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
		setAmbientRoomTone ("house_outdoor","amb_cricket_blend", 1, 1);
		setAmbientRoomReverb ("house_outdoor","panama_neighborhood", 1, 1);
		setAmbientRoomContext( "house_outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "house_outdoor" );
		
		//House Shed: Wooden shed in the back yard, small
		declareAmbientRoom( "house_shed" );
		setAmbientRoomTone ("house_shed","amb_cricket_blend",  1, 1);
		setAmbientRoomReverb ("house_shed","panama_yard_shed", 1, 1);
		setAmbientRoomContext( "house_shed", "ringoff_plr", "outdoor" );
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
		
		//Airfield Hangar : Hanger outside of the airfield
		declareAmbientRoom( "airfield_hangar_large_room" );
		setAmbientRoomTone ("airfield_hangar_large_room","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("airfield_hangar_large_room","panama_hangar_largeroom", 1, 1);
		setAmbientRoomContext( "airfield_hangar_large_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "airfield_hangar_large_room" );
		
		//Airfield Hotel: Medium hotel room, carpeted floor, where the final airfield vignette takes place
		declareAmbientRoom( "airfield_hotel" );
		setAmbientRoomTone ("airfield_hotel","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("airfield_hotel","panama_mediumroom_hotel", 1, 1);
		setAmbientRoomContext( "airfield_hotel", "ringoff_plr", "indoor" );
		declareAmbientPackage( "airfield_hotel" );
		
		//Airfield Hotel: Medium hotel room, carpeted floor, where the final airfield vignette takes place
		declareAmbientRoom( "airfield_hotel_gaurd_rm" );
		setAmbientRoomTone ("airfield_hotel_gaurd_rm","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("airfield_hotel_gaurd_rm","panama_mediumroom_hotel", 1, 1);
		setAmbientRoomContext( "airfield_hotel_gaurd_rm", "ringoff_plr", "indoor" );
		declareAmbientPackage( "airfield_hotel_gaurd_rm" );
		
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
		
		//Slums Motel: Building with a bunch of scenes, normal, kind of like the rest of the interiors
		declareAmbientRoom( "slums_motel" );
		setAmbientRoomTone ("slums_motel","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("slums_motel","panama_slums_motelroom", 1, 1);
		setAmbientRoomContext( "slums_motel", "ringoff_plr", "indoor" );
		declareAmbientPackage( "slums_motel" );
		
	//DOCKS	
		//Docks Outdoor: Main package for the outdoor ambience of the slums section, big battles going on, etc
		declareAmbientRoom( "docks_outdoor" );
		setAmbientRoomTone ("docks_outdoor","blk_panama_battle_bg", .5, .5);
		setAmbientRoomReverb ("docks_outdoor","panama_outdoor_docks", 1, 1);
		setAmbientRoomContext( "docks_outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "docks_outdoor" );	
		
		//Docks Shipping Container: Interior of a shipping container
		declareAmbientRoom( "docks_shipping_container" );
		setAmbientRoomTone ("docks_shipping_container","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("docks_shipping_container","panama_container", 1, 1);
		setAmbientRoomContext( "docks_shipping_container", "ringoff_plr", "indoor" );
		declareAmbientPackage( "docks_shipping_container" );
		
		//Docks Warehouse: Medium building, metal walls, full of crap
		declareAmbientRoom( "docks_warehouse" );
		setAmbientRoomTone ("docks_warehouse","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("docks_warehouse","panama_busy_room", 1, 1);
		setAmbientRoomContext( "docks_warehouse", "ringoff_plr", "indoor" );
		declareAmbientPackage( "docks_warehouse" );
		
		//Docks Elevator: Metal freight elevator
		declareAmbientRoom( "docks_elevator" );
		setAmbientRoomTone ("docks_elevator","blk_panama_indoor_bg", .5, .5);
		setAmbientRoomReverb ("docks_elevator","panama_vader", 1, 1);
		setAmbientRoomContext( "docks_elevator", "ringoff_plr", "indoor" );
		declareAmbientPackage( "docks_elevator" );
		
	activateAmbientPackage( 0, "docks_outdoor", 0 );
	activateAmbientRoom( 0, "docks_outdoor", 0 );	


//MUSIC SETUP
	declaremusicState("PANAMA_INTRO");
		musicAliasloop ("mus_intro_pad_loop", 2, 0.5);
		musicStinger ("mus_intro_pad_STG", 0, true);
		
	declareMusicState ("PANAMA_GATE_OPENED");
		musicAliasloop ("null", 0, 0);
	
	declareMusicState ("PANAMA_ZODIAK");
		musicAliasloop ("mus_zodiac", 0, 2);
		
	declareMusicState ("PANAMA_BEACH");	
		musicAlias ("mus_stealth_in", 0.5);
		//musicStinger ("mus_context_kill_STG", 8, true);
	
	declareMusicState ("PANAMA_PRE_HANGAR_FIGHT");
		musicAliasloop ("mus_fight_to_hangar_loop", 0, 6);
		musicStinger ("mus_context_kill_STG", 1, true);
	
	declareMusicState ("PANAMA_AT_HANGAR");
		musicAliasloop ("mus_airport_meeting", 3, 2);
	
	declareMusicState ("PANAMA_ROOFTOPS");
		musicAliasloop ("mus_rooftops", 0, 3);
/*		
	declareMusicState ("PANAMA_POST_AIRPORT");
	musicAliasloop ("mus_panama_on_the_hotel", 0, 3);
*/
		
	declareMusicState ("PANAMA_HOTEL_RUN");
		musicAliasloop ("mus_hotel_run", 2, 2);
		musicStinger ("mus_noriega_breakin",  30, true);
		
	declareMusicState ("PANAMA_NORIEGA");
		musicAliasloop ("mus_intro_pad_loop", 0, 2);
	
		
		
	//TODO: Delete these after a new bsp goes in	
//	level thread old_ambient_packages();	    
	
	level thread song_player(); 
	level thread setup_ambient_fx_sounds();
	level thread setup_exploder_aliases();
	level thread motel_snapshot();
	level thread zodiac_underwater_snapshot();
	level thread grill_fire();
}

song_player()
{
   		wait (2); 
		playsound (0, "amb_song", (24019, -19919, 89 ));	
}
grill_fire()
{
	playloopat("amb_grill_fire", (23757, -19198, 32));
	
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
	snd_play_auto_fx( "fx_pan_light_overhead", "amb_street_light_buzz", 0, 0, 0, false);
	snd_play_auto_fx( "fx_pan_streetlight_flicker_glow", "amb_street_light_flicker", 0, 0, 0, false);
}

setup_exploder_aliases()
{
	//condo explo during boat ride in
	clientscripts\_audio::snd_add_exploder_alias( 250, "fxa_condo_explo" );
	//These occur pre/during the slide-out-of-the-building section, 3 simple explosions
	clientscripts\_audio::snd_add_exploder_alias( 562, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 561, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 560, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 298, "evt_guards_flare_explode" );
	
	
	
	clientscripts\_audio::snd_add_exploder_alias( 102, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 103, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 104, "wpn_grenade_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 105, "wpn_grenade_explode" );
	
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

motel_snapshot()
{
	level waittill( "mute_amb" );
	wait(4);
	snd_set_snapshot( "spl_panama_1_motel" );
}


zodiac_underwater_snapshot()
{
	level waittill ("underwater_on");
	snd_set_snapshot ("spl_panama_underwater");
	level waittill ("underwater_off");
	snd_set_snapshot ("default");
}
	
	