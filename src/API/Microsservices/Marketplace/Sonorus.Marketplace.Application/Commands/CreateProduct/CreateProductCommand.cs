using MediatR;
using Sonorus.Marketplace.Application.ViewModels;

namespace Sonorus.Marketplace.Application.Commands.CreateProduct;

public class CreateProductCommand : CreateProductInputModel, IRequest<ProductViewModel> {
    public long UserId { get; private set; }

    public CreateProductCommand(long userId, CreateProductInputModel inputModel) {
        UserId = userId;
        Name = inputModel.Name;
        Description = inputModel.Description;
        Price = inputModel.Price;
        Condition = inputModel.Condition;
        Medias = inputModel.Medias;
    }
}