#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include maps\mp\zm_transit_utility;

#insert raw\common_scripts\utility.gsh;

//classic serverscript setup here



main()
{
	// Power Doors Should Only Open Via Turbine Notify
	//------------------------------------------------
	door_triggers = GetEntArray( "electric_door", "script_noteworthy" );
	foreach ( trigger in door_triggers )
	{
		// Door In Power Station Is Exempt
		//--------------------------------
		if ( IsDefined( trigger.script_flag ) && trigger.script_flag == "OnPowDoorWH" )
		{
			continue;
		}
		trigger.power_door_ignore_flag_wait = true;
	}





}