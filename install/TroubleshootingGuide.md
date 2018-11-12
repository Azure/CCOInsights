# CCO Dashboard Troubleshooting guide
<div style="text-align: justify">

## Introduction
This document provides the information needed to troubleshoot the CCO Dashboard. Suggest ways CCO Dashboard documentation can be improved and better serve your needs.

## Locale Options

If in some of the maps that are in the dashboard the locations are not correct, you should check the regional configuration of the Power BI. It must be configured as English (United States)

![localel](/install/images/locale_options_powerBI.PNG)


## Graph API credentials permission error

If the RBAC data is not appearing into the RBAC page, the credentials must be entered again. 

![graph apil](/install/images/problem_graph_api.png)

To do this you must follow this steps:

- Go to **File**.
- Click on **Options and settings**.
- Click on **Data source settings**.
- In in **Current file/Global permissions** select https://graph.windows.net and click on **Edit permissions**.
- Click on **Edit** and enter your credentials.

## Log analytics API timeout

Depending on the number of records we have in log analytics, we can obtain a timeout during the refresh.

The solution is to wait a few minutes and launch a new refresh.

## Relationships Model

If something happens and all the relationships between tables are broken, the following picture shows the actual relationship model inside the CCO Power BI dashboard.

![relationship model](/install/images/RelationshipsModel.PNG)


