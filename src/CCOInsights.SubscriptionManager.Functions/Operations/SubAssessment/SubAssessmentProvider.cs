using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment
{
    public interface ISubAssessmentProvider : IProvider<SubAssessmentResponse> { }
    public class SubAssessmentProvider : Provider<SubAssessmentResponse>, ISubAssessmentProvider
    {
        public override string Path => "/providers/Microsoft.Security/subAssessments?api-version=2019-01-01-preview";
        public override HttpMethod HttpMethod => HttpMethod.Get;

        public SubAssessmentProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
        {
        }
    }
}
