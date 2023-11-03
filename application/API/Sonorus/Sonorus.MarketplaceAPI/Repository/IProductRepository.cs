using Microsoft.EntityFrameworkCore;
using Sonorus.MarketplaceAPI.Data.Context;
using Sonorus.MarketplaceAPI.Data.Entities;
using Sonorus.MarketplaceAPI.Repository.Interfaces;

namespace Sonorus.MarketplaceAPI.Repository;

public class ProductRepository : IProductRepository {
    private readonly MarketplaceAPIDbContext _dbContext;

    public ProductRepository(MarketplaceAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task<List<Product>> GetAllProductsAsync() => await this._dbContext.Products
        .AsNoTracking()
        .Include(product => product.Medias)
        .ToListAsync();
}