using MediatR;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application.Queries.GetAllInterests;

public class GetAllInterestsQuery : IRequest<IEnumerable<InterestViewModel>> { }