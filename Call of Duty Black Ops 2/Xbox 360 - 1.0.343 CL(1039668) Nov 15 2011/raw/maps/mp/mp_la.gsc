#include maps\mp\_utility;
#include common_scripts\utility; 

main()
{
	//needs to be first for create fx
	maps\mp\mp_la_fx::main();

	if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) )
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_la_wager");
	}
	else
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_la");
	}

	maps\mp\teams\_teamset_seals::register();

	maps\mp\_load::main();

	maps\mp\mp_la_amb::main();

	// If the team nationalites change in this file, you must also update the level's csc file,
	// the level's csv file, and the share/raw/mp/mapsTable.csv
	maps\mp\teams\_teamset_seals::level_init();

	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

	// Set up some generic War Flag Names.
	// Example from COD5: CALLSIGN_SEELOW_A is the name of the 1st flag in Selow whose string is "Cottage" 
	// The string must have MPUI_CALLSIGN_ and _A. Replace Mapname with the name of your map/bsp and in the 
	// actual string enter a keyword that names the location (Roundhouse, Missle Silo, Launchpad, Guard Tower, etc)

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAPNAME_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAPNAME_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAPNAME_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAPNAME_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAPNAME_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAPNAME_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAPNAME_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAPNAME_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAPNAME_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAPNAME_E";

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	SetDvar( "scr_spawn_enemy_influencer_radius", 2600 );

	//Get conveyer belt functionality working
	level thread conveyer_belt_init();
}

//Starts a thread to alter player's velocity as long as they're in the trigger
conveyer_belt_init()
{
	conveyer_triggers = GetEntArray("conveyer_trig","targetname");
	//IPrintLnBold("lol" + conveyer_triggers.origin);
	//conveyer_triggers thread conveyer_belt_think();
	array_thread( conveyer_triggers, ::conveyer_belt_think );

	/#
	PrintLn( "number conveyers: " + conveyer_triggers.size );
	#/
}

//Self is the conveyer trigger
conveyer_belt_think()
{
	//The trigger targets a script struct. The struct contains angles to determine the force direction.
	trigger_struct = getstruct(self.target, "targetname");
	assert(IsDefined(trigger_struct), "Script struct target is missing on conveyer trigger at " + self.origin);
	
	//Find direction that my trigger is pointed toward
	trigger_angles = AnglesToForward(trigger_struct.angles);

	//conveyer_speed = self.script_float;
	//assert(IsDefined(conveyer_speed), "Script_float key/value pair is missing on conveyer trigger at " + self.origin);

	//Create intensity of conveyer force equal to my script DVar. Store it on my trigger for a seperate function to use.
	self._conveyer_vector = VectorScale(trigger_angles,45 );

	while(1)
	{	
		self waittill("trigger", player);
		
		if(IsPlayer(player))
		{
			self thread trigger_thread(player, ::player_on_conveyer);
		}

		wait .05;
	}	
}

//Self is trigger. Function is ran when player jumps into the trigger.
player_on_conveyer(player, endon_string)
{
	player endon ("death");
	player endon ("disconnect");
	player endon(endon_string);

	while(1)
	{
		player_velocity = player GetVelocity();

		//Don't want jumping player to be pulled by conveyer 
		if (player IsOnGround())
		{
			//Gives player momentum in the direction of the conveyer equal to a dvar I created earlier along with their own momentum
			player SetVelocity(player_velocity + self._conveyer_vector);
		}

		wait .05;	
	}
}