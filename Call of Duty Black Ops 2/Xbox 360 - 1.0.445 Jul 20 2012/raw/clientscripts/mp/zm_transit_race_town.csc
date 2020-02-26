#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;


main()
{
	clientscripts\mp\zm_transit::gamemode_common_setup( "race", "town", "zm_encounters_town", 2 );
	
	//level thread clientscripts\mp\zombies\_zm_game_mode_objects::init_game_mode_objects("race","town");
	//level thread clientscripts\mp\zombies\_zm_audio::zmbMusLooper();


	level thread clean_up_doors_and_signs_on_race_end();
	level._team_1_current_door = 1;
	level._team_2_current_door = 1;	
	level thread race_town_doors();

	
	/*
	players = GetLocalPlayers();
	for(i=0;i<players.size;i++)
	{
		localclientnum = players[i] GetLocalClientNumber();
		if(!isDefined(localclientnum))
		{
			return;
		}
		visionsetnaked(localclientnum,"zm_encounters_town",5);
		SetWorldFogActiveBank(localclientnum,2);
	}
	*/
}



race_town_doors()
{
	wait(1);
	level._race_doors = [];
	level._race_arrows = [];
	
	//team 1
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("1",1);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("1",2);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("1",3);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("1",4);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("1",5);
	
	// team 2
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("2",1);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("2",2);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("2",3);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("2",4);
	clientscripts\mp\zombies\_zm_game_mode_objects::door_init("2",5);
}