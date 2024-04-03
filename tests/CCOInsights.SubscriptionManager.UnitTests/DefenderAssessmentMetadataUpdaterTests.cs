using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.DefenderAssessmentsMetadata;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DefenderAssessmentMetadataUpdaterTests
{
    private readonly IDefenderAssessmentsMetadataUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<DefenderAssessmentsMetadataUpdater>> _loggerMock;
    private readonly Mock<IDefenderAssessmentsMetadataProvider> _providerMock;

    public DefenderAssessmentMetadataUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<DefenderAssessmentsMetadataUpdater>>();
        _providerMock = new Mock<IDefenderAssessmentsMetadataProvider>();
        _updater = new DefenderAssessmentsMetadataUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task DefenderAssessmentMetadataUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new DefenderAssessmentsMetadataResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<DefenderAssessmentsMetadataResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<DefenderAssessmentsMetadata>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
