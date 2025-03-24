using MediatR;

namespace Sonorus.Marketplace.Application.Commands.DeleteProduct;

public class DeleteProductCommand(long userId, long productId) : IRequest<Unit> {
    public long UserId { get; private set; } = userId;
    public long ProductId { get; private set; } = productId;
}