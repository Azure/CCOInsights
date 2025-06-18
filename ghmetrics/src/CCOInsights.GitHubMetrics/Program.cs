using Microsoft.Extensions.Hosting;
using Quartz;

var builder = Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.AddQuartz(q =>
        {
            q.ScheduleJob<GitHubMetricsExporterJob>(x => x
                .WithIdentity(nameof(GitHubMetricsExporterJob))
                .WithCronSchedule(GitHubMetricsExporterJob.CronSchedule, s => s.InTimeZone(TimeZoneInfo.Utc)));

        });

        services.AddQuartzHostedService(q => q.WaitForJobsToComplete = true);
    });

await builder.RunConsoleAsync();

public class GitHubMetricsExporterJob : IJob
{
    //public static string CronSchedule = "0 0 10 * * ?"; // Execute daily at 10 AM UTC
    public static string CronSchedule = "0 * * * * ?"; // Execute every minute

    public Task Execute(IJobExecutionContext context)
    {
        Console.WriteLine("Hello, World!");
        return Task.CompletedTask;
    }
}
