using MediatR;
using Sonorus.Marketplace.Core.Entities;
using Sonorus.Marketplace.Core.Exceptions;
using Sonorus.Marketplace.Core.Services;
using Sonorus.Marketplace.Infrastructure.Persistence;

namespace Sonorus.Marketplace.Application.Commands.DeleteProduct;

public class DeleteProductCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage) : IRequestHandler<DeleteProductCommand, Unit> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;

    public async Task<Unit> Handle(DeleteProductCommand request, CancellationToken cancellationToken) {
        Product product = await this._unitOfWork.Products.GetByIdTrackingAsync(request.ProductId) ?? throw new ProductNotFoundException();

        if (product.SellerId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfProductException();

        this._unitOfWork.Products.Delete(product);
        foreach (Media media in product.Medias) await this._fileStorage.DeleteFileAsync(Path.GetFileName(media.Path));

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        return Unit.Value;
    }
}