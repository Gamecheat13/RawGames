#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include common_scripts\utility;
#include maps\_utility;



#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "hovercraft", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_hovercraft" );
	build_drive( %hovercraft_movement, undefined, 0);

	build_life( 999, 500, 1500 );
	build_team( "allies" );
	level._effect[ "hovercraft_wake_geotrail" ]		 			= LoadFX( "treadfx/hovercraft_wake_geo_trail" );
	level._effect[ "hovercraft_water_splash_loop_water" ]		= LoadFX( "water/hovercraft_side_wake" );
	level._effect[ "hovercraft_water_splash_ring" ]		 		= LoadFX( "water/hovercraft_side_wake_ring" );
	level._effect[ "hovercraft_water_splash_loop_dirt" ]		= LoadFX( "misc/no_effect" );

	level._effect[ "hovercraft_water_splash_ring_plume" ]		= LoadFX( "misc/hover_craft_water_plume" );
	level._effect[ "hovercraft_dirt_splash_ring_plume" ]		= LoadFX( "misc/hover_craft_dirt_plume" );

}

init_local()
{
	thread hovercraft_treadfx();
}

set_vehicle_anims( positions )
{
	return positions;
}

hovercraft_treadfx()
{
	chaser = spawn_tag_origin();
	chaser.angles = ( 0, self.angles[ 1 ], 0 );
	chaser thread hovercraft_treadfx_chaser( self );
	
	self.water_splash_reset_function = ::water_splash_reset_hovercraft;
	thread water_splash();
	
}

//HOVERCRAFT_TREADFX_MOVETIME = .2;
//HOVERCRAFT_TREADFX_MOVETIMEFRACTION = 1 / ( HOVERCRAFT_TREADFX_MOVETIME + .05 );
//HOVERCRAFT_TREADFX_HEIGHTOFFSET = ( 0, 0, 16 );
CHEAP_WATER_SPLASH_DISTANCE = 64000000; //4000*4000

hovercraft_treadfx_chaser( chaseobj )
{
	// self here is the invisible boat for playing leveled wake fx.
	self.origin = chaseobj tag_project( "tag_origin" , -10000 );
	
	wait 0.1;
	
	PlayFXOnTag( getfx( "hovercraft_wake_geotrail" ), self, "tag_origin" );
	wake_enabled = true;

	self NotSolid();
	self Hide();
	rot_angle = ( 0, chaseobj.angles[ 1 ], 0 );
	while ( IsAlive( chaseobj ) )
	{
		self.origin = chaseobj GetTagOrigin( "tag_origin" ) + ( 0, 0, 8 );
		rot_angle = flat_angle( self.angles );
		self.angles = rot_angle;

		if ( IsDefined( chaseobj.surfacetype ) )
		{
			if ( wake_enabled )
			{
				if ( chaseobj.surfacetype != "water" )
				{
					wake_enabled = false;
					StopFXOnTag( getfx( "hovercraft_wake_geotrail" ), self, "tag_origin" );
				}
			}
			else if ( chaseobj.surfacetype == "water" )
			{
				PlayFXOnTag( getfx( "hovercraft_wake_geotrail" ), self, "tag_origin" );
				wake_enabled = true;
			}
		}

		wait( 0.05 );		
	}

	self Delete();
}


WATER_TAG_COUNT = 12;
WATER_TRACE_CACHE_UPDATE_TIME = 2000;

water_splash_reset_hovercraft( info )
{
	info.water_tags = [];
	info.water_tag_trace_cache = [];

	info.water_fx = [];
	info.water_fx[ "water" ] 	= getfx( "hovercraft_water_splash_loop_water" );
	info.water_fx[ "dirt" ] 	= getfx( "hovercraft_water_splash_loop_dirt" );
	info.water_fx[ "concrete" ] = getfx( "hovercraft_water_splash_loop_dirt" );
	info.water_fx[ "mud" ] 		= getfx( "hovercraft_water_splash_loop_dirt" );
	info.water_fx[ "default" ] 	= getfx( "hovercraft_water_splash_loop_dirt" );
	info.water_fx[ "sand" ] 	= getfx( "hovercraft_water_splash_loop_dirt" );
	
	info.water_fx_ring = getfx( "hovercraft_water_splash_ring" );
	
	info.water_fx_plume = [];
	info.water_fx_plume[ "water" ]  	= getfx( "hovercraft_water_splash_ring_plume" );
	info.water_fx_plume[ "dirt" ]  		= getfx( "hovercraft_dirt_splash_ring_plume" );
	info.water_fx_plume[ "concrete" ]  	= getfx( "hovercraft_dirt_splash_ring_plume" );
	info.water_fx_plume[ "mud" ]  		= getfx( "hovercraft_dirt_splash_ring_plume" );
	info.water_fx_plume[ "sand" ]  		= getfx( "hovercraft_dirt_splash_ring_plume" );
	
	info.splash_delay = 0.01;
	info.ring_interval = 5;
	
	tag_int = 0;
	for ( i = 0; i < WATER_TAG_COUNT; i++ )
	{
		
		// these are on the front
		if ( i == 4 || i == 5 || i == 6 )
			continue;
		info.water_tags[ tag_int ] = "TAG_FX_WATER_SPLASH" + i;
		info.water_tag_trace_cache[ tag_int ] = create_trace_cache( tag_int );
		tag_int++;
	}
}

create_trace_cache( interval )
{
	cache = spawnstruct();
	cache.last_time = GetTime() - ( WATER_TRACE_CACHE_UPDATE_TIME - interval );
	cache.trace = [];
	cache.trace[ "position" ] = self.origin;
	return cache;
}


water_splash(  )
{
	self endon ( "death" );
		
	self.touching_water_trigger = true;
	
	dummy = get_dummy();
	
	touching_ent = self.touching_trigger_ent;
	
	if ( !IsDefined( self.water_splash_info ) )
	{
		info = SpawnStruct();
		self.water_splash_info = info;
		[[ self.water_splash_reset_function ]]( info );
	}
	else
		info = self.water_splash_info;
	
	ring_interval = info.ring_interval;
	do_ring = true;
	
	self.water_plume_inc = 0;
	self.water_plume_next = RandomIntRange( 3, 5 );
	
	while ( true )
	{
		wait info.splash_delay;
		
		if( self Vehicle_GetSpeed() < 1 )
			continue;
		
		if( DistanceSquared( self.origin, level.player geteye() ) < CHEAP_WATER_SPLASH_DISTANCE )
			wait info.splash_delay;
			
		for ( i = 0; i < info.water_tags.size; i++ )
			water_splash_single( i );
			
		dummy = get_dummy();
		if ( dummy != self )
			touching_ent = dummy;
		else
			touching_ent = self.touching_trigger_ent;
	}
}

water_splash_single( water_tag_index, do_ring )
{
	info = self.water_splash_info;
	dummy = get_dummy();
	
	
	tag = info.water_tags[ water_tag_index ];
	
	tag_origin = dummy GetTagOrigin( tag );
	start = tag_origin + ( 0, 0, 150 );
	end = tag_origin - ( 0, 0, 150 );
	
	
	trace_cache = info.water_tag_trace_cache[ water_tag_index ];
	
	if ( GetTime() - trace_cache.last_time >= WATER_TRACE_CACHE_UPDATE_TIME )
	{
		trace = BulletTrace( start, end, false, self );
		trace_cache.last_time = GetTime();
		trace_cache.trace = trace;
	}
	else
	{
		trace_cache.trace[ "position" ] = set_z( tag_origin, trace_cache.trace[ "position" ][ 2 ] );
		trace = trace_cache.trace;
	}
	
	if ( !IsDefined( info.water_fx[ trace[ "surfacetype" ] ] ) )
		return;
			
	type = trace[ "surfacetype" ];
	self.surfacetype = type;
	
	if( type != "water" )
		do_ring = false;
			
	start = trace[ "position" ];

	if( trace[ "fraction" ] == 1 )
		return;

	angles = flat_angle( dummy GetTagAngles( tag ) );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );
	
	if( DistanceSquared( start, level.player geteye() ) < CHEAP_WATER_SPLASH_DISTANCE ) // 3000
	{
		if ( IsDefined( self.use_big_splash ) )
		{
			if ( tag == "TAG_FX_WATER_SPLASH3" || tag == "TAG_FX_WATER_SPLASH7" )
			{
				if ( IsDefined( info.water_fx[ type + "_big" ] ) )
				{
					type = type + "_big";
				}
			}
		}

		PlayFX( info.water_fx[ type ], start, up, forward );
	}
	
}

#using_animtree( "generic_human" );


/*QUAKED script_vehicle_hovercraft (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_hovercraft::main( "vehicle_hovercraft", undefined, "script_vehicle_hovercraft" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_hovercraft
sound,vehicle_hovercraft,vehicle_standard,all_sp


defaultmdl="vehicle_hovercraft"
default:"vehicletype" "hovercraft"
default:"script_team" "allies"
*/


