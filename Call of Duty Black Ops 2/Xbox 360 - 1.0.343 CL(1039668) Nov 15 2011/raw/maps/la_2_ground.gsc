/*
la_2_ground.gsc - contains all functionality for air to ground section
 */

#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\la_utility;

#insert raw\maps\_utility.gsh;

main()
{
	
}

f35_flight_start()
{
	level.player thread f35_tutorial();  // tell player how to fly the F35
}


// wake up player and direct him to f35
f35_wakeup()
{
	wait_for_first_player();
	
	maps\createart\la_2_art::fog_intro();  // 'level start' fog settings
	exploder( level.EXPLODER_STAPLES_CENTER );

	intro_move_player_origin();
	
	// don't let player kill van
	vh_intro_van = get_ent( "intro_van", "targetname", true );
	vh_intro_van thread func_on_death( ::required_vehicle_death );	
	
	// return player to consciousness
	level.player thread player_wakes_up();		
	level thread pilot_pre_drag_idle();
	level thread harper_wakes_up();
	
	level thread intro_guys_die();	
	level.f35 thread f35_blinking_light();
	level.f35 thread maps\la_2_anim::vo_f35_boarding();
	level.f35 thread func_on_death( ::required_vehicle_death );
	
	level waittill( "start_anderson_f35_exit" );
	level thread harper_drags_pilot_to_van();
}

intro_move_player_origin()
{	
	println( "intro_move_player_origin starting..." );
	
	// player starting position and angles
	s_player_start = get_struct( "player_start_default_struct", "targetname", true );	
	v_start_origin_world = s_player_start.origin;
	v_start_angles = s_player_start.angles;		
	
	// test section
	//str_start_lazy = s_player_start get_transition_vector_string();
	//SetDvar( "la_2_player_start_pos", str_start_lazy );
	//SetDvar( "la_1_ending_position", 1 );
	
	// should use player pos - check other variable
	if ( IsDefined( GetDvar( "la_1_ending_position" ) ) && ( GetDvar( "la_1_ending_position" ) == "1" ) )
	{
		println( "LA_2 USING LA_1 ENDING POSITION!" );
		v_start_origin_local = GetDvarVector( "la_2_player_start_pos" );
		v_start_origin_world = la_convert_local_position_to_world( v_start_origin_local );
		
		v_start_angles = VectorToAngles( VectorNormalize( level.f35.origin - v_start_origin_world ) );
	}
	
	v_start_origin_world += ( 0, 0, 1000 );  // offset since ground may be lower in la_1
	v_start_origin = level.player find_ground_pos( v_start_origin_world );
	
	level.player SetOrigin( v_start_origin );
	level.player SetPlayerAngles( v_start_angles );	
	
	println( "intro_move_player_origin done!" );	
}

find_ground_pos( v_current )
{
	v_ground = v_current; // default 
	n_scale = 10000;
	v_down = ( 0, 0, -1 );
	v_trace_end = v_current + ( n_scale * v_down );
	a_trace = BulletTrace( v_current, v_trace_end, false, level.player );
	v_hit = a_trace[ "position" ];
	n_distance = Distance( v_current, v_hit );
	n_threshold = 3000;
	
	if ( n_distance < n_threshold )
	{
		v_ground = v_hit;
	}	
	
	return v_ground;
}

pilot_pre_drag_idle()
{
	ai_pilot = init_hero( "f35_pilot" );
	ai_pilot.animname = "f35_pilot";	
	
	// get everything in position
	run_scene_first_frame( "pilot_drag_van_setup" );
	level thread run_scene( "anderson_f35_exit" );  
	println( "anderson_f35_exit F35 pos: " + ( level.f35 GetTagOrigin( "tag_origin" ) ) + ", angles = " + ( level.f35 GetTagAngles( "tag_origin" ) ) );
	
	level waittill( "start_anderson_f35_exit" );
	//iprintlnbold( "anderson_f35_exit started" );
	
	if ( !flag( "pilot_drag_started" ) )
	{
		run_scene( "pilot_drag_setup" );
	}
}

harper_drags_pilot_to_van()
{
	vh_intro_van = get_ent( "intro_van", "targetname", true );
	nd_start = GetVehicleNode( "intro_van_exit_spline", "targetname" );
	Assert( IsDefined( nd_start ), "nd_start is missing for harper_drags_pilot_to_van" );
	
	run_scene( "pilot_drag" );	
	
	n_wait_time = 1;
	
	if ( !flag( "player_in_f35" ) )
	{
		n_wait_time = 5;
	}
	
	level thread run_scene( "pilot_drag_van_idle" );
	
	flag_wait( "player_in_f35" );  // intro sequence started 

	ai_harper = get_ent( "harper_ai", "targetname", true );
	ai_harper anim_stopanimscripted();
	
	if ( !IsDefined( ai_harper.ridingvehicle ) )
	{
		ai_harper enter_vehicle( vh_intro_van );
	}
	
	ai_pilot = get_ent( "f35_pilot_ai", "targetname", true );
	ai_pilot anim_stopanimscripted();
	if ( !IsDefined( ai_pilot.isridingvehicle ) )
	{
		ai_pilot enter_vehicle( vh_intro_van );
	}

	wait n_wait_time;  // give player enough time to see van start moving
	
	vh_intro_van thread go_path( nd_start );
	vh_intro_van waittill( "reached_end_node" );
	vh_intro_van Delete();

	ai_pilot Delete();
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

harper_wakes_up()
{	
	n_scale = 150;
	v_angles_player = AnglesToForward( level.player.angles );
	v_origin_player = level.player.origin;
	v_offset = ( 0, 0, 1000 );
	
	v_harper_pos = ( v_angles_player * n_scale ) + v_origin_player + v_offset;
	v_start_origin = level.player find_ground_pos( v_harper_pos );
	v_angles = VectorToAngles( ( VectorNormalize( level.f35.origin - v_start_origin ) * 1 ) );
		
	ai_harper = get_ent( "harper_ai", "targetname" );
	if ( !IsDefined( ai_harper ) )
	{
		ai_harper = init_hero( "harper" );
	}
	ai_harper.animname = "harper";
	ai_harper forceteleport( v_start_origin, v_angles );
	
	maps\_scene::run_scene( "harper_wakes_up" );
	
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
	
	//play sound for boarding sequence
	
	level.player PlaySound ("evt_f35_takeoff");
	
	level thread maps\la_2_anim::vo_f35_startup(); 	
	level.player anim_f35_get_in();
	level.player anim_f35_startup();
	maps\la_2_player_f35::player_boards_f35();	
	
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
	maps\_scene::run_scene( "F35_get_in" );
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
	e_temp_left = Spawn( "script_origin", v_pos_left );
	e_temp_right = Spawn( "script_origin", v_pos_right );
	
	PlayFX( level._effect[ "f35_light" ], e_temp_left.origin );
	PlayFX( level._effect[ "f35_light" ], e_temp_right.origin );
	
	flag_wait( "player_flying" );
	
	e_temp_left Delete();
	e_temp_right Delete();
}

setup_destructibles()
{
	wait_for_first_player();
	
	// gas station
	level thread damage_trigger_monitor( "gas_station_damage_trigger", 3000, "gas_station_destroyed", level.player, ::gas_station_death );
	
	// warehouse
//	level thread damage_trigger_monitor( "warehouse_damage_trigger", 3000, "warehouse_destroyed", level.player, ::warehouse_death );

	// crane and setup for collapse
	bm_clip_pristine = get_ent( "crane_clip_pristine", "targetname", true );
	
	bm_clip_collapsed = get_ent( "crane_clip_collapsed", "targetname", true );
	bm_clip_collapsed MoveTo( bm_clip_collapsed.origin - ( 0, 0, 10000 ), 0.1 ); // this never checks for classname, so it works with brushmodels
	level thread damage_trigger_monitor( "rooftop_crane_trigger", 1000, "fxanim_crane_collapse_start", level.player, ::crane_death );	
	
	a_fake_physics_vehicles = get_ent_array( "fake_physics_vehicle", "targetname", true );
	array_thread( a_fake_physics_vehicles, ::fake_physics_vehicle_launch );
		
	level thread setup_parking_garage();
}


setup_parking_garage()
{
	t_roof = get_ent( "parking_garage_destroyed_roof_part_trigger", "targetname", true );
	t_damage = get_ent( "parking_structure_damage_trigger", "targetname", true );
	bm_roof_clip_pristine = get_ent( "parking_structure_roof_brushmodel", "targetname", true );
	bm_roof_clip_destroyed = get_ent( "parking_structure_destroyed_clip", "targetname", true );	
	
	t_roof thread destroy_roof_on_helicopter_crash();
	level thread parking_structure_destroy_roof();  // this is where actual fxanim notify is sent out, since destruction can be triggered by multiple sources
	
	bm_roof_clip_pristine SetMovingPlatformEnabled();
	
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
	e_harper thread say_dialog( "holy_shit_043" );  //Holy shit!!!
	
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
	if ( !flag( "ground_targets_escape" ) )
	{
		e_harper thread say_dialog( "roadblock_warehouse_dead" );	
	}
	
	
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
		self [[ func_on_death ]]();
	}
}



f35_ground_targets()
{	
	maps\createart\la_2_art::art_vtol_mode_settings();	
	
	flag_wait( "convoy_movement_started" );
	maps\la_2_drones_ambient::aerial_vehicles_set_circling_close( false );
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
	stop_exploder( level.EXPLODER_STAPLES_CENTER );

	//spawn_manager_enable( "spawn_manager_warehouse_street" );
	
	level thread setup_ground_attack_objectives();
	level thread maps\la_2_drones_ambient::update_circling_plane_structs( "flight_point_ground_section", "script_noteworthy" );
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
	
	self add_ground_vehicle_damage_callback();
	
	if ( self.vehicletype == "civ_pickup_red_wturret_la2" )
	{
		self thread vehicle_free_on_death_think();
	}
	
	n_index = 1;
	v_offset = ( 0, 0, 0 );
	n_fire_min = 2;
	n_fire_max = 3;
	n_wait_min = 2;
	n_wait_max = 4;
	n_fire_time = 5;
	
	if ( IsDefined( n_custom_index ) )
	{
		n_index = n_custom_index;
	}
	
	self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index );
	
	while ( true )
	{
		e_target = maps\la_2_convoy::convoy_get_leader();
		self maps\_turret::set_turret_target( e_target, v_offset, n_index );
		self maps\_turret::shoot_turret_at_target( e_target, n_fire_time, v_offset, n_index );
	}
}

vehicle_free_on_death_think()
{
	self.dontfreeme = true;
	
	self waittill( "death" );
	
	b_convoy_passed_me = false;
	
	while ( b_convoy_passed_me )
	{
		
	}
	
	self.dontfreeme = false;
}

add_ground_vehicle_damage_callback()
{
	self.overrideVehicleDamage = ::ground_vehicle_damage_callback;
}

ground_vehicle_damage_callback(  eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsDefined( sWeapon ) )
	{
		if ( sWeapon == "f35_missile_turret_player" )   // one shot kill from player missile
		{
			iDamage = 9999;
		}
		else if ( sWeapon == "cougar_gun_turret" )
		{
			println( "damage from cougar turret" );
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
	a_guys = array_combine( a_guys, a_guys_1 );
	
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
		a_vans = array_combine( a_vans, a_temp );
		
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
//	a_targets = array_combine( a_targets, a_vehicles ); // removing optional targets from objectives. TravisJ 7/5/2011 - DT#4139
	
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
	add_spawn_function_group( "claw", "script_noteworthy", ::attack_convoy_leader_claw );
	
	add_spawn_function_group( "parking_structure_van_guys", "script_noteworthy", ::attack_convoy_leader_ai );
	
	add_spawn_function_veh( "parking_garage_heli_1", ::ground_vehicle_fires_at_player, 0 );
	add_spawn_function_veh( "parking_garage_heli_2", ::ground_vehicle_fires_at_player, 0 );
	
	add_spawn_function_veh( "crane_building_helicopter", maps\la_2_ground::helicopter_rappel_unload );
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
	
	n_distance_to_next_max = 300;
	n_distance_to_next_max_sq = n_distance_to_next_max * n_distance_to_next_max;
	n_distance_from_last_max = 300;
	n_distance_from_last_max_sq = n_distance_from_last_max * n_distance_from_last_max;
	n_move_time_min = 10;
	n_move_time_max = 25;
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

attack_convoy_leader_claw()
{
	self endon( "death" );
	
	b_shoot_player = false;
	self.dropweapon = false;
	self.goalradius = 64;
	self.a.rockets = 200;  // TODO: is there a better way to give 'unlimited' rockets?
	
	self maps\la_2::add_missile_turret_target();
	
	if ( IsDefined( self.target ) )
	{
		nd_goal = GetNode( self.target, "targetname" );
		self set_goal_node( nd_goal );
	}
	
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "shoot_player" ) )
	{
		b_shoot_player = true;
	}
	
	while( true )
	{		
		e_target = maps\la_2_convoy::convoy_get_leader();
		
		if ( b_shoot_player )
		{
			e_target = level.player;
		}
		
		self shoot_at_target( e_target ); 
		wait 1;
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
	
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "shoot_player" ) )
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
	Assert( ( IsDefined( str_targetname ) || ( IsDefined( v_start ) && IsDefined( v_end ) ) ), "either str_targetname or v_start and v_end are required for molotov_throw function" );
	const N_THROW_SCALE = 700;
	
	if ( IsDefined( str_targetname ) )
	{
		s_start = get_struct( str_targetname, "targetname", true );
	}
	
	if ( !IsDefined( v_start ) )
	{
		v_start = s_start.origin;
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
	
	level.player MagicGrenadeType( "molotov_sp", v_start, v_launch );
}

f35_pacing()
{
	if ( is_greenlight_build() )
	{
		level thread art_vtol_mode_settings();
		n_exposure = 2.99997;
		level.player SetClientDvars( "r_exposureTweak", 1, "r_exposureValue", n_exposure );
		
		maps\_drones::drones_start( "warehouse_st_left_turn_drones_allies" );
		delay_thread( 0.1, maps\_drones::drones_start, "warehouse_st_left_turn_drones_axis" );
		delay_thread( 0.2, maps\_drones::drones_start, "warehouse_st_right_blockade" );
		//maps\_drones::drones_start( "warehouse_st_distant_runners" );
		delay_thread( 0.3, maps\_drones::drones_start, "warehouse_st_blockade_lapd" );
		
		delay_thread ( 3, ::molotov_throw, "warehouse_st_molotov_struct_1" );
		delay_thread ( 4, ::molotov_throw, "warehouse_st_molotov_struct_2" );
		delay_thread ( 5, ::molotov_throw, "warehouse_st_molotov_struct_3" );
		
		level thread spawn_vehicles_from_targetname_and_gopath( "warehouse_st_left_turn_police_car" );
	}
	
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_roadblock_trigger", "roadblock_done", ::flag_set, "convoy_at_roadblock" );		
	
	if ( !is_greenlight_build() )
	{
		level thread maps\la_2_anim::vo_pacing();  // removed pacing VO for greenlight - TravisJ
	}
	
	flag_wait( "convoy_at_roadblock" );
	
	//level thread update_circling_plane_structs( "flight_point_air_section", "script_noteworthy" );
	level thread maps\la_2_drones_ambient::update_circling_plane_structs();
	n_circling_drone_count = 25;
	level thread _set_max_circling_count( n_circling_drone_count );
	
	autosave_by_name( "la_2" );
	
	flag_set( "roadblock_done" );
}

f35_rooftops()
{
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_waits_after_parking_garage", "player_passed_garage" );
	//level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_hotel_regroup_stop_trigger", "" );
	
	//flag_wait( "convoy_at_rooftops" );
	
	n_distance_from_player_close = 12000;
	n_distance_from_player_medium = 16000;	
	level thread maps\la_2_drones_ambient::update_circling_plane_structs( undefined, undefined, n_distance_from_player_close, n_distance_from_player_medium );	// "flight_point_air_section" / "script_noteworthy"
	
	autosave_by_name( "la_2" );
	
	//iprintlnbold( "rooftops" );
	level thread vo_rooftops();
	
	level thread rooftop_ai_setup();
	//level thread _kill_drones_after_convoy_passes( "convoy_waits_after_parking_garage", "parking_structure_drones" );
	//level thread _kill_drones_after_convoy_passes( "convoy_waits_after_parking_garage", "rooftops_drones_2" );
	//level thread _kill_drones_after_convoy_passes( "kill_rooftops_drones_3", "rooftops_drones_3" );
	//delay_thread( 5, ::simple_spawn, "rooftop_guys_left", ::attack_convoy_leader_ai );
	level thread crane_building_spawner();

	flag_wait( "player_passed_garage" );
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_rooftops_stop_trigger", "convoy_at_rooftops", ::convoy_waits_after_crane_building );		
		
	flag_wait( "convoy_at_rooftops" );
	
	//iprintlnbold( "spawning building collapse event stuff" );
	
	// spawn vehicles and make them path for this section (LAPD vs terrorists in one group)
	t_vehicle_spawner = get_ent( "building_collapse_event_vehicle_spawner", "targetname", true );
	t_vehicle_spawner notify( "trigger" );
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
	
	t_wait Delete();
}

crane_building_spawner()
{
	t_crane_building = get_ent( "crane_building_lookat_trigger", "targetname", true );
	
	b_spawn_ready = false;
	n_distance_ok_to_spawn_guys = 7500;
	n_distance_ok_to_spawn_heli = 15000;
	
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
		vh_helicopter_2 thread ground_vehicle_fires_at_player( 0 );
		
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
	
	self playsound( "evt_heli_crash" );
		
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

_heli_crash_sanity_check( s_reference )
{
	self endon( "missed_rooftop" );
	self endon( "crash_move_done" );
	
	while ( true )
	{
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
	self sethoverparams( 0, 0, 0 );
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
	n_update_timer = 1;
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
	s_explosion = get_struct( "convoy_dogfight_explosion_struct", "targetname", true );
	s_smoke = get_struct( "convoy_dogfight_explosion_smoke_struct", "targetname", true );
	s_building_fall = get_struct( "convoy_dogfight_building_fall_struct", "targetname", true );
	bm_building = get_ent( "convoy_dogfight_building_brush", "targetname", true );	
	s_building_end_point = get_struct( "convoy_dogfight_building_fall_struct", "targetname", true );
	n_time = 5;
	
	// explosion below
	PlayFX( level._effect[ "dogfight_building_explosion" ], s_explosion.origin );
	
	// building falls
	bm_building MoveTo( s_building_end_point.origin, n_time );
	bm_building RotateTo( s_building_end_point.angles, n_time );
	
	// dust cloud emerges
	PlayFX( level._effect[ "dogfight_building_smoke" ], s_smoke.origin );
	
	// radio message: we're alive. not being attacked. thin out the UAVs
	level thread maps\la_2_anim::vo_dogfight();
	
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
	n_distance = 8000;
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
	
	n_speed_wave_1 = 300;
	n_speed_wave_2 = 250;
	n_speed_wave_3 = 250;
	n_speed_fast = 300;
	v_offset = ( 30, 30, 30 );
	n_update_time = 1;
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
	
	n_accel = 1000;
	n_decel = 1000;
	v_origin_old = sp_vehicle.origin;
	v_angles_old = sp_vehicle.angles;
	sp_vehicle.origin = nd_start.origin;
	sp_vehicle.angles = nd_start.angles;
	vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( str_spawner_name );
	vh_plane thread track_trenchrun_death();
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
	
	vh_plane thread trenchrun_add_objective_to_plane();
	n_near_goal_dist = 700;
	n_near_goal_dist_suicide = 192;
	n_near_goal_draw_red_line = 10192;
	
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
	
	n_distance_max = 1500;	
	
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


track_trenchrun_death()
{
	if ( !IsDefined( level.trenchruns_struct ) )
	{
		level.trenchruns_struct  = SpawnStruct();
		level.trenchruns_struct.targetname = "trenchrun_death_struct";
		level.trenchruns_struct.missile_deaths = 0;
		level.trenchruns_struct.gun_deaths = 0;
		level.trenchruns_struct.killed_convoy = 0;
	}
	
	self waittill( "death", e_attacker, str_cause, str_weapon_name, e_inflictor ); 	

	if ( IsDefined( str_weapon_name ) && ( str_weapon_name == "f35_missile_turret_player" ) )
	{
		level.trenchruns_struct.missile_deaths++;
	}
	else if ( IsDefined( str_weapon_name ) && ( str_weapon_name == "none" ) 
	         && IsDefined( e_attacker ) && IsPlayer( e_attacker ) )  // "none" because guns are scripted, not on vehicle directly
	{
		level.trenchruns_struct.gun_deaths++;
	}
	else 
	{
		level.trenchruns_struct.killed_convoy++;
	}
}


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
		
		if ( b_first_run )
		{
			self thread _print_goal_line( e_target, n_r, n_g, n_b, 0.05 );
			self thread notify_delay( "_kill_goal_line", 5 );
			b_first_run = false;
		}
		
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
	
	n_speed_fast = 200;
	v_offset = ( 30, 30, 30 );
	n_update_time = 1;	
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
	flag_wait( "hotel_done" );
	
	autosave_by_name( "la_2" );
	
	delay_thread( 2, maps\la_2_anim::vo_no_guns );
	
	wait 2;
	level.player notify( "turretownerchange" );
	
	level thread eject_drone_spawn();
	level thread f35_intercepts_drone();
	
	level thread maps\la_2_anim::vo_eject();
	level waittill( "eject_sequence_started" );
	
	//iprintlnbold( "plotting collision course..." );
	level.f35 thread maps\la_2_anim::vo_eject_f35(); 
	f35_eject_sequence_start();
	
	level thread maps\la_2_anim::vo_eject_collision();
	level.f35.supportsAnimScripted = true;
	level notify( "midair_collision_started" );
	
	level thread maps\_scene::run_scene( "midair_collision" );
	m_player_body = get_model_or_models_from_scene( "midair_collision", "player_body" );
	PlayFXOnTag( level._effect[ "ejection_seat_rocket" ], m_player_body, "J_SpineLower" );	// ejection seat fx
	maps\_scene::scene_wait( "midair_collision" );
	
	//iprintlnbold( "eject done" );
	maps\_objectives::set_objective( level.OBJ_TRENCHRUN_4, undefined, "delete" );
	flag_set( "eject_done" );
}

f35_eject_sequence_start()
{
	level.convoy.vh_van notify( "unload" );
	level.f35 thread f35_eject_bink();
	//maps\_scene::run_scene( "F35_eject" );
	
	// change fov to match the driver's seat since player isn't 'using' it anymore
	n_fov_f35 = 70;
	n_fov_default = GetDvarFloat( "cg_fov_default" );
	level.player SetClientDvar( "cg_fov", n_fov_f35 );
	
	// doing this manually since _scene isn't working right with linking
	level.player DisableWeapons();
	level.player.body = spawn_anim_model( "player_body", level.player.origin );
	level.player.body.angles = level.player.angles;
	level.player PlayerLinkToAbsolute( level.player.body, "tag_player" );
	level.player.body LinkTo( level.f35, "tag_driver" );
	level.player.body maps\_anim::anim_single( level.player.body, "f35_eject_start" );
	level.player Unlink();
	
	if ( IsDefined( level.player.body ) )
	{
		level.player.body Delete();	
	}
	
	level.player SetClientDvar( "cg_fov", n_fov_default );
}

f35_intercepts_drone()
{
	level endon( "midair_collision_started" );
	
	level waittill( "eject_sequence_ready" );
	
	n_distance_threshold = 1024;
	n_speed_intercept = 200;
	level.f35 = level.f35;
	vh_drone = get_ent( "eject_sequence_drone", "targetname", true );	
	vh_drone.supportsAnimScripted = true;
	
	player_exits_f35();	
	flag_set( "eject_sequence_started" );
	//audio:  set exterior f35 snapshot
	clientnotify( "stop_f35_snap" );
	
	wait 0.25;
	//level.player LinkTo( level.f35 );
	//level.f35 SetLookAtEnt( vh_drone );
	
	level.f35 CancelAIMove();
	level.f35 SetSpeed( n_speed_intercept );
	
	while ( n_distance_threshold < Distance( level.f35.origin, vh_drone.origin ) )
	{
		level.f35 SetVehGoalPos( vh_drone.origin );
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
	
	level thread spawn_trenchrun_plane( "eject_sequence_drone", "eject_sequence_spline", 200, v_offset, n_update_time );
	wait 0.1;
	vh_plane = get_ent( "eject_sequence_drone", "targetname", true );
	Target_Remove( vh_plane );
	wait 2;
	Target_Set( vh_plane );
	vh_plane waittill( "missileLockTurret_locked" );
	level notify( "eject_sequence_ready" );
	//iprintlnbold( "F35 locked on" );
}

f35_outro()
{
	flag_wait( "eject_done" );
	
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
	
	if ( is_alive( level.convoy.vh_g20_1 ) )
	{
		level thread maps\_scene::run_scene( "outro_g20_1" );
	}
	
	if ( is_alive( level.convoy.vh_g20_2 ) )
	{
		level thread maps\_scene::run_scene( "outro_g20_2" );
	}	
	
	maps\_scene::run_scene( "outro_hero" );
	
	flag_set( "outro_done" );
}
