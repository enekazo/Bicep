
param vmName string 
param location string = resourceGroup().location
param script string  = 'apt install squid'
param filesurls array 

//"https://www.linuxhelp.com/how-to-install-and-configure-squid-proxy-in-ubuntu-20-4-1#:~:text=%20Install%20Squid%3A%20%201%20To%20install%20Squid,on%20Ubuntu%20comes%20to%20end..%20%20More%20"


resource vmext 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  name: '${vmName}/squid-app'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: filesurls
    }
    protectedSettings: {
      commandToExecute: script
    }
  }
}

