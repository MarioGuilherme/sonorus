using MediatR;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application.Queries.GetUserByLogin;

public class GetUserByLoginQuery(string login, string password) : IRequest<TokenViewModel> {
    public string Login { get; private set; } = login;
    public string Password { get; private set; } = password;
}