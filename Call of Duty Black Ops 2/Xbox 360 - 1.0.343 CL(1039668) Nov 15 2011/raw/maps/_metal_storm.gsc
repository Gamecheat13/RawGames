
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_statemachine;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_statemachine.gsh;

#define PLAYER_FOV 65
#define MIN_GOAL_DIST 300
#define MAX_GOAL_DIST 700
#define MIN_GOAL_HEIGHT 100
#define MAX_GOAL_HEIGHT 350
#define MAX_METALSTORMS 1
#define METALSTORM_ATTACK_RANGE 1024

#define NUM_DAMAGE_STATES 4
#define DAMAGE_STATE_THRESHOLD_PCT_1 0.75
#define DAMAGE_STATE_THRESHOLD_PCT_2 0.5
#define DAMAGE_STATE_THRESHOLD_PCT_3 0.25
#define DAMAGE_STATE_THRESHOLD_PCT_4 0.1	

init()
{
	vehicle_add_main_callback( "drone_firestorm", ::main );
	vehicle_add_loadfx_callback( "drone_firestorm", ::precache_damage_fx );
}

precache_damage_fx()
{
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
}

main()
{
	self thread metalstorm_think();
	self thread update_damage_states();
}

metalstorm_think()
{
	//self thread metalstorm_patrol();
	//self thread metalstorm_seek();
	
	// TODO: make this a target selection
	//self.enemy = level.player;
	
	self EnableAimAssist();

	self.state_machine = create_state_machine( "brain", self );
	state_patrol = self.state_machine add_state( "patrol", ::metalstorm_patrol_enter, undefined, ::metalstorm_patrol, undefined, undefined );
	state_seek = self.state_machine add_state( "seek", ::metalstorm_seek_enter, undefined, ::metalstorm_seek2, undefined, undefined );
	state_fixed_fire = self.state_machine add_state( "fixed_fire", ::metalstorm_fixed_fire_enter, undefined, ::metalstorm_fixed_fire, undefined, undefined );
	state_flank = self.state_machine add_state( "flank", ::metalstorm_flank_enter, undefined, ::metalstorm_flank, ::metalstorm_can_flank, undefined );
	state_hide = self.state_machine add_state( "hide", ::metalstorm_hide_enter, undefined, ::metalstorm_hide, ::metalstorm_can_hide, undefined );
	state_strafe = self.state_machine add_state( "strafe", ::metalstorm_strafe_enter, undefined, ::metalstorm_strafe, ::metalstorm_can_strafe, undefined );	
	
	// Patrol to seek	
	//state_patrol add_connection_by_type( "dist_check", "seek", 1, CONNECTION_TYPE_ENEMY_DIST, LESS_THAN_OR_EQUAL_TO, METALSTORM_ATTACK_RANGE );
	//state_patrol add_connection_by_type( "damage_check", "seek", 2, CONNECTION_TYPE_ON_NOTIFY, undefined, "damage" );
	state_patrol add_connection_by_type( "enemy_check", "seek", 2, CONNECTION_TYPE_ENEMY_VALID, undefined, undefined );	
	
	// seek to patrol
	state_seek add_connection_by_type( "dist_check", "patrol", 1, CONNECTION_TYPE_ENEMY_DIST, GREATER_THAN, METALSTORM_ATTACK_RANGE * 2 );
	
	// seek to fixed fire
	state_seek add_connection_by_type( "fire_dist_check", "fixed_fire", 2, CONNECTION_TYPE_ENEMY_DIST, LESS_THAN, METALSTORM_ATTACK_RANGE * 0.5 );
	
	// seek to hide
	state_seek add_connection_by_type( "low_health", "hide", 3, CONNECTION_TYPE_HEALTH_PCT, LESS_THAN, 50 );	
	
	// fixed fire to seek
	state_fixed_fire add_connection_by_type( "fire_dist", "seek", 1, CONNECTION_TYPE_ENEMY_DIST, GREATER_THAN, 512 );
	
	// fixed fire to flank 
	state_fixed_fire add_connection_by_type( "enemy_hidden", "flank", 2, CONNECTION_TYPE_ENEMY_VISIBLE, FALSE, undefined );
	
	// fixed fire to strafe
	state_fixed_fire add_connection_by_type( "damage", "strafe", 3, CONNECTION_TYPE_ON_NOTIFY, undefined, "damage" );
	
	// fixed fire to hide
	state_fixed_fire add_connection_by_type( "low_health", "hide", 4, CONNECTION_TYPE_HEALTH_PCT, LESS_THAN, 50 );	

	// flank to fixed fire
	state_flank add_connection_by_type( "flank_done", "fixed_fire", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "main_finished" );
	
	// hide to seek
	state_hide add_connection_by_type( "hide_done", "seek", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "main_finished" );	
	
	// hide to patrol
	state_hide add_connection_by_type( "hide_done", "patrol", 2, CONNECTION_TYPE_ENEMY_DIST, GREATER_THAN, METALSTORM_ATTACK_RANGE * 2 );
	
	// strafe to fixed fire
	state_strafe add_connection_by_type( "strafe_done", "fixed_fire", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "main_finished" );
	
	// strafe to hide
	state_strafe add_connection_by_type( "strafe_low_health", "hide", 1, CONNECTION_TYPE_HEALTH_PCT, LESS_THAN, 25 );	
	
	// Set the first state
	self.state_machine set_state( "patrol" );
	
	// start the update
	self.state_machine update_state_machine();
}

metalstorm_patrol_enter()
{
	self endon( "death" );

	self notify( "lost_target" );	
	self SetSpeed( 5, 1, 1 );
	self thread metalstorm_turret_scan();
}

#define PATROL_NODE_LOOK_THRESHOLD 0.875
metalstorm_patrol()
{
	self endon( "death" );
	self endon( "change_state" );

	while ( 1 )
	{
		nodes = GetNodesInRadius( self.origin, 512, 256 );
		
		forward = AnglesToForward( self.angles );
		potential_nodes = [];
		
		for ( i = 0; i < nodes.size; i++ )
		{
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
}

metalstorm_seek_enter()
{
	self endon( "death" );
	self endon( "change_state" );

	self.firing = false;	
	self SetSpeed( 20, 10, 10 );
	//self SetVehMaxSpeed( 25 );
	self SetTurretTargetEnt( level.player, ( 0, 0, 60 ) );
}

metalstorm_seek()
{
	self endon( "death" );
	self endon( "change_state" );

	self thread metalstorm_fire();	
	
	while ( 1 )
	{
		nodes = GetNodesInRadius( self.enemy.origin, 512, 256 );
		
		goal = random( nodes );
		
		self SetVehGoalPos( goal.origin, 1, 2 );		
		self SetNearGoalNotifyDist( 100 );
		self waittill( "near_goal" );

		wait( 2 );
	}
}

metalstorm_seek2()
{
	self endon( "death" );
	self endon( "change_state" );

	while ( 1 )
	{
		if ( !IsDefined( self ) || IS_TRUE( self.isacorpse ) )
			return;
	
		self SetVehGoalPos( level.player.origin, 1, 2 );
		wait( 1 );
	}
}

metalstorm_fixed_fire_enter()
{
	self CancelAIMove();
}

metalstorm_fixed_fire()
{
	self endon( "death" );
	self endon( "change_state" );
	
	self SetTurretTargetEnt( level.player, ( 0, 0, 60 ) );	
	self thread metalstorm_fire();
}

metalstorm_can_flank()
{
	if ( !IsDefined( self.enemy ) )
		return false;
	
	start = self.enemy.origin + ( 0, 0, 30 );
	right = AnglesToRight( self.enemy.angles );
	
	point1 = start + right * 256;
	point2 = start - right * 256;	

	right_nodes = GetNodesInRadius( point1, 128, 0 );	
	left_nodes = GetNodesInRadius( point2, 128, 0 );

	if ( right_nodes.size == 0 && left_nodes.size == 0 )
		return false;
	
	random_left = ( left_nodes.size != 0 ? random( left_nodes ) : undefined );
	random_right = ( right_nodes.size != 0 ? random( right_nodes ) : undefined );
	
	if ( IsDefined( random_right ) && BulletTracePassed( start, random_right.origin, false, self.enemy ) )
	{
		self.flank_point = random_right.origin;
		return true;
	}
	
	if ( IsDefined( random_left ) && BulletTracePassed( start, random_left.origin, false, self.enemy ) )
	{
		self.flank_point = random_left.origin;		
		return true;	
	}
	
	self.flank_point = undefined;
	
	return false;
}

metalstorm_flank_enter()
{
	self SetSpeed( 20, 10, 10 );
	self SetTurretTargetEnt( level.player, ( 0, 0, 60 ) );
}

metalstorm_flank()
{
	self endon( "change_state" );
	
	if ( IsDefined( self.flank_point ) )
	{
		self SetVehGoalPos( self.flank_point, 1, 2 );
		self waittill( "goal" );
	}

	self notify( "main_finished" );
}

metalstorm_fire()
{
	self endon( "death" );
	self endon( "change_state" );
	
	while ( 1 )
	{
		self.firing = true;
		self thread maps\_turret::fire_turret_for_time( 2, 0 );
		wait( 2 );
		self.firing = false;
	}
}

#define SCAN_FOV 90
#define SCAN_HEIGHT_OFFSET 40
#define SCAN_VEL 100
#define SCAN_WAIT_TIME 1
metalstorm_turret_scan()
{
	self endon( "death" );
	self endon( "change_state" );
	
	scan_yaw = -SCAN_FOV;
	scan_dir = 1;
	scan_height_offset = SCAN_HEIGHT_OFFSET;
	
	while ( 1 )
	{
		target_vec = self.origin + AnglesToForward( ( 0, self.angles[1] + scan_yaw, 0 ) ) * 1000;
		target_vec = target_vec + ( 0, 0, 60 + scan_height_offset );
		
		self SetTargetOrigin( target_vec );
		
		scan_yaw += scan_dir * SCAN_VEL * 0.05;
		scan_yaw = AngleClamp180( scan_yaw );
		if ( scan_yaw >= SCAN_FOV || scan_yaw <= -SCAN_FOV )
		{
			scan_yaw = Clamp( scan_yaw, -SCAN_FOV, SCAN_FOV );
			scan_dir *= -1;
			scan_height_offset = RandomIntRange( 0, SCAN_HEIGHT_OFFSET );
			wait( SCAN_WAIT_TIME );
		}
		
		wait( 0.05 );
	}
}

#define SPRAY_FOV 5
#define SPRAY_HEIGHT_OFFSET 40
#define SPRAY_VEL 50
metalstorm_turret_spray()
{
	self endon( "death" );
	self endon( "change_state" );
	
	spray_yaw = 0;
	spray_dir = 1;
	spray_height_offset = SPRAY_HEIGHT_OFFSET;
	
	while ( 1 )
	{
		enemy_yaw = AngleClamp180( get2DYaw( self.origin, self.enemy.origin ) );
		
		target_vec = self.origin + AnglesToForward( ( 0, enemy_yaw + spray_yaw, 0 ) ) * 1000;
		target_vec = target_vec + ( 0, 0, 60 + spray_height_offset );
		
		self SetTargetOrigin( target_vec );
		
		spray_yaw += spray_dir * SPRAY_VEL * 0.05;
		spray_yaw = AngleClamp180( spray_yaw );
		if ( spray_yaw >= SPRAY_FOV || spray_yaw <= -SPRAY_FOV )
		{
			spray_yaw = Clamp( spray_yaw, -SPRAY_FOV, SPRAY_FOV );
			spray_dir *= -1;
			spray_height_offset = RandomIntRange( 0, SPRAY_HEIGHT_OFFSET );
		}
		
		wait( 0.05 );
	}
}

metalstorm_can_hide()
{
	if ( !IsDefined( self.enemy ) )
		return false;
	
	cover_nodes = GetCoverNodeArray( self.origin, 512 );
	enemy_origin = self.enemy.origin;
	
	for ( i = 0; i < cover_nodes.size; i++ )
	{
		node_origin = ( cover_nodes[i].origin[0], cover_nodes[i].origin[1], cover_nodes[i].origin[2] + 30 );
		enemy_origin = ( enemy_origin[0], enemy_origin[1], cover_nodes[i].origin[2] );
		
		if ( !BulletTracePassed( node_origin, enemy_origin, false, self ) )
		{
			self.evade_node = cover_nodes[i];
			return true;
		}
	}
	
	return false;
}

metalstorm_hide_enter()
{
	self SetSpeed( 30, 10, 10 );
}

metalstorm_hide()
{
	self endon( "change_state" );
	
	if ( IsDefined( self.evade_node.origin ) )
	{
		self SetVehGoalPos( self.evade_node.origin, 1, 2 );
		self waittill( "goal" );
	}
	
	//self thread metalstorm_fire();
	wait( 3 );
	self.health = self.maxhealth;
	self notify( "main_finished" );
}

metalstorm_can_strafe()
{
	if ( !IsDefined( self.enemy ) )
		return false;
	
	start = self.origin + ( 0, 0, 30 );
	right = AnglesToRight( self.angles );
	
	point1 = start + right * 256;
	point2 = start - right * 256;	

	right_nodes = GetNodesInRadius( point1, 128, 0 );	
	left_nodes = GetNodesInRadius( point2, 128, 0 );

	if ( right_nodes.size == 0 && left_nodes.size == 0 )
		return false;
	
	random_left = ( left_nodes.size != 0 ? random( left_nodes ) : undefined );
	random_right = ( right_nodes.size != 0 ? random( right_nodes ) : undefined );
	
	if ( IsDefined( random_right ) && BulletTracePassed( start, random_right.origin, false, self ) )
	{
		self.strafe_point = random_right.origin;
		return true;
	}
	
	if ( IsDefined( random_left ) && BulletTracePassed( start, random_left.origin, false, self ) )
	{
		self.strafe_point = random_left.origin;		
		return true;	
	}
	
	self.strafe_point = undefined;
	
	return false;
}

metalstorm_strafe_enter()
{
	self SetSpeed( 3, 1, 1 );
	self ClearTurretTarget();
}

metalstorm_strafe()
{
	self endon( "change_state" );

	self thread metalstorm_turret_spray(); 
	self thread metalstorm_fire();
	
	if ( IsDefined( self.strafe_point ) )
	{
		self SetVehGoalPos( self.strafe_point, 1, 2 );
		self waittill( "goal" );
	}

	self notify( "main_finished" );
}

update_damage_states()
{
	self endon( "death" );
	
	current_damage_state = 0;
	next_damage_state = 0;
	
	if ( !IsDefined( level.fx_damage_effects[ self.vehicleType ] ) )
		return;
	
	self thread delete_damage_state_effect_on_death();
	
	while ( 1 )
	{
		self waittill( "damage" );
		
		if ( !IsDefined( self ) )
			return;
		
		health_pct = self.health / self.maxhealth;
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
		
		if ( next_damage_state != current_damage_state )
		{
			if ( IsDefined( level.fx_damage_effects[ self.vehicleType ][ next_damage_state - 1 ] ) )
			{
				fx_ent = self get_damage_fx_ent();
				
				PlayFXOnTag( level.fx_damage_effects[ self.vehicleType ][ next_damage_state - 1 ], fx_ent, "tag_origin" );
				current_damage_state = next_damage_state;
			}
		}
	}
}

get_damage_fx_ent()
{
	if ( IsDefined( self.fx_damage_state_ent ) )
		self.fx_damage_state_ent Delete();

	self.fx_damage_state_ent = Spawn( "script_model", ( 0, 0, 0 ) );
	self.fx_damage_state_ent SetModel( "tag_origin" );
	self.fx_damage_state_ent.origin = self.origin;
	self.fx_damage_state_ent.angles = self.angles;
	self.fx_damage_state_ent LinkTo( self );
	
	return self.fx_damage_state_ent;
}

delete_damage_state_effect_on_death()
{
	self waittill( "death" );
	
	if ( IsDefined( self.fx_damage_state_ent ) )
		self.fx_damage_state_ent Delete();
}