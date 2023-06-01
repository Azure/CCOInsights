using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.VirtualMachinePatch;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{
    public class VirtualMachinePatchUpdaterTests
    {
        private readonly IVirtualMachinePatchUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<VirtualMachinePatchUpdater>> _loggerMock;
        private readonly Mock<IVirtualMachinePatchProvider> _providerMock;

        public VirtualMachinePatchUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<VirtualMachinePatchUpdater>>();
            _providerMock = new Mock<IVirtualMachinePatchProvider>();
            _updater = new VirtualMachinePatchUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task VirtualMachinePatchUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new VirtualMachinePatchResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<VirtualMachinePatchResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<VirtualMachinePatch>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
