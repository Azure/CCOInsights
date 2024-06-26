
namespace CCOInsights.SubscriptionManager.Functions.Helpers;

public static class DurableOrchestrationContextExtensions
{
    public static async Task CallActivityAsyncWithPolicies(this TaskOrchestrationContext context, string functionName, EnabledFunctions enabledFunctions)
    {
        try
        {
            if (enabledFunctions.isEnabled(functionName))
            {
                await context.CallActivityAsync(functionName, null);
            }
        }
        catch (Exception)
        {
            enabledFunctions.Disable(functionName);
            //await context.CallActivityAsync("CleanUpFunction", null);
        }

    }
}
