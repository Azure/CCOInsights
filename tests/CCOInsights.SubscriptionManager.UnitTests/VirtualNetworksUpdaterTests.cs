using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.VirtualNetworks;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{

    public class VirtualNetworksUpdaterTests
    {
        private readonly IVirtualNetworksUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<VirtualNetworksUpdater>> _loggerMock;
        private readonly Mock<IVirtualNetworksProvider> _providerMock;

        public VirtualNetworksUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<VirtualNetworksUpdater>>();
            _providerMock = new Mock<IVirtualNetworksProvider>();
            _updater = new VirtualNetworksUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task VirtualNetworksUpdaterUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new VirtualNetworksResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<VirtualNetworksResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<VirtualNetworks>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
