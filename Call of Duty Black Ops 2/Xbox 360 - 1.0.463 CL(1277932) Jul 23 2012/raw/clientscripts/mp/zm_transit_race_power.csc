#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;


main()
{
	clientscripts\mp\zm_transit::gamemode_common_setup( "race", "power", "zm_encounters_town", 2 );
	
	level thread setup_power_race_arrows();
	level thread clean_up_power_race_arrows();	
		 	
}

setup_power_race_arrows()
{
	level._race_arrows = [];
	all_structs = level.struct;
	foreach(struct in all_structs)
	{
		if(!isDefined(struct.name) || struct.name != "power_arrows")
		{
			continue;
		}
		players = GetLocalPlayers();
		for(x=0;x<players.size;x++)
		{		
			arrow = spawn(x,struct.origin,"script_model");
			if(isDefined(struct.angles))
			{
				arrow.angles= struct.angles;
			}
			if(isDefined(struct.script_parameters))
			{
				arrow setmodel(struct.script_parameters);
			}
			level._race_arrows[level._race_arrows.size] = arrow;
		}
	}
	level thread blink_race_arrows(level._race_arrows,"stop_blink");	

}

set_arrow_model(arrows,model)
{
	for(i=0;i<arrows.size;i++)
	{
		arrows[i] setmodel(model);
		if( model == "p6_zm_sign_neon_arrow_on_green" )
		{
			arrows[i] playsound( 0, "zmb_arrow_buzz" );
		}
	}	
}

blink_race_arrows(arrows,end_on)
{
	level endon("end_race");
	wait(.1);
	
	level endon(end_on);
	
	while(1)
	{
		set_arrow_model(arrows,"p6_zm_sign_neon_arrow_on_green");
		
		wait(randomfloatrange(.1,.25));

		set_arrow_model(arrows,"p6_zm_sign_neon_arrow_off");

		wait(randomfloatrange(.1,.25));	
	}
	
}

clean_up_power_race_arrows()
{
	level waittill("end_race");
	wait(3);
		
	foreach(arrow in level._race_arrows)
	{
		if(isDefined(arrow))
		{
			arrow delete();
		}
	}
}