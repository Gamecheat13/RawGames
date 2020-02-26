#include maps\_utility;
#include maps\pel2_util;

// pel2_airfield script

main()
{

	trig = getent( "trig_airfield_spawners_1", "targetname" );
	trig waittill( "trigger" );	

	maps\_status::show_task( "Event3" );

	simple_spawn( "airfield_spawners_1" );

	level thread tank_wave_1();
	level thread tank_wave_2();

//	level thread maps\_mortar::hurtgen_style();
//	
//	wait ( 1 );
//	
//	level notify( "start_mortars" );
	
	// TEMP MORTARS!
	level thread mortar_loop( "orig_mortar_airfield_sw" );
	level thread mortar_loop( "orig_mortar_airfield_nw" );
	level thread mortar_loop( "orig_mortar_airfield_se" );
	level thread mortar_loop( "orig_mortar_airfield_ne" );

}


mortar_loop( mortar_name )
{

	level endon( "stop_airfield_mortars" );

	if( !( IsDefined( level.mortar ) ) )
	{
		error( "level.mortar not defined. define in level script" ); 
	}

	mortars = GetEntArray( mortar_name, "targetname" ); 
	
	if( !mortars.size )
	{
		assertmsg( "no mortar origins found!" );
		return;
	}
	
	while( 1 )
	{
		
		c = RandomInt( mortars.size ); 
		
		wait( 1 + ( RandomFloat( 2 ) ) ); 
		
		mortars[c] maps\_mortar::activate_mortar( 400, 300, 25, undefined, undefined, undefined, false ); 
				
	}
	
}



tank_wave_1()
{

	trig = getent( "trig_tank_wave_1_spawn", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "tank_spawn_1" );
	
	trig = getent( "trig_tank_wave_1_move", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "tank_move_1" );

}



tank_wave_2()
{

	trig = getent( "trig_tank_wave_2_spawn", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "tank_spawn_2" );
	
	trig = getent( "trig_tank_wave_2_move", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "tank_move_2" );

}