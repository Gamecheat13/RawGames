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
	
	if ( getdvar("scr_spawn_visibility_check_max") == "" )
	{
		SetDvar("scr_spawn_visibility_check_max", 35);
	}

	if ( getdvar("scr_ignore_spawn_visibility_check_max") == "" )
	{
		SetDvar("scr_ignore_spawn_visibility_check_max", 0);
	}
	
	level.spawn_visibility_check_max = getdvarint("scr_spawn_visibility_check_max");
	level.ignore_spawn_visibility_check_max = getdvarint("scr_ignore_spawn_visibility_check_max");
		
	
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
	//thread spawn_influencers_debug_render_thread();
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
	if ( level.friendlyfire )
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
		// for the player influencers we need to pay attention to the switchedsides
		team = self.pers["team"];
//		if ( isdefined( game["switchedsides"] ) && game["switchedsides"] )
//		{
//			team = getotherteam(team);
//		}
		
		team_mask = get_team_mask( team );
		other_team_mask = get_team_mask( getotherteam(team) );
		weapon_team_mask = get_team_mask( getotherteam(team) );
	}
	
	// if friendly fire is on then we do not want to spawn infront of the weapon either
	if ( level.friendlyfire != 0 && level.teamBased )
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
		setinfluencerteammask(self.influencer_squad, team_mask);
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
		if ( level.friendlyfire )
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
	
	// this will remove all spawnpoints for the other gametypes which are not used
	remove_unused_spawn_entities();
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
	dog_influencer_radius = 15.0*k_player_height;
	dog_influencer_score = 150.0;
	
	// this controls the original script driven influencer system
	ss.script_based_influencer_system =	set_dvar_int_if_unset("scr_script_based_influencer_system", "0");

	// general parameters
	// amount of randomness applied to spawning scores
	ss.randomness_range =	set_dvar_float_if_unset("scr_spawn_randomness_range", "50");
	// bonus applied to spawn points which face the current objective in certain objective-based games
	ss.objective_facing_bonus =	set_dvar_float_if_unset("scr_spawn_objective_facing_bonus", "50");
	
	// strong friend influencers are now a cylinder projected behind the player
	ss.friend_strong_influencer_score =	set_dvar_float_if_unset("scr_spawn_friend_strong_influencer_score", "175");
	ss.friend_strong_influencer_score_curve =	set_dvar_if_unset("scr_spawn_friend_strong_influencer_score_curve", "linear");
	ss.friend_strong_influencer_radius =	set_dvar_float_if_unset("scr_spawn_friend_strong_influencer_radius", player_height_times_10);
	ss.friend_strong_influencer_length =	set_dvar_float_if_unset("scr_spawn_friend_strong_influencer_length", "" + 15*k_player_height);
	
	// weak friend influencers are a sphere about the player
	ss.friend_weak_influencer_score =	set_dvar_float_if_unset("scr_spawn_friend_weak_influencer_score", "75");
	ss.friend_weak_influencer_score_curve =	set_dvar_if_unset("scr_spawn_friend_weak_influencer_score_curve", "linear");
	ss.friend_weak_influencer_radius =	set_dvar_float_if_unset("scr_spawn_friend_weak_influencer_radius", player_height_times_10);
	
	// squad leader influencer (applied in addition to other friendly player influencers)
	ss.squad_leader_influencer_score =	set_dvar_float_if_unset("scr_spawn_squad_leader_influencer_score", "150");
	ss.squad_leader_influencer_score_curve =	set_dvar_if_unset("scr_spawn_squad_leader_influencer_score_curve", "linear");
	ss.squad_leader_influencer_radius =	set_dvar_float_if_unset("scr_spawn_squad_leader_influencer_radius", player_height_times_10);
	
	// enemy player influencer
	ss.enemy_influencer_score =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_score", "-150");
	ss.enemy_influencer_score_curve =	set_dvar_if_unset("scr_spawn_enemy_influencer_score_curve", "linear");
	ss.enemy_influencer_radius =	set_dvar_float_if_unset("scr_spawn_enemy_influencer_radius", "" + player_influencer_radius);
	
	// enemy weapon influencer
	ss.weapon_influencer_score =	set_dvar_float_if_unset("scr_spawn_weapon_influencer_score", "-400");
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
	ss.dog_influencer_score =	set_dvar_float_if_unset("scr_spawn_dog_influencer_score", "-300");
	ss.dog_influencer_score_curve =	set_dvar_if_unset("scr_spawn_dog_influencer_score_curve", "linear");
	ss.dog_influencer_radius =	set_dvar_float_if_unset("scr_spawn_dog_influencer_radius", "" + dog_influencer_radius);
	
	// artillery strike influencer
	ss.artillery_influencer_score =	set_dvar_float_if_unset("scr_spawn_artillery_influencer_score", "-800");
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
	ss.sab_carrier_influencer_score =	set_dvar_float_if_unset("scr_spawn_sab_carrier_influencer_score", "-175");
	ss.sab_carrier_influencer_score_curve =	set_dvar_if_unset("scr_spawn_sab_carrier_influencer_score_curve", "linear");
	ss.sab_carrier_influencer_radius =	set_dvar_float_if_unset("scr_spawn_sab_carrier_influencer_radius", "" + 15.0*k_player_height);
	
	// ctf: influencer around friendly base
	ss.ctf_friendly_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_base_influencer_score", "0");
	ss.ctf_friendly_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_friendly_base_influencer_score_curve", "constant");
	ss.ctf_friendly_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_base_influencer_radius", "" + 15.0*k_player_height);

	// ctf: influencer around enemy base
	ss.ctf_enemy_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_base_influencer_score", "-500");
	ss.ctf_enemy_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_enemy_base_influencer_score_curve", "constant");
	ss.ctf_enemy_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_base_influencer_radius", "" + 15.0*k_player_height);
	
	// ctf: negative influencer around carrier
	ss.ctf_carrier_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_carrier_influencer_score", "-200");
	ss.ctf_carrier_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_carrier_influencer_score_curve", "constant");
	ss.ctf_carrier_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_carrier_influencer_radius", "" + 15*k_player_height);

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
	
	/#
	if (GetDvarInt("scr_spawn_point_test_mode")!=0)
	{
		spawn_point = get_debug_spawnpoint( self );
		self spawn( spawn_point.origin, spawn_point.angles );
		return;
	}
	#/

	use_new_spawn_system= true;
	initial_spawn= true;
	
	if (IsDefined(self.uspawn_already_spawned))
	{
		initial_spawn= !self.uspawn_already_spawned;
	}
	
	// is this the player's first spawn into the game?
//	if (initial_spawn) 
//	{
//		// if less than 45 seconds into the match, use initial spawn logic; otherwise, treat this as a respawn
//		// on initial spawns, it was decided that we want to use the pre-existing, designer placed
//		// spawn points particular to the game mode being played. therefor, in this case we call the
//		// old spawning logic
//		k_allow_initial_spawn_logic_duration_milliseconds= 45000;
//		k_current_time= GetTime();
//		
//		if (k_current_time <= k_allow_initial_spawn_logic_duration_milliseconds)
//		{
//			use_new_spawn_system= false;
//		}
//	}
		
	if ( level.useStartSpawns )
		{
			use_new_spawn_system= false;
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
			self.lastspawntime = gettime();
			self spawn( spawn_point.origin, spawn_point.angles );
			self enable_player_influencers( true );
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
		point_team = player_entity.pers["team"];
		influencer_team = player_entity.pers["team"];
	}
	else
	{
		point_team = "free";
		influencer_team = "free";
	}

	if (level.teambased && IsDefined(game["switchedsides"]) &&	game["switchedsides"])
	{
		point_team = GetOtherTeam(point_team);
	}
	
//	if ( level.spawnsystem.script_based_influencer_system )
//	{
////		best_spawn_entity= undefined;
////		spawnEntities_s= gatherSpawnEntities(point_team);
////		bestIndex= spawning_find_best_spawn_entity_for_player(player_entity, spawnEntities_s);
////		
////		if (bestIndex >= 0)
////		{
////			best_spawn_entity= spawnEntities_s.a[bestIndex];
////		}
//	}
//	else
	{
		best_spawn_entity = get_best_spawnpoint( point_team, influencer_team, player_entity );
	}
	
	return best_spawn_entity;
}

get_debug_spawnpoint( player )
{
	if (level.teambased )
	{
		team = player.pers["team"];
	}
	else
	{
		team = "free";
	}
	
	index = level.test_spawn_point_index;
	level.test_spawn_point_index++;
	
	if ( team == "free" )
	{
		spawn_counts = level.unified_spawn_points[ "allies" ].a.size;
		spawn_counts += level.unified_spawn_points[ "axis" ].a.size;
		
		if (level.test_spawn_point_index >= spawn_counts)
		{
			level.test_spawn_point_index= 0;
		}
		
		if (level.test_spawn_point_index >= level.unified_spawn_points[ "allies" ].a.size)
		{
			return level.unified_spawn_points[ "axis" ].a[level.test_spawn_point_index - level.unified_spawn_points[ "allies" ].a.size];
		}
		else
		{
			return level.unified_spawn_points[ "allies" ].a[level.test_spawn_point_index];
		}
	}
	else
	{
		if (level.test_spawn_point_index >= level.unified_spawn_points[ team ].a.size)
		{
			level.test_spawn_point_index= 0;
		}

		return level.unified_spawn_points[ team ].a[level.test_spawn_point_index];

	}
}

get_best_spawnpoint( point_team, influencer_team, player )
{
	scored_spawn_points = getsortedspawnpoints( point_team, influencer_team, player );
	assert(scored_spawn_points.size > 0 );
	
	if (level.teambased )
	{
		other_team = GetOtherTeam(point_team);
	}
	else
	{
		other_team = "free";
	}
	
	best_spawn_no_sight = undefined;
	
	prof_begin("get_best_spawnpoint__");
	for (i = 0 ; i < scored_spawn_points.size; i++)
	{
		scored_spawn = scored_spawn_points[i];
		if (PositionWouldTelefrag(scored_spawn_points[i].origin))
			continue;
		
		if ( !isdefined(best_spawn_no_sight) )
		{
			best_spawn_no_sight = scored_spawn_points[i];
		}
		
		if ( level.spawn_visibility_check_max <= i && !level.ignore_spawn_visibility_check_max )
		{
			//logPrint("SPAWN script: selected best_spawn_no_sight;" + self.name + "\n"); 
			return best_spawn_no_sight;
		}
		 
		if ( isspawnpointvisible(scored_spawn_points[i].origin, scored_spawn_points[i].angles, other_team, player ) )
		{
				continue;
		}
		
		prof_end("get_best_spawnpoint__");

		//logPrint("SPAWN script: selected scored_spawn_points;" + self.name + "\n"); 
		return scored_spawn_points[i];
	}
	
	prof_end("get_best_spawnpoint__");
	
	// could not find anything
	if( isdefined( best_spawn_no_sight ) )
	{
		return best_spawn_no_sight;
	}
	else
	{
		return scored_spawn_points[0];
	}
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

/* ---------- private code */

/* ---------- spawn_influencer */

// These functions add the new influencers to the provided influencers array.

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

remove_unused_spawn_entities()
{
	spawn_entity_types = [];
	
	// dm
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dm_spawn";
	
	// tdm 
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn";
	
	// ctf
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_allies";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_axis";
	
	// dom
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn";
	
	// koth
	// uses TDM spawns
	
	// sab
	spawn_entity_types[ spawn_entity_types.size ] = "mp_sab_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_sab_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_sab_spawn_allies";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_sab_spawn_axis";
	
	// sd
	spawn_entity_types[ spawn_entity_types.size ] = "mp_sd_spawn_attacker";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_sd_spawn_defender";
	
	// twar
	spawn_entity_types[ spawn_entity_types.size ] = "mp_twar_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_twar_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_twar_spawn";
	
	for ( i = 0; i < spawn_entity_types.size; i++ )
	{
		if ( spawn_point_class_name_being_used( spawn_entity_types[i] ) )
			continue;
			
		spawnpoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( spawn_entity_types[i] );
		
		delete_all_spawns( spawnpoints );
	}
}

delete_all_spawns( spawnpoints )
{
	for ( i = 0; i < spawnpoints.size; i++ )
	{
		spawnpoints[i] delete();
	}
}

spawn_point_class_name_being_used( name )
{
	if ( !IsDefined( level.spawn_point_class_names ) )
	{
		return false;
	}
	
	for ( i = 0; i < level.spawn_point_class_names.size; i++ )
	{
		if ( level.spawn_point_class_names[i] == name )
		{
			return true;
		}
	}
	
	return false;
}

// LEGACY OLD SCRIPT BASED SYSTEM
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

