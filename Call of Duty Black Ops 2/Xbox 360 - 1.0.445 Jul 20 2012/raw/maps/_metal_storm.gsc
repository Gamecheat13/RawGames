
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_vehicle_death;
#include maps\_statemachine;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_statemachine.gsh;
#insert raw\animscripts\utility.gsh;

#define PLAYER_FOV 65
#define MIN_GOAL_DIST 300
#define MAX_GOAL_DIST 700
#define MIN_GOAL_HEIGHT 100
#define MAX_GOAL_HEIGHT 350
#define MAX_METALSTORMS 1
#define METALSTORM_ATTACK_RANGE 700

#define NUM_DAMAGE_STATES 4
#define DAMAGE_STATE_THRESHOLD_PCT_1 0.75
#define DAMAGE_STATE_THRESHOLD_PCT_2 0.5
#define DAMAGE_STATE_THRESHOLD_PCT_3 0.25
#define DAMAGE_STATE_THRESHOLD_PCT_4 0.1	

#define SCAN_HEIGHT_OFFSET 40
	
#define TURRET_STATE_SCAN_AT_ENEMY 0
#define TURRET_STATE_SCAN_FORWARD 1
#define TURRET_STATE_SCAN_RIGHT 2
#define TURRET_STATE_SCAN_FORWARD2 3
#define TURRET_STATE_SCAN_LEFT 4
#define NUM_TURRET_STATES 5
	
	
init( variant )
{
	vehicle_add_main_callback( "drone_firestorm", ::main );
	vehicle_add_main_callback( "drone_metalstorm", ::main );
	vehicle_add_main_callback( "drone_metalstorm_rts", ::main );
	vehicle_add_main_callback( "drone_metalstorm_karma", ::main );
	vehicle_add_main_callback( "drone_metalstorm_monsoon", ::main );
	
	vehicle_add_loadfx_callback( "drone_firestorm", ::precache_damage_fx );
	vehicle_add_loadfx_callback( "drone_metalstorm", ::precache_damage_fx );
	vehicle_add_loadfx_callback( "drone_metalstorm_rts", ::precache_damage_fx );
	vehicle_add_loadfx_callback( "drone_metalstorm_karma", ::precache_damage_fx );
	vehicle_add_loadfx_callback( "drone_metalstorm_monsoon", ::precache_damage_fx );
	
	if( IsDefined( variant ) )
	{
		vehicle_add_main_callback( variant, ::main );
		vehicle_add_loadfx_callback( variant, ::precache_damage_fx );
	}
}

// Metal storm short hand commands!! Use these to give explicit orders

precache_damage_fx()
{
	// GDT doesn't support enemy death models right now so manually handing it for the ASD
	PrecacheModel( "veh_t6_drone_asd_alt_dead" );
	
	if ( !IsDefined( level.fx_damage_effects ) )
	{
		level.fx_damage_effects = [];
	}
	
	if ( !IsDefined( level.fx_damage_effects[ self.vehicleType ] ) )
	{
		level.fx_damage_effects[ self.vehicleType ] = [];
	}
	
	for ( i = 0; i < NUM_DAMAGE_STATES; i++ )
		level.fx_damage_effects[ self.vehicleType ][i] = LoadFx( "destructibles/fx_metalstorm_damagestate0" + ( i + 1 ) );
	
	// final explosion fx
	level._effect[ "metalstorm_busted" ]	= LoadFX( "destructibles/fx_metalstorm_damagestate_back01" );
	level._effect[ "metalstorm_explo" ]		= LoadFX( "destructibles/fx_metalstorm_death01a" );
	
	level._effect[ "metalstorm_hit" ]		= LoadFX( "impacts/fx_metalstorm_hit01" );
	level._effect[ "metalstorm_hit_back" ]	= LoadFX( "impacts/fx_metalstorm_hit02" );
	
	level._effect[ "eye_light_friendly" ]	= LoadFX( "light/fx_vlight_metalstorm_eye_grn" );
	level._effect[ "eye_light_enemy" ]		= LoadFX( "light/fx_vlight_metalstorm_eye_red" );
}

main()
{
	self thread metalstorm_think2();
	self thread update_damage_states();
	self thread metalstorm_rocket_recoil();
	self thread metalstorm_death();
	/#self thread metalstorm_debug();#/
	self.overrideVehicleDamage = ::MetalStormCallback_VehicleDamage;
}

metalstorm_think2()
{
	self EnableAimAssist();
	self SetNearGoalNotifyDist( 35 );
	//self SetVehicleAvoidance( true );
	self SetSpeed( 5, 5, 5 );
	
	// Set this on the metal storm to specify the cuttoff distance at which he can see
	self.maxsightdistance = 1024;
	self.turret_state = TURRET_STATE_SCAN_AT_ENEMY;
	self.turret_on_target = false;
	
	if( !IsDefined( self.goalradius ) )
	{
		self.goalradius = 600;
	}
	
	if( !IsDefined( self.goalpos ) )
	{
		self.goalpos = self.origin;
	}
	
	self SetVehGoalPos( self.goalpos, true );

	self.state_machine = create_state_machine( "brain", self );
	main = self.state_machine add_state( "main", undefined, undefined, ::metalstorm_main, undefined, undefined );
	scripted = self.state_machine add_state( "scripted", undefined, undefined, ::metalstorm_scripted, undefined, undefined );
	idle = self.state_machine add_state( "idle", ::metalstorm_idle_enter, undefined, undefined, undefined, undefined );
	patrol = self.state_machine add_state( "patrol", ::metalstorm_patrol_enter, undefined, ::metalstorm_patrol, undefined, undefined );	
	
	main add_connection_by_type( "patrol", 3, CONNECTION_TYPE_ON_NOTIFY, undefined, "patrol" );	
	//main add_connection_by_type( "patrol", 2, CONNECTION_TYPE_ENEMY_VISIBLE, FALSE, undefined );	
	main add_connection_by_type( "idle", 4, CONNECTION_TYPE_ON_NOTIFY, undefined, "stop" );
	main add_connection_by_type( "scripted", 999, CONNECTION_TYPE_ON_NOTIFY, undefined, "enter_vehicle" );	
	
	idle add_connection_by_type( "patrol", 3, CONNECTION_TYPE_ON_NOTIFY, undefined, "patrol" );	
	idle add_connection_by_type( "main", 4, CONNECTION_TYPE_ON_NOTIFY, undefined, "main" );		
	idle add_connection_by_type( "scripted", 999, CONNECTION_TYPE_ON_NOTIFY, undefined, "enter_vehicle" );		
	
	patrol add_connection_by_type( "main", 2, CONNECTION_TYPE_ENEMY_VISIBLE, TRUE, undefined );
	patrol add_connection_by_type( "idle", 4, CONNECTION_TYPE_ON_NOTIFY, undefined, "stop" );	
	patrol add_connection_by_type( "main", 5, CONNECTION_TYPE_ON_NOTIFY, undefined, "main" );
	patrol add_connection_by_type( "scripted", 999, CONNECTION_TYPE_ON_NOTIFY, undefined, "enter_vehicle" );		
	
	scripted add_connection_by_type( "main", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "exit_vehicle" );
	scripted add_connection_by_type( "main", 2, CONNECTION_TYPE_ON_NOTIFY, undefined, "main" );			
	scripted add_connection_by_type( "idle", 3, CONNECTION_TYPE_ON_NOTIFY, undefined, "scripted_done" );
	scripted add_connection_by_type( "scripted", 999, CONNECTION_TYPE_ON_NOTIFY, undefined, "enter_vehicle" );		
	
	// Set the first state
	if ( IsDefined( self.script_startstate ) )
	{
		if( self.script_startstate == "off" )
		{
			self metalstorm_off();
		}
		else
		{
			self.state_machine set_state( self.script_startstate );
		}
	}
	else
	{
		// Set the first state
		metalstorm_start_ai();
	}	
	
	self thread metalstorm_set_team( self.vteam );
	
	// start the update
	self.state_machine update_state_machine( 0.05 );	
}


metalstorm_off()
{
	self.state_machine set_state( "scripted" );
	self lights_off();
	self veh_toggle_tread_fx( 0 );
	self vehicle_toggle_sounds( 0 );
	self veh_toggle_exhaust_fx( 0 );
	self DisableAimAssist();
	target_vec = self.origin + AnglesToForward( ( 0, self.angles[1], 0 ) ) * 1000;
	target_vec = target_vec + ( 0, 0, -500 );
	self SetTargetOrigin( target_vec );		
	self.off = true;
}

metalstorm_on()
{
	self lights_on();
	self veh_toggle_tread_fx( 1 );
	self vehicle_toggle_sounds( 1 );
	self veh_toggle_exhaust_fx( 1 );
	self EnableAimAssist();
	self.off = undefined;
	metalstorm_start_ai();
}

metalstorm_turret_on_vis_target_thread()	// Used for grenade watching
{
	self endon( "death" );
	self endon( "change_state" );
	
	self.turret_on_target = false;
	
	while( 1 )
	{
		self waittill( "turret_on_vistarget" );
		self.turret_on_target = true;
		wait 0.05;
	}
}


metalstorm_turret_on_target_thread()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "turret_on_target_thread" );
	
	self endon( "turret_on_target_thread" );
	
	self.turret_on_target = false;
	
	while( 1 )
	{
		self waittill( "turret_on_target" );
		self.turret_on_target = true;
		wait 0.5;
	}
}

// rotates the turret around until he can see his enemy
metalstorm_turret_scan( scan_forever )
{
	self endon( "death" );
	self endon( "change_state" );
	
	self thread metalstorm_turret_on_target_thread();
	
	self.turretRotScale = 0.35;
	
	while( scan_forever || ( !IsDefined( self.enemy ) || !(self VehCanSee( self.enemy )) ) )
	{
		if( self.turret_on_target )
		{
			self.turret_on_target = false;
			self.turret_state++;
			if( self.turret_state >= NUM_TURRET_STATES )
				self.turret_state = 0;
		}
		
		switch( self.turret_state )
		{	
			case TURRET_STATE_SCAN_AT_ENEMY:
				if( IsDefined( self.enemy ) )
				{
					target_vec = ( self.enemy.origin[0], self.enemy.origin[1], self.origin[2] );
					break;
				}	// else fall through to FORWARD
				
			case TURRET_STATE_SCAN_FORWARD:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1], 0 ) ) * 1000;
				break;
				
			case TURRET_STATE_SCAN_RIGHT:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1] + 90, 0 ) ) * 1000;
				break;
				
			case TURRET_STATE_SCAN_FORWARD2:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1], 0 ) ) * 1000;
				break;
				
			case TURRET_STATE_SCAN_LEFT:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1] - 90, 0 ) ) * 1000;
				break;
		}

		target_vec = target_vec + ( 0, 0, SCAN_HEIGHT_OFFSET );
		self SetTargetOrigin( target_vec );		
		
		wait 0.2;
	}
}

metalstorm_grenade_watcher()
{
	self endon( "death" );
	self endon( "change_state" );
	
	wait 1;
	
	while( 1 )
	{
		level.player waittill( "grenade_fire", grenade );
		
		// coming at me?
		vel_towards_me = VectorDot( grenade GetVelocity(), VectorNormalize( self.origin - grenade.origin) );
		if( vel_towards_me < 100 || !self VehCanSee( grenade ) )
			continue;
		
		wait 0.15;
		
		distSq = 0;
		if( IsDefined( grenade ) )
		{
			distSq = DistanceSquared( self.origin, grenade.origin );
			while( IsDefined( grenade ) && ( distSq > 650 * 650 || distSq < 150 * 150 ) )
			{
				distSq = DistanceSquared( self.origin, grenade.origin );
				wait 0.05;
			}
		}
		
		if( !IsDefined( grenade ) )
			continue;
		
		// double check that the granade is still coming towards me
		vel_towards_me = VectorDot( grenade GetVelocity(), VectorNormalize( self.origin - grenade.origin) );
		if( vel_towards_me < 100 )
			continue;
		
		self SetSpeed( 0 );
		self.turretRotScale = 2;
		self SetTurretTargetEnt( grenade );
		self thread metalstorm_turret_on_vis_target_thread();
		
		wait 0.05;
			
		for( i = 0; i < 6; i++ )
		{	
			self FireWeapon();
			
			if( RandomInt( 100 ) > 40 && self.turret_on_target )
			{
				if( IsDefined( grenade ) )
				{
					grenade ResetMissileDetonationTime( 0 );
				}
				break;
			}
			
			wait 0.15;
		}
		
		self SetSpeed( 5, 5, 5 );
		self ClearTurretTarget();
	}
}

metalstorm_weapon_think()
{
	self endon( "death" );
	self endon( "change_state" );
	
	cant_see_enemy_count = 0;
	
	self thread metalstorm_grenade_watcher();
	
	while ( 1 )
	{
		if ( IsDefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			self.turretRotScale = 1;
			self SetTurretTargetEnt( self.enemy );
			
			if( cant_see_enemy_count >= 2 )
			{
				// found enemy, react by changing goal positions
				self ClearVehGoalPos();
				self notify( "near_goal" );
			}
			cant_see_enemy_count = 0;
		
			//C. Ayers: Changing this to play only when locking onto a player
			if( isPlayer( self.enemy ) )
			{
				self playsound ("wpn_metalstorm_lock_on");
			}
			self thread metalstorm_blink_lights();
			
			wait 1.0;
			
			if ( IsDefined( self.enemy ) && self VehCanSee( self.enemy ) )
			{
				if( IsDefined( self.enemy ) && DistanceSquared( self.origin, self.enemy.origin ) > 800 * 800 )
				{
					self FireGunnerWeapon( 0 );
				}
				else
				{
					self metalstorm_fire_for_time( 2 );
				}
			}
			wait 1.5;
		}
		else
		{	
			cant_see_enemy_count++;
			
			wait 0.5;
			
			if( cant_see_enemy_count > 2 )
			{
				self metalstorm_turret_scan( false );
			}
			else if( cant_see_enemy_count > 1 )
			{
				self ClearTargetEntity();
			}
		}
	}
}

metalstorm_fire_for_time( totalFireTime )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	weaponName = self SeatGetWeapon( 0 );
	fireTime = WeaponFireTime( weaponName );
	time = 0;
	
	while( time < totalFireTime )
	{
		self FireWeapon();
		wait fireTime;
		time += fireTime;
	}
}

metalstorm_start_ai( state )
{
	self.goalpos = self.origin;
	
	if ( !IsDefined( state ) )
		state = "main";
	
	self.state_machine set_state( state );
}

metalstorm_stop_ai()
{
	self.state_machine set_state( "scripted" );
}

metalstorm_main()
{
	self SetSpeed( 5, 5, 5 );	
	self SetVehMaxSpeed( 0 );
	self thread metalstorm_movementupdate();
	self thread metalstorm_weapon_think();	
}

/#
metalstorm_debug()
{
	self endon( "death" );
	
	while ( 1 )
	{
		// no dvar, no debugging
		if( GetDvarInt( "metalstorm_debug" ) == 0 )
		{
			wait( 0.5 );
			continue;
		}
		
		if ( IsDefined( self.goalpos ) )
		{
			DebugStar( self.goalpos, 10, ( 1, 0, 0 ) );
			Circle( self.goalpos, self.goalradius, ( 1, 0, 0 ), false, 10 );
		}
		
		if ( IsDefined( self.enemy ) )
		{
			Line( self.origin + ( 0, 0, 30 ), self.enemy.origin + ( 0, 0, 30 ), ( 1, 0, 0 ), true, 1 );
		}
		
		wait( 0.05 );
	}
}
#/

metalstorm_check_move( position )
{
	results = PhysicsTraceEx( self.origin, position, (-15,-15,-5), (15,15,5), self );
	
	if( results["fraction"] == 1 )
	{
		return true;
	}
	
	return false;
}

path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	wait 1;
	
	while( 1 )
	{
		if ( IsDefined( self.enemy ) && isDefined(self.goal_node) )
		{
			if( Distance2DSquared( self.enemy.origin, self.origin ) < 150 * 150 )
			{
				self.move_now = true;
				self notify( "near_goal" );
			}
			if( Distance2DSquared( self.enemy.origin, self.goal_node.origin ) < 150 * 150 )
			{
				self.move_now = true;
				self notify( "near_goal" );
			}
		}
		
		wait 0.2;
	}
}

waittill_enemy_too_close_or_timeout( time )
{
	self endon( "death" );
	self endon( "change_state" );
	
	while( time > 0 )
	{
		time -= 0.2;
		wait 0.2;
		
		if ( IsDefined( self.enemy ) )
		{
			if( Distance2DSquared( self.enemy.origin, self.origin ) < 150 * 150 )
			{
				return;
			}
			if( Distance2DSquared( self.enemy.origin, self.goal_node.origin ) < 150 * 150 )
			{
				return;
			}
		}
	}
}

metalstorm_movementupdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	self SetVehGoalPos( self.goalpos, true, 2, true );
	
	wait 1;
	
	goalfailures = 0;
	
	while( 1 )
	{
		goalpos = metalstorm_find_new_position();
		if( self SetVehGoalPos( goalpos, false, 2, true ) )
		{
			self thread path_update_interrupt();
			
			goalfailures = 0;
			self waittill_any( "near_goal", "reached_end_node" );
			
			if( IsDefined( self.move_now ) )
			{
				self.move_now = undefined;
				wait 0.1;
			}
			else if( IsDefined( self.enemy ) && self VehCanSee( self.enemy ) )
			{
				waittill_enemy_too_close_or_timeout( RandomFloatRange( 3, 4 ) );
			}
			else
			{
				wait 0.5;
			}
		}
		else
		{
			goalfailures++;
			
			offset = ( RandomFloatRange(-70,70), RandomFloatRange(-70,70), 15 );
			goalpos = self.origin + offset;
			
			if( self metalstorm_check_move( goalpos ) )
			{
				self SetVehGoalPos( goalpos, false );
				self waittill( "near_goal" );
				
				wait 2;
			}
			wait 0.5;
		}	
	}
}

metalstorm_find_new_position()
{
	const sweet_spot_dist = 350;
	
	origin = self.goalpos;
	
	nodes = GetNodesInRadius( self.goalpos, self.goalradius, 0, 128, "Path" );
	
	if( nodes.size == 0 )
	{
		self.goalpos = ( self.goalpos[0], self.goalpos[1], self.origin[2] );
		nodes = GetNodesInRadius( self.goalpos, self.goalradius + 500, 0, 500, "Path" );
	}
	
	best_node = undefined;
	best_score = -999999;
	
	if ( IsDefined( self.enemy ) )
	{
		vec_enemy_to_self = VectorNormalize( FLAT_ORIGIN( self.origin ) - FLAT_ORIGIN( self.enemy.origin ) );
	
		foreach( node in nodes )
		{
			if( !(ISNODEDOUBLEWIDE(node) ) )
			{
				continue;
			}
			
			vec_enemy_to_node = ( FLAT_ORIGIN( node.origin ) - FLAT_ORIGIN( self.enemy.origin ) );
			
			dist_in_front_of_enemy = VectorDot( vec_enemy_to_node, vec_enemy_to_self );
			dist_away_from_sweet_line = Abs( dist_in_front_of_enemy - sweet_spot_dist );
			
			score = 1 + RandomFloat( .15 );

			if( dist_away_from_sweet_line > 100 )
			{
				score -= Clamp( dist_away_from_sweet_line / 800, 0, 0.5 );
			}
			
			if( Distance2DSquared( node.origin, self.enemy.origin ) > 550 * 550 )
			{
				score -= 0.2;
			}
			
			if( Distance2DSquared( self.origin, node.origin ) < 120 * 120 )
			{
				score -= 0.2;
			}
			
			if( IsDefined( node.metal_storm_previous_goal ) )
			{
				score -= 0.2;
				node.metal_storm_previous_goal--;
				if( node.metal_storm_previous_goal == 0 )
				{
					node.metal_storm_previous_goal = undefined;
				}
			}
			
			//DebugStar( node.origin, 100, ( 1, score, 1 ) );
			//Print3d( node.origin, "Score: " + score, ( 1, 1, 1 ), 1, 1, 100 );

			if ( score > best_score )
			{
				best_score = score;
				best_node = node;
			}
		}
	}
	else
	{
		foreach( node in nodes )
		{
			if( !(ISNODEDOUBLEWIDE(node) ) )
			{
				continue;
			}
			
			score = RandomFloat( 1 );			
			
			if( Distance2DSquared( self.origin, node.origin ) < 100 )
			{
				score -= 0.5;
			}
			
			if( IsDefined( node.metal_storm_previous_goal ) )
			{
				score -= 0.2;
				node.metal_storm_previous_goal--;
				if( node.metal_storm_previous_goal == 0 )
				{
					node.metal_storm_previous_goal = undefined;
				}
			}
			
			if( score > best_score )
			{
				best_score = score;
				best_node = node;
			}		
		}
	}
	
	if( IsDefined( best_node ) )
	{
		best_node.metal_storm_previous_goal = 3;
		origin = best_node.origin;
		self.goal_node = best_node;
	}
	
	return origin;
}

// self is vehicle
metalstorm_exit_vehicle()
{
	self waittill( "exit_vehicle", player );
	
	player.ignoreme = false;
	player DisableInvulnerability();
	
	self thread metalstorm_rocket_recoil();
	self ShowPart( "tag_pov_hide" );
	self.goalpos = self.origin;
}

metalstorm_scripted()
{
	self endon( "change_state" );
	
	driver = self GetSeatOccupant( 0 );
	if( IsDefined(driver) )
	{
		self.turretRotScale = 1;
		self DisableAimAssist();
		self HidePart( "tag_pov_hide" );
		self thread vehicle_damage_filter( "firestorm_turret" );
		self thread metalstorm_set_team( driver.team );
		self SetVehMaxSpeed( 7 );
		driver EnableInvulnerability();
		driver.ignoreme = true;
		self thread metalstorm_player_rocket_recoil( driver );
		self thread metalstorm_player_bullet_shake( driver );
		self thread metalstorm_exit_vehicle();
	}
	
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
}

metalstorm_idle_enter()
{
	self endon( "change_state" );
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
}

metalstorm_update_damage_fx()
{
	next_damage_state = 0;
	
	max_health = self.healthdefault;
	if( IsDefined( self.health_max ) )
	{
		max_health = self.health_max;
	}
	
	health_pct = self.health / max_health;
	
	if ( health_pct <= DAMAGE_STATE_THRESHOLD_PCT_1 && health_pct > DAMAGE_STATE_THRESHOLD_PCT_2 )
	{
		next_damage_state = 1;
	}
	else if ( health_pct <= DAMAGE_STATE_THRESHOLD_PCT_2 && health_pct > DAMAGE_STATE_THRESHOLD_PCT_3 )
	{
		next_damage_state = 2;			
	}
	else if ( health_pct <= DAMAGE_STATE_THRESHOLD_PCT_3 && health_pct > DAMAGE_STATE_THRESHOLD_PCT_4 )
	{
		next_damage_state = 3;			
	}
	else if ( health_pct <= DAMAGE_STATE_THRESHOLD_PCT_4 )
	{
		next_damage_state = 4;
	}
	
	if ( next_damage_state != self.current_damage_state )
	{
		if ( IsDefined( level.fx_damage_effects[ self.vehicleType ][ next_damage_state - 1 ] ) )
		{
			fx_ent = self get_damage_fx_ent();
			
			PlayFXOnTag( level.fx_damage_effects[ self.vehicleType ][ next_damage_state - 1 ], fx_ent, "tag_origin" );
		}
		else
		{
			// This will get rid of the fx ent
			get_damage_fx_ent();
		}
		
		self.current_damage_state = next_damage_state;
	}
}

update_damage_states()
{
	self endon( "death" );
	
	self.current_damage_state = 0;
	
	if ( !IsDefined( level.fx_damage_effects[ self.vehicleType ] ) )
		return;
	
	while ( 1 )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, modelAttachTag, part );
		
		if ( !IsDefined( self ) )
			return;
		
		if( mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET" || mod == "MOD_MELEE" )
		{
			if( part == "tag_control_panel" || part == "tag_body_panel" )
			{
				PlayFx( level._effect[ "metalstorm_hit_back" ], point, dir );
			}
			else
			{
				PlayFx( level._effect[ "metalstorm_hit" ], point, dir );
			}
		}
		
		// when taking damage let the turret know if it is scanning to look at our enemy
		// hopefully code will update our enemy
		self.turret_state = TURRET_STATE_SCAN_AT_ENEMY;
		self.turretRotScale = 1.0;
		self.turret_on_target = true;
		
		metalstorm_update_damage_fx();
	}
}

get_damage_fx_ent()
{
	if ( IsDefined( self.damage_fx_ent ) )
		self.damage_fx_ent Delete();

	self.damage_fx_ent = Spawn( "script_model", ( 0, 0, 0 ) );
	self.damage_fx_ent SetModel( "tag_origin" );
	self.damage_fx_ent.origin = self.origin;
	self.damage_fx_ent.angles = self.angles;
	self.damage_fx_ent LinkTo( self, "tag_turret", (0,0,0), (0,0,0) );
	
	return self.damage_fx_ent;
}

#define METAL_STORM_PATROL_SPEED 5
metalstorm_patrol_enter()
{
	self endon( "death" );

	self SetSpeed( METAL_STORM_PATROL_SPEED, 1, 1 );
	//self thread metalstorm_turret_scan();
}

#define PATROL_NODE_LOOK_THRESHOLD 0.875
metalstorm_patrol()
{
	self endon( "death" );
	self endon( "change_state" );

	self thread metalstorm_turret_scan( true );
	
	while ( 1 )
	{
		nodes = GetNodesInRadius( self.goalpos, self.goalradius, 256 );
		
		if ( nodes.size > 0 )
		{
			forward = AnglesToForward( self.angles );
			potential_nodes = [];
			
			for ( i = 0; i < nodes.size; i++ )
			{
				if( !(ISNODEDOUBLEWIDE(nodes[i]) ) )
				{
					continue;
				}
				   
				to_node = VectorNormalize( nodes[i].origin - self.origin );
				if ( VectorDot( forward, to_node ) > PATROL_NODE_LOOK_THRESHOLD )
				{
					potential_nodes[ potential_nodes.size ] = nodes[i];
				}
			}
			
			goal = random( nodes );
			if ( potential_nodes.size > 0 )
			{
				goal = random( potential_nodes );
			}
			
			self SetVehGoalPos( goal.origin, 0, 2 );		
			self waittill( "goal" );
		}
		else
		{
			wait( 0.5 );
		}
	}
}

cleanup_fx_ents()
{
	if( IsDefined( self.damage_fx_ent ) )
	{
		self.damage_fx_ent delete();
	}
}



metalstorm_freeze_blink_lights()
{
	self endon( "death" );
	
	self lights_off();
	wait 0.4;
	self lights_on();
	wait 0.3;
	self lights_off();
	wait 0.4;
	self lights_on();
	wait 0.3;
	self lights_off();
	wait 0.4;
	self lights_on();
	wait 0.3;
	self lights_off();
}

metalstorm_freeze_death( attacker, mod )
{
	self endon( "death" );
	
	level notify( "asd_freezed" );
	
	goalDist = RandomFloatRange( 350, 450 );
	deathGoal = self.origin + AnglesToForward( self.angles ) * goalDist;
	PlayFXOnTag( level._effect[ "freeze_short_circuit" ], self, "tag_origin" );
	self SetModel( "veh_t6_drone_asd_freeze" );
	self SetVehGoalPos( deathGoal, false );
	self thread metalstorm_freeze_blink_lights();
	self SetClientFlag( 13 /*CLIENT_FLAG_GASFREEZE_TOGGLE*/ );
	
	self.turretRotScale = 0.3;
	self SetSpeed( 1 );
	
	wait 1;
	
	self.turretRotScale = 0.1;
	self SetSpeed( 0.5 );
	
	wait 1;
	
	self.turretRotScale = 0.01;
	self SetSpeed( 0.0 );
	
	wait 1;
	
	self CancelAIMove();
	self ClearVehGoalPos();
	self ClearTurretTarget();
		//self SetBrake( 1 );
}

// Death 

metalstorm_death()
{
	wait 0.1;
	
	self notify( "nodeath_thread" );	// Kill off the _vehicle_death::main thread
	
	self waittill( "death", attacker, damageFromUnderneath, weapon, point, dir, mod );
	
	if( IsDefined( self.eye_fx_ent ) )
	{
		self.eye_fx_ent delete();
	}
	
	if( IsDefined( self.delete_on_death ) )
	{
		self cleanup_fx_ents();
		self delete();
		return;
	}
	
	if ( !IsDefined( self ) )
	{
		return;
	}
	
	self maps\_vehicle_death::death_cleanup_level_variables();			
	
	self DisableAimAssist();
	self vehicle_toggle_sounds( false );
	self lights_off();
	self cleanup_fx_ents();
	self veh_toggle_tread_fx( false );
	self veh_toggle_exhaust_fx( false );
	
	
	if( IsDefined(mod) && mod == "MOD_GAS" && IsDefined( level.metalstorm_freeze_death ) )
	{
		self metalstorm_freeze_death( attacker, mod );
	}
	else
	{
		fx_ent = self get_damage_fx_ent();			
		PlayFXOnTag( level._effect[ "metalstorm_explo" ], fx_ent, "tag_origin" );
		self PlaySound( "veh_metalstorm_dying" );
		
		self metalstorm_crash_movement( attacker );
	}
	
	wait 5;
	
	if ( IsDefined( self ) )
	{
		self freeVehicle();
	}
	
	wait 40;
	
	if ( IsDefined( self ) )
	{
		self delete();
	}
}


death_fx()
{
	playfxontag( self.deathfx, self, self.deathfxtag );
	self playsound("veh_metalstorm_sparks");
}

metalstorm_crash_movement( attacker )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	self CancelAIMove();
	self ClearVehGoalPos();	

	self.takedamage = 0;
	self thread death_turret_rotate();
	self.turretRotScale = 1.0;
	
	self PlaySound( "wpn_turret_alert" );
	self thread metalstorm_fire_for_time( RandomFloatRange( 1.5, 4.0 ) );
		
	self SetSpeed( 7 );
	
	deathMove = RandomInt( 8 );
	
	if( deathMove == 0 )
	{
		goalDist = RandomFloatRange( 350, 450 );
		deathGoal = self.origin + AnglesToForward( self.angles ) * goalDist;
	}
	else if( deathMove == 1 )
	{
		goalDist = RandomFloatRange( 350, 450 );
		deathGoal = self.origin + AnglesToForward( self.angles ) * -goalDist;
	}
	else if( deathMove <= 4 )
	{
		self thread spin_crash();
	}
	else //if( deathMove >= 4 )
	{
		if( IsDefined( attacker ) )
		{
			deathGoal = attacker.origin;
		}
		else
		{
			self thread spin_crash();
		}
	}
	
	if( IsDefined( deathGoal ) )
	{
		self SetVehGoalPos( deathGoal, false );
	}
	
	wait 0.5;
	self waittill_any_timeout( 2.5, "near_goal", "veh_collision" );

	if( !IsDefined( self ) )
	{
		return;
	}
	
	self CancelAIMove();
	self ClearVehGoalPos();
	self ClearTurretTarget();
	self SetBrake( 1 );
	
	self thread maps\_vehicle_death::death_radius_damage();
	
	if( self.team == "allies" )
	{
		self thread maps\_vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	}
	else
	{
		self thread maps\_vehicle_death::set_death_model( "veh_t6_drone_asd_alt_dead", self.modelswapdelay );
	}

	self death_fx();
	self LaunchVehicle( ( RandomFloatRange(-20,20), RandomFloatRange(-20,20), 32 ), (RandomFloatRange(-5,5),RandomFloatRange(-5,5),0), true, false );
	self playsound ("exp_metalstorm_vehicle");
	
	self notify( "crash_done" );
}

spin_crash()
{
	self endon( "crash_done" );
	
	turn_rate = 5 + RandomFloatRange( 0, 20 );
	
	if( RandomInt( 100 ) > 50 )
	{
		turn_rate *= -1;
	}
	
	count = 0;
	
	while( IsDefined( self ) )
	{
		deathGoal = self.origin + AnglesToForward( (0, self.angles[1] + turn_rate, 0) ) * 300;
		self SetVehGoalPos( deathGoal, false );
		wait 0.05;
	
		count++;
		if( count % 10 == 0 )
		{
			turn_rate += RandomFloatRange( -10, 10 );
		}
	}	
}


// rotates the turret around until he can see his enemy
death_turret_rotate()
{
	self endon( "crash_done" );
	self endon( "death" );
	
	self.turretRotScale = 1.3;
	
	while( 1 )
	{
		pitch = RandomFloatRange( -60, 20 );
		target_vec = self.origin + AnglesToForward( ( pitch, RandomFloat( 360 ), 0 ) ) * 1000;
		
		driver = self GetSeatOccupant( 0 );
		if( !IsDefined(driver) )	// can't set the target on the player's vehicle
		{
			self SetTargetOrigin( target_vec );
		}
		
		wait RandomFloatRange( 0.3, 0.6 );
		
		if( pitch < 0 && RandomInt( 100 ) > 50 )
		{
			self FireGunnerWeapon( 0 );
		}
	}
}


MetalStormCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if( partName == "tag_control_panel" || partName == "tag_body_panel" )
	{
		iDamage *= 2;
	}
	
	if( sMeansOfDeath == "MOD_GAS" )
	{
		iDamage = self.health + 100;
	}
	
	return iDamage;
}


metalstorm_set_team( team )
{
	self.vteam = team;
	if( IsDefined( self.vehmodelenemy ) )
	{
		if( team == "allies" )
		{
			self SetModel( self.vehmodel );
		}
		else
		{
			self SetModel( self.vehmodelenemy );
		}
	}
	
	if( !IsDefined( self.off ) )
	{
		metalstorm_blink_lights();
	}
}

metalstorm_blink_lights()
{
	self endon( "death" );
	
	self lights_off();
	wait 0.1;
	self lights_on();
	wait 0.1;
	self lights_off();
	wait 0.1;
	self lights_on();
}

metalstorm_player_bullet_shake( player )
{
	self endon( "death" );
	self endon( "recoil_thread" );
	
	while( 1 )
	{
		self waittill( "turret_fire" );
		angles = self GetTagAngles( "tag_barrel" );
		dir = AnglesToForward( angles );
		self LaunchVehicle( dir * -5, self.origin + (0,0,30), false );
		Earthquake( 0.2, 0.2, player.origin, 200 );
	}
}

metalstorm_player_rocket_recoil( player )
{
	self notify( "recoil_thread" );
	self endon( "recoil_thread" );
	self endon( "death" );
	
	while( 1 )
	{
		player waittill( "missile_fire" );
		
		angles = self GetTagAngles( "tag_barrel" );
		dir = AnglesToForward( angles );
		
		self LaunchVehicle( dir * -30, self.origin + (0,0,70), false );
		Earthquake( 0.4, 0.3, player.origin, 200 );
	}
}

metalstorm_rocket_recoil()
{
	self notify( "recoil_thread" );
	self endon( "recoil_thread" );
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "missile_fire" );
		
		angles = self GetTagAngles( "tag_barrel" );
		dir = AnglesToForward( angles );
		
		self LaunchVehicle( dir * -30, self.origin + (0,0,70), false );
	}
}