using System.Text.Json.Serialization;
using static ghmetrics.metrics.metricsCalculator;

namespace ghmetrics.github;

[JsonSerializable(typeof(GHExtractionResult[]))]
internal partial class GithubExtractionSerializerContext : JsonSerializerContext
{

}

[JsonSerializable(typeof(AllMetricsForAllPeriodsDto[]))]
internal partial class MetricsJsonSerializerContext : JsonSerializerContext
{

}
