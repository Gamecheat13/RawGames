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
	level._audio_spiderbot_override = ::start_spiderbot_audio;
	
	//MAIN KARMA ENTRANCE
		//Karma Entrance Roof: High atop the building, like ridiculously high, construction going on, landing pads around, birds flying about
		declareAmbientRoom( "karma_entrance_roof" );
		setAmbientRoomTone ("karma_entrance_roof","", .5, .5);
		setAmbientRoomReverb ("karma_entrance_roof","gen_city", 1, 1);
		setAmbientRoomContext( "karma_entrance_roof", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_entrance_roof" );
		addAmbientElement( "karma_entrance_roof", "amb_wind_gust_oneshot", 5, 20, 100, 900 );
		
		//Karma Entrance Security: Closed roof, security scanners and officers around, rather dull compared to the next room. Hard floors.
		declareAmbientRoom( "karma_entrance_security" );
		setAmbientRoomTone ("karma_entrance_security","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_security","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_entrance_security", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_security" );
		
		//Karma Entrance Front Desk: Ornate, relaxing, lovely.  Closed walls and roof. Carpeted.
		declareAmbientRoom( "karma_entrance_desk" );
		setAmbientRoomTone ("karma_entrance_desk","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_desk","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_entrance_desk", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_desk" );
		
		//Karma Entrance Waiting Area: Partially open, big vista of the rest of the buildings and such, mostly hard floors, advertisements around
		declareAmbientRoom( "karma_entrance_waiting" );
		setAmbientRoomTone ("karma_entrance_waiting","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_waiting","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_entrance_waiting", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_waiting" );
		
		//Karma Entrance Elevator: Elevators that lead down to the main lobby.  Quiet, futuristic.
		declareAmbientRoom( "karma_entrance_elevator" );
		setAmbientRoomTone ("karma_entrance_elevator","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_entrance_elevator","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_entrance_elevator", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_elevator" );
	
	//HOTEL LOBBY
		//Karma Lobby Covered: Main lobby, covered sections have a roof above them, usually another floor.  Carpeted sometimes, huge, expansive
		declareAmbientRoom( "karma_lobby_covered" );
		setAmbientRoomTone ("karma_lobby_covered","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_lobby_covered","gen_city", 1, 1);
		setAmbientRoomContext( "karma_lobby_covered", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_lobby_covered" );
		
		//Karma Lobby UNCovered: Same as above, except without the roof above, usually a bridge overlooking everything below
		declareAmbientRoom( "karma_lobby_uncovered" );
		setAmbientRoomTone ("karma_lobby_uncovered","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_lobby_uncovered","gen_city", 1, 1);
		setAmbientRoomContext( "karma_lobby_uncovered", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_lobby_uncovered" );
		
		//Karma Lobby Elevator Area: Room off the main lobby, where you enter the elevator shaft.  Medium room, no carpet.
		declareAmbientRoom( "karma_lobby_elevator_area" );
		setAmbientRoomTone ("karma_lobby_elevator_area","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_lobby_elevator_area","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_lobby_elevator_area", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_lobby_elevator_area" );
		
	//ELEVATOR SHAFT
		//Elevator Shaft Elevator: Inside one of two elevators before/after being in the shaft.  Standard elevator.
		declareAmbientRoom( "karma_elshaft_elevator" );
		setAmbientRoomTone ("karma_elshaft_elevator","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_elshaft_elevator","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_elshaft_elevator", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_elshaft_elevator" );
		
		//Elevator Shaft: Self explanatory
		declareAmbientRoom( "karma_elshaft_shaft" );
		setAmbientRoomTone ("karma_elshaft_shaft","blk_karma_vent_bg", .5, .5);
		setAmbientRoomReverb ("karma_elshaft_shaft","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_elshaft_shaft", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_elshaft_shaft" );
		
	//CONSTRUCTION AREA	
		//Construction Area Medium: Enclosed area, undeveloped, major firefight occurs throughout here
		declareAmbientRoom( "karma_construct_med" );
		setAmbientRoomTone ("karma_construct_med","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_med","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_construct_med", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_med" );
		
		//Construction Area Small: Same as above, but small
		declareAmbientRoom( "karma_construct_sml" );
		setAmbientRoomTone ("karma_construct_sml","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_sml","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_construct_sml", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_sml" );
		
		//Construction Area Freight Elevator: Elevator that leads up to Solar Lounge
		declareAmbientRoom( "karma_construct_freight" );
		setAmbientRoomTone ("karma_construct_freight","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_freight","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_construct_freight", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_freight" );
		
	//SPIDERBOT SECTION
		//Karma Spider Vent: Metal all around, varies in size from small to medium
		declareAmbientRoom( "karma_spider_vent" );
		setAmbientRoomTone ("karma_spider_vent","blk_karma_vent_bg", .5, .5);
		setAmbientRoomReverb ("karma_spider_vent","gen_sewerpipe", 1, 1);
		setAmbientRoomContext( "karma_spider_vent", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_spider_vent" );
		
	//CIC SECTION	
		//CIC Main Area: Computer room, futuristic, pretty big
		declareAmbientRoom( "karma_cic_main" );
		setAmbientRoomTone ("karma_cic_main","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_cic_main","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_cic_main", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_cic_main" );
		
	//SOLAR CLUB SECTION
		//Solar Outer: Staging area for Solar Club, large rooms, many people, lights and advertisements, sometimes carpeted
		declareAmbientRoom( "karma_solar_outer" );
		setAmbientRoomTone ("karma_solar_outer","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_solar_outer","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_solar_outer", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_solar_outer" );
		
		//Solar Lounge: Pre-Club area, bar, hallways, hard floors, small
		declareAmbientRoom( "karma_solar_lounge" );
		setAmbientRoomTone ("karma_solar_lounge","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_solar_lounge","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_solar_lounge", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_solar_lounge" );
		
		//Solar Lounge: Pre-Club area, bar, hallways, hard floors, small
		declareAmbientRoom( "karma_solar_club" );
		setAmbientRoomTone ("karma_solar_club","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_solar_club","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_solar_club", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_solar_club" );
		
	//FINAL SECTION: Finding Karma	
		//Final - Medium Room: Medium sized room, nothing special
		declareAmbientRoom( "karma_final_room_med" );
		setAmbientRoomTone ("karma_final_room_med","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_final_room_med","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_final_room_med", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_final_room_med" );
		
		//Final - Room Partial: Wall open to one side, viewing the ocean
		declareAmbientRoom( "karma_final_room_partial" );
		setAmbientRoomTone ("karma_final_room_partial","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_final_room_partial","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "karma_final_room_partial", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_final_room_partial" );
		
		//Final - Room Atrium: Huge room, stone and brick everywhere, tall ceiling with a curved glass aspect
		declareAmbientRoom( "karma_final_room_atrium" );
		setAmbientRoomTone ("karma_final_room_atrium","blk_karma_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("karma_final_room_atrium","gen_city", 1, 1);
		setAmbientRoomContext( "karma_final_room_atrium", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_final_room_atrium" );
	
	//DEFAULT
		//Outdoor: All the outdoor sections at the bottom of the hotel, specifically post-Solar Club fight.  Any outdoor sections in the ABOVE area have their own packages
		declareAmbientRoom( "outdoor" );
		setAmbientRoomTone ("outdoor","blk_karma_pool_bg", .5, .5);
		setAmbientRoomReverb ("outdoor","gen_city", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "outdoor" );
	
	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );		
		
	//TODO: Delete this as soon as a new BSP goes in
	level thread old_ambient_packages();
	
	level thread spiderbot_amb_convo_triggers();
	level thread waitfor_bodyscan();
	level thread waitfor_bodyscan_end();
	level thread play_intro_blockout_pa_vox();
	level thread main_area_pa_vox_setup();
	level thread wait_to_start_club_music();
	level thread wait_to_start_club_crowd();
	thread snd_fx_create();
	
	array_thread(getstructarray( "primary_alarm", "targetname"), ::primary_alarm);
	array_thread(Getstructarray( "secondary_alarm", "targetname"), ::secondary_alarm);
	
}

//Self == Spiderbot
start_spiderbot_audio( player )
{
	self thread play_loops_for_player( player );
	self thread play_engine_audio();
	self thread change_ambient_room();
	//self thread play_static_loop();
}

change_ambient_room()
{
	self thread waitfor_exit_vehicle();
	
	activateAmbientPackage( 0, "spiderbot", 20 );
	activateAmbientRoom( 0, "spiderbot", 20 );
	level thread updateActiveAmbientRoom();
	level thread updateActiveAmbientPackage();
}

waitfor_exit_vehicle()
{
	self waittill( "exit_vehicle" );
	
	deactivateAmbientPackage( 0, "spiderbot", 20 );
	deactivateAmbientRoom( 0, "spiderbot", 20 );
}

play_loops_for_player( player )
{
	loop_ent_1 = spawn( 0, (0,0,0), "script_origin" );
	loop_ent_2 = spawn( 0, (0,0,0), "script_origin" );
		
	self thread loop_cleanup( "exit_vehicle", loop_ent_1, loop_ent_2 );
		
	loop_ent_1 playloopsound( "veh_spiderbot_ui_plr_loop1", 1 );
	loop_ent_2 playloopsound( "veh_spiderbot_ui_plr_loop2", 1 );
}

play_engine_audio()
{
	level endon( "spiderbot_audio_cleanup" );
	
	loop_ent_1 = spawn( 0, (0,0,0), "script_origin" );
	//loop_ent_2 = spawn( 0, (0,0,0), "script_origin" );
		
	self thread loop_cleanup( "exit_vehicle", loop_ent_1 );
	
	while(1)
	{
		if( self getspeed() >= 5 )
		{
			loop_ent_1 playloopsound( "veh_spiderbot_legs_loop_front", .05 );
			//loop_ent_2 playloopsound( "veh_spiderbot_legs_loop_back", .05 );
		}
		else
		{
			loop_ent_1 stoploopsound( .1 );
			//loop_ent_2 stoploopsound( .1 );
		}
		
		wait(.05);
	}
}

play_static_loop()
{
	level endon( "spiderbot_audio_cleanup" );
	
	loop_ent_1 = spawn( 0, (0,0,0), "script_origin" );
	self thread loop_cleanup( "exit_vehicle", loop_ent_1 );
	
	loop_id = loop_ent_1 playloopsound( "veh_spiderbot_static_loop", 1 );
	setsoundvolume( loop_id, 0 );
	
	while(1)
	{
		wait(randomfloatrange(2,5));
		setsoundvolume( loop_id, randomfloatrange(.8,1) );
		wait(randomfloatrange(0,2));
		setsoundvolume( loop_id, randomfloatrange(.4,1) );
		wait(randomfloatrange(0,2));
		setsoundvolume( loop_id, 0 );
	}
}

loop_cleanup( string, ent1, ent2, ent3, ent4 )
{
	if( !isdefined( string ) )
		return;
	
	self waittill( string );
	level notify( "spiderbot_audio_cleanup" );
	wait(.1);
	
	if( isdefined( ent1 ) )
		ent1 delete();
	
	if( isdefined( ent2 ) )
		ent2 delete();
	
	if( isdefined( ent3 ) )
		ent3 delete();
	
	if( isdefined( ent4 ) )
		ent4 delete();
}

spiderbot_amb_convo_triggers()
{
	wait(5);
	array_thread( getentarray( 0, "audio_spiderbot_convo", "targetname" ), ::waitfor_convo_trigger );
}

waitfor_convo_trigger()
{
	self waittill( "trigger" );
	
	//playsound( 0, "vox_spd_voice", self.origin );
	
	struct = getstruct( self.target, "targetname" );
	if( isdefined( struct.script_sound ) )
	{
		playsound( 0, struct.script_sound, struct.origin );
	}
}

waitfor_bodyscan()
{
	level waittill( "kbss" );
	snd_set_snapshot( "spl_karma_bodyscan" );
}

waitfor_bodyscan_end()
{
	level waittill( "kbse" );
	snd_set_snapshot( "default" );
}

play_intro_blockout_pa_vox()
{
	level endon( "sbpv" );
	level endon( "slpa" );
	
	wait(5);
	
	location = [];
	location[0] = spawnstruct();
	location[0].origin = (5172, -10291, 1145);
	location[0].alias = "vox_blk_pa_welcome_lrg";
	location[1] = spawnstruct();
	location[1].origin = (5063, -9699, 1036);
	location[1].alias = "vox_blk_pa_welcome_sml";
	location[2] = spawnstruct();
	location[2].origin = (5265, -9697, 1039);
	location[2].alias = "vox_blk_pa_welcome_sml";
	location[3] = spawnstruct();
	location[3].origin = (5158, -8890, 1058);
	location[3].alias = "vox_blk_pa_welcome_sml";
	location[4] = spawnstruct();
	location[4].origin = (5159, -8286, 818);
	location[4].alias = "vox_blk_pa_welcome_sml";
	location[5] = spawnstruct();
	location[5].origin = (4958, -7645, 769);
	location[5].alias = "vox_blk_pa_welcome_sml";
	location[6] = spawnstruct();
	location[6].origin = (5373, -7589, 773);
	location[6].alias = "vox_blk_pa_welcome_sml";
	
	while(1)
	{
		for(i=0;i<location.size;i++)
		{
			playsound(0, location[i].alias, location[i].origin );
		}
		
		wait(18);
	}
}


primary_alarm()
{
	
	level waittill ( "alarm_on" );

	sound_ent = spawn(0, self.origin, "script_origin" );
	sound_ent playloopsound( "evt_primary_alarm", .1 );
	wait(10);
	sound_ent stoploopsound( 1 );
	wait(1);
	sound_ent delete();
}

secondary_alarm()
{
alarm_ent = spawn (0, (self.origin), "script_origin");	
	
level waittill ( "alarm_on" );

alarm_ent PlayLoopSound ("evt_secondary_alarm");

wait(18);

alarm_ent stoploopsound(.1);

PlaySound (0, "evt_secondary_alarm_off", alarm_ent.origin);

wait(2);

alarm_ent delete();

}

main_area_pa_vox_setup()
{
	level waittill( "slpa" );
	
	test = getentarray(0,"karma_pa_lobby","targetname");
	if( !isdefined( test[0] ) )
		return;
	
	pa_vox = [];
	pa_vox[0] = [];
	pa_vox[1] = [];
	
	for(i=0;i<5;i++)
	{
		pa_vox[0][i] = "vox_karma_pa_remind_0" + i;
		pa_vox[1][i] = "vox_karma_pa_ad_0" + i;
	}
	
	array_vox_remind = array_randomize( pa_vox[0] );
	array_vox_ad = array_randomize( pa_vox[1] );
	
	array_thread( getentarray(0,"karma_pa_lobby","targetname"), ::play_main_area_pa_muzak );
	level thread pick_and_play_pa_vox( pa_vox );
}

pick_and_play_pa_vox( pa_vox )
{
	ent_array = getentarray(0,"karma_pa_lobby","targetname");
	num = 0;
	
	old_array = [];
	old_array[0] = pa_vox[0];
	old_array[1] = pa_vox[1];
	
	wait(randomintrange(5,11));
	
	while(1)
	{
		if( num > 1 )
			num = 0;
		
		alias = random( pa_vox[num] );
		array_remove( pa_vox[num], alias );
		
		for(i=0;i<ent_array.size;i++)
		{
			playsound( 0,alias,ent_array[i].origin );
		}
		
		if( pa_vox[num].size <= 0 )
		{
			pa_vox[num] = old_array[num];
		}
		
		wait(randomintrange(30,40));
		num++;
	}
}

play_main_area_pa_muzak()
{
	self playloopsound( "mus_karma_lobby", 1 );
}

wait_to_start_club_music()
{
	wait(2);
	struct = getstruct( "blk_mus_club", "targetname" );
	ent1 = spawn( 0, struct.origin, "script_origin" );
	ent2 = spawn( 0, struct.origin, "script_origin" );
	
	level thread play_club_lowend_until_door( struct );
	
	level waittill( "scms" );
	
	ent1 playloopsound( "blk_mus_club", .1 );
	
	level waittill( "scm2" );
	
	ent1 stoploopsound( 1 );
	ent2 playloopsound( "blk_mus_club_quiet", .1 );
	
	level waittill( "scm3" );
	
	ent2 stoploopsound( 1 );
	ent1 playloopsound( "blk_mus_club_fight", .1 );
	
	wait(110);
	ent1 stoploopsound( 3 );
	wait(3);
	
	ent1 delete();
	ent2 delete();
}

play_club_lowend_until_door( struct )
{
	level waittill( "scle" );
	
	ent1 = spawn( 0, struct.origin, "script_origin" );
	ent1 playloopsound( "blk_mus_club_lowend", 3 );
	
	level waittill( "scms" );
	
	ent1 stoploopsound( .5 );
	wait(2);
	ent1 delete();
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


//TODO: Delete this as soon as new BSP goes in
old_ambient_packages()
{
	declareAmbientRoom( "outdoor" );
	setAmbientRoomTone ("outdoor","blk_karma_outdoor_bg", .5, .5);
	setAmbientRoomReverb ("outdoor","gen_city", 1, 1);
	setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "outdoor" );
	
	declareAmbientRoom( "pool" );
	setAmbientRoomTone ("pool","blk_karma_pool_bg", .5, .5);
	setAmbientRoomReverb ("pool","gen_city", 1, 1);
	setAmbientRoomContext( "pool", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "pool" );
	
	declareAmbientRoom( "hall" );
	setAmbientRoomTone ("hall","blk_karma_hall_bg", .5, .5);
	setAmbientRoomReverb ("hall","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "hall", "ringoff_plr", "indoor" );
	declareAmbientPackage( "hall" );
	
	declareAmbientRoom( "lobby" );
	setAmbientRoomTone ("lobby","blk_karma_lobby_bg", .5, .5);
	setAmbientRoomReverb ("lobby","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "lobby", "ringoff_plr", "indoor" );
	declareAmbientPackage( "lobby" );
	
	declareAmbientRoom( "club" );
	setAmbientRoomTone ("club","blk_karma_lobby_bg", .5, .5);
	setAmbientRoomReverb ("club","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "club", "ringoff_plr", "indoor" );
	declareAmbientPackage( "club" );
	
	declareAmbientRoom( "atrium" );
	setAmbientRoomTone ("atrium","blk_karma_lobby_bg", .5, .5);
	setAmbientRoomReverb ("atrium","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "atrium", "ringoff_plr", "indoor" );
	declareAmbientPackage( "atrium" );
	
	declareAmbientRoom( "office" );
	setAmbientRoomTone ("office","blk_karma_office_bg", .5, .5);
	setAmbientRoomReverb ("office","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "office", "ringoff_plr", "indoor" );
	declareAmbientPackage( "office" );
	
	declareAmbientRoom( "computer_room" );
	setAmbientRoomTone ("computer_room","blk_karma_office_bg", .5, .5);
	setAmbientRoomReverb ("computer_room","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "computer_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "computer_room" );
	
	declareAmbientRoom( "elevator_shaft" );
	setAmbientRoomTone ("elevator_shaft","blk_karma_vent_bg", .5, .5);
	setAmbientRoomReverb ("elevator_shaft","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "elevator_shaft", "ringoff_plr", "indoor" );
	declareAmbientPackage( "elevator_shaft" );
	
	declareAmbientRoom( "bedroom" );
	setAmbientRoomTone ("bedroom","blk_karma_office_bg", .5, .5);
	setAmbientRoomReverb ("bedroom","gen_largeroom", 1, 1);
	setAmbientRoomContext( "bedroom", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bedroom" );
	
	declareAmbientRoom( "vent_small" );
	setAmbientRoomTone ("vent_small","blk_karma_vent_bg", .5, .5);
	setAmbientRoomReverb ("vent_small","gen_sewerpipe", 1, 1);
	setAmbientRoomContext( "vent_small", "ringoff_plr", "indoor" );
	declareAmbientPackage( "vent_small" );
	
	declareAmbientRoom( "vent_fanroom" );
	setAmbientRoomTone ("vent_fanroom","blk_karma_vent_bg", .5, .5);
	setAmbientRoomReverb ("vent_fanroom","gen_sewerpipe", 1, 1);
	setAmbientRoomContext( "vent_fanroom", "ringoff_plr", "indoor" );
	declareAmbientPackage( "vent_fanroom" );
	
	declareAmbientRoom( "hallway" );
	setAmbientRoomTone ("hallway","blk_karma_hall_bg", .5, .5);
	setAmbientRoomReverb ("hallway","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "hallway", "ringoff_plr", "indoor" );
	declareAmbientPackage( "hallway" );
	
	declareAmbientRoom( "spiderbot" );
	setAmbientRoomTone ("spiderbot","", .5, .5);
	setAmbientRoomReverb ("spiderbot","gen_smallroom", 1, 1);
	setAmbientRoomContext( "spiderbot", "ringoff_plr", "indoor" );
	declareAmbientPackage( "spiderbot" );
}