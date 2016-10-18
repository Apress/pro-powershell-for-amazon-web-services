
#This script will enable SQL TDE and launch a new RDS instance that uses it

param(
    [parameter(mandatory=$true)][string]$DBInstanceIdentifier,
    [parameter(mandatory=$false)][string]$DBInstanceClass = 'db.m1.large',
    [parameter(mandatory=$false)][string]$Engine = 'sqlserver-ee',
    [parameter(mandatory=$false)][string]$AllocatedStorage = 200,
    [parameter(mandatory=$true)][string]$MasterUsername, 
    [parameter(mandatory=$true)][string]$MasterUserPassword,
    [parameter(mandatory=$true)][string]$DBSubnetGroupName, 
    [parameter(mandatory=$true)][string]$VpcSecurityGroupIds
)

Try {
    $OptionGroup = Get-RDSOptionGroup -OptionGroupName 'SQL2012TDE'
}
Catch [Amazon.RDS.Model.OptionGroupNotFoundException]{
    $OptionGroup = New-RDSOptionGroup -OptionGroupName 'SQL2012TDE' -OptionGroupDescription "SQL2012 with TDE" -EngineName sqlserver-ee -MajorEngineVersion '11.00'

    $Option = New-Object Amazon.RDS.Model.OptionConfiguration
    $Option.OptionName = 'TDE'

    Edit-RDSOptionGroup -OptionGroupName 'SQL2012TDE' -OptionsToInclude $Option -ApplyImmediately $true
}

$Instance = New-RDSDBInstance -DBInstanceIdentifier $DBInstanceIdentifier -Engine $Engine -AllocatedStorage $AllocatedStorage -DBInstanceClass $DBInstanceClass -MasterUsername $MasterUsername -MasterUserPassword $MasterUserPassword -DBSubnetGroupName $DBSubnetGroupName -VpcSecurityGroupIds $VpcSecurityGroupIds -OptionGroupName 'SQL2012TDE'

While ($Instance.DBInstanceStatus -ne 'available') {$Instance = Get-RDSDBInstance $DBInstanceIdentifier; Write-Host "Waiting for RDS instance to launch."; Start-Sleep -s 60}

$Address = (Get-RDSDBInstance -DBInstanceIdentifier $DBInstanceIdentifier).Endpoint.Address

Write-Host "The RDS instance $DBInstanceIdentifier is ready. The address is $Address."

