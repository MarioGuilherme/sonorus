using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Http;
using Sonorus.Marketplace.Application.ViewModels;
using Sonorus.Marketplace.Core.Entities;
using Sonorus.Marketplace.Core.Services;
using Sonorus.Marketplace.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Marketplace.Application.Commands.CreateProduct;

public class CreateProductCommandHandler(IUnitOfWork unitOfWork, IFileStorage fileStorage, IHttpClientFactory httpClientFactory, IMapper mapper) : IRequestHandler<CreateProductCommand, ProductViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IFileStorage _fileStorage = fileStorage;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<ProductViewModel> Handle(CreateProductCommand request, CancellationToken cancellationToken) {
        Product product = new(request.UserId, request.Name, request.Description, request.Price, request.Condition);

        foreach (IFormFile file in request.Medias) {
            string mediaName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            await this._fileStorage.UploadOrUpdateFileAsync(mediaName, file.OpenReadStream());
            product.Medias.Add(new(mediaName));
        }
        await this._unitOfWork.Products.CreateProductAsync(product);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>(
            $"users?id={request.UserId}",
            cancellationToken: cancellationToken
        );
        ProductViewModel productViewModel = this._mapper.Map<ProductViewModel>(product);
        productViewModel.Seller = users!.First();

        return productViewModel;
    }
}