using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.Entity;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class EntitiesUpdaterTests
{
    private readonly IEntitiesUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<EntityUpdater>> _loggerMock;
    private readonly Mock<IEntityProvider> _providerMock;

    public EntitiesUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<EntityUpdater>>();
        _providerMock = new Mock<IEntityProvider>();
        _updater = new EntityUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task EntitiesUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new EntityResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<EntityResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<Entity>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
