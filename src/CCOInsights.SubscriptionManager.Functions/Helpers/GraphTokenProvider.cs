using Azure.Core;
using Azure.Identity;
using Microsoft.Kiota.Abstractions.Authentication;

namespace CCOInsights.SubscriptionManager.Functions.Helpers
{
    public class GraphTokenProvider : IAccessTokenProvider
    {
        string _government;
        public GraphTokenProvider(string government)
        {
            _government = government ?? throw new ArgumentNullException(nameof(government));
        }
        public async Task<string> GetAuthorizationTokenAsync(Uri uri, Dictionary<string, object> additionalAuthenticationContext = default,
            CancellationToken cancellationToken = default)
        {
            var credential = new ChainedTokenCredential(
                new ManagedIdentityCredential(),
                new EnvironmentCredential());

            var governmentUrl = _government switch
            {
                "Public" => "graph.microsoft.com",
                "US" => "graph.microsoft.us",
                _ => throw new ArgumentOutOfRangeException()
            };

            var token = await credential.GetTokenAsync(
                new TokenRequestContext(
                    new[] { $"https://{governmentUrl}/.default" }), cancellationToken);

            // Return the token string
            return token.Token;
        }

        public AllowedHostsValidator AllowedHostsValidator { get; }
    }
}
