//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
// M70_FLIGHT_AI
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// ===============================================
// FUNCTION INDEX
// ===============================================

// ===============================================
// FLIGHT_AI_VARIABLES
// ===============================================

global short S_banshee_spawn_location 				= 0;
global short S_phantom_spawn_location 				= 0;
global short S_flight_door_wave       				= 0;
global boolean b_move_to_spires								= FALSE;
global short   S_reinforce_spire              = 0;
global boolean b_begin_spire1_bait_stage_1		= FALSE;
global boolean b_begin_spire1_bait_stage_2		= FALSE;
global boolean b_begin_spire2_bait_stage_1    = FALSE;
global boolean b_begin_spire2_bait_stage_2    = FALSE;
global boolean b_turrets_active								= FALSE;


global short S_flight_bait_state = 0;


script static short DEF_FLIGHT_DOOR_WAVE_MAX()  3; end

//===============================================
// FLIGHT_AI
//===============================================

//:: F_FLIGHT_AI_INIT
script dormant f_flight_AI_init()
	dprint( "::: f_flight_AI_init :::" );

end

//:: FLIGHT_AI_DEINIT 
script dormant f_flight_AI_deinit()
	dprint( "::: f_flight_AI_deinit :::" );
	// kill sub modules
	sleep_forever(f_flight_AI_init);
end

script static void f_flight_ai_spawn()
	sleep_until( f_Flight_Zone_Active(), 1);
		if s_flight_state == S_DEF_FLIGHT_STATE_START() then
			wake(f_flight_ai_start_spawn);
		elseif s_flight_state == S_DEF_FLIGHT_STATE_SECOND() then
			wake(f_flight_ai_second_spire_spawn);	
		end

end

script dormant f_flight_ai_start_spawn()
	dprint ("f_flight_spire_bait");
	sleep_until(not b_flight_launch_active, 1);
	ai_place(sg_flight_sp01_air);
	ai_place(sg_flight_sp02_air);
	sleep_s(2);
	thread(f_flight_set_ai_clump());
	//ai_place(sg_flight_sp01_ground);
	//ai_place(sg_flight_sp02_ground);
	//thread(f_flight_ai_start_flight_sp01());
	//thread(f_flight_ai_start_flight_sp02());
	sleep_until(not f_Flight_Zone_Active() and f_spires_state_active(), 1);
	ai_erase(sg_flight_all);
end


script static void f_flight_ai_start_flight_sp01()
	dprint("f_flight_respawn_flight_sp02_air");
	
	local short sp01_phantoms_killed = 0;
	
	
	repeat
		sleep_until(volume_test_players(tv_flight_spire_01_airspace), 1);
		inspect(sp01_phantoms_killed);
		sleep_s(2);
		if	sp01_phantoms_killed < 3 then
			ai_place(sq_flight_sp01_01);
		end
		
		if	sp01_phantoms_killed < 2 then
			ai_place(sq_flight_sp01_02);
		end
		
		if	sp01_phantoms_killed < 1 then
			ai_place(sq_flight_sp01_03);
		end
		sleep_s(3);
		sleep_until( not volume_test_players(tv_flight_spire_01_airspace), 1);
		
		if ai_living_count(sq_flight_sp01_01) == 0 then
			sp01_phantoms_killed = sp01_phantoms_killed + 1;
		end
		
		if ai_living_count(sq_flight_sp01_02) == 0 then
			sp01_phantoms_killed = sp01_phantoms_killed + 1;
		end
		
		if ai_living_count(sq_flight_sp01_03) == 0 then
			sp01_phantoms_killed = sp01_phantoms_killed + 1;
		end
		
		ai_erase(sg_flight_sp01_air);
	until(sp01_phantoms_killed == 3 or not f_Flight_Zone_Active(), 1 );
end



script static void f_flight_ai_start_flight_sp02()
	dprint("f_flight_respawn_flight_sp02_air");

	local short sp02_phantoms_killed = 0;
	
	
	repeat
		sleep_until(volume_test_players(tv_flight_spire_02_airspace), 1);
		inspect(sp02_phantoms_killed);
		sleep_s(1);
		if	sp02_phantoms_killed < 3 then
			ai_place(sq_flight_sp02_01);
		end
		
		if sp02_phantoms_killed < 2 then
			ai_place(sq_flight_sp02_02);
		end
		
		if	sp02_phantoms_killed < 1 then
			ai_place(sq_flight_sp02_03);
		end
		
		sleep_until(not volume_test_players(tv_flight_spire_02_airspace), 1);
		
		if ai_living_count(sq_flight_sp02_01) == 0 then
			sp02_phantoms_killed = sp02_phantoms_killed + 1;
		end

		if ai_living_count(sq_flight_sp02_02) == 0 then
			sp02_phantoms_killed = sp02_phantoms_killed + 1;
		end
		
		if ai_living_count(sq_flight_sp02_03) == 0 then
			sp02_phantoms_killed = sp02_phantoms_killed + 1;
		end
	
		ai_erase(sg_flight_sp02_air);
	
	until(sp02_phantoms_killed == 3 or not f_Flight_Zone_Active(), 1 );
end



script dormant f_flight_ai_second_spire_spawn()
dprint("f_flight_ai_second_spire_spawn");
sleep_until(f_Flight_Zone_Active() , 1);
	if f_spire_state_complete(DEF_SPIRE_02) then
		ai_place(sg_flight_sp01);
	elseif f_spire_state_complete(DEF_SPIRE_01) then
		ai_place(sg_flight_sp02);
	end
	sleep_until(not f_Flight_Zone_current_zoneset(), 1);
	ai_erase(sg_flight_all);
end


script command_script f_cs_give_collision()
	dprint("f_cs_give_collision");
	//vehicle_set_collision_group( ai_vehicle_get(ai_current_actor), "everything" ) ;
	unit_set_ultimate_parent_vehicle_collision_group(ai_current_actor, everything);
end


//RegisterHSFunction(new HaloscriptVoidFunctionDef<1, HSRealParam, _hs_type_real>("ai_designer_clump_perception_range", ai_scripting_set_clump_perception_range, "Override the maximum perception range of designer specified clumps"));

//RegisterHSFunction(new HaloscriptVoidFunctionDef<2, HSAIParam, _hs_type_ai, HSShortParam, _hs_type_short_integer>("ai_set_clump", ai_scripting_set_clump_index, "Force the given AI into a specific clump"));

script static void f_flight_set_ai_clump()
	dprint("f_flight_clump");
	ai_designer_clump_perception_range(350);
	sleep(5);
	ai_set_clump(sq_flight_sp01_01, 1);
	ai_set_clump(sq_flight_sp01_02, 2);
	ai_set_clump(sq_flight_sp01_03, 3);
	ai_set_clump(sq_flight_sp01_04, 4);
	ai_set_clump(sq_flight_sp01_05, 5);
	ai_set_clump(sq_flight_sp02_01, 6);
	ai_set_clump(sq_flight_sp02_02, 7);
	ai_set_clump(sq_flight_sp02_03, 8);
	ai_set_clump(sq_flight_sp02_04, 9);
	ai_set_clump(sq_flight_sp02_05, 10);
end

//======================================
// TURRET DISTANCE PHASING CONTROL
//======================================

global short max_distance = 300;
global short min_distance = 280;

script static void turret_phase_control (ai vehicle_turret, point_reference turret_loc, ai task_name)

local boolean turret_deleted = true;

  repeat
  
  inspect (vehicle_turret);
  
    if ai_living_count (vehicle_turret) == 0 and objects_distance_to_point (players(), turret_loc) < min_distance and ai_task_status (task_name) != (ai_task_status_exhausted) and b_turrets_active then
      ai_place(vehicle_turret);
      //object_hide(ai_vehicle_get(vehicle_turret.turret1));
      object_dissolve_from_marker(ai_vehicle_get(vehicle_turret), "phase_in", "primary_trigger");
      
      effect_new_on_object_marker ("objects\vehicles\forerunner\turrets\storm_anti_vehicle_turret\fx\spr_gravity_lift", ai_vehicle_get(vehicle_turret), "primary_trigger");
      sleep_s(2);
      effect_stop_object_marker ("objects\vehicles\forerunner\turrets\storm_anti_vehicle_turret\fx\spr_gravity_lift", ai_vehicle_get(vehicle_turret), "primary_trigger");

    end
    
    if ((ai_living_count(vehicle_turret) == 1) and objects_distance_to_point (players(), turret_loc) > max_distance) then

      object_dissolve_from_marker(ai_vehicle_get(vehicle_turret), "phase_out", "primary_trigger");
      sleep_s(2);
      
      object_destroy (ai_vehicle_get(vehicle_turret));
      ai_erase(vehicle_turret);
    end
    
  until (1 == 0, 30*5); 

end

