function Get-Bigrams {
    param (
        [Parameter(Mandatory=$true)][string]$String
    )
    $Bigrams = @{}
    for ($i = 0; $i -lt $String.Length - 2; $i++) {
        $Bigram = $String[$i..($i+1)] 
        if ($Bigrams[$Bigram]) {
            $Bigrams[$Bigram] += 1
        } else {
            $Bigrams[$Bigram] = 1
        }
    }
    Write-Output $Bigrams
}