using Sonorus.Account.Core.Enums;

namespace Sonorus.Account.Core.Entities;

public class Interest(string key, string value, InterestType type) {
    public long InterestId { get; private set; }
    public string Key { get; private set; } = key;
    public string Value { get; private set; } = value;
    public InterestType Type { get; private set; } = type;
    public ICollection<User> Users { get; private set; } = [];
}