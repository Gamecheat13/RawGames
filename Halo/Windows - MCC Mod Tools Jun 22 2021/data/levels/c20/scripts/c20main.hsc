;   Script:		Halo Mission C20
; Synopsis:		Four stacked floors, branching off a main shaft.
;					Flood vs Player, Flood vs Sentinel encounters.

;- History ---------------------------------------------------------------------

; 05/17/01 - Initial version (Tyson)
; 06/18/01 - Initial pass complete (Tyson)


;- Globals ---------------------------------------------------------------------

; Print useful debugging text
(global boolean debug false)

; Is it coop?
(global boolean coop false)

; Spawn wave parameters
(global real spawn_scale 1.0)				; Scales total spawn counts
(global short min_combat_spawn 2)		; Minimum number of combats in a spawn wave
(global short min_carrier_spawn 2)		; Minimum number of carriers in a spawn wave
(global short min_infection_spawn 7)	; Minimum number of infections in a spawn wave

; Flood spawn wave limiters
(global short enc4_limiter 0)
(global short enc7_limiter 0)
(global short enc1_9_limiter 0)
(global short enc2_0_limiter 0)
(global short enc2_4_limiter 0)
(global short enc2_9_limiter 0)
(global short enc2_11_limiter 0)
(global short enc3_4_limiter 0)
(global short enc3_6_limiter 0)
(global short enc4_0_limiter 0)
(global short enc4_3_limiter 0)
(global short enc4_6_limiter 0)
(global short enc4_8_limiter 0)
(global short enc5_3_limiter 0)
(global short enc5_5_limiter 0)
(global short enc6_2_limiter 0)
(global short enc6_4_limiter 0)
(global short enc6_7_limiter 0)
(global short enc6_8_limiter 0)
(global short enc7_3_limiter 0)
(global short enc7_5_limiter 0)

; Door counters
(global short floor3_door2_count 0)
(global short floor4_door2_count 0)

; Magic numbers
(global short hud_objectives_display_time 90)
(global short testing_save 5)
(global short testing_fast 5)
(global real door_open .85)


;- Chapter Breaks --------------------------------------------------------------

(script static void chapter_c20_1
	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_c20_1)
	(sleep 150)
)

(script static void chapter_c20_2
	; Remove control
	(show_hud false)
	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_c20_2)
	(sleep 150)

	; Return control
	(cinematic_show_letterbox false)
	(show_hud true)
)

(script static void chapter_c20_3
	; Remove control
	(show_hud false)
	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_c20_3)
	(sleep 30)
	(cinematic_set_title chapter_c20_3b)
	(sleep 30)
	(cinematic_set_title chapter_c20_3c)
	(sleep 120)

	; Return control
	(cinematic_show_letterbox false)
	(show_hud true)
)

(script static void chapter_c20_4
	; Remove control
	(show_hud false)
	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_c20_4)
	(sleep 150)

	; Return control
	(cinematic_show_letterbox false)
	(show_hud true)
)


;- Game Save Checks ------------------------------------------------------------

; Save loop
(global boolean save_now false)
(script continuous save_loop
	(sleep_until save_now testing_save)
	(sleep_until (game_safe_to_save) testing_save)
	(game_save_totally_unsafe)
	(set save_now false)
)

; Certain save subroutine
(script static void certain_save
	(set save_now true)
)

;- Mission Objectives ----------------------------------------------------------

(script static void objective_index
	(show_hud_help_text true)
	(hud_set_help_text obj_index)
	(hud_set_objective_text obj_index)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_follow
	(show_hud_help_text true)
	(hud_set_help_text obj_follow)
	(hud_set_objective_text obj_follow)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_hold
	(show_hud_help_text true)
	(hud_set_help_text obj_hold)
	(hud_set_objective_text obj_hold)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)


;- Game Save Checks ------------------------------------------------------------

; Save checkpoint 1_1
(script static void save_checkpoint1_1
	(sleep_until (volume_test_objects tv_save_checkpoint1 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "02")
)


; Save checkpoint 1_2
(script static void save_checkpoint1_2
	(sleep_until (volume_test_objects tv_save_checkpoint2 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "03")
)


; Save checkpoint 1_3
(script static void save_checkpoint1_3
	(sleep_until (volume_test_objects tv_save_checkpoint3 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "04")
)


; Save checkpoint 1_4
(script static void save_checkpoint1_4
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint4 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "05")
)


; Save checkpoint 1_5
(script static void save_checkpoint1_5
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint5 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "06")
)


; Save checkpoint 2_1
(script static void save_checkpoint2_1
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint2_1 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "07")
)


; Save checkpoint 2_2
(script static void save_checkpoint2_2
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint2_2 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "08")
)


; Save checkpoint 2_3
(script static void save_checkpoint2_3
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint2_3 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "09")
)


; Save checkpoint 2_4
(script static void save_checkpoint2_4
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint2_4 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "10")
)


; Save checkpoint 3_1
(script static void save_checkpoint3_1
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint3_1 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "11")
)


; Save checkpoint 3_2
(script static void save_checkpoint3_2
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint3_2 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "12")
)


; Save checkpoint 3_3
(script static void save_checkpoint3_3
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint3_3 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "13")
)


; Save checkpoint 3_4
(script static void save_checkpoint3_4
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint3_4 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "14")
)


; Save checkpoint 3_5
(script static void save_checkpoint3_5
	; Sleep until its time to save
	(sleep_until (volume_test_objects tv_save_checkpoint3_5 (players)) 15)
	(certain_save) 
   (mcc_mission_segment "15")
)


; Save checkpoint 4_1
(script static void save_checkpoint4_1
	; Sleep until its time to save
	(sleep_until (volume_test_objects enc7_4_trigger (players)) 15)
	(certain_save) 
   (mcc_mission_segment "16")
)


; Save checkpoint 4_2
(script static void save_checkpoint4_2
	; Sleep until its time to save
	(sleep_until (volume_test_objects enc7_9_trigger (players)) 15)
	(certain_save) 
   (mcc_mission_segment "17")
)


; Save checkpoint thread script
(script dormant save_checkpoints
	; Debug text
	(if debug (print "Save Checkpoints Running..."))

	; Go through the checkpoints in order. Each checkpoint blocks appropriately
	(save_checkpoint1_1)
	(save_checkpoint1_2)
	(save_checkpoint1_3)
	(save_checkpoint1_4)
	(save_checkpoint1_5)
	(save_checkpoint2_1)
	(save_checkpoint2_2)
	(save_checkpoint2_3)
	(save_checkpoint2_4)
	(save_checkpoint3_1)
	(save_checkpoint3_2)
	(save_checkpoint3_3)
	(save_checkpoint3_4)
	(save_checkpoint3_5)
	(save_checkpoint4_1)
	(save_checkpoint4_2)
)


;- Fall Killerz ----------------------------------------------------------------

(script continuous fall_killerz
	(if (volume_test_object fall_killer1 (list_get (players) 0))
		(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 0))
	)
	(if (volume_test_object fall_killer2 (list_get (players) 0))
		(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 0))
	)
	(if (volume_test_object fall_killer3 (list_get (players) 0))
		(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 0))
	)
	(if (volume_test_object fall_killer4 (list_get (players) 0))
		(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 0))
	)
	(if (volume_test_object fall_killer5 (list_get (players) 0))
		(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 0))
	)

	(if coop
		(begin
			(if (volume_test_object fall_killer1 (list_get (players) 1))
				(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 1))
			)
			(if (volume_test_object fall_killer2 (list_get (players) 1))
				(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 1))
			)
			(if (volume_test_object fall_killer3 (list_get (players) 1))
				(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 1))
			)
			(if (volume_test_object fall_killer4 (list_get (players) 1))
				(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 1))
			)
			(if (volume_test_object fall_killer5 (list_get (players) 1))
				(damage_object "effects\damage effects\guaranteed plummet to untimely death" (list_get (players) 1))
			)
		)
	)
	
	(sleep 5)
)


;- Platform Controls -----------------------------------------------------------

(script continuous platforms
	; Is the player in platform 1?
	(if 
		(or
			; Short circuit: a player is at the top of the lift, so stay up there
			(volume_test_objects tv_platform1_top (players))
		
			; If no players at the top of the lift
			(and
				; Short circuit test
				(volume_test_objects tv_platform1 (players))
				; Check for players on lift
				(or
					(volume_test_objects plat1_vol1 (players))
					(volume_test_objects plat1_vol2 (players))
					(volume_test_objects plat1_vol3 (players))
					(volume_test_objects plat1_vol4 (players))
				)
			)
		)
		; Raise it if the conditions are met, lower otherwise
		(device_set_position platform1 1)
		(begin
			(if (> (device_get_position platform1) 0.9) (sleep 90))
			(device_set_position platform1 0)
		)
	)
	
	; Is the player in platform 2?
	(if 
		(or
			; Short circuit: a player is at the top of the lift, so stay up there
			(volume_test_objects tv_platform2_top (players))
		
			; If no players at the top of the lift
			(and
				; Short circuit test
				(volume_test_objects tv_platform2 (players))
				; Check for players on lift
				(or
					(volume_test_objects plat2_vol1 (players))
					(volume_test_objects plat2_vol2 (players))
					(volume_test_objects plat2_vol3 (players))
					(volume_test_objects plat2_vol4 (players))
				)
			)
		)
		; Raise it if the conditions are met, lower otherwise
		(device_set_position platform2 1)
		(begin
			(if (> (device_get_position platform2) 0.9) (sleep 90))
			(device_set_position platform2 0)
		)
	)
	
	; Is the player in platform 3?
	(if 
		(or
			; Short circuit: a player is at the top of the lift, so stay up there
			(volume_test_objects tv_platform3_top (players))
		
			; If no players at the top of the lift
			(and
				; Short circuit test
				(volume_test_objects tv_platform3 (players))
				; Check for players on lift
				(or
					(volume_test_objects plat3_vol1 (players))
					(volume_test_objects plat3_vol2 (players))
					(volume_test_objects plat3_vol3 (players))
					(volume_test_objects plat3_vol4 (players))
				)
			)
		)
		; Raise it if the conditions are met, lower otherwise
		(device_set_position platform3 1)
		(begin
			(if (> (device_get_position platform3) 0.9) (sleep 90))
			(device_set_position platform3 0)
		)
	)
	
	; Sleep
	(sleep 30)
)


;- Door Counters ---------------------------------------------------------------

; Floor 4 Door 3 counter script
(script continuous floor4_door2_counter
	; Sleep
	(sleep 30)
	
	; Tick
	(if (volume_test_objects enc7_5_trigger (players))
		; Player is near the door. Increment by 3
		(set floor4_door2_count (+ floor4_door2_count 3))
		
		; Player is not near the door. Increment by 1
		(set floor4_door2_count (+ floor4_door2_count 1))
	)		
)


; Floor 3 Door 2 counter script
(script continuous floor3_door2_counter
	; Sleep
	(sleep 30)
	
	; Tick
	(if (volume_test_objects enc5_5_trigger (players))
		; Player is near the door. Increment by 3
		(set floor3_door2_count (+ floor3_door2_count 3))
		
		; Player is not near the door. Increment by 1
		(set floor3_door2_count (+ floor3_door2_count 1))
	)		
)


; Stun counter scripts
(script dormant stun_door_counters
	; Debug
	(if debug (print "Stunning door counters..."))

	; Stun 'em
	(sleep -1 floor3_door2_counter)
	(sleep -1 floor4_door2_counter)
)


;- Spawn Wave Encounters -------------------------------------------------------

; Enc 7_12 manager
(global short enc7_12_limiter 0)
(script continuous enc7_12_spawner
	; Sleep until the spawn count is low enough
	(sleep_until 
		(and
			(<= enc7_12_limiter (* 40 spawn_scale))
			(<= (ai_nonswarm_count enc7_12) (* min_combat_spawn 2))
		)
	)
			
	; Based on location, spawn
	(if (volume_test_objects_all enc7_12a (players))
		(begin
			(ai_spawn_actor enc7_12/squadC)
			(ai_spawn_actor enc7_12/squadD)
;			(ai_place enc7_12/infsB)
			(set enc7_12_limiter (+ enc7_12_limiter 2))
		)
	)
	(if (volume_test_objects_all enc7_12b (players))
		(begin
			(ai_spawn_actor enc7_12/squadA)
			(ai_spawn_actor enc7_12/squadD)
			(set enc7_12_limiter (+ enc7_12_limiter 2))
		)
	)
	(if (volume_test_objects_all enc7_12c (players))
		(begin
			(ai_spawn_actor enc7_12/squadA)
			(ai_spawn_actor enc7_12/squadB)
;			(ai_place enc7_12/infsA)
			(set enc7_12_limiter (+ enc7_12_limiter 2))
		)
	)
)


; Encounter 7_5 spawn wave
(script continuous enc7_5_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc7_5_trigger (players))
			(< enc7_5_limiter (* 30 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc7_5/combats) (* 1.5 min_combat_spawn))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc7_5/combats)
					(set enc7_5_limiter (+ enc7_5_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc7_5/carriers) (* 1.5 min_carrier_spawn))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc7_5/carriers)
					(set enc7_5_limiter (+ enc7_5_limiter 1))
				)
			)
		)
	)	 
)


; Encounter 7_3 spawn wave
(script continuous enc7_3_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc7_3_trigger (players))
			(< enc7_3_limiter (* 30 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		; Check the combat form count. If it is too low, spawn
		(if (< (ai_living_count enc7_3/combats) (* min_combat_spawn 2))
			; Spawn 'em and increment the count
			(begin 
				(ai_spawn_actor enc7_3/combats)
				(set enc7_3_limiter (+ enc7_3_limiter 1))
			)
		)
	)	 
)


; Encounter 6_8 spawn wave
(script continuous enc6_8_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects tv_platform3 (players))
			(< enc6_8_limiter (* 15 spawn_scale))
			(> (device_group_get platform3) .4)
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc6_8/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc6_8/combats)
					(set enc6_8_limiter (+ enc6_8_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc6_8/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc6_8/carriers)
					(set enc6_8_limiter (+ enc6_8_limiter 1))
				)
			)
		)
	)	 
	
	; Sleep 
	(sleep 30)
)


; Encounter 6_7 spawn wave
(script continuous enc6_7_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc6_7_trigger (players))
			(< enc6_7_limiter (* 40 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		; Check the combat form count. If it is too low, spawn
		(if (< (ai_living_count enc6_7/carriers) (* min_carrier_spawn 1.5))
			; Spawn 'em and increment the count
			(begin 
				(ai_spawn_actor enc6_7/carriers)
				(set enc6_7_limiter (+ enc6_7_limiter 1))
			)
		)
	)	 
)


; Encounter 6_4 spawn wave
(script continuous enc6_4_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc6_4b_trigger (players))
			(< enc6_4_limiter (* 40 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin
		
		; Check the combat form count. If it is too low, spawn
		(if (< (ai_living_count enc6_4/combats) (* min_combat_spawn 2))
			; Spawn 'em and increment the count
			(begin 
				(ai_spawn_actor enc6_4/combats)
				(set enc6_4_limiter (+ enc6_4_limiter 1))
			)
		)
		; Check the infection form count. If it is too low, spawn
		(if (< (ai_living_count enc6_4/infs) min_infection_spawn)
			; Spawn 'em and increment the count
			(ai_place enc6_4/infs)
		)
		)
	)	 
)


; Encounter 6_2b spawn wave
(script continuous enc6_2b_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc6_2b_trigger (players))
			(< enc6_2_limiter (* 15 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc6_2b/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc6_2b/combats)
					(set enc6_2_limiter (+ enc6_2_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc6_2b/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc6_2b/carriers)
					(set enc6_2_limiter (+ enc6_2_limiter 1))
				)
			)
		)
	)	 
	
	; Sleep
	(sleep 30)
)


; Encounter 6_2 spawn wave
(script continuous enc6_2_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc6_2_trigger (players))
			(< enc6_2_limiter (* 15 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc6_2/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc6_2/combats)
					(set enc6_2_limiter (+ enc6_2_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc6_2/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc6_2/carriers)
					(set enc6_2_limiter (+ enc6_2_limiter 1))
				)
			)
		)
	)	 
	
	; Sleep
	(sleep 30)
)


; Encounter 5_5 spawn wave
(script continuous enc5_5_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc5_5_trigger (players))
			(< enc5_5_limiter (* 30 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		; Check the carrier form count. If it is too low, spawn
		(if (< (ai_living_count enc5_5/carriers) (* min_carrier_spawn 3))
			; Spawn 'em and increment the count
			(begin 
				(ai_spawn_actor enc5_5/carriers)
				(ai_magically_see_players enc5_5/carriers)
				(set enc5_5_limiter (+ enc5_5_limiter 1))
			)
		)
	)	 
)


; Encounter 5_3 spawn wave
(script continuous enc5_3_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc5_3_trigger (players))
			(< enc5_3_limiter (* 20 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc5_3b/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc5_3b/combats)
					(ai_magically_see_players enc5_3b/combats)
					(set enc5_3_limiter (+ enc5_3_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc5_3b/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc5_3b/carriers)
					(ai_magically_see_players enc5_3b/carriers)
					(set enc5_3_limiter (+ enc5_3_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 30)
)


; Encounter 4_8 spawn wave
(script continuous enc4_8_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc4_8_trigger (players))
			(< enc4_8_limiter (* 20 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc4_8/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_8/combats)
					(ai_magically_see_players enc4_8/combats)
					(set enc4_8_limiter (+ enc4_8_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc4_8/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_8/carriers)
					(ai_magically_see_players enc4_8/carriers)
					(set enc4_8_limiter (+ enc4_8_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 15)
)


; Encounter 4_6 spawn wave
(script continuous enc4_6_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc4_6_trigger (players))
			(< enc4_6_limiter (* 20 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc4_6/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_6/combats)
					(ai_magically_see_players enc4_6/combats)
					(set enc4_6_limiter (+ enc4_6_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc4_6/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_6/carriers)
					(ai_magically_see_players enc4_6/carriers)
					(set enc4_6_limiter (+ enc4_6_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 15)
)


; Encounter 4_3 spawn wave
(script continuous enc4_3_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc4_3_trigger (players))
			(< enc4_3_limiter (* 20 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc4_3/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_3/combats)
					(ai_magically_see_players enc4_3/combats)
					(set enc4_3_limiter (+ enc4_3_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc4_3/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_3/carriers)
					(ai_magically_see_players enc4_3/carriers)
					(set enc4_3_limiter (+ enc4_3_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 15)
)


; Encounter 4_0 spawn wave
(script continuous enc4_0_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc4_0 (players))
			(< enc4_0_limiter (* 6 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		; Check the infection form count. If it is too low, spawn
		(if (< (ai_living_count enc4_0) 20)
			; Spawn 'em and increment the count
			(begin 
				(ai_place enc4_0)
				(set enc4_0_limiter (+ enc4_0_limiter 1))
			)
		)
	)	 
)


; Encounter 3_6 spawn wave
(script continuous enc3_6_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc3_6b_trigger (players))
			(< enc3_6_limiter (* 2 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		; Check the infection form count. If it is too low, spawn
		(if (< (ai_living_count enc3_6_flood/infs) 20)
			; Spawn 'em and increment the count
			(begin 
				(ai_place enc3_6_flood/infs)
				(set enc3_6_limiter (+ enc3_6_limiter 1))
			)
		)
	)	 
)


; Encounter 3_4 spawn wave
(script continuous enc3_4_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc3_4_trigger (players))
			(< enc3_4_limiter (* 30 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc3_4/combats) (* 1.25 min_combat_spawn))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_4/combats)
					(ai_magically_see_players enc3_4/combats)
					(set enc3_4_limiter (+ enc3_4_limiter 2))
					
					; Spawn a leaper if you can
					(if (volume_test_objects_all enc3_4b (players))
						(ai_spawn_actor enc3_4/leapers)
						(ai_spawn_actor enc3_4/runners)
					)
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc3_4/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_4/carriers)
					(ai_magically_see_players enc3_4/carriers)
					(set enc3_4_limiter (+ enc3_4_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 30)
)


; Encounter 2.11 spawn wave
(script continuous enc2_11_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc2_11_trigger (players))
			(< enc2_11_limiter (* 20 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc2_11/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc2_11/combats)
					(set enc2_11_limiter (+ enc2_11_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc2_11/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc2_11/carriers)
					(set enc2_11_limiter (+ enc2_11_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 15)
)


; Encounter 2.9 spawn wave
(script continuous enc2_9_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc2_9_trigger (players))
			(< enc2_9_limiter (* 20 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc2_9/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc2_9/combats)
					(set enc2_9_limiter (+ enc2_9_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc2_9/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc2_9/carriers)
					(set enc2_9_limiter (+ enc2_9_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 30)
)


; Encounter 2.4 spawn wave
(script continuous enc2_4_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc2_4_trigger (players))
			(< enc2_4_limiter (* 20 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc2_4/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc2_4/combats)
					(set enc2_4_limiter (+ enc2_4_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc2_4/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc2_4/carriers)
					(set enc2_4_limiter (+ enc2_4_limiter 1))
				)
			)
		)
	)	 
)


; Encounter 2_0 spawn wave
(script continuous enc2_0_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc2_0_trigger (players))
			(< enc2_0_limiter (* 6 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		; Check the infection form count. If it is too low, spawn
		(if (< (ai_living_count enc2_0) 20)
			; Spawn 'em and increment the count
			(begin 
				(ai_place enc2_0)
				(set enc2_0_limiter (+ enc2_0_limiter 1))
			)
		)
	)	 
)


; Encounter 1_9 spawn wave
(script continuous enc1_9_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc1_9_trigger (players))
			(< enc1_9_limiter (* 6 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		; Check the infection form count. If it is too low, spawn
		(if (< (ai_living_count enc1_9) 20)
			; Spawn 'em and increment the count
			(begin 
				(ai_place enc1_9)
				(set enc1_9_limiter (+ enc1_9_limiter 1))
			)
		)
	)	 
)


; Encounter 7 spawn wave
(script continuous enc7_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc7_trigger (players))
			(< enc7_limiter (* 15 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc7/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc7/combats)
					(set enc7_limiter (+ enc7_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc7/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc7/carriers)
					(set enc7_limiter (+ enc7_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 60)
)


; Encounter 4 spawn wave
(script continuous enc4_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(if 
		(and 
			(volume_test_objects enc4_trigger (players))
			(< enc4_limiter (* 10 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc4/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4/combats)
					(set enc4_limiter (+ enc4_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc4/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4/carriers)
					(set enc4_limiter (+ enc4_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 15)
)


; Put all continuous spawn waves to sleep immediately
(script dormant stun_spawn_waves
	; Debug
	(if debug (print "Stunning spawn waves..."))
	
	; Sleep all of the spawn waves
	(sleep -1 enc4_spawner)
	(sleep -1 enc7_spawner)
	(sleep -1 enc1_9_spawner)
	(sleep -1 enc2_0_spawner)
	(sleep -1 enc2_4_spawner)
	(sleep -1 enc2_9_spawner)
	(sleep -1 enc2_11_spawner)
	(sleep -1 enc3_4_spawner)
	(sleep -1 enc3_6_spawner)
	(sleep -1 enc4_0_spawner)
	(sleep -1 enc4_3_spawner)
	(sleep -1 enc4_6_spawner)
	(sleep -1 enc4_8_spawner)
	(sleep -1 enc5_3_spawner)
	(sleep -1 enc5_5_spawner)
	(sleep -1 enc6_2_spawner)
	(sleep -1 enc6_2b_spawner)
	(sleep -1 enc6_4_spawner)
	(sleep -1 enc6_7_spawner)
	(sleep -1 enc6_8_spawner)
	(sleep -1 enc7_3_spawner)
	(sleep -1 enc7_5_spawner)
	(sleep -1 enc7_12_spawner)	
;	(sleep -1 enc7_12_spawner_coop)	
)


;- Monitor Behavior ------------------------------------------------------------

; Monitor motion script 4_4
(script dormant monitor4_4
	; Create monitor and execute command list
	(ai_command_list_advance bsp3_monitor)
	(ai_command_list bsp3_monitor monitor4_4)
	
	; Sleep until the player has gotten close
	(sleep_until (volume_test_objects enc7_10a_trigger (players)))
;	(C20_320_Monitor) ; You may now retrieve the index
	(objective_index)
)


; Monitor motion script 4_3
(script dormant monitor4_3
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor4_3 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp3_monitor)
	(ai_command_list bsp3_monitor monitor4_3)
	(sleep 90)
	(C20_flavor_100_Monitor) ; The flood are hard at work repairing your vessel
	(set music_03_base true) ; Emphasis music
 	
	; DISCONTINUITY
	; Action continues in floor4_door2
)


; Monitor motion script 4_2
(script dormant monitor4_2
	; Create monitor and execute command list
	(ai_command_list_advance bsp3_monitor)
	(ai_command_list bsp3_monitor monitor4_2)
 	
	; Wakey wakey
	(wake monitor4_3)
)


; Monitor motion script 4_1
(script dormant monitor4_1
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor4_1 (players)))
	
	; Create monitor and execute command list
	(ai_place bsp3_monitor)
	(object_cannot_take_damage (ai_actors bsp3_monitor))
	(ai_disregard (ai_actors bsp3_monitor) true)
	(ai_force_active bsp3_monitor true)
	(ai_command_list bsp3_monitor monitor4_1)

	; DISCONTINUITY
	; Action continues in floor4_door2
)


; Monitor motion script 3_9
(script dormant monitor3_9
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc6_6_trigger (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_9)
	(C20_125_Monitor) ; I'm gratified to see you
)


; Monitor motion script 3_8
(script dormant monitor3_8
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_8)
 	
	; Wakey wakey
	(wake monitor3_9)
	(C20_210_Monitor) ; I will deactivate the lock... wait here
)


; Monitor motion script 3_7
(script dormant monitor3_7
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor3_7 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_7)
 	
	; DISCONTINUITY
	; Execution continues from enc6_4
)


; Monitor motion script 3_6
(script dormant monitor3_6
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc6_2_trigger (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_6)
 	
	; Wakey wakey
	(wake monitor3_7)
)


; Monitor motion script 3_5
(script dormant monitor3_5
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects section6_trigger (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_5)
 	
	; Wakey wakey
	(wake monitor3_6)
	(C20_flavor_140_Monitor) ; Construct was built to study the flood
)


; Monitor motion script 3_4
(script dormant monitor3_4
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc5_6_trigger (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_4)
 	
	; Wakey wakey
	(wake monitor3_5)
	(C20_flavor_130_Monitor) ; Naturally, samples were kept
)


; Monitor motion script 3_3
(script dormant monitor3_3
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_3)
	(C20_135_Monitor) ; We must continue
 	
	; Wakey wakey
	(wake monitor3_4)
)


; Monitor motion script 3_2
(script dormant monitor3_2
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor3_2 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp2_monitor)
	(ai_command_list bsp2_monitor monitor3_2)
 	
	; DISCONTINUITY
	; Script continues in floor3_door2
)


; Monitor motion script 3_1
(script dormant monitor3_1
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc5_1_trigger (players)))
	
	; Create monitor and execute command list
	(ai_place bsp2_monitor)
	(object_cannot_take_damage (ai_actors bsp2_monitor))
	(ai_disregard (ai_actors bsp2_monitor) true)
	(ai_force_active bsp2_monitor true)
	(ai_command_list bsp2_monitor monitor3_1)
 	(wake monitor3_2)
 	(C20_flavor_090_Monitor) ; The index is naturally our first priority
 	(C20_flavor_150_Monitor) ; I would conjecture that the other species...
)


; Monitor motion script 2_11
(script dormant monitor2_11
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor2_11 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_11)
 	
	; End of Floor 2 Monitor Shiznat-O-Bang.
	; Stay tuned for our next season, which begins in Section 5
)


; Monitor motion script 2_10
(script dormant monitor2_10
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor2_10 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_10)
 	
	; Wakey wakey
	(wake monitor2_11)
)


; Monitor motion script 2_9
(script dormant monitor2_9
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects tv_save_checkpoint2_3 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_9)
 	
	; Wakey wakey
	(wake monitor2_10)
	(C20_flavor_060_Monitor) ; Flood will spread from planet to planet
	(C20_flavor_080_Monitor) ; The construct is well conceived
)


; Monitor motion script 2_8
(script dormant monitor2_8
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor2_8 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_8)
 	
	; Wakey wakey
	(wake monitor2_9)
	(C20_flavor_070_Monitor) ; Environment suit is good. Good planning
)


; Monitor motion script 2_7
(script dormant monitor2_7
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc4_2_trigger (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_7)
 	
	; Wakey wakey
	(wake monitor2_8)
	(C20_190_Monitor)
)


; Monitor motion script 2_6
(script dormant monitor2_6
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects tv_save_checkpoint2_2 (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_6)
 	
	; Wakey wakey
	(wake monitor2_7)
)


; Monitor motion script 2_5
(script dormant monitor2_5
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc3_6_trigger (players)) 5)
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_5)
	
	; Sleep until the monitor is ready to advance
	(sleep_until (= 2 (ai_command_list_status (ai_actors bsp1_monitor))))
 	
 	; Sleep 2 seconds, then start opening the door
 	(sleep 60)
 	(device_group_set floor2_door2 0.2)
 	
 	; Sleep another few seconds
 	(sleep_until (>= (device_get_position floor2_door2) 0.2))
 	(sleep 30)
 	(C20_200_Monitor) ; Wait here... 
 	
 	; Advance the command list, change objective
	(ai_command_list_advance bsp1_monitor)
	(objective_hold)
	(sleep_until (= 2 (ai_command_list_status (ai_actors bsp1_monitor))))
	
	; Wake the spawner and sleep until the infs are more or less dead
;	(ai_force_active enc3_6_flood true)

	; Place the infection forms
	(ai_place enc3_6_flood)
	(ai_magically_see_players enc3_6_flood)
	(ai_try_to_fight_player enc3_6_flood)
	(ai_disregard (ai_actors enc3_5e) true)
	
	; Sleep a bit
	(sleep 300)

 	; Bring back the monitor
	(ai_command_list_advance bsp1_monitor) 
	(sleep 240)
	
	; Open the door more
	(device_group_set floor2_door2 door_open)
	(objective_follow)
 	
	; Wakey wakey
	(wake monitor2_6)
)


; Monitor motion script 2_4
(script dormant monitor2_4
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc3_5_trigger (players)))
	
	; Create monitor and execute command list
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_4)
	
	; Sleep until triggers, advance after those
	(sleep_until (volume_test_objects enc3_5b_trigger (players))) (print "enc3_5b_trigger")
	(ai_command_list_advance bsp1_monitor)
	(C20_flavor_030_Monitor) ; The sents can only manage for a short time...
	(sleep_until (volume_test_objects enc3_5c_trigger (players))) (print "enc3_5c_trigger")
	(ai_command_list_advance bsp1_monitor)

	; DISCONTINUITY
	; Script continues in... HELL! *horror music*
)


; Monitor motion script 2_3
(script dormant monitor2_3
	; Create monitor and execute command list
	(ai_command_list bsp1_monitor monitor2_3)
 	(wake monitor2_4)
)


; Monitor motion script 2_2
(script dormant monitor2_2
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc3_3_trigger (players)))
	
	; Create monitor and execute command list
	(C20_140_Monitor) ; I must away!
	(ai_command_list_advance bsp1_monitor)
	(ai_command_list bsp1_monitor monitor2_2)
 	
	; DISCONTINUITY
	; Script continues in enc3_5
)


; Monitor motion script 2_1
(script dormant monitor2_1
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects section3_trigger (players)) 5)
	
	; Create monitor and execute command list
	(ai_place bsp1_monitor)
	(object_cannot_take_damage (ai_actors bsp1_monitor))
	(ai_disregard (ai_actors bsp1_monitor) true)
	(ai_force_active bsp1_monitor true)
	(ai_command_list bsp1_monitor monitor2_1)
 	(wake monitor2_2)
 	(C20_120_Monitor) ; Please stay close
)


; Monitor motion script 1_17
(script dormant monitor1_17
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_17)
	(C20_090_Monitor) ; Pardon me, I must away
)


; Monitor motion script 1_16
(script dormant monitor1_16
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_16)
	(sleep 90)
	(C20_070_Monitor) ; These sentinels will help
)


; Monitor motion script 1_15
(script dormant monitor1_15
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc2_9_trigger (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_15)
	(C20_flavor_110_Monitor) ; Most impressive facilities

	; DISCONTINUITY
	; Next section of monitor commands is triggered by Encounter 2_12
)


; Monitor motion script 1_14
(script dormant monitor1_14
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc2_8_trigger (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
;	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_14)
 	(wake monitor1_15)
 	(sleep 120)
 	(C20_130_Monitor) ; We must continue.
)


; Monitor motion script 1_13
(script dormant monitor1_13
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects tv_save_checkpoint3 (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_13)
 	(wake monitor1_14)
)


; Monitor motion script 1_12
(script dormant monitor1_12
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor1_12 (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_12)
 	(wake monitor1_13)
 	(C20_flavor_040_Monitor) ; You can see how mutate...
 	(C20_flavor_050_Monitor) ; Small creatures carry...
)


; Monitor motion script 1_11
(script dormant monitor1_11
	; Sleep till trigger volume 
	(sleep_until (= 2 (ai_command_list_status (list_get (ai_actors bsp0_monitor) 0))))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_11)
 	(wake monitor1_12)
)


; Monitor motion script 1_10
(script dormant monitor1_10
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc2_3_trigger (players)))
	(sleep_until (= 2 (ai_command_list_status (list_get (ai_actors bsp0_monitor) 0))))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_10)
	(wake monitor1_11)
	(C20_flavor_010_Monitor) ; If flood escapes the halo...
	(C20_flavor_020_Monitor) ; Flood must not escape
)


; Monitor motion script 1_9b
(script dormant monitor1_9b
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor1_9b (players)) testing_fast)
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_9b)
	(sleep 60)
 	(C20_180_Monitor) ; Not correct direction
)


; Monitor motion script 1_9
(script dormant monitor1_9
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor1_9 (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_9)
 	(sleep -1 monitor1_9b)
	(wake monitor1_10)
 	(C20_060_Monitor) ; Curiously ineffective weapons...
)


; Monitor motion script 1_8
(script dormant monitor1_8
	; Sleep for the right period of time
	(sleep_until (= 1 (ai_command_list_status (ai_actors bsp0_monitor))))
	(sleep 150)
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_8)

	; Sleep a bit
	(sleep 100)
	
	; Open the doors
	(device_group_set floor1_door1 door_open)
	
	; NEXT!
	(wake monitor1_9)
	(wake monitor1_9b)
	(C20_050_Monitor) ; Please follow closely
)


; Monitor motion script 1_7
(script dormant monitor1_7
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects floor1_door1_trigger (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(C20_040_Monitor) ; The door has sealed...
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_7)
 	(wake monitor1_8)
)


; Monitor motion script 1_6
(script dormant monitor1_6
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor1_6 (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
	(ai_command_list bsp0_monitor monitor1_6)
 	(wake monitor1_7)
)


; Monitor motion script 1_5
(script dormant monitor1_5
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor1_5 (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
 	(wake monitor1_6)
	(ai_command_list bsp0_monitor monitor1_5)
	(C20_020_Monitor) ; The energy field above contains the index
)


; Monitor motion script 1_4
(script dormant monitor1_4
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor1_4 (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
 	(wake monitor1_5)
	(ai_command_list bsp0_monitor monitor1_4)
)


; Monitor motion script 1_3
(script dormant monitor1_3
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects enc3_trigger (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
 	(wake monitor1_4)
	(ai_command_list bsp0_monitor monitor1_3)
	(C20_010_Monitor)	; We are near the index chamber...
)


; Monitor motion script 1_2
(script dormant monitor1_2
	; Sleep till trigger volume 
	(sleep_until (volume_test_objects monitor1_2 (players)))
	
	; Kill, advance, wake, execute... repeat until world dominated
	(ai_command_list_advance bsp0_monitor)
 	(wake monitor1_3)
	(ai_command_list bsp0_monitor monitor1_2)
)


; Monitor motion script 1_1
(script dormant monitor1_1
	; Trigger subsequent commands, if any
 	(wake monitor1_2)

	; Begin executing action list
	(ai_command_list bsp0_monitor monitor1_1)
)

; Initialize the monitor, bsp0
(script dormant init_monitor_bsp0
	; Place the monitor
	(ai_place bsp0_monitor)
	(object_cannot_take_damage (ai_actors bsp0_monitor))
	(ai_disregard (ai_actors bsp0_monitor) true)
	(ai_force_active bsp0_monitor true)
	
	; Begin script
	(wake monitor1_1)
)


;- Section 7 Encounters --------------------------------------------------------

; Encounter 7_12, triggered by Encounter 7_9
(script dormant enc7_12
	; Sleep until the trigger
	(sleep_until (>= (device_group_get floor4_door3) door_open))
	
	; Debug
	(if debug (print "Encounter 7.12..."))
	(certain_save)

	; Wake the manager
	(wake enc7_12_spawner)
	
	; Sleep until D is triggered, end the manager
	(sleep_until (volume_test_objects enc7_12d (players)))
	(sleep -1 enc7_12_spawner)
)


; Encounter 7_10, triggered by Encounter 7_9
(script dormant enc7_10
	; Sleep until the trigger
	(sleep_until 
		(and
			(volume_test_objects finale (players))
			(volume_test_objects_all finale (players))
		)		
	)

	; End the game
;	(sleep_until (<= (ai_nonswarm_count enc7_12) 0) 30 1800)
	(sleep -1 enc7_12_spawner)
	(ai_kill enc7_12)	; AI DIEZ HEAR!!! k thnx gg
	(ai_kill enc7_9)	; AI DIEZ HEAR!!! k thnx gg
	
	; Invincible players
	(object_cannot_take_damage (players))

	; MUZAK
	(sound_looping_stop "levels\c20\music\c20_04")

   (if (mcc_mission_segment "cine2_final") (sleep 1))
  
	; Fin
	(cutscene_extraction)
)

	
; Encounter 7_9, triggered by Encounter 7_4
(script dormant enc7_9
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_9_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.9..."))
	
	; Wake 7_10, 7_12
	(wake enc7_10)
	(wake enc7_12)
	
	; Wait for it...
	(sleep 150)
	
	; Start the music
	(set music_04_base true)
	
	; Open a bit and wake the infections
	(device_group_set floor4_door3 0.18)
	(ai_place enc7_9/infs)
	
	; Create the sparks
	(sleep_until (> (device_group_get floor4_door3) 0.1) 1)
	(object_create floor4_door3_sparks1)
	(object_create floor4_door3_sparks2)
	(object_create floor4_door3_sparks3)
	(object_create floor4_door3_sparks4)
	(sleep_until (>= (device_group_get floor4_door3) 0.18) 1)
	(object_destroy floor4_door3_sparks1)
	(object_destroy floor4_door3_sparks2)
	(object_destroy floor4_door3_sparks3)
	(object_destroy floor4_door3_sparks4)
	
	; Monitor flies off... fukr!!
	(wake monitor4_4)

	; MUZAK
	(sound_looping_set_alternate "levels\c20\music\c20_04" true)

	; Wait for it....
	(sleep 90)
	
	; Open a bit more...
 	(device_group_set floor4_door3 0.4)
 	
 	; Create the sparks
	(object_create floor4_door3_sparks1)
	(object_create floor4_door3_sparks2)
	(object_create floor4_door3_sparks3)
	(object_create floor4_door3_sparks4)
 	(sleep_until (>= (device_group_get floor4_door3) 0.4) 1)
	(object_destroy floor4_door3_sparks1)
	(object_destroy floor4_door3_sparks2)
	(object_destroy floor4_door3_sparks3)
	(object_destroy floor4_door3_sparks4)
	
 	; Place the leapers, who leap
 	(ai_place enc7_9/leapers)
 	(sleep 30)
 	(ai_place enc7_9/leapers)
  	(sleep 20)
	(ai_place enc7_9/leapers)
  	(sleep 40)
	(ai_place enc7_9/leapers)
 	(sleep 150)
 	
 	; And open it up
 	(device_group_set floor4_door3 door_open)
 	
 	; Create the sparks
	(object_create floor4_door3_sparks1)
	(object_create floor4_door3_sparks2)
 	(object_create floor4_door3_sparks3)
	(object_create floor4_door3_sparks4)
	
 	; Place the others... all hell breaks loose
 	(sleep_until (> (device_group_get floor4_door3) 0.5) 1)
	(ai_place enc7_9/rushers)
	(ai_place enc7_9/rushers2)
	(ai_place enc7_9/snipers)
	(ai_place enc7_9/carriers)

	; Stop the sparks
 	(sleep_until (>= (device_group_get floor4_door3) 0.8) 1)
	(object_destroy floor4_door3_sparks1)
	(object_destroy floor4_door3_sparks2)
	(object_destroy floor4_door3_sparks3)
	(object_destroy floor4_door3_sparks4)
)


; Encounter 7_8, triggered by Encounter 7_4
(script dormant enc7_8
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_8_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.8..."))
	
	; Place the Flood
	(ai_place enc7_8)
)


; Encounter 7_7, triggered by Encounter 7_4
(script dormant enc7_7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_7_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.7..."))
	
	; Place the Flood
	(ai_place enc7_7)
)


; Encounter 7_6, triggered by Encounter 7_4
(script dormant enc7_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_6_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.6..."))
)


; Do the door, dude
(script dormant floor4_door2
	; Wake the door counter
	(wake floor4_door2_counter)
	(sleep_until (> floor4_door2_count 120))
	(sleep -1 floor4_door2_counter)
	
	; Open the door
	(device_group_set floor4_door2 door_open)
	(certain_save)
	
	; Wait till it's open enough
	(sleep_until (> (device_group_get floor4_door2) 0.2))
;	(set music_03_base false) ; Disengage the music
	
	; Monitor flies out
	(wake monitor4_2)
)


; Encounter 7_5, triggered by Encounter 7_4
(script dormant enc7_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_5_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.5..."))
	
	; Wake scripts
	(wake enc7_6)
	(wake enc7_7)
	(wake enc7_8)
	(wake enc7_9)
	
	; Remove the sentinels from 7_1
	(ai_erase enc7_1)
	
	; Wait a moment, then wake the spawner
	(sleep 180)
	(wake enc7_5_spawner)
	
	; Do the door stuff
	(wake floor4_door2)
)


; Encounter 7_4, triggered by Encounter 7_1
(script dormant enc7_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_4_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.4..."))
	
	; Wake the actors
	(ai_place enc7_0)
	(ai_place enc7_4)
	
	; Trigger subsequent scripts
	(wake enc7_5)
)


; Encounter 7_3, triggered by Encounter 7_1
(script dormant enc7_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_3_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.3..."))
	
	; Wake the spawner
	(wake enc7_3_spawner)
)


; Encounter 7_2, triggered by Encounter 7_1
(script dormant enc7_2 
	; Debug
	(if debug (print "Encounter 7.2..."))
	
	; Place the carriers, delightful little bug'gers that they are
	(ai_place enc7_2)
)


; Encounter 7_1, triggered by Section 7
(script dormant enc7_1
	; Debug
	(if debug (print "Encounter 7.1..."))
	
	; Wake subsequent encounters
	(wake enc7_2)
	(wake enc7_3)
	(wake enc7_4)
	
	; Place the units and give them sight
	(ai_place enc7_1) (sleep 90)
	(if 
		(or
			(= "easy" (game_difficulty_get))
			(= "normal" (game_difficulty_get))			
		)
		(ai_place enc7_1)
	)
	
	; Set up migration
	(ai_automatic_migration_target enc7_1 true)
	(ai_follow_target_players enc7_1)

	; And send them off
	(sleep_until (volume_test_objects enc7_4_trigger (players)))
	(ai_automatic_migration_target enc7_1 false)
	(ai_command_list enc7_1 enc7_1_exit)
)


; Section 7 trigger
(script dormant section7
	; Debug
	(if debug (print "Section 7..."))
	(certain_save)

	; Erase old encounters
	(ai_erase enc5_0)
	(ai_erase enc5_1)
	(ai_erase enc5_1b)
	(ai_erase enc5_2)
	(ai_erase enc5_3)
	(ai_erase enc5_3b)
	(ai_erase enc5_4)
	(ai_erase enc5_5)
	(ai_erase enc5_6)
	(ai_erase enc6_1)
	(ai_erase enc6_2)
	(ai_erase enc6_2b)
	(ai_erase enc6_3)
	(ai_erase enc6_4)
	(ai_erase enc6_5)
	(ai_erase enc6_5b)
	(ai_erase enc6_6)
	(ai_erase enc6_7)
	(ai_erase enc6_7b)
	(ai_erase enc6_8)

	; Close the door on floor 1
	(device_group_set_immediate floor3_door1 0)
	(device_group_set_immediate floor3_door2 0)
	(device_group_set_immediate floor3_door3 0)
	(device_group_set_immediate floor3_door4 0)
	(device_group_set_immediate floor3_door5 0)

	; Wake Section 3 encounters
	(wake enc7_1)
	
	; Wake the monitor
	(wake monitor4_1)
)


;- Section 6 Encounters --------------------------------------------------------

; Encounter 6_8, triggered by Encounter 6_6
(script dormant enc6_8
	; Sleep until the trigger
	(sleep_until (volume_test_objects tv_platform3 (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 6.8..."))
	
	; Wait till the player is in the lift and it's high enough
	(sleep_until 
		(and
			(volume_test_objects tv_platform3 (players))
			(>= (device_get_position platform3) 0.6)
		)
	)
	(chapter_c20_3)
)


; Encounter 6_7, triggered by Encounter 6_6
(script dormant enc6_7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_7_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 6.7..."))
	
	; Wake the spawner
	(wake enc6_7_spawner)
)


; Encounter 6_6, triggered by Encounter 6_3
(script dormant enc6_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_6_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 6.6..."))

	; Maneuver sentinels into position
	(ai_maneuver enc6_5b/sentinel_platoon)
	
	; Place the Flood and give sight
	(ai_place enc6_6)
	(ai_magically_see_encounter enc6_5b enc6_6)
	(ai_magically_see_encounter enc6_6 enc6_5b)
	
	; When Flood are dead, advance the Sentinels and wake 6_7 and 6_8
	(sleep_until (<= (ai_living_count enc6_6) 0))
	(ai_command_list enc6_5b/sentinels2 enc6_6_advance)
	(ai_migrate enc6_5b enc6_7b)
	(wake enc6_7)
	(wake enc6_8)
)


; Encounter 6_5, triggered by Encounter 6_4
(script dormant enc6_5
	; Sleep until the trigger for the previous encounter
;	(sleep_until (volume_test_objects enc6_4_trigger (players)))
	(certain_save)

	; Debug
	(if debug (print "Encounter 6.5 Prep..."))
	
	; Place the two sets of units
	(ai_place enc6_5)						; Flood
	(ai_place enc6_5b/sentinels)		; Sentinels (gee, really?)

	; Wait for the player
	(sleep_until (volume_test_objects enc6_5_trigger (players)))

	; Debug
	(if debug (print "Encounter 6.5..."))
	
	; Add sentinels if necessary (ugly brute force way of doing it)
	(if (< (ai_living_count enc6_5b) 6) (ai_spawn_actor enc6_5b/replacements))
	(sleep 45)
	(if (< (ai_living_count enc6_5b) 6) (ai_spawn_actor enc6_5b/replacements))
	(sleep 45)
	(if (< (ai_living_count enc6_5b) 6) (ai_spawn_actor enc6_5b/replacements))
	(sleep 45)
	(if (< (ai_living_count enc6_5b) 6) (ai_spawn_actor enc6_5b/replacements))
	(sleep 45)
	(if (< (ai_living_count enc6_5b) 6) (ai_spawn_actor enc6_5b/replacements))
	(sleep 45)
	(if (< (ai_living_count enc6_5b) 6) (ai_spawn_actor enc6_5b/replacements))
)


; Encounter 6_4, triggered by Encounter 6_3
(script dormant enc6_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects_all enc6_4_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 6.4..."))
	
	; Sleep for a moment
	(sleep 30)
	
	; Do monitor exit
	(wake monitor3_8)
	(set music_02_base true) ; Start music
	
	; Close the door which is being behinden yo, change objective
	(sleep 30)
	(device_group_set floor3_door4 0)
	(objective_hold)


	; Place the appetizers
	(sleep 60)
	(ai_place enc6_4/infs)

	; MUZAK
	(sound_looping_set_alternate "levels\c20\music\c20_04" true)

	; Sleep till the door is closed, then drop some infs, give them sight
	(sleep_until (<= (device_group_get floor3_door4) 0))
	(ai_magically_see_players enc6_4)

	; Wake the central encounter
	(sleep 150)
	(wake enc6_4_spawner)

	; Sleep till the encounter is done
	(sleep (* 30 (* spawn_scale 60)))
	
	; End the encounter wave
	(sleep -1 enc6_4_spawner)

	; Open the door, wake the encounter
	(device_group_set floor3_door5 door_open)
  	(objective_follow)
 	
 	; Wake subsequent encounters
 	(wake enc6_5)
	(wake enc6_6)
	
	; Sleep till combat forms are dead, or 30 seconds
	(sleep_until (<= (ai_nonswarm_count enc6_4) 0) 30 900)
	
	; MUZAK
	(sound_looping_set_alternate "levels\c20\music\c20_04" false)
)


; Encounter 6_3, triggered by Section 6
(script dormant enc6_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_3_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 6.3..."))
	
	; Place the units... AND KILL THEM!
	(ai_place enc6_3)
	(ai_kill enc6_3)
	
	; Snap the door open
	(device_group_set_immediate floor3_door4 0.6)
	
	; Wake scripts
	(wake enc6_4)
)


; Encounter 6_2, triggered by Section 6
(script dormant enc6_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_2_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 6.2..."))
	
	; MUZAK
	(sound_looping_start "levels\c20\music\c20_04" none 1)

	; Wake the wave
	(wake enc6_2_spawner)
	(wake enc6_2b_spawner)
)


; Encounter 6_1, triggered by Section 6
(script dormant enc6_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_1_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 6.1..."))
	
	; MUZAK
	(sound_looping_stop "levels\c20\music\c20_01")

	; Place the units and give them sight
	(ai_place enc6_1)
	(ai_magically_see_players enc6_1)
)


; Section 6 trigger
(script dormant section6
	; Debug
	(if debug (print "Section 6..."))
;	(certain_save)

	; Kill old encounters
	(ai_erase enc4_0)
	(ai_erase enc4_1)
	(ai_erase enc4_2)
	(ai_erase enc4_3)
	(ai_erase enc4_4)
	(ai_erase enc4_5)
	(ai_erase enc4_6)
	(ai_erase enc4_7)
	(ai_erase enc4_8)
	
	; Destroy scenery
	(object_destroy scen5_1)
	(object_destroy scen5_2)
	(object_destroy scen5_3)
	(object_destroy scen5_4)
	(object_destroy scen5_5)
	(object_destroy scen5_6)
	(object_destroy scen5_7)
	(object_destroy scen5_8)
	(object_destroy scen5_9)
	(object_destroy scen5_10)
	(object_destroy scen5_11)
	(object_destroy scen5_12)
	(object_destroy scen5_13)
	(object_destroy scen5_14)
	(object_destroy scen5_15)
	(object_destroy scen5_16)
	(object_destroy scen5_17)
	(object_destroy scen5_18)
	(object_destroy scen5_19)
	(object_destroy scen5_20)
	(object_destroy scen5_21)
	(object_destroy scen5_22)
	(object_destroy scen5_23)
	(object_destroy scen5_24)
	(object_destroy scen5_25)
	(object_destroy scen5_26)
	
	; Close the door on floor 2
	(device_group_set_immediate floor2_door1 0)
	(device_group_set_immediate floor2_door2 0)

	; Wake Section 6 encounters
	(wake enc6_1)
	(wake enc6_2)
	(wake enc6_3)
	
	; Sleep until the trigger
	(sleep_until (volume_test_objects section7_trigger (players)) testing_fast)
	(wake section7)
	
	; End old encounters
	(sleep -1 enc6_2b_spawner)
	(sleep -1 enc6_4_spawner)
	(sleep -1 enc6_7_spawner)
)


;- Section 5 Encounters --------------------------------------------------------

; Encounter 5_6, triggered by Encounter 5_5
(script dormant enc5_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_6_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 5.6..."))
	
	; Open the next door a bit
	(device_group_set floor3_door3 door_open)
	
	; Place the units and give them sight
	(ai_place enc5_6/squad1)
	(ai_magically_see_players enc5_6)
	
	; Wait till either the player crosses the next volume
	(sleep_until 
		(or
			(volume_test_objects enc5_6b_trigger (players))
			(volume_test_objects enc5_6d (players))
		)
	)
	(certain_save)
	
	; Place the units and give them sight
	(if (volume_test_objects enc5_6d (players))
		(ai_place enc5_6/squad2b)
		(ai_place enc5_6/squad2)
	)
	
	; Wait till either the player crosses the next volume
	(sleep_until (volume_test_objects enc5_6c_trigger (players)))
	(certain_save)
	
	; Place the units and give them sight
	(ai_place enc5_6/squad3)
	(ai_place enc5_6/squad3_infs)
)


; Do the door, dude
(script dormant floor3_door2
	; Wake the door counter
	(certain_save)
	(wake floor3_door2_counter)
	(objective_hold) ; Hold your ground
	(sleep_until (> floor3_door2_count 120))
	(sleep -1 floor3_door2_counter)
	
	; Open the door
	(device_group_set floor3_door2 door_open)
	(certain_save)
	(wake monitor3_3)
	(objective_follow)

	; MUZAK
	(sleep_until (> (device_get_position floor3_door2) 0.1))
	(sound_looping_stop "levels\c20\music\c20_03")
	(sleep -1 enc5_5_spawner)
	(sleep 900)
	(sound_looping_start "levels\c20\music\c20_01" none 1)
)


; Encounter 5_5, triggered by Encounter 5_2
(script dormant enc5_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_5_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 5.5..."))
	
	; Place the units
	(ai_place enc5_5/combats)
	
	; Begin the spawner
	(wake enc5_5_spawner)
	
	; MUZAK
	(sound_looping_set_alternate "levels\c20\music\c20_03" true)

	; Run the door sequence and subsequent scripts
	(wake floor3_door2)
	(wake enc5_6)
)


; Encounter 5_4, triggered by Encounter 5_2
(script dormant enc5_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_4_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 5.4..."))
	
	; Place the units and give them sight
;	(ai_place enc5_4)
;	(ai_magically_see_players enc5_4)
)


; Encounter 5_3, triggered by Encounter 5_2
(script dormant enc5_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_3_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 5.3..."))
	
	; Place the units and give them sight
	(ai_place enc5_3)
	(ai_magically_see_encounter enc5_3 enc5_3b)
	
	; Begin the spawner
	(wake enc5_3_spawner)
)


; Encounter 5_2, triggered by Section 5
(script dormant enc5_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_2_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 5.2..."))
	
	; Place the units and give them sight
	(ai_place enc5_2)
	(ai_magically_see_players enc5_2)
	
	; Wake scripts
	(wake enc5_3)
	(wake enc5_4)
	(wake enc5_5)
)


; Encounter 5_1, triggered by Section 5
(script dormant enc5_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_1_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 5.1..."))
	
	; Kill the sacrificial Flood
	(ai_place enc5_1b/sacrifices)
	(ai_kill enc5_1b/sacrifices)
	
	; Place the flood
	(ai_place enc5_1b/combats)
	
	; Place the sentinel patrols
	(ai_place enc5_1/entrance1)
	(ai_place enc5_1/entrance2)
	(sleep 75)
	(ai_place enc5_1/entrance1)
	(ai_place enc5_1/entrance2)
	(sleep 75)
	(ai_place enc5_1/entrance1)
	(ai_place enc5_1/entrance2)
)


; Encounter 5_0, triggered by Section 5
(script dormant enc5_0
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_0_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 5.0..."))
	
	; Place the units and give them sight
	(ai_place enc5_0)
	(ai_magically_see_players enc5_0)
)


; Section 5 trigger
(script dormant section5
	; Debug
	(if debug (print "Section 5..."))
	(certain_save)

	; Kill old encounters
	(ai_erase enc3_1)
	(ai_erase enc3_2)
	(ai_erase enc3_3)
	(ai_erase enc3_4)
	(ai_erase enc3_5)
	(ai_erase enc3_5b)
	(ai_erase enc3_5c)
	(ai_erase enc3_5d)
	(ai_erase enc3_5e)
	(ai_erase enc3_5_sents)
	(ai_erase enc3_6)
	(ai_erase enc3_6_flood)
	(ai_erase enc3_4b)
	
	; Create scenery
	(object_create scen5_1)
	(object_create scen5_2)
	(object_create scen5_3)
	(object_create scen5_4)
	(object_create scen5_5)
	(object_create scen5_6)
	(object_create scen5_7)
	(object_create scen5_8)
	(object_create scen5_9)
	(object_create scen5_10)
	(object_create scen5_11)
	(object_create scen5_12)
	(object_create scen5_13)
	(object_create scen5_14)
	(object_create scen5_15)
	(object_create scen5_16)
	(object_create scen5_17)
	(object_create scen5_18)
	(object_create scen5_19)
	(object_create scen5_20)
	(object_create scen5_21)
	(object_create scen5_22)
	(object_create scen5_23)
	(object_create scen5_24)
	(object_create scen5_25)
	(object_create scen5_26)
	
	; Wake Section 3 encounters
	(wake enc5_0)
	(wake enc5_1)
	(wake enc5_2)
	
	; FIRE UP THAT MONSTER MONITOR MAAAAAYHEM! VROOOM! VRRRRRROOOOM!
	; 45cm OF CAR CRUSHING, ADRENALINE PUMPING, EPILEPSY INDUCING POWWWWERRRR! 
	(wake monitor3_1)
	
	; Sleep until the trigger
	(sleep_until (volume_test_objects section6_trigger (players)) testing_fast)
	(wake section6)
	
	; End old encounters
	(sleep -1 enc5_1)
	(sleep -1 enc5_3_spawner)
	(sleep -1 enc5_5_spawner)
)


;- Section 4 Encounters --------------------------------------------------------

; Encounter 4_8, triggered by Encounter 4_4
(script dormant enc4_8
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_8_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 4.8..."))
	
	; Wake the spawner
	(wake enc4_8_spawner)
)


; Encounter 4_7, triggered by Encounter 4_4
(script dormant enc4_7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_7_trigger (players)) 10)
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 4.7..."))
	
	; Place the units and give them sight
	(ai_place enc4_7)
	(ai_magically_see_players enc4_7)
	
	; Wait till the player is in the lift and it's high enough
	(sleep_until 
		(and
			(volume_test_objects tv_platform2 (players))
			(>= (device_get_position platform2) 0.6)
		)
	)
	(chapter_c20_2)
)


; Encounter 4_6, triggered by Encounter 4_4
(script dormant enc4_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_6_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 4.6..."))
	
	; Wake the spawner
	(wake enc4_6_spawner)
)


; Encounter 4_5, triggered by Encounter 4_2
(script dormant enc4_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_5_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 4.5..."))
	
	; Place the units and give them sight
	(ai_place enc4_5)
	(ai_magically_see_players enc4_5)
)


; Encounter 4_4, triggered by Encounter 4_2
(script dormant enc4_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_4_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 4.4..."))
	
	; Place the units
	(ai_place enc4_4)
	
	; Wake scripts
	(wake enc4_6)
	(wake enc4_7)
	(wake enc4_8)
)


; Encounter 4_3, triggered by Encounter 4_2
(script dormant enc4_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_3_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 4.3..."))
	
	; Wake the spawner
	(wake enc4_3_spawner)
)


; Encounter 4_2, triggered by Section 4
(script dormant enc4_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_2_trigger (players)) testing_fast)
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 4.2..."))

	; MUZAK
	(sound_looping_start "levels\c20\music\c20_03" none 1)
	
	; Place the units and give them sight
	(ai_place enc4_2)
	(ai_magically_see_players enc4_2)
	
	; Wake encounters
	(wake enc4_3)
	(wake enc4_4)
	(wake enc4_5)
)


; Encounter 4_1, triggered by Section 4
(script dormant enc4_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_1_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 4.1..."))
	
	; Place the units and give them sight
	(ai_place enc4_1)
)


; Encounter 4_0, triggered by Section 4
(script dormant enc4_0
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_0 (players)))
	
	; Debug
	(if debug (print "Encounter 4.0..."))
	
	; MUZAK
	(sound_looping_stop "levels\c20\music\c20_01")

	; Place the units and give them sight
	(ai_place enc4_0)
	(ai_magically_see_players enc4_0)
	
	; Wake the spawner
	(wake enc4_0_spawner)	
)


; Section 4 trigger
(script dormant section4
	; Debug and save
	(if debug (print "Section 4..."))
;	(certain_save)
	
	; Close the door on floor 1
	(device_group_set_immediate floor1_door1 0)

	; Wake Section 4 encounters
	(wake enc4_0)
	(wake enc4_1)
	(wake enc4_2)

	; Kill old units
	(ai_erase enc2_0)
	(ai_erase enc2_1)
	(ai_erase enc2_2)
	(ai_erase enc2_3)
	(ai_erase enc2_4)
	(ai_erase enc2_5)
	(ai_erase enc2_6)
	(ai_erase enc2_7)
	(ai_erase enc2_8)
	(ai_erase enc2_9)
	(ai_erase enc2_10)
	(ai_erase enc2_11)
	(ai_erase enc2_12)
	(ai_erase enc2_12b)
	
	; Sleep until the trigger
	(sleep_until (volume_test_objects section5_trigger (players)) testing_fast)
	(wake section5)

	; End old encounters
	(sleep -1 enc4_0)
	(sleep -1 enc4_0_spawner)
	(sleep -1 enc4_3_spawner)
	(sleep -1 enc4_6_spawner)
	(sleep -1 enc4_8_spawner)
)


;- Section 3 Encounters --------------------------------------------------------

; Encounter 3_6, triggered by Encounter 3_4
(script dormant enc3_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_6_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 3.6..."))
	
	; Migrate the units to 3_6
	(ai_migrate enc3_5_sents enc3_6)
;	(ai_migrate enc3_5 enc3_6)
;	(ai_migrate enc3_5c enc3_6)
;	(ai_migrate enc3_5e enc3_6)
	
	; Run door sequence
	(wake monitor2_5)
	(ai_command_list enc3_6 enc3_6_exit)
)


; Encounter 3_5, triggered by Section 3
(script dormant enc3_5
	; Sleep until the trigger
;	(sleep_until (volume_test_objects enc3_5_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 3.5..."))
	
	; Place the units and give them sight
	(ai_place enc3_5)
	(ai_migrate enc3_5 enc3_5_sents)
	(ai_follow_distance enc3_5_sents 5)
	
	; Set up the automigration
	(ai_automatic_migration_target enc3_5_sents/squadA true)
	(ai_automatic_migration_target enc3_5_sents/squadB true)
	(ai_automatic_migration_target enc3_5_sents/squadC true)
	(ai_automatic_migration_target enc3_5_sents/squadD true)
	(ai_automatic_migration_target enc3_5_sents/squadE true)
	(ai_automatic_migration_target enc3_5_sents/squadF true)
	(ai_automatic_migration_target enc3_5_sents/squadG true)
	(ai_automatic_migration_target enc3_5_sents/squadH true)
	(ai_automatic_migration_target enc3_5_sents/squadI true)
	(ai_follow_target_players enc3_5_sents)
	
	; First clash
	(ai_place enc3_5b)
	
	; Sleep until the flood are dead or the player has pushed forward
	(sleep_until 
		(volume_test_objects enc3_5b_trigger (players))
	)		
	(certain_save)
	(ai_automatic_migration_target enc3_5_sents/squadA false)
	(ai_automatic_migration_target enc3_5_sents/squadB false)
	(ai_automatic_migration_target enc3_5_sents/squadC false)
	
	; Migrate the sentinels to the next encounter, wake flood
	(ai_place enc3_5d)	

	; Place sentinels if necessary
	(if (<= (ai_living_count enc3_5_sents) 1)
		(begin
			(ai_place enc3_5c)
			(ai_migrate enc3_5c enc3_5_sents)
		)
	)
		
	; Sleep until the flood are dead or the player has pushed forward
	(sleep_until 
		(volume_test_objects enc3_5c_trigger (players))
	)		
	(certain_save)
	(ai_automatic_migration_target enc3_5_sents/squadD false)
	(ai_automatic_migration_target enc3_5_sents/squadE false)
	(ai_automatic_migration_target enc3_5_sents/squadF false)

	; Migrate the sentinels to the next encounter, wake flood
	(ai_place enc3_5f)	
	(ai_try_to_fight enc3_5f enc3_5_sents)

	; Place sentinels if necessary
	(if (<= (ai_living_count enc3_5_sents) 1)
		(begin
			(ai_place enc3_5e)
			(ai_migrate enc3_5e enc3_5_sents)
		)
	)
)


; Floor 2 Door 1 Actions
(script dormant floor2_door1
	; Sleep for a while
	(sleep 1200)
	
	; Continue with the monitor
	(wake monitor2_3)
	(sleep 240)
	(device_group_set floor2_door1 door_open)

	; Kill the spawner
	(sleep -1 enc3_4_spawner)
	(certain_save)
	
	; Wake next encounter
	(sleep_until (> (device_group_get floor2_door1) .4))
	(wake enc3_5)
	
	; Wait till the door is open enough, and then move the 3_2 setinels out 
	; and have them join the 3_5 sentinels
	(ai_command_list enc3_2 enc3_2_migrate)
	(ai_migrate enc3_2 enc3_5)
	
	; Reset objective
	(objective_follow)
	
	; MUZAK
	(sound_looping_stop "levels\c20\music\c20_02")
	(sleep 1500)
	(sound_looping_start "levels\c20\music\c20_01" none 1)
) 


; Encounter 3_4, triggered by Section 3
(script dormant enc3_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_4_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 3.4..."))
	
	; Wake the door actions
	(wake floor2_door1)
	
	; Migrate the sentinels to the door
	(ai_maneuver enc3_2/door_platoon)
	(ai_command_list enc3_2 enc3_4_transition)
	
	; Display objective
	(objective_hold)
	
	; Wake the wave
	(wake enc3_4_spawner)
	
	; MUZAK
	(sound_looping_set_alternate "levels\c20\music\c20_02" true)

	; Trigger subsequent encounters
	(wake enc3_6)
)


; Encounter 3_3, triggered by Section 3
(script dormant enc3_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_3_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 3.3..."))
	
	; Place the units and give them sight
	(ai_place enc3_3)
	(ai_magically_see_players enc3_3)
)


; Encounter 3_2, triggered by Section 3
(script dormant enc3_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_2_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 3.2..."))
	
	; Place the units
	(ai_place enc3_2)
)


; Encounter 3_1, triggered by Section 3
(script dormant enc3_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_1_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 3.1..."))
	
	; Place the units and give them sight
	(ai_place enc3_1)
	(ai_magically_see_players enc3_1)
)


; Section 3 trigger
(script dormant section3
	; Debug
	(if debug (print "Section 3..."))
	
	; Kill old units
	(ai_erase enc1)
	(ai_erase enc2)
	(ai_erase enc3)
	(ai_erase enc4)
	(ai_erase enc5)
	(ai_erase enc6)
	(ai_erase enc7)
	(ai_erase enc8)
	(ai_erase enc1_9)
	
	; Remove old scenery
	(object_destroy scen1_1)
	(object_destroy scen1_2)
	(object_destroy scen1_3)
	(object_destroy scen1_4)
	(object_destroy scen1_5)
	(object_destroy scen1_6)
	(object_destroy scen2_1)
	(object_destroy scen2_2)
	(object_destroy scen2_3)
	(object_destroy scen2_4)
	(object_destroy scen2_5)
	(object_destroy scen2_6)
	(object_destroy scen2_7)
	(object_destroy scen2_8)
	(object_destroy scen2_9)

	; Wake Section 3 encounters
	(wake enc3_1)
	(wake enc3_2)
	(wake enc3_3)
	(wake enc3_4)
	
	; Wake the monitor
	(wake monitor2_1)

	; Sleep until the trigger
	(sleep_until (volume_test_objects section4_trigger (players)) testing_fast)
	(wake section4)
	
	; End old encounters
	(sleep -1 enc3_4_spawner)
)


;- Section 2 Encounters --------------------------------------------------------

; Encounter 2_12, triggered by Encounter 2_8
(script dormant enc2_12
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_12_trigger (players)))
	(certain_save)

	; Debug
	(if debug (print "Encounter 2.12..."))
	
	; Put the prior spawn wave to sleep, and wait for them to be dead
	(sleep -1 enc2_11_spawner)
;	(sleep_until (<= (ai_living_count enc2_11) 1))
	
	; Wake the flood if the player isn't already in trouble
	(if (> 8
		(+ (ai_living_count enc2_11/combats) 
			(ai_living_count enc2_9/combats) 
			(ai_living_count enc2_8/combats)
		))
		(begin
			(ai_place enc2_12b)
			(ai_magically_see_players enc2_12b)
		)
	)

	; Wait until the flood have been damaged
	(sleep 90)
	
	; Wake the setinels
	(wake monitor1_16)
	(ai_place enc2_12)
	(ai_magically_see_encounter enc2_12 enc2_12b)
	(ai_magically_see_encounter enc2_12b enc2_12)
	
	; Sleep until the flood are dead
	(sleep_until (= (ai_nonswarm_count enc2_12b) 0))
	(ai_maneuver enc2_12)
	(certain_save)
	(wake monitor1_17)
	
	; Sleep until the command list is done
	(sleep_until (volume_test_objects tv_save_checkpoint5 (players)))
	(ai_erase bsp0_monitor)
	(ai_erase enc2_12)
)


; Encounter 2_11, triggered by Encounter 2_8
(script dormant enc2_11
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_11_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.11..."))
	
	; Predict
	(objects_predict (ai_actors enc2_12))
	
	; Wait till the player is in the lift and it's high enough
	(sleep_until 
		(and
			(volume_test_objects tv_platform1 (players))
			(>= (device_get_position platform1) 0.6)
		)
	)
	(chapter_c20_4)
)


; Encounter 2_10, triggered by Encounter 2_8
(script dormant enc2_10
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_10_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.10..."))
	
	; Place the units and give them sight
	(ai_place enc2_10)
	(ai_magically_see_players enc2_10)
)


; Encounter 2_9, triggered by Encounter 2_6
(script dormant enc2_9
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_9_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.9..."))
	
	; Wake the spawner and rear carriers
	(ai_place enc2_9/rear_carriers)
	(ai_magically_see_players enc2_9)
	(wake enc2_9_spawner)
)


; Encounter 2_8, triggered by Encounter 2_6
(script dormant enc2_8
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_8_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.8..."))
	
	; Place the units and give them sight
	(ai_place enc2_8)
	(ai_magically_see_players enc2_8)
	
	; Wake subsequent encounters
	(wake enc2_10)
	(wake enc2_11)
	(wake enc2_12)
)


; Encounter 2_7, triggered by Encounter 2_5
(script dormant enc2_7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_7_trigger (players)) 15)
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.7..."))
	
	; Place the units and give them sight
	(ai_place enc2_7/combats)
	(ai_magically_see_players enc2_7)
	
	; Send in the le(a)pers
	(ai_spawn_actor enc2_7/leapers) (sleep 12)	
	(ai_spawn_actor enc2_7/leapers) (sleep 8)
	(ai_spawn_actor enc2_7/leapers)
)


; Encounter 2_6, triggered by Encounter 2_5
(script dormant enc2_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_6_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.6..."))
	
	; Place the units and give them sight
	(ai_place enc2_6)
	(ai_magically_see_players enc2_6)
	
	; Wake subsequent encounters
	(wake enc2_8)
	(wake enc2_9)
)


; Encounter 2_5, triggered by Encounter 2_4
(script dormant enc2_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_5_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.5..."))
	
	; Place the units and give them sight
	(ai_place enc2_5)
	(ai_magically_see_players enc2_5)
	
	; Sleep until encounter is finished
	(wake enc2_6)	
	(wake enc2_7)
)


; Encounter 2_4, triggered by Section 2 
(script dormant enc2_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_4_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.4..."))
	
	; MUZAK
	(sound_looping_start "levels\c20\music\c20_02" none 1)

	; Wake the spawner
	(wake enc2_4_spawner)

	; Wake mandatory encounters
	(wake enc2_5)
)


; Encounter 2_3, triggered by Section 2
(script dormant enc2_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_3_trigger (players)))
	(certain_save)
	
	; Place the infections
	(ai_place enc2_3/infs)
	(ai_magically_see_players enc2_3)
	
	; Sleep some more
	(sleep_until (<= (ai_living_count enc2_1) 1))
	(sleep_until (<= (ai_living_count enc2_2) 1))
	
	; Debug
	(if debug (print "Encounter 2.3..."))
	
	; Place the units and give them sight
	(ai_place enc2_3/combats)
	(ai_place enc2_3/carriers)
	(ai_magically_see_players enc2_3)
)


; Encounter 2_2, triggered by Encounter 2_1
(script dormant enc2_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_2_trigger (players)))
;	(certain_save)
	
	; Debug
	(if debug (print "Encounter 2.2..."))
	
	; Place the units and give them sight
;	(ai_place enc2_2/combats_rear)
;	(ai_place enc2_2/carriers_rear)
;	(ai_magically_see_players enc2_2)
	
	; Sleep, then trigger the next wave
;	(ai_place enc2_2/combats_front)
;	(ai_place enc2_2/carriers_front)
;	(ai_magically_see_players enc2_2)
)


; Encounter 2_1, triggered by Section 2
(script dormant enc2_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_1_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 2.1..."))
	
	; Place the units and give them sight
	(ai_place enc2_1)
	(ai_magically_see_players enc2_1)
	
	; Trigger next enc, kill spawn waves
	(wake enc2_2)	
	(sleep -1 enc1_9_spawner)
)


; Encounter 2_0, triggered by Section 2
(script dormant enc2_0
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_0_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 2.0..."))
	
	; Place the units and give them sight
	(ai_place enc2_0)
	(ai_magically_see_players enc2_0)
	
	; Wake the spawner
	(wake enc2_0_spawner)	
)


; Section 2, Begin
(script dormant section2 
	; Debug
	(if debug (print "Section 2..."))
	
	; Wake enc2
	(wake enc2_0)
	(wake enc2_1)
	(wake enc2_3)
	(wake enc2_4)
	
	; Sleep until the trigger
	(sleep_until (volume_test_objects section3_trigger (players)) testing_fast)
	(wake section3)

	; End old encounters
	(sleep -1 enc2_0)
	(sleep -1 enc2_3)
	(sleep -1 enc2_0_spawner)
	(sleep -1 enc2_4_spawner)
	(sleep -1 enc2_9_spawner)
	
)


;- Section 1 Encounters --------------------------------------------------------

; Encounter 1_9, triggered by Encounter 8
(script dormant enc1_9
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc1_9_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 1.9..."))
	
	; Place the units and give them sight
	(ai_place enc1_9)
	(ai_magically_see_players enc1_9)
	
	; Wake the spawner
	(wake enc1_9_spawner)	
)


; Encounter 8, triggered by Encounter 7
(script dormant enc8
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc8_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 1.8..."))
	
	; Kill prior spawner, and wake the next enc
	(sleep -1 enc7_spawner)
	(wake enc1_9)
	
	; Place the units and give them sight
	(ai_place enc8)
	(ai_magically_see_players enc8)
	
	; Sleep till the door is open
	(sleep_until (>= (device_get_position floor1_door1) door_open))

	; MUZAK
	(sound_looping_stop "levels\c20\music\c20_01")
)


; Encounter 7, triggered by Encounter 5
(script dormant enc7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc7_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 1.7..."))
	
	; Wake the spawner
	(wake enc7_spawner)

	; Wake mandatory encounters
	(wake enc8)
)


; Encounter 6, triggered by Encounter 5
(script dormant enc6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_trigger (players)) 15)
	
	; Debug
	(if debug (print "Encounter 1.6..."))
	
	; Place the units and give them sight
	(ai_place enc6)
	(ai_magically_see_players enc6)
)


; Encounter 5, triggered by Encounter 2
(script dormant enc5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 1.5..."))
	
	; Place the units
	(ai_place enc5/combats)
	(ai_place enc5/carriers)
	(ai_place enc5/infs)
	
	; Wake mandatory encounters
	(wake enc6)
	(wake enc7)
	
	; Sleep until the first set of infs is dead, then wake the next set
	(sleep_until (<= (ai_living_count enc5/infs) 2))
	(ai_place enc5/infs2)
	(ai_magically_see_players enc5)
)


; Encounter 4, triggered by Encounter 2
(script dormant enc4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 1.4..."))
	
	; Wake the spawner
	(wake enc4_spawner)
)


; Encounter 3, triggered by Encounter 2
(script dormant enc3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_trigger (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 1.3..."))
	
	; Place the units and give them sight
	(ai_place enc3)
	(ai_magically_see_players enc3)
	
	; Sleep until all quiet, then end the music
	(sleep_until (game_all_quiet) 20 1800)
	
	; MUZAK
	(sound_looping_set_alternate "levels\c20\music\c20_01" false)
)


; Encounter 2, triggered by Section1
(script dormant enc2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_trigger (players)))
	
	; Debug
	(if debug (print "Encounter 1.2..."))
	
	; Place the units and give them sight
	(ai_place enc2)
	(ai_magically_see_players enc2)
	
	; Trigger mandatory encounters
	(wake enc3)	
	(wake enc4)
	(wake enc5)
)


; Encounter 1, triggered by Section1
(script dormant enc1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc1 (players)))
	
	; Debug
	(if debug (print "Encounter 1.1..."))
	
	; Wait until the player has looked at a carrier, or has crossed the 
	; threshhold. Then, have the carriers go into attacking mode
	(sleep_until
		(or
			(volume_test_objects enc1b (players))
			(volume_test_objects monitor1_2 (players))
			(objects_can_see_object (players) (list_get (ai_actors enc1/carrier1) 0) 30)
		)
	)
	
	; Fire up the music
	(sound_looping_set_alternate "levels\c20\music\c20_01" true)
	
	; Charge!
	(ai_command_list enc1/infs2 general_null)
	(sleep 45)
	(ai_command_list enc1/carriers general_null)
	(ai_attack enc1/carriers)
	(sleep 30)
	(object_destroy enc1_smoke)
	
	; Sleep until the player has killed the carriers or fled in terror
	(sleep_until
		(or
			(volume_test_objects enc5_trigger (players))
			(<= (ai_nonswarm_count enc1) 0)
		)
	)
)


; Section 1, Begin
(script dormant section1 
	; Debug
	(if debug (print "Section 1..."))
	
	; Wakey!
	(wake enc1)
	(wake enc2)
	
	; Sleep then clean
	(sleep_until (volume_test_objects section2 (players)) testing_fast)
	(wake section2)	

	; End old encounters
	(sleep -1 enc2)
	(sleep -1 enc1_9)
	(sleep -1 enc4_spawner)
	(sleep -1 enc7_spawner)
)


;- Cheats ----------------------------------------------------------------------

(script static void rex_test
	(switch_bsp 3)
	(volume_teleport_players_not_inside enc2_trigger test)
	(wake enc7_9)

)

;*
(script static void rex_test2
;	(switch_bsp 1)
	(volume_teleport_players_not_inside enc2_trigger test2)
	(ai_place bsp0_monitor)
	(ai_disregard (ai_actors bsp0_monitor) true)
	(ai_force_active bsp0_monitor true)
	(wake monitor1_14)
)

(script static void s3
	(switch_bsp 1)
	(volume_teleport_players_not_inside enc2_trigger tp_sec3)
	(wake section3)
)

(script static void s4
	(switch_bsp 1)
	(volume_teleport_players_not_inside enc2_trigger tp_sec4)
	(wake section4)
)

(script static void s5
	(switch_bsp 2)
	(volume_teleport_players_not_inside enc2_trigger tp_sec5)
	(wake section5)
)

(script static void s6
	(switch_bsp 2)
	(device_group_set_immediate floor3_door3 door_open)
	(volume_teleport_players_not_inside enc2_trigger tp_sec6)
	(wake section6)
)

(script static void s7
	(switch_bsp 3)
	(wake enc7_1)
	(volume_teleport_players_not_inside enc2_trigger tp_sec7)
	(wake section7)
)

*;

;- Variant control -------------------------------------------------------------

; Test for coop, and if it is coop, adjust some globals
(script static void coop_control
	; Is it coop?
	(if (< (list_count (players)) 1)
		; It's coop
		(begin
			(if debug (print "Difficulty Adjusted for Coop"))
			(set coop true)
			(set spawn_scale (* spawn_scale 1.2))
			(set min_combat_spawn (+ min_combat_spawn 1))
		)
	)
)


; Test for difficulty, adjust some globals
(script static void diff_control
	; Is it hard?
	(if (= "easy" (game_difficulty_get_real))
		; It's hard
		(begin
			(if debug (print "Difficulty Adjusted for Easy"))
			(set spawn_scale (* spawn_scale 0.75))
			(player_add_equipment (player0) easy_start true)
		)
	)
	
	; Is it hard?
	(if (= "hard" (game_difficulty_get))
		; It's hard
		(begin
			(if debug (print "Difficulty Adjusted for Hard"))
			(set spawn_scale (* spawn_scale 1.1))
			(set min_combat_spawn (+ min_combat_spawn 1))
			(set min_carrier_spawn (+ min_carrier_spawn 1))
			(set min_infection_spawn (+ min_infection_spawn 1))
		)
	)
	
	; Is it impossible?
	(if (= "impossible" (game_difficulty_get))
		; It's hard
		(begin
			(if debug (print "Difficulty Adjusted for Impossible"))
			(set spawn_scale (* spawn_scale 1.25))
			(set min_combat_spawn (+ min_combat_spawn 1))
			(set min_carrier_spawn (+ min_carrier_spawn 1))
			(set min_infection_spawn (+ min_infection_spawn 2))
		)
	)
)


;- Object Prediction -----------------------------------------------------------

(script static void object_prediction
	(objects_predict (ai_actors enc1))
	(objects_predict (players))
)


;- Cutscene Side Threads -------------------------------------------------------

; Intro
(script dormant intro_cutscene_aux
	(sleep 90)
	(chapter_c20_1)
)


;- Main ------------------------------------------------------------------------

(global boolean cinematic_ran false)
(script startup mission
	; Fade out
	(fade_out 0 0 0 0)

	; Initialize scripts
	(if debug (print "Initializing..."))
	(wake save_checkpoints)
	(wake stun_spawn_waves)
	(wake stun_door_counters)
	
	; Variant control
	(coop_control)
	(diff_control)
	
	; Set allegiances
	(ai_allegiance sentinel player)
   
   (if (mcc_mission_segment "cine1_intro") (sleep 1))
	
	; Run opening cinematics
	(if (cinematic_skip_start) 
		(begin
			(set cinematic_ran true)
			(wake intro_cutscene_aux)
			(cinematic_intro)
		)		
	)
	(cinematic_skip_stop)
	(sleep -1 intro_cutscene_aux)
	
	; If cinematic didn't run, fade in
	(if (not cinematic_ran)
		(fade_in 0 0 0 0)
	)

   (mcc_mission_segment "01_start")
   
	; Fire up the music
	(sound_looping_start "levels\c20\music\c20_01" none 1)

	; Wake section tests
	(wake section1)
	
	; Begin monitor run
	(wake init_monitor_bsp0)
	
	; Display initial objective
	(objective_follow)
)



