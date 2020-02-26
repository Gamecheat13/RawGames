//
// file: frontend_amb.gsc
// description: level ambience script for frontend
// scripter: 
//
#include maps\_music;
#include maps\_utility;
#include common_scripts\utility; 


main()
{
	level thread start_front_music_delay();
}
start_front_music_delay()
{
	if( level.console )
		wait(0.5);
	else
		wait( 1 );

	setmusicstate ("FRONT_END_MAIN");

}
