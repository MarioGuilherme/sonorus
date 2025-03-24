using MediatR;
using Sonorus.Marketplace.Application.ViewModels;

namespace Sonorus.Marketplace.Application.Commands.CreateProduct;

public class CreateProductCommand : CreateProductInputModel, IRequest<ProductViewModel> {
    public long UserId { get; private set; }

    public CreateProductCommand(long userId, CreateProductInputModel inputModel) {
        this.UserId = userId;
        this.Name = inputModel.Name;
        this.Description = inputModel.Description;
        this.Price = inputModel.Price;
        this.Condition = inputModel.Condition;
        this.Medias = inputModel.Medias;
    }
}