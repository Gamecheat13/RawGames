;----------------------------------------------------------------------------------------------------
; *** GLOBALS *** 
;----------------------------------------------------------------------------------------------------

; b_debug Options
(global boolean b_debug 					TRUE)
(global boolean b_breakpoints 		FALSE)
(global boolean b_md_print 				TRUE)
(global boolean debug_objectives 	FALSE)
(global boolean editor 						(editor_mode))
(global boolean cinematics 				TRUE)
(global boolean editor_cinematics FALSE)
(global boolean game_emulate 			FALSE)
(global boolean dialogue 					FALSE)
(global boolean skip_intro				FALSE)

; Objective Controls
(global short objcon_hill -1)

; Objective Readiness
(global boolean b_hill_ready FALSE)

; Insertion
(global short g_insertion_index 0)

; Insertion Indicies
(global short s_insert_idx_transition 1)
(global short s_insert_idx_hill 2)
(global short s_insert_idx_credits 3)

; Zone Sets
(global short s_set_hill 0)
(global short s_set_cin_outro 1)
(global short s_set_all 2)

; Fire Teams
(global short fireteam_max 4)
(global real fireteam_dist 3.0)

; Mission Specific
(global boolean g_mission_complete FALSE)

; Persistent Objects

; global functions
(script command_script cs_abort  
	(sleep 1) 
)
; Utility
(global short s_wave_spawning 0)

; Hints
(global short s_waypoint_timer 10)

; =================================================================================================
; SUNDANCE STARTUP
; =================================================================================================
(script startup sundance

	(print_difficulty)
	(dprint "::: M80 - SUNDANCE :::")
	(set breakpoints_enabled FALSE)

	; Allegiances
	(ai_allegiance human player)
	(ai_allegiance player human)

	(set breakpoints_enabled FALSE)

	(wake f_weather_control)
	(wake f_objects_manage)

	; STARTING THE GAME
	; ============================================================================================
	(if	
		(or
			(and (not editor) (> (player_count) 0))
			game_emulate
		)
			(begin			
				; if true, start the game
				(start)
			)
			; else just fade in, we're in edit mode
			(begin
				(dprint ":::  editor mode  :::")
			)
	)

	; ENCOUNTERS
	; ============================================================================================

		; HILL
		; =======================================================================================
		(sleep_until	
			(or
				(>= g_insertion_index s_insert_idx_transition)
				FALSE
			)
		1)
		
		(if (<= g_insertion_index s_insert_idx_hill) (wake f_hill_objective_control))
		
)

(script dormant f_weather_control

	(sleep_until (>= objcon_hill 1))
	(set s_rain_force 2)
	(wake f_rain)

)

(global short s_zoneset_last_refreshed -1)
(script dormant f_objects_manage

		(sleep_until (begin

			(cond

				((and (= (current_zone_set_fully_active) s_set_hill)(not (= s_zoneset_last_refreshed s_set_hill)))
					(f_objects_hill_create)
					(set s_zoneset_last_refreshed s_set_hill)
				)

				((and (= (current_zone_set_fully_active) s_set_cin_outro)(not (= s_zoneset_last_refreshed s_set_cin_outro)))
					(f_objects_hill_destroy)
					(set s_zoneset_last_refreshed s_set_cin_outro)
				)

			)

	FALSE) 3)

)

(script static void f_objects_hill_create

	(dprint "creating hill objects")
	(object_create_folder wp_hill)
	(object_create_folder sc_hill)

	(if (difficulty_is_legendary) (object_create dt_term_1) (object_destroy dt_term_1) )

	(pose_body sc_hill_marine_04 pose_on_back_var3)
	(pose_body sc_hill_marine_05 pose_on_side_var1)
	(pose_body sc_hill_marine_06 pose_face_down_var3)
	(pose_body sc_hill_marine_08 pose_face_down_var3)
	(pose_body sc_hill_marine_09 pose_on_side_var4)
	(pose_body sc_hill_marine_10 pose_on_back_var3)
	(pose_body sc_hill_marine_11 pose_against_wall_var3)
	(pose_body sc_hill_marine_13 pose_on_back_var2)
	(pose_body sc_hill_marine_14 pose_on_side_var2)
	(pose_body sc_hill_marine_15 pose_face_down_var1)


)

(script static void f_objects_hill_destroy

	(dprint "destroying hill objects")
	(object_destroy_folder wp_hill)
	(object_destroy_folder sc_hill)

)

; =================================================================================================
; =================================================================================================
; START
; =================================================================================================
; =================================================================================================

(script static void start

	; Figure out what insertion point to use
	(cond
		((= (game_insertion_point_get) 0) (ins_transition))
		((= (game_insertion_point_get) 1) (ins_hill))
		((= (game_insertion_point_get) 2) (ins_credits))
	)
)

; =================================================================================================
; =================================================================================================
; HILL
; =================================================================================================
; =================================================================================================

(global short s_escalation 0)
(global boolean b_bob 0)
(global boolean b_wraith 0)

(script dormant sc_spawn_start
	(wake sc_spawn_bottom)
	(sleep 1)
	(wake sc_spawn_left)
	(sleep 1)
	(wake sc_spawn_right)
	(sleep 1)
	(wake sc_spawn_top)
	(sleep 1)
	(wake sc_escalation)
	(wake sc_wraith_top)
	(wake sc_wraith_bottom)
	(wake sc_wraith_right)
	(wake sc_wraith_left)
	(sleep 1)
	(wake sc_fork_bottom)
	(wake sc_fork_right)
	(wake sc_fork_left)
	(wake sc_fork_top)
)

(script dormant sc_escalation
	(sleep_until (>= (ai_body_count obj_sundance/main_gate) 8) 1 3600)
			(set s_escalation 1)
			(print "escalation set to 1")
	(sleep_until (>= (ai_body_count obj_sundance/main_gate) 16) 1 3600)
			(set s_escalation 2)	
			(set b_wraith 1)
			(print "escalation set to 2")		
	(sleep_until (>= (ai_body_count obj_sundance/main_gate) 24) 1 3600)
			(set s_escalation 3)		
			(print "escalation set to 3")			
	(sleep_until (>= (ai_body_count obj_sundance/main_gate) 32) 1 3600)
			(set s_escalation 4)		
			(print "escalation set to 4")			
)

(script dormant sc_spawn_bottom
	(sleep_until
		(begin
			(sleep_until (<= (+ (ai_living_count sq_bot_01) (ai_living_count sq_bot_02)) 3) 1)
				(print "spawn bottom 01")
				(sv_bottom01)
				(sleep 30)
			(sleep_until (<= (+ (ai_living_count sq_bot_01) (ai_living_count sq_bot_02)) 3) 1)
				(print "spawn bottom 02")
				(sv_bottom02)
				(sleep 30)				
		0)
	1)
)

(script dormant sc_spawn_left
	(sleep_until
		(begin
			(sleep_until (<= (+ (ai_living_count sq_left_01) (ai_living_count sq_left_02)) 3) 1)
				(print "spawn left 01")
				(sv_left01)
				(sleep 30)
			(sleep_until (<= (+ (ai_living_count sq_left_01) (ai_living_count sq_left_02)) 3) 1)
				(print "spawn left 02")
				(sv_left02)
				(sleep 30)				
		0)
	1)
)

(script dormant sc_spawn_right
	(sleep_until
		(begin
			(sleep_until (<= (+ (ai_living_count sq_right_01) (ai_living_count sq_right_02)) 3) 1)
				(print "spawn right 01")
				(sv_right01)
				(sleep 30)
			(sleep_until (<= (+ (ai_living_count sq_right_01) (ai_living_count sq_right_02)) 3) 1)
				(print "spawn right 02")
				(sv_right02)
				(sleep 30)				
		0)
	1)
)

(script dormant sc_spawn_top
	(sleep_until
		(begin
			(sleep_until (<= (+ (ai_living_count sq_top_01) (ai_living_count sq_top_02)) 3) 1)
				(print "spawn top 01")
				(sv_top01)
				(sleep 30)
			(sleep_until (<= (+ (ai_living_count sq_top_01) (ai_living_count sq_top_02)) 3) 1)
				(print "spawn top 02")
				(sv_top02)
				(sleep 30)				
		0)
	1)
)

(script static void sv_bottom01
	(if (= s_escalation 0)
		(begin
			(print "squad bottom01 esc0 01")
			(ai_place sq_bot_01/esc0_01)
			(ai_place sq_bot_01/esc0_02)
			(ai_place sq_bot_01/esc0_03)
			(ai_place sq_bot_01/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad bottom01 esc1 01")
			(ai_place sq_bot_01/esc1_01)
			(ai_place sq_bot_01/esc1_02)
			(ai_place sq_bot_01/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad bottom01 esc2 01")
			(ai_place sq_bot_01/esc2_01)
			(ai_place sq_bot_01/esc2_02)
			(ai_place sq_bot_01/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad bottom01 esc3 01")
			(ai_place sq_bot_01/esc3_01)
			(ai_place sq_bot_01/esc3_02)
			(ai_place sq_bot_01/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad bottom01 esc4 01")
			(ai_place sq_bot_01/esc4_01)
			(ai_place sq_bot_01/esc4_02)
			(if (= b_bob 0)
				(begin
					(print "BOB!!!!")
					(ai_place sq_bot_01/esc4_03_bob)
					(set b_bob 1)
				)
				(ai_place sq_bot_01/esc4_03)
			)
		)
	)
)

(script static void sv_bottom02
	(if (= s_escalation 0)
		(begin
			(print "squad bottom02 esc0 01")
			(ai_place sq_bot_02/esc0_01)
			(ai_place sq_bot_02/esc0_02)
			(ai_place sq_bot_02/esc0_03)
			(ai_place sq_bot_02/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad bottom02 esc1 01")
			(ai_place sq_bot_02/esc1_01)
			(ai_place sq_bot_02/esc1_02)
			(ai_place sq_bot_02/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad bottom02 esc2 01")
			(ai_place sq_bot_02/esc2_01)
			(ai_place sq_bot_02/esc2_02)
			(ai_place sq_bot_02/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad bottom02 esc3 01")
			(ai_place sq_bot_02/esc3_01)
			(ai_place sq_bot_02/esc3_02)
			(ai_place sq_bot_02/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad bottom02 esc4 01")
			(ai_place sq_bot_02/esc4_01)
			(ai_place sq_bot_02/esc4_02)
			(ai_place sq_bot_02/esc4_03)
		)
	)
)

(script static void sv_top01
	(if (= s_escalation 0)
		(begin
			(print "squad top01 esc0 01")
			(ai_place sq_top_01/esc0_01)
			(ai_place sq_top_01/esc0_02)
			(ai_place sq_top_01/esc0_03)
			(ai_place sq_top_01/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad top01 esc1 01")
			(ai_place sq_top_01/esc1_01)
			(ai_place sq_top_01/esc1_02)
			(ai_place sq_top_01/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad top01 esc2 01")
			(ai_place sq_top_01/esc2_01)
			(ai_place sq_top_01/esc2_02)
			(ai_place sq_top_01/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad top01 esc3 01")
			(ai_place sq_top_01/esc3_01)
			(ai_place sq_top_01/esc3_02)
			(ai_place sq_top_01/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad top01 esc4 01")
			(ai_place sq_top_01/esc4_01)
			(ai_place sq_top_01/esc4_02)
			(ai_place sq_top_01/esc4_03)
		)
	)
)

(script static void sv_top02
	(if (= s_escalation 0)
		(begin
			(print "squad top02 esc0 01")
			(ai_place sq_top_02/esc0_01)
			(ai_place sq_top_02/esc0_02)
			(ai_place sq_top_02/esc0_03)
			(ai_place sq_top_02/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad top02 esc1 01")
			(ai_place sq_top_02/esc1_01)
			(ai_place sq_top_02/esc1_02)
			(ai_place sq_top_02/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad top02 esc2 01")
			(ai_place sq_top_02/esc2_01)
			(ai_place sq_top_02/esc2_02)
			(ai_place sq_top_02/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad top02 esc3 01")
			(ai_place sq_top_02/esc3_01)
			(ai_place sq_top_02/esc3_02)
			(ai_place sq_top_02/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad top02 esc4 01")
			(ai_place sq_top_02/esc4_01)
			(ai_place sq_top_02/esc4_02)
			(ai_place sq_top_02/esc4_03)
		)
	)
)

(script static void sv_left01
	(if (= s_escalation 0)
		(begin
			(print "squad left01 esc0 01")
			(ai_place sq_left_01/esc0_01)
			(ai_place sq_left_01/esc0_02)
			(ai_place sq_left_01/esc0_03)
			(ai_place sq_left_01/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad left01 esc1 01")
			(ai_place sq_left_01/esc1_01)
			(ai_place sq_left_01/esc1_02)
			(ai_place sq_left_01/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad left01 esc2 01")
			(ai_place sq_left_01/esc2_01)
			(ai_place sq_left_01/esc2_02)
			(ai_place sq_left_01/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad left01 esc3 01")
			(ai_place sq_left_01/esc3_01)
			(ai_place sq_left_01/esc3_02)
			(ai_place sq_left_01/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad left01 esc4 01")
			(ai_place sq_left_01/esc4_01)
			(ai_place sq_left_01/esc4_02)
			(ai_place sq_left_01/esc4_03)
		)
	)
)

(script static void sv_left02
	(if (= s_escalation 0)
		(begin
			(print "squad left02 esc0 01")
			(ai_place sq_left_02/esc0_01)
			(ai_place sq_left_02/esc0_02)
			(ai_place sq_left_02/esc0_03)
			(ai_place sq_left_02/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad left02 esc1 01")
			(ai_place sq_left_02/esc1_01)
			(ai_place sq_left_02/esc1_02)
			(ai_place sq_left_02/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad left02 esc2 01")
			(ai_place sq_left_02/esc2_01)
			(ai_place sq_left_02/esc2_02)
			(ai_place sq_left_02/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad left02 esc3 01")
			(ai_place sq_left_02/esc3_01)
			(ai_place sq_left_02/esc3_02)
			(ai_place sq_left_02/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad left02 esc4 01")
			(ai_place sq_left_02/esc4_01)
			(ai_place sq_left_02/esc4_02)
			(ai_place sq_left_02/esc4_03)
		)
	)
)

(script static void sv_right01
	(if (= s_escalation 0)
		(begin
			(print "squad right01 esc0 01")
			(ai_place sq_right_01/esc0_01)
			(ai_place sq_right_01/esc0_02)
			(ai_place sq_right_01/esc0_03)
			(ai_place sq_right_01/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad right01 esc1 01")
			(ai_place sq_right_01/esc1_01)
			(ai_place sq_right_01/esc1_02)
			(ai_place sq_right_01/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad right01 esc2 01")
			(ai_place sq_right_01/esc2_01)
			(ai_place sq_right_01/esc2_02)
			(ai_place sq_right_01/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad right01 esc3 01")
			(ai_place sq_right_01/esc3_01)
			(ai_place sq_right_01/esc3_02)
			(ai_place sq_right_01/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad right01 esc4 01")
			(ai_place sq_right_01/esc4_01)
			(ai_place sq_right_01/esc4_02)
			(ai_place sq_right_01/esc4_03)
		)
	)
)

(script static void sv_right02
	(if (= s_escalation 0)
		(begin
			(print "squad right02 esc0 01")
			(ai_place sq_right_02/esc0_01)
			(ai_place sq_right_02/esc0_02)
			(ai_place sq_right_02/esc0_03)
			(ai_place sq_right_02/esc0_04)
		)
	)
	(if (= s_escalation 1)
		(begin
			(print "squad right02 esc1 01")
			(ai_place sq_right_02/esc1_01)
			(ai_place sq_right_02/esc1_02)
			(ai_place sq_right_02/esc1_03)
		)
	)
	(if (= s_escalation 2)
		(begin
			(print "squad right02 esc2 01")
			(ai_place sq_right_02/esc2_01)
			(ai_place sq_right_02/esc2_02)
			(ai_place sq_right_02/esc2_03)
		)
	)
	(if (= s_escalation 3)
		(begin
			(print "squad right02 esc3 01")
			(ai_place sq_right_02/esc3_01)
			(ai_place sq_right_02/esc3_02)
			(ai_place sq_right_02/esc3_03)
		)
	)
	(if (= s_escalation 4)
		(begin
			(print "squad right02 esc4 01")
			(ai_place sq_right_02/esc4_01)
			(ai_place sq_right_02/esc4_02)
			(ai_place sq_right_02/esc4_03)
		)
	)
)

(script dormant sc_wraith_top
	(sleep_until (= b_wraith 1) 1)
		(sleep_until 
			(begin
				(sleep_until (<= (ai_task_count obj_vehicles/mg_top) 1) 1)
					(ai_place sq_top_wraith01)
					(sleep 300)
			0)
		1)
)

(script dormant sc_wraith_left
	(sleep_until (= b_wraith 1) 1)
		(sleep_until 
			(begin
				(sleep_until (<= (ai_task_count obj_vehicles/mg_left) 1) 1)
					(ai_place sq_left_wraith01)
					(sleep 300)
			0)
		1)
)

(script dormant sc_wraith_right
	(sleep_until (= b_wraith 1) 1)
		(sleep_until 
			(begin
				(sleep_until (<= (ai_task_count obj_vehicles/mg_right) 1) 1)
					(ai_place sq_right_wraith01)
					(sleep 300)
			0)
		1)
)

(script dormant sc_wraith_bottom
	(sleep_until (= b_wraith 1) 1)
		(sleep_until 
			(begin
				(sleep_until (<= (ai_task_count obj_vehicles/mg_bottom) 1) 1)
					(ai_place sq_bot_wraith01)
					(sleep 300)
			0)
		1)
)

(script dormant sc_fork_bottom
	(sleep_until
		(begin
			(sleep_until (= (ai_living_count sq_tuningfork_bot) 0) 1)
				(ai_place sq_tuningfork_bot)
		0)
	1)
)

(script dormant sc_fork_right
	(sleep_until
		(begin
			(sleep_until (= (ai_living_count sq_tuningfork_right) 0) 1)
				(ai_place sq_tuningfork_right)
		0)
	1)
)

(script dormant sc_fork_left
	(sleep_until
		(begin
			(sleep_until (= (ai_living_count sq_tuningfork_left) 0) 1)
				(ai_place sq_tuningfork_left)
		0)
	1)
)

(script dormant sc_fork_top
	(sleep_until
		(begin
			(sleep_until (= (ai_living_count sq_tuningfork_top) 0) 1)
				(ai_place sq_tuningfork_top)
		0)
	1)
)

; =================================================================================================
; =================================================================================================
; FORK COMMAND SCRIPTS
; =================================================================================================
; =================================================================================================

(script command_script cs_fork01
	(cs_fly_to ps_fork01/p0)
	(cs_fly_to ps_fork01/p1)
	(cs_fly_to ps_fork01/p2)
	(cs_fly_to ps_fork01/p3)
	(cs_fly_to_and_face ps_fork01/p4 ps_fork01/p5)
	(sleep 120)
	(cs_fly_to ps_fork01/p6)
	(cs_fly_to ps_fork01/p7) 
	(cs_fly_to ps_fork01/p8)
	(ai_erase ai_current_squad)
)

(script command_script cs_fork02
	(cs_fly_to ps_fork02/p0)
	(cs_fly_to ps_fork02/p1)
	(cs_fly_to ps_fork02/p2)
	(cs_fly_to ps_fork02/p3)
	(cs_fly_to_and_face ps_fork02/p4 ps_fork02/p5)
	(sleep 120)
	(cs_fly_to ps_fork02/p6)
	(cs_fly_to ps_fork02/p7) 
	(cs_fly_to ps_fork02/p8)
	(ai_erase ai_current_squad)
)

(script command_script cs_fork03
	(cs_fly_to ps_fork03/p0)
	(cs_fly_to ps_fork03/p1)
	(cs_fly_to_and_face ps_fork03/p2 ps_fork03/p3)
	(sleep 120)
	(cs_fly_to ps_fork03/p4)
	(cs_fly_to ps_fork03/p5)
	(cs_fly_to ps_fork03/p6) 
	(ai_erase ai_current_squad)
)

(script command_script cs_fork04
	(cs_fly_to ps_fork04/p0)
	(cs_fly_to ps_fork04/p1)
	(cs_fly_to_and_face ps_fork04/p2 ps_fork04/p3)
	(sleep 120)
	(cs_fly_to ps_fork04/p4)
	(cs_fly_to ps_fork04/p5)
	(cs_fly_to ps_fork04/p6) 
	(ai_erase ai_current_squad)
)

; =================================================================================================
; =================================================================================================
; HILL Objective Control
; =================================================================================================
; =================================================================================================

(global short s_fade_time 30)
(script dormant f_hill_objective_control

	(if (game_is_cooperative) (skull_enable skull_iron FALSE) )

	;(wake f_music_intro)

	(dprint "::: hill encounter :::")
	(f_cin_intro_finish)
	(cinematic_exit 070lb_re_intro FALSE)	

	(game_save_immediate)

	(set b_hill_ready TRUE)

	; Standard Scripts	
	;(wake f_hill_spawn_control) ;fancy sammons shit
	(wake f_hill_death_control)
	(wake f_hill_title_control)
	(wake f_hill_missionobj_control)
	;(wake f_hill_waypoint_control)
	(wake f_hill_music_control)
	;(wake f_hill_md_control)
	;(wake f_hill_save_control)

	; Encounter Scripts 
	(wake sc_spawn_start)
	(wake f_hill_last_crack)

	(dprint "objective control : hill.1")
	(set objcon_hill 1)
	(flock_create flock_banshee)
	;(cinematic_exit 070lb_re_intro FALSE)

	(sleep_until b_last_player_dead 1)
	(if (not cheat_deathless_player)
		(begin
			(if (cinematic_skip_start)
				(begin
					(input_suppress_rumble 1)
					(cinematic_enter 080lc_game_over TRUE)
					(f_cin_outro_prep)
					;(f_play_cinematic_advanced 080lc_game_over set_hill set_cin_outro)
					(set b_cinematic_entered false)
					(if b_debug_globals (print "f_play_cinematic: playing cinematic..."))
					(cinematic_show_letterbox_immediate true)
					(cinematic_run_script_by_name 080lc_game_over)
					(set b_cinematic_entered true)
					(sleep 1)
					
					(f_cin_epilogue_prep)
					;(f_end_mission 080ld_epilogue set_cin_outro)
					(cinematic_enter 080ld_epilogue FALSE)
					(set b_cinematic_entered false)	
					(sleep 1)
					(ai_erase_all)
					(garbage_collect_now)
					(switch_zone_set set_cin_outro)
					(if (cinematic_skip_start) 
						(begin
							(sleep 1)
							(if b_debug_globals (print "play outro cinematic..."))
							(cinematic_show_letterbox true)
							(sleep 30)
							(cinematic_show_letterbox_immediate true)
							(cinematic_run_script_by_name 080ld_epilogue)
							(cinematic_skip_stop_internal)
						)
					)
				)
			)
			;(cinematic_skip_stop 080ld_epilogue)
		  (fade_out 0 0 0 0)
			(sleep 1)
			(game_won)
			(sleep 0)
		)
	)

)

(script dormant f_hill_music_control

	(wake music_hill)

)

(global short s_crack 0)
(global boolean b_hill_last_crack FALSE)
(script dormant f_hill_last_crack

	(sleep_until
		(begin

			(set s_crack 0)
			(if (and (player_is_in_game player0) b_crack_p0 ) (set s_crack (+ s_crack 1) ) )
			(if (and (player_is_in_game player1) b_crack_p1 ) (set s_crack (+ s_crack 1) ) )
			(if (and (player_is_in_game player2) b_crack_p2 ) (set s_crack (+ s_crack 1) ) )
			(if (and (player_is_in_game player3) b_crack_p3 ) (set s_crack (+ s_crack 1) ) )

			(if (= (game_coop_player_count) s_crack) (begin
				(set b_hill_last_crack TRUE)
			))

		b_hill_last_crack)
	1)
	
	(dprint "last crack")
	(set s_music_hill 1)

)

(script static void f_cin_intro_finish

	(ai_place sq_hill_phantom_init)

)


(script static void f_cin_outro_prep

	(object_destroy_type_mask 1039)
	(add_recycling_volume tv_recycle_hill 0 0)
	(add_recycling_volume_by_type tv_recycle_hill 0 0 1039)

	(flock_delete flock_banshee)
	(object_destroy sc_hill_hide_a_rock)
	(ai_erase sg_covenant)

	(sleep_forever sc_spawn_bottom)
	(sleep_forever sc_spawn_bottom)
	(sleep_forever sc_spawn_left)
	(sleep_forever sc_spawn_right)
	(sleep_forever sc_spawn_top)

	(sleep_forever sc_escalation)
	(sleep_forever sc_wraith_top)
	(sleep_forever sc_wraith_bottom)
	(sleep_forever sc_wraith_right)
	(sleep_forever sc_wraith_left)
	(sleep_forever sc_fork_bottom)
	(sleep_forever sc_fork_right)
	(sleep_forever sc_fork_left)
	(sleep_forever sc_fork_top)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_hill_outro/player0)
	(object_teleport_to_ai_point (player1) ps_hill_outro/player1)
	(object_teleport_to_ai_point (player2) ps_hill_outro/player2)
	(object_teleport_to_ai_point (player3) ps_hill_outro/player3)

	(sleep_until b_tit_hill_done)

)

(script static void f_cin_epilogue_prep

	(sleep_forever f_rain)
	(weather_animate_force no_rain 1 0)		

)

(script dormant f_hill_title_control

	(sleep_until (>= objcon_hill 1) 5)
	(wake tit_hill)

)

(script dormant f_hill_missionobj_control

	(sleep_until (>= objcon_hill 1) 5)
	(sleep 200)
	(wake mo_hill)

)

(global real r_damage_messages 0.4)
(global real r_damage_weapons 0.8)
(global real r_damage_grenades 0.8)
(global real r_damage_crack_1 0.9)
(global real r_damage_motion 1.2)
(global real r_damage_shield 1.4)
(global real r_damage_crack_2 1.6)
(global real r_damage_crosshair 2.4)

(script dormant f_hill_death_control

	(game_safe_to_respawn FALSE)

	(wake f_death_tracker)
	;(wake f_hud_messages)
	(wake f_hud_weapons)
	(wake f_hud_grenades)
	;(wake f_hud_motion)
	;(wake f_hud_shield)
	;(wake f_hud_crosshair)
	(wake f_hud_crack_1)
	(wake f_hud_crack_2)

)

(global boolean b_last_player_dead FALSE)
(global short s_players_alive 1)
(global real r_health_min 0.1)
(script dormant f_death_tracker

	(object_cannot_die_except_kill_volumes (player0) TRUE)
	(object_cannot_die_except_kill_volumes (player1) TRUE)
	(object_cannot_die_except_kill_volumes (player2) TRUE)
	(object_cannot_die_except_kill_volumes (player3) TRUE)

	(sleep_until
		(begin
		
			(if
				(and
					(or (not (player_is_in_game player0))(<= (unit_get_health (player0)) r_health_min))
					(or (not (player_is_in_game player1))(<= (unit_get_health (player1)) r_health_min))
					(or (not (player_is_in_game player2))(<= (unit_get_health (player2)) r_health_min))
					(or (not (player_is_in_game player3))(<= (unit_get_health (player3)) r_health_min))
				)
				(begin
					(set b_last_player_dead TRUE)
					(sleep_forever)
				)
			)

			; Count number of living players
			(set s_players_alive 0)
			(if
				(and
					(player_is_in_game player0)
					(> (unit_get_health (player0)) 0)
				)
				(begin
					(set s_players_alive (+ s_players_alive 1))
				)
			)

			(if
				(and
					(player_is_in_game player1)
					(> (unit_get_health (player1)) 0)
				)
				(begin
					(set s_players_alive (+ s_players_alive 1))
				)
			)

			(if
				(and
					(player_is_in_game player2)
					(> (unit_get_health (player2)) 0)
				)
				(begin
					(set s_players_alive (+ s_players_alive 1))
				)
			)
			
			(if
				(and
					(player_is_in_game player3)
					(> (unit_get_health (player3)) 0)
				)
				(begin
					(set s_players_alive (+ s_players_alive 1))
				)
			)
				
			; Handle killing all but last player
			(if (> s_players_alive 1)
				(begin

					(if
						(and
							(player_is_in_game player0)
							(<= (unit_get_health (player0)) r_health_min)
						)
						(begin
							(object_cannot_die_except_kill_volumes (player0) FALSE)
							(tick)
							(unit_kill (player0))
					))

					(if
						(and
							(player_is_in_game player1)
							(<= (unit_get_health (player1)) r_health_min)
						)
						(begin
							(object_cannot_die_except_kill_volumes (player1) FALSE)
							(tick)
							(unit_kill (player1))
					))

					(if
						(and
							(player_is_in_game player2)
							(<= (unit_get_health (player2)) r_health_min)
						)
						(begin
							(object_cannot_die_except_kill_volumes (player2) FALSE)
							(tick)
							(unit_kill (player2))
					))

					(if
						(and
							(player_is_in_game player3)
							(<= (unit_get_health (player3)) r_health_min)
						)
						(begin
							(object_cannot_die_except_kill_volumes (player3) FALSE)
							(tick)
							(unit_kill (player3))
					))

				)
			)
			
			(if 
				(and 
					(= s_players_alive 1)
					(and
						(or
							(not (player_is_in_game player0))
							(<= (unit_get_health (player0)) r_health_min)						
						)
						(or
							(not (player_is_in_game player1))
							(<= (unit_get_health (player1)) r_health_min)						
						)
						(or
							(not (player_is_in_game player2))
							(<= (unit_get_health (player2)) r_health_min)						
						)
						(or
							(not (player_is_in_game player3))
							(<= (unit_get_health (player3)) r_health_min)						
						)
					)
				)
				(set b_last_player_dead TRUE)
			)

		FALSE
		)
	1)

)

(script dormant f_hud_messages

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_messages)
					FALSE
				)
				(begin
					(f_hud_messages_player player0)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_messages)
					FALSE
				)
				(begin
					(f_hud_messages_player player1)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_messages)
					FALSE
				)
				(begin
					(f_hud_messages_player player2)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_messages)
					FALSE
				)
				(begin
					(f_hud_messages_player player3)
				)
			)

			FALSE
		)
	1)

)

(script static void (f_hud_messages_player (player p))

	(chud_fade_messages_for_player p 0 30)

)

(script dormant f_hud_weapons

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_weapons)
					FALSE
				)
				(begin
					(f_hud_weapons_player player0)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_weapons)
					FALSE
				)
				(begin
					(f_hud_weapons_player player1)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_weapons)
					FALSE
				)
				(begin
					(f_hud_weapons_player player2)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_weapons)
					FALSE
				)
				(begin
					(f_hud_weapons_player player3)
				)
			)

			FALSE
		)
	1)

)

(script static void (f_hud_weapons_player (player p))

	(chud_fade_weapon_stats_for_player p 0 30)

)

(script dormant f_hud_grenades

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_grenades)
					FALSE
				)
				(begin
					(f_hud_grenades_player player0)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_grenades)
					FALSE
				)
				(begin
					(f_hud_grenades_player player1)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_grenades)
					FALSE
				)
				(begin
					(f_hud_grenades_player player2)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_grenades)
					FALSE
				)
				(begin
					(f_hud_grenades_player player3)
				)
			)

			FALSE
		)
	1)

)

(script static void (f_hud_grenades_player (player p))

	(chud_fade_grenades_for_player p 0 30)

)

(script dormant f_hud_motion

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_motion)
					FALSE
				)
				(begin
					(f_hud_motion_player player0)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_motion)
					FALSE
				)
				(begin
					(f_hud_motion_player player1)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_motion)
					FALSE
				)
				(begin
					(f_hud_motion_player player2)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_motion)
					FALSE
				)
				(begin
					(f_hud_motion_player player3)
				)
			)

			FALSE
		)
	1)

)

(script static void (f_hud_motion_player (player p))

	(chud_fade_motion_sensor_for_player p 0 30)
	(sleep 30)
	(chud_set_static_hs_variable p 4 1)

)

(script dormant f_hud_shield

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_shield)
					FALSE
				)
				(begin
					(f_hud_shield_player player0)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_shield)
					FALSE
				)
				(begin
					(f_hud_shield_player player1)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_shield)
					FALSE
				)
				(begin
					(f_hud_shield_player player2)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_shield)
					FALSE
				)
				(begin
					(f_hud_shield_player player3)
				)
			)

			FALSE
		)
	1)

)

(script static void (f_hud_shield_player (player p))

	(chud_fade_shield_for_player p 0 30)

)

(script dormant f_hud_crosshair

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_crosshair)
					FALSE
				)
				(begin
					(f_hud_crosshair_player player0)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_crosshair)
					FALSE
				)
				(begin
					(f_hud_crosshair_player player1)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_crosshair)
					FALSE
				)
				(begin
					(f_hud_crosshair_player player2)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_crosshair)
					FALSE
				)
				(begin
					(f_hud_crosshair_player player3)
				)
			)

			FALSE
		)
	1)

)

(script static void (f_hud_crosshair_player (player p))

	(chud_fade_crosshair_for_player p 0 30)

)

(global boolean b_crack_p0 FALSE)
(global boolean b_crack_p1 FALSE)
(global boolean b_crack_p2 FALSE)
(global boolean b_crack_p3 FALSE)
(script dormant f_hud_crack_1

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_crack_1)
					FALSE
				)
				(begin
					(f_hud_crack_1_player player0)
					(set b_crack_p0 TRUE)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_crack_1)
					FALSE
				)
				(begin
					(f_hud_crack_1_player player1)
					(set b_crack_p1 TRUE)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_crack_1)
					FALSE
				)
				(begin
					(f_hud_crack_1_player player2)
					(set b_crack_p2 TRUE)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_crack_1)
					FALSE
				)
				(begin
					(f_hud_crack_1_player player3)
					(set b_crack_p3 TRUE)
				)
			)

			FALSE
		)
	1)

)


(script static void (f_hud_crack_1_player (player p))

	(chud_set_static_hs_variable p 3 1)

)


(script dormant f_hud_crack_2

	(sleep_until
		(begin

			(if
				(or
					(>= r_p0_damage_tracker r_damage_crack_2)
					FALSE
				)
				(begin
					(f_hud_crack_2_player player0)
				)
			)

			(if
				(or
					(>= r_p1_damage_tracker r_damage_crack_2)
					FALSE
				)
				(begin
					(f_hud_crack_2_player player1)
				)
			)

			(if
				(or
					(>= r_p2_damage_tracker r_damage_crack_2)
					FALSE
				)
				(begin
					(f_hud_crack_2_player player2)
				)
			)

			(if
				(or
					(>= r_p3_damage_tracker r_damage_crack_2)
					FALSE
				)
				(begin
					(f_hud_crack_2_player player3)
				)
			)

			FALSE
		)
	1)

)

(script static void (f_hud_crack_2_player (player p))

	(chud_set_static_hs_variable p 2 1)
	(chud_clear_hs_variable p 4)

)

;*
(script dormant f_hill_spawn_control

	; Wave 0
	(sleep_until (>= objcon_hill 1))
	(f_hill_phantom_2 sq_hill_cov_w0_1 sq_hill_cov_w0_2 sq_hill_cov_w0_3 NONE NONE NONE NONE)
	(tick)

	; Wave 1
	(sleep_until
		(and
			(<= (ai_living_count obj_hill_cov) 3)
			(f_phantom_2_not_spawning)
		)
	)
	(f_hill_phantom_0 sq_hill_cov_w1_1 sq_hill_cov_w1_2 sq_hill_cov_w1_3 NONE NONE NONE NONE)
	(tick)
	
	; Wave 2 & 3 (repeat)

	(sleep_until
		(and
			(<= (ai_living_count obj_hill_cov) 3)
			(f_phantom_0_not_spawning)
		)
	)
	(sleep_until
		(begin

			(sleep_until
				(and
					(<= (ai_living_count obj_hill_cov) 3)
					(f_phantom_4_not_spawning)
					(f_phantom_1_not_spawning)
				)
			)
			(f_hill_phantom_2 sq_hill_cov_w2_1 sq_hill_cov_w2_2 sq_hill_cov_w2_3 NONE NONE NONE NONE)
			(tick)
		
		
			(sleep_until
				(and
					(<= (ai_living_count obj_hill_cov) 3)
					(f_phantom_2_not_spawning)
				)
			)
			(f_hill_phantom_4 sq_hill_cov_w4_1 sq_hill_cov_w4_2 sq_hill_cov_w4_3 NONE NONE NONE NONE)
			(f_hill_phantom_1 NONE NONE NONE NONE NONE sq_hill_cov_w5_1 NONE)
			
		FALSE)
	1)

)
*;

(script static boolean f_phantom_0_not_spawning

	(or
		(not b_sq_hill_phantom_0_spawn)
		(<= (object_get_health (ai_vehicle_get_from_squad sq_hill_phantom_0 0) ) 0)			
	)

)


(script static boolean f_phantom_1_not_spawning

	(or
		(not b_sq_hill_phantom_1_spawn)
		(<= (object_get_health (ai_vehicle_get_from_squad sq_hill_phantom_1 0) ) 0)			
	)

)

(script static boolean f_phantom_2_not_spawning

	(or
		(not b_sq_hill_phantom_2_spawn)
		(<= (object_get_health (ai_vehicle_get_from_squad sq_hill_phantom_2 0) ) 0)			
	)

)

(script static boolean f_phantom_3_not_spawning

	(or
		(not b_sq_hill_phantom_3_spawn)
		(<= (object_get_health (ai_vehicle_get_from_squad sq_hill_phantom_3 0) ) 0)			
	)

)

(script static boolean f_phantom_4_not_spawning

	(or
		(not b_sq_hill_phantom_4_spawn)
		(<= (object_get_health (ai_vehicle_get_from_squad sq_hill_phantom_4 0) ) 0)			
	)

)

; =================================================================================================
; =================================================================================================
; TEST
; =================================================================================================
; =================================================================================================

;----------------------------------------------------------------------------------------------------
; Utility

(script static void (dprint (string s) )
	(if b_debug (print s))
)

(script static void (md_print (string s) )
	(if b_md_print (print s))
)

(script static void (dbreak (string s) )
	(if (or (not (editor_mode)) b_breakpoints) (breakpoint s))
)

(script static void f_abort
	(dprint "function aborted")
)

(script static void tick
	(sleep 1)
)

(script command_script f_cs_draw
	(cs_stow 0)
)

(script static boolean difficulty_is_normal_or_higher  

	(or 
		(= (game_difficulty_get) normal)  
		(= (game_difficulty_get) heroic)  
		(= (game_difficulty_get) legendary)  
	) 

) 
 
(script static boolean difficulty_is_heroic_or_higher  

	(or 
		(= (game_difficulty_get) heroic)  
		(= (game_difficulty_get) legendary)  
	) 

) 
 
(script static boolean difficulty_is_legendary  

	(= (game_difficulty_get) legendary) 

)  

;----------------------------------------------------------------------------------------------------
; Shortcuts

; sh - half speed
(script static void sh
	(if (!= game_speed .5)
		(set game_speed .5)
		(set game_speed 1)
	)
)

; s0 - pause/unpause
(script static void s0
	(if (!= game_speed 0)
		(set game_speed 0)
		(set game_speed 1)
	)
)

; s5 - game speed 5
(script static void s5
	(if (!= game_speed 5)
		(set game_speed 5)
		(set game_speed 1)
	)
)

; b - bsps
(script static void b
	(if ai_render_sector_bsps
		(begin
			(set ai_render_sector_bsps 0)
			(print "ai_render_sector_bsps OFF")
		)
		(begin
			(set ai_render_sector_bsps 1)
			(print "ai_render_sector_bsps ON")
		)
	)
)

; o - objectives
(script static void o
	(if ai_render_objectives
		(begin
			(set ai_render_objectives 0)
			(print "render objectives OFF")
		)
		(begin
			(set ai_render_objectives 1)
			(print "render objectives ON")
		)
	)
)

; d - decisions
(script static void d
	(if ai_render_decisions
		(begin
			(set ai_render_decisions 0)
			(print "ai_render_decisions OFF")
		)
		(begin
			(set ai_render_decisions 1)
			(print "ai_render_decisions ON")
		)
	)
)

; c - command scripts
(script static void c
	(if ai_render_command_scripts
		(begin
			(set ai_render_command_scripts 0)
			(print "ai_render_command_scripts OFF")
		)
		(begin
			(set ai_render_command_scripts 1)
			(print "ai_render_command_scripts ON")
		)
	)
)

; p - command scripts
(script static void p
	(if debug_performances
		(begin
			(set debug_performances 0)
			(print "debug_performances OFF")
		)
		(begin
			(set debug_performances 1)
			(print "debug_performances ON")
		)
	)
)


(global boolean b_debug_scripting TRUE)
; s - debug scripting
(script static void s
	(if b_debug_scripting
		(begin
			(debug_scripting FALSE)
			(print "debug_scripting OFF")
			(set b_debug_scripting FALSE)
		)
		(begin
			(debug_scripting TRUE)
			(print "debug_scripting ON")
			(set b_debug_scripting TRUE)
		)
	)
)


; f - cinematic_fade_to_gameplay
(script static void f
	(print "cinematic_fade_to_gameplay")
	(cinematic_fade_to_gameplay)
)


; pr - ai render props
(script static void pr
	(if ai_render_props
		(begin
			(set ai_render_props 0)
			(print "ai_render_props OFF")
		)
		(begin
			(set ai_render_props 1)
			(print "ai_render_props ON")
		)
	)
)


; be - ai render behavior stack
(script static void be
	(if ai_render_behavior_stack_all
		(begin
			(set ai_render_behavior_stack_all 0)
			(print "ai_render_behavior_stack_all OFF")
		)
		(begin
			(set ai_render_behavior_stack_all 1)
			(print "ai_render_behavior_stack_all ON")
		)
	)
)


; de - ai render decisions
(script static void de
	(if ai_render_decisions
		(begin
			(set ai_render_decisions 0)
			(print "ai_render_decisions OFF")
		)
		(begin
			(set ai_render_decisions 1)
			(print "ai_render_decisions ON")
		)
	)
)

; damage Tracker Scripts
; =================================================================================================
(global real r_p0_damage_tracker 0)
(global real r_p0_shield_last 1)
(global real r_p0_health_last 1)

(global real r_p1_damage_tracker 0)
(global real r_p1_shield_last 1)
(global real r_p1_health_last 1)

(global real r_p2_damage_tracker 0)
(global real r_p2_shield_last 1)
(global real r_p2_health_last 1)

(global real r_p3_damage_tracker 0)
(global real r_p3_shield_last 1)
(global real r_p3_health_last 1)

(script continuous f_p0_damage_tracker

	(sleep_until (>= objcon_hill 1) 1)

	(sleep_until
		(begin
				
			(if (< (unit_get_shield (player0)) r_p0_shield_last )
				(begin
				
					;(dprint "shield damage done")
					(set r_p0_damage_tracker (+ r_p0_damage_tracker (- r_p0_shield_last (unit_get_shield (player0)))))
			
				)
			)

			(if (< (unit_get_health (player0)) r_p0_health_last )
				(begin
				
					;(dprint "health damage done")
					(set r_p0_damage_tracker (+ r_p0_damage_tracker (- r_p0_health_last (unit_get_health (player0)))))

				)
			)

			(set r_p0_shield_last (unit_get_shield (player0)))
			(set r_p0_health_last (unit_get_health (player0)))

		(player_is_in_game player0))
	1)
			
)

(script continuous f_p1_damage_tracker

	(sleep_until (>= objcon_hill 1) 1)

	(sleep_until
		(begin
				
			(if (< (unit_get_shield (player1)) r_p1_shield_last )
				(begin
				
					(dprint "shield damage done")
					(set r_p1_damage_tracker (+ r_p1_damage_tracker (- r_p1_shield_last (unit_get_shield (player1)))))
			
				)
			)

			(if (< (unit_get_health (player1)) r_p1_health_last )
				(begin
				
					(dprint "health damage done")
					(set r_p1_damage_tracker (+ r_p1_damage_tracker (- r_p1_health_last (unit_get_health (player1)))))

				)
			)

			(set r_p1_shield_last (unit_get_shield (player1)))
			(set r_p1_health_last (unit_get_health (player1)))

		(player_is_in_game player1))
	1)
			
)

(script continuous f_p2_damage_tracker

	(sleep_until (>= objcon_hill 1) 1)

	(sleep_until
		(begin
				
			(if (< (unit_get_shield (player2)) r_p2_shield_last )
				(begin
				
					(dprint "shield damage done")
					(set r_p2_damage_tracker (+ r_p2_damage_tracker (- r_p2_shield_last (unit_get_shield (player2)))))
			
				)
			)

			(if (< (unit_get_health (player2)) r_p2_health_last )
				(begin
				
					(dprint "health damage done")
					(set r_p2_damage_tracker (+ r_p2_damage_tracker (- r_p2_health_last (unit_get_health (player2)))))

				)
			)

			(set r_p2_shield_last (unit_get_shield (player2)))
			(set r_p2_health_last (unit_get_health (player2)))

		(player_is_in_game player2))
	1)
			
)

(script continuous f_p3_damage_tracker

	(sleep_until (>= objcon_hill 1) 1)

	(debug_scripting_variable 's_p3_damage_tracker' TRUE)

	(sleep_until
		(begin
				
			(if (< (unit_get_shield (player3)) r_p3_shield_last )
				(begin
				
					(dprint "shield damage done")
					(set r_p3_damage_tracker (+ r_p3_damage_tracker (- r_p3_shield_last (unit_get_shield (player3)))))
			
				)
			)

			(if (< (unit_get_health (player3)) r_p3_health_last )
				(begin
				
					(dprint "health damage done")
					(set r_p3_damage_tracker (+ r_p3_damage_tracker (- r_p3_health_last (unit_get_health (player3)))))

				)
			)

			(set r_p3_shield_last (unit_get_shield (player3)))
			(set r_p3_health_last (unit_get_health (player3)))

		(player_is_in_game player3))
	1)
			
)

; Phantoms
; =================================================================================================
(global boolean b_sq_hill_phantom_init_spawn FALSE)
(script command_script f_cs_hill_phantom_init

	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)

	(set b_sq_hill_phantom_0_spawn TRUE)
	(cs_vehicle_speed .2)
	(cs_fly_by ps_hill_phantom_init/hover_out)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_hill_phantom_init/exit_01)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_hill_phantom_init/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0 (* 30 5))
	(cs_fly_by ps_hill_phantom_init/erase)
	(print "drop")

)


; Phantom 0
(global ai ai_phantom_0_1 NONE)
(global ai ai_phantom_0_2 NONE)
(global ai ai_phantom_0_3 NONE)
(global ai ai_phantom_0_4 NONE)
(global ai ai_phantom_0_5 NONE)
(global ai ai_phantom_0_v1 NONE)
(global ai ai_phantom_0_v2 NONE)

(script static void
	(f_hill_phantom_0
		(ai sq_1)
		(ai sq_2)
		(ai sq_3)
		(ai sq_4)
		(ai sq_5)
		(ai sq_v1)
		(ai sq_v2)
	)
	
	(set ai_phantom_0_1 sq_1)
	(set ai_phantom_0_2 sq_2)
	(set ai_phantom_0_3 sq_3)
	(set ai_phantom_0_4 sq_4)
	(set ai_phantom_0_5 sq_5)	
	(set ai_phantom_0_v1 sq_v1)
	(set ai_phantom_0_v2 sq_v2)
	
	(ai_place sq_hill_phantom_0)
	(cs_run_command_script sq_hill_phantom_0/driver f_cs_sq_hill_phantom_0)

)

(global boolean b_sq_hill_phantom_0_spawn FALSE)
(script command_script f_cs_sq_hill_phantom_0

	(if (and (not (= ai_phantom_0_v1 NONE)) (= ai_phantom_0_v2 NONE) )
		(begin
			(f_load_phantom_cargo ai_current_squad "single" ai_phantom_0_v1 NONE)
		)	
	)

	(if (and (not (= ai_phantom_0_v1 NONE) ) (not (= ai_phantom_0_v2 NONE) ) )
		(begin
			(f_load_phantom_cargo ai_current_squad "double" ai_phantom_0_v1 ai_phantom_0_v2)
		)
	)

	(set b_sq_hill_phantom_0_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_hill_phantom_0/enter_01)
	(cs_fly_by ps_hill_phantom_0/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_hill_phantom_0/drop ps_hill_phantom_0/drop_face .25)
	(print "drop")

	(if (and (not (= ai_phantom_0_v1 NONE)) (= ai_phantom_0_v2 NONE) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "single")
			(sleep 120)
		)
	)

	(if (and (not (= ai_phantom_0_v1 NONE)) (not (= ai_phantom_0_v2 NONE)) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "double")
			(sleep 120)
		)
	)

	(if (not (= ai_phantom_0_1 NONE))
		(begin
			(ai_place ai_phantom_0_1)
			(ai_vehicle_enter_immediate ai_phantom_0_1 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_0_2 NONE))
		(begin
			(ai_place ai_phantom_0_2)
			(ai_vehicle_enter_immediate ai_phantom_0_2 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_0_3 NONE))
		(begin
			(ai_place ai_phantom_0_3)
			(ai_vehicle_enter_immediate ai_phantom_0_3 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_0_4 NONE))
		(begin
			(ai_place ai_phantom_0_4)
			(ai_vehicle_enter_immediate ai_phantom_0_4 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_0_5 NONE))
		(begin
			(ai_place ai_phantom_0_5)
			(ai_vehicle_enter_immediate ai_phantom_0_5 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(set b_sq_hill_phantom_0_spawn FALSE)
	(cs_fly_by ps_hill_phantom_0/hover_out)
	(cs_fly_by ps_hill_phantom_0/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_hill_phantom_0/erase)
	(ai_erase ai_current_squad)

)

; Phantom 1
(global ai ai_phantom_1_1 NONE)
(global ai ai_phantom_1_2 NONE)
(global ai ai_phantom_1_3 NONE)
(global ai ai_phantom_1_4 NONE)
(global ai ai_phantom_1_5 NONE)
(global ai ai_phantom_1_v1 NONE)
(global ai ai_phantom_1_v2 NONE)

(script static void
	(f_hill_phantom_1
		(ai sq_1)
		(ai sq_2)
		(ai sq_3)
		(ai sq_4)
		(ai sq_5)
		(ai sq_v1)
		(ai sq_v2)
	)
	
	(set ai_phantom_1_1 sq_1)
	(set ai_phantom_1_2 sq_2)
	(set ai_phantom_1_3 sq_3)
	(set ai_phantom_1_4 sq_4)
	(set ai_phantom_1_5 sq_5)	
	(set ai_phantom_1_v1 sq_v1)
	(set ai_phantom_1_v2 sq_v2)
	
	(ai_place sq_hill_phantom_1)
	(cs_run_command_script sq_hill_phantom_1/driver f_cs_sq_hill_phantom_1)

)

(global boolean b_sq_hill_phantom_1_spawn FALSE)
(script command_script f_cs_sq_hill_phantom_1

	(if (and (not (= ai_phantom_1_v1 NONE)) (= ai_phantom_1_v2 NONE) )
		(begin
			(print "load single")
			(f_load_phantom_cargo ai_current_squad "single" ai_phantom_1_v1 NONE)
		)	
	)

	(if (and (not (= ai_phantom_1_v1 NONE) ) (not (= ai_phantom_1_v2 NONE) ) )
		(begin
			(print "load double")
			(f_load_phantom_cargo ai_current_squad "double" ai_phantom_1_v1 ai_phantom_1_v2)
		)
	)

	(set b_sq_hill_phantom_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_hill_phantom_1/enter_01)
	(cs_fly_by ps_hill_phantom_1/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_hill_phantom_1/drop ps_hill_phantom_1/drop_face .25)
	(print "drop")

	(if (and (not (= ai_phantom_1_v1 NONE)) (= ai_phantom_1_v2 NONE) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "single")
			(sleep 120)
		)
	)

	(if (and (not (= ai_phantom_1_v1 NONE)) (not (= ai_phantom_1_v2 NONE)) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "double")
			(sleep 120)
		)
	)

	(if (not (= ai_phantom_1_1 NONE))
		(begin
			(ai_place ai_phantom_1_1)
			(ai_vehicle_enter_immediate ai_phantom_1_1 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_1_2 NONE))
		(begin
			(ai_place ai_phantom_1_2)
			(ai_vehicle_enter_immediate ai_phantom_1_2 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_1_3 NONE))
		(begin
			(ai_place ai_phantom_1_3)
			(ai_vehicle_enter_immediate ai_phantom_1_3 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_1_4 NONE))
		(begin
			(ai_place ai_phantom_1_4)
			(ai_vehicle_enter_immediate ai_phantom_1_4 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_1_5 NONE))
		(begin
			(ai_place ai_phantom_1_5)
			(ai_vehicle_enter_immediate ai_phantom_1_5 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(set b_sq_hill_phantom_1_spawn FALSE)
	(cs_fly_by ps_hill_phantom_1/hover_out)
	(cs_fly_by ps_hill_phantom_1/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_hill_phantom_1/erase)
	(ai_erase ai_current_squad)

)

; Phantom 2
(global ai ai_phantom_2_1 NONE)
(global ai ai_phantom_2_2 NONE)
(global ai ai_phantom_2_3 NONE)
(global ai ai_phantom_2_4 NONE)
(global ai ai_phantom_2_5 NONE)
(global ai ai_phantom_2_v1 NONE)
(global ai ai_phantom_2_v2 NONE)

(script static void
	(f_hill_phantom_2
		(ai sq_1)
		(ai sq_2)
		(ai sq_3)
		(ai sq_4)
		(ai sq_5)
		(ai sq_v1)
		(ai sq_v2)
	)
	
	(set ai_phantom_2_1 sq_1)
	(set ai_phantom_2_2 sq_2)
	(set ai_phantom_2_3 sq_3)
	(set ai_phantom_2_4 sq_4)
	(set ai_phantom_2_5 sq_5)	
	(set ai_phantom_2_v1 sq_v1)
	(set ai_phantom_2_v2 sq_v2)
	
	(ai_place sq_hill_phantom_2)
	(cs_run_command_script sq_hill_phantom_2/driver f_cs_sq_hill_phantom_2)

)

(global boolean b_sq_hill_phantom_2_spawn FALSE)
(script command_script f_cs_sq_hill_phantom_2

	(if (and (not (= ai_phantom_2_v1 NONE)) (= ai_phantom_2_v2 NONE) )
		(begin
			(f_load_phantom_cargo ai_current_squad "single" ai_phantom_2_v1 NONE)
		)	
	)

	(if (and (not (= ai_phantom_2_v1 NONE) ) (not (= ai_phantom_2_v2 NONE) ) )
		(begin
			(f_load_phantom_cargo ai_current_squad "double" ai_phantom_2_v1 ai_phantom_2_v2)
		)
	)

	(set b_sq_hill_phantom_2_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_hill_phantom_2/enter_01)
	(cs_fly_by ps_hill_phantom_2/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_hill_phantom_2/drop ps_hill_phantom_2/drop_face .25)
	(print "drop")

	(if (and (not (= ai_phantom_2_v1 NONE)) (= ai_phantom_2_v2 NONE) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "single")
			(sleep 120)
		)
	)

	(if (and (not (= ai_phantom_2_v1 NONE)) (not (= ai_phantom_2_v2 NONE)) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "double")
			(sleep 120)
		)
	)

	(if (not (= ai_phantom_2_1 NONE))
		(begin
			(ai_place ai_phantom_2_1)
			(ai_vehicle_enter_immediate ai_phantom_2_1 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_2_2 NONE))
		(begin
			(ai_place ai_phantom_2_2)
			(ai_vehicle_enter_immediate ai_phantom_2_2 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_2_3 NONE))
		(begin
			(ai_place ai_phantom_2_3)
			(ai_vehicle_enter_immediate ai_phantom_2_3 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_2_4 NONE))
		(begin
			(ai_place ai_phantom_2_4)
			(ai_vehicle_enter_immediate ai_phantom_2_4 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_2_5 NONE))
		(begin
			(ai_place ai_phantom_2_5)
			(ai_vehicle_enter_immediate ai_phantom_2_5 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(set b_sq_hill_phantom_2_spawn FALSE)
	(cs_fly_by ps_hill_phantom_2/hover_out)
	(cs_fly_by ps_hill_phantom_2/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_hill_phantom_2/erase)
	(ai_erase ai_current_squad)

)

; Phantom 3
(global ai ai_phantom_3_1 NONE)
(global ai ai_phantom_3_2 NONE)
(global ai ai_phantom_3_3 NONE)
(global ai ai_phantom_3_4 NONE)
(global ai ai_phantom_3_5 NONE)
(global ai ai_phantom_3_v1 NONE)
(global ai ai_phantom_3_v2 NONE)

(script static void
	(f_hill_phantom_3
		(ai sq_1)
		(ai sq_2)
		(ai sq_3)
		(ai sq_4)
		(ai sq_5)
		(ai sq_v1)
		(ai sq_v2)
	)
	
	(set ai_phantom_3_1 sq_1)
	(set ai_phantom_3_2 sq_2)
	(set ai_phantom_3_3 sq_3)
	(set ai_phantom_3_4 sq_4)
	(set ai_phantom_3_5 sq_5)	
	(set ai_phantom_3_v1 sq_v1)
	(set ai_phantom_3_v2 sq_v2)
	
	(ai_place sq_hill_phantom_3)
	(cs_run_command_script sq_hill_phantom_3/driver f_cs_sq_hill_phantom_3)

)

(global boolean b_sq_hill_phantom_3_spawn FALSE)
(script command_script f_cs_sq_hill_phantom_3

	(if (and (not (= ai_phantom_3_v1 NONE)) (= ai_phantom_3_v2 NONE) )
		(begin
			(print "load single")
			(f_load_phantom_cargo ai_current_squad "single" ai_phantom_3_v1 NONE)
		)	
	)

	(if (and (not (= ai_phantom_3_v1 NONE) ) (not (= ai_phantom_3_v2 NONE) ) )
		(begin
			(print "load double")
			(f_load_phantom_cargo ai_current_squad "double" ai_phantom_3_v1 ai_phantom_3_v2)
		)
	)

	(set b_sq_hill_phantom_3_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_hill_phantom_3/enter_01)
	(cs_fly_by ps_hill_phantom_3/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_hill_phantom_3/drop ps_hill_phantom_3/drop_face .25)
	(print "drop")

	(if (and (not (= ai_phantom_3_v1 NONE)) (= ai_phantom_3_v2 NONE) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "single")
			(sleep 120)
		)
	)

	(if (and (not (= ai_phantom_3_v1 NONE)) (not (= ai_phantom_3_v2 NONE)) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "double")
			(sleep 120)
		)
	)

	(if (not (= ai_phantom_3_1 NONE))
		(begin
			(print "place 3_1")
			(ai_place ai_phantom_3_1)
			(ai_vehicle_enter_immediate ai_phantom_3_1 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_3_2 NONE))
		(begin
			(ai_place ai_phantom_3_2)
			(ai_vehicle_enter_immediate ai_phantom_3_2 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_3_3 NONE))
		(begin
			(ai_place ai_phantom_3_3)
			(ai_vehicle_enter_immediate ai_phantom_3_3 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_3_4 NONE))
		(begin
			(ai_place ai_phantom_3_4)
			(ai_vehicle_enter_immediate ai_phantom_3_4 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_3_5 NONE))
		(begin
			(ai_place ai_phantom_3_5)
			(ai_vehicle_enter_immediate ai_phantom_3_5 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(set b_sq_hill_phantom_3_spawn FALSE)
	(cs_fly_by ps_hill_phantom_3/hover_out)
	(cs_fly_by ps_hill_phantom_3/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_hill_phantom_3/erase)
	(ai_erase ai_current_squad)

)

; Phantom 4
(global ai ai_phantom_4_1 NONE)
(global ai ai_phantom_4_2 NONE)
(global ai ai_phantom_4_3 NONE)
(global ai ai_phantom_4_4 NONE)
(global ai ai_phantom_4_5 NONE)
(global ai ai_phantom_4_v1 NONE)
(global ai ai_phantom_4_v2 NONE)

(script static void
	(f_hill_phantom_4
		(ai sq_1)
		(ai sq_2)
		(ai sq_3)
		(ai sq_4)
		(ai sq_5)
		(ai sq_v1)
		(ai sq_v2)
	)
	
	(set ai_phantom_4_1 sq_1)
	(set ai_phantom_4_2 sq_2)
	(set ai_phantom_4_3 sq_3)
	(set ai_phantom_4_4 sq_4)
	(set ai_phantom_4_5 sq_5)	
	(set ai_phantom_4_v1 sq_v1)
	(set ai_phantom_4_v2 sq_v2)
	
	(ai_place sq_hill_phantom_4)
	(cs_run_command_script sq_hill_phantom_4/driver f_cs_sq_hill_phantom_4)

)

(global boolean b_sq_hill_phantom_4_spawn FALSE)
(script command_script f_cs_sq_hill_phantom_4

	(if (and (not (= ai_phantom_4_v1 NONE)) (= ai_phantom_4_v2 NONE) )
		(begin
			(f_load_phantom_cargo ai_current_squad "single" ai_phantom_4_v1 NONE)
		)	
	)

	(if (and (not (= ai_phantom_4_v1 NONE) ) (not (= ai_phantom_4_v2 NONE) ) )
		(begin
			(f_load_phantom_cargo ai_current_squad "double" ai_phantom_4_v1 ai_phantom_4_v2)
		)
	)

	(set b_sq_hill_phantom_4_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_hill_phantom_4/enter_01)
	(cs_fly_by ps_hill_phantom_4/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_hill_phantom_4/drop ps_hill_phantom_4/drop_face .25)
	(print "drop")

	(if (and (not (= ai_phantom_4_v1 NONE)) (= ai_phantom_4_v2 NONE) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "single")
			(sleep 120)
		)
	)

	(if (and (not (= ai_phantom_4_v1 NONE)) (not (= ai_phantom_4_v2 NONE)) )
		(begin
			(f_unload_phantom_cargo ai_current_squad "double")
			(sleep 120)
		)
	)

	(if (not (= ai_phantom_4_1 NONE))
		(begin
			(ai_place ai_phantom_4_1)
			(ai_vehicle_enter_immediate ai_phantom_4_1 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_4_2 NONE))
		(begin
			(ai_place ai_phantom_4_2)
			(ai_vehicle_enter_immediate ai_phantom_4_2 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_4_3 NONE))
		(begin
			(ai_place ai_phantom_4_3)
			(ai_vehicle_enter_immediate ai_phantom_4_3 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_4_4 NONE))
		(begin
			(ai_place ai_phantom_4_4)
			(ai_vehicle_enter_immediate ai_phantom_4_4 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(if (not (= ai_phantom_4_5 NONE))
		(begin
			(ai_place ai_phantom_4_5)
			(ai_vehicle_enter_immediate ai_phantom_4_5 (ai_vehicle_get ai_current_actor) "phantom_pc")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
			(sleep 120)		
		)
	)

	(set b_sq_hill_phantom_4_spawn FALSE)
	(cs_fly_by ps_hill_phantom_4/hover_out)
	(cs_fly_by ps_hill_phantom_4/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_hill_phantom_4/erase)
	(ai_erase ai_current_squad)

)

; BODIES
; -------------------------------------------------------------------------------------------------
(global short pose_against_wall_var1     0)
(global short pose_against_wall_var2     1)
(global short pose_against_wall_var3     2)
(global short pose_against_wall_var4     3)
(global short pose_on_back_var1          4)
(global short pose_on_back_var2          5)
(global short pose_on_side_var1          6)
(global short pose_on_side_var2          7)
(global short pose_on_back_var3          8)
(global short pose_face_down_var1        9)
(global short pose_face_down_var2        10)
(global short pose_on_side_var3          11)
(global short pose_on_side_var4          12)
(global short pose_face_down_var3        13)
(global short pose_on_side_var5          14)


(script static void (pose_body (object_name body_name) (short pose))
       (object_create body_name)
       (cond
              ((= pose pose_against_wall_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_01))
              ((= pose pose_against_wall_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_02))
              ((= pose pose_against_wall_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_03))
              ((= pose pose_against_wall_var4) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_04))
              ((= pose pose_on_back_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_05))
              ((= pose pose_on_back_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_06))
              ((= pose pose_on_side_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_07))
              ((= pose pose_on_side_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_08))
              ((= pose pose_on_back_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_09))
              ((= pose pose_face_down_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_10))
              ((= pose pose_face_down_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_11))
              ((= pose pose_on_side_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_12))
              ((= pose pose_on_side_var4) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_13))
              ((= pose pose_face_down_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_14))
              ((= pose pose_on_side_var5) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_15))
       )             
)