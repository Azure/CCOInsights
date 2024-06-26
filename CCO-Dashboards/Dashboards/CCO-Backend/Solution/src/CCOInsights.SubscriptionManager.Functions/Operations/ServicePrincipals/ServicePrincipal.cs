namespace CCOInsights.SubscriptionManager.Functions.Operations.ServicePrincipals;

public class ServicePrincipal : BaseEntity<ServicePrincipalResponse>
{
    protected ServicePrincipal(string id, string executionId, ServicePrincipalResponse value) : base(id, executionId, value)
    {
    }

    public static ServicePrincipal From(string executionId, ServicePrincipalResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new ServicePrincipal(id, executionId, response);
    }
}
