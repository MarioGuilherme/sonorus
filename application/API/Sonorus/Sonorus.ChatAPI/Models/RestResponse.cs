namespace Sonorus.ChatAPI.Models;

public class RestResponse<TData> {
    public string? Message { get; set; }
    public TData? Data { get; set; }
    public List<FieldError>? Errors { get; set; }
}