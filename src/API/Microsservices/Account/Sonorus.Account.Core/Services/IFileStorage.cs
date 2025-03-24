namespace Sonorus.Account.Core.Services;

public interface IFileStorage {
    Task DeleteFileAsync(string fileName);
    Task UploadOrUpdateFileAsync(string fileName, Stream stream);
}