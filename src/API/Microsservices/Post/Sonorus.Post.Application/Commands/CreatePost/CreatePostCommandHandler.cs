using AutoMapper;
using Azure.Storage.Blobs;
using MediatR;
using Microsoft.AspNetCore.Http;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Services;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.CreatePost;

public class CreatePostCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage) : IRequestHandler<CreatePostCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;

    public async Task<Unit> Handle(CreatePostCommand request, CancellationToken cancellationToken) {
        Core.Entities.Post post = new(request.UserId, request.Content, request.Tablature);

        foreach (long interestId in request.InterestsIds) post.PostInterests.Add(new(interestId));

        foreach (IFormFile file in request.Medias) {
            string mediaName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            await this._fileStorage.UploadOrUpdateFileAsync(mediaName, file.OpenReadStream());
            post.Medias.Add(new(mediaName));
        }

        await this._unitOfWork.Posts.CreatePostAsync(post);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}