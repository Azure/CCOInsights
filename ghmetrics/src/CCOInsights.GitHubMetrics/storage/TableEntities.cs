using Azure;
using Azure.Data.Tables;


namespace CCOInsights.GithubMetrics.exports
{
    public class RepositoryEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
        public string Id { get; set; }
        public string? FullName { get; set; }
        public string? Name { get; set; }
        public string? Owner { get; set; }
        public int? OpenIssues { get; set; }
        public int? Forks { get; set; }
        public int? Stargazers { get; set; }
        public int? Watchers { get; set; }
        public int? Clones { get; set; }
        public int? Views { get; set; }
        public string? CreatedAt { get; set; }
    }

    // Fork entity
    public class ForkEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Forks";
        public string RowKey { get; set; } = default!;
        public string Id { get; set; } = default!;
        public string FullName { get; set; } = default!;
        public string Owner { get; set; }
        public string CreatedAt { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Clone entity
    public class CloneEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Clones";
        public string RowKey { get; set; } = default!;
        public string Id { get; set; } = default!;
        public string Date { get; set; } = default!;
        public int Count { get; set; } = default!;
        public int Uniques { get; set; } = default!;

        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }


    // View entity
    public class ViewEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Views";
        public string RowKey { get; set; } = default!;
        public string Id { get; set; } = default!;
        public string Date { get; set; } = default!;
        public int Count { get; set; } = default!;
        public int Uniques { get; set; } = default!;
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }


    // Pull request entity
    public class PullRequestEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = default!;
        public string RowKey { get; set; } = default!;
        public string Id { get; set; } 
        public string? Title { get; set; }
        public string? User { get; set; }
        public string? State { get; set; }
        public int Additions { get; set; }
        public int Deletions { get; set; }
        public int ChangedFiles { get; set; }
        public string CreatedDate { get; set; }
        public int Number { get; set; }
        public string ClosedDate { get; set; }
        public string? MergedDate { get; set; }
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
        public string? Login { get; set; }
        public string Id { get; set; }
        public string? AvatarUrl { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }

    // Issue entity
    public class IssueEntity : ITableEntity
    {
        public string PartitionKey { get; set; } = "Issues";
        public string RowKey { get; set; } = default!;
        public string Assignee { get; set; }
        public string? Id { get; set; }
        public string? Number { get; set; }
        public string? Milestone { get; set; }
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
