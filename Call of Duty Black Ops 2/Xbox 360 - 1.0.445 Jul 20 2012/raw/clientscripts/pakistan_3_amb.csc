//
// file: pakistan_3_amb.csc
// description: clientside ambient script for pakistan_3: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_audio;
#include clientscripts\_music;

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
	
	
	declareAmbientRoom( "pakistan_outdoor" );
	setAmbientRoomTone ("pakistan_outdoor","blk_amb_rain", .5, .5);
	setAmbientRoomReverb ("pakistan_outdoor","pakistan_outdoor", 1, 1);
	setAmbientRoomContext( "pakistan_outdoor", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "pakistan_outdoor" );
	
	declareAmbientRoom( "pak_control_room" );
	setAmbientRoomReverb ("pak_control_room","pakistan_smallroom", 1, 1);
	setAmbientRoomContext( "pak_control_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_control_room" );
	
	declareAmbientRoom( "pak_brick_open" );
	setAmbientRoomReverb ("pak_brick_open","pakistan_stoneroom", 1, 1);
	setAmbientRoomContext( "pak_brick_open", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_brick_open" );
 
	declareAmbientRoom( "pak_carpet_train_room" );
	setAmbientRoomReverb ("pak_carpet_train_room","pakistan_smallroom", 1, 1);
	setAmbientRoomContext( "pak_carpet_train_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_carpet_train_room" );
 
	declareAmbientRoom( "pak_wood_train_room" );
	setAmbientRoomReverb ("pak_wood_train_room","pakistan_smallroom", 1, 1);
	setAmbientRoomContext( "pak_wood_train_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_wood_train_room" );
	
	declareAmbientRoom( "pak_train_warehouse" );
	setAmbientRoomReverb ("pak_train_warehouse","pakistan_largeroom", 1, 1);
	setAmbientRoomContext( "pak_train_warehouse", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_train_warehouse" );
	
	declareAmbientRoom( "pak_above_water_room_sm" );
	setAmbientRoomReverb ("pak_above_water_room_sm","pakistan_smallroom", 1, 1);
	setAmbientRoomContext( "pak_above_water_room_sm", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_above_water_room_sm" );
	
	declareAmbientRoom( "pak_above_water_room_lrg" );
	setAmbientRoomReverb ("pak_above_water_room_lrg","pakistan_largeroom", 1, 1);
	setAmbientRoomContext( "pak_above_water_room_lrg", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_above_water_room_lrg" );
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "pakistan_outdoor", 0 );
	activateAmbientRoom( 0, "pakistan_outdoor", 0 );
	
	
	declareMusicState ("PAKISTAN_CHASE");
		musicAliasloop ("mus_pakistan_chase", 0, 10);
	
		
	declareMusicState ("PAKISTAN_BURNED");
		musicAliasloop ("null", 0, 3.5);
		
	declareMusicState ("PAKISTAN_STANDOFF");
		musicAlias ("mus_standoff", 0);
		
	//thread snd_play_loopers();
	//thread snd_start_autofx_audio();
	level thread mill_scanner();
}
snd_play_loopers()
{
	//clientscripts\_audio::playloopat( "amb_water_int_trans_rumb", (2518, 4050, 373));	
}
	
snd_start_autofx_audio()
{
	//snd_play_auto_fx ( "fx_fireplace01", "amb_fireplace", 0, 0, 0, false );
}

//SELF == Menendez
menendezStartRecording( localClientNum, set, newEnt )
{
	if( set )
	{
		level.surv_ON = true;
    	player = getlocalplayers()[0];
    	player thread menendezChangeDvar( self );
    	level thread waitfor_StopLoop();
    	level thread waitfor_StartLoop();
	}
	else
	{
		level notify( "surv_END" );
	}
}
menendezChangeDvar( menendez )
{
    level endon( "surv_END" );
    
    min_num = .979;
    max_num = .9999;
    min_set = -1;
    max_set = -.1;
    
    ent = spawn( 0, (0,0,0), "script_origin" );
    loop_id = ent playloopsound( "evt_surv_talk_test_loop", 1 );
    setSoundVolume( loop_id, 1 );
    
    level thread menendezEndRecording( ent );
    
    while(1)
    {
        num = self get_view_num( self get_eye(), self GetPlayerAngles(), menendez.origin + (0,0,45) );
        set = abs(scale_speed( min_num, max_num, min_set, max_set, num ));
        
        level set_dvar_and_volume( loop_id, set );
        
        wait(.05);
    }
}
set_dvar_and_volume( loop_id, set )
{   
    if( set == 0 || !level.surv_ON )
    {
        SetDvarfloat( "snd_futz", 1 );
    	//setSoundVolume( loop_id, 0 );
    }
    else
    {
        SetDvarfloat( "snd_futz", set );
    	//setSoundVolume( loop_id, 1 );
    }
}
get_view_num( start_origin, start_angles, end_origin )
{
    normal = VectorNormalize( end_origin - start_origin ); 
    forward = AnglesToForward( start_angles ); 
    dot = VectorDot( forward, normal ); 

    return dot; 
}
waitfor_StopLoop()
{
    level endon( "surv_END" );
    
    while(1)
    {
        level waittill( "surv_OFF" );
        level.surv_ON = false;
    }
}
waitfor_StartLoop()
{
    level endon( "surv_END" );
    
    while(1)
    {
        level waittill( "surv_ON" );
        level.surv_ON = true;
    }
}
menendezEndRecording( ent )
{
    level waittill( "surv_END" );
    
    SetDvarfloat( "snd_futz", 0 );
    ent stoploopsound( 1 );
    wait(1);
    ent delete();
}


mill_scanner()
{
   
    while(1)
    {
        level waittill( "millibar_on" );
        scanEnt = spawn( 0, (0,0,0), "script_origin" );
        scanEnt PlayLoopSound ("evt_mill_scan"); 
		playsound (0, "evt_mill_scan_on", (0,0,0));        
        
        level waittill( "millibar_off" );
        scanEnt StopLoopSound (.5);
		playsound (0, "evt_mill_scan_off", (0,0,0)); 
        wait (1);
        scanEnt Delete();
    }	
   
}	