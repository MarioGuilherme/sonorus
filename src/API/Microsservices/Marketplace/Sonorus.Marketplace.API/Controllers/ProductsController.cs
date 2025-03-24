using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.Marketplace.Application.Commands.CreateProduct;
using Sonorus.Marketplace.Application.Commands.DeleteProduct;
using Sonorus.Marketplace.Application.Commands.UpdateProduct;
using Sonorus.Marketplace.Application.Queries.GetAllProductsByName;
using Sonorus.Marketplace.Application.ViewModels;
using Sonorus.SharedKernel;

namespace Sonorus.Marketplace.API.Controllers;

[Authorize]
[ApiController]
[Route("api/v2/products")]
public class ProductsController(IMediator mediator) : ControllerBase {
    private readonly IMediator _mediator = mediator;

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> GetAllWithQuery(string? name = default) {
        GetAllProductsByNameQuery getAllProductsByNameQuery = new(name);
        IEnumerable<ProductViewModel> products = await this._mediator.Send(getAllProductsByNameQuery);
        return this.Ok(products);
    }

    [HttpPost]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> Create(CreateProductInputModel inputModel) {
        CreateProductCommand createProductCommand = new(this.User.UserId(), inputModel);
        ProductViewModel product = await this._mediator.Send(createProductCommand);
        return this.Created(string.Empty, product);
    }

    [HttpPatch("{productId}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> Update(long productId, [FromForm] UpdateProductInputModel inputModel) {
        UpdateProductCommand updateProductCommand = new(this.User.UserId(), productId, inputModel);
        ProductViewModel product = await this._mediator.Send(updateProductCommand);
        return this.Ok(product);
    }

    [HttpDelete("{productId}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<ActionResult> Delete(long productId) {
        DeleteProductCommand deleteProductCommand = new(this.User.UserId(), productId);
        await this._mediator.Send(deleteProductCommand);
        return this.NoContent();
    }
}