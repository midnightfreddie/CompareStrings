Import-Module $PSScriptRoot\CompareStrings\CompareStrings.psm1 -Force

$InfoLine = "CPU-INTEL6700K"
$WmiName = "Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz"

Get-Bigrams $InfoLine
@{"---" = "---"}
Get-Bigrams $WmiName

Compare-BigramVectors -Vector1 (Get-Bigrams $InfoLine) -Vector2 (Get-Bigrams $WmiName)