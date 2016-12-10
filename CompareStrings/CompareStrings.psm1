function Get-Bigrams {
    param (
        [Parameter(Mandatory=$true)][string]$String
    )
    
    for ($i = 0; $i -lt $String.Length - 2; $i++) { 
        "Hi"
    }
}