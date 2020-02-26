//
// file: afghanistan_amb.csc
// description: clientside ambient script for afghanistan: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_audio;
#include clientscripts\_music;

main()
{
	declareAmbientRoom( "desert_outside" );
	setAmbientRoomTone ("desert_outside","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("desert_outside","afgan_desert_outside", 1, 1);
	setAmbientRoomContext( "desert_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "desert_outside" );
 	addAmbientElement( "desert_outside", "amb_desert_wind_gusts", 1, 3, 50, 750 );

 	
 	declareAmbientRoom( "afgan_cliff_echo" );
	setAmbientRoomTone ("afgan_cliff_echo","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("afgan_cliff_echo","afgan_cliff_echo", 1, 1);
	setAmbientRoomContext( "afgan_cliff_echo", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "afgan_cliff_echo" );
 	addAmbientElement( "afgan_cliff_echo", "amb_desert_wind_gusts", 1, 3, 50, 750 );
 	addAmbientElement( "afgan_cliff_echo", "amb_red_tail_hawk", 8, 18, 200, 1000 );
 	
 	declareAmbientRoom( "short_cave_arch" );
	setAmbientRoomTone ("short_cave_arch","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("short_cave_arch","afgan_short_cave_arch", 1, 1);
	setAmbientRoomContext( "short_cave_arch", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "short_cave_arch" );
	
	 declareAmbientRoom( "big_cave_arch" );
	setAmbientRoomTone ("big_cave_arch","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("big_cave_arch","afgan_big_cave_arch", 1, 1);
	setAmbientRoomContext( "big_cave_arch", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "big_cave_arch" );
			
	declareAmbientRoom( "hills_outside" );
	setAmbientRoomTone ("hills_outside","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("hills_outside","afgan_bridges", 1, 1);
	setAmbientRoomContext( "hills_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "hills_outside" );
	
	//Set this room for the open-air places between buildings and ruins without roofs by the weapon cache - set the reverb for the walls but left the ringoff
	declareAmbientRoom( "open_air_enclosure" );
	setAmbientRoomTone ("open_air_enclosure","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("open_air_enclosure","afgan_open_hut", 1, 1);
	setAmbientRoomContext( "open_air_enclosure", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "open_air_enclosure" );
	
	declareAmbientRoom( "village" );
	setAmbientRoomTone ("village","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("village","afgan_village", 1, 1);
	setAmbientRoomContext( "village", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "village" );
	
	declareAmbientRoom( "stone_room" );
	setAmbientRoomTone ("stone_room","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("stone_room","afgan_stone_room", 1, 1);
	setAmbientRoomContext( "stone_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room" );
	
	declareAmbientRoom( "stone_room_large" );
	setAmbientRoomTone ("stone_room_large","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("stone_room_large","afgan_stone_room_lg", 1, 1);
	setAmbientRoomContext( "stone_room_large", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room_large" );
	
	declareAmbientRoom( "bunker_tunnel" );
	setAmbientRoomTone ("bunker_tunnel","amb_cave_bg", 3, 3);
	setAmbientRoomReverb ("bunker_tunnel","afgan_bunker_tunnel", 1, 1);
	setAmbientRoomContext( "bunker_tunnel", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_tunnel" );
	
	declareAmbientRoom( "tunnel_gen" );
	setAmbientRoomTone ("tunnel_gen","amb_cave_bg", 3, 3);
	setAmbientRoomReverb ("tunnel_gen","afgan_tunnel_gen", 1, 1);
	setAmbientRoomContext( "tunnel_gen", "ringoff_plr", "indoor" );
	declareAmbientPackage( "tunnel_gen" );
	
	declareAmbientRoom( "bunker_room" );
	setAmbientRoomTone ("bunker_room","amb_cave_bg", 3, 3);
	setAmbientRoomReverb ("bunker_room","afgan_bunker_room", 1, 1);
	setAmbientRoomContext( "bunker_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_room" );	
	
	declareAmbientRoom( "numbers" );
	setAmbientRoomTone( "numbers", "evt_numbers_amb_trippy", 1, .25 );
	setAmbientRoomReverb ("numbers", "afgan_numbers_igc", 1, 1);
	setAmbientRoomContext( "numbers", "ringoff_plr", "indoor" );
	declareAmbientPackage( "numbers" );
 	addAmbientElement( "numbers", "evt_numbers_small", .25, 2, 25, 250 );	
 	addAmbientElement( "numbers", "evt_numbers_large", 2, 15, 150, 500 );	
 	addAmbientElement( "numbers", "evt_numbers_large_flux", 5, 15, 250, 500 );	
	
 	
 	declareAmbientRoom( "omw_room" );
	setAmbientRoomTone ("omw_room","amb_omw_hospital__bg", 2, 2);
	setAmbientRoomReverb ("omw_room","cmn_omw", 1, 1);
	setAmbientRoomContext( "omw_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "omw_room" );

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



