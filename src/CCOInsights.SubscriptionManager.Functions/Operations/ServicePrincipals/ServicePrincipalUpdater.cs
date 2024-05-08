using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

public interface IServicePrincipalUpdater : IUpdater { }
public class ServicePrincipalUpdater : Updater<ServicePrincipalResponse, ServicePrincipal>, IServicePrincipalUpdater
{
    public ServicePrincipalUpdater(IStorage storage, ILogger<ServicePrincipalUpdater> logger, IServicePrincipalProvider provider) : base(storage, logger, provider)
    {
    }

    protected override ServicePrincipal Map(string executionId, ISubscription subscription, ServicePrincipalResponse response) =>
        ServicePrincipal.From(executionId, response);
}
