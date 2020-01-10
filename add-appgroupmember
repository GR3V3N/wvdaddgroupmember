########Modules needed for this script to work
Import-Module Microsoft.RDInfra.RDPowerShell
Import-Module ActiveDirectory

########Change variables to fit your envoirment
$TeneantName = "defaultTeneant"
$HostPoolName = "WVD-HP-TEST-01"
$ApplicationGroupName = "WVD-APP-GROUP-TEST-01"
$SecurityGroup = "Default-Users-AppGroup"
$AadTenantId = "XXXX-XXXX-XXXX-XXXX-XXXXXXXX"

########WVD Service Account (The one used for creating the WVD solution, hostpool,appgroup and so on.)
$wvdcredz = Get-AutomationPSCredential -Name 'svc_testservice'

########Establish connection to wvd so we can manage it
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -ServicePrincipal -AadTenantId $AadTenantId -Credential $wvdcredz

########Default App Group

$defaultUsers = Get-ADGroupMember -Identity $SecurityGroup | Get-ADUser | select userPrincipalName -ExpandProperty userPrincipalName
$defaultUsersappgroup = Get-RdsAppGroupUser $TeneantName $HostPoolName $ApplicationGroupName | select UserPrincipalName -ExpandProperty UserPrincipalName

if (($defaultUsers -ne $null -or '') -and ($defaultUsersappgroup -ne $null -or '')) {

$comparedefault = Compare-Object -ReferenceObject $defaultUsers -DifferenceObject $defaultUsersappgroup 

    if ($comparedefault.SideIndicator -eq "<=") {
    
        foreach ($User in $comparedefault.InputObject) {
    
        Add-RdsAppGroupUser $TeneantName $HostPoolName $ApplicationGroupName -UserPrincipalName $User
        Write-Output "$User Added to $ApplicationGroupName"

        }

    }elseif ($comparedefault.SideIndicator -eq "=>") {
    
        foreach ($User in $comparedefault.InputObject) {

        Remove-RdsAppGroupUser $TeneantName $HostPoolName $ApplicationGroupName -UserPrincipalName $User
        Write-Output "$User Removed from $ApplicationGroupName"

        }

}}elseif ($defaultUsersappgroup -eq $null) {
    
    foreach ($User in $defaultUsers) {

    Add-RdsAppGroupUser $TeneantName $HostPoolName $ApplicationGroupName -UserPrincipalName $User
    Write-Output "$User Added to $ApplicationGroupName"

    }
}elseif ($defaultUsers -eq $null) {

    foreach ($User in $defaultUsersappgroup) {

    Remove-RdsAppGroupUser $TeneantName $HostPoolName $ApplicationGroupName -UserPrincipalName $User
    Write-Output "$User Removed from $ApplicationGroupName"
   } 
}
