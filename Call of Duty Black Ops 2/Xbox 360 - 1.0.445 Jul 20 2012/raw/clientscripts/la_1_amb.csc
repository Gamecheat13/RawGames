//
// file: la_1_amb.csc
// description: clientside ambient script for la_1: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;

main()
{
	
	
	declareAmbientRoom( "outdoor" );
		setAmbientRoomTone ("outdoor","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("outdoor","la_1_low_road", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "outdoor" );
	
	declareAmbientRoom( "indoor" );
		setAmbientRoomTone ("indoor","blk_la_indoor_bg", .5, .5);
		setAmbientRoomReverb ("indoor","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "indoor", "ringoff_plr", "indoor" );
		declareAmbientPackage( "indoor" );
	
	declareAmbientRoom( "battle" );
		setAmbientRoomTone ("battle","blk_la_battle_bg", .5, .5);
		setAmbientRoomReverb ("battle","gen_city", 1, 1);
		setAmbientRoomContext( "battle", "ringoff_plr", "battle" );
		declareAmbientPackage( "battle" );
	
	declareAmbientRoom( "staples_center" );
		setAmbientRoomTone ("staples_center","blk_la_indoor_bg", .5, .5);
		setAmbientRoomReverb ("staples_center","gen_mediumroom", 1, 1);
		setAmbientRoomContext( "staples_center", "ringoff_plr", "indoor" );
		declareAmbientPackage( "staples_center" );
	
//******************************************NEW rooms********************************************

	declareAmbientRoom( "lobby" );
		//setAmbientRoomTone ("la_1_lobby","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("lobby","la_1_lobby", 1, 1);
		setAmbientRoomContext( "lobby", "ringoff_plr", "indoor" );
		declareAmbientPackage( "lobby" );
	
	declareAmbientRoom( "plaza_side_room" );
		//setAmbientRoomTone ("la_1_lobby","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("plaza_side_room","la_1_side_room", 1, 1);
		setAmbientRoomContext( "plaza_side_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "plaza_side_room" );
		
	declareAmbientRoom( "mall_room" );
		//setAmbientRoomTone ("mall_room","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("mall_room","la_1_mallroom", 1, 1);
		setAmbientRoomContext( "mall_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "mall_room" );
		
	declareAmbientRoom( "la_small_room" );
		//setAmbientRoomTone ("la_small_room","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("la_small_room","la_1_smallroom", 1, 1);
		setAmbientRoomContext( "la_small_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "la_small_room" );


	declareAmbientRoom( "la_1_intro_cougar" );
		setAmbientRoomReverb ("la_1_intro_cougar","la_1_intro_cougar", 1, 1);
		setAmbientRoomContext( "la_1_intro_cougar", "ringoff_plr", "indoor" );
		declareAmbientPackage( "la_1_intro_cougar" );

		
	declareAmbientRoom( "la_1_drivable_cougar" );
		setAmbientRoomReverb ("la_1_drivable_cougar","la_1_intro_cougar", 1, 1);
		setAmbientRoomContext( "la_1_drivable_cougar", "ringoff_plr", "indoor" );
		declareAmbientPackage( "la_1_drivable_cougar" );	

//NEED NEW VERB HERE
	declareAmbientRoom( "la_1_post_intro" );
		//setAmbientRoomTone ("la_1_lobby","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("la_1_post_intro","la_1_low_road", 1, 1);
		setAmbientRoomContext( "la_1_post_intro", "ringoff_plr", "indoor" );
		declareAmbientPackage( "la_1_post_intro" );
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );	
	
	
	declaremusicState ("LA_1_INTRO");
		musicAlias ("mus_la1_intro", 0);		
		
	declaremusicState("LA_1_CRAWL");
		musicAliasloop ("mus_crawl_pad_loop", 0, 0);
	
	declareMusicState ("LA_POST_CRASH");
		musicAliasloop ("mus_post_crash_loop", 0, 3.5);
		musicStinger ("mus_turret_jump", 12.4, true);
		
//	declaremusicState ("LA_1_TURRET_JUMP");			
//		musicAliasloop ("NULL", 0, 0);
	
	declaremusicState ("LA_1_TURRET");
		musicAliasloop ("mus_la1_turret", 0, 0);
	
	declaremusicState ("LA_1_OFF_TURRET");
		musicAlias ("mus_anderson_reveal");
		musicAliasloop ("null", 0, 0);
	
	declareMusicState ("LA_1_SNIPER_RAPEL");
		musicAliasloop ("mus_sniper_event_music", 0, 8);
		//musicStinger ("");
		
	declareMusicState ("LA_1_BRIDGE_SCENE");
		musicAliasloop ("mus_predrive_pad_loop", 1, 2);	
		musicStinger ("mus_sniper_event_stg", 44, true);
	
	declaremusicState ("LA_1_PRE_DRIVE");
		musicAliasloop ("mus_predrive_pad_loop", 0, 2);	
			
	declaremusicState ("LA_1_DRIVE");
		musicAliasloop ("mus_drive_loop", 1, 4);
		musicStinger ("mus_drive_stg", 0);
		
	declaremusicState ("LA_1_HOPELESS");
		musicAliasloop ("null", 0, 0);
		musicStinger ("mus_drive_cresendo", 0, true);

	declareMusicState ("LA_1_SEMI");
		musicAliasloop ("null", 0, 0);
			
			
	thread tv_sounds();
	thread snd_fx_create();
	level thread cougar_radio_chatter();
	level thread sam_turret_snapshot_and_verb_on();
    level thread sam_turret_snapshot_and_verb_off();
    level thread sonar_vision();       
    level thread set_intro_snapshot();
    level thread setup_ambient_fx_sounds();
   	level thread play_siren_on_cop_car();
   	level thread play_siren_on_cop_car_2();
    level thread f35_context();
    level thread cougar_crash_snapshot();
    level thread big_battle_ambience();
    level thread play_siren2_after_freeway();
    level thread play_distant_battle_bg_until_jump();
    level thread freeway_barrier_suspension_audio();
    level thread cougar_jump_duck();
    level thread battle_sam_context();
	level thread sndActivateDriveSnapshot();
	level thread drone_listener();
	level thread sound_fade_out_snapshot();
	level thread cougar_rattle_scaling();
	level thread post_anderson_reveal_fires();
    level thread turn_down_cougar();
    level thread snapshot_check();
    level thread play_cougar_heartbeat();
}

//Sj - fix for snapshot in skipto issue
snapshot_check()
{
	level endon ("intr_on");
	wait (2);
	//iprintlnbold ("snp_default");
	snd_set_snapshot("default");	
}

sndActivateDriveSnapshot()
{
	level waittill ("snd_ADS");
	snd_set_snapshot("spl_la_1_drive");
	activateambientroom( 0, "la_1_drivable_cougar", 80 );
	activateambientpackage( 0, "la_1_drivable_cougar", 80 );
}
drone_listener()
{
	//set drone snapshot
	level waittill("sds1");
	snd_set_snapshot("spl_la_1_drone");
	level thread play_heartbeat_drone();

	//set default snapshot
	level waittill("sdfs1");	
	//snapshot for anderson reveal
	snd_set_snapshot("spl_la_1_drone_incoming");
	
	wait (12);
	
	snd_set_snapshot("cmn_low_vehicles_and_ambience");
	
	
	
//	activateAmbientPackage( 0, "outdoor", 0 );
//	activateAmbientRoom( 0, "outdoor", 0 );	
}
play_heartbeat_drone()
{
	wait(1.5);
	playsound (0, "evt_drone_heartbeat", (0,0,0));
	
}
tv_sounds()
{
	//small
	//soundloopemitter ("blk_vox_emg_broadcast", (12384, -2987, 308));
	//soundloopemitter ("blk_vox_emg_broadcast", (12499, -2124, 325));
	//soundloopemitter ("blk_vox_emg_broadcast", (12432, -1187, 313));
	
	//big
	playloopat ("blk_vox_emg_broadcast_big", (9099, -606, 413));
	playloopat ("blk_vox_emg_broadcast_big", (10396, 874, 591));
	playloopat ("blk_vox_emg_broadcast_big", (13964, -4424, 311));

	
	//small f35
	playloopat ("blk_vox_emg_broadcast", (1625, 8261, 399));
	playloopat ("blk_vox_emg_broadcast", (3312, 8935, 356));
		
}


sam_turret_snapshot_and_verb_on()
{
	setsoundcontext( "f35", "exterior" );
	
	level waittill( "mTon" );
    
    //TODO: Replace with actual snapshot, change reverb to actual reverb
   // (handled in other script now) snd_set_snapshot("spl_la_1_sam");
    setAmbientRoomReverb ("outdoor","gen_smallroom", 1, 1);
    level.activeAmbientRoom = "";
    level notify( "updateActiveAmbientRoom" );
    setsoundcontext( "f35", "interior" );
}
set_intro_snapshot()
{
	//Eckert - Moved Fadein snap to main func
	level waittill("intr_on");
	snd_set_snapshot("spl_la_1_intro_vehicle");
//	level thread temp_remove_timer();
	
	activateambientroom(0, "la_1_intro_cougar", 50 );
	level waittill ("reset_snapshot");
	wait(5);
	snd_set_snapshot("spl_la_1_post_intro"); // turns on the timed snapshot
	deactivateambientroom(0, "la_1_intro_cougar", 50 );
	activateambientroom(0, "la_1_post_intro", 50 );
	level thread air_raid_sirens();
	level notify ("intro_done");
	level waittill( "snd_ECRWL" );
	snd_set_snapshot( "default" );	
	wait(1.7);
	deactivateambientroom(0, "la_1_post_intro", 50 );
	
 //   level.activeAmbientRoom = "";
 //   level notify( "updateActiveAmbientRoom" );
	
	
}
temp_remove_timer()
{
	wait(0.1);
	level notify ("over_black");
	
}
play_cougar_heartbeat()
{
	level waittill ("over_black");
	loop_ent_1 = spawn( 0, (0,0,0), "script_origin" );	
	loop_ent_1 playloopsound("evt_la_1_intro_crawl_heartbeat", 1);
	level waittill ("snd_ECRWL");
	loop_ent_1 stoploopsound();
	loop_ent_1 delete();
	
}
sam_turret_snapshot_and_verb_off()
{
    level waittill( "mToff" );
    
    snd_set_snapshot("default");
    setAmbientRoomReverb ("outdoor","gen_city", 1, 1);
    
    activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );	
	
    
    level.activeAmbientRoom = "";
    level notify( "updateActiveAmbientRoom" );
    setsoundcontext( "f35", "exterior" );
}

snd_fx_create()
{

	wait (1);

	clientscripts\_audio::snd_add_exploder_alias( 210, "exp_mortar" );
	clientscripts\_audio::snd_add_exploder_alias( 211, "exp_mortar" );
	clientscripts\_audio::snd_add_exploder_alias( 212, "exp_mortar" );
	clientscripts\_audio::snd_add_exploder_alias( 405, "evt_freefall" );
	//clientscripts\_audio::snd_add_exploder_alias( 410, "blk_f35_crash_impact" );

}
sonar_vision()
{

	sonarEnt = spawn( 0, (0,0,0), "script_origin" );
	
	while (1)
	{
   		level waittill( "sonar_on" ); 
		playsound (0, "evt_sonar_engage", (0,0,0));
   		sonarEnt playloopsound ("evt_sonar_loop", 1);   		
   		level waittill( "sonar_off" );
   		sonarEnt stoploopsound ();
 		playsound (0, "evt_sonar_disengage", (0,0,0));  		
	}
	
}

setup_ambient_fx_sounds()
{		
	
	snd_play_auto_fx( "fx_fire_column_creep_xsm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_column_creep_sm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_wall_md", "amb_fire_medium", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_ceiling_md", "amb_fire_medium", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_line_xsm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_fuel_sm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_line_sm", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_fuel_sm_line", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_fuel_sm_ground", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	snd_play_auto_fx( "fx_fire_line_md", "amb_fire_medium", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	//snd_play_auto_fx( "fx_fire_sm_smolder", "amb_fire_small", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
	//snd_play_auto_fx( "fx_fire_md_smolder", "amb_fire_medium", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_window_lg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_window_xlg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_lg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_line_xlg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	//snd_play_auto_fx( "fx_debris_papers_fall_burning_xlg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
}


play_siren_on_cop_car()
{
	copsiren1 = spawn(0, (8032, -46336, -48), "script_origin");
	copsiren1 PlayLoopSound("amb_police_siren_stationary");
}


play_siren_on_cop_car_2()
{
	copsiren2 = spawn (0, (8391, -39665, 372 ), "script_origin");
	copsiren2 PlayLoopSound ("amb_police_siren_stationary");
}

play_siren2_after_freeway()
{
	copsiren1 = spawn (0, (14388, -17338, 148 ), "script_origin");
	copsiren2 = spawn (0, (14971, -17016, 163 ), "script_origin");
	copsiren1 PlayLoopSound ("amb_police_siren_stationary_2");
	copsiren2 PlayLoopSound ("amb_police_siren_stationary_2");
}

air_raid_sirens()
{
	wait(8);
	playloopat ("amb_air_raid_siren_l", (5876, -55025, 823));
	playloopat ("amb_air_raid_siren_r", (10533, -55215, 801));
}

f35_context()
{
	 waitforclient(0);
	 setsoundcontext( "f35", "exterior" );
}

cougar_radio_chatter()
{
	level waittill( "cougar_chatter" );
	waitforclient(0);
	//IPrintLnBold( "cougar_chatter" );
	loop_ent_1 = spawn( 0, (0,0,0), "script_origin" );
    //player = GetLocalPlayers()[0];
	loop_ent_1 playloopsound( "amb_radio_chatter_cougar_loop" , 2 );
	loop_ent_1 thread cougar_radio_chatter_cleanup();
}
cougar_radio_chatter_cleanup()
{
	level waittill( "sccs" );
	self delete();
	//IPrintLnBold( "cougar_chatter_delete" );
}

cougar_crash_snapshot()
{
	level waittill( "sccs" );
	wait(1);
	snd_set_snapshot( "spl_la_1_cougar_crash" );
}

big_battle_ambience()
{
	level waittill( "bbvi0" );
	
	snd_play_auto_fx( "fx_la_overpass_debris_area_md", "evt_freeway_debris_drivethru", 0, 0, -300, true, 100, 2, "evt_freeway_debris_drivethru" );
	snd_play_auto_fx( "fx_la_overpass_debris_area_lg", "evt_freeway_debris_drivethru", 0, 0, -300, true, 100, 2, "evt_freeway_debris_drivethru" );
	snd_play_auto_fx( "fx_la_overpass_debris_area_md_line", "evt_freeway_debris_drivethru", 0, 0, -300, true, 100, 2, "evt_freeway_debris_drivethru" );
	snd_play_auto_fx( "fx_la_overpass_debris_area_md_line_wide", "evt_freeway_debris_drivethru", 0, 0, -300, true, 100, 2, "evt_freeway_debris_drivethru" );
	snd_play_auto_fx( "fx_la_overpass_debris_area_xlg", "evt_freeway_debris_drivethru", 0, 0, -300, true, 100, 2, "evt_freeway_debris_drivethru" );
	snd_play_auto_fx( "fx_la_overpass_debris_area_lg_os", "evt_freeway_debris_drivethru", 0, 0, -300, true, 100, 2, "evt_freeway_debris_drivethru" );
	
	origin = spawn( 0, (14993, -8519, 503), "script_origin" );
	
	level.big_battle_loop_id = origin playloopsound( "amb_big_battle_loop", 1 );
	setsoundvolume( level.big_battle_loop_id, .5 );
	
	level thread waitfor_volume_increase( "bbvi1", .5, 1, 2 );
	//level thread waitfor_volume_increase( "bbvi2", .8, 1, 2 );
}

waitfor_volume_increase( time_notify, old_volume, new_volume, time )
{
	level waittill( time_notify );
	
	num = time/.1;
	diff = new_volume - old_volume;
	rate = diff/num;
	
	for(i=0;i<num;i++)
	{
		old_volume += rate;
		setsoundvolume( level.big_battle_loop_id, old_volume );
		wait(.1);
	}
}

play_distant_battle_bg_until_jump()
{
	level waittill( "sdlbg" );
	origin = spawn( 0, (7833, -52918, 796 ), "script_origin" );
	origin playloopsound( "amb_la_big_battle_loop", 1 );
	level waittill( "scjs" );
	origin stoploopsound(2);
	wait(2);
	origin delete();
}

freeway_barrier_suspension_audio()
{
	wait(2);
	array_thread( getentarray( 0, "audio_freeway_barrier", "targetname"), ::play_suspension_audio );
}

play_suspension_audio()
{
	if( !isdefined( self ) )
		return;
	
	self waittill( "trigger" );
	
	playsound( 0, "evt_cougar_suspension_oneshot", (0,0,0) );
}

cougar_jump_duck()
{
	level waittill( "scjs" );
	snd_set_snapshot( "spl_la_1_cougar_mount" );
	wait(8);
	snd_set_snapshot( "spl_la_1_turret_event" );
}


battle_sam_context()
{
	level waittill( "set_sam_int_context" );
	 waitforclient(0);
	 setsoundcontext( "f35", "interior" );
	level waittill( "set_sam_ext_context" );
	 setsoundcontext( "f35", "exterior" );
	 
}
sound_fade_out_snapshot()
{
	level waittill ("fade_out");
	snd_set_snapshot ( "cmn_fade_out" );	
}


cougar_rattle_scaling()
{
	level waittill ("drive_time");
	volumerate = 2;
	//const MPH_TO_INCHES_PER_SEC = 17.6;
	player = getlocalplayers()[0];
	
	rattle_ent = Spawn( 0, player.origin, "script_origin" );
	rattle_ent linkto (player, "tag_origin");
	rattle_id = rattle_ent playloopsound ("veh_cougar_int_rattle");
	setSoundVolume( rattle_id, 0 );	
	
	
	while(1)
	{
		
		//player.cur_speed = player getspeed();/ MPH_TO_INCHES_PER_SEC;

		//                     min speed, max speed, min vol, max vol
		
		last_pos_x = player.origin[0];
		last_pos_y = player.origin[1];
		wait .1;
		new_pos_x = abs (last_pos_x - player.origin[0]);
		new_pos_y = abs (last_pos_y - player.origin[1]);
		pos_xy = new_pos_x + new_pos_y;
		//rattle_volume = scale_speed( 5, 30, 0, 1, player.cur_speed );
		
		rattle_volume = scale_speed( 10, 65, 0, 1, pos_xy );

		setSoundVolumeRate (rattle_id, volumerate);
		
		setSoundVolume( rattle_id, rattle_volume );

	}
}

post_anderson_reveal_fires()
{
	level waittill( "and_reveal" );
	snd_play_auto_fx( "fx_fire_fuel_sm_line", "amb_fire_medium", 0, 0, 0, false, 200, 2, "amb_fire_medium" );
}

turn_down_cougar()
{
	level waittill( "cougar_vol" );
	snd_set_snapshot("spl_la_1_cougar_vol");
}