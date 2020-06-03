//
// file: ber2_amb.gsc
// description: level ambience script for berlin2
// scripter: slayback
//

#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;
#include common_scripts\utility;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	//***************
	//Ber2_Outdoors
	//*************** 

		declareAmbientPackage( "outdoors_pkg" );			
			addAmbientElement( "outdoors_pkg", "bomb_far", 2, 12, 500, 2000 );

	//***************
	//Ber2_Building_Interrior
	//*************** 

		declareAmbientPackage( "stone_room_pkg" );
		
			addAmbientElement( "stone_room_pkg", "bomb_far", 2, 12, 1000, 4000 );
			addAmbientElement( "stone_room_pkg", "bomb_medium", 15, 30, 1000, 3500 );
	
		declareAmbientPackage( "wood_room_pkg" );
			addAmbientElement( "wood_room_pkg", "bomb_far", 2, 12, 500, 3500 );
			addAmbientElement( "wood_room_pkg", "bomb_medium", 15, 30, 800, 3500 );

	//***************
	//Ber2_Subway
	//*************** 
		
			declareAmbientPackage( "rodent_pkg" );		
				addAmbientElement( "rodent_pkg", "amb_rodents", 5, 35, 100, 500 );
	
			declareAmbientPackage( "large_tunnel_pkg" );		
				addAmbientElement( "large_tunnel_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
			declareAmbientPackage( "small_tunnel_pkg" );
				//addAmbientElement( "small_tunnel_pkg", "amb_dog_bark", 3, 6, 2000, 3000);
				//addAmbientElement( "small_tunnel_pkg", "amb_wood_creak", 4, 12, 10, 100 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//Ber2_Outdoors
	//*************** 

		declareAmbientRoom( "outdoors_room" );	
			setAmbientRoomTone( "outdoors_room", "helmet_rainf" );
			setAmbientRoomTone( "outdoors_room", "helmet_rainr" );
			setAmbientRoomReverb( "outdoors_room", "cod_alley",  1, 0.4 );
			
	//***************
	//Ber2_Building_Interrior
	//*************** 

		declareAmbientRoom( "closed_room" );	
			setAmbientRoomTone( "closed_room", "closed_room_wind" );
			setAmbientRoomReverb( "closed_room", "livingroom", 0.70, 1 );
	
		declareAmbientRoom( "partial_room" );	
			setAmbientRoomTone( "partial_room", "partial_room_wind" );
			setAmbientRoomReverb( "partial_room", "livingroom", 1, 0.5 );
	
		declareAmbientRoom( "basement_room" );			
			setAmbientRoomTone( "basement_room", "basement_wind" );
			setAmbientRoomReverb( "basement_room", "auditorium", 0.70, 1 );
			
	//***************
	//Ber2_Subway
	//***************

		declareAmbientRoom( "small_tunnel" );	
			setAmbientRoomTone( "small_tunnel", "bgt_small_tunnel" );
			setAmbientRoomReverb( "small_tunnel", "plain", 0.70, 1 );
	
		declareAmbientRoom( "large_tunnel" );			
			setAmbientRoomTone( "large_tunnel", "bgt_large_tunnel" );
			setAmbientRoomReverb( "large_tunnel", "plain", 0.70, 1 );

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( "outdoors_pkg", 0 );
		activateAmbientRoom( "outdoors_room", 0 );
		
	//*************************************************************************************************
	//                                      START SCRIPTS
	//*************************************************************************************************
/*
	level thread Start_Intro_Music();
	level thread Start_Subway_Music();
	level thread Start_PostIGC_Music();
	level thread Start_FBattle_Music();
	level thread Start_Victory_Music();
	level thread Start_Swell();
	level thread play_halftrackhack();
*/
	level thread play_arty_sound();
	level thread play_metro_arty_sound();
	//level thread light_loop();
	//level thread light_loop_stop();
	level thread play_metro_rats_sound();
	level thread play_wave_arty_sound();
	level thread play_rumble_sound();
	level thread play_wave_sound();
	level thread play_tinnitus();
	
	// SRS 7/29/2008 : added destructible speakers
	level thread destructible_speakers_init();
}


	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************
/*
Start_Intro_Music()
{
	musicplay("MX_Intro", 0);
	wait(45);
	level.MusicTrack = 0;
	Start_Event1_Music();
	Start_PostIGC_Music();
}
Start_Event1_Music()
{	
	//if (level.MusicTrack == 0)
	//{
		musicstop(2);
		wait(3);
		musicplay("MX_Event1", 0);
//	}
}
Start_Swell()
{
	level waittill ("start_swell");
	level.MusicTrack = 1;
	musicstop(2);
	wait(3);
	musicplay("MX_Swell", 0);
	//get_players()[0] playsound ("MX_Swell");
	
	wait (36);
	level.MusicTrack = 0;
	Start_Event1_Music();
}
Start_PostIGC_Music()
{
	level waittill ("start_postigc_music");
	//wait(10);
	musicstop(2);
	wait(3);
	musicplay("MX_Outside", 0);
}
Start_Subway_Music()
{
	level waittill ("start_sewer_music");
	level.MusicTrack = 1;
	musicstop(2);
	wait(3);
	musicplay("MX_Subway", 0);
	wait(130);
	level.MusicTrack = 0;
	Start_Event1_Music();
}
Start_FBattle_Music()
{
	level waittill ("start_fbattle_music");
	musicstop(2);
	wait(3);
	musicplay("MX_Fbattle", 0);
}
Start_Victory_Music()
{
	level waittill ("start_victory_music");
	//wait(4);
	musicstop(2);
	wait(3);
	musicplay("MX_ST_Victory", 0);
}

Start_Vehicle_Music()
{
	level.MusicTrack = 1;
	musicstop(2);
	wait(3);
	musicplay("MX_Pst_IGC", 0);
	wait (55);
	level.MusicTrack = 0;
	Start_Event1_Music();	
}
*/
play_tinnitus()
{
	level waittill("tinnitus");
	tinnitus = getent("2d_origin", "targetname");
	cough_player = getent("rats_2d", "targetname");
	wait 2;
	tinnitus playloopsound("player_explosion_loop",3);
	wait 3.5;
	tinnitus stoploopsound(2);
	cough_player playsound("cough_player_self");

}
play_arty_sound()
{

	level endon( "subway_gate_opened" );
	
	while(1)
	{
		level waittill("ber2_earthquake");
		ber2_earthquake = getent("2d_origin", "targetname");
		ber2_earthquake playsound ("art_int");
	}

}
play_metro_arty_sound()
{

	level endon( "subway_exitgate_startDefenders" );
	
	while(1)
	{
		level waittill("metro_arty");
		metro_arty = getent("2d_origin", "targetname");
		metro_arty playsound ("metro_arty");
	}

}
play_metro_rats_sound()
{

	level endon( "wave_finished" );
	
	while(1)
	{
		level waittill("start_rats");
		start_rats = getent("rats_2d", "targetname");
		start_rats playsound ("rats");
	}

}
play_wave_arty_sound()
{

	level endon( "wave_finished" );
	
	while(1)
	{
		level waittill("wave_arty");
		wave_arty = getent("2d_origin", "targetname");
		wave_arty playsound ("wave_arty");
	}

}
play_rumble_sound()
{

	level endon( "wave_finished" );
	
	while(1)
	{
		level waittill("rumble");
		rumble = getent("rumble_2d", "targetname");
		rattle1 = getent("rattle1", "targetname");
		rattle2 = getent("rattle2", "targetname");
		
		rumble playloopsound ("rumble",1);
		
		wait 7;
		
		rattle1 playsound ("rattle1");
		rattle2 playsound ("rattle2");
		
		level waittill("stop_wave_sound");
		rumble stoploopsound (.2);
		
	}

}
play_wave_sound()
{

	
	level waittill("subway_exitgate_startRunners");
	
	subway_exitgate_startRunners = getent("smodel_metrowave", "targetname");
	wave_impact = getent("wave_impact", "targetname");
	underwater_loop1 = getent("underwater_loop1", "targetname");
	underwater_loop2 = getent("underwater_loop2", "targetname");
	underwater_scream1 = getent("underwater_scream1", "targetname");
	underwater_scream2 = getent("underwater_scream2", "targetname");
	slow_shatter = getent("slow_shatter", "targetname");
	
	subway_exitgate_startRunners playloopsound ("wave");
	
	level waittill("slow_shatter");
	
	slow_shatter playsound ("slow_shatterL");
	slow_shatter playsound ("slow_shatterLrev");
	slow_shatter playsound ("dewww");
	
	level waittill("stop_wave_sound");
	
	subway_exitgate_startRunners stoploopsound(.1);
	wave_impact playsound ("wave_impactF");
	underwater_loop1 playloopsound ("under_waterF",1);
	underwater_loop2 playloopsound ("under_waterR",1);
	
	
	wave_impact playsound ("water_passF");
	
	level waittill("water_scream");
	
	underwater_scream1 playsound ("water_scream1");
	
	level waittill("water_scream");
	
	underwater_scream2 playsound ("water_scream3");
	
	level waittill("loops_stop");
	
	underwater_loop1 stoploopsound (5);
	underwater_loop2 stoploopsound (5);
	
	

}
state_timer(time, state_name)
{
	wait(time);
	setmusicstate(state_name);

}

// SRS 7/29/2008: destructible speakers
destructible_speakers_init()
{
	// don't want to spam the console with sound errors when there are no listeners connected
	flag_wait( "all_players_connected" );
	
	speakers = GetEntArray( "destructible_speaker", "targetname" );
	
	for( i = 0; i < speakers.size; i++ )
	{
		if( !IsDefined( speakers[i].script_noteworthy ) )
		{
			ASSERTMSG( "Destructible speaker at origin " + speakers[i].origin + " must have script_noteworthy set to the soundalias you want it to loop." );
		}
		
		level thread destructible_speaker( speakers[i] );
	}
}

destructible_speaker( speaker )
{
	alias = speaker.script_noteworthy;
	speakerDmg = maps\ber2_util::getent_safe( speaker.target, "targetname" );
	
	// init
	speakerDmg Hide();
	speaker PlayLoopSound( alias );
	speaker SetCanDamage( true );
	
	// wait for damage
	while( 1 )
	{
		speaker waittill( "damage", dmg, attacker, direction_vec, point, type );
		
		if( IsPlayer( attacker ) )
		{
			if( type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET" )
			{
				break;
			}
		}
	}
	
	speakerDmg Show();
	speakerDmg PlaySound( "speaker_break" );
	PlayFx( level._effect["wire_sparks"], speakerDmg.origin );
	
	speaker Delete();
	
	// SRS 8/9/2008: give points in arcade mode
	if( arcademode() )
	{
		arcademode_assignpoints( "arcademode_score_generic500", attacker );
	}
}
