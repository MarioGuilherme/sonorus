namespace Sonorus.Post.Core.Services;

public interface IFileStorage {
    Task DeleteFileAsync(string fileName);
    Task UploadOrUpdateFileAsync(string fileName, Stream stream);
}