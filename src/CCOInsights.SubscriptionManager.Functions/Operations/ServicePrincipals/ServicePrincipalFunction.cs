namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;
using System.Text.Json.Nodes;

[OperationDescriptor(DashboardType.Infrastructure, nameof(ServicePrincipalFunction))]
public class ServicePrincipalFunction(IServicePrincipalUpdater updater) : IOperation
{
    [Function(nameof(ServicePrincipalFunction))]
        public async Task Execute([ActivityTrigger] JsonObject input, FunctionContext executionContext, CancellationToken cancellationToken = default)
    {
        await updater.UpdateAsync(executionContext.BindingContext.BindingData["instanceId"].ToString(), null, cancellationToken);
    }
}
