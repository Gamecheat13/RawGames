#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\abilities\gadgets\_gadget_resurrect;

                                             
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_airsupport;

#namespace spawning;

function autoexec __init__sytem__() {     system::register("spawning",&__init__,undefined,undefined);    }

/*
_spawning.gsc
function Copyright (c) 2008 Certain Affinity, Inc. All rights reserved.
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
function deceased.timeOfDeathMillis - GetTime() value (in milliseconds) at TOD
*/

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

/*QUAKED mp_mobile_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Mobile spawn point. For use with the mobile spawn killstreak.*/

/* ---------- includes */



/* ---------- initialization */

function __init__()
{
	level init_spawn_system();
		
	level.influencers = [];
	level.recently_deceased= [];

	foreach( team in level.teams )
	{
		level.recently_deceased[ team ]= util::spawn_array_struct();
	}
	
	callback::on_connecting( &onPlayerConnect );

	level.spawnProtectionTime = GetGametypeSetting( "spawnprotectiontime" );
	
	/#
	// this dvar stores the name for whom to display debug spawning information
	SetDvar("scr_debug_spawn_player", "");
	SetDvar("scr_debug_render_spawn_data", "1");
	SetDvar("scr_debug_render_snapshotmode", "0");
	// for testing spawn point placements
	SetDvar("scr_spawn_point_test_mode", "0");
	level.test_spawn_point_index= 0;
	SetDvar("scr_debug_render_spawn_text", "1");
	#/

	return;
}

function init_spawn_system()
{
	level.spawnsystem = spawnstruct();
	spawnsystem = level.spawnsystem;

	if (!IsDefined( spawnsystem.sideSwitching ))
		spawnsystem.sideSwitching = 1;
		
	spawnsystem.objective_facing_bonus = 0.0;

	spawnsystem.iSPAWN_TEAMMASK = [];
	spawnsystem.iSPAWN_TEAMMASK_FREE = ( 1 << 0 );
	spawnsystem.iSPAWN_TEAMMASK["free"] = spawnsystem.iSPAWN_TEAMMASK_FREE;
	all = spawnsystem.iSPAWN_TEAMMASK_FREE;
	count = 1;
	foreach( team in level.teams )
	{
		spawnsystem.iSPAWN_TEAMMASK[team] = ( 1 << count );
		all = all | spawnsystem.iSPAWN_TEAMMASK[team];
		count++;
	}
	spawnsystem.iSPAWN_TEAMMASK["all"] = all;
}


/*
=============
onPlayerConnect

=============
*/
function onPlayerConnect()
{
	level endon ( "game_ended" );

	self setEnterTime( getTime() );

	self thread onPlayerSpawned();
	self thread onTeamChange();
	self thread onGrenadeThrow();
}


/*
=============
onPlayerSpawned

=============
*/
function onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	for(;;)
	{
		self waittill( "spawned_player" );
		
		//println("SPAWN:onPlayerSpawned() - spawned player event");
		self airsupport::clearMonitoredSpeed();

		self thread initialSpawnProtection();

		// If radar permanently enabled for the player, enable it
		if ( isdefined( self.pers["hasRadar"] ) && self.pers["hasRadar"] )
		{
			self.hasSpyplane = true;
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
function onDeath()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	self waittill ( "death" );
	
	self enable_player_influencers( false );
	
	// creating on the level so the player does not clean it up
	level create_friendly_influencer( "friend_dead", self.origin, self.team );
}

/*
=============
onTeamChange

Changes influencer teams when player changes teams
=============
*/
function onTeamChange()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	while(1)
	{
		self waittill ( "joined_team" );
		self player_influencers_set_team();
		{wait(.05);};
	}
}


/*
=============
onGrenadeThrow

Creates an influencer on grenade 
=============
*/
function onGrenadeThrow()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	while(1)
	{
		self waittill ( "grenade_fire", grenade, weapon );
		level thread create_grenade_influencers( self.pers["team"], weapon, grenade );
		{wait(.05);};
	}
}

function get_friendly_team_mask( team )
{
	if ( level.teambased )
	{
		team_mask = util::getTeamMask( team );
	}
	else
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	
	return team_mask;
}

function get_enemy_team_mask( team )
{
	if ( level.teambased )
	{
		team_mask = util::getOtherTeamsMask( team );
	}
	else
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	
	return team_mask;
}

function create_influencer( name, origin, team_mask )
{
	self.influencers[name] =  AddInfluencer( name, origin, team_mask );
//	/#println( "create_influencer: " + name + " id " + self.influencers[name] );#/
	
	self thread watch_remove_influencer();
	
	return self.influencers[name];
}

function create_friendly_influencer( name, origin, team )
{
	team_mask = self get_friendly_team_mask( team );
	
	self.influencersFriendly[name] = create_influencer( name, origin, team_mask );;
	
	return self.influencersFriendly[name];
}

function create_enemy_influencer( name, origin, team )
{
	team_mask = self get_enemy_team_mask( team );
	
	self.influencersEnemy[name] = create_influencer( name, origin, team_mask );
	
	return self.influencersEnemy[name];
}

function create_entity_influencer( name, team_mask )
{
	self.influencers[name] =  AddEntityInfluencer( name, self, team_mask );
//	/#println( "create_entity_influencer: " + name + " id " + self.influencers[name] );#/

	self thread watch_remove_influencer();
	
	return self.influencers[name] ;
}

function create_entity_friendly_influencer( name, team )
{
	team_mask = self get_friendly_team_mask( team );
	
	return self create_entity_masked_friendly_influencer( name, team_mask );
}

function create_entity_enemy_influencer( name, team )
{
	team_mask = self get_enemy_team_mask( team );
	
	return self create_entity_masked_enemy_influencer( name, team_mask );
}

function create_entity_masked_friendly_influencer( name, team_mask )
{
	self.influencersFriendly[name] = self create_entity_influencer( name, team_mask );
	
	return self.influencersFriendly[name];
}

function create_entity_masked_enemy_influencer( name, team_mask )
{
	self.influencersEnemy[name] = self create_entity_influencer( name, team_mask );
	
	return self.influencersEnemy[name];
}

function create_player_influencers()
{
	assert( !isdefined(self.influencers) );
	assert( !isdefined(self.influencers) );

	if ( !level.teambased )
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		enemy_teams_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else if ( isdefined( self.pers["team"] ) )
	{
		team = self.pers["team"];
		team_mask = util::getTeamMask( team );
		enemy_teams_mask = util::getOtherTeamsMask( team );
	}
	else
	{
		team_mask = 0;
		enemy_teams_mask = 0;
	}

	angles = self.angles;
	origin = self.origin;
	up = (0,0,1);
	forward = (1,0,0);
	
	self.influencers = [];
	self.friendlyInfluencers = [];
	self.enemyInfluencers = [];
	
	self create_entity_masked_enemy_influencer( "enemy", enemy_teams_mask );
	
	if ( level.teambased )
	{
		self create_entity_masked_friendly_influencer( "friend", team_mask );
	}
	
	if ( !isdefined(self.pers["team"]) || self.pers["team"] == "spectator" )
	{
		self enable_influencers( false );
	}
}

// influencers created for every spawn
function create_player_spawn_influencers( spawn_origin )
{
	// create a negative influencer for the opposition here
	level create_enemy_influencer( "enemy_spawn", spawn_origin, self.pers["team"] );
	level create_friendly_influencer( "friendly_spawn", spawn_origin, self.pers["team"] );
}

function remove_influencer( to_be_removed )
{
//	/#println( "remove_influencer: id " + to_be_removed );#/
	foreach ( influencer in self.influencers )
	{
		if ( influencer == to_be_removed )
		{
			RemoveInfluencer( influencer );
			
			ArrayRemoveValue( self.influencers, influencer );
			if ( IsDefined( self.influencersFriendly ) )
			{
				ArrayRemoveValue( self.influencersFriendly, influencer );
			}
			if ( IsDefined( self.influencersEnemy ) )
			{
				ArrayRemoveValue( self.influencersEnemy, influencer );
			}
			return;
		}
	}
}

function remove_influencers()
{
	if ( isdefined( self.influencers  ) )
	{
		foreach ( influencer in self.influencers )
		{
			RemoveInfluencer( influencer );
		}
  }
	    
	self.influencers = [];
	if ( IsDefined( self.influencersFriendly ) )
	{
		self.influencersFriendly = [];
	}
	if ( IsDefined( self.influencersEnemy ) )
	{
		self.influencersEnemy = [];
	}
}

function watch_remove_influencer()
{
	self endon("death");
	
	self notify("watch_remove_influencer" );
	self endon("watch_remove_influencer" );
	
	self waittill("influencer_removed", index );
	
	ArrayRemoveValue( self.influencers, index );
	if ( IsDefined( self.influencersFriendly ) )
	{
		ArrayRemoveValue( self.influencersFriendly, index );
	}
	if ( IsDefined( self.influencersEnemy ) )
	{
		ArrayRemoveValue( self.influencersEnemy, index );
	}
	
	self thread watch_remove_influencer();
}


function enable_influencers( enabled )
{
	foreach ( influencer in self.influencers )
	{
		EnableInfluencer( influencer, enabled );
	}
}

function enable_player_influencers( enabled )
{
	if (!isdefined(self.influencers))
		self create_player_influencers();

	self enable_influencers( enabled );
}

function player_influencers_set_team()
{
	if ( !level.teambased )
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		enemy_teams_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else
	{
		// for the player influencers we need to pay attention to the switchedsides
		team = self.pers["team"];
		
		team_mask = util::getTeamMask( team );
		enemy_teams_mask = util::getOtherTeamsMask( team );
	}

	if ( isDefined( self.influencersFriendly ) )
	{
		foreach ( influencer in self.influencersFriendly )
		{
			SetInfluencerTeammask( influencer, team_mask );
		}
	}
	if ( isDefined( self.influencersEnemy ) )
	{
		foreach ( influencer in self.influencersEnemy )
		{
			SetInfluencerTeammask( influencer, enemy_teams_mask );
		}
	}
}

function create_grenade_influencers( parent_team, weapon, grenade )
{	
	pixbeginevent("create_grenade_influencers");

	spawn_influencer = weapon.spawnInfluencer;
	
	if ( IsDefined( grenade.origin ) && spawn_influencer != "" )
	{
		if ( !level.teambased )
		{
			weapon_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		}
		else
		{
			weapon_team_mask = util::getOtherTeamsMask( parent_team );
	
			// if this is hardcore then we do not want to spawn infront of the weapon either
			if ( level.friendlyfire )
			{
				weapon_team_mask |= util::getTeamMask( parent_team );
			}
		}
	
		grenade create_entity_masked_enemy_influencer( spawn_influencer, weapon_team_mask );		
	}
	
	pixendevent();//"create_grenade_influencers" (moved from the bottom of the file - pix cannot extend over code with wait).
}

function create_map_placed_influencers()
{
	staticInfluencerEnts = GetEntArray( "mp_uspawn_influencer", "classname" );
	
	for ( i = 0; i < staticInfluencerEnts.size; i++ )
	{
		staticInfluencerEnt = staticInfluencerEnts[ i ];
	
		create_map_placed_influencer(staticInfluencerEnt);
	}
}

function create_map_placed_influencer( influencer_entity  )
{
	influencer_id = -1;
	
	if (isdefined(influencer_entity.script_noteworty))
	{
		team_mask = util::getTeamMask(influencer_entity.script_team);
		level create_enemy_influencer( influencer_entity.script_noteworty, influencer_entity.origin, team_mask );
	}
	else
	{
		assertmsg( "Radiant-placed spawn influencers require the 'script_noteworty' parameter" );
	}
	
	return influencer_id;
}

function updateAllSpawnPoints()
{
	// force spawn points to get precached
	foreach( team in level.teams )
	{ 
		gatherSpawnPoints( team );
	}
	
	clearSpawnPoints();
	
	if ( level.teambased )
	{
		foreach( team in level.teams )
		{ 
			addSpawnPoints( team, level.player_spawn_points[ team ].a );
		}
	}
	else
	{
		foreach( team in level.teams )
		{ 
			addSpawnPoints( "free", level.player_spawn_points[ team ].a );
		}
	}
	
	level.spawnAllMins = level.spawnMins;
	level.spawnAllMaxs = level.spawnMaxs;
	
	// this will remove all spawnpoints for the other gametypes which are not used
	remove_unused_spawn_entities();
}

/* ---------- spawn_point */

//void - self= player entity for the player who is spawning
function onSpawnPlayer(predictedSpawn)
{
	
	if (!isdefined( predictedSpawn ))
		predictedSpawn = false;
	
	/#
	if (GetDvarint( "scr_spawn_point_test_mode")!=0)
	{
		spawn_point = get_debug_spawnpoint( self );
		self spawn( spawn_point.origin, spawn_point.angles );
		return;
	}
	#/

	spawnOverride = self tacticalinsertion::overrideSpawn(predictedSpawn);
	spawnResurrect = self resurrect::overrideSpawn(predictedSpawn);

/#
		if ( isdefined(self.devguiLockSpawn) && self.devguiLockSpawn )
	{
		spawnResurrect = true;
	}
#/

	spawn_origin = undefined;
	spawn_angles = undefined;
	
	if ( spawnResurrect )
	{
		spawn_origin = self.resurrect_origin;
		spawn_angles = self.resurrect_angles;
	}
	else if ( spawnOverride )
	{
		if (predictedSpawn && isdefined( self.tacticalInsertion ))
		{
			// get the tactical insertion position
			// send this point as a message to the client
			self predictSpawnPoint( self.tacticalInsertion.origin, self.tacticalInsertion.angles );
			// println("predicted spawn [TI] - " + self.tacticalInsertion.origin );
		}
		return;
	}
	else if ( level.useStartSpawns || level.alwaysUseStartSpawns )
	{
		if( level.teambased )
		{
			spawnteam = self.pers["team"];
			if ( game["switchedsides"] )
				spawnteam = util::getOtherTeam( spawnteam );
			
			spawnpoint = spawnlogic::get_spawnpoint_random(level.spawn_start[spawnteam]);
		}
		else
		{
			spawnpoint = spawnlogic::get_spawnpoint_random(level.spawn_start);
		}
		
		if (isdefined(spawnpoint))
		{
			spawn_origin = spawnpoint.origin;
			spawn_angles = spawnpoint.angles;
		}
	}
	else 
	{
		// find the most desireable spawn point, and spawn there
		spawn_point = getSpawnPoint(self, predictedSpawn);
		
		if (isdefined(spawn_point))
		{
			spawn_origin = spawn_point["origin"];
			spawn_angles = spawn_point["angles"];
		}
	}
	
	if ( !isdefined(spawn_origin) )
	{
		/#	println("ERROR: unable to locate a usable spawn point for player");		#/
		callback::abort_level();
	}
	
	if ( predictedSpawn )
	{
		self predictSpawnPoint( spawn_origin, spawn_angles );
	}
	else
	{
		self spawn( spawn_origin, spawn_angles );
		
		self.lastspawntime = gettime();
		self enable_player_influencers( true );

		// on normal spawns create the spawned influencers
		if ( !spawnResurrect && !spawnOverride )
		{
			self create_player_spawn_influencers( spawn_origin );
		}
	}
}

// spawnPoint: .origin, .angles
function getSpawnPoint(
	player_entity,
	predictedSpawn )
{

	if (!isdefined( predictedSpawn ))
		predictedSpawn = false;
		
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

	if (level.teambased && isdefined(game["switchedsides"]) && game["switchedsides"] && level.spawnsystem.sideSwitching)
	{
		point_team = util::getOtherTeam(point_team);
	}
	
	best_spawn = get_best_spawnpoint( point_team, influencer_team, player_entity, predictedSpawn );
	
	if (!predictedSpawn)
	{
		player_entity.last_spawn_origin = best_spawn["origin"];
	}

	return best_spawn;
}

function get_debug_spawnpoint( player )
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
		spawn_counts = 0;
		foreach( team in level.teams )
		{
			spawn_counts += level.player_spawn_points[ team ].a.size;
		}
		
		if (level.test_spawn_point_index >= spawn_counts)
		{
			level.test_spawn_point_index= 0;
		}
		
		count = 0;
		foreach( team in level.teams )
		{
			size = level.player_spawn_points[ team ].a.size;
			if (level.test_spawn_point_index < count + size)
				return level.player_spawn_points[ team ].a[level.test_spawn_point_index - count];
			
			count += size;
		}
	}
	else
	{
		if (level.test_spawn_point_index >= level.player_spawn_points[ team ].a.size)
		{
			level.test_spawn_point_index= 0;
		}

		return level.player_spawn_points[ team ].a[level.test_spawn_point_index];

	}
}

function get_best_spawnpoint( point_team, influencer_team, player, predictedSpawn )
{
	if (level.teambased )
	{
		vis_team_mask = util::getOtherTeamsMask( player.pers["team"] );
	}
	else
	{
		vis_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
		
	spawn_point = GetBestSpawnPoint( point_team, influencer_team, vis_team_mask, player, predictedSpawn );
	
	if( !predictedSpawn )
	{
		// don't log predicted spawn points
		bbPrint( "mpspawnpointsused", "reason %s x %d y %d z %d", "point used", spawn_point["origin"] );
	}
	
	return spawn_point;
}

// struct.a[] = a contains spawn entities
function gatherSpawnPoints( player_team )
{	
	// use cached spawn points when they are available
	if ( !isdefined( level.player_spawn_points ) )
	{
		level.player_spawn_points = [];
	}
	else
	{
		if ( isdefined( level.player_spawn_points[ player_team ] ) )
		{
			return level.player_spawn_points[ player_team ];
		}
	}
	
	spawn_entities_s = util::spawn_array_struct();
	
	// also gather any old-style spawn points (the old world order)
	spawn_entities_s.a = spawnlogic::get_team_spawnpoints(player_team);
	if ( !isdefined(spawn_entities_s.a))
	{
		spawn_entities_s.a= [];
	}

	level.player_spawn_points[player_team] = spawn_entities_s;
	
	return spawn_entities_s;
}

/* ---------- private code */

/* ---------- spawn_influencer */

// These functions add the new influencers to the provided influencers array.

function is_hardcore()
{
	return isdefined( level.hardcoreMode )
		&& level.hardcoreMode;
}

function teams_have_enmity(
	team1,
	team2)
{
	// If either is undefined, then we don't know; assume they are enemies.
	// If the game is straight-up deathmatch, everyone is enemies (regardless of their assigned teams).
	if ( !isdefined( team1 ) || !isdefined( team2 ) || (level.gameType=="dm"))
		return true;
	
	return team1 != "neutral"
		&& team2 != "neutral"
		&& team1 != team2;
}

// Really would like to get rid of these gametype specific references to spawn points
// from this file, however right now there is no way of getting a array of
// all spawnpoints in a level.  They have to be asked for by classname.
function remove_unused_spawn_entities()
{
	spawn_entity_types = [];
	
	// TODO MTEAM - update this funcion for multiteam and just for all the new spawnpoints
	
	// dm
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dm_spawn";
	
	// tdm 
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_team1_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_team2_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_team3_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_team4_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_team5_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn_team6_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_tdm_spawn";
	
	// ctf
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_allies";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_ctf_spawn_axis";
	
	// dom
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn_flag_a";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn_flag_b";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dom_spawn_flag_c";
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

	// dem
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dem_spawn_attacker_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dem_spawn_defender_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dem_spawn_attackerOT_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dem_spawn_defenderOT_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dem_spawn_attacker";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_dem_spawn_defender";
	
	// twar
	spawn_entity_types[ spawn_entity_types.size ] = "mp_twar_spawn_axis_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_twar_spawn_allies_start";
	spawn_entity_types[ spawn_entity_types.size ] = "mp_twar_spawn";
	
	for ( i = 0; i < spawn_entity_types.size; i++ )
	{
		if ( spawn_point_class_name_being_used( spawn_entity_types[i] ) )
			continue;
			
		spawnpoints = spawnlogic::get_spawnpoint_array( spawn_entity_types[i] );
		
		delete_all_spawns( spawnpoints );
	}
}

function delete_all_spawns( spawnpoints )
{
	for ( i = 0; i < spawnpoints.size; i++ )
	{
		spawnpoints[i] delete();
	}
}

function spawn_point_class_name_being_used( name )
{
	if ( !isdefined( level.spawn_point_class_names ) )
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

// callback to process spawn point changes from Radiant Live Update
function CodeCallback_UpdateSpawnPoints()
{
	// rebuild the legacy spawn points
	foreach( team in level.teams )
	{
		spawnlogic::rebuild_spawn_points( team );
	}
	
	// make sure the list gets completely rebuilt
	level.player_spawn_points = undefined;
	updateAllSpawnPoints();	
}

function initialSpawnProtection()
{
	self endon( "death" );
	self endon( "disconnect" );

	self thread airsupport::monitorSpeed( level.spawnProtectionTime );
	
	if ( !isdefined( level.spawnProtectionTime ) || level.spawnProtectionTime == 0 )
	{
		return;
	}

	self.specialty_nottargetedbyairsupport = true;
	self clientfield::set( "killstreak_spawn_protection", 1 );
	self.ignoreme = true;
	wait level.spawnProtectionTime;
	self clientfield::set( "killstreak_spawn_protection", 0 );
	self.specialty_nottargetedbyairsupport = undefined;
	self.ignoreme = false;
}

function getTeamStartSpawnName( team, spawnpointNameBase )
{
	spawn_point_team_name = team;

	if ( !level.multiTeam && game["switchedsides"] )
		spawn_point_team_name = util::getOtherTeam( team );
	
	// for multi-team using slightly different start spawns for axis and allies
	if ( level.multiTeam )
	{
		if ( team == "axis" )
		 	spawn_point_team_name = "team1";
		else if ( team == "allies" )
		 	spawn_point_team_name = "team2";

		// for multi-round rotate the teams through all the start points
		if ( !util::isOneRound() )
		{
			// to zero based
			number = int( getsubstr( spawn_point_team_name, 4, 5) ) - 1;
			
			// back to one based
			number = (( number + game[ "roundsplayed" ]) % level.teams.size) + 1;
			
			spawn_point_team_name = "team" + number;
		}
	}
	
	return spawnpointNameBase + "_" + spawn_point_team_name + "_start" ;
}

function getTDMStartSpawnName( team )
{
	return getTeamStartSpawnName( team, "mp_tdm_spawn" );
}
