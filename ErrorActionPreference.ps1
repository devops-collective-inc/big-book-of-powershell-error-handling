function Test-ErrorActionPreference ([string] $Preference)
{
    Write-Host ''
    Write-Host "Preference: $Preference"

    $ErrorActionPreference = $Preference
    Write-Host 'Statement before the error.'

    Get-Item C:\Does\Not\Exist.txt

    Write-Host 'Statement after the error.'
}

Test-ErrorActionPreference 'Continue'
Test-ErrorActionPreference 'SilentlyContinue'
Test-ErrorActionPreference 'Stop'
