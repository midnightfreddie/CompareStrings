# Don't want to include bigrams with punctuation or spaces
# This match should only include bigrams with two word characters which hopefully works with non-English Unicode, too
$ValidBigramMatch = '\w\w'

function Get-Bigrams {
    param (
        [Parameter(Mandatory=$true)][string]$String
    )
    $Bigrams = @{}
    for ($i = 0; $i -lt $String.Length - 2; $i++) {
        $Bigram = ($String[$i..($i+1)] -join "").ToLower()
        if ($Bigram -match $ValidBigramMatch) {
            $Bigrams[$Bigram] += 1
        }
    }
    Write-Output $Bigrams
}

# 
function Compare-BigramVectors {
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
    Write-Output $BigramMatches
}