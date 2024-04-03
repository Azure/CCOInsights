using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class PolicyStateUpdaterTests
{
    private readonly IPolicyStateUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<PolicyStateUpdater>> _loggerMock;
    private readonly Mock<IPolicyStateProvider> _providerMock;

    public PolicyStateUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<PolicyStateUpdater>>();
        _providerMock = new Mock<IPolicyStateProvider>();
        _updater = new PolicyStateUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task PolicyStateUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new AzurePolicyStateResponseValue { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<AzurePolicyStateResponseValue> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<PolicyState>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
