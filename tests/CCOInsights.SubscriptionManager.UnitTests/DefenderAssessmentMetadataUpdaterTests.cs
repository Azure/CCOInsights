using CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DefenderAssessmentMetadataUpdaterTests
{
    private readonly IDefenderAssessmentsMetadataUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IDefenderAssessmentsMetadataProvider> _providerMock;

    public DefenderAssessmentMetadataUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<DefenderAssessmentsMetadataUpdater>> loggerMock = new();
        _providerMock = new Mock<IDefenderAssessmentsMetadataProvider>();
        _updater = new DefenderAssessmentsMetadataUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DefenderAssessmentsMetadataResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderAssessmentsMetadataResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(DefenderAssessmentsMetadata).ToLower()}s", It.Is<List<DefenderAssessmentsMetadata>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
