//=============================================================================================================================
//============================================ MIDNIGHT FIREFIGHT COMPLEX VO SCRIPTS ========================================================
//=============================================================================================================================


//============================STARTING E1 M3==============================

script static void start_e1_m3_switch_1_vo
	print ("vo e1_m3_switch_1 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m3_switch_2_vo
	print ("vo e1_m3_switch_2 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e1_m3_switch_2_vo
	print ("vo end e1_m3_switch_2 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m3_switch_3_vo
	print ("vo e1_m3_switch_3 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e1_m3_switch_3_vo
	print ("vo end e1_m3_switch_3 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m3_lz_1_vo
	print ("vo e1_m3_lz_1 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m3_lz_2_vo
	print ("vo e1_m3_lz_2 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e1_m3_lz_2_vo
	print ("vo end e1_m3_lz_2 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m3_lz_3_vo
	print ("vo e1_m3_lz_3 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e1_m3_lz_3_vo
	print ("vo end e1_m3_lz_3 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

//============================ENDING E1 M3==============================


//============================STARTING E1 M5==============================

script static void start_e1_m5_switch_1_vo
	print ("vo e1_m5_switch_1 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e1_m5_switch_1_vo
	print ("vo end e1_m5_switch_1 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m5_clear_base_1_vo
	print ("vo e1_m5_clear_base_1 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m5_clear_base_2_vo
	print ("vo e1_m5_clear_base_2 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m5_get_artifact_vo
	print ("vo e1_m5_get_artifact ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e1_m5_get_artifact_vo
	print ("vo end e1_m5_get_artifact ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e1_m5_swarm_vo
	print ("vo e1_m5_swarm ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e1_m5_swarm_vo
	print ("vo end e1_m5_swarm ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

//============================ENDING E1 M5==============================

//============================STARTING E6 M1==============================

script static void start_e6_m1_get_shard_1_vo
	print ("vo e6_m1_get_shard_1 ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

//script static void end_e6_m1_switch_1_vo
//	print ("vo end e6_m1_switch_1 ");
//	//vo_oyo_m1_d1();
//	//vo_oyo_m1_p1();
//end

script static void start_e6_m1_get_shard_2_vo
	print ("vo e6_m1_get_shard_2");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void start_e6_m1_get_shard_3_vo
	print ("start_e6_m1_get_shard_3_vo");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end


script static void start_e6_m1_swarm_vo
	print ("vo e6_m1_swarm ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end

script static void end_e6_m1_swarm_vo
	print ("vo end e6_m1_swarm ");
	//vo_oyo_m1_d1();
	//vo_oyo_m1_p1();
end


//======================================================================
//========OYO M1=========
//======================================================================

//========M1 VO MACRO SCRIPTS===========
//we should add the VO lines in comments these macro scripts as well
script static void m1_vo_start_defend_1
	print ("vo start defend 1");
	vo_oyo_m1_d1();
	vo_oyo_m1_p1();
end

script static void m1_vo_enemy_drop_pod
	print ("vo enemy drop pod");
	vo_oyo_m1_p2();
end

script static void m1_vo_weapon_drop_1
	print ("vo weapon drop 1");
	vo_oyo_m1_p3();
	vo_oyo_m1_d2();
	vo_oyo_m1_p4();
end

script static void m1_vo_more_enemies_1
	print ("vo more enemies 1");
	vo_oyo_m1_r1();
	vo_oyo_m1_p5();
	vo_oyo_m1_r2();
	vo_oyo_m1_p6();
end

script static void m1_vo_invading_1
	print ("vo invading 1");
	vo_oyo_m1_p7();
	vo_oyo_m1_r3_1();
end

script static void m1_vo_start_turrets
	print ("vo start turrets");
	vo_oyo_m1_bb1();
	vo_oyo_m1_p8();
	vo_oyo_m1_bb2();
end

script static void m1_vo_more_enemies_2
	print ("vo more enemies 2");
	vo_oyo_m1_r1();
	vo_oyo_m1_p5();
	vo_oyo_m1_r2();
	vo_oyo_m1_p6();
end

script static void m1_vo_invading_2
	print ("vo invading 2");
	vo_oyo_m1_r4_1();
	vo_oyo_m1_p11();
end

script static void m1_vo_reinforcements
	print ("vo reinforcements");
	vo_oyo_m1_d3();
	vo_oyo_m1_p9();
end

script static void m1_vo_not_many_left
	print ("vo not many left");
	vo_oyo_m1_p10();
end

script static void m1_vo_end_defend_1
	print ("vo end defend 1");
	vo_oyo_m1_p12();
	vo_oyo_m1_r5();
	vo_oyo_m1_p13();
end

//======================================================================
//========OYO M2=========
//======================================================================


script static void m2_vo_start_switch
	print ("m2_vo_start_switch");
	vo_oyo_m2_p1();
	vo_oyo_m2_r1();
	vo_oyo_m2_p2();
	sleep_until (objective_obj == firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0)), 1);
	sleep (30 * 6);
	vo_oyo_m2_p3();
end

script static void m2_vo_end_switch_1
	print ("m2_vo_end_switch_1");
	vo_oyo_m2_r2();
	vo_oyo_m2_p4();
end

script static void m2_vo_weapon_drop_1
	print ("m2_vo_weapon_drop_1");
	vo_oyo_m2_p5();
	vo_oyo_m2_d1();
end

script static void m2_vo_powercore_destroy
	print ("m2_vo_powercore_destroy");
	vo_oyo_m2_p6();
end

script static void m2_vo_weapon_drop_2
	print ("m2_vo_weapon_drop_2");
	vo_oyo_m2_d2();
	vo_oyo_m2_p7();
end

script static void m2_vo_end_destroy_2
	print ("m2_vo_end_destroy_2");
	vo_oyo_m2_p8();
end

script static void m2_vo_start_swarm_1
	print ("m2_vo_start_swarm_1");
	vo_oyo_m2_r3();
//	vo_oyo_m2_r3_3();
//	vo_oyo_m2_r3_2();
//	vo_oyo_m2_r3_1();
	vo_oyo_m2_p9();
end
	
script static void m2_vo_pod_1
	print ("m2_vo_pod_1");
	vo_oyo_m2_p10();
	vo_oyo_m2_d3();
	vo_oyo_m2_p11();
	vo_oyo_m2_r4();
	vo_oyo_m2_p12();
end

script static void m2_vo_end_swarm_1
	print ("m2_vo_end_swarm_1");
	vo_oyo_m2_p13();
end

//	vo_oyo_m2_p14();
//	vo_oyo_m2_pr5();
//	vo_oyo_m2_p15();
//	vo_oyo_m2_p16();
//	vo_oyo_m2_p17();

//======================================================================
//========OYO M5=========
//======================================================================

script static void m5_vo_start_switch
	print ("m5_vo_start_switch");
	vo_oyo_m5_d1();
	vo_oyo_m5_r1();
	vo_oyo_m5_p1();
end

script static void m5_vo_end_switch
	print ("m5_vo_end_switch");
	vo_oyo_m5_r2();
end

script static void m5_vo_weapon_drop_1
	print ("m5_vo_weapon_drop_1");
	vo_oyo_m5_p2();
	vo_oyo_m5_d4();
//	vo_oyo_m5_p3();
end

script static void m5_vo_start_switch_2
	print ("m5_vo_start_switch_2");
	vo_oyo_m5_p4();
end

script static void m5_vo_end_switch_2
	print ("m5_vo_end_switch_2");
	vo_oyo_m5_r3();
	sleep (30 * 2);
	vo_oyo_m5_d5();
end

script static void m5_vo_start_atob_1
	print ("m5_vo_start_atob_1");
	vo_oyo_m5_p5();
end

script static void m5_vo_start_atob_2
	print ("m5_vo_start_atob_2");
	vo_oyo_m5_p6();
end

script static void m5_vo_end_lz
	print ("m5_vo_end_lz");
	vo_oyo_m5_d6();
end

script static void m5_vo_start_swarm_lz
	print ("m5_vo_start_swarm_lz");
	vo_oyo_m5_d7();
	vo_oyo_m5_p7();
end

script static void m5_vo_hunters_incoming
	print ("m5_vo_hunters_incoming");
	vo_oyo_m5_p8();
end

script static void m5_vo_end_swarm_lz
	print ("m5_vo_end_swarm_lz");
	vo_oyo_m5_d8();
	vo_oyo_m5_p9();
end

script static void m5_vo_elites_incoming
	vo_oyo_m5_p8_2();
end
//	vo_oyo_m5_p8_1();
//	vo_oyo_m5_p8_2();
//	vo_oyo_m5_p8_3();

