//
// file: afghanistan_amb.csc
// description: clientside ambient script for afghanistan: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	
	declareAmbientRoom( "desert_outside" );
	setAmbientRoomTone ("desert_outside","blk_desert_wind_bg", .5, .5);
	setAmbientRoomReverb ("desert_outside","gen_desert", 1, 1);
	setAmbientRoomContext( "desert_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "desert_outside" );
 	addAmbientElement( "desert_outside", "amb_red_tail_hawk", 30, 70, 200, 1000 );	
 			
	declareAmbientRoom( "hills_outside" );
	setAmbientRoomTone ("hills_outside","blk_desert_wind_bg", .5, .5);
	setAmbientRoomReverb ("hills_outside","gen_hills", 1, 1);
	setAmbientRoomContext( "hills_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "hills_outside" );
 	//addAmbientElement( "desert_outside", "amb_red_tail_hawk", 8, 18, 200, 1000 );
	
	//Set this room for the open-air places between buildings and ruins without roofs by the weapon cache - set the reverb for the walls but left the ringoff
	declareAmbientRoom( "open_air_enclosure" );
	setAmbientRoomTone ("open_air_enclosure","blk_desert_wind_bg", .5, .5);
	setAmbientRoomReverb ("open_air_enclosure","gen_stoneroom", 1, 1);
	setAmbientRoomContext( "open_air_enclosure", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "open_air_enclosure" );
	
	declareAmbientRoom( "stone_room" );
	setAmbientRoomTone ("stone_room","blk_tunnel_wind_bg", .5, .5);
	setAmbientRoomReverb ("stone_room","gen_stoneroom", 1, 1);
	setAmbientRoomContext( "stone_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room" );
	
	declareAmbientRoom( "stone_room_large" );
	setAmbientRoomTone ("stone_room_large","blk_tunnel_wind_bg", .5, .5);
	setAmbientRoomReverb ("stone_room_large","gen_stoneroom", 1, 1);
	setAmbientRoomContext( "stone_room_large", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room_large" );
	
	declareAmbientRoom( "bunker_tunnel" );
	setAmbientRoomTone ("bunker_tunnel","blk_tunnel_wind_bg", .5, .5);
	setAmbientRoomReverb ("bunker_tunnel","gen_cave", 1, 1);
	setAmbientRoomContext( "bunker_tunnel", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_tunnel" );
	
	declareAmbientRoom( "bunker_room" );
	setAmbientRoomTone ("bunker_room","blk_bunker_room_bg", .5, .5);
	setAmbientRoomReverb ("bunker_room","gen_stoneroom", 1, 1);
	setAmbientRoomContext( "bunker_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_room" );	
	
	declareAmbientRoom( "numbers" );
	setAmbientRoomTone( "numbers", "evt_numbers_amb_trippy", 1, .25 );
	setAmbientRoomReverb ("numbers", "gen_cave", 1, 1);
	setAmbientRoomContext( "numbers", "ringoff_plr", "indoor" );
	declareAmbientPackage( "numbers" );
 	addAmbientElement( "numbers", "evt_numbers_small", .25, 2, 25, 250 );	
 	addAmbientElement( "numbers", "evt_numbers_large", 2, 15, 150, 500 );	
 	addAmbientElement( "numbers", "evt_numbers_large_flux", 5, 15, 250, 500 );	
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "desert_outside", 0 );
	activateAmbientRoom( 0, "desert_outside", 0 );	
	
	thread snd_fx_create();
	thread blend_desert_tunnel();
	thread activate_numbers_audio();
}


snd_fx_create()
{
//	while (!isDefined(level.createFXent))
//	{
		wait (1);
//	}

	//statue
	clientscripts\_audio::snd_add_exploder_alias( 10350, "blk_f35_crash_impact" );
	//tower
	clientscripts\_audio::snd_add_exploder_alias( 10330, "blk_f35_crash_impact" );

}

blend_desert_tunnel()
{

	soundloopemitter ("blk_blend", (15104, -10119, -32));
		
}

activate_numbers_audio()
{
	level endon( "ensc" );
	
	level waittill( "snsc" );
	
	level thread cleanup_numbers_audio();
	activateambientpackage( 0, "numbers", 100 );
	activateambientroom( 0, "numbers", 100 );
	level notify( "updateActiveAmbientPackage" );
	level notify( "updateActiveAmbientRoom" );
	
	num = 1;
	while(1)
	{
		playsound( 0, "evt_numbers_heartbeat_loud", (0,0,0) );
		if( num == 2 )
		{
			num = 0;
			playsound( 0, "evt_numbers_breath_cold", (0,0,0) );
		}
		wait(1.5);
		num++;
	}
}

cleanup_numbers_audio()
{
	level waittill( "ensc" );
	
	deactivateambientpackage( 0, "numbers", 100 );
	deactivateambientroom( 0, "numbers", 100 );
}