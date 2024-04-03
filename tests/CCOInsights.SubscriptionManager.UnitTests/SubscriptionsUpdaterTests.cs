using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.Subscriptions;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class SubscriptionsUpdaterTests
{
    private readonly ISubscriptionsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<SubscriptionsUpdater>> _loggerMock;
    private readonly Mock<ISubscriptionProvider> _providerMock;

    public SubscriptionsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<SubscriptionsUpdater>>();
        _providerMock = new Mock<ISubscriptionProvider>();
        _updater = new SubscriptionsUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task SubscriptionUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new SubscriptionsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<SubscriptionsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<Subscriptions>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
