using System.Threading.Tasks;



namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

[OperationDescriptor(DashboardType.Infrastructure, nameof(ServicePrincipalFunction))]
public class ServicePrincipalFunction : IOperation
{
    private readonly IServicePrincipalUpdater _updater;

    public ServicePrincipalFunction(IServicePrincipalUpdater updater)
    {
        _updater = updater;
    }

    [Function(nameof(ServicePrincipalFunction))]
        public async Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(executionContext.InvocationId, null, cancellationToken);
    }
}
