using CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class SubAssessmentUpdaterTests
{
    private readonly ISubAssessmentUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ISubAssessmentProvider> _providerMock;

    public SubAssessmentUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<SubAssessmentUpdater>> loggerMock = new();
        _providerMock = new Mock<ISubAssessmentProvider>();
        _updater = new SubAssessmentUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new SubAssessmentResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<SubAssessmentResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(SubAssessment).ToLower()}s", It.Is<List<SubAssessment>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
