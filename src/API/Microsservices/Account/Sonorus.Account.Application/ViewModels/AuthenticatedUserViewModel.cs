namespace Sonorus.Account.Application.ViewModels;

public record AuthenticatedUserViewModel(long UserId, string Fullname, string Nickname, string Email, string Picture);