namespace CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

public class DefenderSecureScoreControlDefinition : BaseEntity<DefenderSecureScoreControlDefinitionResponse>
{
    private DefenderSecureScoreControlDefinition(string id, string executionId, DefenderSecureScoreControlDefinitionResponse value) : base(id, executionId, value)
    {
    }

    public static DefenderSecureScoreControlDefinition From(string executionId, DefenderSecureScoreControlDefinitionResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new DefenderSecureScoreControlDefinition(id, executionId, response);
    }
}