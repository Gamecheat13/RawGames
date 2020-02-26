/*
 * Created by ScriptDevelop.
 * User: bjoyal
 * Date: 3/8/2012
 * Time: 3:31 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#include common_scripts\utility;
#include maps\_utility;


//#define AFGHANSTINGER_ALT_NAME		"afghanstinger_ff_sp"
#define AFGHANSTINGER_ALT_NAME		"afghanstinger_sp"
#define STINGER_EXPLOSION_RADIUS	256
#define MAX_FIREBALLS				5
#define FIREBALL_SPEED				900
#define FIREBALL_EXPLOSION_RADIUS	64
	

	// initializes everything needed for the weapon
autoexec init()
{
	level._effect[ "_afghanstinger_trail" ] 	= LoadFX( "weapon/rocket/fx_stinger_afgh_trail" );
	level._effect[ "_afghanstinger_impact" ]	= LoadFX( "weapon/rocket/fx_stinger_afgh_trail_impact" );
	
	level._afghanstinger_detonate_function = undefined;	// empty function pointer for levels to use.  Called when a rocket is detonated
	
	flag_init( "detonation_hint_show" );
}


// Waits for the player to fire a missile weapon.  If it is the proper weapon, run the logic
_afghanstinger_fire_watcher()
{
	self endon ( "death" );
	
	while ( true )
	{
		self waittill ( "missile_fire", e_missile, str_weapon );
		
		if ( str_weapon == AFGHANSTINGER_ALT_NAME )
		{
			if ( !flag( "detonation_hint_show" ) )
			{
				e_missile thread mid_air_detonation_hint();
			}
			
			self _afghanstinger_missile_think( e_missile );
		}
	}	
}


mid_air_detonation_hint()
{
	n_index = 0;
	
	screen_message_create( &"SCRIPT_AFGHANSTINGER_DETONATE_HINT" );
	
	self waittill( "death" );
	
	screen_message_delete();
	
	n_index++;
	
	if ( n_index > 1 )
	{
		flag_set( "detonation_hint_show" );
	}
}


_afghanstinger_missile_think( e_missile )
{
	self thread _afghanstinger_airburst_button_check( e_missile );
	self thread _afghanstinger_impact_check( e_missile );
	
	level waittill ( "as_rocket_exploded", v_explode_point );
	
	self thread _afghanstinger_fireballs_think( v_explode_point );
}


// self = the player
_afghanstinger_airburst_button_check( e_missile )
{
	level endon ( "as_rocket_exploded" );
	e_missile endon( "death" );
	
	wait 0.05;

	do
	{
		// wait for the player to let go of the fire button first
		while ( self AttackButtonPressed() )
		{
			wait 0.05;	
		}
		
		// once let go, wait for the player to press it again
		while ( !self AttackButtonPressed() )
		{
			wait 0.05;
		}
		
		RadiusDamage( e_missile.origin, 500, 800, 500, self, "MOD_EXPLOSIVE" );
		
		flag_set( "detonation_hint_show" );

		if ( IsDefined( level._afghanstinger_detonate_function ) )
		{
			e_missile thread [[level._afghanstinger_detonate_function]]();
		}
	}
	
	while( self GetCurrentWeapon() != AFGHANSTINGER_ALT_NAME );	// only explode if we're holding the correct weapon
	
	v_explode_point = e_missile.origin;
	
	e_missile ResetMissileDetonationTime( 0 );	// make the missile detonate right now
	
	level notify ( "as_rocket_exploded", v_explode_point );
}


// get the impact point if we don't air-detonate it
// self = the player
_afghanstinger_impact_check( e_missile )
{
	level endon ( "as_rocket_exploded" );
	
	self waittill( "projectile_impact", e_ent, v_explode_point, n_radius, str_name, n_impact );
	level notify ( "as_rocket_exploded", v_explode_point );
}


// self = the player
_afghanstinger_fireballs_think( v_explode_point )
{
	v_end_pos = v_explode_point - (0, 0, 8000);
	a_ground_trace = BulletTrace( v_explode_point, v_end_pos, false, self );
	
	if( a_ground_trace["position"] == v_end_pos )
	{
		return false;	// ground can't be found.  Play normal explosion, but no extra fireballs
	}

	a_enemies = get_within_range( a_ground_trace["position"], GetAIArray( "axis" ), STINGER_EXPLOSION_RADIUS );
	a_enemies = array_randomize( a_enemies );
	
	for ( i = 0; i < MAX_FIREBALLS; i++ )
	{
		n_z_offset = RandomIntRange( -64, 64 );
		
		if ( i < a_enemies.size && !IsDefined( a_enemies[i].ridingvehicle ) )
		{
			// fireball to guy
			v_guy_origin = a_enemies[i].origin;
			v_start = ( v_guy_origin[0], v_guy_origin[1], v_explode_point[2] + n_z_offset);	// find the spot at the guy's x, y and the explosion's z
		}
		else
		{
			v_fireball_offset = ( RandomIntRange( -STINGER_EXPLOSION_RADIUS, STINGER_EXPLOSION_RADIUS ),
			                          RandomIntRange( -STINGER_EXPLOSION_RADIUS, STINGER_EXPLOSION_RADIUS ),
			                          n_z_offset );

			v_start = v_explode_point + v_fireball_offset;
		}
		
		self thread _fireball_drop( v_start );
	}
}


// self = the player
_fireball_drop( v_start )
{
	m_fireball = spawn_model( "tag_origin", v_start, (0,0,0) );
	PlayFXOnTag( level._effect[ "_afghanstinger_trail" ], m_fireball, "tag_origin" );
	
	v_end_pos = v_start - (0, 0, 8000);
	a_ground_trace = BulletTrace( v_start, v_end_pos, false, m_fireball );
	n_fall_dist = Length( a_ground_trace["position"] - v_start );
	n_fall_time = n_fall_dist / FIREBALL_SPEED;
	
	if ( n_fall_time > 0 )
	{
		n_accel_time = 2;
		if ( n_accel_time > n_fall_time )
		{
			n_accel_time = n_fall_time;
		}
		
		m_fireball MoveTo( a_ground_trace["position"], n_fall_time, n_accel_time );
		m_fireball waittill ( "movedone" );
	}
	
	v_final_pos = m_fireball.origin;
	
	PlayFX( level._effect[ "_afghanstinger_impact" ], v_final_pos, (1,0,0), (0,0,1) );
	
	RadiusDamage( v_final_pos, 200, 200, 100, self, "MOD_PROJECTILE" );
	
	m_fireball Delete();
	
	self thread _fireball_do_damage( v_final_pos );
}


// self = the player
_fireball_do_damage( v_spot )
{
	a_enemies = get_within_range( v_spot, GetAIArray( "axis" ), FIREBALL_EXPLOSION_RADIUS );	
	
	foreach( ai_enemy in a_enemies )
	{
		if( !IsDefined( ai_enemy.ridingvehicle ) )
		{
			ai_enemy DoDamage( ai_enemy.health + 10, v_spot, self );
		}
	}
}