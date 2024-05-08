using CCOInsights.SubscriptionManager.Functions.Operations.GenericResource;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.GenericResource.Update;
using Microsoft.Azure.Management.ResourceManager.Fluent.Models;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class ResourcesUpdaterTests
{
    private readonly IResourcesUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IGenericResourceProvider> _providerMock;

    public ResourcesUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<GenericResourceUpdater>> loggerMock = new();
        _providerMock = new Mock<IGenericResourceProvider>();

        _updater = new GenericResourceUpdater(_storageMock.Object, loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new GenericResourceResponse { Inner = new GenericResourceInner(id: "Id"), GenericResource = new GenericResourceTest() };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<GenericResourceResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(GenericResource).ToLower()}s", It.Is<List<GenericResource>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}

public class GenericResourceTest : IGenericResource
{
    public string Key => "Key";
    public string Id => "Id";
    public string Name => "Name";
    public string Type => "Type";
    public string RegionName => "RegionName";
    public Region Region => Region.USWest;
    public IReadOnlyDictionary<string, string> Tags => new Dictionary<string, string>();
    public string ResourceGroupName => "ResourceGroupName";
    public IResourceManager Manager => throw new System.NotImplementedException();
    public GenericResourceInner Inner => new();
    public IGenericResource Refresh() => throw new System.NotImplementedException();
    public Task<IGenericResource> RefreshAsync(CancellationToken cancellationToken = new()) => throw new System.NotImplementedException();
    public IWithApiVersion Update() => throw new System.NotImplementedException();
    public string ResourceProviderNamespace => "ResourceProviderNamespace";
    public string ParentResourceId => "ParentResourceId";
    public string ResourceType => "ResourceType";
    public string ApiVersion => "ApiVersion";
    public Plan Plan => new();
    public object Properties => "Properties";
}
