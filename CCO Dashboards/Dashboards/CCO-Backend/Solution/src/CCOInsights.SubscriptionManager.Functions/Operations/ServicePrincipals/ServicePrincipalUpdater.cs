using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

public interface IServicePrincipalUpdater : IUpdater { }
public class ServicePrincipalUpdater(IStorage storage, ILogger<ServicePrincipalUpdater> logger,
        IServicePrincipalProvider provider)
    : Updater<ServicePrincipalResponse, ServicePrincipal>(storage, logger, provider), IServicePrincipalUpdater
{
    protected override ServicePrincipal Map(string executionId, ISubscription subscription, ServicePrincipalResponse response) =>
        ServicePrincipal.From(executionId, response);
}
