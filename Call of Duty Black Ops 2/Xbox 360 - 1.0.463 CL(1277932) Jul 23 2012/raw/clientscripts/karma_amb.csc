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
	
	snd_set_snapshot("spl_karma_fade_in");	
	
	//MAIN KARMA ENTRANCE
		//Karma Entrance Roof: High atop the building, like ridiculously high, construction going on, landing pads around, birds flying about
		declareAmbientRoom( "karma_entrance_roof" );
		setAmbientRoomTone ("karma_entrance_roof","", .5, .5);
		setAmbientRoomReverb ("karma_entrance_roof","karma_roof", 1, 1);
		setAmbientRoomContext( "karma_entrance_roof", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_entrance_roof" );
		addAmbientElement( "karma_entrance_roof", "amb_wind_gust_oneshot", 5, 20, 100, 900 );
		
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
		setAmbientRoomReverb ("karma_entrance_elevator","karma_vader_future", 1, 1);
		setAmbientRoomContext( "karma_entrance_elevator", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_entrance_elevator" );
		
		declareAmbientRoom( "karma_salazar_exit_room" );
		setAmbientRoomTone ("karma_salazar_exit_room","blk_karma_hall_bg", .5, .5);
		setAmbientRoomReverb ("karma_salazar_exit_room","karma_smallroom", 1, 1);
		setAmbientRoomContext( "karma_salazar_exit_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_salazar_exit_room" );
	
	//HOTEL LOBBY
		//Karma Lobby Covered: Main lobby, covered sections have a roof above them, usually another floor.  Carpeted sometimes, huge, expansive
		//declareAmbientRoom( "karma_lobby_covered" );
		//setAmbientRoomTone ("karma_lobby_covered","blk_karma_lobby_bg", .5, .5);
		//setAmbientRoomReverb ("karma_lobby_covered","karma_city", 1, 1);
		//setAmbientRoomContext( "karma_lobby_covered", "ringoff_plr", "outdoor" );
		//declareAmbientPackage( "karma_lobby_covered" );
		
		//Karma Lobby UNCovered: Same as above, except without the roof above, usually a bridge overlooking everything below
		//declareAmbientRoom( "karma_lobby_uncovered" );
		//setAmbientRoomTone ("karma_lobby_uncovered","blk_karma_lobby_bg", .5, .5);
		//setAmbientRoomReverb ("karma_lobby_uncovered","karma_city", 1, 1);
		//setAmbientRoomContext( "karma_lobby_uncovered", "ringoff_plr", "outdoor" );
		//declareAmbientPackage( "karma_lobby_uncovered" );
		
		//Karma Lobby Elevator Area: Room off the main lobby, where you enter the elevator shaft.  Medium room, no carpet.
		declareAmbientRoom( "karma_lobby_elevator_area" );
		setAmbientRoomTone ("karma_lobby_elevator_area","blk_karma_hall_bg", 1, 1);
		setAmbientRoomReverb ("karma_lobby_elevator_area","karma_elevator_area", 1, 1);
		setAmbientRoomContext( "karma_lobby_elevator_area", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_lobby_elevator_area" );
		
	//ELEVATOR SHAFT
		//Elevator Shaft Elevator: Inside one of two elevators before/after being in the shaft.  Standard elevator.
		//declareAmbientRoom( "karma_elshaft_elevator" );
		//setAmbientRoomTone ("karma_elshaft_elevator","blk_karma_hall_bg", .5, .5);
		//setAmbientRoomReverb ("karma_elshaft_elevator","karma_mediumroom", 1, 1);
		//setAmbientRoomContext( "karma_elshaft_elevator", "ringoff_plr", "indoor" );
		//declareAmbientPackage( "karma_elshaft_elevator" );
		
		//Elevator Shaft: Self explanatory
		//declareAmbientRoom( "karma_elshaft_shaft" );
		//setAmbientRoomTone ("karma_elshaft_shaft","blk_karma_vent_bg", .5, .5);
		//setAmbientRoomReverb ("karma_elshaft_shaft","karma_mediumroom", 1, 1);
		//setAmbientRoomContext( "karma_elshaft_shaft", "ringoff_plr", "indoor" );
		//declareAmbientPackage( "karma_elshaft_shaft" );
		
	//CONSTRUCTION AREA	
		//Construction Area Medium: Enclosed area, undeveloped, major firefight occurs throughout here
		declareAmbientRoom( "karma_construct_med" );
		setAmbientRoomTone ("karma_construct_med","amb_karma_const_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_med","karma_construct_site", 1, 1);
		setAmbientRoomContext( "karma_construct_med", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_med" );
		
		//Construction Area Small: Same as above, but small
		declareAmbientRoom( "karma_construct_sml" );
		setAmbientRoomTone ("karma_construct_sml","amb_karma_const_bg", .5, .5);
		setAmbientRoomReverb ("karma_construct_sml","karma_construct_site_sml", 1, 1);
		setAmbientRoomContext( "karma_construct_sml", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_construct_sml" );
		
		//Office adjacent to construction area
		declareAmbientRoom( "karma_office_med" );
		setAmbientRoomTone ("karma_office_med","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_office_med","karma_office_sml", 1, 1);
		setAmbientRoomContext( "karma_office_med", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_office_med" );
		
		declareAmbientRoom( "karma_office_hall" );
		setAmbientRoomTone ("karma_office_hall","blk_karma_office_bg", .5, .5);
		setAmbientRoomReverb ("karma_office_hall","karma_office_sml", 1, 1);
		setAmbientRoomContext( "karma_office_hall", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_office_hall" );
		
		
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

//adding to fix assert

		//Karma Spider Vent: Metal all around, varies in size from small to medium
		declareAmbientRoom( "spiderbot" );
		setAmbientRoomTone ("spiderbot","blk_karma_vent_bg", .5, .5);
		setAmbientRoomReverb ("spiderbot","karma_spider_vents", 1, 1);
		setAmbientRoomContext( "spiderbot", "ringoff_plr", "indoor" );
		declareAmbientPackage( "spiderbot" );
		
	//CIC SECTION	
		//CIC Main Area: Computer room, futuristic, pretty big
		declareAmbientRoom( "karma_cic_main" );
		setAmbientRoomTone ("karma_cic_main","amb_karma_computer_bg", .5, .5);
		setAmbientRoomReverb ("karma_cic_main","karma_comproom_lg", 1, 1);
		setAmbientRoomContext( "karma_cic_main", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_cic_main" );
		
		declareAmbientRoom( "karma_cic_main_sml" );
		setAmbientRoomTone ("karma_cic_main_sml","amb_karma_computer_bg", .5, .5);
		setAmbientRoomReverb ("karma_cic_main_sml","karma_comproom_sml", 1, 1);
		setAmbientRoomContext( "karma_cic_main_sml", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_cic_main_sml" );
		
	//SOLAR CLUB SECTION
		//Solar Outer: before outer solar entrance, tile flooring large room
		declareAmbientRoom( "karma_pre_outer" );
		setAmbientRoomTone ("karma_pre_outer","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_pre_outer","karma_club_outer_live", 1, 1);
		setAmbientRoomContext( "karma_pre_outer", "ringoff_plr", "indoor" );
		declareAmbientPackage( "karma_pre_outer" );

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
		
		//Club solar: UP IN DA CLUB
		declareAmbientRoom( "karma_solar_club" );
		setAmbientRoomTone ("karma_solar_club","blk_karma_lobby_bg", .5, .5);
		setAmbientRoomReverb ("karma_solar_club","karma_club_solar", 1, 1);
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
		setAmbientRoomContext( "karma_final_room_partial", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_final_room_partial" );
		
		//Final - Room Atrium: Huge room, stone and brick everywhere, tall ceiling with a curved glass aspect
		declareAmbientRoom( "karma_final_room_atrium" );
		setAmbientRoomTone ("karma_final_room_atrium","blk_karma_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("karma_final_room_atrium","karma_artium_huge", 1, 1);
		setAmbientRoomContext( "karma_final_room_atrium", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "karma_final_room_atrium" );
	
	//DEFAULT
		//Outdoor: All the outdoor sections at the bottom of the hotel, specifically post-Solar Club fight.  Any outdoor sections in the ABOVE area have their own packages
		declareAmbientRoom( "outdoor" );
		setAmbientRoomTone ("outdoor","blk_karma_pool_bg", .5, .5);
		setAmbientRoomReverb ("outdoor","karma_city", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "outdoor" );
		
		//Ospree cockpit
		declareAmbientRoom( "ospree" );
		setAmbientRoomTone ("ospree","", .5, .5);
		setAmbientRoomReverb ("ospree","karma_cockpit", 1, 1);
		setAmbientRoomContext( "ospree", "ringoff_plr", "indoor" );
		declareAmbientPackage( "ospree" );
	
	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );		
	
	//MUSIC
	declaremusicState ("KARMA_1_INTRO");
		musicAlias ("mus_karma_intro", 0);
		musicAliasloop ("NULL", 0, 0);
	
	declareMusicState ("KARMA_1_CHECKIN");
		musicAlias ("mus_karma_checkin", 0);
		//musicStinger ("mus_karma_construction", 0, true);
		
	declareMusicState ("KARMA_1_CONSTRUCTION");
		musicAlias ("mus_karma_construction", 0);		
		musicAliasloop ("mus_karma_dark_loop", 3, 3);
		
	declaremusicState ("KARMA_1_SPIDERBOT");
		musicAliasloop ("mus_karma_spiderbot", 0, 1);
		musicStinger ("mus_karma_spiderbot_stg", 10, true);
	
	declaremusicState ("KARMA_1_GULLIVER");
		musicAliasloop ("mus_karma_dark_loop", 3, 0);
	
	declareMusicState ("KARMA_1_ENTER_CRC");
		musicAliasloop ("mus_karma_crc_fight", 0, 2);
		
	declaremusicState ("KARMA_1_CRC");
		musicAlias ("mus_karma_crc_room", 0);
		musicAliasloop ("mus_karma_dark_loop_b", 0, 0);
		
		
	declareMusicState ("KARMA_POST_CRC");
		musicAliasloop ("mus_karma_post_crc", 0, 0);
		musicStinger ("mus_karma_post_crc_stg", 0);
		
	declareMusicState ("KARMA_ELEVATOR");
		musicAliasloop ("mus_karma_dark_loop", 2, 0);
		
	declareMusicState ("KARMA_1_OUTER_SOLAR");	
		musicAliasloop ("null", 0, 1);
			
	declareMusicState ("KARMA_1_ENTER_CLUB");	
		musicAliasloop ("NULL", 0, 0);
			
	declareMusicState ("KARMA_1_DEFALCO");	
		musicAliasloop ("mus_karma_defalco_scene", 0, 0);
	
	declareMusicState ("KARMA_1_CLUB_FIGHT");
		musicAliasloop ("NULL", 0, 0);
	
	level thread spiderbot_amb_convo_triggers();
	level thread waitfor_bodyscan();
	level thread waitfor_bodyscan_end();
	//level thread play_intro_blockout_pa_vox();
	//level thread main_area_pa_vox_setup();
	level thread wait_to_start_club_music();
	level thread wait_to_start_club_crowd();
	level thread turn_on_bullet_snapshot();
	level thread turn_off_bullet_snapshot();
	thread snd_fx_create();
	level thread wait_for_flag_set_lull();
	level thread wait_for_flag_set_action();
	level thread snapshot_check();
	level thread ospree_ambient_room();
	level thread reset_room();
	thread snd_start_autofx_audio();
	level thread checkin_sounds();
	level thread solarMusicDuck();
	level thread levelFadeOut();
	
	array_thread(getstructarray( "primary_alarm", "targetname"), ::primary_alarm);
}
//Eckert - Fixes fade in when using skiptos (from Shawn J)
snapshot_check()
{
	level endon ("intr_on");
	wait (3);
	//iprintlnbold ("snp_default");
	snd_set_snapshot("default");	
}
//Self == Spiderbot
start_spiderbot_audio( player )
{
	self thread play_loops_for_player( player );
	self thread play_engine_audio();
	self thread change_ambient_room();
	//self thread play_static_loop();
	self thread snd_spiderbot_look_servo_start();
}
snd_spiderbot_look_servo(loop)
{
	self endon( "entityshutdown" );
	

	while (1)
	{
		movement = self GetNormalizedCameraMovement();
	
		movement = abs(movement[0]);
		
		//print3d( self.origin + (AnglesToForward (self.angles) * 1000 ), "movement- " + movement,  (0.0, 0.8, 0.0), 1, 3, 1 );
	
		soundVolume = scale_speed ( .1, .99, 0, 1, movement);	
		
		//print3d( self.origin + (0,0,-100) + (AnglesToForward (self.angles) * 1000 ), "soundVolume- " + soundVolume,  (0.0, 0.8, 0.0), 1, 3, 1 );
		
		setSoundVolume( loop, soundVolume * soundVolume * soundVolume );
		//setSoundVolumeRate( loopSound, .5 );	
		//setSoundPitch( loopSound, 1 );
		//setSoundPitchRate( loopSound, 1 );
		
		wait (.001);
	}
}
snd_spiderbot_look_servo_start ( loopSoundEnt )
{

	loopSoundEnt = spawn( 0, self.origin, "script_origin" );
	loopSound = loopSoundEnt PlayLoopSound ( "veh_spiderbot_look_servo" ,0);

	self thread snd_spiderbot_look_servo(loopSound);

	self waittill_any ("entityshutdown", "drpdn");
	
	loopSoundEnt stoploopsound ();
	wait (1);
	loopSoundEnt delete();

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
		ArrayRemoveValue( pa_vox[num], alias );
		
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
	
	ent1 thread temp_stop_sound_wait();
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
temp_stop_sound_wait()
{
	//wait(.25);
	self stoploopsound( .25 );
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
	level waittill( "scm2" );
	level notify( "stop_solar_walla" );
}

snd_fx_create()
{
	//wait (1);
	waitforclient(0);
	
	clientscripts\_audio::snd_add_exploder_alias( 913, "exp_metalstorm_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 914, "exp_metalstorm_explode" );
	clientscripts\_audio::snd_add_exploder_alias( 915, "exp_metalstorm_explode" );
}

turn_on_bullet_snapshot()
{
    while(1)
    {
        level waittill( "turn_on_bullet_snapshot" );
        snd_set_snapshot( "spl_karma_slow_bullet" );
        wait(0.1);
    }
}
turn_off_bullet_snapshot()
{
    while(1)
    {
        level waittill( "turn_off_bullet_snapshot" );
        snd_set_snapshot( "default" );
        wait(0.1);
    }
}

wait_for_flag_set_lull()
{
		while(1)
	{
		level waittill ("lull");
				level notify ("client_lull_vox_on");
	}
}

wait_for_flag_set_action()
{
		while(1)
	{
		level waittill ("ccs");
		level notify ("client_action_vox_on");
	}
}

/*
//function for faking elevator "reveal" occlusion in construction area
play_occluded_construction()
{
	level waittill ("occlude_on");
	aud_occ = getent("room_occlude", "targetname");
	aud_occ playloopsound("amb_construction_occlude", 1);
	level waittill ("occlude_off");
	aud_occ stoploopsound (1);
	wait 3;
	aud_occ delete();
}
*/
ospree_ambient_room()
{
	level waittill ( "ospree_rm");
	activateAmbientPackage(0, "ospree", 0 );
	activateAmbientRoom(0, "ospree", 0 );
	
}

reset_room()
{
	level waittill ( "verb_reset");
	wait (9);
	activateAmbientPackage(0, "karma_entrance_roof", 0 );
	activateAmbientRoom( 0, "karma_entrance_roof", 0 );		
}
snd_start_autofx_audio()
{
	snd_play_auto_fx ( "fx_pipe_steam_md", "amb_steam_md", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_pipe_steam_xsm", "amb_steam_xsm", 0, 0, 0, false );
}

checkin_sounds()
{
	//This is the ambient sound of the scanner
	playloopat ("amb_scanner_int", (4560, -9446, 1004));
}

levelFadeOut()
{
	level waittill( "sndFadeOut" );
	wait(1);
	snd_set_snapshot( "cmn_fade_out" );
}
solarMusicDuck()
{
	while(1)
	{
		level waittill( "sndDuckSolar" );
		snd_set_snapshot( "spl_karma_1_solarmus_duck" );
		level waittill( "sndDuckSolarOff" );
		snd_set_snapshot( "default" );
	}
}