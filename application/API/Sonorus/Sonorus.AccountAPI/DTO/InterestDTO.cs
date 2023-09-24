using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.DTO;

public class InterestDTO {
    public long? IdInterest { get; set; }

    public string? Key { get; set; }

    public string? Value { get; set; }

    public InterestType Type { get; set; }
}