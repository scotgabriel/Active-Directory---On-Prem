#REQUIRES -Version 4.0

# path definitions
#   root directory structure

$groupsZipFile = $PsScriptRoot + "\ad-onprem-groups.zip"
$groupExport = $PsScriptRoot + "\ad-onprem-groups.csv"
$groupExport1 = $PsScriptRoot + "\ad-onprem-groups1.csv"

# Get domain SID

$domainSid = (get-addomain).domainsid.value

# Group known groupType
# 2 = Global distribution group
# 4	= Domain local distribution group
# 8	= Universal distribution group
# -2147483646 = Global security group
# -2147483644 = Domain local security group
# -2147483640 = Universal security group

get-adgroup -filter * -properties * | `
    Select-Object `
        CanoniclaName, `
        CN, `
        Created, `
        createTimeStamp, `
        Deleted, `
        Description, `
        DisplayName, `
        DistinguishedName, `
        dSCorePropagationData, `
        GroupCategory, `
        GroupScope, `
        groupType, `
        HomePage, `
        instanceType, `
        isDeleted, `
        LastKnownParent, `
        ManagedBy, `
        member, `
        MemberOf, `
        Members, `
        Modified, `
        modifyTimeStamp, `
        Name, `
        nTSecurityDescriptor, `
        ObjectCategory, `
        ObjectFlass, `
        ObjectGUID, `
        objectSid, `
        ProtectedFromAccidentalDeletion, `
        SamAccountName, `
        sAMAccountType, `
        sDRightsEffective, `
        SID, `
        SIDHistory, `
        uSNChanged, `
        uSNCreated, `
        whenChanged, `
        whenCreated | `
            export-csv -NoTypeInformation -path $groupExport1


# add DomainSID column and set it
Import-Csv $groupExport1 | Select-Object *,@{Name='DomainSID';Expression={$domainSid}} | Export-Csv $groupExport -NoTypeInformation

# final clean-up and deliverable
Compress-Archive -Force -path $groupExport -DestinationPath $groupsZipFile
Remove-Item $groupExport, $groupExport1
