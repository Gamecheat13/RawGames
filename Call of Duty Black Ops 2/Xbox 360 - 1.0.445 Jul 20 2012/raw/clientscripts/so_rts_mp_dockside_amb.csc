//
// file: mp_dockside_amb.csc
// description: clientside ambient script for mp_dockside: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_audio;
#include clientscripts\_music;

main()
{
	declareAmbientRoom("dockside_outdoor" );
		setAmbientRoomtone ("dockside_outdoor", "amb_wind_extreior_2d", .55, 1);
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
		
	declareAmbientRoom("dockside_semi_room" );
		setAmbientRoomReverb( "dockside_semi_room", "dockside_semi", 1, 1 );
		setAmbientRoomContext( "dockside_semi_room", "ringoff_plr", "indoor" );
		
	declareAmbientRoom("dockside_office_partial_room" );
		setAmbientRoomReverb( "dockside_office_partial_room", "dockside_small_room", 1, 1 );
		setAmbientRoomContext( "dockside_office_partial_room", "ringoff_plr", "outdoor" );	
			
	declareAmbientRoom("dockside_semi_partial_room" );
		setAmbientRoomReverb( "dockside_semi_partial_room", "dockside_semi", 1, 1 );
		setAmbientRoomContext( "dockside_semi_partial_room", "ringoff_plr", "outdoor" );
		
	// temp fade in for PRESS
	snd_set_snapshot ( "cmn_fade_in" );		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "dockside_outdoor", 0 );

	//MUSIC SETUP
	declareMusicState ("DOCKSIDE_ACTION");
		musicAliasloop ("mus_rts_action", 0, 3.5);
	//Fade Out	
	declareMusicState ("DOCKSIDE_ACTION_NM");
		musicAliasloop ("null", 0, 0);
	//Mission Sucseess 	
	declareMusicState ("DOCKSIDE_ACTION_WIN");
		musicAliasloop ("null", 0, 0);
		musicAlias ("mus_rts_action_end", 0.0 );

		level thread rts_fadeout();
	//	thread snd_start_autofx_audio();
	//	thread snd_play_loopers();
		
}


rts_fadeout()
{
	level waittill( "rts_fd" );
	snd_set_snapshot ( "spl_rts_fade_out" );		
}

//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	//playloopat( "amb_flag", (-68, 3130, 182), );

}	



