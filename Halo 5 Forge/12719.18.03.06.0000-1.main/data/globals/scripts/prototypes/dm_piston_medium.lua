-- object dm_piston_medium

--## SERVER

function dm_piston_medium:init()

	local secondsBetweenAnimations = 30.0;

	device_set_power( self, 1 );

	SleepUntil( [| mp_round_started() == true and mp_round_timer_is_paused() == false ], 1 );
	
	-- continue to loop for this amount of time
	repeat
	
		self:animate( secondsBetweenAnimations, secondsBetweenAnimations );
		
	until false;
	
end

function dm_piston_medium:animate( n_down_delay:number, n_up_delay:number )

	local n_down_frame:number = 80.0;
	local n_max_frame:number = 180.0;
	local n_target_pos:number = 0.0

	-- animate down
	print( "Medium Piston; animating down" );
	n_target_pos = n_down_frame / n_max_frame;
	device_set_position( self, n_target_pos );
	
	RunClientScript ("fx_trigger_piston_call");
	RunClientScript ("fx_stop_piston_call");		
	sleep_s( n_down_delay );

	-- animate up
	print( "Medium Piston; animating up" );
	n_target_pos = 1.0;
	device_set_position( self, n_target_pos );
	
	RunClientScript ("fx_trigger_piston_call_down");
	RunClientScript ("fx_stop_piston_call_down");	
	sleep_s( n_up_delay );

end

--## CLIENT


function remoteClient.fx_trigger_piston_call()

	sleep_s (26);
	print ("ALARM");
	
	CreateEffectGroup(EFFECTS.fx_pistons_call_01);
	CreateEffectGroup(EFFECTS.fx_pistons_call_02);
	CreateEffectGroup(EFFECTS.fx_pistons_call_03);
	CreateEffectGroup(EFFECTS.fx_pistons_call_04);
	CreateEffectGroup(EFFECTS.fx_pistons_call_05);
	CreateEffectGroup(EFFECTS.fx_pistons_call_06);
	CreateEffectGroup(EFFECTS.fx_pistons_call_07);
	CreateEffectGroup(EFFECTS.fx_pistons_call_08);
	CreateEffectGroup(EFFECTS.fx_pistons_call_09);
	CreateEffectGroup(EFFECTS.fx_pistons_call_10);
	
	
	interpolator_start ('yellow_warning_slow');
	sleep_s (4);
	interpolator_stop ('yellow_warning_slow');
	interpolator_start ('yellow_warning_fast');
	sleep_s (4);
	interpolator_stop ('yellow_warning_fast');
	
end


function remoteClient.fx_stop_piston_call()

	sleep_s (36);
	print ("stopping ALARM");
	
	StopEffectGroup(EFFECTS.fx_pistons_call_01);
	StopEffectGroup(EFFECTS.fx_pistons_call_02);
	StopEffectGroup(EFFECTS.fx_pistons_call_03);
	StopEffectGroup(EFFECTS.fx_pistons_call_04);
	StopEffectGroup(EFFECTS.fx_pistons_call_05);
	StopEffectGroup(EFFECTS.fx_pistons_call_06);
	StopEffectGroup(EFFECTS.fx_pistons_call_07);
	StopEffectGroup(EFFECTS.fx_pistons_call_08);
	StopEffectGroup(EFFECTS.fx_pistons_call_09);
	StopEffectGroup(EFFECTS.fx_pistons_call_10);	

end

function remoteClient.fx_trigger_piston_call_down()

	sleep_s (28);
	print ("ALARM");
	
	CreateEffectGroup(EFFECTS.fx_pistons_call_01);
	CreateEffectGroup(EFFECTS.fx_pistons_call_02);
	CreateEffectGroup(EFFECTS.fx_pistons_call_03);
	CreateEffectGroup(EFFECTS.fx_pistons_call_04);
	CreateEffectGroup(EFFECTS.fx_pistons_call_05);
	CreateEffectGroup(EFFECTS.fx_pistons_call_06);
	CreateEffectGroup(EFFECTS.fx_pistons_call_07);
	CreateEffectGroup(EFFECTS.fx_pistons_call_08);
	CreateEffectGroup(EFFECTS.fx_pistons_call_09);
	CreateEffectGroup(EFFECTS.fx_pistons_call_10);
	
	
	interpolator_start ('yellow_warning_slow');
	sleep_s (4);
	interpolator_stop ('yellow_warning_slow');
	interpolator_start ('yellow_warning_fast');
	sleep_s (4);
	interpolator_stop ('yellow_warning_fast');
	
end


function remoteClient.fx_stop_piston_call_down()

	sleep_s (38);
	print ("stopping ALARM");
	
	StopEffectGroup(EFFECTS.fx_pistons_call_01);
	StopEffectGroup(EFFECTS.fx_pistons_call_02);
	StopEffectGroup(EFFECTS.fx_pistons_call_03);
	StopEffectGroup(EFFECTS.fx_pistons_call_04);
	StopEffectGroup(EFFECTS.fx_pistons_call_05);
	StopEffectGroup(EFFECTS.fx_pistons_call_06);
	StopEffectGroup(EFFECTS.fx_pistons_call_07);
	StopEffectGroup(EFFECTS.fx_pistons_call_08);
	StopEffectGroup(EFFECTS.fx_pistons_call_09);
	StopEffectGroup(EFFECTS.fx_pistons_call_10);	

end

