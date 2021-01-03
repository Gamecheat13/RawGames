#using scripts\shared\callbacks_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     






	
#namespace gameobjects;

function autoexec __init__sytem__() {     system::register("gameobjects",&__init__,undefined,undefined);    }
	
function __init__()
{
	level.numGametypeReservedObjectives = 0;
	level.releasedObjectives = [];

	callback::on_spawned( &on_player_spawned );
	callback::on_disconnect( &on_disconnect );
	callback::on_laststand( &on_player_last_stand );
}

function main()
{
	level.vehiclesEnabled = GetGametypeSetting( "vehiclesEnabled" );
	level.vehiclesTimed = GetGametypeSetting( "vehiclesTimed" );
	level.objectivePingDelay = GetGametypeSetting( "objectivePingTime" );
	
	level.nonTeamBasedTeam = "allies";
	
	if ( !IsDefined( level.allowedGameObjects ) )
	{
		level.allowedGameObjects = [];
	}
	
	if ( level.oldschool )
	{
		level.allowedGameObjects[level.allowedGameObjects.size] = "os";
	}	
	
	/#
	//###stefan $NOTE don't remove vehicles when running the vehicle test maps
	if ( level.script == "mp_vehicle_test" )
	{
		level.vehiclesEnabled = true;
	}
	#/
	
	if (level.vehiclesEnabled)
	{
		level.allowedGameObjects[level.allowedGameObjects.size]= "vehicle";
		filter_script_vehicles_from_vehicle_descriptors(level.allowedGameObjects);
	}
	
	entities= GetEntArray();
	for (entity_index= entities.size-1; entity_index>=0; entity_index--)
	{
		entity= entities[entity_index];
		if (!entity_is_allowed(entity, level.allowedGameObjects))
		{
			entity delete();
		}
	}
	
	return;
}

function register_allowed_gameobject( gameobject )
{
	if ( !IsDefined( level.allowedGameObjects ) )
	{
		level.allowedGameObjects = [];
	}
	
	level.allowedGameObjects[level.allowedGameObjects.size] = gameobject;

	if ( level.oldschool )
	{
		level.allowedGameObjects[level.allowedGameObjects.size] = "os" + gameobject;
	}	
}

function clear_allowed_gameobjects()
{
	level.allowedGameObjects = [];
}

//bool
function entity_is_allowed( entity, allowed_game_modes )
{
	allowed= true;
	
	// is entity allowed for any of the give game modes?
	if (isdefined(entity.script_gameobjectname) &&
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

//bool
function location_is_allowed( entity, location )
{
	allowed = true;
	
	location_list = undefined;
	
	// Check if Location stored on Script_Noteworthy
	//----------------------------------------------
	if ( IsDefined( entity.script_noteworthy ) )
	{
		location_list = entity.script_noteworthy;
	}

	// Check if Location stored on Script_Location, Takes Prescedence over Script_Noteworthy
	//--------------------------------------------------------------------------------------
	if ( IsDefined( entity.script_location ) )
	{
		location_list = entity.script_location;
	}
	
	if ( IsDefined( location_list ) )
	{
		if ( location_list == "[all_modes]" )
		{
			allowed = true;
		}
		else
		{
			allowed = false;
			
			gameobjectlocations = StrTok( location_list, " " );
			
			for ( j = 0; j < gameobjectlocations.size; j++ )
			{
				if ( gameobjectlocations[ j ] == location )
				{
					allowed = true;
					break;
				}
			}
		}
	}
	
	return allowed;
}

// this function filters out script_vehicles (which are usually placed as prefabs)
// based on associated vehicle_descriptor objects
function filter_script_vehicles_from_vehicle_descriptors(
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
		
		if (isdefined(closest_vehicle))
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


//=====================================================================================
// Callback functions
//=====================================================================================
function on_player_spawned()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	self thread on_death();
	self.touchTriggers = [];
	self.packObject = [];
	self.packIcon = [];
	self.carryObject = undefined;
	self.claimTrigger = undefined;
	self.canPickupObject = true;
	self.disabledWeapon = 0;
	self.killedInUse = undefined;
}

//Drops any carried object when the player dies
function on_death()
{
	level endon ( "game_ended" );
	self endon("killOnDeathMonitor");
	
	self waittill ( "death" );

	self thread gameObjects_dropped();
}

//Drops any carried object when the player disconnects
function on_disconnect()
{
	level endon ( "game_ended" );
	
	self thread gameObjects_dropped();
}

//Drops any carried object when the player enters laststand
function on_player_last_stand()
{
	self thread gameObjects_dropped();
}

function gameObjects_dropped()
{
	if ( isdefined( self.carryObject ) )
	{
		self.carryObject thread set_dropped();
	}
	
	if ( isdefined( self.packObject ) && self.packObject.size > 0 )
	{
		foreach(item in self.packObject)
		{
			item thread set_dropped();
		}
	}
}	
//=====================================================================================

/*
=============
create_carry_object

Creates and returns a carry object
=============
*/
function create_carry_object( ownerTeam, trigger, visuals, offset, objectiveName, hitSound )
{
	carryObject = spawnStruct();
	carryObject.type = "carryObject";
	carryObject.curOrigin = trigger.origin;
	carryObject.entNum = trigger getEntityNumber();
	carryObject.hitSound = hitSound;
	
	if ( isSubStr( trigger.classname, "use" ) )
	{
		carryObject.triggerType = "use";
	}
	else
	{
		carryObject.triggerType = "proximity";
	}
		
	// associated trigger
	trigger.baseOrigin = trigger.origin;
	carryObject.trigger = trigger;
	
	carryObject.useWeapon = undefined;
	
	if ( !isdefined( offset ) )
	{
		offset = (0,0,0);
	}

	carryObject.offset3d = offset;
	
	carryObject.newStyle = false;
	
	if ( isdefined( objectiveName ) )
	{
		if( !SessionModeIsCampaignGame() )
		{
			carryObject.newStyle = true;
		}
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
	
	carryObject _set_team( ownerTeam );
	
	// compass objectives
	carryObject.compassIcons = [];
	carryObject.objID =[];
	// this block will completely go away when we have fully switched to the new style
	if ( !carryObject.newStyle )
	{
		foreach( team in level.teams )
		{
			carryObject.objID[team] = get_next_obj_id();
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
				if( SessionModeIsCampaignGame() )
				{
					if( team == "allies" )
					{
						objective_add( carryObject.objID[team], "active", carryObject.curOrigin, objectiveName );
					}
					else
					{
						objective_add( carryObject.objID[team], "invisible", carryObject.curOrigin, objectiveName );
					}
				}
				else
				{
					objective_add( carryObject.objID[team], "invisible", carryObject.curOrigin, objectiveName );
				}
				
				objective_team( carryObject.objID[team], team );
				carryObject.objPoints[team] = objpoints::create( "objpoint_" + team + "_" + carryObject.entNum, carryObject.curOrigin + offset, team, undefined );
				carryObject.objPoints[team].alpha = 0;
			}
		}
		else
		{
			// TODO MTEAM - not sure why the we only use allies in dm
			objective_add( carryObject.objID[level.nonTeamBasedTeam], "invisible", carryObject.curOrigin, objectiveName );
			carryObject.objPoints[level.nonTeamBasedTeam] = objpoints::create( "objpoint_"+ level.nonTeamBasedTeam + "_" + carryObject.entNum, carryObject.curOrigin + offset, "all", undefined );
			carryObject.objPoints[level.nonTeamBasedTeam].alpha = 0;
		}
	}
	
	carryObject.objectiveID = get_next_obj_id();
	
	// new style objective
	if ( carryObject.newStyle )
	{
		objective_add( carryObject.objectiveID, "invisible", carryObject.curOrigin, objectiveName );
	}
	
	// carrying player
	carryObject.carrier = undefined;
	
	// misc
	carryObject.isResetting = false;	
	carryObject.interactTeam = "none"; // "none", "any", "friendly", "enemy";
	carryObject.allowWeapons = false;
	carryObject.visibleCarrierModel = undefined;
	carryObject.dropOffset = 0;
	carryObject.disallowRemoteControl = false;
	
	// 3d world icons
	carryObject.worldIcons = [];
	carryObject.carrierVisible = false; // carryObject only
	carryObject.visibleTeam = "none"; // "none", "any", "friendly", "enemy";
	carryObject.worldIsWaypoint = [];

	carryObject.worldIcons_disabled = [];
	
	carryObject.carryIcon = undefined;

	// callbacks
	carryObject.setDropped = undefined;
	carryObject.onDrop = undefined;
	carryObject.onPickup = undefined;
	carryObject.onReset = undefined;
	

	if ( carryObject.triggerType == "use" )
	{
		carryObject thread carry_object_use_think();
	}
	else
	{
		carryObject.numTouching["neutral"] = 0;
		carryObject.numTouching["none"] = 0;
		carryObject.touchList["neutral"] = [];
		carryObject.touchList["none"] = [];

		foreach( team in level.teams )
		{
			carryObject.numTouching[team] = 0;
			carryObject.touchList[team] = [];
		}
		
		carryObject.curProgress = 0;
		carryObject.useTime = 0;
		carryObject.useRate = 0;
		carryObject.claimTeam = "none";
		carryObject.claimPlayer = undefined;
		carryObject.lastClaimTeam = "none";
		carryObject.lastClaimTime = 0;
		carryObject.claimGracePeriod = 0;
		carryObject.mustMaintainClaim = false;	
		carryObject.canContestClaim = false;
		carryObject.decayProgress = false;

		carryObject.teamUseTimes = [];
		carryObject.teamUseTexts = [];

		carryObject.onUse =&set_picked_up;
		
		carryObject thread use_object_prox_think();

		//carryObject thread carry_object_prox_think();
	}
		
	carryObject thread update_carry_object_origin();
	carryObject thread update_carry_object_objective_origin();

	return carryObject;
}


/*
=============
carry_object_use_think

Think function for "use" type carry objects
=============
*/
function carry_object_use_think()
{
	level endon ( "game_ended" );
	self.trigger endon( "destroyed" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( self.isResetting )
		{
			continue;
		}
		
		if ( !isAlive( player ) )
		{
			continue;
		}
			
		if ( isdefined(player.laststand) && player.laststand )
		{
			continue;
		}
			
		if ( !self can_interact_with( player ) )
		{
			continue;
		}
		
		if ( !player.canPickupObject )
		{
			continue;
		}

		if ( player.throwingGrenade )
		{
			continue;
		}
			
		if ( isdefined( self.carrier ) )
		{
			continue;
		}
	
		if ( player isInVehicle() )
		{
			continue;
		}
		
		if ( player isRemoteControlling() || player util::isUsingRemote() )
		{
			continue;
		}		

		if ( ( isdefined( player.selectingLocation ) && player.selectingLocation ) )
		{
			continue;
		}
		
		if ( player IsWeaponViewOnlyLinked() )
		{
			continue;
		}

		if( !player isTouching( self.trigger ) )
		{
			continue;
		}
				
		self set_picked_up( player );
	}
}

/*
=============
carry_object_prox_think

Think function for "proximity" type carry objects
=============
*/
function carry_object_prox_think()
{
	level endon ( "game_ended" );
	self.trigger endon( "destroyed" );

	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( self.isResetting )
		{
			continue;
		}
		
		if ( !isAlive( player ) )
		{
			continue;
		}
			
		if ( isdefined(player.laststand) && player.laststand )
		{
			continue;
		}
			
		if ( !self can_interact_with( player ) )
		{
			continue;
		}
		
		if ( !player.canPickupObject )
		{
			continue;
		}
			
		if ( player.throwingGrenade )
		{
			continue;
		}
			
		if ( isdefined( self.carrier ) )
		{
			continue;
		}
			
		if ( player isInVehicle() )
		{
			continue;
		}
		
		if ( player isRemoteControlling() || player util::isUsingRemote() )
		{
			continue;
		}		

		if ( ( isdefined( player.selectingLocation ) && player.selectingLocation ) )
		{
			continue;
		}
		
		if ( player IsWeaponViewOnlyLinked() )
		{
			continue;
		}

		//Fix for player being able to respawn with the flag. This occured due to 
		//trigger collisions being stored and used a frame later than the collision occured.
		if( !player isTouching( self.trigger ) )
		{
			continue;
		}
				
		self set_picked_up( player );
	}
}


/*
=============
pickup_object_delay

Temporarily disallows picking up of "proximity" type objects
=============
*/
function pickup_object_delay( origin )
{
	level endon ( "game_ended" );

	self endon("death");
	self endon("disconnect");
	
	self.canPickupObject = false;
	
	for( ;; )
	{
		if ( distanceSquared( self.origin, origin ) > 64*64 )
		{
			break;
		}

		wait 0.2;
	}
	
	self.canPickupObject = true;
}


/*
=============
set_picked_up

Sets this object as picked up by passed player
=============
*/
function set_picked_up( player )
{
	if ( !IsAlive( player ) )
	{
		return;
	}

	if ( self.type == "carryObject" )
	{
		if(isdefined( player.carryObject ))
		{ 
			if ( ( isdefined( player.carryObject.swappable ) && player.carryObject.swappable ) )
			{
				player.carryObject thread set_dropped();
			}
			else
			{		
				if ( isdefined( self.onPickupFailed ) )
				{
					self [[self.onPickupFailed]]( player );
				}
					
				return;
			}
		}
		
		player give_object( self );
	}
	else if( self.type == "packObject")
	{
		if(IsDefined(level.max_packObjects) && (level.max_packObjects <= player.packObject.size))
		{		
			if ( isdefined( self.onPickupFailed ) )
			{
				self [[self.onPickupFailed]]( player );
			}
				
			return;
		}	

		player give_pack_object( self );
	}	
	
	self set_carrier( player );

	self ghost_visuals();
			
	// this should get replaced triggerenable functionality
	self.trigger.origin += (0,0,10000);

	self notify ( "pickup_object" );
	if ( isdefined( self.onPickup ) )
	{
		self [[self.onPickup]]( player );
	}
	
	self update_compass_icons();
	self update_world_icons();
	self update_objective();
}

function unlink_grenades()
{
	radius = 32;
	origin = self.origin;
	grenades = getentarray( "grenade", "classname" );
	radiusSq = radius * radius;
	linkedGrenades = [];

	foreach( grenade in grenades )
	{
		if( DistanceSquared( origin, grenade.origin ) < radiusSq )
		{
			if ( grenade islinkedto( self ) )
			{
				grenade unlink();
				
				linkedGrenades[linkedGrenades.size] = grenade;
			}
		}
	}
	
	waittillframeend;
	
	foreach( grenade in linkedGrenades )
	{
		grenade launch( (RandomFloatRange( -5, 5 ),RandomFloatRange( -5, 5 ),5) );
	}
}

function ghost_visuals()
{
	foreach ( visual in self.visuals )
	{
		visual Ghost();
		visual thread unlink_grenades();
	}
}

function update_carry_object_origin()
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
		if ( isdefined( self.carrier ) && level.teamBased )
		{
			self.curOrigin = self.carrier.origin + (0,0,75);
		
			foreach ( team in level.teams )
			{
				self.objPoints[team] objpoints::update_origin( self.curOrigin );
			}
			
			if ( (self.visibleTeam == "friendly" || self.visibleTeam == "any") && self.objIDPingFriendly )
			{
				foreach ( team in level.teams )
				{
					if (  self is_friendly_team( team ) )
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
				if ( !self is_friendly_team( team ) )
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


			self util::wait_endon( objPingDelay, "dropped", "reset" );
		}
		else if( isdefined( self.carrier ) )
		{
			self.curOrigin = self.carrier.origin + (0,0,75);
			self.objPoints[level.nonTeamBasedTeam] objpoints::update_origin( self.curOrigin );
			objective_position( self.objID[level.nonTeamBasedTeam], self.curOrigin );

			{wait(.05);};
		}
		else
		{
			if ( level.teamBased )
			{
				foreach( team in level.teams )
				{
					self.objPoints[team] objpoints::update_origin( self.curOrigin + self.offset3d );
				}
			}
			else
			{
				self.objPoints[level.nonTeamBasedTeam] objpoints::update_origin( self.curOrigin + self.offset3d );
			}

			{wait(.05);};
		}
	}
}

function update_carry_object_objective_origin()
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
		if ( isdefined( self.carrier ) )
		{
			self.curOrigin = self.carrier.origin;
			objective_position( self.objectiveID, self.curOrigin );
			self util::wait_endon( objPingDelay, "dropped", "reset" );
		}
		else
		{
			objective_position( self.objectiveID, self.curOrigin );
			{wait(.05);};
		}
	}
}


/*
=============
give_object

Set player as holding this object
Should only be called from set_picked_up
=============
*/
function give_object( object )
{
	assert( !isdefined( self.carryObject ) );
	
	self.carryObject = object;
	self thread track_carrier(object);
		
	if ( IsDefined(object.carryWeapon) )
	{
		//object.carrierWeaponCurrent = self GetCurrentWeapon();
		//So we don't take the weapon if the player has it in their loadout.
		//object.carrierHasCarryWeaponInLoadout = self HasWeapon(object.carryWeapon);
		if ( isDefined(object.carryWeaponThink) )
		{
			self thread [[object.carryWeaponThink]]();
		}
		
		self GiveWeapon(object.carryWeapon);
		self SwitchToWeaponImmediate(object.carryWeapon);
		self setblockweaponpickup( object.carryWeapon, true );
		self DisableWeaponCycling();
	}
	else if ( !object.allowWeapons )
	{
		self util::_disableWeapon();
		self thread manual_drop_think();
	}

	self.disallowVehicleUsage = true;
	
	if ( isdefined( object.visibleCarrierModel ) )
	{
		self weapons::force_stowed_weapon_update();
	}

	if ( !object.newStyle )
	{
		if ( isdefined( object.carryIcon ) )
		{
			if ( self IsSplitscreen() )
			{
				self.carryIcon = hud::createIcon( object.carryIcon, 35, 35 );
				self.carryIcon.x = -130;
				self.carryIcon.y = -90;
				self.carryIcon.horzAlign = "right";
				self.carryIcon.vertAlign = "bottom";
			}
			else
			{
				self.carryIcon = hud::createIcon( object.carryIcon, 50, 50 );
				
				if ( !object.allowWeapons )
				{
					self.carryIcon hud::setPoint( "CENTER", "CENTER", 0, 60 );
				}
				else
				{
					self.carryIcon.x = 130;
					self.carryIcon.y = -60;
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

function move_visuals_to_base( )
{
	foreach( visual in self.visuals )
	{
		visual.origin = visual.baseOrigin;
		visual.angles = visual.baseAngles;
		visual DontInterpolate();
		visual show();
	}
}

/*
=============
return_home

Resets a carryObject to it's default home position
=============
*/
function return_home()
{
	self.isResetting = true;

	// trigger is more up to date then self.curOrigin
	prev_origin = self.trigger.origin;
	
	self notify ( "reset" );
	self move_visuals_to_base();
	self.trigger.origin = self.trigger.baseOrigin;
	
	self.curOrigin = self.trigger.origin;
	
	if ( isdefined( self.onReset ) )
	{
		self [[self.onReset]](prev_origin);
	}

	self clear_carrier();
	
	update_world_icons();
	update_compass_icons();
	update_objective();
	
	self.isResetting = false;
}


/*
=============
is_object_away_from_home
=============
*/
function is_object_away_from_home()
{
	if ( isdefined( self.carrier ) )
	{
		return true;
	}
		
	if ( distancesquared(self.trigger.origin,self.trigger.baseOrigin) > 4 )
	{
		return true;
	}
	
	return false;
}


/*
=============
set_position

set a carryObject to a new position
=============
*/
function set_position( origin, angles )
{
	self.isResetting = true;

	foreach( visual in self.visuals )
	{
		visual.origin = origin;
		visual.angles = angles;
		visual DontInterpolate();
		visual show();
	}
	self.trigger.origin = origin;
	
	self.curOrigin = self.trigger.origin;
	
	self clear_carrier();
	
	update_world_icons();
	update_compass_icons();
	update_objective();
	
	self.isResetting = false;
}

function set_drop_offset( height )
{
	self.dropOffset = height;
}

/*
=============
set_dropped

Sets this carry object as dropped and calculates dropped position
=============
*/
function set_dropped()
{
	if ( isdefined(self.setDropped) )
	{
		if ( [[self.setDropped]]() )
			return;
	}

	self.isResetting = true;
	
	self notify ( "dropped" );

	startOrigin = (0,0,0);
	endOrigin = (0,0,0);
	body = undefined;
	if ( isdefined( self.carrier ) && self.carrier.team != "spectator" )
	{
		startOrigin = self.carrier.origin + (0,0,20);
		endOrigin = self.carrier.origin - (0,0,2000);
		body = self.carrier.body;
	}
	else
	{
		if( isdefined( self.safeOrigin ) )
		{
			startOrigin = self.safeOrigin + (0,0,20);
			endOrigin = self.safeOrigin - (0,0,20);
		}
		else
		{
			startOrigin = self.curorigin + (0,0,20);
			endOrigin = self.curorigin - (0,0,20);
		}

	}
	trace = playerPhysicsTrace( startOrigin, endOrigin );
	angleTrace = bulletTrace( startOrigin, endOrigin, false, body );
	
	droppingPlayer = self.carrier;

	self clear_carrier();

	if ( isdefined( trace ) )
	{
		tempAngle = randomfloat( 360 );
		
		dropOrigin = trace + ( 0, 0, self.dropOffset );
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
		
		foreach( visual in self.visuals )
		{
			visual.origin = dropOrigin;
			visual.angles = dropAngles;
			visual DontInterpolate();
			visual show();
		}
		self.trigger.origin = dropOrigin;
		
		self.curOrigin = self.trigger.origin;

		self thread pickup_timeout( trace[2], startOrigin[2] );
	}
	else
	{
		self move_visuals_to_base();
		self.trigger.origin = self.trigger.baseOrigin;
		
		self.curOrigin = self.trigger.baseOrigin;
	}	
	
	if ( IsDefined( self.onDrop ) )
	{
		self [[self.onDrop]]( droppingPlayer );
	}
	
	self update_icons_and_objective();
	
	self.isResetting = false;
}

function update_icons_and_objective()
{
	self update_compass_icons();
	self update_world_icons();
	self update_objective();
}

function set_carrier( carrier )
{
	self.carrier = carrier;
	Objective_SetPlayerUsing( self.objectiveID, carrier );

	self thread update_visibility_according_to_radar();
}

/*
=============
get_carrier

Returns the carrier entity for this gameobject
=============
*/

// CP TODO - Added
function get_carrier()
{
	return( self.carrier );
}


function clear_carrier()
{
	if ( !isdefined( self.carrier ) )
	{
		return;
	}
	
	self.carrier take_object( self );
	Objective_ClearPlayerUsing( self.objectiveID, self.carrier );
	
	self.carrier = undefined;
	
	self notify("carrier_cleared");
}

function is_touching_any_trigger( triggers, minZ, maxZ )
{
	foreach( trigger in triggers )
	{
		if( self isTouchingSwept( trigger, minZ, maxZ ) )
			return true;
	}
	return false;
}

function is_touching_any_trigger_key_value( value, key, minZ, maxZ )
{
	return self is_touching_any_trigger( getEntArray( value, key ), minZ, maxZ ); 
}

function should_be_reset( minZ, maxZ, testHurtTriggers )
{
	if ( self.visuals[0] is_touching_any_trigger_key_value( "minefield", "targetname", minZ, maxZ ) )
		return true;
		
	if ( ( isdefined( testHurtTriggers ) && testHurtTriggers ) && self.visuals[0] is_touching_any_trigger_key_value( "trigger_hurt", "classname", minZ, maxZ ) )
		return true;
		
	if ( self.visuals[0] is_touching_any_trigger( level.oob_triggers, minZ, maxZ ) )
		return true;

	elevators = GetEntArray( "script_elevator", "targetname" );
	
	foreach( elevator in elevators )
	{
		assert( isdefined( elevator.occupy_volume ) );

		if ( self.visuals[0] isTouchingSwept( elevator.occupy_volume, minZ, maxZ ) )
			return true;
	}

	return false;
}


function pickup_timeout( minZ, maxZ )
{
	self endon ( "pickup_object" );
	self endon ( "reset" );
	
	{wait(.05);};
	
	if ( self should_be_reset( minZ, maxZ, true ) )
	{
		self thread return_home();
		return;
	}

	if ( isdefined( self.autoResetTime ) )
	{
		wait ( self.autoResetTime );

		if ( !isdefined( self.carrier ) )
		{
			self thread return_home();
		}
	}
}

/*
=============
take_object

Set player as dropping this object
=============
*/
function take_object( object )
{
	
	if ( isdefined( object.visibleCarrierModel ) )
	{
		self weapons::detach_all_weapons();
	}

	shouldEnableWeapon = true;
	if( isDefined(object.carryWeapon) && !IsDefined( self.player_disconnected ) )
	{
		shouldEnableWeapon = false;
		self thread wait_take_carry_weapon( object.carryWeapon );
	}
	
	if(object.type == "carryObject") 
	{
		if ( isdefined( self.carryIcon ) )
		{
			self.carryIcon hud::destroyElem();
		}		
		
		self.carryObject = undefined;
	}
	else if(object.type == "packObject")
	{
		if ( isdefined( self.packIcon ) && self.packIcon.size > 0 )
		{
			for( i = 0; i < self.packIcon.size; i++ )
			{
				if(IsDefined(self.packIcon[i].script_string))
				{
					if(self.packIcon[i].script_string == object.packIcon)
					{
						elem = self.packIcon[i];
						ArrayRemoveValue(self.packIcon, elem);
						elem hud::destroyElem();
						
						//adjust remaining icons
						self thread adjust_remaining_packIcons();
					}	
				}
			}
		}				
		
		ArrayRemoveValue(self.packObject, object);
	}	

	if ( !isAlive( self ) || IsDefined( self.player_disconnected ) )
	{
		return;
	}

	self notify ( "drop_object" );
	
	self.disallowVehicleUsage = false;

	if ( object.triggerType == "proximity" )
	{
		self thread pickup_object_delay( object.trigger.origin );
	}

	if ( isdefined( object.visibleCarrierModel ) )
	{
		self weapons::force_stowed_weapon_update();
	}
	
	if ( !object.allowWeapons && shouldEnableWeapon )
	{
		self util::_enableWeapon();
	}
}

function wait_take_carry_weapon( weapon )
{
	self thread take_carry_weapon_on_death( weapon );
	
	// Take some time away otherwise it tends to 'flash' before disappearing
	wait( Max( 0, weapon.fireTime - ( 2 * .05 ) ) );
	
	self take_carry_weapon( weapon );
}

function take_carry_weapon_on_death( weapon )
{
	self endon( "take_carry_weapon" );
	self waittill( "death" );
	
	self take_carry_weapon( weapon );
}

function take_carry_weapon( weapon )
{
	self notify( "take_carry_weapon" );
	
	if ( self HasWeapon( weapon, true ) )
	{
		self setblockweaponpickup( weapon, false );
		self TakeWeapon( weapon );
		self EnableWeaponCycling();
	}
}

/*
=============
track_carrier

Calculates and updates a safe drop origin for a carry object based on the current carriers position
=============
*/
function track_carrier(object)
{
	level endon ( "game_ended" );
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	{wait(.05);}; // wait a frame so the carrier gets set
	
	while ( (isdefined( object.carrier ) && object.carrier == self) && isAlive( self ) )
	{
		if ( self isOnGround() )
		{
			trace = bulletTrace( self.origin + (0,0,20), self.origin - (0,0,20), false, undefined );
			if ( trace["fraction"] < 1 ) // if there is ground at the player's origin (not necessarily true just because of isOnGround)
			{
				object.safeOrigin = trace["position"];
			}
		}
		{wait(.05);};
	}
}


/*
=============
manual_drop_think

Allows the player to manually drop this object by pressing the fire button
Does not allow drop if the use button is pressed
=============
*/
function manual_drop_think()
{
	level endon ( "game_ended" );

	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "drop_object" );
	
	for( ;; )
	{
		while ( self attackButtonPressed() || self fragButtonPressed() || self secondaryOffhandButtonPressed() || self meleeButtonPressed() )
		{
			wait .05;
		}
	
		while ( !self attackButtonPressed() && !self fragButtonPressed() && !self secondaryOffhandButtonPressed() && !self meleeButtonPressed() )
		{
			wait .05;
		}
	
		if ( isdefined( self.carryObject ) && !self useButtonPressed() )
		{
			self.carryObject thread set_dropped();
		}
	}
}


/*
=============
create_use_object

Creates and returns a use object
In FFA gametypes, ownerTeam should be the player who owns the object
=============
*/
function create_use_object( ownerTeam, trigger, visuals, offset, objectiveName )
{
	useObject = Spawn( "script_model", trigger.origin );
	useObject.type = "useObject";
	useObject.curOrigin = trigger.origin;
	useObject.entNum = trigger getEntityNumber();
	useObject.keyObject = undefined;
	
	if ( isSubStr( trigger.classname, "use" ) )
	{
		useObject.triggerType = "use";
	}
	else
	{
		useObject.triggerType = "proximity";
	}
		
	// associated trigger
	useObject.trigger = trigger;
	useObject LinkTo( trigger );
	
	// associated visual object
	for ( index = 0; index < visuals.size; index++ )
	{
		visuals[index].baseOrigin = visuals[index].origin;
		visuals[index].baseAngles = visuals[index].angles;
	}
	useObject.visuals = visuals;
	
	useObject _set_team( ownerTeam );
	
	if ( !isdefined( offset ) )
	{
		offset = (0,0,0);
	}

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
				useObject.objID[team] = get_next_obj_id();
			}
			
			if ( level.teamBased )
			{
				foreach( team in level.teams )
				{
					if( SessionModeIsCampaignGame() ) 
					{
						objective_add( useObject.objID[ "allies" ], "active", useObject.curOrigin, objectiveName );
						break;
					}
					else
					{
						objective_add( useObject.objID[team], "invisible", useObject.curOrigin, objectiveName );
					}
					
					objective_team( useObject.objID[team], team );
				}
			}
			else
			{
				objective_add( useObject.objID[level.nonTeamBasedTeam], "invisible", useObject.curOrigin, objectiveName );
			}
		}
	}

	useObject.objectiveID = get_next_obj_id();
	
	// new style objective
	if ( useObject.newStyle )
	{
		if( SessionModeIsCampaignGame() ) 
		{
			objective_add( useObject.objectiveID, "invisible", useObject, objectiveName );
		}
		else
		{
			objective_add( useObject.objectiveID, "invisible", useObject.curOrigin + offset, objectiveName );
		}
	}

	if ( !useObject.newStyle )
	{
		if ( level.teamBased )
		{
			foreach( team in level.teams )
			{
				useObject.objPoints[team] = objpoints::create( "objpoint_" + team + "_" + useObject.entNum, useObject.curOrigin + offset, team, undefined );
				useObject.objPoints[team].alpha = 0;
			}
		}
		else
		{
			useObject.objPoints[level.nonTeamBasedTeam] = objpoints::create( "objpoint_allies_" + useObject.entNum, useObject.curOrigin + offset, "all", undefined );
			useObject.objPoints[level.nonTeamBasedTeam].alpha = 0;
		}
	}

	// misc
	useObject.interactTeam = "none"; // "none", "any", "friendly", "enemy";
	
	// 3d world icons
	useObject.worldIcons = [];
	useObject.visibleTeam = "none"; // "none", "any", "friendly", "enemy";
	useObject.worldIsWaypoint = [];

	useObject.worldIcons_disabled = [];

	// calbacks
	useObject.onUse = undefined;
	useObject.onCantUse = undefined;

	useObject.useText = "default";
	useObject.useTime = 10000;
	useObject clear_progress();

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
		
		useObject.teamUseTimes = [];
		useObject.teamUseTexts = [];

		useObject.useRate = 0;
		useObject.claimTeam = "none";
		useObject.claimPlayer = undefined;
		useObject.lastClaimTeam = "none";
		useObject.lastClaimTime = 0;
		useObject.claimGracePeriod = 1.0;
		useObject.mustMaintainClaim = false;	
		useObject.canContestClaim = false;
	
		useObject thread use_object_prox_think();
	}
	else
	{
		useObject.useRate = 1;
		useObject thread use_object_use_think();
	}
	
	return useObject;
}


/*
=============
set_key_object

function Sets this use object to require carry object(s)
=============
*/
function set_key_object( object )
{
	if ( !isdefined( object ) )
	{
		self.keyObject = undefined;
		
		return;
	}
	
	if ( !isdefined( self.keyObject ) )
	{
		self.keyObject = [];
	}
	
	self.keyObject[ self.keyObject.size ] = object;
}


/*
=============
has_key_object

function Checks if player is carrying key object(s)
=============
*/
function has_key_object( use )
{
	if(!isdefined( use.keyObject ) )
	{
		return false;
	}
	
	for ( x = 0; x < use.keyObject.size; x++ )
	{
		if ( isdefined( self.carryObject ) && ( self.carryObject == use.keyObject[ x ] ) )
		{
			return true;
		}
		else if( isdefined(self.packObject) )
		{
			for ( i = 0; i < self.packObject.size; i++ )
			{
				if(self.packObject[i] == use.keyObject[x] )
				{
					return true;
				}	 				
			}	
		}	
	}
	
	return false;
}


/*
=============
use_object_use_think

Think function for "use" type carry objects
=============
*/
function use_object_use_think()
{
	level endon ( "game_ended" );
	self.trigger endon( "destroyed" );
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		if ( !isAlive( player ) )
		{
			continue;
		}
			
		if ( !self can_interact_with( player ) )
		{
			continue;
		}
		
		if ( IsDefined( self.canInteractWithPlayer ) && ![[self.canInteractWithPlayer]]( player )  )
		{
			continue;
		}
		
		if ( !player isOnGround() )
		{
			continue;
		}
		
		if ( player isInVehicle() )
		{
			continue;
		}
		
		if ( isdefined( self.keyObject ) && !player has_key_object( self ) )
		{
			if ( isdefined( self.onCantUse ) )
			{
				self [[self.onCantUse]]( player );
			}
			continue;
		}

		result = true;
		if ( self.useTime > 0 )
		{
			if ( isdefined( self.onBeginUse ) )
			{
				if( isdefined( self.classObj ) )
				{
					[[self.classObj]]->onBeginUse( player );
				}
				else
				{
					self [[self.onBeginUse]]( player );
				}
			}

			team = player.pers["team"];

			result = self use_hold_think( player );
			
			if ( isdefined( self.onEndUse ) )
			{
				self [[self.onEndUse]]( team, player, result );
			}
		}

		if ( !( isdefined( result ) && result ) )
		{
			continue;
		}
		
		if ( isdefined( self.onUse ) )
		{
			if( ( isdefined( self.onUse_thread ) && self.onUse_thread ) )
			{
				//used in co-op situations when we need simultaneous interaction
				//with the use object.  Example: mobile armory
				self thread use_object_OnUse( player );
			}
			else
			{
				self use_object_OnUse( player );
			}
		}
	}
}

function use_object_onUse( player )
{
	level endon( "game_ended" );
	self.trigger endon( "destroyed" );

	if( isdefined( self.classObj ) )
	{
		[[self.classObj]]->onUse( player );
	}
	else
	{
		self [[self.onUse]]( player );
	}
}


function get_earliest_claim_player()
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
use_object_prox_think

Think function for "proximity" type carry objects
=============
*/
function use_object_prox_think()
{
	level endon ( "game_ended" );
	self.trigger endon( "destroyed" );
	
	self thread prox_trigger_think();
	
	while ( true )
	{
		if ( self.useTime && self.curProgress >= self.useTime )
		{			
			self clear_progress();
			
			creditPlayer = get_earliest_claim_player();

			if ( isdefined( self.onEndUse ) )
			{
				self [[self.onEndUse]]( self get_claim_team(), creditPlayer, isdefined( creditPlayer ) );
			}
			
			if ( isdefined( creditPlayer ) && isdefined( self.onUse ) )
			{
				self [[self.onUse]]( creditPlayer );
			}
		
			if ( !self.mustMaintainClaim )
			{
				self set_claim_team( "none" );
				self.claimPlayer = undefined;
			}
		}
		
		if ( self.claimTeam != "none" )
		{
			if ( self use_object_locked_for_team( self.claimTeam ) )
			{
				if ( isdefined( self.onEndUse ) )
				{
					self [[self.onEndUse]]( self get_claim_team(), self.claimPlayer, false );
				}
				
				self set_claim_team( "none" );
				self.claimPlayer = undefined;
				self clear_progress();
			}
			else
			{
				if ( self.useTime &&
				    ( !self.mustMaintainClaim || ( self get_owner_team() != self get_claim_team() ) ) )
				{
					if ( self.decayProgress && !self.numTouching[self.claimTeam] )
					{
						if ( isdefined( self.claimPlayer ) )
						{
							if ( isdefined( self.onEndUse ) )
							{
								self [[self.onEndUse]]( self get_claim_team(), self.claimPlayer, false );
							}
							
							self.claimPlayer = undefined;
						}

						decayScale = 0;
						if ( self.decayTime )
						{
							decayScale = self.useTime / self.decayTime;
						}
						
						self.curProgress -= (50 * self.useRate * decayScale);
						if ( self.curProgress <= 0 )
						{
							self clear_progress();
						}
					
						self update_current_progress();

						if ( isdefined( self.onUseUpdate ) )
						{
							self [[self.onUseUpdate]]( self get_claim_team(), self.curProgress / self.useTime, (50*self.useRate*decayScale) / self.useTime );
						}

						if ( self.curProgress == 0 )
						{
							self set_claim_team( "none" );
						}
					}
					else if ( !self.numTouching[self.claimTeam] )
					{
						if ( isdefined( self.onEndUse ) )
						{
							self [[self.onEndUse]]( self get_claim_team(), self.claimPlayer, false );
						}
						
						self set_claim_team( "none" );
						self.claimPlayer = undefined;
					}
					else
					{
						self.curProgress += (50 * self.useRate);
						self update_current_progress();
						if ( isdefined( self.onUseUpdate ) )
						{
							self [[self.onUseUpdate]]( self get_claim_team(), self.curProgress / self.useTime, (50*self.useRate) / self.useTime );
						}
					}
				}
				else if ( !self.mustMaintainClaim )
				{
					if ( isdefined( self.onUse ) )
					{
						self [[self.onUse]]( self.claimPlayer );
					}
					
					// onUse may toggle on mustMaintainClaim
					if ( !self.mustMaintainClaim )
					{
						self set_claim_team( "none" );
						self.claimPlayer = undefined;	
					}
				}
				else if ( !self.numTouching[self.claimTeam] )
				{
					if ( isdefined( self.onUnoccupied ) )
					{
						self [[self.onUnoccupied]]();
					}
	
					self set_claim_team( "none" );
					self.claimPlayer = undefined;	
				}
				else if ( self.canContestClaim )
				{
					numOther = get_num_touching_except_team( self.claimTeam );

					if ( numOther > 0 )
					{
						if ( isdefined( self.onContested ) )
						{
							self [[self.onContested]]();
						}
		
						self set_claim_team( "none" );
						self.claimPlayer = undefined;	
					}
				}
			}

		}
		else
		{
			if ( self.curProgress > 0 && getTime() - self.lastClaimTime > ( self.claimGracePeriod * 1000 ) )
			{
				self clear_progress();
			}
			
			if ( self.mustMaintainClaim && ( self get_owner_team() != "none" ) )
			{
				if ( !self.numTouching[self get_owner_team()] )
				{
					if ( isdefined( self.onUnoccupied ) )
					{
						self [[self.onUnoccupied]]();
					}
				}
				else if ( self.canContestClaim && self.lastClaimTeam != "none" && self.numTouching[self.lastClaimTeam] )
				{
					numOther = get_num_touching_except_team( self.lastClaimTeam );

					if ( numOther == 0 )
					{
						if ( isdefined( self.onUncontested ) )
						{
							self [[self.onUncontested]](self.lastClaimTeam);
						}
					}
				}
			}
		}

		{wait(.05);};
		hostmigration::waitTillHostMigrationDone();
	}
}


/*
=============
use_object_locked_for_team

Verify that a team is not locked from using an object
=============
*/
function use_object_locked_for_team( team )
{
	if ( isdefined( self.teamLock ) && isdefined( level.teams[team] ) )
	{
		return self.teamLock[team];
	}

	return false;
}

/*
=============
can_claim

Determine if the player can claim 
=============
*/
function can_claim( player )
{
	if ( isdefined( self.carrier ) )
	{
		return false;
	}
	
	if ( self.canContestClaim )
	{
		numOther = get_num_touching_except_team( player.pers["team"] );
		
		if ( numOther != 0 )
		{
			return false;
		}
	}
	
	if ( !isdefined( self.keyObject ) ||  player has_key_object( self ) )
	{
		return true;
	}
	
	return false;
}

/*
=============
function prox_trigger_think ("proximity" only)

Handles setting the current claiming team and player, as well as starting threads to track players touching the trigger
=============
*/
function prox_trigger_think()
{
	level endon ( "game_ended" );
	self.trigger endon( "destroyed" );
	
	entityNumber = self.entNum;
	
	while ( true )
	{
		self.trigger waittill ( "trigger", player );
		
		// TODO: Notify the player if they are attempting to capture a locked flag
		if ( !isAlive( player ) || self use_object_locked_for_team( player.pers["team"] ) )
		{
			continue;
		}
		
		if ( ( isdefined( player.laststand ) && player.laststand ))
		{
			continue;
	    }
		
		if ( player.spawntime == GetTime() )	// It's possible to get the "trigger" notify from the origin of the beginning of this frame when the player was dead
		{
			continue;						 	// and then have the player spawn in, changing origins later this frame and this will no longer be valid.
		}
		
//		if ( player isInVehicle() )
//		{
//			continue;
//		}
		
		if ( player isRemoteControlling() || player util::isUsingRemote() )
		{
			continue;
		}
		
		if ( ( isdefined( player.selectingLocation ) && player.selectingLocation ) )
		{
			continue;
		}

		if ( player IsWeaponViewOnlyLinked() )
		{
			continue;
		}
			
		if ( self is_excluded( player ) )
		{
			continue;
		}
		
		if( IsDefined(self.canUseObject) && ![[self.canUseObject]](player) )
		{
			continue;
		}
			
		if ( self can_interact_with( player ) && self.claimTeam == "none" )
		{
			if ( self can_claim( player ) )
			{
				set_claim_team( player.pers["team"] );
				self.claimPlayer = player;
				
				relativeTeam = self get_relative_team( player.pers["team"] );
				if ( isdefined( self.teamUseTimes[relativeTeam] ) )
				{
					self.useTime = self.teamUseTimes[relativeTeam];
					// TODO we don't store the base self.useTime setting... we should.
				}

				if ( self.useTime && isdefined( self.onBeginUse ) )
				{
					self [[self.onBeginUse]]( self.claimPlayer );
				}
			}
			else
			{
				if ( isdefined( self.onCantUse ) )
				{
					self [[self.onCantUse]]( player );
				}
			}
		}
			
		if ( isAlive( player ) && !isdefined( player.touchTriggers[entityNumber] ) )
		{
			player thread trigger_touch_think( self );
		}
	}
}

function is_excluded( player )
{
	if ( !isdefined( self.exclusions ) )
	{
		return false;
	}
		
	foreach( exclusion in self.exclusions ) 
	{
		if ( exclusion istouching( player ) )
		{
			return true;
		}
	}
	
	return false;
}

function clear_progress()
{
	self.curProgress = 0;
	
	self update_current_progress();
	
	if ( isdefined( self.onUseClear ) )
	{
		self [[self.onUseClear]]( );
	}
}

/*
=============
function set_claim_team ("proximity" only)

Sets this object as claimed by specified team including grace period to prevent 
object reset when claiming team leave trigger for short periods of time
=============
*/
function set_claim_team( newTeam )
{
	assert( newTeam != self.claimTeam );
	
	if ( self.claimTeam == "none" && getTime() - self.lastClaimTime > ( self.claimGracePeriod * 1000 ) )
	{
		self clear_progress();
	}
	else if ( newTeam != "none" && newTeam != self.lastClaimTeam )
	{
		self clear_progress();
	}

	self.lastClaimTeam = self.claimTeam;
	self.lastClaimTime = getTime();
	self.claimTeam = newTeam;
	
	self update_use_rate();
}


function get_claim_team()
{
	return self.claimTeam;
}

function continue_trigger_touch_think(team,object) // self == player
{
	if ( !isAlive( self ) )
	{
		return false;
	}
		
	if ( self use_object_locked_for_team( team ) )
	{
	  return false;
	}
	 
//	if ( self isinvehicle() )
//	{
//		return false;
//	}
	
	if ( ( isdefined( self.laststand ) && self.laststand ))
	{
		return false;
	}
		
	if ( !self isTouching( object.trigger ) )
	{
	  return false;
	}
	  
	return true;
}

/*
=============
function trigger_touch_think ("proximity" only)

Updates use object while player is touching the trigger and updates the players visual use bar
=============
*/
function trigger_touch_think( object )
{
	team = self.pers["team"];

	score = 1;

	object.numTouching[team] = object.numTouching[team] + score;

	if ( object.useTime )
	{
		object update_use_rate();
	}

	touchName = "player" + self.clientid;
	struct = spawnstruct();
	struct.player = self;
	struct.starttime = gettime();
	object.touchList[team][touchName] = struct;
	Objective_SetPlayerUsing( object.objectiveID, self );
	
	self.touchTriggers[object.entNum] = object.trigger;

	if ( isdefined( object.onTouchUse ) )
	{
		object [[object.onTouchUse]]( self );
	}

	while ( self continue_trigger_touch_think(team,object) )
	{
		if ( object.useTime )
		{
			self update_prox_bar( object, false );
		}
		{wait(.05);};
	}

	// disconnected player will skip this code
	if ( isdefined( self ) )
	{
		if ( object.useTime )
		{
			self update_prox_bar( object, true );
		}
		self.touchTriggers[object.entNum] = undefined;
		Objective_ClearPlayerUsing( object.objectiveID, self );
	}
	
	if ( level.gameEnded )
	{
		return;
	}
	
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
			object update_current_progress();
		}
	}
	
	if ( isdefined( self ) && isdefined( object.onEndTouchUse ) )
	{
		object [[object.onEndTouchUse]]( self );
	}

	object update_use_rate();
}


/*
=============
function update_prox_bar ("proximity" only)

Updates drawing of the players use bar when using a use object
=============
*/
function update_prox_bar( object, forceRemove )
{
	if ( object.newStyle )
	{
		return;
	}
		
	if ( !forceRemove && object.decayProgress )
	{
		if ( !object can_interact_with( self ) )
		{
			if ( isdefined( self.proxBar ) )
			{
				self.proxBar hud::hideElem();
			}

			if ( isdefined( self.proxBarText ) )
			{
				self.proxBarText hud::hideElem();
			}
			return;
		}
		else
		{
			if ( !isdefined( self.proxBar ) )
			{
				self.proxBar = hud::createPrimaryProgressBar();
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
	else if ( forceRemove || !object can_interact_with( self ) || self.pers["team"] != object.claimTeam )
	{
		if ( isdefined( self.proxBar ) )
		{
			self.proxBar hud::hideElem();
		}

		if ( isdefined( self.proxBarText ) )
		{
			self.proxBarText hud::hideElem();
		}
		return;
	}
	
	if ( !isdefined( self.proxBar ) )
	{
		self.proxBar = hud::createPrimaryProgressBar();
		self.proxBar.lastUseRate = -1;
		self.proxBar.lastHostMigrationState = false;
	}
	
	if ( self.proxBar.hidden )
	{
		self.proxBar hud::showElem();
		self.proxBar.lastUseRate = -1;
		self.proxBar.lastHostMigrationState = false;
	}

	if ( !isdefined( self.proxBarText ) )
	{
		self.proxBarText = hud::createPrimaryProgressBarText();
		self.proxBarText setText( object.useText );
	}
	
	if ( self.proxBarText.hidden )
	{
		self.proxBarText hud::showElem();
		self.proxBarText setText( object.useText );
	}
	
	if ( self.proxBar.lastUseRate != object.useRate || self.proxBar.lastHostMigrationState != isdefined( level.hostMigrationTimer ) )
	{
		if( object.curProgress > object.useTime)
		{
			object.curProgress = object.useTime;
		}
				
		if ( object.decayProgress && self.pers["team"] != object.claimTeam )
		{
			if ( object.curProgress > 0 )
			{
				progress = object.curProgress / object.useTime;
				rate =  (1000 / object.useTime) * ( object.useRate * -1 );
				if ( isdefined( level.hostMigrationTimer ) )
				{
					rate = 0;
				}
				self.proxBar hud::updateBar( progress, rate );
			}
		}
		else
		{
			progress = object.curProgress / object.useTime;
			rate = (1000 / object.useTime) * object.useRate;
			if ( isdefined( level.hostMigrationTimer ) )
			{
				rate = 0;
			}
			self.proxBar hud::updateBar( progress, rate );
		}
		self.proxBar.lastHostMigrationState = isdefined( level.hostMigrationTimer );
		self.proxBar.lastUseRate = object.useRate;
	}
}

function get_num_touching_except_team( ignoreTeam )
{
	numTouching = 0;
	foreach( team in level.teams )
	{
		if ( ignoreTeam == team )
		{
			continue;
		}
		numTouching += self.numTouching[team];
	}
	
	return numTouching;
}

/*
=============
function update_use_rate ("proximity" only)

Handles the rate a which a use objects progress bar is filled based on the number of players touching the trigger
Stops updating if an enemy is touching the trigger
=============
*/
function update_use_rate()
{
	numClaimants = self.numTouching[self.claimTeam];
	numOther = 0;
	
	numOther = get_num_touching_except_team( self.claimTeam );

	self.useRate = 0;

	if ( self.decayProgress )
	{
		if ( numClaimants && !numOther )
		{
			self.useRate = numClaimants;
		}
		else if ( !numClaimants && numOther )
		{
			self.useRate = numOther;
		}
		else if ( !numClaimants && !numOther )
		{
			self.useRate = 0;
		}
	}
	else
	{
		if ( numClaimants && !numOther )
		{
			self.useRate = numClaimants;
		}
	}

	if ( isdefined( self.onUpdateUseRate ) )
	{
		self [[self.onUpdateUseRate]]( );
	}
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
use_hold_think

Claims the use trigger for player and displays a use bar
Returns true if the player sucessfully fills the use bar
=============
*/
function use_hold_think( player )
{
	player notify ( "use_hold" );
	
	if ( !( isdefined( self.dontLinkPlayerToTrigger ) && self.dontLinkPlayerToTrigger ) )
	{
		if(!SessionModeIsMultiplayerGame()) //allow 3d person rotation for linked player since the trigger doesn't get sent to client, ToDo: make this an option
		{
			gameobject_link = util::spawn_model( "tag_origin", player.origin, player.angles );
	    	player PlayerLinkTo( gameobject_link);
		}
		else
		{
			player playerLinkTo( self.trigger );
			player PlayerLinkedOffsetEnable();
		}
	}
	
	player clientClaimTrigger( self.trigger );
	player.claimTrigger = self.trigger;

	useWeapon = self.useWeapon;
	
	if ( isdefined( useWeapon ) )
	{
		player giveWeapon( useWeapon );
		player setWeaponAmmoStock( useWeapon, 0 );
		player setWeaponAmmoClip( useWeapon, 0 );
		player switchToWeapon( useWeapon );
	}
	else if ( self.keepWeapon !== true )
	{
		player util::_disableWeapon();
	}
	
	self clear_progress();
	self.inUse = true;
	self.useRate = 0;
	Objective_SetPlayerUsing( self.objectiveID, player );
	player thread personal_use_bar( self );
	
	result = use_hold_think_loop( player );
	
	self.inUse = false;
	
	if ( isdefined( player ) )
	{
		Objective_ClearPlayerUsing( self.objectiveID, player );
		self clear_progress();
		if ( isdefined( player.attachedUseModel ) )
		{
			player detach( player.attachedUseModel, "tag_inhand" );
			player.attachedUseModel = undefined;
		}
		
		player notify( "done_using" );
		
		if ( isdefined( useWeapon ) )
		{
			player thread take_use_weapon( useWeapon );
		}
		
		player.claimTrigger = undefined;
		player clientReleaseTrigger( self.trigger );
		
		if ( isdefined( useWeapon ) )
		{
			player killstreaks::switch_to_last_non_killstreak_weapon();
		}
		else if ( self.keepWeapon !== true )
		{
			player util::_enableWeapon();
		}

		if ( !( isdefined( self.dontLinkPlayerToTrigger ) && self.dontLinkPlayerToTrigger ) )
		{
			player unlink();
		}
		
		if ( !isAlive( player ) )
		{
			player.killedInUse = true;
		}		
	}	
	
	if(isdefined(gameobject_link))
	{
		gameobject_link Delete();
	}

	return result;
}


function take_use_weapon( useWeapon )
{
	self endon( "use_hold" );
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while ( self getCurrentWeapon() == useWeapon && !self.throwingGrenade )
		{wait(.05);};
		
	self takeWeapon( useWeapon );
}

function continue_hold_think_loop(player, waitForWeapon, timedOut, useTime)
{
	maxWaitTime = 1.5; // must be greater than the putaway timer for all weapons

	if (!IsAlive(player))
	{
		return false;
	}

	if ( isdefined( player.laststand ) && player.laststand )
	{
		return false;
	}
		
	if ( self.curProgress >= useTime )
	{
		return false;
	}
	
	if ( !(player useButtonPressed()) )
	{
		return false;
	}
		
	if (player.throwingGrenade)
	{
		return false;
	}
	
	if ( player meleeButtonPressed() )
	{
		return false;
	}
	
	if ( player isinvehicle() )
	{
		return false;
	}

	if ( player isRemoteControlling() || player util::isUsingRemote() )
	{
		return false;
	}
	
	if ( ( isdefined( player.selectingLocation ) && player.selectingLocation ) )
	{
		return false;
	}	
	
	if ( player IsWeaponViewOnlyLinked() )
	{
		return false;
	}

	if ( !(player isTouching( self.trigger ) ) )
	{
		return false;
	}
		
	if ( !self.useRate && !waitForWeapon )
	{
		return false;
	}
	
	if (waitForWeapon && timedOut > maxWaitTime)
	{
		return false;
	}
	
	if ( ( isdefined( self.interrupted ) && self.interrupted ) )
	{
		return false;
	}
		
	return true;
}

function update_current_progress()
{
	if ( self.useTime )
	{
		if ( isdefined( self.curProgress ) )
		{
			progress = float(self.curProgress) / self.useTime;
		}
		else
		{
			progress = 0;
		}

		Objective_SetProgress( self.objectiveID, math::clamp(progress,0,1) );
	}
}

function use_hold_think_loop( player )
{
	level endon ( "game_ended" );
	self endon("disabled");
	
	useWeapon = self.useWeapon;
	waitForWeapon = true;
	timedOut = 0;
	
	useTime = self.useTime;

	while( self continue_hold_think_loop( player, waitForWeapon, timedOut, useTime ) )
	{
		timedOut += 0.05;

		if ( !isdefined( useWeapon ) || player getCurrentWeapon() == useWeapon )
		{
			self.curProgress += (50 * self.useRate);
			self update_current_progress();
			self.useRate = 1;
			waitForWeapon = false;
		}
		else
		{
			self.useRate = 0;
		}

		if ( self.curProgress >= useTime )
		{			
			return true;
		}
		
		{wait(.05);};
		hostmigration::waitTillHostMigrationDone();
	}
	
	return false;
}

/*
=============
personal_use_bar

Displays and updates a players use bar
=============
*/
function personal_use_bar( object )
{
	self endon("disconnect");
	
	if ( object.newStyle )
	{
		return;
	}

	if( isdefined( self.useBar ) )
	{
		return;
	}
	
	self.useBar = hud::createPrimaryProgressBar();
	self.useBarText = hud::createPrimaryProgressBarText();
	self.useBarText setText( object.useText );

	useTime = object.useTime;

	lastRate = -1;
	lastHostMigrationState = isdefined( level.hostMigrationTimer );
	while ( isAlive( self ) && object.inUse && !level.gameEnded )
	{
		if ( lastRate != object.useRate || lastHostMigrationState != isdefined( level.hostMigrationTimer ) )
		{
			if( object.curProgress > useTime)
			{
				object.curProgress = useTime;
			}

			if ( object.decayProgress && self.pers["team"] != object.claimTeam )
			{
				if ( object.curProgress > 0 )
				{
					progress = object.curProgress / useTime;
					rate = (1000 / useTime) * ( object.useRate * -1 );
					if ( isdefined( level.hostMigrationTimer ) )
					{
						rate = 0;
					}
					self.proxBar hud::updateBar( progress, rate );
				}
			}
			else
			{
				progress = object.curProgress / useTime;
				rate = (1000 / useTime) * object.useRate;
				if ( isdefined( level.hostMigrationTimer ) )
				{
					rate = 0;
				}
				self.useBar hud::updateBar( progress, rate );
			}

			if ( !object.useRate )
			{
				self.useBar hud::hideElem();
				self.useBarText hud::hideElem();
			}
			else
			{
				self.useBar hud::showElem();
				self.useBarText hud::showElem();
			}
		}	
		lastRate = object.useRate;
		lastHostMigrationState = isdefined( level.hostMigrationTimer );
		{wait(.05);};
	}
	
	self.useBar hud::destroyElem();
	self.useBarText hud::destroyElem();
}


/*
=============
update_trigger

Displays and updates a players use bar
=============
*/
function update_trigger()
{
	if ( self.triggerType != "use" )
	{
		return;
	}
	
	if ( self.interactTeam == "none" )
	{
		self.trigger TriggerEnable( false );
	}	
	else if ( ( self.interactTeam == "any" ) || !level.teamBased )
	{
		self.trigger TriggerEnable( true );
		self.trigger setTeamForTrigger( "none" );
	}
	else if ( self.interactTeam == "friendly" )
	{
		self.trigger TriggerEnable( true );
		if ( isdefined( level.teams[self.ownerTeam] ) )
		{
			self.trigger setTeamForTrigger( self.ownerTeam );
		}
		else
		{
			self.trigger TriggerEnable( false );
		}
	}
	else if ( self.interactTeam == "enemy" )
	{
		self.trigger TriggerEnable( true );
		self.trigger SetExcludeTeamForTrigger( self.ownerTeam );
	}
}

function update_objective()
{
	if ( !self.newStyle )
	{
		return;
	}
	
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
	
	if ( (self.type == "carryObject") || (self.type == "packObject"))
	{
		if ( isAlive( self.carrier ) )
		{
			objective_onentity( self.objectiveID, self.carrier );
		}
		else if ( IsDefined(self.objectiveOnVisuals) && self.objectiveOnVisuals )
		{
			objective_onentity( self.objectiveID, self.visuals[0] );
		}
		else
		{
			objective_clearentity( self.objectiveID );
		}
	}
}

function update_world_icons()
{
	if ( self.visibleTeam == "any" )
	{
		update_world_icon( "friendly", true );
		update_world_icon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		update_world_icon( "friendly", true );
		update_world_icon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		update_world_icon( "friendly", false );
		update_world_icon( "enemy", true );
	}
	else
	{
		update_world_icon( "friendly", false );
		update_world_icon( "enemy", false );
	}
}


function update_world_icon( relativeTeam, showIcon )
{	
	if ( self.newStyle )
	{
		return;
	}
		
	if ( !isdefined( self.worldIcons[relativeTeam] ) )
	{
		showIcon = false;
	}
	
	updateTeams = get_update_teams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		if ( !level.teamBased && updateTeams[index] != level.nonTeamBasedTeam )
		{
			continue;
		}
		opName = "objpoint_" + updateTeams[index] + "_" + self.entNum;
		objPoint = objpoints::get_by_name( opName );
		
		objPoint notify( "stop_flashing_thread" );
		objPoint thread objpoints::stop_flashing();
		
		if ( showIcon )
		{
			objPoint setShader( self.worldIcons[relativeTeam], level.objPointSize, level.objPointSize );
			objPoint fadeOverTime( 0.05 ); // overrides old fadeOverTime setting from flashing thread
			objPoint.alpha = objPoint.baseAlpha;
			objPoint.isShown = true;

			isWaypoint = true;
			if ( isdefined(self.worldIsWaypoint[relativeTeam]) )
			{
				isWaypoint = self.worldIsWaypoint[relativeTeam];
			}
				
			if ( isdefined( self.compassIcons[relativeTeam] ) )
			{
				objPoint setWayPoint( isWaypoint, self.worldIcons[relativeTeam] );
			}
			else
			{
				objPoint setWayPoint( isWaypoint );
			}
				
			if ( (self.type == "carryObject") || (self.type == "packObject"))
			{
				if ( isdefined( self.carrier ) && !should_ping_object( relativeTeam ) )
				{
					objPoint SetTargetEnt( self.carrier );
				}
				else
				{
					objPoint ClearTargetEnt();
				}
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


function update_compass_icons()
{
	if ( self.visibleTeam == "any" )
	{
		update_compass_icon( "friendly", true );
		update_compass_icon( "enemy", true );
	}
	else if ( self.visibleTeam == "friendly" )
	{
		update_compass_icon( "friendly", true );
		update_compass_icon( "enemy", false );
	}
	else if ( self.visibleTeam == "enemy" )
	{
		update_compass_icon( "friendly", false );
		update_compass_icon( "enemy", true );
	}
	else
	{
		update_compass_icon( "friendly", false );
		update_compass_icon( "enemy", false );
	}
}


function update_compass_icon( relativeTeam, showIcon )
{	
	if ( self.newStyle )
	{
		return;
	}

	updateTeams = get_update_teams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		showIconThisTeam = showIcon;
		if ( !showIconThisTeam && should_show_compass_due_to_radar( updateTeams[ index ] ) )
		{
			showIconThisTeam = true;
		}
		
		if ( level.teamBased )
		{
			objId = self.objID[updateTeams[ index ]];
		}
		else
		{
			objId = self.objID[level.nonTeamBasedTeam];
		}
				
		if ( !isdefined( self.compassIcons[relativeTeam] ) || !showIconThisTeam )
		{
			if( !SessionModeIsCampaignGame() )
			{
				objective_state( objId, "invisible" );
			}
			
			continue;
		}

		objective_icon( objId, self.compassIcons[relativeTeam] );
		
		if( !SessionModeIsCampaignGame() )
		{
			objective_state( objId, "active" );
		}
		
		if ( (self.type == "carryObject") || (self.type == "packObject"))
		{
			if ( isAlive( self.carrier ) && !should_ping_object( relativeTeam ) )
			{
				objective_onentity( objId, self.carrier );
			}
			else
			{
				if( !SessionModeIsCampaignGame() )
				{
					objective_clearentity( objId );
				}
				
				objective_position( objId, self.curOrigin );
			}
		}
	}
}

function hide_waypoint( e_player )
{
	if ( isdefined( e_player ) )
	{
		Assert( IsPlayer( e_player ), "Passed a non-player entity into gameobjects::hide_waypoint()" );
		
		Objective_SetInvisibleToPlayer( self.objectiveid, e_player );
	}
	else
	{
		Objective_SetInvisibleToAll( self.objectiveid );
	}
}

function show_waypoint( e_player )
{
	if ( isdefined( e_player ) )
	{
		Assert( IsPlayer( e_player ), "Passed a non-player entity into gameobjects::hide_waypoint()" );
		
		Objective_SetVisibleToPlayer( self.objectiveid, e_player );
	}
	else
	{
		Objective_SetVisibleToAll( self.objectiveid );
	}
}

function should_ping_object( relativeTeam )
{
	if ( relativeTeam == "friendly" && self.objIDPingFriendly )
	{
		return true;
	}
	else if ( relativeTeam == "enemy" && self.objIDPingEnemy )
	{
		return true;
	}
	
	return false;
}


function get_update_teams( relativeTeam )
{
	updateTeams = [];
	if ( level.teamBased )
	{
		if ( relativeTeam == "friendly" )
		{
			foreach( team in level.teams )
			{
				if ( self is_friendly_team( team ) )
				{
					updateTeams[updateTeams.size] = team;
				}
			}
		}
		else if ( relativeTeam == "enemy" )
		{
			foreach( team in level.teams )
			{
				if ( !self is_friendly_team( team ) )
				{
					updateTeams[updateTeams.size] = team;
				}
			}
		}
	}
	else
	{
		if ( relativeTeam == "friendly" )
		{
			updateTeams[updateTeams.size] = level.nonTeamBasedTeam;
		}
		else
		{
			updateTeams[updateTeams.size] = "axis";
		}
	}
	
	return updateTeams;
}

function should_show_compass_due_to_radar( team )
{
	showCompass = false;
	if ( !isdefined( self.carrier ) )
	{
		return false;
	}
	
	if ( self.carrier hasPerk( "specialty_gpsjammer" ) == false )
	{
		if( killstreaks::HasUAV( team ) )
		{
			showCompass = true;
		}
	}

	if( killstreaks::HasSatellite( team ) )
	{
		showCompass = true;
	}

	return showCompass;
}

function update_visibility_according_to_radar()
{
	self endon("death");
	self endon("carrier_cleared");
	
	while(1)
	{
		level waittill("radar_status_change");
		self update_compass_icons();
	}
}

function private _set_team( team )
{
	self.ownerTeam = team;
	
	if ( team != "any" )
	{
		self.team = team;
		
		foreach( visual in self.visuals )
		{
			visual.team = team;
		}
	}
	
}

function set_owner_team( team )
{
	self _set_team( team );
	
	self update_trigger();	
	self update_icons_and_objective();
}

function get_owner_team()
{
	return self.ownerTeam;
}

function set_decay_time( time )
{
	self.decayTime = int( time * 1000 );
}

function set_use_time( time )
{
	self.useTime = int( time * 1000 );
}

function set_use_text( text )
{
	self.useText = text;
}

function set_team_use_time( relativeTeam, time )
{
	self.teamUseTimes[relativeTeam] = int( time * 1000 );
}

function set_team_use_text( relativeTeam, text )
{
	self.teamUseTexts[relativeTeam] = text;
}

function set_use_hint_text( text )
{
	self.trigger setHintString( text );
}

function allow_carry( relativeTeam )
{
	allow_use( relativeTeam );
}

function allow_use( relativeTeam )
{
	self.interactTeam = relativeTeam;
	update_trigger();
}

function set_visible_team( relativeTeam )
{
	self.visibleTeam = relativeTeam;

	if ( !tweakables::getTweakableValue( "hud", "showobjicons" ) )
	{
		self.visibleTeam = "none";
	}

	update_icons_and_objective();
}

function set_model_visibility( visibility )
{
	if ( visibility )
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] show();
			if ( self.visuals[index].classname == "script_brushmodel" || self.visuals[index].classname == "script_model" )
			{
				self.visuals[index] thread make_solid();
			}
		}
	}
	else
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] Ghost();
			if ( self.visuals[index].classname == "script_brushmodel" || self.visuals[index].classname == "script_model" )
			{
				self.visuals[index] notify("changing_solidness");
				self.visuals[index] notsolid();
			}
		}
	}
}

function make_solid()
{
	self endon("death");
	self notify("changing_solidness");
	self endon("changing_solidness");
	
	while(1)
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( level.players[i] isTouching( self ) )
			{
				break;
			}
		}
		if ( i == level.players.size )
		{
			self solid();
			break;
		}
		wait .05;
	}
}

function set_carrier_visible( relativeTeam )
{
	self.carrierVisible = relativeTeam;
}

function set_can_use( relativeTeam )
{
	self.useTeam = relativeTeam;
}

function set_2d_icon( relativeTeam, shader )
{
	self.compassIcons[relativeTeam] = shader;
	update_compass_icons();
}

function set_3d_icon( relativeTeam, shader )
{
	if( !IsDefined(shader) )
	{
		self.worldIcons_disabled[relativeTeam] = true;
	}
	else
	{
		self.worldIcons_disabled[relativeTeam] = false;
	}

	self.worldIcons[relativeTeam] = shader;
	update_world_icons();
}

// Added
function set_3d_icon_color( relativeTeam, v_color, alpha )
{
	updateTeams = get_update_teams( relativeTeam );
	
	for ( index = 0; index < updateTeams.size; index++ )
	{
		if ( !level.teamBased && updateTeams[index] != level.nonTeamBasedTeam )
		{
			continue;
		}

		opName = "objpoint_" + updateTeams[index] + "_" + self.entNum;
		objPoint = objpoints::get_by_name( opName );
		
		if ( isdefined( objPoint ) )
		{
			if ( isdefined( v_color ) )
			{
				objPoint.color = v_color;
			}
			
			if ( isdefined( alpha ) )
			{
				objPoint.alpha = alpha;
			}
		}
	}
}

function set_objective_color( relativeTeam, v_color, alpha = 1 )  // self = gameobject
{
	if ( self.newstyle )
	{
		Objective_SetColor( self.objectiveID, v_color[ 0 ], v_color[ 1 ], v_color[ 2 ], alpha );
	}
	else
	{
		a_teams = get_update_teams( relativeTeam );
		
		for ( index = 0; index < a_teams.size; index++ )
		{
			if ( !level.teamBased && a_teams[ index ] != level.nonTeamBasedTeam )
			{
				continue;
			}
	
			Objective_SetColor( self.objID[ a_teams[ index ] ], v_color[ 0 ], v_color[ 1 ], v_color[ 2 ], alpha );
		}	
	}
}

function set_objective_entity( entity )  // self = gameobject
{
	if ( self.newstyle )
	{
		if ( IsDefined( self.objectiveID ) )
		{
			Objective_OnEntity( self.objectiveID, entity );
		}
	}
	else
	{
		a_teams = gameobjects::get_update_teams( self.interactTeam );
		
		foreach ( str_team in a_teams )
		{
			Objective_OnEntity( self.objID[ str_team ], entity );
		}
	}
}	

function get_objective_ids( str_team )  // self = gameobject
{
	a_objective_ids = [];
	
	if ( ( isdefined( self.newstyle ) && self.newstyle ) )
	{
		// newStyle objectives only use one objective index
		if ( !isdefined( a_objective_ids ) ) a_objective_ids = []; else if ( !IsArray( a_objective_ids ) ) a_objective_ids = array( a_objective_ids ); a_objective_ids[a_objective_ids.size]=self.objectiveID;;
	}
	else 
	{
		// oldStyle objectives use two objective indicies
		a_keys = GetArrayKeys( self.objID );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			if ( !IsDefined( str_team ) || ( str_team == a_keys[ i ] ) )
			{
				if ( !isdefined( a_objective_ids ) ) a_objective_ids = []; else if ( !IsArray( a_objective_ids ) ) a_objective_ids = array( a_objective_ids ); a_objective_ids[a_objective_ids.size]=self.objID[ a_keys[ i ] ];;
			}
		}
		
		if ( !isdefined( a_objective_ids ) ) a_objective_ids = []; else if ( !IsArray( a_objective_ids ) ) a_objective_ids = array( a_objective_ids ); a_objective_ids[a_objective_ids.size]=self.objectiveID;;
	}
	
	return a_objective_ids;
}

// Added
//  v_color
//	hide_distance - Hide icon if player futher away than this distance
//	los_check - Trace check?
//	ignore_ent - (optional) ignore ent in los check
function hide_icon_distance_and_los( v_color, hide_distance, los_check, ignore_ent )
{
	self endon( "disabled" );
	self endon( "destroyed_complete" );
	while( 1 )
	{
		hide = 0;

		if( IsDefined(self.worldIcons_disabled["friendly"]) && (self.worldIcons_disabled["friendly"] == true) )
		{
			hide = 1;
		}

		if( !hide )
		{
			hide = 1;
			for( i=0; i<level.players.size; i++ )
			{
				n_dist = ( Distance( level.players[i].origin, self.curorigin ) );
				if( n_dist < hide_distance )
				{
					if( ( isdefined( los_check ) && los_check ) )
					{
						b_cansee = level.players[i] gameobject_is_player_looking_at( self.curorigin, 0.8, true, ignore_ent, 42 );
						if( b_cansee )
						{
							hide = 0;
							break;
						}
					}
					else
					{
						hide = 0;
						break;
					}
				}
			}
		}

		if( hide )
		{
			self gameobjects::set_3d_icon_color( "friendly", v_color, 0 );
		}
		else
		{
			self gameobjects::set_3d_icon_color( "friendly", v_color, 1 );
		}
		{wait(.05);};
	}
}

function gameobject_is_player_looking_at( origin, dot, do_trace, ignore_ent, ignore_trace_distance )
{
	assert(IsPlayer(self), "player_looking_at must be called on a player.");

	if (!isdefined(dot))
	{
		dot = .7;
	}

	if (!isdefined(do_trace))
	{
		do_trace = true;
	}

	eye = self util::get_eye();

	delta_vec = AnglesToForward(VectorToAngles(origin - eye));
	view_vec = AnglesToForward(self GetPlayerAngles());
		
	new_dot = VectorDot( delta_vec, view_vec );
	if ( new_dot >= dot )
	{
		if (do_trace)
		{
			trace =  BulletTrace( eye, origin, false, ignore_ent );
			// If no collision, we pass
			if( trace[ "position" ] == origin )
			{
				return( true );
			}
			// if collision is close to the origin, the trace can pass
			else if( IsDefined(ignore_trace_distance) )
			{
				n_mag = Distance( origin, eye );
				n_dist = Distance( trace[ "position" ], eye );
				n_delta = abs( n_dist - n_mag );
				if( n_delta <= ignore_trace_distance )
				{
					return( true );
				}
			}
		}
		else
		{
			return true;
		}
	}
	
	return false;
}

// Hides both compass and world icons
function hide_icons( team )
{
	// Flag which icons should be hidden
	if( (self.visibleTeam == "any") || (self.visibleTeam == "friendly") )
	{
		hide_friendly = true;
	}
	else
	{
		hide_friendly = false;
	}
	if( (self.visibleTeam == "any") || (self.visibleTeam == "enemy") )
	{
		hide_enemy = true;
	}
	else
	{
		hide_enemy = false;
	}

	// Hide icons
	self.hidden_compassIcon = [];
	self.hidden_worldIcon = [];
	if( hide_friendly == true )
	{
		self.hidden_compassIcon["friendly"] = self.compassIcons["friendly"];
		self.hidden_worldIcon["friendly"] = self.worldIcons["friendly"];

	}
	if( hide_enemy == true )
	{
		self.hidden_compassIcon["enemy"] = self.compassIcons["enemyy"];
		self.hidden_worldIcon["enemy"] = self.worldIcons["enemy"];
	}

	self gameobjects::set_2d_icon( team, undefined );
	self gameobjects::set_3d_icon( team, undefined );
}

// Shows hidden compass and world icons
function show_icons( team )
{
	if( IsDefined(self.hidden_compassIcon[team]) )
	{
		self gameobjects::set_2d_icon( team, self.hidden_compassIcon[team] );
	}
	if( IsDefined(self.hidden_worldIcon[team]) )
	{
		self gameobjects::set_3d_icon( team, self.hidden_worldIcon[team] );
	}
}

function set_3d_use_icon( relativeTeam, shader )
{
	self.worldUseIcons[relativeTeam] = shader;	
}

function set_3d_is_waypoint( relativeTeam, waypoint )
{
	self.worldIsWaypoint[relativeTeam] = waypoint;	
}

function set_carry_icon( shader )
{
	assert(self.type == "carryObject", "for packObjects use: set_pack_icon() instead.");
	
	self.carryIcon = shader;
}

function set_visible_carrier_model( visibleModel )
{
		self.visibleCarrierModel = visibleModel;
}

function get_visible_carrier_model( )
{
	return self.visibleCarrierModel;
}

function destroy_object( deleteTrigger, forceHide, b_connect_paths = false )
{
	if ( !isdefined( forceHide ) )
	{
		forceHide = true;
	}
	
	self disable_object( forceHide );

	foreach ( visual in self.visuals )
	{
		if ( b_connect_paths )
		{
			visual ConnectPaths();
		}
		
		if ( IsDefined( visual ) )
		{
			visual Ghost();
			visual Delete();
		}
	}
	
	self.trigger notify( "destroyed" );

	if ( ( isdefined( deleteTrigger ) && deleteTrigger ) )
	{
		self.trigger Delete();
	}
	else
	{
		self.trigger TriggerEnable( true );
	}

	self notify( "destroyed_complete" );
}

function disable_object( forceHide )
{
	self notify("disabled");
	
	if ( (self.type == "carryObject") || (self.type == "packObject") || ( isdefined( forceHide ) && forceHide ) )
	{
		if ( isdefined( self.carrier ) )
		{
			self.carrier take_object( self );
		}

		for ( index = 0; index < self.visuals.size; index++ )
		{
			if( IsDefined(self.visuals[index]) )
			{
				self.visuals[index] Ghost();
			}
		}
	}
	
	self.trigger TriggerEnable( false );
	self set_visible_team( "none" );
	
	if( isdefined( self.objectiveid ) )
	{
		objective_clearentity( self.objectiveID );
	}
}

function enable_object( forceShow )
{
	if ( (self.type == "carryObject") || (self.type == "packObject") || ( isdefined( forceShow ) && forceShow ) )
	{
		for ( index = 0; index < self.visuals.size; index++ )
		{
			self.visuals[index] show();
		}
	}
	
	self.trigger TriggerEnable( true );
	self set_visible_team( "any" );
	
	if( isdefined( self.objectiveid ) )
	{
		objective_onentity( self.objectiveID, self );
	}
}


function get_relative_team( team )
{
	if( self.ownerTeam == "any" )
	{
		return "friendly";
	}

	if ( team == self.ownerTeam )
	{
		return "friendly";
	}
	else if ( team == get_enemy_team( self.ownerTeam ) )
	{
		return "enemy";
	}
	else
	{
		return "neutral";
	}
}


function is_friendly_team( team )
{
	if ( !level.teamBased )
	{
		return true;
	}
	
	if ( self.ownerTeam == "any" )
	{
		return true;
	}
	
	if ( self.ownerTeam == team )
	{
		return true;
	}

	return false;
}


function can_interact_with( player )
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
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if ( player == self.ownerTeam )
				{
					return true;
				}
				else
				{
					return false;
				}
			}

		case "enemy":
			if ( level.teamBased )
			{
				if ( team != self.ownerTeam )
				{
					return true;
				}
				else if ( isdefined(self.decayProgress) && self.decayProgress && self.curProgress > 0 )
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if ( player != self.ownerTeam )
				{
					return true;
				}
				else
				{
					return false;
				}
			}

		default:
			assert( 0, "invalid interactTeam" );
			return false;
	}
}


function is_team( team )
{
	switch( team )
	{
		case "neutral":
		case "any":
		case "none":
			return true;
			break;
	}

	if ( isdefined( level.teams[team] ) )
	{
		return true;
	}
	
	return false;
}

function is_relative_team( relativeTeam )
{
	switch( relativeTeam )
	{
		case "friendly":
		case "enemy":
		case "any":
		case "none":
			return true;		
			break;
			
		default:
			return false;
			break;
	}
}


function get_enemy_team( team )
{
	switch( team )
	{
		case "neutral":
			return "none";		
			break;
		// TODO MTEAM - figure out how to determine enemy team	
		case "allies":
			return "axis";
			break;
			
		default:
			return "allies";
			break;
	}
}

function get_next_obj_id()
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

/#
	//No longer an assert, but still print a warning so we know when it happens.
	if( nextId >= 128 )
	{
		println("^3SCRIPT WARNING: Ran out of objective IDs");
	}
#/
	
	// if for some reason we ever overrun the objective array then just going
	// to keep using the last objective id.  This should only happen in extreme
	// situations (ie. trying to make this happen).
	if ( nextId > ( 128 - 1 ) )
	{
		nextId = ( 128 - 1 );
	}
		
	return nextID;
}

function release_obj_id( objID )
{
	Assert( objID < level.numGametypeReservedObjectives );
	for ( i = 0; i < level.releasedObjectives.size; i++ )
	{
		if ( objID == level.releasedObjectives[i] && objID == ( 128 - 1 ) )
		{
			return;
		}
/#
		Assert( objID != level.releasedObjectives[i] );
#/	
	}
	level.releasedObjectives[ level.releasedObjectives.size ] = objID;		
	
	// reset color and alpha
	Objective_SetColor( objID, 1, 1, 1, 1 );
	
	// clear objective state
	Objective_State( objID, "empty" );
}

function release_all_objective_ids()  // self = gameobject
{
	if ( IsDefined( self.objID ) )
	{
		a_keys = GetArrayKeys( self.objID );
		{
			for ( i = 0; i < a_keys.size; i++ )
			{
				release_obj_id( self.objID[ a_keys[ i ] ] );
			}
		}
	}
	
	if ( IsDefined( self.objectiveID ) )
	{
		release_obj_id( self.objectiveID );
	}
}

function get_label()
{
	label = self.trigger.script_label;
	if ( !isdefined( label ) )
	{
		label = "";
		return label;
	}
	
	if ( label[0] != "_" )
	{
		return ("_" + label);
	}
	
	return label;
}

function must_maintain_claim( enabled )
{
	self.mustMaintainClaim = enabled;
}

function can_contest_claim( enabled )
{
	self.canContestClaim = enabled;
}

function set_flags( flags )
{
	Objective_SetGamemodeFlags( self.objectiveID, flags );
}

function get_flags( flags )
{
	return Objective_GetGamemodeFlags( self.objectiveID );
}

//=====================================================================================
//	create_pack_object
//	dcs: 042314
//	Creates and returns a pack object
//	pack objects are line carry objects except you can carry more than one at a time.
//=====================================================================================
function create_pack_object( ownerTeam, trigger, visuals, offset, objectiveName )
{
	if(!IsDefined(level.max_packObjects))
	{
		level.max_packObjects = 4;	
	}
	
	Assert( level.max_packObjects < 5, "packObject system not currently designed to handle more than 4 objects" );
	
	packObject = spawnStruct();
	packObject.type = "packObject";
	packObject.curOrigin = trigger.origin;
	packObject.entNum = trigger getEntityNumber();
	
	if ( isSubStr( trigger.classname, "use" ) )
	{
		packObject.triggerType = "use";
	}
	else
	{
		packObject.triggerType = "proximity";
	}
		
	// associated trigger
	trigger.baseOrigin = trigger.origin;
	packObject.trigger = trigger;
	
	packObject.useWeapon = undefined;
	
	if ( !isdefined( offset ) )
	{
		offset = (0,0,0);
	}

	packObject.offset3d = offset;
	
	packObject.newStyle = false;
	if ( isdefined( objectiveName ) )
	{
		if( !SessionModeIsCampaignGame() )
		{
			packObject.newStyle = true;
		}
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
	packObject.visuals = visuals;
	
	packObject _set_team( ownerTeam );

	// compass objectives
	packObject.compassIcons = [];
	packObject.objID =[];
	// this block will completely go away when we have fully switched to the new style
	if ( !packObject.newStyle )
	{
		foreach( team in level.teams )
		{
			packObject.objID[team] = get_next_obj_id();
		}
	}
	packObject.objIDPingFriendly = false;
	packObject.objIDPingEnemy = false;
	level.objIDStart += 2;
	
	// this block will completely go away when we have fully switched to the new style
	if ( !packObject.newStyle )
	{
		if ( level.teamBased )
		{
			foreach ( team in level.teams )
			{
				objective_add( packObject.objID[team], "invisible", packObject.curOrigin );
				objective_team( packObject.objID[team], team );
				packObject.objPoints[team] = objpoints::create( "objpoint_" + team + "_" + packObject.entNum, packObject.curOrigin + offset, team, undefined );
				packObject.objPoints[team].alpha = 0;
			}
		}
		else
		{
			// TODO MTEAM - not sure why the we only use allies in dm
			objective_add( packObject.objID[level.nonTeamBasedTeam], "invisible", packObject.curOrigin );
			packObject.objPoints[level.nonTeamBasedTeam] = objpoints::create( "objpoint_"+ level.nonTeamBasedTeam + "_" + packObject.entNum, packObject.curOrigin + offset, "all", undefined );
			packObject.objPoints[level.nonTeamBasedTeam].alpha = 0;
		}
	}
	
	packObject.objectiveID = get_next_obj_id();
	
	// new style objective
	if ( packObject.newStyle )
	{
		objective_add( packObject.objectiveID, "invisible", packObject.curOrigin, objectiveName );
	}
	
	// carrying player
	packObject.carrier = undefined;
	
	// misc
	packObject.isResetting = false;	
	packObject.interactTeam = "none"; // "none", "any", "friendly", "enemy";
	packObject.allowWeapons = true;
	packObject.visibleCarrierModel = undefined;
	packObject.dropOffset = 0;
	
	// 3d world icons
	packObject.worldIcons = [];
	packObject.carrierVisible = false; // packObject only
	packObject.visibleTeam = "none"; // "none", "any", "friendly", "enemy";
	packObject.worldIsWaypoint = [];

	packObject.worldIcons_disabled = [];
	
	packObject.packIcon = undefined;

	// callbacks
	packObject.setDropped = undefined;
	packObject.onDrop = undefined;
	packObject.onPickup = undefined;
	packObject.onReset = undefined;
	

	if ( packObject.triggerType == "use" )
	{
		packObject thread carry_object_use_think();
	}
	else
	{
		packObject.numTouching["neutral"] = 0;
		packObject.numTouching["none"] = 0;
		packObject.touchList["neutral"] = [];
		packObject.touchList["none"] = [];

		foreach( team in level.teams )
		{
			packObject.numTouching[team] = 0;
			packObject.touchList[team] = [];
		}
		
		packObject.curProgress = 0;
		packObject.useTime = 0;
		packObject.useRate = 0;
		packObject.claimTeam = "none";
		packObject.claimPlayer = undefined;
		packObject.lastClaimTeam = "none";
		packObject.lastClaimTime = 0;
		packObject.claimGracePeriod = 0;
		packObject.mustMaintainClaim = false;	
		packObject.canContestClaim = false;
		packObject.decayProgress = false;

		packObject.teamUseTimes = [];
		packObject.teamUseTexts = [];

		packObject.onUse =&set_picked_up;
		
		packObject thread use_object_prox_think();

		//packObject thread carry_object_prox_think();
	}
		
	packObject thread update_carry_object_origin();
	packObject thread update_carry_object_objective_origin();

	return packObject;
}

//=====================================================================================
//give_pack_object
//Set player as holding this object
//Should only be called from set_picked_up
//=====================================================================================






function give_pack_object( object )
{
	self.packObject[ self.packObject.size ] = object;
	self thread track_carrier(object);
	
	if ( !object.newStyle )
	{
		if ( isdefined( object.packIcon ))
		{
			if ( self IsSplitscreen() )
			{
				elem = hud::createIcon( object.packIcon, 25, 25 );
				elem.y = -90;
				elem.horzAlign = "right";
				elem.vertAlign = "bottom";
			}
			else
			{
				elem = hud::createIcon( object.packIcon, 35, 35 );
				elem.y = -110;
				elem.horzAlign = "user_right";
				elem.vertAlign = "user_bottom";
			}

			elem.x = get_packIcon_offset(self.packIcon.size);
			elem.alpha = 0.75;
			elem.hidewhileremotecontrolling = true;
			elem.hidewheninkillcam = true;
			elem.script_string = object.packIcon;
			
			self.packIcon[ self.packIcon.size ] = elem;
		}
	}
}

function get_packIcon_offset(index)
{
	if(!IsDefined(index))
	{
		index = 0;
	}
			
	if( self IsSplitscreen() )
		{
			size = 25;
			base = -130;
		}
		else
		{
			size = 35;
			base = -40;
		}
	
	int = base - (size * index);
	return int;
}	

function adjust_remaining_packIcons()
{
	if(!IsDefined(self.packIcon))
	{
		return;
	}
	
	if(self.packIcon.size > 0)
	{
		for( i = 0; i < self.packIcon.size; i++ )
		{
			self.packIcon[i].x = get_packIcon_offset(i);
		}
	}		
}	

function set_pack_icon( shader )
{
	assert(self.type == "packObject", "for carryObjects use: set_carry_icon() instead.");
	
	self.packIcon = shader;
}
//=====================================================================================

