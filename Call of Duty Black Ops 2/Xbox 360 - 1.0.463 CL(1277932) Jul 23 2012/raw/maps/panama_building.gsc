#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\panama.gsh;

skipto_building()
{
	skipto_setup();
	
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	skipto_teleport( "player_skipto_building", a_heroes );	
	
	//flag_wait( "panama_gump_3" );
	
	//wait 1;
}

main()
{
	//flag_wait( "panama_gump_3" );
	//audio notify to keep level sounds down except for music at the beginning
	level clientnotify("lsmn");
	
	flag_set( "panama_building_start" );
	level.player freeze_player_controls(true);
	level thread screen_fade_in(4);
	level thread old_man_woods( "panama_3_load", "lsn" );
	

	setmusicstate ("PANAMA_HAUNTED_HOUSE");

	//update the handle on the heroes
	level.mason = init_hero( "mason" );
	level.mason change_movemode();
	level.noriega = init_hero( "noriega" );
	level.noriega change_movemode();

//	SetSavedDvar( "r_enableFlashlight", "1" );
	//	set_custom_flashlight_values( range, startRadius, endRadius, FOVInnerFraction, brightness, offset, color )
	//set_custom_flashlight_values( 840, 16, 227.917, 0.700035, 8.02644, (2.8977, 6.76, -0.277745), (0.851611, 0.990459, 0.90554), (1, 1.5, 1) );
	// event setup
	level thread start_crying_woman();
	
	level thread building_dialog();
	
	// event flow
	
	clinic_spookies();
	level thread clinic_move_heroes();	// threaded in case player sprints through
	
	
	//wait for fade and unfreeze player
	wait(4);
	level.player freeze_player_controls(false);
	
	digbat_tackle();
	digbat_gauntlet();
	
	if(!flag("player_moved_during_gauntlet"))
	{
		level thread gauntlet_recover();
	}
	building_stairwell();
}

init_flags()
{
	flag_init( "panama_building_start" );
	flag_init( "player_at_clinic" );
	flag_init( "clinic_enter_hall_1" );
	flag_init( "clinic_enter_hall_2" );
	
	flag_init( "clinic_ceiling_collapsed" );
	
	flag_init( "post_gauntlet_player_fired" );
	flag_init( "post_gauntlet_mason_open_door" );
}

/*************************************************************************************************************
	Clinic Walk
*************************************************************************************************************/
clinic_move_heroes()
{
	level endon( "digbat_tackle_started" );
	
//	m_gurney = GetEnt( "clinic_gurney", "targetname" );
//	m_gurney_clip = GetEnt( "clinic_gurney_clip", "targetname" );
//	m_gurney_clip LinkTo( m_gurney );
	
	//run_scene_first_frame( "clinic_gurney" );
	
//	level thread run_scene( "clinic_walk_start_idle" );	// idle outside the clinic
	
//	flag_wait( "player_at_clinic" );					// set by one of two triggers
	
	wait 1;
	
	run_scene( "clinic_walk_door_to_idle" ); 		// from outside to the first stop point
	level thread run_scene( "clinic_walk_idle_1" ); // first stop point idle
	
	flag_wait( "clinic_enter_hall_1" );				// set by trigger (targetname clinic_enter_hall_1)
	run_scene( "clinic_walk_move_to_idle2" );		// move through first hall
	level thread run_scene( "clinic_walk_idle_2" );	// second stop point idle
	
	flag_wait( "clinic_enter_hall_2" );				// set by trigger (targetname clinic_enter_hall_2)
	//level thread run_scene( "clinic_gurney" );
	run_scene( "clinic_walk_path_v1" );			// run to the last stop point
	level thread run_scene( "clinic_walk_end_idle_v1" ); // idle at the end after no react
}

//clinic_door_kicked_in()
//{
//	m_door_clip = GetEnt( "clinic_frontdoor_clip", "targetname" );
//	m_door = GetEnt( "clinic_frontdoor", "targetname" );
//	
//	m_door LinkTo( m_door_clip );
//
//	m_door_clip RotateYaw( 100, 0.7, 0.0, 0.5 );
//
//	//if the player is close shake camera and controller rumble
//	n_distance = Distance2D( m_door.origin, level.player.origin );
//	if( n_distance < 200 )
//	{
//		Earthquake(0.1, 0.5, level.player.origin, 256);
//		level.player PlayRumbleOnEntity( "damage_light" );
//	}
//
//	m_door_clip waittill("rotatedone");
//	m_door_clip RotateYaw( -3, 0.5, 0.0, 0.2 );
//}

clinic_spookies()			// feel free to rename
{
//	autosave_by_name( "clinic_entrance" );
	exploder(106);
	level thread clinic_ceiling_collapse();
	level thread clinic_light_shake();
	level thread maps\createart\panama3_art::clinic();
}


clinic_ceiling_collapse()	
{
	//set by one of two triggers
	flag_wait( "clinic_ceiling_collapsed" );
	
	autosave_by_name( "digbat_tackle" );

	//delete the door
	e_door = GetEnt( "clinic_stairwell_door", "targetname" );
	e_door Delete();	

	//start the fx
	level notify( "fxanim_ceiling_collapse_start" );
	
	//origin of collapse
	v_ceiling_position = getstruct( "building_ceiling_collapse", "targetname" ).origin;
	
	//shake and rumble	
	Earthquake( 0.3, .5, v_ceiling_position, 1000 );
		
	//sounds
	e_sound_pos = Spawn( "script_origin", v_ceiling_position );
	level.player PlaySound( "evt_hospital_shake_1" );
	e_sound_pos PlaySound( "evt_hospital_collapse" );
	e_sound_pos Delete();
	
	level.player PlayRumbleLoopOnEntity( "damage_heavy" );
	wait 0.5;
	level.player StopRumble( "damage_heavy" );
}

clinic_light_shake()
{
	trigger_wait( "clinic_light_shake" );
	
	level.player playsound( "evt_hospital_shake_0" );
	exploder(621);
	earthquake( 0.5, 1.5, level.player.origin, 250 );
	
	a_structs = getstructarray( "clinic_move_light", "targetname" );
	foreach( s_pos in a_structs )
	{
		physicsExplosionCylinder( s_pos.origin, 200, 190, 0.5 );
	}
}

/*************************************************************************************************************
	Digbat Tackle/Defend
*************************************************************************************************************/
start_crying_woman()
{
	flag_wait( "clinic_enter_hall_1" );
	
	level thread run_scene( "crying_woman_idle" );
}

digbat_tackle()
{
	
	//level thread run_scene_first_frame("digbat_tackle");
	trigger_wait( "trig_tackle_start" );
	
	level thread maps\_audio::switch_music_wait ("PANAMA_BACK_FIGHT", 1.8);
	
	//clear out previous allies and axis
	a_ai = GetAIArray( "axis", "allies" );
	foreach( ai in a_ai )
	{
		if( ai is_hero() )
		{
			continue;
		}	
		ai Delete();
	}	
	
	a_vehicles = GetEntArray( "slums_vehicle", "script_noteworthy" );
	foreach( vehicle in a_vehicles )
	{
		VEHICLE_DELETE( vehicle );
	}
	
	level notify( "digbat_tackle_started" );
		
	level thread run_scene( "digbat_tackle" );
	level thread digbat_blood_pool();
	
	wait(0.05);
	
	digbat = get_ais_from_scene("digbat_tackle", "tackle_digbat");
	digbat Attach("t6_wpn_machete_prop", "tag_weapon_left");
//	digbat.digbat_melee_weapon = Spawn( "script_model", digbat GetTagOrigin("tag_weapon_left") );
//	digbat.digbat_melee_weapon.angles = digbat GetTagAngles("tag_weapon_left");
//	digbat.digbat_melee_weapon SetModel( "t6_wpn_machete_prop" );
//	digbat.digbat_melee_weapon LinkTo( digbat, "tag_weapon_right" );
	
	level.player.current_weapon = level.player GetCurrentWeapon();
	level.player.gauntlet_weapons = level.player GetWeaponsList();
	level.player TakeAllWeapons();
	
	level.player GiveWeapon( "m1911_sp" );
	level.player SwitchToWeapon( "m1911_sp" );
//	level.player thread give_player_max_ammo();
	scene_wait( "digbat_tackle" );
	
	align_struct = getstruct("tackle_sequence", "targetname");
	
	fake_origin = spawn("script_model", align_struct.origin);
	fake_origin SetModel("tag_origin");
	fake_origin.angles = (0, 0, 0);
	fake_origin.targetname = "player_tackle_sequence";
	
	level thread run_scene( "digbat_tackle_body" );
	level thread player_tackle_player_control_logic();
	
	level thread digbat_kick_open_door();
	nd_mason_gauntlet = GetNode( "mason_gauntlet_node", "targetname" );
	level.mason SetGoalNode( nd_mason_gauntlet );
	level.mason thread digbat_mason_control();
	
	level.player DisableWeaponCycling();
	level.player ShowViewModel();
	level.player EnableWeapons();
	level.player SetClientDvar("cg_drawFriendlyNames", 1);
		
}
digbat_mason_control()
{
	level endon("end_gauntlet");
	
	level.mason.ignoreall = true;
	level.mason.ignoreme = true;
	level.mason.dontmelee = true;
	
	while(1)
	{
		trigger = trigger_wait("trigger_digbat_gauntlet", "targetname" );
		
		level.mason thread shoot_and_kill(trigger.who);
		
		while( isdefined( trigger.who ) )
		{
			wait( 0.05 );
		}
		
		level.mason.ignoreall = true;
	}
	
}


give_player_max_ammo()
{
	level endon("end_gauntlet");
	
	while(1)
	{
		wait(0.1);
		
		level.player SetWeaponAmmoClip("m1911_1handed_sp", 400);
	}
}

digbat_kick_open_door()
{
	
	scene_wait("digbat_gauntlet_3");
	left_door = getent("hospital_door_left", "targetname");
	right_door = getent("hospital_door_right", "targetname");
	left_door RotateYaw(-78, 0.5);
	right_door RotateYaw(87, 0.5);
	
	door_clip = getent("clinic_double_door_clip", "targetname");
	
	
	door_clip trigger_off();
	door_clip ConnectPaths();
	
	
}
#define L_STICK_INPUT_MIN -0.01
player_tackle_player_control_logic()
{
	level endon("end_gauntlet");
	
	player_align = getent("player_tackle_sequence", "targetname");
	flag_init( "player_moved_during_gauntlet");
	align = _get_align_object("digbat_tackle_body");
	
	while(1)
	{
		player_leftstick_y = level.player GetNormalizedMovement()[0];
		if(player_leftstick_y < L_STICK_INPUT_MIN)
		{	
			player_align MoveX(2, 0.05);
			player_align waittill("movedone");
			player_align Movey(0.4, 0.05);
			wait(0.05);
		}
		else if(level.player JumpButtonPressed() )
		{	
			if(!flag("player_moved_during_gauntlet") )
			{
				flag_set("player_moved_during_gauntlet");
			}	
			
			level thread gauntlet_recover();
			break;
		}
		else
		{
			wait(0.05);
		}
	}
}

digbat_tackle_wall( e_digbat )
{
	level notify( "fxanim_wall_tackle_start" );
	exploder( 640 );
	
	//play the sound of the wall breaking
	level.player PlaySound ("evt_dingbat_wall_break");
	
	wait 1;
	
	level.player PlayRumbleOnEntity( "damage_heavy" );
	//level.player ShellShock( "death", 5 );
	
	overlay = NewClientHudElem( level.player );
	overlay.x = 0;
	overlay.y = 0;
	overlay SetShader( "overlay_low_health_splat", 640, 480 );
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay FadeOverTime( 10 ); 
	overlay.alpha = 0;
	
	//level.player SetBlur( 1, 0.5 );
	
	wait 1;
	
	level.player SetBlur( 0, 5 );
	wait 10;
	
	overlay Destroy();
}

digbat_blood_pool()
{
	run_scene( "digbat_blood_pool" );
	level thread run_scene( "digbat_blood_pool_loop" );
	
	e_blood_pool = GetEnt( "blood_pool", "targetname" );
	e_blood_pool SetClientFlag( CLIENT_FLAG_BLOOD_POOL );
}

digbat_gauntlet()
{
	level.gauntlet_death = 1;
	
	n_wave_count = 8;	// number of waves that spawn
	
	//wait for first guy to die before starting the gauntlet
	wait 1;

	sp_gauntlet = GetEnt( "digbat_tackle_spawner", "targetname" );
	sp_gauntlet add_spawn_function( ::digbat_gauntlet_think );
	for( i = 1; i < n_wave_count; i++ )
	{
		e_digbat = sp_gauntlet spawn_ai( true );
		e_digbat.animname = "digbat_" + i;
		
		//attach a machete if it is the 1st or 5th
		if( i == 1 || i == 5 )
		{
			//wait for the ai to spawn
			wait 0.05;
			e_digbat maps\_digbats::make_machete_digbat();
			e_digbat thread digbat_challenge_track();
			e_digbat.dontmelee = true;
		}
		
		if(i == 3)
		{
			level thread spawn_digbat_hallway("digbat_gauntlet_hallway_spawner_2");
		}
		
		if(i == 5)
		{
			level thread spawn_digbat_hallway("digbat_gauntlet_hallway_spawner_1");
		}
		
		if(i == 6)
		{
			
			level thread spawn_digbat_hallway("digbat_gauntlet_hallway_spawner_3");
		}
		
		level thread run_scene( "digbat_gauntlet_" + i );
		
		waittill_notify_or_timeout( "gauntlet_death", 4.0 );
	}
	
	enemies = GetAIArray("axis");
	
	
	while( enemies.size > 0 )
	{
		wait 0.5;
		enemies = GetAIArray("axis");
	}
	
	level notify("end_gauntlet");
	
}

spawn_digbat_hallway( spawner_name )
{
	digbat = simple_spawn_single(spawner_name);
	digbat thread digbat_challenge_track();
	digbat.fixednode = true;
	digbat.dontmelee = true;
}

digbat_gauntlet_think()
{
	self.health = 30;
	
	self waittill( "death" );

	level notify( "gauntlet_death" );
	level.gauntlet_death++;
}

//digbat_gauntlet_spawn_wave( a_spawners, n_wave_size, n_wait_time )
//{
//	a_spawners = array_randomize( a_spawners );	// mix up the spawners 
//		
//	for( i = 0; i < n_wave_size; i++ )
//	{
//		a_spawners[i].count = 1;
//		a_spawners[i].script_aigroup = "digbat_gauntlet";	//hax!
//		guy = a_spawners[i] spawn_ai( true );
//		guy.health = 30;
//		wait n_wait_time;
//	}			
//}

digbat_challenge_track()
{
	
	self waittill("death", attacker);
	
	if( !isdefined( attacker ) )
	{
		return;
	}	

	if(attacker == level.player)
	{
		level.total_digbat_killed++;
	}
	
}

gauntlet_recover()
{
	
	level notify("end_gauntlet");
	
	level.player HideViewModel();
	level.player EnableWeaponCycling();
	level.player TakeWeapon( "m1911_sp" );
	
	foreach( e_weapon in level.player.gauntlet_weapons )
	{
		level.player GiveWeapon( e_weapon );
	}
	
	level.player SwitchToWeapon( level.player.current_weapon );
	level thread run_scene( "tackle_recover_woman" );
	
	
	//end_scene("digbat_tackle_body");
	run_scene( "tackle_recover_player" );
	setmusicstate ("PANAMA_BACK_FIGHT_OVER");
	
	autosave_by_name( "digbat_gauntlet_over" );
}

/*************************************************************************************************************
	Building Stairwell
*************************************************************************************************************/
building_stairwell()
{
	level thread building_stairwell_mason_movement();
	level thread building_stairwell_flashlights();
	level thread building_stairwell_player_fire_listener();
	
	flag_wait( "post_gauntlet_mason_open_door" );
	
	level clientnotify( "SND_ehs" );
	
	autosave_by_name( "apache_chase_start" );
}

building_stairwell_mason_movement()
{
	nd_stairwell_entrance = GetNode( "stairwell_entrance", "targetname" );
	level.mason set_goalradius( 32 );
	level.mason SetGoalNode( nd_stairwell_entrance );
	wait( .5 );
	level.mason waittill( "goal" );
	
	//flag_wait( "post_gauntlet_mason_open_door" );
}

building_stairwell_flashlights()
{	
	wait( 1 );
	
	level thread run_scene( "hallway_flashlights_enter" );
	wait( .5 );
	a_flashlights = get_model_or_models_from_scene( "hallway_flashlights_enter" );
	foreach( m_flashlight in a_flashlights )
	{
		PlayFXOnTag( level._effect["flashlight"], m_flashlight, "tag_origin" );
	}
	
	scene_wait( "hallway_flashlights_enter" );
	array_delete( a_flashlights );
	
	level thread run_scene( "hallway_flashlights_loop" );
	a_flashlights = get_model_or_models_from_scene( "hallway_flashlights_loop" );
	foreach( m_flashlight in a_flashlights )
	{
		PlayFXOnTag( level._effect["flashlight"], m_flashlight, "origin_animate_jnt" );
	}	
	
	flag_wait( "clinic_stairwell_top" );
	array_delete( a_flashlights );
}

building_stairwell_player_fire_listener()
{
	level endon( "clinic_stairwell_top" );
	
	trigger_off( "building_hallway_dmg", "targetname" );
	
	level.player waittill( "weapon_fired" );
	flag_set( "post_gauntlet_player_fired" );
	
	level.player say_dialog( "contact_front_024" );
	wait( .5 );
	
	level thread building_stairwell_soldier_fire( "flashlight_hall_shot_start_1", "flashlight_hall_shot_end_1" );
	level thread building_stairwell_soldier_fire( "flashlight_hall_shot_start_2", "flashlight_hall_shot_end_2" );
		
	//bullet lights
	exploder( 540 );
	level notify("fxanim_hall_blinds_start");
	
	//damage trigger
	trigger_on( "building_hallway_dmg", "targetname" );
}

building_stairwell_soldier_fire( str_start_struct, str_end_struct )
{
	level endon( "clinic_stairwell_top" );
	
	n_burst_count_min		= 12;
	n_burst_count_max		= 15;
	n_burst_delay_min		= .1;
	n_burst_delay_max		= .15;
	n_post_burst_delay_min	= .2;
	n_post_burst_delay_max	= .3;
	
	a_start_structs = GetStructArray( str_start_struct, "targetname" );
	a_end_structs = GetStructArray( str_end_struct, "targetname" );
	
	while( true )
	{
		n_burst_count = RandomIntRange( n_burst_count_min, n_burst_count_max );
		for( i = 0;	i < n_burst_count; i++ )
		{
			s_start = a_start_structs[ RandomInt( a_start_structs.size ) ];
			s_end = a_end_structs[ RandomInt( a_end_structs.size ) ];
			MagicBullet( "m16_sp", 	s_start.origin, s_end.origin );
			
			wait RandomFloatRange( n_burst_delay_min, n_burst_delay_max );
		}
		
		wait RandomFloatRange( n_post_burst_delay_min, n_post_burst_delay_max );
	}
}


building_dialog()
{
	
	level endon("start_digbag_tackle_dialog");
	level thread digbat_tackle_dialog();
	
	trigger_wait("clinic_light_shake");
	level.player say_dialog("wood_this_place_is_a_fuck_0", 1);
	level.mason say_dialog("maso_it_wasn_t_much_bette_0", 1);

	trigger_wait("building_side_door_roof_fall");
	
	level.mason say_dialog("maso_shh_do_you_hear_0");
	level.player say_dialog("wood_i_hear_it_0");

}

digbat_tackle_dialog()
{
	trigger_Wait("trig_tackle_start");
	level notify("start_digbag_tackle_dialog");
	
	level.player say_dialog("wood_she_s_hurt_bad_maso_0");
	
	//wait(2);
	level.player say_dialog("wood_damn_it_0");
	
	wait(3);
	level.mason say_dialog("maso_shit_he_s_running_0");
	level.mason say_dialog("maso_idiot_s_gonna_get_hi_0");

	wait(2);
	level.mason say_dialog("maso_more_in_front_0", 1);
	
	level waittill("end_gauntlet");
	
	level.player say_dialog("wood_we_gotta_get_after_h_0", 1);
	level.mason say_dialog("maso_i_knew_we_were_givin_0");
}
