using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkSecurityGroups;

[OperationDescriptor(DashboardType.Infrastructure, nameof(NetworkSecurityGroupFunction))]
public class NetworkSecurityGroupFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly INetworkSecurityGroupUpdater _updater;

    public NetworkSecurityGroupFunction(IAuthenticated authenticatedResourceManager, INetworkSecurityGroupUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [FunctionName(nameof(NetworkSecurityGroupFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(context.InstanceId, subscription, cancellationToken), 1);
    }

}

