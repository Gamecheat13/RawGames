//
// file: mp_drone_amb.csc
// description: clientside ambient script for mp_drone: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
	declareAmbientRoom("drone_outdoor", true );
		setAmbientRoomtone ("drone_outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "drone_outdoor", "drone_outdoor", 1, 1 );
		setAmbientRoomContext( "drone_outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("drone_partial_room" );
		setAmbientRoomReverb( "drone_partial_room", "drone_partial_room", 1, 1 );
		setAmbientRoomContext( "drone_partial_room", "ringoff_plr", "outdoor" );				
		
	declareAmbientRoom("drone_small_room" );
		setAmbientRoomReverb( "drone_small_room", "drone_small_room", 1, 1 );
		setAmbientRoomContext( "drone_small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_medium_room" );
		setAmbientRoomReverb( "drone_medium_room", "drone_medium_room", 1, 1 );
		setAmbientRoomContext( "drone_medium_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("drone_large_room" );
		setAmbientRoomReverb( "drone_large_room", "drone_large_room", 1, 1 );
		setAmbientRoomContext( "drone_large_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_open_room" );
		setAmbientRoomReverb( "drone_open_room", "drone_open_room", 1, 1 );
		setAmbientRoomContext( "drone_open_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_dense_hallway" );
		setAmbientRoomReverb( "drone_dense_hallway", "drone_dense_hallway", 1, 1 );
		setAmbientRoomContext( "drone_dense_hallway", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("drone_stone_room" );
		setAmbientRoomReverb( "drone_stone_room", "drone_stone_room", 1, 1 );
		setAmbientRoomContext( "drone_stone_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_container" );
		setAmbientRoomReverb( "drone_container", "drone_container", 1, 1 );
		setAmbientRoomContext( "drone_container", "ringoff_plr", "indoor" );	
		
	//new amb room names
		
	declareAmbientRoom("drone_small_helipad_room" );
		setAmbientRoomReverb( "drone_small_helipad_room", "drone_small_room", 1, 1 );
		setAmbientRoomContext( "drone_small_helipad_room", "ringoff_plr", "indoor" );

	declareAmbientRoom("drone_small_under_helipad_room" );
		setAmbientRoomReverb( "drone_small_under_helipad_room", "gen_cave", 1, 1 );
		setAmbientRoomContext( "drone_small_under_helipad_room", "ringoff_plr", "indoor" );	
				
		
	declareAmbientRoom("drone_small_carpet_room" );
		setAmbientRoomReverb( "drone_small_carpet_room", "drone_small_room", 1, 1 );
		setAmbientRoomContext( "drone_small_carpet_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_large_hanger_room" );
		setAmbientRoomReverb( "drone_large_hanger_room", "drone_large_room", 1, 1 );
		setAmbientRoomContext( "drone_large_hanger_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_small_comp_room" );
		setAmbientRoomReverb( "drone_small_comp_room", "drone_small_room", 1, 1 );
		setAmbientRoomContext( "drone_small_comp_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_large_machine_room" );
		setAmbientRoomReverb( "drone_large_machine_room", "drone_partial_room", 1, 1 );
		setAmbientRoomContext( "drone_large_machine_room", "ringoff_plr", "outdoor" );	
		
	declareAmbientRoom("drone_small_brick_room" );
		setAmbientRoomReverb( "drone_small_brick_room", "drone_stone_room", 1, 1 );
		setAmbientRoomContext( "drone_small_brick_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_small_tile_room" );
		setAmbientRoomReverb( "drone_small_tile_room", "drone_small_room", 1, 1 );
		setAmbientRoomContext( "drone_small_tile_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("drone_small_marble_room" );
		setAmbientRoomReverb( "drone_small_marble_room", "drone_small_room", 1, 1 );
		setAmbientRoomContext( "drone_small_marble_room", "ringoff_plr", "indoor" );
		
		
		
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "drone_outdoor", 0 );	
		
	//	thread snd_start_autofdrone_audio();
	//	thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	//playloopat ( "amb_flag", (-68, 3130, 182) );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofdrone_audio()
{

	//snd_play_auto_fx ( "fdrone_fire_sm", "amb_fire_med", 0, 0, 0, true );
	//snd_play_auto_fx ( "fdrone_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	//snd_play_auto_fx ( "fdrone_fire_lg", "amb_fire_lrg", 0, 0, 0, true );		
	

}
