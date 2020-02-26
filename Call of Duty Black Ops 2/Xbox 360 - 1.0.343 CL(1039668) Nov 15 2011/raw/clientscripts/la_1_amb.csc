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





	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );	
	
	
	declaremusicState ("LA_1_INTRO");
		musicAlias ("mus_la1_intro", 0);
		musicAliasloop ("NULL", 0, 0);
		musicStinger ("mus_post_crash_intro", 0.35);
		musicwaittilldone();
	
	declareMusicState ("LA_POST_CRASH");
		musicAliasloop ("mus_post_crash_loop", 0, 2);
		musicStinger ("mus_turret_jump", 0);
		
	declaremusicState ("LA_1_TURRET_JUMP");			
		musicAliasloop ("NULL", 0, 0);
	
	declaremusicState ("LA_1_TURRET");
		musicAliasloop ("mus_la1_turret", 0, 0);
	
	
	declaremusicState ("LA_1_TURRET");
		musicAliasloop ("mus_la1_turret", 0, 0);
	
	declaremusicState ("LA_1_OFF_TURRET");
		musicAliasloop ("null", 0, 0);
	

		
	thread tv_sounds();
	thread snd_fx_create();
	level thread sam_turret_snapshot_and_verb_on();
    level thread sam_turret_snapshot_and_verb_off();
    level thread sonar_vision();       
    level thread set_intro_snapshot();
    level thread setup_ambient_fx_sounds();
   	level thread play_siren_on_cop_car();
   	level thread play_siren_on_cop_car_2();
   	level thread air_raid_sirens();
    level thread f35_context();
}


tv_sounds()
{
	//small
	//soundloopemitter ("blk_vox_emg_broadcast", (12384, -2987, 308));
	//soundloopemitter ("blk_vox_emg_broadcast", (12499, -2124, 325));
	//soundloopemitter ("blk_vox_emg_broadcast", (12432, -1187, 313));
	
	//big
	soundloopemitter ("blk_vox_emg_broadcast_big", (9099, -606, 413));
	soundloopemitter ("blk_vox_emg_broadcast_big", (10396, 874, 591));
	soundloopemitter ("blk_vox_emg_broadcast_big", (13964, -4424, 311));

	
	//small f35
	soundloopemitter ("blk_vox_emg_broadcast", (1625, 8261, 399));
	soundloopemitter ("blk_vox_emg_broadcast", (3312, 8935, 356));
		
}


sam_turret_snapshot_and_verb_on()
{
	setsoundcontext( "f35", "exterior" );
	
	level waittill( "mTon" );
    
    //TODO: Replace with actual snapshot, change reverb to actual reverb
    snd_set_snapshot("spl_la_1_sam");
    setAmbientRoomReverb ("outdoor","gen_smallroom", 1, 1);
    level.activeAmbientRoom = "";
    level notify( "updateActiveAmbientRoom" );
    setsoundcontext( "f35", "interior" );
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
    setsoundcontext( "f35", "exterior" );
}

snd_fx_create()
{

	wait (1);


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
	copsiren1 PlayLoopSound("amb_stationary_siren");
}


play_siren_on_cop_car_2()
{
	copsiren2 = spawn (0, (8391, -39665, 372 ), "script_origin");
	copsiren2 PlayLoopSound ("amb_stationary_siren");
}

air_raid_sirens()
{
	soundloopemitter ("amb_air_raid_siren_l", (5876, -55025, 823));
	soundloopemitter ("amb_air_raid_siren_r", (10533, -55215, 801));
}

f35_context()
{
	 waitforclient(0);
	 setsoundcontext( "f35", "exterior" );
}
