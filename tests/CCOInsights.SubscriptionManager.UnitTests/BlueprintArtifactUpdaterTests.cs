using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.BlueprintArtifacts;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class BlueprintArtifactUpdaterTests
{
    private readonly IBlueprintArtifactUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<BlueprintArtifactUpdater>> _loggerMock;
    private readonly Mock<IBlueprintArtifactProvider> _providerMock;

    public BlueprintArtifactUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<BlueprintArtifactUpdater>>();
        _providerMock = new Mock<IBlueprintArtifactProvider>();
        _updater = new BlueprintArtifactUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task BlueprintArtifactUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new BlueprintArtifactsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<BlueprintArtifactsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<BlueprintArtifacts>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
