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
	//Eckert - level fade in
	snd_set_snapshot("spl_la_1_cougar_exit_2");	

	
	
	declareAmbientRoom( "outdoor" );
		setAmbientRoomTone ("outdoor","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("outdoor","la_1_low_road", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "outdoor" );
	
	declareAmbientRoom( "indoor" );
		setAmbientRoomTone ("indoor","blk_la_indoor_bg", .5, .5);
		setAmbientRoomReverb ("indoor","la_1_side_room", 1, 1);
		setAmbientRoomContext( "indoor", "ringoff_plr", "indoor" );
		declareAmbientPackage( "indoor" );
	
	declareAmbientRoom( "battle" );
		setAmbientRoomReverb ("battle","la_1_low_road", 1, 1);
		setAmbientRoomContext( "battle", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "battle" );
	
	declareAmbientRoom( "staples_center" );
		setAmbientRoomTone ("staples_center","blk_la_indoor_bg", .5, .5);
		setAmbientRoomReverb ("staples_center","la_1_arena", 1, 1);
		setAmbientRoomContext( "staples_center", "ringoff_plr", "indoor" );
		declareAmbientPackage( "staples_center" );
	
	//******************************************NEW rooms********************************************

	declareAmbientRoom( "lobby" );
		//setAmbientRoomTone ("la_1_lobby","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("lobby","la_1_lobby", 1, 1);
		setAmbientRoomContext( "lobby", "ringoff_plr", "indoor" );
		declareAmbientPackage( "lobby" );
		
	declareAmbientRoom( "small_room" );
		//setAmbientRoomTone ("la_1_lobby","blk_la_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("small_room","la_1_lobby", 1, 1);
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "small_room" );
	
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

	declareAmbientRoom("bus" );
		setAmbientRoomReverb( "bus", "la_1_bus", 1, 1 );
		setAmbientRoomContext( "bus", "ringoff_plr", "indoor" );	

	
	declareAmbientRoom("intro");
		setAmbientRoomReverb( "intro", "shock_flashbang", 1, 1 );
		
	activateAmbientRoom( 0, "intro", 1 );	
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "outdoor", 0 );
	//activateAmbientRoom( 0, "outdoor", 0 );	
	
	
	declaremusicState ("LA_1_INTRO");
		musicAlias ("mus_la1_intro", 0);
		musicAliasloop ("NULL", 0, 0);
	
	declaremusicState ("LA_1_TURRET");
		musicAliasloop ("mus_la1_turret", 0, 0);
	
	declaremusicState ("LA_1_OFF_TURRET");
		musicAliasloop ("null", 0, 0);
		
	declaremusicState ("LA_1B_INTRO");
		musicAliasloop ("mus_la1b_intro", 0, 5);
		
	declaremusicState ("LA_1B_INTRO_B");
		musicAliasloop ("mus_street_intro", 2, 3);
	
	declareMusicState ("LA_1B_STREET_NO_MUSIC");		
		musicAliasloop ("null", 10, 0);
	
	declareMusicState ("LA_1B_STREET");
		musicAliasloop ("mus_street_pad_loop", 1, 2);
		musicStinger ("mus_claw_stg", 28, true);
		
	declareMusicState ("LA_1B_STREET_CLAW_DEAD");
		musicAliasloop ("mus_street_pad_loop_b", 2, 2);
		musicStinger ("mus_street_battle_pres_stg", 18.5, true);
	
	declareMusicState ("LA_1B_CLAW");
		musicAliasloop ("mus_street_pad_loop", 0, 0);
		
	declareMusicState ("LA_1B_PLAZA");
		musicAliasloop ("mus_plaza_loop", 0, 2);
		
	declareMusicState ("LA_1B_BUILDING_COLLAPSE");
		musicAliasloop ("null", 0, 0);	
		

	
	
	thread tv_sounds();
	thread snd_fx_create();
	level thread sam_turret_snapshot_and_verb_on();
    level thread sam_turret_snapshot_and_verb_off();
    level thread set_intro_snapshot();
    level thread setup_ambient_fx_sounds();
    level thread air_raid_sirens();
    level thread f35_context();
    level thread battle_silent_context();
    level thread force_shock_file_for_intro();
    level thread force_street_flyby_snapshot();
    level thread sound_fade_out_snapshot();
    level thread play_f35_fire_sounds();
}

force_street_flyby_snapshot()
{
	level waittill ("fbsoff");
	snd_set_snapshot("default");	
}

force_shock_file_for_intro()
{
	//Eckert - moved fade in snapshot to main func
	//level waittill ("int_st");

	
	//Hatch open
	level waittill ("stop_intro_snp");
	snd_set_snapshot("spl_la_1b_street_flyby_duck");	
	activateAmbientRoom( 0, "outdoor", 2 );	
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
    level waittill( "mTon" );
    
    //TODO: Replace with actual snapshot, change reverb to actual reverb
   // (handled in other script now) snd_set_snapshot("spl_la_1_sam");
    setAmbientRoomReverb ("outdoor","gen_smallroom", 1, 1);
    level.activeAmbientRoom = "";
    level notify( "updateActiveAmbientRoom" );
}
set_intro_snapshot()
{
	level waittill("intro_started");
	snd_set_snapshot("spl_la_1_intro_vehicle");
	level waittill ("reset_snapshot");
	snd_set_snapshot("default");
}

sam_turret_snapshot_and_verb_off()
{
    level waittill( "mToff" );
    
    snd_set_snapshot("default");
    setAmbientRoomReverb ("outdoor","gen_city", 1, 1);
    level.activeAmbientRoom = "";
    level notify( "updateActiveAmbientRoom" );
}

snd_fx_create()
{
//	while (!isDefined(level.createFXent))
//	{
		wait (1);
//	}

	clientscripts\_audio::snd_add_exploder_alias( 405, "blk_f35_crash_impact" );
	clientscripts\_audio::snd_add_exploder_alias( 410, "blk_f35_crash_impact" );

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
	snd_play_auto_fx( "fx_water_splash_detail", "amb_pipe_splash", 0, 0, 0, false);
	snd_play_auto_fx( "fx_water_pipe_broken_gush", "amb_pipe_gush", 0, 0, 0, false);
	//snd_play_auto_fx( "fx_debris_papers_fall_burning_xlg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
}

air_raid_sirens()
{
	playloopat ("amb_air_raid_siren_l", (16761, -5309, 386));
	playloopat ("amb_air_raid_siren_r", (12408, -5867, 342));
}

f35_context()
{
	 waitforclient(0);
	 setsoundcontext( "f35", "exterior" );
}
battle_silent_context()
{
	level waittill( "set_silent_context" );
	 waitforclient(0);
	 setsoundcontext( "battle", "silent" );
}

sound_fade_out_snapshot()
{
	level waittill ("fade_out");
	wait 2;
	snd_set_snapshot ( "cmn_fade_out" );	
}

play_f35_fire_sounds()
{
	level waittill( "f35_crash_done" );
	snd_play_auto_fx( "fx_fire_line_xsm", "amb_fire_large", 0, 0, 0, false, 200, 2, "amb_fire_large" );
	snd_play_auto_fx( "fx_fire_fuel_sm_line", "amb_fire_large", 0, 0, 0, false, 200, 2, "amb_fire_large" );
}