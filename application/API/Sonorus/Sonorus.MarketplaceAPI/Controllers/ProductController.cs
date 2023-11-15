using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.MarketplaceAPI.Core;
using Sonorus.MarketplaceAPI.DTO;
using Sonorus.MarketplaceAPI.Exceptions;
using Sonorus.MarketplaceAPI.Models;
using Sonorus.MarketplaceAPI.Services.Interfaces;

namespace Sonorus.MarketplaceAPI.Controllers;

[ApiController]
[Route("api/v1/products")]
public class ProductController : APIControllerBase {
    private readonly IProductService _productService;

    public ProductController(IProductService productService) => this._productService = productService;

    [Authorize]
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<ProductDTO>))]
    public async Task<ActionResult<RestResponse<ProductDTO>>> CreateProduct([FromForm] NewProductDTO product, IEnumerable<IFormFile> medias) {
        RestResponse<ProductDTO> response = new();
        try {
            response.Data = await this._productService.CreateProductAsync((long)this.CurrentUser!.UserId!, product, medias.ToList());
            return this.Ok(response);
        } catch (SonorusMarketplaceAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpPatch]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<object>>> UpdateProduct([FromForm] NewProductDTO product, IEnumerable<IFormFile> medias) {
        RestResponse<object> response = new();
        try {
            await this._productService.UpdateProductAsync((long)this.CurrentUser!.UserId!, product, medias.ToList());
            return this.NoContent();
        } catch (SonorusMarketplaceAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpDelete("{productId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<ProductDTO>>> DeleteProduct(long productId) {
        RestResponse<object> response = new();
        try {
            await this._productService.DeleteProductByIdAsync((long)this.CurrentUser!.UserId!, productId);
            return this.NoContent();
        } catch (SonorusMarketplaceAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<ProductDTO>>))]
    public async Task<ActionResult<RestResponse<List<ProductDTO>>>> GetAllProducts() {
        RestResponse<List<ProductDTO>> response = new();
        try {
            response.Data = await this._productService.GetAllProductsAsync();
            return this.Ok(response);
        } catch (SonorusMarketplaceAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [HttpGet("{name}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<ProductDTO>>))]
    public async Task<ActionResult<RestResponse<List<ProductDTO>>>> GetAllProductsByName(string name) {
        RestResponse<List<ProductDTO>> response = new();
        try {
            response.Data = await this._productService.GetAllProductsByNameAsync(name);
            return this.Ok(response);
        } catch (SonorusMarketplaceAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpDelete]
    public async Task<ActionResult<RestResponse<object>>> DeleteAllFromUserId() {
        RestResponse<object> response = new();
        try {
            await this._productService.DeleteAllFromUserId((long)this.CurrentUser!.UserId!);
            return this.NoContent();
        } catch (SonorusMarketplaceAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}