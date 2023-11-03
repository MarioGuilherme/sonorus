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
}