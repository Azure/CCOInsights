namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;

public class DefenderAssessmentsMetadata : BaseEntity<DefenderAssessmentsMetadataResponse>
{
    private DefenderAssessmentsMetadata(string id, string tenantId, string subscriptionId, string executionId, DefenderAssessmentsMetadataResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static DefenderAssessmentsMetadata From(string tenantId, string subscriptionId, string executionId, DefenderAssessmentsMetadataResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new DefenderAssessmentsMetadata(id, tenantId, subscriptionId, executionId, response);
    }
}