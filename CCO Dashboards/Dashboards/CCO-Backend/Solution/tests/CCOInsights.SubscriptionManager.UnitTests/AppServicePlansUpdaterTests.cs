using CCOInsights.SubscriptionManager.Functions.Operations.AppServicePlans;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class AppServicePlansUpdaterTests
{
    private readonly IAppServicePlansUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IAppServicePlansProvider> _providerMock;

    public AppServicePlansUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<AppServicePlansUpdater>> loggerMock = new();
        _providerMock = new Mock<IAppServicePlansProvider>();
        _updater = new AppServicePlansUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new AppServicePlansResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<AppServicePlansResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(AppServicePlans).ToLower()}", It.Is<List<AppServicePlans>>(x => x.Any(item => item.SubscriptionId== subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
