using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.DefenderSecureScoreControlDefinition;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DefenderSecureScoreControlDefinitionUpdaterTests
{
    private readonly IDefenderSecureScoreControlDefinitionUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<DefenderSecureScoreControlDefinitionUpdater>> _loggerMock;
    private readonly Mock<IDefenderSecureScoreControlDefinitionProvider> _providerMock;

    public DefenderSecureScoreControlDefinitionUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<DefenderSecureScoreControlDefinitionUpdater>>();
        _providerMock = new Mock<IDefenderSecureScoreControlDefinitionProvider>();
        _updater = new DefenderSecureScoreControlDefinitionUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task DefenderSecureScoreControlDefinitionUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DefenderSecureScoreControlDefinitionResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderSecureScoreControlDefinitionResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<DefenderSecureScoreControlDefinition>(), It.IsAny<CancellationToken>()), Times.Once);
    }
}
