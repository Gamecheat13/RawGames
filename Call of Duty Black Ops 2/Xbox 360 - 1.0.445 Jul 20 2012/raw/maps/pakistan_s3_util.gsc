#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_objectives;
#include maps\_turret;
#include maps\_vehicle;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\pakistan.gsh;

escape_setup( is_not_intro )
{
	/#
		// TODO: uncomment this if you want super soc-t (boost)
//		level.player set_temp_stat( SOCT_HAS_BOOST, 1 );
		level.player set_temp_stat( SOCT_HAS_BOOST, 0 );
	#/
	
	// set up player's soc-t
	level.vh_player_soct = spawn_vehicle_from_targetname( "player_soc_t" );
	level.vh_player_soct.overrideVehicleDamage = ::player_soct_damage_override;
	level.vh_player_soct thread player_soct_damage_watcher();
	level.vh_player_soct enable_turret( 1 );
	level.vh_player_soct set_turret_target_flags( TURRET_TARGET_AI | TURRET_TARGET_VEHICLES, 1 );
	level.vh_player_soct.n_fail_speed = 29;
	level.vh_player_soct.n_intensity_min = 9;

	if ( level.player get_temp_stat( SOCT_HAS_BOOST ) )
	{
		level.vh_player_soct SetModel( "veh_t6_mil_super_soc_t" );
		level.vh_player_soct.n_intensity_min = 6;
	}

	// set up salazar's soc-t
	level.vh_salazar_soct = spawn_vehicle_from_targetname( "salazar_soc_t" );
	level.vh_salazar_soct veh_magic_bullet_shield( true );
	level.vh_salazar_soct enable_turret( 1 );
	level.vh_salazar_soct set_turret_target_flags( TURRET_TARGET_AI | TURRET_TARGET_VEHICLES, 1 );
	
	// set up player's drone
	level.vh_player_drone = spawn_vehicle_from_targetname( "player_drone" );
	level.vh_player_drone.overrideVehicleDamage = ::player_drone_damage_override;
	level.vh_player_drone set_turret_target_flags( TURRET_TARGET_AI | TURRET_TARGET_VEHICLES, 1 );
	level.vh_player_drone thread friendly_drone_shoot_logic();

	// set up harper
	level.harper = init_hero( "harper" );
	level.harper enter_vehicle( level.vh_player_soct );
	
	// set up salazar
	level.salazar = init_hero( "salazar" );
	level.salazar enter_vehicle( level.vh_salazar_soct, "tag_driver" );
	
	// set up redshirt
	level.han = init_hero( "han" );
	level.han enter_vehicle( level.vh_salazar_soct );
	
	// set up the player
	level.player thread take_and_giveback_weapons( "give_back_weapons" );
	level.player.overridePlayerDamage = ::player_damage_override;
	level.player SetClientDvar( "phys_impact_intensity_limit", 1 );
	
	// set up dvars
	SetSavedDvar( "vehicle_collision_prediction_time", 0.25 );
	SetSavedDvar( "phys_vehicleDamageFroceScale", 0.01 );
	
	if ( IS_TRUE( is_not_intro ) )
	{
		move_friendly_into_position();
		
		level.player.vehicle_state = PLAYER_VH_STATE_SOCT;
		level.vh_player_soct UseBy( level.player );
		
		wait 1; // give salazar a head start
		
		level.vh_salazar_soct thread salazar_soct_speed_control();
		level.vh_player_drone thread vehicle_speed_control();
	}
	
	flag_set( "section_3_started" );
}

move_friendly_into_position( is_not_intro )
{
	// set up player's soc-t
	s_skipto = getstruct( "skipto_" + level.skipto_point, "targetname" );
	level.vh_player_soct.origin = s_skipto.origin;
	level.vh_player_soct.angles = s_skipto.angles;

	// set up salazar's soc-t
	s_skipto = getstruct( "skipto_" + level.skipto_point + "_salazar", "targetname" );
	level.vh_salazar_soct.origin = s_skipto.origin;
	level.vh_salazar_soct.angles = s_skipto.angles;
	
	nd_start = GetVehicleNode( level.skipto_point + "_salazar_start", "script_noteworthy" );
	level.vh_salazar_soct thread go_path( nd_start );
		
	// set up player's drone
	s_skipto = getstruct( "skipto_" + level.skipto_point + "_drone", "targetname" );
	level.vh_player_drone.origin = s_skipto.origin;
	level.vh_player_drone.angles = s_skipto.angles;
	
	nd_start = GetVehicleNode( level.skipto_point + "_drone_start", "script_noteworthy" );
	level.vh_player_drone thread go_path( nd_start );
}

// self == player's soc-t
player_soct_damage_watcher()
{
	self endon( "death" );
	
	const n_damage_times_max = 19;
	self.n_times_before_damage = 0;
	
	while ( true )
	{	
		self waittill( "damage" );
		
		// on certain occasions we might not what the player to get hurt at all, then set this flag
		if ( !flag( "player_cannot_get_hurt" ) )
		{
			// only do this if the player is in the soc-t
			if ( IsDefined( level.player.viewlockedentity ) && level.player.viewlockedentity == self )
			{
				// player only takes damage if the player's soc-t takes damage after a certain amount
				if ( self.n_times_before_damage > n_damage_times_max )
				{
					level.player DoDamage( 1, self.origin );
					self.n_times_before_damage = 0;
				}
				else
				{
					self.n_times_before_damage++;
				}
			}
		}
	}
}

// self == player's soct
player_soct_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	const n_health_min = 3;
	
	if ( self.health < n_health_min )
	{
		self.health = 3600;
	}
	
	n_damage = 1;
	
	return n_damage;
}

// self == player's drone
player_drone_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	const n_health_min = 3;
	
	if ( self.health < n_health_min )
	{
		self.health = 3600;
	}
	
	n_damage = 1;
	
	return n_damage;
}

player_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	if ( flag( "player_cannot_get_hurt" ) )
	{
		n_damage = 0;
	}
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		n_damage = 0;
	}
	
	const n_health_after_damage_min = 1;
	n_health_after_damage = self.health - n_damage;
	if ( n_health_after_damage < n_health_after_damage_min )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

get_player_on_soc_t()
{
	s_skipto = getstruct( "skipto_" + level.skipto_point, "targetname" );
	self.origin = s_skipto.origin;
	self.angles = s_skipto.angles;
	self UseBy( level.player );
}

vehicle_switch( nd_start )
{
	level endon( "end_vehicle_switch" );
	level endon( "missionfailed" );
	level.player endon( "death" );
//	level.player waittill( "enter_vehicle", vh_entered );
		
	level.player.vehicle_state = PLAYER_VH_STATE_NONE;
	
	wait 0.05;
	
	if ( IsDefined( level.player.viewlockedentity ) )
	{
		// if the player starts in the soc-t
		if ( level.player.viewlockedentity.vehicleclass == "boat"  ) 
		{
			level.vh_player_drone.follow_ent = level.vh_player_soct;
			level.vh_player_soct player_soct_switch_setup( nd_start );
		}
		
		// if the player starts in the drone
		if ( level.player.viewlockedentity.vehicleclass == "helicopter"  ) 
		{	
			level.player.vehicle_state = PLAYER_VH_STATE_DRONE;
			level.vh_player_soct.follow_ent = level.vh_player_drone;
			level.vh_player_soct notify( "stop_turret_shoot" );			
			
			level.player hide_player_hud();
		}
	}
	
	while ( true )
	{
		level.player.viewlockedentity waittill( "change_seat" );
		
		if ( !flag( "cannot_switch" ) )
		{
			flag_clear( "vehicle_switched" );
			flag_clear( "vehicle_switch_fade_in_started" );
			
			level.player playsound ("uin_fire_scout_transition");
		
			screen_fade_out( SWITCH_TIME );
			
			vh_current = level.player.viewlockedentity;
			vh_current UseBy( level.player );
			vh_current notify( "switch_vehicle" );
			
			wait 0.05; // needs a wait for drone hud
			
			if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT ) // the player is in the soc-t and trying to switch to the drone
			{
				soct_to_drone_setup( nd_start );
			}
			else if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE ) // the player is in the drone and trying to switch to the soc-t
			{	
				drone_to_soct_setup( nd_start );
			}
			
			flag_set( "vehicle_switch_fade_in_started" );
			
			screen_fade_in( SWITCH_TIME );
		
			flag_set( "vehicle_switched" );
		}
	}
}

player_soct_switch_setup( nd_start )
{
	// Spawn drive hands
	ClientNotify( "enter_soct" );
			
	level.player.vehicle_state = PLAYER_VH_STATE_SOCT;
	
	nd_current = ( IsDefined( self.currentNode ) ? self.currentNode : nd_start );				
	self thread vehicle_paths( nd_current );
	self DrivePath( nd_current, true );
	self.driver = level.player;
	self thread player_in_soct_fail();
	self notify( "stop_turret_shoot" );
	
	level.player show_player_hud();
}

drone_to_soct_setup( nd_start )
{
	level.vh_player_soct UseBy( level.player );
				
	level.vh_player_drone notify( "remove_fx" );
	level.vh_player_soct notify( "remove_fx_cheap" );
	
	wait 0.05; // give time for the previous headlights fx delete
	
	level.vh_player_drone play_fx( "drone_spotlight_cheap", level.vh_player_drone GetTagOrigin( "tag_flash" ), level.vh_player_drone GetTagAngles( "tag_flash" ), "remove_fx_cheap", true, "tag_flash" );
	level.vh_player_soct play_fx( "soct_spotlight", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx", true, "tag_headlights" );
	
	level.vh_player_soct ClearClientFlag( CLIENT_FLAG_VEHICLE_OUTLINE );
	level.vh_salazar_soct ClearClientFlag( CLIENT_FLAG_VEHICLE_OUTLINE );
	
	level.vh_player_soct player_soct_switch_setup( nd_start );
}

soct_to_drone_setup( nd_start )
{
	level.vh_player_soct notify( "end_player_in_soct_fail" );
				
	level.vh_player_drone ClearVehGoalPos();
	level.vh_player_drone thread go_path( level.vh_player_drone get_correct_switch_node() );
	
	level.vh_player_drone UseBy( level.player );
	level.vh_player_drone thread turret_shoot();
	level.player.vehicle_state = PLAYER_VH_STATE_DRONE;
	
	level.vh_player_drone thread maps\_vehicle_death::vehicle_damage_filter( "firestorm_turret" );	
	level.vh_player_drone thread firescout_fire_missiles();
	
	level.vh_player_soct AttachPath( level.vh_player_soct get_vehiclenode_any_dynamic( level.vh_player_soct.currentNode.target ) );
	level.vh_player_soct StartPath();
	
	level.vh_player_drone notify( "remove_fx_cheap" );
	level.vh_player_soct notify( "remove_fx" );
	
	wait 0.05; // give time for the previous headlights fx delete
	
	level.vh_player_drone play_fx( "firescout_spotlight", level.vh_player_drone GetTagOrigin( "tag_flash" ), level.vh_player_drone GetTagAngles( "tag_flash" ), "remove_fx", true, "tag_flash" );
	level.vh_player_soct play_fx( "soct_spotlight_cheap", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx_cheap", true, "tag_headlights" );
	
	level.player hide_player_hud();
	
	level.vh_player_soct SetClientFlag( CLIENT_FLAG_VEHICLE_OUTLINE );
	level.vh_salazar_soct SetClientFlag( CLIENT_FLAG_VEHICLE_OUTLINE );
	
	level.vh_player_drone thread speed_up_drone();
}

/* ------------------------------------------------------------------------------------------
GENERAL PLAYER FAIL SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == player's soc-t
player_in_soct_fail()
{
	level endon( "escape_done" );
	self endon( "end_player_in_soct_fail" );
	
	level.player waittill_attack_button_pressed();
	
	wait 1; // give the player time to start before failing them
	
	self thread player_in_soct_dist_check();
	
	while ( true )
	{
		// wait if it just came back from a save restore
		if ( IsDefined( level.n_fail_delay ) && level.n_fail_delay > 0 )
		{
			wait level.n_fail_delay;
			
			level.n_fail_delay = undefined;
		}
		else 
		{
			// check to see if the player is going below the fail speed
			if ( self GetSpeedMPH() < self.n_fail_speed )
			{
				self player_in_soct_fail_speed_recover();
				
				// only fail the player if the soc-t is not back to the allowed speed
				if ( IS_TRUE( self.b_speed_fail ) )
				{	
					self.b_speed_fail = false;
					
					missionfailedwrapper( &"PAKISTAN_SHARED_SOCT_FAIL" );
				}
			}
		}
		
		wait 0.05;
	}
}

// self == player's soc-t
player_in_soct_fail_speed_recover()
{
	level endon( "fail_speed_recovered" );
	
	const n_seconds = 3;

	// only fail the player if the soc-t does not speed up within the allowed time
	for ( i = 0; i < n_seconds; i++ )
	{
		wait 1;
		
		if ( self GetSpeedMPH() > self.n_fail_speed )
		{
			level notify( "fail_speed_recovered" );
		}
	}
	
	self.b_speed_fail = true;
}

// self == player's soc-t
player_in_soct_dist_check()
{
	level endon( "escape_done" );
	self endon( "end_player_in_soct_fail" );
	
	const n_dist_max = 67108864; // 8192 * 8192
	
	// fail the player if the player's soc-t is further than the allowed distance from salazar's soc-t
	while ( true )
	{
		n_dist = Distance2DSquared( self.origin, level.vh_salazar_soct.origin );
		if ( n_dist > n_dist_max )
		{	
			missionfailedwrapper( &"PAKISTAN_SHARED_SOCT_FAIL" );
		}
		
		wait 0.05;
	}
}

/* ------------------------------------------------------------------------------------------
SPEED CONTROL SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == salazar's soc-t
salazar_soct_speed_control()
{
	self endon( "death" );
	self endon( "end_salazar_speed_control" );
	
	//self.n_speed_max = self GetMaxSpeed() / INCHES_PER_SEC_TO_MPH;
	self.n_speed_max = 71;
	
	while ( true )
	{
		v_player_forward = AnglesToForward( level.vh_player_soct.angles );
		v_salazar_pos = ( self.origin[0], self.origin[1], level.vh_player_soct.origin[2] );
		n_dot_to_player = VectorDot( v_player_forward, VectorNormalize( v_salazar_pos - level.vh_player_soct.origin ) );
	
		const n_dot_min = 0.25;
		if ( n_dot_to_player > n_dot_min ) // maintain distance if salazar's soc-t is in front of player's soc-t
		{
			n_speed_new = level.vh_player_soct GetSpeedMPH();
			
			n_dist = Distance2D( level.vh_player_soct.origin, self.origin );
			if ( n_dist > VH_DISTANCE_MAX )
			{
				const n_speed_damp = 3;
				n_speed_new -= n_speed_damp * Floor( n_dist / VH_DISTANCE_MAX );
			}
			else if ( n_dist < 512 )
			{
				n_speed_new = self.n_speed_max;
			}
		
			if ( n_speed_new < 0 )
			{
				n_speed_new = 0;
			}
		}
		else // speed up salazar's soc-t if it is behind the player's soc-t
		{
			n_speed_new = self.n_speed_max;
		}
		
		n_speed_new = Max( 0, n_speed_new );
		self SetSpeed( n_speed_new, VH_ACCELERATION, VH_DECELERATION );
		
		wait 0.05;
	}
}

// self == player's drone
vehicle_speed_control()
{
	self endon( "death" );
	
	while ( true )
	{
		if ( IsDefined( level.player.viewlockedentity ) && level.player.viewlockedentity == self )
		{
			self player_in_drone();
		}
		else
		{
			self player_in_soct();			
		}
		
		wait 0.05;
	}
}

// self == player's drone
player_in_soct()
{
	self endon( "death" );
	
	v_player_forward = AnglesToForward( level.vh_player_soct.angles );
	v_heli_pos = ( self.origin[0], self.origin[1], level.vh_player_soct.origin[2] );
	n_dot_to_heli = VectorDot( v_player_forward, VectorNormalize( v_heli_pos - level.vh_player_soct.origin ) );
		
	const n_dot_max = 0.4;
	const n_dot_min = -0.4;
	
	if ( n_dot_to_heli > n_dot_max ) // if the drone is in front of the player's soc-t
	{
		n_speed_new = self _normal_speed_control();
	}
	else if ( n_dot_to_heli < n_dot_min ) // if the drone is behind the player's soc-t
	{
		v_heli_forward = AnglesToForward( self.angles );
		n_dot_directions = VectorDot( v_player_forward, v_heli_forward );
			
		if( n_dot_directions > 0 )
		{
			// the soc-t and drone are facing in the same direction. The angle between their directions is < 90 degrees
			n_speed_new = DRONE_SPEED_MAX;
		}
		else
		{
			// stop the drone if the player's soc-t is facing the opposite direction
			n_speed_new = 0;
		}
	}
	else // speed up the drone if it is fly "beside" the player's soc-t
	{
		n_speed_new = DRONE_SPEED_MAX;
	}

	n_speed_new = Max( 0, n_speed_new );	
	self SetSpeed( n_speed_new, VH_ACCELERATION, VH_DECELERATION );
		
	// wait for the player to get back on track
	if ( n_speed_new == 0 )
	{
		self _back_on_track_wait();
	}
}

// self == player's drone
_normal_speed_control()
{
	self endon( "death" );
	
	const n_sweet_spot = 0.95;
	n_dist = clamp( Distance2D( self.origin, level.vh_player_soct.origin ), 0, VH_DISTANCE_MAX );
	
	// 1 is out of range and need to stop. 0 means we need to speed up
	n_dist_frac = n_dist / VH_DISTANCE_MAX;
	
	if ( n_dist_frac < n_sweet_spot ) // the drone is not that far away, so it can gun it
	{
		n_speed_new = DRONE_SPEED_MAX;
	}
	else // the drone is kind of far, so it needs to slow down
	{
		n_dist_percent = 1 - n_dist_frac;
		n_speed_new = linear_map( n_dist_percent, 0, 1, DRONE_SPEED_MIN, DRONE_SPEED_MAX );
	}
	
	return n_speed_new;
}

// self == player's drone
_back_on_track_wait()
{
	self endon( "death" );
	
	const n_dot_min = -0.4;
	n_dot_to_player = self _drone_dot_to_player();
	n_dist = Distance2D( self.origin, level.vh_player_soct.origin );
	
	// wait if the player's soc-t is behind the drone and further than the max distance
	while ( n_dot_to_player < n_dot_min && n_dist > VH_DISTANCE_MAX )
	{
		wait 0.05;
		
		n_dot_to_player = self _drone_dot_to_player();
		n_dist = Distance2D( self.origin, level.vh_player_soct.origin );
	}
}

// self == player's drone
_drone_dot_to_player()
{
	self endon( "death" );
	
	v_drone_forward = AnglesToForward( self.angles );
	v_heli_pos = ( self.origin[0], self.origin[1], level.vh_player_soct.origin[2] );
	n_dot_to_player = VectorDot( v_drone_forward, VectorNormalize( level.vh_player_soct.origin - v_heli_pos ) );
	
	return n_dot_to_player;
}

// self == player's drone
player_in_drone()
{
	self endon( "death" );
	
	n_soct_speed = level.vh_player_soct GetSpeedMPH();
	
	if ( n_soct_speed >= 0 && !flag( "stop_drone_speed_control" ) )
	{
		const n_dot_front = 0.25;
		n_dot_to_player = self _drone_dot_to_player();
	
		if ( n_dot_to_player < n_dot_front ) // if soc-t is behind the drone, slowly increase speed until the soc-t is in front
		{
			const n_sweet_spot = 0.95;
			n_dist = clamp( Distance2D( self.origin, level.vh_player_soct.origin ), 0, VH_DISTANCE_MAX );
	
			// 1 is out of range and need to stop. 0 means we need to speed up
			n_dist_frac = n_dist / VH_DISTANCE_MAX;
	
			if ( n_dist_frac < n_sweet_spot ) // the player's soc-t is not that far away, so it can gun it
			{
				self SetSpeed( n_soct_speed, VH_ACCELERATION, VH_DECELERATION );
				level.vh_player_soct SetSpeed( 62, VH_ACCELERATION, VH_DECELERATION );
			}
			else // the player's soct is kind of far, so it needs to slow down
			{
				n_dist_percent = 1 - n_dist_frac;
				n_speed_new = linear_map( n_dist_percent, 0, 1, 45, 62 );
				self SetSpeed( n_speed_new, VH_ACCELERATION, VH_DECELERATION );
				level.vh_player_soct SetSpeed( 63, VH_ACCELERATION, VH_DECELERATION );
			}
		}
		else // move the drone as fast as the soc-t if the soc-t is in front of it
		{
			self SetSpeed( n_soct_speed, VH_ACCELERATION, VH_DECELERATION );
		
			n_dist = Distance2D( self.origin, level.vh_player_soct.origin );
			
			// wait for the drone to catch up to the soc-t if the soc-t is too far ahead
			while ( n_dist > 2305 )
			{
				level.vh_player_soct SetSpeed( 3, VH_ACCELERATION, VH_DECELERATION );
			
				wait 0.05;
			
				n_dist = Distance2D( self.origin, level.vh_player_soct.origin );
			}
			
			level.vh_player_soct SetSpeed( 62, VH_ACCELERATION, VH_DECELERATION );
		}
	}
}

// self == player's soc-t
watch_for_boost()
{
	self endon( "death" );
	self endon( "end_boost" );
//	self endon( "no_driver" );

	self.max_speed = self GetMaxSpeed() / INCHES_PER_SEC_TO_MPH;
	self.min_sprint_speed = self.max_speed * 0.75;
	self.sprint_meter = 100;
	self.sprint_meter_max = 100;
	self.sprint_meter_min = self.sprint_meter_max * 0.25;
	
	if ( level.player get_temp_stat( SOCT_HAS_BOOST ) )
	{
		self.max_sprint_speed = self.max_speed * 1.16;
		self.sprint_time = 3;
		self.sprint_recover_time = 9;
	}
	else
	{
		self.max_sprint_speed = self.max_speed * 1.05;
		self.sprint_time = 1;
		self.sprint_recover_time = 12;
	}
		
	bPressingSprint = false;
	bMeterEmpty = false;
	bSprintFXActive = false;	
	sprint_drain_rate = self.sprint_meter_max / self.sprint_time;
	sprint_recover_rate = self.sprint_meter_max / self.sprint_recover_time;
	
	while( true )
	{
		speed = self GetSpeedMPH();
		forward = AnglesToForward( self.angles );		
		
		bCanSprint = ( bMeterEmpty == false ) && ( IsDefined( self.driver ) && self.driver == level.player );
		bPressingSprint = level.player SprintButtonPressed();

		if ( bCanSprint && bPressingSprint && level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
		{
			self.sprint_meter -= sprint_drain_rate * 0.05; 
			
			// Check for a completely drained sprint meter
			if ( self.sprint_meter < 0 )
			{
				self.sprint_meter = 0;
				bMeterEmpty = true;	
			}
			else
			{
				self SetVehMaxSpeed( self.max_sprint_speed );

				// Speed me up
				if ( speed < self.max_sprint_speed )
				{
					self LaunchVehicle( forward * 400 * 0.05 );
					self playsound ( "veh_soct_boost");
				}
				
				if ( !bSprintFXActive )
				{
					self thread boost_fx_loop();
					bSprintFXActive = true;
					
					rpc( "clientscripts/_boat_soct_ride", "set_soct_boost", 1 );
				}
			}
		}
		else
		{
			self.sprint_meter += sprint_recover_rate * 0.05;
			
			// If the meter was completely drained...don't allow sprint
			// until we've recovered the minimum amount
			if ( bMeterEmpty )
			{
				if ( self.sprint_meter > self.sprint_meter_min )
					bMeterEmpty = false;
			}
			
			if ( self.sprint_meter > self.sprint_meter_max )
				self.sprint_meter = self.sprint_meter_max;

			self SetVehMaxSpeed( self.max_speed );

			// Slow me down
			if ( speed > self.max_speed )
				self LaunchVehicle( forward * -200 * 0.05 );
			
			if ( bSprintFXActive )
			{
				self notify( "done_boosting" );
				bSprintFXActive = false;
				
				rpc( "clientscripts/_boat_soct_ride", "set_soct_boost", 0 );				
			}
		}	
		
		wait 0.05;
	}
}

// self == player's soc-t
boost_fx_loop()
{
	self endon( "death" );
	self endon( "done_boosting" );
	
	while ( true )
	{
		PlayFXOnTag( level._effect["soct_boost_fx"], self, "tag_origin" );
		wait 0.2;
	}
}

// self == player's drone
speed_up_drone()
{	
	const n_drone_immediate_speed = 63;
	
	flag_set( "stop_drone_speed_control" );
	self SetSpeed( n_drone_immediate_speed, 1000, 1000 );
	
	while ( self GetSpeedMPH() < n_drone_immediate_speed - 1 )
	{
		wait 0.05;
	}
	
	flag_clear( "stop_drone_speed_control" );
}

/* ------------------------------------------------------------------------------------------
SOC-T SHOOTING LOGIC SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == enemy's soc-t
enemy_soct_shoot_logic()
{
	wait_network_frame();
	
	self enable_turret( 1 );
	self set_turret_target_flags( TURRET_TARGET_VEHICLES, 1 );
}

// self == enemy's soc-t
enemy_soct_must_shoot_logic( e_priority_target )
{
	wait_network_frame();
	
	if ( IsDefined( e_priority_target ) )
	{
		self add_turret_priority_target( e_priority_target, 1 );
	}
	
	self set_turret_burst_parameters( 6, 6, 0, 0, 1 );
	self enable_turret( 1 );
	self set_turret_target_flags( TURRET_TARGET_VEHICLES, 1 );
}

random_friendly_target()
{
	const n_random = 2;
	
	if ( RandomInt( n_random ) == 0 )
	{
		vh_friendly = level.vh_player_soct;
	}
	else if ( RandomInt( n_random ) == 1 )
	{
		vh_friendly = level.vh_salazar_soct;
	}
	else
	{
		vh_friendly = level.vh_player_soct;
	}
	
	return vh_friendly;
}

// self == player's drone
friendly_drone_shoot_logic()
{
	self endon( "death" );
	
	while ( true )
	{
		if ( IsDefined( level.player.vehicle_state ) )
		{
			if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
			{
				self disable_turret( 0 );
			}
			else if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
			{
				self enable_turret( 0 );
			}
		}
		
		wait 0.05;
	}
}

enemy_drone_setup( b_only_turret )
{
	self endon( "death" );
	
	self play_fx( "drone_spotlight_cheap", self GetTagOrigin( "tag_flash" ), self GetTagAngles( "tag_flash" ), "remove_fx_cheap", true, "tag_flash" );
	
	self thread set_lock_on_target( ( 0, 0, -32 ) );
	self enable_turret( 0 );
	
	if ( !IS_TRUE( b_only_turret ) )
	{
		self enable_turret( 1 );
		self enable_turret( 2 );
	}
}

/* ------------------------------------------------------------------------------------------
ENEMY SOC-T SETUP SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == enemy soc-t
enemy_soct_setup( b_consistent_shooting, e_priority_target )
{
	self endon( "death" );
	
	self.dontfreeme = true;
	self.overrideVehicleDamage = ::enemy_soct_damage_override;
	
	if ( self.targetname != "heli_crash_soct" )
	{
		self thread vehicle_collision_watcher();
		self thread set_lock_on_target( ( 0, 0, 32 ) );
		self thread drone_kill_count();
		self thread enemy_soct_speed_control();
		self thread add_scripted_damage_state( 0.5, ::soct_damaged_fx );
	}
	
	if ( IS_TRUE( b_consistent_shooting ) )
	{
		self thread enemy_soct_must_shoot_logic( e_priority_target );
	}
	else
	{
		self thread enemy_soct_shoot_logic();
	}	
	
	level notify( "update_enemy_soct_list" );
}

// self == enemy soc-t
enemy_soct_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( self.targetname == "heli_crash_soct" )
	{
		n_damage = 0;
	}
	else if ( IsDefined( e_attacker.vehicletype ) && e_attacker.vehicletype == "boat_soct_axis" )
	{
		n_damage = 0;
	}
	else if ( str_weapon == "boat_gun_turret" )
	{
		n_damage = Int( Ceil( n_damage/ 6 ) );
	}
	
	return n_damage;
}

// self == enemy
 temp_magic_bullet_shield( n_seconds_to_wait )
{
	self endon( "death" );
	
	if ( IS_VEHICLE( self ) )
	{
		level notify( "update_enemy_soct_list" );
		self.dontfreeme = true;		
		
		self veh_magic_bullet_shield( true );
		self thread enemy_soct_shoot_logic();
		self thread vehicle_collision_watcher();
		self thread set_lock_on_target( ( 0, 0, 32 ) );
		self thread soct_death_launch();
		self thread drone_kill_count();
		self thread enemy_soct_speed_control();
		self thread add_scripted_damage_state( 0.5, ::soct_damaged_fx );
	}
	else
	{
		self magic_bullet_shield();
	}
	
	if ( IsDefined( n_seconds_to_wait ) )
	{	
		wait n_seconds_to_wait;
	}
	else
	{
		if ( IS_VEHICLE( self ) )
		{
			self waittill( "stop_magic_bullet" ); // a notify that is sent from its path
		}
	}
	
	if ( IS_VEHICLE( self ) )
	{
		self veh_magic_bullet_shield( false );
		self.overrideVehicleDamage = ::enemy_soct_damage_override;
	}
	else
	{
		self stop_magic_bullet_shield();
	}
}

/* ------------------------------------------------------------------------------------------
ENEMY SOC-T RESPAWN SCRIPTS
-------------------------------------------------------------------------------------------*/
enemy_respawn()
{
	a_respawn_triggers = GetEntArray( "enemy_soct_respawn", "targetname" );
	array_thread( a_respawn_triggers, ::enemy_respawn_listener );
}

// self == a trigger that will spawn an enemy soc-t
enemy_respawn_listener()
{
	self waittill( "trigger" );
	
	while ( level.player IsTouching( self ) )
	{
		a_soct = GetEntArray( "generic_enemy_soct", "script_noteworthy" );
		a_soct = array_removeDead( a_soct );
		
		if ( a_soct.size < 3 && !is_lane_occupied( self.script_noteworthy ) )
		{
			vh_soct = spawn_vehicle_from_targetname( "soct_respawner" );
			
			nd_start = GetVehicleNode( self.target, "targetname" );
			vh_soct thread go_path( nd_start );
			
			sp_driver = GetEnt( "driver_respawner", "targetname" );
			ai_driver = sp_driver spawn_drone();
			ai_driver enter_vehicle( vh_soct, "tag_driver" );
			
			sp_shooter = GetEnt( "driver_respawner", "targetname" );
			ai_shooter = sp_shooter spawn_drone();
			ai_shooter enter_vehicle( vh_soct );
			
			vh_soct thread enemy_soct_setup();
			vh_soct thread clear_lane( self.script_noteworthy );
			
			level.a_lanes[ self.script_noteworthy ] = "occupied";
			
			break;
		}
		
		wait 0.05;
	}
}

is_lane_occupied( str_lane )
{
	b_lane_occupied = false;
	
	if ( level.a_lanes[ str_lane ] == "occupied" )
	{
		b_lane_occupied = true;
	}
	
	return b_lane_occupied;
}

// self == enemy soc-t
clear_lane( str_lane )
{
	self waittill( "death" );
	
	level.a_lanes[ str_lane ] = "unoccupied";
}

/* ------------------------------------------------------------------------------------------
TAKEDOWN ENEMY SOC-T SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == enemy soc-t
vehicle_collision_watcher()
{
	self endon( "death" );
	level endon( "end_veh_collision_watcher" );
	
	self.num_hits = 0;
	
	const max_forward_launch = 150;
	const min_launch_intensity = 9;
	
	while ( true )
	{
		self waittill( "veh_collision", location, normal, intensity, type, ent );
		
		if ( IsDefined( intensity ) )
		{
			/#
			IPrintLn( "Intensity: " + intensity );
			#/
			
			if ( IsDefined( ent ) && IsDefined( ent.vehicletype ) )
			{
				// only count as a hit if any of these conditions is met
				if ( intensity >= level.vh_player_soct.n_intensity_min || can_player_takedown( intensity ) )
					self.num_hits++;
				
				if ( self.num_hits > 0 )
				{
					// send notify only if the player is the one who took the soc-t down
					if ( ent == level.vh_player_soct )
					{
						level notify( "takedown" );
					}
					
					/#
//					set_objective( level.OBJ_RAM, self, "remove" );
					#/
					
					self ClearVehGoalPos();
					self.dontfreeme = true;
					
					self LaunchVehicle( VectorNormalize( level.vh_player_soct.velocity ) * max_forward_launch, location, false, true );
					Earthquake( 0.75, 1.0, self.origin, 512, level.player );
					
					wait 1.2; // give the player time to see the launch

					self thread vehicle_free();
					self DoDamage( 10000, location, level.player, undefined, "projectile" );
				}
			}
			else
			{
				wait 0.15; 	
			}
		}
		
		wait 0.05; // prevent detecting vehicle collision every frame
	}
}

can_player_takedown( n_intensity )
{
	can_takedown = false;
		
	if ( level.player SprintButtonPressed() )
	{
		can_takedown = true;
	}
	
	return can_takedown;
}

// self == enemy soc-t
vehicle_free()
{
	wait 3;
	
	if ( IsDefined( self ) )
	{
		self.dontfreeme = false;
	}
	
	//if ( !IsDefined( self.isacorpse ) )
	//	self FreeVehicle();
}

/* ------------------------------------------------------------------------------------------
GENERAL ENEMY SOC-T SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == enemy soc-t
drone_kill_count()
{
	self waittill( "death", e_attacker );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		level notify( "drone_kill" );
	}
}

// self == enemy soc-t
set_lock_on_target( v_offset )
{
	if( IsDefined( v_offset ) )
	{
		Target_Set( self, v_offset );
	}
	else
	{
		Target_Set( self );
	}
	
	self waittill_either( "death", "end_lock_on" );
	
	if( IsDefined( self ) )
	{
		Target_Remove( self );
	}
}

// self == enemy soct
soct_death_launch()
{
	self endon( "soct_player_collision" );
	
	self waittill( "death", attacker, damageFromUnderneath, weaponName, point, dir );
	
	// in case "death" was sent because it was deleted
	if ( IsDefined( attacker ) )
	{
		self.dontfreeme = true;
		self getoffpath();
		self LaunchVehicle( VectorNormalize( self.velocity ) * 200 + ( 0, 0, 50 ), point, false, true );
		wait 1.5;
		//if ( !IsDefined( self.isacorpse ) )
		//	self FreeVehicle();
		self.dontfreeme = false;
	}
}

/* ------------------------------------------------------------------------------------------
DRONE LOCK ON SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == player's drone
firescout_fire_missiles()
{
    self endon( "death" );
    self endon( "stop_firescout_missiles" );
    self endon( "exit_vehicle" );
    
    //level.player thread player_unlimited_ammo();
    n_fire_time = WeaponFireTime( self SeatGetWeapon( 1 ) );
    n_fov = GetDvarFloat( "cg_fov" );
    v_offset = ( 0, 0, 0 );
    n_radius = 20;
    const n_distance_max = 8000;
    n_distance_max_sq = n_distance_max * n_distance_max;
    
    const n_heat_time = 3;
    const n_cooldown_time = 1;
    n_current_heat = 0;
  	const n_max_heat = 100;
    
    while ( IsAlive( self ) )
    {     	
    	if ( IsDefined( level.player.missileTurretTarget ) )
        {
    		self SetGunnerTargetEnt( level.player.missileTurretTarget, ( 0, 0, 0 ), 0 );
        	self SetGunnerTargetEnt( level.player.missileTurretTarget, ( 0, 0, 0 ), 1 );
        }
        else
        {
			v_aim_pos = self get_player_aim_pos( 20000 );        	
        	self SetGunnerTargetVec( v_aim_pos, 0 );
        	self SetGunnerTargetVec( v_aim_pos, 1 );            	
        }
        
        if ( level.player ThrowButtonPressed() )
        { 	
            self FireGunnerWeapon(0);
            self FireGunnerWeapon(1);        
                      
            wait ( n_fire_time );
        }
        else
        {        	
            wait ( 0.05 );
        }
    }
}

// self == player's drone
get_player_aim_pos( n_range, e_to_ignore )
{
	v_start_pos = level.player GetEye();
	v_dir = AnglesToForward( self GetTagAngles( "tag_flash" ) );
	v_end_pos = v_start_pos + v_dir * n_range;

	//v_hit_pos = PlayerPhysicsTrace( v_start_pos, v_end_pos, (-10,-10,0), (10,10,0), e_to_ignore );
	v_hit_pos = v_end_pos; // test to see if this helps performance

//	DebugStar( v_hit_pos, 20, (0.9, 0.7, 0.6) );

	return v_hit_pos;
}

// doesn't run a function for distance comparison like getClosest; a_elements = anything with .origin
get_closest_element( v_reference, a_elements ) 
{
	Assert( IsDefined( v_reference ), "v_reference is a required parameter for get_closest_element" );
	Assert( IsDefined( a_elements ), "a_elements is a required parameter for get_closest_element" );
	Assert( ( a_elements.size > 0 ), "get_closest_elements was passed a zero sized array" );
	
	e_closest = a_elements[ 0 ];
	
	n_dist_lowest = 99999;
	for ( i = 0; i < a_elements.size; i++ )
	{
		n_dist_current = DistanceSquared( v_reference, a_elements[ i ].origin );
		
		if ( n_dist_current < n_dist_lowest )
		{
			n_dist_lowest = n_dist_current;
			e_closest = a_elements[ i ];
		}
	}
	
	return e_closest;
}

/* ------------------------------------------------------------------------------------------
RUN OVER ENEMY AI SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == enemy that can be run over by the player's soc-t
run_over()
{
	self endon( "death" );
	
	self.overrideactordamage = ::run_over_override;
	self shoot_at_target_untill_dead( level.player );
}

// self == enemy that can be run over by the player's soc-t
run_over_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if ( str_means_of_death == "MOD_CRUSH" )
	{
		if ( IsPlayer( e_attacker ) && !IsDefined( self.alreadyLaunched ) )
		{
			self.alreadyLaunched = true;
			self StartRagdoll( true );
			
			v_launch = ( 0, 0, 100 );
			if( RandomInt( 100 ) < 40 )
			{
				v_launch += AnglesToForward( e_inflictor.angles ) * 300;
			}
			self LaunchRagdoll( v_launch, "J_SpineUpper" );
		}
	}
	
	return n_damage;
}

/* ------------------------------------------------------------------------------------------
GENERAL SECTION 3 SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == enemy heli that shoots from the main turret
heli_shoot_logic( b_hind )
{
	self endon( "death" );
	
	self.can_shoot = false;
	self thread _can_heli_shoot();
	
	while ( true )
	{
		if ( self.can_shoot )
		{
			if ( IS_TRUE( b_hind ) )
			{
				// for some reason some helicopter's main gun doesn't work throught the turret system
				self FireWeapon( level.vh_salazar_soct );
			}
			else
			{
				self fire_turret( 0 );
			}
		}
		
		wait 0.05;
	}
}

// self == enemy heli that shoots from the main turret
_can_heli_shoot()
{
	self endon( "death" );
	
	// wait for a notify from the path of this vehicle
	while ( true )
	{
		self waittill( "shoot" );
		
		self.can_shoot = true;
		
		self waittill( "stop_shooting" );
		
		self.can_shoot = false;
	}
}

// self == a vehicle
lerp_vehicle_speed( n_current_speed, n_goal_speed, n_time, b_set_max_speed )
{
	self endon( "death" );
	
	s_timer = new_timer();
	n_speed = n_current_speed;
	
	do
	{
		wait 0.05;
		n_current_time = s_timer get_time_in_seconds();
		n_speed = LerpFloat( n_current_speed, n_goal_speed, n_current_time / n_time );
		
		if ( IS_TRUE( b_set_max_speed ) )
		{
			self SetVehMaxSpeed( n_speed );
		}
		else
		{
			self SetSpeed( n_speed, 1000 );
		}
	}
	while ( n_speed != n_goal_speed );
}

enemy_clean_up( n_lowest_unit, n_origin_index, b_less_than, b_clean_vehicles )
{
	a_enemies = GetAIArray( "axis" );
	
	// delete AIs that meets the requiremnts given by the parameters
	foreach ( ai_enemy in a_enemies )
	{
		if ( IS_TRUE( b_less_than ) )
		{
			if ( ai_enemy.origin[ n_origin_index ] < n_lowest_unit )
			{
					ai_enemy Delete();
			}
		}
		else
		{
			if ( ai_enemy.origin[ n_origin_index ] > n_lowest_unit )
			{
				ai_enemy Delete();
			}
		}
	}
	
	// delete vehicles that meets the requiremnts given by the parameters
	if ( IS_TRUE( b_clean_vehicles ) )
	{
		a_vehicles = GetVehicleArray( "axis" );
		
		foreach ( vh_enemy in a_vehicles )
		{
			if ( IS_TRUE( b_less_than ) )
			{
				if ( vh_enemy.origin[ n_origin_index ] < n_lowest_unit )
				{
					if ( !IS_TRUE( vh_enemy.crashing ) )
					{
						vh_enemy Delete();
					}
				}
			}
			else
			{
				if ( vh_enemy.origin[ n_origin_index ] > n_lowest_unit )
				{
					if ( !IS_TRUE( vh_enemy.crashing ) )
					{
						vh_enemy Delete();
					}
				}
			}
		}
	}
}

// self == player
hide_player_hud()
{
	if ( !IsDefined( self.is_hud_hidden ) || IS_FALSE( self.is_hud_hidden ) )
	{
		self SetClientDvars( "cg_drawfriendlynames", 0 );
		self SetClientUIVisibilityFlag( "hud_visible", 0 );
		
		self.is_hud_hidden = true;
	}
}

// self == player
show_player_hud()
{
	if ( IS_TRUE( self.is_hud_hidden ) )
	{
		self SetClientDvars( "cg_drawfriendlynames", 1 );
		self SetClientUIVisibilityFlag( "hud_visible", 1 );
		
		self.is_hud_hidden = false;
	}
}

// self == player's drone
get_correct_switch_node()
{
	if ( IsDefined( self.nd_previous_x3 ) )
	{
		return self.nd_previous_x3;
	}
	
	if ( IsDefined( self.nd_previous_x2 ) )
	{
		return self.nd_previous_x2;
	}
	
	if ( IsDefined( self.nd_previous ) )
	{
		return self.nd_previous;
	}
	
	return self.currentNode;
}

// self == a vehicle
store_previous_veh_nodes()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "reached_node", currentPoint );
		
		self.nd_previous_x3 = self.nd_previous_x2;
		self.nd_previous_x2 = self.nd_previous;
		self.nd_previous = self.currentNode;
	}
}

// self == apache
apache_setup()
{
	self endon( "death" );
	
	level.vh_apache = self;
	self veh_magic_bullet_shield( true );
	
	self play_fx( "apache_spotlight_cheap", self GetTagOrigin( "tag_barrel" ), self GetTagAngles( "tag_barrel" ), undefined, true, "tag_barrel" );
	self thread heli_shoot_logic();
}

purple_smoke()
{
	s_purple_smoke = getstruct( "purple_smoke", "targetname" );
	play_fx( "fx_pak_smk_signal_dist", s_purple_smoke.origin, s_purple_smoke.angles );
}

// self == player's soct
rubberband_potential_soct()
{
	self endon( "death" );
	
	self.vh_target_current = undefined;
	
	level thread generate_potential_enemy_soct_list();
	
	while ( true )
	{
		if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
		{
			if ( IsDefined( level.a_socts_to_ram ) )
			{
				a_potential_soct_to_ram = undefined;
				a_soct_behind_the_player = undefined;
				
				foreach ( vh_enemy in level.a_socts_to_ram )
				{
					// figure out what category this enemy soc-t belongs to
					if ( IsDefined( vh_enemy ) )
					{
						if ( vh_enemy is_soct_in_front_of_player() && is_player_looking_at_soct( vh_enemy ) )
						{
							a_potential_soct_to_ram = add_to_array( a_potential_soct_to_ram, vh_enemy, false );
						}
						else if ( vh_enemy is_soct_behind_the_player() )
						{
							a_soct_behind_the_player = add_to_array( a_soct_behind_the_player, vh_enemy, false );
						}
						else
						{
							vh_enemy ResumeSpeed( VH_ACCELERATION );
						}
					}
				}
					
				if ( IsDefined( a_potential_soct_to_ram ) )
				{
					self thread soct_in_front_of_player_logic( a_potential_soct_to_ram );
				}
				
				if ( IsDefined( a_soct_behind_the_player ) )
				{
					self thread soct_behind_the_player_logic( a_soct_behind_the_player );
				}
			}
		}
		
		wait 0.05;
	}
}

// self == an array of SOC-Ts in front of the player
soct_in_front_of_player_logic( a_potential_soct_to_ram )
{
	vh_soct_to_bump = GetClosest( level.player.origin, a_potential_soct_to_ram );
					
	// only adjust the speed of the soc-t if there is no target or the closest enemy soc-t is not the same
	if ( !IsDefined( self.vh_target_current ) || vh_soct_to_bump != self.vh_target_current )
	{
		// resume speed of the old target if it is not dead
		if ( !is_soct_dead( self.vh_target_current ) )
		{
			self.vh_target_current ResumeSpeed( VH_ACCELERATION );
			self.vh_target_current clear_turret_target_ent_array( 1 );
		}
		
		self.vh_target_current = vh_soct_to_bump;
		vh_soct_to_bump SetSpeed( 55 );
		vh_soct_to_bump add_turret_priority_target( level.player, 1 );
		
		/#
//		set_objective( level.OBJ_RAM, vh_soct_to_bump, "destroy" );
		#/
	}
}

soct_behind_the_player_logic( a_soct_behind_the_player )
{
	// all these enemy SOC-Ts are behind the player
	foreach ( vh_enemy in a_soct_behind_the_player )
	{
		// slow down the SOC-T if it is going to intersect the player
		if ( level.player can_intersect_player( vh_enemy ) )
		{
			vh_enemy SetSpeed( 1 );
		}
		else // speed it if the enemy is not going to hit the player but it is behind
		{
			vh_enemy SetSpeed( 111 );
		}
	}
}

// self == player
can_intersect_player( vh_enemy ) // this function is ment to prevent as much as possible enemy SOC-Ts smashing behind you
{
	const n_dist_diff = 2048;
	
	n_player_start = self.origin - AnglesToForward( self.angles ) * n_dist_diff;
	n_player_end = self.origin + AnglesToForward( self.angles ) * n_dist_diff;
	n_enemy_start = vh_enemy.origin - AnglesToForward( vh_enemy.angles ) * n_dist_diff;
	n_enemy_end = vh_enemy.origin + AnglesToForward( vh_enemy.angles ) * n_dist_diff;
	
	n_denominator = ( n_enemy_end[1] - n_enemy_start[1] ) * ( n_player_end[0] - n_player_start[0] ) - ( n_enemy_end[0] - n_enemy_start[0] ) * ( n_player_end[1] - n_player_start[1] );
	
	// 0 means the lines are parallel and will never intersect
	if ( n_denominator != 0 )
	{
		n_player_numerator = ( n_enemy_end[0] - n_enemy_start[0] ) * ( n_player_start[1] - n_enemy_start[1] ) - ( n_enemy_end[1] - n_enemy_start[1] ) * ( n_player_start[0] - n_enemy_start[0] );
		n_player_t = n_player_numerator / n_denominator;
		
		n_enemy_numerator = ( n_player_end[0] - n_player_start[0] ) * ( n_player_start[1] - n_enemy_start[1] ) - ( n_player_end[1] - n_player_start[1] ) * ( n_player_start[0] - n_enemy_start[0] );
		n_enemy_t = n_enemy_numerator / n_denominator;
		
		// if it is not between 0 and 1, then it means they only intersect pass this line in the future or the past
		if ( 0 <= n_player_t && n_player_t <= 1 && 0 <= n_enemy_t && n_enemy_t <= 1 )
		{
			return true;
		}
	}
	
	return false;
}

// self == enemy soc-t
is_soct_in_front_of_player()
{
	v_player_forward = AnglesToForward( level.player.angles );
	v_enemy_pos = ( self.origin[0], self.origin[1], level.player.origin[2] );
	n_dot_to_player = VectorDot( v_player_forward, VectorNormalize( v_enemy_pos - level.player.origin ) );
	
	const n_dot_min = 0.15;
	if ( n_dot_to_player > n_dot_min )
	{
		return true;
	}
	
	return false;
}

// self == enemy soc-t
is_soct_behind_the_player()
{
	v_player_forward = AnglesToForward( level.player.angles );
	v_enemy_pos = ( self.origin[0], self.origin[1], level.player.origin[2] );
	n_dot_to_player = VectorDot( v_player_forward, VectorNormalize( v_enemy_pos - level.player.origin ) );
	
	const n_dot_max = 0;
	if ( n_dot_to_player < n_dot_max )
	{
		return true;
	}
	
	return false;
}

is_player_looking_at_soct( vh_soct )
{
	const n_dot_min = 0.95;

	v_eye = level.player get_eye();
	v_origin = vh_soct.origin + ( 0, 0, 32 );
	v_delta = AnglesToForward( VectorToAngles( v_origin - v_eye ) );
	v_view = AnglesToForward( level.player GetPlayerAngles() );
	n_dot = VectorDot( v_delta, v_view );
	
	if ( n_dot >= n_dot_min )
	{
		a_bullet_trace_info = BulletTrace( v_eye, v_origin, false, level.vh_player_soct, true, true );
		if ( IsDefined( a_bullet_trace_info[ "entity" ] ) && vh_soct == a_bullet_trace_info[ "entity" ] )
		{
			return true;
		}
	}
	
	return false;
}

generate_potential_enemy_soct_list()
{
	while ( true )
	{
		level waittill_notify_or_timeout( "update_enemy_soct_list", 0.15 );
		
		a_enemy_vehicles = GetVehicleArray( "axis" );
		a_enemy_socts = undefined;
		
		foreach ( vh_enemy in a_enemy_vehicles )
		{
			// if it is an enemy soc-t and is alive
			if ( vh_enemy.vehicletype == "boat_soct_axis" && !is_soct_dead( vh_enemy ) )
			{
				// there are specific vehicles that should not be on this list
				if ( IsDefined( vh_enemy.targetname ) && vh_enemy.targetname != "heli_crash_soct" && vh_enemy.targetname != "hwy_soct_3" )
				{
					a_enemy_socts = add_to_array( a_enemy_socts, vh_enemy, false );
				}
			}
		}
		
		level.a_socts_to_ram = a_enemy_socts;
		a_enemy_vehicles = undefined;
		a_enemy_socts = undefined;
	}
}

is_soct_dead( vh_soct )
{
	if ( !IsDefined( vh_soct ) || vh_soct.model == "veh_t6_mil_soc_t_dead" )
	{
		return true;
	}
	
	return false;
}

// self == enemy's soc-t
enemy_soct_speed_control()
{
	self endon( "death" );
	
	self.n_speed_max = self GetMaxSpeed() / INCHES_PER_SEC_TO_MPH;
	
	while ( true )
	{
		if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
		{
			v_player_forward = AnglesToForward( level.player.angles );
			v_enemy_pos = ( self.origin[0], self.origin[1], level.player.origin[2] );
			n_dot_to_player = VectorDot( v_player_forward, VectorNormalize( v_enemy_pos - level.player.origin ) );
		
			const n_dot_min = 0.14;
			if ( n_dot_to_player < n_dot_min ) // speed up enemy's soc-t if it is behind the player's soc-t
			{
				n_speed_new = 83;
				self SetSpeedImmediate( n_speed_new, VH_ACCELERATION, VH_DECELERATION );
			}
			else
			{
				n_speed_new = self.n_speed_max;
			}
			
			self SetSpeed( n_speed_new, VH_ACCELERATION, VH_DECELERATION );
		}
		
		wait 0.05;
	}
}

// self == enemy soc-t
soct_damaged_fx()
{
	self endon( "death" );
	
	self play_fx( "soct_damaged", undefined, undefined, -1, true, "tag_origin" );
}

/@
"Name: add_scripted_damage_state( <n_percentage_to_change_state>, <func_on_state_change> )"
"Summary: Adds a custom damage state to an entity, such as a vehicle. To add several states, just call this function multiple times. Also supports custom health values (.armor)."
"Module: level"
"CallOn: Any entity that can take damage. Use as a spawn function."
"MandatoryArg: <n_percentage_to_change_state>: Percentage health to change state and run func_on_state_change. Should be between 0 and 1."
"MandatoryArg: <func_on_state_change>: function pointer that points to a function to run when state changes. For instance, it could play a sound and FX."
"Example: vh_presidents_vehicle add_scripted_damage_state( 0.25, ::play_low_health_fx );"
"SPMP: singleplayer"
@/
add_scripted_damage_state( n_percentage_to_change_state, func_on_state_change )  // self = entity that can receive the 'damage' notify
{
	Assert( IsDefined( n_percentage_to_change_state ), "n_percentage_to_change_state is a required argument for add_scripted_damage_state!" );
	Assert( ( ( n_percentage_to_change_state > 0 ) && ( n_percentage_to_change_state < 1 ) ), "add_scripted_damage_state was passed an invalue percentage to change state. Passed " + n_percentage_to_change_state + ", but valid range is between 0 and 1." );
	Assert( IsDefined( func_on_state_change ), "func_on_state_change is a required argument for add_scripted_damage_state!" );
	Assert( ( IsDefined( self.health ) || IsDefined( self.armor ) ), "no .health or .armor parameter found on entitiy" + self GetEntityNumber() + " at position " + self.origin );

	// use .health if no .armor value is used
	b_use_custom_health = IsDefined( self.armor );
	
	n_health_max = self.health;
	
	if ( b_use_custom_health )
	{
		n_health_max = self.armor;
	}
	
	b_state_changed = false;
	n_damage_to_change_state = n_health_max * n_percentage_to_change_state;
	
	while ( !b_state_changed )
	{
		self waittill( "damage", n_damage );
		
		n_current_health = self.health;
		
		if ( b_use_custom_health )
		{
			n_current_health = self.armor;
		}
		
		if ( n_current_health < n_damage_to_change_state )
		{
			b_state_changed = true;
		}
	}
	
	self [[ func_on_state_change ]]();
}

/* ------------------------------------------------------------------------------------------
VO SCRIPTS
-------------------------------------------------------------------------------------------*/
waittill_vo_done()
{
	while ( IS_TRUE( level.harper.is_talking ) )
	{
		wait 0.05;
	}
}

// self == player's soc-t
general_ram_vo()
{
	level endon( "escape_bosses_started" );
	
	const n_time_between_reminder = 9;
	const n_dist_max_sq = 265225; // 512 * 512
	
	n_array_counter = 0;
	
	// this array has to have more than 2 items
	a_ram_vo = array( "harp_ram_them_0", "harp_do_it_man_0", "harp_hit_em_again_0" );
	
	while ( true )
	{
		if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
		{
			// make sure there is a target and it is not dead
			if ( IsDefined( self.vh_target_current ) && !is_soct_dead( self.vh_target_current ) )
			{	
				// only say a ram vo if I think you can actually hit it
				if ( Distance2DSquared( self.vh_target_current.origin, self.origin ) < n_dist_max_sq )
				{
					waittill_vo_done();
					
					level.harper say_dialog( a_ram_vo[ n_array_counter ] );
					
					n_array_counter++;
					
					// suffle the array once all dialog has been said
					if ( n_array_counter == a_ram_vo.size )
					{
						a_ram_vo = random_shuffle( a_ram_vo );
						n_array_counter = 0;
					}
					
					wait n_time_between_reminder;
				}
			}
		}
		
		wait 0.05;
	}
}

general_help_vo()
{
	level endon( "slanted_building_started" );
	
	const n_time_between_reminder = 9;
	const n_dist_max_sq = 262144; // 512 * 512
	
	n_array_counter = 0;
	
	// this array has to have more than 2 items
	a_help_vo = array( "harp_they_re_right_on_us_2", "harp_they_re_closing_fast_0", "harp_gotta_shake_em_sec_0", "harp_one_thing_at_a_time_0", "harp_they_re_all_over_us_0", "harp_eyes_on_the_road_0" );
	
	while ( true )
	{
		n_veh_near_counter = 0;
		a_enemy_vehicles = GetVehicleArray( "axis" );
		
		foreach ( vh_enemy in a_enemy_vehicles )
		{
			// check to see if this soc-t is within a certain distance from the player's soc-t
			if ( Distance2DSquared( level.vh_player_soct.origin, vh_enemy.origin ) < n_dist_max_sq )
			{
				n_veh_near_counter++;
			}
		}
		
		// if there are more than 1 vehicle near the player's soc-t
		if ( n_veh_near_counter > 1 )
		{
			waittill_vo_done();
			
			if ( a_help_vo[ n_array_counter ] == "harp_eyes_on_the_road_0" && level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
			{
				level.harper say_dialog( a_help_vo[ n_array_counter ] );
			}
			else
			{
				level.harper say_dialog( a_help_vo[ n_array_counter ] );
			}
			
			n_array_counter++;
			
			// suffle the array once all dialog has been said
			if ( n_array_counter == a_help_vo.size )
			{
				a_help_vo = random_shuffle( a_help_vo );
				n_array_counter = 0;
			}
			
			wait n_time_between_reminder;
		}
		
		wait 0.05;
	}
}

general_congrats_vo()
{
	level endon( "escape_bosses_started" );
	
	n_array_counter = 0;
	
	// this array has to have more than 2 items
	a_congrats_vo = array( "harp_oh_yeah_0", "harp_that_s_it_0", "harp_way_to_fucking_go_0" );
	
	while ( true )
	{
		level waittill( "takedown" );
		
		waittill_vo_done();
		
		level.harper say_dialog( a_congrats_vo[ n_array_counter ] );
		
		n_array_counter++;
		
		// suffle the array once all dialog has been said
		if ( n_array_counter == a_congrats_vo.size )
		{
			a_congrats_vo = random_shuffle( a_congrats_vo );
			n_array_counter = 0;
		}
		
		wait 0.05;
	}
}

get_the_player_up_drone_vo()
{
	level endon( "apache_showed_up" );
	
	const n_time_between_reminder = 9;
	n_array_counter = 0;
	
	// this array has to have more than 2 items
	a_nag_vo = array( "harp_you_gotta_use_the_dr_0", "harp_switch_to_drone_cont_0", "harp_take_direct_control_0" );
	
	while ( true )
	{	
		if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
		{
			waittill_vo_done();
			
			level.harper say_dialog( a_nag_vo[ n_array_counter ] );
			
			n_array_counter++;
			
			// suffle the array once all dialog has been said
			if ( n_array_counter == a_nag_vo.size )
			{
				a_nag_vo = random_shuffle( a_nag_vo );
				n_array_counter = 0;
			}
			
			wait n_time_between_reminder;
		}
		
		wait 0.05;
	}
}

random_shuffle( a_items ) // this function helps to make sure no dialog is repeats
{
	b_done_shuffling = undefined;
	item = a_items[ a_items.size - 1 ];
	
	while ( !IS_TRUE( b_done_shuffling ) )
	{
		a_items = array_randomize( a_items );
		if ( a_items[0] != item )
		{
			b_done_shuffling = true;
		}
		
		wait 0.05;
	}
	
	return a_items;
}

/* ------------------------------------------------------------------------------------------
DEBUG SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == vehicle that needs its speed be printed on screen
print_speed_in_mph()
{
	self endon( "death" );
	
	while ( true )
	{	
		IPrintLnBold( self GetSpeedMPH() );
		
		wait 0.05;
	}
}

print_number_respawners()
{
	while ( true )
	{
		a_soct = GetEntArray( "generic_enemy_soct", "script_noteworthy" );
		a_soct = array_removeDead( a_soct );
		IPrintLnBold( a_soct.size );
		
		wait 0.05;
	}
}

/* ------------------------------------------------------------------------------------------
CHECKPOINT RESTORE SCRIPTS
-------------------------------------------------------------------------------------------*/
checkpoint_save_restored()
{	
	if ( IsDefined( level.player.vehicle_state ) && level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		nd_start = level.vh_player_soct get_restored_checkpoint_start_node();
		level.vh_player_soct.origin = nd_start.origin;
		level.vh_player_soct thread wait_restore_player_soct( nd_start );
		
		nd_start = level.vh_salazar_soct get_restored_checkpoint_start_node();
		level.vh_salazar_soct.origin = nd_start.origin;
		level.vh_salazar_soct thread wait_restore_salazar_soct( nd_start );
		
		level.n_fail_delay = 1;
		level.vh_player_soct.b_speed_fail = false;
		level notify( "fail_speed_recovered" );
	}
}

// self == soc-t
get_restored_checkpoint_start_node()
{
	if ( IsDefined( self.currentNode.target ) )
	{
		nd_start = GetVehicleNode( self.currentNode.target, "targetname" );
	}
	else
	{
		nd_start = self.currentNode;
	}
	
	return nd_start;
}

// self == player's soc-t
wait_restore_player_soct( nd_start )
{
	wait 0.15;
	
	self ClearVehGoalPos();
	
	if ( IsDefined( nd_start ) )
	{
		level.vh_player_soct DrivePath( nd_start, true );
	}
	
	rpc( "clientscripts/_boat_soct_ride", "soct_save_restore" );	
	
	wait 0.05;
	
	// Spawn drive hands
	ClientNotify( "enter_soct" );
}

// self == salazar soc-t
wait_restore_salazar_soct( nd_start )
{
	wait 0.15;
	
	self ClearVehGoalPos();
	self go_path( nd_start );
}

// self == npc soc-t
wait_restore_npc_soct()
{
	wait 0.15;
	
	self ClearVehGoalPos();
	self go_path( self.currentNode );
}