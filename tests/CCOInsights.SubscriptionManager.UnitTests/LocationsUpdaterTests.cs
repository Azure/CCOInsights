using CCOInsights.SubscriptionManager.Functions.Operations.Location;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class LocationsUpdaterTests
{
    private readonly ILocationUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILocationProvider> _providerMock;

    public LocationsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<LocationUpdater>> loggerMock = new();
        _providerMock = new Mock<ILocationProvider>();
        _updater = new LocationUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new LocationResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<LocationResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(Location).ToLower()}s", It.Is<List<Location>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
