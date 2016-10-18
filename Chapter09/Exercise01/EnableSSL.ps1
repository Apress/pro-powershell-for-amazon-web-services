
#This script will install the Amazon RDS root certificate on an instance

Invoke-WebRequest ‘https://rds.amazonaws.com/doc/rds-ssl-ca-cert.pem’ -OutFile "$env:TEMP\rds-ssl-ca-cert.pem" 

Import-Certificate -FilePath "$env:TEMP\rds-ssl-ca-cert.pem" -CertStoreLocation 'Cert:\LocalMachine\authRoot' -Confirm:$false

Remove-Item "$env:TEMP\rds-ssl-ca-cert.pem" 