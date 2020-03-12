function Load-Module ($m) {

    # If module is imported say that and do nothing
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        write-host "Module $m is already imported."
    }
    else {

        # If module is not imported, but available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m -Verbose
        }
        else {

            # If module is not imported, not available on disk, but is in online gallery then install and import
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser -skippublishercheck
                Import-Module $m -Verbose
            }
            else {

                # If module is not imported, not available and not in online gallery then abort
                write-host "Module $m not imported, not available and not in online gallery, exiting."
                EXIT 1
            }
        }
    }
}


function Main()
{
#Load-Module Microsoft.Xrm.OnlineManagementAPI
Load-Module Microsoft.Xrm.Tooling.CrmConnector.Powershell
Remove-Module C:\Users\chxion\Documents\GitHub\Microsoft.Xrm.Data.PowerShell\Microsoft.Xrm.Data.PowerShell\Microsoft.Xrm.Data.PowerShell.psm1
Import-Module C:\Users\chxion\Documents\GitHub\Microsoft.Xrm.Data.PowerShell\Microsoft.Xrm.Data.PowerShell\Microsoft.Xrm.Data.PowerShell.psm1

$username="admin@CRM058785.onmicrosoft.com"
$password="5pita1b2sD"
$set_password=ConvertTo-SecureString $password -AsPlainText -Force
$cred=New-Object System.Management.Automation.PSCredential($username,$set_password)







$CrmOrg=Get-CrmOrganizations -Credential $Cred -OnLineType Office365

write-host "current organizations in your tenant"

foreach($item in $CrmOrg)
{
    $item.uniquename
}

$CrmOrgName=Read-Host -Prompt "please input org name you want to connect"

$CRMConn=Get-CrmConnection -Credential $Cred -OnLineType office365 -OrganizationName $CrmOrgName

New-OptionSetValue -conn $CRMConn -EntityLogicalName "rac_vehiclename" -FieldName "rac_vehiclebrand" -LabelName "test item" -LanguageCode 1033


$entityName = Read-Host -Prompt "please input entity name"

$attrs=Get-CrmEntityAttributes -conn $CRMConn -EntityLogicalName $entityName

$attrs | ForEach-Object{ if($_.AttributeType -eq "Picklist"){

write-host $_.LogicalName -ForegroundColo Green
write-host "----------------------------------"
$curAttr=Get-CrmEntityOptionSet -conn $CRMConn -EntityLogicalName $entityName $_.LogicalName

$curAttr.items | Format-Table



}
}


}

Main

