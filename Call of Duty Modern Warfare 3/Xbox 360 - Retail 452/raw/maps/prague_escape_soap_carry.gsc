#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_shg_common;
#include maps\prague_escape_code;
#include maps\_utility_chetan;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_soap_carry()
{
	setup_hero_for_start( "soap", "soap_carry" );
	setup_hero_for_start( "price", "soap_carry" );	
	
	move_player_to_start( "start_soap_carry" );
	
	maps\_compass::setupMiniMap( "compass_map_prague_escape_sniper", "sniper_minimap_corner" );
	
	level.price place_weapon_on( "m4m203_reflex", "back" );
	level.price forceUseWeapon( "m4m203_reflex", "primary" );	
	
	maps\prague_escape_sniper::prague_escape_sniper_cleanup();
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
	
	wait(1);
}



// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
soap_carry_main()
{
	/#
	iprintln( "soap_carry" );
	#/	

	maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save
	
	soap_carry_event_setup();
	
	thread pick_up_soap();
	thread dumpster_fx();
	follow_price_through_street();
	soap_stop_cough_blood();
	price_grenade_wall();
	soap_set_down_at_dumpster();
	//prague_escape_soap_carry_cleanup();
	
	flag_wait( "event_soap_carry_done" );
}

init_event_flags()
{
	flag_init( "soap_picked_up" );
	flag_init( "soap_carry_death" );
	flag_init( "pause_soap_carry" );
	flag_init( "clear_path_loop_started" );
	flag_init( "soap_set_down" );
	flag_init( "event_soap_carry_done" );
	flag_init( "player_inside_apt_building" );
	flag_init( "clear_path_dialogue_2" );
	flag_init( "soap_carry_pickup_dialogue_2" );
	flag_init( "soap_carry_cough_throw_smoke" );
	flag_init( "soap_carry_cough_stop_dialogue_2" );
	flag_init( "soap_carry_cough_stop_dialogue_3" );
	flag_init( "soap_carry_cough_stop_dialogue_4" );	
	flag_init( "queue_player_carry_music" );
}

dumpster_fx()
{
	flag_wait( "dumpster_go" );
	struct = getstruct("paper_fx", "targetname" );
	wait(4.6);
	playfx( getfx( "paper_fx"), struct.origin );	
}	

soap_carry_event_setup()
{
	battlechatter_on( "axis" );
	
	m_wall = GetEnt( "fxanim_exit_wall", "targetname" );
	s_wall_moveto = getstruct( "exit_wall_struct", "targetname" );
	
	SetSavedDvar( "cg_drawCrosshair", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	setsaveddvar( "ui_hideMap", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "actionSlotsHide", "0" );		
	
	m_wall MoveTo( s_wall_moveto.origin, 0.05 );
	
	level.price set_ignoreme( false );
	
	level.price.grenadeammo = 0;
    // level.price.baseaccuracy = 1000;
    level.price.aggressivemode = true;
    level.price.badplaceawareness = 0;
    level.price.dontavoidplayer = true;
    
    level.price disable_careful();
    level.price disable_danger_react();
    level.price disable_pain();
    level.price disable_surprise();
    level.price disable_bulletwhizbyreaction();
    level.price set_ignoreSuppression( true );
	
	level.soap set_ignoreme( true );
	
	trigger_off( "soap_carry_after_smoke_trig", "targetname" );
	
	a_spawners = GetEntArray( "soap_carry_plaza_enemy", "script_noteworthy" );
	array_spawn_function( a_spawners, ::soap_carry_plaza_spawnfunc );
	
	a_spawners = GetEntArray( "soap_carry_starting_guys", "script_noteworthy" );
	array_spawn_function( a_spawners, ::soap_carry_starters_spawnfunc );
	
	damage_trigs = GetEntArray( "soap_carry_damage_trig", "targetname" );
	after_smoke_trig = GetEnt( "soap_carry_after_smoke_trig", "targetname" );
	damage_trigs = array_add( damage_trigs, after_smoke_trig );
	array_thread( damage_trigs, ::soap_carry_damage_trig_think );
	
	a_grenade_trigs = GetEntArray( "soap_carry_grenade_death_trig", "targetname" );
	array_thread( a_grenade_trigs, ::soap_carry_grenade_damage_trig_think );
	
	kill_trigs = GetEntArray( "soap_carry_death_trig", "targetname" );
	array_thread( kill_trigs, ::soap_carry_kill_trig_think );
	
	veh_suv = getent( "soap_carry_suv_flip", "targetname" );
	veh_suv.maxhealth = veh_suv.maxhealth * 10;
	veh_suv.health = veh_suv.maxhealth;
	
	// activate_trigger_with_targetname( "soap_carry_starting_guys" );
	activate_trigger_with_targetname( "soap_carry_begin_price" );
	
	a_m_dest = GetEntArray( "apt_wall_destroyed", "targetname" );
	foreach( m_dest in a_m_dest )
	{
		m_dest Hide();
	}
	
	m_wall = getent( "fxanim_rpg_wall", "targetname" );
	m_wall Hide();
	
	m_rpg_wall_destroyed = getentarray( "esc_wall_clean_01", "targetname" );
	foreach( m_wall_piece in m_rpg_wall_destroyed )
	{
		m_wall_piece Hide();
	}

	a_glass_break_trigs = GetEntArray( "soap_carry_glass_break_trig", "targetname" );
	array_thread( a_glass_break_trigs, ::glass_break_trig_think );
	
	m_blocker_clip = getent( "apt_wall_collapse_clip", "targetname" );
	m_blocker_clip ConnectPaths();
	
	m_blocker_clip trigger_off();
	
	a_backtrack_blocker = getentarray( "apt_wall_collapse", "targetname" );
	foreach( m_blocker in a_backtrack_blocker )
	{
		m_blocker Hide();
	}
}

soap_carry_plaza_spawnfunc()
{
	self.grenadeammo = 0;
	self waittill ( "goal" );	
	self bloody_death();
}

soap_carry_starters_spawnfunc()
{
	self.grenadeammo = 0;
	flag_wait( "soap_picked_up" );
	self bloody_death();
}

glass_break_trig_think()
{
	self waittill( "trigger" );
	
	a_break_structs = getstructarray( self.script_noteworthy, "targetname" );
	foreach( s_breaker in a_break_structs )
	{
		RadiusDamage( s_breaker.origin, 32, 100, 100 );
		wait RandomFloatRange( .5, 1 );
	}
}

pick_up_soap()
{
	level thread no_nades_for_baddies();
	e_align = Spawn( "script_origin", level.soap.origin );
	e_align.angles = level.soap.angles;
	
	e_align thread anim_loop_solo( level.soap, "soap_carry_prone_soap" );
	
	level.player EnableInvulnerability();
	if( !isdefined( level.player.m_player_rig ) )
	{
		m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
		m_player_rig.angles = level.player GetPlayerAngles();
		level.player.m_player_rig = m_player_rig;
	}
	else
	{
		m_player_rig = level.player.m_player_rig;
	}
	
	level.soap dontcastshadows();
	e_align anim_first_frame_solo( m_player_rig, "soap_carry_pickup" );
	m_player_rig Hide();
	
	n_lerp_time = .25;
	
	level.player FreezeControls( true );
	level.player PlayerLinkToBlend( m_player_rig, "tag_player", n_lerp_time, n_lerp_time * 0.25, n_lerp_time * 0.25 );
	wait n_lerp_time;	

	//level.player PlayerLinkToAbsolute( m_player_rig, "tag_player" );
	level.player PlayerLinkToDelta( m_player_rig, "tag_player", 1, 0, 0, 20, 0, true );
	m_player_rig Show();
	
	pickup_trig = getent( "soap_carry_pickup_soap", "targetname" );
	pickup_trig SetHintString( &"PRAGUE_ESCAPE_HINT_PICKUP_SOAP" );
	
	level thread soap_carry_death_listener();
	level thread pick_up_soap_timer();
	level.player DisableInvulnerability();
	
	level thread soap_carry_pickup_dialogue();
	flag_set( "queue_player_carry_music" );
	
	pickup_trig waittill( "trigger" );	
	pickup_trig Delete();
	
	price_blocker = getent( "scaffold_price_blocker", "targetname" );
	price_blocker Delete();
	
	e_align notify ( "stop_loop" );
	flag_set( "soap_picked_up" );
	level.player thread pick_up_soap_rumble();
	a_anim_ents = make_array( level.soap, m_player_rig );
	e_align anim_single( a_anim_ents, "soap_carry_pickup" );
	
	level.player allowCrouch( false );
	level.player allowProne( false );
	level.player AllowSprint( false );
	level.player AllowAds( false );
	
	level thread carry_soap();
	level thread wait_for_apt_enter();
	
	level thread randomly_damage_player_in_street();
	//flag_set( "queue_player_carry_music" );
	
	
	// level.price dialogue_queue( "presc_pri_havetomove" );
}

no_nades_for_baddies()
{
	axis = getaiarray( "axis" );
	foreach(guy in axis)
	{
		guy.grenadeammo = 0;
	}	
}	

soap_carry_death_listener()
{
	level endon( "soap_set_down" );
	level.player thread flag_on_death( "soap_carry_death" );
	
	flag_wait( "soap_carry_death" );
	
	flag_set( "pause_soap_carry" );
	level.soap Hide();
	level.player Unlink();
	
}

pick_up_soap_rumble()
{
	wait( 2.5 );
	self PlayRumbleOnEntity( "damage_heavy" );
	PlayFXOnTag( level._effect["dust_fall_soap_chest"], level.soap, "J_Spine4" );
	wait( 2 );
	self PlayRumbleOnEntity( "damage_heavy" );
	PlayFXOnTag( level._effect["dust_fall_soap_chest"], level.soap, "J_Spine4" );
}

pick_up_soap_timer()
{
	level endon ( "soap_picked_up" );
	n_grace_time = 5;	
	
	n_frequency_increase = .5;
	n_initial_delay = 2;
	n_current_delay = n_initial_delay;
	
	wait ( n_grace_time );
	
	thread kill_in_time( 3 );
	
	while ( true )
	{
		soap_carry_shoot_player_magically();
		wait ( n_current_delay );
		
		n_current_delay -= n_frequency_increase;
		if ( n_current_delay < n_frequency_increase )
		{
			n_current_delay = n_frequency_increase;	
		}
	}
}

kill_in_time( n_time )
{
	wait n_time;

	//MagicGrenade( "fraggrenade", level.player.m_player_rig.origin + (0, 64, 64 ), level.player.m_player_rig.origin + (0, 32, 32 ), 2 );
	SetDvar( "ui_deadquote", &"PRAGUE_ESCAPE_PROTECT_FAIL" );	
	level thread missionFailedWrapper();
	
}

randomly_damage_player_in_street()
{
	level endon ( "smoke_grenade_toss" );
	
	while (true )
	{
		wait( 7 );
		if( level.player.health == level.player.maxhealth )
		{
			soap_carry_shoot_player_magically();
		}
	}
}

soap_carry_shoot_player_magically()
{
	e_target = getent( "soap_carry_fire_backup", "targetname" );
	MagicBullet( "ak47", e_target.origin, level.player.origin + ( 0, 0, 32 ) );	
	
}

carry_soap()
{
	// level endon ( "soap_set_down" );
	level.is_soap_carry_done = false;
	
	n_movement_speed = 155;
	v_height_offset = (0, 0, 16);
	v_rotate_speed = (0, 5, 0 );
	v_up = (0, 0, 1);
	n_current_strength = -50;
	is_moving = false;
	
	if( !isdefined( level.player.m_player_rig ) )
	{
		m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
		m_player_rig.angles = level.player GetPlayerAngles();
		level.player.m_player_rig = m_player_rig;
		level.player PlayerLinkToDelta( m_player_rig, "tag_player", .5, 0, 0, 20, 0 );
	}
	else
	{
		m_player_rig = level.player.m_player_rig;
	}
	
	level.m_player_spot = Spawn( "script_model", m_player_rig.origin );
	level.m_player_spot SetModel( "tag_origin" );	
	level.m_player_spot.angles = m_player_rig.angles;	 	
	
	level.soap LinkTo( m_player_rig, "tag_origin" );
	m_player_rig LinkTo( level.m_player_spot, "tag_origin" );
	
	a_normalized_movement = level.player GetNormalizedMovement();
	n_movement_strength = Length( a_normalized_movement ); 	
	
	if( n_movement_strength == 0 )
	{
		level.m_player_spot thread anim_loop_solo( m_player_rig, "soap_carry_idle" );
		m_player_rig thread anim_loop_solo( level.soap, "soap_carry_idle" );
	}
	
	level.m_carry_rig = m_player_rig; 
	
	level thread watch_distance_from_price();
	level.n_obj_follow = prague_objective_add_on_ai( level.price, &"PRAGUE_ESCAPE_FOLLOW_PRICE" );
	
	a_rig_and_soap = make_array( m_player_rig, level.soap );
	
	while ( !level.is_soap_carry_done )
	{
		if( flag( "pause_soap_carry" ) )
		{
			wait (0.05 );
			continue;	
		}
		
		a_normalized_movement = level.player GetNormalizedMovement();
	
		n_movement_strength = Length( a_normalized_movement ); 
        
        rig_angles = m_player_rig.angles;
        forward = AnglesToForward( rig_angles );
        right = AnglesToRight( rig_angles );
        
        speed_forward = n_movement_speed * a_normalized_movement[0];
        speed_right = n_movement_speed * a_normalized_movement[1];
        movement_vector = forward * speed_forward + right * speed_right;
		
		// Translation
        if( n_movement_strength > 0 )
        {       	
        	if( !is_moving )
        	{
        		level.m_player_spot notify ( "stop_loop" );
        		m_player_rig notify ( "stop_loop" );
				level.m_player_spot thread anim_loop_solo( m_player_rig, "soap_carry_run" );
				m_player_rig thread anim_loop_solo( level.soap, "soap_carry_run" );        		
        	}

       		array_thread( a_rig_and_soap, ::soap_carry_set_rate, "soap_carry_run", n_movement_strength );
			
        	is_moving = true;
        	
        	v_velocity = movement_vector;
        	v_collision_velocity = movement_vector * 0.2;
        	v_projected_spot = level.m_player_spot.origin + v_collision_velocity;
        	v_soap_projected_spot = level.soap.origin + v_collision_velocity;
        	
        	trace_start = level.m_player_spot.origin + v_height_offset;
        	trace_end = v_projected_spot + v_height_offset;
        	
        	// thread draw_line_for_time( trace_start, trace_end, 1, 1, 1, 0.05 );
        	
        	// collision detection
        	v_forward_trace = PlayerPhysicsTrace( trace_start, trace_end );
        	
        	// Player collided with an object, calculate slide
        	v_final_spot = undefined;
        	if ( v_forward_trace != trace_end )
        	{
        		// thread draw_line_for_time( trace_start, trace_start + VectorNormalize( v_velocity ) * ( v_velocity * a_forward_trace["fraction"] ), 1, 0, 0, 0.05 );
								
				a_forward_trace = BulletTrace( trace_start, trace_end, false, m_player_rig );
				if( a_forward_trace["position"] == trace_end )
				{
					v_movement = v_forward_trace - trace_start;
					// find the vector perpendicular to the movement vector
					v_movement_perp = VectorCross( VectorNormalize( v_movement ), v_up );
					v_movement_perp_inverse = v_movement_perp *-1;
					a_movement_perp_trace = BulletTrace( v_forward_trace, v_forward_trace + (v_movement_perp * speed_forward), false, m_player_rig );
					a_movement_perp_inverse_trace = BulletTrace( v_forward_trace, v_forward_trace + (v_movement_perp_inverse * speed_forward), false, m_player_rig );
	        		
					a_forward_trace = a_movement_perp_trace;
					if( a_movement_perp_trace[ "fraction" ] > a_movement_perp_inverse_trace[ "fraction" ] )
					{
						a_forward_trace = a_movement_perp_inverse_trace;	
					}
				}
				
        		// negates the movement into the wall
        		v_collision_normal = a_forward_trace["normal"];
        		n_projection = 1- a_forward_trace["fraction"]; // abs( VectorDot( VectorNormalize(v_velocity), v_collision_normal ) );
        		v_velocity += ( v_collision_normal * ( n_movement_speed ));
        		
        		// Find the vector parallel to the collision surface
        		v_collision_parallel = VectorCross( VectorNormalize( v_collision_normal ), v_up );
        		v_collision_to_player = VectorNormalize( v_forward_trace - level.player.origin );
        		n_parallel_dot = VectorDot( v_collision_parallel, v_collision_to_player );
        		
        		if( n_parallel_dot < 0 )
        		{
        			v_collision_parallel *= -1;	
        		}
        		
        		v_velocity += (v_collision_parallel * ( n_projection * abs(n_parallel_dot) ) );
        	}
        	
        	v_soap_spot = level.m_player_spot.origin + ( (VectorNormalize(right) * -1) * 8 );
    		v_final_spot = PlayerPhysicsTrace( level.m_player_spot.origin + v_height_offset, ( level.m_player_spot.origin + ( v_velocity * 0.05 ) ) + v_height_offset );
    		v_final_soap_spot = v_soap_spot + ( VectorNormalize(v_velocity) * 16 ) + v_height_offset;
    		v_final_soap_trace = PlayerPhysicsTrace( v_soap_spot + v_height_offset, v_final_soap_spot );
    		
    		// if soap hit something but the player didn't, shorten the player's movement to the same length
    		if( v_final_soap_spot != v_final_soap_trace )
    		{
    			v_final_spot = level.m_player_spot.origin;
    		}
    			
    		ground_trace = GetGroundPosition( v_final_spot + v_height_offset, 2 );
        	
    		v_final_spot = ( v_final_spot[0], v_final_spot[1], ground_trace[2] );
    		
    		// price collision
    		n_to_price = DistanceSquared( v_final_spot, level.price.origin );
    		if( n_to_price > ( 16 * 16 ) )
    		{
    			level.m_player_spot.origin = v_final_spot;
    		}
        	
        }
        else
        {
        	if ( is_moving )
        	{
				level.m_player_spot notify( "stop_loop" );
				m_player_rig notify( "stop_loop" );
				level.m_player_spot thread anim_loop_solo( m_player_rig, "soap_carry_idle" );
				m_player_rig thread anim_loop_solo( level.soap, "soap_carry_idle" );        	        		
        	}
        	
        	is_moving = false;
        }
 
        a_normalized_rotation = level.player GetNormalizedCameraMovement();
   
	    // Rotation
	    if ( a_normalized_rotation[1] >= 0.2 )
	    {
	    	// Soap rotation checks
	        
	        v_rotate_vel = v_rotate_speed * a_normalized_rotation[1];
	        v_soap_spot = level.m_player_spot.origin + ( (VectorNormalize(right) * -1) * 16 );
	        v_rotate_radius = v_soap_spot - level.m_player_spot.origin;
	        v_rotation_movement = v_rotate_vel + ( VectorCross( v_rotate_radius, v_up ) );
	        v_rotation_point = v_soap_spot + v_rotation_movement;
	        v_final_soap_rotation = PlayerPhysicsTrace( v_soap_spot + v_height_offset, v_rotation_point + v_height_offset );
	    	
	        if( (v_rotation_point + v_height_offset) == v_final_soap_rotation )
	        {
	        	v_final_angles = level.m_player_spot.angles - ( v_rotate_speed * abs(a_normalized_rotation[1] ) );
	        	level.m_player_spot RotateTo( v_final_angles, 0.05 );
	        }
	    }
	    else if ( a_normalized_rotation[1] <= -0.2 )
	    {
	    	// Soap rotation checks
	        
	        v_rotate_vel = v_rotate_speed * a_normalized_rotation[1];
	        v_soap_spot = level.m_player_spot.origin + ( (VectorNormalize(right) * -1) * 16 );
	        v_rotate_radius = v_soap_spot - level.m_player_spot.origin;
	        v_rotation_movement = v_rotate_vel + ( VectorCross( v_rotate_radius, v_up ) );
	        v_rotation_point = v_soap_spot + v_rotation_movement;
	        v_final_soap_rotation = PlayerPhysicsTrace( v_soap_spot + v_height_offset, v_rotation_point + v_height_offset );
	    	
	        if( (v_rotation_point + v_height_offset) == v_final_soap_rotation )
	        {	        	
	        	v_final_angles = level.m_player_spot.angles + ( v_rotate_speed * abs(a_normalized_rotation[1] ) );
	        	level.m_player_spot RotateTo( v_final_angles, 0.05 ); 
	        }
	    }        	
      
        
        wait ( .05 );
	}
	
	level.m_player_spot notify ( "stop_loop" );
	level.m_carry_rig notify ( "stop_loop" );	
	level.m_carry_rig Delete();
	level.m_player_spot delete();		
}

soap_carry_set_rate( anime, n_rate )
{	
	self SetFlaggedAnim( "looping anim", level.scr_anim[ self.animname ][anime][0], 1, 0, n_rate );
}



watch_distance_from_price()
{
	level endon ( "soap_cough_done" );
	level.player thread player_god_while_moving();
	n_max_distance = 1000;
	n_current_accuracy = 0;
	n_max_distance_sq = n_max_distance * n_max_distance;
	
	while ( true )
	{
		n_to_price_dist = DistanceSquared( level.player.origin, level.price.origin );
		if ( n_to_price_dist > n_max_distance_sq )
		{
			if ( n_current_accuracy < 1.0 )
			{
				n_current_accuracy += 0.1;
				 //IPrintLn( "increasing accuracy" );
			}
			
			// a_enemy_ai = get_ai_group_ai( "soap_carry_enemy" );
			
			a_enemy_ai = GetAIArray( "axis" );
			array_thread( a_enemy_ai, ::set_baseaccuracy, n_current_accuracy );
			
			soap_carry_player_randomly_shot();
		}
		else if ( n_current_accuracy > 0 )
		{
			 //IPrintLn( "decreasing accuracy" );
			n_current_accuracy -= 0.2;
			
			if ( n_current_accuracy < 0 )
			{
				n_current_accuracy = 0;	
			}
			
			a_enemy_ai = get_ai_group_ai( "soap_carry_enemy" );
			array_thread( a_enemy_ai, ::set_baseaccuracy, n_current_accuracy );
		}
			
		wait ( 1 );
	}
}

player_god_while_moving()
{	
	//dont want player dying from explosive cars
	level endon("soap_cough_done" );
	//level.player enabledeathshield(true);
	
	while(1)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );		
		if( isdefined( type ) && type == "MOD_EXPLOSIVE" )
		{
			self.health = self.health + damage;
		}	
	}			
}	

wait_for_apt_enter()
{
	trigger_wait_targetname( "inside_apt_building" );
	flag_set( "player_inside_apt_building" );
}

follow_price_through_street()
{
	flag_wait( "soap_picked_up" );
	
	// wait( 2.5 );
	
	level thread fake_grenade_explosion();

	level.price thread price_fire_controller();
	
	follow_price_cover_then_m203();
	level.price set_force_color( "b" );
	activate_trigger_with_targetname( "price_move_after_scaffold" );
	level.price AllowedStances( "stand" );
	
	follow_price_rpg();
}

fake_grenade_explosion()
{
	veh_car = getent( "soap_carry_rpg_car_target", "script_noteworthy" );
	veh_car destructible_force_explosion();
	
	wait( 1 );
	grenade_spot = getstruct( "soap_carry_fake_grenade", "targetname" );
	
	MagicGrenade( "fraggrenade", grenade_spot.origin + (0, 0, 8 ), grenade_spot.origin, .1 );
	PlayFX( level._effect[ "grenade_exp_concrete" ], grenade_spot.origin );
	
	trigger_wait_targetname( "rpg_player_whizby" );
	
	s_start_point = getstruct( "soap_carry_rpg_first_start", "targetname" );
	s_end_point = getstruct( "soap_carry_rpg_first_end", "targetname" );
	
	MagicBullet( "rpg_straight", s_start_point.origin, s_end_point.origin );
	wait( .75 );
}

price_fire_controller()
{
	a_trigs = GetEntArray( "soap_carry_spawn_trigger", "targetname" );
	array_thread( a_trigs, ::price_fire_set_targets );
	
	// soap_carry_price_target_4
//	n_group_count = 4;
//	
//	for ( i = 0; i < n_group_count; i++ )
//	{
//		str_ai_group = "soap_carry_price_target_" + ( i + 1 );
//
//		price_fire_set_targets( str_ai_group );
//		
//		// waittill_aigroupcleared( str_ai_group );	
//		// level notify ( "price_cleared_group" );
//	}		
}

price_fire_set_targets()
{	
	self waittill ( "trigger" );
	wait ( 1 );
	level.price disable_sprint();
	guy = GetEntArray( self.target, "targetname" )[0];
	if ( IsDefined( guy ) && IsDefined( guy.script_aigroup ) )
	{
		str_ai_group = guy.script_aigroup;
	}
	else
	{
		return;	
	}
	
	a_guys = get_ai_group_ai( str_ai_group );
	
	m_target_point = spawn( "script_model", level.player.origin );
	m_target_point SetModel( "tag_origin" );	
	
	// level.price thread just_keep_shooting();
	
	foreach ( e_guy in a_guys )
	{
		if ( IsAlive( e_guy ) )
		{
			m_target_point.origin = e_guy.origin + (0, 0, 36);
			m_target_point LinkTo( e_guy );
			
			// thread draw_line_for_time( level.price.origin, m_target_point.origin, 1, 0, 0, 3 );
			
			level.price SetEntityTarget( m_target_point );
			level.price Shoot( 0.7 );
			
			e_guy thread make_sure_dies( 2 );
			
			e_guy waittill ( "death" );
			
			m_target_point Unlink();
		}
	}
	
	level.price ClearEntityTarget();
	m_target_point Delete();
	level.price enable_sprint();
}

make_sure_dies( n_wait_time )
{
	wait n_wait_time;
	
	self bloody_death();
}

just_keep_shooting()
{
	level endon ( "smoke_grenade_toss" );
	
	while ( true )
	{
		n_wait = RandomFloatRange( .1, .3 );
		wait( n_wait );
		
		if (  IsDefined( self.target) && self CanShoot( self.target.origin ) )
		{
			self Shoot( 0.7 );
		}
	}
}

follow_price_cover_then_m203()
{
	s_price_align = getstruct( "align_price_throw_smoke", "targetname" );
	
	nd_align = GetNode( "anim_align_cover_then_m203", "targetname" );
	nd_align anim_reach_solo( level.price, "grenade_fire_a" );
	nd_align anim_single_solo( level.price, "grenade_fire_a" );
	
	s_price_align thread anim_reach_and_approach_solo( level.price, "soap_carry_cough_stop" );
	level.price SetGoalPos( s_price_align.origin );
}

follow_price_rpg()
{
	s_price_align = getstruct( "align_price_throw_smoke", "targetname" );
	
	trigger_wait_targetname( "soap_carry_rpg_fired" );
	
	s_start_point = getstruct( "soap_carry_rpg_start", "targetname" );
	s_end_point = getstruct( "soap_carry_rpg_end", "targetname" );
	
	wait( .5 );
	MagicBullet( "rpg_straight", s_start_point.origin, s_end_point.origin );
	wait ( .5 );
	
	m_wall = getent( "fxanim_rpg_wall", "targetname" );
	m_wall Show();
	m_wall UseAnimTree( level.scr_animtree[ "script_model" ] );
	m_wall.animname = "rpg_wall";
	m_wall thread anim_single_solo( m_wall, "rpg_wall_explode" );	
	exploder( 250 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	m_rpg_wall_destroyed = getentarray( "esc_wall_destroy_01", "targetname" );
	foreach( m_wall_piece in m_rpg_wall_destroyed )
	{
		m_wall_piece Hide();
	}
	
	m_rpg_wall_clean = getentarray( "esc_wall_clean_01", "targetname" );
	foreach( m_wall_piece in m_rpg_wall_clean )
	{
		m_wall_piece Show();
	}
	
	
	level.price anim_single_solo( level.price, "grenade_fire_b" );
	s_price_align thread anim_reach_and_approach_solo( level.price, "soap_carry_cough_stop" );
}

suv_flip()
{
	veh_suv = getent( "soap_carry_suv_flip", "targetname" );
	m_suv = spawn( "script_model", veh_suv.origin );
	m_suv.angles = veh_suv.angles;
	m_suv SetModel( veh_suv.model );
	veh_suv Hide();
	veh_suv Delete();
	
	PlayFX( level._effect[ "suv_explosion" ], m_suv.origin );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	level.player PlaySound( "scn_prague_suv_flip_exp" );
	
	m_suv.animname = "soap_carry_suv";
	m_suv UseAnimTree( level.scr_animtree[ "convoy_vehicle" ] );
	m_suv thread anim_single_solo( m_suv, "suv_flip" );	
	
}

soap_stop_cough_blood()
{ 
	s_price_align = getstruct( "align_price_throw_smoke", "targetname" );
	// soap_carry_cough_stop
	trigger_wait_targetname( "trig_price_throw_smoke" );
	// IPrintLn( "Soap coughs up blood" );
	level thread spawn_chopper();
	level notify ( "smoke_grenade_toss" );
	
	level thread smoke_grenade_explode();
	
	level.player FreezeControls( true );
	level.player EnableInvulnerability();
	level.player enablePlayerWeapons( false );
	wait( .05 );
	flag_set( "pause_soap_carry" );
	level.player Unlink();
	level.m_carry_rig Hide();
	
	level.m_cough_rig = spawn_anim_model( "player_rig", level.m_carry_rig.origin );
	level.m_cough_rig.angles = level.m_carry_rig.angles; // level.player GetPlayerAngles();	
	level.m_cough_rig.angles = level.m_player_spot.angles; //( 0, level.m_cough_rig.angles[1], level.m_cough_rig.angles[2] );
	level.m_cough_rig linkto( level.m_player_spot );
	level.m_cough_rig dontcastshadows();
	level.player PlayerLinkToDelta( level.m_cough_rig, "tag_player", 1, 10, 10, 10, 10 );
	
	
	level.m_cough_rig thread soap_cough_face_price();
	
	a_animents = make_array( level.soap, level.m_cough_rig );	
	level thread soap_cough_blood();
	level.m_player_spot anim_single( a_animents, "soap_carry_cough_stop" );
	level.m_player_spot.origin = level.m_cough_rig.origin;
	level.player unlink();
	level.m_cough_rig Delete();
	level.m_carry_rig Show();
	flag_clear( "pause_soap_carry" );
	level notify( "soap_cough_done" );
	
	level.player PlayerLinkToDelta( level.m_carry_rig, "tag_player", .5, 0, 0, 20, 0  ); 
	level.m_carry_rig notify ( "stop_loop" );
	level.m_carry_rig thread anim_loop_solo( level.soap, "soap_carry_idle" );
	level.player FreezeControls( false );
	level.player delaycall( 5, ::DisableInvulnerability );
	level.soap set_ignoreme( false );
	
	a_enemy_ai = GetAIArray( "axis" );
	array_thread( a_enemy_ai, ::set_baseaccuracy, 1 );
	
	level.player enabledeathshield(false);
	level.player.health = 100;
}

spawn_chopper()
{
	//level waittill("soap_cough_done");
	wait(2);
	level.cough_alley_chopper = spawn_vehicle_from_targetname_and_drive( "cough_alley_chopper" );
	wait(.10);
	level.cough_alley_chopper.health = level.cough_alley_chopper.health + 5000;
	level.cough_alley_chopper.target_offset = undefined;
	level.cough_alley_chopper thread alley_chopper_attack();
	level.cough_alley_chopper delaythread( 4, ::chopper_loudspeaker );
	level.cough_alley_chopper notify_delay( "stop_attacking", 9);
}	

alley_chopper_attack()
{
	self endon( "death" );	
	self endon ("stop_attacking");
	while(1)
	{
		chopper_fire_at_target();
		wait(1);
	}	

}

soap_cough_face_price()
{
	n_rotate_speed = .4;
	
	s_price_spot = getstruct( "align_price_lookat", "targetname" );
	trig_change_align = getent( "smoke_throw_change_align", "targetname" );
	if( level.player IsTouching( trig_change_align ) )
	{
		s_price_spot = getstruct( "align_price_lookat_2", "targetname" );
	}	
	
	v_player_to_spot = VectorNormalize( s_price_spot.origin - level.player.origin );
	v_player_forward = VectorNormalize( AnglesToForward( self.angles ) );
	
	n_player_dot = VectorDot( v_player_to_spot, v_player_forward );
	
	self RotateTo( VectorToAngles( v_player_to_spot ), n_rotate_speed );
	level.m_player_spot RotateTo( VectorToAngles( v_player_to_spot ), n_rotate_speed, n_rotate_speed *.25 );	// set the same angles for the rig, to be safe
}

soap_cough_blood()
{
	level.soap dialogue_queue( "presc_mct_fallpains" ); //pain..cough
	level.player PlayRumbleOnEntity( "damage_heavy" );
	wait ( 2 ); // TODO: change to notetrack
	level.player PlayRumbleOnEntity( "damage_light" );
	PlayFXOnTag( level._effect[ "blood_cough_heavy" ], level.soap, "tag_eye" );
	level.price delaythread( 2, ::dialogue_queue, "presc_pri_getoffroad" ); //enemy chopper we have to get off the road!
}

smoke_grenade_explode()
{
	flag_wait( "soap_carry_cough_throw_smoke" );
	
	smoke_grenade_left = spawn( "script_model", level.price GetTagOrigin( "tag_weapon_left" ) );
	smoke_grenade_left.angles = level.price GetTagAngles( "tag_weapon_left" );
	smoke_grenade_left SetModel( "weapon_us_smoke_grenade" );
	smoke_grenade_left LinkTo( level.price, "tag_weapon_left" );
	
	smoke_grenade_inhand = spawn( "script_model", level.price GetTagOrigin( "TAG_INHAND" ) );
	smoke_grenade_inhand.angles = level.price GetTagAngles( "TAG_INHAND" );
	smoke_grenade_inhand SetModel( "weapon_us_smoke_grenade" );
	smoke_grenade_inhand LinkTo( level.price, "TAG_INHAND" );
	
	m_smoke_right = spawn( "script_model", level.price GetTagOrigin( "TAG_INHAND" ) );
	m_smoke_right SetModel( "tag_origin" );
	m_smoke_right.angles = level.price GetTagAngles( "TAG_INHAND" );
	m_smoke_right linkto( level.price, "TAG_INHAND" );
	m_smoke_left = spawn( "script_model", level.price GetTagOrigin( "tag_weapon_left" ) );
	m_smoke_left SetModel( "tag_origin" );
	m_smoke_left.angles = level.price GetTagAngles( "tag_weapon_left" );
	m_smoke_left linkto( level.price, "tag_weapon_left" );
	
	PlayFXOnTag( level._effect[ "smoke_grenade_streamer" ], m_smoke_left, "tag_origin" );
	PlayFXOnTag( level._effect[ "smoke_grenade_streamer" ], m_smoke_right, "tag_origin" );
	
	a_smoke_structs = getstructarray( "soap_carry_smoke_grenade", "targetname" );
	
	level thread play_sound_in_space( "smokegrenade_explode_default", a_smoke_structs[1].origin );
	
	foreach( s_grenade in a_smoke_structs )
	{
		v_grenade_pos = s_grenade.origin;
		// MagicGrenade( "smoke_grenade_american", v_grenade_pos + (0, 0, 32), v_grenade_pos, 1 );
		PlayFX( level._effect["smoke_grenade_prague"], s_grenade.origin );
	}	
	
	wait( 1 );
	smoke_grenade_left Delete();
	smoke_grenade_inhand Delete();
	m_smoke_right Unlink();
	m_smoke_left Unlink();
	
	wait( 14 );
	trigger_on( "soap_carry_after_smoke_trig", "targetname" ); // start shooting the player, force them off the road
}

price_grenade_wall()
{
	thread blood_drip_decals();
	thread blood_pool_decals();
	
	trigger_wait_targetname( "trig_price_blows_hole_in_wall" );
	
	flag_wait( "clear_path_loop_started" );
	
//	level.player PlaySound( "scn_prague_blowout_wall_exp" );
	
	s_align = getstruct( "anim_align_wall_breach", "targetname" );
	s_align notify ( "stop_loop" );
	s_align anim_single_solo( level.price, "clear_path_out" );
	level.price set_force_color( "b" );
	level.price enable_cqbwalk( true );
}

soap_set_down_at_dumpster()
{
	maps\_compass::setupMiniMap( "compass_map_prague_escape_escort", "escort_minimap_corner" );
	
	trigger_wait_targetname( "trig_set_down_soap" );
	
	level thread prague_escape_soap_carry_cleanup();
	
	flag_set( "FLAG_soap_blood_fx" );
	thread soap_walk_blood_drip_elbow_fx();
	thread soap_walk_blood_drip_hip_fx();
	thread soap_walk_blood_smear_fx( "right" );
	thread soap_walk_blood_smear_fx( "left" );
	
	maps\_autosave::_autosave_game_now_nochecks(); // TEMP
	e_obj_point = getent( "obj_set_down_soap", "targetname" );
	
	Objective_Position( level.objective_iterator, e_obj_point.origin );
	// n_objective = prague_objective_add( &"PRAGUE_ESCAPE_SET_SOAP_DOWN", true, true, e_obj_point.origin );
	Objective_SetPointerTextOverride( level.objective_iterator, &"PRAGUE_ESCAPE_SET_DOWN" );
		
	level.soap dialogue_queue( "presc_mct_putmedown" );
	
	musicstop(7);
	
	t_setdown = GetEnt( "dumpster_set_down_soap", "targetname" );
	b_set_down = false;
	// wait for player to touch trigger and be facing the set down point
	while( !b_set_down )
	{
		if( level.player IsTouching( t_setdown ) )
		{
			v_player_angles = level.player GetPlayerAngles();
			v_player_forward = VectorNormalize( AnglesToForward( v_player_angles ) );
        	
			v_to_setdown = VectorNormalize( e_obj_point.origin - level.player.origin );
			
			if( VectorDot( v_player_forward, v_to_setdown ) > 0.25 )
			{
				b_set_down = true;   	
			}
		}
		wait 0.05;
	}
	
	t_setdown delete();	
	
	level.is_soap_carry_done = true;
	flag_set( "soap_set_down" );
	flag_set( "FLAG_soap_walk_blood_drip_hip" );
	delayThread( 1.0, ::dumpster_soap_play_blood_pool_fx );
	
	level.player Unlink();
	
	//this sends the chopper across the dumpster area
	level thread flag_set_delayed("dumpster_go", 2 );
	
	level.soap animscripts\shared::placeweaponon( level.soap.primaryweapon, "none" );
	
	// Put down, toss gun anim
	s_align = getstruct( "anim_align_dumpster", "targetname" );

	m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
	m_player_rig.angles = level.player GetPlayerAngles();

	s_align anim_first_frame_solo( m_player_rig, "toss_gun" );
	m_player_rig Hide();

	n_lerp_time = .4;
	level.soap hide();
	s_align anim_first_frame_solo( level.soap, "toss_gun" );
	
	level.player FreezeControls( true );
	level.player PlayerLinkToBlend( m_player_rig, "tag_player", n_lerp_time, n_lerp_time * 0.5 );
	wait n_lerp_time;	
	
	level.soap Show();
	m_player_rig Show();
	level.player PlayerLinkToDelta( m_player_rig, "tag_player", 1, 10, 10, 10, 10, true );
	
	level.soap thread dialogue_queue( "presc_mct_givemearifle" );
	a_anim_ents = make_array( level.soap, m_player_rig, level.price );
	level thread maps\prague_escape_code::play_light_rumble( level.player );
	s_align anim_single( a_anim_ents, "toss_gun" );
	
	exploder( 310 );	// blood pool under soap
	
	level.player Unlink();
	m_player_rig Delete();
	level.player SetOrigin( level.player.origin + (0, 0, 8) );
	// prague_objective_complete( undefined );
	
	level.player allowCrouch( true );
	level.player allowProne( true );
	level.player AllowSprint( true );
	
	level.player GiveWeapon( "m4m203_reflex" );
	level.player SwitchToWeapon( "m4m203_reflex" );
	level.player AllowAds( true );

	// level.player ShowViewModel();
	SetSavedDvar( "cg_drawCrosshair", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	setsaveddvar( "ui_hideMap", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "actionSlotsHide", "0" );
	
	wait (.05);
	level.player enablePlayerWeapons( true );	
	flag_set( "event_soap_carry_done" );	
}

dumpster_soap_play_blood_pool_fx()
{
	spots 	= getstructarray( "blood_pool", "targetname" );
	spot 	= array_keep_values( spots, [ "script_noteworthy" ], [ "dumpster" ] )[ 0 ];
	deletestruct_ref( spot );
	
	PlayFX( getfx( "FX_soap_sit_blood_pool_small" ), spot.origin, AnglesToForward( spot.angles ), AnglesToUp( spot.angles ) );
}

blood_drip_decals()
{
	decals = GetEntArray( "blood_drip_decal", "targetname" );
	array_call( decals, ::NotSolid );
	array_call( decals, ::Hide );
	array_call( decals, ::DontCastShadows );
	
	fov = Cos( 65 );
	
	// Dumpster to Statue
	flag_wait( "event_soap_carry_done" );	
	wait 5.0;
	
	_decals = array_keep_values( decals, [ "script_noteworthy" ], [ "dumpster_to_statue" ] );
	_decals = array_index_by_script_index( _decals );
	
	foreach ( i, decal in _decals )
	{
		if ( i > 7 )
			break;
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 2.25;
	}
	
	// Wait to enter store
	flag_wait( "player_enter_store" );
	wait 1.0;

	foreach ( i, decal in _decals )
	{
		if ( i < 8 )
			continue;
		if ( i > 17 )
			break;
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 0.5;
	}
	
	// Wait to enter statue area	
	flag_wait( "breach_done" );
	
	foreach ( i, decal in _decals )
	{
		if ( i < 18 )
			continue;
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 1.0;
	}
	
	// Statue to Mailbox
	flag_wait( "left_statue" );
	wait 1.0;
	
	_decals = array_keep_values( decals, [ "script_noteworthy" ], [ "statue_to_mailbox" ] );
	_decals = array_index_by_script_index( _decals );
	
	foreach ( i, decal in _decals )
	{
		if ( i > 13 ) 
			break;
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 1.2;
	}
	
	// Wait before going to mailbox
	flag_wait_any( "spawn_tacticals", "goto_tunnel" );
	wait 2.0;
	
	foreach ( i, decal in _decals )
	{
		if ( i < 14 )
			continue;
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 1.0;
	}
	
	// Mailbox to Bank
	flag_wait( "goto_bank" );
	wait 10.0;
	
	_decals = array_keep_values( decals, [ "script_noteworthy" ], [ "mailbox_to_bank" ] );
	_decals = array_index_by_script_index( _decals );
	
	foreach ( i, decal in _decals )
	{
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 1.5;
	}
	
	// Bank to Defend
	flag_wait( "bank_done" );
	wait 6.0;
	
	_decals = array_keep_values( decals, [ "script_noteworthy" ], [ "bank_to_defend" ] );
	_decals = array_index_by_script_index( _decals );
	
	foreach ( i, decal in _decals )
	{
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 0.9;
	}
	
	// Defend to Death
	flag_wait( "soap_pickedup" );
	wait 5.0;
	
	_decals = array_keep_values( decals, [ "script_noteworthy" ], [ "defend_to_death" ] );
	_decals = array_index_by_script_index( _decals );
	
	foreach ( i, decal in _decals )
	{
		decal thread blood_pool_decals_player_LOS_check( fov );
		wait 1.0;
	}
	
	flag_wait( "player_opened_door" );
	
	array_call( decals, ::Delete );
}

blood_pool_decals_player_LOS_check( fov )
{
	if ( !IsDefined( fov ) )
		fov = Cos( 65 );
	
	for ( dot = 1; dot >= fov; wait 0.1 )
	{
		n 	= VectorNormalize( self.origin - level.player.origin );
		fwd = AnglesToForward( level.player GetPlayerAngles() );
		dot = VectorDot( fwd, n );
	}
	self Show();
}

blood_pool_decals()
{
	decals = GetEntArray( "blood_pool_decal", "targetname" );
	array_call( decals, ::NotSolid );
	array_call( decals, ::Hide );
	
	flag_wait( "soap_set_down" );
	wait 20.0;
	decal = array_keep_values( decals, [ "script_noteworthy" ], [ "dumpster" ] )[ 0 ];
	decal Show();
	
	flag_wait( "FLAG_store_soap_sitting_at_statue" );
	wait 20.0;
	decal = array_keep_values( decals, [ "script_noteworthy" ], [ "statue" ] )[ 0 ];
	decal Show();
	
	flag_wait( "FLAG_street_soap_sitting_by_mailbox" );
	wait 20.0;
	decal = array_keep_values( decals, [ "script_noteworthy" ], [ "street" ] )[ 0 ];
	decal Show();
	
	flag_wait( "FLAG_defend_court_soap_reached_back_area" );
	wait 20.0;
	decal = array_keep_values( decals, [ "script_noteworthy" ], [ "defend" ] )[ 0 ];
	decal Show();
}

soap_walk_blood_drip_elbow_fx()
{
	tag = Spawn( "script_model", level.soap GetTagOrigin( "j_elbow_bulge_le" ) );
	tag.angles = ( 0, 0, 0 );
	right = 0 * AnglesToRight( level.soap GetTagAngles( "j_elbow_bulge_le" ) );
	up = 0 * AnglesToUp( level.soap GetTagAngles( "j_elbow_bulge_le" ) );
	tag.origin += right + up;
	tag SetModel( "tag_origin" );
	tag LinkTo( level.soap, "j_elbow_bulge_le" );
	
	fx = getfx( "FX_soap_walk_blood_drip" );
	
	for ( ; flag( "FLAG_soap_blood_fx" ); wait 0.05 )
	{
		flag_wait( "FLAG_soap_walk_blood_drip_elbow" );
		PlayFXOnTag( fx, tag, "tag_origin" );
		if ( !flag( "FLAG_soap_blood_fx" ) )
			break;
		flag_waitopen( "FLAG_soap_walk_blood_drip_elbow" );
		StopFXOnTag( fx, tag, "tag_origin" );
	}
	StopFXOnTag( fx, tag, "tag_origin" );
	tag Delete();
}

soap_walk_blood_drip_hip_fx()
{
	tag = Spawn( "script_model", level.soap GetTagOrigin( "j_hip_ri" ) );
	tag.angles = ( 0, 0, 0 );
	up = 4 * AnglesToUp( level.soap GetTagAngles( "j_hip_ri" ) );
	tag.origin += up;
	tag SetModel( "tag_origin" );
	tag LinkTo( level.soap, "j_hip_ri" );
	
	fx = getfx( "FX_soap_walk_blood_drip" );
	
	for ( ; flag( "FLAG_soap_blood_fx" ); wait 0.05 )
	{
		flag_wait( "FLAG_soap_walk_blood_drip_hip" );
		PlayFXOnTag( fx, tag, "tag_origin" );
		if ( !flag( "FLAG_soap_blood_fx" ) )
			break;
		flag_waitopen( "FLAG_soap_walk_blood_drip_hip" );
		StopFXOnTag( fx, tag, "tag_origin" );
	}
	StopFXOnTag( fx, tag, "tag_origin" );
	tag Delete();
}

soap_walk_blood_smear_fx( side )
{
	Assert( IsDefined( side ) );
	
	tag_side = ter_op( ToLower( side ) == "right", "ri", "le" );
	tag = Spawn( "script_model", level.soap GetTagOrigin( "j_ball_" + tag_side ) );
	tag.angles = ( 0, level.soap.angles[ 1 ], 0 );
	tag.origin += ( 0, 0, 4 );
	tag SetModel( "tag_origin" );
	tag LinkTo( level.soap, "j_ball_" + tag_side );
	
	fx = getfx( "FX_soap_walk_blood_smear" );
	
	for ( ; flag( "FLAG_soap_blood_fx" ); wait 0.05 )
	{
		flag_wait( "FLAG_soap_walk_blood_smear" );
		PlayFXOnTag( fx, tag, "tag_origin" );
		if ( !flag( "FLAG_soap_blood_fx" ) )
			break;
		flag_waitopen( "FLAG_soap_walk_blood_smear" );
		StopFXOnTag( fx, tag, "tag_origin" );
	}
	StopFXOnTag( fx, tag, "tag_origin" );
	tag Delete();
}

soap_carry_damage_trig_think()
{
	//level endon( "player_inside_apt_building" );
	level endon(  "event_soap_carry_done" );
	
	while ( true )
	{
		self waittill ( "trigger" );
		
		soap_carry_player_randomly_shot();
		
		wait(1);
	}
}

soap_carry_kill_trig_think()
{
	self waittill ( "trigger" );
	
	while ( true )
	{
		soap_carry_shoot_player_magically();
		
		n_wait_time = RandomFloatRange( .1, .4 );
		wait( n_wait_time );
	}
}

soap_carry_grenade_damage_trig_think()
{
	self waittill( "trigger" );
	
	MagicGrenade( "fraggrenade", level.player.m_player_rig.origin - (0, 32, 32 ), level.player.m_player_rig.origin, .25 );
}

//vo_this_way


soap_carry_player_randomly_shot()
{
	a_enemy_ai = get_ai_group_ai( "soap_carry_enemy" );
	a_enemy_ai = array_removeDead_or_dying( a_enemy_ai );
	if( a_enemy_ai.size > 1 )
	{
		e_target = a_enemy_ai[ RandomIntRange( 1, a_enemy_ai.size ) -1 ];
		if( IsAlive( e_target ) )
		{
			MagicBullet( e_target.weapon, e_target GetTagOrigin( "tag_flash" ), level.player.origin + ( 0, 0, 32 ) );
		}
	}
	else
	{
		e_target = getent( "soap_carry_fire_backup", "targetname" );
		MagicBullet( "ak47", e_target.origin, level.player.origin + ( 0, 0, 32 ) );
	}
}

soap_carry_reload_listener()
{
	level endon ( "smoke_grenade_toss" );
	
	while( true )
	{
		wait( 0.05 );
				
		if ( self GetCurrentWeaponClipAmmo() == 0 )
		{
			self soap_carry_reload();
		}
		else if( self UseButtonPressed() )
		{
			self soap_carry_reload();
		}
	}
}

soap_carry_reload()
{
	level endon ( "smoke_grenade_toss" );
	
	self enablePlayerWeapons( false );
	self SetWeaponAmmoClip( "p99", 12 );
	wait( 1 );
	self enablePlayerWeapons( true );
}

prague_escape_soap_carry_cleanup()
{
	m_blocker_clip = getent( "apt_wall_collapse_clip", "targetname" );
	m_blocker_clip DisconnectPaths();
	m_blocker_clip trigger_on();
	
	a_backtrack_blocker = getentarray( "apt_wall_collapse", "targetname" );
	foreach( m_blocker in a_backtrack_blocker )
	{
		m_blocker Show();
	}
	
	a_smoke_guys = GetEntArray( "soap_carry_smoke_enemy", "script_noteworthy" );
	array_delete( a_smoke_guys );
	
	a_distance_guys = GetEntArray( "soap_carry_distance_guys", "script_noteworthy" );
	array_delete( a_distance_guys );	
	
	//soap is put down 
	flag_wait("event_soap_carry_done");
	
	level.price AllowedStances( "stand", "crouch", "prone" );
	
    level.price.aggressivemode = false;
    level.price.badplaceawareness = 1;
    level.price.dontavoidplayer = false;
    
    level.price enable_careful();
    level.price enable_danger_react( 3 );
    level.price enable_pain();
    level.price enable_surprise();
    level.price enable_bulletwhizbyreaction();
    level.price set_ignoreSuppression( false );

    level.price cqb_walk( "off" );
    
	level.soap set_ignoreme( false );
	
	// clean up AI
	a_enemies = GetAIArray( "axis" );
	
	foreach( guy in a_enemies )
	{
		guy Die();
	}
}

fire_m203_a( guy )
{
	s_end_point = getstruct( "fire_m203_a", "targetname" );
	m203_fake_fire( s_end_point.origin );
	
	e_car = getent( "soap_carry_m203_car", "script_noteworthy" );
	if( IsDefined( e_car ) )
	{
		e_car destructible_force_explosion();
	}
	
	level.price enable_sprint();
}

fire_m203_b( guy )
{
	s_end_point = getstruct( "fire_m203_b", "targetname" );
	m203_fake_fire( s_end_point.origin );
	wait( .5 );
	level thread suv_flip();
	level.price disable_sprint();
}

fire_m203_at_wall( guy )
{
	s_end_point = getstruct( "fire_m203_at_wall", "targetname" );
	m203_fake_fire( s_end_point.origin );		
	
	wait(.2);
	exploder( 280 );
	level.player PlaySound( "scn_prague_blowout_wall_exp" );
		
	level thread price_open_wall();
	m_wall = getent( "fxanim_exit_wall", "targetname" );
	m_wall UseAnimTree( level.scr_animtree[ "script_model" ] );
	m_wall.animname = "exit_wall";
	m_wall anim_single_solo( m_wall, "exit_wall_explode" );
	level.price disable_sprint();
	level.price cqb_walk( "on" );
}

fire_m203_b_dialogue( guy )
{
	level.price dialogue_queue( "presc_pri_keepmoving" );
}

clear_path_dialogue( guy )
{
	level.price dialogue_queue( "presc_pri_wehavetogetoff" );
	flag_wait( "clear_path_dialogue_2" );
	level.price dialogue_queue( "presc_pri_thisway" );
}

soap_carry_pickup_dialogue()
{
	wait( 1 );
	level.soap thread dialogue_queue( "presc_mct_makarovsaid" );
	// wait 5;
	// level.price dialogue_queue( "presc_pri_havetomove" );
}

smoke_grenade_toss( guy )
{
	s_price_align = getstruct( "align_price_throw_smoke", "targetname" );
	trig_change_align = getent( "smoke_throw_change_align", "targetname" );
	if( level.player IsTouching( trig_change_align ) )
	{
		s_price_align = getstruct( "align_price_throw_smoke_2", "targetname" );
	}
	
	s_price_align anim_single_solo( level.price, "soap_carry_cough_stop" );	
	
	s_align = getstruct( "anim_align_wall_breach", "targetname" );
	s_align anim_reach_solo( level.price, "clear_path_in" );
	s_align anim_single_solo( level.price, "clear_path_in" );
	s_align thread anim_loop_solo( level.price, "clear_path_loop" );	
	flag_set( "clear_path_loop_started" );
}

soap_cough_stop_dialogue( guy )
{
	level.soap dialogue_queue( "presc_mct_coughing" );
}

price_cough_stop_dialogue( guy )
{
	//Pick him up!
	level.price dialogue_queue( "presc_pri_pickhimup" );
	flag_wait( "soap_carry_cough_stop_dialogue_3" );
	//we cant stay here, cmon this way
	level.price dialogue_queue( "presc_pri_reinforcementsright" );
	flag_wait( "soap_carry_cough_stop_dialogue_4" );
	level.price dialogue_queue( "presc_pri_cmonnow" );	
}

toss_gun_dialogue( guy )
{
	level.price dialogue_queue( "presc_pri_dontyoudare" ); //its not safe here we have to move!
}

m203_fake_fire( v_end_point, do_damage )
{
	v_start_point = level.price GetTagOrigin( "tag_flash" );
	
	PlayFXOnTag( level._effect[ "muzzleflash_heavy" ], level.price, "tag_flash" );
	projectile = MagicBullet( "m203_m4", v_start_point, v_end_point );
	
	PlayFXOnTag( level._effect[ "geotrail_m203" ], projectile, "tag_origin" );
	
	n_max_dist = 96 * 96;
	n_dist = DistanceSquared( level.price.origin, level.player.origin );
	
	if( n_dist < n_max_dist )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );	
	}
	
	if(IsDefined( do_damage ))
	{		
		RadiusDamage( v_end_point, 100, 200, 200 );
	}	
}


price_open_wall()
{
	wait 0.1;
	
	a_m_dest = GetEntArray( "apt_wall_destroyed", "targetname" );
	foreach( m_dest in a_m_dest )
	{
		m_dest Show();
	}
	
	m_wall = GetEnt( "fxanim_exit_wall", "targetname" );
	m_wall Show();
	
	a_m_clean = GetEntArray( "apt_wall_clean", "targetname" );
	foreach( m_clean in a_m_clean )
	{
		//m_clean ConnectPaths();
		m_clean Delete();
	}
}
	
