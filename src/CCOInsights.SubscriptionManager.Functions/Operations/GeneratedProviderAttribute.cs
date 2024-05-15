namespace CCOInsights.SubscriptionManager.Functions.Operations;

using System;

[AttributeUsage(AttributeTargets.Class)]
public class GeneratedProviderAttribute(string path) : System.Attribute
{
    private string path = path;
}