(script dormant m60_insertion_stub
	(if g_debug (print "m60 insertion stub"))
)

;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================
(global short g_set_all 10)

;=========================================================================================
;================================== LEVEL START =========================================
;=========================================================================================
(script static void ins_main_start
	(if (editor_mode)
		(fade_in 0 0 0 0)	
		(m60_cin_intro)
	)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if g_debug (print "switching zone sets..."))
;			(switch_zone_set set_060)
			(sleep 1)
		)
	)
	; set insertion point index 
	(set g_insertion_index 1)
)

(script static void ins_motorpool

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(ai_erase_all)
				(if g_debug (print "switching zone sets..."))
				(switch_zone_set initial_zone_set)
				(sleep 1)
			)
		)

		(object_teleport player0 ins_motorpool_start_00)
		(object_teleport player1 ins_motorpool_start_01)
		(object_teleport player2 ins_motorpool_start_02)
		(object_teleport player3 ins_motorpool_start_03)

		; set insertion point index
		(set g_insertion_index 2)
		
		(set intro_obj_control 100)
		
		(sleep 1)

		; temporarily start the mission script
		;(wake m60_mission)	
		(fade_in 0 0 0 0)		
		;(objectives_finish_up_to 0)
		(game_save)

)

(script static void ins_supply_depot

			
		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(ai_erase_all)
				(if g_debug (print "switching zone sets..."))
				(switch_zone_set initial_zone_set)
				(sleep 1)
			)
		)

		; set insertion point index
		(set g_insertion_index 3)
		
		(set intro_obj_control 100)
		(set motorpool_obj_control 100)
		
		(sleep 1)

		(object_teleport player0 ins_supply_start_00)
		(object_teleport player1 ins_supply_start_01)
		(object_teleport player2 ins_supply_start_02)
		(object_teleport player3 ins_supply_start_03)

		; temporarily start the mission script
		(wake m60_mission)	
		(fade_in 0 0 0 0)			
		;(objectives_finish_up_to 0)
		(game_save)
			

)
(script static void ins_gate_attack

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(ai_erase_all)
			(if g_debug (print "switching zone sets..."))
			(switch_zone_set initial_zone_set)
			(sleep 1)
		)
	)

	; set insertion point index
	(set g_insertion_index 4)
	
	(set intro_obj_control 100)
	(set motorpool_obj_control 100)
	(set supply_obj_control 100)
	
	(sleep 1)

	(object_teleport player0 ins_gate_start_00)
	(object_teleport player1 ins_gate_start_01)
	(object_teleport player2 ins_gate_start_02)
	(object_teleport player3 ins_gate_start_03)

; temporarily start the mission script
	(wake m60_mission)

	
	; placing allies...	
;	(if g_debug (print "placing allies..."))
;	(ai_place sq_jw_johnson_marines)
;	(ai_place sq_jw_marines)
;	(ai_place sq_jw_arbiter)
;	(sleep 1)
					
	(fade_in 0 0 0 0)		
	;(objectives_finish_up_to 0)
	(game_save)

)
(script static void ins_assault
			
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(ai_erase_all)
			(if g_debug (print "switching zone sets..."))
			(switch_zone_set sword_surf_exterior)
			(sleep 1)
		)
	)

	; set insertion point index
	(set g_insertion_index 5)
	
	(set intro_obj_control 100)
	(set motorpool_obj_control 100)
	(set supply_obj_control 100)
	(set gate_obj_control 100)
	(set g_music_m60_04 1)
	
	(sleep 5)

	(object_teleport player0 ins_assault_start_00)
	(object_teleport player1 ins_assault_start_01)
	(object_teleport player2 ins_assault_start_02)
	(object_teleport player3 ins_assault_start_03)
	
	(if (editor_mode)
	(wake m60_mission))	
	(sleep 5)
	
	(insertion_fade_to_gameplay)		
	;(objectives_finish_up_to 0)
	;(game_save)
	(sleep 90)
	(f_hud_obj_new ct_objective_sword PRIMARY_OBJECTIVE_4)
			
)
(script static void ins_interior
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(ai_erase_all)
			(if g_debug (print "switching zone sets..."))
			(switch_zone_set sword_interior)
			(sleep 1)
		)
	)

	; set insertion point index
	(set g_insertion_index 6)
	
	(set intro_obj_control 100)
	(set motorpool_obj_control 100)
	(set supply_obj_control 100)
	(set gate_obj_control 100)
	(set assault_obj_control 100)
	
	(sleep 1)


	(object_teleport player0 ins_interior_start_00)
	(object_teleport player1 ins_interior_start_01)
	(object_teleport player2 ins_interior_start_02)
	(object_teleport player3 ins_interior_start_03)

	(ai_place sq_carter/carter_interior)
	(set ai_carter sq_carter/carter_interior)
	(set obj_carter (ai_get_object sq_carter/carter_interior))
	(ai_place sq_emile/emile_interior)
	(set ai_emile sq_emile/emile_interior)
	(set obj_emile (ai_get_object sq_emile/emile_interior))
	(ai_place sq_jun/jun_interior)
	(set ai_jun sq_jun/jun_interior)
	(set obj_jun (ai_get_object sq_jun/jun_interior))

	;temporarily start the mission script
	(wake m60_mission)				
	(fade_in 0 0 0 0)			
	;(objectives_finish_up_to 0)
	(game_save)
)
(script static void ins_security	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(ai_erase_all)
			(if g_debug (print "switching zone sets..."))
			(switch_zone_set sword_interior)
			(sleep 1)
		)
	)

	; set insertion point index
	(set g_insertion_index 7)
	
	(set intro_obj_control 100)
	(set motorpool_obj_control 100)
	(set supply_obj_control 100)
	(set gate_obj_control 100)
	(set assault_obj_control 100)
	(set interior_obj_control 100)
	
	(sleep 30)

	(object_teleport player0 ins_security_start_00)
	(object_teleport player1 ins_security_start_01)
	(object_teleport player2 ins_security_start_02)
	(object_teleport player3 ins_security_start_03)



; temporarily start the mission script
	(wake m60_mission)	
	
	(sleep_until (= (current_zone_set_fully_active) 5)1)
	
	(ai_place sq_carter/carter_interior)
	(ai_place sq_emile/emile_interior)
	(ai_place sq_jun/jun_interior)
	(ai_cannot_die sq_carter true)
	(ai_cannot_die sq_emile true)
	(ai_cannot_die sq_jun true)
	(object_teleport (ai_get_object sq_carter/carter_interior) ins_security_start_01)
	(object_teleport (ai_get_object sq_emile/emile_interior) ins_security_start_02)
	(object_teleport (ai_get_object sq_jun/jun_interior) ins_security_start_03)	
	
	(ai_set_objective sq_carter obj_security)
	(ai_set_objective sq_emile obj_security)
	(ai_set_objective sq_jun obj_security)
				
	(fade_in 0 0 0 0)			
	;(objectives_finish_up_to 0)
	(game_save)
	(soft_ceiling_enable soft_ceiling_interior TRUE)
	(soft_ceiling_enable default FALSE)			
)
(script static void ins_ice_cave

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(ai_erase_all)
			(if g_debug (print "switching zone sets..."))
			(switch_zone_set forerunner_ice_cave)
			(sleep 1)
		)
	)
	
	; set insertion point index
	(set g_insertion_index 9)
	
	(set intro_obj_control 100)
	(set motorpool_obj_control 100)
	(set supply_obj_control 100)
	(set gate_obj_control 100)
	(set assault_obj_control 100)
	(set interior_obj_control 100)
	(set security_obj_control 100)
	(sleep 5)
	(if (editor_mode)
		(begin	
			(object_teleport player0 player0_mid_cin_teleport)
			(object_teleport player1 player1_mid_cin_teleport)
			(object_teleport player2 player2_mid_cin_teleport)
			(object_teleport player3 player3_mid_cin_teleport)
		)
	)
	(object_create fx_screenfx_icecave)
	(object_create glacier_glow) 
	(if (editor_mode)
	(wake m60_mission))
	
	(sleep 5)
	(set g_music_m60_07 1)
	;(insertion_fade_to_gameplay)		end cinematic plays here
						
)