//
// file: khe_sanh_amb.csc
// description: clientside ambient script for khe_sanh: setup ambient sounds, etc.
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
	
		declareAmbientRoom( "outdoor" );
		setAmbientRoomReverb ("outdoor","khe_san_outdoor", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "outdoor" );
			
		declareAmbientRoom ("trench");
		setAmbientRoomReverb ("trench","khe_san_trench", 1, 1);
		setAmbientRoomContext( "trench", "ringoff_plr", "outdoor" );
		declareAmbientPackage ("trench");
		
		declareAmbientRoom ("wood_bunker");
		setAmbientRoomReverb ("wood_bunker","khe_san_wood_bunker", 1, 1);
//		setAmbientRoomContext( "trench", "ringoff_plr", "outdoor" );
		declareAmbientPackage ("wood_bunker");
		
		declareAmbientRoom ("khe_san_wood_bunker");
		setAmbientRoomReverb ("khe_san_wood_bunker","khe_san_wood_bunker", 1, 1);
//		setAmbientRoomContext( "trench", "ringoff_plr", "outdoor" );
		declareAmbientPackage ("khe_san_wood_bunker");
	
	
		declareAmbientRoom ("small_cave");
		setAmbientRoomReverb ("small_cave","khe_san_small_cave", 1, 1);
//		setAmbientRoomContext( "trench", "ringoff_plr", "outdoor" );
		declareAmbientPackage ("small_cave");

		declareAmbientRoom ("open_wood_bunker");
		setAmbientRoomReverb ("open_wood_bunker","khe_san_open_wood_bunker", 1, 1);
		setAmbientRoomContext( "open_wood_bunker", "ringoff_plr", "outdoor" );
		declareAmbientPackage ("open_wood_bunker");

		declareAmbientRoom ("sandbag_bunker");
		setAmbientRoomReverb ("sandbag_bunker","khe_san_sandbag_bunker", 1, 1);
		setAmbientRoomContext( "sandbag_bunker", "ringoff_plr", "outdoor" );
		declareAmbientPackage ("sandbag_bunker");
		
		
		declareAmbientRoom ("pipe");
		setAmbientRoomReverb ("pipe","khe_san_pipe", 1, 1);
		setAmbientRoomContext( "pipe", "ringoff_plr", "indoor" );
		declareAmbientPackage ("pipe");








	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "outdoor", 0 );
		activateAmbientRoom( 0, "outdoor", 0 );		
		
		
		declareMusicState("JEEP_RIDE"); 
			musicAliasloop("mus_creedence_base", 0, 4);
		
		declareMusicState( "CRASH");
			musicAlias("mus_crash_c130", 0);
			musicwaittilldone();
			
		declareMusicState ("PICKUP_BODY");
			musicAliasloop ("mus_bendz_trenchwalk_STG", 0, 0);
			
		declareMusicState ("SARGE_OWNED");
			musicAlias ("mus_hit_sarge_mortared", 0);
		
		declareMusicState("TRENCH_WARFARE");
			musicAliasloop ("mus_warden_trench_loop", 0, 0);
			musicStinger ("mus_pegasus_nva_fight", 10, true);

		declareMusicState("TRENCH_NVA_FIGHT_AI");
			musicAliasloop ("mus_warden_trench_loop", 0, 0);
			musicStinger ("mus_hit_vc_attack", 5, true);
			
		declareMusicState("VC_ATTACK");
			musicAliasloop ("mus_warden_trench_loop", 0, 2);
			
		declareMusicState ("FOUGASSE_SECTION");
			musicAliasloop ("mus_warden_trench_loop", 0, 2);
			
		declareMusicState ("FUGAZIS_BROTHER");
			musicAliasloop ("mus_warden_trench_loop", 0, 2);		
			
		declareMusicState ("TANK_DEFEND");		
			musicAliasloop("mus_virus_tank_defend_loop", 0, 2);
			musicStinger ("mus_trailer_fougasse_stg", 6, true);	

		declareMusicState("TRENCH_DEFEND");
			musicAliasloop ("mus_pegusus_defend_loop", 0,2);
			musicStinger ("mus_pegusus_defend_stg", 15, true);
		
		declareMusicState ("END_TANKS");
			musicAliasloop ("mus_resurrection_tension_loop", 0,0);
		
		declareMusicState ("FIGHT_ON_HILL");
			musicAliasloop ("mus_virus_downhill_perc", 0,0);
			musicStinger ("mus_virus_kick_barrel_stg", 25, true);
			
		declareMusicState ("KICK_BARRELS");
			musicAliasloop ("mus_virus_downhill_perc", 0,0);
			
		declareMusicState ("HAMBURGER_HILL");
			musicAliasloop ("mus_virus_hamburgerhill_loop", 0,0);
			musicStinger ("mus_player_shocked_stg", 25, true);
				
		declareMusicState ("PLAYER_SHOCKED");	
			musicAliasloop ("mus_resurrection_tension_loop", 0,0);

		declareMusicState ("IN_THE_JEEP");
			musicAliasloop ("mus_virus_tank_defend_loop", 0, 4);	
			musicStinger ("mus_creedence_ending", 30, true);
			
		declareMusicState ("ENDING");	
			musicAliasloop ("mus_eagleclaw_mason_hero", 0,0);
		
		level thread tow_missle_snapshots_and_telemetry();
		level thread vc_attacks_snapshot();
		level thread khe_sanh_intro_snapshot();
		level thread khe_sanh_e3_end();
		level thread khe_sanh_c130_snapshot();
		level thread khe_sanh_base_snapshot();
		level thread khe_sanh_woods_scene();
		level thread khe_sanh_default();
		level thread khe_sanh_end_cinematic();
		
			

		
}
tow_missle_snapshots_and_telemetry()
{
	if (!IsDefined (level.telemetry_sound_ent))
	{
		level.telemetry_sound_ent = Spawn( 0, (0,0,0), "script_origin" );		
	}
	while(1)
	{
		level waittill ("tms");
		
		level.telemetry_sound_ent playloopsound( "wpn_tow_telemetry_loop", 3 );		

		snd_set_snapshot( "wpn_tow_missile" );
	    level waittill( "tmu" );
	    level.telemetry_sound_ent stoploopsound (0.25);

	    snd_set_snapshot( "default" );	
	}
	
}
vc_attacks_snapshot()
{
		level waittill ("vca");
		//snd_set_snapshot( "khe_sanh_vc_attack" );
		level waittill ("vcd");
		snd_set_snapshot( "default" );		
}
khe_sanh_intro_snapshot()
{
		level waittill ("ints");
		//snd_set_snapshot( "khe_sanh_intro" );
	
}
khe_sanh_base_snapshot()
{
		level waittill ("intn");
		//snd_set_snapshot( "khe_sanh_base" );		
}
khe_sanh_e3_end()
{
	level waittill ("e3_end");	
	snd_set_snapshot( "alloff_except_music" );	
	
}
khe_sanh_c130_snapshot()
{
	level waittill ("crsh");	
	//snd_set_snapshot( "khe_sanh_c130" );
	
	level waittill ("crsh_over");	
	snd_set_snapshot( "default" );
	
}
khe_sanh_woods_scene()
{	
	sound_bg = Spawn( 0, (0,0,0), "script_origin" );
	level waittill ("wds_scene");
	//snd_set_snapshot( "khe_sanh_woods");
	sound_bg playloopsound ("evt_win_breach_bg");
		
	level waittill ("dflt");
	sound_bg stoploopsound();
}
khe_sanh_default()
{	
	level waittill ("dflt");
	snd_set_snapshot( "default");	
	playsound (0, "evt_time_slow_stop", (0,0,0));
}
khe_sanh_end_cinematic()
{
	level waittill ("theend");
	//snd_set_snapshot( "khe_sanh_ending" );
}

