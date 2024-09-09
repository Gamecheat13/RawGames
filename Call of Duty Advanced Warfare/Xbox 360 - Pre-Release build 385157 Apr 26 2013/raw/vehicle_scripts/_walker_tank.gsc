#include maps\_vehicle;
#include common_scripts\utility;

main( model, type, classname )
{
	build_template( "walker_tank", model, type, classname );
	build_localinit( ::init_local );
	build_shoot_shock( "tankblast_walker" );
	build_treadfx();

	build_life( 999, 500, 1500 );

	build_team( "axis" );
	
	PrecacheTurret("enemy_walker_top_left_turret");
	PreCacheModel( "vehicle_walker_tank_dstrypv" );
	
	build_bulletshield( true );
	build_grenadeshield( true );
	//build_turret( info,                          tag,                    model,                                  maxrange,  defaultONmode, deletedelay, defaultdroppitch, defaultdropyaw, offset_tag )
	build_turret( "enemy_walker_belly_turret",     "TAG_TURRET_BELLY",     "vehicle_walker_tank_turret_belly",     undefined, undefined,     undefined,   0,                0,              undefined  );
	build_turret( "enemy_walker_top_left_turret",  "TAG_TURRET_TOP_LEFT",  "vehicle_walker_tank_turret_top_left",  undefined, undefined,     undefined,   0,                0,              undefined  );
	build_turret( "enemy_walker_top_right_turret", "TAG_TURRET_TOP_RIGHT", "vehicle_walker_tank_turret_top_right", undefined, undefined,     undefined,   0,                0,              undefined  );
}

init_local()
{
	handle_vehicle_ai();
	self.shock_distance = 1500;
	self.black_distance = 1500;
}

handle_vehicle_ai()
{
	self thread vehicle_scripts\_vehicle_turret_ai::vehicle_turret_settings_target( 1.5 );
	self thread vehicle_scripts\_vehicle_turret_ai::vehicle_turret_settings_shoot( 3, 5, 3, 5 );
	self thread vehicle_scripts\_vehicle_turret_ai::vehicle_turret_default_ai();
	
	self thread setup_mg_turrets();
}

setup_mg_turrets()
{
	waittillframeend;
	waittillframeend;
	
	foreach( turret in self.mgturret )
	{
		turret thread walker_tank_turret_think();
		turret thread stop_firing_for_death_anim( self );
	}
}

walker_tank_turret_think()
{
	self endon( "death" );
	self endon( "stop_vehicle_turret_ai" );
	
	while( true )
	{
		targets = GetAiArray( "allies" );
		targets = array_add( targets, level.player );
		targets = SortByDistance( targets, self.origin );
		
		for( i = 0; i < targets.size; i++ )
		{
			if( !isDefined( targets[ i ].claimed_walker_turret_target ) )
			{
				self.claimed_walker_turret_target = true;
				self thread fire_at_target( targets[ i ] );
				break;
			}
		}
		
		self waittill( "acquire_new_target" );
	}
}

fire_at_target( target )
{	
	self endon( "death" );
	self endon( "stop_vehicle_turret_ai" );
	
	min_burst_time = 2;
	max_burst_time = 4;
	burst_time = RandomFloatRange( min_burst_time, max_burst_time );
	
	min_burst_delay = 2;
	max_burst_delay = 5;
	burst_delay = RandomFloatRange( min_burst_delay, max_burst_delay );
	
	time_firing = 0;
	
	self SetTurretTeam( "axis" );
	self SetMode( "manual" );
	self SetTargetEntity( target );
	self TurretFireEnable();	
	self StartFiring();
	
	while( time_firing < burst_time && isAlive( target ) )
	{	
		time_firing += 0.05;
		wait( 0.05 );
	}
	
	self StopFiring();
	self TurretFireDisable();
	self ClearTargetEntity();
	if( isAlive( target ) )
	{
		target.claimed_walker_turret_target = undefined;
	}
	
	wait( burst_delay );
	self notify( "acquire_new_target" );
}

stop_firing_for_death_anim( walker )
{
	walker waittill( "stop_vehicle_turret_ai" );
	
	self StopFiring();
	self TurretFireDisable();
	self ClearTargetEntity();
}

/*QUAKED script_vehicle_walker_tank (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER
This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_walker_tank::main( "vehicle_walker_tank", undefined, "script_vehicle_walker_tank" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_walker_tank

defaultmdl="vehicle_walker_tank"
default:"vehicletype" "walker_tank"
default:"script_team" "axis"
*/
