using Microsoft.EntityFrameworkCore;
using Sonorus.Marketplace.Core.Entities;
using Sonorus.Marketplace.Core.Repositories;

namespace Sonorus.Marketplace.Infrastructure.Persistence.Repositories;

public class ProductRepository(SonorusMarketplaceDbContext dbContext) : IProductRepository {
    private readonly SonorusMarketplaceDbContext _dbContext = dbContext;

    public async Task CreateProductAsync(Product product) {
        await _dbContext.Products.AddAsync(product);
    }

    public void Delete(Product product) {
        _dbContext.Medias.RemoveRange(product.Medias);
        _dbContext.Products.Remove(product);
    }

    public IEnumerable<string> DeleteAllFromUserId(long userId) {
        IQueryable<Product> products = _dbContext.Products.Where(product => product.SellerId == userId);

        _dbContext.Medias.RemoveRange(products.SelectMany(product => product.Medias));
        _dbContext.Products.RemoveRange(products);

        return products.SelectMany(product => product.Medias.Select(m => m.Path));
    }

    public Task<List<Product>> GetAllByNameAsync(string? name = default) => _dbContext.Products
        .AsNoTracking()
        .Where(product => name == null || (name != null && product.Name.Contains(name)))
        .Include(product => product.Medias)
        .ToListAsync();

    public Task<Product?> GetByIdAsync(long productId) => _dbContext.Products
        .AsNoTracking()
        .Include(product => product.Medias)
        .FirstOrDefaultAsync(product => product.ProductId == productId);

    public Task<Product?> GetByIdTrackingAsync(long productId) => _dbContext.Products
        .Include(product => product.Medias)
        .FirstOrDefaultAsync(product => product.ProductId == productId);

    public void Update(Product productForm, IEnumerable<Media> mediasToRemove) => _dbContext.Medias.RemoveRange(mediasToRemove);
}