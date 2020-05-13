global object g_ics_player= NONE;

script static void activate_plinth( object trigger, unit activator )
	g_ics_player = activator;
	pup_play_show(cryotube);
end

script static void press_button( object trigger, unit activator )
	g_ics_player = activator;
	pup_play_show(button);
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: PLINTH
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_guns_plinth_cortana_rampancy_anim = 				-1;
global real R_guns_plinth_cortana_rampancy_fx_low = 			0.05;	// SET IN Puppeteer
global real R_guns_plinth_cortana_rampancy_fx_medium = 		0.625;
global real R_guns_plinth_cortana_rampancy_fx_high = 			0.8125;
global long L_dlg_lookout_success = 									DEF_DIALOG_ID_NONE();
global short S_dlg_lookout_success_hack_complete_line_index = 3;
global boolean B_guns_turrets_reactivated = 						FALSE;
global long g_cortana_dialog = 0;
global real g_rampancy_chance = 25;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_plinth_cortana_rampancy_anim_roll::: XXX
script static void f_guns_plinth_cortana_rampancy_anim_roll( short s_min, short s_max )
local short s_prev = S_guns_plinth_cortana_rampancy_anim;
	//dprint( "::: f_guns_plinth_cortana_rampancy_anim_roll :::" );
	S_guns_plinth_cortana_rampancy_anim = random_range( s_min, s_max );
	if ( S_guns_plinth_cortana_rampancy_anim == s_prev ) then
		S_guns_plinth_cortana_rampancy_anim = random_range( s_min, s_max );
	end
	//inspect( S_guns_plinth_cortana_rampancy_anim );
end

// === f_guns_plinth_cortana_rampancy_fx_low::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_low()
	dprint( "::: f_guns_plinth_cortana_rampancy_fx_low :::" );
	cortana_rampancy_set( R_guns_plinth_cortana_rampancy_fx_low );
	inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_low_med::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_low_med()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_low_med :::" );
	cortana_rampancy_set( real_random_range(R_guns_plinth_cortana_rampancy_fx_low,R_guns_plinth_cortana_rampancy_fx_medium) );
	//inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_med::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_med()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_med :::" );
	cortana_rampancy_set( R_guns_plinth_cortana_rampancy_fx_medium );
	//inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_med_high::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_med_high()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_med_high :::" );
	cortana_rampancy_set( real_random_range(R_guns_plinth_cortana_rampancy_fx_medium,R_guns_plinth_cortana_rampancy_fx_high) );
	//inspect( cortana_rampancy_get() );
end

// === f_guns_plinth_cortana_rampancy_fx_high::: XXX
script static void f_guns_plinth_cortana_rampancy_fx_high()
	//dprint( "::: f_guns_plinth_cortana_rampancy_fx_high :::" );
	cortana_rampancy_set( R_guns_plinth_cortana_rampancy_fx_high );
	//inspect( cortana_rampancy_get() );
end
 


script static void f_dialog_lookout_success()
dprint("f_dialog_lookout_success");
									
            L_dlg_lookout_success = dialog_start_foreground( "AIRLOCK_2_SYSTEM_LOCKDOWN", L_dlg_lookout_success, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
							dialog_line_chief( L_dlg_lookout_success, 0, TRUE, 'sound\dialog\mission\m80\m80_lookout_00102', FALSE, NONE, 0.0, "", "Master Chief : Dr. Tillson, are you there?" );
							dialog_line_npc( L_dlg_lookout_success, 1, TRUE, 'sound\dialog\mission\m80\m80_lookout_00103', FALSE, NONE, 0.0, "", "Dr. Tillson : I’m here. Any luck?", TRUE);
							dialog_line_chief( L_dlg_lookout_success, 2, TRUE, 'sound\dialog\mission\m80\m80_lookout_00104', FALSE, NONE, 0.0, "", "Master Chief : Cortana’s bringing the defense grid online now." );
							sleep_s( 1.0 );
							dialog_line_cortana( L_dlg_lookout_success, 3, TRUE, 'sound\dialog\mission\m80\m80_lookout_00104a', FALSE, NONE, 0.0, "", "Cortana : That’s it." );
//							sleep_until( B_guns_turrets_fired, 1 );
							dialog_line_npc( L_dlg_lookout_success, 4, TRUE, 'sound\dialog\mission\m80\m80_lookout_00105', FALSE, NONE, 0.0, "", "Dr. Tillson : I hear them! We’ll broadcast the final evac orders.", TRUE);
							dialog_line_chief( L_dlg_lookout_success, 5, TRUE, 'sound\dialog\mission\m80\m80_lookout_00106', FALSE, NONE, 0.0, "", "Master Chief : The nuke?" );
							dialog_line_npc( L_dlg_lookout_success, 6, TRUE, 'sound\dialog\mission\m80\m80_lookout_00107', FALSE, NONE, 0.0, "", "Dr. Tillson : We’re rigging it now. Meet us back on the upper platform and we’ll help you get it to the artifact.", TRUE);
							dialog_line_cortana( L_dlg_lookout_success, 7, TRUE, 'sound\dialog\mission\m80\m80_lookout_00108', FALSE, NONE, 0.0, "", "Cortana : Pull me, Chief." );
            L_dlg_lookout_success = dialog_end( L_dlg_lookout_success, TRUE, TRUE, "" );
				
end

script static real DEF_R_OBJECTIVE_GUNS_PLINTH_INSERT()									09.5;		end
script static real DEF_R_OBJECTIVE_GUNS_PLINTH_REMOVE()									09.7;		end

script static void f_objective_complete( real r_index, boolean b_msg, boolean b_unblip )
	dprint("f_objective_complete");
end

script static void f_turrets_objective_complete()
	dprint("f_turrets_objective_complete");
end

// === f_guns_ai_turrets_action::: Action
// 	NOTE: Triggered in puppeteer
script dormant f_guns_ai_turrets_action()
local short s_target_cnt =		0;
local ai ai_spawn = 					NONE;
	dprint( "::: f_guns_ai_turrets_action :::" );
/*
	// Increase AI LOD	
	ai_lod_full_detail_actors( 24 );

	// set allegiance
	ai_allegiance( spare, human );
	ai_allegiance( spare, covenant );
	ai_allegiance( spare, player );
	ai_allegiance( mule, covenant );
	
	// watch for the turrets to fire
	thread( f_guns_ai_turrets_fired_watch() );

	repeat

		// wait for the need to spawn
		sleep_until( ai_living_count(sg_guns_turrets_targets) < s_guns_turrets_target_min, 1 );

		// collect garbage
		garbage_collect_now();
		
		s_target_cnt = random_range( s_guns_turrets_target_min, s_guns_turrets_target_max ) - ai_living_count( sg_guns_turrets_targets );
		repeat

			if ( ai_spawn_count(sg_guns_turrets_targets) > 0 ) then
				sleep_rand_s( s_guns_turrets_target_delay_min, s_guns_turrets_target_delay_max );
			end
			
			// spawn while preventing double spawning the same one
			begin_random_count( 1 )
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.01 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.02 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.03 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.04 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.05 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.06 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.07 );
				ai_spawn = f_guns_ai_exterior_spawn( sq_guns_turret_targets_01.08 );
			end
		
			if ( ai_spawn != NONE ) then
				// place a targets
				ai_place( ai_spawn );
				s_target_cnt = s_target_cnt - 1;
			
				// decrement lives counter
				if ( s_guns_turrets_target_lives > 0 ) then
					s_guns_turrets_target_lives = s_guns_turrets_target_lives - 1;
				end
			end
			
		until( (s_target_cnt <= 0) or (s_guns_turrets_target_lives == 0), 1 );
	
	until( s_guns_turrets_target_lives == 0, 1 );
*/
end

script static void f_objective_set( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip )
	dprint( "::: f_objective_set :::" );
end

script static boolean f_chance( real r_percent )
	( real_random_range(0.0,100.0) <= r_percent );
end
