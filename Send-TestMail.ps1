<# 
    .SYNOPSIS 
    Send test emails to a configured SMTP host

    Thomas Stensitzki 

    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 

    Version 1.1, 2016-11-29

    Please send ideas, comments and suggestions to support@granikos.eu 

    .LINK 
    More information can be found at http://scripts.granikos.eu

    .LINK
    EICAR test file information: http://www.eicar.org/86-0-Intended-use.html

    .DESCRIPTION 
    The script sends a given number of test email to a configured SMTP host for 
    test purposes (primarily Exchange queues, transport agents or anti-virus engines)
    
 
    .NOTES 
    Requirements 
    - Windows Server 2008 R2 SP1, Windows Server 2012 or Windows Server 2012 R2  
    - A file containing some email body text (i.e. Exchange Environment Report output, )
    - A text file containing the EICAR test virus string (see http://www.eicar.org/86-0-Intended-use.html)
    - A non password protected compressed archive containing a file (i.e. DLL) that is prohobited bymalware agents
    - A password protected compressed archive to test malware agents
    
    Revision History 
    -------------------------------------------------------------------------------- 
    1.0 Initial community release 
    1.1 Some PowerShell fixes

    .PARAMETER Normal  
    Send a normal email containing an Html body and an non malware attachment

    .PARAMETER Archive
    Send an email containg an Html body and a non password protected archive containing mailcious content

    .PARAMETER ProtectedArchive
    Send an email containg an Html body and a password protected archive containing whatever content

    .PARAMETER Eicar
    Send an email containg an the Eicar test string as body and an Eicar test file as attachment
    Requires an EICAR test file named EICAR-TEST.txt 

    .PARAMETER MessageCount
    Number of email messages to send, default is 1, maximum 50
    
    .EXAMPLE 
    Send 10 normal emails
    .\Send-TestMail.ps1 -Normal -MessageCount 10

    .EXAMPLE
    Send an Eicar test email
    .\Send-TestMail.ps1 -Eicar
#> 
param(
[parameter(Mandatory=$true,HelpMessage='Send a normal email containing an Html body and an non malware attachment', ParameterSetName="Normal")]
		[switch]$Normal,
[parameter(Mandatory=$true,HelpMessage='Send an email containg an Html body and a non password protected archive containing mailcious content', ParameterSetName="Archive")]
		[switch]$Archive,
[parameter(Mandatory=$true,HelpMessage='Send an email containg an Html body and a password protected archive containing whatever content', ParameterSetName="PArchive")]
		[switch]$ProtectedArchive,
[parameter(Mandatory=$true,HelpMessage='Send an email containg an the Eicar test string as body and an Eicar test file as attachment', ParameterSetName="Eicar")]
		[switch]$Eicar,
[parameter(Mandatory=$false)]
[ValidateRange(1,50)]
[int]$MessageCount=1
)

# your SMTP "relay" server accepting your test messages for relaying
$SMTPServer = 'smtp.yourdomain.com'
$SMTPPort = 25 

# root folder for file attachments and Html body
$fileRoot = 'D:\Scripts'
$EicarTestFileName = 'EICAR-TEST.txt'
$AttachmentFileName = 'Attachment.html'
$PasswordProtectedZipFileName = 'PASSWORDPROTECTEDARCHIVE.7z'
$MaliciousArchiveFileName = 'MALICOUSARCHIVE.zip'


# for internal use only
$isAuthenticated = $false

# the other parameters to modify to suit your environment
$EmailFrom = 'OuterSpace <outerspace@external-domain.com>'
$EmailTo = @('Recipient 1 <recipient1@DOMAINTOTEST.COM>', 'Recipient 2 <recipient2@DOMAINTOTEST.COM>')
$SubjectNormal = 'SMTP TEST EMAIL NORMAL'
$SubjectProtectedArchive = 'SMTP TEST EMAIL PROTECTED ARCHIVE'
$SubjectMaliciousArchive = 'SMTP TEST EMAIL MALICIOUS ARCHIVE'
$SubjectEicar = 'SMTP TEST EMAIL EICAR'
$BodyFileNormal    = ('{0}\{1}' -f $fileRoot, $AttachmentFileName)
$FileProtectedArchive = ('{0}\{1}' -f $fileRoot, $PasswordProtectedZipFileName)
$FileMailciousArchive = ('{0}\{1}' -f $fileRoot, $MaliciousArchiveFileName)
$FileNormal = ('{0}\{1}' -f $fileRoot, $AttachmentFileName)
$FileEicar = ('{0}\{1}' -f $fileRoot, $EicarTestFileName)

# Some default body string
$Body = 'Default body text - Loading body from file might have failed!'

# time stamp will be added to email subject
$Date = Get-Date -Format "dd.MM.yyyy HH:mm"

if($Normal) { # for normal email
    $AttachmentFile = $FileNormal
    $BodyFile = $BodyFileNormal
    $Subject = "$SubjectNormal $Date"
}
if($Archive){ # for malicious archive
    $AttachmentFile = $FileMailciousArchive
    $BodyFile = $BodyFileNormal # use  the same Html body as for a normal email
    $Subject = "$SubjectMaliciousArchive $Date"
}
if($ProtectedArchive) { # for password protected archive
    $AttachmentFile = $FileProtectedArchive
    $BodyFile = $BodyFileNormal # use  the same Html body as for a normal email
    $Subject = "$SubjectProtectedArchive $Date"
}
if($Eicar){ # for EICAR test virus
    $AttachmentFile = $FileEicar
    $BodyFile = $FileEicar # use the EICAR test string a email body
    $Subject = "$SubjectEicar $Date"
}

# Check if file exists
if(Test-Path $BodyFile) {
    # Read body from file
    $File = Get-Content $BodyFile -Encoding UTF8
    $Body = $File | Out-String
}

$Attachment = $null

# Check for attachment and detch from disk, if possible
if(Test-Path $AttachmentFile) { 
    $Attachment = $AttachmentFile }

# Loop to send messages
for($i=1;$i -le $MessageCount;$i++){
    
    $MailSubject ="$Subject - $i" 
    Write-Output "Sending: $MailSubject"

    if($Attachment -eq $null) {
        Send-MailMessage -Subject $MailSubject -From $EmailFrom -To $EmailTo -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort 
    }
    else {
        Send-MailMessage -Subject $MailSubject -From $EmailFrom -To $EmailTo -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -Attachments $Attachment
    }
}