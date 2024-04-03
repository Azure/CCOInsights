using CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class BlueprintArtifactUpdaterTests
{
    private readonly IBlueprintArtifactUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IBlueprintArtifactProvider> _providerMock;

    public BlueprintArtifactUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<BlueprintArtifactUpdater>> loggerMock = new();
        _providerMock = new Mock<IBlueprintArtifactProvider>();
        _updater = new BlueprintArtifactUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new BlueprintArtifactsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<BlueprintArtifactsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(BlueprintArtifacts).ToLower()}", It.Is<List<BlueprintArtifacts>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
