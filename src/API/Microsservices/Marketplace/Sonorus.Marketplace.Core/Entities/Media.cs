namespace Sonorus.Marketplace.Core.Entities;

public class Media(string path) {
    public long MediaId { get; private set; }
    public long ProductId { get; private set; }
    public Product Product { get; private set; } = null!;
    public string Path {
        get => $"{Environment.GetEnvironmentVariable("BlobStorageURL")}/{_path}";
        private set => _path = value;
    }
    private string _path = path;

    public override bool Equals(object? obj) => obj is Media media && MediaId == media.MediaId && ProductId == media.ProductId;
    public override int GetHashCode() => HashCode.Combine(MediaId, ProductId);
}