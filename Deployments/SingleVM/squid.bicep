
targetScope = 'subscription'

param region string = 'westeurope'
param spokeProxyVNETIPRange  string = '192.168.0.0/24'
param spokeProxyVNETSub0IPRange  string = '192.168.0.0/24'
param filesurls array =[
  'https://raw.githubusercontent.com/enekazo/Bicep/main/Modules/squidConfig/installsquid.sh'
  'https://raw.githubusercontent.com/enekazo/Bicep/main/Modules/squidConfig/whitelist.txt'
  'https://raw.githubusercontent.com/enekazo/Bicep/main/Modules/squidConfig/squid.conf'
]

resource spokerg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'spoketestrg'
  location: region
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
    filesurls: filesurls
    script:'sh installsquid.sh'
  }  
}
