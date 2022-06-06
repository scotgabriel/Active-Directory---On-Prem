<#
1. User mistypes password
2. Event ID 4625 is logged on the PDC
3. User mistypes password enough to lock out thier account
4. Event ID 4740 is logged on the PDC
#>
# https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4625
# Logon Type codes and status codes
# Account lockout Event ID and log
$badPwId = 4625
$LogName = "Security"
# Find the PDC
$Computer = $env:COMPUTERNAME
try {
    # Get the events from the PDC
    $events = Get-WinEvent -ComputerName $Computer -ErrorAction Stop -FilterHashtable @{
        LogName = $LogName
        ID      = $badPwId
    }
    # Correlate the logon types
    $LogonType = @{
        '2'  = 'Interactive'
        '3'  = 'Network'
        '4'  = 'Batch'
        '5'  = 'Service'
        '7'  = 'Unlock'
        '8'  = 'Networkcleartext'
        '9'  = 'NewCredentials'
        '10' = 'RemoteInteractive'
        '11' = 'CachedInteractive'
    }
    Clear-Host
    ForEach ($event in $events) {
        [pscustomobject]@{
            Account             = $event.properties.Value[5]
            LogonType           = $LogonType["$($event.properties.Value[10])"]
            CallingComputer     = $event.Properties.Value[13]
            IPAddress           = $event.Properties.Value[19]
            TimeStamp           = $event.TimeCreated
            "Failure Reason"    = ($event.Message -split "\n" | Select-String "Failure Reason:\s+(.+)").Matches[0].Groups[1].Value
            "Failure Status"    = ($event.Message -split "\n" | Select-String "Status:\s+(.+)").Matches[0].Groups[1].Value
            "Failure SubStatus" = ($event.Message -split "\n" | Select-String "Sub Status:\s+(.+)").Matches[0].Groups[1].Value
        }
    }
}
catch {
    Write-Warning $Error[0].Exception.Message
}