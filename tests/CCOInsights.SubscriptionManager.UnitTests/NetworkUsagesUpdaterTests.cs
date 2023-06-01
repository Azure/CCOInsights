using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.NetworkUsages;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{

    public class NetworkUsagesUpdaterTests
    {
        private readonly INetworkUsagesUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<NetworkUsagesUpdater>> _loggerMock;
        private readonly Mock<INetworkUsagesProvider> _providerMock;


        public NetworkUsagesUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<NetworkUsagesUpdater>>();
            _providerMock = new Mock<INetworkUsagesProvider>();
            _updater = new NetworkUsagesUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task LocationUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new NetworkUsagesResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<NetworkUsagesResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<NetworkUsages>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
