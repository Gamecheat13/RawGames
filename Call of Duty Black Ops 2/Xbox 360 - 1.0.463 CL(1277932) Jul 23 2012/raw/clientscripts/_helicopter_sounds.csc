
#include clientscripts\_utility; 
#include clientscripts\_music;
#include clientscripts\_audio;

// *************************************************
// INIT HELI SOUNDS
//
// List of availible sound specific bones
// "SND_Cockpit"
// "SND_INT_F_L"
// "SND_INT_F_R"
// "SND_INT_R_L"
// "SND_INT_R_R"
// "SND_INT_Rotor"
// "SND_Rotor"
// "SND_Tail_Rotor"
// "SND_UNDER_Body"
// "SND_WIND_Left"
// "SND_WIND_Right"
//
// *************************************************

// heli_type, part_type, max_speed_vol, min_vol, max_vol, max_speed_pitch, min_pitch, max_pitch
init()
{
	level.jet_stick_turn_rate = .5;
	level.jet_stick_down_rate = .3;
	level.jet_stick_up_rate = .3;
	
	//pitch was .05
	level.jet_stick_pitch_turn_rate = .9;
	level.jet_stick_pitch_down_rate = .9;
	level.jet_stick_pitch_up_rate = .9;	
	
	level.pitch_run_rate = .9;		
	
	level._entityShutDownCBFunc = clientscripts\_helicopter_sounds::heli_linkto_sound_ents_delete;
	level.heliSoundValues = [];
	
	level thread delete_loop_sound_save_restore_watcher();

	//plane_f35_player_vtol
	
	init_heli_sound_values( "f35", "idle",					95, 0.3, 0.8, 95, 1, 1.05 );
	init_heli_sound_values( "f35", "forward",				95, 0.05, 0.1, 95, 1, 1 );
	init_heli_sound_values( "f35", "up",					95, 0.05, 0.1, 95, 1, 1.05 );
	
	
	//osprey_vtol
	
	init_heli_sound_values( "plane_x78", "steady",			40, 0.4, 1, 45, .9, 1.1 );
	init_heli_sound_values( "plane_x78", "down",			40, 0.3, 1, 45, .9, 1.1 );
	init_heli_sound_values( "plane_x78", "up",				40, 0.3, 1, 45, .9, 1.1 );
	
	
	//firescout_drone
	
	init_heli_sound_values( "drone_firescout", "turbine",		95, 0.6, 1, 35, 0.9, 1.1 );
	init_heli_sound_values( "drone_firescout", "distant",		95, 0.6, 1, 40, 0.9, 1.1 );
	init_heli_sound_values( "drone_firescout", "close",			95, 0.6, 1, 40, 0.9, 1.1 );
	
	
	//LA2 F35
	
	init_heli_sound_values( "f35_la2", "forward",		90, 0.7, 1, 90, 1, 1 );
	
	
	//Jet F35 Vtol in Test Helicpter Crash
	//						heli_type	part_type			max_speed_vol	min_vol		max_vol		max_speed_pitch		min_pitch	max_pitch
	init_heli_sound_values( "f35_vtol", "steady",			400, 			0.2, 		1,	 		300, 				1, 			1.3 ); 	 	//steady
	init_heli_sound_values( "f35_vtol", "steady_low",		160, 			0.4, 		1,	 		650, 				1, 			1.15 ); 	 	//steady
 	init_heli_sound_values( "f35_vtol", "steady_hum",		95, 			0.6, 		1,	 		400, 				1, 			1.1 ); 	 	//steady
	init_heli_sound_values( "f35_vtol", "turn",				300, 			0.01, 		1,	 		600, 				1, 			1.25 );     //turn
	init_heli_sound_values( "f35_vtol", "turn_rattle",		400, 			0.01, 		1,	 		500, 				1, 			1.05 );     //turn
	init_heli_sound_values( "f35_vtol", "up",				300,			0.01, 		1,	 		600, 				1, 			1.25 );    	//up 1.2
	init_heli_sound_values( "f35_vtol", "up_rattle",	    500,			0.01, 		.5,	 		500, 				1, 		    1.05 );    	//up 1.1
	init_heli_sound_values( "f35_vtol", "down",				495, 			0.01,		1,	 		685, 				1, 			1.4 );     //down
	init_heli_sound_values( "f35_vtol", "afterburn",		800, 			0.4,		1,	 		500, 				1, 			1.1 );     //down
 	init_heli_sound_values( "f35_vtol", "turn_whine",		895, 			0.01, 		1,	 		1, 					1, 			1.4 );     //turn


	
/*/old Values for debug	
	init_heli_sound_values( "f35_vtol", "steady",			95, 			0.3, 		0.8, 		95, 				1, 			1.05 ); 	 //steady
 	init_heli_sound_values( "f35_vtol", "turn",				95, 			0.05, 		0.1, 		95, 				1, 			1 );       //turn
	init_heli_sound_values( "f35_vtol", "up",				95,				0.05, 		0.1, 		95, 				1, 			1.05 );    //up
	init_heli_sound_values( "f35_vtol", "down",				95, 			0, 			0.5, 		95, 				.9, 		1.1 );       //down	
*/

	init_heli_sound_values( "littlebird", "turbine", 		25, 0.75, 0.8, 65, 1,  1);
	init_heli_sound_values( "littlebird", "top_rotor",		15, 0.85, 1, 25, 0.95, 1); 
	init_heli_sound_values( "littlebird", "tail_rotor", 	25, 0.95, 1, 35, 0.95, 1); 
	
	init_heli_sound_values( "huey", "cockpit",				65, 0.6, 0.8, 65, 1, 1.1 );
	init_heli_sound_values( "huey", "cockpit2",				45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "int_eng",				45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "int_eng2",				45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "int_eng3", 			45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "ext_rotor",			45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "tail_rotor",			45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "tail_rotor",			45, 0.5, 1, 45, 0.95, 1.1);
	
	init_heli_sound_values( "hind", "cockpit", 				95, 0.6, 0.8, 95, 1, 1.1 );
	init_heli_sound_values( "hind", "cockpit2",				95, 0.5, 0.8, 95, 1, 1.2 );
	init_heli_sound_values( "hind", "int_eng", 				65, 0.5, 0.8, 65, 1, 1.1 );
	init_heli_sound_values( "hind", "int_eng2",				65, 0.4, 0.9, 65, 1, 1.1 );
	init_heli_sound_values( "hind", "eng_dmg", 				40, 0.3, 0.5, 65, 1, 1.1 );
	init_heli_sound_values( "hind", "ext_rotor",			70, 0.5, 1, 70, 0.95, 1.1 );
	
	init_heli_sound_values( "hip", "turbine",				15, 0.85, 1, 20, 1, 1.0); 
	init_heli_sound_values( "hip", "top_rotor",					15, 0.85, 1, 20, 0.95, 1);
	init_heli_sound_values( "hip", "tail_rotor",					15, 0.85, 1, 20, 0.95, 1.1);

	
	init_heli_sound_values( "heli_osprey", "steady",		15, 0.75, 1, 30,  0.9,    1.05 );
	init_heli_sound_values( "heli_osprey", "up",			15, 0.5,  1, 30, 0.9,  1);
	init_heli_sound_values( "heli_osprey", "down",			15, 0.5,  1, 30, 0.95, 1.05);
	
	
	init_heli_sound_values( "heli_alouette", "turbine",		50, 0.85, 1, 50, .95, 1.1 );
	init_heli_sound_values( "heli_alouette", "top_rotor",	50, 0.85, 1, 50, 0.95, 1.05);
	init_heli_sound_values( "heli_alouette", "tail_rotor",	50, 0.85, 1, 50, 0.95, 1.1);
	
	
	init_heli_sound_values( "hind_enemy", "turbine",		45, 0.6, 0.8, 65, 1, 1.0 );
	init_heli_sound_values( "hind_enemy", "top_rotor",		15, 0.5, 1, 25, 0.95, 1.0);
	init_heli_sound_values( "hind_enemy", "tail_rotor",		45, 0.5, 1, 45, 0.95, 1.0);
	init_heli_sound_values( "hind_enemy", "distant",		45, 0.5, 1, 45, 0.95, 1.0);
	
	init_heli_sound_values( "huey_toda", "turbine", 		25, 0.75, 0.8, 65, 0.9,  1);		
	init_heli_sound_values( "huey_toda", "top_rotor",		15, 0.85, 1, 25, 0.95, 1); 
	init_heli_sound_values( "huey_toda", "tail_rotor", 		25, 0.95, 1, 35, 0.95, 1); 
	init_heli_sound_values( "huey_toda", "distant",			25, 0.75, 0.8, 65, 0.9, 1);
	
	
	init_heli_sound_values( "heli_chinook", "turbine",		15, 0.80, 1, 35, 0.95, 1.05);
	init_heli_sound_values( "heli_chinook", "top_rotor",	15, 0.80, 1, 35, 0.95, 1.05);	

	init_heli_sound_values( "huey_player", "turbine", 		65, 0.6, 0.8, 65, 1, 1.1 );		
	init_heli_sound_values( "huey_player", "top_rotor",		45, 0.5, 1, 45, 0.95, 1.1); 	
	init_heli_sound_values( "huey_player", "tail_rotor", 	45, 0.5, 1, 45, 0.95, 1.0); 	
	init_heli_sound_values( "huey_player", "wind_rt", 		45, 0.5, 1, 45, 0.95, 1.0); 	
	init_heli_sound_values( "huey_player", "wind_lft", 		45, 0.5, 1, 45, 0.95, 1.0); 

	init_heli_sound_values( "heli_pavelow_la2", "turbine",	100, 0.95, 1, 100, .95, 1.0 );	
	
	init_heli_sound_values( "qrdrone", "turbine_idle", 20, 0.8, 0.0, 16, .9, 1 );		
	init_heli_sound_values( "qrdrone", "turbine_moving", 20, 0.0, 1, 20, 1, 1 );
	init_heli_sound_values( "qrdrone", "distant", 20, 1, 1, 20, 1, 1 );
	init_heli_sound_values( "qrdrone", "close", 20, 1, 1, 20, 1, 1 );
	
	
	init_heli_sound_values( "qrdrone_so", "turbine_idle", 	20, 		0.8, 		0.0, 		16, 				.9, 		1 );		
	init_heli_sound_values( "qrdrone_so", "turbine_moving", 20, 		0.0, 		0.8, 		20, 				.9, 		1 );		
	init_heli_sound_values( "qrdrone_so", "turn",		    5, 			  0, 		 1,	 		 1, 				1, 			1 );
	

	init_heli_sound_values( "osprey", "turbine", 	    65, 			0.7, 		1,	 		65, 				1, 		1.1 );		
	init_heli_sound_values( "osprey", "top_rotor",		35, 			0.95, 		1, 			100, 				1, 		1.1	); 	
	init_heli_sound_values( "osprey", "tail_rotor", 	35, 			0.95, 		1, 			45, 				1, 		1.1	); 	
	
	init_heli_sound_values( "vtol", "turbine",			45, 0.6, 0.8, 65, 1, 1.0 );
	init_heli_sound_values( "vtol", "top_rotor",		15, 0.5, 1, 25, 0.95, 1.0);
	
	init_heli_sound_values( "blackhawk", "turbine", 		65,				0.6, 		0.8, 		65, 				1, 			1.1 );		
	init_heli_sound_values( "blackhawk", "top_rotor",		45,				0.7, 		1, 			45, 				0.95, 		1.1); 	
	init_heli_sound_values( "blackhawk", "tail_rotor", 		45, 			0.5, 		1, 			45, 				0.95, 		1.1); 	
	
	init_heli_sound_values( "heli_future", "turbine", 		50, 			0.7, 		1, 			60, 				.9, 		1.1 );		
	init_heli_sound_values( "heli_future", "rotor",      	35, 			0.7, 		1, 			45, 				.9, 		1.1 );	
	
	
	
	
	thread stupiddelayfix();
	
/#
	if ( GetDvar( "helisounds" ) == "" )
	{
		SetDvar( "helisounds", "" );
	}

	level thread command_parser();

	level thread command_parserpitch();
		
#/
}

stupiddelayfix()
{
	wait 1;
	register_clientflag_callback("helicopter", 2, ::updatestatus);
}

updatestatus(localClientNum, flag, set, newEnt)
{
	self.should_not_play_sounds = set; 
}

init_heli_sound_values( heli_type, part_type, max_speed_vol, min_vol, max_vol, max_speed_pitch, min_pitch, max_pitch )
{
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		level.heliSoundValues[heli_type] = [];
	}
	if( !IsDefined( level.heliSoundValues[heli_type][part_type] ) )
	{
		level.heliSoundValues[heli_type][part_type] = spawnStruct();
	}
	
	level.heliSoundValues[heli_type][part_type].speedVolumeMax = max_speed_vol;
	level.heliSoundValues[heli_type][part_type].speedPitchMax = max_speed_pitch;
	level.heliSoundValues[heli_type][part_type].volumeMin = min_vol;
	level.heliSoundValues[heli_type][part_type].volumeMax = max_vol;
	level.heliSoundValues[heli_type][part_type].pitchMin = min_pitch;
	level.heliSoundValues[heli_type][part_type].pitchMax = max_pitch;
	
	/#
	if( GetDvarint( "debug_heli" ) > 0 )
	{
		println("Init Heli Sounds heli_type: " + heli_type );
		println("Init Heli Sounds part_type: " + part_type );	
		println("Init Heli Sounds max_speed_vol: " + max_speed_vol );	
		println("Init Heli Sounds min_vol: " + min_vol );	
		println("Init Heli Sounds max_vol: " + max_vol );
		println("Init Heli Sounds max_speed_pitch: " + max_speed_pitch );
		println("Init Heli Sounds min_pitch: " + min_pitch );	
		println("Init Heli Sounds max_pitch: " + max_pitch );	
	}			
	#/	
}

/#
command_parser()
{
	while(1)
	{
		command = GetDvar( "helisounds" );
		if ( command != "" )
		{
			success = true;
			tokens = strtok( command, " " );
			if ( !isdefined( tokens[0] ) || !IsDefined(level.heliSoundValues[tokens[0]]) )
			{
				if ( isdefined( tokens[0] ) )
					println("helisounds Did not recognize helicopter type:  " + tokens[0] );
				else
					println("helisounds Did not recognize helicopter type" );
					
					
				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				success = false;
			}	
//			else if ( !isdefined( tokens[1] )|| !IsDefined(level.heliSoundValues[heli_type][tokens[1]]))
			else if ( !isdefined( tokens[1] ) )
			{
				if ( isdefined( tokens[1] ) )
					println("helisounds Did not recognize helicopter part:  " + tokens[0] + " for heli: " + tokens[1] );
				else
					println("helisounds Did not recognize helicopter part for heli: " + tokens[0] );
				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				success = false;
			}	
			else if ( !isdefined( tokens[2] ) )
			{
				println("helisounds Did not recognize helicopter value name for heli:" + tokens[0] + " part: " + tokens[1] );

				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				success = false;
			}	
			else if ( !isdefined( tokens[3] ) )
			{
				println("helisounds Did not recognize helicopter value for heli:" + tokens[0] + " part: " + tokens[1] );

				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				success = false;
			}	
		
			if ( success )
			{
				heli_type = tokens[0];
				heli_part = tokens[1];
				value_name = tokens[2];
				value = float(tokens[3]);
				//value = value / 10
				switch( value_name )
				{
					case "volumemin":
						level.heliSoundValues[heli_type][heli_part].volumeMin = value;
						println("Setting volumeMin to " + value );
						break;
					case "volumemax":
						level.heliSoundValues[heli_type][heli_part].volumeMax = value;
						println("Setting volumeMax to " + value );
						break;
					case "pitchmin":
						level.heliSoundValues[heli_type][heli_part].pitchMin = value;
						println("Setting pitchMin to " + value );				
						break;
					case "pitchmax":
						level.heliSoundValues[heli_type][heli_part].pitchMax = value;
						println("Setting pitchMax to " + value );
						break;
					case "speedvolumemax":
						level.heliSoundValues[heli_type][heli_part].speedVolumeMax = value;
						println("Setting speedVolumeMax to " + value );
						break;
					case "speedpitchmax":
						level.heliSoundValues[heli_type][heli_part].speedPitchMax = value;
						println("Setting speedPitchMax to " + value );
						break;
					default:
						//iprintln("helisounds Did not recognize helicopter value name for heli:" + heli_name + " part: " + part_name + " value name:" + value_name);
						println("no case match - helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				}
			}
			SetDvar( "helisounds", "" );
		}
		wait(0.1);		
	}	
}


command_parserpitch()
{
	while(1)
	{
		command = GetDvar( "jetsounds" );
		if ( command != "" )
		{
			//success = true; -- this is always set to true, so commented out and if commented out
			tokens = strtok( command, " " );
			//if ( success )
			//{
				value_name = tokens[0];
				value = float(tokens[1]);
				//value = value / 10
				switch( value_name )
				{
					case "turnrate":
						level.jet_stick_pitch_turn_rate = value;
						println("Setting volumeMin to " + value );
						break;
					case "downrate":
						level.jet_stick_pitch_down_rate = value;
						println("Setting volumeMax to " + value );
						break;
					case "uprate":
						level.jet_stick_pitch_up_rate = value;
						println("Setting pitchMin to " + value );				
						break;
					case "runrate":
						level.pitch_run_rate = value;
						println("Setting runrate to " + value );
						break;
					default:
						//iprintln("helisounds Did not recognize helicopter value name for heli:" + heli_name + " part: " + part_name + " value name:" + value_name);
						println("no case match - helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				}
			//}
			SetDvar( "jetsounds", "" );
		}
		wait(0.1);		
	}	
}
#/
		
//tag, type, bone, run

init_heli_sounds_f35_vtol() //self == jet
{
	level endon( "save_restore" );
	self endon( "heli_entityshutdown" );

	wait (.1);
	self setup_heli_sounds( "steady",	"engine",		"tag_engine",		"veh_f35_steady" );
	self setup_heli_sounds( "turn",		"engine",		"tag_engine",		"veh_f35_turn" );
	self setup_heli_sounds( "up",		"engine",		"tag_engine",		"veh_f35_up" );
	self setup_heli_sounds( "down",		"engine",		"tag_engine",		"veh_f35_down" );
	self setup_heli_sounds( "afterburn","engine",		"tag_engine",		"veh_f35_afterburn" );
	self setup_heli_sounds( "turn_whine","engine",		"tag_engine",		"veh_f35_turn_whine" );	
	self setup_heli_sounds( "steady_low",	"engine",	"tag_engine",	    "veh_f35_steady_low" );
	self setup_heli_sounds( "steady_hum",	"engine",	"tag_engine",	    "veh_f35_hum" );
	self setup_heli_sounds( "turn_rattle", "engine",	"tag_engine",		"veh_f35_rattle_turn" );
	self setup_heli_sounds( "up_rattle", "engine",	    "tag_engine",		"veh_f35_rattle_up");
	self setup_heli_sounds( "telemetry", "engine",	    "tag_engine",		"veh_f35_telemetry");
	
	level waittill( "start_f35_snap" );
	wait (12);
	self thread play_f35_vtol_sounds();
}

init_heli_sounds_firescout() //self == jet
{
	self setup_heli_sounds( "turbine",	"engine",		"tag_origin",	"veh_fire_scout_run" );
	self setup_heli_sounds( "distant",	"engine",		"tag_origin",	"veh_fire_scout_run_dist" );
	self setup_heli_sounds( "close",	"engine",		"tag_origin",	"veh_fire_scout_run_close" );
	
}

init_heli_sounds_plane_x78() //self == jet
{
	self setup_heli_sounds( "steady",	"engine",		"tag_body",		"veh_osp_steady" );
	self setup_heli_sounds( "up",		"engine",		"tag_body",		"veh_osp_up" );
	self setup_heli_sounds( "down",		"engine",		"tag_body",		"veh_osp_down" );
}


init_heli_sounds_heli_osprey()
{
	self setup_heli_sounds( "steady",	"engine",		"tag_origin",		"veh_heli_osp_steady" );
	self setup_heli_sounds( "up",		"engine",		"tag_origin",		"veh_heli_osp_up" );
	self setup_heli_sounds( "down",		"engine",		"tag_origin",		"veh_heli_osp_down" );
	self setup_heli_sounds( "lfe",		"engine",		"tag_origin",		"veh_heli_osp_lfe" );	
}


init_heli_sounds_f35_la2() //self == jet
{
	self setup_heli_sounds( "forward",		"engine",		"tag_engine",		"veh_f35_la2_engine" );
}


init_heli_sounds_f35() //self == jet
{
	
	self setup_heli_sounds( "idle",		"engine",		"tag_engine",		"blk_f35_low_loop" );
	self setup_heli_sounds( "forward",		"engine",		"tag_engine",		"blk_f35_low_loop" );
	self setup_heli_sounds( "up",		"engine",		"tag_engine",		"blk_f35_high_loop" );
	self setup_heli_sounds( "lateral",	"engine",		"tag_engine",		"blk_f35_lateral_loop" );
}

init_heli_sounds_huey_toda() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hind_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hind_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_hind_tail" ); 			// Tail Rotor
	self setup_heli_sounds( "lfe",			"engine",		"snd_rotor",		"veh_hind_rotor_lfe" ); 	// Distant LFE	
	self setup_heli_sounds( "distant",		"engine",		"snd_rotor",		"veh_hind_run_dist" ); 		// Tail Rotor
}

init_heli_sounds_littlebird() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"TAG_BODY",			"veh_hind_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"main_rotor_jnt",	"veh_hind_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"tail_rotor_jnt",	"veh_hind_tail" ); 			// Tail Rotor
	self setup_heli_sounds( "lfe",			"engine",		"tag_main_rotor",	"veh_hind_rotor_lfe" ); 	// Distant LFE	
	self setup_heli_sounds( "distant",		"engine",		"tag_origin",		"veh_hind_run_dist" ); 		// Tail Rotor
}
init_heli_sounds_apache() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hind_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hind_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_hind_tail" ); 			// Tail Rotor
	self setup_heli_sounds( "lfe",			"engine",		"snd_rotor",		"veh_hind_rotor_lfe" ); 	// Distant LFE
	self setup_heli_sounds( "distant",		"engine",		"tag_origin",		"veh_hind_run_dist" ); 		// Tail Rotor	
}


init_heli_sounds_alouette() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_alouette_turbine" ); 	// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_alouette_rotor" ); 	// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_alouette_tail" ); 		// Tail Rotor
	self setup_heli_sounds( "lfe",			"engine",		"snd_rotor",		"veh_alouette_lfe" ); 	    // Distant LFE	
}

init_heli_sounds_huey() //self == helicopter
{
	self setup_heli_sounds( "cockpit",		"engine",		"snd_cockpit",		"veh_huey_whine_int_idle" );
	self setup_heli_sounds( "cockpit2",		"engine",		"snd_rotor",		"veh_huey_hf_int_idle" );
	self setup_heli_sounds( "int_eng",		"engine",		"snd_rotor",		"veh_huey_lf_int_idle" );
	self setup_heli_sounds( "int_eng2",		"engine",		"snd_tail_rotor",	"veh_huey_dist_idle" );
	self setup_heli_sounds( "int_eng3",		"engine",		"snd_wind_right",	"veh_huey_ringing_dist" );
	self setup_heli_sounds( "ext_rotor",	"engine",		"snd_wind_left",	"veh_huey_rotor_idle" );
}

init_heli_sounds_hind() //self == helicopter
{
	self setup_heli_sounds( "cockpit",		"engine",		"snd_cockpit",		"veh_hind_whine_int_idle" );
	self setup_heli_sounds( "cockpit2",		"engine",		"snd_cockpit",		"veh_hind_hf_int_idle" );
	self setup_heli_sounds( "int_eng",		"engine",		"snd_int_rotor",	"veh_hind_lf_int_idle" );
	self setup_heli_sounds( "int_eng2",		"engine",		"snd_int_rotor",	"veh_hind_dist_idle1" );
	self setup_heli_sounds( "ext_rotor",	"engine",		"snd_rotor",		"veh_hind_rotor_idle" );
	self setup_heli_sounds( "eng_dmg",		"engine",		"snd_int_rotor",	"veh_hind_sputter" );
	self setup_heli_sounds( "eng_dmg_alarm","engine",		"snd_cockpit",		"veh_hind_alarm_damage_high_loop" );	
}

init_heli_sounds_hip() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hip_turbine" );		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hip_rotor" );			// Top Rotor
	//self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_hip_tail" );			// Tail Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_rotor",		"veh_hip_tail" );			// Tail Rotor
	self setup_heli_sounds( "lfe",			"engine",		"snd_rotor",		"veh_hip_rotor_lfe" ); 	// Distant LFE	
}

init_heli_sounds_chinook() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"tag_origin",		"veh_chinook_turbine" );	// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"main_rotor_jnt",	"veh_chinook_rotor" );		// Top Rotor
	self setup_heli_sounds( "top_rotor",	"engine",		"tail_rotor_jnt",	"veh_chinook_rotor" );		// Top Rotor
	self setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_chinook_rotor_lfe" ); 	// Distant LFE
}

init_heli_sounds_hind_enemy() //self == helicopter     NEED ACTUAL BONES ON MODEL
{
	self setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_hind_epow_rotor_lfe" ); 	// Distant LFE
	self setup_heli_sounds( "turbine",		"engine",		"tag_origin",		"veh_hind_epow_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"tag_origin",		"veh_hind_epow_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"tag_origin",		"veh_hind_epow_tail" ); 		// Tail Rotor
	self setup_heli_sounds( "distant",		"engine",		"tag_origin",		"veh_hind_run_dist" ); 		// Tail Rotor
}

init_heli_sounds_hind_vorkuta() //tag, type, bone, run
{

//need bones added to LA2 helis, changes to tag origin for now
	self setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_hind_rotor_lfe" ); 	// Distant LFE
	self setup_heli_sounds( "turbine",		"engine",		"tag_origin",		"veh_hind_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"tag_origin",		"veh_hind_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"tag_origin",		"veh_hind_tail" ); 			// Tail Rotor
	self setup_heli_sounds( "distant",		"engine",		"tag_origin",		"veh_hind_run_dist" ); 		// Tail Rotor
}
init_heli_sounds_pavelow_la2() //tag, type, bone, run
{

//need bones added to LA2 helis, changes to tag origin for now
	self setup_heli_sounds( "turbine",		"engine",		"main_rotor_jnt",		"veh_pavelow_turbine" ); 		// Turbine
}

init_heli_sounds_huey_player() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		"snd_cockpit",		"veh_huey_rotor_lfe" ); 	//  Distant LFE
	setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_huey_turbine" ); 		//  Turbine
	setup_heli_sounds( "top_rotor",		"engine",		"snd_rotor",		"veh_huey_rotor" ); 		//  Top Rotor
	setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_huey_tail" ); 			//  Tail Rotor	
	setup_heli_sounds( "wind_rt",		"engine",		"snd_wind_right",	"veh_huey_door_wind"); 		//	Wind right
	setup_heli_sounds( "wind_lft",		"engine",		"snd_wind_left",	"veh_huey_door_wind"); 		//	Wind left  
	setup_heli_sounds( "radio",			"engine",		"snd_cockpit",		"veh_huey_radio"); 			//	radio cockpit  	
}



init_heli_sounds_player_drone_so() //tag, type, bone, run
{
	setup_heli_sounds( "turbine_idle",		"engine",		"tag_origin",		"veh_qrdrone_turbine_idle" ); 		// Turbine
	setup_heli_sounds( "turbine_moving",	"engine",		"tag_origin",		"veh_qrdrone_turbine_moving" ); 		// Turbine
	setup_heli_sounds( "turn",		        "engine",		 "tag_origin",		 "veh_qrdrone_idle_rotate" ); 		// Rotate angle
	self.warning_tag = "tag_origin";
}

init_heli_sounds_blackhawk() //tag, type, bone, run
{
	setup_heli_sounds( "turbine",		"engine",		"tag_origin",		"veh_bhawk_turbine" ); 		// Turbine
	setup_heli_sounds( "top_rotor",		"engine",		"tag_origin",		"veh_bhawk_rotor" ); 		// Top Rotor
	setup_heli_sounds( "tail_rotor",	"engine",		"tag_origin",		"veh_bhawk_tail" ); 		// Tail Rotor
	setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_bhawk_rotor_lfe" ); 	// Distant LFE
}

init_heli_sounds_osprey() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_osprey_rotor_lfe" ); 	// Distant LFE
	setup_heli_sounds( "turbine",		"engine",		"tag_origin",		"veh_osprey_turbine" ); 	// Turbine
	setup_heli_sounds( "top_rotor",		"engine",		"tag_origin",		"veh_osprey_rotor" ); 		// Top Rotor
}

init_heli_sounds_vtol() //tag, type, bone, run
{
	self setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_vtol_rotor_lfe" ); 	// Distant LFE
	self setup_heli_sounds( "turbine",		"engine",		"tag_origin",		"veh_vtol_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"tag_origin",		"veh_vtol_rotor" ); 		// Top Rotor
}

init_heli_sounds_heli_future() //tag, type, bone, run
{
	self setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_heli_future_lfe" ); 	// Distant LFE
	self setup_heli_sounds( "turbine",		"engine",		"snd_cockpit",		"veh_heli_future_turbine" ); 		// Turbine
	self setup_heli_sounds( "rotor",		"engine",		"snd_cockpit",		"veh_heli_future_rotor" ); 		// Rotor
}


setup_heli_sounds( bone_location, type, tag, run, dmg1, dmg2, dmg3, distanceCheck ) //self == helicopter
{
	self.heli[bone_location] = spawnStruct();
	self.heli[bone_location].sound_type = type;

	self.heli[bone_location].run = spawn( 0, self.origin, "script_origin" );
	self.heli[bone_location].run linkto( self, tag );
	self.heli[bone_location].run.alias = run;

	self.sound_ents[self.sound_ents.size] = self.heli[bone_location].run;
	level.delete_loop_sound_save_restore[level.delete_loop_sound_save_restore.size] = self.heli[bone_location].run;
	
	if (IsDefined(distanceCheck))
	{
		self thread delete_loop_distance ( self.heli[bone_location].run );
	}
	
	if( IsDefined( dmg1 ) )
	{
		self.heli[bone_location].dmg1 = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].dmg1 linkto( self, tag );
		self.heli[bone_location].dmg1.alias = dmg1;

		self.sound_ents[self.sound_ents.size] = self.heli[bone_location].dmg1;
		level.delete_loop_sound_save_restore[level.delete_loop_sound_save_restore.size] = self.heli[bone_location].dmg1;
	}
	if( IsDefined( dmg2 ) )
	{
		self.heli[bone_location].idle = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].idle linkto( self, tag );
		self.heli[bone_location].idle.alias = dmg2;

		self.sound_ents[self.sound_ents.size] = self.heli[bone_location].dmg2;
		level.delete_loop_sound_save_restore[level.delete_loop_sound_save_restore.size] = self.heli[bone_location].dmg2;
	}
	if( IsDefined( dmg3 ) )
	{
		self.heli[bone_location].idle = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].idle linkto( self, tag );
		self.heli[bone_location].idle.alias = dmg3;

		self.sound_ents[self.sound_ents.size] = self.heli[bone_location].dmg3;
		level.delete_loop_sound_save_restore[level.delete_loop_sound_save_restore.size] = self.heli[bone_location].dmg3;
	}
}

init_terrain_sounds() //self == helicopter
{
	self.surface_type = [];
	// dirt
	self.surface_type["default"]	= "dirt";
	self.surface_type["metal"]		= "dirt";
	self.surface_type["concrete"]	= "dirt";
	self.surface_type["wood"] 		= "dirt";
	self.surface_type["dirt"] 		= "dirt";
	self.surface_type["gravel"]		= "dirt";
	self.surface_type["grass"]		= "dirt";
	self.surface_type["mud"]		= "dirt";
	self.surface_type["snow"]		= "dirt";
	self.surface_type["asphalt"]	= "dirt";
	self.surface_type["brick"]		= "dirt";
	self.surface_type["glass"]		= "dirt";
	self.surface_type["plaster"]	= "dirt";
	self.surface_type["sand"]		= "dirt";
	self.surface_type["rock"]		= "dirt";
	// water
	self.surface_type["water"]		= "water";
	// foliage
	self.surface_type["foliage"]	= "dirt";
	//self.surface_type["foliage"]	= "foliage";

	// create ents
	self setup_terrain_sounds( "dirt",		"veh_chopper_prop_wash_dirt"	);
	self setup_terrain_sounds( "water",		"veh_chopper_prop_wash_water"	);
	//self setup_terrain_sounds( "foliage",	"veh_chopper_prop_wash_foliage"	);
	
}

setup_terrain_sounds( surface_type, alias ) //self == helicopter
{
	self.terrain_ent_array[surface_type] = spawn( 0, self.origin, "script_origin" );
	self.terrain_ent_array[surface_type].alias = alias;

	self thread terrain_loop_sound_delete( self.terrain_ent_array[surface_type] );
}

start_helicopter_sounds( localClientNum ) //self == helicopter
{
	//printLn( "^5 ********* in start_helicopter_sounds ***********" );

	if( IsDefined( self.vehicletype ) )
	{
		self.heli = [];
		self.terrain = [];
		self.sound_ents = [];
		self.cur_speed = 0;
		self.idle_run_trans_speed = 5; // in MPH

		play_terrain_sounds = false;
		switch( self.vehicletype )
		{
/*			case "zombie_cobra":
				self init_heli_sounds_huey();
				self play_huey_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
*/			
			case "heli_littlebird":	
				self init_heli_sounds_littlebird();
				self play_littlebird_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
			case "heli_apache":	
			case "heli_future":	
				self init_heli_sounds_apache();
				self play_apache_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;				
				
			case "plane_f35":
			//case "plane_f35_player":
				self init_heli_sounds_f35();
				self play_f35_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
				
				
			case "plane_f35_fast_la2":
			//case "plane_f35_player":
				self init_heli_sounds_f35_la2();
				self play_f35_la2_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
				
				
				
/*				
			case "plane_f35_player_vtol":
				self init_heli_sounds_f35();
				self play_f35_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;
*/
			case "plane_f35_vtol":
			case "plane_f35_player":
			case "plane_f35_player_vtol":
			case "plane_f35_player_vtol_dogfight":
			case "plane_f35_vtol_nocockpit":
			case "plane_fa38_hero":
				self thread init_heli_sounds_f35_vtol();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
				
				//blackout plane
			case "plane_fa38_prototype":
				//yemen osprey
			case "heli_v78_blackout":
			case "plane_x78":
			case "heli_v78":
			case "heli_v78_rts":				
			case "heli_v78_yemen":					
				self init_heli_sounds_plane_x78();
				self play_plane_x78_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;	
				
				//angola Helo
			case "heli_alouette":	
			case "heli_alouette_angola_river":				
				self init_heli_sounds_alouette();
				self play_alouette_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;		
				
			
			case "heli_huey_small":
				//firescout drone sounds
			case "drone_firescout":
			case "drone_firescout_allies":	
			case "drone_firescout_axis":
			case "drone_firescout_isi":
				self init_heli_sounds_firescout();
				self play_firescout_sounds();
				level.pitch_run_rate = .15;	
				break;
				
				
			// this the first wave heli in POW
			case "heli_huey_gunship":
				self init_heli_sounds_huey();
				self play_huey_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;				
/*
			// POW flyable 
			case "heli_hind_player":			
				self init_heli_sounds_hind();
				self play_hind_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
*/

			//The final POW heli
			case "heli_hind":	
			//BIG enemy choppers in POW
			case "heli_hind_doublesize":
			case "heli_hind_doublesize_uwb":
			//War mode hind
			case "heli_hind_so":

			case "heli_hind_river":
				self init_heli_sounds_hind_enemy();
				self play_hind_enemy_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
				
			//Afghanistan hinds
			case "heli_hind_afghan":
			case "hip_soviet":
			// this the first wave heli in POW
			case "heli_hip":
			case "heli_hip_afghan":
			case "heli_hip_afghanistan_land":
			//case "rebirth_heli_hip_sidegun_spotlight":
			//case "heli_hip_sidegun_spotlight":
			case "heli_hip_noseturret":
			case "heli_cobra":
			//case "heli_cobra_khesanh":
			//case "heli_hip_sidegun_uwb":			
				self init_heli_sounds_hip();
				self play_hip_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;				

			// this the heli Hue City
			case "heli_huey_assault":
			// Khe Sanh Huey's
			case "heli_huey":
			//case "heli_huey_usmc_heavyhog":
			case "heli_huey_usmc":
			//case "heli_huey_usmc_khesanh":
			case "heli_huey_side_minigun":
			case "heli_huey_player":
			//case "heli_huey_player_uwb":
			case "heli_huey_heavyhog_river":				
			case "heli_huey_assault_river":		
			case "heli_huey_gunship_river":		
			//case "heli_huey_usmc_khesanh_std":	
			case "heli_huey_medivac_khesanh":
			//case "heli_huey_usmc_heavyhog_khesanh":
			case "heli_huey_medivac_river":
			//case "heli_huey_side_minigun_uwb":
			case "heli_huey_vista":
			//Angola Hinds
			case "heli_hind_angola":
			//Pakistan heli
			case "heli_hind_pakistan":
			//River Hinds

			
				self init_heli_sounds_huey_toda();
				self play_huey_toda_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
			
			case "heli_chinook":
			case "heli_seaknight":
				self init_heli_sounds_chinook();
				self play_chinook_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
			
			//Creek Huey's
			//case "heli_huey_heavyhog_creek":
			//case "heli_huey_heavyhog":			
			//Vorkuta Hip
			//case "heli_hip_sidegun":
			//Rebith Heli
			//case "heli_hip_spotlight":
			// LA 2 helis
			case "heli_hip_so":
			case "heli_pavelow":
			case "heli_pavelow_la2":
				self init_heli_sounds_pavelow_la2();
				self play_pavelow_sounds_la2();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;			
				
			//rts heli_osprey
			case "heli_osprey":	
			case "heli_v78":
			case "heli_v78_rts":
			case "heli_v78_yemen_player":			
				self init_heli_sounds_heli_osprey();
				self play_heli_osprey_sounds();
				//self init_heli_sounds_hind_vorkuta();  OLD
				//self play_hind_sounds_vorkuta();  OLD
				self thread flying_booster_rotate_update();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
				
			case "heli_quadrotor":
				//self init_heli_sounds_player_drone();
				self play_player_drone_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
				
			case "heli_quadrotor_rts":
			case "heli_quadrotor_rts_player":
			case "heli_quadrotor_rtsafghan_player":
				self init_heli_sounds_player_drone_so();
				self play_player_drone_sounds_so();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;	
				

			// osprey -  osprey plane in Yemen

			case "plane_osprey":
				self init_heli_sounds_osprey();
				self play_osprey_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;		
				
			
			//jets that are covered in GDTs'
			case "drone_avenger_fast":
			case "drone_pegasus_fast":
			case "plane_f35_fast":		
				play_terrain_sounds = false;
				break;
				
			case "heli_blackhawk_stealth":
				self init_heli_sounds_blackhawk();
				self play_heli_sounds_blackhawk();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;							
				
			case "heli_vtol":
				self init_heli_sounds_vtol();
				self play_heli_sounds_vtol();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;
			
			case "heli_future_pakistan":
				self init_heli_sounds_heli_future();
				self play_heli_future_sounds();
				/#printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );#/
				break;	
				
			
				
			default:
				play_terrain_sounds = false;
				/#
				if( GetDvarint( "debug_heli" ) > 0 )
				{
					printLn( "^5helicopter type: " + self.vehicletype + " NOT FOUND; playing NO helicopter sounds" );
				}
				#/
				break;
		
		
		
		
		}

		if( play_terrain_sounds )
		{
			self init_terrain_sounds();
			self thread terrain_trace();
		}
	}
	else
	{
		/#printLn( "^6helicopter type: " + self.vehicletype + " not defined" );#/
	}
}
delete_loop_distance( real_ent ) //self == helicopter
{
	self endon( "heli_entityshutdown" );
	level endon( "save_restore" );
	self waittill( "outOfRange" );
	/#PrintLn( "heli_script: outOfRange" );#/
	
	if( IsDefined( real_ent ) )
	{
		/#PrintLn( "heli_script: killing DRONE sound ent" );#/
		ArrayRemoveValue( level.delete_loop_sound_save_restore, real_ent );
		real_ent StopLoopSound( 0 );
		real_ent Delete();
	}
}

delete_loop_sound_save_restore_watcher() 
{
	if (!IsDefined(level.delete_loop_sound_save_restore))
	{
		level.delete_loop_sound_save_restore=[];
	}
	while(1)
	{
		level waittill("save_restore");
		for (i=0;i<level.delete_loop_sound_save_restore.size;i++)
		{
			if( IsDefined( level.delete_loop_sound_save_restore[i]  ) )
			{
				/#PrintLn( "heli_script: killing helicopter sound ent" );#/
				level.delete_loop_sound_save_restore[i] StopLoopSound( 0 );
				level.delete_loop_sound_save_restore[i] Delete();
			}
		}
		level.delete_loop_sound_save_restore=[];
	}
}

terrain_loop_sound_delete( real_ent ) //self == helicopter
{
	level endon( "save_restore" );
	self waittill( "entityshutdown" );
	self notify( "heli_entityshutdown" );

	/#PrintLn( "heli_script: deleting terrain ents" );#/
	if( IsDefined( real_ent) )
	{
		real_ent StopLoopSound( 4 );
		real_ent Delete();
	}
}


heli_linkto_sound_ents_delete( localClientNum, entity )
{
	entity notify( "heli_entityshutdown" );
	array_thread( entity.sound_ents, ::heli_delete_sound_loops );
}

heli_delete_sound_loops() //self == linkto sound ents that are to be deleted
{
	/#PrintLn( "heli_script: deleting linkto ents" );#/

	if( IsDefined( self ) )
	{
		self StopLoopSound( 4 );
		self Delete();
	}
}
drone_delete_sound_loops() //self == linkto sound ents that are to be deleted
{
	/#PrintLn( "heli_script: deleting linkto ents" );#/

	if( IsDefined( self ) )
	{
		//self StopLoopSound( 4 );
		self Delete();
	}
}

// *************************************************	
// PLAY HELICOPTER SOUNDS SECTION
// This section plays the Helicopter sounds 
// heli_sound_play () - Starts a thread to play a loop unaffected by the entity speed
// heli_idle_run_transition () - Starts a thread that will pitch and volume the loop based on the arguments
// heli_bone - The tag to play the loop on, this is set to a bone in the init
// max_speed_vol - the speed at which volume will stop attenuation
// min_vol - This is the volume of the loop when not moving
// max_vol - This is the volume of the loop when at max_speed_vol
// max_speed_pitch - The speed at which pitch will no longer change
// min_pitch - This is the pitch of the loop when not moving
// max_pitch - This is the amount of pitch when at max_speed_vol
// *************************************************	
play_f35_sounds() // self == helicopter
{
	// ******* f35 sounds **************	
	//self thread heli_sound_play( self.heli["lfe"] ); // non-occulded, non-pitched 3d lfe
	
	self thread heli_idle_run_transition( "f35", "idle" );
	self thread heli_idle_run_transition( "f35", "forward" );
	self thread heli_idle_run_transition( "f35", "up" );
	self thread heli_idle_run_transition( "f35", "lateral" );	
}


play_f35_la2_sounds() // self == helicopter
{
	// ******* f35 sounds **************	
	//self thread heli_sound_play( self.heli["lfe"] ); // non-occulded, non-pitched 3d lfe
	
	self thread heli_idle_run_transition( "f35_la2", "forward" );

}


play_f35_vtol_sounds() // self == helicopter
{
	level endon( "save_restore" );
	self endon( "heli_entityshutdown" );

	wait (0.1);
	// ******* f35 Vtol player jet sounds **************	
	//self thread heli_idle_run_transition( "f35_vtol", "steady" );	
	self thread jet_idle_run_transition( "f35_vtol", "steady" );
	self thread jet_idle_run_transition( "f35_vtol", "steady_low" );
	self thread jet_idle_run_transition( "f35_vtol", "steady_hum" );
	self thread jet_turn_rattle_transition( "f35_vtol", "turn_rattle" );	
	self thread jet_turn_transition( "f35_vtol", "turn" );
	self thread jet_up_rattle_transition( "f35_vtol", "up_rattle" );
	self thread jet_up_transition( "f35_vtol", "up" );
	self thread jet_down_transition( "f35_vtol", "down" );	
	self thread jet_afterburn( "f35_vtol", "afterburn" );	
	self thread heli_sound_play( self.heli["telemetry"] );	
	//self thread jet_turn_whine( "f35_vtol", "turn_whine" );		
		
}

play_plane_x78_sounds() // self == helicopter
{
	// ******* Osprey Vtol jet sounds **************	
	self thread jet_idle_run_transition( "plane_x78", "steady" );	
	self thread jet_up_transition( "plane_x78", "up" );
	self thread jet_down_transition( "plane_x78", "down" );	
}


play_heli_osprey_sounds()
{
	self thread heli_sound_play( self.heli["lfe"] );
	self thread jet_idle_run_transition( "heli_osprey", "steady" );	
	self thread jet_up_transition( "heli_osprey", "up" );
	self thread jet_down_transition( "heli_osprey", "down" );	
}


play_hind_sounds() // self == helicopter
{
	// ******* heli Hind sounds **************
	//self thread heli_sound_play( self.heli["eng_dmg_alarm"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hind", "cockpit" );		 
	self thread heli_idle_run_transition( "hind", "cockpit2");  
	self thread heli_idle_run_transition( "hind", "int_eng");
	self thread heli_idle_run_transition( "hind", "int_eng2" );		 
//	self thread heli_idle_run_transition( "hind", "eng_dmg_alarm");  
	self thread heli_idle_run_transition( "hind", "ext_rotor");			
}

play_hind_enemy_sounds() // self == helicopter
{
	// ******* heli Hind sounds, this is the AI controled heli **************
	self thread heli_sound_play( self.heli["lfe"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hind_enemy", "turbine" );		 
	self thread heli_idle_run_transition( "hind_enemy", "top_rotor");  
	self thread heli_idle_run_transition( "hind_enemy", "tail_rotor");
	self thread heli_idle_run_transition( "hind_enemy", "distant" );	
}

play_firescout_sounds() // self == helicopter
{
	// ******* Firescout sounds **************	
		self thread heli_idle_run_transition( "drone_firescout", "turbine" );
		self thread heli_idle_run_transition( "drone_firescout", "close" );		
		self thread heli_idle_run_transition( "drone_firescout", "distant" );		
}

play_huey_sounds() // self == helicopter
{
	// ******* heli Huey sounds **************	
	self thread heli_sound_play( self.heli["lfe"] ); // non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey", "cockpit" );		 
	self thread heli_idle_run_transition( "huey", "cockpit2");  
	self thread heli_idle_run_transition( "huey", "int_eng");	
	self thread heli_idle_run_transition( "huey", "int_eng2" );		 
	self thread heli_idle_run_transition( "huey", "int_eng3");
	self thread heli_idle_run_transition( "huey", "ext_rotor" );		 
}

play_hip_sounds() // self == helicopter
{
	// ******* heli hip **************	
	self thread heli_sound_play( self.heli["lfe"] );		
	self thread heli_idle_run_transition( "hip", "turbine" );		 
	self thread heli_idle_run_transition( "hip", "top_rotor");  
	self thread heli_idle_run_transition( "hip", "tail_rotor");	
}


play_alouette_sounds() // self == helicopter
{
	// ******* heli hip **************	
	self thread heli_sound_play( self.heli["lfe"] );		
	self thread heli_idle_run_transition( "heli_alouette", "turbine" );		 
	self thread heli_idle_run_transition( "heli_alouette", "top_rotor");  
	self thread heli_idle_run_transition( "heli_alouette", "tail_rotor");	
}


play_huey_toda_sounds() // self == helicopter
{
	// ******* heli huey toada sounds, this is the AI controled heli in Hue City **************
	self thread heli_sound_play( self.heli["lfe"] );							// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey_toda", "turbine" );		 
	self thread heli_idle_run_transition( "huey_toda", "top_rotor");  
	self thread heli_idle_run_transition( "huey_toda", "tail_rotor");
	self thread heli_idle_run_transition( "huey_toda", "distant" );	
}

play_littlebird_sounds() // self == helicopter
{
	// ******* heli huey toada sounds, this is the AI controled heli in Hue City **************
	self thread heli_sound_play( self.heli["lfe"] );							// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey_toda", "turbine" );		 
	self thread heli_idle_run_transition( "huey_toda", "top_rotor");  
	self thread heli_idle_run_transition( "huey_toda", "tail_rotor");
	self thread heli_idle_run_transition( "huey_toda", "distant" );	
}
play_apache_sounds() // self == helicopter
{
	// ******* heli huey toada sounds, this is the AI controled heli in Hue City **************
	self thread heli_sound_play( self.heli["lfe"] );							// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey_toda", "turbine" );		 
	self thread heli_idle_run_transition( "huey_toda", "top_rotor");  
	self thread heli_idle_run_transition( "huey_toda", "tail_rotor");
	self thread heli_idle_run_transition( "huey_toda", "distant" );	
}
play_chinook_sounds()
{
	self thread heli_idle_run_transition( "heli_chinook", "top_rotor");  
	self thread heli_idle_run_transition( "heli_chinook", "turbine");
	self thread heli_sound_play( self.heli["lfe"] );	
}

play_hind_sounds_vorkuta() // self == helicopter
{
	//self thread heli_sound_play( self.heli["lfe"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hip", "turbine" );		 
	self thread heli_idle_run_transition( "hip", "top_rotor");  
	self thread heli_idle_run_transition( "hip", "tail_rotor");	
}

play_pavelow_sounds_la2() // self == helicopter
{
	//self thread heli_sound_play( self.heli["lfe"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "heli_pavelow_la2", "turbine" );		 
}

play_heli_sounds_huey_player() // self == helicopter
{
	// ******* heli Huey sounds, this is used on the hueys in underwaterbase  **************	
	self thread heli_sound_play( self.heli["lfe"] ); 
	self thread heli_sound_play( self.heli["radio"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey_player", "turbine" );		 
	self thread heli_idle_run_transition( "huey_player", "top_rotor");  
	self thread heli_idle_run_transition( "huey_player", "tail_rotor");	
	self thread heli_idle_run_transition( "huey_player", "wind_rt" );		 
	self thread heli_idle_run_transition( "huey_player", "wind_lft");  
}

play_player_drone_sounds() // self == Drone
{
	// ******* qrdrone **************
	self thread quad_idle_run_transition( "qrdrone", "turbine_idle","turbine_moving","distant","close", 0, .2 );		 
/*
	self thread heli_idle_run_transition( "qrdrone", "turbine_idle", 0, .2 );
	self thread heli_idle_run_transition( "qrdrone", "turbine_moving", 0, .2 );
	self thread heli_idle_run_transition( "qrdrone", "distant", 0, .2  );
	self thread heli_idle_run_transition( "qrdrone", "close", 0, .2  );	
*/
}

play_player_drone_sounds_so() // self == helicopter Cobra
{
	// ******* qrdrone **************
	self thread heli_idle_run_transition( "qrdrone_so", "turbine_idle", 1 );		 
	self thread heli_idle_run_transition( "qrdrone_so", "turbine_moving", 1 );		
	self thread drone_up_down_transition();
	self thread drone_rotate_angle( "qrdrone_so", "turn" );	
}

play_osprey_sounds() // self == helicopter
{
	// ******* heli Opsrey sounds, this is the AI controled Osprey plane **************
	self thread heli_idle_run_transition( "osprey", "turbine" );		 
	self thread heli_idle_run_transition( "osprey", "top_rotor");  
	self thread heli_sound_play( self.heli["lfe"] ); 																										// non-occulded, non-pitched 3d lfe
}
play_heli_sounds_vtol() // self == Drone
{
	// ******* qrdrone **************
	self thread heli_idle_run_transition( "vtol", "turbine" );		 
	self thread heli_idle_run_transition( "vtol", "top_rotor" );		 
}

play_heli_sounds_blackhawk() // self == helicopter
{
	// ******* blackhawks used in karma **************
	self thread heli_idle_run_transition( "blackhawk", "turbine" );		 
	self thread heli_idle_run_transition( "blackhawk", "top_rotor");  
	self thread heli_idle_run_transition( "blackhawk", "tail_rotor");	
	self thread heli_sound_play( self.heli["lfe"] );
}

play_heli_future_sounds()
{
	self thread heli_idle_run_transition( "heli_future", "turbine" );		 
	self thread heli_idle_run_transition( "heli_future", "rotor" );
	self thread heli_sound_play( self.heli["lfe"] ); 
}


// *************************************************
//	END OF PLAY HELICOPTER SOUNDS SECTION
// *************************************************

// *************************************************
//	HELICOPTER VOLUME/PITCH CHANGES
// *************************************************
heli_sound_play( heli_bone ) //self == helicopter
{
	self endon( "heli_entityshutdown" );
	self endon( "entityshutdown" );
	level endon( "save_restore" );

	if( !IsDefined(heli_bone) )
	{
		/#printLn( "AUDIO ERROR: Undefined call to  heli_sound_play( heli_bone ); " );#/
		return;
	}

	while( 1 )
	{
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			self waittill( "play_heli_sounds" );
		}

		heli_bone.run PlayLoopSound( heli_bone.run.alias, 2 );
		self waittill( "stop_heli_sounds" );
	}
}
init_heli_sounds_player_drone() //tag, type, bone, run
{
	setup_heli_sounds( "turbine_idle",		"engine",		"tag_origin",		"veh_qr_idle", undefined, undefined, undefined, true ); 		// Turbine
	setup_heli_sounds( "turbine_moving",	"engine",		"tag_origin",		"veh_qr_move", undefined, undefined, undefined, true ); 		// Turbine
	setup_heli_sounds( "distant",			"engine",		"tag_origin",		"veh_qr_distant", undefined, undefined, undefined, true ); 		// Turbine
	setup_heli_sounds( "close",				"engine",		"tag_origin",		"veh_qr_close", undefined, undefined, undefined, true ); 		// Turbine

}
quad_idle_run_transition( heli_type, heli_part1, heli_part2, heli_part3, heli_part4, updown, delay, distanceCheck ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	
	
	wait( RandomFloat( 0.5 ) );  
	
	self init_heli_sounds_player_drone();
	
	
	
	self.deletedFakeEnts = false;
		
	if ( !IsDefined( delay ) )
	{
		delay = .05;
	}
	if ( !IsDefined( updown ) )
	{
		updown = false;
	}
					
	const MPH_TO_INCHES_PER_SEC = 17.6;

	heli_bone1 = self.heli[heli_part1];
	heli_bone2 = self.heli[heli_part2];
	heli_bone3 = self.heli[heli_part3];
	heli_bone4 = self.heli[heli_part4];	
	
	run_id1 = undefined;
	run_id2 = undefined;
	//run_id3 = undefined; -- not used
	run_id4 = undefined;
	
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part1] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part1 + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part2] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part2 + "'." );#/
		return;
	}

	if( !IsDefined( level.heliSoundValues[heli_type][heli_part3] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part3 + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part4] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part4 + "'." );#/
		return;
	}
	
	last_speed = 0;
	
	while( IsDefined( self ) )
	{
		
		last_pos = self.origin[2];
		
		wait( 0.2 );

		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone1.run StopLoopSound( 0.5 );
			heli_bone2.run StopLoopSound( 0.5 );
			//heli_bone3.run StopLoopSound( 0.5 );
			heli_bone4.run StopLoopSound( 0.5 );
			run_id1 = undefined;
			run_id2 = undefined;
			//run_id3 = undefined;
			run_id4 = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}
		
		
		player = GetLocalPlayers()[0];
		playerDistance = DistanceSquared(self.origin, player.origin);
			
		if ( playerDistance > 1000 * 1000 )
		{
		    if (!self.deletedFakeEnts)
		    {
		    	//array_thread( self.sound_ents, ::drone_delete_sound_loops );
		    	//self notify ("outOfRange");
		    	//self.deletedFakeEnts = true;
		    	wait (.5);
		    }
		    
		}
		else
		{
			if (self.deletedFakeEnts)
			{
			    self init_heli_sounds_player_drone();
			    wait (.5);
			    self.deletedFakeEnts = false;
				run_id1 = heli_bone1.run PlayLoopSound( heli_bone1.run.alias, 0.5 );
				run_id2 = heli_bone2.run PlayLoopSound( heli_bone2.run.alias, 0.5 );
				self thread heli_sound_play( self.heli["close"] ); 			
			}
			
			
			if( !IsDefined( run_id1 ) )
			{
				run_id1 = heli_bone1.run PlayLoopSound( heli_bone1.run.alias, 0.5 );
				run_id2 = heli_bone2.run PlayLoopSound( heli_bone2.run.alias, 0.5 );
				self thread heli_sound_play( self.heli["distant"] ); 	
				self thread heli_sound_play( self.heli["close"] ); 			
			}
			
			self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
			
			if (last_speed !=self.cur_speed )
			{
				last_speed = self.cur_speed;
				//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
				run_volume1 = scale_speed( 0, 25, 0.8, 0.0, self.cur_speed );
				run_pitch1 = scale_speed( 0, 16, 9, 1.1, self.cur_speed );
				
				run_volume2 = scale_speed( 0, 25, 0.0, 1.0, self.cur_speed );
				run_pitch2 = scale_speed( 0, 25, .9, 1.1, self.cur_speed );
		
				//attenuate move loop volume when moving vertically
				updown = 0;
				if (updown)
				{
					
					self.qrdrone_z_difference = (last_pos - self.origin[2]);
					
					if (!isDefined (self.qrdrone_z_difference))
					{
						self.qrdrone_z_difference = 0;
					}
					
					run_volume_vertical = scale_speed( 0, 15, 0, 1, abs (self.qrdrone_z_difference) );
					
					run_volume_vertical_smooth = run_volume_vertical * run_volume_vertical * run_volume_vertical;
					
					run_volume1 = run_volume1 - run_volume_vertical_smooth;
					
					run_volume2 = run_volume2 + run_volume_vertical_smooth;
					
					//offloadprint = int(offloadprint*100);
					//printFakeRpm = int(fakeRpm);
					//print3d( self.origin + (0,0,-100) /*+ (AnglesToForward (self.angles) * 2000 )*/, "run_volume1- " + run_volume1,  (0.0, 0.8, 0.0), 1, 3, 1 );
					//print3d( self.origin /*+  (AnglesToForward (self.angles) * 2000 )*/, " run_volume2- " + run_volume2 ,  (0.0, 0.8, 0.0), 1, 3, 1 );					
				}
				
				
				if( IsDefined( run_volume1 ) && IsDefined( run_pitch1 ) )
				{
					setSoundVolume( run_id1, run_volume1 );
					setSoundPitch( run_id1, run_pitch1 );
					setSoundPitchRate( run_id1, level.pitch_run_rate );
	
					setSoundVolume( run_id2, run_volume2 );
					setSoundPitch( run_id2, run_pitch2 );
					setSoundPitchRate( run_id2, level.pitch_run_rate );

				}
			}
		}
/#			
		if( GetDvarint( "debug_heli" ) > 0 &&  IsDefined( run_volume1 ) && IsDefined( run_pitch1 ) )
		{
			printLn( "^5a self.cur_speed = " + self.cur_speed );
			printLn( "^5a run_pitch . " + run_pitch1 );			
			printLn( "^5a self.cur_speed = " + self.cur_speed );
			printLn( "^5a run_volume. " + run_volume1 );

		}
		#/
	}
}


heli_idle_run_transition( heli_type, heli_part, updown, delay ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	
	
	wait( RandomFloat( 0.5 ) );  
	
	if ( !IsDefined( delay ) )
	{
		delay = .05;
	}
	if ( !IsDefined( updown ) )
	{
		updown = false;
	}
					
	const MPH_TO_INCHES_PER_SEC = 17.6;

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}

	last_speed=0;
	
	while( IsDefined( self ) )
	{
		wait( delay );

		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			// MikeA: Restarting checkpoint in Paks at the bosses causes heli_bone.run
			if( !IsDefined(heli_bone.run) )
			{
				//IPrintLnBold( "HELI BONE PROBLEM" );
				return;
			}
			
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
		{
			// MikeA: Restarting checkpoint in Paks at the bosses causes heli_bone.run
			if( !IsDefined(heli_bone.run) )
			{
				//IPrintLnBold( "HELI BONE PROBLEM" );
				return;
			}
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );
		}

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
	
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
		
		if (last_speed!=self.cur_speed)
		{
			last_speed=self.cur_speed;
			//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
			run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
			run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );
	
			
			//attenuate move loop volume when moving vertically
			if (updown)
			{
				if (!isDefined (self.qrdrone_z_difference))
				{
					self.qrdrone_z_difference = 0;
				}
				
				run_volume_vertical = scale_speed( 5, 50, 0, 1, abs (self.qrdrone_z_difference) );
				
				run_volume = run_volume - run_volume_vertical;					
			}
			
			
			if( IsDefined( run_volume ) && IsDefined( run_pitch ) )
			{
				setSoundVolume( run_id, run_volume );
				setSoundPitch( run_id, run_pitch );
				setSoundPitchRate( run_id, level.pitch_run_rate );
				//setsoundvolumerate(run_id, 3);
			}
		}

		if( IsDefined ( self.isdamaged ) && ( heli_damage == "none"  ))
		{
			//heli_bone StopLoopSound( 1 );
			//dmg1_id = heli_bone PlayLoopSound( heli_bone.dmg1.alias, 0.5 );
			//heli_damage = "stage_1";
			return;
		}	
		
/#			
		if( GetDvarint( "debug_heli" ) > 0 &&  IsDefined( run_volume ) && IsDefined( run_pitch ) )
		{
			printLn( "^5a self.cur_speed = " + self.cur_speed );
			printLn( "^5a run_pitch . " + run_pitch );			
			printLn( "^5a self.cur_speed = " + self.cur_speed );
			printLn( "^5a run_volume. " + run_volume );

		}
		#/
	}
}

jet_afterburn( heli_type, heli_part ) //self == jet
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	
	
	level.sndVtolmode = true;
	
	const MPH_TO_INCHES_PER_SEC = 17.6;

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}

	while( IsDefined( self ) )
	{
		//level flag_wait( "snd_jet_start" );
				
		wait( 0.05 );

		if( level.sndVtolmode )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			level waittill( "snd_jet_start" );
			continue;
		}

		if( !IsDefined( run_id ) )
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
	
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
		
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );
		
		if( IsDefined( run_id ) )
		{
			setSoundVolume( run_id, run_volume );
		}

	}
}

jet_idle_run_transition( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	
	
	const MPH_TO_INCHES_PER_SEC = 17.6;

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}

	while( IsDefined( self ) )
	{
		wait( 0.05 );

		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
	
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
		
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );

		movement = self GetNormalizedCameraMovement();
	
		jet_stick_turn =  movement[1];
		
		if(jet_stick_turn <= 0 )
		{
			jet_stick_turn = (jet_stick_turn * -1);
		}
		jet_stick_pitch =  movement[0];
		
		if(jet_stick_pitch <= 0 )
		{
			jet_stick_pitch = (jet_stick_pitch * -1);
		}
		
		jet_stick_movement = jet_stick_turn + jet_stick_pitch;
		jet_stick_move_pitch = scale_speed( 0, 1.6, .5, 1.5, jet_stick_movement );
		
		//iprintlnbold (" jet_stick_movement = " + jet_stick_move_pitch);
		
		if( IsDefined( run_volume ) && IsDefined( run_pitch ) )
		{
			setSoundVolume( run_id, run_volume );
			setSoundPitch( run_id, run_pitch );
			setSoundPitchRate( run_id, level.pitch_run_rate );
			
			if( IsDefined ( self.isdamaged ) && ( heli_damage == "none"  ))
			{
				//heli_bone StopLoopSound( 1 );
				//dmg1_id = heli_bone PlayLoopSound( heli_bone.dmg1.alias, 0.5 );
				//heli_damage = "stage_1";
				return;
			}	
						
			/#
			if( GetDvarint( "debug_heli" ) > 0 )
			{
				printLn( "^5a self.cur_speed = " + self.cur_speed );
				printLn( "^5a run_pitch . " + run_pitch );			
				printLn( "^5a self.cur_speed = " + self.cur_speed );
				printLn( "^5a run_volume. " + run_volume );

			}
			#/
		}
	}
}
jet_turn_transition( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	
	
	const MPH_TO_INCHES_PER_SEC = 17.6;
	

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}

	while( IsDefined( self ) )
	{
				
		wait( 0.05 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
		
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
			
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );
		
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
		{
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );
		}

		angular_velocity = self.angles;
		
		turning_speed = abs( angular_velocity[2] / 90 );	
		
		jet_stick_vol = scale_speed ( 0, .7, 0, 1, turning_speed);
		jet_stick_pitch = scale_speed ( 0, .7, 1, 1.2, turning_speed);
		

		if( IsDefined( run_id ) && IsDefined( jet_stick_vol ) && IsDefined( jet_stick_pitch ))
		{
			setSoundVolumeRate ( run_id, .5 );
			setSoundVolume ( run_id, jet_stick_vol );
			setSoundPitch ( run_id, jet_stick_pitch );
			setSoundPitchRate( run_id, level.jet_stick_pitch_turn_rate );
		}
	}
}





jet_turn_rattle_transition( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	
	
	const MPH_TO_INCHES_PER_SEC = 17.6;
	

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}

	while( IsDefined( self ) )
	{
		
		
		wait( 0.05 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
		
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
			
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );
		
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
		{
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );
		}
	

		angular_velocity = self.angles;
		
		turning_speed = abs( angular_velocity[2] / 90 );	
		
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		jet_stick_vol = scale_speed ( 0, .7, 0, 1, turning_speed);
		jet_stick_pitch = scale_speed ( 0, .7, 1, 1.2, turning_speed);
		
//		if ( level.sndVtolmode )
//		{	
//			jet_stick_vol = 0;
//		}
		//iprintlnbold ( " Pitch angular_velocity[0] = " + angular_velocity[0] / 90 );		
		//iprintlnbold ( " Yaw angular_velocity[1] = " + angular_velocity[1] / 90 );
		//iprintlnbold ( " Roll angular_velocity[2] = " + angular_velocity[2] / 90);
		
		if( IsDefined( run_id ) && IsDefined( jet_stick_vol ) && IsDefined( jet_stick_pitch ))
		{
			setSoundVolumeRate ( run_id, .5 );
		//	setSoundVolume ( run_id, jet_stick_turn );
		//	setSoundVolume ( run_id, run_volume );			
		//	setSoundPitch( run_id, run_pitch );
			setSoundVolume ( run_id, jet_stick_vol );
			setSoundPitch ( run_id, jet_stick_pitch );
			setSoundPitchRate( run_id, level.jet_stick_pitch_turn_rate );
		}
	}
}





jet_down_transition( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	

	const MPH_TO_INCHES_PER_SEC = 17.6;	

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}
	
	
	while( IsDefined( self ) )
	{

		wait( 0.05 );
		
		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
		
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
			
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );

		
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
		{
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );
		}

		movement = self GetNormalizedCameraMovement();
		
		//iprintlnbold( " pitch = " + movement[0] );
		//iprintlnbold( " run_pitch = " + run_pitch );
		
		jet_stick_down =  movement[0];
		
		if(jet_stick_down <= 0 )
		{
			jet_stick_down = (jet_stick_down * -1);
		}
		else
		{
			jet_stick_down = 0;
		}
		
		//iprintlnbold( " down = " + jet_stick_down );

		jet_stick_down = scale_speed( 0, 1, 0.1, 1, jet_stick_down);
		
		//jet_stick_down_rate = .6;
		jet_stick_down_rate = level.jet_stick_down_rate;
		
		if( IsDefined( run_id ) && IsDefined( jet_stick_down ) )
		{
			setSoundVolumeRate ( run_id, jet_stick_down_rate );
			setSoundVolume( run_id, jet_stick_down );
			//setSoundVolume ( run_id, run_volume );					
			setSoundPitch( run_id, run_pitch );
			setSoundPitchRate( run_id, level.jet_stick_pitch_down_rate );			

		}
	}
}
jet_up_transition( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	

	const MPH_TO_INCHES_PER_SEC = 17.6;	

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}
	

	while( IsDefined( self ) )
	{
		wait( 0.05 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
		
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
			
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );
		
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
		{
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );
		}

		movement = self GetNormalizedCameraMovement();
		
		//iprintlnbold( " pitch = " + movement[0] );
		//iprintlnbold( " roll = " + movement[1] );
		
		jet_stick_up =  movement[0];
		
		if(jet_stick_up <= 0 )
		{
			jet_stick_up = 0;
		}
		
		jet_stick_up = scale_speed( 0, 1, 0.1, 1, jet_stick_up);
		
		//jet_stick_up_rate =.9;
		jet_stick_up_rate = level.jet_stick_up_rate;
		
		if( IsDefined( run_id ) && IsDefined( jet_stick_up ) )
		{
			setSoundVolumeRate ( run_id, jet_stick_up_rate );
			setSoundVolume( run_id, jet_stick_up );
			//setSoundVolume ( run_id, run_volume );		
			setSoundPitch( run_id, run_pitch );
			setSoundPitchRate( run_id, level.jet_stick_pitch_up_rate );			
	
		}
	}
}



jet_up_rattle_transition( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	

	const MPH_TO_INCHES_PER_SEC = 17.6;	

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}
	

	while( IsDefined( self ) )
	{
		wait( 0.05 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
		
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
			
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );
		
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;
			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
		{
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );
		}

		movement = self GetNormalizedCameraMovement();
		
		//iprintlnbold( " pitch = " + movement[0] );
		//iprintlnbold( " roll = " + movement[1] );
		
		jet_stick_up =  movement[0];
		
		if(jet_stick_up <= 0 )
		{
			jet_stick_up = 0;
		}
		
		jet_stick_up = scale_speed( 0, 1, 0.1, 1, jet_stick_up);
		
		//jet_stick_up_rate =.9;
		jet_stick_up_rate = level.jet_stick_up_rate;
		
		if( IsDefined( run_id ) && IsDefined( jet_stick_up ) )
		{
			setSoundVolumeRate ( run_id, jet_stick_up_rate );
			setSoundVolume( run_id, jet_stick_up );
			//setSoundVolume ( run_id, run_volume );		
			setSoundPitch( run_id, run_pitch );
			setSoundPitchRate( run_id, level.jet_stick_pitch_up_rate );			
	
		}
	}
}






jet_turn_whine( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
	
	const MPH_TO_INCHES_PER_SEC = 17.6;
	
	heli_bone = self.heli[heli_part];
	run_id = undefined;
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );#/
		return;
	}
	
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		/#printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );#/
		return;
	}

	while( IsDefined( self ) )
	{
		
	/*
		wait( 0.05 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
		
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
			
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );
	

	*/	
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
		{
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );
		}

		angular_velocity = self.angles;
		
		turning_speed = abs( angular_velocity[2] / 90 );		

		jet_stick_vol = scale_speed ( 0, 1, 0, 1, turning_speed);
		jet_stick_pitch = scale_speed ( 0, 1, .9, 1, turning_speed);
		
//		if ( level.sndVtolmode )
//		{	
//			jet_stick_vol = 0;
//		}
		//iprintlnbold ( " Pitch angular_velocity[0] = " + angular_velocity[0] / 90 );		
		//iprintlnbold ( " Yaw angular_velocity[1] = " + angular_velocity[1] / 90 ) ;
		//iprintlnbold ( " Roll angular_velocity[2] = " + angular_velocity[2] / 90) ;		
				
		if( IsDefined( run_id ) && IsDefined( jet_stick_vol ) )
		{
			setSoundVolumeRate ( run_id, .9 );
			setSoundVolume ( run_id, jet_stick_vol );			
			setSoundPitch( run_id, jet_stick_pitch );
			//setSoundPitchRate( run_id, .9 );			
		}
	}
}
// *************************************************	
// HELICOPTER TERRAIN SOUNDS (PROP WASH)
// *************************************************
terrain_trace() //self == helicopter
{
	self endon( "entityshutdown" ); 
	level endon( "save_restore" );

	trace = undefined; 
	trace_ent = self;

	pre_terrain = undefined;
	next_terrain = undefined;

	pre_trace_real_ent = undefined;
	trace_real_ent = undefined;
	pre_origin = ( 100000, 100000, 100000 );

	while( IsDefined( self ) )
	{
		wait( 1 + RandomFloatRange( 0.0, 0.2) );

		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			if( IsDefined( pre_trace_real_ent ) )
				pre_trace_real_ent StopLoopSound();

			if( IsDefined( trace_real_ent ) )
				trace_real_ent StopLoopSound();

			self waittill( "play_heli_sounds" );
			continue;
		}
		
		// do checks only if we moved more than a feet
		if( DistanceSquared( pre_origin, trace_ent.origin ) < 144 )
		{
			continue;
		}
			
		pre_origin = trace_ent.origin;

		trace = tracepoint( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ) );
		//println( "btrace " + trace_ent.origin );
		trace_surface_type = trace["surfacetype"];


		if( !IsDefined( trace ) )
			continue; 

		pre_terrain = next_terrain;
		next_terrain = trace_surface_type;
		if( !IsDefined( pre_terrain ) || !IsDefined( next_terrain ) )
		{
			//printLn( "heli_script: this is in non defined trerrain" );
			continue;
		}

		if( !IsDefined( self.surface_type[next_terrain] ) || !IsDefined( self.surface_type[pre_terrain] ) )
		{
			/#
			//printLn( "^6 prop wash for terrain type: " + next_terrain + " or " + pre_terrain + " is not set up" );
			#/
			continue;
		}

		surf_type = self.surface_type[next_terrain];
		trace_real_ent = self.terrain_ent_array[surf_type];

		pre_surf_type = self.surface_type[pre_terrain];
		pre_trace_real_ent = self.terrain_ent_array[pre_surf_type];

		if( !IsDefined( trace["position"] ) )
		{
			if( IsDefined( pre_trace_real_ent ) )
			{
				pre_trace_real_ent StopLoopSound( 0.5 );
				//printLn( "^5heli_script: STOP playing terrain sound (position undefined): " + pre_surf_type );
			}
			continue; 
		}

		//update origin
		trace_real_ent.origin = trace["position"];
		pre_trace_real_ent.origin = trace["position"];
		if( IsDefined( surf_type ) )
		{
			if( ( surf_type == pre_surf_type ) && ( pre_trace_real_ent IsPlayingLoopSound() ) )
				continue;

			//printLn( "^5heli_script: STOP playing terrain sound: " + pre_surf_type + " surface '" + pre_terrain + "'" );
			pre_trace_real_ent StopLoopSound( 0.5 );

			//printLn( "^6heli_script: START playing terrain sound: " + surf_type + " surface '" + next_terrain + "'" );
			trace_real_ent PlayLoopSound( trace_real_ent.alias, 0.5 );
		}
	}	
}

// *************************************************
// Update Helicopter Sounds
// *************************************************
update_helicopter_sounds() //self == helicopter
{
	//-- Setup the sound arrays in here
	if( IsDefined( self.engine_damage_low ) && self.engine_damage_low )
	{
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				if( !IsDefined( self.low_dmg ) )
				{
					self thread heli_idle_run_transition( "hind", "eng_dmg" ); 
				}
				self.low_dmg = true;
				playsound( 0, "veh_hind_alarm_damage_high", (0,0,0) );
				level.heliSoundValues["hind"]["cockpit"].volumeMax = 1;
				level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.3;
				/#printLn( "^5a activating heli sound damage stage 1");#/
				break;
			
			default:
				/#printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );#/
				break;
		}
	}

	if( IsDefined( self.engine_damage_high ) && self.engine_damage_high && IsDefined( self.engine_damage_low ) && !self.engine_damage_low )
	{
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				//level.heliSoundValues["hind"]["eng_dmg"].volumeMax = .5;
				//level.heliSoundValues["hind"]["eng_dmg"].volumeMin = .3;
				//level.heliSoundValues["hind"]["cockpit"].volumeMax = 1;
				//level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.3;
				//playsound( 0, "veh_hind_alarm_damage_high", (0,0,0) );

				// set up damage states
				level.heliSoundValues["hind"]["eng_dmg"].volumeMax = 1;
				level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.5;
				wait( 0.1 );
				level.heliSoundValues["hind"]["eng_dmg"].volumeMin = 1;
				// Play an alarm loop
				//self heli_sound_play( self.heli["eng_dmg_alarm"] );
				/#printLn( "^5a activating heli sound damage stage 2");#/
				break;
			
			default:
				/#printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );#/
				break;
		}
	}

	if( IsDefined( self.engine_damage_high ) && self.engine_damage_high && IsDefined( self.engine_damage_low ) && self.engine_damage_low )
	{
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				playsound( 0, "veh_hind_alarm_damage_high", (0,0,0) );
				level.heliSoundValues["hind"]["eng_dmg"].volumeMax = 1;
				level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.5;
				wait( 0.1 );
				level.heliSoundValues["hind"]["eng_dmg"].volumeMin = 1;
				/#printLn( "^5a activating heli sound damage stage 3");#/
				break;
			
			default:
				/#printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );#/
				break;
		}
	}
	
	if( IsDefined( self.engine_damage_low ) && !self.engine_damage_low && IsDefined( self.engine_damage_high ) && !self.engine_damage_high )
	{
		/#printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; Atempting to reset Defaults" );#/
		
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				init_heli_sound_values( "hind", "cockpit", 			95, 0.6, 0.8, 95, 1, 1.1 );
				init_heli_sound_values( "hind", "cockpit2",			95, 0.5, 0.8, 95, 1, 1.2);
				init_heli_sound_values( "hind", "int_eng", 			65, 0.5, 0.8, 65, 1, 1.1 );
				init_heli_sound_values( "hind", "int_eng2",			65, 0.4, 0.9, 65, 1, 1.3 );
				init_heli_sound_values( "hind", "eng_dmg", 			40, 0.2, 0.4, 65, 1, 1.1 );
				init_heli_sound_values( "hind", "ext_rotor",		70, 0.5, 1, 70, 0.95, 1.1);
				//self.heli["eng_dmg"] stoploopsound( 1 );
				/#printLn( "^5a Setting Defaults ");#/
				break;
				
			default:
				/#printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );#/
				break;
		}
	}
}
veh_throttle()
{
	
//	if (self.vehicletype != "apc_cougar_player" )
//	{
		return;
//	}
		
vehicle = self;

self.idle = spawn( 0, self.origin, "script_origin" );
self.idle linkto( self, "tag_origin" );

self.offidle = spawn( 0, self.origin, "script_origin" );
self.offidle linkto( self, "tag_origin" );
		
self.onlow = spawn( 0, self.origin, "script_origin" );
self.onlow linkto( self, "tag_origin" );
		
self.offlow = spawn( 0, self.origin, "script_origin" );
self.offlow linkto( self, "tag_origin" );

self.onmid = spawn( 0, self.origin, "script_origin" );
self.onmid linkto( self, "tag_origin" );

self.offmid = spawn( 0, self.origin, "script_origin" );
self.offmid linkto( self, "tag_origin" );

self.onhigh = spawn( 0, self.origin, "script_origin" );
self.onhigh linkto( self, "tag_origin" );

self.offhigh = spawn( 0, self.origin, "script_origin" );
self.offhigh linkto( self, "tag_origin" );
		
//playDriveSounds ( sound, fadeInstart, startfullThreshold, endFullThreshold, fadeOutEnd  )		

idle = self.idle PlayLoopSound ( "blk_car_idle_plr" ,1);
self thread playDriveSounds  ( idle, -1, 0, .16, .274, true, .133 );

offidle = self.offidle PlayLoopSound ( "blk_car_idle_plr" ,1);
self thread playDriveSounds  ( offidle, -1, 0, .16, .274, false, .133 );

onlow = self.onlow PlayLoopSound ( "blk_car_onlow_plr" ,1);
setSoundVolume ( onlow, 0 );		
self thread playDriveSounds ( onlow, .16, .274, .38, .55, true, .343);    //end at .55

offlow = self.offlow PlayLoopSound ( "blk_car_offlow_plr" ,1);
setSoundVolume ( offlow, 0 );	
self thread playDriveSounds ( offlow, .16, .274, .38, .55, false, .343);    //end at .55

onmid = self.onmid PlayLoopSound ( "blk_car_onmid_plr" ,1);
setSoundVolume ( onmid, 0 );	
self thread playDriveSounds ( onmid, .38, .55, .71, .84, true, .459  );

offmid = self.offmid PlayLoopSound ( "blk_car_offmid_plr" ,1);
setSoundVolume ( offmid, 0 );	
self thread playDriveSounds ( offmid, .38, .55, .71, .84, false, .459  );

onhigh = self.onhigh PlayLoopSound ( "blk_car_onhigh_plr" ,1);
setSoundVolume ( onhigh, 0 );	
//self thread playDriveSounds ( onhigh, .71, .84, .99, 1.1, true, .684 );
self thread playDriveSounds ( onhigh, .71, .84, 1.4, 1.5, true, .684 );
//

offhigh = self.offhigh PlayLoopSound ( "blk_car_offhigh_plr" ,1);
setSoundVolume ( offhigh, 0 );	
self thread playDriveSounds ( offhigh, .71, .84, 1.4, 1.5, false, .684 );

}
playDriveSounds ( sound, fadeInstart, startfullThreshold, endFullThreshold, fadeOutEnd, onload, throttlePitchRef  )
{

	const onloadFadein = .562;
	const onloadFadeOut = .433;
	const offloadFadein = .534;
	const offloadFadeOut = .433;	
	const idlePoint = .14;
	//time = 1; -- all references were commented out
	//a = 1 - 5.18 / time / 30;
	loadSmoothing = .04;
	throttleSmoothing = .025;
	
	currentLoadSmoothing = .04;
	currentThrottleSmoothing = .025;	
	
	throttle = 0;
	loadFilter = 0;
	load = 0;
	globalVolume = 0;		
	const rpmRedline = 9000;
//	idleRpm = 1100; -- currently not used
	maxSpeed = 1500;
	self.onground = true;

	speedPercentage = 1;
	throttlePercentage = 1;
	
	onloadPrint = 0;
	offloadPrint = 0;

	//testing
	//onloadFadein = .662;
	//onloadFadeOut = .333;
	//offloadFadein = .634;
	//offloadFadeOut = .333;		
	
	//currentGear = 1;
	//nextgear = 2;
	//shiftpoint = 4500;
	
	//upShift = false;
	//downShift = false;
	currentGear = 1;
	//shiftPoint = 3500; --not used
	const maxGear = 7;
	nextGear = 2;
	upshiftPoint= 2200;
	downshiftPoint = 1300;
	//downGear = 1;	

	throttleSmoothingStart = throttleSmoothing;
	
	usesGears = true;
	
	while (1)
	{
		wait(.0000001);	
		

		throttleInput = self GetThrottle();

		if ( self iswheelcolliding( "back_left" ) && self iswheelcolliding( "back_right" ) )
		{
			self.onground = true;
			throttleSmoothing = currentThrottleSmoothing;
			loadSmoothing = currentLoadSmoothing;		
	
			currentLoadSmoothing = throttleSmoothing;
	
			currentLoadSmoothing = loadSmoothing;
	
		}
		else
		{
			self.onground = false;
			loadSmoothing = .08;
			throttleSmoothing = .040;
		
		
			throttleSmoothing = currentThrottleSmoothing * 2;
			loadSmoothing = currentLoadSmoothing * 2;		
		

			throttleInput = throttleInput + .15;
		}

	//currentLoadSmoothing = .04;
	//currentThrottleSmoothing = .025;			
		
		fakeRpm = scale_speed ( 0, 1, 0, rpmRedline,  throttle);

		if (usesGears)
		{
			if ( fakeRpm > upshiftPoint && currentGear + 1 == nextGear && currentGear != maxGear) //&& throttleToSpeed > 1 )
			{
				//upShift = true;
		
				//downGear = currentGear;
				currentGear = currentGear + 1;
				nextGear = currentGear + 1;
				
				//Testing upshiftPoint
				//downshiftPoint = upshiftPoint;
				downshiftPoint = upshiftPoint - 1000;
				
				upshiftPoint = 5000 + ((currentGear * 1000)/2);
				
				//currentLoadSmoothing = loadSmoothing  * (currentGear / 2 ) ;
				currentThrottleSmoothing = throttleSmoothingStart + (currentGear * .002 ) ;		
	
				//throttleInput = throttleInput - .25;
				
				throttleInput = 0;
				
				//iprintlnbold ("UpShift");			
				
			}
			else if ( fakeRpm < downshiftPoint && currentGear != 1 ) // && throttleToSpeed < 1 )
			{
	
				currentGear = currentGear - 1;
				upshiftPoint = 5000 + ((currentGear * 1000)/2);
				downshiftPoint = upshiftPoint - 1000;	
				
				nextGear = currentGear + 1;
				
				//currentLoadSmoothing = loadSmoothing * (currentGear * 2 ) ;
				currentThrottleSmoothing = throttleSmoothingStart  - (currentGear * .002 )  ;	
				
				//iprintlnbold ("DownShift");							
				
			}
			else
			{
				loadSmoothing = currentLoadSmoothing;
				throttleSmoothing = currentThrottleSmoothing;
			
//				loadmod = 0; -- not used
			}		
		}
		
		curspeed = self GetSpeed();
		maxSpeed = self GetMaxSpeed();
		speedRatio = int(((curspeed / maxSpeed) * 100) * throttle);
	
		previousThrottle = throttle;
		throttle = throttle * (1 - throttleSmoothing) + throttleInput * throttleSmoothing;
		loadFilter = loadFilter * (1 - loadSmoothing) + (throttle - previousThrottle) * loadSmoothing;

		// converts load to .5 default banding from 0 1
		load = 10 * loadFilter + .5;

		// this is the idle value.
		if (throttle < idlePoint)
		{
			throttle = idlePoint;
		}

		// this makes pitch a constant between samples and locks it to the fake rpm range
		sound_pitch = throttle / throttlePitchRef;

		crossFadein = scale_speed ( fadeInstart, startfullThreshold, 0, 1, throttle);
		crossFadeout = scale_speed ( endFullThreshold, fadeOutEnd, 1, 0, throttle);
		
		speedPercentage = scale_speed ( 0, maxSpeed, 1, 100,  curspeed);
		throttlePercentage = scale_speed ( .14, 1, 1, 100,  throttle);
		
		throttleToSpeed = (speedPercentage / throttlePercentage);
	
		if (onload)
		{
			globalVolume = scale_speed ( onloadFadeOut, onloadFadein, 0, 1, load);
			onloadPrint = globalVolume;
		}
		else
		{
			globalVolume = scale_speed ( offloadFadeOut, offloadFadein, .6, 0, load);
			offloadPrint = globalVolume;
		}

		fadeVolume = 0.0;
		
		if (throttle >= fadeInstart && throttle <= startfullThreshold )
		{
			fadeVolume = Sin( crossFadein * 90  );
		}
		else if (throttle >= startfullThreshold && throttle <= endFullThreshold)
		{
			fadeVolume = 1.0;
		}
		else if (throttle >= endFullThreshold && throttle <= fadeOutEnd )
		{
			fadeVolume =  Sin( crossFadeOut * 90 );
		}
		
		setSoundPitch( sound, sound_pitch ); 
		setSoundVolume( sound, fadeVolume * (globalVolume * globalVolume * globalVolume) );

		/#
		//time = GetTime ();
		//println ( "SND_FILTER," + time + "," + sound +"," + crossFadein +","+ fadeVolume+","+ globalVolume);
		printThrottle = int(throttle*1000);
		printLoad = int(load*1000);
		printCurspeed =int(curspeed);
		onloadPrint = int(onloadPrint*100);
		offloadprint = int(offloadprint*100);
		printFakeRpm = int(fakeRpm);
		print3d( self.origin + (0,0,-100) + (AnglesToForward (self.angles) * 2000 ), "SPEED- " + printCurspeed + " SPEED RATIO- " + speedRatio ,  (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (AnglesToForward (self.angles) * 2000 ), "LOAD- " + printLoad + " THROTTLE- " + printThrottle ,  (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (0,0,100) + (AnglesToForward (self.angles) * 2000 ), "FAKE RPM- " + printFakeRpm  + " GEAR " + currentGear,  (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (0,0,200) + (AnglesToForward (self.angles) * 2000 ), "ONGROUND- " + self.onground ,  (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (0,0,300) + (AnglesToForward (self.angles) * 2000 ), "THROTTLE/SPEED- " + throttleToSpeed ,  (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (0,0,400) + (AnglesToForward (self.angles) * 2000 ), "SPEED%- " + speedPercentage ,  (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (0,0,500) + (AnglesToForward (self.angles) * 2000 ), "THROTTLE%- " + throttlePercentage ,  (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (0,0,600) + (AnglesToForward (self.angles) * 2000 ), "ONVOL- " + onloadPrint,   (0.0, 0.8, 0.0), 1, 3, 1 );
		print3d( self.origin + (0,0,700) + (AnglesToForward (self.angles) * 2000 ), "OFFVOL- " + offloadprint ,  (0.0, 0.8, 0.0), 1, 3, 1 );
		#/
	}
}


drone_up_down_transition()
{
	self endon( "entityshutdown" );

	const volumerate = 1;
	
	qr_ent_up = Spawn( 0, self.origin, "script_origin" );
	qr_ent_down = Spawn( 0, self.origin, "script_origin" );
	qr_ent_either = Spawn( 0, self.origin, "script_origin" );
	
	qr_ent_up thread qr_ent_cleanup(self);
	qr_ent_down thread qr_ent_cleanup(self);
	qr_ent_either thread qr_ent_cleanup(self);
	
	self.qrdrone_z_difference = 0;
	
	down = qr_ent_down playloopsound ("veh_qrdrone_move_down");
	setSoundVolume( down, 0 );

	
	up = qr_ent_up playloopsound ("veh_qrdrone_move_up");
	setSoundVolume( up, 0 );	
	
		
	either = qr_ent_either playloopsound ("veh_qrdrone_vertical");
	setSoundVolume( either, 0 );	
	
	
	tag = "tag_origin";
	qr_ent_up linkto (self, tag);
	qr_ent_down linkto (self, tag);
	qr_ent_either linkto (self, tag);
	
	
	//self thread drone_button_watch("BUTTON_RSHLDR");
	//self thread drone_button_watch("BUTTON_LSHLDR");
	self thread drone_button_watch();
	
	while(1)
	{
		last_pos = self.origin[2];
		wait (.1);
		//curr_pos = self.origin[2];
		
		self.qrdrone_z_difference = (last_pos - self.origin[2]);
		
		if ( self.qrdrone_z_difference < 0)
		{
			up_difference = self.qrdrone_z_difference * -1;
			run_volume_up = scale_speed( 5, 40, 0, 1, up_difference );
			run_pitch_up = scale_speed( 5, 40, .9, 1.1, up_difference );
			
			run_volume_either = scale_speed( 5, 50, 0, 1, up_difference );
			run_pitch_either = scale_speed( 5, 50, .9, 1.1, up_difference );
		}
		else
		{
			run_volume_up = 0;
			run_pitch_up = 0;
			
			run_volume_either = scale_speed( 5, 50, 0, 1, self.qrdrone_z_difference );
			run_pitch_either = scale_speed( 5, 50, .95, .8, self.qrdrone_z_difference );
		}
		
		run_volume_down = scale_speed( 5, 50, 0, 1, self.qrdrone_z_difference );
		run_pitch_down = scale_speed( 5, 50, 1, .8, self.qrdrone_z_difference );
		
		
		setSoundVolumeRate (up, volumerate);
		setSoundVolumeRate (down, volumerate);	
		setSoundVolumeRate (either, volumerate);
		
		setSoundVolume( up, run_volume_up );
		setSoundPitch( up, run_pitch_up );
		setSoundVolume( down, run_volume_down );	
		setSoundPitch( down, run_pitch_down );		
		
			
		setSoundVolume( either, run_volume_either );	
		setSoundPitch( either, run_pitch_either );	
	}
}


qr_ent_cleanup(veh_ent)
{
	veh_ent waittill ("entityshutdown");
	self delete();
}


drone_rotate_angle( heli_type, heli_part ) //self == drone
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
	
	const volumerate = 2.5;
	
	qr_ent_angle = Spawn( 0, self.origin, "script_origin" );
	qr_ent_angle thread qr_ent_cleanup (self);
	
	angle = qr_ent_angle playloopsound ("veh_qrdrone_idle_rotate");
	setSoundVolume( angle, 0 );
	
	tag = "tag_origin";
	qr_ent_angle linkto (self, tag);

	
	while( 1 )
	{
		
		last_angle = abs( self.angles[1] );

		wait (.1);
		
	 	turning_speed =  last_angle - abs( self.angles[1] );
	 	
	 	abs_turning_speed = abs(turning_speed);
	 	
	 	

	 	jet_stick_vol = scale_speed ( 0, 5, 0, .4, abs_turning_speed);
		jet_stick_pitch = scale_speed ( 0, 4, .9, 1.05, abs_turning_speed);	
		
		setSoundVolumeRate (angle, volumerate);		
		setSoundVolume ( angle, jet_stick_vol );			
		setSoundPitch ( angle, jet_stick_pitch );		

	}
}



drone_button_watch()
{
	self endon( "entityshutdown" );
	
	player = getlocalplayers()[0];
	return_to_zero= true;
	/#println (self.qrdrone_z_difference);#/
	while (1)
	{
		if ( abs (self.qrdrone_z_difference) > 5 && return_to_zero)
		{
			self playsound (0, "veh_qrdrone_move_start");
			return_to_zero = false;
			
			/*
			while (abs (level.difference) > 10)
			{
				wait (.05);
			}
			
			check_speed = scale_speed( 5, 50, 0, 1, level.difference );
			while (check_speed < .1)
			{
				wait (.05);
				check_speed = scale_speed( 5, 50, 0, 1, level.difference );
			}
			*/
			
		}
		
		else if (abs (self.qrdrone_z_difference) < 5 && !return_to_zero )
		{
			return_to_zero = true;
		}
		wait (.05);
	}
}


flying_booster_rotate_update()
{
	self endon( "entityshutdown" );
	level endon( "save_restore" ); 
	
	const max_speed = 1200;
	
	left_anim = %vehicles::veh_anim_v78_vtol_engine_left;
	right_anim = %vehicles::veh_anim_v78_vtol_engine_right;
	
	self SetAnim( left_anim, 1, 0, 0 );
	self SetAnim( right_anim, 1, 0, 0 );
	
	prev_yaw = self.angles[1];
	delta_yaw = 0;
	
	while( 1 )
	{
		speed = self GetSpeed();
		anim_time = 0.5;
		if( speed > 0 )
		{
			anim_time -= ( speed / max_speed ) * 0.5;
		}
		else
		{
			anim_time += ( -speed / max_speed ) * 0.5;
		}
		
		frame_delta_yaw = AngleClamp180( self.angles[1] - prev_yaw ) / 3;
		frame_delta_yaw = ( frame_delta_yaw < 0.1 ? 0 : frame_delta_yaw );
			
		delta_yaw = AngleClamp180( delta_yaw + (frame_delta_yaw - delta_yaw) * 0.1 );
		delta_yaw = clamp( delta_yaw, -0.1, 0.1 );
		
		prev_yaw = self.angles[1];
		
		left_anim_time = clamp( anim_time + delta_yaw, 0, 1 );
		right_anim_time = clamp( anim_time - delta_yaw, 0, 1 );
		
		self SetAnimTime( left_anim, left_anim_time );
		self SetAnimTime( right_anim, right_anim_time );
		
		wait 0.01;
	}
}



