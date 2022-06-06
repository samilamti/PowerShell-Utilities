$Path = Join-Path $env:USERPROFILE Documents Temp
$Shell = New-Object -ComObject "Shell.Application"
$Namespace = $Shell.Namespace(0)
$SevenDaysOld = (Get-Date).AddDays(-7)
Get-ChildItem $Path | Where-Object { $_.LastAccessTime -le $SevenDaysOld } | ForEach-Object { $Namespace.ParseName($_).InvokeVerb("delete") }
