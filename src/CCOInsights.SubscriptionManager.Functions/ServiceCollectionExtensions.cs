using System.Reflection;
using Azure.Identity;
using Azure.Storage.Files.DataLake;
using CCOInsights.SubscriptionManager.Functions.Operations.Groups;
using CCOInsights.SubscriptionManager.Functions.Operations.Users;
using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;
using Microsoft.Extensions.DependencyInjection;
using NetCore.AutoRegisterDi;
using Polly;
using Polly.Extensions.Http;

namespace CCOInsights.SubscriptionManager.Functions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddUpdaters(this IServiceCollection services)
    {
        var assembliesToScan = new[]
        {
            Assembly.GetExecutingAssembly(), //Functions Layer
            Assembly.GetAssembly(typeof(DataLakeStorage)), //Infra Layer
            Assembly.GetAssembly(typeof(VirtualMachineUpdater)) //Application Layer
        };
        services.RegisterAssemblyPublicNonGenericClasses(assembliesToScan)
            .Where(c => c.Name.EndsWith("Updater"))
            .IgnoreThisInterface<IUpdater>()
            .AsPublicImplementedInterfaces(ServiceLifetime.Scoped);
        return services;
    }

    public static IServiceCollection AddProviders(this IServiceCollection services)
    {
        var assembliesToScan = new[]
        {
            Assembly.GetExecutingAssembly(), //Functions Layer
            Assembly.GetAssembly(typeof(DataLakeStorage)), //Infra Layer
            Assembly.GetAssembly(typeof(VirtualMachineUpdater)) //Application Layer
        };
        services.RegisterAssemblyPublicNonGenericClasses(assembliesToScan)
            .Where(c => c.Name.EndsWith("Provider"))
            .AsPublicImplementedInterfaces(ServiceLifetime.Scoped);
        return services;
    }

    public static IServiceCollection AddStorage(this IServiceCollection services)
    {
        DataLakeServiceClient dataLakeServiceClient;

        if (EnvironmentExtensions.IsLocal())
        {
            dataLakeServiceClient = new DataLakeServiceClient(
                new Uri($"https://{Environment.GetEnvironmentVariable("DataLakeAccountName")}.dfs.core.windows.net"),
                new ClientSecretCredential(Environment.GetEnvironmentVariable("TenantId"), Environment.GetEnvironmentVariable("ClientId"), Environment.GetEnvironmentVariable("ClientSecret")));

        }
        else
        {
            dataLakeServiceClient = new DataLakeServiceClient(new Uri($"https://{Environment.GetEnvironmentVariable("DataLakeAccountName")}.dfs.core.windows.net"), new ManagedIdentityCredential());
        }

        services.AddSingleton(dataLakeServiceClient);
        services.AddSingleton<IStorage, DataLakeStorage>();
        services.AddSingleton<UsersMapper>();
        services.AddSingleton<GroupsMapper>();
        services.AddSingleton<EnabledFunctions>();

        return services;
    }

    public static IServiceCollection AddCustomHttpClient(this IServiceCollection services, string government)
    {
        var governmentUrl = government switch
        {
            "Public" => "management.azure.com",
            "US" => "management.usgovcloudapi.net",
            _ => throw new ArgumentOutOfRangeException()
        };
        services.AddHttpClient("client", client =>
        {
            client.BaseAddress = new Uri($"https://{governmentUrl}/subscriptions/");
        }).AddPolicyHandler(HttpPolicyExtensions
            .HandleTransientHttpError()
            .WaitAndRetryAsync(3, retry => TimeSpan.FromSeconds(2 * retry)));

        return services;
    }
}
