#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\compass;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_objectives;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses_level_start;
#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;

#precache( "objective", "cp_level_ramses_walkthrough_mid" );

function main()
{
//	precache();
	
	level flag::init( "end_tunneltalk_pt1" );
	level thread ambient_vtol_flyovers();
//	level thread rachel_hendricks_walk_scene();
	level thread additional_aligned_walk_anims();
	level thread additional_unaligned_walk_anims();
//	level thread player_triggered_anims(); //These are triggered by a players' position in the station
//	level thread khalil_triggered_anims(); TODO: these are the animations the trigger specifically off of Khalil giving you a tour of the station
	level thread scene_cleanup();
	level thread soundSceneWatchers();
	level thread subway_cleanup();

	rachel_hendricks_walk_scene();
	
	if ( !ramses_util::is_demo() )
	{
		level skipto::objective_completed( "rs_walk_through" );
	}	
}

//function precache()
//{
//	// DO ALL PRECACHING HERE
//}

function init_heroes( str_objective )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_rachel = util::get_hero( "rachel" );
	level.ai_khalil = util::get_hero( "khalil" );
		
    skipto::teleport_ai( str_objective );
}

function pre_skipto_anims()
{

}

function player_triggered_anims()
{
	//These animations are triggered off the player position.  Some of them are currently temp'ed in and will be switched to being driven by notetracks
	// on the walking anim through the station
	
}


function rachel_hendricks_walk_scene()
{
	level endon( "player_at_fade_down" ); //-- For DT 34001
	
	level thread ramses_util::ambient_walk_fx_exploder();
	
	level thread rachel_hendrickS_walk_scene_additional_anims(); //-- This runs all of the scenes that are tied to the hero walk through
	
	//INIT
	scene::init( "cin_ram_02_04_walk_1st_introduce_01" ); //-- TODO: later this will flow in from a different set of intro anims
	scene::init( "cin_ram_02_04_walk_1st_thousandyardstare" ); //-- This init is actually the whole loop
			
	//PLAY
	scene::play( "cin_ram_02_04_walk_1st_introduce_01" );
	scene::play( "cin_ram_02_04_walk_1st_introduce_02" );
	scene::play( "cin_ram_02_04_walk_1st_introduce_03" );
	scene::play( "cin_ram_02_04_walk_1st_introduce_04" );
	
	if ( ramses_util::is_demo() )
	{
		level thread util::delay( 2 , undefined , &skipto::objective_completed , "rs_walk_through" );
	}
	
	scene::play( "cin_ram_02_04_walk_1st_introduce_05" );
	//-- the walk is done here
}

//-- threaded from rachel_hendricks_walk_scene
function rachel_hendricks_walk_scene_additional_anims()
{
	util::wait_network_frame(); //space out the spawns caused by these
	
	scene::init( "cin_ram_02_03_station_vign_interview_guards" );
	scene::init( "cin_ram_02_03_station_vign_recovery_room_guys" );
	
	util::wait_network_frame(); 
	
	scene::init( "cin_ram_02_03_station_vign_walk_to_escalator_sit" );
	scene::init( "cin_ram_02_03_station_vign_run_to_crates" );
	
	util::wait_network_frame();
	
	scene::init( "cin_ram_02_03_station_vign_run_to_surgery_cleanup" );
	scene::init( "cin_ram_02_03_station_vign_guys_impede_vips_guy01" );
	
	util::wait_network_frame();
	
	scene::init( "cin_ram_02_03_station_vign_guys_impede_vips_guy02" );
	scene::init( "cin_ram_02_03_station_walk_run_to_guy_at_cleanup" );
	
	util::wait_network_frame();
	
	scene::init( "cin_ram_02_03_station_vign_jump_off_crates" );
	scene::init( "cin_ram_02_03_station_vign_triage_enter_02" );
	
	util::wait_network_frame();
	
	scene::init( "cin_ram_02_03_station_vign_mop_blood_move" );
	scene::init( "cin_ram_02_04_walk_vign_movemove_02" );
	
	util::wait_network_frame();
	
	scene::init( "cin_ram_02_03_station_vign_intosurgery" );
	scene::init( "cin_ram_02_03_station_vign_triage_helmettable_02" );
	scene::init( "cin_ram_02_03_recovery_vign_walk_inspect");
	
	util::wait_network_frame();
	
	scene::init( "cin_ram_02_03_station_vign_stressed" );
	
	util::wait_network_frame();
	
	//-- the level notifies for these are based on notetracks from khalil's animations
	level thread util::delay( "play_impede_vips", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_guys_impede_vips_guy01" );
	level thread util::delay( "play_impede_vips", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_guys_impede_vips_guy02" );
	level thread util::delay( "play_walk_to_escalator_sit", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_walk_to_escalator_sit" );
	level thread util::delay( "play_run_to_crates", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_run_to_crates" );
	level thread util::delay( "play_run_to_surgery_cleanup", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_run_to_surgery_cleanup" );
	level thread util::delay( "play_recovery_room_guys", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_recovery_room_guys" );
	level thread util::delay( "play_interview_guards", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_interview_guards" );
	level thread util::delay( "play_interview_guards", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_interviewroom_guards" );
	
	level thread util::delay( "play_run_to_guy_at_cleanup", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_walk_run_to_guy_at_cleanup" );
	level thread util::delay( "play_triage_enter", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_triage_enter_02" );
	level thread util::delay( "play_into_surgery", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_intosurgery" );
	level thread util::delay( "play_mop_blood_move", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_mop_blood_move" );
	level thread util::delay( "play_move_move", "station_walk_cleanup", &scene::play, "cin_ram_02_04_walk_vign_movemove_02" );
	level thread util::delay( "play_jump_off_crates", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_jump_off_crates" );
	
	level thread util::delay( "play_helmet_table", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_triage_helmettable_02" );
	
	level thread util::delay( "play_move_move", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_stressed" ); //TODO: get a new notetrack for this
	
	level thread util::delay( "play_inspect_servers", "station_walk_cleanup", &scene::play, "cin_ram_02_03_recovery_vign_walk_inspect");
	
}

function additional_aligned_walk_anims()
{
	util::wait_network_frame();
	
	level thread scene::init( "cin_ram_02_03_station_vign_inspect_patients_02_medic" );
	level thread scene::init( "cin_ram_02_03_station_vign_inspect_patients_02_guy01" );
	level thread scene::init( "cin_ram_02_03_station_vign_inspect_patients_02_guy02" );
	level thread scene::init( "cin_ram_02_03_station_vign_inspect_patients_01_medic" );
	level thread scene::init( "cin_ram_02_03_station_vign_inspect_patients_01_guy01" );
	level thread scene::init( "cin_ram_02_03_station_vign_inspect_patients_01_guy02" );
	level thread scene::play( "cin_ram_02_03_station_vign_cornerguard_derive" );
	
	util::wait_network_frame();
	
	level thread scene::play( "cin_ram_02_03_station_vign_on_crates_inspecting" );
	level thread scene::play( "cin_ram_02_03_station_vign_inspecting_two_crates" );
	
	level thread scene::play( "cin_ram_02_03_station_vign_reflecting_guy01" );
	level thread scene::play( "cin_ram_02_03_station_vign_reflecting_guy02" );
	
	level thread scene::play( "cin_ram_02_03_station_vign_readingipad_guy01" );
	level thread scene::play( "cin_ram_02_03_station_vign_readingipad_guy02" );
	level thread scene::play( "cin_ram_02_03_station_vign_supply_opencrate" ); //-- TODO: This one should probably be timed to the walk...
	level thread scene::play( "cin_ram_02_03_station_vign_supply_inventory" );
	
	util::wait_network_frame();
	
	level thread scene::play( "cin_ram_02_03_recovery_vign_patient01" );
	level thread scene::play( "cin_ram_02_03_recovery_vign_patient02" );
	
	level thread util::delay( "play_recovery_medics", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_inspect_patients_02_medic" );
	level thread util::delay( "play_recovery_medics", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_inspect_patients_01_medic" );
	
	level thread util::delay( "play_medic_01_patient_02", "station_walk_cleanup", &scene::play, "cin_ram_02_03_station_vign_inspect_patients_01_guy02" );
}

function additional_unaligned_walk_anims()
{
	level thread scene::play( "cin_ram_02_03_station_vign_scaffold_inspecting" );
	level thread scene::play( "cin_ram_02_03_station_vign_amputee_arm_a" );
	level thread scene::play( "cin_ram_02_03_station_vign_amputee_arm_b" );
	level thread scene::play( "cin_ram_02_03_station_vign_shrapnel_comfort_1" );
	level thread scene::play( "cin_ram_02_03_station_vign_triage_gurney_elevated_main" );
	level thread scene::play( "cin_ram_02_03_station_vign_consoling_chair" );
	level thread scene::play( "cin_ram_02_03_station_vign_consoling" );
}

function tunneltalk_pt1_done( a_ents )
{
	level flag::set( "end_tunneltalk_pt1" );
}


function forklift_passes_vig()
{	
	//trigger::wait_till( "move_forklift" );
	
	level scene::play( "cin_ram_02_03_interview_vign_forklift_passes" );
}

function subway_cleanup()
{
	level flag::wait_till( "subway_cleared" ); //set on trigger in radiant, players all on stairs or beyond
	
	level_start::turn_off_reflection_extracam();
	
	t_subway_top = GetEnt( "trig_subway_area_top" , "targetname" );
	t_subway_mid = GetEnt( "trig_subway_area_mid" , "targetname" );
	t_subway_bottom = GetEnt( "trig_subway_area_bottom" , "targetname" );
	s_sight = struct::get( "subway_sight_target" );
	
	do
	{
		b_can_hide_gate = true;
		
		while ( util::any_player_is_touching( t_subway_top , "allies" ) || util::any_player_is_touching( t_subway_mid , "allies" ) || util::any_player_is_touching( t_subway_bottom , "allies" ) )
		{
			wait 0.25;
		}
		
		foreach ( player in level.players )
		{
			if ( player util::is_looking_at( s_sight , 0.5 ) )
			{
				b_can_hide_gate = false;
			}
		}
		
		wait 0.25;
	} 
	while ( b_can_hide_gate == false );
	
	GetEnt( "subway_collision" , "script_string" ) Show();
	
	a_blockers = GetEntArray( "subway_blocker" , "script_string" );
	
	foreach ( blocker in a_blockers )
	{
		blocker Show();
	}
}

function scene_cleanup( b_wait_for_flag = true )
{
	if( b_wait_for_flag )
	{
		level flag::wait_till( "station_walk_cleanup" );
	}
	else
	{
		//HACK: remove this later once things are more settled
		wait 1;
	}
	
	level notify( "station_walk_cleanup" );
	
	a_str_scenes = [];
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_clipboard_a";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_clipboard_b";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_clipboard_c";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_argument_a";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_argument_b";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_turret_guy_a";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_turret_guy_b";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_walk_vign_forklift_loop";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_medsuppliesdelivery";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_patient_in_shock";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_walk_vign_medical";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_interview_vign_forklift_passes";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_bloodyhead_seated_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_bloodyhead_seated_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_bloodyhead_seated_guy03";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_conversation";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_sharpening";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_sleeping_seated";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_sleeping_seated_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_sleeping_seated_guy03";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_sleeping_seated_guy04";;
//	ARRAY_ADD( a_str_scenes, "cin_ram_02_03_station_vign_shrapnel_soldier_seated_guy01" );
//	ARRAY_ADD( a_str_scenes, "cin_ram_02_03_station_vign_shrapnel_soldier_seated_guy02" );
//	ARRAY_ADD( a_str_scenes, "cin_ram_02_03_station_vign_shrapnel_soldier_seated_guy03" );
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_using_ipad_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_using_ipad_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_using_ipad_guy03";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_diagnostics_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_diagnostics_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_diagnostics_guy03";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_amputee_arm_a";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_amputee_arm_b";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_amputee_arm_c";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_amputee_preist";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_balcony_surveying_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_balcony_surveying_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_balcony_surveying_guy03";;
//	ARRAY_ADD( a_str_scenes, "cin_ram_02_03_station_vign_screaming" );
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_triage_bleedout";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_seizure_soldier";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_scaffold_inspecting";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_staring_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_giving_blood_guy1";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_giving_blood_guy2";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_giving_blood_guy3";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_thousandstare_a_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_thousandstare_a_guy03";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_thousandstare_b_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_thousandstare_b_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_treated_soldier_guy05";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_treated_soldier_guy06";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_treated_soldier_guy08";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_nervous_guy03";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_smoking_guy03";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_smoking_guy04";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_on_crates_inspecting";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_inspecting_two_crates";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_reflecting_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_reflecting_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_readingipad_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_readingipad_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_supply_opencrate";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_supply_inventory";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_inspect_patients_01_medic";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_inspect_patients_01_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_inspect_patients_01_guy02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_inspect_patients_02_medic";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_inspect_patients_02_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_inspect_patients_02_guy02";;
	
	//-- January Mocap
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_triage_helmettable_02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_bloodmopping";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_supply_getweapons";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_triage_nursegauze_distributing";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_triage_cot_exitdoors";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_walk_run_to_guy_at_cleanup";;

	//-- Additional Walk Animation
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_interview_guards";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_recovery_room_guys";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_walk_to_escalator_sit";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_run_to_crates";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_run_to_surgery_cleanup";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_guys_impede_vips_guy01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_guys_impede_vips_guy02";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_run_to_guy_at_cleanup";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_jump_off_crates";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_triage_enter_02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_mop_blood_move";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_04_walk_vign_movemove_02";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_intosurgery";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_04_walk_1st_thousandyardstare";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_stressed";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_recovery_vign_walk_inspect";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_interviewroom_guards";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_recovery_vign_patient01";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_recovery_vign_patient02";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_cornerguard_derive";;
	
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_amputee_arm_a";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_amputee_arm_b";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_shrapnel_comfort_1";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_triage_gurney_elevated_main";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_consoling_chair";;
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_02_03_station_vign_consoling";;
		
	// Level Start scenes
	if ( !isdefined( a_str_scenes ) ) a_str_scenes = []; else if ( !IsArray( a_str_scenes ) ) a_str_scenes = array( a_str_scenes ); a_str_scenes[a_str_scenes.size]="cin_ram_01_01_enterstation_vign_loading";;
	
	n_cycles = 0;
	foreach ( str_scene in a_str_scenes )
	{
		if ( level scene::is_active( str_scene ) )
		{
			level thread scene::stop( str_scene, true );
			n_cycles++;
			
			if ( n_cycles > 10 )
			{
				wait 0.05;
				n_cycles = 0;
			}
		}
	}
}

//self == trig
//all the models it spawns are temp soldiers
//TODO: delete this function ocne the vtol ride no longer needs it
function spawn_and_move_model( str_char_model = "c_gen_soldier_1_fb", speed_multiplier = 1, b_hide = false )
{
	start_struct = struct::get( self.target, "targetname");

	e_temp_guy = util::spawn_model( str_char_model , start_struct.origin, start_struct.angles );
	
	if(b_hide)
	{
		wait 0.05;
		e_temp_guy ghost();
	}
	
	//wait for the trigger to spawn
	self waittill( "trigger" );
	
	if(b_hide)
	{
		e_temp_guy show();
	}
	
	//move the model from struct to struct
	do
	{
		next_struct = struct::get( start_struct.target, "targetname" );
	
		//Calculate generic move time for someone who is... walking?
		move_time = Distance( next_struct.origin, start_struct.origin ) / (36*2) / speed_multiplier ; // distance / (1 yd + 1ft steps at 2 steps per second)
		e_temp_guy Moveto( next_struct.origin, move_time );
		
		//Snap the guy to face his next node
		new_angles = next_struct.origin - start_struct.origin;
		e_temp_guy.angles = ( 0, VectorToAngles(new_angles)[1], 0 );
		
		
		wait( move_time );
		
		start_struct = next_struct;
	} 
	while( isdefined( start_struct.target ) );
	
	e_temp_guy Delete();
}


//-- Flies VTOLs over the station
function ambient_vtol_flyovers() //-- new version that doesn't use an actual vtol
{
	level endon( "station_walk_cleanup" );
			
	//a_vtol_spawner = GetVehicleSpawnerArray( "walk_flyover_vtol", "targetname" );
	a_start_struct = struct::get_array( "walk_flyover_vtol", "targetname" );
	a_end_struct = struct::get_array( "struct_station_fly_end", "targetname" );
	
	while( true )
	{
		v_start = array::random( a_start_struct ).origin;
		
		e_vtol = Spawn( "script_model", v_start );
		e_vtol SetModel( "p7_mil_vtol_egypt_alphatest" );
		
		util::wait_network_frame();
		
		v_end_pos = array::random( a_end_struct ).origin;
		
		//set proper facing angle based on path end pos
		v_path = v_end_pos - v_start;
		angles = VectorToAngles( v_path );
		e_vtol.angles = angles;
		
		e_vtol thread vtol_fly_over_roof( v_end_pos );		
		
		wait( RandomFloatRange( 12, 15 ) );
	}
}

function vtol_fly_over_roof( v_end_pos )
{
	self MoveTo( v_end_pos, 5 );
	self waittill( "movedone" );
	self Delete();
}

//TODO:  DELETE IF STILL COMMENTED OUT AFTER OR ON 4/1/15
//function ambient_vtol_flyovers()
//{
//	level endon( "station_walk_cleanup" );
//			
//	a_vtol_spawner = GetVehicleSpawnerArray( "walk_flyover_vtol", "targetname" );
//	a_end_struct = struct::get_array( "struct_station_fly_end", "targetname" );
//	
//	while( true )
//	{
//		vh_vtol = spawner::simple_spawn_single( array::random(a_vtol_spawner) );
//		vh_vtol thread vtol_fly_over_roof( array::random(a_end_struct).origin );		
//		wait( RandomFloatRange( 12, 15 ) );
//	}
//}
//
//function vtol_fly_over_roof( v_goal )
//{
//	self SetVehGoalPos( v_goal, false );
//	self util::waittill_any( "near_goal", "goal" );
//	self Delete();
//}

function soundSceneWatchers()
{
	level thread soundScenePlay( "sndScene1",(6346,-1864,94),"vox_rams_vign_generic_002_med3","vox_rams_vign_generic_003_med4","vox_rams_vign_generic_006_med3");
	level thread soundScenePlay( "sndScene2",(6830,-1580,90),"vox_rams_vign_generic_000_med1","vox_rams_vign_generic_001_med2");
	level thread soundScenePlay( "sndScene3",(7079,-2344,84),"vox_rams_vign_inventory_001_esl2","vox_rams_vign_inventory_002_esl3");
	level thread soundScenePlay( "sndScene4",(7442,-1686,86),"vox_rams_vign_generic_010_srg1","vox_rams_vign_generic_011_srg4","vox_rams_vign_generic_016_srg1");
	level thread soundScenePlay( "sndScene5",(7907,-1126,96),"vox_rams_vign_inventory_003_esl4","vox_rams_vign_inventory_004_esl1");
	level thread soundScenePlay( "sndScene6",(7251,-398,36),"vox_rams_vign_civ2_000_esl1","vox_rams_vign_civ2_001_esl2");
	level thread soundScenePlay( "sndScene7",(7442,-1686,86),"vox_rams_vign_generic_008_med1", "vox_rams_vign_generic_009_med2");
	level thread sndPAWatcher();
}
function soundScenePlay(sndNotify,sndOrigin,alias1,alias2,alias3,alias4)
{
	level waittill( sndNotify );
	playsoundatposition(alias1,sndOrigin);
	level soundSceneWait( alias1 );
	
	if(isdefined(alias2))
	{
		playsoundatposition(alias2,sndOrigin);
		level soundSceneWait( alias1 );
	}
	
	if(isdefined(alias3))
	{
		playsoundatposition(alias3,sndOrigin);
		level soundSceneWait( alias1 );
	}
	
	if(isdefined(alias4))
	{
		playsoundatposition(alias4,sndOrigin);
		level soundSceneWait( alias1 );
	}
}
function soundSceneWait( soundAlias )
{
	playbackTime = soundgetplaybacktime ( soundAlias );
	
	if ( playbackTime >= 0 )
	{
		waitTime = playbackTime * .001;
		wait ( waitTime );
	}
	else
	{
		wait ( 1.0 );
	}
}
function sndPAWatcher()
{
	sndEnt = spawn( "script_origin", (7068, -1791, 548) );
	
	while(1)
	{
		level waittill( "sndPA" );
		sndEnt playsound( "amb_hospital_pa" );
	}
}