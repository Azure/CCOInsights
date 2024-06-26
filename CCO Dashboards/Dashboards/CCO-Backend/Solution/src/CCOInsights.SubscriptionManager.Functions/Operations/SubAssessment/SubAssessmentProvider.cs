using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;

public interface ISubAssessmentProvider : IProvider<SubAssessmentResponse> { }
public class SubAssessmentProvider(IHttpClientFactory httpClientFactory, RestClient restClient)
    : Provider<SubAssessmentResponse>(httpClientFactory, restClient), ISubAssessmentProvider
{
    public override string Path => "/providers/Microsoft.Security/subAssessments?api-version=2019-01-01-preview";
    public override HttpMethod HttpMethod => HttpMethod.Get;
}
