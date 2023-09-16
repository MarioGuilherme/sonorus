using Sonorus.AccountAPI.DTO;

namespace Sonorus.AccountAPI.Configuration;

public class RestResponse<TData> {
    public string? Message { get; set; }
    public TData? Data { get; set; }
    public List<FormErrorDTO>? Errors { get; set; }
}