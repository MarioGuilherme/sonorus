using MediatR;
using Microsoft.AspNetCore.Http;
using Sonorus.Marketplace.Application.ViewModels;
using Sonorus.Marketplace.Core.Entities;
using Sonorus.Marketplace.Core.Services;
using Sonorus.Marketplace.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Marketplace.Application.Commands.CreateProduct;

public class CreateProductCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage, IHttpClientFactory httpClientFactory) : IRequestHandler<CreateProductCommand, ProductViewModel>
{
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;

    public async Task<ProductViewModel> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        Product product = new(request.UserId, request.Name, request.Description, request.Price, request.Condition);

        foreach (IFormFile file in request.Medias)
        {
            string mediaName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            await _fileStorage.UploadOrUpdateFileAsync(mediaName, file.OpenReadStream());
            product.Medias.Add(new(mediaName));
        }
        await _unitOfWork.Products.CreateProductAsync(product);

        await _unitOfWork.BeginTransactionAsync();
        await _unitOfWork.CompleteAsync();
        await _unitOfWork.CommitAsync();

        using HttpClient userMShttpClient = _httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>(
            $"users?id={request.UserId}",
            cancellationToken: cancellationToken
        );
        ProductViewModel productViewModel = new(product.ProductId,
            product.Name,
            product.Price,
            product.Description,
            product.Condition,
            product.AnnouncedAt,
            product.Medias.Select(m => new MediaViewModel(m.MediaId, m.Path)))
        {
            Seller = users!.First()
        };

        return productViewModel;
    }
}