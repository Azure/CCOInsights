using CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControl;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DefenderSecureScoreControlUpdaterTests
{
    private readonly IDefenderSecureScoreControlUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IDefenderSecureScoreControlProvider> _providerMock;

    public DefenderSecureScoreControlUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<DefenderSecureScoreControlUpdater>> loggerMock = new();
        _providerMock = new Mock<IDefenderSecureScoreControlProvider>();
        _updater = new DefenderSecureScoreControlUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DefenderSecureScoreControlResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderSecureScoreControlResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(DefenderSecureScoreControl).ToLower()}s", It.Is<List<DefenderSecureScoreControl>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
