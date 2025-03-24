using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Http;
using Sonorus.Marketplace.Application.ViewModels;
using Sonorus.Marketplace.Core.Entities;
using Sonorus.Marketplace.Core.Exceptions;
using Sonorus.Marketplace.Core.Services;
using Sonorus.Marketplace.Infrastructure.Persistence;
using System.Net.Http.Json;

namespace Sonorus.Marketplace.Application.Commands.UpdateProduct;

public class UpdateProductCommandHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory, IFileStorage fileStorage, IMapper mapper) : IRequestHandler<UpdateProductCommand, ProductViewModel> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IFileStorage _fileStorage = fileStorage;
    private readonly IMapper _mapper = mapper;

    public async Task<ProductViewModel> Handle(UpdateProductCommand request, CancellationToken cancellationToken) {
        Product productDb = await this._unitOfWork.Products.GetByIdTrackingAsync(request.ProductId) ?? throw new ProductNotFoundException();

        if (productDb.SellerId != request.UserId) throw new AuthenticatedUserAreNotOwnerOfProductException();

        foreach (IFormFile file in request.NewMedias) {
            string mediaName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            await this._fileStorage.UploadOrUpdateFileAsync(mediaName, file.OpenReadStream());
            productDb.Medias.Add(new(mediaName));
        }

        IEnumerable<Media> mediasToRemove = productDb.Medias.Where(media => request.MediasToRemove.Contains(media.MediaId));
        foreach (Media media in mediasToRemove) await this._fileStorage.DeleteFileAsync(Path.GetFileName(media.Path));

        productDb.Update(request.Name, request.Price, request.Description, request.Condition);
        this._unitOfWork.Products.Update(productDb, mediasToRemove);

        await this._unitOfWork.BeginTransactionAsync();
        await this._unitOfWork.CompleteAsync();
        await this._unitOfWork.CommitAsync();

        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        IEnumerable<UserViewModel>? users = await userMShttpClient.GetFromJsonAsync<IEnumerable<UserViewModel>>($"users?id={request.UserId}", cancellationToken: cancellationToken);

        ProductViewModel productViewModel = this._mapper.Map<ProductViewModel>(productDb);
        productViewModel.Seller = users!.First();

        return productViewModel;
    }
}