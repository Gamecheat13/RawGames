//
// file: la_2_amb.csc
// description: clientside ambient script for la_2: setup ambient sounds, etc.
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
	setAmbientRoomReverb ("outdoor","gen_city", 1, 1);
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
	
	declareAmbientRoom( "f35_int" );
 	setAmbientRoomTone( "f35_int", "blk_la_battle_f35_bg" );
 	setAmbientRoomReverb ("f35_int","gen_cockpit", 1, 0);
 	setAmbientRoomSnapshot ("f35_int", "veh_f35_int");
 	setAmbientRoomContext( "f35_int", "f35", "interior" );
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );	
	
	level.playerHealthSystemOverride = ::start_f35_health_system;
	
	level thread activate_f35_room();
	level thread deactivate_f35_room();
	//level thread f35_context(); comment back in after green light
	thread tv_sounds();
	level thread fx_audio_setup();
}
fx_audio_setup()
{
	//auto play sound based on effects name
	snd_play_auto_fx("parking_garage_pillar", "evt_parking_garage");

}

tv_sounds()
{

	soundloopemitter ("blk_vox_emg_broadcast_big", (-14951, -26712, 260));

}

activate_f35_room()
{
     level waittill( "start_f35_snap" );
     waitforclient(0);
     player = GetLocalPlayers()[0];
 //    player thread radio_chatter();
     //wait 5; put back in after greenlight
     //snd_set_snapshot( "spl_pow_no_ext_amb" );
     activateAmbientRoom( 0, "f35_int", 1 );
}
deactivate_f35_room()
{
	level waittill( "stop_f35_snap" );
	wait 3;
    //iprintlnbold( "exit" );
    deactivateAmbientRoom( 0, "f35_int", 1 );
    setsoundcontext( "f35", "exterior" );
}

radio_chatter()
{
	//TUEY  Moved to server so we can do a waittill done.
	level endon( "stop_f35_snap" );
	while(1)
	{
		wait (RandomIntRange (5, 15));
		self playsound(0, "blk_f35_radio_chatter");
		
	}
}

f35_context()
{
	 waitforclient(0);
	 setsoundcontext( "f35", "exterior" );
}

start_f35_health_system( clientnum )
{
	level endon( "save_restore" );
	wait( 1 );
	
	level.f35_health = GetLocalClientHealth( 0 );
	
	level thread play_midhealth_alarms();
	level thread play_lowhealth_alarms();
		
	for( ;; )
	{
		wait ( 0.05 );

		level.f35_health = GetLocalClientHealth( 0 );
	}
}

play_midhealth_alarms()
{
	level endon( "save_restore" );
	
	ent = spawn( 0, (0,0,0), "script_origin" );
	ent thread delete_ent_on_save_restore();
	
	while(1)
	{
		while(level.f35_health <= 90 )
		{
			ent playloopsound( "evt_health_alarm_mid", .05 );
			wait( .05 );
		}
		ent stoploopsound( .1 );
		wait(.05);
	}
}

play_lowhealth_alarms()
{
	level endon( "save_restore" );
	
	ent = spawn( 0, (0,0,0), "script_origin" );
	ent thread delete_ent_on_save_restore();
	
	while(1)
	{
		while(level.f35_health <= 5 )
		{
			ent playloopsound( "evt_health_alarm_low", .05 );
			wait(.05);
		}
		ent stoploopsound( .1 );
		wait(.05);
	}
}

delete_ent_on_save_restore()
{
	level waittill( "save_restore" );
	self delete();
}