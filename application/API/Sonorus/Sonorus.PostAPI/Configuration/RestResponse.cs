namespace Sonorus.PostAPI.Configuration;

public class RestResponse<TData> {
    public string? Message { get; set; }
    public TData? Data { get; set; }

    public void Deconstruct(out string? message, out TData? data) {
        message = this.Message;
        data = this.Data;
    }
}