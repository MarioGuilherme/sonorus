using MediatR;
using Sonorus.Account.Core.Entities;
using Sonorus.Account.Core.Exceptions;
using Sonorus.Account.Core.Services;
using Sonorus.Account.Infrastructure.Persistence;

namespace Sonorus.Account.Application.Commands.UpdatePicture;

public class UpdatePictureCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage) : IRequestHandler<UpdatePictureCommand, string> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;

    public async Task<string> Handle(UpdatePictureCommand request, CancellationToken cancellationToken) {
        User user = await this._unitOfWork.Users.GetByIdTrackingAsync(request.UserId) ?? throw new AuthenticatedUserNoLongerExistException();

        if (Path.GetFileName(user.Picture) == "defaultPicture.png") {
            string fileName = $"{Guid.NewGuid()}{Path.GetExtension(request.Picture.FileName)}";
            user.UpdatePicture(fileName);

            await this._unitOfWork.BeginTransactionAsync();
            await this._unitOfWork.CompleteAsync();
            await this._unitOfWork.CommitAsync();
        }

        await this._fileStorage.UploadOrUpdateFileAsync(Path.GetFileName(user.Picture), request.Picture.OpenReadStream());
        return user.Picture;
    }
}