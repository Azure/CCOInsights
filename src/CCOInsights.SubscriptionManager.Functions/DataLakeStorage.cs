using System.Globalization;
using Azure.Storage.Files.DataLake;
using Azure.Storage.Files.DataLake.Models;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

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
            var json = JsonConvert.SerializeObject(item, new JsonSerializerSettings
            {
                ContractResolver = new UpperCamelCaseNamingResolver(),
                Formatting = Formatting.Indented,
            }
        );
        var stream = new MemoryStream(Encoding.UTF8.GetBytes(json));

            await response.UploadAsync(stream, new DataLakeFileUploadOptions{HttpHeaders = new PathHttpHeaders{ContentType = "application/json"}}, cancellationToken);
        }
        catch (Exception ex)
        {
            _logger.LogError($"Error processing {typeof(T).Name} with id: {id}. Exception: {ex}");
            throw;
        }
    }
}

public class UpperCamelCaseNamingResolver: DefaultContractResolver
{
    protected override string ResolvePropertyName(string propertyName)
    {
        return char.ToUpper(propertyName[0], CultureInfo.InvariantCulture) + propertyName.Substring(1);
    }
}
