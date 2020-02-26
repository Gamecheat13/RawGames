#include maps\_music;
#include maps\_utility;

//
// file: la_2_amb.gsc
// description: level ambience script for la_2
// scripter: 
//



main()
{
	level.sndF35_death_sound = false;
	//level thread cleanup_ground_emitters();
}
radio_chatter()
{
	level endon( "player_ejected" );

	while(1)
	{
		wait (RandomIntRange (1, 6));
		level.player playsound("blk_f35_radio_chatter", "sound_done" );
		level.player waittill ("sound_done");
	}
}
