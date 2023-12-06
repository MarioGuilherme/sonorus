using Microsoft.EntityFrameworkCore;
using Sonorus.MarketplaceAPI.Data.Context;
using Sonorus.MarketplaceAPI.Data.Entities;
using Sonorus.MarketplaceAPI.Exceptions;
using Sonorus.MarketplaceAPI.Repository.Interfaces;
using System.Threading.Tasks;

namespace Sonorus.MarketplaceAPI.Repository;

public class ProductRepository : IProductRepository {
    private readonly MarketplaceAPIDbContext _dbContext;

    public ProductRepository(MarketplaceAPIDbContext dbContext) => this._dbContext = dbContext;

    public async Task CreateProductAsync(Product product, List<string> mediasName) {
        await this._dbContext.Products.AddAsync(product);
        await this._dbContext.SaveChangesAsync();
        foreach (string path in mediasName) {
            product.Medias.Add(new() {
                Path = path
            });
        }
        await this._dbContext.SaveChangesAsync();
    }

    public async Task<List<string>> DeleteAllFromUserId(long userId) {
        List<Product> products = await this._dbContext.Products
            .Where(product => product.SellerId == userId)
            .Include(product => product.Medias)
            .ToListAsync();
        List<string> productsMediasPath = new();

        foreach (var item in products) {
            productsMediasPath.AddRange(item.Medias.Select(m => m.Path).ToList());
            this._dbContext.Medias.RemoveRange(item.Medias);
        }
        this._dbContext.Products.RemoveRange(products);

        await this._dbContext.SaveChangesAsync();
        return productsMediasPath;
    }

    public async Task<List<string>> DeleteProductByIdAsync(long userId, long productId) {
        Product product = await this._dbContext.Products
            .Include(product => product.Medias)
            .FirstAsync(product => product.ProductId == productId);
        List<string> productsMediasPath = product.Medias.Select(m => m.Path).ToList();

        if (product.SellerId != userId)
            throw new SonorusMarketplaceAPIException("Este anúncio não pertence à você", 403);

        this._dbContext.Medias.RemoveRange(product.Medias);
        this._dbContext.Products.Remove(product);
        await this._dbContext.SaveChangesAsync();
        return productsMediasPath;
    }

    public async Task<List<Product>> GetAllProductsAsync() {
        List<Product> products = await this._dbContext.Products
            .AsNoTracking()
            .Include(product => product.Medias)
            .ToListAsync();

        return products;
    }

    public async Task<List<Product>> GetAllProductsByNameAsync(string name) {
        List<Product> products = await this._dbContext.Products
            .AsNoTracking()
            .Where(product => product.Name.Contains(name))
            .Include(product => product.Medias)
            .ToListAsync();

        return products;
    }

    public async Task<List<Product>> GetAllProductsByUserIdAsync(long userId) {
        List<Product> products = await this._dbContext.Products
            .AsNoTracking()
            .Where(product => product.SellerId == userId)
            .Include(product => product.Medias)
            .ToListAsync();

        products.ForEach(product => {
            product.Medias.Add(this._dbContext.Medias.AsNoTracking().First(media => media.Product.ProductId == product.ProductId));
        });

        return products;
    }

    public async Task<List<string>> UpdateByProductIdAsync(Product productForm, List<string> mediasName, List<string> mediasToKeep) {
        Product productDB = await this._dbContext.Products
            .Include(p => p.Medias)
            .FirstAsync(product => product.ProductId == productForm.ProductId);
        List<string> mediasToRemove = productDB.Medias
            .Select(m => m.Path)
            .ToList();

        productDB.Condition = productForm.Condition;
        productDB.Name = productForm.Name;
        productDB.Description = productForm.Description;
        productDB.Price = productForm.Price;

        foreach (var media in productDB.Medias) {
            if (mediasToKeep.Contains(media.Path)) {
                mediasToRemove.Remove(media.Path);
                continue;
            }
            this._dbContext.Medias.Remove(media);
        }

        foreach (string path in mediasName) {
            productDB.Medias.Add(new() {
                Path = path
            });
        }

        await _dbContext.SaveChangesAsync();
        return mediasToRemove;
    }
}