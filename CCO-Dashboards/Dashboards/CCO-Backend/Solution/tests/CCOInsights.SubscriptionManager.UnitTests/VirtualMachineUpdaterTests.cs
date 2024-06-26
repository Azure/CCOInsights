using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachine;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class VirtualMachineUpdaterTests
{
    private readonly IVirtualMachineUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IVirtualMachineProvider> _providerMock;

    public VirtualMachineUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<VirtualMachineUpdater>> loggerMock = new();
        _providerMock = new Mock<IVirtualMachineProvider>();
        _updater = new VirtualMachineUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new VirtualMachineResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<VirtualMachineResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(VirtualMachine).ToLower()}s", It.Is<List<VirtualMachine>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
