using MediatR;
using Sonorus.Marketplace.Application.ViewModels;

namespace Sonorus.Marketplace.Application.Commands.UpdateProduct;

public class UpdateProductCommand : UpdateProductInputModel, IRequest<ProductViewModel> {
    public long UserId { get; private set; }
    public long ProductId { get; private set; }

    public UpdateProductCommand(long userId, long productId, UpdateProductInputModel inputModel) {
        this.UserId = userId;
        this.ProductId = productId;
        this.Name = inputModel.Name;
        this.Description = inputModel.Description;
        this.Price = inputModel.Price;
        this.Condition = inputModel.Condition;
        this.NewMedias = inputModel.NewMedias;
        this.MediasToRemove = inputModel.MediasToRemove;
    }
}