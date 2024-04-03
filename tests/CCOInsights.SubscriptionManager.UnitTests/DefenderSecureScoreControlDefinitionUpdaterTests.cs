using CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DefenderSecureScoreControlDefinitionUpdaterTests
{
    private readonly IDefenderSecureScoreControlDefinitionUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<DefenderSecureScoreControlDefinitionUpdater>> _loggerMock;
    private readonly Mock<IDefenderSecureScoreControlDefinitionProvider> _providerMock;

    public DefenderSecureScoreControlDefinitionUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<DefenderSecureScoreControlDefinitionUpdater>>();
        _providerMock = new Mock<IDefenderSecureScoreControlDefinitionProvider>();
        _updater = new DefenderSecureScoreControlDefinitionUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DefenderSecureScoreControlDefinitionResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderSecureScoreControlDefinitionResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(DefenderSecureScoreControlDefinition).ToLower()}s", It.IsAny<List<DefenderSecureScoreControlDefinition>>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
