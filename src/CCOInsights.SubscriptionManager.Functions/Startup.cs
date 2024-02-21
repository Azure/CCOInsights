global using System;
global using System.Text;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Azure.Core;
using Azure.Identity;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Functions;
using CCOInsights.SubscriptionManager.Helpers;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Graph;

[assembly: FunctionsStartup(typeof(Startup))]
namespace CCOInsights.SubscriptionManager.Functions
{

    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            var government = builder.GetContext().Configuration["Government"];

            var authenticatedResourceManager = BuildAuthenticatedResourceManager();
            var restClient = BuildAzureRestClient();
            var graphClient = BuildGraphClient(government);

            builder.Services.AddSingleton(authenticatedResourceManager);
            builder.Services.AddSingleton(restClient);
            builder.Services.AddSingleton(graphClient);

            builder.Services
                .AddHttpClient(government)
                .AddUpdaters()
                .AddProviders()
                .AddStorage();

            builder.Services.AddOptions<Features>().Configure<IConfiguration>((settings, configuration) =>
            {
                configuration.GetSection("Features").Bind(settings);
            });
        }

        private GraphServiceClient BuildGraphClient(string government)
        {
            if (EnvironmentExtensions.IsLocal())
            {
                return new GraphServiceClient(new ClientSecretCredential(Environment.GetEnvironmentVariable("ExternalTenantId"),
                    Environment.GetEnvironmentVariable("ExternalClientId"),
                    Environment.GetEnvironmentVariable("ExternalClientSecret")));
            }
            return new GraphServiceClient(new ClientSecretCredential(Environment.GetEnvironmentVariable("ExternalTenantId"),
                    Environment.GetEnvironmentVariable("ExternalClientId"),
                    Environment.GetEnvironmentVariable("ExternalClientSecret")));
            // else
            // {
            //     var credential = new ChainedTokenCredential(
            //     new ManagedIdentityCredential(Environment.GetEnvironmentVariable("AZURE_CLIENT_ID")),
            //     new EnvironmentCredential());

            //     var governmentUrl = government switch
            //     {
            //         "Public" => "graph.microsoft.com",
            //         "US" => "graph.microsoft.us",
            //         _ => throw new ArgumentOutOfRangeException()
            //     };

            //     var token = credential.GetToken(
            //         new TokenRequestContext(
            //             new[] { $"https://{governmentUrl}/.default" }));

            //     return new GraphServiceClient(
            //         new DelegateAuthenticationProvider(requestMessage =>
            //         {
            //             requestMessage
            //             .Headers
            //             .Authorization = new AuthenticationHeaderValue("bearer", token.Token);

            //             return Task.CompletedTask;
            //         }));
            // }
        }

        private Microsoft.Azure.Management.Fluent.Azure.IAuthenticated BuildAuthenticatedResourceManager()
        {
            return Microsoft.Azure.Management.Fluent.Azure.Configure()
                .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
                .Authenticate(BuildAzureCredentials());
        }

        private static RestClient BuildAzureRestClient()
        {
            return RestClient
                .Configure()
                .WithEnvironment(AzureEnvironment.AzureGlobalCloud)
                .WithCredentials(BuildAzureCredentials())
                .Build();
        }

        private static AzureCredentials BuildAzureCredentials()
        {
            if (EnvironmentExtensions.IsLocal())
            {
                return SdkContext
                    .AzureCredentialsFactory
                    .FromServicePrincipal(Environment.GetEnvironmentVariable("ExternalClientId"), Environment.GetEnvironmentVariable("ExternalClientSecret"), Environment.GetEnvironmentVariable("ExternalTenantId"), AzureEnvironment.AzureGlobalCloud);
            }
            return SdkContext
                .AzureCredentialsFactory
                .FromUserAssigedManagedServiceIdentity(Environment.GetEnvironmentVariable("AZURE_CLIENT_ID"), MSIResourceType.AppService, AzureEnvironment.AzureGlobalCloud, Environment.GetEnvironmentVariable("TenantId"));
        }
    }
}
