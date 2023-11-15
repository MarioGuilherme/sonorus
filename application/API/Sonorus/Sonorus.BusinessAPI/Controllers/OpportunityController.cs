using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sonorus.BusinessAPI.Core;
using Sonorus.BusinessAPI.DTO;
using Sonorus.BusinessAPI.Exceptions;
using Sonorus.BusinessAPI.Models;
using Sonorus.BusinessAPI.Services.Interfaces;

namespace Sonorus.BusinessAPI.Controllers;

[ApiController]
[Route("api/v1/opportunities")]
public class OpportunityController : APIControllerBase {
    private readonly IOpportunityService _opportunityService;

    public OpportunityController(IOpportunityService opportunityService) => this._opportunityService = opportunityService;

    [HttpGet]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<List<OpportunityDTO>>))]
    [ProducesResponseType(StatusCodes.Status404NotFound, Type = typeof(RestResponse<List<OpportunityDTO>>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<List<OpportunityDTO>>))]
    public async Task<ActionResult<RestResponse<List<OpportunityDTO>>>> GetAll() {
        RestResponse<List<OpportunityDTO>> response = new();
        try {
            response.Data = await this._opportunityService.GetAllAsync();
            return this.Ok(response);
        } catch (SonorusBusinessAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpPost]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<OpportunityDTO>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<OpportunityDTO>))]
    public async Task<ActionResult<RestResponse<OpportunityDTO>>> Create(OpportunityRegisterDTO opportunityRegister) {
        RestResponse<OpportunityDTO> response = new();
        try {
            response.Data = await this._opportunityService.CreateAsync((long)this.CurrentUser!.UserId!, opportunityRegister);
            return this.Created(string.Empty, response);
        } catch (SonorusBusinessAPIException exception) {
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
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<object>>> Update(OpportunityRegisterDTO opportunityRegister) {
        RestResponse<object> response = new();
        try {
            await this._opportunityService.UpdateAsync((long)this.CurrentUser!.UserId!, opportunityRegister);
            return this.NoContent();
        } catch (SonorusBusinessAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }

    [Authorize]
    [HttpDelete("{opportunityId}")]
    [Produces("application/json")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status404NotFound, Type = typeof(RestResponse<object>))]
    [ProducesResponseType(StatusCodes.Status500InternalServerError, Type = typeof(RestResponse<object>))]
    public async Task<ActionResult<RestResponse<object>>> DeletepportunityById(long opportunityId) {
        RestResponse<object> response = new();
        try {
            await this._opportunityService.DeleteOpportunityByIdAsync((long)this.CurrentUser!.UserId!, opportunityId);
            return this.NoContent();
        } catch (SonorusBusinessAPIException exception) {
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
    public async Task<ActionResult<RestResponse<object>>> DeleteAllFromuserId() {
        RestResponse<object> response = new();
        try {
            await this._opportunityService.DeleteAllFromuserId((long)this.CurrentUser!.UserId!);
            return this.NoContent();
        } catch (SonorusBusinessAPIException exception) {
            response.Message = exception.Message;
            response.Errors = exception.Errors;
            return this.StatusCode(exception.StatusCode, response);
        } catch (Exception error) {
            response.Message = "Ocorreu um erro interno na aplicação, por favor, tente novamente mais tarde";
            return this.StatusCode(500, response);
        }
    }
}