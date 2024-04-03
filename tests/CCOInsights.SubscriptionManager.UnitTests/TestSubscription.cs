using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.Models;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class TestSubscription : ISubscription
{
    public string Key => "Key";
    public string SubscriptionId => "SubscriptionId";
    public string DisplayName => "DisplayName";
    public string State => "State";
    public SubscriptionInner Inner => new(tenantId: "tenantId");
    public IEnumerable<ILocation> ListLocations()
    {
        throw new System.NotImplementedException();
    }

    public ILocation GetLocationByRegion(Region region)
    {
        throw new System.NotImplementedException();
    }


    public SubscriptionPolicies SubscriptionPolicies => new();
}
