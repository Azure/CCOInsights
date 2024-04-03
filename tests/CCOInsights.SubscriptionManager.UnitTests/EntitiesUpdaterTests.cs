using CCOInsights.SubscriptionManager.Functions.Operations.Entity;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class EntitiesUpdaterTests
{
    private readonly IEntitiesUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IEntityProvider> _providerMock;

    public EntitiesUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<EntityUpdater>> loggerMock = new();
        _providerMock = new Mock<IEntityProvider>();
        _updater = new EntityUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new EntityResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<EntityResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"entities", It.IsAny<List<Entity>>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
