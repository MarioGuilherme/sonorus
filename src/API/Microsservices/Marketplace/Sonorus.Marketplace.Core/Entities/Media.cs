namespace Sonorus.Marketplace.Core.Entities;

public class Media(string path) {
    public long MediaId { get; private set; }
    public long ProductId { get; private set; }
    public Product Product { get; private set; } = null!;
    public string Path {
        get => $"{Environment.GetEnvironmentVariable("BlobStorageURL")}/{this._path}";
        private set => this._path = value;
    }
    private string _path = path;

    public override bool Equals(object? obj) => obj is Media media && this.MediaId == media.MediaId && this.ProductId == media.ProductId;
    public override int GetHashCode() => HashCode.Combine(this.MediaId, this.ProductId);
}