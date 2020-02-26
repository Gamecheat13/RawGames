#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

/*
	No Man's Land ( Survival )
	Objective:	Survive in endless waves of multiple enemy types
	Map ends: When all players die
	Respawning:	Players remain dead for the game mode
*/

//	******************************************************************************************************
//	REGISTER THE NO MAN'S LAND MODULE
//	******************************************************************************************************

register_game_module()
{
	level.GAME_MODULE_NML_INDEX = 5;
	maps\mp\zombies\_zm_game_module::register_game_module( level.GAME_MODULE_NML_INDEX, "znml", ::onPreInitGameType, ::onPostInitGameType, undefined, ::onSpawnZombie, ::onStartGameType );
}

register_nml_match( start_func, end_func, name, nml_spawn_func, location )
{
	if ( !IsDefined( level._registered_nml_matches ) )
	{
		level._registered_nml_matches = [];
	}

	match = SpawnStruct();
	match.match_name = name;
	match.match_start_func = start_func;
	match.match_end_func = end_func;
	match.match_spawn_func = nml_spawn_func;
	match.match_location = location;
	match.mode_name = "znml";
	level._registered_nml_matches[ level._registered_nml_matches.size ] = match;
}

get_registered_nml_match( name )
{
	foreach ( struct in level._registered_nml_matches )
	{
		if ( struct.match_name == name )
		{
			return struct;
		}
	}
}

set_current_nml_match( name )
{
	level._current_nml_match = name;
}

get_current_nml_match()
{
	return level._current_nml_match;
}

//	******************************************************************************************************
//	GAME MODE FUNCTIONS
//	******************************************************************************************************

onPrecacheGameType()
{
	// Survival
	//---------
	if( GetDvar( "ui_gametype" ) == "znml" )
	{
	}
	// Encounters
	//-----------
	else if ( GetDvar( "ui_gametype" ) == "zpitted" )
	{
	}
}

onPreInitGameType()
{
	if(getdvar("ui_gametype") != "znml" && getdvar("ui_gametype") != "zpitted")
	{
		return;
	}

	flag_init_undef( "between_rounds" );

	level thread onPrecacheGameType();

	//* level thread onPlayerConnect();

	OnPlayerConnect_Callback(::onPlayerConnect);
	
	// Survival
	//---------
	if( GetDvar( "ui_gametype" ) == "znml" )
	{
	}
	// Encounters
	//-----------
	else
	{
	}
	
	level thread makeFindFleshStructs();
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
	if ( level.scr_zm_game_module != level.GAME_MODULE_NML_INDEX )
	{
		return;
	}
	
	game_mode_objects = getstructarray("game_mode_object","targetname");
	for(i=0;i<game_mode_objects.size;i++)
	{
		if(isDefined(game_mode_objects[i].script_parameters))
		{
				
			precachemodel(game_mode_objects[i].script_parameters);
		}
	}	
	
}

onStartGameType( name )
{
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

	updateGametypeVariables();

	//maps\mp\zombies\_zm_weapons::init_weapon_upgrade();

	match = get_registered_nml_match( name );
	set_current_nml_match( name );

	level thread nml_ramp_up_zombies();

	level thread [[ match.match_start_func ]]();
	level thread [[ match.match_end_func ]]();


	level.round_spawn_func = ::nml_round_manager;

	onSpawnPlayer();
	onJoinedTeam();
	
	level notify("start_fullscreen_fade_out");

/*	if ( !level.objectiveBased )
	{
		if ( is_Encounter() )
		{
			IPrintLnBold( "SURVIVE LONGER THAN YOUR YOUR OPPONENTS" );
		}
		else
		{
			IPrintLnBold( "SURVIVE AS LONG AS YOU CAN" );
		}
	}
	*/
	flag_clear( "zombie_drop_powerups" );
	
	//disable chalk
	level.noChalk = true;
	level._supress_survived_screen = 1;
	level.nml_dog_health = 100;

	level thread nml_dogs_init();
	level thread maps\mp\zombies\_zm::round_start();
}



display_time_survived()
{
	players = GET_PLAYERS();
	level.nml_best_time = GetTime() - level.nml_start_time;

	survived = [];
	for( i = 0; i < players.size; i++ )
	{
		survived[i] = NewClientHudElem( players[i] );
		survived[i].alignX = "center";
		survived[i].alignY = "middle";
		survived[i].horzAlign = "center";
		survived[i].vertAlign = "middle";
		survived[i].y -= 100;
		survived[i].foreground = true;
		survived[i].fontScale = 2;
		survived[i].alpha = 0;
		survived[i].color = ( 1.0, 1.0, 1.0 );
		if ( players[i] isSplitScreen() )
		{
			survived[i].y += 40;
		}
		
		nomanslandtime = level.nml_best_time; 
		player_survival_time = int( nomanslandtime/1000 ); 
		player_survival_time_in_mins = maps\mp\zombies\_zm::to_mins( player_survival_time );		
		survived[i] SetText( &"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins );
		survived[i] FadeOverTime( 1 );
		survived[i].alpha = 1;
	}
	
	wait( 3.0 );
	
	for( i = 0; i < players.size; i++ )
	{
		survived[i] FadeOverTime( 1 );
		survived[i].alpha = 0;
	}
}


updateGametypeVariables()
{
	level.objectiveBased = onGetObjectiveBased();

	level.nml_max_zombies = 24;
	level.nml_zombie_spawners = level.zombie_spawners;

	level.objectivePlantTime = 10;

	// Survival
	//---------
	if( GetDvar( "ui_gametype" ) == "znml" )
	{
	}
	// Encounters
	//-----------
	else
	{
	}
	
	flag_init_undef( "start_supersprint" );

	level.initial_spawn = true;

	level.last_perk_index = -1;

	level.NML_REACTION_INTERVAL		  = 2000;	  // time interval between reactions
	level.NML_MIN_REACTION_DIST_SQ    = 32*32;	  // minimum distance from the player to be able to react
	level.NML_MAX_REACTION_DIST_SQ	  = 2400*2400;// maximum distance from the player to be able to react

	level.zombie_health = level.zombie_vars[ "zombie_health_start" ];
	level._zombie_spawning = false;
	//level.friendlyfire = 0;
	level._nml_on_team = undefined;
	level._nml_zombie_spawn_timer = 3;
	level._nml_zombie_spawn_health = 1;
	level._get_game_module_players = ::get_game_module_players;
	level.powerup_drop_count = 0;

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
}

onPlayerConnect()
{
}

onPlayerDisconnect()
{
	self waittill( "disconnect" );
}

/*onSpawnPlayer()
{

	players = GET_PLAYERS();
	foreach ( index, player in players )
	{
		player.ignoreme = false;
		player.score = 500;
		player TakeAllWeapons();
		player GiveWeapon( "knife_zm" );
		player give_start_weapon( true );

		player.prevteam = player.team;
		player thread maps\mp\zombies\_zm_game_module::team_icon_intro(player._team_hud["team"]);
	}
}*/


onSpawnPlayer( predictedSpawn )
{
	getSpawnPoints();

	players = GET_PLAYERS();
	foreach ( index, player in players )
	{
		// Give Grenades
		//--------------
		lethal_grenade = player get_player_lethal_grenade();
		if( !player HasWeapon( lethal_grenade ) )
		{
			player GiveWeapon( lethal_grenade );
			player SetWeaponAmmoClip( lethal_grenade, 0 );
		}

		if ( player GetFractionMaxAmmo( lethal_grenade ) < .25 )
		{
			player SetWeaponAmmoClip( lethal_grenade, 2 );
		}
		else if ( player GetFractionMaxAmmo( lethal_grenade ) < .5 )
		{
			player SetWeaponAmmoClip( lethal_grenade, 3 );
		}
		else
		{
			player SetWeaponAmmoClip( lethal_grenade, 4 );
		}
	}

	// Survival
	//---------
	if( GetDvar( "ui_gametype" ) == "znml" )
	{
	}
	// Encounters
	//-----------
	else
	{
		foreach ( player in players )
		{
			player thread onDownEvent();
		}
	}
}

getSpawnPoints()
{
	if ( level.objectiveBased )
	{
		return;
	}

	//t6.5todo Grab From Radiant
}

onJoinedTeam()
{
	if ( !is_Encounter() )
	{
		return;
	}
}

onSpawnZombie()
{
	//* self.exclude_distance_cleanup_adding_to_total = true;
}

onGetObjectiveBased()
{
	if ( GetDvar( "ui_gametype" ) == "zsurvival" ) //t6.5todo "zclassic"
	{
		return true;
	}

	return false;
}

onCleanUp()
{
	//TODO: Temp, This Is Getting Cleanup Too Fast In Classic Transit
	if ( false )
	{
		level.teamBased = undefined;
		level.objectiveBased = undefined;
	}

	level.objectivePlantTime = undefined;

	level._nml_team_1_spawn_points = undefined;
	level._nml_team_2_spawn_points = undefined;

	level.nmlObjectiveZones = undefined;

	level.nmlObjectivePickUps = undefined;
}

onDownEvent()
{
	level endon( "end_game" );

	while( true )
	{
		self waittill( "player_downed" );

		playersOnTeamAlive = 0;

		players = GET_PLAYERS();

		foreach ( player in players )
		{
			if ( player.sessionteam == self.sessionteam )
			{
				if ( IsAlive( player ) && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
				{
					playersOnTeamAlive++;
				}
			}
		}

		if ( playersOnTeamAlive == 0 )
		{
			thread onDeadEvent( self.sessionteam );

			break;
		}
	}
}

onEndGame()
{
	level thread display_time_survived();
}

onDeadEvent( team )
{
	level thread display_time_survived();

	
	if ( level.objectiveBased )
	{
		return;
	}

	level notify( "team_is_dead" );

	winning_team = undefined;

	// CDC DIED
	//---------
	if ( team != "allies" )
	{
		winning_team = "B";
	}
	// CIA DIED
	//---------
	else
	{
		winning_team = "A";
	}

	level notify( "game_module_ended", winning_team );

	wait( 5 );
}

get_players_on_nml_team( team )
{
	players = GET_PLAYERS();
	players_on_team = [];

	foreach ( player in players )
	{
		if ( !IsDefined( player._nml_team ) || player._nml_team != team )
		{
			continue;
		}

		players_on_team[ players_on_team.size ] = player;
	}

	return players_on_team;
}

get_game_module_players( player )
{
	return get_players_on_nml_team( player._nml_team );
}



nml_round_never_ends()
{
	wait( 2 );
	
	level endon( "restart_round" );

	while( 1 ) //flag("enter_nml") )
	{
		zombies = GetAiSpeciesArray( "axis", "all" );
		if( zombies.size >= 2 )
		{
			// This ensures the round will never end
			level.zombie_total = 100;
			return;
		}
		wait( 1 );
	}
}


nml_side_stepping_zombies()
{
	level.mp_side_step = false;
	level waittill( "nml_attack_wave" );
	level.mp_side_step = true;
}

nml_ramp_up_zombies()
{
	self endon( "stop_ramp" );

	wait ( 30 ); //* level waittill( "start_nml_ramp" );

	// start at round level entered no mans land
	level.nml_timer = 1;

	while( true )
	{
		level thread attack_wave_screen_shake();
		
		//Check for health bump.

		level.nml_timer++;

		// DCS: ramping up zombies, play round change sound ( # 88706 )
		thread play_sound_2d( "evt_nomans_warning" );

		zombies = GetAISpeciesArray( "axis", "zombie" );
		z = 0;
		while ( isdefined(zombies) && zombies.size>0 && z<zombies.size )
		{
			zombie = zombies[z];
			//remove zombies from this array that have already taken damage or had thier head gibbed
			if ( ( zombie.health != level.zombie_health ) || is_true( zombie.gibbed ) || is_true( zombie.head_gibbed ) )
			{
				ArrayRemoveValue( zombies, zombie );
				z = 0;
			}
			else
			{
				z++;
			}
		}

		maps\mp\zombies\_zm::ai_calculate_health( level.nml_timer );

		// all zombies full health ramp up.
		foreach ( zombie in zombies )
		{
			if ( is_true( zombie.gibbed ) || is_true( zombie.head_gibbed ) )
			{
				continue;
			}
			
			if ( IsDefined( level.custom_zombie_health ) )
			{
				level.zombie_health = level.custom_zombie_health;
			}
			else
			{
				zombie.health = level.zombie_health;
			}

			if ( is_true( level.mp_side_step ) )
			{
				zombie.shouldSideStepFunc = ::nml_shouldSideStep;
				zombie.sideStepAnims = [];

				//t6todo			zombie.sideStepAnims[ "step_left" ]	= array( %ai_zombie_MP_sidestep_left_a, %ai_zombie_MP_sidestep_left_b );
				//t6todo			zombie.sideStepAnims[ "step_right" ]	= array( %ai_zombie_MP_sidestep_right_a, %ai_zombie_MP_sidestep_right_b );
			}
		}

		IPrintLn( "RAMP UP: " + level.nml_timer + " - " + level.zombie_health );

		if ( level.nml_timer == 6 )
		{
			flag_set( "start_supersprint" );
		}

		wait( 20.0 );
	}
}

nml_shouldSideStep()
{
	if ( self nml_canSideStep() )
	{
		return "step";
	}

	return "none";
}

nml_canSideStep()
{
	if ( GetTime() - self.a.lastSideStepTime < level.NML_REACTION_INTERVAL )
	{
		return false;
	}

	if ( !IsDefined( self.enemy ) )
	{
		return false;
	}

	if ( self.a.pose != "stand" )
	{
		return false;
	}

	distSqFromEnemy = DistanceSquared( self.origin, self.enemy.origin );

	// don't do it too close to the enemy
	if ( distSqFromEnemy < level.NML_MIN_REACTION_DIST_SQ )
	{
		return false;
	}

	// don't do it too far from the enemy
	if ( distSqFromEnemy > level.NML_MAX_REACTION_DIST_SQ )
	{
		return false;
	}

	// don't do it if not path or too close to destination
	if ( !IsDefined( self.pathgoalpos ) || DistanceSquared( self.origin, self.pathgoalpos ) < level.NML_MIN_REACTION_DIST_SQ )
	{
		return false;
	}

	// make sure the AI's running straight
	if ( abs( self GetMotionAngle() ) > 15 )
	{
		return false;
	}

	return true;
}

//	******************************************************************************************************
//	UTILITY
//	******************************************************************************************************

flag_init_undef( flag )
{
	if ( !IsDefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
}


//****************************//


nml_dogs_init()
{
	level.nml_dogs_enabled = false;
	//wait(5);
	//level.nml_dogs_enabled = true;
}

//*****************************************************************************
//*****************************************************************************
nml_round_manager()
{
	level endon("restart_round");

	// *** WHAT IS THIS? *** 
	level.dog_targets = GET_PLAYERS();
	for( i=0; i<level.dog_targets.size; i++ )
	{
		level.dog_targets[i].hunted_by = 0;
	}
	
	level.nml_start_time = GetTime();
	
	// Time when dog spawns start in NML
	dog_round_start_time = 100;
	dog_can_spawn_time = -1000*10;
	dog_difficulty_min_time = 3000;
	dog_difficulty_max_time = 9500;
	
	// Attack Waves setup
	wave_1st_attack_time = (1000 * 25);//(1000 * 40);
	prepare_attack_time = (1000 * 2.1);
	wave_attack_time = (1000 * 35);		// 40
	cooldown_time = (1000 * 16);		// 25
	next_attack_time = (1000 * 26);		// 32

	max_zombies = 20;
	
	if ( IsDefined( level.custom_max_zombies ) )
	{
		max_zombies = level.custom_max_zombies;
	}
	
	next_round_time = level.nml_start_time + wave_1st_attack_time;
	mode = "normal_spawning";
	
	area = 1;
	
	// Once some AI appear, make sure the round never ends
	level thread nml_round_never_ends();


	while( 1 )
	{
		current_time = GetTime();
		
		wait_override = 0.0;


		/**************************************************************/
		/* There is a limit of 24 AI entities, wait to hit this limit */
		/**************************************************************/

		zombies = GetAiSpeciesArray( "axis", "all" );
		
		while( zombies.size >= max_zombies )
		{
			zombies = GetAiSpeciesArray( "axis", "all" );
			wait( 0.5 );
		}


		/***************************/
		/* Update the Spawner Mode */
		/***************************/


		switch( mode )
		{
			// Default Ambient Zombies
			case "normal_spawning":
				
				if(level.initial_spawn == true)
				{
					spawn_a_zombie( 10, "nml_zone_spawners", 0.01 ,true);
				}
				else
				{	
					ai = spawn_a_zombie( max_zombies, "nml_zone_spawners", 0.01 ,true);
					if( isdefined (ai) )
					{
						move_speed = "sprint";

						if ( flag( "start_supersprint" ) )
						{
							move_speed  = "super_sprint";
						}

						ai set_zombie_run_cycle( move_speed );
						if( IsDefined( ai.pre_black_hole_bomb_run_combatanim ) )
						{
							ai.pre_black_hole_bomb_run_combatanim = move_speed;
						}
					}
				}
				
				// Check for Spawner Wave to Start
				if( current_time > next_round_time )
				{
					next_round_time = current_time + prepare_attack_time;
					mode = "preparing_spawn_wave";
					level thread screen_shake_manager( next_round_time );
				}
			break;


			// Shake screen, start existing zombies running, then start a wave
			case "preparing_spawn_wave":
				zombies = GetAiSpeciesArray( "axis" );
				for( i=0; i < zombies.size; i++ )
				{
					if( zombies[i].has_legs && zombies[i].animname == "zombie") // make sure not a dog.
					{
						move_speed = "sprint";

						if ( flag( "start_supersprint" ) )
						{
							move_speed  = "super_sprint";
						}

						zombies[i] set_zombie_run_cycle( move_speed );
						level.initial_spawn = false;
						level notify( "start_nml_ramp" );
						
						if( IsDefined( zombies[i].pre_black_hole_bomb_run_combatanim ) )
						{
							zombies[i].pre_black_hole_bomb_run_combatanim = move_speed;
						}
					}
				}
				
				if( current_time > next_round_time )
				{
					level notify( "nml_attack_wave" );
					mode = "spawn_wave_active";
					
					if( area == 1 )
					{
						area = 2;
						level thread nml_wave_attack( max_zombies, "nml_area2_spawners" );
					}
					else
					{
						area = 1;
						level thread nml_wave_attack( max_zombies, "nml_area1_spawners" );
					}
									
					next_round_time = current_time + wave_attack_time;
				}
				wait_override = 0.1;
			break;


			// Attack wave in progress
			// Occasionally spawn a zombie
			case "spawn_wave_active":
				if( current_time < next_round_time )
				{
					if( randomfloatrange(0, 1) < 0.05 )
					{
						ai = spawn_a_zombie( max_zombies, "nml_zone_spawners", 0.01,true );
						if( isdefined (ai) )
						{
							ai.ignore_gravity = true;
							move_speed = "sprint";

							if ( flag( "start_supersprint" ) )
							{
								move_speed  = "super_sprint";
							}

							ai set_zombie_run_cycle( move_speed );
							if( IsDefined( ai.pre_black_hole_bomb_run_combatanim ) )
							{
								ai.pre_black_hole_bomb_run_combatanim = move_speed;
							}
						}			
					}
				}
				else
				{
					level notify("wave_attack_finished");
					mode = "wave_finished_cooldown";
					next_round_time = current_time + cooldown_time;
				}
			break;
			

			// Round over, cooldown period
			case "wave_finished_cooldown":
			
				if( current_time > next_round_time )
				{
					next_round_time = current_time + next_attack_time;
					mode = "normal_spawning";
				}
				
				wait_override = 0.01;
			break;
		}


		/***************************************************************************************/
		/* If there are any dog targets (players running about in NML (away from the platform) */
		/* Send dogs after them																   */
		/***************************************************************************************/

		num_dog_targets = 0;
		if( (current_time - level.nml_start_time) > dog_round_start_time )
		{
			skip_dogs = 0;
			
			// *** DIFFICULTY FOR 1 Player ***
			players = GET_PLAYERS();
			if( players.size <= 1 )
			{
				dt = current_time - dog_can_spawn_time;
				if( dt < 0 )
				{
					//iPrintLn( "DOG SKIP" );
					skip_dogs = 1;
				}
				else
				{
					dog_can_spawn_time = current_time + randomfloatrange(dog_difficulty_min_time, dog_difficulty_max_time);
				}
			}
			
			if( mode == "preparing_spawn_wave" )
			{
				skip_dogs = 1;
			}

			if( !skip_dogs && level.nml_dogs_enabled == true)
			{
				num_dog_targets =  players.size;
				//iPrintLn( "Num Dog Targets: " + num_dog_targets );
		
				if( num_dog_targets )
				{
					// Send 2 dogs after each player
					dogs = getaispeciesarray( "axis", "dog" );
					num_dog_targets *= 2;
						
					if( dogs.size < num_dog_targets )
					{
						//IPrintLnBold("Spawn a dog");
						ai = maps\mp\zombies\_zm_ai_dogs::special_dog_spawn();
						
						//set their health to current level immediately.
						zombie_dogs = GetAISpeciesArray("axis","zombie_dog");
						if(IsDefined(zombie_dogs))
						{
							for( i=0; i<zombie_dogs.size; i++ )
							{
								zombie_dogs[i].maxhealth = int( level.nml_dog_health);
								zombie_dogs[i].health = int( level.nml_dog_health );
							}	
						}
					}
				}
			}
		}
	
		if( wait_override != 0.0 )
		{
			wait( wait_override );
		}
		else
		{
			wait randomfloatrange( 0.1, 0.8 );
		}
	}
}


//*****************************************************************************
// 
//*****************************************************************************
nml_wave_attack( num_in_wave, spawner_name )
{
	level endon("wave_attack_finished");
	level endon("restart_round");

	while( 1 )
	{
		zombies = GetAiSpeciesArray( "axis", "all" );
		if( zombies.size < num_in_wave )
		{
			ai = spawn_a_zombie( num_in_wave, spawner_name, 0.01,true );
			if( isdefined (ai) )
			{
				ai.ignore_gravity = true;
				move_speed = "sprint";

				if ( flag( "start_supersprint" ) )
				{
					move_speed  = "super_sprint";
				}

				ai set_zombie_run_cycle( move_speed );
				if( IsDefined( ai.pre_black_hole_bomb_run_combatanim ) )
				{
					ai.pre_black_hole_bomb_run_combatanim = move_speed;
				}
			}
		}

		wait randomfloatrange( 0.3, 1.0 );
	}
}


//*****************************************************************************
//*****************************************************************************
spawn_a_zombie( max_zombies, spawner_zone_name, wait_delay,ignoregravity )
{
	// Don't spawn a new zombie if we are at the limit
	zombies = getaispeciesarray( "axis" );
	if( zombies.size >= max_zombies )
	{
		return( undefined );
	}

	//zombie_spawners = getentarray( spawner_zone_name, "targetname" );
	spawn_point = level.nml_zombie_spawners[RandomInt( level.nml_zombie_spawners.size )]; 

	ai = spawn_zombie( spawn_point ); 
	if( IsDefined( ai ) )
	{	
		if(is_true(ignoregravity))
		{
			ai.ignore_gravity = true;
		}
		ai thread maps\mp\zombies\_zm::round_spawn_failsafe();
//		ai.zone_name = spawner_zone_name;

		if ( is_true( level.mp_side_step ) )
		{
			ai.shouldSideStepFunc = ::nml_shouldSideStep;
			ai.sideStepAnims = [];
			
	//t6todo		ai.sideStepAnims["step_left"]	= array( %ai_zombie_MP_sidestep_left_a, %ai_zombie_MP_sidestep_left_b );
	//t6todo		ai.sideStepAnims["step_right"]	= array( %ai_zombie_MP_sidestep_right_a, %ai_zombie_MP_sidestep_right_b );
		}
	}
	
	wait( wait_delay );
	wait_network_frame();
	
	return( ai );
}

//*****************************************************************************
//*****************************************************************************
screen_shake_manager( next_round_time )
{
	level endon( "nml_attack_wave" );
	level endon("restart_round");

	time = 0;
	while( time < next_round_time )
	{
		level thread attack_wave_screen_shake();
		wait_time = randomfloatrange(0.25, 0.35);
		wait( wait_time );
		time = gettime();
	}
}

attack_wave_screen_shake()
{
	/**********************************************************/
	/* Get a position that averages all the players positions */
	/**********************************************************/

	num_valid = 0;
	players = GET_PLAYERS();
	pos = ( 0, 0, 0 );
	
	for( i=0; i<players.size; i++ )
	{
		player = players[i];
		if( is_player_valid(player) )
		{
			pos += player.origin;
			num_valid ++;
		}
	}
	
	if( !num_valid )
	{
		return;
	}
	
	shake_position = ( (pos[0]/num_valid), (pos[1]/num_valid), (pos[2]/num_valid) );


	/**********/
	/* Rumble */
	/**********/

	thread rumble_all_players( "damage_heavy" );
	
	
	/****************/
	/* Shake Screen */
	/****************/
	
	scale = 0.4;
	duration = 1.0;
	radius = 42 * 400;
	
	//earthquake( scale, duration, shake_position, radius );
}


rumble_all_players(high_rumble_string, low_rumble_string, rumble_org, high_rumble_range, low_rumble_range)
{
	players = GET_PLAYERS();
	
	for (i = 0; i < players.size; i++)
	{
		if (isdefined (high_rumble_range) && isdefined (low_rumble_range) && isdefined(rumble_org))
		{
			if (distance (players[i].origin, rumble_org) < high_rumble_range)
			{
				players[i] playrumbleonentity(high_rumble_string);
			}
			else if (distance (players[i].origin, rumble_org) < low_rumble_range)
			{
				players[i] playrumbleonentity(low_rumble_string);
			}
		}
		else
		{
			players[i] playrumbleonentity(high_rumble_string);
		}
	}
}