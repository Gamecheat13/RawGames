//
// file: blackout_amb.csc
// description: clientside ambient script for blackout: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;

main()
{
	declareAmbientRoom( "blackout_outdoor" );
	setAmbientRoomTone ("blackout_outdoor","blk_calm_wind_2d", .2, .5);
	setAmbientRoomReverb ("blackout_outdoor","black_outdoor", 1, 1);
	setAmbientRoomContext( "blackout_outdoor", "ringoff_plr", "outdoor" );
	setAmbientRoomContext( "blackout_outdoor", "grass", "no_grass" );
	declareAmbientPackage( "blackout_outdoor" );
	
	declareAmbientRoom("intro_room_sml" );
	setAmbientRoomReverb( "intro_room_sml", "black_introom", 1, 1 );
	setAmbientRoomContext( "intro_room_sml", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "intro_room_sml", "grass", "no_grass" );
	
	declareAmbientRoom("intro_hallway_sml" );
	setAmbientRoomReverb( "intro_hallway_sml", "black_inthall", 1, 1 );
	setAmbientRoomContext( "intro_hallway_sml", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "intro_hallway_sml", "grass", "no_grass" );
	
	declareAmbientRoom("intro_hallway_rooms_sml" );
	setAmbientRoomReverb( "intro_hallway_rooms_sml", "black_inthall", 1, 1 );
	setAmbientRoomContext( "intro_hallway_rooms_sml", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "intro_hallway_rooms_sml", "grass", "no_grass" );
	
	
	//new room new stairs that lead outside
	declareAmbientRoom("intro_pre_stair_room" );
	setAmbientRoomReverb( "intro_pre_stair_room", "black_inthall", 1, 1 );
	setAmbientRoomContext( "intro_pre_stair_room", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "intro_pre_stair_room", "grass", "no_grass" );

	declareAmbientRoom("hallway_stair_room" );
	setAmbientRoomReverb( "hallway_stair_room", "black_stairs", 1, 1 );
	setAmbientRoomContext( "hallway_stair_room", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "hallway_stair_room", "grass", "no_grass" );
		
	declareAmbientRoom("hallway_outside" );
	setAmbientRoomReverb( "hallway_outside", "black_open_hall", 1, 1 );
	setAmbientRoomTone ("blackout_outdoor","blk_calm_wind_2d", .2, .5);
	setAmbientRoomContext( "hallway_outside", "ringoff_plr", "outdoor" );	
	setAmbientRoomContext( "hallway_outside", "grass", "no_grass" );
		
	declareAmbientRoom("hallway_outside_rooms" );
	setAmbientRoomReverb( "hallway_outside_rooms", "black_open_smallroom", 1, 1 );
	setAmbientRoomContext( "hallway_outside_rooms", "ringoff_plr", "outdoor" );
	setAmbientRoomContext( "hallway_outside_rooms", "grass", "no_grass" );

	declareAmbientRoom("bridge_rooms_sml" );
	setAmbientRoomReverb( "bridge_rooms_sml", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "bridge_rooms_sml", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "bridge_rooms_sml", "grass", "no_grass" );

	declareAmbientRoom("main_bridge_room" );
	setAmbientRoomReverb( "main_bridge_room", "black_bridge_room", 1, 1 );
	setAmbientRoomContext( "main_bridge_room", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "main_bridge_room", "grass", "no_grass" );
	
	//new room off of the main bridge room
	declareAmbientRoom("main_bridge_map_room" );
	setAmbientRoomReverb( "main_bridge_map_room", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "main_bridge_map_room", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "main_bridge_map_room", "grass", "no_grass" );
	
	declareAmbientRoom("main_bridge_room_front" );
	setAmbientRoomReverb( "main_bridge_room_front", "black_bridge_room", 1, 1 );
	setAmbientRoomContext( "main_bridge_room_front", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "main_bridge_room_front", "grass", "no_grass" );

	declareAmbientRoom("below_bridge_room" );
	setAmbientRoomReverb( "below_bridge_room", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "below_bridge_room", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "below_bridge_room", "grass", "no_grass" );
	
	//new room below the bridge
	declareAmbientRoom("below_pipe_room" );
	setAmbientRoomReverb( "below_pipe_room", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "below_pipe_room", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "below_pipe_room", "grass", "no_grass" );
	
	//new room leading to the office area
	declareAmbientRoom("below_pipe_room_stairs" );
	setAmbientRoomReverb( "below_pipe_room_stairs", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "below_pipe_room_stairs", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "below_pipe_room_stairs", "grass", "no_grass" );
	
	//new room below the pipe room leading to the 
	declareAmbientRoom("below_bridge_office_rooms" );
	setAmbientRoomReverb( "below_bridge_office_rooms", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "below_bridge_office_rooms", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "below_bridge_office_rooms", "grass", "no_grass" );
	
	//new room hallways next to the offices leading to the security room
	declareAmbientRoom("below_bridge_hallway" );
	setAmbientRoomReverb( "below_bridge_hallway", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "below_bridge_hallway", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "below_bridge_hallway", "grass", "no_grass" );
	
	declareAmbientRoom("pre_security_stairs" );
	setAmbientRoomReverb( "pre_security_stairs", "black_smallroom", 1, 1 );
	setAmbientRoomContext( "pre_security_stairs", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "pre_security_stairs", "grass", "no_grass" );

	declareAmbientRoom("security_rooms_sml" );
	setAmbientRoomReverb( "security_rooms_sml", "black_sec_room", 1, 1 );
	setAmbientRoomContext( "security_rooms_sml", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "security_rooms_sml", "grass", "no_grass" );
	
	//new room in engine room bottom floor lots of metal and pipes
	declareAmbientRoom("engine_room_hallway_below" );
	setAmbientRoomReverb( "engine_room_hallway_below", "black_sec_room", 1, 1 );
	setAmbientRoomContext( "engine_room_hallway_below", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "engine_room_hallway_below", "grass", "no_grass" );
	
	//new room in engine room top floor
	declareAmbientRoom("engine_room_hallway_below" );
	setAmbientRoomReverb( "engine_room_hallway_below", "black_sec_room", 1, 1 );
	setAmbientRoomContext( "engine_room_hallway_below", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "engine_room_hallway_below", "grass", "no_grass" );

	declareAmbientRoom("engine_room_main" );
	setAmbientRoomReverb( "engine_room_main", "black_med_sec_room", 1, 1 );
	setAmbientRoomContext( "engine_room_main", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "engine_room_main", "grass", "no_grass" );
	
	//new room stairs that lead to the vent room
	declareAmbientRoom("small_stairs" );
	setAmbientRoomReverb( "small_stairs", "black_med_sec_room", 1, 1 );
	setAmbientRoomContext( "small_stairs", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "small_stairs", "grass", "no_grass" );
	
	//new room room before going into the vent
	declareAmbientRoom("pre_vent_room" );
	setAmbientRoomReverb( "pre_vent_room", "black_med_sec_room", 1, 1 );
	setAmbientRoomContext( "pre_vent_room", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "pre_vent_room", "grass", "no_grass" );

	declareAmbientRoom("air_vent" );
	setAmbientRoomReverb( "air_vent", "black_vent", 1, 1 );
	setAmbientRoomContext( "air_vent", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "air_vent", "grass", "no_grass" );
	
	declareAmbientRoom("server_room" );
	setAmbientRoomReverb( "server_room", "black_server_room", 1, 1 );
	setAmbientRoomContext( "server_room", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "server_room", "grass", "no_grass" );
	
	//new room when menendez looks at the camera
	declareAmbientRoom("menendez_cctv_room" );
	setAmbientRoomReverb( "menendez_cctv_room", "black_server_room", 1, 1 );
	setAmbientRoomContext( "menendez_cctv_room", "ringoff_plr", "indoor" );	
	setAmbientRoomContext( "menendez_cctv_room", "grass", "no_grass" );
	
	declareAmbientRoom("hanger_control_room" );
	setAmbientRoomReverb( "hanger_control_room", "black_hang_ctl", 1, 1 );
	setAmbientRoomContext( "hanger_control_room", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "hanger_control_room", "grass", "no_grass" );
	
	declareAmbientRoom("hanger_control_room_stairs" );
	setAmbientRoomReverb( "hanger_control_room_stairs", "black_hang_ctl", 1, 1 );
	setAmbientRoomContext( "hanger_control_room_stairs", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "hanger_control_room_stairs", "grass", "no_grass" );
	
	declareAmbientRoom("hanger_room" );
	setAmbientRoomReverb( "hanger_room", "black_hang_lg", 1, 1 );
	setAmbientRoomContext( "hanger_room", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "hanger_room", "grass", "no_grass" );
	
	
	declareAmbientRoom("medium_room" );
	setAmbientRoomReverb( "medium_room", "black_med_sec_room", 1, 1 );
	setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "medium_room", "grass", "no_grass" );
	
	declareAmbientRoom("gas_mask" );
	setAmbientRoomtone ("gas_mask", "evt_gasmask_loop", 3, 3);
	setAmbientRoomReverb( "gas_mask", "black_gasmask", 1, 1 );
	setAmbientRoomContext( "gas_mask", "grass", "in_grass" );//the gas mask context was taken out
	setAmbientRoomSnapshot( "gas_mask", "spl_blackout_gas_mask" );

	declareAmbientRoom( "f35_int" );
 	setAmbientRoomTone( "f35_int", "" );
 	setAmbientRoomReverb ("f35_int","black_cockpit", 1, 1);
 	setAmbientRoomSnapshot ("f35_int", "veh_f35_int_blackout");
 	setAmbientRoomContext( "f35_int", "f35", "interior" );	
 	setAmbientRoomContext( "f35_int", "grass", "no_grass" );
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "blackout_outdoor", 0 );
	activateAmbientRoom( 0, "blackout_outdoor", 0 );	
	
	
	//************************************************************************************************
	//                                      MUSIC STATES
	//***********************************************************************************************
	
	declaremusicState ("BLACKOUT_MENENDEZ_WALK");
		musicAliasloop ("mus_menendez_walk", 0, 2);
		
	declaremusicState ("BLACKOUT_MENENDEZ_OVER");
		musicAliasloop ("null", 0, 0);
		

	thread snd_start_autofx_audio();
	thread snd_commotion_start();
	thread walla_vignettes();
	thread random_alarms();
	thread activate_f35_room();
	thread computer_loops();
	thread nuke_loop();
	thread sound_fade_snapshot();
	thread sound_fade_out_snapshot();
	thread menendez_mask_on();
	thread interrogation_LightFlicker();
	thread play_ceiling_water_splash();
}
walla_vignettes()
{
	level waittill( "argument_done" );
	
	location = [];
	location[0] = (613, 1200, 356);
	location[1] = (309, 1420, 500);
	location[2] = (192, 449, -208);
	location[3] = (498, 258, 323);
	location[4] = (628, 703, 355);
	location[5] = (101, 899, 334);
	
	location = array_randomize( location );
	
	location[6] = (2343, 915, -250);
	location[7] = (1936, 879, -277);
	
	aliases = [];
	aliases[0] = spawnstruct();
	aliases[0].alias = "amb_walla_fighting_0";
	aliases[1] = spawnstruct();
	aliases[1].alias = "amb_walla_fighting_0";
	aliases[2] = spawnstruct();
	aliases[2].alias = "amb_walla_fighting_0";
	aliases[3] = spawnstruct();
	aliases[3].alias = "amb_walla_fighting_1";
	aliases[4] = spawnstruct();
	aliases[4].alias = "amb_walla_fighting_1";
	aliases[5] = spawnstruct();
	aliases[5].alias = "amb_walla_stuck";
	aliases[6] = spawnstruct();
	aliases[6].alias = "amb_walla_execution";
	aliases[7] = spawnstruct();
	aliases[7].alias = "amb_walla_fighting_1_quiet";
	
	for( i=0;i<aliases.size;i++ )
	{
		aliases[i].location = location[i];
		
		if( i == 6 )
			level thread play_walla_vignettes( aliases[i], true );
		else
			level thread play_walla_vignettes( aliases[i], undefined );
	}
}
play_walla_vignettes( struct, oneshot)
{
	if( isdefined( oneshot ) )
	{
		player = getlocalplayers()[0];
		while( distance( player.origin, struct.location ) > 200 )
		{
			wait(.5);
		}
		playsound( 0, struct.alias, struct.location );
		return;
	}
	
	playloopat( struct.alias, struct.location );
}
random_alarms()
{
	level waittill( "argument_done" );
	
	location = [];
	location[0] = (320, 254, 371);
	location[1] = (323, 993, 370);
	location[2] = (663, 1569, 400);
	location[3] = (426, 1207, 545);
	location[4] = (454, 1059, 551);
	location[5] = (349, 7, 556);
	location[6] = (362, -551, 384);
	location[7] = (697, 135, 387);
	location[8] = (467, 1189, 224);
	location[8] = (447, 1022, 103);
	location[9] = (624, 511, -30);
	location[10] = (401, 820, -176);
	location[11] = (507, 1549, -189);
	location[12] = (1564, 1749, -300);
	location[13] = (1551, 2459, -312);
	
	for(i=0;i<location.size;i++)
	{
		playloopat( "amb_alarm_looper", location[i] );
	}
}
snd_start_autofx_audio()
{
	wait(1);
	snd_play_auto_fx ( "fx_com_pipe_steam", "amb_steam_pipe", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_com_pipe_fire", "amb_pipe_fire", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_com_water_drips", "amb_water_drips", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_com_water_leak", "amb_water_splash_md_metal", 10, 0, 0, true );

	
	

}

interrogation_LightFlicker()
{
	light = (430, -163, 135);
	power = (311, -132, 133);
	
	light_ent = spawn( 0, light, "script_origin" );
	power_ent = spawn( 0, power, "script_origin" );
	
	level thread play_generator( power_ent );
	level thread play_flicker( light_ent );
	level thread play_off( light_ent, power_ent );
}
play_flicker( light, power )
{
	level endon( "INT_out" );
	
	light_id = light playloopsound( "amb_interrogation_light", 2 );
	
	setSoundVolume( light_id, .8 );	
	setsoundpitch( light_id, 1 );
	
	while(1)
	{
		level waittill( "INT_flick" );
		make_flicker_change( light_id, 1, 1.1, .9, .5 );
		make_flicker_change( light_id, .4, .8, .9, .2 );
		make_flicker_change( light_id, .8, 1, .05, 2 );
	}
}
play_off( light, power )
{
	level waittill( "INT_out" );
	
	playsound( 0, "amb_interrogation_power_down", power.origin );

	light delete();
	power delete();
}
make_flicker_change( id, volume, pitch, rate, waittime )
{
	setsoundvolumerate( id, rate );
	setsoundpitchrate( id, rate );
	setsoundvolume( id, volume );
	setsoundpitch( id, pitch );
	wait(waittime);
}
play_generator( ent )
{
	level endon( "INT_out" );
	
	ent_id = ent playloopsound( "amb_interrogation_power", 2 );
	setSoundVolume( ent_id, 1 );	
	setsoundpitch( ent_id, 1 );
	
	while(1)
	{
		level waittill( "INT_flick" );
		playsound( 0, "amb_interrogation_power_down", ent.origin );
		setsoundvolumerate( ent_id, .2 );
		setsoundpitchrate( ent_id, .2 );
		setsoundvolume( ent_id, 0 );
		setsoundpitch( ent_id, .5 );
		wait(2.5);
		playsound( 0, "amb_interrogation_power_up", ent.origin );
		setsoundvolumerate( ent_id, .8 );
		setsoundpitchrate( ent_id, .8 );
		setsoundvolume( ent_id, 1 );
		setsoundpitch( ent_id, 1 );
	}
}
play_ceiling_water_splash()
{
	level waittill ("cpb");	
	playloopat ("amb_water_splash_md_metal", (766, 1438, 356));
	playloopat ("amb_water_splash_md_metal", (761, 1353, 356));
}
snd_commotion_start()
{
	level waittill ("snd_commotion");
	sound_ent_commotion = spawn( 0, (317, 318, 344), "script_origin" );
	sound_ent_commotion PlayLoopSound ("amb_commotion_chat", .1);
	
	
	level waittill ( "snd_argument" );
	wait (41);
	sound_ent_commotion stoploopsound (8);
	playsound (0, "amb_commotion_argument", sound_ent_commotion.origin);
	             
	level waittill ("argument_done");
	sound_ent_commotion PlayLoopSound ("amb_ship_alarm", .1);
	
}

activate_f35_room()
{
    waitforclient(0); 
	level waittill( "start_f35_snap" );
	//IPrintLnBold("like donkey kong");
	deactivateAmbientRoom( 0, "gas_mask", 80 );
    activateAmbientRoom( 0, "f35_int", 90 );
    thread deactivate_f35_room();
}
deactivate_f35_room()
{
	level waittill( "stop_f35_snap" );
	//IPrintLnBold("off client");
	//wait 3;
    deactivateAmbientRoom( 0, "f35_int", 90 );
    //setsoundcontext( "f35", "default" );
}
nuke_loop()
{
	playloopat ("amb_nuke_hum", (1312, 2136, -343));
}

computer_loops()
{

	//*********INTERRO SCREENS
	//first_one - SHOULD BE SCRIPTED - IT TURNS OFF
	//soundloopemitter ("amb_comp_screen", (94, 102, 312));
	//cctv_room_w_static?
	playloopat ("amb_comp_screen", (2496, 1418, -265));
	//mainframe_room
	playloopat ("amb_comp_screen", (2016, 206, -254));

	//********RADARS
	//room1
	playloopat ("amb_radar_screen", (183, 1536, 305));
	playloopat ("amb_radar_screen", (326, 1537, 304));
	//first_big_room
	playloopat ("amb_radar_screen", (507, 75, 481));
	playloopat ("amb_radar_screen", (242, 75, 481));
	//bridge
	playloopat ("amb_radar_screen", (495, -597, 481));
	playloopat ("amb_radar_screen", (432, -595, 481));
	playloopat ("amb_radar_screen", (368, -594, 480));
	playloopat ("amb_radar_screen", (303, -597, 481));
	playloopat ("amb_radar_screen", (239, -599, 482));
	playloopat ("amb_radar_screen", (174, -597, 483));
	playloopat ("amb_radar_screen", (54, -587, 481));
	//under_bridge
	playloopat ("amb_radar_screen", (708, -582, 336));
	playloopat ("amb_radar_screen", (367, -594, 334));
	playloopat ("amb_radar_screen", (173, -597, 337));
	//small_room
	playloopat ("amb_radar_screen", (340, 1051, -230));
	//long_row_b4_security_room
	playloopat ("amb_radar_screen", (340, 1372, -358));
	playloopat ("amb_radar_screen", (434, 1370, -360));
	//security_room
	playloopat ("amb_radar_screen", (575, 2047, -361));
	//post_security_room
	playloopat ("amb_radar_screen", (1618, 2006, -369));
	playloopat ("amb_radar_screen", (1774, 2071, -368));
	playloopat ("amb_radar_screen", (1932, 1801, -368));
	playloopat ("amb_radar_screen", (1942, 2136, -368));
	playloopat ("amb_radar_screen", (1810, 2455, -367));
	playloopat ("amb_radar_screen", (1649, 2226, -370));
	//cctv_room
	playloopat ("amb_radar_screen", (2147, 1429, -263));
	playloopat ("amb_radar_screen", (2313, 1429, -264));
	playloopat ("amb_radar_screen", (2509, 1319, -265));
	//mainframe_room - custom aliases to always call the same loops
	playloopat ("amb_radar_screen_mf1", (2558, 272, -264));
	playloopat ("amb_radar_screen_mf2", (2558, 240, -265));
	//post_mainframe
	playloopat ("amb_radar_screen", (2612, -332, -263));
	playloopat ("amb_radar_screen", (2290, -521, -367));
	playloopat ("amb_radar_screen", (2696, -518, -365));
	playloopat ("amb_radar_screen", (2658, -785, -365));
	playloopat ("amb_radar_screen", (2467, -782, -368));
	
	//*************SWITCH_BANKS
	//room1
	playloopat ("amb_switch_bank", (347, 1498, 304));
	playloopat ("amb_switch_bank", (256, 1553, 306));
	playloopat ("amb_switch_bank", (166, 1499, 306));
	//first_big_room
	playloopat ("amb_switch_bank", (225, 34, 482));
	playloopat ("amb_switch_bank", (296, 91, 479));
	playloopat ("amb_switch_bank", (455, 91, 479));
	playloopat ("amb_switch_bank", (524, 22, 478));
	//bridge
	playloopat ("amb_switch_bank", (38, -545, 481));
	playloopat ("amb_switch_bank", (94, -600, 483));
	playloopat ("amb_switch_bank", (143, -598, 484));
	playloopat ("amb_switch_bank", (207, -600, 483));
	playloopat ("amb_switch_bank", (271, -599, 480));
	playloopat ("amb_switch_bank", (334, -598, 481));
	playloopat ("amb_switch_bank", (398, -596, 482));
	playloopat ("amb_switch_bank", (462, -599, 482));
	//under_bridge
	playloopat ("amb_switch_bank", (105, -601, 334));
	playloopat ("amb_switch_bank", (333, -597, 336));
	playloopat ("amb_switch_bank", (725, -543, 336));
	//small_room
	playloopat ("amb_switch_bank", (285, 1053, -229));
	playloopat ("amb_switch_bank", (480, 1054, -234));
	//long_row_b4_security_room
	playloopat ("amb_switch_bank", (627, 1374, -359));
	playloopat ("amb_switch_bank", (298, 1376, -359));
	//security_room
	playloopat ("amb_switch_bank", (623, 2034, -365));
	//post_security_room
	playloopat ("amb_switch_bank", (1891, 178,2 -369));
	playloopat ("amb_switch_bank", (1943, 2103, -369));
	playloopat ("amb_switch_bank", (1892, 2454, -370));
	playloopat ("amb_switch_bank", (1774, 2105, -368));
	//cctv_room
	playloopat ("amb_switch_bank", (2246, 1428, -261));
	playloopat ("amb_switch_bank", (2459, 1432, -261));
	playloopat ("amb_switch_bank", (2509, 1367, -264));
	//mainframe_room - off by design
	//soundloopemitter ("amb_switch_bank", (2556, 221, -263));
	//soundloopemitter ("amb_switch_bank", (2555, 292, -262));
	//post_mainframe
	playloopat ("amb_switch_bank", (2583, -336, -264));
	playloopat ("amb_switch_bank", (2228, -505, -362));
	playloopat ("amb_switch_bank", (2422, -791, -368));
	
	//**************BIG_COMPUTER
	//security_room
	playloopat ("amb_big_comp", (607, 2162, -351));
	playloopat ("amb_big_comp", (726, 2294, -359));
	//post_security_room
	playloopat ("amb_big_comp", (726, 2294, -359));
	//post_mainframe
	playloopat ("amb_big_comp", (2010, -655, -362));
	
	//*************CHUNKY_SERVER_HUM
	//cctv_room
	playloopat ("amb_server_hum_cctv_room", (2231, 1273, -223));
	//mainframe_room
	playloopat ("amb_server_hum", (2503, 433, -295));
	playloopat ("amb_server_hum", (2488, 78, -292));
	playloopat ("amb_server_hum", (2297, 437, -293));
	playloopat ("amb_server_hum", (2321, 88, -286));
	
	//**************WALL MAPS/DISPLAYS
	//bigroom & adjacent
	playloopat ("amb_wall_display", (27, 225, 538));
	playloopat ("amb_wall_display", (48, 616, 529));
	playloopat ("amb_wall_display", (626, 136, 512));
	//text_display
	playloopat ("amb_wall_display", (621, 537, 515));
	//post_mainframe - small
	playloopat ("amb_wall_display", (2002, -547, -356));
	
	//**************3D TOPDOWN MAPS
	//bigroom & adjacent
	playloopat ("amb_3d_maps", (24, 516, 485));
	playloopat ("amb_3d_maps", (363, -130, 495));
	playloopat ("amb_3d_maps", (62, 151, 482));

}

sound_fade_snapshot()
{
	level waittill ("fade");
	snd_set_snapshot ( "cmn_fade_in" );	
	wait (2);
	snd_set_snapshot ( "default" );
}

sound_fade_out_snapshot()
{
	level waittill ("fade_out");
	snd_set_snapshot ( "cmn_fade_out" );	
}

menendez_mask_on()
{
	level waittill( "audio_mask" );
	waitforclient(0); 
	activateAmbientRoom( 0, "gas_mask", 80 );
	
}
