using CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class NetworkUsagesUpdaterTests
{
    private readonly INetworkUsagesUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<INetworkUsagesProvider> _providerMock;


    public NetworkUsagesUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<NetworkUsagesUpdater>> loggerMock = new();
        _providerMock = new Mock<INetworkUsagesProvider>();
        _updater = new NetworkUsagesUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new NetworkUsagesResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<NetworkUsagesResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(NetworkUsages).ToLower()}", It.Is<List<NetworkUsages>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
