//
// file: mp_express_amb.csc
// description: clientside ambient script for mp_express: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_audio;

main()
{
		declareAmbientRoom( "default_outdoor", true );
		setAmbientRoomtone ("default_outdoor", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "default_outdoor", "express_outdoor", 1, 1 );
		setAmbientRoomContext( "default_outdoor", "ringoff_plr", "outdoor" );
		
		declareAmbientRoom( "subway_room" );
		//setAmbientRoomtone ("subway_room", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "subway_room", "express_smallroom", 1, 1 );
		setAmbientRoomContext( "subway_room", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "tunnel_ramp_room" );
		//setAmbientRoomtone ("tunnel_ramp_room", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "tunnel_ramp_room", "express_sewerpipe", 1, 1 );
		setAmbientRoomContext( "tunnel_ramp_room", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "tunnel_bridge_room" );
		//setAmbientRoomtone ("tunnel_bridge_room", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "tunnel_bridge_room", "express_sewerpipe", 1, 1 );
		setAmbientRoomContext( "tunnel_bridge_room", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "tunnel_wide_room" );
		//setAmbientRoomtone ("tunnel_wide_room", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "tunnel_wide_room", "express_stoneroom", 1, 1 );
		setAmbientRoomContext( "tunnel_wide_room", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "ticket_window_room" );
		//setAmbientRoomtone ("ticket_window_room", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "ticket_window_room", "express_smallroom", 1, 1 );
		setAmbientRoomContext( "ticket_window_room", "ringoff_plr", "indoor" );		
		
		declareAmbientRoom( "ticket_main_room" );
		//setAmbientRoomtone ("ticket_window_room", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "ticket_main_room", "express_mediumroom", 1, 1 );
		setAmbientRoomContext( "ticket_main_room", "ringoff_plr", "indoor" );		
		
		declareAmbientRoom( "stairwell" );
		//setAmbientRoomtone ("stairwell", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "stairwell", "express_stoneroom", 1, 1 );
		setAmbientRoomContext( "stairwell", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "stairwell_open" );
		//setAmbientRoomtone ("stairwell_open", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "stairwell_open", "express_smallroom", 1, 1 );
		setAmbientRoomContext( "stairwell_open", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "marble_room" );
		//setAmbientRoomtone ("marble_room", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "marble_room", "express_stoneroom", 1, 1 );
		setAmbientRoomContext( "marble_room", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "walkway_open" );
		//setAmbientRoomtone ("walkway_open", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "walkway_open", "express_outdoor", 1, 1 );
		setAmbientRoomContext( "walkway_open", "ringoff_plr", "indoor" );
		
		declareAmbientRoom( "walkway_closed" );
		//setAmbientRoomtone ("walkway_closed", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "walkway_closed", "express_stoneroom", 1, 1 );
		setAmbientRoomContext( "walkway_closed", "ringoff_plr", "indoor" );		
		
		declareAmbientRoom( "main_lobby" );
		//setAmbientRoomtone ("main_lobby", "amb_wind_extreior_2d", .2, .5);
		setAmbientRoomReverb( "main_lobby", "express_largeroom", 1, 1 );
		setAmbientRoomContext( "main_lobby", "ringoff_plr", "indoor" );		
		
		
		
	
		activateAmbientRoom( 0, "default_outdoor", 0 );	
		
	//	thread snd_start_autofx_audio();
	//	thread snd_play_loopers();
	
/*
 verb list:
express_underwater
express_stoneroom
express_smallroom
express_sewerpipe
express_outdoor
express_mediumroom
express_largeroom
express_hills
express_hangar
express_desert
express_cockpit
express_city
express_cave
*/

		
}

//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{
	//playloopat ( "amb_battle_dist", (-1404, 166, 1299) );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{
	//snd_play_auto_fx ( "fx_leaves_falling_lite_w", "amb_wind_tree_high", 0, 0, 0, false );	
}

