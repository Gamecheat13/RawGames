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
	//HOUSE OPENING
		//House Outdoor: Main package for the outdoor ambience of the house section, normal small little street with a house
		declareAmbientRoom( "house_outdoor" );
		setAmbientRoomTone ("house_outdoor","blk_panama_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("house_outdoor","panama_neighborhood", 1, 1);
		setAmbientRoomContext( "house_outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "house_outdoor" );
		
		//House Shed: Wooden shed in the back yard, small
		declareAmbientRoom( "house_shed" );
		setAmbientRoomTone ("house_shed","blk_panama_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("house_shed","panama_yard_shed", 1, 1);
		setAmbientRoomContext( "house_shed", "ringoff_plr", "indoor" );
		declareAmbientPackage( "house_shed" );
		
	//AIRFIELD
		//Airfield Outdoor: Main package for the outdoor ambience of the airfield section, big battles going on, etc
		declareAmbientRoom( "airfield_outdoor" );
		setAmbientRoomTone ("airfield_outdoor","blk_panama_battle_bg", .5, .5);
		setAmbientRoomReverb ("airfield_outdoor","panama_airfield", 1, 1);
		setAmbientRoomContext( "airfield_outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "airfield_outdoor" );
		
		//Airfield Sewer: Small sewer tunnel you climb through at the beginning, metal, tiny
		declareAmbientRoom( "airfield_sewer" );
		setAmbientRoomTone ("airfield_sewer","blk_panama_battle_bg", .5, .5);
		setAmbientRoomReverb ("airfield_sewer","panama_sewerpipe_sml", 1, 1);
		setAmbientRoomContext( "airfield_sewer", "ringoff_plr", "indoor" );
		declareAmbientPackage( "airfield_sewer" );
		
		//Airfield Hangar Open: Large hangar, metal roof, open at both ends, concrete floor
		declareAmbientRoom( "airfield_hangar_open" );
		setAmbientRoomTone ("airfield_hangar_open","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("airfield_hangar_open","panama_hangar", 1, 1);
		setAmbientRoomContext( "airfield_hangar_open", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "airfield_hangar_open" );
		
		//Airfield Stairwell: Small stairwell, stone
		declareAmbientRoom( "airfield_stairwell" );
		setAmbientRoomTone ("airfield_stairwell","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("airfield_stairwell","panama_stairs", 1, 1);
		setAmbientRoomContext( "airfield_stairwell", "ringoff_plr", "indoor" );
		declareAmbientPackage( "airfield_stairwell" );
		
		//Airfield Hangar Room: Room inside the hangar, medium sized, metal all around
		declareAmbientRoom( "airfield_hangar_room" );
		setAmbientRoomTone ("airfield_hangar_room","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("airfield_hangar_room","panama_mediumroom", 1, 1);
		setAmbientRoomContext( "airfield_hangar_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "airfield_hangar_room" );
		
		//Airfield Hotel: Medium hotel room, carpeted floor, where the final airfield vignette takes place
		declareAmbientRoom( "airfield_hotel" );
		setAmbientRoomTone ("airfield_hotel","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("airfield_hotel","panama_mediumroom_hotel", 1, 1);
		setAmbientRoomContext( "airfield_hotel", "ringoff_plr", "indoor" );
		declareAmbientPackage( "airfield_hotel" );
		
	//SLUMS	
		//Slums Outdoor: Main package for the outdoor ambience of the slums section, big battles going on, etc
		declareAmbientRoom( "slums_outdoor" );
		setAmbientRoomTone ("slums_outdoor","blk_panama_battle_bg", .5, .5);
		setAmbientRoomReverb ("slums_outdoor","panama_slums", 1, 1);
		setAmbientRoomContext( "slums_outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "slums_outdoor" );
		
		//Slums interior: generic interior for the multitude of slum interiors during the main battle, medium rooms
		declareAmbientRoom( "slums_interior" );
		setAmbientRoomTone ("slums_interior","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("slums_interior","panama_slums_mediumroom", 1, 1);
		setAmbientRoomContext( "slums_interior", "ringoff_plr", "indoor" );
		declareAmbientPackage( "slums_interior" );
		
		//Slums Hospital interior
		declareAmbientRoom( "slums_hospital" );
		setAmbientRoomTone ("slums_hospital","amb_hospital_bg", .5, .5);
		setAmbientRoomReverb ("slums_hospital","panama_mediumroom", 1, 1);
		setAmbientRoomContext( "slums_hospital", "ringoff_plr", "indoor" );
		declareAmbientPackage( "slums_hospital" );
		
		//Slums Hospital interior
		declareAmbientRoom( "slums_motel" );
		setAmbientRoomReverb ("slums_motel","panama_slums_motelroom", 1, 1);
		setAmbientRoomContext( "slums_motel", "ringoff_plr", "indoor" );
		declareAmbientPackage( "slums_motel" );
		
		
	//DOCKS	
		//Docks Outdoor: Main package for the outdoor ambience of the slums section, big battles going on, etc
		declareAmbientRoom( "docks_outdoor" );
		//setAmbientRoomTone ("docks_outdoor","blk_panama_battle_bg", .5, .5);
		setAmbientRoomReverb ("docks_outdoor","panama_outdoor_docks", 1, 1);
		setAmbientRoomContext( "docks_outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "docks_outdoor" );	
		
		//Docks Warehouse: Medium building, metal walls, full of crap
		declareAmbientRoom( "docks_warehouse" );
		//setAmbientRoomTone ("docks_warehouse","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("docks_warehouse","panama_busy_room", 1, 1);
		setAmbientRoomContext( "docks_warehouse", "ringoff_plr", "indoor" );
		declareAmbientPackage( "docks_warehouse" );
		
		//Docks Elevator: Metal freight elevator
		declareAmbientRoom( "docks_elevator" );
		//setAmbientRoomTone ("docks_elevator","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("docks_elevator","panama_vader", 1, 1);
		setAmbientRoomContext( "docks_elevator", "ringoff_plr", "indoor" );
		declareAmbientPackage( "docks_elevator" );
		
	activateAmbientPackage( 0, "docks_outdoor", 0 );
	activateAmbientRoom( 0, "docks_outdoor", 0 );	


//MUSIC DECLARATIONS

	declaremusicState("PANAMA_HAUNTED_HOUSE");
		musicAliasloop ("mus_haunted_underscore", 0, 2);	
		musicStinger ("mus_haunted_lady_fight", 8, true);
	
	declaremusicState("PANAMA_BACK_FIGHT");
		musicAliasloop ("mus_fight_on_back", 0, 6);		
		
	declaremusicState("PANAMA_BACK_FIGHT_OVER");	
		musicAliasloop ("mus_post_lady_fight", 2, 3);	
		musicStinger ("mus_noriega_misbehaving", 17, true);

	declaremusicState("PANAMA_BAD_NORIEGA");
		musicAliasloop ("mus_post_lady_fight", 3, 1);
	
	declareMusicState ("PANAMA_APACHE");
		musicAlias ("mus_apache");
		
	//TODO: Delete these after a new bsp goes in	
	level thread old_ambient_packages();	    
	
	level thread starting_snapshot();
	level thread song_player(); 
	level thread setup_ambient_fx_sounds();
	level thread setup_exploder_aliases();
	level thread snapshot_under_woods();
}
snapshot_under_woods()
{
	level waittill ("lsmn");
	snd_set_snapshot( "cmn_music_voice_only" );
}
starting_snapshot()
{
	level waittill ("lsn");
	snd_set_snapshot( "spl_panama_3_horror" );
	level waittill( "SND_ehs" );
	snd_set_snapshot( "default" );
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
	snd_play_auto_fx( "fx_water_drip_light_long_noripple", "amb_water_drip_1", 0, 0, 0, false);
	snd_play_auto_fx( "fx_pan_light_overhead", "amb_light_buzz", 0, 0, 0, true);
	
}

setup_exploder_aliases()
{
	//These occur pre/during the slide-out-of-the-building section, 3 simple explosions
	clientscripts\_audio::snd_add_exploder_alias( 562, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 561, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 560, "wpn_grenade_explode" );
}

old_ambient_packages()
{
	declareAmbientRoom( "outdoor" );
	setAmbientRoomTone ("outdoor","blk_panama_outdoor_bg", .5, .5);
	setAmbientRoomReverb ("outdoor","panama_city", 1, 1);
	setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "outdoor" );
	
	declareAmbientRoom( "indoor" );
	setAmbientRoomTone ("indoor","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("indoor","panama_mediumroom", 1, 1);
	setAmbientRoomContext( "indoor", "ringoff_plr", "indoor" );
	declareAmbientPackage( "indoor" );
	
	declareAmbientRoom( "battle" );
	setAmbientRoomTone ("battle","blk_panama_battle_bg", .5, .5);
	setAmbientRoomReverb ("battle","panama_city", 1, 1);
	setAmbientRoomContext( "battle", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "battle" );
	
	declareAmbientRoom( "stairwell" );
	setAmbientRoomTone ("stairwell","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("stairwell","panama_cave", 1, 1);
	setAmbientRoomContext( "stairwell", "ringoff_plr", "indoor" );

	declareAmbientRoom( "hangar" );
	setAmbientRoomTone ("hangar","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("hangar","panama_hangar", 1, 1);
	setAmbientRoomContext( "hangar", "ringoff_plr", "indoor" );
	
	declareAmbientRoom( "small_room" );
	setAmbientRoomTone ("small_room","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("small_room","panama_smallroom", 1, 1);
	setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );
	
	declareAmbientRoom( "medium_room" );
	setAmbientRoomTone ("medium_room","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("medium_room","panama_mediumroom", 1, 1);
	setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );	

	declareAmbientRoom( "large_room" );
	setAmbientRoomTone ("large_room","blk_panama_indoor_bg", .5, .5);
	setAmbientRoomReverb ("large_room","panama_largeroom", 1, 1);
	setAmbientRoomContext( "large_room", "ringoff_plr", "indoor" );
}