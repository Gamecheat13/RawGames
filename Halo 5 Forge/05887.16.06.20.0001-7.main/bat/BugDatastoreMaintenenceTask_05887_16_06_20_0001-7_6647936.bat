REM FRMPROCCLNT022
REM Client ID: 6000

set LOGFILE=BugDatastoreMaintenenceTask_05887_16_06_20_0001-7_6647936.log
"c:\farm\Corinth.Farm\Services\Live\Client\ClientPlugins\Corinth.BugDatastore.Maintenance.exe" /Command:RegisterBuild /Project:"AusarJira" /BuildVersion:"05887.16.06.20.0001-7" /Changelist:1499963 /IsContentBuild:True /EnlistmentRoot:"C:\Tools\Main\\" /DaysBackCheckinRange:1 /DaysForwardCheckinRange:1 /SendBigBrotherMail:False /JobId:6647936 >>%LOGFILE% 2>&1
