Import-Module $PSScriptRoot\CompareStrings\CompareStrings.psm1 -Force

$InfoLine = "CPU-INTEL6700K"
$WmiName = "Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz"

# To view the bigram hashtables
# Get-Bigrams $InfoLine
# @{"---" = "---"}
# Get-Bigrams $WmiName

$VectorMatch = Compare-BigramVectors -Vector1 (Get-Bigrams $InfoLine) -Vector2 (Get-Bigrams $WmiName)

Write-Output ("The bigram matching score of {0} compared to {1} is {2}" -f $InfoLine, $WmiName, $VectorMatch.Matches)

$VectorMatch