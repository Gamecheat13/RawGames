-- object pelican_takeoff

-- Copyright (C) Microsoft. All rights reserved.
-- This KIT should is designed to be streamed and not initially placed

--## SERVER

REQUIRES('globals\scripts\global_ai.lua');
REQUIRES('globals\scripts\global_squad_create.lua');

hstructure pelican_takeoff
	meta : table;
	instance: luserdata;
	components: userdata;
	initialized: boolean;	
	pelican: object;
	pilot: ai;
	pelicanSquad: ai;
	lineupPoint: point;
	acceleratePoint: point;
	targetPoint: point;
	vehicleSeat: string;
	pelicanEffect: any;
	initialLocation: location;
	
	--tuneable design properties
	flightDelayTime: number; --$$ METADATA {"prettyName": "Flight Delay",  "min": 1.0, "max": 600.0, "tooltip": "Time it takes (in seconds) the Pelican to fly from accelerate point to target point"}
	flightBehavior: string; --$$ METADATA {"prettyName": "Flight Behavior", "source": ["Takeoff"]}
	velocityTime: number; --$$ METADATA {"prettyName": "Velocity Time",  "min": 1.0, "max": 20.0, "tooltip": "Time it takes (in seconds) the Pelican to fly from accelerate point to target point"}
end

function pelican_takeoff:init():void
	self.lineupPoint = self.components.ps_pelican01.lineup;
	self.acceleratePoint = self.components.ps_pelican01.accelerate;
	self.targetPoint = self.components.ps_pelican01.target;
	self.pelican =  self.components.pelican01;
	self.initialLocation = Object_GetPosition(self.pelican);
	self.vehicleSeat =  "pelican_d";
	self.pilot = SquadBuilder:BuildUnscSquadDescription(TAG('objects\characters\null\ai\null_human_flying.character'), "pilot", 1);
	self.flightBehavior = self.flightBehavior or "Takeoff";
	self.velocityTime = self.velocityTime or 5;
	self.flightDelayTime = self.flightDelayTime or 10;
	self.initialized = true;
	self.pelicanEffect = self.components.fx_pelican_wake;
	CreateKitThread(self, self.CustomInitThread, self);
	
end

function pelican_takeoff:GetComponents():void
	return self.components;
end

function pelican_takeoff:startEffect():void
	CreateEffectGroup(self.pelicanEffect);
end

function pelican_takeoff:stopEffect():void
	SleepUntil([|Object_GetDistanceSquaredToPosition(self.pelican, self.initialLocation) >= 20], 1);
	StopEffectGroup(self.pelicanEffect);
end

function pelican_takeoff:IsInitialized():void
	return self.initialized;
end

function pelican_takeoff:CustomInitThread():void
	SleepUntil ([|Object_IsPlayer(PLAYERS.player0), 1]);
	if object_index_valid(self.pelican) == true then
		SleepSeconds(self.flightDelayTime);
		self.pelicanSquad = SquadBuilder:PlaceSquad(self.pilot, vector(0,0,0), false);
		vehicle_load_magic(self.pelican, self.vehicleSeat, self.pelicanSquad);
		for _, actor in hpairs(ai_actors(self.pelicanSquad)) do
			if self.flightBehavior ~= nil then
				self:ApplyFlightBehavior(actor);
			end
		end
	else
		dprint("Something stopped the pelican from existing.");
	end
end

--BEHAVIOR DETERMINANT
function pelican_takeoff:ApplyFlightBehavior(actor:ai):void
	if self.flightBehavior == "Takeoff" then
		RunCommandScript(object_get_ai(actor), self.TakeoffAndLeave, self);
	else
		dprint("NO FLIGHT BEHAVIOR SELECTED.");
	end
end

--COMMAND SCRIPTS
function pelican_takeoff:TakeoffAndLeave():void
	ai_cannot_die(ai_current_actor, true);
	self:startEffect();
	CreateKitThread(self, self.stopEffect, self);
	SleepSeconds(3.0); -- added some delay for the pelican to take off
	cs_fly_to_and_face(ai_current_actor, true, self.lineupPoint, self.acceleratePoint);
	cs_fly_to_and_face(ai_current_actor, true, self.acceleratePoint, self.targetPoint);
	
	if object_index_valid(self.pelican) == true then
		object_override_physics_motion_type(self.pelican, 1);
		Object_TranslateToPoint(self.pelican, self.velocityTime, self.targetPoint, CURVE_BUILT_IN.EaseInOutCubic);

		ai_braindead(ai_current_actor);
		Object_SetScale(self.pelican, 0.01, 3.0);
		SleepSeconds(3);
		object_destroy(self.pelican);
	end
end

--## CLIENT