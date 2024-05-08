using CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class PublicIPUpdaterTests
{
    private readonly IPublicIPUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IPublicIPProvider> _providerMock;

    public PublicIPUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<PublicIPsUpdater>> loggerMock = new();
        _providerMock = new Mock<IPublicIPProvider>();
        _updater = new PublicIPsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new PublicIPsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<PublicIPsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(PublicIPs).ToLower()}", It.Is<List<PublicIPs>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
