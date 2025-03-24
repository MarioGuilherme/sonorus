using AutoMapper;
using MediatR;
using Sonorus.Marketplace.Application.ViewModels;
using Sonorus.Marketplace.Core.Entities;
using Sonorus.Marketplace.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Marketplace.Application.Queries.GetAllProductsByName;

public class GetAllProductsByNameQueryHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory, IMapper mapper) : IRequestHandler<GetAllProductsByNameQuery, IEnumerable<ProductViewModel>> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<ProductViewModel>> Handle(GetAllProductsByNameQuery request, CancellationToken cancellationToken) {
        IEnumerable<Product> products = await this._unitOfWork.Products.GetAllByNameAsync(request.Name);
        if (!products.Any()) return [];

        IEnumerable<long> userIds = products.Select(product => product.SellerId).Distinct();
        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>(
            $"users?{string.Join('&', userIds.Select(userId => $"id={userId}"))}",
            cancellationToken: cancellationToken
        );

        ICollection<ProductViewModel> mappedProducts = [];
        foreach (Product product in products) {
            UserViewModel? user = users!.FirstOrDefault(user => user.UserId == product.SellerId);
            if (user is null) continue;
            ProductViewModel productViewModel = this._mapper.Map<ProductViewModel>(product);
            productViewModel.Seller = user;
            mappedProducts.Add(productViewModel);
        }

        return mappedProducts;
    }
}