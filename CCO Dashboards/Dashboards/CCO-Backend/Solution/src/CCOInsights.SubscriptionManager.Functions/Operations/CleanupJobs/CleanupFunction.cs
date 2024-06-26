//using System.Threading;
//using System.Threading.Tasks;
//using DurableTask.AzureStorage;


//using Microsoft.Extensions.Logging;

//namespace CCOInsights.SubscriptionManager.Functions.Operations.CleanupJobs;

//public class CleanupFunction
//{
//    private readonly INameResolver _nameResolver;
//    private readonly ILogger<CleanupFunction> _logger;

//    public CleanupFunction(INameResolver nameResolver, ILogger<CleanupFunction> logger)
//    {
//        _nameResolver = nameResolver;
//        _logger = logger;
//    }

//    [Function(nameof(CleanupFunction))]
//    public async Task Execute([ActivityTrigger] IDurableClient client, CancellationToken cancellationToken = default)
//    {
//        string connString = _nameResolver.Resolve("AzureWebJobsStorage");
//        var settings = new AzureStorageOrchestrationServiceSettings
//        {
//            StorageConnectionString = connString,
//            TaskHubName = client.TaskHubName,
//        };


//        var storageService = new AzureStorageOrchestrationService(settings);

//        _logger.LogInformation(
//            "Deleting all storage resources for task hub {taskHub}...",
//            settings.TaskHubName);
//        await storageService.DeleteAsync();

//        _logger.LogInformation(
//            "The delete operation completed. Waiting one minute before recreating...");
//        await Task.Delay(TimeSpan.FromMinutes(1));

//        _logger.LogInformation(
//            "Recreating storage resources for task hub {taskHub}...",
//            settings.TaskHubName);
//        await storageService.CreateIfNotExistsAsync();

//    }
//}
