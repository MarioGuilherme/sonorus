using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.DTO;

public class InterestDTO {
    public long? InterestId { get; set; }

    public string? Key { get; set; }

    public string? Value { get; set; }

    public InterestType Type { get; set; }
}