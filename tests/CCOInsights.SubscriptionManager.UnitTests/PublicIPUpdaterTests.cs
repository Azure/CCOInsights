﻿using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.SubscriptionManager.Functions;
using CCOInsights.SubscriptionManager.Functions.Operations.PublicIPs;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class PublicIPUpdaterTests
{
    private readonly IPublicIPUpdater _updater;
    private readonly Mock<IStorage> _storageMock;
    private readonly Mock<ILogger<PublicIPsUpdater>> _loggerMock;
    private readonly Mock<IPublicIPProvider> _providerMock;

    public PublicIPUpdaterTests()
    {
        _storageMock = new Mock<IStorage>();
        _loggerMock = new Mock<ILogger<PublicIPsUpdater>>();
        _providerMock = new Mock<IPublicIPProvider>();
        _updater = new PublicIPsUpdater(_storageMock.Object, _loggerMock.Object, _providerMock.Object);
    }

    [Fact]
    public async Task PublicIPUpdater_UpdateAsync_ShouldUpdate_IfValid()
    {
        var response = new PublicIPsResponse { Id = "Id" };
        _providerMock.Setup(x => x.GetAsync(It.IsAny<string>(), It.IsAny<CancellationToken>())).ReturnsAsync(new List<PublicIPsResponse> { response });

        var subscriptionTest = new TestSubscription();
        await _updater.UpdateAsync(Guid.Empty.ToString(), subscriptionTest, CancellationToken.None);

        _providerMock.Verify(x => x.GetAsync(It.Is<string>(x => x == subscriptionTest.SubscriptionId), CancellationToken.None));
        _storageMock.Verify(x => x.UpdateItemAsync(It.IsAny<string>(), It.IsAny<string>(), It.Is<PublicIPs>(x => x.SubscriptionId == subscriptionTest.SubscriptionId && x.TenantId == subscriptionTest.Inner.TenantId), It.IsAny<CancellationToken>()), Times.Once);
    }
}
