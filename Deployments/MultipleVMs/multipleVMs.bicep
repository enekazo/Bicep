
//vnet-subnet sybolic reference 

resource vnetSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing ={
  name: '${'hub'}/${'Other'}'
  scope:resourceGroup('hubtestrg')
}

/*module vdiVms '../Modules/VmUbuntu.bicep'= [for i in range(0, 2):{
  name: '${i}proxyvm'
  scope: resourceGroup('hubtestrg')
  params:{
    vmName:'${i}evvms'
    adminPasswordOrKey:'!Pass@word1234'
    adminUsername:'evadmin'
    dnsLabelPrefix:'evproxyvm'
    subnetID:vnetSubnet.id
    deployVMExt: false
  }
}]*/

module vdiWind  '../Modules/Windows.bicep' = [for i in range(0,2): {
  name:'${i}vdiwinev'
  scope: resourceGroup('hubtestrg')
  params:{
    vmName: '${i}simple-vm'
    nicName: '${i}myVMNic'
    adminPassword:'!Pass@word1234'
    adminUsername:'evadmin'
    subnetID:vnetSubnet.id
    customScript: true
  }
}]
