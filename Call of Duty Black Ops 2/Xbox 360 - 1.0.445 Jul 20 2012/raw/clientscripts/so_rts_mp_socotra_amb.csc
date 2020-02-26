//
// file: mp_socotra_amb.csc
// description: clientside ambient script for mp_socotra: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_audio;
#include clientscripts\_music;

main()
{
	declareAmbientRoom("default" );
		setAmbientRoomtone ("default", "amb_battel_2d", .2, .5);
		setAmbientRoomReverb( "default", "socotra_outdoor", 1, 1 );
		setAmbientRoomContext( "default", "ringoff_plr", "outdoor" );
	
	declareAmbientRoom("under_bridge" );
		//setAmbientRoomtone ("under_bridge", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "under_bridge", "socotra_stoneroom", 1, 1 );
		setAmbientRoomContext( "under_bridge", "ringoff_plr", "outdoor" );

	declareAmbientRoom("small_room" );
		//setAmbientRoomtone ("small_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "small_room", "socotra_smallroom", 1, 1 );
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("medium_room" );
		//setAmbientRoomtone ("medium_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "medium_room", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("largeroom_room" );
		//setAmbientRoomtone ("largeroom_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "largeroom_room", "socotra_largeroom", 1, 1 );
		setAmbientRoomContext( "largeroom_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("hallroom" );
		//setAmbientRoomtone ("hallroom", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "hallroom", "socotra_hallroom", 1, 1 );
		setAmbientRoomContext( "hallroom", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("partialroom" );
		//setAmbientRoomtone ("partialroom", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "partialroom", "socotra_partialroom", 1, 1 );
		setAmbientRoomContext( "partialroom", "ringoff_plr", "outdoor" );	
		
		
		
/*
	declareAmbientRoom("default" );
		setAmbientRoomtone ("default", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "default", "gen_outdoor", 1, 1 );
		setAmbientRoomContext( "default", "ringoff_plr", "outdoor" );
	
	declareAmbientRoom("under_bridge" );
		//setAmbientRoomtone ("under_bridge", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "under_bridge", "gen_stoneroom", 1, 1 );
		setAmbientRoomContext( "under_bridge", "ringoff_plr", "outdoor" );

	declareAmbientRoom("small_room" );
		//setAmbientRoomtone ("small_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "small_room", "gen_smallroom", 1, 1 );
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("medium_room" );
		//setAmbientRoomtone ("medium_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "medium_room", "gen_mediumroom", 1, 1 );
		setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("largeroom_room" );
		//setAmbientRoomtone ("largeroom_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "largeroom_room", "gen_largeroom", 1, 1 );
		setAmbientRoomContext( "largeroom_room", "ringoff_plr", "indoor" );		
		
*/
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "default", 0 );	

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

	//soundloopemitter( "amb_flag", (-68, 3130, 182), );

}	



