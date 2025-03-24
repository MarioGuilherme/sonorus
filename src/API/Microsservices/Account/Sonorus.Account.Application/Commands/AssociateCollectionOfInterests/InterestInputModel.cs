using Sonorus.Account.Core.Enums;

namespace Sonorus.Account.Application.Commands.AssociateCollectionOfInterests;

public class InterestInputModel(long interestId, string? key, string? value, InterestType type) {
    public long InterestId { get; private set; } = interestId;
    public string? Key { get; private set; } = key;
    public string? Value { get; private set; } = value;
    public InterestType Type { get; private set; } = type;
}