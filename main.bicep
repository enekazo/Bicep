targetScope = 'subscription'

param region string = 'westeurope'

resource hubrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'test'
  location: region
}


module hubVNET 'Modules/vnet.bicep' = {
  name: 'hub-vnet'
  scope: resourceGroup(hubrg.name)
  params: {
    vnetname: 'hub'
    addressSpaces: [
      '192.168.0.0/24'
    ]
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '192.168.0.0/25'
        }
      }
    ]
  }
}
