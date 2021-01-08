targetScope = 'managementGroup'

param targetMG string ='ES-management'

var mgScope = tenantResourceId('Microsoft.Management/managementGroups', targetMG)
var policyDefinition = 'LocationRestriction'

resource policy 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
  name: policyDefinition
  properties: {
    policyType: 'Custom'
    mode: 'All'
    parameters: {}
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            field: 'Microsoft.Storage/storageAccounts/networkAcls.defaultAction'
            notequals: 'Deny'
          }
        ]
      }
      then: {
        effect: 'Deny'
      }

    }
  }
}
