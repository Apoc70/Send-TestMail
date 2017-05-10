# Send-TestMail.ps1
Send test emails to a configured SMTP host

## Description
The script sends a given number of test email to a configured SMTP host for test purposes (primarily Exchange queues, transport agents or anti-virus engines)

## Parameters
### Normal  
Send a normal email containing an Html body and an non malware attachment

### Archive
Send an email containg an Html body and a non password protected archive containing mailcious content

### ProtectedArchive
Send an email containg an Html body and a password protected archive containing whatever content

### Eicar
Send an email containg an the Eicar test string as body and an Eicar test file as attachment
Requires an EICAR test file named EICAR-TEST.txt 

### MessageCount
Number of email messages to send, default is 1, maximum 50

## Examples
```
.\Send-TestMail.ps1 -Normal -MessageCount 10
```
Send 10 normal emails

```
.\Send-TestMail.ps1 -Eicar
```
Send an Eicar test email

## TechNet Gallery
Find the script at TechNet Gallery
* https://gallery.technet.microsoft.com/Send-test-emails-to-a98c1ca4


## Credits
Written by: Thomas Stensitzki

Stay connected:

* My Blog: http://justcantgetenough.granikos.eu
* Twitter: https://twitter.com/stensitzki
* LinkedIn:	http://de.linkedin.com/in/thomasstensitzki
* Github: https://github.com/Apoc70

For more Office 365, Cloud Security and Exchange Server stuff checkout services provided by Granikos

* Blog: http://blog.granikos.eu/
* Website: https://www.granikos.eu/en/
* Twitter: https://twitter.com/granikos_de