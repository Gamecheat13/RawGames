#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\angola_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\angola.gsh;

#define CLIENT_FLAG_MOVER_EXTRA_CAM 1

skipto_riverbed_intro()
{
	skipto_teleport_players( "player_skipto_riverbed" );	
}

skipto_riverbed()
{
	skipto_teleport_players( "player_skipto_riverbed" );
	level.savimbi = init_hero( "savimbi", ::savimbi_setup );
	level thread maps\createart\angola_art::riverbed_skipto();
	
	level thread riverbed_savimbi();
	flag_set( "riverbed_done" );
}

init_flags()
{
	flag_init( "riverbed_done" );
	flag_init( "riverbed_player_intro_done" );
}

riverbed_intro()
{
	level.savimbi = init_hero( "savimbi", ::savimbi_setup_start );
	
	level thread turn_on_convoy_headlights();
	
	m_buffel_windshield = GetEnt( "buffel_windshield", "targetname" );
	m_buffel_cracked_windshield01 = spawn_model( "veh_t6_mil_buffelapc_windshield_cracked01", m_buffel_windshield.origin-(1,0,0), m_buffel_windshield.angles );
	m_buffel_cracked_windshield02 = spawn_model( "veh_t6_mil_buffelapc_windshield_cracked02", m_buffel_windshield.origin-(1,0,0), m_buffel_windshield.angles );
	m_buffel_cracked_windshield03 = spawn_model( "veh_t6_mil_buffelapc_windshield_cracked03", m_buffel_windshield.origin-(1,0,0), m_buffel_windshield.angles );
	
	level thread animate_grass( true );
	
	a_veh_buffels = GetEntArray( "convoy", "script_noteworthy" );
	array_thread( a_veh_buffels, ::init_convoy_vehicle );
	//savimbi_buffel = getent( "savimbi_buffel", "targetname" );
	//savimbi_buffel thread load_buffel();
	
	//vh_intro_buffel HidePart( "tag_glass_f_cracked" );

	run_scene_first_frame( "level_intro_player" );
	
	//Setting audio snapshot for intro
	level clientNotify ("intro");
	
	level thread blackscreen( 0, 1, 0 );
	
	wait .075;
	//start FX for the initial area
	exploder( EXPLODER_SUNFLARE );//Sun flare
	exploder( EXPLODER_INTRO );	
	
	//SOUND - Shawn J
	clientNotify ("intr");
	
	//5 seconds for FX flame and black screen
	wait 5;
	
	level thread riverbed_intro_player();
	level thread riverbed_savimbi();
	level thread riverbed_intro_convoy();
	
	level thread riverbed_intro_buffel( m_buffel_windshield, m_buffel_cracked_windshield01, m_buffel_cracked_windshield02, m_buffel_cracked_windshield03 );
}

riverbed_intro_player()
{
	level thread intro_notetrack_catcher();
	level thread run_scene( "level_intro_player" );
	level thread run_scene( "level_intro_fake_player" );
	level thread riverbed_intro_mortars();
	
	ai_fake_mason = GetEnt( "fake_mason_ai", "targetname" );
	ai_fake_mason Attach( "p6_tool_shovel", "tag_weapon_left" );
	ai_fake_mason thread reflection_scene_head_track();
	m_player_body = GetEnt( "player_body", "targetname" );
	m_player_body Attach( "p6_tool_shovel", "tag_weapon1" );

	scene_wait( "level_intro_player" );
	
	flag_set( "riverbed_player_intro_done" );
	level.savimbi unequip_savimbi_machete();
	level thread riverbed_mortars();
}

intro_notetrack_catcher()
{
	//Intro lighting/fog settings were initially tied to a notetrack, but now are enabled when the intro begins
	level thread maps\createart\angola_art::burning_man();
	level clientnotify( "fog_change" );
	
	flag_wait( "player_looking_at_burning_man" );
	m_player_body = GetEnt( "player_body", "targetname" );
	level.player PlayerLinkToDelta( m_player_body, "tag_player", 1, 20, 20, 20, 20 );
	
	flag_wait( "player_looking_at_savimbi" );
	level thread maps\createart\angola_art::burning_sky();	
	level clientnotify( "fog_change" );
	
	flag_wait( "player_looking_at_savimbi_reveal" );
	level thread maps\createart\angola_art::riverbed();
	level clientnotify( "fog_change" );
	stop_exploder( EXPLODER_SUNFLARE ); // Stop sun flare
}

riverbed_intro_buffel( m_pristine_window, m_cracked_window01, m_cracked_window02, m_cracked_window03 )
{
	m_cracked_window01 hide();
	m_cracked_window02 hide();
	m_cracked_window03 hide();
	
	//swap the pristine with cracked01 on 1st hit
	flag_wait( "player_hit_window" );
	flag_clear( "player_hit_window" );
		
	m_cracked_window01 show();
	m_pristine_window hide();
	
	//swap cracked01 for cracked02 on 3rd hit
	for (i = 0; i < 2; i++)
	{
		flag_wait( "player_hit_window" );
		flag_clear( "player_hit_window" );
	}
	
	m_cracked_window02 show();
	m_cracked_window01 hide();
	
	//Turn on reflection when player turns to look at Zavimbi
	flag_wait( "player_looking_at_savimbi" );
	
	m_pristine_window show();
	m_pristine_window turn_on_reflection_cam();
	
	
	//swap cracked02 for cracked03 on 4th hit
	flag_wait( "player_hit_window" );
	flag_clear( "player_hit_window" );
	
	m_cracked_window03 show();
	m_cracked_window02 hide();
	
	//Turn off reflection when the player turns for the Zavimbi reveal
	flag_wait( "player_looking_at_savimbi_reveal" );
	
	m_pristine_window turn_off_reflection_cam();
	m_pristine_window hide();
	
   	//ai_fake_mason = GetEnt( "fake_mason_ai", "targetname" );//Now deleted by scene system
   	//ai_fake_mason Delete();
}

//spawns 2 vehicles specifically timed for the first look to the left to fill the scene
riverbed_intro_convoy()
{
	wait 1;
	
	nd_eland_start = GetVehicleNode( "intro_eland_path", "script_noteworthy" );
	nd_buffel_start = GetVehicleNode( "intro_buffel_path", "script_noteworthy" );
	
	vehicle = spawn_vehicle_from_targetname( "start_convoy_eland" );
	vehicle SetClientFlag( CLIENT_FLAG_VEHICLE_LIGHTS );
	vehicle thread go_path( nd_eland_start );
	vehicle thread riverbed_convoy_think();
	
	wait 2; //added to prevent the two vehicles from running into each other -mb
	
	vehicle = spawn_vehicle_from_targetname( "start_convoy_buffel" );
	vehicle thread go_path( nd_buffel_start );
	vehicle thread riverbed_convoy_think();
	
}

riverbed_savimbi()
{
	//Begin Savimbi and Buffel animations
	level thread riverbed_savimbi_intro_buffel();
	run_scene( "level_intro_savimbi" );
	end_scene( "level_intro_savimbi" );
	
	//When Savimbi's info anim completes, play his part 2 anim
 	run_scene( "level_intro_savimbi_part2" );
	
	
	//When Savimbi's part 2 anim completes, begin his normal idles (and VO convo b/w Mason and Hudson)
	level thread VO_riverbed();
	
	run_scene( "savimbi_ride_rally" );
	level thread run_scene( "savimbi_ride_idle" );
	
	//save game
	autosave_by_name( "riverbed" );
}

riverbed_savimbi_intro_buffel()
{
	//Play the Savimbi Buffel intro anim
	level thread run_scene( "level_intro_savimbi_buffel" );
	
	//Grab buffel info so we're ready to make the convoy move
	veh_buffel = GetEnt( "savimbi_buffel", "targetname" );
	veh_buffel veh_magic_bullet_shield( true );
	veh_buffel.drivepath = true;
	nd_start = GetVehicleNode( "savimbi_intro_path", "targetname" );
	
	veh_convoy = getent( "riverbed_convoy_eland", "targetname" );
	veh_convoy.drivepath = true;
	
	veh_buffel1 = getent( "convoy_destroy_2", "targetname" );
	veh_buffel1.drivepath = true;
	
	veh_buffel2 = getent( "riverbed_convoy_buffel", "targetname" );
	veh_buffel2.drivepath = true;
	
	//Wait for Savimbi's intro anim to end, then make the buffels path
	scene_wait( "level_intro_savimbi" );
	
	veh_buffel1 thread go_path();
	veh_buffel2 thread go_path();
	veh_convoy thread go_path();
	veh_buffel thread go_path( nd_start );
}

riverbed()
{
	level thread riverbed_lockbreaker_perk();
	level thread riverbed_ambient_scenes();
	//level thread riverbed_mortars();
	level thread riverbed_convoy();
	level thread riverbed_fail_watch();
	
	flag_wait( "riverbed_player_intro_done" );
	
	spawn_manager_enable( "sm_riverbed_left" );
	//spawn_manager_enable( "sm_riverbed_right" );	
	
	a_convoy_trailers = get_ai_array( "convoy_trailers", "script_noteworthy" );
	foreach( guy in a_convoy_trailers)
	{
		guy magic_bullet_shield();
	}
	
	flag_wait( "riverbed_done" );
		
	//spawn_manager_kill( "sm_riverbed_right" );
	
	wait 2;
	
	spawn_manager_kill( "sm_riverbed_left" );
	
}

riverbed_intro_mortars()
{
	// sets up the endon for this mortar group
	level._explosion_stopNotify[ "mortar_intro" ] = "stop_intro_mortars";
	
	// starts the mortar loop for this mortar group
	level thread maps\_mortar::set_mortar_delays( "mortar_intro", 0.5, 2 );	
	level thread maps\_mortar::set_mortar_damage( "mortar_intro", 1, 0, 0 );	
	level thread maps\_mortar::mortar_loop( "mortar_intro" );
	
	flag_wait( "riverbed_player_intro_done" );
		
	// notifies the mortar group with this string to stop
	level notify( "stop_intro_mortars" );
}

riverbed_mortars()
{	
	// sets up the endon for this mortar group
	level._explosion_stopNotify[ "mortar_riverbed" ] = "stop_riverbed_mortars";
	
	// starts the mortar loop for this mortar group
	level thread maps\_mortar::set_mortar_delays( "mortar_riverbed", 1, 2 );	
	level thread maps\_mortar::set_mortar_damage( "mortar_riverbed", 256, 1001, 1003);	
	level thread maps\_mortar::set_mortar_range( "mortar_riverbed", 256, 3072 );	
	level thread maps\_mortar::mortar_loop( "mortar_riverbed" );
	
	flag_wait( "savannah_base_reached" );
		
	// notifies the mortar group with this string to stop
	level notify( "stop_riverbed_mortars" );
}

riverbed_ambient_scenes()
{
	//level thread run_scene( "riverbed_ambience_vehicles" );
	
	for( i = 2; i < 7; i++ )
	{
		//Cut these AI soldiers from 7 down to 5 (all five take cover after initial anims complete) -mb
		level thread run_scene( "level_intro_soldier_" + i );
	}	

	m_actors = [];	
	for( i = 1; i < 10; i++ )
	{
		//space these out to preserve framerate
		wait 0.1;
		m_actor = create_friendly_model_actor();
		m_actor.targetname = "riverbed_ambience_" + i;
		
		//certain guys have machetes in their animations
		if( i == 3 || i == 4 || i == 8 )
		{
			m_actor Attach( "t6_wpn_machete_prop", "tag_weapon_left" );
		}
		else if( i == 1 || i == 2 )
		{
			m_actor attach_weapon();
		}
		
		level thread run_scene( "riverbed_ambience_" + i );
		
		m_actors[ m_actors.size ] = m_actor;
	}
	
	//DEAD BODIES
	m_bodies = [];	
	for( i = 1; i < 9; i++ )
	{
		//space these out to preserve framerate
		wait 0.1;
		m_body = create_friendly_model_actor();
		m_body.targetname = "riverbed_corpses_" + i;
		
		//certain guys have machetes in their animations
		if( i == 4 || i == 7 || i == 6 )
		{
			m_body Attach( "t6_wpn_machete_prop", "tag_weapon_left" );
		}
	
		level thread run_scene( "riverbed_corpses_" + i );
		
		m_bodies[ m_bodies.size ] = m_body;
	}
	
	//Dead Driver
	m_driver = create_friendly_model_actor();
	m_driver.targetname = "riverbed_corpses_driver";
	wait 0.05;
	level thread run_scene( "riverbed_corpses_driver" );
	
	level thread riverbed_soldiers_move_up();
	
	//cleanup
	flag_wait( "savannah_base_reached" );
	
	/*m_driver Delete();
	
	foreach( m_actor in m_actors )
	{
		m_actor Delete();
	}
	
	foreach( m_body in m_bodies )
	{
		m_body Delete();
	}

	
	a_soldiers = GetEntArray( "intro_unita_shooter", "script_noteworthy" );
	for( i = 0; i < a_soldiers.size; i++ )
	{
		//spawn a mortar on the first soldier's origin to explain their death
		if( i == 0 )
		{
			PlayFx( getfx( "mortar_savannah" ), a_soldiers[i].origin );
	
		}
		a_soldiers[i] die();
	}
	
	a_soldiers = GetEntArray( "intro_mpla_shooter", "script_noteworthy" );
	foreach( soldier in a_soldiers )
	{
		soldier die();
	}
	
	a_soldiers = GetEntArray( "intro_soldier", "script_noteworthy" );
	foreach( soldier in a_soldiers )
	{
		soldier die();
	}*/
	
}

riverbed_soldiers_move_up()
{
	flag_wait( "riverbed_done" );
	
	a_soldiers = get_ai_array( "convoy_trailers", "script_noteworthy" );
	
	a_nd_staging_area = GetNodeArray( "staging_area_nodes", "script_noteworthy" );
	
	foreach( soldier in a_soldiers)
	{
		nd_node = random( a_nd_staging_area );
		ArrayRemoveValue( a_nd_staging_area, nd_node );
		
		soldier SetGoalNode( nd_node );
	}
	
	a_ledge_soldiers = get_ai_array( "intro_mpla_shooter", "script_noteworthy" );
	
	waittill_dead( a_ledge_soldiers);
	
	a_nd_savannah_base = GetNodeArray( "savannah_base_nodes", "script_noteworthy" );

	foreach( soldier in a_soldiers)
	{
		nd_node = random( a_nd_savannah_base );
		ArrayRemoveValue( a_nd_savannah_base, nd_node );
		
		if ( IsAlive(soldier) )
		{
			soldier SetGoalNode( nd_node );
		}
	}
}

riverbed_lockbreaker_perk()
{
	run_scene_first_frame( "lockbreaker" );

	t_open = GetEnt( "lockbreaker_buffel_trigger", "targetname" );
	t_open SetHintString( &"ANGOLA_BREAK_LOCK" );
	t_open SetCursorHint( "HINT_NOICON" );
	t_open trigger_off();
	
	a_weapons = GetEntArray( "lockbreaker_weapon", "script_noteworthy" );
	foreach( weapon in a_weapons )
	{
		weapon trigger_off();
	}

	level.player waittill_player_has_lock_breaker_perk();
	
	t_open trigger_on();
	set_objective( level.OBJ_LOCKBREAKER, t_open, "interact" );
	
	t_open waittill( "trigger" );
	t_open Delete();
	set_objective( level.OBJ_LOCKBREAKER, t_open, "remove" );	
	
	a_weapons = GetEntArray( "lockbreaker_weapon", "script_noteworthy" );
	foreach( weapon in a_weapons )
	{
		weapon trigger_on();
	}
	
	level thread run_scene( "lockbreaker_interact" );
	lockpick = get_model_or_models_from_scene( "lockbreaker_interact", "lockbreaker" );
	lockpick SetForceNoCull();
	
	scene_wait( "lockbreaker_interact" );
	
	level thread give_player_mortars();
}

riverbed_convoy()
{
	a_nd_starts_intro = GetVehicleNodeArray( "start_convoy_intro_path", "script_noteworthy" );
	a_nd_starts = GetVehicleNodeArray( "start_convoy_path", "targetname" );
	a_nd_random = [];
	
	while( !flag( "savannah_base_reached" ) )
	{
		if( !flag( "level_intro_player_done" ) )
		{
			a_nd_random = array_randomize( a_nd_starts_intro );
		}
		else
		{
			a_nd_random = array_randomize( a_nd_starts );
		}
		
		foreach( nd in a_nd_random )
		{
			vehicle = spawn_vehicle_from_targetname( riverbed_get_random_vehicle() );
			if( vehicle.vehicletype != "truck_gaz66_cargo" )
			{
				vehicle SetClientFlag( CLIENT_FLAG_VEHICLE_LIGHTS );				
			}
			vehicle thread go_path( nd );
			vehicle thread riverbed_convoy_think();
	
			wait RandomFloatRange( 3.0, 10.0 );
		}
	}	
}

//returns a string of a vehicle
riverbed_get_random_vehicle()
{
	//a_str_veh[0] = "start_convoy_buffel";
	a_str_veh[1] = "start_convoy_eland";
	a_str_veh[2] = "start_convoy_gaz66";
	a_str_veh[3] = "start_convoy_buffel_turret";
	a_str_veh[4] = "start_convoy_eland";
	a_str_veh[0] = "start_convoy_gaz66";
	
	return a_str_veh[ RandomInt( a_str_veh.size ) ];
}

riverbed_convoy_think()
{
	self veh_magic_bullet_shield( true );
	
	self load_convoy_vehicle();
	
	self waittill( "reached_end_node" );
	
	self unload_convoy_vehicle();
	
	VEHICLE_DELETE( self );
}

load_convoy_vehicle()
{
	self load_buffel( true );
	self load_gaz66();
}

unload_convoy_vehicle()
{
	self unload_buffel();
	self unload_gaz66();	
}

#define REFLECTION_WIDTH 30.5
#define REFLECTION_HEIGHT 22
turn_on_reflection_cam()
{
    SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );
    s_camera = getstruct( "s_reflection_cam", "targetname" );
    
    level.e_camera = Spawn( "script_model", s_camera.origin );
	level.e_camera SetModel( "tag_origin" );
	level.e_camera.angles = s_camera.angles;
	level.e_camera SetClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
    
	self Attach( "veh_t6_mil_buffelapc_window_xcam" );
}

turn_off_reflection_cam()
{
   	self Detach( "veh_t6_mil_buffelapc_window_xcam" );
   	level.e_camera ClearClientFlag( CLIENT_FLAG_MOVER_EXTRA_CAM );
   	wait_network_frame();
   	level.e_camera Delete();
}

reflection_scene_head_track()
{
	self endon( "death" );
	
	while ( true )
	{
		v_forward = AnglesToForward( level.player GetPlayerAngles() );
		v_eye = level.player get_eye();
		
		self LookAtPos( ( self.origin + ( 0, 0, 60 ) ) + ( v_forward * 300 ) );
		
		wait .05;
	}
}

riverbed_fail_watch()
{
	array_thread( GetEntArray( "riverbed_warning", "targetname" ), ::riverbed_fail_warning );
	array_thread( GetEntArray( "riverbed_fail", "targetname" ), ::riverbed_fail_kill );
}

riverbed_fail_warning()
{
	n_count = 1;
	
	while( !flag( "savannah_base_reached" ) )
	{
		self waittill( "trigger" );

		if( (n_count%2) != 0)
		{
			level.savimbi say_dialog( "savi_i_would_not_wish_you_0" , 0.5); //I would not wish you to find yourself a target for the mortars, Mason.
		}
		else
		{
			level.savimbi say_dialog( "savi_stay_close_to_the_co_0" , 0.5); //Stay close to the convoy, my friend.
		}
		
		//level.player thread say_dialog( "savimbi_warning" );
		//wait RandomFloatRange(1, 1.5);
		wait RandomFloatRange(5, 7.5);
		n_count++;
	}
}

riverbed_fail_kill()
{
	level endon( "savannah_base_reached" );
	
	self waittill( "trigger" );
	
	SetDvar( "ui_deadquote", &"ANGOLA_CONVOY_FAIL" );
	level.player maps\_mortar::explosion_boom( "mortar_savannah" );
}

//////////////////
//	VO SECTION	//
//////////////////

VO_riverbed()
{
	wait 2;
	
	level.player say_dialog( "huds_mason_you_copy_0" , 0.5); //Mason.  You copy?
	level.player say_dialog( "maso_where_are_you_hudso_0" , 0.5); //Where are you, Hudson?
	level.player say_dialog( "huds_i_m_in_a_chopper_t_0" , 0.5); //I’m in a chopper - tracking MPLA forces advancing on your position.
	level.player say_dialog( "maso_i_know_the_convoy_0" , 0.5); //I know.  The convoy was hit by a mortar attack...  Now Zavimbi’s got us heading straight for them.
	level.player say_dialog( "huds_he_got_balls_i_ll_0" , 0.5); //He’ got balls, I’ll give him that.
	level.player say_dialog( "maso_what_about_woods_yo_0" , 0.5); //What about Woods, you’re sure we’re on the right track?
	level.player say_dialog( "huds_right_now_it_s_all_0" , 0.5); //Right now, it’s all we got.
	
	//wait 7.5;
	//VO_riverbed_savimbi_nag();
}

VO_riverbed_savimbi_nag()
{
	level endon( "savannah_base_reached" );
		
	n_count = 1;
	vh_savimbi_buffel = GetEnt( "savimbi_buffel", "targetname");
	
	while( !flag( "savannah_base_reached" ) )
	{
		n_delta = Distance2D( level.player.origin, vh_savimbi_buffel.origin );
		if( n_delta < 1024)
		{
			wait 1;
			continue;
		}
		
		if( (n_count%2) != 0)
		{
			level.savimbi say_dialog( "savi_i_would_not_wish_you_0" , 0.5); //I would not wish you to find yourself a target for the mortars, Mason.
		}
		else
		{
			level.savimbi say_dialog( "savi_stay_close_to_the_co_0" , 0.5); //Stay close to the convoy, my friend.
		}
		
		wait 12.5;
		n_count++;
	}
}

give_player_mortars()
{
	level.player GiveWeapon( "mortar_shell_dpad_sp" );
	level.player setactionslot( 4, "weapon", "mortar_shell_dpad_sp" );

	//level thread beartrap_helper_message( 2 );
}


//******************************************************************************************
//******************************************************************************************

/*mortar_helper_message( delay )
{
	if( ISTRUE(delay) )
	{
		wait( delay );
	}

	screen_message_create( &"ANGOLA_2_BEARTRAP_HELPER" );
	wait( 4 );
	screen_message_delete();
}*/

init_convoy_vehicle()
{
	self veh_magic_bullet_shield( true );
	self load_buffel();
}