using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.Blueprint;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class BlueprintUpdaterTests
{
    private readonly IBlueprintUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<BlueprintUpdater>> _loggerMock;
    private readonly Mock<IBlueprintProvider> _providerMock;

    public BlueprintUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<BlueprintUpdater>>();
        _providerMock = new Mock<IBlueprintProvider>();
        _updater = new BlueprintUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task BlueprintUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new BlueprintResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<BlueprintResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<Blueprint>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
