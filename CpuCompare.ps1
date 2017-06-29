<#
    A simulation of a solution to the problem that inspired this project.
    https://www.reddit.com/r/PowerShell/comments/5hf2vi/help_compare_string_to_string/
#>

Import-Module $PSScriptRoot\CompareStrings\CompareStrings.psm1 -Force

$Info = Get-Content -Path $PSScriptRoot\data\info.txt | ForEach-Object {
    New-Object psobject -Property ([ordered]@{
        Info = $PSItem
        Vector = Get-Bigrams $PSItem
    })
}

$ThisCpu = (Get-CimInstance Win32_Processor).Name
$ThisCpuVector = Get-Bigrams $ThisCpu

$Result = New-Object System.Collections.ArrayList

for ($i = 0; $i -lt $Info.Count; $i++) {
    $Result.Add(
        (
            Compare-BigramVectors -Vector1 $Info[$i].Vector -Vector2 $ThisCpuVector |
                Add-Member -MemberType NoteProperty -Name "String1" -Value $Info[$i].Info -PassThru |
                Add-Member -MemberType NoteProperty -Name "String2" -Value $ThisCpu -PassThru
        )
    ) | Out-Null
}

$Result | Sort-Object -Property Vector1Match -Descending | Select-Object -First 10