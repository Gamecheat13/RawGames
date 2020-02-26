/*-----------------------------------------------------------------------------
pakistan_street.gsc

Events contained in this file:
- frogger
- bus_street
- bus_dam
- alley
 ----------------------------------------------------------------------------*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\pakistan_util;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\pakistan.gsh;

// -----------------------------
// frogger debris model setup
// -----------------------------
	
// these objects can float down the street during the frogger event	
#define		FROGGER_DYN_ENT_1			"p6_industrial_metal_can"
#define		FROGGER_DYN_ENT_2			"p6_gourd_container_b"
#define		FROGGER_DYN_ENT_3			"furniture_waterbottle01"	
#define		FROGGER_DYN_ENT_4			"berlin_com_pallet"
#define		FROGGER_DYN_ENT_5			"p6_chair_wood_hotel"
#define		FROGGER_DYN_ENT_6			"afr_pillow_1"
#define 	FROGGER_DYN_ENT_7			"furniture_waterbottle01"
#define		FROGGER_DYN_ENT_8			"me_plastic_crate10"
#define		FROGGER_DYN_ENT_9			"p6_gourd_container_b"
#define		FROGGER_DYN_ENT_10			"p6_industrial_metal_can"	
#define		FROGGER_DYN_ENT_11			"goat_dead_01"
#define		FROGGER_DYN_ENT_12			"pig_dead_01"
#define		FROGGER_DYN_ENT_13			"p6_pak_food_wheat"
#define		FROGGER_DYN_ENT_14			"p6_pak_food_soda_single_01"	
#define		FROGGER_DYN_ENT_15			"p6_pak_food_soda_single_02"
#define		FROGGER_DYN_ENT_16			"trash_styrofoam_container1"
#define		FROGGER_DYN_ENT_17			"p6_pak_food_sauce_01"
#define		FROGGER_DYN_ENT_18			"p6_pak_muddy_clothes01"
#define		FROGGER_DYN_ENT_19			"trash_carton_milk"
#define		FROGGER_DYN_ENT_20			"p6_gas_container"
#define		FROGGER_DYN_ENT_21			"com_bottle1_underwater"
	
// these objects are attached to vehicle splines and will hurt the player if they hit him	
#define		FROGGER_DEBRIS_1			"com_vending_can_new1_destroyed"
#define		FROGGER_DEBRIS_2			"p_ger_desk_industrial"
#define		FROGGER_DEBRIS_3			"me_refrigerator_d"
#define		FROGGER_DEBRIS_4			"machinery_washer_blue"
#define		FROGGER_DEBRIS_5			"afr_mattress_3"
#define		FROGGER_DEBRIS_6			"p6_chair_damaged_panama"	
#define		FROGGER_DEBRIS_7 			"ch_crate48x64"
#define		FROGGER_DEBRIS_8			"furniture_cabinet_console_b"
#define  	FROGGER_DEBRIS_9			"dub_lounge_sofa_02"
#define  	FROGGER_DEBRIS_10			"berlin_furniture_chair1_dusty"
#define  	FROGGER_DEBRIS_11			"p_glo_crate02"
#define  	FROGGER_DEBRIS_12			"paris_furniture_chair2_b"
#define 	FROGGER_DEBRIS_13  			"veh_iw_civ_car_hatch"
	
#define		DEBRIS_SPEED				175
#define		EXPLODER_FROGGER_FX			100
/*----------------------------------------------------------------------------
Skipto section
----------------------------------------------------------------------------*/

skipto_frogger()
{	
	water_stops_create_cover( false );
	// get rid of the vehicles/models in the street from previous events
	m_car = get_ent( "car_smash_car", "targetname", true );
	m_car Delete();
	
	m_bus = get_ent( "car_smash_bus", "targetname", true );
	m_bus Delete();
	
	maps\createart\pakistan_art::set_water_dvars_street();
	flag_set( "flooded_streets_done" ); // event flag only, not needed later
	
	skipto_teleport( "skipto_frogger", _get_friendly_array_frogger() );
}

skipto_frogger_claw_support()
{	
	_get_friendly_array_frogger_support();

	maps\pakistan_market::enable_claw_fire_direction_feature();
	
	flag_set( "brute_force_unlock_done" );
	
	skipto_frogger();
}

skipto_bus_street()
{
	maps\createart\pakistan_art::set_water_dvars_street();
	water_stops_create_cover( false );
	level.harper = init_hero( "harper" );
	
	a_friendlies = GetAIArray( "allies" );
	skipto_teleport( "skipto_bus_street", a_friendlies );
}

skipto_bus_dam()
{
	skipto_teleport( "skipto_bus_dam", _get_friendly_array_frogger() );
	
	level thread bus_wave_starts();  // bring this in to simulate enemy-less scenario	
		
	level thread bus_dam_anim_sequence();
	flag_set( "bus_dam_start_done" );
}

skipto_alley()
{
	skipto_teleport( "skipto_alley", _get_friendly_array_alley() );
}

_get_friendly_array_frogger()
{
	a_friendlies = [];
	ARRAY_ADD( a_friendlies, init_hero( "harper" ) );
	
	return a_friendlies;
}

_get_friendly_array_frogger_support()
{
	a_friendlies = [];
	ARRAY_ADD( a_friendlies, init_hero( "salazar" ) );
	ARRAY_ADD( a_friendlies, init_hero( "claw_1" ) );
	ARRAY_ADD( a_friendlies, init_hero( "claw_2" ) );
	
	return a_friendlies;
}

_get_friendly_array_alley()
{
	a_friendlies = [];
	ARRAY_ADD( a_friendlies, init_hero( "harper" ) );
	
	return a_friendlies;
}

/*----------------------------------------------------------------------------
Event functions
----------------------------------------------------------------------------*/

frogger()
{
	autosave_by_name( "pakistan_frogger_start" );	
	debug_print_line("frogger started" );
	
	flag_set( "frogger_started" );
	
	

	level thread frogger_setup_ai();
	level thread frogger_setup_environment();
	
	level thread watch_player_rain_water_sheeting();

	flag_wait( "frogger_combat_started" ); // set by player running ahead into trigger OR flooded_streets scene ending
	setmusicstate ("PAK_RIVER_FIGHT");
	level thread maps\pakistan_anim::vo_frogger();
	
	wait 0.05; // wait a frame to see if trigger has been hit or not
	
	// start combat if player hasn't walked into trigger already
	t_combat_start = get_ent( "frogger_first_wave_spawn_trigger", "targetname" );
	if ( IsDefined( t_combat_start ) )
	{
		t_combat_start notify( "trigger" );
	}
	
	trigger_wait( "frogger_spawn_manager_start_trigger" );
	autosave_by_name( "pakistan_frogger_mid" );	
	
	debug_print_line("SM enable: frogger_street" );
	spawn_manager_enable( "frogger_street" );
	if ( maps\_fire_direction::is_fire_direction_active() )
	{
		//maps\_fire_direction::claw_fire_direction_allow_hint();
	}
	
	trigger_wait( "frogger_complete" );  // trigger in archway at the end of frogger event
	flag_set( "frogger_done" );
	
	if ( maps\_fire_direction::is_fire_direction_active() )
	{
		level.player maps\_fire_direction::_fire_direction_kill();  // disable fire direction feature for the rest of the level
	}
	
	level thread maps\pakistan_anim::vo_frogger_support_ends();
	level notify( "harper_frogger_anims_done" );
	
	// get rid of salazar and claws once frogger is done
	//level thread delete_ent_if_defined( "salazar_ai", "targetname", :: );
	delete_ent_if_defined( "claw_1_ai" );
	delete_ent_if_defined( "claw_2_ai" );
	
	debug_print_line("frogger done" );
}

frogger_setup_environment()
{
	level thread frogger_debris_start();  // large objects that will do damage to player and push him on collision
	level thread frogger_start_spawning_dyn_ents();  // small objects that can be pushed by player
	level thread start_frogger_cover();  // scripted objects that act as cover, but move into place
	level.player thread slow_player_in_fast_water( "street_water_volume", "frogger_done", ( 0, 10, 0 ), true );
	level thread frogger_ambient_destruction();  // fxanims and lookat triggers 

	if ( !IsDefined( level.water_level_raised ) )
	{
		raise_water_level();
	}
	
	frogger_set_dvars();

	// set up node connections for balcony that's destroyed
	nd_fall = GetNode( "frogger_balcony_connect_fall", "targetname" );
	nd_balcony = GetNode( "frogger_balcony_connect_balcony", "targetname" );
	if ( IsDefined( nd_fall ) && IsDefined( nd_balcony ) )
	{
		// balcony links to fall
		LinkNodes( nd_balcony, nd_fall );
		LinkNodes( nd_fall, nd_balcony );
	}
}

frogger_setup_ai()
{
	add_spawn_function_ai_group( "frogger_balcony_guys", ::shoot_at_players_feet );
	level thread move_breakoff_group_to_roof();
	level thread slow_ai_in_fast_water( "street_water_volume", "frogger_done" );
	level thread frogger_harper_movement();	
	
	add_trigger_function( "frogger_left_side_window_spawn_trigger", ::simple_spawn, "frogger_left_side_window_guys" );	
}

frogger_ambient_destruction()
{
	// kashmir neon sign
	level thread play_fx_anim_on_trigger( "frogger_kashmir_sign_trigger", "kashmir_sign_break_start" );
	
	// swinging sign in the center of the street
	level thread play_fx_anim_on_trigger( "frogger_swinging_sign_trigger", "sign_dangle_break_start" );  // lookat version
	level thread play_fx_anim_on_trigger( "frogger_swinging_sign_damage_trigger", "sign_dangle_break_start" );  // damage version
	
	// power pole falling and hitting building
	level thread play_fx_anim_on_trigger( "frogger_fxanim_pole_fall", "fxanim_power_pole_break_start" );
	
	// balcony collapse near arch
	level thread play_fx_anim_on_trigger( "frogger_fxanim_balcony_collapse", "fxanim_balcony_collapse_start", ::_balcony_collapse_internal );
} 

_balcony_collapse_internal()
{
	// turn off the balcony nodes
	a_nodes = GetNodeArray( "balcony_collapse_nodes", "script_noteworthy" );
	foreach( node in a_nodes )
	{
		SetEnableNode( node, false );
	}
	
	// delete collision so they'll fall to the ground
	bm_clip = get_ent( "balcony_collapse_clip", "targetname" );
	bm_clip Delete();
	
	// kill any guys on the balcony (within volume)
	t_balcony = get_ent( "balcony_collapse_kill_volume", "targetname" );
	a_guys = get_ai_touching_volume( "axis", undefined, t_balcony );
	array_thread( a_guys, ::kill_me );
	t_balcony Delete();	
}

shoot_at_players_feet()
{
	self endon( "death" );
	
	v_offset = ( 0, 0, 0 );
	
	if ( !IsDefined( level.player.water_impact_origin ) )
	{
		level.player.water_impact_origin = Spawn( "script_origin", ( level.player.origin + v_offset ) );
		level.player.water_impact_origin.targetname = "player_water_impact_origin";
		level.player.water_impact_origin.health = 100; // hack so shoot_at_target works; returns if health value is missing
		level.player.water_impact_origin LinkTo( level.player );
	}
	
	self thread shoot_at_target( level.player.water_impact_origin, undefined, undefined, -1 );  // shoot forever
}

raise_water_level()
{
	level.water_level_raised = true;
	str_val = GetDvar( "r_waterWaveBase" );
	const n_raise_time = 2;
	
	if ( IsDefined( str_val ) && ( str_val != "" ) )
	{
		// then dvar exists! set it
		level thread lerp_dvar( "r_waterWaveBase", FROGGER_WATER_HEIGHT_OFFSET, n_raise_time );
	}
	
	e_market_volume = get_ent( "market_water_volume", "targetname", true );
	SetWaterBrush( e_market_volume );
	e_market_volume  MoveZ( FROGGER_WATER_HEIGHT_OFFSET, n_raise_time );
	exploder( EXPLODER_FROGGER_FX );
}

lower_water_level()
{	
	if ( IS_TRUE( level.water_level_raised ) )
	{
		str_val = GetDvar( "r_waterWaveBase" );
		
		if ( IsDefined( str_val ) && ( str_val != "" ) )
		{
			// then dvar exists! set it
			level thread lerp_dvar( "r_waterWaveBase", 0, 2 );  // go back to original height
		}		
	}
	
	stop_exploder( EXPLODER_FROGGER_FX );
}


/#	
debug_frogger_harper_movement()
{
	level endon( "harper_frogger_anims_done" );
	
	nodes = [];
	nodes[nodes.size] = GetNode( "harper_frogger_start", "targetname" );
	nodes[nodes.size] = GetNode( "harper_frogger_left_1", "targetname" );
	//nodes[nodes.size] = GetNode( "harper_fridge_cover", "targetname" );
	nodes[nodes.size] = GetNode( "harper_frogger_left_2", "targetname" );
	nodes[nodes.size] = GetNode( "harper_sign_cover", "targetname" );
	nodes[nodes.size] = GetNode( "frogger_harper_center_3", "targetname" );
	nodes[nodes.size] = GetNode( "harper_frogger_melee_cover", "targetname" );
	nodes[nodes.size] = GetNode( "harper_frogger_arch", "targetname" );
	nodes[nodes.size] = GetNode( "harper_frogger_done", "targetname" );
			
	while(1)
	{
		for( i=0; i<nodes.size -1; i++ )
		{	
			RecordLine( nodes[i].origin, nodes[i+1].origin, (1,1,1), "Script" );
		}
		
		wait(0.05);
	}
	
}
#/
	
#define SET_FROGGER_GOAL true	
frogger_harper_movement()
{
	level endon( "harper_frogger_anims_done" );
	level thread _frogger_sign_scene_setup();
	
	/#level thread debug_frogger_harper_movement();#/
	
	ai_harper = init_hero( "harper" );
	ai_harper AllowedStances( "stand" );
	ai_harper thread _frogger_movement_harper_ends();	
	
	flag_wait( "flooded_streets_done" );
	
	// set 'water walk' animations
	ai_harper change_movemode( "cqb_run" );
	//ai_harper disable_tactical_walk();
	ai_harper disable_pain();
	ai_harper disable_react();
	ai_harper set_cqb_run_anim( %generic_human::ai_cqb_walk_f_water_light, %generic_human::ai_cqb_walk_f_water_light, %generic_human::ai_cqb_walk_f_water_light );
	
	// start
	ai_harper set_goalradius( 32 );
	nd_start = GetNode( "harper_frogger_start", "targetname" );
	ai_harper set_goal_node( nd_start );	
	ai_harper waittill( "goal" );
	wait 1;
	
	// get to center
	ai_harper set_goalradius( 16 );
//	ai_harper set_frogger_goal( "frogger_harper_center_1", SET_FROGGER_GOAL, 1.0 );
	nd_left_1 = GetNode( "harper_frogger_left_1", "targetname" );
	ai_harper set_goal_node( nd_left_1 );
	ai_harper waittill( "goal" );
	
	wait 1;  // give script a second to reevaluate situation
	
	flag_wait( "harper_runs_to_fridge" );
	
	nd_left_2 = GetNode( "harper_frogger_left_2", "targetname" );
	ai_harper set_goal_node( nd_left_2 );
	ai_harper waittill( "goal" );
	
	flag_wait( "harper_runs_to_sign" ); // set in radiant
	
	// sign
	//ai_harper set_frogger_goal( "harper_sign_cover", !SET_FROGGER_GOAL );
	debug_print_line( "trying sign" );
	maps\_scene::run_scene( "frogger_sign" );
	nd_sign = GetNode( "harper_sign_cover", "targetname" );
	ai_harper set_goal_node( nd_sign );
	
	wait 4;  // give some time to shoot from this cover position
	
	// sign exit
	ai_harper set_frogger_goal( "frogger_harper_center_3", !SET_FROGGER_GOAL );
	debug_print_line( "trying sign exit" );
	maps\_scene::run_scene( "frogger_sign_exit" );
	nd_center_3 = GetNode( "frogger_harper_center_3", "targetname" );
	ai_harper set_goal_node( nd_center_3 ); // blocking
	
	wait 1;  // give script a second to reevaluate situation
	
	flag_wait( "harper_frogger_melee_start" );
	
	ai_harper set_frogger_goal( "harper_frogger_melee_cover", !SET_FROGGER_GOAL );
	debug_print_line( "trying melee" );
	maps\_scene::run_scene( "frogger_melee" );
	nd_melee = GetNode( "harper_frogger_melee_cover", "targetname" );
	ai_harper set_goal_node( nd_melee ); // blocking	
	
	wait 1;  // give script a second to reevaluate situation
	
	//ai_harper set_frogger_goal( "harper_frogger_arch" );
	nd_arch = GetNode( "harper_frogger_arch", "targetname" );
	ai_harper set_goal_node( nd_arch );
	ai_harper waittill( "goal" );
	
	flag_wait( "frogger_player_near_arch" );
	
	ai_harper set_goal_path( "harper_avoid_arch_path", "harper_frogger_done" );
	nd_end = GetNode( "harper_frogger_done", "targetname" );
	ai_harper set_goal_node( nd_end );
	
	level notify( "harper_frogger_anims_done" );	
}

// this function will take the string or node of the start of a series of nodes that are linked with targets. blocking call
set_goal_path( start_node_or_string, end_node_or_string )  // self = AI
{
	self endon( "death" );
	self notify( "_stop_set_goal_path" );
	self endon( "_stop_set_goal_path" );
	
	if ( IsString( start_node_or_string ) )
	{
		nd_current = GetNode( start_node_or_string, "targetname" );
		Assert( IsDefined( nd_current ), "set_goal_path couldn't find start node with targetname " + start_node_or_string );  
	}
	else 
	{
		nd_current = start_node_or_string;
	}
	
	b_check_end = IsDefined( end_node_or_string );
	
	if ( b_check_end )
	{
		if ( IsString( start_node_or_string ) )
		{
			nd_end = GetNode( end_node_or_string, "targetname" );
			Assert( IsDefined( nd_end ), "set_goal_path couldn't find end node with targetname " + end_node_or_string );  
		}
		else 
		{
			nd_end = end_node_or_string;
		}
		
	}
	
	b_first_time = true; 
	b_has_path = true;  
	b_found_end = false;
	
	while ( b_has_path )
	{
		if ( !b_first_time ) // first time only, so we get the entire node path
		{
			nd_current = GetNode( nd_current.target, "targetname" );
			if ( b_check_end )
			{
				b_found_end = ( nd_end == nd_current );
			}		
		}
		
		b_first_time = false;
		self set_goal_node( nd_current );
		
		self waittill( "goal" );  // may pause at goal
	
		b_has_path = !b_found_end && IsDefined( nd_current.target );
	}
}

set_frogger_goal( str_node_name, b_set_goal, n_custom_scale, n_dot_max )
{	
	DEFAULT( b_set_goal, true );
	nd_goal = GetNode( str_node_name, "targetname" );
	self.frogger_goal = nd_goal.origin;
	
	self frogger_wait_for_clear_path( nd_goal, n_custom_scale, n_dot_max );	
	if ( self.bulletsInClip == 0 )
	{
		self.bulletsInClip = 15;  // give bullets so Harper doesn't try stationary reload before movement
	}
	
	debug_print_line( "harper moving up" );
	
	if ( b_set_goal )
	{
		self.perfectaim = true;
		self thread force_goal( nd_goal );
		self thread _slow_vehicles_around_harper();	
		self waittill( "goal" );
		self notify( "reached_frogger_goal" );
		self.perfectaim = false;
		debug_print_line( "harper at " + str_node_name );
	}
}

frogger_wait_for_clear_path( nd_goal, n_distance_scale = 1.1, n_dot_max = 0.6 )  // self = harper (AI)
{
	n_distance = ( Distance( self.origin, nd_goal.origin ) * n_distance_scale );
	n_distance_squared = n_distance * n_distance;
	
	b_has_clear_path = false;
	
	v_to_goal = VectorNormalize( nd_goal.origin - self.origin );
	
	while ( !b_has_clear_path )
	{
		wait 0.1;  // wait first so all information is as current as possible as function loops
		
		// fake_vehicle_spawner = misc vehicle that all the frogger debris objects are attached to
		a_vehicles = get_ent_array( "fake_vehicle_spawner", "targetname" );
		a_vehicles_close = [];
		
		// remove stationary objects, keep close ones
		foreach( vehicle in a_vehicles )
		{
			b_within_range = ( DistanceSquared( vehicle.origin, self.origin ) < n_distance_squared );
			b_is_stationary_object = IsDefined( vehicle.frogger_debris_wave_type );  // stationary objects don't contain debris_wave_type parameter
			if ( b_within_range && !b_is_stationary_object )
			{
				ARRAY_ADD( a_vehicles_close, vehicle );
			}
		}
		
		n_close_debris = 0;
		for ( i = 0; i < a_vehicles_close.size; i++ )
		{
			v_to_object = VectorNormalize( a_vehicles_close[ i ].origin - self.origin );
			n_dot = VectorDot( v_to_object, v_to_goal );
			
			if ( n_dot > n_dot_max )
			{
				n_close_debris++;
				a_vehicles_close[ i ] thread _debug_line_to_slowed_object( self, 1 );
			}
		}
		
		if ( n_close_debris == 0 )
		{
			b_has_clear_path = true;
		}
		
		/#
		str_dvar = GetDvar( "debug_frogger_movement" );
		if ( str_dvar != "" )
		{
			self thread draw_line_for_time( nd_goal.origin, self.origin, 0, 0, 1, 0.1 );  // draw blue line to goal
		}
		#/
	}		
}



_slow_vehicles_around_harper()
{
	self endon( "reached_frogger_goal" );
	
	const n_debris_slow_distance = 300;
	
	while ( true )
	{
		// fake_vehicle_spawner = misc vehicle that all the frogger debris objects are attached to
		a_vehicles = get_ent_array( "fake_vehicle_spawner", "targetname" );
		a_vehicles_close = get_within_range( self.origin, a_vehicles, n_debris_slow_distance );
		
		for ( i = 0; i < a_vehicles_close.size; i++ )
		{
			a_vehicles_close[ i ] thread _slow_vehicle_for_time( self );
		}	
		
		wait 0.25;
	}
}

_slow_vehicle_for_time( ai_harper )  // self = vehicle
{
	self endon( "death" ); 
	
	DEFAULT( self.slowed_for_frogger, false );
	
	const n_slow_time = 1.0;	
	const n_slow_percent = 0.3; 
	const n_resume_speed_acceleration = 2;
		
	if ( !self.slowed_for_frogger )
	{
		self.slowed_for_frogger = true;
		
		n_speed_slow = ( self GetSpeedMPH() ) * n_slow_percent;
		self SetSpeed( n_speed_slow );
		
		self thread _debug_line_to_slowed_object( ai_harper, n_slow_time, 1, 0, 0 );
		
		wait n_slow_time;
		
		self ResumeSpeed( n_resume_speed_acceleration );
		self.slowed_for_frogger = false;
	}
}

_debug_line_to_slowed_object( ai_harper, n_slow_time, r = 1, g = 1, b = 1 )  // self = vehicle
{  
	/#
	self endon( "death" );  // object may be deleted before timer is up
	
	str_dvar = GetDvar( "debug_frogger_movement" );
	if ( str_dvar != "" )
	{
		n_frames = n_slow_time * 20;
		
		for ( i = 0; i < n_frames; i++ )
		{
			draw_line_for_time( self.origin, ai_harper.origin, r, g, b, 0.05 ); // blocking
		}
	 }
	#/
}


// puts harper back to color chain if he finishes sequence, or player finishes frogger quickly
_frogger_movement_harper_ends()  // self = harper
{
	str_color = self get_force_color();
	self clear_force_color();	
	
	level waittill( "harper_frogger_anims_done" );
	
	// restore color 		
	self set_force_color( str_color );	
		
	// restore stances
	self AllowedStances( "stand", "crouch", "prone" );
	
	self enable_pain();
	self enable_react();	
}

_frogger_sign_scene_setup()
{
	e_sign_origin = get_ent( "frogger_sign_origin", "targetname", true );
	
	bm_sign = get_ent( "frogger_sign_brush", "targetname", true );
	//bm_sign RotateYaw( 90, 1 );  // since brushmodel angles don't match anim, fix it
//	bm_sign waittill( "rotatedone" );
	bm_sign LinkTo( e_sign_origin );
	maps\_scene::run_scene_first_frame( "frogger_sign_only" );
}

delete_ent_if_defined( str_key, str_value )
{
	DEFAULT( str_value, "targetname" );
	
	e_temp = get_ent( str_key, str_value );
	
	if ( IsDefined( e_temp ) )
	{
		if ( e_temp is_hero() )
		{
			e_temp unmake_hero();
		}	
		
		if ( IS_VEHICLE( e_temp ) )
		{
			VEHICLE_DELETE( e_temp );
		}
		else 
		{
			e_temp Delete();	
		}
	}
}

start_frogger_cover()
{
	// cover objects are kept -100 units down from their desired position (Z only); move them back into position at event start. 
	// this was done to allow paths to connect properly since each of these objects has collision	
	a_cover_objects = get_ent_array( "frogger_cover_models", "script_noteworthy", true );
	const n_offset_z = 100;
	foreach( object in a_cover_objects )
	{
		object MoveZ( n_offset_z, 0.25 );
	}
	
	trigger_wait( "frogger_cover_trigger_car" );
	debug_print_line("moving car for cover now" );
	level thread move_frogger_cover( "frogger_cover_car", "frogger_cover_car_path_start" );
	
//	trigger_wait( "frogger_cover_trigger_couch" );
//	debug_print_line("moving couch for cover now" );
//	level thread move_frogger_cover( "frogger_cover_couch", "frogger_cover_couch_path" );	
	
	trigger_wait( "frogger_cover_trigger_cabinet" );
	debug_print_line("moving cabinet for cover now" );
	level thread move_frogger_cover( "frogger_cover_cabinet", "frogger_cover_cabinet_path" );	
		
}



water_stops_create_cover( b_move_objects )
{
	const n_objects = 5;
	
	for ( i = 0; i < n_objects; i++ )
	{
		vh_temp = maps\_vehicle::spawn_vehicle_from_targetname( "fake_vehicle_spawner" );
		m_temp = get_ent( "bus_street_script_cover_" + ( i + 1 ), "targetname", true );
		nd_path_start = GetVehicleNode( "bus_street_script_cover_spline_" + ( i + 1 ), "targetname" );
		
		// move temp vehicle to path start
		vh_temp.origin = nd_path_start.origin;
		
		if ( IsDefined( nd_path_start.angles ) )
		{
			vh_temp.angles = nd_path_start.angles;
		}
		
		// move temp model to path start
		m_temp.origin = nd_path_start.origin;
		
		if ( IsDefined( nd_path_start.angles ) )
		{
			m_temp.angles = nd_path_start.angles;
		}		
		
		if ( b_move_objects )
		{
			m_temp LinkTo( vh_temp );
			vh_temp thread go_path( nd_path_start );
		}
	}
}

move_breakoff_group_to_roof()
{
	level endon( "frogger_perk_not_used" );
	
	flag_wait( "brute_force_unlock_done" );
	
	wait 3; // give claws fake time to get to the roof
	
	flag_set( "frogger_perk_active" );
	
	if ( !maps\_fire_direction::is_fire_direction_active() )
	{
		maps\pakistan_market::enable_claw_fire_direction_feature();
	}
	
	s_warp_claw_1 = get_struct( "claw_1_warp_to_roof_struct", "targetname", true );
	s_warp_claw_2 = get_struct( "claw_2_warp_to_roof_struct", "targetname", true );
	s_warp_salazar = get_struct( "salazar_warp_to_roof_struct", "targetname", true );
	
	ai_claw_1 = get_ent( "claw_1_ai", "targetname", true );
	ai_claw_2 = get_ent( "claw_2_ai", "targetname", true );
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	
	ai_claw_1 forceteleport( s_warp_claw_1.origin, s_warp_claw_1.angles );
	ai_claw_2 forceteleport( s_warp_claw_2.origin, s_warp_claw_2.angles );
	ai_salazar forceteleport( s_warp_salazar.origin, s_warp_salazar.angles );
	
	// clear colors because claw repositioning isn't desired for firing angles
	ai_claw_1 clear_force_color();
	ai_claw_2 clear_force_color(); 
	
	maps\pakistan_market::claw_toggle_firing( true );
	level thread maps\pakistan_anim::vo_frogger_support();
}

kill_me()
{
	if ( IsDefined( self ) )
	{
		self DoDamage( self.health, self.origin, self );
	}
}

bus_street()
{
	a_axis = GetAIArray( "axis" );
	array_thread( a_axis, ::kill_me );
	
	autosave_by_name( "pakistan_bus_street" );
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	ai_harper thread _kill_all_frogger_harper_scenes();
	ai_harper clear_cqb_run_anim();
	
	add_spawn_function_group( "bus_street_spawn_manager_guys", "script_noteworthy", ::pacifist_to_goal );
	
	level thread maps\pakistan_anim::vo_bus_street();
	
	water_stops_create_cover( true );
	//level thread water_dvar_lerp( "r_waterwaveamplitude", 12, 1, 1, 1, 1 );  // nearly flatten water surface over time
	
	level.player thread slow_player_in_fast_water( "bus_street_water_volume", "bus_started", ( 5, 0, 0 ) );
	level thread slow_ai_in_fast_water( "bus_street_water_volume", "bus_dam_done" );	
	
	lower_water_level();
	
	trigger_wait( "bus_street_spawn_initial_spawn_trigger" );
	level thread frogger_archway_collapse();
	level thread maps\pakistan_anim::vo_bus_street_combat();
	simple_spawn( "bus_street_initial_spawns" );
	
	trigger_wait( "bus_street_spawn_second_spawn_trigger" );
	simple_spawn( "bus_street_secondary_spawns" );
	spawn_manager_enable( "bus_street_spawn_manager" );
	
	trigger_wait( "bus_dam_start" );
	
	spawn_manager_kill( "bus_street_spawn_manager" );
	
	debug_print_line("bus_dam_runners" );
	level thread maps\pakistan_anim::vo_bus_dam();
	level thread maps\_scene::run_scene( "bus_dam_runners" );
}

pacifist_to_goal()  // self = AI
{
	self endon( "death" );
	
	self set_pacifist( true );
	
	self waittill( "goal" );
	
	self set_pacifist( false );
}

frogger_archway_collapse()
{
	t_lookat = get_ent( "archway_lookat_trigger", "targetname", true );
	t_damage = get_ent( "archway_damage_trigger", "targetname", true );
	s_fire = get_struct( "archway_magic_rpg_struct", "targetname", true );
	s_target = get_struct( s_fire.target, "targetname", true );
	a_arch_models = get_ent_array( "archway_pristine", "targetname", true );  // group of models; no brushes
	bm_clip = get_ent( "archway_destroyed_clip", "targetname", true );
	const n_move_distance = 300;
	
	t_lookat waittill( "trigger" ); 
	
	MagicBullet( "usrpg_sp", s_fire.origin, s_target.origin );
	t_damage waittill( "trigger" );
	debug_print_line("archway collapses" );
	level notify( "fxanim_arch_collapse_start" );
	bm_clip MoveZ( n_move_distance, 0.5 );
	
	foreach( model in a_arch_models )
	{
		model Delete();
	}
}

start_bus( e_bus )
{
	level thread bus_street_decrease_enemy_accuracy();
	level thread bus_wave_starts();
	bus_path_start();	

	ClientNotify( "bus_wave_initial_start" );
//	level thread clientnotify_delay( "bus_wave_start", 6 );
	maps\_scene::run_scene( "bus_dam_start" );
}

// change existing water dvars to specified values
water_dvar_lerp( str_dvar, n_time, n_amp_1, n_amp_2, n_amp_3, n_amp_4 )
{
	const n_waves = 4;
	
	str_water_values = GetDvar( str_dvar );
	
	// dvar stored as string separated by spaces, so break that into a usable format
	a_tokens = StrTok( str_water_values, " " );
	
	a_values = [];
	
	// change strings to floats
	for ( i = 0; i < n_waves; i++ )
	{
		ARRAY_ADD( a_values, Float( a_tokens[ i ] ) );
	}
	
	// determine change per frame
	n_frames = n_time * 20;

	a_change_per_frame = [];
	a_change_per_frame[ 0 ] = Abs( n_amp_1 - a_values[ 0 ] ) / n_frames;
	a_change_per_frame[ 1 ] = Abs( n_amp_2 - a_values[ 1 ] ) / n_frames;
	a_change_per_frame[ 2 ] = Abs( n_amp_3 - a_values[ 2 ] ) / n_frames;
	a_change_per_frame[ 3 ] = Abs( n_amp_4 - a_values[ 3 ] ) / n_frames;
	
	// loop through array and change it to new value
	for ( j = 0; j < n_frames; j++ )
	{
		str_frame_amplitudes = "";
		for ( k = 0; k < a_tokens.size; k++ )
		{
			n_change_this_frame = a_values[ k ] - ( a_change_per_frame[ k ] * j );
			str_frame_amplitudes += n_change_this_frame + " ";
		}
		
		SetDvar( str_dvar, str_frame_amplitudes );
		
		wait 0.05;
	}
	
	// set final amplitude
	str_final_amp = "" + n_amp_1 + " " + n_amp_2 + " " + n_amp_3 + " " + n_amp_4;
	
	SetDvar( str_dvar, str_final_amp );
}

bus_street_decrease_enemy_accuracy()
{
	a_enemies = GetAIArray( "axis" );
	m_bus = get_ent( "bus_dam_bus", "targetname", true );
	s_escape = get_struct( "bus_escape_struct", "targetname", true );
	e_ignore = get_ent( "player_bus_safe_zone_volume", "targetname", true );
	
	foreach( enemy in a_enemies )
	{
		enemy thread _run_from_bus( m_bus, s_escape, e_ignore );
	}
	
	level delay_notify( "stop_running_from_bus", 5 );
}

_run_from_bus( m_bus, s_escape, e_ignore )
{
	level endon( "stop_running_from_bus" );
	self endon( "death" );
	
	const n_escape_distance = 950;
	self.script_accuracy = 0.0;
	
	while ( Distance( m_bus.origin, self.origin ) > n_escape_distance )
	{
		wait 0.05;
	}
	
	wait RandomFloat( 0.15, 1.0 );
	
	if ( !self IsTouching( e_ignore ) )
	{
		self.ignore_water_speed = true;
		self.ignoreall = true;
		self.goalradius = 32;
		self SetGoalPos( s_escape.origin );
		self change_movemode( "run" );
		self.moveplaybackrate = 0.6;
		self set_ignoreme( true );
	}
}

bus_wave_starts()
{
	const n_move_time = 10;	
	
	//level thread water_dvar_lerp( "r_waterwaveamplitude", n_move_time, 3.125, 2.5, 1.125, 1.5 );
	
	t_wave = get_ent( "bus_street_wave_trigger", "targetname", true );
	e_temp = Spawn( "script_origin", t_wave.origin );
	t_wave EnableLinkTo();
	t_wave LinkTo( e_temp );
	s_target = get_struct( "bus_dam_temp_wave_struct", "targetname", true );
	
	e_temp MoveTo( s_target.origin, n_move_time );
	
	t_wave thread _wave_hits_harper();
	t_wave thread _wave_hits_player();
	t_wave thread _wave_hits_ai();
	t_wave thread _wave_hits_debris();
	
	e_temp waittill( "movedone" );
	t_wave Unlink();
	e_temp Delete();
}

_wave_hits_debris()
{
	//bus_dam_wave_push_debris
	a_debris = get_ent_array( "bus_dam_wave_push_debris", "targetname", true );
	for ( i = 0; i < a_debris.size; i++ )
	{
		self thread _wave_moves_debris( a_debris[ i ] );
		wait 0.1;  // give spawner time to bring in unique vehicles
	}
}

// spawns in vehicle, moves it on spline once wave trigger hits it
_wave_moves_debris( m_object )
{
	nd_path_start = GetVehicleNode( m_object.target, "targetname" );
	Assert( IsDefined( nd_path_start ), "bus dam wave object missing spline at " + m_object.origin );
	
	vh_temp = maps\_vehicle::spawn_vehicle_from_targetname( "fake_vehicle_spawner" );
	vh_temp.origin = nd_path_start.origin;  
	vh_temp.angles = nd_path_start.angles;
	
	vh_temp _frogger_debris_add_bobbing_anim( nd_path_start );
	
	vh_temp.m_temp = m_object;
	vh_temp.m_temp _frogger_fx_play_on_object();
	vh_temp.m_temp LinkTo( vh_temp.m_anim, "origin_animate_jnt" );
	
	b_wave_hit_object = false;
	while ( !b_wave_hit_object )
	{
		self waittill( "trigger", e_triggered );
		
		if (  e_triggered == vh_temp )
		{
			b_wave_hit_object = true;
		}
	}	
	vh_temp thread go_path( nd_path_start );
	vh_temp.m_temp thread notify_on_collision( vh_temp );	
	vh_temp thread delete_at_spline_end();
}

_wave_hits_ai()
{
	const n_launch_scale = 55;
	v_launch_offset = ( 0, 0, 50 );
	
	b_toggle = 0;
	
	while ( true )
	{
		self waittill( "trigger", e_triggered );
		
		b_is_ai = IsAI( e_triggered );
		b_is_enemy = IsDefined( e_triggered.targetname ) && IsSubstr( e_triggered.targetname, "bus_street" );
		b_first_time = !IsDefined( e_triggered.hit_by_wave );
		
		if ( b_is_ai && b_is_enemy && b_first_time )
		{
			b_toggle = !b_toggle;
			
			e_triggered.hit_by_wave = true;
			v_launch = ( VectorNormalize( e_triggered.origin - self.origin ) * n_launch_scale ) + v_launch_offset;
			e_triggered.animname = "generic";
			
			if ( b_toggle )
			{
				str_deathanim = "bus_wave_death_1";
			}
			else 
			{
				str_deathanim = "bus_wave_death_2";
			}
			
			e_triggered set_deathanim( str_deathanim );
			e_triggered DoDamage( e_triggered.health + 1, e_triggered.origin, self );
		}
	}
}

// copies origin and angles to self, from target
copy_orientation( e_target ) 
{
	self.origin = e_target.origin;
	
	if ( IsDefined( e_target.angles ) )
	{
		self.angles = e_target.angles;
	}
}

bus_path_start()
{
	debug_print_line("bus started" );
	flag_set( "bus_started" );
	
	vh_bus = _bus_event_setup();
}


launch_debris_over_stuck_bus()
{
	level endon( "bus_dam_exit_started" );
		
	a_models = frogger_get_dyn_ent_model_array();
	a_forces = bus_dam_get_launch_force_array();
	
	Assert( ( a_forces.size >= a_models.size ), "launch_debris_over_stuck_bus didn't find enough launch forces - you have " + a_models.size + "models, but " + a_forces.size + " force scalars" );
	
	a_launch_points = [];
	ARRAY_ADD( a_launch_points, get_struct( "dam_bus_dynent_spawn_point_4", "targetname", true ) );
	ARRAY_ADD( a_launch_points, get_struct( "dam_bus_dynent_spawn_point_2", "targetname", true ) );
	ARRAY_ADD( a_launch_points, get_struct( "dam_bus_dynent_spawn_point_3", "targetname", true ) );
	ARRAY_ADD( a_launch_points, get_struct( "dam_bus_dynent_spawn_point_1", "targetname", true ) );
	ARRAY_ADD( a_launch_points, get_struct( "dam_bus_dynent_spawn_point_6", "targetname", true ) );
	ARRAY_ADD( a_launch_points, get_struct( "dam_bus_dynent_spawn_point_5", "targetname", true ) );
	
	a_target_points = [];
	for ( i = 0; i < a_launch_points.size; i++ )
	{
		ARRAY_ADD( a_target_points, get_struct( a_launch_points[ i ].target, "targetname", true ) );
	}
	
	n_model_index = 0;
	
	// wait for bus to be in idle 'dam' position before launching
	flag_wait( "bus_dam_idle_started" );
	
	while ( true )
	{
		for ( i = 0; i < a_launch_points.size; i++ )
		{
			if ( n_model_index >= a_models.size )
			{
				n_model_index = 0;
			}
			
			v_force = VectorNormalize( a_target_points[ i ].origin - a_launch_points[ i ].origin ) * a_forces[ n_model_index ];
			CreateDynEntAndLaunch( a_models[ n_model_index ], a_launch_points[ i ].origin, a_launch_points[ i ].angles, a_target_points[ i ].origin, v_force );
			playsoundatposition ("fly_bus_debris", a_launch_points[i].origin);
			n_model_index++;
			wait 0.15;
		}
		
		wait 0.25;
	}
}

precache_dyn_ent_debris()
{
	PrecacheModel( FROGGER_DYN_ENT_1 );
	PrecacheModel( FROGGER_DYN_ENT_2 );
	PrecacheModel( FROGGER_DYN_ENT_3 );
	PrecacheModel( FROGGER_DYN_ENT_4 );
	PrecacheModel( FROGGER_DYN_ENT_5 );
	PrecacheModel( FROGGER_DYN_ENT_6 );
	PrecacheModel( FROGGER_DYN_ENT_7 );
	PrecacheModel( FROGGER_DYN_ENT_8 );
	PrecacheModel( FROGGER_DYN_ENT_9 );
	PrecacheModel( FROGGER_DYN_ENT_10 );
	PrecacheModel( FROGGER_DYN_ENT_11 );
	PrecacheModel( FROGGER_DYN_ENT_12 );
	PrecacheModel( FROGGER_DYN_ENT_13 );
	PrecacheModel( FROGGER_DYN_ENT_14 );
	PrecacheModel( FROGGER_DYN_ENT_15 );
	PrecacheModel( FROGGER_DYN_ENT_16 );
	PrecacheModel( FROGGER_DYN_ENT_17 );
	PrecacheModel( FROGGER_DYN_ENT_18 );
	PrecacheModel( FROGGER_DYN_ENT_19 );
	PrecacheModel( FROGGER_DYN_ENT_20 );
	PrecacheModel( FROGGER_DYN_ENT_21 );
}

_wave_hits_harper()
{
	// wait a few frames when using a skipto to make sure flags are defined 
	if ( maps\_skipto::is_after_skipto( "bus_street" ) )
	{
		wait 0.1;
	}
	
	// restore full movement to harper before reach 
	ai_harper = get_ent( "harper_ai", "targetname", true );
	ai_harper.ignore_water_speed = true;
	ai_harper.moveplaybackrate = 1.0;
	ai_harper change_movemode( "cqb_run" );
	
	run_scene( "bus_dam_harper_gate_idle" );
}

_wave_hits_player()
{
	level endon( "bus_dam_gate_push_setup_started" );
	
	b_wave_hit_player = false;
	while ( !b_wave_hit_player )
	{
		self waittill( "trigger", e_triggered );
		
		if ( IsPlayer( e_triggered ) )
		{
			b_wave_hit_player = true;
		}
	}
	
	level notify( "bus_wave_hits_player" );
	level thread clientnotify_delay( "bus_wave_start", 0.75 );
	
	m_bus = get_ent( "bus_dam_bus", "targetname", true );
	
	v_look = VectorToAngles( VectorNormalize(  m_bus.origin - level.player.origin ) );
	
	// play wave hit anim if we need to warp harper in front of the player. otherwise, don't!
	ai_harper = get_ent( "harper_ai", "targetname", true );
	t_anim_trigger = get_ent( "player_escaped_bus_trigger", "targetname", true );
	const n_dist_max_for_warp = 300;
	
	b_should_play_anim = ( Distance( ai_harper.origin, t_anim_trigger.origin ) > n_dist_max_for_warp );
	
	level notify( "bus_dam_wave_at_player" );
	if ( b_should_play_anim )
	{
		level.player SetStance( "crouch" );
		level.player look_at( m_bus, 0.15, true );		
		level thread run_scene( "bus_dam_wave_push_player" );
		ai_harper thread _bus_dam_warp_harper_in_front_of_player();
	}
	
	level.player SetStance( "crouch" );
	
	level.player SetWaterSheeting( 1, 8 );
	level.player SetWaterDrops( 50 );
	
	wait 10;
	
	level.player SetWaterDrops( 0 );
}

_bus_dam_warp_harper_in_front_of_player()
{
		wait 0.5; // make sure player is looking down at water. TODO: switch to notify!
		s_warp = get_struct( "bus_wave_harper_cheat_struct", "targetname", true );
		self ForceTeleport( s_warp.origin, s_warp.angles );	
}

_move_player_if_too_close()
{
	t_success = get_ent( "player_escaped_bus_trigger", "targetname", true );
	s_move = get_struct( "bus_dam_too_close_struct", "targetname", true );
	
	n_distance_to_alley = Distance( t_success.origin, level.player.origin );
	const n_cutoff = 800;
	
	if ( n_distance_to_alley < n_cutoff )
	{
		//iprintlnbold( "player too close!" );
		e_temp = Spawn( "script_origin", level.player.origin );
		m_body = get_model_or_models_from_scene( "bus_dam_wave_push_player", "player_body" );
		m_body LinkTo( e_temp );
		e_temp MoveTo( s_move.origin, 0.5 );
		e_temp waittill( "movedone" );
		m_body Unlink();
		
		flag_wait( "bus_dam_exit_player_done" );
		
		e_temp Delete();
	}
}

_bus_event_setup()
{
	// normal path for bus
	m_bus = get_ent( "bus_dam_bus", "targetname", true );
	t_bus_kill = get_ent( "bus_dam_damage_trigger", "targetname", true );	
	t_bus_kill thread maps\pakistan_market::trigger_kill_ai_on_contact( "bus_initial_path_done", m_bus );
	
	return m_bus;
}

bus_event_failure()
{
	debug_print_line("fail path started" );	

	m_bus = get_ent( "bus_dam_bus", "targetname", true );
	t_bus_kill = get_ent( "bus_dam_damage_trigger", "targetname", true );
	t_bus_kill thread maps\pakistan_market::trigger_kill_ai_on_contact( "bus_dam_done" );	
	
	SetDvar( "ui_deadquote", &"PAKISTAN_SHARED_BUS_FAIL" );

	run_scene( "bus_dam_exit" );	
	MissionFailed();
	wait 100;  // when scene completes, will run into alley scripting otherwise
}

bus_event_success()
{
	debug_print_line("bus dam success" );
	m_bus = get_ent( "bus_dam_bus", "targetname", true );
	t_bus_kill = get_ent( "bus_dam_damage_trigger", "targetname", true );
	t_bus_kill thread maps\pakistan_market::trigger_kill_ai_on_contact( "bus_dam_done" );
	
	level.player maps\pakistan_market::set_player_invulerability( true );
	bus_dam_success_debris_move_back();  // normally kept under the map. move these back to their original positions
	delay_thread( 0.1, ::bus_dam_success_debris_buildup );
	delay_thread( 0.4, ::bus_dam_success_debris_followers );
	level thread run_scene( "bus_dam_exit" );	
	level thread maps\pakistan_anim::vo_bus_dam_escape();
	run_scene( "bus_dam_gate_success" );
	level.player maps\pakistan_market::set_player_invulerability( false );
}

ambient_alley_scenes()
{
	level thread maps\_scene::run_scene( "alley_civilian_1" );
	level thread maps\_scene::run_scene( "alley_civilian_2" );
	level thread maps\_scene::run_scene( "alley_civilian_3" );
	
	t_civilian_react = get_ent( "alley_civilian_react_trigger", "targetname", true );
	add_trigger_function( t_civilian_react, ::_ambient_civilian_group_1_react );
	
	bm_door = get_ent( "pakistan_alley_door", "targetname" );
	m_door_origin = get_ent( "alley_civilian_door", "targetname", true );
	
	if ( IsDefined( bm_door ) )
	{
		bm_door LinkTo( m_door_origin ); // attach door so it swings properly
	}
	
	trigger_wait( "alley_ambient_start_trigger" );
	level thread run_scene( "slum_alley_initial" );
	
	trigger_wait( "alley_ambient_dog_trigger" );
	level thread run_scene( "slum_alley_dog_rummage" );	
	wait 0.1; // let models spawn in
	m_dog = get_model_or_models_from_scene( "slum_alley_dog_rummage", "alley_dog_2" );	
	
	trigger_wait( "alley_ambient_corner_trigger" );
	level thread run_scene( "slum_alley_corner" );	
	run_scene( "slum_alley_dog_transition" );
	level thread run_scene( "slum_alley_dog_growl" );
	
	const n_dog_run_timeout = 10;
	delay_notify( "alley_dog_run", n_dog_run_timeout );  // timeout for dog 
	
	level waittill( "alley_dog_run" );  // sent either by timeout, or radius trigger on dogs position
	
	run_scene( "slum_alley_dog_exit" );
}

_ambient_civilian_group_1_react()
{
	// both of these animations run funcs to wait for scene completion, then go back to idle loop 
	level thread maps\_scene::run_scene( "alley_civilian_1_react" );
	level thread maps\_scene::run_scene( "alley_civilian_2_react" );
	level thread alley_civ_1_react_then_idle();
	level thread alley_civ_2_react_then_idle();
}

alley_civ_1_react_then_idle( ai_civilian )
{
	level endon( "alley_clean_up" );
	
	debug_print_line( "civ 1 reacts" );
	scene_wait( "alley_civilian_1_react" );
	run_scene( "alley_civilian_1" );
}

alley_civ_2_react_then_idle( ai_civilian )
{
	level endon( "alley_clean_up" );
	
	debug_print_line( "civ 2 reacts" );
	scene_wait( "alley_civilian_2_react" );
	run_scene( "alley_civilian_2" );	
}

bus_dam_success_debris_setup()
{
	a_models = get_ent_array( "bus_dam_success_debris", "script_noteworthy", true );
	
	for ( i = 0; i < a_models.size; i++ )
	{
		a_models[ i ].old_origin = a_models[ i ].origin;
		a_models[ i ].origin += ( 0, 0, -1000 );
		a_models[ i ].bus_dam_ready = true;
	}
}

bus_dam_success_debris_move_back()
{
	a_models = get_ent_array( "bus_dam_success_debris", "script_noteworthy", true );
	
	for ( i = 0; i < a_models.size; i++ )
	{
		if ( a_models[ i ].bus_dam_ready )
		{
			a_models[ i ].origin = a_models[ i ].old_origin;
		}
	}	
}

bus_dam_success_debris_buildup()
{
	a_models = [];
	ARRAY_ADD( a_models, "bus_dam_success_debris_buildup_1" );
	ARRAY_ADD( a_models, "bus_dam_success_debris_buildup_2" );
	ARRAY_ADD( a_models, "bus_dam_success_debris_buildup_3" );
	
	a_debris_paths = [];
	ARRAY_ADD( a_debris_paths, "bus_dam_success_debris_buildup_1_path" );
	ARRAY_ADD( a_debris_paths, "bus_dam_success_debris_buildup_2_path" );
	ARRAY_ADD( a_debris_paths, "bus_dam_success_debris_buildup_3_path" );
	
	for ( i = 0; i < a_models.size; i++ )
	{
		level thread move_frogger_cover( a_models[ i ], a_debris_paths[ i ], true );
		wait 0.1;  // make sure script has enough time to spawn another vehicle
	}	
}

bus_dam_success_debris_followers()
{
	debug_print_line("moving bus dam success debris" );
	
	a_models = [];
	ARRAY_ADD( a_models, "bus_dam_success_debris_1" );
	ARRAY_ADD( a_models, "bus_dam_success_debris_2" );
	ARRAY_ADD( a_models, "bus_dam_success_debris_3" );
	
	a_debris_paths = [];
	ARRAY_ADD( a_debris_paths, "bus_dam_success_debris_1_path" );
	ARRAY_ADD( a_debris_paths, "bus_dam_success_debris_2_path" );
	ARRAY_ADD( a_debris_paths, "bus_dam_success_debris_3_path" );
	
	for ( i = 0; i < a_models.size; i++ )
	{
		level thread move_frogger_cover( a_models[ i ], a_debris_paths[ i ], true );
		wait 0.15;  // make sure script has enough time to spawn another vehicle
	}
}

bus_dam_anim_sequence( e_bus )
{
	level endon( "bus_dam_done" );
	
	flag_wait( "bus_dam_start_done" );
	debug_print_line("bus stuck on environment..." );
	level thread maps\_scene::run_scene( "bus_dam_idle" );
	level thread launch_debris_over_stuck_bus();

	// calculate rough time player should need to get to bus
	n_bus_event_success_wait_max = _get_time_required_to_avoid_bus();
	n_time_at_calc_ms = GetTime();
	
	//PLAYING AUDIO ON ANIM LOOP   - JM
	bus_ent_aud = get_ent( "bus_dam_bus", "targetname", true );
	bus_ent_aud thread play_audio_one_shot(n_bus_event_success_wait_max); //calculate time to play loop outro	
	
	level notify( "bus_initial_path_done" );	
}

bus_dam()
{	
	debug_print_line("bus stuck on environment..." );
	autosave_by_name( "pakistan_dam_bus_run" );
	
	flag_init( "player_at_bus_gate" );
	flag_init( "bus_dam_harper_at_gate" );	
	
	flag_wait( "bus_dam_harper_gate_idle_started" );
	
	bus_dam_determine_success(); // this function will return when either success or failure conditions are met

	wait 0.05; // make sure flag has been set
	
	if ( !flag( "player_at_bus_gate" ) )
	{
		bus_event_failure();
	}
	
	level.player playsound ("evt_bus_gate_extra");

	// button mash sequence
	b_passed_strength_test = bus_dam_strength_test();

	if ( b_passed_strength_test )
	{
		bus_event_success();
	}
	else 
	{
		bus_event_gate_failure();
	}
	
	flag_set( "bus_dam_done" );
}

// function will return when either success or failure conditions are met
bus_dam_determine_success()
{
	level endon( "bus_dam_idle_timeout" );

	add_trigger_function( "player_escaped_bus_trigger", ::flag_set, "player_at_bus_gate" );
	
	t_gate = get_ent( "player_escaped_bus_trigger", "targetname", true );
	
	t_gate thread _bus_dam_idle_timeout();
	
	t_gate waittill( "trigger" );
}

// this function will wait until the bus is idle, then wait for trigger
_bus_dam_idle_timeout()
{
	const n_timeout = 3.5;
	
	flag_wait( "bus_dam_harper_at_gate" );
	flag_wait( "bus_dam_idle_started" );

	level thread delay_notify( "bus_dam_idle_timeout", n_timeout );
	self waittill( "trigger" );
}

play_audio_one_shot(delay)
{
	self playloopsound ("evt_bus_idle_loop", .5); 
	if (delay > 4.1)
	{
		wait ( delay - 4.1);
		self playsound ("evt_bus_idle_build", "sounddone");
		self waittill ("sounddone");
		if ( !flag( "player_at_bus_gate" ) )
		{
			self stoploopsound (1);
		}
		else
		{
			wait (6);
			self stoploopsound (1);
		}
		
	}
	
	else
	{
		self playsound ("evt_bus_idle_build", "sounddone");
		self waittill ("sounddone");
		if ( !flag( "player_at_bus_gate" ) )
		{
			self stoploopsound (1);
		}
		else
		{
			wait (6);
			self stoploopsound (1);
		}
	}
}

bus_event_gate_failure()
{
	level thread run_scene( "bus_dam_exit" );	
	maps\_scene::run_scene( "bus_dam_gate_failure" );
	MissionFailed();
	wait 100;  // wait when scene completes, will run into alley scripting otherwise
}

bus_dam_strength_test()
{
	maps\_scene::end_scene( "bus_dam_harper_gate_idle" );
	maps\_scene::run_scene( "bus_dam_gate_push_setup" );
	
	level thread _hack_screen_message();
	level thread bus_dam_button_mash();
	
	maps\_scene::run_scene( "bus_dam_gate_push_test" );
	level notify( "button_mash_done" );
	screen_message_delete();

	b_succeeded = flag( "player_survives_bus" );
	
	return b_succeeded;
}


#define BUTTON_RELEASED 0
#define BUTTON_PRESSED 1
#define BUTTON_HELD 2
// button must be pushed down then released to count as one push
bus_dam_button_mash()
{
	level endon( "button_mash_done" );
	
	flag_init( "player_survives_bus" );
	
	const n_presses_required = 10;
	
	n_state_current = 0;
	n_state_last = 0;
	n_push_count = 0;
	
	while ( true )
	{
		 b_button_pressed_this_frame = _bus_dam_button_push_poll();
		 
		  // next state = current input + last state
		 if ( b_button_pressed_this_frame )
		 {
		 	if ( ( n_state_last == BUTTON_PRESSED ) || ( n_state_last == BUTTON_HELD ) )
		 	{
		 		n_state = BUTTON_HELD; 
		 	}
		 	else // last state = released
		 	{
		 		n_state = BUTTON_PRESSED; 
		 		n_push_count++;
		 		debug_print_line("push count = " + n_push_count + " of " + n_presses_required );
		 	}
		 }
		 else   // button not pushed this frame
		 {
			n_state = BUTTON_RELEASED; 
		 }
		
		 n_state_last = n_state;
		 
		 // you win!
		 if ( n_push_count >= n_presses_required )
		 {
		 	flag_set( "player_survives_bus" );
		 	debug_print_line("success!" );
		 	level notify( "button_mash_done" );
		 }
		 
		 wait 0.05;
	}
}

// wrap in case button changes
_bus_dam_button_push_poll()
{
	return level.player UseButtonPressed();
}

// flashing buttons don't work, so temp this in. ^F[{BUTTON_REF}]F^ should do this normally
_hack_screen_message()
{
	level endon( "bus_dam_gate_push_test_done" );
	
	while ( true )
	{
		screen_message_delete();
		screen_message_create( "Press ^F[{+activate}]^F to push" );  // actual message, but doesn't work
		wait 0.15;
		screen_message_delete();
		screen_message_create( "Press       to push" );  // spaces so button lines up
		wait 0.15;
	}
}

_get_time_required_to_avoid_bus()
{
	t_success = get_ent( "player_escaped_bus_trigger", "targetname", true );
	n_distance_to_bus = Distance( t_success.origin, level.player.origin );
	n_sprint_speed_units_per_sec = 120; // average sprint speed while in the water that still allows LMGs to succeed
	n_bus_event_success_wait_max = n_distance_to_bus / n_sprint_speed_units_per_sec;
	debug_print_line(n_bus_event_success_wait_max + " to get to alley" );

	return n_bus_event_success_wait_max;	
}

#define DRONE_SPOTLIGHT_TURRET 0
alley()
{
	autosave_by_name( "pakistan_alley" );
	
	flag_init( "player_hides_under_body" );
	ai_harper = init_hero( "harper" );
	ai_harper change_movemode( "cqb" );
	ai_harper Unlink(); // temp fix for DT#19680
	
	level.player SetLowReady( true );
	
	level thread maps\pakistan_anim::vo_alley();
	level thread ambient_alley_scenes();
	level thread corpse_alley_scene_setup();
	
	level thread alley_player_jump_anim();
	
	flag_wait( "corpse_alley_player_jump_started" );
	setmusicstate ("PAK_BODIES");
	
	// TEMP LOCATION FOR ANIM
	level thread _corpse_alley_anim_think();

	level thread alley_drone_intro();
	
	level.player SetLowReady( false );
 	level thread maps\pakistan_anim::vo_corpse_alley();
	level thread alley_clean_up_civilians();
	level thread _corpse_alley_harper_kill_on_detection();
	level thread maps\_scene::run_scene( "corpse_alley_harper" );
//	level thread maps\_scene::run_scene( "corpse_alley_drone_and_civ" );
//	level thread _focus_spotlight_on_player(); 
	
//	maps\_scene::scene_wait( "corpse_alley_harper" );
	level waittill( "helicopter_alley_scan_done" );
}

_corpse_alley_harper_kill_on_detection()
{
	level endon( "corpse_alley_harper_done" );
	
	flag_wait( "drone_attacks_player" );
	ai_harper = get_ent( "harper_ai", "targetname" );
	ai_harper anim_stopanimscripted( 0.25 );
}

drone_shoots_civilian()
{

}

alley_drone_intro()
{
	debug_print_line( "spawning helicopter" );
	vh_drone = maps\pakistan_anthem_approach::_get_drone_helicopter();
	vh_drone ent_flag_clear( "start_spotlight_search" );
	nd_path = GetVehicleNode( "drone_intro_spline", "targetname" );
	vh_drone thread go_path( nd_path );
	vh_drone waittill( "start_detection" );
	level notify( "allow_body_hide" );
	vh_drone ent_flag_set( "start_spotlight_search" );
}

/*---------
 IMPORTANT: since this animation can be triggered in a mantle volume, the MoveSlide -> link is required to cancel the 
 mantle movement from code. MoveSlide can't be called on a player, and the function must be called BEFORE the player 
 is linked to the script origin. There isn't a frame wait required to make this work, either.
---------*/ 	
alley_player_jump_anim()
{
	t_anim = get_ent( "transition_to_anthem_approach", "targetname", true );
	b_corpse_alley_scene_ready = false;
	
	while ( !b_corpse_alley_scene_ready )
	{
		b_in_position = ( level.player IsTouching( t_anim ) );
		b_correct_stance = ( level.player JumpButtonPressed() ) || !( level.player IsOnGround() );
		
		if ( b_in_position && b_correct_stance ) 
		{
			b_corpse_alley_scene_ready = true;
		}
		
		wait 0.05;
	}	
		
	// fix for code mantle playing after animation below
	fake_origin = spawn("script_model", level.player.origin); 
	fake_origin setmodel("tag_origin");
	fake_origin moveslide(fake_origin.origin, 16, (0, 0, 0));  // must call this before linkto
	
	maps\_scene::run_scene( "corpse_alley_player_jump" );  // play animation

	fake_origin.origin = level.player.origin;  // move object to player origin after anim is done
	level.player PlayerLinkTo(fake_origin); // link player to object to cancel mantle from code

	// clean up fake origin
	fake_origin StopMoveSlide();
	fake_origin delete();
}

_kill_all_frogger_harper_scenes()
{
	level notify( "harper_frogger_anims_done" );		
	
	maps\_scene::end_scene( "frogger_fridge_cover" );  // will reach
	maps\_scene::end_scene( "frogger_fridge_cover_exit" );
	maps\_scene::end_scene( "frogger_sign" );
	maps\_scene::end_scene( "frogger_sign_exit" );
	maps\_scene::end_scene( "frogger_melee" );
}

alley_clean_up_civilians()
{
	level notify( "alley_clean_up" );
	a_civs = get_ai_group_ai( "alley_civilians" );
	
	array_delete( a_civs );
}

corpse_alley_helicopter_scans_bodies( ai_harper )  // sent from notetrack on harper when he starts hide part of anim
{
	level notify( "corpse_alley_spotlight_on_player" );
	
	set_objective( level.OBJ_HIDE, undefined, "done" );
	
	if ( flag( "player_hides_under_body" ) )
	{
		flag_set( "player_hiding_underwater" );
		screen_message_delete();
		maps\_scene::run_scene( "corpse_alley_player" );
		flag_clear( "player_hiding_underwater" );
	}		
	
	screen_message_delete();
}

corpse_alley_helicopter_scan_done( ent )
{
	if ( ent.targetname == "player_body" )
	{
		wait 5;
	}
	
	level notify( "helicopter_alley_scan_done" );
}

_focus_spotlight_on_player( n_react_time )
{	
	wait 0.1; // wait for scene to start and spawn in helicopter
	vh_helicopter = get_ent( "drone_helicopter", "targetname", true );
	
	vh_helicopter thread maps\pakistan_anthem_approach::player_detection_logic();
	vh_helicopter maps\_turret::set_turret_target( level.player, undefined, DRONE_SPOTLIGHT_TURRET );
	
	level waittill( "corpse_alley_spotlight_on_player" );  // sent from notetrack on harper

	debug_print_line("start_spotlight_search" );	
	set_objective( level.OBJ_HIDE, undefined, "done" );
	screen_message_delete();
	
	if ( flag( "player_hides_under_body" ) )
	{
		vh_helicopter thread _underwater_spotlight();
		maps\_scene::run_scene( "corpse_alley_player" );
	}	
	
	vh_helicopter ent_flag_set( "start_spotlight_search" );	
	maps\_scene::scene_wait( "corpse_alley_player" );
	debug_print_line("turning off spotlight follower" );	
	debug_print_line("aim at civ now" );
	vh_helicopter thread maps\pakistan_anthem_approach::drone_set_lookat_ent( "drone_detects_civilian_struct", 0.25 );
}

#define UNDERWATER_PARTICLES_EXPLODER 310
_underwater_spotlight()
{
	str_tag = "tag_flash";
	n_cycles = 10;
	n_delay = 1;
	
	exploder( UNDERWATER_PARTICLES_EXPLODER );
	
	for ( i = 0; i < n_cycles; i++ )
	{
		v_spotlight_origin = self.origin;
		v_target = level.player.origin;
		a_trace = BulletTrace( v_spotlight_origin, v_target, false, self );
		v_water_surface = a_trace[ "position" ];  // should always be waters surface
		v_forward = ( v_target - v_spotlight_origin );
		v_forward = FLAT_ORIGIN( v_forward ); 
		v_up = ( 0, 0, 1 );  // will always be straight up
		PlayFX( level._effect[ "underwater_spotlight" ], v_water_surface, v_forward, v_up );
		
		wait n_delay;
	}
	
	stop_exploder( UNDERWATER_PARTICLES_EXPLODER );
}

_corpse_alley_anim_think()
{
	level endon( "corpse_alley_player_started" );
	level endon( "corpse_alley_spotlight_on_player" );
	level endon( "drone_attacks_player" );
	
	ai_corpse_hat = simple_spawn_single( "corpse_hat_2" );
	s_align = get_struct( "pakistan_alley_exit", "targetname", true );
	
	s_align thread maps\_anim::anim_first_frame( ai_corpse_hat, "corpse_alley_player" );
	wait 0.1; // wait to get correct position for objective
	
	flag_wait( "corpse_alley_player_jump_done" );
	
	wait 2;
	
	v_objective_pos = ai_corpse_hat GetTagOrigin( "tag_stowed_back" );
	set_objective( level.OBJ_HIDE, v_objective_pos, "" );	
	
	const n_distance_to_lerp = 128;
	const n_distance_to_prompt = 256;
	
	b_pressed_button = false;
	
	while ( true )  // terminates through endon
	{
		if ( level.player UseButtonPressed() )
		{
			b_pressed_button = true;
			if(!IsDefined(level.music_tracker))
			{
				level.music_tracker = 0;
				setmusicstate ("PAK_HIDE");
			}
		}
		
		n_distance_from_corpse = Distance( ai_corpse_hat.origin, level.player.origin );
		b_within_range = ( n_distance_from_corpse < n_distance_to_lerp );
		b_should_play_anim = ( b_pressed_button && b_within_range );		
		
		if ( b_within_range )
		{
			screen_message_create( "Hold [{+activate}] to hide under body" );
		}
		else 
		{
			screen_message_delete();
		}
		
		if ( b_should_play_anim )
		{
			flag_set( "player_hides_under_body" );
		}
		else 
		{
			flag_clear( "player_hides_under_body" );
		}
		
		wait 0.05;
	}
}



#define CAR_HEADLIGHT_LEFT_TAG "tag_light_left_front_d"
#define CAR_HEADLIGHT_RIGHT_TAG "tag_light_right_front_d"
corpse_alley_scene_setup()
{
	level endon( "corpse_alley_player_done" );
	
	sp_corpse_hat_1 = get_ent( "corpse_hat_1", "targetname", true );
	sp_corpse_hat_1 add_spawn_function( ::ragdoll_me_when_scene_ends, "corpse_alley_harper" );

	sp_corpse_hat_2 = get_ent( "corpse_hat_2", "targetname", true );
	sp_corpse_hat_2 add_spawn_function( ::ragdoll_me_when_scene_ends, "corpse_alley_player" );
	
	m_car = get_ent( "corpse_alley_car", "targetname", true );
	m_car play_fx( "civ_car_headlight", m_car GetTagOrigin( CAR_HEADLIGHT_LEFT_TAG ), m_car GetTagAngles( CAR_HEADLIGHT_LEFT_TAG ), undefined, true, CAR_HEADLIGHT_LEFT_TAG );
	m_car play_fx( "civ_car_headlight", m_car GetTagOrigin( CAR_HEADLIGHT_RIGHT_TAG ), m_car GetTagAngles( CAR_HEADLIGHT_RIGHT_TAG ), undefined, true, CAR_HEADLIGHT_RIGHT_TAG );
	
	level thread alley_populate_corpses();
}

corpse_alley_civ_detected_by_drone( ai_civilian )
{
	debug_print_line("drone sees civ" );
	
	vh_drone = maps\pakistan_anthem_approach::_get_drone_helicopter();
	
	vh_drone ent_flag_clear( "start_spotlight_search" );

	vh_drone SetSpeed( 0 );
	vh_drone drone_set_lookat_ent( "drone_detects_civilian_struct" );
	vh_drone thread corpse_alley_drone_finds_civ( self );
	vh_drone drone_spotlight_target_set( "drone_detects_civilian_struct", 3 );


	
	b_use_missiles = false;
	
	if ( b_use_missiles )
	{
		wait 0.25;
		
		n_turret_index = 1;  // 0 = spotlight, 1 = missile, 2 = missile
		n_fire_time = 2;
		b_fire_once = false;
		vh_drone thread maps\_turret::shoot_turret_at_target( ai_civilian, n_fire_time, undefined, n_turret_index, b_fire_once );
	}
	else 
	{
		wait 0.75;  // aim time
		
		// fake fire since turret aiming on cue isn't reliable
		for ( i = 0; i < 15; i++ )
		{
			//vh_drone SetTurretTargetEnt( e_temp );
			vh_drone FireWeapon();
			wait 0.1;
		}
	}
	
	vh_drone ResumeSpeed( 1 );
	wait 2;
	vh_drone ent_flag_set( "start_spotlight_search" );
	vh_drone waittill( "reached_end_node" );
	level notify( "helicopter_alley_scan_done" );	
}

corpse_alley_civ_launched_by_drone( ai_civ )
{
	debug_print_line("civ launched" );
	
	ai_civ thread maps\pakistan_market::ragdoll_me_when_scene_ends( "corpse_alley" );
}

corpse_alley_drone_finds_civ( vh_drone )
{
	
}

corpse_alley_drone_fires_at_civ( vh_drone )
{
	debug_print_line("drone fires at civ" );
	level notify( "drone_done_firing_at_civ" );
}

alley_populate_corpses()
{
	a_corpse_structs = get_struct_array( "alley_corpse_struct", "targetname", true );
	foreach ( corpse_struct in a_corpse_structs )
	{
		m_corpse = spawn_model( CIVILIAN_CORPSE_MODEL, corpse_struct.origin, corpse_struct.angles );
		
		if ( IsDefined( corpse_struct.script_string ) && ( corpse_struct.script_string == "try_ragdoll" ) )
		{
			m_corpse StartRagdoll();
		}
	}
}

make_floating_body( s_float_point )
{
	self forceteleport( s_float_point.origin, s_float_point.angles );
	wait 0.1;
	self DoDamage( self.health + 1, self.origin, self );
	self ForceBuoyancy();
	self FloatLonger();
}

frogger_manage_dyn_ents()
{
	a_triggers = get_ent_array( "frogger_dyn_ent_triggers", "script_noteworthy" );
	
	array_thread( a_triggers, ::frogger_dyn_ent_spawner_manager );
}

frogger_dyn_ent_spawner_manager()
{		
	level endon( "frogger_done" );
	
	a_active_spawners = get_struct_array( self.targetname, "script_noteworthy" );
	
	while ( true )
	{
		self waittill( "trigger" );  // should only trigger one time while player is inside trigger
		
		_frogger_set_dyn_ent_spawner( self, a_active_spawners );
		
		while ( level.player IsTouching( self ) )
		{
			wait 1;
		}
	}
}

_frogger_set_dyn_ent_spawner( t_active, a_structs )
{
	debug_print_line( "dyn ent group active = " + t_active.targetname );
	level.frogger_trigger_active = t_active;
	level.frogger_dyn_ent_spawners = a_structs;
}

frogger_get_dyn_ent_model_array()
{
	a_models = [];
	
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_1 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_2 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_3 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_4 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_5 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_6 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_7 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_8 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_9 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_10 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_11 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_12 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_13 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_14 );	
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_15 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_16 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_17 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_18 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_19 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_20 );
	ARRAY_ADD( a_models, FROGGER_DYN_ENT_21 );	
	
	return a_models;
}

// IMPORTANT - these array indicies match the frogger_get_dyn_ent_model_array models!
bus_dam_get_launch_force_array()
{
	a_forces = [];
	
	ARRAY_ADD( a_forces, 8 );
	ARRAY_ADD( a_forces, 15 );
	ARRAY_ADD( a_forces, 6 );
	ARRAY_ADD( a_forces, 4 );
	ARRAY_ADD( a_forces, 6 );
	ARRAY_ADD( a_forces, 5 );
	ARRAY_ADD( a_forces, 4 );	
	ARRAY_ADD( a_forces, 4 );
	ARRAY_ADD( a_forces, 3 );
	ARRAY_ADD( a_forces, 10 );
	ARRAY_ADD( a_forces, 11 );
	ARRAY_ADD( a_forces, 3 );
	ARRAY_ADD( a_forces, 6 );
	ARRAY_ADD( a_forces, 4 );
	ARRAY_ADD( a_forces, 6 );
	ARRAY_ADD( a_forces, 5 );
	ARRAY_ADD( a_forces, 4 );	
	ARRAY_ADD( a_forces, 7 );
	ARRAY_ADD( a_forces, 3 );
	ARRAY_ADD( a_forces, 8 );
	ARRAY_ADD( a_forces, 6 );

	return a_forces;	
}

frogger_start_spawning_dyn_ents()
{
	level endon( "frogger_done" );
	
	if ( !IsDefined( level.frogger_dyn_ents_active ) )
	{
		level.frogger_dyn_ents_active = true;
	}
	else 
	{
		return;
	}	
	
	frogger_manage_dyn_ents();
	
	a_default_spawn_points = get_struct_array( "frogger_dyn_ent_trigger_0", "script_noteworthy", true );
	//a_spawn_points = get_struct_array( "frogger_dyn_ent_spawn_point", "targetname", true );
	
	a_models = frogger_get_dyn_ent_model_array();
	
	const n_wait_between_spawns = 0.25;

	n_spawn_index = 0;
	n_model_index = 0;
	v_force = ( 0, 0, 0.01 );  // drop into water
	
	a_spawn_points = a_default_spawn_points;  // default case
	t_active_last = level.player;  // placeholder since entity comparison w/undefined will give SRE
	
	while ( true )
	{
		// check to see what trigger the player was in last
		t_active = level.frogger_trigger_active;
		b_update_spawn_points = IsDefined( t_active ) && ( t_active_last != t_active );
		if ( b_update_spawn_points )
		{
			t_active_last = t_active;
			
			if ( IsDefined( level.frogger_dyn_ent_spawners ) )
			{
				a_spawn_points = level.frogger_dyn_ent_spawners;
				n_spawn_index = 0;
			}
		}
		
		// error check in case we don't find structs
		if ( !IsDefined( a_spawn_points ) || ( a_spawn_points.size == 0 ) )
		{
			a_spawn_points = a_default_spawn_points;
		}
		
		// cycle through dyn ent index to make sure we evenly distribute models
		if ( n_spawn_index == a_spawn_points.size )
		{
			n_spawn_index = 0;
		}
		
		if ( n_model_index == a_models.size )
		{
			n_model_index = 0;
		}

		CreateDynEntAndLaunch( a_models[ n_model_index ], a_spawn_points[ n_spawn_index ].origin, a_spawn_points[ n_spawn_index ].angles, a_spawn_points[ n_spawn_index ].origin, v_force );
		
		n_model_index++;
		n_spawn_index++;
		
		wait n_wait_between_spawns;
	}
}

#define FROGGER_WAVE_NONE 0
#define FROGGER_WAVE_LEFT 1
#define FROGGER_WAVE_RIGHT 2
#define FROGGER_WAVE_ALL 3
#define	NEXT_WAVE_TIME 3	
frogger_debris_start()
{
	level endon( "frogger_done" );

	if ( !IsDefined( level.frogger_debris_active ) )
	{
		level.frogger_debris_active = true;
	}
	else 
	{
		return;
	}
	
	level thread frogger_debris_sequence_think();
	
	// get all points where debris can spawn in 
	a_debris_paths_left = _get_debris_path_array_left();
	a_debris_paths_right = _get_debris_path_array_right();
	a_debris_paths_all = ArrayCombine( a_debris_paths_left, a_debris_paths_right, true, false );
	
	// get all the large objects to send down the street
	a_debris_models = _get_debris_model_array();
	
	Assert( ( a_debris_paths_all.size <= a_debris_models.size ), "there are " + a_debris_paths_all.size + " debris paths, but " + a_debris_models.size + " debris models. Add more debris models to the frogger section!" );
	
	DEFAULT( level.frogger_debris_wave_type, FROGGER_WAVE_NONE );
	
	 // spawn 2 waves of prepopulated debris so player can see it in market before exiting, then full splines only after that
	level thread _prepopulate_frogger_debris( a_debris_models );
	
	n_wave_type = FROGGER_WAVE_NONE;  // placeholder for first wave
	n_model_index = 0;  // cycle debris in a predictable fashion
	
	// spawn in debris
	while ( true )
	{		
		// determine wave type
		n_wave_type_next = level.frogger_debris_wave_type;
		
		// did state change?
		b_is_new_state = !( n_wave_type_next == n_wave_type );
		
		// set valid splines
		if ( n_wave_type_next == FROGGER_WAVE_NONE )
		{
			a_splines = [];
		}
		else if ( n_wave_type_next == FROGGER_WAVE_LEFT )
		{
			a_splines = a_debris_paths_left;
		}
		else if ( n_wave_type_next == FROGGER_WAVE_RIGHT )
		{
			a_splines = a_debris_paths_right;
		}
		else // all
		{
			a_splines = a_debris_paths_all;
		}
		
		// spawn wave
		n_model_index = _frogger_spawn_debris_wave( a_splines, a_debris_models, b_is_new_state, n_wave_type_next, n_model_index );
		
		n_wave_type = n_wave_type_next;
		wait NEXT_WAVE_TIME;
	}
}

frogger_set_debris_wave_type( str_wave_type )
{
	Assert( IsDefined( str_wave_type ), "str_wave_type is a required parameter for frogger_set_debris_wave_type!" );
	
	switch ( str_wave_type )
	{
		case "all":
			n_wave_index = FROGGER_WAVE_ALL;
			break;
			
		case "left":
			n_wave_index = FROGGER_WAVE_LEFT;
			break;
		
		case "right":
			n_wave_index = FROGGER_WAVE_RIGHT;
			break;
		
		case "none":
			n_wave_index = FROGGER_WAVE_NONE;
			break;
		
		default:
			n_wave_index = FROGGER_WAVE_ALL;
			AssertMsg( str_wave_type + " is an invalid frogger debris wave type. Valid types = all, left, right, none" );
			break;
	}
	
	level.frogger_debris_wave_type = n_wave_index; 
}

frogger_debris_sequence_think()
{
	level endon( "frogger_done" );
	            
	while ( true )
	{
		frogger_set_debris_wave_type( "left" );
		wait 6;
		frogger_set_debris_wave_type( "none" );
		wait 6;
		frogger_set_debris_wave_type( "right" );
		wait 6;
		frogger_set_debris_wave_type( "all" );
		wait 6;
	}
}

_frogger_spawn_debris_wave( a_splines, a_debris_models, b_is_new_state, n_wave_type, n_index )
{
	if ( a_splines.size > 0 )
	{		
		b_is_first_run = true;
		
		for ( i = 0; i < a_splines.size; i++ )
		{
			if ( n_index == a_debris_models.size )
			{
				n_index = 0;
			}
			
			vh_temp = _spawn_and_move_frogger_debris( a_debris_models[ n_index ], a_splines[ i ] );
			vh_temp.frogger_debris_wave_type = n_wave_type;
			
			if ( b_is_new_state && b_is_first_run )
			{
				 vh_temp.frogger_debris_wave_leader = true;
				 b_is_first_run = false;
			}
			
			n_index++;
		}
	}
	
	return n_index;
}

_prepopulate_frogger_debris( a_debris_models )
{
	const n_wave_count = 1;
	
	a_debris_paths_short = _get_prepopulated_debris_path_array();
	
	n_half_done = ( Floor( a_debris_paths_short.size * 0.5 ) );
	
	j = 0;  // model counter. will have more spawn points than models, so loop at appropriate time
	
	for ( n_waves = 0; n_waves < n_wave_count; n_waves++ )
	{
		for ( i = 0; i < a_debris_paths_short.size; i++ )
		{
			if ( j == a_debris_models.size )
			{
				j = 0;
			}
			
			vh_temp = _spawn_and_move_frogger_debris( a_debris_models[ j ], a_debris_paths_short[ i ] );	
			vh_temp.frogger_debris_wave_type = 0000;
			j++;
			wait RandomFloat( 0.5, 1 );
		}
		
		wait NEXT_WAVE_TIME;
	}
}

// spawns a model for the actual debris, then links it to a script_vehicle for movement
// link heiarchy: debris model --> bob origin --> misc vehicle ( links to = --> )
#using_animtree( "animated_props" );
_spawn_and_move_frogger_debris( str_model, nd_path_start )
{
	vh_temp = maps\_vehicle::spawn_vehicle_from_targetname( "fake_vehicle_spawner" );
	vh_temp.origin = nd_path_start.origin;  
	
	// actual debris model = vh_temp.m_temp
	vh_temp.m_temp = spawn_model( str_model, nd_path_start.origin, nd_path_start.angles );
	
	/#RecordEnt(vh_temp.m_temp);#/
	
	// add bobbing model (vh_temp.m_anim)
	vh_temp _frogger_debris_add_bobbing_anim( nd_path_start );
	
	b_should_flip = _should_debris_flip();
	v_offset_origin = vh_temp.m_temp _find_float_origin_offset( b_should_flip );
	v_offset_angles = vh_temp.m_temp _find_float_angles_offset( b_should_flip );
	vh_temp.m_temp.is_flipped = b_should_flip;  // for easier tracking of offsets
	vh_temp.m_temp _frogger_fx_play_on_object();
	vh_temp.m_temp LinkTo( vh_temp.m_anim, "origin_animate_jnt", v_offset_origin, v_offset_angles );
	vh_temp thread go_path( nd_path_start );
	vh_temp thread delete_at_spline_end();
	vh_temp.m_temp thread notify_on_collision( vh_temp );
	
	if( str_model == "veh_iw_civ_car_hatch" && randomintrange(0,100) <= 45 )
	{
		vh_temp.m_temp playloopsound( "amb_debris_float_loop_0", .25 );
	}
	else
	{
		vh_temp.m_temp playloopsound( "amb_debris_float_loop_1", .25 );
	}
	
	return vh_temp;
}

_frogger_debris_add_bobbing_anim( nd_path_start )  // self = misc vehicle on frogger debris spline
{
	// 'bobbing' comes from animation
	self.m_anim = spawn_model( "tag_origin_animate", nd_path_start.origin, nd_path_start.angles );
	self.m_anim init_anim_model( "frogger_debris", false );  // NOT simple prop
	self.m_anim LinkTo( self );	
	
	anim_bob = level.scr_anim[ "frogger_debris" ][ "frogger_debris_bob" ];
	self.m_anim SetAnim( anim_bob, 1, 0, 1 );	
}

move_frogger_cover( str_model_name, nd_path_start, b_delete_at_end )
{
	DEFAULT( b_delete_at_end, false );
	
	if ( IsString( nd_path_start ) )
	{
		nd_path_start = GetVehicleNode( nd_path_start, "targetname" );
	}
	
	vh_temp = maps\_vehicle::spawn_vehicle_from_targetname( "fake_vehicle_spawner" );
	vh_temp.origin = nd_path_start.origin;  
	vh_temp.angles = nd_path_start.angles;
	
	vh_temp _frogger_debris_add_bobbing_anim( nd_path_start );
	
	vh_temp.m_temp = get_ent( str_model_name, "targetname", true );
	vh_temp.m_temp _frogger_fx_play_on_object();
	vh_temp.m_temp LinkTo( vh_temp.m_anim, "origin_animate_jnt" );
	vh_temp thread go_path( nd_path_start );
	vh_temp.m_temp thread notify_on_collision( vh_temp );
	
	if ( b_delete_at_end ) 
	{
		vh_temp thread delete_at_spline_end();
	}
}

_get_debris_path_array_left()
{
	a_debris_paths = [];

	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_3", "targetname" ) );
	//ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_5", "targetname" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_6", "targetname" ) );		
	
	return a_debris_paths;
}

_get_debris_path_array_right()
{
	a_debris_paths = [];

	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_1", "targetname" ) );
	//ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_2", "targetname" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_4", "targetname" ) );		
	
	return a_debris_paths;
}

_get_prepopulated_debris_path_array()
{
	a_debris_paths = [];
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_1_prepopulate", "script_noteworthy" ) );
//	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_2_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_3_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_4_prepopulate", "script_noteworthy" ) );
//	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_5_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_6_prepopulate", "script_noteworthy" ) );		
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_7_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_8_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_9_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_10_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_11_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_12_prepopulate", "script_noteworthy" ) );	
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_13_prepopulate", "script_noteworthy" ) );
//	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_14_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_15_prepopulate", "script_noteworthy" ) );	
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_16_prepopulate", "script_noteworthy" ) );
	//ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_17_prepopulate", "script_noteworthy" ) );
	ARRAY_ADD( a_debris_paths, GetVehicleNode( "avoid_debris_spawn_point_18_prepopulate", "script_noteworthy" ) );	

	return a_debris_paths;	
}

_get_debris_model_array()
{
	a_debris_models = [];
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_1 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_2 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_3 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_4 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_5 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_6 );	
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_7 );		
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_8 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_9 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_10 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_11 );
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_12 );	
	ARRAY_ADD( a_debris_models, FROGGER_DEBRIS_13 );	
	
	return a_debris_models;
}

_frogger_fx_play_on_object()
{
	self SetClientFlag( CLIENT_FLAG_FROGGER_DEBRIS );
	
	if ( self.model == "veh_iw_civ_car_hatch" )
	{
		str_tag = "origin_animate_jnt";
		self play_fx( "frogger_car_interior_light", self GetTagOrigin( str_tag ), self GetTagAngles( str_tag ), undefined, true, str_tag );
	}
}

// offset specific models so they are visible in water. note that upside down models have different offsets...
_find_float_origin_offset( b_should_flip )  // self = model
{
	v_offset = ( 0, 0, 0 );
	
	switch ( self.model )
	{
		case "furniture_couch_leather2_dust":
			v_offset = ( 0, 0, 14 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 50 );
			}
			break;
			
		case "p_glo_crate02":
			v_offset = ( 0, 0, 12 );
			if ( b_should_flip ) 
			{
				v_offset = ( 0, 0, 40 );
			}
			break;
			
		case "p6_chair_damaged_panama":
			v_offset = ( 0, 0, 16 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 50 );
			}
			break;
			
		case "com_pallet_2":
			v_offset = ( 0, 0, 29 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 35 );
			}		
			break;
		
		case "veh_iw_civ_car_hatch":
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 52 );
			}
			break;
			
		case "ch_crate48x64":
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 45 );
			}
			break;
		
		case "me_refrigerator_d":
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 60 );
			}
			break;
			
		case "iw_construction_porter_potty":
			v_offset = ( 0, 0, -10 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 60 );
			}
			break;			
			
		case "global_barrel_grey_rusty":
			v_offset = ( 0, 0, -0 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 0 );
			}
			break;	
			
		case "com_barrel_green_dirt":
			v_offset = ( 0, 0, 0 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 45 );
			}
			break;					

		case "furniture_cabinet_console_b":
			v_offset = ( 0, 0, 15 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 50 );
			}
			break;	

		case "machinery_washer_blue":
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 55 );
			}
			break;	

		case "paris_kitchen_prep_sink":
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 45 );
			}
			break;	
			
		case "p_ger_desk_industrial":
			v_offset = ( 0, 0, 15 );
			if ( b_should_flip )
			{
				v_offset = ( 0, 0, 54 );
			}
			break;				
					
		case "com_vending_can_new1_destroyed":
		v_offset = ( 0, 0, 0 );
		if ( b_should_flip )
		{
			v_offset = ( 0, 0, 60 );
		}
		break;		
		
		case "dub_lounge_sofa_02":
		v_offset = ( 0, 0, 6 );
		if ( b_should_flip )
		{
			v_offset = ( 0, 0, 35 );
		}
		break;			
		
		case "berlin_furniture_chair1_dusty":
		v_offset = ( 0, 0, 6 );
		if ( b_should_flip )
		{
			v_offset = ( 0, 0, 40 );
		}
		break;	
		
		case "paris_furniture_chair2_b":
		v_offset = ( 0, 0, 0 );
		if ( b_should_flip )
		{
			v_offset = ( 0, 0, 25 );
		}
		break;	

		case "afr_mattress_3":
		v_offset = ( 0, 0, 27 );
		if ( b_should_flip )
		{
			v_offset = ( 0, 0, 32 );
		}
		break;			
		
		default:
			debug_print_line( self.model + " is missing origin offset parameter" );
			break;
	}
	
	return v_offset;
}

_should_debris_flip()
{
	const n_chance_to_flip = 50;
	b_should_flip = ( RandomInt( 100 ) > n_chance_to_flip );
	
	return b_should_flip;
}

#define ANGLES_X_MIN	-8
#define ANGLES_X_MAX	8
#define ANGLES_Y_MIN	-8 
#define ANGLES_Y_MAX 	8
_find_float_angles_offset( b_should_flip )  // self = model
{
	v_offset = ( RandomIntRange( ANGLES_X_MIN, ANGLES_X_MAX ), RandomIntRange( ANGLES_Y_MIN, ANGLES_Y_MAX ), 0 );
	
	if ( b_should_flip )
	{
		v_offset+= ( 0, 0, 180 );
	}
	
	return v_offset;
}	

// since all the #defines for frogger debris are kept here, pakistan.gsc calls this function before _load::main()
precache_frogger_debris()
{
	PrecacheModel( FROGGER_DEBRIS_1 );
	PrecacheModel( FROGGER_DEBRIS_2 );
	PrecacheModel( FROGGER_DEBRIS_3 );
	PrecacheModel( FROGGER_DEBRIS_4 );
	PrecacheModel( FROGGER_DEBRIS_5 );
	PrecacheModel( FROGGER_DEBRIS_6 );
	PrecacheModel( FROGGER_DEBRIS_7 );
	PrecacheModel( FROGGER_DEBRIS_8 );
	PrecacheModel( FROGGER_DEBRIS_9 );
	PrecacheModel( FROGGER_DEBRIS_10 );
	PrecacheModel( FROGGER_DEBRIS_11 );
	PrecacheModel( FROGGER_DEBRIS_12 );
	PrecacheModel( FROGGER_DEBRIS_13 );
	
	precache_dyn_ent_debris();
}


#define SPEED_SCALE_IN_HIGH_WATER 0.6
#define TIME_BEFORE_PUSH 2.5
slow_player_in_fast_water( str_trigger_name, str_flag, v_push_direction, b_play_rumble = false )  // self = player
{
	self endon( "death" );
	
	t_water = get_ent( str_trigger_name, "targetname", true );
	n_frame_counter = 0;
	n_frames_to_push = Int( TIME_BEFORE_PUSH * 20 );  // must be int for possible increment later

	if ( !self ent_flag_exist( "frogger_rumble_active" ) )
	{
		self ent_flag_init( "frogger_rumble_active" );
	}
	
	while ( !flag( str_flag ) )
	{
		n_speed = 1.0;  // normal movement speed
		
		if ( self IsTouching( t_water ) )
		{
			if ( !self ent_flag( "frogger_rumble_active" ) && b_play_rumble )
			{
				self PlayRumbleLoopOnEntity( FROGGER_WATER_RUMBLE );
				self ent_flag_set( "frogger_rumble_active" );
			}
			
			n_speed = SPEED_SCALE_IN_HIGH_WATER;
			b_using_thumbstick = self is_player_using_thumbstick();
			
			if ( b_using_thumbstick )
			{
				n_frame_counter = 0;
			}
			else 
			{
				n_frame_counter++;
			}
			
			// automatically push back if player jumps first
			if ( !( self IsOnGround() ) )
			{
				n_frame_counter = n_frames_to_push;
			}
			
			b_should_push = ( n_frame_counter > n_frames_to_push );
			
			if ( b_should_push )
			{
				v_velocity = self GetVelocity();
				self SetVelocity( v_velocity + v_push_direction );
			}
		}
		else 
		{
			if ( self ent_flag( "frogger_rumble_active" ) )
			{
				self ent_flag_clear( "frogger_rumble_active" );
				self StopRumble( FROGGER_WATER_RUMBLE );
			}
		}
		
		wait 0.05;
	}

	// stop rumble when event is done if it's active
	if ( self ent_flag( "frogger_rumble_active" ) )
	{
		self ent_flag_clear( "frogger_rumble_active" );
		self StopRumble( FROGGER_WATER_RUMBLE );
	}	
	
}

slow_ai_in_fast_water( str_trigger_name, str_flag )
{
	self endon( "death" );
	
	t_water = get_ent( str_trigger_name, "targetname", true );
	
	while ( !flag( str_flag ) )
	{
		a_guys_in_water = get_ai_touching_volume( "axis", str_trigger_name, t_water );
		a_guys_in_water = ArrayCombine( a_guys_in_water, get_ai_touching_volume( "allies", str_trigger_name, t_water ), true, false );
		
		foreach ( guy in a_guys_in_water )
		{
			if ( !IsDefined( guy.ignore_water_speed ) )
			{
				guy AllowedStances( "stand" );
				guy change_movemode( "cqb_walk" );
				guy.moveplaybackrate = 0.8;
			}
		}
		
		wait 1;
	}
	
	a_guys_in_water = get_ai_touching_volume( "axis", str_trigger_name, t_water );
	a_guys_in_water = ArrayCombine( a_guys_in_water, get_ai_touching_volume( "allies", str_trigger_name, t_water ), true, false );
	
	foreach ( guy in a_guys_in_water )
	{
		guy AllowedStances( "stand", "crouch", "prone" );
		guy reset_movemode();
		guy.moveplaybackrate = 1;
	}	
}

is_player_using_thumbstick()  // self = player
{
	const n_threshold = 0.3;
	b_using_thumbstick = true;
	
	v_thumbstick = self GetNormalizedMovement();
	
	if ( Length( v_thumbstick ) < n_threshold )
	{
		b_using_thumbstick = false;
	}
	
	return b_using_thumbstick;
}

delete_at_spline_end()
{
	self waittill( "reached_end_node" );
	if ( IsDefined( self.m_temp ) )
	{
		self.m_temp ClearClientFlag( CLIENT_FLAG_FROGGER_DEBRIS );
		
		wait 0.1;  // give client a chance to clear flag to stop playing fx before deleting the ent
		
		if ( IsDefined( self.m_anim ) )
		{
			self.m_anim Delete();
		}
		
		if ( IsDefined( self.m_temp ) )
		{
			self.m_temp Delete();
		}
	}
	
	VEHICLE_DELETE( self )
}

// when should we do damage? if vehicle speed > threshold, cooldown is up, and not hero AI
#define COLLISION_DAMAGE 20
#define COLLISION_COOLDOWN_MS 1000
#define COLLISION_SPEED_MIN 8
notify_on_collision( vh_ent )  // self = model with collision
{
	self endon( "death" );
	vh_ent endon( "death" );
	
	while ( true )
	{
		self waittill( "touch", e_touched );
		
		b_is_player = IsPlayer( e_touched );
		b_is_hero_ai = e_touched is_hero();
		b_debris_fast_enough = ( vh_ent GetSpeedMPH() > COLLISION_SPEED_MIN );
		
		if ( b_is_player )
		{
			level notify( "player_hit_by_frogger_debris" );
			debug_print_line( "player_hit_by_frogger_debris" );
			self SetMovingPlatformEnabled( true );  // removes jitters on player push
			self frogger_debris_audio();
		}
		
		b_should_damage = ( b_is_player || !b_is_hero_ai || b_debris_fast_enough );
		
		if ( b_is_hero_ai )
		{
			DEFAULT( e_touched.playing_custom_pain, false );
			
			if ( !e_touched.playing_custom_pain )  
			{	
				e_touched AnimCustom( ::frogger_debris_pain_react );  // not blocking
				self frogger_debris_audio();
			}
		}	
		if ( b_should_damage )
		{
			if ( !IsDefined( e_touched._last_collision_time ) )
			{
				e_touched._last_collision_time = 0;
			}
			
			if ( b_is_player && ( level.player.health < COLLISION_DAMAGE ) )
			{
				SetDvar( "ui_deadquote", &"PAKISTAN_SHARED_FROGGER_FAIL" );
			}
			
			n_current_time_ms = GetTime();
			
			if ( ( n_current_time_ms - e_touched._last_collision_time ) > COLLISION_COOLDOWN_MS )
			{			
				e_touched DoDamage( COLLISION_DAMAGE, self.origin, self );
				e_touched._last_collision_time = n_current_time_ms;
				
				// additional rumble besides damage
				if ( b_is_player )
				{
					level thread maps\pakistan_anim::vo_frogger_debris_hit();
					
					level.player ViewKick( 40, self.origin );
					level.player PlayRumbleOnEntity( "damage_heavy" );
				}
			}
		}
	}
}

frogger_debris_audio()
{
	if (self.model == "com_pallet_2" || self.model == "p_glo_crate02" || self.model == "ch_crate48x64" )
	{
		self playsound ("fly_bump_wood");
	}
	
	else if (self.model == "veh_iw_civ_car_hatch" )
	{
		self playsound ("fly_bump_veh");
	}
	
	else if (self.model == "furniture_couch_leather2_dust" )
	{
		self playsound ("fly_bump_couch");
	}
	
	else if (self.model == "p6_chair_damaged_panama" ) 
	{
		self playsound ("fly_bump_chair");
	}
	
	else if (self.model == "me_refrigerator_d" ) 
	{
		self playsound ("fly_bump_fridge");
	}
	
	else 
	{
		self playsound ("fly_bump_plr");
		//iprintln (self.model);  // TravisJ - removed debug text for milestone
	}
}
	

// play pain reaction on Harper, but don't allow him to be pushed by objects
frogger_debris_pain_react()
{
	DEFAULT( self.playing_custom_pain, false );
	
	if ( !self.playing_custom_pain ) 
	{		
		// play pain react, link to temp origin so harper isn't pushed
		self.playing_custom_pain = true;
		b_pain_enabled = self.allowpain;
		self disable_pain();
		self.takedamage = false;
		anim_pain = self _get_best_frogger_pain_anim();
		e_temp = Spawn( "script_origin", self.origin );
		self LinkTo( e_temp );
		self SetFlaggedAnimKnobAllRestart( "pain_anim", anim_pain, %generic_human::body, 1, 0.2, 1 );
		self waittillmatch( "pain_anim", "end" );
		
		// restore parameters
		if ( b_pain_enabled )
		{
			self enable_pain();
		}
		self.takedamage = true;
		self Unlink();
		e_temp Delete();
		self.playing_custom_pain = false;		
	}
}

_get_best_frogger_pain_anim()
{
	// TODO: get a list of pain anims that are appropriate here
	anim_best = %generic_human::exposed_pain_leg;
	
	return anim_best;
}