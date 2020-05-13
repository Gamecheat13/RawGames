//// =============================================================================================================================
// ============================================ CAVERNS SCRIPT ========================================================
// =============================================================================================================================


script startup caverns

	print( "caverns_startup" );
	
	//object_destroy(cr_e6_m3_pod_top_1);
	//object_destroy(cr_e6_m3_pod_top_2);

	//object_hide(cr_e6_m3_pod_top_1, true);
	//object_hide(cr_e6_m3_pod_top_2, true);
//	object_destroy(e6_m3_cov_base_01);
//	object_destroy(e6_m3_cov_base_02);


	//e8_m3 placed Cov watchtowers
//	object_hide(e8m3_pod_1, true);
//	object_destroy(e8m3_base_1);

	//Remove pods from E10_M2
//	object_destroy(e10_m2_base_1);
//	object_destroy(e10_m2_pod_1);
//	object_destroy(e10_m2_base_2);
//	object_destroy(e10_m2_pod_2);
//	object_destroy(e10_m2_base_3);
//	object_destroy(e10_m2_pod_3); 

	
	// setup defaults
	f_spops_mission_startup_defaults();
	
	// track mission flow
	f_spops_mission_flow();
	
end


// ==============================================================================================================
//====== OTHER SCRIPTS ===============================================================================
// ==============================================================================================================

 