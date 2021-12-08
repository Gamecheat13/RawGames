-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

REQUIRES('scripts\ParcelLibrary\parcel_quick_tips.lua');

global QuickTipsInstance = nil;

function startup.QuickTipsStartup():void

	if QuickTipsInstance == nil then
		QuickTipsInstance = QuickTips:New();
		QuickTipsInstance.instanceName = "QuickTipsInstance";
		ParcelAddAndStart(QuickTipsInstance, QuickTipsInstance.instanceName);
	end
end

