using CCOInsights.SubscriptionManager.Functions.Operations.KeyVault;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class KeyVaultUpdaterTests
{
    private readonly IKeyVaultUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IKeyVaultProvider> _providerMock;

    public KeyVaultUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<KeyVaultUpdater>> loggerMock = new();
        _providerMock = new Mock<IKeyVaultProvider>();
        _updater = new KeyVaultUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdateNics_IfValid()
    {
        var response = new KeyVaultResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<KeyVaultResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(KeyVault).ToLower()}s", It.Is<List<KeyVault>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task UpdateAsync_ShouldNotUpdateNics_IfNotValid()
    {
        KeyVaultResponse? response = null;
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<KeyVaultResponse?> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(KeyVault).ToLower()}s", It.IsAny<List<KeyVault>>(), It.IsAny<CancellationToken>()), Times.Never);
    }
}
