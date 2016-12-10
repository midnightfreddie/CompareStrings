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

function Compare-Bigrams {
    param(
        [Parameter(Mandatory=$true)][hashtable]$Bigram1,
        [Parameter(Mandatory=$true)][hashtable]$Bigram2
    )
    $BigramMatches = 0
    $Bigram1.GetEnumerator() | ForEach-Object {
        if ($Bigram2[$PSItem.Name]) {
            $BigramMatches += (
                $Bigram1[$PSItem.Name] , $Bigram2[$PSItem.Name] |
                    Measure-Object -Minimum
            ).Minimum
        }
    }
    Write-Output $BigramMatches
}