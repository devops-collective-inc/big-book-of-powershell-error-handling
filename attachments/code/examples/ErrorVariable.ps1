$err = $null

Get-ChildItem -Path C:\Temp -File -Recurse -ErrorVariable +err -ErrorAction SilentlyContinue |
Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-60) } | 
Remove-Item -Force -ErrorVariable +err -ErrorAction SilentlyContinue

foreach ($errorRecord in $err)
{
    # Take action based on the error(s) that occurred, if any.
}
