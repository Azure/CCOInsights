using System.Net.Http.Headers;
using System.Text.Json;

namespace ghmetrics.github;

public class GhExtractor
{
    public async Task<GHExtractionResult> ExtractData(string owner, string repo, string token)
    {
        var result = new GHExtractionResult();
        
        using var httpClient = new HttpClient();
        httpClient.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("MyApp", "1.0"));
        httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("token", token);

        // Get repository info
        var repoInfo = await GetJsonAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}");
        if (repoInfo != null)
        {
            result.RepositoryInfo = new RepoInfo
            {
                Owner = repoInfo.Value.GetProperty("owner").GetProperty("login").GetString(),
                Id = repoInfo.Value.GetProperty("id").GetInt32(),
                Name = repoInfo.Value.GetProperty("name").GetString(),
                FullName = repoInfo.Value.GetProperty("full_name").GetString(),
                ForksCount = repoInfo.Value.GetProperty("forks_count").GetInt32(),
                WatchersCount = repoInfo.Value.GetProperty("watchers_count").GetInt32(),
                StarsCount = repoInfo.Value.GetProperty("stargazers_count").GetInt32(),
                Size = repoInfo.Value.GetProperty("size").GetInt32(),
                OpenIssuesCount = repoInfo.Value.GetProperty("open_issues_count").GetInt32(),
                CreatedAt = repoInfo.Value.GetProperty("created_at").GetString()
            };
        }

        // Forks & secondary forks
        var forksArray = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/forks");
        if (forksArray != null)
        {
            foreach (var fork in forksArray)
            {
                var forkFullName = fork.GetProperty("full_name").GetString();
                result.Forks.Add(forkFullName);

                var subForks = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{forkFullName}/forks");
                if (subForks != null && subForks.Any())
                {
                    foreach (var sf in subForks)
                    {
                        var subForkUrl = sf.GetProperty("html_url").GetString();
                        result.SecondaryForks.Add(subForkUrl);
                    }
                }
            }
        }

        // Traffic clones
        var clones = await GetJsonAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/traffic/clones");
        if (clones != null)
        {
            result.ClonesCount = clones.Value.GetProperty("count").GetInt32();
        }

        // Traffic views
        var views = await GetJsonAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/traffic/views");
        if (views != null)
        {
            result.ViewsCount = views.Value.GetProperty("count").GetInt32();
        }

        // Pull Requests (open)
        var openPrs = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/pulls?state=open");
        if (openPrs != null)
        {
            foreach (var pr in openPrs)
            {
                var prDetails = await GetPullRequestDetails(httpClient, pr, owner, repo);
                result.OpenPullRequests.Add(prDetails);
            }
        }

        // Pull Requests (closed)
        var closedPrs = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/pulls?state=closed");
        if (closedPrs != null)
        {
            foreach (var pr in closedPrs)
            {
                var prDetails = await GetPullRequestDetails(httpClient, pr, owner, repo);
                result.ClosedPullRequests.Add(prDetails);
            }
        }

        // Stargazers
        var stargazers = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/stargazers");
        if (stargazers != null)
        {
            foreach (var star in stargazers)
            {
                result.Stargazers.Add(new StargazerInfo
                {
                    Login = star.GetProperty("login").GetString(),
                    Id = star.GetProperty("id").GetInt32(),
                    AvatarUrl = star.GetProperty("avatar_url").GetString(),
                    HtmlUrl = star.GetProperty("html_url").GetString(),
                    Type = star.GetProperty("type").GetString()
                });
            }
        }

        // Contributors
        var contributors = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/contributors");
        if (contributors != null)
        {
            foreach (var contributor in contributors)
            {
                result.Contributors.Add(new ContributorInfo
                {
                    Login = contributor.GetProperty("login").GetString(),
                    Id = contributor.GetProperty("id").GetInt32(),
                    AvatarUrl = contributor.GetProperty("avatar_url").GetString()
                });
            }
        }

        // Issues (excluding PRs)
        var issues = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/issues?state=all");
        if (issues != null)
        {
            foreach (var issue in issues)
            {
                if (!issue.TryGetProperty("pull_request", out _))
                {
                    var issueInfo = new IssueInfo
                    {
                        Id = issue.GetProperty("id").GetInt64(),
                        Number = issue.GetProperty("number").GetInt64(),
                        Title = issue.GetProperty("title").GetString(),
                        User = issue.GetProperty("user").GetProperty("login").GetString(),
                        State = issue.GetProperty("state").GetString(),
                        CreatedAt = issue.GetProperty("created_at").GetString(),
                        UpdatedAt = issue.GetProperty("updated_at").GetString()
                    };
                    if (issue.TryGetProperty("closed_at", out var closedAt) && closedAt.ValueKind != JsonValueKind.Null)
                    {
                        issueInfo.ClosedAt = closedAt.GetString();
                    }
                    result.Issues.Add(issueInfo);
                }
            }
        }

        // Releases
        var releases = await GetJsonArrayAsync(httpClient, $"https://api.github.com/repos/{owner}/{repo}/releases");
        if (releases != null)
        {
            foreach (var release in releases)
            {
                result.Releases.Add(new ReleaseInfo
                {
                    Name = release.GetProperty("name").GetString(),
                    PublishedAt = release.GetProperty("published_at").GetString()
                });
            }
        }

        return result;

        // Helper local functions
        static async Task<JsonElement?> GetJsonAsync(HttpClient client, string url)
        {
            var resp = await client.GetAsync(url);
            if (!resp.IsSuccessStatusCode) return null;
            var json = await resp.Content.ReadAsStringAsync();
            return JsonDocument.Parse(json).RootElement;
        }

        static async Task<JsonElement[]?> GetJsonArrayAsync(HttpClient client, string url)
        {
            var resp = await client.GetAsync(url);
            if (!resp.IsSuccessStatusCode) return null;
            var json = await resp.Content.ReadAsStringAsync();
            return JsonDocument.Parse(json).RootElement.EnumerateArray().ToArray();
        }

        static async Task<PullRequestDetails> GetPullRequestDetails(HttpClient httpClient, JsonElement pr, string owner, string repo)
        {
            var number = pr.GetProperty("number").GetInt32();
            var prApi = $"https://api.github.com/repos/{owner}/{repo}/pulls/{number}";
            var prDetails = await GetJsonAsync(httpClient, prApi);

            var details = new PullRequestDetails
            {
                Id = pr.GetProperty("id").GetInt64(),
                Number = number,
                Title = pr.GetProperty("title").GetString(),
                User = pr.GetProperty("user").GetProperty("login").GetString(),
                State = pr.GetProperty("state").GetString(),
                CreatedAt = pr.GetProperty("created_at").GetString()
            };

            if (prDetails != null)
            {
                details.Additions = prDetails.Value.GetProperty("additions").GetInt32();
                details.Deletions = prDetails.Value.GetProperty("deletions").GetInt32();
                details.ChangedFiles = prDetails.Value.GetProperty("changed_files").GetInt32();

                var mergedAt = prDetails.Value.GetProperty("merged_at");
                if (mergedAt.ValueKind != JsonValueKind.Null)
                {
                    details.MergedAt = mergedAt.GetString();
                }

                if (prDetails.Value.TryGetProperty("closed_at", out var closedAt) && closedAt.ValueKind != JsonValueKind.Null)
                {
                    details.ClosedAt = closedAt.GetString();
                }
            }

            return details;
        }
    }
}
