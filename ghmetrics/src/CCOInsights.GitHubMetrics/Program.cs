using Azure.Data.Tables;
using CCOInsights.GithubMetrics.exports;
using CCOInsights.GithubMetrics.github;
using CCOInsights.GitHubMetrics.github;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Quartz;

DotNetEnv.Env.TraversePath().Load();
var builder = Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.AddQuartz(q =>
        {
            q.ScheduleJob<GitHubMetricsExporterJob>(x => x
                .WithIdentity(nameof(GitHubMetricsExporterJob))
                .WithCronSchedule(GitHubMetricsExporterJob.CronSchedule, s => s.InTimeZone(TimeZoneInfo.Utc)));
        });

        var owner = Environment.GetEnvironmentVariable("GH_OWNER") ?? "azure";
        var repo = Environment.GetEnvironmentVariable("GH_REPO") ?? "ccoInsights";
        var token = Environment.GetEnvironmentVariable("GH_TOKEN") ?? "YOURAWESOMETOKEN";
        var connectionString = Environment.GetEnvironmentVariable("TABLE_STORAGE_CONNECTION_STRING") ?? "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;TableEndpoint=http://127.0.0.1:10002/devstoreaccount1;";

        services.AddScoped<TableServiceClient>(sp =>
        {
            return new TableServiceClient(connectionString);
        });
        services.AddSingleton<GhExtractorOptions>(e =>
        {
            return new GhExtractorOptions
            {
                Owner = owner,
                Repo = repo,
                Token = token
            };
        });

        services.AddScoped<Exporter>();
        services.AddScoped<GhExtractor>();
        services.AddHttpClient<GhExtractor>(); 

        services.AddQuartzHostedService(q => q.WaitForJobsToComplete = true);
    });



await builder.RunConsoleAsync();

public class GitHubMetricsExporterJob : IJob
{
    //public static string CronSchedule = "0 0 10 * * ?"; // Execute daily at 10 AM UTC
    public static string CronSchedule = "0 * * * * ?"; // Execute every minute
    private readonly ILogger _log;
    private readonly Exporter _exporter;
    private readonly GhExtractor _extractor;

    public GitHubMetricsExporterJob(ILogger<GitHubMetricsExporterJob> log, Exporter exporter, GhExtractor extractor)
    {
        _log = log;
        _exporter = exporter;
        _extractor = extractor;
    }
    public async Task Execute(IJobExecutionContext context)
    {
        // Lee valores de entorno
        _log.LogInformation("Starting data extraction.");
        var dataExtracted = await _extractor.ExtractData();
        _log.LogInformation("Extraction done.");
        _log.LogInformation("Exporting to Azure Table Storage.");
        await _exporter.UploadGhDataAsync(dataExtracted);
        _log.LogInformation("Export done");
    }
}
