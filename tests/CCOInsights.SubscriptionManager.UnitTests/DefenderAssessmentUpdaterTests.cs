using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessment;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{
    public class DefenderAssessmentUpdaterTests
    {
        private readonly IDefenderAssessmentUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<DefenderAssessmentUpdater>> _loggerMock;
        private readonly Mock<IDefenderAssessmentProvider> _providerMock;

        public DefenderAssessmentUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<DefenderAssessmentUpdater>>();
            _providerMock = new Mock<IDefenderAssessmentProvider>();
            _updater = new DefenderAssessmentUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task DefenderAssessmentUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new DefenderAssessmentResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderAssessmentResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<DefenderAssessment>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
