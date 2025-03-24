using MediatR;
using Sonorus.Marketplace.Application.ViewModels;

namespace Sonorus.Marketplace.Application.Queries.GetAllProductsByName;

public class GetAllProductsByNameQuery(string? name = default) : IRequest<IEnumerable<ProductViewModel>> {
    public string? Name { get; private set; } = name;
}