using Sonorus.MarketplaceAPI.Data.Entities;

namespace Sonorus.MarketplaceAPI.Repository.Interfaces;

public interface IProductRepository {
    Task<List<Product>> GetAllProductsAsync();
}