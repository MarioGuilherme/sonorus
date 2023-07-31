namespace Sonorus.AccountAPI.Configuration;

public class RestResponse<TData> {
    public string? Message { get; set; }
    public TData? Data { get; set; }
}