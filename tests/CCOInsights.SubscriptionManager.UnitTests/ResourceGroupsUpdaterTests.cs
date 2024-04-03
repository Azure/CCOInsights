using CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class ResourceGroupsUpdaterTests
{
    private readonly IResourceGroupUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IResourceGroupProvider> _providerMock;

    public ResourceGroupsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<ResourceGroupUpdater>> loggerMock = new();
        _providerMock = new Mock<IResourceGroupProvider>();
        _updater = new ResourceGroupUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new ResourceGroupResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<ResourceGroupResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(ResourceGroup).ToLower()}s", It.Is<List<ResourceGroup>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
