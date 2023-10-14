using Microsoft.Azure.Cosmos;
using System.Text.Json;

namespace Sonorus.ChatAPI.Configuration;

public class CosmosDbSerializer : CosmosSerializer {
    private readonly JsonSerializerOptions jsonOptions = new() {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase
    };

    public override T FromStream<T>(Stream stream) {
        using (stream) {
            if (typeof(Stream).IsAssignableFrom(typeof(T)))
                return (T) (object) stream;

            return JsonSerializer.DeserializeAsync<T>(stream, this.jsonOptions).GetAwaiter().GetResult()!;
        }
    }
    
    public override Stream ToStream<T>(T input) {
        MemoryStream outputStream = new();
        JsonSerializer.SerializeAsync<T>(outputStream, input, this.jsonOptions).GetAwaiter().GetResult();
        outputStream.Position = 0;
        return outputStream;
    }
}