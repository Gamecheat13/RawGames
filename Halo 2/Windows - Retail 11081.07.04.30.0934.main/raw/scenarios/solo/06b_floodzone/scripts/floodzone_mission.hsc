;========== GLOBALS ==========================================================================
(global boolean debug 1)
(global boolean dialogue 1)
(global boolean g_play_cinematics 1)

(global boolean g_fact_ent_sen_spawn 0)
(global short g_fact_ent_sen_count 0)
(global short g_fact_ent_sen_index 10)
(global short g_fact_ent_enf_count 0)
(global short g_fact_ent_enf_index 3)


(script stub void x07 (print "x07"))
(script stub void c06_intra1 (print "c06_intra1"))
(script stub void c06_intra2 (print "c06_intra2"))

(script command_script cs_invulnerable
	(cs_enable_moving 1)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(sleep_until (>= (ai_combat_status ai_current_actor) ai_combat_status_certain))
	(sleep (* 30 1))
	(object_can_take_damage (ai_get_object ai_current_actor))
)

(script command_script cs_invul_8
	(cs_enable_moving 1)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(sleep (* 30 8))
	(object_can_take_damage (ai_get_object ai_current_actor))
)

(script command_script cs_kill
	(ai_kill_silent ai_current_actor)
)

(script static void no_death
	(object_cannot_take_damage (ai_actors covenant))
)

(script dormant ice_cream_superman
	(object_create ice_cream_head)
	
	(sleep_until 
		(or
                (unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
                (unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	5)
	
	(if debug (print "you're going to get fat!!!!! or dead..."))
	(if debug (print "because now everyone is superman!!!!"))
	(ice_cream_flavor_stock 10)
)

; =====  !!!! MUSIC !!!! ===========================================================================
(global boolean g_music_06b_01 1)
(global boolean g_music_06b_02 0)
(global boolean g_music_06b_03 0)
(global boolean g_music_06b_04 0)
(global boolean g_music_06b_05 0)
(global boolean g_music_06b_06 0)
(global boolean g_music_06b_07 0)

(script dormant music_06b_01
	(sleep_until g_music_06b_01)
	(if debug (print "start music 06b_01"))
	(sound_looping_start scenarios\solo\06b_floodzone\06b_music\06b_01 none 1)

;	(sleep_until (not g_music_06b_01))
;	(if debug (print "stop music 06b_01"))
;4	(sound_looping_stop scenarios\solo\06b_floodzone\06b_music\06b_01)
)

(script dormant music_06b_02
	(sleep_until g_music_06b_02)
	(if debug (print "start music 06b_02"))
	(sound_looping_start scenarios\solo\06b_floodzone\06b_music\06b_02 none 1)

	(sleep_until (not g_music_06b_02))
	(if debug (print "stop music 06b_02"))
	(sound_looping_stop scenarios\solo\06b_floodzone\06b_music\06b_02)
)


(script dormant music_06b_03
	(sleep_until g_music_06b_03)
	(if debug (print "start music 06b_03"))
	(sound_looping_start scenarios\solo\06b_floodzone\06b_music\06b_03 none 1)

	(sleep_until (not g_music_06b_03))
	(if debug (print "stop music 06b_03"))
	(sound_looping_stop scenarios\solo\06b_floodzone\06b_music\06b_03)
)

(script dormant music_06b_04
	(sleep_until g_music_06b_04)
	(if debug (print "start music 06b_04"))
	(sound_looping_start scenarios\solo\06b_floodzone\06b_music\06b_04 none 1)

;	(sleep_until (not g_music_06b_04))
;	(if debug (print "stop music 06b_04"))
;	(sound_looping_stop scenarios\solo\06b_floodzone\06b_music\06b_04)
)

(script dormant music_06b_05
	(sleep_until (volume_test_objects tv_e20_dock_entrance (players)))
	(set g_music_06b_05 1)
	(if debug (print "start music 06b_05"))
	(sound_looping_start scenarios\solo\06b_floodzone\06b_music\06b_05 none 1)
	
	(sleep_until (not g_music_06b_05))
	(if debug (print "stop music 06b_05"))
	(sound_looping_stop scenarios\solo\06b_floodzone\06b_music\06b_05)
)

(script dormant music_06b_06
	(sleep_until g_music_06b_06)
	(if debug (print "start music 06b_06"))
	(sound_looping_start scenarios\solo\06b_floodzone\06b_music\06b_06 none 1)
	
;	(sleep_until (not g_music_06b_06))
;	(if debug (print "stop music 06b_06"))
;	(sound_looping_stop scenarios\solo\06b_floodzone\06b_music\06b_06)
)

(script dormant music_06b_07
	(sleep_until (volume_test_objects tv_music_06b_07 (players)))
	(if debug (print "start music 06b_07"))
	(sound_looping_start scenarios\solo\06b_floodzone\06b_music\06b_07 none 1)
)

;= CHAPTER TITLES ========================================================================

(script dormant chapter_mirror
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)
(script dormant chapter_competition
	(sleep 30)
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)
(script dormant chapter_gallery
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_3)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)
(script dormant chapter_familiar
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_4)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

;= OBJECTIVES ============================================================================

(script dormant objective_push_set
	(sleep 30)
	(print "new objective set:")
	(print "Push through the Quarantine-Zone toward The Library.")
	(objectives_show_up_to 0)
)

(script dormant objective_push_clear
	(print "objective complete:")
	(print "Push through the Quarantine-Zone toward The Library.")
	(objectives_finish_up_to 0)
)

(script dormant objective_link_set
	(sleep 30)
	(print "new objective set:")
	(print "Link-up with the Spec-Ops Leader, and break through the Flood barricade.")
	(objectives_show_up_to 1)
)

(script dormant objective_link_clear
	(print "objective complete:")
	(print "Link-up with the Spec-Ops Leader, and break through the Flood barricade.")
	(objectives_finish_up_to 1)
)

(script dormant objective_retrieve_set
	(sleep 30)
	(print "new objective set:")
	(print "Retrieve the Sacred Icon before the Humans.")
	(objectives_show_up_to 2)
)

(script dormant objective_retrieve_clear
	(print "objective complete:")
	(print "Retrieve the Sacred Icon before the Humans.")
	(objectives_finish_up_to 2)
)

; =====  DIALOGUE SCENES ===========================================================================
(global short dialogue_pause 7)
(global boolean g_qz_cov_def_progress 0)

; plays right after the insertion cinematic 

(script dormant sc_cov_charge
	(sleep 60) ; for Marty, because he bitches a lot 

	(if dialogue (print "COMMANDER: Forward, warriors! And fear not pain or death!"))
	(sleep (ai_play_line_on_object none 0220))
	(sleep (* dialogue_pause 2))

;	(if dialogue (print "SPEC-OPS: For those who fell before us!"))
;	(sleep (ai_play_line_on_object none 0230))
;	(sleep dialogue_pause)

	(if dialogue (print "COMMANDER: Go, Arbiter! I'll follow when our reinforcements arrive!"))
	(sleep (ai_play_line_on_object none 0240))
	(sleep dialogue_pause)
	
	(sleep_until g_qz_cov_def_progress)
	(if (<= (ai_living_count cov_def_enf) 0) (sleep 180) (sleep 30))
	; if the enforcers are not alive then sleep 180, if they are then sleep 30 
	
; if there are no enforcers alive when it tries to play this line skip it 
	(if (> (ai_living_count cov_def_enf) 0)
		(begin
			(if dialogue (print "SPEC-OPS: Go, Enforcers!"))
			(sleep (ai_play_line covenant 0590))
			(sleep dialogue_pause)
		)
	)
	
	(if dialogue (print "SPEC-OPS: To the vehicles! We'll need their heavy-guns!"))
	(sleep (ai_play_line covenant 0600))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: Onward! To the Sacred Icon!"))
	(sleep (ai_play_line covenant 0610))
	(sleep dialogue_pause)
)
;*  this was removed because it was blocking the AI from getting into their vehicles 
(script dormant sc_cov_charge
	(sleep_until (ai_scene sc_cov_charge cs_sc_cov_charge covenant))
)
*;
(script command_script cs_sc_qz_veh_int
	(if dialogue (print "SPEC-OPS: What?! The Parasite controls our vehicles?!"))
	(sleep (ai_play_line covenant 0620))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: Impossible! It's never done that before!"))
	(sleep (ai_play_line covenant 0640))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: No matter. It will die all the same!"))
	(sleep (ai_play_line covenant 0650))
	(sleep dialogue_pause)
)

; plays when the covenant see the flood driving ghosts 
(script dormant sc_qz_veh_int
	(sleep 180)
	(sleep_until (ai_scene sc_qz_veh_int cs_sc_qz_veh_int covenant))
)

; plays when you get to the bottom of the dam 
(script dormant sc_ext_a
	(if dialogue (print "COMMANDER: I'm sending you a squad of my most experienced Warriors, Arbiter."))
	(sleep (ai_play_line_on_object none 0650))
	(sleep dialogue_pause)

	(if dialogue (print "COMMANDER: Do not squander their talents!"))
	(sleep (ai_play_line_on_object none 0660))
	(sleep dialogue_pause)
)

; plays halfway through the vehicle interior space (unlike what the title would suggest) 
(script dormant sc_factory_approach
	(if dialogue (print "COMMANDER: Commander! We've found a human vehicle!"))
	(sleep (ai_play_line covenant 0250))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: Keep moving. I'm on my way."))
	(sleep (ai_play_line_on_object none 0260))
	(sleep dialogue_pause)
)

; plays in the gateway to the final vehicle space (right after the crashed factory exit) 
(script dormant sc_factory_exit
	(sleep 60)
	(if dialogue (print "SPEC-OPS: Humans and parasites!"))
	(if dialogue (print "This ring has been befouled, but we will wipe it clean!"))
	(sleep (ai_play_line covenant 0270))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: Honoring those who built it!"))
	(sleep (ai_play_line covenant 0280))
	(sleep dialogue_pause)
)

; plays at the exit from the crashed sentinel factory 
(script dormant sc_human_fools
	(if dialogue (print "COMMANDER: Human fools. I almost feel sorry for them."))
	(sleep (ai_play_line_on_object none 0290))
	(sleep dialogue_pause)
)

; plays when the exterior b covenant reinforcements get dropped off 
(script dormant sc_ext_b
	(if dialogue (print "SPEC-OPS: Forward to the Icon!"))
	(sleep (ai_play_line covenant 0700))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: The Parasite's ranks swell as we draw nearer to the Library!"))
	(sleep (ai_play_line covenant 0710))
	(sleep dialogue_pause)

	(if dialogue (print "SPEC-OPS: Steel your nerves. We are not turning back!"))
	(sleep (ai_play_line covenant 0720))
	(sleep dialogue_pause)
)

; joe plays this line in his cinematic 
(script dormant sc_chasm
	(if dialogue (print "TARTARUS: I see that coward didn't join you."))
	(sleep (ai_play_line_on_object none 0300))
	(sleep dialogue_pause)

	(if dialogue (print "TARTARUS: I'll do what I can to keep the Flood off your back."))
	(sleep (ai_play_line_on_object none 0310))
	(sleep dialogue_pause)
)

; plays right after the key cinematic 
(script dormant sc_outer_wall
	(if dialogue (print "TARTARUS: We cannot let the humans capture the Icon!"))
	(sleep (ai_play_line_on_object none 0320))
	(sleep dialogue_pause)

	(if dialogue (print "TARTARUS: The Hierarchs do not look kindly on failure."))
	(sleep (ai_play_line_on_object none 0330))
	(sleep dialogue_pause)
)

; plays when the key docs in its final position 
(script dormant sc_dock
	(if dialogue (print "TARTARUS: Hurry, Arbiter! Get the Icon!"))
	(sleep (ai_play_line_on_object none 0340))
	(sleep dialogue_pause)
)


;====== COVENANT VEHICLE MIGRATION =======================================================
(script static boolean driver_seat_test
	(if
		(or
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_ghosts/a) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_ghosts/b) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_flood_ghosts_ini/a) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_flood_ghosts_ini/b) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_hog_ab/hog) "warthog_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_ghost_ab/a) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_ghost_ab/b) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_scorpion/scorpion) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_flood_hog_bk/warthog) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_flood_ghosts_bk/a) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_flood_ghosts_bk/b) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_a_ghosts/a) "ghost_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_a_ghosts/b) "ghost_d" (players))
		)
	true false)
)

(script static boolean passenger_seat_test
	(if
		(or
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_p_l" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_p_r" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_g" (players))

			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_hog_ab/hog) "warthog_p" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_hog_ab/hog) "warthog_g" (players))

			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_flood_hog_bk/warthog) "warthog_p" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location veh_int_flood_hog_bk/warthog) "warthog_g" (players))

			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_fact_warthog/warthog) "warthog_p" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_fact_warthog/warthog) "warthog_g" (players))

			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_warthog/warthog) "warthog_p" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_warthog/warthog) "warthog_g" (players))

			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_warthog_gauss/warthog) "warthog_p" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_warthog_gauss/warthog) "warthog_g" (players))

			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_cov_spectre/spectre) "spectre_p_l" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_cov_spectre/spectre) "spectre_p_r" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_ext_b_cov_spectre/spectre) "spectre_g" (players))
		)
	true false)
)

(global short g_order_delay 150)

(script command_script cov_def_spec_tele_a
	(cs_teleport bsp_swap_teleport/a bsp_swap_teleport/face)
)
(script command_script cov_def_spec_tele_b
	(cs_teleport bsp_swap_teleport/b bsp_swap_teleport/face)
)
(script command_script cov_def_spec_tele_c
	(cs_teleport bsp_swap_teleport/c bsp_swap_teleport/face)
)
(script command_script cov_def_spec_tele_d
	(cs_teleport bsp_swap_teleport/d bsp_swap_teleport/face)
)

(script command_script cs_fact_ent_exit_veh
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_nearest crashed_fact_ent)
	(cs_enable_targeting true) ; 9/22 
	(cs_shoot true) ; 9/22 
	(ai_set_orders covenant cov_follow_factory1)
	
	(sleep 30)
	(ai_vehicle_exit covenant)
)

(global boolean g_veh_int_migrate_a 0)
(global boolean g_veh_int_migrate_b 0)
(global boolean g_veh_int_migrate_c 0)
(global boolean g_veh_int_migrate_d 0)
(global boolean g_veh_int_migrate_e 0)

(global boolean g_ext_a_dam_migrate_a 0)
(global boolean g_ext_a_dam_migrate_b 0)
(global boolean g_ext_a_migrate_a 0)
(global boolean g_ext_a_migrate_b 0)
(global boolean g_ext_a_migrate_c 0)
(global boolean g_ext_a_migrate_d 0)
(global boolean g_ext_a_migrate_e 0)
(global boolean g_ext_a_migrate_f 0)
(global boolean g_ext_a_fact_ent_migrate 0)


(script dormant ext_a_vehicle_orders
	(sleep g_order_delay)
	; == covenant defense == 
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant cov_drive_cov_def))
				)
				(true (ai_set_orders covenant cov_follow_cov_def))
			)
		(= (structure_bsp_index) 1))
	)

;*
; == BSP SWAP BULLSHIT ============
	(if	(not (volume_test_object tv_bsp_swap_bullshit (ai_get_object qz_cov_def_spec_ops/a)))
		(cs_run_command_script qz_cov_def_spec_ops/a cov_def_spec_tele_a)
	)
	(if	(not (volume_test_object tv_bsp_swap_bullshit (ai_get_object qz_cov_def_spec_ops/b)))
		(cs_run_command_script qz_cov_def_spec_ops/b cov_def_spec_tele_b)
	)
	(if	(not (volume_test_object tv_bsp_swap_bullshit (ai_get_object qz_cov_def_spec_ops/c)))
		(cs_run_command_script qz_cov_def_spec_ops/c cov_def_spec_tele_c)
	)
	(if	(not (volume_test_object tv_bsp_swap_bullshit (ai_get_object qz_cov_def_spec_ops/d)))
		(cs_run_command_script qz_cov_def_spec_ops/d cov_def_spec_tele_d)
	)
; == BSP SWAP BULLSHIT ============
*;

; VEHICLE INTERIOR START ======================================================================================= 
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(cond
											((= (structure_bsp_index) 0) (begin
																		(ai_set_orders covenant_infantry cov_follow_cov_def)
																		(ai_set_orders covenant_vehicles cov_drive_cov_def)
																	)
											)
											((= (structure_bsp_index) 1) (begin
																		(ai_set_orders covenant_infantry cov_follow_veh_int)
																		(ai_set_orders covenant_vehicles cov_drive_veh_int_a)
																	)
											)
										)
									)
				)
				(true
					(cond
						((= (structure_bsp_index) 0) (ai_set_orders covenant cov_follow_cov_def))
						((= (structure_bsp_index) 1) (ai_set_orders covenant cov_follow_veh_int))
					)
				)
			)
		(or ; exit conditions 
			(and
				(volume_test_objects tv_veh_int_a (players))
				(ai_trigger_test "done_fighting" covenant)
			)
			(and 
				(volume_test_objects tv_veh_int_a (players))
				(<= (ai_living_count veh_int_sen_a) 0)
			)
			g_veh_int_migrate_b
		))
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(cond
											((= (structure_bsp_index) 0) (begin
																		(ai_set_orders covenant_infantry cov_follow_cov_def)
																		(ai_set_orders covenant_vehicles cov_drive_cov_def)
																	)
											)
											((= (structure_bsp_index) 1) (begin
																		(ai_set_orders covenant_infantry cov_follow_veh_int)
																		(ai_set_orders covenant_vehicles cov_drive_veh_int_b)
																	)
											)
										)
									)
				)
				(true
					(cond
						((= (structure_bsp_index) 0) (ai_set_orders covenant cov_follow_cov_def))
						((= (structure_bsp_index) 1) (ai_set_orders covenant cov_follow_veh_int))
					)
				)
			)
		(or ; exit conditions 
			(and
				(volume_test_objects tv_veh_int_b (players))
				(ai_trigger_test "done_fighting" covenant)
			)
			(and
				(volume_test_objects tv_veh_int_b (players))
 				(<= (ai_living_count veh_int_sen_b) 0)
				(<= (ai_living_count veh_int_flood_b) 0)
			)
			g_veh_int_migrate_c
		))
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_veh_int)
										(ai_set_orders covenant_vehicles cov_drive_veh_int_c)
									)
				)
				(true (ai_set_orders covenant cov_follow_veh_int))
			)
		(or ; exit conditions 
			(and
				(volume_test_objects tv_veh_int_c (players))
				(ai_trigger_test "done_fighting" covenant)
			)
			(and
				(volume_test_objects tv_veh_int_c (players))
				(<= (ai_living_count veh_int_sen_c) 0)
				(<= (ai_living_count veh_int_flood_c) 0)
			)
			g_veh_int_migrate_d
		))
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_veh_int)
										(ai_set_orders covenant_vehicles cov_drive_veh_int_d)
									)
				)
				(true (ai_set_orders covenant cov_follow_veh_int))
			)
		(or ; exit conditions 
			(and
				(volume_test_objects tv_veh_int_d (players))
				(ai_trigger_test "done_fighting" covenant)
			)
			(and
				(volume_test_objects tv_veh_int_d (players))
				(<= (ai_living_count veh_int_sen_d) 0)
				(<= (ai_living_count veh_int_flood_d) 0)
			)
			g_veh_int_migrate_e
		))
	)
	(sleep g_order_delay)
	
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_veh_int)
										(ai_set_orders covenant_vehicles cov_drive_veh_int_e)
									)
				)
				(true (ai_set_orders covenant cov_follow_veh_int))
			)
			(or ; exit conditions 
				(volume_test_objects tv_qz_ext_a (players))
				g_ext_a_dam_migrate_a
			))
	)
	(sleep g_order_delay)
	
; EXTERIOR A START ======================================================================================= 
	
	; == upper dam == 
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a_dam)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_dam_a)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a_dam))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects tv_ext_a_dam_a (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects tv_ext_a_dam_a (players))
					(<= (ai_living_count ext_a_sen_dam_a) 0)
					(<= (ai_living_count ext_a_flood_dam_a) 0)
				)
				g_ext_a_dam_migrate_b
			)
		)
	)
	(sleep g_order_delay)
	
	; == lower dam ==
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a_dam)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_dam_b)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a_dam))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects qz_ext_a_dam_b (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects qz_ext_a_dam_b (players))
					(<= (ai_living_count ext_a_sen_dam_b) 0)
					(<= (ai_living_count ext_a_flood_dam_b) 0)
				)
				g_ext_a_migrate_a
			)
		)
	)
	(sleep g_order_delay)

	; == exterior a == 
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_a)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects tv_ext_a_a (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects tv_ext_a_a (players))
					(<= (ai_living_count ext_a_sen_a) 0)
					(<= (ai_living_count ext_a_flood_a) 0)
				)
				g_ext_a_migrate_b
			)
		)
	)
	(sleep g_order_delay)
	
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_b)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects tv_ext_a_b (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects tv_ext_a_b (players))
					(<= (ai_living_count ext_a_sen_b) 0)
					(<= (ai_living_count ext_a_flood_b) 0)
				)
				g_ext_a_migrate_c
			)
		)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_c)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects tv_ext_a_c (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects tv_ext_a_c (players))
					(<= (ai_living_count ext_a_sen_c) 0)
					(<= (ai_living_count ext_a_flood_c) 0)
				)
				g_ext_a_migrate_d
			)
		)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_d)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects tv_ext_a_d (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects tv_ext_a_d (players))
					(<= (ai_living_count ext_a_sen_d) 0)
					(<= (ai_living_count ext_a_flood_d) 0)
				)
				g_ext_a_migrate_e
			)
		)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_e)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects tv_ext_a_e (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects tv_ext_a_e (players))
					(<= (ai_living_count ext_a_sen_e) 0)
					(<= (ai_living_count ext_a_flood_e) 0)
				)
				g_ext_a_migrate_f
			)
		)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a_fact_ent)
										(ai_set_orders covenant_vehicles cov_drive_ext_a_f)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a_fact_ent))
			)
			(or ; exit conditions 
				(and
					(volume_test_objects tv_ext_a_f (players))
					(ai_trigger_test "done_fighting" covenant)
				)
				(and
					(volume_test_objects tv_ext_a_f (players))
					(<= (ai_living_count ext_a_sen_f) 0)
					(<= (ai_living_count ext_a_flood_f) 0)
				)
				g_ext_a_fact_ent_migrate
			)
		)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_a_fact_ent)
										(ai_set_orders covenant_vehicles cov_drive_fact_ent)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_a_fact_ent))
			)
			(or ; exit conditions 
				(and
					(ai_trigger_test "done_fighting" covenant)
					g_fact_ent_sen_spawn
				)
				(and
					(<= (ai_living_count fact_ent_sentinels) 0)
					(<= (ai_living_count fact_ent_flood) 0)
					g_fact_ent_sen_spawn
				)
				(volume_test_objects tv_fact_ent_follow (players))
	
			)
		)
	)
	(sleep g_order_delay)

	(cs_run_command_script covenant cs_fact_ent_exit_veh) ; new order set in the command script 
	
)

(global boolean g_ext_b_migrate_1 0)
(global boolean g_ext_b_migrate_2 0)
(global boolean g_ext_b_migrate_3 0)
(global boolean g_ext_b_migrate_4 0)
(global boolean g_ext_b_migrate_5 0)

(script command_script cs_ext_b_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_nearest ext_b_exit)
	(cs_enable_targeting true) ; 9/22 
	(cs_shoot true) ; 9/22 
	(ai_set_orders covenant cov_ext_b_exit)
	
	(sleep 30)
	(ai_vehicle_exit covenant)
)

(script dormant ext_b_vehicle_orders
	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_b)
										(ai_set_orders covenant_vehicles cov_drive_ext_b_a)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_b))
			)
			(ai_magically_see covenant ext_b_flood)
		g_ext_b_migrate_1)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_b)
										(ai_set_orders covenant_vehicles cov_drive_ext_b_b)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_b))
			)
			(ai_magically_see covenant ext_b_flood)
		g_ext_b_migrate_2)
	)
	(sleep (* g_order_delay 3))

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_b)
										(ai_set_orders covenant_vehicles cov_drive_ext_b_b)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_b))
			)
			(ai_magically_see covenant ext_b_flood)
			(or ; exit conditions 
				(and
					(<= (ai_living_count ext_b_flood_b) 0)
					(<= (ai_living_count ext_b_sentinels_b) 0)
				)
				g_ext_b_migrate_3
			)
		)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_b)
										(ai_set_orders covenant_vehicles cov_drive_ext_b_c)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_b_bk))
			)
			(ai_magically_see covenant ext_b_flood)
			(or ; exit condition 
				(and
					(<= (ai_living_count ext_b_flood_c) 0)
					(<= (ai_living_count ext_b_sentinels_c) 0)
				)
				g_ext_b_migrate_4
			)
		)
	)
	(sleep g_order_delay)

	(sleep_until
		(begin	
			(cond
				((passenger_seat_test)	(begin
										(if debug (print "player is passenger"))
										(ai_set_orders covenant_infantry cov_follow_ext_b)
										(ai_set_orders covenant_vehicles cov_drive_ext_b_d)
									)
				)
				(true (ai_set_orders covenant cov_follow_ext_b_bk))
			)
			(ai_magically_see covenant ext_b_flood)
		g_ext_b_migrate_5)
	)
	(sleep (* g_order_delay 3))
	
	(cs_run_command_script covenant cs_ext_b_exit) ; new order set in the command script 
	
	(sleep_until (= (structure_bsp_index) 3))
	(ai_migrate covenant key_cov_dump)
	(sleep 5)
	
	(ai_teleport_to_starting_location_if_outside_bsp key_cov_dump)
	(sleep 5)
	(ai_set_orders covenant cov_follow_key_ent)
)


;====== COVENANT DEFENSE =================================================================
(script command_script cs_cov_def_phantom
	(cs_fly_to qz_cov_def/drop)
	(sleep_until g_qz_cov_def_progress)
;	(cs_vehicle_speed .35)
;	(cs_fly_to qz_cov_def/drop .1)
;	(sleep 30)
;	(vehicle_unload (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "phantom_p")
;	(sleep 30)
;	(unit_exit_vehicle (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre))
;	(sleep (* 30 2))
	(cs_vehicle_speed .85)
	(cs_fly_to_and_face qz_cov_def/p4 qz_cov_def/p1 3)
	(cs_vehicle_speed 1)
;	(cs_fly_to qz_cov_def/p0 3)
;	(cs_vehicle_speed .7)
	(cs_fly_by qz_cov_def/p1 10)
;	(cs_vehicle_speed 1)
	(cs_fly_by qz_cov_def/p2 10)
	(cs_fly_by qz_cov_def/p3 10)
	(ai_erase ai_current_squad)
)

(script command_script cs_cov_def_spec_ops_a
	(cs_enable_pathfinding_failsafe true)
	(cs_look_player true)
	
	(sleep_until g_qz_cov_def_progress 5)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location qz_cov_def_ghosts/a))
)

(script command_script cs_cov_def_spec_ops_b
	(cs_enable_pathfinding_failsafe true)
	(cs_look_player true)

	(sleep_until g_qz_cov_def_progress 5)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location qz_cov_def_ghosts/b))
)

(script command_script cs_cov_def_spec_ops_c
	(cs_enable_pathfinding_failsafe true)
	(cs_look_player true)

	(sleep_until g_qz_cov_def_progress 5)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre))
)

(script command_script cs_cov_def_spec_ops_d
	(cs_enable_pathfinding_failsafe true)
	(cs_look_player true)

	(sleep_until g_qz_cov_def_progress 5)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre))
)

;====== VEHICLE INTERIOR SCRIPTS =======================================================

(script command_script cs_go_to_scorpion
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location veh_int_scorpion/scorpion))
)

(script command_script cs_go_to_wraith
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location veh_int_wraith/wraith))
)

(global boolean g_veh_int_ghost_spawn 0)
(global short g_veh_int_ghost_limit 0)
(global short g_veh_int_ghost_number 0)

(script dormant ai_veh_int_ghost_spawn
	(sleep_until (<= (ai_living_count veh_int_flood_ghosts_ini) 0))
	(if debug (print "waking vehicle interior ghost spawner"))
	
	(cond
		((difficulty_normal) (begin (set g_veh_int_ghost_limit 6) (set g_veh_int_ghost_number 1)))
		((difficulty_heroic) (begin (set g_veh_int_ghost_limit 8) (set g_veh_int_ghost_number 2)))
		((difficulty_legendary) (begin (set g_veh_int_ghost_limit 10) (set g_veh_int_ghost_number 3)))
	)

	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count veh_int_flood_ghosts_bk) 0))
			(sleep 90)
			(if debug (print "placing ghosts"))
			(ai_place veh_int_flood_ghosts_bk g_veh_int_ghost_number)
		(or ; exit conditions 
			(>= (ai_spawn_count veh_int_flood_ghosts_bk) g_veh_int_ghost_limit)
			g_veh_int_ghost_spawn)
		)
	)
	
	(if (<= (ai_living_count veh_int_flood_ghosts_bk) 0) (ai_place veh_int_flood_ghosts_bk))
)


;====== QUARANTINE ZONE EXTERIOR A =======================================================

(script dormant dam_door_a
	(sleep_until
		(begin
			(sleep_until (volume_test_objects tv_dam_door_a (players)) 5)
			(device_set_position dam_door_a 1)
		false)
	)
)
(script dormant dam_door_b
	(sleep_until
		(begin
			(sleep_until (volume_test_objects tv_dam_door_b (players)) 5)
			(device_set_position dam_door_b 1)
		false)
	)
)


(script command_script cs_ext_a_enf_ini
	(cs_shoot 1)
	(cs_vehicle_boost 1)
	(cs_fly_by qz_ext_a_enf/p0 3)
	(cs_fly_by qz_ext_a_enf/p1 3)
	(cs_fly_by qz_ext_a_enf/p2 3)
	(cs_vehicle_boost 0)
)

(script command_script cs_ext_a_pelican
;	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
		(vehicle_load_magic
			(ai_vehicle_get_from_starting_location qz_ext_a_dam_human/pelican)
			"pelican_lc"
			(ai_vehicle_get_from_starting_location qz_ext_a_dam_human/scorpion)
		)
	
	(cs_fly_by qz_ext_a_pelican/p0 3)
;	(cs_fly_by qz_ext_a_pelican/p1 3)
	(cs_fly_by qz_ext_a_pelican/p2 3)
	(cs_fly_by qz_ext_a_pelican/p3 5)
;	(cs_fly_by qz_ext_a_pelican/p4 3)
	(cs_fly_by qz_ext_a_pelican/p5 3)
	(sleep 30)
	(ai_erase ai_current_squad)
)

(script command_script cs_boost_1_5
	(cs_vehicle_boost true)
	(sleep (* 30 1.5))
	(cs_vehicle_boost false)
)

(global vehicle v_ext_a_phantom none)

(script command_script cs_ext_a_phantom
	(ai_place qz_ext_a_spec_ops)
	(ai_place qz_ext_a_ghosts)
	(cs_shoot true)
	(cs_enable_pathfinding_failsafe true)
		(sleep 1)
		(vehicle_load_magic
			v_ext_a_phantom
			"phantom_p"
			(ai_actors qz_ext_a_spec_ops)
		)
		(vehicle_load_magic
			v_ext_a_phantom
			"phantom_sc01"
			(ai_vehicle_get_from_starting_location qz_ext_a_ghosts/a)
		)
		(vehicle_load_magic
			v_ext_a_phantom
			"phantom_sc02"
			(ai_vehicle_get_from_starting_location qz_ext_a_ghosts/b)
		)
	
		(sleep 1)
	(cs_vehicle_boost true)
	(cs_fly_by qz_ext_a_phantom/p0 5)
	(cs_vehicle_boost false)
	(cs_fly_by qz_ext_a_phantom/p1 5)
	(cs_fly_by qz_ext_a_phantom/p2 4)
	(cs_fly_to_and_face qz_ext_a_phantom/p3 qz_ext_a_phantom/unit_face)
	(cs_vehicle_speed .75)
	(cs_fly_to_and_face qz_ext_a_phantom/drop_units qz_ext_a_phantom/unit_face 2)
	(object_set_phantom_power v_ext_a_phantom 1)
		(sleep 45)
	
		(vehicle_unload v_ext_a_phantom "phantom_p_a01")
		(sleep 30)
		(vehicle_unload v_ext_a_phantom "phantom_p_a02")
		(sleep 30)
		(vehicle_unload v_ext_a_phantom "phantom_p_a03")
	;	(sleep 20)
	
		(sleep 45)

	(cs_fly_to_and_face qz_ext_a_phantom/drop_ghosts qz_ext_a_phantom/face 2)
		(sleep_until (not (volume_test_objects_all tv_qz_ext_a_ghost_drop (players))))
		(sleep 45)
		(vehicle_unload v_ext_a_phantom "phantom_sc")
		(sleep 90)
	(object_set_phantom_power v_ext_a_phantom 0)
	(cs_vehicle_speed 1)
	(cs_fly_by qz_ext_a_phantom/p6)
	(cs_fly_by qz_ext_a_phantom/p4)
	(cs_vehicle_boost true)
	(cs_fly_by qz_ext_a_phantom/p7)
	(ai_erase ai_current_actor)
)

(global boolean g_qz_ext_a_wraith_shoot 0)

(script command_script cs_wraiths_shoot
	(cs_abort_on_damage true)

	(sleep_until	
		(begin
			(begin_random
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p0)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p1)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p2)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p3)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p4)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p5)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p6)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_shoot_point true qz_ext_a_wraiths/p7)
					(sleep (random_range 30 60))
				)
			)
		g_qz_ext_a_wraith_shoot)
	)
)

(global boolean g_ext_a_dam_enf 0)

(script dormant ai_ext_a_dam_enforcers
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count ext_a_sen_dam_b) 0))
			(sleep 90)
			(ai_place qz_ext_a_dam_enf_door)
			(or
				(>= (ai_spawn_count qz_ext_a_dam_enf_door) 3)
				g_ext_a_dam_enf
			)
		)
	)
)

(script dormant ai_qz_ext_a_wraiths
	(ai_place qz_ext_a_flood_wraith_fr)
	(ai_place qz_ext_a_flood_wraith_bk)
	(ai_place qz_ext_a_flood_wraith_ledge)
)

(global boolean g_qz_ext_a_flood_ghosts 0)

(script dormant ai_qz_ext_a_ghosts
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count qz_ext_a_flood_ghosts) 0))
			(if g_qz_ext_a_flood_ghosts (sleep_forever))
			(sleep (random_range 60 120))
			(ai_place qz_ext_a_flood_ghosts)
		g_qz_ext_a_flood_ghosts)
	)
)

(script dormant ai_fact_ent_sen_spawn
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count fact_ent_sen) 1))
			(sleep (random_range 15 30))
			(ai_place fact_ent_sen)
			(set g_fact_ent_sen_count (+ g_fact_ent_sen_count 1))
			(if (= g_fact_ent_sen_count g_fact_ent_sen_index) (set g_fact_ent_sen_spawn 1))
		g_fact_ent_sen_spawn)
	)
)

(script dormant ai_fact_ent_enf_spawn
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count fact_ent_enf) 0))
			(sleep (random_range 30 60))
			(ai_place fact_ent_enf)
			(set g_fact_ent_enf_count (+ g_fact_ent_enf_count 1))
			(if (= g_fact_ent_enf_count g_fact_ent_enf_index) (set g_fact_ent_sen_spawn 1))
		g_fact_ent_sen_spawn)
	)
)

(global boolean g_qz_ext_a_d_spawn 1)

(script dormant ai_qz_ext_a_d_spawn
	(sleep_until (volume_test_objects tv_ext_a_d (players)))
	(if g_qz_ext_a_d_spawn
		(begin
			(ai_place qz_ext_a_flood_d)
			(ai_place qz_ext_a_enf_bk)
		)
	)
)


; ===== CRASHED FACTORY SCRIPTS ============================================================

;Respawns exit Flood until the player reaches the end
(script dormant factory_1_flood_respawn  ; turn this one off after a few waves (count waves with AI_SPAWN_COUNT)  
	(sleep_until 
		(begin
			(sleep_until
				(OR
					(= (volume_test_objects vol_factory_1_mid_03 (players)) TRUE)
					(< (ai_nonswarm_count factory1_flood) 3)
				)
			)
			(if (= (volume_test_objects vol_factory_1_mid_03 (players)) FALSE)
				(ai_place factory_1_flood_end 1)			
				(sleep 60)
			)
			(or
				(= (volume_test_objects vol_factory_1_mid_03 (players)) TRUE)
				(>= (ai_spawn_count factory_1_flood_end) 10)
			)
		)
	)
)

;Respawns sentinels over course of encounter, switching to different spawn points as the player pushes in
(script dormant factory_1_sentinel_respawn_01
	(sleep_until 
		(begin
			(sleep_until
				(OR
					(= (volume_test_objects vol_factory_1_mid_01 (players)) TRUE)
					(< (ai_living_count factory1_sentinels) 2)
				)
			)
			(if (= (volume_test_objects vol_factory_1_mid_01 (players)) FALSE)
				(ai_place factory_1_sentinels_01_low 1)
				(sleep 120)
			)
			(if (= (volume_test_objects vol_factory_1_mid_01 (players)) FALSE)
				(ai_place factory_1_sentinels_01_high 1)
				(sleep 120)
			)
			(or
				(= (volume_test_objects vol_factory_1_mid_01 (players)) TRUE)
				(>=	(+
						(ai_spawn_count factory_1_sentinels_01_low)
						(ai_spawn_count factory_1_sentinels_01_high)
					)
				3)
			)
		)
	)
)
(script dormant factory_1_sentinel_respawn_02
	(sleep_until 
		(begin
			(sleep_until
				(OR
					(= (volume_test_objects vol_factory_1_mid_02 (players)) TRUE)
					(< (ai_living_count factory1_sentinels) 2)
				)
			)
			(if (= (volume_test_objects vol_factory_1_mid_02 (players)) FALSE)
				(ai_place factory_1_sentinels_02_low 1)
				(sleep 120)
			)
			(if (= (volume_test_objects vol_factory_1_mid_02 (players)) FALSE)
				(ai_place factory_1_sentinels_02_high 1)
				(sleep 120)
			)
			(or
				(= (volume_test_objects vol_factory_1_mid_02 (players)) TRUE)
				(>=	(+
						(ai_spawn_count factory_1_sentinels_02_low)
						(ai_spawn_count factory_1_sentinels_02_high)
					)
				6)
			)
		)
	)
)

;Respawns the sentinels fighting the flood at the exit
(script dormant factory_1_sentinel_enders
	(sleep_until 
		(begin
			(sleep_until
				(OR
					(= (volume_test_objects vol_factory_1_mid_03 (players)) TRUE)
					(< (ai_living_count factory1_sentinels) 2)
				)
			)
			(if (= (volume_test_objects vol_factory_1_mid_03 (players)) FALSE)
				(ai_place factory_1_sentinels_03_low 1)
				(sleep 120)
			)
			(if (= (volume_test_objects vol_factory_1_mid_03 (players)) FALSE)
				(ai_place factory_1_sentinels_03_high 1)
				(sleep 120)
			)
			(or
				(= (volume_test_objects vol_factory_1_mid_03 (players)) TRUE)
				(>=	(+
						(ai_spawn_count factory_1_sentinels_03_low)
						(ai_spawn_count factory_1_sentinels_03_high)
					)
				6)
			)
		)
	)
)

;Waits until major is dead before the Flood pour in
(script dormant factory_1_flood_surge
	(sleep_until (= (ai_living_count factory_1_major) 0))
	(sleep_forever factory_1_flood_respawn)
	(ai_set_orders factory1_flood factory_1_flood_tubes_fwd)

	(sleep_until 
		(begin
			(sleep_until
				(OR
					(= (volume_test_objects vol_factory_1_mid_03 (players)) TRUE)
					(< (ai_nonswarm_count factory1_flood) 3)
				)
			)
			(if (= (volume_test_objects vol_factory_1_mid_03 (players)) FALSE)
				(ai_place factory_1_flood_end 1)
				(sleep 120)
			)
			(if (= (volume_test_objects vol_factory_1_mid_03 (players)) FALSE)
				(ai_place factory_1_flood_tubes_far 1)
				(sleep 120)
			)
			(if (= (volume_test_objects vol_factory_1_mid_03 (players)) FALSE)
				(ai_place factory_1_flood_tubes_near 1)
				(sleep 120)
			)
			(if (= (volume_test_objects vol_factory_1_mid_03 (players)) FALSE)
				(ai_place factory_1_flood_alcove 1)
				(sleep 120)
			)
			(or
				(= (volume_test_objects vol_factory_1_mid_03 (players)) TRUE)
				(>=	(+
						(ai_spawn_count factory_1_flood_end)
						(ai_spawn_count factory_1_flood_tubes_far)
						(ai_spawn_count factory_1_flood_tubes_near)
						(ai_spawn_count factory_1_flood_alcove)
					)
				10)
			)
		)
	)
	(sleep_until 
		(begin
			(sleep_until
				(OR
					(= (volume_test_objects vol_factory_1_exit (players)) TRUE)
					(< (ai_nonswarm_count factory1_flood) 2)
				)
			)
			(if (= (volume_test_objects vol_factory_1_exit (players)) FALSE)
				(ai_place factory_1_flood_end 1)
				(sleep 120)
			)
			(or
				(= (volume_test_objects vol_factory_1_exit (players)) TRUE)
				(>= (ai_spawn_count factory_1_flood_end) 8)
			)
		)
	)
)

;Overall script for sentinel factory 1
(script dormant sent_factory_1_start
	(sleep_until (= (volume_test_objects vol_factory_1_enter (players)) TRUE)) 
	(game_save)
	
	(ai_place factory_1_sentinels_intro)
	(ai_place factory_1_flood_intro)
	
	(ai_place factory_1_major)
	(ai_place factory_1_sentinels_initial_mid)
	(ai_place factory_1_flood_initial_mid)
	
	(wake factory_1_flood_surge)
	(wake factory_1_flood_respawn)
	(wake factory_1_sentinel_respawn_01)
	(wake factory_1_sentinel_enders)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_factory_1_mid_01 (players)) TRUE)
			(< (ai_nonswarm_count factory1_enemies) 8)
		)
	)
	(game_save_no_timeout)
	(ai_place factory_1_sentinels_initial_end)
	(ai_place factory_1_flood_initial_end)

	(sleep_until (= (volume_test_objects vol_factory_1_mid_01 (players)) TRUE))
	(game_save)
	(sleep_forever factory_1_sentinel_respawn_01)
	(wake factory_1_sentinel_respawn_02)
	(ai_renew covenant)

	(sleep_until (= (volume_test_objects vol_factory_1_mid_02 (players)) TRUE))
	(game_save)
	(sleep_forever factory_1_sentinel_respawn_02)

	(sleep_until (= (volume_test_objects vol_factory_1_mid_03 (players)) TRUE))
	(game_save)
	(sleep_forever factory_1_sentinel_enders)
	(sleep_forever factory_1_flood_respawn)
	
	(sleep_until (= (volume_test_objects vol_factory_1_exit (players)) TRUE))
	(game_save)
	(if (= (ai_living_count factory_1_major) 1)
		(sleep_forever factory_1_flood_surge)
	)
)

; ==== GORGE SCRIPTS =====================================================================
(global boolean g_gorge_sen_spawn 0)

(script dormant ai_sentinel_spawn
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count gorge_sen) 0))
			(sleep 150)
			(ai_place gorge_sen)
		g_gorge_sen_spawn)
	)
)

(script dormant ai_gorge
;	(ai_place gorge_jugg_a)
;	(ai_place gorge_jugg_b)
	(ai_place gorge_flood_ini)
	(ai_place gorge_enf)
	(wake ai_sentinel_spawn)
	
	(sleep_until (volume_test_objects tv_gorge_mid (players)))
	(game_save_no_timeout)
	(ai_place gorge_flood_bk)
	
	(sleep_until (volume_test_objects tv_gorge_bk_cave (players)))
	(ai_place gorge_flood_bk_cave)
	(set g_gorge_sen_spawn 1)
)

; ===== FACTORY 2 SCRIPTS ================================================================
(script dormant ai_factory2
	(ai_place factory2_flood_ini)

	(sleep_until (volume_test_objects tv_factory2_mid (players)))
	(game_save_no_timeout)
	(if	(<= (ai_living_count factory2_flood) 4)
		(begin
			(ai_place factory2_flood_mid)
			(ai_place factory2_flood_bk)
		)
	)
	
	(sleep_until (volume_test_objects tv_factory2_bk (players)))
	(game_save)
	(ai_place factory2_flood_bk_tunnel)
	(ai_place factory2_sen_bk_tunnel)
)



;===== QUARANTINE ZONE EXTERIOR B ========================================================
(script dormant ai_constructor_flock
	(flock_start constructor_swarm)
	(sleep 150)
	(flock_stop constructor_swarm)
)

(global boolean g_ext_b_phantom 0)
(global vehicle v_ext_b_phantom none)


(script command_script cs_ext_b_phantom ; called from the starting location 
	(cs_shoot true)
	(cs_enable_pathfinding_failsafe true)
	(ai_place qz_ext_b_cov_spec_ops)
;	(ai_place qz_ext_b_cov_ghosts)
	(ai_place qz_ext_b_cov_spectre)
	(object_cannot_die (ai_get_object qz_ext_b_cov_spec_ops/soc) true)

	(sleep 1)
		(vehicle_load_magic v_ext_b_phantom "phantom_p" (ai_actors qz_ext_b_cov_spec_ops))
		(vehicle_load_magic v_ext_b_phantom "phantom_sc01" (ai_vehicle_get_from_starting_location qz_ext_b_cov_ghosts/a))
		(vehicle_load_magic v_ext_b_phantom "phantom_sc02" (ai_vehicle_get_from_starting_location qz_ext_b_cov_ghosts/b))
		(vehicle_load_magic v_ext_b_phantom "phantom_lc" (ai_vehicle_get_from_starting_location qz_ext_b_cov_spectre/spectre))
	(sleep 1)
	(cs_vehicle_boost true)
	(cs_fly_by qz_ext_b_phantom/p0 5)
	(cs_fly_by qz_ext_b_phantom/p1 5)
	(cs_vehicle_boost false)
	(ai_magically_see qz_ext_b_wraith_a qz_ext_b_cov_phantom)
	(cs_fly_by qz_ext_b_phantom/p2 5)
	(cs_fly_by qz_ext_b_phantom/p3 3)
	(cs_fly_to qz_ext_b_phantom/p4)
	(cs_face true qz_ext_b_phantom/p2)
;	(sleep 30)
	(cs_vehicle_speed .65)
	(cs_fly_to_and_face qz_ext_b_phantom/drop qz_ext_b_phantom/p2)
	(object_set_phantom_power v_ext_b_phantom 1)

;	(sleep_until g_ext_b_phantom)
		(sleep 45)
		(vehicle_unload v_ext_b_phantom "phantom_sc")
		(vehicle_unload v_ext_b_phantom "phantom_lc")
		(sleep 45)
		(vehicle_unload v_ext_b_phantom "phantom_p_a01")
		(sleep 30)
		(vehicle_unload v_ext_b_phantom "phantom_p_a02")
		(sleep 30)
		(vehicle_unload v_ext_b_phantom "phantom_p_a03")
		(sleep 45)
		(object_set_phantom_power v_ext_b_phantom 0)

;		(ai_vehicle_enter qz_ext_b_cov_spec_ops (ai_vehicle_get_from_starting_location qz_ext_b_cov_ghosts/a))
;		(ai_vehicle_enter qz_ext_b_cov_spec_ops (ai_vehicle_get_from_starting_location qz_ext_b_cov_ghosts/b))
		(ai_vehicle_enter qz_ext_b_cov_spec_ops (ai_vehicle_get_from_starting_location qz_ext_b_cov_spectre/spectre))

	(cs_face false qz_ext_b_phantom/p2)
	(cs_vehicle_speed 1)
	(sleep 60)
	
	(wake sc_ext_b)
	
	(cs_fly_by qz_ext_b_phantom/p2 3)
	(cs_fly_by qz_ext_b_phantom/p1 3)
	(cs_fly_by qz_ext_b_phantom/p0 3)
	(ai_erase ai_current_squad)
)

(global boolean g_ext_b_ent_phantom 0)

(script command_script cs_ext_b_ent_phantom ; called from the starting location 
	(cs_enable_pathfinding_failsafe 1)
	(cs_vehicle_boost true)
	(cs_fly_by qz_ext_b_ent_phantom/p0 5)
	(cs_fly_by qz_ext_b_ent_phantom/p1 5)
	(cs_fly_by qz_ext_b_ent_phantom/p2 5)
	(cs_vehicle_boost false)
	(cs_fly_to qz_ext_b_ent_phantom/p3)
	(cs_face true qz_ext_b_ent_phantom/p5)
;	(sleep 30)
	(cs_vehicle_speed .65)
	(cs_fly_to qz_ext_b_ent_phantom/drop)
	
	(sleep_until g_ext_b_ent_phantom)
	(cs_face false qz_ext_b_ent_phantom/p5)
	(cs_vehicle_speed 1)
	(cs_fly_by qz_ext_b_ent_phantom/p5 3)
	(cs_vehicle_boost true)
	(cs_fly_by qz_ext_b_ent_phantom/p6 3)
	(ai_erase ai_current_squad)
)

(script dormant ai_ext_b_exit_tube_a
	(sleep_until (volume_test_objects tv_ext_b_exit_tube_a (players)))
	(ai_place qz_ext_b_ent_flood_tube_a (pin (- 8 (ai_nonswarm_count ext_b_flood)) 0 6))
)
(script dormant ai_ext_b_exit_tube_b
	(sleep_until (volume_test_objects tv_ext_b_exit_tube_b (players)))
	(ai_place qz_ext_b_ent_flood_tube_b (pin (- 8 (ai_nonswarm_count ext_b_flood)) 0 6))
)

(global boolean g_ext_b_enforcer 0)

(script dormant ai_ext_b_enf_spawn
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count ext_b_sentinels_b) 0))
			
			(cond
				((volume_test_objects tv_ext_b_mid (players)) (ai_place qz_ext_b_enf_b))
				(true (ai_place qz_ext_b_enf_a))
			)
			(or ; exit conditions 
				(>= (ai_spawn_count ext_b_sentinels_b) 4)
				g_ext_b_enforcer
			)
		)
	)
)

(global boolean g_ext_b_bk_ghost_spawn 0)
(global short g_ext_b_bk_ghost_limit 0)
(global short g_ext_b_bk_ghost_number 0)

(script dormant ai_ext_b_bk_ghost_spawn
	(cond
		((difficulty_normal) (begin (set g_ext_b_bk_ghost_limit 6) (set g_ext_b_bk_ghost_number 1)))
		((difficulty_heroic) (begin (set g_ext_b_bk_ghost_limit 8) (set g_ext_b_bk_ghost_number 2)))
		((difficulty_legendary) (begin (set g_ext_b_bk_ghost_limit 10) (set g_ext_b_bk_ghost_number 3)))
	)

	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count qz_ext_b_ent_ghost_bk) 0))
			(sleep 90)
			(if debug (print "placing ghosts"))
			(ai_place qz_ext_b_ent_ghost_bk g_ext_b_bk_ghost_number)
		(or ; exit conditions 
			(>= (ai_spawn_count qz_ext_b_ent_ghost_bk) g_ext_b_bk_ghost_limit)
			g_ext_b_bk_ghost_spawn)
		)
	)
)


;= KEY CONTROL ===========================================================================
;*
Scripts which drive the key's motion through the level.
Also, scripts which drive Tartarus's dropship, and the human key.

*;

;- Globals ---------------------------------------------------------------------

; Flags for transmitting key state
(global boolean g_key_started false)
(global boolean g_key_lock0_entered false)
	(global boolean g_key_lock0_first_loadpoint false)
	(global boolean g_key_lock0_second_loadpoint false)
	(global boolean g_key_lock0_begin_human false)
	(global boolean g_key_lock0_door1 false)
(global boolean g_key_cruise_entered false)
	(global boolean g_key_cruise_first_loadpoint false)
	(global boolean g_key_cruise_halfway false)
(global boolean g_key_shaft_entered false)
	(global boolean g_key_shaft_rising false)
	(global boolean g_key_shaft_near_exterior false)
(global boolean g_key_lock1_entered false)
	(global boolean g_key_lock1_first_arch false)
	(global boolean g_key_lock1_second_arch false)
(global boolean g_key_library_entered false)
	(global boolean g_key_library_arrival false)


;- Event Control ---------------------------------------------------------------

(script dormant key_ride_door3_main
	; Begin opening
	(print "key_ride_door3 begins to open")
	(device_set_position key_ride_door3 1.0)

	; Sleep until finished opening
	(sleep_until (>= (device_get_position key_ride_door3) 0.9) 10)
	(sleep 60)
	
	; Begin closing
	(print "key_ride_door3 begins to close")
	(device_set_position key_ride_door3 0.0)
)

(script dormant key_ride_human_door2_main
	; Begin opening
	(print "human_key_door2 begins to open")
	(device_set_position human_key_door2 1.0)

	; Sleep until finished opening
	(sleep_until (>= (device_get_position human_key_door2) 0.9) 10)
	
	; Begin closing
	(print "human_key_door2 begins to close")
	(device_set_position human_key_door2 0.0)
)

(script dormant key_ride_door2_main
	; Begin opening
	(print "key_ride_door2 begins to open")
	(device_set_position key_ride_door2 1.0)

	; Sleep until finished opening
	(sleep_until (>= (device_get_position key_ride_door2) 0.9) 10)
	
	; Begin closing
	(print "key_ride_door2 begins to close")
	(device_set_position key_ride_door2 0.0)
)

(script dormant key_ride_door1_main
	; Begin opening
	(print "key_ride_door1 begins to open")
	(device_set_position key_ride_door1 1.0)

	; Sleep until finished opening
	(sleep_until (>= (device_get_position key_ride_door1) 0.9) 10)
	(sleep 60)
	
	; Begin closing
	(print "key_ride_door1 begins to close")
	(device_set_position key_ride_door1 0.0)
)

(script dormant key_ride_door0_main
	; Begin opening
	(print "key_ride_door0 begins to open")
	(device_set_position_immediate key_ride_door0 0.32)
	(device_closes_automatically_set key_ride_door0 false)
	(device_set_position key_ride_door0 1.0)

	; Sleep until finished opening
	(sleep_forever)
	(sleep_until (>= (device_get_position key_ride_door0) 0.9) 10)
	(sleep 540)
	
	; Begin closing
	(print "key_ride_door0 begins to close")
	(device_set_position key_ride_door0 0.0)
)

(script dormant key_main
	; For Joe
	(wake key_ride_door0_main)

	; When awakened, this script starts the key in the correct place and
	; drives it for the rest of the mission. Progress is inexorable--everything
	; adjusts to the omnipotent key. All fear the key! THE KEY WILL DESTROY YOU

	; Make it always active
	(pvs_set_object key)

	;- Horizontal Section ---------------------------------------
	
	; Start the sound
	(sound_looping_start "sound\ambience\device_machines\shq__key\shq__key" none 1.0)

	; Set the track and go
	(device_set_position_track key track_horiz0 0)
	
	; Get it to the initial position
	(device_animate_position key 0.3 0.0 0 0 false)
	(sleep 5)

	; Teleport the players onto the key 
	(object_teleport (player0) key_ent0)
	(object_teleport (player1) key_ent1)
	(sleep 5)

	; Begin the first leg, to the interior cruise
	(device_animate_position key 0.6 75 0 0 false)
	(set g_key_started true)
	
	; Sleep until the key is in position to begin opening the next door
	(sleep_until 
		(>= (device_get_position key) 0.35)
		3
	)

	; Begin opening the first door
	(wake key_ride_door0_main)

	; Sleep until the key is entering the first lock
	(sleep_until 
		(>= (device_get_position key) 0.4)
		3
	)
	(set g_key_lock0_first_loadpoint true)

	; Flag that we're entering the first lock
	(set g_key_lock0_entered true)
	
	; Sleep until the key is passing the first loading point
	(sleep_until 
		(>= (device_get_position key) 0.43)
		3
	)
	(set g_key_lock0_first_loadpoint true)
	
	; Sleep until the key is in position for a bsp swap
	(sleep_until 
		(>= (device_get_position key) 0.48)
		3
	)
	
	; Swap BSPs
	(switch_bsp_by_name sen_hq_bsp_6)
	
	; Sleep until the key is approaching the next load point
	(sleep_until 
		(>= (device_get_position key) 0.50)
		3
	)
	(set g_key_lock0_second_loadpoint true)
	
	; Sleep until we should start the Human key
	(sleep_until 
		(>= (device_get_position key) 0.50)
		3
	)
	(set g_key_lock0_begin_human true)
		
	; Sleep until the key is in position to begin opening the next door
	(sleep_until 
		(>= (device_get_position key) 0.53)
		3
	)
	(set g_key_lock0_door1 true)
	
	; Begin opening the door
	(wake key_ride_door1_main)

	; Sleep until the key is entering the interior cruise
	(sleep_until 
		(>= (device_get_position key) 0.58)
		3
	)
	(set g_key_cruise_entered true)
	
	; Accelerate
	(device_animate_position key 1.0 45 5 10 true)
	
	; Sleep until the key is near the first loadpoint, then the second
	(sleep_until 
		(>= (device_get_position key) 0.67)
		3
	)
	(set g_key_cruise_first_loadpoint true)
	(sleep_until 
		(>= (device_get_position key) 0.84)
		3
	)
	(set g_key_cruise_halfway true)
	
	; Sleep until the key is into the vertical rise
	(sleep_until 
		(>= (device_get_position key) 1.0)
		3
	)
	(set g_key_shaft_entered true)
	
	;- Vertical Section -----------------------------------------

	; Short pause
	(sleep 30)

	; Set the tracks and go
	(device_set_position_track key track_rise 0)
	(device_set_overlay_track key overlay_transform)
	
	; Start the alt track
	(sound_looping_set_alternate "sound\ambience\device_machines\shq__key\shq__key" true)

	; TRANSFORM AND ROLL OUT!!!1
	(device_animate_overlay key 1.0 5 0 0)
	(sleep 180)
	
	; Start it moving
	(device_animate_position key 1.0 90 20 10 false)	
	(set g_key_shaft_rising true)
	(set g_music_06b_06 1)

	; Sleep until the key is near the interior->exterior shaft transition
	(sleep_until 
		(>= (device_get_position key) 0.3)
		3
	)
	(set g_key_shaft_near_exterior true)

	; Sleep until the key is in position to begin opening the third door
	(sleep_until 
		(>= (device_get_position key) 0.73)
		3
	)

	; Begin opening the door
	(wake key_ride_door2_main)

	; Sleep until the key is in position to transform back
	(sleep_until 
		(>= (device_get_position key) 1.0)
		3
	)
	(set g_key_lock1_entered true)
	
	; Start the alt track
	(sound_looping_stop "sound\ambience\device_machines\shq__key\shq__key")

	;- Horizontal Section ---------------------------------------

	; Short pause
	(sleep 30)

	; Set the track and go
	(device_set_position_track key track_horiz1 0)
	
	; Start the sound
	(sound_looping_start "sound\ambience\device_machines\shq__key\shq__key" none 1.0)

	; TRANSFORM AND ROLL OUT!!!1
	(device_animate_overlay key 0.0 5 0 0)
	(sleep 180)
	
	; Start it moving
	(device_animate_position key 1.0 75 10 10 false)

	; Sleep until the key is near the first arch
	(sleep_until 
		(>= (device_get_position key) 0.15)
		3
	)
	(set g_key_lock1_first_arch true)
	
	; Sleep until the key is near the second arch
	(sleep_until 
		(>= (device_get_position key) 0.4)
		3
	)
	(set g_key_lock1_second_arch true)
	
	; Sleep until the key is in position to begin opening the last door
	(sleep_until 
		(>= (device_get_position key) 0.49)
		3
	)

	; Begin opening the door
	(wake key_ride_door3_main)

	; Sleep until the key is entering the library
	(sleep_until 
		(>= (device_get_position key) 0.65)
		3
	)
	(set g_key_library_entered true)

	; Sleep until the key is halfway in
	(sleep_until 
		(>= (device_get_position key) 0.85)
		3
	)
	
	; Begin tilting up the outriggers
	(device_animate_overlay key 1.0 5 0 0)

	; Ride it out
	(sleep_until 
		(>= (device_get_position key) 1.0)
		3
	)
	(set g_key_library_arrival true)
	(wake chapter_familiar)
	(wake sc_dock)
	(set g_music_06b_05 0)

	; Start the alt track
	(sound_looping_stop "sound\ambience\device_machines\shq__key\shq__key")
)

(script dormant key_ride_human_key_main
	; Do the exterior stuff
	
	; Sleep until the player is near the interior cruise
	(sleep_until g_key_lock0_begin_human 10)
	
	; Place the key, and move it into position
	(object_create_anew key_human)
	
	; Make it always active
	(pvs_set_object key_human)

	; Set the track and go
	(device_set_position_track key_human track_horiz0 0)
	
	; Get it to the initial position
	(device_animate_position key_human 0.58 0.5 0 0 false)
	(sleep 15)
	(device_animate_position key_human 1.0 55 5 10 false)

	; Sleep until the key is into the vertical rise
	(sleep_until 
		(>= (device_get_position key_human) 1.0)
		3
	)
	
	;- Vertical Section -----------------------------------------

	; Short pause
	(sleep 30)

	; Set the tracks and go
	(device_set_position_track key_human track_rise 0)
	(device_set_overlay_track key_human overlay_transform)
	
	; TRANSFORM AND ROLL OUT!!!1
	(device_animate_overlay key_human 1.0 5 0 0)
	(sleep 180)
	
	; Start it moving
	(device_animate_position key_human 1.0 80 20 10 false)	

	; Sleep until the key is in position to begin opening the door
	(sleep_until 
		(>= (device_get_position key_human) 0.71)
		3
	)

	; Begin opening the door
	(wake key_ride_human_door2_main)

	; Sleep until the key is in position to transform back
	(sleep_until 
		(>= (device_get_position key_human) 1.0)
		3
	)

	;- Horizontal Section ---------------------------------------

	; Short pause, let the other key catch up
	(sleep 120)

	; Set the track and go
	(device_set_position_track key_human track_horiz1 0)
	
	; TRANSFORM AND ROLL OUT!!!1
	(device_animate_overlay key_human 0.0 5 0 0)
	(sleep 180)
	
	; Start it moving
	(device_animate_position key_human 1.0 75 10 10 false)	

	; Sleep until the key is out of sight, and then end this charade
	(sleep_until 
		(>= (device_get_position key_human) 0.191)
		3
	)
	(object_destroy key_human)
	
	; Set the overlay of the docked key
	(object_create_anew key_docked)
	(sleep 1)
	(device_set_overlay_track key_docked overlay_transform)
	(device_animate_overlay key_docked 1.0 0.1 0 0)
)

(script command_script cs_e21_tartarus
	(cs_enable_pathfinding_failsafe true)
	(print "e21 *tartarus returns from harassing human key*")
	(cs_vehicle_boost true)
	(cs_fly_by e21_tartarus/p0)
	(cs_vehicle_boost false)

	; Move in behind the key
	(print "e21 *tartarus follows the key in through the door*")	
	(cs_fly_by e21_tartarus/p1)
	
	; Follow the key
	(cs_vehicle_speed 0.75)
	(cs_enable_pathfinding_failsafe false)
	(sleep_until
		(begin
			(cs_fly_by key_bsp5/left)
			false
		)
		3
		300
	)

	; Move in behind the key
	(cs_vehicle_speed 0.85)
	(cs_face true e22_tartarus_bsp6/forward_facing)

	; Hold position
	(sleep_until
		(begin
			(cs_fly_by key_bsp5/center)
			false
		)
		3
		300
	)
)

(script command_script cs_e22_tartarus
	(cs_face false e22_tartarus_bsp6/forward_facing)
	(cs_fly_by e22_tartarus/p0)
	(cs_fly_by e22_tartarus/p1)

	; Boost ahead and through
	(cs_vehicle_boost true)
	(cs_fly_by e22_tartarus/p2)
	(cs_vehicle_boost false)
	
	; Wait for them
	(cs_fly_to e22_tartarus/p3 1.0)
	(sleep 50)

	(cs_face true e22_tartarus_bsp6/forward_facing)
	(cs_vehicle_speed 0.9)
	(cs_fly_by key_bsp6/center_front)
	(cs_vehicle_speed 0.9)
	(sleep_until
		(begin
			(cs_fly_by key_bsp6/center_front 1.0)
			false
		)
		3
	)
)

(script command_script cs_e23_tartarus
	; Head off to the Human key
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost true)
	(cs_fly_by e23_tartarus/p0)
	(cs_fly_by e23_tartarus/p1)
	(cs_vehicle_boost false)
	(cs_fly_by e23_tartarus/p2)
	
	; Join in with it
	(cs_vehicle_speed 1.0)
	(sleep_until
		(begin
			(cs_fly_by key_human_bsp6/left_high 1.0)
			false
		)
		3
		360
	)

	
	; And teleport him to safety
	(cs_teleport e23_tartarus/teleport_dest e23_tartarus/teleport_facing)
	(sleep_forever)
)

(script command_script cs_e24_tartarus
	(sleep 200)
	(cs_vehicle_speed 0.6)
	(cs_fly_by e24_tartarus/p0)
	(cs_vehicle_speed 1.0)
	(cs_fly_by e24_tartarus/p1)
	(cs_fly_by e24_tartarus/p2)
	(sleep_forever)
)

(script command_script cs_e25_tartarus
	(sleep 120)
	(cs_face true e25_tartarus/p0)
	(sleep 60)
	(cs_face false e25_tartarus/p0)
	(cs_vehicle_speed 0.6)
	(cs_fly_by e25_tartarus/p0)

	; Head up to the arch
	(cs_vehicle_speed 1.0)
	(cs_fly_to e25_tartarus/p1 1.0)
	(cs_face true e25_tartarus/p1_facing)
	(sleep 320)
	(cs_face false e25_tartarus/p1_facing)

	; Fall in behind the key
	(cs_vehicle_speed 1.0)
;	(cs_fly_by e25_tartarus/p2 1.0)
	(cs_fly_by key_bsp6/center 1.0)
	(cs_vehicle_speed 0.9)
	(sleep_until
		(begin
			(cs_fly_by key_bsp6/center 1.0)
			false
		)
		3
	)

)

(script command_script cs_e26_tartarus
	; Fall in behind the key
	(cs_vehicle_speed 0.9)
	(sleep_until
		(begin
			(cs_fly_by key_bsp6/center 1.0)
			false
		)
		3
		210
	)

	; Fly off to check out the human key
	(cs_fly_to e26_tartarus/p0)
	(sleep 120)
	(cs_fly_by e26_tartarus/p1)
	(cs_fly_by e26_tartarus/p2)
	(ai_erase ai_current_squad)
)

(script dormant key_ride_tartarus_main
	(ai_place key_ride_tartarus)

	; e21 stuff
	(cs_run_command_script key_ride_tartarus/tartarus cs_e21_tartarus)

	; e22 stuff
	(sleep_until (= (structure_bsp_index) 4) 10)
	(cs_run_command_script key_ride_tartarus/tartarus cs_e22_tartarus)

	; e23 stuff
	(sleep_until g_key_cruise_entered 10)
	(cs_run_command_script key_ride_tartarus/tartarus cs_e23_tartarus)
	
	; e24 stuff
	(sleep_until g_key_shaft_near_exterior 10)
	(cs_run_command_script key_ride_tartarus/tartarus cs_e24_tartarus)
	
	; e25 stuff
	(sleep_until g_key_lock1_entered 10)
	(cs_run_command_script key_ride_tartarus/tartarus cs_e25_tartarus)

	; e26 stuff
	(sleep_until g_key_library_entered 10)
	(cs_run_command_script key_ride_tartarus/tartarus cs_e26_tartarus)
)

(script static void key_ride_test
	(wake key_main)
	(wake key_ride_human_key_main)
	(wake key_ride_tartarus_main)
)


;= ENCOUNTER 26 ==========================================================================
;*
The Library. MWA-HAH-HAH-HAAAAaaaaa....

Begins when player steps off the key.
Ends with the mission.

Flood
	e26_fld_inf0 - Packs of infection forms that scurry about

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e26_started false)			; Encounter has been activated?
(global boolean g_e26_ended false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e26_fld_infections_entry3
	(cs_abort_on_damage true)
	(sleep 30)
	(cs_go_to e26_fld_infection_forms0/p2)
	(cs_go_to e26_fld_infection_forms0/p3)
	(cs_go_to e26_fld_infection_forms0/p4)
	(cs_go_to e26_fld_infection_forms0/p5)
	(ai_erase ai_current_actor)
)

(script command_script cs_e26_fld_infections_entry2
	(cs_abort_on_damage true)
	(sleep 30)
	(cs_go_to e26_fld_infection_forms0/p6)
	(cs_go_to e26_fld_infection_forms0/p7)
	(cs_go_to e26_fld_infection_forms0/p2)
	(cs_go_to e26_fld_infection_forms0/p3)
	(cs_go_to e26_fld_infection_forms0/p4)
	(cs_go_to e26_fld_infection_forms0/p5)
	(ai_erase ai_current_actor)
)

(script command_script cs_e26_fld_infections_entry1
	(cs_abort_on_damage true)
	(sleep 30)
	(cs_go_to e26_fld_infection_forms0/p8)
	(cs_go_to e26_fld_infection_forms0/p7)
	(cs_go_to e26_fld_infection_forms0/p2)
	(cs_go_to e26_fld_infection_forms0/p3)
	(cs_go_to e26_fld_infection_forms0/p4)
	(cs_go_to e26_fld_infection_forms0/p5)
	(ai_erase ai_current_actor)
)

(script command_script cs_e26_fld_infections_entry0
	(cs_abort_on_damage true)
	(sleep 30)
	(cs_go_to e26_fld_infection_forms0/p0)
	(cs_go_to e26_fld_infection_forms0/p1)
	(cs_go_to e26_fld_infection_forms0/p2)
	(cs_go_to e26_fld_infection_forms0/p3)
	(cs_go_to e26_fld_infection_forms0/p4)
	(cs_go_to e26_fld_infection_forms0/p5)
	(ai_erase ai_current_actor)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Scripts ---------------------------------------------------------------

(script dormant e26_smg1
	(object_create e26_smg1)	
	(sleep_until
		(begin
			(weapon_hold_trigger e26_smg1 0 true)
			(sleep_until g_e26_ended 2 (random_range 15 45))
			(weapon_hold_trigger e26_smg1 0 false)
			(sleep_until g_e26_ended 2 (random_range 45 90))
			
			; Loop until the encounter ends
			g_e26_ended
		)
		1
	)
	(weapon_hold_trigger e26_smg1 0 false)
	(object_destroy e26_smg1)
)

(script dormant e26_smg0
	(object_create e26_smg0)	
	(sleep_until
		(begin
			(weapon_hold_trigger e26_smg0 0 true)
			(sleep_until g_e26_ended 2 (random_range 15 45))
			(weapon_hold_trigger e26_smg0 0 false)
			(sleep_until g_e26_ended 2 (random_range 45 90))
			
			; Loop until the encounter ends
			g_e26_ended
		)
		1
	)
	(weapon_hold_trigger e26_smg0 0 false)
	(object_destroy e26_smg0)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e26_fld_infections_main
	(ai_place e26_fld_infection_forms0/swarm0)
	(sleep_until (< (objects_distance_to_flag (players) e26_fld_infs0_1) 10) 10 300)
	(ai_place e26_fld_infection_forms0/swarm1)
	(sleep_until (< (objects_distance_to_flag (players) e26_fld_infs0_2) 10) 10 300)
	(ai_place e26_fld_infection_forms0/swarm2)
	(sleep_until (< (objects_distance_to_flag (players) e26_fld_infs0_3) 10) 10 300)
	(ai_place e26_fld_infection_forms0/swarm3)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e26_main
	(sleep_until (volume_test_objects tv_e26_main_begin (players)) 10)
	(data_mine_set_mission_segment enc_e26)
	(set g_e26_started true)
	(print "e26_main")
	(game_save)
	
	; Wake subsequent scripts

	; Wake control scripts
	(wake e26_fld_infections_main)
	(wake e26_smg0)
	(wake e26_smg1)
	
	; Encounter end condition
	(sleep_until 
		(or
			(volume_test_objects tv_mission_end0 (players)) 
			(volume_test_objects tv_mission_end1 (players)) 
		)
		10
	)
	(set g_e26_ended 1)
)


;= ENCOUNTER 25 ==========================================================================
;*
Flood combat in the second interior lock.

Begins when the key reaches the top of the shaft.
Ends sometime later (indeterminate).

Elites
	e25_cov_inf0 - Elite allies
		(init) - Fighting and covering

Flood
	e25_fld_inf0 - First arch Flood
		_0 - First carrier wave
		_1 - Second carrier wave
		_2 - Combat forms
			(engage) - Engaging Covenant
	e25_fld_inf1 - Second arch Flood
		_0 - First carrier wave
		_1 - Second carrier wave
		_2 - Combat forms
			(engage) - Engaging Covenant

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e25_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e25_scene3
	; Send both Elites to their destinations
	(cs_switch "elite1")
	(cs_start_to e25_scenes/p1)
	(cs_switch "elite0")
	(cs_start_to e25_scenes/p0)
	
	; Wait until he's close to the player or done moving
	(sleep_until
		(or
			(not (cs_moving))
			(and
				(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
				(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4)
			)
		)
	)
	
	; Stop and face the player
	(cs_face_player true)
	(cs_approach (ai_get_object ai_current_actor) 1 1 1) ; Hack, whee
	
	; Wait for the player to be closer still
	(sleep_until
		(and
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
			(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4)
		)
	)
	(print "elite0: we'll guard the key")
	(sleep (ai_play_line_at_player ai_current_actor 0910))
	(sleep 20)
	
	; Second Elite chimes in
	(cs_switch "elite1")

	; Wait until he's close to the player or done moving
	(sleep_until
		(or
			(not (cs_moving))
			(and
				(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
				(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4)
			)
		)
	)
	
	; Stop and face the player
	(cs_face_player true)
	(cs_approach (ai_get_object ai_current_actor) 1 1 1) ; Hack, whee
	
	; Wait for the player to be closer still
	(sleep_until
		(and
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
			(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4)
		)
	)
	(print "elite1: git to werk")
	(sleep (ai_play_line_at_player ai_current_actor 0920))
)

(script command_script cs_e25_scene1
	(cs_start_to e25_scenes/p0)
	
	; Wait until he's close to the player or done moving
	(sleep_until
		(or
			(not (cs_moving))
			(and
				(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
				(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4)
			)
		)
	)
	
	; Stop and face the player
	(cs_face_player true)
	(cs_approach (ai_get_object ai_current_actor) 1 1 1) ; Hack, whee
	
	; Wait for the player to be closer still
	(sleep_until
		(and
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
			(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4)
		)
	)
	(print "elite0: we'll guard the key")
	(sleep (ai_play_line_at_player ai_current_actor 0910))
	(sleep 15)
	(print "elite0: get the icon")
	(sleep (ai_play_line_at_player ai_current_actor 0920))
)

(script command_script cs_e25_scene0
	(print "elite: behold, the library") ; haaa hahahaha, 5 million people just shat their pants
	(sleep (ai_play_line ai_current_actor 0890))
)


;- Order Scripts ---------------------------------------------------------------
;- Event Scripts ---------------------------------------------------------------

(script dormant e25_dialogue
	; Elite scene
	(sleep_until
		(ai_scene e25_scene0 cs_e25_scene0 e21_cov_inf0)
		5
		300
	)
	
	; Tartarus replies
	(sleep 120)
	(ai_play_line_on_object none 0900)
	
	; End scene
	(sleep_until g_key_library_arrival 10)
	
	; Try the ideal scene
	(if (>= (ai_living_count e21_cov_inf0) 2)
		; Do the ideal scene
		(begin
			(sleep_until
				(ai_scene e25_scene3 cs_e25_scene3 e21_cov_inf0)
				5
			)
		)

		; That failed, so do the singleton scene
		(begin
			(sleep_until
				(ai_scene e25_scene1 cs_e25_scene1 e21_cov_inf0)
				5
			)
		)
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e25_fld_inf1_main
	; Wait until the key is near the second arch
	(sleep_until g_key_lock1_second_arch 10)
	
	; First volley!
	(ai_place e25_fld_inf1_0)
	
	; Second volley
	(sleep 60)
	(ai_place e25_fld_inf1_1)
	
	; Combat forms!
	(sleep 60)
	(ai_place e25_fld_inf1_2)
)

(script dormant e25_fld_inf0_main
	; Wait until the key is near the first arch
	(sleep_until g_key_lock1_first_arch 10)
	
	; First volley!
	(ai_place e25_fld_inf0_0)
	
	; Second volley
	(sleep 60)
	(ai_place e25_fld_inf0_1)
	
	; Combat forms!
	(sleep 60)
	(ai_place e25_fld_inf0_2)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e25_main
	(data_mine_set_mission_segment enc_e25)
	(sleep_until g_key_lock1_entered 10)
	(set g_e25_started true)
	(print "e25_main")
	(game_save)
	
	; Wake subsequent scripts
	(wake e26_main)

	; Wake control scripts
;	(wake e25_fld_inf0_main)
;	(wake e25_fld_inf1_main)
	(wake e25_dialogue)
	
	; Shut down
	(sleep_until g_e26_started)
	(sleep_forever e25_fld_inf0_main)
	(sleep_forever e25_fld_inf1_main)
)


;= ENCOUNTER 24 ==========================================================================
;*
Flood combat in the vertical section.

Begins when the key enters the base of the vertical section.
Ends sometime later (indeterminate).

Elites

Flood
	e24_fld_juggernaut - Guess
		(killificate) - Kill folks
	e24_fld_inf0 - Any leftover combat forms
		(guard0) - Guard left side
		(guard1) - Guard right side
		(follow) - Follow the Juggernaut
	e24_fld_inf1 - Reinforcements for the juggernaut's posse
		_0 - From the left side
		_1 - From the right side
			(follow) - Follow the Juggernaut
	e24_fld_inf2 - Reinforcements at the interior->exterior threshhold
		(follow) - Follow the Juggernaut
		(engage) - Free roam if the Juggernaut dies

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e24_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e24_fld_inf1_load
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_face_object true key)

	; Wait for it...
	(sleep 210)
	
	; Board it
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(cs_face_object false key)
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(if (= (random_range 0 2) 0)
		(begin
			(cs_go_to e24_fld_inf1_load/p0_0)
			(cs_go_to e24_fld_inf1_load/p0_1)
		)
		(begin
			(cs_go_to e24_fld_inf1_load/p1_0)
			(cs_go_to e24_fld_inf1_load/p1_1)
		)
	)

	; Jump in
	(cs_jump_to_point 3 1)

	; Migrate them over
	(ai_migrate ai_current_actor e21_fld_inf0_0)
	
	; Wait for them to land
	(sleep 150)
	(object_can_take_damage (ai_get_object ai_current_actor))
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e24_fld_inf2_main
	(sleep_until g_key_shaft_entered 10)
)

(script dormant e24_fld_inf1_main
	(sleep_until g_key_shaft_rising 10)
	(ai_place e24_fld_inf1_1)
)

(script dormant e24_fld_inf0_main
	(sleep_until g_key_shaft_entered 10)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e24_main
	(sleep_until g_key_shaft_entered 10)
	(data_mine_set_mission_segment enc_e24)
	(set g_e24_started true)
	(print "e24_main")
	(game_save)
	
	; Wake subsequent scripts
	(wake e25_main)

	; Wake control scripts
;	(wake e24_fld_inf0_main)
;	(wake e24_fld_inf1_main)
;	(wake e24_fld_inf2_main)
	
	; Shut down
	(sleep_until g_e25_started)
	(sleep_forever e24_fld_inf0_main)
	(sleep_forever e24_fld_inf1_main)
	(sleep_forever e24_fld_inf2_main)
)


;= ENCOUNTER 23 ==========================================================================
;*
Flood combat in the long interior cruise.

Begins when the key enters the open space.
Ends sometime later (indeterminate).

Elites

Flood
	e23_fld_inf0 - Flood at the second boarding point
		_0 - Left side
			(init) - Firing from the boarding point
		_1 - Right side
			(init) - Firing from the boarding point
			(engage) - Leaping aboard the key and engaging

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e23_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e23_fld_inf0_0_load
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_go_to e23_fld_inf0_load/p0_0)
	(cs_go_to e23_fld_inf0_load/p0_1)
	(cs_jump 15.0 3.0)
)

(script command_script cs_e23_fld_inf0_1_load
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_go_to e23_fld_inf0_load/p1_0)
	(cs_go_to e23_fld_inf0_load/p1_1)
	(cs_jump 15.0 3.0)
)

(script command_script cs_e23_scene0
	(cs_abort_on_combat_status ai_combat_status_visible)
	
	; Elite 0
	(cs_switch "elite0")
	(print "dog: the fool...")
	(sleep (ai_play_line ai_current_actor 0810))
	(sleep 15)
	
	; Elite 0
	(cs_switch "elite1")
	(print "scl: on the bright side...")
	(sleep (ai_play_line ai_current_actor 0820))
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e23_dialogue
	; Tartarus sees the humans
	(sleep 90)
	(print "Tartarus: Humans! I'll deal with them!")
	(sleep (ai_play_line_on_object none 0800))
	(sleep 30)
	
	; Run the response scene
	(sleep_until 
		(ai_scene e23_scene0 cs_e23_scene0 e21_cov_inf0)
		10
		90
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e23_fld_inf0_main
	(sleep_until g_key_cruise_first_loadpoint 10)
	
	; Place the Flood
	(ai_place e23_fld_inf0)
	
	; Wait until the key is close enough
	(sleep_until g_key_cruise_halfway 10)
	(sleep 90)
	
	; Change orders, send them in
	(ai_set_orders e23_fld_inf0_0 e23_fld_inf0_engage)
	(ai_set_orders e23_fld_inf0_1 e23_fld_inf0_engage)
	(cs_run_command_script e23_fld_inf0_0 cs_e23_fld_inf0_0_load)
	(cs_run_command_script e23_fld_inf0_1 cs_e23_fld_inf0_1_load)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e23_main
	(data_mine_set_mission_segment enc_e23)
	(sleep_until g_key_cruise_entered 10)
	(set g_e23_started true)
	(print "e23_main")
	(game_save)
	
	; Wake subsequent scripts
	(wake e24_main)

	; Wake control scripts
;	(wake e23_fld_inf0_main)
	(wake e23_dialogue)
	
	; Shut down
	(sleep_until g_e24_started)
	(sleep_forever e23_fld_inf0_main)
)

(script static void test_key_ride2
	(device_set_position_immediate key 0.26)
	(sleep 1)
	(object_teleport (player0) e23_test)
	(object_set_velocity (player0) 1 0 0)
	(wake key_main)
	(wake e23_main)
	(sleep 3)
	(device_set_position_immediate key 0.26)
	(device_set_position key 1.0)
)


;= ENCOUNTER 22 ==========================================================================
;*
Flood combat in the first interior lock.

Begins when the key passes into the lock.
Ends sometime later (indeterminate).

Elites

Flood
	e22_fld_inf0 - Flood which boards from the second loading ramp
		_0 - Left side
			(init) - Fighting on their side
			(engage0) - Fighting on the key, on the left side
		_1 - Right side
			(init) - Fighting on their side
			(engage0) - Fighting on the key, on the right side
			(engage1) - Free roam
??	e22_fld_inf1 - Flood who board the key from below
		(massing) - Massing before attacking
		(engage) - Attacking when alerted or finished amassing

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e22_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e22_hack_divide
	(if (< (ai_living_count e22_cov_inf1_0) 2)
		(ai_migrate ai_current_actor e22_cov_inf1_0)
		(ai_migrate ai_current_actor e22_cov_inf1_1)
	)
)

(script command_script cs_e22_fld_inf0_0_load
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_face_object true key)
	(sleep_until g_key_lock0_second_loadpoint 1)

	; Wait for it...
	(sleep 95)
	
	; Board it
	(cs_face_object false key)
	(unit_impervious ai_current_actor true)
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(if (= (random_range 0 2) 0)
		(begin
			(cs_go_to e22_fld_inf0_load/p0_0)
			(cs_go_to e22_fld_inf0_load/p0_1)
		)
		(begin
			(cs_go_to e22_fld_inf0_load/p1_0)
			(cs_go_to e22_fld_inf0_load/p1_1)
		)
	)
	(cs_move_in_direction 0 1 0)
	(unit_impervious ai_current_actor false)

	; Migrate them over
	(ai_migrate ai_current_actor e21_fld_inf0_0)
)

(script command_script cs_e22_scene0
	(cs_abort_on_combat_status ai_combat_status_visible)
	
	; Elite 0
	(cs_switch "elite0")
	(print "scl: what courage...")
	(sleep (ai_play_line ai_current_actor 0780))
	(sleep 15)
	
	; Elite 0
	(cs_switch "elite1")
	(print "dog: ignore him...")
	(sleep (ai_play_line ai_current_actor 0790))
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e22_dialogue
	(sleep_until (= (structure_bsp_index) 4))
	
	; Tartarus boosts ahead
	(sleep 90)
	(print "Tartarus: I will thin their ranks")
	(sleep (ai_play_line_on_object none 0770))
	(sleep 30)
	
	; Run the response scene
	(sleep_until 
		(ai_scene e22_scene0 cs_e22_scene0 e21_cov_inf0)
		10
		90
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e22_fld_inf0_main
	(sleep_until g_key_lock0_first_loadpoint 10)
	
	; Place the Flood
	(ai_place e22_fld_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e22_main
	(sleep_until g_key_lock0_entered 10)
	(data_mine_set_mission_segment enc_e22)
	(set g_e22_started true)
	(print "e22_main")
	(game_save)
	
	; Wake subsequent scripts
	(wake e23_main)

	; Wake control scripts
	(wake e22_fld_inf0_main)
	(wake e22_dialogue)
	
	; Shut down
	(sleep_until g_e23_started)
	(sleep_forever e22_fld_inf0_main)
)


;= ENCOUNTER 21 ==========================================================================
;*
A running Flood vs. Covenant battle which rages on the key for the entire run.

Begins when the cutscene ends.
Ends sometime later (indeterminate).

Elites
	e21_cov_inf0 - Elite allies
		(init) - Front idle
		_0 - Ranged specialists, they hang back
			(guard_left) - Guarding the left side
			(guard_right) - Guarding the left side
		_1 - Close range fighters, they hold the line
			(advance_left) - Further up the line on the left
			(advance_right) - Ditto, for the right

Flood
	e21_fld_inf0 - Flood attacking from the left side of the key
		_0 - The main squad
		_1 - Reinforcements from down low
		_2 - Reinforcements from up high
		_3 - Carriers from down low
			(engage0) - Engaging on the left side
			(hunt0) - Hunting all over the key for the player
	e21_fld_inf1 - Flood attacking from the right side of the key
		_0 - The main squad
		_1 - Reinforcements from down low
		_2 - Reinforcements from up high
		_3 - Carriers from down low
			(engage0) - Engaging on the left side
			(hunt0) - Hunting all over the key for the player

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e21_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e21_fld_inf1_low_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_move_in_direction 6 0 0)

	; Head to the rally point
	(if (= (structure_bsp_index) 3)
		(begin
			(cs_go_to e21_fld_bsp5/p2)
			(cs_abort_on_combat_status ai_combat_status_clear_los)
			(cs_go_to e21_fld_bsp5/p1_0)
			(cs_go_to e21_fld_bsp5/p1_1)
		)
		(begin
			(cs_go_to e21_fld_bsp6/p2)
			(cs_abort_on_combat_status ai_combat_status_clear_los)
			(cs_go_to e21_fld_bsp6/p1_0)
			(cs_go_to e21_fld_bsp6/p1_1)
		)
	)	
)

(script command_script cs_e21_fld_inf1_high_entry
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_pathfinding_failsafe true)

	; Jump in
;	(cs_jump_to_point 2.5 1)
	
	; Then go to the rally point
	(if (= (structure_bsp_index) 3)
		(begin
			(cs_go_to e21_fld_bsp5/p1_0)
			(cs_go_to e21_fld_bsp5/p1_1)
		)
		(begin
			(cs_go_to e21_fld_bsp6/p1_0)
			(cs_go_to e21_fld_bsp6/p1_1)
		)
	)	
)

(script command_script cs_e21_fld_inf0_low_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_move_in_direction 6 0 0)

	; Head to the rally point
	(if (= (structure_bsp_index) 3)
		(begin
			(cs_go_to e21_fld_bsp5/p2)
			(cs_abort_on_combat_status ai_combat_status_clear_los)
			(cs_go_to e21_fld_bsp5/p0_0)
			(cs_go_to e21_fld_bsp5/p0_1)
		)
		(begin
			(cs_go_to e21_fld_bsp6/p2)
			(cs_abort_on_combat_status ai_combat_status_clear_los)
			(cs_go_to e21_fld_bsp6/p0_0)
			(cs_go_to e21_fld_bsp6/p0_1)
		)
	)	
)

(script command_script cs_e21_fld_inf0_high_entry
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_pathfinding_failsafe true)

	; Jump in
;	(cs_jump_to_point 2.5 1)
	
	; Head to the rally point
	(if (= (structure_bsp_index) 3)
		(begin
			(cs_go_to e21_fld_bsp5/p0_0)
			(cs_go_to e21_fld_bsp5/p0_1)
		)
		(begin
			(cs_go_to e21_fld_bsp6/p0_0)
			(cs_go_to e21_fld_bsp6/p0_1)
		)
	)	
)

(script command_script cs_e21_fld_inf0_0_load
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(sleep_until g_key_lock0_first_loadpoint 1)
	
	; Shoot at the key
	(sleep 30)
	(cs_shoot_point true key_bsp5/p0)

	; Wait for it...
	(sleep 148)
	(cs_shoot_point false key_bsp5/p0)
	
	; Set their orders
	(ai_set_orders ai_current_squad e21_fld_inf0_engage0)

	; Board it
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e21_fld_load/left0)
	(cs_go_to e21_fld_load/left1)
	(cs_move_in_direction 0 1 0)
)

(script command_script cs_e21_scene0
	(print "elite: I grow restless without a target")
	(sleep (ai_play_line_at_player ai_current_actor 0730))
)

(script command_script cs_e21_scene1
	(print "elite: Look, up ahead! The Parasite readies")
	(ai_play_line_at_player ai_current_actor 0760)
	(sleep 20)
	
	; Move to a point
	(cs_go_to_nearest e21_scene1_points)
	(cs_face true e21_fld_load/p0)
	(cs_aim true e21_fld_load/p0)
	
	; Wait until we're closer...
	(sleep_until g_key_lock0_first_loadpoint 5)

	; Shoot a random combat form
	(cs_shoot_point true e21_fld_load/p0)
	(sleep 90)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e21_in_bsp4
	(= (structure_bsp_index) 4)
)


;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e21_fld_carriers1_main
	; Migrate everyone over
	(ai_migrate e21_fld_carriers0 e21_fld_carriers1)
	
	; Respawner
	(sleep_until
		(begin
			; Replenish the carrier forms
			(if (< (ai_swarm_count e21_fld_carriers1) 2)
				; Respawn one
				(ai_place e21_fld_carriers1 1)
			)
		
			; Loop until the shaft
			g_key_lock1_second_arch
		)
		90
	)
)

(script static void e21_fld_inf1_spawn
	; Is the player in the way of the lower spawner?
	(if (volume_test_objects tv_key_near_lower_spawner (players))
		; He is, so spawn from up top
		(begin
			; Is the other one on the upper left side?
			(if (volume_test_objects tv_key_upper_left_side (players))
				; He is, spawn from the opposite side
				(begin
					(ai_place e21_fld_inf1_2 1)
					(ai_migrate e21_fld_inf1_2 e21_fld_inf1_0)
					(sleep 5)
					(ai_magically_see_object e21_fld_inf1_0 (player0))
					(ai_magically_see_object e21_fld_inf1_0 (player1))
				)
				
				; He is not, spawn from that side
				(begin
					(ai_place e21_fld_inf0_2 1)
					(cs_run_command_script e21_fld_inf0_2 cs_e21_fld_inf1_high_entry)
					(ai_migrate e21_fld_inf0_2 e21_fld_inf1_0)
					(sleep 5)
					(ai_magically_see_object e21_fld_inf1_0 (player0))
					(ai_magically_see_object e21_fld_inf1_0 (player1))
				)
			)
		)
		
		; He is not, so spawn from down low
		(begin
			(ai_place e21_fld_inf1_1 1)
			(ai_migrate e21_fld_inf1_1 e21_fld_inf1_0)
			(sleep 5)
			(ai_magically_see_object e21_fld_inf1_0 (player0))
			(ai_magically_see_object e21_fld_inf1_0 (player1))
		)
	)
)

(script dormant e21_fld_inf1_main
	; Migrate everyone over
	(ai_migrate e21_fld_inf0 e21_fld_inf1_0)
	
	; Respawner
	(sleep_until
		(begin
			; Replenish the combat forms
			(if (< (ai_nonswarm_count e21_fld_inf1_0) 8)
				; Respawn them
				(sleep_until
					(begin
						(e21_fld_inf1_spawn)
						
						; Until there are enough or the ride is over
						(or
							(>= (ai_nonswarm_count e21_fld_inf1_0) 8)
							g_key_lock1_second_arch
						)
					)
					60
				)
			)
			
			; Loop until the shaft
			g_key_lock1_second_arch
		)
		900
	)
)

(script dormant e21_fld_carriers0_main
	; Wait for that initial group to load on board
	(sleep_until (= (structure_bsp_index) 4))

	; Respawner
	(sleep_until
		(begin			
			; Replenish the carrier forms
			(if (< (ai_nonswarm_count e21_fld_carriers0) 2)
				; Respawn one
				(ai_place e21_fld_carriers0 1)
			)
		
			; Loop until the shaft
			g_key_shaft_rising
		)
		90
	)
	
	; Switch sides
	(wake e21_fld_carriers1_main)
)

(script static void e21_fld_inf0_spawn
	; Is the player in the way of the lower spawner?
	(if (volume_test_objects tv_key_near_lower_spawner (players))
		; He is, so spawn from up top
		(begin
			; Is the other one on the upper left side?
			(if (volume_test_objects tv_key_upper_left_side (players))
				; He is, spawn from the opposite side
				(begin
					(ai_place e21_fld_inf1_2 1)
					(cs_run_command_script e21_fld_inf1_2 cs_e21_fld_inf0_high_entry)
					(ai_migrate e21_fld_inf1_2 e21_fld_inf0_0)
					(sleep 5)
					(ai_magically_see_object e21_fld_inf0_0 (player0))
					(ai_magically_see_object e21_fld_inf0_0 (player1))
				)
				
				; He is not, spawn from that side
				(begin
					(ai_place e21_fld_inf0_2 1)
					(ai_migrate e21_fld_inf0_2 e21_fld_inf0_0)
					(sleep 5)
					(ai_magically_see_object e21_fld_inf0_0 (player0))
					(ai_magically_see_object e21_fld_inf0_0 (player1))
				)
			)
		)
		
		; He is not, so spawn from down low
		(begin
			(ai_place e21_fld_inf0_1 1)
			(ai_migrate e21_fld_inf0_1 e21_fld_inf0_0)
			(sleep 5)
			(ai_magically_see_object e21_fld_inf0_0 (player0))
			(ai_magically_see_object e21_fld_inf0_0 (player1))
		)
	)
)

(script dormant e21_fld_inf0_main
	(ai_place e21_fld_inf0_0)

	; Wait for that initial group to load on board
	(sleep_until (= (structure_bsp_index) 4))

	; Initial spawn
	(sleep_until
		(begin
			(e21_fld_inf0_spawn)
			
			; Until there are enough or the ride is over
			(or
				(>= (ai_nonswarm_count e21_fld_inf0_0) 8)
				g_key_shaft_rising
			)
		)
	)

	; Respawner
	(sleep_until
		(begin
			; Replenish the combat forms
			(if (< (ai_nonswarm_count e21_fld_inf0_0) 8)
				; Respawn them
				(sleep_until
					(begin
						(e21_fld_inf0_spawn)
						
						; Until there are enough or the ride is over
						(or
							(>= (ai_nonswarm_count e21_fld_inf0_0) 8)
							g_key_shaft_rising
						)
					)
					60
				)
			)
					
			; Loop until the shaft
			g_key_shaft_rising
		)
		900
	)
	
	; Switch sides
	(wake e21_fld_inf1_main)
)

(script dormant e21_cov_inf0_main
	; Place the Elites
	(ai_place e21_cov_inf0)
	
	; Play the scene
	(sleep 150)
	(sleep_until
		(ai_scene e21_scene0 cs_e21_scene0 e21_cov_inf0_1)
		5
		60
	)
	
	; Play the next scene
	(sleep 300)
	(sleep_until
		(ai_scene e21_scene1 cs_e21_scene1 e21_cov_inf0_0)
		5
		60
	)
	
	; Wait for that initial group to load on board
	(sleep_until g_key_lock0_first_loadpoint 5)
	(game_save)

	; Set the orders
	(ai_set_orders e21_cov_inf0_0 e21_cov_inf0_0_guard_left)
	(ai_set_orders e21_cov_inf0_1 e21_cov_inf0_1_advance_left)
	
	; Wait for the shaft
	(sleep_until g_key_shaft_rising)

	; Set the orders
	(ai_set_orders e21_cov_inf0_0 e21_cov_inf0_0_guard_right)
	(ai_set_orders e21_cov_inf0_1 e21_cov_inf0_1_advance_right)			
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e21_main
	(sleep_until g_key_started 5)
	(data_mine_set_mission_segment enc_e21)
	(set g_e21_started true)
	(print "e21_main")
	
	; Wake subsequent scripts
	(wake e22_main)

	; Wake control scripts
	(wake e21_cov_inf0_main)
	(wake e21_fld_inf0_main)
;	(wake e21_fld_carriers0_main)
	
	(wake sc_outer_wall) ; pbertone: dialogue 
)

(script static void test_key_ride
	(switch_bsp_by_name sen_hq_bsp_5)
	(sleep 1)
	(object_teleport (player0) key_ent0)
	(object_set_velocity (player0) 5 0 0)
	(object_teleport (player1) key_ent1)
	(object_set_velocity (player1) 5 0 0)
	(wake key_main)
	(wake key_ride_human_key_main)
	(wake key_ride_tartarus_main)
	(wake e21_main)
)


;*= KEY RIDE CINEMATIC ====================================================================

(script dormant cinematic_key_boarding
	(sleep_until (volume_test_objects tv_cutscene_key_boarding (players)) 10)

	; Run the cinematic
	(object_teleport (player0) key_ride_a)
	(object_set_velocity (player0) 10 0 0)
	(object_teleport (player1) key_ride_b)
	(object_set_velocity (player1) 10 0 0)

	; Once it's done, wake subsequent encounters
	(wake key_main)
	(wake key_ride_human_key_main)
	(wake key_ride_tartarus_main)
	(wake e21_main)
)
*;

;= ENCOUNTER 20 ==========================================================================
;*
A vigorous flood defense of the key.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e20_cov_inf0 - The sum of all prior squads, just dump them here
		(init) - Positions at the first intersection
		(advance0) - Positions at the second intersection

Flood
	e20_fld_infs0 - Infection forms milling through the environment, fleeing

Open Issues



;- Globals ---------------------------------------------------------------------

(global boolean g_e20_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e20_cov_inf0_main
	; FILL THIS WITH MIGRATION COMMANDS
	(sleep 1)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e20_main
	(set g_e20_started true)
	(print "e20_main")
	(game_save)
	
	; Wake subsequent scripts

	; Wake control scripts
	(wake e20_cov_inf0_main)
	
	; Shut down
	(sleep_until (volume_test_objects tv_cutscene_key_boarding (players)) 10)
	(sleep_forever e20_cov_inf0_main)
	
	; Start the cutscene
	
	; Clean up
	(sleep 15)
	(ai_erase e20_cov)
	(ai_erase e20_fld)
)

(script static void test_key_dock
	(switch_bsp_by_name sen_hq_bsp_5)
	(sleep 1)
	(object_teleport (player0) e20_test)
	(ai_place e20_cov_inf0)
	(if (not g_e20_started) (wake e20_main))
)
*;
;= KEYRIDE MAIN ==========================================================================

(script dormant begin_key_ride_main
	; MIGRATE SQUADS HERE
	; Add (ai_migrate <your_squad> e20_cov_inf0) statements
	
	
	; Wake the encounters
	(wake e21_main)
	(wake key_main)
	(wake key_ride_human_key_main)
	(wake key_ride_tartarus_main)
;	(wake cinematic_key_boarding)
)

;= MISSION MAIN ==========================================================================
;=========== ENCOUNTER SCRIPTS ==========
(script dormant enc_cov_charge
		(data_mine_set_mission_segment enc_cov_charge)
		(print "initialize covenant charge scripts")
		(game_save)
		
		(object_dynamic_simulation_disable qz_cov_def_tower_pod_a true)
		(object_dynamic_simulation_disable qz_cov_def_tower_pod_b true)
		
		(ai_place qz_cov_def_phantom)
		(ai_place qz_cov_def_spectre)
		(ai_place qz_cov_def_ghosts)
		(ai_place qz_cov_def_spec_ops)
		
		(wake sc_cov_charge)
	
	(sleep_until (or
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_d" (players))
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_p_l" (players))
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_p_r" (players))
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_spectre/spectre) "spectre_g" (players))
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_ghosts/a) "ghost_d" (players))
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location qz_cov_def_ghosts/b) "ghost_d" (players))
			   ) 10 (* 30 20))
		(set g_qz_cov_def_progress 1)
		
		(sleep 30)
		(game_save_no_timeout)
		(sleep 90)
		
		(ai_place qz_cov_def_enforcer_a)
		(ai_place qz_cov_def_sen_elim)
	;	(if (difficulty_legendary) (ai_place qz_cov_def_enforcer_b) (ai_set_orders qz_cov_def_enforcer_a qz_cov_def_mid))
		(device_set_position qz_door_a 1)
		(sleep (* 30 2))
		(wake ext_a_vehicle_orders)
	
	(sleep_until (<= (ai_living_count sentinels) 0))
		(sleep 30)
		(game_save)
		(ai_renew covenant)
)

(script dormant enc_vehicle_int
	(data_mine_set_mission_segment enc_vehicle_int)
	(print "initialize vehicle interior scripts")
	(game_save)
	(ai_renew covenant)

		(ai_disposable cov_def_sentinels true)
		(ai_disposable cov_def_enf true)
	
		(set g_veh_int_migrate_a 1)
		(set g_music_06b_01 1)
	
		(wake music_06b_01)
		(wake sc_qz_veh_int)
	
		(ai_place veh_int_enf_a) ; 1 
		(ai_place veh_int_enf_b) ; 1 
		(ai_place veh_int_enf_d) ; 1 
		(ai_place veh_int_sen_elim_ini)  ; 2 
		(ai_place veh_int_scorpion) ; 0 
		(ai_place veh_int_flood_ghosts_ini) ; 2 
		(ai_place veh_int_wraith/wraith)
;		(ai_place veh_int_turrets)
		(ai_place veh_int_hog_ab) ; 0 
		(ai_place veh_int_ghost_ab) ;0 
		(sleep 15)
	
		(device_operates_automatically_set veh_int_door_a 1)

	(sleep_until (volume_test_objects tv_veh_int_b (players)))
		(game_save)
		(ai_renew covenant)
	
		(set g_veh_int_migrate_b 1)
		
		(wake ai_veh_int_ghost_spawn)
		
		(ai_place veh_int_sen_elim_rt) ; 2 
		(ai_place veh_int_sen_elim_lt) ; 2 
		(ai_magically_see veh_int_wraith veh_int_sen)
		(ai_place veh_int_flood_bk/runner)
	
		(sleep_until (volume_test_objects tv_veh_int_c (players)))
		(data_mine_set_mission_segment enc_vehicle_int_bk)
		(game_save)
		
		(set g_veh_int_migrate_c 1)
	
		(wake sc_factory_approach)	
	
		(ai_renew covenant)
		(ai_place veh_int_wraith/driver) ; 1 

	(sleep_until (volume_test_objects tv_veh_int_d (players)))
;		(device_set_position veh_int_door_b 1)
	
		(set g_veh_int_migrate_d true)
		(set g_veh_int_ghost_spawn 1) ; turn off the ghost spawner 
	
		(ai_place veh_int_flood_hog_bk) ; 1 
)

(script dormant enc_qz_ext_a
		(data_mine_set_mission_segment enc_qz_ext_a_dam)
		(print "initialize quarantine zone exterior A scripts")
		(game_save)
		(ai_renew covenant)
	
		(ai_disposable veh_int_flood true)
		(ai_disposable veh_int_sen true)
	
		(set g_veh_int_migrate_e 1)
		(set g_ext_a_dam_migrate_a 1)
	
		(wake music_06b_02)
		(wake ai_ext_a_dam_enforcers)
		(device_set_position qz_dam_door_a 1)
;		(wake dam_door_a)
;		(wake dam_door_b)
	
		(ai_place qz_ext_a_dam_enf/a)
		(ai_place qz_ext_a_dam_human)
		(ai_place qz_ext_a_dam_sen)
		(ai_place qz_ext_a_dam_sen_elim)
		(ai_place qz_ext_a_dam_flood_ini)
		
		(wake chapter_competition)
		(game_save)
		(ai_renew covenant)

	(sleep_until (volume_test_objects qz_ext_a_dam_b (players)))
	
		(set g_ext_a_dam_migrate_b 1)
	
		(ai_place qz_ext_a_dam_flood_cliff_a)
		(ai_place qz_ext_a_dam_flood_cliff_b)
	
	(sleep_until (volume_test_objects tv_ext_a_a (players)))
;*		(sleep_until	(or
						(> (device_get_position dam_door_a) 0)
						(> (device_get_position dam_door_b) 0)
					)
		)*;
		(data_mine_set_mission_segment enc_qz_ext_a)
		(game_save)
		(ai_renew covenant)
	
		(set g_ext_a_dam_enf 1)
		(set g_ext_a_migrate_a 1)
		
		(ai_disposable ext_a_flood_dam_a true)
		(ai_disposable ext_a_flood_dam_b true)
		(ai_disposable ext_a_sen_dam_a true)
		(ai_disposable ext_a_sen_dam_b true)
	
		(wake ai_qz_ext_a_wraiths)
	
		(ai_place qz_ext_a_enf_a)
		(ai_place qz_ext_a_flood_rocket)
	
		(if (<= (ai_living_count covenant) 1) (begin (wake sc_ext_a) (ai_place qz_ext_a_phantom)))
		(set v_ext_a_phantom (ai_vehicle_get_from_starting_location qz_ext_a_phantom/phantom))


	(sleep_until (volume_test_objects tv_ext_a_b (players)))
;		(game_save)
		(set g_ext_a_migrate_b 1)

	(sleep_until (volume_test_objects tv_ext_a_c (players)))
		(game_save_no_timeout)
		(ai_renew covenant)
	
		(set g_ext_a_migrate_c 1)
	
		(ai_place qz_ext_a_flood_c)
		(ai_place qz_ext_a_flood_c2)
		(ai_place ext_a_flood_ghost_fr)

	(sleep_until (volume_test_objects tv_ext_a_d (players)))
;		(game_save_no_timeout)
	
		(set g_ext_a_migrate_d 1)
	
		(wake ai_qz_ext_a_ghosts)
		(wake ai_qz_ext_a_d_spawn)
	
		(sleep_until (volume_test_objects tv_ext_a_e (players)))
		(game_save)
		(ai_renew covenant)
	
		(set g_ext_a_migrate_e 1)
		(set g_qz_ext_a_d_spawn 0)
	
		(ai_place ext_a_sen_elim_bk)
		(if (<= (ai_living_count qz_ext_a_enf_bk) 0) (ai_place qz_ext_a_enf_bk))

	(sleep_until (volume_test_objects tv_ext_a_ghosts_off (players)))
		(set g_qz_ext_a_flood_ghosts 1)
	
	(sleep_until (volume_test_objects tv_ext_a_f (players)))
		(data_mine_set_mission_segment enc_ext_a_fact_ent)
		(game_save_no_timeout)
		
		(set g_ext_a_migrate_f 1)
		(set g_music_06b_02 1)
	
		(ai_renew covenant)
		
;		(ai_place fact_ent_flood_turrets)
		(ai_place fact_ent_flood_scorpion)
;		(ai_place fact_ent_flood_wraith_a)
		(ai_place fact_ent_flood_wraith_b)
		(wake ai_fact_ent_sen_spawn)
		(wake ai_fact_ent_enf_spawn)
	
	(sleep_until (volume_test_objects tv_ext_a_fact_ent (players)))
		(set g_ext_a_fact_ent_migrate 1)
)

(script dormant enc_crashed_factory
		(data_mine_set_mission_segment enc_crashed_factory_a)
		(game_save)
		(ai_renew covenant)
	
		(ai_disposable ext_a_flood true)
		(ai_disposable ext_a_sen true)
	
		(set g_music_06b_02 0)
		(set g_music_06b_03 1)
		(set g_fact_ent_sen_spawn 1)
	
		(wake music_06b_03)
		(wake sent_factory_1_start)

	(sleep_until (= (volume_test_objects vol_factory_1_exit (players)) TRUE)) 
		(game_save)

	(sleep_until (volume_test_objects tv_gorge (players)))
		(data_mine_set_mission_segment enc_crashed_factory_ext)
		(game_save)
	
		(ai_disposable factory1_enemies true)
	
		(set g_music_06b_03 0)
	
		(ai_set_orders covenant cov_follow_gorge)
		(ai_renew covenant)
	
		(wake ai_gorge)
	
	(sleep_until (volume_test_objects tv_factory2_enter (players)))
		(data_mine_set_mission_segment enc_crashed_factory_b)
		(game_save)
	
		(ai_disposable gorge_enemies true)
	
		(ai_set_orders covenant cov_follow_factory2)
		(ai_renew covenant)
	
		(wake ai_factory2)
)

(script dormant enc_qz_ext_b
		(data_mine_set_mission_segment enc_ext_b_fact_exit)
		(print "initialize quarantine zone exterior B scripts")
		(game_save_no_timeout)
		(ai_renew covenant)
		
		(ai_disposable factory2_enemies true)
	
		(wake music_06b_04)
		(wake sc_factory_exit)
		(wake objective_push_clear)
		(wake objective_link_set)
		(wake ext_b_vehicle_orders)
		
		(ai_place qz_ext_b_fact_scorpion)
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location qz_ext_b_fact_scorpion/scorpion) true)
;		(ai_place qz_ext_b_fact_humans)
		(ai_place qz_ext_b_fact_wraith)
		(ai_place qz_ext_b_fact_ghosts)
		(ai_place qz_ext_b_fact_flood)
		(ai_place qz_ext_b_fact_ghosts_spare)
		(ai_place qz_ext_b_enf_a)
		
	(sleep_until (volume_test_objects tv_ext_b_fact_mid (players)))
		(game_save)
		(if (random_range 0 2) (ai_place qz_ext_b_fact_warthog) (ai_place qz_ext_b_fact_ghost_bk))

	(sleep_until	(or
					(and 
						(<= (ai_living_count ext_b_flood_a) 0)
						(<= (ai_living_count ext_b_sentinels_a) 0)
					)
					(volume_test_objects tv_ext_b_gate (players))
				)
	5)
		(data_mine_set_mission_segment enc_qz_ext_b)
		(game_save)
		(ai_renew covenant)
		
		(set g_ext_b_migrate_1 1)	
	
		(wake ai_ext_b_enf_spawn)
	
		(set g_music_06b_04 1)
	
		(ai_place qz_ext_b_cov_phantom)
		(ai_place qz_ext_b_wraith_a)
		(ai_place qz_ext_b_wraith_b)
		(ai_place qz_ext_b_ghosts_a (pin (- 7 (ai_living_count ext_b_flood)) 0 2))
		(ai_place qz_ext_b_warthog)
		(set v_ext_b_phantom (ai_vehicle_get_from_starting_location qz_ext_b_cov_phantom/phantom))
	
	(sleep_until	(or
					(and 
						(<= (ai_living_count ext_b_flood_b) 0)
						(<= (ai_living_count ext_b_sentinels_b) 0)
					)
					(volume_test_objects tv_ext_b_mid (players))
				)
	5)
		(game_save_no_timeout)
		(ai_renew covenant)
	
		(set g_ext_b_migrate_2 1)	
	
		(ai_place qz_ext_b_ghosts_b)
		(ai_place qz_ext_b_warthog_gauss)
		
	(sleep_until (volume_test_objects tv_ext_b_back (players)) 5)
		(data_mine_set_mission_segment enc_qz_ext_b_bk)
		(game_save_no_timeout)
		(ai_renew covenant)
		
		(ai_disposable ext_b_flood true)
		(ai_disposable ext_b_sentinels true)
	
		(set g_ext_b_migrate_3 1)	
		(set g_ext_b_enforcer 1)
	
		(wake ai_constructor_flock)
		(wake ai_ext_b_bk_ghost_spawn)
	
		(ai_place qz_ext_b_ent_enf)
		(ai_place qz_ext_b_ent_scorpion)
		(ai_place qz_ext_b_ent_wraith_a)
;		(ai_place qz_ext_b_ent_cov_phantom)
	
	(sleep_until (volume_test_objects tv_ext_b_exit (players)) 5)
		(data_mine_set_mission_segment enc_qz_ext_b_exit)
		(game_save)
		(ai_renew covenant)
	
		(set g_ext_b_bk_ghost_spawn 1)
		(set g_ext_b_migrate_4 1)
	
		(wake ai_ext_b_exit_tube_a)
		(wake ai_ext_b_exit_tube_b)
	
		(ai_place qz_ext_b_ent_turrets)
	
	(sleep_until	(or
					(and
						(<= (ai_living_count ext_b_flood_d) 0)
						(<= (ai_living_count ext_b_sentinels_d) 0)
					)
					(volume_test_objects tv_ext_b_exit_door (players))
				)
	5)
		(game_save_no_timeout)
		(ai_renew covenant)
	
		(set g_ext_b_migrate_5 1)
	
		(ai_place qz_ext_b_ent_flood_bk (pin (- 8 (ai_nonswarm_count ext_b_flood)) 0 6))
)

(script dormant enc_key_ride
		(print "initialize key ride scripts")
	;	(game_save)
		(ai_renew covenant)
		
		(wake music_06b_05)
		(wake music_06b_06)
		(wake music_06b_07)
	
	(sleep_until (volume_test_objects tv_key_ride_cinematic (players)))
		(cinematic_fade_to_white)
		(ai_erase_all)
		(object_teleport (player0) key_ride_a)
		(object_teleport (player1) key_ride_b)
		(sleep 5)
	
		(if (= g_play_cinematics 1)
			(begin
				(if (cinematic_skip_start)
					(begin
						(print "c06_intra2")
						(c06_intra2)
					)
				)
				(cinematic_skip_stop)
			)
		)
	
		(wake begin_key_ride_main)
	
		(sleep 25)
		(game_save_immediate)
	
		(wake chapter_gallery)
		(wake objective_link_clear)
		(wake objective_retrieve_set)
		(ai_renew covenant)
		
		(camera_control off)
		(sleep 1)
		(cache_block_for_one_frame)
		(sleep 1)
		(cinematic_fade_from_white)
)

(script dormant enc_library
	(print "initialize library scripts")
	(game_save)

	(game_save)
	(ai_renew covenant)
)


	
;===========================================================================================================
;============= STARTUP SCRIPT ==============================================================================
;===========================================================================================================

(script dormant mission_floodzone
	(cinematic_snap_to_white)
	(switch_bsp 0)
	(if (= g_play_cinematics 1)
		(begin
			(if (cinematic_skip_start)
				(begin
					(print "c06_intra1")
					(c06_intra1)
				)
			)
			(cinematic_skip_stop)
		)
	)

	(sleep 2)
	
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)

	(wake enc_cov_charge)
	(if (difficulty_legendary) (wake ice_cream_superman))

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white_bars)
	(wake chapter_mirror)
	(wake objective_push_set)

	(sleep_until (volume_test_objects tv_vehicle_int (players)))
	(wake enc_vehicle_int)
	
	(sleep_until (volume_test_objects tv_qz_ext_a (players)))
	(wake enc_qz_ext_a)
	
	(sleep_until (volume_test_objects tv_factory (players)))
	(wake enc_crashed_factory)
	
	(sleep_until (volume_test_objects tv_qz_ext_b (players)))
	(wake enc_qz_ext_b)

	(sleep_until (volume_test_objects tv_key_ride (players)))
	(wake enc_key_ride)
	
	; TODO: Paul should change this to test g_e26_ended, like this:
;	(sleep_until g_e26_ended)
	(sleep_until (volume_test_objects tv_x07 (players))) ; 9/18 
;*	(sleep_until
		(or
			g_e26_ended
			(volume_test_objects tv_x07 (players))
		)
	5)
*;
	(cinematic_fade_to_white)
	(ai_erase_all)
	
	(object_teleport (player0) player0_end)
	(object_teleport (player1) player1_end)
	
	(if (cinematic_skip_start)
		(begin
			(print "x07")
			(x07)			
		)
	)
	(cinematic_skip_stop)
	
	(playtest_mission)
	
	(game_won)

)

(script static void start
	(wake mission_floodzone)
)

(script startup mission_main

	; Necessary startup stuff
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance prophet player)
	(ai_allegiance player prophet)
	(ai_allegiance covenant prophet)
	(ai_allegiance prophet covenant)

	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0 ) (start))
)

(script static void test
	(set g_play_cinematics 0)
	(device_set_position qz_door_a 1)
	(device_set_position veh_int_door_a 1)
	(device_set_position veh_int_door_b 1)
	(device_set_position qz_dam_door_a 1)
	
	(ai_place qz_cov_def_spectre)
	(ai_place qz_cov_def_ghosts)
	(ai_place qz_cov_def_spec_ops)

	(wake ext_a_vehicle_orders)
	(wake dam_door_a)
	(wake dam_door_b)
	
	(sleep 90)
	
	(set g_qz_cov_def_progress 1)
)


(script static void test_ext_a_phantom
	(ai_place qz_ext_a_phantom)
	(set v_ext_a_phantom (ai_vehicle_get_from_starting_location qz_ext_a_phantom/phantom))
)
(script static void test_ext_b_phantom
	(ai_place qz_ext_b_cov_phantom)
;	(ai_place qz_ext_b_wraith_a)
	(set v_ext_b_phantom (ai_vehicle_get_from_starting_location qz_ext_b_cov_phantom/phantom))
)
