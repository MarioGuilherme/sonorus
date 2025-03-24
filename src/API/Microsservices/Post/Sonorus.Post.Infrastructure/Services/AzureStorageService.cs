using Azure.Storage.Blobs;
using Sonorus.Post.Core.Services;

namespace Sonorus.Post.Infrastructure.Services;

public class AzureStorageService(string connectionString, string containerName) : IFileStorage {
    private readonly BlobContainerClient _blobContainerClient = new(connectionString, containerName);

    public async Task DeleteFileAsync(string fileName) => await this._blobContainerClient.DeleteBlobIfExistsAsync(fileName);

    public async Task UploadOrUpdateFileAsync(string fileName, Stream stream) {
        BlobClient blobClient = this._blobContainerClient.GetBlobClient(fileName);
        await blobClient.UploadAsync(stream, overwrite: true);
    }
}