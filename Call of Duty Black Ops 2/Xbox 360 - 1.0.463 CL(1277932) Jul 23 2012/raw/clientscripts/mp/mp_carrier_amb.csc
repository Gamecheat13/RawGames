//
// file: mp_carrier_amb.csc
// description: clientside ambient script for mp_carrier: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
	declareAmbientRoom("carrier_outdoor", true );
		setAmbientRoomtone ("carrier_outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "carrier_outdoor", "carrier_outdoor", 1, 1 );
		setAmbientRoomContext( "carrier_outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("carrier_partial_room" );
		setAmbientRoomReverb( "carrier_partial_room", "carrier_partial_room", 1, 1 );
		setAmbientRoomContext( "carrier_partial_room", "ringoff_plr", "outdoor" );				
		
	declareAmbientRoom("carrier_small_room" );
		setAmbientRoomReverb( "carrier_small_room", "carrier_small_room", 1, 1 );
		setAmbientRoomContext( "carrier_small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("carrier_medium_room" );
		setAmbientRoomReverb( "carrier_medium_room", "carrier_medium_room", 1, 1 );
		setAmbientRoomContext( "carrier_medium_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("carrier_large_room" );
		setAmbientRoomReverb( "carrier_large_room", "carrier_large_room", 1, 1 );
		setAmbientRoomContext( "carrier_large_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("carrier_open_room" );
		setAmbientRoomReverb( "carrier_open_room", "carrier_open_room", 1, 1 );
		setAmbientRoomContext( "carrier_open_room", "ringoff_plr", "outdoor" );	
		
	declareAmbientRoom("carrier_dense_hallway" );
		setAmbientRoomReverb( "carrier_dense_hallway", "carrier_dense_hallway", 1, 1 );
		setAmbientRoomContext( "carrier_dense_hallway", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("carrier_stone_room" );
		setAmbientRoomReverb( "carrier_stone_room", "carrier_stone_room", 1, 1 );
		setAmbientRoomContext( "carrier_stone_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("carrier_container" );
		setAmbientRoomReverb( "carrier_container", "carrier_container", 1, 1 );
		setAmbientRoomContext( "carrier_container", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("carrier_metal_room" );
		setAmbientRoomReverb( "carrier_metal_room", "carrier_metal_room", 1, 1 );
		setAmbientRoomContext( "carrier_metal_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("carrier_metal_partial" );
		setAmbientRoomReverb( "carrier_metal_partial", "carrier_metal_partial", 1, 1 );
		setAmbientRoomContext( "carrier_metal_partial", "ringoff_plr", "outdoor" );	
		
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "carrier_outdoor", 0 );	
		
	//	thread snd_start_autofcarrier_audio();
	//	thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	//playloopat ( "amb_flag", (-68, 3130, 182) );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofcarrier_audio()
{

	//snd_play_auto_fx ( "fcarrier_fire_sm", "amb_fire_med", 0, 0, 0, true );
	//snd_play_auto_fx ( "fcarrier_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	//snd_play_auto_fx ( "fcarrier_fire_lg", "amb_fire_lrg", 0, 0, 0, true );		
	

}

