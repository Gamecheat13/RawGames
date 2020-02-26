#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main(allowed)
{
	vehicles_enabled= false;
	
	/#
	//###stefan $NOTE don't remove vehicles when running the vehicle test maps
	if (level.script=="mp_ca_vehicle_test" || level.script=="mp_vehicle_test")
	{
		vehicles_enabled= true;
	}
	#/
	
	// setting this dvar affects the placement of any vehicles
	if (GetDvar("scr_vehicles_enabled")!="")
	{
		if (GetDvarInt("scr_vehicles_enabled")!=0)
		{
			vehicles_enabled= true;
		}
		else
		{
			vehicles_enabled= false;
		}
	}
	
	if (vehicles_enabled)
	{
		allowed[allowed.size]= "vehicle";
		filter_script_vehicles_from_vehicle_descriptors(allowed);
	}
	
	entities= GetEntArray();
	for (entity_index= entities.size-1; entity_index>=0; entity_index--)
	{
		entity= entities[entity_index];
		if (!entity_is_allowed(entity, allowed))
		{
			entity delete();
		}
	}
	
	return;
}

//bool
entity_is_allowed(
	entity,
	allowed_game_modes)
{
	allowed= true;
	
	// is entity allowed for any of the give game modes?
	if (IsDefined(entity.script_gameobjectname) &&
		entity.script_gameobjectname!="[all_modes]" )
	{
		allowed= false;
		// allow a space-separated list of gameobjectnames
		gameobjectnames= strtok(entity.script_gameobjectname, " ");
		for (i= 0; i<allowed_game_modes.size && !allowed; i++)
		{
			for (j= 0; j<gameobjectnames.size && !allowed; j++)
			{
				allowed= (gameobjectnames[j]==allowed_game_modes[i]);
			}
		}
	}
	
	return allowed;
}

// this function filters out script_vehicles (which are usually placed as prefabs)
// based on associated vehicle_descriptor objects
filter_script_vehicles_from_vehicle_descriptors(
	allowed_game_modes)
{
	vehicle_descriptors= GetEntArray("vehicle_descriptor", "targetname");
	script_vehicles= GetEntArray("script_vehicle", "classname");
	
	vehicles_to_remove= [];
	
	for (descriptor_index= 0; descriptor_index<vehicle_descriptors.size; descriptor_index++)
	{
		descriptor= vehicle_descriptors[descriptor_index];
		closest_distance_sq= 1000000000000.0;
		closest_vehicle= undefined;
		
		for (vehicle_index= 0; vehicle_index<script_vehicles.size; vehicle_index++)
		{
			vehicle= script_vehicles[vehicle_index];
			dsquared= DistanceSquared(vehicle GetOrigin(), descriptor GetOrigin());
			if (dsquared < closest_distance_sq) 
			{
				closest_distance_sq= dsquared;
				closest_vehicle= vehicle;
			}
		}
		
		if (IsDefined(closest_vehicle))
		{
			if (!entity_is_allowed(descriptor, allowed_game_modes))
			{
				vehicles_to_remove[vehicles_to_remove.size]= closest_vehicle;
			}
		}
	}
	
	for (vehicle_index= 0; vehicle_index<vehicles_to_remove.size; vehicle_index++)
	{
		vehicles_to_remove[vehicle_index] delete();
	}
	
	return;
}

init()
{
	level.numGametypeReservedObjectives = 0;
	
	precacheItem( "briefcase_bomb_mp" );
	precacheItem( "briefcase_bomb_defuse_mp" );
	precacheModel( "weapon_explosives" );

	level thread onPlayerConnect();
}

/*
=============
onPlayerConnect

=============
*/
onPlayerConnect()
{
	level endon ( "game_ended" );

	for( ;; )
	{
		level waittill( "connecting", player );
		
		player thread onPlayerSpawned();
		player thread onDisconnect();
	}
}


/*
=============
onPlayerSpawned

=============
*/
onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	for(;;)
	{
		self waittill( "spawned_player" );
		
		self thread onDeath();
		self.touchTriggers = [];
		self.carryObject = undefined;
		self.claimTrigger = undefined;
		self.canPickupObject = true;
		self.disabledWeapon = 0;
		self.killedInUse = undefined;
	}
}


/*
=============
onDeath

Drops any carried object when the player dies
=============
*/
onDeath()
{
	level endon ( "game_ended" );

	self waittill ( "death" );
	if ( isDefined( self.carryObject ) )
		self.carryObject thread setDropped();
}


/*
=============
onDisconnect

Drops any carried object when the player disconnects
=============
*/
onDisconnect()
{
	level endon ( "game_ended" );

	self waittill ( "disconnect" );
	if ( isDefined( self.carryObject ) )
		self.carryObject thread setDropped();
}


/*
=============
createCarryObject

Creates and returns a carry object
=============
*/
createCarryObject( ownerTeam, trigger, visuals, offset )
{
	carryObject = spawnStruct();
	carryObject.type = "carryObject";
	carryObject.curOrigin = trigger.origin;
	carryObject.ownerTeam = ownerTeam;
	carryObject.entNum = trigger getEntityNumber();
	
	if ( isSubStr( trigger.classname, "use" ) )
		carryObject.triggerType = "use";
	else
		carryObject.triggerType = "proximity";
		
	// associated trigger
	trigger.baseOrigin = trigger.origin;
	carryObject.trigger = trigger;
	
	carryObject.useWeapon = undefined;
	
	if ( !isDefined( offset ) )
		offset = (0,0,0);

	carryObject.offset3d = offset;
	
	// associated visual objects
	for ( index = 0; index < visuals.size; index++ )
	{
		visuals[index].baseOrigin = visuals[index].origin;
		visuals[index].baseAngles = visuals[index].angles;
	}
	carryObject.visuals = visuals;
	
	// compass objectives
	carryObject.compassIcons = [];
	carryObject.objIDAllies = getNextObjID();
	carryObject.objIDAxis = getNextObjID();
	carryObject.objIDPingFriendly = false;
	carryObject.objIDPingEnemy = false;
	level.objIDStart += 2;
	
	objective_add( carryObject.objIDAllies, "invisible", carryObject.curOrigin );
	objective_add( carryObject.objIDAxis, "invisible", carryObject.curOrigin );
	objective_team( carryObject.objIDAllies, "allies" );
	objective_team( carryObject.objIDAxis, "axis" );
	
	carryObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + carryObject.entNum, carryObject.curOrigin + offset, "allies", undefined );
	carryObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + carryObject.entNum, carryObject.curOrigin + offset, "axis", undefined );
	
	carryObject.objPoints["allies"].alpha = 0;
	carryObject.objPoints["axis"].alpha = 0;
	
	// carrying player
	carryObject.carrier = undefined;
	
	// misc
	carryObject.isResetting = false;	
	carryObject.interactTeam = "none"; // "none", "any", "friendly", "enemy";
	carryObject.allowWeapons = false;
	carryObject.visibleCarrierModel = undefined;
	
	// 3d world icons
	carryObject.worldIcons = [];
	carryObject.carrierVisible = false; // carryObject only
	carryObject.visibleTeam = "none"; // "none", "any", "friendly", "enemy";
	carryObject.worldIsWaypoint = [];
	
	carryObject.carryIcon = undefined;

	// calbacks
	carryObject.onDrop = undefined;
	carryObject.onPickup = undefined;
	carryObject.onReset = undefined;
	
	if ( carryObject.triggerType == "use" )
		carryObject thread carryObjectUseThink();
	else
		carryObject thread carryObjectProxThink();
		
	carryObject thread updateCarryObjectOrigin();

	return carryObject;
}


/*
=============
carryObjectUseThink

Think function for "use" type carry objects
=============
*/
carryObjectUseThink()
{
	level endon ( "game_ended" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( self.isResetting )
			continue;
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !self canInteractWith( player.pers["team"] ) )
			continue;
		
		if ( !player.canPickupObject )
			continue;

		if ( player.throwingGrenade )
			continue;
			
		if ( isDefined( self.carrier ) )
			continue;
	
		if ( player isInVehicle() )
			continue;

		if( !player isTouching( self.trigger ) )
			continue;
				
		self setPickedUp( player );
	}
}


/*
=============
carryObjectProxThink

Think function for "proximity" type carry objects
=============
*/
carryObjectProxThink()
{
	level endon ( "game_ended" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( self.isResetting )
			continue;
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !self canInteractWith( player.pers["team"] ) )
			continue;
		
		if ( !player.canPickupObject )
			continue;
			
		if ( player.throwingGrenade )
			continue;
			
		if ( isDefined( self.carrier ) )
			continue;
			
		if ( player isInVehicle() )
			continue;

		//Fix for player being able to respawn with the flag. This occured due to 
		//trigger collisions being stored and used a frame later than the collision occured.
		if( !player isTouching( self.trigger ) )
			continue;
				
		self setPickedUp( player );
	}
}


/*
=============
pickupObjectDelay

Temporarily disallows picking up of "proximity" type objects
=============
*/
pickupObjectDelay( origin )
{
	level endon ( "game_ended" );

	self endon("death");
	self endon("disconnect");
	
	self.canPickupObject = false;
	
	for( ;; )
	{
		if ( distanceSquared( self.origin, origin ) > 64*64 )
			break;

		wait 0.2;
	}
	
	self.canPickupObject = true;
}


/*
=============
setPickedUp

Sets this object as picked up by passed player
=============
*/
setPickedUp( player )
{
	if ( isDefined( player.carryObject ) )
	{
		if ( isDefined( self.onPickupFailed ) )
			self [[self.onPickupFailed]]( player );
			
		return;
	}
		
	player giveObject( self );
	
	self setCarrier( player );

	for ( index = 0; index < self.visuals.size; index++ )
		self.visuals[index] hide();
			
	self.trigger.origin += (0,0,10000);

	self notify ( "pickup_object" );
	if ( isDefined( self.onPickup ) )
		self [[self.onPickup]]( player );
	
	self updateCompassIcons();
	self updateWorldIcons();
}


updateCarryObjectOrigin()
{
	level endon ( "game_ended" );
	
	objPingDelay = 5.0;
	for ( ;; )
	{
		if ( isDefined( self.carrier ) )
		{
			self.curOrigin = self.carrier.origin + (0,0,75);
			self.objPoints["allies"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );
			self.objPoints["axis"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );

			if ( (self.visibleTeam == "friendly" || self.visibleTeam == "any") && self isFriendlyTeam( "allies" ) && self.objIDPingFriendly )
			{
				if ( self.objPoints["allies"].isShown )
				{
					self.objPoints["allies"].alpha = self.objPoints["allies"].baseAlpha;
					self.objPoints["allies"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["allies"].alpha = 0;
				}
				objective_position( self.objIDAllies, self.curOrigin );
			}
			else if ( (self.visibleTeam == "friendly" || self.visibleTeam == "any") && self isFriendlyTeam( "axis" ) && self.objIDPingFriendly )
			{
				if ( self.objPoints["axis"].isShown )
				{
					self.objPoints["axis"].alpha = self.objPoints["axis"].baseAlpha;
					self.objPoints["axis"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["axis"].alpha = 0;
				}
				objective_position( self.objIDAxis, self.curOrigin );
			}

			if ( (self.visibleTeam == "enemy" || self.visibleTeam == "any") && !self isFriendlyTeam( "allies" ) && self.objIDPingEnemy )
			{
				if ( self.objPoints["allies"].isShown )
				{
					self.objPoints["allies"].alpha = self.objPoints["allies"].baseAlpha;
					self.objPoints["allies"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["allies"].alpha = 0;
				}
				objective_position( self.objIDAllies, self.curOrigin );
			}
			else if ( (self.visibleTeam == "enemy" || self.visibleTeam == "any") && !self isFriendlyTeam( "axis" ) && self.objIDPingEnemy )
			{
				if ( self.objPoints["axis"].isShown )
				{
					self.objPoints["axis"].alpha = self.objPoints["axis"].baseAlpha;
					self.objPoints["axis"] fadeOverTime( objPingDelay + 1.0 );
					self.objPoints["axis"].alpha = 0;
				}
				objective_position( self.objIDAxis, self.curOrigin );
			}

			self wait_endon( objPingDelay, "dropped", "reset" );
		}
		else
		{
			self.objPoints["allies"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );
			self.objPoints["axis"] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );

			wait ( 0.05 );
		}
	}
}


/*
=============
giveObject

Set player as holding this object
Should only be called from setPickedUp
=============
*/
giveObject( object )
{
	assert( !isDefined( self.carryObject ) );
	
	self.carryObject = object;
	self thread trackCarrier();
		
	if ( !object.allowWeapons )
	{
		self _disableWeapon();
		self thread manualDropThink();
	}

	self.disallowVehicleUsage = true;
	
	if ( isdefined( object.visibleCarrierModel ) )
	{
		self maps\mp\gametypes\_weapons::forceStowedWeaponUpdate();
	}

	if ( isDefined( object.carryIcon ) )
	{
		if ( level.splitscreen )
		{
			self.carryIcon = createIcon( object.carryIcon, 35, 35 );
			self.carryIcon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -10, -50 );
		}
		else
		{
			self.carryIcon = createIcon( object.carryIcon, 50, 50 );
			
			if ( !object.allowWeapons )
				self.carryIcon setPoint( "CENTER", "CENTER", 0, 60 );
			else
				self.carryIcon setPoint( "CENTER", "CENTER", 220, 140 );
		}
	}
}


/*
=============
returnHome

Resets a carryObject to it's default home position
=============
*/
returnHome()
{
	self.isResetting = true;

	self notify ( "reset" );
	for ( index = 0; index < self.visuals.size; index++ )
	{
		self.visuals[index].origin = self.visuals[index].baseOrigin;
		self.visuals[index].angles = self.visuals[index].baseAngles;
		self.visuals[index] show();
	}
	self.trigger.origin = self.trigger.baseOrigin;
	
	self.curOrigin = self.trigger.origin;
	
	if ( isDefined( self.onReset ) )
		self [[self.onReset]]();

	self clearCarrier();
	
	updateWorldIcons();
	updateCompassIcons();
	
	self.isResetting = false;
}


/*
=============
isObjectAwayFromHome
=============
*/
isObjectAwayFromHome()
{
	if ( isdefined( self.carrier ) )
		return true;
		
	if ( distancesquared(self.trigger.origin,self.trigger.baseOrigin) > 4 )
		return true;
	
	return false;
}


/*
=============
setPosition

set a carryObject to a new position
=============
*/
setPosition( origin, angles )
{
	self.isResetting = true;

	for ( index = 0; index < self.visuals.size; index++ )
	{
		self.visuals[index].origin = self.origin;
		self.visuals[index].angles = self.angles;
		self.visuals[index] show();
	}
	self.trigger.origin = origin;
	
	self.curOrigin = self.trigger.origin;
	
	self clearCarrier();
	
	updateWorldIcons();
	updateCompassIcons();
	
	self.isResetting = false;
}

onPlayerLastStand()
{
	if ( isDefined( self.carryObject ) )
		self.carryObject thread setDropped();
}

/*
=============
setDropped

Sets this carry object as dropped and calculates dropped position
=============
*/
setDropped()
{
	self.isResetting = true;
	
	self notify ( "dropped" );

//	trace = bulletTrace( self.safeOrigin + (0,0,20), self.safeOrigin - (0,0,20), false, undefined );
	if ( isDefined( self.carrier ) )
	{
		trace = playerPhysicsTrace( self.carrier.origin + (0,0,20), self.carrier.origin - (0,0,2000), false, self.carrier.body );
		angleTrace = bulletTrace( self.carrier.origin + (0,0,20), self.carrier.origin - (0,0,2000), false, self.carrier.body );
	}
	else
	{
		trace = playerPhysicsTrace( self.safeOrigin + (0,0,20), self.safeOrigin - (0,0,20), false, undefined );
		angleTrace = bulletTrace( self.safeOrigin + (0,0,20), self.safeOrigin - (0,0,20), false, undefined );
	}
	
	droppingPlayer = self.carrier;
	
	if ( isDefined( trace ) )
	{
		tempAngle = randomfloat( 360 );
		
		dropOrigin = trace;		
		if ( angleTrace["fraction"] < 1 && distance( angleTrace["position"], trace ) < 10.0 )
		{
			forward = (cos( tempAngle ), sin( tempAngle ), 0);
			forward = vectornormalize( forward - vector_scale( angleTrace["normal"], vectordot( forward, angleTrace["normal"] ) ) );
			dropAngles = vectortoangles( forward );
		}
		else
		{
			dropAngles = (0,tempAngle,0);
		}
		
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index].origin = dropOrigin;
			self.visuals[index].angles = dropAngles;
			self.visuals[index] show();
		}
		self.trigger.origin = dropOrigin;
		
		self.curOrigin = self.trigger.origin;

		self thread pickupTimeout();
	}
	else
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index].origin = self.visuals[index].baseOrigin;
			self.visuals[index].angles = self.visuals[index].baseAngles;
			self.visuals[index] show();
		}
		self.trigger.origin = self.trigger.baseOrigin;
		
		self.curOrigin = self.trigger.baseOrigin;
	}	
	
	if ( isDefined( self.onDrop ) )
		self [[self.onDrop]]( droppingPlayer );
	
	self clearCarrier();
	
	self updateCompassIcons();
	self updateWorldIcons();
	
	self.isResetting = false;
}


setCarrier( carrier )
{
	self.carrier = carrier;

	self thread updateVisibilityAccordingToRadar();
}


clearCarrier()
{
	if ( !isdefined( self.carrier ) )
		return;
	
	self.carrier takeObject( self );
	
	self.carrier = undefined;
	
	self notify("carrier_cleared");
}


pickupTimeout()
{
	self endon ( "pickup_object" );
	self endon ( "stop_pickup_timeout" );
	
	wait ( 0.05 );
	
	mineTriggers = getEntArray( "minefield", "targetname" );
	hurtTriggers = getEntArray( "trigger_hurt", "classname" );

	for ( index = 0; index < mineTriggers.size; index++ )
	{
		if ( !self.visuals[0] isTouching( mineTriggers[index] ) )
			continue;

		self returnHome();
		return;
	}

	for ( index = 0; index < hurtTriggers.size; index++ )
	{
		if ( !self.visuals[0] isTouching( hurtTriggers[index] ) )
			continue;

		self returnHome();	
		return;
	}

	if ( isDefined( self.autoResetTime ) )
	{
		wait ( self.autoResetTime );

		if ( !isDefined( self.carrier ) )
			self returnHome();	
	}
}

/*
=============
takeObject

Set player as dropping this object
=============
*/
takeObject( object )
{
	if ( isDefined( self.carryIcon ) )
		self.carryIcon destroyElem();

	if ( !isAlive( self ) )
		return;

	self.carryObject = undefined;
	self notify ( "drop_object" );
	
	self.disallowVehicleUsage = false;

	if ( object.triggerType == "proximity" )
		self thread pickupObjectDelay( object.trigger.origin );

	if ( isdefined( object.visibleCarrierModel ) )
	{
		self maps\mp\gametypes\_weapons::forceStowedWeaponUpdate();
	}	
	
	if ( !object.allowWeapons )
	{
		self _enableWeapon();
	}
}


/*
=============
trackCarrier

Calculates and updates a safe drop origin for a carry object based on the current carriers position
=============
*/
trackCarrier()
{
	level endon ( "game_ended" );
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	while ( isDefined( self.carryObject ) && isAlive( self ) )
	{
		if ( self isOnGround() )
		{
			trace = bulletTrace( self.origin + (0,0,20), self.origin - (0,0,20), false, undefined );
			if ( trace["fraction"] < 1 ) // if there is ground at the player's origin (not necessarily true just because of isOnGround)
				self.carryObject.safeOrigin = trace["position"];
		}
		wait ( 0.05 );
	}
}


/*
=============
manualDropThink

Allows the player to manually drop this object by pressing the fire button
Does not allow drop if the use button is pressed
=============
*/
manualDropThink()
{
	level endon ( "game_ended" );

	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	for( ;; )
	{
		while ( self attackButtonPressed() || self fragButtonPressed() || self secondaryOffhandButtonPressed() || self meleeButtonPressed() )
			wait .05;
	
		while ( !self attackButtonPressed() && !self fragButtonPressed() && !self secondaryOffhandButtonPressed() && !self meleeButtonPressed() )
			wait .05;
	
		if ( isDefined( self.carryObject ) && !self useButtonPressed() )
			self.carryObject thread setDropped();
	}
}


/*
=============
createUseObject

Creates and returns a use object
=============
*/
createUseObject( ownerTeam, trigger, visuals, offset )
{
	useObject = spawnStruct();
	useObject.type = "useObject";
	useObject.curOrigin = trigger.origin;
	useObject.ownerTeam = ownerTeam;
	useObject.entNum = trigger getEntityNumber();
	useObject.keyObject = undefined;
	
	if ( isSubStr( trigger.classname, "use" ) )
		useObject.triggerType = "use";
	else
		useObject.triggerType = "proximity";
		
	// associated trigger
	useObject.trigger = trigger;
	
	// associated visual object
	for ( index = 0; index < visuals.size; index++ )
	{
		visuals[index].baseOrigin = visuals[index].origin;
		visuals[index].baseAngles = visuals[index].angles;
	}
	useObject.visuals = visuals;
	
	if ( !isDefined( offset ) )
		offset = (0,0,0);

	useObject.offset3d = offset;
	
	// compass objectives
	useObject.compassIcons = [];
	useObject.objIDAllies = getNextObjID();
	useObject.objIDAxis = getNextObjID();

	objective_add( useObject.objIDAllies, "invisible", useObject.curOrigin );
	objective_add( useObject.objIDAxis, "invisible", useObject.curOrigin );
	objective_team( useObject.objIDAllies, "allies" );
	objective_team( useObject.objIDAxis, "axis" );

	useObject.objPoints["allies"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + useObject.entNum, useObject.curOrigin + offset, "allies", undefined );
	useObject.objPoints["axis"] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_axis_" + useObject.entNum, useObject.curOrigin + offset, "axis", undefined );
	
	useObject.objPoints["allies"].alpha = 0;
	useObject.objPoints["axis"].alpha = 0;
	
	// misc
	useObject.interactTeam = "none"; // "none", "any", "friendly", "enemy";
	
	// 3d world icons
	useObject.worldIcons = [];
	useObject.visibleTeam = "none"; // "none", "any", "friendly", "enemy";
	useObject.worldIsWaypoint = [];

	// calbacks
	useObject.onUse = undefined;
	useObject.onCantUse = undefined;

	useObject.useText = "default";
	useObject.useTime = 10000;
	useObject.curProgress = 0;

	// if this is true, decay the flag back down instead of just resetting it to 0
	useObject.decayProgress = false;

	if ( useObject.triggerType == "proximity" )
	{
		useObject.numTouching["neutral"] = 0;
		useObject.numTouching["axis"] = 0;
		useObject.numTouching["allies"] = 0;
		useObject.numTouching["none"] = 0;
		useObject.touchList["neutral"] = [];
		useObject.touchList["axis"] = [];
		useObject.touchList["allies"] = [];
		useObject.touchList["none"] = [];
		useObject.useRate = 0;
		useObject.claimTeam = "none";
		useObject.claimPlayer = undefined;
		useObject.lastClaimTeam = "none";
		useObject.lastClaimTime = 0;
		
		useObject thread useObjectProxThink();
	}
	else
	{
		useObject.useRate = 1;
		useObject thread useObjectUseThink();
	}
	
	return useObject;
}


/*
=============
setKeyObject

Sets this use object to require carry object
=============
*/
setKeyObject( object )
{
	self.keyObject = object;
}


/*
=============
useObjectUseThink

Think function for "use" type carry objects
=============
*/
useObjectUseThink()
{
	level endon ( "game_ended" );
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !self canInteractWith( player.pers["team"] ) )
			continue;
		
		if ( !player isOnGround() )
			continue;
		
		if ( player isInVehicle() )
			continue;
		
		if ( isDefined( self.keyObject ) && (!isDefined( player.carryObject ) || player.carryObject != self.keyObject ) )
		{
			if ( isDefined( self.onCantUse ) )
				self [[self.onCantUse]]( player );
			continue;
		}

		result = true;
		if ( self.useTime > 0 )
		{
			if ( isDefined( self.onBeginUse ) )
				self [[self.onBeginUse]]( player );

			team = player.pers["team"];

			result = self useHoldThink( player );
			
			if ( isDefined( self.onEndUse ) )
				self [[self.onEndUse]]( team, player, result );	
		}

		if ( !result )
			continue;
		
		if ( isDefined( self.onUse ) )
			self [[self.onUse]]( player );
	}
}


getEarliestClaimPlayer()
{
	assert( self.claimTeam != "none" );
	team = self.claimTeam;
	
	earliestPlayer = self.claimPlayer;
	
	if ( self.touchList[team].size > 0 )
	{
		// find earliest touching player
		earliestTime = undefined;
		players = getArrayKeys( self.touchList[team] );
		for ( index = 0; index < players.size; index++ )
		{
			touchdata = self.touchList[team][players[index]];
			if ( !isdefined( earliestTime ) || touchdata.starttime < earliestTime )
			{
				earliestPlayer = touchdata.player;
				earliestTime = touchdata.starttime;
			}
		}
	}

	return earliestPlayer;
}	


/*
=============
useObjectProxThink

Think function for "proximity" type carry objects
=============
*/
useObjectProxThink()
{
	level endon ( "game_ended" );
	
	self thread proxTriggerThink();
	
	while ( true )
	{
		if ( self.useTime && self.curProgress >= self.useTime )
		{
			self.curProgress = 0;
			
			creditPlayer = getEarliestClaimPlayer();

			if ( isDefined( self.onEndUse ) )
				self [[self.onEndUse]]( self getClaimTeam(), creditPlayer, isDefined( creditPlayer ) );
			
			if ( isDefined( creditPlayer ) && isDefined( self.onUse ) )
				self [[self.onUse]]( creditPlayer );
			
			self setClaimTeam( "none" );
			self.claimPlayer = undefined;
		}
		
		if ( self.claimTeam != "none" )
		{
			if ( self useObjectLockedForTeam( self.claimTeam ) )
			{
				if ( isDefined( self.onEndUse ) )
					self [[self.onEndUse]]( self getClaimTeam(), self.claimPlayer, false );
				
				self setClaimTeam( "none" );
				self.claimPlayer = undefined;
				self.curProgress = 0;
			}
			else
			{
				if ( self.useTime )
				{
					if ( self.decayProgress && !self.numTouching[self.claimTeam] )
					{
						if ( isDefined( self.claimPlayer ) )
						{
							if ( isDefined( self.onEndUse ) )
								self [[self.onEndUse]]( self getClaimTeam(), self.claimPlayer, false );
							
							self.claimPlayer = undefined;
						}

						self.curProgress -= (50 * self.useRate);
						if ( self.curProgress <= 0 )
							self.curProgress = 0;

						if ( isDefined( self.onUseUpdate ) )
							self [[self.onUseUpdate]]( self getClaimTeam(), self.curProgress / self.useTime, (50*self.useRate) / self.useTime );

						if ( self.curProgress == 0 )
							self setClaimTeam( "none" );
					}
					else if ( !self.numTouching[self.claimTeam] )
					{
						if ( isDefined( self.onEndUse ) )
							self [[self.onEndUse]]( self getClaimTeam(), self.claimPlayer, false );
						
						self setClaimTeam( "none" );
						self.claimPlayer = undefined;
					}
					else
					{
						self.curProgress += (50 * self.useRate);
						if ( isDefined( self.onUseUpdate ) )
							self [[self.onUseUpdate]]( self getClaimTeam(), self.curProgress / self.useTime, (50*self.useRate) / self.useTime );
					}
				}
				else
				{
					if ( isDefined( self.onUse ) )
						self [[self.onUse]]( self.claimPlayer );
					
					self setClaimTeam( "none" );
					self.claimPlayer = undefined;	
				}
			}

		}

		wait ( 0.05 );
	}
}


/*
=============
useObjectLockedForTeam

Verify that a team is not locked from using an object
=============
*/
useObjectLockedForTeam( team )
{
	if ( isDefined( self.teamLock ) && ( team == "axis" || team == "allies" ) )
	{
		return self.teamLock[team];
	}

	return false;
}


/*
=============
proxTriggerThink ("proximity" only)

Handles setting the current claiming team and player, as well as starting threads to track players touching the trigger
=============
*/
proxTriggerThink()
{
	level endon ( "game_ended" );
	
	entityNumber = self.entNum;
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		// TODO: Notify the player if they are attempting to capture a locked flag
		if ( !isAlive( player ) || self useObjectLockedForTeam( player.pers["team"] ) )
			continue;
		
		if ( player isInVehicle() )
			continue;
		
		if ( self canInteractWith( player.pers["team"] ) && self.claimTeam == "none" )
		{
			if ( !isDefined( self.keyObject ) || (isDefined( player.carryObject ) && player.carryObject == self.keyObject ) )
			{
				setClaimTeam( player.pers["team"] );
				self.claimPlayer = player;
				
				if ( self.useTime && isDefined( self.onBeginUse ) )
					self [[self.onBeginUse]]( self.claimPlayer );
			}
			else
			{
				if ( isDefined( self.onCantUse ) )
					self [[self.onCantUse]]( player );
			}
		}
			
		if ( self.useTime && isAlive( player ) && !isDefined( player.touchTriggers[entityNumber] ) )
			player thread triggerTouchThink( self );
	}
}


/*
=============
setClaimTeam ("proximity" only)

Sets this object as claimed by specified team including grace period to prevent 
object reset when claiming team leave trigger for short periods of time
=============
*/
setClaimTeam( newTeam )
{
	assert( newTeam != self.claimTeam );
	
	if ( self.claimTeam == "none" && getTime() - self.lastClaimTime > 1000 )
		self.curProgress = 0;
	else if ( newTeam != "none" && newTeam != self.lastClaimTeam )
		self.curProgress = 0;

	self.lastClaimTeam = self.claimTeam;
	self.lastClaimTime = getTime();
	self.claimTeam = newTeam;
	
	self updateUseRate();
}


getClaimTeam()
{
	return self.claimTeam;
}

/*
=============
triggerTouchThink ("proximity" only)

Updates use object while player is touching the trigger and updates the players visual use bar
=============
*/
triggerTouchThink( object )
{
	team = self.pers["team"];

	object.numTouching[team]++;
	object updateUseRate();

	touchName = "player" + self.clientid;
	struct = spawnstruct();
	struct.player = self;
	struct.starttime = gettime();
	object.touchList[team][touchName] = struct;

	self.touchTriggers[object.entNum] = object.trigger;

	if ( isDefined( object.onTouchUse ) )
		object [[object.onTouchUse]]( self );

	while ( isAlive( self ) && self isTouching( object.trigger ) && ( self useObjectLockedForTeam( team ) == false ) )
	{
		self updateProxBar( object, false );
		wait ( 0.05 );
	}

	// disconnected player will skip this code
	if ( isDefined( self ) )
	{
		self updateProxBar( object, true );
		self.touchTriggers[object.entNum] = undefined;
	}
	
	if ( level.gameEnded )
		return;
	
	object.touchList[team][touchName] = undefined;

	object.numTouching[team]--;

	if ( isDefined( self ) )
	{
		if ( isDefined( object.onEndTouchUse ) )
			object [[object.onEndTouchUse]]( self );
	}

	object updateUseRate();
}


/*
=============
updateProxBar ("proximity" only)

Updates drawing of the players use bar when using a use object
=============
*/
updateProxBar( object, forceRemove )
{
	if ( !forceRemove && object.decayProgress )
	{
		if ( !object canInteractWith( self.pers["team"] ) )
		{
			if ( isDefined( self.proxBar ) )
				self.proxBar hideElem();

			if ( isDefined( self.proxBarText ) )
				self.proxBarText hideElem();
			return;
		}
		else
		{
			if ( !isDefined( self.proxBar ) )
			{
				self.proxBar = createPrimaryProgressBar();
				self.proxBar.lastUseRate = -1;
			}

			if ( self.pers["team"] == object.claimTeam )
			{
				if ( self.proxBar.bar.color != ( 1, 1, 1 ) )
				{
					self.proxBar.bar.color = ( 1, 1, 1 );
					self.proxBar.lastUseRate = -1;
				}
			}
			else
			{
				if ( self.proxBar.bar.color != ( 1, 0, 0 ) )
				{
					self.proxBar.bar.color = ( 1, 0, 0 );
					self.proxBar.lastUseRate = -1;
				}
			}
		}
	}
	else if ( forceRemove || !object canInteractWith( self.pers["team"] ) || self.pers["team"] != object.claimTeam )
	{
		if ( isDefined( self.proxBar ) )
			self.proxBar hideElem();

		if ( isDefined( self.proxBarText ) )
			self.proxBarText hideElem();
		return;
	}
	
	if ( !isDefined( self.proxBar ) )
	{
		self.proxBar = createPrimaryProgressBar();
		self.proxBar.lastUseRate = -1;
	}
	
	if ( self.proxBar.hidden )
	{
		self.proxBar showElem();
		self.proxBar.lastUseRate = -1;
	}

	if ( !isDefined( self.proxBarText ) )
	{
		self.proxBarText = createPrimaryProgressBarText();
		self.proxBarText setText( object.useText );
	}
	
	if ( self.proxBarText.hidden )
	{
		self.proxBarText showElem();
		self.proxBarText setText( object.useText );
	}
	
	if ( self.proxBar.lastUseRate != object.useRate )
	{
		if( object.curProgress > object.useTime)
			object.curProgress = object.useTime;
				
		if ( object.decayProgress && self.pers["team"] != object.claimTeam )
		{
			if ( object.curProgress > 0 )
			{
				self.proxBar updateBar( object.curProgress / object.useTime , (1000 / object.useTime) * ( object.useRate * -1 ) );
			}
		}
		else
		{
			self.proxBar updateBar( object.curProgress / object.useTime , (1000 / object.useTime) * object.useRate );
		}
		self.proxBar.lastUseRate = object.useRate;
	}
}


/*
=============
updateUseRate ("proximity" only)

Handles the rate a which a use objects progress bar is filled based on the number of players touching the trigger
Stops updating if an enemy is touching the trigger
=============
*/
updateUseRate()
{
	numClaimants = self.numTouching[self.claimTeam];
	numOther = 0;
	
	if ( self.claimTeam != "axis" )
		numOther += self.numTouching["axis"];
	if ( self.claimTeam != "allies" )
		numOther += self.numTouching["allies"];

	self.useRate = 0;

	if ( self.decayProgress )
	{
		if ( numClaimants && !numOther )
			self.useRate = numClaimants;
		else if ( !numClaimants && numOther )
			self.useRate = numOther;
		else if ( !numClaimants && !numOther )
			self.useRate = 1;
	}
	else
	{
		if ( numClaimants && !numOther )
			self.useRate = numClaimants;
	}

	if ( isDefined( self.onUpdateUseRate ) )
		self [[self.onUpdateUseRate]]( );
}


attachUseModel()
{
	self endon("death");
	self endon("disconnect");
	self endon("done_using");
	
	wait 1.3;
	
	self attach( "weapon_explosives", "tag_inhand", true );
	self.attachedUseModel = "weapon_explosives";
}

/*
=============
useHoldThink

Claims the use trigger for player and displays a use bar
Returns true if the player sucessfully fills the use bar
=============
*/
useHoldThink( player )
{
	player notify ( "use_hold" );
	player linkTo( self.trigger );
	player clientClaimTrigger( self.trigger );
	player.claimTrigger = self.trigger;

	useWeapon = self.useWeapon;
	lastWeapon = player getCurrentWeapon();
	
	if ( isDefined( useWeapon ) )
	{
		assert( isDefined( lastWeapon ) );
		if ( lastWeapon == useWeapon )
		{
			assert( isdefined( player.lastNonUseWeapon ) );
			lastWeapon = player.lastNonUseWeapon;
		}
		assert( lastWeapon != useWeapon );
		
		player.lastNonUseWeapon = lastWeapon;
		
		player giveWeapon( useWeapon );
		player setWeaponAmmoStock( useWeapon, 0 );
		player setWeaponAmmoClip( useWeapon, 0 );
		player switchToWeapon( useWeapon );
		
		player thread attachUseModel();
	}
	else
	{
		player _disableWeapon();
	}
	
	self.curProgress = 0;
	self.inUse = true;
	self.useRate = 0;
	
	player thread personalUseBar( self );
	
	result = useHoldThinkLoop( player, lastWeapon );
	
	if ( isDefined( player ) )
	{
		if ( isDefined( player.attachedUseModel ) )
		{
			player detach( player.attachedUseModel, "tag_inhand" );
			player.attachedUseModel = undefined;
		}
		player notify( "done_using" );
	}
	
	// result may be undefined if useholdthinkloop hits an endon

	if ( isDefined( useWeapon ) && isDefined( player ) )
		player thread takeUseWeapon( useWeapon );
	
	if ( isdefined( result ) && result )
		return true;
	
	if ( isDefined( player ) )
	{
		player.claimTrigger = undefined;
		if ( isDefined( useWeapon ) )
		{
			if ( lastWeapon != "none" )
				player switchToWeapon( lastWeapon );
			else
				player takeWeapon( useWeapon );
	
//			while ( player getCurrentWeapon() == useWeapon && isAlive( player ) )
//				wait ( 0.05 );
		}
		else
		{
			player _enableWeapon();
		}

		player unlink();
		
		if ( !isAlive( player ) )
			player.killedInUse = true;
	}

	self.inUse = false;
	self.trigger releaseClaimedTrigger();
	return false;
}


takeUseWeapon( useWeapon )
{
	self endon( "use_hold" );
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while ( self getCurrentWeapon() == useWeapon && !self.throwingGrenade )
		wait ( 0.05 );
		
	self takeWeapon( useWeapon );
}

useHoldThinkLoop( player, lastWeapon )
{
	level endon ( "game_ended" );
	self endon("disabled");
	
	useWeapon = self.useWeapon;
	waitForWeapon = true;
	timedOut = 0;
	
	maxWaitTime = 1.5; // must be greater than the putaway timer for all weapons
	
	while( isAlive( player ) && player isTouching( self.trigger ) && player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() && self.curProgress < self.useTime && (self.useRate || waitForWeapon) && !(waitForWeapon && timedOut > maxWaitTime) )
	{
		timedOut += 0.05;

		if ( !isDefined( useWeapon ) || player getCurrentWeapon() == useWeapon )
		{
			self.curProgress += (50 * self.useRate);
			self.useRate = 1;
			waitForWeapon = false;
		}
		else
		{
			self.useRate = 0;
		}

		if ( self.curProgress >= self.useTime )
		{
			self.inUse = false;
			player clientReleaseTrigger( self.trigger );
			player.claimTrigger = undefined;
			
			if ( isDefined( useWeapon ) )
			{
				player setWeaponAmmoStock( useWeapon, 1 );
				player setWeaponAmmoClip( useWeapon, 1 );
				if ( lastWeapon != "none" )
					player switchToWeapon( lastWeapon );
				else
					player takeWeapon( useWeapon );
				
//				while ( player getCurrentWeapon() == useWeapon && isAlive( player ) )
//					wait ( 0.05 );
			}
			else
			{
				player _enableWeapon();
			}
			player unlink();
			
			wait .05;
			
			return isAlive( player );
		}
		
		wait 0.05;
	}
	
	return false;
}

/*
=============
personalUseBar

Displays and updates a players use bar
=============
*/
personalUseBar( object )
{
	self endon("disconnect");
	
	self.useBar = createPrimaryProgressBar();
	self.useBarText = createPrimaryProgressBarText();
	self.useBarText setText( object.useText );

	lastRate = -1;
	while ( isAlive( self ) && object.inUse && !level.gameEnded )
	{
		if ( lastRate != object.useRate )
		{
			if( object.curProgress > object.useTime)
				object.curProgress = object.useTime;

			if ( object.decayProgress && self.pers["team"] != object.claimTeam )
			{
				if ( object.curProgress > 0 )
				{
					self.proxBar updateBar( object.curProgress / object.useTime , (1000 / object.useTime) * ( object.useRate * -1 ) );
				}
			}
			else
			{
				self.useBar updateBar( object.curProgress / object.useTime, (1000 / object.useTime) * object.useRate );
			}

			if ( !object.useRate )
			{
				self.useBar hideElem();
				self.useBarText hideElem();
			}
			else
			{
				self.useBar showElem();
				self.useBarText showElem();
			}
		}	
		lastRate = object.useRate;
		wait ( 0.05 );
	}
	
	self.useBar destroyElem();
	self.useBarText destroyElem();
}


/*
=============
updateTrigger

Displays and updates a players use bar
=============
*/
updateTrigger()
{
	if ( self.triggerType != "use" )
		return;
	
	if ( self.interactTeam == "none" )
	{
		self.trigger.origin -= (0,0,50000);
	}	
	else if ( self.interactTeam == "any" )
	{
		self.trigger.origin = self.curOrigin;
		self.trigger setTeamForTrigger( "none" );
	}
	else if ( self.interactTeam == "friendly" )
	{
		self.trigger.origin = self.curOrigin;
		if ( self.ownerTeam == "allies" )
			self.trigger setTeamForTrigger( "allies" );
		else if ( self.ownerTeam == "axis" )
			self.trigger setTeamForTrigger( "axis" );
		else
			self.trigger.origin -= (0,0,50000);
	}
	else if ( self.interactTeam == "enemy" )
	{
		self.trigger.origin = self.curOrigin;
		if ( self.ownerTeam == "allies" )
			self.trigger setTeamForTrigger( "axis" );
		else if ( self.ownerTeam == "axis" )
			self.trigger setTeamForTrigger( "allies" );
		else
			self.trigger setTeamForTrigger( "none" );
	}
}


updateWorldIcons()
{
	if ( self.visibleTeam == "any" )
	{
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		updateWorldIcon( "friendly", true );
		updateWorldIcon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", true );
	}
	else
	{
		updateWorldIcon( "friendly", false );
		updateWorldIcon( "enemy", false );
	}
}


updateWorldIcon( relativeTeam, showIcon )
{
	if ( !isDefined( self.worldIcons[relativeTeam] ) )
		showIcon = false;
	
	updateTeams = getUpdateTeams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		opName = "objpoint_" + updateTeams[index] + "_" + self.entNum;			
		objPoint = maps\mp\gametypes\_objpoints::getObjPointByName( opName );
		
		objPoint notify( "stop_flashing_thread" );
		objPoint thread maps\mp\gametypes\_objpoints::stopFlashing();
		
		if ( showIcon )
		{
			objPoint setShader( self.worldIcons[relativeTeam], level.objPointSize, level.objPointSize );
			objPoint fadeOverTime( 0.05 ); // overrides old fadeOverTime setting from flashing thread
			objPoint.alpha = objPoint.baseAlpha;
			objPoint.isShown = true;

			isWaypoint = true;
			if ( isdefined(self.worldIsWaypoint[relativeTeam]) )
				isWaypoint = self.worldIsWaypoint[relativeTeam];
				
			if ( isDefined( self.compassIcons[relativeTeam] ) )
				objPoint setWayPoint( isWaypoint, self.worldIcons[relativeTeam] );
			else
				objPoint setWayPoint( isWaypoint );
				
			if ( self.type == "carryObject" )
			{
				if ( isDefined( self.carrier ) && !shouldPingObject( relativeTeam ) )
					objPoint SetTargetEnt( self.carrier );
				else
					objPoint ClearTargetEnt();
			}
		}
		else
		{
			objPoint fadeOverTime( 0.05 );
			objPoint.alpha = 0;
			objPoint.isShown = false;
			objPoint ClearTargetEnt();
		}
	}
}


updateCompassIcons()
{
	if ( self.visibleTeam == "any" )
	{
		updateCompassIcon( "friendly", true );
		updateCompassIcon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		updateCompassIcon( "friendly", true );
		updateCompassIcon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		updateCompassIcon( "friendly", false );
		updateCompassIcon( "enemy", true );
	}
	else
	{
		updateCompassIcon( "friendly", false );
		updateCompassIcon( "enemy", false );
	}
}


updateCompassIcon( relativeTeam, showIcon )
{
	updateTeams = getUpdateTeams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		showIconThisTeam = showIcon;
		if ( !showIconThisTeam && shouldShowCompassDueToRadar( updateTeams[ index ] ) )
			showIconThisTeam = true;
		
		objId = self.objIDAllies;
		if ( updateTeams[ index ] == "axis" )
			objId = self.objIDAxis;
		
		if ( !isDefined( self.compassIcons[relativeTeam] ) || !showIconThisTeam )
		{
			objective_state( objId, "invisible" );
			continue;
		}
		
		objective_icon( objId, self.compassIcons[relativeTeam] );
		objective_state( objId, "active" );
		
		if ( self.type == "carryObject" )
		{
			if ( isAlive( self.carrier ) && !shouldPingObject( relativeTeam ) )
				objective_onentity( objId, self.carrier );
			else
				objective_position( objId, self.curOrigin );
		}
	}
}


shouldPingObject( relativeTeam )
{
	if ( relativeTeam == "friendly" && self.objIDPingFriendly )
		return true;
	else if ( relativeTeam == "enemy" && self.objIDPingEnemy )
		return true;
	
	return false;
}


getUpdateTeams( relativeTeam )
{
	updateTeams = [];
	if ( relativeTeam == "friendly" )
	{
		if ( self isFriendlyTeam( "allies" ) )
			updateTeams[0] = "allies";
		else if ( self isFriendlyTeam( "axis" ) )
			updateTeams[0] = "axis";
	}
	else if ( relativeTeam == "enemy" )
	{
		if ( !self isFriendlyTeam( "allies" ) )
			updateTeams[updateTeams.size] = "allies";

		if ( !self isFriendlyTeam( "axis" ) )
			updateTeams[updateTeams.size] = "axis";
	}
	
	return updateTeams;
}

shouldShowCompassDueToRadar( team )
{
	// the only case we return true in this function is when the enemy has UAV,
	// and an enemy visible on RADAR is holding the object.
	
	if ( !isdefined( self.carrier ) )
		return false;
	
	if ( self.carrier hasPerk( "specialty_gpsjammer" ) )
		return false;
	
	return maps\mp\gametypes\_hardpoints::teamHasRadar( team );
}

updateVisibilityAccordingToRadar()
{
	self endon("death");
	self endon("carrier_cleared");
	
	while(1)
	{
		level waittill("radar_status_change");
		self updateCompassIcons();
	}
}

setOwnerTeam( team )
{
	self.ownerTeam = team;
	self updateTrigger();	
	self updateCompassIcons();
	self updateWorldIcons();
}

getOwnerTeam()
{
	return self.ownerTeam;
}

setUseTime( time )
{
	self.useTime = int( time * 1000 );
}

setUseText( text )
{
	self.useText = text;
}

setUseHintText( text )
{
	self.trigger setHintString( text );
}

allowCarry( relativeTeam )
{
	self.interactTeam = relativeTeam;
}

allowUse( relativeTeam )
{
	self.interactTeam = relativeTeam;
	updateTrigger();
}

setVisibleTeam( relativeTeam )
{
	self.visibleTeam = relativeTeam;

	if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showobjicons" ) )
		self.visibleTeam = "none";

	updateCompassIcons();
	updateWorldIcons();
}

setModelVisibility( visibility )
{
	if ( visibility )
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] show();
			if ( self.visuals[index].classname == "script_brushmodel" || self.visuals[index].classname == "script_model" )
			{
				self.visuals[index] thread makeSolid();
			}
		}
	}
	else
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] hide();
			if ( self.visuals[index].classname == "script_brushmodel" || self.visuals[index].classname == "script_model" )
			{
				self.visuals[index] notify("changing_solidness");
				self.visuals[index] notsolid();
			}
		}
	}
}

makeSolid()
{
	self endon("death");
	self notify("changing_solidness");
	self endon("changing_solidness");
	
	while(1)
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( level.players[i] isTouching( self ) )
				break;
		}
		if ( i == level.players.size )
		{
			self solid();
			break;
		}
		wait .05;
	}
}

setCarrierVisible( relativeTeam )
{
	self.carrierVisible = relativeTeam;
}

setCanUse( relativeTeam )
{
	self.useTeam = relativeTeam;
}

set2DIcon( relativeTeam, shader )
{
	self.compassIcons[relativeTeam] = shader;
	updateCompassIcons();
}

set3DIcon( relativeTeam, shader )
{
	self.worldIcons[relativeTeam] = shader;
	updateWorldIcons();
}

set3DUseIcon( relativeTeam, shader )
{
	self.worldUseIcons[relativeTeam] = shader;	
}

set3DIsWaypoint( relativeTeam, waypoint )
{
	self.worldIsWaypoint[relativeTeam] = waypoint;	
}

setCarryIcon( shader )
{
	self.carryIcon = shader;
}

setVisibleCarrierModel( visibleModel )
{
		self.visibleCarrierModel = visibleModel;
}

getVisibleCarrierModel( )
{
	return self.visibleCarrierModel;
}

disableObject()
{
	self notify("disabled");
	
	if ( self.type == "carryObject" )
	{
		if ( isDefined( self.carrier ) )
			self.carrier takeObject( self );

		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] hide();
		}
	}
	
	self.trigger triggerOff();
	self setVisibleTeam( "none" );
}


enableObject()
{
	if ( self.type == "carryObject" )
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] show();
		}
	}
	
	self.trigger triggerOn();
	self setVisibleTeam( "any" );
}


getRelativeTeam( team )
{
	if ( team == self.ownerTeam )
		return "friendly";
	else if ( team == self.enemyTeam )
		return "enemy";
	else
		return "neutral";
}


isFriendlyTeam( team )
{
	if ( self.ownerTeam == "any" )
		return true;
	
	if ( self.ownerTeam == team )
		return true;

	return false;
}


canInteractWith( team )
{
	switch( self.interactTeam )
	{
		case "none":
			return false;

		case "any":
			return true;

		case "friendly":
			if ( team == self.ownerTeam )
				return true;
			else
				return false;

		case "enemy":
			if ( team != self.ownerTeam )
				return true;
			else
				return false;

		default:
			assertEx( 0, "invalid interactTeam" );
			return false;
	}
}


isTeam( team )
{
	if ( team == "neutral" )
		return true;
	if ( team == "allies" )
		return true;
	if ( team == "axis" )
		return true;
	if ( team == "any" )
		return true;
	if ( team == "none" )
		return true;
	
	return false;
}

isRelativeTeam( relativeTeam )
{
	if ( relativeTeam == "friendly" )
		return true;
	if ( relativeTeam == "enemy" )
		return true;
	if ( relativeTeam == "any" )
		return true;
	if ( relativeTeam == "none" )
		return true;
	
	return false;
}


_disableWeapon()
{
	self.disabledWeapon++;	
	self disableWeapons();
}

_enableWeapon()
{
	self.disabledWeapon--;
	
	if ( !self.disabledWeapon )
		self enableWeapons();
}

getEnemyTeam( team )
{
	if ( team == "neutral" )
		return "none";
	else if ( team == "allies" )
		return "axis";
	else
		return "allies";
}

getNextObjID()
{
	nextID = level.numGametypeReservedObjectives;
		
	level.numGametypeReservedObjectives++;
	return nextID;
}

getLabel()
{
	label = self.trigger.script_label;
	if ( !isDefined( label ) )
	{
		label = "";
		return label;
	}
	
	if ( label[0] != "_" )
		return ("_" + label);
	
	return label;
}
