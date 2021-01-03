#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapons;

#using scripts\shared\bots\_bot;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_dev;

#using scripts\mp\_util;
#using scripts\mp\bots\_bot_combat;
#using scripts\mp\bots\_bot_conf;
#using scripts\mp\bots\_bot_ctf;
#using scripts\mp\bots\_bot_dem;
#using scripts\mp\bots\_bot_dom;
#using scripts\mp\bots\_bot_hq;
#using scripts\mp\bots\_bot_koth;
#using scripts\mp\bots\_bot_loadout;
#using scripts\mp\bots\_bot_sd;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_uav;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\teams\_teams;

#using scripts\shared\bots\_bot;
#using scripts\shared\bots\bot_traversals;

                                               	               	               	                	                                                               








 // from pathnode_db.h
 // from pathnode_db.h
	
#namespace bot;

function autoexec __init__sytem__() {     system::register("bot",&__init__,undefined,undefined);    }
	
function __init__()
{
	bot::init_shared();
	
	callback::on_start_gametype( &init );
}

function init()
{
/#
	level thread system_devgui_think();
	level thread system_devgui_gadget_think();
#/

	level thread bot_loadout::init();

	if ( !gametype_allowed() )
	{
		return;
	}

	if ( level.rankedMatch && !is_bot_ranked_match() )
	{
		return;
	}

	bot_friends = GetDvarInt( "bot_friends" );
	bot_enemies = GetDvarInt( "bot_enemies" );

	level.bot_traversal_abort = &update_wander;
	
	callback::on_spawned( &on_bot_spawned);
	
	if ( bot_friends <= 0 && bot_enemies <= 0 )
	{
		return;
	}
	
	wait_for_host();
	set_difficulty();
	
	if ( is_bot_comp_stomp() )
	{
		team = choose_comp_stomp_team();
		level thread comp_stomp_think( team );
	}
	else if ( is_bot_ranked_match() )
	{
		level thread ranked_think();
	}
	else
	{
		// either local, system link, or custom game
		level thread local_think();
	}
}

function on_bot_spawned()
{
	if ( self.pers[ "isBot" ] === true )
	{
		self ClearLookAt();
		self BotReleaseManualControl();
	}
}

function spawn( team )
{
	bot = AddTestClient();

	if ( isdefined( bot ) )
	{
		bot.pers[ "isBot" ] = true;

		if ( team != "autoassign" )
		{
			bot.pers[ "team" ] = team;
		}
		
		bot thread spawn_think( team );
		return true;
	}

	return false;
}

function getEnemyTeamWithLowestPlayerCount( player_team )
{
	counts = [];

	foreach( team in level.teams )
	{
		counts[ team ] = 0;
	}

	foreach( player in level.players )
	{
		if ( !isdefined( player.team ) )
			continue;

		if ( !isdefined( counts[player.team] ) )
			continue;

		counts[ player.team ]++;
	}

	count = 999999;
	enemy_team = player_team;
	
	foreach( team in level.teams )
	{
		if ( team == player_team )
			continue;

		if ( team == "spectator" )
			continue;
			
		if ( counts[team] < count )
		{
			enemy_team = team;
			count = counts[team];
		}
	}
	
	return enemy_team;
}

function getEnemyTeamWithGreatestBotCount( player_team )
{
	counts = [];

	foreach( team in level.teams )
	{
		counts[ team ] = 0;
	}

	foreach( player in level.players )
	{
		if ( !isdefined( player.team ) )
			continue;

		if ( !isdefined( counts[player.team] ) )
			continue;

		if ( !player util::is_bot() )
			continue;

		counts[ player.team ]++;
	}

	count = -1;
	enemy_team = undefined;

	foreach( team in level.teams )
	{
		if ( team == player_team )
			continue;

		if ( team == "spectator" )
			continue;

		if ( counts[team] > count )
		{
			enemy_team = team;
			count = counts[team];
		}
	}

	return enemy_team;
}

function wait_for_host()
{
	host = util::getHostPlayerForBots();
		
	while ( !isdefined( host ) )
	{
		wait( 0.25 );
		host = util::getHostPlayerForBots();
	}

	if ( level.PrematchPeriod > 0 && level.inPrematchPeriod == true )
	{
		wait( 1 );
	}
}

function count_humans( team )
{
	players = GetPlayers();
	count = 0;

	foreach( player in players )
	{
		if ( player util::is_bot() )
		{
			continue;
		}

		if ( isdefined( team ) )
		{
			if ( GetAssignedTeam( player ) == team )
			{
				count++;
			}
		}
		else
		{
			count++;
		}
	}

	return count;
}

function count_bots( team )
{
	players = GetPlayers();
	count = 0;

	foreach( player in players )
	{
		if ( !player util::is_bot() )
		{
			continue;
		}

		if ( isdefined( team ) )
		{
			if ( isdefined( player.team ) && player.team == team )
			{
				count++;
			}
		}
		else
		{
			count++;
		}
	}

	return count;
}

function count_enemy_bots( friend_team )
{
	if ( !level.teamBased )
	{
		return count_bots();
	}

	enemies = 0;

	foreach( team in level.teams )
	{
		if ( team == friend_team )
		{
			continue;
		}

		enemies += count_bots( team );
	}

	return enemies;
}

function choose_comp_stomp_team()
{
	host = util::getHostPlayerForBots();
	assert( isdefined( host ) );

	teamKeys = GetArrayKeys( level.teams );
	assert( teamKeys.size == 2 );

	enemy_team = host.pers[ "team" ];
	assert( isdefined( enemy_team ) && enemy_team != "spectator" );

	return ( util::getOtherTeam( enemy_team ) );
}

function comp_stomp_think( team )
{
	for ( ;; )
	{
		for ( ;; )
		{
			humans = count_humans();
			bots = count_bots();

			if ( humans == bots )
			{
				break;
			}

			if ( bots < humans )
			{
				bot::spawn( team );
			}

			if ( bots > humans )
			{
				comp_stomp_remove( team );
			}

			wait( 1 );
		}

		wait( 3 );
	}
}

function comp_stomp_remove( team )
{
	players = GetPlayers();
	bots = [];

	remove = undefined;

	foreach( player in players )
	{
		if ( !isdefined( player.team ) )
		{
			continue;
		}
		
		if ( player util::is_bot() )
		{
			if ( level.teamBased )
			{
				if ( player.team == team )
				{
					bots[ bots.size ] = player;
				}
			}
			else
			{
				bots[ bots.size ] = player;
			}
		}
	}

	if ( !bots.size )
	{
		return;
	}

	// try to find one that isn't in combat
	foreach( bot in bots )
	{
		if ( !bot bot_combat::has_enemy() )
		{
			remove = bot;
			break;
		}
	}

	if ( !isdefined( remove ) )
	{
		remove = array::random( bots );
	}

	remove BotLeaveGame();
}

function ranked_remove()
{
	if ( !level.teamBased )
	{
		comp_stomp_remove();
		return;
	}
	
	high = -1;
	highest_team = undefined;

	foreach( team in level.teams )
	{
		count = CountPlayers( team );

		if ( count > high )
		{
			high = count;
			highest_team = team;
		}
	}

	comp_stomp_remove( highest_team );
}

function ranked_count( team )
{
	count = CountPlayers( team );

	if ( count < 6 )
	{
		bot::spawn( team );
		return true;
	}
	else if ( count > 6 )
	{
		comp_stomp_remove( team );
		return true;
	}

	return false;
}

function ranked_think()
{
	level endon( "game_ended" );

	wait( 5 ); // try to let all players connect
	
	for ( ;; )
	{
		for ( ;; )
		{
			wait( 1 );

			teams = [];
			teams[0] = "axis";
			teams[1] = "allies";

			if ( math::cointoss() )
			{
				teams[0] = "allies";
				teams[1] = "axis";
			}

			if ( !ranked_count( teams[0] ) && !ranked_count( teams[1] ) )
			{
				break;
			}
		}

		level util::waittill_any( "connected", "disconnect" );
		wait( 5 );

		while ( IsDefined( level.hostMigrationTimer ) )
		{
			wait( 1 );
		}
	}
}

function local_friends( expected_friends, max, host_team )
{
	if ( level.teamBased )
	{
		players = GetPlayers();
		friends = count_bots( host_team );
		
		if ( friends < expected_friends && players.size < max )
		{
			bot::spawn( host_team );
			return true;
		}

		if ( friends > expected_friends )
		{
			comp_stomp_remove( host_team );
			return true;
		}
	}

	return false;
}

function local_enemies( expected_enemies, max, host_team )
{
	enemies = count_enemy_bots( host_team );
	players = GetPlayers();
	
	if ( enemies < expected_enemies && players.size < max )
	{
		team = getEnemyTeamWithLowestPlayerCount( host_team );
		bot::spawn( team );
		return true;
	}

	if ( enemies > expected_enemies )
	{
		team = getEnemyTeamWithGreatestBotCount( host_team );

		if ( isdefined( team ) )
		{
			comp_stomp_remove( team );
		}
		
		return true;
	}

	return false;
}

function local_think()
{
	wait( 5 ); // try to let all players connect

	host = util::getHostPlayerForBots();
	assert( isdefined( host ) );

	host_team = host.team;

	if ( !isdefined( host_team ) || host_team == "spectator" )
	{
		host_team = "allies";
	}

	bot_expected_friends = GetDvarInt( "bot_friends" );
	bot_expected_enemies = GetDvarInt( "bot_enemies" );

	max_players = ( IsLocalGame() ? 10 : 18 );
			
	for ( ;; )
	{
		for ( ;; )
		{
			if ( local_friends( bot_expected_friends, max_players, host_team ) )
			{
				wait( 0.5 );
				continue;
			}

			if ( local_enemies( bot_expected_enemies, max_players, host_team ) )
			{
				wait( 0.5 );
				continue;
			}

			break;
		}

		wait( 3 );
	}
}

function is_bot_comp_stomp()
{
	return( is_bot_ranked_match() && !GetDvarInt( "party_autoteams" ) );
}

function spawn_think( team )
{
	self endon( "disconnect" );

	while ( !isdefined( self.pers[ "bot_loadout" ] ) )
	{
		wait( 0.1 );
	}

	while( !isdefined( self.team ) )
	{
		wait .05;
	}

	if ( level.teambased )
	{
		self notify( "menuresponse", game["menu_team"], team );
		wait 0.5;
	}

	self notify( "joined_team" );
	callback::callback( #"on_joined_team" );

	bot_classes = build_classes();
	self notify( "menuresponse", "ChooseClass_InGame", array::random( bot_classes ) );
}

function build_classes()
{
	bot_classes = [];

	bot_classes[ bot_classes.size ] = "class_smg";
	bot_classes[ bot_classes.size ] = "class_cqb";	
	bot_classes[ bot_classes.size ] = "class_assault";
	bot_classes[ bot_classes.size ] = "class_lmg";
	bot_classes[ bot_classes.size ] = "class_sniper";

	return bot_classes;
}

function choose_class()
{
	bot_classes = build_classes();

	if ( ( self bot_combat::threat_requires_rocket( self.bot.attacker ) || self bot_combat::threat_is_qrdrone( self.bot.attacker ) ) &&
		 !bot_combat::threat_is_warthog( self.bot.attacker ) )
	{
		if ( RandomInt( 100 ) < 75 )
		{
			bot_classes[ bot_classes.size ] = "class_smg";
			bot_classes[ bot_classes.size ] = "class_cqb";	
			bot_classes[ bot_classes.size ] = "class_assault";
			bot_classes[ bot_classes.size ] = "class_lmg";
			bot_classes[ bot_classes.size ] = "class_sniper";
		}

		for( i = 0; i < bot_classes.size; i++ )
		{
			sidearm = self GetLoadoutWeapon( i, "secondary" );

			if ( sidearm.name == "fhj18" )
			{
				self notify( "menuresponse", "ChooseClass_InGame", bot_classes[i] );
				return;
			}
			else if ( sidearm.name == "smaw" )
			{
				bot_classes[ bot_classes.size ] = bot_classes[i];
				bot_classes[ bot_classes.size ] = bot_classes[i];
				bot_classes[ bot_classes.size ] = bot_classes[i];
			}
		}
	}

	if ( bot_combat::threat_requires_rocket( self.bot.attacker ) || 
		 bot_combat::threat_is_warthog( self.bot.attacker ) )
	{
		for( i = 0; i < bot_classes.size; i++ )
		{
			perks = self GetLoadoutPerks( i );

			foreach( perk in perks )
			{
				if ( perk == "specialty_nottargetedbyairsupport" )
				{
					bot_classes[ bot_classes.size ] = bot_classes[i];
					bot_classes[ bot_classes.size ] = bot_classes[i];
					bot_classes[ bot_classes.size ] = bot_classes[i];
				}
			}
		}
	}

	self notify( "menuresponse", "ChooseClass_InGame", array::random( bot_classes ) );
}

function bot_spawn()
{
	self endon( "disconnect" );

/#
	weapon = undefined;

	if ( GetDvarInt( "scr_botsHasPlayerWeapon" ) != 0 )
	{
		player = util::getHostPlayer();
		weapon = player GetCurrentWeapon();
	}

	if ( GetDvarString( "devgui_bot_weapon" ) != "" )
	{
		weapon = GetWeapon( GetDvarString( "devgui_bot_weapon" ) );
	}

	if ( isdefined( weapon ) && level.weaponNone != weapon )
	{
		self weapons::detach_all_weapons();
		self TakeAllWeapons();
		self GiveWeapon( weapon );
		self SwitchToWeapon( weapon );
		self SetSpawnWeapon( weapon );

		self teams::set_player_model( self.team, weapon );
	}
#/
	self spawn_init();

	if ( isdefined( self.bot_first_spawn ) )
	{
		self choose_class();
	}
		
	self.bot_first_spawn = true;
	self thread main();
/#
	self thread devgui_think();
#/
}

function spawn_init()
{
	time = GetTime();

	if ( !isdefined( self.bot ) )
	{
		self.bot		= SpawnStruct();
		self.bot.threat = SpawnStruct();
	}

	// behaviors
	self.bot.glass_origin				= undefined;
	self.bot.ignore_entity				= [];
	self.bot.previous_origin			= self.origin;
	self.bot.time_ads					= 0;
	self.bot.update_c4					= time + RandomIntRange( 1000, 3000 );
	self.bot.update_crate				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_crouch				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_failsafe			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_idle_lookat			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_killstreak			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_lookat				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_objective			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_objective_patrol	= time + RandomIntRange( 1000, 3000 );
	self.bot.update_patrol				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_toss				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_launcher			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_weapon				= time + RandomIntRange( 1000, 3000 );

	difficulty = get_difficulty();

	switch( difficulty )
	{
		case "easy":
			self.bot.think_interval = 0.5;
			self.bot.fov = 0.4226;
		break;
				
		case "normal":
			self.bot.think_interval = 0.25;
			self.bot.fov = 0.0872;
		break;

		case "hard":
			self.bot.think_interval = 0.2;
			self.bot.fov = -0.1736;
		break;

		case "fu":
			self.bot.think_interval = 0.1;
			self.bot.fov = -0.9396;
		break;

		default:
			self.bot.think_interval = 0.25;
			self.bot.fov = 0.0872;
		break;
	}
	
	// combat
	self.bot.threat.entity				= undefined;
	self.bot.threat.position			= ( 0, 0, 0 );
	self.bot.threat.time_first_sight	= 0;
	self.bot.threat.time_recent_sight	= 0;
	self.bot.threat.time_aim_interval	= 0;
	self.bot.threat.time_aim_correct	= 0;
	self.bot.threat.update_riotshield	= 0;
}

function wakeup_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	for ( ;; )
	{
		wait( self.bot.think_interval );
		self notify( "wakeup" );
	}
}

function damage_think()
{
	self notify( "bot_damage_think" );
	self endon( "bot_damage_think" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, mod, unused1, unused2, unused3, weapon, flags, inflictor );
		
		if ( attacker.classname == "worldspawn" )
		{
			continue;
		}

		if ( isdefined( weapon ) )
		{
			if ( weapon.name == "proximity_grenade" || weapon.name == "proximity_grenade_aoe" )
			{
				continue;
			}
			else if ( weapon.name == "claymore" )
			{
				continue;
			}
			else if ( weapon.name == "satchel_charge" )
			{
				continue;
			}
			else if ( weapon.name == "bouncingbetty" )
			{
				continue;
			}
		}

		if ( isdefined( inflictor ) )
		{
			switch( inflictor.classname )
			{
				case "auto_turret":
				case "script_vehicle":
					attacker = inflictor;
				break;

			}
		}

		if ( isdefined( attacker.viewlockedentity ) )
		{
			attacker = attacker.viewlockedentity;
		}

		if ( bot_combat::threat_requires_rocket( attacker ) || 
			 bot_combat::threat_is_warthog( attacker ) )
		{
			level thread killstreak_dangerous_think( self.origin, self.team, attacker );
		}

		self.bot.attacker = attacker;
		self notify( "wakeup", damage, attacker, direction );
	}
}

function killcam_think()
{
	self notify( "bot_killcam_think" );
	self endon( "bot_killcam_think" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	wait_time = 0.5;

	if ( level.playerRespawnDelay )
	{
		wait_time = level.playerRespawnDelay + 1.5;
	}

	if ( !level.killcam )
	{
		self waittill( "death" );
	}
	else
	{
		self waittill( "begin_killcam" );
	}
	
	wait( wait_time );

	for ( ;; )
	{
		self PressUseButton( 0.1 );
		wait( 0.5 );
	}
}

function glass_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	for ( ;; )
	{
		self waittill( "glass", origin );
		self.bot.glass_origin = origin;

		self notify( "wakeup" );
	}
}

function main()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	if ( level.inPrematchPeriod )
	{
		level waittill( "prematch_over" );
		self.bot.update_failsafe = GetTime() + RandomIntRange( 1000, 3000 );
	}

	self thread wakeup_think();
	self thread damage_think();
	self thread killcam_think();
	self thread glass_think();

	for ( ;; )
	{
		self waittill( "wakeup", damage, attacker, direction );

		if ( self IsRemoteControlling() )
		{
			continue;
		}
		//self update_wander();

		self bot_combat::combat_think( damage, attacker, direction );
				
		self update_glass();
		self update_patrol();
		self update_lookat();
		self update_killstreak();
		self update_wander();
		self update_c4();
		self update_launcher();
		self update_weapon();

		if ( math::cointoss() )
		{
			self update_toss_flash();
			self update_toss_frag();
		}
		else
		{
			self update_toss_frag();
			self update_toss_flash();
		}
		
		self [[level.bot_gametype]]();
	}
}

function failsafe_node_valid( nearest, node )
{
	if ( isdefined( node.script_noteworthy ) )
	{
		return false;
	}

	if ( node.origin[2] - self.origin[2] > 18 )
	{
		return false;
	}
	
	if ( nearest == node )
	{
		return false;
	}

	if ( !NodesVisible( nearest, node ) )
	{
		return false;
	}

	if ( self friend_in_radius( node.origin, 32 ) )
	{
		return false;
	}
		
	if ( isdefined( level.spawn_all ) && level.spawn_all.size > 0 )
	{
		spawns = ArraySort( level.spawn_all, node.origin );
	}
	else if ( isdefined( level.spawnpoints ) && level.spawnpoints.size > 0 )
	{
		spawns = ArraySort( level.spawnpoints, node.origin );
	}
	else if ( isdefined( level.spawn_start ) && level.spawn_start.size > 0 )
	{
		spawns = ArrayCombine( level.spawn_start[ "allies" ], level.spawn_start[ "axis" ], true, false );
		spawns = ArraySort( spawns, node.origin );
	}
	else
	{
		return false;
	}

	goal = bot_combat::nearest_node( spawns[0].origin );

	if ( IsDefined( goal ) && self FindPath( node.origin, goal.origin, false, true ) )
	{
		return true;
	}

	return false;
}

// returns the mantle start node if it is behind the bot
function get_mantle_start()
{
	dist = self GetLookAheadDist();
	dir = self GetLookaheadDir();

	if ( dist > 0 && IsDefined( dir ) )
	{
		forward = AnglesToForward( self.angles );

		if ( VectorDot( dir, forward ) < 0 )
		{
			dir = VectorScale( dir, dist );
			origin = self.origin + dir;

			nodes = GetNodesInRadius( origin, 16, 0, 16, "Begin" );

			if ( nodes.size && nodes[0].spawnflags & (1 << 23) )
			{
				return nodes[0];
			}
		}
	}

	return undefined;
}

// attempts to determine if a bot that is mantling has actually jumped instead
// can also erroneously return true if the bot is falling from a height
function is_traversing()
{
	if ( !self IsOnGround() )
	{
		return ( !self IsMantling() && !self IsOnLadder() );
	}

	return false;
}

function update_failsafe()
{
	return;

	time = GetTime();
	
	if ( time - self.spawntime < 7500 )
	{
		return;
	}

	if ( is_traversing() )
	{
		wait( 0.25 );

		node = get_mantle_start();

		if ( IsDefined( node ) )
		{
			end = GetNode( node.target, "targetname" );
			self ClearLookAt();

			// force the bot to the end node
			self BotSetFailsafeNode( end );
			self util::wait_endon( 1, "goal" );
			self BotSetFailsafeNode();
			return;
		}
	}

	if ( time < self.bot.update_failsafe )
	{
		return;
	}

	if ( self IsMantling() || self IsOnLadder() || !self IsOnGround() )
	{
		wait( RandomFloatRange( 0.1, 0.25 ) );
		return;
	}

	if ( !self AtGoal() && Distance2DSquared( self.bot.previous_origin, self.origin ) < 16 * 16 )
	{
		nodes = GetNodesInRadius( self.origin, 512, 0 );
		nodes = array::randomize( nodes );

		nearest = bot_combat::nearest_node( self.origin );

		failsafe = false;

		if ( isdefined( nearest ) )
		{
			foreach( node in nodes )
			{
				if ( !failsafe_node_valid( nearest, node ) )
				{
					continue;
				}

				self BotSetFailsafeNode( node );
				wait( 0.5 );

				self.bot.update_idle_lookat = 0;
				self update_lookat();

				self CancelGoal( "enemy_patrol" );
				self util::wait_endon( 4, "goal" );
				self BotSetFailsafeNode();
				self update_lookat();
				failsafe = true;
				break;
			}
		}

		if ( !failsafe && nodes.size )
		{
			node = array::random( nodes );

			self BotSetFailsafeNode( node );
			wait( 0.5 );

			self.bot.update_idle_lookat = 0;
			self update_lookat();

			self CancelGoal( "enemy_patrol" );
			self util::wait_endon( 4, "goal" );
			self BotSetFailsafeNode();
			self update_lookat();
		}
	}

	self.bot.update_failsafe = GetTime() + 3500;
	self.bot.previous_origin = self.origin;
}

function update_crouch()
{
	time = GetTime();
	
	if ( time < self.bot.update_crouch )
	{
		return;
	}

	if ( self AtGoal() )
	{
		return;
	}

	if ( self IsMantling() || self IsOnLadder() || !self IsOnGround() )
	{
		return;
	}
			
	dist = self GetLookAheadDist();
	
	if ( dist > 0 )
	{
		dir = self GetLookaheadDir();
		assert( isdefined( dir ) );

		dir = VectorScale( dir, dist );

		start = self.origin + ( 0, 0, 70 );
		end = start + dir;

		if ( dist >= 256 )
		{
			self.bot.update_crouch = time + 1500;
		}

		stance = self GetStance();
		
		if ( stance == "stand" )
		{
			trace = WorldTrace( start, end );
			if ( trace["fraction"] < 1 )
			{
				self SetStance( "crouch" );
				self.bot.update_crouch = time + 2500;
			}
		}
		else if ( stance == "crouch" )
		{
			currentWeapon = self GetCurrentWeapon();
		
			if( !currentWeapon.isRiotShield )
			{
				trace = WorldTrace( start, end );
				if ( trace["fraction"] >= 1 )
				{
					self SetStance( "stand" );
				}
			}
			else
			{
				currentNode = GetNearestNode(self.origin);
				
				if ( IsDefined( currentNode ) && ( isdefined( currentNode.spawnflags & (1 << 23) ) && currentNode.spawnflags & (1 << 23) ) )//|| currentNode.spawnflags & PNF_HINT_LADDER ) // ladder is handled correctly so this is not needed
				{
					self SetStance( "stand" );
					self.bot.update_crouch = time + 1000;
				}
			}
		}
	}
}

function update_glass()
{
	if ( isdefined( self.bot.glass_origin ) )
	{
		forward = AnglesToForward( self.angles );
		dir = VectorNormalize( self.bot.glass_origin - self.origin );

		dot = VectorDot( forward, dir );

		if ( dot > 0 )
		{
			self LookAt( self.bot.glass_origin );

			wait_time = 0.5 * ( 1 - dot );
			wait_time = math::clamp( wait_time, 0.05, 0.5 );
			wait( wait_time );

			self PressMelee();
			wait( 0.25 );

			self ClearLookAt();
			self.bot.glass_origin = undefined;
		}
	}
}

function has_radar()
{
	if ( level.teambased )
	{
		return ( uav::HasUAV( self.team ) || satellite::HasSatellite( self.team ) );
	}
	
	return ( uav::HasUAV( self.entnum ) || satellite::HasSatellite( self.entnum ) );
}

function get_enemies( on_radar )
{
	if ( !isdefined( on_radar ) )
	{
		on_radar = false;
	}

	enemies = self GetEnemies();

/#
	for ( i = 0; i < enemies.size; i++ )
	{
		if ( isplayer( enemies[i] ) && enemies[i] IsInMoveMode( "ufo", "noclip" ) )
		{
			ArrayRemoveIndex( enemies, i );
			i--;
		}
	}
#/

	if ( on_radar && !self has_radar() )
	{
		for ( i = 0; i < enemies.size; i++ )
		{
			if ( !isdefined( enemies[i].lastFireTime ) )
			{
				ArrayRemoveIndex( enemies, i );
				i--;
			}
			else if ( GetTime() - enemies[i].lastFireTime > 2000 ) 
			{
				ArrayRemoveIndex( enemies, i );
				i--;
			}
		}
	}

	return enemies;
}

function get_friends()
{
	friends = self GetFriendlies( true );

/#
	for ( i = 0; i < friends.size; i++ )
	{
		if ( friends[i] IsInMoveMode( "ufo", "noclip" ) )
		{
			ArrayRemoveIndex( friends, i );
			i--;
		}
	}
#/

	return friends;
}

function friend_goal_in_radius( goal_name, origin, radius )
{
	count = 0;
	friends = get_friends();

	foreach( friend in friends )
	{
		if ( friend util::is_bot() )
		{
			goal = friend GetGoal( goal_name );

			if ( isdefined( goal ) && DistanceSquared( origin, goal ) < radius * radius )
			{
				count++;
			}
		}
	}

	return count;
}

function friend_in_radius( origin, radius )
{
	friends = get_friends();

	foreach( friend in friends )
	{
		if ( DistanceSquared( friend.origin, origin ) < radius * radius )
		{
			return true;
		}
	}

	return false;
}

function get_closest_enemy( origin, on_radar )
{
	enemies = self get_enemies( on_radar );
	enemies = ArraySort( enemies, origin );

	if ( enemies.size )
	{
		return enemies[0];
	}

	return undefined;
}

function update_wander()
{
	goal = self GetGoal( "wander" );

	if ( isdefined( goal ) )
	{
		return;
	}

	if ( isdefined( level.spawn_all ) && level.spawn_all.size > 0 )
	{
		spawns = ArraySort( level.spawn_all, self.origin );
	}
	else if ( isdefined( level.spawnpoints ) && level.spawnpoints.size > 0 )
	{
		spawns = ArraySort( level.spawnpoints, self.origin );
	}
	else if ( isdefined( level.spawn_start ) && level.spawn_start.size > 0 )
	{
		spawns = ArrayCombine( level.spawn_start[ "allies" ], level.spawn_start[ "axis" ], true, false );
		spawns = ArraySort( spawns, self.origin );
	}
	else
	{
		return;
	}

	spawn = array::random( spawns );
	self AddGoal( spawn.origin, 24, 1, "wander" );
}

function get_look_at()
{
	enemy = self bot::get_closest_enemy( self.origin, true );

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
		{
			return node.origin;
		}
	}

	enemies = self get_enemies( false );

	if ( enemies.size )
	{
		enemy = array::random( enemies );
	}

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
		{
			return node.origin;
		}
	}

	spawn = self GetGoal( "wander" );

	if ( isdefined( spawn ) )
	{
		node = GetVisibleNode( self.origin, spawn );
	}
	
	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
	{
		return node.origin;
	}

	return undefined;
}

function update_lookat()
{
	path = isdefined( self GetLookaheadDir() );
		
	if ( !path && GetTime() > self.bot.update_idle_lookat )
	{
		// bot is standing idle
		origin = get_look_at();
		
		if ( !isdefined( origin ) )
		{
			return;
		}

		self LookAt( origin + ( 0, 0, 16 ) );
		
		 self.bot.update_idle_lookat = GetTime() + RandomIntRange( 1500, 3000 );
	}
	else if ( path && self.bot.update_idle_lookat > 0 )
	{
		self ClearLookAt();
		self.bot.update_idle_lookat = 0;
	}
}

function update_patrol()
{
	closest = get_closest_enemy( self.origin, true );
	
	if ( isdefined( closest ) && DistanceSquared( self.origin, closest.origin ) < 512 * 512 )
	{
		goal = self GetGoal( "enemy_patrol" );

		if ( isdefined( goal ) && DistanceSquared( goal, closest.origin ) > 128 * 128 )
		{
			self CancelGoal( "enemy_patrol" );
			self.bot.update_patrol = 0;
		}
	}

	if ( GetTime() < self.bot.update_patrol )
	{
		return;
	}
	
	self bot_combat::patrol_near_enemy();
	self.bot.update_patrol = GetTime() + RandomIntRange( 5000, 10000 );
}

function update_toss_flash()
{
	if ( get_difficulty() == "easy" )
	{
		return;
	}

	time = GetTime();

	if ( time - self.spawntime < 7500 )
	{
		return;
	}

	if ( time < self.bot.update_toss )
	{
		return;
	}

	self.bot.update_toss = time + 1500;
	
	if ( self GetWeaponAmmoStock( GetWeapon( "sensor_grenade" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "proximity_grenade" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "trophy_system" ) ) <= 0 )
	{
		return;
	}

	enemy = self bot::get_closest_enemy( self.origin, true );
	node = undefined;

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );
	}

	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) < 256 * 256 )
	{
		self LookAt( node.origin );
		wait( 0.75 );
		self PressAttackButton( 2 );
		self.bot.update_toss = time + 20000;
		self ClearLookAt();
	}
}

function update_toss_frag()
{
	if ( get_difficulty() == "easy" )
	{
		return;
	}

	time = GetTime();

	if ( time - self.spawntime < 7500 )
	{
		return;
	}

	if ( time < self.bot.update_toss )
	{
		return;
	}

	self.bot.update_toss = time + 1500;

	if ( self GetWeaponAmmoStock( GetWeapon( "bouncingbetty" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "claymore" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "satchel_charge" ) ) <= 0 )
	{
		return;
	}

	enemy = self bot::get_closest_enemy( self.origin, true );
	node = undefined;

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );
	}

	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) < 256 * 256 )
	{
		self LookAt( node.origin );
		wait( 0.75 );
		self PressAttackButton( 1 );
		self.bot.update_toss = time + 20000;
		self ClearLookAt();
	}
}

function set_rank()
{
	players = GetPlayers();

	ranks = [];
	bot_ranks = [];
	human_ranks = [];

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] == self )
			continue;

		if ( isdefined( players[i].pers[ "rank" ] ) )
		{
			if ( players[i] util::is_bot() )
			{
				bot_ranks[ bot_ranks.size ] = players[i].pers[ "rank" ];
			}
			else
			{
				human_ranks[ human_ranks.size ] = players[i].pers[ "rank" ];
			}
		}
	}

	if( !human_ranks.size )
		human_ranks[ human_ranks.size ] = 10;

	human_avg = math::array_average( human_ranks );

	while ( bot_ranks.size + human_ranks.size < 5 )
	{
		// add some random ranks for better random number distribution
		r = human_avg + RandomIntRange( -5, 5 );
		rank = math::clamp( r, 0, level.maxRank );
		human_ranks[ human_ranks.size ] = rank;
	}

	ranks = ArrayCombine( human_ranks, bot_ranks, true, false );

	avg = math::array_average( ranks );
	s = math::array_std_deviation( ranks, avg );
	
	rank = Int( math::random_normal_distribution( avg, s, 0, level.maxRank ) );
	
	self.pers[ "rank" ] = rank;
	self.pers[ "rankxp" ] = rank::getRankInfoMinXP( rank );

	self setRank( rank );
	self rank::syncXPStat();
}

function gametype_allowed()
{
	level.bot_gametype =&gametype_void;

	switch( level.gameType )
	{
		case "dm":
		case "tdm":
			return true;

		case "ctf":
			level.bot_gametype = &bot_ctf::ctf_think;
			return true;

		case "dem":
			level.bot_gametype = &bot_dem::dem_think;
			return true;

		case "dom":
			level.bot_gametype = &bot_dom::dom_think;
			return true;
			
		case "koth":
			level.bot_gametype = &bot_koth::koth_think;
			return true;
			
		case "hq":
			level.bot_gametype = &bot_hq::hq_think;
			return true;

		case "conf":
			level.bot_gametype = &bot_conf::conf_think;
			return true;

		case "sd":
//		case "sr":
			level.bot_gametype = &bot_sd::sd_think;
			return true;
	}

	return false;
}

function get_difficulty()
{
	if ( !isdefined( level.bot_difficulty ) )
	{
		level.bot_difficulty = "normal";
		difficulty = GetDvarInt( "bot_difficulty", 1 );

		if ( difficulty == 0 )
		{
			level.bot_difficulty = "easy";
		}
		else if ( difficulty == 1 )
		{
			level.bot_difficulty = "normal";
		}
		else if ( difficulty == 2 )
		{
			level.bot_difficulty = "hard";
		}
		else if ( difficulty == 3 )
		{
			level.bot_difficulty = "fu";
		}
	}

	return level.bot_difficulty;
}

function set_difficulty()
{
	difficulty = get_difficulty();

	if ( difficulty == "fu" )
	{
		SetDvar( "bot_MinDeathTime",	"250" );
		SetDvar( "bot_MaxDeathTime",	"500" );
		SetDvar( "bot_MinFireTime",		"100" );
		SetDvar( "bot_MaxFireTime",		"250" );
		SetDvar( "bot_PitchUp",			"-5" );
		SetDvar( "bot_PitchDown",		"10" );
		SetDvar( "bot_Fov",				"160" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",	"100" );
		SetDvar( "bot_MaxCrouchTime",	"400" );
		SetDvar( "bot_TargetLeadBias",	"2" );
		SetDvar( "bot_MinReactionTime",	"40" );
		SetDvar( "bot_MaxReactionTime",	"70" );
		SetDvar( "bot_StrafeChance",	"1" );
		SetDvar( "bot_MinStrafeTime",	"3000" );
		SetDvar( "bot_MaxStrafeTime",	"6000" );
		SetDvar( "scr_help_dist",		"512" );
		SetDvar( "bot_AllowGrenades",	"1"	);
		SetDvar( "bot_MinGrenadeTime",	"1500" );
		SetDvar( "bot_MaxGrenadeTime",	"4000" );
		SetDvar( "bot_MeleeDist",		"70" );
//		SetDvar( "bot_YawSpeed",		"1" ); // perfect turning
	}
	else if ( difficulty == "hard" )
	{
		SetDvar( "bot_MinDeathTime",	"250" );
		SetDvar( "bot_MaxDeathTime",	"500" );
		SetDvar( "bot_MinFireTime",		"400" );
		SetDvar( "bot_MaxFireTime",		"600" );
		SetDvar( "bot_PitchUp",			"-5" );
		SetDvar( "bot_PitchDown",		"10" );
		SetDvar( "bot_Fov",				"100" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",	"100" );
		SetDvar( "bot_MaxCrouchTime",	"400" );
		SetDvar( "bot_TargetLeadBias",	"2" );
		SetDvar( "bot_MinReactionTime",	"400" );
		SetDvar( "bot_MaxReactionTime",	"700" );
		SetDvar( "bot_StrafeChance",	"0.9" );
		SetDvar( "bot_MinStrafeTime",	"3000" );
		SetDvar( "bot_MaxStrafeTime",	"6000" );
		SetDvar( "scr_help_dist",		"384" );
		SetDvar( "bot_AllowGrenades",	"1"	);
		SetDvar( "bot_MinGrenadeTime",	"1500" );
		SetDvar( "bot_MaxGrenadeTime",	"4000" );
		SetDvar( "bot_MeleeDist",		"70" );
//		SetDvar( "bot_YawSpeed",		"0.7" );
	}
	else if ( difficulty == "easy" )
	{
		SetDvar( "bot_MinDeathTime",	"1000" );
		SetDvar( "bot_MaxDeathTime",	"2000" );
		SetDvar( "bot_MinFireTime",		"900" );
		SetDvar( "bot_MaxFireTime",		"1000" );
		SetDvar( "bot_PitchUp",			"-20" );
		SetDvar( "bot_PitchDown",		"40" );
		SetDvar( "bot_Fov",				"50" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",	"4000" );
		SetDvar( "bot_MaxCrouchTime",	"6000" );
		SetDvar( "bot_TargetLeadBias",	"8" );
		SetDvar( "bot_MinReactionTime",	"1200" );
		SetDvar( "bot_MaxReactionTime",	"1600" );
		SetDvar( "bot_StrafeChance",	"0.1" );
		SetDvar( "bot_MinStrafeTime",	"3000" );
		SetDvar( "bot_MaxStrafeTime",	"6000" );
		SetDvar( "scr_help_dist",		"256" );
		SetDvar( "bot_AllowGrenades",	"0"	);
		SetDvar( "bot_MeleeDist",		"40" );
//		SetDvar( "bot_YawSpeed",		"0.1" );
	}
	else // 'normal' difficulty
	{
		SetDvar( "bot_MinDeathTime",	"500" );
		SetDvar( "bot_MaxDeathTime",	"1000" );
		SetDvar( "bot_MinFireTime",		"600" );
		SetDvar( "bot_MaxFireTime",		"800" );
		SetDvar( "bot_PitchUp",			"-10" );
		SetDvar( "bot_PitchDown",		"20" );
		SetDvar( "bot_Fov",				"70" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",	"2000" );
		SetDvar( "bot_MaxCrouchTime",	"4000" );
		SetDvar( "bot_TargetLeadBias",	"4" );
		SetDvar( "bot_MinReactionTime",	"600" );
		SetDvar( "bot_MaxReactionTime",	"800" );
		SetDvar( "bot_StrafeChance",	"0.6" );
		SetDvar( "bot_MinStrafeTime",	"3000" );
		SetDvar( "bot_MaxStrafeTime",	"6000" );
		SetDvar( "scr_help_dist",		"256" );
		SetDvar( "bot_AllowGrenades",	"1"	);
		SetDvar( "bot_MinGrenadeTime",	"1500" );
		SetDvar( "bot_MaxGrenadeTime",	"4000" );
		SetDvar( "bot_MeleeDist",		"70" );
//		SetDvar( "bot_YawSpeed",		"0.4" );
	}

	if ( level.gameType == "oic" && difficulty == "fu" )
	{
		SetDvar( "bot_MinReactionTime",	"400" );
		SetDvar( "bot_MaxReactionTime",	"500" );
		SetDvar( "bot_MinAdsTime",		"1000" );
		SetDvar( "bot_MaxAdsTime",		"2000" );
	}

	if ( level.gameType == "oic" && ( difficulty == "hard" || difficulty == "fu" ) )
	{
		SetDvar( "bot_SprintDistance",	"256" );
	}
}

function update_c4()
{
	if ( !isdefined( self.weaponObjectWatcherArray ) )
	{
		return;
	}

	time = GetTime();

	if ( time < self.bot.update_c4 )
	{
		return;
	}

	self.bot.update_c4 = time + RandomIntRange( 1000, 2000 );

	foreach( watcher in self.weaponObjectWatcherArray )
	{
		if ( watcher.name == "satchel_charge" )
		{
			break;
		}
	}

	radius_sq = watcher.weapon.explosionRadius;
	if ( watcher.objectarray.size )
	{
		foreach( weapon in watcher.objectarray )
		{
			if ( !isdefined( weapon ) )
			{
				continue;
			}

			enemy = get_closest_enemy( weapon.origin, false );

			if ( !isdefined( enemy ) )
			{
				return;
			}

			if ( DistanceSquared( enemy.origin, weapon.origin ) < radius_sq )
			{
				self PressAttackButton( 1 );
				return;
			}
		}
	}
}

function update_launcher()
{
	time = GetTime();

	if ( time < self.bot.update_launcher )
	{
		return;
	}

	self.bot.update_launcher = time + RandomIntRange( 5000, 10000 );

	if ( !self bot_combat::has_launcher() )
	{
		return;
	}

	enemies = self GetThreats( -1 );

	foreach( enemy in enemies )
	{
		if ( !Target_IsTarget( enemy ) )
		{
			continue;
		}

		if ( bot_combat::threat_is_warthog( enemy ) )
		{
			continue;
		}

		if ( !bot_combat::threat_requires_rocket( enemy ) )
		{
			continue;
		}

		origin = self GetPlayerCameraPos();
		angles = VectorToAngles( enemy.origin - origin );

		if ( angles[0] < 290 )
		{
			continue;
		}

		if ( self BotSightTracePassed( enemy ) )
		{
			self bot_combat::lookat_entity( enemy );
			
			return;
		}
	}
}

function update_weapon()
{
	time = GetTime();

	if ( time < self.bot.update_weapon )
	{
		return;
	}

	self.bot.update_weapon = time + RandomIntRange( 5000, 7500 );

	weapon = self GetCurrentWeapon();
	ammo = self GetWeaponAmmoClip( weapon ) + self GetWeaponAmmoStock( weapon );
	
	if ( weapon == level.weaponNone )
	{
		return;
	}

	if ( self bot_combat::can_reload() )
	{
		frac = 0.5;

		if ( bot_combat::has_lmg() )
		{
			frac = 0.25;
		}

		frac += RandomFloatRange( -0.1, 0.1 );

		if ( bot_combat::weapon_ammo_frac() < frac )
		{
			self PressUseButton( 0.1 );
			return;
		}
	}

	if ( ammo && !self bot_combat::has_pistol() && !self bot_combat::using_launcher() )
	{
		return;
	}
	
	primaries = self GetWeaponsListPrimaries();

	foreach( primary in primaries )
	{
		if ( primary == level.weaponBaseMeleeHeld )
		{
			continue;
		}

		if ( primary != weapon && ( self GetWeaponAmmoClip( primary ) || self GetWeaponAmmoStock( primary ) ) && !self IsReloading() && !self IsSwitchingWeapons() )
		{
			self SwitchToWeapon( primary );
			return;
		}
	}
}

// ensure bots don't get stuck on crates for too long
function update_crate()
{
	time = GetTime();

	if ( time < self.bot.update_crate )
	{
		return;
	}

	self.bot.update_crate = time + RandomIntRange( 1000, 3000 );
	self CancelGoal( "care package" );

	radius = GetDvarFloat( "player_useRadius" );
	crates = GetEntArray( "care_package", "script_noteworthy" );

	foreach( crate in crates )
	{
		if ( DistanceSquared( self.origin, crate.origin ) < radius * radius )
		{
			if ( isdefined( crate.hacker ) )
			{
				if ( crate.hacker == self )
				{
					continue;
				}

				if ( crate.hacker.team == self.team )
				{
					continue;
				}
			}

			if ( crate.owner == self )
			{
				time = level.crateOwnerUseTime / 1000 + 0.5;
			}
			else
			{
				time = level.crateNonOwnerUseTime / 1000 + 0.5;
			}

			self SetStance( "crouch" );
			self AddGoal( self.origin, 24, 4, "care package" );
			self PressUseButton( time );

			wait( time );

			self SetStance( "stand" );
			self CancelGoal( "care package" );

			self.bot.update_crate = GetTime() + RandomIntRange( 1000, 3000 );
			return;
		}
		
	}

	if ( self GetWeaponAmmoStock( GetWeapon( "pda_hack" ) ) )
	{
		foreach( crate in crates )
		{
			if ( !isdefined( crate.friendlyObjID ) )
			{
				continue;
			}

			if ( isdefined( crate.hacker ) )
			{
				if ( crate.hacker == self )
				{
					continue;
				}

				if ( crate.hacker.team == self.team )
				{
					continue;
				}
			}

			if ( self BotSightTracePassed( crate ) )
			{
				self LookAt( crate.origin );
				self AddGoal( self.origin, 24, 4, "care package" );
				wait( 0.75 );

				start = GetTime();

				if ( !IsDefined( crate.owner ) )
				{
					self CancelGoal( "care package" );
					return;
				}

				if ( crate.owner == self )
				{
					end = level.crateOwnerUseTime + 1000;
				}
				else
				{
					end = level.crateNonOwnerUseTime + 1000;
				}

				while( GetTime() < start + end )
				{
					self PressAttackButton( 2 );
					{wait(.05);};
				}

				self.bot.update_crate = GetTime() + RandomIntRange( 1000, 3000 );
				self CancelGoal( "care package" );
				return;
			}
		}
	}
}

function update_killstreak()
{
	if ( !level.loadoutKillstreaksEnabled )
	{
		return;
	}

	time = GetTime();

	if ( time < self.bot.update_killstreak )
	{
		return;
	}

	if ( self IsWeaponViewOnlyLinked() )
	{
		return;
	}

/#
	if ( !GetDvarInt( "scr_botsAllowKillstreaks" ) )
	{
		return;
	}
#/

	self.bot.update_killstreak = time + RandomIntRange( 1000, 3000 );
	weapons = self GetWeaponsList();
	ks_weapon = undefined;

	inventoryWeapon = self GetInventoryWeapon();
		
	foreach( weapon in weapons )
	{
		if ( self GetWeaponAmmoClip( weapon ) <= 0 && ( !isdefined( inventoryWeapon ) || weapon != inventoryWeapon ) )
		{
			continue;
		}
		
		if ( killstreaks::is_killstreak_weapon( weapon ) )
		{
			killstreak = killstreaks::get_killstreak_for_weapon( weapon );

			if ( self killstreakrules::isKillstreakAllowed( killstreak, self.team ) )
			{
				ks_weapon = weapon;
				break;
			}
		}
	}

	if ( !isdefined( ks_weapon ) )
	{
		return;
	}

	killstreak = killstreaks::get_killstreak_for_weapon( ks_weapon );
	killstreak_ref = killstreaks::get_menu_name( killstreak );

	if ( !isdefined( killstreak_ref ) )
	{
		return;
	}

	switch( killstreak_ref )
	{
		case "killstreak_helicopter_comlink":
			killstreak_location( 1, weapon );
		break;

		case "killstreak_planemortar":
			killstreak_location( 3, weapon );
		break;

		case "killstreak_supply_drop":
		case "killstreak_ai_tank_drop":
		case "killstreak_missile_drone":
			self use_supply_drop( weapon );
		break;

		case "killstreak_auto_turret":
		case "killstreak_tow_turret":
		case "killstreak_microwave_turret":
			self turret_location( weapon );
		break;

		case "killstreak_rcbomb":
		case "killstreak_qrdrone":
		case "killstreak_remote_mortar":
		//case "killstreak_helicopter_player_gunner":
			return;

		case "killstreak_remote_missile":
			if ( time - self.spawntime < 6000 )
			{
				self SwitchToWeapon( weapon );
				self waittill( "weapon_change_complete" );
				wait( 1.5 );
				self PressAttackButton();
			}
			return;

		default:
			self SwitchToWeapon( weapon );
		break;
	}
}

function get_vehicle_entity()
{
	if ( self IsRemoteControlling() )
	{
		if ( isdefined( self.rcbomb ) )
		{
			return self.rcbomb;
		}
		else if ( isdefined( self.QRDrone ) )
		{
			return self.QRDrone;
		}
	}

	return undefined;
}

function rccar_think()
{
	self endon( "disconnect" );
	self endon( "rcbomb_done" );
	self endon( "weapon_object_destroyed" );
	level endon ( "game_ended" );

	wait( 2 );

	self thread rccar_kill();

	for ( ;; )
	{
		wait( 0.5 );

		ent = self get_vehicle_entity();

		if ( !isdefined( ent ) )
		{
			return;
		}

		players = GetPlayers();

		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( player == self )
			{
				continue;
			}

			if ( !IsAlive( player ) )
			{
				continue;
			}

			if ( level.teamBased && player.team == self.team )
			{
				continue;
			}

		/#
			if ( player IsInMoveMode( "ufo", "noclip" ) )
			{
				continue;
			}
		#/

			if ( get_difficulty() == "easy" )
			{
				if ( DistanceSquared( ent.origin, player.origin ) < 512 * 512 )
				{
					self PressAttackButton();
				}
			}
			else if ( DistanceSquared( ent.origin, player.origin ) < 200 * 200 )
			{
				self PressAttackButton();
			}
		}
	}
}

// failsafe for stuck cars
function rccar_kill()
{
	self endon( "disconnect" );
	self endon( "rcbomb_done" );
	self endon( "weapon_object_destroyed" );
	level endon ( "game_ended" );

	og_origin = self.origin;

	for ( ;; )
	{
		wait( 1 );

		ent = get_vehicle_entity();

		if ( !isdefined( ent ) )
		{
			return;
		}

		if ( DistanceSquared( og_origin, ent.origin ) < 16 * 16 )
		{
			wait( 2 );

			if ( !isdefined( ent ) )
			{
				return;
			}

			if ( DistanceSquared( og_origin, ent.origin ) < 16 * 16 )
			{
				self PressAttackButton();
			}
		}

		og_origin = ent.origin;
	}
}

function turret_location( weapon )
{
	enemy = get_closest_enemy( self.origin );

	if ( !isdefined( enemy ) )
	{
		return;
	}

	forward = AnglesToForward( self GetPlayerAngles() );
	forward = VectorNormalize( forward );

	delta = enemy.origin - self.origin;
	delta = VectorNormalize( delta );

	dot = VectorDot( forward, delta );

	if ( dot < 0.707 )
	{
		return;
	}

	node = GetVisibleNode( self.origin, enemy.origin );

	if ( !isdefined( node ) )
	{
		return;
	}

	if ( DistanceSquared( self.origin, node.origin ) < 512 * 512 )
	{
		return;
	}

	delta = node.origin - self.origin;
	delta = VectorNormalize( delta );

	dot = VectorDot( forward, delta );

	if ( dot < 0.707 )
	{
		return;
	}

	self thread weapon_switch_failsafe();
	self SwitchToWeapon( weapon );
	self waittill( "weapon_change_complete" );
	self util::freeze_player_controls( true );

	wait( 1 );
	self util::freeze_player_controls( false );
	use_item( weapon );
	
	if ( isalive(self) )
	{
		self killstreaks::switch_to_last_non_killstreak_weapon();
	}
}

function use_supply_drop( weapon )
{
	if ( weapon.name == "inventory_supplydrop_marker" || weapon.name == "supplydrop_marker" )
	{
		if ( GetTime() - self.spawntime > 5000 )
		{
			return;
		}
	}

	yaw = ( 0, self.angles[1], 0 );
	dir = AnglesToForward( yaw );

	dir = VectorNormalize( dir );
	drop_point = self.origin + VectorScale( dir, 384 );
	//DebugStar( drop_point, 500, ( 1, 0, 0 ) );

	end = drop_point + ( 0, 0, 2048 );
	//DebugStar( end, 500, ( 1, 0, 0 ) );

	if ( !SightTracePassed( drop_point, end, false, undefined ) )
	{
		return;
	}

	if ( !SightTracePassed( self.origin, end, false, undefined ) )
	{
		return;
	}

	// is this point in mid-air?
	end = drop_point - ( 0, 0, 32 );
	//DebugStar( end, 500, ( 1, 0, 0 ) );
	if ( BulletTracePassed( drop_point, end, false, undefined ) )
	{
		return;
	}

	self AddGoal( self.origin, 24, 4, "killstreak" );

	if ( weapon.name == "missile_drone" || weapon.name == "inventory_missile_drone" )
	{
		self LookAt( drop_point + ( 0, 0, 384 ) );
	}
	else
	{
		self LookAt( drop_point );
	}
		
	wait( 0.5 );

	if ( self GetCurrentWeapon() != weapon )
	{
		self thread weapon_switch_failsafe();
		self SwitchToWeapon( weapon );
		self waittill( "weapon_change_complete" );
	}

	use_item( weapon );
	
	if ( isalive(self) )
	{
		self killstreaks::switch_to_last_non_killstreak_weapon();
	}

	self ClearLookAt();
	self CancelGoal( "killstreak" );
}

function use_item( weapon )
{
	self PressAttackButton();
	wait( 0.5 );

	for ( i = 0; i < 10; i++ )
	{
		if ( self GetCurrentWeapon() == weapon || self GetCurrentWeapon() == level.weaponNone )
		{
			self PressAttackButton();
		}
		else
		{
			return;
		}

		wait( 0.5 );
	}
}

function killstreak_location( num, weapon )
{
	enemies = get_enemies();

	if ( !enemies.size )
	{
		return;
	}

	if ( !self SwitchToWeapon( weapon ) )
	{
		return;
	}
	self waittill( "weapon_change" );
	self util::freeze_player_controls( true );

	wait_time = 1;
	while ( !isdefined( self.selectingLocation ) || self.selectingLocation == false )
	{
		{wait(.05);};
		wait_time -= 0.05;

		if ( wait_time <= 0 )
		{
			self util::freeze_player_controls( false );
			if ( isalive(self) )
			{
				self killstreaks::switch_to_last_non_killstreak_weapon();
			}
			return;
		}
	}

	wait( 2 );

	for ( i = 0; i < num; i++ )
	{
		enemies = get_enemies();

		if ( enemies.size )
		{
			enemy = array::random( enemies );
			self notify( "confirm_location", enemy.origin, 0 );
		}

		wait( 0.25 );
	}

	self util::freeze_player_controls( false );
}

function killstreak_dangerous_think( origin, team, attacker )
{
	if ( !level.teamBased )
	{
		return;
	}

	nodes = GetNodesInRadius( origin + ( 0, 0, 384 ), 384, 0 );
	//debug_circle( origin, 384, 10 );

	foreach( node in nodes )
	{
		if ( node IsDangerous( team ) )
		{
			return;
		}
	}

	foreach( node in nodes )
	{
		node SetDangerous( team, true );
	}

	attacker util::wait_endon( 25, "death" );

	foreach( node in nodes )
	{
		node SetDangerous( team, false );
	}
}

function weapon_switch_failsafe()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "weapon_change_complete" );

	wait( 10 );

	//self ClearScriptGoal();
	self notify( "weapon_change_complete" );
}

function dive_to_prone( exit_stance )
{
	self PressDTPButton();

	event = self util::waittill_any_timeout( 0.25, "dtp_start" );

	if ( event == "dtp_start" )
	{
		self waittill( "dtp_end" );
		self SetStance( "prone" );
		wait( 0.35 );
		self SetStance( exit_stance );
	}
}

function gametype_void()
{
}

function navmesh_points_visible( pt1, pt2 )
{
	points = NavPointSightFilter( array( pt1 ), pt2 );
	return ( points.size > 0 );
}

/#

function debug_star( origin, seconds, color )
{
	if ( !isdefined( seconds ) )
	{
		seconds = 1;
	}
	
	if ( !isdefined( color ) )
	{
		color = ( 1, 0, 0 );
	}

	frames = Int( 20 * seconds );
	DebugStar( origin, frames, color );
}

function debug_circle( origin, radius, seconds, color )
{
	if ( !isdefined( seconds ) )
	{
		seconds = 1;
	}

	if ( !isdefined( color ) )
	{
		color = ( 1, 0, 0 );
	}

	frames = Int( 20 * seconds );
	Circle( origin, radius, color, false, true, frames );
}

function bot_debug_box( origin, mins, maxs, yaw, seconds, color )
{
	if ( !IsDefined( yaw ) )
	{
		yaw = 0;
	}
	
	if ( !IsDefined( seconds ) )
	{
		seconds = 1;
	}

	if ( !IsDefined( color ) )
	{
		color = ( 1, 0, 0 );
	}

	frames = Int( 20 * seconds );
	Box( origin, mins, maxs, yaw, color, 1, false, frames );
}

function devgui_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	SetDvar( "devgui_bot", "" );
	SetDvar( "scr_bot_follow", "0" );

	for ( ;; )
	{
		wait( 1 );

		reset = true;
		switch( GetDvarString( "devgui_bot" ) )
		{
		case "crosshair":
			if ( GetDvarint( "scr_bot_follow" ) != 0 )
			{
				iprintln( "Bot following enabled" );
				self thread crosshair_follow();
			}
			else
			{
				iprintln( "Bot following disabled" );
				self notify( "crosshair_follow_off" );
				SetDvar( "bot_AllowMovement", "0" );
				//self ClearScriptGoal();
			}
			break;

		case "laststand":
			SetDvar( "scr_forcelaststand", "1" );
			
			self SetPerk( "specialty_pistoldeath" );
			self SetPerk( "specialty_finalstand" );
			self DoDamage( self.health, self.origin );
			break;
		case "doublejump":
			//self double_jump_traversal();
			break;
		case "":
		default:
			reset = false;
			break;
		}

		if ( reset )
		{
			SetDvar( "devgui_bot", "" );
		}
	}
}

function system_devgui_think()
{
	SetDvar( "devgui_bot", "" );
	SetDvar( "devgui_bot_weapon", "" );

	for ( ;; )
	{
		wait( 1 );

		tokens = strtok(GetDvarString( "devgui_bot" )," ");
		
		if ( tokens.size == 0 )
				continue;
				
		reset = true;
		player = util::getHostPlayer();
		team = player.team;
		
		switch( tokens[0] )
		{
		case "spawn_enemy":
			if ( team == "spectator" )
			{
				team = "axis";
			}
			else
			{
				team = getEnemyTeamWithLowestPlayerCount( player.team );
			}
		case "spawn_friendly":	
			if ( team == "spectator" )
			{
				team = "allies";
			}
			count = 1;
			if ( tokens.size > 1 )
			{
				count = int( tokens[1] );
			}
			for( i = 0; i < count; i++ )
			{
				devgui_bot_spawn( team );
			}
			break;
		
		case "fixed_spawn_enemy":
			team = getEnemyTeamWithLowestPlayerCount( player.team );
		case "fixed_spawn_friendly":	
			count = 1;
			if ( tokens.size > 1 )
			{
				count = int( tokens[1] );
			}
			for( i = 0; i < count; i++ )
			{
				devgui_bot_spawn_fixed( team );
			}		
			break;

			case "loadout":
			case "player_weapon":
			players = GetPlayers();
			foreach( player in players )
			{
				if ( !player util::is_bot() )
				{
					continue;
				}

				host = util::getHostPlayer();
				weapon = host GetCurrentWeapon();

				player weapons::detach_all_weapons();
				player TakeAllWeapons();
				player GiveWeapon( weapon );
				player SwitchToWeapon( weapon );
				player SetSpawnWeapon( weapon );

				player teams::set_player_model( player.team, weapon );
			}
			break;

		case "routes":
			devgui_debug_route();
			break;
		case "":
		default:
			reset = false;
			break;
		}

		if ( reset )
		{
			SetDvar( "devgui_bot", "" );
		}
	}
}

function system_devgui_gadget_think()
{
	SetDvar( "devgui_bot_gadget", "" );

	for ( ;; )
	{
		wait( 1 );

		gadget = GetDvarString( "devgui_bot_gadget" );
		
		if ( gadget != "" )
		{
			bot_turn_on_gadget( GetWeapon(gadget) );
			SetDvar( "devgui_bot_gadget", "" );
		}	
	}
}

function bot_turn_on_gadget( gadget )
{
	players = GetPlayers();
	
	foreach( player in players )
	{
		if ( !player util::is_bot() )
		{
			continue;
		}
		
		host = util::getHostPlayer();
		weapon = host GetCurrentWeapon();
		
		if ( !isdefined( weapon ) || weapon == level.weaponNone || weapon == level.weaponNull )
		{
			weapon = GetWeapon( "smg_standard" );
		}

		player weapons::detach_all_weapons();
		player TakeAllWeapons();
		player GiveWeapon( weapon );
		player SwitchToWeapon( weapon );
		player SetSpawnWeapon( weapon );

		player teams::set_player_model( player.team, weapon );
		
		player GiveWeapon( gadget );
		slot = player GadgetGetSlot( gadget );
		player GadgetPowerSet( slot, 100.0 );
		player BotPressButtonForGadget( gadget );
	}	
}

function crosshair_follow()
{
	self notify( "crosshair_follow_off" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "crosshair_follow_off" );
	
	for ( ;; )
	{
		wait( 1 );
		SetDvar( "bot_AllowMovement", "1" );
		SetDvar( "bot_IgnoreHumans", "1" );
		SetDvar( "bot_ForceStand", "1" );
	
		// Trace to where the player is looking
		player = util::getHostPlayerForBots();
		direction = player GetPlayerAngles();
		direction_vec = AnglesToForward( direction );
		eye = player GetEye();

		scale = 8000;
		direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );

		origin = trace[ "position" ] + ( 0, 0, 0 );

		if ( DistanceSquared( self.origin, origin ) > 128 * 128 )
		{
			//self ClearScriptGoal();
			//self SetScriptGoal( origin, 32 );
		}
	}
}

function debug_patrol( node1, node2 )
{
	self endon( "death" );
	self endon( "debug_patrol" );

	for( ;; )
	{
		self AddGoal( node1, 24, 4, "debug_route" );
		self waittill( "debug_route", result );

		if ( result == "failed" )
		{
			self CancelGoal( "debug_route" );
			wait( 5 );
		}

		self AddGoal( node2, 24, 4, "debug_route" );
		self waittill( "debug_route", result );

		if ( result == "failed" )
		{
			self CancelGoal( "debug_route" );
			wait( 5 );
		}
	}
}

function devgui_debug_route()
{
	iprintln( "Choose points with 'A' or press 'B' to cancel" );
	nodes = dev::dev_get_point_pair();

	if ( !isdefined( nodes ) )
	{
		iprintln( "Route Debug Cancelled" );
		return;
	}

	iprintln( "Sending bots to chosen points" );

	players = GetPlayers();
	foreach( player in players )
	{
		if ( !player util::is_bot() )
		{
			continue;
		}

		player notify( "debug_patrol" );
		player thread debug_patrol( nodes[0], nodes[1] );
	}
}

function devgui_bot_spawn( team )
{
	player = util::getHostPlayer();

	bot = AddTestClient();

	if ( !isdefined( bot ) )
	{
		println( "Could not add test client" );
		return;
	}
			
	bot.pers["isBot"] = true;
	bot thread spawn_think( team );
}

function devgui_bot_spawn_fixed( team )
{
	player = util::getHostPlayer();

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	direction_vec = player.origin - trace["position"];
	direction = VectorToAngles( direction_vec );
	
	bot = AddTestClient();

	if ( !isdefined( bot ) )
	{
		println( "Could not add test client" );
		return;
	}
			
	bot.pers["isBot"] = true;
	bot thread spawn_think( team );

	yaw = direction[1];
	bot thread devgui_bot_spawn_think( trace[ "position" ], yaw );
}

function devgui_bot_spawn_think( origin, yaw )
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );
		self SetOrigin( origin );

		angles = ( 0, yaw, 0 );
		self SetPlayerAngles( angles );
	}
}
#/
