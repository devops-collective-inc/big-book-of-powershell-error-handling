Write-Host 'Normal behavior of $?'

Get-Item c:\does\not\exist.txt
Write-Host "`$? = $?"

Write-Host
Write-Host 'Error-generating command in parentheses'

(Get-Item c:\does\not\exist.txt)
Write-Host "`$? = $?"

Write-Host
Write-Host 'Error-generating command in a sub-expression'

$(Get-Item c:\does\not\exist.txt)
Write-Host "`$? = $?"
