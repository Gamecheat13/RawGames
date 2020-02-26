//
// file: mp_raid_amb.csc
// description: clientside ambient script for mp_raid: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("raid_outdoor", true );
		setAmbientRoomtone ("raid_outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "raid_outdoor", "raid_outdoor", 1, 1 );
		setAmbientRoomContext( "raid_outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("raid_partial_room" );
		setAmbientRoomReverb( "raid_partial_room", "raid_partial_room", 1, 1 );
		setAmbientRoomContext( "raid_partial_room", "ringoff_plr", "outdoor" );				
		
	declareAmbientRoom("raid_small_room" );
		setAmbientRoomReverb( "raid_small_room", "raid_small_room", 1, 1 );
		setAmbientRoomContext( "raid_small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("raid_medium_room" );
		setAmbientRoomReverb( "raid_medium_room", "raid_medium_room", 1, 1 );
		setAmbientRoomContext( "raid_medium_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("raid_large_room" );
		setAmbientRoomReverb( "raid_large_room", "raid_large_room", 1, 1 );
		setAmbientRoomContext( "raid_large_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("raid_open_room" );
		setAmbientRoomReverb( "raid_open_room", "raid_open_room", 1, 1 );
		setAmbientRoomContext( "raid_open_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("raid_dense_hallway" );
		setAmbientRoomReverb( "raid_dense_hallway", "raid_dense_hallway", 1, 1 );
		setAmbientRoomContext( "raid_dense_hallway", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("raid_stone_room" );
		setAmbientRoomReverb( "raid_stone_room", "raid_stone_room", 1, 1 );
		setAmbientRoomContext( "raid_stone_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("raid_container" );
		setAmbientRoomReverb( "raid_container", "raid_container", 1, 1 );
		setAmbientRoomContext( "raid_container", "ringoff_plr", "indoor" );	
		
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "raid_outdoor", 0 );	
		
	//	thread snd_start_autofraid_audio();
	//	thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	//playloopat ( "amb_flag", (-68, 3130, 182) );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofraid_audio()
{

	//snd_play_auto_fx ( "fraid_fire_sm", "amb_fire_med", 0, 0, 0, true );
	//snd_play_auto_fx ( "fraid_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	//snd_play_auto_fx ( "fraid_fire_lg", "amb_fire_lrg", 0, 0, 0, true );		
	

}
