using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachineExtensions;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class VirtualMachineExtensionUpdaterTests
{
    private readonly IVirtualMachineExtensionUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IVirtualMachineExtensionProvider> _providerMock;

    public VirtualMachineExtensionUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<VirtualMachineExtensionsUpdater>> loggerMock = new();
        _providerMock = new Mock<IVirtualMachineExtensionProvider>();
        _updater = new VirtualMachineExtensionsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new VirtualMachineExtensionsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<VirtualMachineExtensionsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(VirtualMachineExtensions).ToLower()}", It.Is<List<VirtualMachineExtensions>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
