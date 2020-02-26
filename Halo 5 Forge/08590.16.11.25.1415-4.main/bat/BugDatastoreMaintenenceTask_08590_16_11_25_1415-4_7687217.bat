REM FARMPROC012
REM Client ID: 4000

set LOGFILE=BugDatastoreMaintenenceTask_08590_16_11_25_1415-4_7687217.log
"c:\farm\Corinth.Farm\Services\Live\Client\ClientPlugins\Corinth.BugDatastore.Maintenance.exe" /Command:RegisterBuild /Project:"AusarJira" /BuildVersion:"08590.16.11.25.1415-4" /Changelist:1660225 /IsContentBuild:True /EnlistmentRoot:"D:\Tools\Main\\" /DaysBackCheckinRange:1 /DaysForwardCheckinRange:1 /SendBigBrotherMail:False /JobId:7687217 >>%LOGFILE% 2>&1
