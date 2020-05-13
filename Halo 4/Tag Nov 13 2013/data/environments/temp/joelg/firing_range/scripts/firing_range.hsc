//----------------------------
//		Locomotion Tests
//----------------------------

global boolean g_loc_strafe_walk = false;

script command_script cs_locomotion_strafe_1
	print("test");
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		cs_go_to(ps_locomotion_strafe.p0);
		cs_go_to(ps_locomotion_strafe.p1);
		cs_go_to(ps_locomotion_strafe.p0);
		cs_go_to(ps_locomotion_strafe.p1);
		cs_go_to(ps_locomotion_strafe.p0);
		cs_go_to(ps_locomotion_strafe.p1);
	until (false);	//	Adds delay for some reason.
end

script command_script cs_locomotion_strafe_2
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		cs_go_to(ps_locomotion_strafe.p2);
		cs_go_to(ps_locomotion_strafe.p3);
		cs_go_to(ps_locomotion_strafe.p2);
		cs_go_to(ps_locomotion_strafe.p3);
		cs_go_to(ps_locomotion_strafe.p2);
		cs_go_to(ps_locomotion_strafe.p3);
	until (false);	//	Adds delay for some reason.
end

script command_script cs_locomotion_strafe_3
	if g_loc_strafe_walk == true then
		cs_walk(true);
	end
	
	cs_aim(true, ps_locomotion_strafe.aim_point);
	repeat
		//	Forwards
		cs_go_to(ps_locomotion_strafe.p5);
		cs_go_to(ps_locomotion_strafe.p6);
		cs_go_to(ps_locomotion_strafe.p7);
		cs_go_to(ps_locomotion_strafe.p8);
		cs_go_to(ps_locomotion_strafe.p9);
		cs_go_to(ps_locomotion_strafe.p10);
		cs_go_to(ps_locomotion_strafe.p11);
		
		//	And backwards
		cs_go_to(ps_locomotion_strafe.p11);
		cs_go_to(ps_locomotion_strafe.p10);
		cs_go_to(ps_locomotion_strafe.p9);
		cs_go_to(ps_locomotion_strafe.p8);
		cs_go_to(ps_locomotion_strafe.p7);
		cs_go_to(ps_locomotion_strafe.p6);
		cs_go_to(ps_locomotion_strafe.p5);
	until (false);
end


//=========================== weapons_test_target =====================
script static void weapons_test_elite()
	ai_place("target_test_elites");
	cs_run_command_script("target_test_elites", weapon_test);
end

script static void weapons_test_grunt()
	ai_place("target_test_grunts");
	cs_run_command_script("target_test_grunts", weapon_test);
end

script static void weapons_test_jackal()
	ai_place("target_test_jackals");
	cs_run_command_script("target_test_jackals", weapon_test);
end

script static void weapons_test_knight()
	ai_place("target_test_knights");
	cs_run_command_script("target_test_knights", weapon_test);
end

script static void weapons_test_pawn()
	ai_place("target_test_pawns");
	cs_run_command_script("target_test_pawns", weapon_test);
end

script static void weapons_test_bishop()
	ai_place("target_test_bishops");
	cs_run_command_script("target_test_bishops", weapon_test);
end

script static void weapons_test_hunter()
	ai_place("target_test_hunters");
	cs_run_command_script("target_test_hunters", weapon_test);
end

script static void weapons_test_marine()
	ai_place("target_test_marines");
	cs_run_command_script("target_test_marines", weapon_test);
end

script static void weapons_test_fem_marine()
	ai_place("target_test_fem_marines");
	cs_run_command_script("target_test_fem_marines", weapon_test);
end

script static void weapons_test_spartan()
	ai_place("target_test_spartans");
	cs_run_command_script("target_test_spartans", weapon_test);
end

script static void weapons_test_civilian()
	ai_place("target_test_civilians");
	cs_run_command_script("target_test_civilians", weapon_test);
end

script static void weapons_test_fem_civlian()
	ai_place("target_test_fem_civilians");
	cs_run_command_script("target_test_fem_civilians", weapon_test);
end

script command_script weapon_test
	ai_braindead(ai_current_actor, true);
end

//=========================== ai_tests ====================
script static void ai_test_elite_1()
	ai_place("target_test_elites");
end

script static void ai_test_grunt_1()
	ai_place("target_test_grunts");
end

script static void ai_test_jackal_1()
	ai_place("target_test_jackals");
end

script static void ai_test_hunter_1()
	ai_place("target_test_hunters");
end

script static void ai_test_pawn_1()
	ai_place("target_test_pawns");
end

script static void ai_test_bishop_1()
	ai_place("target_test_bishops");
end

script static void ai_test_knight_1()
	ai_place("target_test_knights");
end

script static void ai_test_marine_1()
	ai_place("target_test_marines");
end

script static void ai_test_fem_marine_1()
	ai_place("target_test_fem_marines");
end

script static void ai_test_spartan_1()
	ai_place("target_test_spartans");
end

script static void ai_test_civilians_1()
	ai_place("target_test_civilians");
end


//========== bishop ============================
script static void bishop_31()
	ai_place(standing_bishop.stasis_pistol);
end

script static void bishop_move_31()
	ai_place(move_firing_bishop.stasis_pistol);
end

//========== hunter ============================
script static void hunter_0()
	ai_place(standing_hunter);
end

script static void hunter_move_0()
	ai_place(move_firing_hunter);
end

//========== elite_minor =======================

;=========== elite_minor_1 ====================;
script static void elite_minor_1()
	ai_place(standing_elite_minor.assault_carbine);
end
;=========== elite_minor_move_1 ====================;
script static void elite_minor_move_1()
	ai_place(move_firing_elite_minor.assault_carbine);
end
;=========== elite_minor_c_1 ====================;
script static void elite_minor_c_1()
	ai_place(crouching_elite_minor.assault_carbine);
end

;=========== elite_minor_2 ====================;
script static void elite_minor_2()
	ai_place(standing_elite_minor.beam_rifle);
end
;=========== elite_minor_move_2 ====================;
script static void elite_minor_move_2()
	ai_place(move_firing_elite_minor.beam_rifle);
end
;=========== elite_minor_c_2 ====================;
script static void elite_minor_c_2()
	ai_place(crouching_elite_minor.beam_rifle);
end

;=========== elite_minor_3 ====================;
script static void elite_minor_3()
	ai_place(standing_elite_minor.covenant_carbine);
end
;=========== elite_minor_move_3 ====================;
script static void elite_minor_move_3()
	ai_place(move_firing_elite_minor.covenant_carbine);
end
;=========== elite_minor_c_3 ====================;
script static void elite_minor_c_3()
	ai_place(crouching_elite_minor.covenant_carbine);
end

;=========== elite_minor_4 ====================;
script static void elite_minor_4()
	ai_place(standing_elite_minor.concussion_rifle);
end
;=========== elite_minor_move_4 ====================;
script static void elite_minor_move_4()
	ai_place(move_firing_elite_minor.concussion_rifle);
end
;=========== elite_minor_c_4 ====================;
script static void elite_minor_c_4()
	ai_place(crouching_elite_minor.concussion_rifle);
end

;=========== elite_minor_6 ====================;
script static void elite_minor_6()
	ai_place(standing_elite_minor.needler);
end
;=========== elite_minor_move_6 ====================;
script static void elite_minor_move_6()
	ai_place(move_firing_elite_minor.needler);
end
;=========== elite_minor_c_6 ====================;
script static void elite_minor_c_6()
	ai_place(crouching_elite_minor.needler);
end

;=========== elite_minor_7 ====================;
script static void elite_minor_7()
	ai_place(standing_elite_minor.plasma_pistol);
end
;=========== elite_minor_move_7 ====================;
script static void elite_minor_move_7()
	ai_place(move_firing_elite_minor.plasma_pistol);
end
;=========== elite_minor_c_7 ====================;
script static void elite_minor_c_7()
	ai_place(crouching_elite_minor.plasma_pistol);
end

;=========== elite_minor_8 ====================;
script static void elite_minor_8()
	ai_place(standing_elite_minor.fuel_rod_cannon);
end
;=========== elite_minor_move_8 ====================;
script static void elite_minor_move_8()
	ai_place(move_firing_elite_minor.fuel_rod_cannon);
end
;=========== elite_minor_c_8 ====================;
script static void elite_minor_c_8()
	ai_place(crouching_elite_minor.fuel_rod_cannon);
end

//========== elite_officer =======================

;=========== elite_officer_1 ====================;
script static void elite_officer_1()
	ai_place(standing_elite_officer.assault_carbine);
end
;=========== elite_officer_move_1 ====================;
script static void elite_officer_move_1()
	ai_place(move_firing_elite_officer.assault_carbine);
end
;=========== elite_officer_c_1 ====================;
script static void elite_officer_c_1()
	ai_place(crouching_elite_officer.assault_carbine);
end

;=========== elite_officer_2 ====================;
script static void elite_officer_2()
	ai_place(standing_elite_officer.beam_rifle);
end
;=========== elite_officer_move_2 ====================;
script static void elite_officer_move_2()
	ai_place(move_firing_elite_officer.beam_rifle);
end
;=========== elite_officer_c_2 ====================;
script static void elite_officer_c_2()
	ai_place(crouching_elite_officer.beam_rifle);
end

;=========== elite_officer_3 ====================;
script static void elite_officer_3()
	ai_place(standing_elite_officer.covenant_carbine);
end
;=========== elite_officer_move_3 ====================;
script static void elite_officer_move_3()
	ai_place(move_firing_elite_officer.covenant_carbine);
end
;=========== elite_officer_c_3 ====================;
script static void elite_c_3()
	ai_place(crouching_elite_officer.covenant_carbine);
end

;=========== elite_officer_4 ====================;
script static void elite_officer_4()
	ai_place(standing_elite_officer.concussion_rifle);
end
;=========== elite_officer_move_4 ====================;
script static void elite_officer_move_4()
	ai_place(move_firing_elite_officer.concussion_rifle);
end
;=========== elite_officer_c_4 ====================;
script static void elite_officer_c_4()
	ai_place(crouching_elite_officer.concussion_rifle);
end

;=========== elite_officer_6 ====================;
script static void elite_officer_6()
	ai_place(standing_elite_officer.needler);
end
;=========== elite_officer_move_6 ====================;
script static void elite_officer_move_6()
	ai_place(move_firing_elite_officer.needler);
end
;=========== elite_officer_c_6 ====================;
script static void elite_officer_c_6()
	ai_place(crouching_elite_officer.needler);
end

;=========== elite_officer_7 ====================;
script static void elite_officer_7()
	ai_place(standing_elite_officer.plasma_pistol);
end
;=========== elite_officer_move_7 ====================;
script static void elite_officer_move_7()
	ai_place(move_firing_elite_officer.plasma_pistol);
end
;=========== elite_officer_c_7 ====================;
script static void elite_officer_c_7()
	ai_place(crouching_elite_officer.plasma_pistol);
end

;=========== elite_officer_8 ====================;
script static void elite_officer_8()
	ai_place(standing_elite_officer.fuel_rod_cannon);
end
;=========== elite_officer_move_8 ====================;
script static void elite_officer_move_8()
	ai_place(move_firing_elite_officer.fuel_rod_cannon);
end
;=========== elite_officer_c_8 ====================;
script static void elite_officer_c_8()
	ai_place(crouching_elite_officer.fuel_rod_cannon);
end

//========== elite_zealot =======================

;=========== elite_zealot_1 ====================;
script static void elite_zealot_1()
	ai_place(standing_elite_zealot.assault_carbine);
end
;=========== elite_zealot_move_1 ====================;
script static void elite_zealot_move_1()
	ai_place(move_firing_elite_zealot.assault_carbine);
end
;=========== elite_zealot_c_1 ====================;
script static void elite_zealot_c_1()
	ai_place(crouching_elite_zealot.assault_carbine);
end

;=========== elite_zealot_2 ====================;
script static void elite_zealot_2()
	ai_place(standing_elite_zealot.beam_rifle);
end
;=========== elite_zealot_move_2 ====================;
script static void elite_zealot_move_2()
	ai_place(move_firing_elite_zealot.beam_rifle);
end
;=========== elite_zealot_c_2 ====================;
script static void elite_zealot_c_2()
	ai_place(crouching_elite_zealot.beam_rifle);
end

;=========== elite_zealot_3 ====================;
script static void elite_zealot_3()
	ai_place(standing_elite_zealot.covenant_carbine);
end
;=========== elite_zealot_move_3 ====================;
script static void elite_zealot_move_3()
	ai_place(move_firing_elite_zealot.covenant_carbine);
end
;=========== elite_zealot_c_3 ====================;
script static void elite_zealot_c_3()
	ai_place(crouching_elite_zealot.covenant_carbine);
end

;=========== elite_zealot_4 ====================;
script static void elite_zealot_4()
	ai_place(standing_elite_zealot.concussion_rifle);
end
;=========== elite_zealot_move_4 ====================;
script static void elite_zealot_move_4()
	ai_place(move_firing_elite_zealot.concussion_rifle);
end
;=========== elite_zealot_c_4 ====================;
script static void elite_zealot_c_4()
	ai_place(crouching_elite_zealot.concussion_rifle);
end

;=========== elite_zealot_8 ====================;
script static void elite_zealot_8()
	ai_place(standing_elite_zealot.fuel_rod_cannon);
end
;=========== elite_zealot_move_8 ====================;
script static void elite_zealot_move_8()
	ai_place(move_firing_elite_zealot.fuel_rod_cannon);
end
;=========== elite_zealot_c_8 ====================;
script static void elite_zealot_c_8()
	ai_place(crouching_elite_zealot.fuel_rod_cannon);
end

//========== elite_ranger =======================

;=========== elite_ranger_1 ====================;
script static void elite_ranger_1()
	ai_place(standing_elite_ranger.assault_carbine);
end
;=========== elite_ranger_move_1 ====================;
script static void elite_ranger_move_1()
	ai_place(move_firing_elite_ranger.assault_carbine);
end
;=========== elite_ranger_c_1 ====================;
script static void elite_ranger_c_1()
	ai_place(crouching_elite_ranger.assault_carbine);
end

;=========== elite_ranger_2 ====================;
script static void elite_ranger_2()
	ai_place(standing_elite_ranger.beam_rifle);
end
;=========== elite_ranger_move_2 ====================;
script static void elite_ranger_move_2()
	ai_place(move_firing_elite_ranger.beam_rifle);
end
;=========== elite_ranger_c_2 ====================;
script static void elite_ranger_c_2()
	ai_place(crouching_elite_ranger.beam_rifle);
end

;=========== elite_ranger_3 ====================;
script static void elite_ranger_3()
	ai_place(standing_elite_ranger.covenant_carbine);
end
;=========== elite_ranger_move_3 ====================;
script static void elite_ranger_move_3()
	ai_place(move_firing_elite_ranger.covenant_carbine);
end
;=========== elite_ranger_c_3 ====================;
script static void elite_ranger_c_3()
	ai_place(crouching_elite_ranger.covenant_carbine);
end

;=========== elite_ranger_4 ====================;
script static void elite_ranger_4()
	ai_place(standing_elite_ranger.concussion_rifle);
end
;=========== elite_ranger_move_4 ====================;
script static void elite_ranger_move_4()
	ai_place(move_firing_elite_ranger.concussion_rifle);
end
;=========== elite_ranger_c_4 ====================;
script static void elite_ranger_c_4()
	ai_place(crouching_elite_ranger.concussion_rifle);
end

;=========== elite_ranger_6 ====================;
script static void elite_ranger_6()
	ai_place(standing_elite_ranger.needler);
end
;=========== elite_ranger_move_6 ====================;
script static void elite_ranger_move_6()
	ai_place(move_firing_elite_ranger.needler);
end
;=========== elite_ranger_c_6 ====================;
script static void elite_ranger_c_6()
	ai_place(crouching_elite_ranger.needler);
end

;=========== elite_ranger_7 ====================;
script static void elite_ranger_7()
	ai_place(standing_elite_ranger.plasma_pistol);
end
;=========== elite_ranger_move_7 ====================;
script static void elite_ranger_move_7()
	ai_place(move_firing_elite_ranger.plasma_pistol);
end
;=========== elite_ranger_c_7 ====================;
script static void elite_ranger_c_7()
	ai_place(crouching_elite_ranger.plasma_pistol);
end

;=========== elite_ranger_8 ====================;
script static void elite_ranger_8()
	ai_place(standing_elite_ranger.fuel_rod_cannon);
end
;=========== elite_ranger_move_8 ====================;
script static void elite_ranger_move_8()
	ai_place(move_firing_elite_ranger.fuel_rod_cannon);
end
;=========== elite_ranger_c_8 ====================;
script static void elite_ranger_c_8()
	ai_place(crouching_elite_ranger.fuel_rod_cannon);
end

//========== elite_general =======================

;=========== elite_general_2 ====================;
script static void elite_general_2()
	ai_place(standing_elite_general.beam_rifle);
end
;=========== elite_general_move_2 ====================;
script static void elite_general_move_2()
	ai_place(move_firing_elite_general.beam_rifle);
end
;=========== elite_general_c_2 ====================;
script static void elite_general_c_2()
	ai_place(crouching_elite_general.beam_rifle);
end

;=========== elite_general_4 ====================;
script static void elite_general_4()
	ai_place(standing_elite_general.concussion_rifle);
end
;=========== elite_general_move_4 ====================;
script static void elite_general_move_4()
	ai_place(move_firing_elite_general.concussion_rifle);
end
;=========== elite_general_c_4 ====================;
script static void elite_general_c_4()
	ai_place(crouching_elite_general.concussion_rifle);
end

;=========== elite_general_8 ====================;
script static void elite_general_8()
	ai_place(standing_elite_general.fuel_rod_cannon);
end
;=========== elite_general_move_8 ====================;
script static void elite_general_move_8()
	ai_place(move_firing_elite_general.fuel_rod_cannon);
end
;=========== elite_general_c_8 ====================;
script static void elite_general_c_8()
	ai_place(crouching_elite_general.fuel_rod_cannon);
end

;=========================== grunt_minor_ai_test =====================;

;=========== grunt_minor_6 ====================;
script static void grunt_minor_6()
	ai_place(standing_grunts_minor.needler);
end
;=========== grunt_minor_move_6 ====================;
script static void grunt_minor_move_6()
	ai_place(move_firing_grunts_minor.needler);
end

;=========== grunt_minor_7 ====================;
script static void grunt_minor_7()
	ai_place(standing_grunts_minor.plasma_pistol);
end
;=========== grunt_minor_move_7 ====================;
script static void grunt_minor_move_7()
	ai_place(move_firing_grunts_minor.plasma_pistol);
end

;=========================== grunt_ultra_ai_test =====================;
;=========== grunt_ultra_6 ====================;
script static void grunt_ultra_6()
	ai_place(standing_grunts_ultra.needler);
end
;=========== grunt_ultra_move_6 ====================;
script static void grunt_ultra_move_6()
	ai_place(move_firing_grunts_ultra.needler);
end

;=========== grunt_ultra_8 ====================;
script static void grunt_ultra_8()
	ai_place(standing_grunts_ultra.fuel_rod_cannon);
end
;=========== grunt_ultra_move_8 ====================;
script static void grunt_ultra_move_8()
	ai_place(move_firing_grunts_ultra.fuel_rod_cannon);
end

;=========================== grunt_imperial_ai_test =====================;

;=========== grunt_imperial_6 ====================;
script static void grunt_imperial_6()
	ai_place(standing_grunts_imperial.needler);
end
;=========== grunt_imperial_move_6 ====================;
script static void grunt_imperial_move_6()
	ai_place(move_firing_grunts_imperial.needler);
end

;=========== grunt_imperial_7 ====================;
script static void grunt_imperial_7()
	ai_place(standing_grunts_imperial.plasma_pistol);
end
;=========== grunt_imperial_move_7 ====================;
script static void grunt_imperial_move_7()
	ai_place(move_firing_grunts_imperial.plasma_pistol);
end

;=========== grunt_imperial_8 ====================;
script static void grunt_imperial_8()
	ai_place(standing_grunts_imperial.fuel_rod_cannon);
end
;=========== grunt_imperial_move_8 ====================;
script static void grunt_imperial_move_8()
	ai_place(move_firing_grunts_imperial.fuel_rod_cannon);
end

;=========================== grunt_imperial_ai_test =====================;

;=========== grunt_space_6 ====================;
script static void grunt_space_6()
	ai_place(standing_grunts_space.needler);
end
;=========== grunt_space_move_6 ====================;
script static void grunt_space_move_6()
	ai_place(move_firing_grunts_space.needler);
end

;=========== grunt_space_7 ====================;
script static void grunt_space_7()
	ai_place(standing_grunts_space.plasma_pistol);
end
;=========== grunt_space_move_7 ====================;
script static void grunt_space_move_7()
	ai_place(move_firing_grunts_space.plasma_pistol);
end

;=========== grunt_space_8 ====================;
script static void grunt_space_8()
	ai_place(standing_grunts_space.fuel_rod_cannon);
end
;=========== grunt_space_move_8 ====================;
script static void grunt_space_move_8()
	ai_place(move_firing_grunts_space.fuel_rod_cannon);
end

;=========================== jackal_minor_ai_test =====================;

;=========== jackal_minor_6 ====================;
script static void jackal_minor_6()
	ai_place(standing_jackal_minor.needler);
end
;=========== jackal_minor_move_6 ====================;
script static void jackal_minor_move_6()
	ai_place(move_firing_jackal_minor.needler);
end
;=========== jackal_minor_c_6 ====================;
script static void jackal_minor_c_6()
	ai_place(crouching_jackal_minor.needler);
end
;=========== jackal_minor_c_move_6 ====================;
script static void jackal_minor_c_move_6()
	ai_place(c_move_firing_jackal_minor.needler);
end

;=========== jackal_minor_7 ====================;
script static void jackal_minor_7()
	ai_place(standing_jackal_minor.plasma_pistol);
end
;=========== jackal_minor_move_7 ====================;
script static void jackal_minor_move_7()
	ai_place(move_firing_jackal_minor.plasma_pistol);
end
;=========== jackal_minor_c_7 ====================;
script static void jackal_minor_c_7()
	ai_place(crouching_jackal_minor.plasma_pistol);
end
;=========== jackal_minor_c_move_7 ====================;
script static void jackal_minor_c_move_7()
	ai_place(c_move_firing_jackal_minor.plasma_pistol);
end

;=========================== jackal_major_ai_test =====================;

;=========== jackal_major_6 ====================;
script static void jackal_major_6()
	ai_place(standing_jackal_major.needler);
end
;=========== jackal_major_move_6 ====================;
script static void jackal_major_move_6()
	ai_place(move_firing_jackal_major.needler);
end
;=========== jackal_major_c_6 ====================;
script static void jackal_major_c_6()
	ai_place(crouching_jackal_major.needler);
end
;=========== jackal_major_c_move_6 ====================;
script static void jackal_major_c_move_6()
	ai_place(c_move_firing_jackal_major.needler);
end

;=========== jackal_major_7 ====================;
script static void jackal_major_7()
	ai_place(standing_jackal_major.plasma_pistol);
end
;=========== jackal_major_move_7 ====================;
script static void jackal_major_move_7()
	ai_place(move_firing_jackal_major.plasma_pistol);
end
;=========== jackal_major_c_7 ====================;
script static void jackal_major_c_7()
	ai_place(crouching_jackal_major.plasma_pistol);
end
;=========== jackal_major_c_move_7 ====================;
script static void jackal_major_c_move_7()
	ai_place(c_move_firing_jackal_major.plasma_pistol);
end

;=========================== jackal_ranger_shield_ai_test =====================;

;=========== jackal_ranger_shield_6 ====================;
script static void jackal_ranger_shield_6()
	ai_place(standing_jackal_ranger_shield.needler);
end
;=========== jackal_ranger_shield_move_6 ====================;
script static void jackal_ranger_shield_move_6()
	ai_place(move_firing_jackal_ranger_shiel.needler);
end
;=========== jackal_ranger_shield_c_6 ====================;
script static void jackal_ranger_shield_c_6()
	ai_place(crouching_jackal_ranger_shield.needler);
end
;=========== jackal_ranger_shield_c_move_6 ====================;
script static void jackal_ranger_shield_c_move_6()
	ai_place(c_move_firing_jackal_ranger_shi.needler);
end

;=========== jackal_ranger_shield_7 ====================;
script static void jackal_ranger_shield_7()
	ai_place(standing_jackal_ranger_shield.plasma_pistol);
end
;=========== jackal_ranger_shield_move_7 ====================;
script static void jackal_ranger_shield_move_7()
	ai_place(move_firing_jackal_ranger_shiel.plasma_pistol);
end
;=========== jackal_ranger_shield_c_7 ====================;
script static void jackal_ranger_shield_c_7()
	ai_place(crouching_jackal_ranger_shield.plasma_pistol);
end
;=========== jackal_ranger_shield_c_move_7 ====================;
script static void jackal_ranger_shield_c_move_7()
	ai_place(c_move_firing_jackal_ranger_shi.plasma_pistol);
end

;=========================== jackal_sniper_ai_test =====================;

;=========== jackal_sniper_2 ====================;
script static void jackal_sniper_2()
	ai_place(standing_jackal_sniper.beam_rifle);
end
;=========== jackal_sniper_move_2 ====================;
script static void jackal_sniper_move_2()
	ai_place(move_firing_jackal_sniper.beam_rifle);
end
;=========== jackal_sniper_c_2 ====================;
script static void jackal_sniper_c_2()
	ai_place(crouching_jackal_sniper.beam_rifle);
end
;=========== jackal_sniper_c_move_2 ====================;
script static void jackal_sniper_c_move_2()
	ai_place(c_move_firing_jackal_sniper.beam_rifle);
end

;=========== jackal_sniper_3 ====================;
script static void jackal_sniper_3()
	ai_place(standing_jackal_sniper.covenant_carbine);
end
;=========== jackal_sniper_move_3 ====================;
script static void jackal_sniper_move_3()
	ai_place(move_firing_jackal_sniper.covenant_carbine);
end
;=========== jackal_sniper_c_3 ====================;
script static void jackal_sniper_c_3()
	ai_place(crouching_jackal_sniper.covenant_carbine);
end
;=========== jackal_sniper_c_move_3 ====================;
script static void jackal_sniper_c_move_3()
	ai_place(c_move_firing_jackal_sniper.covenant_carbine);
end

;=========================== jackal_ranger_ai_test =====================;

;=========== jackal_ranger_2 ====================;
script static void jackal_ranger_2()
	ai_place(standing_jackal_ranger.beam_rifle);
end
;=========== jackal_ranger_move_2 ====================;
script static void jackal_ranger_move_2()
	ai_place(move_firing_jackal_ranger.beam_rifle);
end
;=========== jackal_ranger_c_2 ====================;
script static void jackal_ranger_c_2()
	ai_place(crouching_jackal_ranger.beam_rifle);
end
;=========== jackal_ranger_c_move_2 ====================;
script static void jackal_ranger_c_move_2()
	ai_place(c_move_firing_jackal_ranger.beam_rifle);
end

;=========== jackal_ranger_3 ====================;
script static void jackal_ranger_3()
	ai_place(standing_jackal_ranger.covenant_carbine);
end
;=========== jackal_ranger_move_3 ====================;
script static void jackal_ranger_move_3()
	ai_place(move_firing_jackal_ranger.covenant_carbine);
end
;=========== jackal_ranger_c_3 ====================;
script static void jackal_ranger_c_3()
	ai_place(crouching_jackal_ranger.covenant_carbine);
end
;=========== jackal_ranger_c_move_3 ====================;
script static void jackal_ranger_c_move_3()
	ai_place(c_move_firing_jackal_ranger.covenant_carbine);
end

;=========================== marine_ai_test =====================;

;=========== marine_16 ====================;
(script static void marine_16

	(ai_place standing_marines/assault_rifle)
)
;=========== marine_move_16 ====================;
(script static void marine_move_16

	(ai_place move_firing_marines/assault_rifle)
)
;=========== marine_c_16 ====================;
(script static void marine_c_16

	(ai_place crouching_marine/assault_rifle)
)
;=========== marine_c_move_16 ====================;
(script static void marine_c_move_16

	(ai_place c_move_firing_marines/assault_rifle)
)
;=========== marine_17 ====================;
(script static void marine_17

	(ai_place standing_marines/br)
)
;=========== marine_move_17 ====================;
(script static void marine_move_17

	(ai_place move_firing_marines/br)
)
;=========== marine_c_17 ====================;
(script static void marine_c_17

	(ai_place crouching_marine/br)
)
;=========== marine_c_move_17 ====================;
(script static void marine_c_move_17

	(ai_place c_move_firing_marines/br)
)
;=========== marine_18 ====================;
(script static void marine_18

	(ai_place standing_marines/dmr)
)
;=========== marine_move_18 ====================;
(script static void marine_move_18

	(ai_place move_firing_marines/dmr)
)
;=========== marine_c_18 ====================;
(script static void marine_c_18

	(ai_place crouching_marine/dmr)
)
;=========== marine_c_move_18 ====================;
(script static void marine_c_move_18

	(ai_place c_move_firing_marines/dmr)
)
;=========== marine_19 ====================;
(script static void marine_19

	(ai_place standing_marines/lmg)
)
;=========== marine_move_19 ====================;
(script static void marine_move_19

	(ai_place move_firing_marines/lmg)
)
;=========== marine_c_19 ====================;
(script static void marine_c_19

	(ai_place crouching_marine/lmg)
)
;=========== marine_c_move_19 ====================;
(script static void marine_c_move_19

	(ai_place c_move_firing_marines/lmg)
)
;=========== marine_20 ====================;
(script static void marine_20

	(ai_place standing_marines/magnum)
)
;=========== marine_move_20 ====================;
(script static void marine_move_20

	(ai_place move_firing_marines/magnum)
)
;=========== marine_c_20 ====================;
(script static void marine_c_20

	(ai_place crouching_marine/magnum)
)
;=========== marine_c_move_20 ====================;
(script static void marine_c_move_20

	(ai_place c_move_firing_marines/magnum)
)
;=========== marine_21 ====================;
(script static void marine_21

	(ai_place standing_marines/rail_gun)
)
;=========== marine_move_21 ====================;
(script static void marine_move_21

	(ai_place move_firing_marines/rail_gun)
)
;=========== marine_c_21 ====================;
(script static void marine_c_21

	(ai_place crouching_marine/rail_gun)
)
;=========== marine_c_move_21 ====================;
(script static void marine_c_move_21

	(ai_place c_move_firing_marines/rail_gun)
)
;=========== marine_22 ====================;
(script static void marine_22

	(ai_place standing_marines/rocket_launcher)
)
;=========== marine_move_22 ====================;
(script static void marine_move_22

	(ai_place move_firing_marines/rocket_launcher)
)
;=========== marine_c_22 ====================;
(script static void marine_c_22

	(ai_place crouching_marine/rocket_launcher)
)
;=========== marine_c_move_22 ====================;
(script static void marine_c_move_22

	(ai_place c_move_firing_marines/rocket_launcher)
)
;=========== marine_23 ====================;
(script static void marine_23

	(ai_place standing_marines/shotgun)
)
;=========== marine_move_23 ====================;
(script static void marine_move_23

	(ai_place move_firing_marines/shotgun)
)
;=========== marine_c_23 ====================;
(script static void marine_c_23

	(ai_place crouching_marine/shotgun)
)
;=========== marine_c_move_23 ====================;
(script static void marine_c_move_23

	(ai_place c_move_firing_marines/shotgun)
)
;=========== marine_24 ====================;
(script static void marine_24

	(ai_place standing_marines/sniper_rifle)
)
;=========== marine_move_24 ====================;
(script static void marine_move_24

	(ai_place move_firing_marines/sniper_rifle)
)
;=========== marine_c_24 ====================;
(script static void marine_c_24

	(ai_place crouching_marine/sniper_rifle)
)
;=========== marine_c_move_24 ====================;
(script static void marine_c_move_24

	(ai_place c_move_firing_marines/sniper_rifle)
)
;=========== marine_26 ====================;
(script static void marine_26

	(ai_place standing_marines/sticky_detonator)
)
;=========== marine_move_26 ====================;
(script static void marine_move_26

	(ai_place move_firing_marines/sticky_detonator)
)
;=========== marine_c_26 ====================;
(script static void marine_c_26

	(ai_place crouching_marine/sticky_detonator)
)
;=========== marine_c_move_26 ====================;
(script static void marine_c_move_26

	(ai_place c_move_firing_marines/sticky_detonator)
)

;=========================== fem_marine_ai_test =====================;

;=========== fem_marine_16 ====================;
(script static void fem_marine_16

	(ai_place standing_female_marines/assault_rifle)
)
;=========== fem_marine_move_16 ====================;
(script static void fem_marine_move_16

	(ai_place move_firing_fem_marines/assault_rifle)
)
;=========== fem_marine_c_16 ====================;
(script static void fem_marine_c_16

	(ai_place crouching_fem_marines/assault_rifle)
)
;=========== fem_marine_c_move_16 ====================;
(script static void fem_marine_c_move_16

	(ai_place c_move_firing_fem_marines/assault_rifle)
)
;=========== fem_marine_17 ====================;
(script static void fem_marine_17

	(ai_place standing_female_marines/br)
)
;=========== fem_marine_move_17 ====================;
(script static void fem_marine_move_17

	(ai_place move_firing_fem_marines/br)
)
;=========== fem_marine_c_17 ====================;
(script static void fem_marine_c_17

	(ai_place crouching_fem_marines/br)
)
;=========== fem_marine_c_move_17 ====================;
(script static void fem_marine_c_move_17

	(ai_place c_move_firing_fem_marines/br)
)
;=========== fem_marine_18 ====================;
(script static void fem_marine_18

	(ai_place standing_female_marines/dmr)
)
;=========== fem_marine_move_18 ====================;
(script static void fem_marine_move_18

	(ai_place move_firing_fem_marines/dmr)
)
;=========== fem_marine_c_18 ====================;
(script static void fem_marine_c_18

	(ai_place crouching_fem_marines/dmr)
)
;=========== fem_marine_c_move_18 ====================;
(script static void fem_marine_c_move_18

	(ai_place c_move_firing_fem_marines/dmr)
)
;=========== fem_marine_19 ====================;
(script static void fem_marine_19

	(ai_place standing_female_marines/lmg)
)
;=========== fem_marine_move_19 ====================;
(script static void fem_marine_move_19

	(ai_place move_firing_fem_marines/lmg)
)
;=========== fem_marine_c_19 ====================;
(script static void fem_marine_c_19

	(ai_place crouching_fem_marines/lmg)
)
;=========== fem_marine_c_move_19 ====================;
(script static void fem_marine_c_move_19

	(ai_place c_move_firing_fem_marines/lmg)
)
;=========== fem_marine_20 ====================;
(script static void fem_marine_20

	(ai_place standing_female_marines/magnum)
)
;=========== fem_marine_move_20 ====================;
(script static void fem_marine_move_20

	(ai_place move_firing_fem_marines/magnum)
)
;=========== fem_marine_c_20 ====================;
(script static void fem_marine_c_20

	(ai_place crouching_fem_marines/magnum)
)
;=========== fem_marine_c_move_20 ====================;
(script static void fem_marine_c_move_20

	(ai_place c_move_firing_fem_marines/magnum)
)
;=========== fem_marine_21 ====================;
(script static void fem_marine_21

	(ai_place standing_female_marines/rail_gun)
)
;=========== fem_marine_move_21 ====================;
(script static void fem_marine_move_21

	(ai_place move_firing_fem_marines/rail_gun)
)
;=========== fem_marine_c_21 ====================;
(script static void fem_marine_c_21

	(ai_place crouching_fem_marines/rail_gun)
)
;=========== fem_marine_c_move_21 ====================;
(script static void fem_marine_c_move_21

	(ai_place c_move_firing_fem_marines/rail_gun)
)
;=========== fem_marine_22 ====================;
(script static void fem_marine_22

	(ai_place standing_female_marines/rocket_launcher)
)
;=========== fem_marine_move_22 ====================;
(script static void fem_marine_move_22

	(ai_place move_firing_fem_marines/rocket_launcher)
)
;=========== fem_marine_c_22 ====================;
(script static void fem_marine_c_22

	(ai_place crouching_fem_marines/rocket_launcher)
)
;=========== fem_marine_c_move_22 ====================;
(script static void fem_marine_c_move_22

	(ai_place c_move_firing_fem_marines/rocket_launcher)
)
;=========== fem_marine_23 ====================;
(script static void fem_marine_23

	(ai_place standing_female_marines/shotgun)
)
;=========== fem_marine_move_23 ====================;
(script static void fem_marine_move_23

	(ai_place move_firing_fem_marines/shotgun)
)
;=========== fem_marine_c_23 ====================;
(script static void fem_marine_c_23

	(ai_place crouching_fem_marines/shotgun)
)
;=========== fem_marine_c_move_23 ====================;
(script static void fem_marine_c_move_23

	(ai_place c_move_firing_fem_marines/shotgun)
)
;=========== fem_marine_24 ====================;
(script static void fem_marine_24

	(ai_place standing_female_marines/sniper_rifle)
)
;=========== fem_marine_move_24 ====================;
(script static void fem_marine_move_24

	(ai_place move_firing_fem_marines/sniper_rifle)
)
;=========== fem_marine_c_24 ====================;
(script static void fem_marine_c_24

	(ai_place crouching_fem_marines/sniper_rifle)
)
;=========== fem_marine_c_move_24 ====================;
(script static void fem_marine_c_move_24

	(ai_place c_move_firing_fem_marines/sniper_rifle)
)
;=========== fem_marine_26 ====================;
(script static void fem_marine_26

	(ai_place standing_female_marines/sticky_detonator)
)
;=========== fem_marine_move_26 ====================;
(script static void fem_marine_move_26

	(ai_place move_firing_fem_marines/sticky_detonator)
)
;=========== fem_marine_c_26 ====================;
(script static void fem_marine_c_26

	(ai_place crouching_fem_marines/sticky_detonator)
)
;=========== fem_marine_c_move_26 ====================;
(script static void fem_marine_c_move_26

	(ai_place c_move_firing_fem_marines/sticky_detonator)
)

;=========================== spartan_ai_test =====================;
script static void spartan_1()
	ai_place("standing_spartans/assault_carbine");
end

script static void spartan_2()
	ai_place("standing_spartans/beam_rifle");
end

script static void spartan_3()
	ai_place("standing_spartans/covenant_carbine");
end

script static void spartan_4()
	ai_place("standing_spartans/concussion_rifle");
end

script static void spartan_6()
	ai_place("standing_spartans/needler");
end

script static void spartan_7()
	ai_place("standing_spartans/plasma_pistol");
end

script static void spartan_8()
	ai_place("standing_spartans/fuel_rod_cannon");
end

script static void spartan_9()
	ai_place("standing_spartans/attach_beam");
end

script static void spartan_14()
	ai_place("standing_spartans/spread_gun");
end

script static void spartan_16()
	ai_place("standing_spartans/assault_rifle");
end

script static void spartan_17()
	ai_place("standing_spartans/br");
end

script static void spartan_18()
	ai_place("standing_spartans/dmr");
end

script static void spartan_19()
	ai_place("standing_spartans/lmg");
end

script static void spartan_20()
	ai_place("standing_spartans/magnum");
end

script static void spartan_21()
	ai_place("standing_spartans/rail_gun");
end

script static void spartan_22()
	ai_place("standing_spartans/rocket_launcher");
end

script static void spartan_23()
	ai_place("standing_spartans/shotgun");
end

script static void spartan_24()
	ai_place("standing_spartans/sniper_rifle");
end

script static void spartan_25()
	ai_place("standing_spartans/spartan_laser");
end

script static void spartan_26()
	ai_place("standing_spartans/sticky_detonator");
end

script static void spartan_c_1()
	ai_place("crouching_spartans/assault_carbine");
end

script static void spartan_c_2()
	ai_place("crouching_spartans/beam_rifle");
end

script static void spartan_c_3()
	ai_place("crouching_spartans/covenant_carbine");
end

script static void spartan_c_4()
	ai_place("crouching_spartans/concussion_rifle");
end

script static void spartan_c_6()
	ai_place("crouching_spartans/needler");
end

script static void spartan_c_7()
	ai_place("crouching_spartans/plasma_pistol");
end

script static void spartan_c_8()
	ai_place("crouching_spartans/fuel_rod_cannon");
end

script static void spartan_c_9()
	ai_place("crouching_spartans/attach_beam");
end

script static void spartan_c_14()
	ai_place("crouching_spartans/spread_gun");
end

script static void spartan_c_16()
	ai_place("crouching_spartans/assault_rifle");
end

script static void spartan_c_17()
	ai_place("crouching_spartans/br");
end

script static void spartan_c_18()
	ai_place("crouching_spartans/dmr");
end

script static void spartan_c_19()
	ai_place("crouching_spartans/lmg");
end

script static void spartan_c_20()
	ai_place("crouching_spartans/magnum");
end

script static void spartan_c_21()
	ai_place("crouching_spartans/rail_gun");
end

script static void spartan_c_22()
	ai_place("crouching_spartans/rocket_launcher");
end

script static void spartan_c_23()
	ai_place("crouching_spartans/shotgun");
end

script static void spartan_c_24()
	ai_place("crouching_spartans/sniper_rifle");
end

script static void spartan_c_25()
	ai_place("crouching_spartans/spartan_laser");
end

script static void spartan_c_26()
	ai_place("crouching_spartans/sticky_detonator");
end

script static void spartan_move_1()
	ai_place("move_firing_spartans/assault_carbine");
end

script static void spartan_move_2()
	ai_place("move_firing_spartans/beam_rifle");
end

script static void spartan_move_3()
	ai_place("move_firing_spartans/covenant_carbine");
end

script static void spartan_move_4()
	ai_place("move_firing_spartans/concussion_rifle");
end

script static void spartan_move_6()
	ai_place("move_firing_spartans/needler");
end

script static void spartan_move_7()
	ai_place("move_firing_spartans/plasma_pistol");
end

script static void spartan_move_8()
	ai_place("move_firing_spartans/fuel_rod_cannon");
end

script static void spartan_move_9()
	ai_place("move_firing_spartans/attach_beam");
end

script static void spartan_move_14()
	ai_place("move_firing_spartans/spread_gun");
end

script static void spartan_move_16()
	ai_place("move_firing_spartans/assault_rifle");
end

script static void spartan_move_17()
	ai_place("move_firing_spartans/br");
end

script static void spartan_move_18()
	ai_place("move_firing_spartans/dmr");
end

script static void spartan_move_19()
	ai_place("move_firing_spartans/lmg");
end

script static void spartan_move_20()
	ai_place("move_firing_spartans/magnum");
end

script static void spartan_move_21()
	ai_place("move_firing_spartans/rail_gun");
end

script static void spartan_move_22()
	ai_place("move_firing_spartans/rocket_launcher");
end

script static void spartan_move_23()
	ai_place("move_firing_spartans/shotgun");
end

script static void spartan_move_24()
	ai_place("move_firing_spartans/sniper_rifle");
end

script static void spartan_move_25()
	ai_place("move_firing_spartans/spartan_laser");
end

script static void spartan_move_26()
	ai_place("move_firing_spartans/sticky_detonator");
end

script static void spartan_c_move_1()
	ai_place("c_move_firing_spartans/assault_carbine");
end

script static void spartan_c_move_2()
	ai_place("c_move_firing_spartans/beam_rifle");
end

script static void spartan_c_move_3()
	ai_place("c_move_firing_spartans/covenant_carbine");
end

script static void spartan_c_move_4()
	ai_place("c_move_firing_spartans/concussion_rifle");
end

script static void spartan_c_move_6()
	ai_place("c_move_firing_spartans/needler");
end

script static void spartan_c_move_7()
	ai_place("c_move_firing_spartans/plasma_pistol");
end

script static void spartan_c_move_8()
	ai_place("c_move_firing_spartans/fuel_rod_cannon");
end

script static void spartan_c_move_9()
	ai_place("c_move_firing_spartans/attach_beam");
end

script static void spartan_c_move_11()
	ai_place("c_move_firing_spartans/forerunner_smg");
end

script static void spartan_c_move_12()
	ai_place("c_move_firing_spartans/forerunner_rifle");
end

script static void spartan_c_move_13()
	ai_place("c_move_firing_spartans/spread_gun");
end

script static void spartan_c_move_14()
	ai_place("c_move_firing_spartans/incineration_launcher");
end

script static void spartan_c_move_16()
	ai_place("c_move_firing_spartans/assault_rifle");
end

script static void spartan_c_move_17()
	ai_place("c_move_firing_spartans/br");
end

script static void spartan_c_move_18()
	ai_place("c_move_firing_spartans/dmr");
end

script static void spartan_c_move_19()
	ai_place("c_move_firing_spartans/lmg");
end

script static void spartan_c_move_20()
	ai_place("c_move_firing_spartans/magnum");
end

script static void spartan_c_move_21()
	ai_place("c_move_firing_spartans/rail_gun");
end

script static void spartan_c_move_22()
	ai_place("c_move_firing_spartans/rocket_launcher");
end

script static void spartan_c_move_23()
	ai_place("c_move_firing_spartans/shotgun");
end

script static void spartan_c_move_24()
	ai_place("c_move_firing_spartans/sniper_rifle");
end

script static void spartan_c_move_25()
	ai_place("c_move_firing_spartans/spartan_laser");
end

script static void spartan_c_move_26()
	ai_place("c_move_firing_spartans/sticky_detonator");
end


;=========================== knight_ai_test =====================;


;=========== knight_11 ====================;
script static void knight_11()

	ai_place("standing_knight/forerunner_smg");
end

;=========== knight_move_11 ====================;
script static void knight_move_11()

	ai_place("move_firing_knight/forerunner_smg");
end

;=========== knight_c_11 ====================;
script static void knight_c_11()

	ai_place("crouching_knight/forerunner_smg");
end

;=========== knight_c_move_11 ====================;
script static void knight_c_move_11()

	ai_place("c_move_firing_knight/forerunner_smg");
end

;=========== knight_12 ====================;
script static void knight_12()

	ai_place("standing_knight/forerunner_rifle");
end

;=========== knight_move_12 ====================;
script static void knight_move_12()

	ai_place("move_firing_knight/forerunner_rifle");
end

;=========== knight_c_12 ====================;
script static void knight_c_12()

	ai_place("crouching_knight/forerunner_rifle");
end

;=========== knight_c_move_12 ====================;
script static void knight_c_move_12()

	ai_place("c_move_firing_knight/forerunner_rifle");
end

;=========== knight_14 ====================;
script static void knight_14()

	ai_place("standing_knight/spread_gun");
end

;=========== knight_move_14 ====================;
script static void knight_move_14()

	ai_place("move_firing_knight/spread_gun");
end

;=========== knight_c_14 ====================;
script static void knight_c_14()

	ai_place("crouching_knight/spread_gun");
end

;=========== knight_c_move_14 ====================;
script static void knight_c_move_14()

	ai_place("c_move_firing_knight/spread_gun");
end

;=========================== knight_battlewagon_ai_test =====================;

;=========== knight_battlewagon_11 ====================;
script static void knight_battlewagon_11()

	ai_place("standing_knight_battlewagon/forerunner_smg");
end

;=========== knight_battlewagon_move_11 ====================;
script static void knight_battlewagon_move_11()

	ai_place("move_firing_knight_battlewagon/forerunner_smg");
end

;=========== knight_battlewagon_c_11 ====================;
script static void knight_battlewagon_c_11()

	ai_place("crouching_knight_battlewagon/forerunner_smg");
end

;=========== knight_battlewagon_c_move_11 ====================;
script static void knight_battlewagon_c_move_11()

	ai_place("c_move_firing_knight_battlewago/forerunner_smg");
end

;=========== knight_battlewagon_14 ====================;
script static void knight_battlewagon_14()

	ai_place("standing_knight_battlewagon/spread_gun");
end

;=========== knight_battlewagon_move_14 ====================;
script static void knight_battlewagon_move_14()

	ai_place("move_firing_knight_battlewagon/spread_gun");
end

;=========== knight_battlewagon_c_14 ====================;
script static void knight_battlewagon_c_14()

	ai_place("crouching_knight_battlewagon/spread_gun");
end

;=========== knight_battlewagon_c_move_14 ====================;
script static void knight_battlewagon_c_move_14()

	ai_place("c_move_firing_knight_battlewago/spread_gun");
end

;=========================== knight_ranger_ai_test =====================;

;=========== knight_ranger_12 ====================;
script static void knight_ranger_12()

	ai_place("standing_knight_ranger/forerunner_rifle");
end

;=========== knight_ranger_move_12 ====================;
script static void knight_ranger_move_12()

	ai_place("move_firing_knight_ranger/forerunner_rifle");
end

;=========== knight_ranger_c_12 ====================;
script static void knight_ranger_c_12()

	ai_place("crouching_knight_ranger/forerunner_rifle");
end

;=========== knight_ranger_c_move_12 ====================;
script static void knight_ranger_c_move_12()

	ai_place("c_move_firing_knight_ranger/forerunner_rifle");
end

;=========== knight_ranger_9 ====================;
script static void knight_ranger_9()

	ai_place("standing_knight_ranger/attach_beam");
end

;=========== knight_ranger_move_9 ====================;
script static void knight_ranger_move_9()

	ai_place("move_firing_knight_ranger/attach_beam");
end

;=========== knight_ranger_c_9 ====================;
script static void knight_ranger_c_9()

	ai_place("crouching_knight_ranger/attach_beam");
end

;=========== knight_ranger_c_move_9 ====================;
script static void knight_ranger_c_move_9()

	ai_place("c_move_firing_knight_ranger/attach_beam");
end

;=========================== knight_commander_ai_test =====================;

;=========== knight_commander_12 ====================;
script static void knight_commander_12()

	ai_place("standing_knight_commander/forerunner_rifle");
end

;=========== knight_commander_move_12 ====================;
script static void knight_commander_move_12()

	ai_place("move_firing_knight_commander/forerunner_rifle");
end

;=========== knight_commander_c_12 ====================;
script static void knight_commander_c_12()

	ai_place("crouching_knight_commander/forerunner_rifle");
end

;=========== knight_commander_c_move_12 ====================;
script static void knight_commander_c_move_12()

	ai_place("c_move_firing_knight_commander/forerunner_rifle");
end

;=========== knight_commander_13 ====================;
script static void knight_commander_13()

	ai_place("standing_knight_commander/incineration_launcher");
end

;=========== knight_commander_move_13 ====================;
script static void knight_commander_move_13()

	ai_place("move_firing_knight_commander/incineration_launcher");
end

;=========== knight_commander_c_13 ====================;
script static void knight_commander_c_13()

	ai_place("crouching_knight_commander/incineration_launcher");
end

;=========== knight_commander_c_move_13 ====================;
script static void knight_commander_c_move_13()

	ai_place("c_move_firing_knight_commander/incineration_launcher");
end

;=========================== pawn_minor_ai_test =====================;
;=========== pawn_minor_31 ====================;
script static void pawn_minor_31()
	ai_place(standing_pawn_minor.stasis_pistol);
end

;=========== pawn_move_31 ====================;
script static void pawn_minor_move_31()
	ai_place(move_firing_pawn_minor.stasis_pistol);
end

;=========== pawn_minor_11 ====================;
script static void pawn_minor_11()
	ai_place(standing_pawn_minor.forerunner_smg);
end

;=========== pawn_move_11 ====================;
script static void pawn_minor_move_11()
	ai_place(move_firing_pawn_minor.forerunner_smg);
end

;=========================== pawn_prime_ai_test =====================;
;=========== pawn_prime_31 ====================;
script static void pawn_prime_31()
	ai_place(standing_pawn_prime.stasis_pistol);
end

;=========== pawn_move_31 ====================;
script static void pawn_prime_move_31()
	ai_place(move_firing_pawn_prime.stasis_pistol);
end

;=========== pawn_prime_11 ====================;
script static void pawn_prime_11()
	ai_place(standing_pawn_prime.forerunner_smg);
end

;=========== pawn_move_11 ====================;
script static void pawn_prime_move_11()
	ai_place(move_firing_pawn_prime.forerunner_smg);
end

;=========================== pawn_sniper_ai_test =====================;
;=========== pawn_sniper_9 ====================;
script static void pawn_sniper_9()
	ai_place(standing_pawn_sniper.attach_beam);
end

;=========== pawn_move_9 ====================;
script static void pawn_sniper_move_9()
	ai_place(move_firing_pawn_sniper.attach_beam);
end

;=========== aimtest script ======================;

(script command_script firing_range

(print "Firing Forward")
	(sleep 30)
(print "Center Wall Top Left")
	(sleep 90)
	(cs_aim_object 1 center_wall_top_left)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_left)
	(sleep 90)
(print "Center Wall Top Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_center)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_center)
	(sleep 90)
(print "Center Wall Top Right")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_right)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_right)
	(sleep 90)
(print "Center Wall Bottom Left")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_left)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_left)
	(sleep 90)
(print "Center Wall Bottom Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_center)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_center)
	(sleep 90)
(print "Center Wall Bottom Right")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_right)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_right)
	(sleep 90)
(print "Rotating between Targets")

	(sleep 90)
(print "Left Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 left_wall_top_left)	
	(sleep 30)
	(cs_shoot 1 left_wall_top_left)
	(sleep 90)
(print "Right Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 right_wall_top_left)	
	(sleep 30)
	(cs_shoot 1 right_wall_top_left)
	(sleep 90)
(print "Center Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_left)
	(sleep 30)
	(cs_shoot 1 center_wall_top_left)
	(sleep 90)
(print "Above Crate Front")
	(sleep 30)
	(cs_aim_object 1 above_crate_front)			
	(sleep 30)
	(cs_shoot 1 above_crate_front)
	(sleep 90)
(print "Above Crate Back")
	(sleep 30)
	(cs_aim_object 1 above_crate_back)	
	(sleep 30)
	(cs_shoot 1 above_crate_back)
	(sleep 90)
(print "Center Wall Bottom Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_center)			
	(sleep 30)
	(cs_shoot 1 center_wall_bot_center)
	(sleep 90)

	(ai_erase_all)
)

;=========== moveaimtest script ======================;

(script command_script move_firing_range

	(sleep 30)
(print "Move-Back : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(sleep 60)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(sleep 60)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(sleep 60)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)


	(sleep 120)
	(ai_erase_all)
)

;=========== crouch move aimtest script ======================;

(script command_script c_move_firing_range
	(cs_crouch 1)
	(sleep 30)
(print "Move-Back : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(sleep 60)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Level")
	(cs_shoot 1 move_mid_front)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Level")
	(cs_shoot 1 move_mid_front_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Level")
	(cs_shoot 1 move_mid_front_left)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_mid_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Level")
	(cs_shoot 1 move_mid_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(sleep 60)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Down")
	(cs_shoot 1 move_bot_front)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Down")
	(cs_shoot 1 move_bot_front_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Down")
	(cs_shoot 1 move_bot_front_left)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_bot_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Down")
	(cs_shoot 1 move_bot_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)

(print "Move-Back : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(sleep 60)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-Forward : Angle-Up")
	(cs_shoot 1 move_top_front)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_front_right)
	(sleep 60)
(print "Move-Back : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardRight : Angle-Up")
	(cs_shoot 1 move_top_front_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_front_left)
	(sleep 60)
(print "Move-Back : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Forward : Shoot-ForwardLeft : Angle-Up")
	(cs_shoot 1 move_top_front_left)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)
	(cs_shoot 1 move_top_right)
	(sleep 120)
(print "Move-Right : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(cs_move_towards_point point.mid_back 0.05)
	(sleep 60)
(print "Move-Left : Shoot-ForwardRange : Angle-Up")
	(cs_shoot 1 move_top_right)
	(cs_move_towards_point point.mid_front 0.05)
	(sleep 60)


	(sleep 120)
	(ai_erase_all)
)

;=============== reset test case =================;

script static void start_over()
	kill_active_scripts();
	object_destroy(hog_1);
	object_destroy(banshee_1);
	object_destroy(ghost_1);
	object_destroy(scorpion_1);
	object_destroy(wraith_1);
	object_destroy(revenant_1);
	object_destroy(mongoose_1);
	ai_erase_all();
end


;============================== RANGE WRAITH AND WARTHOG ===========================;

;=========== elite wraith script ======================;

script static void firetest_wraith_2()
	ai_place("Wraith_test_elites");
end

;=========== spartan wraith script ======================;

script static void firetest_wraith_5()
	ai_place("Wraith_test_spartans");
end

;=========== marine warthog script ======================;

script static void firetest_warthog_1()
	ai_place("warthog_test_troopers");
end


;=========== spartan warthog script ======================;

script static void firetest_warthog_5()
	ai_place("warthog_test_spartans");
end

script command_Script vehicle_driver_test
	ai_braindead(ai_current_actor, true);
end

;=========== aimtest script ======================;

(script command_script standing_vehicle

(print "Firing Above")
	(sleep 60)
(print "Above back left side")
	(sleep 60)
	(cs_aim_object 1 veh_above_left_back)	
	(sleep 60)
	(cs_shoot 1 veh_above_left_back)
	(sleep 60)
(print "Above right front")
	(sleep 60)
	(cs_aim_object 1 veh_above_right_front)	
	(sleep 60)
	(cs_shoot 1 veh_above_right_front)
	(sleep 60)
(print "Above left front")
	(sleep 60)
	(cs_aim_object 1 veh_above_left_front)	
	(sleep 60)
	(cs_shoot 1 veh_above_left_front)
	(sleep 60)
(print "Above back right side")
	(sleep 60)
	(cs_aim_object 1 veh_above_right_back)	
	(sleep 60)
	(cs_shoot 1 veh_above_right_back)
	(sleep 60)
(print "Above middle mid")
	(sleep 60)
	(cs_aim_object 1 veh_above_mid_mid)	
	(sleep 60)
	(cs_shoot 1 veh_above_mid_mid)
	(sleep 60)
(print "Above middle back")
	(sleep 60)
	(cs_aim_object 1 veh_above_mid_back)	
	(sleep 60)
	(cs_shoot 1 veh_above_mid_back)
	(sleep 60)
(print "Rotating around Targets")


(print "Right Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 right_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 right_wall_back_crnr)
	(sleep 60)
(print "Front Right")
	(sleep 60)
	(cs_aim_object 1 front_right)	
	(sleep 60)
	(cs_shoot 1 front_right)
	(sleep 60)
(print "Front Left")
	(sleep 60)
	(cs_aim_object 1 front_left)	
	(sleep 60)
	(cs_shoot 1 front_left)
	(sleep 60)
(print "Left Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 left_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 left_wall_back_crnr)
	(sleep 60)
(print "Right Bottom Back Wall")
	(sleep 60)
	(cs_aim_object 1 right_bot_back)	
	(sleep 60)
	(cs_shoot 1 right_bot_back)
	(sleep 60)
(print "Front Right Bottom")
	(sleep 60)
	(cs_aim_object 1 front_right_bot)	
	(sleep 60)
	(cs_shoot 1 front_right_bot)
	(sleep 60)
(print "Front Left Bottom")
	(sleep 60)
	(cs_aim_object 1 front_left_bot)	
	(sleep 60)
	(cs_shoot 1 front_left_bot)
	(sleep 60)
(print "Back Left Bottom")
	(sleep 60)
	(cs_aim_object 1 left_bot_back)	
	(sleep 60)
	(cs_shoot 1 left_bot_back)
	(sleep 60)
(print "Back Right Bottom")
	(sleep 60)
	(cs_aim_object 1 right_bot_back)	
	(sleep 60)
	(cs_shoot 1 right_bot_back)
	(sleep 60)
(print "Right Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 right_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 right_wall_back_crnr)
	(sleep 60)
(print "Left Wall Back Corner")
	(sleep 60)
	(cs_aim_object 1 left_wall_back_crnr)	
	(sleep 60)
	(cs_shoot 1 left_wall_back_crnr)
	(sleep 60)
(print "Front Left")
	(sleep 60)
	(cs_aim_object 1 front_left)	
	(sleep 60)
	(cs_shoot 1 front_left)
	(sleep 60)
(print "Front Left Bottom")
	(sleep 60)
	(cs_aim_object 1 front_left_bot)	
	(sleep 60)
	(cs_shoot 1 front_left_bot)
	(sleep 60)
(print "Front Right")
	(sleep 60)
	(cs_aim_object 1 front_right)	
	(sleep 60)
	(cs_shoot 1 front_right)
	(sleep 60)
(print "Front Right Bottom")
	(sleep 60)
	(cs_aim_object 1 front_right_bot)	
	(sleep 60)
	(cs_shoot 1 front_right_bot)
	(sleep 60)

	(ai_erase_all)
)
;===================== Enter Warthog test ================;


(script static void Enter_Warthog_1
	(object_create hog_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(ai_place warthog_boarding_test_troopers/spawn_points_1)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 hog_1 warthog_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 hog_1 warthog_p)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_1 1 hog_1 warthog_g)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_1 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
)

(script static void Enter_Warthog_2
	(object_create hog_1)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(ai_place warthog_boarding_test_elites/spawn_points_0)
	(ai_place warthog_boarding_test_elites/spawn_points_1)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_2 1 hog_1 warthog_d)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_0 1 hog_1 warthog_p)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_1 1 hog_1 warthog_g)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_1 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_2 1)
)

(script static void Board_warthog_1
	(object_create hog_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 hog_1 warthog_d)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_2 1 hog_1 warthog_d)
)

script static void Boarding_warthog_1()
	object_create (hog_1);
	ai_place (warthog_boarding_test_troopers.spawn_points_2);
	cs_go_to_vehicle (warthog_boarding_test_troopers.spawn_points_2, 1, hog_1, warthog_d);
	ai_place (warthog_boarding_test_elites.spawn_points_2);
	cs_go_to_vehicle (warthog_boarding_test_elites.spawn_points_2, 1, hog_1, warthog_d);
end


(script static void Board_warthog_2
	(object_create hog_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(ai_place warthog_boarding_test_troopers/spawn_points_1)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 hog_1 warthog_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 hog_1 warthog_p)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_1 1 hog_1 warthog_g)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_1 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(ai_place warthog_boarding_test_elites/spawn_points_0)
	(ai_place warthog_boarding_test_elites/spawn_points_1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_1 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 1)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_2 1 hog_1 warthog_d)
(sleep 100)
	(ai_braindead warthog_boarding_test_elites/spawn_points_2 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 0)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_0 1 hog_1 warthog_p)
(sleep 200)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_1 0)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_1 1 hog_1 warthog_g)
)

(script static void Pathing_warthog_1
	(object_create hog_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(ai_place warthog_boarding_test_troopers/spawn_points_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 hog_1 warthog_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_1 1 hog_1 warthog_p)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 hog_1 warthog_g)
)

;===================== Enter Wraith test ================;


(script static void Enter_Wraith_1
	(object_create wraith_1)
	(ai_place wraith_boarding_test_troopers/spawn_points_0)
	(ai_place wraith_boarding_test_troopers/spawn_points_1)
	(cs_go_to_vehicle wraith_boarding_test_troopers/spawn_points_0 1 wraith_1 wraith_d)
	(cs_go_to_vehicle wraith_boarding_test_troopers/spawn_points_1 1 wraith_1 wraith_g)
)

(script static void Enter_Wraith_2
	(object_create wraith_1)
	(ai_place wraith_boarding_test_elites/spawn_points_0)
	(ai_place wraith_boarding_test_elites/spawn_points_1)
	(cs_go_to_vehicle wraith_boarding_test_elites/spawn_points_0 1 wraith_1 wraith_g)
	(cs_go_to_vehicle wraith_boarding_test_elites/spawn_points_1 1 wraith_1 wraith_d)
	(ai_braindead wraith_boarding_test_elites/spawn_points_1 1)
	(ai_braindead wraith_boarding_test_elites/spawn_points_0 1)
)

(script static void Board_wraith_1
	(object_create wraith_1)
	(ai_place wraith_boarding_test_troopers/spawn_points_1)
	(cs_go_to_vehicle wraith_boarding_test_troopers/spawn_points_1 1 wraith_1 wraith_d)
(sleep 200)
	(ai_braindead wraith_boarding_test_troopers/spawn_points_1 1)
	(ai_place scorpion_test_elites/spawn_points_0)
(sleep 300)
	(ai_erase_all)
	(object_destroy_all)
	(object_create wraith_1)
	(ai_place wraith_boarding_test_troopers/spawn_points_1)
	(cs_go_to_vehicle wraith_boarding_test_troopers/spawn_points_1 1 wraith_1 wraith_d)
(sleep 200)
	(ai_braindead wraith_boarding_test_troopers/spawn_points_1 1)
	(ai_place scorpion_test_elites/spawn_points_1)
(sleep 300)
	(ai_erase_all)
	(object_destroy_all)
	(object_create wraith_1)
	(ai_place wraith_boarding_test_troopers/spawn_points_1)
	(cs_go_to_vehicle wraith_boarding_test_troopers/spawn_points_1 1 wraith_1 wraith_d)
(sleep 200)
	(ai_braindead wraith_boarding_test_troopers/spawn_points_1 1)
	(ai_place scorpion_test_elites/spawn_points_2)
(sleep 400)
	(ai_erase_all)
	(object_destroy_all)
)

;===================== Enter Scorpion test ================;


(script static void Enter_Scorpion_1
	(object_create scorpion_1)
	(ai_place scorpion_test_troopers/spawn_points_0)
	(ai_place scorpion_test_troopers/spawn_points_1)
	(cs_go_to_vehicle scorpion_test_troopers/spawn_points_0 1 scorpion_1 scorpion_d)
	(cs_go_to_vehicle scorpion_test_troopers/spawn_points_1 1 scorpion_1 scorpion_g)
	(ai_braindead scorpion_test_troopers/spawn_points_0 1)
	(ai_braindead scorpion_test_troopers/spawn_points_1 1)
)

(script static void Enter_scorpion_2
	(object_create scorpion_1)
	(ai_place scorpion_test_elites/spawn_points_0)
	(ai_place scorpion_test_elites/spawn_points_1)
	(cs_go_to_vehicle scorpion_test_elites/spawn_points_0 1 scorpion_1 scorpion_d)
	(cs_go_to_vehicle scorpion_test_elites/spawn_points_1 1 scorpion_1 scorpion_g)
	(ai_braindead scorpion_test_elites/spawn_points_0 1)
	(ai_braindead scorpion_test_elites/spawn_points_1 1)
)

(script static void Board_scorpion_1
	(object_create scorpion_1)
	(ai_place scorpion_test_troopers/spawn_points_0)
	(cs_go_to_vehicle scorpion_test_troopers/spawn_points_0 1 scorpion_1 scorpion_d)
	(ai_braindead scorpion_test_troopers/spawn_points_0 1)
(sleep 100)
	(ai_place scorpion_test_elites/spawn_points_0)
(sleep 300)
	(ai_erase_all)
	(object_destroy_all)
	(object_create scorpion_1)
	(ai_place scorpion_test_troopers/spawn_points_0)
	(cs_go_to_vehicle scorpion_test_troopers/spawn_points_0 1 scorpion_1 scorpion_d)
	(ai_braindead scorpion_test_troopers/spawn_points_0 1)
(sleep 100)
	(ai_place scorpion_test_elites/spawn_points_1)
(sleep 300)
	(ai_erase_all)
	(object_destroy_all)
	(object_create scorpion_1)
	(ai_place scorpion_test_troopers/spawn_points_0)
	(cs_go_to_vehicle scorpion_test_troopers/spawn_points_0 1 scorpion_1 scorpion_d)
	(ai_braindead scorpion_test_troopers/spawn_points_0 1)
(sleep 100)
	(ai_place scorpion_test_elites/spawn_points_2)
(sleep 600)
	(ai_erase_all)
	(object_destroy_all)
)

;===================== Trooper Enter Ghost test ================;


(script static void Enter_Ghost_1
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_0 1 ghost_1 ghost_d)
	(ai_braindead ghost_boarding_test_troopers/spawn_points_0 1)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_1)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_1 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_2)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_2 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_3)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_3 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
)


;===================== Elites Enter Ghost test ================;

(script static void Enter_Ghost_2
	(object_create ghost_1)
	(ai_place ghost_boarding_test_elites/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_0 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_elites/spawn_points_1)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_1 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_elites/spawn_points_2)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_2 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_elites/spawn_points_3)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_3 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
)

;===================== Elite Enter Banshee test ================;

script static void Enter_Banshee_2()
	object_create(banshee_1);
	ai_place(banshee_boarding_test_elites.spawn_points_0);
	cs_go_to_vehicle(banshee_boarding_test_elites.spawn_points_0, 1,banshee_1,banshee_d);
	sleep(180);

	ai_erase_all();
	object_create(banshee_1);
	ai_place(banshee_boarding_test_elites.spawn_points_1);
	cs_go_to_vehicle(banshee_boarding_test_elites.spawn_points_1, 1, banshee_1, banshee_d);
	sleep(80);

	ai_erase_all();
	object_create(banshee_1);
	ai_place(banshee_boarding_test_elites.spawn_points_2);
	cs_go_to_vehicle(banshee_boarding_test_elites.spawn_points_2, 1, banshee_1, banshee_d);
	sleep(80);
	
	ai_erase_all();
	object_create(banshee_1);
	ai_place(banshee_boarding_test_elites.spawn_points_3);
	cs_go_to_vehicle(banshee_boarding_test_elites.spawn_points_3, 1, banshee_1, banshee_d);
	sleep(80);
	ai_erase_all();
end

;===================== Grunt Enter Ghost test ================;

(script static void Enter_Ghost_3
	(object_create ghost_1)
	(ai_place ghost_boarding_test_grunts/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_grunts/spawn_points_0 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_grunts/spawn_points_1)
	(cs_go_to_vehicle ghost_boarding_test_grunts/spawn_points_1 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_grunts/spawn_points_2)
	(cs_go_to_vehicle ghost_boarding_test_grunts/spawn_points_2 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_grunts/spawn_points_3)
	(cs_go_to_vehicle ghost_boarding_test_grunts/spawn_points_3 1 ghost_1 ghost_d)
(sleep 80)
	(ai_erase_all)
)

;===================== Ghost Elite Hijack test ================;

(script static void Ghost_Hijack_1
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_0 1 ghost_1 ghost_d)
	(ai_braindead ghost_boarding_test_troopers/spawn_points_0 1)
(sleep 80)
	(ai_place ghost_boarding_test_elites/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_0 1 ghost_1 ghost_d)
(sleep 300)
	(ai_erase_all)
(sleep 50)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_0 1 ghost_1 ghost_d)
	(ai_braindead ghost_boarding_test_troopers/spawn_points_0 1)
(sleep 80)
	(ai_place ghost_boarding_test_elites/spawn_points_1)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_1 1 ghost_1 ghost_d)
(sleep 300)
	(ai_erase_all)
(sleep 50)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_0 1 ghost_1 ghost_d)
	(ai_braindead ghost_boarding_test_troopers/spawn_points_0 1)
(sleep 80)
	(ai_place ghost_boarding_test_elites/spawn_points_2)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_2 1 ghost_1 ghost_d)
(sleep 300)
	(ai_erase_all)
(sleep 50)
	(object_create ghost_1)
	(ai_place ghost_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle ghost_boarding_test_troopers/spawn_points_0 1 ghost_1 ghost_d)
	(ai_braindead ghost_boarding_test_troopers/spawn_points_0 1)
(sleep 80)
	(ai_place ghost_boarding_test_elites/spawn_points_3)
	(cs_go_to_vehicle ghost_boarding_test_elites/spawn_points_3 1 ghost_1 ghost_d)
(sleep 300)
	(ai_erase_all)
)

;===================== Enter Mongoose test ================;


(script static void Enter_mongoose_1
	(object_create mongoose_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 mongoose_1 mongoose_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 mongoose_1 mongoose_p)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
	(object_create mongoose_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 mongoose_1 mongoose_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 mongoose_1 mongoose_p)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
)

(script static void Enter_mongoose_2
	(object_create mongoose_1)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(ai_place warthog_boarding_test_elites/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_2 1 mongoose_1 mongoose_d)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_0 1 mongoose_1 mongoose_p)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
	(object_create mongoose_1)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(ai_place warthog_boarding_test_elites/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_0 1 mongoose_1 mongoose_d)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_2 1 mongoose_1 mongoose_p)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
)

;===================== Enter Revenant test ================;


(script static void Enter_revenant_1
	(object_create revenant_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 revenant_1 revenant_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 revenant_1 revenant_p)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
	(object_create revenant_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 revenant_1 revenant_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 revenant_1 revenant_p)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
)

(script static void Enter_revenant_2
	(object_create revenant_1)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(ai_place warthog_boarding_test_elites/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_2 1 revenant_1 revenant_d)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_0 1 revenant_1 revenant_p)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
	(object_create revenant_1)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(ai_place warthog_boarding_test_elites/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_0 1 revenant_1 revenant_d)
	(cs_go_to_vehicle warthog_boarding_test_elites/spawn_points_2 1 revenant_1 revenant_p)
	(ai_braindead warthog_boarding_test_elites/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_elites/spawn_points_2 1)
(sleep 100)
(ai_erase_all)
)

(script static void Board_revenant_1
	(object_create revenant_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 revenant_1 revenant_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 revenant_1 revenant_p)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
	(ai_place warthog_boarding_test_elites/spawn_points_2)
	(sleep 300)
	(ai_erase_all)
	(object_create revenant_1)
	(ai_place warthog_boarding_test_troopers/spawn_points_2)
	(ai_place warthog_boarding_test_troopers/spawn_points_0)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_2 1 revenant_1 revenant_d)
	(cs_go_to_vehicle warthog_boarding_test_troopers/spawn_points_0 1 revenant_1 revenant_p)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_0 1)
	(ai_braindead warthog_boarding_test_troopers/spawn_points_2 1)
	(ai_place warthog_boarding_test_elites/spawn_points_0)
	(sleep 300)
	(ai_erase_all)
)

;=========================== melee_test =====================;

script static void elite_sword_melee_test()
	ai_place("elite_melee/energy_sword");
	ai_place("trooper_melee/trooper_target");
	ai_cannot_die("trooper_melee", 1);
	ai_braindead("trooper_melee", 1);
	ai_prefer_target_ai("elite_melee/energy_sword", "trooper_melee/trooper_target", 1);
end

script static void spartan_sword_melee_test()
	ai_place("spartan_melee/energy_sword");
	ai_place("trooper_melee/trooper_target");
	ai_cannot_die("trooper_melee", 1);
	ai_braindead("trooper_melee", 1);
	ai_prefer_target_ai("spartan_melee/energy_sword", "trooper_melee/trooper_target", 1);
end

;=========================== jump_test =====================;

script static void elite_minor_jump_1()
	ai_place(elite_jump_test.assault_carbine);
end

script static void elite_minor_jump_2()
	ai_place(elite_jump_test.beam_rifle);
end

script static void elite_minor_jump_3()
	ai_place(elite_jump_test.covenant_carbine);
end

script static void elite_minor_jump_4()
	ai_place(elite_jump_test.concussion_rifle);
end

script static void elite_minor_jump_6()
	ai_place(elite_jump_test.needler);
end

script static void elite_minor_jump_7()
	ai_place(elite_jump_test.plasma_pistol);
end

script static void elite_minor_jump_8()
	ai_place(elite_jump_test.fuel_rod_cannon);
end

script static void elite_minor_jump_29()
	ai_place(elite_jump_test.energy_sword);
end

script static void elite_minor_jump_30()
	ai_place(elite_jump_test.gravity_hammer);
end

script static void jackal_minor_jump_2()
	ai_place(jackal_jump_test.beam_rifle);
end

script static void jackal_minor_jump_3()
	ai_place(jackal_jump_test.covenant_carbine);
end

script static void jackal_minor_jump_6()
	ai_place(jackal_jump_test.needler);
end

script static void jackal_minor_jump_7()
	ai_place(jackal_jump_test.plasma_pistol);
end

script static void grunt_minor_jump_6()
	ai_place(grunt_jump_test.needler);
end

script static void grunt_minor_jump_7()
	ai_place(grunt_jump_test.plasma_pistol);
end

script static void grunt_minor_jump_8()
	ai_place(grunt_jump_test.fuel_rod_cannon);
end

script static void knight_minor_jump_14()
	ai_place(knight_jump_test.spread_gun);
end

script static void knight_minor_jump_31()
	ai_place(knight_jump_test.stasis_pistol);
end

script static void knight_minor_jump_11()
	ai_place(knight_jump_test.forerunner_smg);
end

script static void knight_minor_jump_12()
	ai_place(knight_jump_test.forerunner_rifle);
end

script static void knight_minor_jump_9()
	ai_place(knight_jump_test.attach_beam);
end

script static void knight_minor_jump_13()
	ai_place(knight_jump_test.incineration_cannon);
end

script static void pawn_minor_jump_0()
	ai_place(pawn_jump_test);
end

script static void spartan_jump_1()
	ai_place(spartan_jump_test.assault_carbine);
end

script static void spartan_jump_2()
	ai_place(spartan_jump_test.beam_rifle);
end

script static void spartan_jump_3()
	ai_place(spartan_jump_test.covenant_carbine);
end

script static void spartan_jump_4()
	ai_place(spartan_jump_test.concussion_rifle);
end

script static void spartan_jump_6()
	ai_place(spartan_jump_test.needler);
end

script static void spartan_jump_7()
	ai_place(spartan_jump_test.plasma_pistol);
end

script static void spartan_jump_8()
	ai_place(spartan_jump_test.fuel_rod_cannon);
end

script static void spartan_jump_29()
	ai_place(spartan_jump_test.energy_sword);
end

script static void spartan_jump_30()
	ai_place(spartan_jump_test.gravity_hammer);
end

script static void spartan_jump_16()
	ai_place(spartan_jump_test.assault_rifle);
end

script static void spartan_jump_17()
	ai_place(spartan_jump_test.battle_rifle);
end

script static void spartan_jump_18()
	ai_place(spartan_jump_test.DMR);
end

script static void spartan_jump_19()
	ai_place(spartan_jump_test.lmg);
end

script static void spartan_jump_20()
	ai_place(spartan_jump_test.magnum);
end

script static void spartan_jump_21()
	ai_place(spartan_jump_test.rail_gun);
end

script static void spartan_jump_22()
	ai_place(spartan_jump_test.rocket_launcher);
end

script static void spartan_jump_23()
	ai_place(spartan_jump_test.shotgun);
end

script static void spartan_jump_24()
	ai_place(spartan_jump_test.sniper_rifle);
end

script static void spartan_jump_25()
	ai_place(spartan_jump_test.spartan_laser);
end

script static void spartan_jump_26()
	ai_place(spartan_jump_test.sticky_detonator);
end

script static void spartan_jump_27()
	ai_place(spartan_jump_test.target_locator);
end

/*
script static void spartan_jump_39()
	ai_place(spartan_jump_test.plasma_turret);
end*/

script static void spartan_jump_14()
	ai_place(spartan_jump_test.spread_gun);
end

script static void spartan_jump_31()
	ai_place(spartan_jump_test.stasis_pistol);
end

script static void spartan_jump_11()
	ai_place(spartan_jump_test.forerunner_smg);
end

script static void spartan_jump_12()
	ai_place(spartan_jump_test.forerunner_rifle);
end

script static void spartan_jump_9()
	ai_place(spartan_jump_test.attach_beam);
end

script static void spartan_jump_13()
	ai_place(spartan_jump_test.incineration_cannon);
end

/*script static void spartan_jump_28()
	ai_place(spartan_jump_test.machinegun);
end*/
script static void marine_jump_16()
	ai_place(marine_jump_test.assault_rifle);
end

script static void marine_jump_17()
	ai_place(marine_jump_test.battle_rifle);
end

script static void marine_jump_18()
	ai_place(marine_jump_test.DMR);
end

script static void marine_jump_19()
	ai_place(marine_jump_test.lmg);
end

script static void marine_jump_20()
	ai_place(marine_jump_test.magnum);
end

script static void marine_jump_21()
	ai_place(marine_jump_test.rail_gun);
end

script static void marine_jump_22()
	ai_place(marine_jump_test.rocket_launcher);
end

script static void marine_jump_23()
	ai_place(marine_jump_test.shotgun);
end

script static void marine_jump_24()
	ai_place(marine_jump_test.sniper_rifle);
end

script static void marine_jump_26()
	ai_place(marine_jump_test.sticky_detonator);
end

script static void marine_jump_27()
	ai_place(marine_jump_test.target_locator);
end

script static void fem_marine_jump_16()
	ai_place(fem_marine_jump_test.assault_rifle);
end

script static void fem_marine_jump_17()
	ai_place(fem_marine_jump_test.battle_rifle);
end

script static void fem_marine_jump_18()
	ai_place(fem_marine_jump_test.DMR);
end

script static void fem_marine_jump_19()
	ai_place(fem_marine_jump_test.lmg);
end

script static void fem_marine_jump_20()
	ai_place(fem_marine_jump_test.magnum);
end

script static void fem_marine_jump_21()
	ai_place(fem_marine_jump_test.rail_gun);
end

script static void fem_marine_jump_22()
	ai_place(fem_marine_jump_test.rocket_launcher);
end

script static void fem_marine_jump_23()
	ai_place(fem_marine_jump_test.shotgun);
end

script static void fem_marine_jump_24()
	ai_place(fem_marine_jump_test.sniper_rifle);
end

script static void fem_marine_jump_26()
	ai_place(fem_marine_jump_test.sticky_detonator);
end

script static void fem_marine_jump_27()
	ai_place(fem_marine_jump_test.target_locator);
end

script command_script cs_jump_test_1()
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	

	ai_cannot_die (ai_current_actor, true);
	ai_disregard (ai_actors (ai_current_actor), true);
	//ai_braindead (ai_current_actor, true);
	
	print  ("moving while facing destination");
	cs_go_to (ps_jump_test.p0, 0.3);
	cs_go_to (ps_jump_test.p1, 0.3);
	cs_go_to (ps_jump_test.p2, 0.3);
	cs_go_to (ps_jump_test.p3, 0.3);
	cs_go_to (ps_jump_test.p4, 0.3);
	cs_go_to (ps_jump_test.p5, 0.3);
	cs_go_to (ps_jump_test.p6, 0.3);
	sleep(30);
	
	ai_erase (ai_current_actor);
end

;=========== crouch aimtest script ======================;

(script command_script standing_crouch
	(cs_crouch 1)
(print "Firing Forward")
	(sleep 30)
(print "Center Wall Top Left")
	(sleep 90)
	(cs_aim_object 1 center_wall_top_left)
	(sleep 90)
	(cs_shoot 1 center_wall_top_left)
	(sleep 90)
(print "Center Wall Top Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_center)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_center)
	(sleep 90)
(print "Center Wall Top Right")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_right)	
	(sleep 90)
	(cs_shoot 1 center_wall_top_right)
	(sleep 90)
(print "Center Wall Bottom Left")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_left)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_left)
	(sleep 90)
(print "Center Wall Bottom Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_center)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_center)
	(sleep 90)
(print "Center Wall Bottom Right")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_right)	
	(sleep 90)
	(cs_shoot 1 center_wall_bot_right)
	(sleep 90)
(print "Rotating between Targets")
	(sleep 90)
(print "Left Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 left_wall_top_left)	
	(sleep 30)
	(cs_shoot 1 left_wall_top_left)
	(sleep 90)
(print "Right Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 right_wall_top_left)	
	(sleep 30)
	(cs_shoot 1 right_wall_top_left)
	(sleep 90)
(print "Center Wall Top Left")
	(sleep 30)
	(cs_aim_object 1 center_wall_top_left)
	(sleep 30)
	(cs_shoot 1 center_wall_top_left)
	(sleep 90)
(print "Above Crate Front")
	(sleep 30)
	(cs_aim_object 1 above_crate_front)			
	(sleep 30)
	(cs_shoot 1 above_crate_front)
	(sleep 90)
(print "Above Crate Back")
	(sleep 30)
	(cs_aim_object 1 above_crate_back)	
	(sleep 30)
	(cs_shoot 1 above_crate_back)
	(sleep 90)
(print "Center Wall Bottom Center")
	(sleep 30)
	(cs_aim_object 1 center_wall_bot_center)			
	(sleep 30)
	(cs_shoot 1 center_wall_bot_center)
	(sleep 90)

	(ai_erase_all)

)


