namespace CCOInsights.SubscriptionManager.Functions.Operations.AppServicePlans;

[GeneratedProvider("/providers/Microsoft.Web/serverfarms?api-version=2022-03-01")]
public class AppServicePlansResponse : AzureResponse
{
    public string Kind { get; set; }
    public string Location { get; set; }
    public AppServicePlansProperties Properties { get; set; }
    public AppServicePlansSku Sku { get; set; }
}



public class AppServicePlansProperties
{
    public int? ServerFarmId { get; set; }
    public string Name { get; set; }
    public string WorkerSize { get; set; }
    public int? WorkerSizeId { get; set; }
    public object WorkerTierName { get; set; }
    public int? NumberOfWorkers { get; set; }
    public object CurrentWorkerSize { get; set; }
    public object CurrentWorkerSizeId { get; set; }
    public object CurrentNumberOfWorkers { get; set; }
    public string Status { get; set; }
    public string WebSpace { get; set; }
    public object Subscription { get; set; }
    public object AdminSiteName { get; set; }
    public object HostingEnvironment { get; set; }
    public object HostingEnvironmentProfile { get; set; }
    public int? MaximumNumberOfWorkers { get; set; }
    public string PlanName { get; set; }
    public object AdminRuntimeSiteName { get; set; }
    public string ComputeMode { get; set; }
    public object SiteMode { get; set; }
    public string GeoRegion { get; set; }
    public object PerSiteScaling { get; set; }
    public object ElasticScaleEnabled { get; set; }
    public object MaximumElasticWorkerCount { get; set; }
    public int? NumberOfSites { get; set; }
    public object HostingEnvironmentId { get; set; }
    public object IsSpot { get; set; }
    public object SpotExpirationTime { get; set; }
    public object FreeOfferExpirationTime { get; set; }
    public dynamic Tags { get; set; }
    public string Kind { get; set; }
    public string ResourceGroup { get; set; }
    public object Reserved { get; set; }
    public object IsXenon { get; set; }
    public object HyperV { get; set; }
    public object MdmId { get; set; }
    public object TargetWorkerCount { get; set; }
    public object TargetWorkerSizeId { get; set; }
    public object ProvisioningState { get; set; }
    public object WebSiteId { get; set; }
    public object ExistingServerFarmIds { get; set; }
    public object KubeEnvironmentProfile { get; set; }
    public object ZoneRedundant { get; set; }
}



public class AppServicePlansSku
{
    public string Name { get; set; }
    public string Tier { get; set; }
    public string Size { get; set; }
    public string Family { get; set; }
    public int? Capacity { get; set; }
}