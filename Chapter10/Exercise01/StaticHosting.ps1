
#This is an example of a static web site created from PowerShell

Param
(
    [string][parameter(mandatory=$false)]$FQDN = 'aws.brianbeach.com'
)

New-S3Bucket -BucketName $FQDN -PublicReadOnly

$Content = @"
<HTML>
  <HEAD>
    <TITLE>Hello World</TITLE>
  </HEAD>
  <BODY>
    <H1>Hello World</H1>
    <P>Hello from my Amazon Web Services site.</P>
  </BODY>
</HTML>
"@

Write-S3Object -BucketName $FQDN -Key 'index.htm' -Content $Content -ContentType 'text/html' -PublicReadOnly

$Content = @"
<HTML>
  <HEAD>
    <TITLE>Oops</TITLE>
  </HEAD>
  <BODY>
    <H1>Oops</H1>
    <P>Something seems to have gone wrong.</P>
  </BODY>
</HTML>
"@

Write-S3Object -BucketName $FQDN -Key 'error.htm' -Content $Content -ContentType 'text/html' -PublicReadOnly

Write-S3BucketWebsite -BucketName $FQDN -WebsiteConfiguration_IndexDocumentSuffix 'index.htm' -WebsiteConfiguration_ErrorDocument 'error.htm'