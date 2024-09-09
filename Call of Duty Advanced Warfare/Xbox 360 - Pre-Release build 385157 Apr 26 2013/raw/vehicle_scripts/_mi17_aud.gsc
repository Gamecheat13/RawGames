#include maps\_utility;
#include maps\_shg_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include soundscripts\_audio;
#include soundscripts\_audio_vehicle_manager;
#include soundscripts\_snd;

kMI17_Hover = 5;
	
snd_init_mi17()
{
	VM2_register_callback("facing", ::mi17_input_callback_facing);
	VM2_register_callback("about_to_unload", ::mi17_input_callback_about_to_unload);
	
	snd_message("snd_register_vehicle", "mi17", ::snd_mi17_constructor);
}

snd_start_mi17()
{
	if (IsDefined(self.snd_instance))
	{
		wait( 1.0 );
		snd_stop_mi17( 1.0 );
	}
	
	self thread snd_monitor_about_to_unload();

	args = SpawnStruct();
	args.preset_name = "mi17";
	self snd_message("snd_start_vehicle", args);
}

snd_stop_mi17( fadeout_time_ )
{
	if (IsDefined(self.snd_instance))
	{
		self snd_message( "snd_stop_vehicle", fadeout_time_ );
		self notify( "snd_stop_vehicle" );
	}
}

snd_monitor_about_to_unload()
{
	self endon( "death" );
	self endon( "snd_stop_vehicle" );

	while(1)
	{
		self waittill( "about_to_unload" );
		self.about_to_unload = true;
		self waittill( "unloaded" );
		self.about_to_unload = undefined;
	}
}

snd_mi17_constructor()
{

	VM2_begin_preset_def( "mi17" );	

		// Loop Data
		VM2_begin_loop_data();
	
			VM2_begin_loop_def( "mi17_dist_towards_lp");
				VM2_begin_param_map( "facing", 0.65, 0.65 );
					VM2_add_param_map_env( "volume", "mi17_towards_facing2vol", "mi17_towards_facing2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "mi17_dist_away_lp" );
				VM2_begin_param_map( "facing", 0.65, 0.65 );
					VM2_add_param_map_env( "volume", "mi17_away_facing2vol", "mi17_away_facing2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "mi17_close_towards_lp" );
				VM2_begin_param_map( "facing", 0.65, 0.65 );
					VM2_add_param_map_env( "volume", "mi17_towards_facing2vol", "mi17_towards_facing2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
			
			VM2_begin_loop_def( "mi17_close_away_lp" );
				VM2_begin_param_map( "facing", 0.65, 0.65 );
					VM2_add_param_map_env( "volume", "mi17_away_facing2vol", "mi17_away_facing2vol" );
				VM2_end_param_map();
			VM2_end_loop_def();
				
		VM2_end_loop_data();

		// Oneshot Data
		VM2_begin_oneshot_data(0.5);
		
			VM2_begin_oneshot_def( "mi17_by_in", "mi17_noduck" );
			VM2_end_oneshot_def();
				
			VM2_begin_oneshot_def( "mi17_by_windup", "mi17_noduck" );
			VM2_end_oneshot_def();
		
			VM2_begin_oneshot_def( "mi17_by_out", "mi17_noduck" );
			VM2_end_oneshot_def();
			
		VM2_end_oneshot_data();
		
		// Behavior Data		
		VM2_begin_behavior_data();
		
			VM2_begin_behavior_def( "to_state_hover_initial", ::mi17_condition_callback_to_hover );
				VM2_add_loops( "ALL" );
				VM2_begin_param_map( "speed", 0.65, 0.65 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_unload", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_hover", ::mi17_condition_callback_to_hover, 0.5, 0.5 );
			VM2_begin_behavior_def( "to_state_hover", ::mi17_condition_callback_to_hover );
				VM2_add_oneshots( "mi17_by_in" );
				VM2_begin_param_map( "speed", 0.65, 0.65 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_unload", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_fly_from_hover_initial", ::mi17_condition_callback_to_fly );
				VM2_add_loops( "ALL" );
				VM2_begin_param_map( "speed", 0.65, 0.65 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_unload", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_fly_from_hover", ::mi17_condition_callback_to_fly, 0.5, 0.5 );
			VM2_begin_behavior_def( "to_state_fly_from_hover", ::mi17_condition_callback_to_fly );
				VM2_add_oneshots( "mi17_by_windup" );
				VM2_begin_param_map( "speed", 0.65, 0.65 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_unload", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			VM2_begin_behavior_def( "to_state_fly_from_flyby", ::mi17_condition_callback_to_fly );
				VM2_begin_param_map( "speed", 0.65, 0.65 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_unload", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
			
			// VM2_begin_behavior_def( "to_state_flyby", ::mi17_condition_callback_to_flyby, 0.5, 0.5 );
			VM2_begin_behavior_def( "to_state_flyby", ::mi17_condition_callback_to_flyby );
				VM2_add_oneshots( "mi17_by_out" );
				VM2_begin_param_map( "speed", 0.65, 0.65 );
				VM2_end_param_map();
				VM2_begin_param_map( "about_to_unload", 1.0, 1.0 );
				VM2_end_param_map();
				VM2_begin_param_map( "facing", 1.0, 1.0 );
				VM2_end_param_map();
			VM2_end_behavior_def();
		
		VM2_end_behavior_data();
		
		// State Data
		VM2_begin_state_data();

			VM2_begin_state_group( "engine_oneshots", "state_hover_initial", "to_state_hover_initial", 50, 1.0 );
			
				VM2_begin_state_def( "state_hover_initial", 0.0 );
					VM2_add_state_transition( "state_fly", "to_state_fly_from_hover" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_hover", 0.0 );
					VM2_add_state_transition( "state_fly", "to_state_fly_from_hover" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "state_fly", 0.0 );
					VM2_add_state_transition( "state_hover", "to_state_hover" );
				VM2_end_state_def();
				
			VM2_end_state_group();
			
			VM2_begin_state_group( "flyby", "flyby_1", "to_state_flyby", 50, 1.0 );
			
				VM2_begin_state_def( "flyby_1", 0.0, 50 );
					VM2_add_state_transition( "flyby_2", "to_state_flyby" );
				VM2_end_state_def();
				
				VM2_begin_state_def( "flyby_2", 0.0, 50 );
					VM2_add_state_transition( "flyby_1", "to_state_flyby" );
				VM2_end_state_def();
				
			VM2_end_state_group();
			
		VM2_end_state_data();
		
		// Envelopes
		VM2_add_envelope( "mi17_towards_facing2vol",
			[
				[-0.5,	0.35],
				[0.5,	0.7]
			]
		);
		
		VM2_add_envelope( "mi17_away_facing2vol",	 
			[
	            [-0.5,	0.7],
	            [0.5,	0.175]
  			]
		);
		
		VM2_add_envelope ( "mi17_noduck",
			[
				[0.00,	1.0],
				[1.00,	1.0]
			]
		);
		
	VM2_end_preset_def();
}

////////////////////////
// BEHAVIOR CALLBACKS //
////////////////////////

mi17_input_callback_facing()
{
	vehicle_entity = self VM2x_get_vehicle_entity();

	forward = AnglesToForward( vehicle_entity.angles );
	player_to_heli = VectorNormalize( level.player.origin - vehicle_entity.origin );
	facing = VectorDot( forward, player_to_heli );

	return facing;
}

mi17_input_callback_about_to_unload()
{
	vehicle_entity = self VM2x_get_vehicle_entity();
	return IsDefined(vehicle_entity.about_to_unload);
}

mi17_condition_callback_to_hover(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];
	about_to_unload = curr_smoothed_input_keyed_values["about_to_unload"];

	if (about_to_unload > 0.5 || speed < kMI17_Hover)
	{
		return true;
	}
	
	return false;
}

mi17_condition_callback_to_fly(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];
	about_to_unload = curr_smoothed_input_keyed_values["about_to_unload"];
	
	result = false;

	if (about_to_unload < 0.5 && speed >= kMI17_Hover)
	{
		return true;
	}

	return false;
}

mi17_condition_callback_to_flyby(curr_smoothed_input_keyed_values, vars)
{
	speed = curr_smoothed_input_keyed_values["speed"];
	about_to_unload = curr_smoothed_input_keyed_values["about_to_unload"];
	facing = curr_smoothed_input_keyed_values["facing"];

	result = false;

	if ( !IsDefined( vars.last_flyby_time ) )
	{	
		vars.last_flyby_time = 0;
	}

	if ( IsDefined( vars.last_facing ) )
	{	
		time = GetTime();
	
		if ( vars.last_facing >= 0.0 && facing < 0.0 && about_to_unload < 0.5 && speed > kMI17_Hover && time - vars.last_flyby_time > 3000 )
		{
			vars.last_flyby_time = time;
			result = true;
		}
	}

	vars.last_facing = facing;

	return result;
}
