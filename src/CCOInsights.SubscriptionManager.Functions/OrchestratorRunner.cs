using CCOInsights.SubscriptionManager.Functions.Operations;
using Microsoft.DurableTask.Client;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace CCOInsights.SubscriptionManager.Functions;

public class OrchestratorRunner
{
    private readonly Features _features;
    private readonly IEnumerable<OperationDescriptor> _governanceFunctions;
    private readonly IEnumerable<OperationDescriptor> _infrastructureFunctions;
    private readonly IEnumerable<OperationDescriptor> _commonFunctions;
    private readonly string _singleFunctionExecution;
    private readonly EnabledFunctions _enabledOperations;

    public OrchestratorRunner(IOptions<Features> features, EnabledFunctions enabledOperations)
    {
        _features = features.Value;
        var functions = OperationScanner.ScanForOperations();
        _governanceFunctions = functions.Where(x => x.DasboardAssigned == DashboardType.Governance);
        _infrastructureFunctions = functions.Where(x => x.DasboardAssigned == DashboardType.Infrastructure);
        _commonFunctions = functions.Where(x => x.DasboardAssigned == DashboardType.Common);
        _singleFunctionExecution = Environment.GetEnvironmentVariable("FunctionExclusive");
        _enabledOperations = enabledOperations;
        _enabledOperations.EnableRange(_infrastructureFunctions.Select(x => x.OperationName));
        _enabledOperations.EnableRange(_governanceFunctions.Select(x => x.OperationName));
        _enabledOperations.EnableRange(_commonFunctions.Select(x => x.OperationName));
        if (!string.IsNullOrEmpty(_singleFunctionExecution)) _enabledOperations.Enable(_singleFunctionExecution);

    }

    [Function("OrchestratorScheduleStart")]
    [ExponentialBackoffRetry(3, "00:00:10", "00:10:00")]
    public async Task Schedule([TimerTrigger("0 0 3 * * *", RunOnStartup = true)] TimerInfo myTimer, [DurableClient] DurableTaskClient durableClient, FunctionContext executionContext)
    {
        var logger = executionContext.GetLogger(nameof(Schedule));
        var instanceId = await durableClient.ScheduleNewOrchestrationInstanceAsync("OrchestratorRunner");
        logger.LogInformation("Started orchestration with ID = '{instanceId}'.", instanceId);
    }

    [Function(nameof(OrchestratorRunner))]
    public async Task Execute([OrchestrationTrigger] TaskOrchestrationContext context, CancellationToken cancellationToken = default)
    {
        var logger = context.CreateReplaySafeLogger(nameof(Execute));
        var tasks = new List<Task>();
        if (string.IsNullOrWhiteSpace(_singleFunctionExecution))
        {
            if (_features.GovernanceDashboard)
            {
                logger.LogInformation("Registering Functions in GovernanceDashboard Feature");
                foreach (var function in _governanceFunctions)
                    tasks.Add(context.CallActivityAsync(function.OperationName, _enabledOperations));
            }
            if (_features.InfrastructureDashboard)
            {
                logger.LogInformation("Registering Functions in InfrastructureDashboard Feature");
                foreach (var function in _infrastructureFunctions)
                    tasks.Add(context.CallActivityAsync(function.OperationName, _enabledOperations));
            }
            if (_features.GovernanceDashboard || _features.InfrastructureDashboard)
            {
                foreach (var function in _commonFunctions)
                    tasks.Add(context.CallActivityAsync(function.OperationName, _enabledOperations));
            }
        }
        else
            tasks.Add(context.CallActivityAsyncWithPolicies(_singleFunctionExecution, _enabledOperations));
        await Task.WhenAll(tasks);

        logger.LogInformation("Finished");
    }
}
