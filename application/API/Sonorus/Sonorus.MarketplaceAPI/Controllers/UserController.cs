using Microsoft.AspNetCore.Mvc;
using Sonorus.MarketplaceAPI.Core;
using Sonorus.MarketplaceAPI.DTO;
using Sonorus.MarketplaceAPI.Exceptions;
using Sonorus.MarketplaceAPI.Models;
using Sonorus.MarketplaceAPI.Services.Interfaces;

namespace Sonorus.MarketplaceAPI.Controllers;

[ApiController]
[Route("api/v1/users")]
public class UserController : APIControllerBase {
    private readonly IProductService _productService;

    public UserController(IProductService productService) => this._productService = productService;

    [HttpGet("{userId}/products")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<ProductDTO>>))]
    public async Task<ActionResult<RestResponse<List<ProductDTO>>>> GetAllProductsByUserId(long userId) {
        RestResponse<List<ProductDTO>> response = new();
        try {
            response.Data = await this._productService.GetAllProductsByUserIdAsync(userId);
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