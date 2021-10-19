;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================
(global short g_set_all 10)

;=========================================================================================
;================================== CRASH SITE START ======================================
;=========================================================================================
(script static void ins_crash_site
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 120_00_01_02)
		)
	)
	
	; wake opening cinematic
	(wake cin_halo_intro)

	; set insertion point index 
	(set g_insertion_index 1)
)


;=========================================================================================
;=================================== CONTROL ROOM ==========================================
;=========================================================================================
(script static void ins_exit_run
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 120_03_05)
			(sleep 1)
		)
	)
	(insertion_start)
	
	(wake cin_halo_activation)
;	(object_teleport (player0) exit_run_player0)
;	(object_teleport (player1) exit_run_player1)
;	(object_teleport (player2) exit_run_player2)
;	(object_teleport (player3) exit_run_player3)	
	(sleep_until (script_finished cin_halo_activation)1)
	(fade_out 0 0 0 0)
	(print "TELEPORT PLAYER INSERTION")
	
	(set g_insertion_index 7)
	(garbage_collect_now)
;	(wake insertion_end)
	
	; placing allies... 
;	(if debug (print "placing allies..."))
;	(ai_place sq_gc_arbiter)
;	(ai_place sq_gc_marines)
;	(sleep 1)
)

;=========================================================================================
;=================================== TRENCH RUN =========================================
;=========================================================================================
(script static void ins_trench_run

	; set insertion point index 
	(set g_insertion_index 8)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 120_04_100_110)
			(sleep 1)
		)
	)

		
	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) trench_run_player0)
	(object_teleport (player1) trench_run_player1)
	(sleep 1)	
	(unit_add_equipment (player0) teleport_profile TRUE TRUE)
	(ai_erase arbiter)
	(ai_place arbiter_trench/trench)
	(set obj_arbiter (ai_get_object arbiter_trench/trench))	
	(ai_cannot_die arbiter_trench/trench TRUE)
;	(object_teleport arbiter_trench trench_run_player1)
	(wake 120_07_ambient_background)
	(sleep_forever obj_ziggurat_set)
	(sleep_forever md_01_crash_site_cortana)
	(sleep_forever md_02_terminal_cortana)	
	
)


;*
=========================================================================================
================================== COMMENTS AND JUNK ====================================
=========================================================================================


Objects per frame		characters	vehicles	weapons	scenery	crates/garbage/items 
						28			12		30		50		60 



*;

