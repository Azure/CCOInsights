using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;

namespace CCOInsights.SubscriptionManager.Functions.Operations
{

    public interface IOperation
    {
        Task Execute([ActivityTrigger] IDurableActivityContext context, CancellationToken cancellationToken = default);
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

    public class OperationDescriptor
    {
        public DashboardType DasboardAssigned { get; private set; }
        public string OperationName { get; private set; }
        public OperationDescriptor(DashboardType dasboardAssigned, string operationName)
        {
            this.OperationName = operationName;
            this.DasboardAssigned = dasboardAssigned;
        }
    }

    [AttributeUsage(AttributeTargets.Class)]
    public class OperationDescriptorAttribute : System.Attribute
    {
        public OperationDescriptorAttribute(DashboardType dashboardtype, String operationName)
        {
            this.OperationName = operationName;
            this.DashboardAssigned = dashboardtype;
        }

        public DashboardType DashboardAssigned { get; }

        public String OperationName { get; }
    }
}
