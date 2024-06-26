using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Models;

namespace CCOInsights.SubscriptionManager.Functions.Operations.GenericResource;

public class GenericResourceResponse
{
    public IGenericResource GenericResource { get; init; }
    public GenericResourceInner Inner { get; init; }
}
