using Azure.Core.Serialization;
using Azure.Data.Tables;
using ghmetrics.github;

namespace ghmetrics.exports
{

    public static class Exporter
    {
        public static async Task UploadGhDataAsync(
            GHExtractionResult data,
            string storageConnectionString)
        {

            var serviceClient = new TableServiceClient(storageConnectionString);

            var tableClient = serviceClient.GetTableClient("REPODATA");
            await tableClient.CreateIfNotExistsAsync();
            var repoEntity = new GhDataTableEntity
            {
                PartitionKey= "RepositoryInfo",
                RowKey = data.RepositoryInfo.Id.ToString(),
                RepoName = data.RepositoryInfo.Name,
                Owner = data.RepositoryInfo.Owner,
                ForksCount = data.RepositoryInfo.ForksCount,
                StarsCount = data.RepositoryInfo.StarsCount,
                ClonesCount = data.ClonesCount,
                ViewsCount = data.ViewsCount,
            };

            await tableClient.UpsertEntityAsync(repoEntity);
            

            // Open Pull Requests
            tableClient = serviceClient.GetTableClient("OPENPRS");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var pr in data.OpenPullRequests)
            {
                var prEntity = CreatePullRequestEntity(pr, "OpenPullRequests");
                await tableClient.UpsertEntityAsync(prEntity);
            }

            // Closed Pull Requests
            tableClient = serviceClient.GetTableClient("CLOSEDPRS");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var pr in data.ClosedPullRequests)
            {
                var prEntity = CreatePullRequestEntity(pr, "ClosedPullRequests");
                await tableClient.UpsertEntityAsync(prEntity);
            }

            // Stargazers
            tableClient = serviceClient.GetTableClient("STARGAZERS");
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

            // Contributors
            tableClient = serviceClient.GetTableClient("CONTRIBUTORS");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var contr in data.Contributors)
            {
                var contrEntity = new ContributorEntity
                {
                    RowKey = contr.Id.ToString(),
                    AvatarUrl = contr.AvatarUrl
                };
                await tableClient.UpsertEntityAsync(contrEntity);
            }

            // Issues
            tableClient = serviceClient.GetTableClient("ISSUES");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var issue in data.Issues)
            {
                var issueEntity = new IssueEntity
                {
                    RowKey = issue.Id.ToString(),
                    Title = issue.Title,
                    User = issue.User,
                    State = issue.State,
                    CreatedAt = issue.CreatedAt,
                    UpdatedAt = issue.UpdatedAt,
                    ClosedAt = issue.ClosedAt
                };
                await tableClient.UpsertEntityAsync(issueEntity);
            }

            // Releases
            tableClient = serviceClient.GetTableClient("RELEASES");
            await tableClient.CreateIfNotExistsAsync();
            foreach (var release in data.Releases)
            {
                var releaseEntity = new ReleaseEntity
                {
                    RowKey = Guid.NewGuid().ToString(),
                    PublishedAt = release.PublishedAt
                };
                await tableClient.UpsertEntityAsync(releaseEntity);
            }
        }

        private static PullRequestEntity CreatePullRequestEntity(PullRequestDetails pr, string partitionKey)
        {
            return new PullRequestEntity
            {
                PartitionKey = partitionKey,
                RowKey = pr.Id.ToString(),
                Title = pr.Title,
                User = pr.User,
                State = pr.State,
                CreatedAt = pr.CreatedAt,
                Additions = pr.Additions,
                Deletions = pr.Deletions,
                ChangedFiles = pr.ChangedFiles,
                ClosedAt = pr.ClosedAt,
                MergedAt = pr.MergedAt
            };
        }
    }
}
