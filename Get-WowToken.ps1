$Creds = Import-Csv ..\creds.csv
$ClientSecret = $Creds.clientSecret
$ClientID = $Creds.clientID

$Url = "https://us.battle.net/oauth/token"

$Body = @{
  'client_id' = $ClientID
  'client_secret' = $ClientSecret
  'grant_type' = 'client_credentials'
}

$token = Invoke-RestMethod -Method Post -Uri $Url -Body $Body

# $token

$headers = @{Authorization = "Bearer "+$token.access_token}

$price = Invoke-RestMethod -Method Get -Headers $headers -Uri https://us.api.blizzard.com/data/wow/token/?namespace=dynamic-us

$price.price