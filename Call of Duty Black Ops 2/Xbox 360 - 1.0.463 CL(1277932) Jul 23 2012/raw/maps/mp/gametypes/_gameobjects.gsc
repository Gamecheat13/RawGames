#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#define CARRY_ICON_X 130
#define CARRY_ICON_Y -60

#define MAX_OBJECTIVE_IDS 32

main(allowed)
{
	level.vehiclesEnabled = GetGametypeSetting( "vehiclesEnabled" );
	level.vehiclesTimed = GetGametypeSetting( "vehiclesTimed" );
	level.objectivePingDelay = GetGametypeSetting( "objectivePingTime" );
	
	level.nonTeamBasedTeam = "allies";
	
	/#
	//###stefan $NOTE don't remove vehicles when running the vehicle test maps
	if ( level.script == "mp_vehicle_test" )
	{
		level.vehiclesEnabled = true;
	}
	#/
	
	if (level.vehiclesEnabled)
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
	if ( IsDefined(level.createFX_enabled) && level.createFX_enabled )
	{
		return true;
	}

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
	level.releasedObjectives = [];

	if ( !SessionModeIsZombiesGame() )
	{	
		precacheItem( "briefcase_bomb_mp" );
		precacheItem( "briefcase_bomb_defuse_mp" );
	}

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
createCarryObject( ownerTeam, trigger, visuals, offset, objectiveName )
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
	
	carryObject.newStyle = false;
	if ( IsDefined( objectiveName ) )
	{
		carryObject.newStyle = true;
	}
	else
	{
		objectiveName = &"";
	}
	
	// associated visual objects
	for ( index = 0; index < visuals.size; index++ )
	{
		visuals[index].baseOrigin = visuals[index].origin;
		visuals[index].baseAngles = visuals[index].angles;
	}
	carryObject.visuals = visuals;
	
	// compass objectives
	carryObject.compassIcons = [];
	carryObject.objID =[];
	// this block will completely go away when we have fully switched to the new style
	if ( !carryObject.newStyle )
	{
		foreach( team in level.teams )
		{
			carryObject.objID[team] = getNextObjID();
		}
	}
	carryObject.objIDPingFriendly = false;
	carryObject.objIDPingEnemy = false;
	level.objIDStart += 2;
	
	// this block will completely go away when we have fully switched to the new style
	if ( !carryObject.newStyle )
	{
		if ( level.teamBased )
		{
			foreach ( team in level.teams )
			{
				objective_add( carryObject.objID[team], "invisible", carryObject.curOrigin );
				objective_team( carryObject.objID[team], team );
				carryObject.objPoints[team] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_" + team + "_" + carryObject.entNum, carryObject.curOrigin + offset, team, undefined );
				carryObject.objPoints[team].alpha = 0;
			}
		}
		else
		{
			// TODO MTEAM - not sure why the we only use allies in dm
			objective_add( carryObject.objID[level.nonTeamBasedTeam], "invisible", carryObject.curOrigin );
			carryObject.objPoints[level.nonTeamBasedTeam] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_"+ level.nonTeamBasedTeam + "_" + carryObject.entNum, carryObject.curOrigin + offset, "all", undefined );
			carryObject.objPoints[level.nonTeamBasedTeam].alpha = 0;
		}
	}
	
	// new style objective
	{
		carryObject.objectiveID = getNextObjID();

		objective_add( carryObject.objectiveID, "invisible", carryObject.curOrigin, objectiveName );
	}
	
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
	carryObject thread updateCarryObjectObjectiveOrigin();

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
	self.trigger endon( "destroyed" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( self.isResetting )
			continue;
		
		if ( !isAlive( player ) )
			continue;
			
		if ( isdefined(player.laststand) && player.laststand )
			continue;
			
		if ( !self canInteractWith( player ) )
			continue;
		
		if ( !player.canPickupObject )
			continue;

		if ( player.throwingGrenade )
			continue;
			
		if ( isDefined( self.carrier ) )
			continue;
	
		if ( player isInVehicle() )
			continue;

		if ( player IsWeaponViewOnlyLinked() )
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
	self.trigger endon( "destroyed" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( self.isResetting )
			continue;
		
		if ( !isAlive( player ) )
			continue;
			
		if ( isdefined(player.laststand) && player.laststand )
			continue;
			
		if ( !self canInteractWith( player ) )
			continue;
		
		if ( !player.canPickupObject )
			continue;
			
		if ( player.throwingGrenade )
			continue;
			
		if ( isDefined( self.carrier ) )
			continue;
			
		if ( player isInVehicle() )
			continue;

		if ( player IsWeaponViewOnlyLinked() )
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
		if ( is_true( player.carryObject.swappable ) )
		{
			player.carryObject thread setDropped();
		}
		else
		{		
			if ( isDefined( self.onPickupFailed ) )
				self [[self.onPickupFailed]]( player );
				
			return;
		}
	}
		
	player giveObject( self );
	
	self setCarrier( player );

	for ( index = 0; index < self.visuals.size; index++ )
	{
		self.visuals[index] thread hideObject();
	}
			
	self.trigger.origin += (0,0,10000);

	self notify ( "pickup_object" );
	if ( isDefined( self.onPickup ) )
		self [[self.onPickup]]( player );
	
	self updateCompassIcons();
	self updateWorldIcons();
	self updateObjective();
}

hideObject()
{
	radius = 32;
	origin = self.origin;
	grenades = getentarray( "grenade", "classname" );
	radiusSq = radius * radius;
	linkedGrenades = [];
	linkedGrenadesIndex = 0;
	
	self hide();
	
	for( i = 0 ; i < grenades.size ; i++ )
	{
		if( DistanceSquared( origin, grenades[i].origin ) < radiusSq )
		{
			if ( grenades[i] islinkedto( self ) )
			{
				linkedGrenades[linkedGrenadesIndex] = grenades[i];
				linkedGrenades[linkedGrenadesIndex] unlink();
				linkedGrenadesIndex++;
			}
		}
	}
	
	self.origin += (0,0,10000);
	
	waittillframeend;
	
	for ( i = 0; i < linkedGrenadesIndex; i++ )
	{
		linkedGrenades[i] launch( (5,5,5) );
	}
}


updateCarryObjectOrigin()
{
	level endon ( "game_ended" );
	self.trigger endon( "destroyed" );
	
	if ( self.newStyle )
	{
		return;
	}
	
	objPingDelay = level.objectivePingDelay;
	for ( ;; )
	{
		if ( isDefined( self.carrier ) && level.teamBased )
		{
			self.curOrigin = self.carrier.origin + (0,0,75);
		
			foreach ( team in level.teams )
			{
				self.objPoints[team] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );
			}
			
			if ( (self.visibleTeam == "friendly" || self.visibleTeam == "any") && self.objIDPingFriendly )
			{
				foreach ( team in level.teams )
				{
					if (  self isFriendlyTeam( team ) )
					{
						if ( self.objPoints[team].isShown )
						{
							self.objPoints[team].alpha = self.objPoints[team].baseAlpha;
							self.objPoints[team] fadeOverTime( objPingDelay + 1.0 );
							self.objPoints[team].alpha = 0;
						}
						objective_position( self.objID[team], self.curOrigin );
					}
				}
			}

			if ( (self.visibleTeam == "enemy" || self.visibleTeam == "any") && self.objIDPingEnemy )
			{
				if ( !self isFriendlyTeam( team ) )
				{
					if ( self.objPoints[team].isShown )
					{
						self.objPoints[team].alpha = self.objPoints[team].baseAlpha;
						self.objPoints[team] fadeOverTime( objPingDelay + 1.0 );
						self.objPoints[team].alpha = 0;
					}
					objective_position( self.objID[team], self.curOrigin );
				}
			}

			self wait_endon( objPingDelay, "dropped", "reset" );
		}
		else if( isDefined( self.carrier ) )
		{
			self.curOrigin = self.carrier.origin + (0,0,75);
			self.objPoints[level.nonTeamBasedTeam] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin );
			objective_position( self.objID[level.nonTeamBasedTeam], self.curOrigin );

			wait ( 0.05 );
		}
		else
		{
			if ( level.teamBased )
			{
				foreach( team in level.teams )
				{
					self.objPoints[team] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );
				}
			}
			else
			{
				self.objPoints[level.nonTeamBasedTeam] maps\mp\gametypes\_objpoints::updateOrigin( self.curOrigin + self.offset3d );
			}

			wait ( 0.05 );
		}
	}
}

updateCarryObjectObjectiveOrigin()
{
	level endon ( "game_ended" );
	self.trigger endon( "destroyed" );
	
	if ( !self.newStyle )
	{
		return;
	}
	
	objPingDelay = level.objectivePingDelay;
	for ( ;; )
	{
		if ( isDefined( self.carrier ) )
		{
			self.curOrigin = self.carrier.origin;
			objective_position( self.objectiveID, self.curOrigin );
			self wait_endon( objPingDelay, "dropped", "reset" );
		}
		else
		{
			objective_position( self.objectiveID, self.curOrigin );
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

	if ( !object.newStyle )
	{
		if ( isDefined( object.carryIcon ) )
		{
			if ( self IsSplitscreen() )
			{
				self.carryIcon = createIcon( object.carryIcon, 35, 35 );
				self.carryIcon.x = -130;
				self.carryIcon.y = -90;
				self.carryIcon.horzAlign = "right";
				self.carryIcon.vertAlign = "bottom";
			}
			else
			{
				self.carryIcon = createIcon( object.carryIcon, 50, 50 );
				
				if ( !object.allowWeapons )
					self.carryIcon setPoint( "CENTER", "CENTER", 0, 60 );
				else
				{
					self.carryIcon.x = CARRY_ICON_X;
					self.carryIcon.y = CARRY_ICON_Y;
					self.carryIcon.horzAlign = "user_left";
					self.carryIcon.vertAlign = "user_bottom";
				}
			}
			self.carryIcon.alpha = 0.75;
			self.carryIcon.hidewhileremotecontrolling = true;
			self.carryIcon.hidewheninkillcam = true;
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
	updateObjective();
	
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
		visual = self.visuals[index];
		visual.origin = origin;
		visual.angles = angles;
		visual show();
	}
	self.trigger.origin = origin;
	
	self.curOrigin = self.trigger.origin;
	
	self clearCarrier();
	
	updateWorldIcons();
	updateCompassIcons();
	updateObjective();
	
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

	startOrigin = (0,0,0);
	endOrigin = (0,0,0);
	body = undefined;
	if ( isDefined( self.carrier ) && self.carrier.team != "spectator" )
	{
		startOrigin = self.carrier.origin + (0,0,20);
		endOrigin = self.carrier.origin - (0,0,2000);
		body = self.carrier.body;
		self.visuals[0].origin = self.carrier.origin;
	}
	else
	{
		startOrigin = self.safeOrigin + (0,0,20);
		endOrigin = self.safeOrigin - (0,0,20);
	}
	trace = playerPhysicsTrace( startOrigin, endOrigin );
	angleTrace = bulletTrace( startOrigin, endOrigin, false, body );
	
	droppingPlayer = self.carrier;
	
	if ( isDefined( trace ) )
	{
		tempAngle = randomfloat( 360 );
		
		dropOrigin = trace;		
		if ( angleTrace["fraction"] < 1 && distance( angleTrace["position"], trace ) < 10.0 )
		{
			forward = (cos( tempAngle ), sin( tempAngle ), 0);
			forward = vectornormalize( forward - VectorScale( angleTrace["normal"], vectordot( forward, angleTrace["normal"] ) ) );
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

		self thread pickupTimeout( trace[2], startOrigin[2] );
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
	self updateObjective();
	
	self.isResetting = false;
}


setCarrier( carrier )
{
	self.carrier = carrier;
	Objective_SetPlayerUsing( self.objectiveID, carrier );

	self thread updateVisibilityAccordingToRadar();
}


clearCarrier()
{
	if ( !isdefined( self.carrier ) )
		return;
	
	self.carrier takeObject( self );
	Objective_ClearPlayerUsing( self.objectiveID, self.carrier );
	
	self.carrier = undefined;
	
	self notify("carrier_cleared");
}


shouldBeReset( minZ, maxZ )
{
	mineTriggers = getEntArray( "minefield", "targetname" );
	hurtTriggers = getEntArray( "trigger_hurt", "classname" );
	elevators = GetEntArray( "script_elevator", "targetname" );

	for ( index = 0; index < mineTriggers.size; index++ )
	{
		if ( self.visuals[0] isTouchingSwept( mineTriggers[index], minZ, maxZ ) )
		{
			return true;
		}
	}

	for ( index = 0; index < hurtTriggers.size; index++ )
	{
		if ( self.visuals[0] isTouchingSwept( hurtTriggers[index], minZ, maxZ ) )
		{
			return true;
		}
	}

	for ( index = 0; index < elevators.size; index++ )
	{
		assert( IsDefined( elevators[index].occupy_volume ) );

		if ( self.visuals[0] isTouchingSwept( elevators[index].occupy_volume, minZ, maxZ ) )
		{
			return true;
		}
	}

	return false;
}


pickupTimeout( minZ, maxZ )
{
	self endon ( "pickup_object" );
	self endon ( "stop_pickup_timeout" );
	
	wait ( 0.05 );
	
	if ( self shouldBeReset( minZ, maxZ ) )
	{
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
	
	if ( isdefined( object.visibleCarrierModel ) )
	{
		self maps\mp\gametypes\_weapons::detach_all_weapons();
	}

	self.carryObject = undefined;

	if ( !isAlive( self ) )
		return;

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
In FFA gametypes, ownerTeam should be the player who owns the object
=============
*/
createUseObject( ownerTeam, trigger, visuals, offset, objectiveName )
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
	
	useObject.newStyle = false;
	
	if ( isdefined( objectiveName ) )
	{
		useObject.newStyle = true;
	}
	else
	{
		objectiveName = &"";
	}
	
	// this block will completely go away when we have fully switched to the new style
	{
		// compass objectives
		useObject.compassIcons = [];
		useObject.objID = [];
		if ( !useObject.newStyle )
		{
			foreach( team in level.teams )
			{
				useObject.objID[team] = getNextObjID();
			}
			
			if ( level.teamBased )
			{
				foreach( team in level.teams )
				{
					objective_add( useObject.objID[team], "invisible", useObject.curOrigin );
					objective_team( useObject.objID[team], team );
				}
			}
			else
			{
				objective_add( useObject.objID[level.nonTeamBasedTeam], "invisible", useObject.curOrigin );
			}
		}
	}

	// new style objective
	{
		useObject.objectiveID = getNextObjID();

		objective_add( useObject.objectiveID, "invisible", useObject.curOrigin, objectiveName );
	}
	
	if ( !useObject.newStyle )
	{
		if ( level.teamBased )
		{
			foreach( team in level.teams )
			{
				useObject.objPoints[team] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_" + team + "_" + useObject.entNum, useObject.curOrigin + offset, team, undefined );
				useObject.objPoints[team].alpha = 0;
			}
		}
		else
		{
			useObject.objPoints[level.nonTeamBasedTeam] = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_allies_" + useObject.entNum, useObject.curOrigin + offset, "all", undefined );
			useObject.objPoints[level.nonTeamBasedTeam].alpha = 0;
		}
	}

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
	useObject clearProgress();

	// if this is true, decay the flag back down instead of just resetting it to 0
	useObject.decayProgress = false;
	
	if ( useObject.triggerType == "proximity" )
	{
		useObject.numTouching["neutral"] = 0;
		useObject.numTouching["none"] = 0;
		useObject.touchList["neutral"] = [];
		useObject.touchList["none"] = [];

		foreach( team in level.teams )
		{
			useObject.numTouching[team] = 0;
			useObject.touchList[team] = [];
		}
		
		useObject.useRate = 0;
		useObject.claimTeam = "none";
		useObject.claimPlayer = undefined;
		useObject.lastClaimTeam = "none";
		useObject.lastClaimTime = 0;
		useObject.claimGracePeriod = 1.0;
		useObject.mustMaintainClaim = false;	
		useObject.canContestClaim = false;
	
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

Sets this use object to require carry object(s)
=============
*/
setKeyObject( object )
{
	if ( !IsDefined( object ) )
	{
		self.keyObject = undefined;
		
		return;
	}
	
	if ( !IsDefined( self.keyObject ) )
	{
		self.keyObject = [];
	}
	
	self.keyObject[ self.keyObject.size ] = object;
}


/*
=============
hasKeyObject

Checks if player is carrying key object(s)
=============
*/
hasKeyObject( use )
{
	for ( x = 0; x < use.keyObject.size; x++ )
	{
		if ( IsDefined( self.carryObject ) && IsDefined( use.keyObject[ x ] ) && ( self.carryObject == use.keyObject[ x ] ) )
		{
			return true;
		}
	}
	
	return false;
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
	self.trigger endon( "destroyed" );
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( !isAlive( player ) )
			continue;
			
		if ( !self canInteractWith( player ) )
			continue;
		
		if ( !player isOnGround() )
			continue;
		
		if ( player isInVehicle() )
			continue;
		
		if ( isDefined( self.keyObject ) && (!isDefined( player.carryObject ) || !player hasKeyObject( self ) ) )
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
	self.trigger endon( "destroyed" );
	
	self thread proxTriggerThink();
	
	while ( true )
	{
		if ( self.useTime && self.curProgress >= self.useTime )
		{
			self clearProgress();
			
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
				self clearProgress();
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

						decayScale = 0;
						if ( self.decayTime )
						{
							decayScale = self.useTime / self.decayTime;
						}
						
						self.curProgress -= (50 * self.useRate * decayScale);
						if ( self.curProgress <= 0 )
							self clearProgress();
					
						updateCurrentProgress();

						if ( isDefined( self.onUseUpdate ) )
							self [[self.onUseUpdate]]( self getClaimTeam(), self.curProgress / self.useTime, (50*self.useRate*decayScale) / self.useTime );

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
						updateCurrentProgress();
						if ( isDefined( self.onUseUpdate ) )
							self [[self.onUseUpdate]]( self getClaimTeam(), self.curProgress / self.useTime, (50*self.useRate) / self.useTime );
					}
				}
				else if ( !self.mustMaintainClaim )
				{
					if ( isDefined( self.onUse ) )
						self [[self.onUse]]( self.claimPlayer );
					
					// onUse may toggle on mustMaintainClaim
					if ( !self.mustMaintainClaim )
					{
						self setClaimTeam( "none" );
						self.claimPlayer = undefined;	
					}
				}
				else if ( !self.numTouching[self.claimTeam] )
				{
					if ( isDefined( self.onUnoccupied ) )
						self [[self.onUnoccupied]]();			
	
					self setClaimTeam( "none" );
					self.claimPlayer = undefined;	
				}
				else if ( self.canContestClaim )
				{
					numOther = getNumTouchingExceptTeam( self.claimTeam );

					if ( numOther > 0 )
					{
						if ( isDefined( self.onContested ) )
							self [[self.onContested]]();			
		
						self setClaimTeam( "none" );
						self.claimPlayer = undefined;	
					}
				}
			}

		}
		else
		{
			if ( self.curProgress > 0 && getTime() - self.lastClaimTime > ( self.claimGracePeriod * 1000 ) )
				self clearProgress();
			
		}

		wait ( 0.05 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
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
	if ( isDefined( self.teamLock ) && isdefined( level.teams[team] ) )
	{
		return self.teamLock[team];
	}

	return false;
}

/*
=============
canClaim

Determine if the player can claim 
=============
*/
canClaim( player )
{
	if ( self.canContestClaim )
	{
		numOther = getNumTouchingExceptTeam( player.pers["team"] );
		
		if ( numOther != 0 )
			return false;
	}
	
	if ( !isDefined( self.keyObject ) || (isDefined( player.carryObject ) && player hasKeyObject( self ) ) )
		return true;
	
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
	self.trigger endon( "destroyed" );
	
	entityNumber = self.entNum;
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		// TODO: Notify the player if they are attempting to capture a locked flag
		if ( !isAlive( player ) || self useObjectLockedForTeam( player.pers["team"] ) )
			continue;
		
		if ( player isInVehicle() )
			continue;

		if ( player IsWeaponViewOnlyLinked() )
			continue;
			
		if ( self canInteractWith( player ) && self.claimTeam == "none" )
		{
			if ( self canClaim( player ) )
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
			
		if ( isAlive( player ) && !isDefined( player.touchTriggers[entityNumber] ) )
			player thread triggerTouchThink( self );
	}
}

clearProgress()
{
	self.curProgress = 0;
	
	updateCurrentProgress();
	
	if ( isDefined( self.onUseClear ) )
		self [[self.onUseClear]]( );
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
	
	if ( self.claimTeam == "none" && getTime() - self.lastClaimTime > ( self.claimGracePeriod * 1000 ) )
		self clearProgress();
	else if ( newTeam != "none" && newTeam != self.lastClaimTeam )
		self clearProgress();

	self.lastClaimTeam = self.claimTeam;
	self.lastClaimTime = getTime();
	self.claimTeam = newTeam;
	
	self updateUseRate();
}


getClaimTeam()
{
	return self.claimTeam;
}

continueTriggerTouchThink(team,object)
{
	if ( !isAlive( self ) )
		return false;
		
	if ( self useObjectLockedForTeam( team ) )
	  return false;
	 
	if ( self isinvehicle() )
		return false;
		
	if ( !self isTouching( object.trigger ) )
	  return false;
	  
	return true;
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

	score = 1;

	object.numTouching[team] = object.numTouching[team] + score;

	if ( object.useTime )
	{
		object updateUseRate();
	}

	touchName = "player" + self.clientid;
	struct = spawnstruct();
	struct.player = self;
	struct.starttime = gettime();
	object.touchList[team][touchName] = struct;
	Objective_SetPlayerUsing( object.objectiveID, self );
	
	self.touchTriggers[object.entNum] = object.trigger;

	if ( isDefined( object.onTouchUse ) )
		object [[object.onTouchUse]]( self );

	while ( self continueTriggerTouchThink(team,object) )
	{
		if ( object.useTime )
		{
			self updateProxBar( object, false );
		}
		wait ( 0.05 );
	}

	// disconnected player will skip this code
	if ( isDefined( self ) )
	{
		if ( object.useTime )
		{
			self updateProxBar( object, true );
		}
		self.touchTriggers[object.entNum] = undefined;
		Objective_ClearPlayerUsing( object.objectiveID, self );
	}
	
	if ( level.gameEnded )
		return;
	
	object.touchList[team][touchName] = undefined;

	object.numTouching[team] = object.numTouching[team] - score;
	// there's a bug here because of the specialty_fastinteract, so we need to see if we're less than 1
	//	reason being is because the team can never have less than 1 person on the flag, so if it's less than 1 then we can say no one is on it
	if( object.numTouching[team] < 1 )
	{
		object.numTouching[team] = 0;
	}
	
	if ( object.useTime )
	{
		// There was a timing bug here where a player could leave the trigger but have just completed its progress so:
		// If no one is touching make sure progress is not completed in the same frame
		if ( object.numTouching[team] <= 0 && ( object.curProgress >= object.useTime ) )
		{
			object.curProgress = object.useTime - 1;
			updateCurrentProgress();
		}
	}
	
	if ( isDefined( self ) && isDefined( object.onEndTouchUse ) )
	{
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
	if ( object.newStyle )
		return;
		
	if ( !forceRemove && object.decayProgress )
	{
		if ( !object canInteractWith( self ) )
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
	else if ( forceRemove || !object canInteractWith( self ) || self.pers["team"] != object.claimTeam )
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
		self.proxBar.lastHostMigrationState = false;
	}
	
	if ( self.proxBar.hidden )
	{
		self.proxBar showElem();
		self.proxBar.lastUseRate = -1;
		self.proxBar.lastHostMigrationState = false;
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
	
	if ( self.proxBar.lastUseRate != object.useRate || self.proxBar.lastHostMigrationState != isDefined( level.hostMigrationTimer ) )
	{
		if( object.curProgress > object.useTime)
			object.curProgress = object.useTime;
				
		if ( object.decayProgress && self.pers["team"] != object.claimTeam )
		{
			if ( object.curProgress > 0 )
			{
				progress = object.curProgress / object.useTime;
				rate =  (1000 / object.useTime) * ( object.useRate * -1 );
				if ( isDefined( level.hostMigrationTimer ) )
					rate = 0;
				self.proxBar updateBar( progress, rate );
			}
		}
		else
		{
			progress = object.curProgress / object.useTime;
			rate = (1000 / object.useTime) * object.useRate;
			if ( isDefined( level.hostMigrationTimer ) )
				rate = 0;
			self.proxBar updateBar( progress, rate );
		}
		self.proxBar.lastHostMigrationState = isDefined( level.hostMigrationTimer );
		self.proxBar.lastUseRate = object.useRate;
	}
}

getNumTouchingExceptTeam( ignoreTeam )
{
	numTouching = 0;
	foreach( team in level.teams )
	{
		if ( ignoreTeam == team )
			continue;
		numTouching += self.numTouching[team];
	}
	
	return numTouching;
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
	
	numOther = getNumTouchingExceptTeam( self.claimTeam );

	self.useRate = 0;

	if ( self.decayProgress )
	{
		if ( numClaimants && !numOther )
			self.useRate = numClaimants;
		else if ( !numClaimants && numOther )
			self.useRate = numOther;
		else if ( !numClaimants && !numOther )
			self.useRate = 0;
	}
	else
	{
		if ( numClaimants && !numOther )
			self.useRate = numClaimants;
	}

	if ( isDefined( self.onUpdateUseRate ) )
		self [[self.onUpdateUseRate]]( );
}


//attachUseModel()
//{
//	self endon("death");
//	self endon("disconnect");
//	self endon("done_using");
//	
//	wait 1.3;
//	
//	self attach( "weapon_explosives", "tag_inhand", true );
//	self.attachedUseModel = "weapon_explosives";
//}

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
	if ( !is_true( self.dontLinkPlayerToTrigger ) )
	{
		player playerLinkTo( self.trigger );
		player PlayerLinkedOffsetEnable();
	}
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
		
		//player thread attachUseModel();
	}
	else
	{
		player _disableWeapon();
	}
	
	self clearProgress();
	self.inUse = true;
	self.useRate = 0;
	Objective_SetPlayerUsing( self.objectiveID, player );
	player thread personalUseBar( self );
	
	result = useHoldThinkLoop( player, lastWeapon );
	
	if ( isDefined( player ) )
	{
		Objective_ClearPlayerUsing( self.objectiveID, player );
		self clearProgress();
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
			ammo = player GetWeaponAmmoClip( lastWeapon );
			if ( lastWeapon != "none" && !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( lastWeapon ) && !( IsWeaponEquipment( lastWeapon ) && player GetWeaponAmmoClip( lastWeapon ) == 0 ) )
				player switchToWeapon( lastWeapon );
			else
			{
				player takeWeapon( useWeapon );
				player switchToLastNonKillstreakWeapon();
			}
		}
		else if ( IsAlive( player ) )
		{
			player _enableWeapon();
		}

		if ( !is_true( self.dontLinkPlayerToTrigger ) )
		{
			player unlink();
		}
		
		if ( !isAlive( player ) )
			player.killedInUse = true;
	}

	self.inUse = false;
	
	if ( self.trigger.classname == "trigger_radius_use" )
	{
		player ClientReleaseTrigger( self.trigger );
	}
	else
	{	
		self.trigger releaseClaimedTrigger();
	}
	
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

continueHoldThinkLoop(player, waitForWeapon, timedOut, useTime)
{
	maxWaitTime = 1.5; // must be greater than the putaway timer for all weapons

	if (!IsAlive(player))
		return false;

	if ( IsDefined( player.laststand ) && player.laststand )
		return false;
		
	if ( self.curProgress >= useTime )
		return false;
	
	if ( !(player useButtonPressed()) )
		return false;
		
	if (player.throwingGrenade)
		return false;
	
	if ( player meleeButtonPressed() )
		return false;
	
	if ( player isinvehicle() )
		return false;

	if ( player isRemoteControlling() )
		return false;
	
	if ( player IsWeaponViewOnlyLinked() )
		return false;

	if ( !(player isTouching( self.trigger ) ) )
		return false;
		
	if ( !self.useRate && !waitForWeapon )
		return false;
	
	if (waitForWeapon && timedOut > maxWaitTime)
		return false;
		
	return true;
}

updateCurrentProgress()
{
	if ( self.useTime )
	{
		progress = float(self.curProgress) / self.useTime;
		
		Objective_SetProgress( self.objectiveID, clamp(progress,0,1) );
	}
}

useHoldThinkLoop( player, lastWeapon )
{
	level endon ( "game_ended" );
	self endon("disabled");
	
	useWeapon = self.useWeapon;
	waitForWeapon = true;
	timedOut = 0;
	
	useTime = self.useTime;

	while( self continueHoldThinkLoop( player, waitForWeapon, timedOut, useTime ) )
	{
		timedOut += 0.05;

		if ( !isDefined( useWeapon ) || player getCurrentWeapon() == useWeapon )
		{
			self.curProgress += (50 * self.useRate);
			updateCurrentProgress();
			self.useRate = 1;
			waitForWeapon = false;
		}
		else
		{
			self.useRate = 0;
		}

		if ( self.curProgress >= useTime )
		{
			self.inUse = false;
			player clientReleaseTrigger( self.trigger );
			player.claimTrigger = undefined;
			
			if ( isDefined( useWeapon ) )
			{
				player setWeaponAmmoStock( useWeapon, 1 );
				player setWeaponAmmoClip( useWeapon, 1 );
				if ( lastWeapon != "none" && !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( lastWeapon ) && !( IsWeaponEquipment( lastWeapon ) && player GetWeaponAmmoClip( lastWeapon ) == 0 ) )
					player switchToWeapon( lastWeapon );
				else
				{
					player takeWeapon( useWeapon );
					player switchToLastNonKillstreakWeapon();
				}
			}
			else
			{
				player _enableWeapon();
			}
			
			if ( !is_true( self.dontLinkPlayerToTrigger ) )
			{
				player unlink();
			}
			
			wait .05;
			
			return isAlive( player );
		}
		
		wait 0.05;
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
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
	
	if ( object.newStyle )
	{
		return;
	}

	if( isDefined( self.useBar ) )
		return;
	
	self.useBar = createPrimaryProgressBar();
	self.useBarText = createPrimaryProgressBarText();
	self.useBarText setText( object.useText );

	useTime = object.useTime;

	lastRate = -1;
	lastHostMigrationState = isDefined( level.hostMigrationTimer );
	while ( isAlive( self ) && object.inUse && !level.gameEnded )
	{
		if ( lastRate != object.useRate || lastHostMigrationState != isDefined( level.hostMigrationTimer ) )
		{
			if( object.curProgress > useTime)
				object.curProgress = useTime;

			if ( object.decayProgress && self.pers["team"] != object.claimTeam )
			{
				if ( object.curProgress > 0 )
				{
					progress = object.curProgress / useTime;
					rate = (1000 / useTime) * ( object.useRate * -1 );
					if ( isDefined( level.hostMigrationTimer ) )
						rate = 0;
					self.proxBar updateBar( progress, rate );
				}
			}
			else
			{
				progress = object.curProgress / useTime;
				rate = (1000 / useTime) * object.useRate;
				if ( isDefined( level.hostMigrationTimer ) )
					rate = 0;
				self.useBar updateBar( progress, rate );
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
		lastHostMigrationState = isDefined( level.hostMigrationTimer );
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
	else if ( ( self.interactTeam == "any" ) || !level.teamBased )
	{
		self.trigger.origin = self.curOrigin;
		self.trigger setTeamForTrigger( "none" );
	}
	else if ( self.interactTeam == "friendly" )
	{
		self.trigger.origin = self.curOrigin;
		if ( isdefined( level.teams[self.ownerTeam] ) )
			self.trigger setTeamForTrigger( self.ownerTeam );
		else
			self.trigger.origin -= (0,0,50000);
	}
	else if ( self.interactTeam == "enemy" )
	{
		self.trigger.origin = self.curOrigin;
		self.trigger SetExcludeTeamForTrigger( self.ownerTeam );
	}
}

updateObjective()
{
	if ( !self.newStyle )
		return;
	
	objective_team( self.objectiveID, self.ownerTeam );
	
	if ( self.visibleTeam == "any" )
	{
		objective_state( self.objectiveID, "active");
		objective_visibleteams( self.objectiveID, level.spawnsystem.iSPAWN_TEAMMASK["all"] );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		objective_state( self.objectiveID, "active");
		// TODO convert level.spawnsystem.iSPAWN_TEAMMASK to be more global
		objective_visibleteams( self.objectiveID, level.spawnsystem.iSPAWN_TEAMMASK[self.ownerTeam] );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		objective_state( self.objectiveID, "active");
		// TODO convert level.spawnsystem.iSPAWN_TEAMMASK to be more global
		objective_visibleteams( self.objectiveID, level.spawnsystem.iSPAWN_TEAMMASK["all"] & ~(level.spawnsystem.iSPAWN_TEAMMASK[self.ownerTeam]) );
	}
	else
	{
		objective_state( self.objectiveID, "invisible");
		objective_visibleteams( self.objectiveID, 0 );
	}
	
	if ( self.type == "carryObject" )
	{
		if ( isAlive( self.carrier ) )
		{
			objective_onentity( self.objectiveID, self.carrier );
		}
		else
		{
			objective_clearentity( self.objectiveID );
		}
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
	if ( self.newStyle )
		return;
		
	if ( !isDefined( self.worldIcons[relativeTeam] ) )
		showIcon = false;
	
	updateTeams = getUpdateTeams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		if ( !level.teamBased && updateTeams[index] != level.nonTeamBasedTeam )
			continue;
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
	if ( self.newStyle )
		return;

	updateTeams = getUpdateTeams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		showIconThisTeam = showIcon;
		if ( !showIconThisTeam && shouldShowCompassDueToRadar( updateTeams[ index ] ) )
			showIconThisTeam = true;
		
		if ( level.teamBased )
			objId = self.objID[updateTeams[ index ]];
		else
			objId = self.objID[level.nonTeamBasedTeam];
				
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
	if ( level.teamBased )
	{
		if ( relativeTeam == "friendly" )
		{
			foreach( team in level.teams )
			{
				if ( self isFriendlyTeam( team ) )
					updateTeams[updateTeams.size] = team;
			}
		}
		else if ( relativeTeam == "enemy" )
		{
			foreach( team in level.teams )
			{
				if ( !self isFriendlyTeam( team ) )
					updateTeams[updateTeams.size] = team;
			}
		}
	}
	else
	{
		if ( relativeTeam == "friendly" )
			updateTeams[updateTeams.size] = level.nonTeamBasedTeam;
		else
			updateTeams[updateTeams.size] = "axis";
	}
	
	return updateTeams;
}

shouldShowCompassDueToRadar( team )
{
	showCompass = false;
	if ( !isdefined( self.carrier ) )
		return false;
	
	if ( self.carrier hasPerk( "specialty_gpsjammer" ) == false )
		if ( maps\mp\killstreaks\_radar::teamHasSpyplane( team ) )
			showCompass = true;

	if ( maps\mp\killstreaks\_radar::teamHasSatellite( team ) )
		showCompass = true;

	return showCompass;
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
	self updateObjective();
}

getOwnerTeam()
{
	return self.ownerTeam;
}

setDecayTime( time )
{
	self.decayTime = int( time * 1000 );
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
	updateObjective();
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

destroyObject( deleteTrigger, forceHide )
{
	if ( !IsDefined( forceHide ) )
	{
		forceHide = true;
	}
	
	self disableObject( forceHide );

	foreach ( visual in self.visuals )
	{
		visual Hide();
		visual Delete();
	}
	
	self.trigger notify( "destroyed" );

	if ( is_true( deleteTrigger ) )
	{
		self.trigger Delete();
	}
	else
	{
		self.trigger triggerOn();
	}
}

disableObject( forceHide )
{
	self notify("disabled");
	
	if ( self.type == "carryObject" || ( isDefined( forceHide ) && forceHide ) )
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


enableObject( forceShow )
{
	if ( self.type == "carryObject" || ( isDefined( forceShow ) && forceShow ) )
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
	if( self.ownerTeam == "any" )
		return "friendly";

	if ( team == self.ownerTeam )
		return "friendly";
	else if ( team == getEnemyTeam( self.ownerTeam ) )
		return "enemy";
	else
		return "neutral";
}


isFriendlyTeam( team )
{
	if ( !level.teamBased )
		return true;
	
	if ( self.ownerTeam == "any" )
		return true;
	
	if ( self.ownerTeam == team )
		return true;

	return false;
}


canInteractWith( player )
{
	team = player.pers["team"];
	switch( self.interactTeam )
	{
		case "none":
			return false;

		case "any":
			return true;

		case "friendly":
			if ( level.teamBased )
			{
				if ( team == self.ownerTeam )
					return true;
				else
					return false;
			}
			else
			{
				if ( player == self.ownerTeam )
					return true;
				else
					return false;
			}

		case "enemy":
			if ( level.teamBased )
			{
				if ( team != self.ownerTeam )
					return true;
				else if ( IsDefined(self.decayProgress) && self.decayProgress && self.curProgress > 0 )
					return true;
				else
					return false;
			}
			else
			{
				if ( player != self.ownerTeam )
					return true;
				else
					return false;
			}

		default:
			assert( 0, "invalid interactTeam" );
			return false;
	}
}


isTeam( team )
{
	if ( team == "neutral" )
		return true;
	if ( isdefined( level.teams[team] ) )
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


getEnemyTeam( team )
{
	if ( team == "neutral" )
		return "none";
	// TODO MTEAM - figure out how to determine enemy team
	else if ( team == "allies" )
		return "axis";
	else
		return "allies";
}

getNextObjID()
{
	nextID = 0;
	
	if (  level.releasedObjectives.size > 0 )
	{
		nextID = level.releasedObjectives[ level.releasedObjectives.size - 1 ];
		level.releasedObjectives[ level.releasedObjectives.size - 1 ] = undefined;
	}
	else
	{
		nextID = level.numGametypeReservedObjectives;
		level.numGametypeReservedObjectives++;
	}

	Assert( nextId < MAX_OBJECTIVE_IDS, "Ran out of objective IDs" );
	return nextID;
}

releaseObjID( objID )
{
	Assert( objID < level.numGametypeReservedObjectives );
	for ( i = 0; i < level.releasedObjectives.size; i++ )
	{
		if ( objID == level.releasedObjectives[i] && objID == 31 )
			return;
/#
		Assert( objID != level.releasedObjectives[i] );
#/	
	}
	level.releasedObjectives[ level.releasedObjectives.size ] = objID;		
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

mustMaintainClaim( enabled )
{
	self.mustMaintainClaim = enabled;
}

canContestClaim( enabled )
{
	self.canContestClaim = enabled;
}

setFlags( flags )
{
	Objective_SetGamemodeFlags( self.objectiveID, flags );
}

getFlags( flags )
{
	return Objective_GetGamemodeFlags( self.objectiveID );
}