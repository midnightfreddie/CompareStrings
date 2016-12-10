Import-Module $PSScriptRoot\CompareStrings\CompareStrings.psm1 -Force

$InfoLine = "CPU-INTEL6700K"
$WmiName = "Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz"

Get-Bigrams $InfoLine