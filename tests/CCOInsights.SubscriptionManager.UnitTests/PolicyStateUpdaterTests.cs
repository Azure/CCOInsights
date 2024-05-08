using CCOInsights.SubscriptionManager.Functions.Operations.PolicyState;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class PolicyStateUpdaterTests
{
    private readonly IPolicyStateUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IPolicyStateProvider> _providerMock;

    public PolicyStateUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<PolicyStateUpdater>> loggerMock = new();
        _providerMock = new Mock<IPolicyStateProvider>();
        _updater = new PolicyStateUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new AzurePolicyStateResponseValue { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<AzurePolicyStateResponseValue> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(PolicyState).ToLower()}s", It.Is<List<PolicyState>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
