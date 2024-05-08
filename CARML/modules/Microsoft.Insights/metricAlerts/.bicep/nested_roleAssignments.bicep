@sys.description('Required. The IDs of the principals to assign the role to.')
param principalIds array

@sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
param roleDefinitionIdOrName string

@sys.description('Required. The resource ID of the resource to apply the role assignment to.')
param resourceId string

@sys.description('Optional. The principal type of the assigned principal ID.')
@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
  'Device'
  ''
])
param principalType string = ''

@sys.description('Optional. The description of the role assignment.')
param description string = ''

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
param condition string = ''

@sys.description('Optional. Version of the condition.')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@sys.description('Optional. Id of the delegated managed identity resource.')
param delegatedManagedIdentityResourceId string = ''

var builtInRoleNames = {
  'API Management Service Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '312a565d-c81f-4fd8-895a-4e21e48d571c')
  'API Management Service Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e022efe7-f5ba-4159-bbe4-b44f577e9b61')
  'API Management Service Reader Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '71522526-b88f-4d52-b57f-d31fc3546d0d')
  'Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ca6382a4-1721-4bcf-a114-ff0c70227b6b')
  'Application Insights Component Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ae349356-3a1b-4a5e-921d-050484c6347e')
  'Application Insights Snapshot Debugger': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '08954f03-6346-4c2e-81c0-ec3a5cfae23b')
  'Automation Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f353d9bd-d4a6-484e-a77a-8050b599b867')
  'Automation Job Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4fe576fe-1146-4730-92eb-48519fa6bf9f')
  'Automation Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd3881f73-407a-4167-8283-e981cbba0404')
  'Automation Runbook Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5fb5aef8-1081-4b8e-bb16-9d5d0385bab5')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Azure Arc Enabled Kubernetes Cluster User Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00493d72-78f6-4148-b6c5-d3ce8e4799dd')
  'Azure Arc Kubernetes Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'dffb1e0c-446f-4dde-a09f-99eb5cc68b96')
  'Azure Arc Kubernetes Cluster Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8393591c-06b9-48a2-a542-1bd6b377f6a2')
  'Azure Arc Kubernetes Viewer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '63f0a09d-1495-4db4-a681-037d84835eb4')
  'Azure Arc Kubernetes Writer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5b999177-9696-4545-85c7-50de3797e5a1')
  'Azure Arc ScVmm Administrator role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a92dfd61-77f9-4aec-a531-19858b406c87')
  'Azure Arc ScVmm Private Cloud User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c0781e91-8102-4553-8951-97c6d4243cda')
  'Azure Arc ScVmm Private Clouds Onboarding': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6aac74c4-6311-40d2-bbdd-7d01e7c6e3a9')
  'Azure Arc ScVmm VM Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e582369a-e17b-42a5-b10c-874c387c530b')
  'Azure Arc VMware Administrator role ': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ddc140ed-e463-4246-9145-7c664192013f')
  'Azure Arc VMware Private Cloud User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ce551c02-7c42-47e0-9deb-e3b6fc3a9a83')
  'Azure Arc VMware Private Clouds Onboarding': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '67d33e57-3129-45e6-bb0b-7cc522f762fa')
  'Azure Arc VMware VM Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b748a06d-6150-4f8a-aaa9-ce3940cd96cb')
  'Azure Center for SAP solutions administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7b0c7e81-271f-4c71-90bf-e30bdfdbc2f7')
  'Azure Center for SAP solutions reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '05352d14-a920-4328-a0de-4cbe7430e26b')
  'BizTalk Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e3c6656-6cfa-4708-81fe-0de47ac73342')
  'CDN Endpoint Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '426e0c7f-0c7e-4658-b36f-ff54d6c29b45')
  'CDN Endpoint Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '871e35f6-b5c1-49cc-a043-bde969a0f2cd')
  'CDN Profile Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ec156ff8-a8d1-4d15-830c-5b80698ca432')
  'CDN Profile Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8f96442b-4075-438f-813d-ad51ab4019af')
  'Classic Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b34d265f-36f7-4a0d-a4d4-e158ca92e90f')
  'Classic Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '86e8f5dc-a6e9-4c67-9d15-de283e8eac25')
  'Classic Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd73bb868-a0df-4d4d-bd69-98a00b01fccb')
  'ClearDB MySQL DB Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9106cda0-8a86-4e81-b686-29a22c54effe')
  'Cognitive Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68')
  'Cognitive Services User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a97b65f3-24c7-4388-baec-2e87135dc908')
  'Collaborative Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'daa9e50b-21df-454c-94a6-a8050adab352')
  'Collaborative Runtime Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7a6f0e70-c033-4fb1-828c-08514e5f4102')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Cosmos DB Account Reader Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fbdf93bf-df7d-467e-a4d2-9458aa1360c8')
  'Cosmos DB Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '230815da-be43-4aae-9cb4-875f7bd000aa')
  'Data Factory Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '673868aa-7521-48a0-acc6-0f60742d39f5')
  'Data Lake Analytics Developer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '47b7735b-770e-4598-a7da-8b91488b4c88')
  'Data Purger': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '150f5e0c-0603-4f03-8c7f-cf70034c4e90')
  'Desktop Virtualization Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '86240b0e-9422-4c43-887b-b61143f32ba8')
  'Desktop Virtualization Application Group Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aebf23d0-b568-4e86-b8f9-fe83a2c6ab55')
  'Desktop Virtualization Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '082f0a83-3be5-4ba1-904c-961cca79b387')
  'Desktop Virtualization Host Pool Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e307426c-f9b6-4e81-87de-d99efb3c32bc')
  'Desktop Virtualization Host Pool Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ceadfde2-b300-400a-ab7b-6143895aa822')
  'Desktop Virtualization Power On Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '489581de-a3bd-480d-9518-53dea7416b33')
  'Desktop Virtualization Power On Off Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '40c5ff49-9181-41f8-ae61-143b0e78555e')
  'Desktop Virtualization Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '49a72310-ab8d-41df-bbb0-79b649203868')
  'Desktop Virtualization Session Host Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2ad6aaab-ead9-4eaa-8ac5-da422f562408')
  'Desktop Virtualization User Session Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6')
  'Desktop Virtualization Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a959dbd1-f747-45e3-8ba6-dd80f235f97c')
  'Desktop Virtualization Workspace Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21efdde3-836f-432b-bf3d-3e8e734d4b2b')
  'Desktop Virtualization Workspace Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0fa44ee9-7a7d-466b-9bb2-2bf446b1204d')
  'Device Update Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '02ca0879-e8e4-47a5-a61e-5c618b76e64a')
  'Device Update Content Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0378884a-3af5-44ab-8323-f5b22f9f3c98')
  'Device Update Content Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd1ee9a80-8b14-47f0-bdc2-f4a351625a7b')
  'Device Update Deployments Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e4237640-0e3d-4a46-8fda-70bc94856432')
  'Device Update Deployments Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '49e2f5d2-7741-4835-8efa-19e1fe35e47f')
  'Device Update Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e9dba6fb-3d52-4cf0-bce3-f06ce71b9e0f')
  'Disk Pool Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '60fc6e62-5479-42d4-8bf4-67625fcc2840')
  'DNS Resolver Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0f2ebee7-ffd4-4fc0-b3b7-664099fdad5d')
  'DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'befefa01-2a29-4197-83a8-272ff33ce314')
  'DocumentDB Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5bd9cd88-fe45-4216-938b-f97437e15450')
  'Domain Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'eeaeda52-9324-47f6-8069-5d5bade478b2')
  'Domain Services Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '361898ef-9ed1-48c2-849c-a832951106bb')
  'EventGrid Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1e241071-0855-49ea-94dc-649edcd759de')
  'EventGrid EventSubscription Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '428e0ff0-5e57-4d9c-a221-2c70d0e0a443')
  'HDInsight Cluster Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '61ed4efc-fab3-44fd-b111-e24485cc132a')
  'Intelligent Systems Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '03a6d094-3444-4b3d-88af-7477090a9e5e')
  'Key Vault Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
  'Key Vault Certificates Officer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a4417e6f-fecd-4de8-b567-7b0420556985')
  'Key Vault Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f25e0fa2-a7c8-4377-a976-54943a77a395')
  'Key Vault Crypto Officer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '14b46e9e-c2b7-41b4-b07b-48a6ebf60603')
  'Key Vault Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21090545-7ca7-4776-b22c-e363652d74d2')
  'Key Vault Secrets Officer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
  'Kubernetes Cluster - Azure Arc Onboarding': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '34e09817-6cbe-4d01-b1a2-e0eac5743d41')
  'Kubernetes Extension Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '85cb6faf-e071-4c9b-8136-154b5a04f717')
  'Lab Assistant': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ce40b423-cede-4313-a93f-9b28290b72e1')
  'Lab Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5daaa2af-1fe8-407c-9122-bba179798270')
  'Lab Creator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b97fb8bc-a8b2-4522-a38b-dd33c7e65ead')
  'Lab Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a36e6959-b6be-4b12-8e9f-ef4b474d304d')
  'Lab Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f69b8690-cc87-41d6-b77a-a4bc3c0a966f')
  'Load Test Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749a398d-560b-491b-bb21-08924219302e')
  'Load Test Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45bb0b16-2f0c-4e78-afaa-a07599b003f6')
  'Load Test Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3ae3fb29-0000-4ccd-bf80-542e7b26e081')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Logic App Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '87a39d53-fc1b-424a-814c-f7e04687dc9e')
  'Logic App Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '515c2055-d9d4-4321-b1b9-bd0c9a0f79fe')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Managed Identity Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e40ec5ca-96e0-45a2-b4ff-59039f2c2b59')
  'Managed Identity Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
  'Media Services Account Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '054126f8-9a2b-4f1c-a9ad-eca461f08466')
  'Media Services Live Events Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '532bc159-b25e-42c0-969e-a1d439f60d77')
  'Media Services Media Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e4395492-1534-4db2-bedf-88c14621589c')
  'Media Services Policy Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c4bba371-dacd-4a26-b320-7250bca963ae')
  'Media Services Streaming Endpoints Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '99dba123-b5fe-44d5-874c-ced7199a5804')
  'Microsoft Sentinel Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ab8e14d6-4a74-4a29-9ba8-549422addade')
  'Microsoft Sentinel Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8d289c81-5878-46d4-8554-54e1e3d8b5cb')
  'Microsoft Sentinel Responder': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3e150937-b8fe-4cfb-8069-0eaf05ecd056')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'New Relic APM Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5d28c62d-5b37-4476-8438-e587778df237')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Private DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b12aa53e-6015-4669-85d0-8515ebb3ae7f')
  'Quota Request Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0e5f05e5-9ab9-446b-b98d-1e2157c94125')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Redis Cache Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e0f68234-74aa-48ed-b826-c38b57376e17')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'Scheduler Job Collections Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '188a0f2f-5c9e-469b-ae67-2aa5ce574b94')
  'Search Service Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7ca78c08-252a-4471-8644-bb5ff32d4ba0')
  'Security Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb1c8493-542b-48eb-b624-b4c8fea62acd')
  'Security Manager (Legacy)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e3d13bf0-dd5a-482e-ba6b-9b8433878d10')
  'Security Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '39bc4728-0917-49c7-9d2c-d95423bc2eb4')
  'SignalR/Web PubSub Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8cf5e20a-e4b2-4e9d-b3a1-5ceb692c2761')
  'Site Recovery Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6670b86e-a3f7-4917-ac9b-5d6ab1be4567')
  'Site Recovery Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '494ae006-db33-4328-bf46-533a6560a3ca')
  'SQL DB Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec')
  'SQL Managed Instance Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d')
  'SQL Security Manager': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '056cd41c-7e88-42e1-933e-88ba6a50c9c3')
  'SQL Server Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437')
  'Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
  'Tag Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4a9ae827-6dc8-4573-8ac7-8239d42aa03f')
  'Traffic Manager Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a4b10055-b0c7-44c2-b00f-c7b5b3550cf7')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  'Web Plan Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2cc479cb-7b4d-49a8-b449-8c00fd0f0a4b')
  'Website Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')
  'Workbook Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e8ddcd69-c73f-4f9f-9844-4100522f16ad')
  'Workbook Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b279062a-9be3-42a0-92ae-8b3cf002ec4d')
}

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' existing = {
  name: last(split(resourceId, '/'))
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
  name: guid(metricAlert.id, principalId, roleDefinitionIdOrName)
  properties: {
    description: description
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
    principalId: principalId
    principalType: !empty(principalType) ? any(principalType) : null
    condition: !empty(condition) ? condition : null
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId) ? delegatedManagedIdentityResourceId : null
  }
  scope: metricAlert
}]
