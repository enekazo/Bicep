
//vnet-subnet sybolic reference 

resource vnetSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing ={
  name: '${'hub'}/${'Other'}'
  scope:resourceGroup('hubtestrg')
}

resource DiskEncrySet 'Microsoft.Compute/diskEncryptionSets@2020-12-01' existing ={
  name: 'evdiskencrytionset'
  scope:resourceGroup('hubtestrg')
}

resource OsImage 'Microsoft.Compute/galleries/images@2020-09-30' existing ={
  name: '${'evimageGalery'}/${'evimagedefinition'}'
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

module vdiWind  '../Modules/Windows.bicep' = [for i in range(0,1): {
  name:'${i}vdiwinev'
  scope: resourceGroup('hubtestrg')
  params:{
    vmName: '${i}simple-vm'
    nicName: '${i}myVMNic'
    adminPassword:'!Pass@word1234'
    adminUsername:'evadmin'
    subnetID:vnetSubnet.id
    customScript: false
    diskEncryptionSetID: DiskEncrySet.id
    ImageID: OsImage.id
  }
}]
