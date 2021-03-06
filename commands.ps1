# Specify the Istio version that will be leveraged throughout these instructions

$ISTIO_VERSION="1.7.3"

[Net.ServicePointManager]::SecurityProtocol = "tls12"
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -URI "https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istioctl-$ISTIO_VERSION-win.zip" -OutFile "istioctl-$ISTIO_VERSION.zip"
Expand-Archive -Path "istioctl-$ISTIO_VERSION.zip" -DestinationPath .

###########################################################

# Copy istioctl.exe to C:\Istio
New-Item -ItemType Directory -Force -Path "C:\Istio"
Move-Item -Path .\istioctl.exe -Destination "C:\Istio\"

# Add C:\Istio to PATH. 
# Make the new PATH permanently available for the current User
$USER_PATH = [environment]::GetEnvironmentVariable("PATH", "User") + ";C:\Istio\"
[environment]::SetEnvironmentVariable("PATH", $USER_PATH, "User")
# Make the new PATH immediately available in the current shell
$env:PATH += ";C:\Istio\"

##############################################################

# Install the operator
istioctl operator init

##############################################################

See istio.yml config

##############################################################

# Create Istio namespace and deploy the YAML

kubectl create ns istio-system

# The below takes well over 10 minutes to get up and running, so I have it already running on my AKS cluster.

kubectl apply -f .\istio.aks.yml -n istio-system

##############################################################

# Open the Kiali dashboard
istioctl dashboard kiali
