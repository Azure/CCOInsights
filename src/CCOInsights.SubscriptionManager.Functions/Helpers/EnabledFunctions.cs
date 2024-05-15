using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Helpers;

public class EnabledFunctions(ILogger<EnabledFunctions> logger)
{
    private readonly List<string> _enabledFunctions = new List<string>();

    public void Enable(string functionName)
    {
        _enabledFunctions.Add(functionName);
    }

    public void EnableRange(IEnumerable<string> functions)
    {
        _enabledFunctions.AddRange(functions);
    }

    public void Disable(string functionName)
    {
        logger.LogInformation($"Disabling Function {functionName}, this will be enabled on next function reboot ");
        _enabledFunctions.Remove(functionName);
    }

    public bool isEnabled(string functionName) => _enabledFunctions.Contains(functionName);
}
