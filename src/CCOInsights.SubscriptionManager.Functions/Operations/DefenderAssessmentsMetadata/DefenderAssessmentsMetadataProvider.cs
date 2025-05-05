using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;

public interface IDefenderAssessmentsMetadataProvider : IProvider<DefenderAssessmentsMetadataResponse> { }

public class DefenderAssessmentsMetadataProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<DefenderAssessmentsMetadataResponse>(httpClientFactory, restClient), IDefenderAssessmentsMetadataProvider
{
    public override string Path => "/providers/Microsoft.Security/assessmentMetadata?api-version=2020-01-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
