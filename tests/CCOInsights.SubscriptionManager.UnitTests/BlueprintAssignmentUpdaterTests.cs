using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class BlueprintAssignmentUpdaterTests
{
    private readonly IBlueprintAssignmentsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<BlueprintAssignmentsUpdater>> _loggerMock;
    private readonly Mock<IBlueprintAssignmentsProvider> _providerMock;

    public BlueprintAssignmentUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<BlueprintAssignmentsUpdater>>();
        _providerMock = new Mock<IBlueprintAssignmentsProvider>();
        _updater = new BlueprintAssignmentsUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task BlueprintAssignmentUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new BlueprintAssignmentsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<BlueprintAssignmentsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<BlueprintAssignments>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
