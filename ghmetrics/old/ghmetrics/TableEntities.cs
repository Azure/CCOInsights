using Azure;
using Azure.Data.Tables;


namespace ghmetrics.exports
{
    public class GhDataTableEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }

        public string? RepoName { get; set; }
        public string? Owner { get; set; }
        public int? ForksCount { get; set; }
        public int? StarsCount { get; set; }
        public int? ClonesCount { get; set; }
        public int? ViewsCount { get; set; }
    }

    // Fork entity
    public class ForkEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Forks";
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Secondary fork entity
    public class SecondaryForkEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "SecondaryForks";
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Pull request entity
    public class PullRequestEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public string? Title { get; set; }
        public string? User { get; set; }
        public string? State { get; set; }
        public string? CreatedAt { get; set; }
        public int Additions { get; set; }
        public int Deletions { get; set; }
        public int ChangedFiles { get; set; }
        public string? ClosedAt { get; set; }
        public string? MergedAt { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Stargazer entity
    public class StargazerEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Stargazers";
        public string RowKey { get; set; } = default!;
        public string? AvatarUrl { get; set; }
        public string? HtmlUrl { get; set; }
        public string? Type { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Contributor entity
    public class ContributorEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Contributors";
        public string RowKey { get; set; } = default!;
        public string? AvatarUrl { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Issue entity
    public class IssueEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Issues";
        public string RowKey { get; set; } = default!;
        public string? Title { get; set; }
        public string? User { get; set; }
        public string? State { get; set; }
        public string? CreatedAt { get; set; }
        public string? UpdatedAt { get; set; }
        public string? ClosedAt { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Release entity
    public class ReleaseEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Releases";
        public string RowKey { get; set; } = default!;
        public string? PublishedAt { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

}
