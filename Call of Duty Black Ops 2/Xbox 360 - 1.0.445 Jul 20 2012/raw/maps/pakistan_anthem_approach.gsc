/*-----------------------------------------------------------------------------
pakistan_anthem_approach.gsc

Events contained in this file:
- anthem_approach
- sewer_exterior
- sewer_interior
 ----------------------------------------------------------------------------*/
 
#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\pakistan_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\pakistan.gsh;

#define DRONE_SPOTLIGHT_TAG "tag_flash"
#define DRONE_SPOTLIGHT_TURRET 0
 
/*----------------------------------------------------------------------------
Skipto section
----------------------------------------------------------------------------*/
skipto_anthem_approach()
{	
	wait 0.1;  // let global_funcs catch up
	skipto_teleport( "skipto_anthem_approach", _get_friendly_array_anthem_approach() );
	
	delay_thread( 0.5, ::flag_set, "corpse_alley_drone_and_civ_done" );
	level thread _skipto_anthem_approach();
}

_skipto_anthem_approach()
{
	wait 1;
	
	vh_helicopter = get_ent( "drone_helicopter", "targetname", true );
	vh_helicopter ent_flag_set( "start_spotlight_search" );	
}

skipto_sewer_exterior()
{
	skipto_teleport( "skipto_sewer_exterior", _get_friendly_array_anthem_approach() );
}

skipto_sewer_interior()
{
	if ( !flag( "_stealth_spotted" ) )
	{
		level.player thread maps\_stealth_logic::stealth_ai();
	}	
	
	skipto_teleport( "skipto_sewer_interior", _get_friendly_array_anthem_approach() );
}

skipto_sewer_interior_perk()
{
	level.player SetPerk( PERK_INTRUDER );
	skipto_sewer_interior();
}

skipto_sewer_interior_no_perk()
{
	level.player UnsetPerk( PERK_INTRUDER );
	skipto_sewer_interior();	
}

_get_friendly_array_anthem_approach()
{
	a_friendlies = [];
	ARRAY_ADD( a_friendlies, init_hero( "harper" ) );
	
	return a_friendlies;
}


/*-----------------------------------------------------------------------------
Event functions
-----------------------------------------------------------------------------*/
anthem_approach()
{
	autosave_by_name( "pakistan_anthem_approach" );
	flag_init( "drone_at_bank" );
	flag_init( "avoid_spotlights_done" );
	
	//maps\pakistan_anim::avoid_spotlights_moveup_nag_setup();
	//level thread maps\_dialog::start_vo_nag_group_flag( "avoid_spotlight_moveup", "avoid_spotlights_done", 6, 1, true, 3, ::avoid_spotlight_nag_filter );  
	level thread maps\pakistan_anim::vo_avoid_spotlight();
	
	flag_set( "pakistan_introscreen_show" );

	anthem_approach_ai_setup();
	vh_drone = _get_drone_helicopter();
	vh_drone thread drone_patrol();
	
	trigger_wait( "sideways_building_start" );
	flag_set( "avoid_spotlights_done" );
	
	if ( IsDefined( vh_drone ) )
	{
		debug_print_line( "drone leaves" );
		vh_drone delay_thread( 6, ::ent_flag_clear, "start_spotlight_search" );
		vh_drone CancelAIMove(); 
		wait 0.1;
		vh_drone thread drone_gets_on_path( "drone_flies_back_to_alley" );
	}
}

drone_patrol()
{
	self endon( "death" );
	level endon( "avoid_spotlights_done" );
	level endon( "drone_detects_player" );
	level endon( "_stealth_spotted" );
	
	self ent_flag_init( "on_patrol_path" );
	const n_wait_time = 3;
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	self drone_set_lookat_ent( "drone_scan_building_1" );
	self drone_flies_to_point( "drone_stop_point_diner" );	
	wait 4;
	ai_harper ent_flag_waitopen( "moving_to_goal" );
	self drone_clear_lookat_ent();
	
	while ( true )
	{
		debug_print_line( "starting patrol route" );
	
		ai_harper ent_flag_waitopen( "moving_to_goal" );
		self drone_gets_on_path( "drone_looks_at_building_1_path" );
		
		wait n_wait_time;
	
		ai_harper ent_flag_waitopen( "moving_to_goal" );		
		self drone_gets_on_path( "drone_looks_at_building_2_path" );
		
		wait n_wait_time;
		
		if ( flag( "drone_looks_at_building_2" ) )
		{
			ai_harper ent_flag_waitopen( "moving_to_goal" );
			self drone_gets_on_path( "drone_looks_at_building_3_path" );
			
			wait n_wait_time;
			
			if ( flag( "drone_looks_at_building_3" ) )
			{			
				ai_harper ent_flag_waitopen( "moving_to_goal" );
				self drone_gets_on_path( "drone_looks_at_building_4_path" );
				
				wait n_wait_time;
			}
		}
	}
}

drone_flies_to_point( str_struct_targetname )
{
	const n_search_speed = 10;
	const n_near_goal_dist = 128;
	
	self SetSpeed( n_search_speed );	
	self SetNearGoalNotifyDist( n_near_goal_dist );
	s_goal = get_struct( str_struct_targetname, "targetname", true );
	self SetVehGoalPos( s_goal.origin );
	self waittill( "near_goal" );
}

// this will NOT clear lookat ents by default, and is blocking
drone_set_lookat_ent( str_ent_targetname, n_focus_time = 0 )  // self = drone helicopter
{
	e_lookat = get_ent( str_ent_targetname, "targetname", true );
	self SetLookatEnt( e_lookat );
	self.spotlight_target = e_lookat;
	//self maps\_turret::set_turret_target( self.spotlight_target, ( 0, 0, 0 ), DRONE_SPOTLIGHT_TURRET );
	debug_print_line( "helicopter looking at " + str_ent_targetname );
	
	if ( n_focus_time > 0 )
	{
		wait n_focus_time;
		self drone_clear_lookat_ent();
	}
}

drone_scan_default()
{
	const n_time_for_scan = 3;  // time it takes to go from one side to the other. doesn't factor turret speed in
	b_scan_right = true;
	
	while ( is_alive( self ) )
	{
		if ( !self ent_flag( "focus_spotlight" ) )
		{
			// right to left... forever
			if ( b_scan_right )
			{
				self.spotlight_target = self.e_spotlight_default_right;
			}
			else
			{
				self.spotlight_target = self.e_spotlight_default_left;
			}
			
			b_scan_right = !b_scan_right; // toggle back and forth
			self maps\_turret::set_turret_target( self.spotlight_target, ( 0, 0, 0 ), DRONE_SPOTLIGHT_TURRET );
			wait n_time_for_scan;
		}
		else 
		{
			wait 1;
		}
	}
}

drone_clear_lookat_ent() // self = drone helicopter
{
	self ClearLookAtEnt();
	self.spotlight_target = self.e_spotlight_default;
}

_get_drone_helicopter()
{
	vh_helicopter = get_ent( "drone_helicopter", "targetname" );
	
	if ( !IsDefined( vh_helicopter ) )
	{
		vh_helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "drone_helicopter" );
	}	
	
	return vh_helicopter;
}

drone_gets_on_path( str_name, b_lockpath )  // self = drone helicopter. not blocking!
{
	nd_path_start = GetVehicleNode( str_name, "targetname" );
	
	self.drivepath = 1;
	
	if ( IsDefined( b_lockpath ) && b_lockpath ) 
	{
		// there's an issue with using drivepath to get on a spline after an anim, but lockpath works; start with lockpath, then drivepath. TODO: bug and get fixed!
		self.drivepath = 0;
		self AttachPath( nd_path_start );
		wait 0.1;
		self.drivepath = 1;
	}
	
	debug_print_line( "drone path: " + str_name );
	level notify( "drone_helicopter_on_new_path" );
	self ent_flag_set( "on_patrol_path" );
	self go_path( nd_path_start );
	self ent_flag_clear( "on_patrol_path" );
}

avoid_spotlight_nag_filter()
{
	const n_distance_to_nag = 400;
	
	if ( !IsDefined( level.ai_harper ) )
	{
		level.ai_harper = get_ent( "harper_ai", "targetname" );
	}
	
	n_distance = Distance( level.ai_harper.origin, level.player.origin );
	
	b_is_far_from_harper = ( n_distance > n_distance_to_nag );
	b_is_harper_talking = IsDefined( level.ai_harper.is_talking );
	
	b_should_nag = ( b_is_far_from_harper && !b_is_harper_talking );
	
	return b_should_nag;
}

anthem_approach_ai_setup()
{
	ai_harper = init_hero( "harper" );
	ai_harper change_movemode( "cqb" );
	
	if ( !flag( "drone_attacks_player" ) )
	{
		ai_harper thread anthem_approach_harper_movement();
	}
}

anthem_approach_harper_movement()  // self = AI (harper)
{
	level endon( "avoid_spotlights_done" );
	level endon( "helicopter_dead" );
	level endon( "drone_attacks_player" );
	
	self thread anthem_approach_harper_movement_restore();
	
	self ent_flag_init( "moving_to_goal" );
	
	self set_goalradius( 64 );
	nd_start = GetNode( "harper_spotlight_cover_start", "targetname" );
	self set_goal_node( nd_start );
	self waittill( "goal" );
	vh_drone = _get_drone_helicopter();
	
	flag_wait( "corpse_alley_harper_done" );
	self thread maps\_dialog::say_dialog( "harp_okay_go_0" );  // Ok, GO!
	self thread maps\_dialog::say_dialog( "harp_oh_i_m_watchin_y_0", 2 );  // Oh... I'm watchin' you...
	
	nd_1 = GetNode( "harper_spotlight_cover_1", "targetname" );
	
	self set_goal_node( nd_1 );
	self waittill( "goal" );
	self ent_flag_clear( "moving_to_goal" );
	debug_print_line("harper: 1" );
	wait 2;	
	
	flag_wait( "drone_looks_at_building_2" );  // set in radiant off trigger
	self thread maps\_dialog::say_dialog( "harp_that_s_right_you_dum_0" );  // That's right you dumb bastard, keep looking the wrong fucking way.
	
	nd_2 = GetNode( "harper_spotlight_cover_2", "targetname" );
	self harper_waits_until_path_is_clear_to_goal( nd_2, vh_drone );
	self set_goal_node( nd_2 );
	self waittill( "goal" );
	self ent_flag_clear( "moving_to_goal" );
	debug_print_line("harper: 2" );
	
	wait 2;
	
	nd_3 = GetNode( "harper_spotlight_cover_3", "targetname" );
	self harper_waits_until_path_is_clear_to_goal( nd_3, vh_drone );
	self set_goal_node( nd_3 );
	self waittill( "goal" );
	self ent_flag_clear( "moving_to_goal" );
	debug_print_line("harper: 3" );

	flag_wait( "drone_looks_at_building_3" );  // set in radiant off trigger
	self thread maps\_dialog::say_dialog( "harp_stay_left_brother_0" );//Stay left, brother!
	
	nd_4 = GetNode( "harper_spotlight_cover_4", "targetname" );
	self harper_waits_until_path_is_clear_to_goal( nd_4, vh_drone );
	self set_goal_node( nd_4 );
	self waittill( "goal" );
	self ent_flag_clear( "moving_to_goal" );
	debug_print_line("harper: 4" );
	
	flag_wait( "drone_flies_back_to_alley" );  // set in radiant off trigger
	self thread maps\_dialog::say_dialog( "harp_it_s_turning_around_0" );  // It's turning around!
	
	nd_5 = GetNode( "harper_spotlight_cover_5", "targetname" );
	self harper_waits_until_path_is_clear_to_goal( nd_5, vh_drone );
	self set_goal_node( nd_5 );
	self waittill( "goal" );
	self ent_flag_clear( "moving_to_goal" );
	debug_print_line("harper: 5" );
	wait 2;	
	
	self thread maps\_dialog::say_dialog( "harp_move_section_1" ); // Move, Section!
}

anthem_approach_harper_movement_restore()
{
	str_color = self get_force_color();
	self clear_force_color();	
	
	level waittill_any( "avoid_spotlights_done", "helicopter_dead", "drone_attacks_player" );
	self set_force_color( str_color );
}

harper_waits_until_path_is_clear_to_goal( nd_goal, vh_drone )  // self = harper
{
	self ent_flag_clear( "moving_to_goal" );
	
	const n_dot_max = 0.7;
	b_trace = false;
	
	if ( is_alive( vh_drone ) )
	{
		b_has_clear_path = false;
		
		while ( !b_has_clear_path )
		{
			wait 0.25;  // wait first so there's no delay in calculations
			
			// figure out if spotlight can see current location and goal position
			b_can_see_goal_position = vh_drone _can_spotlight_see_position( nd_goal.origin, n_dot_max );
			b_can_see_current_position = vh_drone _can_spotlight_see_position( self.origin, n_dot_max );
			b_drone_moving = vh_drone ent_flag( "on_patrol_path" );
			
			if ( !b_can_see_current_position && !b_can_see_goal_position && !b_drone_moving )
			{
				b_has_clear_path = true;
			}
		}
	}
	
	self ent_flag_set( "moving_to_goal" );
	debug_print_line( "harper path clear now" );
}

// check spotlight direction versus a point
_can_spotlight_see_position( v_target_position, n_dot_tolerance )  // self = drone
{
	v_spotlight_origin = self GetTagOrigin( DRONE_SPOTLIGHT_TAG );
	v_to_harper_from_spotlight = VectorNormalize( v_target_position - v_spotlight_origin );
	v_drone_forward = AnglesToForward( self GetTagAngles( DRONE_SPOTLIGHT_TAG ) );
	n_dot = VectorDot( v_to_harper_from_spotlight, v_drone_forward );
	
	/#
	str_dvar = GetDvar( "debug_helicopter" );
	
	if ( str_dvar != "" )
	{
		self thread draw_line_for_time( v_target_position, v_spotlight_origin, 0, 0, 1, 0.25 );  // blue line: harper to drone
	}
	#/
	
	b_within_dot = ( n_dot > n_dot_tolerance );
	
	return b_within_dot;
}

pakistan_title_screen( string1, string2, string3, string4, string5 )
{
	level.introstring = []; 
	
	//introscreen_create_redacted_line
	flag_wait( "pakistan_introscreen_show" );
	
	level.introstring = []; 

	const pausetime = 0.75;
	const totaltime = 14.25;
	time_to_redact = ( 0.525 * totaltime);
	rubout_time = 1;
	color = (1,1,1);

	const delay_between_redacts_min = 350; // this is a slight pause added when redacting each line, so it isn't robotically smooth
	const delay_between_redacts_max = 500;

	start_rubout_time = Int( time_to_redact*1000 );// convert to miliseconds and fraction of total time to start rubbing out the text
	totalpausetime = 0; // track how much time we've waited so we can wait total desired waittime
	rubout_time = Int(rubout_time*1000); // convert to miliseconds 

	// following 2 lines are used in and logically could exist in isdefined(string1), but need to be initialized so exist here
	redacted_line_time = Int( 1000* (totaltime - totalpausetime) ); // each consecutive line waits the total time minus the total pause time so far, so they all go away at once.

	if( IsDefined( string1 ) )
	{
		level thread maps\_introscreen::introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time, color ); 

		wait( pausetime );
		totalpausetime += pausetime;	
	}

	if( IsDefined( string2 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string2, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);	
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string3, redacted_line_time,  start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string4 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) )	+ RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);		
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string4, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}		

	if( IsDefined( string5 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);			
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string5, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	wait (totaltime - totalpausetime);

	//default wait time
	wait 2.5;

	level notify("introscreen_done");
	
	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 	
}

transition_to_section_2()
{
	b_claw_has_flamethrower = level.player get_temp_stat( CLAW_HAS_FLAMETHROWER );
	b_soct_has_boost = level.player get_temp_stat( SOCT_HAS_BOOST );
	
	wait 4;
	nextmission(); 
}

drone_helicopter_setup()  // self = helicopter. spawn func
{
	self ent_flag_init( "start_spotlight_search" );
	self ent_flag_init( "focus_spotlight" );
	self play_fx( "helicopter_drone_spotlight", self GetTagOrigin( DRONE_SPOTLIGHT_TAG ), self GetTagAngles( DRONE_SPOTLIGHT_TAG ), "death", true, DRONE_SPOTLIGHT_TAG );
	self thread player_detection_logic();	
	self thread set_flag_on_notify( "death", "helicopter_dead" );
	self thread set_flag_on_notify( "death", "_stealth_spotted" );
	self SetHoverParams( 20 );
	self.drivepath = true;
	
	// give helicopter a 'default' spotlight position since turret system doesn't store default position of turret (spotlight is a turret here)
	const n_dist_forward = 400;
	const n_dist_right = 150;
	const DRONE_SPOTLIGHT_INDEX = 0;
	v_down_offset = ( 0, 0, -200 );
	v_spotlight_origin = ( ( AnglesToForward( self.angles ) * n_dist_forward ) + self.origin + v_down_offset );
	v_spotlight_origin_right_offset = ( AnglesToRight( self.angles ) * n_dist_right );
	self.e_spotlight_default = Spawn( "script_origin", v_spotlight_origin );
	self.e_spotlight_default LinkTo( self );
	
	// right and left origins are there for scanning while moving
	self.e_spotlight_default_right = Spawn( "script_origin", v_spotlight_origin + v_spotlight_origin_right_offset );	
	self.e_spotlight_default_right LinkTo( self );
	self.e_spotlight_default_left = Spawn( "script_origin", v_spotlight_origin - v_spotlight_origin_right_offset );
	self.e_spotlight_default_left LinkTo( self );
	
	// set default target for spotlight
	self.spotlight_target = self.e_spotlight_default;
	self maps\_turret::set_turret_target( self.spotlight_target, ( 0, 0, 0 ), DRONE_SPOTLIGHT_INDEX );	
	
	// thread scanning behavior
	self thread drone_scan_default();
	
	/#  // debug loop for drawing helicopter spotlight targets
	while ( is_alive( self ) )
	{
		str_dvar = GetDvar( "debug_helicopter" );
		
		if ( str_dvar != "" )
		{
			self thread draw_debug_line( self GetTagOrigin( "tag_turret" ), self.spotlight_target.origin, 0.05 );
		}
		
		wait 0.05;
	}
	#/
}

drone_spotlight_target_set( e_focus, n_focus_time = 0 )  // self = drone
{
	const DRONE_SPOTLIGHT_INDEX = 0;
	
	if ( IsString( e_focus ) )
	{
		e_focus = get_ent( e_focus, "targetname", true );
	}
	
	self.spotlight_target = e_focus;
	self maps\_turret::set_turret_target( self.spotlight_target, ( 0, 0, 0 ), DRONE_SPOTLIGHT_INDEX );	
	self ent_flag_set( "focus_spotlight" );
	
	if ( n_focus_time > 0 )
	{
		wait n_focus_time;
		self drone_spotlight_target_clear();
	}
}

// clears drone spotlight target and puts it back to default position 
drone_spotlight_target_clear()  // self = drone
{
	self ent_flag_clear( "focus_spotlight" );
	self.spotlight_target = self.e_spotlight_target_default;
}

player_detection_logic()
{
	if ( !IsDefined( self.player_detection_active ) )
	{
		self.player_detection_active = false;
	}
	
	self ent_flag_set( "start_spotlight_search" );
	
	if ( !self.player_detection_active )
	{
		self.player_detection_active = true;
		
		self thread drone_spotlight_detection();
		self thread player_detected_logic();
		self thread player_behaviors_to_alert_drone();
		self thread drone_detects_damage_for_alert();
	}
}

player_behaviors_to_alert_drone()
{
	self endon( "death" );
	level endon( "drone_attacks_player" );
	
	// level thread _player_behavior_movement();  // possibly reimplement after event is more complete
	const n_alert_cutoff_distance = 2000;
	
	while ( true )
	{
		level.player waittill_any( "weapon_fired", "grenade_fire", "grenade_launcher_fire" );
	
		n_distance = Distance( self.origin, level.player.origin );
		
		if ( n_distance < n_alert_cutoff_distance )
		{
			level notify( "drone_detects_player", &"PAKISTAN_SHARED_DRONE_FAIL_SOUND" );
		}
	}
}

_player_behavior_movement()
{
	self endon( "death" );
	level endon( "drone_attacks_player" );
	
	while ( true )
	{
		if ( level.player IsSprinting() || !( level.player IsOnGround() ) )
		{
			level notify( "drone_detects_player", &"PAKISTAN_SHARED_DRONE_FAIL_SOUND" );
		}
		
		wait 0.05;
	}
}

drone_detects_damage_for_alert()
{
	self endon( "death" );
	level endon( "drone_attacks_player" );
	
	while ( true )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		if ( IsPlayer( attacker ) )
		{
			level notify( "drone_detects_player", &"PAKISTAN_SHARED_DRONE_FAIL_SOUND" );
		}
	}
}

#define SPOTLIGHT_TAG "tag_flash"
drone_spotlight_detection()  // self = helicopter drone
{
	self endon( "death" );
	level endon( "drone_attacks_player" );
	
	const n_scale_forward = 500;
	const n_check_time = 0.05;
	
	n_frames_detected = 0;
	
	while ( true )
	{
		if ( self ent_flag( "start_spotlight_search" ) && !flag( "player_hiding_underwater" ) )
		{
			v_spotlight_origin = self GetTagOrigin( SPOTLIGHT_TAG );
			v_spotlight_forward = v_spotlight_origin + ( AnglesToForward( self GetTagAngles( SPOTLIGHT_TAG ) ) * n_scale_forward );
			v_spotlight = VectorNormalize( v_spotlight_forward - v_spotlight_origin );
			v_player_trace_origin = level.player get_eye();
			v_to_player = VectorNormalize( v_player_trace_origin - v_spotlight_origin );
			n_dot = VectorDot( v_spotlight, v_to_player );
	
			// debug_print_line( n_dot );
			str_difficulty = getdifficulty();
			n_dot_tolerance = level.player get_drone_spotlight_detection_dot_tolerance( str_difficulty );
			n_frames_before_detection = get_drone_spotlight_frames_before_detection( str_difficulty );
			
			b_within_dot = ( n_dot > n_dot_tolerance );
			b_can_hit = false;
			
			if ( b_within_dot )
			{
				a_trace = BulletTrace( v_spotlight_origin, v_player_trace_origin, true, self, true, true );
				b_can_hit = IsPlayer( a_trace[ "entity" ] ) || vector_compare( a_trace[ "position" ], v_player_trace_origin );
			}
			
			b_can_see = ( b_within_dot && b_can_hit );
			
			if ( b_can_see )
			{
				n_frames_detected++;
				debug_print_line( "spotlight can see player " + n_frames_detected );
			}
			else 
			{
				n_frames_detected = 0;
			}
			
			if ( n_frames_detected > n_frames_before_detection )
			{
				level notify( "drone_detects_player", &"PAKISTAN_SHARED_DRONE_FAIL_SIGHT" );
			}
		}
		
		wait n_check_time;
	}
}

get_drone_spotlight_frames_before_detection( str_difficulty )
{
	if ( !IsDefined( self.drone_spotlight_detection_parameters ) )
	{
		self _init_drone_spotlight_detection_parameters();
	}

	n_frames_to_detection = self.drone_spotlight_detection_parameters[ str_difficulty ][ "time_to_detect" ] * 20;  // 20 fps
	return n_frames_to_detection;
}

get_drone_spotlight_detection_dot_tolerance( str_difficulty )  // self = player
{
	str_stance = self GetStance();
	b_player_is_sprinting = self IsSprinting();
	b_player_is_jumping = !( self IsOnGround() );
	
	if ( !IsDefined( self.drone_spotlight_detection_parameters ) )
	{
		self _init_drone_spotlight_detection_parameters();
	}
	
	n_dot = self.drone_spotlight_detection_parameters[ str_difficulty ][ "dot_crouch" ]; // default for non standing or sprinting
	
	if ( str_stance == "stand" || b_player_is_sprinting || b_player_is_jumping )
	{
		n_dot = self.drone_spotlight_detection_parameters[ str_difficulty ][ "dot_exposed" ];
	}
	else if ( str_stance == "prone" )  // prone probably won't be possible anywhere, but just in case
	{
		n_dot = self.drone_spotlight_detection_parameters[ str_difficulty ][ "dot_prone" ];
	}
	
	return n_dot;
}

_init_drone_spotlight_detection_parameters()
{
	self.drone_spotlight_detection_parameters = [];
	
	// easy settings
	self.drone_spotlight_detection_parameters[ "easy" ][ "dot_prone" ] = 0.9;
	self.drone_spotlight_detection_parameters[ "easy" ][ "dot_crouch" ] = 0.8;
	self.drone_spotlight_detection_parameters[ "easy" ][ "dot_exposed" ] = 0.7;
	self.drone_spotlight_detection_parameters[ "easy" ][ "time_to_detect" ] = 1.25;
	
	// medium settings
	self.drone_spotlight_detection_parameters[ "medium" ][ "dot_prone" ] = 0.85;
	self.drone_spotlight_detection_parameters[ "medium" ][ "dot_crouch" ] = 0.7;
	self.drone_spotlight_detection_parameters[ "medium" ][ "dot_exposed" ] = 0.5;
	self.drone_spotlight_detection_parameters[ "medium" ][ "time_to_detect" ] = 1.00;
	
	// hard settings
	self.drone_spotlight_detection_parameters[ "hard" ][ "dot_prone" ] = 0.8;
	self.drone_spotlight_detection_parameters[ "hard" ][ "dot_crouch" ] = 0.7;
	self.drone_spotlight_detection_parameters[ "hard" ][ "dot_exposed" ] = 0.5;
	self.drone_spotlight_detection_parameters[ "hard" ][ "time_to_detect" ] = 0.9;
	
	// veteran settings
	self.drone_spotlight_detection_parameters[ "fu" ][ "dot_prone" ] = 0.75;
	self.drone_spotlight_detection_parameters[ "fu" ][ "dot_crouch" ] = 0.7;
	self.drone_spotlight_detection_parameters[ "fu" ][ "dot_exposed" ] = 0.4;
	self.drone_spotlight_detection_parameters[ "fu" ][ "time_to_detect" ] = 0.85;
}

#define DRONE_TURRET_INDEX_LEFT 1
#define DRONE_TURRET_INDEX_RIGHT 2
player_detected_logic()
{
	self endon( "death" );
	
	b_has_fired = false;
	
	while ( true )
	{
		level waittill( "drone_detects_player", str_deadquote );
	
		b_should_aim_at_player = ( !IsGodMode( level.player ) && !b_has_fired );
		
		if ( b_should_aim_at_player )
		{
			level.player notify( "scripted_stealth_break" );  // force stealth break if it's active
			b_has_fired = true;  // running multiple instances of this will cause turrets to not fire at the correct time
			flag_set( "drone_attacks_player" );  // kill 'stealth' watcher threads
			screen_message_delete();  // kill prompt if it exists
			level thread maps\pakistan_anim::vo_avoid_spotlight_detected();
			self SetSpeed( 0 );  // TODO: decide on best way to fly drone to firing range, but not look dumb. avoidance nodes?
			self SetLookAtEnt( level.player );  // force physical redirect of drone body
			self thread maps\_turret::set_turret_target( level.player, undefined, DRONE_SPOTLIGHT_TURRET );  // set turret to look at player
			self thread maps\_turret::shoot_turret_at_target( level.player, -1, ( 0, 0, 0 ), DRONE_SPOTLIGHT_TURRET );  
			self thread maps\_turret::shoot_turret_at_target( level.player, -1, ( 0, 0, 0 ), DRONE_TURRET_INDEX_LEFT ); 
			self thread maps\_turret::shoot_turret_at_target( level.player, -1, ( 0, 0, 0 ), DRONE_TURRET_INDEX_RIGHT ); 

			SetDvar( "ui_deadquote", str_deadquote );
		}
	}
}

sewer_exterior()
{
	autosave_by_name( "pakistan_sewer_exterior" );
	level thread vo_sideways_building();
	level thread sewer_exterior_ai_setup();
	
	if ( !flag( "_stealth_spotted" ) )
	{
		level.player thread maps\_stealth_logic::stealth_ai();
	}
	
	trigger_wait( "sewer_guard_spawn_trigger" );
	a_sewer_guard_spawners = get_ent_array( "sewer_guard_spawners", "script_noteworthy" );
	simple_spawn( a_sewer_guard_spawners );
	level thread vo_sideways_building_stealth();
	
	level thread stealth_break_logic();
	
	trigger_wait( "sewer_exterior_start" );
	
	flag_wait( "sewer_entrance_clear" );  // can be set by getting to sewer undetected (on trigger), or clearing guards
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	if ( flag( "_stealth_spotted" ) )
	{
		
		ai_harper maps\_dialog::say_dialog( "harp_area_clear_0" );  // Area clear.
		ai_harper maps\_dialog::say_dialog( "sect_ready_when_you_are_0" ); // Ready when you are.
	}
	else 
	{
		ai_harper maps\_dialog::say_dialog( "harp_we_re_clear_move_u_0" );  //We're clear.  Move up.
		ai_harper maps\_dialog::say_dialog( "harp_let_s_get_to_anthem_0" );  //Let's get to Anthem before anyone else finds us.
	}
	
	sewer_gate_clip_setup();
	maps\_scene::run_scene( "sewer_entry" );
}

sewer_gate_clip_setup()
{
	bm_gate_clip = get_ent( "sewer_gate_clip", "targetname", true );
	m_gate = get_ent( "sewer_entry_gate", "targetname", true );
	
	bm_gate_clip LinkTo( m_gate, "j_hinge" );
}

stealth_break_logic()
{
	flag_wait( "_stealth_spotted" );
	
	t_no_kill = get_ent( "sewer_entrance_no_kill_trigger", "targetname" );
	
	if ( IsDefined( t_no_kill ) )
	{
		t_no_kill Delete();
	}
}

drone_flies_over_bank()
{
	vh_helicopter = get_ent( "drone_helicopter", "targetname" );
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	if ( !IsDefined( vh_helicopter ) )
	{
		vh_helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "drone_helicopter" );
	}	

	vh_helicopter SetHoverParams( 30 );
	vh_helicopter.drivepath = 0;
	
	nd_bank_look_in = GetVehicleNode( "drone_looks_in_bank", "targetname" );
	
	debug_print_line("helicopter flies over bank" );
	
	vh_helicopter thread go_path( nd_bank_look_in );
	vh_helicopter thread drone_set_lookat_ent( "drone_bank_focus", 3 );
	
	if ( !flag( "sideways_building_harper_climb_done" ) )
	{
	   	ai_harper notify( "goal" ); // force teleport from reach to not break event scripting; harper will ALWAYS be reaching by this point
	}
	
	ai_harper thread maps\_dialog::say_dialog( "harp_shit_this_building_0" ); // Shit, this building's occupied! Get down!
	
	wait 3;  // hold at this spot
	
	ai_harper thread maps\_dialog::say_dialog( "harp_stay_low_it_should_0" ); // Don't move. It'll fly right by us.
	
	nd_bank_flyover = GetVehicleNode( "drone_flyover_bank_path", "targetname" );
	vh_helicopter.drivepath = 1;
	vh_helicopter thread go_path( nd_bank_flyover );
	vh_helicopter thread drone_set_lookat_ent( "drone_bank_focus_interior", 15 );
	vh_helicopter thread player_detection_logic();
	//vh_helicopter ent_flag_set( "start_spotlight_search" );  // removed fail condition
	level thread notify_delay( "harper_bank_change_cover_position", 3 );
	
	vh_helicopter waittill( "reached_end_node" );
	
	wait 1;
	
	debug_print_line("drone leaving" );
	nd_bank_exit = GetVehicleNode( "drone_bank_exit_start", "targetname" );
	vh_helicopter thread go_path( nd_bank_exit );	
	
	ai_harper say_dialog( "harp_looks_like_the_drone_0" );//Looks like the drone is gone.
	ai_harper thread maps\_dialog::say_dialog( "harp_there_s_a_guard_in_t_0" ); // There's a guard in that window. Probably more nearby.
	//ai_harper thread _kill_guard_stealth_vo();
	
	level thread notify_delay( "harper_bank_exit_cover", 2 );
}

_kill_guard_stealth_vo()
{
	level endon( "_stealth_spotted" );
	
	ai_guard = get_ent( "sewer_overwatch_ai", "targetname" );
	
	if ( IsDefined( ai_guard ) )
	{
		ai_guard waittill( "death" );
		
		self say_dialog( "harp_smart_move_i_see_mo_0" ); // Smart move. I see more up ahead.
	}
}

sewer_exterior_ai_setup()
{
	ai_harper = init_hero( "harper" );
	ai_harper thread sewer_exterior_harper_movement();
	
	sp_patroller_1 = get_ent( "sewer_guard_patroller_1", "targetname", true );
	sp_patroller_1 add_spawn_function( ::patrol_sewer, "sewer_patroller_1_loop_start" );
	
//	sp_patroller_2 = get_ent( "sewer_guard_patroller_2", "targetname", true );
//	sp_patroller_2 add_spawn_function( ::patrol_sewer, "sewer_patroller_2_loop_start" );

	sp_patroller_3 = get_ent( "sewer_guard_patroller_3", "targetname", true );
	sp_patroller_3 add_spawn_function( ::patrol_sewer, "sewer_patroller_3_loop_start" );
	
	add_spawn_function_veh( "sewer_guard_spotlight", ::sewer_guard_spotlight_logic );
	maps\_vehicle::spawn_vehicles_from_targetname( "sewer_guard_spotlight" );
	
	add_spawn_function_ai_group( "sewer_guards", ::sewer_guard_logic );
	add_spawn_function_group( "bank_patroller", "targetname", ::rush_on_stealth_break );
	add_spawn_function_group( "bank_patroller", "targetname", ::change_movemode, "cqb_walk" );
	
	waittill_ai_group_cleared( "sewer_guards" );
	flag_set( "sewer_entrance_clear" );
	
	// trigger Harper to move up if the player hasn't entered water outside sewer
	t_moveup = get_ent( "sewer_exterior_start", "targetname" );
	if ( IsDefined( t_moveup ) )
	{
		t_moveup notify( "trigger" );
	}
}

// the fallen building doesn't have a ton of spots for cover, so force rush after stealth break to prevent non-prog
rush_on_stealth_break()  // self = AI
{
	self endon( "death" );
	
	flag_wait( "_stealth_spotted" );
	
	wait RandomFloatRange( 3, 8 );
	
	self maps\_rusher::rush();
}

sewer_guard_spotlight_logic()
{
	self endon( "death" );
	
	const SEARCHLIGHT_TURRET_INDEX = 0;
	SEARCHLIGHT_TURRET_TAG = "tag_flash";
	
	s_right = get_ent( "sewer_guard_spotlight_target", "targetname", true );
	s_left = get_ent( s_right.target, "targetname", true );
	
	// add spotlight fx
	self play_fx( "helicopter_drone_spotlight_cheap", self GetTagOrigin( SEARCHLIGHT_TURRET_TAG ), self GetTagAngles( SEARCHLIGHT_TURRET_TAG ), "death", true, SEARCHLIGHT_TURRET_TAG );
	
	//self ent_flag_init( "can_see_player" );  // TODO: add spotlight user?
	self maps\_turret::set_turret_target( s_right, ( 0, 0, 0 ), SEARCHLIGHT_TURRET_INDEX );
}


patrol_sewer( str_name )
{
	self endon( "death" );

	self.disable_melee = true;		
	flag_wait( "player_can_see_sewer" );
	debug_print_line("patrol starting" );
	self thread maps\_patrol::patrol( str_name );
	
	level waittill( "_stealth_spotted" );
	
	self set_goalradius( 1024 );
}

sewer_guard_logic()  // self = AI
{
	self endon( "death" );

	self.disable_melee = true;	// disable contextual melee
	self disable_long_death();
	
	if ( !flag( "_stealth_spotted" ) )  // if stealth hasn't been broken, thread stealth logic
	{
		self set_ignoreme( true );  // set so Harper doesn't fire at me
		self thread maps\_stealth_logic::stealth_ai();
	}
		
	flag_wait( "_stealth_spotted" );
	
	self set_ignoreme( false );
	self change_movemode( "cqb" );
	self set_goalradius( 1024 );
}

sewer_exterior_harper_movement()
{	
	self change_movemode( "cqb" );
	
	self thread sewer_exterior_harper_movement_complete();
	
	if ( !flag( "_stealth_spotted" ) )
	{
		self set_ignoreme( true );  // patrollers shouldn't see him or fire at him; base only on player
	}
	
	level endon( "_stealth_spotted" );
	
	nd_entry = GetNode( "harper_bank_entry_node", "targetname" );
	self set_goal_node( nd_entry );
	
	trigger_wait( "harper_idle_for_climb" );
	
	nd_cover_patrol = GetNode( "harper_bank_cover_patrol", "targetname" );
	self set_goal_node( nd_cover_patrol );
	
	squad_waits_for_patrol_to_pass();
	
	nd_cover_patrol_passed = GetNode( "harper_bank_cover_patrol_moveup", "targetname" );
	self set_goal_node( nd_cover_patrol_passed );
	
	flag_wait( "player_leaving_bank" );
	
	nd_cover_sewer_dropdown = GetNode( "harper_bank_cover_water", "targetname" );
	self set_goal_node( nd_cover_sewer_dropdown );
}

squad_waits_for_patrol_to_pass()
{
	level endon( "_stealth_spotted" );
	
	t_passed_squad = get_ent( "bank_patroller_passes_player_trigger", "targetname", true );
	
	flag_wait( "sewer_guards_spawned" );  // set on trigger
	wait 0.25; // wait for all AI to spawn in 
	
	a_patrollers = get_ent_array( "bank_patroller_ai", "targetname" );
	
	array_thread( a_patrollers, ::bank_patroller_passes_squad, t_passed_squad );  // function 
	
	array_wait( a_patrollers, "passed_squad" );
	debug_print_line( "bank_patrollers pass squad" );
}

bank_patroller_passes_squad( t_notify )
{
	self endon( "death" );
	
	b_hit_trigger = false;
	
	while ( !b_hit_trigger )
	{
		t_notify waittill( "trigger", e_triggered );
		
		if ( e_triggered == self )
		{
			self notify( "passed_squad" );
			b_hit_trigger = true;
		}
	}
}

sewer_exterior_harper_movement_complete()
{
	self clear_force_color();
	self thread _restore_color_on_stealth_break();
	
	flag_wait( "sewer_entry_done" );
	nd_sewer_interior = GetNode( "sewer_interior_harper_cover_initial", "targetname" );
	self set_goal_node( nd_sewer_interior );	
	self set_force_color( "r" );
}

_restore_color_on_stealth_break()  // self = Harper AI
{
	level endon( "sewer_entry_done" );
	
	flag_wait( "_stealth_spotted" );
	self set_force_color( "r" );
}

sewer_interior()
{
	autosave_by_name( "pakistan_sewer_interior" );
	sewer_interior_ai_setup();
	
	level thread maps\pakistan_anim::vo_sewer_interior();
	
	level thread perk_intruder_setup();
	
	trigger_wait( "section_1_ends_trigger" );
	level.player notify( "mission_finished" );
	level thread maps\_scene::run_scene( "sewer_exit" );
	level thread maps\pakistan_anim::vo_change_level();
	transition_to_section_2();
}

sewer_interior_ai_setup()
{
	ai_harper = init_hero( "harper" );
	ai_harper change_movemode( "cqb" );
}

perk_intruder_setup()
{
	t_logic_check = get_ent( "perk_intruder_logic_trigger", "targetname", true );
	t_perk_use = get_ent( "perk_intruder_trigger", "targetname", true );
	
	t_logic_check waittill( "trigger" );
	
	b_has_perk = level.player HasPerk( PERK_INTRUDER );
	
	if ( b_has_perk )
	{
		debug_print_line("player has intruder perk" );
		
		set_objective( level.OBJ_INTERACT_INTRUDER, t_perk_use, "interact" );
		
		t_perk_use waittill( "trigger" );
		set_objective( level.OBJ_INTERACT_INTRUDER, undefined, "done" );
		
		// link clip to door hinge
		bm_door_clip = get_ent( "sewer_intruder_perk_door", "targetname", true );
		m_door = get_ent( "intruder_perk_door", "targetname", true );
		bm_door_clip LinkTo( m_door, "hinge" );
		
		maps\_scene::run_scene( "perk_intruder_unlock" );
		
		simple_spawn( "intruder_guys" );
		flag_set( "intruder_perk_used" );
		level.player set_temp_stat( SOCT_HAS_BOOST, 1 );	// notify section 3 about perk unlock
		maps\pakistan_anim::vo_sewer_perk_dialog_exchange();
	}
	else 
	{
		debug_print_line("player does NOT have intruder perk" );
	}
	
	if ( IsDefined( t_logic_check ) )
	{
		t_logic_check Delete();
	}
	
	if ( IsDefined( t_perk_use ) )
	{
		t_perk_use Delete();
	}
}