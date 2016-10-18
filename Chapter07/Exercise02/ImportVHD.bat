@Echo Off

if [%1]==[] goto USAGE
if [%2]==[] goto USAGE

SET JAVA_HOME=C:\Program Files\Java\jre6
SET EC2_HOME=C:\AWS\ec2-api-tools-1.6.7.2
SET CLASSPATH=%CLASSPATH%;%EC2_HOME%\lib
SET PATH=%JAVA_HOME%\bin;%PATH%;%EC2_HOME%\bin.

SET AWS_ACCESS_KEY=PUT_YOUR_ACCESS_KEY_HERE
SET AWS_SECRET_KEY=PUT_YOUR_SECRET_KEY_HERE
SET BUCKET_NAME=MyBucket

ec2-import-instance %2 -t t1.micro -f %1 -a i386 -b %BUCKET_NAME% -o %AWS_ACCESS_KEY% -w %AWS_SECRET_KEY%

goto :EOF

:USAGE
Echo Usage:   ImportVHD.bat FileType FileName
Echo Example: ImportVHD.bat VHD MyFile.vhd
