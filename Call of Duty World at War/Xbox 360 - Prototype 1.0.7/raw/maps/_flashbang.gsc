#include maps\_anim;
#include maps\_utility;
#using_animtree("generic_human");
main()
{	
	assertmsg("_flashbang::main is deprecated, please remove your references!");
	level.player thread flashMonitor();
}


//TODO: Non-hacky rumble.
flashRumbleLoop( duration )
{
	goalTime = getTime() + duration * 1000;
	
	while ( getTime() < goalTime )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
		wait( 0.05 );
	}
}


flashMonitor()
{
	self endon( "death" );
	
	for(;;)
	{
		level.player waittill( "flashbang", percent_distance, percent_angle );
	
		if ( "1" == getdvar( "noflash" ) )
			continue;
	
		if ( percent_angle < 0.5 )
			percent_angle = 0.5;
		else if ( percent_angle > 0.8 )
			percent_angle = 1;
	
		seconds = percent_distance * percent_angle * 6.0;
	
		if ( seconds < 0.25 )
			continue;
	
		level.player shellshock( "flashbang", seconds );
		
		if ( seconds > 2 )
			thread flashRumbleLoop( 0.75 );
		else
			thread flashRumbleLoop( 0.25 );
	}
}
