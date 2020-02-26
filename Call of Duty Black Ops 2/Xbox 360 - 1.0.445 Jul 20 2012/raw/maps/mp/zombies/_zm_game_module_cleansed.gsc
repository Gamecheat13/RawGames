#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_turned;

/*
	Cleansed ( Survival )
	Objective: 	Out match the other players on your team
	Map ends:	When only one human player is left standing
	Respawning:	Respawn as a Zombie if you die, Respawn as a human if you kill a Zombified player
*/

//	******************************************************************************************************
//	REGISTER THE CLEANSED MODULE
//	******************************************************************************************************
register_game_module()
{
	level.GAME_MODULE_CLEANSED_INDEX = 8;
	maps\mp\zombies\_zm_game_module::register_game_module( level.GAME_MODULE_CLEANSED_INDEX, "zcleansed", ::onPreInitGameType, ::onPostInitGameType, undefined, ::onSpawnZombie, ::onStartGameType );
}

register_cleansed_match( start_func, end_func,name )
{
	if ( !IsDefined( level._registered_turned_matches ) )
	{
		level._registered_turned_matches = [];
	}

	match = SpawnStruct();
	//race.race_start_trig = race_start_trig;
	match.match_name = name;
	match.match_start_func = start_func;
	match.match_end_func = end_func;
	level._registered_turned_matches[ level._registered_turned_matches.size ] = match;
}

get_registered_turned_match( name )
{
	foreach ( struct in level._registered_turned_matches )
	{
		if ( struct.match_name == name )
		{
			return struct;
		}
	}
}

set_current_turned_match( name )
{
	level._current_turned_match = name;
}

get_current_turned_match()
{
	return level._current_turned_match;
}

init_zombie_weapon()
{
	maps\mp\zombies\_zm_turned::init();

}

//	******************************************************************************************************
//	GAME MODE FUNCTIONS
//	******************************************************************************************************

onPrecacheGameType()
{
	// Survival
	//---------
	if ( GetDvar( "ui_gametype" ) == "zcleansed" )
	{
		PreCacheModel( "zombie_pickup_perk_bottle" );
	}
	// Encounters
	//-----------
	else if ( GetDvar( "ui_gametype" ) == "zturned" )
	{
		PreCacheShellShock( "tabun_gas_mp" );
	}
	precacheshader("faction_cdc");
	precacheshader("faction_cia");

}

onPreInitGameType()
{
	if ( GetDvar( "ui_gametype" ) != "zcleansed" && GetDvar( "ui_gametype" ) != "zturned" )
	{
		return;
	}

	level thread onPrecacheGameType();

	level thread makeFindFleshStructs();
	
	level thread onPlayerConnect();
	
	// Don't Forfeit Match
	//--------------------
	level.gracePeriodFunc = ::waitForHumanSelection;
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		
		player thread onPlayerDisconnect();
	}
}

onPlayerDisconnect()
{
	level endon( "end_game" );
	
	self waittill( "disconnect" );
	
	if ( !is_true( level.inGracePeriod ) )
	{
		checkZombieHumanRatio();
	}
}

makeFindFleshStructs()
{
	structs = getstructarray( "spawn_location", "script_noteworthy" );

	foreach ( struct in structs )
	{
		struct.script_string = "find_flesh";
	}
}

onPostInitGameType()
{
	if ( level.scr_zm_game_module != level.GAME_MODULE_CLEANSED_INDEX )
	{
		return;
	}
	
	level thread init_zombie_weapon();	

	level thread maps\mp\zombies\_zm_game_module_nml::makeFindFleshStructs();
}

onStartGameType( name )
{
	updateGametypeVariables();

	// Disable Doors
	//--------------
	doors = GetEntArray( "zombie_door", "targetname" );
	foreach ( door in doors )
	{
		door SetInvisibleToAll();
	}

	// Disable Windows
	//----------------
	level thread maps\mp\zombies\_zm_blockers::open_all_zbarriers();

	match = get_registered_turned_match( name );
	set_current_turned_match( name );

	//* level thread maps\mp\zombies\_zm_game_module_nml::nml_ramp_up_zombies();

	if ( IsDefined( match ) )
	{
		level thread [[ match.match_start_func ]]();
		level thread [[ match.match_end_func ]]();
	}

	//* level.round_spawn_func = maps\mp\zombies\_zm_game_module_nml::nml_round_manager;

	onSpawnPlayer();

	level notify( "start_fullscreen_fade_out" );

	if ( is_Encounter() )
	{
		IPrintLnBold( "SURVIVE LONGER THAN THE OPPOSING TEAM" );

		players = GET_PLAYERS();
		foreach ( player in players )
		{
			player thread maps\mp\zombies\_zm_game_module::team_icon_intro( player._team_hud[ "team" ] );
		}
	}
	else
	{
		level thread onStartCleansedGameType();
	}

	//* level thread zombieSpawnLogic();

	// Don't Allow Carpenter
	//----------------------
	level.zombie_include_powerups[ "carpenter" ] = false;

	// Disable Chalk
	//--------------
	level.noChalk = true;
	level._supress_survived_screen = 1;

	//* level thread maps\mp\zombies\_zm::round_start();

	if ( level.scr_zm_ui_gametype == "zturned" )
	{
		level thread maps\mp\zombies\_zm_game_module::wait_for_team_death();
	}
}

updateGametypeVariables()
{
	flag_init( "start_supersprint" );
	
	// Disable Fake Deaths
	//--------------------
	level.custom_player_fake_death = ::empty;
	level.custom_player_fake_death_cleanup = ::empty;

	level.nml_zombie_spawners = level.zombie_spawners;
	
	level.custom_max_zombies = 6;
	level.custom_zombie_health = 200;

	level.nml_dogs_enabled = false;

	level.timerCountDown = true;
	level.round_timer = 3; // Minutes
	level.round_timer_pulse = 10; // Every x Seconds

	level.initial_spawn = true;

	level.NML_REACTION_INTERVAL		  = 2000;	  // time interval between reactions
	level.NML_MIN_REACTION_DIST_SQ    = 32*32;	  // minimum distance from the player to be able to react
	level.NML_MAX_REACTION_DIST_SQ	  = 2400*2400;// maximum distance from the player to be able to react

	level.min_humans = 1;

	level.no_end_game_check = true;

	level.zombie_health = level.zombie_vars[ "zombie_health_start" ];
	level._get_game_module_players = undefined;
	level.powerup_drop_count = 0;
	//* level.custom_player_fake_death = ::playerFakeDeath;
	level.is_zombie_level=true;
	level.player_becomes_zombie		= ::onZombifyPlayer;
	set_zombie_var( "zombify_player", 					true );

	// Survival
	//---------
	if ( GetDvar( "ui_gametype" ) == "zcleansed" )
	{
		SetDvar( "player_lastStandBleedoutTime", "0.05" );
	}
	// Encounters
	//-----------
	else
	{
		SetDvar( "player_lastStandBleedoutTime", "15" );
	}

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
}

clearGametypeVariables()
{
	level.zombie_health = level.zombie_vars[ "zombie_health_start" ];
	level._get_game_module_players = undefined;
	level.powerup_drop_count = 0;
	level.is_zombie_level=false;
	level.player_becomes_zombie		= maps\mp\zombies\_zm::zombify_player;
	set_zombie_var( "zombify_player", 					false );
	SetDvar( "player_lastStandBleedoutTime", "45" );

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
}

onZombifyPlayer()
{
	self.zombification_time = GetTime() / 1000;
	
	// Turn Zombie Who Killed Us To Human, If Applicable
	//--------------------------------------------------
	if ( IsDefined( self.last_player_attacker ) && IsPlayer( self.last_player_attacker ) && is_true( self.last_player_attacker.is_zombie ) )
	{
		checkZombieHumanRatio( self.last_player_attacker );

		self.player_was_turned_by = self.last_player_attacker; // in case we want to detect revenge
	}
	// Already A Zombie, Just Respawning
	//----------------------------------
	else if ( is_true( self.is_zombie ) )
	{
	}
	// Get Earliest Zombie Player To Turn Human If Killed By AI Zombie
	//----------------------------------------------------------------
	else
	{
		checkZombieHumanRatio( undefined, self );
	}
	
	self.last_player_attacker = undefined;

	self  maps\mp\zombies\_zm_laststand::laststand_enable_player_weapons();

	self.ignoreme = true;
	//	self.is_zombie = true;

	//	self.team = "axis";
	self notify( "zombified" );

	if ( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger Delete();
	}

	self.revivetrigger = undefined;

	//	self setMoveSpeedScale( 0.3 );

	self reviveplayer();

	self maps\mp\zombies\_zm_turned::turn_to_zombie();
}

playerFakeDeath( vDir )
{
	if ( !is_true( self.is_zombie ) )
	{
		self endon( "disconnect" );
		level endon( "game_module_ended" );
		
		level notify ("fake_death");
		self notify ("fake_death");
		
		self EnableInvulnerability();
		self TakeAllWeapons();
		self FreezeControls( true );
		
		self.ignoreme = true;
	
		origin = self.origin;
		xyspeed = ( 0, 0, 0 );
		angles = self getplayerangles();
		angles = ( angles[0], angles[1], angles[2] + RandomFloatRange( -5, 5 ) );  
	
		if (isDefined(vDir) && Length(vDir) > 0)
		{
			XYSpeedMag = 40 + randomint(12) + randomint(12);
			xyspeed = XYSpeedMag * vectornormalize(( vDir[ 0 ], vDir[ 1 ], 0 ) );
		}
	
		linker = spawn( "script_origin", ( 0, 0, 0 ) );
		linker.origin = origin;
		linker.angles = angles;
		self._fall_down_anchor = linker;
		self playerlinkto( linker );
		self playsoundtoplayer( "zmb_player_death_fall", self );
	
		origin = PlayerPhysicsTrace( origin, origin + xyspeed );
		origin = origin + (0,0,-52); 
	
		lerptime = 0.5;
	
		linker moveto( origin, lerptime, lerptime );
		linker rotateto( angles, lerptime, lerptime );
		self FreezeControls( true );
		linker waittill( "movedone" );
	
	
		self GiveWeapon("death_throe_zm");
		self SwitchToWeapon("death_throe_zm");
	
		bounce = randomint(4) + 8; 
		origin = origin + (0,0,bounce) - ( xyspeed * 0.1 );
		lerptime = bounce / 50.0;
	
		linker moveto( origin, lerptime, 0, lerptime );
		linker waittill( "movedone" );
	
		origin = origin + (0,0,-bounce) + ( xyspeed * 0.1 );
		lerptime = lerptime / 2.0;
	
		linker moveto( origin, lerptime, lerptime );
		linker waittill( "movedone" );
	
		linker moveto( origin, 5, 0 );
		wait 5;
		linker delete();
		
		self.ignoreme = false;
		
		self TakeWeapon("death_throe_zm");	
		self DisableInvulnerability();
		self FreezeControls( false );
	}
}


onSpawnPlayer()
{

	players = GET_PLAYERS();
	foreach ( index, player in players )
	{
		player.ignoreme = false;
		player.score = 0;
		player TakeAllWeapons();
		player GiveWeapon( "knife_zm" );
		player give_start_weapon( true );

		player.prevteam = player.team;
		player.no_revive_trigger = true;

		player.human_score = 0;

		player thread playerHumanCounter();
	}

	// Survival
	//---------
	if( GetDvar( "ui_gametype" ) == "zcleansed" )
	{
		foreach ( player in players )
		{
			player.is_zombie = false;
		}
	}
	// Encounters
	//-----------
	else
	{
	}
}

onSpawnZombie()
{
	//	self.maxhealth = maps\mp\zombies\_zm_race_utility::get_race_zombie_health( self._starting_round_number );
	//	self.health = maps\mp\zombies\_zm_race_utility::get_race_zombie_health( self._starting_round_number );
	//	self maps\mp\zombies\_zm_race_utility::set_race_zombie_run_cycle( self._starting_round_number );
}

onStartCleansedGameType()
{
	level endon( "turned_end" );

	// Kicks Off The Cleansed Logic
	//-----------------------------
	
	// Assign Players To Roles
	//------------------------
	players = GET_PLAYERS();
	foreach ( player in players )
	{
		player thread turn_to_zombie();
	}
	
	wait ( 2 );
	
	notifyData = SpawnStruct();
	notifyData.notifyText = "ACCRUE THE MOST TIME AS A HUMAN TO WIN";
	notifyData.duration = 8;
	
	players = GET_PLAYERS();
	foreach ( player in players )
	{
		player clearCenterPopups();
		player thread maps\mp\gametypes\_hud_message::showNotifyMessage( notifyData, notifyData.duration );
	}
	
	waitForPowerUpPickUp();
		
	wait ( 1.2 );
	
	flag_clear( "pregame" );

	round_timer_milliseconds = level.round_timer * ( 60 * 1000 ); // Convert Minutes To MilliSeconds
	round_timer_end = GetTime() + round_timer_milliseconds;
	round_second_keeper = 0;

	while ( GetTime() < round_timer_end )
	{
		wait ( 1 );
		
		round_second_keeper++;
		
		if ( round_second_keeper % level.round_timer_pulse == 0 )
		{
			if ( IsDefined( level.game_module_timer ) )
			{
				level.game_module_timer thread maps\mp\gametypes\_hud::fontPulse( self );
			}
			
			round_second_keeper = 0;
		}
	}

	endGameScreen();
	
	level notify( "end_game" );
}

waitForHumanSelection()
{
	level waittill( "initial_human_selected" );	
}

waitForPowerUpPickUp()
{
	struct = random( level._turned_powerup_spawnpoints );

	pickupModelOrigin = Spawn( "script_model", struct.origin + ( 0, 0, 40 ) );
	pickupModelOrigin.angles = ( 0, 0, 0 );
	pickupModelOrigin SetModel( "tag_origin" );

	pickupModel = Spawn( "script_model", struct.origin + ( 0, 0, 40 ) );
	pickupModel.angles = ( 0, 0, 0 );
	pickupModel SetModel( "zombie_pickup_perk_bottle" );
	pickupModel LinkTo( pickupModelOrigin );

	pickupModelOrigin.icon = pickupModel;

	pickupModelOrigin thread waitForPowerUpPickUpWobble();
	pickupModelOrigin waitForPowerUpPickUpGrab();
}

waitForPowerUpPickUpWobble()
{
	self endon ( "powerupPickUpGrabbed" );
	
	wait ( 1 );

	if ( IsDefined( self ) )
	{
		wait_network_frame();

		PlayFXOnTag ( level._effect[ "powerup_on" ], self, "tag_origin" );
		self PlaySound( "zmb_tombstone_spawn" );
		self PlayLoopSound( "zmb_tombstone_looper" );
	}

	while ( IsDefined( self ) )
	{
		self RotateYaw( 360, 3 );

		wait( 3 - 0.1 );
	}
}

waitForPowerUpPickUpGrab()
{
	wait( 1 );

	while ( IsDefined( self ) )
	{
		players = get_players();

		for ( i = 0; i < players.size; i++ )
		{
			dist = DistanceSquared( players[ i ].origin, self.origin );

			if ( dist < ( 64 * 64 ) )
			{
				PlayFX( level._effect[ "powerup_grabbed" ], self.origin );
				PlayFX( level._effect[ "powerup_grabbed_wave" ], self.origin );

				players[ i ] turn_to_human();

				wait( 0.1 );

				playsoundatposition( "zmb_tombstone_grab", self.origin );
				self StopLoopSound();

				self.icon UnLink();
				self.icon Delete();
				self Delete();
				self notify( "powerupPickUpGrabbed" );

				level notify( "initial_human_selected" );
				
				return;
			}
		}

		wait_network_frame();
	}
}

endGameScreen()
{
	// TEMP ANNOUNCE WINNER
	players = GET_PLAYERS();

	winner = players[ 0 ];

	foreach ( player in players )
	{
		player setClientUIVisibilityFlag( "hud_visible", 0 );

		if ( IsDefined( winner ) && player.human_score > winner.human_score )
		{
			winner = player;
		}
	}
	
	offSet = -40;
	
	level thread maps\mp\zombies\_zm_game_module::module_hud_full_screen_overlay();
	
	foreach ( index, player in players )
	{
		player FreezeControls( true );
		
		matchStartText = createServerFontString( "objective", 1.5 );
		matchStartText setPoint( "CENTER", "CENTER", 0, offSet );
		if ( player == winner )
		{
			matchStartText SetText( player.name + " ^2WINNER w/ " + player.human_score + " seconds as a Human" );
		}
		else
		{
			matchStartText SetText( player.name + " ^1LOSER w/ " + player.human_score + " seconds as a Human" );
		}
		matchStartText.sort = 1001;
		matchStartText.foreground = true;
		
		offSet += 20;
	}
	
	wait ( 8 );
}

checkZombieHumanRatio( playerToMove, playerToIgnore )
{
	zombieCount = 0;
	humanCount = 0;
	zombieExist = false;
	humanExist = false;
	earliestZombie = undefined;
	earliestZombieTime = 99999999;
	
	if ( IsDefined( playerToMove ) )
	{
		someoneBecomingHuman = false;
		
		players = GET_PLAYERS();
		foreach ( player in players )
		{
			if ( is_true( player.is_in_process_of_humanify ) )
			{
				someoneBecomingHuman = true;
			}
		}
		
		// TODO -- If We Want A Player To Switch Sides Intentionally, Then They Should Swap With Whoever Is A Human Already
		if ( !is_true( someoneBecomingHuman ) )
		{
			playerToMove turn_to_human();
		}
		
		return;
	}

	players = GET_PLAYERS();
	foreach ( player in players )
	{
		if ( IsDefined( playerToIgnore ) && playerToIgnore == player )
		{
			continue;
		}
		
		if ( !is_true( player.is_zombie ) && !is_true( player.is_in_process_of_zombify ) )
		{
			humanCount++;
			humanExist = true;
		}
		else
		{
			zombieCount++;
			zombieExist = true;
			
			if ( IsDefined( player.zombification_time ) && player.zombification_time < earliestZombieTime )
			{			
				earliestZombie = player;
				earliestZombieTime = player.zombification_time;
			}
		}
	}

	if ( !zombieExist || humanCount > 1 )
	{
		players = GET_PLAYERS( "allies" );
		
		if ( IsDefined( players ) && players.size > 0 )
		{
			random( players ) turn_to_zombie();
		}
	}
	
	if ( !humanExist )
	{
		players = GET_PLAYERS( "axis" );
		
		if ( IsDefined( players ) && players.size > 0 )
		{
			random( players ) turn_to_human();
		}
	}
}

playerHumanCounter()
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );

	myCounter = self createFontString( "objective", 2 );
	myCounter maps\mp\gametypes\_hud::fontPulseInit();
	myCounter.y = 4;
	myCounter.label = ( &"ZOMBIE_SECONDS" );
	myCounter SetValue( 0 );

	self.myCounter = myCounter;

	while ( true )
	{
		// Turns To A Zombie
		//------------------
		self waittill( "zombify" );
		
		self.myCounter.color = ( 1, 0, 0 );
		
		// Turns To A Human
		//-----------------
		self waittill( "humanify" );
		
		self.myCounter.color = ( 0, 1, 0 );
		self.myCounter thread maps\mp\gametypes\_hud::fontPulse( self );
		
		self thread playerHumanCounterScoring();
	}
}

playerHumanCounterScoring()
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );
	self endon( "zombify" );
	
	self thread playerHumanCounterScoringUpdate();
	
	while ( true )
	{
		startTime = GetTime() / 1000;
		
		wait ( 0.05 );
		
		self.human_score += ( ( GetTime() / 1000 ) - startTime );
	}
}

playerHumanCounterScoringUpdate()
{
	self endon( "_zombie_game_over" );
	self endon( "disconnect" );
	self endon( "zombify" );
	
	while ( true )
	{
		self.myCounter SetValue( self.human_score );
		
		wait ( 0.1 );
	}	
}