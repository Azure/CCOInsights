namespace CCOInsights.SubscriptionManager.Generators;

internal class TemplateParameters
{
    public string GeneratedClassName { get; private set; } = "";
    public string GeneratedResponseName { get; private set; } = "";
    public string GeneratedNamespace { get; private set; } = "";
    public string Path { get; private set; } = "";

    private TemplateParameters()
    { }

    public static TemplateParameters Create(string generatedNamespace, string entityName, string responseName, string path)
    {
        var parameters = new TemplateParameters();
        parameters.GeneratedNamespace = generatedNamespace;
        parameters.GeneratedResponseName = responseName;
        parameters.GeneratedClassName = entityName;
        parameters.Path = path;
        return parameters;
    }
}