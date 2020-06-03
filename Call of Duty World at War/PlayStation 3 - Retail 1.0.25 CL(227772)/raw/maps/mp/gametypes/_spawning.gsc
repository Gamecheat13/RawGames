/*
_spawning.gsc
Copyright (c) 2008 Certain Affinity, Inc. All rights reserved.
Friday April 25, 2008 3:59pm Stefan S.

spawn_point[]:
--------------
"origin" - worldspace origin
"score" - desirability for spawning; calculated by applying influencers plus a small amount of randomness

spawn_influencer[]:
-------------------
"type" - one of: "static", "friend", "enemy", "enemy_weapon", "vehicle", "projectile", "airstrike", "dead_friend", "game_mode", "dog"
"shape" - one of: "sphere", "cylinder", "pill", "cone", "box"
"forward" - worldspace forward vector
"up" - worldspace up vector
"origin" - worldspace origin
"radius" - for sphere, cylinder, pill, cone
"axis_length" - for cylinder, pill, cone
"width", "height", "depth" - for box
"score" - base influencer score
"score_curve" - one of: "constant", "linear" (1->0), "inverse_linear" (0->1), "negative_to_positive" (-1 -> +1)

level.recently_deceased["<teamname>"][]:
--------------------------
deceased.angles - angles of the deceased player at TOD
deceased.origin - origin of the deceased player at TOD
deceased.timeOfDeathMillis - GetTime() value (in milliseconds) at TOD
*/

/*QUAKED mp_uspawn_point (1.0 0.549 0.0) (-16 -16 0) (16 16 72)
Unified spawn point.  A player from any team can spawn here, based on spawn influencers.  Use dvar "useUnifiedSpawning" to enable. Use targetname "allies_start" or "axis_start" to put a start influencer at that spawn point.*/

/*QUAKED mp_uspawn_influencer (1 0 0) (-16 -16 -16) (16 16 16)
Static influencer for unified spawning system
"script_shape"					Shape of this influencer.  Supported shapes for Radiant-placed static influencers are "cylinder" and "sphere".
"radius"						Radius of the influencer ( whether cylinder or sphere ).
"height"						Height of the cylinder ( ignored for sphere shapes ).
"script_score"					The maximum influence this influencer can have.
"script_score_curve"			The shape of the score falloff as a function of the distance from the primary cylinder axis.  Options are: "constant", "linear", "inverse_linear", "negative_to_positive"
"script_team"					Make this influencer team-specific by specifying "axis" or "allies"
"script_gameobjectname"			Gametypes for which the influencer is active (space-separated values), can be "[all_modes]" or combination of "dm", "hq", "iwar", "war", "twar", "sd", "dom"
"script_twar_flag"				Used to associate this influencer with a specific twar flag
default:"script_shape"			"cylinder"
default:"radius"				"400"
default:"height"				"100"
default:"script_score"			"25"
default:"script_score_curve"	"constant"
default:"script_team"			"neutral"
default:"script_gameobjectname"	"[all_modes]"
default:"script_twar_flag"		"NONE"
*/

/* ---------- includes */

#include maps\mp\_utility;
#include maps\mp\_geometry;

/* ---------- initialization */

init()
{
	level init_spawn_system();
	
	level.teams= [];
	level.teams[ 0 ]= "allies";
	level.teams[ 1 ]= "axis";
	
	
	level.recently_deceased= [];
	for ( iTeam= 0; iTeam < level.teams.size; iTeam++ )
	{
		level.recently_deceased[ level.teams[ iTeam ] ]= spawn_array_struct();
	}
	
	level thread onPlayerConnect();
	
	//###nmorse $REVIEW from stefan: seems like the way rest of the game works for this sort of thing is to
	// spawn a thread which waits for the onPlayerKilled() signal?
	level.onPlayerKilledExtraUnthreadedCBs[ level.onPlayerKilledExtraUnthreadedCBs.size ]= ::player_died_callback;

	
	/#
	// this dvar stores the name for whom to display debug spawning information
	SetDvar("scr_debug_spawn_player", "");
	SetDvar("scr_debug_render_spawn_data", "1");
	SetDvar("scr_debug_render_snapshotmode", "0");
	// for testing spawn point placements
	SetDvar("scr_spawn_point_test_mode", "0");
	level.test_spawn_point_index= 0;
	//###stefan $NOTE turning off debug text only saves 1-2 sv ms/frame
	SetDvar("scr_debug_render_spawn_text", "1");
	// spawn thread for debug rendering of spawn influencer state
	thread spawn_influencers_debug_render_thread();
	#/

	return;
}

init_spawn_system()
{
	level.spawnsystem = spawnstruct();
	spawnsystem = level.spawnsystem;

	level thread initialize_player_spawning_dvars();
	
	// code enums - these must match the code versions
	spawnsystem.eINFLUENCER_SHAPE_SPHERE = 0;
	spawnsystem.eINFLUENCER_SHAPE_CYLINDER = 1;

	spawnsystem.eINFLUENCER_TYPE_NORMAL = 0;
	spawnsystem.eINFLUENCER_TYPE_PLAYER = 1;
	spawnsystem.eINFLUENCER_TYPE_WEAPON = 2;
	spawnsystem.eINFLUENCER_TYPE_DOG = 3;
	spawnsystem.eINFLUENCER_TYPE_VEHICLE = 4;
	spawnsystem.eINFLUENCER_TYPE_SQUAD = 5;
	spawnsystem.eINFLUENCER_TYPE_GAME_MODE = 6;

	spawnsystem.eINFLUENCER_CURVE_CONSTANT = 0;
	spawnsystem.eINFLUENCER_CURVE_LINEAR = 1;
	spawnsystem.eINFLUENCER_CURVE_INVERSE_LINEAR = 2;
	spawnsystem.eINFLUENCER_CURVE_NEGATIVE_TO_POSITIVE = 3;

	spawnsystem.iSPAWN_TEAMMASK_FREE = 1;
	spawnsystem.iSPAWN_TEAMMASK_AXIS = 2;
	spawnsystem.iSPAWN_TEAMMASK_ALLIES = 4;
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
		player thread onTeamChange();
		player thread onGrenadeThrow();
		player thread onSquadLeaderChange();
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
	
	created_influencers = false;
	for(;;)
	{
		self waittill( "spawned_player" );
		
		if ( !created_influencers )
		{
			self create_player_influencers();
			created_influencers = true;
		}
		
		self enable_player_influencers( true );
		self thread onDeath();
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
	self endon( "disconnect" );
	level endon ( "game_ended" );

	self waittill ( "death" );
	self enable_player_influencers( false );
	self create_body_influencers();
}

/*
=============
onTeamChange

Changes influencer teams when player changes teams
=============
*/
onTeamChange()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	while(1)
	{
		self waittill ( "joined_team" );
		self player_influencers_set_team();
		wait(0.05);
	}
}

/*
=============
onSquadLeaderChange

Adds removes the squad leader influencer
=============
*/
onSquadLeaderChange()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	while(1)
	{
		self waittill ( "squadleader_changed", squad_id, is_leader );
		
		// the inital squads will be created on connect we do not want this
		// created that early we will let the player influencer function create it
		if ( isdefined(self.spawn_influencers_created) )
		{
			if ( is_leader )
			{
				self create_squad_influencers();
			}
			else
			{
				self remove_squad_influencers();
			}
		}
		wait(0.05);
	}
}

/*
=============
onGrenadeThrow

Creates an influencer on grenade 
=============
*/
onGrenadeThrow()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	while(1)
	{
		self waittill ( "grenade_fire", grenade, weaponName );
		grenade create_grenade_influencers( self.pers["team"], weaponName );
		wait(0.05);
	}
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
}


get_team_mask( team )
{
	// this can be undefined on connect
	if ( !level.teambased || !isdefined(team))
	 return level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	 
	switch( team )
	{
	case "axis":
		return level.spawnsystem.iSPAWN_TEAMMASK_AXIS;
	case "allies":
		return level.spawnsystem.iSPAWN_TEAMMASK_ALLIES; 	
	case "all":
	return (level.spawnsystem.iSPAWN_TEAMMASK_FREE | level.spawnsystem.iSPAWN_TEAMMASK_AXIS |level.spawnsystem.iSPAWN_TEAMMASK_ALLIES);
	case "free":
	default:
		return level.spawnsystem.iSPAWN_TEAMMASK_FREE;	
	}
}

get_score_curve_index( curve )
{
	switch( curve )
	{
	case "linear":
		return level.spawnsystem.eINFLUENCER_CURVE_LINEAR; 	
	case "inverse_linear":
		return level.spawnsystem.eINFLUENCER_CURVE_LINEAR; 	
	case "negative_to_positive":
		return level.spawnsystem.eINFLUENCER_CURVE_NEGATIVE_TO_POSITIVE;
	case "constant":
	default:
		return level.spawnsystem.eINFLUENCER_CURVE_CONSTANT;
	}
}

get_influencer_type_index( curve )
{
//	switch( curve )
//	{
//	case "linear":
//		return level.spawnsystem.eINFLUENCER_CURVE_LINEAR; 	
//	case "inverse_linear":
//		return level.spawnsystem.eINFLUENCER_CURVE_LINEAR; 	
//	case "negative_to_positive":
//		return level.spawnsystem.eINFLUENCER_CURVE_NEGATIVE_TO_POSITIVE;
//	case "constant":
//	default:
//		return level.spawnsystem.eINFLUENCER_CURVE_CONSTANT;
//	}
}

create_player_influencers()
{
	assert( !isdefined(self.influencer_enemy_sphere) );
	assert( !isdefined(self.influencer_weapon_cylinder) );
	assert( !level.teambased || !isdefined(self.influencer_friendly_sphere) );
	assert( !level.teambased || !isdefined(self.influencer_friendly_cylinder) );

	if ( !level.teambased )
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		other_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		weapon_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else if ( isdefined( self.pers["team"] ) )
	{
		team_mask = get_team_mask( self.pers["team"] );
		other_team_mask = get_team_mask( getotherteam(self.pers["team"]) );
		weapon_team_mask = get_team_mask( getotherteam(self.pers["team"]) );
	}
	else
	{
		team_mask = 0;
		other_team_mask = 0;
		weapon_team_mask = 0;
	}

	// if this is hardcore then we do not want to spawn infront of the weapon either
	if ( level.hardcoreMode )
	{
		weapon_team_mask |= team_mask;
	}
	
	angles = self.angles;
	origin = self.origin;
//	up = AnglesToUp(angles);
//	forward = AnglesToForward(angles);
	up = (0,0,1);
	forward = (1,0,0);
	cylinder_forward = up;
	cylinder_up = forward;

	self.influencer_enemy_sphere = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_PLAYER,
																												 origin, 
																												 level.spawnsystem.enemy_influencer_radius,
																												 level.spawnsystem.enemy_influencer_score,
																												 other_team_mask,
																												 get_score_curve_index(level.spawnsystem.enemy_influencer_score_curve),
																												 0,
																												 self );

	self.influencer_weapon_cylinder = addcylinderinfluencer( level.spawnsystem.eINFLUENCER_TYPE_WEAPON,
																												 origin, 
																												 cylinder_forward,
																												 cylinder_up,
																												 level.spawnsystem.weapon_influencer_radius,
																												 level.spawnsystem.weapon_influencer_length,
																												 level.spawnsystem.weapon_influencer_score,
																												 weapon_team_mask,
																												 get_score_curve_index(level.spawnsystem.weapon_influencer_score_curve),
																												 0,
																												 self );

	if ( level.teambased )
	{
		// aim cylinder backwards for friends
		cylinder_up = -1.0 * forward;
	
		self.influencer_friendly_sphere = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_PLAYER,
																													 origin, 
																													 level.spawnsystem.friend_weak_influencer_radius,
																													 level.spawnsystem.friend_weak_influencer_score,
																													 team_mask,
																													 get_score_curve_index(level.spawnsystem.friend_weak_influencer_score_curve),
																													 0,
																													 self );
																													 
		self.influencer_friendly_cylinder = addcylinderinfluencer( level.spawnsystem.eINFLUENCER_TYPE_PLAYER,
																													 origin, 
																													 cylinder_forward,
																													 cylinder_up,
																													 level.spawnsystem.friend_strong_influencer_radius,
																													 level.spawnsystem.friend_strong_influencer_length,
																													 level.spawnsystem.friend_strong_influencer_score,
																													 team_mask,
																													 get_score_curve_index(level.spawnsystem.friend_strong_influencer_score_curve),
																													 0,
																													 self );
	
		if (IsSquadLeader(self))
		{
			create_squad_influencers();
		}
	}
	
	self.spawn_influencers_created = true;
	
	if ( !isdefined(self.pers["team"]) || self.pers["team"] == "spectator" )
	{
		self enable_player_influencers( false );
	}
}

remove_player_influencers()
{
	if ( level.teambased && isdefined(self.influencer_friendly_sphere) )
	{
		removeinfluencer(self.influencer_friendly_sphere);
		self.influencer_friendly_sphere = undefined;
	}
	if ( level.teambased && isdefined(self.influencer_friendly_cylinder) )
	{
		removeinfluencer(self.influencer_friendly_cylinder);
		self.influencer_friendly_cylinder = undefined;
	}
	if ( isdefined(self.influencer_enemy_sphere) )
	{
		removeinfluencer(self.influencer_enemy_sphere);
		self.influencer_enemy_sphere = undefined;
	}
	if ( isdefined(self.influencer_weapon_cylinder) )
	{
		removeinfluencer(self.influencer_weapon_cylinder);
		self.influencer_weapon_cylinder = undefined;
	}
	
	self remove_squad_influencers();
}

enable_player_influencers( enabled )
{
	if ( isdefined(self.influencer_friendly_sphere) )
		enableinfluencer(self.influencer_friendly_sphere, enabled);
	if ( isdefined(self.influencer_friendly_cylinder) )
		enableinfluencer(self.influencer_friendly_cylinder, enabled);
	if ( isdefined(self.influencer_enemy_sphere) )
		enableinfluencer(self.influencer_enemy_sphere, enabled);
	if ( isdefined(self.influencer_weapon_cylinder) )
		enableinfluencer(self.influencer_weapon_cylinder, enabled);
	if ( isdefined(self.influencer_squad) )
		enableinfluencer(self.influencer_squad, enabled);
}

player_influencers_set_team()
{
	if ( !level.teambased )
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		other_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		weapon_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else
	{
		team_mask = get_team_mask( self.pers["team"] );
		other_team_mask = get_team_mask( getotherteam(self.pers["team"]) );
		weapon_team_mask = get_team_mask( getotherteam(self.pers["team"]) );
	}
	
	// if this is hardcore then we do not want to spawn infront of the weapon either
	if ( level.hardcoreMode )
	{
		weapon_team_mask |= team_mask;
	}

	if ( isdefined(self.influencer_friendly_sphere) )
		setinfluencerteammask(self.influencer_friendly_sphere, team_mask);
	if ( isdefined(self.influencer_friendly_cylinder) )
		setinfluencerteammask(self.influencer_friendly_cylinder, team_mask);
	if ( isdefined(self.influencer_enemy_sphere) )
		setinfluencerteammask(self.influencer_enemy_sphere, other_team_mask);
	if ( isdefined(self.influencer_weapon_cylinder) )
		setinfluencerteammask(self.influencer_weapon_cylinder, weapon_team_mask);
	if ( isdefined(self.influencer_squad) )
		setinfluencerteammask(self.influencer_squad, weapon_team_mask);
}

create_squad_influencers()
{
	if ( level.teambased && !isdefined(self.influencer_squad) )
	{
		team_mask = get_team_mask( self.pers["team"] );
		
		self.influencer_squad = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_SQUAD,
																									self.origin, 
																								 level.spawnsystem.squad_leader_influencer_radius,
																								 level.spawnsystem.squad_leader_influencer_score,
																								 team_mask,
																								 get_score_curve_index(level.spawnsystem.squad_leader_influencer_score_curve),
																								 0,
																								 self );
	}
}

remove_squad_influencers()
{
	if ( isdefined(self.influencer_squad) )
	{
		removeinfluencer(self.influencer_squad);
		self.influencer_squad = undefined;
	}
}

create_body_influencers()
{
	if ( level.teambased )
	{
		team_mask = get_team_mask( self.pers["team"] );
	}
	else
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_NORMAL,
											 self.origin, 
											 level.spawnsystem.dead_friend_influencer_radius,
											 level.spawnsystem.dead_friend_influencer_score,
											 team_mask,
											 get_score_curve_index(level.spawnsystem.dead_friend_influencer_score_curve),
											 level.spawnsystem.dead_friend_influencer_timeout_seconds);
}

create_grenade_influencers( parent_team, weaponName )
{
	if ( !level.teambased )
	{
		weapon_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else
	{
		weapon_team_mask = get_team_mask( getotherteam(parent_team) );

		// if this is hardcore then we do not want to spawn infront of the weapon either
		if ( level.hardcoreMode )
		{
			weapon_team_mask |= get_team_mask( parent_team );
		}
	}
	
	if ( issubstr(weaponName,"napalmblob") || issubstr(weaponName,"gl_") )
	{
		return;
	}
	
	timeout = 0;
	
	// these have lasting effects after detonation so hang it around a bit longer 
	if ( weaponName == "tabun_gas_mp" || weaponName == "molotov_mp")
	{
		timeout = 7.0;
	}
	
	addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_NORMAL,
											 self.origin, 
											 level.spawnsystem.grenade_influencer_radius,
											 level.spawnsystem.grenade_influencer_score,
											 weapon_team_mask,
											 get_score_curve_index(level.spawnsystem.grenade_influencer_score_curve),
											 timeout,
											 self );
}

create_dog_influencers( )
{
	if ( !level.teambased )
	{
		dog_enemy_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else
	{
		dog_enemy_team_mask = get_team_mask( getotherteam(self.aiteam) );
	}
	
	addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_DOG,
											 self.origin, 
											 level.spawnsystem.dog_influencer_radius,
											 level.spawnsystem.dog_influencer_score,
											 dog_enemy_team_mask,
											 get_score_curve_index(level.spawnsystem.dog_influencer_score_curve),
											 0,
											 self );
}


create_artillery_influencers( point, radius )
{
	// just going to leave this blank to indicate all teams
	weapon_team_mask = 0;
	
	return addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_NORMAL,
											 point, 
											 radius,
											 level.spawnsystem.artillery_influencer_score,
											 weapon_team_mask,
											 get_score_curve_index(level.spawnsystem.artillery_influencer_score_curve) );
}

create_vehicle_influencers( )
{
	// just going to leave this blank to indicate all teams
	// because we dont want anyone spawning directly infront of the tank
	weapon_team_mask = 0;
	
	vehicleRadius= 144;
//	cylinderLength = (vehicleRadius*0.5) + (vehSpeedIPS*spawn_vehicle_influencer_lead_seconds);
	
	// code will always maintain the length at half the radius 
	// plus the given length * the vehicle speed in inches per second
	cylinderLength = level.spawnsystem.vehicle_influencer_lead_seconds;
	
	up = (0,0,1);
	forward = (1,0,0);
	cylinder_forward = up;
	cylinder_up = forward;
	
	return addcylinderinfluencer( level.spawnsystem.eINFLUENCER_TYPE_VEHICLE,
																	 self.origin, 
																	 cylinder_forward,
																	 cylinder_up,
																	 vehicleRadius,
																	 cylinderLength,
																	 level.spawnsystem.vehicle_influencer_score,
																	 weapon_team_mask,
																	 get_score_curve_index(level.spawnsystem.vehicle_influencer_score_curve),
																	 0,
																	 self );
}


create_map_placed_influencers()
{
	staticInfluencerEnts = GetEntArray( "mp_uspawn_influencer", "classname" );
	
	for ( i = 0; i < staticInfluencerEnts.size; i++ )
	{
		staticInfluencerEnt = staticInfluencerEnts[ i ];

		// don't include ones which have a twar-flag affiliation
		// those will be activated by twar code
		if (IsDefined(staticInfluencerEnt.script_gameobjectname) &&
			staticInfluencerEnt.script_gameobjectname=="twar")
		{
			continue;
		}
		
		create_map_placed_influencer(staticInfluencerEnt);
	}
}

create_map_placed_influencer(	influencer_entity, optional_score_override )
{
	influencer_id = -1;
	
	if (IsDefined(influencer_entity.script_shape) &&
		IsDefined(influencer_entity.script_score) &&
		IsDefined(influencer_entity.script_score_curve))
	{
		switch (influencer_entity.script_shape)
		{
			case "sphere":
			{
				if (IsDefined(influencer_entity.radius))
				{
					if (IsDefined(optional_score_override))
					{
						score= optional_score_override;
					}
					else
					{
						score= influencer_entity.script_score;
					}
					
					influencer_id = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
											 influencer_entity.origin, 
											 influencer_entity.radius,
											 score,
											 get_team_mask(influencer_entity.script_team),
											 get_score_curve_index(influencer_entity.script_score_curve) );
				}
				else
				{
					assertmsg( "Radiant-placed sphere spawn influencers require 'radius' parameter" );
				}
				break;
			}
			case "cylinder":
			{
				if (IsDefined(influencer_entity.radius) &&
					IsDefined(influencer_entity.height))
				{
					if (IsDefined(optional_score_override))
					{
						score= optional_score_override;
					}
					else
					{
						score= influencer_entity.script_score;
					}
					
					influencer_id  = addcylinderinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
																 influencer_entity.origin,
																 AnglesToForward(influencer_entity.angles), 
																 AnglesToUp(influencer_entity.angles),
																 influencer_entity.radius,
																 influencer_entity.height,
																 score,
																 get_team_mask(influencer_entity.script_team),
																 get_score_curve_index(influencer_entity.script_score_curve) );
				}
				else
				{
					assertmsg( "Radiant-placed cylinder spawn influencers require 'radius' and 'height' parameters" );
				}
				break;
			}
			default:
			{
				assertmsg( "Unsupported script_shape value (\""+influencer_entity.script_shape+"\") for unified spawning system static influencer.  Supported shapes are \"cylinder\" and \"sphere\"." );
				break;
			}
		}
	}
	else
	{
		assertmsg( "Radiant-placed spawn influencers require 'script_shape', 'script_score' and 'script_score_curve' parameters" );
	}
	
	return influencer_id;
}


updateAllSpawnPoints()
{
	// force spawn points to get precached
	gatherSpawnEntities( "allies" );
	gatherSpawnEntities( "axis" );
	
	// raise all the spawn points
//	raise_all_points_in_height( level.unified_spawn_points[ "allies" ] );
//	raise_all_points_in_height( level.unified_spawn_points[ "axis" ] );

	clearspawnpoints();
	
	if ( level.teambased )
	{
		addspawnpoints( "allies", level.unified_spawn_points[ "allies" ].a );
		addspawnpoints( "axis", level.unified_spawn_points[ "axis" ].a );
	}
	else
	{
		addspawnpoints( "free", level.unified_spawn_points[ "allies" ].a );
		addspawnpoints( "free", level.unified_spawn_points[ "axis" ].a );
	}
}

set_dvar_if_unset(
	dvar,
	value)
{
	if (GetDvar(dvar)=="")
	{
		SetDvar(dvar, value);
		return value;
	}
	
	return GetDvar(dvar);
}

set_dvar_float_if_unset(
	dvar,
	value)
{
	if (GetDvar(dvar)=="")
	{
		SetDvar(dvar, value);
	}
	
	return GetDvarFloat(dvar);
}

set_dvar_int_if_unset(
	dvar,
	value)
{
	if (GetDvar(dvar)=="")
	{
		SetDvar(dvar, value);
		return int(value);
	}
	
	return GetDvarInt(dvar);
}

initialize_player_spawning_dvars()
{
	while( 1 )
	{
		get_player_spawning_dvars();
		wait(2);  // dont need this to happen frequently
	}
}

get_player_spawning_dvars()
{
	k_player_height= get_player_height();
	player_height_times_10 = "" + 10.0*k_player_height;
	ss = level.spawnsystem;

	player_influencer_radius = 15.0*k_player_height;
	player_influencer_score = 150.0;
	dog_influencer_radius = 10.0*k_player_height;
	dog_influencer_score = 150.0;
	
	// this controls the original script driven influencer system
	ss.script_based_influencer_system =	set_dvar_int_if_unset("scr_script_based_influencer_system", "0");

	// general parameters
	// amount of randomness applied to spawning scores
	ss.randomness_range =	set_dvar_float_if_unset("scr_spawn_randomness_range", "10");
	// bonus applied to spawn points which face the current objective in certain objective-based games
	ss.objective_facing_bonus =	set_dvar_float_if_unset("scr_spawn_objective_facing_bonus", "50");
	
	// strong friend influencers are now a cylinder projected behind the player
	ss.friend_strong_influencer_score =	set_dvar_float_if_unset("scr_spawn_friend_strong_influencer_score", "75");
	ss.friend_strong_influencer_score_curve =	set_dvar_if_unset("scr_spawn_friend_strong_influencer_score_curve", "linear");
	ss.friend_strong_influencer_radius =	set_dvar_float_if_unset("scr_spawn_friend_strong_influencer_radius", player_height_times_10);
	ss.friend_strong_influencer_length =	set_dvar_float_if_unset("scr_spawn_friend_strong_influencer_length", player_height_times_10);
	
	// weak friend influencers are a sphere about the player
	ss.friend_weak_influencer_score =	set_dvar_float_if_unset("scr_spawn_friend_weak_influencer_score", "25");
	ss.friend_weak_influencer_score_curve =	set_dvar_if_unset("scr_spawn_friend_weak_influencer_score_curve", "linear");
	ss.friend_weak_influencer_radius =	set_dvar_float_if_unset("scr_spawn_friend_weak_influencer_radius", player_height_times_10);
	
	// squad leader influencer (applied in addition to other friendly player influencers)
	ss.squad_leader_influencer_score =	set_dvar_float_if_unset("scr_spawn_squad_leader_influencer_score", "50");
	ss.squad_leader_influencer_score_curve =	set_dvar_if_unset("scr_spawn_squad_leader_influencer_score_curve", "linear");
	ss.squad_leader_influencer_radius =	set_dvar_float_if_unset("scr_spawn_squad_leader_influencer_radius", player_height_times_10);
	
	// enemy player influencer
	ss.enemy_influencer_score =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_score", "-150");
	ss.enemy_influencer_score_curve =	set_dvar_if_unset("scr_spawn_enemy_influencer_score_curve", "linear");
	ss.enemy_influencer_radius =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_radius", player_height_times_10);
	
	// enemy weapon influencer
	ss.weapon_influencer_score =	set_dvar_float_if_unset("scr_spawn_weapon_influencer_score", "-100");
	ss.weapon_influencer_score_curve =	set_dvar_if_unset("scr_spawn_weapon_influencer_score_curve", "linear");
	ss.weapon_influencer_radius =	set_dvar_float_if_unset("scr_spawn_weapon_influencer_radius", "" + 5.0*k_player_height);
	ss.weapon_influencer_length =	set_dvar_float_if_unset("scr_spawn_weapon_influencer_length", "" + 25.0*k_player_height);
	
	// dead friends
	ss.dead_friend_influencer_timeout_seconds =	set_dvar_float_if_unset("scr_spawn_dead_friend_influencer_timeout_seconds", "20");
	ss.dead_friend_influencer_count =	set_dvar_float_if_unset("scr_spawn_dead_friend_influencer_count", "7");
	ss.dead_friend_influencer_score =	set_dvar_float_if_unset("scr_spawn_dead_friend_influencer_score", "-100");
	ss.dead_friend_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dead_friend_influencer_score_curve", "linear");
	ss.dead_friend_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dead_friend_influencer_radius", player_height_times_10);
	
	// moving vehicle influencer
	ss.vehicle_influencer_score =	set_dvar_float_if_unset("scr_spawn_vehicle_influencer_score", "-50");
	ss.vehicle_influencer_score_curve =	set_dvar_if_unset("scr_spawn_vehicle_influencer_score_curve", "linear");
	ss.vehicle_influencer_lead_seconds =	set_dvar_float_if_unset("scr_spawn_vehicle_influencer_lead_seconds", "3"); // The influencer will project out this far in time, based on vehicle speed
	
	// dog influencer
	ss.dog_influencer_score =	set_dvar_float_if_unset("scr_spawn_dog_influencer_score", "-50");
	ss.dog_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dog_influencer_score_curve", "linear");
	ss.dog_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dog_influencer_radius", player_height_times_10);
	
	// artillery strike influencer
	ss.artillery_influencer_score =	set_dvar_float_if_unset("scr_spawn_artillery_influencer_score", "-500");
	ss.artillery_influencer_score_curve =	set_dvar_if_unset("scr_spawn_artillery_influencer_score_curve", "linear");
	// radius determined @ runtime
	
	// grenade influencer
	ss.grenade_influencer_score =	set_dvar_float_if_unset("scr_spawn_grenade_influencer_score", "-500");
	ss.grenade_influencer_score_curve =	set_dvar_if_unset("scr_spawn_grenade_influencer_score_curve", "linear");
	ss.grenade_influencer_radius =	set_dvar_float_if_unset("scr_spawn_grenade_influencer_radius", "" + 8.0*k_player_height);
	
	// war: owned flag linked-influencer (used as baseline for al owned objectives)
	ss.twar_linked_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_twar_linked_flag_influencer_score", "200");
	ss.twar_linked_flag_near_objective_bonus =	set_dvar_float_if_unset("scr_spawn_twar_linked_flag_near_objective_bonus", "50");
	ss.twar_linked_flag_influencer_score_falloff_percentage =	set_dvar_float_if_unset("scr_spawn_twar_linked_flag_influencer_score_falloff_percentage", "0.2");
	
	// war: contested flag influencer (negative influencer generated programatically around the presently contested flag)
	ss.twar_contested_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_twar_contested_flag_influencer_score", "-500.0");
	ss.twar_contested_flag_influencer_score_curve =	set_dvar_if_unset("scr_spawn_twar_contested_flag_influencer_score_curve", "constant");
	ss.twar_contested_flag_influencer_radius =	set_dvar_float_if_unset("scr_spawn_twar_contested_flag_influencer_radius", "" + 15.0*k_player_height);
	
	// domination: owned outer flag influencers
	ss.dom_owned_outer_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_dom_owned_outer_flag_influencer_score", "100");
	ss.dom_owned_outer_flag_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dom_owned_outer_flag_influencer_score_curve", "constant");
	ss.dom_owned_outer_flag_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dom_owned_outer_flag_influencer_radius", "" + 15.0*k_player_height);
	
	// domination: owned inner flag influencers
	ss.dom_owned_inner_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_dom_owned_inner_flag_influencer_score", "150");
	ss.dom_owned_inner_flag_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dom_owned_inner_flag_influencer_score_curve", "constant");
	ss.dom_owned_inner_flag_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dom_owned_inner_flag_influencer_radius", "" + 15.0*k_player_height);
	
	// domination: enemy flag influencers
	ss.dom_enemy_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_influencer_score", "-500");
	ss.dom_enemy_flag_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dom_enemy_flag_influencer_score_curve", "constant");
	ss.dom_enemy_flag_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dom_enemy_flag_influencer_radius", "" + 15.0*k_player_height);
	
	// domination: un-owned inner flag influencers
	ss.dom_unowned_inner_flag_influencer_score =	set_dvar_float_if_unset("scr_spawn_dom_unowned_inner_flag_influencer_score", "-500");
	ss.dom_unowned_inner_flag_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dom_unowned_inner_flag_influencer_score_curve", "constant");
	ss.dom_unowned_inner_flag_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dom_unowned_inner_flag_influencer_radius", "" + 15.0*k_player_height);
	
	// koth (hq): influencer placed around the radio
	ss.koth_objective_influencer_score =	set_dvar_float_if_unset("scr_spawn_koth_objective_influencer_score", "150");
	ss.koth_objective_influencer_score_curve =	set_dvar_if_unset("scr_spawn_koth_objective_influencer_score_curve", "negative_to_positive");
	ss.koth_objective_influencer_radius =	set_dvar_float_if_unset("scr_spawn_koth_objective_influencer_radius", "" + 35.0*k_player_height);
	
	// sabotage: influencer around friendly base
	ss.sab_friendly_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_sab_friendly_base_influencer_score", "100");
	ss.sab_friendly_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_sab_friendly_base_influencer_score_curve", "constant");
	ss.sab_friendly_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_sab_friendly_base_influencer_radius", "" + 15.0*k_player_height);
	
	// sabotage: influencer around enemy base
	ss.sab_enemy_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_sab_enemy_base_influencer_score", "-500");
	ss.sab_enemy_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_sab_enemy_base_influencer_score_curve", "constant");
	ss.sab_enemy_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_sab_enemy_base_influencer_radius", "" + 15.0*k_player_height);
	
	// sabotage: negative influencer around carrier
	ss.sab_carrier_influencer_score =	set_dvar_float_if_unset("scr_spawn_sab_carrier_influencer_score", "-75");
	ss.sab_carrier_influencer_score_curve =	set_dvar_if_unset("scr_spawn_sab_carrier_influencer_score_curve", "linear");
	ss.sab_carrier_influencer_radius =	set_dvar_float_if_unset("scr_spawn_sab_carrier_influencer_radius", "" + 8.0*k_player_height);
	
	// ctf: influencer around friendly base
	ss.ctf_friendly_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_base_influencer_score", "100");
	ss.ctf_friendly_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_friendly_base_influencer_score_curve", "constant");
	ss.ctf_friendly_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_base_influencer_radius", "" + 15.0*k_player_height);

	// ctf: influencer around enemy base
	ss.ctf_enemy_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_base_influencer_score", "-500");
	ss.ctf_enemy_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_enemy_base_influencer_score_curve", "constant");
	ss.ctf_enemy_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_base_influencer_radius", "" + 15.0*k_player_height);
	
	// ctf: negative influencer around carrier
	ss.ctf_carrier_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_carrier_influencer_score", "-75");
	ss.ctf_carrier_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_carrier_influencer_score_curve", "constant");
	ss.ctf_carrier_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_carrier_influencer_radius", "" + 8.0*k_player_height);

	setspawnpointrandomvariation( ss.randomness_range );
}

level_use_unified_spawning( use )
{
//	if ( use )
//	{
//		level.onSpawnPlayerUnified = ::onSpawnPlayer_Unified;
//	}
//	else
//	{
//		level.onSpawnPlayerUnified = undefined;
//	}
}


/* ---------- spawn_point */

//void - self= player entity for the player who is spawning
onSpawnPlayer_Unified()
{
	prof_begin("onSpawnPlayer_Unified");
	
	use_new_spawn_system= true;
	initial_spawn= true;
	
	if (IsDefined(self.uspawn_already_spawned))
	{
		initial_spawn= !self.uspawn_already_spawned;
	}
	
	// is this the player's first spawn into the game?
	if (initial_spawn) 
	{
		// if less than 45 seconds into the match, use initial spawn logic; otherwise, treat this as a respawn
		// on initial spawns, it was decided that we want to use the pre-existing, designer placed
		// spawn points particular to the game mode being played. therefor, in this case we call the
		// old spawning logic
		k_allow_initial_spawn_logic_duration_milliseconds= 45000;
		k_current_time= GetTime();
		
		if (k_current_time <= k_allow_initial_spawn_logic_duration_milliseconds)
		{
			use_new_spawn_system= false;
		}
	}
	
	// no respawn points for search & destroy, so don't run the new spawning system (it would needlessly abort on respawn attempt otherwise)
	if (level.gametype=="sd")
	{
		use_new_spawn_system= false;
	}
	
	if (use_new_spawn_system)
	{
		// find the most desireable spawn point, and spawn there
		spawn_point= getSpawnPoint(self);
		
		if (IsDefined(spawn_point))
		{
			self spawn( spawn_point.origin, spawn_point.angles );
		}
		else
		{
			println("ERROR: unable to locate a usable spawn point for player");
			maps\mp\gametypes\_callbacksetup::AbortLevel();
		}
	}
	else
	{
		// old spawning logic
		[[level.onSpawnPlayer]]();
	}
	
	// remember that the player has initially spawned
	self.uspawn_already_spawned= true;
	
	prof_end("onSpawnPlayer_Unified");

	return;
}

// spawnPoint: .origin, .angles
getSpawnPoint(
	player_entity)
{
	if (level.teambased )
	{
		team= player_entity.pers["team"];
	}
	else
	{
		team = "free";
	}

	if (level.teambased && IsDefined(game["switchedsides"]) &&	game["switchedsides"])
	{
		team= GetOtherTeam(team);
	}
	
	if ( level.spawnsystem.script_based_influencer_system )
	{
		best_spawn_entity= undefined;
		spawnEntities_s= gatherSpawnEntities(team);
		bestIndex= spawning_find_best_spawn_entity_for_player(player_entity, spawnEntities_s);
		
		if (bestIndex >= 0)
		{
			best_spawn_entity= spawnEntities_s.a[bestIndex];
		}
	}
	else
	{
		best_spawn_entity = get_best_spawnpoint( team, player_entity );
	}
	
	return best_spawn_entity;
}

get_best_spawnpoint( team, player )
{
	scored_spawn_points = getsortedspawnpoints( team, player );
	assert(scored_spawn_points.size > 0 );
	
	for (i = 0 ; i < scored_spawn_points.size; i++)
	{
		scored_spawn = scored_spawn_points[i];
		if (!PositionWouldTelefrag(scored_spawn_points[i].origin))
		{
			return scored_spawn_points[i];
		}
	}
	
	// could not find anything
	return scored_spawn_points[0];
}

// struct.a[] = a contains spawn entities
gatherSpawnEntities( player_team )
{	
	// use cached spawn points when they are available
	if ( !IsDefined( level.unified_spawn_points ) )
	{
		level.unified_spawn_points = [];
	}
	else
	{
		if ( IsDefined( level.unified_spawn_points[ player_team ] ) )
		{
			return level.unified_spawn_points[ player_team ];
		}
	}
	
	spawn_entities_s= spawn_array_struct();
	
	// We grab both new & old spawn points here. The idea is
	// that there are alot of maps already setup & designers are not
	// going to want to lay down new spawn points. So, just use the existing points
	// for each game mode.
	// For new maps, designers now only have to lay down one set of points
	// instead of one set *per game mode* (the new unified spawn points).
	// This system here allows the use of either or both.
	
	// get placed unified spawn points (the new world order)
	spawn_entities_s.a= GetEntArray( "mp_uspawn_point", "classname" );
	if ( !IsDefined(spawn_entities_s.a))
	{
		spawn_entities_s.a= [];
	}
	// also gather any old-style spawn points (the old world order)
	legacy_spawn_points= maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints(player_team);
	for (legacy_spawn_index= 0; legacy_spawn_index<legacy_spawn_points.size; legacy_spawn_index++)
	{
		spawn_entities_s.a[spawn_entities_s.a.size]= legacy_spawn_points[legacy_spawn_index];
	}
	
	level.unified_spawn_points[player_team]= spawn_entities_s;
	
	return spawn_entities_s;
}

// returns integer index of best spawn entity in spawn_entity_list[], or -1 if none is found
spawning_find_best_spawn_entity_for_player(
	player_entity,
	spawn_entities_s)
{
	prof_begin("spawning_find_best_spawn_entity_for_player");
	prof_begin("generate_points_list_from_entity_list");
	// generate list of available spawn points
	points_list_s= generate_points_list_from_entity_list(spawn_entities_s);
	prof_end("generate_points_list_from_entity_list");
	
	// generate list of applicable spawn influencers
	spawnInfluencers_s= spawn_influencers_generate_for_player_spawn(player_entity);
	
	// test spawn points against spawn influencers
	scored_spawn_points_s= score_spawn_points_against_influencers(player_entity, points_list_s, spawn_entities_s, spawnInfluencers_s);
	
	
	// return most desirable spawn point
	best_spawn_entity_index= get_best_spawn_point_index(spawn_entities_s, scored_spawn_points_s);
	
	if (0<=best_spawn_entity_index && best_spawn_entity_index<spawn_entities_s.a.size)
	{
		debug_cache_spawn_snapshot( player_entity, spawnInfluencers_s, spawn_entities_s.a[ best_spawn_entity_index ] );
	}
	prof_end("spawning_find_best_spawn_entity_for_player");
	
	return best_spawn_entity_index;
}


debug_cache_spawn_snapshot( player_entity, spawnInfluencers_s, actual_spawn_point_ent )
{
	/#
	if ( !IsDefined( level.debug_uspawn_snapshots ) )
	{
		level.debug_uspawn_snapshots = [];
	}
	
	snapshot = SpawnStruct();
	snapshot.player_team = player_entity.pers[ "team" ]; // this is to help us build spawn points later
	snapshot.spawn_influencers_s = spawnInfluencers_s;
	
	snapshot.actual_spawn_point_cylinder = create_cylinder_influencer(
		"actual_spawn",
		AnglesToForward( actual_spawn_point_ent.angles ),
		AnglesToUp( actual_spawn_point_ent.angles ),
		actual_spawn_point_ent.origin,
		0,
		"constant",
		15, // radius - player is 30 wide
		get_player_height()
		);
	
	level.debug_uspawn_snapshots[ player_entity.name ] = snapshot;
	#/
}


// render debug spawning information
spawn_influencers_debug_render_thread()
{
/#
	while (true)
	{
		debug_player= undefined;
		debug_spawn_player_name= GetDvar("scr_debug_spawn_player");
		
		if (debug_spawn_player_name != "")
		{
			// is player on allies team?
			allies_team_players_s= get_team_alive_players_s("allies");
			for (player_index= 0; player_index<allies_team_players_s.a.size; player_index++)
			{
				player= allies_team_players_s.a[player_index];
				
				if (player.name==debug_spawn_player_name)
				{
					debug_player= player;
					break;
				}
			}
			// is player on axis team?
			if (!IsDefined(debug_player))
			{
				axis_team_players_s= get_team_alive_players_s("axis");
				for (player_index= 0; player_index<axis_team_players_s.a.size; player_index++)
				{
					player= axis_team_players_s.a[player_index];
					
					if (player.name==debug_spawn_player_name)
					{
						debug_player= player;
						break;
					}
				}
			}
		}

		// don't render if game has ended
		if (IsDefined(debug_player) && !level.GameEnded)
		{
			player_height= get_player_height();
			spawn_entities_s= undefined;
			spawn_influencers_s= undefined;
			
			// Gather available spawn entities and build influencer list
			if (GetDvarInt("scr_debug_render_snapshotmode") != 0 )
			{
				if ( IsDefined( level.debug_uspawn_snapshots ) )
				{
					snapshot = level.debug_uspawn_snapshots[ debug_player.name ];
					
					if ( IsDefined( snapshot ) )
					{
						spawn_entities_s = gatherSpawnEntities( snapshot.player_team );
						spawn_influencers_s = snapshot.spawn_influencers_s;
						
						// Draw a blue cylinder to indicate which spawn point was actually used
						debug_render_spawn_influencer( snapshot.actual_spawn_point_cylinder, ( 0, 0, 1 ) );
					}
				}
			}
			
			// If we don't want to use the last snapshot, OR if one is not available
			if ( !IsDefined( spawn_entities_s ) )
			{
				team= debug_player.pers["team"];
				if (IsDefined(game["switchedsides"]) &&
					game["switchedsides"])
				{
					team= GetOtherTeam(team);
				}
				spawn_entities_s= gatherSpawnEntities(team);
				spawn_influencers_s= spawn_influencers_generate_for_player_spawn( debug_player );
			}
			
			// generate list of available spawn points
			points_list_s= generate_points_list_from_entity_list( spawn_entities_s );
			// test spawn points against spawn influencers
			scored_spawn_points_s= score_spawn_points_against_influencers(debug_player, points_list_s, spawn_entities_s, spawn_influencers_s);
			
			// for profiling spawn calculation overhead, it's useful to turn debug spawning on,
			// but not actually render anything, to simulate spawning a player every frame
			if (GetDvarInt("scr_debug_render_spawn_data")==1)
			{
				// render spawn point scores
				debug_render_scored_spawn_points(spawn_entities_s, scored_spawn_points_s);
				// render influencer geometry
				debug_render_spawn_influencers(spawn_influencers_s);
			}
		}
		
		wait(0.01);
	}
#/

	return;
}

/* ---------- private code */

/* ---------- spawn_influencer */

//struct.a[]= point3d[] points
generate_points_list_from_entity_list(
	entities_s )
{
	point_offset= ( 0.0, 0.0, 0.5 * get_player_height() );
	
	pointsList_s= spawn_array_struct();
	
	for ( i= 0; i < entities_s.a.size; i++ )
	{
		pointsList_s.a[ i ]= point3d_translate( entities_s.a[ i ] GetOrigin(), point_offset );
	}
	
	return pointsList_s;
}


//spawn_influencers_s.a[]
spawn_influencers_generate_for_player_spawn(
	player_entity)
{
	prof_begin("spawn_influencers_generate_for_player_spawn");
	
	spawnInfluencers_s= spawn_array_struct();
	
	generate_static_influencers( spawnInfluencers_s, player_entity );
	generate_friend_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_squad_leader_spawn_influencer(spawnInfluencers_s, player_entity);
	generate_enemy_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_enemy_weapon_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_vehicle_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_projectile_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_dog_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_artillery_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_dead_friend_spawn_influencers( spawnInfluencers_s, player_entity );
	generate_game_mode_spawn_influencers( spawnInfluencers_s, player_entity );

	prof_end("spawn_influencers_generate_for_player_spawn");
	
	return spawnInfluencers_s;
}

/* ###stefan $NOTE we no longer use the unified spawn system for initial spawns; initial spawns use designer placed points as before
//###stefan $TODO spawnPoints should be replaced with an entity list of initial spawn influencers
//spawn_influencers_s.a[]
generate_initial_spawn_influencers( influencers_s, player_entity, spawnPoints_s )
{
	targetname= player_entity.team + "_start";
	
	player_height= get_player_height();
	
	for ( i= 0; i < spawnPoints_s.a.size; i++ )
	{
		spawnPoint= spawnPoints_s.a[ i ];
		
		if ( ( IsDefined( spawnPoint.targetname ) && ( spawnPoint.targetname == targetname ) )
			|| ( IsSubStr( spawnPoint.classname, player_entity.team ) && IsSubStr( spawnPoint.classname , "start" ) ) )
		{
			influencer_height= 2*player_height;
			influencer_origin= point3d_translate(spawnPoint GetOrigin(), (0, 0, -0.5*influencer_height));
			
			influencers_s.a[ influencers_s.a.size ]= create_cylinder_influencer(
				"static",
				AnglesToForward( spawnPoint.angles ),
				AnglesToUp( spawnPoint.angles ),
				influencer_origin,
				2, ///<= params.score
				"linear", ///< params.score_curve
				10 * player_height, ///< params.radius
				influencer_height ///< params.axis_length
				);
		}
	}
	
	return influencers_s;
}
*/

// spawn_influencers_s.a[]
generate_static_influencers(
	influencers_s,
	player_entity )
{
	player_team = player_entity.pers[ "team" ];
	
	staticInfluencerEnts = GetEntArray( "mp_uspawn_influencer", "classname" );
	
	for ( i = 0; i < staticInfluencerEnts.size; i++ )
	{
		staticInfluencerEnt = staticInfluencerEnts[ i ];
		
		// don't include ones that don't match our team
		if ( IsDefined( staticInfluencerEnt.script_team )
			&& staticInfluencerEnt.script_team != "neutral"
			&& staticInfluencerEnt.script_team != player_team )
		{
			continue;
		}
		
		// don't include ones which have a twar-flag affiliation
		// those will be activated by twar code
		if (IsDefined(staticInfluencerEnt.script_gameobjectname) &&
			staticInfluencerEnt.script_gameobjectname=="twar")
		{
			continue;
		}
		
		generate_designer_placed_spawn_influencer(influencers_s, staticInfluencerEnt, "static");
	}
	
	return influencers_s;
}

// spawn_influencers_s.a[]
generate_friend_spawn_influencers(
	influencers_s,
	player_entity )
{
	// strong friend influencers are now a cylinder projected behind the player
	spawn_friend_strong_influencer_score= level.spawnsystem.friend_strong_influencer_score;
	spawn_friend_strong_influencer_score_curve= level.spawnsystem.friend_strong_influencer_score_curve;
	spawn_friend_strong_influencer_radius= level.spawnsystem.friend_strong_influencer_radius;
	spawn_friend_strong_influencer_length= level.spawnsystem.friend_strong_influencer_length;

	// weak friend influencers are a sphere about the player
	spawn_friend_weak_influencer_score= level.spawnsystem.friend_weak_influencer_score;
	spawn_friend_weak_influencer_score_curve= level.spawnsystem.friend_weak_influencer_score_curve;
	spawn_friend_weak_influencer_radius= level.spawnsystem.friend_weak_influencer_radius;
	
	team_players_s= get_team_alive_players_s(player_entity GetTeam());
	
	for (player_index= 0; player_index < team_players_s.a.size; player_index++)
	{
		team_player= team_players_s.a[player_index];
		
		if (player_entity!=team_player)
		{
			angles= team_player GetPlayerAngles();
			origin= team_player GetOrigin();
			up= AnglesToUp(angles);
			forward= AnglesToForward(angles);
			cylinder_forward= up;
			// aim cylinder backwards
			cylinder_up= -1.0*forward;
			
			// create strong friend influencer (cylinder projected behind the player)
			influencers_s.a[influencers_s.a.size]= create_cylinder_influencer(
				"friend",
				cylinder_forward,
				cylinder_up,
				// vertically center about their origin
				point3d_translate(origin, (0, 0, -0.5*spawn_friend_strong_influencer_length)),
				spawn_friend_strong_influencer_score,
				spawn_friend_strong_influencer_score_curve,
				spawn_friend_strong_influencer_radius,
				spawn_friend_strong_influencer_length);
			
			// create weak friend influencer (sphere projected around player)
			influencers_s.a[influencers_s.a.size]= create_sphere_influencer(
				"friend",
				forward,
				up,
				origin,
				spawn_friend_weak_influencer_score,
				spawn_friend_weak_influencer_score_curve,
				spawn_friend_weak_influencer_radius);
		}
	}
	
	return influencers_s;
}

// spawn_influencers_s.a[]
generate_squad_leader_spawn_influencer(
	influencers_s,
	player_entity)
{
	// squad leader influencer (applied in addition to other friendly player influencers)
	spawn_squad_leader_influencer_score= level.spawnsystem.squad_leader_influencer_score;
	spawn_squad_leader_influencer_score_curve= level.spawnsystem.squad_leader_influencer_score_curve;
	spawn_squad_leader_influencer_radius= level.spawnsystem.squad_leader_influencer_radius;
	
	team_players_s= get_team_alive_players_s(player_entity.team);
	
	for (player_index= 0; player_index<team_players_s.a.size; player_index++ )
	{
		if (team_players_s.a[player_index] != player_entity &&
			IsSquadLeader(team_players_s.a[player_index]))
		{
			angles= team_players_s.a[player_index] GetPlayerAngles();
			influencers_s.a[influencers_s.a.size]= create_sphere_influencer(
				"squad_leader",
				AnglesToForward(angles),
				AnglesToUp(angles),
				team_players_s.a[player_index] GetOrigin(),
				spawn_squad_leader_influencer_score,
				spawn_squad_leader_influencer_score_curve,
				spawn_squad_leader_influencer_radius);
			break;
		}
	}
	
	return influencers_s;
}

// spawn_influencers_s.a[]
generate_enemy_spawn_influencers(
	influencers_s,
	player_entity )
{
	// enemy player influencer
	spawn_enemy_influencer_score= level.spawnsystem.enemy_influencer_score;
	spawn_enemy_influencer_score_curve= level.spawnsystem.enemy_influencer_score_curve;
	spawn_enemy_influencer_radius= level.spawnsystem.enemy_influencer_radius;
	
	for (team_index= 0; team_index< level.teams.size; team_index++ )
	{
		team_name= level.teams[team_index];
		
		if (teams_have_enmity(player_entity.team, team_name))
		{
			// generate an enemy influencer for each player on this enemy team
			team_players_s= get_team_alive_players_s(team_name);
			
			for (player_index= 0; player_index < team_players_s.a.size; player_index++)
			{
				angles= team_players_s.a[player_index] GetPlayerAngles();
				
				// enemy influencer is a sphere
				influencers_s.a[influencers_s.a.size]= create_sphere_influencer(
					"enemy",
					AnglesToForward(angles),
					AnglesToUp(angles),
					team_players_s.a[player_index] GetOrigin(),
					spawn_enemy_influencer_score,
					spawn_enemy_influencer_score_curve,
					spawn_enemy_influencer_radius);
			}
		}
	}
	
	return influencers_s;
}

generate_designer_placed_spawn_influencer(
	influencers_s,
	influencer_entity,
	influencer_type,
	optional_score_override)
{
	if (IsDefined(influencer_entity.script_shape) &&
		IsDefined(influencer_entity.script_score) &&
		IsDefined(influencer_entity.script_score_curve))
	{
		switch (influencer_entity.script_shape)
		{
			case "sphere":
			{
				if (IsDefined(influencer_entity.radius))
				{
					if (IsDefined(optional_score_override))
					{
						score= optional_score_override;
					}
					else
					{
						score= influencer_entity.script_score;
					}
					
					influencers_s.a[influencers_s.a.size]= create_sphere_influencer(
						influencer_type,
						AnglesToForward(influencer_entity.angles),
						AnglesToUp(influencer_entity.angles),
						influencer_entity.origin,
						score,
						influencer_entity.script_score_curve,
						influencer_entity.radius);
				}
				else
				{
					assertmsg( "Radiant-placed sphere spawn influencers require 'radius' parameter" );
				}
				break;
			}
			case "cylinder":
			{
				if (IsDefined(influencer_entity.radius) &&
					IsDefined(influencer_entity.height))
				{
					if (IsDefined(optional_score_override))
					{
						score= optional_score_override;
					}
					else
					{
						score= influencer_entity.script_score;
					}
					
					influencers_s.a[influencers_s.a.size]= create_cylinder_influencer(
						influencer_type,
						AnglesToForward(influencer_entity.angles),
						AnglesToUp(influencer_entity.angles),
						influencer_entity.origin,
						score,
						influencer_entity.script_score_curve,
						influencer_entity.radius,
						influencer_entity.height);
				}
				else
				{
					assertmsg( "Radiant-placed cylinder spawn influencers require 'radius' and 'height' parameters" );
				}
				break;
			}
			default:
			{
				assertmsg( "Unsupported script_shape value (\""+influencer_entity.script_shape+"\") for unified spawning system static influencer.  Supported shapes are \"cylinder\" and \"sphere\"." );
				break;
			}
		}
	}
	else
	{
		assertmsg( "Radiant-placed spawn influencers require 'script_shape', 'script_score' and 'script_score_curve' parameters" );
	}
	
	return influencers_s;
}

// These functions add the new influencers to the provided influencers array.

// influencers.a[]
_generate_weapon_spawn_influencers(
	influencers_s,
	player,
	enemy_team_name,
	influencer_parameters )
{
	//half_player_height= 0.5*get_player_height();
	
	spawn_weapon_influencer_score= level.spawnsystem.weapon_influencer_score;
	spawn_weapon_influencer_score_curve= level.spawnsystem.weapon_influencer_score_curve;
	spawn_weapon_influencer_radius= level.spawnsystem.weapon_influencer_radius;
	spawn_weapon_influencer_length= level.spawnsystem.weapon_influencer_length;
	
	enemy_players_s= get_team_alive_players_s(enemy_team_name);
	
	for (player_index= 0; player_index<enemy_players_s.a.size; player_index++ )
	{
		enemy_player= enemy_players_s.a[player_index];
		
		vehicle= enemy_player GetVehicleOccupied();
		// is the player in a vehicle?
		if (!IsDefined(vehicle))
		{
			// the player is NOT in a vehicle
			enemy_player_origin= enemy_player GetOrigin();
			angles= enemy_player GetPlayerAngles();
			enemy_player_forward= AnglesToForward(angles);
			enemy_player_up= AnglesToUp(angles);
			/* ###stefan $OPTIMIZATION make weapon influencers cylinders instead of cones
			cone_height_unit_vector= -1*enemy_player_forward;
			cone_radial_unit_vector= enemy_player_up;
			cone_base= point3d_translate(enemy_player_origin, (enemy_player_forward*influencer_parameters.axis_length)+(0, 0, half_player_height));
			
			influencers_s.a[influencers_s.a.size]=
				create_cone_influencer(
					"enemy_weapon",
					cone_radial_unit_vector,
					cone_height_unit_vector,
					cone_base,
					spawn_weapon_influencer_score,
					spawn_weapon_influencer_score_curve,
					spawn_weapon_influencer_radius,
					spawn_weapon_influencer_length);*/
			influencers_s.a[influencers_s.a.size]=
				create_cylinder_influencer(
					"enemy_weapon",
					enemy_player_up,
					enemy_player_forward,
					enemy_player_origin,
					spawn_weapon_influencer_score,
					spawn_weapon_influencer_score_curve,
					spawn_weapon_influencer_radius,
					spawn_weapon_influencer_length);
		}
		else // the player is in a vehicle
		{
			seatIndex= vehicle GetOccupantSeat( enemy_player );
			
			if (!(vehicle SeatHasWeapon(seatIndex)))
			{
				continue;
			}
			
			barrelOrigin= vehicle GetSeatFiringOrigin(seatIndex);
			barrelAngles= vehicle GetSeatFiringAngles(seatIndex);
			
			if (IsDefined(barrelOrigin) && IsDefined(barrelAngles))
			{
				cylinderUp= AnglesToForward(barrelAngles);
				cylinderForward= AnglesToUp(barrelAngles);
				
				influencers_s.a[ influencers_s.a.size ]=
					create_cylinder_influencer(
						"enemy_weapon",
						cylinderForward,
						cylinderUp,
						barrelOrigin,
						spawn_weapon_influencer_score,
						spawn_weapon_influencer_score_curve,
						spawn_weapon_influencer_radius,
						spawn_weapon_influencer_length);
			}
		}
	}
	
	return influencers_s;
}

is_hardcore()
{
	return IsDefined( level.hardcoreMode )
		&& level.hardcoreMode;
}

teams_have_enmity(
	team1,
	team2)
{
	// If either is undefined, then we don't know; assume they are enemies.
	// If the game is straight-up deathmatch, everyone is enemies (regardless of their assigned teams).
	if ( !IsDefined( team1 ) || !IsDefined( team2 ) || (level.gameType=="dm"))
		return true;
	
	return team1 != "neutral"
		&& team2 != "neutral"
		&& team1 != team2;
}

//spawn_influencers_s.a[]
generate_enemy_weapon_spawn_influencers(
	influencers_s,
	player_entity )
{
	teams= level.teams;

	for (team_index= 0; team_index<teams.size; team_index++ )
	{
		enemy_team_name= teams[team_index];

		if (teams_have_enmity(enemy_team_name, player_entity.team) || is_hardcore())
		{
			_generate_weapon_spawn_influencers(
				influencers_s,
				player_entity,
				enemy_team_name);
		}
	}

	return influencers_s;
}

generate_vehicle_spawn_influencers(
	influencers_s, // generated by spawn_array_struct(), struct that contains an array
	player_entity )
{
	// moving vehicle influencer
	spawn_vehicle_influencer_score= level.spawnsystem.vehicle_influencer_score;
	spawn_vehicle_influencer_score_curve= level.spawnsystem.vehicle_influencer_score_curve;
	spawn_vehicle_influencer_lead_seconds= level.spawnsystem.vehicle_influencer_lead_seconds;

	playerTeam= player_entity GetTeam();
	
	vehicles= GetEntArray( "script_vehicle", "classname" );
	
	for (vehicle_index= 0; vehicle_index < vehicles.size; vehicle_index++)
	{
		vehicle= vehicles[vehicle_index];
				
		if (!teams_have_enmity(vehicle GetTeam(), playerTeam) && !is_hardcore())
		{
			continue;
		}
		
		// If vehicle has no driver, then skip
		if (!IsDefined(vehicle GetSeatOccupant(0)))
		{
			continue;
		}
		
		vehicleOrigin= vehicle GetOrigin();
		vehicleAngles= vehicle GetAngles();
		
		// No pitch, always project forward in ground plane
		vehicleAngles= (0, vehicleAngles[ 1 ], vehicleAngles[ 2 ]);
		
		vehSpeedIPS= vehicle GetSpeed();
		
		if (vehSpeedIPS < 0)
		{
			vehSpeedIPS= 0 - vehSpeedIPS;
			vehicleAngles= (vehicleAngles[ 0 ], vehicleAngles[ 1 ] + 180, vehicleAngles[ 2 ]);
		}
		
		vehicleForward= AnglesToForward(vehicleAngles);
		vehicleUp= AnglesToUp(vehicleAngles);
		
		vehicleRadius= 144;
		cylinderLength= (vehicleRadius*0.5) + (vehSpeedIPS*spawn_vehicle_influencer_lead_seconds);
		
		cylinderForward= vehicleUp;
		cylinderUp= vehicleForward;
		cylinderRadius= vehicleRadius + vehSpeedIPS;
		
		influencers_s.a[influencers_s.a.size]=
			create_cylinder_influencer(
				"vehicle",
				cylinderForward,
				cylinderUp,
				vehicleOrigin,
				spawn_vehicle_influencer_score,
				spawn_vehicle_influencer_score_curve,
				cylinderRadius,
				cylinderLength);
	}

	return;
}

generate_projectile_spawn_influencers(
	influencers_s,
	player_entity )
{
	// grenade influencers
	spawn_grenade_influencer_score= level.spawnsystem.grenade_influencer_score;
	spawn_grenade_influencer_score_curve= level.spawnsystem.grenade_influencer_score_curve;
	spawn_grenade_influencer_radius= level.spawnsystem.grenade_influencer_radius;
	
	playerTeam= player_entity GetTeam();
	
	grenades= GetEntArray("grenade", "classname");
	
	for (grenade_index= 0; grenade_index<grenades.size; grenade_index++ )
	{
		/*###stefan $REVIEW even in non-hardcore games, friendly grenades will kill you
		//if (teams_have_enmity(grenade GetTeam(), playerTeam) || is_hardcore())*/
		{
			influencers_s.a[influencers_s.a.size]= create_sphere_influencer(
				"projectile",
				(1.0, 0.0, 0.0), // forward
				(0.0, 0.0, 1.0), // up
				grenades[grenade_index] GetOrigin(),
				spawn_grenade_influencer_score,
				spawn_grenade_influencer_score_curve,
				spawn_grenade_influencer_radius);
		}
	}
	
	return;
}

generate_dog_spawn_influencers(
	influencers_s,
	player_entity)
{
	if (IsDefined(level.dogs))
	{
		// dog influencers
		spawn_dog_influencer_score= level.spawnsystem.dog_influencer_score;
		spawn_dog_influencer_score_curve= level.spawnsystem.dog_influencer_score_curve;
		spawn_dog_influencer_radius= level.spawnsystem.dog_influencer_radius;
		
		player_team= player_entity.pers["team"];
		
		for (dog_index= 0; dog_index<level.dogs.size; dog_index++)
		{
			dog= level.dogs[dog_index];
			
			if (IsDefined(dog) && IsAlive(dog))
			{
				dog_team= dog.aiteam;
				
				if (teams_have_enmity(player_team, dog_team))
				{
					influencer_origin= dog GetOrigin();
					influencer_angles= dog GetAngles();
					
					influencers_s.a[influencers_s.a.size]= create_sphere_influencer(
						"dog",
						AnglesToForward(influencer_angles),
						AnglesToUp(influencer_angles),
						influencer_origin,
						spawn_dog_influencer_score,
						spawn_dog_influencer_score_curve,
						spawn_dog_influencer_radius);
				}
			}
		}
	}
	
	return;
}

generate_artillery_spawn_influencers(
	influencers_s, // generated by spawn_array_struct(), struct that contains an array
	player_entity )
{
	if (IsDefined(level.artilleryDangerCenters))
	{
		// artillery influencers
		spawn_artillery_influencer_score= level.spawnsystem.artillery_influencer_score;
		spawn_artillery_influencer_score_curve= level.spawnsystem.artillery_influencer_score_curve;
		
		for (artillery_index= 0; artillery_index<level.artilleryDangerCenters.size; artillery_index++)
		{
			// A dangerCenter struct has a .origin and a .forward.
			// The radius is defined implicitly for all dangerCenters
			// using the level.artilleryDangerMaxRadius value.
			dangerCenter= level.artilleryDangerCenters[artillery_index]; // has .origin and .forward
			
			//###nathan $TODO - It looks like TA is in the process of making the airstrike area
			// more nuanced, so this will need to be revisited.  See _hardpoints.gsc:pointIsInAirstrikeArea().
			warningRadius= level.artilleryDangerMaxRadius * 1.25;
			
			influencers_s.a[ influencers_s.a.size ]=
				create_sphere_influencer(
					"airstrike",
					(1.0, 0.0, 0.0), // forward
					(0.0, 0.0, 1.0), // up,
					dangerCenter.origin,
					spawn_artillery_influencer_score,
					spawn_artillery_influencer_score_curve,
					warningRadius);
		}
	}

	return;
}

// spawn_influencers_s[]
generate_dead_friend_spawn_influencers(
	influencers_s,
	player_entity )
{
	// dead friends
	spawn_dead_friend_influencer_score= level.spawnsystem.dead_friend_influencer_score;
	spawn_dead_friend_influencer_score_curve= level.spawnsystem.dead_friend_influencer_score_curve;
	spawn_dead_friend_influencer_radius= level.spawnsystem.dead_friend_influencer_radius;
	
	team= player_entity.team;
	
	clean_recently_deceased( level.recently_deceased[ team ] );
	theDead_s= level.recently_deceased[ team ];
		
	for ( iDead= 0; iDead < theDead_s.a.size; iDead++ )
	{
		dead= theDead_s.a[ iDead ];
		
		influencers_s.a[ influencers_s.a.size ]= create_sphere_influencer(
			"dead_friend",
			AnglesToForward(dead.angles),
			AnglesToUp(dead.angles),
			dead.origin,
			spawn_dead_friend_influencer_score,
			spawn_dead_friend_influencer_score_curve,
			spawn_dead_friend_influencer_radius);
	}
	
	return influencers_s;
}

// void
// player:: member method ( self == dead_player_entity )
player_died_callback(
	eInflictor,
	attacker,
	iDamage,
	sMeansOfDeath,
	sWeapon,
	vDir,
	sHitLoc,
	psOffsetTime,
	deathAnimDuration )
{
	dead= SpawnStruct();
	
	dead.angles= self GetPlayerAngles();
	dead.origin= self GetOrigin();
	dead.timeOfDeathMillis= GetTime();
	
	
	recently_deceased_s= level.recently_deceased[ self.team ];
	
	for ( i= recently_deceased_s.a.size; i > 0; i-- )
	{
		recently_deceased_s.a[ i ]= recently_deceased_s.a[ i - 1 ];
	}
	
	recently_deceased_s.a[ 0 ]= dead;
	
	checkDeceased( recently_deceased_s );
}

// void
clean_recently_deceased(
	recently_deceased_s ) // s.a[]= player_entities[]
{
	spawn_dead_friend_influencer_timeout_seconds= level.spawnsystem.dead_friend_influencer_timeout_seconds;
	spawn_dead_friend_influencer_count= level.spawnsystem.dead_friend_influencer_count;
	
	timeCutoffMillis= spawn_dead_friend_influencer_timeout_seconds*1000.0;
	maxDeceased= spawn_dead_friend_influencer_count;
	
	currentTimeMillis= GetTime();
	
	clean_count= 0;
	
	for ( iDead= 0; iDead < recently_deceased_s.a.size; iDead++ )
	{
		if ( clean_count >= maxDeceased
			&& maxDeceased != -1 )
		{
			break;
		}
		
		dead= recently_deceased_s.a[ iDead ];
		
		if ( currentTimeMillis - dead.timeOfDeathMillis >= timeCutoffMillis
			&& timeCutoffMillis != -1 )
		{
			continue;
		}
		
		recently_deceased_s.a[ clean_count ]= dead;
		clean_count++;
	}
	
	
	old_size = recently_deceased_s.a.size;
	
	for ( i= clean_count; i < old_size; i++ )
	{
		recently_deceased_s.a[ i ]= undefined;
	}
	
	checkDeceased( recently_deceased_s );
	
	return;
}

checkDeceased( recently_deceased_s )
{
/#
	for ( i = 0; i < recently_deceased_s.a.size; i++ )
	{
		if ( !IsDefined( recently_deceased_s.a[ i ] ) )
		{
			AssertMsg( "recently deceased list is bad" );
		}
	}
#/
}

//spawn_influencers_s.a[]
generate_game_mode_spawn_influencers(
	influencers_s,
	player_entity)
{
	if (IsDefined(level.callbackPlayerSpawnGenerateInfluencers))
	{
		// add any game mode influencers to the cummulative influencer array
		[[level.callbackPlayerSpawnGenerateInfluencers]](player_entity, influencers_s);
	}
	
	return influencers_s;
}

//bool
influencer_type_string_is_game_mode(
	influencer_type_string)
{
	tokens= strtok(influencer_type_string, ":");
	game_mode_string= false;
	
	//###stefan $TODO add additional game-type strings here as they generate influencers
	if (tokens[0]=="twar")
	{
		game_mode_string= true;
	}
	
	return game_mode_string;
}

//returns spawn_points_s.a[] - array of vectors
score_spawn_points_against_influencers(
	player_entity,
	points_list_s, //s.a[]= point3d[]
	spawn_entities_s, //s.a[]= spawn point entity array
	spawn_influencers_s)
{
	spawn_randomness_range= level.spawnsystem.randomness_range;
	
	// calculate the score of each influencer against every point
	influencer_point_scores= []; ///< This is an array of array structs!
	
	prof_begin("sspai score_points_functions");
	for (influencer_index= 0; influencer_index < spawn_influencers_s.a.size; influencer_index++ )
	{
		spawn_influencer= spawn_influencers_s.a[ influencer_index ];
		
		switch ( spawn_influencer["shape"] )
		{
			case "sphere":
			{
				influencer_point_scores[ influencer_index ]= score_points_list_against_sphere_influencer( points_list_s, spawn_influencer );
				break;
			}
			case "cylinder":
			{
				influencer_point_scores[ influencer_index ]= score_points_list_against_cylinder_influencer( points_list_s, spawn_influencer );
				break;
			}
			case "pill":
			{
				influencer_point_scores[ influencer_index ]= score_points_list_against_pill_influencer( points_list_s, spawn_influencer );
				break;
			}
			case "cone":
			{
				influencer_point_scores[ influencer_index ]= score_points_list_against_cone_influencer( points_list_s, spawn_influencer );
				break;
			}
			case "box":
			{
				influencer_point_scores[ influencer_index ]= score_points_list_against_box_influencer( points_list_s, spawn_influencer );
				break;
			}
			default:
			{
				assertmsg("undefined spawn influencer shape!");
				influencer_point_scores[ influencer_index ]= spawn_array_struct();
				break;
			}
		}
	}
	prof_end("sspai score_points_functions");
	
	// assemble list of scored spawn points
	scored_spawn_points_s= spawn_array_struct();
	
	prof_begin("sspai point vs influencer loop");
	for (point_index= 0; point_index < points_list_s.a.size; point_index++)
	{
		score= 0.0;
		
		// get baseline spawn point entity score from the active game mode
		if (IsDefined(level.callbackPlayerSpawnGenerateSpawnPointEntityBaseScore))
		{
			score= [[level.callbackPlayerSpawnGenerateSpawnPointEntityBaseScore]](player_entity, spawn_entities_s.a[point_index]);
		}
		
		// friend influencers & game mode influencers are not combinative; everything else is combinative
		friend_influence_score= 0.0;
		objective_influence_score= 0.0;
		
		// add cumulative affect of all influencers on this point
		for (influencer_index= 0; influencer_index<spawn_influencers_s.a.size; influencer_index++)
		{
			point_score= influencer_point_scores[ influencer_index ].a[ point_index ];
			
			if (IsDefined(point_score))
			{
				influencer_type= spawn_influencers_s.a[influencer_index]["type"];
				
				// some game modes pass in their own special type strings
				if (influencer_type_string_is_game_mode(influencer_type))
				{
					influencer_type= "game_mode";
				}
				
				switch (influencer_type)
				{
					// friend influencers are not combinative; everything else is combinative
					case "friend":
					{
						if (Abs(point_score) > Abs(friend_influence_score))
						{
							friend_influence_score= point_score;
						}
						break;
					}
					case "game_mode":
					{
						if (Abs(point_score) > Abs(objective_influence_score))
						{
							objective_influence_score= point_score;
						}
						break;
					}
					//case "static":
					//case "enemy":
					//case "enemy_weapon":
					//case "vehicle":
					//case "projectile":
					//case "dead_friend":
					//case "misc":
					default:
					{
						score+= point_score;
						break;
					}
				}
			}
		}
		
		// add friend, game mode scores
		score+= friend_influence_score;
		score+= objective_influence_score;
		
		// finally add score randomness
		score+= RandomFloat(spawn_randomness_range);
		
		// save scored spawn point as a vector <unsorted_index, score, unused>
		scored_spawn_points_s.a[point_index]= (0.0+point_index, score, 0.0);
	}
	prof_end("sspai point vs influencer loop");
	
	return scored_spawn_points_s;
}

//scores.a[]
score_points_list_against_sphere_influencer(
	points_list_s,
	spawn_influencer )
{
	scores_s= spawn_array_struct();
	collision_results_s= undefined;
	
	//###stefan $REVIEW really this shouldn't be necessary but sometimes buggered up static influencers find their way in here
	if (IsDefined(spawn_influencer["origin"]) && IsDefined(spawn_influencer["radius"]))
	{
		collision_results_s= collision_test_points_in_sphere(
			points_list_s,
			spawn_influencer["origin"],
			spawn_influencer["radius"]);
	}
	
	if (IsDefined(collision_results_s) && IsDefined(collision_results_s.a))
	{
		one_over_maximum_distance_squared= 1.0 / ( spawn_influencer[ "radius" ] * spawn_influencer[ "radius" ] );
		
		for ( point_index= 0; point_index < points_list_s.a.size; point_index++ )
		{
			collision_result= collision_results_s.a[ point_index ];
			if ( collision_result[0] > 0.0 )
			{
				// weighted according to radial distance from origin
				scores_s.a[ point_index ]= spawn_influencer_scoring_function_evaluate(
					spawn_influencer[ "score_curve" ], // function_type
					collision_result[1], // distance
					one_over_maximum_distance_squared, // one_over_maximum_distance
					spawn_influencer[ "score" ] ); // base_score
			}
			else
			{
				scores_s.a[ point_index ]= 0.0;
			}
		}
	}

	return scores_s;
}

//scores.a[]
score_points_list_against_cylinder_influencer(
	points_list_s,
	spawn_influencer )
{
	scores_s= spawn_array_struct();
	collision_results_s= undefined;
	
	//###stefan $REVIEW really this shouldn't be necessary but sometimes buggered up static influencers find their way in here
	if (IsDefined(spawn_influencer["origin"]) && IsDefined(spawn_influencer["radius"]) &&
		IsDefined(spawn_influencer["axis_length"]) && IsDefined(spawn_influencer["up"]))
	{
		collision_results_s= collision_test_points_in_cylinder(
			points_list_s,
			spawn_influencer["origin"],
			spawn_influencer["radius"],
			spawn_influencer["axis_length"],
			spawn_influencer["up"]);
	}
	
	if (IsDefined(collision_results_s) && IsDefined(collision_results_s.a))
	{
		one_over_maximum_distance_squared= 1.0 / ( spawn_influencer[ "radius" ] * spawn_influencer[ "radius" ] );
		
		for ( point_index= 0; point_index < points_list_s.a.size; point_index++ )
		{
			collision_result= collision_results_s.a[ point_index ];
			if ( collision_result[0] > 0 )
			{
				// weighted according to radial distance from axis
				scores_s.a[ point_index ]= spawn_influencer_scoring_function_evaluate(
					spawn_influencer[ "score_curve" ], // function_type
					collision_result[2], // distance
					one_over_maximum_distance_squared, // one_over_maximum_distance
					spawn_influencer[ "score" ] ); // base_score
			}
			else
			{
				scores_s.a[ point_index ]= 0.0;
			}
		}
	}
	
	return scores_s;
}

//scores.a[]
score_points_list_against_pill_influencer(
	points_list_s,
	spawn_influencer )
{
	scores_s= spawn_array_struct();
	collision_results_s= undefined;
	
	//###stefan $REVIEW really this shouldn't be necessary but sometimes buggered up static influencers find their way in here
	if (IsDefined(spawn_influencer["origin"]) && IsDefined(spawn_influencer["radius"]) &&
		IsDefined(spawn_influencer["axis_length"]) && IsDefined(spawn_influencer["up"]) && IsDefined(spawn_influencer["forward"]))
	{
		collision_results_s= collision_test_points_in_pill(
			points_list_s,
			spawn_influencer["origin"],
			spawn_influencer["radius"],
			spawn_influencer["axis_length"],
			spawn_influencer["up"],
			spawn_influencer["forward"]);
	}
	
	if (IsDefined(collision_results_s) && IsDefined(collision_results_s.a))
	{
		one_over_maximum_distance_squared= 1.0 / ( spawn_influencer[ "radius" ] * spawn_influencer[ "radius" ] );
		
		for ( point_index= 0; point_index < points_list_s.a.size; point_index++ )
		{
			if (collision_results_s.a[ point_index ][0] > 0 )
			{
				// weighted according to radial distance from axis
				scores_s.a[ point_index ]= spawn_influencer_scoring_function_evaluate(
					spawn_influencer[ "score_curve" ], // function_type
					collision_results_s.a[ point_index ][2], // distance
					one_over_maximum_distance_squared, // one_over_maximum_distance
					spawn_influencer[ "score" ] ); // base_score
			}
			else
			{
				scores_s.a[ point_index ]= 0;
			}
		}
	}
	
	return scores_s;
}

//scores.a[]
score_points_list_against_cone_influencer(
	points_list_s,
	spawn_influencer)
{
	scores_s= spawn_array_struct();
	collision_results_s= undefined;

	//###stefan $REVIEW really this shouldn't be necessary but sometimes buggered up static influencers find their way in here
	if (IsDefined(spawn_influencer["origin"]) && IsDefined(spawn_influencer["radius"]) && IsDefined(spawn_influencer["axis_length"]) &&
		IsDefined(spawn_influencer["up"]) && IsDefined(spawn_influencer["forward"]))
	{
		collision_results_s= collision_test_points_in_cone(
			points_list_s,
			spawn_influencer["origin"],
			spawn_influencer["radius"],
			spawn_influencer["axis_length"],
			spawn_influencer["up"],
			spawn_influencer["forward"]);
	}
		
	if (IsDefined(collision_results_s) && IsDefined(collision_results_s.a))
	{
		one_over_maximum_distance_squared= 1.0 / ( spawn_influencer[ "axis_length" ] * spawn_influencer[ "axis_length" ] );
		
		for ( point_index= 0; point_index < points_list_s.a.size; point_index++ )
		{
			if ( collision_results_s.a[ point_index ][0] > 0 )
			{
				// weighted according to distance from cone base
				scores_s.a[ point_index ]= spawn_influencer_scoring_function_evaluate(
					spawn_influencer[ "score_curve" ], // function_type
					collision_results_s.a[ point_index ][1], // distance
					one_over_maximum_distance_squared, // one_over_maximum_distance
					spawn_influencer[ "score" ] ); // base_score
			}
			else
			{
				scores_s.a[ point_index ]= 0;
			}
		}
	}

	return scores_s;
}

//scores.a[]
score_points_list_against_box_influencer(
	points_list_s,
	spawn_influencer )
{
	scores_s= spawn_array_struct();
	collision_results_s= undefined;
	
	//###stefan $REVIEW really this shouldn't be necessary but sometimes buggered up static influencers find their way in here
	if (IsDefined(spawn_influencer["origin"]) && IsDefined(spawn_influencer["width"]) &&
		IsDefined(spawn_influencer["height"]) && IsDefined(spawn_influencer["depth"]) &&
		IsDefined(spawn_influencer["forward"]) && IsDefined(spawn_influencer["up"]))
	{
		collision_results_s= collision_test_points_in_box(
			points_list_s,
			spawn_influencer["origin"],
			spawn_influencer["width"],
			spawn_influencer["height"],
			spawn_influencer["depth"],
			spawn_influencer["forward"],
			spawn_influencer["up"]);
	}
		
	if (IsDefined(collision_results_s) && IsDefined(collision_results_s.a))
	{
		for ( point_index= 0; point_index < points_list_s.a.size; point_index++ )
		{
			if ( collision_results_s.a[ point_index ][0] > 0 )
			{
				// no function curve evaluation for boxes
				scores_s.a[ point_index ]= spawn_influencer[ "score" ];
			}
			else
			{
				scores_s.a[ point_index ]= 0;
			}
		}
	}
	
	return scores_s;
}

//float
spawn_influencer_scoring_function_evaluate(
	function_type, //"constant", "linear" (1->0), "inverse_linear" (0->1), "negative_to_positive" (-1 -> +1)
	distance_squared,
	one_over_maximum_distance_squared,
	base_score )
{
	switch (function_type)
	{
		case "constant": result_score= base_score; break;
		case "linear": result_score= base_score*(1 - distance_squared*one_over_maximum_distance_squared); break;
		case "inverse_linear": result_score= base_score*(distance_squared*one_over_maximum_distance_squared); break;
		case "negative_to_positive": result_score= base_score*(2.0*Sqrt(distance_squared*one_over_maximum_distance_squared) - 1.0); break;
		default: assertmsg("unknown function type: "+function_type); result_score= undefined; break;
	}
	
	return result_score;
}

// returns integer index of best spawn point in spawn_points[], or -1 if none is found
get_best_spawn_point_index(
	spawn_entities_s,
	scored_spawn_points_s)
{
	index= -1;
	
	/#
	if (GetDvarInt("scr_spawn_point_test_mode")!=0)
	{
		index= level.test_spawn_point_index;
		level.test_spawn_point_index++;
		if (level.test_spawn_point_index>=spawn_entities_s.a.size)
		{
			level.test_spawn_point_index= 0;
		}
		
		return index;
	}
	#/
	
	//sort spawn points by score (low to high)
	sorted_scored_spawn_points_array= QsortScoredSpawnPointsAscending(scored_spawn_points_s.a);
	// now pick the highest scoring spawn point that won't telefrag a player
	for (i= sorted_scored_spawn_points_array.size-1; i>=0; i--)
	{
		scored_spawn= sorted_scored_spawn_points_array[i];
		entity_index= int(scored_spawn[0]); // v[0]==entity_index
		spawn_entity_origin=  spawn_entities_s.a[entity_index] GetOrigin();
		if (!PositionWouldTelefrag(spawn_entity_origin))
		{
			index= entity_index;
			break;
		}
	}
	
	// if there is no good spawn position, return the first possible spawn point, if any
	if (index<0)
	{
		if (spawn_entities_s.a.size>0)
		{
			index= 0;
		}
	}

	return index;
}

// influencer
_create_influencer(
	type,        ///< See spawn_influencer["type"] at the top of _spawning.gsc
	shape,       ///< See spawn_influencer["shape"] at the top of _spawning.gsc
	forward,     ///< See spawn_influencer["forward"] at the top of _spawning.gsc
	up,          ///< See spawn_influencer["up"] at the top of _spawning.gsc
	origin,      ///< See spawn_influencer["origin"] at the top of _spawning.gsc
	score,       ///< See spawn_influencer["score"] at the top of _spawning.gsc
	score_curve  ///< See spawn_influencer["score_curve"] at the top of _spawning.gsc
	)
{
	influencer= [];

	influencer["type"]= type;
	influencer["shape"]= shape;
	influencer["forward"]= forward;
	influencer["up"]= up;
	influencer["origin"]= origin;
	influencer["score"]= score;
	influencer["score_curve"]= score_curve;
	
	return influencer;
}

// influencer
_create_radiusaxis_influencer(
	type,        ///< See spawn_influencer["type"] at the top of _spawning.gsc
	shape,       ///< See spawn_influencer["shape"] at the top of _spawning.gsc
	forward,     ///< See spawn_influencer["forward"] at the top of _spawning.gsc
	up,          ///< See spawn_influencer["up"] at the top of _spawning.gsc
	origin,      ///< See spawn_influencer["origin"] at the top of _spawning.gsc
	score,       ///< See spawn_influencer["score"] at the top of _spawning.gsc
	score_curve, ///< See spawn_influencer["score_curve"] at the top of _spawning.gsc
	radius,      ///< See spawn_influencer["radius"] at the top of _spawning.gsc
	axis_length  ///< See spawn_influencer["axis_length"] at the top of _spawning.gsc
	)
{
	radiusaxis_influencer=  _create_influencer( type, shape, forward, up, origin, score, score_curve );
	
	radiusaxis_influencer["radius"]= radius;
	radiusaxis_influencer["axis_length"]= axis_length;
	
	return radiusaxis_influencer;
}

// influencer
create_sphere_influencer(
	type,        ///< See spawn_influencer["type"] at the top of _spawning.gsc
	forward,     ///< See spawn_influencer["forward"] at the top of _spawning.gsc
	up,          ///< See spawn_influencer["up"] at the top of _spawning.gsc
	origin,      ///< See spawn_influencer["origin"] at the top of _spawning.gsc
	score,       ///< See spawn_influencer["score"] at the top of _spawning.gsc
	score_curve, ///< See spawn_influencer["score_curve"] at the top of _spawning.gsc
	radius       ///< See spawn_influencer["radius"] at the top of _spawning.gsc
	)
{
	sphere= _create_influencer( type, "sphere", forward, up, origin, score, score_curve );
	
	sphere["radius"]= radius;
	
	return sphere;
}

// influencer
create_cylinder_influencer(
	type,        ///< See spawn_influencer["type"] at the top of _spawning.gsc
	forward,     ///< See spawn_influencer["forward"] at the top of _spawning.gsc
	up,          ///< See spawn_influencer["up"] at the top of _spawning.gsc
	origin,      ///< See spawn_influencer["origin"] at the top of _spawning.gsc
	score,       ///< See spawn_influencer["score"] at the top of _spawning.gsc
	score_curve, ///< See spawn_influencer["score_curve"] at the top of _spawning.gsc
	radius,      ///< See spawn_influencer["radius"] at the top of _spawning.gsc
	axis_length  ///< See spawn_influencer["axis_length"] at the top of _spawning.gsc
	)
{
	return _create_radiusaxis_influencer( type, "cylinder", forward, up, origin, score, score_curve, radius, axis_length );
}

// influencer
create_pill_influencer(
	type,        ///< See spawn_influencer["type"] at the top of _spawning.gsc
	forward,     ///< See spawn_influencer["forward"] at the top of _spawning.gsc
	up,          ///< See spawn_influencer["up"] at the top of _spawning.gsc
	origin,      ///< See spawn_influencer["origin"] at the top of _spawning.gsc
	score,       ///< See spawn_influencer["score"] at the top of _spawning.gsc
	score_curve, ///< See spawn_influencer["score_curve"] at the top of _spawning.gsc
	radius,      ///< See spawn_influencer["radius"] at the top of _spawning.gsc
	axis_length  ///< See spawn_influencer["axis_length"] at the top of _spawning.gsc
	)
{
	return _create_radiusaxis_influencer( type, "pill", forward, up, origin, score, score_curve, radius, axis_length );
}

// influencer
create_cone_influencer(
	type,        ///< See spawn_influencer["type"] at the top of _spawning.gsc
	forward,     ///< See spawn_influencer["forward"] at the top of _spawning.gsc
	up,          ///< See spawn_influencer["up"] at the top of _spawning.gsc
	origin,      ///< See spawn_influencer["origin"] at the top of _spawning.gsc
	score,       ///< See spawn_influencer["score"] at the top of _spawning.gsc
	score_curve, ///< See spawn_influencer["score_curve"] at the top of _spawning.gsc
	radius,      ///< See spawn_influencer["radius"] at the top of _spawning.gsc
	axis_length  ///< See spawn_influencer["axis_length"] at the top of _spawning.gsc
	)
{
	return _create_radiusaxis_influencer( type, "cone", forward, up, origin, score, score_curve, radius, axis_length );
}

// influencer
create_box_influencer(
	type,        ///< See spawn_influencer["type"] at the top of _spawning.gsc
	forward,     ///< See spawn_influencer["forward"] at the top of _spawning.gsc
	up,          ///< See spawn_influencer["up"] at the top of _spawning.gsc
	origin,      ///< See spawn_influencer["origin"] at the top of _spawning.gsc
	score,       ///< See spawn_influencer["score"] at the top of _spawning.gsc
	score_curve, ///< See spawn_influencer["score_curve"] at the top of _spawning.gsc
	width,       ///< See spawn_influencer["width"] at the top of _spawning.gsc
	height,      ///< See spawn_influencer["height"] at the top of _spawning.gsc
	depth        ///< See spawn_influencer["depth"] at the top of _spawning.gsc
	)
{
	box= _create_influencer( type, "box", forward, up, origin, score, score_curve );
	
	box["width"]= width;
	box["height"]= height;
	box["depth"]= depth;
	
	return box;
}

/* ---------- debug rendering */
/#
debug_render_scored_spawn_points(
	spawn_entities_s,
	scored_spawn_points_s)
{
	k_player_height= get_player_height();
	k_top_spawn_cylinder_radius= k_player_height;
	k_top_spawn_cylinder_height= 10.0*k_player_height;
	k_debug_render_spawn_text= true;
	point_offset= (0.0, 0.0, 0.5*k_player_height);
	top_spawn_count= 10;
	
	//###stefan $NOTE turning off debug text only saves 1-2 sv ms/frame
	if (GetDvar("scr_debug_render_spawn_text")!="1")
	{
		k_debug_render_spawn_text= false;
	}
	
	// sort spawn points by score (low to high) as we want to call out the top N most desirable spawn locations
	sorted_scored_spawn_points_array= QsortScoredSpawnPointsAscending(scored_spawn_points_s.a);
	
	// render spawn point information
	for (point_index= sorted_scored_spawn_points_array.size-1; point_index>=0; point_index--)
	{
		scored_spawn_point= sorted_scored_spawn_points_array[point_index];
		entity_index= int(scored_spawn_point[0]);
		score= scored_spawn_point[1];
		render_origin= point3d_translate(spawn_entities_s.a[entity_index] GetOrigin(), point_offset);
		
		if (score>0.0)
		{
			rgb_color= (0, 1, 0);
		}
		else if (score<0.0)
		{
			rgb_color= (1, 0, 0);
		}
		else // score==0
		{
			rgb_color= (1, 1, 1);
		}
		
		if (k_debug_render_spawn_text)
		{
			Print3d(
				render_origin, // origin
				score, //text
				rgb_color, // rgb
				1, // alpha
				1.0, // scale
				1 // duration in server frames
				);
		}
		
		// if this is one of the top N spawn points, render a big yellow cylinder about it
		if (top_spawn_count>0)
		{
			draw_cylinder(
				render_origin, // origin
				k_top_spawn_cylinder_radius, // radius
				k_top_spawn_cylinder_height, // height
				(1.0, 0.0, 0.0), // forward
				(0.0, 0.0, 1.0), // up
				(1, 1, 0)); // rgb_color
			top_spawn_count--;
		}
	}
	
	return;
}

debug_render_spawn_influencers(
	spawn_influencers_s)
{
	for (influencer_index= 0; influencer_index<spawn_influencers_s.a.size; influencer_index++)
	{
		debug_render_spawn_influencer( spawn_influencers_s.a[influencer_index] );
	}
}

debug_render_spawn_influencer(
	influencer,
	rgb_color)
{
	k_debug_render_spawn_text= true;
	
	//###stefan $NOTE turning off debug text only saves 1-2 sv ms/frame
	if (GetDvar("scr_debug_render_spawn_text")!="1")
	{
		k_debug_render_spawn_text= false;
	}
	
	if ( !IsDefined( rgb_color ) )
	{
		if (influencer["score"]>0)
		{
			rgb_color= (0, 1, 0);
		}
		else if (influencer["score"]<0)
		{
			rgb_color= (1, 0, 0);
		}
		else // influencer["score"]==0
		{
			rgb_color= (1, 1, 1);
		}
	}
	
	if (k_debug_render_spawn_text)
	{
		Print3d(
			influencer["origin"], // origin
			"<<" + influencer[ "type" ] + ": " + influencer[ "score" ] + ">>", ///< text
			rgb_color, // rgb
			1, // alpha
			1.0, ///< scale
			1 // duration in server frames
			);
	}
	
	switch (influencer["shape"])
	{
		case "sphere":
		{
			draw_sphere(
				influencer["origin"],
				influencer["radius"],
				influencer["forward"],
				influencer["up"],
				rgb_color);
			break;
		}
		case "cylinder":
		{
			draw_cylinder(
				influencer["origin"],
				influencer["radius"],
				influencer["axis_length"],
				influencer["forward"],
				influencer["up"],
				rgb_color);
			break;
		}
		case "pill":
		{
			draw_pill(
				influencer["origin"],
				influencer["radius"],
				influencer["axis_length"],
				influencer["forward"],
				influencer["up"],
				rgb_color);
			break;
		}
		case "cone":
		{
			draw_cone(
				influencer["origin"],
				influencer["radius"],
				influencer["axis_length"],
				influencer["forward"],
				influencer["up"],
				rgb_color);
			break;
		}
		case "box":
		{
			draw_box(
				influencer["origin"],
				(influencer["width"], influencer["height"], influencer["depth"]),
				influencer["forward"],
				influencer["up"],
				rgb_color);
			break;
		}
		default:
		{
			assertmsg("undefined influencer shape!");
			break;
		}
	}
}
#/
