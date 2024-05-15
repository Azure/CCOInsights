using Microsoft.Extensions.Logging;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.GenericResource;

public interface IGenericResourceProvider : IProvider<GenericResourceResponse> { }
public class GenericResourceProvider(IAuthenticated authenticated, ILogger<GenericResourceProvider> logger)
    : IGenericResourceProvider
{
    private readonly ILogger<GenericResourceProvider> _logger = logger;

    public async Task<IEnumerable<GenericResourceResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = new List<GenericResourceResponse>();

        var resources = await authenticated.WithSubscription(subscriptionId).Deployments.Manager.GenericResources.ListAsync(cancellationToken: cancellationToken);
        foreach (var resource in resources)
        {
            var resourceDetail = await authenticated.WithSubscription(subscriptionId).Deployments.Manager.GenericResources.GetByIdAsync(resource.Id, cancellationToken: cancellationToken);
            result.Add(new GenericResourceResponse { GenericResource = resource, Inner = resourceDetail.Inner });
        }

        return result;
    }

}
