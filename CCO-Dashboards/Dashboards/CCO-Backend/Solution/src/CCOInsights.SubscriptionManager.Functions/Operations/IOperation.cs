using System.Reflection;

namespace CCOInsights.SubscriptionManager.Functions.Operations;

public interface IOperation
{
    Task Execute([ActivityTrigger] string name, FunctionContext executionContext, CancellationToken cancellationToken = default);
}

public enum DashboardType
{
    Governance,
    Infrastructure,
    Common
}

public static class OperationScanner
{
    public static List<OperationDescriptor> ScanForOperations()
    {
        List<OperationDescriptor> operationDescriptors = new List<OperationDescriptor>();
        var type = typeof(IOperation);
        var types = Assembly.GetExecutingAssembly().GetTypes().Where(p => type.IsAssignableFrom(p));

        foreach (var operationType in types)
        {
            var attributeData = operationType.GetCustomAttributes<OperationDescriptorAttribute>();
            if ((attributeData != null) && (attributeData.Count() > 0))
            {
                var descriptor = attributeData.First();
                operationDescriptors.Add(new OperationDescriptor(descriptor.DashboardAssigned, descriptor.OperationName));
            }

        }
        return operationDescriptors;
    }

}

public class OperationDescriptor(DashboardType dasboardAssigned, string operationName)
{
    public DashboardType DasboardAssigned { get; private set; } = dasboardAssigned;
    public string OperationName { get; private set; } = operationName;
}

[AttributeUsage(AttributeTargets.Class)]
public class OperationDescriptorAttribute(DashboardType dashboardtype, String operationName) : System.Attribute
{
    public DashboardType DashboardAssigned { get; } = dashboardtype;

    public String OperationName { get; } = operationName;
}
