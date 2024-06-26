using CCOInsights.SubscriptionManager.Functions.Operations.Pricing;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class PricingUpdaterTests
{
    private readonly IPricingUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IPricingProvider> _providerMock;

    public PricingUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<PricingUpdater>> loggerMock = new();
        _providerMock = new Mock<IPricingProvider>();
        _updater = new PricingUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new PricingResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<PricingResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(Pricing).ToLower()}s", It.Is<List<Pricing>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
