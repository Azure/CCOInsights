using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class VirtualMachinePatchUpdaterTests
{
    private readonly IVirtualMachinePatchUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IVirtualMachinePatchProvider> _providerMock;

    public VirtualMachinePatchUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<VirtualMachinePatchUpdater>> loggerMock = new();
        _providerMock = new Mock<IVirtualMachinePatchProvider>();
        _updater = new VirtualMachinePatchUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new VirtualMachinePatchResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<VirtualMachinePatchResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(VirtualMachinePatch).ToLower()}s", It.Is<List<VirtualMachinePatch>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
