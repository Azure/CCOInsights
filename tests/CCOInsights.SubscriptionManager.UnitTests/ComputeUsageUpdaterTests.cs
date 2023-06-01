using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.ComputeUsage;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class ComputeUsageUpdaterTests
{
    private readonly IComputeUsageUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<ComputeUsageUpdater>> _loggerMock;
    private readonly Mock<IComputeUsageProvider> _providerMock;

    public ComputeUsageUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<ComputeUsageUpdater>>();
        _providerMock = new Mock<IComputeUsageProvider>();
        _updater = new ComputeUsageUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task ComputeUsageUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new ComputeUsageResponse { Name = new ComputeUsageName { Value = "ComputeUsage" } };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<ComputeUsageResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<ComputeUsage>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
