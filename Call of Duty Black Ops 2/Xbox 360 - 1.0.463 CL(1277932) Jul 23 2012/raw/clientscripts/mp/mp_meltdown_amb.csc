//
// file: mp_meltdown_amb.csc
// description: clientside ambient script for mp_meltdown: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
	declareAmbientRoom( "default_outdoor", true );
		setAmbientRoomtone ("default_outdoor", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "default_outdoor", "meltdown_outdoor", 1, 1 );
		setAmbientRoomContext( "default_outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("meltdown_partial_room" );
		setAmbientRoomReverb( "meltdown_partial_room", "meltdown_partial_room", 1, 1 );
		setAmbientRoomContext( "meltdown_partial_room", "ringoff_plr", "outdoor" );				
		
	declareAmbientRoom("meltdown_small_room" );
		setAmbientRoomReverb( "meltdown_small_room", "meltdown_small_room", 1, 1 );
		setAmbientRoomContext( "meltdown_small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("meltdown_medium_room" );
		setAmbientRoomReverb( "meltdown_medium_room", "meltdown_medium_room", 1, 1 );
		setAmbientRoomContext( "meltdown_medium_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("meltdown_large_room" );
		setAmbientRoomReverb( "meltdown_large_room", "meltdown_large_room", 1, 1 );
		setAmbientRoomContext( "meltdown_large_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("meltdown_open_room" );
		setAmbientRoomReverb( "meltdown_open_room", "meltdown_open_room", 1, 1 );
		setAmbientRoomContext( "meltdown_open_room", "ringoff_plr", "outdoor" );	
		
	declareAmbientRoom("meltdown_dense_hallway" );
		setAmbientRoomReverb( "meltdown_dense_hallway", "meltdown_dense_hallway", 1, 1 );
		setAmbientRoomContext( "meltdown_dense_hallway", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("meltdown_stone_room" );
		setAmbientRoomReverb( "meltdown_stone_room", "meltdown_stone_room", 1, 1 );
		setAmbientRoomContext( "meltdown_stone_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("meltdown_container" );
		setAmbientRoomReverb( "meltdown_container", "meltdown_container", 1, 1 );
		setAmbientRoomContext( "meltdown_container", "ringoff_plr", "indoor" );	
		activateAmbientRoom( 0, "default_outdoor", 0 );	
		
	declareAmbientRoom("meltdown_tower" );
		setAmbientRoomReverb( "meltdown_tower", "meltdown_tower", 1, 1 );
		setAmbientRoomContext( "meltdown_tower", "ringoff_plr", "indoor" );	
		activateAmbientRoom( 0, "default_outdoor", 0 );	
		
	//	thread snd_start_autofx_audio();
	//	thread snd_play_loopers();
	
}

//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{
	playloopat ( "amb_battle_dist", (-1404, 166, 1299) );
}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{
	//snd_play_auto_fx ( "fx_leaves_falling_lite_w", "amb_wind_tree_high", 0, 0, 0, false );
}


