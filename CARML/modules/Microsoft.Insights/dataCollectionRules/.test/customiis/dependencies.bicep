@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the data collection endpoint to create.')
param dataCollectionEndpointName string

@description('Required. The name of the log analytics workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
    name: logAnalyticsWorkspaceName
    location: location
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2021-04-01' = {
    kind: 'Windows'
    location: location
    name: dataCollectionEndpointName
    properties: {
        networkAcls: {
            publicNetworkAccess: 'Enabled'
        }
    }
}

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The name of the deployed log analytics workspace.')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Data Collection Endpoint.')
output dataCollectionEndpointResourceId string = dataCollectionEndpoint.id
