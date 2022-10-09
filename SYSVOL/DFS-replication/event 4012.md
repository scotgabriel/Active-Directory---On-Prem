If you have eventid 4012 in DFS replication logs, then review for the tombstoned length of time (by default anything over 60 days will tombstone).

Do NOT do the following without understanding the consequences (it will only make things worse if you don't know which DC to trust/replicate):

```powershell
$i = gwmi -namespace root\microsoftdfs -query 'Select * FROM DfsrMachineConfig'

# next line replace 75 with some number greater than current tombstoned days in eventlog
$i.MaxOfflineTimeInDays =[uint32]75
$i.Put()
Restart-Service -Name DFSR -Verbose
```
Logs will start showing syncing and will likely have missing SYSVOL/NETLOGON shares show up on any newer DC's that weren't syncing.
