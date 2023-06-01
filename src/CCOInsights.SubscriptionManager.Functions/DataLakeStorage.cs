using System.Threading;
using System.Threading.Tasks;
using Azure.Storage.Files.DataLake;
using Azure.Storage.Files.DataLake.Models;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions
{
    public interface IStorage
    {
        Task UpdateItemAsync<T>(string id, T item, CancellationToken cancellationToken = default);
    }

    public class DataLakeStorage : IStorage
    {
        private readonly DataLakeServiceClient _dataLakeServiceClient;
        private readonly ILogger _logger;

        public DataLakeStorage(DataLakeServiceClient dataLakeServiceClient, ILogger<DataLakeStorage> logger)
        {
            _dataLakeServiceClient = dataLakeServiceClient;
            _logger = logger;
        }

        public async Task UpdateItemAsync<T>(string id, T item, CancellationToken cancellationToken = default)
        {
            try
            {
                var fileSystem =
                    _dataLakeServiceClient.GetFileSystemClient(
                        $"{typeof(T).Name.Replace("Model", string.Empty).ToLower()}s");
                await fileSystem.CreateIfNotExistsAsync(new DataLakeFileSystemCreateOptions { PublicAccessType = PublicAccessType.FileSystem },
                    cancellationToken: cancellationToken);

                var response = fileSystem.GetFileClient(id);
                var stream = BinaryData.FromObjectAsJson(item).ToStream();
                await response.DeleteIfExistsAsync(cancellationToken: cancellationToken); //Esto marca como borrado, pero no borra, será borrado más tarde cuando pasen unos minutos y el garbage collector del datalake quiera
                await response.UploadAsync(stream, overwrite: true, cancellationToken: cancellationToken); //Por eso esto da fallos a veces, por que esta en transicion
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error processing {typeof(T).Name} with id: {id}. Exception: {ex.ToString()}");
                throw;
            }
        }
    }
}
