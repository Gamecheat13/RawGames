#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_audio;

// Start Functions	/////////////////////////////////////////////////////////////_////////////////////////
start_security_office()
{
	flag_set( "ruins_done" );
	move_player_to_start( "start_security_office" );
	setup_price_for_start( "start_security_office" );
	
	battlechatter_off( "allies" );
	level.price thread price_stealth_think();

	set_rain_level( 6 );
	maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );
}

start_prison_battle_start()
{
	move_player_to_start( "start_prison_battle_start" );
	setup_price_for_start( "start_prison_battle_start" );
	
	level thread open_inner_door(true);

	battlechatter_off( "allies" );
	maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
//	level thread swap_nvg_fx();
}

start_prison_battle_flare_room()
{
	move_player_to_start( "start_prison_battle_flare_room" );
	setup_price_for_start( "start_prison_battle_flare_room" );
	
	maps\_compass::setupMiniMap("compass_map_castle_dungeon", "dungeon_minimap_corner");

	battlechatter_on( "allies" );
	level.price set_ai_bcvoice( "seal" );
	maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
//	level thread swap_nvg_fx();
}

// Init Functions	/////////////////////////////////////////////////////////////////////////////////////

init_event_flags()
{
	//prison battle objective flags
	flag_init( "objective_clear_prison" );	
	flag_init( "objective_clear_prison_cleared" );	
	
	//security office flags
	flag_init( "enter_security_office" );
	flag_init( "inside_security_office" );
	flag_init( "security_office_react" );
	flag_init( "security_office_cleared" );
	flag_init( "security_office_closed" );
	flag_init( "security_office_react_done" );
	flag_init( "chair_react_done" );
	flag_init( "chair_guy_dead" );
	flag_init( "non_chair_guys_dead" );
	flag_init( "start_price_drag" );
	flag_init( "entered_security_office_cage" );
	flag_init( "prison_start" );
	flag_init( "price_open_door" );
	flag_init( "price_shot_chair_guard" );
	flag_init( "inner_door_open" );
	flag_init( "player_outside_office_alert" );
	flag_init( "do_not_stop_price_anim" );
	flag_init( "do_not_stop_guard_anim" );

	//security office -> prison battle flags
	flag_init( "at_power_switch" );
	flag_init( "price_say_ready" );
	flag_init( "harasser_damaged" );
	flag_init( "player_impulsive" );
	flag_init( "price_activate_switch" );
	flag_init( "covercrouch_blindfire_1_alerted" );
	flag_init( "guard_stumble_shot" );
	flag_init( "harass_guard_dead" );
	flag_init( "guard_stumble_dead" );
	
	// multipath	
	flag_init( "stop_prison_nvg_nag" );
	flag_init( "path_selected" );
	flag_init( "multipath_end" );

	// Flare room
	flag_init( "start_flare_room" );
	flag_init( "start_price_nag_before_meatshield" );
	flag_init( "meatshield_done" );
	flag_init( "guard_died" );
	flag_init( "prisoner_died" );
	flag_init( "exited_prison" );
	flag_init( "neither_died" );

	//dialogue flags for security office -> prison battle
	flag_init( "price_say_door_open" );
	flag_init( "price_say_inner_door" );
	flag_init( "price_say_endtheirdays" );
	flag_init( "price_say_waitforlights" );
	flag_init( "price_say_split_up" );
	flag_init( "price_say_flare" );
	//flag_init( "price_say_wave2" );
	//flag_init( "price_say_wave3" );
	flag_init( "price_say_finddead" );
}


//
//
setup_spawn_funcs()
{
	array_spawn_function_targetname( "guard_security_office", 	::init_security_office_guards );

	//array_spawn_function_noteworthy( "guard_prison_start",		::fight_in_darkness );
	//array_spawn_function_targetname( "spawn_prison_halls_a",	::fight_in_darkness );
	level.guard_to_say_vo = [];
	array_spawn_function_targetname( "spawn_prison_halls_a", ::setup_animate_in_darkness );

	array_spawn_function_targetname( "prison_ambient_runners",	::delete_on_goal );
}


//
// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
//

security_office()
{
	level thread enter_security_office();
	flag_wait( "security_office_cleared" );
}


prison_battle_start()
{
	level thread enter_prison();
	flag_wait( "start_flare_room" );
}


prison_battle_flare_room()
{
	level prison_flare_room_battle();
}


/////////////////////////////////////////////////////////////////////////////////////
//
// EVENT MAIN FUNCTIONS
//
/////////////////////////////////////////////////////////////////////////////////////


//handles progression of entering the office and going down to the base of the steps for the Power Switch moment
enter_security_office()
{
	//keypad is set to red
	exploder( 701 );
	
	//light set to red
	cage_pad_light = GetEnt( "cage_pad_light", "targetname" );
	cage_pad_light SetLightIntensity( 1.0 );
	
	clip = getent("player_security_door_clip", "targetname");
	clip trigger_off();
	
	entrance_door_clip = getent("player_security_entrance_clip", "targetname");
	entrance_door_clip trigger_off();
	
	gun = getent("dead_security_gun", "targetname");
	gun trigger_off();
	
	level thread set_power_switch_to_first_frame();
	
	
//	level thread swap_nvg_fx();
	
	level.top_right_destructible = getent( "top_right_destructible", "script_noteworthy" );
	level.top_right_destructible hide();
	level.top_right_destructible SetCanDamage(false);
	
	level.bottom_left_destructible = getent( "bottom_left_destructible", "script_noteworthy" );
	level.bottom_left_destructible hide();
	level.bottom_left_destructible SetCanDamage(false);	
	
	level.bottom_right_destructible = getent( "bottom_right_destructible", "script_noteworthy" );
	level.bottom_right_destructible hide();
	level.bottom_right_destructible SetCanDamage(false);
	
	level.right_top_right_destructible = getent( "right_top_right_destructible", "script_noteworthy" );
	level.right_top_right_destructible SetCanDamage(false);	
	
	level.right_top_left_destructible = getent( "right_top_left_destructible", "script_noteworthy" );
	level.right_top_left_destructible SetCanDamage(false);

	level.right_bottom_left_destructible = getent( "right_bottom_left_destructible", "script_noteworthy" );
	level.right_bottom_left_destructible SetCanDamage(false);	
	
	level.right_bottom_right_destructible = getent( "right_bottom_right_destructible", "script_noteworthy" );
	level.right_bottom_right_destructible SetCanDamage(false);
	
	level thread security_room_monitors();
	
	level thread open_inner_door();
	
	// Price setup
	level.price thread price_security_office_animation();
	level.price thread price_dialogue_security_office();

	//set up security office enemies
	level thread security_office_guards();

	//	wait until we're at the bottom of the spiral stairs to cleanup upstairs
	flag_wait( "at_power_switch" );
	level thread cleanup_security_office();
}


// Open the cage door and setup the prison battles
enter_prison()
{
	battlechatter_off("axis");
	
	maps\_compass::setupMiniMap("compass_map_castle_dungeon", "dungeon_minimap_corner");
	
	// the light comes from the small window on the right path
	set_lightning( 3, 8, (14, 289, -35), "lightning_multipath_room" );

	// Scripted light that will get "shut off"
	a_e_lights = GetEntArray( "dungeon_light", "targetname" );
	foreach( e_light in a_e_lights )
	{
		e_light SetLightIntensity( 2.0 );
	}
	
	dungeon_light_models_off = GetEntArray( "dungeon_light_model_off", "targetname" );
	foreach(dungeon_light_model_off in dungeon_light_models_off)
	{
		dungeon_light_model_off hide();
	}
	
	level.prison_path_end_left = GetEnt( "prison_path_end_left", "targetname" );
	level.prison_path_end_left trigger_off();
	level.prison_path_end_mid_right = GetEnt( "prison_path_end_mid_right", "targetname" );
	level.prison_path_end_mid_right trigger_off();

	// Setup fake targets
	level.e_darkness_targets = GetEntArray( "darkness_target", "targetname" );

	// Make the allies harder to see
	//level.darkness_maxVisibleDist = 156;
	level.darkness_maxVisibleDist = 100;
	
	level.player.old_maxVisibleDist	= level.player.maxVisibleDist;
	level.player.maxVisibleDist 	= level.darkness_maxVisibleDist;
	level.player.n_detections 		= 0;	// used to keep track of how many people saw me

	level.price.old_maxVisibleDist	= level.price.maxVisibleDist;
	level.price.maxVisibleDist		= level.darkness_maxVisibleDist;
	level.price.n_detections 		= 0;	// used to keep track of how many people saw me

	// Price works his way down
	//price will react to player action at the base of steps. If the player rushes in and does not wait for the
	//light switch, price calls him wreckless. Is also set off if player runs ahead (trigger in map sets "player_entered_prison")
	level.price thread price_dialogue_prison();
	level.price thread price_prison_movement();
	level.price thread monitor_price_prison_behavior();
	//level.price price_prison_behavior( "prison_tame" );
	
	thread turn_lights_off();
	
	// Wait for the guys downstairs to be spawned via trigger, just before this flag trigger
	flag_wait( "entered_security_office_cage" );
	
	//First set of guards closest to the base of the spiral staircase
	harass_guard = spawn_targetname( "spawner_harass_guard" );
	harass_prisoner1 = spawn_targetname( "prisoner1" );
	harass_prisoner3 = spawn_targetname( "prisoner3" );
	level.prisoner_to_say_vo = [];
	level.prisoner_to_say_vo[0] = harass_prisoner1;
	level.prisoner_to_say_vo[1] = harass_prisoner3;
	//level thread animate_prison_harass_scene();
	harass_prisoner1 thread animate_harass_prisoners("prisoner1");
	harass_prisoner3 thread animate_harass_prisoners("prisoner3");	
	harass_guard thread animate_harass_guards();
	
	//  Lights out Vignettes
	guard_stumble_ai = spawn_targetname( "guard_stumble" );
	guard_stumble_ai thread guard_stumble();
	
	covercrouch_blindfire_ai = spawn_targetname( "covercrouch_blindfire" );
	covercrouch_blindfire_ai thread guard_covercrouch_blindfire();
	
	level.find_wall_guard_lookat_trig = getent( "find_wall_guard_lookat_trig", "targetname" );
	level.find_wall_guard_lookat_trig trigger_off();
	
	thread spawn_stair_stumble_forward_guard();
	thread spawn_find_wall_guard();
	thread spawn_stair_stumble_back_guard();
	
	thread player_multipath_movement();
	
	//creates ambient prisoners and animates thems
	level thread animate_prisoners_in_multipath_cells_script_structs();
	
	level thread guard_lights_out_vo();
	
	// Setup enemy AI 
	level thread spawn_ambient_runners();

	flag_wait( "start_flare_room" );
	level notify( "notify_flareroom" );
	battlechatter_on("axis");
	
	// Restore old target values
	level.player.maxVisibleDist 	= level.player.old_maxVisibleDist;
	level.player.old_maxVisibleDist	= undefined;

	level.price.maxVisibleDist 		= level.price.old_maxVisibleDist;
	level.price.old_maxVisibleDist 	= undefined;
	
		//this is a quick fix for player visibility changes
//    maps\_stealth_visibility_system:: system_default_detect_ranges ();
	level.player.maxvisibledist = 8196;
	level.price.maxvisibledist = 8196;
	
	autosave_by_name( "flare_room" );
}


price_prison_movement()
{
	flag_wait( "prison_start" );

	// Don't let the guards see you and don't shoot the guards
	level.price set_ignoreall( true );
	level.price set_ignoreme( true );
	activate_trigger( "price_to_power_switch", "targetname" );

	//price says to follow him down the spiral stairs
	flag_set( "price_say_endtheirdays" );

	//checkpoint. Restores the player as they are travelling down the spiral.
	autosave_by_name( "heading_down_to_prison" );
	

	//price runs down stairs and uses power switch
	level.price thread price_explains_power_switch();
	s_align = get_new_anim_node( "dungeon_cell" );
	
	s_align anim_reach_solo( level.price, "goto_power_switch" );	
	s_align thread anim_single_solo( level.price, "goto_power_switch" );
	
	animation = level.price getanim("goto_power_switch");
	while( level.price getanimtime(animation) < 0.65 )
	{
		wait(0.05);
	}
	//wait(0.05);
	anim_set_rate_single( level.price, "goto_power_switch", 1.8 );
	level.price waittillmatch( "single anim", "end" );
	
	s_align thread anim_loop_solo( level.price, "power_switch_wait", "stop_wait" );	

	flag_wait( "at_power_switch" );

	flag_set( "price_say_ready" );
	s_align notify( "stop_wait" );
	
	//TODO Need item to be in the map!
//	m_switch = spawn_anim_model( "power_switch" );
	//	m_switch = GetEnt( "power_switch", "targetname);
	//	m_switch assign_animtree();
	//	m_switch.animname = "power_switch";
	//	s_align thread anim_single_solo( m_switch, "power_switch_off" );
	
	//if(!flag( "player_entered_prison" ))
	//{
		s_align thread anim_single_solo( level.price, "power_switch_off" );
		thread anim_set_rate_single( level.price, "power_switch_off", 1.5 );
		while( level.price getanimtime(level.price getanim("power_switch_off")) < 0.35 )
		{
			wait(0.05);
		}
		anim_set_time( [level.price], "power_switch_off", .6 );
		level.price waittillmatch( "single anim", "end" );
	//}
	
	level.price enable_ai_color();
	level.price set_ignoreall( false );
	level.price set_ignoreme( false );

	//Price movement logic. 
	level.price thread price_multipath_prison_movement();
	
	//Holds until player commits to direction
//	flag_wait( "path_selected" );
}





//handles main progression of the flare room
prison_flare_room_battle()
{
	set_lightning( 0, 0 );

	level.a_m_flares = [];
    level.price notify( "notify_flareroom" );
	level.player notify( "notify_flareroom" );
	
    level.player.maxvisibledist = 8196;
	level.price.maxvisibledist = 8196;
	
	// This is the door that's going to animate
	e_exit_door = GetEnt( "prison_exit_door", "targetname" );
	e_exit_door.animname = "door";
	e_exit_door assign_animtree();
	// This is the clip for the door
	e_exit_door_clip = GetEnt( "prison_exit_clip", "targetname" );
	e_exit_door_clip LinkTo( e_exit_door, "origin_animate_jnt" );
	//move the door into it's first animation frame
	s_align = get_new_anim_node( "align_dungeon_exit" );
	s_align anim_first_frame_solo( e_exit_door, "prison_exit_briefing_open" );
	
	e_blocker = GetEnt( "prison_exit_blocker", "targetname" );
	e_blocker NotSolid();

	// just keep this open
	door1 		= GetEnt( "dungeon_door1_model", "targetname" );
	door1_clip 	= GetEnt( "dungeon_door1", 		 "targetname" );
	door1_clip LinkTo( door1 );

	door2 		= GetEnt( "dungeon_door2_model", "targetname" );
	door2_clip 	= GetEnt( "dungeon_door2", 		 "targetname" );
	door2_clip LinkTo( door2 );

	//this handles the animation for the guy throwing the flare
	level thread animate_flare_thrower();

	//handles the spawning and animation for the meatshield event in the rec room
	level thread rec_room_meatshield();

	//price goes into flare room	
	level.price price_prison_behavior( "flare_room" );
	level.price thread price_dialogue_flare_room();
	level.price enable_ai_color();
	activate_trigger( "price_into_flareroom", "targetname" );

	//ambient flare effects when player enters the room
	t_wave_1_start = GetEnt( "t_flare_room_wave_1", "targetname" );
	t_wave_1_start waittill( "trigger" );

	level thread flare_sequence();

	//wait to make sure wave 1 spawned and if count goes down to spawn next wave
	wait 0.1;

	ai_wave_1 = get_ai_group_ai( "flare_room_wave_1" ); 
	waittill_dead_or_dying( ai_wave_1, ai_wave_1.size - 1 );

	// Move one guy from downstairs to upstairs if possible
	nd_top = GetNode( "n_flare_room_top", "targetname" );
	e_new_goal = GetEnt( "prison_back_office_goalvol", "targetname" );
	a_ai_remaining = GetAIArray( "axis" );
	ai_wave_1_left = get_ai_group_ai( "flare_room_wave_1" );
	foreach( guy in ai_wave_1_left )
	{
		guy SetGoalNode( nd_top );
		guy SetGoalVolume( e_new_goal );
	}
	
	/*foreach( ai_guy in a_ai_remaining )
	{
		if ( IsAlive( ai_guy ) )
		{
			if ( ai_guy.origin[2] < ( nd_top.origin[2] - 100 ) )
			{
				ai_guy SetGoalNode( nd_top );
				ai_guy SetGoalVolume( e_new_goal );
				break;
			}
		}
	}*/
	
	//spawn guys coming from office/stairs
	activate_trigger( "t_flare_room_wave_2", "targetname" );
	wait( 1.0 );	// wait for AI to move in
		
	//move price to left alcove
	//flag_set( "price_say_wave2" );
//	activate_trigger( "price_into_first_alcove", "targetname" );
	
	//waits for x amount of guys to start final wave
	ai_wave_2 = get_ai_group_ai( "flare_room_wave_2" ); 
	waittill_dead_or_dying( ai_wave_2, ai_wave_2.size - 1 );

	activate_trigger( "t_prison_final_wave", "targetname" );
	wait 1.0;	// wait for AI to move in

	//flag_set( "price_say_wave3" );
	activate_trigger( "price_into_back_office", "targetname" );	
	
	waittill_dead_or_dying( ai_wave_2, ai_wave_2.size - 1);
	activate_trigger( "price_into_back_office_2", "targetname" );
	
	//set up the final wave that come from the rec room and the entrance to flare room
	ai_final_wave = get_ai_group_ai( "final_wave" );
	waittill_dead_or_dying( ai_final_wave, ai_final_wave.size );
	
	//set price to the threshold exit just before the rec room
	activate_trigger( "price_into_rec_room", "targetname" );
	level.price waittill("goal");
	flag_set( "start_price_nag_before_meatshield" );

	// 
	flag_wait( "meatshield_start" );
	
	//move price towards the exit once the player resolves the meatshield event
	flag_wait( "meatshield_done" );
	
	// Prep the weather for when you come back outside.  Can also see out some of the windows near the exit.
	set_lightning( 3, 8, (18, 269, 0), "lightning_prison_exit_hall", 3.25, (1.0, 1.0, 1.0) );
	set_rain_level( 6 );

	// Move Price to the exit
	activate_trigger( "price_into_exit", "targetname" );
	level.price disable_cqbwalk();
	level.price enable_sprint();
	level.price waittill( "goal" );
	level.price enable_cqbwalk();
	level.price disable_sprint();

	//Now do the the exit prison sequence

//---JZ disabling trigger for bridge sequence.
	//disable_trigger_with_targetname( "move_up_ladder" );
	
	// Price opens exit door 
	a_exit_briefing_actors = make_array( level.price, e_exit_door );
	s_align anim_reach_solo( level.price, "prison_exit_briefing_open" );
	flag_set( "price_say_finddead" );
	aud_send_msg("price_open_prison_exit_door");
	s_align anim_single( a_exit_briefing_actors, "prison_exit_briefing_open" );
	s_align thread anim_loop( a_exit_briefing_actors, "prison_exit_briefing_open_idle", "end_prison_exit_briefing_open_idle" );
	
	// wait until the player is outside then close the door
	flag_wait( "exited_prison" );
	level notify( "exited_prison" );
	
	VisionSetNight( "castle_nvg_grain" );
	
	flag_set( "objective_clear_prison_cleared" );
	
	_disable_local_lightning_lights( "lightning_prison_exit_hall" );	

	s_align notify( "end_prison_exit_briefing_open_idle" );
	e_blocker Solid();
	s_align anim_single( a_exit_briefing_actors, "prison_exit_briefing_close" );	

	// Move Price out to the bridge area
	level.price enable_ai_color();
	activate_trigger( "price_onto_bridge", "targetname" );

	cleanup_ents( "prison");	// This needs to be called outside of prison_cleanup.
	level prison_cleanup();
	
	//checkpoint
	autosave_by_name( "under_bridge" );
}

flare_room_bottom_spawn()
{

}

//
// Security Office Functions	/////////////////////////////////////////////////////////////////////////////////////
//


//
//	Play security cam footage
//	uses bink movie on a texture
security_room_monitors()
{	
	
	level endon( "kill_security_cinematic");
	SetSavedDvar( "cg_cinematicFullScreen", "0" );
	
	while(1)
	{
		CinematicInGameLoopResident( "castle_securitycam" );
	
		while ( IsCinematicPlaying() )
		{
				wait 1;	   
		}
		wait(0.05);
	}
//	flag_wait( "at_power_switch" );

//	StopCinematicInGame();
}

/*
//waits for enemies in security office to die; sets a flag
//two flags because one guy is a fake death
set_security_room_clear_flag( ae_enemies )
{
	level thread non_chair_guards_dead( ae_enemies );
	flag_wait_all( "non_chair_guys_dead", "chair_guy_dead" );

	flag_set( "security_office_cleared" );
}


//watches for AI group dead on the two AI guards in the security office
non_chair_guards_dead( a_guards )
{
	//removes the fake death guard from the array. 
	for ( i = 0; i < a_guards.size; i++ )
	{
		if( a_guards[ i ].script_noteworthy == "security_guard_chair" )
		{
			a_guards = array_remove( a_guards, a_guards[ i ] );
		}
	}
	waittill_dead( a_guards );
	flag_set( "non_chair_guys_dead" );
}
*/

//Handles price and the 3 guards' animations
//self is price
price_security_office_animation()
{
	level.m_security_door = GetEnt( "security_front_door", "targetname" );
	
	self endon( "death" ); // might die if stealth is broken
	level endon( "player_outside_office_alert" );
	self thread check_player_inside_office();
	
	//update objective to now clear prison
	flag_set( "objective_clear_prison" );

	activate_trigger( "spawn_security_office", "targetname" );
	
	s_align = get_new_anim_node( "security_room" );
	
	self anim_stopanimscripted();

	s_align anim_reach_solo( self, "security_office_run_up" );
	s_align anim_single_solo( self, "security_office_run_up" );
	
	s_align thread anim_loop_solo( self, "security_office_entry_idle" );
	
	// Setup the door for anim
	bm_security_door_clip = GetEnt( "front_door_clip", "targetname" );
	//level.m_security_door = GetEnt( "security_front_door", "targetname" );
	level.m_security_door.animname = "door";
	level.m_security_door assign_animtree();
	bm_security_door_clip LinkTo( level.m_security_door, "origin_animate_jnt" );	
	self place_weapon_on( "mp5_silencer", "chest" );
	
	level.m_security_door thread check_player_inside_office();
		
	//Price should be standing by the door
	flag_wait( "enter_security_office" );
	flag_set( "price_say_door_open" );
	
	thread shut_door_behind_player(s_align, bm_security_door_clip);
	
	aud_send_msg("price_enters_security_office");

	//  Open sesame
	s_align notify( "stop_loop" );
	a_price_and_door = make_array( self, level.m_security_door );
	flag_set( "price_open_door" );
	s_align anim_single(a_price_and_door, "security_office_entry");

	bm_security_door_clip ConnectPaths();

	flag_wait( "inside_security_office" );
		
	self set_ignoreall( false );
	self set_ignoreme( false );
	self.goalradius = 8;
	self SetGoalPos( self.origin );

	flag_wait( "security_office_cleared" );	
	
	//handles animations for price and the guard. drag and opening and closing the cage door
	level.price price_drags_guard_to_cage_door();
}

check_player_inside_office()
{
	self endon("death");
	level endon( "prison_start" );
	
	if(self != level.price)
	{
		level endon( "do_not_stop_guard_anim" );
	}
	
	while(1)
	{
		if(!flag("inside_security_office"))
		{
			if(flag("_stealth_spotted"))
			{
				if(!flag("do_not_stop_price_anim"))
				{
					level notify( "player_outside_office_alert" );
					flag_set( "player_outside_office_alert" );
					
					if (self == level.m_security_door)
					{
						self anim_stopanimscripted();
					}
					else
					{
						if(IsAlive(self))
						{
							self anim_stopanimscripted();

							if (IsDefined(self.magic_bullet_shield)) //&& self.magic_bullet_shield)
							{
								self stop_magic_bullet_shield();
							}
						
							if(self != level.price)
							{
								//self.weapon = level.last_weapon;
								//self Delete();
							}
							else
							{
								self disable_cqbwalk();
								self.pacifist = false;	
								self.ignoreme = false;
							
								security_office_stealth_spotted_node = GetNode("security_office_stealth_spotted_node", "targetname");
								self SetGoalNode(security_office_stealth_spotted_node);
								self.goalradius = 30;	
						
								self.allowdeath = true;
								self.health = 1;
							}
						}
					}
					return;
				}
			}
		}
		wait(0.03);
	}
}

/*
check_player_inside_office()
{
	self endon("death");
	level endon( "prison_start" );
	
	if(self != level.price)
	{
		level endon( "do_not_stop_guard_anim" );
	}
	
	while(1)
	{
		if(!flag("inside_security_office"))
		{
			if(flag("_stealth_spotted"))
			{
				if(!flag("do_not_stop_price_anim"))
				{
					level notify( "player_outside_office_alert" );
					flag_set( "player_outside_office_alert" );
					if(IsAlive(self))
					{
						self anim_stopanimscripted();
						self disable_cqbwalk();
						self.pacifist = false;	
						self.ignoreme = false;
						if (self != level.price && IsDefined(self.magic_bullet_shield))
						{
							self.weapon = level.last_weapon;
							self stop_magic_bullet_shield();
						}
						if(self == level.price)
						{
							self.health = 1;
							security_office_stealth_spotted_node = GetNode("security_office_stealth_spotted_node", "targetname");
							self SetGoalNode(security_office_stealth_spotted_node);
							self.goalradius = 30;	
							
							self.allowdeath = true;	// just in case
							if (IsDefined(self.magic_bullet_shield) && self.magic_bullet_shield)
							{
								self stop_magic_bullet_shield();
							}
						}
					
						return;
					}
				}
			}
		}
		wait(0.03);
	}
}
*/

shut_door_behind_player( s_align, bm_security_door_clip )
{
	flag_wait( "inside_security_office" );
	
	if(!flag("player_outside_office_alert") && !flag("_stealth_spotted"))
	{
		entrance_door_clip = getent("player_security_entrance_clip", "targetname");
		entrance_door_clip trigger_on();
	
		s_align thread anim_single_solo( level.m_security_door, "security_office_entry_door_close" );
		anim_set_rate_single( level.m_security_door , "security_office_entry_door_close" , 50 );
	
		entrance_door_clip delete();
		bm_security_door_clip DisconnectPaths();
		flag_set( "security_office_closed" );
		flag_set( "stop_water_splash_fx" );
	
		level.right_top_right_destructible SetCanDamage(true);	
		level.right_top_left_destructible SetCanDamage(true);
		level.right_bottom_right_destructible SetCanDamage(true);
		level.right_bottom_left_destructible SetCanDamage(true);
		
		level notify( "price_stealth_end" );
		flag_set( "security_office_cleared" );
	}
}

//Notetrack functions for Price's security office anims
grab_pistol(price)
{	
	level.price_pistol = spawn( "script_model", level.price GetTagOrigin( "TAG_WEAPON_RIGHT" ) );
	level.price_pistol setmodel( "weapon_usp_silencer" );
	level.price_pistol linkto( level.price, "TAG_WEAPON_RIGHT", (0, 0, 0), (0, 0, 0) );
	
	level.price_knife = spawn( "script_model", level.price GetTagOrigin( "TAG_INHAND" ) );
	level.price_knife setmodel( "weapon_commando_knife" );
	level.price_knife linkto( level.price, "TAG_INHAND", (0, 0, 0), (0, 0, 0) );
}

knock1(price)
{
	//Put sfx for knock here	
	level.price PlaySound( "hijk_cockpit_bash" );
	
}

knock2(price)
{
	//Put sfx for knock here
	level.price PlaySound( "hijk_cockpit_bash" );
	
	wait(4);
	flag_set( "security_office_react" );	
}

kill_right(price)
{
	PlayFXOnTag( level._effect[ "pistol_muzzle_flash" ] , level.price_pistol , "TAG_FLASH" );
	PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , level.price_pistol , "TAG_BRASS" );
	level.price_pistol thread play_sound_on_tag( "weap_usp45sd_fire_npc" , "TAG_FLASH" );
	//magicBullet( "usp_silencer" , level.price_pistol GetTagOrigin( "TAG_FLASH" ) , level.security_guard_chair GetTagOrigin( "J_Head" ) );
	flag_set( "price_shot_chair_guard");
}

kill_left(price)
{
	PlayFXOnTag( level._effect[ "pistol_muzzle_flash" ] , level.price_pistol , "TAG_FLASH" );
	PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , level.price_pistol , "TAG_BRASS" );
	level.price_pistol thread play_sound_on_tag( "weap_usp45sd_fire_npc" , "TAG_FLASH" );
	//magicBullet( "usp_silencer" , level.price_pistol GetTagOrigin( "TAG_FLASH" ) , level.security_guard_1 GetTagOrigin( "J_Head" ) );
	level.security_guard_1 kill();
}

kill_mid(price)
{
	PlayFXOnTag( level._effect[ "pistol_muzzle_flash" ] , level.price_pistol , "TAG_FLASH" );
	PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , level.price_pistol , "TAG_BRASS" );
	level.price_pistol thread play_sound_on_tag( "weap_usp45sd_fire_npc" , "TAG_FLASH" );
	//magicBullet( "usp_silencer" , level.price_pistol GetTagOrigin( "TAG_FLASH" ) , level.security_guard_2 GetTagOrigin( "J_Head" ) );
	level.security_guard_2 kill();
	
	//flag_set( "security_office_cleared" );
}

hide_pistol(price)
{
	level.price_pistol Delete();
	//wait(2);
	flag_clear( "do_not_stop_price_anim" );
	level.price.dont_break_anim = false;
}

hide_knife(price)
{
	level.price_knife Delete();
}

grab_rifle(price)
{
	level.price place_weapon_on( "mp5_silencer", "right" );
}


//	Security guards in the office are idling until the door opens, then they react and the player needs
//	to get inside.  The guard in the chair is pretty custom because he's a part of a scene anim with Price
//	after they are all killed.
//
security_office_guards()
{
	flag_wait( "enter_security_office" );
	
	//	
	a_ai_security_guards = get_ai_group_ai( "security_office" );
	foreach ( ai_security_guard in a_ai_security_guards )
	{
		ai_security_guard disable_surprise();
		
		if( ai_security_guard.script_noteworthy == "security_guard_chair" )
		{
			ai_security_guard thread chair_guard_animations();
			level.security_guard_chair = ai_security_guard;
			//ai_security_guard thread stop_animation_on_grenade_security();
		}
		else if( ai_security_guard.script_noteworthy == "security_guard_3" )
		{
			ai_security_guard thread entry_door_guard_animations();
			level.security_guard_3 = ai_security_guard;
		}
		else if( ai_security_guard.script_noteworthy == "security_guard_2" )
		{
			ai_security_guard thread security_guard_2_animations();
			level.security_guard_2 = ai_security_guard;
		}
		else if( ai_security_guard.script_noteworthy == "security_guard_1" )
		{
			ai_security_guard thread guard_animations();
			level.security_guard_1 = ai_security_guard;
		}
	}

	//track the death of 2 AI guards and watch for a special flag for the guard with a fake death
	//level thread set_security_room_clear_flag( a_ai_security_guards );

	// wait for a couple of seconds or until the player dashes in.	
    flag_wait_either( "security_office_react", "inside_security_office" );
	wait( 5.0 );

	flag_set( "security_office_react_done" );

	// Price needs to die if you haven't gone inside like you're supposed to.
	/*
	if ( !flag( "inside_security_office" ) )
	{
		flag_set( "_stealth_spotted" );
		return;
	}
*/
}

stop_animation_on_grenade_security()
{
	self endon("death");
	
	self waittill_any("flashbang", "grenade danger", "explode", "bulletwhizby" );
	flag_set("_stealth_spotted");
	
	self anim_stopanimscripted();
}


stop_animation_on_grenade_prison()
{
	self endon("death");
	level endon("price_activate_switch");
	
	self waittill_any("flashbang", "grenade danger", "explode", "bulletwhizby", "pain_death" );
	flag_set("player_impulsive");
	
	self anim_stopanimscripted();
}
stop_animation_on_prison_guard_if_flashbang()
{
	self endon("death");
	//level endon("price_activate_switch");
	
	self waittill_any("flashbang", "explode");
	//flag_set("player_impulsive");
	
	self anim_stopanimscripted();
}

//	Guards idle around until the door opens.  Then they react
//	self is a security office guard
guard_animations()
{
	s_align = get_new_anim_node( "security_room" );

	self.noragdoll = 1;
	
	self set_allowdeath( true );
	//play reaction anims for the other two guards in the room
	s_align thread anim_loop_solo( self, "security_office_idle" );

	// wait for a couple of seconds or until the player dashes in.
    flag_wait( "security_office_react");

	//	Now react and come alive
	s_align notify( "stop_loop" );
	s_align anim_single_solo( self, "security_office_react" );
	
	self set_ai_guard_passive( false, 256 );
}

security_guard_2_animations()
{
	flag_wait( "security_office_react" );
	
	self.noragdoll = 1;
	self.deathanim = getanim( "generic_death" );
	
	self anim_single_solo(self, "security_office_react" );
	
}

entry_door_guard_animations()
{
	self thread check_player_inside_office();
	self gun_remove();	
	self magic_bullet_shield();
	
	s_align = get_new_anim_node( "security_room" );
	
	flag_wait( "price_open_door" );
	if (flag( "_stealth_spotted" ))
	{
		return;
	}
	
	s_align anim_single_solo( self, "security_office_entry_guard" );
	
	if(flag( "do_not_stop_guard_anim" ))
	{
		if(IsDefined(self.magic_bullet_shield))
		{
			self stop_magic_bullet_shield();
		}
		if(IsAlive(self))
		{
			self.allowDeath = true;
			self.a.nodeath = true;
			self.diequietly = true;
			self.noragdoll = 1;
			self kill();
		}
	}
	//wait(5);
	//self.team = "neutral";
	//self StopAnimScripted();
	//self SetAnim(self GetAnim("security_office_entry_guard"), 1.0, 0.95, 0.0);
	//anim_set_time( [self], "security_office_entry_guard", .95 );
	
	//flag_wait("");
}

stab_enter(guard)
{
	//Put sfx here for guard getting stabbed and Price pushing his way into security office	
	level.price PlaySound( "temp_stab" );
	//level notify( "price_stealth_end" );
	level.security_guard_3.team = "neutral";
	level.security_guard_3 SetCanDamage(false);
	level.security_guard_3.ignoreme = 1;
	flag_set( "do_not_stop_price_anim" );
	flag_set( "do_not_stop_guard_anim" );
	level.price.dont_break_anim = true;
}

throat_cut(guard)
{
	//Put sfx/fx here for guard getting his throat cut
	level.price PlaySound( "temp_gurgle" );
}

land(guard)
{
	//Put sfx here for guard landing on the ground
}

kill_dude(guard)
{
	//For scripting purposes
}

chair_guard_animations()
{
	s_align = get_new_anim_node( "security_room" );

	//make the chair guy global since he has more custom anims post getting shot
	level.ai_chair_guard = self;

	// His chair needs to animate too.
	m_guard_chair = GetEnt( "guard_chair", "targetname" );
	m_guard_chair.animname = "chair";
	m_guard_chair assign_animtree();
	m_guard_chair thread animate_chair();
	
	//	Rockin in the chair
	a_chair_actors = make_array( level.ai_chair_guard, m_guard_chair );
	s_align thread anim_loop( a_chair_actors, "security_office_guard_chair_idle" );
	
	// wait for a couple of seconds or until the player dashes in.	
    flag_wait( "security_office_react");
    
	s_align notify( "stop_loop" );
	s_align anim_single_solo( self, "security_office_react" );
	flag_set( "chair_react_done" );
	s_align thread anim_single_solo( self, "security_office_react_stand" );
	
	self deletable_magic_bullet_shield();
	self disable_pain();

	self thread maps\castle_anim::spawn_fake_security_office_dead_model();
	s_align anim_first_frame_solo( level.fake_security_character, "security_office_react_death" );
	
	//set ignore so price stops shooting him since he's still alive.
	self set_ignoreme( true );
	self.ignoreall = 1;
	
	flag_wait( "price_shot_chair_guard" );
	wait(0.05);
	anim_set_time( [self], "security_office_react_stand", 0.98 );
	self.dropWeapon = true;
	self animscripts\shared::DropAIWeapon();
	wait(.1);
	
	level.fake_security_character show();
	self delete();
	s_align anim_single_solo( level.fake_security_character, "security_office_react_death" );

	// This needs to be set here so that the death anim is completed before 
	// Price tries to perform the drag animation.
	flag_set( "chair_guy_dead" );
	
	gun = getent("dead_security_gun", "targetname");
	gun trigger_on();

	s_align thread anim_loop_solo( level.fake_security_character, "security_office_guard_chair_death_idle", "end_death_loop" );
	
	//waits for price to reach
	flag_wait( "security_office_cleared" );
	s_align notify( "end_death_loop" ); 
}

//	The chair gets pushed back if the guard stands up or if he dies in his chair
// self is the guard chair	
animate_chair()
{
	waittill_any_ents( level, "chair_react_done", level.ai_chair_guard, "damage" );
	
	s_align = get_new_anim_node( "security_room" );
	s_align anim_single_solo( self, "security_office_guard_chair_move" );
	s_align anim_loop_solo( self, "security_office_guard_chair_death_idle" );
}


//handles animation of price dragging the guard to the gate. and places price inside waiting for the player
//self is price
price_drags_guard_to_cage_door()
{
	self endon( "death" );	// He might die if you break stealth
	
	s_align = get_new_anim_node( "security_room" );

	// Setup the door to be animated
	m_cage_door = GetEnt( "security_door_1", "targetname" );
	m_cage_door.animname = "airlock_door";
	m_cage_door assign_animtree();

	bm_cage_door_clip = GetEnt( "cage_door_clip", "targetname" );
	bm_cage_door_clip LinkTo( m_cage_door, "origin_animate_jnt" );

	// Price drags the guard's body to the scanner
	level thread ready_to_close_security_door();
	s_align anim_reach_solo( self, "security_office_drag" );
	flag_set( "start_price_drag" );
	aud_send_msg("price_use_dead_guard_hand");
	s_align anim_single( make_array( self, level.fake_security_character, m_cage_door ), "security_office_drag" );
	
	flag_set( "prison_start" );
	
	//price tells the player to get inside
	flag_set( "price_say_inner_door" );

	flag_wait( "entered_security_office_cage" );	
	s_align anim_single_solo( m_cage_door, "security_office_door_close" );
}

ready_to_close_security_door()
{
	
	flag_wait( "entered_security_office_cage" );
	
	clip = getent("player_security_door_clip", "targetname");
	clip trigger_on();
}


//
//	After the thumb scan, change the light to green
cage_pad_open( ai_guy )
{
	//keypad is set to green
	stop_exploder( 701 );
	exploder( 702 ); 
	
	//set light to green
	cage_pad_light = GetEnt( "cage_pad_light", "targetname" );
	cage_pad_light SetLightColor( (0.0, 1.0, 0.0) );
}

door2_trigger(guy)
{
	flag_set( "inner_door_open" );
}

monitor_trigger(monitor)
{
	level.top_right_destructible show();
	top_right = GetEnt( "top_right", "script_noteworthy" );
	top_right Delete();
	level.top_right_destructible SetCanDamage(true);
	
	level.bottom_left_destructible show();
	bottom_left = GetEnt( "bottom_left", "script_noteworthy" );
	bottom_left Delete();
	level.bottom_left_destructible SetCanDamage(true);
	
	level.bottom_right_destructible show();
	bottom_right = GetEnt( "bottom_right", "script_noteworthy" );
	bottom_right Delete();
	level.bottom_right_destructible SetCanDamage(true);
}

dialogue01(price)
{
	level.price dialogue_queue( "castle_pri_camerasout" );
}

dialogue02(price)
{
	level.price dialogue_queue( "castle_pri_knock" );	
}

dialogue03(price)
{
	level.price dialogue_queue( "castle_pri_cheers" );	
}

open_inner_door(open_fast)
{
	if ( !IsDefined( open_fast ))
	{
		open_fast = false;	
	}
	
	dungeon_enter_door = GetEnt( "prison_enter_door", "targetname" );
	dungeon_enter_door.animname = "door";
	dungeon_enter_door assign_animtree();
	
	// This is the clip for the door
	e_inner_door_clip = GetEnt( "inner_door_clip", "targetname" );
	e_inner_door_clip LinkTo( dungeon_enter_door, "origin_animate_jnt" );
	
	s_align = get_new_anim_node( "align_dungeon_enter" );
	s_align anim_first_frame_solo( dungeon_enter_door, "prison_exit_briefing_open" );
	
	if ( !open_fast )
	{
		flag_wait( "inner_door_open" );
	}
	
	s_align thread anim_single_solo( dungeon_enter_door, "prison_exit_briefing_open" );
	
	if ( open_fast )
	{
		anim_set_rate_single( dungeon_enter_door , "prison_exit_briefing_open" , 50 );
	}
	
	e_inner_door_clip ConnectPaths();
}

//self is AI, sets amimname to be noteworthy, ignore all and goal radius
init_security_office_guards()
{
	//enable ignoreall and sets goal radius
	//set health so guards only take one shot to make stealth easier.
//	self.health = 10;
	self set_ai_guard_passive( true, 32);
	self.animname = self.script_noteworthy;
}



//////////////////////////////////////////////////////////////////////////////
// Prison Battle Functions	
//////////////////////////////////////////////////////////////////////////////
 /*
//handles opening the inner door once they are inside the cage
open_inner_door()
{
	e_inner_door = GetEnt( "security_door_2", "targetname" );
	e_inner_door_clip = GetEnt( "inner_door_clip", "targetname" );
	v_inner_door_original_angles = e_inner_door_clip.angles;

	//open inner door
	e_inner_door_clip SetModel( "tag_origin" );
	e_inner_door LinkTo( e_inner_door_clip, "tag_origin" );
	//e_inner_door_clip hunted_style_door_open();	
	
	wait( 1.75 );
	
	e_inner_door_clip PlaySound( "door_wood_slow_open" );

	e_inner_door_clip RotateTo( e_inner_door_clip.angles + ( 0, 40, 0 ), 2, .5, 0 );
	e_inner_door_clip ConnectPaths();
	e_inner_door_clip waittill( "rotatedone" );
	e_inner_door_clip RotateTo( e_inner_door_clip.angles + ( 0, 57, 0 ), 2, 0, 2 );
	
}
*/

//self is price. initiates price explanation of lights out when he hits a trigger at base of steps
price_explains_power_switch()
{
	level endon( "price_activate_switch" );
	level endon( "player_entered_prison" );

	t_price_power_switch = GetEnt( "price_light_switch", "targetname" );
	t_price_power_switch waittill( "trigger", ent );

	if ( ent == level.price )
	{
		flag_set( "price_say_waitforlights" );
	}
}


//
//	Turn the lights off
lights_off( ai_price )
{
	flag_set( "price_activate_switch" );
	/*
	// Start NVG nag
	if ( !flag( "nvg_on" ) )
	{
		a_nag_lines = [ "castle_pri_usenvgs", "castle_pri_blindasthem", "castle_pri_putonnvgs" ];
		level thread check_player_used_nvgs( 1 );
		n_wait = 10;
		wait(1);
		if(flag("start_flare_room"))
		{
			return;	
		}
		
		ai_price thread nag_vo_until_flag( a_nag_lines, "stop_prison_nvg_nag", n_wait );
		flag_wait_any( "nvg_on", "path_selected", "start_flare_room" );
		
		flag_set( "stop_prison_nvg_nag" );
	}
	*/
}

turn_lights_off()
{
	flag_wait_any( "price_activate_switch", "player_entered_prison" );
	level thread rotate_power_switch();
	exploder( 703 );	// Sparks on light switch
	a_e_lights = GetEntArray( "dungeon_light", "targetname" );
	foreach( e_light in a_e_lights )
	{
		e_light SetLightIntensity( 0.1 );
	}
	
	dungeon_light_models_off = GetEntArray( "dungeon_light_model_off", "targetname" );
	foreach(dungeon_light_model_off in dungeon_light_models_off)
	{
		dungeon_light_model_off show();
	}
	
	dungeon_light_models_on = GetEntArray( "dungeon_light_model_on", "targetname" );
	foreach(dungeon_light_model_on in dungeon_light_models_on)
	{
		dungeon_light_model_on Delete();
	}
	
	VisionSetNaked( "castle_light_switch", 0 );
}

set_power_switch_to_first_frame()
{
	s_align = get_new_anim_node( "dungeon_cell" );
	power_switch = GetEnt( "power_switch_handle", "targetname" );
	power_switch.animname = "power_switch";
	power_switch assign_animtree();
	s_align thread anim_first_frame_solo( power_switch, "power_off" );
	
}


rotate_power_switch()
{
	s_align = get_new_anim_node( "dungeon_cell" );
	power_switch = GetEnt( "power_switch_handle", "targetname" );
	power_switch.animname = "power_switch";
	power_switch assign_animtree();
	aud_send_msg("price_cut_lights");
	s_align thread anim_single_solo( power_switch, "power_off" );
	//wait(1);
	//iprintlnbold(power_switch.origin[0] + " " + power_switch.origin[1] + " " + power_switch.origin[2]);

}


// simple check to see if the player uses the NVGs at least once
check_player_used_nvgs( n_wait )
{
	if ( flag( "nvg_on" ) )
	{
		return;
	}
	level endon( "nvg_on" );
	//level endon( "path_selected" );
	wait( n_wait );
	
	level.player display_hint( "nvg" );
	flag_wait_or_timeout( "nvg_on", 5 );	
	//level.player display_hint( "" );
}

/*
//self is level
//if player kills before lights are out; price insults
has_player_killed_prematurely( ae_enemies )
{
	self waittill_dead( ae_enemies, 1 );
	
	if( !flag( "price_activate_switch" ) )
	{
		flag_set( "player_impulsive" );
	}
}
*/

player_multipath_movement()
{
	//get all the triggers for price's color chains
	level.t_prison_path_left 	= GetEnt( "prison_path_left", "targetname" );
	level.t_prison_path_middle 	= GetEnt( "prison_path_middle", "targetname" );
	level.t_prison_path_right 	= GetEnt( "prison_path_right", "targetname" );

	//put them in array and run threads to set a flag if they are chosen.
	at_paths = GetEntArray( "path", "script_noteworthy" );
	array_thread( at_paths, ::select_path );
	level.t_path_taken = undefined;
	
	//player has taken a path so clean up the rest of the color triggers so the player cannot retrigger them
	//Note: IW colors do not disable once used.
	flag_wait( "path_selected" );
	if ( level.t_path_taken == level.t_prison_path_left )
	{
		if (isDefined(level.t_prison_path_middle))
		{
			level.t_prison_path_middle Delete();
		}
		
		if (isDefined(level.t_prison_path_right))
		{
			level.t_prison_path_right Delete();
		}
	}
	if ( level.t_path_taken == level.t_prison_path_middle )
	{
		if (isDefined(level.t_prison_path_left))
		{
			level.t_prison_path_left Delete();
		}
		if (isDefined(level.t_prison_path_right))
		{
			level.t_prison_path_right Delete();
		}
	}	
	if ( level.t_path_taken == level.t_prison_path_right )
	{
		if (isDefined(level.t_prison_path_middle))
		{
			level.t_prison_path_middle Delete();
		}
		
		if (isDefined(level.t_prison_path_left))
		{
			level.t_prison_path_left Delete();
		}
	}	
}


// Handles movement for Price in the multipath part of prison.
//	self is Price
price_multipath_prison_movement()
{
	//price needs to truck through the multipath room
	self set_ignoreall( false );
	self set_ignoreme( false );
	self set_ignoreSuppression( true );

	thread move_price_into_multipath_start();
	
	//player has taken a path so clean up the rest of the color triggers so the player cannot retrigger them
	//Note: IW colors do not disable once used.
	flag_wait( "path_selected" );
	fake_targetname = "price_target_left";
	//if player chooses left path, Price goes right
	if ( level.t_path_taken == level.t_prison_path_left )
	{
		fake_targetname = "price_target_right";
	}
	
	//if player chooses middle path, Price goes left
	if ( level.t_path_taken == level.t_prison_path_middle )
	{
		fake_targetname = "price_target_left";
	}

	//if player chooses right path, Price goes left
	if ( level.t_path_taken == level.t_prison_path_right )
	{
		fake_targetname = "price_target_left";
	}	
	
	// Now have Price shoot and look badass for a bit
	self waittill( "goal" );
	self.ignoreme = 1;
	e_fake_target = GetEnt( fake_targetname, "targetname" );
	for ( i=0; i<4; i++ )	// number of max iterations before we decide it's time to move on
	{
		if ( flag("multipath_end" ) )
		{
			break;
		}
		
		level.price shoot_at_fake_target( e_fake_target );
	}
	self ClearEntityTarget();
	flag_wait( "multipath_end" );
	wait 1;
	activate_trigger( "price_move_to_path_end", "targetname" );
}

move_price_into_multipath_start()
{
	flag_wait( "harass_guard_dead" );
	activate_trigger( "prison_halls_a", "targetname" );
	flag_set( "price_say_split_up" );
}


//
//	Shoot at fake target, as long as the player can't see it
//	e_fake_target - the thing Price will shoot at
//	self is Price
shoot_at_fake_target( e_fake_target )
{
	level endon( "multipath_end" );
	
	b_trace = true;
	while ( b_trace )
	{
		wait( 0.1 );
		
		b_trace = BulletTracePassed( level.player GetEye(), e_fake_target.origin, false, undefined );
	}
	
	self SetEntityTarget( e_fake_target, 0.7 );
	wait( RandomFloatRange( 1.5, 2.0 ) );
	
	self ClearEntityTarget();
	wait( RandomFloatRange( 1.0, 2.0 ) );
}


//	
//	See some movement in the background if you look in the right spot
spawn_ambient_runners()
{
	level endon( "start_flare_event" );

	flag_wait( "start_ambient_runners" );

	// Start the runners
	activate_trigger( "spawn_ambient_runners", "targetname" );
}

	
//	Get rid of these guys once they've reached their goal.
//	Used for simple ambient AI
delete_on_goal()
{
	self endon( "death" );
	
	self waittill( "goal" );
	
	self Delete();
}


//
//	Spawnfunc for prisoner drones.
//	s_align is an optional align node to play an anim from
prisoner_init()
{
//  Hack so NVGs don't assert when the prisoners spawn
	//	This has to be done in a spawn_function.  Setting it after spawning doesn't work 
	//	because the NVG thread is also a spawn_function on AI.
//	self.has_no_ir = true;

	self.drone_idle_custom = 1;
	self.drone_idle_override = ::prisoner_loop_idle;

	self.name = "";
	self.team = "neutral";
}


//
//	This is currently empty because we're assigning animations to them differently for the moment.
prisoner_loop_idle()
{
}

animate_harass_prisoners(animname)
{
	wait( 0.5 );  	// In case of skipto, we need to wait to make sure the guys have spawned.
		
	self.animname = animname;
	self thread anim_loop_solo( self, "harass_loop" );
	
	flag_wait_any( "price_activate_switch", "player_impulsive", "harasser_damaged", "player_entered_prison" );

	// React to the player
	if ( IsAlive( self ) )
	{
		self anim_stopanimscripted();
		self thread harassed_prisoner_react();
	}
	
}

animate_harass_guards( harass_guard )
{
	wait( 0.5 );  	// In case of skipto, we need to wait to make sure the guys have spawned.
	
	s_align = get_new_anim_node( "dungeon_cell" );
	
	self.allowdeath = true;
	self.animname = "guard3";
	self thread stop_animation_on_grenade_prison();
	
	//level thread has_player_killed_prematurely( array );
	self thread has_player_killed_prematurely();
	level thread harasser_damage_watcher( self );
	
	// Spawn the baton one of the guards uses
	m_baton = spawn_anim_model( "baton" );
	add_cleanup_ent( m_baton, "prison" );

	//s_align thread anim_loop( make_array( self, m_baton ), "harass_loop" );
	s_align thread anim_loop_solo( m_baton, "harass_loop", "stop_loop" );
	s_align thread anim_loop_solo( self, "harass_loop", "stop_loop" );
	
	flag_wait_any( "price_activate_switch", "player_impulsive", "harasser_damaged", "player_entered_prison" );

	// React to the player
	self anim_stopanimscripted();
	s_align notify( "stop_loop" );
	
	thread drop_baton(s_align, m_baton);

	if(IsAlive(self))
	{
		self thread dialogue_queue( "castle_ru2_whatthehell" );
		self thread stop_animation_on_prison_guard_if_flashbang();
		self thread check_for_attacker_close();
		s_align anim_single_solo( self, "harass_react" );
	}
	
	if(IsAlive(self))
	{
		self thread anim_loop_solo( self, "blinded_react_loop" );
	}
}

drop_baton(s_align, m_baton)
{
	// Drop the baton
	s_align anim_single_solo( m_baton, "harass_drop" );
	s_align thread anim_loop_solo( m_baton, "harass_drop_idle" );	
}

//
//	Reactions for the prisoners, transition to a new idle
//harassed_prisoner_react( s_align )
harassed_prisoner_react()
{
	self endon( "death" );
	
	if ( IsDefined( level.scr_anim[ self.animname ][ "harass_react" ] ) )
	{
		self anim_single_solo( self, "harass_react" );
		self thread anim_loop_solo( self, "harass_end_loop" );
	}
}


//sets a flag if any of the harassing guards take damage
harasser_damage_watcher( harasser )
{
	level endon( "path_selected" );
	//waittill_dead( a_harassers, 1 );
	//waittill_any_ents( a_harassers[ 0 ], "damage", a_harassers[ 1 ], "damage", a_harassers[ 2 ], "damage" );
	
	self waittill( "damage", amount, attacker, direction_vec, point, type );
	
	flag_set( "harasser_damaged" );
}

has_player_killed_prematurely()
{
	self waittill("death");
	
	flag_set( "harass_guard_dead" );
	
	if( !flag( "price_activate_switch" ) )
	{
		flag_set( "player_impulsive" );
	}
	
}

animate_prisoners_in_multipath_cells_script_structs()
{
	level.a_prisoner_multipath_actors = [];
	sp_prisoner_spawner_multipath = GetEnt( "prisoner_spawner_multipath", "targetname" );
	a_s_anim_locations = GetStructArray( "struct_cell_prisoner", "targetname" );
	foreach( a_s_anim_location in a_s_anim_locations )
	{
		e_prisoner = sp_prisoner_spawner_multipath dronespawn();
		wait 0.05;
		
		level.a_prisoner_multipath_actors = array_add( level.a_prisoner_multipath_actors, e_prisoner );
		add_cleanup_ent( e_prisoner, "prison" );

		e_prisoner.name = "";
		e_prisoner.animname = "generic";
		a_s_anim_location thread anim_generic_loop( e_prisoner, a_s_anim_location.script_noteworthy );
	}
	thread prisoner_ambient_vo_setup();
	thread prisoner_kill_count();
}

prisoner_kill_count()
{
	level.prisoner_count_kill = 0;
	level.prisoner_count_kill_max = 4;
	
	level.friendlyfire[ "friend_kill_points" ] 	 = 0;
	level.friendlyfire[ "enemy_kill_points" ]	 = 0;
	
	for(i = 0; i < level.a_prisoner_multipath_actors.size; i++)
	{
		level.a_prisoner_multipath_actors[i] thread keep_track_prisoners();
	}	
	
	flag_wait("start_flare_room");
	level.prisoner_count_kill = 0;
}

keep_track_prisoners()
{
	level endon( "exited_prison" );
	//self endon("death");
	
	self waittill( "damage", amount, attacker, direction_vec, point, type );
		
    if( IsDefined( attacker ) && IsPlayer( attacker ))
    {
		level.friendlyfire[ "friend_kill_points" ] 	 = 0;
		level.prisoner_count_kill ++;
		if (level.prisoner_count_kill > level.prisoner_count_kill_max)
		{
			SetDvar( "ui_deadquote", &"CASTLE_KILLED_TOO_MANY_PRISONERS" );
			level thread missionFailedWrapper();
		}
     }
}

prisoner_ambient_vo_setup()
{

	pre_lights_out = [];
	pre_lights_out[0] = "castle_rup3_innocents";			//We are innocents!!!
	pre_lights_out[1] = "castle_rup2_doctor";				//We need a doctor!
	pre_lights_out[2] = "castle_rup2_letusout";				//Please - Let us out!
	pre_lights_out[3] = "castle_rup3_helpusplease";			//Help us, please!!!
	pre_lights_out[4] = "castle_rup1_help";					//Help!!!
	
	lights_out = [];
	lights_out[0] = "castle_cop1_whatshappening";			//What's happening?
	lights_out[1] = "castle_cop1_whoarethose";				//Who are those guys?
	lights_out[2] = "castle_cop1_setusfree";				//They're here to set us free!
	lights_out[3] = "castle_cop1_getusout";					//Get us out of here!
	lights_out[4] = "castle_cop1_abouttime";				//It's about time!
	lights_out[5] = "castle_rup1_whatsgoingon";				//What the hell is going on?!!
	lights_out[6] = "castle_rup2_outthere";					//Who is out there?!!

	flares_out = [];
	flares_out[0] = "castle_cop1_hurray";					//Hurray!
	flares_out[1] = "castle_cop1_yeah";						//Yeah!
	flares_out[2] = "castle_cop1_shootthe";					//Shoot the bastards!
	flares_out[3] = "castle_rup1_hereforus";				//Are you here for us?
	flares_out[4] = "castle_rup2_wecanhelp";				//We can help you!
	flares_out[5] = "castle_rup3_deathtomakarov";			//Death to Makarov!
	flares_out[6] = "castle_rup1_overhere";					//Over here!
	flares_out[7] = "castle_rup3_openthedoors";				//Open the doors!
	flares_out[8] = "castle_rup1_yes";						//Yes!!!!
	flares_out[9] = "castle_rup2_killthem";					//Kill them!  Kill them all!!
	
	level.prisoner_vo = [];
	level.prisoner_vo = array_combine( level.prisoner_vo, pre_lights_out);

	level.min_wait = 5.0;
	level.max_wait = 7.0;	
	
	thread prisoner_ambient_vo();
	
	flag_wait( "player_entered_prison" );
	level.prisoner_vo = array_combine( level.prisoner_vo, lights_out);
	
	for(i = 1; i <= (level.a_prisoner_multipath_actors.size - 20); i++)
	{
		level.prisoner_to_say_vo = add_to_array(level.prisoner_to_say_vo, level.a_prisoner_multipath_actors[i]);
	}
	
	level.min_wait = 2.0;
	level.max_wait = 3.5;
	
	flag_wait( "start_flare_room" );
	level.prisoner_vo = array_combine( level.prisoner_vo, flares_out);
	
	for(i = 1; i <= (level.a_prisoner_multipath_actors.size - 10); i++)
	{
		level.prisoner_to_say_vo = add_to_array(level.prisoner_to_say_vo, level.a_prisoner_multipath_actors[i]);
	}
	
	level.min_wait = 0.75;
	level.max_wait = 1.5;
}

prisoner_ambient_vo()
{
	level endon( "exited_prison" );
	last_line = -1;
	
	level.prisoner_to_say_vo = array_removeDead(level.prisoner_to_say_vo);

	while(level.prisoner_to_say_vo.size > 0)
	{
		vo_index = RandomInt(level.prisoner_vo.size);
		if (vo_index == last_line)
		{
			vo_index++;
			if (vo_index >= level.prisoner_vo.size)
				vo_index = 0;
		}
		random_vo = level.prisoner_vo[vo_index];

		play_sound_in_space(random_vo, level.prisoner_to_say_vo[RandomInt(level.prisoner_to_say_vo.size)].origin);
		last_line = vo_index;
		//IPrintLn(random_vo);
		wait(RandomFloatRange( level.min_wait, level.max_wait ));

		level.prisoner_to_say_vo = array_removeDead(level.prisoner_to_say_vo);
	}
	
}

guard_lights_out_vo()
{
	guard_lights_out_vo_1 = [];
	guard_lights_out_vo_1[0] = "castle_ru1_intruders";			//Intruders!!
	guard_lights_out_vo_1[1] = "castle_ru1_soundalarm";			//Sound the alarm!
	guard_lights_out_vo_1[2] = "castle_ru3_alertcommander";		//Alert the commander!	
	guard_lights_out_vo_1[3] = "castle_ru1_lockdown";			//Lock down the facility!
	guard_lights_out_vo_1[4] = "castle_ru2_powerback";			//Get the power back on!
	
	guard_lights_out_vo_2 = [];
	guard_lights_out_vo_2[0] = "castle_ru1_gunfire";			//We have gunfire!!!	
	guard_lights_out_vo_2[1] = "castle_ru2_spreadout";			//Spread out! Find them!!
	guard_lights_out_vo_2[2] = "castle_ru3_wherearethey";		//Where are they?
	guard_lights_out_vo_2[3] = "castle_ru1_findthem";			//Move!  Find them!!!	
	guard_lights_out_vo_2[4] = "castle_ru2_unidentified";		//Unidentified personnel have breached the facility!	
	
	
	flag_wait("price_activate_switch");
	
	level.guard_vo = [];
	level.guard_vo = array_combine( level.guard_vo, guard_lights_out_vo_1);
	
	level.guard_min_wait = 7.0;
	level.guard_max_wait = 12.0;	
	
	thread guard_ambient_vo();
	
	flag_wait( "harass_guard_dead" );
	level.guard_vo = array_combine( level.guard_vo, guard_lights_out_vo_2);
}

guard_ambient_vo()
{
	level endon( "notify_flareroom" );
	last_line = -1;
	
	while(1)
	{
		level.guard_to_say_vo = array_removeDead(level.guard_to_say_vo);
		
		if (level.guard_to_say_vo.size > 0)
		{
			vo_index = RandomInt(level.guard_vo.size);
			if (vo_index == last_line)
			{
				vo_index++;
				if (vo_index >= level.guard_vo.size)
					vo_index = 0;
			}
			random_vo = level.guard_vo[vo_index];

			play_sound_in_space(random_vo, level.guard_to_say_vo[RandomInt(level.guard_to_say_vo.size)].origin);
			last_line = vo_index;
			//IPrintLn(random_vo);
			wait(RandomFloatRange( level.guard_min_wait, level.guard_max_wait ));
		}
		else
		{
			return;
		}
	}
	
}

setup_animate_in_darkness()
{
	self endon( "death" );

	self enable_cqbwalk();
	self disable_long_death();
	self.animname = "generic";	
	self.allowdeath = true;
	self.allowpain = true;
	self.ignoreme = true;
	self thread price_sees_me();
	
	level.guard_to_say_vo = add_to_array(level.guard_to_say_vo, self);
	
	start_anim = self.animation + "_single";
	
	if ( IsAlive( self ) && IsDefined(self.animation))
	{
		self thread anim_generic_first_frame( self, start_anim );
	}
	
	flag_wait( "player_entered_prison" );

	if ( IsAlive( self ) && IsDefined(self.animation))
	{
		wait(RandomFloatRange(0.5,1.5));
		self thread anim_generic_loop( self, self.animation ); //add "stop_looping_anim"?
		self thread stop_animation_on_prison_guard_if_flashbang();
		self thread check_for_attacker_close();
	}
}

price_sees_me()
{
	trigger_wait_targetname( "price_into_prison" );
	level.price waittill("goal");
	if (isAlive(self))
	{
		self.ignoreme = false;
	}
}

spawn_stair_stumble_forward_guard()
{
	flag_wait( "player_entered_prison" );
	stair_stumble_forward_guard_ai = spawn_targetname( "stair_stumble_forward_guard" );
	s_align = get_new_anim_node( "dungeon_cell" );
	stair_stumble_forward_guard_ai thread stair_stumble_forward_guard(s_align);
}

stair_stumble_forward_guard(s_align)
{
	self endon("death");
	
	self enable_cqbwalk();
	self disable_long_death();
	self.animname = "generic";
	self.allowdeath = true;
	self.noragdoll = 1;
	self.ignoreme = 1;
	
	if ( IsAlive( self ) )
	{
		s_align thread anim_generic_first_frame( self, "stair_stumble_forward_guard" );
	}
	
	flag_wait_any( "stair_stumble_forward_guard_mid_trig", "stair_stumble_forward_guard_left_trig", "stair_stumble_forward_guard_right_trig" );
	
	//if player hits middle trigger
	if( flag( "stair_stumble_forward_guard_mid_trig" ) )
	{
		trig1 = GetEnt( "stair_stumble_forward_guard_left_targetname", "targetname" );
		trig2 = GetEnt( "stair_stumble_forward_guard_right_targetname", "targetname" );
		trig1 Delete();
		trig2 Delete();
		
		if ( IsAlive( self ) )
		{
			s_align thread anim_single_solo( self, "stair_stumble_forward_guard" );
			
			wait(0.05);
			
			anim_set_time( [self], "stair_stumble_forward_guard", .25 );
			
			self.ignoreme = 0;
			self thread stop_animation_on_prison_guard_if_flashbang();
			self thread check_for_attacker_close();
			self waittillmatch( "single anim", "end" );
			self anim_loop_solo(self,"corner_standR_alert_idle");
		}
	
	}
	//if player hits left trigger
	else if( flag( "stair_stumble_forward_guard_left_trig" ) )
	{
		trig1 = GetEnt( "stair_stumble_forward_guard_mid_targetname", "targetname" );
		trig2 = GetEnt( "stair_stumble_forward_guard_right_targetname", "targetname" );
		trig1 Delete();
		trig2 Delete();
		
		if ( IsAlive( self ) )
		{
			s_align thread anim_single_solo( self, "stair_stumble_forward_guard" );
			self.ignoreme = 0;
			self thread stop_animation_on_prison_guard_if_flashbang();
			self thread check_for_attacker_close();
			self waittillmatch( "single anim", "end" );
			self anim_loop_solo(self,"corner_standR_alert_idle");
		}
	}
	//if player hits right trigger
	else if( flag( "stair_stumble_forward_guard_right_trig" ) )
	{
		trig1 = GetEnt( "stair_stumble_forward_guard_mid_targetname", "targetname" );
		trig2 = GetEnt( "stair_stumble_forward_guard_left_targetname", "targetname" );
		trig1 Delete();
		trig2 Delete();
		
		if ( IsAlive( self ) )
		{
			s_align thread anim_single_solo( self, "stair_stumble_forward_guard" );
			self.ignoreme = 0;
			self thread stop_animation_on_prison_guard_if_flashbang();
			self thread check_for_attacker_close();
			self waittillmatch( "single anim", "end" );
			self anim_loop_solo(self,"corner_standR_alert_idle");
		}
	}
}

spawn_find_wall_guard()
{
	level endon( "end_find_wall_guard_trig" );
	
	flag_wait("find_wall_guard_spawn_trig");
	
	find_wall_guard_ai = spawn_targetname( "find_wall_guard" );
	level.find_wall_guard_lookat_trig trigger_on();
	s_align = get_new_anim_node( "dungeon_cell" );
	s_align thread anim_generic_first_frame( find_wall_guard_ai, "find_wall_guard" );
	find_wall_guard_ai thread find_wall_guard(s_align);
}

find_wall_guard(s_align)
{
	self endon("death");
	
	self enable_cqbwalk();
	self disable_long_death();
	self.animname = "generic";
	self.allowdeath = true;
	
	flag_wait("find_wall_guard_lookat");
	
	if ( IsAlive( self ))
	{
		s_align thread anim_single_solo( self, "find_wall_guard" );
		self thread stop_animation_on_prison_guard_if_flashbang();
		self thread check_for_attacker_close();
	}
}

spawn_stair_stumble_back_guard()
{	
	
	flag_wait_any( "stair_stumble_back_guard_mid_spawn", "stair_stumble_back_guard_right_spawn", "stair_stumble_back_guard_left_spawn" );
	
	if( flag( "stair_stumble_back_guard_mid_spawn" ) )
	{
		trig_to_delete = GetEnt( "stair_stumble_back_guard_right_spawn_targetname", "targetname" );
		trig_to_delete Delete();
		
		trig_to_delete = GetEnt( "stair_stumble_back_guard_left_spawn_targetname", "targetname" );
		trig_to_delete Delete();
		
		level.prison_path_end_mid_right trigger_on();
		level.prison_path_end_left Delete();
	}
	else if( flag( "stair_stumble_back_guard_right_spawn" ) )
	{
		trig_to_delete = GetEnt( "stair_stumble_back_guard_mid_spawn_targetname", "targetname" );
		trig_to_delete Delete();
		
		trig_to_delete = GetEnt( "stair_stumble_back_guard_left_spawn_targetname", "targetname" );
		trig_to_delete Delete();
		
		level.prison_path_end_mid_right trigger_on();
		level.prison_path_end_left Delete();
	}
	else if( flag( "stair_stumble_back_guard_left_spawn" ) )
	{
		trig_to_delete = GetEnt( "stair_stumble_back_guard_mid_spawn_targetname", "targetname" );
		trig_to_delete Delete();
		
		trig_to_delete = GetEnt( "stair_stumble_back_guard_right_spawn_targetname", "targetname" );
		trig_to_delete Delete();
		
		level.prison_path_end_left trigger_on();
		level.prison_path_end_mid_right Delete();
	}
	
	stair_stumble_back_guard_ai = spawn_targetname( "stair_stumble_back_guard" );
	stair_stumble_back_guard_ai.ignoreme = 1;
	s_align = get_new_anim_node( "dungeon_cell" );
	stair_stumble_back_guard_ai thread stair_stumble_back_guard(s_align);
	flag_wait( "multipath_end" );
	if(IsAlive(stair_stumble_back_guard_ai))
	{
		stair_stumble_back_guard_ai.ignoreme = 0;
	}
}

stair_stumble_back_guard(s_align)
{
	self endon("death");
	
	self enable_cqbwalk();
	self disable_long_death();
	self.animname = "generic";
	self.allowdeath = true;
	
	if ( IsAlive( self ) )
	{
		s_align thread anim_single_solo( self, "stair_stumble_back_guard" );
		self thread stop_animation_on_prison_guard_if_flashbang();
		self thread check_for_attacker_close();
		self waittillmatch( "single anim", "end" );
		self anim_loop_solo( self, "castle_dungeon_blind_idle_guard" );
	}
}

guard_stumble()	
{
	self endon( "death" );

	self enable_cqbwalk();
	self disable_long_death();
	self.animname = "generic";	
	self.allowdeath = true;
	self.ignoreme = 1;
	self.health = 1;
	self thread check_for_death();
	
	start_anim = self.animation + "_single";
	
	if ( IsAlive( self ) && IsDefined(self.animation))
	{
		self thread anim_generic_first_frame( self, start_anim );
	}
	
	flag_wait( "stumble_guy_go" );

	if ( IsAlive( self ) && IsDefined(self.animation))
	{
		wait(RandomFloatRange(0.0,2.0));
		self thread anim_generic_loop( self, self.animation );
		self thread stop_animation_on_prison_guard_if_flashbang();
		self thread guard_stumble_damage_watch();
		
		flag_wait_or_timeout("guard_stumble_shot", 1.5);
		self.ignoreme = 0;
		wait(6.5);
		if(IsAlive(self))
		{
			self kill();
			}
		}
	}

check_for_death()
{
	self waittill("death");
	
	flag_set( "guard_stumble_dead" );
}

guard_stumble_damage_watch()
{
	self endon("death");
	level endon( "guard_stumble_shot" );
	
	while(1)
	{
	self waittill( "damage", amount, attacker, direction_vec, point, type );
		
		if( IsDefined( attacker ) && IsPlayer( attacker ))
		{
				flag_set( "guard_stumble_shot" );
			}
		}
	}

guard_covercrouch_blindfire()
{
	self endon( "death" );

	self enable_cqbwalk();
	self disable_long_death();
	self.animname = "generic";	
	self.allowdeath = true;
	
	self thread guard_covercrouch_blindfire_idle_anims();
	self thread stop_animation_on_prison_guard_if_flashbang();
	self thread check_for_attacker_close();
	//self thread wakeup_blind_guards();
	
	flag_wait( "covercrouch_blindfire_trigger" );
	
	if ( IsAlive( self ) && IsDefined(self.animation))
	{
		self notify( "stop_looping_anim" );
		self anim_single_solo( self, self.animation );
		self thread guard_covercrouch_blindfire_idle_anims();
	}
}

guard_covercrouch_blindfire_idle_anims()
{
	self endon("death");
	level endon("covercrouch_blindfire_trigger");
	level endon( "covercrouch_blindfire_1_alerted" );
	
	while(1)
	{
		self thread anim_generic_loop(self, "covercrouch_hide_idle", "stop_looping_anim");
		wait(RandomFloatRange(0.5, 3.5));
		self notify( "stop_looping_anim" );
		if (flag("covercrouch_blindfire_trigger"))
		{
			twitch_anim =  "cover_twitch_0" + randomintrange(1,3); // randomly choose between the two anims
		}
		else
		{
			twitch_anim =  "cover_twitch_01";
		}
		self anim_single_solo( self, twitch_anim );
	}
}
/*
wakeup_blind_guards()
{
	self endon("death");
	
	flag_wait( "start_flare_room" );
	
	if (isAlive(self))
	{
		//self notify("stop_looping_anim");
		self anim_stopanimscripted();
	}
	
	while(1)
	{
		if (IsAlive(self))
		{
			self SetGoalEntity( level.player );
			self.goalradius = 64;
		}
		wait( 0.25 );
	}
}
*/
/*
//makes AI in multipath room retreat first. When the player picks a path the guys in the halls will run to their guard nodes
//nodes are behind them so they run away.
fight_in_darkness()
{
	self endon( "death" );

	//self thread ai_force_alertness();

	self enable_cqbwalk();
	self disable_long_death();

	// If the player was impulsive, then we don't need to make them weak
	if ( flag( "player_impulsive" ) )
	{
		return;
	}
	// Otherwise, 
	else if ( !flag("price_activate_switch") )
	{
		level endon( "player_impulsive" );

		self set_ai_guard_passive( true, 32 );
		self enable_ai_color();
		self.goalradius = 32;
		self waittill( "goal" );
	}

	self.dontmelee = 1;
	self set_ai_guard_passive( false, 64 );
	self set_baseaccuracy( 0.35 );
	self enable_heat_behavior();
	self.rambochance = 1;
	
	if ( flag( "start_flare_room" ) )
	{
		return;
	}
	level endon( "start_flare_room" );

	// Now become blind to the player and Price unless something spooks you
//	self thread aim_nervously();
	self thread check_for_attacker_close();
	self addAIEventListener( "bulletwhizby" );
	while( 1 )
	{
  		self waittill( "ai_event", event_type, attacker );

  		if ( event_type == "damage" || event_type == "bulletwhizby" )
  		{
  			// reaction time
			wait( 0.4 );
			
			// Sense where the player is and shoot if you can
//			self notify( "stop_aiming" );
			self ClearEntityTarget();
//			self disable_dontevershoot();
			if ( IsAlive(attacker) && attacker.team == "allies" )
			{
				self anim_stopanimscripted();
				attacker thread attacker_detected();
				self GetEnemyInfo( attacker );
				return;
			}
//			else
//			{
//				self.animname = "guard1";
//				self thread anim_custom_animmode_solo(self, "gravity", "blinded_react_loop");	
//			}
			wait( RandomFloatRange( 4.0, 8.0 ) );	// Is he still there?
			self.animname = "guard1";
			self thread anim_custom_animmode_solo(self, "gravity", "blinded_react_loop");	
			
			// Go back to scanning
//			self thread aim_nervously();
  		}
	}
}
*/
//
//	Monitor for someone near you
check_for_attacker_close()
{
	self endon( "notify_flareroom" );
	self endon( "death" );
	n_visible_distance_sq = level.darkness_maxVisibleDist * level.darkness_maxVisibleDist;
	//a_enemies = [ level.player, level.price ];
	a_enemies = [level.player];
	while (1)
	{
		foreach( e_enemy in a_enemies )
		{
			if ( DistanceSquared( self.origin, e_enemy.origin ) <= n_visible_distance_sq &&
			    self CanSee( e_enemy ) )
			{
				if ((IsDefined(self.animation) && self.animation == "covercrouch_blindfire_1"))
				{
					flag = self.animation + "_alerted";
					flag_set(flag);
					self notify("stop_looping_anim");
				}
				self anim_stopanimscripted();
				self disable_ai_color();
				self SetGoalEntity( e_enemy );
				//self.goalradius = 64;
				//self SetGoalPos( self.origin );
				self.goalradius = 30;
				
				e_enemy thread attacker_detected();
				//wait( 10 );
				//wait( RandomFloatRange( 4.0, 8.0 ) );

				//self SetGoalPos( self.origin );
				//self.goalradius = 256;
			}
			else
			{
				/*
				if(flag("enemy_alerted"))
				{
					flag_clear("enemy_alerted");
					self SetGoalPos( self.origin );
					self.goalradius = 256;
				
					self thread animate_in_darkness();
				}
				*/
			}
		}
		wait( 0.25 );
	}
}


//	Keeps track of enemy detections, one thread for each occurance
//	self is either the player or Price
attacker_detected()
{
	self endon( "notify_flareroom" );
	self endon( "death" );
	
	self.n_detections++;
	self.maxVisibleDist = 800;
	// Let people shoot at you for a bit
	wait( RandomFloatRange( 4.0, 6.0 ) );	

	// Now let the attacker disappear again
	// but only after the last detection report.
	//	This prevents the attacker from becoming invisible too soon.
	self.n_detections--;
	if ( self.n_detections == 0 )
	{
		self.maxVisibleDist = level.darkness_maxVisibleDist;
	}
}


/*
//	Make the AI shift around their aiming nervously
//	self is an enemy AI
aim_nervously()
{
	self endon( "death" );
	self endon( "stop_aiming" );
	
	n_index = RandomInt( level.e_darkness_targets.size );
	e_curr_target = level.e_darkness_targets[ n_index ];
	//self enable_dontevershoot();
	while ( !flag( "start_flare_room" ) )
	{
		b_trace = BulletTracePassed( self GetEye(), e_curr_target.origin, false, undefined );
		n_distance = Distance2D( self.origin, e_curr_target.origin );
		if ( b_trace && n_distance > 85 )
		{
			self SetEntityTarget( e_curr_target, 0.8, false, undefined );
			wait( RandomFloatRange( 1.5, 2.5 ) );
		}
		
		// Advance to the next target
		n_index++;
		if ( n_index >= level.e_darkness_targets.size )
		{
			n_index = 0;
		}
		e_curr_target = level.e_darkness_targets[ n_index ];
		wait( 0.05 );
	}
}
*/


// Gives AI some sensibility to make things tougher for the player
// self is an AI enemy
ai_force_alertness()
{
	self endon( "death" );
	
	flag_wait( "player_impulsive" );

	self set_ai_guard_passive( false, 384 );
	self disable_ai_color();
	self.ignoresuppression = true;
	self.aggressivemode = true;

	if ( self.script_aigroup == "prison_halls_a" )
	{
		level.player attacker_detected();
		level.price attacker_detected();

		self set_baseaccuracy( 0.5 );
		// Move to ambush position
		e_goalvol = GetEnt( "prison_ambush_goalvol", "targetname" );
		self.goalradius = 512;
		self.combatmode = "ambush";
		self GetEnemyInfo( level.player );
		self SetGoalPos( e_goalvol.origin );
		self SetGoalVolume( e_goalvol );
	}
	else
	{
		self SetGoalEntity( level.player, 2 );
		self.goalradius = 384;
	}
}


//self is trigger, set a flag to indicate which path the player took in multipath room
select_path()
{
	self endon( "death" );
	self waittill( "trigger" );
	level.t_path_taken = self;
	flag_set( "path_selected" );
	flag_set( "stop_prison_nvg_nag" );
}	


//////////////////////////////////////////////////////////////////////////////
// Flare Room Functions	
//////////////////////////////////////////////////////////////////////////////


//	Controls how the flares populate the room.
//
flare_sequence()
{
	level thread toss_flare( "flare_toss_6", "light_flare_6" );
	level thread toss_flare( "flare_toss_5", "light_flare_5" );
	level thread toss_flare( "flare_toss_4", "light_flare_4" );
	level thread toss_flare( "align_flare_room", "light_flare_3", "guard_flare_toss3" );
}


//	Spawn a flare model and throw it.
//	The effect has a dynamic light while it's in the air.
//	After it lands, switch to a non-dynamic light FX with sparks
//	 and start the baked-in dynamic light flickering
toss_flare( str_origin, str_light, str_animname )
{
	s_origin = GetStruct( str_origin, "targetname" );
	if ( !IsDefined( s_origin ) )
	{
		s_origin = GetEnt( str_origin, "targetname" );
	}
	
	m_flare = Spawn( "script_model", s_origin.origin );
	m_flare SetModel( "ctl_emergency_flare_animated" );
	array_add( level.a_m_flares, m_flare );
	add_cleanup_ent( m_flare, "prison" );
	m_flare ent_flag_init( "landed" );
	
	aud_send_msg("toss_flare", m_flare);	
	
	PlayFXOnTag( level._effect["fx_flare_trail"], m_flare, "TAG_FIRE_FX" );

	// fly through the air, either via anim or structs
	if ( IsDefined( str_animname ) )
	{
		m_flare.animname = "flare";
		m_flare assign_animtree();

		s_align = get_new_anim_node( str_origin );
		s_align anim_single_solo( m_flare, str_animname );
	}
	else
	{
		n_time = 1.0;
		while ( IsDefined( s_origin.target) )
		{
			s_dest = GetStruct( s_origin.target, "targetname" );
			if ( IsDefined( s_origin.script_float ) )
			{
				n_time = s_origin.script_float;
			}
			else
			{
				n_time = 1.0;
			}
			m_flare MoveTo( s_dest.origin, n_time );
			if ( IsDefined( s_dest.angles ) )
			{
				m_flare RotateTo( s_dest.angles, n_time );
			}
			s_origin = s_dest;
			wait( n_time );
		}
	}
	wait( 0.05 );	// let the object settle
	
	// Now switch effects
	StopFXOnTag( level._effect["fx_flare_trail"], m_flare, "TAG_FIRE_FX" );
	PlayFXOnTag( level._effect["fx_flare_ambient"], m_flare, "TAG_FIRE_FX" );
	exploder( 833 );     //Spawn flare haze fx
	
    m_flare ent_flag_set( "landed" );
    
	// Activate the dynamic light
	e_light = GetEnt( str_light, "targetname" );
	if ( IsDefined( e_light ) )
	{
		e_light thread flare_flicker();
	}
}


//animation of guy throwing flare
animate_flare_thrower()
{
	wait 0.5;

	//prep the guard to play the animation
	e_flare_toss_spawn = GetEnt( "enemy_flare_throw", "targetname" );
	ai_flare_thrower = e_flare_toss_spawn spawn_ai();
	if ( spawn_failed( ai_flare_thrower ) )
	{
		return;
	}

	ai_flare_thrower set_ignoreme( true );
	ai_flare_thrower.animname = "generic";

	//play animation of flare toss
	s_align = get_new_anim_node( "align_flare_room" );
	s_align thread anim_single_solo( ai_flare_thrower, "guard_flare_toss" );
	flag_set( "price_say_flare" );
	level toss_flare( "align_flare_room", "light_flare_1", "guard_flare_toss" );
	
	if (flag("nvg_on"))
	{
		thread nvg_blowout(true);
	}
	else
	{
		thread nvg_blowout();	
	}
	
	//move him downstairs
	ai_flare_thrower SetGoalVolumeAuto( GetEnt( "prison_B2", "targetname" ) );
	ai_flare_thrower set_ignoreme( false );

	// Spawn extra support guys moving up.
	a_sp_support = GetEntArray( "enemy_flare_throw_support", "targetname" );
	foreach( sp_guy in a_sp_support )
	{
		sp_guy spawn_ai();
	}
	
	level thread toss_flare( "align_flare_room", "light_flare_2", "guard_flare_toss2" );
}

nvg_blowout(nvg_on_now)
{
	level endon("exited_prison");
	
	if(IsDefined(nvg_on_now))
	{
		VisionSetNight( "castle_nvg_blowout", .5 );
	}
	
	while(1)
	{
		level.player waittill( "night_vision_on" );
		VisionSetNight( "castle_nvg_blowout");
		
		level.player waittill( "night_vision_off" );
		wait(0.05);
	}
}

//
//	Simulate the flickering of the flare
//	self is a dynamic light
flare_flicker()
{
	level endon( "exited_prison" );

	self SetLightColor( (0.9, 0.44, 0.44) );
	v_curr_color 		= self GetLightColor();
	v_target_color 		= (1.0, 0.5, 0.5);
	n_transition_time 	= 2000;
	n_start_time 		= GetTime();

	while (1)
	{
		//	Slowly account for any differences in the effect color and what we want 
		//	the final light color to be so there's no pop.
		if ( v_curr_color != v_target_color )
		{
			n_fraction = (GetTime() - n_start_time) / n_transition_time;
			if ( n_fraction >= 1.0 )
			{
				v_curr_color = v_target_color;
			}
			else
			{
				v_curr_color = VectorLerp( v_curr_color, v_target_color, n_fraction );
			}
			self SetLightColor( v_curr_color );
		}

		// Adjust the light intensity to simulate flickering
		if ( level.player ent_flag( "nightvision_on" ) )
		{
			self SetLightIntensity( RandomFloatRange( 4.0, 6.2 ) );
		}
		else
		{
			self SetLightIntensity( RandomFloatRange( 1.3, 2.0 ) );
		}

		wait( RandomFloatRange( 0.05, 0.10 ) );
	}
}


////handles the animation for the meatshield event in the rec room
rec_room_meatshield()
{
	s_align = get_new_anim_node( "align_flare_room" );
	e_spawn_meatshield_guard = GetEnt( "spawner_meatshield_guard", "targetname" );
	e_spawn_meatshield_victim = GetEnt( "spawner_meatshield_prisoner", "targetname" );

	//wait until tthe player gets to the hallway just before the rec room	
	flag_wait( "meatshield_start" );
	level thread clear_prison_ai();
	
	
	//checkpoint
	autosave_by_name( "meatshield_room" );
	
	ai_guard = e_spawn_meatshield_guard spawn_ai();
	ai_prisoner = e_spawn_meatshield_victim spawn_ai();
	if ( spawn_failed( ai_guard ) || spawn_failed( ai_prisoner ) )
	{
		return;
	}
	
	//set up animations
	ai_guard.animname = "meatshield_guard"; 
	ai_guard set_ignoreme( true );
	ai_guard deletable_magic_bullet_shield();

	ai_prisoner.animname = "meatshield_prisoner";
	ai_prisoner set_ignoreme( true );
	ai_prisoner deletable_magic_bullet_shield();
	ai_prisoner.name = "";
	ai_prisoner.team = "neutral";
	
	//play animations for intro of meatshield
	level thread meatshield_anim( s_align, ai_guard, ai_prisoner );
	//run watcher threads for meatshield outcome
	level thread guard_died_watcher( s_align, ai_guard, ai_prisoner );
	level thread prisoner_dies_watcher( s_align, ai_guard, ai_prisoner );
	level thread meatshield_resolution( s_align, ai_guard, ai_prisoner );
	
	level thread check_player_distance( ai_guard );
	level thread check_for_grenade_flashbang( ai_guard );
}

check_for_grenade_flashbang( ai_guard )
{
	level endon( "meatshield_done" );
	ai_guard endon( "death" );
	
	ai_guard waittill_any("flashbang", "grenade danger" );
	flag_set("neither_died");

	
}

check_player_distance( ai_guard )
{
	level endon("meatshield_done");
	ai_guard endon("death");
	
	while(1)
	{
		if( DistanceSquared(level.player.origin, ai_guard.origin) < 250 * 250 )
		{
			flag_set("neither_died");
			return;
		}
		wait(0.05);
	}
}

clear_prison_ai()
{
	a_enemies = GetAIArray( "axis" );
	
	foreach( e_enemy in a_enemies )
	{
		if( IsAlive( e_enemy ) )
		{
			e_enemy Kill();
			wait 1;
		}
	}
}


// 
//	Guy comes out using prisoner as a shield
meatshield_anim( s_align, ai_guard, ai_prisoner )
{
	level endon( "meatshield_done" );
	
	ai_guard thread meatshield_shooting();
	ae_meatshield_actors = [ ai_guard, ai_prisoner ];
	s_align anim_single( ae_meatshield_actors, "meatshield_start" );
	s_align thread anim_loop( ae_meatshield_actors, "meatshield_idle", "stop_meatshield_idle" );
}


//
//	Fake shooting from the guard
meatshield_shooting()
{
	self endon( "damage" );
	self endon( "death" );
	level endon ( "meatshield_done" );
	
	// Make the guard shoot!
	while (1)
	{
		v_player_eye = level.player GetEye();
		b_trace = BulletTracePassed( v_player_eye, self GetEye(), false, undefined );
		if ( b_trace )
		{
			n_shots = RandomIntRange( 2, 6 );
			for( i=0; i<n_shots; i++ )
			{
				self Shoot( 1.0, v_player_eye );
				wait( 0.05 );
			}
		}
		wait( RandomFloatRange( 0.5, 2.0 ) );
	}
}


//
//watches if the prisoner is alive but the guard dies. plays an anim
guard_died_watcher( s_align, ai_guard, ai_prisoner )
{
	level endon( "meatshield_done" );

	ai_guard waittill( "damage" );

	flag_set( "guard_died" );
}


//
//watches if the prisoner dies then plays an anim
prisoner_dies_watcher( s_align, ai_guard, ai_prisoner )
{
	level endon( "meatshield_done" );

	ai_prisoner waittill( "damage" );

	flag_set( "prisoner_died" );
}


//
//	Somebody dies, but who?
meatshield_resolution( s_align, ai_guard, ai_prisoner )
{
	//hold until player resolves
	flag_wait_any( "guard_died", "prisoner_died" , "neither_died");
	wait( 0.1 );

	// 	This has a short time to resolve if it's a double kill
	flag_set( "meatshield_done" );
	
	ai_guard 	stop_magic_bullet_shield();
	ai_prisoner	stop_magic_bullet_shield();
	s_align notify( "stop_meatshield_idle" );

	// Double Kill
	if ( flag( "guard_died" ) && flag("prisoner_died" ) )
	{
		ai_guard thread meatshield_death( "meatshield_double_kill" );
		ai_prisoner thread meatshield_death( "meatshield_double_kill" );
	}
	else if ( flag( "guard_died" ) && !flag( "prisoner_died" ) )
	{
		ai_guard anim_stopanimscripted();
		ai_guard die();

		ai_prisoner anim_stopanimscripted();	
		
//		s_align anim_single_solo( ai_prisoner, "meatshield_survives" );
//		s_align anim_loop_solo( ai_prisoner, "meatshield_survives_idle" );
	}
	else if( flag("neither_died") )
	{
	  ai_guard anim_stopanimscripted();
	  ai_prisoner anim_stopanimscripted();	       	
	}
	else // prisoner_died
	{
		ai_guard anim_stopanimscripted();
		
		ai_prisoner thread meatshield_death( "meatshield_dies" );
	}
}


//	Play unaligned death anim and die
//
meatshield_death( str_anim )
{
	//self thread anim_single_solo( self, str_anim );
	
	//self.a.nodeath = true;
	self.noragdoll = true;
	self set_allowdeath(true);
	self die();
}

////////////////////////////////////////////////////////////////////////////
//	MISCELLANEOUS UTILITY AND DIALOG FUNCTIONS
////////////////////////////////////////////////////////////////////////////

monitor_price_prison_behavior()
{
	self enable_cqbwalk();
	self.pacifist = 0;
	self disable_pain();
	self disable_surprise();
	self disable_bulletwhizbyreaction();
	self set_ignoreSuppression( true );
	self.aggressivemode = true;
	
	level.price price_prison_behavior( "prison_tame" );
	
	flag_wait( "harass_guard_dead" );
	level.price price_prison_behavior( "prison_beast" );
	
	flag_wait( "guard_stumble_dead" );
	level.price price_prison_behavior( "prison_tame" );
}
	
//
//	Make him a badass, no long pains or reactions
price_prison_behavior( str_section )
{
	switch( str_section )
	{
		case "flare_room":
			self enable_cqbwalk();
			self.pacifist = 0;
			self enable_pain();
			self enable_surprise();
			self enable_bulletwhizbyreaction();
			self set_ignoreSuppression( false );
			self.aggressivemode = false;
			self.baseaccuracy = 1;
			self.ignoreme = false;
			break;
			
		case "prison_tame":
			self.baseaccuracy = 0.5;
			break;
			
		default:
			self.baseaccuracy = 100;
			break;
	}
}

//self is AI: sets ignore and goal radii
set_ai_guard_passive( is_passive, n_goalradius  )
{
	if ( !IsAlive(self) )
	{
		return;
	}
	
	AssertEx( IsDefined( is_passive ), "is_passive not defined" );
	AssertEx( IsDefined( n_goalradius ), "n_goalradius not defined" );	
	
	self set_goal_radius( n_goalradius );
	
	if ( is_passive )
	{
		self set_ignoreall( true );
		self set_battlechatter( false );
	}
	else
	{
		self set_ignoreall( false );		
		self set_battlechatter( true );
	}
}


//
//
cleanup_security_office()
{
	ae_cleanup = GetEntArray( "cleanup_security_office", "script_noteworthy" );
	ae_spawners = GetEntArray( "guard_security_office", "targetname" );
	ai_chair = get_ai_group_ai( "security_office" );
	ae_cleanup = array_combine_unique( ae_cleanup, ae_spawners ); 
	ae_cleanup = array_combine_unique( ae_cleanup, ai_chair ); 
	
	//delete the fake character in security office.
	//add check for skiptos
	if( isdefined( level.fake_security_character ) )
	{
		level.fake_security_character delete();
	}
	
	array_delete( ae_cleanup );
	
	
	//kill bink video
	level notify("kill_security_cinematic");
	
	StopCinematicInGame();
	
}

prison_cleanup()
{
	ae_cleanup = GetEntArray( "cleanup_prison", "script_noteworthy" );
	ae_spawners = GetEntArray( "spawner_harass_scene", "targetname" );

	ae_cleanup = array_combine_unique( ae_cleanup, ae_spawners ); 
	if ( IsDefined( level.a_prisoner_multipath_actors ) )	// check needed in case we're using a skipto.
	{
		ae_cleanup = array_combine_unique( ae_cleanup, level.a_prisoner_multipath_actors );	
	}

	for (i = 0; i < ae_cleanup.size; i++ )
	{
		if ( IsDefined( ae_cleanup[ i ] ) )
		{
			ae_cleanup[ i ] Delete();
		}
	}

	stop_exploder( 831 );
	stop_exploder( 832 );
	stop_exploder( 833 );
	stop_exploder( 702 );
	
	// Startup the base spotlights again
   level thread maps\castle_courtyard_activity::base_lights_on( level.price );
 
}


// FUNCTIONS TO HANDLE DIALOUGE 
// Security Room - outside office until just inside the cage
//	self is Price
price_dialogue_security_office()
{
	self endon( "death" );
	
	flag_wait( "objective_clear_prison" );

	// Waiting for player to get near the security office	
	a_nag_lines = make_array( "castle_pri_cmon", "castle_pri_overhere");
	nag_vo_until_flag( a_nag_lines, "price_say_door_open", 15, false, false );
	
	self dialogue_queue( "castle_pri_illhandle" );
}


// Setting up the power cutting scene
//	self is price
price_cut_the_power_vo()
{
	self endon( "death" );
	level endon( "player_impulsive" );
	level endon( "player_entered_prison" );
	
	flag_wait( "price_say_waitforlights" );

	self dialogue_queue( "castle_pri_nightvisionon" );		//Night-vision on.
	
	level.price.lastheadmodel = level.price.headmodel;
	self thread wait_till_offscreen_then_switch_head_models("head_price_europe_c_nvg", "start_flare_room");
	/*
	// Switch to head with nvg
	level.price.lastheadmodel = level.price.headmodel;
	level.price Detach( level.price.headmodel, "" );

	head = "head_price_europe_c_nvg";
	level.price Attach( head, "", true );
	level.price.headModel = head;	
	*/
	thread nvg_hint();
	self dialogue_queue("castle_pri_takecare");				//I'll take care of the lights.	
	
	flag_wait( "price_say_ready" );

	self dialogue_queue( "castle_pri_ready" );				//Ready?
}

nvg_hint(turnoff)
{	
	wait(1);
	
	if(!IsDefined(turnoff))
	{
		turnoff = false;	
	}
	
	if(turnoff)
	{
		if (flag("nvg_on"))
		{
			level.player thread display_hint_timeout( "disable_nvg", 3);
		}
	} 
	else if (!turnoff)
	{
		if ( !flag( "nvg_on" ) )
		{
			level.player display_hint( "nvg" );
			flag_wait_or_timeout( "nvg_on", 3 );
		}
	}
}


//conditional VO for the powerswitch event. Depends on what the player does before the switch is put out.
// self is Price
price_impulsive_vo()
{
	self endon( "death" );

	flag_wait_any( "price_activate_switch", "player_impulsive", "player_entered_prison" );
	
	if ( flag( "price_activate_switch" ) )
	{
		wait(1);
		self dialogue_queue( "castle_pri_weaponsfree" );
	}
	else	// player did something before he pulled the switch
	{
		if ( !flag( "player_impulsive" ) )
		{
			flag_set( "player_impulsive" );
		}
		//self dialogue_queue( "castle_pri_shit3" );
		//self dialogue_queue( "castle_pri_whatareyoudoing" );
		flag_set( "at_power_switch" );
		
	}
}

//Price tells the player to pick a path through the multipath room and he will pick an opposing path.
//Reminds the player to use NVG
//	self is Price
price_dialogue_prison()
{
	self endon( "death" );

	flag_wait( "price_say_endtheirdays" );
	
	wait(1.5);	
	self dialogue_queue( "castle_pri_quiet" );			//Quiet . . . 

	//price says different stuff based on player rushing in or killing too soon
	level.price thread price_cut_the_power_vo();
	level.price price_impulsive_vo();
	
	level endon( "price_say_flare" );
	
	flag_wait( "price_say_split_up" );
	wait( 2.0 );
	
	self dialogue_queue("castle_pri_sweepthrough");		//Sweep through this area fast.	
	self dialogue_queue("castle_pri_howfew");			//They won't know how few we are in the dark.
	//battlechatter_on( "allies" );
	battlechatter_off( "allies" );
	level.price set_ai_bcvoice( "seal" );
	//level.price thread set_battlechatter( true );
}


//
//	From the flare toss to the exit
// 	self is Price
price_dialogue_flare_room()
{
	flag_wait( "price_say_flare" );
	wait( 3.0 );	// Give the flare time to live before Price reacts to it
	
	self dialogue_queue( "castle_pri_usingflares" );	//They're using flares!
	wait( 1.0 );
	
	self dialogue_queue( "castle_pri_oldway" );	//Take your night-vision off.  We'll do this the old way.
	
	if(IsDefined(level.price.lastheadmodel) && level.price.headmodel == "head_price_europe_c_nvg")
	{
		self thread wait_till_offscreen_then_switch_head_models(level.price.lastheadmodel, "exited_prison");
	}

	thread nvg_hint(true);
	level.price set_ai_bcvoice( "taskforce" );
	battlechatter_on( "allies" );

	flag_wait( "price_say_wave2" );

	self dialogue_queue( "castle_pri_reinforcements2" );	//They're bringing in reinforcements!

	//flag_wait( "price_say_wave3" );

	//self dialogue_queue( "castle_pri_rightside" );
	
	thread nag_before_meatshield();

	flag_wait( "meatshield_start" );
	
	flag_wait_any( "prisoner_died", "guard_died", "neither_died" );
	
	if(flag("prisoner_died"))
	{
		self dialogue_queue( "castle_pri_nevermind" );		//He never would have made it anyway.
	}
	else if(flag("guard_died"))
	{
		self dialogue_queue( "castle_pri_getoutofhere2" );	//Get out of here.  GO!	
	}
	
	/*
	if ( flag( "guard_died" ) && !flag( "prisoner_died" ) )
	{
		self dialogue_queue( "castle_pri_getoutofhere2" );	//Get out of here.  GO!	
	}
	else if ( flag( "prisoner_died" ) )
	{
		self dialogue_queue( "castle_pri_nevermind" );		//He never would have made it anyway.
	}
	*/
	
	flag_wait( "price_say_finddead" );		
	
	self dialogue_queue( "castle_pri_tenminutes" );			//We have about ten minutes until they find their dead.	

	wait 10.5;
	
	if( !flag( "exited_prison" ) )
	{
		self dialogue_queue( "castle_pri_fallbehind" );
	}
}

nag_before_meatshield()
{
	flag_wait( "start_price_nag_before_meatshield" );
	
	if(!flag("meatshield_start"))
	{
		self dialogue_queue( "castle_pri_onpoint" );
	
		// Waiting for player to move down hall
		a_nag_lines = make_array( "castle_pri_startmoving", "castle_pri_onpoint" );
		nag_vo_until_flag( a_nag_lines, "meatshield_start", 15, false, false );
	}
}

wait_till_offscreen_then_switch_head_models(head, endon_flag)
{
	level endon(endon_flag);
	
	price_is_offscreen = false;
	while(!price_is_offscreen)
	{
		if ( !within_fov_2d(level.player.origin,level.player.angles,self.origin,Cos(45)) )
		{
			price_is_offscreen = true;
		}
		else
		{
			wait(0.1);
		}
	}
	
	// Switch to head without nvg
	level.price Detach( level.price.headmodel, "" );

	level.price Attach( head, "", true );
	level.price.headModel = head;
}



//
//	Switches the dlight effect for NVGs so you can see better inside the prison
//	NOTE: Currently it won't actually swap unless you turn the NVGs off and on again.
swap_nvg_fx()
{
	old_fx = level.nightVision_DLight_Effect;
	level.nightVision_DLight_Effect = level._effect[ "nvg_dlight"];
	flag_wait( "exited_prison" );
	
	level.nightVision_DLight_Effect = old_fx;
}
