namespace CCOInsights.GithubMetrics.github;

public record GHExtractionResult
{
    public RepoInfo? RepositoryInfo { get; set; }
    public List<string> Forks { get; } = new();
    public List<string> SecondaryForks { get; } = new();
    public int? ClonesCount { get; set; }
    public int? ViewsCount { get; set; }
    public List<PullRequestDetails> OpenPullRequests { get; } = new();
    public List<PullRequestDetails> ClosedPullRequests { get; } = new();
    public List<StargazerInfo> Stargazers { get; } = new();
    public List<ContributorInfo> Contributors { get; } = new();
    public List<IssueInfo> Issues { get; } = new();
    public List<ReleaseInfo> Releases { get; } = new();
}

public record RepoInfo
{
    public string? Owner { get; init; }
    public long? Id { get; init; }
    public string? Name { get; init; }
    public string? FullName { get; init; }
    public int? ForksCount { get; init; }
    public int? WatchersCount { get; init; }
    public int? StarsCount { get; init; }
    public int? Size { get; init; }
    public int? OpenIssuesCount { get; init; }
    public string? CreatedAt { get; init; }
}

public record PullRequestDetails
{
    public long Id { get; init; }
    public int Number { get; init; }
    public string? Title { get; init; }
    public string? User { get; init; }
    public string? State { get; init; }
    public string? CreatedAt { get; init; }
    public int Additions { get; set; }
    public int Deletions { get; set; }
    public int ChangedFiles { get; set; }
    public string? MergedAt { get; set; }
    public string? ClosedAt { get; set; }
}

public record StargazerInfo
{
    public string? Login { get; init; }
    public long Id { get; init; }
    public string? AvatarUrl { get; init; }
    public string? HtmlUrl { get; init; }
    public string? Type { get; init; }
}

public record ContributorInfo
{
    public string? Login { get; init; }
    public long Id { get; init; }
    public string? AvatarUrl { get; init; }
}

public record IssueInfo
{
    public long Id { get; init; }
    public long Number { get; init; }
    public string? Title { get; init; }
    public string? User { get; init; }
    public string? State { get; init; }
    public string? CreatedAt { get; init; }
    public string? UpdatedAt { get; init; }
    public string? ClosedAt { get; set; }
}

public record ReleaseInfo
{
    public string? Name { get; init; }
    public string? PublishedAt { get; init; }
}
