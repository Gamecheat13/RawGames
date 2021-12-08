-- object shock_chain_tracer

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure shock_chain_tracer
	meta : table
	instance : luserdata
	ownerObject:object
	initialLocation: vector
	maxTracerDistance: number
	tracerRadius: number
	radialSearchRadius: number
	tracerAllowance: number
	collisionFilter: string

end

global g_TracerVars = table.makePermanent
{
	projectileSpeedDefs = 
	{
		[TAG(nil)] = 5000,
		[TAG('objects\weapons\proto\proto_volt_action\projectiles\proto_volt_action_secondary.projectile')] = 5000,
		[TAG('objects\weapons\proto\proto_arc_zapper\projectiles\arc_zapper.projectile')] = 350, -- artifically faster
		[TAG('objects\weapons\proto\proto_lightning_grenade\proto_lightning_grenade_first_sub.projectile')] = 5000,
	},
	
}

function shock_chain_tracer:init() : void 
	self.ownerObject = Object_GetDamageOwnerObject(self);


	--init table

	self.maxTracerDistance = self.maxTracerDistance or 3.5;
	self.tracerRadius = self.tracerRadius or 0.05;
	self.radialSearchRadius = self.radialSearchRadius or 0.05;
	self.tracerAllowance = self.tracerAllowance or (0.5*2); -- x2 for both sides of the tracer
	self.collisionFilter = self.collisionFilter or "environment_play_collision";
	CreateObjectThread(self, self.CustomInitThread, self);
end

function shock_chain_tracer:CustomInitThread():void

	-- lighting grenade exceptions
	local lgMode = false
	if ( Object_GetDefinition(self) == TAG('objects\weapons\proto\proto_lightning_grenade\proto_lightning_grenade_first_sub.projectile') ) then
		lgMode = true
		self.collisionFilter = "small_crate";
		self.tracerRadius = 0.01;
		self.radialSearchRadius = 2.75;
		self.maxTracerDistance = 2.5;

	end

	local loc = location(self,"fx_root")
	self.initialLocation = loc.vector

	
	local startingTime:time_point = time_point();

	SleepUntilSeconds ([|object_get_function_value(self, "projectile_attach")>=1], 0); -- wait for attach

	local totalElapsedTime:time_point = Game_TimeGet();
	local elapsedSeconds = totalElapsedTime:ElapsedTime(startingTime); -- get duration of our sleep

	local speed = g_TracerVars.projectileSpeedDefs[Object_GetDefinition(self)] or 5000;

	local distance = speed*elapsedSeconds;
	local fwd = Object_GetForward(self)

	if (lgMode) then			
		local objs = Object_GetObjectsInSphere( location(self, ""), self.radialSearchRadius) -- radial search for the source
		local projTag = TAG('objects\weapons\proto\proto_lightning_grenade\proto_lightning_grenade.projectile')

		-- uncomment for range debug
		--RenderDebugSphereFilled(location(self, ""), self.radialSearchRadius, 0.1, 1.0, 1.0, 1.0)

		for _, target in hpairs(objs) do
			if (Object_GetDefinition(target) == projTag ) then	-- only look for the cluser master proj

				if (Object_GetDamageOwnerObject(target) == self.ownerObject) then --only projectiles I own
					local objLoc = location(target, "");
					RunClientScript("DrawTracerBeam", self, target, objLoc.vector, self.maxTracerDistance+self.tracerAllowance);
					break;
				end
			end
		end

	else 
	
		if (distance>self.maxTracerDistance) and (Object_GetParent(self)) then
		
			-- raycast backtrace method
			local rayCastResult:table = Physics_CapsuleCast( location(self, ""), location( location(self, "").vector+(fwd*self.maxTracerDistance*-1) ), fwd*-1, self.tracerRadius, self.collisionFilter, {Object_GetParent(self),} )
			if ( rayCastResult ~=nil) then
			
				self.initialLocation = rayCastResult.position;
				-- validate the backtrace
				local objs = Object_GetObjectsInSphere( self.initialLocation, self.radialSearchRadius) -- search for the source

				for _, target in hpairs(objs) do
					if ( (self.ownerObject~=nil) and (target==self.ownerObject) ) then -- owner condition
						break; -- exit 
					else 
						if (Object_IsUnit(target) or (Engine_GetObjectType( target ) == OBJECT_TYPE._object_type_crate)) then -- check valid chaining types

							RunClientScript("DrawTracerBeam", self, target, self.initialLocation.vector,self.maxTracerDistance+self.tracerAllowance);
							break;
					
						end
					end
				
				end

			end
		end
	end
end

--## CLIENT
function remoteClient.DrawTracerBeam(attachObj, initialObj, initialLocation:vector, maxDist:number) : void
	-- create a connection between the projectile and the location found by the trace.
	if (attachObj) then -- this can be nil for the initial attack
		local dist = DistanceBetweenLocations( location(Object_GetParent(attachObj), ""), location(initialLocation, "") ) -- confirm max allowance
		if ( dist <= (maxDist) ) then
			local _pfx = connection_effect_new(TAG('test\v-toruiz\fx\dev_proto_lightning_grenade_tesla_link.effect'), Object_GetParent(attachObj))
			connection_effect_update( _pfx, TAG('test\v-toruiz\fx\dev_proto_lightning_grenade_tesla_link.effect'), false, location(attachObj,"body") )
			Sleep(1); -- wait before update thread
			CreateThread(UpdateTracerBeam, _pfx, initialObj , Object_GetParent(attachObj)) -- start an update thread
			
		end
	end
end


function UpdateTracerBeam(effect, obj, attachObj)
	local wait:number = 0;

	repeat
		wait = wait + Game_TimeGetDelta();

		if(not object_index_valid(obj)) then -- validate inital object
			break;
		end

		local bodyLoc:location = location(obj,"body");
		if(bodyLoc~=nil) or (effect~=nil) then
			if ( not Vector_NearEqual( bodyLoc.vector, vector(0,0,0) )  ) then -- validate
				
				connection_effect_update( effect, TAG('test\v-toruiz\fx\dev_proto_lightning_grenade_tesla_link.effect'), false, bodyLoc )
			else
				connection_effect_update( effect, TAG('test\v-toruiz\fx\dev_proto_lightning_grenade_tesla_link.effect'), true, bodyLoc )
				break;
			end
		else
			break; -- exit
		end
		Sleep(1);
	until(wait > 0.4);

end
