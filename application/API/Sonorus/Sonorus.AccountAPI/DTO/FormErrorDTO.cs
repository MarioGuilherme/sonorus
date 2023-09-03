namespace Sonorus.AccountAPI.DTO;

public class FormErrorDTO {
    public string Field { get; set; } = null!;
    public string Error { get; set; } = null!;
}