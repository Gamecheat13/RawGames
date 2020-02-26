REM FARMPROC091
REM Client ID: 3000

set LOGFILE=BugDatastoreMaintenenceTask_09353_17_02_16_0957-2_8310120.log
"c:\farm\Corinth.Farm\Services\Live\Client\SoftwareStoreInstallations\Farm.Client.exe\1.1702.900.4983\ClientPlugins\Corinth.BugDatastore.Maintenance.exe" /Command:RegisterBuild /Project:"AusarJira" /BuildVersion:"09353.17.02.16.0957-2" /Changelist:1757065 /IsContentBuild:True /EnlistmentRoot:"D:\Tools\Main\\" /DaysBackCheckinRange:1 /DaysForwardCheckinRange:1 /SendBigBrotherMail:False /JobId:8310120 >>%LOGFILE% 2>&1
