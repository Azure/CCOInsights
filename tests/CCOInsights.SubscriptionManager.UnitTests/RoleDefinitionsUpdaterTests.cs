using CCOInsights.SubscriptionManager.Functions.Operations.RoleDefinitions;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class RoleDefinitionsUpdaterTests
{
    private readonly IRoleDefinitionsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IRoleDefinitionsProvider> _providerMock;

    public RoleDefinitionsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<RoleDefinitionsUpdater>> loggerMock = new();
        _providerMock = new Mock<IRoleDefinitionsProvider>();
        _updater = new RoleDefinitionsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new RoleDefinitionsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<RoleDefinitionsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(RoleDefinitions).ToLower()}", It.Is<List<RoleDefinitions>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
