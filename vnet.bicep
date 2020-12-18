resource vnetWEUSpoke1 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'aadds-eus-vnet'
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'aadds-subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}


resource nsgWEU 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: 'aadds-weu-nsg'
  location: 'westeurope'
  properties: {
    securityRules: [
      {
        name: 'AllowSyncWithAzureAD'
        properties: {
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureActiveDirectoryDomainServices'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowPSRemoting'
        properties: {
          access: 'Allow'
          priority: 301
          direction: 'Inbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureActiveDirectoryDomainServices'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '5986'
        }
      }
      {
        name: 'AllowRD'
        properties: {
          access: 'Allow'
          priority: 201
          direction: 'Inbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'CorpNetSaw'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}

resource vnetWEU 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'aadds-weu-vnet'
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'aadds-subnet'
        properties: {
          addressPrefix: '10.1.0.0/24'
          networkSecurityGroup: {
            id: nsgWEU.id
          }
        }
      }
    ]
  }
}

resource peerNEU 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: '${vnetWEUSpoke1.name}/${vnetWEUSpoke1.name}-peering-${vnetWEU.name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetWEU.id
    }
  }
}

resource peerWEU 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-06-01' = {
  name: '${vnetWEU.name}/${vnetWEU.name}-peering-${vnetWEUSpoke1.name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetWEUSpoke1.id
    }
  }
}

output aaddssudnet string = vnetWEU.properties.subnets[0].id

