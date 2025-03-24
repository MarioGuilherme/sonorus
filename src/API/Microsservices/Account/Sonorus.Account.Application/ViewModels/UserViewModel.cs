namespace Sonorus.Account.Application.ViewModels;

public record UserViewModel(
    long UserId,
    string Fullname,
    string Nickname,
    string Email,
    string Picture,
    IEnumerable<InterestViewModel> Interests
);