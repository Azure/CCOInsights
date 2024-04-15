using CCOInsights.SubscriptionManager.Functions.Operations.BlueprintPublished;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class BlueprintPublishedUpdaterTests
{
    private readonly IBlueprintPublishedUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<BlueprintPublishedUpdater>> _loggerMock;
    private readonly Mock<IBlueprintPublishedProvider> _providerMock;

    public BlueprintPublishedUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<BlueprintPublishedUpdater>>();
        _providerMock = new Mock<IBlueprintPublishedProvider>();
        _updater = new BlueprintPublishedUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new BlueprintPublishedResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<BlueprintPublishedResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(BlueprintPublished).ToLower()}s", It.Is<List<BlueprintPublished>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
