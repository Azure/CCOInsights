using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControl;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{
    public class DefenderSecureScoreControlUpdaterTests
    {
        private readonly IDefenderSecureScoreControlUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<DefenderSecureScoreControlUpdater>> _loggerMock;
        private readonly Mock<IDefenderSecureScoreControlProvider> _providerMock;

        public DefenderSecureScoreControlUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<DefenderSecureScoreControlUpdater>>();
            _providerMock = new Mock<IDefenderSecureScoreControlProvider>();
            _updater = new DefenderSecureScoreControlUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task DefenderSecureScoreControlUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new DefenderSecureScoreControlResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderSecureScoreControlResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<DefenderSecureScoreControl>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
