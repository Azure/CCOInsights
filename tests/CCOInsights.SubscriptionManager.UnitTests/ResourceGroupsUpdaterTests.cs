using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.ResourceGroup;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class ResourceGroupsUpdaterTests
{
    private readonly IResourceGroupUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<ResourceGroupUpdater>> _loggerMock;
    private readonly Mock<IResourceGroupProvider> _providerMock;

    public ResourceGroupsUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<ResourceGroupUpdater>>();
        _providerMock = new Mock<IResourceGroupProvider>();
        _updater = new ResourceGroupUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task ResourceGroupUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new ResourceGroupResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<ResourceGroupResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<ResourceGroup>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
