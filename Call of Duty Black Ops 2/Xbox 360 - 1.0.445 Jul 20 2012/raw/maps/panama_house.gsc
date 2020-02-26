#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\panama_utility;
#include maps\_vehicle;
#include maps\_objectives;
#include maps\_music;

#define CLIENT_FLAG_MOVER_EXTRA_CAM	1

#insert raw\maps\_utility.gsh;
	
skipto_house()
{
	skipto_setup();
	skipto_teleport_players("player_skipto_house");
}

panama_wind_settings()
{
	SetSavedDvar( "wind_global_vector", "246.366 0 0" );						// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage	
}

main()
{	
	screen_fade_out( 0.05 );
	level thread maps\createart\panama_art::house();
	
	level.player_interactive_model = "c_usa_woods_panama_casual_viewbody";
	
	house_intro_setup();
	
	level thread screen_fade_in( 0.15 );
	
	player_exits_hummer();
	
	// fail if player wanders off in the streets
	level.player thread street_fail_condition();
	
	house_events();
	
	level.player_interactive_model = "c_usa_woods_panama_viewbody";
	
	//screen_fade_out( 0.05 );
	
	level thread old_man_woods( "old_woods_1");
	
	level thread house_clean_up_and_reset();
	
	level waittill( "movie_done" );
		
	screen_fade_out( 0.5 );
	
	flag_set( "house_event_end" );
}


house_intro_setup()
{	
	level.ai_mason_casual = simple_spawn_single( "ai_mason_casual", ::init_casual_hero );
	level.ai_mason_casual.animname = "mason";
	
//	run_scene_first_frame( "mason_hummer" );
//	run_scene_first_frame( "mason_exits_hummer" );
	run_scene_first_frame( "house_front_door" );
	run_scene_first_frame( "front_gate" );
	run_scene_first_frame( "get_bag_door" );
	run_scene_first_frame( "outro_back_gate" );
	
//	level thread run_scene( "skinner_jane_argue_loop" );
	
	//hide graffiti
	m_gringo_graffiti = GetEnt( "m_gringo_graffiti", "targetname" );
	m_gringo_graffiti Hide();
	
	level.player init_player();
	
	exploder( 1001 );
	
	//flag_wait( "skinner_jane_argue_loop_started" );
	
	level thread get_skinner_ai();
}


get_skinner_ai()
{
	flag_wait( "mason_greets_mcknight_started" );
	
	level.ai_skinner_casual = GetEnt( "skinner_ai", "targetname" );
}

// self == player
init_player()
{
	self AllowJump( false );
	self AllowSprint( false );
	self hide_hud();
	
	self thread take_and_giveback_weapons( "house_event_end" );
	self thread walk_speed_adjustment();
}

// self == mason
init_casual_hero()
{
	self endon( "death" );
	
	self make_hero();		
	self gun_remove();
	self.ignoreme = true;
	self.ignoreall = true;
}

// self == player
walk_speed_adjustment()
{
	level endon( "player_outro_started" );
	
	const n_dist_min = 128;
	const n_dist_max = 256;
	self.n_speed_scale_min = 0.35;
	self.n_speed_scale_max = 0.65;
	
	while ( true )
	{
		n_dist = Distance2D( level.player.origin, level.ai_mason_casual.origin );

		if ( n_dist < n_dist_min )
		{
			self SetMoveSpeedScale( self.n_speed_scale_min );
		}
		else if ( n_dist > n_dist_max )
		{
			self SetMoveSpeedScale( self.n_speed_scale_max );
		}
		else
		{
			n_speed_scale = linear_map( n_dist, n_dist_min, n_dist_max, self.n_speed_scale_min, self.n_speed_scale_max );
			self SetMoveSpeedScale( n_speed_scale );
		}
		
		wait 0.05;
	}
}

// self == player
street_fail_condition()
{
	level endon( "player_opened_shed" );
	
	t_warn_player = GetEnt( "warn_player", "targetname" );
	t_warn_player thread house_warn_player_logic();
	
	t_fail_player = GetEnt( "fail_player", "targetname" );
	while ( true )
	{
		if ( !( self IsTouching( t_fail_player ) ) )
		{
			missionfailedwrapper( &"PANAMA_STREET_FAIL" );
		}
		
		wait 0.05;
	}
}

// self == warning trigger
house_warn_player_logic()
{
	level endon( "player_opened_shed" );
	
	while ( true )
	{
		if ( !( level.player IsTouching( self ) ) )
		{
			screen_message_create( &"PANAMA_STREET_WARNING" );
			
			wait 3;
			
			screen_message_delete();
		}
		
		wait 0.05;
	}
}

house_clean_up_and_reset()
{
	//destroy hat hud
	level notify("hat_off");
	
	a_house_vehicles = GetEntArray( "house_vehicles", "script_noteworthy" );
	foreach ( vehicle in a_house_vehicles )
	{
		if ( IsDefined( vehicle ) )
		{
			VEHICLE_DELETE( vehicle );
		}
	}
	
	//just in case
	a_ai = GetAIArray();
	foreach ( ai in a_ai )
	{
		ai Delete();
	}
	
	a_house_triggers = GetEntArray( "house_trigger", "script_noteworthy" );
	foreach ( t_house in a_house_triggers )
	{
		t_house Delete();
	}
	
	flag_wait( "house_event_end" );

	level.player SetMoveSpeedScale( 1 );
	level.player AllowSprint( true );
	level.player AllowJump( true );
	level.player show_hud();
	level.player notify( "house_event_end" );
}

player_exits_hummer()
{
	vh_player_hummer = GetEnt( "vh_player_humvee", "targetname" );
	vh_player_hummer veh_toggle_tread_fx( false );
	vh_player_hummer veh_toggle_exhaust_fx( false );
	vh_player_hummer Attach( "veh_iw_hummer_win_xcam", "front_door_left_jnt" );
	
//	run_scene_first_frame( "player_exits_hummer_xcam" );
//	m_humvee = get_model_or_models_from_scene( "player_exits_hummer_xcam", "player_hummer_xcam" );
//	e_humvee_extra_cam = GetEnt( "extra_cam_humvee", "targetname" );
//	e_humvee_extra_cam LinkTo( m_humvee, "front_door_left_jnt" );
	
	turn_on_reflection_cam( "extra_cam_humvee" );
	
	level thread house_drive_by();
	level thread run_scene( "player_exits_hummer_xcam" );
	level thread run_scene( "mason_sits_hummer" );
	level thread start_mcknight_arguing_vo();
	
	
	m_nocap_hair = get_model_or_models_from_scene( "player_exits_hummer_xcam", "reflection_woods" );
	m_nocap_hair Attach( "c_usa_milcas_woods_hair", "J_HEAD" );
		
	level thread run_scene( "player_exits_hummer" );
	
	wait 6;
	
	m_nocap_hair Detach( "c_usa_milcas_woods_hair", "J_HEAD" );
	m_nocap_hair Attach( "c_usa_milcas_woods_hair_cap", "J_HEAD" );
	
	scene_wait( "player_exits_hummer" );
	
	//level thread toggle_hat_overlay();
	vh_player_hummer Detach( "veh_iw_hummer_win_xcam", "front_door_left_jnt" );
	turn_off_reflection_cam( "extra_cam_humvee" );
}

house_drive_by()
{
	wait 5.5;
	
	//spawn_vehicle_from_targetname_and_drive( "drive_by_truck" );
		
	vh_hatch = spawn_vehicle_from_targetname( "pan_truck" );
	vh_hatch thread go_path( GetVehicleNode( "drive_by_path", "targetname" ) );
	vh_hatch thread truck_play_music();
	/*
	music_ent = spawn ("script_origin", vh_hatch.origin);
	music_ent linkto(vh_hatch);
	music_ent playsound ("mus_intro_truck");
	*/	
	wait 3;
	
	vh_truck_driveway = GetEnt( "truck_driveway", "targetname" );
	vh_truck_driveway thread go_path( GetVehicleNode( "start_driveway", "targetname" ) );
	
	wait 4;
	
	level thread ambient_neighborhood_vehicles();
}
truck_play_music()
{
	music_ent = spawn( "script_origin" , self.origin);
	music_ent playloopsound ("mus_intro_truck");
	music_ent LinkTo (self);	
}

ambient_neighborhood_vehicles()
{
	level endon( "player_at_front_gate" );
		
	while( 1 )
	{
		if ( RandomInt( 3 ) == 0 )
		{
			vh_ambient = "pan_hatchback";	
		}
		
		else if ( RandomInt( 3 ) == 1 )
		{
			vh_ambient = "pan_van";	
		}
		
		else
		{
			vh_ambient = "pan_truck";	
		}
		
		if ( RandomInt( 4 ) == 0 )
		{
			nd_start = GetVehicleNode( "start_sideroad_1", "targetname" );
		}
		
		else if ( RandomInt( 4 ) == 1 )
		{
			nd_start = GetVehicleNode( "start_sideroad_2", "targetname" );
		}
		
		else if ( RandomInt( 4 ) == 2 )
		{
			nd_start = GetVehicleNode( "start_sideroad_3", "targetname" );
		}
		
		else
		{
			nd_start = GetVehicleNode( "start_sideroad_4", "targetname" );
		}
		
		vh_car = spawn_vehicle_from_targetname( vh_ambient );
		vh_car thread go_path( nd_start );
		
		wait RandomFloatRange( 2.5, 4.5 );
	}
}


house_events()
{
	flag_set( "house_meet_mason" );
	autosave_by_name( "house_start" );
	
	house_event_front();
	house_event_walk_to_shed();
	house_event_backyard();
	house_event_exit();
}

house_event_front()
{
	vh_mason_hummer = GetEnt( "mason_hummer", "targetname" );
	vh_mason_hummer thread turn_off_mason_hummer();
	
	trigger_wait( "trig_mason_greet" );
	
	flag_set( "house_follow_mason" );
	
	//mason gets out of hummer and walks to front gate
	//level thread run_scene( "mason_hummer" );
	//run_scene( "mason_exits_hummer" );
	
	level thread house_frontyard_obj();
	
	
	stop_exploder(1001);
	wait(0.05);
	exploder(1002);
	level thread run_scene( "mason_greets_mcknight" );
	level.player say_dialog("mason_002", 2);
	level.player say_dialog("you_too_alex_004", 4.5);
	
	
	scene_wait("mason_greets_mcknight");

	level thread mason_front_gate_nag();
	//level thread run_scene( "mason_gate_loop" );
	
	level thread run_scene( "mason_wait_gate" );
}

house_event_walk_to_shed()
{
	trigger_wait( "trig_front_gate" );
	
	flag_set( "player_at_front_gate" );
	
	m_front_gate_clip = GetEnt( "m_front_gate_clip", "targetname" );
	m_front_gate_clip MoveTo( m_front_gate_clip.origin - ( 0, 0, 128 ), 0.05 );
	
	//level thread run_scene( "house_front_gate" );
	//level thread run_scene( "backyard_walk" );
	
	level thread run_scene( "squad_to_backyard" );
	level thread run_scene( "front_gate" );
	
	m_front_gate_clip thread front_gate_close_wait();
	level thread shed_door_wait();
	
	level.player thread say_dialog( "maso_hey_mcknight_you_g_0", 8 );  //Hey McKnight - You got the stuff?
	
//	level.player.n_speed_scale_min = 0.2;
//	level.player.n_speed_scale_max = 0.2;
//	level.player thread increase_player_speed_after_dog_leaves();
}

increase_player_speed_after_dog_leaves()
{
	wait 16;
	
	IPrintLnBold( "done" );
	
	level.player.n_speed_scale_min = 0.35;
	level.player.n_speed_scale_max = 0.65;
}

house_event_backyard()
{
	trigger_wait( "trig_use_shed_door" );
	
	
	stop_exploder(1002);
	level thread maps\_audio::switch_music_wait("PANAMA_INTRO", 17);
		
	flag_set( "player_opened_shed" );
	
	turn_on_reflection_cam( "reflection_cam" );
	
	m_shed_door_extra = GetEnt( "m_mirrored_shed_door", "targetname" );
	m_shed_door_extra Delete();
	
//	level thread run_scene( "reflection_shed_door" );
//	level thread run_scene( "shed_door" );
//	level thread run_scene( "bag_anim" ); //mason and skinner walk to gate from table
//	level thread run_scene( "player_grabs_bag" );
	
	level thread run_scene( "reflection_woods_grabs_bag" );
	level thread run_scene( "reflection_woods_grabs_bag_door" );
	level thread run_scene( "get_bag_door" );
	run_scene( "get_bag" );
	
//	scene_wait( "player_grabs_bag" );
	
	flag_set( "player_frontyard_obj" );
	
	run_scene_first_frame( "get_bag_door" );
	
	turn_off_reflection_cam( "reflection_cam" );
	
	//autosave_by_name( "shed_done" ); // TODO: figure out why door animations doesn't get save
	
	level thread paint_spray();
	
//	scene_wait( "bag_anim" );

	level thread run_scene( "leave_table" );
	
	level thread mason_mcknight_wait_at_gate();
	
	//mason and skinner loop at the exit gate
//	level thread run_scene( "exit_gate_loop" );
}


mason_mcknight_wait_at_gate()
{
	level endon( "house_player_at_exit" );
	
	scene_wait( "leave_table" );
		
	level thread run_scene( "leave_table_wait" );
	
	//level thread exit_gate_nag();
}


house_event_exit()
{
	trigger_wait( "trig_exit_gate" );
	
	flag_set( "house_player_at_exit" );
	
	setmusicstate ("PANAMA_GATE_OPENED");
	
	m_gringo_graffiti = GetEnt( "m_gringo_graffiti", "targetname" );
	m_gringo_graffiti Show();
	
	delay_thread( 6, ::flag_set, "show_introscreen_title" );
	
	level thread house_end_flag();
	level thread run_scene_and_delete( "outro_back_gate" );
	level notify ("stop_painting"); // for sound
	level thread run_scene_and_delete( "player_outro" );
		
	flag_wait( "player_outro_started" );
	
	autosave_by_name( "player_outro" );
	
	ai_tagger = GetEnt( "gringo_tagger_ai", "targetname" );
	ai_tagger Attach( "p_glo_spray_can", "tag_weapon_left" );
	
	level thread fade_out_house_end();
	
	scene_wait( "player_outro" );
}


fade_out_house_end()
{
	anim_length = GetAnimLength( %player::ch_pan_01_07_gringos_player );
	
	wait( anim_length - 2.1 );
	
	level notify( "hat_off" );
	
	level thread screen_fade_out( 2 );
	
	flag_wait( "movie_started" );
	
	wait 0.5;
	
	screen_fade_in( 1 );
}


// self == mason's hummer
turn_off_mason_hummer()
{
	trigger_wait( "trig_turn_off_mason_car" );
	
	self veh_toggle_tread_fx( false );
	self veh_toggle_exhaust_fx( false );
	//stop_exploder( 1001 );
}

// self == front gate clip
front_gate_close_wait()
{
	flag_wait( "start_shed_obj" );
	
	run_scene_first_frame( "front_gate" );
	
	m_front_door_open_clip = GetEnt( "front_gate_open", "targetname" );
	m_front_door_open_clip Delete();
	
	self MoveTo( self.origin + ( 0, 0, 128 ), 0.05 );
}

shed_door_wait()
{
	level endon( "player_opened_shed" );
	
	//scene_wait( "backyard_walk" );
	
	scene_wait( "squad_to_backyard" );
	
	//mason and skinner loop at table with beers
	//level thread run_scene( "beer_loop" );
	
	//level thread shed_door_nag();
	
	level thread run_scene( "wait_table" );
}

house_end_flag()
{
	flag_wait( "player_outro_started" );
	
	run_scene_first_frame( "house_end_flag" );
	
	wait 5.5;
	
	run_scene( "house_end_flag" );
}

#define REFLECTION_WIDTH 30.5
#define REFLECTION_HEIGHT 22

turn_on_reflection_cam( str_extra_cam )
{
	SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );
	sm_cam_ent = GetEnt( str_extra_cam, "targetname" );
	
	level.e_tag_origin = Spawn( "script_model", sm_cam_ent.origin );
	level.e_tag_origin SetModel( "tag_origin" );
	level.e_tag_origin.angles = sm_cam_ent.angles;
	
	level.e_tag_origin SetClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
}

turn_off_reflection_cam( str_extra_cam )
{
	sm_cam_ent = GetEnt( str_extra_cam, "targetname" );
	
	level.e_tag_origin ClearClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
	level.e_tag_origin delay_thread( 2, ::self_delete );
	
	sm_cam_ent delay_thread( 2, ::self_delete );	
}

skinner_wave_us_back( ai_mason )
{
	autosave_by_name( "house_front" );
	
	end_scene( "skinner_jane_argue_loop" );
	
	level thread house_frontyard_obj();
	level thread run_scene( "house_front_door" );
	run_scene( "skinner_waves_us_back" );
}

house_frontyard_obj()
{
	wait 10;
	
	flag_set( "house_front_door_obj_done" );
	
	wait 6;
	
	flag_set( "house_front_gate_obj" );
}

mason_front_gate_nag()
{
	level endon( "player_at_front_gate" );
	
	add_vo_to_nag_group( "front_gate_nag", level.ai_mason_casual, "we_should_make_thi_007" );	//We should make this quick, Woods.
	add_vo_to_nag_group( "front_gate_nag", level.ai_mason_casual, "for_the_sake_of_sk_008" );	//For the sake of McKnight's marriage if nothing else.
	add_vo_to_nag_group( "front_gate_nag", level.ai_mason_casual, "maso_come_on_frank_0" );  //Come on, Frank.
	
	wait 5;
	
//	level thread start_vo_nag_group_flag( "front_gate_nag", "player_at_front_gate", 16, 3, false, 3 );
	level thread start_vo_nag_group_flag( "front_gate_nag", "player_at_front_gate", 8 );
}

shed_door_nag()
{
	level endon( "player_opened_shed" );
	
	add_vo_to_nag_group( "shed_door_nag", level.ai_skinner_casual, "come_on_woods__w_017" );	//What are you waiting for, Frank?
	
	level thread start_vo_nag_group_flag( "shed_door_nag", "player_opened_shed", 16, 3, false, 3 );
}

exit_gate_nag()
{
	level endon( "house_player_at_exit" );
	
	add_vo_to_nag_group( "exit_gate_nag", level.ai_skinner_casual , "hey_woods__what_a_029" );	//Hey Woods,  what are you waiting for?
	add_vo_to_nag_group( "exit_gate_nag", level.ai_skinner_casual, "come_on_030" );				//Come on!
	
	level thread start_vo_nag_group_flag( "exit_gate_nag", "house_player_at_exit", 16, 3, false, 3 );
}

toggle_hat_overlay()
{
	overlay = NewClientHudElem( level.player );
	overlay.x = 0;
	overlay.y = 0;
	overlay SetShader( "ballcap_panama_overlay", 640, 480 );
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	//overlay FadeOverTime( 10 ); 
	//overlay.alpha = 0;
	
	level waittill("hat_off");
	overlay destroy();
}

player_woods_dialog()
{
	level.player thread say_dialog( "mason_002" ); //Mason
}

paint_spray()
{
//Start loopingsound of spray paint
	paintent = spawn ( "script_origin" , (24362, -20164, 56));
	paintent PlayLoopSound ( "evt_spray_paint_loop" );	
	level waittill ("stop_painting"); 
	paintent Stoploopsound(0.5);
	paintent delete();
}
start_mcknight_arguing_vo()
{
	level endon("kill_argue_vo");
	
	mcknight = simple_spawn_single("skinner");
	mcknight.animname = "skinner";
	mcknight say_dialog("jane_my_mom_was_right_s_0");
	mcknight say_dialog("mckn_please_honey_you_0");
	mcknight say_dialog("jane_did_i_listen_no_0");
	mcknight say_dialog("mckn_honey_you_need_to_0");
	mcknight say_dialog("jane_i_am_calm_0");
	mcknight say_dialog("jane_five_years_mark_w_0");
	mcknight say_dialog("mckn_family_i_thought_th_0");
	mcknight say_dialog("jane_it_s_about_everythin_0");
	mcknight say_dialog("jane_i_need_something_mor_0");
	mcknight say_dialog("jane_it_s_not_enough_mar_0");
}