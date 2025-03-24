namespace Sonorus.Post.Core.Entities;

public class Media(string path) {
    public long MediaId { get; private set; }
    public long PostId { get; private set; }
    public string Path {
        get => $"{Environment.GetEnvironmentVariable("BlobStorageURL")}/{this._path}";
        private set => this._path = value;
    }
    private string _path = path;
}