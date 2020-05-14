; =================================================================================================
; M10 RAIN
; =================================================================================================
(script dormant rain_start
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(print "rain_start")
	(weather_animate_force light_rain_far 1 0)
	
	(sleep_until (>= g_1stbowl_obj_control 20))
	(sleep_until (not (any_players_in_vehicle)))
	(weather_animate_force light_rain 1 5)
	
	;*
	(sleep_until (volume_test_players tv_1stbowl_cliffside))
	(weather_animate_force off 1 6)
	
	(sleep_until (volume_test_players tv_first_bowl_end))
	(weather_animate_force light_rain 1 5)
	*;
	
	(sleep_until (volume_test_players vol_barn_start))
	(wake rain_barn_start)

)

(script dormant rain_barn_start
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(weather_animate_force heavy_rain 1 5)
	(print "rain_barn_start")
	(if (game_is_cooperative)
		(begin
			(sleep_until (volume_test_players tv_barn_bloodtrail02))
			(weather_animate_force off 1 3)
		)
	)
	(sleep_until (volume_test_players tv_weather03))
	(sleep (random_range 100 200))
	(wake rain_3kiva_start)
	
)

(script dormant rain_3kiva_start
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(branch
		3kiva_troopers_spoted
		(branch_kill)
	)
	
	(print "rain_3kiva_start")
	(sleep_until
		(begin
			(weather_animate_force light_rain 1 (random_range 5 15))
			(sleep 
				(random_range 
					(* 30 20) 
					(* 30 30)
				)
			)
			
			(weather_animate_force heavy_rain 1 (random_range 5 15))
			(sleep 
				(random_range 
					(* 30 5) 
					(* 30 25)
				)
			)
			
			(weather_animate_force light_rain 1 (random_range 5 15))
			(sleep 
				(random_range 
					(* 30 15) 
					(* 30 20)
				)
			)
			
			(weather_animate_force off 1 (random_range 5 15))
			(sleep 
				(random_range 
					(* 30 15) 
					(* 30 30)
				)
			)
			
			FALSE
		)
	)
)

(script dormant rain_3kiva_defend_start
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(branch
		(>= g_3kiva_obj_control 10)
		(branch_kill)
	)
	
	(print "rain_3kiva_defend_start")
	(sleep 
		(random_range 
			(* 30 5) 
			(* 30 25)
		)
	)
	(weather_animate_force light_rain 1 (random_range 5 15))
	
)

(script dormant rain_3kiva_evac_start
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(print "rain_3kiva_evac_start")
	(weather_animate_force light_rain_far 1 0)
	
)

(script dormant rain_outpost_start
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(print "rain_3kiva_evac_start")

	(weather_animate_force light_rain 1 (random_range 5 15))
	
	(sleep 
		(random_range 
			(* 30 20) 
			(* 30 30)
		)
	)
	(weather_animate_force heavy_rain 1 (random_range 5 15))
	
	(sleep_until (>= g_outpost_int_obj_control 10))
	(weather_animate_force off 1 5)
	
)


; ===================================================================================================================================================
; ===================================================================================================================================================
; DIALOG scripts
; ===================================================================================================================================================
; ================================================================================================================================================

(script dormant md_1stbowl_hover
	(sleep 44)
	(set g_1stbowl_obj_control 5)
	
	(sleep 40)
	(print "CARTER: Shoot-down attempts are likely, so keep your distance.")
	(f_md_ai_play 20 (object_get_ai obj_carter) m10_0080)
	(print "PILOT2: Yes sir!")
	(f_md_object_play 40 NONE m10_1890)
	(set g_music01 TRUE)
	(print "CARTER: Let’s stay focused.  Watch your sectors...")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_0420)

	
	(sleep_until (>= (device_get_position dm_falcon01_start) .22) 1)
	(chud_cinematic_fade 1 30)
	(player_camera_control TRUE)
	(player_enable_input TRUE)
	
	(wake hud_outpost_start)
	;(sleep 30)
	(player_control_unlock_gaze player0)
	(if (not (game_is_cooperative))
		(wake training_look_start)
	)
	
	(print "JORGE: There’s the communications outpost.")
	(f_md_ai_play 0 (object_get_ai obj_jorge) m10_0010)
	;(print "CARTER: We can see the relay outpost from here...  Sight-lines are tight.  Tailor-made for an ambush --")
	;(f_md_object_play 10 NONE m10_0840)

	(print "KAT: Reading a distress beacon.")
	(f_md_ai_play 0 (object_get_ai obj_kat) m10_0020)
	(wake hud_beacon_start)
	
	(sleep_until b_training_look_done 5 200)
	(sleep 90)
	(chud_track_object sc_beacon_nav02 FALSE)
	(sleep 40)
	(hud_unblip_all)
	
	(set g_1stbowl_obj_control 7)
	(print "CARTER: Could be the missing troopers.  Let's check it out.")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_0030)
	
	(sleep 20)
	(set g_ui_obj_control 5)
	(sleep 70)
	
	(print "CARTER: Put us down on the bluff.")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_0040)
	
	(sleep 220)
	(set g_1stbowl_obj_control 8)
	(sleep 50)
	(print "CARTER: Jun, I want your eyes in the sky.")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_0050)
	(print "JUN: Sir.")
	(f_md_ai_play 0 (object_get_ai obj_jun) m10_0060)
	
)

(script dormant md_1stbowl_unload
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "CARTER: Let's go, Six.")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_0070)
	
	;(sleep 60)
	;(wake md_1stbowl_orders)
)


; dialog 1stbowl ==============================================================================================================================================================================

(script dormant md_1stbowl_orders
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Alright, Noble Team, spread out. Watch the approach.")
	(f_md_ai_play 0 group_carter m10_0100)
	
	(ai_dialogue_enable TRUE)

	(wake md_1stbowl_beacon_south)
)


(script dormant md_1stbowl_rock_look
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: Emile, high left and scout.")
	(f_md_ai_play 0 group_carter m10_0110)
	(print "EMILE: Roger.")
	(f_md_ai_play 0 group_emile m10_0120)
)

(script dormant md_1stbowl_beacon_south
	(sleep_until (volume_test_players tv_1stbowl_adv04))
	(sleep_until (not b_is_dialogue_playing))
	
	(print "KAT: Distress beacon's coming from just south of here, boss.  We're close.")
	(f_md_ai_play 0 group_kat m10_0140)
	
	(wake hud_beacon02_start)
	
	(sleep 20)
	(sleep_until (not b_is_dialogue_playing) 5)
	(print "CARTER: Roger that. Eyes peeled.")
	(f_md_ai_play 0 group_carter m10_0150)
	
)

(script dormant md_1stbowl_rock_look02
	
	(sleep_until (object_running_sync_action (ai_get_object group_emile) "spartan_rock_climb") 1)
	(sleep 150)
	(sleep_until (not b_is_dialogue_playing) 5)
	(print "EMILE: Structure point three-four.  Looks clear from this angle.")
	(f_md_ai_play 0 group_emile m10_0130)

)

(script dormant md_1stbowl_blood
	(sleep_until (not b_is_dialogue_playing))
	(sleep 20)
	(print "EMILE: Blood on the ground. A lot.")
	(f_md_ai_play 0 group_emile m10_0200)
)

(script dormant md_1stbowl_beacon_found
	(branch                                
		warthog_done
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	;(sleep 120)
	(sleep_until (object_running_sync_action (ai_get_object group_kat) "spartan_inspect_debris") 1 (* 30 9))
	(if (not (object_running_sync_action (ai_get_object group_kat) "spartan_inspect_debris"))
		(print "vig_beacon: failsafe")
	)
	(sleep_until (not b_is_dialogue_playing) 1)
	(print "beacon sync action")
	
	(sleep 190)
	(print "EMILE: Found the beacon.")
	(f_md_ai_play 0 group_emile m10_0160)
	
	(set g_music02 TRUE)
	
	(sleep 40)
	(print "CARTER: Make out any ID?")
	
	(sleep 45)
	(f_md_ai_play 0 group_carter m10_0170)
	(print "KAT: Negative.  But it's military.")
	(f_md_ai_play 20 group_kat m10_0180)
	(print "JORGE: So where are the troopers?")
	(f_md_object_play 0 NONE m10_0190)
	
	(set beacon_done TRUE)

)

;*
(script dormant md_1stbowl_tac_eval
	(branch                                
		warthog_done
		;(volume_test_players tv_1stbowl_witnesses)
		(f_md_abort_no_combat_dialog)
	)
	
	(sleep_until (not b_is_dialogue_playing))

	(print "CARTER: Kat.  Tac eval.")
	(f_md_ai_play 20 group_carter m10_0210)
	(print "KAT: Scent still fresh; untrained civvies with small arms --")
	(f_md_ai_play 0 group_kat m10_0220)
	(print "CARTER: You thinking bait-and-switch?")
	(f_md_ai_play 20 group_carter m10_0230)
	;(print "KAT: Aren't you?")
	;(f_md_ai_play 0 group_kat m10_0240)
	
	(sleep (random_range 30 50))
	(wake md_1stbowl_move_on)
	
)
*;

(script dormant md_1stbowl_ex_residue
	(branch
		warthog_done                      
		;(volume_test_players tv_1stbowl_witnesses)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	
	(sleep_until (not b_is_dialogue_playing))
	
	(ai_dialogue_enable FALSE)
	
	;(print "CARTER: Kat.  Tac eval.")
	;(f_md_ai_play 20 group_carter m10_0210)
	(print "KAT: Why are we not seeing explosives residue?")
	(f_md_ai_play 0 group_kat m10_0360)
	(print "CARTER: Noble Three, can you confirm any EX residue in the area?")
	(f_md_ai_play 0 group_carter m10_0370)
	(print "JUN: Mm... Negative, Commander.")
	(f_md_object_play 20 NONE m10_0380)
	;(print "CARTER: Copy.")
	;(f_md_ai_play 0 group_carter m10_0390)
	(print "EMILE: Plasma, maybe?")
	(f_md_ai_play 0 group_emile m10_0400)
	(print "JORGE: Can’t be.  Not on Reach --")
	(f_md_object_play_cutoff 12 NONE m10_0410)
	;(f_md_ai_play_cutoff 20 group_jorge m10_0410)
	;(print "CARTER: Let’s stay focused.  Watch your sectors...")
	;(f_md_ai_play 0 group_carter m10_0420)
	
	(ai_dialogue_enable TRUE)
	
	(sleep (random_range 30 50))
	(wake md_1stbowl_move_on)

)

(script dormant md_1stbowl_move_on
	(sleep_until (not b_is_dialogue_playing))
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: All right, Noble, looks like there’s nothing here.  Let’s move on.")
	(f_md_ai_play 0 group_carter m10_0250)
	
	(ai_dialogue_enable TRUE)
	
	(set warthog_done TRUE)
	(wake obj_locate02_start)
	(game_save)
)

(script dormant md_1stbowl_stand_down01
	(branch                                
		(= (current_zone_set) 4)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	
	(sleep_until (= (object_get_health sc_1stbowl_propane01) 0))
	(sleep_until (not b_is_dialogue_playing) 5)
	(print "CARTER: Stand down Noble Six!")
	(f_md_ai_play 0 group_carter m10_0495)
	
)

(script dormant md_1stbowl_stand_down02
	(branch                                
		(= (current_zone_set) 4)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	
	(sleep_until (not b_is_dialogue_playing) 5)
	(print "CARTER: Stand down Noble Six!")
	(f_md_ai_play 0 group_carter m10_0495)
	
)

(script dormant md_1stbowl_next_structure
	(branch                                
		(volume_test_players tv_1stbowl_witnesses)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	(sleep_until warthog_done)
	(sleep_until (not b_is_dialogue_playing))
	
	; music change in case player didn't watch beacon moment
	(set g_music02 TRUE)
	
	(ai_dialogue_enable FALSE)

	(print "KAT: Smoke at the next structure, boss.")
	(f_md_ai_play 0 group_kat m10_0260)
	(print "CARTER: Circle west and check it out.  Noble Team: you have permission to engage, but be selective.  We don't need to telegraph our presence.")
	(f_md_ai_play 0 group_carter m10_0270)
	
	(ai_dialogue_enable TRUE)
	
	;*
	(if (not (volume_test_players vol_1stbowl_kiva01))
		(begin
			(print "JORGE: Nor shoot innocent civilians.")
			(f_md_object_play 10 NONE m10_0410)
			(print "EMILE: I do hate paperwork.")
			(f_md_ai_play 0 group_emile m10_0290)
		)
	)
	*;
	
	;(wake md_1stbowl_ex_residue)
	;(wake md_1stbowl_tac_eval)
)

(script dormant md_1stbowl_house
	(branch                                
		(volume_test_players tv_1stbowl_witnesses)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	
	(sleep_until (volume_test_players vol_1stbowl_kiva01))
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: Noble Six, move into the house.  Go in quiet.  I'm right behind you.")
	(f_md_ai_play 0 group_carter m10_1670)
	
)


(script dormant md_1stbowl_tossed
	(branch                                
		(volume_test_players tv_1stbowl_witnesses)
		(f_md_abort_no_combat_dialog)
	)
	
	(sleep_until (not b_is_dialogue_playing))
	
	(print "JORGE: Place was tossed.")
	(f_md_ai_play 10 group_jorge m10_0330)
	(print "EMILE: Looking for what?  Weapons?")
	(f_md_ai_play 10 group_emile m10_0340)
	(print "KAT: Whatever it was, I don't think they found it...")
	(f_md_ai_play 0 group_carter m10_0350)
)

(script dormant md_1stbowl_civ_heat
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "JUN: Noble Leader, I’m seeing heat sigs in the structure ahead.")
	(f_md_object_play 0 NONE m10_0430)
	;*
	(print "KAT: We've got movement on the other side of that door.")
	(f_md_ai_play 0 group_kat m10_0440)
	(print "JORGE: Livestock?")
	(f_md_ai_play 0 group_jorge m10_0450)
	(print "KAT: Not a chance.")
	(f_md_ai_play 0 group_kat m10_0460)
	*;
	;(print "CARTER: Six, lose that lock.")
	;(f_md_ai_play 0 group_carter m10_0470)
)

(script dormant md_1stbowl_witnesses
	(branch
		(>= g_1stbowl_obj_control 30)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	;(sleep_until (not b_is_dialogue_playing) 1)
	;(sleep_until (volume_test_players tv_1stbowl_witnesses02) 1)
	
	(sleep_until (object_running_sync_action (ai_get_object 1stbowl_witnesses_dad) "witnesses_enter") 1)
	
	(ai_dialogue_enable FALSE)
	
	(sleep 70)
	(print "CIVILIAN 2: Hungarian: We've done nothing")
	(f_md_ai_play_cutoff 20 1stbowl_witnesses_family/son m10_0500)
	(print "EMILE: Move! On your knees!  NOW!")
	(f_md_ai_play_cutoff 10 group_emile m10_0490)
	(print "CIVILIAN 1: Hungarian: Please. Do not Shoot!")
	(f_md_ai_play_cutoff 50 1stbowl_witnesses_dad m10_0510)
	
	(print "JORGE: They're not rebels!")
	(f_md_ai_play 0 group_jorge m10_0520)
	(print "JORGE: They're farmers.  Look at them.")
	(f_md_ai_play 0 group_jorge m10_0530)
	(print "CARTER: Ask them what they're doing here.")
	(f_md_ai_play 0 group_carter m10_0540)
	(print "JORGE: Hungarian: What are you doing here?")
	(f_md_ai_play 0 group_jorge m10_0550)
	
	(print "CIVILIAN 1: Hungarian: We hide in here")
	(f_md_ai_play_cutoff 5 1stbowl_witnesses_dad m10_0560)
	(print "JORGE: Hiding, sir.")
	(f_md_ai_play 0 group_jorge m10_0570)
	
	(sleep_until (object_running_sync_action (ai_get_object 1stbowl_witnesses_dad) "witnesses_dialogue") 1)
	(print "CIVILIAN 1: Hungarian: In the night, my neighbor, his family… Screams, gunfire… Then, before sunrise, nothing.")
	(f_md_ai_play_cutoff 100 1stbowl_witnesses_dad m10_0580)
	(print "JORGE: Neighbors were attacked last night… He heard screams, gunfire… Stopped around sunrise…")
	(f_md_ai_play_cutoff 80 group_jorge m10_0590)
	
	(print "CIVILIAN 1: Hungarian: Something kill my son")
	(f_md_ai_play 0 1stbowl_witnesses_dad m10_0600)
	
	(sleep 20)
	(print "JORGE: Says something in the fields killed his son.")
	(f_md_ai_play 0 group_jorge m10_0610)
	(print "CARTER: Something?")
	(f_md_ai_play 0 group_carter m10_0620)
	(set g_1stbowl_obj_control 25)
	
	(ai_dialogue_enable TRUE)

)

(script dormant md_1stbowl_sprint
	(sleep_until (>= g_1stbowl_obj_control 25) 1)
	(sleep_until (not b_is_dialogue_playing) 1)
	
	(ai_dialogue_enable FALSE)
	
	(print "JUN: Commander, be advised I'm reading heat signatures in that structure directly east of your position, over.")
	(f_md_object_play 10 NONE m10_0630)
	
	(if (= g_1stbowl_obj_control 25)
		(begin
			(print "CARTER: Copy That. Get them back inside!")
			(f_md_ai_play 20 group_carter m10_0640)
			(set g_1stbowl_obj_control 30)
			
			(print "JORGE: Hungarian: I said back inside! Go!")
			(f_md_ai_play 0 group_jorge m10_0650)
		)
	)
	
	(sleep_until (volume_test_players tv_training_sprint) 5)
	(print "CARTER: Noble Team, double-time it!")
	(f_md_ai_play 0 group_carter m10_0660)
	
	(ai_dialogue_enable TRUE)
	
	(set g_music03 TRUE)
	(wake ct_training_sprint_start)
)


(script dormant md_barn_entry
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: Six, you're with me.  Everyone else, fan out and check the perimeter.")
	(f_md_ai_play 0 group_carter m10_0760)
)


(script dormant md_barn_dead_troopers
	(branch
		(volume_test_players tv_barn01_end)
		(kill_md_barn_dead_troopers)
	)
	(sleep_until (not b_is_dialogue_playing))
	(sleep_until (volume_test_object tv_barn_bodies obj_carter) 5)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Damn.")
	(f_md_ai_play 20 group_carter m10_0800)
	
	(set g_music01 TRUE)
	
	(print "JUN: Fill me in, Noble.  What are you seeing, over?")
	(f_md_object_play 10 NONE m10_0810)
	(print "CARTER: We've got military casualties.  Two of our missing troopers.")
	(f_md_ai_play 50 group_carter m10_0820)
	(print "CARTER: Looks like they were interrogated.. it’s messy")
	(f_md_ai_play 0 group_carter m10_0830)
	
	(ai_dialogue_enable TRUE)
	
	(set g_music02 TRUE)

)

(script static void kill_md_barn_dead_troopers
	(set g_music01 TRUE)
	(set g_music02 TRUE)
	;(f_md_abort_no_combat_dialog)
	(f_md_abort)
)

(script dormant md_motion_tracker
	(branch
		(volume_test_players tv_barn_main)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	
	(sleep 45)
	
	; set this in case player bypassed last vignette
	(set g_music02 TRUE)
	
	(sleep_until (not b_is_dialogue_playing) 1)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Movement. Watch your motion tracker people.")
	(f_md_ai_play 0 group_carter m10_0710)
	(training_motion_tracker)
	(sleep 50)
	
	(print "EMILE: The hell was that?")
	(f_md_ai_play 10 group_emile m10_0700)
	(print "CARTER: Jun, you see anything?")
	(f_md_ai_play 30 group_carter m10_0730)
	(print "JUN: Negative. Thermal's clean.")
	(f_md_object_play 0 NONE m10_0740)
	
	(ai_dialogue_enable TRUE)
	
	(set g_music03 TRUE)
	
	(sleep 30)
	
	
)

; dialog barn ==============================================================================================================================================================================
(script dormant md_barn_window
	(sleep_until (volume_test_players tv_barn_bloodtrail03) 5)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	; set this in case player bypassed last vignette
	(set g_music03 TRUE)
	
	(ai_dialogue_enable FALSE)
	
	(print "JUN: Boss, I see movement! Outside your structure!")
	(f_md_object_play 10 NONE m10_0850)
	(print "CARTER: Noble Two, move up to the west!  We're about to be flanked!")
	(f_md_ai_play 0 group_carter m10_0860)
	
	(ai_dialogue_enable TRUE)

)

(script static void test
	
	
	(sleep 60)
	

)

(script dormant md_barn_contact
	(sleep_until (not b_is_dialogue_playing))
	
	(ai_dialogue_enable FALSE)
	
	(print "jorge: Huh")
	(f_md_ai_play_cutoff 3 group_jorge m10_0863)
	(print "jorge: Dammit")
	(f_md_ai_play 0 group_emile m10_0866)
	(print "jorge: Covenant!")
	(f_md_ai_play 10 group_jorge m10_0869)
	(print "CARTER: Contact!  Contact!")
	(f_md_ai_play 0 group_carter m10_0870)
	(print "CARTER: Spartans!  Assist!")
	(f_md_ai_play 10 group_carter m10_0890)
	(print "jorge: Here we go")
	(f_md_ai_play 0 group_jorge m10_0880)
	
	(ai_dialogue_enable TRUE)
	
	;(print "CARTER: Noble Two, move up to the west!  We're about to be flanked!")
	;(f_md_ai_play 0 group_carter m10_0860)
	(set g_music04 TRUE)
	(sleep 20)
	(set g_ui_obj_control 10)
	;*
	(print "PILOT 1: Falcon moving to assist!")
	(f_md_object_play 10 NONE m10_1140)
	*;
	
	(sleep 70)
	;(wake md_barn_skirm_basement)
	(print "CARTER: They're headed into the basement!  Let's move down to the lower level!")
	(f_md_ai_play 0 group_carter m10_0910)
)

;*
(script dormant md_barn_skirm_basement
	;(sleep_until (volume_test_players tv_barn_combat02) 5 200)
	(sleep_until (not b_is_dialogue_playing))

	(print "CARTER: They're headed into the basement!  Let's move down to the lower level!")
	(f_md_ai_play 0 group_carter m10_0910)
	;(set g_music02 TRUE)
)
*;

(script dormant md_barn_skirm_grenades
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: They're in the back pen!  Noble Six, flush 'em out with grenades!")
	;(md_play 0 sound\dialog\levels\m10\mission\robot\m10_0820_car)
)

(script dormant md_meadow_dropship
	;(sleep_until (volume_test_players tv_meadow_adv01) 5 200)
	(sleep_until (not b_is_dialogue_playing))
	
	(print "JUN: Noble Leader!  Enemy dropships inbound!")
	(f_md_object_play 0 NONE m10_1120)
	
	(set g_music01 TRUE)
	
	(sleep 100)
	(print "PILOT 1: Falcon moving to assist!")
	(f_md_object_play 10 NONE m10_1140)
	
)

(script dormant md_meadow_banshees
	(sleep_until (>= (ai_living_count meadow_banshees) 1) 5)
	(sleep 50)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "Pilot 2: Banshees! Heads up, Charlie One!")
	(f_md_object_play 15 NONE m10_1150)
	(print "JUN: Get some altitude! Now!")
	(f_md_ai_play 0 group_jun m10_1160)

)

(script dormant md_meadow02
	(branch
		(volume_test_players tv_3kiva_start03)
		;(f_md_abort_no_combat_dialog)
		(f_md_abort)
	)
	
	(sleep_until (not b_is_dialogue_playing))
	(if (volume_test_players vol_meadow_halfway)
		(sleep_until 
			(and
				(<= (ai_task_count obj_meadow_cov/meadow_elite) 0)
				(<= (ai_task_count obj_meadow_cov/gate_meadow_back) 0)
			)
		)
	)
	
	(game_save)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Stand down, Noble, stand down!  Contacts neutralized!")
	(f_md_ai_play 20 group_carter m10_1020)
	(print "JORGE: Contacts?  It's the damn COVENANT!")
	(f_md_ai_play 15 group_jorge m10_1030)
	
	(print "EMILE: Cheer up, big man.  This whole valley just turned into a free-fire zone.")
	(f_md_ai_play 35 group_emile m10_1090)
	
	(print "CARTER: Kat, we gotta warn Holland.  I need you at that relay outpost now!")
	(f_md_ai_play 20 group_carter m10_1040)
	
	(if (not (volume_test_players vol_meadow_exit))
		(begin
			(print "JUN: Boss, I'm showing more activity to the east…")
			(f_md_object_play 20 NONE m10_1490)
			(print "CARTER: Copy that, Jun.  We're on it.  Six, you've got point.")
			(f_md_ai_play 0 group_carter m10_1110)
		)
	)
	
	(ai_dialogue_enable TRUE)
	
)

(script dormant md_meadow_evac_request
	(sleep_until (not b_is_dialogue_playing))
	
	(ai_dialogue_enable FALSE)
	
	;(print "CARTER: Kat, we gotta warn Holland.  I need you at that relay outpost now!")
	;(f_md_ai_play 20 group_carter m10_1040)
	(print "KAT: Noble Three, requesting airlift, over!")
	(f_md_ai_play 20 group_kat m10_1050)
	(print "JUN: Falcon en route.  Stand by!")
	(f_md_object_play 20 NONE m10_1060)
	
	(ai_dialogue_enable TRUE)
	
	;(f_blip_object (ai_vehicle_get_from_squad meadow_falcon 0) blip_interface)
	
)



(script dormant md_3kiva_jun_evac
	(branch
		(>= g_3kiva_obj_control 10)
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: Six, Jun! Let's go!")
	(f_md_ai_play 0 group_carter m10_2120)
	
	(sleep 400)
	(print "CARTER: On the Falcon, Six! Now!")
	(f_md_ai_play 0 group_carter m10_2130)
	
	(sleep 600)
	(print "CARTER: Lieutenant, mount up. That's an order!")
	(f_md_ai_play 0 group_carter m10_2140)

)


; dialog Troopers ==============================================================================================================================================================================

(script dormant md_3kiva_start
	(sleep_until
		(or
			(<= (ai_living_count obj_meadow_cov) 0)
			(volume_test_players tv_3kiva_start02)
		)
	)
	(sleep 90)
	(ai_dialogue_enable FALSE)
	(sleep_until (not b_is_dialogue_playing))
	
	(print "JUN: Commander, I'm seeing more hostile activity to the northeast.")
	(f_md_object_play 0 NONE m10_1100)
	
	(sleep 50)
	(print "CARTER: Jorge, Emile: You're with Kat.  Six and I will run interference on the ground; we'll meet you at the outpost.")
	(f_md_ai_play 30 group_carter m10_1070)
	
	(print "KAT: Noble Three, requesting airlift, over!")
	(f_md_ai_play 20 group_kat m10_1050)
	
	(set g_music02 TRUE)
	(set g_ui_obj_control 20)
	(sleep 50)
	
	(print "CARTER: Get to work Noble. The war just came to Reach.")
	(f_md_ai_play 0 group_carter m10_1220)
	
	; music
	(set g_music_ins TRUE)
	
	(ai_dialogue_enable TRUE)
	(wake md_3kiva_start_prompt)
	
)

(script dormant md_3kiva_start_prompt
	(branch
		(or
			(volume_test_players tv_3kiva_start02)
			(>= (current_zone_set) 5)
		)
		(f_md_abort)
	)
	
	(sleep 400)
	(print "CARTER: Noble Six, on me.")
	(f_md_ai_play 0 group_carter m10_0770)
	
	(sleep 600)
	(print "CARTER: Lieutenant!  You're with me!")
	(f_md_ai_play 0 group_carter m10_0780)
	
)

(script dormant md_3kiva01_heat
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "JUN: Noble Leader, I’m seeing heat sigs in the structure ahead.")
	(f_md_object_play 0 NONE m10_0430)
	
	(set g_music01 TRUE)
)

(script dormant md_3kiva_waypoint_kiva01
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "JUN: Boss, I'm showing more activity to the east…")
	(f_md_object_play 40 NONE m10_1490)
)

(script dormant md_3kiva_waypoint_kiva02
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "JUN: Boss, I'm showing more activity to the east…")
	(f_md_object_play 40 NONE m10_1490)
)

(script dormant md_3kiva_waypoint_kiva03
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "JUN: Boss, I'm showing more activity to the east…")
	(f_md_object_play 40 NONE m10_1490)
)

(script dormant md_3kiva_kiva01_done
	(branch
		3kiva_troopers_spoted
		(f_md_abort)
	)
	
	(ai_dialogue_enable FALSE)
	(sleep 100)
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: Looks like we're clear, Lieutenant.")
	(f_md_ai_play 90 group_carter m10_1460)
	
	(ai_dialogue_enable TRUE)
	
	(sleep 100)
	(sleep_until (not (volume_test_players tv_kiva01_center)) 30 (* 30 500))
	(wake md_3kiva_kiva01_more)
	
)

(script dormant md_3kiva_kiva01_more
	(branch
		3kiva_troopers_spoted
		(f_md_abort)
	)
	(ai_dialogue_enable FALSE)

	(print "JUN: Boss, I'm showing more activity to the east…")
	(f_md_object_play 40 NONE m10_1490)
	(print "JUN: ...Advise you check it out.")
	(f_md_object_play 20 NONE m10_1510)
	
	(print "CARTER: Roger, Three.  We're en route.")
	(f_md_ai_play 0 group_carter m10_1350)
	
	(ai_dialogue_enable TRUE)
	
)

(script dormant md_3kiva_blip
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "JUN: Boss, I'm showing more activity to the south…")
	(f_md_object_play 40 NONE m10_1480)

)


(script dormant md_3kiva_trooper_distress_start
	(branch 
		(or                              
			(and (= 3kiva_troopers_bsp 2) (volume_test_players vol_3kiva_2bsp))
			(and (= 3kiva_troopers_bsp 3) (volume_test_players vol_3kiva_3bsp))
		)
		(f_md_abort)
	)

	;sleep until player finishes an objective
	(sleep_until 
		(or
			;3kiva01_done
			3kiva02_done
			3kiva03_done
		)
	30)
	(sleep 100)
	
	(sleep_until 
		(and
			(not (volume_test_players_all vol_3kiva02_approach03))
			(not (volume_test_players_all vol_3kiva03_approach03))
		)
	30)
	
	(sleep_until (not b_is_dialogue_playing) 5)
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Looks like we're clear, Lieutenant.")
	(f_md_ai_play 180 group_carter m10_1460)
	
	
	(print "JUN: Boss, we're picking up a distress signal.")
	(f_md_object_play 0 NONE m10_1250)
	(sleep 20)
	
	(print "TROOPER5: Mayday, Three Charlie Six… Does anyone read?")
	(f_md_object_play (random_range 10 40) NONE m10_2630)
	(print "TROOPER5: I Repeat, we have multiple wounded and need immediate assistance.")
	(f_md_object_play (random_range 10 40) NONE m10_2640)
	(print "TROOPER5: We were attacked by Covenant forces; the Covenant is on Reach -- I repeat, the Covenant is on Reach.")
	(f_md_object_play (random_range 10 40) NONE m10_2650)
	(print "TROOPER5: If anyone is picking this up, please respond.")
	(f_md_object_play (random_range 10 40) NONE m10_2660)
	
	(print "JORGE: The troopers?")
	(f_md_ai_play 20 group_jorge m10_1260)
	
	(print "CARTER: Let's move, Six.  We gotta find the source of that distress call.")
	(f_md_ai_play 180 group_carter m10_1530)
	(set g_ui_obj_control 30)
	
	(print "JUN: No disrespect, but don't we have more important things to do than round up strays?")
	(f_md_object_play 10 NONE m10_1380)
	(print "CARTER: We don't leave people behind.  You see those troopers, you let me know.")
	(f_md_ai_play 0 group_carter m10_1390)
	
	
	(ai_dialogue_enable TRUE)
	
)


(script dormant md_trooper_distress_attack
	(branch                                
		3kiva_troopers_spoted
		(f_md_abort)
	)
	(sleep_until (>= 3kiva_troopers_bsp 2))
	
	;sleep until player finishes an objective
	(sleep_until 
		(or
			3kiva02_done
			3kiva03_done
			(player_in_trooper_bsp)
		)
	5)
	
	(if
		(or
			3kiva02_done
			3kiva03_done
		)
		(sleep 100)
	)
	(sleep_until (not b_is_dialogue_playing) 5)
	(ai_dialogue_enable FALSE)
	
	(print "JUN: Boss, we're picking up a distress signal.")
	(f_md_object_play 0 NONE m10_1250)
	(sleep 20)

	;(print "TROOPER5: We're under attack!")
	;(f_md_object_play 30 NONE m10_2750)
	(print "TROOPER5: Mayday, Three Charlie Six… Does anyone read?")
	(f_md_object_play 10 NONE m10_2630)
	(print "TROOPER5: We were attacked by Covenant forces; the Covenant is on Reach -- I repeat, the Covenant is on Reach.")
	(f_md_object_play 10 NONE m10_2650)
	;(print "TROOPER5: I Repeat: Mayday, mayday!  Three Charlie Six!  We are under attack by the Covenant!")
	;(f_md_object_play 0 NONE m10_2760)
	
	(print "JORGE: The troopers?")
	(f_md_ai_play 20 group_jorge m10_1260)
	
	(print "CARTER: Let's move, Six.  We gotta find the source of that distress call.")
	(f_md_ai_play 0 group_carter m10_1530)
	
	(set g_ui_obj_control 30)
	
	(print "JUN: No disrespect, but don't we have more important things to do than round up strays?")
	(f_md_object_play 10 NONE m10_1380)
	(print "CARTER: We don't leave people behind.  You see those troopers, you let me know.")
	(f_md_ai_play 0 group_carter m10_1390)
	
	
	(wake md_3kiva_distress_response)
	
)

(script static boolean player_in_trooper_bsp
	(or
		(and (= 3kiva_troopers_bsp 2) (volume_test_players vol_3kiva_2bsp))
		(and (= 3kiva_troopers_bsp 3) (volume_test_players vol_3kiva_3bsp))
	)
)

(script dormant md_3kiva_distress_response
	(branch                                
		3kiva_troopers_spoted
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing) 5)
	(ai_dialogue_enable FALSE)
	
	(sleep 50)
	
	;(wake 3kiva_fork_hud)
	(cond
		((= 3kiva_troopers_bsp 2)
			(begin
				(print "JUN: Noble Leader, I'm seeing possible friendly forces under attack, northeast of your position, over!")
				(f_md_object_play 0 NONE m10_1760)
			)
		)
		((= 3kiva_troopers_bsp 3)
			(begin
				(print "JUN: Noble Primary, I'm seeing possible friendly forces under attack, south of your position, over!")
				(f_md_object_play 0 NONE m10_1770)
			)
		)
	)
	
	(if (not (player_in_trooper_bsp))
		(wake md_trooper_distress_attack02)
	)
	
)

(script dormant md_trooper_distress_attack02
	(branch                                
		3kiva_troopers_spoted
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing) 5)
	(ai_dialogue_enable FALSE)
	
	(print "TROOPER5: We're under attack!")
	(f_md_object_play 0 NONE m10_2750)
	(print "TROOPER5: I Repeat: Mayday, mayday!  Three Charlie Six!  We are under attack by the Covenant!")
	(f_md_object_play 0 NONE m10_2760)
	;(print "TROOPER5: I Repeat: This is Three Charlie Six!  We are under attack!")
	;(f_md_object_play (random_range 10 40) NONE m10_2800)
	;(print "TROOPER5: We are pinned down in a civilian building east of the relay outpost!")
	;(f_md_object_play (random_range 10 40) NONE m10_2770)
	(print "TROOPER5: I got wounded!  Cannot hold this position!")
	(f_md_object_play (random_range 10 40) NONE m10_2780)

	(print "CARTER: We need to find those troopers now!")
	(f_md_ai_play 0 group_carter m10_1750)
	
	(ai_dialogue_enable TRUE)
	
)

(script dormant md_3kiva_troopers_spoted
	(sleep_until 3kiva_troopers_spoted 5)
	(sleep_until (not b_is_dialogue_playing) 5)
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Noble Three, we've located the trooper squad.  Request immediate evac, my coordinates.")
	(f_md_ai_play 10 group_carter m10_1810)
	(print "JUN: Solid copy, Commander.  Recalling Falcon Charlie Two.  Hold that evac position.")
	(f_md_object_play 0 NONE m10_1820)
	
	(wake md_3kiva_troopers_evac_dropship)
	(wake md_3kiva_troopers_evac_dropship02)
	(wake md_3kiva_troopers_clear)
	
	(ai_dialogue_enable TRUE)

)

;*
(script dormant md_3kiva_troopers_meet
	;(sleep until combat status lower?
	(sleep_until (>= g_3kiva_obj_control 2) 5)
	(sleep_until (not b_is_dialogue_playing) 5)
	(ai_dialogue_enable FALSE)
	
	(print "TROOPER: Spartans...!  Corporal Travis, sir, Three Charlie!  It's the Covenant!")
	(if (>= (ai_living_count 3kiva_troopers_bsp02) 1)
		(f_md_ai_play 20 3kiva_troopers_bsp02/dmr m10_1790)
		(f_md_ai_play 20 3kiva_troopers_bsp03/dmr m10_1790)
	)
	(print "CARTER: We know, Corporal.  Let’s get you out of here.")
	(f_md_ai_play 20 group_carter m10_1800)
	
	(ai_dialogue_enable TRUE)
	
)
*;

(script dormant md_3kiva_troopers_evac_dropship
	;(sleep until combat status lower?
	(sleep_until (>= g_3kiva_obj_control 2) 5)
	(sleep_until (not b_is_dialogue_playing) 5)
	(ai_dialogue_enable FALSE)
	
	(sleep (random_range 40 70))
	
	(print "JUN: Noble Leader, be advised I have visual on inbound Covenant dropships!")
	(f_md_object_play 0 NONE m10_1830)
	(print "CARTER: Evac transport, keep your distance!")
	(f_md_ai_play 40 group_carter m10_1840)
	(print "CARTER: Six! Hold position -- clear an LZ!")
	(f_md_ai_play 0 group_carter m10_1850)
	
	(set g_music04 TRUE)
	(set g_ui_obj_control 40)
	(ai_dialogue_enable TRUE)

)

(script dormant md_3kiva_troopers_evac_dropship02
	(sleep_until (= g_3kiva_obj_control 3))
	(sleep_until (not b_is_dialogue_playing))

	(print "JUN: Be advised.. We got hostile dropship inbound!")
	(f_md_object_play 20 NONE m10_2080)

)


(script dormant md_3kiva_troopers_clear
	(sleep_until 3kiva_done)
	(sleep_until (not b_is_dialogue_playing))
	(ai_dialogue_enable FALSE)
	
	(f_hud_obj_complete)
	(print "CARTER: Transport, LZ is clear.  Move in for evac!")
	(f_md_ai_play 0 group_carter m10_1860)
	
	(set g_ui_obj_control 50)
	
	(print "JUN: Affirmative! Transport inbound!")
	(f_md_object_play 0 NONE m10_1870)
	
	(ai_dialogue_enable TRUE)
	
	(set g_music05 TRUE)

)

(script dormant md_3kiva_troopers_evac
	(branch                                
		(<= (ai_living_count group_3kiva_troopers) 0)
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: Troopers: Hop that bird, on the double!  Pilot, stay close; watch for hostile air!")
	(f_md_ai_play 0 group_carter m10_1880)

)


; dialog outpost ==============================================================================================================================================================================
(script command_script cs_spartans_talks
	(cs_custom_animation objects\characters\spartans_ai\spartans_ai.model_animation_graph "falcon_p_r1:rifle:communication" TRUE)
)


(script dormant md_outpost_sitrep02
	(sleep 90)
	(sleep_until (not b_is_dialogue_playing))

	(cs_run_command_script (object_get_ai obj_carter) cs_spartans_talks)
	(sleep 40)
	(print "CARTER: Noble Two, sitrep.")
	(f_md_ai_play 30 (object_get_ai obj_carter) m10_2210)
	(print "KAT: We're at the relay outpost.  Door's locked; mechanism's been flash-fused.")
	(f_md_object_play 10 NONE m10_1610)
	(print "CARTER: Can you beat it?")
	(f_md_ai_play 20 (object_get_ai obj_carter) m10_1620)
	;(print "KAT: Taking a little longer than I hoped, Commander; I've cut about halfway through the door.")
	;(f_md_object_play 15 NONE m10_2220)
	(print "KAT: I'll dial up my torch, cut a way through.  Gonna take some time…")
	(f_md_object_play 0 NONE m10_1630)
	(cs_run_command_script (object_get_ai obj_carter) cs_spartans_talks)
	(sleep 30)
	(print "CARTER: OK. We’re en route to your position.")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_2230)
	
	(sleep_until (volume_test_players vol_outpost_ext) 5)
	
	(print "PILOT 1: Approaching the comm outpost!")
	(f_md_object_play 0 NONE m10_2240)
	(cs_run_command_script (object_get_ai obj_carter) cs_spartans_talks)
	(sleep 20)
	(print "CARTER: Drop us in the courtyard.")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_2250)
	
	(set g_music06 TRUE)
	
	(print "PILOT 1: LZ's a little hot, sir…")
	(f_md_object_play_cutoff 5 NONE m10_2260)
	(print "CARTER: Put her down, Pilot. Six: break's over.")
	(f_md_ai_play 0 (object_get_ai obj_carter) m10_2270)
	
)

(script dormant md_outpost_ext01
	(sleep_until (not b_is_dialogue_playing))
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: How we doing', Kat?")
	(f_md_ai_play 20 group_carter m10_2280)
	
	(set g_music_ins TRUE)
	
	;(print "KAT: Almost there…")
	;(f_md_ai_play 20 group_kat m10_2290)
	
	(print "KAT: Taking a little longer than I hoped, Commander; I've cut about halfway through the door.")
	(f_md_ai_play 10 group_kat m10_2220)
	;(print "CARTER: Good.  Sooner Holland knows the Covenant are on Reach the better --")
	;(f_md_ai_play 10 group_carter m10_2300)
	
	;(sleep 40)
	(print "EMILE: Contact!")
	(f_md_ai_play 80 group_emile m10_2310)
	(print "CARTER: Hold 'em off 'til Kat can hack the control!")
	(f_md_ai_play 0 group_carter m10_2320)
	
	(set g_outpost_ext_obj_control 12)
	(set g_ui_obj_control 70)
	(ai_dialogue_enable TRUE)

)

(script dormant md_outpost_ext_fallback
	(sleep_until (not b_is_dialogue_playing))
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Kat?!")
	(f_md_ai_play 20 group_carter m10_2350)
	(print "KAT: Just... about... There!  We're in!")
	(f_md_ai_play 0 group_kat m10_2360)
	(set g_outpost_ext_obj_control 20)
	
	(set g_music01 TRUE)
	
	(sleep 40)
	(print "Everybody inside!  Go, go, go!")
	(f_md_ai_play 0 group_carter m10_2370)
	
	(set g_ui_obj_control 80)
	(set g_outpost_ext_obj_control 30)
	
	(set g_music02 TRUE)
	
	(sleep 200)
	(if (not (volume_test_players tv_outpost_ext_control))
		(wake md_outpost_ext_fallback_a)
	)
	
	(ai_dialogue_enable TRUE)
)

(script dormant md_outpost_ext_fallback_a
	(sleep_until (not b_is_dialogue_playing))
	
	(print "CARTER: Inside, Lieutenant!  I'll cover you!")
	(f_md_ai_play 0 group_carter m10_2380)

)

(script dormant md_outpost_ext_fallback_b
	(sleep_until (not b_is_dialogue_playing))
	
	;(print "CARTER: Noble Six!  Get inside!")
	;;(md_play 0 sound\dialog\levels\m10\mission\robot\m10_1600_car)
	(if (not (volume_test_players tv_outpost_ext_control))
		(begin
			(print "CARTER: Noble Six!  Inside!  That's an order!")
			(f_md_ai_play 0 group_carter m10_2400)
		)
	)

)

(script dormant md_outpost_rally

	;this is set in kat's hacking vig
	;(sleep_until (>= g_outpost_ext_obj_control 30) 1 200)
	(sleep_until (not b_is_dialogue_playing))
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: We need to find the control room.")
	(f_md_ai_play 0 group_carter m10_2420)
	
	(sleep_until (>= g_outpost_ext_obj_control 45) 5 200)
	(print "CARTER: From there, Kat can get the relay back online.")
	(f_md_ai_play 15 group_carter m10_2430)
	
	(set g_outpost_ext_obj_control 47)
	(print "CARTER: Emile, post here.  If we flush any hostiles, they're yours. ")
	(f_md_ai_play 0 group_carter m10_2440)
	(set g_outpost_ext_obj_control 50)
	(sleep 50)
	(print "CARTER: All right, let's do this.")
	(f_md_ai_play 0 group_carter m10_2450)
	
	(wake ct_training_nightvision02_start)
	(ai_dialogue_enable TRUE)
	
)

(script dormant md_outpost_nightvision
	(branch
		(player_night_vision_on)
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "CARTER: Can't see a thing... Noble Six, turn on your night vision.")
	(f_md_ai_play 0 group_carter m10_0790)
	
	;(sleep 80)
	(wake md_outpost_control)

)

(script dormant md_outpost_control
	(sleep_until (volume_test_players vol_outpost_int_server01))
	(sleep_until (not b_is_dialogue_playing))
	
	(print "KAT: Control room. Go easy. ")
	(f_md_ai_play 40 group_kat m10_2460)
	(print "CARTER: Go in quiet -- just in case...")
	(f_md_ai_play 0 group_carter m10_0430)
	;*
	(print "JORGE: Meaning...?")
	(f_md_ai_play 0 group_jorge m10_2470)
	(print "KAT: Meaning, if it looks important, don't shoot it.")
	(f_md_ai_play 0 group_kat m10_2480)
	(print "CARTER: Six, move in and take a look around.")
	(f_md_ai_play 20 group_carter m10_2490)
	*;

)

(script dormant md_outpost_search
	(branch
		(volume_test_players tv_body_search)
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "KAT: Noble Six, search that body.")
	(f_md_ai_play 0 group_kat m10_2540)
	
	(sleep 200)
	(print "KAT: Lieutenant!  Check that body for ID!")
	(f_md_ai_play 0 group_kat m10_2550)
	
)

(script dormant md_outpost_flush
	(sleep_until (not b_is_dialogue_playing) 5)
	
	; music
	(set g_music02 TRUE)
	
	(sleep 25)
	(print "JORGE: Quiet!... Hear that?  There’s more.  Flush ‘em out; I’ve got you covered.")
	(f_md_ai_play 0 group_jorge m10_2570)
	
)

(script dormant md_outpost_finished
	(sleep_until (not b_is_dialogue_playing))
	
	(sleep 40)
	(print "JORGE: Noble Five reporting.  Targets neutralized.")
	(f_md_ai_play 40 group_jorge m10_2580)
	(print "CARTER: Kat needs you to reset a junction.  Do it, and get back here.")
	(f_md_object_play 0 NONE m10_2590)

	(wake ct_training_activate_start)
	
)



(script static void (md_play (short delay) (ai character) (ai_line line))
	(sleep (ai_play_line character line))
	(sleep delay)
)

(script static void (md_play_object (short delay) (object obj) (ai_line line))
	(sleep (ai_play_line_on_object obj line))
	(sleep delay)
)


; =================================================================================================
; sound Scripts
; =================================================================================================
(script dormant sound_1stbowl_falcons

	;when you begin the vignette after the cinematic – set immediately to these values
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) rotor_audio 1 0)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) engine_audio 0.6 0)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) rotor_audio 1 0)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) engine_audio 0.6 0)
	
	
	;when you start to slow down to the hover – set these over 2 seconds…may need to adjust
	(sleep_until (>= (device_get_position dm_falcon01_start) .22) 5)
	(print "sound_1stbowl_falcons: slow down to the hover")
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) rotor_audio 0.6 60)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) rotor_audio 0.6 60)
	
	
	;when you start to speed up again to head to the landing zone – set these over 2 seconds…may need to adjust
	(sleep_until (= g_1stbowl_obj_control 7) 5)
	(print "sound_1stbowl_falcons: speed up again")
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) rotor_audio 1 60)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) rotor_audio 1 60)
	
	
	;when you start to begin hovering to drop off the spartans – set these over 2 seconds…may need to adjust
	(sleep_until (>= (device_get_position dm_falcon01_start) .9) 5)
	(print "sound_1stbowl_falcons: hovering to drop off")
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) rotor_audio 0.2 60)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) engine_audio 0.2 60)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) rotor_audio 0.2 60)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) engine_audio 0.2 60)
	
	(sleep_until (>= (device_get_position dm_falcon02_start) .9) 5)
	(print "sound_1stbowl_falcons: falcon02 takes off")
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) rotor_audio 1 60)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) engine_audio 0.6 60)
	
	(sleep_until (not (any_players_in_vehicle)) 5)
	(print "sound_1stbowl_falcons: falcon01 takes off")
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) rotor_audio 1 60)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) engine_audio 0.6 60)

)

; =================================================================================================
; Music Scripts
; =================================================================================================
(global boolean g_music01 FALSE)
(global boolean g_music02 FALSE)
(global boolean g_music03 FALSE)
(global boolean g_music04 FALSE)
(global boolean g_music05 FALSE)
(global boolean g_music06 FALSE)
(global boolean g_music_ins FALSE)

(script static void reset_music_var_go
	(set g_music01 FALSE)
	(set g_music02 FALSE)
	(set g_music03 FALSE)
	(set g_music04 FALSE)
	(set g_music05 FALSE)
	(set g_music06 FALSE)
	(set g_music_ins FALSE)
)


(script dormant music_1stbowl
	(print "music_1stbowl")
	(sleep_until g_music01 5)
	(print "music change: let's stay focused")
	(sound_looping_start levels\solo\m10\music\m10_music01 NONE 1)
	
	(sleep_until g_music02 5)
	(print "music change: gas kiva- found the beacon")
	(sound_looping_stop levels\solo\m10\music\m10_music01)
	(sound_looping_start levels\solo\m10\music\m10_music02 NONE 1)
	
	(sleep_until g_music03 5)
	(print "music change: double time it")
	(sound_looping_start levels\solo\m10\music\m10_music03 NONE 1)
)

(script dormant music_barn
	(print "music_barn")
	(reset_music_var_go)
	
	(sleep_until g_music01 5)
	(print "music change: damn...")
	(sound_looping_stop levels\solo\m10\music\m10_music03)
	
	(sleep_until g_music02 5)
	(print "music change: it's messy")
	(sound_looping_start levels\solo\m10\music\m10_music04 NONE 1)
	
	(sleep_until g_music03 5)
	(print "music change: thermal's clean")
	(sound_looping_stop levels\solo\m10\music\m10_music02)
	
	(sleep_until g_music04 5)
	(print "music change: about to be flanked")
	(sound_looping_stop levels\solo\m10\music\m10_music04)
	
)

(script dormant music_meadow
	(print "music_meadow")
	(reset_music_var_go)
	
	(sleep_until g_music01 5)
	(print "music change: enemy dropships inbound")
	(sound_looping_start levels\solo\m10\music\m10_music05 NONE 1)

	(sleep_until g_music02 5)
	(print "music change: george go with kat")
	(sound_looping_stop levels\solo\m10\music\m10_music05)
	
)

(script dormant music_3kiva
	(print "music_3kiva")
	(reset_music_var_go)
	
	; optional music
	; uses g_music01 and g_music02
	(wake music_3kiva01)
	(wake music_3kiva02)
	
	(sleep_until g_music05 5)
	(print "music change: Transport inbound")
	(sound_looping_start levels\solo\m10\music\m10_music08 NONE 1)
	
	(sleep_until g_music06 5)
	(print "music change: Drop us in the courtyard")
	(sound_looping_set_alternate levels\solo\m10\music\m10_music08 TRUE)
	
)

(script dormant music_3kiva01
	(print "music_3kiva01")
	
	(sleep_until (or 3kiva_done g_music01) 5)
	
	(if (or 3kiva_done g_music03)
		(sleep_forever)
	)
	
	(print "music change: 3kiva01 start")
	(sound_looping_start levels\solo\m10\music\m10_music06 NONE 1)
	
	;(sleep_until g_music02 5)
	(sleep_until
		(or
			3kiva01_done
			(not (volume_test_players vol_3kiva01_approach01))
		)
	5)
	(print "music change: 3kiva01 done")
	(sound_looping_stop levels\solo\m10\music\m10_music06)
	
)

(script dormant music_3kiva02
	(print "music_3kiva02")
	
	(sleep_until (or g_music03 g_music04) 5)
	
	(if g_music04
		(sleep_forever)
	)
	
	(sleep_until g_music03 5)
	(print "music change: hog kiva")
	(sound_looping_start levels\solo\m10\music\m10_music07 NONE 1)
	
	(sleep_until g_music04 5)
	(print "music change: clear an LZ")
	(sound_looping_stop levels\solo\m10\music\m10_music07)
	
)


(script dormant music_outpost_ext
	(print "music_outpost_ext")
	(reset_music_var_go)
	
	(sleep_until g_music01 5)
	(print "music change: Fallback Into Outpost")
	(sound_looping_stop levels\solo\m10\music\m10_music08)
	
	(sleep_until g_music02 5)
	(print "music change: Objective Defend Outpost")
	(sound_looping_start levels\solo\m10\music\m10_music09 NONE 1)
	
	(sleep_until g_music03 5)
	(print "music change: body search")
	(sound_looping_stop levels\solo\m10\music\m10_music09)
	
)

(script dormant music_outpost_int
	(print "music_outpost_int")
	(reset_music_var_go)
	
	(sleep_until g_music01 5)
	(print "music change: when 1st group of convenant fall back in 1st hall")
	(sound_looping_stop levels\solo\m10\music\m10_music095)
	
	(sleep_until g_music02 5)
	(print "music change: there's more, flush em out I've got you covered")
	(sound_looping_start levels\solo\m10\music\m10_music10 NONE 1)
	
	(sleep_until g_music03 5)
	(print "music change: kill last elite")
	(sound_looping_stop levels\solo\m10\music\m10_music10)
	
)

(script dormant music_alpha
	(print "music_alpha")
	(reset_music_var_go)

	(print "music change: alpha start")
	(sound_looping_start levels\solo\m10\music\m10_music11 NONE 1)
	
	(sleep_until g_music_ins 5)
	(print "music change: get to work, noble")
	(sound_looping_stop levels\solo\m10\music\m10_music11)

)

(script dormant music_bravo
	(print "music_bravo")
	(reset_music_var_go)

	(print "music change: bravo start")
	(sound_looping_start levels\solo\m10\music\m10_music08 NONE 1)
	
	(sleep_until g_music_ins 5)
	(print "music change: How we doin' Kat?")
	(sound_looping_set_alternate levels\solo\m10\music\m10_music08 TRUE)
	
	(sleep_until g_music01 5)
	(print "music change: Fallback Into Outpost")
	(sound_looping_stop levels\solo\m10\music\m10_music08)

)


;=====================================================================;
; performances====================================================;
;=====================================================================;
(script command_script cs_lookat_player
	(cs_look_player TRUE)
)

(script command_script cs_void 
	(sleep 1)
)


(script static void branch_kill_vignette
	(print "killing vignette")
)

(script static void branch_witnesses_dad
	(print "witnesses_dad: branch")
	(set g_1stbowl_obj_control 30)
	;(device_set_position dm_kiva01_door 0)
)

(script static void witnesses_dad_exit
	(print "witnesses_dad: finished")
	(set g_1stbowl_obj_control 30)
)

;(branch_vig_damage ai_current_actor)
(script static boolean (branch_vig_damage (ai my_actor)) 
	(or
		(> (object_get_recent_shield_damage (ai_get_object my_actor)) 0)
		(> (object_get_recent_body_damage (ai_get_object my_actor)) 0)
	)
)

;(branch_vig_damage ai_current_actor)
(script static boolean (branch_vig_damage_hack (ai my_actor)) 
	(or
		(> (object_get_recent_shield_damage (ai_get_object my_actor)) .3)
		(> (object_get_recent_body_damage (ai_get_object my_actor)) 0)
	)
)

(script static void vig_glowstick02
	(sleep_until (object_running_sync_action (ai_get_object group_jorge) "throw_flare") 1)
	(sleep 60)
	(print "throwing flare")
	(object_create cr_outpost_glowstick02)
	(object_set_velocity cr_outpost_glowstick02 7.5)
)

(script static boolean (branch_outpost_elite_leader (ai my_actor)) 
	(or
		(> (object_get_recent_shield_damage (ai_get_object my_actor)) .3)
		(> (object_get_recent_body_damage (ai_get_object my_actor)) 0)
		(<= (ai_living_count outpost_int_elites01) 0)
		(volume_test_players vol_outpost_int_rear03)
		(and
			(<= (ai_living_count outpost_final_grunts01) 0)
			(volume_test_players vol_outpost_int_rear02)
		)
	)
)
;(sleep_until (branch_outpost_elite_leader ai_current_actor))

; =================================================================================================
; M10 HUD
; =================================================================================================

(script dormant hud_outpost_start
	(f_hud_flash_object sc_hud_outpost_highlight)
	(f_blip_title sc_hud_outpost_dish "WP_CALLOUT_M10_VISEGRAD")
	
)

(script dormant hud_beacon_start
	(f_blip_object sc_beacon_nav blip_default)
	(chud_track_object_with_priority sc_beacon_nav02 6 "WP_CALLOUT_M10_BEACON")
	
)

(script dormant hud_beacon02_start
	(f_blip_object sc_beacon_nav blip_default)
	(sleep_until (volume_test_players tv_1stbowl_gas))
	(hud_unblip_all)
	
)

(script dormant hud_witnesses
	(sleep_until (objects_can_see_object player0 sc_hud_1stbowl_kiva01 25) 5 (* 5 30))
	(f_hud_flash_object sc_hud_1stbowl_kiva_highlight)
	;(f_blip_title sc_hud_1stbowl_kiva01 "WP_CALLOUT_M10_WITNESSES")
	
)

;*
(script dormant hud_1stbowl_beacon
	;(hud_info_object sc_beacon "WP_CALLOUT_BARN_RADIO")
	(f_blip_object sc_beacon blip_recon)
	(sleep 90)
	(sleep_until (objects_can_see_object player0 sc_beacon 5) 5)
	(f_unblip_object sc_beacon)
	(set b_player_spotted_beacon TRUE)
)
*;

;*
(script dormant hud_1stbowl_weapon
	(sleep_until (player_can_see_and_dist w_1stbowl_dmr hud_info_fov 3) 5)
	(hud_info_object w_1stbowl_dmr "WP_CALLOUT_WEAPON01")
)
*;
(script dormant 3kiva01_hud
	(sleep_until (player_can_see_or_dist sc_hud_3kiva01_center 20 10) 5 (* 5 30))
	(wake md_3kiva01_heat)
	(f_hud_flash_object sc_hud_3kiva01_highlight)
)

(script dormant 3kiva02_hud
	;(sleep_until (objects_can_see_object player0 sc_hud_3kiva02 25))
	(sleep_until (player_can_see_or_dist sc_hud_3kiva02 25 10) 5 (* 5 30))
	(f_hud_flash_object sc_hud_3kiva02_highlight)
)

(script dormant 3kiva03_hud
	;(sleep_until (objects_can_see_object player0 sc_hud_3kiva03 25))
	(sleep_until (player_can_see_or_dist sc_hud_3kiva03 25 10) 5 (* 5 30))
	;(f_hud_flash_object sc_hud_3kiva03_highlight)
)

(script dormant 1stbowl_hud_master
	(sleep_until
		(begin
			(cond
	
				((player_can_see_and_dist sc_hud_1stbowl_gas01 hud_info_fov 3)
					(hud_info_object_destroy sc_hud_1stbowl_gas01 "WP_CALLOUT_DAMAGE01")
				)
				
				((player_can_see_and_dist sc_hud_1stbowl_gas02 hud_info_fov 3)
					(hud_info_object_destroy sc_hud_1stbowl_gas02 "WP_CALLOUT_DAMAGE02")
				)
				
				((player_can_see_and_dist sc_hud_1stbowl_hog hud_info_fov 3)
					(hud_info_object_destroy sc_hud_1stbowl_hog "WP_CALLOUT_VEHICLE01")
				)
				
			)
			;FALSE
			;sleep_until 3kiva is loaded
			(= (current_zone_set_fully_active) 5)
		)
	)
)

;globals ===========================================================================================

(global short hud_info_on 2)
(global short hud_info_off 2)
(global short hud_flash_on 4)
(global short hud_flash_off 5)
(global short hud_flash_final 30)
(global short hud_info_fov 15)

(script static void (hud_info_object (object_name hud_object) (string WP_CALLOUT_TYPE))
	(print "hud info action")
	
	;(chud_track_object_with_priority hud_object 6 WP_CALLOUT_TYPE)
	;(sound_impulse_start sound\game_sfx\ui\transition_beeps NONE 1)
	(sleep 80)
	(sleep_until (not (objects_can_see_object player0 hud_object 35)) 5 150)
	(chud_track_object hud_object FALSE)
)

(script static void (hud_info_object_destroy (object_name hud_object) (string WP_CALLOUT_TYPE))
	(hud_info_object hud_object WP_CALLOUT_TYPE)
	(object_destroy hud_object)
)

(script static boolean (player_can_see_and_dist (object_name hud_object) (short fov) (short distance))
	(and
		(objects_can_see_object player0 hud_object fov)
		(> (player_count) 0)
		(>= distance (objects_distance_to_object player0 hud_object))
	)
)

(script static boolean (player_can_see_or_dist (object_name hud_object) (short fov) (short distance))
	(or
		(objects_can_see_object player0 hud_object fov)
		(objects_can_see_object player1 hud_object fov)
		(objects_can_see_object player2 hud_object fov)
		(objects_can_see_object player3 hud_object fov)
		(>= distance (objects_distance_to_object player0 hud_object))
	)
)

;Spartan waypoints ===========================================================================================

(script static void spartan_waypoints
	(wake carter_waypoint)
	(wake kat_waypoint)
	(wake jun_waypoint)
	(wake emile_waypoint)
	(wake jorge_waypoint)
)

(script dormant carter_waypoint
	(f_hud_spartan_waypoint (object_get_ai obj_carter) carter_name 60)
)

(script dormant kat_waypoint
	(branch
		(>= (current_zone_set) 5)
		(branch_kill)
	)
	(f_hud_spartan_waypoint (object_get_ai obj_kat) kat_name 60)
)

(script dormant kat_outpost_waypoint
	(f_hud_spartan_waypoint (object_get_ai obj_kat) kat_name 60)
)

(script dormant jun_waypoint
	(f_hud_spartan_waypoint (object_get_ai obj_jun) jun_name 300)
)

(script dormant emile_waypoint
	(branch
		(>= (current_zone_set) 5)
		(branch_kill_waypoint (object_get_ai obj_emile))
	)
	(f_hud_spartan_waypoint (object_get_ai obj_emile) emile_name 60)
)

(script dormant emile_outpost_waypoint
	(branch
		(volume_test_players vol_outpost_int_server01)
		(branch_kill)
	)
	(f_hud_spartan_waypoint (object_get_ai obj_emile) emile_name 60)
)

(script dormant jorge_waypoint
	(f_hud_spartan_waypoint (object_get_ai obj_jorge) jorge_name 60)
)



(script static void (branch_kill_waypoint (ai spartan))
	(chud_track_object spartan FALSE)
)

; =================================================================================================
; M10 OBJECTIVES
; =================================================================================================
(global short g_ui_obj_control 0)

(script dormant obj_start
	(sleep_until (>= g_ui_obj_control 5) 5)
	(if (= g_ui_obj_control 5) (wake obj_01_locate_start))
	
	(sleep_until (>= g_ui_obj_control 10) 5)
	(if (= g_ui_obj_control 10) (wake obj_engage_start))
	
	(sleep_until (>= g_ui_obj_control 20) 5)
	(if (= g_ui_obj_control 20) (wake obj_recon_start))
	
	(sleep_until (>= g_ui_obj_control 30) 5)
	(if (= g_ui_obj_control 30) (wake obj_troopers_start))
	
	(sleep_until (>= g_ui_obj_control 40) 5)
	(if (= g_ui_obj_control 40) (wake obj_evac_start))
	
	(sleep_until (>= g_ui_obj_control 50) 5)
	(if (= g_ui_obj_control 50) (wake obj_falcon_start))
	
	(sleep_until (>= g_ui_obj_control 60) 5)
	(if (= g_ui_obj_control 60) (wake obj_outpost_start))
	
	(sleep_until (>= g_ui_obj_control 70) 5)
	(if (= g_ui_obj_control 70) (wake obj_outpost02_start))
	
	(sleep_until (>= g_ui_obj_control 80) 5)
	(if (= g_ui_obj_control 80) (wake obj_outpost03_start))
	
	(sleep_until (>= g_ui_obj_control 90) 5)
	(if (= g_ui_obj_control 90) (wake obj_inside_start))
)

(script dormant obj_01_locate_start
	(f_hud_obj_new ct_objective_locate PRIMARY_OBJECTIVE_1)
)

(script dormant obj_locate02_start
	;(f_hud_obj_repeat ct_objective_locate)
	(f_hud_obj_new ct_objective_investigate PRIMARY_OBJECTIVE_1_5)
)

(script dormant obj_engage_start
	(f_hud_obj_new ct_objective_engage PRIMARY_OBJECTIVE_2)
)

(script dormant obj_recon_start
	(f_hud_obj_new ct_objective_recon PRIMARY_OBJECTIVE_35)
)

(script dormant obj_troopers_start
	(f_hud_obj_new ct_objective_troopers PRIMARY_OBJECTIVE_45)
)

(script dormant obj_evac_start
	(f_hud_obj_new ct_objective_evac PRIMARY_OBJECTIVE_4)
)

(script dormant obj_falcon_start
	(f_hud_obj_new ct_objective_falcon PRIMARY_OBJECTIVE_5)
)

(script dormant obj_outpost_start
	(f_hud_obj_new ct_objective_outpost01 PRIMARY_OBJECTIVE_55)
)

(script dormant obj_outpost02_start
	(f_hud_obj_new ct_objective_outpost02 PRIMARY_OBJECTIVE_6)
)

(script dormant obj_outpost03_start
	(f_hud_obj_new ct_objective_outpost03 PRIMARY_OBJECTIVE_65)
)

(script dormant obj_inside_start
	(f_hud_obj_new ct_objective_inside PRIMARY_OBJECTIVE_7)
)


(script static void hud_unblip_all
	(f_unblip_object sc_beacon_nav)
	(f_unblip_object sc_hud_barn01)
	(f_unblip_object sc_hud_meadow_waypoint01)
	(f_unblip_object v_3kiva_pickup_init)
	(f_unblip_object sc_hud_3kiva01)
	(f_unblip_object sc_hud_3kiva02)
	(f_unblip_object sc_hud_3kiva03)
	(f_unblip_object (ai_vehicle_get_from_squad intro_falcon_01 0))
	(f_unblip_object (ai_vehicle_get_from_squad 3kiva_fork 0))
	(f_unblip_object dc_outpost_health)
	(f_unblip_object sc_hud_outpost_body)
	
)

; =================================================================================================
; M10 TRAINING
; =================================================================================================

(script dormant training_look_start
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	(sleep 60)
	(chud_cinematic_fade 1 30)
	(training_look player0)
)

(script static void (training_look (player player_num))
	(print "begin training look")
	
	; set data mine name 
	;(data_mine_set_mission_segment "l100_001_look_training")
	
		; look training starts here =============================================
		(chud_show_screen_training player_num tr_look)
		;(f_sfx_hud_in player_short)
			(sleep 90)
		
		; scale player input to one 
		;(unit_control_fade_in_all_input (player_get player_short) 1)
		;(sleep_until (>= g_1stbowl_obj_control 7))
		;(sleep_until (>= g_1stbowl_obj_control 8))
		(training_player_has_looked)
		(print "player has looked")
		(chud_show_screen_training player_num "")
		;(sleep_until b_player_spotted_beacon 5)
		
		(print "ask player if they like their settings ")
		; yes: then move on 
		; no: invert and try again
		
		(f_display_message_confirm player_num tr_look_accept)

			(cond
				((player_action_test_accept)	(begin
												(print "camera settings accepted")
												(set b_training_look_done TRUE)									
												(f_training_set_look_pref player0)
										)
				)
				((player_action_test_rotate_weapons)	(begin
												(print "camera settings rejected")
												(f_training_look_rejected player0)
										)
				)
				(TRUE
												(f_display_message_time player_num tr_start_menu_short 200)
				)
			)
		
		(print "training look done")
		(set b_training_look_done TRUE)
)

(script static void training_player_has_looked
	(player_action_test_reset)
	(sleep 5)
	(sleep_until	(or
					(player_action_test_look_relative_up)
					(player_action_test_look_relative_down)
					(player_action_test_look_relative_left)
					(player_action_test_look_relative_right)
					;(>= g_1stbowl_obj_control 7)
				)
	)
	(sleep_until 
		(or
			(player_action_test_look_relative_all_directions)
			(>= g_1stbowl_obj_control 7)
		)
	30 (* 30 10))
		(sleep 80)
)

(script static void (f_training_set_look_pref
										(player player_num)
				)
	(chud_show_screen_training player_num "")
		(sleep 30)
	;(f_sfx_hud_in player_short)
	;*
	(if	(controller_get_look_invert)
		(f_display_message_accept player_num tr_set_invert_01)
		(f_display_message_accept player_num tr_set_normal_01)
	)
	*;
	;(f_display_message_accept player_num tr_start_menu)
	(f_display_message_time player_num tr_start_menu_short 250)
		(sleep 15)
)


(script static void (f_training_look_rejected
										(player player_num)
				)
	(chud_show_cinematic_title player_num tr_look_reject)
	
	(player_invert_look player_num)
		(sleep 30)
	(chud_show_cinematic_title player_num tr_look)
		(sleep 15)
	
	; sleep until player moves the look stick up or down 
	(training_player_has_looked)
	
	(f_display_message_confirm player_num tr_look_accept)

			(cond
				((player_action_test_accept)	(begin
												(print "camera settings accepted")	
												(set b_training_look_done TRUE)									
												(f_training_set_look_pref player0)
										)
				)
				((player_action_test_rotate_weapons)	(begin
												(print "camera settings rejected")
												(f_training_look_rejected player0)
										)
				)
			)
		
	(chud_show_screen_training player_num "")
	(set b_training_look_done TRUE)
)


(script dormant ct_training_sprint_start
	(branch
		(volume_test_players vol_barn_start)
		(branch_kill)
	)
	
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	(sleep_until (volume_test_players tv_training_sprint) 5)
	(wake ct_training_sprint_start0)
	(wake ct_training_sprint_start1)
	(wake ct_training_sprint_start2)
	(wake ct_training_sprint_start3)
	
	;*
	;if coop
	(if (>= (game_coop_player_count) 2)
		(wake ct_training_sprint_start1)
	)
	
	(if (>= (game_coop_player_count) 3)
		(wake ct_training_sprint_start2)
	)
	
	(if (>= (game_coop_player_count) 4)
		(wake ct_training_sprint_start3)
	)
	*;
	
)

(script dormant ct_training_sprint_start0
		(f_hud_training_confirm player0 ct_training_sprint "equipment")
)

(script dormant ct_training_sprint_start1
	(f_hud_training_confirm player1 ct_training_sprint "equipment")
)

(script dormant ct_training_sprint_start2
	(f_hud_training_confirm player2 ct_training_sprint "equipment")
)

(script dormant ct_training_sprint_start3
	(f_hud_training_confirm player3 ct_training_sprint "equipment")
)

(script static void training_motion_tracker
	(chud_show_motion_sensor 0)
	(chud_set_static_hs_variable player0 4 1)
	(chud_show_motion_sensor 1)
	(sleep 15)
	(chud_clear_hs_variable player0 4)

)


(script dormant ct_training_switch
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	;(sleep_until (unit_action_test_rotate_weapons player_num))
	(sleep_until (volume_test_players vol_meadow_halfway))
	(f_hud_training_confirm player0 ct_training_switch "rotate_weapons")
)

(script dormant ct_training_exit_start
	(branch
		(not (unit_in_vehicle (unit player0)))
		(f_hud_training_clear player0)
	)
	
	;*
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	*;
	
	(f_hud_training_forever player0 ct_training_enterexit)
	(sleep_until (not (unit_in_vehicle (unit player0))) 5)
	(f_hud_training_clear player0)
	
)

(script dormant ct_training_enterexit_start
	(branch
		(or
			(unit_in_vehicle (unit player0))
			(volume_test_players vol_3kiva_1bsp)
		)
		(ct_training_enterexit_done)
	)
	
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	(sleep_until (>= 10 (objects_distance_to_object player0 v_3kiva_pickup_init)) 5)
	(f_blip_object_offset v_3kiva_pickup_init blip_default 1)
	
	(sleep_until
		(begin
			(sleep_until (player_can_see_and_dist v_3kiva_pickup_init 10 5) 5)
			(f_hud_training_forever player0 ct_training_enterexit)
			(sleep_until (not (<= (objects_distance_to_object player0 v_3kiva_pickup_init) 6)) 5)
			(f_hud_training_clear player0)
			FALSE
		)
	)
	
)

(script static void  ct_training_enterexit_done
	(f_hud_training_clear player0)
	(f_unblip_object v_3kiva_pickup_init)
	
)

(script dormant training_health
	(branch
		(or
			(>= (unit_get_health player0) 1)
			(volume_test_players tv_body_search)
		)
		(f_unblip_object dc_outpost_health)
	)
	
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	(if (>= (unit_get_health player0) 1)
		(sleep_forever)
	)
	(sleep_until (< (objects_distance_to_object dc_outpost_health player0) 4) 1)
	(f_blip_object dc_outpost_health blip_default)
	(wake ct_training_health_start)
	
)

(script dormant ct_training_health_start
	(f_hud_training player0 ct_training_health)
)


(script dormant ct_training_activate_start
	(branch
		(>= (device_get_position dc_outpost_end) 1)
		(f_unblip_object dc_outpost_end)
	)
	
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	(f_blip_object dc_outpost_end blip_interface)
	(sleep_until (>= (device_get_position dc_outpost_end) 1) 5)
	(f_unblip_object dc_outpost_end)
	
)

(script dormant ct_training_activate_end
	(f_unblip_object dc_outpost_end)
)


(script dormant ct_training_jump_start
	(f_hud_training player0 ct_training_jump)
)


(script dormant ct_training_melee_start
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	(sleep_until (volume_test_players tv_barn_training_grenades) 5)
	(f_hud_training player0 ct_training_melee)
)

(script dormant ct_training_grenades_start
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	(f_hud_training player0 ct_training_grenades)
)

(script dormant ct_training_nightvision_start
	(if (= (game_difficulty_get) legendary)
		(sleep_forever)
	)
	
	(f_hud_training player0 ct_training_nightvision)
)

(script dormant ct_training_nightvision02_start
	(branch
		(volume_test_players tv_body_search)
		(f_hud_training_clear player0)
	)
	(sleep 20)
	(f_hud_training_confirm player0 ct_training_nightvision "vision_trigger")
)

(script dormant m10_weapon_training
	(sleep_until
		(or
			(unit_has_weapon  player0 objects\weapons\rifle\dmr\dmr.weapon)
			(unit_has_weapon  player0 objects\weapons\pistol\plasma_pistol\plasma_pistol.weapon)
			(unit_has_weapon  player0 objects\weapons\rifle\plasma_rifle\plasma_rifle.weapon)
			(unit_has_weapon  player0 objects\weapons\pistol\needler\needler.weapon)
			(unit_has_weapon  player0 objects\weapons\rifle\needle_rifle\needle_rifle.weapon)
	   	)
	5)
	(sleep 10)
	(f_hud_training_new_weapon)

)

; =================================================================================================
; global TRAINING
; =================================================================================================
; TIMEOUT 
(script static void (f_display_message_time
								(player			player_num)
								(string_id	display_title)
								(short ticks)
				)
	(chud_show_screen_training player_num display_title)
	(sleep ticks)
	(chud_show_screen_training player_num "")
)

; Accept / Cancel Button 
(script static void (f_display_message_confirm
								(player			player_num)
								(string_id	display_title)
				)
	(chud_show_screen_training player_num display_title)
		(sleep 5)
	(unit_action_test_reset player_num)
		(sleep 5)
	;(unit_confirm_message (player_get player_short))
	;(unit_confirm_cancel_message (player_get player_short))
	(sleep_until	(or
					(unit_action_test_accept player_num)
					(unit_action_test_rotate_weapons player_num)
					(>= g_1stbowl_obj_control 8)
				)
	1)
	(print "player has given input")
	;*
	(cond
		((unit_action_test_accept player_num) (f_sfx_a_button player_num))
		((unit_action_test_cancel player_num) (f_sfx_b_button player_num))
	)
	*;
	(chud_show_screen_training player_num "")
		(sleep 5)
)

; Accept Button 
(script static void (f_display_message_accept
								(player			player_num)
								(string_id	display_title)
				)
	(chud_show_screen_training player_num display_title)
		(sleep 5)
	(unit_action_test_reset player_num)
		(sleep 5)
	;(unit_confirm_message player_num)
	(sleep_until (unit_action_test_accept player_num) 1)
	;(f_sfx_a_button player_short)
	(chud_show_screen_training player_num "")
		(sleep 30)
)


; =================================================================================================
; CHAPTER TITLES
; =================================================================================================
(script dormant chapter_01_start
	(sleep 30)
	(f_hud_chapter chapter_01)
	
	; spartans waypoints
	(if (not (game_is_cooperative))
		(spartan_waypoints)
	)
)

(script dormant chapter_02_start
	(sleep_until (volume_test_players tv_3kiva_start03) 5)
	(f_hud_chapter chapter_02)
)

(script dormant chapter_03_start
	(sleep 90)
	(f_hud_chapter chapter_03)
)


; =================================================================================================
; ACHIEVEMENTS
; =================================================================================================
(script dormant achievment01_start
	
	(sleep_until (= (current_zone_set_fully_active) 4))
	(sleep_until
		(or
			(any_players_in_vehicle)
			3kiva_done
		)
	)
	
	(if 3kiva_done
		(begin
			(print "achievement: no pickups")
			(submit_incident_with_cause_player "3kiva_clear" player0)
			(submit_incident_with_cause_player "3kiva_clear" player1)
			(submit_incident_with_cause_player "3kiva_clear" player2)
			(submit_incident_with_cause_player "3kiva_clear" player3)
			
		)
		(print "achievement: FAIL")
	)
	
)


;*
(script static boolean player_used_pickup
		(or
			(player_used_placed_pickup v_3kiva_pickup_init)
			(player_used_placed_pickup v_3kiva_pickup_init02)
			(player_used_placed_pickup v_3kiva_pickup_init03)
			(player_used_placed_pickup v_3kiva_pickup_left)
			(player_used_placed_pickup v_3kiva_pickup_right)
			(player_used_placed_pickup v_3kiva_pickup_kiva02)
			(player_used_placed_pickup v_3kiva_pickup_kiva03)
		)
)

(script static boolean (player_used_placed_pickup (vehicle pickup))
	(if (> (object_get_health pickup) 0)
		(vehicle_test_seat_unit_list pickup "warthog_d" (players))
		FALSE
	)
)
*;


;object_get_health v_3kiva_pickup_init02


; =================================================================================================
; Soft Ceilings
; =================================================================================================

(script dormant ceiling_control
	(soft_ceiling_enable camera_blocker_07 0)
	(soft_ceiling_enable camera_blocker_06 0)
	
	(sleep_until 
		(or
			(volume_test_players tv_1stbowl_adv02)
			(> g_insertion_index 0)
		)
	)
	;(soft_ceiling_enable player_blocker_end 0)
	(soft_ceiling_enable falcon_ride 0)
	(soft_ceiling_enable camera_blocker_01 0)
	(sleep_until 
		(or
			(volume_test_players tv_barn_hud)
			(>= g_insertion_index 1)
		)
	)
	(soft_ceiling_enable camera_blocker_02 0)
	
	(sleep_until 
		(or
			(= (current_zone_set) 4)
			(>= g_insertion_index 2)
		)
	)
	(soft_ceiling_enable camera_blocker_07 1)
	
	(sleep_until 
		(or
			(volume_test_players vol_meadow_start02)
			(>= g_insertion_index 2)
		)
	)
	(soft_ceiling_enable camera_blocker_03 0)
	
	
	(sleep_until 
			(or 
				(volume_test_players vol_meadow_exit)
				(volume_test_players tv_meadow_backleft)
			(>= g_insertion_index 2)
		)
	)
	(soft_ceiling_enable camera_blocker_04 0)
	
	
	(sleep_until 
		(or 
			(= (current_zone_set) 5)
			(>= g_insertion_index 3)
		)
	)
	(soft_ceiling_enable camera_blocker_06 1)
	
	
	(sleep_until 
		(or
			(volume_test_players vol_3kiva_1bsp)
			(>= g_insertion_index 3)
		)
	)
	(soft_ceiling_enable camera_blocker_05 0)
)
