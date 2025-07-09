using Azure.Data.Tables;
using CCOInsights.GithubMetrics.github;


namespace CCOInsights.GithubMetrics.exports
{

    public class Exporter
    {
        private readonly TableServiceClient _tableServiceClient;
        public Exporter(TableServiceClient client)
        {
            _tableServiceClient = client;   
        }
        public async Task UploadGhDataAsync(
            GHExtractionResult data)
        {
            var tableClient = _tableServiceClient.GetTableClient("Repository");
            await tableClient.CreateIfNotExistsAsync();
            var repoEntity = new RepositoryEntity
            {
                PartitionKey= "RepositoryInfo",
                RowKey = data.RepositoryInfo.Id.ToString(),
                Id = data.RepositoryInfo.Id.ToString(),
                Name = data.RepositoryInfo.Name,
                FullName = data.RepositoryInfo.FullName,
                Owner = data.RepositoryInfo.Owner,
                OpenIssues = data.RepositoryInfo.OpenIssuesCount,
                Forks = data.RepositoryInfo.ForksCount,
                Stargazers = data.RepositoryInfo.StarsCount,
                Watchers = data.RepositoryInfo.WatchersCount,
                CreatedAt = data.RepositoryInfo.CreatedAt,
            };

            await tableClient.UpsertEntityAsync(repoEntity);
            

            // Open Pull Requests
            tableClient = _tableServiceClient.GetTableClient("OpenPRs");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var pr in data.OpenPullRequests)
            {
                var prEntity = CreatePullRequestEntity(pr, "OpenPullRequests");
                await tableClient.UpsertEntityAsync(prEntity);
            }

            // Closed Pull Requests
            tableClient = _tableServiceClient.GetTableClient("ClosedPRs");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var pr in data.ClosedPullRequests)
            {
                var prEntity = CreatePullRequestEntity(pr, "ClosedPullRequests");
                await tableClient.UpsertEntityAsync(prEntity);
            }

            // Stargazers
            tableClient = _tableServiceClient.GetTableClient("Stargazers");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var star in data.Stargazers)
            {
                var starEntity = new StargazerEntity
                {
                    RowKey = star.Id.ToString(),
                    AvatarUrl = star.AvatarUrl,
                    HtmlUrl = star.HtmlUrl,
                    Type = star.Type
                };
                await tableClient.UpsertEntityAsync(starEntity);
            }
            //Forks
            tableClient = _tableServiceClient.GetTableClient("Forks");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var fork in data.Forks)
            {
                var forkEntity = new ForkEntity
                {
                    RowKey = fork.Id.ToString(),
                    FullName = fork.FullName,
                    Owner = fork.Owner,
                    CreatedAt = fork.CreatedAt,
                    Id = fork.Id.ToString(),
                };
                await tableClient.UpsertEntityAsync(forkEntity);
            }
            //Clones
            tableClient = _tableServiceClient.GetTableClient("Clones");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var clone in data.Clones)
            {
                var cloneEntity = new CloneEntity
                {
                    RowKey = Guid.NewGuid().ToString(),
                    Id = clone.Id,
                    Date = clone.Date,
                    Count = clone.Count ?? 0,
                    Uniques = clone.Uniques ?? 0
                };
                await tableClient.UpsertEntityAsync(cloneEntity);
            }

            //Clones
            tableClient = _tableServiceClient.GetTableClient("Views");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var view in data.Views)
            {
                var viewEntity = new ViewEntity
                {
                    RowKey = Guid.NewGuid().ToString(),
                    Id = view.Id,
                    Date = view.Date,
                    Count = view.Count ?? 0,
                    Uniques = view.Uniques ?? 0
                };
                await tableClient.UpsertEntityAsync(viewEntity);
            }


            // Contributors
            tableClient = _tableServiceClient.GetTableClient("Contributors");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var contr in data.Contributors)
            {
                var contrEntity = new ContributorEntity
                {
                    RowKey = contr.Id.ToString(),
                    Login = contr.Login,
                    Id = contr.Id.ToString(),
                    AvatarUrl = contr.AvatarUrl
                };
                await tableClient.UpsertEntityAsync(contrEntity);
            }

            // Issues
            tableClient = _tableServiceClient.GetTableClient("Issues");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var issue in data.Issues)
            {
                var issueEntity = new IssueEntity
                {
                    RowKey = issue.Id.ToString(),
                    Id = issue.Id.ToString(),
                    PartitionKey = "Issues",
                    Assignee = issue.Assignee ?? string.Empty,
                    Title = issue.Title,
                    User = issue.User,
                    State = issue.State,
                    CreatedAt = issue.CreatedAt,
                    UpdatedAt = issue.UpdatedAt,
                    ClosedAt = issue.ClosedAt,
                    Milestone = issue.Milestone
                };
                await tableClient.UpsertEntityAsync(issueEntity);
            }

            // Releases
            tableClient = _tableServiceClient.GetTableClient("Releases");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var release in data.Releases)
            {
                var releaseEntity = new ReleaseEntity
                {
                    RowKey = Guid.NewGuid().ToString(),
                    PublishedAt = release.PublishedAt,
                };
                await tableClient.UpsertEntityAsync(releaseEntity);
            }
        }

        private static PullRequestEntity CreatePullRequestEntity(PullRequestDetails pr, string partitionKey)
        {
            return new PullRequestEntity
            {
                PartitionKey = partitionKey,
                Id = pr.Id.ToString(),
                Number = pr.Number,
                RowKey = pr.Id.ToString(),
                Title = pr.Title,
                User = pr.User,
                State = pr.State,
                CreatedDate = pr.CreatedAt,
                Additions = pr.Additions,
                Deletions = pr.Deletions,
                ChangedFiles = pr.ChangedFiles,
                ClosedDate = pr.ClosedAt,
                MergedDate = pr.MergedAt
            };
        }
    }
}
