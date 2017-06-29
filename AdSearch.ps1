<#
    A simulation of exporting an AD user list and encoding it for fuzzy search of AD users
    https://www.reddit.com/r/PowerShell/comments/6k2c4a/anyone_want_to_look_at_this_and_tell_me_ways_i/
#>

Import-Module $PSScriptRoot\CompareStrings\CompareStrings.psm1 -Force

# Creates an XML file with AD Users and character bigrams of space-separated fields
function New-BigramSearchIndex {
    # You may not want "Filter *" in a prod or large environment!
    # Get-AdUser -Filter * | Select-Object SamAccountName, GivenName, Surname |
    Import-Csv -Path $PSScriptRoot\data\FakeAdUsers.csv |
        ForEach-Object {
            $PSItem | Add-Member -MemberType NoteProperty -Name "BiGrams" -Value (Get-Bigrams ('{0} {1} {2}' -f $PSItem.SamAccountName, $PSItem.GivenName, $PSItem.Surname)) -PassThru
        } |
        Export-Clixml $PSScriptRoot\data\AdUsersWithBigrams.xml
}

# Pass this search text and the exported-bigrammed AD user list (after Import-CliXml'ing it)
function Compare-ManyBigrams {
    param (
        [Parameter(Mandatory=$true)][string]$SearchText,
        [Parameter(Mandatory=$true)][psobject[]]$BigramObjectList,
        $ReturnTopResults = 5
    )
    $SearchBigrams = Get-Bigrams $SearchText
    $Result = New-Object System.Collections.ArrayList

    for ($i = 0; $i -lt $BigramObjectList.Count; $i++) {
        $Result.Add(
            (
                New-Object psobject -Property ([ordered]@{
                    Match = [math]::Round((Compare-BigramVectors -Vector1 $BigramObjectList[$i].Bigrams -Vector2 $SearchBigrams).Vector1Match, 5)
                    SamAccountName = $BigramObjectList[$i].SamAccountName
                    Givenname = $BigramObjectList[$i].GivenName
                    Surname = $BigramObjectList[$i].Surname
                })
            )
        ) | Out-Null
    }
    $Result | Sort-Object -Property Match -Descending | Select-Object -First $ReturnTopResults -Property * -ExcludeProperty BiGrams
}

# Load the AD user list with bigrams
$Users = Import-Clixml $PSScriptRoot\data\AdUsersWithBigrams.xml

# A few non-exact searches to demonstrate results
"Luvina", "Ashley", "Enrica", "Donavan", "Catherine", "Faraby", "mtp2004" | ForEach-Object {
    "`n${PSItem}`n"
    Compare-ManyBigrams -SearchText $PSItem -BigramObjectList $Users
}