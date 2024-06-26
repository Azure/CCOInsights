using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Newtonsoft.Json;
using static Microsoft.Azure.Management.Fluent.Azure;

namespace CCOInsights.SubscriptionManager.Functions.Operations.KeyVault;

public interface IKeyVaultProvider : IProvider<KeyVaultResponse> { }
public class KeyVaultProvider(IAuthenticated authenticated, RestClient restClient, IHttpClientFactory httpClientFactory)
    : IKeyVaultProvider
{
    public async Task<IEnumerable<KeyVaultResponse>> GetAsync(string subscriptionId, CancellationToken cancellationToken = default)
    {
        var result = new List<KeyVaultResponse>();

        var resources = await authenticated.WithSubscription(subscriptionId).Deployments.Manager.GenericResources.ListAsync(cancellationToken: cancellationToken);
        var keyVaultsResources = resources.Where(r => r.Type.Contains("Microsoft.KeyVault/vaults")).ToList();

        await keyVaultsResources.AsyncParallelForEach(async keyVaultResource =>
        {
            var httpClient = httpClientFactory.CreateClient("client");

            var response = await GetModelAsync(httpClient, $"https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{keyVaultResource.ResourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultResource.Name}?api-version=2021-10-01", cancellationToken);

            result.Add(response);
        });

        return result;
    }

    private async Task<KeyVaultResponse> GetModelAsync(HttpClient client, string url, CancellationToken cancellationToken = default)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, url);

        await restClient.Credentials.ProcessHttpRequestAsync(request, cancellationToken);
        var response = await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        var content = await response.Content.ReadAsStringAsync(cancellationToken);

        return JsonConvert.DeserializeObject<KeyVaultResponse>(content);
    }
}
