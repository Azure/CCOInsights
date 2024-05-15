using Azure.Storage.Files.DataLake;
using Azure.Storage.Files.DataLake.Models;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions;

public interface IStorage
{
    Task UpdateItemAsync<T>(string id, string containerName, T item, CancellationToken cancellationToken = default);
}

public class DataLakeStorage(DataLakeServiceClient dataLakeServiceClient, ILogger<DataLakeStorage> logger)
    : IStorage
{
    private readonly ILogger _logger = logger;

    public async Task UpdateItemAsync<T>(string id, string containerName, T item, CancellationToken cancellationToken = default)
    {
        try
        {
            id = $"{id}.json";
            var fileSystem = dataLakeServiceClient.GetFileSystemClient(containerName);

            var response = fileSystem.GetFileClient(id);
            var stream = BinaryData.FromObjectAsJson(item).ToStream();

            await response.UploadAsync(stream, new DataLakeFileUploadOptions{HttpHeaders = new PathHttpHeaders{ContentType = "application/json"}}, cancellationToken);
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error processing {typeof(T).Name} with id: {id}. Exception: {ex}");
            throw;
        }
    }
}
