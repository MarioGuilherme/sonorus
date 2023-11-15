using Sonorus.MarketplaceAPI.Data.Entities;
using Sonorus.MarketplaceAPI.DTO;

namespace Sonorus.MarketplaceAPI.Services.Interfaces;

public interface IProductService {
    Task<List<ProductDTO>> GetAllProductsAsync();

    Task<List<ProductDTO>> GetAllProductsByNameAsync(string name);

    Task<List<ProductDTO>> GetAllProductsByUserIdAsync(long userId);

    Task DeleteAllFromUserId(long userId);

    Task<ProductDTO> CreateProductAsync(long userId, NewProductDTO product, List<IFormFile> medias);

    Task UpdateProductAsync(long userId, NewProductDTO product, List<IFormFile> medias);

    Task DeleteProductByIdAsync(long userId, long productId);
}