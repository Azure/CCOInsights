using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class VirtualMachineUpdaterTests
{
    private readonly IVirtualMachineUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<VirtualMachineUpdater>> _loggerMock;
    private readonly Mock<IVirtualMachineProvider> _providerMock;

    public VirtualMachineUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<VirtualMachineUpdater>>();
        _providerMock = new Mock<IVirtualMachineProvider>();
        _updater = new VirtualMachineUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task VirtualMachineUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new VirtualMachineResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<VirtualMachineResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<VirtualMachine>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
