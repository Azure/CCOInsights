using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using CCOInsights.GithubMetrics.github;
using CCOInsights.GitHubMetrics.github;
using Xunit;

namespace CCOInsights.GithubMetrics.Tests
{
    public class GhExtractorTests
    {
        [Fact]
        public void Constructor_AssignsFieldsProperly()
        {
            // Arrange
            var GHExtractorOptions = new GhExtractorOptions
            {
                Owner = "testOwner",
                Repo = "testRepo",
                Token = "testToken"
            };

            // Act
            var extractor = new GhExtractor(GHExtractorOptions, new HttpClient());

            // Assert
            Assert.NotNull(extractor);
        }

        [Fact]
        public async Task ExtractData_ReturnsEmptyResult_WhenHttpFails()
        {
            // Arrange
            var handler = new MockHttpMessageHandler(HttpStatusCode.NotFound, "{}");
            using var httpClient = new HttpClient(handler);
            // Arrange
            var GHExtractorOptions = new GhExtractorOptions
            {
                Owner = "testOwner",
                Repo = "testRepo",
                Token = "testToken"
            };

            // Act
            var extractor = new GhExtractor(GHExtractorOptions, httpClient);

            // Act
            var result = await extractor.ExtractData();

            // Assert
            Assert.NotNull(result);
            Assert.Null(result.RepositoryInfo);
            Assert.Empty(result.Forks);
            Assert.Empty(result.OpenPullRequests);
        }

    }

    /// <summary>
    /// Simple mock handler to intercept requests and return a canned response.
    /// </summary>
    internal class MockHttpMessageHandler : HttpMessageHandler
    {
        private readonly HttpStatusCode _statusCode;
        private readonly string _jsonContent;

        public MockHttpMessageHandler(HttpStatusCode statusCode, string jsonContent)
        {
            _statusCode = statusCode;
            _jsonContent = jsonContent;
        }

        protected override Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            var response = new HttpResponseMessage(_statusCode)
            {
                Content = new StringContent(_jsonContent)
            };
            return Task.FromResult(response);
        }
    }
}
