-- object saber_launch_kit
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER
--

hstructure saber_launch_kit
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")

	initialDelay:number						--$$ METADATA {"prettyName": "Initial Delay", "tooltip": "Set Initial Delay for first activation"}
	timerLower:number						--$$ METADATA {"prettyName": "Timer Length Min", "tooltip": "Set Timer length in seconds for the minimum amount"}
	timerUpper:number						--$$ METADATA {"prettyName": "Timer Length Max", "tooltip": "Set Timer length in seconds for the maximum amount"}
end

function saber_launch_kit:init()
	
	
	CreateKitThread(self, self.LaunchLoop, self)
end

function saber_launch_kit:LaunchLoop():void
	SleepSeconds(self.initialDelay)

	repeat
	composer_play_show_handle(self.components.saber_launch);

	SleepSeconds(self:RandomTimer() or 60);
	until false;
end

function saber_launch_kit:RandomTimer():number
	local randNum:number = real_random_range(self.timerLower, self.timerUpper);
	return randNum;
end