$Creds = Import-Csv ..\creds.csv
$ClientSecret = $Creds.clientSecret
$ClientID = $Creds.clientID

$char = Read-Host -Prompt "Character Name?"
$realm = Read-Host -Prompt "Realm?"

$Url = "https://us.battle.net/oauth/token"

$Body = @{
  'client_id' = $ClientID
  'client_secret' = $ClientSecret
  'grant_type' = 'client_credentials'
}

$token = Invoke-RestMethod -Method Post -Uri $Url -Body $Body

$URL = "https://us.api.blizzard.com/profile/wow/character/" + $realm + "/" + $char +  "/reputations?namespace=profile-us&locale=en_US&access_token=" + $token.access_token

$rep = Invoke-WebRequest -Uri $URL

$repxml = $rep | ConvertFrom-Json

$reputations = $repxml.reputations

$reputations | ForEach-Object {Write-Host $_.faction.name, $_.standing.value  "/" $_.standing.max "-" $_.standing.name}