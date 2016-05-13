try
{
    $testVariable = 'This is a test.'

    Write-Host 'Statement before the error.'

    [System.IO.File]::ReadAllText('C:\does\not\exist.txt')
    
    Write-Host 'Statement after the error.'
}
catch [System.IO.IOException]
{
    Write-Host 'An IOException was caught.'
    Write-Host "Exception type: $($_.Exception.GetType().FullName)"
}
catch
{
    Write-Host 'Some other type of error was caught.'
}
finally
{
    $testVariable = 'The finally block was executed.'
}

Write-Host "`$testVariable = '$testVariable'."
