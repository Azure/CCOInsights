using ghmetrics.github;
using DotNetEnv;
using ghmetrics.exports; // <-- Importante para cargar .env

namespace ghmetrics;

public class Program
{
    public static void Main(string[] args)
    {
        // Carga las variables desde .env
        Env.Load();

        var builder = WebApplication.CreateSlimBuilder(args);

        builder.Services.ConfigureHttpJsonOptions((Action<Microsoft.AspNetCore.Http.Json.JsonOptions>)(options =>
        {
            options.SerializerOptions.TypeInfoResolverChain.Insert(0, 
                (System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver)GithubExtractionSerializerContext.Default);
            options.SerializerOptions.TypeInfoResolverChain.Insert(1, 
                (System.Text.Json.Serialization.Metadata.IJsonTypeInfoResolver)MetricsJsonSerializerContext.Default);
        }));

        var app = builder.Build();

        // Habilita la carga de archivos estáticos y un archivo por defecto (index.html)
        app.UseDefaultFiles();
        app.UseStaticFiles();

        // Lee valores de entorno
        var owner = Environment.GetEnvironmentVariable("GH_OWNER") ?? "iaexperiments";
        var repo = Environment.GetEnvironmentVariable("GH_REPO") ?? "ghissuebot";
        var token = Environment.GetEnvironmentVariable("GH_TOKEN") ?? "ghp_REEMPLAZAR";
        var tablestorageConnectionString = Environment.GetEnvironmentVariable("TABLE_STORAGE_CONNECTION_STRING") ?? "DefaultEndpointsProtocol=https;AccountName=REEMPLAZAR;AccountKey=REEMPLAZAR;TableEndpoint=REEMPLAZAR";

        var extractor = new GhExtractor();

        var ghApi = app.MapGroup("/ghapi");
        ghApi.MapGet("/", async () =>
        {
            var extractedData = await extractor.ExtractData(owner, repo, token);
            await Exporter.UploadGhDataAsync(extractedData, tablestorageConnectionString);
            return Results.Ok(extractedData);
        });

        ghApi.MapGet("/metrics", async () =>
        {
            var extractedData = await extractor.ExtractData(owner, repo, token);
            var metricsCalculator = new metrics.metricsCalculator();
            var result = metricsCalculator.CalculateAllMetrics(extractedData);
            return Results.Ok(result);
        });

        // Inicia la aplicación
        app.Run();
    }
}

