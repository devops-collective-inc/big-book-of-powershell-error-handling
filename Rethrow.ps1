Import-Module .\ErrorHandlingTests.psm1

function Test-Rethrow
{
    "Before terminating error."

    try
    {
        Test-CmdletErrors -Terminating
    }
    catch
    {
        throw
    }

    "After terminating error."
}

Test-Rethrow -Rethrow