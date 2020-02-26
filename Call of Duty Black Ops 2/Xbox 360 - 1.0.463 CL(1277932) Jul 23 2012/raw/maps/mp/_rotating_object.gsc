#include maps\mp\_utility;
#include common_scripts\utility;

/*
This script sets up functionality in multiplayer where an object can be rotated. The majority of the script is set up in _rotating_object.csc.
*/

//Sets up my dvar for my csc.
init()
{
	rotating_objects = GetEntArray("rotating_object", "targetname");
	
	if(IsDefined(rotating_objects))
	{
		set_dvar_int_if_unset( "scr_rotating_objects_secs", 12 );
		/#
		if(!IsDefined(GetDvar( "scr_rotating_objects_secs")))
		{
			PrintLn("scr_rotating_objects_secs is undefined");
		}
		#/		
	}
}

