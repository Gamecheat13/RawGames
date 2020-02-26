//
// file: mp_socotra_amb.csc
// description: clientside ambient script for mp_socotra: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
	declareAmbientRoom("default", true );
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
		
	thread snd_start_autofx_audio();
	thread snd_play_loopers();
		
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
	snd_play_auto_fx ( "fx_insects_swarm_md_light", "amb_insects_flys_md", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_insects_fly_swarm_lng", "amb_insects_flys_lg", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_insects_fly_swarm", "amb_insects_flys_swarm", 0, 0, 0, false );
    snd_play_auto_fx ( "fx_mp_water_drip_light_shrt", "amb_water_drip", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_mp_water_drip_light_long", "amb_water_drip_2", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_fire_fuel_sm", "amb_fire_large", 0, 0, 0, false );	
	snd_play_auto_fx ( "fx_water_faucet_on", "amb_water_faucet", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_water_faucet_splash", "amb_water_faucet_splash", 0, 0, 0, true );	

	

}

