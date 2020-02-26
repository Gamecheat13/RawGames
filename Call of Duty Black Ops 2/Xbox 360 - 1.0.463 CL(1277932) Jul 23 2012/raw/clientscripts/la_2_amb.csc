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
	snd_set_snapshot("cmn_fade_in");	
	
	declareAmbientRoom( "outdoor" );
	setAmbientRoomTone ("outdoor","blk_la_outdoor_bg", .5, .5);
	setAmbientRoomReverb ("outdoor","la_2_outdoor", 1, 1);
	setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
	setAmbientRoomContext( "outdoor", "f35", "exterior" );
	setAmbientRoomContext( "outdoor", "grass", "no_grass" );
	setAmbientRoomSnapshot ("outdoor", "veh_f35_off");
	declareAmbientPackage( "outdoor" );
//unused	
	declareAmbientRoom( "indoor" );
	setAmbientRoomTone ("indoor","blk_la_indoor_bg", .5, .5);
	setAmbientRoomReverb ("indoor","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "indoor", "ringoff_plr", "indoor" );
	setAmbientRoomContext( "indoor", "grass", "no_grass" );
	setAmbientRoomSnapshot ("indoor", "veh_f35_off");
	declareAmbientPackage( "indoor" );
//enused
	declareAmbientRoom( "battle" );
	setAmbientRoomTone ("battle","blk_la_battle_bg", .5, .5);
	setAmbientRoomReverb ("battle","la_2_outdoor", 1, 1);
	setAmbientRoomContext( "battle", "ringoff_plr", "battle" );
	setAmbientRoomSnapshot ("battle", "veh_f35_off");
	setAmbientRoomContext( "battle", "grass", "no_grass" );
	declareAmbientPackage( "battle" );
	
	declareAmbientRoom( "f35_int" );
 	setAmbientRoomTone( "f35_int", "blk_la_battle_f35_bg" );
 	setAmbientRoomReverb ("f35_int","la_2_cockpit", 1, 1);
 	setAmbientRoomSnapshot ("f35_int", "veh_f35_int");
 	setAmbientRoomContext( "f35_int", "grass", "no_grass" );
 	setAmbientRoomContext( "f35_int", "f35", "interior" );
 	
 	
	declareAmbientRoom( "f35_int_dogfight" );
 	setAmbientRoomTone( "f35_int_dogfight", "blk_la_battle_f35_bg" );
 	setAmbientRoomReverb ("f35_int_dogfight","la_2_cockpit", 1, 1);
 	setAmbientRoomSnapshot ("f35_int_dogfight", "veh_f35_int");
 	setAmbientRoomContext( "f35_int_dogfight", "grass", "in_grass" );
 	setAmbientRoomContext( "f35_int_dogfight", "f35", "interior" );
 	
 	
 	declareMusicState ("LA_2_INTRO");
 		musicAliasLoop ("mus_la2_intro", 0, 2);
 	
	declaremusicState ("LA_2_ESCORT");
	//musicAlias ("mus_la1_intro", 0);
	musicAliasloop ("mus_la2_escort_loop", 1, 2);
		musicStinger ("mus_la2_dogfight_intro", 3.9);
	
	declaremusicState ("LA_2_DOGFIGHT");
		musicAliasloop ("mus_la2_dogfight_loop", 1, 2);
		musicStinger ("mus_la2_dogfight_parachute", 0);
		
	declaremusicState ("LA_2_END");
		musicAliasloop ("null", 0, 0);
		
	declaremusicState ("LA_2_PARACHUTE");
		musicAliasloop ("null", 0, 0);
		
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	//activateAmbientPackage( 0, "f35_int", 0 );
	activateAmbientRoom( 0, "f35_int", 0 );	
	
	level thread activate_f35_room();
	level thread deactivate_f35_room();
	level thread set_intro_to_exterior();
	//level thread f35_context(); comment back in after green light
	thread tv_sounds();
	level thread fx_audio_setup();
	level thread jet_transistion_watcher();
	level thread jet_boost_watcher();	
	level thread setup_ambient_fx_sounds();
	level thread special_greenlight_ending();
	level thread f35_health_system();
	level thread cleanup_ground_emitters();
	level thread change_room_for_dogfight();
	level thread sound_fade_out_snapshot();

}

///////////////////////////////
//Since you are in the jet more often than not the default amb package will be "f35_int"
//set_intro_to_exterior sets the room to exteror just for the intro
//activate_f35_room handles getting into the jet
//deactivate_f35_room sets the room back to exterior for the outro
///////////////////////////////
set_intro_to_exterior()
{
	level waittill( "intro_exterior" );
	waitforclient(0);
    activateAmbientRoom( 0, "outdoor", 1 );
}
activate_f35_room()
{
    level waittill( "start_f35_snap" );
    waitforclient(0);
    player = GetLocalPlayers()[0];
    //player thread radio_chatter();
    wait 10;
    activateAmbientRoom( 0, "f35_int", 1 );
}
deactivate_f35_room()
{
	level waittill( "stop_f35_snap" );
    activateAmbientRoom( 0, "outdoor", 1 );
    //level.f35.should_not_play_sounds = true;
}
///////////////////////////////
///////////////////////////////





jet_transistion_watcher()
{
	while (1)
	{
		player = GetLocalPlayers()[0];
		
		level waittill ("snd_jet_start");
	
		level.sndVtolmode = false;
		player PlaySound(0, "veh_vtol_engage_c" );

		level waittill ("snd_vtol_start");
		
		level.sndVtolmode = true;
		player PlaySound(0,"veh_vtol_disengage_c");
	}
}
jet_boost_watcher()
{

	boost_ent = spawn( 0, (0,0,0), "script_origin" );
	boost_lfe = spawn (0, (0,0,0), "script_origin" );

	while (1)

	{

		player = GetLocalPlayers()[0];

		level waittill ("snd_boost_start");
		//iprintlnbold ("Boost Sound Start");
	
		player PlaySound(0, "veh_f35_boost" );
	
		boost_ent PlayLoopSound ("veh_f35_boost_lp", 1 );
		boost_lfe PlayLoopSOund ("veh_f35_boost_lp_lfe", 1 );
			
		level waittill ("snd_boost_end");
		//iprintlnbold ("Boost Sound End");		

		boost_ent StopLoopSound( 0.5 );
		boost_lfe StopLoopSound( 0.5 );

	}
}
fx_audio_setup()
{
	//auto play sound based on effects name
	snd_play_auto_fx("parking_garage_pillar", "evt_parking_garage");

}

tv_sounds()
{

	playloopat ("blk_vox_emg_broadcast_big", (-14951, -26712, 260));

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

delete_ent_on_save_restore()
{
	level waittill( "save_restore" );
	self delete();
}
setup_ambient_fx_sounds()
{		
	
	snd_play_auto_fx( "fx_la2_fire_window_lg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_window_xlg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_lg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_line_xlg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );
	snd_play_auto_fx( "fx_la2_fire_fuel_sm", "amb_fire_sml", 0, 0, 0, false, 200, 3, "amb_fire_sml" );
	snd_play_auto_fx( "fx_fire_fuel_sm_smolder", "amb_fire_tiny", 0, 0, 0, false, 200, 3, "amb_fire_tiny" );
	//snd_play_auto_fx( "fx_debris_papers_fall_burning_xlg", "amb_fire_large", 0, 0, 0, false, 200, 3, "amb_fire_large" );

}

//TODO: Delete after greenlight
special_greenlight_ending()
{
	level waittill( "gnses" );
	snd_set_snapshot( "spl_la_2_greenlight_ending" );
}

f35_health_system()
{
	level thread max_health_wait();
	level thread health_warnings();
}
max_health_wait()
{
	while(1)
	{
		level waittill( "f35_h_max" );
		soundstoploopemitter( "evt_health_alarm_mid", (0,0,0) );
		soundstoploopemitter( "evt_health_alarm_low", (0,0,0) );
		level thread health_warnings();
	}
}
health_warnings()
{
	level endon( "f35_h_max" );
	
	level waittill( "f35_h_mid" );
	playloopat( "evt_health_alarm_mid", (0,0,0) );
	level waittill( "f35_h_low" );
	playloopat( "evt_health_alarm_low", (0,0,0) );
}
cleanup_ground_emitters()
{
	//sound ground cleanup
	level waittill ("sgc");	
	
	ground_battles = getstructarray ("amb_fadeup_disaster_sirens", "targetname");
	if(IsDefined(ground_battles))
	{
		for (i=0;i<ground_battles.size;i++)
		{
			soundstoploopemitter( ground_battles[i].script_sound, ground_battles[i].origin );
		}
	}
	
	amb_ground_battle_loopers = getstructarray ("amb_fadeup_battle", "targetname");	
	if(IsDefined(amb_ground_battle_loopers))
	{
		for (i=0;i<amb_ground_battle_loopers.size;i++)
		{
			soundstoploopemitter( amb_ground_battle_loopers[i].script_sound, amb_ground_battle_loopers[i].origin );
			
		}
	}
	
}
change_room_for_dogfight()
{
	//wait for dog fight star
	level waittill ("dfs_go");
	setsoundcontext ( "grass", "in_grass" );	
}

sound_fade_out_snapshot()
{
	level waittill ("fade_out");
	//wait 2;
	snd_set_snapshot ( "cmn_fade_out" );	
}
