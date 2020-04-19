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

# $baseuri = /profile/wow/character/{realmSlug}/{characterName}/equipment

$URL = "https://us.api.blizzard.com/profile/wow/character/" + $realm + "/" + $char +  "/equipment?namespace=profile-us&locale=en_US&access_token=" + $token.access_token

#$url

$equip = Invoke-WebRequest -Uri $URL

$equipment = $equip | ConvertFrom-Json

$equipment.equipped_items | ForEach-Object {Write-Host $_.quality.name, $_.slot.name, $_.name, $_.level.value}