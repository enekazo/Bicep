param domainName string = 'cloudsquare.co.uk'
param subnetId string 
param location string 

resource aadds 'Microsoft.AAD/domainServices@2020-01-01' = {
  name: domainName
  location: location
  properties: {
    domainName: domainName
    domainSecuritySettings: {
      ntlmV1: 'Enabled'
      syncNtlmPasswords: 'Enabled'
      tlsV1: 'Enabled'
    }
    filteredSync: 'Disabled'
    ldapsSettings: {
      externalAccess: 'Disabled'
      ldaps: 'Disabled'
    }
    notificationSettings: {
      notifyDcAdmins: 'Enabled'
      notifyGlobalAdmins: 'Enabled'
      additionalRecipients: []
    }
    replicaSets: [
      {
        subnetId: subnetId /*vnetWeE.properties.subnets[0].id*/
        location: location
      }
    ]
    sku: 'Standard'
  }
}



