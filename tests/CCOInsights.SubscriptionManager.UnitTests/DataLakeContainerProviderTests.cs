using CCOInsights.SubscriptionManager.Functions.Operations.AdvisorScore;

namespace CCOInsights.SubscriptionManager.UnitTests;

public class DataLakeContainerProviderTests
{
    [Fact]
    public void DataLakeContainerProvider_DataLakeContainerName_ShouldBeEqual()
    {
        const string expected = "advisorscores";

        var actual = DataLakeContainerProvider.GetContainer(typeof(AdvisorScore));

        Assert.Equal(expected, actual);
    }
}
