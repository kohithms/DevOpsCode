#ConvertPAT Token

$accesstoken = $env:basicB64Token;

# Base64-encodes the Personal Access Token (PAT) appropriately

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "",$basicB64Token)))

$headers = @{authorization=("Basic {0}" -f $base64AuthInfo)}

$headers.Add("X-TFS-FedAuthRedirect","Suppress")

# Get content of releasenotes
$content = [IO.File]::ReadAllText("$(System.DefaultWorkingDirectory)\releasenotes.md")
# Get content of package.json for getting version value
$contentPackage = [IO.File]::ReadAllText("$(System.DefaultWorkingDirectory)\package.json") | ConvertFrom-Json;
# Concat the URI
$uri = $env:WikiUri +$env:WikiPath + $($contentPackage.version)

# Convert to json for Wiki API
$data = @{content=$content;} | ConvertTo-Json;
# Set Request
$params = @{uri = "$($uri)";
  Method = 'PUT';
  Headers = @{Authorization = "Basic $($env:basicB64Token)" };
  ContentType = "application/json";
  Body = $data;
}
# Call 
Invoke-WebRequest @params
