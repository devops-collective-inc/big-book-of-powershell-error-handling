#requires -Version 3.0

function Test-Function
{
    [CmdletBinding()]
    param ()

    $VerbosePreference = $DebugPreference = $ErrorActionPreference = $WarningPreference = 'Continue'

    Write-Warning 'Warning Output'
    Write-Error 'Error Output'
    Write-Verbose 'Verbose Output'
    Write-Debug 'Debug Output'

    Write-Output "Normal pipeline output."
}

function Test-StreamRedirection
{
    Test-Function *>&1 |
    ForEach-Object {
        $InputObject = $_

        "`$InputObject.GetType().FullName: $($InputObject.GetType().FullName)"

        if ($InputObject -is [System.Management.Automation.ErrorRecord])
        {
            # Handle the error record here
        }
        elseif ($InputObject -is [System.Management.Automation.WarningRecord])
        {
            # Handle the warning record here

        } # ... etc (VerboseRecord, DebugRecord)
        else
        {
            # Handle the object from the Output stream here
        }
    }
}

Test-StreamRedirection