using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;

namespace CCOInsights.SubscriptionManager.Functions.Operations;

public interface IProvider<T>
{
    Task<IEnumerable<T>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default);
}

public abstract class Provider<T> : IProvider<T> where T : IAzureResponse
{
    public abstract string Path { get; }
    public abstract HttpMethod HttpMethod { get; }

    private readonly IHttpClientFactory _httpClientFactory;
    private readonly RestClient _restClient;

    protected Provider(IHttpClientFactory httpClientFactory, RestClient restClient)
    {
        _httpClientFactory = httpClientFactory;
        _restClient = restClient;
    }

    public async Task<IEnumerable<T>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = new List<T>();

        var httpClient = _httpClientFactory.CreateClient("client");

        var response = await GetModelAsync(httpClient, $"{httpClient.BaseAddress}{subscriptionId}{Path}", cancellationToken);

        result.AddRange(response.Value);

        while (!string.IsNullOrEmpty(response.NextLink))
        {
            response = await GetModelAsync(httpClient, response.NextLink, cancellationToken);
            result.AddRange(response.Value);
        }

        return result;
    }

    private async Task<ProviderResponse<T>> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod, url);

        await _restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        //if(response.StatusCode == )
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<ProviderResponse<T>>(content);
    }
}