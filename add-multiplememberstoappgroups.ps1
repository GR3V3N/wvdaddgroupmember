########Modules needed for this script to work
Import-Module Microsoft.RDInfra.RDPowerShell
Import-Module ActiveDirectory

########Change variables to fit your envoirment
$TeneantName = "defaultTeneant"
$HostPoolName = "WVD-HP-TEST-01"
$ApplicationGroupName = "WVD-APP-GROUP-TEST-01"
$SecurityGroup = "Default-Users-AppGroup"
$AadTenantId = "XXXX-XXXXXXX-XXXXX-XXXXXX"

########WVD Service Account (The one used for creating the WVD solution, hostpool,appgroup and so on.)
$wvdcredz = Get-AutomationPSCredential -Name 'svc_WVDTestAdmin'
$ADServiceAccountCredz = Get-AutomationPSCredential -Name 'runbookExecuter'

########Establish connection to wvd so we can manage it
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -ServicePrincipal -AadTenantId $AadTenantId -Credential $wvdcredz

########Default script part

try {

$defaultUsers = Get-ADGroupMember -Identity $SecurityGroup -Credential $ADServiceAccountCredz | Get-ADUser -Credential $ADServiceAccountCredz | select userPrincipalName -ExpandProperty userPrincipalName 
$defaultUsersappgroup = Get-RdsAppGroupUser $TeneantName $HostPoolName $ApplicationGroupName | select UserPrincipalName -ExpandProperty UserPrincipalName 

}catch {

throw $_

}

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

#########End of default script part

$ApplicationGroupName = "WVD-APP-GROUP-TEST-02"
$SecurityGroup = "Economy-Users-App-Group"


try {

$defaultUsers = Get-ADGroupMember -Identity $SecurityGroup -Credential $ADServiceAccountCredz | Get-ADUser -Credential $ADServiceAccountCredz | select userPrincipalName -ExpandProperty userPrincipalName 
$defaultUsersappgroup = Get-RdsAppGroupUser $TeneantName $HostPoolName $ApplicationGroupName | select UserPrincipalName -ExpandProperty UserPrincipalName 

}catch {

throw $_

}

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
