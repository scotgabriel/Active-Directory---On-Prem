# You should get ONE ad user account in the output, in the description is the name of the server that is running the service (assuming that a custom user account wasn't selected)

get-aduser -Filter * -Properties SamAccountName, Description | Where-Object {$_.SamAccountName -match "MSOL"}