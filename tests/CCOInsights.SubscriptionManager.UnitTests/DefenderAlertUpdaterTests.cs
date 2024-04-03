using CCOInsights.SubscriptionManager.Functions.Operations.DefenderAlert;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DefenderAlertUpdaterTests
{
    private readonly IDefenderAlertUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IDefenderAlertProvider> _providerMock;

    public DefenderAlertUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<DefenderAlertUpdater>> loggerMock = new();
        _providerMock = new Mock<IDefenderAlertProvider>();
        _updater = new DefenderAlertUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DefenderAlertResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderAlertResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(DefenderAlert).ToLower()}s", It.Is<List<DefenderAlert>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
