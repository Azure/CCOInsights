using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.SubAssessment;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{
    public class SubAssessmentUpdaterTests
    {
        private readonly ISubAssessmentUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<SubAssessmentUpdater>> _loggerMock;
        private readonly Mock<ISubAssessmentProvider> _providerMock;

        public SubAssessmentUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<SubAssessmentUpdater>>();
            _providerMock = new Mock<ISubAssessmentProvider>();
            _updater = new SubAssessmentUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task SubAssessmentUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new SubAssessmentResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<SubAssessmentResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<SubAssessment>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
