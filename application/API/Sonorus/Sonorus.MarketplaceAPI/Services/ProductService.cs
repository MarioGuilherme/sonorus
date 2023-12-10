using AutoMapper;
using Azure.Storage.Blobs;
using Sonorus.MarketplaceAPI.Data.Entities;
using Sonorus.MarketplaceAPI.DTO;
using Sonorus.MarketplaceAPI.Models;
using Sonorus.MarketplaceAPI.Repository.Interfaces;
using Sonorus.MarketplaceAPI.Services.Interfaces;
using System.Net.Http.Json;
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

    public async Task<ProductDTO> CreateProductAsync(long userId, NewProductDTO product, List<IFormFile> medias) {
        Product mappedProduct = this._mapper.Map<Product>(product);
        mappedProduct.SellerId = userId;
        List<string> mediasName = new();

        foreach (IFormFile file in medias) {
            string mediaName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, mediaName);
            await blobClient.UploadAsync(file.OpenReadStream());
            mediasName.Add(mediaName);
        }

        await this._productRepository.CreateProductAsync(mappedProduct, mediasName);
        ProductDTO productCreated = this._mapper.Map<ProductDTO>(mappedProduct);

        this._httpClient.DefaultRequestHeaders.Add("userIds", mappedProduct.SellerId.ToString());
        productCreated.Seller = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users"))!.Data!.First();

        return productCreated;
    }

    public async Task UpdateProductAsync(long userId, NewProductDTO product, List<IFormFile> medias) {
        Product mappedProduct = this._mapper.Map<Product>(product);
        mappedProduct.SellerId = userId;
        List<string> mediasName = new();

        foreach (IFormFile file in medias) {
            string mediaName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, mediaName);
            await blobClient.UploadAsync(file.OpenReadStream());
            mediasName.Add(mediaName);
        }

        List<string> oldMedias = await this._productRepository.UpdateByProductIdAsync(mappedProduct, mediasName, product.MediasToKeep);

        foreach (var item in oldMedias) {
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, item.Split("/")[4]);
            await blobClient.DeleteAsync();
        }
    }

    public async Task<List<ProductDTO>> GetAllProductsAsync() {
        List<Product> products = await this._productRepository.GetAllProductsAsync();

        if (!products.Any())
            return new();

        List<long> userIds = products.Select(product => product.SellerId).Distinct().ToList();

        this._httpClient.DefaultRequestHeaders.Add("userIds", string.Join(",", userIds));
        RestResponse<List<UserDTO>> responseUsers = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users/"))!;

        List<ProductDTO> mappedProducts = this._mapper.Map<List<Product>, List<ProductDTO>>(products,
            options => options.AfterMap((products, productsDTO) => {
                for (int i = 0; i < products.Count; i++)
                    productsDTO[i].Seller = new() { UserId = products[i].SellerId };
            })
        );

        mappedProducts.ForEach(opportunityMapped => {
            opportunityMapped.Seller = responseUsers!.Data!.First(user => opportunityMapped.Seller.UserId == user.UserId);
        });

        return mappedProducts;
    }

    public async Task DeleteAllFromUserId(long userId) {
        List<string> mediasPath = await this._productRepository.DeleteAllFromUserId(userId);

        foreach (var item in mediasPath) {
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, item.Split("/")[4]);
            await blobClient.DeleteAsync();
        }
    }

    public async Task<List<ProductDTO>> GetAllProductsByUserIdAsync(long userId) {
        List<Product> products = await this._productRepository.GetAllProductsByUserIdAsync(userId);
        return this._mapper.Map<List<ProductDTO>>(products);
    }

    public async Task<List<ProductDTO>> GetAllProductsByNameAsync(string name) {
        List<Product> products = await this._productRepository.GetAllProductsByNameAsync(name);
        if (products.Count == 0)
            return new();
        List<long> userIds = products.Select(product => product.SellerId).Distinct().ToList();

        this._httpClient.DefaultRequestHeaders.Add("userIds", string.Join(",", userIds));
        RestResponse<List<UserDTO>> responseUsers = (await this._httpClient.GetFromJsonAsync<RestResponse<List<UserDTO>>>("api/v1/users/"))!;

        List<ProductDTO> mappedProducts = this._mapper.Map<List<Product>, List<ProductDTO>>(products,
            options => options.AfterMap((products, productsDTO) => {
                for (int i = 0; i < products.Count; i++)
                    productsDTO[i].Seller = responseUsers.Data!.First(user => user.UserId == products.First(p => p.SellerId == user.UserId).SellerId);
            })
        );

        return mappedProducts;
    }

    public async Task DeleteProductByIdAsync(long userId, long productId) {
        List<string> mediaNames = await this._productRepository.DeleteProductByIdAsync(userId, productId);

        foreach (var item in mediaNames) {
            BlobClient blobClient = new(Environment.GetEnvironmentVariable("StorageConnectionString")!, Environment.GetEnvironmentVariable("StorageContainer")!, item.Split("/")[4]);
            await blobClient.DeleteAsync();
        }
    }
}