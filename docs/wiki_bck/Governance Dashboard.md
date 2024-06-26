### _Navigation_

- [Overview](#overview)
- [APIs in use](#apis-in-use)

---

<br>

# Overview

The CCO Azure Governance Dashboard is aligned with the Microsoft Cloud Adoption Framework governance principles and will allow you to get quick insights around important cloud assets and configuration, such as:
- Management Groups, 
- Subscriptions, 
- Blueprints, 
- Polices, 
- Naming Standards, 
- Tagging 
- and Regulatory Standards compliance. 
 
The information captured on this Power BI Dashboard can help Cloud Teams, Operations Teams or business decision makers to have a snapshot of the current Azure configuration in just few minutes.

<br>

# APIs in use

The CCO Azure Governance Dashboard Governance pulls the information from several APIs. You can read the public documentation if you need further information about the calls and methods available:
<br><br>

| API Name| Dashboard API Version | Using latest version available when it was released|
| --- | :---: | :---: |
| [Resource Groups][ResourceGroups]  |2019-05-01 | :heavy_check_mark:|
| [Azure Resources][AzureResources]  |2019-05-01 |:heavy_check_mark:|
| [Azure Subscriptions][AzureSubscriptions]  |2020-01-01 |:heavy_check_mark:|
| [Azure Locations][AzureLocations]  |2019-05-01 |:heavy_check_mark:|
| [Azure Blueprints][AzureBlueprints]  |2018-11-01-preview |:heavy_check_mark:|
| [Azure Policies][AzurePolicies]  |2019-09-01 |:heavy_check_mark:|
| [Azure Regulatory Compliances][AzureRegulatoryCompliances]  |2019-01-01-preview |:heavy_check_mark:|
| [Azure Assessments][AzureAssessments]  |2020-01-01 |:heavy_check_mark:|
| [Azure Secure Scores][AzureSecureScores] |2020-01-01 |:heavy_check_mark:|
| [Azure Secure Scores Controls][AzureSecureScoresControls] |2020-01-01-preview |:heavy_check_mark:|

<br>

<details>
<summary>
    API URLs by Azure environment:
</summary>


| API Name| API URL | Environment|
|--- |--- |--- |
| Management |https://management.azure.com/|Global|
| Management |https://management.usgovcloudapi.net/|US Government|
| Management |https://management.chinacloudapi.cn/|China|
</details>

<!-- Docs -->
[ResourceGroups]: <https://learn.microsoft.com/en-us/rest/api/resources/resource-groups>
[AzureResources]: <https://learn.microsoft.com/en-us/rest/api/resources/resources>
[AzureSubscriptions]: <https://docs.microsoft.com/en-us/rest/api/resources/subscriptions>
[AzureLocations]: <https://learn.microsoft.com/en-us/rest/api/resources/subscriptions/list-locations>
[AzureBlueprints]: <https://learn.microsoft.com/en-us/rest/api/blueprints>
[AzurePolicies]: <https://learn.microsoft.com/en-us/rest/api/policy/>
[AzureRegulatoryCompliances]: <https://learn.microsoft.com/en-us/rest/api/defenderforcloud/regulatory-compliance-standards>
[AzureAssessments]: <https://learn.microsoft.com/es-es/rest/api/defenderforcloud/assessments/list>
[AzureSecureScores]: <https://learn.microsoft.com/en-us/rest/api/defenderforcloud/secure-scores>
[AzureSecureScoresControls]: <https://learn.microsoft.com/en-us/rest/api/defenderforcloud/secure-score-controls>

<!-- Images -->

<!-- References -->
