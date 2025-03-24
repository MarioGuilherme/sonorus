using Sonorus.Marketplace.Core.Entities;

namespace Sonorus.Marketplace.Core.Repositories;

public interface IProductRepository {
    Task CreateProductAsync(Product product);
    void Delete(Product product);
    IEnumerable<string> DeleteAllFromUserId(long userId);
    Task<List<Product>> GetAllByNameAsync(string? name = default);
    Task<Product?> GetByIdAsync(long productId);
    Task<Product?> GetByIdTrackingAsync(long productId);
    void Update(Product productForm, IEnumerable<Media> mediasToRemove);
}