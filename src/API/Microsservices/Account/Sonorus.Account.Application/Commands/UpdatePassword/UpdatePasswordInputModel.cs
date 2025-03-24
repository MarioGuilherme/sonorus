namespace Sonorus.Account.Application.Commands.UpdatePassword;

public class UpdatePasswordInputModel(string password) {
    public string Password { get; private set; } = password;
}