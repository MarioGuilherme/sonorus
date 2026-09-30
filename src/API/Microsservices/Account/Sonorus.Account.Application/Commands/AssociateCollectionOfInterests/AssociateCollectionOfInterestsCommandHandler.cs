using AutoMapper;
using MediatR;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;

public class AssociateCollectionOfInterestsCommandHandler(IMapper mapper, ICacheService cacheService, IUnitOfWork unitOfWork) : IRequestHandler<AssociateCollectionOfInterestsCommand, Unit> {
    private readonly IMapper _mapper = mapper;
    private readonly ICacheService _cacheService = cacheService;
    private readonly IUnitOfWork _unitOfWork = unitOfWork;

    public async Task<Unit> Handle(AssociateCollectionOfInterestsCommand request, CancellationToken cancellationToken) {
        User user = await _unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();
        IEnumerable<Interest> interests = _mapper.Map<IEnumerable<Interest>>(request.Interests);

        user.Interests.Clear();
        foreach (Interest interest in interests) {
            Interest? interestDb = await _unitOfWork.Interests.GetByIdTrackingAsync(interest.InterestId);

            if (interestDb is not null) {
                user.Interests.Add(interestDb);
                continue;
            }

            interestDb = await _unitOfWork.Interests.GetByKeyTrackingAsync(interest.Key);

            if (interestDb is not null) {
                user.Interests.Add(interestDb);
                continue;
            }

            await _unitOfWork.Interests.AddAsync(interest);
            await _unitOfWork.CompleteAsync();
            user.Interests.Add(interest);
        }

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        _cacheService.SetInterests(await _unitOfWork.Interests.GetAllAsync());

        return Unit.Value;
    }
}