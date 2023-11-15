using Sonorus.MarketplaceAPI.Data.Entities;
using System.Threading.Tasks;

namespace Sonorus.MarketplaceAPI.Repository.Interfaces;

public interface IProductRepository {
    Task<List<Product>> GetAllProductsAsync();

    Task CreateProductAsync(Product product, List<string> mediasName);

    Task<List<Product>> GetAllProductsByNameAsync(string name);

    Task<List<Product>> GetAllProductsByUserIdAsync(long userId);

    Task<List<string>> DeleteAllFromUserId(long userId);

    Task<List<string>> DeleteProductByIdAsync(long userId, long productId);

    Task<List<string>> UpdateByProductIdAsync(Product productForm, List<string> mediasName, List<string> mediasToKeep);
}