using System.Threading.Tasks;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions;

[OperationDescriptor(DashboardType.Infrastructure, nameof(RoleDefinitionsFunction))]
public class RoleDefinitionsFunction : IOperation
{
    private readonly IAuthenticated _authenticatedResourceManager;
    private readonly IRoleDefinitionsUpdater _updater;

    public RoleDefinitionsFunction(IAuthenticated authenticatedResourceManager, IRoleDefinitionsUpdater updater)
    {
        _authenticatedResourceManager = authenticatedResourceManager;
        _updater = updater;
    }

    [Function(nameof(RoleDefinitionsFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        var subscriptions = await _authenticatedResourceManager.Subscriptions.ListAsync(cancellationToken: cancellationToken);
        await subscriptions.AsyncParallelForEach(async subscription =>
            await _updater.UpdateAsync(executionContext.InvocationId, subscription, cancellationToken), 1);
    }
}
