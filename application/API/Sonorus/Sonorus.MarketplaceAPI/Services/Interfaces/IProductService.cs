using Sonorus.MarketplaceAPI.DTO;

namespace Sonorus.MarketplaceAPI.Services.Interfaces;

public interface IProductService {
    Task<List<ProductDTO>> GetAllProductsAsync();
}