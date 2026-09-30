using MediatR;
using Sonorus.Marketplace.Application.ViewModels;

namespace Sonorus.Marketplace.Application.Commands.UpdateProduct;

public class UpdateProductCommand : UpdateProductInputModel, IRequest<ProductViewModel> {
    public long UserId { get; private set; }
    public long ProductId { get; private set; }

    public UpdateProductCommand(long userId, long productId, UpdateProductInputModel inputModel) {
        UserId = userId;
        ProductId = productId;
        Name = inputModel.Name;
        Description = inputModel.Description;
        Price = inputModel.Price;
        Condition = inputModel.Condition;
        NewMedias = inputModel.NewMedias;
        MediasToRemove = inputModel.MediasToRemove;
    }
}