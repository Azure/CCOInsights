using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions.Helpers;
using CCOInsights.SubscriptionManager.Functions.Operations;
using CCOInsights.SubscriptionManager.Helpers;
using DurableTask.Core;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace CCOInsights.SubscriptionManager.Functions.Functions;

public class OrchestratorRunner
{
    private readonly ILogger<OrchestratorRunner> _logger;
    private readonly Features _features;
    private readonly IEnumerable<OperationDescriptor> _governanceFunctions;
    private readonly IEnumerable<OperationDescriptor> _infrastructureFunctions;
    private readonly IEnumerable<OperationDescriptor> _commonFunctions;
    private readonly INameResolver _nameResolver;
    private readonly string _singleFunctionExecution;
    private readonly EnabledFunctions _enabledOperations;

    public OrchestratorRunner(ILogger<OrchestratorRunner> logger, IOptions<Features> features, INameResolver nameResolver, EnabledFunctions enabledOperations)
    {
        _logger = logger;
        _features = features.Value;
        var functions = OperationScanner.ScanForOperations();
        _governanceFunctions = functions.Where(x => x.DasboardAssigned == DashboardType.Governance);
        _infrastructureFunctions = functions.Where(x => x.DasboardAssigned == DashboardType.Infrastructure);
        _commonFunctions = functions.Where(x => x.DasboardAssigned == DashboardType.Common);
        _nameResolver = nameResolver;
        _singleFunctionExecution = Environment.GetEnvironmentVariable("FunctionExclusive");
        _enabledOperations = enabledOperations;
        _enabledOperations.EnableRange(_infrastructureFunctions.Select(x => x.OperationName));
        _enabledOperations.EnableRange(_governanceFunctions.Select(x => x.OperationName));
        if (!string.IsNullOrEmpty(_singleFunctionExecution)) _enabledOperations.Enable(_singleFunctionExecution);

    }


    [FunctionName("OrchestratorScheduleStart")]
    public async Task Schedule([TimerTrigger("0 0 0 * * *", RunOnStartup = true)] TimerInfo earlyTimer, [DurableClient] IDurableOrchestrationClient starter, System.Threading.CancellationToken cancellationToken = default)
    {
        await starter.PurgeInstanceHistoryAsync(DateTime.MinValue, DateTime.UtcNow, new List<OrchestrationStatus>() { OrchestrationStatus.Failed, OrchestrationStatus.Pending, OrchestrationStatus.Suspended, OrchestrationStatus.Canceled });
        var instanceId = await starter.StartNewAsync("OrchestratorRunner");
        _logger.LogInformation($"Started orchestration with ID = '{instanceId}'.");
    }



    [FunctionName(nameof(OrchestratorRunner))]
    public async Task Execute([OrchestrationTrigger] IDurableOrchestrationContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        var tasks = new List<Task>();
        if (string.IsNullOrWhiteSpace(_singleFunctionExecution))
        {
            if (_features.GovernanceDashboard)
            {
                _logger.LogInformation($"Registering Functions in GovernanceDashboard Feature");
                foreach (var function in _governanceFunctions)
                    tasks.Add(context.CallActivityAsyncWithPolicies(function.OperationName, _enabledOperations));
            }
            if (_features.InfrastructureDashboard)
            {

                _logger.LogInformation($"Registering Functions in InfrastructureDashboard Feature");
                foreach (var function in _infrastructureFunctions)
                    tasks.Add(context.CallActivityAsyncWithPolicies(function.OperationName, _enabledOperations));
            }
            if (_features.GovernanceDashboard || _features.InfrastructureDashboard)
            {
                foreach (var function in _commonFunctions)
                    tasks.Add(context.CallActivityAsyncWithPolicies(function.OperationName, _enabledOperations));
            }
        }
        else
            tasks.Add(context.CallActivityAsyncWithPolicies(_singleFunctionExecution, _enabledOperations));
        await Task.WhenAll(tasks);

        _logger.LogInformation("Finished");
    }
}