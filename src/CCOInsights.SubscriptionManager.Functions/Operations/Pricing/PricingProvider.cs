using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Pricing;

public interface IPricingProvider : IProvider<PricingResponse> { }

public class PricingProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<PricingResponse>(httpClientFactory, restClient), IPricingProvider
{
    public override string Path => "/providers/Microsoft.Security/pricings?api-version=2018-06-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
