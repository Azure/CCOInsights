using CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class PolicySetDefinitionsUpdaterTests
{
    private readonly IPolicySetDefinitionsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IPolicySetDefinitionProvider> _providerMock;

    public PolicySetDefinitionsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<PolicySetDefinitionsUpdater>> loggerMock = new();
        _providerMock = new Mock<IPolicySetDefinitionProvider>();
        _updater = new PolicySetDefinitionsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new PolicySetDefinitionsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<PolicySetDefinitionsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(PolicySetDefinitions).ToLower()}", It.Is<List<PolicySetDefinitions>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
