using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions.Helpers;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Helpers
{
    public static class DurableOrchestrationContextExtensions
    {
        public static async Task CallActivityAsyncWithPolicies(this IDurableOrchestrationContext context, string functionName, EnabledFunctions enabledFunctions)
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

}

