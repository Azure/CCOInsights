using CCOInsights.SubscriptionManager.Functions.Operations.Nic;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class NicsUpdaterTests
{
    private readonly INicsUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<INicProvider> _providerMock;

    public NicsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<NicsUpdater>> loggerMock = new();
        _providerMock = new Mock<INicProvider>();
        _updater = new NicsUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdateNics_IfValid()
    {
        var azureNicResponse = new NicResponse { Id = "Id", NicProperties = new NicProperties { VirtualMachine = new NetworkSecurityGroup { NetworkSecurityGroupId = "Id" } } };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<NicResponse> { azureNicResponse });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(Nic).ToLower()}s", It.Is<List<Nic>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task UpdateAsync_ShouldNotUpdateNics_IfNotValid()
    {
        var azureNicResponse = new NicResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<NicResponse> { azureNicResponse });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(Nic).ToLower()}", It.IsAny<List<Nic>>(), It.IsAny<CancellationToken>()), Times.Never);
    }
}
