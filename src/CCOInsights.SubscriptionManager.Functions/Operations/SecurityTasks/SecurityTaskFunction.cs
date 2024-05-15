using System.Threading;
using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SecurityTasks;

[OperationDescriptor(DashboardType.Infrastructure, nameof(SecurityTaskFunction))]
public class SecurityTaskFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly ISecurityTaskUpdater _updater;

    public SecurityTaskFunction(IAuthenticated authenticatedResourceManager, ISecurityTaskUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(SecurityTaskFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }

}
