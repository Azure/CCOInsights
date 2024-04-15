using CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class SubscriptionsUpdaterTests
{
    private readonly ISubscriptionsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ISubscriptionProvider> _providerMock;

    public SubscriptionsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<SubscriptionsUpdater>> loggerMock = new();
        _providerMock = new Mock<ISubscriptionProvider>();
        _updater = new SubscriptionsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new SubscriptionsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<SubscriptionsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(Subscriptions).ToLower()}", It.IsAny<List<Subscriptions>>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
