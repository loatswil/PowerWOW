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

$token.access_token
