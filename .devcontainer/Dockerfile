## Start from the dotnet base image to allow easy install of Powershell and ensure common tools are available for things like the bicep language server.
#FROM mcr.microsoft.com/dotnet/sdk:5.0

# Configure the release version of Bicep you'd like to use
#ARG BICEP_VERSION=latest
# Pinned to ensure compatability with dotnet version installed in container
#ARG POWSERSHELL_VERSION=7.1.1

# Install Azure CLI
#RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install common tooling
#RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#    && apt-get -y install --no-install-recommends curl build-essential

# Install Azure Powershell
#ENV PATH="$PATH:/root/.dotnet/tools"
#RUN \
##    dotnet tool install -g powershell --version $POWSERSHELL_VERSION \
 #   && pwsh -c "Install-Module -Name Az -AllowClobber -Scope AllUsers -Force"

# Install Bicep
#RUN \
    # Fetch the latest Bicep CLI binary
 #   curl -Lo bicep https://github.com/Azure/bicep/releases/${BICEP_VERSION}/download/bicep-linux-x64 \
    # Mark it as executable
 #   && chmod +x ./bicep \
    # Add bicep to your PATH (requires admin)
 #   && mv ./bicep /usr/local/bin/bicep \
    # Verify you can now access the 'bicep' command
  #  && bicep --help \
    # Download the bicep vscode extension for installation
    #&& curl -Lo /tmp/vscode-bicep.vsix https://github.com/Azure/bicep/releases/${BICEP_VERSION}/download/vscode-bicep.vsix

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog libssl1.1 2>&1 \
    #
    # Verify wget, jq, unzip, git and process tools installed
    && apt-get -y install git iproute2 procps wget unzip jq \
    #
    # Upgrade existing packages
    && apt-get -y upgrade \
    #
    # Install Docker CE CLI
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT) \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    #
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

CMD ["bash"]