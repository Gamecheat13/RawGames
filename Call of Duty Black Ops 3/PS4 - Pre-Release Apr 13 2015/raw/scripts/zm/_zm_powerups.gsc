#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                   

#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\gib;

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                       	                                
                                                                
                                                                                                                               

#precache( "material", "black" );

#precache( "fx", "zombie/fx_powerup_on_green_zmb" );
#precache( "fx", "zombie/fx_powerup_off_green_zmb" );
#precache( "fx", "zombie/fx_powerup_grab_green_zmb" );
#precache( "fx", "zombie/fx_powerup_wave_green_zmb" );
#precache( "fx", "zombie/fx_powerup_on_red_zmb" );
#precache( "fx", "zombie/fx_powerup_grab_red_zmb" );
#precache( "fx", "zombie/fx_powerup_wave_red_zmb" );
#precache( "fx", "zombie/fx_powerup_on_solo_zmb" );
#precache( "fx", "zombie/fx_powerup_grab_solo_zmb" );
#precache( "fx", "zombie/fx_powerup_wave_solo_zmb" );
#precache( "fx", "zombie/fx_powerup_on_caution_zmb" );
#precache( "fx", "zombie/fx_powerup_grab_caution_zmb" );
#precache( "fx", "zombie/fx_powerup_wave_caution_zmb" );

#namespace zm_powerups;

function init()
{	
	// powerup Vars
	zombie_utility::set_zombie_var( "zombie_insta_kill",					0, undefined, undefined, true );
	zombie_utility::set_zombie_var( "zombie_point_scalar",					1, undefined, undefined, true );
	zombie_utility::set_zombie_var( "zombie_drop_item",						0 );
	zombie_utility::set_zombie_var( "zombie_timer_offset",					350 );	// hud offsets
	zombie_utility::set_zombie_var( "zombie_timer_offset_interval",			30 );
	zombie_utility::set_zombie_var( "zombie_powerup_fire_sale_on",			false );
	zombie_utility::set_zombie_var( "zombie_powerup_fire_sale_time",		30 );
	zombie_utility::set_zombie_var( "zombie_powerup_bonfire_sale_on",		false );
	zombie_utility::set_zombie_var( "zombie_powerup_bonfire_sale_time",		30 );
	zombie_utility::set_zombie_var( "zombie_powerup_insta_kill_on",			false, undefined, undefined, true );
	zombie_utility::set_zombie_var( "zombie_powerup_insta_kill_time",		30, undefined, undefined, true );	// length of insta kill
	zombie_utility::set_zombie_var( "zombie_powerup_double_points_on",		false, undefined, undefined, true );
	zombie_utility::set_zombie_var( "zombie_powerup_double_points_time",	30, undefined, undefined, true );	// length of point doubler
	// Modify by the percentage of points that the player gets
	zombie_utility::set_zombie_var( "zombie_powerup_drop_increment",		2000 );	// 2000, lower this to make drop happen more often
	zombie_utility::set_zombie_var( "zombie_powerup_drop_max_per_round",	4 );	// 4, raise this to make drop happen more often

	// special vars for individual power ups
	callback::on_connect( &init_player_zombie_vars);

	// powerups
	level._effect["powerup_on"] 					= "zombie/fx_powerup_on_green_zmb";
	level._effect["powerup_off"] 					= "zombie/fx_powerup_off_green_zmb";
	level._effect["powerup_grabbed"] 				= "zombie/fx_powerup_grab_green_zmb";
	level._effect["powerup_grabbed_wave"] 			= "zombie/fx_powerup_wave_green_zmb";
	if (( isdefined( level.using_zombie_powerups ) && level.using_zombie_powerups ))
	{
		level._effect["powerup_on_red"] 				= "zombie/fx_powerup_on_red_zmb";
		level._effect["powerup_grabbed_red"] 			= "zombie/fx_powerup_grab_red_zmb";
		level._effect["powerup_grabbed_wave_red"] 		= "zombie/fx_powerup_wave_red_zmb";
	}
	level._effect["powerup_on_solo"]				= "zombie/fx_powerup_on_solo_zmb";
	level._effect["powerup_grabbed_solo"]			= "zombie/fx_powerup_grab_solo_zmb";
	level._effect["powerup_grabbed_wave_solo"] 		= "zombie/fx_powerup_wave_solo_zmb";
	level._effect["powerup_on_caution"]				= "zombie/fx_powerup_on_caution_zmb";
	level._effect["powerup_grabbed_caution"]		= "zombie/fx_powerup_grab_caution_zmb";
	level._effect["powerup_grabbed_wave_caution"] 	= "zombie/fx_powerup_wave_caution_zmb";

	init_powerups();
	
	if(!level.enable_magic)
	{
		return;
	}
	
	thread watch_for_drop();
}


//
function init_powerups()
{
	level flag::init( "zombie_drop_powerups" );	// As long as it's set, powerups will be able to spawn
	
	if(( isdefined( level.enable_magic ) && level.enable_magic ))
	{
		level flag::set( "zombie_drop_powerups" );
	}

	if( !IsDefined( level.active_powerups ) )
	{
		level.active_powerups = [];
	}

	//Random Drops
	
	//not sure if there's a better place to put this function call
	add_zombie_powerup( "insta_kill_ug",		"zombie_skull",					&"ZOMBIE_POWERUP_INSTA_KILL",	&func_should_never_drop, true, !true, !true, undefined, "powerup_instant_kill_ug", "zombie_powerup_insta_kill_ug_time", "zombie_powerup_insta_kill_ug_on", 1 );
	
	if(isDefined(level.level_specific_init_powerups))
	{
		[[level.level_specific_init_powerups]]();
	}
	
	// Randomize the order
	randomize_powerups();
	level.zombie_powerup_index = 0;
	randomize_powerups();

	// Rare powerups
	level.rare_powerups_active = 0;
	
	//AUDIO: Prevents the long firesale vox from playing more than once
	level.firesale_vox_firstime = false;

	// start the power up process monitor:
	level thread powerup_hud_monitor();
	clientfield::register( "scriptmover", "powerup_fx", 1, 3, "int" );
}


//	Creates zombie_vars that need to be tracked on an individual basis rather than as
//	a group.
function init_player_zombie_vars()
{
	self.zombie_vars[ "zombie_powerup_insta_kill_ug_on" ] = false; // persistent instant kill upgrade
	self.zombie_vars[ "zombie_powerup_insta_kill_ug_time" ] = 18; //level.pers_insta_kill_upgrade_active_time
}

function set_weapon_ignore_max_ammo( weapon )
{
	if ( !IsDefined( level.zombie_weapons_no_max_ammo ) )
	{
		level.zombie_weapons_no_max_ammo = [];
	}
	
	level.zombie_weapons_no_max_ammo[ weapon ] = 1;
}

//
function powerup_hud_monitor( )
{
	level flag::wait_till( "start_zombie_round_logic" );

	// race mode has no global powerup drops for now
	if(isDefined(level.current_game_module) && level.current_game_module == 2) 
	{
		return;
	}

	// Setting up flashing timer and clientfield values
	flashing_timers = [];
	flashing_values = [];
	flashing_timer = 10;
	flashing_delta_time = 0;
	flashing_is_on = false;
	flashing_value = 3;
	flashing_min_timer = 0.1+0.05;
	while( flashing_timer >= flashing_min_timer )
	{
		if ( flashing_timer < 5)
		{
			flashing_delta_time = 0.1;
		}
		else
		{
			flashing_delta_time = 0.2;
		}

		if( flashing_is_on )
		{
			flashing_timer = flashing_timer - flashing_delta_time - 0.05;
			flashing_value = 2;
		}
		else
		{
			flashing_timer = flashing_timer - flashing_delta_time;
			flashing_value = 3;
		}

		flashing_timers[flashing_timers.size] = flashing_timer;
		flashing_values[flashing_values.size] = flashing_value;
		
		flashing_is_on = !flashing_is_on;
	}

	// Setting up client_fields
	client_fields = [];
	powerup_keys = GetArrayKeys( level.zombie_powerups );
	for ( powerup_key_index = 0; powerup_key_index < powerup_keys.size; powerup_key_index++ )
	{
		if ( IsDefined( level.zombie_powerups[powerup_keys[powerup_key_index]].client_field_name ) )
		{
			powerup_name = powerup_keys[powerup_key_index];
			client_fields[powerup_name] = SpawnStruct();

			client_fields[powerup_name].client_field_name = level.zombie_powerups[powerup_name].client_field_name;
			client_fields[powerup_name].only_affects_grabber = level.zombie_powerups[powerup_name].only_affects_grabber;
			client_fields[powerup_name].time_name = level.zombie_powerups[powerup_name].time_name;
			client_fields[powerup_name].on_name = level.zombie_powerups[powerup_name].on_name;
		}
	}
	client_field_keys = GetArrayKeys( client_fields );

	// main logic
	while ( true )
	{
		{wait(.05);};
		waittillframeend;

		players = GetPlayers();
		// for loop over clientfields
		// for loop over players
		for( playerIndex = 0; playerIndex < players.size; playerIndex++ )
		{
			for ( client_field_key_index = 0; client_field_key_index < client_field_keys.size; client_field_key_index++ )
			{
				player = players[playerIndex];

				/#
				if (( isdefined( player.pers["isBot"] ) && player.pers["isBot"] ))
					continue;
				#/
					
				if (isdefined(level.powerup_player_valid))
				{
					if ( ! [[level.powerup_player_valid]]( player ))
						continue;
				}

				client_field_name = client_fields[client_field_keys[client_field_key_index]].client_field_name;
				time_name = client_fields[client_field_keys[client_field_key_index]].time_name;
				on_name = client_fields[client_field_keys[client_field_key_index]].on_name;
				powerup_timer = undefined;
				powerup_on = undefined;

				// if solo, pass in player.var
				if ( client_fields[client_field_keys[client_field_key_index]].only_affects_grabber )
				{
					if( IsDefined( player._show_solo_hud ) && player._show_solo_hud == true )
					{
						powerup_timer = player.zombie_vars[time_name];
						powerup_on = player.zombie_vars[on_name];
					}
				}
				else if ( IsDefined( level.zombie_vars[player.team][time_name] ) )
				{
					powerup_timer = level.zombie_vars[player.team][time_name];
					powerup_on = level.zombie_vars[player.team][on_name];
				}
				else if ( IsDefined( level.zombie_vars[time_name] ) )
				{
					powerup_timer = level.zombie_vars[time_name];
					powerup_on = level.zombie_vars[on_name];
				}

				if ( IsDefined( powerup_timer ) && IsDefined( powerup_on ) )
				{
					player set_clientfield_powerups( client_field_name, powerup_timer, powerup_on, flashing_timers, flashing_values );
				}
				else
				{
					player clientfield::set_to_player( client_field_name, 0 );
				}
			}
		}
	}
}

//
function set_clientfield_powerups( clientfield_name, powerup_timer, powerup_on, flashing_timers, flashing_values )
{
	if ( powerup_on )
	{
		if ( powerup_timer < 10 )
		{
			// flashing stage
			flashing_value = 3;
			for ( i = flashing_timers.size - 1; i > 0; i-- )
			{
				if ( powerup_timer < flashing_timers[i] )
				{
					flashing_value = flashing_values[i];
					break;
				}
			}
			self clientfield::set_to_player( clientfield_name, flashing_value );
		}
		else
		{
			self clientfield::set_to_player( clientfield_name, 1 );
		}
	}
	else
	{
		self clientfield::set_to_player( clientfield_name, 0 );
	}
}


function randomize_powerups()
{
	if( !isdefined( level.zombie_powerup_array ) )
	{
		level.zombie_powerup_array = [];
	}
	else
	{
		level.zombie_powerup_array = array::randomize( level.zombie_powerup_array );
	}
}

//
// Get the next powerup in the list
//
function get_next_powerup()
{
	powerup = level.zombie_powerup_array[ level.zombie_powerup_index ];

	level.zombie_powerup_index++;
	if( level.zombie_powerup_index >= level.zombie_powerup_array.size )
	{
		level.zombie_powerup_index = 0;
		randomize_powerups();
	}

	return powerup;
}


//
// Figure out what the next powerup drop is
//
// Powerup Rules:
//   "carpenter": Needs at least 5 windows destroyed
//   "fire_sale": Needs the box to have moved
//
//
function get_valid_powerup()
{
/#
	if( isdefined( level.zombie_devgui_power ) && level.zombie_devgui_power == 1 )
		return level.zombie_powerup_array[ level.zombie_powerup_index ];
#/

	if ( isdefined( level.zombie_powerup_boss ) )
	{
		i = level.zombie_powerup_boss;
		level.zombie_powerup_boss = undefined;
		return level.zombie_powerup_array[ i ];
	}

	if ( isdefined( level.zombie_powerup_ape ) )
	{
		powerup = level.zombie_powerup_ape;
		level.zombie_powerup_ape = undefined;
		return powerup;
	}


	powerup = get_next_powerup();
	while( 1 )
	{
		if(	![[level.zombie_powerups[powerup].func_should_drop_with_regular_powerups]]() )
		{
			powerup = get_next_powerup();
			continue;
		}
		return powerup;
	}
}

function minigun_no_drop()
{
	players = GetPlayers();
	for ( i=0; i<players.size; i++ )
	{
		if( players[i].zombie_vars[ "zombie_powerup_minigun_on" ] == true )
		{
			return true;
		}
	}

	if( !level flag::get( "power_on" ) ) // if power is not on check for solo
	{
		if( level flag::get( "solo_game" ) ) // if it is a solo game then perform another check
		{
			if( level.solo_lives_given == 0 ) // the power isn't on, it is a solo game, has the player purchased a life/revive?
			{
				return true; // no drop because the player has no bought a life/revive
			}
		}
		else
		{
			return true; // not a solo game, powerup is invalid
		}
	}
	
	return false;
}

function watch_for_drop()
{
	level endon("unloaded");
	level flag::wait_till( "start_zombie_round_logic" );
	level flag::wait_till( "begin_spawning" );
	{wait(.05);};
	
	players = GetPlayers();
	score_to_drop = ( players.size * level.zombie_vars["zombie_score_start_"+players.size+"p"] ) + level.zombie_vars["zombie_powerup_drop_increment"];

	while (1)
	{
		level flag::wait_till( "zombie_drop_powerups" );

		players = GetPlayers();

		curr_total_score = 0;

		for (i = 0; i < players.size; i++)
		{
			if(isdefined(players[i].score_total))
			{
				curr_total_score += players[i].score_total;
			}
		}

		if (curr_total_score > score_to_drop )
		{
			level.zombie_vars["zombie_powerup_drop_increment"] *= 1.14;
			score_to_drop = curr_total_score + level.zombie_vars["zombie_powerup_drop_increment"];
			level.zombie_vars["zombie_drop_item"] = 1;
		}

		wait( 0.5 );
	}
}

function get_random_powerup_name()
{
	powerup_keys = GetArrayKeys( level.zombie_powerups );
	powerup_keys = array::randomize( powerup_keys );
	return powerup_keys[0];
}

function get_regular_random_powerup_name()
{
	powerup_keys = GetArrayKeys( level.zombie_powerups );
	powerup_keys = array::randomize( powerup_keys );

	for ( i = 0; i < powerup_keys.size; i++ )
	{
		if ( [[level.zombie_powerups[powerup_keys[i]].func_should_drop_with_regular_powerups]]() )
		{
			return powerup_keys[i];
		}
	}

	return powerup_keys[0];
}

function add_zombie_powerup( powerup_name, model_name, hint, func_should_drop_with_regular_powerups, only_affects_grabber, any_team, zombie_grabbable, fx, client_field_name, time_name, on_name, clientfield_version = 1 )
{
	if( IsDefined( level.zombie_include_powerups ) && !( isdefined( level.zombie_include_powerups[powerup_name] ) && level.zombie_include_powerups[powerup_name] ) )
	{
		return;
	}
	
	if( !IsDefined( level.zombie_powerup_array ) )
	{
		level.zombie_powerup_array = [];
	}	

	struct = SpawnStruct();

	if( !IsDefined( level.zombie_powerups ) )
	{
		level.zombie_powerups = [];
	}

	struct.powerup_name = powerup_name;
	struct.model_name = model_name;
	struct.weapon_classname = "script_model";
	struct.hint = hint;
	struct.func_should_drop_with_regular_powerups = func_should_drop_with_regular_powerups;
	struct.only_affects_grabber = only_affects_grabber;
	struct.any_team = any_team;
	struct.zombie_grabbable = zombie_grabbable;

	struct.can_pick_up_in_last_stand = true;

	if( IsDefined( fx ) )
	{
		struct.fx = fx;
	}

	level.zombie_powerups[powerup_name] = struct;
	level.zombie_powerup_array[level.zombie_powerup_array.size] = powerup_name;
	add_zombie_special_drop( powerup_name );
	
	if( IsDefined( client_field_name ) )
	{
		clientfield::register( "toplayer", client_field_name, clientfield_version, 2, "int" );
		struct.client_field_name = client_field_name;
		struct.time_name = time_name;
		struct.on_name = on_name;
	}
}

function powerup_set_can_pick_up_in_last_stand( powerup_name, b_can_pick_up )
{	
	level.zombie_powerups[ powerup_name ].can_pick_up_in_last_stand = b_can_pick_up;
}

// special powerup list for the teleporter drop
function add_zombie_special_drop( powerup_name )
{
	if ( !IsDefined( level.zombie_special_drop_array ) )
	{
		level.zombie_special_drop_array = [];
	}
	
	level.zombie_special_drop_array[ level.zombie_special_drop_array.size ] = powerup_name;
}

function include_zombie_powerup( powerup_name )
{
	if( !IsDefined( level.zombie_include_powerups ) )
	{
		level.zombie_include_powerups = [];
	}

	level.zombie_include_powerups[powerup_name] = true;
}

function powerup_remove_from_regular_drops( powerup_name )
{
	// do this in "main" not "init" so the powerup will be present.
	assert( isdefined( level.zombie_powerups ) );
	assert( isdefined( level.zombie_powerups[ powerup_name ] ) );

	level.zombie_powerups[ powerup_name ].func_should_drop_with_regular_powerups = &zm_powerups::func_should_never_drop;
}

function powerup_round_start()
{
	level.powerup_drop_count = 0;
}

function powerup_drop(drop_point)
{
	if( level.powerup_drop_count >= level.zombie_vars["zombie_powerup_drop_max_per_round"] )
	{
/#
		println( "^3POWERUP DROP EXCEEDED THE MAX PER ROUND!" );
#/
		return;
	}
	
	if( !isDefined(level.zombie_include_powerups) || level.zombie_include_powerups.size == 0 )
	{
		return;
	}
	
	// some guys randomly drop, but most of the time they check for the drop flag
	rand_drop = randomint(100);
	
	if (rand_drop > 2)
	{
		if (!level.zombie_vars["zombie_drop_item"])
		{
			return;
		}

		debug = "score";
	}
	else
	{
		debug = "random";
	}	

	// Never drop unless in the playable area
	playable_area = getentarray("player_volume","script_noteworthy");
	
	// This needs to go above the network_safe_spawn because that has a wait.
	//	Otherwise, multiple threads could attempt to drop powerups.
	level.powerup_drop_count++;

	powerup = zm_net::network_safe_spawn( "powerup", 1, "script_model", drop_point + (0,0,40));
	
	//chris_p - fixed bug where you could not have more than 1 playable area trigger for the whole map
	valid_drop = false;
	for (i = 0; i < playable_area.size; i++)
	{
		if (powerup istouching(playable_area[i]))
		{
			valid_drop = true;
			break;
		}
	}
	
	// If a valid drop
	// We will rarely override the drop with a "rare drop"  (MikeA 3/23/10)
	if( valid_drop && level.rare_powerups_active )
	{
		pos = ( drop_point[0], drop_point[1], drop_point[2] + 42 );
		if( check_for_rare_drop_override( pos ) )
		{
			level.zombie_vars["zombie_drop_item"] = 0;
			valid_drop = 0;
		}
	}
	
	// If not a valid drop, allow another spawn to be attempted
	if(! valid_drop )
	{
		level.powerup_drop_count--;
		powerup delete();
		return;
	}

	powerup powerup_setup();

	print_powerup_drop( powerup.powerup_name, debug );

	powerup thread powerup_timeout();
	powerup thread powerup_wobble();
	powerup thread powerup_grab();
	powerup thread powerup_move();
	powerup thread powerup_emp();

	level.zombie_vars["zombie_drop_item"] = 0;

	// RAVEN BEGIN bhackbarth: let the level know that a powerup has been dropped
	level notify("powerup_dropped", powerup);
	// RAVEN END
}


//
//	Drop the specified powerup
function specific_powerup_drop( powerup_name, drop_spot, powerup_team, powerup_location, pickup_delay )
{
	powerup = zm_net::network_safe_spawn( "powerup", 1, "script_model", drop_spot + (0,0,40));

	level notify("powerup_dropped", powerup);

	if ( IsDefined(powerup) )
	{
		powerup powerup_setup( powerup_name,powerup_team, powerup_location );

		powerup thread powerup_timeout();
		powerup thread powerup_wobble();
		if ( isdefined( pickup_delay ) && pickup_delay > 0 )
		{
			powerup util::delay( pickup_delay, "powerup_timedout", &powerup_grab, powerup_team);
		}
		else
		{
			powerup thread powerup_grab( powerup_team );
		}		
		powerup thread powerup_move();
		powerup thread powerup_emp();
		return powerup;
	}
}


//
//	Special power up drop - done outside of the powerup system.
function special_powerup_drop(drop_point)
{
// 	if( level.powerup_drop_count == level.zombie_vars["zombie_powerup_drop_max_per_round"] )
// 	{
// 		println( "^3POWERUP DROP EXCEEDED THE MAX PER ROUND!" );
// 		return;
// 	}

	if( !isDefined(level.zombie_include_powerups) || level.zombie_include_powerups.size == 0 )
	{
		return;
	}

	powerup = spawn ("script_model", drop_point + (0,0,40));

	// never drop unless in the playable area
	playable_area = getentarray("player_volume","script_noteworthy");
	//chris_p - fixed bug where you could not have more than 1 playable area trigger for the whole map
	valid_drop = false;
	for (i = 0; i < playable_area.size; i++)
	{
		if (powerup istouching(playable_area[i]))
		{
			valid_drop = true;
			break;
		}
	}

	if(!valid_drop)
	{
		powerup Delete();
		return;
	}

	powerup special_drop_setup();
}

//
//	Pick the next powerup in the list
function powerup_setup( powerup_override,powerup_team, powerup_location )
{
	powerup = undefined;
	
	if ( !IsDefined( powerup_override ) )
	{
		powerup = get_valid_powerup();
	}
	else
	{
		powerup = powerup_override;

		if ( "tesla" == powerup && tesla_powerup_active() )
		{
			// only one tesla at a time, give a minigun instead
			powerup = "minigun";
		}
	}	

	struct = level.zombie_powerups[powerup];

	if ( IsDefined( level._custom_powerups ) && IsDefined( level._custom_powerups[ powerup ] ) && IsDefined( level._custom_powerups[ powerup ].setup_powerup ) )
	{
		self [[level._custom_powerups[ powerup ].setup_powerup]]();
	}
	else
	{
		self SetModel( struct.model_name );
	}

	demo::bookmark( "zm_powerup_dropped", gettime(), undefined, undefined, 1 );

	//TUEY Spawn Powerup
	playsoundatposition("zmb_spawn_powerup", self.origin);
	
	if(isDefined(powerup_team))
	{
		self.powerup_team = powerup_team;  //for encounters
	}
	if(isDefined(powerup_location))
	{
		self.powerup_location = powerup_location; //for encounters
	}
	self.powerup_name 			= struct.powerup_name;
	self.hint 					= struct.hint;
	self.only_affects_grabber 	= struct.only_affects_grabber;
	self.any_team				= struct.any_team;
	self.zombie_grabbable 		= struct.zombie_grabbable;
	self.func_should_drop_with_regular_powerups = struct.func_should_drop_with_regular_powerups;

	if( IsDefined( struct.fx ) )
	{
		self.fx = struct.fx;
	}
	
	if( IsDefined( struct.can_pick_up_in_last_stand ) )
	{
		self.can_pick_up_in_last_stand = struct.can_pick_up_in_last_stand;
	}

	self PlayLoopSound("zmb_spawn_powerup_loop");
	
    level.active_powerups[level.active_powerups.size]=self;
}


//
//	Get the special teleporter drop
function special_drop_setup()
{
	powerup = undefined;
	
	if( isdefined( level.powerup_special_drop_override ) )
	{
		powerup = [[ level.powerup_special_drop_override ]]();
	}
	else
	{
		powerup = get_valid_powerup();	
	}

	if ( isdefined( powerup ) )
	{
		Playfx( level._effect["lightning_dog_spawn"], self.origin );
		playsoundatposition( "zmb_hellhound_prespawn", self.origin );
		wait( 1.5 );
		playsoundatposition( "zmb_hellhound_bolt", self.origin );

		Earthquake( 0.5, 0.75, self.origin, 1000);
		//PlayRumbleOnPosition("explosion_generic", self.origin);//TODO T7 - update rumble
		playsoundatposition( "zmb_hellhound_spawn", self.origin );

//		wait( 0.5 );

		self powerup_setup( powerup );

		self thread powerup_timeout();
		self thread powerup_wobble();
		self thread powerup_grab();
		self thread powerup_move();
		self thread powerup_emp();
	}
}

function powerup_zombie_grab_trigger_cleanup( trigger )
{
	self util::waittill_any( "powerup_timedout", "powerup_grabbed", "hacked" );

	trigger delete();
}

function powerup_zombie_grab(powerup_team)
{
	self endon( "powerup_timedout" );
	self endon( "powerup_grabbed" );
	self endon( "hacked" );
	
	zombie_grab_trigger = spawn( "trigger_radius", self.origin - (0,0,40), 1 + 8, 32, 72 );
	zombie_grab_trigger enablelinkto();
	zombie_grab_trigger linkto( self );
	zombie_grab_trigger SetTeamForTrigger( level.zombie_team );
	
	self thread powerup_zombie_grab_trigger_cleanup( zombie_grab_trigger );
	poi_dist = 300;
	if(isDefined(level._zombie_grabbable_poi_distance_override))
	{
		poi_dist = level._zombie_grabbable_poi_distance_override;
	}
	zombie_grab_trigger zm_utility::create_zombie_point_of_interest( poi_dist, 2, 0, true,undefined,undefined,powerup_team );

	while ( isdefined( self ) )
	{
		zombie_grab_trigger waittill( "trigger", who );
		if ( isdefined( level._powerup_grab_check ) )
		{
			if ( ! self [[level._powerup_grab_check]]( who ) )
				continue;
		}
		/*
		if(level.gametype == "zcleansed" ) //if playing cleansed/returned than human players can be zombies too, so we need to check for that. Might want to change this to a function pointer later
		{
			if(!isDefined(who) || !IS_TRUE (who.is_zombie))
			{
				continue;
			}
		}
		*/
		else if( !isdefined( who ) || !IsAI( who ) )
		{
			continue;
		}

		playfx( level._effect["powerup_grabbed_red"], self.origin );	
		playfx( level._effect["powerup_grabbed_wave_red"], self.origin );

		if( isdefined( level._custom_powerups ) && isdefined( level._custom_powerups[ self.powerup_name ] ) && isdefined( level._custom_powerups[ self.powerup_name ].grab_powerup ) )
		{
			b_continue = self [[ level._custom_powerups[ self.powerup_name ].grab_powerup ]]();
			if( ( isdefined( b_continue ) && b_continue ) )
			{
				continue;	
			}
		}
		else
		{
			if ( IsDefined( level._zombiemode_powerup_zombie_grab ) )
			{
				level thread [[ level._zombiemode_powerup_zombie_grab ]]( self );
			}
			
			if ( IsDefined( level._game_mode_powerup_zombie_grab ) )
			{
				level thread [[ level._game_mode_powerup_zombie_grab ]]( self,who );
			}
			
			
			// RAVEN END
			else
			{
			/#	println("Unrecognized poweup.");	#/
			}			
		}
		
		level thread zm_audio::sndAnnouncerPlayVox(self.powerup_name);

		wait( 0.1 );

		playsoundatposition( "zmb_powerup_grabbed", self.origin );
		self stoploopsound();

		self powerup_delete();
		self notify( "powerup_grabbed" );
	}
}

function powerup_grab(powerup_team)
{
	if ( isdefined( self ) && self.zombie_grabbable )
	{
		self thread powerup_zombie_grab(powerup_team);
		return;
	}

	self endon ("powerup_timedout");
	self endon ("powerup_grabbed");

	range_squared = 64 * 64;
	while (isdefined(self))
	{
		players = GetPlayers();

		for (i = 0; i < players.size; i++)
		{
			// Don't let them grab the minigun, tesla, or random weapon if they're downed or reviving
			//	due to weapon switching issues.
			if ( (self.powerup_name == "minigun" || self.powerup_name == "tesla" || self.powerup_name == "random_weapon" || self.powerup_name == "meat_stink" ) &&
				( players[i] laststand::player_is_in_laststand() ||
				  ( players[i] UseButtonPressed() && players[i] zm_utility::in_revive_trigger() ) ) )
			{
				continue;
			}
			
			// Don't let them grab this power up if they are in last stand and this power is not for last stand players
			if ( !( isdefined( self.can_pick_up_in_last_stand ) && self.can_pick_up_in_last_stand ) && players[i] laststand::player_is_in_laststand() )
			{
				continue;
			}

			ignore_range = false;
			if ( isdefined( players[i].ignore_range_powerup ) && players[i].ignore_range_powerup == self )
			{
				players[i].ignore_range_powerup = undefined;
				ignore_range = true;
			}
			
			if ( DistanceSquared( players[i].origin, self.origin ) < range_squared || ignore_range )
			{
				if ( isdefined( level._powerup_grab_check ) )
				{
					if ( ! self [[level._powerup_grab_check]]( players[i] ) )
						continue;
				}
				/*
				if(level.gametype == "zcleansed" ) //if playing cleansed/returned than human players can be zombies too, so we need to check for that
				{
					if( IS_TRUE (players[i].is_zombie))
					{
						continue;
					}
				}
				*/
				
				if( isdefined( level._custom_powerups ) && isdefined( level._custom_powerups[ self.powerup_name ] ) && isdefined( level._custom_powerups[ self.powerup_name ].grab_powerup ) )
				{
					b_continue = self [[ level._custom_powerups[ self.powerup_name ].grab_powerup ]]( players[i] );
					if( ( isdefined( b_continue ) && b_continue ) )
					{
						continue;	
					}
				}
				else
				{
					switch (self.powerup_name)
					{						
					case "teller_withdrawl":
						level thread teller_withdrawl(self ,players[i]);
						//TODO - play some sound/vo stuff here? 
						break;
						
					default:
						// RAVEN BEGIN bhackbarth: callback for level specific powerups
						if ( IsDefined( level._zombiemode_powerup_grab ) )
						{
							level thread [[ level._zombiemode_powerup_grab ]]( self, players[i] );
						}
						// RAVEN END
						else
						{
						/#	println ("Unrecognized poweup.");	#/
						}

						break;

					}
				}
				
				demo::bookmark( "zm_player_powerup_grabbed", gettime(), players[i] );

				if( should_award_stat ( self.powerup_name )) //don't do this for things that aren't really a powerup
				{
					//track # of picked up powerups/drops for the player
					players[i] zm_stats::increment_client_stat( "drops" );
					players[i] zm_stats::increment_player_stat( "drops" );
					players[i] zm_stats::increment_client_stat( self.powerup_name + "_pickedup" );
					players[i] zm_stats::increment_player_stat( self.powerup_name + "_pickedup" );
				}
				
				if ( self.only_affects_grabber )
				{
					playfx( level._effect["powerup_grabbed_solo"], self.origin );
					playfx( level._effect["powerup_grabbed_wave_solo"], self.origin );
				}
				else if ( self.any_team )
				{
					playfx( level._effect["powerup_grabbed_caution"], self.origin );
					playfx( level._effect["powerup_grabbed_wave_caution"], self.origin );
				}
				else
				{
					playfx( level._effect["powerup_grabbed"], self.origin );
					playfx( level._effect["powerup_grabbed_wave"], self.origin );
				}

				if ( ( isdefined( self.stolen ) && self.stolen ) )
				{
					level notify( "monkey_see_monkey_dont_achieved" );
				}
				
				if( IsDefined( self.grabbed_level_notify ) )
				{
					level notify( self.grabbed_level_notify );
				}

				// RAVEN BEGIN bhackbarth: since there is a wait here, flag the powerup as being taken 
				self.claimed = true;
				self.power_up_grab_player = players[i]; //Player who grabbed the power up
				// RAVEN END

				wait( 0.1 );
				
				playsoundatposition("zmb_powerup_grabbed", self.origin);
				self stoploopsound();
				self hide();
				
				//Preventing the line from playing AGAIN if fire sale becomes active before it runs out
				if( self.powerup_name != "fire_sale" )
				{
					if( isdefined( self.power_up_grab_player ) )
					{
						if(isDefined(level.powerup_intro_vox))
						{
							level thread [[level.powerup_intro_vox]](self);
							return;
						}
						else
						{
							if(isDefined(level.powerup_vo_available) )
							{
								can_say_vo = [[level.powerup_vo_available]]();
								if(!can_say_vo)
								{
									self powerup_delete();
									self notify ("powerup_grabbed");
									return;
								}
							}
						}
					}
				}

				level thread zm_audio::sndAnnouncerPlayVox(self.powerup_name);
				self powerup_delete();
				self notify ("powerup_grabbed");
			}
		}
		wait 0.1;
	}
}

function get_closest_window_repair( windows, origin )
{
	current_window = undefined;
	shortest_distance = undefined;
	for( i = 0; i < windows.size; i++ )
	{
		if( zm_utility::all_chunks_intact(windows, windows[i].barrier_chunks ) )
			continue;

		if( !IsDefined( current_window ) )	
		{
			current_window = windows[i];
			shortest_distance = DistanceSquared( current_window.origin, origin );
			
		}
		else
		{
			if( DistanceSquared(windows[i].origin, origin) < shortest_distance )
			{

				current_window = windows[i];
				shortest_distance =  DistanceSquared( windows[i].origin, origin );
			}

		}

	}

	return current_window;


}

//SELF = Player
function powerup_vo( type )
{
	self endon("death");
	self endon("disconnect");
	
	if(isDefined(level.powerup_vo_available) )
	{
		if(![[level.powerup_vo_available]]() )
		{
			return;
		}
	}
	
	wait( randomfloatrange(2,2.5) );

	if( type == "tesla" )
	{
		self zm_audio::create_and_play_dialog( "weapon_pickup", type );
	}
	else
	{
		self zm_audio::create_and_play_dialog( "powerup", type );
	}

	if(isDefined(level.custom_powerup_vo_response))
	{
		level [[level.custom_powerup_vo_response]](self,type);
	}
}

function powerup_wobble_fx()
{
	self endon( "death" ); 
	
	if ( !isdefined( self ) )
	{
		return;
	}

	if ( isDefined(level.powerup_fx_func) )
	{
		self thread [[level.powerup_fx_func]]();
		return;
	}

	//wait( 0.5 ); // must wait a bit because of the bug where a new entity has its events ignored on the client side //bumping it up from .1 to .5, this was failing in some instances
	
	if ( self.only_affects_grabber )
	{
		self clientfield::set( "powerup_fx", 2 );
	}
	else if ( self.any_team )
	{
		self clientfield::set( "powerup_fx", 4 );
	}	
	else if ( self.zombie_grabbable )
	{
		self clientfield::set( "powerup_fx", 3 );
	}
	else
	{
		self clientfield::set( "powerup_fx", 1 );
	}
}

function powerup_wobble()
{
	self endon( "powerup_grabbed" );
	self endon( "powerup_timedout" );

	self thread powerup_wobble_fx();

	while ( isdefined( self ) )
	{
		waittime = randomfloatrange( 2.5, 5 );
		yaw = RandomInt( 360 );
		if( yaw > 300 )
		{
			yaw = 300;
		}
		else if( yaw < 60 )
		{
			yaw = 60;
		}
		yaw = self.angles[1] + yaw;
		new_angles = (-60 + randomint( 120 ), yaw, -45 + randomint( 90 ));
		self rotateto( new_angles, waittime, waittime * 0.5, waittime * 0.5 );
		if ( isdefined( self.worldgundw ) )
		{
			self.worldgundw rotateto( new_angles, waittime, waittime * 0.5, waittime * 0.5 );
		}
		wait randomfloat( waittime - 0.1 );
	}
}

function powerup_timeout()
{
	if(isDefined(level._powerup_timeout_override)&& !isDefined(self.powerup_team))
	{
		self thread [[level._powerup_timeout_override]]();
		return;
	}
	self endon( "powerup_grabbed" );
	self endon( "death" );
	self endon("powerup_reset");
	
	self show();
	
	wait_time = 15;
	if (isDefined( level._powerup_timeout_custom_time ) )
	{
		time = [[level._powerup_timeout_custom_time]](self);
		if ( time == 0 )
		{
			return;
		}
		wait_time = time;
		
	}
	
	wait wait_time;

	for ( i = 0; i < 40; i++ )
	{
		// hide and show
		if ( i % 2 )
		{
			self ghost();
			if ( isdefined( self.worldgundw ) )
			{
				self.worldgundw ghost();
			}
		}
		else
		{
			self show();
			if ( isdefined( self.worldgundw ) )
			{
				self.worldgundw show();
			}
		}

		if ( i < 15 )
		{
			wait( 0.5 );
		}
		else if ( i < 25 )
		{
			wait( 0.25 );
		}
		else
		{
			wait( 0.1 );
		}
	}

	self notify( "powerup_timedout" );
	self powerup_delete();
}


function powerup_delete()
{
	ArrayRemoveValue(level.active_powerups,self,false);
	if ( isdefined( self.worldgundw ) )
	{
		self.worldgundw delete();
	}
	self delete();
}

function powerup_delete_delayed(time)
{
	if (isdefined(time))
		wait time;
	else
		wait 0.01;
	self powerup_delete();
}

//*****************************************************************************
//*****************************************************************************

// self == player
function is_insta_kill_active()
{
	return( level.zombie_vars[self.team]["zombie_insta_kill"] );
}

//*****************************************************************************
//*****************************************************************************

function check_for_instakill( player, mod, hit_location )
{
	if(isDefined(player) && isAlive(player) && isDefined(level.check_for_instakill_override)) 
	{
		if ( !self [[level.check_for_instakill_override]](player) )
		{
			return;
		}
		
		if(player.use_weapon_type == "MOD_MELEE")
		{
			player.last_kill_method = "MOD_MELEE";
		}
		else
		{
			player.last_kill_method = "MOD_UNKNOWN";

		}
		modName = zm_utility::remove_mod_from_methodofdeath( mod );
		if ( !( isdefined( self.no_gib ) && self.no_gib ) )
		{
			self zombie_utility::zombie_head_gib();
		}
		self.health = 1;
		self DoDamage( self.health + 666, self.origin, player, self, hit_location, modName );
		player notify("zombie_killed");
		
	}
	
	if( IsDefined( player ) && IsAlive( player ) && ( level.zombie_vars[player.team]["zombie_insta_kill"] || ( isdefined( player.personal_instakill ) && player.personal_instakill )) )
	{
		if( zm_utility::is_magic_bullet_shield_enabled( self ) )
		{
			return;
		}

		if ( IsDefined( self.instakill_func ) )
		{
			self thread [[ self.instakill_func ]]();
			return;
		}

		if(player.use_weapon_type == "MOD_MELEE")
		{
			player.last_kill_method = "MOD_MELEE";
		}
		else
		{
			player.last_kill_method = "MOD_UNKNOWN";

		}

		modName = zm_utility::remove_mod_from_methodofdeath( mod );
		if( !level flag::get( "special_round" ) && !( isdefined( self.no_gib ) && self.no_gib ) ) // normal zombie round, and zombie is gibbable
		{
			self zombie_utility::zombie_head_gib();
		}
		self.health = 1;
		self DoDamage( self.health + 666, self.origin, player, self, hit_location, modName );
		player notify("zombie_killed");
	}
}

function point_doubler_on_hud( drop_item, player_team )
{
	self endon ("disconnect");

	// check to see if this is on or not
	if ( level.zombie_vars[player_team]["zombie_powerup_double_points_on"] )
	{
		// reset the time and keep going
		level.zombie_vars[player_team]["zombie_powerup_double_points_time"] = 30;
		return;
	}

	level.zombie_vars[player_team]["zombie_powerup_double_points_on"] = true;
	//level.powerup_hud_array[0] = true;
	// set up the hudelem
	//hudelem = hud::createFontString( "objective", 2 );
	//hudelem hud::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] );
	//hudelem.sort = 0.5;
	//hudelem.alpha = 0;
	//hudelem fadeovertime( 0.5 );
	//hudelem.alpha = 1;
	//hudelem.label = drop_item.hint;

	// set time remaining for point doubler
	level thread time_remaining_on_point_doubler_powerup( player_team );

	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}

function time_remaining_on_point_doubler_powerup( player_team )
{
	//self setvalue( level.zombie_vars["zombie_powerup_double_points_time"] );
	
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent playloopsound ("zmb_double_point_loop");
	
	// time it down!
	while ( level.zombie_vars[player_team]["zombie_powerup_double_points_time"] >= 0)
	{
		{wait(.05);};
		level.zombie_vars[player_team]["zombie_powerup_double_points_time"] = level.zombie_vars[player_team]["zombie_powerup_double_points_time"] - 0.05;
		//self setvalue( level.zombie_vars["zombie_powerup_double_points_time"] );
	}

	// turn off the timer
	level.zombie_vars[player_team]["zombie_powerup_double_points_on"] = false;
	players = GetPlayers( player_team );
	for (i = 0; i < players.size; i++)
	{
		//players[i] stoploopsound("zmb_double_point_loop", 2);
		players[i] playsound("zmb_points_loop_off");
	}
	temp_ent stoploopsound(2);


	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars[player_team]["zombie_powerup_double_points_time"] = 30;
	//level.zombie_timer_offset += level.zombie_timer_offset_interval;
	//self destroy();
	temp_ent delete();
}

//-------------------------------------------------------------------------------
//	DCS: Adding check if box is open to grab weapon when fire sale ends.
//-------------------------------------------------------------------------------
function fire_sale_weapon_wait()
{
	self.zombie_cost = self.old_cost;
	while( isdefined( self.chest_user ) )
	{
		util::wait_network_frame();
	}
	self zm_utility::set_hint_string( self , "default_treasure_chest", self.zombie_cost );	
}

function devil_dialog_delay()
{
	wait(1.0);
}

//*****************************************************************************
// Here we have a selection of special case rare powerups that may get dropped
// by the random powerup generator
//*****************************************************************************
function check_for_rare_drop_override( pos )
{
	if ( level flagsys::get( "ape_round") )
	{
		return( 0 );
	}

	return( 0 );
}

function tesla_powerup_active()
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i].zombie_vars[ "zombie_powerup_tesla_on" ] )
		{
			return true;
		}
	}
	
	return false;
}


//******************************************************************************
//
// DEBUG
//
function print_powerup_drop( powerup, type )
{
	/#
		if( !IsDefined( level.powerup_drop_time ) )
		{
			level.powerup_drop_time = 0;
			level.powerup_random_count = 0;
			level.powerup_score_count = 0;
		}

		time = ( GetTime() - level.powerup_drop_time ) * 0.001;
		level.powerup_drop_time = GetTime();

		if( type == "random" )
		{
			level.powerup_random_count++;
		}
		else
		{
			level.powerup_score_count++;
		}

		println( "========== POWER UP DROPPED ==========" );
		println( "DROPPED: " + powerup );
		println( "HOW IT DROPPED: " + type );
		println( "--------------------" );
		println( "Drop Time: " + time );
		println( "Random Powerup Count: " + level.powerup_random_count );
		println( "Random Powerup Count: " + level.powerup_score_count );
		println( "======================================" );
#/
}

function register_carpenter_node(node, callback)
{
	if(!isdefined(level._additional_carpenter_nodes))
	{
		level._additional_carpenter_nodes = [];
	}
	
	node._post_carpenter_callback = callback;
	
	level._additional_carpenter_nodes[level._additional_carpenter_nodes.size] = node;
}

//*****************************************************************************
// Boards are upgraded if the player that uses the carpenter has the upgrade
//*****************************************************************************

function is_carpenter_boards_upgraded()
{
	if( IsDefined(level.pers_carpenter_boards_active) && (level.pers_carpenter_boards_active == true) )
	{
		return( 1 );
	}
	return( 0 );
}



//*****************************************************************************
//*****************************************************************************

function func_should_never_drop()
{
	return false;
}

function func_should_always_drop()
{
	return true;
}

function powerup_move()
{
	self endon ("powerup_timedout");
	self endon ("powerup_grabbed");
	
	drag_speed = 75;
	while ( 1 )
	{
		self waittill("move_powerup", moveto, distance);
		drag_vector = moveto - self.origin;
		range_squared = LengthSquared(drag_vector); //DistanceSquared( self.origin, self.drag_target );
		if ( range_squared > distance * distance )
		{
			drag_vector = VectorNormalize( drag_vector );
			drag_vector = distance * drag_vector;
			moveto = self.origin + drag_vector;
		}
		self.origin = moveto;		
	}
}

function powerup_emp()
{
	self endon ("powerup_timedout");
	self endon ("powerup_grabbed");
	if (!zm_utility::should_watch_for_emp())
		return;
	while(1)
	{
		level waittill("emp_detonate",origin,radius);
		if ( DistanceSquared( origin, self.origin) < radius * radius )
		{
			PlayFX( level._effect[ "powerup_off" ], self.origin );
			self thread powerup_delete_delayed();
			self notify( "powerup_timedout" );
		}
	}
}

function get_powerups( origin, radius )
{
	if (isdefined(origin) && isdefined(radius))
	{
		powerups = [];
		foreach( powerup in level.active_powerups )
		{
			if ( DistanceSquared( origin, powerup.origin) < radius * radius )
			{
				powerups[powerups.size] = powerup;
			}
		}
		return powerups;
	}
    return level.active_powerups;
}

function should_award_stat( powerup_name )
{
	if ( powerup_name == "teller_withdrawl" || powerup_name == "blue_monkey" || powerup_name == "free_perk" || powerup_name == "bonus_points_player" )
	{
		return false;
	}
	
	if ( isdefined( level.statless_powerups ) && isdefined( level.statless_powerups[powerup_name] ) )
	{
		return false;
	}
	
	return true;
}

function teller_withdrawl(powerup,player)
{
	player zm_score::add_to_player_score( powerup.value);
}

//HUD powerup functions
function show_on_hud( player_team, str_powerup )
{
	self endon ("disconnect");
	
	str_index_on 	= "zombie_powerup_" + str_powerup + "_on";
	str_index_time 	= "zombie_powerup_" + str_powerup + "_time";

	// check to see if this is on or not
	if ( level.zombie_vars[player_team][str_index_on] )
	{
		// reset the time and keep going
		level.zombie_vars[player_team][str_index_time] = 30;
		return;
	}

	level.zombie_vars[player_team][str_index_on] = true;

	// set time remaining for powerup
	level thread time_remaining_on_powerup( player_team, str_powerup );
}

function time_remaining_on_powerup( player_team, str_powerup )
{	
	str_index_on 	= "zombie_powerup_" + str_powerup + "_on";
	str_index_time 	= "zombie_powerup_" + str_powerup + "_time";
	str_sound_loop 	= "zmb_" + str_powerup + "_loop";
	str_sound_off 	= "zmb_" + str_powerup + "_loop_off";
	
	temp_ent = Spawn("script_origin", (0,0,0));
	temp_ent PlayLoopSound (str_sound_loop);
	
	// time it down!
	while ( level.zombie_vars[player_team][str_index_time] >= 0)
	{
		{wait(.05);};
		level.zombie_vars[player_team][str_index_time] = level.zombie_vars[player_team][str_index_time] - 0.05;
	}

	// turn off the timer
	level.zombie_vars[player_team][str_index_on] = false;
	
	GetPlayers()[0] PlaySoundToTeam(str_sound_off, player_team);

	temp_ent StopLoopSound(2);

	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars[player_team][str_index_time] = 30;

	temp_ent delete();
}
////////End HUD powerup functions

//Special weapon powerup functions

function weapon_powerup( ent_player, time, str_weapon )
{
	str_weapon_on 			= "zombie_powerup_" + str_weapon + "_on";
	str_weapon_time_over 	= str_weapon + "_time_over";
	
	ent_player notify( "replace_weapon_powerup" );
	ent_player._show_solo_hud = true;
	
	ent_player.has_specific_powerup_weapon[ str_weapon ] = true;
	ent_player.has_powerup_weapon = true;
	
	ent_player zm_utility::increment_is_drinking();
	ent_player._zombie_weapon_before_powerup[ str_weapon ] = ent_player GetCurrentWeapon();
	
	// give player the powerup weapon
	ent_player GiveWeapon( level.zombie_powerup_weapon[ str_weapon ] );
	ent_player SwitchToWeapon( level.zombie_powerup_weapon[ str_weapon ] );
	
	ent_player.zombie_vars[ str_weapon_on ] = true;
	
	level thread weapon_powerup_countdown( ent_player, str_weapon_time_over, time, str_weapon );
	level thread weapon_powerup_replace( ent_player, str_weapon_time_over, str_weapon );
}

function weapon_powerup_countdown( ent_player, str_gun_return_notify, time, str_weapon )
{
	ent_player endon( "death" );
	ent_player endon( "disconnect" );
	ent_player endon( "player_downed" );
	ent_player endon( str_gun_return_notify );
	ent_player endon( "replace_weapon_powerup" );
	
	str_weapon_time = "zombie_powerup_" + str_weapon + "_time";
	
	//AUDIO: Starting powerup loop on ONLY this player
	util::setClientSysState( "levelNotify", "minis", ent_player );

	ent_player.zombie_vars[str_weapon_time] = time;
	
	[[level._custom_powerups[ str_weapon ].weapon_countdown]]( ent_player, str_weapon_time );
	
	//AUDIO: Ending powerup loop on ONLY this player
	util::setClientSysState( "levelNotify", "minie", ent_player );
	
	level thread weapon_powerup_remove( ent_player, str_gun_return_notify, str_weapon );	
}

function weapon_powerup_replace( ent_player, str_gun_return_notify, str_weapon )
{
	ent_player endon( "death" );
	ent_player endon( "disconnect" );
	ent_player endon( "player_downed" );
	ent_player endon( str_gun_return_notify );
	
	str_weapon_on 	= "zombie_powerup_" + str_weapon + "_on";

	ent_player waittill( "replace_weapon_powerup" );

	ent_player TakeWeapon( level.zombie_powerup_weapon[ str_weapon ] );
	
	ent_player.zombie_vars[ str_weapon_on ] = false;
	
	ent_player.has_specific_powerup_weapon[ str_weapon ] = false;
	ent_player.has_powerup_weapon = false;
	
	ent_player zm_utility::decrement_is_drinking();
}

function weapon_powerup_remove( ent_player, str_gun_return_notify, str_weapon )
{
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	
	str_weapon_on 	= "zombie_powerup_" + str_weapon + "_on";
	
	// take the minigun back
	ent_player TakeWeapon( level.zombie_powerup_weapon[ str_weapon ] );
	
	ent_player.zombie_vars[ str_weapon_on ] = false;
	ent_player._show_solo_hud = false;
	
	ent_player.has_specific_powerup_weapon[ str_weapon ] = false;
	ent_player.has_powerup_weapon = false;
	
	// this gives the player back their weapons
	ent_player notify( str_gun_return_notify );
	
	ent_player zm_utility::decrement_is_drinking();
	
	if( IsDefined( ent_player._zombie_weapon_before_powerup[ str_weapon ] ) )
	{
		player_weapons = ent_player GetWeaponsListPrimaries();
		for( i = 0; i < player_weapons.size; i++ )
		{
			if( player_weapons[i] == ent_player._zombie_weapon_before_powerup[ str_weapon ] )
			{
				ent_player SwitchToWeapon( ent_player._zombie_weapon_before_powerup[ str_weapon ] );
				return;
			}
		}
	}
	
	// if the player got through all that without getting a weapon back give them the first one
	primaryWeapons = ent_player GetWeaponsListPrimaries();
	if( primaryWeapons.size > 0 )
	{
		ent_player SwitchToWeapon( primaryWeapons[0] );
	}
	else
	{
		allWeapons = ent_player GetWeaponsList( true );
		for( i = 0; i < allWeapons.size; i++ )
		{
			if( zm_utility::is_melee_weapon( allWeapons[i] ) )
			{
				ent_player SwitchToWeapon( allWeapons[i] );
				return;
			}
		}
	}	
}

function weapon_watch_gunner_downed( str_weapon )
{
	str_notify 		= str_weapon + "_time_over";
	str_weapon_on 	= "zombie_powerup_" + str_weapon + "_on";
	
	if ( !( isdefined( self.has_specific_powerup_weapon[ str_weapon ] ) && self.has_specific_powerup_weapon[ str_weapon ] ) )
	{
		return;
	}

	primaryWeapons = self GetWeaponsListPrimaries();
	
	for( i = 0; i < primaryWeapons.size; i++ )
	{
		if( primaryWeapons[i] == level.zombie_powerup_weapon[ str_weapon ] )
		{
			self TakeWeapon( level.zombie_powerup_weapon[ str_weapon ] );
		}
	}

	// this gives the player back their weapons
	self notify( str_notify );
	self.zombie_vars[ str_weapon_on ] = false;
	self._show_solo_hud = false;

	// wait a frame to let last stand finish initializing so that
	// the wholethe system knows we went into last stand with a powerup weapon
	{wait(.05);};
	self.has_specific_powerup_weapon[ str_weapon ] = false;
	self.has_powerup_weapon = false;
}

//END special weapon powerup functions

/@
"Name: register_powerup( <str_powerup>, [func_grab_powerup], [func_setup] )"
"Module: Zombie Powerups"
"Summary: Registers functions to run when zombie perks are given to and taken from players."
"MandatoryArg: <str_powerup>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"OptionalArg: [func_grab_powerup]: this function will run when the player grabs the powerup."
"OptionalArg: [func_setup]: this function will in addition to normal powerup setup."	
"Example: register_powerup( "nuke", &grab_nuke );"
"SPMP: multiplayer"
@/
function register_powerup( str_powerup, func_grab_powerup, func_setup )
{
	Assert( IsDefined( str_powerup ), "str_powerup is a required argument for register_powerup!" );

	_register_undefined_powerup( str_powerup );
	
	if ( IsDefined( func_grab_powerup ) )
	{
		if ( !IsDefined( level._custom_powerups[ str_powerup ].grab_powerup ) )
		{
			level._custom_powerups[ str_powerup ].grab_powerup = func_grab_powerup;
		}
	}
	
	if ( IsDefined( func_setup ) )
	{
		if ( !IsDefined( level._custom_powerups[ str_powerup ].setup_powerup ) )
		{
			level._custom_powerups[ str_powerup ].setup_powerup = func_setup;
		}
	}	
}

// make sure powerup exists before we actually try to set fields on it. Does nothing if it exists already
function _register_undefined_powerup( str_powerup )
{
	if ( !IsDefined( level._custom_powerups ) )
	{
		level._custom_powerups = [];
	}
	
	if ( !IsDefined( level._custom_powerups[ str_powerup ] ) )
	{
		level._custom_powerups[ str_powerup ] = SpawnStruct();
		include_zombie_powerup( str_powerup );
	}	
}

/@
"Name: register_powerup_weapon( <str_powerup>, [func_grab_powerup], [func_setup] )"
"Module: Zombie Powerups"
"Summary: Registers functions to run when zombie perks are given to and taken from players."
"MandatoryArg: <str_powerup>: the name of the specialty that this perk uses. This should be unique, and will identify this perk in system scripts."
"OptionalArg: [func_countdown]: this function will run when the weapon powerup counts down."
"Example: register_powerup_weapon( "minigun", &minigun_countdown );"
"SPMP: multiplayer"
@/
function register_powerup_weapon( str_powerup, func_countdown )
{
	Assert( IsDefined( str_powerup ), "str_powerup is a required argument for register_powerup!" );

	_register_undefined_powerup( str_powerup );
	
	if ( IsDefined( func_countdown ) )
	{
		if ( !IsDefined( level._custom_powerups[ str_powerup ].weapon_countdown ) )
		{
			level._custom_powerups[ str_powerup ].weapon_countdown = func_countdown;
		}
	}
}
