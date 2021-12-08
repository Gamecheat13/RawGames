-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('scripts\ParcelLibrary\parcel_stopwatch_daemon.lua');

global GlobalStopwatchDaemon:table = nil;

function startup.InitializeGlobalStopwatchDaemon():void
	TryAndCreateGlobalStopwatchDaemonParcel();
end

function TryAndCreateGlobalStopwatchDaemonParcel():void
	if (GlobalStopwatchDaemon == nil) then
		GlobalStopwatchDaemon = StopwatchDaemon:New();
		ParcelAddAndStart(GlobalStopwatchDaemon, GlobalStopwatchDaemon.instanceName);
	end
end