using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

public interface IVirtualMachinePatchProvider : IProvider<VirtualMachinePatchResponse> { }
public class VirtualMachinePatchProvider : IVirtualMachinePatchProvider
{
    private readonly RestClient _restClient;
    private readonly IHttpClientFactory _httpClientFactory;

    public VirtualMachinePatchProvider(RestClient restClient, IHttpClientFactory httpClientFactory)
    {
        _restClient = restClient;
        _httpClientFactory = httpClientFactory;
    }

    public async Task<IEnumerable<VirtualMachinePatchResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        const string query = "patchassessmentresources | where type == 'microsoft.compute/virtualmachines/patchassessmentresults/softwarepatches'";
        var request = new HttpRequestMessage(HttpMethod.Post, $"https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2021-03-01");

        request.Content = new StringContent(JsonConvert.SerializeObject(new GraphRequestBody
        {
            subscriptions = new[] { subscriptionId },
            query = query
        }), Encoding.UTF8, "application/json");

        await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);

        var httpClient = _httpClientFactory.CreateClient("client");

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