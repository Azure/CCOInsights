using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests
{
    public class RoleAssignmentUpdaterTests
    {
        private readonly IRoleAssignmentUpdater _updater;
        private readonly Mock<IStorage> _storageMock;
        private readonly Mock<ILogger<RoleAssignmentUpdater>> _loggerMock;
        private readonly Mock<IRoleAssignmentProvider> _roleAssignmentProviderMock;
        private readonly Mock<IUsersProvider> _usersProviderMock;

        public RoleAssignmentUpdaterTests()
        {
            _storageMock = new Mock<IStorage>();
            _loggerMock = new Mock<ILogger<RoleAssignmentUpdater>>();

            _roleAssignmentProviderMock = new Mock<IRoleAssignmentProvider>();
            _usersProviderMock = new Mock<IUsersProvider>();
            var durableContextMock = new Mock<IDurableActivityContext>();
            durableContextMock.SetupGet(prop => prop.InstanceId).Returns("FakeExecution");
            _updater = new RoleAssignmentUpdater(_roleAssignmentProviderMock.Object, _usersProviderMock.Object, _storageMock.Object, durableContextMock.Object, _loggerMock.Object);
        }

        [Fact]
        public async Task RoleAssignmentUpdater_UpdateAsync_ShouldUpdate_IfValid()
        {
            var roleAssignmentResponse = new RoleAssignmentResponse { Id = "Id", Properties = new RoleAssignmentProperties { PrincipalId = "PrincipalId" } };
            _roleAssignmentProviderMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<RoleAssignmentResponse> { roleAssignmentResponse });
            var userResponse = new UserResponse { Id = "Id" };
            _usersProviderMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<UserResponse> { userResponse });
            var subscriptionTest = new TestSubscription();
            await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

            _roleAssignmentProviderMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
            _usersProviderMock.Verify(x => x.GetAsync(It.Is<string>(x => x == roleAssignmentResponse.Properties.PrincipalId), CancellationToken.None));
            _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.Is<RoleAssignment>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
        }
    }
}
