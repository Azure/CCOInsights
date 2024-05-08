using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Pricing;

public interface IPricingProvider : IProvider<PricingResponse> { }

public class PricingProvider : Provider<PricingResponse>, IPricingProvider
{
    public override string Path => "/providers/Microsoft.Security/pricings?api-version=2018-06-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;

    public PricingProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
    {
    }
}
