using CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessment;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DefenderAssessmentUpdaterTests
{
    private readonly IDefenderAssessmentUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IDefenderAssessmentProvider> _providerMock;

    public DefenderAssessmentUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<DefenderAssessmentUpdater>> loggerMock = new();
        _providerMock = new Mock<IDefenderAssessmentProvider>();
        _updater = new DefenderAssessmentUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DefenderAssessmentResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderAssessmentResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(DefenderAssessment).ToLower()}s", It.Is<List<DefenderAssessment>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
