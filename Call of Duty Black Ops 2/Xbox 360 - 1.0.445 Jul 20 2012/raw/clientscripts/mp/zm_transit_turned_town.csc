#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;


main()
{
	level thread clientscripts\mp\zombies\_zm_game_mode_objects::init_game_mode_objects("turned","town");	
	level thread clientscripts\mp\zombies\_zm_audio::zmbMusLooper();

	level thread clientscripts\mp\zombies\_zm_turned::init();
}
