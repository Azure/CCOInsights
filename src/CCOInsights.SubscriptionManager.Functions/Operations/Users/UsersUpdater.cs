using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Extensions.Logging;

namespace CCOInsights.SubscriptionManager.Functions.Operations.Users
{

    public interface IUsersUpdater : IUpdater { }
    public class UsersUpdater : Updater<UsersResponse, Users>, IUsersUpdater
    {
        public UsersUpdater(IStorage storage, ILogger<UsersUpdater> logger, IUsersProvider provider) : base(storage, logger, provider)
        {
        }

        protected override Users Map(string executionId, ISubscription subscription, UsersResponse response) =>
            Users.From(executionId, response);
    }
}
