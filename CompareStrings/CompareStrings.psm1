# Don't want to include bigrams with punctuation or spaces
# This match should only include bigrams with two word characters which hopefully works with non-English Unicode, too
$ValidBigramMatch = '\w\w'

<#
.Synopsis
   String to HashTable of bigrams
.DESCRIPTION
   Given a String, returns a HashTable with character bigram strings as keys
   and the number of occurrences as a value.
.EXAMPLE
   Get-Bigrams "This is a string!"
.PARAMETER String
   The string to convert to a bigram vector
#>
function Get-Bigrams {
    [cmdletbinding()]
    [outputtype([hashtable])]
    param (
        [Parameter(Mandatory=$true)][string]$String
    )
    $Bigrams = @{}
    for ($i = 0; $i -le $String.Length - 2; $i++) {
        $Bigram = ($String[$i..($i+1)] -join "").ToLower()
        if ($Bigram -match $ValidBigramMatch) {
            $Bigrams[$Bigram] += 1
        }
    }
    Write-Output $Bigrams
}

<#
.Synopsis
   Returns matching bigram counts
.DESCRIPTION
   Given two bigram occurence HashTables (like the output of Get-Bigrams),
   return an object with the number of bigram matches between them and
   match ratio for each vector.
.EXAMPLE
   Compare-BigramVectors -Vector1 @{"ab" = 1} -Vector2 @{"ab" = 2}
.EXAMPLE
   Compare-BigramVectors -Vector1 (Get-Bigrams "Hello") -Vector2 (Get-Bigrams "He'll be sorry")
.PARAMETER Vector1
   A HashTable of bigram strings as keys with the number of occurrences as the value
.PARAMETER Vector2
   A HashTable of bigram strings as keys with the number of occurrences as the value
#>
function Compare-BigramVectors {
    [cmdletbinding()]
    [outputtype([psobject])]
    param(
        [Parameter(Mandatory=$true)][hashtable]$Vector1,
        [Parameter(Mandatory=$true)][hashtable]$Vector2
    )
    $BigramMatches = 0
    $Vector1.GetEnumerator() | ForEach-Object {
        # If the bigram exists in both vectors...
        if ($Vector2[$PSItem.Name]) {
            # Count the matches. It is possible for each bigram to have multiple occurences (value > 1) in both
            #   hashes, so using Minimum to bump up the matches once for each of the lower-occuring bigram
            $BigramMatches += (
                $Vector1[$PSItem.Name] , $Vector2[$PSItem.Name] |
                    Measure-Object -Minimum
            ).Minimum
        }
    }
    New-Object psobject -Property ([ordered]@{
        Matches = $BigramMatches
        Vector1Match = $BigramMatches / (
            $Vector1.GetEnumerator() |
                Select-Object -ExpandProperty Value |
                Measure-Object -Sum
        ).Sum
        Vector2Match = $BigramMatches / (
            $Vector2.GetEnumerator() |
                Select-Object -ExpandProperty Value |
                Measure-Object -Sum
        ).Sum
    })
}