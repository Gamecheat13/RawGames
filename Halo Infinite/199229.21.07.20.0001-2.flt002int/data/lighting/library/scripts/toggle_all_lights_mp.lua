-- object toggle_all_lights_mp

hstructure toggle_all_lights_mp
    meta:table;
    instance:luserdata;
    components:userdata;
	
	triggerUnloads:boolean;		--$$ METADATA {"visible": true}
	fade:boolean;				--$$ METADATA {"visible": true}
	fadeTime:number; 			--$$ METADATA {"visible": true}

	-- Internal data
	lights:table;
	cones:table;
	fadeThread:thread;
	currentFadeTarget:number;
end

global ToggleAllLightsMPData:table = 
{
	updateDelay = 0.1,
};

function toggle_all_lights_mp:init():void
	self.fade = self.fade or false;
	self.fadeTime = self.fadeTime or 1;
	self.currentFadeTarget = 0;
	self:UpdateLights(self.currentFadeTarget);
end

function toggle_all_lights_mp:manual_toggle(toggle:boolean)
	self:KillFadeThread();

	if (toggle) then
		self:LightsOn();
	else
		self:LightsOff();
	end
end

function toggle_all_lights_mp:LightsOn():void
	if (self.currentFadeTarget == 1) then
		return;
	end

	if (self.fade) then
		self:KillFadeThread();
		self.fadeThread = CreateKitThread(self, self.FadeLights, self, 0, 1);
	else
		self:UpdateLights(1);
	end
end

function toggle_all_lights_mp:LightsOff():void
	if (self.currentFadeTarget == 0) then
		return;
	end

	if (self.fade) then
		self.fadeThread = CreateKitThread(self, self.FadeLights, self, 1, 0);
	else
		self:UpdateLights(0);
	end
end

function toggle_all_lights_mp:FadeLights(initial:number, target:number):void
	local startTime:time_point = Game_TimeGet();
	local current:number = initial;

	repeat
		local elapsed:number = Game_TimeGet():ElapsedTime(startTime);
		local t:number = Clamp(elapsed / self.fadeTime, 0, 1);

		current = (1 - t) * initial + t * target;
		self:UpdateLights(current);

		SleepSeconds(ToggleAllLightsMPData.updateDelay);
	until current == target;

	self.fadeThread = nil;
end

function toggle_all_lights_mp:UpdateLights(target:number):void	
	local lights:table = {
		self.components.player_intro_light_backleft,
		self.components.player_intro_light_backright,
		self.components.player_intro_light_front
	};

	self.currentFadeTarget = target;
	Fixture_SetAllLightsDimmerValue(lights, target);
end

function toggle_all_lights_mp:KillFadeThread():void
	if self.fadeThread ~= nil then
		KillThread(self.fadeThread);
		self.fadeThread = nil;
	end
end