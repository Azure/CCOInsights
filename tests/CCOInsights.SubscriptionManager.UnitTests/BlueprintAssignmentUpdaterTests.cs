using CCOInsights.SubscriptionManager.Functions.Operations.BlueprintAssignments;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class BlueprintAssignmentUpdaterTests
{
    private readonly IBlueprintAssignmentsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IBlueprintAssignmentsProvider> _providerMock;

    public BlueprintAssignmentUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<BlueprintAssignmentsUpdater>> loggerMock = new();
        _providerMock = new Mock<IBlueprintAssignmentsProvider>();
        _updater = new BlueprintAssignmentsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new BlueprintAssignmentsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<BlueprintAssignmentsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(BlueprintAssignments).ToLower()}", It.Is<List<BlueprintAssignments>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
