using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CCOInsights.GitHubMetrics.github
{
    public class GhExtractorOptions
    {
        public string Owner { get; set; }
        public string Repo { get; set; }
        public string Token { get; set; }   
    }
}
