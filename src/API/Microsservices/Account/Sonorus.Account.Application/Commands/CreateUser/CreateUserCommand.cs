using MediatR;
using Sonorus.Account.Application.ViewModels;

namespace Sonorus.Account.Application.Commands.CreateUser;

public class CreateUserCommand(string fullname, string nickname, string email, string password) : IRequest<TokenViewModel> {
    public string Fullname { get; private set; } = fullname;
    public string Nickname { get; private set; } = nickname;
    public string Email { get; private set; } = email;
    public string Password { get; private set; } = password;
}