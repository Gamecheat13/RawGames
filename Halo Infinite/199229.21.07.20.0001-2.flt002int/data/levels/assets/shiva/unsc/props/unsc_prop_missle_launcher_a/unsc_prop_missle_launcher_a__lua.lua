-- object unsc_prop_missle_launcher_a__dm
-- author: Christopher Daugherty  //  Cynthia Fenton-Quijano
-- 01/14/2020
--## SERVER
REQUIRES('scripts\ParcelLibrary\parcel_rockridge_missile_launcher.lua');

hstructure unsc_prop_missle_launcher_a__dm
	meta		:table				-- required
	instance	:luserdata			-- required (must be first slot after meta to prevent crash

	animationType:string;					--$$ METADATA {"prettyName": "Animation Type", "source": ["rotation_1", "rotation_2", "rotation_3", "rotation_4", "rotation_5"], "groupName": "Scriptable Device", "tooltip": "Choose animation type for control message"}

	powerMessage:string						--$$ METADATA {"prettyName": "Receive Power Broadcast", "groupName": "Broadcast Channels", "tooltip": "Set Power Channel that Device will listen to."}
	controlMessage:string					--$$ METADATA {"prettyName": "Recieve Control Broadcast", "groupName": "Broadcast Channels", "tooltip": "Set Control Channel that Device will listen to."}

	debugStart:boolean						--$$ METADATA {"prettyName": "Debug Test", "groupName": "DEBUG", "tooltip": "Check this and map reset to auto fire rocket for test."}

	missileLauncherParcel:table

end

function unsc_prop_missle_launcher_a__dm:init()
	if (self.powerMessage == nil or self.powerMessage == "") and (self.controlMessage == nil or self.controlMessage == "") then
		return;
	end

	self.missileLauncherParcel = TriggerableMissileLauncher:New(
			tostring(Object_GetName(self)) .. "missileLauncherParcel",
			self,
			self.animationType
	);

	self.missileLauncherParcel.CONFIG.powerMessage = self.powerMessage;
	self.missileLauncherParcel.CONFIG.controlMessage = self.controlMessage;

	self:ParcelAddAndStartOnSelf(self.missileLauncherParcel, self.missileLauncherParcel.instanceName);

	self:CreateThread(self.DebugStart, self);
end

function unsc_prop_missle_launcher_a__dm:DebugStart():void
	if self.debugStart and self.debugStart ~= nil then
		SleepSeconds(1);
		Object_SetFunctionValue(self, self.animationType, 1, 0)
	end
end