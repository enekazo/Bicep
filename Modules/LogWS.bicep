param name string
param location string

resource logAnalyticsWS 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'pergb2018'
    }
  }
}

output wsId string = logAnalyticsWS.id
