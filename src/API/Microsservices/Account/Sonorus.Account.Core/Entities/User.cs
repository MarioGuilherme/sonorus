using static BCrypt.Net.BCrypt;

namespace Sonorus.Account.Core.Entities;

public class User(string fullname, string nickname, string email, string password) {
    public long UserId { get; private set; }
    public string Fullname { get; private set; } = fullname;
    public string Nickname { get; private set; } = nickname;
    public string Email { get; private set; } = email;
    public RefreshToken RefreshToken { get; private set; } = null!;

    public string Password {
        get => this._password;
        private set => this._password = HashPassword(value);
    }
    private string _password = password;

    public string Picture {
        get => $"{Environment.GetEnvironmentVariable("BlobStorageURL")}/{this._picture ?? "defaultPicture.png"}";
        private set => this._picture = value;
    }
    private string? _picture;

    public ICollection<Interest> Interests { get; private set; } = [];

    public void UpdatePassword(string password) => this._password = HashPassword(password);

    public void UpdateData(string fullname, string nickname, string email) {
        this.Fullname = fullname;
        this.Nickname = nickname;
        this.Email = email;
    }

    public void UpdatePicture(string pictureName) => this._picture = pictureName;
}