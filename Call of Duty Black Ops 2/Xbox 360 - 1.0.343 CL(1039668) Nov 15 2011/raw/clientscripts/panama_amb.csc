//
// file: panama_amb.csc
// description: clientside ambient script for panama: setup ambient sounds, etc.
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
	
	declareAmbientRoom( "outdoor" );
	setAmbientRoomTone ("outdoor","blk_panama_outdoor_bg", .5, .5);
	setAmbientRoomReverb ("outdoor","gen_city", 1, 1);
	setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "outdoor" );
	
	declareAmbientRoom( "indoor" );
	setAmbientRoomTone ("indoor","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("indoor","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "indoor", "ringoff_plr", "indoor" );
	declareAmbientPackage( "indoor" );
	
	declareAmbientRoom( "battle" );
	setAmbientRoomTone ("battle","blk_panama_battle_bg", .5, .5);
	setAmbientRoomReverb ("battle","gen_city", 1, 1);
	setAmbientRoomContext( "battle", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "battle" );
	
	declareAmbientRoom( "stairwell" );
	setAmbientRoomTone ("stairwell","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("stairwell","gen_cave", 1, 1);
	setAmbientRoomContext( "stairwell", "ringoff_plr", "indoor" );

	declareAmbientRoom( "hangar" );
	setAmbientRoomTone ("hangar","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("hangar","gen_hangar", 1, 1);
	setAmbientRoomContext( "hangar", "ringoff_plr", "indoor" );
	
	declareAmbientRoom( "small_room" );
	setAmbientRoomTone ("small_room","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("small_room","gen_smallroom", 1, 1);
	setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );
	
	declareAmbientRoom( "medium_room" );
	setAmbientRoomTone ("medium_room","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("medium_room","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );	

	declareAmbientRoom( "large_room" );
	setAmbientRoomTone ("large_room","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("large_room","gen_largeroom", 1, 1);
	setAmbientRoomContext( "large_room", "ringoff_plr", "indoor" );	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );	    
	
	level thread song_player(); 
	level thread setup_ambient_fx_sounds();
	level thread setup_exploder_aliases();
}

song_player()
{
   		wait (2); 
		playsound (0, "amb_song", (24019, -19919, 89 ));	
}

setup_ambient_fx_sounds()
{		
	snd_play_auto_fx( "fx_fire_column_creep_xsm", "amb_fire_medium", 0, 0, 0, false, 200, 2, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_column_creep_sm", "amb_fire_medium", 0, 0, 0, false, 200, 2, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_wall_md", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_ceiling_md", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_line_xsm", "amb_fire_medium", 0, 0, 0, false, 200, 2, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_line_sm", "amb_fire_medium", 0, 0, 0, false, 200, 2, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_line_md", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
}

setup_exploder_aliases()
{
	//These occur pre/during the slide-out-of-the-building section, 3 simple explosions
	clientscripts\_audio::snd_add_exploder_alias( 562, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 561, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 560, "wpn_grenade_explode" );
}