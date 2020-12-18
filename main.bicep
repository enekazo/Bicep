module dnsvnet './vnet.bicep' = {
  name: 'dnsvnet'  
}

module dnsaadds './aadds.bicep' = {
  name: 'dnsaadds'
  params: {
    location: 'westeurope'
    subnetId: dnsvnet.outputs.aaddssudnet
  }
  
}