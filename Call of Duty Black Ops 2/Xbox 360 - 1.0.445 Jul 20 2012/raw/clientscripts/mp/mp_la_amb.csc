//
// file: mp_la_amb.csc
// description: clientside ambient script for mp_la: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
	declareAmbientRoom("outdoor", true );
		setAmbientRoomtone ("outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "outdoor", "mp_la_city", 1, 1 );
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("cement_hall" );
		setAmbientRoomReverb( "cement_hall", "mp_la_cement_hall", 1, 1 );
		setAmbientRoomContext( "cement_hall", "ringoff_plr", "indoor" );
	
	declareAmbientRoom("parking_garage" );
		setAmbientRoomReverb( "parking_garage", "mp_la_garage", 1, 1 );
		setAmbientRoomContext( "parking_garage", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("parking_garage_partial" );
		setAmbientRoomReverb( "parking_garage_partial", "mp_la_garage", 1, 1 );
		setAmbientRoomContext( "parking_garage_partial", "ringoff_plr", "outdoor" );	
		
	declareAmbientRoom("indoor_small" );
		setAmbientRoomReverb( "indoor_small", "mp_la_smallroom", 1, 1 );
		setAmbientRoomContext( "indoor_small", "ringoff_plr", "indoor" );

	declareAmbientRoom("indoor_small_partial" );
		setAmbientRoomReverb( "indoor_small_partial", "mp_la_smallroom", 1, 1 );
		setAmbientRoomContext( "indoor_small_partial", "ringoff_plr", "outdoor" );			
		
	declareAmbientRoom("indoor_medium" );
		setAmbientRoomReverb( "indoor_medium", "mp_la_mediumroom", 1, 1 );
		setAmbientRoomContext( "indoor_medium", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("indoor_medium_partial" );//for guns when you are near a window.  indoor verb plus outdoor ringoff
		setAmbientRoomReverb( "indoor_medium_partial", "mp_la_mediumroom", 1, 1 );
		setAmbientRoomContext( "indoor_medium_partial", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("indoor_shaft" );
		setAmbientRoomReverb( "indoor_shaft", "mp_la_shaftroom", 1, 1 );
		setAmbientRoomContext( "indoor_shaft", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("indoor_large" );
		setAmbientRoomReverb( "indoor_large", "mp_la_largeroom", 1, 1 );
		setAmbientRoomContext( "indoor_large", "ringoff_plr", "indoor" );	

	declareAmbientRoom("indoor_large_partial" );
		setAmbientRoomReverb( "indoor_large_partial", "mp_la_largeroom", 1, 1 );
		setAmbientRoomContext( "indoor_large_partial", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("indoor_rubble_md" );
		setAmbientRoomReverb( "indoor_rubble_md", "mp_la_rubbleroom_md", 1, 1 );
		setAmbientRoomContext( "indoor_rubble_md", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("indoor_rubble_lg" );
		setAmbientRoomReverb( "indoor_rubble_lg", "mp_la_rubbleroom_lg", 1, 1 );
		setAmbientRoomContext( "indoor_rubble_lg", "ringoff_plr", "outdoor" );	

	declareAmbientRoom("bus" );
		setAmbientRoomReverb( "bus", "mp_la_bus", 1, 1 );
		setAmbientRoomContext( "bus", "ringoff_plr", "indoor" );	

	declareAmbientRoom("bus_partial" );
		setAmbientRoomReverb( "bus_partial", "mp_la_bus", 1, 1 );
		setAmbientRoomContext( "bus_partial", "ringoff_plr", "outdoor" );		
		

	declareAmbientRoom("under_bridge" );
		setAmbientRoomReverb( "under_bridge", "mp_la_stoneroom", 1, 1 );
		setAmbientRoomContext( "under_bridge", "ringoff_plr", "outdoor" );
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "outdoor", 0 );	
		
		thread snd_start_autofx_audio();
		thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	playloopat ( "amb_fire_sprinkler", (41, 2071, -38)  );
	//soundloopemitter(  "amb_fire_sprinkler_2", (-209, 1854, -47)  );
	//soundloopemitter(  "amb_fire_sprinkler", (514, 2575, -38)  );
	playloopat (  "amb_fire_sprinkler_2", (-235, 2555, -46)  );
	playloopat (  "amb_toliet_spray", (-663, 3057, 76)  );
	playloopat (  "amb_fire_sprinkler_gush", (480, 2198, -38)  );
	playloopat (  "amb_light_flicker", (-122, -80, 77)  );
	//playloopat (  "amb_fire_sprinkler_gush", (-351, 2220, -209)  );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{

	snd_play_auto_fx ( "fx_fire_sm", "amb_fire_med", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	snd_play_auto_fx ( "fx_fire_lg", "amb_fire_lrg", 0, 0, 0, true );		
	snd_play_auto_fx ( "fx_mp_light_flare_la", "amb_flare_loop", 0, 0, 10, true );		
	snd_play_auto_fx ( "fx_fire_detail", "amb_fire_med", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_mp_water_drip_light_shrt", "amb_water_drip", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_insects_swarm_md_light", "amb_insects_flys_md", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_insects_swarm_lg_light", "amb_insects_flys_lg", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_water_fountian_pool_md", "amb_fountain_md", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_water_fountain_pool_sm", "amb_fountain_sm", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_water_fire_sprinkler_splash", "amb_water_splash", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_mp_water_drip_light_long", "amb_water_drip_2", 0, 0, 0, true );
	//snd_play_auto_fx ( "fx_dust_crumble_lg", "amb_rubble_dirt", 0, 0, 0, false );
	//snd_play_auto_fx ( "fx_light_flourescent_glow_cool", "amb_light_flicker", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_water_fire_sprinkler_gush_splash", "amb_water_splash", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_light_ambulance_red_flash", "amb_siren_click", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_light_ambulance_blue_flash", "amb_siren_click", 0, 0, 0, false );
	//snd_play_auto_fx ( "fx_leaves_falling_lite_sm_orng", "amb_wind_tree", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_water_fire_sprinkler_splash", "amb_sprinkler_drip", 0, 0, 0, true );
	
}



