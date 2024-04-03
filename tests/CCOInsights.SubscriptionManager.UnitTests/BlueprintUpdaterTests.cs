using CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class BlueprintUpdaterTests
{
    private readonly IBlueprintUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IBlueprintProvider> _providerMock;

    public BlueprintUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<BlueprintUpdater>> loggerMock = new();
        _providerMock = new Mock<IBlueprintProvider>();
        _updater = new BlueprintUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new BlueprintResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<BlueprintResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(Blueprint).ToLower()}s", It.Is<List<Blueprint>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
