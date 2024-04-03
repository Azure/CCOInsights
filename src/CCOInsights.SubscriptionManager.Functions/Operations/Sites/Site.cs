﻿namespace CCOInsights.SubscriptionManager.Functions.Operations.Sites;

public class Site : BaseEntity<SiteResponse>
{
    public Site(string id, string tenantId, string subscriptionId, string executionId, SiteResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static Site From(string tenantId, string subscriptionId, string executionId, SiteResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new Site(id, tenantId, subscriptionId, executionId, response);
    }
}