# Pulling reputation for a specified character from the 
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

$URL = "https://us.api.blizzard.com/profile/wow/character/" + $realm + "/" + $char +  "/reputations?namespace=profile-us&locale=en_US&access_token=" + $token.access_token

$rep = Invoke-WebRequest -Uri $URL

$reputations = $rep | ConvertFrom-Json

# $reputations.reputations | ForEach-Object {Write-Output $_.faction.name, $_.standing.value  "/" $_.standing.max "-" $_.standing.name}

# $reputations.reputations | Select-Object -Property {$_.faction.name, $_.standing.value, $_.standing.max, $_.standing.name}

ForEach ($line in $reputations.reputations) {
    $value = $line.standing.value
    $max = $line.standing.max
    $properties = @{
    faction = $line.faction.name
    total = "$value/$max"
    standing = $line.standing.name
    }

$standings = New-Object psobject -Property $properties
$standings
}