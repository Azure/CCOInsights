### _Navigation_

- [Report Pages](#report-pages)
  - [Management Groups and Subscriptions Hierarchy Overview page](#management-groups-and-subscriptions-hierarchy-overview-page)
  - [Tags and naming standards page](#tags-and-naming-standards-page)
  - [Azure Regulatory Standards Forecast](#azure-regulatory-standards-forecast)
  - [Azure Resources Security & Compliance page](#azure-resources-security--compliance-page)
  - [Azure Policies page](#azure-policies-page)
  - [Azure Blueprints page](#azure-blueprints-page)

---

<br>

# Report Pages

## Management Groups and Subscriptions Hierarchy Overview page

In this page, you will be able to easily get a hierarchal view of your Management Groups and Subscriptions within your environment. It's important to mention that this page just gives you a quick view.

![overview][Overview]

## Tags and naming standards page

In this page you will be able to sort and filter all your Resources and Resource groups based on Tags. It will help you identify any missing Tag and if your naming standards and Tags classifications adheres to your organization guidelines or policies.

You can filter the information by:

- Management Group with subscriptions
- Subscription

![TagsOverview][TagsOverview]

## Azure Regulatory Standards Forecast

In this page you can compare your current Azure resources compliance against selected Regulatory Standards, to understand how far from a given Regulatory Standard your current Azure footprint is today. For more information check the published [Regulatory Standards][RegulatoryStandards].

You can filter the information by:

- Subscription
- Regulatory Compliance
- Assessment Category

![regulatorycompliance][RegulatoryCompliance]

## Azure Resources Security & Compliance page

In this page you can check the compliance status of your Azure resources based on the Azure Security Center Secure Score Controls and the corresponding Policy Set or Regulatory Standard.

You can filter the information by:

- Subscription
- Policy Set
- Regulatory Standard Name
- Secure Controls
- Policy Category

![regulatory compliance resources][RegulatoryComplianceResources]

## Azure Policies page

In this page of the report, you will be able to identify the total amount of policies that you are applying in your environment. It will also give a high-level overview of which policies have less compliance level and which resources require more attention.

You can filter the information by:

- Management Group with subscriptions
- Subscription
- Policy scope

If you navigate to a impacted resource you will see a quick description of the applied policies.

![policies][policies]

## Azure Blueprints page

In this page of the report, you will be able to identify the total amount of blueprints that you are applying in your environment. It will also show which are the artifacts within the blueprints.

You can filter the information by:

- Subscription with assigned blueprints
- Blueprint Definition




<!-- Docs -->
[RegulatoryStandards]: <https://learn.microsoft.com/en-us/azure/governance/blueprints/samples/>

<!-- Images -->
[Overview]: <./media/GovernanceOverview.png>
[TagsOverview]: <./media/TagsOverview.png>
[RegulatoryCompliance]: <./media/regulatorycompliance.png>
[RegulatoryComplianceResources]: <./media/regulatorycomplianceresources.png>
[policies]: <./media/governancePolicies.png>
[GovernanceSubsBlueprints]: <./media/governanceSubsBlueprints.png>


<!-- References -->
