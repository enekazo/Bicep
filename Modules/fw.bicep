
//param virtualNetworkName string
//param vnetAddressPrefix string 
//param azureFirewallSubnetAddressPrefix string 
param firewallName string 
param location string = resourceGroup().location
param availabilityZones array = [
  '1'
]
param numberOfPublicIPAddresses int = 1
param subnetID string

var azureFirewallSubnetName = 'AzureFirewallSubnet'

var azureFirewallIpConfigurations = [for i in range(0, numberOfPublicIPAddresses): {
  name: 'IpConf${i}'
  properties: {
    subnet: ((i == 0) ? json('{"id": "${subnetID}"}') : json('null'))
    publicIPAddress: {
      id: '${azureFirewallPublicIpId}${i + 1}'
    }
  }
}]

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: 'publicIp1'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2022-01-01'= {
  name: 'firewallPolicyName'
  location: location
  properties: {
    threatIntelMode: 'Alert'
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2021-03-01' = {
  name: firewallName
  location: location
  zones: ((length(availabilityZones) == 0) ? null : availabilityZones)
  dependsOn: [
    publicIP
  ]
  properties: {
    ipConfigurations: firewallPolicy
    firewallPolicy: {
      id: firewallPolicy.id
    }
  }
}

resource firewall2 'Microsoft.Network/azureFirewalls@2020-06-01' = {
  name: firewallName
  location: location
  zones: length(availabilityZones) == 0 ? json('null') : availabilityZones
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf1'
        properties: {
          subnet: {
            id: subnetID
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    applicationRuleCollections: [
      {
        name: 'appRc1'
        properties: {
          priority: 101
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'appRule1'
              protocols: [
                {
                  port: 80
                  protocolType: 'Http'
                }
              ]
              targetFqdns: [
                'www.microsoft.com'
              ]
              sourceAddresses: [
                '10.0.0.0/24'
              ]
            }
          ]
        }
      }
    ]
    networkRuleCollections: [
      {
        name: 'netRc1'
        properties: {
          priority: 200
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'netRule1'
              protocols: [
                'TCP'
              ]
              sourceAddresses: [
                '10.0.0.0/24'
              ]
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '8000-8999'
              ]
            }
          ]
        }
      }
    ]
  }
}
