using CCOInsights.SubscriptionManager.Functions.Operations.Disks;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DisksUpdaterTests
{
    private readonly IDisksUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IDisksProvider> _providerMock;

    public DisksUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<DisksUpdater>> loggerMock = new();
        _providerMock = new Mock<IDisksProvider>();
        _updater = new DisksUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DisksResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DisksResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(Disks).ToLower()}", It.Is<List<Disks>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
