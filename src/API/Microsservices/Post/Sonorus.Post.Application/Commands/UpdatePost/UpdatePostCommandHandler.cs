using MediatR;
using Microsoft.AspNetCore.Http;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Core.Services;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.UpdatePost;

public class UpdatePostCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage) : IRequestHandler<UpdatePostCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;

    public async Task<Unit> Handle(UpdatePostCommand request, CancellationToken cancellationToken) {
        Core.Entities.Post postDb = await this._unitOfWork.Posts.GetByIdWithFullDataTrackingAsync(request.PostId) ?? throw new PostNotFoundException();

        foreach (IFormFile file in request.NewMedias) {
            string mediaName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            await this._fileStorage.UploadOrUpdateFileAsync(mediaName, file.OpenReadStream());
            postDb.Medias.Add(new(mediaName));
        }

        IEnumerable<Media> mediasToRemove = postDb.Medias.Where(media => request.MediasToRemove.Contains(media.MediaId));
        foreach (Media media in mediasToRemove) await this._fileStorage.DeleteFileAsync(Path.GetFileName(media.Path));

        postDb.PostInterests.Clear();
        foreach (long interestId in request.InterestsIds) postDb.PostInterests.Add(new(interestId));

        postDb.Update(request.Content, request.Tablature);
        this._unitOfWork.Posts.UpdatePost(postDb, mediasToRemove);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}