using CCOInsights.SubscriptionManager.Functions.Operations.VirtualNetworks;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class VirtualNetworksUpdaterTests
{
    private readonly IVirtualNetworksUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IVirtualNetworksProvider> _providerMock;

    public VirtualNetworksUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<VirtualNetworksUpdater>> loggerMock = new();
        _providerMock = new Mock<IVirtualNetworksProvider>();
        _updater = new VirtualNetworksUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new VirtualNetworksResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<VirtualNetworksResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(VirtualNetworks).ToLower()}", It.Is<List<VirtualNetworks>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
