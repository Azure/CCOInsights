using CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class StorageUsageUpdaterTests
{
    private readonly IStorageUsageUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IStorageUsageProvider> _providerMock;

    public StorageUsageUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<StorageUsageUpdater>> loggerMock = new();
        _providerMock = new Mock<IStorageUsageProvider>();
        _updater = new StorageUsageUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new StorageUsageResponse { Name = new StorageUsageName { Value = "StorageUsage" } };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<StorageUsageResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(StorageUsage).ToLower()}s", It.Is<List<StorageUsage>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
