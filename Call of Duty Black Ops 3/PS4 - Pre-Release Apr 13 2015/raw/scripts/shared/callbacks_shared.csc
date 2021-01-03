#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  

#namespace callback;

#precache( "eventstring", "open_side_mission_countdown" );
#precache( "eventstring", "close_side_mission_countdown" );

function callback( event, params )
{
	if ( isdefined( level._callbacks ) && isdefined( level._callbacks[event] ) )
	{
		for ( i = 0; i < level._callbacks[event].size; i++ )
		{
			callback = level._callbacks[event][i][0];
			obj = level._callbacks[event][i][1];
			
			if ( !isdefined( callback ) )
			{
				continue;
			}

			if ( isdefined( obj ) )
			{
				if ( isdefined( params ) )
				{
					obj thread [[callback]]( self, params );
				}
				else
				{
					obj thread [[callback]]( self );
				}
			}
			else
			{
				if ( isdefined( params ) )
				{
					self thread [[callback]]( params );
				}
				else
				{
					self thread [[callback]]();
				}
			}
		}
	}
}

function add_callback( event, func, obj )
{
	assert( isdefined( event ), "Trying to set a callback on an undefined event." );

	if ( !isdefined( level._callbacks ) || !isdefined( level._callbacks[event] ) )
	{
		level._callbacks[event] = [];
	}

	array::add( level._callbacks[event], array( func, obj ), false );
	
	if ( isdefined( obj ) )
	{
		obj thread remove_callback_on_death( event, func );
	}
}

function remove_callback_on_death( event, func )
{
	self waittill( "death" );
	remove_callback( event, func, self );
}

function remove_callback( event, func, obj )
{
	assert( isdefined( event ), "Trying to remove a callback on an undefined event." );
	assert( isdefined( level._callbacks[event] ), "Trying to remove callback for unknown event." );
	
	foreach ( index, func_group in level._callbacks[event] )
	{
		if ( func_group[0] == func )
		{
			if ( ( func_group[1] === obj ) )
			{
				ArrayRemoveIndex( level._callbacks[event], index, false );
				break;  // callback to remove has been found, don't process anything else in the array; add_callback disallows dupes
			}
		}
	}
}

function on_finalize_initialization( func, obj )
{
	add_callback( #"on_finalize_initialization", func, obj );
}

/@
"Name: on_connect(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player connects"
"MandatoryArg: <func> the function you want to call on the new player."
"Example: callback::on_connect(&on_player_connect);"
"SPMP: singleplayer"
@/
function on_connect( func, obj )
{
	add_callback( #"on_player_connect", func, obj );
}

/@
"Name: remove_on_connect(<func>)"
"Summary: Remove a callback for when a player connects"
"MandatoryArg: <func> the function you want to Remove on the new player."
"Example: callback::remove_on_connect(&on_player_connect);"
@/
function remove_on_connect( func, obj )
{
	remove_callback( #"on_player_connect", func, obj );
}

/@
"Name: on_connecting(<func>)"
"Summary: Set a callback for when a player is connecting"
"MandatoryArg: <func> the function you want to call on the new player."
"Example: callback::on_connecting(&on_player_connect);"
@/
function on_connecting( func, obj )
{
	add_callback( #"on_player_connecting", func, obj );
}

/@
"Name: remove_on_connecting(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player is connecting"
"MandatoryArg: <func> the function you want to Remove on the new player."
"Example: callback::remove_on_connecting(&on_player_connect);"
@/
function remove_on_connecting( func, obj )
{
	remove_callback( #"on_player_connecting", func, obj );
}

function on_disconnect( func, obj )
{
	add_callback( #"on_player_disconnect", func, obj );
}

/@
"Name: remove_on_disconnect(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a player connects"
"MandatoryArg: <func> the function you want to remove when a player disconnects."
"Example: callback::remove_on_disconnect(&on_player_disconnect);"
@/
function remove_on_disconnect( func, obj )
{
	remove_callback( #"on_player_disconnect", func, obj );
}

/@
"Name: on_spawned( <func> )"
"Summary: Set a callback for when a player spawns"
"MandatoryArg: <func> the function you want to call on the new player."
"Example: callback::on_connect( &on_player_spawned );"
@/
function on_spawned( func, obj )
{
	add_callback( #"on_player_spawned", func, obj );
}

/@
"Name: remove_on_spawned(<func>)"
"Summary: Remove a callback for when a player spawns"
"MandatoryArg: <func> the function you want to remove on the new player."
"Example: callback::remove_on_spawned( &on_player_spawned );"
@/
function remove_on_spawned( func, obj )
{
	remove_callback( #"on_player_spawned", func, obj );
}

/@
"Name: on_loadout( <func> )"
"Summary: Set a callback for when a player gets their loadout set"
"MandatoryArg: <func> the function you want to call when a player gets their loadout set."
"Example: callback::on_loadout( &on_loadout );"
@/
function on_loadout( func, obj )
{
	add_callback( #"on_loadout", func, obj );
}

/@
"Name: remove_on_loadout( <func> )"
"Summary: Remove a callback for when a player gets their loadout set"
"MandatoryArg: <func> the function you want to remove."
"Example: callback::remove_on_loadout( &on_loadout );"
@/
function remove_on_loadout( func, obj )
{
	remove_callback( #"on_loadout", func, obj );
}

/@
"Name: on_player_damage(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player get damaged"
"MandatoryArg: <func> the function you want to call on the damaged player."
"Example: callback::on_player_damage(&on_player_damage);"
@/
function on_player_damage( func, obj )
{
	add_callback( #"on_player_damage", func, obj );
}

/@
"Name: remove_on_player_damage(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a player get damaged"
"MandatoryArg: <func> the function you want to Remove on the damaged player."
"Example: callback::remove_on_player_damage(&on_player_damage);"
@/
function remove_on_player_damage( func, obj )
{
	remove_callback( #"on_player_damage", func, obj );
}

/@
"Name: on_start_gametype(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player starts a gametype"
"MandatoryArg: <func> the function you want to call on the player."
"Example: callback::on_start_gametype( &init );"
@/
function on_start_gametype( func, obj )
{
	add_callback( #"on_start_gametype", func, obj );
}

/@
"Name: on_joined_team(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player joins a team"
"MandatoryArg: <func> the function you want to call on the player joining a team."
"Example: callback::on_joined_team( &init );"
@/
function on_joined_team( func, obj )
{
	add_callback( #"on_joined_team", func, obj );
}

/@
"Name: on_joined_spectate(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player joins spectate"
"MandatoryArg: <func> the function you want to call on the player joining a team."
"Example: callback::on_joined_spectate( &init );"
@/
function on_joined_spectate( func, obj )
{
	add_callback( #"on_joined_spectate", func, obj );
}

/@
"Name: on_player_killed(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player dies"
"MandatoryArg: <func> the function you want to call when a player dies."
"Example: callback::on_player_killed(&on_player_killed);"
"SPMP: singleplayer"
@/
function on_player_killed( func, obj )
{
	add_callback( #"on_player_killed", func, obj );
}

/@
"Name: remove_on_player_killed(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a player dies"
"MandatoryArg: <func> the function you want to remove when a player dies."
"Example: callback::remove_on_player_killed(&on_player_killed);"
"SPMP: singleplayer"
@/
function remove_on_player_killed( func, obj )
{
	remove_callback( #"on_player_killed", func, obj );
}

/@
"Name: on_ai_killed(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a ai dies"
"MandatoryArg: <func> the function you want to call when a ai dies."
"Example: callback::on_ai_killed(&on_ai_killed);"
@/
function on_ai_killed( func, obj )
{
	add_callback( #"on_ai_killed", func, obj );
}

/@
"Name: remove_on_ai_killed(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a ai dies"
"MandatoryArg: <func> the function you want to remove when a ai dies."
"Example: callback::remove_on_ai_killed(&on_ai_killed);"
@/
function remove_on_ai_killed( func, obj )
{
	remove_callback( #"on_ai_killed", func, obj );
}

/@
"Name: on_actor_killed(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a actor dies"
"MandatoryArg: <func> the function you want to call when a actor dies."
"Example: callback::on_actor_killed(&on_actor_killed);"
@/
function on_actor_killed( func, obj )
{
	add_callback( #"on_actor_killed", func, obj );
}

/@
"Name: remove_on_actor_killed(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a actor dies"
"MandatoryArg: <func> the function you want to remove when a actor dies."
"Example: callback::remove_on_actor_killed(&on_actor_killed);"
@/
function remove_on_actor_killed( func, obj )
{
	remove_callback( #"on_actor_killed", func, obj );
}

/@
"Name: on_vehicle_spawned(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a vehicle spawns"
"MandatoryArg: <func> the function you want to call when a vehicle dies."
"Example: callback::on_vehicle_spawned(&on_vehicle_spawned);"
@/
function on_vehicle_spawned( func, obj )
{
	add_callback( #"on_vehicle_spawned", func, obj );
}

/@
"Name: remove_on_vehicle_spawned(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a vehicle spawns"
"MandatoryArg: <func> the function you want to remove when a vehicle dies."
"Example: callback::remove_on_vehicle_spawned(&on_vehicle_spawned);"
@/
function remove_on_vehicle_spawned( func, obj )
{
	remove_callback( #"on_vehicle_spawned", func, obj );
}

/@
"Name: on_vehicle_killed(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a vehicle dies"
"MandatoryArg: <func> the function you want to call when a vehicle dies."
"Example: callback::on_vehicle_killed(&on_vehicle_killed);"
@/
function on_vehicle_killed( func, obj )
{
	add_callback( #"on_vehicle_killed", func, obj );
}

/@
"Name: remove_on_vehicle_killed(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a vehicle dies"
"MandatoryArg: <func> the function you want to remove when a vehicle dies."
"Example: callback::remove_on_vehicle_killed(&on_vehicle_killed);"
@/
function remove_on_vehicle_killed( func, obj )
{
	remove_callback( #"on_vehicle_killed", func, obj );
}

/@
"Name: on_ai_damage(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when an ai takes damage"
"MandatoryArg: <func> the function you want to call when an ai takes damage."
"Example: callback::on_ai_damage(&on_ai_damage);"
@/
function on_ai_damage( func, obj )
{
	add_callback( #"on_ai_damage", func, obj );
}

/@
"Name: remove_on_ai_damage(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a ai gets damaged"
"MandatoryArg: <func> the function you want to remove when a ai recieves damage."
"Example: callback::remove_on_ai_damage(&on_ai_killed);"
@/
function remove_on_ai_damage( func, obj )
{
	remove_callback( #"on_ai_damage", func, obj );
}

/@
"Name: on_ai_spawned(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when an ai spawns"
"MandatoryArg: <func> the function you want to call when an ai spawns."
"Example: callback::on_ai_spawned(&on_ai_spawned);"
@/
function on_ai_spawned( func, obj )
{
	add_callback( #"on_ai_spawned", func, obj );
}

/@
"Name: remove_on_ai_spawned(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a ai spawns"
"MandatoryArg: <func> the function you want to remove when a ai spawns."
"Example: callback::remove_on_ai_spawned(&on_ai_spawned);"
@/
function remove_on_ai_spawned( func, obj )
{
	remove_callback( #"on_ai_spawned", func, obj );
}


/@
"Name: on_actor_damage(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when an actor takes damage"
"MandatoryArg: <func> the function you want to call when an actor takes damage."
"Example: callback::on_actor_damage(&on_actor_damage);"
@/
function on_actor_damage( func, obj )
{
	add_callback( #"on_actor_damage", func, obj );
}

/@
"Name: remove_on_actor_damage(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a actor gets damaged"
"MandatoryArg: <func> the function you want to remove when a actor recieves damage."
"Example: callback::remove_on_actor_damage(&on_actor_killed);"
@/
function remove_on_actor_damage( func, obj )
{
	remove_callback( #"on_actor_damage", func, obj );
}


/@
"Name: on_vehicle_damage(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when an vehicle takes damage"
"MandatoryArg: <func> the function you want to call when an vehicle takes damage."
"Example: callback::on_vehicle_damage(&on_vehicle_damage);"
"SPMP: singleplayer"
@/
function on_vehicle_damage( func, obj )
{
	add_callback( #"on_vehicle_damage", func, obj );
}

/@
"Name: remove_on_vehicle_damage(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a vehicle gets damaged"
"MandatoryArg: <func> the function you want to remove when a vehicle recieves damage."
"Example: callback::remove_on_vehicle_damage(&on_vehicle_killed);"
@/
function remove_on_vehicle_damage( func, obj )
{
	remove_callback( #"on_vehicle_damage", func, obj );
}


/@
"Name: on_laststand(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player goes into last stand"
"MandatoryArg: <func> the function you want to call when a player goes into last stand."
"Example: callback::on_laststand(&on_last_stand);"
"SPMP: singleplayer"
@/
function on_laststand( func, obj )
{
	add_callback( #"on_player_laststand", func, obj );
}

/*================
Called by code before level main but after autoexecs
================*/
function CodeCallback_PreInitialization()
{
	callback::callback( #"on_pre_initialization" );
	system::run_pre_systems();
}

/*================
Called by code as the final step of initialization
================*/
function CodeCallback_FinalizeInitialization()
{
	system::run_post_systems();
	callback::callback( #"on_finalize_initialization" );
}

function add_weapon_damage( weapontype, callback )
{
	if ( !isdefined( level.weapon_damage_callback_array ) )
	{
		level.weapon_damage_callback_array = [];
	}
	
	level.weapon_damage_callback_array[weapontype] = callback;
}

function callback_weapon_damage( eAttacker, eInflictor, weapon, meansOfDeath, damage )
{
	if( isdefined( level.weapon_damage_callback_array ) )
	{
		if ( isdefined( level.weapon_damage_callback_array[weapon] ) )
		{
			self thread [[level.weapon_damage_callback_array[weapon]]]( eAttacker, eInflictor, weapon, meansOfDeath, damage );
			return true;
		}
		else if ( isdefined( level.weapon_damage_callback_array[weapon.rootWeapon] ) )
		{
			self thread [[level.weapon_damage_callback_array[weapon.rootWeapon]]]( eAttacker, eInflictor, weapon, meansOfDeath, damage );
			return true;
		}
	}

	return false;
}

function add_weapon_watcher( callback )
{
	if ( !isdefined( level.weapon_watcher_callback_array ) )
	{
		level.weapon_watcher_callback_array = [];
	}
	
	array::add( level.weapon_watcher_callback_array, callback );
}

function callback_weapon_watcher()
{
	if( isdefined( level.weapon_watcher_callback_array ) )
	{
		for( x = 0; x < level.weapon_watcher_callback_array.size; x++ )
		{
			self [[level.weapon_watcher_callback_array[x]]]();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Files moved from _callbacksetup.gsc
//////////////////////////////////////////////////////////////////////////////////////////////////

/*================
Called by code after the level's main script function has run.
================*/
function CodeCallback_StartGameType()
{
	// If the gametype has not been started, run the startup
	if(!isdefined(level.gametypestarted) || !level.gametypestarted)
	{
		[[level.callbackStartGameType]]();

		level.gametypestarted = true; // so we know that the gametype has been started up
	}
}

/*================
Called when a player begins connecting to the server.
Called again for every map change or tournement restart.

Return undefined if the client should be allowed, otherwise return
a string with the reason for denial.

Otherwise, the client will be sent the current gamestate
and will eventually get to ClientBegin.

firstTime will be qtrue the very first time a client connects
to the server machine, but qfalse on map changes and tournement
restarts.
================*/
function CodeCallback_PlayerConnect()
{
	self endon("disconnect");
	
	[[level.callbackPlayerConnect]]();
}

/*================
Called when a player drops from the server.
Will not be called between levels.
self is the player that is disconnecting.
================*/
function CodeCallback_PlayerDisconnect()
{
	self notify( "death" );
	
	self notify("disconnect");
	level notify("disconnect", self);

	[[level.callbackPlayerDisconnect]]();
	
	callback::callback( #"on_player_disconnect" );
}

/*================
Called when we want to setup the game type details from host migration
================*/
function CodeCallback_Migration_SetupGameType()
{
/#	PrintLn("****CodeCallback_Migration_SetupGameType****");		#/
	simple_hostmigration::Migration_SetupGameType();
}

/*================
Called when a host migration has occurred
================*/
function CodeCallback_HostMigration()
{
/#	PrintLn("****CodeCallback_HostMigration****");	#/
	[[level.callbackHostMigration]]();
}


/*================
Called when a host migration save has occurred
================*/
function CodeCallback_HostMigrationSave()
{
/#	PrintLn("****CodeCallback_HostMigrationSave****");	#/
	[[level.callbackHostMigrationSave]]();
}

function CodeCallback_PreHostMigrationSave()
{
/#	PrintLn("****CodeCallback_PreHostMigrationSave****");	#/	
	[[level.callbackPreHostMigrationSave]]();
}


/*================
Called when a player migration has occurred
================*/
function CodeCallback_PlayerMigrated()
{
/#	PrintLn("****CodeCallback_PlayerMigrated****");		#/
	[[level.callbackPlayerMigrated]]();
}


/*================
Called when a player has taken damage.
self is the player that took damage.
================*/
function CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, vSurfaceNormal)
{
	self endon("disconnect");
	[[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, vSurfaceNormal);
}

/*================
Called when a player has been killed.
self is the player that was killed.
================*/
function CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	[[level.callbackPlayerKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

/*================
Called when a player has been killed, but has last stand perk.
self is the player that was killed.
================*/
function CodeCallback_PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, delayOverride )
{
	self endon("disconnect");
	[[level.callbackPlayerLastStand]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, delayOverride );
}

/*================
Called when a player has been melee'd.
self is the player that was melee'd
================*/
function CodeCallback_PlayerMelee( eAttacker, iDamage, weapon, vOrigin, vDir, boneIndex, shieldHit )
{
	self endon("disconnect");
	[[level.callbackPlayerMelee]]( eAttacker, iDamage, weapon, vOrigin, vDir, boneIndex, shieldHit);
}


/*================
Called when a actor has spawned.
self is the actor that spawned.
================*/
function CodeCallback_ActorSpawned( spawner )
{
	[[level.callbackActorSpawned]]( spawner );
}


/*================
Called when a actor has taken damage.
self is the actor that took damage.
================*/
function CodeCallback_ActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal)
{
	[[level.callbackActorDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal );
}

/*================
Called when a actor has been killed.
self is the actor that was killed.
================*/
function CodeCallback_ActorKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset)
{
	[[level.callbackActorKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset);
}

/*================
Called when a vehicle has spawned.
self is the vehicle that spawned.
================*/
function CodeCallback_VehicleSpawned( spawner )
{
	if (IsDefined(level.callbackVehicleSpawned))
		[[level.callbackVehicleSpawned]]( spawner );
}

/*================
Called when a vehicle has been killed.
self is the vehicle that has been killed.
================*/

function codecallback_vehiclekilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	[[level.callbackVehicleKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
}
	

/*================
Called when a vehicle has taken damage.
self is the vehicl that took damage.
================*/
function CodeCallback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	[[level.callbackVehicleDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
}


/*================
Called when a vehicle has taken damage.
self is the vehicl that took damage.
================*/
function CodeCallback_VehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, timeOffset)
{
	[[level.callbackVehicleRadiusDamage]](eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, timeOffset);
}

function finishCustomTraversalListener()
{
	self endon( "death" );
	self waittillmatch( "custom_traversal_anim_finished", "end" );
	
	self finishtraversal();
	self Unlink();

	self.useGoalAnimWeight = false;
	self.blockingPain = false;
	
	self notify( "custom_traversal_cleanup" );
}

function killedCustomTraversalListener()
{
	self endon( "custom_traversal_cleanup" );
	self waittill( "death" );
	
	if ( isdefined( self ) )
	{
		self finishtraversal();
		self StopAnimScripted();
		self Unlink();
	}
}

/*================
Called from code to register custom
traversal animations
================*/

function CodeCallback_PlayCustomTraversal( entity, beginParent, endParent, origin, angles, animHandle, animMode, playbackSpeed, goalTime, lerpTime )
{
	entity.blockingPain = true;
	entity.useGoalAnimWeight = true;
	
	entity AnimMode( "noclip", false );
	entity OrientMode( "face angle", angles[1] );

	if ( IsDefined( endParent ) )
	{
		offset = entity.origin - endParent.origin;
		entity LinkTo( endParent, "", offset );
	}

	entity AnimScripted( "custom_traversal_anim_finished", origin, angles, animHandle, animMode, undefined, playbackSpeed, goalTime, lerpTime );
	
	entity thread finishCustomTraversalListener();
	entity thread killedCustomTraversalListener();
}

// CODER_MOD - LDS - 06/02/10 - Callback to inform facial animation system of new event
function CodeCallback_FaceEventNotify( notify_msg, ent )
{
	if( isdefined( ent ) && isdefined( ent.do_face_anims ) && ent.do_face_anims )
	{
		if( isdefined( level.face_event_handler ) && isdefined( level.face_event_handler.events[notify_msg] ) )
		{
			ent SendFaceEvent( level.face_event_handler.events[notify_msg] );
		}
	}
}

/*================
Called when a menu message is recieved
================*/
function CodeCallback_MenuResponse( action, arg )
{
	//append to the message queue
	if (!isdefined(level.MenuResponseQueue))
	{
		level.MenuResponseQueue=[];
		level thread menu_response_queue_pump();
	}
	
	index=level.MenuResponseQueue.size;
	level.MenuResponseQueue[index]=SpawnStruct();
	level.MenuResponseQueue[index].action=action;
	level.MenuResponseQueue[index].arg=arg;
	level.MenuResponseQueue[index].ent=self;
	level notify("menuresponse_queue");
}

function menu_response_queue_pump()
{
	while(1)
	{
		level waittill("menuresponse_queue");
		do
		{
			level.MenuResponseQueue[0].ent notify("menuresponse",level.MenuResponseQueue[0].action,level.MenuResponseQueue[0].arg);
			ArrayRemoveIndex(level.MenuResponseQueue,0,false);
			{wait(.05);};
		}
		while (level.MenuResponseQueue.size>0);
	}
}

/*================
Called when the server has been notified that lui has updated a bunk collectible (see CodeCallback_BunkCollectibleChange for client side)
================*/
function CodeCallback_SetBunkCollectible( player, collectibleId, collectibleSlot )
{
	//only proceed if the rooms are setup for the safehouse
	if( !IsDefined( level.rooms ) )
	{
		return;
	}
	
	//get the room number for the player
	n_player = player GetEntityNumber();
	
	//the id must not be 0, that is a null condition
	if( collectibleId != 0 )
	{
		str_model = GetCollectibleModel( collectibleId );
		level.rooms[n_player].a_coll[ collectibleSlot ] SetModel( str_model );
	}
	else
	{
		level.rooms[n_player].a_coll[ collectibleSlot ] SetModel( "tag_origin" );
	}
}

/*================
Called when an animation notetrack for calling a script function is encountered.
pSelf is the entity playing the animation that is executing the notetrack
label is the label set for the function to be called
param is a string containing all parameters passed through the notetrack
================*/
function CodeCallback_CallServerScript( pSelf, label, param )
{
	if ( !IsDefined( level._animnotifyfuncs ) )
		return;
	
	if ( IsDefined( level._animnotifyfuncs[ label ] ) )
	{
		pSelf [[ level._animnotifyfuncs[ label ] ]]( param );
	}
}

function CodeCallback_CallServerScriptOnLevel( label, param )
{
	if ( !IsDefined( level._animnotifyfuncs ) )
		return;
	
	if ( IsDefined( level._animnotifyfuncs[ label ] ) )
	{
		level [[ level._animnotifyfuncs[ label ] ]]( param );
	}
}

/*================
Called when lui needs to trigger a mission switch
================*/
function CodeCallback_LaunchSideMission( str_mapname, str_gametype, int_list_index, int_lighting )
{
	switchmap_preload( str_mapname, str_gametype, int_lighting );

	LUINotifyEvent( &"open_side_mission_countdown", 1, int_list_index );
	
	wait( 10.0 );
	
	LUINotifyEvent( &"close_side_mission_countdown" );
	
	switchmap_switch();
}

function CodeCallback_FadeBlackscreen( duration, blendTime )
{
	for( i = 0; i < level.players.size; i++ )
	{
		if( IsDefined( level.players[i] ) )
		{
			level.players[i] thread hud::fade_to_black_for_x_sec( 0, duration, blendTime, blendTime );
		}
	}
}

/*================
Called when a gametype is not supported.
================*/
function abort_level()
{
/#	println("ERROR: Aborting level - gametype is not supported");	#/

	level.callbackStartGameType =&callback_void;
	level.callbackPlayerConnect =&callback_void;
	level.callbackPlayerDisconnect =&callback_void;
	level.callbackPlayerDamage =&callback_void;
	level.callbackPlayerKilled =&callback_void;
	level.callbackPlayerLastStand =&callback_void;
	level.callbackPlayerMelee =&callback_void;
	level.callbackActorDamage =&callback_void;
	level.callbackActorKilled =&callback_void;
	level.callbackVehicleDamage =&callback_void;
	level.callbackVehicleKilled = &callback_void;
	level.callbackActorSpawned =&callback_void;	
	level.callbackBotEnteredUserEdge =&callback_void;
	
	if( isdefined( level._gametype_default ) )
	{
		SetDvar( "g_gametype", level._gametype_default );
	}

	exitLevel(false);
}

function CodeCallback_GlassSmash(pos, dir)
{
	level notify("glass_smash", pos, dir);
}

/*================
Called when a bot enters a user edge
================*/
function CodeCallback_BotEnteredUserEdge( start, end, dir, beginDir, dist, zDelta, wallDir, climb )
{ 
	[[level.callbackBotEnteredUserEdge]]( start, end, dir, beginDir, dist, zDelta, wallDir, climb );
}

/*================
================*/
function callback_void()
{
}

