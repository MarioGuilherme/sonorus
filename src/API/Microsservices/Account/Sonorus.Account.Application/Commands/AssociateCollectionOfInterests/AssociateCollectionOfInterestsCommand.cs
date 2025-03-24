using MediatR;

namespace Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;

public class AssociateCollectionOfInterestsCommand(long userId, AssociateCollectionOfInterestsInputModel inputModel) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public IEnumerable<InterestInputModel> Interests { get; private set; } = inputModel.Interests;
}