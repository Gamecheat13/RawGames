//
// file: karma_amb.csc
// description: clientside ambient script for karma: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_audio;

main()
{
		
	//MAIN KARMA ENTRANCE
		//Karma Entrance Roof: High atop the building, like ridiculously high, construction going on, landing pads around, birds flying about
		declareAmbientRoom( "karma_entrance_roof" );
		setAmbientRoomTone ("karma_entrance_roof","blk_karma_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_roof","karma_roof", 1, 1);
		setAmbientRoomContext( "karma_entrance_roof", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_entrance_roof" );
		
		//Karma Entrance Security: Closed roof, security scanners and officers around, rather dull compared to the next room. Hard floors.
		declareAmbientRoom( "karma_entrance_security" );
		setAmbientRoomTone ("karma_entrance_security","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_security","karma_security", 1, 1);
		setAmbientRoomContext( "karma_entrance_security", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_security" );
		
		//Karma Entrance Front Desk: Ornate, relaxing, lovely.  Closed walls and roof. Carpeted.
		declareAmbientRoom( "karma_entrance_desk" );
		setAmbientRoomTone ("karma_entrance_desk","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_desk","karma_lobby", 1, 1);
		setAmbientRoomContext( "karma_entrance_desk", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_desk" );
		
		//Karma Entrance Waiting Area: Partially open, big vista of the rest of the buildings and such, mostly hard floors, advertisements around
		declareAmbientRoom( "karma_entrance_waiting" );
		setAmbientRoomTone ("karma_entrance_waiting","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_waiting","karma_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_entrance_waiting", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_waiting" );
		
		//Karma Entrance Elevator: Elevators that lead down to the main lobby.  Quiet, futuristic.
		declareAmbientRoom( "karma_entrance_elevator" );
		setAmbientRoomTone ("karma_entrance_elevator","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_elevator","karma_vader", 1, 1);
		setAmbientRoomContext( "karma_entrance_elevator", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_elevator" );
	
	//HOTEL LOBBY
		//Karma Lobby Covered: Main lobby, covered sections have a roof above them, usually another floor.  Carpeted sometimes, huge, expansive
		declareAmbientRoom( "karma_lobby_covered" );
		setAmbientRoomTone ("karma_lobby_covered","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_lobby_covered","karma_lobby", 1, 1);
		setAmbientRoomContext( "karma_lobby_covered", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_lobby_covered" );
		
		//Karma Lobby UNCovered: Same as above, except without the roof above, usually a bridge overlooking everything below
		declareAmbientRoom( "karma_lobby_uncovered" );
		setAmbientRoomTone ("karma_lobby_uncovered","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_lobby_uncovered","karma_lobby", 1, 1);
		setAmbientRoomContext( "karma_lobby_uncovered", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_lobby_uncovered" );
		
		//Karma Lobby Elevator Area: Room off the main lobby, where you enter the elevator shaft.  Medium room, no carpet.
		declareAmbientRoom( "karma_lobby_elevator_area" );
		setAmbientRoomTone ("karma_lobby_elevator_area","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_lobby_elevator_area","karma_elevator_area", 1, 1);
		setAmbientRoomContext( "karma_lobby_elevator_area", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_lobby_elevator_area" );
		
	//ELEVATOR SHAFT
		//Elevator Shaft Elevator: Inside one of two elevators before/after being in the shaft.  Standard elevator.
		declareAmbientRoom( "karma_elshaft_elevator" );
		setAmbientRoomTone ("karma_elshaft_elevator","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_elshaft_elevator","karma_vader", 1, 1);
		setAmbientRoomContext( "karma_elshaft_elevator", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_elshaft_elevator" );
		
		//Elevator Shaft: Self explanatory
		declareAmbientRoom( "karma_elshaft_shaft" );
		setAmbientRoomTone ("karma_elshaft_shaft","blk_karma_vent_bg", .5, .5);
		setAmbientRoomReverb ("karma_elshaft_shaft","karma_shaft", 1, 1);
		setAmbientRoomContext( "karma_elshaft_shaft", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_elshaft_shaft" );
		
	//CONSTRUCTION AREA	
		//Construction Area Medium: Enclosed area, undeveloped, major firefight occurs throughout here
		declareAmbientRoom( "karma_construct_med" );
		setAmbientRoomTone ("karma_construct_med","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_med","karma_construct_site", 1, 1);
		setAmbientRoomContext( "karma_construct_med", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_med" );
		
		//Construction Area Small: Same as above, but small
		declareAmbientRoom( "karma_construct_sml" );
		setAmbientRoomTone ("karma_construct_sml","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_sml","karma_construct_site_sml", 1, 1);
		setAmbientRoomContext( "karma_construct_sml", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_sml" );
		
		//Construction Area Freight Elevator: Elevator that leads up to Solar Lounge
		declareAmbientRoom( "karma_construct_freight" );
		setAmbientRoomTone ("karma_construct_freight","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_freight","karma_vader_freight", 1, 1);
		setAmbientRoomContext( "karma_construct_freight", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_freight" );
		
	//SPIDERBOT SECTION
		//Karma Spider Vent: Metal all around, varies in size from small to medium
		declareAmbientRoom( "karma_spider_vent" );
		setAmbientRoomTone ("karma_spider_vent","blk_karma_vent_bg", .5, .5);
		setAmbientRoomReverb ("karma_spider_vent","karma_spider_vents", 1, 1);
		setAmbientRoomContext( "karma_spider_vent", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_spider_vent" );
		
	//CIC SECTION	
		//CIC Main Area: Computer room, futuristic, pretty big
		declareAmbientRoom( "karma_cic_main" );
		setAmbientRoomTone ("karma_cic_main","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_cic_main","karma_comproom_lg", 1, 1);
		setAmbientRoomContext( "karma_cic_main", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_cic_main" );
		
	//SOLAR CLUB SECTION
		//Solar Outer: Staging area for Solar Club, large rooms, many people, lights and advertisements, sometimes carpeted
		declareAmbientRoom( "karma_solar_outer" );
		setAmbientRoomTone ("karma_solar_outer","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_solar_outer","karma_club_outer_dead", 1, 1);
		setAmbientRoomContext( "karma_solar_outer", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_solar_outer" );
		
		//Solar Lounge: Pre-Club area, bar, hallways, hard floors, small
		declareAmbientRoom( "karma_solar_lounge" );
		setAmbientRoomTone ("karma_solar_lounge","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_solar_lounge","karma_club_outer_bar", 1, 1);
		setAmbientRoomContext( "karma_solar_lounge", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_solar_lounge" );
		
		//Solar Lounge: Pre-Club area, bar, hallways, hard floors, small
		declareAmbientRoom( "karma_solar_club" );
		setAmbientRoomTone ("karma_solar_club","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_solar_club","karma_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_solar_club", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_solar_club" );
		
	//FINAL SECTION: Finding Karma	
		//Final - Medium Room: Medium sized room, nothing special
		declareAmbientRoom( "karma_final_room_med" );
		setAmbientRoomTone ("karma_final_room_med","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_final_room_med","karma_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_final_room_med", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_final_room_med" );
		
		//Final - Room Partial: Wall open to one side, viewing the ocean
		declareAmbientRoom( "karma_final_room_partial" );
		setAmbientRoomTone ("karma_final_room_partial","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_final_room_partial","karma_partial", 1, 1);
		setAmbientRoomContext( "karma_final_room_partial", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_final_room_partial" );
		
		//Final - Room Atrium: Huge room, stone and brick everywhere, tall ceiling with a curved glass aspect
		declareAmbientRoom( "karma_final_room_atrium" );
		setAmbientRoomTone ("karma_final_room_atrium","blk_karma_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("karma_final_room_atrium","karma_artium_huge", 1, 1);
		setAmbientRoomContext( "karma_final_room_atrium", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_final_room_atrium" );
		
		//Final - pool area with inclosed sections
		declareAmbientRoom( "karma_poolroom_over" );
		setAmbientRoomTone ("karma_poolroom_over","blk_karma_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("karma_poolroom_over","karma_pool_area", 1, 1);
		setAmbientRoomContext( "karma_poolroom_over", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_poolroom_over" );
		
		//FINAL - security room before heli pad
		declareAmbientRoom( "karma_security_room" );
		setAmbientRoomReverb ("karma_security_room","karma_security", 1, 1);
		setAmbientRoomContext( "karma_security_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_security_room" );
	
	//DEFAULT
		//Outdoor: All the outdoor sections at the bottom of the hotel, specifically post-Solar Club fight.  Any outdoor sections in the ABOVE area have their own packages
		declareAmbientRoom( "outdoor" );
		setAmbientRoomTone ("outdoor","blk_karma_pool_bg", .5, .5);
		setAmbientRoomReverb ("outdoor","karma_city", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "outdoor" );
	
	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );		
	
	thread snd_fx_create();	
	thread setup_ambient_fx_sounds();
	//level thread pa_setup();
}

pa_setup()
{
	array = getstructarray("snd_pa","targetname");
	if( !isdefined( array[0] ) )
		return;
	
	pa_vox = [];
	pa_vox[0] = "vox_kar_12_01_006a_pa";
	pa_vox[1] = "vox_kar_3_01_001a_pa";
	pa_vox[2] = "vox_kar_12_01_004a_pa";
	
	array_vox = array_randomize( pa_vox );

	level thread pick_and_play_pa_vox( pa_vox, array );
}

pick_and_play_pa_vox( vox_array, struct_array )
{
	
	wait(randomintrange(5,11));
	num = 0;
	while(1)
	{
		if( num > 2 )
			num = 0;
		
		for(i=0;i<struct_array.size;i++)
		{
			playsound( 0,vox_array[num],struct_array[i].origin );
		}
		
		wait(randomintrange(20,25));
		num++;
	}
}

wait_to_start_club_crowd()
{
	level waittill( "scle" );
	
	struct = getstruct( "blk_mus_club", "targetname" );
	ent1 = spawn( 0, struct.origin, "script_origin" );
	
	ent1 playloopsound( "blk_karma_club_bg", 2 );
	
	level waittill( "scm2" );
	

	ent1 stoploopsound( 1 );
	
	wait(2);
	
	ent1 delete();
}

snd_fx_create()
{
	//wait (1);
	waitforclient(0);
	
	clientscripts\_audio::snd_add_exploder_alias( 913, "exp_metalstorm_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 914, "exp_metalstorm_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 915, "exp_metalstorm_explode" );
}
setup_ambient_fx_sounds()
{		
	
	snd_play_auto_fx( "fx_fire_line_xsm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_fuel_sm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_line_sm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_fuel_sm_line", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_fuel_sm_ground", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_line_md", "amb_fire_medium", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_sm_smolder", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_md_smolder", "amb_fire_medium", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	
	snd_play_auto_fx ( "fx_water_fire_sprinkler", "amb_fire_sprinkler", 10, 0, 0, true );
}