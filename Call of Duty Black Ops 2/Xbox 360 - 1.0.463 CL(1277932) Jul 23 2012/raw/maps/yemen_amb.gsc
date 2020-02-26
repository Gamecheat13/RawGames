#include common_scripts\utility;
#include maps\_utility;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
}

yemen_drone_control_tones( activate )
{
	if( activate )
	{
		level thread play_drone_control_tones();
	}
	else
	{
		level notify( "stop_drone_control_tones" );
	}
}
play_drone_control_tones()
{
	level endon( "stop_drone_control_tones" );
	
	level waitfor_enough_drones();
	
	while(1)
	{
		level thread play_drone_control_tones_single();
		
		wait(randomintrange( 19, 39 ) );
	}
}
waitfor_enough_drones()
{
	level endon( "stop_drone_control_tones" );
	
	while(1)
	{
		drones = get_vehicle_array( "veh_t6_drone_quad_rotor_sp", "model" );
		if( !isdefined( drones ) || drones.size <= 3 )
		{
			wait(1);
		}
		else
		{
			break;
		}
	}
}
play_drone_control_tones_single()
{
	drones = get_vehicle_array( "veh_t6_drone_quad_rotor_sp", "model" );
		
	if( drones.size <= 3 )
		return;
		
	drone = drones[randomintrange(0,drones.size)];
	drone playsound( "veh_qr_tones_activate" );
		
	wait(4);
		
	drones = get_vehicle_array( "veh_t6_drone_quad_rotor_sp", "model" );
	
	if( isdefined( drone ) )
	{
		ArrayRemoveValue( drones, drone );
	}
	
	array_thread( drones, ::play_drone_reply );
}
play_drone_reply()
{
	wait(randomfloatrange(.1,.85));
	
	if( isdefined( self ) )
	{
		self playsound( "veh_qr_tones_activate_reply" );
	}
}