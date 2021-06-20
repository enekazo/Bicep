targetScope = 'subscription'

param region string = 'westeurope'

resource hubrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'hubtestrg'
  location: region
}

resource spokerg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'spoketestrg'
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

module spokeVNET 'Modules/vnet.bicep' = {
  name: 'spoke-vnet'
  scope: resourceGroup(spokerg.name)
  params: {
    vnetname: 'spoke'
    addressSpaces: [
      '192.168.1.0/24'
    ]
    subnets: [
      {
        name: 'spoke-vnet'
        properties: {
          addressPrefix: '192.168.1.0/24'
        }
      }
    ]
  }
}

module spokeProxyVNET 'Modules/vnet.bicep' = {
  name: 'spokeProxy'
  scope: resourceGroup(spokerg.name)
  params: {
    vnetname: 'proxy'
    addressSpaces: [
      '192.168.2.0/24'
    ]
    subnets: [
      {
        name: 'proxy'
        properties: {
          addressPrefix: '192.168.2.0/24'
        }
      }
    ]
  }
}


module hubfirewall 'Modules/fw.bicep' ={
  name: 'hubFirewall'
  scope: resourceGroup(hubrg.name)
  params: {
    subnetID:hubVNET.outputs.subnetids[0].id
    firewallName:'hubFirewall'
  }

}

module proxyVM 'Modules/VmUbuntu.bicep'={
  name: 'proxyvm'
  scope: resourceGroup(spokerg.name)
  params:{
    adminPasswordOrKey:'!Pass@word1234'
    adminUsername:'evadmin'
    dnsLabelPrefix:'evproxyvm'
    subnetID:spokeProxyVNET.outputs.subnetids[0].id
    deployVMExt: true
  }
}

