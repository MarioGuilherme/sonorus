namespace Sonorus.AccountAPI.DTO;

public class UserInterestsDTO {
    public long? IdUser { get; set; }

    public List<InterestDTO> Interests { get; set; } = new();
}