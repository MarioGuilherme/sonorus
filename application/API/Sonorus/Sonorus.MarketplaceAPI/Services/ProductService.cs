using AutoMapper;
using Sonorus.MarketplaceAPI.Data.Entities;
using Sonorus.MarketplaceAPI.DTO;
using Sonorus.MarketplaceAPI.Models;
using Sonorus.MarketplaceAPI.Repository.Interfaces;
using Sonorus.MarketplaceAPI.Services.Interfaces;
using System.Text.Json;

namespace Sonorus.MarketplaceAPI.Services;

public class ProductService : IProductService {
    private readonly HttpClient _httpClient;
    private readonly IProductRepository _productRepository;
    private readonly IMapper _mapper;

    public ProductService(HttpClient httpClient, IProductRepository productRepository, IMapper mapper) {
        this._httpClient = httpClient;
        this._productRepository = productRepository;
        this._mapper = mapper;
    }

    public async Task<List<ProductDTO>> GetAllProductsAsync() {
        List<Product> products = await this._productRepository.GetAllProductsAsync();
        List<long> idsUsers = products.Select(product => product.SellerId).Distinct().ToList();

        this._httpClient.DefaultRequestHeaders.Add("UserIds", JsonSerializer.Serialize(idsUsers));
        RestResponse<List<UserDTO>> responseUsers = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users/"))!;

        List<ProductDTO> mappedProducts = this._mapper.Map<List<Product>, List<ProductDTO>>(products,
            options => options.AfterMap((products, productsDTO) => {
                for (int i = 0; i < products.Count; i++)
                    productsDTO[i].Seller = responseUsers.Data!.First(user => user.UserId == products.First(p => p.SellerId == user.UserId).SellerId);
            })
        );

        return mappedProducts;
    }
}