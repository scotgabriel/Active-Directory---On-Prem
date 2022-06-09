# Can be run on it's own, or place in path specified in associated cmd file

$timenow = Get-Date
$currentUser = $env:USERNAME
$currentUserDomain = $env:USERDNSDOMAIN

if (Test-NetConnection -ComputerName $currentUserDomain)
{
    $expirationTime = (Get-ADUser -Identity $currentUser -properties msDS-UserPasswordExpiryTimeComputed).'msDS-UserPasswordExpiryTimeComputed' | ForEach-Object -Process {[datetime]::FromFileTime($_)}
    $daysleft = new-timespan -start $timenow -end $expirationTime
    $daysleft = $daysleft.Days

Write-Output "You have ****** $daysleft ****** until your password expires on $expirationTime"
} else {
    write-ouput "Can't reach a Domain Controller"
}

Read-Host -Prompt "Press Enter to continue"

