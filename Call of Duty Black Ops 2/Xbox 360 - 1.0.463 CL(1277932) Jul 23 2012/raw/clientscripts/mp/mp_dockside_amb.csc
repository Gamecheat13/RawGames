//
// file: mp_dockside_amb.csc
// description: clientside ambient script for mp_dockside: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
	declareAmbientRoom("dockside_outdoor", true );
		//setAmbientRoomtone ("dockside_outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "dockside_outdoor", "dockside_outdoor", 1, 1 );
		setAmbientRoomContext( "dockside_outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("dockside_partial_room" );
		setAmbientRoomReverb( "dockside_partial_room", "dockside_partial_room", 1, 1 );
		setAmbientRoomContext( "dockside_partial_room", "ringoff_plr", "outdoor" );				
		
	declareAmbientRoom("dockside_small_room" );
		setAmbientRoomReverb( "dockside_small_room", "dockside_small_room", 1, 1 );
		setAmbientRoomContext( "dockside_small_room", "ringoff_plr", "indoor" );

	declareAmbientRoom("dockside_partial_small_room" );
		setAmbientRoomReverb( "dockside_partial_small_room", "dockside_small_room", 1, 1 );
		setAmbientRoomContext( "dockside_partial_small_room", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("dockside_medium_room" );
		setAmbientRoomReverb( "dockside_medium_room", "dockside_medium_room", 1, 1 );
		setAmbientRoomContext( "dockside_medium_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("dockside_large_room" );
		setAmbientRoomReverb( "dockside_large_room", "dockside_large_room", 1, 1 );
		setAmbientRoomContext( "dockside_large_room", "ringoff_plr", "indoor" );

	declareAmbientRoom("dockside_partial_large_room" );
		setAmbientRoomReverb( "dockside_partial_large_room", "dockside_large_room", 1, 1 );
		setAmbientRoomContext( "dockside_partial_large_room", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("dockside_open_room" );
		setAmbientRoomReverb( "dockside_open_room", "dockside_open_room", 1, 1 );
		setAmbientRoomContext( "dockside_open_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("dockside_dense_hallway" ); 
		setAmbientRoomReverb( "dockside_dense_hallway", "dockside_dense_hallway", 1, 1 );
		setAmbientRoomContext( "dockside_dense_hallway", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("dockside_stone_room" );
		setAmbientRoomReverb( "dockside_stone_room", "dockside_stone_room", 1, 1 );
		setAmbientRoomContext( "dockside_stone_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("dockside_container" );
		setAmbientRoomReverb( "dockside_container", "dockside_container", 1, 1 );
		setAmbientRoomContext( "dockside_container", "ringoff_plr", "indoor" );

	declareAmbientRoom("dockside_partial_container" );
		setAmbientRoomReverb( "dockside_partial_container", "dockside_container", 1, 1 );
		setAmbientRoomContext( "dockside_partial_container", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("dockside_office_room" );
		setAmbientRoomReverb( "dockside_office_room", "dockside_small_room", 1, 1 );
		setAmbientRoomContext( "dockside_office_room", "ringoff_plr", "indoor" );

	declareAmbientRoom("dockside_office_partial_room" );
		setAmbientRoomReverb( "dockside_office_partial_room", "dockside_small_room", 1, 1 );
		setAmbientRoomContext( "dockside_office_partial_room", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("dockside_semi_room" );
		setAmbientRoomReverb( "dockside_semi_room", "dockside_semi", 1, 1 );
		setAmbientRoomContext( "dockside_semi_room", "ringoff_plr", "indoor" );
		
	declareAmbientRoom("dockside_semi_partial_room" );
		setAmbientRoomReverb( "dockside_semi_partial_room", "dockside_semi", 1, 1 );
		setAmbientRoomContext( "dockside_semi_partial_room", "ringoff_plr", "outdoor" );
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "dockside_outdoor", 0 );	
		
		thread snd_start_autofx_audio();
	//	thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	//playloopat ( "amb_flag", (-68, 3130, 182), );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{

	//snd_play_auto_fx ( "fx_fire_sm", "amb_fire_med", 0, 0, 0, true );
	//snd_play_auto_fx ( "fx_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	//snd_play_auto_fx ( "fx_fire_lg", "amb_fire_lrg", 0, 0, 0, true );
      snd_play_auto_fx ( "fx_mp_water_drip_light_shrt", "amb_water_drips", 0, 0, 0, true );	
	  snd_play_auto_fx ( "fx_mp_steam_pipe_md", "amb_steam_pipe", 0, 0, 0, false );   
 	  snd_play_auto_fx ( "fx_light_flour_glow_wrm_dbl_md", "amb_flour_light", 0, 0, 0, false );  	  
	

}

