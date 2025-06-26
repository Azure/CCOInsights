using System.Globalization;
using ghmetrics.github;

namespace ghmetrics.metrics
{
    public class metricsCalculator
    {
        public enum MetricsPeriod
        {
            LastMonth,
            LastThreeMonths,
            LastSixMonths,
            LastYear
        }

        public record ContributorMetric
        {
            public string? User { get; init; }
            public int ClosedPrCount { get; init; }
        }

        public record AllMetricsDto
        {
            public MetricsPeriod Period { get; init; }
            public double PrClosedRate { get; init; }
            public double IssuesClosedRate { get; init; }
            public double AverageCodingTimeDays { get; init; }
            public int NumberOfCommits { get; init; }
            public int ReviewsCompleted { get; init; }
            public List<ContributorMetric> TopTenContributors { get; init; } = new();

            // "Opened vs Closed" metrics
            public int OpenedPrCount { get; init; }
            public int ClosedPrCount { get; init; }
            public int OpenedIssuesCount { get; init; }
            public int ClosedIssuesCount { get; init; }

            // Forks vs Clones
            public int ForksCount { get; init; }
            public int ClonesCount { get; init; }

            // Additions vs Deletions
            public int TotalAdditions { get; init; }
            public int TotalDeletions { get; init; }
        }

        public record AllMetricsForAllPeriodsDto
        {
            public AllMetricsDto LastMonth { get; init; } = default!;
            public AllMetricsDto LastThreeMonths { get; init; } = default!;
            public AllMetricsDto LastSixMonths { get; init; } = default!;
            public AllMetricsDto LastYear { get; init; } = default!;
        }

        public AllMetricsForAllPeriodsDto CalculateAllMetrics(GHExtractionResult data)
        {
            return new AllMetricsForAllPeriodsDto
            {
                LastMonth = CalculateAllMetricsForPeriod(data, MetricsPeriod.LastMonth),
                LastThreeMonths = CalculateAllMetricsForPeriod(data, MetricsPeriod.LastThreeMonths),
                LastSixMonths = CalculateAllMetricsForPeriod(data, MetricsPeriod.LastSixMonths),
                LastYear = CalculateAllMetricsForPeriod(data, MetricsPeriod.LastYear)
            };
        }

        private AllMetricsDto CalculateAllMetricsForPeriod(GHExtractionResult data, MetricsPeriod period)
        {
            // Forks vs Clones (not date-specific in the current GHExtractionResult)
            int forkCount = data.Forks.Count + data.SecondaryForks.Count;
            int clonesCount = data.ClonesCount ?? 0;

            DateTime now = DateTime.UtcNow;
            DateTime periodStart = period switch
            {
                MetricsPeriod.LastMonth => now.AddMonths(-1),
                MetricsPeriod.LastThreeMonths => now.AddMonths(-3),
                MetricsPeriod.LastSixMonths => now.AddMonths(-6),
                MetricsPeriod.LastYear => now.AddYears(-1),
                _ => now.AddMonths(-1)
            };

            // Filter PRs created (opened) in this period
            var relevantPrsCreated = data.OpenPullRequests
                .Concat(data.ClosedPullRequests)
                .Where(pr => InRange(ParseDate(pr.CreatedAt), periodStart, now))
                .ToList();

            // Filter PRs actually closed in this period
            var relevantPrsClosed = relevantPrsCreated
                .Where(pr => !string.IsNullOrEmpty(pr.ClosedAt))
                .ToList();

            // PR closed rate
            double prClosedRate = relevantPrsCreated.Count == 0
                ? 0
                : (double)relevantPrsClosed.Count / relevantPrsCreated.Count;

            // Filter issues opened in this period
            var relevantIssuesCreated = data.Issues
                .Where(issue => InRange(ParseDate(issue.CreatedAt), periodStart, now))
                .ToList();

            // Filter issues closed in this period
            var relevantIssuesClosed = relevantIssuesCreated
                .Where(issue => !string.IsNullOrEmpty(issue.ClosedAt))
                .ToList();

            // Issues closed rate
            double issuesClosedRate = relevantIssuesCreated.Count == 0
                ? 0
                : (double)relevantIssuesClosed.Count / relevantIssuesCreated.Count;

            // Approximate average coding time (PR creation -> close)
            var closedPrsInPeriod = data.ClosedPullRequests
                .Where(pr =>
                    InRange(ParseDate(pr.CreatedAt), periodStart, now) &&
                    !string.IsNullOrEmpty(pr.ClosedAt))
                .ToList();

            double averageCodingTimeDays = 0;
            if (closedPrsInPeriod.Any())
            {
                double totalDays = 0;
                foreach (var pr in closedPrsInPeriod)
                {
                    var created = ParseDate(pr.CreatedAt);
                    var closed = ParseDate(pr.ClosedAt);
                    totalDays += (closed - created).TotalDays;
                }
                averageCodingTimeDays = totalDays / closedPrsInPeriod.Count;
            }

            // Placeholder commits & reviews
            int numberOfCommits = 0; 
            int reviewsCompleted = closedPrsInPeriod.Count;

            // Top ten contributors by closed PR count in this period
            var contributorGroups = closedPrsInPeriod
                .GroupBy(pr => pr.User ?? "Unknown User")
                .Select(g => new ContributorMetric
                {
                    User = g.Key,
                    ClosedPrCount = g.Count()
                })
                .OrderByDescending(c => c.ClosedPrCount)
                .Take(10)
                .ToList();

            // Additions vs Deletions (sum for PRs created in this period)
            int totalAdditions = relevantPrsCreated.Sum(pr => pr.Additions);
            int totalDeletions = relevantPrsCreated.Sum(pr => pr.Deletions);

            return new AllMetricsDto
            {
                Period = period,
                PrClosedRate = prClosedRate,
                IssuesClosedRate = issuesClosedRate,
                AverageCodingTimeDays = averageCodingTimeDays,
                NumberOfCommits = numberOfCommits,
                ReviewsCompleted = reviewsCompleted,
                TopTenContributors = contributorGroups,

                // PR opened vs closed
                OpenedPrCount = relevantPrsCreated.Count,
                ClosedPrCount = relevantPrsClosed.Count,

                // Issues opened vs closed
                OpenedIssuesCount = relevantIssuesCreated.Count,
                ClosedIssuesCount = relevantIssuesClosed.Count,

                // Forks vs Clones
                ForksCount = forkCount,
                ClonesCount = clonesCount,

                // Additions vs Deletions
                TotalAdditions = totalAdditions,
                TotalDeletions = totalDeletions
            };
        }

        private static bool InRange(DateTime date, DateTime start, DateTime end)
            => date >= start && date <= end;

        private static DateTime ParseDate(string? dateString)
            => DateTime.TryParse(dateString, CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal, out var dt)
                ? dt
                : DateTime.MinValue;
    }
}
