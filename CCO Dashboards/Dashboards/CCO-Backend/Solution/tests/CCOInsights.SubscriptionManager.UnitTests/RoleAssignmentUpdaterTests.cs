using CCOInsights.SubscriptionManager.Functions.Operations.RoleAssignment;
using Microsoft.DurableTask;


namespace CCOInsights.SubscriptionManager.UnitTests;

public class RoleAssignmentUpdaterTests
{
    private readonly IRoleAssignmentUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<IRoleAssignmentProvider> _roleAssignmentProviderMock;
    private readonly Mock<IUsersProvider> _usersProviderMock;

    public RoleAssignmentUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        Mock<ILogger<RoleAssignmentUpdater>> loggerMock = new();

        _roleAssignmentProviderMock = new Mock<IRoleAssignmentProvider>();
        _usersProviderMock = new Mock<IUsersProvider>();
        var durableContextMock = new Mock<TaskOrchestrationContext>();
        durableContextMock.SetupGet(prop => prop.InstanceId).Returns("FakeExecution");
        _updater = new RoleAssignmentUpdater(_roleAssignmentProviderMock.Object, _usersProviderMock.Object, _storageMock.Object, loggerMock.Object);
    }

    [Fact]
    public async Task UpdateAsync_ShouldUpdate_IfValid()
    {
        var roleAssignmentResponse = new RoleAssignmentResponse { Id = "Id", Properties = new RoleAssignmentProperties { PrincipalId = "PrincipalId" } };
        _roleAssignmentProviderMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<RoleAssignmentResponse> { roleAssignmentResponse });
        var userResponse = new UserResponse { Id = "Id" };
        _usersProviderMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<UserResponse> { userResponse });
        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _roleAssignmentProviderMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _usersProviderMock.Verify(x => x.GetAsync(It.Is<string>(x => x == roleAssignmentResponse.Properties.PrincipalId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), $"{nameof(RoleAssignment).ToLower()}s", It.Is<List<RoleAssignment>>(x => x.Any(item => item.SubscriptionId == subscriptionTest.SubscriptionId && item.TenantId == subscriptionTest.Inner.TenantId)), It.IsAny<CancellationToken>()), Times.Once);
    }
}
