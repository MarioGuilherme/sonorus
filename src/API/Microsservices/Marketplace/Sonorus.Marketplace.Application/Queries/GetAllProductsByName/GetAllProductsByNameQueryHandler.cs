using MediatR;
using Sonorus.Marketplace.Application.ViewModels;
using Sonorus.Marketplace.Core.Entities;
using Sonorus.Marketplace.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Marketplace.Application.Queries.GetAllProductsByName;

public class GetAllProductsByNameQueryHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory) : IRequestHandler<GetAllProductsByNameQuery, IEnumerable<ProductViewModel>>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;

    public async Task<IEnumerable<ProductViewModel>> Handle(GetAllProductsByNameQuery request, CancellationToken cancellationToken)
    {
        IEnumerable<Product> products = await _unitOfWork.Products.GetAllByNameAsync(request.Name);
        if (!products.Any()) return [];

        IEnumerable<long> userIds = products.Select(product => product.SellerId).Distinct();
        using HttpClient userMShttpClient = _httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>(
            $"users?{string.Join('&', userIds.Select(userId => $"id={userId}"))}",
            cancellationToken: cancellationToken
        );

        ICollection<ProductViewModel> mappedProducts = [];
        foreach (Product product in products)
        {
            UserViewModel? user = users!.FirstOrDefault(user => user.UserId == product.SellerId);
            if (user is null) continue;
            ProductViewModel productViewModel = new(product.ProductId,
                product.Name,
                product.Price,
                product.Description,
                product.Condition,
                product.AnnouncedAt,
                product.Medias.Select(m => new MediaViewModel(m.MediaId, m.Path)))
            {
                Seller = user
            };

            mappedProducts.Add(productViewModel);
        }

        return mappedProducts;
    }
}