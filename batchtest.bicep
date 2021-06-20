targetScope = 'subscription'

param region string = 'westeurope'

resource testbatchrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'testbatch'
  location: region
}



module hubVNET 'Modules/vnet.bicep' = {
  name: 'batchtest-vnet'
  scope: resourceGroup(testbatchrg.name)
  params: {
    vnetname: 'batchtest'
    addressSpaces: [
      '10.4.0.0/16'
    ]
    subnets: [
      {
        name: 'Vms'
        properties: {
          addressPrefix: '10.4.0.0//24'
        }
      }
      {
        name: 'PE'
        properties: {
          addressPrefix: '10.4.1.0//24'
        }
      }
      {
        name: 'batch'
        properties: {
          addressPrefix: '10.4.2.0//24'
          privateLinkServiceNetworkPolicies: 'Disabled'
          privateEndpointNetworkPolicies: 'Disabled' 
        }
      }
    ]
  }
}





