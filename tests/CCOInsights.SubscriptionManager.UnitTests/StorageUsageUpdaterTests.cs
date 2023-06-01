using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.StorageUsage;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class StorageUsageUpdaterTests
{
    private readonly IStorageUsageUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<StorageUsageUpdater>> _loggerMock;
    private readonly Mock<IStorageUsageProvider> _providerMock;

    public StorageUsageUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<StorageUsageUpdater>>();
        _providerMock = new Mock<IStorageUsageProvider>();
        _updater = new StorageUsageUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task StorageUsageUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new StorageUsageResponse { Name = new StorageUsageName { Value = "StorageUsage" } };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<StorageUsageResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<StorageUsage>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
