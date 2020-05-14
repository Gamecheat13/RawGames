(script startup m35_ambient_stub
	(if debug (print "m35 ambient stub"))
)

; =================================================================================================
; M35 CINEMATICS
; =================================================================================================
;*
(script static void m35_cin_intro_blockout

	(print "m35 intro cinematic")

	; switch to proper zone set 
	(switch_zone_set set_hill_intro)
		
	(cinematic_snap_to_black)
		(sleep 60)
	(camera_set_field_of_view 80 0)
	(camera_set cam_1 0)
		(sleep 5)
	(fade_in 0 0 0 45)
	(camera_set cam_2 300)
		(sleep 100)
	
	; chapter titles 
	(cinematic_set_title ct_cinematic_stub01)				
	
	(camera_set cam_3 300)
		(sleep 200)
	
	; return to gameplay 
	(cinematic_fade_to_gameplay)
)



(script static void m35_cin_outro_blockout

	(print "m35 outro cinematic")
	
	; switch to proper zone set 
	(switch_zone_set set_spire)
	
	; removing spire AI
	(ai_erase gr_spire_cov)
	
	; adding falcon 
	(object_create v_spire_outro_falcon)
	
	;removing banshees 
	(object_destroy v_spire_banshee_01)
	(object_destroy v_spire_banshee_02)
		
	(cinematic_snap_to_black)
		(sleep 60)
	(camera_set_field_of_view 80 0)
	(camera_set cam_4 0)
		(sleep 5)
	(fade_in 0 0 0 45)
	(camera_set cam_5 200)
		(sleep 100)				
	(camera_set cam_6 200)
		(sleep 100)
	(camera_set cam_7 200)
		(sleep 100)		
	
	; chapter titles 
	(cinematic_set_title ct_cinematic_stub02)				
	
	(camera_set cam_8 200)	
		(sleep 200)
)
*;
; =================================================================================================
; MISSION DIALOGUE: MAIN SCRIPTS
; =================================================================================================
(script static void (md_play (short delay) (sound line))
	(sleep delay)
	(sound_impulse_start line NONE 1)
	(sleep (sound_impulse_language_time line))
)

; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION DIALOGUE 
; ===================================================================================================================================================
; ===================================================================================================================================================

;*
+++++++++++++++++++++++
 DIALOGUE INDEX  
+++++++++++++++++++++++

m35_0010_tr1  
m35_0020_com  
m35_0030_com  
m35_0040_com  
m35_0050_com  
m35_0060_com  
m35_0070_com  
m35_0080_com  
m35_0090_pil  
m35_0100_pil  
m35_0110_pil  

+++++++++++++++++++++++
*;

; ===================================================================================================================================================

(script dormant md_hill_intro
	(sleep 80)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Kat, Six: what's your status?")
	(f_md_object_play 0 NONE m35_0010)
	
	(sleep 60)
	
	(print "KAT: Pylons are down. We're pushing up the hill!")
	(f_md_ai_play 0 gr_kat m35_0020)
	(print "CARTER: Copy that.  I'm waiting on new intel.  See what you can see.  Carter out.")
	;(f_md_object_play 0 NONE m35_0010)
	
	(ai_dialogue_enable TRUE)
	
	(sleep 50)
	(wake obj_00_engage_start)
)

(script dormant md_kat_left
	;(sleep_until (not (volume_test_players tv_facility_start)))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)
	
	(print "KAT: Commander, I'm gonna set up a forward observation post here.")
	(f_md_object_play 0 NONE m35_0050)
	(print "CARTER: Copy that.  I'm waiting on new intel.  See what you can see.  Carter out.")
	(f_md_object_play 40 NONE m35_0060)
	
	(ai_dialogue_enable TRUE)

)

; ===================================================================================================================================================
(script dormant md_twin_intro
	
	(sleep_until 
		(or
			(<= (ai_living_count obj_hill_cov) 0)
			(>= g_hill_obj_control 6)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "" (players))
		)
	)
	(sleep_until (not b_is_dialogue_playing))
	
	(if (<= (ai_living_count obj_hill_cov) 0)
		(wake md_hill_hog)
	)
	
	(ai_dialogue_enable FALSE)
	
	(sleep 50)
	(print "CARTER: Kat, be advised ONI has ID'd two hostile anti-aircraft guns southwest of your position.")
	(f_md_object_play 20 NONE m35_0120)
	(print "KAT: Copy, Commander.  New targets, Six.  Go shut down those AA guns.")
	(f_md_ai_play 10 gr_kat m35_0130)
	
	(ai_dialogue_enable TRUE)
	
	(wake obj_01_aa01_start)
	(set g_music01 TRUE)
	
)

(script dormant md_hill_hog
	(branch
		(player_in_vehicle (ai_vehicle_get_from_squad sq_hill_rockethog_01 0))
		(f_md_abort)
	)
	(sleep_until (volume_test_objects tv_hill_hog_drop (ai_vehicle_get_from_squad sq_hill_rockethog_01 0)))
	(sleep_until (<= (ai_living_count obj_hill_cov) 0))
	(sleep 200)
	
	(sleep_until (not b_is_dialogue_playing))
	
	(print "KAT: Commandeer that Warthog, Six.")
	(f_md_ai_play 0 gr_kat m35_0100)

)

(script dormant md_twin_intro_02
	(branch
		g_bfg01_core_destroyed
		(f_md_abort)
	)
	;(sleep_until (>= g_hill_obj_control 6) 5)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	
	(print "LONGSWORD CAPTAIN 1: Two Lima Four to Noble One.  Those guns are pounding us with high-velocity plasma shells.")
	(f_md_object_play 20 NONE m35_0180)
	;(print "LONGSWORD CAPTAIN 2: No way we get our Longswords airborne under these conditions.")
	;(f_md_object_play 20 NONE m35_0190)
	
	(print "AUNTIE DOT: Which would mean a strike by the frigate Grafton is also out of the question.")
	(f_md_object_play 0 NONE m35_0200)
	(print "CARTER: Noble Six: all our birds are stuck out of range unless you can do something about those guns.")
	(f_md_object_play 0 NONE m35_0210)
	
	(set g_music02 TRUE)
)

; ===================================================================================================================================================
(script dormant md_twin_gun_in_range
	(branch
		g_bfg01_core_destroyed
		(f_md_abort)
	)
	;(sleep_until (>= g_twin_obj_control 1) 5)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(game_save)
	(wake twin_bfg_flash)
	
	(ai_dialogue_enable FALSE)
	
	(sleep 30)
	(print "CARTER: Six: AA gun should be in visual range.")
	(f_md_object_play 0 NONE m35_0170)
	
	(ai_dialogue_enable TRUE)
	
	(wake md_twin_intro_02)
	
)

(script dormant md_twin_gun_info_02
	(branch
		g_bfg01_core_destroyed
		(f_md_abort)
	)
	
	(sleep_until (>= g_twin_obj_control 2) 30 b_waypoint_time)
	(if (>= g_twin_obj_control 2)
		(sleep b_waypoint_time)
	)
	
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: New intel, Six: Looks like normal weapons won't dent those AA guns.")
	(f_md_object_play 20 NONE m35_0220)
	(print "AUNTIE DOT: I would suggest neutralizing the interior fuel cells, Lieutenant.")
	(f_md_object_play 0 NONE m35_0230)
	
	(ai_dialogue_enable TRUE)
	
	(wake obj_11_aa01b_start)
	
)

(script dormant md_twin_gun_info_03
	(branch
		g_bfg01_core_destroyed
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "AUNTIE DOT: Noble Six, if I may? Look for the fuel-chamber hatch.")
	(f_md_object_play 0 NONE m35_0240)
	(f_blip_object sc_hud_bfg01_core blip_neutralize)
	
)

; ===================================================================================================================================================
(script dormant md_twin_longswords
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "LONGSWORD CAPTAIN 1: Control, Two Lima Four.  Permission to commence bombing run, heading two-two-four-point-six, over.")
	(f_md_object_play 0 NONE m35_0630)
	
	(sleep_until g_bfg01_destroyed)
	(f_hud_obj_complete)
	(sleep (random_range 20 30))
	
	(ai_dialogue_enable FALSE)
	
	;(f_hud_start_menu_obj PRIMARY_OBJECTIVE_2)
	(print "CARTER: Good work, Noble Six.  UNSC air support: skies are clear.")
	(f_md_object_play 40 NONE m35_0560)
	
	(ai_dialogue_enable TRUE)
	
	(print "longswords are clear")
	(set g_longswords01_clear TRUE)
	
	(print "LONGSWORD CAPTAIN 1: Copy, Two Lima Four, bombing run, heading two-two-four-point-six  Permission granted, out.")
	(f_md_object_play 10 NONE m35_0640)
	
	;(print "LONGSWORD CAPTAIN 1: Two Lima Four, commencing run.  Two Lima Five, assume position on my left wing and focus on that line of Wraiths, over.")
	;(f_md_object_play 0 NONE m35_0650)
	;(print "LONGSWORD CAPTAIN 1: Roger that, Two Lima Four.  Moving into position.  Copy target the Wraiths and follow your lead, over.")
	;(f_md_object_play 20 NONE m35_0660)
	;(print "LONGSWORD CAPTAIN 1: Okay, let's hit 'em...")
	;(f_md_object_play 0 NONE m35_0670)
	
	(sleep 200)
	(wake obj_02_adv01_start)
	(wake md_twin_take_road)
	(set g_music03 TRUE)
	
)

(script dormant md_twin_take_road
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "KAT: Six: take that south road and see if you can get a better look at those LZ spires.  I'll be on radio.")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play 0 gr_kat m35_0070)
		(f_md_object_play 0 NONE m35_0070)
	)

)

(script dormant md_twin_bridge
	(sleep_until (>= (device_get_position dm_pelican) .2) 1)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)

	(print "KAT: Six, Pelican inbound with a portable bridge.  Once it's in place, head over to the southwest side.")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play 0 gr_kat m35_0570)
		(f_md_object_play 0 NONE m35_0570)
	)
	
	(ai_dialogue_enable TRUE)

)

(script dormant md_twin_bridge_02
	(branch
		(>= g_facility_obj_control 1)
		(f_md_abort)
	)
	(sleep_until (>= (device_get_position dm_pelican) .5))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "KAT: Bridge in position, Six. Keep moving toward those spires.")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play 0 gr_kat m35_0580)
		(f_md_object_play 0 NONE m35_0580)
	)
	
	;(wake obj_02_adv01_start)
	
	(sleep b_waypoint_time)
	(print "KAT: Bridge in position, Six. Keep moving toward those spires.")
	;(f_md_ai_play 0 gr_kat m35_0590)
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play 0 gr_kat m35_0590)
		(f_md_object_play 0 NONE m35_0590)
	)
)



; ===================================================================================================================================================
(script dormant md_facility_intro
	;(sleep_until (>= g_twin_obj_control 5) 5)
	;(sleep_until (<= (ai_living_count sq_facility_intro_cov) 0) 5)
	(sleep_until (>= g_facility_obj_control 1))
	
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(wake chapter_02_start)
	
	(ai_dialogue_enable FALSE)
	
	(sleep 40)
	(print "CARTER: Noble Six, there's a mining facility near your position.  Covenant are using it as a command outpost.  Troopers on-site have already engaged.")
	(f_md_object_play 0 NONE m35_0730)
	
	(ai_dialogue_enable TRUE)
	
	(wake obj_03_facility_start)
	(set g_music01 TRUE)
	
)

(script dormant md_facility_elite
	(sleep_until (>= g_facility_obj_control 3))
	(sleep_until 
		(or
			(<= (ai_living_count gr_facility_intro_cov) 0)
			(>= g_facility_obj_control 5)
		)
	)
	
	(sleep_until (not b_is_dialogue_playing))
	
	(ai_dialogue_enable FALSE)
	
	(sleep 20)
	(print "AUNTIE DOT: New intelligence: friendly forces near the Covenant outpost have sighted a high value target. An Elite Zealot in fact.")
	(f_md_object_play 0 NONE m35_0740)
	(print "KAT: A Zealot? We're onto something big, Commander…")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play_cutoff 5 gr_kat m35_0750)
		(f_md_object_play_cutoff 5 NONE m35_0750)
	)
	(print "CARTER: Eyes on the prize, Noble. Take out that Zealot IF you get the chance. But keep moving toward the spires.")
	(f_md_object_play 0 NONE m35_0760)
	
	(ai_dialogue_enable TRUE)
	
	(set g_music02 TRUE)
)

(script dormant md_facility_zealot_dead
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "KAT: High value target has been neutralized. Impressive, Six.")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play_cutoff 10 gr_kat m35_0780)
		(f_md_object_play_cutoff 10 NONE m35_0780)
	)

)

(script dormant md_facility_end
	(branch
		(volume_test_players tv_enc_cannon)
		(f_md_abort)
	)
	(sleep_until (>= g_facility_obj_control 14) 5)
	(sleep_until (<= (ai_living_count obj_facility_cov) 0))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(sleep 60)
	(print "Kat: Mining facility secured, Six.  Move on at your discretion.")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play 0 gr_kat m35_0790)
		(f_md_object_play 0 NONE m35_0790)
	)
	
)

; ===================================================================================================================================================
(script dormant md_cannon_intro
	(sleep_until (>= g_cannon_obj_control 1) 1)
	
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Update, Six: Scans show another Covenant AA gun ahead of your position.")
	(f_md_object_play 20 NONE m35_0820)
	;(print "CARTER: Take that gun down, and our Longswords can carpet-bomb the area.")
	;(f_md_object_play 0 NONE m35_0830)
	
	(print "CARTER: I want you to neutralize that gun -- by any means necessary.")
	(f_md_object_play 0 NONE m35_0840)
	
	(ai_dialogue_enable TRUE)
	
	(game_save)
	(wake obj_04_aa02_start)
	(set g_music01 TRUE)
	
)

(script dormant md_cannon_waypoint
	(branch
		g_bfg02_destroyed
		(f_md_abort)
	)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "CARTER: Noble Six!  I need that AA gun offline NOW!")
	(f_md_object_play 0 NONE m35_0920)
	
)

(script dormant md_cannon_end
	;(sleep_until g_bfg02_destroyed)
	(sleep_until (>= (ai_living_count sq_falcon_01) 1))
	
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(sleep (random_range 50 60))
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Well done, Six. ONI needs up-close recon on those spires.  We're gonna fly you the rest of the way.")
	(f_md_object_play 40 NONE m35_0930)

	(print "KAT: Jorge has a Falcon inbound your position, Lieutenant.  Highlighting the LZ now...")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play 0 gr_kat m35_0940)
		(f_md_object_play 0 NONE m35_0940)
	)
	
	(wake md_kat_left)
	
	;(wake md_kat_left)
	
	(ai_dialogue_enable TRUE)
	
	(wake obj_05_falcon_start)
	
	; turns on the LZ flag
	(f_blip_flag fl_falcon_01 blip_default)
	
)


(script dormant md_cannon_end_02
	(sleep 60)
	(sleep_until (not b_is_dialogue_playing))
	
	(print "KAT: Jorge has a Falcon inbound your position, Lieutenant.  Highlighting the LZ now...")
	(if (>= (ai_living_count (object_get_ai obj_kat)) 1)
		(f_md_ai_play 0 gr_kat m35_0940)
		(f_md_object_play 0 NONE m35_0940)
	)
	
	; music
	(set g_music_ins TRUE)
	
	(wake obj_05_falcon_start)
	
	; turns on the LZ flag
	(f_blip_flag fl_falcon_01 blip_default)
	
)


; ===================================================================================================================================================
(script dormant md_falcon_start
	(sleep_until (volume_test_players tv_cannon_landing))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "JORGE: Need a lift, Spartan?")
	(f_md_ai_play 0 (object_get_ai obj_jorge) m35_0950)
	
	(wake obj_05_falcon02_start)

)

(script dormant md_falcon_canyon
	; wait for player 
	(sleep_until (unit_in_vehicle_type player0 20))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)
	
	(sleep 120)
	(print "JORGE: Spotted some nasty business in the canyon on the way down.")
	(f_md_ai_play 0 (object_get_ai obj_jorge) m35_0970)
	(print "PILOT 2: I'll call out targets as we go.")
	(f_md_object_play 0 NONE m35_0980)
	
	(ai_dialogue_enable TRUE)
	
	(sleep 20)
	; chapter title
	(wake chapter_03_start)

)

(script dormant md_falcon_callouts
	(wake md_falcon_callout_top)
	(wake md_falcon_callout_ground)
	(wake md_falcon_callout_nice)
	
	(sleep_until (all_players_in_falcon))
	(if (falcon_has_right_gunners)
		(wake md_falcon_callout_right_phantom)
	)
	(if (falcon_has_left_gunners)
		(wake md_falcon_callout_left_wraiths)
	)
)


(script dormant md_falcon_callout_top
	(sleep_until (>= g_falcon_obj_control 30))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "PILOT 2: Top of the canyon, dead ahead.")
	(f_md_object_play 0 NONE m35_1030)

)

(script dormant md_falcon_callout_right_phantom
	(sleep_until (>= g_falcon_obj_control 40))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "PILOT 2: Phantom inbound!  Hang on!")
	(f_md_object_play 0 NONE m35_1020)

)

(script dormant md_falcon_callout_left_wraiths
	;call sooner
	(sleep_until (>= g_falcon_obj_control 40))
	(sleep_until (not b_is_dialogue_playing) 1)
	
	
	(print "PILOT 2: We've got hostile armor across the canyon!")
	(f_md_object_play 0 NONE m35_1120)
	(print "JORGE: Take out those tanks, Six!")
	(f_md_ai_play 0 (object_get_ai obj_jorge) m35_1130)

)


(script dormant md_falcon_callout_nice
	(sleep_until (>= g_falcon_obj_control 50))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "PILOT 2: Nice shooting, Spartans!")
	(f_md_object_play 0 NONE m35_1100)
	(print "JORGE: Stay sharp, Six; we're not out of the canyon yet.")
	(f_md_ai_play 0 (object_get_ai obj_jorge) m35_1110)

)

(script dormant md_falcon_callout_ground
	(sleep_until (>= g_falcon_obj_control 260))
	(sleep_until (not b_is_dialogue_playing) 5)

	(print "JORGE: Engage the ground units!")
	(f_md_ai_play 0 (object_get_ai obj_jorge) m35_1140)

)

(script dormant md_falcon_dome_start
	(sleep_until (>= g_falcon_obj_control 50) 5)
	(sleep 440)
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "PILOT: There's the spire!")
	(f_md_object_play 20 NONE m35_1180)
	
	(wake md_falcon_view_hud)
	(set g_music05 TRUE)
	
	(ai_dialogue_enable FALSE)
	
	(print "CARTER: Solid copy.  Dot?")
	(f_md_object_play 30 NONE m35_1190)
	(print "AUNTIE DOT: Latest intel suggests these spires may be projecting electro-magnetic cloaking shields.")
	(f_md_object_play 25 NONE m35_1200)
	;(print "PILOT: EM could short my  electrical…")
	;(f_md_object_play_cutoff 10 NONE m35_1210)
	(print "JORGE: Priority One, Pilot.  Gotta know what's in there.")
	(f_md_ai_play 0 (object_get_ai obj_jorge) m35_1220)
	(print "PILOT: Affirmative, sir. Here we go...")
	(f_md_object_play 20 NONE m35_1230)
	
	(ai_dialogue_enable TRUE)

)

(script dormant md_falcon_view_hud
	(f_hud_flash_object sc_hud_highlight_spire)
	(f_blip_title sc_hud_spire "WP_CALLOUT_M35_SPIRE")
	
)

(script dormant md_falcon_crash_01
	
		(if dialogue (print "COMMAND (radio): EMP!  My falcon's not responding!"))
		;(md_play 0 sound\dialog\levels\m35\mission\robot\m35_0090_pil.sound)
		(if dialogue (print "COMMAND (radio): We're going down, repeat Echo 21 going down!"))
		;(md_play 30 sound\dialog\levels\m35\mission\robot\m35_0100_pil.sound)
)

(script dormant md_falcon_crash_02

		(if dialogue (print "COMMAND (radio): Brace yourself for impact!"))
		;(md_play 0 sound\dialog\levels\m35\mission\robot\m35_0110_pil.sound)
)

; ===================================================================================================================================================
(script dormant md_spire_start
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(sleep 60)
	(print "JORGE: You all right?  I'm showing hostiles all over the place… We gotta move!")
	(f_md_ai_play 0 gr_jorge m35_1240)
	;(f_md_object_play 0 NONE m35_1240)
	
	(sleep 30)
	(wake md_spire_view)
)

(script dormant md_spire_view
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)
	
	(wake md_spire_view_hud)
	(print "JORGE: Commander, we've got eyes on the spire.  Looks like a staging area…")
	(f_md_ai_play 0 gr_jorge m35_1260)
	;(f_md_object_play 20 NONE m35_1260)
	
	(wake obj_06_spire_start)
	
	(set g_music01 TRUE)
	
	(print "CARTER: Copy.  We have your visual. Dot's working the problem. Standby.")
	(f_md_object_play 0 NONE m35_1270)
	
	(ai_dialogue_enable TRUE)

	(wake md_spire_view02)
)

(script dormant md_spire_view_hud
	(f_hud_flash_object sc_hud_highlight_spire)
	(f_blip_title sc_hud_spire "WP_CALLOUT_M35_SPIRE")
	
)


(script dormant md_spire_jetpack
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "AUNTIE DOT: Be advised, Noble Six: jet-pack armor module available in your vicinity.")
	(f_md_object_play 0 NONE m35_1340)
	(print "JORGE: Six, see if they're operational.")
	(f_md_ai_play 0 gr_jorge m35_1350)
	;(f_md_object_play 0 NONE m35_1350)

	(wake md_spire_view02)
)

(script dormant md_spire_view02
	(sleep_until (>= g_spire_obj_control 3))
	
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(wake spire_phantoms)
	(f_hud_flash_object sc_hud_highlight_spire)
	(f_blip_title sc_hud_spire "WP_CALLOUT_M35_SPIRE")
	
	(ai_dialogue_enable FALSE)
	
	(print "AUNTIE DOT: Noble Five: ONI believes those spires to be teleportation terminals.")
	(f_md_object_play 20 NONE m35_1280)
	(print "JORGE: Teleporters? Linked to what?")
	(f_md_ai_play 70 gr_jorge m35_1290)

	(print "CARTER: Frigate Grafton is on station, ready to kill that spire. But we need the shield powered down first.")
	(f_md_object_play 15 NONE m35_1310)
	(print "JORGE: Understood. Six, I'll hold these bastards off! You find a way to the top of the spire!")
	(f_md_ai_play 0 gr_jorge m35_1320)
	
	(ai_dialogue_enable TRUE)
	
	(set g_music02 TRUE)
	
	;(sleep 60)
	;(wake md_spire_banshee)
)

(script dormant md_spire_banshee
	(sleep_until (not b_is_dialogue_playing) 5)

	(print "JORGE: I spotted a Banshee on the eastern ridge. Could be your ticket up, Six.")
	(f_md_ai_play 0 gr_jorge m35_1360)
	;(f_md_object_play 0 NONE m35_1360)

)

(script dormant md_spire_up
	(sleep_until
		(or
			(volume_test_players tv_spire_grav)
			(>= g_spire_obj_control 4)
		)
	1)
	(sleep_until (not b_is_dialogue_playing) 1)
	(if (not (game_is_cooperative))
		(game_save_immediate)
	)
	
	(ai_dialogue_enable FALSE)
	
	(print "JORGE: Noble Leader: Six is on his/her way up!")
	(if (player_has_female_voice player0)
		(f_md_ai_play 20 gr_jorge m35_1400)
		(f_md_ai_play 20 gr_jorge m35_1390)
	)
	(print "CARTER: Get in there, take out that shield, Lieutenant!")
	(f_md_object_play 0 NONE m35_1410)
	
	(ai_dialogue_enable TRUE)
	(game_save)
	
	(wake obj_07_spire02_start)
	
)

(script dormant md_spire_interior
	(sleep_until (>= g_spire_obj_control 4))
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(ai_dialogue_enable FALSE)

	(print "CARTER: Spartans: I'm en route with a Falcon. We'll extract as soon as you knock out power to that shield!")
	(f_md_object_play 0 NONE m35_1420)
	(print "JORGE: Ready when you are, Six!")
	(f_md_ai_play 30 gr_jorge m35_1430)
	;(f_md_object_play 0 NONE m35_1430)
	(print "CARTER: Hurry, Lieutenant!  We got a frigate inbound to blow that spire soon as the shield's powered down!")
	(f_md_object_play 0 NONE m35_1440)
	
	(ai_dialogue_enable TRUE)
	
	(wake md_spire_button)
)

(script dormant md_spire_button
	(branch
		(>= (device_get_position dc_spire_01) 1)
		(f_md_abort)
	)
	(sleep_until (<= (ai_living_count gr_spire_top_cov) 0))
	(sleep_until (not b_is_dialogue_playing) 5)

	(print "CARTER: Lieutenant! Drop the shield, and get out of there!")
	(f_md_object_play 0 NONE m35_1460)
	
	(f_blip_object dc_spire_01 blip_interface)
	
)

(script static void md_spire_interior_remind
	(sleep_until (not b_is_dialogue_playing) 5)
	
	(print "CARTER: Noble Six, we need to kill that shield and clear the area! Now!")
	(f_md_object_play 0 NONE m35_1450)

)

; =================================================================================================
; M35 Performances
; =================================================================================================
(script static void branch_vig_kill
	(print "branch kill")
)

(script static boolean (branch_spire_elite (ai my_actor)) 
	(or
		(> (object_get_recent_shield_damage (ai_get_object my_actor)) 0)
		(> (object_get_recent_body_damage (ai_get_object my_actor)) 0)
		(>= g_spire_obj_control 5)
		(<= (ai_living_count gr_spire_top_cov) 2)
		(<= (ai_living_count sq_spire_grunt_01) 1)
	)
)
;(sleep_until (branch_spire_elite ai_current_actor))

; ===================================================================================================================================================
; ===================================================================================================================================================
; MUSIC 
; ===================================================================================================================================================
; ===================================================================================================================================================
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

(script dormant music_memory_test
	(sound_looping_stop levels\solo\m35\music\m35_music_01)
	(sound_looping_stop levels\solo\m35\music\m35_music_02)
	(sound_looping_stop levels\solo\m35\music\m35_music_03)
	(sound_looping_stop levels\solo\m35\music\m35_music_04)
	(sound_looping_stop levels\solo\m35\music\m35_music_05)
	(sound_looping_stop levels\solo\m35\music\m35_music_06)
	(sound_looping_stop levels\solo\m35\music\m35_music_07)
	(sound_looping_stop levels\solo\m35\music\m35_music_08)
	(sound_looping_stop levels\solo\m35\music\m35_music_09)
	(sound_looping_stop levels\solo\m35\music\m35_music_10)
	(sound_looping_stop levels\solo\m35\music\m35_music_11)
	(sound_looping_stop levels\solo\m35\music\m35_music_12)
	(sound_looping_stop levels\solo\m35\music\m35_music_13)
	
)

(script dormant music_hill
	(print "music_hill")
	;(sound_looping_start levels\solo\m35\music\m35_music_01 NONE 1)
	
	(sleep_until g_music01 5)
	(print "music change: Objective Neutralize Enemy AA")
	(sound_looping_stop levels\solo\m35\music\m35_music_01)
	(sound_looping_start levels\solo\m35\music\m35_music_02 NONE 1)
	
)

(script dormant music_twin
	(print "music_twin")
	(reset_music_var_go)

	(sleep_until g_music02 5)
	(print "music change: visual range")
	(sound_looping_stop levels\solo\m35\music\m35_music_02)
	
	(sleep_until g_music03 5)
	(print "music change: Objective Advance Into Enemy Territory")
	(sound_looping_start levels\solo\m35\music\m35_music_03 NONE 1)
	
)


(script dormant music_facility
	(print "music_facility")
	(reset_music_var_go)
	
	(sleep_until g_music01 5)
	(print "music change: Objective Secure Mining Facility")
	(sound_looping_stop levels\solo\m35\music\m35_music_03)
	
	(sleep_until g_music02 5)
	(print "music change: keep moving towards the spires")
	(sound_looping_start levels\solo\m35\music\m35_music_04 NONE 1)
	
	(sleep_until g_music03 5)
	(print "music change: reach the area with the vehicles")
	(sound_looping_stop levels\solo\m35\music\m35_music_04)
	
)

(script dormant music_cannon
	(print "music_cannon")
	(reset_music_var_go)
	
	(sleep_until g_music01 5)
	(print "music change: Objective Neutralize AA Gun")
	(sound_looping_start levels\solo\m35\music\m35_music_05 NONE 1)
	
	(sleep_until g_music02 5)
	(print "music change: kill wraith or hunter")
	(sound_looping_activate_layer levels\solo\m35\music\m35_music_05 1)
	
	(sleep_until g_music03 5)
	(print "music change: destroy AA gun")
	(sound_looping_stop levels\solo\m35\music\m35_music_05)
	
)


(script dormant music_falcon
	(print "music_falcon")
	(reset_music_var_go)
	
	(sleep_until g_music04 5)
	(print "music change: The Spire")
	(sound_looping_start levels\solo\m35\music\m35_music_06 NONE 1)
	
	(sleep_until g_music05 5)
	(print "music change: there's the spire")
	(sound_looping_stop levels\solo\m35\music\m35_music_06)
	
)


(script dormant music_spire
	(print "music_spire")
	(reset_music_var_go)
	
	(sleep_until g_music01 5)
	(print "music change: ")
	(sound_looping_stop levels\solo\m35\music\m35_music_07)
	
	(sleep_until g_music02 5)
	(print "music change: find a way to the top of the spire")
	(sound_looping_start levels\solo\m35\music\m35_music_08 NONE 1)
	
	(sleep_until g_music03 5)
	(print "music change: top of the spire")
	(sound_looping_start levels\solo\m35\music\m35_music_09 NONE 1)
	
	(sleep_until g_music04 5)
	(print "music change: hit the button drop shield")
	(sound_looping_stop levels\solo\m35\music\m35_music_09)
	
)


(script dormant music_alpha
	(print "music_alpha")
	(reset_music_var_go)
	
	(print "music change: Rally Point Alpha")
	(sound_looping_start levels\solo\m35\music\m35_music_03 NONE 1)
	
)


(script dormant music_bravo
	(print "music_bravo")
	(reset_music_var_go)
	
	(print "music change: Rally Point Beavo")
	(sound_looping_start levels\solo\m35\music\m35_music_10 NONE 1)
	
	(sleep_until g_music_ins 5)
	(print "music change: I'm highlighting the lz now")
	(sound_looping_start levels\solo\m35\music\m35_music_11 NONE 1)
	
	(sleep_until g_music01 5)
	(print "music change: The Spire")
	(sound_looping_stop levels\solo\m35\music\m35_music_10)
	(sound_looping_stop levels\solo\m35\music\m35_music_11)

)


;Spartan waypoints ===========================================================================================

(script dormant spartan_waypoints_hill
	
	(f_hud_spartan_waypoint (object_get_ai obj_kat) kat_name 60)
)

(script dormant spartan_waypoints_falcon
	(f_hud_spartan_waypoint (object_get_ai obj_jorge) jorge_name 60)
)

(script dormant spartan_waypoints_spire
	(f_hud_spartan_waypoint (object_get_ai obj_jorge) jorge_name 60)
)


; =================================================================================================
; M35 OBJECTIVES
; =================================================================================================

(script dormant obj_00_engage_start
	(f_hud_obj_new ct_objective_0 PRIMARY_OBJECTIVE_0)
)

(script dormant obj_01_aa01_start
	(f_hud_obj_new ct_objective_1 PRIMARY_OBJECTIVE_1)
)

(script dormant obj_11_aa01b_start
	(f_hud_obj_new ct_objective_1 PRIMARY_OBJECTIVE_11)
)

(script dormant obj_02_adv01_start
	(f_hud_obj_new ct_objective_2 PRIMARY_OBJECTIVE_2)
)

(script dormant obj_03_facility_start
	(f_hud_obj_new ct_objective_3 PRIMARY_OBJECTIVE_3)
)

(script dormant obj_04_aa02_start
	(f_hud_obj_new ct_objective_4 PRIMARY_OBJECTIVE_4)
)

(script dormant obj_05_falcon_start
	(f_hud_obj_new ct_objective_0 PRIMARY_OBJECTIVE_0)
)

(script dormant obj_05_falcon02_start
	(f_hud_obj_new ct_objective_5 PRIMARY_OBJECTIVE_5)
)

(script dormant obj_06_spire_start
	(f_hud_obj_new ct_objective_6 PRIMARY_OBJECTIVE_6)
)

(script dormant obj_07_spire02_start
	(f_hud_obj_new ct_objective_7 PRIMARY_OBJECTIVE_7)
)


; =================================================================================================
; CHAPTER TITLES
; =================================================================================================
(script dormant chapter_01_start
	(sleep 30)
	(f_hud_chapter chapter_01)
)

(script dormant chapter_02_start
	(f_hud_chapter chapter_02)
)

(script dormant chapter_03_start
	(set g_music04 TRUE)
	(f_hud_chapter chapter_03)
)
