; =================================================================================================
; AMBIENT SOUNDS

(global looping_sound 	snd_city_ambient 			sound\levels\040_voi\old_mombasa_quiet\old_mombasa_quiet)
(global looping_sound	snd_floodship_creaks		sound\levels\050_floodvoi\sound_scenery\crashed_floodship_hole\crashed_floodship_hole)

(global sound 		snd_vehicle_destroyed 		sound\visual_fx\ambient_vehicle_destroyed)
(global sound 		snd_vehicle_destroyed_lrg 	sound\visual_fx\ambient_vehicle_destroyed_large)
(global sound			snd_creak					sound\levels\120_halo\trench_run\island_creak)
(global sound			snd_elite_fleet				sound\levels\050_floodvoi\050pb_elite_fleet)
(global sound			snd_longsword_leadin		sound\levels\070_waste\070_longsword_crash\longsword_lead_in)
(global sound			snd_longsword_crash			sound\levels\070_waste\070_longsword_crash\070_longsword)
(global sound			snd_longsword_flyby			sound\device_machines\040vc_longsword\start)
(global sound			snd_cap_ship_flyover		sound\levels\030_outskirts\sound_scenery\cap_ship_flyover)
(global sound			snd_pelican1_start			sound\levels\010_jungle\010vd_pelican_crash\pelican1_crash)
(global sound			snd_pelican1_crash			sound\levels\010_jungle\010vd_pelican_crash\pelican1_crash)
(global sound			snd_pelican2_start			sound\levels\010_jungle\010vd_pelican_crash\pelican2_start)
(global sound			snd_pelican2_crash			sound\levels\010_jungle\010vd_pelican_crash\pelican2_crash)
(global sound 		snd_tower_fall				sound\levels\120_halo\trench_run\tower_fall)



; =================================================================================================
; HUD SOUNDS
;*
(global looping_sound	snd_jitter					sound\device_machines\jittery_holo\jittery_holo)
(global looping_sound	snd_error					sound\device_machines\terminals\error_loop\error_loop)
(global looping_sound	snd_alarm					sound\game_sfx\ui\shield_low_dervish\shield_low_dervish)
(global sound			snd_hud_success				sound\game_sfx\fireteam\issue_directive)
(global	looping_sound	snd_hud_fail				sound\game_sfx\ui\shield_low_dervish\shield_low_dervish)
(global sound			snd_hud_reboot_tick			sound\game_sfx\ui\pda_transition)
*;
; -------------------------------------------------------------------------------------------------
; MUSIC
;sound_looping_activate_layer <looping_sound> <long> (1 for layer 1)
;sound_looping_deactivate_layer <looping_sound> <long>
; -------------------------------------------------------------------------------------------------
(global looping_sound mus_01 levels\solo\m50\music\m50_music_01.sound_looping)
(global looping_sound mus_02 levels\solo\m50\music\m50_music_02.sound_looping)
(global looping_sound mus_03 levels\solo\m50\music\m50_music_03.sound_looping)
(global looping_sound mus_04 levels\solo\m50\music\m50_music_04.sound_looping)
(global looping_sound mus_05 levels\solo\m50\music\m50_music_05.sound_looping)
(global looping_sound mus_06 levels\solo\m50\music\m50_music_06.sound_looping)
(global looping_sound mus_07 levels\solo\m50\music\m50_music_07.sound_looping)
(global looping_sound mus_08 levels\solo\m50\music\m50_music_08.sound_looping)
(global looping_sound mus_09 levels\solo\m50\music\m50_music_09.sound_looping)
(global looping_sound mus_10 levels\solo\m50\music\m50_music_10.sound_looping)
	
; =================================================================================================
; CINEMATICS
;*
(script static void cin_intro
	(cinematic_snap_to_black)
	(050la_wake)
	(cinematic_fade_to_gameplay)
)
*;
(script static void cin_outro
	(f_end_mission 050lb_reunited cin_outro_reunited)
)

;*
(script static void cin_canyonview
	(cinematic_snap_to_white)
	(camera_set_field_of_view 80 0)
	(sleep 1)
	(fade_in 1 1 1 15)
	(camera_set canyon00_start 0)
	(sleep 10)
	(camera_set canyon07_sky 90)
	(sleep 10)
	(camera_set canyon00_start 90)
	(sleep 15)
	(camera_set canyon07_sky 90)
	(sleep 10)
	(camera_set canyon00_start 120)
	(sleep 20)
	(camera_set canyon07_sky 90)
	(sleep 10)
	(camera_set canyon00_start 90)
	(sleep 19)
	(camera_set canyon07_sky 90)
	(sleep 10)
	(camera_set canyon00_start 90)
	(sleep 29)
	(camera_set canyon07_sky 90)
	(sleep 10)
	(camera_set canyon00_start 90)
	(sleep 19)
	
	; look down canyon
	(camera_set canyon01_canyon 30)
	(sleep 30)
	
	; look at civilians
	(camera_set canyon05_civilians 60)
	(sleep 60)
	
	; look at corvette
	(camera_set canyon03a_corvette 50)
	(sleep 1)
	(camera_set_field_of_view 50 50)
	(sleep 35)
	(camera_set canyon03a_corvette 60)
	(sleep 20)
	(camera_set canyon03b_corvette 90)
	(sleep 10)
	(camera_set canyon03c_corvette 50)
	(sleep 15)
	(camera_set canyon03a_corvette 60)
	(sleep 20)
	(camera_set canyon03b_corvette 90)
	(sleep 10)
	(camera_set canyon03c_corvette 50)
	(sleep 40)
	
	; look at traxus
	(camera_set canyon04a_traxus 90)
	(sleep 15)
	(camera_set_field_of_view 40 60)
	(sleep 10)
	(camera_set canyon04a_traxus 60)
	(sleep 10)
	(camera_set canyon04b_traxus 60)
	(sleep 20)
	(camera_set canyon04c_traxus 90)
	(sleep 10)
	(camera_set canyon04a_traxus 50)
	(sleep 20)
	(camera_set canyon04b_traxus 60)
	(sleep 20)
	(camera_set canyon04c_traxus 50)
	(sleep 20)
	(camera_set canyon04a_traxus 90)
	(sleep 10)
	(camera_set canyon04b_traxus 50)
	(sleep 20)
	(camera_set canyon04c_traxus 40)
	(sleep 10)
	
	; look at sky
	(camera_set canyon07_sky 60)
	(sleep 1)
	(camera_set_field_of_view 80 60)
	(sleep 30)
	
	; look at troopers
	(camera_set canyon06a_troopers 60)
	(sleep 1)
	(camera_set_field_of_view 30 60)
	(sleep 50)
	(camera_set canyon06b_troopers 90)
	(sleep 10)
	(camera_set canyon06a_troopers 90)
	(sleep 20)
	(camera_set canyon06a_troopers 90)
	(sleep 10)
	(camera_set canyon06b_troopers 90)
	(sleep 30)
	(camera_set canyon06a_troopers 90)
	(sleep 10)
	(camera_set canyon06a_troopers 90)
	(sleep 20)
	
	(camera_set canyon00_start 60)
	(camera_set_field_of_view 80 60)
	(sleep 30)
	(fade_out 1 1 1 30)
	(sleep 30)	
	(sleep 1)
	(object_teleport (player0) canyonview_cinematic_teleport)
	(cinematic_fade_to_gameplay)
)
*;

;*
(script dormant cin_outro_turret0
	(sleep 90)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret0_hardpoints 0 0)
	(sleep 5)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret0_hardpoints 0 0)
	(sleep 5)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret0_hardpoints 0 0)
	(sleep 5)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret0_hardpoints 0 0)
	(sleep 5)
)

(script dormant cin_outro_turret1
	(sleep 240)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret1_hardpoints 0 0)
	(sleep 5)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret1_hardpoints 0 0)
	(sleep 5)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret1_hardpoints 0 0)
	(sleep 5)
	(effect_new_random "fx\fx_library\designer_fx\rocket.effect" starport_turret1_hardpoints 0 0)
	(sleep 5)
)
*;
; =================================================================================================
; M50 CHAPTER TITLES
;(f_hud_obj_repeat <string_hud>)
; =================================================================================================

(script dormant ct_title_act1
	(sleep (* 30 2))
                ;(cinematic_set_title ct_act1)
                (f_hud_chapter ct_act1)
)

(script dormant ct_title_act2
	(sleep_until (>= objcon_ready 40))
                ;(cinematic_set_title ct_act2)
                (f_hud_chapter ct_act2)
 )

(script dormant ct_title_act3
	;*
	(sleep_until (or b_ride_falcon_landed b_ride_falcon0_landed))	
  *;            
	(sleep_until 
		(or
			(player_in_vehicle (ai_vehicle_get ride_falcon/pilot))
			(player_in_vehicle (ai_vehicle_get ride_falcon0/pilot))
		)
	5)
	(sleep (* 30 5))
	;(cinematic_set_title ct_act3)
	(f_hud_chapter ct_act3)
)

;*
(script dormant ct_title_act1
	(f_hud_obj_repeat "ct_act1");"An Orchard of Graves"
)

(script dormant ct_title_act2
	(sleep_until (>= objcon_ready 40))
	(f_hud_obj_repeat "ct_act2");"Hold on to Your Helmets"
)

(script dormant ct_title_act3
	(sleep_until (or b_ride_falcon_landed b_ride_falcon0_landed))	
	(f_hud_obj_repeat "ct_act3");"I Should Have Become a Watchmaker"
)
*;

; =================================================================================================
; M50 OBJECTIVES
; (f_hud_obj_new (string_id string_hud) (string_id string_start))
; (f_hud_obj_new "" "")
; =================================================================================================
(global short objective_flash_time 15)
(global short objective_delay (* 30 2))

(script dormant ct_objective_link_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_link_up" "PRIMARY_OBJECTIVE_1");"LINK UP WITH UNSC FORCES"
)

(script dormant ct_objective_link_complete
	(sleep objective_delay)
	;(f_hud_obj_new "ct_objective_link_up" "ct_objective_complete")
	;(f_hud_start_menu_obj "ct_objective_complete")
	(f_hud_start_menu_obj "PRIMARY_OBJECTIVE_1")
)

(script dormant ct_objective_traxus_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_traxus" "PRIMARY_OBJECTIVE_2");"EVACUATE CIVILIANS FROM TRAXUS TOWER"
	;(wake hud_flash_tower)
)

(script dormant ct_objective_elevator_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_advance_atrium" "PRIMARY_OBJECTIVE_3");"ADVANCE TO ATRIUM ELEVATOR"
)	

(script dormant ct_objective_defend_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_defend_atrium" "PRIMARY_OBJECTIVE_4");"DEFEND POSITION"
)	

(script dormant ct_objective_defend_complete
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_activate_elevator" "PRIMARY_OBJECTIVE_5");"TAKE ELEVATOR DOWN TO CARGO PORT"
)	

(script dormant ct_objective_elevator_complete
	(sleep objective_delay)
	;(f_hud_start_menu_obj "ct_objective_complete")
	(f_hud_start_menu_obj "PRIMARY_OBJECTIVE_2")	
)
	
(script dormant ct_objective_jetpack_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_jetpack" "PRIMARY_OBJECTIVE_6");"ACQUIRE JETPACK EQUIPMENT"
)

(script dormant ct_objective_cargo_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_cargo" "PRIMARY_OBJECTIVE_7");"TRAVERSE CARGO PORT"
)
;*
(script dormant ct_training_ui_jetpack
	(f_hud_training_confirm player0 ct_training_jetpack "equipment")
	(f_hud_training_confirm player1 ct_training_jetpack "equipment")
	(f_hud_training_confirm player2 ct_training_jetpack "equipment")
	(f_hud_training_confirm player3 ct_training_jetpack "equipment")
)
*;

(script dormant ct_training_ui_jetpack3
	(sleep_until (unit_has_equipment (player3) objects\equipment\jet_pack\jet_pack.equipment))
	(f_hud_training_confirm player3 ct_training_jetpack "equipment")				
)

(script dormant ct_training_ui_jetpack2
	(sleep_until (unit_has_equipment (player2) objects\equipment\jet_pack\jet_pack.equipment))
	(f_hud_training_confirm player2 ct_training_jetpack "equipment")
)

(script dormant ct_training_ui_jetpack1
	(sleep_until (unit_has_equipment (player1) objects\equipment\jet_pack\jet_pack.equipment))
	(f_hud_training_confirm player1 ct_training_jetpack "equipment")
)

(script dormant ct_training_ui_jetpack0
	(sleep_until (unit_has_equipment (player0) objects\equipment\jet_pack\jet_pack.equipment))
	(f_hud_training_confirm player0 ct_training_jetpack "equipment")
)

(script dormant ct_objective_tower_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_advance_traxus" "PRIMARY_OBJECTIVE_8");"ADVANCE TO TRAXUS TOWER"
	
	;(wake hud_flash_evac)
)

(script dormant ct_objective_capture_pad
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_landing_pad" "PRIMARY_OBJECTIVE_9");"SECURE LANDING PAD"
	;(sleep_forever hud_flash_evac)
)

(script dormant ct_objective_capture_pad_complete
	(sleep objective_delay)
	;(f_hud_start_menu_obj "ct_objective_complete")	
	(f_hud_obj_complete)
)

(script dormant ct_objective_traxus_complete
	(sleep objective_delay)
	;(f_hud_start_menu_obj "ct_objective_complete")
	(f_hud_obj_complete)
)

(script dormant ct_objective_transport_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_transports" "PRIMARY_OBJECTIVE_10");"EVACUATE CIVILIAN TRANSPORTS"
)

(script dormant ct_objective_missiles_start
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_arm_missiles" "PRIMARY_OBJECTIVE_11");"ARM MISSILE BATTERIES"
)

(script dormant ct_objective_arm_complete
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_fire_missiles" "PRIMARY_OBJECTIVE_12");"FIRE MISSILES FROM COMMAND CONSOLE"
)

(script dormant ct_objective_missiles_complete
	(sleep objective_delay)
	(mus_stop mus_08)
	;(f_hud_start_menu_obj "ct_objective_complete")
	(f_hud_obj_complete)
)

(script dormant hud_flash_tower
	;(sleep_until
		;(begin		
 			;sleep until player can see the object within an FOV of 20
 			(f_blip_object highlight_tower_box blip_destination)
 			(sleep_until (objects_can_see_object player0 highlight_tower_box 10) 5 (* 30 15))
 			(f_hud_flash_object sc_ui_highlight_tower)
 			(f_unblip_object highlight_tower_box)
 			;(sleep (* 30 5))
 		;FALSE)
	;)
)

(script dormant hud_flash_evac
	;(sleep_until
		;(begin		
 			;sleep until player can see the object within an FOV of 20
 			(f_blip_object highlight_evac_box blip_destination)
 			(sleep_until (objects_can_see_object player0 highlight_evac_box 10) 5 (* 30 30))
 			(f_hud_flash_object sc_ui_highlight_evac)
 			(f_unblip_object highlight_evac_box)
 			;(sleep (* 30 5))
 		;FALSE)
	;)
)

(script dormant hud_flash_evac0
	;(sleep_until
		;(begin		
 			;sleep until player can see the object within an FOV of 20
 			(f_blip_object highlight_evac0_box blip_destination)
 			(sleep_until (objects_can_see_object player0 highlight_evac0_box 10) 5 (* 30 30))
 			(f_hud_flash_object sc_ui_highlight_evac)
 			(f_unblip_object highlight_evac0_box)
 			;(sleep (* 30 5))
 		;FALSE)
	;)
)

; -------------------------------------------------------------------------------------------------
; MISSION DIALOGUE: MAIN SCRIPTS


(global boolean b_md_is_playing false)

(script static void (md_play_debug (short delay) (string line))
	(if dialogue (print line))
	(sleep delay))

(script static void (md_print (string line))
	(if dialogue (print line)))

;*
(global sound snd_transmission "sound\game_sfx\ui\pda_transition")
(script static void play_transmission_sound 
	(sound_impulse_start snd_transmission NONE 1)
	(sleep (sound_impulse_language_time snd_transmission)))
*;

(script static void md_prep
	(sleep_until (not b_md_is_playing) 1)
	;(sleep_until (not b_is_dialogue_playing) 1)
	(set b_md_is_playing true)
	;(set b_is_dialogue_playing true)
)

(script static void md_finished
	(set b_md_is_playing false))


; -------------------------------------------------------------------------------------------------
; DIALOGUE: AMBIENT
; -------------------------------------------------------------------------------------------------

;* VISOR REPAIR
;When the player encounters tech specialists who can repair Six's visor (these are one-offs):
(script dormant md_visor_repair01
	(md_print "I can repair that visor for you, Lieutenant.")
	(f_md_ai_play 0 ai m50_0350)

	(md_print "All done, Lieutenant  Good hunting.")
	(f_md_ai_play 0 ai m50_0380)
)

(script dormant md_visor_repair02
	(md_print "Trouble with your visor, Spartan?  I can take care of that for you.")
	(f_md_ai_play 0 ai m50_0360)

	(md_print "That should do it.  Give 'em hell, Spartan.")
	(f_md_ai_play 0 ai m50_0390)
)

(script dormant md_visor_repair03
	(md_print "Want me to do a quick fix on that visor, Spartan?")
	(f_md_ai_play 0 ai m50_0370)

	(md_print "Good as new, Lieutenant.  Go get 'em.")
	(f_md_ai_play 0 ai m50_0400)
)*;

; -------------------------------------------------------------------------------------------------
; CASTING
; -------------------------------------------------------------------------------------------------
(global ai trooper_01 NONE)
(global ai trooper_02 NONE)
(global ai trooper_03 NONE)
(global ai trooper_04 NONE)

(global ai civilian_01 NONE)
(global ai civilian_02 NONE)
(global ai civilian_03 NONE)
(global ai civilian_04 NONE)

(global ai odst_01 NONE)
(global ai odst_02 NONE)
(global ai odst_03 NONE)
(global ai odst_04 NONE)

(global ai duval NONE)

; -------------------------------------------------------------------------------------------------

(global ai air_control NONE)
(global ai trooper_sgt1 NONE)
(global ai trooper_sgt2 NONE)

(global ai trooper1 NONE)
(global ai trooper2 NONE)
(global ai trooper3 NONE)
(global ai trooper4 NONE)
(global ai trooper5 NONE)

(global ai trooper3_odst1 NONE)
(global ai trooper5_odst2 NONE)

(global ai female_trooper1 NONE)

(global ai civilian1 NONE)
(global ai f_civilian1 NONE)

(global ai atrium_a.i. NONE)

(global ai pilot1 NONE)
(global ai pilot2 NONE)
(global ai female_pilot NONE)

(global ai stalwart_dawn_actual NONE)
(global ai civilian_transport_pilot1 NONE)
(global ai civilian_transport_pilot2 NONE)


; -------------------------------------------------------------------------------------------------
; DIALOGUE: PANOPTICAL
; -------------------------------------------------------------------------------------------------
(script dormant md_amb_traxus01
	(md_prep)
	(sleep (random_range (* 30 2) (* 30 3)))

	; Immediately after gameplay resumes: AMBIENT RADIO BATTLE CHATTER TBD.  (And should be sprinkled throughout this first part of the mission.)
	; When player first reaches the main plaza level (the one with the door to the next area):
	(md_print "This is Kilo Dispatch.  All available teams advance to Traxus Tower.  Evacuation will commence A-sap.")
	(f_md_object_play 0 NONE m50_0010)

	(md_print "Copy, Dispatch.  What's the status of the tower pad?")
	(f_md_object_play 30 NONE m50_0020)

	(md_print "Tower pad is green.  Let's move these civilians before it changes.")
	(f_md_object_play 30 NONE m50_0030)

	(md_print "Solid copy, Dispatch.  Four Zero out.")
	(f_md_object_play 30 NONE m50_0040)
	
	(md_finished)
	
	(wake hud_flash_tower)
	(wake ct_objective_link_start)
)

; -------------------------------------------------------------------------------------------------
; DIALOGUE: TOWERS
; -------------------------------------------------------------------------------------------------
(script dormant md_amb_bombers
	(sleep_until (volume_test_players tv_md_bombers) 1)
	
	(md_prep)
	;When player emerges into second plaza (facing west toward stairs/waterfall):
	(md_print "Romeo Company, be advised we have reports of Covenant suicide squads.")
	(f_md_object_play 0 NONE m50_0050)

	(md_print "You gotta be kiddin' me...")
	(f_md_object_play 30 NONE m50_0060)
	
	(md_print "Negative.  Keep your eyes open, troopers.")
	(f_md_object_play 30 NONE m50_0070)
	(md_finished)
	
	(mus_stop mus_01)
)	

; -------------------------------------------------------------------------------------------------
; DIALOGUE: INTERIOR
; -------------------------------------------------------------------------------------------------
(script dormant md_amb_cruiser01
;*
	(sleep_until (or
		(volume_test_players tv_md_cruiser_start)
		(f_ai_is_defeated cov.towers.skirmishers) 1))
*;
	(sleep_until (volume_test_players tv_md_cruiser_start))
		
		
	(md_prep)
	; IMMEDIATELY PRECEDING the first big bombardment repercussion:
	(md_print "Kilo Two Six, this is Kilo Four Zero.  Covenant Corvette's raining hell on us.  Final Protective Fire One, danger close, my command, over.")
	(f_md_object_play 0 NONE m50_0080)

	(md_print "Copy, Kilo Four Zero.  Firing FPF One at your command.")
	(f_md_object_play 30 NONE m50_0090)
	(md_finished)

	;(sleep_until (volume_test_players tv_md_cruiser_shot01) 1)
	;(sleep_until (>= objcon_interior 30))
	(sleep_until (volume_test_players tv_md_cruiser_shot01)1)
	(md_prep)
	
	(md_print "Fire FPF One, over.")
	(f_md_object_play 0 NONE m50_0100)

	(md_print "Firing FPF One... Shot...")
	(f_md_object_play 30 NONE m50_0110)

	(md_print "Hold onto your helmets --")
	(f_md_object_play 30 NONE m50_0120)
	(md_finished)
	
	; shot!
	(snd_play sound\weapons\mac_gun\mac_gun_m50\mac_gun_m50.sound)
	;(snd_play sound\weapons\covy_gun_tower\c_gun_tower_fire_surr.sound)
	(sleep 66)
	(snd_play sound\levels\120_halo\trench_run\island_creak.sound)
	(cam_shake 0.2 1 3)
	(interpolator_start base_bombing)

		(cs_run_command_script cov.interior.grunts.1 cs_wakeup)
		(cs_run_command_script cov.interior.grunts.2 cs_wakeup)
		(cs_run_command_script cov.interior.grunts.3a cs_wakeup)
		(cs_run_command_script cov.interior.grunts.3b cs_wakeup)
		(cs_run_command_script cov.interior.grunts.3c cs_wakeup)
		(cs_run_command_script cov.interior.grunts.4a cs_wakeup)
		(cs_run_command_script cov.interior.grunts.4b cs_wakeup)
		(cs_run_command_script cov.interior.grunts.4c cs_wakeup)
		(cs_run_command_script cov.interior.grunts.5a cs_wakeup)
		(cs_run_command_script cov.interior.grunts.5b cs_wakeup)
		(cs_run_command_script cov.interior.grunts.5c cs_wakeup)	

	(sleep_until (volume_test_players tv_md_cruiser_shot02) 1)
	;(sleep_until (>= objcon_interior 40))
	
	(md_prep)
	; IMMEDIATELY PRECEDING the second boom:
	(md_print "Kilo Four Zero, request FPF sitrep!")
	(f_md_object_play 0 NONE m50_0130)

	(md_print "Negative, Two Six -- Corvette's still coming!")
	(f_md_object_play 30 NONE m50_0140)

	(md_print "Copy, Four Zero, Firing FPF Two... Shot…")
	(f_md_object_play 30 NONE m50_0150)
	(md_finished)
	
	; shot!
	(snd_play sound\weapons\mac_gun\mac_gun_m50\mac_gun_m50.sound)
	;(snd_play sound\weapons\covy_gun_tower\c_gun_tower_fire_surr.sound)
	(sleep 66)
	(snd_play sound\levels\120_halo\trench_run\island_creak.sound)
	(cam_shake 0.2 1 3)
	(interpolator_start base_bombing)

		(cs_run_command_script cov.interior.grunts.1 cs_wakeup)
		(cs_run_command_script cov.interior.grunts.2 cs_wakeup)
		(cs_run_command_script cov.interior.grunts.3a cs_wakeup)
		(cs_run_command_script cov.interior.grunts.3b cs_wakeup)
		(cs_run_command_script cov.interior.grunts.3c cs_wakeup)
		(cs_run_command_script cov.interior.grunts.4a cs_wakeup)
		(cs_run_command_script cov.interior.grunts.4b cs_wakeup)
		(cs_run_command_script cov.interior.grunts.4c cs_wakeup)
		(cs_run_command_script cov.interior.grunts.5a cs_wakeup)
		(cs_run_command_script cov.interior.grunts.5b cs_wakeup)
		(cs_run_command_script cov.interior.grunts.5c cs_wakeup)		
				
	(sleep (random_range 150 210))
	(md_prep)
	; IMMEDIATELY FOLLOWING the second boom:
	(md_print "Damn it, how do you stop that thing...?")
	(f_md_object_play 0 NONE m50_0160)
	(md_finished)
)

; -------------------------------------------------------------------------------------------------
; DIALOGUE: CANYONVIEW
; -------------------------------------------------------------------------------------------------
(script dormant md_canyonview_civilian_intro
	
	(vs_cast cv_civilians_near0 FALSE 10 "m50_0170" "m50_0180")
	(set civilian1 (vs_role 1));civilian1
  (set f_civilian1 (vs_role 2));f_civilian1

	(vs_cast cv_unsc_echo_inf0 FALSE 10 "m50_0190")
	(set trooper4 (vs_role 1));trooper4
	
	(md_prep)
	; When the door opens and the player sees the frightened civilians and one trooper in front of it on the landing:
	(md_print "Help!  Somebody help us!");civilian1
	(f_md_ai_play 0 civilian1 m50_0170)
	;(f_md_object_play 0 NONE m50_0170)

	(md_print "They're coming!  They're after us!");f_civilian1
	(f_md_ai_play 30 f_civilian1 m50_0180)
	;(f_md_object_play 0 NONE m50_0180)
	
	(md_print "Come on, let’s go!");trooper4
	(f_md_ai_play 30 trooper4 m50_0190)
	;(f_md_object_play 0 NONE m50_0190)

	(md_print "What ARE those things?!?");civilian1
	(f_md_ai_play 30 civilian1 m50_0200)
	;(f_md_object_play 0 NONE m50_0200)

	(md_print "Brutes! Move to cover!");trooper4
	(f_md_ai_play 30 trooper4 m50_0210)
	;(f_md_object_play 0 NONE m50_0210)	
	(md_finished)
)

(script dormant md_canyonview_marine_intro
	;(sleep_until (>= objcon_canyonview 10))
	
	(vs_cast cv_unsc_echo_inf1 FALSE 10 "m50_0220")
	(set trooper1 (vs_role 1));trooper1
	
	(md_prep)
	; After the first, closest group of Covenant are killed (BEFORE the player actually sees the troopers):
	(md_print "Evac Team Seven to Kilo Two Six.  We have eyes on Traxus Tower.");trooper1
	(f_md_ai_play 0 trooper1 m50_0220)
	;(f_md_object_play 0 NONE m50_0220)

	(md_print "Copy, Evac Seven.  Move to assist the evac, over.");air_control
	(f_md_object_play 30 NONE m50_0230)
	(md_finished)
	(wake ct_objective_traxus_start)
	
)

(script dormant md_cv_trooper_intro
                                                
	(sleep_until (or
		(cv_player_near_troopers)
		(>= objcon_canyonview 40)))
	
	(vs_cast cv_unsc_echo_inf0 FALSE 10 "m50_0270")
	(set female_trooper1 (vs_role 1));female_trooper1
	
	(md_prep)
	; When the player gets close to the troopers:
	(md_print "Picked up a Friendly!");trooper1	
	(if (>= (ai_living_count trooper1) 1)
		(f_md_ai_play 0 trooper1 m50_0250)
		(f_md_object_play 0 NONE m50_0250))
	
	(if (player_has_female_voice player0)
		(begin
			(md_print "A Spartan?  Where the hell'd SHE come from?");female_trooper1
			(if (>= (ai_living_count female_trooper1) 1)
				(f_md_ai_play 0 female_trooper1 m50_0270)
				(f_md_object_play 30 NONE m50_0270))
		)

		(begin
			(md_print "A Spartan?  Where the hell'd HE come from?");female_trooper1
			(if (>= (ai_living_count female_trooper1) 1)
				(f_md_ai_play 0 female_trooper1 m50_0260)
				(f_md_object_play 0 NONE m50_0260))
		)
	)
	
	(md_print "Who cares? Spartan, assist!");trooper1
	(if (>= (ai_living_count trooper1) 1)
		(f_md_ai_play 0 trooper1 m50_0280)
		(f_md_object_play 0 NONE m50_0280))
		
	(md_finished)
	; migrate these guys to the player's fireteam
	;(ai_migrate cv_unsc_echo_inf0 fireteam_player0)
	;(ai_set_objective fireteam_player0 obj_canyonview_unsc);fireteam player 0
	(if (not (game_is_cooperative))
		(begin
			(ai_player_add_fireteam_squad player0 cv_unsc_echo_inf0)
			(ai_player_add_fireteam_squad player0 cv_unsc_echo_inf1)))
			
	(wake ct_objective_link_complete)
	(wake md_canyonview_marine_intro)
	(wake md_cv_how_to)
)

(script dormant md_cv_how_to	
	(sleep_until (or
		(<= (ai_task_count obj_canyonview_cov/gate_main) 0)
		(= b_cv_counter_started true)))
	
	(sleep (* 30 2))
	(md_prep)			
	; When the third group emerges from the west door:
	(md_print "How do we get to the tower?");female_trooper1
	(if (>= (ai_living_count female_trooper1) 1)
		(f_md_ai_play 0 female_trooper1 m50_0290)
		(f_md_object_play 0 NONE m50_0290))
	
	(md_print "Elevator in the atrium goes down to the cargo port; cargo port goes to the tower!");trooper1
	(if (>= (ai_living_count trooper1) 1)
		(f_md_ai_play 30 trooper1 m50_0300)
		(f_md_object_play 30 NONE m50_0300))
	
	
	
	; alternate
	;(md_print "Elevator in the atrium goes down to the cargo port; cargo port goes to the tower!");trooper4
	;(f_md_ai_play 0 cv_unsc_echo_inf1 m50_0310)

	;* alternate
	(vs_cast cv_unsc_echo_inf1 FALSE 10 "m50_0290" "m50_0320")
	(set trooper3 (vs_role 1))
	(md_print "Elevator in the atrium goes down to the cargo port; cargo port goes to the tower!");trooper3
	(f_md_ai_play 0 cv_unsc_echo_inf1 m50_0320)
	*;
	
	(md_print "Gotta get in there...");female_trooper1
	(if (>= (ai_living_count female_trooper1) 1)
		(f_md_ai_play 0 female_trooper1 m50_0330)
		(f_md_object_play 0 NONE m50_0330))
	(sleep 60)

	; When the second group of Covenant emerges from the door on the west side of the area (which will probably be almost immediately after the above):
	(md_print "WHOA!  Contacts!  From the west!");trooper1
	(if (>= (ai_living_count trooper1) 1)
		(f_md_ai_play 0 trooper1 m50_0240)
		(f_md_object_play 0 NONE m50_0240))
	
	(md_finished)
)

(script dormant md_cv_encounter_complete
	(md_prep)
	; When all Covenant forces in the area are defeated:
	(md_print "Okay, let's move in and find that elevator!");trooper1
	(if (>= (ai_living_count trooper1) 1)
		(f_md_ai_play 0 trooper1 m50_0340)
		(f_md_object_play 0 NONE m50_0340))

	(md_finished)
	
	(wake ct_objective_elevator_start)
)

; -------------------------------------------------------------------------------------------------
; DIALOGUE: ATRIUM
; -------------------------------------------------------------------------------------------------

(script dormant md_atrium_elevator_call
	(sleep_until (> (device_get_position atrium_elevator_call) 0) 1)

		;(sleep (* 30 2))
		(sleep (random_range (* 30 4)(* 30 6)))
		(begin
			(vs_cast atrium_unsc_troopers FALSE 10 "m50_0460")
			(set trooper1 (vs_role 1))
		
			(md_prep)
			; When player presses elevator call button, IF at least one trooper remains:
			(md_print "What the hell's taking this thing so long?");trooper1
			(if (>= (ai_living_count trooper1) 1)
				(f_md_ai_play 0 trooper1 m50_0460)
				(f_md_object_play 0 NONE m50_0460))	
		)
	;)
	

	(md_print "We're evacuating a group civilians on the floor below you.  Soon as they reach the cargo port, I'll send the elevator back up.");trooper_sgt1
	(f_md_object_play 30 NONE m50_0470)
	
	; alternate
	;(md_print "We're evacuating those civilians and the elevator's acting up on us.  Soon as we get 'em down to the cargo port, I'll send it back up.");trooper_sgt1
	;(f_md_object_play 0 NONE m50_0480)
	(md_finished)
	(sleep_until b_atrium_counterattack_started)			

;*
	(if (and 
			(> (ai_task_count obj_atrium_unsc/gate_main) 0)
			(not b_atrium_complete))
*;			
		(begin
			(md_prep)
			(md_print "OK, everyone find some cover, stay sharp.  We need to hold this position!");trooper1
			(if (>= (ai_living_count trooper1) 1)
				(f_md_ai_play 30 trooper1 m50_0490)
				(f_md_object_play 30 NONE m50_0490))
			(md_finished)
			
			(sleep (* 30 2))
			(wake ct_objective_defend_start)
			(set b_md_defend_complete TRUE)
		)
	;)	
)

(script dormant md_atrium_counterattack
	;(sleep_until b_atrium_counterattack_started 1)
	(sleep_until (> (ai_task_count obj_atrium_cov/gate_counterattack) 0)1)

	(if (and 
			(> (ai_task_count obj_atrium_unsc/gate_main) 0)
			(not b_atrium_complete))
		
		(begin
			;(vs_cast atrium_unsc_troopers FALSE 10 "m50_0460")
			;(set trooper_03 (vs_role 1))
  		(sleep (* 30 7))
			(md_prep)
			; When Phantom dropship appears at the door end of the atrium, IF at least one trooper present:
			(md_print "Dropships!  Deploying to the courtyards!  Watch your flanks!");trooper1
			(if (>= (ai_living_count trooper1) 1)
				(f_md_ai_play 0 trooper1 m50_0510)
				(f_md_object_play 0 NONE m50_0510))
			(md_finished)
		)
	)
)

(script dormant md_atrium_hunters_arrive
	; When the Hunters come out, IF a trooper is still alive and present:
	;(sleep_until (and (> (ai_living_count atrium_cov_hunter0) 0) 
	;									(> (ai_living_count atrium_cov_hunter1) 0))1)
	;(sleep_until (> (ai_task_count obj_atrium_cov/hunters) 0)1)

	(sleep_until 
		(or
			(volume_test_object tv_music_atrium0 atrium_cov_captain0)
			(volume_test_object tv_music_atrium0 atrium_cov_captain1)
			(>= (ai_combat_status atrium_cov_captain0) 8)
			(>= (ai_combat_status atrium_cov_captain1) 8)
		)		
	5)
	
	(mus_layer_start mus_03 1)
	
;*
	(if (> (ai_task_count obj_atrium_unsc/gate_main) 0)
		(begin
				;(vs_cast atrium_unsc_troopers FALSE 10 "m50_0520")
				;(set trooper_04 (vs_role 1))
			
			(md_prep)
			(md_print "Hunters!  Big boys are all yours, Spartan!");trooper1
			(if (>= (ai_living_count trooper1) 1)
				(f_md_ai_play 0 trooper1 m50_0520)
				(f_md_object_play 0 NONE m50_0520))
			(md_finished)
		)
	)
*;
)

(script dormant md_atrium_hunters_defeated
	; When the Hunters have been killed, IF a trooper is still alive and present:
	(sleep_until (= b_atrium_complete true))
	(wake ct_objective_defend_complete)
	
	;(if (> (ai_task_count obj_atrium_unsc/gate_main) 0)
		;(begin
			(md_prep)
			(md_print "Damn, Lieutenant -- glad you're on our side!  Let's hop that elevator and get to the tower!");trooper1
			(if (>= (ai_living_count trooper1) 1)
				(f_md_ai_play 30 trooper1 m50_0530)
				(f_md_object_play 30 NONE m50_0530))
			(md_finished)
		;)
	;)
)

; AMBIENT
(script dormant md_traxus_ai01
	(sleep_until (volume_test_players tv_md_traxus_entrance) 1)
	
	(md_prep)
	; When the player enters the atrium:
	(md_print "Welcome -- to Traxus Heavy Industries.  Traxus: Getting you there is half the battle.");atrium_ai
	;(f_md_object_play 0 NONE m50_0410)
	(sound_impulse_start sound\dialog\levels\m50\mission\m50_0410_tra none 1)
	(md_finished)
)

(script dormant md_traxus_ai02
	(md_prep)
	; If the player goes out and re-enters the atrium (these alternate if the player does that multiple times):
	(md_print "Welcome -- to Traxus Heavy Industries.  Traxus: The sky's no limit.");atrium_ai
	;(f_md_object_play 0 NONE m50_0420)
	(sound_impulse_start sound\dialog\levels\m50\mission\m50_0420_tra none 1)
	(md_finished)
)

(script dormant md_traxus_evac_loop
	(sleep_until (volume_test_players tv_md_traxus_evac_start) 1)
	
	(sleep_until
		(begin
			(md_traxus_evac)
			(sleep (* 30 180))	
		b_ready_started)
	)
)
(script static void md_traxus_evac
	(md_prep)
	; Periodically recurring while the player is in the atrium (preceded by an alarm, perhaps?):
	(md_print "Evacuation in process.  Please move to the nearest exit.  Thank you for your cooperation.");atrium_ai
	;(f_md_object_play 0 NONE m50_0430)
	(sound_impulse_start sound\dialog\levels\m50\mission\m50_0430_tra none 1)
	(md_finished)
)

(script dormant md_traxus_ai04
	(md_prep)
	; Whenever the player nears one of the Information screens:
	(md_print "Traxus directory.  Wherever you're going, Traxus takes you there.");atrium_ai
	;(f_md_object_play 0 NONE m50_0450)
	(sound_impulse_start sound\dialog\levels\m50\mission\m50_0450_tra none 1)
	(md_finished)
)

;*
(script dormant md_atrium_shut_off
	; IF a trooper is still alive and present after the third time this plays: 
	; Added value if the Trooper then shoots a nearby AI station!
			
	(sleep_until (or
		(volume_test_players tv_md_atrium_near_elevator)
		(f_ai_is_defeated gr_cov_atrium_initial)) 1)

	(if (and 
			(> (ai_task_count obj_atrium_unsc/gate_main) 0)
			(not b_atrium_complete))
			
		(begin
			(md_prep)
			(md_print "Somebody shut that damn thing off!")
			(f_md_ai_play 0 trooper_01 m50_0440)
			;(f_md_object_play 0 NONE m50_0440)
			(md_finished)
		)
	)
)
*;

(script dormant md_traxus_ai_elevator
	(sleep_until (volume_test_players tv_md_traxus_elevator) 1)
	
	(md_prep)
	; Whenever the player enters the elevator:
	(md_print "Going down. Cargo Port and Traxus Tower.");atrium_ai
	;(f_md_object_play 0 NONE m50_0500)
	(sound_impulse_start sound\dialog\levels\m50\mission\m50_0500_tra none 1)
	(md_finished)
)
;=============================================================================================
;sound_impulse_start <sound> <object> <real>
;sc_info_booth_00-07

(global object g_location	NONE)
(global short md_atruim_ai 0)	
(global short md_atruim_ai_delay 500)	

(script static void md_play_info_booth
	;Whenever the player nears one of the Information screens:
  ;(sleep_until (not b_is_dialogue_playing) 1)
	(md_prep)
	(md_print "Traxus directory.  Wherever you're going, Traxus takes you there.");atrium_ai
	;(f_md_object_play 0 g_location m50_0450)
	;(f_md_object_play 0 NONE m50_0450)
	(sound_impulse_start sound\dialog\levels\m50\mission\m50_0450_tra none 1)
	(md_finished)
	(set md_atruim_ai (+ md_atruim_ai 1))
)	

(script dormant md_atrium_ai_response
	(sleep_until (and 
								(not b_atrium_counterattack_started)
								(>= md_atruim_ai 3) ) 5)

	(md_prep)
	;IF a trooper is still alive and present after the third time this plays:
	;(sleep_until (not b_is_dialogue_playing) 1)
	(md_print "Somebody shut that damn thing off!");trooper1
	(if (>= (ai_living_count trooper1) 1)
		(f_md_ai_play 0 trooper1 m50_0440)
		(f_md_object_play 0 NONE m50_0440))

	(md_finished)
	(set md_atruim_ai_delay (+ md_atruim_ai_delay 500))
)


(script dormant md_info_booth
		(sleep_until 
			(begin					
					(cond
					; -------------------------------------------------------------------------------------------------
						; -------------------------------------------------------------------------------------------------
						; condition #1 when the player is in this trigger and the associated object is not destroyed 
						(
							(and 
								(volume_test_players tv_info_screen_02) 
								(>= (object_get_health sc_info_booth_02) 1) 
							)

							; play this dialogue
							(begin
								(set g_location sc_info_booth_02)
								(md_play_info_booth)
								(sleep md_atruim_ai_delay)
							)
						)
						
						; -------------------------------------------------------------------------------------------------
						; condition #2 when the player is in this trigger and the associated object is not destroyed 
						(
							(and 
								(volume_test_players tv_info_screen_03) 
								(>= (object_get_health sc_info_booth_03) 1) 
							)

							; play this dialogue
							(begin
								(set g_location sc_info_booth_03)
								(md_play_info_booth)
								(sleep md_atruim_ai_delay)
							)
						)
						
						; -------------------------------------------------------------------------------------------------
						; condition #3 when the player is in this trigger and the associated object is not destroyed 
						(
							(and 
								(volume_test_players tv_info_screen_04) 
								(>= (object_get_health sc_info_booth_04) 1) 
							)

							; play this dialogue
							(begin
								(set g_location sc_info_booth_04)
								(md_play_info_booth)
								(sleep md_atruim_ai_delay)
							)
						)
						
						; -------------------------------------------------------------------------------------------------
						; condition #4 when the player is in this trigger and the associated object is not destroyed 
						(
							(and 
								(volume_test_players tv_info_screen_05) 
								(>= (object_get_health sc_info_booth_05) 1) 
							)

							; play this dialogue
							(begin
								(set g_location sc_info_booth_05)
								(md_play_info_booth)
								(sleep md_atruim_ai_delay)
							)
						)
						
						; -------------------------------------------------------------------------------------------------
						; condition #5 when the player is in this trigger and the associated object is not destroyed 
						(
							(and 
								(volume_test_players tv_info_screen_06) 
								(>= (object_get_health sc_info_booth_06) 1) 
							)

							; play this dialogue
							(begin
								(set g_location sc_info_booth_06)
								(md_play_info_booth)
								(sleep md_atruim_ai_delay)
							)
						)
						
						; -------------------------------------------------------------------------------------------------
						; condition #6 when the player is in this trigger and the associated object is not destroyed 
						(
							(and 
								(volume_test_players tv_info_screen_07) 
								(>= (object_get_health sc_info_booth_07) 1) 
							)

							; play this dialogue
							(begin
								(set g_location sc_info_booth_07)
								(md_play_info_booth)
								(sleep md_atruim_ai_delay)
							)
						)
						; -------------------------------------------------------------------------------------------------
						; condition #7 when the player is not in any trigger
						(
							(not b_atrium_complete)
							
							; play this dialogue
							(begin
								(if (<= md_atruim_ai 0)
									(begin
										;When the player enters the atrium:
										;(sleep_until (not b_is_dialogue_playing) 1)
										(md_prep)
										(md_print "Welcome -- to Traxus Heavy Industries.  Traxus: Getting you there is half the battle.");atrium_ai
										;(f_md_object_play 0 NONE m50_0410)
										(sound_impulse_start sound\dialog\levels\m50\mission\m50_0410_tra none 1)
										(set md_atruim_ai (+ md_atruim_ai 1))
										(md_finished)
										(sleep md_atruim_ai_delay)
									)
									
									(begin
										;Periodically recurring while the player is in the atrium (preceded by an alarm, perhaps?):		
										;(sleep_until (not b_is_dialogue_playing) 1)
										(md_prep)
										(md_print "Evacuation in process.  Please move to the nearest exit.  Thank you for your cooperation.");atrium_ai
										;(f_md_object_play 0 NONE m50_0430)
										(sound_impulse_start sound\dialog\levels\m50\mission\m50_0430_tra none 1)
										(set md_atruim_ai (+ md_atruim_ai 1))
										(md_finished)
										(sleep md_atruim_ai_delay)	
									)
								
							)
						)
					)	
				)
			b_atrium_counterattack_started
		)
	)
)


; -------------------------------------------------------------------------------------------------
; DIALOGUE: READY
; -------------------------------------------------------------------------------------------------

(script dormant md_ready_intro 
	(wake ct_objective_elevator_complete)
	
	(vs_cast atrium_unsc_elevator FALSE 10 "m50_0540")
	(set trooper_sgt1 (vs_role 1))
	
	(md_prep)
	; TRAXUS CARGO PORT
	; When the player approaches the troopers outside the building exit:
	(md_print "If you're trying to get to the tower, you're too late, Lieutenant -- Corvette over the Starport pounded the hell out of the place.  cargo port is impassable on foot; rooftop evac's a wash.");trooper_sgt1
	;(f_md_ai_play 0 trooper_sgt1 m50_0540)
	(f_md_object_play 0 NONE m50_0540)
	
	(md_print "We could use the executive landing pad… except there's no easy way to get there.");trooper_sgt1
	;(f_md_ai_play 0 trooper_sgt1 m50_0550)
	(f_md_object_play 30 NONE m50_0550)

	(md_print "A group of ODST specialists are working a plan. They might appreciate some back-up.");trooper_sgt1
	;(f_md_ai_play 0 trooper_sgt1 m50_0560)
	(f_md_object_play 30 NONE m50_0560)

	; alternate
	;(md_print "But these ODSTs have worked-up a plan…");trooper_sgt1
	;(f_md_ai_play 0 trooper_sgt1 m50_0580)
	(md_finished)
)

(script dormant md_ready_outside_door
	(md_prep)
	(md_print "Other side of the hall there, Lieutenant -- right through Triage.");trooper4
	(if (>= (ai_living_count trooper4) 1)
	(f_md_ai_play 0 trooper4 m50_0570)
	(f_md_object_play 0 NONE m50_0570))
	(md_finished)
)

;* When player enters the hall (these are one-offs, not necessarily right on top of each other, and can be just heard and not animated, if needed; it's dark in there):
	(vs_cast rr_civilians0 FALSE 10 "m50_0660" "m50_0670")
	(set civilian1 (vs_role 1))
	(set f_civilian1 (vs_role 2))
	
(script dormant md_ready_medic01
	(md_print "Someone get me two pints of O-neg!");civilian1
	(f_md_ai_play 0 civilian1 m50_0660)
)

(script dormant md_ready_medic02
	(md_print "Stay with me, trooper.  You're gonna be fine...");f_civilian1
	(f_md_ai_play 0 f_civilian1 m50_0670)
)

(script dormant md_ready_medic03
	(md_print "Need a foam cannister, stat!");civilian1
	(f_md_ai_play 0 civilian1 m50_0680)
)

(script dormant md_ready_medic04
	(md_print "He can wait; she needs to go on the next Falcon.");f_civilian1
	(f_md_ai_play 0 f_civilian1 m50_0690)
)*;

(script dormant md_ready_odst_intro
	(md_prep)

	; When the jet-pack ODSTs land on bridge and emerge from their pods:
	(if (player_has_female_voice player0)
  	(begin
  		(vs_cast unsc_jl_odsts FALSE 10 "m50_0600")
			(set trooper5_odst2 (vs_role 1));trooper5_odst2
			
			(md_print "There she is -- the one they were talking about…");trooper5_odst2
			(if (>= (ai_living_count trooper5_odst2) 1)
			(f_md_ai_play 0 trooper5_odst2 m50_0600))
			;(f_md_object_play 0 NONE m50_0600))
		)

		(begin
			(vs_cast unsc_jl_odsts FALSE 10 "m50_0590")
			(set trooper5_odst2 (vs_role 1));trooper5_odst2
  		
  		(md_print "There he is -- the one they were talking about…");trooper5_odst2
			(if (>= (ai_living_count trooper5_odst2) 1)
			(f_md_ai_play 0 trooper5_odst2 m50_0590))
			;(f_md_object_play 0 NONE m50_0590))
  	)
	)
	(md_finished)
)

(script dormant md_ready_odst_intro2
	;(sleep_until (>= objcon_ready 60) 1)
	
	(vs_cast unsc_jl_odsts FALSE 10 "m50_0610")
  (set trooper3_odst1 (vs_role 1));trooper3_odst1
  
  (md_prep)
	(md_print "Radio's buzzing about you, Spartan.  You feel like jumping?");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0610))
	;(f_md_object_play 0 NONE m50_0610))

	;* alternates
	(md_print "We've got an extra jetpack near the pods…");trooper5_odst2
	(f_md_ai_play 0 trooper5_odst2 m50_0620)

	(md_print "We've got an extra jetpack over there…");trooper5_odst2
	(f_md_ai_play 0 trooper5_odst2 m50_0630)
	*;

	(device_set_position dm_ready_door1 1)
	(device_set_position dm_ready_door2 1)

	(md_print "We've got an extra jetpack…");trooper5_odst2
	(if (>= (ai_living_count trooper5_odst2) 1)
	(f_md_ai_play 30 trooper5_odst2 m50_0640))
	;(f_md_object_play 30 NONE m50_0640))
	
	; When player approaches a jet-pack:
	(md_print "Go ahead. Try it on, Spartan.");trooper5_odst2
	(if (>= (ai_living_count trooper5_odst2) 1)
	(f_md_ai_play 30 trooper5_odst2 m50_0650))
	;(f_md_object_play 30 NONE m50_0650))
	(md_finished)
	
	(wake ct_objective_jetpack_start)
)


(script dormant md_ready_player_get_jetpack
	(md_prep)
	; When the player emerges onto the landing with a jet-pack on:
	(md_print "Welcome to the Bullfrogs!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0700)
	(f_md_object_play 0 NONE m50_0700))
	(md_finished)

	;(sleep 180)	
	(wake ct_objective_cargo_start)
	
	;(ai_migrate unsc_jl_odsts fireteam_player0)
	;(ai_set_objective fireteam_player0 obj_canyonview_unsc);fireteam player 0
	(if (not (game_is_cooperative))
		(begin
			(ai_player_add_fireteam_squad player0 unsc_jl_odsts)
			(ai_player_add_fireteam_squad player0 unsc_jl_odsts1)))
)

; -------------------------------------------------------------------------------------------------
; DIALOGUE: Jetpack
; -------------------------------------------------------------------------------------------------
(script dormant md_jp_doors_open
	(md_prep)
	;(sleep (* 2 30))

	(md_print "Other side, on my mark.  Three!  Two!  One!  JUMP!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0710))
	;(f_md_object_play 0 NONE m50_0710))
	(md_finished)
)

(script dormant md_jp_other_side
	(md_prep)
	
	; When player nears far landing:
	(md_print "We gotta get to the other side of the cargo port!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0890)
	(f_md_object_play 0 NONE m50_0890))
	(md_finished)
)

(script dormant md_jp_player_crosses
	;(sleep_until (>= objcon_jetpack_low 70))
	(md_prep)
	; When player completes first jump across:
	(md_print "We're gonna capture the landing pad on the Executive Wing, so the evac birds can land!  Try and keep up, Spartan!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0720)
	(f_md_object_play 0 NONE m50_0720))
	(md_finished)
	
	(wake hud_flash_evac0)
)

; If player dallies too long on any one level (one-offs):
(script dormant md_jp_keep_moving01
	(md_prep)
	(md_print "Keep it moving toward that pad!  ");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0830)
	(f_md_object_play 0 NONE m50_0830))
	(md_finished)
)

(script dormant md_jp_keep_moving02
	(md_prep)
	(md_print "Keep jumping!  Go, go, go!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0840)
	(f_md_ai_play 0 NONE m50_0840))
	(md_finished)
)

;*
(script dormant md_jp_keep_moving03
	(md_prep)
	(md_print "We're headed up to the pad, Spartan!");trooper5_odst2
	(if (>= (ai_living_count trooper5_odst2) 1)
	(f_md_ai_play 0 trooper5_odst2 m50_0850)
	(f_md_object_play 0 NONE m50_0850))
	(md_finished)
)

(script dormant md_jp_keep_moving04
	(md_prep)
	(md_print "Just keep jumping up!");trooper5_odst2
	(if (>= (ai_living_count trooper5_odst2) 1)
	(f_md_ai_play 0 trooper5_odst2 m50_0860)
	(f_md_object_play 0 NONE m50_0860))
	(md_finished)
)
*;

(script static void md_jp_take_elevator
	(md_prep)
	; When player reaches the foyer before the elevator room:
	(md_print "Head up to the roof level, Spartan!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0870)
	(f_md_object_play 0 NONE m50_0870))
	(md_finished)
	
	(if (not (game_is_cooperative))
		(ai_player_remove_fireteam_squad player0 unsc_jl_odsts))
	
	(wake ct_objective_tower_start)
)

; -------------------------------------------------------------------------------------------------
; DIALOGUE: JETPACK HIGH
; -------------------------------------------------------------------------------------------------


(script dormant md_jp_theres_the_pad
	(sleep_until (>= objcon_jetpack_high 5)5)
	
	(vs_cast jh_unsc_mars_balcony_inf0 FALSE 10 "m50_0900" "m50_0910")
	(set trooper3_odst1 (vs_role 1));trooper3_odst1
	(set trooper5_odst2 (vs_role 2));trooper5_odst2

	(md_prep)
	; When player reaches highest plaza:
	(md_print "There's the pad -- east end of that tower!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0900)
	(f_md_object_play 0 NONE m50_0900))

	(md_print "Entrance on the other side!");trooper5_odst2
	(if (>= (ai_living_count trooper5_odst2) 1)
	(f_md_ai_play 30 trooper5_odst2 m50_0910)
	(f_md_object_play 30 NONE m50_0910))
	(md_finished)
)

(script dormant md_jp_second_floor
	(sleep_until (>= objcon_jetpack_high 7)5)
	
	(md_prep)
	; When player emerges from elevator:
	(md_print "Over here, Spartan!");trooper5_odst2
	(if (>= (ai_living_count trooper5_odst2) 1)
	(f_md_ai_play 0 trooper5_odst2 m50_0880)
	(f_md_object_play 0 NONE m50_0880))
	(md_finished)
	
	(if (not (game_is_cooperative))
		(begin
			(ai_player_add_fireteam_squad player0 jh_unsc_odst_tree_inf0)
			(ai_player_add_fireteam_squad player0 jh_unsc_odst_balcony_inf0)))
)

(script dormant md_jp_clear_the_pad
  (sleep_until (>= objcon_trophy 20)5)
	
  (md_prep)
	; When player emerges onto pad:
	(md_print "Clear that pad, Spartan!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0920)
	(f_md_object_play 0 NONE m50_0920))
	(md_finished)
	
	(wake ct_objective_capture_pad)
	(mus_start mus_06)	
)

(script dormant md_jetpack_complete
	(sleep (random_range objective_delay (* objective_delay 2)))
	(md_prep)
	; When pad is clear:
	(md_print "Yankee Niner to Echo Dispatch: Landing pad is clear!  Send in the evac birds!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0930)
	(f_md_object_play 0 NONE m50_0930))

	(md_print "Copy, Yankee Niner.  Birds away.");air_control
	(f_md_object_play 30 NONE m50_0940)
	(md_finished)
	
	;(wake ct_objective_traxus_complete)
	(wake ct_objective_transport_start)
	(mus_stop mus_06)
)
; -------------------------------------------------------------------------------------------------
; DIALOGUE: JETPACK FLOURISH
; -------------------------------------------------------------------------------------------------
;*
Death from above!					trooper3_odst1	m50_0730
Bullfrogs incoming!				trooper3_odst1	m50_0740
Keep your arc up!					trooper3_odst1	m50_0750
Bounce it high!						trooper3_odst1	m50_0760
Watch your angle!					trooper3_odst1	m50_0770
Death from above!					trooper5_odst2	m50_0780
Nice arc!									trooper5_odst2	m50_0790
Here come the Bullfrogs!	trooper5_odst2	m50_0800
Easy down!								trooper5_odst2	m50_0810
Hang time!								trooper5_odst2	m50_0820

global ai
global line text

set line text
set ai
set line_number

	(md_prep)
	(md_print "line_text");ai
	(if (>= (ai_living_count ai) 1)
	(f_md_ai_play 0 ai line_number)
	(f_md_object_play 0 NONE line_number))
	(md_finished)
*;

(script dormant md_jp_flourish
	(sleep_until
		(begin
			;(if debug (print "jetpack flourish md..."))
			(sleep (random_range (* 30 15) (* 30 60)))
			(sleep_until (cv_player_jumping))
				(begin_random_count 10				
					(begin
						(set jp_flourish_ai trooper3_odst1)
						(set jp_flourish_text "Death from above!")
						(set jp_flourish_line m50_0730)
					)
					
					(begin
						(set jp_flourish_ai trooper3_odst1)
						(set jp_flourish_text "Bullfrogs incoming!")
						(set jp_flourish_line m50_0740)
					)
					
					(begin
						(set jp_flourish_ai trooper3_odst1)
						(set jp_flourish_text "Keep your arc up!")
						(set jp_flourish_line m50_0750)
					)
					
					(begin
						(set jp_flourish_ai trooper3_odst1)
						(set jp_flourish_text "Bounce it high!")
						(set jp_flourish_line m50_0760)
					)
					
					(begin
						(set jp_flourish_ai trooper3_odst1)
						(set jp_flourish_text "Watch your angle!")
						(set jp_flourish_line m50_0770)
					)
					
					(begin
						(set jp_flourish_ai trooper5_odst2)
						(set jp_flourish_text "Death from above!")
						(set jp_flourish_line m50_0780)
					)
					
					(begin
						(set jp_flourish_ai trooper5_odst2)
						(set jp_flourish_text "Nice arc!")
						(set jp_flourish_line m50_0790)
					)
					
					(begin
						(set jp_flourish_ai trooper5_odst2)
						(set jp_flourish_text "Here come the Bullfrogs!")
						(set jp_flourish_line m50_0800)
					)
					
					(begin
						(set jp_flourish_ai trooper5_odst2)
						(set jp_flourish_text "Easy down!")
						(set jp_flourish_line m50_0810)
					)
					
					(begin
						(set jp_flourish_ai trooper5_odst2)
						(set jp_flourish_text "Hang time!")
						(set jp_flourish_line m50_0820)
					)
				)
			(md_flourish_play jp_flourish_text jp_flourish_ai jp_flourish_line)
		FALSE)
	)
)

(global ai jp_flourish_ai NONE)
(global string jp_flourish_text "")
(global ai_line jp_flourish_line NONE)

(script static void (md_flourish_play (string text) (ai squad) (ai_line line))
	(md_prep)
	(md_print "text")
	(if (>= (ai_living_count squad) 1)
	(f_md_ai_play 0 squad line)
	(f_md_object_play 0 NONE line))
	(md_finished)
)

(script static boolean cv_player_jumping
	;*
	(or
		(and
			(< (objects_distance_to_object (ai_get_object unsc_jl_odsts) (player0)) 8.0)
			(> (objects_distance_to_object (ai_get_object unsc_jl_odsts) (player0)) 0))

		(and
			(< (objects_distance_to_object (ai_get_object jh_unsc_odst_balcony_inf0) (player0)) 8.0)
			(> (objects_distance_to_object (ai_get_object jh_unsc_odst_balcony_inf0) (player0)) 0))

		(and
			(< (objects_distance_to_object (ai_get_object jh_unsc_odst_tree_inf0) (player0)) 8.0)
			(> (objects_distance_to_object (ai_get_object jh_unsc_odst_tree_inf0) (player0)) 0))
	)
	*;
	(or
		(volume_test_players tv_flourish_ready0)
		(volume_test_players tv_flourish_ready1)
		(volume_test_players tv_flourish_ready2)
		(volume_test_players tv_flourish_ready3)
		(volume_test_players tv_flourish_low0)
		(volume_test_players tv_flourish_low1)
		(volume_test_players tv_flourish_high0)
		(volume_test_players tv_flourish_high1)
		(volume_test_players tv_flourish_high2)
		(volume_test_players tv_flourish_high3)
		(volume_test_players tv_flourish_high4)
	)

)

; -------------------------------------------------------------------------------------------------
; DIALOGUE: FALCON RIDE
; -------------------------------------------------------------------------------------------------
;*
(script dormant md_ride_master
	(wake md_jetpack_complete)
	(wake md_ride_start)
)
*;
(script dormant md_ride_start
	(md_prep)
	(thespian_performance_setup_and_begin trophy_odst_salute "" 0)
	; When the Falcon approaches:
	(md_print "Pleasure jumping with you, Spartan.");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0950)
	(f_md_object_play 0 NONE m50_0950))
	
	(md_print "We'll hold this location.  You get on that Falcon, and make sure those transports make it out in one piece!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 30 trooper3_odst1 m50_0960)
	(f_md_object_play 30 NONE m50_0960))
	(md_finished)

	(if (not (game_is_cooperative))
		(begin
			(ai_player_remove_fireteam_squad player0 jh_unsc_odst_tree_inf0)
			(ai_player_remove_fireteam_squad player0 jh_unsc_odst_balcony_inf0)
			(ai_player_remove_fireteam_squad player0 jh_odst_inf0)
			(ai_player_remove_fireteam_squad player0 trophy_odst_inf0)
			;(ai_player_remove_fireteam_squad player0 gr_unsc_odst)
		)
	)

	(sleep_until b_ride_falcon_landed 1)
	;(sleep_until 
	;	(and
	;		b_ride_falcon_landed
	;		b_ride_falcon0_landed
	;	)	5)
	
	;(wake ct_objective_transport_start)

	(md_prep)
	; As the Falcon lands:
	(md_print "This is your ride, Spartan!");trooper3_odst1
	(if (>= (ai_living_count trooper3_odst1) 1)
	(f_md_ai_play 0 trooper3_odst1 m50_0970)
	(f_md_object_play 0 NONE m50_0970))
	(md_finished)

	(sleep objective_delay)		
	(if  
		(not
			(or
				(player_in_vehicle (ai_vehicle_get ride_falcon/pilot))
				(player_in_vehicle (ai_vehicle_get ride_falcon0/pilot))
			)
		)
	
	(begin
		;blip falcons
		;(f_blip_object (ai_vehicle_get ride_falcon/pilot) blip_interface)
		;(f_blip_object (ai_vehicle_get ride_falcon0/pilot) blip_interface)
		(chud_track_object_with_priority (ai_vehicle_get ride_falcon/pilot) 21)
		
		(if (game_is_cooperative)
			(chud_track_object_with_priority (ai_vehicle_get ride_falcon0/pilot) 21)
		)
		
		(wake md_ride_pilot_master)
	))
)

; -------------------------------------------------------------------------------------------------
; DIALOGUE: Ride
; -------------------------------------------------------------------------------------------------

(script dormant md_ride
	(md_prep)
	(md_print "City's been under siege for the last five days.  Thought we had it in hand -- and then those Corvettes showed up.");female_pilot
	(f_md_object_play 0 NONE m50_1050)
	
	(md_print "Our fleet's scattered, pulling back.  Hell, we've all got orders to evacuate... Guess some of us just don't like leaving a job half-finished.");femal_pilot
	(f_md_object_play 0 NONE m50_1060)
	(md_finished)
)

(script dormant md_ride2
	(md_prep)
	; During Falcon ride:
	(md_print "Midtown airspace is way too hot.  Gonna take an alternate route.");female_pilot
	(f_md_object_play 0 NONE m50_1040)
	(md_finished)
)

(script dormant md_ride_pilot_ready
	(sleep (random_range (* 30 5) (* 30 10)))
		(md_prep)
		(md_print "Get on board, Lieutenant!  We've got civilians that need immediate assistance!");female_pilot
		(f_md_object_play 0 NONE m50_0980)
		(md_finished)
			
;*
	(if (< (random_range 0 100) 50)
		(begin
			(md_prep)
			(md_print "Get on board, Lieutenant!  We've got civilians that need immediate assistance!");female_pilot
			(f_md_object_play 0 NONE m50_0980)
			(md_finished)
			(sleep (random_range 300 600))
		)
		
		(begin
			(md_prep)
			(md_print "Get on board, Lieutenant!  We've got civilians that need immediate assistance!");female_pilot
			(f_md_object_play 0 NONE m50_0980)
			(md_finished)
			(sleep (random_range 300 600))
		)
	)
*;
)

(script dormant md_ride_pilot_master
	(sleep_until
		(begin
			(wake md_ride_pilot_ready)
		b_ride_player_in_falcon)
	)
)

; Falcon radio ambient dialogue:
(script dormant md_ride_chatter1
	(md_prep)
	(md_print "Evac transport Delta One Five to Evac Dispatch.  Loaded up, ready to go.");pilot1
	(f_md_object_play 0 NONE m50_0990)
	
	(md_print "Delta One Five, this is Evac Dispatch.  Copy that.  Proceed at your discretion.");air_control
	(f_md_object_play 0 NONE m50_1000)
	(md_finished)
)

(script dormant md_ride_chatter2
	(md_prep)
	(md_print "Delta One Five to Dispatch!  Banshee squadron on my tail!  Taking fire!");pilot1
	(f_md_object_play 0 NONE m50_1010)
	
	(md_print "Copy, Delta One Five.  Can you --");air_control
	(f_md_object_play 0 NONE m50_1020)
	
	(md_print "Mayday!  Port engine's hit!  We're going in!  I'm gonna try to set her down…!");pilot1
	(f_md_object_play 0 NONE m50_1030)
	(md_finished)
)


; -------------------------------------------------------------------------------------------------
; DIALOGUE: STARPORT
; -------------------------------------------------------------------------------------------------
(script dormant md_starport_intro	
	(md_prep)
	; STARPORT APPROACH
	(md_print "Fox Actual to UNSC frigate Stalwart Dawn.  Request immediate air strike on Covenant Corvette over Starport.");trooper_sgt2
	(f_md_object_play 0 NONE m50_1070)

	(md_print "Solid copy, Fox Actual.  Longswords unavailable at this time, over.");stalwart_dawn_actual
	(f_md_object_play 0 NONE m50_1080)

	(md_print "This is Civilian Transport Six Echo Two.  I need to go now, Sergeant Major!");civilian_transport_pilot1
	(f_md_object_play 0 NONE m50_1090)

	(md_print "Hold on, Echo Two -- Stalwart Dawn, I have multiple commercial craft loaded with civilians, and I have GOT to get them out of the city!  I need air support NOW!");trooper_sgt2
	(f_md_object_play 0 NONE m50_1100)

	(md_print "As soon as something frees up, you'll be the first to --");stalwart_dawn_actual
	(f_md_object_play 0 NONE m50_1110)

	(md_print "Not good enough!")
	(f_md_object_play 0 NONE m50_1120);trooper_sgt2
	
	(md_print "I've got six hundred souls onboard, Sergeant Major -- I can't wait any longer!");civilian_transport_pilot1
	(f_md_object_play 0 NONE m50_1130)

	(md_print "Negative, Echo Two, I can't cover you!  Do NOT take off!");trooper_sgt2
	(f_md_object_play 0 NONE m50_1140)

	(md_print "Dammit!")
	(f_md_object_play 0 NONE m50_1150);trooper_sgt2
	(md_finished)
)

(script dormant md_starport_transport
	(sleep (* 30 2))
	(md_prep)
	; After the transport ship is hit:
	(md_print "Oh, my God...!");female_pilot
	(f_md_object_play 0 NONE m50_1160)

	(md_print "Mayday!  Mayday!");civlian_transport_pilot1
	(f_md_object_play 0 NONE m50_1170)

	(md_print "Six Echo Two, can you maintain altitude?");trooper_sgt2
	(f_md_object_play 0 NONE m50_1180)

	(md_print "Negative!  We're going down!");civilian_transport_pilot1
	(f_md_object_play 0 NONE m50_1190)

;*
	(md_print "Echo Two, shut down your engines!");trooper_sgt2
	(f_md_object_play 0 NONE m50_1200)

	(md_print "Shut down our --?!");civilian_transport_pilot1
	(f_md_object_play 0 NONE m50_1210)

	(md_print "You crash with your reactors hot? You'll nuke the whole city!  SHUT 'EM DOWN!");trooper_sgt2
	(f_md_object_play 0 NONE m50_1220)
*;
	(md_print "Son of a BITCH --");female_pilot
	(f_md_object_play 0 NONE m50_1230)
;*
	(md_print "Roger, Sergeant Major.  Powering down.");civilian_transport_pilot1
	(f_md_object_play 0 NONE m50_1240)

	(md_print "Crash positions... Now!  Tell them!");civilan_transport_pilot1
	(f_md_object_play 0 NONE m50_1250)
*;
	; As the ship goes down:
	(md_print "I can't watch this.");female_pilot
	(f_md_object_play 0 NONE m50_1260)

	; After ship has crashed:
	(md_print "Fox Actual, should we send search-and-rescue birds?");air_control
	(f_md_object_play 30 NONE m50_1270)

	(md_print "Negative, Dispatch... No point.");trooper_sgt2
	(f_md_object_play 30 NONE m50_1280)
	
	;*
	; As Falcon lands:
	(md_print "Good luck, Spartan... God knows we need it.");female_pilot
	;(f_md_ai_play 0 ride_falcon m50_1290)
	(f_md_object_play 0 NONE m50_1290)
	*;
	(md_finished)
)

(script command_script cs_stow_weapon
	(cs_stow ai_current_actor TRUE)
)
;*
(script command_script cs_draw_weapon
	(cs_draw ai_current_actor TRUE)
)
*;

(script dormant md_commander_dialogue
	(vs_cast starport_unsc_command FALSE 10 "m50_1360")
	(set trooper_sgt2 (vs_role 1));trooper_sgt2
	
	(sleep 71)
	(md_prep)
	; As player approaches Duvall:
	(md_print "Spartan? Sergeant Major Duval. Awful day so far -- let's keep it from getting any worse!");trooper_sgt2
	;(if (>= (ai_living_count trooper_sgt2) 1)
	;(f_md_ai_play 0 trooper_sgt2 m50_1360)
	(f_md_object_play 0 NONE m50_1360);)
	

	(sleep 19)
	(md_print "Coveys are all over my missile batteries, and I got five thousand civilians across the bay waiting for passage out!");trooper_sgt2
	;(if (>= (ai_living_count trooper_sgt2) 1)
	;(f_md_ai_play 0 trooper_sgt2 m50_1370)
	(f_md_object_play 0 NONE m50_1370);)

	(sleep 18)
	(md_print "I need you to arm those batteries, and then fire the missiles from the central terminal.  Understood?");trooper_sgt2
	;(if (>= (ai_living_count trooper_sgt2) 1)
	;(f_md_ai_play 0 trooper_sgt2 m50_1380)
	(f_md_object_play 0 NONE m50_1380);)
	
	(set b_starport_monologue TRUE)	

	(sleep 21)
	(md_print "Corvette's been a pain in my ass too damn long.  Give it hell, Spartan!");trooper_sgt2
	;(if (>= (ai_living_count trooper_sgt2) 1)
	;(f_md_ai_play 0 trooper_sgt2 m50_1390)
	(f_md_object_play 0 NONE m50_1390);)

	(sleep 42)
	; As Duvall leaves Six:
	(md_print "Troopers! Let's get these split-jaws off our beach!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 0 trooper_sgt2 m50_1400)
	(f_md_object_play 0 NONE m50_1400))
	(md_finished)
	(set b_starport_monologue TRUE)
)

;*
(script dormant md_duvall_1360
	(vs_cast starport_unsc_command FALSE 10 "m50_1360")
	(set trooper_sgt2 (vs_role 1));trooper_sgt2
	
	(sleep 71)
	(md_prep)
	; As player approaches Duvall:
	(md_print "Spartan? Sergeant Major Duval. Awful day so far -- let's keep it from getting any worse!");trooper_sgt2
	(f_md_ai_play 0 trooper_sgt2 m50_1360)
	;(f_md_object_play 0 NONE m50_1360)
)

(script dormant md_duvall_1370
	(sleep 19)
	(md_print "Coveys are all over my missile batteries, and I got five thousand civilians across the bay waiting for passage out!");trooper_sgt2
	(f_md_ai_play 0 trooper_sgt2 m50_1370)
	;(f_md_object_play 0 NONE m50_1370)
)

(script dormant md_duvall_1380
	(sleep 18)
	(md_print "I need you to arm those batteries, and then fire the missiles from the central terminal.  Understood?");trooper_sgt2
	(f_md_ai_play 0 trooper_sgt2 m50_1380)
	;(f_md_object_play 0 NONE m50_1380)
	
)

(script dormant md_duvall_1390
	(sleep 21)
	(set b_starport_monologue TRUE)
	(md_print "Corvette's been a pain in my ass too damn long.  Give it hell, Spartan!");trooper_sgt2
	(f_md_ai_play 0 trooper_sgt2 m50_1390)
	;(f_md_object_play 0 NONE m50_1390)
)

(script dormant md_duvall_1400
	(sleep 42)
	; As Duvall leaves Six:
	(md_print "Troopers! Let's get these split-jaws off our beach!");trooper_sgt2
	(f_md_ai_play 0 trooper_sgt2 m50_1400)
	;(f_md_object_play 0 NONE m50_1400)
	(md_finished)
)
*;

(script dormant md_starport_objectives
	;(sleep_until (>= objcon_starport 10))
	;(sleep_until (volume_test_players tv_starport_start01) 5)
	;(sleep_until (f_ride_sync_check) 5)	
	
	;(thespian_performance_setup_and_begin starport_intro "" 0)
	
	(sleep_until b_starport_monologue)
	(wake ct_objective_missiles_start)
	
	(ai_dialogue_enable TRUE)
	(ai_set_task starport_unsc_command obj_starport_unsc start)	
	(ai_disregard (players) false)
	(ai_cannot_die starport_unsc_mars0 false)
	(set b_starport_music_start true)
	
	;(ai_set_objective starport_unsc_mars0 obj_starport_unsc)
	;(ai_set_objective starport_unsc_command obj_starport_unsc)
	
	;(cinematic_set_title ct_objective_activate_defenses)
	
	;(ai_migrate starport_unsc_mars0 fireteam_player0)

	
	(game_save)
	
	(wake md_starport_tension_master)
)

(script dormant md_starport_tension_master	
	;(sleep (random_range 900 1800))
	(sleep_until (>= objcon_starport 30) 5)
	
	;(vs_cast starport_unsc_command FALSE 10 "m50_1420")
	;(set trooper_sgt2 (vs_role 1));trooper_sgt2
	
	(md_prep)
	; As player makes his way to first battery:
	(md_print "Civilian transport Seven Echo Three to Fox Actual.  My engines are hot; waiting for your go.");civilian_transport_pilot2
	(f_md_object_play 0 NONE m50_1410)

	(md_print "Copy, Seven Echo Three.  We're working on it!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 0 trooper_sgt2 m50_1420)
	(f_md_object_play 30 NONE m50_1420))
	(md_finished)
	
	(sleep_until (or (volume_test_players tv_md_starport_battery0)
									(volume_test_players tv_md_starport_battery1)))
	
	; When player approaches the first battery:
	(md_print "That's the first missile battery, Lieutenant!  Get it armed!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 0 trooper_sgt2 m50_1430)
	(f_md_object_play 0 NONE m50_1430))
	
	(sleep_until (or b_starport_turret0_ready b_starport_turret1_ready))
	(sleep (random_range 30 60))
	
	; When player primes first battery (two alts):
	(cond 
		(; condition #1
			b_starport_turret0_ready
			; play this dialogue
			(begin
				(md_prep)
				(md_print "First battery's online!  Other one's to your north!");turret0;trooper_sgt2
				(if (>= (ai_living_count trooper_sgt2) 1)
				(f_md_ai_play 0 trooper_sgt2 m50_1440)
				(f_md_object_play 0 NONE m50_1440))
				(md_finished)
			)
		)
		
		(; condition #2
			b_starport_turret1_ready
			; play this dialogue
			(begin
				(md_prep)
				(md_print "First battery's online!  Other one's to your south!");turret1;trooper_sgt2
				(if (>= (ai_living_count trooper_sgt2) 1)
				(f_md_ai_play 0 trooper_sgt2 m50_1450)
				(f_md_object_play 0 NONE m50_1450))
				(md_finished)
			)
		)
	)
	
	; Followed immediately by:
	(md_prep)
	(md_print "Sergeant Major, Covenant are banging on my bay door,  I got families and wounded on board -- I gotta get airborne!");civilian_transport_pilot2
	(f_md_object_play 0 NONE m50_1460)

	(md_print "Easy, Seven Echo Three. Spartan's gonna clear the skies!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 30 trooper_sgt2 m50_1470)
	(f_md_object_play 30 NONE m50_1470))
	(md_finished)

	(mus_start mus_08)
	
	(sleep_until (and b_starport_turret0_ready b_starport_turret1_ready))
	;(sleep (random_range 300 600))
	(sleep (* 30 3))
	
	; When player primes second battery:
	(md_prep)
	(md_print "Batteries primed!  Now get over to the east complex and fire those missiles!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 0 trooper_sgt2 m50_1480)
	(f_md_object_play 0 NONE m50_1480))

	(wake ct_objective_arm_complete)

	(md_print "Sergeant Major, the Coveys are almost through my door!");civilian_transport_pilot2
	(f_md_object_play 30 NONE m50_1490)

	(md_print "Steady, Echo Three; that Corvette's still up there.");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 30 trooper_sgt2 m50_1500)
	(f_md_object_play 30 NONE m50_1500))
	(md_finished)
	
	(mus_layer_start mus_08 1)
	
	(sleep_until (volume_test_players tv_md_starport_terminal) 5)
	
	(md_prep)
	; When player nears central terminal:
	(md_print "That's it!  They've breached the landing bay!");civilian_transport_pilot2
	(f_md_object_play 0 NONE m50_1510)

	(md_print "Copy that!  Now or never, Spartan!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 30 trooper_sgt2 m50_1520)
	(f_md_object_play 30 NONE m50_1520))
	(md_finished)
)

(script dormant md_starport_complete
	(sleep_until (= b_starport_defenses_fired true))
	
	(wake ct_objective_missiles_complete)	
	(md_prep)
		
	; fired off when the button is pressed and at the same time that the cinematic is called
	;plays over the fade transition and during the head of the cinematic
	(md_print "Missile defense online!  All evac transports: You are cleared for take off!  Repeat, you are cleared for take off! Go! Now!");trooper_sgt2
	;(if (>= (ai_living_count trooper_sgt2) 1)
	;(f_md_ai_play 0 trooper_sgt2 m50_1530)
	(f_md_object_play 0 NONE m50_1530)
	;)
;*
	(md_print "Civilian transport away!");civilian_transport_pilot2
	(f_md_object_play 0 NONE m50_1540)

	(md_print "You saved a lotta lives today, Spartan!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 0 trooper_sgt2 m50_1550))
	(f_md_object_play 0 NONE m50_1550)

	(md_print "Few more days like this, we might save the whole damn planet!");trooper_sgt2
	(if (>= (ai_living_count trooper_sgt2) 1)
	(f_md_ai_play 0 trooper_sgt2 m50_1560))
	(f_md_object_play 0 NONE m50_1560)
*;
	(md_finished)
)



;*
(script dormant md_starport_uploading_codes
	(md_prep)
	
	(md_print "FOX ACTUAL: I'm uploading those arming codes to you now, Lieutenant.")
	;(md_play 0 sound\dialog\levels\m50\mission\robot\m50_1150_duv.sound)
	
	(md_finished)
)
*;

;*
(script dormant md_starport_south_armed
	(md_prep)
	(md_print "First battery's online!  Other one's to your north!");trooper_sgt2
	(f_md_ai_play 0 trooper_sgt2 m50_1440)
	;(f_md_object_play 0 NONE m50_1440)
	(md_finished)
)

(script dormant md_starport_north_armed
	(md_prep)
	(md_print "First battery's online!  Other one's to your south!");trooper_sgt2
	(f_md_ai_play 0 trooper_sgt2 m50_1450)
	;(f_md_object_play 0 NONE m50_1450)
	(md_finished)
)
*;

(global boolean playmusic		true)
; -------------------------------------------------------------------------------------------------
; SOUND HELPERS
(script static void (snd_loop (looping_sound s))
	(sound_looping_start s NONE 1))

(script static void (snd_stop (looping_sound s))
	(sound_looping_stop s))
	
(script static void (snd_stop_now (looping_sound s))
	(sound_looping_stop_immediately s))

(script static void (snd_play (sound s))
	(sound_impulse_start s (player0) 1))

(script static void (snd_play_all (sound s))
	(sound_impulse_start s NONE 1)
	(sleep (sound_impulse_language_time s)))
	
(script static void (mus_play (looping_sound s))
	(if debug (print "starting new music loop..."))
	(sound_looping_start s NONE 1))
;*	
(script static void (mus_alt (looping_sound s))
	(if debug (print "starting music alt loop..."))
	(sound_looping_set_alternate s TRUE))

(script static void (mus_stop (looping_sound s))
	(if debug (print "stopping music loop..."))
	(sound_looping_stop s))
*;	
(script static void (mus_stop_immediate (looping_sound s))
	(if debug (print "killing music loop..."))
	(sound_looping_stop_immediately s))
	
(script static void (cam_shake (real attack) (real intensity) (real decay))
	(player_effect_set_max_rotation 2 2 2)
	(player_effect_start intensity attack)
	(player_effect_stop decay))
; -------------------------------------------------------------------------------------------------

(script static void (mus_start (looping_sound s))
	(if playmusic (sound_looping_start s NONE 1)))
	
(script static void (mus_stop (looping_sound s))
	(sound_looping_stop s))
	
(script static void (mus_alt (looping_sound s))
	(sound_looping_set_alternate s true))

(script static void (mus_layer_start (looping_sound s) (long l))
	(sound_looping_activate_layer s l))

(script static void (mus_layer_stop (looping_sound s) (long l))
	(sound_looping_deactivate_layer s l))	
; =================================================================================================



(script static void hud_malfunction_loop
	(sleep_until
		(begin
			
		0)
	)
)


(global short s_hud_flash_count 0)
(script static void (hud_flash_message (cutscene_title t) (short count) (short delay))
	(snd_play snd_hud_reboot_tick)	
	(set s_hud_flash_count 0)
	(sleep_until
		(begin
			(cinematic_set_title t)
			(set s_hud_flash_count (+ s_hud_flash_count 1))
			(sleep delay)
		(>= s_hud_flash_count (- count 1)))
	1)
)

; =================================================================================================
;* MOTION SENSOR
(global boolean b_motionsensor_repaired 0)
(script static void hud_motionsensor_startup
	(wake hud_motionsensor_static)
	(hud_flash_message ct_hud_reboot_motion_startup 1 90)
	(if (= b_motionsensor_repaired 1)
		(begin
			(chud_show_motion_sensor 1)
			(snd_play snd_hud_success)
			(hud_flash_message ct_hud_reboot_motion_success 1 120)
		)
		
		(begin 
			(snd_loop snd_hud_fail)
			(hud_flash_message ct_hud_reboot_motion_fail 20 3)
			(snd_stop snd_hud_fail)
		)
	)
)

(global short s_motion_static_loop_count 0)
(script dormant hud_motionsensor_static
	(sleep_until
		(begin
			(chud_show_motion_sensor 1)
			(snd_loop snd_jitter)
			(sleep (random_range 3 15))
			(chud_show_motion_sensor 0)
			(snd_stop_now snd_jitter)
			(sleep (random_range 5 20))	
			(set s_motion_static_loop_count (+ s_motion_static_loop_count 1))	
		(>= s_motion_static_loop_count 3))
	1)
)


; =================================================================================================
; SHIELD
(global boolean b_shield_repaired 0)
(script static void hud_shield_startup
	(wake hud_shield_static)
	(hud_flash_message ct_hud_reboot_shield_startup 1 90)
	(if (= b_shield_repaired 1)
		(begin
			(chud_show_shield 1)
			(snd_play snd_hud_success)
			(hud_flash_message ct_hud_reboot_shield_success 1 120)
		)
		
		(begin 
			(snd_loop snd_hud_fail)
			(hud_flash_message ct_hud_reboot_shield_fail 20 3)
			(snd_stop snd_hud_fail)
		)
	)
)

(global short s_shield_static_loop_count 0)
(script dormant hud_shield_static
	(sleep_until
		(begin
			(chud_show_shield 1)
			(snd_loop snd_jitter)
			(sleep (random_range 3 15))
			(chud_show_shield 0)
			(snd_stop_now snd_jitter)
			(sleep (random_range 5 20))	
			(set s_shield_static_loop_count (+ s_shield_static_loop_count 1))	
		(>= s_shield_static_loop_count 3))
	1)
)

; =================================================================================================
; AMMO
(global boolean b_ammo_repaired 0)
(script static void hud_ammo_startup
	(hud_flash_message ct_hud_reboot_munitions_startup 1 90)
	(if (= b_ammo_repaired 1)
		(begin
			(chud_show_weapon_stats 1)
			(chud_show_grenades 1)
			(snd_play snd_hud_success)
			(hud_flash_message ct_hud_reboot_munitions_success 1 120)
		)
		
		(begin 
			(snd_loop snd_hud_fail)
			(hud_flash_message ct_hud_reboot_munitions_fail 20 3)
			(snd_stop snd_hud_fail)
		)
	)
)



(script static void hud_crosshair_shutdown
	(chud_show_crosshair 0)
)

(script static void hud_grenades_shutdown
	(chud_show_grenades 0)
)

(script static void hud_motionsensor_shutdown
	(chud_show_motion_sensor 0)
)

(script static void hud_shield_shutdown
	(chud_show_shield 0)
)



(script static void hud_weapons_shutdown
	(chud_show_weapon_stats 0)
)


(script static void hud_shutdown
	(chud_show_crosshair 0)
	(chud_show_grenades 0)
	(chud_show_motion_sensor 0)
	(chud_show_shield 0)
	(chud_show_weapon_stats 0))

(script static void hud_reboot
	(if debug (print "test"))
	(hud_motionsensor_startup)
	(hud_shield_startup)
	
)

;(script static void mus_test_start 	(sound_looping_start "sound\music\numbers\9m_full\9m_full" NONE 1))
;(script static void mus_test_alt 	(sound_looping_set_alternate 	"sound\music\numbers\9m_full\9m_full"  TRUE))
*;

; =================================================================================================
; WAR EFFECTS
; =================================================================================================
;\halox\main\tags\levels\solo\m50\fx\explosion_building.effect
;\halox\main\tags\levels\solo\m50\fx\explosion_flak.effect
;\halox\main\tags\levels\solo\m50\fx\explosion_water.effect
;\halox\main\tags\levels\solo\m50\fx\impact_ground.effect
; =================================================================================================

(global point_reference l_point pts_fx_pan_0/p1)
(global point_reference n_point pts_fx_pan_0/p1)
(global point_reference o_point pts_fx_pan_0/p5)

(script static void (f_fx_ambient (short fx_type))
	(cond
		((= fx_type 0)
			(begin
		 		(effect_new_random "levels\solo\m50\fx\explosion_building.effect" n_point)
				(sleep (random_range 0 15))
			)
		)
		((= fx_type 1)
			(begin
		 		(effect_new_random "levels\solo\m50\fx\explosion_building.effect" n_point)
				(sleep (random_range 0 15))
			)
		)		
	)
)

; panoptical
; ======================================

(script dormant f_panoptical_fx_ambient
	(sleep_until
		(begin
				(begin_random_count 1
						(begin
							(if debug (print "pts_fx_pan_0 pts_fx_ambient_a"))
							(set n_point pts_fx_ambient_a)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)				
					
						(begin
							(if debug (print "pts_fx_pan_0 pts_fx_ambient_b"))
							(set n_point pts_fx_ambient_b)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)
					
						(begin
							(if debug (print "pts_fx_pan_0 pts_fx_ambient_c"))
							(set n_point pts_fx_ambient_c)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)
					 
						(begin
							(if debug (print "pts_fx_pan_0 pts_fx_ambient_d"))
							(set n_point pts_fx_ambient_d)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)
			)
		FALSE)
	60)
)

; towers
; ======================================


(script dormant f_towers_fx_ambient
	(sleep_until
		(begin
			(begin_random_count 1
						(begin
							(if debug (print "pts_fx_master_tow_0 pts_fx_ambient_b"))
							(set n_point pts_fx_ambient_b)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)									
								)
						)
					
						(begin
							(if debug (print "pts_fx_tow_0 pts_fx_ambient_c"))
							(set n_point pts_fx_ambient_c)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)
			)
		FALSE)
	60)
)

; canyonview
; ======================================

(script dormant f_canyon_fx_ambient
	(sleep_until
		(begin
			(begin_random_count 1
						(begin
							(if debug (print "pts_fx_master_can_0 pts_fx_ambient_a"))
							(set n_point pts_fx_ambient_a)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)									
								)
						)
					
						(begin
							(if debug (print "pts_fx_can_0 pts_fx_ambient_b"))
							(set n_point pts_fx_ambient_b)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)

						(begin
							(if debug (print "pts_fx_can_0 pts_fx_ambient_c"))
							(set n_point pts_fx_ambient_c)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)

						(begin
							(if debug (print "pts_fx_can_0 pts_fx_ambient_d"))
							(set n_point pts_fx_ambient_d)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)

						(begin
							(if debug (print "pts_fx_can_0 pts_fx_ambient_e"))
							(set n_point pts_fx_ambient_e)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)
					)					
		FALSE)
	60)
)


; atrium
; ======================================

(script dormant f_atrium_fx_ambient
	(sleep_until
		(begin
						(begin
							(if debug (print "pts_fx_master_atr_0 pts_fx_ambient_c"))
							(set n_point pts_fx_ambient_c)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)									
								)
						)
		FALSE)
	60)
)

; jetpack
; ======================================	

(script dormant f_jetpack_fx_ambient
	(sleep_until
		(begin
			(begin_random_count 1
						(begin
							(if debug (print "pts_fx_master_jet_0 pts_fx_ambient_a"))
							(set n_point pts_fx_ambient_a)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)									
								)
						)

						(begin
							(if debug (print "pts_fx_jet_0 pts_fx_ambient_d"))
							(set n_point pts_fx_ambient_d)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)

						(begin
							(if debug (print "pts_fx_jet_0 pts_fx_ambient_e"))
							(set n_point pts_fx_ambient_e)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)
			)
		FALSE)
	60)
)

; ride
; ======================================
; starport
; ======================================

(script dormant f_starport_fx_ambient
	(sleep_until
		(begin
			(begin_random_count 1
						(begin
							(if debug (print "pts_fx_master_star_0 pts_fx_ambient_b"))
							(set n_point pts_fx_ambient_b)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)									
								)
						)

						(begin
							(if debug (print "pts_fx_star_0 pts_fx_ambient_e"))
							(set n_point pts_fx_ambient_e)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)

						(begin
							(if debug (print "pts_fx_star_0 pts_fx_ambient_f"))
							(set n_point pts_fx_ambient_f)						
								(begin_random_count 1
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
									(f_fx_ambient 0)
								)
						)
			)
		FALSE)
	60)
)

; =================================================================================================
; wraith shells
; ======================================
(script dormant ambient_wraith_shells_a
	(sleep_until
		(begin
			;(if debug (print "wraith shell a..."))
			(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" 000_ambient_shells_a 5 5)
			(sleep (random_range 5 60))
		0)
	)
)

(script dormant ambient_wraith_shells_b
	(sleep_until
		(begin
			;(if debug (print "wraith shell b..."))
			(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" 000_ambient_shells_b 5 5)
			(sleep (random_range 5 60))
		0)
	)
)


; CORVETTE ATTACKS
; =================================================================================================
(script dormant panoptical_corvette_attack
	(sleep_until
		(begin
			;(if debug (print "panoptical corvette attack..."))
			(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" 000_ambient_shells_a 5 5)
			(sleep (random_range 5 60))
		0)
	)
)

; CORVETTES
; =================================================================================================

(script dormant f_corvette_exterior
	(sleep_until
		(begin
			(begin
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_01_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_02_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_03_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_04_01 "")
			)
			
			(sleep (random_range (* 30 5) (* 30 7)))

			b_interior_started)
	)

	(sleep_until (>= objcon_canyonview 10))

	(sleep_until
		(begin
			(begin
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_01_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_02_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_03_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_panoptical_04_01 "")
			)
			
			(sleep (random_range (* 30 5) (* 30 7)))

			b_atrium_complete)
	)
)


; =================================================================================================
(script dormant f_corvette_starport
	(sleep_until
		(begin
			(begin
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_starport_01_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_starport_02_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_starport_03_01 "")
				(sleep (random_range (* 30 0)(* 30 1)))
				(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_starport_04_01 "")
			)
			
			(sleep (random_range (* 30 5) (* 30 7)))

		b_starport_defenses_fired);b_starport_monologue
	)
)
; =================================================================================================
; CORVETTE SCRIPTS
; =================================================================================================
;*
(script static void start_corvette_fx
	(set corvette_fx TRUE)
	(if (= corvette_fx TRUE)
		(begin
			(wake fx_corvette_1)
			;(wake fx_corvette_2)
			;(wake fx_corvette_3)
		)
	)
)

(script dormant fx_corvette_1
	(if debug (print "Corvette #1 firing!"))
	(sleep_until
		(begin
			(sleep (random_range 30 45))
			(begin_random_count 2
				(begin
					(if debug (print "firing turret 0"))
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret0 "")
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret0 "")					
					;(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette1/p_turret0)
					;(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette1/p_explosion0)
				)
			
				(begin
					(if debug (print "firing turret 1"))
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret1 "")
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret1 "")
					
					;(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette1/p_turret1)
					;(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette1/p_explosion1)
				)
				
				(begin
					(if debug (print "firing turret 2"))
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret2 "")
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret2 "")
					;(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette1/p_turret2)
					;(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette1/p_explosion2)
				)
				
				(begin
					(if debug (print "firing turret 3"))
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret3 "")
					(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire fx_corvette_turret3 "")
					;(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette1/p_turret3)
					;(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette1/p_explosion3)
				)
			)
			FALSE
		)
	)
)

(script dormant fx_corvette_2
	(if debug (print "Corvette #2 firing!"))
	(sleep_until
		(begin
			(sleep (random_range 30 45))
			(begin_random_count 2
				(begin
					(if debug (print "firing turret 0"))
					(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette2/p_turret0)
					(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette2/p_explosion0))
			
				(begin
					(if debug (print "firing turret 1"))
					(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette2/p_turret1)
					(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette2/p_explosion1))
				
				(begin
					(if debug (print "firing turret 2"))
					(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette2/p_turret2)
					(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette2/p_explosion2))
				
				(begin
					(if debug (print "firing turret 3"))
					(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette2/p_turret3)
					(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette2/p_explosion3))
			)
			FALSE
		)
	)
)

(script dormant fx_corvette_3
	(if debug (print "Corvette #3 firing!"))
	(sleep_until
		(begin
			(sleep (random_range 30 45))
			(begin_random_count 2
				(begin
					(if debug (print "firing turret 0"))
					(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette3/p_turret0)
					(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette3/p_explosion0))
			
				(begin
					(if debug (print "firing turret 1"))
					(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" points000_corvette3/p_turret1)
					(effect_new_random "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" points000_corvette3/p_explosion1))
			)
			FALSE
		)
	)
)

*;

; AIR STRIKES
; =================================================================================================
(global short s_min_longsword_flyby_delay 15)
(global short s_max_longsword_flyby_delay 45)

(script static void (ls_flyby (device_name d))
	(object_create d)
	(device_animate_position d 0 0.0 0.0 0.0 TRUE)
	(device_set_position_immediate d 0)
	(device_set_power d 0)
	(sleep 1)
	;(device_set_position_track d device:position 0)
	(device_set_position_track d device:m50 0)
	(device_animate_position d 0.5 7.0 0.1 0.1 TRUE)
	(sleep_until (>= (device_get_position d) .5))
	(object_destroy d))

(script static void ls_flyby_sound
	;(sound_impulse_start "sound\device_machines\040vc_longsword\start.sound" NONE 1))
	(sound_impulse_start snd_longsword_flyby NONE 1))

(script static void ls_flyby_delay
	(sleep (random_range (* 30 s_min_longsword_flyby_delay) (* 30 s_max_longsword_flyby_delay))))

(script dormant panoptical_longsword_cycle
	(sleep (random_range 30 150))
	
	
	(sleep_until 
		(begin
			(begin_random
				(begin
					(ls_flyby ls_panoptical_01)
					(sleep 10)
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_panoptical_02)
					(sleep 10)
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_panoptical_03)
					(sleep 10)
					;(ls_flyby_sound)
					(ls_flyby_delay))
			)
		0)
	)
)

(script dormant towers_longsword_cycle
	(sleep_forever panoptical_longsword_cycle)
	(sleep (random_range 30 150))
	
;*
	(object_create ls_towers_01)
	(object_create ls_towers_02)
	(object_create ls_towers_03)
*;	
	(sleep_until 
		(begin
			(ls_flyby ls_towers_01)
			(sleep (* 30 1))
			(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_tow_0/p0)
			(sleep (* 30 .125))
			(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_tow_0/p1)
			(ls_flyby ls_towers_02)
			
			(ls_flyby ls_towers_03)
			(sleep (* 30 1))
			(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_tow_0/p2)
			(sleep (* 30 .125))
			(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_tow_0/p3)
			(sleep (* 30 .125))
			(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_tow_0/p4)
			(ls_flyby_delay)
		0)
	)
)



(script dormant canyonview_longsword_cycle
	(sleep_forever towers_longsword_cycle)
	(sleep (random_range 30 150))
;*	
	(object_create ls_canyonview_01)
	(object_create ls_canyonview_02)
	(object_create ls_canyonview_03)
	(object_create ls_canyonview_04)	
	(object_create ls_canyonview_05)	
	(object_create ls_canyonview_06)	
	(object_create ls_canyonview_07)	
*;
	(sleep_until 
		(begin
			(begin_random
				(begin
					(ls_flyby ls_canyonview_02)
					(ls_flyby ls_canyonview_03)
					(ls_flyby ls_canyonview_04)
					(sleep (* 30 1))
					(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_can_0/p0)
					(sleep (* 30 .125))
					(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_can_0/p1)
					(sleep (* 30 .125))
					(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_can_0/p2)
					(sleep (* 30 .125))

					(sleep 20)
					
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_canyonview_01)
					(sleep 10)
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_canyonview_05)
					(ls_flyby ls_canyonview_06)
					(ls_flyby ls_canyonview_07)
					(sleep (* 30 1))
					(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_can_0/p3)
					(sleep (* 30 .125))
					(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_can_0/p4)
					(sleep (* 30 .125))
					(effect_new_random "levels\solo\m50\fx\explosion_building.effect" pts_fx_can_0/p5)
					(sleep (* 30 .125))
					
					(sleep 5)
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_canyonview_08)
					(ls_flyby ls_canyonview_09)
					(sleep 5)
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_canyonview_10)
					(sleep 5)
					;(ls_flyby_sound)
					(ls_flyby_delay))
			)
		0)
	)
)
		
		
(script dormant jetpack_longsword_cycle
	(sleep (random_range 30 150))
	
	(object_create ls_jetpack_01)
	(object_create ls_jetpack_02)
	(object_create ls_jetpack_03)
	
	(sleep_until 
		(begin
			(begin_random
				(begin
					(ls_flyby ls_jetpack_01)
					(sleep 10)
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_jetpack_02)
					(sleep 10)
					;(ls_flyby_sound)
					(ls_flyby_delay))
					
				(begin
					(ls_flyby ls_jetpack_03)
					(sleep 10)
					;(ls_flyby_sound)
					(ls_flyby_delay))
			)
		0)
	)
)
			
;*					
(script static void ls_test 
	(sleep_until 
		(begin
			(ls_flyby ls1)
			(ls_flyby ls2)
			(ls_flyby ls3)
			(sleep 10)
			(sound_impulse_start "sound\levels\070_waste\070_longsword_crash\070_longsword.sound" NONE 3)
			(sleep 90)
			(flyby_bomb bombs 8 4)
			(sleep 450)
		0)
	)
)
*;

(global short s_current_bomb 0)
(script static void (flyby_bomb (point_reference p) (short count) (short delay))
	(set s_current_bomb 0)
	(sleep_until
		(begin
			(print "boom")
			;(effect_new_at_point_set_point "fx\fx_library\_placeholder\placeholder_explosion.effect" p s_current_bomb)
			(effect_new_at_point_set_point "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" p s_current_bomb)
			;(effect_new_at_ai_point "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" bombs/p0)
			(set s_current_bomb (+ s_current_bomb 1))
			(sleep delay)
		(>= s_current_bomb count)) 1)	
)

;*
(script static void (ls_flyby (device d))
	(device_set_position_track d device:position 0)
	(device_animate_position d 0 0.0 0.0 0.0 TRUE)
	(device_set_position_immediate d 0)
	(device_set_power d 0)
	(sleep 1)
	(device_set_position_track d device:position 0)
	(device_animate_position d 0.5 7.0 0.1 0.1 TRUE))*;
	
(global boolean b_kill_canyon_dropships FALSE)
; AMBIENT DROPSHIPS
; =================================================================================================
(script command_script cs_ambient_dropship_1
	;Scale up
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	
	(cs_enable_pathfinding_failsafe TRUE)	
	(sleep_until
		(begin
			(sleep (random_range 0 240))
				(cs_vehicle_speed 1.0)
				;(cs_vehicle_boost TRUE)
			(cs_fly_by 000_ambient_dropship_1/entry0)
				(cs_vehicle_boost FALSE)
				(cs_vehicle_speed 0.8)
			(cs_fly_to 000_ambient_dropship_1/hover 0.5)
				(cs_vehicle_speed 0.4)
			 	(sleep (random_range 30 60))
			(cs_fly_to_and_face 000_ambient_dropship_1/land 000_ambient_dropship_1/land_facing 0.5)
				(cs_vehicle_speed 0.6)
				(sleep (random_range 90 150))
			(cs_fly_to_and_face 000_ambient_dropship_1/hover 000_ambient_dropship_1/land_facing 0.5)
				(cs_vehicle_speed 1.0)
				;(cs_vehicle_boost TRUE)
			(cs_fly_by 000_ambient_dropship_1/entry0)
			(cs_fly_to 000_ambient_dropship_1/start 0.5)
				;(sleep (random_range 60 240))
		b_kill_canyon_dropships)
	)
			
	;Scale down
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(sleep (* 30 5))
	(ai_erase ai_current_squad)
)

(script command_script cs_ambient_dropship_2
	;Scale up
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	
	(cs_enable_pathfinding_failsafe TRUE)	
	(sleep_until
		(begin
			(sleep (random_range 0 240))
				(cs_vehicle_speed 1.0)
				;(cs_vehicle_boost TRUE)
			(cs_fly_by 000_ambient_dropship_2/entry0)
				(cs_vehicle_boost FALSE)
				(cs_vehicle_speed 0.8)
			(cs_fly_to 000_ambient_dropship_2/hover 0.5)
				(cs_vehicle_speed 0.4)
			 	(sleep (random_range 30 60))
			(cs_fly_to_and_face 000_ambient_dropship_2/land 000_ambient_dropship_2/land_facing 0.5)
				(cs_vehicle_speed 0.6)
				(sleep (random_range 90 150))
			(cs_fly_to_and_face 000_ambient_dropship_2/hover 000_ambient_dropship_2/land_facing 0.5)
				(cs_vehicle_speed 1.0)
				;(cs_vehicle_boost TRUE)
			(cs_fly_by 000_ambient_dropship_2/entry0)
			(cs_fly_to 000_ambient_dropship_2/start 0.5)
				;(sleep (random_range 60 240))
		b_kill_canyon_dropships)
	)
		
	;Scale down
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(sleep (* 30 5))
	(ai_erase ai_current_squad)
)

(script command_script cs_ambient_dropship_3
	;Scale up
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	
	(cs_enable_pathfinding_failsafe TRUE)	
	(sleep (random_range 0 240))
	(sleep_until
		(begin
				(cs_vehicle_speed 1.0)
				;(cs_vehicle_boost TRUE)
			(cs_fly_by 000_ambient_dropship_3/entry0)
				(cs_vehicle_boost FALSE)
				(cs_vehicle_speed 0.8)
			(cs_fly_to 000_ambient_dropship_3/hover 0.5)
				(cs_vehicle_speed 0.4)
			 	(sleep (random_range 30 60))
			(cs_fly_to_and_face 000_ambient_dropship_3/land 000_ambient_dropship_3/land_facing 0.5)
				(cs_vehicle_speed 0.6)
				(sleep (random_range 90 150))
			(cs_fly_to_and_face 000_ambient_dropship_3/hover 000_ambient_dropship_3/land_facing 0.5)
				(cs_vehicle_speed 1.0)
				;(cs_vehicle_boost TRUE)
			(cs_fly_by 000_ambient_dropship_3/entry0)
			(cs_fly_to 000_ambient_dropship_3/start 0.5)
				(sleep (random_range 60 240))
		b_kill_canyon_dropships)
	)
)

(script dormant ambient_spawn_dropships
	(f_ai_place_vehicle_deathless cov.ambient.dropship.1)
	(f_ai_place_vehicle_deathless cov.ambient.dropship.2)
	;(f_ai_place_vehicle_deathless cov.ambient.dropship.3)
	;(ai_place cov.ambient.dropship.1)
	;(ai_place cov.ambient.dropship.2)
	;(ai_place cov.ambient.dropship.3)
	(ai_set_clump cov.ambient.dropship.1 2)
	(ai_set_clump cov.ambient.dropship.2 2)
	;(ai_set_clump cov.ambient.dropship.3 2)
)

(script static void kill_ambient_dropships
;*	
	(ai_erase cov.ambient.dropship.1)
	(ai_erase cov.ambient.dropship.2)
	(ai_erase cov.ambient.dropship.3)
*;
	(set b_kill_canyon_dropships TRUE)
)	


; civilian transport scripts
(global boolean transport_start false)
(global boolean transport_finish false)
; =================================================================================================
; TRANSPORT TEST SCRIPTS
                ;Total Frames: 1000
                ;Bolt Impact: 333 frames = .333%
                ;bolt travel time: 0.033079% of device anim
                ;Water Impact: 540 frames =.54%
                ;30 frames = 1 sec = 3.75% = .03
                ;15 frames = 1/2 sec = ???% = .015
                ;7.5 frames = 1/4 sec = ???% = .0075
; =================================================================================================
(script dormant civilian_transport_takeoff
;*
	(sleep_until
		(begin
			(sleep_until transport_start)
*;
			(device_set_position_track dm_civilian_transport "m50_starport_escape" 0)
			
			;delay event start
			(sleep (* 30 8))
			
			(device_animate_position dm_civilian_transport 1.0 33.33 .1 .1 false);1000 frames           
;*
			(sleep (* 30 9.6))
			(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire civilian_ship_hit "")

			(sleep (* 30 1.3));11.1
      (wake md_starport_transport) 
      
			(sleep (* 30 7.0));18
			(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\water_impact\civilian_ship_water_impact civilian_ship_crash "")
*;
			;(sleep_until (>= (device_get_position dm_civilian_transport) 0.308275) 1); late 0.001002%
			(sleep_until (>= (device_get_position dm_civilian_transport) 0.307273) 1)
			(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire civilian_ship_hit "")

			(wake md_starport_transport)

			(sleep_until (>= (device_get_position dm_civilian_transport) .54) 1)
			(effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\water_impact\civilian_ship_water_impact civilian_ship_crash "")
;*		
			(sleep_until transport_finish)
		FALSE)
	1)
*;

)


;*
(script dormant civilian_transport_takeoff_loop
                (sleep_until
                (begin
                (print "anim: civilian transport takeoff")
                (device_set_position_track dm_civilian_transport "m50_starport_escape" 0)
                (device_animate_position dm_civilian_transport 1.0 26.66 .1 .1 false);1000 frames           

                (sleep_until 
                                (>= (device_get_position dm_civilian_transport) 0.2615) 1)
                (effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire civilian_ship_hit "")
                                
                (sleep_until 
                                (>= (device_get_position dm_civilian_transport) .535) 1)
                (effect_new_on_object_marker levels\solo\m50\fx\civilian_ship_crash\water_impact\civilian_ship_water_impact civilian_ship_crash "")
                                                
                
                (sleep_until (= (device_get_position dm_civilian_transport) 1) 1)
                (print "anim: spline_00 done")
                
                (sleep (* 30 5))
                
                (device_animate_position dm_civilian_transport 0.0 0.00 0 0 false)
                FALSE)1)
)
*;
;*
(script static void ins_transport_test
	
	;(set s_active_insertion_index s_index_starport)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set starport_test)
			(sleep 1)))
	
	; Teleport
	(object_teleport_to_ai_point (player0) falcon_ride/land)
	(object_teleport_to_ai_point (player1) falcon_ride/land)
		
	(objects_destroy_all)
	(wake object_control)
		
	(cinematic_fade_to_gameplay)
	(sleep 1)
 	;(wake ride_transport_test)
 	(wake civilian_transport_takeoff_loop)
 	(fade_in 0 0 0 0)
)

(script static void ins_transport_test_cache
	
	;(set s_active_insertion_index s_index_starport)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set starport_test)
			(sleep 1)))
	
	; Teleport
	(object_teleport (player0) spawn_starport_player0)
	(object_teleport (player1) spawn_starport_player1)
	(object_teleport (player2) spawn_starport_player2)
	(object_teleport (player3) spawn_starport_player3)
			
	(cinematic_fade_to_gameplay)
	(sleep 1)
 	;(wake ride_transport_test)
 	(wake ride_transport_test)
 	(wake civilian_transport_takeoff)
 	(fade_in 0 0 0 0)
)
*;
;*
(script dormant ride_transport_test
	(sleep_until
	(begin

		
	(ai_place ride_falcon_test)
	(set v_ride_falcon (ai_vehicle_get ride_falcon_test/pilot))
	(cs_enable_pathfinding_failsafe ride_falcon_test TRUE)
	(ai_cannot_die ride_falcon_test true)
	;(vehicle_load_magic (ai_vehicle_get ride_falcon_test/pilot) "falcon_p" (players))	
	(vehicle_load_magic (ai_vehicle_get ride_falcon_test/pilot) "falcon_p_r2" (player0))	
	(unit_lower_weapon (player0) 15)
	(sleep 30)

	(set transport_finish FALSE)
	(sleep 1)
	(set transport_start TRUE)

	(cs_vehicle_speed ride_falcon_test 1.0)
 	(cs_fly_by ride_falcon_test TRUE falcon_ride/park 5)

  (cs_fly_by ride_falcon_test TRUE falcon_ride/evac 5)
  (cs_vehicle_speed ride_falcon_test 0.6)
  (cs_fly_to_and_face ride_falcon_test TRUE falcon_ride/hover falcon_ride/hover_facing 5)
	(sleep 90)
	(cs_vehicle_speed ride_falcon_test 0.2)
  (cs_fly_to_and_face ride_falcon_test TRUE falcon_ride/land falcon_ride/land_facing 0.5)
  
		
	(if debug (print "unloading falcon..."))
	(vehicle_unload v_ride_falcon "falcon_p")
	(unit_raise_weapon (player0) 15)
  (sleep 30)
	(ai_erase ride_falcon_test)
	
	(sleep 1)
	(sleep_until (= (device_get_position dm_civilian_transport) 1) 1)
	(device_animate_position dm_civilian_transport 0.0 0.00 0 0 false)
	(sleep 10)
	
	(set transport_start FALSE)
	(sleep 1)
	(set transport_finish TRUE)
	
	FALSE))
)
*;

; =================================================================================================
; AMBIENT FX TEST SCRIPTS
; =================================================================================================
;*
(script static void ins_ambient_fx_test
; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set ambient_fx_test)
			(sleep 1)))
	
	; Teleport
	(object_teleport_to_ai_point (player0) pts_teleport/p0)
			
	(cinematic_fade_to_gameplay)
	(sleep 1)
 	(wake ambient_fx_test)
 	(fade_in 0 0 0 0)
)
*;
(script dormant ambient_fx_test
	(wake f_panoptical_fx_ambient)
	(wake f_towers_fx_ambient)
	(wake f_canyon_fx_ambient)
	(wake f_atrium_fx_ambient)
	(wake f_jetpack_fx_ambient)
	(wake f_starport_fx_ambient)
)

(script static void ins_ambient_fx_test_panoptical
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_panoptical_010_020)
			(sleep 1)))
	
	; Teleport
	(object_teleport_to_ai_point (player0) pts_teleport/panoptical)
			
	(cinematic_fade_to_gameplay)
	(sleep 1)
 	(wake f_panoptical_fx_ambient)
 	(wake f_towers_fx_ambient)
 	(fade_in 0 0 0 0)
)

(script static void ins_ambient_fx_test_canyonview
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_atrium_040_050_060)
			(sleep 1)))
	
	; Teleport
	(object_teleport_to_ai_point (player0) pts_teleport/canyonview)
			
	(cinematic_fade_to_gameplay)
	(sleep 1)
	(device_set_position dm_canyonview_door1 1)
 	(wake f_canyon_fx_ambient)
 	(wake f_atrium_fx_ambient)
 	(fade_in 0 0 0 0)
)

(script static void ins_ambient_fx_test_jetpack
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)))
	
	; Teleport
	(object_teleport_to_ai_point (player0) pts_teleport/jetpack)
			
	(cinematic_fade_to_gameplay)
	(sleep 1)
 	(wake f_jetpack_fx_ambient)
 	(fade_in 0 0 0 0)
)

(script static void ins_ambient_fx_test_starport
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_starport_090)
			(sleep 1)))
	
	; Teleport
	(object_teleport_to_ai_point (player0) pts_teleport/starport)
			
	(cinematic_fade_to_gameplay)
	(sleep 1)
 	(wake f_starport_fx_ambient)
 	(fade_in 0 0 0 0)
)



; =================================================================================================
; RIDE TEST SCRIPTS
; =================================================================================================
;*
(script static void ins_ride_test
	(if debug (print "::: insertion point: ride"))
	(set s_active_insertion_index s_index_ride)

	(insertion_snap_to_black)

	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)))
	
	; Teleport
	(object_teleport_to_ai_point (player0) pts_teleport/ride)

	(insertion_fade_to_gameplay)

	(sleep 1)
	(jp)

	(set b_jetpack_complete true)
	;(ride_test)
)

(script static void ride_test

			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)
	
	; Teleport
	(object_teleport_to_ai_point (player0) pts_teleport/ride)
		
	(cinematic_fade_to_gameplay)
	(sleep 1)

	(ai_place ride_falcon)

	(set v_ride_falcon (ai_vehicle_get ride_falcon/pilot))
	(ai_cannot_die ride_falcon true)
	;(ai_teleport ride_falcon falcon_enter/land)
	(sleep 90)

	(ai_place ride_falcon0)
	(set v_ride_falcon0 (ai_vehicle_get ride_falcon0/pilot))
	(ai_cannot_die ride_falcon0 true)
	;(ai_teleport ride_falcon0 falcon0_enter/land)

	(sleep 1)
	
	(sleep_until 
		(and
			b_ride_falcon_landed
			b_ride_falcon0_landed
		)	5)
		
	(vehicle_load_magic (ai_vehicle_get ride_falcon/pilot) "falcon_p_r2" (player0))	
	(sleep 1)
	(unit_lower_weapon (player0) 15)
	
	(sleep (* 30 2))
	(cs_run_command_script ride_falcon/pilot cs_ride_vehicle_route)
	(sleep (* 30 3))
	(cs_run_command_script ride_falcon0/pilot cs_ride_vehicle0_route)
	
	(wake ride_progression)


)

*;



;==============SPECIAL ELITE=====================;
; s_special_elite1 - ready
; s_special_elite2 - jetpack high
; s_special_elite3 - starport
;================================================;

(global short s_special_elite 0)
(global boolean b_special false)
(global boolean b_special_win false)
(global short s_special_elite_ticks 600)

(script dormant special_elite
	(if (= s_special_elite 0)
		(begin_random_count 1
			(set s_special_elite 1)
			(set s_special_elite 2)    
			(set s_special_elite 3)                                    
		)
	)
	
	(sleep_until (> (ai_living_count gr_special_elite) 0)1)
	
	(sleep_until 
		(and
			(< (ai_living_count gr_special_elite) 1)
			(= b_special_win true)
		)
	1)
	
	(set b_special true)
	
	(submit_incident "kill_elite_bob")
	(print "SPECIAL WIN!")
)

(script command_script cs_special_elite1
	(set b_special_win true)
	(print "SPECIAL START")
	
	;Scale up
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	                
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_vehicle_boost TRUE)
	;(cs_ignore_obstacles TRUE)
	
	(cs_fly_by pts_bob/ready_enter 10)
	(cs_fly_by pts_bob/ready_dive 10)
	(cs_fly_by pts_bob/ready_turn) 
	(cs_fly_by pts_bob/ready_exit)
;*        
	(print "SPECIAL ELITE SPOTTED")                               
	(sleep s_special_elite_ticks)
	(ai_set_active_camo ai_current_actor true)
	(sleep 30)
*;
	(cs_fly_by pts_bob/ready_remove)

	;Scale down
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
	(sleep (* 30 2.5))	
	;(ai_erase ai_current_squad)

	(set b_special_win false)
	(print "SPECIAL FAIL")
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script command_script cs_special_elite2
	(set b_special_win true)
	(print "SPECIAL START")
	
	;Scale up
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	                
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_vehicle_boost TRUE)
	;(cs_ignore_obstacles TRUE)
	
	(cs_fly_by pts_bob/jetpack_enter 10)
	(cs_fly_by pts_bob/jetpack_dive 10)
	(cs_fly_by pts_bob/jetpack_turn)  
	(cs_fly_by pts_bob/jetpack_exit)
;*        
	(print "SPECIAL ELITE SPOTTED")                               
	(sleep s_special_elite_ticks)
	(ai_set_active_camo ai_current_actor true)
	(sleep 30)
*;
	(cs_fly_by pts_bob/jetpack_remove)

	;Scale down
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
	(sleep (* 30 2.5))	
	;(ai_erase ai_current_squad)

	(set b_special_win false)
	(print "SPECIAL FAIL")
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script command_script cs_special_elite3
	(set b_special_win true)
	(print "SPECIAL START")
	
	;Scale up
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	                
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_vehicle_boost TRUE)
	(cs_shoot TRUE)
	;(cs_ignore_obstacles TRUE)
	
	(cs_fly_by pts_bob/starport_enter 10)
	(cs_fly_by pts_bob/starport_dive 10)
	(cs_fly_by pts_bob/starport_turn)
	(cs_fly_by pts_bob/starport_exit)
;*        
	(print "SPECIAL ELITE SPOTTED")                               
	(sleep s_special_elite_ticks)
	(ai_set_active_camo ai_current_actor true)
	(sleep 30)
*;
	(cs_fly_by pts_bob/starport_remove)

	;Scale down
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
	(sleep (* 30 2.5))	
	;(ai_erase ai_current_squad)

	(set b_special_win false)
	(print "SPECIAL FAIL")
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script dormant starport_bob
	(sleep_until (volume_test_players tv_starport_bridge) 5)
	(if (= s_special_elite 3)
		(begin
			(ai_place special_elite3)
			(sleep 1)
			(ai_disregard (ai_actors special_elite3) TRUE)
		)
	)
)
; =================================================================================================
; track music memory
; =================================================================================================


(script dormant music_memory_test
                (sound_looping_stop levels\solo\m50\music\m50_music_01)
                (sound_looping_stop levels\solo\m50\music\m50_music_02)
                (sound_looping_stop levels\solo\m50\music\m50_music_03)
                (sound_looping_stop levels\solo\m50\music\m50_music_04)
                (sound_looping_stop levels\solo\m50\music\m50_music_05)
                (sound_looping_stop levels\solo\m50\music\m50_music_06)
                (sound_looping_stop levels\solo\m50\music\m50_music_07)
                (sound_looping_stop levels\solo\m50\music\m50_music_08)
                (sound_looping_stop levels\solo\m50\music\m50_music_09)
                (sound_looping_stop levels\solo\m50\music\m50_music_10)
                (sound_looping_stop levels\solo\m50\music\m50_music_11)
                (sound_looping_stop levels\solo\m50\music\m50_music_12)
                (sound_looping_stop levels\solo\m50\music\m50_music_13)                
)

; =================================================================================================

