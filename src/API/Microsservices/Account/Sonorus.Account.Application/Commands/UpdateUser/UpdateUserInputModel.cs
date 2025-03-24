namespace Sonorus.Account.Application.Commands.UpdateUser;

public class UpdateUserInputModel(string fullname, string nickname, string email) {
    public string Fullname { get; private set; } = fullname;
    public string Nickname { get; private set; } = nickname;
    public string Email { get; private set; } = email;
}