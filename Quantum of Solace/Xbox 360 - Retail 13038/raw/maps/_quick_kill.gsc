#include maps\_utility;
#include common_scripts\utility;

main()
{
	level.player qk_bus();
}

qk_bus()
{
	precacheShellshock( "quick_kill" );

	for(;;)
	{
		level.player waittill("quick_kill_start");
		// insert something useful here to start the thing
		//iprintlnbold("This is where we start the shock stuff!");
		//self setbusvolumes( "snd_busvolprio_stealth", "stealth", 3 );
		
		level.player waittill("quick_kill_done");
		// insert something useful here to end the thing
		//self deactivatebusvolumes( "snd_busvolprio_stealth", 3);
		//iprintlnbold("This is where we end the shock stuff!");
	}
}
