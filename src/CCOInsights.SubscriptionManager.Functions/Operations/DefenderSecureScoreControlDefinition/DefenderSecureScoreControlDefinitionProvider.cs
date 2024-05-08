using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

public interface IDefenderSecureScoreControlDefinitionProvider : IProvider<DefenderSecureScoreControlDefinitionResponse> { }
public class DefenderSecureScoreControlDefinitionProvider : IDefenderSecureScoreControlDefinitionProvider
{
    private readonly RestClient _restClient;
    private readonly IHttpClientFactory _httpClientFactory;

    public DefenderSecureScoreControlDefinitionProvider(RestClient restClient, IHttpClientFactory httpClientFactory)
    {
        _restClient = restClient;
        _httpClientFactory = httpClientFactory;
    }

    public async Task<IEnumerable<DefenderSecureScoreControlDefinitionResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var httpClient = _httpClientFactory.CreateClient("client");
        var response = await GetModelAsync(httpClient, "https://management.azure.com/providers/Microsoft.Security/secureScoreControlDefinitions?api-version=2020-01-01", cancellationToken);
        return response.Value;
    }

    private async Task<DefenderSecureScoreControlDefinitionResponseList> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, url);

        await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<DefenderSecureScoreControlDefinitionResponseList>(content);
    }
}