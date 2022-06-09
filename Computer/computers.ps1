#REQUIRES -Version 4.0

# Should be run from PDC-Emulator

# path definitions
#   root directory structure

$computersZipFile = $PsScriptRoot + "\ad-onprem-computers.zip"
$computerExport = $PsScriptRoot + "\ad-onprem-computers.csv"
$computerExport1 = $PsScriptRoot + "\ad-onprem-computers1.csv"
$computerExport2 = $PsScriptRoot + "\ad-onprem-computers2.csv"

# Get domain SID

$domainSid = (get-addomain).domainsid.value

# Computer known primaryGroupID
# 515 = Domain Computer
# 516 = Domain Controller (writable)
# 521 = Domain Controller (Read-Only)

get-adcomputer -filter * -properties * | `
    Select-Object `
        AccountExpirationDate, `
        accountExpires, `
        AccountLockoutTime, `
        BadLogonCount, `
        CannotChangePassword, `
        CanonicalName, `
        CN, `
        countryCode, `
        Created, `
        createTimeStamp, `
        Deleted, `
        Description, `
        DisplayName, `
        DistinguishedName, `
        DNSHostName, `
        dSCorePropagationData, `
        Enabled, `
        HomedirRequired, `
        HomePage, `
        instanceType, `
        IPv4Address, `
        IPv6Address, `
        isCriticalSystemObject, `
        isDeleted, `
        KerberosEncryptionType, `
        LastBadPasswordAttempt, `
        LastKnownParent, `
        lastLogon, `
        LastLogonDate, `
        lastLogonTimestamp, `
        Location, `
        LockedOut, `
        logonCount, `
        ManagedBy, `
        MemberOf, `
        MNSLogonAccount, `
        Modified, `
        modifyTimeStamp, `
        msDS-SupportedEncryptionTypes, `
        Name, `
        nTSecurityDescriptor, `
        ObjectCategory, `
        ObjectClass, `
        ObjectGUID, `
        objectSid, `
        OperatingSystem, `
        OperatingSystemHotfix, `
        OperatingSystemServicePack, `
        OperatingSystemVersion, `
        PasswordExpired, `
        PasswordLastSet, `
        PasswordNeverExpires, `
        PasswordNotRequired, `
        PrimaryGroup, `
        primaryGroupID, `
        ProtectedFromAccidentalDeletion, `
        pwdLastSet, `
        SamAccountName, `
        sAMAccountType, `
        sDRightsEffective, `
        ServiceAccount, `
        servicePrincipalName, `
        ServicePrincipalNames, `
        SID, `
        SIDHistory, `
        userAccountControl, `
        UserPrincipalName, `
        uSNChanged, `
        uSNCreated, `
        whenChanged, `
        whenCreated  | `
            export-csv -NoTypeInformation -path $computerExport2

# fixed headers that contain a hyphen <which can't be processed by powershell easily>
$content = Get-Content -path $computerExport2
$content[0] = $content[0] -replace "-", "_"
Set-Content -path $computerExport1 $content

# add DomainSID column and set it
Import-Csv $computerExport1 | Select-Object *,@{Name='DomainSID';Expression={$domainSid}} | Export-Csv $computerExport -NoTypeInformation

# final clean-up and deliverable
Compress-Archive -Force -path $computerExport -DestinationPath $computersZipFile
Remove-Item $computerExport, $computerExport1, $computerExport2
