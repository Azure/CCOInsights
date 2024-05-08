using CCOInsights.SubscriptionManager.Functions.Operations.AdvisorScore;
using DurableTask.Core.Common;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class AdvisorScoreUpdaterTests
{
    private readonly IAdvisorScoreUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IAdvisorScoreProvider> _providerMock;

    public AdvisorScoreUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<AdvisorScoreUpdater>> loggerMock = new();
        _providerMock = new Mock<IAdvisorScoreProvider>();
        _updater = new AdvisorScoreUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new AdvisorScoreResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<AdvisorScoreResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        //entities.FirstOrDefault().GetType().Name.ToLower()
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(AdvisorScore).ToLower()}s", It.Is<List<AdvisorScore>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
