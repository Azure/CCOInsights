﻿namespace CCOInsights.SubscriptionManager.Functions.Operations.NetworkSecurityGroups;

public class NetworkSecurityGroup : BaseEntity<NetworkSecurityGroupResponse>
{
    public NetworkSecurityGroup(string id, string tenantId, string subscriptionId, string executionId, NetworkSecurityGroupResponse value) : base(id, tenantId, subscriptionId, executionId, value)
    {
    }

    public static NetworkSecurityGroup From(string tenantId, string subscriptionId, string executionId, NetworkSecurityGroupResponse response)
    {
        var plainTextBytes = Encoding.UTF8.GetBytes(DateTime.UtcNow + response.Id);
        var id = Convert.ToBase64String(plainTextBytes);

        return new NetworkSecurityGroup(id, tenantId, subscriptionId, executionId, response);
    }
}

