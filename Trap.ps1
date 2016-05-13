trap [System.IO.IOException]
{
    Write-Host 'An IOException was trapped.'
    break
}

trap
{
    Write-Host 'Some other type of error was trapped.'
    break
}

Write-Host 'Statement before the error.'

[System.IO.File]::ReadAllText('C:\does\not\exist.txt')
    
Write-Host 'Statement after the error.'
