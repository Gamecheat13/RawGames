/* zombie_moon_sq_osc.gsc
 *
 * Purpose : 	Sidequest declaration and side-quest logic for zombie_moon stage X.
 *						Open Sam's Chamber.
 *		
 * 
 * Author : 	Dan L & Walter W
 * 
 *	Players must open Sam's chamber to get the Black Egg inside it.
 *	Stage 1: Get hacker.
 *	Stage 2: Figure out how to access terminal near Sam.
 *	Stage 3: Hack a terminal that will randomly activate security terminals.
 *	Stage 4: Hack all chosen security terminals before the time runs out.
 *	Stage 5: Press all dour open buttons on Sams access terminal.
 * 
 *
 *
 *	OSC Flags:
 *	0. osc_begin
 *	1. buttons_free
 *	2. security_fail
 *	3. security_pass
 *	4. security_1_done
 *	5. security_2_done
 *	6. security_3_done
 *	7. security_4_done
 *	8. release_started
 *	9. release_complete
 *	10. flag_wait_for_osc
 *
 *
 *
 */			

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_sidequests;



init()
{
	
	PreCacheModel( "rus_sq_button_red_single_long" );
	PreCacheModel( "p_zom_moon_py_glyph_dial_cap" );
	PreCacheModel( "p_zom_moon_button_console_lid" );
	
	level._osc_rb_jolie_spots = [];
	
	level._osc_rbs = getstructarray( "struct_osc_button", "targetname" ); // buttons to open the chamber, these are covered
	if( !IsDefined( level._osc_rbs ) )
	{
		PrintLn( "$$$$ missing _osc_rbs, need bsp $$$$" );
		
		wait( 1.0 );
		
		return;
	}
	
	level._osc_struct = getstruct( "struct_sq_osc", "targetname" ); // main struct with all osc information
	if( !IsDefined( level._osc_struct ) )
	{
		PrintLn( "$$$$ missing _osc_struct, need bsp $$$$" );
		
		wait( 1.0 );
		
		return;
	}
	level._osc_flags = StrTok( level._osc_struct.script_flag, "," );
	if( !IsDefined( level._osc_flags ) )
	{
		PrintLn( "$$$$ fail define on osc flags $$$$" );
		
		wait( 1.0 );
		
		return;
	}
	for( j = 0; j < level._osc_flags.size; j++ )
	{
		if( !IsDefined( level.flag[ level._osc_flags[ j ] ] ) )
		{
			flag_init( level._osc_flags[ j ] );	
		}
		
	}
	
	level._jolie_greet_array = array( level._osc_flags[4], level._osc_flags[5], level._osc_flags[6], level._osc_flags[7] );
	
	level._osc_st = getstructarray( "struct_osc_st", "targetname" ); // security terminals
	for( k = 0; k < level._osc_st.size; k++ )
	{
		level._osc_st[k].focus = SpawnStruct();
		level._osc_st[k].focus.origin = level._osc_st[k].origin;
		level._osc_st[k].focus.radius = 48;
		level._osc_st[k].focus.height = 48;
		level._osc_st[k].focus.script_float = 5;
		level._osc_st[k].focus.script_int = 0;
		
		level._osc_st[k].focus._light_spot = getstruct( level._osc_st[k].target, "targetname" );
	}
	
	level._osc_min_dist = level._osc_struct.script_wait_min;
	level._osc_max_dist = level._osc_struct.script_wait_max;
	level._osc_rbs_dist_range = level._osc_max_dist - level._osc_min_dist;
	
	level._osc_release = 0;
	
	level._osc_check = undefined;
	
	if( GetDvarInt( "jolie_greet_debug" ) )
	{
		level._osc_trial_time = GetDvarInt( "jolie_greet_time" );
	}
	else
	{
		if( !IsDefined( level._osc_struct.script_int ) )
		{
			PrintLn( "$$$$ Missing level._osc_struct.script_int $$$$" );
			
			wait( 1.0 );
			
			return;
		}
		level._osc_trial_time = level._osc_struct.script_int;
	}
	
	level._osc_cap_spot = getstruct( "struct_cover", "targetname" );
	level._osc_cap = Spawn( "script_model", level._osc_cap_spot.origin );
	level._osc_cap.angles = level._osc_cap_spot.angles;
	level._osc_cap SetModel( "p_zom_moon_py_glyph_dial_cap" );

	level._osc_terms = 0;
	
	level thread osc_button_cover_setup();

	declare_sidequest_stage("sq", "osc", ::init_stage, ::stage_logic, ::exit_stage);
}

// set up the button covers but not until _zombiemode is done
osc_button_cover_setup()
{
	
	flag_wait( "start_zombie_round_logic" );
	
	// Had to move the button spawning out of init_stage cause I have to spawn the button cover
	for( i = 0; i < level._osc_rbs.size; i++ )
	{
		// level._osc_rbs[i].cover = GetEnt( level._osc_rbs[i].target, "targetname" );
		osc_target = getstruct( level._osc_rbs[i].target, "targetname" );
		level._osc_rbs[i].cover = Spawn( "script_model", osc_target.origin );
		level._osc_rbs[i].cover.angles = osc_target.angles;
		level._osc_rbs[i].cover SetModel( "p_zom_moon_button_console_lid" );
		
		level._osc_rbs[i].cover_close = level._osc_rbs[i].cover.angles; // save close
	
		level._osc_rbs[i].cover RotateRoll( -90, 0.05 );
		level._osc_rbs[i].cover waittill( "rotatedone" );
		
		level._osc_rbs[i].cover_open = level._osc_rbs[i].cover.angles; // save open
		
		level._osc_rbs[i].cover.angles = level._osc_rbs[i].cover_close; // reset to close
		
		level._osc_rbs[i].jolie = SpawnStruct();
		level._osc_rbs[i].jolie.origin = level._osc_rbs[i].origin;
		level._osc_rbs[i].jolie.radius = 48;
		level._osc_rbs[i].jolie.height = 48;
		level._osc_rbs[i].jolie.script_float = 4;
		level._osc_rbs[i].jolie.script_int = 500;
		level._osc_rbs[i].jolie.no_sight_check = 1;
		level._osc_rbs[i].jolie.no_bullet_trace = 1;
		
		level._osc_rb_jolie_spots = add_to_array( level._osc_rb_jolie_spots, level._osc_rbs[i].jolie, false );
	}
	level._osc_rbs_totalrot = level._osc_rbs[0].cover_close - level._osc_rbs[0].cover_open;
	
}


exit_stage(success)
{
}

stage_logic()
{
	level waittill("release_complete");
	
	stage_completed("sq", "osc");
}

init_stage()
{

	level thread moon_jolie_greet();
	
	level thread moon_rb_dist_think();
	
	level thread moon_open_access();
	
	level thread moon_keyhole();
	
}


moon_rb_dist_think()
{
	level endon( "end_game" );
	level endon( level._osc_flags[ 1 ] );
	level endon( "stop_dist_think" );
	
	level._lid_close_sound = 0;
	int_close = 0;
	dist_struct = getstruct( "struct_rb_dist_check", "targetname" );
	
	while( !flag( level._osc_flags[ 1 ] ) )
	{
		level._osc_check = get_closest_player( dist_struct.origin );
		
		int_distance = Distance2D( level._osc_check.origin, dist_struct.origin );
		
		if( int_distance > level._osc_max_dist )
		{
			int_distance = level._osc_max_dist;
		}
		else if( int_distance < level._osc_min_dist )
		{
			int_distance = level._osc_min_dist;
		}
		
		scale = ( int_distance - level._osc_min_dist ) / level._osc_rbs_dist_range;
		
		rotation_offset = level._osc_rbs_totalrot * scale;
		
		for( i = 0; i < level._osc_rbs.size; i++ )
		{
			level._osc_rbs[i].cover.angles = level._osc_rbs[i].cover_close - rotation_offset;
			if( level._osc_rbs[i].cover.angles == level._osc_rbs[i].cover_close
					&& level._lid_close_sound == 0 )
			{
				level._lid_close_sound = 1;
				level._osc_rbs[i].cover thread rb_cover_sound();
			}
		}
		
		wait( 0.05 );
		
		level._osc_check = undefined;
		
	}

}

rb_cover_sound()
{
	for( i = 0; i < level._osc_rbs.size; i++ )
	{
		level._osc_rbs[i].cover playsound( "evt_sq_rbs_close" );
		level._osc_rbs[i].cover playsound( "vox_mcomp_quest_step3_0", "sounddone" );
	}

	level._osc_rbs[0].cover waittill( "sounddone" );
	level thread play_rb_cover_player_vox( self );
	
	// Not sure how you want to set this up Colin, but this way it won't spam on you the first time.
	// wait a certain amount of time then clear the level var
	wait( 30 );

	level._lid_close_sound = 0;
}

play_rb_cover_player_vox( ent )
{
	level notify( "prevent_dupe_rb_cover_vox" );
	level endon( "prevent_dupe_rb_cover_vox" );
	
	wait(.5);
	
	player = get_closest_player( ent.origin );
	player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest3", undefined, 0 );
}

// Hack the covered buttons to start the security override
moon_jolie_greet()
{
	if( !IsDefined( level._osc_rb_jolie_spots ) || level._osc_rb_jolie_spots.size == 0 )
	{
		PrintLn( "$$$$ Missing jolie spots $$$$" );
		
		wait( 1.0 );
		
		return;
	}
	
	while( !flag( level._osc_flags[ 1 ] ) )
	{
		// register the spots
		for( i = 0; i < level._osc_rb_jolie_spots.size; i++ )
		{
			maps\mp\zombies\_zm_equip_hacker::register_pooled_hackable_struct( level._osc_rb_jolie_spots[i], ::moon_jolie_access );
		}
		
		if( !IsDefined( level._osc_flags[2] ) || !IsDefined( level._osc_flags[3] ) )
		{
			PrintLn( "$$$$ missing flags for jolie_greet $$$$" );
			
			wait( 1.0 );
			
			return;
		}
		
		flag_wait_any( level._osc_flags[2], level._osc_flags[3] );
		
		if( flag( level._osc_flags[2] ) ) // fail
		{
			// reset everything, clean up terminals and activate the hacker structs again
			// clear flags for next time around
			if( flag( level._osc_flags[2] ) )
			{
				flag_clear( level._osc_flags[2] );	
			}
			else if( flag( level._osc_flags[3] ) )
			{
				flag_clear( level._osc_flags[3] );
			}
			
			// clean the terminals
			for( j = 0; j < level._osc_st.size; j++ )
			{
				maps\mp\zombies\_zm_equip_hacker::deregister_hackable_struct( level._osc_st[j].focus );
				
				if( IsDefined( level._osc_st[j].focus._light ) )
				{
					level._osc_st[j].focus._light Delete();
					
				}
				
				if( IsDefined( level._osc_st[j].focus.script_flag ) )
				{
					flag_clear( level._osc_st[j].focus.script_flag );
					
					level._osc_st[j].focus.script_flag = "";
				}

				
				
			}
			
			// hack buttons reset at the top of the loop
	
		}
		else if( flag( level._osc_flags[3] ) ) // pass
		{
			// finished
			flag_set( level._osc_flags[1] );
			
			// open button covers
			level notify( "stop_dist_think" );
			for( l = 0; l < level._osc_rbs.size; l++ )
			{
				level._osc_rbs[l].cover.angles = level._osc_rbs[l].cover_open;
			}
			
			// clean up everything
			for( m = 0; m < level._osc_st.size; m++ )
			{
				if( IsDefined( level._osc_st[m].focus._light ) )
				{
					level._osc_st[m].focus._light Delete();
					
				}
				
				level._osc_st[m].focus.script_flag = "";
				
				maps\mp\zombies\_zm_equip_hacker::deregister_hackable_struct( level._osc_st[m].focus );
				
			}
			
			if( flag( level._osc_flags[2] ) )
			{
				flag_clear( level._osc_flags[2] );	
			}
			else if( flag( level._osc_flags[3] ) )
			{
				flag_clear( level._osc_flags[3] );
			}
			
		}
		

	}
	
}


// Accessed the security override
moon_jolie_access( ent_hacker )
{
	level thread play_moon_jolie_access_vox( ent_hacker );
	level._lid_close_sound = 1;
	
	// turn off the greet spots
	for( i = 0; i < level._osc_rb_jolie_spots.size; i++ )
	{
		maps\mp\zombies\_zm_equip_hacker::deregister_hackable_struct( level._osc_rb_jolie_spots[i] );
	}
	
	level._osc_terms = 0;
	
	random_array = level._osc_st;
	
	random_array = array_randomize( random_array );
	
	for( j = 0; j < 4; j++ )
	{
		PrintLn("*** register hackable terminal hackable.");
		
		//spawn the green light model
		random_array[j].focus._light = Spawn( "script_model", random_array[j].focus._light_spot.origin );
		random_array[j].focus._light.angles = random_array[j].focus._light_spot.angles;
		
		random_array[j].focus._light SetModel( "zombie_trap_switch_light_on_green" );
		PlayFXOnTag( level._effect["terminal_ready"], random_array[j].focus._light, "tag_origin" );

		
		random_array[j].focus._light playsound( "evt_sq_rbs_light_on" );
		random_array[j].focus._light playloopsound( "evt_sq_rbs_light_loop", 1 );
		
				
		// random_array[j].focus.script_flag = "security_" + j + "_done";
		
		// activate the struct for the terminal
		maps\mp\zombies\_zm_equip_hacker::register_pooled_hackable_struct( random_array[j].focus, ::moon_jolie_work );
		
	}
	
	level thread moon_good_jolie();
	level thread moon_bad_jolie();
	array_thread( random_array, ::moon_jolie_timer_vox );
	
}

// From a successful hack the terminal should set its flag
moon_jolie_work( ent_hacker )
{
	
	level._osc_terms++;
	
	if( IsDefined( self._light ) )
	{
		self._light playsound( "evt_sq_rbs_light_off" );
		self._light Delete();
		
	}
	
	if( level._osc_terms < 4 )
	{
		ent_hacker thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest3", undefined, randomintrange(10,12) );
	}
	else
	{
		self thread play_moon_pass_vox( ent_hacker );
	}
	
	maps\mp\zombies\_zm_equip_hacker::deregister_hackable_struct( self );
	
}

// watch for all four flags to be set - PASS
moon_good_jolie()
{
	level endon( "jolie_fail" );
	level endon( "jolie_pass" );
	level endon( level._osc_flags[ 1 ] );
	
	while( level._osc_terms < 4 )
	{
		PrintLn("**** osc terms : " + level._osc_terms);
		wait( 0.1 );
	}
	
	flag_set( level._osc_flags[3] );
	
	level notify( "jolie_pass" );
}

moon_bad_jolie()
{
	level endon( "jolie_fail" );
	level endon( "jolie_pass" );
	level endon( level._osc_flags[ 1 ] );
	
	wait( level._osc_trial_time );
	
	// security wasn't cleared in time
	flag_set( level._osc_flags[2] );
	
	level notify( "jolie_fail" );
	level thread comp_fail_vox();
}

moon_jolie_timer_vox()
{
	level endon( "jolie_fail" );
	level endon( "jolie_pass" );
	level endon( level._osc_flags[ 1 ] );
	
	for(i=level._osc_trial_time;i>0;i--)
	{
		playon = self.focus._light;
		
		if( !isdefined( playon ) )
		{
			return;
		}
		
		if( i == 50 )
		{
			playon playsound( "vox_mcomp_quest_step3_2" );
		}
		if( i == 40 )
		{
			playon playsound( "vox_mcomp_quest_step3_3" );
		}
		if( i == 30 )
		{
			playon playsound( "vox_mcomp_quest_step3_4" );
		}
		if( i == 20 )
		{
			playon playsound( "vox_mcomp_quest_step3_5" );
		}
		if( i == 10 )
		{
			playon playsound( "vox_mcomp_quest_step3_6" );
		}
		if( i == 5 )
		{
			playon playsound( "vox_mcomp_quest_step3_7" );
		}
		
		wait(1);
	}
}

moon_open_access()
{
	button_triggers = [];
	
	flag_wait( level._osc_flags[ 1 ] );
	
	for( i = 0; i < level._osc_rbs.size; i++ )
	{
		trig = Spawn( "trigger_radius_use", level._osc_rbs[i].origin, 0, 48, 32 );
		trig.radius = 48;
		// trig SetHintString( "" );
		trig SetCursorHint( "HINT_NOICON" );
		// trig UseTriggerRequireLookAt();
		trig._hit_already = 0;
		trig thread moon_hit_reaction();
		
		//trig thread hacker_debug( "button", undefined );
		
		button_triggers = add_to_array( button_triggers, trig, false );
		
		trig = undefined;
		
	}
	
	level thread moon_access_granted( button_triggers.size );
	
	while( !flag( level._osc_flags[9] ) )
	{
		
		flag_wait( level._osc_flags[8] );
		
		if( !IsDefined( level._osc_struct.script_float ) )
		{
			PrintLn( "$$$$ need script_float on _osc_struct $$$$" );
			
			wait( 1.0 );
			
			return;
		}
		
		// -- TODO: REMOVE THIS AFTER USING IT FOR TEST PURPOSES!
		if( GetDvarInt( "osc_access_time" ) > 0 )
		{
			wait( GetDvarInt( "osc_access_time" ) );
		}
		else
		{
			wait( level._osc_struct.script_float );	
		}
		
		
		if( !flag( level._osc_flags[9] ) )
		{
			level._osc_release = 0;
			
			for( k = 0; k < button_triggers.size; k++ )
			{
				button_triggers[k]._hit_already = 0;
				if( IsDefined( button_triggers[k]._active ) ) // fx light
				{
					button_triggers[k]._active Delete();
				}
			}
			
			flag_clear( level._osc_flags[8] );

		}
		
	}
	
}

moon_access_granted( int_hits )
{
	level endon( "end_game" );
	
	flag_wait( level._osc_flags[1] );
	
	while( !flag( level._osc_flags[9] ) )
	{
		if( level._osc_release == int_hits )
		{
			flag_set( level._osc_flags[9] );
			
			for( l = 0; l < level._osc_rbs.size; l++ )
			{
				level._osc_rbs[l].cover.angles = level._osc_rbs[l].cover_close;
			}
		}
		
		wait( 0.1 );
	}
}

moon_hit_reaction()
{
	level endon( "end_game" );
	level endon( level._osc_flags[9] );
	
	while( !flag( level._osc_flags[9] ) )
	{
		self waittill( "trigger", who );
		
		if( self._hit_already )
		{
			wait( 0.1 );
			
			continue;
		}
		
		if( is_player_valid( who ) )
		{
			flag_set( level._osc_flags[8] );
			
			self playsound( "evt_sq_rbs_button" );
			self._active = Spawn( "script_model", self.origin );
			self._active SetModel( "tag_origin" );
			PlayFXOnTag( level._effect["osc_button_glow"], self._active, "tag_origin" );
			
			self._hit_already = 1;
			
			level._osc_release++;
		}
		
	}
	
}

moon_keyhole()
{
	flag_wait( level._osc_flags[9] );
	
	// rotate cap
	level._osc_cap RotateRoll( 180, 1.0 );
	level._osc_cap waittill( "rotatedone" );
	
	flag_set( level._osc_flags[10] );
}


hacker_debug( msg, color )
{
	/#
	if ( !isdefined( color ) )
	{
		color = (1, 1, 1);
	}
	
	while(1)
	{
		Print3d(self.origin, msg, color, 1, 2, 10); // 10 server frames is 1 second
		
		wait(1.0);
	}
	#/
}

play_moon_jolie_access_vox( who )
{
	for( i = 0; i < level._osc_rbs.size; i++ )
	{
		level._osc_rbs[i].cover playsound( "vox_mcomp_quest_step3_1", "rbs_sounddone" );
	}
	
	level._osc_rbs[0].cover waittill( "rbs_sounddone" );
	
	if( isdefined( who ) )
	{
		who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest3", undefined, 9 );
	}
}

play_moon_pass_vox( who )
{
	playsoundatposition( "vox_mcomp_quest_step5_26", self.origin );
	
	for( i = 0; i < level._osc_rbs.size; i++ )
	{
		level._osc_rbs[i].cover playsound( "vox_mcomp_quest_step5_26", "rbs_sounddone" );
	}
	
	level._osc_rbs[0].cover waittill( "rbs_sounddone" );
	
	if( isdefined( who ) )
	{
		who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "quest3", undefined, 12 );
	}
}

comp_fail_vox()
{
	for( i = 0; i < level._osc_rbs.size; i++ )
	{
		level._osc_rbs[i].cover playsound( "vox_mcomp_quest_step5_8", "rbs_sounddone" );
	}
	
	level._osc_rbs[0].cover waittill( "rbs_sounddone" );
	
	level._lid_close_sound = 0;
}