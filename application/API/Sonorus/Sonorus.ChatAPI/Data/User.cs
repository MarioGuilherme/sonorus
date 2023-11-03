namespace Sonorus.ChatAPI.Data;

public class User {
    public long UserId { get; set; }
    public string Nickname { get; set; } = null!;
    public string Picture { get; set; } = null!;
}