#include maps\_utility;
#include common_scripts\utility;

main()
{
	thread qk_bus();
}

qk_bus()
{
	precacheShellshock( "quick_kill" );

	for(;;)
	{
		level.player waittill("quick_kill_start");
		// insert something useful here to start the thing
		//iprintlnbold("This is where we start the shock stuff!");

		level.player setbusvolumes( "snd_busvolprio_stealth", "quick_kill", 1.5 );


		
		level.player waittill("quick_kill_done");
		// insert something useful here to end the thing
		//iprintlnbold("This is where we end the shock stuff!");

		level.player deactivatebusvolumes( "snd_busvolprio_stealth", 3 );
	}
}
