namespace CCOInsights.SubscriptionManager.Functions.Operations;

using System;

[AttributeUsage(AttributeTargets.Class)]
public class GeneratedProviderAttribute : System.Attribute
{
    private string path;
    public GeneratedProviderAttribute(string path)
    {
        this.path = path;
    }
}