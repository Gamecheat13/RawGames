//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m30_cryptum_fx
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

//

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m30_cryptum_fx()

	if b_debug then 
		print ("::: M30 - FX :::");
	end
	
	thread(test_fx());
end

script static void test_fx()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
end


// This is used to "turn off" the pylon electricity beam effects after chief pulls the plug
script static void hide_pylon_beam(short s_pylon)
	dprint("Hiding pylon beam");
	pup_play_show(pyelectric_hide);
	
	if (s_pylon == 1) then
		// Kill the beam running through the pylon structure
		effect_kill_from_flag(environments\solo\m30_cryptum\fx\pylon_low\pylon_low.effect, pylon_shaft_fx_1);
		
		// Set the skybox cryptum shield to the next stage
		thread(set_cryptum_shield_stage(2, 2, FALSE));		
	end
	
	if (s_pylon == 2) then
		// Kill the beam running through the pylon structure
		effect_kill_from_flag(environments\solo\m30_cryptum\fx\pylon_low\pylon_low.effect, pylon_shaft_fx_2);
		
		// Set the skybox cryptum shield to the next stage
		thread(set_cryptum_shield_stage(3, 3, FALSE));		
	end
 
end

// Handles applying the correct "stage" of the skybox cryptum shield
script static void set_cryptum_shield_stage(short s_shield, short s_stage, boolean b_wait)
	
	if(b_wait == TRUE) then
		sleep_until(current_zone_set_fully_active() >= 0);
	end
		
	// First turn off everything, since the bsps get reloaded at various points
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage1.effect, fx_cryptum_shield1);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage2.effect, fx_cryptum_shield1);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage3_flares.effect, fx_cryptum_shield1);
	
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage1.effect, fx_cryptum_shield2);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage2.effect, fx_cryptum_shield2);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage2_under.effect, fx_cryptum_shield2);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage3_flares.effect, fx_cryptum_shield2);
	
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage1.effect, fx_cryptum_shield3);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage2.effect, fx_cryptum_shield3);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage2_under.effect, fx_cryptum_shield3);
	effect_kill_from_flag(environments\solo\m30_cryptum\fx\core\core_stage3_flares.effect, fx_cryptum_shield3);
	
	// BSP shield markers set #1
	if (s_shield == 1) then
		if (s_stage == 2) then
			dprint("===Setting cryptum_shield1 effects to stage 2");
			// Apply the effects for stage 2
			effect_new(environments\solo\m30_cryptum\fx\core\core_stage2.effect, fx_cryptum_shield1);
		end
		
		if (s_stage == 3) then
			dprint("===Setting cryptum_shield1 effects to stage 3");
			// Apply the effects for stage 3
			effect_new(environments\solo\m30_cryptum\fx\core\core_stage3_flares.effect, fx_cryptum_shield1);
		end
	end
	
	// BSP shield markers set #2
	if (s_shield == 2) then
		if (s_stage == 1) then
			dprint("===Setting cryptum_shield2 effects to stage 1");
			// Apply the effects for stage 1
			effect_new(environments\solo\m30_cryptum\fx\core\core_stage1.effect, fx_cryptum_shield2);
		end
		
		if (s_stage == 2) then
			dprint("===Setting cryptum_shield2 effects to stage 2");
			// Apply the effects for stage 2
			effect_new(environments\solo\m30_cryptum\fx\core\core_stage2_under.effect, fx_cryptum_shield2);
		end
		
		if (s_stage == 3) then
			dprint("===Setting cryptum_shield2 effects to stage 3");
			// Apply the effects for stage 3
			effect_new(environments\solo\m30_cryptum\fx\core\core_stage3_flares.effect, fx_cryptum_shield2);
		end
	end
	
	// BSP shield markers set #3
	if (s_shield == 3) then
		if (s_stage == 2) then
			dprint("===Setting cryptum_shield3 effects to stage 2");
			// Apply the effects for stage 2
			effect_new(environments\solo\m30_cryptum\fx\core\core_stage2_under.effect, fx_cryptum_shield3);
		end
		
		if (s_stage == 3) then
			dprint("===Setting cryptum_shield3 effects to stage 3");			
			// Apply the effects for stage 3
			effect_new(environments\solo\m30_cryptum\fx\core\core_stage3_flares.effect, fx_cryptum_shield3);
		end
	end
end



// Daisy chain of triggered events for handling the cryptum shield effects following zone set and bsp changes
script dormant cryptshield_1_caves()
	sleep_until (volume_test_players ("begin_zone_set:1_caves"), 1);
	dprint("cryptshield_1_caves_1");
	thread(set_cryptum_shield_stage(2, 1, FALSE));
	sleep_until (volume_test_players ("zone_set:1_caves"), 1);
	dprint("cryptshield_1_caves_2");
	thread(set_cryptum_shield_stage(2, 1, TRUE));
	wake(cryptshield_1_canyon);
end

script dormant cryptshield_1_canyon()
	sleep_until (volume_test_players (tv_insertion_wake_py1_ext), 1);
	dprint("cryptshield_1_canyon_1");
	thread(set_cryptum_shield_stage(2, 1, FALSE));
	sleep_until (volume_test_players ("zone_set:1_canyon"), 1);
	dprint("cryptshield_1_caves_2");
	thread(set_cryptum_shield_stage(2, 1, TRUE));
	wake(cryptshield_1_forts);
end

script dormant cryptshield_1_forts()
	sleep_until (volume_test_players (tv_insertion_wake_py1_forts), 1);
	dprint("cryptshield_1_forts_1");
	thread(set_cryptum_shield_stage(2, 1, FALSE));
	sleep_until (volume_test_players ("zone_set:1_forts"), 1);
	dprint("cryptshield_1_forts_2");
	thread(set_cryptum_shield_stage(2, 1, TRUE));
	wake(cryptshield_1_pylon);
end


script dormant cryptshield_1_pylon()
	sleep_until (volume_test_players ("begin_zone_set:1_pylon"), 1);
	dprint("cryptshield_1_pylon_1");
	thread(set_cryptum_shield_stage(2, 1, FALSE));
	sleep_until (volume_test_players ("zone_set:1_pylon"), 1);
	dprint("cryptshield_1_pylon_2");
	thread(set_cryptum_shield_stage(2, 1, TRUE));
end



script static void obs_fleet_shields_on(object_name cruiser, object_name phantom1, object_name phantom2)
	object_set_function_variable(cruiser, slip_space_shield, 1, 0);
	object_set_function_variable(phantom1, slip_space_shield, 1, 0);
	object_set_function_variable(phantom2, slip_space_shield, 1, 0);
end

script static void obs_fleet_shields_off(object_name cruiser, object_name phantom1, object_name phantom2)
	object_set_function_variable(cruiser, slip_space_shield, 0, 2.0);
	object_set_function_variable(phantom1, slip_space_shield, 0, 2.0);
	object_set_function_variable(phantom2, slip_space_shield, 0, 2.0);
end

script static void clip_obs_fleet(object_name cruiser, object_name phantom1, object_name phantom2, cutscene_flag marker)
	object_set_clip_plane(cruiser, marker);
	object_set_clip_plane(phantom1, marker);
	object_set_clip_plane(phantom2, marker);
end

script static void unclip_obs_fleet(object_name cruiser, object_name phantom1, object_name phantom2)
	object_clear_clip_plane(cruiser);
	object_clear_clip_plane(phantom1);
	object_clear_clip_plane(phantom2);
end
