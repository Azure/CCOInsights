using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

public interface IVirtualMachinePatchProvider : IProvider<VirtualMachinePatchResponse> { }
public class VirtualMachinePatchProvider(RestClient restClient, IHttpClientFactory httpClientFactory)
    : IVirtualMachinePatchProvider
{
    public async Task<IEnumerable<VirtualMachinePatchResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        const string query = "patchassessmentresources | where type == 'microsoft.compute/virtualmachines/patchassessmentresults/softwarepatches'";
        var request = new HttpRequestMessage(HttpMethod.Post, $"https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2021-03-01");

        request.Content = new StringContent(JsonConvert.SerializeObject(new GraphRequestBody
        {
            subscriptions = new[] { subscriptionId },
            query = query
        }), Encoding.UTF8, "application/json");

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);

        var httpClient = httpClientFactory.CreateClient("client");

        var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
        var virtualMachinePatchResponse = JsonConvert.DeserializeObject<ProviderResponse<VirtualMachinePatchResponse>>(responseContent);

        return virtualMachinePatchResponse?.Value != null ? virtualMachinePatchResponse.Value : new List<VirtualMachinePatchResponse>();
    }
}

public class GraphRequestBody
{
    public string[] subscriptions;
    public string query;
}
