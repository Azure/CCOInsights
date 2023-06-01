using System.Collections.Generic;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Helpers
{
    public class EnabledFunctions
    {
        private readonly List<string> _enabledFunctions = new List<string>();
        private ILogger<EnabledFunctions> _logger;

        public EnabledFunctions(ILogger<EnabledFunctions> logger)
        {
            _logger = logger;
        }

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
            _logger.LogInformation($"Disabling Function {functionName}, this will be enabled on next function reboot ");
            _enabledFunctions.Remove(functionName);
        }

        public bool isEnabled(string functionName) => _enabledFunctions.Contains(functionName);
    }
}
