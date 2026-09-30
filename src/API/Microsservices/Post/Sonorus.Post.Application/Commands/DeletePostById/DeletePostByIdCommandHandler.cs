using MediatR;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Core.Exceptions;
using Sonorus.Post.Core.Services;
using Sonorus.Post.Infrastructure.Persistence;

namespace Sonorus.Post.Application.Commands.DeletePostById;

public class DeletePostByIdCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage) : IRequestHandler<DeletePostByIdCommand, Unit>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;

    public async Task<Unit> Handle(DeletePostByIdCommand request, CancellationToken cancellationToken)
    {
        Core.Entities.Post post = await _unitOfWork.Posts.GetByIdWithFullDataTrackingAsync(request.PostId) ?? throw new PostNotFoundException();

        if (post.UserId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfPostException();

        await _unitOfWork.BeginTransactionAsync();

        _unitOfWork.Posts.Delete(post);
        foreach (Media item in post.Medias)
            await _fileStorage.DeleteFileAsync(Path.GetFileName(item.Path));

        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        return Unit.Value;
    }
}