# C# code for our test cmdlet, as well as a .NET method that throws an exception.

$code = @'
    using System;
    using System.Management.Automation;

    [Cmdlet(VerbsDiagnostic.Test, "CmdletErrors")]
    public class TestCmdletErrorsCommand : PSCmdlet
    {
        [Parameter()]
        public SwitchParameter NonTerminating { get; set; }

        [Parameter()]
        public SwitchParameter Terminating { get; set; }

        [Parameter(ValueFromPipeline = true)]
        public Object InputObject { get; set; }

        private int i = 1;

        protected override void ProcessRecord()
        {
            if (this.NonTerminating)
            {
                var exception = new Exception("Test Cmdlet Non-Terminating Exception #" + i);
                var record = new ErrorRecord(exception, "System.Exception", ErrorCategory.NotSpecified, null);

                this.WriteError(record);
            
                i++;
            }
        }

        protected override void EndProcessing()
        {
            if (this.Terminating)
            {
                var exception = new Exception("Test Cmdlet Terminating Exception");
                var record = new ErrorRecord(exception, "System.Exception", ErrorCategory.NotSpecified, null);

                this.ThrowTerminatingError(record);
            }
        }
    }

    public static class ErrorTestClass
    {
        public static void MethodThatThrowsException()
        {
            throw new Exception("Test Exception from .NET method.");
        }
    }
'@

$dllName = "PowerShellErrorTests-v$($PSVersionTable.PSVersion.Major).dll"

if (-not (Test-Path $env:temp\$dllName))
{
    $params = @{
        TypeDefinition = $code
        Language = 'CSharpVersion3'
        OutputAssembly = "$env:temp\$dllName"
        ErrorAction = 'Stop'
    }

    if ($PSVersionTable.PSVersion.Major -ge 4)
    {
        $params['ReferencedAssemblies'] = 'System.Core'
    }

    Add-Type @params
}

Import-Module $env:temp\$dllName -ErrorAction Stop

# The Advanced Function version of the same cmdlet.  This uses Throw and Write-Error instead of
# PSCmdlet.ThrowTerminatingError() and PSCmdlet.WriteError().

function Test-FunctionErrors
{
    [CmdletBinding()]
    param (
        [Switch]
        $NonTerminating,

        [Switch]
        $Terminating,

        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )

    begin
    {
        $i = 1
    }

    process
    {
        if ($NonTerminating)
        {
            Write-Error "Test Function Non-Terminating Exception #$i"
            $i++
        }
    }

    end
    {
        if ($Terminating)
        {
            throw "Test Function Terminating Exception"
        }
    }
}

#
# Demonstrating PowerShell's behavior when terminating errors come from different sources
#
# Test-WithRethrow achieves consistent behavior, regardless of where the error came from.
#

function Test-WithoutRethrow
{
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'Cmdlet')]
        [switch]
        $Cmdlet,

        [Parameter(ParameterSetName = 'Function')]
        [switch]
        $Function,

        [Parameter(ParameterSetName = 'Method')]
        [switch]
        $Method,

        [Parameter(ParameterSetName = 'BadCommand')]
        [switch]
        $UnknownCommand,

        [Parameter(ParameterSetname = 'Cmdlet')]
        [Parameter(ParameterSetname = 'Function')]
        [switch]
        $Terminating,

        [Parameter(ParameterSetname = 'Cmdlet')]
        [Parameter(ParameterSetname = 'Function')]
        [switch]
        $NonTerminating
    )

    $params = @{
        Terminating = $Terminating
        NonTerminating = $NonTerminating
        ErrorAction = 'Stop'
    }

    "Before Terminating Error"
    ""
    
    if ($Cmdlet)
    {
        Test-CmdletErrors @params

    }
    elseif ($Function)
    {
        Test-FunctionErrors @params
    }
    elseif ($Method)
    {
        [ErrorTestClass]::MethodThatThrowsException()
    }
    elseif ($UnknownCommand)
    {
        BogusCommandThatDoesntExist
    }
    
    "After Terminating Error"
    ""
}

function Test-WithRethrow
{
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'Cmdlet')]
        [switch]
        $Cmdlet,

        [Parameter(ParameterSetName = 'Function')]
        [switch]
        $Function,

        [Parameter(ParameterSetName = 'Method')]
        [switch]
        $Method,
        
        [Parameter(ParameterSetName = 'BadCommand')]
        [switch]
        $UnknownCommand,

        [Parameter(ParameterSetname = 'Cmdlet')]
        [Parameter(ParameterSetname = 'Function')]
        [switch]
        $Terminating,

        [Parameter(ParameterSetname = 'Cmdlet')]
        [Parameter(ParameterSetname = 'Function')]
        [switch]
        $NonTerminating
    )

    $params = @{
        Terminating = $Terminating
        NonTerminating = $NonTerminating
        ErrorAction = 'Stop'
    }

    "Before Terminating Error"
    ""
    
    try
    {
        if ($Cmdlet)
        {
            Test-CmdletErrors @params

        }
        elseif ($Function)
        {
            Test-FunctionErrors @params
        }
        elseif ($Method)
        {
            [ErrorTestClass]::MethodThatThrowsException()
        }
        elseif ($UnknownCommand)
        {
            BogusCommandThatDoesntExist
        }
    }
    catch
    {
        throw
    }
    
    "After Terminating Error"
    ""
}