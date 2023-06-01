using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

[OperationDescriptor(DashboardType.Infrastructure, nameof(ServicePrincipalFunction))]
public class ServicePrincipalFunction : IOperation
{
    private readonly IServicePrincipalUpdater _updater;

    public ServicePrincipalFunction(IServicePrincipalUpdater updater)
    {
        _updater = updater;
    }

    [FunctionName(nameof(ServicePrincipalFunction))]
    public async Task Execute([ActivityTrigger] IDurableActivityContext context, System.Threading.CancellationToken cancellationToken = default)
    {
        await _updater.UpdateAsync(context.InstanceId, null, cancellationToken);
    }
}
