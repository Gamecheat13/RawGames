//
// file: mp_nuked_amb.csc
// description: clientside ambient script for mp_nuked: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	thread clientscripts\mp\mp_nuked_amb_platform::main();
	
	thread pa_think("notify_20","amb_pa_notify_20");
	thread pa_think("notify_10","amb_pa_notify_10");
	thread pa_think("notify_5","amb_pa_notify_5");
	thread pa_think("notify_1","amb_pa_notify_1");
	thread pa_think("notify_stones","mus_sympathy_for_the_devil");
 	thread snd_fx_create();
	
declareAmbientRoom ("default");
	setAmbientRoomReverb ("default", "nuked_outdoor", 1, 1);
	setAmbientRoomContext( "default", "ringoff_plr", "outdoor" );
	
declareAmbientRoom ("int_room");
	setAmbientRoomReverb ("int_room", "nuked_house", 1, 1);
	setAmbientRoomContext( "int_room", "ringoff_plr", "indoor" );
	
declareAmbientRoom ("truck_room");
	setAmbientRoomReverb ("truck_room", "nuked_truck", 1, 1);
	setAmbientRoomContext( "truck_room", "ringoff_plr", "indoor" );

declareAmbientRoom ("garage");
	setAmbientRoomReverb ("garage", "nuked_garage", 1, 1);
	setAmbientRoomContext( "garage", "ringoff_plr", "outdoor" );
	
declareAmbientRoom ("wood_room");
	setAmbientRoomReverb ("wood_room", "nuked_wood_room", 1, 1);
	setAmbientRoomContext( "wood_room", "ringoff_plr", "outdoor" );

	activateAmbientRoom( 0, "default", 0 );		
}

snd_fx_create ()
{
	// TODO make the audio init happen after FX and put snd_play_auto_fx in _audio
	wait (1);
	
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_mp_nuked_sprinkler", "amb_sprinklers");				
}	

pa_think(notifyName, alias)
{
	level waittill (notifyName);
	speakers = getentarray(0, "loudspeaker", "targetname");
	for(i=0; i<speakers.size; i++)
	{
		speakers[i] thread pa_play(alias);
	}
}

pa_play(alias)
{
	wait (self.script_wait_min);
	self PlaySound (0, alias);
}

bomb_sound_go()
{
	level waittill ("notify_nuke");
	playSound (0, "amb_end_nuke", (0,0,0));
}

