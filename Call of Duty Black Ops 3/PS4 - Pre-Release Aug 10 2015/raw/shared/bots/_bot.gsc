#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                               	               	               	                	                                                               

#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_traversals;

#namespace bot;

function init_shared()
{
/#
	level thread system_devgui_think();
	level thread system_init();
#/
}

function system_init()
{
	level endon( "game_ended" );

	for ( ;; )
	{
		level waittill( "connected", player );

		if ( !player IsTestClient() )
		{
			continue;
		}

		player thread bot_connect();
	}
}

function bot_connect()
{
	self endon( "disconnect" );

	self init();

	for ( ;; )
	{
		self waittill( "spawned_player" );
/#
	self thread devgui_think();
#/
	}
}

/#

function get_host_player()
{
	players = GetPlayers();

	foreach( player in players )
	{
		if ( player IsHost() )
		{
			return player;
		}
	}

	return undefined;
}

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

function add_bots( count )
{
	for ( i = 0; i < count; i++ )
	{
		add_bot();
	}
	
}

function add_bot_crosshair()	
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
	
	yaw = direction[1];
	bot = add_bot();
	if ( isdefined( bot ) )
	{
		bot SetOrigin( trace[ "position" ] );
		bot.angles = ( bot.angles[0], yaw, bot.angles[2] );
	}
}

function add_bot()
{
	player = get_host_player();
	team = player.team;

	bot = AddTestClient();

	if ( !IsDefined( bot ) )
	{
		return;
	}

	bot.pers[ "isBot" ] = true;
	bot.pers[ "team" ] = team;
	bot.sessionteam = team;

	wait 0.25;
	bot notify( "menuresponse", "ChooseClass_InGame", "class_assault" );
	wait 0.25;

	bot notify( "joined_team" );
	bot callback::callback( #"on_joined_team" );
	bot.bcVoiceNumber = bot.pers["bcVoiceNumber"];
	
	return bot;
}

function remove_bots( count )
{
	players = GetPlayers();

	foreach( player in players )
	{
		if ( player util::is_bot() )
		{
			player BotLeaveGame();
			count--;
			if ( count == 0 )
			{
				break;
			}
		}
	}
}

function remove_all_bots()
{
	players = GetPlayers();

	foreach( player in players )
	{
		if ( player util::is_bot() )
		{
			player BotLeaveGame();
		}
	}
}

function devgui_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	SetDvar( "devgui_bot", "" );

	for ( ;; )
	{
		wait( 1 );

		reset = true;
		switch( GetDvarString( "devgui_bot" ) )
		{
		case "laststand":
			self DoDamage( self.health, self.origin );
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

	while(1)
	{
		wait( 1 );

		cmd = GetDvarString( "devgui_bot" );
		
		if ( cmd == "" )
		{
			continue;
		}
		
		handled = true;
		
		switch( cmd )
		{
		case "add":
			add_bot();
		break;
		
		case "add_3":
			add_bots( 3 );
		break;

		case "add_crosshair":
			add_bot_crosshair();
		break;
		
		case "remove":
			remove_bots( 1 );
		break;
		
		case "remove_all":
			remove_bots( 0 );
		break;
		default:
			handled = false;
			break;			
		}
		
		if ( handled )
		{
			SetDvar( "devgui_bot", "" );
		}
	}
}
  	
function init()
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
	//SetDvar( "bot_YawSpeed",		"0.7" );

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

	self.bot.think_interval = 0.2;
	self.bot.fov = -0.1736;

	// combat
	self.bot.threat.entity				= undefined;
	self.bot.threat.position			= ( 0, 0, 0 );
	self.bot.threat.time_first_sight	= 0;
	self.bot.threat.time_recent_sight	= 0;
	self.bot.threat.time_aim_interval	= 0;
	self.bot.threat.time_aim_correct	= 0;
	self.bot.threat.update_riotshield	= 0;
}

function debug_patrol( node1, node2 )
{
	self endon( "death" );
	self endon( "debug_patrol" );

	for( ;; )
	{
		if ( self.sessionstate != "playing" )
		{
			wait( 1 );
			continue;
		}

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

function get_difficulty()
{
	return "hard";
}

function get_closest_enemy( origin, on_radar )
{
	team = getOtherTeam( self.team );

	enemies = GetAITeamArray( team );

	if ( enemies.size )
	{
		enemies = ArraySort( enemies, origin );
		return enemies[0];
	}

	return undefined;
}

#/
	
//TODO T7
// this function is depricated 
function getOtherTeam( team )
{
	// TODO MTEAM - Need to fix this.
	if ( team == "allies" )
		return "axis";
	else if ( team == "axis" )
		return "allies";
	else // all other teams
		return "allies";
		
	assertMsg( "getOtherTeam: invalid team " + team );
}

function is_bot_ranked_match()
{
	bot_enemies = GetDvarInt( "bot_enemies" );
	isDedicatedBotSoak = GetDvarInt( "sv_botsoak" );

	return ( level.rankedMatch && bot_enemies && 0 == isDedicatedBotSoak );
}
