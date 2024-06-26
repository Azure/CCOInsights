using CCOInsights.SubscriptionManager.Functions.Operations.PolicyDefinitions;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class PolicyDefinitionsUpdaterTests
{
    private readonly IPolicyDefinitionsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IPolicyDefinitionProvider> _providerMock;

    public PolicyDefinitionsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<PolicyDefinitionsUpdater>> loggerMock = new();
        _providerMock = new Mock<IPolicyDefinitionProvider>();
        _updater = new PolicyDefinitionsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task ShouldUpdate_IfValid()
    {
        var response = new PolicyDefinitionResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<PolicyDefinitionResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(
            x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(PolicyDefinitions).ToLower()}",
                It.Is<List<PolicyDefinitions>>(x => x.Any(item =>
                    item.SubscriptionId == subscriptionTest.SubscriptionId &&
                    item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
