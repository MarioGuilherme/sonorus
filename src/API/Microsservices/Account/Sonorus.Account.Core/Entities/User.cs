using static BCrypt.Net.BCrypt;

namespace Sonorus.Account.Core.Entities;

public class User(string fullname, string nickname, string email, string password)
{
    public long UserId { get; private set; }
    public string Fullname { get; private set; } = fullname;
    public string Nickname { get; private set; } = nickname;
    public string Email { get; private set; } = email;
    public RefreshToken RefreshToken { get; private set; } = null!;

    public string Password
    {
        get => _password;
        private set => _password = HashPassword(value);
    }
    private string _password = password;

    public string Picture
    {
        get => $"{Environment.GetEnvironmentVariable("BlobStorageURL")}/{_picture ?? "defaultPicture.png"}";
        private set => _picture = value;
    }
    private string? _picture;

    public ICollection<Interest> Interests { get; private set; } = [];

    public void UpdatePassword(string password) => _password = HashPassword(password);

    public void UpdateData(string fullname, string nickname, string email)
    {
        Fullname = fullname;
        Nickname = nickname;
        Email = email;
    }

    public void UpdatePicture(string pictureName) => _picture = pictureName;
}