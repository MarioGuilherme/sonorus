using MediatR;
using Sonorus.Business.Application.ViewModels;

namespace Sonorus.Business.Application.Queries.GetAllOpportunitiesByName;

public class GetAllOpportunitiesByNameQuery(string? name) : IRequest<IEnumerable<OpportunityViewModel>> {
    public string? Name { get; private set; } = name;
}