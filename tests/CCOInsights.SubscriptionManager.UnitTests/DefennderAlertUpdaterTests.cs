using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.DefenderAlert;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{
    public class DefenderAlertUpdaterTests
    {
        private readonly IDefenderAlertUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<DefenderAlertUpdater>> _loggerMock;
        private readonly Mock<IDefenderAlertProvider> _providerMock;

        public DefenderAlertUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<DefenderAlertUpdater>>();
            _providerMock = new Mock<IDefenderAlertProvider>();
            _updater = new DefenderAlertUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task DefenderAlertUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new DefenderAlertResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderAlertResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<DefenderAlert>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
