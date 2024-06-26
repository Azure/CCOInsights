namespace CCOInsights.SubscriptionManager.Functions.Helpers;

public static class EnvironmentExtensions
{
    public static bool IsLocal()
    {
        var environment = Environment.GetEnvironmentVariable("Environment");
        return environment != null && environment.Equals("Local", StringComparison.OrdinalIgnoreCase);
    }
}
