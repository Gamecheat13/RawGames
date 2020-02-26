/*
la_2_ground.gsc - contains all functionality for air to ground section
 */

#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\la_utility;
#include maps\_music;
#include maps\_hud_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

main()
{
	
}

f35_flight_start()
{
	level.player thread f35_tutorial( true, false, true, false, false );  // tell player how to fly the F35
}


// wake up player and direct him to f35
f35_wakeup()
{
	wait_for_first_player();
	
	level clientnotify( "intro_exterior" );
	
	//TUEY kick off the starting music
	setmusicstate("LA_2_INTRO");
	
	maps\createart\la_2_art::fog_intro();  // 'level start' fog settings
	exploder( EXPLODER_STAPLES_CENTER );
	exploder( 462 );
	exploder( 100 );		// Fog at the start of the level
	exploder( 102 );
	
	run_scene_first_frame( "anderson_f35_exit" );

	intro_move_player_origin();
	level.f35 thread f35_landing_gear();
	
	level thread intro_set_cull_dist();
	
	// don't let player kill van
	vh_intro_van = get_ent( "intro_van", "targetname", true );
	vh_intro_van thread func_on_death( ::required_vehicle_death );
	
	// return player to consciousness
	level.player thread player_wakes_up_la_2();
	level thread pilot_pre_drag_idle();
	
	if ( !flag( "harper_dead" ) )
	{
		level thread harper_wakes_up();
	}
	else
	{
		flag_set( "start_anderson_f35_exit" );
		wait 5.5;
		level notify( "harper_woke_up" );		
	}
	
	level thread late_cops_driveup();
	level thread ambient_flybys();
	
	level thread intro_guys_die();
	level.f35 thread f35_blinking_light();
	level.f35 thread maps\la_2_anim::vo_f35_boarding();
	level.f35 thread func_on_death( ::required_vehicle_death );
	
	flag_wait( "start_anderson_f35_exit" );
	level thread harper_drags_pilot_to_van();
	vh_intro_van attach( "veh_iw_civ_ambulance_int", "tag_origin" );
	
	level thread run_digital_billboards();
}

player_wakes_up_la_2( b_remove_weapons, str_return_weapons_notify )
{
	assert( IsPlayer( self ), "player_wakes_up can only be used on players!" );
	
	if ( !IsDefined( level.flag[ "player_awake" ] ) )  // if set, means player is fully awake and movement restored
	{
		flag_init( "player_awake" );
	}
	
	if ( !IsDefined( b_remove_weapons ) )
	{
		b_remove_weapons = true;
	}
	
	// restrict player movement and remove weapons here
	e_temp = Spawn( "script_origin", self.origin );
	e_temp.angles = self GetPlayerAngles();
	
	const n_view_percentage = 0;
	const n_right_arc = 45;
	const n_left_arc = 45;
	const n_top_arc = 45;
	const n_bottom_arc = 45;

	// prevent ground movement but retain view look
	self PlayerLinkToDelta( e_temp, undefined, n_view_percentage, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc );
	
	self SetStance( "prone" );
	self AllowStand( false );
	self AllowSprint( false );
	self AllowJump( false );
	self AllowAds( !b_remove_weapons );  // if weapons removed, don't allow ADS. if weapons present, allow ADS
	self SetPlayerViewRateScale( 30 );
	self SetClientDvar( "cg_drawHUD", 0 );
	
	if ( b_remove_weapons )
	{
		self thread _player_wakes_up_remove_weapons( str_return_weapons_notify );
	}
	
	self ShellShock( "death", 12 );  // "explosion" includes ringing, "death" looks similar but without ringing sound
	self screen_fade_out( 0 );  // start off with black screen
	
	wait 0.2;

	self PlayRumbleOnEntity( "damage_light" );
	
	wait 0.4;

	self PlayRumbleOnEntity( "damage_light" );
	
	wait 0.4;
	
	self screen_fade_to_alpha_with_blur( 0.35, 2, 3 );
	
	wait 1.5;
	
	self screen_fade_to_alpha_with_blur( 1, 1.5, 6 );  // first fade to black
	
	self PlayRumbleOnEntity( "damage_light" );
	
	wait 0.5;
	
	self screen_fade_to_alpha_with_blur( 0.2, 2, 1.5 );

	wait 2;
	
	self screen_fade_to_alpha_with_blur( 1, 1, 6 );  // second fade to black
	
	wait 1;
	self SetPlayerViewRateScale( 80 );
	
	self screen_fade_to_alpha_with_blur( 0.2, 2, 1 );
	
	// player is awake enough now, return full movement controls
	self AllowStand( true );
	self AllowSprint( true );
	self AllowJump( true );
	self AllowAds( true );
	self ResetPlayerViewRateScale();
	self notify( "_give_back_weapons" ); // left as defaulted value so user can control timing if custom notify defined
	self SetClientDvar( "cg_drawHUD", 1 );
	flag_set( "player_awake" );
	self Unlink();
	e_temp Delete();
	
	self screen_fade_to_alpha_with_blur( 0, 2, 0 );  // restore vision to normal over a few seconds
}

intro_set_cull_dist()
{
	wait 2;
	level clientnotify( "set_intro_fog_banks" );
	SetCullDist( 15000 );
        wait 0.2;
        SetCullDist( 15001 );
}

intro_move_player_origin()
{
	s_player_start = get_struct( "player_start_default_struct", "targetname", true );
	v_start_pos = s_player_start.origin;
	v_start_ang = s_player_start.angles;
	
	v_saved_pos = "";
	//v_saved_pos = GetDvarVector( "la_2_player_start_pos" );
	
	if ( v_saved_pos != "" )
	{
		v_start_pos = level.f35 LocalToWorldCoords( v_saved_pos );
	}
	
	v_saved_ang = "";
	//v_saved_ang = GetDvarVector( "la_2_player_start_ang" );
	if ( v_saved_ang != "" )
	{
		v_start_ang = v_saved_ang;
	}
		
	level.player SetOrigin( GROUNDPOS( level.player, v_start_pos + (0, 0, 1000 ) ) );
	level.player SetPlayerAngles( v_start_ang );
	
	println( "intro_move_player_origin done!" );
}

f35_landing_gear()
{
	self HidePart( "tag_landing_gear_doors" );
	self HidePart( "tag_ladder" );
	
	self attach( "veh_t6_air_fa38_landing_gear", "tag_landing_gear_down" );
	self attach( "veh_t6_air_fa38_ladder", "tag_ladder" );
	
	flag_wait( "player_flying" );
	
    self ShowPart( "tag_landing_gear_doors" );
	self ShowPart( "tag_ladder" );
	
	self Detach( "veh_t6_air_fa38_landing_gear", "tag_landing_gear_down" );
	self Detach( "veh_t6_air_fa38_ladder", "tag_ladder" );	
}

pilot_pre_drag_idle()
{
	level endon( "player_in_f35" );
	level endon( "pilot_drag_started" );
	
	ai_pilot = init_hero( "f35_pilot" );
	ai_pilot.animname = "f35_pilot";
	
	// get everything in position
	run_scene_first_frame( "pilot_drag_van_setup" );
	
	level waittill( "start_anderson_f35_exit" );
	run_scene( "anderson_f35_exit" );
	println( "anderson_f35_exit F35 pos: " + ( level.f35 GetTagOrigin( "tag_origin" ) ) + ", angles = " + ( level.f35 GetTagAngles( "tag_origin" ) ) );
	
	// level waittill( "start_anderson_f35_exit" );
	//iprintlnbold( "anderson_f35_exit started" );
	
	run_scene( "pilot_drag_setup" );
}

harper_drags_pilot_to_van()
{
	wait 1.5;	// delay the animation so the pilot can get out of the f38
	vh_intro_van = get_ent( "intro_van", "targetname", true );
	nd_start = GetVehicleNode( "intro_van_exit_spline", "targetname" );
	Assert( IsDefined( nd_start ), "nd_start is missing for harper_drags_pilot_to_van" );
	
	if ( !flag( "harper_dead" ) )
	{
		level thread pilot_drag_play_harper_anims();
		
		ai_harper = get_ais_from_scene( "pilot_drag_harper" )[0];
		ai_harper waittill( "goal" );
	}
	else
	{
		t_debris_trigger = get_ent( "player_inside_debris_cloud_trigger", "targetname", true );	
		t_debris_trigger waittill( "trigger" );
	}
	
	level notify( "pilot_drag_started" );
	
	run_scene( "pilot_drag" );
	
	n_wait_time = 1;
	
	if ( !flag( "player_in_f35" ) )
	{
		n_wait_time = 5;
	}
	
//	level thread run_scene( "pilot_drag_van_idle" );
	
	flag_wait( "player_in_f35" );  // intro sequence started

//	ai_harper = get_ent( "harper_ai", "targetname", true );
	if ( IsDefined( ai_harper ) )
	{
		ai_harper anim_stopanimscripted();
	}
	
//	if ( !IsDefined( ai_harper.ridingvehicle ) )
//	{
//		ai_harper enter_vehicle( vh_intro_van );
//	}
	
//	ai_pilot = get_ent( "f35_pilot_ai", "targetname", true );
//	ai_pilot anim_stopanimscripted();
//	if ( !IsDefined( ai_pilot.isridingvehicle ) )
//	{
//		ai_pilot enter_vehicle( vh_intro_van );
//	}

	wait n_wait_time;  // give player enough time to see van start moving
	
	vh_intro_van thread go_path( nd_start );
	vh_intro_van waittill( "reached_end_node" );
	vh_intro_van Delete();

//	ai_pilot Delete();
}

pilot_drag_play_harper_anims()
{
	ai_harper = get_ent( "harper_ai", "targetname" );
	ai_harper anim_set_blend_in_time( 0.2 );

	run_scene( "pilot_drag_harper" );	
	level thread run_scene( "pilot_drag_harper_idle" );
}

// fails player unless optional flag is set
required_vehicle_death()
{
	if ( flag( "player_in_f35" ) )
	{
		return;
	}
	
	SetDvar( "ui_deadquote", &"LA_2_REQUIRED_VEHICLE_DEAD" );
	MissionFailed();
}

late_cops_driveup()
{
	playsoundatposition( "amb_distant_police_oneshot", (6744, -33418, 316) );
	level waittill( "harper_woke_up" );
	squad_cars = spawn_vehicles_from_targetname_and_drive( "late_lapd" );
	for ( i = 0; i < squad_cars.size; i++ )
	{
		// prevent exact overlap of sirens.
		wait 0.8;
		
		squad_cars[i] playsound( "amb_police_siren_" + i );
		squad_cars[i] thread play_delayed_stop_sound( i );
	}
	
	flag_wait( "player_in_f35" );
	
	wait 5.0;
	
	for ( i = 0; i < squad_cars.size; i++ )
	{
		squad_cars[i] notify( "kill_siren" );
	}
}

play_delayed_stop_sound( num )
{
	while( self getspeed() >= 5 )
	{
		wait(.1);
	}
	
	self playsound( "amb_police_stop_" + num );
}

harper_wakes_up()
{
	n_scale = 150;
	v_angles_player = AnglesToForward( level.player.angles );
	v_origin_player = level.player.origin;
	v_offset = ( 0, 0, 1000 );
	
	v_harper_pos = ( v_angles_player * n_scale ) + v_origin_player + v_offset;
	v_start_origin = GROUNDPOS( level.player, v_harper_pos );
	// v_angles = VectorToAngles( ( VectorNormalize( level.f35.origin - v_start_origin ) * 1 ) );
	v_angles = level.player.angles;
	
	ai_harper = init_hero( "harper" );
	ai_harper forceteleport( v_start_origin, v_angles );
	wait 5.5;

	maps\_scene::run_scene( "harper_wakes_up" );
	
	level notify( "harper_woke_up" );
	
	// find the best node for harper to move to after he's done animating
	a_nodes = GetNodeArray( "harper_intro_cover_node", "targetname" );
	Assert( ( a_nodes.size > 0 ), "harper_intro_cover_node array is missing!" );
	
	nd_best = a_nodes[ 0 ];
	n_dot_best = -1;
	v_to_plane = VectorNormalize( level.f35.origin - ai_harper.origin );
	
	for ( i = 0; i < a_nodes.size; i++ )
	{
		v_to_node = VectorNormalize( a_nodes[ i ].origin - ai_harper.origin );
		n_dot = VectorDot( v_to_plane, v_to_node );
		
		if ( n_dot > n_dot_best )
		{
			nd_best = a_nodes[ i ];
			n_dot_best = n_dot;
		}
	}
	
	ai_harper.goalradius = 64;
	ai_harper set_goal_node( nd_best );
	
	t_move_up = get_ent( "intro_harper_moveup_trigger", "targetname", true );
	t_move_up waittill( "trigger" );
	
	flag_set( "start_anderson_f35_exit" );
}

f35_boarding()
{
	// wait for player to get close to the F35
	t_boarding = get_ent( "f35_bump_trigger", "targetname", true );
	t_boarding waittill( "trigger" );
	
	//audio:  set interrior f35 snapshot
	clientnotify( "start_f35_snap" );
	
	// play boarding animation
	flag_set( "player_in_f35" ); // kill nag lines
	
	level thread maps\la_2_anim::vo_f35_startup();
	level.player anim_f35_get_in();
	SetCullDist( 25000 );
	stop_exploder( 100 );	//TODO: Move this to an appropriate spot
	level.player anim_f35_startup();
	maps\la_2_player_f35::player_boards_f35();
	
	exploder( 470 );
	
	autosave_by_name( "la_2" );
		
	// start convoy movement
	flag_set( "player_flying" );
	level thread maps\la_2_amb::radio_chatter();
}

anim_f35_get_in()
{
	n_fov_vtol = 70;
	level.player SetClientDvar( "cg_fov", n_fov_vtol );  // set fov here so there's less popping at the end of the animation
	level thread maps\_scene::run_scene( "F35_get_in_vehicle" );
	level thread maps\_scene::run_scene( "F35_get_in" );
	wait .05;
	m_helmet = get_model_or_models_from_scene( "F35_get_in", "F35_helmet" );
	m_helmet SetForceNoCull();
	maps\_scene::scene_wait( "F35_get_in" );
}

anim_f35_startup()
{
	level thread maps\_scene::run_scene( "F35_startup_vehicle" );
	maps\createart\la_2_art::art_vtol_mode_settings();  // 'far' fog settings
	maps\_scene::run_scene( "F35_startup" );
}


intro_guys_die()
{
	//a_intro_guys = get_ent_array( "intro_guys_ai", "targetname", true );
	a_intro_guys = simple_spawn( "intro_guys" );
	
	for ( i = 0; i < a_intro_guys.size; i++ )
	{
		//a_intro_guys[ i ] thread bloody_death();
		a_intro_guys[ i ] thread play_intro_guy_death_anim();
	}
}


play_intro_guy_death_anim()
{
	Assert( IsDefined( self.script_int ), "script_int parameter missing on intro guy at " + self.origin );
	
	self.animname = "intro_guy";
	self enable_long_death();
	
	switch( self.script_int )
	{
		case 0:
			str_death_anim = "intro_death_1";    //
			break;
			
		case 1:
			str_death_anim = "intro_death_2";
			break;
			
		case 2:
			str_death_anim = "intro_death_3";
			break;
			
		case 3:
			str_death_anim = "intro_death_4";
			break;
			
		case 4:
			str_death_anim = "intro_death_5";
			break;
			
		case 5:
			str_death_anim = "intro_death_6";
			break;
			
		default:
			AssertMsg( "invalid script_int found on intro guy at " + self.origin );
			break;
	}
	
	self set_deathanim( str_death_anim );
	wait 0.1;
	self DoDamage( self.health + 1, self.origin );
}


// the blinking light effect draws over everything, so stop playing it once player is in F35
f35_blinking_light()  // self = f35
{
	wait 1;
	str_tag_left = "tag_left_wingtip";
	str_tag_right = "tag_right_wingtip";
	v_pos_left = self GetTagOrigin( str_tag_left );
	v_pos_right = self GetTagOrigin( str_tag_right );
	e_temp_left = Spawn( "script_model", v_pos_left );
	e_temp_left SetModel( "tag_origin" );
	e_temp_right = Spawn( "script_model", v_pos_right );
	e_temp_right SetModel( "tag_origin" );
	
	PlayFXonTag( level._effect[ "f35_light" ], e_temp_left, "tag_origin" );
	PlayFXonTag( level._effect[ "f35_light" ], e_temp_right, "tag_origin" );
	
	flag_wait( "player_flying" );
	
	e_temp_left Delete();
	e_temp_right Delete();
}

setup_destructibles()
{
	wait_for_first_player();
	
	// gas station
//	level thread damage_trigger_monitor( "gas_station_damage_trigger", 3000, "gas_station_destroyed", level.player, ::gas_station_death );
	
	// warehouse
//	level thread damage_trigger_monitor( "warehouse_damage_trigger", 3000, "warehouse_destroyed", level.player, ::warehouse_death );

	//  radio tower
	level thread damage_trigger_monitor( "radio_tower_damage_trigger", 500, "fxanim_signal_tower_start", undefined, ::radio_tower_death );
	
	// crane and setup for collapse
	bm_clip_pristine = get_ent( "crane_clip_pristine", "targetname", true );
	
	bm_clip_collapsed = get_ent( "crane_clip_collapsed", "targetname", true );
	bm_clip_collapsed MoveTo( bm_clip_collapsed.origin - ( 0, 0, 10000 ), 0.1 ); // this never checks for classname, so it works with brushmodels
	level thread damage_trigger_monitor( "rooftop_crane_trigger", 1000, "fxanim_crane_collapse_start", level.player, ::crane_death );
	
	level thread billboard_kill_screen( "billboard_death_1", "billboard_physics_struct_1" );
	level thread billboard_kill_screen( "billboard_death_2", "billboard_physics_struct_2" );
	
	a_fake_physics_vehicles = get_ent_array( "fake_physics_vehicle", "targetname", true );
	array_thread( a_fake_physics_vehicles, ::fake_physics_vehicle_launch );
		
	level thread billboard_1_lookat_trigger();
	
	level thread setup_parking_garage();
}

billboard_1_lookat_trigger()
{
	level endon( "billboard_death_1" );
	
	const n_max_distance_to_trigger = 6000;
	
	t_lookat = get_ent( "billboard_1_lookat_trigger", "targetname", true );
	
	b_should_fire_rpg = false;
	
	while ( !b_should_fire_rpg )
	{
		t_lookat waittill( "trigger" );
		
		if ( Distance( t_lookat.origin, level.player.origin ) < n_max_distance_to_trigger )
		{
			b_should_fire_rpg = true;
		}
	}
	
	fire_magic_rpg_struct( "hotel_st_billboard_magic_struct" );  // fire magic rpg at billboard 1
}

billboard_kill_screen( str_fx_anim_start_notify, str_struct_targetname )
{
	s_physics_pulse = get_struct( str_struct_targetname, "targetname", true );
	
	level waittill( str_fx_anim_start_notify );
	
	// screens are dyn ents, so damage/push them to make sure screen stops moving
	RadiusDamage( s_physics_pulse.origin, 300, 150, 150 );
	PhysicsExplosionSphere( s_physics_pulse.origin, 300, 250, 1 );
}

setup_parking_garage()
{
	t_roof = get_ent( "parking_garage_destroyed_roof_part_trigger", "targetname", true );
	t_damage = get_ent( "parking_structure_damage_trigger", "targetname", true );
	bm_roof_clip_pristine = get_ent( "parking_structure_roof_brushmodel", "targetname", true );
	bm_roof_clip_destroyed = get_ent( "parking_structure_destroyed_clip", "targetname", true );
	
	t_roof thread destroy_roof_on_helicopter_crash();
	level thread parking_structure_destroy_roof();  // this is where actual fxanim notify is sent out, since destruction can be triggered by multiple sources
	
	bm_roof_clip_pristine SetMovingPlatformEnabled( true );
	
	bm_roof_clip_destroyed trigger_off();  // turn destroyed clip 'off' before destruction
	b_roof_pristine = true;
	
	// wait until player hits damage trigger with missiles
	while ( b_roof_pristine )
	{
		t_damage waittill( "damage", n_damage, e_attacker, v_fire_direction, v_hit_point, str_type );
		
		//iprintlnbold( "damage: " + n_damage + " type: " + str_type );
		
		if ( IsDefined( e_attacker ) && IsPlayer( e_attacker ) && IsDefined( str_type ) && (IsSubStr( str_type, "PROJECTILE" ) ) )
		{
			b_roof_pristine = false;
		}
	}
	
	level notify( "parking_structure_roof_collapse" );
}

// this is where all actual destruction occurs for parking garage roof
parking_structure_destroy_roof()
{
	t_roof = get_ent( "parking_garage_destroyed_roof_part_trigger", "targetname", true );
	a_roof_nodes = GetNodeArray( "parking_structure_roof_nodes", "script_noteworthy" );
	t_damage = get_ent( "parking_structure_damage_trigger", "targetname", true );
	bm_roof_clip_pristine = get_ent( "parking_structure_roof_brushmodel", "targetname", true );
	bm_roof_clip_destroyed = get_ent( "parking_structure_destroyed_clip", "targetname", true );
	t_physics = get_ent( "garage_roof_physics_struct", "targetname", true );
	Assert( ( a_roof_nodes.size > 0 ), "roof nodes are missing for set_parking_garage" );
	
	level waittill( "parking_structure_roof_collapse" );

	// put 'destroyed' clip back in place so stuff falls on it correctly
	bm_roof_clip_destroyed MoveTo( bm_roof_clip_destroyed.origin + ( 0, 0, 10000 ), 0.1 );
	
	a_vehicles = get_ent_array( "garage_car", "script_noteworthy" );
	a_vehicles_on_roof = [];
	
	for ( i = 0; i < a_vehicles.size; i++ )
	{
		if ( a_vehicles[ i ] IsTouching( t_physics ) )
		{
			a_vehicles_on_roof[ a_vehicles_on_roof.size ] = a_vehicles[ i ];
		}
	}
	
	// start fx anim
	level notify( "fxanim_garage_roof_start" );
	
	array_thread( a_vehicles_on_roof, ::push_garage_roof_vehicles, t_physics );
	
	// kill AI on roof
	a_to_die = get_ai_touching_volume( "axis", "parking_garage_destroyed_roof_part_trigger" );
	
	if ( a_to_die.size > 0 )
	{
		for ( i = 0; i < a_to_die.size; i++ )
		{
			a_to_die[ i ] Die();
		}
	}
	
	// disable AI nodes
	for ( i = 0; i < a_roof_nodes.size; i++ )
	{
		SetEnableNode( a_roof_nodes[ i ], false );
	}

	// delete roof clip brush and clean up triggers
	bm_roof_clip_pristine Delete();
	t_damage Delete();
	t_roof Delete();
}

destroy_roof_on_helicopter_crash()
{
	level endon( "parking_structure_roof_collapse" );
	
	while ( true )
	{
		self waittill( "trigger", e_triggered );
		
		if ( IS_VEHICLE( e_triggered ) && IS_HELICOPTER( e_triggered ) && IsDefined( e_triggered.crashing ) && e_triggered.crashing )
		{
			wait 1;
			level notify( "parking_structure_roof_collapse" );
		}
	}
}

push_garage_roof_vehicles( e_trigger )
{
	wait 0.8;
	
	n_scale = 3;
	v_push = VectorNormalize( e_trigger.origin - self.origin ) * n_scale;
	self PhysicsLaunch( self.origin, v_push );
}

/*=============================================================================
 - need a way to get death models of vehicles... automate or specify manually?
=============================================================================*/
fake_physics_vehicle_launch()
{
	b_valid_vehicle = ( self.classname == "script_model" ) || ( self.classname == "script_vehicle" );
	Assert( b_valid_vehicle, self.classname + " is not a supported classname for fake_physics_vehicle_launch. supported types = script_model" );
	
	self SetCanDamage( true );  // if this is not set, script models can't get damage notify
	n_damage_threshold = 200;
	n_scale_explosive_min = 2000;
	n_scale_explosive_max = 3000;
	n_scale_bullet_min = 400;
	n_scale_bullet_max = 500;
	n_health = 500;
	n_accumulated = 0;
	b_is_dead = false;
	
	while( true )
	{
		self waittill( "damage", n_damage, e_attacker, v_fire_direction, v_hit_point, str_type );
		
		b_should_move = false;
		b_is_explosive_type = false;
		b_is_bullet_type = false;
		b_is_enough_damage = false;
		
		if ( IsSubStr( str_type, "PROJECTILE" ) || IsSubStr( str_type, "GRENADE" ) || IsSubstr( str_type, "EXPLOSIVE" ) )
		{
			b_is_explosive_type = true;
			b_should_move = true;
		}
		else if ( IsSubStr( str_type, "BULLET" ) )
		{
			b_is_bullet_type = true;
			b_should_move = true;
		}
		
		if ( n_damage >= n_damage_threshold )
		{
			b_is_enough_damage = true;
			n_accumulated += n_damage;
		}
		
		if ( !b_is_dead && ( n_accumulated > n_health ) )
		{
			b_is_dead = true;
			
			// FX and model swap
			// TODO: support specific vehicle death explosions
			// TODO: support specific death models
		}
		
		if ( b_should_move && b_is_enough_damage )
		{
			if ( b_is_explosive_type )
			{
				//n_scale = RandomIntRange( n_scale_explosive_min, n_scale_explosive_max );
				self vehicle_explosion_launch( v_hit_point );
			}
			else if( b_is_bullet_type )
			{
				n_scale = RandomIntRange( n_scale_bullet_min, n_scale_bullet_max );
				v_launch_direction = VectorNormalize( v_hit_point - self.origin ) * n_scale * -1;
				self PhysicsLaunch( v_hit_point, v_launch_direction );
			}
				
			
			//self thread draw_line_for_time( self.origin, v_launch_direction, 1, 1, 1, 5 );
		}
	}
}



gas_station_death()
{
	//iprintlnbold( "gas station explodes" );
	exploder( 105 );
	flag_set( "gas_station_destroyed" );
	
	e_harper = level.convoy.vh_van;
	
	t_damage = get_ent( "gas_station_damage_trigger", "targetname", true );
	
	playsoundatposition( "evt_gas_station_explo" , t_damage.origin );//gas station explo sound
	
	v_point = t_damage.origin;
	n_radius = 1024;
	n_force_min = 250;
	n_force_max = 350;
	n_launch_angle_min = undefined;
	n_launch_angle_max = undefined;
	b_use_drones = true;
	
	explosion_launch( v_point, n_radius, n_force_min, n_force_max, n_launch_angle_min, n_launch_angle_max, b_use_drones );
	maps\_drones::drones_delete( "gas_station_drones" );
	
	// kill vehicle close by
	vh_truck = get_ent( "truck_gas_station", "targetname" );
	
	if ( IsDefined( vh_truck ) )
	{
		vh_truck DoDamage( 9999, vh_truck.origin, level.player, level.player, "explosive" );
	}
}

warehouse_death()
{
	//iprintlnbold( "warehouse explodes" );
	exploder( 110 );
	flag_set( "warehouse_destroyed" );
	
	e_harper = level.convoy.vh_van;	
	
	t_damage = get_ent( "warehouse_damage_trigger", "targetname", true );
	
	v_point = t_damage.origin;
	n_radius = 2000;
	n_force_min = 250;
	n_force_max = 350;
	n_launch_angle_min = undefined;
	n_launch_angle_max = undefined;
	b_use_drones = true;
	
	explosion_launch( v_point, n_radius, n_force_min, n_force_max, n_launch_angle_min, n_launch_angle_max, b_use_drones );
	spawn_manager_disable( "spawn_manager_warehouse_roof" );
	spawn_manager_disable( "spawn_manager_warehouse_roof_1" );
	spawn_manager_disable( "spawn_manager_warehouse_street" );
}

radio_tower_death()  // self = radio tower damage trigger
{
	Assert( IsDefined( self.target ), "script_brushmodel target is missing for radio tower!" );
	self playsound ("evt_sigtower_exp");
	
	bm_weapon_clip = get_ent( self.target, "targetname", true );
	
	bm_weapon_clip Delete();
	self Delete();
}

crane_death()
{
	bm_clip_pristine = get_ent( "crane_clip_pristine", "targetname", true );
	bm_clip_collapsed = get_ent( "crane_clip_collapsed", "targetname", true );
	t_hit = get_ent( "crane_clip_trigger", "targetname", true );
	
	bm_clip_pristine Delete();
	bm_clip_collapsed trigger_on();
	
	n_timeout = 4;
// 	t_hit kill_player_if_under_crane( n_timeout );  // keeping crane death out for now until I figure out a better way to monitor this
	t_hit Delete();
}

kill_player_if_under_crane( n_timeout )
{
	level endon( "crane_collapse_done" );

	level delay_thread( n_timeout, "crane_collapse_done" );
	
	self waittill( "trigger" );
	
	level.deadquote_override = true;
	SetDvar( "ui_deadquote", &"LA_2_F35_DEAD_CRANE" );
	level.f35 do_vehicle_damage( level.f35.health_regen.health, self );
}

damage_trigger_monitor( str_trigger_name, n_damage_before_trigger, str_notify_on_death, a_valid_attackers, func_on_death )  // self = anything, probably level. self gets notify on death
{
	Assert( IsDefined( str_trigger_name ), "str_trigger_name is a required parameter for damage_trigger_monitor" );
	Assert( IsDefined( n_damage_before_trigger ), "n_damage_before_trigger is a required parameter for damage_trigger_monitor" );
	Assert( IsDefined( str_notify_on_death ), "str_notify_on_death is a required parameter for damage_trigger_monitor" );
	
	b_check_attackers = false;
	
	t_damage = get_ent( str_trigger_name, "targetname", true );
	Assert( ( t_damage.classname == "trigger_damage" ), "damage_trigger_monitor() requires classname trigger_damage. " + str_trigger_name + " is currently a " + t_damage.classname );
	
	e_target = get_ent( str_trigger_name + "_target", "targetname" );
	
	if ( IsDefined( e_target ) )
	{
		//Target_Set( e_target );
	}
	
	if ( IsDefined( a_valid_attackers ) )
	{
		b_check_attackers = true;
		a_attackers = [];
		
		if ( IsArray( a_valid_attackers ) )
		{
			a_attackers = a_valid_attackers;
		}
		else
		{
			a_attackers[ a_attackers.size ] = a_valid_attackers;
		}
	}
	
	b_check_attackers = IsDefined( a_valid_attackers );
	n_damage_total = 0;
	
	while( n_damage_total < n_damage_before_trigger )
	{
		t_damage waittill( "damage", n_damage, e_attacker );
		
		b_should_damage = true;
		
		if ( b_check_attackers )
		{
			b_should_damage = false;
			
			for( i = 0; i < a_attackers.size; i++ )
			{
				if ( a_attackers[ i ] == e_attacker )
				{
					b_should_damage = true;
				}
			}
		}
		
		if ( b_should_damage )
		{
			//iprintln( str_trigger_name + " hit for " + n_damage + " by " + e_attacker GetEntityNumber() );
			n_damage_total += n_damage;
		}
	}
	
	self notify( str_notify_on_death );
	t_damage notify( "death" );  // so it'll work with func_on_death()
	
	if ( IsDefined( e_target ) )
	{
		e_target Delete();
	}
	
	if ( IsDefined( func_on_death ) )
	{
		t_damage [[ func_on_death ]]();
	}
}



f35_ground_targets()
{
	maps\createart\la_2_art::art_vtol_mode_settings();
	
	flag_wait( "convoy_movement_started" );
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_tutorial_stop_trigger", "ground_targets_done", ::flag_set, "convoy_at_ground_targets" );

	/*
	//level.f35 UseBy( level.player );
	//level.player LinkTo( level.convoy.vh_van, "tag_passenger" );
	//level.convoy.vh_van UseVehicle( level.player, 1 );
	//level.player LinkTo( level.convoy.vh_potus, "tag_passenger" );
	*/
	
	level thread convoy_attacked_by_sprinter_vans();
	level thread spawn_ground_target_guys();
	
	flag_wait( "convoy_at_ground_targets" );
	stop_exploder( EXPLODER_STAPLES_CENTER );

	//spawn_manager_enable( "spawn_manager_warehouse_street" );
	
	level thread setup_ground_attack_objectives();
	level thread roadblock_vehicles();
	
	autosave_by_name( "la_2" );
	
	level thread maps\la_2_anim::vo_roadblock();
	
	// TODO: break out into spawn functions file
			
	//simple_spawn( "gas_station_guys" );
	//simple_spawn( "tutorial_guys" );
	
	//waittill_ai_group_cleared( "gas_station_guys" );
	//waittill_ai_group_cleared( "warehouse_guys" );
	//flag_wait( "ground_attack_vehicles_dead" );
	//waittill_either_function( ::_ground_targets_success, undefined, ::_ground_targets_failure );
	_ground_targets_success();
	
	maps\la_2_convoy::convoy_distance_check_update( 25000 );
	
	flag_set( "ground_targets_done" );
	
	level thread _ground_targets_end();
}

roadblock_vehicles()
{
	a_vehicle_names = Array( "truck_warehouse_1", "truck_warehouse_2", "truck_gas_station" );
	a_vehicles = [];
		
	for ( i = 0; i < a_vehicle_names.size; i++ )
	{
		a_temp_vehicle = maps\_vehicle::spawn_vehicle_from_targetname( a_vehicle_names[ i ] );
		a_vehicles[ a_vehicles.size ] = a_temp_vehicle;
	}
	
	//array_thread( a_vehicles, ::ground_vehicle_fires_at_player );
}

ground_vehicle_fires_at_player( n_custom_index )
{
	self endon( "death" );
	self endon( "gunner_dead" );
	
	self add_ground_vehicle_damage_callback();
	
	if ( self.vehicletype == "civ_pickup_red_wturret_la2" )
	{
		//self thread vehicle_free_on_death_think();
	}
	
	n_index = 1;
	v_offset = ( 0, 0, 0 );
	const n_fire_min = 5;
	const n_fire_max = 7;
	const n_wait_min = 1.5;
	const n_wait_max = 3;
	const n_fire_time = -1;
	
	if ( IsDefined( n_custom_index ) )
	{
		n_index = n_custom_index;
	}
	
	self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index );
	
	while ( !( IsDefined(self.is_ambient_vehicle) ) || !( self.is_ambient_vehicle ) )
	{
		e_target = ( RandomInt( 100 ) < 95 ? maps\la_2_convoy::convoy_get_leader() : level.player );
		self maps\_turret::set_turret_target( e_target, v_offset, n_index );
		self maps\_turret::shoot_turret_at_target( e_target, n_fire_time, v_offset, n_index );
	}
}

add_ground_vehicle_damage_callback()
{
	if ( IsDefined( self ) )
	{
		self.overrideVehicleDamage = ::ground_vehicle_damage_callback;
	}
}

ground_vehicle_damage_callback(  eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsDefined( sWeapon ) )
	{
		if ( sWeapon == "f35_missile_turret_player" )   // one shot kill from player missile
		{
			iDamage = 9999;
		}
		else if ( sWeapon == "f35_side_minigun_player" )
		{
			iDamage = 1000;
		}
		else if ( sWeapon == "cougar_gun_turret" )
		{
			iDamage = 1;
		}
	}
	
	return iDamage;
}

spawn_ground_target_guys()
{
	spawn_manager_enable( "spawn_manager_warehouse_roof_1" );
	waittill_spawn_manager_complete( "spawn_manager_warehouse_roof_1" );
	
	e_warehouse_1 = get_ent( "roadblock_roof_origin_1", "targetname", true );
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, e_warehouse_1, "remove" );
	
	e_warehouse_2 = get_ent( "roadblock_roof_origin_2", "targetname", true );
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, e_warehouse_2, "destroy", -1 );
	
	spawn_manager_enable( "spawn_manager_warehouse_roof" );
}

_ground_targets_end()
{
	if ( flag( "ground_targets_escape" ) )
	{
		wait 6;
	}
	
	// TODO: spawn in drones that 'chase' convoy?
	maps\_drones::drones_delete( "gas_station_drones" );
	maps\_drones::drones_delete( "warehouse_drones" );
}

_ground_targets_success( n_placeholder )
{
	//flag_wait( "gas_station_destroyed" );
	//waittill_ai_group_cleared( "roadblock_guys" );
	//flag_wait( "warehouse_destroyed" );
	
	waittill_spawn_manager_complete( "spawn_manager_warehouse_roof" );
	
	e_warehouse_2 = get_ent( "roadblock_roof_origin_2", "targetname", true );
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, e_warehouse_2, "remove" );
	
	a_guys = get_ent_array( "warehouse_roof_guys" );
	a_guys_1 = get_ent_array( "warehouse_roof_guys_1" );
	a_guys = ArrayCombine( a_guys, a_guys_1, true, false );
	
	level thread spread_array_thread( a_guys, ::mark_ai_for_death );
}

_ground_targets_failure( n_placeholder )
{
	level endon( "ground_targets_done" );
	
	level waittill_any( "G20_1_dead", "G20_2_dead", "POTUS_health_low" );  // notify will be sent out on G20 vehicle death
	
	flag_set( "ground_targets_escape" );
	spawn_manager_disable( "spawn_manager_warehouse_roof" );
	spawn_manager_disable( "spawn_manager_warehouse_roof_1" );
	spawn_manager_disable( "spawn_manager_warehouse_street" );
	e_harper = level.convoy.vh_van;
	e_harper thread say_dialog( "roadblock_escape" );
}

convoy_attacked_by_sprinter_vans()
{
	// get van group a, which spawns no matter what
	a_vans = maps\_vehicle::spawn_vehicles_from_targetname( "terrorist_chaser_vans_a" );
	
	// get van group b if the convoy vehicle with the bullet weapon has been saved
	if ( IsDefined( level.convoy.vh_g20_1 ) )
	{
		a_temp = maps\_vehicle::spawn_vehicles_from_targetname( "terrorist_chaser_vans_b" );
		a_vans = ArrayCombine( a_vans, a_temp, true, false );
		
		level.convoy.vh_g20_1 maps\_turret::set_turret_target_ent_array( a_vans, level.convoy.vh_g20_1.turret_index_used );
	}
	
	// make the president's vehicle fire on the vans
	level.convoy.vh_potus maps\_turret::set_turret_target_ent_array( a_vans, level.convoy.vh_potus.turret_index_used );
	
	// make all the vans move
	foreach ( vh_van in a_vans )
	{
		Assert( IsDefined( vh_van.target ), "van at " + vh_van.origin + " is not targeting a spline path!" );
		n_temp = GetVehicleNode( vh_van.target, "targetname" );
		vh_van.drivepath = 1;
		vh_van thread go_path( n_temp );
	}
}



setup_ground_attack_objectives()
{
	wait 0.5;
	a_targets = [];
	
	//a_vehicles = get_ent_array( "ground_attack_vehicle", "targetname", true );
//	a_targets = ArrayCombine( a_targets, a_vehicles, true, false ); // removing optional targets from objectives. TravisJ 7/5/2011 - DT#4139
	
	//level.ground_attack_vehicles = a_vehicles.size;
	
	//array_thread( a_vehicles, ::func_on_death, ::ground_attack_vehicle_death );
	
	if ( !flag( "gas_station_destroyed" ) )
	{
		t_gas_station = get_ent( "gas_station_damage_trigger", "targetname" );
		a_targets[ a_targets.size ] = t_gas_station;
	
	}
	
	if ( !flag( "warehouse_destroyed" ) )
	{
		t_warehouse = get_ent( "warehouse_damage_trigger", "targetname" );
	//	a_targets[ a_targets.size ] = t_warehouse;
	}
	
	level.ground_attack_targets = a_targets.size;
	array_thread( a_targets, ::objective_ground_attack_add );
	
	e_warehouse = get_ent( "roadblock_roof_origin_1", "targetname", true );
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, e_warehouse, "destroy", -1 );
}

objective_ground_attack_add()
{
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, self, "destroy", -1 );
	
	self waittill( "death" );
	
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, self, "remove" );
	level.ground_attack_targets--;
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, undefined, undefined, level.ground_attack_targets );
}

ground_attack_vehicle_death()
{
	self vehicle_explosion_launch( self.origin );
	
	level.ground_attack_vehicles--;
	
	if ( level.ground_attack_vehicles == 0 )
	{
		flag_set( "ground_attack_vehicles_dead" );
	}
}

setup_spawn_functions()
{
	//add_spawn_function_group( "ground_attack_vehicle_guys", "targetname", ::attack_convoy_leader_ai );
	//add_spawn_function_group( "gas_station_guys", "targetname", ::attack_convoy_leader_ai );
	
	// warehouse guys
	a_nodes_warehouse_roof = GetNodeArray( "roadblock_cover_roof", "targetname" );
	a_nodes_warehouse_roof_edge = GetNodeArray( "roadblock_cover_roof_edge", "targetname" );
	a_nodes_warehouse_roof_1 = GetNodeArray( "roadblock_cover_roof_1", "targetname" );
	a_nodes_warehouse_roof_edge_1 = GetNodeArray( "roadblock_cover_roof_edge_1", "targetname" );
	
	a_nodes_warehouse_street = GetNodeArray( "roadblock_cover_street", "targetname" );
	add_spawn_function_group( "warehouse_roof_guys", "targetname", ::warehouse_guys_func, a_nodes_warehouse_roof_edge, a_nodes_warehouse_roof );
	add_spawn_function_group( "warehouse_ground_guys", "targetname", ::warehouse_guys_func, a_nodes_warehouse_street );
	add_spawn_function_group( "warehouse_roof_guys_1", "targetname", ::warehouse_guys_func, a_nodes_warehouse_roof_edge_1, a_nodes_warehouse_roof_1 );
	
	// apartment building guys (across from parking garage)
	a_nodes_edge = GetNodeArray( "rooftops_edge_node", "targetname" );
	a_nodes_interior = GetNodeArray( "rooftops_edge_node", "targetname" );
	//a_nodes_interior = GetNodeArray( "rooftops_node", "targetname" );
	
	a_volumes_infantry = [];
	a_volumes_infantry[ a_volumes_infantry.size ] = get_ent( "rooftops_volume_east", "targetname", true );

	add_spawn_function_group( "parking_structure_guys", "targetname", ::attack_convoy_leader_ai );
	add_spawn_function_veh( "truck_gas_station", ::gas_station_collateral_damage );
	
	add_spawn_function_group( "crane_building_guys", "targetname", ::attack_convoy_leader_ai );
//	add_spawn_function_group( "claw", "script_noteworthy", ::attack_convoy_leader_claw );
	
	add_spawn_function_group( "parking_structure_van_guys", "script_noteworthy", ::attack_convoy_leader_ai );
	
	add_spawn_function_veh( "parking_garage_heli_1", ::heli_crash_audio );
	add_spawn_function_veh( "parking_garage_heli_2", ::ground_vehicle_fires_at_player, 0 );
	
	add_spawn_function_veh( "crane_building_helicopter", maps\la_2_ground::helicopter_rappel_unload );
	add_spawn_function_veh( "crane_building_helicopter", ::heli_crash_audio );
	add_spawn_function_veh( "crane_building_helicopter_2", ::heli_crash_audio );
	
	// ambient vehicles
//	add_spawn_function_veh( "hotel_street_intersection_2_trucks", ::vehicle_fires_at_target_pool_then_dies, "police_cars_between_hotel_craters" );
	add_spawn_function_veh( "hotel_street_crash_drone", ::die_on_spline );
	
	// building collapse planes
	add_spawn_function_veh( "building_collapse_fly_in_planes", ::building_collapse_planes_fire );
}

#define PEGASUS_MISSILE_TURRET_INDEX 1
building_collapse_planes_fire()
{
	self endon( "death" );
	
	const n_fire_time = 2.5;  // time drones should fire on building
	
	Assert( IsDefined( self.script_string ), "script_string is missing on building collapse plane at " + self.origin );
	
	e_target = get_ent( self.script_string, "targetname" );
	
	Assert( IsDefined( e_target ), "target for building collapse plane with script_string '" + self.script_string + "' is missing!" );
	
	self waittill( "fire_now" );
	
	//self maps\_turret::shoot_turret_at_target( e_target, n_fire_time, ( 0, 0, 0 ), PEGASUS_MISSILE_TURRET_INDEX );
	e_missile = MagicBullet( "pegasus_missile_turret_doublesize", self.origin, e_target.origin );
	e_missile thread _explode_near_target( e_target );
	
	self waittill( "reached_end_node" );
	
	VEHICLE_DELETE( self )
}

_explode_near_target( e_target )
{
	self endon( "death" );
	
	self thread _collapse_building_on_missile_hit();
	
	while ( Distance( self.origin, e_target.origin ) > 200 )
	{
		wait 0.05;
	}
	
	self ResetMissileDetonationTime( 0 );
}

_collapse_building_on_missile_hit()
{
	self waittill( "death" );
	
	const BUILDING_COLLAPSE_EXPLODER = 100;
	
	level notify( "fxanim_bldg_convoy_block_start" );  // start building collapse fxanim
	
	exploder( BUILDING_COLLAPSE_EXPLODER );
	
	wait 5;
	
	flag_set( "building_collapse_done" );
}

die_on_spline()
{
	self endon( "death" );
	
	self waittill( "kill_me" );
	
	self do_vehicle_damage( self.health, level.convoy.vh_potus, "explosive" );
}

#define TRUCK_TURRET_INDEX 1
vehicle_fires_at_target_pool_then_dies( str_enemy_targetname )
{
	self endon ( "death" );
	
	self.is_ambient_vehicle = true;  // set so this vehicle doesn't fire at convoy
	
	a_targets = get_ent_array( str_enemy_targetname, "targetname" );
	array_thread( a_targets, ::add_ambient_turret_target );
	
	self maps\_turret::clear_turret_target( TRUCK_TURRET_INDEX );
	
	if ( a_targets.size > 0 )
	{
		self maps\_turret::set_turret_target_ent_array( a_targets, TRUCK_TURRET_INDEX );
		self maps\_turret::enable_turret( TRUCK_TURRET_INDEX );
	}
	
	self waittill( "target_array_destroyed" );
	
	while ( self GetSpeedMPH() > 5 )  // arbitrary low speed
	{
		wait 1;
	}
	
	wait RandomFloatRange( 3, 5 );
	
	iprintlnbold( "destroying ambient vehicle" );
	
	self do_vehicle_damage( self.health, level.convoy.vh_potus, "explosive" );
}

add_ambient_turret_target()
{
	self.is_ambient_turret_target = true;
}

gas_station_collateral_damage()
{
	self waittill( "death" );
	
	t_gas_station = get_ent( "gas_station_damage_trigger", "targetname" );
	
	if ( IsDefined( t_gas_station ) )
	{
		t_gas_station DoDamage( 9999, t_gas_station.origin, level.player, level.player, "explosive" );
	}
}

warehouse_guys_func( a_convoy_nodes, a_player_nodes )
{
	self endon( "death" );
	
	Assert( IsDefined( a_convoy_nodes ), "a_convoy_nodes is a required parameter for warehouse_guys_func" );
	
	if ( !IsDefined( a_player_nodes ) )
	{
		a_player_nodes = a_convoy_nodes;
	}
	
	const n_distance_to_next_max = 300;
	n_distance_to_next_max_sq = n_distance_to_next_max * n_distance_to_next_max;
	const n_distance_from_last_max = 300;
	n_distance_from_last_max_sq = n_distance_from_last_max * n_distance_from_last_max;
	const n_move_time_min = 10;
	const n_move_time_max = 25;
	v_last_node_position = self.origin;
	self.goalradius = 64;
	self.a.rockets = 200;  // give 'unlimited' rockets
	self.dropweapon = false;
	
	if( is_mature() && !is_gib_restricted_build() )
	{
		self.force_gib = true;
	}
	
	b_should_target_player = ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "shoot_player" ) );
	
	a_nodes = a_convoy_nodes;
	
	if ( b_should_target_player )
	{
		a_nodes = a_player_nodes;
	}
	
	Assert( ( a_nodes.size > 0 ), "a_nodes for " + self.targetname + " at position " + self.origin + " has no nodes for warehouse_guys_func" );
	
	while ( true )
	{
		b_found_node = false;
		self set_ignoreall( true );
		
		while ( !b_found_node )
		{
			nd_cover = random( a_nodes );
			
			b_node_claimed = IsNodeOccupied( nd_cover );
			
			n_distance_from_last_sq = DistanceSquared( nd_cover.origin, v_last_node_position );
			b_distance_from_last_ok = ( n_distance_from_last_sq > n_distance_from_last_max_sq );
			
			n_distance_to_cover_sq = DistanceSquared( self.origin, nd_cover.origin );
			b_distance_to_next_ok = ( n_distance_to_cover_sq > n_distance_to_next_max_sq );
			
			if ( !b_node_claimed && b_distance_to_next_ok && b_distance_from_last_ok )
			{
				b_found_node = true;
			}
			
			wait 0.05;
		}
		
		self set_goal_node( nd_cover );
		self waittill( "goal" );
		v_last_node_position = nd_cover.origin;
		self set_ignoreall( false );
		
		n_shoot_time = RandomFloatRange( n_move_time_min, n_move_time_max );
		
		e_target = maps\la_2_convoy::convoy_get_leader();
		
		if ( b_should_target_player )
		{
			e_target = level.player;
		}
		
		self thread shoot_at_target( e_target, undefined, 0, n_shoot_time );
		wait n_shoot_time;
	}
}

//attack_convoy_leader_claw()
//{
//	self endon( "death" );
//	
//	self thread remove_target_on_death();
//	
//	b_shoot_player = false;
//	self.dropweapon = false;
//	self.goalradius = 64;
//	self.a.rockets = 200;  // TODO: is there a better way to give 'unlimited' rockets?
//	
//	self maps\la_2::add_missile_turret_target();
//	
//	if ( IsDefined( self.target ) )
//	{
//		nd_goal = GetNode( self.target, "targetname" );
//		self set_goal_node( nd_goal );
//	}
//	
//	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "shoot_player" ) )
//	{
//		b_shoot_player = true;
//	}
//	
//	while( true )
//	{
//		e_target = maps\la_2_convoy::convoy_get_leader();
//		
//		if ( b_shoot_player )
//		{
//			e_target = level.player;
//		}
//		
//		self shoot_at_target( e_target );
//		wait 1;
//	}
//}

remove_target_on_death()
{
	self waittill( "death" );
	
	if ( Target_IsTarget( self ) )
	{
		Target_Remove( self );
	}
}

attack_convoy_leader_ai()
{
	self endon( "death" );
	
	b_shoot_player = false;
	self.dropweapon = false;
	self.goalradius = 64;
	self.a.rockets = 200;  // TODO: is there a better way to give 'unlimited' rockets?
	self set_pacifist( true );
	self waittill( "goal" );
	self set_pacifist( false );
	
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "shoot_player" ) && self.weapon == "rpg" )
	{
		b_shoot_player = true;
	}
	
	while( true )
	{
		e_target = maps\la_2_convoy::convoy_get_leader();
		
//		v_eye = self get_eye();
//		b_can_hit_leader = BulletTracePassed( v_eye, e_target.origin, true, self );
//		self thread draw_line_for_time( v_eye, e_target.origin, 1, 1, 1, 1 );
		
//		if( b_shoot_player || !b_can_hit_leader )
		if ( b_shoot_player )
		{
			e_target = level.player;
		}
		
		self shoot_at_target( e_target );
		wait 1;
	}
}

rooftop_guys_func( a_nodes_edge, a_nodes_interior, a_volumes_infantry )
{
	self endon( "death" );
	
	b_shoot_player = false;
	self.dropweapon = false;
	self.goalradius = 64;
	self.a.rockets = 200;  // TODO: is there a better way to give 'unlimited' rockets?

	a_nodes = a_nodes_edge;
	
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "shoot_player" ) )
	{
		b_shoot_player = true;
		a_nodes = a_nodes_interior;
	}
	
	while( true )
	{
		self go_to_appropriate_goal( a_nodes, a_volumes_infantry );
		e_target = maps\la_2_convoy::convoy_get_leader();
		
	//	if( b_shoot_player || !b_can_hit_leader || !b_convoy_in_volume )
		if ( b_shoot_player )
		{
			e_target = level.player;
		}
		
		self shoot_at_target( e_target );
		wait 8;
	}
}

go_to_appropriate_goal( a_nodes, a_volumes_infantry )
{
	b_has_goal = false;
	
	while ( !b_has_goal )
	{
		nd_goal = random( a_nodes );
		
		n_index = 0;
		
		if ( flag( "convoy_at_parking_structure" ) )
		{
			n_index = 1;
		}
		
		e_volume = a_volumes_infantry[ n_index ];
		
		b_node_occupied = IsNodeOccupied( nd_goal );
		b_is_within_volume = is_point_inside_volume( nd_goal.origin, e_volume );
		
		if ( !b_node_occupied && b_is_within_volume )
		{
			b_has_goal = true;
		}
	}
	
	self set_goal_node( nd_goal );
	self waittill( "goal" );
}


shoot_target_until_out_of_view( e_target )
{
	b_can_see_target = true;
	
	while ( b_can_see_target )
	{
		self aim_at_target( e_target, 1 );
		v_eye = self get_eye();
		//b_can_see_target = BulletTracePassed( v_eye, e_target.origin, false, self );
		b_can_see_target = self is_looking_at( e_target.origin, undefined, true );
		//iprintlnbold( b_can_see_target );
		
		if ( !IsAlive( e_target ) || !b_can_see_target )
		{
			return;
		}
	
		self shoot_at_target( e_target );
		wait 1;
	}
}

attack_player_ai()
{
	self endon( "death" );
	
	self.dropweapon = false;
	self.goalradius = 64;
	self.a.rockets = 200;  // TODO: is there a better way to give 'unlimited' rockets?
	self waittill( "goal" );
	
	self shoot_at_target_untill_dead( level.player );
}

spawn_vehicles_from_targetname_and_gopath( str_name )
{
	a_vehicles = maps\_vehicle::spawn_vehicles_from_targetname( str_name );
	
	Assert( ( a_vehicles.size > 0 ), "spawn_vehicles_from_targetname_and_gopath found no vehicles with name " + str_name );
	
	for ( i = 0; i < a_vehicles.size; i++ )
	{
		Assert( IsDefined( a_vehicles[ i ].target ), "spawn_vehicles_from_targetname_and_gopath found a vehicle not attached to spline at " + a_vehicles[ i ].origin );
		nd_temp = GetVehicleNode( a_vehicles[ i ].target, "targetname" );
		a_vehicles[ i ] thread go_path( nd_temp );
	}
}

// throws a molotov either from struct A to struct B, or from vector A to vector B
molotov_throw( str_targetname, v_start, v_end )
{
	Assert( ( IsDefined( str_targetname ) || ( IsDefined( v_start ) || IsDefined( v_end ) ) ), "either str_targetname or v_start and v_end are required for molotov_throw function" );
	const N_THROW_SCALE = 700;
	
	if ( IsDefined( str_targetname ) )
	{
		s_start = get_struct( str_targetname, "targetname", true );
	}
	
	if ( !IsDefined( v_start ) && IsDefined( s_start ) )
	{
		v_start = s_start.origin;
	}
	else if ( !IsDefined( v_start ) && !IsDefined( s_start ) )
	{
		v_start = self.origin;
	}
	
	if ( !IsDefined( v_end ) )
	{
		s_end = get_struct( s_start.target, "targetname", true );
		v_end = s_end.origin;
	}
	
	n_gravity = Abs( GetDvarInt( "bg_gravity" ) ) * -1;
	v_throw = VectorNormalize( v_end - v_start ) * N_THROW_SCALE;
	
	n_dist = Distance( v_start, v_end );
	
	n_time = n_dist / N_THROW_SCALE;
	
	v_delta = v_end - v_start;
	
	// calculate drop based on gravity: (1/2)*G*(t^2)
	n_drop_from_gravity = 0.5 * n_gravity *( n_time * n_time );
	
	// scale X and Y based on time, scale Z based on time and gravity drop
	v_launch = ( ( v_delta[0] / n_time ), ( v_delta[1] / n_time ), ( v_delta[2] - n_drop_from_gravity ) / n_time );
	
	self MagicGrenadeType( "molotov_sp", v_start, v_launch );
}

f35_pacing()
{
//	level thread maps\la_2_convoy::convoy_register_stop_point( "real_roadblock_trigger", "roadblock_clear", ::roadblock_vehicles_dead );
	
	if ( is_greenlight_build() )
	{
		level thread art_vtol_mode_settings();
		n_exposure = 2.99997;
		level.player SetClientDvars( "r_exposureTweak", 1, "r_exposureValue", n_exposure );
		
//		level thread ambient_activity_warehouse_street();
		
		flag_wait( "introscreen_complete" );
	}
	
	level thread ambient_activity_warehouse_street();
	
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_roadblock_trigger", "pip_intro_done", ::flag_set, "convoy_at_roadblock" );
	
	level.f35 delay_thread( 2, ::pip_start, "la_pip_seq_3", maps\la_2_anim::vo_pip_pacing );	
	
	flag_wait( "convoy_at_roadblock" );

	flag_set( "roadblock_done" );
}

pip_start( str_bink_name, func_during_bink )  // this is broken into separate function right now since 2 binks can potentially be playing at this point
{
	flag_waitopen( "pip_playing" );
//	level.f35 ent_flag_set( "playing_bink_now" );  // flag cleared when f35_loop starts playing again
	flag_set( "pip_playing" );
	level.f35.current_bink = str_bink_name;
	if( isdefined(level.f35.current_bink_id) )
	{
		Stop3DCinematic( level.f35.current_bink_id );
	}
	wait 0.1;  // make sure we can pull correct information from Get3DCinematicTimeRemaining()

	maps\la_2_player_f35::f35_show_console( "tag_display_message" );	
	//level.f35 ShowPart( "tag_message" );
	thread maps\_glasses::play_bink_on_hud( str_bink_name, !BINK_IS_LOOPING, !BINK_IN_MEMORY );
	flag_wait( "glasses_bink_playing" );
	
	// now that bink is playing, play optional func
	if ( IsDefined( func_during_bink ) )
	{
		self thread [[ func_during_bink ]]();
	}
	
	// waittill we're done playing
	flag_waitopen( "glasses_bink_playing" );

//	level.f35 HidePart( "tag_message" );
	f35_show_console( undefined );
	flag_clear( "pip_playing" );
}

ambient_activity_warehouse_street()
{
	//maps\_drones::drones_start( "warehouse_st_left_turn_drones_allies" );
	//delay_thread( 0.1, maps\_drones::drones_start, "warehouse_st_left_turn_drones_axis" );
	delay_thread( 0.2, maps\_drones::drones_start, "warehouse_st_right_blockade" );
	//maps\_drones::drones_start( "warehouse_st_distant_runners" );
	delay_thread( 0.3, maps\_drones::drones_start, "warehouse_st_blockade_lapd" );
	
	level.player delay_thread ( 3, ::molotov_throw, "warehouse_st_molotov_struct_1" );
	level.player delay_thread ( 4, ::molotov_throw, "warehouse_st_molotov_struct_2" );
	level.player delay_thread ( 5, ::molotov_throw, "warehouse_st_molotov_struct_3" );
	
	level thread spawn_vehicles_from_targetname_and_gopath( "warehouse_st_left_turn_police_car" );
	
	level thread ambient_activitiy_stop_warehouse_st_left();
	
	level waittill( "stop_ambient_activity_warehouse_street" );
	//iprintlnbold( "stopping warehouse street drones" );
	
	maps\_drones::drones_delete( "warehouse_st_right_blockade" );
	maps\_drones::drones_delete( "warehouse_st_blockade_lapd" );
	
	a_lookat_triggers = get_ent_array( "drones_warehouse_st_turn_kill_trigger_left", "targetname", true );
	
	for ( i = 0; i < a_lookat_triggers.size; i++ )
	{
		a_lookat_triggers[ i ] Delete();
	}
}

ambient_activitiy_stop_warehouse_st_left()
{
	level waittill( "stop_ambient_activity_warehouse_street_left" );
	
	//maps\_drones::drones_delete( "warehouse_st_left_turn_drones_allies" );
	//maps\_drones::drones_delete( "warehouse_st_left_turn_drones_axis" );
	
	a_lookat_triggers = get_ent_array( "drones_warehouse_st_turn_kill_trigger", "targetname", true );
	
	for ( i = 0; i < a_lookat_triggers.size; i++ )
	{
		a_lookat_triggers[ i ] Delete();
	}
}

ambient_activity_hotel_street()
{
	level notify( "stop_ambient_activity_warehouse_street" );
	level notify( "stop_ambient_activity_warehouse_street_left" );
	
	wait 0.05;
	
	//iprintlnbold( "starting hotel_st_breakthrough_opposite" );
	
	delay_thread( 0.1, maps\_drones::drones_start, "hotel_street_breakthrough_drones" );
	delay_thread( 0.2, maps\_drones::drones_start, "hotel_st_breakthrough_opposite" );
	delay_thread( 0.3, maps\_drones::drones_start, "hotel_street_parking_lot_drones" );
	delay_thread( 0.4, maps\_drones::drones_start, "hotel_street_breakthrough_lapd" );
	
	flag_wait( "convoy_at_apartment_building" );
	
	maps\_drones::drones_delete( "hotel_street_building_drones" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_st_breakthrough_opposite" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_street_parking_lot_drones" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_street_breakthrough_lapd" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_street_breakthrough_drones" );
}

ambient_activity_hotel_street_vehicles( e_triggered )
{
	wait 2;
	
	//level thread spawn_vehicles_from_targetname_and_gopath( "hotel_street_police_cars" );
}

ambient_activity_hotel_street_turn()
{
	//maps\_drones::drones_delete( "warehouse_st_left_turn_drones_allies" );
	//maps\_drones::drones_delete( "warehouse_st_left_turn_drones_axis" );
	
	//iprintlnbold( "spawning hotel_turn_drones" );
	delay_thread( 0.1, maps\_drones::drones_start, "hotel_turn_drones" );
	delay_thread( 0.2, maps\_drones::drones_start, "hotel_turn_drones_lapd" );
	
	//level thread spawn_vehicles_from_targetname_and_gopath( "police_cars_between_hotel_craters" );
	
	// clean up EVERYTHING since we're here
	maps\_drones::drones_delete( "hotel_street_building_drones" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_st_breakthrough_opposite" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_street_parking_lot_drones" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_street_breakthrough_lapd" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_street_breakthrough_drones" );

	maps\_drones::drones_delete( "warehouse_st_right_blockade" );
	maps\_drones::drones_delete( "warehouse_st_blockade_lapd" );
		
	
	flag_wait( "convoy_at_apartment_building" );
	
	maps\_drones::drones_delete( "hotel_turn_drones" );
	wait 0.1;
	maps\_drones::drones_delete( "hotel_turn_drones_lapd" );

}

ambient_activity_parking_structure()
{
	t_radio_tower = get_ent( "radio_tower_damage_trigger", "targetname" );
	
	if ( IsDefined( t_radio_tower ) )
	{
		fire_magic_rpg_struct( "radio_tower_magic_damage_struct" );
	}
	
	delay_thread( 0.1, maps\_drones::drones_start, "parking_structure_drones" );
	delay_thread( 0.3, maps\_drones::drones_start, "parking_structure_lapd_drones" );
	
	flag_wait( "player_passed_garage" );
	
	maps\_drones::drones_delete( "parking_structure_drones" );
	maps\_drones::drones_delete( "parking_structure_lapd_drones" );
	
	a_axis_ai = GetAIArray( "axis" );
	
	array_thread( a_axis_ai, ::mark_ai_for_death );
}

ambient_activity_park()
{
	maps\_drones::drones_start( "park_terrorists" );
	delay_thread( 0.2, maps\_drones::drones_start, "park_lapd" );
	
	flag_wait( "player_passed_garage" );
	
	maps\_drones::drones_delete( "park_lapd" );
	maps\_drones::drones_delete( "park_terrorists" );
}

// hotel_st_billboard_magic_struct
fire_magic_rpg_struct( str_struct_name )
{
	// DESTABILIZATION DISTANCE IS 2000 UNITS!
	s_magic_bullet_start = get_struct( str_struct_name, "targetname", true );
	s_magic_bullet_end = get_struct( s_magic_bullet_start.target, "targetname", true );
		
	MagicBullet( "usrpg_magic_bullet_sp", s_magic_bullet_start.origin, s_magic_bullet_end.origin );
	
	return s_magic_bullet_end;
}

lapd_ai_hotel_turn( a_goals, a_fire_points )
{
	self endon( "death" );
	
	b_found_node = false;
	
	self.goalradius = 32;
	self.takedamage = false;
	
	while ( !b_found_node )
	{
		nd_goal = random( a_goals );
		
		if ( !IsNodeOccupied( nd_goal ) )
		{
			b_found_node = true;
		}
	}
	
	self set_goal_node( nd_goal );
	
	self waittill( "goal" );
	self.takedamage = true;
	
	while ( true )
	{
		e_target = random( a_fire_points );
		
		n_fire_time = RandomFloatRange( 5, 10 );
		
		self shoot_at_target( e_target, undefined, undefined, n_fire_time );
	}
}

ambient_activity_crane_street()
{
	maps\_drones::drones_start( "crane_street_terrorists" );
	delay_thread( 0.2, maps\_drones::drones_start, "crane_street_lapd" );
	
	// clean up all previous AI
	a_guys = GetAIArray( "axis" );
	array_thread( a_guys, ::mark_ai_for_death );
	
	flag_wait( "convoy_at_rooftops" );
	
	maps\_drones::drones_delete( "crane_street_lapd" );
	maps\_drones::drones_delete( "crane_street_terrorists" );
}

f35_rooftops()
{
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_waits_after_parking_garage", "player_passed_garage" );
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_hotel_regroup_stop_trigger", "player_in_range_of_convoy", ::flag_set, "convoy_passed_roundabout" );
	
	//flag_wait( "convoy_at_rooftops" );
	
	level thread add_trigger_function( "hotel_street_ambient_trigger", ::ambient_activity_hotel_street );
	level thread add_trigger_function( "hotel_street_turn_drones_trigger", ::ambient_activity_hotel_street_turn );
	level thread add_trigger_function( "drones_in_the_park_trigger", ::ambient_activity_park );
	//level thread add_trigger_function( "crane_building_street_trigger", ::ambient_activity_crane_street );
	level thread add_flag_function( "convoy_at_parking_structure", ::ambient_activity_parking_structure );
	level thread add_trigger_function( "parking_structure_ambient_drones_trigger", ::ambient_activity_parking_structure );
	level thread add_trigger_function( "convoy_waits_after_crane_building_trigger", ::pre_building_collapse_event );
	
	autosave_by_name( "la_2" );
	
	//iprintlnbold( "rooftops" );
	level thread vo_rooftops();
	
	level thread rooftop_ai_setup();
	//level thread _kill_drones_after_convoy_passes( "convoy_waits_after_parking_garage", "parking_structure_drones" );
	//level thread _kill_drones_after_convoy_passes( "convoy_waits_after_parking_garage", "rooftops_drones_2" );
	//level thread _kill_drones_after_convoy_passes( "kill_rooftops_drones_3", "rooftops_drones_3" );
	//delay_thread( 5, ::simple_spawn, "rooftop_guys_left", ::attack_convoy_leader_ai );
	level thread crane_building_spawner();

//	flag_wait( "convoy_passed_roundabout" );
	level thread ambient_activity_hotel_street_vehicles();
	
	flag_wait( "player_passed_garage" );
//	level thread pip_start( "la_hilary_talk" );
	level thread maps\la_2_anim::vo_after_parking_structure();
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_rooftops_stop_trigger", "convoy_at_rooftops", ::convoy_waits_after_crane_building );
		
//	flag_wait( "convoy_at_rooftops" );
//	flag_wait( "player_at_rooftops" );
	
	//iprintlnbold( "spawning building collapse event stuff" );
	
	//level thread pre_building_collapse_event();
	level thread building_collapse_planes_fly_in();
}

building_collapse_planes_fly_in()
{
	level notify( "fxanim_bldg_convoy_block_start" );  // start building collapse fxanim
	delay_thread( 0.1, ::spawn_vehicles_from_targetname_and_gopath, "building_collapse_fly_in_planes" );
}

pre_building_collapse_event()
{
	// spawn vehicles and make them path for this section (LAPD vs terrorists in one group)
	t_vehicle_spawner = get_ent( "building_collapse_event_vehicle_spawner", "targetname", true );
//	t_vehicle_spawner notify( "trigger" );
	
	t_vehicle_spawner_2 = get_ent( "building_collapse_battle_vehicle_trigger", "targetname", true );
//	t_vehicle_spawner_2 notify( "trigger" );
	
	maps\_drones::drones_start( "pre_building_collapse_drones" );
	delay_thread( 0.2, maps\_drones::drones_start, "building_collapse_battle_axis" );
	delay_thread( 0.4, maps\_drones::drones_start, "building_collapse_battle_allies" );
	
	level waittill( "kill_pre_building_collapse_drones" );
	
	maps\_drones::drones_delete( "building_collapse_battle_axis" );
	maps\_drones::drones_delete( "building_collapse_battle_allies" );
	
	a_triggers = get_ent_array( "pre_building_collapse_drones_lookat_kill_triggers", "targetname", true );
	
	for ( i = 0; i < a_triggers.size; i++ )
	{
		a_triggers[ i ] Delete();
	}
}

convoy_waits_after_crane_building()
{
	t_wait = get_ent( "convoy_waits_after_crane_building_trigger", "targetname", true );
	
	b_player_hit_trigger = false;
	
	if ( !flag( "convoy_at_rooftops" ) )
	{
		while ( !b_player_hit_trigger )
		{
			t_wait waittill( "trigger", e_triggered );
			
			if ( IsPlayer( e_triggered ) )
			{
				b_player_hit_trigger = true;
			}
		}
		
		flag_set( "convoy_at_rooftops" );
	}
}

crane_building_spawner()
{
	t_crane_building = get_ent( "crane_building_lookat_trigger", "targetname", true );
	
	b_spawn_ready = false;
	const n_distance_ok_to_spawn_guys = 7500;
	const n_distance_ok_to_spawn_heli = 15000;
	
	level thread _crane_building_helicopter();
	
	while ( !b_spawn_ready )
	{
		t_crane_building waittill( "trigger" );
		n_distance_current = Distance( t_crane_building.origin, level.player.origin );
		
		//iprintlnbold( "crane_building_lookat_trigger hit. distance = " + n_distance_current );
		
		if ( n_distance_current < n_distance_ok_to_spawn_heli )
		{
			level notify( "spawn_crane_building_heli" );
		}
		
		if ( n_distance_current < n_distance_ok_to_spawn_guys )
		{
			b_spawn_ready = true;
		}
	}
	
//	iprintlnbold( "spawning rooftop guys now" );
	if ( !flag( "convoy_at_dogfight" ) )
	{
		//ai_guys = simple_spawn( "crane_building_guys" );
	}
	
	t_crane_building Delete();
}

_crane_building_helicopter()
{
	t_proximity = get_ent( "crane_building_helicopter_trigger", "targetname", true );
	level thread maps\_load_common::trigger_notify( t_proximity, "spawn_crane_building_heli" );
	delay_thread( 3, ::set_flag_on_trigger, t_proximity, "player_passed_garage" );
	
	level waittill( "spawn_crane_building_heli" );  // this notify can come from either func crane_building_spawner or trig w/targetname crane_building_helicopter_radius_trigger
	
	if ( !flag( "convoy_at_dogfight" ) )
	{
	//	iprintlnbold( "spawning crane building helicopter" );
		vh_helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "crane_building_helicopter" );
		vh_helicopter_2 = maps\_vehicle::spawn_vehicle_from_targetname( "crane_building_helicopter_2" );
		
		nd_path = GetVehicleNode( vh_helicopter.target, "targetname" );
		vh_helicopter thread go_path( nd_path );
		vh_helicopter thread heli_triggers_crane_fall();
		
		nd_path_2 = GetVehicleNode( vh_helicopter_2.target, "targetname" );
		vh_helicopter_2 thread go_path( nd_path_2 );
		//vh_helicopter_2 weapon_index_test();
		
		vh_helicopter = get_ent( "crane_building_helicopter", "targetname" );
	}
}

weapon_index_test()
{
	for ( i = 0; i < 5; i++ )
	{
		str_weapon = self SeatGetWeapon( i );
		
		if ( !IsDefined( str_weapon ) )
		{
			str_weapon = "NONE";
		}
		
		iprintlnbold( str_weapon + " at seat index " + i );
	}
}

heli_triggers_crane_fall()
{
	s_crash_point = get_struct( "crane_building_helicopter_crash_point", "targetname", true );
	
	self waittill( "death" );
	self thread _heli_crash_sanity_check( s_crash_point );
		
	if ( !self.rappel_unloading_done )
	{
		self waittill_either( "crash_move_done", "missed_rooftop" );
		//iprintlnbold( "crash_move_done" );
		
		t_crane = get_ent( "rooftop_crane_trigger", "targetname" );
		
		if ( IsDefined( t_crane ) )
		{
			//iprintlnbold( "triggering crane fall" );
			t_crane DoDamage( 9999, t_crane.origin, level.player );  // use DoDamage since there's a func already waiting to send out fxanim start notify
		}
	}
}

heli_crash_audio()
{
	self waittill( "death" );
	if ( IsDefined( self ) )
	{
		self playsound( "evt_heli_crash" );
		//iprintlnbold( "start" );
		self waittill( "crash_move_done" );
		//iprintlnbold( "stop" );
		self StopSound( "evt_heli_crash" );
		//self playsound( "exp_veh_large" );
	}
}

_heli_crash_sanity_check( s_reference )
{
	self endon( "missed_rooftop" );
	self endon( "crash_move_done" );
	self endon( "death" );
	
	while ( true )
	{
		if ( !IsDefined( self ) )
		{
			return;	
		}
		n_dot_up = self get_dot_up( s_reference.origin );
		//iprintlnbold( n_dot_up );
		if ( n_dot_up > 0 )
		{
			self notify( "missed_rooftop" );
		}
		
		wait 0.05;
	}
}

helicopter_rappel_unload( func_ai_custom )
{
	self endon( "death" );
	self.rappel_unloading_done = false;
	self.originheightoffset = 75;  // used by vehicle_land to offset ground pos from trace
	
	if ( !IsDefined( func_ai_custom ) )
	{
		func_ai_custom = ::crane_building_ai_func;
	}
	
	self thread heli_populate_passengers( 6, "crane_building_helicopter_passenger", "targetname", func_ai_custom );
	
	self waittill( "rappel_dropoff" );
	n_speed = ( self GetMaxSpeed() ) / 17.6;
	self land_heli();
	//self SetSpeed( 0 );
	// unload guys
	self vehicle_unload();
	
	wait 9;
	
	self thread go_path( self.currentnode );
	self SetSpeed( n_speed );
	self.rappel_unloading_done = true;
}

land_heli()
{
	self setNearGoalNotifyDist( 12 );
	self sethoverparams( 0, 0, 10 );
	self cleargoalyaw();
	self settargetyaw( flat_angle( self.angles )[ 1 ] );
	self setvehgoalpos_wrap( GROUNDPOS( self, self.origin ), 1 );
	self waittill( "near_goal" );
}

crane_building_ai_func()
{
	self endon( "death" );
	
	self waittill( "jumpedout" );  // waittill vehicle getout animations are done
	
	a_goals = GetNodeArray( "crane_building_edge_nodes", "script_noteworthy" );
	Assert( ( a_goals.size > 0 ), "a_goals missing in crane_building_ai_func!" );
	
	b_found_goal = false;
	
	while ( !b_found_goal )
	{
		wait RandomFloatRange( 0.1, 0.6 );
		
		nd_goal = random( a_goals );
		
		if ( !IsNodeOccupied( nd_goal ) )
		{
			b_found_goal = true;
		}
	}
	
	self set_goalradius( 32 );
	self set_ignoreall( true );
	self SetGoalNode( nd_goal );
	self waittill( "goal" );
	self set_ignoreall( false );
	
	self thread attack_convoy_leader_ai();
}

heli_populate_passengers( n_guys, str_value, str_key, func_spawn )
{
	Assert( IsDefined( n_guys ), "n_guys is a required parameter for heli_populate_passengers!" );
	Assert( IsDefined( str_value ), "str_value is a required parameter for heli_populate_passengers!" );
	Assert( IsDefined( str_key ), "str_key is a required parameter for heli_populate_passengers!" );
	Assert( IsDefined( func_spawn ), "func_spawn is a required parameter for heli_populate_passengers!" );
	
	sp_passenger = get_ent( str_value, str_key, true );
	
	if ( !IsDefined( self ) )
	{
		return;
	}
	
	for ( i = 0; i < n_guys; i++ )
	{
		ai_temp = simple_spawn_single( sp_passenger, func_spawn );
		ai_temp enter_vehicle( self );
		wait_network_frame();
	}
}

_kill_drones_after_convoy_passes( str_trigger_name, str_drone_name )
{
	Assert( IsDefined( str_trigger_name ), "str_trigger_name is a required parameter fo _kill_drones_after_convoy_passes" );
	Assert( IsDefined( str_drone_name ), "str_drone_name is a required parameter for _kill_drones_after_convoy_passes" );
	
	t_kill = get_ent( str_trigger_name, "targetname", true );
	
	t_kill maps\la_2_convoy::_waittill_triggered_by_convoy();
	/*
	b_is_convoy_vehicle = false;
	
	while ( !b_is_convoy_vehicle )
	{
		t_kill waittill( "trigger", e_triggered );
		
		for ( i = 0; i < level.convoy.vehicles.size; i++ )
		{
			if ( e_triggered == level.convoy.vehicles[ i ] )
			{
				b_is_convoy_vehicle = true;
			}
		}
	}
	*/
	
	maps\_drones::drones_delete( str_drone_name );
}



rooftop_ai_setup()
{
	a_aigroup_names = Array( "parking_garage_floor_4", "parking_garage_van_1", "parking_garage_floor_3",
	                        "parking_garage_stairs", "rooftop_near", "rooftop_far" );
	
	// clear all previous 'destroy' objectives
	maps\_objectives::set_objective( level.OBJ_ROADBLOCK, undefined, "delete" );
	
	n_objective_counter = a_aigroup_names.size;
	//maps\_objectives::set_objective( level.OBJ_ROOFTOPS, undefined, undefined, n_objective_counter );
	
	level.rooftop_objective_counter = n_objective_counter;
	
	/*  --- removing optional objectives for now. DT#4139, 7/5/2011 TravisJ
	foreach( str_group_name in a_aigroup_names )
	{
		wait RandomFloatRange( 0.1, 0.5 );
		level thread rooftop_ai_individual_objective( str_group_name );
	}
	*/
	
	t_apartments = get_ent( "rooftop_apartment_guys_move_trigger", "targetname", true );
	t_apartments maps\la_2_convoy::_waittill_triggered_by_convoy();
	flag_set( "convoy_at_apartment_building" );
	
	//spawn_manager_enable( "spawn_manager_rooftops_apartments" );
	
	t_parking_structure = get_ent( "convoy_at_parking_structure_trigger", "targetname", true );
	t_parking_structure_vehicle = get_ent( "convoy_at_parking_structure_trigger_vehicle", "targetname", true );
//	t_parking_structure maps\la_2_convoy::_waittill_triggered_by_convoy();
	t_parking_structure_vehicle notify( "trigger" );
	
	// hint: press RS to zoom
	// level.player maps\la_2_player_f35::f35_tutorial_func( &"LA_2_HINT_ADS", undefined, ::f35_control_check_ads, "dogfight_done" );
	
	flag_set( "convoy_at_parking_structure" );
	//spawn_manager_enable( "rooftops_parking_structure_guys" );
	//spawn_manager_disable( "spawn_manager_rooftops_apartments" );
	
	wait 0.2;
	
	t_kill_spawn_managers = get_ent( "convoy_waits_after_parking_garage", "targetname", true );
	t_kill_spawn_managers maps\la_2_convoy::_waittill_triggered_by_convoy();
	
	spawn_manager_disable( "rooftops_parking_structure_guys" );
		
	// clean up guys
	a_rooftops_guys = get_ent_array( "rooftop_start_guys", "script_noteworthy" );
	spread_array_thread( a_rooftops_guys, ::mark_ai_for_death );
	
	a_rooftops_end = get_ent( "convoy_dogfight_stop_trigger", "targetname", true );
	a_rooftops_end maps\la_2_convoy::_waittill_triggered_by_convoy();
		
	a_crane_building_guys = get_ent_array( "crane_building_guys", "script_noteworthy" );
	spread_array_thread( a_crane_building_guys, ::mark_ai_for_death );
}



stop_at_spline_end()
{
	if ( self != level.convoy.vh_van )
	{
		self endon( "death" );
	
		self waittill_either( "reached_end_node", "brake" );
	
		self SetSpeed( 0 );
		self vehicle_unload();
	}
}


mark_ai_for_death()
{
	self endon( "death" );
	
	b_is_spawner = IsSpawner( self );
	
	if ( b_is_spawner )
	{
		println( "mark_ai_for_death deleting spawner at " + self.origin );
		self Delete();
		return;
	}
	
	wait RandomFloatRange( 0.1, 5.0 );
	
	b_can_see_target = true;
	
	while ( b_can_see_target )
	{
		b_is_alive = IsAlive( self );
		
		if ( !b_is_alive )
		{
			return;
		}
		
		b_can_see_target = level.player is_looking_at( self.origin );
		
		wait 1;
	}
	
	println( "mark_ai_for_death killing AI at " + self.origin );
	
	if ( IsAlive( self ) )
	{
		self DoDamage( self.health, self.origin );
	}
}

rooftop_ai_individual_objective( str_group_name )
{
	b_should_loop = true;
	b_has_setup_objective = false;
	const n_update_timer = 1;
	b_track_objective = false;
	b_is_new_guy = true;
	
	//e_temp = Spawn( "script_origin", ( 0, 0, 0 ) );
	
	while ( b_should_loop )
	{
		a_guys = get_ai_group_ai( str_group_name );
		
		n_living_count = a_guys.size;
		n_total_count = get_ai_group_count( str_group_name );  // this is to check if any guys have yet to spawn
		
		if ( ( n_living_count == 0 ) && ( n_total_count == 0 ) )
		{
			b_should_loop = false;
		}
		
		if ( n_total_count == n_living_count )  // all guys are alive now
		{
			b_track_objective = true;
		}
		
		if ( b_track_objective && ( n_living_count > 0 ) )
		{
			// TODO: update _objectives to support script_origins...
			e_temp = get_closest_living( level.f35.origin, a_guys );
			
			if ( !b_has_setup_objective )
			{
				//e_temp.origin = v_average_origin;
				maps\_objectives::set_objective( level.OBJ_ROOFTOPS, e_temp, "kill", -1 );
				b_has_setup_objective = true;
			}
			
			
			maps\_objectives::set_objective( level.OBJ_ROOFTOPS, e_temp, "kill" );
			
			e_temp waittill( "death" );
			maps\_objectives::set_objective( level.OBJ_ROOFTOPS, e_temp, "remove" );
				
			continue;
			//e_temp waittill( "death" );
		}
		
		wait n_update_timer;
	}
	
	//e_temp Delete();
	level.rooftop_objective_counter--;
	
	if ( level.rooftop_objective_counter == 0 )
	{
		maps\_objectives::set_objective( level.OBJ_ROOFTOPS, undefined, "delete" );
		maps\_drones::drones_delete( "drone_trigger_example_2" );
		flag_set( "rooftop_enemies_dead" );
	}
	else
	{
		maps\_objectives::set_objective( level.OBJ_ROOFTOPS, undefined, undefined, level.rooftop_objective_counter );
	}
}


convoy_blocked_by_debris()
{
	flag_wait( "building_collapse_done" );
	
	level notify( "kill_pre_building_collapse_drones" );
	
	// kill everything on the ground as the building comes down
	a_ground_vehicles = get_ent_array( "building_collapse_truck", "targetname" );
	a_ground_vehicles[ a_ground_vehicles.size ] = get_ent( "building_collapse_bigrig", "targetname" );
	array_thread( a_ground_vehicles, ::do_vehicle_damage, 9999, level.convoy.vh_potus, "explosive" );
	
	a_axis_ai = GetAIArray( "axis" );
	array_thread( a_axis_ai, ::mark_ai_for_death );
	
	/*
	s_explosion = get_struct( "convoy_dogfight_explosion_struct", "targetname", true );
	s_smoke = get_struct( "convoy_dogfight_explosion_smoke_struct", "targetname", true );
	s_building_fall = get_struct( "convoy_dogfight_building_fall_struct", "targetname", true );
	bm_building = get_ent( "convoy_dogfight_building_brush", "targetname", true );
	s_building_end_point = get_struct( "convoy_dogfight_building_fall_struct", "targetname", true );
	const n_time = 5;
	
	// explosion below
	PlayFX( level._effect[ "dogfight_building_explosion" ], s_explosion.origin );
	
	// building falls
	bm_building MoveTo( s_building_end_point.origin, n_time );
	bm_building RotateTo( s_building_end_point.angles, n_time );
	
	// dust cloud emerges
	//PlayFX( level._effect[ "dogfight_building_smoke" ], s_smoke.origin );
	*/
	
	// radio message: we're alive. not being attacked. thin out the UAVs
	//level thread maps\la_2_anim::vo_dogfight();
	
	// dogfights begin
}


f35_trenchrun()
{
	maps\createart\la_2_art::art_vtol_mode_settings();
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_trenchrun_stop_trigger", "trenchruns_start", ::flag_set, "convoy_at_trenchrun" );
	
	//level thread maps\la_2_player_f35::f35_tutorial_func( &"LA_2_HINT_MODE_VTOL", undefined, maps\la_2_player_f35::f35_control_check_mode, "trenchruns_start" );
	
	t_one = get_ent( "trenchruns_plane_trigger_2", "targetname", true );
	t_two = get_ent( "trenchruns_plane_trigger_3", "targetname", true );
	
	flag_wait( "convoy_at_trenchrun" );
	
	scale_model_LODs( 1, 1 );
	
	autosave_by_name( "la_2" );
	
	b_player_within_range = false;
	const n_distance = 8000;
	n_distance_sq = n_distance * n_distance;
	while ( !b_player_within_range )
	{
		n_distance_current_sq = DistanceSquared( level.convoy.vh_potus.origin, level.player.origin );
		
		if ( n_distance_sq > n_distance_current_sq )
		{
			b_player_within_range = true;
		}
		
		wait 0.1;
	}
	
	while ( !level.f35.is_vtol )
	{
		wait 0.25;
	}
	
	wait 2;
	
	flag_set( "trenchruns_start" );
	level.player thread maps\la_2_player_f35::f35_tutorial( false, false, true, true );
	level thread maps\la_2_anim::vo_trenchruns();
	
	n_trenchrun_planes = 10;
	maps\_objectives::set_objective( level.OBJ_TRENCHRUN_1, undefined, undefined );
	
	const n_speed_wave_1 = 300;
	const n_speed_wave_2 = 250;
	const n_speed_wave_3 = 250;
	const n_speed_fast = 300;
	v_offset = ( 30, 30, 30 );
	const n_update_time = 1;
	level.trenchrun_wave = 1;
	delay_thread( 0.5, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_1", n_speed_wave_1, v_offset, n_update_time );
//	delay_thread( 1.0, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_1a", n_speed_wave_1, v_offset, n_update_time );  // ADD BACK FOR HARDER DIFFICULTY AFTER MILESTONE
	
	t_one maps\la_2_convoy::_waittill_triggered_by_convoy();
	maps\_objectives::set_objective( level.OBJ_TRENCHRUN_1, undefined, "delete" );
	level.trenchrun_wave = 2;
	flag_set( "convoy_at_trenchrun_turn_2" );
	//autosave_by_name( "la_2" );
//	delay_thread( 0.5, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_2", n_speed_wave_2, v_offset, n_update_time );  // ADD BACK FOR HARDER DIFFICULTY AFTER MILESTONE
	delay_thread( 1.0, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_2a", n_speed_wave_2, v_offset, n_update_time );
//	delay_thread( 1.5, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_2b", n_speed_wave_2, v_offset, n_update_time );  // ADD BACK FOR HARDER DIFFICULTY AFTER MILESTONE
	
	t_two maps\la_2_convoy::_waittill_triggered_by_convoy();
	maps\_objectives::set_objective( level.OBJ_TRENCHRUN_2, undefined, "delete" );
	level.trenchrun_wave = 3;
	flag_set( "convoy_at_trenchrun_turn_3" );
	autosave_by_name( "la_2" );
//	delay_thread( 0.6, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_3a", n_speed_wave_3, v_offset, n_update_time );  // ADD BACK FOR HARDER DIFFICULTY AFTER MILESTONE
	delay_thread( 1.0, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_3", n_speed_wave_3, v_offset, n_update_time );
//	delay_thread( 1.5, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_3_left", n_speed_wave_3, v_offset, n_update_time );  // ADD BACK FOR HARDER DIFFICULTY AFTER MILESTONE
	delay_thread( 4.5, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_3b", n_speed_wave_3, v_offset, n_update_time );
	//delay_thread( 6.5, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_3d", n_speed_wave_3, v_offset, n_update_time );
	//delay_thread( 7.2, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_3c", n_speed_wave_3, v_offset, n_update_time );
	//delay_thread( 11.0, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_3_right", n_speed_fast, v_offset, n_update_time );
	
	n_max_wait = 17;
	delay_thread( n_max_wait, maps\_objectives::set_objective, level.OBJ_TRENCHRUN_3, undefined, "delete" );

	delay_thread( n_max_wait, ::flag_set, "trenchrun_done" );
}

do_vehicle_damage( n_amount, e_attacker, str_damage_type )
{
	if ( IsDefined( self.armor ) )
	{
		self.armor -= n_amount;
	}
	
	if ( !IsDefined( str_damage_type ) )
	{
		str_damage_type = "explosive";
	}
	
	self DoDamage( n_amount, self.origin, e_attacker, e_attacker, str_damage_type );
}

spawn_trenchrun_plane( str_spawner_name, str_start_point, n_speed, v_offset, n_update_time, b_track )
{
	Assert( IsDefined( str_spawner_name ), "str_spawner_name is a required argument for spawn_trenchrun_plane!" );
	Assert( IsDefined( str_start_point ), "str_start_point is a required argument for spawn_trenchrun_plane!" );
	
	sp_vehicle = get_vehicle_spawner( str_spawner_name, "targetname" );
	//nd_start = get_struct( str_start_point, "targetname" );
	nd_start = GetVehicleNode( str_start_point, "targetname" );
	
	if ( !IsDefined( sp_vehicle.angles ) )
	{
		sp_vehicle.angles = ( 0, 0, 0 );
	}
	
	if ( !IsDefined( nd_start.angles ) )
	{
		nd_start.angles = ( 0, 0, 0 );
	}
	
	if ( !IsDefined( n_speed ) )
	{
		n_speed = 250;
	}
	
	if ( !IsDefined( b_track ) )
	{
		b_track = true;
	}
	
	const n_accel = 1000;
	const n_decel = 1000;
	v_origin_old = sp_vehicle.origin;
	v_angles_old = sp_vehicle.angles;
	sp_vehicle.origin = nd_start.origin;
	sp_vehicle.angles = nd_start.angles;
	vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( str_spawner_name );
	vh_plane thread trenchrun_sanity_check();
	vh_plane endon( "death" );
	
	if ( b_track )
	{
		if ( !IsDefined( level.trenchrun_planes ) )
		{
			level.trenchrun_planes = [];
		}
		
		level.trenchrun_planes[ level.trenchrun_planes.size ] = vh_plane;
	}
	
	sp_vehicle.origin = v_origin_old;
	sp_vehicle.angles = v_angles_old;
	//iprintlnbold( "trenchrun plane spawned!" );
	//vh_plane thread [[ func_behavior ]]();
	
//	vh_plane thread trenchrun_add_objective_to_plane();
	const n_near_goal_dist = 700;
	const n_near_goal_dist_suicide = 192;
	const n_near_goal_draw_red_line = 10192;
	
	vh_plane SetSpeed( n_speed, n_accel, n_decel );
	Target_Set( vh_plane );
	vh_plane EnableAimAssist();
	
//	vh_plane AttachPath( nd_start );
//	vh_plane SetNearGoalNotifyDist( n_near_goal_dist );
//	vh_plane.drivepath = 1;
//	vh_plane thread go_path( nd_start );
	//vh_plane waittill_either( "near_goal", "goal" );
	
//	vh_plane waittill( "movepath_now" );
	
	//nd_end = GetVehicleNode( str_spawner_name + "_end", "targetname" );
	//vh_plane PathMove( nd_end, vh_convoy_leader.origin, vh_plane.angles );
	vh_convoy_leader = maps\la_2_convoy::convoy_get_leader();
	//vh_plane thread trenchrun_draw_line( vh_convoy_leader, n_near_goal_draw_red_line );
	vh_plane.using_ai = false;
	vh_plane thread _trenchrun_update_goal_pos( n_near_goal_draw_red_line );
//	vh_plane fly_to_spline_end( nd_start );
	
	if ( IsDefined( v_offset ) && !IsDefined( n_update_time ) )
	{
		vh_plane PathFixedOffset( v_offset );
	}
	else if ( IsDefined( v_offset ) && IsDefined( n_update_time ) )
	{
		vh_plane PathVariableOffset( v_offset, n_update_time );
	}
	
	vh_plane SetNearGoalNotifyDist( n_near_goal_dist );
	vh_plane thread go_path( nd_start );
	vh_plane waittill( "reached_end_node" );
	vh_plane.using_ai = true;
	//iprintlnbold( "end of spline" );

	// make sure other planes won't shoot at this one
	vh_plane notify( "stop_ambient_behavior" );
	vh_plane.no_tracking = true;
	vh_plane ClearVehGoalPos();
	//vh_plane SetVehGoalPos( vh_convoy_leader.origin );
	vh_plane SetSpeed( n_speed, n_accel, n_decel );
	
	//vh_plane SetNearGoalNotifyDist( n_near_goal_dist );
	
	vh_plane waittill( "near_goal" );
	// TEMP UNTIL NEAR_GOAL WORKS:
	/*
	n_distance = 9999999;
	while ( n_distance > n_near_goal_dist )
	{
		n_distance = Distance( vh_plane.origin, vh_convoy_leader.origin );
		
		wait 0.05;
	} */
	
	//iprintlnbold( "plane blows up" );
	//vh_plane notify( "death" );
	vh_convoy_leader = vh_plane.suicide_target;
	vh_plane.takedamage = true;
	vh_plane DoDamage( vh_plane.health + 1000, vh_plane.origin, vh_convoy_leader, vh_convoy_leader, "explosive" );
	// damage convoy leader

	if ( vh_convoy_leader == level.convoy.vh_potus )
	{
		// play sound for president's vehicle getting hit by a drone
	}
	
	vh_convoy_leader do_vehicle_damage( vh_convoy_leader.armor, vh_plane );
}

trenchrun_sanity_check()
{
	self endon( "death" );
	
	const n_distance_max = 1500;
	
	while ( !IsDefined( self.suicide_target ) )
	{
		wait 0.1;
	}
	
	while ( true )
	{
		n_distance = Distance( self.origin, self.suicide_target.origin );
		
		b_too_close = ( n_distance < n_distance_max );
		
		if ( b_too_close )
		{
			wait 2.5;
			println( "trenchrun sanity check failed!" );
			self DoDamage( self.health + 9999, self.origin, self.suicide_target, self.suicide_target, "explosive" );
		}
		
		wait 0.1;
	}
}

/#
_print_goal_line( s_goal, n_red, n_green, n_blue, n_refresh_time )
{
	self notify( "_kill_goal_line" );
	self endon( "_kill_goal_line" );
	self endon( "death" );
	
	if ( !IsDefined( n_red ) )
	{
		n_red = 1;
	}
	
	if ( !IsDefined( n_green ) )
	{
		n_green = 1;
	}

	
	if ( !IsDefined( n_blue ) )
	{
		n_blue = 1;
	}
	
	if ( !IsDefined( n_refresh_time ) )
	{
		n_refresh_time = 1;
	}
		
	while ( true )
	{
		n_distance = Distance( self.origin, s_goal.origin );
		//iprintln( n_distance );
		self thread draw_line_for_time( self.origin, s_goal.origin, n_red, n_green, n_blue, n_refresh_time );
		wait n_refresh_time;
	}
}
#/

_trenchrun_update_goal_pos( n_near_goal_draw_red_line )
{
	self endon( "death" );
	n_time = 0.5;
	n_r = 1;
	n_g = 0.55;
	n_b = 0;
	b_first_run = true;
	
	while ( true )
	{
		e_target = maps\la_2_convoy::convoy_get_leader();
		self.suicide_target = e_target;
		
//		if ( b_first_run )
//		{
//			self thread _print_goal_line( e_target, n_r, n_g, n_b, 0.05 );
//			self thread notify_delay( "_kill_goal_line", 5 );
//			b_first_run = false;
//		}
		
		if ( is_alive( e_target ) )
		{
			n_speed = e_target GetSpeedMPH();
			v_forward = AnglesToForward( e_target.angles );
			v_predicted_location = e_target.origin + ( v_forward * n_speed * n_time );
			
			// "predictive line"
			n_distance = Distance( self.origin, e_target.origin );
			
			if ( n_distance < n_near_goal_draw_red_line )
			{
				n_r = 1;
				n_g = 0;
				n_b = 0;
			}
			
			if ( self.using_ai )
			{
				self SetVehGoalPos( v_predicted_location );
			}
		}
		
		wait 0.05;
	}
}
/#
trenchrun_draw_line( e_target, n_distance_to_red )  // self = plane
{
	self endon( "death" );
	
	self thread _print_goal_line( e_target, 1, 0.55, 0, 0.05 );

	while ( true )
	{
		n_distance = Distance( self.origin, e_target.origin );
		
		if ( n_distance < n_distance_to_red )
		{
			self thread _print_goal_line( e_target, 1, 0, 0, 0.05 );
		}
		
		wait 0.05;
	}
}
#/
	
trenchrun_add_objective_to_plane()  // self = plane
{
	if ( !IsDefined( level.trenchrun_wave ) )
	{
		level.trenchrun_wave = 1;
	}
	
	n_wave = level.trenchrun_wave;
	
	if ( n_wave == 1 )
	{
		n_objective = level.OBJ_TRENCHRUN_1;
	}
	else if ( n_wave == 2 )
	{
		n_objective = level.OBJ_TRENCHRUN_2;
	}
	else if ( n_wave == 3 )
	{
		n_objective = level.OBJ_TRENCHRUN_3;
	}
	else if ( n_wave == 4 )
	{
		n_objective = level.OBJ_TRENCHRUN_4;
	}
	else
	{
		AssertMsg( "trenchrun wave " + n_wave + " not supported" );
	}
	
	maps\_objectives::set_objective( n_objective, self, "", -1 );
	
	self waittill( "death" );
	
	maps\_objectives::set_objective( n_objective, self, "remove" );
}

f35_hotel()
{
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_hotel_stop_trigger", "hotel_done", ::flag_set, "convoy_at_hotel" );
	
	flag_wait( "convoy_at_hotel" );
		//array_notify( level.convoy.vehicles, "convoy_stop" );
	for ( i = 0; i < level.convoy.vehicles.size; i++ )
	{
		level.convoy.vehicles[ i ] notify( "convoy_stop" );
		level.convoy.vehicles[ i ] ent_flag_clear( "is_moving" );
	}
	level.convoy.vh_van notify( "convoy_stop" );
	flag_wait( "trenchrun_done" );
	
	//iprintlnbold( "missiles disabled!" );
	level.f35 notify( "stop_turret_shoot" );
	level.player notify( "turretownerchange" );
	
	wait 2;
	
	autosave_by_name( "la_2" );
	
	delay_thread( 0.5, maps\la_2_anim::vo_hotel );
	
	const n_speed_fast = 200;
	v_offset = ( 30, 30, 30 );
	const n_update_time = 1;
	level.trenchrun_wave = 4;
//	delay_thread( 1.0, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_4", n_speed_fast, v_offset, n_update_time );	// ADD BACK FOR HARDER DIFFICULTY AFTER MILESTONE
//	delay_thread( 4.0, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_4a", n_speed_fast, v_offset, n_update_time );
	delay_thread( 2.5, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_4b", n_speed_fast, v_offset, n_update_time );
	delay_thread( 4.9, ::spawn_trenchrun_plane, "avenger_fast_la2", "trenchrun_spline_low_4c", n_speed_fast, v_offset, n_update_time );
	
	wait 10;  // wait long enough to spawn all planes
	
	while ( level.trenchrun_planes.size > 0 )
	{
		wait 1;
		level.trenchrun_planes = array_removeDead( level.trenchrun_planes );
	}
	
	//iprintlnbold( "guns disabled!" );
	level.f35 thread say_dialog( "nose_cannons_offli_038" );//Nose cannons offline.
	level.f35 notify( "stop_f35_minigun" );
	
	//iprintlnbold( "hotel" );
	//simple_spawn( "hotel_guys" );
	
	//waittill_ai_group_cleared( "hotel_guys" );
	
	flag_set( "hotel_done" );
}

f35_eject()
{
	//flag_wait( "hotel_done" );
	
	//autosave_by_name( "la_2" );
	
//	level.f35 SetVehicleType( "plane_f35_player_vtol_dogfight" );
//	f35_lock_to_mesh();
//	level.f35 delay_thread( 4, ::do_very_damaged_feedback );
	
	level thread spawn_ambient_drones( "trig_eject_parachute_flyby_1", "trig_kill_parachute_flyby_1", "pegasus_eject_parachute_flyby_1", "f38_eject_parachute_flyby_1","start_eject_parachute_flyby_1", 3, 5, 1.5, 2, 450 );		
//	level thread spawn_ambient_drones( "trig_eject_parachute_flyby_2", undefined, "pegasus_eject_parachute_flyby_2", "f38_eject_parachute_flyby_2","start_eject_parachute_flyby_2", 3, 5, 2, 3, 500 );		
	level thread spawn_ambient_drones( "trig_eject_parachute_flyby_3", "trig_kill_parachute_flyby_3", "pegasus_eject_parachute_flyby_3", "f38_eject_parachute_flyby_3","start_eject_parachute_flyby_3", 3, 5, 1, 1.5, 550 );				
	level thread spawn_ambient_drones( "trig_eject_parachute_flyby_4", "trig_kill_parachute_flyby_4", "pegasus_eject_parachute_flyby_4", "f38_eject_parachute_flyby_4","start_eject_parachute_flyby_4", 1, 8, 2, 3, 400 );					

	nd_start = eject_wait_for_player_position();
	eject_move_align_struct( nd_start );
	
	f35_eject_intro();
	f35_eject_eject();
	f35_eject_collision();
	
//	f35_eject_intro_test();
	
	//iprintlnbold( "eject done" );
	maps\_objectives::set_objective( level.OBJ_TRENCHRUN_4, undefined, "delete" );
	flag_set( "eject_done" );

}
	
#define NEAR_BUILDING_DIST 3000
    
eject_wait_for_player_position()
{
    a_eject_drone_starts = GetVehicleNodeArray( "eject_sequence_spline", "script_noteworthy" );
    nd_spline_start = a_eject_drone_starts[0];    
    
    do 
    {
        b_spawn_ready = false;    
        
        wait .2;
        waittill_player_near_convoy_and_f35_for_eject();
        
        foreach( nd_start_node in a_eject_drone_starts )
        {
            if( Distance2DSquared( level.f35.origin, nd_start_node.origin ) > Distance2DSquared( level.f35.origin, nd_spline_start.origin ) )
            {
                nd_spline_start = nd_start_node;
            }
        }
        
//        v_f38_forward = VectorNormalize( AnglesToForward( level.f35.angles ) );
//        v_trace_end = level.f35.origin + (v_f38_forward * NEAR_BUILDING_DIST);
//        v_trace_start = level.f35.origin + (v_f38_forward * 250);
        is_clear = BulletTracePassed( level.f35.origin, nd_spline_start.origin, false, level.f35 );        
        
        if ( is_clear && level.player is_looking_at( level.convoy.leader, .7, false ) )
        {
            b_spawn_ready = true; // level.player is_looking_at( nd_spline_start.origin, .7, true ); 
        }
        
    } while( !b_spawn_ready );    
    
    return nd_spline_start;
}


#define GOAL_DIST_POTUS_SQ 15000 * 15000
#define GOAL_DIST_F35_SQ 10000 * 10000


waittill_player_near_convoy_and_f35_for_eject()
{
	s_facing_pos = getstruct( "eject_facing_pos", "targetname" );
	vh_friendly = GetEntArray( "convoy_f35_ally_4", "targetname" )[0];
	
	do
	{
		while ( !IsDefined( vh_friendly ) )
		{
			vh_friendly = GetEntArray( "convoy_f35_ally_4", "targetname" )[0];			
			wait( 0.05 );
		}
		
		b_facing_drone = false;
		
		wait .2;
				
		if ( IsDefined( vh_friendly ) )
		{
			n_dist = Distance2DSquared( level.f35.origin, level.convoy.vh_potus.origin );
			n_f35_dist = DistanceSquared( level.f35.origin, vh_friendly.origin );
				
			if ( n_dist <= GOAL_DIST_POTUS_SQ && n_f35_dist <= GOAL_DIST_F35_SQ )
			{
				v_player_to_plane = VectorNormalize( vh_friendly.origin - level.f35.origin);
				v_plane_forward = VectorNormalize( AnglesToForward( vh_friendly.angles ) );
				v_player_forward = VectorNormalize( AnglesToForward( level.f35.angles ) );
				
				if ( VectorDot( v_player_to_plane, v_plane_forward ) > 0.7 ) 	// is the plane in front of the player?
				{
					if ( VectorDot( v_plane_forward, v_player_forward ) > 0.8 )	// Is the player and this plane moving the same direction?
					{
						b_facing_drone = true;	
					}
				}			
				//b_facing_drone = level.player is_looking_at( s_facing_pos.origin, .65, true );
			}
		}
	}
	while ( !b_facing_drone );
}

eject_move_align_struct( nd_start )
{
	s_align = GetStruct( "align_eject_sequence", "targetname" );
	
	n_speed = level.f35 GetMaxSpeed();
	n_time = GetAnimLength( %vehicles::v_la_10_01_f35eject_drone_intro ) + 2;
	n_eject_offset = n_speed * n_time;
	
	// Origin
	v_player_to_node = VectorNormalize( nd_start.origin - level.f35.origin );
	v_start_point = nd_start.origin; // level.f35.origin + ( v_player_to_node * n_eject_offset );
	
	s_align.origin = v_start_point;
	
	// Angles
	v_rotate_to = VectorToAngles( v_player_to_node );
	VEC_SET_X( v_rotate_to, 0 );
	VEC_SET_Z( v_rotate_to, 0 );
	
	s_align.angles = v_rotate_to;
}

f35_eject_intro()
{
	s_align = GetStruct( "align_eject_sequence", "targetname" );
	
	level notify( "kill_ambient_drone_spawn_manager" );
	
	// Set fog changes
	
	level.f35 notify ( "stop_f35_minigun" );
	level.f35 notify ( "stop_turret_shoot" );
	level clientnotify( "set_eject_fog_bank" );
	
	// Get the enemies out of the way
	level thread f35_eject_enemies_fly_away();
	
	// move the player's plane to the starting position
	m_linkto = spawn_model( "tag_origin", level.f35.origin, level.f35.angles );
	m_linkto.targetname = "eject_align_origin";
	m_linkto LinkTo( level.f35, "tag_origin" );
	
	m_lookat = spawn_model( "tag_origin", s_align.origin, s_align.angles );
	
	v_to_goal = VectorToAngles(s_align.origin - level.f35.origin );
	
	level.f35 CancelAIMove();
	level.f35 SetPhysAngles( (0, v_to_goal[1], 0 ) );
//	wait( 0.05 );
//	level.f35 thread test();
//	level.f35 SetLookAtEnt( m_lookat );
//	level.f35 SetSpeed( 200, 50 );
	level.f35 SetVehicleType( "plane_f35_player_vtol_dogfight" );
	level.f35 SetVehicleAvoidance( true );
	level.f35 SetSpeedImmediate( 200, 500 );
	level.f35 SetVehGoalPos( s_align.origin, false );
	
	//level.f35 LinkTo( m_linkto );
	//n_moveto_time = GetAnimLength( %vehicles::v_la_10_01_f35eject_drone_intro ) + 2;
	//v_f35_to_drone = VectorNormalize( s_align.origin - level.f35.origin );
	
//	f35_show_console( "tag_display_malfunction" );
	
//	m_linkto MoveTo( s_align.origin, n_moveto_time );
//	m_linkto RotateTo( s_align.angles, 2, 1 );	
	
	// Start up the incoming plane
	vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( "eject_sequence_drone" );
	wait .1;
	
	vh_plane SetModel( "veh_t6_drone_avenger_x2" );	
	vh_plane linkto( m_linkto );
	
	PlayFXOntag( level._effect[ "drone_damaged_state" ], vh_plane, "tag_origin" );
	
	add_scene_properties( "f35_eject_drone_intro", "eject_align_origin" );
	level thread maps\_scene::run_scene( "f35_eject_drone_intro" );
	
	level thread maps\la_2_anim::vo_eject();
	
	flag_set( "eject_drone_spawned" );
	
	vh_plane thread f35_eject_highlight_drone();
	vh_plane thread eject_plan_fire_before_eject();
	
	maps\_scene::scene_wait( "f35_eject_drone_intro" );
}

test()
{
	self endon( "death" );
	
	while ( true )
	{
		level.f35 SetAngularVelocity( (0, 0, 0) );
		level.f35 SetPhysAngles( (0, self.angles[1], 0) );
		wait 0.05;		
	}
}


f35_eject_intro_test()
{
//	vh_drone = GetEnt( "eject_test_drone", "targetname" );
//	vh_drone thread eject_plan_fire_before_eject();
//	
//	vh_drone veh_magic_bullet_shield( true );
//	
//	vh_drone thread f35_eject_highlight_drone();
//	
//	while ( true )
//	{
//		wait 1;	
//	}
}

f35_eject_enemies_fly_away()
{
//	a_drones = GetEntArray( "convoy_strafing_plane", "targetname" );
//	foreach( vh_drone in a_drones )
//	{
//		vh_drone getoffpath();
//		v_forward = VectorNormalize( AnglestoForward( vh_drone.angles ) );
//		v_new_goal = vh_drone.origin + ( v_forward * 10000 );
//		VEC_SET_Z( v_new_goal, 20000 );
//		vh_drone SetVehGoalPos( v_new_goal );
//	}
}

f35_eject_highlight_drone()
{
	level.player notify ( "missileTurret_off" );
	level.player maps\_lockonmissileturret::ClearLockonTarget();
	
	Target_Set( self );
	
//	self SetClientFlag( 15 );
	
	level.player WeaponLockStart( self );
	wait 2;
	level.player WeaponLockFinalize( self );

//	level waittill ( "midair_collision_started" );
//	self ClearClientFlag( 15 );
}

f35_eject_eject()
{
	f35_eject_sequence_setup();
	
	level.f35.supportsAnimScripted = true;
	level.f35 thread maps\la_2_anim::vo_eject_f35();

	add_scene_properties( "F35_eject", "eject_align_origin" );
	
	// Link the player body to the origin before progressing	
	level thread f35_eject_player();
	
	// now start the animation
	level thread maps\_scene::run_scene( "F35_eject" );
	
	wait .1;

	flag_set( "eject_sequence_started" );
	
	maps\_scene::scene_wait( "F35_eject" );
	
	vh_plane = get_ent( "eject_sequence_drone", "targetname", true );
//	level.f35 Unlink();
	vh_plane Unlink();
//	level.player Unlink();
}

f35_eject_player()
{
	m_linkto = GetEnt( "eject_align_origin", "targetname" );
	
	level.player.body = spawn_anim_model( "player_body", level.player.origin );
	level.player.body.angles = level.player.angles;
	m_linkto maps\_anim::anim_first_frame( level.player.body, "f35_eject_start" );
	level.player.body LinkTo( m_linkto );
	
	/*
	level.fake_f35 = spawn_model( "veh_t6_air_fa38", level.f35.origin, level.f35.angles );
	level.fake_f35 linkto( m_linkto );
	
	
	s_align = GetStruct( "anim_end_struct", "targetname" );
	v_start_origin = GetStartOrigin( s_align.origin, s_align.angles, %vehicles::v_la_10_01_f35eject_f35 );
	v_start_angles = GetStartAngles( s_align.origin, s_align.angles, %vehicles::v_la_10_01_f35eject_f35 );
	level.second_fake_f35 = spawn_model( "veh_t6_air_fa38", v_start_origin, v_start_angles );
	
	/#
	RecordEnt( level.fake_f35 );
	RecordEnt( level.second_fake_f35 );
	#/
	*/
	
	wait 0.05;
	
	//level.f35 Hide();
	
	//m_linkto thread maps\_anim::anim_single( level.player.body, "f35_eject_start" );
	m_linkto thread maps\_anim::anim_single_aligned( level.player.body, "f35_eject_start" );
	
	wait .05;
	
	level.f35 UseBy( level.player );
	level.player PlayerLinkToAbsolute( level.player.body, "tag_player" );
	
	level thread player_exits_f35();
}

f35_eject_collision()
{
	level notify( "midair_collision_started" );
	level clientnotify( "set_outro_fog_bank" );		// set the fog back to normal
	
	f35_eject_warp_plane_to_collision();

	/*
	while ( true )
	{
		wait 1;	
	}
	*/
	
	level.f35 Unlink();
	level.player Unlink();
	
	level thread maps\_audio::switch_music_wait ("LA_2_PARACHUTE", 0.5);
	
	level.f35 HidePart( "tag_canopy" );
	level thread maps\_scene::run_scene( "midair_collision" );
	
	m_player_body = get_model_or_models_from_scene( "midair_collision", "player_body" );
	PlayFXOnTag( level._effect[ "ejection_seat_rocket" ], m_player_body, "J_SpineLower" );	// ejection seat fx

	level thread maps\la_2_anim::vo_eject_collision();
	
	maps\_scene::scene_wait( "midair_collision" );	
}

f35_eject_warp_plane_to_collision()
{
	s_align = GetStruct( "anim_end_struct", "targetname" );
	m_linkto = GetEnt( "eject_align_origin", "targetname" );
	
	v_start_origin = GetStartOrigin( s_align.origin, s_align.angles, %vehicles::v_la_10_01_f35eject_f35 );
	v_start_angles = GetStartAngles( s_align.origin, s_align.angles, %vehicles::v_la_10_01_f35eject_f35 );
	
	level.player thread fadeToBlackForXSec( 0, 0.05, 0.05, 0.4 );
	
	m_linkto.origin = v_start_origin;
	m_linkto.angles = v_start_angles;
	
	//level.second_fake_f35 Hide();
}


f35_eject_sequence_setup()
{
	level.convoy.vh_van notify( "unload" );
	
	level.f35 play_fx( "f35_console_blinking", undefined, undefined, "health_at_max", true, "tag_origin" );
	f35_show_console( "tag_display_eject" );
	
	// change fov to match the driver's seat since player isn't 'using' it anymore
	const n_fov_f35 = 70;
	n_fov_default = GetDvarFloat( "cg_fov_default" );
	level.player SetClientDvar( "cg_fov", n_fov_f35 );
	
	// doing this manually since _scene isn't working right with linki
	level.player EnableInvulnerability();
	//level.player DisableWeapons();
	level.player TakeAllWeapons();
	LUINotifyEvent( &"hud_f35_end" );
	
	level thread maps\createart\la_2_art::eject();
	exploder( 600 );
	
	// lighting to help show hero's face (harper/samuels enter the end scene in different places)
	if ( flag( "harper_dead" ) )
	{
		exploder( 710 );
	}
	else
	{
		exploder( 700 );
	}
	
	level.player SetClientDvar( "cg_fov", n_fov_default );
}

f35_intercepts_drone()
{
	level endon( "midair_collision_started" );
	
	level waittill( "eject_sequence_ready" );
	
	const n_distance_threshold = 1024;
	const n_speed_intercept = 200;
	vh_drone = get_ent( "eject_sequence_drone", "targetname", true );
	vh_drone.supportsAnimScripted = true;
	
	player_exits_f35();
	flag_set( "eject_sequence_started" );
	
	wait 0.25;
	//level.player LinkTo( level.f35 );
	//level.f35 SetLookAtEnt( vh_drone );
	
	level.f35 CancelAIMove();
	level.f35 SetSpeed( n_speed_intercept );

	m_linkto = spawn_model( "tag_origin", level.f35.origin, level.f35.angles );
	level.f35 LinkTo( m_linkto );
	n_moveto_time = Distance( level.f35.origin, vh_drone.origin ) / (n_speed_intercept * 20);
	v_f35_to_drone = VectorNormalize( vh_drone.origin - level.f35.origin );
	v_rotate_to = VectorToAngles( v_f35_to_drone );
	
	m_linkto MoveTo( vh_drone.origin, n_moveto_time );
	m_linkto RotateTo( v_rotate_to, 1, .25, .25 );
	
//	level.f35 SetVehVelocity( v_f35_to_drone * n_speed_intercept * 20 );	
	//level.f35.angles = VectoToAngles( v_f35_to_drone );
	
	//level.f35 SetSpeed( n_speed_intercept );	
		
	while ( n_distance_threshold < Distance( level.f35.origin, vh_drone.origin ) )
	{
		//level.f35 SetVehGoalPos( vh_drone.origin );

		//level.f35 thread _print_goal_line( vh_drone, 1, 1, 1, 0.05 );
		//level.f35 SetLookAtEnt( vh_drone );
		wait 0.05;
	}
	
	level.convoy.vh_potus.takedamage = false;
	level.f35 do_vehicle_damage( level.f35.health_regen.health, vh_drone );
	vh_drone do_vehicle_damage( vh_drone.health, level.f35 );
	//iprintlnbold( "midair collision!" );
}

eject_drone_spawn()
{
	/*
	vh_drone = maps\_vehicle::spawn_vehicle_from_targetname( "eject_sequence_drone" );
	vh_drone.animname = "eject_sequence_drone";

	nd_path = GetVehicleNode( vh_drone.target, "targetname" );
	vh_drone thread go_path( nd_path );
	*/
	
	v_offset = undefined;
	n_update_time = undefined;
	
	level.convoy.leader = level.convoy.vh_potus;
	level.convoy.leader.takedamage = true;
	
	maps\_lockonmissileturret::DisableLockOn();
	level.missile_lock_on_range = undefined;
	
	a_eject_drone_starts = GetVehicleNodeArray( "eject_sequence_spline", "script_noteworthy" );
	nd_spline_start = a_eject_drone_starts[0];

	do 
	{
		b_spawn_ready = false;	
		
		wait .2;
		waittill_player_near_convoy_and_f35_for_eject();
		
		foreach( nd_start_node in a_eject_drone_starts )
		{
			if( Distance2DSquared( level.f35.origin, nd_start_node.origin ) > Distance2DSquared( level.f35.origin, nd_spline_start.origin ) )
			{
				nd_spline_start = nd_start_node;
			}
		}
		
		if ( level.player is_looking_at( level.convoy.leader, .7, true ) )
		{
			b_spawn_ready = true; // level.player is_looking_at( nd_spline_start.origin, .7, true ); 
		}
		
	} while( !b_spawn_ready );
	
	flag_set( "eject_drone_spawned" );
	
	level thread spawn_trenchrun_plane( "eject_sequence_drone", nd_spline_start.targetname, 200, v_offset, n_update_time );
	wait 0.1;
	level thread maps\la_2_anim::vo_no_guns();
	vh_plane = get_ent( "eject_sequence_drone", "targetname", true );
	vh_plane SetModel( "veh_t6_drone_avenger_x2" );
	//Target_Remove( vh_plane );
	vh_plane thread eject_plan_fire_before_eject();
	vh_friendly = GetEntArray( "convoy_f35_ally_4", "targetname" )[0];
	PlayFx( level._effect[ "plane_deathfx_small" ], vh_friendly.origin, AnglesToForward( vh_friendly.angles ) );	
	vh_friendly do_vehicle_damage( vh_friendly.health, vh_plane );
	
	wait 2;
//	Target_Set( vh_plane );
	//vh_plane waittill( "missileLockTurret_locked" );
	
	vh_plane thread near_convoy_fail_watcher();
	
	is_looking_at = false;
	while ( !is_looking_at )
	{
		v_drone_forward = VectorNormalize( AnglesToForward( vh_plane.angles ) );
		v_f35_forward = VectorNormalize( AnglesToForward( level.f35.angles ) );
		
		if ( VectorDot( v_drone_forward, v_f35_forward ) < -0.8 )
		{
			if( level.player is_player_looking_at( vh_plane.origin, 0.8, true, level.f35 ) )
			{
				is_looking_at = true;
			}
		}
		wait 0.05;
	}
	
	level notify( "eject_sequence_ready" );
	//iprintlnbold( "F35 locked on" );
}

eject_plan_fire_before_eject()
{
	level endon( "midair_collision_started" );
	
	vh_friendly = GetEntArray( "convoy_f35_ally_4", "targetname" )[0];
	vh_friendly do_vehicle_damage( vh_friendly.health, self );
	
	self maps\la_2_fly::_setup_plane_firing_by_type();
	
	for ( i = 0; i < self.weapon_indicies.size; i++ )
	{
		n_index = self.weapon_indicies[ i ];
		self maps\_turret::set_turret_target( level.convoy.vh_potus, ( 0, 0, 0 ), n_index );	
	}		
	
	wait 1; 
	
	while ( !flag( "ejection_start" ) )
	{
		self eject_plane_fire( level.convoy.vh_potus, false, true );
		wait RandomIntRange( 1, 2 );
	}
}

eject_plane_fire( e_target, use_actual_pos = false, use_rockets = false )
{
	level endon( "midair_collision_started" );
	e_target endon( "death" );
	
	v_offset = ( 0, 0, 0 );
	n_fire_time = RandomIntRange( 2, 3 );
	
	for ( i = 0; i < self.weapon_indicies.size; i++ )
	{
		n_index = self.weapon_indicies[ i ];
		self maps\_turret::set_turret_target( e_target, v_offset, n_index );	
		self thread maps\_turret::fire_turret_for_time( n_fire_time, n_index );
	}
}

near_convoy_fail_watcher()
{
	level endon( "eject_done" );
	self endon( "death" );
	
	v_convoy_vehicle = level.convoy.vehicles[0];
	n_fail_dist = 3000 * 3000;
	
	while ( true )
	{
		n_dist = Distance2DSquared( v_convoy_vehicle.origin, self.origin );
		
		if ( n_dist < n_fail_dist )
		{
			SetDvar( "ui_deadquote", &"LA_2_OBJ_PROTECT_FAIL" );
			MissionFailed();				
		}
		
		wait 0.05;
	}
}

f35_outro()
{
	flag_wait( "eject_done" );
	
	level thread maps\createart\la_2_art::outro();
	exploder( 610 );
	
	ai_harper = init_hero( "harper" );
	
	ai_harper Unlink();  // get harper out of van
	
	// attach cougar interior model to POTUS vehicle
	level.convoy.vh_potus Attach( "veh_t6_mil_cougar_interior" );
	level.convoy.vh_potus HidePart( "tag_door_l", "veh_t6_mil_cougar_interior" );
	level.convoy.vh_potus HidePart( "tag_door_r", "veh_t6_mil_cougar_interior" );
	a_temp = level.convoy.vehicles;
	a_temp[ a_temp.size ] = level.convoy.vh_van;
	
	foreach ( veh in a_temp )
	{
		veh notify( "goal" );
		veh notify( "_convoy_vehicle_think_stop" );
		veh ClearVehGoalPos();
		veh.takedamage = false;
		veh CancelAIMove();
		veh.supportsAnimScripted = true;
	}
		
	//level.convoy.vh_potus play_fx( "intro_cougar_godrays", undefined, undefined, "stop_godrays", true, "tag_body_animate_jnt" );
	level.convoy.vh_potus play_fx( "cougar_dome_light", undefined, undefined, -1, true, "tag_fx_domelight" );
	
	if ( is_alive( level.convoy.vh_g20_1 ) )
	{
		if ( !flag( "harper_dead" ) )
		{
			level thread maps\_scene::run_scene( "outro_g20_1" );
		}
		else
		{
			level thread maps\_scene::run_scene( "outro_g20_1_noharper" );
		}
	}
	
	if ( is_alive( level.convoy.vh_g20_2 ) )
	{
		if ( !flag( "harper_dead" ) )
		{
			level thread maps\_scene::run_scene( "outro_g20_2" );
		}
		else
		{
			level thread maps\_scene::run_scene( "outro_g20_2_noharper" );
		}		
	}

	if ( !flag( "harper_dead" ) )
	{
		level thread maps\_scene::run_scene( "outro_hero" );
	}
	else
	{
		level thread maps\_scene::run_scene( "outro_hero_noharper" );
	}
	
	level thread press_fadeout();
	wait 1;
	vh_potus_convoy = GetEnt( "convoy_potus", "targetname" );
	vh_potus_convoy thread potus_convoy_interior_setup();
	maps\_scene::scene_wait( "outro_hero" );
	
	flag_set( "outro_done" );
}

outro_pip( guy )
{
	wait 2;
	level thread maps\_glasses::play_bink_on_hud( "la_pip_seq_1", !BINK_IS_LOOPING, !BINK_IN_MEMORY );
	wait 3;
	level.player queue_dialog( "pres_you_did_a_great_serv_0" ); //You did a great service to your country today, Agent Mason.  I sincerely hope that one day we will find a way express our gratitude.
	level.player queue_dialog( "pres_in_the_meantime_0" );	//In the meantime... Find the man responsible for all this...
	level.player queue_dialog( "pres_and_make_sure_ju_0" );	//... And make sure justice is served.                       
}

press_fadeout()
{
	wait 12; // wait for harper to finish his first line of VO
	//Eckert - Fade out sound
	level clientnotify("fade_out");
	screen_fade_out( 1 );
	NextMission();
}

potus_convoy_interior_setup()
{
//	self Attach( "veh_t6_mil_cougar_interior_shadow" );
	self Attach( "veh_t6_mil_cougar_interior_attachment", "tag_body_animate_jnt" );
}

roadblock_vehicles_dead()
{
	roadblock_vehicles = GetEntArray( "roadblock_vehicles", "targetname" );
	array_wait( roadblock_vehicles, "death" );
	flag_set( "roadblock_clear" );
}

ambient_flybys()
{
//	level thread spawn_ambient_drones( "trig_ground_ambient_flybys_1", "trig_ground_ambient_flybys_3", "pegasus_ground_ambient_flyby", "ground_ambient_flyby_path_1", 6, 4, 5 );
	level thread spawn_ambient_drones( "trig_ground_ambient_flybys_1", "trig_ground_ambient_flybys_8", "pegasus_ground_ambient_flyby_2", "f38_ground_ambient_flyby_2", "ground_ambient_flyby_path_2", 6, 2, 3, 4 );	
	level thread spawn_ambient_drones( "trig_ground_ambient_flybys_3", "trig_ground_ambient_flybys_4", "pegasus_ground_ambient_flyby_3", "f38_ground_ambient_flyby_3","ground_ambient_flyby_path_3", 5, 2, 2, 3 );		
	level thread spawn_ambient_drones( "trig_ground_ambient_flybys_4", "trig_ground_ambient_flybys_5", "pegasus_ground_ambient_flyby_4", "f38_ground_ambient_flyby_4","ground_ambient_flyby_path_4", 4, 2, 3, 5 );			
	level thread spawn_ambient_drones( "trig_ground_ambient_flybys_4", "trig_ground_ambient_flybys_5", "pegasus_ground_ambient_flyby_7", "f38_ground_ambient_flyby_7","ground_ambient_flyby_path_7", 4, 2, 4, 5 );				
	level thread spawn_ambient_drones( "trig_ground_ambient_flybys_5", "trig_ground_ambient_flybys_7", "pegasus_ground_ambient_flyby_5", "f38_ground_ambient_flyby_5","ground_ambient_flyby_path_5", 4, 2, 5, 6 );				
	level thread spawn_ambient_drones( "trig_ground_ambient_flybys_5", "trig_ground_ambient_flybys_7", "pegasus_ground_ambient_flyby_6", "f38_ground_ambient_flyby_6","ground_ambient_flyby_path_6", 6, 2, 3, 4 );					
	
}

/*
 [Brian Joyal (Treyarch) -- 04/15/12 15:15:34]
a_signs = GetEntArray( "light_ad", "targetname" );

On a timer, change the signs to one of the following models:
p6_light_ad_03_crnr
p6_light_ad_05_crnr
p6_light_ad_07_crnr
p6_light_ad_09_crnr
p6_light_ad_10_crnr 
*/

run_digital_billboards()
{
	level.corner_sign_models = array( "p6_light_ad_03_crnr", "p6_light_ad_05_crnr","p6_light_ad_07_crnr","p6_light_ad_09_crnr" );
	
	a_signs = GetEntArray( "light_ad", "targetname" );
	array_thread( a_signs, ::_corner_sign_swap );
}

_corner_sign_swap()
{
	level endon("kill_digital_billboards");
	
	while(1)
	{
		for( i=0; i < level.corner_sign_models.size; i++ )
		{
			self SetModel( level.corner_sign_models[i] );
			wait(9);
		}
	}
}



