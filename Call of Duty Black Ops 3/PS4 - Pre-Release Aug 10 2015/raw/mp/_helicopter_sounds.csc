#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\clientfield_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\_helicopter_sounds;
#using scripts\mp\_util;

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

#namespace helicopter_sounds;

function autoexec __init__sytem__() {     system::register("helicopter_sounds",&__init__,undefined,undefined);    }

function __init__()
{
	//clientfield::register("vehicle", "vehicle_is_firing", VERSION_SHIP, 1, "int",&vehicle_is_firing_function, CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);
	//clientfield::register("helicopter", "vehicle_is_firing", VERSION_SHIP, 1, "int",&vehicle_is_firing_function, CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);
	//clientfield::register("actor", "player_is_gunner", VERSION_SHIP, 1, "int",&chppoer_gunner_loop, CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);	
	
	level._entityShutDownCBFunc = &helicopter_sounds::heli_linkto_sound_ents_delete;
	level.heliSoundValues = [];
	
	//						 heli_type, part_type, 		max_speed_vol, 	min_vol, 	max_vol, 	max_speed_pitch, 	min_pitch, 	max_pitch 
	
	init_heli_sound_values( "cobra", "turbine", 		65, 			0.6,		0.8, 		65, 				1, 			1.1 );		
	init_heli_sound_values( "cobra", "top_rotor",		45,				0.7, 		1, 			45, 				0.95, 		1.1); 	
	init_heli_sound_values( "cobra", "tail_rotor", 		45,				0.5, 		1, 			45, 				0.95, 		1.1); 

	init_heli_sound_values( "hind", "turbine", 			65,				0.6, 		0.8, 		65, 				1, 			1.1 );		
	init_heli_sound_values( "hind", "top_rotor",		45,				0.7, 		1, 			45, 				0.95, 		1.1); 	
	init_heli_sound_values( "hind", "tail_rotor", 		45, 			0.5, 		1, 			45, 				0.95, 		1.1); 	

	init_heli_sound_values( "supply", "turbine", 	    65, 			0.7, 		1,	 		65, 				1, 			1.1 );		
	init_heli_sound_values( "supply", "top_rotor",		35, 			0.95, 		1, 			100, 				1, 			1.1	); 	
	init_heli_sound_values( "supply", "tail_rotor", 	35, 			0.95, 		1, 			45, 				1, 			1.1	); 	

	init_heli_sound_values( "huey", "turbine", 			65,				0.7, 		0.8, 		65, 				1, 			1.1 );		
	init_heli_sound_values( "huey", "top_rotor",		45, 			0.8, 		1, 			45, 				0.95, 		1.1); 	
	init_heli_sound_values( "huey", "tail_rotor", 		45, 			0.6, 		1, 			45, 				0.95, 		1.0); 	
	init_heli_sound_values( "huey", "wind_rt", 			45, 			0.6, 		1, 			45, 				0.95, 		1.0); 	
	init_heli_sound_values( "huey", "wind_lft", 		45, 			0.6, 		1, 			45, 				0.95, 		1.0); 	

	init_heli_sound_values( "qrdrone", "turbine_idle", 	30, 			0.8, 		0.0, 		16, 				.9, 		1.1 );		
	init_heli_sound_values( "qrdrone", "turbine_moving",30, 			0.0, 		0.9, 		20, 				.9, 		1.1 );		
	init_heli_sound_values( "qrdrone", "turn",		    5, 			     0, 		 1,	 		 1, 				1, 			1 );
	
	init_heli_sound_values( "heli_guard", "turbine", 	10, 			0.9, 		1, 			30, 				.9, 		1.05 );		
	init_heli_sound_values( "heli_guard", "rotor",      10, 			0.9, 		1, 			30, 				.9, 		1.1 );		
	

/#
	if ( GetDvarString( "helisounds" ) == "" )
	{
		SetDvar( "helisounds", "" );
	}

	level thread command_parser();
#/
}
/*chppoer_gunner_loop(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if (newVal == 0)
	{
		audio::playloopat("mpl_cgunner_flir_lp", (0,0,0));
	}
	else
	{
		audio::stoploopat ("mpl_cgunner_flir_lp", (0,0,0));
	}
}
*/
function vehicle_is_firing_function(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	/# println("vehicle is firing : " + newVal); #/
		
	if (newVal == 0)
	{
		self.isFiring = false;
	}
	else
	{
		self.isFiring = true;	
	}
	
}


function init_heli_sound_values( heli_type, part_type, max_speed_vol, min_vol, max_vol, max_speed_pitch, min_pitch, max_pitch )
{
	if ( !isdefined( level.heliSoundValues[heli_type] ) )
	{
		level.heliSoundValues[heli_type] = [];
	}
	if ( !isdefined( level.heliSoundValues[heli_type][part_type] ) )
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
function command_parser()
{
	while(1)
	{
		command = GetDvarString( "helisounds" );
		if ( command != "" )
		{
			success = true;
			tokens = strtok( command, " " );
			if ( !isdefined( tokens[0] ) || !isdefined(level.heliSoundValues[tokens[0]]) )
			{
				if ( isdefined( tokens[0] ) )
					println("helisounds Did not recognize helicopter type:  " + tokens[0] );
				else
					println("helisounds Did not recognize helicopter type" );
					
					
				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				
				success = false;
			}	
//			else if ( !isdefined( tokens[1] )|| !isdefined(level.heliSoundValues[heli_type][tokens[1]]))
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
#/

function init_heli_sounds_gunner() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		"snd_cockpit",		"veh_huey_rotor_lfe" ); 	//  Distant LFE
	setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_huey_turbine" ); 		//  Turbine
	setup_heli_sounds( "top_rotor",		"engine",		"snd_rotor",		"veh_huey_rotor" ); 		//  Top Rotor
	setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_huey_tail" ); 			//  Tail Rotor	
	setup_heli_sounds( "wind_rt",		"engine",		"snd_wind_right",	"veh_huey_door_wind"); 		//	Wind right
	//setup_heli_sounds( "wind_lft",		"engine",		"snd_wind_left",	"veh_huey_door_wind"); 		//	Wind left  
	setup_heli_sounds( "radio",			"engine",		"snd_cockpit",		"veh_huey_radio"); 			//	radio cockpit  	
	self.warning_tag = "snd_cockpit";
}

function init_heli_sounds_player_controlled() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		"snd_cockpit",		"veh_cobra_rotor_lfe" ); 	// Distant LFE
	setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_cobra_turbine" ); 		// Turbine
	setup_heli_sounds( "top_rotor",		"engine",		"snd_rotor",		"veh_cobra_rotor" ); 		// Top Rotor
	setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_cobra_tail" ); 		// Tail Rotor	
	self.warning_tag = "snd_cockpit";
}

function init_heli_sounds_supply() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		undefined,		"veh_supply_rotor_lfe" ); 	// Distant LFE
	setup_heli_sounds( "turbine",		"engine",		undefined,		"veh_supply_turbine" ); 	// Turbine
	setup_heli_sounds( "top_rotor",		"engine",		undefined,		"veh_supply_rotor" ); 		// Top Rotor
	self.warning_tag = undefined;
}

function init_heli_sounds_ai_attack() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		undefined,		"veh_hind_rotor_lfe" ); 	// Distant LFE
	setup_heli_sounds( "turbine",		"engine",		undefined,		"veh_hind_turbine" ); 		// Turbine
	setup_heli_sounds( "top_rotor",		"engine",		undefined,		"veh_hind_rotor" ); 		// Top Rotor
	setup_heli_sounds( "tail_rotor",	"engine",		undefined,		"veh_hind_tail" ); 			// Tail Rotor

	self.warning_tag = undefined;
}

function init_heli_sounds_player_drone() //tag, type, bone, run
{
	setup_heli_sounds( "turbine_idle",		"engine",		"tag_body",		"veh_qrdrone_turbine_idle" ); 		// Turbine
	setup_heli_sounds( "turbine_moving",	"engine",		"tag_body",		"veh_qrdrone_turbine_moving" ); 	// Turbine
	setup_heli_sounds( "turn",		        "engine",		"tag_body",		"veh_qrdrone_idle_rotate" ); 		// Rotate angle
	self.warning_tag = undefined;
}

function init_heli_sounds_heli_guard() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		undefined,		"veh_overwatch_lfe" ); 	// Distant LFE
	setup_heli_sounds( "turbine",		"engine",		undefined,		"veh_overwatch_turbine" ); 		// Turbine
	setup_heli_sounds( "rotor",			"engine",		undefined,		"veh_overwatch_rotor" ); 		// Rotor
	self.warning_tag = undefined;
}


function sound_linkto( parent, tag )
{
	if( isdefined( tag ) )
		self linkto( parent, tag );
	else 
		self linkto( parent, "tag_body" );
}

function setup_heli_sounds( bone_location, type, tag, run, dmg1, dmg2, dmg3 )
{
	self.heli[bone_location] = spawnStruct();
	self.heli[bone_location].sound_type = type;
	
	self.heli[bone_location].run = spawn( 0, self.origin, "script_origin" );
	self.heli[bone_location].run sound_linkto( self, tag );
	self.heli[bone_location].run.alias = run;

	self thread heli_loop_sound_delete( self.heli[bone_location].run );

	if( isdefined( dmg1 ) )
	{
		self.heli[bone_location].idle = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].idle sound_linkto( self, tag );
		self.heli[bone_location].idle.alias = dmg1;

		self thread heli_loop_sound_delete( self.heli[bone_location].dmg1 );
	}
	if( isdefined( dmg2 ) )
	{
		self.heli[bone_location].idle = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].idle sound_linkto( self, tag );
		self.heli[bone_location].idle.alias = dmg2;

		self thread heli_loop_sound_delete( self.heli[bone_location].dmg2 );
	}
	if( isdefined( dmg3 ) )
	{
		self.heli[bone_location].idle = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].idle sound_linkto( self, tag );
		self.heli[bone_location].idle.alias = dmg3;

		self thread heli_loop_sound_delete( self.heli[bone_location].dmg3 );
	}
}

function init_terrain_sounds()
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

function setup_terrain_sounds( surface_type, alias ) //self == helicopter
{
	self.terrain_ent_array[surface_type] = spawn( 0, self.origin, "script_origin" );
	self.terrain_ent_array[surface_type].alias = alias;

	self thread heli_loop_sound_delete( self.terrain_ent_array[surface_type] );
}
function setup_terrain_brass_sounds( surface_type, alias ) //self == helicopter
{
	self.terrain_brass_ent_array[surface_type] = spawn( 0, self.origin, "script_origin" );
	self.terrain_brass_ent_array[surface_type].alias = alias;

	self thread heli_loop_sound_delete( self.terrain_brass_ent_array[surface_type] );
}
function start_helicopter_sounds( localClientNum )
{
	//printLn( "^5 ********* in start_helicopter_sounds ***********" );

	if( isdefined( self.sounddef  ) )
	{
		self.heli = [];
		self.terrain = [];
		self.sound_ents = [];
		self.cur_speed = 0;
		self.mph_to_inches_per_sec = 17.6;
		self.speed_of_wind = 20;//40; // in MPH
		self.idle_run_trans_speed = 5; // in MPH

		switch( self.sounddef )
		{
			// cobra_mp - Default Attack heli - Cobra
			case "veh_heli_ai_mp":
				//self init_heli_sounds_ai_attack();
				//self play_attack_ai_sounds();
				break;
			
			// Overwatch - killstreak heli				
			case "veh_heli_guard_mp":	
				//self init_heli_sounds_heli_guard();
				//self play_heli_guard_sounds();
				break;
				
			// heli_supplydrop_mp -  Supply drop killstreak heli - Chinoock
			case "veh_heli_supplydrop_mp":
				//self init_heli_sounds_supply();
				//self play_supply_sounds();
				break;				

			// heli_gunner_mp - is the player gunner killstreak  - Huey
			case "veh_heli_gunner_mp":			
				//self init_heli_sounds_gunner();
				//self play_gunner_sounds();
				break;

			// heli_player_controlled_mp - is the player helicopter killstreak - hind
			case "veh_heli_player_gunner_mp":
				//self init_heli_sounds_player_controlled();
				//self play_player_controlled_sounds();
				break;
			
			case "veh_drn_qrdrone_mp":
				//self init_heli_sounds_player_drone();
				//self play_player_drone_sounds();
				break;

			default:
			/#	printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; playing no helicopter sounds" );	#/
				break;
		}
		self init_terrain_sounds();
		self thread terrain_trace();
		//print for debug
		/#
		if( GetDvarint( "debug_heli" ) > 0 )
		{
			iprintLnbold( "helicopter type: " + self.vehicletype + " vehicletype" );		
		}
		#/
	}
	else
	{
	/#	printLn( "^6start_helicopter_sounds(): helicopter type not defined" );	#/
	}
}

function heli_loop_sound_delete( real_ent )
{
	self waittill( "entityshutdown" );
	real_ent Unlink();
	//wait (3);
	real_ent StopAllLoopSounds( 4 );
	real_ent delete();
}

function heli_linkto_sound_ents_delete( localClientNum, entity )
{
	entity notify( "entityshutdown" );
}

function heli_sound_play( heli_bone )
{
	switch( heli_bone.sound_type )
	{
		case "engine":
			heli_bone.run playloopsound( heli_bone.run.alias, 2 );
			break;
		case "wind":
			break;
		default:
		/#	printLn( "^6 unknown helicopter type: " + heli_bone.type + " expecting \"wind\" or \"engine\"");	#/
			break;
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
function play_player_controlled_sounds() // self == helicopter Cobra
{
	// ******* heli Cobra sounds, this is the player controled mp heli **************
	self heli_sound_play( self.heli["lfe"] ); 																										// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "cobra", "turbine" );		 
	self thread heli_idle_run_transition( "cobra", "top_rotor");  
	self thread heli_idle_run_transition( "cobra", "tail_rotor");	
}

function play_attack_ai_sounds() // self == helicopter
{
	// ******* heli Hind sounds, this is the AI controled mp heli **************
	self heli_sound_play( self.heli["lfe"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hind", "turbine" );		 
	self thread heli_idle_run_transition( "hind", "top_rotor");  
	self thread heli_idle_run_transition( "hind", "tail_rotor");	
}

function play_supply_sounds() // self == helicopter
{
	// ******* heli Chinoock sounds, this is the AI controled mp supply helicopter **************
	self thread heli_idle_run_transition( "supply", "turbine" );		 
	self thread heli_idle_run_transition( "supply", "top_rotor");  
	self heli_sound_play( self.heli["lfe"] ); 																										// non-occulded, non-pitched 3d lfe
}

function play_gunner_sounds() // self == helicopter
{
	// ******* heli Huey sounds, this is the AI controled mp gunner helicopter, player hangs out side and fires **************	
	self heli_sound_play( self.heli["lfe"] ); 
	self heli_sound_play( self.heli["radio"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey", "turbine" );		 
	self thread heli_idle_run_transition( "huey", "top_rotor");  
	self thread heli_idle_run_transition( "huey", "tail_rotor");	
	self thread heli_idle_run_transition( "huey", "wind_rt" );		 
	//self thread heli_idle_run_transition( "huey", "wind_lft");  
}

function play_player_drone_sounds() // self == helicopter Cobra
{
	// ******* qrdrone **************
	//self thread heli_idle_run_transition( "qrdrone", "turbine_idle", 0.1, 1 );		 
	//self thread heli_idle_run_transition( "qrdrone", "turbine_moving", 0.1, 1 );		
	//self thread drone_up_down_transition();
	//self thread drone_rotate_angle( "qrdrone", "turn" );	
}

function play_heli_guard_sounds()
{
	self heli_sound_play( self.heli["lfe"] ); 
	self thread heli_idle_run_transition( "heli_guard", "turbine" );		 
	self thread heli_idle_run_transition( "heli_guard", "rotor" );
	self thread terrain_trace_brass ();
	//self thread tempBrassNotify ();
}
/*
function tempBrassNotify ()
{
	while (1)
	{
		level waittill ("isfir");
		self.isfiring = true;
		level waittill ("nofir");
		self.isfiring = false;
	}
}
*/	
// *************************************************
//	END OF PLAY HELICOPTER SOUNDS SECTION
// *************************************************

// *************************************************
//	HELICOPTER VOLUME/PITCH CHANGES
// *************************************************
function heli_idle_run_transition( heli_type, heli_part, wait_time, updown )
{
	self endon( "entityshutdown" );
	
	heli_bone = self.heli[heli_part];
	
	run_id = heli_bone.run playloopsound( heli_bone.run.alias, 0.5 );

	if (!isdefined( wait_time ) )
		wait_time = 0.5;
		
	while( isdefined( self ) )
	{
		//audio::scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		if( !isdefined( level.heliSoundValues[heli_type] ) || !isdefined( level.heliSoundValues[heli_type][heli_part] ) )
		{
		/#	printLn( "^5a speed vol/pitch parameter was not defined." );	#/
			return;
		}

		max_speed_vol = level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol = level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol = level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch = level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch = level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch = level.heliSoundValues[heli_type][heli_part].pitchMax;
	
		/*
		self.cur_speed = abs (self getspeed()) / self.mph_to_inches_per_sec;
		*/
		
		plr_vel = self getvelocity();
		self.cur_speed = abs (sqrt (VectorDot (plr_vel,plr_vel)) ) / self.mph_to_inches_per_sec;
		
		
		run_volume = audio::scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = audio::scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );

		
		//attenuate move loop volume when moving vertically
		if (isdefined(updown))
		{
			if (!isdefined (self.qrdrone_z_difference))
			{
				self.qrdrone_z_difference = 0;
			}
			
			run_volume_vertical = audio::scale_speed( 5, 50, 0, 1, abs (self.qrdrone_z_difference) );
			
			run_volume = run_volume - run_volume_vertical;					
		}
		
		
		
		if( isdefined( run_volume ) && isdefined( run_pitch ) )
		{
			//run_volume = 1;
			//run_pitch = 1;
			
			//setSoundVolume( run_id, run_volume );
			//setSoundPitch( run_id, run_pitch );
			//setSoundPitchRate( run_id, 0.15 );
			heli_bone.run setloopstate(heli_bone.run.alias, run_volume, run_pitch, 1, .15);
			
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

		wait( wait_time );
	}
}
// *************************************************	
// HELICOPTER BRASS ON GROUND SOUNDS 
// *************************************************
function terrain_trace_brass()
{
	self endon( "entityshutdown" ); 

	self setup_terrain_brass_sounds( "dirt",		"prj_brass_loop_dirt"	);
	self setup_terrain_brass_sounds( "water",		"prj_brass_loop_water"	);
	
	self.isFiring = false;
	
	trace = undefined; 
	trace_ent = self;

	pre_terrain = undefined;
	next_terrain = undefined;

	pre_trace_real_ent = undefined;
	trace_real_ent = undefined;
	pre_origin = ( 100000, 100000, 100000 );

	while( isdefined( self ) )
	{
		wait( 1 + RandomFloatRange( 0.0, 0.2) );

		// do checks only if we moved more than a feet
		if( DistanceSquared( pre_origin, trace_ent.origin ) < 144 )
		{
			continue;
		}

		pre_origin = trace_ent.origin;

		trace = tracepoint( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ) );
		//println( "btrace " + trace_ent.origin );
		trace_surface_type = trace["surfacetype"];

		if( !isdefined( trace ) )
			continue; 

		pre_terrain = next_terrain;
		next_terrain = trace_surface_type;
		if( !isdefined( pre_terrain ) || !isdefined( next_terrain ) )
		{
			//printLn( "heli_script: this is in non defined trerrain" );
			continue;
		}

		if( !isdefined( self.surface_type[next_terrain] ) || !isdefined( self.surface_type[pre_terrain] ) )
		{
			/#
			//printLn( "^6 prop wash for terrain type: " + next_terrain + " or " + pre_terrain + " is not set up" );
			#/
			continue;
		}

		surf_type = self.surface_type[next_terrain];
		trace_real_ent = self.terrain_brass_ent_array[surf_type];

		pre_surf_type = self.surface_type[pre_terrain];
		pre_trace_real_ent = self.terrain_brass_ent_array[pre_surf_type];

		if( !isdefined( trace["position"] ) )
		{
			if( isdefined( pre_trace_real_ent ) )
			{
				pre_trace_real_ent StopAllLoopSounds( 0.5 );
				//printLn( "^5heli_script: STOP playing terrain sound (position undefined): " + pre_surf_type );
			}
			continue; 
		}
		if (!self.isFiring)
		{
			pre_trace_real_ent StopAllLoopSounds( 0.5 );
		}
		//update origin
		trace_real_ent.origin = trace["position"];
		pre_trace_real_ent.origin = trace["position"];
		if( isdefined( surf_type ) && self.isFiring )
		{
			if( ( surf_type == pre_surf_type ) && ( pre_trace_real_ent IsPlayingLoopSound() ) )
				continue;

			//printLn( "^5heli_script: STOP playing terrain sound: " + pre_surf_type + " surface '" + pre_terrain + "'" );
			pre_trace_real_ent StopAllLoopSounds( 0.5 );

			//printLn( "^6heli_script: START playing terrain sound: " + surf_type + " surface '" + next_terrain + "'" );
			trace_real_ent PlayLoopSound( trace_real_ent.alias, 0.75 );
		}
	}	
}

// *************************************************	
// HELICOPTER TERRAIN SOUNDS (PROP WASH)
// *************************************************
function terrain_trace()
{
	self endon( "entityshutdown" ); 

	trace = undefined; 
	trace_ent = self;

	pre_terrain = undefined;
	next_terrain = undefined;

	pre_trace_real_ent = undefined;
	trace_real_ent = undefined;
	pre_origin = ( 100000, 100000, 100000 );

	while( isdefined( self ) )
	{
		wait( 1 + RandomFloatRange( 0.0, 0.2) );

		// do checks only if we moved more than a feet
		if( DistanceSquared( pre_origin, trace_ent.origin ) < 144 )
		{
			continue;
		}

		pre_origin = trace_ent.origin;

		trace = tracepoint( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ) );
		//println( "btrace " + trace_ent.origin );
		trace_surface_type = trace["surfacetype"];

		if( !isdefined( trace ) )
			continue; 

		pre_terrain = next_terrain;
		next_terrain = trace_surface_type;
		if( !isdefined( pre_terrain ) || !isdefined( next_terrain ) )
		{
			//printLn( "heli_script: this is in non defined trerrain" );
			continue;
		}

		if( !isdefined( self.surface_type[next_terrain] ) || !isdefined( self.surface_type[pre_terrain] ) )
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

		if( !isdefined( trace["position"] ) )
		{
			if( isdefined( pre_trace_real_ent ) )
			{
				pre_trace_real_ent StopAllLoopSounds( 0.5 );
				//printLn( "^5heli_script: STOP playing terrain sound (position undefined): " + pre_surf_type );
			}
			continue; 
		}

		//update origin
		trace_real_ent.origin = trace["position"];
		pre_trace_real_ent.origin = trace["position"];
		if( isdefined( surf_type ) )
		{
			if( ( surf_type == pre_surf_type ) && ( pre_trace_real_ent IsPlayingLoopSound() ) )
				continue;

			//printLn( "^5heli_script: STOP playing terrain sound: " + pre_surf_type + " surface '" + pre_terrain + "'" );
			pre_trace_real_ent StopAllLoopSounds( 0.5 );

			//printLn( "^6heli_script: START playing terrain sound: " + surf_type + " surface '" + next_terrain + "'" );
			trace_real_ent PlayLoopSound( trace_real_ent.alias, 0.5 );
		}
	}	
}

function aircraft_dustkick(localClientNum)
{

/#	printLn( "^stated aircraft_dustkick" );	#/
	self endon( "entityshutdown" ); 
		
	maxHeight = 1200; 
	minHeight = 350; 

	if ( self.vehicletype == "qrdrone_mp" )
	{
		maxHeight =	120; 
		minHeight = 1; 
	}
	
	slowestRepeatWait = 0.15; 
	fastestRepeatWait = 0.05; 

	numFramesPerTrace = 3; 
	doTraceThisFrame = numFramesPerTrace; 

	defaultRepeatRate = 1.0; 
	repeatRate = defaultRepeatRate; 

	trace = undefined; 
	d = undefined; 

	trace_ent = self; 

	while( isdefined( self ) )
	{
		if( repeatRate <= 0 )
		{
			repeatRate = defaultRepeatRate; 
		}

		if (!util::server_wait( localClientNum, repeatRate ))
		{	// wait failed, we may have rewinded
			continue;
		}
		
		if( !isdefined( self ) )
		{
			return; 
		}
		
		doTraceThisFrame -- ; 


		if( doTraceThisFrame <= 0 )
		{
			doTraceThisFrame = numFramesPerTrace; 

			trace = bullettrace( trace_ent.origin, trace_ent.origin -( 0, 0, 100000 ), false, trace_ent ); 
			 /* 
			trace["entity"]
			trace["fraction"]
			trace["normal"]
			trace["position"]
			trace["surfacetype"]
			 */ 

			d = distance( trace_ent.origin, trace["position"] ); 

			repeatRate = ( ( d - minHeight ) /( maxHeight - minHeight ) ) *( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait; 
		}

		if( !isdefined( trace ) )
		{
			continue; 
		}

		assert( isdefined( d ) ); 

		if( d > maxHeight )
		{
			repeatRate = defaultRepeatRate;
			continue; 
		}

		if( isdefined( trace["entity"] ) )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( !isdefined( trace["position"] ) )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( !isdefined( trace["surfacetype"] ) )
		{
			trace["surfacetype"] = "dirt"; 
		}
		
		//-- Glocke (12/16/2008) converted to prints from asserts while I come up with a better solution with Laufer
		if ( !IsDefined( self.treadfxnamearray ) || !isdefined( self.treadfxnamearray[trace["surfacetype"]] ) )
		{
			/#
			if ( isdefined( self.vehicletype ) )
			{
				println("SCRIPT PRINT: Unknown surface type " + trace["surfacetype"] + " for vehicle type " + self.vehicletype);
			}
			else
			{
				println("SCRIPT PRINT: Unknown surface type " + trace["surfacetype"] + " for vehicle of undefined vehicletype" );
			}
			#/
			return;
		}
		//assert( isdefined( vehicle.treadfxnamearray[trace["surfacetype"]] ), "UNKNOWN SURFACE TYPE: " + trace["surfacetype"] ); 

		 
		if( isdefined( self.treadfxnamearray[trace["surfacetype"]] ) )
		{
				//printLn( "^6this is defaulting dirt" );
				//println("SCRIPT PRINT: Unknown surface type " + trace["surfacetype"] + " for vehicle type " + self.vehicletype);				
			playfx( localClientNum, self.treadfxnamearray[trace["surfacetype"]], trace["position"] );
			//print3d( trace["position"], "+" + self.treadfxnamearray[trace["surfacetype"]], ( 0, 1, 0 ), 1, 3, 30 ); 
		}
	}	
}

function play_targeting_sound( play, sound, handle )
{
	sound_ent = get_lock_sound_ent();
	if ( play )
	{
		 return sound_ent PlayLoopSound ( sound );
	}
	else if ( isdefined(handle) )
	{
		sound_ent StopAllLoopSounds( 0.1 );
		return undefined;
	}
}

function play_targeted_sound( play )
{
	self.lockingSound = play_targeting_sound( play,  "veh_hind_alarm_missile_locking_mp", self.lockingSound );
}

function play_locked_sound(play)
{
	self.lockedSound = play_targeting_sound( play,  "veh_hind_alarm_missile_locked_mp", self.lockedSound );
}

function play_fired_sound(play)
{
	self.firedSound = play_targeting_sound( play,  "veh_hind_alarm_missile_fired", self.firedSound );
}

function play_leaving_battlefield_alarm(play)
{
	sound_ent = get_leaving_sound_ent();
	if ( play )
	{
		 self.leavingBattlefieldSound = sound_ent PlayLoopSound ( "veh_helicopter_alarm" );
	}
	else if ( isdefined(self.leavingBattlefieldSound) && self.leavingBattlefieldSound )
	{
		sound_ent StopAllLoopSounds( 0.1 );
	}
}

function get_heli_sound_ent( sound_ent )
{
	if ( !isdefined(sound_ent)) 
	{
		tag = "tag_origin";
		if ( isdefined(self.warning_tag) )
		{
			tag = self.warning_tag;
		}
		sound_ent = spawn( 0, self GetTagOrigin( tag ), "script_origin" );
		sound_ent linkto( self, tag );
	
		self thread heli_sound_ent_delete( sound_ent );
	}
	
	return sound_ent;
}

function get_lock_sound_ent()
{
	self.lock_sound_ent = get_heli_sound_ent( self.lock_sound_ent );
	
	return self.lock_sound_ent;
}

function get_leaving_sound_ent()
{
	self.leaving_sound_ent = get_heli_sound_ent( self.leaving_sound_ent );
	
	return self.leaving_sound_ent;
}

function heli_sound_ent_delete( real_ent )
{
	self waittill( "entityshutdown" );
	real_ent StopAllLoopSounds( 0.1 );
	real_ent delete();
}



function drone_up_down_transition()
{
	self endon( "entityshutdown" );

	volumerate = 1;
	
	qr_ent_up = spawn( 0, self.origin, "script_origin" );
	qr_ent_down = spawn( 0, self.origin, "script_origin" );
	qr_ent_either = spawn( 0, self.origin, "script_origin" );
	
	qr_ent_up thread qr_ent_cleanup(self);
	qr_ent_down thread qr_ent_cleanup(self);
	qr_ent_either thread qr_ent_cleanup(self);
	
	self.qrdrone_z_difference = 0;
	
	down = qr_ent_down playloopsound ("veh_qrdrone_move_down");
	//setSoundVolume( down, 0 );
	qr_ent_down setloopstate("veh_qrdrone_move_down", 0, 0);
	
	
	up = qr_ent_up playloopsound ("veh_qrdrone_move_up");
	//setSoundVolume( up, 0 );	
	qr_ent_up setloopstate("veh_qrdrone_move_up", 0, 0);
	
		
	either = qr_ent_either playloopsound ("veh_qrdrone_vertical");
	//setSoundVolume( either, 0 );	
	qr_ent_either setloopstate("veh_qrdrone_vertical", 0, 0);
	
	
	tag = "tag_body";
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
			run_volume_up = audio::scale_speed( 5, 40, 0, 1, up_difference );
			run_pitch_up = audio::scale_speed( 5, 40, .9, 1.1, up_difference );
			
			run_volume_either = audio::scale_speed( 5, 50, 0, 1, up_difference );
			run_pitch_either = audio::scale_speed( 5, 50, .9, 1.1, up_difference );
		}
		else
		{
			run_volume_up = 0;
			run_pitch_up = 1;
			
			run_volume_either = audio::scale_speed( 5, 50, 0, 1, self.qrdrone_z_difference );
			run_pitch_either = audio::scale_speed( 5, 50, .95, .8, self.qrdrone_z_difference );
		}
		
		run_volume_down = audio::scale_speed( 5, 50, 0, 1, self.qrdrone_z_difference );
		run_pitch_down = audio::scale_speed( 5, 50, 1, .8, self.qrdrone_z_difference );
		
		/*
		setSoundVolumeRate (up, volumerate);
		setSoundVolumeRate (down, volumerate);	
		setSoundVolumeRate (either, volumerate);
		
		setSoundVolume( up, run_volume_up );
		setSoundPitch( up, run_pitch_up );
		setSoundVolume( down, run_volume_down );
		setSoundPitch( down, run_pitch_down );
		
		setSoundVolume( either, run_volume_either );	
		setSoundPitch( either, run_pitch_either );	
		*/
		
		qr_ent_down setloopstate("veh_qrdrone_move_down", run_volume_down, run_pitch_down, volumerate);

		qr_ent_up setloopstate("veh_qrdrone_move_up", run_volume_up, run_pitch_up, volumerate);

		qr_ent_either setloopstate("veh_qrdrone_vertical", run_volume_either, run_pitch_either, volumerate);
		
	}
}


function qr_ent_cleanup(veh_ent)
{
	veh_ent waittill ("entityshutdown");
	self delete();
}


function drone_rotate_angle( heli_type, heli_part ) //self == drone
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
	
	volumerate = 2.5;
	
	qr_ent_angle = spawn( 0, self.origin, "script_origin" );
	qr_ent_angle thread qr_ent_cleanup (self);
	
	angle = qr_ent_angle playloopsound ("veh_qrdrone_idle_rotate");
	setSoundVolume( angle, 0 );
	
	tag = "tag_body";
	qr_ent_angle linkto (self, tag);

	
	while( 1 )
	{
		
		last_angle = abs( self.angles[1] );

		wait (.1);
		
	 	turning_speed =  last_angle - abs( self.angles[1] );
	 	
	 	abs_turning_speed = abs(turning_speed);
	 	
	 	

	 	jet_stick_vol = audio::scale_speed ( 0, 5, 0, .4, abs_turning_speed);
		jet_stick_pitch = audio::scale_speed ( 0, 4, .9, 1.05, abs_turning_speed);	
		
		//setSoundVolumeRate (angle, volumerate);		
		//setSoundVolume ( angle, jet_stick_vol );			
		//setSoundPitch ( angle, jet_stick_pitch );		

		qr_ent_angle setloopstate("veh_qrdrone_idle_rotate", jet_stick_vol, jet_stick_pitch, volumerate);
	}
}



function drone_button_watch()
{
	self endon( "entityshutdown" );
	
	player = getlocalplayers()[0];
	return_to_zero= true;
	
	while (1)
	{
		if ( abs (self.qrdrone_z_difference) > 5 && return_to_zero)
		{
			self playsound (0, "veh_qrdrone_move_start");
			return_to_zero = false;
			
			/*
			while (abs (self.qrdrone_z_difference) > 10)
			{
				wait (.05);
			}
			
			check_speed = audio::scale_speed( 5, 50, 0, 1, self.qrdrone_z_difference );
			while (check_speed < .1)
			{
				wait (.05);
				check_speed = audio::scale_speed( 5, 50, 0, 1, self.qrdrone_z_difference );
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
