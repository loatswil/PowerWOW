# Pulling pets for a specified character from the 
# Blizzard API

Param(
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ValidateNotNullOrEmptyAttribute()]
        [string] $char,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.ValidateNotNullOrEmptyAttribute()]
        [string] $realm
)

$Creds = Import-Csv ..\creds.csv
$ClientSecret = $Creds.clientSecret
$ClientID = $Creds.clientID

# $char = Read-Host -Prompt "Character Name?"
# $realm = Read-Host -Prompt "Realm?"

$Url = "https://us.battle.net/oauth/token"

$Body = @{
  'client_id' = $ClientID
  'client_secret' = $ClientSecret
  'grant_type' = 'client_credentials'
}

$token = Invoke-RestMethod -Method Post -Uri $Url -Body $Body

# $baseuri = /profile/wow/character/{realmSlug}/{characterName}/equipment

$URL = "https://us.api.blizzard.com/profile/wow/character/" + $realm + "/" + $char +  "/collections/pets?namespace=profile-us&locale=en_US&access_token=" + $token.access_token

#$url

$pets = Invoke-WebRequest -Uri $URL

$petsobject = $pets | ConvertFrom-Json

$petsobject.pets | ForEach-Object {Write-Host $_.quality.type, $_.level, $_.species.name}

ForEach ($line in $petsobject.pets) {
    $properties = @{
    quality = $line.quality.type
    level = $line.level
    species = $line.species.name
    }

$allpets = New-Object psobject -Property $properties
$allpets
}