#include soundscripts\_snd;
#include soundscripts\_audio;
#include soundscripts\_audio_music;
#include soundscripts\_audio_vehicle_manager;

/**************************************************************************************************************************************/
/**************************************************************************************************************************************/
/**************************************************************************************************************************************/

/*
 ********************************************************************************************
 * 
 * MUSIC PRESET:  Virus One
 * 
 * Designed to adapt to a generic "ams_intensity" input.
 * 
 ********************************************************************************************
 */

kVrs1_Default_SmoothUp		= 0.10;
kVrs1_Default_SmoothDown	= 0.05;
	
virus1_preset_constructor()
{
	kVrs1_bsgprc2_IFadeIn		= 0.65;
	kVrs1_bsgprc2_IIn			= 0.75;
	kVrs1_bsgprc2_VolMin		= 0.0;
	kVrs1_bsgprc2_VolMax		= 1.0;
	
	kVrs1_bsgprc1_IFadeIn		= 0.50;
	kVrs1_bsgprc1_IIn			= 0.60;
	kVrs1_bsgprc1_IFadeOut		= 0.70;
	kVrs1_bsgprc1_IOut			= 0.80;
	kVrs1_bsgprc1_VolMin		= 0;
	kVrs1_bsgprc1_VolMax		= 1.0;
	
	kVrs1_bigshufl_IMin			= 0.30;
	kVrs1_bigshufl_IMax			= 1.00;
	kVrs1_bigshufl_VolMin		= 0;
	kVrs1_bigshufl_VolMax		= 1.0;
	
	kVrs1_tribelgruv_IMin		= 0.20;
	kVrs1_tribelgruv_IMax		= 1.00;
	kVrs1_tribelgruv_VolMin		= 0;
	kVrs1_tribelgruv_VolMax		= 1.0;

	kVrs1_tilbell_IMin			= 0.10;
	kVrs1_tilbell_IMax			= 1.00;
	kVrs1_tilbell_VolMin		= 0.00;
	kVrs1_tilbell_VolMax		= 1.00;
	
	kVrs1_badbrain_IMin			= 0.00;
	kVrs1_badbrain_IMax			= 1.00;
	kVrs1_badbrain_VolMin		= 0.15;
	kVrs1_badbrain_VolMax		= 1.0;
	
	
	/***** DEFINE LOOPS *****/
	VM2_begin_preset_def("virus1", ::vrs1_instance_init);

		VM2_begin_loop_data(5.0, kVrs1_Default_SmoothUp, kVrs1_Default_SmoothDown);
	
			VM2_begin_loop_def("virus1_mix1");	
			VM2_end_loop_def();				
		
			VM2_begin_loop_def("virus1_mix2");	
			VM2_end_loop_def();				

			VM2_begin_loop_def("virus1_tilbell");	
				VM2_begin_param_map("ams_intensity");									
					VM2_add_param_map_env("volume", "virus1_tilbell_i2vol");		
				VM2_end_param_map();
			VM2_end_loop_def();				

			VM2_begin_loop_def("virus1_bigshufl");	
				VM2_begin_param_map("ams_intensity");									
					VM2_add_param_map_env("volume", "virus1_bigshufl_i2vol");		
				VM2_end_param_map();
			VM2_end_loop_def();			
			
			VM2_begin_loop_def("virus1_tribelgruv");	
				VM2_begin_param_map("ams_intensity");									
					VM2_add_param_map_env("volume", "virus1_tribelgruv_i2vol");		
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def("virus1_bsgprc1");	
				VM2_begin_param_map("ams_intensity");									
					VM2_add_param_map_env("volume", "virus1_bsgprc1_i2vol");		
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def("virus1_bsgprc2");	
				VM2_begin_param_map("ams_intensity");									
					VM2_add_param_map_env("volume", "virus1_bsgprc2_i2vol");		
				VM2_end_param_map();
			VM2_end_loop_def();

			VM2_begin_loop_def("virus1_badbrain");	
				VM2_begin_param_map("ams_intensity");									
					VM2_add_param_map_env("volume", "virus1_badbrain_i2vol");		
				VM2_end_param_map();
			VM2_end_loop_def();		
					
		VM2_end_loop_data();
		
		/***** DEFINE ONESHOTS *****/
		VM2_begin_oneshot_data();		
		VM2_end_oneshot_data();
		
		/***** DEFINE BEHAVIORS *****/
		VM2_begin_behavior_data();

			VM2_begin_behavior_def("to_mix1", ::vrs1_condition_to_mix1);
				VM2_add_loops(["virus1_mix1"]);
				VM2_add_init_state_callback(::vrs1_enter_mix1);
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def("to_mix2", ::vrs1_condition_to_mix2);
				VM2_add_loops(["virus1_mix2"]);
				VM2_add_init_state_callback(::vrs1_enter_mix2);
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def("to_adaptive", ::vrs1_condition_to_adaptive);				
				VM2_add_loops(["virus1_tilbell", "virus1_bigshufl", "virus1_badbrain", "virus1_tribelgruv", "virus1_bsgprc1", "virus1_bsgprc2"]);
				//VM2_add_loops(["virus1_badbrain"]);
				VM2_add_init_state_callback(::vrs1_enter_adaptive);
				
//				VM2_begin_param_map("ams_intensity", kVrs1_Default_SmoothUp, kVrs1_Default_SmoothDown);
//				VM2_end_param_map();			
//				VM2_add_in_state_callback(		::bsgods_in_adaptive		);				
			VM2_end_behavior_def();
			
		VM2_end_behavior_data();		
		
		/***** DEFINE STATES *****/
		VM2_begin_state_data(0.25, 50);
		
			VM2_begin_state_group("main_group", "mix1", "to_mix1");
			
				VM2_begin_state_def("mix1");
					VM2_add_state_transition("mix2",		"to_mix2");
					VM2_add_state_transition("adaptive",	"to_adaptive");
				VM2_end_state_def();

				VM2_begin_state_def("mix2");
					VM2_add_state_transition("mix1",		"to_mix1");
					VM2_add_state_transition("adaptive", 	"to_adaptive");
				VM2_end_state_def();
				
				VM2_begin_state_def("adaptive");
					VM2_add_state_transition("mix1",		"to_mix1");
					VM2_add_state_transition("mix2",		"to_mix2");
				VM2_end_state_def();
				
			VM2_end_state_group();
		
		VM2_end_state_data();
		
		
		/***** DEFINE ENVELOPES *****/
		VM2_add_envelope("virus1_bsgprc2_i2vol",
			[
				[kVrs1_bsgprc2_IFadeIn,	kVrs1_bsgprc2_VolMin],  
				[kVrs1_bsgprc2_IIn,		kVrs1_bsgprc2_VolMax]
			]
		);
		VM2_add_envelope("virus1_bsgprc1_i2vol",
			[
				[kVrs1_bsgprc1_IFadeIn,		kVrs1_bsgprc1_VolMin],
				[kVrs1_bsgprc1_IIn,			kVrs1_bsgprc1_VolMax],
				[kVrs1_bsgprc1_IFadeOut,	kVrs1_bsgprc1_VolMax],
				[kVrs1_bsgprc1_IOut,		kVrs1_bsgprc1_VolMin]
			]
		);
		VM2_add_envelope("virus1_bigshufl_i2vol",
			[
				[kVrs1_bigshufl_IMin,	kVrs1_bigshufl_VolMin],  
				[kVrs1_bigshufl_IMax,	kVrs1_bigshufl_VolMax]
			]
		);
		VM2_add_envelope("virus1_tribelgruv_i2vol",
			[
				[kVrs1_tribelgruv_IMin,	kVrs1_tribelgruv_VolMin],  
				[kVrs1_tribelgruv_IMax,	kVrs1_tribelgruv_VolMax]
			]
		);
		VM2_add_envelope("virus1_tilbell_i2vol",
			[
				[0,						0],  
				[kVrs1_tilbell_IMin,	kVrs1_tilbell_VolMin],  
				[kVrs1_tilbell_IMax,	kVrs1_tilbell_VolMax]
			]
		);
		VM2_add_envelope("virus1_badbrain_i2vol",
			[
				[kVrs1_badbrain_IMin,	kVrs1_badbrain_VolMin],  
				[kVrs1_badbrain_IMax,	kVrs1_badbrain_VolMax]
			]
		);
		
	VM2_end_preset_def();
}

vrs1_instance_init(userdata)
{
}

vrs1_condition_to_mix1(smoothed_input, user_data)
{	
	return ams_get_state() == "mix1";
}
	
vrs1_condition_to_mix2(smoothed_input, user_data)
{	
	return ams_get_state() == "mix2";
}
	
vrs1_condition_to_adaptive(smoothed_input, user_data)
{	
	return ams_get_state() == "adaptive";
}

vrs1_enter_mix1(userdata)
{
	self VM2_set_instance_master_volume(1.0, 3.0);
}

vrs1_enter_mix2(userdata)
{
	self VM2_set_instance_master_volume(1.0, 3.0);
}

vrs1_enter_adaptive(userdata)
{
	self VM2_set_instance_master_volume(1.0, 3.0);
}
	

/**************************************************************************************************************************************/
/**************************************************************************************************************************************/
/**************************************************************************************************************************************/

/*
 ********************************************************************************************
 * 
 * MUSIC PRESET:  Blacksmith of the Gods
 * 
 * Designed specifically to interact with the speed of the player PitBull in sanfran.
 * 
 ********************************************************************************************
 */
 
kBSGods_MinSpeed			= 0;
kBSGods_MaxSpeed			= 60;	// Really goes to 75, but want to max out the music sooner.
kBSGods_NomSpeed			= kBSGods_MaxSpeed * 0.5;
kBSGods_SpeedRange			= kBSGods_MaxSpeed - kBSGods_MinSpeed;

kBSGods_Default_LoopSmoothUp		= 0.08;
kBSGods_Default_LoopSmoothDown		= 0.08;

bsgods_preset_constructor()
{
	/***** DEFINE LOOPS *****/
	VM2_begin_preset_def("bsgods_preset", ::bsgods_preset_instance_init_callback);

		VM2_begin_loop_data(3.0, kBSGods_Default_LoopSmoothUp, kBSGods_Default_LoopSmoothDown);
	
			// Intro Loop.
			VM2_begin_loop_def("mus_sfa_intro_loop", 3.1);	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "intro_loop_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();				
		
			// PRC Loops.
			VM2_begin_loop_def("bsgods_prc_lyr1");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_prc_lyr1_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();				

			VM2_begin_loop_def("bsgods_prc_lyr2");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_prc_lyr2_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();				

			VM2_begin_loop_def("bsgods_prc_lyr3");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_prc_lyr3_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();		

			// LPS Loops.
			VM2_begin_loop_def("bsgods_lps_lyr1");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_lps_lyr1_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();							
			VM2_begin_loop_def("bsgods_lps_lyr2");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_lps_lyr2_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();							
			VM2_begin_loop_def("bsgods_lps_lyr3");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_lps_lyr3_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();							
			VM2_begin_loop_def("bsgods_lps_lyr4");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_lps_lyr4_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();							
			VM2_begin_loop_def("bsgods_lps_lyr5");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_lps_lyr5_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();	

			// ATM Loops.
			VM2_begin_loop_def("bsgods_atm_lyr2");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_atm_lyr1_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();				
		
			// RIS Loops.
			VM2_begin_loop_def("bsgods_ris_lyr1");	
				VM2_begin_param_map("ams_proxy_vehicle_speed");									
					VM2_add_param_map_env("volume", "bsgods_ris_lyr1_speed_to_vol");		
				VM2_end_param_map();
			VM2_end_loop_def();				
			
		VM2_end_loop_data();
		
		/***** DEFINE ONESHOTS *****/
		VM2_begin_oneshot_data();
			
			VM2_begin_oneshot_def("bsgods_prc_hit1", "bsgods_prc_hit_duck_envelope", 0.25, 0);
				VM2_begin_param_map("ams_proxy_vehicle_speed");
					VM2_add_param_map_env("volume", "bsgods_prc_hit_speed_to_vol");
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
			VM2_begin_oneshot_def("bsgods_prc_hit2", "bsgods_prc_hit_duck_envelope", 0.25, 0);
				VM2_begin_param_map("ams_proxy_vehicle_speed");
					VM2_add_param_map_env("volume", "bsgods_prc_hit_speed_to_vol");
				VM2_end_param_map();
			VM2_end_oneshot_def();
			
		VM2_end_oneshot_data();
		
		/***** DEFINE BEHAVIORS *****/
		VM2_begin_behavior_data();

			VM2_begin_behavior_def("to_state_intro", ::bsgods_condition_to_state_intro, ["ams_proxy_vehicle_speed"]);
				VM2_add_loops(["mus_sfa_intro_loop"]);
				VM2_add_oneshots("bsgods_prc_hit1");		
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def("to_state_driving", ::bsgods_condition_to_state_driving);				
				VM2_add_loops(["bsgods_prc_lyr1", "bsgods_prc_lyr2", "bsgods_prc_lyr3", "bsgods_lps_lyr1", "bsgods_lps_lyr2", "bsgods_lps_lyr3", "bsgods_lps_lyr4", "bsgods_lps_lyr5", "bsgods_atm_lyr2", "bsgods_ris_lyr1"]);		
				VM2_add_oneshots("bsgods_prc_hit1");	
				
				VM2_add_init_state_callback(	::bsgods_enter_state_driving	);
				VM2_add_in_state_callback(		::bsgods_in_state_driving		);
				
				
				VM2_begin_param_map("ams_proxy_vehicle_speed", 0.025, 0.025);
				VM2_end_param_map();
			VM2_end_behavior_def();
			
		VM2_end_behavior_data();		
		
		/***** DEFINE STATES *****/
		VM2_begin_state_data(0.25, 50);
		
			VM2_begin_state_group("main_group", "state_driving", "to_state_driving");
			
				VM2_begin_state_def("state_intro");
					VM2_add_state_transition("state_driving", "to_state_driving");
				VM2_end_state_def();
	
				VM2_begin_state_def("state_driving");
					VM2_add_state_transition("state_intro", "to_state_intro");
				VM2_end_state_def();
				
			VM2_end_state_group();
		
		VM2_end_state_data();
		
		
		/***** DEFINE ENVELOPES *****/

		VM2_add_envelope("intro_loop_speed_to_vol",
			[
				[kBSGods_MinSpeed + kBSGods_SpeedRange * 0.0,		1.0],  
				[kBSGods_MinSpeed + kBSGods_SpeedRange * 1.0,		1.0]
			]
		);
			
		// PRC Loop Envelopes.
		lyr_nodes = [0.000, 0.166, 0.333, 0.500, 0.666, 0.833, 1.000];
		VM2_add_envelope("bsgods_prc_lyr1_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[0],	1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[2],	1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[3],	0.0]
			]
		);
		
		VM2_add_envelope("bsgods_prc_lyr2_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[1],	0.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[2],	1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[4],	1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[5],	0.0]
			]
		);
		
		VM2_add_envelope("bsgods_prc_lyr3_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[3],	0.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[4],	1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[6],	1.0]
			]
		);
		
		// PRC Oneshot Envelopes.
		VM2_add_envelope("bsgods_prc_hit_speed_to_vol",
			[
				[kBSGods_MinSpeed + kBSGods_SpeedRange * 0.0,	0.5],  
				[kBSGods_MinSpeed + kBSGods_SpeedRange * 1.0,	0.5]
			]
		);
		
		// LPS Envelopes.
		lyr_nodes = [0.000, 0.166, 0.333, 0.500, 0.666, 0.833, 1.000];
		VM2_add_envelope("bsgods_lps_lyr1_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[0],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[1],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[2],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[2] + 0.1,	0.0]
			]
		);
		VM2_add_envelope("bsgods_lps_lyr2_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[2] - 0.1,	0.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[2],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[3],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[3] + 0.1,	0.0]
			]
		);
		VM2_add_envelope("bsgods_lps_lyr3_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[3] - 0.1,	0.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[3],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[4],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[4] + 0.1,	0.0]
			]
		);
		VM2_add_envelope("bsgods_lps_lyr4_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[4] - 0.1,	0.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[4],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[5],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[5] + 0.1,	0.0]
			]
		);
		VM2_add_envelope("bsgods_lps_lyr5_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[5] - 0.1,	0.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[5],			1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[6],			1.0]
			]
		);

		// ATM Envelopes.
		lyr_nodes = [0.000, 0.166, 0.333, 0.500, 0.666, 0.833, 1.000];
		VM2_add_envelope("bsgods_atm_lyr1_speed_to_vol",
			[
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[3],		0.00],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[4],		0.40],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[5],		0.70],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[6],		0.70]
			]
		);
		
		// RIS Envelopes.
		lyr_nodes = [0.80, 0.90, 1.0];
		VM2_add_envelope("bsgods_ris_lyr1_speed_to_vol",
			[
				[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[0],		0.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[1],		1.0],
			 	[kBSGods_MinSpeed + kBSGods_SpeedRange * lyr_nodes[2],		1.0]
			]
		);
				
		VM2_add_envelope("bsgods_prc_hit_duck_envelope",
			[
				[0.00,	1.00], 
				[0.05,	0.50], 
				[0.30,	0.75], 
				[1.12,	1.00]
			]
		);

	VM2_end_preset_def();
}


////////////////////////
// BEHAVIOR CALLBACKS //
////////////////////////
bsgods_preset_instance_init_callback(user_data)
{
	
}

bsgods_condition_to_state_intro(smoothed_input, user_data)
{	
	return ams_get_state() == "intro";
}
	
bsgods_condition_to_state_driving(smoothed_input, user_data)
{	
	return ams_get_state() == "driving";
}

bsgods_enter_state_driving(user_data)
{
	assert(IsDefined(user_data));
	
	if (!IsDefined(user_data.st_driving))
		user_data.st_driving = SpawnStruct();
	
	user_data.st_driving.ris_is_muted		= true;
    user_data.st_driving.ris_mute_time		= 0;
    user_data.st_driving.ris_off_time		= false;
    user_data.st_driving.ris_max_off_time	= 36;
    user_data.st_driving.ris_max_on_time	= 18;
    
    user_data.st_driving.atm_is_muted		= true;
	user_data.st_driving.atm_mute_time		= 0;
    user_data.st_driving.atm_off_time		= false;
    user_data.st_driving.atm_max_off_time	= 18;
    user_data.st_driving.atm_max_on_time	= 9;
    
    VM2_set_loop_mute_state("bsgods_ris_lyr1", user_data.st_driving.ris_is_muted, 0.05);
    user_data.st_driving.ris_mute_time = snd_get_secs();
    
	VM2_set_loop_mute_state("bsgods_atm_lyr2", user_data.st_driving.atm_is_muted, 0.05);
    user_data.st_driving.atm_mute_time = snd_get_secs();
}

bsgods_in_state_driving(smoothed_input, user_data)
{
	spd = smoothed_input["ams_proxy_vehicle_speed"];
	
	if (spd > kBSGods_MaxSpeed * 0.75)
	{
		fade_time = 4.0;
		mute_time = snd_get_secs() - user_data.st_driving.ris_mute_time;
		if (user_data.st_driving.ris_is_muted && mute_time > user_data.st_driving.ris_max_off_time)
		{
			//IPrintLnBold("UnMuting RIS...");
			VM2_set_loop_mute_state("bsgods_ris_lyr1", false, fade_time);
			user_data.st_driving.ris_is_muted	= false;
			user_data.st_driving.ris_mute_time	= snd_get_secs();
		}
		else if (!user_data.st_driving.ris_is_muted && mute_time > user_data.st_driving.ris_max_on_time)
		{
			//IPrintLnBold("Muting RIS...");
			VM2_set_loop_mute_state("bsgods_ris_lyr1", true, fade_time);
			user_data.st_driving.ris_is_muted	= true;
			user_data.st_driving.ris_mute_time	= snd_get_secs();
		}
	}
	else if (!user_data.st_driving.ris_is_muted)
	{
		user_data.st_driving.ris_is_muted = true;
		VM2_set_loop_mute_state("bsgods_ris_lyr1", user_data.st_driving.ris_is_muted, 1.0);
	    user_data.st_driving.ris_mute_time = snd_get_secs();
	}
	
	if (spd > kBSGods_MaxSpeed * 0.50)
	{
		fade_time = 2.0;
		mute_time = snd_get_secs() - user_data.st_driving.atm_mute_time;
		if (user_data.st_driving.atm_is_muted && mute_time > user_data.st_driving.atm_max_off_time)
		{
			//IPrintLnBold("UnMuting ATM...");
			VM2_set_loop_mute_state("bsgods_atm_lyr2", false, fade_time);
			user_data.st_driving.atm_is_muted	= false;
			user_data.st_driving.atm_mute_time	= snd_get_secs();
		}
		else if (!user_data.st_driving.atm_is_muted && mute_time > user_data.st_driving.atm_max_on_time)
		{
			//IPrintLnBold("Muting ATM...");
			VM2_set_loop_mute_state("bsgods_atm_lyr2", true, fade_time);
			user_data.st_driving.atm_is_muted	= true;
			user_data.st_driving.atm_mute_time	= snd_get_secs();
		}
	}
	else if (!user_data.st_driving.atm_is_muted)
	{
		user_data.st_driving.atm_is_muted = true;
		VM2_set_loop_mute_state("bsgods_atm_lyr2", user_data.st_driving.atm_is_muted, 1.0);
	    user_data.st_driving.atm_mute_time = snd_get_secs();
	}
}
//************************************************ END: BLACKSMITH OF THE GODS MUSIC PRESET ************************************************/



// THIS IS DEPRECATED - FUNCTIONS ARE NOW STUBS
AUDIO_PRESETS_MUSIC_MOODS(name, p)
{	
	breakpoint;
	aud_print_warning("CALLING MUSIC_MOODS PRESET USING OLD METHOD!");
}

AUDIO_PRESETS_MUSIC_CUE_GROUPS(name, p)
{
	breakpoint;
	aud_print_warning("CALLING MUSIC_CUE_GROUPS PRESET USING OLD METHOD!");
}


//------------------------------ MUSIC CUES ------------------------------//

AUDIO_PRESETS_MUSIC_CUES(name, p)
{	
	breakpoint;
	aud_print_warning("CALLING MUSIC_CUES PRESET USING OLD METHOD!");
}
