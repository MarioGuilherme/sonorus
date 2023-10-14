namespace Sonorus.AccountAPI.DTO;

public class UserInterestsDTO {
    public long? UserId { get; set; }

    public List<InterestDTO> Interests { get; set; } = new();
}