namespace Sonorus.ChatAPI.Data.Read;

public class User {
    public long UserId { get; set; }
    public string Nickname { get; set; } = null!;
    public string Picture { get; set; } = null!;
}