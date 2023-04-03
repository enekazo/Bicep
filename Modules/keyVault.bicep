param keyvaultName string = 'kvname01'
param remoteVnetName string
param remoteVnetId string

resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyvaultName
  location: resourceGroup().location
  properties: {
    enablePurgeProtection: true
    sku: 
  }
}
