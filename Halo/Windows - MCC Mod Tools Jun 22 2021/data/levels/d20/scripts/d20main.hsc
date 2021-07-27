;   Script:		Halo Mission D20
; Synopsis:		Flood vs. Covenant vs. Player in ruined Covenant ship
;	  Notes: 	I use 3 space tabs--if alignment looks off, check this first

;- History ---------------------------------------------------------------------

; 06/18/01 - Initial initial version (Tyson)


;- Globals ---------------------------------------------------------------------

; Print useful debugging text
(global boolean debug false)

; Is it coop?
(global boolean coop false)

; Spawn wave parameters
(global real spawn_scale 1.0)				; Scales total spawn counts
(global short min_combat_spawn 2)		; Minimum number of combats in a spawn wave
(global short min_carrier_spawn 2)		; Minimum number of carriers in a spawn wave
(global short min_infection_spawn 6)	; Minimum number of infections in a spawn wave

; Flood spawn wave limiters
(global short enc1_4_limiter 0)
(global short enc1_5_limiter 0)
(global short enc3_2_limiter 0)
(global short enc3_4_limiter 0)
(global short enc3_5_limiter 0)
(global short enc3_8_limiter 0)
(global short enc4_2_limiter 0)
(global short enc4_4_limiter 0)
(global short enc6_1_limiter 0)
(global short enc7_5_limiter 0)

; Magic numbers
(global short testing_save 5)
(global short testing_fast 5)
(global short hud_objectives_display_time 90)


;- Stubs -----------------------------------------------------------------------

(script stub void create_flood_captain (print "STUB - create_flood_captain"))


;- Extra Checks ----------------------------------------------------------------

; Skin Diver
(global boolean skin_diver false)
(script dormant i_am_skin_diver
	; Place, wait, and set
	(ai_place med1_flood)
	(object_set_permutation (list_get (ai_actors med1_flood) 0) "head" ~damaged)
	(object_set_permutation (list_get (ai_actors med1_flood) 0) "left arm" ~damaged)
	(object_set_permutation (list_get (ai_actors med1_flood) 1) "" ~damaged)
	(object_set_permutation (list_get (ai_actors med1_flood) 2) "" ~damaged)
	(object_set_permutation (list_get (ai_actors med1_flood) 2) "left arm" ~damaged)
	(object_set_permutation (list_get (ai_actors med1_flood) 3) "" ~damaged)
	(object_set_permutation (list_get (ai_actors med1_flood) 4) "right arm" ~damaged)
	(object_set_permutation (list_get (ai_actors med1_flood) 4) "left arm" ~damaged)
	(sleep_until (= 0 (ai_living_count med1_flood)))
	(set skin_diver true)
)

; Bloodthirsty
(global boolean bloodthirsty false)
(script dormant more_blood_for_me
	; Wait until first group is set, wait till they're gone. Repeat.
	(sleep_until (> (ai_living_count enc5_7_cov/specops) 0))
	(sleep_until (= 0 (ai_living_count enc5_7_cov/specops)))
	(sleep_until (> (ai_living_count enc7_1_cov) 0))
	(sleep_until (= 0 (ai_living_count enc7_1_cov)))
	(sleep_until (> (ai_living_count enc7_3) 0))
	(sleep_until (= 0 (ai_living_count enc7_3)))
	(set bloodthirsty true)
)

; Ceremony
(script dormant award_ceremony
	; Check
	(if skin_diver (print "Skin Diver Medal Awarded!"))
	(if bloodthirsty (print "Bloodthirsty Medal Awarded!"))
)


;- Chapter Breaks --------------------------------------------------------------

(script static void chapter_d20_1
	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_d20_1)
	(sleep 150)
)

(script static void chapter_d20_2
	; Remove control
	(show_hud false)
	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_d20_2)
	(sleep 150)

	; Return control
	(cinematic_show_letterbox false)
	(show_hud true)
)

(script static void chapter_d20_3
	; Remove control
	(show_hud false)
	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_d20_3)
	(sleep 150)

	; Return control
	(cinematic_show_letterbox false)
	(show_hud true)
)


;- Mission Objectives ----------------------------------------------------------

(script static void objective_start
	(show_hud_help_text true)
	(hud_set_help_text obj_start)
	(hud_set_objective_text obj_start)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_jump
	(show_hud_help_text true)
	(hud_set_help_text obj_jump)
	(hud_set_objective_text obj_jump)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_exterior
	(show_hud_help_text true)
	(hud_set_help_text obj_exterior)
	(hud_set_objective_text obj_exterior)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_lift
	(show_hud_help_text true)
	(hud_set_help_text obj_lift)
	(hud_set_objective_text obj_lift)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_muster
	(show_hud_help_text true)
	(hud_set_help_text obj_muster)
	(hud_set_objective_text obj_muster)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_recover
	(show_hud_help_text true)
	(hud_set_help_text obj_recover)
	(hud_set_objective_text obj_recover)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void objective_escape
	(show_hud_help_text true)
	(hud_set_help_text obj_escape)
	(hud_set_objective_text obj_escape)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)


;- Game Save Checks ------------------------------------------------------------

; Save loop
(global boolean save_now false)
(script continuous save_loop
	(sleep_until save_now testing_save)
;	(sleep_until (game_safe_to_save) testing_save)
;	(game_save_totally_unsafe)
	(game_save_no_timeout)
	(set save_now false)
)

; Certain save subroutine
(script static void certain_save
	(set save_now true)
)


;- Game Save Checks ------------------------------------------------------------

; Save checkpoint 7_1
(script static void save_checkpoint7_1
	(sleep_until (volume_test_objects section7 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 7.1"))
	(sleep_until (game_safe_to_save))
	(certain_save) 
   (mcc_mission_segment "08")
)


; Save checkpoint 6_1
(script static void save_checkpoint6_1
	(sleep_until (volume_test_objects section7 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 6.1"))
	(sleep_until (game_safe_to_save))
	(certain_save) 
   (mcc_mission_segment "07")
)


; Save checkpoint 5_1
(script static void save_checkpoint5_1
	(sleep_until (volume_test_objects save_point5_1 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 5.1"))
	(sleep_until (game_safe_to_save))
	(certain_save) 
   (mcc_mission_segment "06")
)


; Save checkpoint 4_2
(script static void save_checkpoint4_2
	(sleep_until (volume_test_objects save_point4_2 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 4.2"))
	(sleep_until (game_safe_to_save))
	(certain_save) 
   (mcc_mission_segment "05")
)


; Save checkpoint 4_1
(script static void save_checkpoint4_1
	(sleep_until (volume_test_objects save_point4_1 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 4.1"))
	(sleep_until (game_safe_to_save))
	(certain_save) 
   (mcc_mission_segment "04")
)


; Save checkpoint 3_2
(script static void save_checkpoint3_2
	(sleep_until (volume_test_objects save_point3_2 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 3.2"))
	(sleep_until (game_safe_to_save))
	(certain_save) 
   (mcc_mission_segment "03")
)


; Save checkpoint 3_1
(script static void save_checkpoint3_1
	(sleep_until (volume_test_objects save_point3_1 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 3.1"))
	(sleep_until (game_safe_to_save))
	(certain_save)
   (mcc_mission_segment "02")
)


; Save checkpoint 1_1
(script static void save_checkpoint1_1
	(sleep_until (volume_test_objects save_point3_1 (players)) testing_save)
	(if debug (print "Saved at Checkpoint 1.1"))
	(sleep_until (game_safe_to_save))
	(certain_save) 
)


; Save checkpoint thread script
(script dormant save_checkpoints
	; Debug text
	(if debug (print "Save Checkpoints Running..."))

	; Go through the checkpoints in order. Each checkpoint blocks appropriately
;	(save_checkpoint1_1)
	(save_checkpoint3_1)
	(save_checkpoint3_2)
	(save_checkpoint4_1)
	(save_checkpoint4_2)
	(save_checkpoint5_1)
	(save_checkpoint6_1)
	; Save point 7_1 is triggered after the captain cutscene
)


;- Spawn Wave Encounters -------------------------------------------------------

; Encounter 7_5 spawn wave
(script continuous enc7_5_spawner
	; Check if THE TIME IS RIGHT for FLUD OF D3TH!
	(if 
		(and 
			(volume_test_objects_all enc7_5 (players))
			(< (ai_living_count enc7_5) 24)
			(< enc7_5_limiter 5)
		)
	
		; These conditions are met. Spawn.
		(begin_random
			(begin (ai_place enc7_5/infs1) (set enc7_5_limiter (+ enc7_5_limiter 1)))
			(begin (ai_place enc7_5/infs2) (set enc7_5_limiter (+ enc7_5_limiter 1)))
			(begin (ai_place enc7_5/infs3) (set enc7_5_limiter (+ enc7_5_limiter 1)))
		)
	)	 

	; Pause for a moment
	(sleep 150)
)


; Encounter 4_4 spawn wave
(script continuous enc4_4_spawner
	; Check if THE TIME IS RIGHT for FLUD OF D3TH!
	(if 
		(and 
			(volume_test_objects enc4_4 (players))
			(< enc4_4_limiter (* 25 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc4_4/combats) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_4/combats)
					(set enc4_4_limiter (+ enc4_4_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc4_4/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc4_4/carriers)
					(set enc4_4_limiter (+ enc4_4_limiter 1))
				)
			)
			
			; Check the infection form count. If it is too low, spawn
			(if (< (ai_living_count enc4_4/infs) min_infection_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_place enc4_4/infs)
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 30)
)


; Encounter 4_2 spawn wave
(script continuous enc4_2_spawner
	; Check the limiter
	(if 
		(and
			(< enc4_2_limiter (* 40 spawn_scale))
			(volume_test_objects enc4_2b (players))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc4_2) (+ (ai_living_count enc4_2/carriers1) min_carrier_spawn))
				; Spawn 'em and increment the count
				(begin 
					; Check to see if a player is looking at the forward flag
					; If he is, spawn behind him. Else, spawn in front of him
					(if (objects_can_see_flag (players) enc4_2_forward 30)
						(ai_spawn_actor enc4_2/carriers_rear)
						(ai_spawn_actor enc4_2/carriers_front)
					)
					
					; Increment counter
					(set enc4_2_limiter (+ enc4_2_limiter 1))
				)
			)
			
			; Simple inf form spawnage
			(if (< (ai_living_count enc4_2/infs) min_infection_spawn)
				(ai_place enc4_2/infs)
				(print "foo")
			)
		)
	)	 

	; Pause for a moment
	(sleep 200)
)


; Encounter 3_8 spawn wave
(script continuous enc3_8_spawner
	; Check if there are covenant alive
	(if 
		(and 
			(> (ai_living_count enc3_8_cov) 0)
			(< enc3_8_limiter (* 40 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc3_8_flood/combats) (* 1.5 min_combat_spawn))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_8_flood/combats)
					(set enc3_8_limiter (+ enc3_8_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc3_8_flood/carriers) (* 1.5 min_carrier_spawn))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_8_flood/carriers)
					(set enc3_8_limiter (+ enc3_8_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 15)
)


; Encounter 3_5 spawn wave
(script continuous enc3_5_spawner
	; Check if there are covenant alive
	(if (< enc3_5_limiter (* 30 spawn_scale))
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc3_5_flood/combats) (* 2 min_combat_spawn))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_5_flood/combats)
					(set enc3_5_limiter (+ enc3_5_limiter 1))
				)
			)
			
			;* Check the sniper count. If it is too low, spawn
			(if (< (ai_living_count enc3_5_flood/snipers) min_combat_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_5_flood/snipers)
					(set enc3_5_limiter (+ enc3_5_limiter 1))
				)
			) *;
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc3_5_flood/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_5_flood/carriers)
					(set enc3_5_limiter (+ enc3_5_limiter 1))
				)
			)
		)
	)	 

	; Pause for a moment
	(sleep 30)
)


; Encounter 3_4 spawn wave
(global boolean enc3_4_spawn_in_water true)
(script continuous enc3_4_spawner
	; Check if there are covenant alive
	(if (< enc3_4_limiter (* 30 spawn_scale))
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc3_4_flood/combats) 1)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_4_flood/combats)
					(set enc3_4_limiter (+ enc3_4_limiter 1))
				)
			)
		)
	)	 
	
	; If we're allowed, spawn carriers in the water
	(if enc3_4_spawn_in_water
		(if (< (ai_nonswarm_count enc3_4_flood/water) min_carrier_spawn)
			; Spawn 'em
			(ai_place enc3_4_flood/water)
		)
	)

	; Pause for a moment
	(sleep 30)
)


; Encounter 3_2 spawn wave
(script continuous enc3_2_spawner
	; Check if there are covenant alive
	(if (< enc3_2_limiter (* 40 spawn_scale))
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (< (ai_living_count enc3_2_flood/combats) (* min_combat_spawn 2))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_2_flood/combats)
					(set enc3_2_limiter (+ enc3_2_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc3_2_flood/carriers) (* min_carrier_spawn 2))
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc3_2_flood/carriers)
					(set enc3_2_limiter (+ enc3_2_limiter 1))
				)
			)
			
			; Check the infection form count. If it is too low, spawn
			(if (< (ai_living_count enc3_2_flood/infs) min_infection_spawn)
				; Spawn 'em 
				(ai_place enc3_2_flood/infs)
			)
		)
	)	 

	; Pause for a moment
	(sleep 30)
)


; Encounter 1_5 spawn wave
(script continuous enc1_5_spawner
	; Check if there are covenant alive
	(if 
		(and 
			(volume_test_objects_all enc1_5_spawner (players))
			(< enc1_5_limiter (* 60 spawn_scale))
		)
	
		; These conditions are met. Spawn.
		(begin 
			; Check the combat form count. If it is too low, spawn
			(if (<= (ai_living_count enc1_5_flood/combats)
				(* (+ (/ enc1_5_limiter 20) 1) min_combat_spawn) ; JUST ASK TYSON			
			)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc1_5_flood/combats)
					(set enc1_5_limiter (+ enc1_5_limiter 1))
				)
			)
			
			; Check the carrier form count. If it is too low, spawn
			(if (< (ai_living_count enc1_5_flood/carriers) min_carrier_spawn)
				; Spawn 'em and increment the count
				(begin 
					(ai_spawn_actor enc1_5_flood/carriers)
					(set enc1_5_limiter (+ enc1_5_limiter 1))
				)
			)
			
			; Check the infection form count. If it is too low, spawn
			(if (<= (ai_living_count enc1_5_flood/infections) (* 2 min_infection_spawn)
			)
				; Spawn 'em
				(ai_place enc1_5_flood/infections)
			)
		)
	)	 

	; Pause for a moment
	(sleep 30)
)


; Put all continuous spawn waves to sleep immediately
(script static void stun_spawn_waves
	; Debug
	(if debug (print "Stunning spawn waves..."))
	
	; Sleep all of the spawn waves
	(sleep -1 enc1_5_spawner)
	(sleep -1 enc3_2_spawner)
	(sleep -1 enc3_4_spawner)
	(sleep -1 enc3_5_spawner)
	(sleep -1 enc3_8_spawner)
	(sleep -1 enc4_2_spawner)
	(sleep -1 enc4_4_spawner)
	(sleep -1 enc7_5_spawner)
)


;- Vehicles --------------------------------------------------------------------


; Section 7 Banshee 1 Entrance
(script static void ending_banshee1
	; Create 'em
	(object_create ending_banshee1)
	(object_cannot_take_damage ending_banshee1)

	; Port 'em
	(object_teleport ending_banshee1 ending_banshee1)
	(recording_play_and_hover ending_banshee1 ending_banshee1_v7)
)

; Section 7 Banshee 2 Entrance
(script static void ending_banshee2
	; Create 'em
	(object_create ending_banshee2)
	(object_cannot_take_damage ending_banshee2)

	; Port 'em
	(object_teleport ending_banshee2 ending_banshee2)
	(recording_play_and_hover ending_banshee2 ending_banshee2_v7)
)

; Section 7 Dropship Entrance
(script static void outro_dropship
	(object_create outro_dropship)
	(object_teleport outro_dropship outro_dropship)
	(recording_play_and_hover outro_dropship outro_dropship)
	(unit_close (unit outro_dropship))
)


; Encounter 3_3 overflight banshees
(script static void enc3_3_banshees
	; Create 'em
	(object_create enc3_3_banshee1)
	(object_create enc3_3_banshee2)

	; Port 'em
	(object_teleport enc3_3_banshee2 enc3_3_banshee1)
	(object_teleport enc3_3_banshee1 enc3_3_banshee2)

	; Play 'em
	(recording_play (unit enc3_3_banshee1) enc3_3_banshee1)
	(recording_play (unit enc3_3_banshee2) enc3_3_banshee2)

	; Wait for it... waaaait for it....
	(sleep (max (recording_time enc3_3_banshee1) (recording_time enc3_3_banshee2)))

	; Delete 'em
	(object_destroy enc3_3_banshee1)
	(object_destroy enc3_3_banshee2)
)


; Section 3 finale banshees
(script static void enc3_9_banshees
	; Create, port, play
	(object_create enc3_9_banshee1)
	(object_teleport enc3_9_banshee1 enc3_9_banshee1)
	(recording_play (unit enc3_9_banshee1) enc3_9_banshee1)
	(sleep 75)

	(object_create enc3_9_banshee2)
	(object_teleport enc3_9_banshee2 enc3_9_banshee1)
	(recording_play (unit enc3_9_banshee2) enc3_9_banshee2)
	
	; Wait for one to end
	(sleep (recording_time enc3_9_banshee1))
	(object_destroy enc3_9_banshee1)
	(sleep (recording_time enc3_9_banshee2))
	(object_destroy enc3_9_banshee2)
)


;- Section 7 Encounters --------------------------------------------------------

; Banshee dialog hook
(script dormant banshee_hook
	(sleep 450)
	
	; Wait for eye contact
	(sleep_until
		(or
			(objects_can_see_object (players) ending_banshee1 10)
			(objects_can_see_object (players) ending_banshee2 10)
		)
	)
)

; Safety net for banshees
(script continuous banshee_safety_net
	; If no banshees are in the hanger trigger volume...
	(sleep_until 
		(and
			(not (volume_test_objects enc7_6c ending_banshee1))
			(not (volume_test_objects enc7_6c ending_banshee2))
		)
	)
	
	; Teleport those banshees to their cutscene points
	(object_teleport ending_banshee1 safety_banshee1)
	(object_teleport ending_banshee2 safety_banshee2)
)

; Section 7 Banshees
(script static void ending_banshees
	; Fly 'em in
	(ending_banshee1)
	(ending_banshee2)
	(sleep 90)
	(outro_dropship)

	; Create the units inside of them
	(ai_place enc7_4)
	(ai_force_active enc7_4 true)
	(vehicle_load_magic outro_dropship "passenger" (ai_actors enc7_4/grunts))
	(vehicle_load_magic ending_banshee1 "B-driver" (list_get (ai_actors enc7_4/elites1) 0))
	(vehicle_load_magic ending_banshee2 "B-driver" (list_get (ai_actors enc7_4/elites2) 0))
	(ai_braindead enc7_4 true)

	; Run cortana's dialogue
	(wake banshee_hook)

	; Time the hovering correctly
	(if (< (recording_time ending_banshee1) (recording_time ending_banshee2))
		(begin
			; Unload banshee 1
			(sleep (recording_time ending_banshee1))
			(vehicle_unload ending_banshee1 "B-driver")
			(ai_braindead enc7_4/elites1 false)		

			; Unload banshee 2
			(sleep (recording_time ending_banshee2))
			(vehicle_unload ending_banshee2 "B-driver")
			(ai_braindead enc7_4/elites2 false)		
		)
		(begin
			; Unload banshee 2
			(sleep (recording_time ending_banshee2))
			(vehicle_unload ending_banshee2 "B-driver")
			(ai_braindead enc7_4/elites2 false)		

			; Unload banshee 1
			(sleep (recording_time ending_banshee1))
			(vehicle_unload ending_banshee1 "B-driver")
			(ai_braindead enc7_4/elites1 false)		
		)
	)
	
	; Do the dropship too
	(sleep (max 0 (- (recording_time outro_dropship) 90)))
	(unit_open (unit outro_dropship))
	(sleep (recording_time outro_dropship))
	
	; Unload the grunts
	(vehicle_unload outro_dropship "passenger")
	(ai_braindead enc7_4/grunts false)
	(ai_migrate enc7_4/grunts enc7_6_cov/exit_grunts)

	; Migrate
	(ai_migrate enc7_4/elites1 enc7_6_cov/lower_elites)
	(ai_migrate enc7_4/elites2 enc7_6_cov/lower_elites)
	
	; Wake the safety net
	(wake banshee_safety_net)
)


; Manager for enc7_6
(global short enc7_6_limiter 0)
(script continuous enc7_6_manager
	; 5l33p un71L k1LL
	(sleep_until
		(and
			(volume_test_objects_all enc7_6 (players))
			(<= enc7_6_limiter (* spawn_scale 8))
		)
	)
	
	; Place door guards?
	(if (<= (ai_living_count enc7_6_cov/exit_grunts) 1)
		(begin
			(ai_place enc7_6_cov/exit_grunts)
			(set enc7_6_limiter (+ enc7_6_limiter 1))
		)
	)
	
	; Place lower elites?
	(if (<= (ai_living_count enc7_6_cov/lower_elites) 1)
		(begin
			(ai_place enc7_6_cov/lower_elites)
			(set enc7_6_limiter (+ enc7_6_limiter 1))
		)
	)
	
	; Place upper elites?
	(if (<= (ai_living_count enc7_6_cov/upper_elites) 1)
		(begin
			(ai_place enc7_6_cov/upper_elites)
			(set enc7_6_limiter (+ enc7_6_limiter 1))
		)
	)
)


; Encounter 7_6, triggered by Encounter 7_2
(script dormant enc7_6
	; Sleep until the player is inside the volume
	(sleep_until (volume_test_objects enc7_6 (players)))
	(certain_save)
	
	; Debug
	(if debug (print "Encounter 7.6..."))
	
	; Don't do much of anything here... EXCEPT KILL THE PLAYER!!! AHAHAHAHAAAA...
	(wake enc7_6_manager)
	
	; Wait till the player drops down, then create units if warranted
	(sleep_until (volume_test_objects enc7_6c (players)))
	(certain_save)
	(if (<= (ai_living_count enc7_6_cov) 2)
		(ai_place enc7_6_cov)
	)
)


; Encounter 7_5, triggered by Encounter 7_1
(script dormant enc7_5
	; Sleep until the player is inside the volume
	(sleep_until (volume_test_objects_all enc7_5 (players)) testing_fast)
	
	; Debug
	(if debug (print "Encounter 7.5...."))
	(certain_save) 
	
	; Clean up!
	(ai_erase enc7_1_cov)
	(ai_erase enc7_3)
	
	; Wake the spawn wave
;	(wake enc7_5_spawner)
)


; Encounter 7_3, triggered by Encounter 7_2
(script dormant enc7_3
	; Sleep until the player is inside the volume
	(sleep_until (volume_test_objects enc7_3 (players)) testing_fast)
	
	; Debug
	(if debug (print "Encounter 7.3..."))
	(certain_save) 
	
	; Reveal the barricades
	(object_create enc7_3_barricade1)
	(object_create enc7_3_barricade2)
	
	; Place the AI
	(ai_place enc7_3)
	(ai_magically_see_players enc7_3)
)


; Encounter 7_2, triggered by Encounter 7_1
(script dormant enc7_2
	; Sleep until the player is inside the volume
	(sleep_until 
		(or
			(volume_test_objects enc7_2 (players))
			(volume_test_objects enc7_2b (players))
			(volume_test_objects enc7_2c (players))
		)
	)

	; Debug
	(if debug (print "Encounter 7.2..."))
	(certain_save) 
	
	; Other important stuff
	(wake enc7_3)

	; Bring in the banshees
	(ending_banshees)
	
	; MUZAK!
	(sound_looping_start "levels\d20\music\d20_06" none 1)
		
	; Dialog and wake spawner
	(D20_250_Cortana)
	(wake enc7_6)

	; Test for ending conditions
	(sleep_until 
		(or
			(vehicle_test_seat_list ending_banshee1 "B-driver" (players))
			(vehicle_test_seat_list ending_banshee2 "B-driver" (players))
		)
	)
	
	; Make the players invulnerable
	(object_cannot_take_damage (players))
	
	; Turn off the safety net
	(sleep -1 banshee_safety_net)
	
	; They CAN take damage!
;	(object_can_take_damage ending_banshee1)
;	(object_can_take_damage ending_banshee2)
	
	; Game over, shut the AI off
;	(ai_disregard (players) true)
	
	; Wait a second, and then trigger the outro
	(sleep -1 more_blood_for_me)
	(sleep 15)

   (if (mcc_mission_segment "cine5_final") (sleep 1))
  
	(cinematic_outro)

	; k thnx gg
	(game_won)
)


; Encounter 7_1, triggered by Section6
(script dormant enc7_1
	; Sleep until the player is inside the volume
	(sleep_until (volume_test_objects enc7_1 (players)) testing_fast)
	
	; Debug
	(if debug (print "Encounter 7.1..."))
	(certain_save) 
	
	; Wake subsequent
	(wake enc7_2)
	(wake enc7_5)
	
	; Load textures
	(object_type_predict "vehicles\banshee\banshee")
	
	; Place the AI
	(ai_place enc7_1_cov)
	(ai_place enc7_1_flood)
	
	; Love!
	(ai_try_to_fight enc7_1_cov enc7_1_flood)
	(ai_magically_see_encounter enc7_1_cov enc7_1_flood)
	(ai_magically_see_encounter enc7_1_flood enc7_1_cov)
	
	; Sleep until the player forces an advance, then advance the Covies
	(sleep_until (volume_test_objects enc7_3 (players)))
	(ai_maneuver enc7_1_cov)
)


; Section 7, Begin
(script dormant section7
	; SLEP!!
	(sleep -1 enc7_6_manager)
	
	; FIRE UP THOSE COVENANT FIELD GENERATORS OF DETH!!!! VRROOOOOM!!!!
	(object_create enc7_6_shield1)
	(object_create enc7_6_shield2)

	; Sleep until the trigger
	(sleep_until (volume_test_objects section7 (players)) testing_fast)

	; Debug
	(if debug (print "Section 7..."))
	
	; Place "ambients", wake encs
	(ai_place enc7_0)
	(wake enc7_1)
	
	; Kill any units who might still be manning the hangar bay (garbage collection)
	(ai_erase enc5_1_cov)
)


;- Section 6 Encounters --------------------------------------------------------

; Encounter 6_2 manager script
(global short enc6_2_limiter 0)
(script continuous enc6_2_manager
	; Sleep until the player is inside the volume
	(sleep_until 
		(and
			(volume_test_objects enc6_2 (players))
			(< enc6_2_limiter (* spawn_scale 20))
		)
	)
	
	; Spawn actors if the flood counts are short
	(if (<= (ai_living_count enc6_1_flood/combats) (* 2 min_combat_spawn)) 
		(begin
			(ai_spawn_actor enc6_1_flood/combats)
			(set enc6_2_limiter (+ enc6_2_limiter 1))
		)
	)
	
	; Spawn actors if the flood counts are short
	(if (<= (ai_living_count enc6_1_flood/carriers) 1) 
		(begin
			(ai_spawn_actor enc6_1_flood/carriers)
			(set enc6_2_limiter (+ enc6_2_limiter 1))
		)
	)
)


; Encounter 6_1 manager script, looks after spawning, events, etc
(script continuous enc6_1_manager
	; Sleep until the player is inside the volume
	(sleep_until (volume_test_objects enc6_1 (players)))
	
	; Spawn actors if the flood counts are short
	(if (<= (ai_living_count enc6_1_flood/combats) 1) (ai_spawn_actor enc6_1_flood/combats))
	
	; Spawn covies if necessary
	(if 
		(and
			(<= (ai_living_count enc6_1_cov) 2)
			(<= enc6_1_limiter 3)
		)
		; Make sure the player is clear of both spawn points
		(if (not (volume_test_objects enc6_1b (players))) 
			(ai_place enc6_1_cov/reins1)
			(if (not (volume_test_objects enc6_1c (players)))
				(ai_place enc6_1_cov/reins2)
			)
		)
		
		; If at this point the count is greater than 2, we placed units, so inc
		(if (> (ai_living_count enc6_1_cov) 2)
			(set enc6_1_limiter (+ enc6_1_limiter 1))
		)
	)
	
	; Is the cov count around 4?
	(if (>= (ai_living_count enc6_1_cov) 4)
		; Get aggressive again
		(sleep 150)
		(ai_attack enc6_1_cov/def)
	)
)


; Enc 6_5 manager
(global short enc6_5_limiter 0)
(script continuous enc6_5_manager
	; Sleep until it's safe to spawn
	(sleep_until 
		(and
			(not (volume_test_objects enc6_4_stopper (players)))
			(<= enc6_5_limiter (* 6 spawn_scale))	
		)
	)
	
	; Spawn if necessary
	(if 
		(and
			(<= (device_get_position enc6_5_door1) .05)
			(<= (ai_nonswarm_count enc6_5_flood/left_door) (* 2 min_combat_spawn))
		)
		(begin
			(ai_place enc6_5_flood/left_door)
			(set enc6_5_limiter (+ enc6_5_limiter 1))
		)
	)
	
	; Spawn if necessary
	(if 
		(and
			(<= (device_get_position enc6_5_door2) .05)
			(<= (ai_nonswarm_count enc6_5_flood/right_door) (* 2 min_combat_spawn))
		)
		(begin
			(ai_place enc6_5_flood/right_door)
			(set enc6_5_limiter (+ enc6_5_limiter 1))
		)
	)
)


; Encounter 6_5, triggered by Encounter 6_3
(script dormant enc6_5
	; Debug
	(if debug (print "Encounter 6.5..."))
	
	; Power up the near doors, disable the far doors
	(device_set_power enc6_5_door1 1)
	(device_set_power enc6_5_door2 1)
	(device_operates_automatically_set enc6_5_door1 true)
	(device_operates_automatically_set enc6_5_door2 true)
	
	; Close the old doors
	(device_set_position enc6_5_door3 0)
	(device_set_power enc6_5_door3 0)
	
	; Wakey
	(ai_magically_see_players enc6_5_flood)
	(wake enc6_5_manager)			
)


; Encounter 6_4, triggered by Encounter 6_3
(script dormant enc6_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_4 (players)) testing_fast)

	; Debug
	(if debug (print "Encounter 6.4..."))
	
	; MUZAK!
	(sound_looping_set_alternate "levels\d20\music\d20_051" true)

	; Place the spec ops 
	(ai_place enc6_4_cov)			
	
	; Sleep until the trigger
	(sleep_until (volume_test_objects section6 (players)))
	(sleep -1 enc6_5_manager)
	
	; MUZAK!
	(sound_looping_stop "levels\d20\music\d20_051")
)


; Encounter 6_3, triggered by Encounter 6_2
(script dormant enc6_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_3 (players)))
	(ai_kill enc6_1_flood/carriers)
	(sleep_until 
		(and
			(volume_test_objects enc6_3 (players))
			(not (volume_test_objects enc6_3_safe (ai_actors enc6_1_flood)))
		)
	)

	; Kill script
	(sleep -1 enc6_2_manager)

	; Debug
	(if debug (print "Encounter 6.3..."))
	
	; MUZAK
	(sound_looping_stop "levels\d20\music\d20_05")
	(sleep 30)

   (if (mcc_mission_segment "cine4_blob") (sleep 1))
  
	; Run the cinematic 
	(cinematic_captain)
	(certain_save)
	(deactivate_team_nav_point_flag player waypoint5)

	; Wakey
	(wake enc6_4)

	; Sleep for a few moments, run dialogue
	(sleep 60)
	(D20_240_Cortana)
	(objective_escape)
	
	; MUZAK!
	(sound_looping_start "levels\d20\music\d20_051" none 1)
	
	; Wakey
	(wake enc6_5)
	(wake section7)
	(save_checkpoint7_1)
)


; Encounter 6_2, triggered by Section6
(script dormant enc6_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_2 (players)))

	; Kill the manager! KILL! Then wake the supercharged section manager
	(sleep -1 enc6_1_manager)
	(wake enc6_2_manager)
	
	; Debug
	(if debug (print "Encounter 6.2..."))
	(certain_save) 
	
	; Objective, and create the captain
	(objective_recover)
	(create_flood_captain)
	
	; Wake section 7 and save point
	(wake enc6_3)
	
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc6_4 (players)))

	; MUZAK!
	(sound_looping_set_alternate "levels\d20\music\d20_05" true)
)


; Encounter 6_1, triggered by Section6
(script dormant enc6_1
	; Wake next encounters
;	(wake enc5_2)
	
	; Debug
	(if debug (print "Encounter 6.1..."))
	(certain_save) 
	
	; Place the AI
	(ai_place enc6_1_cov/initial)
	(ai_place enc6_1_flood/initial)
	(ai_place enc6_1_flood/offensive_combats)
	
	; Love!
	(ai_try_to_fight enc6_1_cov enc6_1_flood)
	
	; Start up the 6_1 manager script
	(wake enc6_1_manager)
	
	; Sleep until the player violates the space in front of the entrance
	(sleep_until (volume_test_objects enc6_2 (players)))
	
	; Make the flood attack
	(ai_attack enc6_1_flood/def)
)


; Section 6, Begin
(script dormant section6
	; Sleep until the trigger
	(sleep_until (volume_test_objects section6 (players)))

	; Debug
	(if debug (print "Section 6..."))
	
	; Wake encs
	(wake enc6_1)
	(wake enc6_2)
)


;- Section 5 Encounters --------------------------------------------------------

; Chapter title test
(script dormant chapter_3_test	
	; Title
	(sleep_until (volume_test_objects enc7_1 (players)))
	(chapter_d20_3)
	
	; Trigger dialogue
	(sleep 45)
	(D20_flavor_050_CaptKeyes)
	(D20_flavor_060_Cortana)

	; MUZAK!
	(sound_looping_start "levels\d20\music\d20_05" none 1)
	(deactivate_team_nav_point_flag player waypoint5)
)


; Vehicle control stuff
(script dormant enc5_7_dropship_delivery
	; Create the dropship and move it into place
	(object_create enc5_7_dropship)
	(object_teleport enc5_7_dropship enc5_7_dropship)

	; Create the units and then stuff them into the dropship
	(ai_place enc5_7_cov/specops)
	(ai_braindead enc5_7_cov/specops true)
	(vehicle_load_magic enc5_7_dropship "passenger" (ai_actors enc5_7_cov/specops))
	
	; Start the recording, and wait for the time to disgorge the units
	(recording_play (unit enc5_7_dropship) enc5_7_dropship)
	(sleep 640)
	
	; Drop the units
	(vehicle_unload enc5_7_dropship "passenger")
	(ai_braindead enc5_7_cov/specops false)

	; Sleep the rest of the time, then kill the ship
	(sleep (recording_time enc5_7_dropship))
	(object_destroy enc5_7_dropship)
)


; Enc 5_7 manager
(global short enc5_7_limiter 0)
(script continuous enc5_7_manager
	; Sleep until it's safe to spawn
	(sleep_until 
		(and
			(volume_test_objects_all enc7_6 (players))
			(<= enc5_7_limiter (* 6 spawn_scale))	
		)
	)
	
	; Spawn if necessary
	(if (<= (ai_nonswarm_count enc5_7_flood/reins) (* 2 min_combat_spawn))
		(begin
			(ai_place enc5_7_flood/reins)
			(set enc5_7_limiter (+ enc5_7_limiter 1))
		)
	)
)


; Encounter 5_7, triggered by Encounter 5_4
(script dormant enc5_7
	; Sleep until the player is inside the volume(s)
	(sleep_until (volume_test_objects enc5_7 (players)))
		
	; Debug
	(if debug (print "Encounter 5.7..."))
	(certain_save) 
	
	; Special delivery! (Dropship flies in to drop off specop guys)
	(wake enc5_7_dropship_delivery)
	(wake chapter_3_test)
	
	; MUZAK!
	(sound_looping_stop "levels\d20\music\d20_04")
	
	; Place the AI
	(ai_place enc5_7_flood)
	(if (objects_can_see_flag (players) enc5_7_elites 30)
		(ai_place enc5_7_cov/elites1)
		(ai_place enc5_7_cov/elites2)
	)
	
	; Love!
	(ai_magically_see_players enc5_7_cov)
	(ai_magically_see_players enc5_7_flood)
	
	; Wait for the player to press forward, the go on the offensive and place more
	(sleep_until 
		(or
			(volume_test_objects enc7_2 (players))
			(volume_test_objects enc7_2b (players))
			(volume_test_objects enc7_2c (players))
		)
	)
	(ai_attack enc5_7_flood)
	
	; FIRE UP THE FLUD SPONR OF DETH!!!!!!!!!
	(wake enc5_7_manager)
	
	; Wait until the flood are dead, then place the next waypoint
	(sleep_until 
		(or
			(<= (ai_living_count enc5_7_flood) 0)
			(volume_test_objects enc7_6 (players))
		)
	)
	(D20_220_Cortana)
	
	; Wait to sleep 
	(sleep_until (volume_test_objects enc7_6 (players)))
	(sleep -1 enc5_7_manager)
)


; Encounter 5_6, triggered by Encounter 5_4
(script dormant enc5_6
	; Sleep until the player is inside the volume(s)
	(sleep_until (volume_test_objects enc5_6 (players)))
		
	; Debug
	(if debug (print "Encounter 5.6..."))
	(certain_save) 
	
	; Place the AI
	(ai_place enc5_6)
	
	; Love!
	(ai_magically_see_players enc5_6)
	
	; And do some preloading for the dropship
	(object_type_predict "vehicles\c_dropship\c_dropship")
)


; Encounter 5_5, triggered by Encounter 5_4
(script dormant enc5_5
	; Sleep until the player is inside the volume(s)
	(sleep_until (volume_test_objects enc5_5 (players)))
		
	; Debug
	(if debug (print "Encounter 5.5..."))
	(certain_save) 
	
	; Place the AI
	(ai_place enc5_5_cov)
	(ai_place enc5_5_flood)
	
	; Love!
	(ai_magically_see_encounter enc5_4_flood enc5_4_cov)
	(ai_try_to_fight enc5_4_flood enc5_4_cov)
	(ai_try_to_fight enc5_4_cov enc5_4_flood)
)


; Encounter 5_4, triggered by Section5
(script dormant enc5_4
	; Sleep until the player is inside the volume(s)
	(sleep_until (volume_test_objects enc5_4 (players)))
	
	; Wakey wakey
	(wake enc5_5)
	(wake enc5_6)
	(wake enc5_7)
		
	; Debug
	(if debug (print "Encounter 5.4..."))
	(certain_save) 
	
	; Place the AI
	(ai_place enc5_4_cov)
	(ai_place enc5_4_flood)
	
	; Love!
	(ai_magically_see_encounter enc5_4_flood enc5_4_cov)
	(ai_try_to_fight enc5_4_flood enc5_4_cov)
)


; Encounter 5_3, triggered by Section5
(script dormant enc5_3
	; Sleep until the player is inside the volume(s)
	(sleep_until 
		(or 
			(volume_test_objects enc5_3 (players))
			(volume_test_objects enc5_3b (players))
		)
	)
		
	; Debug
	(if debug (print "Encounter 5.3..."))
	(certain_save) 
	
	; Place the AI
	(ai_place enc5_3_cov)
	(ai_place enc5_3_flood)
	(ai_link_activation enc5_3_cov enc5_3_flood)
	(ai_link_activation enc5_3_flood enc5_3_cov)
	(ai_playfight enc5_3_flood true)

	; Love!
	(ai_try_to_fight enc5_3_cov enc5_3_flood)
)


; Encounter 5_1 manager script, looks after spawning, events, etc
(global short enc5_1_limiter 0)
(script continuous enc5_1_manager
	; Sleep until the player is inside the volume
	(sleep_until 
		(and	
			(<= enc5_1_limiter 30)
			(volume_test_objects_all enc7_6 (players))
		)
	)
	
	; Spawn actors if the flood counts are short
	(if (<= (ai_living_count enc5_1_flood/upper_combats) min_combat_spawn) 
		(begin
			(ai_spawn_actor enc5_1_flood/upper_combats)
			(set enc5_1_limiter (+ enc5_1_limiter 1))
		)
	)
	
	; Spawn covies if necessary
	(if (<= (ai_living_count enc5_1_cov/gunner_elites) 1) 
		(begin
			(ai_spawn_actor enc5_1_cov/gunner_elites)
			(set enc5_1_limiter (+ enc5_1_limiter 1))
		)
	)
	(if (<= (ai_living_count enc5_1_cov/gunner_grunts) 1) 
		(begin
			(ai_spawn_actor enc5_1_cov/gunner_grunts)
			(set enc5_1_limiter (+ enc5_1_limiter 1))
		)
	)
	
	; Pause
	(sleep 30)
)

; Encounter 5_2, triggered by Section5
(script dormant enc5_2
	; Sleep until the player is inside the volume(s)
	(sleep_until 
		(or 
			(volume_test_objects enc5_2 (players))
			(volume_test_objects enc5_2b (players))
		)
	)
		
	; Debug
	(if debug (print "Encounter 5.2..."))
	(certain_save) 
	
	; Kill the spawner
	(sleep -1 enc5_1_manager)
	
	; Place the AI
	(ai_place enc5_2_cov)
	(ai_place enc5_2_flood)
	(ai_link_activation enc5_2_cov enc5_2_flood)
	(ai_link_activation enc5_2_flood enc5_2_cov)
	
	; Love!
	(ai_try_to_fight enc5_2_cov enc5_2_flood)
)


; Encounter 5_1, triggered by Section5
(script dormant enc5_1
	; Debug
	(if debug (print "Encounter 5.1..."))
	(certain_save) 
	
	; Place the AI
	(ai_place enc5_1_cov/inits)
	(ai_place enc5_1_cov/inits)
	(ai_place enc5_1_flood/infs)
	
	; Love!
	(if (not (= "impossible" (game_difficulty_get)))
		(ai_try_to_fight enc5_1_cov enc5_1_flood)
	)
	
	; Start up the 5_1 manager script
	(wake enc5_1_manager)

	; Sleep until the player is inside the hanger, then do the next dialog
	(sleep_until (volume_test_objects enc5_1 (players)))
	(D20_210_Cortana)
	
	; Wait a bit, then do more dialog
	(sleep 150)
	(D20_flavor_030_CaptKeyes)
	(D20_flavor_040_Cortana)

	; MUZAK!
	(sound_looping_start "levels\d20\music\d20_04" none 1)
	
	; Sleep until the player is far enough to end the spawner
	(sleep_until (volume_test_objects enc5_6 (players)))
	(sleep -1 enc5_1_manager)

	; Kill!
	(if (not coop)
		(begin
			(ai_erase enc5_1_cov)
			(ai_erase enc5_1_flood)
		)
	)
)


; Section 5, Begin
(script dormant section5
	; Sleepy
	(sleep -1 enc5_7_manager)

	; Sleep until the trigger
	(sleep_until (volume_test_objects section5 (players)))

	; Debug
	(if debug (print "Section 5..."))
	
	; Place the vehicles
	(object_create enc5_1_turret)
	(vehicle_hover enc5_1_turret true)
	
	; Make the gun enterable
	(ai_vehicle_enterable_distance enc5_1_turret 10)

	; Wake encs
;	(wake more_blood_for_me)
;	(wake enc5_1_music_control)
	(wake enc5_1)
	(wake enc5_2)
	(wake enc5_3)
	(wake enc5_4)

	; Sleep till section6, or four minutes
	(sleep_until (volume_test_objects section6 (players)) 30 7200)
	(sound_looping_stop "levels\d20\music\d20_04")
)


;- Section 4 Encounters --------------------------------------------------------

;* 	Area:		Section 4
  	 Begins:		Gravity lift room inside of ship, after exterior area ends
  	   Ends:		In corridor just prior to shuttle bay, at BSP swap 2->3

  Synopsis:		- Player arrives in pad room, in which lay several bodies
  					- Player exits through only operable door
  					- Player is ambushed by carrier and inf forms
  					- Player enters muster bay on upper level, undetected at first.
  					  After a short period, or if he shoots, he is discovered.
  					- If player travels route from first to second floor, he 
  					  encounters a wave of flood halfway through the connection
  					- Player exits through first floor exit, is ambushed by several
  					  flood waiting around a corner. After the first group is killed,
  					  another smaller group follows
  					- Player drops through hole in the floor, and is ambushed by
  					  carrier forms below
  					- Player encounters several carrier and combat forms engaged by
  					  unseen covenant 
  					- Player encounters unseen covenant, axes dey azz wit his GAT!
  					- A large mob of infection forms broadside the player

	 Issues:		- Units outside of visible clusters do not activate all the time
	 				- Player may need some prompting to jump down the hole (player
	 				  may not even see the hole)
	 				- Overturned ghost vehicle should not be boardable.
	 				- Encounters near the end of the section/BSP might overlap into
	 				  the next BSP--this could cause units to freeze and be Bad(tm)

 Hierarchy:		-> MISSION START
 						-> section4 (immediate)
 							-> enc4_1 (immediate)
 								-> enc4_2 (trigger volume)
 									-> enc4_3 (trigger volume)
 										-> enc4_4 (trigger volume)
 										-> enc4_5 (trigger volume)
 											-> enc4_6 (trigger volume)
 												-> enc4_7 (trigger volume)
 												-> enc4_8 (trigger volume)
*;


; Encounter 4_9, triggered by Encounter 4_7
(script dormant enc4_9
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_9 (players)))
	
	; Debug
	(if debug (print "Encounter 4.9..."))
	(certain_save) 
	
	; Place the cov
	(ai_place enc4_9_cov)
	
	; Sleep until the trigger, toss!
	(sleep_until (volume_test_objects enc4_9b (players)) testing_fast)
	(ai_command_list enc4_9_cov/grunts enc4_9_grenade_toss)
)


; Enc 4_8 manager
(global short enc4_8_limiter 0)
(script continuous enc4_8_manager
	; Sleep until it's safe to spawn
	(sleep_until 
		(and
			(volume_test_objects_all enc4_8_spawner (players))
			(<= enc4_8_limiter (* 6 spawn_scale))	
		)
	)
	
	; Spawn if necessary
	(if (<= (ai_nonswarm_count enc4_8/combats) min_combat_spawn)
		(begin
			(ai_place enc4_8/combats)
			(set enc4_8_limiter (+ enc4_8_limiter 1))
		)
	)
	(if (<= (ai_nonswarm_count enc4_8/combats_upper) min_combat_spawn)
		(begin
			(ai_place enc4_8/combats_upper)
			(set enc4_8_limiter (+ enc4_8_limiter 1))
		)
	)
)


; Encounter 4_8, triggered by Encounter 4_6
(script dormant enc4_8
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_8 (players)))
	
	; Debug
	(if debug (print "Encounter 4.8..."))
	(certain_save) 
	
	; Destroy some objects
	(object_destroy_containing "2_")		; OBLITERATES bipeds placed on BSP 2

	; Place the first set of carriers, wake the spawner
	(ai_place enc4_8)

	; Sleep, wait for the door
	(sleep_until (volume_test_objects_all enc4_8_spawner (players)))
	(device_set_position_immediate enc4_8_door 1)
	(wake enc4_8_manager)
		
	; Sleep until the trigger, then kill it
	(sleep_until (volume_test_objects section5 (players)))
	(sleep -1 enc4_8_manager)
)


; Encounter 4_7, triggered by Encounter 4_6
(script dormant enc4_7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_7 (players)))
	
	; Wake next encounters
	(wake enc4_9)
	
	; Debug
	(if debug (print "Encounter 4.7..."))
	(certain_save) 
	
	; Place the flood
	(ai_place enc4_7_flood)
	
	; Place the covies
	(ai_place enc4_7_cov)
	(ai_link_activation enc4_7_cov enc4_7_flood)
	
	; Make them love each other
	(ai_playfight enc4_7_flood true)
	(ai_try_to_fight enc4_7_flood enc4_7_cov)
	
	; Sleep until the combat forms are dead, then advance the covs
	(sleep_until (<= (ai_living_count enc4_7_flood/combats) 0))
	(ai_maneuver enc4_7_cov)
)


; Encounter 4_6, triggered by Encounter 4_5
(script dormant enc4_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_6 (players)))
	
	; MUZAK!
	(sound_looping_stop "levels\d20\music\d20_03")

	; Do some erasure
	(if (not coop)
		(begin
			(ai_erase enc4_3)
			(ai_erase enc4_4)
		)
	)

	; Wake next encounters
	(wake enc4_7)
	(wake enc4_8)
	
	; Debug
	(if debug (print "Encounter 4.6..."))
	(certain_save) 
	
	; Place the first set of carriers
	(ai_place enc4_6)
)


; Encounter 4_5, triggered by Encounter 4_3
(script dormant enc4_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_5 (players)))
	
	; Wake next encounters
	(wake enc4_6)
	
	; Debug
	(if debug (print "Encounter 4.5..."))
	(certain_save) 
	
	; Place the first set of carriers
	(ai_place enc4_5/infs)
	(ai_place enc4_5/init_combats)
;	(ai_place enc4_5/carriers)
	
	; Sleep until the first wave is dead
	(sleep_until (<= (ai_nonswarm_count enc4_5) 2))
	
	; If the player is clear, spawn a second wave
	(if 
		(not
			(volume_test_objects enc4_5b (players))
		)
		
		; Spawn dat fukr
		(ai_place enc4_5/combats)
	)
)


; Encounter 4_4, triggered by Encounter 4_3
(script dormant enc4_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_4 (players)))
	
	; Debug
	(if debug (print "Encounter 4.4..."))
	(certain_save) 
	
	; Start the wave
	(wake enc4_4_spawner)
)


; Enc 4_3 dialogue
(script dormant enc4_3_dialogue
	(sleep_until (volume_test_objects enc4_3b (players)))	
	(D20_200_Cortana)
)


; Encounter 4_3, triggered by Encounter 4_2
(script dormant enc4_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_3 (players)))
	
	; Wake next encounters
	(wake enc4_4)
	(wake enc4_5)
	
	; Debug
	(if debug (print "Encounter 4.3..."))
	(certain_save) 
	
	; Place the first set of carriers
	(ai_place enc4_3/combats)
	(ai_place enc4_3/carriers)
	(ai_place enc4_3/infs)

	; Kill the last spawn wave
	(sleep -1 enc4_2_spawner)
	
	; MUZAK!
	(sound_looping_start "levels\d20\music\d20_03" none 1)

	; Dialog
	(wake enc4_3_dialogue)

	; Sleep until a) flood are damaged, b) trigger volumes are tripped
	(sleep_until
		(or
			(< (ai_strength enc4_3) 1)
			(volume_test_objects enc4_3c (players))
		)
	)
	
	; Sleep until the flood are mostly gone... then wait for the player...
	(sleep_until (<= (ai_nonswarm_count enc4_3) 2))
	(sleep_until (volume_test_objects enc4_3c (players)) 30 900)
	
	; MUZAK!
	(sound_looping_set_alternate "levels\d20\music\d20_03" true)
	(sleep 60)

	; BLAM HIM!
	(device_group_set_immediate enc4_3_door 1)
	(device_set_position enc4_3_door 1)
	(ai_place enc4_3/second_wave)

	; Terminate enc4_4's spawner if it's running
	(sleep -1 enc4_4_spawner)
)


; Enc 4_2 dialogue hooks
(script dormant enc4_2_dialogue
	(sleep 45)
	(D20_190_Cortana)
)

; Encounter 4_2, triggered by Encounter 4_1
(script dormant enc4_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_2 (players)))
	
	; Wake next encounters
	(wake enc4_3)
	(wake enc4_2_dialogue)
	
	; Debug
	(if debug (print "Encounter 4.2..."))
	(certain_save) 
	
	; Place the first set of carriers
	(ai_place enc4_2/carriers1)
	(ai_magically_see_players enc4_2)
	
	; Wait for the next trigger
	(sleep_until (volume_test_objects enc4_2b (players)))
	
	; Trigger the spawn wave
	(wake enc4_2_spawner)
)


; Enc 4_1 dialogue hooks
(script dormant enc4_1_dialogue
	(sleep 45)
	(D20_180_Cortana)
)

; Encounter 4_1, triggered by Section4
(script dormant enc4_1
	; Wake next encounters
	(wake enc4_2)
	
	; Debug
	(if debug (print "Encounter 4.1..."))
	(certain_save) 
	
	; Run dialogue
	(wake enc4_1_dialogue)
	(chapter_d20_2)
	(objective_muster)
)


; Section 4, Begin
(script dormant section4
	; Sleep until the trigger
	(sleep_until (volume_test_objects section4 (players)))
	(deactivate_team_nav_point_flag player waypoint2)
	
	; Debug
	(if debug (print "Section 4..."))
	(certain_save)
	
	; Sleep if necessary
	(sleep -1 enc4_8_manager)
	(sleep -1 i_am_skin_diver)
	
	; Kill lots of remaining units
	(ai_erase med1_flood)
	(ai_erase enc3_8_cov)
	(ai_erase enc3_8_flood)
	(ai_erase enc3_7_cov)
	(ai_erase enc3_7_flood)
	(ai_erase enc3_7b)
	(ai_erase enc3_5_cov)
	(ai_erase enc3_5_flood)
	(ai_erase enc3_4_cov)
	(ai_erase enc3_4_flood)
	(ai_erase enc3_3)
	(ai_erase enc3_2_cov)
	(ai_erase enc3_2_flood)
	(ai_erase enc3_1_cov)
	(ai_erase enc3_1_flood)

	; Garbage collect
	(garbage_collect_now)
	
	; Place dead bipeds (it should be safe to do so at this point)
	(object_create_containing "2_")		; Places bipeds placed on BSP 2

	; De-immunize players
	(object_can_take_damage (players))

	; Place "ambient" units
	(ai_place enc4_0)
	
	; Wake enc4_1
	(wake enc4_1)
)


;- Section 3 Encounters --------------------------------------------------------

;* 	Area:		Section 3
  	 Begins:		At start of exterior environment, where player falls from ship
  	   Ends:		At gravity lift, where player re-enters the ship
  	   
  Synopsis:		- Player drops from ship, landing unharmed in media (CINEMATIC NOT FINISHED)
  					- Small covenant squad is holding narrow pass against flood
  					- Larger covenant squad is cornered by flood leaping from cliffs 
  					  into media. Smaller first squad will reinforce this larger
  					  squad if they survive long enough.
  					  ...

	 Issues:		- No plan for control room
	 				- No infection forms yet
	 				- Difficulty of Flood encounter near hole needs to be high enough
	 				  to make the player want to jump, but not enough to kill him
	 				  immediately

 Hierarchy:		-> MISSION START
 						-> section1 (immediate)
 							-> enc1_1 (trigger volume)
 								-> enc1_2 (trigger volume)
 									-> enc1_3 (immediate)
 										-> enc1_4 (trigger volume)
 											-> enc1_5 (trigger volume)
*;

; Encounter 3_9, triggered by Section3
(script dormant enc3_9
	; Sleep until the trigger
	(sleep_until (volume_test_objects_all grav_lift (players)))
	
	; Clean up
	(ai_erase enc3_7_flood)
	(ai_erase enc3_7_cov)
	
	; Debug
	(if debug (print "Encounter 3.9..."))
)


; Dialog hooks for enc3_8
(script dormant enc3_8_dialogue
	; Wait till the player is looking at the lift
	(sleep_until (objects_can_see_flag (players) waypoint2 45))
	(D20_160_Cortana)
	(objective_lift)
)


; Banshee hooks for enc3_8
(script dormant enc3_9_banshee_hook
	(enc3_9_banshees)
)


; Gravity lift counter
(global short lift_counter 0)
(script continuous enc3_8_lift_manager
	(sleep 30)
	(if (volume_test_objects 1_to_2_transition_trigger (players))
		(set lift_counter (+ 1 lift_counter))
		(set lift_counter 0)
	)
)


; Encounter 3_8
(script dormant enc3_8
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_8 (players)))
	(certain_save) 
	
	; Debug
	(if debug (print "Encounter 3.8..."))
	
	; Wake next encounters
	(wake enc3_8_dialogue)
	(wake enc3_9)

	; MUZAK!
	(sound_looping_set_alternate "levels\d20\music\d20_02" true)

	; Place the Covies
	(ai_place enc3_8_cov)
	
	; FIRE UP THE FLOOD GENERATOR OF DOOM(tm)
	(wake enc3_8_spawner)
	
	; Wait till the player hits the trigger, then kill the spawner
	(sleep_until (volume_test_objects enc3_8b (players)))
	(sleep -1 enc3_8_spawner)
	
	; Wait till the player hits the trigger, then drop a wave
	(sleep_until (volume_test_objects enc3_8b (players)))
	(ai_place enc3_8_flood/wave_combats)
	(ai_place enc3_8_flood/wave_carriers)
	(ai_place enc3_8_flood/wave_infs)
	(ai_magically_see_players enc3_8_flood)
	
	; Be mean to hard levels
	(if (= "impossible" (game_difficulty_get))
		(begin
			(ai_try_to_fight_player enc3_8_cov)
			(ai_try_to_fight_player enc3_8_flood)
		)
	)

	; Wait till he's in the lift
	(sleep_until 
		(and
			(volume_test_objects 1_to_2_transition_trigger (players))
			(not (volume_test_objects 1_to_2_transition_trigger (ai_actors enc3_8_cov)))
		)
	)
	(wake enc3_8_lift_manager)
	
	; Sleep until the time is ripe to lift the player
	(sleep_until (>= lift_counter 3))
	
	; Make the AI playfight, run the cinematic
	(ai_playfight enc3_8_flood true)
	(object_cannot_take_damage (players))
	(object_destroy_containing "1_")		; SLAUGHTERS bipeds placed on BSP 1

	; MUZAK!
	(sound_looping_stop "levels\d20\music\d20_02")

	; Sleep and destroy
	(sleep 30)

   (if (mcc_mission_segment "cine3_ship") (sleep 1))
      
	(garbage_collect_now)					; Clean up a bit
	(object_create_containing "2x_")		; Places bipeds in BSP 2 gravlift room
	(cinematic_lift)
)


;* Encounter 3_8, triggered by Section3
(script dormant enc3_8
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_8 (players)))
	(certain_save) 
	
	; Wake next encounters
	(wake enc3_8_dialogue)
	(wake enc3_9)
	
	; Debug
	(if debug (print "Encounter 3.8..."))
	
	; MUZAK!
	(set music_02_base false)

	; Place the Covies
	(ai_place enc3_8_cov)
	
	; FIRE UP THE FLOOD GENERATOR OF DOOM(tm)
	(wake enc3_8_spawner)
	
	; Sleep until covenant are nearly dead, then kill the spawner
;	(sleep_until (<= (ai_strength enc3_8_cov) .25))
;	(sleep -1 enc3_8_spawner)
	
	; Sleep until the next trigger
	(sleep_until (volume_test_objects enc3_8b (players)))

	; Flyby banshees
	(wake enc3_9_banshee_hook)

	; Wave 1
	(sleep_until (<= (ai_nonswarm_count enc3_8_flood) 1))
	(ai_place enc3_8_flood/wave_combats)
	(ai_place enc3_8_flood/wave_carriers)
	(ai_place enc3_8_flood/wave_infs)
	(ai_magically_see_players enc3_8_flood)
	
	; Kill the spawner
	(sleep -1 enc3_8_spawner)
	
	; Sleep until the next trigger
	(sleep_until (volume_test_objects enc3_8c (players)))
	(sleep_until (<= (ai_nonswarm_count enc3_8_flood) 1))
	
	; Wave 2
	(ai_place enc3_8_flood/wave_combats)
	(ai_place enc3_8_flood/wave_carriers)
	(ai_place enc3_8_flood/wave_infs)
	(ai_magically_see_players enc3_8_flood)
	
	; Sleep till the combat form count has decreased a bit
	(sleep_until (<= (ai_nonswarm_count enc3_8_flood) 3))
	
	; Sleep until the player is in the lift field, then transition
	(sleep_until 
		(and
			(volume_test_objects enc3_8c (players))
			(game_all_quiet)
		)
		30	
		900
	)
	(sleep_until (volume_test_objects enc3_8c (players)))
	(ai_kill enc3_8_flood)

	; OBLITERATES bipeds, place bipeds, transition
	(object_destroy_containing "1_")		; SLAUGHTERS bipeds placed on BSP 1
	(object_create_containing "2_")		; Places bipeds placed on BSP 2
	(cinematic_lift)
)
*;


; Encounter 3_7, triggered by Section3
(script dormant enc3_7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_7 (players)))
	(certain_save) 
	
	; Debug
	(if debug (print "Encounter 3.7..."))
	
	; MUZAK!
	(sound_looping_start "levels\d20\music\d20_02" none 1)

	; Wake next encounters, clean
	(wake enc3_8)
	(if (not coop)
		(begin
			(ai_erase enc3_4_flood)
			(ai_erase enc3_4_cov)
			(ai_erase enc3_5_flood)
			(ai_erase enc3_5_cov)
		)
	)
	
	; Place the units
	(ai_place enc3_7_cov)
	(ai_place enc3_7_flood)

	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_7b (players)))
	
	; Trigger second wave
	(ai_place enc3_7b)
	(ai_magically_see_players enc3_7b)
)


; Encounter 3_6, triggered by Section3
(script dormant enc3_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_6 (players)))
	(certain_save) 
	
	; Debug
	(if debug (print "Encounter 3.6..."))

	; Wake next encounters
	(wake enc3_7)
	
	; Kill the previous spawner
	(sleep -1 enc3_5_spawner)
)


; Dialog hooks for enc3_5
(script dormant enc3_5_dialogue
	; Wait till the player is up at the ship
	(sleep_until (objects_can_see_flag (players) enc3_4_dialogue_trigger 20))
	(D20_130_Cortana)
)


; Encounter 3_5, triggered by Section3
(script dormant enc3_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_5 (players)))
	(certain_save) 
	
	; Debug
	(if debug (print "Encounter 3.5..."))
	
	; Wake next encounters
	(wake enc3_6)
	
	; Kill the previous spawner
	(sleep -1 enc3_4_spawner)
	
	; Place the Covies
	(ai_place enc3_5_cov)
	(ai_go_to_vehicle enc3_5_cov/gunner enc3_5_turret gunner)
	(ai_vehicle_enterable_distance enc3_5_turret 10)
	
	; Wake the spawner
	(ai_place enc3_5_flood/sacrifices)
	(wake enc3_5_spawner)
	
	; Love!
	(ai_magically_see_encounter enc3_5_cov enc3_5_flood)
	(ai_magically_see_encounter enc3_5_flood enc3_5_cov)
	(ai_try_to_fight enc3_5_cov enc3_5_flood)
	(ai_try_to_fight enc3_5_flood enc3_5_cov)
	
	; Force activity
	(ai_link_activation enc3_5_cov enc3_5_flood)
	(ai_link_activation enc3_5_flood enc3_5_cov)
	
	; Second round!
	(sleep_until (volume_test_objects enc3_5c (players)))
	(ai_place enc3_5_flood/ambush_combats)
	
	; Third round!
	(sleep_until (volume_test_objects enc3_5b (players)))
	(ai_place enc3_5_flood/hole_infs)
)


; Encounter 3_4, triggered by Section3
(script dormant enc3_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_4 (players)))
	(certain_save) 
	
	; Debug
	(if debug (print "Encounter 3.4..."))
	
	; Wake next encounters, clean up if possible
	(wake enc3_5)
	(wake enc3_5_dialogue)
	(if (not coop)
		(begin
			(ai_erase enc3_0_flood)
			(ai_erase enc3_0_cov)
			(ai_erase enc3_1_flood)
			(ai_erase enc3_1_cov)
			(ai_erase enc3_2_flood)
			(ai_erase enc3_2_cov)
			(ai_erase enc3_3)
			(garbage_collect_now)
		)
	)
	
	; Place the covs, magical sight
	(ai_place enc3_4_cov)
	(ai_magically_see_encounter enc3_4_flood enc3_4_cov)

	; Start the spawner
	(wake enc3_4_spawner)

	; Sleep till the player drops down
	(sleep_until (volume_test_objects enc3_4b (players)) testing_fast)
	(set enc3_4_spawn_in_water false)

	; Sleep until covenant are nearly dead, then kill the spawner
	(sleep_until (<= (ai_living_count enc3_4_cov/elites) 1))
	(sleep -1 enc3_4_spawner)
)


; Encounter 3_3, triggered by Section3
(script dormant enc3_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_3 (players)))
	(certain_save) 
	
	; Kill previous spawner, encounters
	(sleep -1 enc3_2_spawner)
	
	; Wake next encounters
	(wake enc3_4)
	
	; Debug
	(if debug (print "Encounter 3.3..."))
	
	; Sleep till the trigger, move every zig
	(sleep_until (volume_test_objects enc3_3b (players)) testing_fast)
	(ai_place enc3_3/carriersB)
	(ai_place enc3_3/infsB)
	
	; Place the rifle
	(object_create enc3_3_rifle)
	
	; And again!
	(sleep_until (volume_test_objects enc3_3c (players)) testing_fast)
	(ai_place enc3_3/carriersC)
	(ai_place enc3_3/infsC)

	; Mark out the next waypoint, run dialogue
	(D20_140_Cortana)
)


; Dialog hooks for enc3_2
(script dormant enc3_2_dialogue
	; Wait till the player is looking at flood and cov fighting
	(sleep_until (objects_can_see_flag (players) enc3_2_dialogue_trigger 30))
	(sleep 60)
	(D20_150_Cortana)
)


; Encounter 3_2, triggered by Section3
(script dormant enc3_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_2 (players)))
	(certain_save)
	
	; Wake next encounters
;	(wake enc3_2_dialogue)
	(wake enc3_3)
	
	; Debug
	(if debug (print "Encounter 3.2..."))
	
	; Clean up
	(if (not coop) 
		(ai_erase enc3_0_flood)
	)
	
	; Migrate some units
	(ai_migrate enc3_0_cov enc3_2_cov/elites)
	
	; Place the covies and snipers
	(ai_place enc3_2_cov/grunts)
	(ai_place enc3_2_cov/elites)
	(ai_place enc3_2_flood/snipers)
	
	; Begin the spawner wave
	(wake enc3_2_spawner)
	
	; Be mean to hard levels
	(if (= "impossible" (game_difficulty_get))
		(begin
			(ai_try_to_fight_player enc3_2_cov)
			(ai_try_to_fight_player enc3_2_flood)
		)
	)

	; Sleep until we can send out the "F*** The Player" wave
	(sleep_until (volume_test_objects enc3_2b (players)))
	(ai_place enc3_2_flood/f_the_player)
	
	; End the spawner
	(sleep_until (<= (ai_nonswarm_count enc3_1_flood) 0))
	(sleep -1 enc3_2_spawner)
)


; Enc3_2 for intro cinematic
(script static void enc3_2_intro
	(ai_place enc3_2_cov/intro)
	(ai_place enc3_2_flood)
	(ai_playfight enc3_2_cov true)
	(ai_playfight enc3_2_flood true)
)


; Enc3_2 cleanup for intro cinematic
(script static void enc3_2_intro_cleanup
	(sleep -1 enc3_2_spawner)
	(ai_playfight enc3_2_cov false)
	(ai_playfight enc3_2_flood false)
	(ai_erase enc3_2_cov/intro)
	(ai_erase enc3_2_flood)
)


; Dialog hooks for Encounter 3_1
(script dormant enc3_1_dialogue
	(sleep 300)
	(D20_120_Cortana)
	(objective_exterior)
)


; Encounter 3_1, triggered by Section3
(script dormant enc3_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_1 (players)))
	(certain_save) 
	
	; Remove the waypoint
	(deactivate_team_nav_point_flag player waypoint1)
	
	; Wake next encounters
	(wake enc3_1_dialogue)
	(wake enc3_2)
	
	; Debug
	(if debug (print "Encounter 3.1..."))
)


; Enc3_1 for intro cinematic
(script static void enc3_1_intro
	(ai_place enc3_1_cov/elites1)	; In squad 1
	(ai_place enc3_1_flood/intro)
	(ai_playfight enc3_1_cov true)
	(ai_playfight enc3_1_flood true)
)


; Enc3_1 for intro cinematic cleanup
(script static void enc3_1_intro_cleanup
	(ai_playfight enc3_1_cov false)
	(ai_playfight enc3_1_flood false)
	(ai_erase enc3_1_cov)	; In squad 1
	(ai_erase enc3_1_flood)
)


; Encounter 3_0
(global boolean cortana_told_you_to_jump false)
(script dormant enc3_0
	; Debug
	(if debug (print "Encounter 3.0..."))
	
	; Guarantee cleanup
	(ai_erase enc3_1_cov)
	(ai_erase enc3_1_flood)

	; Place the covies
	(ai_place enc3_0_cov)
	
	; Place the flood
	(ai_place enc3_0_flood)
	
	; Reinforcements
	(sleep_until (<= (ai_nonswarm_count enc3_0_flood) 1))
	(ai_place enc3_0_flood/combats)
	
	; Additional reins for hard and impossible
	(if 
		(or
			(= "hard" (game_difficulty_get)) 
			(= "impossible" (game_difficulty_get))
		)
		(begin
			; Reinforcements
			(sleep_until (<= (ai_living_count enc3_0_flood/combats) 1))
			(ai_place enc3_0_flood/combats)		
		)
	)
)


; Section 3, Begin
(script dormant section3
	; Debug
	(if debug (print "Section 3..."))
	
	; MUZAK!
	(sound_looping_stop "levels\d20\music\d20_01")

	; Wakey
	(wake enc3_0)
	(wake i_am_skin_diver)
	(wake enc3_1)
	
	; Wait for section4, then clean up
	(sleep_until (volume_test_objects section4 (players)))
	(sleep -1 enc3_0)
)


;- Section 2 Encounters --------------------------------------------------------

; There is no Section 2. Joke's on you! 


;- Section 1 Encounters --------------------------------------------------------

;* 	Area:		Section 1
  	 Begins:		Start of level, inside covenant ship, near control room
  	   Ends:		At hole in shuttle bay floor, immediately prior to exterior area

  Synopsis:		- Player begins near control room
  					- Player sees some sillouhettes in the control room
  					- Player encounters a few infection forms in first hall
  					- Player sees a grunt fleeing from an armless combat form
  					- Player follows grunt and/or combat form around corner, where
  					  Grunts are being engaged by Flood (and killed)
  					- Player arrives at shuttle bay, is stopped by a large hole that
  					  shows exterior environment. Flood and Covies
  					  are fighting in shuttle bay
  					- Player is engaged by Flood coming pushing him towards the hole.

	 Issues:		- No plan for control room
	 				- No infection forms yet
	 				- Difficulty of Flood encounter near hole needs to be high enough
	 				  to make the player want to jump, but not enough to kill him
	 				  immediately

 Hierarchy:		-> MISSION START
 						-> section1 (immediate)
 							-> enc1_1 (trigger volume)
 								-> enc1_2 (trigger volume)
 									-> enc1_3 (immediate)
 										-> enc1_4 (trigger volume)
 											-> enc1_5 (trigger volume)
*;

; Enc 1_1 observation checker
(global boolean enc1_1_door1 false)
(global boolean enc1_1_door2 false)
(global boolean enc1_1_door3 false)
(global boolean enc1_1_door4 false)
(global boolean enc1_1_doors true)
(script continuous enc1_1_exploration
	(if 
		(and 
			(not enc1_1_door1) 
			(volume_test_objects enc1_1_door1_volume (players))
		)
		(set enc1_1_door1 true)
	)
	(if (and (not enc1_1_door2) (volume_test_objects enc1_1_door2_volume (players)))
		(set enc1_1_door2 true)
	)
	(if (and (not enc1_1_door3) (volume_test_objects enc1_1_door3_volume (players)))
		(set enc1_1_door3 true)
	)
	(if (and (not enc1_1_door4) (volume_test_objects enc1_1_door4_volume (players)))
		(set enc1_1_door4 true)
	)
	
	; Trigger dialog
	(if 
		(and
			enc1_1_doors
			enc1_1_door1
			enc1_1_door2
			enc1_1_door3
			enc1_1_door4
		)
		(begin
			(set enc1_1_doors false)
			(D20_20_Cortana)
		)
	)
	
	; End continuous
	(if (not enc1_1_doors)
		(sleep -1)
	)
)


; Encounter 1_5, triggered by Section 1
(script dormant enc1_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc1_5 (players)))
	(set enc1_1_doors false)
	(certain_save) 

	; Debug
	(if debug (print "Encounter 1.5..."))

	; MUZAK!
	(sleep_until (> (device_get_position enc1_5_door) .8) testing_fast)
;	(set music_01_base true)
	(D20_30_Cortana)
	
	; Fire up the spawner
	(sound_looping_set_alternate "levels\d20\music\d20_01" true)
	(wake enc1_5_spawner)
	(ai_magically_see_players enc1_5_flood)
	
	; Cortana dialog
	(sleep_until (> enc1_5_limiter 8) 30 600)
	(D20_71_Cortana)

	; Wait some more
	(sleep_until (> enc1_5_limiter 15))
	(D20_72_Cortana)
	(objective_jump)
	(set cortana_told_you_to_jump true)
	
	; Cortana dialog
	(sleep_until (> enc1_5_limiter 20))
	(D20_73_Cortana)

	; Wait some more
	(sleep_until (> enc1_5_limiter 26))
	(D20_90_Cortana)
)


; Encounter 1_4, triggered by Encounter 1_3
(script dormant enc1_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc1_4 (players)))
	
	; Debug
	(if debug (print "Encounter 1.4..."))
	
	; Wake next
	(wake enc1_5)
	
	; Place the covenant
	(ai_place enc1_4_cov)
	(ai_place enc1_4_flood)
	
	; Make them love each other
	(ai_playfight enc1_4_cov true)
	(ai_playfight enc1_4_flood true)
	(ai_try_to_fight enc1_4_cov enc1_4_flood)
	
	; Sleep until one side is dead
	(sleep_until 
		(or
			(<= (ai_living_count enc1_4_cov) 0)
			(<= (ai_living_count enc1_4_flood) 0)
		)
	)
	
	; Sleep until the player is in the trigger volume
	(sleep_until (volume_test_objects enc1_5 (players)))
	
	; Make the flood leap and the cov migrate
	(ai_command_list enc1_4_flood enc1_4_leap)
	(ai_maneuver enc1_4_cov/migrate)			
)


; Encounter 1_3, triggered by Encounter 1_2
(script dormant enc1_3
	; Debug
	(if debug (print "Encounter 1.3..."))
	(certain_save) 
	
	; Wake next
	(wake enc1_4)
	
	; Place the ai
	(ai_place enc1_3_cov)
	(ai_place enc1_3_flood)
	(ai_magically_see_players enc1_3_cov)
	(ai_magically_see_encounter enc1_3_flood enc1_3_cov)

	; Make them love each other
	(ai_try_to_fight enc1_3_cov enc1_3_flood)

	; Sleep until the grunts are dead, then show the flood the players
	(sleep_until (<= (ai_living_count enc1_3_cov) 0))
	(ai_magically_see_players enc1_3_flood)
)


; Encounter 1_2, triggered by Encounter 1_1
(script dormant enc1_2
	; Sleep until the trigger, testing fast
	(sleep_until (volume_test_objects enc1_2 (players)) testing_fast)
	
	; Debug
	(if debug (print "Encounter 1.2..."))
	
	; Wake next
	(wake enc1_3)
	
	; Erase old units
	(ai_erase enc1_1/control_room_infs)
		
	; Place the chasers, disarm (hee hee) the flood
	(ai_place enc1_2_cov)
	(ai_place enc1_2_flood)
	(object_set_permutation (list_get (ai_actors enc1_2_flood/chaser) 0) "" ~damaged)
	(object_set_melee_attack_inhibited (list_get (ai_actors enc1_2_flood/chaser) 0) true)
	
	; Move the units into the next encounter, and trigger it
	(ai_migrate enc1_2_cov/grunt enc1_3_cov/grunts)
	(ai_migrate enc1_2_flood/chaser enc1_3_flood/combats)
	
	; Sleep until the grunt is killed, and then terminate the combat form's list
	(sleep_until (<= 0 (ai_living_count enc1_2_cov/grunt)))
	(ai_command_list enc1_2_flood/chaser general_null)
	(ai_magically_see_players enc1_2_flood/chaser)
)


; Encounter 1_1, triggered by Section 1
(script dormant enc1_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc1_1 (players)))
	
	; Debug
	(if debug (print "Encounter 1.1..."))

	; Place the milling flood, tell some of them to attack, create the captain
	(ai_place enc1_1)
	(create_flood_captain)
	
	; Wake next
	(wake enc1_2)
	
	; Trigger dialogue
	(D20_flavor_010_CaptKeyes)
	(D20_flavor_020_Cortana)

	; Trigger music
	(sound_looping_start "levels\d20\music\d20_01" none 1)
)


; Section 1, Begin
(script dormant section1
	; Debug
	(if debug (print "Section 1..."))
	
	; Wake next
	(wake enc1_1)
	(wake enc1_1_exploration)
	
	; Wait for the player to drop into the hole, then run the cinematic
	(sleep_until (volume_test_objects 0_to_1_transition_trigger (players)) testing_fast)
	
	; Kill some scripts and sounds first
	(sleep -1 enc1_5)
	(sleep -1 enc1_1_exploration)
	(sound_impulse_stop sound\dialog\d20\D20_030_Cortana)
	(sound_impulse_stop sound\dialog\d20\D20_050_Cortana)
	(sound_impulse_stop sound\dialog\d20\D20_070_Cortana)
	(sound_impulse_stop sound\dialog\d20\D20_090_Cortana)
	
	; Kill units!
	(ai_erase enc1_5_cov)
	(ai_erase enc1_5_flood)
	(ai_erase enc1_4_flood)
	(ai_erase enc1_4_cov)
	(ai_erase enc1_3_flood)
	(ai_erase enc1_3_cov)
	(ai_erase enc1_2_flood)
	(ai_erase enc1_2_cov)
	(ai_erase enc1_1)
	
	; Erase some objects
	(object_destroy_containing "0_")		; SLAYS bipeds placed on BSP 0
		
	; Garbage collect
	(garbage_collect_now)
	
	; Wake sec 3 and the cinematic
	(wake section3)	
	(sleep 30)

   (if (mcc_mission_segment "cine2_into_coolant") (sleep 1))
     
	(cinematic_drop)
	(game_save_totally_unsafe)
)


;- Cheats ----------------------------------------------------------------------

;(script static void test
(script static void s3
	(switch_bsp 1)
	(volume_teleport_players_not_inside null_volume tp_sec3)
)

(script static void s4
	(switch_bsp 2)
	(volume_teleport_players_not_inside null_volume tp_sec4)
)

(script static void s5
	(switch_bsp 3)
	(volume_teleport_players_not_inside null_volume tp_sec5)
)

(script static void s6
	(switch_bsp 4)
	(volume_teleport_players_not_inside null_volume tp_sec6)
)

(script static void s7
	(switch_bsp 4)
	(volume_teleport_players_not_inside null_volume tp_sec6)
	(wake section7)
)


;- Vehicles --------------------------------------------------------------------

; Record
(script static void RECORD
	(print "recording")
	(recording_kill (unit ending_banshee1))

	; Create 'em
	(object_create ending_banshee2)
	(object_destroy ending_banshee2)
	(object_create ending_banshee2)

	; Port 'em
	(object_teleport ending_banshee2 ending_banshee2)


;	(object_destroy ending_banshee1)
;	(object_create ending_banshee1)
;	(object_teleport ending_banshee1 ending_banshee1)
;	(recording_play (unit ending_banshee1) ending_banshee1_v5)
	
)


;

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


;- Texture Preloading ----------------------------------------------------------

(script static void preload_textures
	; I zee in your future...
	(object_type_predict "weapons\needler\needler")
	(object_type_predict "characters\elite\elite")
	(object_type_predict "characters\grunt\grunt")
	(object_type_predict "characters\floodcarrier\floodcarrier")
	(object_type_predict "characters\floodcombat elite\floodcombat elite")
	(object_type_predict "characters\floodcombat_human\floodcombat_human")
)


;- Cutscene Side Threads -------------------------------------------------------

; Intro
(script dormant intro_cutscene_aux
	(sleep 60)
	(enc3_1_intro)
	(sleep 30)
	(chapter_d20_1)
	(sleep 240)
	(enc3_2_intro)
)


;- Clean Up Scripts ------------------------------------------------------------

(script static void stun_managers
	; Shut off the 5_1 manager
	(sleep -1 enc5_1_manager)

	; Shut off the managers
	(sleep -1 enc1_1_exploration)
	(sleep -1 enc3_8_lift_manager)
	(sleep -1 enc6_1_manager)
	(sleep -1 enc6_2_manager)
	(sleep -1 enc6_5_manager)
	(sleep -1 enc7_6_manager)
	
	; Shut off the banshee check right away
	(sleep -1 banshee_safety_net)
)


;- Main ------------------------------------------------------------------------

(global boolean cinematic_ran false)
(script startup mission
	; Fade to black
	(fade_out 0 0 0 0)
	
	; Initialize scripts and preload textures
	(if debug (print "Initializing..."))
	(stun_managers)
	(stun_spawn_waves)
	(preload_textures)

	; Adjustments for coop and difficulty
	(coop_control)
	(diff_control)

   (if (mcc_mission_segment "cine1_intro") (sleep 1))
	; Start music
;	JLG
;	(sound_looping_start "levels\d20\music\d20_01" none 1)
;	/JLG
	; Run opening cinematics
	(if (cinematic_skip_start) 
		(begin
			(set cinematic_ran true)
			(wake intro_cutscene_aux)
			(cinematic_intro)
		)
	)
	(cinematic_skip_stop)
	
	; Fade in if the cinematic hasn't done it already
	(if (not cinematic_ran)
		(fade_in 0 0 0 0)
	)
	; Clean up
	(enc3_2_intro_cleanup)
	(enc3_1_intro_cleanup)
	(garbage_collect_now)		

	; Wake section tests
	(wake save_checkpoints)
	(wake section1)
	(wake section4)	
	(wake section5)	
	(wake section6)
	
   (mcc_mission_segment "01_start")
	; Objective
	(objective_start)
)



