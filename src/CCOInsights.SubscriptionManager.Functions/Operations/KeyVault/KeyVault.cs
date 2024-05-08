namespace CCOInsights.SubscriptionManager.Functions.Operations.KeyVault;

public class KeyVault : BaseEntity<KeyVaultResponse>
{
    private KeyVault(string id, string tenantId, string subscriptionId, string executionId, KeyVaultResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static KeyVault From(string tenantId, string subscriptionId, string executionId, KeyVaultResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new KeyVault(id, tenantId, subscriptionId, executionId, response);
    }
}