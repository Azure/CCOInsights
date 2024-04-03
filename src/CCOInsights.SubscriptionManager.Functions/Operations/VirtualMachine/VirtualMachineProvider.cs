using System.Net.Http;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

namespace CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;

public interface IVirtualMachineProvider : IProvider<VirtualMachineResponse> { }
public class VirtualMachineProvider : Provider<VirtualMachineResponse>, IVirtualMachineProvider
{
    public override string Path => "/providers/Microsoft.Compute/virtualMachines?api-version=2021-11-01";
    public override HttpMethod HttpMethod => HttpMethod.Get;

    public VirtualMachineProvider(IHttpClientFactory httpClientFactory, RestClient restClient) : base(httpClientFactory, restClient)
    {
    }
}