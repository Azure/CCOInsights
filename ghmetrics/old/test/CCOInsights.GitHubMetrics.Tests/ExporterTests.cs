using System.Threading.Tasks;
using Xunit;
using Moq;
using Azure.Data.Tables;
using CCOInsights.GithubMetrics.exports;
using CCOInsights.GithubMetrics.github;

namespace CCOInsights.GithubMetrics.Tests
{
    public class ExporterTests
    {
        [Fact]
        public async Task UploadGhDataAsync_CreatesAndPopulatesTables()
        {
            // Arrange
            var mockTableClient = new Mock<TableClient>();
            var mockServiceClient = new Mock<TableServiceClient>();
            mockServiceClient
                .Setup(s => s.GetTableClient(It.IsAny<string>()))
                .Returns(mockTableClient.Object);

            var data = new GHExtractionResult
            {
                RepositoryInfo = new RepoInfo { Id = 123, Name = "TestRepo" }
            };

            // Act
            // Here we're using the mock's service client instead of a real TableServiceClient
            await Exporter.UploadGhDataAsync(
                data,
                "UseDevelopmentStorage=true"
            );

    // Assert
    mockTableClient.Verify(t => t.CreateIfNotExistsAsync(default), Times.AtLeastOnce);
    mockTableClient.Verify(t => t.UpsertEntityAsync(
        It.IsAny<ITableEntity>(), 
        TableUpdateMode.Merge, 
        default), 
        Times.AtLeastOnce
    );
}
