#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\gametypes\_zm_gametype;
#using scripts\zm\gametypes\znml;

#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

//#using scripts\zm\_zm_ai_avogadro;

//#using scripts\zm\_zm_deadpool;






/*
	znml - znml Mode, wave based gameplay
	Objective: 	Stay alive for as long as you can
	Map ends:	When all players die
	Respawning:	No wait / Near teammates
*/

function main()
{
	zm_gametype::main();	// Generic zombie mode setup - must be called first.
	
	// Mode specific over-rides.
	
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onStartGameType =&onStartGameType;	
	level.onEndGame=&onEndGame;
	level._game_module_custom_spawn_init_func = &zm_gametype::custom_spawn_init_func;
	level._game_module_state_update_func = &zm_stats::survival_classic_custom_stat_update;

	zm_utility::set_gamemode_var("post_init_zombie_spawn_func",&onSpawnZombie);
	
	zm_gametype::post_gametype_main("znml");
}

function onPrecacheGameType()
{
	level.playerSuicideAllowed = true;
	level.canPlayerSuicide =&zm_gametype::canPlayerSuicide;
	
	level thread zm_gametype::init();

	level thread makeFindFleshStructs();
	
	flag_init_undef( "between_rounds" );
	
	zm_gametype::runGameTypePrecache("znml");

}

function makeFindFleshStructs()
{
	structs = struct::get_array( "spawn_location", "script_noteworthy" );
	
	foreach ( struct in structs )
	{
		struct.script_string = "find_flesh";
	}
}

function onStartGameType()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnMins = math::expand_mins( level.spawnMins, struct.origin );
		level.spawnMaxs = math::expand_maxs( level.spawnMaxs, struct.origin );
	}

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs ); 
	setMapCenter( level.mapCenter );

	//setup all the classic mode stuff 
	zm_gametype::setup_classic_gametype();
	
	// Disable Doors
	//--------------
	doors = GetEntArray( "zombie_door", "targetname" );
	foreach ( door in doors )
	{
		door SetInvisibleToAll();
	}
	
	// Disable Windows
	//----------------
	level thread zm_blockers::open_all_zbarriers();	
	
	updateGametypeVariables();

	level.round_spawn_func =&nml_round_manager;
	
	zm_gametype::runGameTypeMain("znml",&znml_main);

}

function znml_main()
{
	level thread nml_ramp_up_zombies();

	setup_players();
	
	level notify("start_fullscreen_fade_out");

	level flag::clear( "zombie_drop_powerups" );
	
	//disable chalk
	level._supress_survived_screen = 1;
	level.nml_dog_health = 100;

	level thread nml_dogs_init();
	level flag::wait_till("start_zombie_round_logic");
	level thread zm::round_start();	

}

function onSpawnZombie()
{
	self.exclude_distance_cleanup_adding_to_total = true;
}

function setup_players( predictedSpawn )
{
	players = GetPlayers();
	foreach ( index, player in players )
	{
		// Give Grenades
		//--------------
		lethal_grenade = player zm_utility::get_player_lethal_grenade();
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

	// TODO - Pitted is nml with teams - move this to pitted set up.
	// Survival
	//---------
/*	if( GetDvarString( "ui_gametype" ) == "znml" )
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
	} */
}

function nml_round_manager()
{
	level endon("restart_round");

	// *** WHAT IS THIS? *** 
	level.dog_targets = GetPlayers();
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

		zombies = zombie_utility::get_round_enemy_array();
		
		while( zombies.size >= max_zombies )
		{
			zombies = zombie_utility::get_round_enemy_array();
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

						if ( level flag::get( "start_supersprint" ) )
						{
							move_speed  = "super_sprint";
						}

						ai zombie_utility::set_zombie_run_cycle( move_speed );
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
				zombies = zombie_utility::get_round_enemy_array();
				for( i=0; i < zombies.size; i++ )
				{
					if( isdefined(zombies[i]) && !zombies[i].missingLegs && isdefined(zombies[i].animname) && zombies[i].animname == "zombie") // make sure not a dog.
					{
						move_speed = "sprint";

						if ( level flag::get( "start_supersprint" ) )
						{
							move_speed  = "super_sprint";
						}

						zombies[i] zombie_utility::set_zombie_run_cycle( move_speed );
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

							if ( level flag::get( "start_supersprint" ) )
							{
								move_speed  = "super_sprint";
							}

							ai zombie_utility::set_zombie_run_cycle( move_speed );
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
			players = GetPlayers();
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
					dogs = getaispeciesarray( "axis", "zombie_dog" );
					num_dog_targets *= 2;
						
					if( dogs.size < num_dog_targets )
					{
						//IPrintLnBold("Spawn a dog");
						ai = zm_ai_dogs::special_dog_spawn();
						
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

function updateGametypeVariables()
{
	level.objectiveBased = true;

	level.nml_max_zombies = 24;
	level.nml_zombie_spawners = level.zombie_spawners;

	level.objectivePlantTime = 10;

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
	level._get_game_module_players =&get_game_module_players;
	level.powerup_drop_count = 0;

	SetMatchTalkFlag( "DeadChatWithDead", 1 );
	SetMatchTalkFlag( "DeadChatWithTeam", 1 );
	SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
	SetMatchTalkFlag( "DeadHearAllLiving", 1 );
	SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
}

function onEndGame( winningTeam )
{
	level thread display_time_survived();
}

function flag_init_undef( flag )
{
	if ( !IsDefined( level.flag[ flag ] ) )
	{
		level flag::init( flag );
	}
}

function nml_ramp_up_zombies()
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
		thread zm_utility::play_sound_2D( "evt_nomans_warning" );

		zombies = zombie_utility::get_round_enemy_array();
		z = 0;
		while ( isdefined(zombies) && zombies.size>0 && z<zombies.size )
		{
			zombie = zombies[z];
			//remove zombies from this array that have already taken damage or had thier head gibbed
			if ( ( zombie.health != level.zombie_health ) || ( isdefined( zombie.gibbed ) && zombie.gibbed ) || ( isdefined( zombie.head_gibbed ) && zombie.head_gibbed ) )
			{
				ArrayRemoveValue( zombies, zombie );
				z = 0;
			}
			else
			{
				z++;
			}
		}

		zombie_utility::ai_calculate_health( level.nml_timer );

		// all zombies full health ramp up.
		foreach ( zombie in zombies )
		{
			if ( ( isdefined( zombie.gibbed ) && zombie.gibbed ) || ( isdefined( zombie.head_gibbed ) && zombie.head_gibbed ) )
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

			if ( ( isdefined( level.mp_side_step ) && level.mp_side_step ) )
			{
				zombie.shouldSideStepFunc =&nml_shouldSideStep;
				zombie.sideStepAnims = [];

				//t6todo			zombie.sideStepAnims[ "step_left" ]	= array( %ai_zombie_MP_sidestep_left_a, %ai_zombie_MP_sidestep_left_b );
				//t6todo			zombie.sideStepAnims[ "step_right" ]	= array( %ai_zombie_MP_sidestep_right_a, %ai_zombie_MP_sidestep_right_b );
			}
		}

		IPrintLn( "RAMP UP: " + level.nml_timer + " - " + level.zombie_health );

		if ( level.nml_timer == 6 )
		{
			level flag::set( "start_supersprint" );
		}

		wait( 20.0 );
	}
}

function nml_dogs_init()
{
	level.nml_dogs_enabled = false;
	wait(5);
	level.nml_dogs_enabled = true;
}

function nml_round_never_ends()
{
	wait( 2 );
	
	level endon( "restart_round" );

	while( 1 ) //level flag::get("enter_nml") )
	{
		zombies = zombie_utility::get_round_enemy_array();
		if( zombies.size >= 2 )
		{
			// This ensures the round will never end
			level.zombie_total = 100;
			return;
		}
		wait( 1 );
	}
}

//*****************************************************************************
//*****************************************************************************
function spawn_a_zombie( max_zombies, spawner_zone_name, wait_delay,ignoregravity )
{
	// Don't spawn a new zombie if we are at the limit
	zombies = zombie_utility::get_round_enemy_array();
	if( zombies.size >= max_zombies )
	{
		return( undefined );
	}

	//zombie_spawners = getentarray( spawner_zone_name, "targetname" );
	spawn_point = level.nml_zombie_spawners[RandomInt( level.nml_zombie_spawners.size )]; 

	ai = zombie_utility::spawn_zombie( spawn_point ); 
	if( IsDefined( ai ) )
	{	
		if(( isdefined( ignoregravity ) && ignoregravity ))
		{
			ai.ignore_gravity = true;
		}
		ai thread zombie_utility::round_spawn_failsafe();
//		ai.zone_name = spawner_zone_name;

		if ( ( isdefined( level.mp_side_step ) && level.mp_side_step ) )
		{
			ai.shouldSideStepFunc =&nml_shouldSideStep;
			ai.sideStepAnims = [];
			
	//t6todo		ai.sideStepAnims["step_left"]	= array( %ai_zombie_MP_sidestep_left_a, %ai_zombie_MP_sidestep_left_b );
	//t6todo		ai.sideStepAnims["step_right"]	= array( %ai_zombie_MP_sidestep_right_a, %ai_zombie_MP_sidestep_right_b );
		}
	}
	
	wait( wait_delay );
	util::wait_network_frame();
	
	return( ai );
}

//*****************************************************************************
//*****************************************************************************
function screen_shake_manager( next_round_time )
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

function attack_wave_screen_shake()
{
	/**********************************************************/
	/* Get a position that averages all the players positions */
	/**********************************************************/

	num_valid = 0;
	players = GetPlayers();
	pos = ( 0, 0, 0 );
	
	for( i=0; i<players.size; i++ )
	{
		player = players[i];
		if( zm_utility::is_player_valid(player) )
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


function rumble_all_players(high_rumble_string, low_rumble_string, rumble_org, high_rumble_range, low_rumble_range)
{
	players = GetPlayers();
	
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

function get_players_on_nml_team( team )
{
	players = GetPlayers();
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

function get_game_module_players( player )
{
	return get_players_on_nml_team( player._nml_team );
}

function display_time_survived()
{
	players = GetPlayers();
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
		player_survival_time_in_mins = zm::to_mins( player_survival_time );		
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

function nml_shouldSideStep()
{
	if ( self nml_canSideStep() )
	{
		return "step";
	}

	return "none";
}

function nml_canSideStep()
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

function nml_wave_attack( num_in_wave, spawner_name )
{
	level endon("wave_attack_finished");
	level endon("restart_round");

	while( 1 )
	{
		zombies = zombie_utility::get_round_enemy_array();
		if( zombies.size < num_in_wave )
		{
			ai = spawn_a_zombie( num_in_wave, spawner_name, 0.01,true );
			if( isdefined (ai) )
			{
				ai.ignore_gravity = true;
				move_speed = "sprint";

				if ( level flag::get( "start_supersprint" ) )
				{
					move_speed  = "super_sprint";
				}

				ai zombie_utility::set_zombie_run_cycle( move_speed );
				if( IsDefined( ai.pre_black_hole_bomb_run_combatanim ) )
				{
					ai.pre_black_hole_bomb_run_combatanim = move_speed;
				}
			}
		}

		wait randomfloatrange( 0.3, 1.0 );
	}
}
