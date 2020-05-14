
; TODO remove these, migrated from atlas' globals.hsc
(global boolean debug false)
(global boolean debug_bonus_round false)
(global boolean alpha_sync_slayer false)

; TODO remove this too (I think?)
(global ai gr_survival_phantom none)


;=============================================================================================================================
;================================================== GLOBALS ==================================================================
;=============================================================================================================================


; The new world squad wave spawn group
(global ai ai_sur_wave_spawns none)

; The remainders squad that survivors get piled into after each wave
(global ai ai_sur_remaining none)

; The squads into which fireteam members are absorbed
(global ai ai_sur_fireteam_squad0 none)
(global ai ai_sur_fireteam_squad1 none)
(global ai ai_sur_fireteam_squad2 none)
(global ai ai_sur_fireteam_squad3 none)
(global ai ai_sur_fireteam_squad4 none)
(global ai ai_sur_fireteam_squad5 none)

; The objectives used by the firefight script
(global ai ai_obj_survival none)

; The number of squads to spawn in a wave, overridden per scenario
(global short s_sur_wave_squad_count 4)

; Bonus round squad
(global ai ai_sur_bonus_wave none)

; Generator defense objects
(global device_name obj_sur_generator0 generator0)
(global device_name obj_sur_generator1 generator1)
(global device_name obj_sur_generator2 generator2)
(global device_name obj_sur_generator_switch0 generator_switch0)
(global device_name obj_sur_generator_switch1 generator_switch1)
(global device_name obj_sur_generator_switch2 generator_switch2)
(global device_name obj_sur_generator_switch_cool0 generator_switch_cool0)
(global device_name obj_sur_generator_switch_cool1 generator_switch_cool1)
(global device_name obj_sur_generator_switch_cool2 generator_switch_cool2)
(global device_name obj_sur_generator_switch_dis0 generator_switch_disabled0)
(global device_name obj_sur_generator_switch_dis1 generator_switch_disabled1)
(global device_name obj_sur_generator_switch_dis2 generator_switch_disabled2)

; Ammo crate object
(global object_name obj_ammo_crate0 ammo_crate0)
(global object_name obj_ammo_crate1 ammo_crate1)

; sets how many ai can be alive before the next wave will spawn 
(global short k_sur_ai_rand_limit 0)
(global short k_sur_ai_end_limit 0)
(global short k_sur_ai_final_limit 0)

; controls the spawning of squads per wave 
(global short k_sur_squad_per_wave_limit 6)
(global short s_sur_squad_count 0)
(global boolean b_sur_squad_spawn TRUE)

; controls the number of waves per round 
(global short k_sur_rand_wave_count 0)
(global short k_sur_rand_wave_limit 0)
(global boolean b_sur_rand_wave_spawn TRUE)
(global short s_sq_actor_count 0)
(global boolean b_sur_wave_phantom FALSE)

; controls the number of rounds per set 
(global short k_sur_wave_per_round_limit 5)
(global short k_sur_round_per_set_limit 3)

; These timers are generally cumulative
(global short k_sur_wave_timer 180)		; Delay following every wave
(global short k_sur_round_timer 150)	; Delay following every round
(global short k_sur_set_timer 300)		; Delay following every set
(global short k_sur_bonus_timer 150)	; Delay following every bonus round
(global short k_sur_wave_timeout 0)		; Not used

; Whether the Phantoms use full or semi-random order
; Semi-random is where 0+1 or 2+3 are selected together in sets
(global boolean b_sur_phantoms_semi_random false)

; What sort of dropship to use
; 0 - No dropships (overrides variant settings)
; 1 - Phantoms
; 2 - Spirits
(global short s_sur_dropship_type 1)
(global short s_sur_dropship_crew_count 2) ; How many AI are in the dropship crews

; Dropships. These can be Phantoms or Spirits depending on scenario settings, but are named "phantom" for legacy support purposes.
(global vehicle v_sur_phantom_01 NONE)
(global vehicle v_sur_phantom_02 NONE)
(global vehicle v_sur_phantom_03 NONE)
(global vehicle v_sur_phantom_04 NONE)
(global vehicle v_sur_bonus_phantom NONE)

; phantom squad definitions 
(global ai ai_sur_phantom_01 NONE)
(global ai ai_sur_phantom_02 NONE)
(global ai ai_sur_phantom_03 NONE)
(global ai ai_sur_phantom_04 NONE)
(global ai ai_sur_bonus_phantom NONE)

; define how the phantoms are loaded 
(global string s_sur_drop_side_01 "dual")
(global string s_sur_drop_side_02 "dual")
(global string s_sur_drop_side_03 "dual")
(global string s_sur_drop_side_04 "dual")
(global string s_sur_drop_side_bonus "dual")

; dropship spawn logic controls. Actually applies to spirits too
(global boolean b_phantom_spawn TRUE)
(global short b_phantom_spawn_count 0)
(global short k_phantom_spawn_limit 2)

; The number of waves completed NOT COUNTING BONUS WAVE
; Used to determine when the game should end due to completion
(global short s_survival_wave_complete_count 0)

; Has a human player ever spawned?
(global boolean b_survival_human_spawned false)

; Score attack parameters
(global long survival_mode_score_silver 50000)
(global long survival_mode_score_gold 200000)
(global long survival_mode_score_onyx 1000000)
(global long survival_mode_score_mm 15000)


;=============================================================================================================================
;============================================ SURVIVAL CONSTANTS =============================================================
;=============================================================================================================================


; number of ai left before the next wave will spawn 
(script static void survival_ai_limit
	(cond
		((difficulty_legendary)			
										(begin
											(set k_sur_ai_rand_limit 3)
											(set k_sur_ai_final_limit 3)
											(set k_sur_ai_end_limit 0)
										)
		)
		((difficulty_heroic)						
										(begin
											(set k_sur_ai_rand_limit 3)
											(set k_sur_ai_final_limit 3)
											(set k_sur_ai_end_limit 0)
										)
		)
		(TRUE						
										(begin
											(set k_sur_ai_rand_limit 3)
											(set k_sur_ai_final_limit 3)
											(set k_sur_ai_end_limit 0)
										)
		)
	)
)

; setting the timer between waves based on difficulty 
(script static void survival_ai_timeout
	(cond
		((difficulty_legendary)		(set k_sur_wave_timeout (* 30 10)))
		((difficulty_heroic)		(set k_sur_wave_timeout (* 30 20)))
		(TRUE						(set k_sur_wave_timeout (* 30 30)))
	)
)

; setting the timer between waves based on difficulty 
(script static void survival_wave_timer
	(cond
		((difficulty_legendary)		(set k_sur_wave_timer (* 30 3)))
		((difficulty_heroic)		(set k_sur_wave_timer (* 30 6)))
		(TRUE						(set k_sur_wave_timer (* 30 9)))
	)
)

; setting the timer between rounds based on difficulty 
(script static void survival_round_timer
	(cond
		((difficulty_legendary)		(set k_sur_round_timer (* 30 5)))
		((difficulty_heroic)		(set k_sur_round_timer (* 30 10)))
		(TRUE						(set k_sur_round_timer (* 30 15)))
	)
)

; setting the timer between set based on difficulty 
(script static void survival_set_timer
	(cond
		((difficulty_legendary)		(set k_sur_set_timer (* 30 10)))
		((difficulty_heroic)		(set k_sur_set_timer (* 30 20)))
		(TRUE						(set k_sur_set_timer (* 30 30)))
	)
)

; setting the timer between end of set and bonus round start 
(script static void survival_bonus_wait_timer
	(cond
		((difficulty_legendary)		(set k_sur_bonus_timer (* 30 5)))
		((difficulty_heroic)		(set k_sur_bonus_timer (* 30 10)))
		(TRUE						(set k_sur_bonus_timer (* 30 15)))
	)
)


;=============================================================================================================================
;============================================ SURVIVAL SCRIPTS ===============================================================
;=============================================================================================================================


(script dormant survival_license_plate
	(if (> (survival_mode_generator_count) 0)
		(begin
			(survival_mode_set_elite_license_plate 37 29 sur_game_name sur_cov_gen_desc elite_icon)
			(survival_mode_set_spartan_license_plate 37 28 sur_game_name sur_unsc_gen_desc spartan_icon)
		)
		(begin
			(survival_mode_set_elite_license_plate 37 29 sur_game_name sur_cov_game_desc elite_icon)
			(survival_mode_set_spartan_license_plate 37 28 sur_game_name sur_unsc_game_desc spartan_icon)
		)
	)
)


; MAIN SURVIVAL MODE SCRIPT 
(script dormant survival_mode
	(wake survival_human_player_has_spawned)

	; Set allegiances
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant covenant_player)
	(ai_allegiance covenant_player covenant)

	; Set loadouts
	(player_set_spartan_loadout (human_player_in_game_get 0))
	(player_set_spartan_loadout (human_player_in_game_get 1))
	(player_set_spartan_loadout (human_player_in_game_get 2))
	(player_set_spartan_loadout (human_player_in_game_get 3))
	(player_set_spartan_loadout (human_player_in_game_get 4))
	(player_set_spartan_loadout (human_player_in_game_get 5))
	(player_set_elite_loadout (elite_player_in_game_get 0))
	(player_set_elite_loadout (elite_player_in_game_get 1))
	(player_set_elite_loadout (elite_player_in_game_get 2))
	(player_set_elite_loadout (elite_player_in_game_get 3))
	(player_set_elite_loadout (elite_player_in_game_get 4))
	(player_set_elite_loadout (elite_player_in_game_get 5))
	
	; start survival music 
	(if (not alpha_sync_slayer) (sound_looping_start m_survival_start NONE 1))
	
	; set initial limits based on difficulty level 
	(survival_ai_limit)
;	(survival_wave_timer)
;	(survival_round_timer)
;	(survival_set_timer)
;	(survival_bonus_wait_timer)
;	(survival_ai_timeout)
	(survival_lives)
	
	; Create the ammo crate
	(wake survival_ammo_crate_create)
	
	; Activate Generator Defense
	(if (> (survival_mode_generator_count) 0)
		(wake survival_mode_generator_defense)
	)
	
	; initial weapon drop (unannounced) 
	(object_create_folder_anew folder_survival_scenery)
	(object_create_folder_anew folder_survival_crates)
	(object_create_folder_anew folder_survival_vehicles)
	(object_create_folder_anew folder_survival_equipment)
	
	; Blink
	(sleep 1)
	
	; Garbage collect, in case anything is left over from previous rounds (sob)
	(garbage_collect_now)

	; fade to gameplay  
	(sleep (* 30 3))
	(if (> (player_count) 0) (cinematic_snap_from_black))
	
	; Delta hack
	(wake survival_license_plate)

	; announce survival mode 
	(sleep (* 30 1))
	(event_welcome)
	(sleep (* 30 2))
	(event_intro)

	; wake secondary scripts 
	(wake survival_lives_announcement)
	(wake survival_award_achievement)
	(wake survival_bonus_round_end)
	(wake survival_end_game)
	(wake survival_elite_manager)
	(wake survival_ammo_crate_waypoint)
	(wake survival_bonus_round_dropship)
	(wake survival_score_attack)
	(wake survival_score_attack_mm)
	(wake survival_health_pack_hud)
	(if alpha_sync_slayer (wake survival_slayer_medpack_respawner))
	
	; begin delay timer 
	(sleep (* 30 3))
	
	; Send in a weapon drop
	(if (survival_mode_weapon_drops_enable)
		(begin
			;(event_survival_awarded_weapon) ; Suppress initial incident
			(set b_survival_mode_weapon_drop TRUE)
		)
	)	

	; stop opening music 
	(if (not alpha_sync_slayer) (sound_looping_stop m_survival_start))
	
	; Start up the dead player timer
	(wake survival_all_dead_timer)
				
	; If we're not in sync slayer, begin the main loop
	(if (not alpha_sync_slayer)
		(sleep_until
			(begin			
				(if debug (print "beginning new set"))
				(survival_mode_begin_new_set)
				(sleep 1)
	
				; announce new set 
				(survival_begin_announcer) ; TODO rewrite this so that it isn't responsible for anything except announcements
					
				; BEGIN WAVE LOOP
				; At this point we are at the BEGINNING OF A SET, WAVE 1
				
					(if debug_bonus_round
						(survival_bonus_wave_test)
						(survival_wave_loop)
					)
	
				; END WAVE LOOP
				; At this point we are at the END OF A SET, AFTER BONUS WAVE COMPLETE
				
				; respawn weapon objects 
				(survival_respawn_weapons)
				
				; replenish player stamina / vitality 
				(survival_mode_replenish_players)
							
				; allow announcer to vocalize new set 
				(set b_survival_new_set TRUE) ; TODO remove/retool
	
				; sleep for set amount of time 
				(sleep k_sur_set_timer)
		
				; Set loop, runs forever
				; Game over conditions are handled in survival_end_game
				FALSE
			)	
			1
		)
	)
)


(script dormant survival_slayer_medpack_respawner
	(sleep_until
		(begin
			(sleep 1800)
			(object_create_folder folder_survival_devices)
			
			false
		)
	)
)


(script dormant survival_human_player_has_spawned
	(sleep_until (> (players_human_living_count) 0))
	(set b_survival_human_spawned true)
)


;============================================ ROUND SPAWNER ===============================================================

;*
So, the engine knows this:
- What set it is
- What wave it is within that set
- Whether that wave is an Initial, Primary, Boss, or Bonus wave
- For any given wave, what wave template it should use (ie. it handles the randomness)

It is always the case that:
- The wave order is (INITIAL, PRIMARY, PRIMARY, PRIMARY, BOSS)x3, BONUS
- The old Round rewards are granted after a BOSS wave is cleared
- The Bonus rewards are granted after a BONUS wave is cleared

The jurisdiction of this script ends after the bonus wave is complete.
*;


(script static void survival_wave_loop

	; reset wave number 
	(if debug (print "resetting wave variables..."))
	(set b_sur_rand_wave_spawn TRUE)
	(set k_sur_rand_wave_count 0)

	; Wave repeat loop
	(sleep_until
		(begin
			; Advance the wave
			(survival_mode_begin_new_wave)
			
			; Is this an initial wave?
			(if (survival_mode_current_wave_is_initial)
				(begin
					; Initialize the round
					(surival_set_music)
					
					; Announce new round
					(survival_begin_announcer) ; TODO rewrite or replace
					(sleep 1)
						
					; Respawn crates on every set but the first
					(if (> (survival_mode_set_get) 1) (survival_respawn_crates))
				)
			)
			
			; At this point, the current wave is SET UP AND READY TO SPAWN.
			(survival_wave_spawn) ; Blocks while running the wave.
			; At this point the wave has spawned and been defeated.
			
			; Increment the wave complete count for game over condition
			(set s_survival_wave_complete_count (+ s_survival_wave_complete_count 1))
			
			; Kill this loop if we're past the end condition count
			; Prevents more loop business from happening
			(if 
				(and
					(> (survival_mode_get_set_count) 0)
					(>= s_survival_wave_complete_count (survival_mode_get_set_count))	
				)
				(begin
					(sleep_forever)
				)
			)
		
			; Completed an initial wave?
			(if (survival_mode_current_wave_is_initial)
				(begin
					; TODO put the real stuff here
					(print "completed an initial wave")
				)
			)
		
			; Completed a boss wave?
			(if (survival_mode_current_wave_is_boss)
				(begin
					; Allow announcer to vocalize new round 
					(set b_survival_new_round TRUE) ; TODO decide if we need this

					; Cleanup any unmanned vehicles 
					(survival_vehicle_cleanup)
					
					;tysongr - 53951: Moving the bonus lives awarded to the end of the set, in the bonus round
					(survival_add_lives)

					; Replenish player stamina / vitality 
					(survival_mode_replenish_players) 
					
					; If this isn't the last boss wave in the round,
					(if (< (survival_mode_round_get) 2)	
						(begin
							(survival_respawn_weapons)
							(sleep k_sur_round_timer)
						)
					)
				)
			)
			
			; Condition: stop looping after 3 rounds
			(and
				(>= (survival_mode_round_get) 2) ; Zero indexed
				(>= (survival_mode_wave_get) 4) ; Zero indexed
			)
		)
		1
	)
	
	; Bonus wave
	(sleep k_sur_bonus_timer)
	(survival_bonus_round)
	
	; Kill this loop if we're past the end condition count
	; Prevents more loop business from happening
	(if 
		(and
			(> (survival_mode_get_set_count) 0)
			(>= s_survival_wave_complete_count (survival_mode_get_set_count))	
		)
		(begin
			(sleep_forever)
		)
	)
	
	;tysongr - 53951: Moving the bonus lives awarded to the end of the set
	; Add additional lives
	(survival_add_lives)
)

(script static void survival_bonus_wave_test
	(print "survival_bonus_wave_test")
	
	; Round 1
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	
	; Round 2
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	
	; Round 3
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	(survival_mode_begin_new_wave) (sleep 1)
	
	; Catch up the count
	(set s_survival_wave_complete_count (+ s_survival_wave_complete_count 15))

	; Bonus
	(survival_bonus_round)
)


; In it's own thread
(script continuous survival_garbage_collector
	(sleep_forever)
	(add_recycling_volume_by_type tv_sur_garbage_all 4 20 16371)
	(sleep (* 30 20))
	(add_recycling_volume_by_type tv_sur_garbage_weapon 30 10 12)
)


; Setup and spawn a wave, then babysit it until it ends
(script static void survival_wave_spawn

	(if debug (print "spawn wave..."))
	
	; Begin music loop
	(survival_mode_wave_music_start)
	
	; Cleanup
	;(add_recycling_volume tv_sur_garbage_all 30 10)
	(wake survival_garbage_collector)
	
	; Temporarily disable fireteam absorbers. This will disable it for 3 seconds then reenable it in a separate thread.
;	(wake survival_elite_fireteams)
	
	; Announce new wave
	(survival_begin_announcer) ; TODO rewrite/replace
	(sleep 5)
	
	; Reset survival objective 
	(ai_reset_objective ai_obj_survival)

	; If this is a dropship wave, handle that side of things
	(if (wave_dropship_enabled) (survival_dropship_spawner))
		
	; Place the wave template, in limbo if dropships are enabled
	(if (wave_dropship_enabled)
		(ai_place_wave_in_limbo (survival_mode_get_wave_squad) ai_sur_wave_spawns s_sur_wave_squad_count)
		(ai_place_wave (survival_mode_get_wave_squad) ai_sur_wave_spawns s_sur_wave_squad_count)
	)
	(sleep 1)
	
	; Bedlam?
	(if (survival_mode_bedlam)
		; Bedlam
		(survival_mode_set_bedlam_teams)
	)
	
	; Load the dropships as appropriate
	(if (wave_dropship_enabled) (survival_dropship_loader))
	
	; Allow the dropships to move 
	(set b_phantom_move_out TRUE)
		
	; Sleep until dropships have dropped off their squads
	(sleep 30) ; This is to make sure the dropships have had a chance to be loaded before the sleep below

	; This pause is no longer necessary with the changes to how survival_wave_living_count works
;*	(sleep_until 
		(or
			; A wave has been dropped off, or
			(> (ai_living_count ai_sur_wave_spawns) 5)
			
			; All of the dropships are dead (someone is using F6, or there were no dropships to begin with)
			(and
				(< (object_get_health v_sur_phantom_01) 0)
				(< (object_get_health v_sur_phantom_02) 0)
				(< (object_get_health v_sur_phantom_03) 0)
				(< (object_get_health v_sur_phantom_04) 0)
			)
		)
	) *;

	; Sleep until wave end conditions are met
	(survival_wave_end_conditions)
	
	; Migrate remaining AI into a unique squad and squad group 
	(ai_migrate_persistent gr_survival_all ai_sur_remaining)
	
	; Announce wave over 
	(survival_end_announcer) ; TODO Replace/rewrite
	
	; End wave
	(survival_mode_end_wave)
	
	; Allow announcer to vocalize new wave 
	(set b_survival_new_wave TRUE) ; TODO Replace/rewrite
	
	; Reset phantom spawn variable 
	(set b_sur_wave_phantom FALSE)
	
	; Prevent the phantom from moving 
	(set b_phantom_move_out FALSE)
		
	; Reset phantom load count to 1 
	(set s_dropship_load_count 1)
		
	; Sleep set amount of time [unless this is the last wave] 
	(if 
		(and
			(< (survival_mode_wave_get) k_sur_wave_per_round_limit)
			(< s_survival_wave_complete_count (- (survival_mode_get_set_count) 1))
		)
		(sleep k_sur_wave_timer)
	)
	
	; Stop music
	(survival_mode_wave_music_stop)
)


; === wave end parameters =====================================================
(script static short survival_wave_living_count
	(+ 
		(ai_living_count gr_survival_all) 
		(ai_living_count gr_survival_remaining)
		(max 0 (- (ai_living_count ai_sur_phantom_01) s_sur_dropship_crew_count))
		(max 0 (- (ai_living_count ai_sur_phantom_02) s_sur_dropship_crew_count))
		(max 0 (- (ai_living_count ai_sur_phantom_03) s_sur_dropship_crew_count))
		(max 0 (- (ai_living_count ai_sur_phantom_04) s_sur_dropship_crew_count))
	)	
)

(script static void survival_wave_end_conditions
	; clean out the spawn rooms when there are less than 10 AI remaining 
	(sleep_until (< (survival_wave_living_count) 7))
	(survival_kill_volumes_on)
	(ai_survival_cleanup gr_survival_all TRUE TRUE)
	(ai_survival_cleanup gr_survival_remaining TRUE TRUE)
	(ai_survival_cleanup gr_survival_extras TRUE TRUE)

	(cond

		; WAVE 4: last random wave of the final round (index 3)
		((= (survival_mode_wave_get) (- k_sur_wave_per_round_limit 2))
					(begin
						(sleep_until (<= (survival_wave_living_count) k_sur_ai_final_limit))
					)
		)
		
		; FINAL WAVE: final wave of each round sleep until all AI are dead (index 4)
		((or
			(>= (survival_mode_wave_get) (- k_sur_wave_per_round_limit 1))
			(and
				(> (survival_mode_get_set_count) 0)
				(>= s_survival_wave_complete_count (- (survival_mode_get_set_count) 1))	
			)
		)
				
			; countdown to final AI 
			(begin
				(sleep_until (<= (survival_wave_living_count) 5) 1)
					(if	(and (<= (survival_wave_living_count) 5) (> (survival_wave_living_count) 2))
							(begin
								(event_survival_5_ai_remaining)
								(f_blip_ai gr_survival_all blip_hostile)
								(f_blip_ai gr_survival_remaining blip_hostile)
							)
							;(sleep 30)
					)
					(sound_looping_set_alternate m_final_wave TRUE)
					
				(sleep_until (<= (survival_wave_living_count) 2) 1)
					(if	(= (survival_wave_living_count) 2)
							(begin
								(event_survival_2_ai_remaining)
								(f_blip_ai gr_survival_all blip_hostile)
								(f_blip_ai gr_survival_remaining blip_hostile)
							)
							;(sleep 30)
					)
					
				(sleep_until (<= (survival_wave_living_count) 1) 1)
					(if	(= (survival_wave_living_count) 1)
							(begin
								(event_survival_1_ai_remaining)
								(f_blip_ai gr_survival_all blip_hostile)
								(f_blip_ai gr_survival_remaining blip_hostile)
							)
							;(sleep 30)
					)
					
				(sleep_until (<= (survival_wave_living_count) 0))
			)
		)
		
		; END WAVE: all other waves 
		(TRUE
					(begin
						(sleep_until (<= (survival_wave_living_count) k_sur_ai_rand_limit))
					)

		)
	)
	(survival_kill_volumes_off)
	(ai_survival_cleanup gr_survival_all FALSE FALSE)
	(ai_survival_cleanup gr_survival_remaining FALSE FALSE)
	(ai_survival_cleanup gr_survival_extras FALSE FALSE)

	; sleep until all phantoms are out of the world 
	(sleep_until	
		(and
			(< (object_get_health v_sur_phantom_01) 0)
			(< (object_get_health v_sur_phantom_02) 0)
			(< (object_get_health v_sur_phantom_03) 0)
			(< (object_get_health v_sur_phantom_04) 0)
		)
	)
)

(script stub void survival_kill_volumes_on
	(if debug (print "**turn on kill volumes**"))
)
(script stub void survival_kill_volumes_off
	(if debug (print "**turn off kill volumes**"))
)


;=============================================================================================================================
;============================================ BONUS ROUND SCRIPTS ============================================================
;=============================================================================================================================


(global boolean b_sur_bonus_round_running FALSE)
(global boolean b_sur_bonus_end FALSE)
(global boolean b_sur_bonus_spawn TRUE)
(global boolean b_sur_bonus_refilling FALSE)
(global boolean b_sur_bonus_phantom_ready FALSE)

(global long l_sur_pre_bonus_points 0)
(global long l_sur_post_bonus_points 0)

(global short s_sur_bonus_count 0)
(global short k_sur_bonus_squad_limit 6)

(global short k_sur_bonus_limit 20)

(global boolean b_survival_bonus_timer_begin FALSE)
(global short k_survival_bonus_timer (* 30 60 1))


(script static void survival_bonus_round
	(if debug (print "** start bonus round **"))
	
	; Reset the objective
	(ai_reset_objective ai_obj_survival)
	
	; mark survival mode as "running" 
	(set b_sur_bonus_round_running TRUE)
	(set b_sur_bonus_end FALSE)
	
	; Cleanup extras (like Wraiths)
	(ai_kill_no_statistics gr_survival_extras)

	; sum up the total points before the BONUS ROUND begins 
	(set l_sur_pre_bonus_points (survival_total_score))
	
	; mark as the start of bonus round
	(survival_mode_begin_new_wave)
	
	; Get the bonus round duration
	(set k_survival_bonus_timer (* (survival_mode_get_current_wave_time_limit) 30))
	
	; Display bonus round timer
	(chud_bonus_round_set_timer (survival_mode_get_current_wave_time_limit))
	(chud_bonus_round_show_timer true)
	
	;tysongr - 54505: Respawn players before the bonus round
	(survival_mode_respawn_dead_players)
			
	; announce BONUS ROUND
	(event_survival_bonus_round)
	(sleep 90)
	
	; spawn in phantom if needed 
	(if (wave_dropship_enabled) 
		(begin
			(ai_place ai_sur_bonus_phantom)
			(ai_squad_enumerate_immigrants ai_sur_bonus_phantom true)
			(sleep 1)
			
			; My sauce was weak. This makes it strong.
			(f_survival_bonus_spawner true)
			(f_survival_bonus_spawner true)
			(f_survival_bonus_spawner true)
			(f_survival_bonus_spawner true)
		)
	)
	
	; Start the bonus round end condition timer
	(set b_survival_bonus_timer_begin TRUE)
	
	; re-populate the space with a single squad 
	(sleep_until 
		(begin
			; Sleep until the number of AI drops below the bonus limit 
			(sleep_until	
				(or
					b_sur_bonus_end
					(<= (survival_mode_bonus_living_count) k_sur_bonus_limit)
					(survival_players_dead)
				)
				1
			)

			; If the round isn't over...
			(if	
				(and
					(not (survival_players_dead))
					(not b_sur_bonus_end)
				)
				(begin
					(f_survival_bonus_spawner false)
				)
			)

			; continue in this loop until the timer expires 
			; OR all players are dead 
			(or
				b_sur_bonus_end
				(survival_players_dead)
			)
		)
		1
	)
				
	; kill all ai 
	(ai_kill_no_statistics ai_sur_wave_spawns)
	(ai_kill_no_statistics ai_sur_bonus_wave)
	(sleep 90)

	; announce bonus round over 
	(event_survival_bonus_round_over)

	; respawn players 
	(skull_enable skull_iron false)
	(survival_mode_respawn_dead_players)
	(sleep 30)
	
	; End the wave and set
	(survival_mode_end_wave)
	(survival_mode_end_set)

	; Increment the wave complete count for game over condition
	(set s_survival_wave_complete_count (+ s_survival_wave_complete_count 1))

	; delay timer 
	(sleep 120)

	; calculate the number of points scored during the bonus round 
	(set l_sur_post_bonus_points (survival_total_score))
	
	; clear timer 
	(chud_bonus_round_set_timer 0)
	(chud_bonus_round_show_timer FALSE)
	(chud_bonus_round_start_timer FALSE)

	; reset parameters 
	(set k_sur_bonus_squad_limit 6)
	(set b_sur_bonus_phantom_ready FALSE)
	(set b_sur_bonus_refilling FALSE)
	
	; mark survival mode as "not-running" 
	(set b_sur_bonus_round_running FALSE)
)


(script dormant survival_bonus_round_end
	(sleep_until
		(begin
			(sleep_until b_survival_bonus_timer_begin 1)
			(chud_bonus_round_start_timer TRUE)
			(sleep_until 
				(survival_players_dead) 
				1 
				k_survival_bonus_timer
			)
			
			; turn off bonus round 
			(set b_sur_bonus_end TRUE)
		
			; if all players are dead reset the timer 
			(if (survival_players_dead)
				(begin
					(chud_bonus_round_start_timer FALSE)
					(chud_bonus_round_set_timer 0)
				)
			)
				
			(set b_survival_bonus_timer_begin FALSE)
			
			; Loop forever
			false
		)
		1
	)
)


;(global ai survival_bonus_last_squad none)
(script static void (f_survival_bonus_spawner (boolean force_load))
	(if debug (print "spawn bonus squad..."))
	
	; Load them into the dropship if appropriate
	(if
		(or 
			force_load
			(and
				b_sur_bonus_phantom_ready
				(wave_dropship_enabled)
				(= (random_range 0 2) 0)		
			)
		)
		
		; Spawn them in limbo and load them
		(begin
			; Place the squad
			(ai_place_wave_in_limbo (survival_mode_get_wave_squad) ai_sur_wave_spawns 1)
;			(ai_reset_objective ai_obj_survival)
			(sleep 1)
			
			; Get the squad, and load it
			(f_survival_bonus_load_dropship ai_sur_wave_spawns)
		)
		
		; Otherwise, spawn and migrate them
		(begin
			(ai_place_wave (survival_mode_get_wave_squad) ai_sur_wave_spawns 1)
			(sleep 1)
			(ai_migrate_persistent ai_sur_wave_spawns ai_sur_bonus_wave)
		)
	)
	
	; Bedlam?
;*	(if (survival_mode_bedlam)
		; Bedlam Brutes?
		(if g_survival_bedlam_brute
			(begin
				(ai_set_team ai_sur_wave_spawns brute)
				(set g_survival_bedlam_brute false)
			)
			(begin
				(ai_set_team ai_sur_wave_spawns mule)
				(set g_survival_bedlam_brute true)
			)
		)
	)
*;
)


(script static void (f_survival_bonus_load_dropship (ai load_squad))
	(if debug (print "loading bonus squad into dropship..."))

	(if (= s_sur_dropship_type 1)
		; Phantom
		(f_survival_load_phantom
			v_sur_bonus_phantom
			s_sur_drop_side_bonus
			load_squad
		)
		
		; Spirit
		(f_survival_load_spirit
			v_sur_bonus_phantom
			s_sur_drop_side_bonus
			load_squad
		)								
	)
)


(script dormant survival_bonus_round_dropship
	(sleep_until
		(begin
			(sleep_until 
				(or
					b_sur_bonus_phantom_ready 
					b_sur_bonus_end
				)
				5
			)
			(if (not b_sur_bonus_end)
				(begin
					(unit_open v_sur_bonus_phantom)
					(sleep_until 
						(begin
							; Empy the dropship. Is it a Phantom or a Spirit?
							(if (= s_sur_dropship_type 1)
								(vehicle_unload v_sur_bonus_phantom "phantom_p") ; Phantom
								(vehicle_unload v_sur_bonus_phantom "fork_p") ; Spirit
							)
							
							; Migrate them (after a short pause)
							(sleep 1)
							(ai_migrate_persistent ai_sur_wave_spawns ai_sur_bonus_wave)
							
							; Loop until bonus round ends
							b_sur_bonus_end
						)
						30
					)
					(unit_close v_sur_bonus_phantom)
				)
			)
		
			; Loop forever
			false
		)
	)
)


(script static short survival_mode_bonus_living_count
	(+
		(ai_living_count ai_sur_wave_spawns)
		(ai_living_count ai_sur_bonus_wave)
		(ai_living_count ai_sur_bonus_phantom)
	)
)


;================================== SCORE AND ACHIEVEMENTS ====================================================================

(script static long survival_total_score
	(+
		(campaign_metagame_get_player_score (player_human 0))
		(campaign_metagame_get_player_score (player_human 1))
		(campaign_metagame_get_player_score (player_human 2))
		(campaign_metagame_get_player_score (player_human 3))
		(campaign_metagame_get_player_score (player_human 4))
		(campaign_metagame_get_player_score (player_human 5))
	)
)


(script dormant survival_score_attack
	(if debug (print "survival_score_attack"))

	(sleep_until (>= (survival_total_score) survival_mode_score_silver))
	(if debug (print "survival_score_attack silver"))
	(submit_incident_for_spartans "score_silver")

	(sleep_until (>= (survival_total_score) survival_mode_score_gold))
	(if debug (print "survival_score_attack gold"))
	(submit_incident_for_spartans "score_gold")

	(sleep_until (>= (survival_total_score) survival_mode_score_onyx))
	(if debug (print "survival_score_attack onyx"))
	(submit_incident_for_spartans "score_onyx")
)

(script dormant survival_score_attack_mm
	(sleep_until (>= (survival_total_score) survival_mode_score_mm))
	(if debug (print "survival_score_attack mm_achieve"))
	(submit_incident_for_spartans "mm_score_achieve")
)


;================================== PHANTOM SPAWNING / LOADING ================================================================
; Dropships. These can be Phantoms or Spirits depending on scenario settings, but are named "phantom" for legacy support purposes.

; allow phantom to move out 
(global boolean b_phantom_move_out FALSE)


; =============== phantom spawn script =============================================

; randomly pick from the available phantoms 
(script static void survival_dropship_spawner

	; spawn all phantoms 
	(sleep_until
		(begin
			(if b_sur_phantoms_semi_random
				; Semi Random Set Order
				(begin_random
					(begin
						(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_01))
						(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_02))
					)
					(begin
						(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_03))
						(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_04))
					)
				)
	
				; Random Phantom Order
				(begin_random
					(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_01))
					(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_02))
					(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_03))
					(if b_phantom_spawn		(f_survival_dropship_spawner ai_sur_phantom_04))
				)
			)
			
		(= b_phantom_spawn FALSE))
	1)

	; reset phantom spawn variables to initial conditions 
	(set b_phantom_spawn TRUE)
	(set b_phantom_spawn_count 0)
	(sleep 1)
)


(script static void survival_spirit_spawner
	(print "foo")
)



; =============== phantom spawn script =============================================

; spawn a single phantom 
(script static void (f_survival_dropship_spawner (ai spawned_phantom))
	(ai_place spawned_phantom)
	(sleep 1)
	(set s_sur_dropship_crew_count (ai_living_count spawned_phantom))
	(ai_force_active spawned_phantom TRUE)
	(if (>= (object_get_health spawned_phantom) 0)
		(begin
			(if debug (print "spawn phantom..."))
			(set b_phantom_spawn_count (+ b_phantom_spawn_count 1))
			(if (>= b_phantom_spawn_count k_phantom_spawn_limit) (set b_phantom_spawn FALSE))
			
			; Bedlam?
			(if (survival_mode_bedlam)
				(ai_set_team spawned_phantom (survival_mode_get_bedlam_team))
			)
		)
	)
)


; =============== phantom load scripts =============================================

(global short s_dropship_load_count 1)		; tells me what phantom i'm loading  (1 - 4) 
(global boolean b_dropship_loaded FALSE)

(script static ai (wave_squad_get (short index))
	(if (<= index (ai_squad_group_get_squad_count ai_sur_wave_spawns))
		(ai_squad_group_get_squad ai_sur_wave_spawns index)
		none
	)
)

(script static short (wave_squad_get_count (short index))
	(if (<= index (ai_squad_group_get_squad_count ai_sur_wave_spawns))
		(ai_living_count (ai_squad_group_get_squad ai_sur_wave_spawns index))
		0
	)
)


(script static boolean (survival_should_load_squad (ai squad))
	(and
		(> (ai_living_count squad) 0)
		(not (ai_is_in_fireteam squad))
	)
)

(script static void survival_dropship_loader
	; For each squad, it if exists, load it
	(if (survival_should_load_squad (wave_squad_get 0)) (f_survival_dropship_loader (wave_squad_get 0)))
	(if (survival_should_load_squad (wave_squad_get 1)) (f_survival_dropship_loader (wave_squad_get 1)))
	(if (survival_should_load_squad (wave_squad_get 2)) (f_survival_dropship_loader (wave_squad_get 2)))
	(if (survival_should_load_squad (wave_squad_get 3)) (f_survival_dropship_loader (wave_squad_get 3)))
	(if (survival_should_load_squad (wave_squad_get 4)) (f_survival_dropship_loader (wave_squad_get 4)))
	(if (survival_should_load_squad (wave_squad_get 5)) (f_survival_dropship_loader (wave_squad_get 5)))
	(if (survival_should_load_squad (wave_squad_get 6)) (f_survival_dropship_loader (wave_squad_get 6)))
	(if (survival_should_load_squad (wave_squad_get 7)) (f_survival_dropship_loader (wave_squad_get 7)))
	(if (survival_should_load_squad (wave_squad_get 8)) (f_survival_dropship_loader (wave_squad_get 8)))
	(if (survival_should_load_squad (wave_squad_get 9)) (f_survival_dropship_loader (wave_squad_get 9)))
	(if (survival_should_load_squad (wave_squad_get 10)) (f_survival_dropship_loader (wave_squad_get 10)))
	(if (survival_should_load_squad (wave_squad_get 11)) (f_survival_dropship_loader (wave_squad_get 11)))
	(if (survival_should_load_squad (wave_squad_get 12)) (f_survival_dropship_loader (wave_squad_get 12)))
	(if (survival_should_load_squad (wave_squad_get 13)) (f_survival_dropship_loader (wave_squad_get 13)))
	(if (survival_should_load_squad (wave_squad_get 14)) (f_survival_dropship_loader (wave_squad_get 14)))
	(if (survival_should_load_squad (wave_squad_get 15)) (f_survival_dropship_loader (wave_squad_get 15)))
	(if (survival_should_load_squad (wave_squad_get 16)) (f_survival_dropship_loader (wave_squad_get 16)))
	(if (survival_should_load_squad (wave_squad_get 17)) (f_survival_dropship_loader (wave_squad_get 17)))
	(if (survival_should_load_squad (wave_squad_get 18)) (f_survival_dropship_loader (wave_squad_get 18)))
	(if (survival_should_load_squad (wave_squad_get 19)) (f_survival_dropship_loader (wave_squad_get 19)))
	(if (survival_should_load_squad (wave_squad_get 20)) (f_survival_dropship_loader (wave_squad_get 20)))
)


(script static void (f_survival_dropship_loader (ai load_squad))
	(sleep_until
		(begin
			; attempt to load dropship 01 
			(if 
				(and 
					(= b_dropship_loaded FALSE) 
					(= s_dropship_load_count 1)
				)
				(begin
					(if 
						(and
							(>= (object_get_health v_sur_phantom_01) 0)
							(> (list_count (ai_actors load_squad)) 0)
							;(= (unit_get_team_index v_sur_phantom_01) (unit_get_team_index (unit (list_get (ai_actors load_squad) 0))))
						)
						(begin
							(if debug (print "** load dropship 01 **"))
							(if (= s_sur_dropship_type 1)
								; Phantom
								(f_survival_load_phantom
									v_sur_phantom_01
									s_sur_drop_side_01
									load_squad
								)
								
								; Spirit
								(f_survival_load_spirit
									v_sur_phantom_01
									s_sur_drop_side_01
									load_squad
								)								
							)
						)
					)
					(set s_dropship_load_count 2)
				)
			)
	
			; attempt to load dropship 02 
			(if 
				(and 
					(= b_dropship_loaded FALSE) 
					(= s_dropship_load_count 2)
				)
				(begin
					(if 
						(and
							(>= (object_get_health v_sur_phantom_02) 0)
							(> (list_count (ai_actors load_squad)) 0)
							;(= (unit_get_team_index v_sur_phantom_02) (unit_get_team_index (unit (list_get (ai_actors load_squad) 0))))
						)
						(begin
							(if debug (print "** load dropship 02 **"))
							(if (= s_sur_dropship_type 1)
								; Phantom
								(f_survival_load_phantom
									v_sur_phantom_02
									s_sur_drop_side_02
									load_squad
								)
								
								; Spirit
								(f_survival_load_spirit
									v_sur_phantom_02
									s_sur_drop_side_02
									load_squad
								)								
							)
						)
					)
					(set s_dropship_load_count 3)
				)
			)
	
			; attempt to load dropship 03 
			(if 
				(and 
					(= b_dropship_loaded FALSE) 
					(= s_dropship_load_count 3)
				)
				(begin
					(if 
						(and
							(>= (object_get_health v_sur_phantom_03) 0)
							(> (list_count (ai_actors load_squad)) 0)
							;(= (unit_get_team_index v_sur_phantom_03) (unit_get_team_index (unit (list_get (ai_actors load_squad) 0))))
						)
						(begin
							(if debug (print "** load dropship 03 **"))
							(if (= s_sur_dropship_type 1)
								; Phantom
								(f_survival_load_phantom
									v_sur_phantom_03
									s_sur_drop_side_03
									load_squad
								)
								
								; Spirit
								(f_survival_load_spirit
									v_sur_phantom_03
									s_sur_drop_side_03
									load_squad
								)								
							)
						)
					)
					(set s_dropship_load_count 4)
				)
			)
	
			; attempt to load dropship 04 
			(if 
				(and 
					(= b_dropship_loaded FALSE) 
					(= s_dropship_load_count 4)
				)
				(begin
					(if 
						(and
							(>= (object_get_health v_sur_phantom_04) 0)
							(> (list_count (ai_actors load_squad)) 0)
							;(= (unit_get_team_index v_sur_phantom_04) (unit_get_team_index (unit (list_get (ai_actors load_squad) 0))))
						)
						(begin
							(if debug (print "** load dropship 04 **"))
							(if (= s_sur_dropship_type 1)
								; Phantom
								(f_survival_load_phantom
									v_sur_phantom_04
									s_sur_drop_side_04
									load_squad
								)
								
								; Spirit
								(f_survival_load_spirit
									v_sur_phantom_04
									s_sur_drop_side_04
									load_squad
								)								
							)
						)
					)
					(set s_dropship_load_count 1)
				)
			)
			
			b_dropship_loaded
		)
		1
	)

	; reset loaded variable 
	(set b_dropship_loaded FALSE)
)

(script static void	(f_survival_load_phantom
								(vehicle dropship)
								(string load_side)
								(ai load_squad)
				)
	; Assign the squad to the hold task to make sure they can be loaded
	(survival_set_hold_task load_squad)
				
	; Take the AI out of limbo
	(ai_exit_limbo load_squad)
				
	; left 
	(if (= load_side "left")
		(begin
			(if debug (print "load phantom left..."))
				(if (= (vehicle_test_seat dropship "phantom_p_lb") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_lb"))
				(if (= (vehicle_test_seat dropship "phantom_p_lf") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_lf"))
				(if (= (vehicle_test_seat dropship "phantom_p_ml_f") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_ml_f"))
				(if (= (vehicle_test_seat dropship "phantom_p_ml_b") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_ml_b"))
			; prevent further attempts to load phantoms 
			(set b_dropship_loaded TRUE)
		)
	)
	; right 
	(if (= load_side "right")
		(begin
			(if debug (print "load phantom right..."))
				(if (= (vehicle_test_seat dropship "phantom_p_rb") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_rb"))
				(if (= (vehicle_test_seat dropship "phantom_p_rf") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_rf"))
				(if (= (vehicle_test_seat dropship "phantom_p_mr_f") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_mr_f"))
				(if (= (vehicle_test_seat dropship "phantom_p_mr_b") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_mr_b"))
			; prevent further attempts to load phantoms 
			(set b_dropship_loaded TRUE)
		)
	)
	; dual 
	(if (= load_side "dual")
		(begin
			(if debug (print "load phantom dual..."))
				(if (= (vehicle_test_seat dropship "phantom_p_lf") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_lf"))
				(if (= (vehicle_test_seat dropship "phantom_p_rf") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_rf"))
				(if (= (vehicle_test_seat dropship "phantom_p_lb") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_lb"))
				(if (= (vehicle_test_seat dropship "phantom_p_rb") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_p_rb"))
			; prevent further attempts to load phantoms 
			(set b_dropship_loaded TRUE)
		)
	)
	; dual 
	(if (= load_side "chute")
		(begin
			(if debug (print "load phantom chute..."))
				(if (= (vehicle_test_seat dropship "phantom_pc_1") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_pc_1"))
				(if (= (vehicle_test_seat dropship "phantom_pc_2") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_pc_2"))
				(if (= (vehicle_test_seat dropship "phantom_pc_3") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_pc_3"))
				(if (= (vehicle_test_seat dropship "phantom_pc_4") FALSE)		(ai_vehicle_enter_immediate load_squad dropship "phantom_pc_4"))
			; prevent further attempts to load phantoms 
			(set b_dropship_loaded TRUE)
		)
	)
)


(script static void (f_survival_load_spirit
						(vehicle dropship)
						(string load_side)
						(ai load_squad))
				
	(if debug (print "load spirit..."))

	; Assign the squad to the hold task to make sure they can be loaded
	(survival_set_hold_task load_squad)
				
	; Take the AI out of limbo
	(ai_exit_limbo load_squad)				
	
	; Left
	(if (= load_side "left")
		(begin
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l")
		)
	)
	
	; Right
	(if (= load_side "right")
		(begin
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r")
		)
	)
	
	; Dual
	(if (= load_side "dual")
		; Filth. But, it works.
		(begin
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r1")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l4")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r2")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l5")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r3")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l3")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r6")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l6")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r5")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l2")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r7")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l7")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r4")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l1")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_r8")
			(ai_vehicle_enter_immediate load_squad dropship "fork_p_l8")
		)
	)
	
	; Remainder
	(ai_vehicle_enter_immediate load_squad dropship "fork_p")
	
	; prevent further attempts to load phantoms 
	(set b_dropship_loaded TRUE)
)


(script static void (survival_callout_dropship_internal (object dropship) (short time))
	(sound_impulse_start sfx_blip NONE 1)
	(chud_track_object_for_player_with_priority (human_player_in_game_get 0) dropship 14)
	(chud_track_object_for_player_with_priority (human_player_in_game_get 1) dropship 14)
	(chud_track_object_for_player_with_priority (human_player_in_game_get 2) dropship 14)
	(chud_track_object_for_player_with_priority (human_player_in_game_get 3) dropship 14)
	(chud_track_object_for_player_with_priority (human_player_in_game_get 4) dropship 14)
	(chud_track_object_for_player_with_priority (human_player_in_game_get 5) dropship 14)
	(sleep time)
	(chud_track_object dropship false)
)


(script static void (f_survival_callout_dropship (object dropship))
	;LB: commented out the extra blips for Candland 
	;(survival_callout_dropship_internal dropship 10) (sleep 2)
	;(survival_callout_dropship_internal dropship 10) (sleep 2)
	;(survival_callout_dropship_internal dropship 10) (sleep 2)
	(survival_callout_dropship_internal dropship 200)
)


;===================================== COUNTDOWN TIMER =======================================================================

(script static void survival_countdown_timer
	(sound_impulse_start "sound\game_sfx\ui\atlas_main_menu\player_timer_beep"	NONE 1)
		(sleep 30)
	(sound_impulse_start "sound\game_sfx\ui\atlas_main_menu\player_timer_beep"	NONE 1)
		(sleep 30)
	(sound_impulse_start "sound\game_sfx\ui\atlas_main_menu\player_timer_beep"	NONE 1)
		(sleep 30)
	(sound_impulse_start "sound\game_sfx\ui\atlas_main_menu\player_respawn"	NONE 1)
		(sleep 30)
)

;=============================================================================================================================
;============================================ ANNOUNCEMENT SCRIPTS ===========================================================
;=============================================================================================================================

;===================================== BEGIN ANNOUNCER =======================================================================

; this script assumes that at the start of a SET the rounds and waves are set to -- 0 -- 
; also, at the start of a ROUND waves are set to -- 0 -- 

(global boolean b_survival_new_set TRUE)
(global boolean b_survival_new_round TRUE)
(global boolean b_survival_new_wave TRUE)

(script static void survival_begin_announcer
	(cond
		(b_survival_new_set				(begin
										(if debug (print "announce new set..."))
										(survival_countdown_timer)
										(event_survival_new_set)
										(set b_survival_new_set FALSE)
										(set b_survival_new_round FALSE)
										(set b_survival_new_wave FALSE)
									)
		)
		(b_survival_new_round
									(begin
										(if debug (print "announce new round..."))
										(survival_countdown_timer)
										(event_survival_new_round)
										(set b_survival_new_round FALSE)
										(set b_survival_new_wave FALSE)
									)
		)
		(b_survival_new_wave		
									(begin
										(if debug (print "announce new wave..."))
										(if (> (survival_mode_wave_get) 0) ; TODO make sure this is correct (updated for 0 index)
											(begin
												; attempt to award the hero medal 
												(survival_mode_award_hero_medal)
													(sleep 1)
													
												; respawn dead players (WE DO NOT ADD LIVES HERE) 
												(event_survival_reinforcements)
												(survival_mode_respawn_dead_players)
													(sleep (* (random_range 3 5) 30))
											)
										)
									)
		)
	)
	(sleep 5)
)

;===================================== END ANNOUNCER =========================================================================

(script static void survival_end_announcer ; TODO update this, especially with regard to 0 index
	(cond
		((< (survival_mode_wave_get) k_sur_wave_per_round_limit)				
										(begin
											(if debug (print "announce end wave..."))
										)
		)
		((< (survival_mode_round_get) k_sur_round_per_set_limit)				
										(begin
											(sleep (* 30 5))
											(if debug (print "announce end round..."))
											(event_survival_end_round)
											(sleep (* 30 3))
										)
		)
		(TRUE		
										(begin
											(sleep (* 30 5))
											(if debug (print "announce end set..."))
											(event_survival_end_set)
											(ai_kill_no_statistics gr_survival_extras)
											(sleep (* 30 3))
										)
		)
	)
)
(script dormant survival_lives_announcement
	(sleep_until
		(begin
			; sleep until lives are greater than ZERO 
			(sleep_until (> (survival_mode_lives_get player) 0) 1)

			; sleep until lives below 5 
			(sleep_until (<= (survival_mode_lives_get player) 5) 1)
			(if (= (survival_mode_lives_get player) 5)	(begin
												(if debug (print "5 lives left..."))
												(event_survival_5_lives_left)
											)
			)

			; sleep until lives below 1 or greater than 5 
			(sleep_until	(or
							(<= (survival_mode_lives_get player) 1)
							(> (survival_mode_lives_get player) 5)
						)
			1)
			(if (= (survival_mode_lives_get player) 1)	(begin
												(if debug (print "1 life left..."))
												(event_survival_1_life_left)
											)
			)

				
			; sleep until lives at 0 or greater than 1 
			(sleep_until	(or
							(<= (survival_mode_lives_get player) 0)
							(> (survival_mode_lives_get player) 1)
						)
			1)
			(if (<= (survival_mode_lives_get player) 0)	(begin
												(if debug (print "0 lives left..."))
												(event_survival_0_lives_left)
											)
			)
				
			; sleep until lives at 0 or greater than 1 
			(sleep_until	(or
							(<= (players_human_living_count) 1)
							(> (survival_mode_lives_get player) 0)
						)
			1)
			(if	(and
					(<= (survival_mode_lives_get player) 0)
					(= (players_human_living_count) 1)
				)
											(begin
												(if debug (print "last man standing..."))
												(event_survival_last_man_standing)
											)
			)

		FALSE)
	)
)


;=============================================================================================================================
;============================================ GENERATOR DEFENSE SCRIPTS ======================================================
;=============================================================================================================================

(global boolean b_sur_generator_defense_active false)
(global boolean b_sur_generator_defense_fail false)
(global boolean b_sur_generator0_spawned false)
(global boolean b_sur_generator1_spawned false)
(global boolean b_sur_generator2_spawned false)
(global boolean b_sur_generator0_alive false)
(global boolean b_sur_generator1_alive false)
(global boolean b_sur_generator2_alive false)
(global short s_sur_generators_alive 0)
(global real r_sur_generator0_health -1)
(global real r_sur_generator1_health -1)
(global real r_sur_generator2_health -1)

(global short k_surv_generator_cooldown 90)

(script dormant survival_mode_generator_defense
	(set b_sur_generator_defense_active true)
	
	; Create the generator objects
	(survival_mode_gd_spawn_generators)
	(sleep 1)
	
	; Start the manager
	(wake survival_generator0_management)
	(wake survival_generator1_management)
	(wake survival_generator2_management)
	
	; Make the AI hate the objects
	(if b_sur_generator0_spawned 
		(begin
			(ai_object_set_team obj_sur_generator0 player)
			(ai_object_set_targeting_bias obj_sur_generator0 0.85)
			(ai_object_enable_targeting_from_vehicle obj_sur_generator0 false)
			(object_set_allegiance obj_sur_generator0 player)
			(object_immune_to_friendly_damage obj_sur_generator0 true)
			(set b_sur_generator0_alive true)
		)
	)
	(if b_sur_generator1_spawned 
		(begin
			(ai_object_set_team obj_sur_generator1 player)
			(ai_object_set_targeting_bias obj_sur_generator1 0.85)
			(ai_object_enable_targeting_from_vehicle obj_sur_generator1 false)
			(object_set_allegiance obj_sur_generator1 player)
			(object_immune_to_friendly_damage obj_sur_generator1 true)
			(set b_sur_generator1_alive true)
		)
	)
	(if b_sur_generator2_spawned 
		(begin
			(ai_object_set_team obj_sur_generator2 player)
			(ai_object_set_targeting_bias obj_sur_generator2 0.85)
			(ai_object_enable_targeting_from_vehicle obj_sur_generator2 false)
			(object_set_allegiance obj_sur_generator2 player)
			(object_immune_to_friendly_damage obj_sur_generator2 true)
			(set b_sur_generator2_alive true)
		)
	)
	
	; Connect HUD elements
	; TODO connect HUD elements
	
	; Begin success/failure conditions
	(sleep_until
		(begin
			; Have any generators taken damage?
			(if (< (object_get_health obj_sur_generator0) r_sur_generator0_health)
				(event_survival_generator0_attacked)
			)
			(if (< (object_get_health obj_sur_generator1) r_sur_generator1_health)
				(event_survival_generator1_attacked)
			)
			(if (< (object_get_health obj_sur_generator2) r_sur_generator2_health)
				(event_survival_generator2_attacked)
			)
			
			; Cache generator health
			(set r_sur_generator0_health (object_get_health obj_sur_generator0))
			(set r_sur_generator1_health (object_get_health obj_sur_generator1))
			(set r_sur_generator2_health (object_get_health obj_sur_generator2))
		
			; Have we lost a generator since last update?
			(if 
				(< (survival_mode_gd_generator_count) s_sur_generators_alive)
				(begin
					(event_survival_generator_died)
					
					; Submit an incident for the elites to track stats
					(submit_incident_for_elites "team_generator_kill")
				)
			)
			
			; Cache the living count
			(set s_sur_generators_alive (survival_mode_gd_generator_count))
					
			; Loop until the generators are no longer alive
			(not (survival_mode_gd_generators_alive))
		)
		3
	)
	
	; Failure. Set the failure flag
	(set b_sur_generator_defense_fail true)
	
	; And shut down any HUD scripts that might be running
	; TODO disconnect HUD elements
)


(script static void (survival_generator_switch (short switch) (short state))
	; Switch 0
	(if (= switch 0)
		(cond
			; No switch
			((= state 0)
				(begin
					(device_set_power obj_sur_generator_switch0 0)
					(device_set_power obj_sur_generator_switch_cool0 0)
					(device_set_power obj_sur_generator_switch_dis0 0)
				)
			)
			
			; Active
			((= state 1)
				(begin
					(device_set_power obj_sur_generator_switch0 1)
					(device_set_power obj_sur_generator_switch_cool0 0)
					(device_set_power obj_sur_generator_switch_dis0 0)
				)
			)
			
			; Cooling
			((= state 2)
				(begin
					(device_set_power obj_sur_generator_switch0 0)
					(device_set_power obj_sur_generator_switch_cool0 1)
					(device_set_power obj_sur_generator_switch_dis0 0)
				)
			)
			
			; Disabled
			((= state 3)
				(begin
					(device_set_power obj_sur_generator_switch0 0)
					(device_set_power obj_sur_generator_switch_cool0 0)
					(device_set_power obj_sur_generator_switch_dis0 1)
				)
			)	
		)
	)

	; Switch 1
	(if (= switch 1)
		(cond
			; No switch
			((= state 0)
				(begin
					(device_set_power obj_sur_generator_switch1 0)
					(device_set_power obj_sur_generator_switch_cool1 0)
					(device_set_power obj_sur_generator_switch_dis1 0)
				)
			)
			
			; Active
			((= state 1)
				(begin
					(device_set_power obj_sur_generator_switch1 1)
					(device_set_power obj_sur_generator_switch_cool1 0)
					(device_set_power obj_sur_generator_switch_dis1 0)
				)
			)
			
			; Cooling
			((= state 2)
				(begin
					(device_set_power obj_sur_generator_switch1 0)
					(device_set_power obj_sur_generator_switch_cool1 1)
					(device_set_power obj_sur_generator_switch_dis1 0)
				)
			)
			
			; Disabled
			((= state 3)
				(begin
					(device_set_power obj_sur_generator_switch1 0)
					(device_set_power obj_sur_generator_switch_cool1 0)
					(device_set_power obj_sur_generator_switch_dis1 1)
				)
			)	
		)
	)

	; Switch 2
	(if (= switch 2)
		(cond
			; No switch
			((= state 0)
				(begin
					(device_set_power obj_sur_generator_switch2 0)
					(device_set_power obj_sur_generator_switch_cool2 0)
					(device_set_power obj_sur_generator_switch_dis2 0)
				)
			)
			
			; Active
			((= state 1)
				(begin
					(device_set_power obj_sur_generator_switch2 1)
					(device_set_power obj_sur_generator_switch_cool2 0)
					(device_set_power obj_sur_generator_switch_dis2 0)
				)
			)
			
			; Cooling
			((= state 2)
				(begin
					(device_set_power obj_sur_generator_switch2 0)
					(device_set_power obj_sur_generator_switch_cool2 1)
					(device_set_power obj_sur_generator_switch_dis2 0)
				)
			)
			
			; Disabled
			((= state 3)
				(begin
					(device_set_power obj_sur_generator_switch2 0)
					(device_set_power obj_sur_generator_switch_cool2 0)
					(device_set_power obj_sur_generator_switch_dis2 1)
				)
			)	
		)
	)
)


(global short s_surv_generator0_cooldown 0)
(script dormant survival_generator0_management
	(device_set_position_immediate obj_sur_generator0 0)

	; Generator alive
	(sleep_until
		(begin
			; Is it open?
			(if (<= (device_get_position obj_sur_generator0) 0.1)
				; The generator is open and vulnerable
				(begin
					(ai_object_set_targeting_bias obj_sur_generator0 0.85)
					
					; Is it Sudden Death?
					(if b_survival_entered_sudden_death
						(survival_generator_switch 0 3) ; Generator disabled (sudden death)
						
						; If not, is it still cooling?
						(if (> s_surv_generator0_cooldown 0)
							(begin
								(survival_generator_switch 0 2) ; Generator cooling prompt
								(sleep s_surv_generator0_cooldown) 
								(set s_surv_generator0_cooldown 0)
							)
							
							; Otherwise, the state is ready
							(survival_generator_switch 0 1) ; Generator ready prompt
						)
					)
				)
				
				; The generator is closed and invulnerable
				(begin
					(event_survival_generator0_locked)
					(survival_generator_switch 0 0) ; No generator prompt
					(ai_object_set_targeting_bias obj_sur_generator0 -1)
					(sleep_until (< (device_get_position obj_sur_generator0) 0.1) 5)
					(set s_surv_generator0_cooldown k_surv_generator_cooldown)
				)
			)
			
			; Loop until the generator is dead
			(<= (object_get_health obj_sur_generator0) 0)
		)
		5 
	)
	
	; Generator dead
	(begin
		(object_cannot_take_damage obj_sur_generator0)
		(survival_generator_switch 0 0) ; No generator prompt
		(ai_object_set_targeting_bias obj_sur_generator0 -1)
		(set b_sur_generator0_alive false)
	)
)


(global short s_surv_generator1_cooldown 0)
(script dormant survival_generator1_management
	(device_set_position_immediate obj_sur_generator1 0)

	; Generator alive
	(sleep_until
		(begin
			; Is it open?
			(if (<= (device_get_position obj_sur_generator1) 0.1)
				; The generator is open and vulnerable
				(begin
					(ai_object_set_targeting_bias obj_sur_generator1 0.85)
					
					; Is it Sudden Death?
					(if b_survival_entered_sudden_death
						(survival_generator_switch 1 3) ; Generator disabled (sudden death)
						
						; If not, is it still cooling?
						(if (> s_surv_generator1_cooldown 0)
							(begin
								(survival_generator_switch 1 2) ; Generator cooling prompt
								(sleep s_surv_generator1_cooldown) 
								(set s_surv_generator1_cooldown 0)
							)
							
							; Otherwise, the state is ready
							(survival_generator_switch 1 1) ; Generator ready prompt
						)
					)
				)
				
				; The generator is closed and invulnerable
				(begin
					(event_survival_generator1_locked)
					(survival_generator_switch 1 0) ; No generator prompt
					(ai_object_set_targeting_bias obj_sur_generator1 -1)
					(sleep_until (< (device_get_position obj_sur_generator1) 0.1) 5)
					(set s_surv_generator1_cooldown k_surv_generator_cooldown)
				)
			)
			
			; Loop until the generator is dead
			(<= (object_get_health obj_sur_generator1) 0)
		)
		5 
	)
	
	; Generator dead
	(begin
		(object_cannot_take_damage obj_sur_generator1)
		(survival_generator_switch 1 0) ; No generator prompt
		(ai_object_set_targeting_bias obj_sur_generator1 -1)
		(set b_sur_generator1_alive false)
	)
)


(global short s_surv_generator2_cooldown 0)
(script dormant survival_generator2_management
	(device_set_position_immediate obj_sur_generator2 0)

	; Generator alive
	(sleep_until
		(begin
			; Is it open?
			(if (<= (device_get_position obj_sur_generator2) 0.1)
				; The generator is open and vulnerable
				(begin
					(ai_object_set_targeting_bias obj_sur_generator2 0.85)
					
					; Is it Sudden Death?
					(if b_survival_entered_sudden_death
						(survival_generator_switch 2 3) ; Generator disabled (sudden death)
						
						; If not, is it still cooling?
						(if (> s_surv_generator2_cooldown 0)
							(begin
								(survival_generator_switch 2 2) ; Generator cooling prompt
								(sleep s_surv_generator2_cooldown) 
								(set s_surv_generator2_cooldown 0)
							)
							
							; Otherwise, the state is ready
							(survival_generator_switch 2 1) ; Generator ready prompt
						)
					)
				)
				
				; The generator is closed and invulnerable
				(begin
					(event_survival_generator2_locked)
					(survival_generator_switch 2 0) ; No generator prompt
					(ai_object_set_targeting_bias obj_sur_generator2 -1)
					(sleep_until (< (device_get_position obj_sur_generator2) 0.1) 5)
					(set s_surv_generator2_cooldown k_surv_generator_cooldown)
				)
			)
			
			; Loop until the generator is dead
			(<= (object_get_health obj_sur_generator2) 0)
		)
		5 
	)
	
	; Generator dead
	(begin
		(object_cannot_take_damage obj_sur_generator2)
		(survival_generator_switch 2 0) ; No generator prompt
		(ai_object_set_targeting_bias obj_sur_generator2 -1)
		(set b_sur_generator2_alive false)
	)
)


(script static void survival_mode_gd_spawn_generators
	; Random, or sequence?
	(if (survival_mode_generator_random_spawn)
		; Random spawns
		(begin_random_count (survival_mode_generator_count)
			; Generator 0
			(begin
				(object_create_anew obj_sur_generator0)
				(object_create_anew obj_sur_generator_switch0)
				(object_create_anew obj_sur_generator_switch_cool0)
				(object_create_anew obj_sur_generator_switch_dis0)
				(set b_sur_generator0_spawned true)
				(object_can_take_damage obj_sur_generator0)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator0 7)
			)

			; Generator 1
			(begin
				(object_create_anew obj_sur_generator1)
				(object_create_anew obj_sur_generator_switch1)
				(object_create_anew obj_sur_generator_switch_cool1)
				(object_create_anew obj_sur_generator_switch_dis1)
				(set b_sur_generator1_spawned true)
				(object_can_take_damage obj_sur_generator1)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator1 8)
			)

			; Generator 2
			(begin
				(object_create_anew obj_sur_generator2)
				(object_create_anew obj_sur_generator_switch2)
				(object_create_anew obj_sur_generator_switch_cool2)
				(object_create_anew obj_sur_generator_switch_dis2)
				(set b_sur_generator2_spawned true)
				(object_can_take_damage obj_sur_generator2)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator2 9)
			)
		)
		
		; Sequential
		(begin_count (survival_mode_generator_count)
			; Generator 0
			(begin
				(object_create_anew obj_sur_generator0)
				(object_create_anew obj_sur_generator_switch0)
				(object_create_anew obj_sur_generator_switch_cool0)
				(object_create_anew obj_sur_generator_switch_dis0)
				(set b_sur_generator0_spawned true)
				(object_can_take_damage obj_sur_generator0)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator0 10)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator0 7)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator0 7)
			)

			; Generator 1
			(begin
				(object_create_anew obj_sur_generator1)
				(object_create_anew obj_sur_generator_switch1)
				(object_create_anew obj_sur_generator_switch_cool1)
				(object_create_anew obj_sur_generator_switch_dis1)
				(set b_sur_generator1_spawned true)
				(object_can_take_damage obj_sur_generator1)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator1 11)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator1 8)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator1 8)
			)

			; Generator 2
			(begin
				(object_create_anew obj_sur_generator2)
				(object_create_anew obj_sur_generator_switch2)
				(object_create_anew obj_sur_generator_switch_cool2)
				(object_create_anew obj_sur_generator_switch_dis2)
				(set b_sur_generator2_spawned true)
				(object_can_take_damage obj_sur_generator2)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator2 12)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator2 9)
				(chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator2 9)
			)
		)
	)
)


(script static boolean survival_mode_gd_generators_alive
	; Is the mode Defend All, or Defend Any?
	(if (survival_mode_generator_defend_all)
		; All of the generators that are supposed to be alive, are
		(>= (survival_mode_gd_generator_count) (survival_mode_generator_count))
		
		; At least one generator is alive
		(> (survival_mode_gd_generator_count) 0)
	)
)


(script static short survival_mode_gd_generator_count
	; This is one of the dirtiest things I've ever done in HS
	(+
		(if (and b_sur_generator0_spawned (> (object_get_health obj_sur_generator0) 0))
			1
			0
		)
		(if (and b_sur_generator1_spawned (> (object_get_health obj_sur_generator1) 0))
			1
			0
		)
		(if (and b_sur_generator2_spawned (> (object_get_health obj_sur_generator2) 0))
			1
			0
		)
	)
)



;=============================================================================================================================
;============================================ WEAPON CRATE SCRIPTS ===========================================================
;=============================================================================================================================
(global folder folder_survival_scenery sc_survival)
(global folder folder_survival_crates cr_survival)
(global folder folder_survival_vehicles v_survival)
(global folder folder_survival_equipment eq_survival)
(global folder folder_survival_weapons wp_survival)
(global folder folder_survival_devices dc_survival)

; respawning weapon crates after round ends
(script static void survival_respawn_weapons
	(if debug (print "creating scenery / vehicles / equipment"))
	
	; create all objects 
	(object_create_folder_anew folder_survival_scenery)
	(object_create_folder_anew folder_survival_crates)
	(object_create_folder_anew folder_survival_vehicles)
	(object_create_folder_anew folder_survival_devices)
	
	; If weapon drops are enabled...
	(if (survival_mode_weapon_drops_enable)
		(begin
			; Allow mission scripts to sync with weapon drops 
			(set b_survival_mode_weapon_drop TRUE)
			
			; Audio/text
			(event_survival_awarded_weapon)

			; Create applicable crates as needed
			(object_create_folder_anew folder_survival_equipment)
			(object_create_folder_anew folder_survival_weapons)			
		)
	)
)

(script static void survival_respawn_crates
	(if debug (print "respawn crates"))
	(object_create_folder_anew folder_survival_crates)
)	

;=============================================================================================================================
;============================================ MUSIC SCRIPTS ==================================================================
;=============================================================================================================================

; music definitions 
(global looping_sound m_survival_start	"firefight\firefight_music\firefight_music01")
(global looping_sound m_new_set		"firefight\firefight_music\firefight_music01")
(global looping_sound m_initial_wave	"firefight\firefight_music\firefight_music02")
(global looping_sound m_final_wave		"firefight\firefight_music\firefight_music20")

(script static void surival_set_music

	; set initial music 
	(begin_random_count 1
		(set m_initial_wave "firefight\firefight_music\firefight_music02")
		(set m_initial_wave "firefight\firefight_music\firefight_music03")
		(set m_initial_wave "firefight\firefight_music\firefight_music04")
		(set m_initial_wave "firefight\firefight_music\firefight_music05")
		(set m_initial_wave "firefight\firefight_music\firefight_music06")
	)

	; set final music 
	(begin_random_count 1
		(set m_final_wave "firefight\firefight_music\firefight_music20")
		(set m_final_wave "firefight\firefight_music\firefight_music21")
		(set m_final_wave "firefight\firefight_music\firefight_music22")
		(set m_final_wave "firefight\firefight_music\firefight_music23")
		(set m_final_wave "firefight\firefight_music\firefight_music24")
	)
)


(script static void survival_mode_wave_music_start
	(cond
		((survival_mode_current_wave_is_initial) 	(sound_looping_start m_initial_wave NONE 1))
		((survival_mode_current_wave_is_boss) 		(sound_looping_start m_final_wave NONE 1))		
	)
)


(script static void survival_mode_wave_music_stop
	(cond
		((survival_mode_current_wave_is_initial) 	(sound_looping_stop m_initial_wave))
		((survival_mode_current_wave_is_boss) 		(sound_looping_stop m_final_wave))		
	)
)


;=============================================================================================================================
;====================================== ACHIEVEMENT SCRIPTS ==================================================================
;=============================================================================================================================
(global string string_survival_map_name none)

(script dormant survival_award_achievement
	(sleep_until (>= (survival_total_score) 200000))
	
;TODO restore achievements
;	(cond
;		((= string_survival_map_name "sc100")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc100))
;		((= string_survival_map_name "sc110")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc110))
;		((= string_survival_map_name "sc120")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc120))
;		((= string_survival_map_name "sc130a")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc130a))
;		((= string_survival_map_name "sc130b")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc130b))
;		((= string_survival_map_name "sc140")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc140))
;		((= string_survival_map_name "l200")	(achievement_grant_to_all_players _achievement_metagame_points_in_l200))
;		((= string_survival_map_name "l300")	(achievement_grant_to_all_players _achievement_metagame_points_in_l300))
;		((= string_survival_map_name "h100a")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc100))
;		((= string_survival_map_name "h100b")	(achievement_grant_to_all_players _achievement_metagame_points_in_sc120))
;	)
)

(global long l_player0_score 0)
(global long l_player1_score 0)
(global long l_player2_score 0)
(global long l_player3_score 0)

; be like marty 
(script static void survival_like_marty_start
	; set long to current score 
	(print "todo fix survival_like_marty_start")
	; TODO make this not crash
;	(set l_player0_score (campaign_metagame_get_player_score (player0)))
;	(set l_player1_score (campaign_metagame_get_player_score (player1)))
;	(set l_player2_score (campaign_metagame_get_player_score (player2)))
;	(set l_player3_score (campaign_metagame_get_player_score (player3)))
)
(script static void survival_like_marty_award
	; if the score is less than or equal to the what it was at the start of the round 
;TODO restore this glorious achievement
;	(if (<= (campaign_metagame_get_player_score (player0)) l_player0_score) (achievement_grant_to_player (player0) "_achievement_be_like_marty"))
;	(if (<= (campaign_metagame_get_player_score (player1)) l_player1_score) (achievement_grant_to_player (player1) "_achievement_be_like_marty"))
;	(if (<= (campaign_metagame_get_player_score (player2)) l_player2_score) (achievement_grant_to_player (player2) "_achievement_be_like_marty"))
;	(if (<= (campaign_metagame_get_player_score (player3)) l_player3_score) (achievement_grant_to_player (player3) "_achievement_be_like_marty"))
	(print "todo fix survival_like_marty_award")
)

;=============================================================================================================================
;============================================ END GAME SCRIPTS ===============================================================
;=============================================================================================================================

(global boolean b_survival_game_end_condition false)
(global boolean b_survival_entered_sudden_death false)
(global long l_sur_round_timer 0)

(script startup survival_round_timer_counter
	; Sleep for 10 seconds to compensate for Bob's pausing the start game timer by 10 sec
	(sleep 300)

	; This is a waste of an HS thread, but I've done worse things
	(sleep_until
		(begin
			(set l_sur_round_timer (+ l_sur_round_timer 1))
			false
		)
		30
	)
)


(script dormant survival_end_game
	; Wake the end condition scripts
	(wake survival_mode_end_condition_lives)
	(wake survival_mode_end_condition_generators)
	(wake survival_mode_end_condition_time)
	(wake survival_mode_end_condition_complete)
	
	; Sleep until one of them has succeeded
	(sleep_until b_survival_game_end_condition 1)
	
	; Make the generators invulnerable the generators
	(object_cannot_take_damage obj_sur_generator0)
	(object_cannot_take_damage obj_sur_generator1)
	(object_cannot_take_damage obj_sur_generator2)
	
	; Kill the remaining end condtion scripts
	(sleep_forever survival_mode_end_condition_lives)
	(sleep_forever survival_mode_end_condition_generators)
	(sleep_forever survival_mode_end_condition_time)
	
	; Kill remaining survival threads 
	(sleep_forever survival_mode)
	(sleep_forever survival_bonus_round_end)
	(sleep_forever survival_lives_announcement)
	(sleep_forever survival_award_achievement)
	(sleep_forever survival_mode_generator_defense)
		
	; Turn off all music 
	(sound_looping_stop m_final_wave)
	(sleep 30)
	
	(sleep 90)
	
	; Last round?
	;(if (>= (+ (survival_mode_get_mp_round_current) 1) (survival_mode_get_mp_round_count))
	;	(event_survival_game_over)
	;	(event_survival_round_over)
	;)
	
	;(sleep 90)
	;(fade_out 0 0 0 60)
	;(sleep 60)
	
	; end game 
	(mp_round_end_with_winning_team none)
)


(script dormant survival_mode_end_condition_lives
	(sleep_until
		(and
			b_survival_human_spawned				; Can't end before a human has even spawned
			(= b_sur_bonus_round_running FALSE)		; Never succeed during a bonus round
			(survival_players_dead)					; Players are all dead
			(survival_players_not_respawning)		; Players are not going to respawn (out of lives, respawn on wave, etc.)
		)
		10
	)

	; Players are out of lives. Classic end condition
	(sleep 30)
	
	; Elites win, Spartans lose
	(survival_elites_increment_score)
	(event_survival_elites_win_normal)
		
	; Set the flag so that the main end condition can progress
	(set b_survival_game_end_condition true)
)


(script dormant survival_mode_end_condition_generators
	(sleep_until
		; Has generator defense failed?
		b_sur_generator_defense_fail
		10
	)

	; Generator Defense has failed.
	(sleep 30)
	
	; Elites win, Spartans lose.
	(survival_elites_increment_score)
	(event_survival_elites_win_gen)
		
	; Set the flag so that the main end condition can progress
	(set b_survival_game_end_condition true)
)


(script dormant survival_mode_end_condition_time
	(sleep_until
		; Have they run out of time in non bonus round?
		(and
			(= b_sur_bonus_round_running FALSE)
			(> (survival_mode_get_time_limit) 0)
			(>= l_sur_round_timer (* (survival_mode_get_time_limit) 60))
		)
		10
	)

	; Time is up. Sudden death?
	(if (survival_sudden_death_condition)
		; Enter sudden death. This blocks as long as is needed
		(survival_sudden_death)
	)
	
	; Short circuit the generator failed condition
	(sleep_forever survival_mode_end_condition_generators)
			
	; Has generator defense failed?
	(if b_sur_generator_defense_fail
		(begin
			; Elites win, Spartans lose
			; Increment score
			(survival_elites_increment_score)
			(event_survival_elites_win_gen)
		)

		; It wasn't a generator defense fail, so:
		(begin
			; Spartans win, Elites lose
			; Increment score
			(survival_spartans_increment_score)
			(event_survival_spartans_win_gen)
			(submit_incident "survival_mm_game_complete")
		)
	)
	
	; Set the flag so that the main end condition can progress
	(set b_survival_game_end_condition true)
)


(script dormant survival_mode_end_condition_complete
	(sleep_until
		; Have we completed enough waves?
		(and
			(> (survival_mode_get_set_count) 0)
			(>= s_survival_wave_complete_count (survival_mode_get_set_count))
		)
		10
	)

	; Waves completed
	(sleep 30)
	
	; Spartans win, Elites lose
	; Increment score
	(survival_spartans_increment_score)
	(event_survival_spartans_win_normal)
	(submit_incident "survival_mm_game_complete")
	
	; Set the flag so that the main end condition can progress
	(set b_survival_game_end_condition true)
)


(script static void survival_sudden_death
	; Enter sudden death
	(event_survival_sudden_death)
	(survival_mode_sudden_death true)
	(set b_survival_entered_sudden_death true)	
	
	; Lock the generators that exist
	(device_set_power obj_sur_generator_switch0 0)
	(device_set_power obj_sur_generator_switch1 0)
	(device_set_power obj_sur_generator_switch2 0)
	
	; Sleep until sudden death no longer in effect or 1 minute
	(sleep_until (not (survival_sudden_death_condition)) 2 1800)
	
	; Sudden death over
	(event_survival_sudden_death_over)
	(sleep 30)
	
	; End sudden death, sleep 5 seconds (grace period)
	(survival_mode_sudden_death false)
	(sleep 150)
)


(script static boolean survival_sudden_death_condition
	(or
		; Generator alive and closed?
		(and
			(> (object_get_health generator0) 0)
			(> (device_get_position generator0) 0)
		)
		; Generator alive and closed?
		(and
			(> (object_get_health generator1) 0)
			(> (device_get_position generator1) 0)
		)
		; Generator alive and closed?
		(and
			(> (object_get_health generator2) 0)
			(> (device_get_position generator2) 0)
		)
	)
)


(script static void survival_spartans_increment_score
	(survival_increment_human_score (human_player_in_game_get 0))
	(survival_increment_human_score (human_player_in_game_get 1))
	(survival_increment_human_score (human_player_in_game_get 2))
	(survival_increment_human_score (human_player_in_game_get 3))
	(survival_increment_human_score (human_player_in_game_get 4))
	(survival_increment_human_score (human_player_in_game_get 5))
)


(script static void survival_elites_increment_score
	(survival_increment_elite_score (elite_player_in_game_get 0))
	(survival_increment_elite_score (elite_player_in_game_get 1))
	(survival_increment_elite_score (elite_player_in_game_get 2))
	(survival_increment_elite_score (elite_player_in_game_get 3))
	(survival_increment_elite_score (elite_player_in_game_get 4))
	(survival_increment_elite_score (elite_player_in_game_get 5))
)


(script static boolean survival_players_dead
	(<= (players_human_living_count) 0)
)


; This script returns true if the players are:
;	Out of Lives
; 	Set to respawn on wave, and have been dead and waiting for >5 seconds
(script static boolean survival_players_not_respawning
	(or 
		(= (survival_mode_lives_get player) 0)				; NOTE: This assumes that you can never go into negative lives. -1 corresponds to infinite lives.
		(and
			(survival_mode_team_respawns_on_wave player)
			(>= g_survival_all_dead_seconds 5)
		)
	)
)


(global short g_survival_all_dead_seconds 0)
(script dormant survival_all_dead_timer
	(if (survival_mode_team_respawns_on_wave player)
		(sleep_until
			(begin
				(if (survival_players_dead)
					(set g_survival_all_dead_seconds (+ g_survival_all_dead_seconds 1))
					(set g_survival_all_dead_seconds 0)
				)
				
				false
			)
			30
		)
	)
)


(script static void survival_refresh_sleep
	(if	(>= (ai_living_count gr_survival_all) 10)
		(cond
			((difficulty_normal)	(sleep (* (random_range 20 30) 30)))
			((difficulty_heroic)	(sleep (* (random_range 10 20) 30)))
			((difficulty_legendary)	(sleep (* (random_range 5 10) 30)))
		)
		(sleep 30)
	)
)


;=============================================================================================================================
;============================================ ELITE MANAGEMENT ===============================================================
;=============================================================================================================================

(script dormant survival_elite_manager
	; Any elites alive?
	(sleep_until (> (players_elite_living_count) 0))
	(if debug (print "starting elite scripts"))
	
	;tysongr - 53954: Adios, fireteams
;*	; Initial setup
	(ai_set_fireteam_absorber ai_sur_fireteam_squad0 1)
	(ai_player_add_fireteam_squad (player_elite 0) ai_sur_fireteam_squad0)
	(ai_player_set_fireteam_max (player_elite 0) 2)
	(ai_player_set_fireteam_max_squad_absorb_distance (player_elite 0) 3.0)
	(ai_set_fireteam_fallback_squad (player_elite 0) ai_sur_remaining)
	
	(ai_set_fireteam_absorber ai_sur_fireteam_squad1 1)
	(ai_player_add_fireteam_squad (player_elite 1) ai_sur_fireteam_squad1)
	(ai_player_set_fireteam_max (player_elite 1) 2)
	(ai_player_set_fireteam_max_squad_absorb_distance (player_elite 1) 3.0)
	(ai_set_fireteam_fallback_squad (player_elite 1) ai_sur_remaining)
	
	(ai_set_fireteam_absorber ai_sur_fireteam_squad2 1)
	(ai_player_add_fireteam_squad (player_elite 2) ai_sur_fireteam_squad2)
	(ai_player_set_fireteam_max (player_elite 2) 2)
	(ai_player_set_fireteam_max_squad_absorb_distance (player_elite 2) 3.0)
	(ai_set_fireteam_fallback_squad (player_elite 2) ai_sur_remaining)
	
	(ai_set_fireteam_absorber ai_sur_fireteam_squad3 1)
	(ai_player_add_fireteam_squad (player_elite 3) ai_sur_fireteam_squad3)
	(ai_player_set_fireteam_max (player_elite 3) 2)
	(ai_player_set_fireteam_max_squad_absorb_distance (player_elite 3) 3.0)
	(ai_set_fireteam_fallback_squad (player_elite 3) ai_sur_remaining)
	
	(ai_set_fireteam_absorber ai_sur_fireteam_squad4 1)
	(ai_player_add_fireteam_squad (player_elite 4) ai_sur_fireteam_squad4)
	(ai_player_set_fireteam_max (player_elite 4) 2)
	(ai_player_set_fireteam_max_squad_absorb_distance (player_elite 4) 3.0)
	(ai_set_fireteam_fallback_squad (player_elite 4) ai_sur_remaining)
	
	(ai_set_fireteam_absorber ai_sur_fireteam_squad5 1)
	(ai_player_add_fireteam_squad (player_elite 5) ai_sur_fireteam_squad5)
	(ai_player_set_fireteam_max (player_elite 5) 2)
	(ai_player_set_fireteam_max_squad_absorb_distance (player_elite 5) 3.0)
	(ai_set_fireteam_fallback_squad (player_elite 5) ai_sur_remaining)
*;
)


(global short s_sur_elite_life_monitor 0)
(script dormant survival_elite_life_monitor
	; Monitor the elite living count. If it drops, award lives to the Humans based on options
	(sleep_until
		(begin
			; Is the current elite living count less than the life monitor?
			(if (< (players_elite_living_count) s_sur_elite_life_monitor)
				; It is, so award lives based on the delta
				(begin
					(survival_mode_add_human_lives (* (- s_sur_elite_life_monitor (players_elite_living_count)) (survival_mode_bonus_lives_elite_death)))
				)
			)
			
			; Update the life monitor
			(set s_sur_elite_life_monitor (players_elite_living_count))
			
			; Loop forever
			false
		)
		1
	)
)


(script static boolean (survival_squad_contains_fireteam (ai squad))
	(and
		(> (ai_living_count squad) 0)
		(= (unit_get_team_index (unit (list_get (ai_actors squad) 0))) -1)
	)
)


;=============================================================================================================================
;============================================ ELITE FIRE TEAMS ===============================================================
;=============================================================================================================================

;tysongr - 53954: Adios, fireteams
;* 
(script continuous survival_elite_fireteams
	; Wait to be activated
	(sleep_forever)
	(if debug (print "temporarily disabling fireteams"))

	; Disable the fireteam absorbers
	(ai_player_set_fireteam_max (player_elite 0) 0)
	(ai_player_set_fireteam_max (player_elite 1) 0)
	(ai_player_set_fireteam_max (player_elite 2) 0)
	(ai_player_set_fireteam_max (player_elite 3) 0)
	(ai_player_set_fireteam_max (player_elite 4) 0)
	(ai_player_set_fireteam_max (player_elite 5) 0)
	
	; Sleep 3 seconds
	(sleep 90)
	
	; Re-enable them
	(ai_player_set_fireteam_max (player_elite 0) 2)
	(ai_player_set_fireteam_max (player_elite 1) 2)
	(ai_player_set_fireteam_max (player_elite 2) 2)
	(ai_player_set_fireteam_max (player_elite 3) 2)
	(ai_player_set_fireteam_max (player_elite 4) 2)
	(ai_player_set_fireteam_max (player_elite 5) 2)
)
*;


;=============================================================================================================================
;============================================ LIVES AND LIVING COUNTS ========================================================
;=============================================================================================================================

; setting the number of lives based on difficulty 
(script static void survival_lives
	(if (< (survival_mode_get_shared_team_life_count) 0)
		(survival_mode_lives_set player -1)
		(survival_mode_lives_set player (survival_mode_get_shared_team_life_count))		
	)
	(if (< (survival_mode_get_elite_life_count) 0)
		(survival_mode_lives_set covenant_player -1)
		(survival_mode_lives_set covenant_player (survival_mode_get_elite_life_count))
	)
)

; TODO every occurrence of survival_mode_lives_set and survival_mode_lives_get needs to be fixed for passing the team index

; adding additional lives as rounds are completed based on difficulty 
; do not add lives for the last round of a set 
(script static void survival_add_lives
	; attempt to award the hero medal 
	(survival_mode_award_hero_medal)
		(sleep 1)
		
	; Respawn dead players 
	(survival_mode_respawn_dead_players)
	(sleep 1)

	; Add the lives if we're not already in infinite lives mode, and we're below the max, add lives and announce
	(if 
		(and
			(>= (survival_mode_lives_get player) 0)
			(< (survival_mode_lives_get player) (survival_mode_max_lives))
		)
		(begin
			(survival_mode_add_human_lives (survival_mode_player_count_by_team player))
			(event_survival_awarded_lives)
		)
	)
)


(script stub void survival_vehicle_cleanup
	(if debug (print "**vehicle cleanup**"))
)

(script static boolean wave_dropship_enabled
	; If the dropship type is 0 (None), then always return false
	(if (!= s_sur_dropship_type 0)
		(survival_mode_current_wave_uses_dropship)
		false
	)
)

(script static short players_human_living_count 
	(list_count (players_human))
)

(script static unit (player_human (short index))
	(if (< index (players_human_living_count))
		(unit (list_get (players_human) index))
		none
	)
)

(script static short players_elite_living_count 
	(list_count (players_elite))
)

(script static unit (player_elite (short index))
	(if (< index (players_elite_living_count))
		(unit (list_get (players_elite) index))
		none
	)
)

(script static void (survival_mode_add_human_lives (short lives))
	; Only add lives if the end condition is not met
	(if (not b_survival_game_end_condition)
		(if (> (survival_mode_max_lives) 0)
			; There is a max lives limit, so cap it at that
			(survival_mode_lives_set player 
				(max
					(min 
						(survival_mode_max_lives) 
						(+ (survival_mode_lives_get player) lives)
					)
					(survival_mode_lives_get player)
				)
			)
			
			; There is no limit, so just add them
			;(survival_mode_lives_set player (+ (survival_mode_lives_get player) lives))
		)
	)
)

(script static void survival_mode_replenish_players
	(unit_set_current_vitality (player_human 0) 80 80)
	(unit_set_current_vitality (player_human 1) 80 80)
	(unit_set_current_vitality (player_human 2) 80 80)
	(unit_set_current_vitality (player_human 3) 80 80)
	(unit_set_current_vitality (player_human 4) 80 80)
	(unit_set_current_vitality (player_human 5) 80 80)
	(unit_set_current_vitality (player_elite 0) 80 80)
	(unit_set_current_vitality (player_elite 1) 80 80)
	(unit_set_current_vitality (player_elite 2) 80 80)
	(unit_set_current_vitality (player_elite 3) 80 80)
	(unit_set_current_vitality (player_elite 4) 80 80)
	(unit_set_current_vitality (player_elite 5) 80 80)
)


;=============================================================================================================================
;================================================== INCIDENT SCRIPTS =========================================================
;=============================================================================================================================

(script static void (submit_incident_for_spartans (string_id incident))
	(submit_incident_with_cause_player incident (human_player_in_game_get 0))
	(submit_incident_with_cause_player incident (human_player_in_game_get 1))
	(submit_incident_with_cause_player incident (human_player_in_game_get 2))
	(submit_incident_with_cause_player incident (human_player_in_game_get 3))
	(submit_incident_with_cause_player incident (human_player_in_game_get 4))
	(submit_incident_with_cause_player incident (human_player_in_game_get 5))
)

(script static void (submit_incident_for_elites (string_id incident))
	(submit_incident_with_cause_player incident (elite_player_in_game_get 0))
	(submit_incident_with_cause_player incident (elite_player_in_game_get 1))
	(submit_incident_with_cause_player incident (elite_player_in_game_get 2))
	(submit_incident_with_cause_player incident (elite_player_in_game_get 3))
	(submit_incident_with_cause_player incident (elite_player_in_game_get 4))
	(submit_incident_with_cause_player incident (elite_player_in_game_get 5))
)

(script static void event_welcome
	(if debug (print "event_welcome"))
	(submit_incident "survival_welcome")
)

(script static void event_intro
	(if debug (print "event_intro"))

	; Announce the appropriate Firefight gametype
	(if (> (survival_mode_generator_count) 0)
		(begin
			(submit_incident_with_cause_campaign_team "sur_gen_unsc_start" player)
			(submit_incident_with_cause_campaign_team "sur_gen_cov_start" covenant_player)
		)
		(begin
			(submit_incident_with_cause_campaign_team "sur_cla_unsc_start" player)
			(submit_incident_with_cause_campaign_team "sur_cla_cov_start" covenant_player)
		)
	)
)

(script static void event_survival_awarded_lives
	(if debug (print "survival_awarded_lives"))
	(submit_incident_with_cause_campaign_team "survival_awarded_lives" player)
)

(script static void event_survival_5_ai_remaining
	(if debug (print "survival_5_ai_remaining"))
	(submit_incident_with_cause_campaign_team "survival_5_ai_remaining" player)
)

(script static void event_survival_2_ai_remaining
	(if debug (print "survival_2_ai_remaining"))
	(submit_incident_with_cause_campaign_team "survival_2_ai_remaining" player)
)

(script static void event_survival_1_ai_remaining
	(if debug (print "survival_1_ai_remaining"))
	(submit_incident_with_cause_campaign_team "survival_1_ai_remaining" player)
)

(script static void event_survival_bonus_round
	(if debug (print "survival_bonus_round"))
	(submit_incident "survival_bonus_round")
)

(script static void event_survival_bonus_round_over
	(if debug (print "survival_bonus_round_over"))
	(submit_incident "survival_bonus_round_over")
)

(script static void event_survival_bonus_lives_awarded
	(if debug (print "survival_bonus_lives_awarded"))
	(submit_incident_with_cause_campaign_team "survival_bonus_lives_awarded" player)
)

(script static void event_survival_better_luck_next_time
	(if debug (print "survival_better_luck_next_time"))
	(submit_incident_with_cause_campaign_team "survival_better_luck_next_time" player)
)

(script static void event_survival_new_set
	(if debug (print "survival_new_set"))
	(submit_incident "survival_new_set")
)

(script static void event_survival_new_round
	(if debug (print "survival_new_round"))
	(submit_incident "survival_new_round")
)

(script static void event_survival_reinforcements
	(if debug (print "survival_reinforcements"))
	(submit_incident "survival_reinforcements")
)

(script static void event_survival_end_round
	(if debug (print "survival_end_round"))
	(submit_incident "survival_end_round")
)

(script static void event_survival_end_set
	(if debug (print "survival_end_set"))
	(submit_incident "survival_end_set")
)

(script static void event_survival_sudden_death
	(if debug (print "sudden_death"))
	(submit_incident "sudden_death")
)

(script static void event_survival_sudden_death_over
	(if debug (print "survival_sudden_death_over"))
	(submit_incident "survival_sudden_death_over")
)

(script static void event_survival_5_lives_left
	(if debug (print "survival_5_lives_left"))
	(submit_incident_with_cause_campaign_team "survival_5_lives_left" player)
)

(script static void event_survival_1_life_left
	(if debug (print "survival_1_life_left"))
	(submit_incident_with_cause_campaign_team "survival_1_life_left" player)
)

(script static void event_survival_0_lives_left
	(if debug (print "survival_0_lives_left"))
	(submit_incident_with_cause_campaign_team "survival_0_lives_left" player)
)

(script static void event_survival_last_man_standing
	(if debug (print "survival_last_man_standing"))
	(submit_incident_with_cause_campaign_team "survival_last_man_standing" player)
)

(script static void event_survival_awarded_weapon
	(if debug (print "survival_awarded_weapon"))
	(submit_incident "survival_awarded_weapon")
)

(script static void event_survival_round_over
	(if debug (print "event_survival_round_over"))
	(submit_incident "round_over")
)

(script static void event_survival_game_over
	(if debug (print "event_survival_game_over"))
	(submit_incident "survival_game_over")
)

(script static void event_survival_generator_died
	(if debug (print "event_survival_generator_died"))
	(submit_incident_with_cause_campaign_team "survival_generator_lost" player)
	(submit_incident_with_cause_campaign_team "survival_generator_destroyed" covenant_player)
)

(global long s_sur_gen0_attack_message_cd 0)
(script static void event_survival_generator0_attacked
	(if (>= (game_tick_get) s_sur_gen0_attack_message_cd)
		(begin
			(if debug (print "event_survival_generator0_attacked"))
			(submit_incident_with_cause_campaign_team "survival_alpha_under_attack" player)
			(set s_sur_gen0_attack_message_cd (+ (game_tick_get) 450))
		)
	)
)

(global long s_sur_gen1_attack_message_cd 0)
(script static void event_survival_generator1_attacked
	(if (>= (game_tick_get) s_sur_gen1_attack_message_cd)
		(begin
			(if debug (print "event_survival_generator1_attacked"))
			(submit_incident_with_cause_campaign_team "survival_bravo_under_attack" player)
			(set s_sur_gen1_attack_message_cd (+ (game_tick_get) 450))
		)
	)
)

(global long s_sur_gen2_attack_message_cd 0)
(script static void event_survival_generator2_attacked
	(if (>= (game_tick_get) s_sur_gen2_attack_message_cd)
		(begin
			(if debug (print "event_survival_generator2_attacked"))
			(submit_incident_with_cause_campaign_team "survival_charlie_under_attack" player)
			(set s_sur_gen2_attack_message_cd (+ (game_tick_get) 450))
		)
	)
)

(script static void event_survival_generator0_locked
	(if debug (print "event_survival_generator0_locked"))
	(submit_incident "gen_alpha_locked")
)

(script static void event_survival_generator1_locked
	(if debug (print "event_survival_generator1_locked"))
	(submit_incident "gen_bravo_locked")
)

(script static void event_survival_generator2_locked
	(if debug (print "event_survival_generator2_locked"))
	(submit_incident "gen_charlie_locked")
)

(script static void event_survival_spartans_win_normal
	(if debug (print "event_survival_spartans_win_normal"))
	(submit_incident_with_cause_campaign_team "sur_gen_unsc_win" player)
	(submit_incident_with_cause_campaign_team "sur_cla_cov_fail" covenant_player)
)

(script static void event_survival_elites_win_normal
	(if debug (print "event_survival_elites_win_normal"))
	(submit_incident_with_cause_campaign_team "sur_cla_unsc_fail" player)
	(submit_incident_with_cause_campaign_team "sur_cov_win" covenant_player)
)

(script static void event_survival_spartans_win_gen
	(if debug (print "event_survival_spartans_win_gen"))
	(submit_incident_with_cause_campaign_team "sur_gen_unsc_win" player)
	(submit_incident_with_cause_campaign_team "sur_gen_cov_fail" covenant_player)
)

(script static void event_survival_elites_win_gen
	(if debug (print "event_survival_elites_win_gen"))
	(submit_incident_with_cause_campaign_team "sur_gen_unsc_fail" player)
	(submit_incident_with_cause_campaign_team "sur_cov_win" covenant_player)
)

(script static void event_survival_time_up
	(if debug (print "event_survival_time_up"))
	(submit_incident_with_cause_campaign_team "sur_unsc_timeout" player)
	(submit_incident_with_cause_campaign_team "sur_cov_timeout" covenant_player)
)


;=============================================================================================================================
;============================================ AMMO CRATES ====================================================================
;=============================================================================================================================

(script dormant survival_ammo_crate_create
	(if (survival_mode_ammo_crates_enable)
		(begin
			(object_create_anew obj_ammo_crate0)
			(object_create_anew obj_ammo_crate1)
		)
	)
)


(script dormant survival_ammo_crate_waypoint
	(if (survival_mode_ammo_crates_enable)
		(begin
			(object_create_anew obj_ammo_crate0)
			(object_create_anew obj_ammo_crate1)
			(chud_track_object_with_priority obj_ammo_crate0 13)
			(chud_track_object_with_priority obj_ammo_crate1 13)
			(sleep 450)
			(chud_track_object obj_ammo_crate0 false)
			(chud_track_object obj_ammo_crate1 false)
		)
	)
)


;=============================================================================================================================
;============================================ HEALTH PACKS ===================================================================
;=============================================================================================================================

(script static void (survival_health_pack_highlight (device_name pack) (unit subject))
	(if 
		(or
			(< (object_get_health pack) 0)
			(< (object_get_health subject) 0)
			(> (object_get_health subject) 0.66600) ; Don't show if the player is in the range where he will regenerate naturally
			(> (objects_distance_to_object pack subject) 3)
		)
		
		; Un-track it
		(begin
			(chud_track_object_for_player subject pack false)
		)
		
		; Track it
		(begin
			(chud_track_object_for_player_with_priority subject pack 21)
		)			
	)
)

(script dormant survival_health_pack_hud
	(sleep_until
		(begin
			(survival_health_pack_highlight health_pack0 (human_player_in_game_get 0))
			(survival_health_pack_highlight health_pack0 (human_player_in_game_get 1))
			(survival_health_pack_highlight health_pack0 (human_player_in_game_get 2))
			(survival_health_pack_highlight health_pack0 (human_player_in_game_get 3))
		
			(survival_health_pack_highlight health_pack1 (human_player_in_game_get 0))
			(survival_health_pack_highlight health_pack1 (human_player_in_game_get 1))
			(survival_health_pack_highlight health_pack1 (human_player_in_game_get 2))
			(survival_health_pack_highlight health_pack1 (human_player_in_game_get 3))
		
			(survival_health_pack_highlight health_pack2 (human_player_in_game_get 0))
			(survival_health_pack_highlight health_pack2 (human_player_in_game_get 1))
			(survival_health_pack_highlight health_pack2 (human_player_in_game_get 2))
			(survival_health_pack_highlight health_pack2 (human_player_in_game_get 3))
		
			(survival_health_pack_highlight health_pack3 (human_player_in_game_get 0))
			(survival_health_pack_highlight health_pack3 (human_player_in_game_get 1))
			(survival_health_pack_highlight health_pack3 (human_player_in_game_get 2))
			(survival_health_pack_highlight health_pack3 (human_player_in_game_get 3))
		
			(survival_health_pack_highlight health_pack4 (human_player_in_game_get 0))
			(survival_health_pack_highlight health_pack4 (human_player_in_game_get 1))
			(survival_health_pack_highlight health_pack4 (human_player_in_game_get 2))
			(survival_health_pack_highlight health_pack4 (human_player_in_game_get 3))
		
			(survival_health_pack_highlight health_pack5 (human_player_in_game_get 0))
			(survival_health_pack_highlight health_pack5 (human_player_in_game_get 1))
			(survival_health_pack_highlight health_pack5 (human_player_in_game_get 2))
			(survival_health_pack_highlight health_pack5 (human_player_in_game_get 3))
			
			false
		)
		15
	)
)


;=============================================================================================================================
;============================================ WEAPON DROPS ===================================================================
;=============================================================================================================================

(global boolean b_survival_mode_weapon_drop false)
(script static boolean survival_mode_should_drop_weapon
	(and
		; Always return false if weapon drops are disabled
		(survival_mode_weapon_drops_enable)
		
		; Otherwise, return true if the boolean is set to true
		; This is a neat trick that will get someone in trouble some day! :)
		(if b_survival_mode_weapon_drop
			(begin
				(set b_survival_mode_weapon_drop false)
				true
			)
			false
		)
	)	
)


;=============================================================================================================================
;========================================== FOLLOW LOD SCRIPT ================================================================
;=============================================================================================================================

;here is the command script that will keep AI in the follow task from being LOD'd out.
(script command_script cs_lod
	(ai_force_full_lod ai_current_actor)
)


;=============================================================================================================================
;============================================ BEDLAM = OH SHI ================================================================
;=============================================================================================================================

(global boolean g_survival_bedlam false)
(global boolean g_survival_bedlam_brute true)
(script static boolean survival_mode_bedlam
	(= g_survival_bedlam true)
)

(script static team survival_mode_get_bedlam_team
	(if g_survival_bedlam_brute
		(begin
			(set g_survival_bedlam_brute false)
			brute
		)
		(begin
			(set g_survival_bedlam_brute true)
			mule
		)
	)
)

(script static void survival_mode_set_bedlam_teams
	(if (> (wave_squad_get_count 0) 0) (ai_set_team (wave_squad_get 0) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 1) 0) (ai_set_team (wave_squad_get 1) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 2) 0) (ai_set_team (wave_squad_get 2) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 3) 0) (ai_set_team (wave_squad_get 3) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 4) 0) (ai_set_team (wave_squad_get 4) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 5) 0) (ai_set_team (wave_squad_get 5) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 6) 0) (ai_set_team (wave_squad_get 6) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 7) 0) (ai_set_team (wave_squad_get 7) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 8) 0) (ai_set_team (wave_squad_get 8) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 9) 0) (ai_set_team (wave_squad_get 9) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 10) 0) (ai_set_team (wave_squad_get 10) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 11) 0) (ai_set_team (wave_squad_get 11) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 12) 0) (ai_set_team (wave_squad_get 12) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 13) 0) (ai_set_team (wave_squad_get 13) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 14) 0) (ai_set_team (wave_squad_get 14) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 15) 0) (ai_set_team (wave_squad_get 15) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 16) 0) (ai_set_team (wave_squad_get 16) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 17) 0) (ai_set_team (wave_squad_get 17) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 18) 0) (ai_set_team (wave_squad_get 18) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 19) 0) (ai_set_team (wave_squad_get 19) (survival_mode_get_bedlam_team)))
	(if (> (wave_squad_get_count 20) 0) (ai_set_team (wave_squad_get 20) (survival_mode_get_bedlam_team)))
)



;=============================================================================================================================
;============================================ TEST SCRIPTS ===================================================================
;=============================================================================================================================

(script dormant test_ai_erase_fast
	(sleep_until
		(begin
			(sleep_until (>= (ai_living_count gr_survival_all) 1) 1)
			(sleep 5)
			(ai_erase_all)
		FALSE)
	1)
)
(script dormant test_ai_erase
	(sleep_until
		(begin
			(sleep_until (>= (ai_living_count gr_survival_all) 1) 1)
			(sleep 30)
			(ai_erase_all)
		FALSE)
	1)
)
(script dormant test_ai_erase_slow
	(sleep_until
		(begin
			(sleep_until (>= (ai_living_count gr_survival_all) 1) 1)
			(sleep 150)
			(ai_erase_all)
		FALSE)
	1)
)

(script static void test_award_500
	(campaign_metagame_award_points (player0) 500)
)
(script static void test_award_1000
	(campaign_metagame_award_points (player0) 1000)
)
(script static void test_award_5000
	(campaign_metagame_award_points (player0) 5000)
)
(script static void test_award_10000
	(campaign_metagame_award_points (player0) 10000)
)
(script static void test_award_20000
	(campaign_metagame_award_points (player0) 20000)
)
(script static void test_award_30000
	(campaign_metagame_award_points (player0) 30000)
)

(script static void test_4_player
	(set k_sur_squad_per_wave_limit 6)
	(set k_phantom_spawn_limit 2)
)


(script static short (test_wave_template (short index))
	(ai_place_wave index ai_sur_wave_spawns s_sur_wave_squad_count)
	(ai_living_count ai_sur_wave_spawns)
)




