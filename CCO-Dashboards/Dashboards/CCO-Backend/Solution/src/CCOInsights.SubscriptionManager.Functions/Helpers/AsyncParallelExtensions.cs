using System.Threading.Tasks.Dataflow;

namespace CCOInsights.SubscriptionManager.Functions.Helpers;

public static class AsyncParallelExtensions
{
    public static Task AsyncParallelForEach<T>(this IEnumerable<T> source, Func<T, Task> body, int maxDegreeOfParallelism = DataflowBlockOptions.Unbounded, TaskScheduler scheduler = null)
    {
        var options = new ExecutionDataflowBlockOptions
        {
            MaxDegreeOfParallelism = maxDegreeOfParallelism
        };
        if (scheduler != null)
            options.TaskScheduler = scheduler;

        var block = new ActionBlock<T>(body, options);

        foreach (var item in source)
            block.Post(item);

        block.Complete();
        return block.Completion;
    }
}
