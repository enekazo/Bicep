targetScope = 'subscription'

param region string = 'westeurope'
param hubVnetIPRange  string = '192.168.0.0/24'
param hubVnetSub0IPRange  string = '192.168.0.0/25'
param spokeVNETIPRange  string = '192.168.1.0/24'
param spokeVNETSub0IPRange  string = '192.168.1.0/24'
param spokeProxyVNETIPRange  string = '192.168.2.0/24'
param spokeProxyVNETSub0IPRange  string = '192.168.2.0/24'
resource hubrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'hubtestrg'
  location: region
}

resource spokerg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'spoketestrg'
  location: region
}

module hubVNET '../../Modules/vnet.bicep' = {
  name: 'hub-vnet'
  scope: resourceGroup(hubrg.name)
  params: {
    vnetname: 'hub'
    addressSpaces: [
      hubVnetIPRange
    ]
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: hubVnetSub0IPRange
        }
      }
    ]
  }
}

module spokeVNET '../../Modules/vnet.bicep' = {
  name: 'spoke-vnet'
  scope: resourceGroup(spokerg.name)
  params: {
    vnetname: 'spoke'
    addressSpaces: [
      spokeVNETIPRange
    ]
    subnets: [
      {
        name: 'spoke-vnet'
        properties: {
          addressPrefix: spokeVNETSub0IPRange
        }
      }
    ]
  }
}

module spokeProxyVNET '../../Modules/vnet.bicep' = {
  name: 'spokeProxy'
  scope: resourceGroup(spokerg.name)
  params: {
    vnetname: 'proxy'
    addressSpaces: [
      spokeProxyVNETIPRange
    ]
    subnets: [
      {
        name: 'proxy'
        properties: {
          addressPrefix: spokeProxyVNETSub0IPRange
        }
      }
    ]
  }
}

module HubToSpokePeering '../../modules/peering.bicep' = {
  name: 'hub-to-spoke-peering'
  scope: resourceGroup(hubrg.name)
  params: {
    localVnetName: hubVNET.outputs.name
    remoteVnetName: 'spoke'
    remoteVnetId: spokeVNET.outputs.id
  }
}

module SpokeToHubPeering '../../modules/peering.bicep' = {
  name: 'spoke-to-hub-peering'
  scope: resourceGroup(spokerg.name)
  params: {
    localVnetName: spokeVNET.outputs.name
    remoteVnetName: 'hub'
    remoteVnetId: hubVNET.outputs.id
  }
}

module HubToSpokeProxyPeering '../../modules/peering.bicep' = {
  name: 'hub-to-spokeProxy-peering'
  scope: resourceGroup(hubrg.name)
  params: {
    localVnetName: hubVNET.outputs.name
    remoteVnetName: 'proxy'
    remoteVnetId: spokeProxyVNET.outputs.id
  }
}

module SpokeProxyToHubPeering '../../modules/peering.bicep' = {
  name: 'spokeProxy-to-hub-peering'
  scope: resourceGroup(spokerg.name)
  params: {
    localVnetName: spokeProxyVNET.outputs.name
    remoteVnetName: 'hub'
    remoteVnetId: hubVNET.outputs.id
  }
}

/*module hubfirewall 'Modules/fw.bicep' ={
  name: 'hubFirewall'
  scope: resourceGroup(hubrg.name)
  params: {
    subnetID:hubVNET.outputs.subnetids[0].id
    firewallName:'hubFirewall'
  }

}*/

module proxyVM '../../Modules/VmUbuntu.bicep'={
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

module proxyVMExtInstall '../../Modules/extension.bicep' = {
 scope:resourceGroup(spokerg.name)
  name: 'intallSquid'
  params:{
    vmName:proxyVM.outputs.VmName
    filesurls:'https://raw.githubusercontent.com/enekazo/Bicep/main/Modules/squidConfig/installsquid.sh, https://github.com/enekazo/Bicep/blob/main/Modules/squidConfig/whitelist.txt'
    script:'sh installsquid.sh'
  }  
}

