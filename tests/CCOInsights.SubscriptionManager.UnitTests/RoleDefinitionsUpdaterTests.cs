using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class RoleDefinitionsUpdaterTests
{
    private readonly IRoleDefinitionsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<RoleDefinitionsUpdater>> _loggerMock;
    private readonly Mock<IRoleDefinitionsProvider> _providerMock;

    public RoleDefinitionsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<RoleDefinitionsUpdater>>();
        _providerMock = new Mock<IRoleDefinitionsProvider>();
        _updater = new RoleDefinitionsUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task SubAssessmentUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new RoleDefinitionsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<RoleDefinitionsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<RoleDefinitions>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
