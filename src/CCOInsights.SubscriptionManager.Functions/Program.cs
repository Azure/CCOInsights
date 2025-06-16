using System.Net.Http.Headers;
using Azure.Core;
using Azure.Identity;
using CCOInsights.SubscriptionManager.Functions;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Graph;
using Microsoft.Kiota.Abstractions.Authentication;

var host = new HostBuilder()
    .ConfigureFunctionsWebApplication()
    .ConfigureServices((context, services) =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();
        var government = context.Configuration["Government"];

        var authenticatedResourceManager = BuildAuthenticatedResourceManager();
        var restClient = BuildAzureRestClient();
        var graphClient = BuildGraphClient(government);

        services.AddSingleton(authenticatedResourceManager);
        services.AddSingleton(restClient);
        services.AddSingleton(graphClient);

        services
            .AddUpdaters()
            .AddProviders()
            .AddStorage()
            .AddCustomHttpClient(government);

        services.AddOptions<Features>().Configure<IConfiguration>((settings, configuration) =>
        {
            configuration.GetSection("Features").Bind(settings);
        });
        services.AddLogging(x => x.AddConsole());
    })
    .Build();

var logger = host.Services.GetRequiredService<ILogger<Program>>();
logger.LogInformation("Host built successfully. Starting the host...");

host.Run();

return;

GraphServiceClient BuildGraphClient(string government)
{
    if (EnvironmentExtensions.IsLocal())
    {
        return new GraphServiceClient(new ClientSecretCredential(Environment.GetEnvironmentVariable("ExternalTenantId"),
            Environment.GetEnvironmentVariable("ExternalClientId"),
            Environment.GetEnvironmentVariable("ExternalClientSecret")));
    }
    else
    {
        var tokenprovider = new BaseBearerTokenAuthenticationProvider(new GraphTokenProvider(government));
        return new GraphServiceClient(tokenprovider);
    }
}

Microsoft.Azure.Management.Fluent.Azure.IAuthenticated BuildAuthenticatedResourceManager()
{
    return Microsoft.Azure.Management.Fluent.Azure.Configure()
        .WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic)
        .Authenticate(BuildAzureCredentials());
}

RestClient BuildAzureRestClient()
{
    return RestClient
        .Configure()
        .WithEnvironment(AzureEnvironment.AzureGlobalCloud)
        .WithCredentials(BuildAzureCredentials())
        .Build();
}

AzureCredentials BuildAzureCredentials()
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
