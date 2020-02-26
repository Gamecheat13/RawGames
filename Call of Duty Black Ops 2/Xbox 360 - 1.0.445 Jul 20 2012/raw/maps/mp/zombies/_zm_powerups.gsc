#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

#insert raw\maps\mp\zombies\_zm_utility.gsh;

//
init()
{
	PrecacheShader( "specialty_doublepoints_zombies" );
	PrecacheShader( "specialty_instakill_zombies" );
	PrecacheShader( "specialty_firesale_zombies");
	PrecacheShader( "zom_icon_bonfire");
	PrecacheShader( "zom_icon_minigun");

	
	PrecacheShader( "black" ); 
	// powerup Vars
	set_zombie_var( "zombie_insta_kill", 				0 );
	set_zombie_var( "zombie_point_scalar", 				1 );
	set_zombie_var( "zombie_drop_item", 				0 );
	set_zombie_var( "zombie_timer_offset", 				350 );	// hud offsets
	set_zombie_var( "zombie_timer_offset_interval", 	30 );
	set_zombie_var( "zombie_powerup_fire_sale_on", 	false );
	set_zombie_var( "zombie_powerup_fire_sale_time", 30 );
	set_zombie_var( "zombie_powerup_bonfire_sale_on", 	false );
	set_zombie_var( "zombie_powerup_bonfire_sale_time", 30 );
	set_zombie_var( "zombie_powerup_insta_kill_on", 	false );
	set_zombie_var( "zombie_powerup_insta_kill_time", 	30 );	// length of insta kill
	set_zombie_var( "zombie_powerup_point_doubler_on", 	false );
	set_zombie_var( "zombie_powerup_point_doubler_time", 30 );	// length of point doubler
//	Modify by the percentage of points that the player gets
	set_zombie_var( "zombie_powerup_drop_increment", 	2000 );	// lower this to make drop happen more often
	set_zombie_var( "zombie_powerup_drop_max_per_round", 4 );	// raise this to make drop happen more often

	// special vars for individual power ups
	OnPlayerConnect_Callback(::init_player_zombie_vars);

	// powerups
	level._effect["powerup_on"] 					= loadfx( "misc/fx_zombie_powerup_on" );
	level._effect["powerup_grabbed"] 				= loadfx( "misc/fx_zombie_powerup_grab" );
	level._effect["powerup_grabbed_wave"] 			= loadfx( "misc/fx_zombie_powerup_wave" );
	level._effect["powerup_on_red"] 				= loadfx( "misc/fx_zombie_powerup_on_red" );
	level._effect["powerup_grabbed_red"] 			= loadfx( "misc/fx_zombie_powerup_red_grab" );
	level._effect["powerup_grabbed_wave_red"] 		= loadfx( "misc/fx_zombie_powerup_red_wave" );
	level._effect["powerup_on_solo"]				= LoadFX( "misc/fx_zombie_powerup_solo_on" );
	level._effect["powerup_grabbed_solo"]			= LoadFX( "misc/fx_zombie_powerup_solo_grab" );
	level._effect["powerup_grabbed_wave_solo"] 		= loadfx( "misc/fx_zombie_powerup_solo_wave" );
	level._effect["powerup_on_caution"]				= LoadFX( "misc/fx_zombie_powerup_caution_on" );
	level._effect["powerup_grabbed_caution"]		= LoadFX( "misc/fx_zombie_powerup_caution_grab" );
	level._effect["powerup_grabbed_wave_caution"] 	= loadfx( "misc/fx_zombie_powerup_caution_wave" );

	if( level.mutators["mutator_noPowerups"] )
	{
		return;
	}
	
	init_powerups();

	thread watch_for_drop();
	thread setup_firesale_audio();
	thread setup_bonfiresale_audio();
	
	level.use_new_carpenter_func = ::start_carpenter_new;
	level.board_repair_distance_squared = 750*750;
}


//
init_powerups()
{
	flag_init( "zombie_drop_powerups" );	// As long as it's set, powerups will be able to spawn
	flag_set( "zombie_drop_powerups" );

	if( !IsDefined( level.zombie_powerup_array ) )
	{
		level.zombie_powerup_array = [];
	}
	if ( !IsDefined( level.zombie_special_drop_array ) )
	{
		level.zombie_special_drop_array = [];
	}

	//Random Drops
	add_zombie_powerup( "nuke", 		"zombie_bomb",		&"ZOMBIE_POWERUP_NUKE",::func_should_always_drop, false, false, false, 			"misc/fx_zombie_mini_nuke_hotness" );
	add_zombie_powerup( "insta_kill", 	"zombie_skull",		&"ZOMBIE_POWERUP_INSTA_KILL",::func_should_always_drop, false, false, false );
	add_zombie_powerup( "full_ammo",  	"zombie_ammocan",	&"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_always_drop,false, false, false );
	add_zombie_powerup( "double_points","zombie_x2_icon",	&"ZOMBIE_POWERUP_DOUBLE_POINTS",::func_should_always_drop, false, false, false );

	if( !level.mutators["mutator_noBoards"] )
	{
		add_zombie_powerup( "carpenter",  	"zombie_carpenter",	&"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_drop_carpenter,false, false, false );
	}
	
	if( !level.mutators["mutator_noMagicBox"] )
	{
		add_zombie_powerup( "fire_sale",  	"zombie_firesale",	&"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_drop_fire_sale, false, false, false );
	}

	add_zombie_powerup( "bonfire_sale",  	"zombie_pickup_bonfire",	&"ZOMBIE_POWERUP_MAX_AMMO",::func_should_never_drop, false, false, false );
	add_zombie_powerup( "minigun",	"zombie_pickup_minigun", &"ZOMBIE_POWERUP_MINIGUN",::func_should_drop_minigun, true, false, false );
	add_zombie_powerup( "free_perk", "zombie_pickup_perk_bottle", &"ZOMBIE_POWERUP_FREE_PERK",::func_should_never_drop, false, false, false );

	add_zombie_powerup( "tesla", "zombie_pickup_minigun", &"ZOMBIE_POWERUP_MINIGUN",::func_should_never_drop, true, false, false ); 
	add_zombie_powerup( "random_weapon", "zombie_pickup_minigun", &"ZOMBIE_POWERUP_MAX_AMMO",::func_should_never_drop, true, false, false );
	add_zombie_powerup( "bonus_points_player", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS",::func_should_never_drop, true, false, false );
	add_zombie_powerup( "bonus_points_team", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS",::func_should_never_drop,false, false, false );
	add_zombie_powerup( "lose_points_team", "zombie_z_money_icon", &"ZOMBIE_POWERUP_LOSE_POINTS",::func_should_never_drop, false, false, true );
	add_zombie_powerup( "lose_perk", "zombie_pickup_perk_bottle", &"ZOMBIE_POWERUP_MAX_AMMO",::func_should_never_drop, false, false, true );
	add_zombie_powerup( "empty_clip", "zombie_ammocan", &"ZOMBIE_POWERUP_MAX_AMMO",::func_should_never_drop, false, false, true );

	//additional special "drops"
	//add_zombie_special_powerup( "monkey" );	
	//add_zombie_special_drop( "nothing" );
	//add_zombie_special_drop( "dog" );
	
	// Randomize the order
	randomize_powerups();
	level.zombie_powerup_index = 0;
	randomize_powerups();

	// Rare powerups
	level.rare_powerups_active = 0;
	
	//AUDIO: Prevents the long firesale vox from playing more than once
	level.firesale_vox_firstime = false;

	level thread powerup_hud_overlay();
	level thread solo_powerup_hud_overlay();

	if ( isdefined( level.quantum_bomb_register_result_func ) )
	{
		[[level.quantum_bomb_register_result_func]]( "random_powerup", ::quantum_bomb_random_powerup_result, 5, level.quantum_bomb_in_playable_area_validation_func );
		[[level.quantum_bomb_register_result_func]]( "random_zombie_grab_powerup", ::quantum_bomb_random_zombie_grab_powerup_result, 5, level.quantum_bomb_in_playable_area_validation_func );
		[[level.quantum_bomb_register_result_func]]( "random_weapon_powerup", ::quantum_bomb_random_weapon_powerup_result, 60, level.quantum_bomb_in_playable_area_validation_func );
		[[level.quantum_bomb_register_result_func]]( "random_bonus_or_lose_points_powerup", ::quantum_bomb_random_bonus_or_lose_points_powerup_result, 25, level.quantum_bomb_in_playable_area_validation_func );
	}
}  


//	Creates zombie_vars that need to be tracked on an individual basis rather than as
//	a group.
init_player_zombie_vars()
{
	self.zombie_vars[ "zombie_powerup_minigun_on" ] = false; // minigun
	self.zombie_vars[ "zombie_powerup_minigun_time" ] = 0;
		
	self.zombie_vars[ "zombie_powerup_tesla_on" ] = false; // tesla
	self.zombie_vars[ "zombie_powerup_tesla_time" ] = 0;
}


//
powerup_hud_overlay()
{
	level endon ("disconnect");

	level.powerup_hud_array = [];
	level.powerup_hud_array[0] = true;
	level.powerup_hud_array[1] = true;
	level.powerup_hud_array[2] = true;
	level.powerup_hud_array[3] = true;
	


	level.powerup_hud = [];
	level.powerup_hud_cover = [];



	for(i = 0; i < 4; i++)
	{
		level.powerup_hud[i] = create_simple_hud();
		level.powerup_hud[i].foreground = true; 
		level.powerup_hud[i].sort = 2; 
		level.powerup_hud[i].hidewheninmenu = false; 
		level.powerup_hud[i].alignX = "center"; 
		level.powerup_hud[i].alignY = "bottom";
		level.powerup_hud[i].horzAlign = "user_center"; 
		level.powerup_hud[i].vertAlign = "user_bottom";
		level.powerup_hud[i].x = -32 + (i * 15); 
		level.powerup_hud[i].y = level.powerup_hud[i].y - 5; // ww: used to offset by - 78
		level.powerup_hud[i].alpha = 0.8;
	}
	
	level thread Power_up_hud( "specialty_doublepoints_zombies", level.powerup_hud[0], -44, "zombie_powerup_point_doubler_time", "zombie_powerup_point_doubler_on" );
	level thread Power_up_hud( "specialty_instakill_zombies", level.powerup_hud[1], -04, "zombie_powerup_insta_kill_time", "zombie_powerup_insta_kill_on" );
	level thread Power_up_hud( "specialty_firesale_zombies", level.powerup_hud[2], 36, "zombie_powerup_fire_sale_time", "zombie_powerup_fire_sale_on" );	
	level thread Power_up_hud( "zom_icon_bonfire", level.powerup_hud[3], 116, "zombie_powerup_bonfire_sale_time", "zombie_powerup_bonfire_sale_on" );	
	
}


//
Power_up_hud( Shader, PowerUp_Hud, X_Position, PowerUp_timer, PowerUp_Var )
{

	while(true)
	{
		
		if(isDefined(level.current_game_module) && level.current_game_module == 2) // race mode has no global powerup drops for now
		{
			if(PowerUp_Hud.alpha != 0)
			{
				wait(.1);
				PowerUp_Hud.alpha = 0;
				return;
			}
		}
		
		if(level.zombie_vars[PowerUp_timer] < 5)
		{
			wait(0.1);		
			PowerUp_Hud.alpha = 0;
			wait(0.1);
		}
		else if(level.zombie_vars[PowerUp_timer] < 10)
		{
			wait(0.2);
			PowerUp_Hud.alpha = 0;
			wait(0.18);

		}

		if( level.zombie_vars[PowerUp_Var] == true )
		{
			PowerUp_Hud.x = X_Position;
			PowerUp_Hud.alpha = 1;
			PowerUp_Hud setshader(Shader, 32, 32);
		}
		else
		{
			PowerUp_Hud.alpha = 0;
		}

		wait( 0.05 );
	}
}


//** solo hud
solo_powerup_hud_overlay()
{
	level endon ("disconnect");
	
	flag_wait( "start_zombie_round_logic" );
	wait( 0.1 );  // wait for solo zombie_vars to be initialized in init_player_zombie_vars

	players = GET_PLAYERS();
	for( p = 0; p < players.size; p++ )
	{
		players[p].solo_powerup_hud_array = [];
		players[p].solo_powerup_hud_array[ players[p].solo_powerup_hud_array.size ] = true; // minigun
		players[p].solo_powerup_hud_array[ players[p].solo_powerup_hud_array.size ] = true; // tesla
	
		players[p].solo_powerup_hud = [];
		players[p].solo_powerup_hud_cover = [];
	
		for(i = 0; i < players[p].solo_powerup_hud_array.size; i++)
		{
			players[p].solo_powerup_hud[i] = create_simple_hud( players[p] );
			players[p].solo_powerup_hud[i].foreground = true; 
			players[p].solo_powerup_hud[i].sort = 2; 
			players[p].solo_powerup_hud[i].hidewheninmenu = false; 
			players[p].solo_powerup_hud[i].alignX = "center"; 
			players[p].solo_powerup_hud[i].alignY = "bottom";
			players[p].solo_powerup_hud[i].horzAlign = "user_center"; 
			players[p].solo_powerup_hud[i].vertAlign = "user_bottom";
			players[p].solo_powerup_hud[i].x = -32 + (i * 15); 
			players[p].solo_powerup_hud[i].y = players[p].solo_powerup_hud[i].y - 5; // ww: used to offset by - 78
			players[p].solo_powerup_hud[i].alpha = 0.8;
		}

		players[p] thread solo_power_up_hud( "zom_icon_minigun", players[p].solo_powerup_hud[0], 76, "zombie_powerup_minigun_time", "zombie_powerup_minigun_on" );
		// the weapon powerups are mutually exclusive, so we use the same screen position
		players[p] thread solo_power_up_hud( "zom_icon_minigun", players[p].solo_powerup_hud[1], 76, "zombie_powerup_tesla_time", "zombie_powerup_tesla_on" );
	}
}


// 
solo_power_up_hud( Shader, PowerUp_Hud, X_Position, PowerUp_timer, PowerUp_Var )
{
	self endon( "disconnect" );
	
	while(true)
	{
		if(self.zombie_vars[PowerUp_timer] < 5 && 
				( IsDefined( self._show_solo_hud ) && self._show_solo_hud == true ) )
		{
			wait(0.1);		
			PowerUp_Hud.alpha = 0;
			wait(0.1);
		}
		else if(self.zombie_vars[PowerUp_timer] < 10 && 
						( IsDefined( self._show_solo_hud ) && self._show_solo_hud == true ) )
		{
			wait(0.2);
			PowerUp_Hud.alpha = 0;
			wait(0.18);

		}

		if( self.zombie_vars[PowerUp_Var] == true && 
				( IsDefined( self._show_solo_hud ) && self._show_solo_hud == true ) )
		{
			PowerUp_Hud.x = X_Position;
			PowerUp_Hud.alpha = 1;
			PowerUp_Hud setshader(Shader, 32, 32);
		}
		else
		{
			PowerUp_Hud.alpha = 0;
		}

		wait( 0.05 );
	}
}
//** solo hud


randomize_powerups()
{
	level.zombie_powerup_array = array_randomize( level.zombie_powerup_array );
}

//
// Get the next powerup in the list
//
get_next_powerup()
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
get_valid_powerup()
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

minigun_no_drop()
{
	players = GET_PLAYERS();
	for ( i=0; i<players.size; i++ )
	{
		if( players[i].zombie_vars[ "zombie_powerup_minigun_on" ] == true )
		{
			return true;
		}
	}

	if( !flag( "power_on" ) ) // if power is not on check for solo
	{
		if( flag( "solo_game" ) ) // if it is a solo game then perform another check
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
		


get_num_window_destroyed()
{
	num = 0;
	for( i = 0; i < level.exterior_goals.size; i++ )
	{
		/*targets = getentarray(level.exterior_goals[i].target, "targetname");

		barrier_chunks = []; 
		for( j = 0; j < targets.size; j++ )
		{
			if( IsDefined( targets[j].script_noteworthy ) )
			{
				if( targets[j].script_noteworthy == "clip" )
				{ 
					continue; 
				}
			}

			barrier_chunks[barrier_chunks.size] = targets[j];
		}*/


		if( all_chunks_destroyed( level.exterior_goals[i], level.exterior_goals[i].barrier_chunks ) )
		{
			num += 1;
		}

	}

	return num;
}

watch_for_drop()
{
	flag_wait( "start_zombie_round_logic" );
	flag_wait( "begin_spawning" );

	players = GET_PLAYERS();
	score_to_drop = ( players.size * level.zombie_vars["zombie_score_start_"+players.size+"p"] ) + level.zombie_vars["zombie_powerup_drop_increment"];

	while (1)
	{
		flag_wait( "zombie_drop_powerups" );

		players = GET_PLAYERS();

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

add_zombie_powerup( powerup_name, model_name, hint, func_should_drop_with_regular_powerups, solo, caution, zombie_grabbable, fx )
{
	if( IsDefined( level.zombie_include_powerups ) && !IsDefined( level.zombie_include_powerups[powerup_name] ) )
	{
		return;
	}

	PrecacheModel( model_name );
	PrecacheString( hint );

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
	struct.solo = solo;
	struct.caution = caution;
	struct.zombie_grabbable = zombie_grabbable;

	if( IsDefined( fx ) )
	{
		struct.fx = LoadFx( fx );
	}

	level.zombie_powerups[powerup_name] = struct;
	level.zombie_powerup_array[level.zombie_powerup_array.size] = powerup_name;
	add_zombie_special_drop( powerup_name );
}


// special powerup list for the teleporter drop
add_zombie_special_drop( powerup_name )
{
	level.zombie_special_drop_array[ level.zombie_special_drop_array.size ] = powerup_name;
}

include_zombie_powerup( powerup_name )
{
	if( "1" == GetDvar( "mutator_noPowerups") )
	{
		return;
	}
	if( !IsDefined( level.zombie_include_powerups ) )
	{
		level.zombie_include_powerups = [];
	}

	level.zombie_include_powerups[powerup_name] = true;
}

powerup_round_start()
{
	level.powerup_drop_count = 0;
}

powerup_drop(drop_point)
{
	if( level.mutators["mutator_noPowerups"] )
	{
		return;
	}
		
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

	powerup = maps\mp\zombies\_zm_net::network_safe_spawn( "powerup", 1, "script_model", drop_point + (0,0,40));
	
	//chris_p - fixed bug where you could not have more than 1 playable area trigger for the whole map
	valid_drop = false;
	for (i = 0; i < playable_area.size; i++)
	{
		if (powerup istouching(playable_area[i]))
		{
			valid_drop = true;
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

	level.zombie_vars["zombie_drop_item"] = 0;

	// RAVEN BEGIN bhackbarth: let the level know that a powerup has been dropped
	level notify("powerup_dropped", powerup);
	// RAVEN END
}


//
//	Drop the specified powerup
specific_powerup_drop( powerup_name, drop_spot, powerup_team, powerup_location )
{
	powerup = maps\mp\zombies\_zm_net::network_safe_spawn( "powerup", 1, "script_model", drop_spot + (0,0,40));

	level notify("powerup_dropped", powerup);

	if ( IsDefined(powerup) )
	{
		powerup powerup_setup( powerup_name,powerup_team, powerup_location );

		powerup thread powerup_timeout();
		powerup thread powerup_wobble();
		powerup thread powerup_grab(powerup_team);
		return powerup;
	}
}


quantum_bomb_random_powerup_result( position )
{
	if( !isDefined( level.zombie_include_powerups ) || !level.zombie_include_powerups.size )
	{
		return;
	}

	keys = GetArrayKeys( level.zombie_include_powerups );
	while ( keys.size )
	{
		index = RandomInt( keys.size );
		if ( !level.zombie_powerups[keys[index]].zombie_grabbable )
		{
			skip = false;
			switch ( keys[index] )
			{
			case "random_weapon":
			case "bonus_points_player":
			case "bonus_points_team":
				// skip these period
				skip = true;
				break;

			case "full_ammo":
			case "insta_kill":
			case "fire_sale":
			case "minigun":
				if ( RandomInt( 4 ) ) // only 25% chance of getting one of these
				{
					skip = true;
				}
				break;

			case "bonfire_sale":
			case "free_perk":
			case "tesla":
				if ( RandomInt( 20 ) ) // only 5% chance of getting one of these
				{
					skip = true;
				}
				break;

			default: // go ahead and use this one
			}

			if ( skip )
			{
				ArrayRemoveValue( keys, keys[index] );
				continue;
			}
			
			self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_good" );
			[[level.quantum_bomb_play_player_effect_at_position_func]]( position );
			level specific_powerup_drop( keys[index], position );
			return;
		}
		else
		{
			ArrayRemoveValue( keys, keys[index] );
		}
	}
}


quantum_bomb_random_zombie_grab_powerup_result( position )
{
	if( !isDefined( level.zombie_include_powerups ) || !level.zombie_include_powerups.size )
	{
		return;
	}

	keys = GetArrayKeys( level.zombie_include_powerups );
	while ( keys.size )
	{
		index = RandomInt( keys.size );
		if ( level.zombie_powerups[keys[index]].zombie_grabbable )
		{
			self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_bad" );
			[[level.quantum_bomb_play_player_effect_at_position_func]]( position );
			level specific_powerup_drop( keys[index], position );
			return;
		}
		else
		{
			ArrayRemoveValue( keys, keys[index] );
		}
	}
}


quantum_bomb_random_weapon_powerup_result( position )
{
	self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_good" );
	
	[[level.quantum_bomb_play_player_effect_at_position_func]]( position );
	level specific_powerup_drop( "random_weapon", position );
}


quantum_bomb_random_bonus_or_lose_points_powerup_result( position )
{
	rand = RandomInt( 10 );
	powerup = "bonus_points_team";
	switch ( rand )
	{
	case 0:
	case 1:
		powerup = "lose_points_team";
		if ( IsDefined( level.zombie_include_powerups[powerup] ) )
		{
			self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_bad" );
			break;
		}
	case 2:
	case 3:
	case 4:
		powerup = "bonus_points_player";
		if ( IsDefined( level.zombie_include_powerups[powerup] ) )
		{
			break;
		}
	default:
		powerup = "bonus_points_team";
		break;
	}

	[[level.quantum_bomb_play_player_effect_at_position_func]]( position );
	level specific_powerup_drop( powerup, position );
}


//
//	Special power up drop - done outside of the powerup system.
special_powerup_drop(drop_point)
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


cleanup_random_weapon_list()
{
	self waittill( "death" );

	ArrayRemoveValue( level.random_weapon_powerups, self );
}


//
//	Pick the next powerup in the list
powerup_setup( powerup_override,powerup_team, powerup_location )
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

	if ( powerup == "random_weapon" )
	{
		// select the weapon for this instance of random_weapon
		self.weapon = maps\mp\zombies\_zm_magicbox::treasure_chest_ChooseWeightedRandomWeapon();

/#
		weapon = GetDvar( "scr_force_weapon" );
		if ( weapon != "" && IsDefined( level.zombie_weapons[ weapon ] ) )
		{
			self.weapon = weapon;
			SetDvar( "scr_force_weapon", "" );
		}
#/

		self.base_weapon = self.weapon;
		if ( !isdefined( level.random_weapon_powerups ) )
		{
			level.random_weapon_powerups = [];
		}
		level.random_weapon_powerups[level.random_weapon_powerups.size] = self;
		self thread cleanup_random_weapon_list();

		if ( IsDefined( level.zombie_weapons[self.weapon].upgrade_name ) && !RandomInt( 4 ) ) // 25% chance
		{
			self.weapon = level.zombie_weapons[self.weapon].upgrade_name;
		}

		self SetModel( GetWeaponModel( self.weapon ) );
		self useweaponhidetags( self.weapon );

		offsetdw = ( 3, 3, 3 );
		self.worldgundw = undefined;
		if ( maps\mp\zombies\_zm_magicbox::weapon_is_dual_wield( self.weapon ) )
		{
			self.worldgundw = spawn( "script_model", self.origin + offsetdw );
			self.worldgundw.angles  = self.angles;
			self.worldgundw setModel( maps\mp\zombies\_zm_magicbox::get_left_hand_weapon_model_name( self.weapon ) );
			self.worldgundw useweaponhidetags( self.weapon );
			self.worldgundw LinkTo( self, "tag_weapon", offsetdw, (0, 0, 0) );
		}
	}
	else
	{
		self SetModel( struct.model_name );
	}

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
	self.powerup_name 		= struct.powerup_name;
	self.hint 				= struct.hint;
	self.solo 				= struct.solo;
	self.caution 			= struct.caution;
	self.zombie_grabbable 	= struct.zombie_grabbable;
	self.func_should_drop_with_regular_powerups = struct.func_should_drop_with_regular_powerups;

	if( IsDefined( struct.fx ) )
	{
		self.fx = struct.fx;
	}

	self PlayLoopSound("zmb_spawn_powerup_loop");
}


//
//	Get the special teleporter drop
special_drop_setup()
{
	powerup = undefined;
	is_powerup = true;
	// Always give something at lower rounds or if a player is in last stand mode.
	if ( level.round_number <= 10 )
	{
		powerup = get_valid_powerup();
	}
	// Gets harder now
	else
	{
		powerup = level.zombie_special_drop_array[ RandomInt(level.zombie_special_drop_array.size) ];
		if ( level.round_number > 15 &&
			 ( RandomInt(100) < (level.round_number - 15)*5 ) )
		{
			powerup = "nothing";
		}
	}
	//MM test  Change this if you want the same thing to keep spawning
//	powerup = "dog";
	switch ( powerup )
	{
	// Don't need to do anything special
	case "nuke":
	case "insta_kill":
	case "double_points":
	case "carpenter":
	case "fire_sale":
	case "bonfire_sale":
	case "all_revive":
	case "minigun":
	case "free_perk":
	case "tesla":
	case "random_weapon":
	case "bonus_points_player":
	case "bonus_points_team":
	case "lose_points_team":
	case "lose_perk":
	case "empty_clip":
		break;

	// Limit max ammo drops because it's too powerful
	case "full_ammo":
		if ( level.round_number > 10 &&
			 ( RandomInt(100) < (level.round_number - 10)*5 ) )
		{
			// Randomly pick another one
			powerup = level.zombie_powerup_array[ RandomInt(level.zombie_powerup_array.size) ];
		}
		break;

	case "dog":
		if ( level.round_number >= 15 )
		{
			is_powerup = false;
			dog_spawners = GetEntArray( "special_dog_spawner", "targetname" );
//Z2	comment out for now so we don't need to include _zombiemode_dogs
//			maps\mp\zombies\_zm_dogs::special_dog_spawn( dog_spawners, 1 );
			//iprintlnbold( "Samantha Sez: No Powerup For You!" );
			thread play_sound_2d( "sam_nospawn" );
		}
		else
		{
			powerup = get_valid_powerup();
		}
		break;

	// Nothing drops!!
	default:	// "nothing"

		// RAVEN BEGIN bhackbarth: callback for level specific powerups
		if ( IsDefined( level._zombiemode_special_drop_setup ) )
		{
			is_powerup = [[ level._zombiemode_special_drop_setup ]]( powerup );
		}
		// RAVEN END
		else
		{
			is_powerup = false;
			Playfx( level._effect["lightning_dog_spawn"], self.origin );
			playsoundatposition( "pre_spawn", self.origin );
			wait( 1.5 );
			playsoundatposition( "zmb_bolt", self.origin );

			Earthquake( 0.5, 0.75, self.origin, 1000);
			PlayRumbleOnPosition("explosion_generic", self.origin);
			playsoundatposition( "spawn", self.origin );

			wait( 1.0 );
			//iprintlnbold( "Samantha Sez: No Powerup For You!" );
			thread play_sound_2d( "sam_nospawn" );
			self Delete();
		}
	}

	if ( is_powerup )
	{
		Playfx( level._effect["lightning_dog_spawn"], self.origin );
		playsoundatposition( "pre_spawn", self.origin );
		wait( 1.5 );
		playsoundatposition( "zmb_bolt", self.origin );

		Earthquake( 0.5, 0.75, self.origin, 1000);
		PlayRumbleOnPosition("explosion_generic", self.origin);
		playsoundatposition( "spawn", self.origin );

//		wait( 0.5 );

		self powerup_setup( powerup );

		self thread powerup_timeout();
		self thread powerup_wobble();
		self thread powerup_grab();
	}
}

powerup_zombie_grab_trigger_cleanup( trigger )
{
	self waittill_any( "powerup_timedout", "powerup_grabbed", "hacked" );

	trigger delete();
}

powerup_zombie_grab(powerup_team)
{
	self endon( "powerup_timedout" );
	self endon( "powerup_grabbed" );
	self endon( "hacked" );
	
	spawnflags = 1; // SF_TOUCH_AI_AXIS
	zombie_grab_trigger = spawn( "trigger_radius", self.origin - (0,0,40), spawnflags, 32, 72 );
	zombie_grab_trigger enablelinkto();
	zombie_grab_trigger linkto( self );
	
	self thread powerup_zombie_grab_trigger_cleanup( zombie_grab_trigger );
	poi_dist = 300;
	if(isDefined(level._zombie_grabbable_poi_distance_override))
	{
		poi_dist = level._zombie_grabbable_poi_distance_override;
	}
	zombie_grab_trigger create_zombie_point_of_interest( poi_dist, 2, 0, true,undefined,undefined,powerup_team );

	while ( isdefined( self ) )
	{
		zombie_grab_trigger waittill( "trigger", who );
		if ( !isdefined( who ) || !IsAI( who ) )
		{
			continue;
		}

		playfx( level._effect["powerup_grabbed_red"], self.origin );	
		playfx( level._effect["powerup_grabbed_wave_red"], self.origin );	

		switch ( self.powerup_name )
		{
		case "lose_points_team":
			level thread lose_points_team_powerup( self );
			
			players = GET_PLAYERS();
			players[randomintrange(0,players.size)] thread powerup_vo( "lose_points" ); // TODO: Audio should uncomment this once the sounds have been set up
			break;

		case "lose_perk":
			level thread lose_perk_powerup( self );
			
//			players = GET_PLAYERS();
//			players[randomintrange(0,players.size)] thread powerup_vo( "lose_perk" ); // TODO: Audio should uncomment this once the sounds have been set up
			break;

		case "empty_clip":
			level thread empty_clip_powerup( self );
			
//			players = GET_PLAYERS();
//			players[randomintrange(0,players.size)] thread powerup_vo( "empty_clip" ); // TODO: Audio should uncomment this once the sounds have been set up
			break;

		default:
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
			
			break;
		}

		level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( "powerup", self.powerup_name );

		wait( 0.1 );

		playsoundatposition( "zmb_powerup_grabbed", self.origin );
		self stoploopsound();

		self powerup_delete();
		self notify( "powerup_grabbed" );
	}
}

powerup_grab(powerup_team)
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
		players = GET_PLAYERS();

		for (i = 0; i < players.size; i++)
		{
			// Don't let them grab the minigun, tesla, or random weapon if they're downed or reviving
			//	due to weapon switching issues.
			if ( (self.powerup_name == "minigun" || self.powerup_name == "tesla" || self.powerup_name == "random_weapon") && 
				( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() ||
				  ( players[i] UseButtonPressed() && players[i] in_revive_trigger() ) ) )
			{
				continue;
			}
			
			if ( DistanceSquared( players[i].origin, self.origin ) < range_squared )
			{
				if( IsDefined( level.zombie_powerup_grab_func ) )
				{
					level thread [[level.zombie_powerup_grab_func]]();
				}
				else
				{
					switch (self.powerup_name)
					{
					case "nuke":
						level thread nuke_powerup( self );
						
						//chrisp - adding powerup VO sounds
						players[i] thread powerup_vo("nuke");
						zombies = getaiarray("axis");
						players[i].zombie_nuked = get_array_of_closest( self.origin, zombies );
						players[i] notify("nuke_triggered");
						
						break;
					case "full_ammo":
						level thread full_ammo_powerup( self ,players[i] );
						players[i] thread powerup_vo("full_ammo");
						break;
					case "double_points":
						level thread double_points_powerup( self, players[i] );
						players[i] thread powerup_vo("double_points");
						break;
					case "insta_kill":
						level thread insta_kill_powerup( self,players[i] );
						players[i] thread powerup_vo("insta_kill");
						break;
					case "carpenter":
						if(isDefined(level.use_new_carpenter_func))
						{
							level thread [[level.use_new_carpenter_func]](self.origin);
						}
						else
						{
							level thread start_carpenter( self.origin );
						}
						players[i] thread powerup_vo("carpenter");
						break;

					case "fire_sale":
						level thread start_fire_sale( self );
						players[i] thread powerup_vo("firesale");
						break;
						
					case "bonfire_sale":
						level thread start_bonfire_sale( self );
						players[i] thread powerup_vo("firesale");
						break;
						
					case "minigun":
						level thread minigun_weapon_powerup( players[i] );
						players[i] thread powerup_vo( "minigun" );
						break;

					case "free_perk":
						level thread free_perk_powerup( self );
						//players[i] thread powerup_vo( "insta_kill" );
						break;
						
					case "tesla":
						level thread tesla_weapon_powerup( players[i] );
						players[i] thread powerup_vo( "tesla" ); // TODO: Audio should uncomment this once the sounds have been set up
						break;

					case "random_weapon":
						if ( !level random_weapon_powerup( self, players[i] ) )
						{
							continue;
						}
						// players[i] thread powerup_vo( "random_weapon" ); // TODO: Audio should uncomment this once the sounds have been set up
						break;

					case "bonus_points_player":
						level thread bonus_points_player_powerup( self, players[i] );
						players[i] thread powerup_vo( "bonus_points_solo" ); // TODO: Audio should uncomment this once the sounds have been set up
						break;

					case "bonus_points_team":
						level thread bonus_points_team_powerup( self );
						players[i] thread powerup_vo( "bonus_points_team" ); // TODO: Audio should uncomment this once the sounds have been set up
						break;

					default:
						// RAVEN BEGIN bhackbarth: callback for level specific powerups
						if ( IsDefined( level._zombiemode_powerup_grab ) )
						{
							level thread [[ level._zombiemode_powerup_grab ]]( self );
						}
						// RAVEN END
						else
						{
						/#	println ("Unrecognized poweup.");	#/
						}

						break;

					}
				}
				
				if ( self.solo )
				{
					playfx( level._effect["powerup_grabbed_solo"], self.origin );
					playfx( level._effect["powerup_grabbed_wave_solo"], self.origin );
				}
				else if ( self.caution )
				{
					playfx( level._effect["powerup_grabbed_caution"], self.origin );
					playfx( level._effect["powerup_grabbed_wave_caution"], self.origin );
				}
				else
				{
					playfx( level._effect["powerup_grabbed"], self.origin );
					playfx( level._effect["powerup_grabbed_wave"], self.origin );
				}

				if ( is_true( self.stolen ) )
				{
					level notify( "monkey_see_monkey_dont_achieved" );
				}

				// RAVEN BEGIN bhackbarth: since there is a wait here, flag the powerup as being taken 
				self.claimed = true;
				self.power_up_grab_player = players[i]; //Player who grabbed the power up
				// RAVEN END

				wait( 0.1 );
				
				playsoundatposition("zmb_powerup_grabbed", self.origin);
				self stoploopsound();
				
				//Preventing the line from playing AGAIN if fire sale becomes active before it runs out
				if( self.powerup_name != "fire_sale" )
				{
				    level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( "powerup", self.powerup_name );
				}

				self powerup_delete();
				self notify ("powerup_grabbed");
			}
		}
		wait 0.1;
	}	
}

start_fire_sale( item )
{

	level notify ("powerup fire sale");
	level endon ("powerup fire sale");
	
	level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( "powerup", "fire_sale_short" );
    
	level.zombie_vars["zombie_powerup_fire_sale_on"] = true;
	level thread toggle_fire_sale_on();
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 30;

	while ( level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
	{
		wait(0.1);
		level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] - 0.1;
	}

	level.zombie_vars["zombie_powerup_fire_sale_on"] = false;
	level notify ( "fire_sale_off" );
	
}

 
start_bonfire_sale( item )
{

	level notify ("powerup bonfire sale");
	level endon ("powerup bonfire sale");
	
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent playloopsound ("zmb_double_point_loop");

	level.zombie_vars["zombie_powerup_bonfire_sale_on"] = true;
	level thread toggle_bonfire_sale_on();
	level.zombie_vars["zombie_powerup_bonfire_sale_time"] = 30;

	while ( level.zombie_vars["zombie_powerup_bonfire_sale_time"] > 0)
	{
		wait(0.1);
		level.zombie_vars["zombie_powerup_bonfire_sale_time"] = level.zombie_vars["zombie_powerup_bonfire_sale_time"] - 0.1;
	}

	level.zombie_vars["zombie_powerup_bonfire_sale_on"] = false;
	level notify ( "bonfire_sale_off" );
	
	players = GET_PLAYERS();
	for (i = 0; i < players.size; i++)
	{
		players[i] playsound("zmb_points_loop_off");
	}
	
	temp_ent Delete();
}

 
start_carpenter( origin )
{

	//level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( level.devil_vox["powerup"]["carpenter"] );
	window_boards = getstructarray( "exterior_goal", "targetname" ); 
	total = level.exterior_goals.size;
	
	//COLLIN
	carp_ent = spawn("script_origin", (0,0,0));
	carp_ent playloopsound( "evt_carpenter" );
	
	while(true)
	{
		windows = get_closest_window_repair(window_boards, origin);
		if( !IsDefined( windows ) )
		{
			carp_ent stoploopsound( 1 );
			carp_ent PlaySoundWithNotify( "evt_carpenter_end", "sound_done" );
			carp_ent waittill( "sound_done" );
			break;
		}
		
		else
			ArrayRemoveValue(window_boards, windows);


		while(1)
		{
			if( all_chunks_intact( windows, windows.barrier_chunks ) )
			{
				break;
			}

			chunk = get_random_destroyed_chunk( windows, windows.barrier_chunks ); 

			if( !IsDefined( chunk ) )
				break;

			windows thread maps\mp\zombies\_zm_blockers::replace_chunk( windows, chunk, undefined, false, true );
			
			if(isdefined(windows.clip))
			{
				windows.clip enable_trigger(); 
				windows.clip DisconnectPaths();
			}
			else
			{
				blocker_disconnect_paths(windows.neg_start, windows.neg_end);
			}				
			wait_network_frame();
			wait(0.05);
		}
		 
		wait_network_frame();
	}
	
	players = GET_PLAYERS();
	for(i = 0; i < players.size; i++)
	{
		players[i] maps\mp\zombies\_zm_score::player_add_points( "carpenter_powerup", 200 ); 
	}
	
	carp_ent delete();
	
}



get_closest_window_repair( windows, origin )
{
	current_window = undefined;
	shortest_distance = undefined;
	for( i = 0; i < windows.size; i++ )
	{
		if( all_chunks_intact(windows, windows[i].barrier_chunks ) )
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
powerup_vo( type )
{
	self endon("death");
	self endon("disconnect");
	
	wait(randomfloatrange(4.5,5.5));
    
    if( type == "tesla" )
    {
        self maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", type );
    }
    else
    {
	    self maps\mp\zombies\_zm_audio::create_and_play_dialog( "powerup", type );
	}
}

powerup_wobble_fx()
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

	wait( 0.1 ); // must wait a bit because of the bug where a new entity has its events ignored on the client side

	if ( self.solo )
	{
		playfxontag( level._effect["powerup_on_solo"], self, "tag_origin" );
	}
	else if ( self.caution )
	{
		playfxontag( level._effect["powerup_on_caution"], self, "tag_origin" );
	}
	else if ( self.zombie_grabbable )
	{
		PlayFXOnTag( level._effect[ "powerup_on_red" ], self, "tag_origin" );
	}
	else
	{
		playfxontag( level._effect["powerup_on"], self, "tag_origin" );
	}
}

powerup_wobble()
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

powerup_timeout()
{
	if(isDefined(level._powerup_timeout_override)&& !isDefined(self.powerup_team))
	{
		self thread [[level._powerup_timeout_override]]();
		return;
	}
	self endon( "powerup_grabbed" );
	self endon( "death" );

	wait 15;

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


powerup_delete()
{
	if ( isdefined( self.worldgundw ) )
	{
		self.worldgundw delete();
	}
	self delete();
}

// kill them all!
nuke_powerup( drop_item )
{
	location = drop_item.origin;

	PlayFx( drop_item.fx, location );
	level thread nuke_flash();

	wait( 0.5 );

	
	zombies = getaispeciesarray("axis");
	zombies = get_array_of_closest( location, zombies );
	zombies_nuked = [];

	// Mark them for death
	for (i = 0; i < zombies.size; i++)
	{
		// unaffected by nuke
		if ( is_true( zombies[i].ignore_nuke ) )
		{
			continue;
		}

		// already going to die
		if ( IsDefined(zombies[i].marked_for_death) && zombies[i].marked_for_death )
		{
			continue;
		}

		// check for custom damage func
		if ( IsDefined(zombies[i].nuke_damage_func) )
		{
 			zombies[i] thread [[ zombies[i].nuke_damage_func ]]();
			continue;
		}
		
		if( is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			continue;
		}

		zombies[i].marked_for_death = true;
		zombies[i].nuked = true;
		zombies_nuked[ zombies_nuked.size ] = zombies[i];
	}

 	for (i = 0; i < zombies_nuked.size; i++)
  	{
 		wait (randomfloatrange(0.1, 0.7));
 		if( !IsDefined( zombies_nuked[i] ) )
 		{
 			continue;
 		}
 
 		if( is_magic_bullet_shield_enabled( zombies_nuked[i] ) )
 		{
 			continue;
 		}
 
		if( i < 5 && !( zombies_nuked[i].isdog ) )
		{
			zombies_nuked[i] thread maps\mp\animscripts\zm_death::flame_death_fx();
		}
 
 		if( !( zombies_nuked[i].isdog ) )
 		{
			if ( !is_true( zombies_nuked[i].no_gib ) )
			{
	 			zombies_nuked[i] maps\mp\zombies\_zm_spawner::zombie_head_gib();
	 		}
 			zombies_nuked[i] playsound ("evt_nuked");
 		}
 		
 
 		zombies_nuked[i] dodamage( zombies_nuked[i].health + 666, zombies_nuked[i].origin );
 	}

	players = GET_PLAYERS();
	for(i = 0; i < players.size; i++)
	{
		players[i] maps\mp\zombies\_zm_score::player_add_points( "nuke_powerup", 400 ); 
	}
}

nuke_flash()
{
	players = GET_PLAYERS();	
	for(i=0; i<players.size; i ++)
	{
		players[i] play_sound_2d("evt_nuke_flash");
	}
	level thread devil_dialog_delay();
	
	
	fadetowhite = newhudelem();

	fadetowhite.x = 0; 
	fadetowhite.y = 0; 
	fadetowhite.alpha = 0; 

	fadetowhite.horzAlign = "fullscreen"; 
	fadetowhite.vertAlign = "fullscreen"; 
	fadetowhite.foreground = true; 
	fadetowhite SetShader( "white", 640, 480 ); 

	// Fade into white
	fadetowhite FadeOverTime( 0.2 ); 
	fadetowhite.alpha = 0.8; 

	wait 0.5;
	fadetowhite FadeOverTime( 1.0 ); 
	fadetowhite.alpha = 0; 

	wait 1.1;
	fadetowhite destroy();
}


// double the points
double_points_powerup( drop_item , player )
{
	level notify ("powerup points scaled");
	level endon ("powerup points scaled");

	//	players = GET_PLAYERS();	
	//	array_thread(level,::point_doubler_on_hud, drop_item);
	level thread point_doubler_on_hud( drop_item );
	
	if(isDefined(level.current_game_module) && level.current_game_module == 2 ) //race
	{
		if(isDefined(player._race_team))
		{
			if(player._race_team == 1)
			{
				level._race_team_double_points = 1;
			}
			else
			{
				level._race_team_double_points = 2;
			}
		}
	}
	
	level.zombie_vars["zombie_point_scalar"] = 2;
	wait 30;

	level.zombie_vars["zombie_point_scalar"] = 1;
	
	level._race_team_double_points = undefined;
}

full_ammo_powerup( drop_item , player)
{
	players = GET_PLAYERS();
	
	if(isDefined(level._get_game_module_players))
	{
		players = [[level._get_game_module_players]](player);
	}
	
	for (i = 0; i < players.size; i++)
	{
		// skip players in last stand
		if ( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			continue;
		}

		primary_weapons = players[i] GetWeaponsList( true ); 

		players[i] notify( "zmb_max_ammo" );
		players[i] notify( "zmb_lost_knife" );
		players[i] notify( "zmb_disable_claymore_prompt" );
		players[i] notify( "zmb_disable_spikemore_prompt" );
		for( x = 0; x < primary_weapons.size; x++ )
		{
			// Fill the clip
			//players[i] SetWeaponAmmoClip( primary_weapons[x], WeaponClipSize( primary_weapons[x] ) );
			
			// Don't refill Equipment
			if ( IsDefined( level.zombie_include_equipment ) && IsDefined( level.zombie_include_equipment[ primary_weapons[ x ] ] ) )
			{
				continue;
			}

			players[i] GiveMaxAmmo( primary_weapons[x] );
		}
	}

	level thread full_ammo_on_hud( drop_item );
}

insta_kill_powerup( drop_item,player)
{
	level notify( "powerup instakill" );
	level endon( "powerup instakill" );

	if(isDefined(level.insta_kill_powerup_override )) //race
	{		
		level thread [[level.insta_kill_powerup_override]](drop_item,player);
		return;
	}

	level thread insta_kill_on_hud( drop_item );

	level.zombie_vars["zombie_insta_kill"] = 1;
	wait( 30 );
	level.zombie_vars["zombie_insta_kill"] = 0;
	players = GET_PLAYERS();
	for(i = 0; i < players.size; i++)
	{
		players[i] notify("insta_kill_over");
	}

}

check_for_instakill( player, mod, hit_location )
{
	if( level.mutators["mutator_noPowerups"] )
	{
		return;
	}
	
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
		modName = remove_mod_from_methodofdeath( mod );
		if ( !is_true( self.no_gib ) )
		{
			self maps\mp\zombies\_zm_spawner::zombie_head_gib();
		}
		self DoDamage( self.health * 10, self.origin, player, self, hit_location, modName );
		player notify("zombie_killed");
		
	}
	
	if( IsDefined( player ) && IsAlive( player ) && (level.zombie_vars["zombie_insta_kill"] || is_true( player.personal_instakill )) )
	{
		if( is_magic_bullet_shield_enabled( self ) )
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

		modName = remove_mod_from_methodofdeath( mod );
		if( flag( "dog_round" ) )
		{
			self DoDamage( self.health * 10, self.origin, player, self, hit_location, modName );
			player notify("zombie_killed");
		}
		else
		{
			if ( !is_true( self.no_gib ) )
			{
				self maps\mp\zombies\_zm_spawner::zombie_head_gib();
			}
			self DoDamage( self.health * 10, self.origin, player, self, hit_location, modName );
			player notify("zombie_killed");
			
		}
	}
}

insta_kill_on_hud( drop_item )
{

	// check to see if this is on or not
	if ( level.zombie_vars["zombie_powerup_insta_kill_on"] )
	{
		// reset the time and keep going
		level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
		return;
	}

	level.zombie_vars["zombie_powerup_insta_kill_on"] = true;

	// set up the hudelem
	//hudelem = maps\mp\gametypes\_hud_util::createFontString( "objective", 2 );
	//hudelem maps\mp\gametypes\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] + level.zombie_vars["zombie_timer_offset_interval"]);
	//hudelem.sort = 0.5;
	//hudelem.alpha = 0;
	//hudelem fadeovertime(0.5);
	//hudelem.alpha = 1;
	//hudelem.label = drop_item.hint;

	// set time remaining for insta kill
	level thread time_remaning_on_insta_kill_powerup();		

	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}

time_remaning_on_insta_kill_powerup()
{
	//self setvalue( level.zombie_vars["zombie_powerup_insta_kill_time"] );
	//level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( level.devil_vox["powerup"]["instakill"] );
	temp_enta = spawn("script_origin", (0,0,0));
	temp_enta playloopsound("zmb_insta_kill_loop");	


	// time it down!
	while ( level.zombie_vars["zombie_powerup_insta_kill_time"] >= 0)
	{
		wait 0.1;
		level.zombie_vars["zombie_powerup_insta_kill_time"] = level.zombie_vars["zombie_powerup_insta_kill_time"] - 0.1;
	//	self setvalue( level.zombie_vars["zombie_powerup_insta_kill_time"] );	
	}

	players = GET_PLAYERS();
	for (i = 0; i < players.size; i++)
	{
		//players[i] stoploopsound (2);

		players[i] playsound("zmb_insta_kill");

	}

	temp_enta stoploopsound(2);
	// turn off the timer
	level.zombie_vars["zombie_powerup_insta_kill_on"] = false;

	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
	//level.zombie_timer_offset += level.zombie_timer_offset_interval;
	//self destroy();
	temp_enta delete();
}

point_doubler_on_hud( drop_item )
{
	self endon ("disconnect");

	// check to see if this is on or not
	if ( level.zombie_vars["zombie_powerup_point_doubler_on"] )
	{
		// reset the time and keep going
		level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
		return;
	}

	level.zombie_vars["zombie_powerup_point_doubler_on"] = true;
	//level.powerup_hud_array[0] = true;
	// set up the hudelem
	//hudelem = maps\mp\gametypes\_hud_util::createFontString( "objective", 2 );
	//hudelem maps\mp\gametypes\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] );
	//hudelem.sort = 0.5;
	//hudelem.alpha = 0;
	//hudelem fadeovertime( 0.5 );
	//hudelem.alpha = 1;
	//hudelem.label = drop_item.hint;

	// set time remaining for point doubler
	level thread time_remaining_on_point_doubler_powerup();		

	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}

time_remaining_on_point_doubler_powerup()
{
	//self setvalue( level.zombie_vars["zombie_powerup_point_doubler_time"] );
	
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent playloopsound ("zmb_double_point_loop");
	
	//level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( level.devil_vox["powerup"]["doublepoints"] );
	
	
	// time it down!
	while ( level.zombie_vars["zombie_powerup_point_doubler_time"] >= 0)
	{
		wait 0.1;
		level.zombie_vars["zombie_powerup_point_doubler_time"] = level.zombie_vars["zombie_powerup_point_doubler_time"] - 0.1;
		//self setvalue( level.zombie_vars["zombie_powerup_point_doubler_time"] );	
	}

	// turn off the timer
	level.zombie_vars["zombie_powerup_point_doubler_on"] = false;
	players = GET_PLAYERS();
	for (i = 0; i < players.size; i++)
	{
		//players[i] stoploopsound("zmb_double_point_loop", 2);
		players[i] playsound("zmb_points_loop_off");
	}
	temp_ent stoploopsound(2);


	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
	//level.zombie_timer_offset += level.zombie_timer_offset_interval;
	//self destroy();
	temp_ent delete();
}
toggle_bonfire_sale_on()
{
	level endon ("powerup bonfire sale");

	if( !isdefined ( level.zombie_vars["zombie_powerup_bonfire_sale_on"] ) )
	{
		return;
	}

	if( level.zombie_vars["zombie_powerup_bonfire_sale_on"] )
	{
		if ( isdefined( level.bonfire_init_func ) )
		{
			level thread [[ level.bonfire_init_func ]]();
		}
		level waittill( "bonfire_sale_off" );
	}
}
toggle_fire_sale_on()
{
	level endon ("powerup fire sale");

	if( !isdefined ( level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		return;
	}

	if( level.zombie_vars["zombie_powerup_fire_sale_on"] )
	{
		for( i = 0; i < level.chests.size; i++ )
		{
			show_firesale_box = level.chests[i] [[level._zombiemode_check_firesale_loc_valid_func]]();
			
			if(show_firesale_box)
			{
				level.chests[i].zombie_cost = 10;
				level.chests[i] set_hint_string( level.chests[i] , "powerup_fire_sale_cost" );

				if( level.chest_index != i )
				{
					level.chests[i].was_temp = true;
					level.chests[i] thread maps\mp\zombies\_zm_magicbox::show_chest();
					level.chests[i] thread maps\mp\zombies\_zm_magicbox::hide_rubble();
					wait_network_frame();
				}
			}
		}
		level waittill( "fire_sale_off" );

		for( i = 0; i < level.chests.size; i++ )
		{
			show_firesale_box = level.chests[i] [[level._zombiemode_check_firesale_loc_valid_func]]();

			if(show_firesale_box)
			{
				if( level.chest_index != i && IsDefined(level.chests[i].was_temp))
				{
					level.chests[i].was_temp = undefined;
					level thread remove_temp_chest( i );
				}
				
				if(IsDefined(level.chests[i].grab_weapon_hint) && (level.chests[i].grab_weapon_hint == true))
				{
					level.chests[i] thread fire_sale_weapon_wait();
				}
				else
				{			
					level.chests[i].zombie_cost = level.chests[i].old_cost;
					level.chests[i] set_hint_string( level.chests[i] , "default_treasure_chest_" + level.chests[i].zombie_cost );
				}	
			}
		}

	}

}
//-------------------------------------------------------------------------------
//	DCS: Adding check if box is open to grab weapon when fire sale ends.
//-------------------------------------------------------------------------------
fire_sale_weapon_wait()
{
	self.zombie_cost = self.old_cost;
	while( isdefined( self.chest_user ) )
	{
		wait_network_frame();
	}
	self set_hint_string( self , "default_treasure_chest_" + self.zombie_cost );	
}	

//
//	Bring the chests back to normal.
remove_temp_chest( chest_index )
{
	while( isdefined( level.chests[chest_index].chest_user ) || (IsDefined(level.chests[chest_index]._box_open) && level.chests[chest_index]._box_open == true))
	{
		wait_network_frame();
	}
	playfx(level._effect["poltergeist"], level.chests[chest_index].orig_origin);
	level.chests[chest_index] playsound ( "zmb_box_poof_land" );
	level.chests[chest_index] playsound( "zmb_couch_slam" );
	level.chests[chest_index] maps\mp\zombies\_zm_magicbox::hide_chest();
	level.chests[chest_index] maps\mp\zombies\_zm_magicbox::show_rubble();
}


devil_dialog_delay()
{
	wait(1.0);
	//level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( level.devil_vox["powerup"]["nuke"] );
}

full_ammo_on_hud( drop_item )
{
	self endon ("disconnect");

	// set up the hudelem
	hudelem = maps\mp\gametypes\_hud_util::createServerFontString( "objective", 2 );
	hudelem maps\mp\gametypes\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;
	hudelem.label = drop_item.hint;

	// set time remaining for insta kill
	hudelem thread full_ammo_move_hud();
}

full_ammo_move_hud()
{

	players = GET_PLAYERS();
	//level thread maps\mp\zombies\_zm_audio::do_announcer_playvox( level.devil_vox["powerup"]["maxammo"] );
	for (i = 0; i < players.size; i++)
	{
		players[i] playsound ("zmb_full_ammo");
		
	}
	wait 0.5;
	move_fade_time = 1.5;

	self FadeOverTime( move_fade_time ); 
	self MoveOverTime( move_fade_time );
	self.y = 270;
	self.alpha = 0;

	wait move_fade_time;

	self destroy();
}


//*****************************************************************************
// Here we have a selection of special case rare powerups that may get dropped
// by the random powerup generator
//*****************************************************************************
check_for_rare_drop_override( pos )
{
	if( IsDefined(flag("ape_round")) && flag("ape_round") )
	{
		return( 0 );
	}

	return( 0 );
}
setup_firesale_audio()
{
	wait(2);
	
	intercom = getentarray ("intercom", "targetname");
	while(1)
	{	
		while( level.zombie_vars["zombie_powerup_fire_sale_on"] == false)
		{
			wait(0.2);		
		}	
		for(i=0;i<intercom.size;i++)
		{
			intercom[i] thread play_firesale_audio();
			//PlaySoundatposition( "zmb_vox_ann_firesale", intercom[i].origin );			
		}	
		while( level.zombie_vars["zombie_powerup_fire_sale_on"] == true)
		{
			wait (0.1);		
		}
		level notify ("firesale_over");
	}
}
play_firesale_audio()
{
	if( level.player_4_vox_override )
	{
		self playloopsound ("mus_fire_sale_rich");
	}
	else
	{
		self playloopsound ("mus_fire_sale");
	}
	
	level waittill ("firesale_over");
	self stoploopsound ();	
	
}

setup_bonfiresale_audio()
{
	wait(2);
	
	intercom = getentarray ("intercom", "targetname");
	while(1)
	{	
		while( level.zombie_vars["zombie_powerup_fire_sale_on"] == false)
		{
			wait(0.2);		
		}	
		for(i=0;i<intercom.size;i++)
		{
			intercom[i] thread play_bonfiresale_audio();
			//PlaySoundatposition( "zmb_vox_ann_firesale", intercom[i].origin );			
		}	
		while( level.zombie_vars["zombie_powerup_fire_sale_on"] == true)
		{
			wait (0.1);		
		}
		level notify ("firesale_over");
	}
}
play_bonfiresale_audio()
{
	if( level.player_4_vox_override )
	{
		self playloopsound ("mus_fire_sale_rich");
	}
	else
	{
		self playloopsound ("mus_fire_sale");
	}
	
	level waittill ("firesale_over");
	self stoploopsound ();	
	
}

//******************************************************************************
// free perk powerup
//******************************************************************************
free_perk_powerup( item )
{
	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(players[i].sessionstate == "spectator") )
		{
			players[i] maps\mp\zombies\_zm_perks::give_random_perk();
		}
	}
}

//******************************************************************************
// random weapon powerup
//******************************************************************************
random_weapon_powerup_throttle()
{
	self.random_weapon_powerup_throttle = true;
	wait( 0.25 );
	self.random_weapon_powerup_throttle = false;
}


random_weapon_powerup( item, player )
{
	if ( player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		return false;
	}
	
	if ( is_true( player.random_weapon_powerup_throttle ) || player IsSwitchingWeapons() || IS_DRINKING(player.is_drinking) )
	{
		return false;
	}
	
	current_weapon = player GetCurrentWeapon();
	current_weapon_type = WeaponInventoryType( current_weapon );
	if ( !is_tactical_grenade( item.weapon ) )
	{
		if ( "primary" != current_weapon_type && "altmode" != current_weapon_type )
		{
			return false;
		}

		if ( !isdefined( level.zombie_weapons[current_weapon] ) && !maps\mp\zombies\_zm_weapons::is_weapon_upgraded( current_weapon ) && "altmode" != current_weapon_type )
		{
			return false;
		}
	}

	player thread random_weapon_powerup_throttle();

	weapon_string = item.weapon;
	if ( player HasWeapon( "bowie_knife_zm" ) )
	{
		if ( weapon_string == "knife_ballistic_zm" )
		{
			weapon_string = "knife_ballistic_bowie_zm";
		}
		else if ( weapon_string == "knife_ballistic_upgraded_zm" )
		{
			weapon_string = "knife_ballistic_bowie_upgraded_zm";
		}
	}
	else if ( player HasWeapon( "sickle_knife_zm" ) )
	{
		if ( weapon_string == "knife_ballistic_zm" )
		{
			weapon_string = "knife_ballistic_sickle_zm";
		}
		else if ( weapon_string == "knife_ballistic_upgraded_zm" )
		{
			weapon_string = "knife_ballistic_sickle_upgraded_zm";
		}
	}

	player thread maps\mp\zombies\_zm_weapons::weapon_give( weapon_string );
	return true;
}

//******************************************************************************
// bonus points powerups
//******************************************************************************
bonus_points_player_powerup( item, player )
{
	points = RandomIntRange( 1, 25 ) * 100;

	if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(player.sessionstate == "spectator") )
	{
		player maps\mp\zombies\_zm_score::player_add_points( "bonus_points_powerup", points );
	}
}

bonus_points_team_powerup( item )
{
	points = RandomIntRange( 1, 25 ) * 100;

	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(players[i].sessionstate == "spectator") )
		{
			players[i] maps\mp\zombies\_zm_score::player_add_points( "bonus_points_powerup", points );
		}
	}
}

lose_points_team_powerup( item )
{
	points = RandomIntRange( 1, 25 ) * 100;

	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(players[i].sessionstate == "spectator") )
		{
			if ( 0 > (players[i].score - points) )
			{
				players[i] maps\mp\zombies\_zm_score::minus_to_player_score( players[i].score );
			}
			else
			{
				players[i] maps\mp\zombies\_zm_score::minus_to_player_score( points );
			}
		}
	}
}

//******************************************************************************
// lose perk powerup
//******************************************************************************
lose_perk_powerup( item )
{
	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(player.sessionstate == "spectator") )
		{
			player maps\mp\zombies\_zm_perks::lose_random_perk();
		}
	}
}

//******************************************************************************
// empty clip powerup
//******************************************************************************
empty_clip_powerup( item )
{
	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(player.sessionstate == "spectator") )
		{
			weapon = player GetCurrentWeapon();
			player SetWeaponAmmoClip( weapon, 0 );
		}
	}
}

//******************************************************************************
// Minigun powerup
//******************************************************************************
minigun_weapon_powerup( ent_player, time )
{
	ent_player endon( "disconnect" );
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	
	if ( !IsDefined( time ) )
	{
		time = 30;
	}
	if(isDefined(level._minigun_time_override))
	{
		time = level._minigun_time_override;
	}

	// Just replenish the time if it's already active
	if ( ent_player.zombie_vars[ "zombie_powerup_minigun_on" ] && 
		 ("minigun_zm" == ent_player GetCurrentWeapon() || (IsDefined(ent_player.has_minigun) && ent_player.has_minigun) ))
	{
		if ( ent_player.zombie_vars["zombie_powerup_minigun_time"] < time )
		{
			ent_player.zombie_vars["zombie_powerup_minigun_time"] = time;
		}
		return;
	}

	ent_player notify( "replace_weapon_powerup" );
	ent_player._show_solo_hud = true;
	
	// make sure weapons are replaced properly if the player is downed
	level._zombie_minigun_powerup_last_stand_func = ::minigun_watch_gunner_downed;
	ent_player.has_minigun = true;
	ent_player.has_powerup_weapon = true;
	
	ent_player increment_is_drinking();
	ent_player._zombie_gun_before_minigun = ent_player GetCurrentWeapon();
	
	// give player a minigun
	ent_player GiveWeapon( "minigun_zm" );
	ent_player SwitchToWeapon( "minigun_zm" );
	
	ent_player.zombie_vars[ "zombie_powerup_minigun_on" ] = true;
	
	level thread minigun_weapon_powerup_countdown( ent_player, "minigun_time_over", time );
	level thread minigun_weapon_powerup_replace( ent_player, "minigun_time_over" );
}

minigun_weapon_powerup_countdown( ent_player, str_gun_return_notify, time )
{
	ent_player endon( "death" );
	ent_player endon( "disconnect" );
	ent_player endon( "player_downed" );
	ent_player endon( str_gun_return_notify );
	ent_player endon( "replace_weapon_powerup" );
	
	//AUDIO: Starting powerup loop on ONLY this player
	setClientSysState( "levelNotify", "minis", ent_player );

	ent_player.zombie_vars["zombie_powerup_minigun_time"] = time;
	while ( ent_player.zombie_vars["zombie_powerup_minigun_time"] > 0)
	{
		wait(1.0);
		ent_player.zombie_vars["zombie_powerup_minigun_time"]--;
	}
	
	//AUDIO: Ending powerup loop on ONLY this player
	setClientSysState( "levelNotify", "minie", ent_player );
	
	level thread minigun_weapon_powerup_remove( ent_player, str_gun_return_notify );
	
}


minigun_weapon_powerup_replace( ent_player, str_gun_return_notify )
{
	ent_player endon( "death" );
	ent_player endon( "disconnect" );
	ent_player endon( "player_downed" );
	ent_player endon( str_gun_return_notify );

	ent_player waittill( "replace_weapon_powerup" );

	ent_player TakeWeapon( "minigun_zm" );
	
	ent_player.zombie_vars[ "zombie_powerup_minigun_on" ] = false;
	
	ent_player.has_minigun = false;
	
	ent_player decrement_is_drinking();
}


minigun_weapon_powerup_remove( ent_player, str_gun_return_notify )
{
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	
	// take the minigun back
	ent_player TakeWeapon( "minigun_zm" );
	
	ent_player.zombie_vars[ "zombie_powerup_minigun_on" ] = false;
	ent_player._show_solo_hud = false;
	
	ent_player.has_minigun = false;
	ent_player.has_powerup_weapon = false;
	
	// this gives the player back their weapons
	ent_player notify( str_gun_return_notify );
	
	ent_player decrement_is_drinking();
	
	if( IsDefined( ent_player._zombie_gun_before_minigun ) )
	{
		player_weapons = ent_player GetWeaponsListPrimaries();
		for( i = 0; i < player_weapons.size; i++ )
		{
			if( player_weapons[i] == ent_player._zombie_gun_before_minigun )
			{
				ent_player SwitchToWeapon( ent_player._zombie_gun_before_minigun );
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
			if( is_melee_weapon( allWeapons[i] ) )
			{
				ent_player SwitchToWeapon( allWeapons[i] );
				return;
			}
		}
	}
	
}

minigun_weapon_powerup_off()
{
	self.zombie_vars["zombie_powerup_minigun_time"] = 0;
}

minigun_watch_gunner_downed()
{
	if ( !is_true( self.has_minigun ) )
	{
		return;
	}

	primaryWeapons = self GetWeaponsListPrimaries();
	
	for( i = 0; i < primaryWeapons.size; i++ )
	{
		if( primaryWeapons[i] == "minigun_zm" )
		{
			self TakeWeapon( "minigun_zm" );
		}
	}
	
	// self decrement_is_drinking();

	// this gives the player back their weapons
	self notify( "minigun_time_over" );
	self.zombie_vars[ "zombie_powerup_minigun_on" ] = false;
	self._show_solo_hud = false;

	// wait a frame to let last stand finish initializing so that
	// the wholethe system knows we went into last stand with a powerup weapon
	wait( 0.05 );
	self.has_minigun = false;
	self.has_powerup_weapon = false;
}



//******************************************************************************
// Tesla powerup
//		players[p].zombie_vars[ "zombie_powerup_tesla_on" ] = false; // tesla
//		players[p].zombie_vars[ "zombie_powerup_tesla_time" ] = 0;	
//******************************************************************************
tesla_weapon_powerup( ent_player, time )
{
	ent_player endon( "disconnect" );
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	
	if ( !IsDefined( time ) )
	{
		time = 11; // no blink
	}

	// Just replenish the time if it's already active
	if ( ent_player.zombie_vars[ "zombie_powerup_tesla_on" ] && 
		 ("tesla_gun_zm" == ent_player GetCurrentWeapon() || (IsDefined(ent_player.has_tesla) && ent_player.has_tesla) ))
	{
		ent_player GiveMaxAmmo( "tesla_gun_zm" );
		if ( ent_player.zombie_vars[ "zombie_powerup_tesla_time" ] < time )
		{
			ent_player.zombie_vars[ "zombie_powerup_tesla_time" ] = time;
		}
		return;
	}

	ent_player notify( "replace_weapon_powerup" );
	ent_player._show_solo_hud = true;
	
	// make sure weapons are replaced properly if the player is downed
	level._zombie_tesla_powerup_last_stand_func = ::tesla_watch_gunner_downed;
	ent_player.has_tesla = true;
	ent_player.has_powerup_weapon = true;

	ent_player increment_is_drinking();
	ent_player._zombie_gun_before_tesla = ent_player GetCurrentWeapon();
	
	// give player a minigun
	ent_player GiveWeapon( "tesla_gun_zm" );
	ent_player GiveMaxAmmo( "tesla_gun_zm" );
	ent_player SwitchToWeapon( "tesla_gun_zm" );
	
	ent_player.zombie_vars[ "zombie_powerup_tesla_on" ] = true;
	
	level thread tesla_weapon_powerup_countdown( ent_player, "tesla_time_over", time );
	level thread tesla_weapon_powerup_replace( ent_player, "tesla_time_over" );
}

tesla_weapon_powerup_countdown( ent_player, str_gun_return_notify, time )
{
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	ent_player endon( str_gun_return_notify );
	ent_player endon( "replace_weapon_powerup" );
	
	//AUDIO: Starting powerup loop on ONLY this player
	setClientSysState( "levelNotify", "minis", ent_player );

	ent_player.zombie_vars[ "zombie_powerup_tesla_time" ] = time;
	while ( true )
	{
		ent_player waittill_any( "weapon_fired", "reload", "zmb_max_ammo" );
		
		if ( !ent_player GetWeaponAmmoStock( "tesla_gun_zm" ) )
		{
			clip_count = ent_player GetWeaponAmmoClip( "tesla_gun_zm" );
			
			if ( !clip_count )
			{
				break; // powerup now ends
			}
			else if ( 1 == clip_count )
			{
				ent_player.zombie_vars[ "zombie_powerup_tesla_time" ] = 1; // blink fast
			}
			else if ( 3 == clip_count )
			{
				ent_player.zombie_vars[ "zombie_powerup_tesla_time" ] = 6; // blink
			}
		}
		else
		{
			ent_player.zombie_vars[ "zombie_powerup_tesla_time" ] = 11; // no blink
		}
	}
	
	//AUDIO: Ending powerup loop on ONLY this player
	setClientSysState( "levelNotify", "minie", ent_player ); // TODO: need a new sound for the tesla
	
	level thread tesla_weapon_powerup_remove( ent_player, str_gun_return_notify );
	
}


tesla_weapon_powerup_replace( ent_player, str_gun_return_notify )
{
	ent_player endon( "death" );
	ent_player endon( "disconnect" );
	ent_player endon( "player_downed" );
	ent_player endon( str_gun_return_notify );

	ent_player waittill( "replace_weapon_powerup" );

	ent_player TakeWeapon( "tesla_gun_zm" );
	
	ent_player.zombie_vars[ "zombie_powerup_tesla_on" ] = false;
	
	ent_player.has_tesla = false;
	
	ent_player decrement_is_drinking();
}


tesla_weapon_powerup_remove( ent_player, str_gun_return_notify )
{
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	
	// take the minigun back
	ent_player TakeWeapon( "tesla_gun_zm" );
	
	ent_player.zombie_vars[ "zombie_powerup_tesla_on" ] = false;
	ent_player._show_solo_hud = false;
	
	ent_player.has_tesla = false;
	ent_player.has_powerup_weapon = false;
	
	// this gives the player back their weapons
	ent_player notify( str_gun_return_notify );
	
	ent_player decrement_is_drinking();
	
	if( IsDefined( ent_player._zombie_gun_before_tesla ) )
	{
		player_weapons = ent_player GetWeaponsListPrimaries();
		for( i = 0; i < player_weapons.size; i++ )
		{
			if( player_weapons[i] == ent_player._zombie_gun_before_tesla )
			{
				ent_player SwitchToWeapon( ent_player._zombie_gun_before_tesla );
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
			if( is_melee_weapon( allWeapons[i] ) )
			{
				ent_player SwitchToWeapon( allWeapons[i] );
				return;
			}
		}
	}
	
}

tesla_weapon_powerup_off()
{
	self.zombie_vars[ "zombie_powerup_tesla_time" ] = 0;
}

tesla_watch_gunner_downed()
{
	if ( !is_true( self.has_tesla ) )
	{
		return;
	}

	primaryWeapons = self GetWeaponsListPrimaries();
	
	for( i = 0; i < primaryWeapons.size; i++ )
	{
		if( primaryWeapons[i] == "tesla_gun_zm" )
		{
			self TakeWeapon( "tesla_gun_zm" );
		}
	}
	
	// self decrement_is_drinking();

	// this gives the player back their weapons
	self notify( "tesla_time_over" );
	self.zombie_vars[ "zombie_powerup_tesla_on" ] = false;
	self._show_solo_hud = false;

	// wait a frame to let last stand finish initializing so that
	// the wholethe system knows we went into last stand with a powerup weapon
	wait( 0.05 );
	self.has_tesla = false;
	self.has_powerup_weapon = false;
}


tesla_powerup_active()
{
	players = GET_PLAYERS();
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
print_powerup_drop( powerup, type )
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

register_carpenter_node(node, callback)
{
	if(!isdefined(level._additional_carpenter_nodes))
	{
		level._additional_carpenter_nodes = [];
	}
	
	node._post_carpenter_callback = callback;
	
	level._additional_carpenter_nodes[level._additional_carpenter_nodes.size] = node;
}
 
start_carpenter_new( origin )
{
	
	window_boards = getstructarray( "exterior_goal", "targetname" ); 
	
	if(isdefined(level._additional_carpenter_nodes))
	{
		window_boards = ArrayCombine(window_boards, level._additional_carpenter_nodes, false, false);
	}
	
	//COLLIN
	carp_ent = spawn("script_origin", (0,0,0));
	carp_ent playloopsound( "evt_carpenter" );	
	
	boards_near_players = get_near_boards(window_boards);
	boards_far_from_players = get_far_boards(window_boards);	
	
	//instantly repair all 'far' boards
	level repair_far_boards(boards_far_from_players);

	for(i=0;i<boards_near_players.size;i++)
	{
		window = boards_near_players[i];
		
		num_chunks_checked = 0;
		
		last_repaired_chunk = undefined;
		
		while(1)
		{
			if( all_chunks_intact( window, window.barrier_chunks ) )
			{
				break;
			}

			chunk = get_random_destroyed_chunk( window, window.barrier_chunks ); 

			if( !IsDefined( chunk ) )
				break;

			window thread maps\mp\zombies\_zm_blockers::replace_chunk( window, chunk, undefined, false, true );
			
			last_repaired_chunk = chunk;
			
			if(IsDefined(window.clip))
			{
				window.clip enable_trigger(); 
				window.clip DisconnectPaths();
			}
			else
			{
				blocker_disconnect_paths(window.neg_start, window.neg_end);
			}
			
			wait_network_frame();
			
			num_chunks_checked++;
			
			if(num_chunks_checked >= 20)
			{
				break;	// Avoid staying in this while loop forever....
			}
		}
		
		//wait for the last window board to be repaired
		
		if(isdefined(window.zbarrier))
		{
			if(isdefined(last_repaired_chunk))
			{
				while(window.zbarrier GetZBarrierPieceState(last_repaired_chunk) == "closing")
				{
					wait(0.05);
				}
				
				if(isdefined(window._post_carpenter_callback))
				{
					window [[window._post_carpenter_callback]]();
				}
			}
		}
		else
		{
			while((IsDefined(last_repaired_chunk)) && (last_repaired_chunk.state == "mid_repair"))
			{
				wait(.05);
			}
		}
	}
	
	carp_ent stoploopsound( 1 );
	carp_ent PlaySoundWithNotify( "evt_carpenter_end", "sound_done" );
	carp_ent waittill( "sound_done" );

	players = GET_PLAYERS();
	for(i = 0; i < players.size; i++)
	{
		players[i] maps\mp\zombies\_zm_score::player_add_points( "carpenter_powerup", 200 ); 
	}

	carp_ent delete();
}


get_near_boards(windows)
{
	// get all boards that are farther than 500 units away from any player and put them into a list
	players = GET_PLAYERS();
	boards_near_players = [];
	
	for(j =0;j<windows.size;j++)
	{
		close = false;
		for(i=0;i<players.size;i++)
		{
			origin = undefined;
			
			if(isdefined(windows[j].zbarrier))
			{
				origin = windows[j].zbarrier.origin;
			}
			else
			{
				origin = windows[j].origin;
			}
			
			if( distancesquared(players[i].origin, origin) <= level.board_repair_distance_squared  )
			{
				close = true;
				break;
			}
		}
		if(close)
		{
			boards_near_players[boards_near_players.size] = windows[j];
		}			
	}
	return boards_near_players;
}

get_far_boards(windows)
{
	// get all boards that are farther than 500 units away from any player and put them into a list
	players = GET_PLAYERS();
	boards_far_from_players = [];
	
	for(j =0;j<windows.size;j++)
	{
		close = false;
		for(i=0;i<players.size;i++)
		{
			
			origin = undefined;
			
			if(isdefined(windows[j].zbarrier))
			{
				origin = windows[j].zbarrier.origin;
			}
			else
			{
				origin = windows[j].origin;
			}			
			
			if( distancesquared(players[i].origin, origin) >= level.board_repair_distance_squared  )
			{
				close = true;
				break;
			}
		}
		
		if(close)
		{
			boards_far_from_players[boards_far_from_players.size] = windows[j];
		}			
	}
	return boards_far_from_players;
}

repair_far_boards(barriers)
{
	for(i=0;i<barriers.size;i++)
	{
		barrier = barriers[i];
		if( all_chunks_intact( barrier, barrier.barrier_chunks ) )
		{
			continue;
		}

		if(isdefined(barrier.zbarrier))
		{
			for(x = 0; x < barrier.zbarrier GetNumZBarrierPieces(); x ++)
			{
				barrier.zbarrier SetZBarrierPieceState(x, "closed");
			}
		}
		
		if(IsDefined(barrier.clip))
		{
			barrier.clip enable_trigger(); 
			barrier.clip DisconnectPaths();
		}
		else
		{
			blocker_disconnect_paths(barrier.neg_start, barrier.neg_end);
		}			

	}
}


func_should_never_drop()
{
	return false;
}

func_should_always_drop()
{
	return true;
}

func_should_drop_minigun()
{
	if ( minigun_no_drop() )
	{
		return false;
	}
	return true;

}

func_should_drop_carpenter()
{
	if(get_num_window_destroyed() < 5 )
	{
		return false;
	}
	return true;
}


func_should_drop_fire_sale()
{
	if( level.zombie_vars["zombie_powerup_fire_sale_on"] == true || level.chest_moves < 1 )
	{
		return false;
	}
	return true;
}
