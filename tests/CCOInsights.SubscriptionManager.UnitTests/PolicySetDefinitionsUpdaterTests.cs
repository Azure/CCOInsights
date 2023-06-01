using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.PolicySetDefinitions;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{
    public class PolicySetDefinitionsUpdaterTests
    {
        private readonly IPolicySetDefinitionsUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<PolicySetDefinitionsUpdater>> _loggerMock;
        private readonly Mock<IPolicySetDefinitionProvider> _providerMock;

        public PolicySetDefinitionsUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<PolicySetDefinitionsUpdater>>();
            _providerMock = new Mock<IPolicySetDefinitionProvider>();
            _updater = new PolicySetDefinitionsUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
        }

        [Fact]
        public async Task PolicySetDefinitionsUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var response = new PolicySetDefinitionsResponse { Id = "Id" };
            _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<PolicySetDefinitionsResponse> { response });

            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<PolicySetDefinitions>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
