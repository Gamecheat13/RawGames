; -------------------------------------------------------------------------------------------------
; MUSIC
; -------------------------------------------------------------------------------------------------
(global looping_sound mus_01 levels\solo\m45\music\m45_music_01.sound_looping)
(global looping_sound mus_02 levels\solo\m45\music\m45_music_02.sound_looping)
(global looping_sound mus_03 levels\solo\m45\music\m45_music_03.sound_looping)
(global looping_sound mus_04 levels\solo\m45\music\m45_music_04.sound_looping)
(global looping_sound mus_05 levels\solo\m45\music\m45_music_05.sound_looping)
(global looping_sound mus_06 levels\solo\m45\music\m45_music_06.sound_looping)
(global looping_sound mus_07 levels\solo\m45\music\m45_music_07.sound_looping)
(global looping_sound mus_08 levels\solo\m45\music\m45_music_08.sound_looping)
(global looping_sound mus_09 levels\solo\m45\music\m45_music_09.sound_looping)
(global looping_sound mus_10 levels\solo\m45\music\m45_music_10.sound_looping)

; SFX
; -------------------------------------------------------------------------------------------------
(global effect fx_warp_flash objects\vehicles\covenant\seraph\fx\warp\warp.effect)
(global sound sfx_warp sound\vehicles\seraph\seraph_slip_space.sound)
(global looping_sound sfx_chatter sound\prototype\radio_chatter\radio_chatter_loop\radio_chatter_loop.sound_looping)
; -------------------------------------------------------------------------------------------------

(script static void (mus_start (looping_sound s))
	(if playmusic (sound_looping_start s NONE 1)))
	
(script static void (mus_stop (looping_sound s))
	(sound_looping_stop s))
	
(script static void (mus_alt (looping_sound s))
	(sound_looping_set_alternate s true))
	
(script static void (mus_kill (looping_sound s))
	(sound_looping_stop_immediately s))

(script static void sfx_attach_chatter
	(sound_looping_start sfx_chatter (player0) 1.0))
	
(script static void sfx_detach_chatter
	(sound_looping_stop sfx_chatter))
	
(script static void mus_kill_all
	(mus_kill mus_01)
	(mus_kill mus_02)
	(mus_kill mus_03)
	(mus_kill mus_04)
	(mus_kill mus_05)
	(mus_kill mus_06)
	(mus_kill mus_07)
	(mus_kill mus_08)
	(mus_kill mus_09)
	(mus_kill mus_10)
)
	
; -------------------------------------------------------------------------------------------------
; MISSION DIALOGUE MAIN
; -------------------------------------------------------------------------------------------------
(global boolean b_dialogue_playing false)
(global short s_md_duration 0)
; -------------------------------------------------------------------------------------------------
(script static void (md_play (short delay) (sound line))
	(sleep delay)
	(sound_impulse_start line NONE 1)
	(sleep (sound_impulse_language_time line)))

(script static void (md_print (string line))
	(if dialogue (print line)))
	
(script static void md_start
	(sleep_until (not b_dialogue_playing) 1)
	(ai_dialogue_enable false)
	(set b_dialogue_playing TRUE))
	
(script static void md_stop
	(set b_dialogue_playing FALSE)
	(ai_dialogue_enable true))

(script static void (md_ai_play (short delay) (ai char) (ai_line line))
	(set s_md_duration (ai_play_line char line))
	(sleep s_md_duration)
	(sleep delay)
)

(script static void (md_object_play (short delay) (object obj) (ai_line line))
	(set s_md_duration (ai_play_line_on_object obj line))
	(sleep s_md_duration)
	(sleep delay)
)

(script static void md_abort
	(if debug (print "dialogue script aborted!"))
	(sleep 30)
	(md_stop)
)

; -------------------------------------------------------------------------------------------------
; MISSION DIALOGUE
; -------------------------------------------------------------------------------------------------
(global short s_md_reminder_wait		(* 30 60))	; how long we initially wait to remind the player to move on
(global short s_md_reminder_interval 	(* 30 45)) 	; how long we wait to remind the player again

; AI
(global ai ai_carter 			none)
(global ai ai_kat 				none)
(global ai ai_jorge 			none)
(global ai ai_airboss			none)
(global ai ai_tr1				none)
(global ai ai_tr2				none)
(global ai ai_tr3				none)
(global ai ai_tr4				none)
(global ai ai_tr5				none)
(global ai ai_tf1				none)
(global ai ai_tf2				none)	; boarding party
(global ai ai_fac_tr_door 		none)
(global ai ai_fac_tr_wraith 	none)
(global ai ai_fac_tr_mg 		none)
(global ai ai_slo_tr_stairs		none)
; -------------------------------------------------------------------------------------------------

; BEACH
; -------------------------------------------------------------------------------------------------
(script dormant md_bch_jor_intro
	(md_start)
		
		(md_print "JORGE: Bit of a hike to the launch facility")
		(md_ai_play 0 ai_jorge m45_0010)
		
		(md_print "CARTER: Any closer's too hot to land.")
		(md_ai_play 0 ai_carter m45_0020)
	
	(md_stop)
	
	;(new_mission_objective ct_obj_beach PRIMARY_OBJECTIVE_1)
	(wake show_objective_beach)
	(sleep (random_range 60 90))
)

(script dormant md_bch_kat_calls_phantom
	(md_start)
		
		(md_print "KAT: Phantom. East. One five zero!")		
		(md_ai_play 0 ai_kat m45_0030)
			
		(md_print "CARTER: Move up the beach, Noble.")
		(md_ai_play 0 ai_carter m45_0040)
		
	(md_stop)
)

(script dormant md_bch_kat_launch_ahead
	(md_start)
	
		(md_print "KAT: Launch facility dead ahead.")
		(md_ai_play 0 ai_kat m45_0050)
		
	(md_stop)
)

(script dormant md_bch_jor_friendlies_taking
	(md_start)
	
		(md_print "JORGE: Friendlies taking fire!")
		(md_ai_play 0 ai_jorge m45_0060)
		
		(md_print "CARTER: Six, you're on point.")
		(md_ai_play 0 ai_carter m45_0070)
		
	(md_stop)
)

(script dormant md_bch_car_six_on_point
	(md_start)
	
		(md_print "CARTER: Six, you're on point.")
		(md_ai_play 0 ai_carter m45_0070)
	
	(md_stop)
)

(script dormant md_bch_jor_hostile_rocks_south
	(md_start)
	
		(md_print "JORGE: More hostiles in the rocks to the south!")
		(md_ai_play 20 ai_jorge m45_0080)
		
		(md_print "CARTER: Root'em out!")
		(md_ai_play 0 ai_carter m45_0090)
	
	(md_stop)
)

(script dormant md_bch_trf_spartans_coming
	(branch
		(= b_lnc_started true) (md_abort)
	)
	
	(sleep_until
		(or
			(<= (objects_distance_to_object (ai_actors gr_unsc_spartans) (ai_get_object sq_unsc_bch_tf0)) 4.5)
			(<= (objects_distance_to_object (players) (ai_get_object sq_unsc_bch_tf0)) 4.5)
		)
	)
	

	(md_start)
	
		(md_print "FEMALE TROOPER: Spartans coming in! Watch your fire!")
		;(md_ai_play 0 sq_unsc_bch_tr_door0_female m45_0100)
		(md_ai_play 0 sq_unsc_bch_tf0/trooper0 m45_0100)
		
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; FACILITY
; -------------------------------------------------------------------------------------------------
(global ai ai_facility_escort none)
(script dormant md_fac_tr_everybody_inside
	(branch
		(>= s_objcon_fac 10) (branch_abort_dialogue)
	)
	
	
	(md_start)
		
		(sleep 60)
			
		(vs_cast sq_unsc_fac_tr_lead FALSE 10 m45_0110)
		(set ai_facility_escort (vs_role 1))
		
		(md_print "TROOPER: Everybody inside! More hostiles on the way!")
		(md_ai_play 30 ai_facility_escort m45_0110)
		
		(md_print "CARTER: Inside, Six. Let's go.")
		(md_ai_play 0 ai_carter m45_0220)
		
	(md_stop)
	
	(wake md_fac_entrance_reminder)
)

(script dormant md_fac_tr_inside_now
	(branch
		(= b_fac_started true) (branch_abort_dialogue)
	)
	
	(md_start)
	
		(vs_cast sq_unsc_fac_tr_lead FALSE 10 m45_0120)
		(set ai_facility_escort (vs_role 1))
		
		(md_print "TROOPER: Inside! Now! We've got to seal this entrance!")
		;(md_ai_play 0 sq_unsc_fac_tr_lead m45_0120)
		(md_ai_play 0 ai_facility_escort m45_0120)

	(md_stop)
)

(script dormant md_fac_car_move_inside
	(md_start)
	
		(md_print "CARTER: Noble Six, move inside!")
		(md_ai_play 0 ai_carter m45_0130)
		
	(md_stop)
)

(script dormant md_fac_entrance_reminder
	(branch
		(or (>= s_objcon_fac 40) (= b_lnc_started true)) (branch_abort_fac_reminder)
	)
	
	(if debug (print "facility: reminder started for entering facility..."))
	(sleep (* 30 30))
	
	(if (not (>= s_objcon_fac 20))
		(wake md_fac_tr_inside_now))
		
	(sleep (* 30 60))
	
	(if (not (>= s_objcon_fac 20))
		(wake md_fac_tr_clocks_ticking))
		
	(sleep s_md_reminder_interval)
	
	(sleep_until
		(begin
			(if (not (>= s_objcon_fac 20))
				(begin 
					(wake md_fac_car_move_inside)
					(sleep (* 30 180))))
					
			(if (not (>= s_objcon_fac 20))
				(begin 
					(md_fac_car_enter_reminder)
					(sleep (* 30 180))))		

			
		(>= s_objcon_fac 20))
	)
	
)

(script static void branch_abort_fac_reminder
	(sleep 60)
	(branch_abort_dialogue)
)

(script dormant md_fac_spkr_warning1
	(md_print "SPEAKER: Warning! Launch facility breach! Covenant forces have entered the base!")
	(md_object_play 0 NONE m45_0140)
	
	(sleep (random_range 210 360))
	
	(md_print "SPEAKER: Warning! Launch facility has been -- *static*")
	(md_object_play 0 NONE m45_0150)
	
)


(script dormant md_fac_tr_flight_control
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
		
	
	(vs_cast sq_unsc_fac_tr_lead FALSE 10 m45_0160)
	(set ai_facility_escort (vs_role 1))
	
	(md_start)
		
		(sleep 40) 	
			
		(md_print "TROOPER: Flight control is this way. They're expecting you.")
		(md_ai_play 20 ai_facility_escort m45_0160)
				
	(md_stop)
	
	(wake show_objective_flight_control)
)

(script dormant md_fac_jor_holland_said_yes
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
	
	
	(md_start)
		
		(sleep 30)
	
		(md_print "JORGE: Still can't believe Holland said yes to this.")
		(md_ai_play 30 ai_jorge m45_0170)
		
		(md_print "KAT: Some plans are too go to say no.")
		(md_ai_play 20 ai_kat m45_0180)
		
		(md_print "CARTER: Let's get that sabre airborne before he changes his mind.")
		(md_ai_play 0 ai_carter m45_0190)
		
	(md_stop)
)

(global ai ai_facility_rocketguy none)
(script dormant md_fac_tr_calls_wraith
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
	
	(sleep 20)
	
	(if (bch_wraith_is_alive)
		(begin
			(md_start)
			
				(vs_cast sq_unsc_fac_tr_rocketcrew/rocketcrew0 false 10 m45_0200)
				(set ai_facility_rocketguy (vs_role 1))
				
				(md_print "TROOPER: We got a Wraith on the lower platform!")
				(md_ai_play 0 ai_facility_rocketguy m45_0200)
				
			(md_stop)
		)
	)
)

(script dormant md_fac_tr_clocks_ticking
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
	
	(vs_cast sq_unsc_fac_tr_lead FALSE 10 m45_0210)
	(set ai_facility_escort (vs_role 1))
	
	(md_start)
		
		(md_print "TROOPER: Clock's ticking, Spartans. We need to keep pushing to flight control.")
		(md_ai_play 0 sq_unsc_fac_tr_lead m45_0210)

	(md_stop)
)

(script static void md_fac_car_enter_reminder
	(md_start)
	
		(md_print "CARTER: Inside, Six. Let's go.")
		(md_ai_play 0 ai_carter m45_0220)
		
	(md_stop)
)
(script dormant md_fac_car_inside_six
	(md_start)
	
		(md_print "CARTER: Inside, Six. Let's go.")
		(md_ai_play 0 ai_carter m45_0220)
		
	(md_stop)
)

(script dormant md_fac_kat_orbit
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
	
	
	(md_start)
	
		(md_print "KAT: Boss, when we get into orbit...")
		(md_ai_play 0 ai_kat m45_0230)
		
		(md_print "CARTER: Not now, Kat.")
		(md_ai_play 30 ai_carter m45_0240)
		
		(md_print "KAT: But shouldn't we iron out the --")
		(md_ai_play 5 ai_kat m45_0250)
		
		(md_print "CARTER: It was your plan, but it's Holland's show.")
		(md_ai_play 15 ai_carter m45_0260)
		
	(md_stop)
)

(script dormant md_fac_tr_be_coming
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
	
	;(md_start)
		
		(md_print "TROOPER: They'll be coming from this way.")
		(md_ai_play 0 sq_unsc_fac_tr_hallgunners/gunner m45_0270)
		
	;(md_stop)
)

(script dormant md_fac_tr_clear_los
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
	
	;(md_start)
	
	(sleep_until (<= (objects_distance_to_object (players) (ai_get_object sq_unsc_fac_posthallway/trooper0)) 3) 10)
		
		(md_print "TROOPER: Get a clear LOS down the corridor. Split-jaws'll be here any second...")
		(md_ai_play 0 sq_unsc_fac_posthallway/trooper0 m45_0280)
		
	;(md_stop)
)

(script dormant md_fac_tr_through_door
	(branch
		(= b_lnc_started true) (branch_abort_dialogue)
	)
	
	(md_start)
	
		(md_print "TROOPER: Control's right through that door, Commander.")
		(md_ai_play 0 sq_unsc_fac_tr_lead m45_0290)
		
	(md_stop)
	
	(sleep (* 30 45))
	(ai_migrate sq_unsc_fac_tr_lead sq_unsc_bch_reinforce_holding0)
)

(script dormant md_fac_car_you_first_six
	(md_start)
		
		(md_print "CARTER: You first, Six.")
		(md_ai_play 0 ai_carter m45_0300)
		
	(md_stop)
)

(script dormant md_fac_car_get_in_control_room
	(md_start)
		
		(md_print "CARTER: Noble Six, get in the control room.")
		(md_ai_play 0 ai_carter m45_0310)
	
	(md_stop)
)

(script dormant md_fac_car_control_room_now
	(md_start)
	
		(md_print "CARTER: Lieutenant, in the control room. Now.")
		(md_ai_play 0 ai_carter m45_0320)
		
	(md_stop)
)
;*
(script dormant md_fac_fco_greets_carter
	(md_start)
	
		(md_print "AIRBOSS: Commander Carter, you made it.")
		;(md_ai_play 0 sq_unsc_fac_tr_boss m45_0330)
		(md_object_play 0 NONE m45_0330)
		
		(md_print "CARTER: Major. You're been briefed?")
		(md_ai_play 0 ai_carter m45_0340)
		
		(md_print "AIRBOSS: Colonel Holland filled me in. A major Covenant force is inbound this location. We don't have much time.")
		;(md_ai_play 0 sq_unsc_fac_tr_boss m45_0350)
		(md_object_play 0 NONE m45_0350)
		
		(md_print "CARTER: What do you need from us?")
		(md_ai_play 0 ai_carter m45_0360)
		
		(md_print "AIRBOSS: A quick biometric scan from your flight crew and we'll get the launch underway. Scanner's right over there.")
		;(md_ai_play 0 sq_unsc_fac_tr_boss m45_0370)
		(md_object_play 0 NONE m45_0370)
		
		
		
	(md_stop)
	
	(wake md_fac_scn_checkpoint_ready)
	;(wake fac_biometric_scan)
	(wake md_fac_ask)
)


(script dormant md_fac_fco_step_up
	(md_start)
		
		(md_print "AIRBOSS: Step up to the scanner, Lieutenant.")
		(md_ai_play 0 sq_unsc_fac_tr_boss m45_0380)
	
	(md_stop)
)

(script dormant md_fac_car_you_heard_him
	(md_start)
		
		(md_print "CARTER: You heard him, Six. Get scanned.")
		(md_ai_play 0 ai_carter m45_0390)
		
	(md_stop)
)

(script dormant md_fac_car_use_scanner
	(md_start)
	
		(md_print "CARTER: Noble Six, use the scanner.")
		(md_ai_play 0 ai_carter m45_0400)
		
	(md_stop)
)

(script dormant md_fac_scn_checkpoint_ready
	(md_start)
		
		(md_print "SECURITY AI: This security checkpoint is ready. Please remain still for biometric identity confirmation.")
		(md_object_play 0 NONE m45_0410)
			
	(md_stop)
)

(script dormant md_fac_scn_player_confirmed
	(md_start)
		
		(md_print "SECURITY AI: Spartan 312 confirmed. Clearance for primary flight system operations verified.")
		(md_print "SECURITY AI: Synching spacecraft controls to your bio-stats. Thank you.")
		;(md_ai_play 0 sq_scanner m45_0420_sab)
	
	(md_stop)
)

(script dormant md_fac_car_youre_next_jorge
	(md_start)
	
		(md_print "CARTER: You're next, Jorge.")
		(md_ai_play 0 ai_carter m45_0430)
	
	(md_stop)
)

(script dormant md_fac_ask
	(md_start)
	
		(sleep 60)
	
		(md_print "KAT: Sir?")
		(md_ai_play 0 ai_kat m45_0440)
	
		(md_print "KAT: This is MY plan. If anyone's in that second seat, it should be me.")
		(md_ai_play 0 ai_kat m45_0450)
		
		(md_print "CARTER: Decision's made. I still got surface ops to run, and I need my comms officer.")
		(md_ai_play 0 ai_carter m45_0460)
		
	(md_stop)
)
*;
(script dormant md_fac_scn_jorge_confirmed
	(md_start)
		
		(md_print "SECURITY AI: Spartan 052 identified. M-Spec biometric sync confirmed. Thank you.")
		;(md_ai_play 0 sq_scanner m45_0470_sab)
		
	(md_stop)
)

(script static void md_fac_jor_calms_kat
	(md_start)
	
		(md_print "JORGE: Kat...")
		(md_ai_play 0 ai_jorge m45_0480)
		
		(md_print "KAT: Forget it, Jorge. Just blow that super carrier out of the sky.")
		(md_ai_play 0 ai_kat m45_0490)
		
		(md_print "JORGE: Do my best.")
		(md_ai_play 0 ai_jorge m45_0500)
		
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; LAUNCH
; -------------------------------------------------------------------------------------------------
(script dormant md_lnc_bay_breach
	(md_start)
	
		(md_print "SPEAKER: Warning, launch bay breach. Warning, launch bay breach.")
		(md_object_play 0 NONE m45_0510)
		
	(md_stop)
	
)

;*

(script dormant md_lnc_fco_phantom_in_bay
	(md_start)
		
		(md_print "AIRBOSS: Phantom in the launch bay!")
		(md_ai_play 0 sq_unsc_fac_tr_boss m45_0520)
		
	(md_stop)
)
*;

(global boolean b_lnc_bombing_started false)
(script dormant md_lnc_car_get_to_sabre
	(branch
		(= b_lnc_player_in_sabre true) (md_abort)
	)
	
	(sleep_until (>= (device_get_position dm_slo_shutter) 1) 1)
	
	;(set b_slo_bombing_completed true)
	(set b_lnc_bombing_started true)
	(trigger_bombing_heavy)
	(sleep (random_range 20 35))
	
	(md_start)
	
		(md_print "CARTER: Six, Jorge, get to the Sabre before the Covenant wreck it.")
		(md_ai_play 15 ai_carter m45_0530)
		
		;(new_mission_objective 3 ct_obj_launch)
		
		
		;(thespian_performance_kill_by_name "vig_airboss_jorge")
		;(ai_set_objective sq_jorge obj_unsc_lnc)
		
		(md_print "JORGE: What about you and Kat?")
		(md_ai_play 20 ai_jorge m45_0540)
		
		(md_print "CARTER: Jun's on his way with a Falcon. We'll exfil after you launch. Move!")
		(md_ai_play 20 ai_carter m45_0550)
		
				(thespian_performance_kill_by_name thespian_controlroom_jorge)
				(sleep 1)
				(thespian_performance_setup_and_begin thespian_launch_jorge "" 0)
				
		(md_print "JORGE: You heard him, Six. Let's go.")
		(md_ai_play 0 ai_jorge m45_0560)
		
		;(ai_set_objective sq_jorge obj_unsc_lnc)
		
		(if (not b_lnc_player_in_sabre)
			(begin
				(wake show_objective_launch)
				(f_blip_flag fl_launch 21)
		
				(thespian_performance_kill_by_name thespian_controlroom_kat)
				(thespian_performance_kill_by_name thespian_controlroom_carter)
				
				(sleep 1)
				
				(cs_run_command_script ai_kat cs_lnc_kat_post)
				(cs_run_command_script ai_carter cs_lnc_carter_post)
			)
		)
	
	(md_stop)
)

(script dormant md_lnc_tr5_through_north_1
	(md_start)
	
		(md_print "TROOPER: Through north doorway, Spartans. We got your back.")
		(md_ai_play 0 ai_tr5 m45_0570)
		
	(md_stop)
)

;*
(script dormant md_lnc_tr2_through_north_2
	(md_start)
	
		(md_print "TROOPER: Through the north doorway, Spartans. We got your back.")
		(md_ai_play 0 ai_tr2 m45_0580)
		
	(md_start)
)
*;
(script dormant md_lnc_tf1_through_north_3
	(md_start)
			
		(md_print "TROOPER FEMALE: Through the north doorway, Spartans. We got your back.")
		(md_ai_play 0 ai_tf1 m45_0590)
			
	(md_stop)
)

(script dormant md_lnc_fco_sabre_prepped
	(md_start)
	
		(md_print "AIRBOSS: Launch team, Sabre is prepped and ready for launch.")
		(md_ai_play 0 sq_unsc_fac_tr_boss m45_0600)
		
	(md_stop)
)

(script dormant md_lnc_car_hurry_up
	(md_start)
	
		(md_print "CARTER: Hurry up, Noble. We can't hold them off forever.")
		(md_ai_play 0 ai_carter m45_0610)
		
	(md_stop)
)


(script dormant md_lnc_fco_sabres_ready
	(md_start)
	
		(md_print "AIRBOSS: Sabre's ready, launch team. Just waiting for you to get into position.")
		(md_ai_play 0 sq_unsc_fac_tr_boss m45_0620)
		
	(md_stop)
)

(script dormant md_lnc_car_hustle
	(md_start)
	
		(md_print "CARTER: Hustle, Six. Our launch window is closing.")
		(md_ai_play 0 ai_carter m45_0630)
		
	(md_stop)
)

(script dormant md_lnc_car_get_move_on
	(md_start)
	
		(md_print "CARTER: Move, Spartans. If that Sabre gets hit, this mission is over.")
		(md_ai_play 0 ai_carter m45_0640)
		
	(md_stop)
)

;*
(script dormant md_lnc_tr_take_stairs_1
	(md_start)
	
		(md_print "TROOPER: Right through here. Take these stairs.")
		;(md_ai_play 0 sq_trooper m45_0650)
		
	(md_stop)
)

(script dormant md_lnc_tr_take_stairs_2
	(md_start)
	
		(md_print "TROOPER: Right through here. Take these stairs.")
		;(md_ai_play 0 sq_trooper 045_0660)
		
	(md_stop)
)

(script dormant md_lnc_trf_take_stairs_3
	(md_start)
	
		(md_print "TROOPER FEMALE: Right through here. Take these stairs.")
		;(md_ai_play 0 sq_trooper_female 045_0670)
		
	(md_stop)
)
*;

(script dormant md_lnc_jor_at_sabre
	(md_start)
	
		(md_print "JORGE: We're at the Sabre now, Commander.")
		(md_ai_play 0 ai_jorge m45_0680)
		
		(md_print "CARTER: Copy, five. We see you.")
		(md_ai_play 0 ai_carter m45_0690)
				
		(md_print "JORGE: After you, ace.")
		(md_ai_play 0 ai_jorge m45_0700)
		
	(md_stop)
	
	(wake md_lnc_sabre_reminder)
)

(script dormant md_lnc_sabre_reminder
	(if debug (print "launch: reminder started for entering the sabre..."))
	(sleep s_md_reminder_wait)
	(sleep_until
		(begin
			(if (not b_lnc_player_in_sabre)
				(md_lnc_jor_you_first))
			(sleep s_md_reminder_interval)
		b_lnc_player_in_sabre)
	)
)

(script static void md_lnc_jor_you_first
	(md_start)
	
		(md_print "JORGE: You first, Six. I'm just a passenger on this leg.")
		(md_ai_play 0 ai_jorge m45_0710)
		
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; WAFER
; -------------------------------------------------------------------------------------------------
(script static void md_waf_hol_intro
	(md_start)
	
		(md_print "HOLLAND: Noble actual to Sabre B-029, over.")
		(md_object_play 20 NONE m45_0720)
		
		(md_print "JORGE: Copy, actual. Colonel Holland?")
		(md_object_play 15 NONE m45_0730)
		
		(md_print "HOLLAND: Affirmative. I'll be your control from here on out. Safer that way.")
		(md_object_play 20 NONE m45_0740)
		
		(md_print "JORGE: Understood, Colonel.")
		(md_object_play 0 NONE m45_0750)
		
	(md_stop)
)

(script static void md_waf_jor_contacts
	(md_start)

		(md_print "JORGE: Multiple unidentified contacts!")
		(md_object_play 15 NONE m45_0840)
		
		(md_print "SAVANNAH: Savannah actual to Sabre team, be advised we have bogeys inbound.")
		(md_object_play 25 NONE m45_0850)
	
		(md_print "ANCHOR 9: Anchor 9 to all UNSC ships, station defenses are down. Requesting combat support until we can bring them back online.")
		(md_object_play 20 NONE m45_2200)
		
		(md_print "JORGE: Here we go, Six. Show them what you can do.")
		(md_object_play 0 NONE m45_0860)
		
	(md_stop)
)

(script dormant md_waf_sav_skies_clear
	(md_start)
	
		;(md_print "SAVANNAH: Savannah actual to Sabre team, skies are clear. You are --")
		;(md_object_play 0 NONE m45_0870)
	
		(md_print "ANCHOR 9 ACTUAL: Anchor niner to all craft in the vicinity. Be advised, we show a large attack force inbound.")
		(md_print "ANCHOR 9 ACTUAL: Combat air patrol and Sabre teams are directed to defend the station.")
		(md_object_play 45 NONE m45_0890)
		
		
		
		(md_print "JORGE: Is there any place the Covenant isn't?")
		(md_object_play 10 NONE m45_0910)
		
	(md_stop)
)

(script dormant md_waf_an9_warning_fighter
	(md_start)
	
		(md_print "ANCHOR 9 ACTUAL: Anchor 9 to UNSC ships, impulse drive signatures detected. Fighter class. Heads up, Sabres!")
		(md_object_play 0 NONE m45_0920)
	
	(md_stop)
	
	(mus_stop mus_05)
	(mus_start mus_06)
)

(script static void md_waf_an9_warning_warning_bogeys
	(md_start)
	
		(md_print "ANCHOR 9 ACTUAL: Anchor 9 to UNSC ships, inbound Covenant bogeys. Combat air patrol, align on intercept vector to inbound enemy craft.")
		(md_object_play 0 NONE m45_0930)
		
	(md_stop)
	
	
)


(script dormant md_waf_an9_warning_signatures
	(md_start)

		(md_print "ANCHOR 9 ACTUAL: Anchor 9 to UNSC ships, scan's detecting multiple inbound signatures. Heading 126.")
		(md_object_play 0 NONE m45_0940)
	
	(md_stop)
)

(script dormant md_waf_an9_warning_phantom
	(md_start)
	
		(md_print "ANCHOR 9 ACTUAL: Phantom! Take it out, Sabre teams.")
		(md_object_play 0 NONE m45_0950)
		
	(md_stop)
)

(script dormant md_waf_an9_scrambling_reserves
	(md_start)
	
		(md_print "ANCHOR 9 ACTUAL: Scrambling reserve Sabre squadron. That's all we got left.")
		(md_object_play 0 NONE m45_0960)
		
	(md_stop)
)

(script static void md_waf_an9_defenses_down
	(md_start)

		(md_print "ANCHOR 9: Anchor 9 to all UNSC ships, station defenses are down. Requesting combat support until we can bring them back online.")
		(md_object_play 0 NONE m45_2200)
	
	(md_stop)
)

(script dormant md_waf_an9_batteries_at_56
	(md_start)

		(md_print "ANCHOR 9: Defensive batteries are at 56 percent. Hang in there, Sabre teams.")
		(md_object_play 0 NONE m45_2210)
	
	(md_stop)
)

(script dormant md_waf_an9_batteries_at_79
	(sleep (random_range (* 30 10) (* 30 20)))
	(md_start)

		(md_print "ANCHOR 9: Defensive batteries at 79 percent. Buy us another minute Sabre teams!")
		(md_object_play 0 NONE m45_2220)
	
	(md_stop)
)

(script dormant md_waf_an9_station_defenses_online
	(sleep (random_range (* 30 12) (* 30 15)))
	(md_start)

		(md_print "ANCHOR 9: Anchor 9 to all UNSC ships, station defenses are back online. Clear the lane. We'll light'em up.")
		(md_object_play 0 NONE m45_2230)
		
	(md_stop)
	
	(cs_run_command_script sq_unsc_waf_aa cs_abort)
)


; -------------------------------------------------------------------------------------------------
(script static void md_waf_an9_phantoms_arrived
	(md_start)

		(md_print "ANCHOR 9: Anchor 9 to all UNSC fighters: multiple inbound Phantoms -- headed straight for our defensive batteries.")
		(md_object_play 20 NONE m45_2240)
	
		(md_print "ANCHOR 9: Sabre teams, we're marking high-value gunboat targets... now!")
		(md_object_play 30 NONE m45_2250)
		
		;(md_print "SAVANNAH: Copy Anchor niner. Get get'em, Sabres.")
		;(md_object_play 45 NONE m45_0900)
		
	(md_stop)
)


(script static void md_waf_an9_intercept_gunboats
	(md_start)
	
		(md_print "ANCHOR 9: All UNSC ships: intercept gunboat-class Phantoms. Hit those markers!")
		(md_object_play 0 NONE m45_2260)
		
	(md_stop)
)

; -------------------------------------------------------------------------------------------------
(script static void md_waf_incoming_phantoms_inbound
	(begin_random_count 1
		(md_waf_an9_phantoms_inbound_vector)
		(md_waf_an9_phantoms_forward))
		
	(mus_stop mus_06)
)

(script static void md_waf_an9_phantoms_inbound_vector
	(md_start)

		(md_print "ANCHOR 9: Anchor 9 to Sabre teams, Phantoms are inbound on vector seven mark four-niner.")
		(md_object_play 0 NONE m45_2270)
	
	(md_stop)
)

(script static void md_waf_an9_phantoms_forward
	(md_start)

		(md_print "ANCHOR 9: Anchor 9 to Sabre teams: Phantom signatures detected on a forward-facing vector.")
		(md_object_play 0 NONE m45_2280)
	
	(md_stop)
)

; -------------------------------------------------------------------------------------------------
(script dormant md_waf_an9_gunboats_in_position
	(branch
		(= b_waf_phantoms_defeated true) (md_abort)
	)
	
	(sleep_until b_waf_phantoms_in_position)
	
	(md_start)

		(md_print "ANCHOR 9: Gunboats are in position! Damage control teams, at the ready!")
		(md_object_play 0 NONE m45_2310)
	
	(md_stop)
)

(script dormant md_waf_phantom_torpedoes_away
	(branch
		(= b_waf_phantoms_defeated true) (md_abort)
	)
	
	(sleep_until b_waf_phantom_torpedoes_away)
	
	(begin_random_count 1
		(md_waf_an9_torpedoes_away)
		(md_waf_an9_torpedo_launch)
		(md_waf_an9_torpedoes_incoming))
		
	(sleep (* 30 5))
	
	(md_waf_an9_collision_alarm)
)

(script static void md_waf_an9_torpedoes_away
	(md_start)

		(md_print "ANCHOR 9: Phantom torpedoes away! Bracing for impact!")
		(md_object_play 0 NONE m45_2290)
	
	(md_stop)
)

(script static void md_waf_an9_torpedo_launch
	(md_start)

		(md_print "ANCHOR 9: Torpedo launch detected!")
		(md_object_play 0 NONE m45_2300)
	
	(md_stop)
)


(script static void md_waf_an9_torpedoes_incoming
	(md_start)

		(md_print "ANCHOR 9: Torpedoes incoming!")
		(md_object_play 0 NONE m45_2320)
	
	(md_stop)
)

(script static void md_waf_an9_collision_alarm
	(md_start)
	
		(md_print "ANCHOR 9: Collision alarm!")
		(md_object_play 0 NONE m45_2330)
		
	(md_stop)
)

;*
(script static void md_waf_an9_battery_one_down
	(md_start)

		(md_print "ANCHOR 9: Battery one is down!")
		(md_object_play 0 NONE m45_2340)
	
	(md_stop)
)

(script static void md_waf_an9_battery_two_down
	(md_start)

		(md_print "ANCHOR 9: We've lost battery two!")
		(md_object_play 0 NONE m45_2350)
	
	(md_stop)
)

(script static void md_waf_an9_battery_three_down
	(md_start)

		(md_print "ANCHOR 9: Battery three is down!")
		(md_object_play 0 NONE m45_2360)
	
	(md_stop)
)

(script static void md_waf_an9_battery_four_down
	(md_start)

		(md_print "ANCHOR 9: Battery four is down!")
		(md_object_play 0 NONE m45_2370)
	
	(md_stop)
)

(script static void md_waf_an9_battery_five_down
	(md_start)

		(md_print "ANCHOR 9: Battery five is offline!")
		(md_object_play 0 NONE m45_2380)
			
	(md_stop)
)

(script static void md_waf_an9_battery_six_down
	(md_start)

		(md_print "ANCHOR 9: Battery six is out of the fight!")
		(md_object_play 0 NONE m45_2390)
	
	(md_stop)
)

(script static void md_waf_an9_all_batteries_down
	(md_start)

		(md_print "ANCHOR 9: Anchor 9 to all UNSC ships: all forward-faciong batteries are destroyed. Our lives are in your hands now, Sabre teams!")
		(md_object_play 0 NONE m45_2400)
	
	(md_stop)
)
*;



; -------------------------------------------------------------------------------------------------
; WARP
; -------------------------------------------------------------------------------------------------
(script static void md_wrp_an9_ships_neutralized
	(md_start)

		(md_print "ACHOR 9 ACTUAL: Anchor 9 to UNSC ships, all targets neutralized. B-029, you are clear to dock. Activating marker.")
		(md_object_play 30 NONE m45_0970)
					
		(md_print "HOLLAND: Holland to B-029 -- Noble 5, you ready to go?")
		(md_object_play 15 NONE m45_0980)
		
		(md_print "JORGE: Affirmative, Colonel.")
		(md_object_play 0 NONE m45_0990)
		
	(md_stop)
	
	(wake md_warp_dock_reminder)
)

(script dormant md_warp_dock_reminder
	(branch
		(= b_wrp_player_docks true) (md_abort)
	)
	
	(sleep 30)
	
	(sleep_until
		(begin
			(sleep (* 30 30))
			(md_wrp_hol_dock_reminder_1)
			
			(sleep (* 30 30))
			(md_wrp_hol_dock_reminder_2)
			
			(sleep (* 30 30))
			(md_wrp_hol_dock_reminder_3)
		0)
	1)
)

(script static void md_wrp_hol_dock_reminder_1
	(md_start)

		(md_print "HOLLAND: Noble 6, head for the marker. Initiate docking procedure.")
		(md_object_play 0 NONE m45_1000)
	
	(md_stop)
)

(script static void md_wrp_hol_dock_reminder_2
	(md_start)

		(md_print "HOLLAND: Spartan, dock at the marker. That's an order.")
		(md_object_play 0 NONE m45_1010)
	
	(md_stop)
)

(script static void md_wrp_hol_dock_reminder_3
	(md_start)

		(md_print "HOLLAND: Lieutenant, this mission is a wash unless you dock at that marker.")
		(md_object_play 0 NONE m45_1020)
	
	(md_stop)
)

(script dormant md_wrp_jor_my_stop
	(md_start)

		(md_print "JORGE: This is my stop, Lieutenant. See you on the other side.")
		(md_object_play 0 NONE m45_1030)
	
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; CORVETTE
; -------------------------------------------------------------------------------------------------
(script dormant md_crv_sav_intro
	(sleep 60)
	
	(md_start)

		(md_print "SAVANNAH: Frigate Savannah in position, Sabre team sound off.")
		(md_object_play 10 NONE m45_1040)
		
		(md_print "ECHO 1: Echo 1, all systems nominal.")
		(md_object_play 5 NONE m45_1050)
		
		(md_print "ECHO 2: Echo 2, good to go.")
		(md_object_play 7 NONE m45_1060)
	
		(md_print "ECHO 3: Echo 3, systems green.")
		(md_object_play 4 NONE m45_1070)
		
		(md_print "ECHO 4: Echo 4, all systems online.")
		(md_object_play 15 NONE m45_1080)
		
		(md_print "SAVANNAH: Solid copy. We are currently jamming the corvette's comms. Hit it hard while it could call for help.")
		(md_object_play 35 NONE m45_1090)
		
		;*
		
		
		
		(md_print "SAVANNAH: Might want to clip her engines, Colonel. See if we can slow her down.")
		(md_object_play 20 NONE m45_1430)
		
		(md_print "HOLLAND: Good thinking, Savannah. Will make boarding her a whole lot easier.")
		(md_object_play 45 NONE m45_1440)
		
		;(md_print "HOLLAND: Noble 6, I'm marking a target. Take out the Corvette's main engine.")
		;(md_object_play 20 NONE m45_1460)
	
		(md_print "HOLLAND: Noble 6, I'm marking targets. Take out the Corvette's main engines.")
		(md_object_play 0 NONE m45_1460)
		*;
		
		(md_print "HOLLAND: Agreed. Sabre teams, clear a path to that corvette.")
		(md_object_play 0 NONE m45_1130)
		
		;(new_mission_objective 8 ct_obj_corvette)
		;(wake show_objective_corvette_escort)
		
		
		
	(md_stop)
)

(script dormant md_crv_hol_sitrep
	(md_start)
	
		(md_print "HOLLAND: Holland to strike force, sitrep.")
		(md_object_play 0 NONE m45_1100)
		
		(md_print "JORGE: Noble 5 reporting. My Pelican's at the Savannah. Standing by.")
		(md_object_play 0 NONE m45_1110_hor)
		
	(md_stop)
)

(script dormant md_crv_sav_countermeasures
	(md_start)
		
		(md_print "SAVANNAH: UNSC Savannah in position 015 light seconds from target. Electronic countermeasures are working for now. Let's do this quick.")
		(md_object_play 0 NONE m45_1120)
		
		(md_print "HOLLAND: Agreed. Sabre teams, clear a path to that corvette.")
		(md_object_play 0 NONE m45_1130)
		
	(md_stop)
)

;*
(script dormant md_crv_sav_warning_phantom
	(md_start)
		
		(md_print "SAVANNAH: Savannah actual to Sabre teams, Phantom inbound. Take it out!")
		(md_object_play 0 NONE m45_1140)
		
	(md_stop)
)
*;

(script dormant md_crv_sav_warning_seraphs
	(md_start)
	
		(md_print "SAVANNAH: Savannah actual to Sabre teams, Seraphs on scan. Light'em up!")
		(md_object_play 0 NONE m45_1150)
		
	(md_stop)
)


(script dormant md_crv_dot_bomber_shields
	(md_start)
	
		(md_print "DOT: Colonel, be advised latest intel on Covenant Seraph bombers indicates active shield defenses.")
		(md_object_play 0 NONE m45_1160)
	
	(md_stop)
)

(script dormant md_hol_guns_on_shields
	(md_start)
	
		(md_print "HOLLAND: Sabre teams, use your guns to take down their shields then hit them with your missiles.")
		(md_object_play 0 NONE m45_1170)
		
	(md_stop)
)

;*
(script dormant md_crv_hol_missiles_on_shields
	(md_start)
	
		(md_print "HOLLAND: Sabre teams, use your missiles to take down their shields then hit them with your guns.")
		(md_object_play 0 NONE m45_1180)
		
	(md_stop)
)
*;

(script dormant md_crv_sav_warning_more_bogeys
	(md_start)
	
		(md_print "SAVANNAH: Heads up, Sabres. Multiple impulse drive signatures detected. More bogeys incoming.")
		(md_object_play 0 NONE m45_1190)
	
	(md_stop)
)

(script dormant md_crv_sav_warning_4_phantoms
	(md_start)
	
		(md_print "SAVANNAH: Three -- strike that -- four-plus Phantoms on scan. Take them out.")
		(md_object_play 0 NONE m45_1200)
	
	(md_stop)
)

(script dormant md_crv_sav_getting_hammered
	(md_start)
	
		(md_print "SAVANNAH: Savannah to Holland, we're getting hammered.")
		(md_object_play 0 NONE m45_1210)
		
		(md_print "HOLLAND: Understood, Savannah. Noble 6, I need you to neutralize those Phantoms.")
		(md_object_play 0 NONE m45_1220)
		
	(md_stop)
)

(script dormant md_crv_ec1_new_contacts
	(md_start)
	
		(md_print "ECHO 1: Echo 1, I've got new unknown contacts.")
		(md_object_play 0 NONE m45_1230)
		
		(md_print "SAVANNAH: Stand by, looks like more Phantoms, Echo 1. But something's wrong with their profiles.")
		(md_object_play 0 NONE m45_1240)
		
		(md_print "DOT: Scans are consistent with gunboat class dropships. Rare, but quite formidable.")
		(md_object_play 0 NONE m45_1250)
		
		(md_print "HOLLAND: You heard her, Sabre teams. Watch your step.")
		(md_object_play 0 NONE m45_1260)
		
	(md_stop)
)

;*
(script dormant md_crv_ec2_shot_down_missiles
	(md_start)
		
		(md_print "ECHO 2: Savannah, the damn thing shot down my missiles.")
		(md_object_play 0 NONE m45_1270)
		
		(md_print "SAVANNAH: Sabre teams, form up and focus fire on those heavy Phantoms.")
		(md_object_play 0 NONE m45_1280)
		
		(md_print "HOLLAND: Do whatever it takes, Sabres. We need to get the slipspace bomb aboard the corvette.")
		(md_object_play 0 NONE m45_1290)
		
	(md_stop)
)
*;

(script dormant md_crv_sav_more_heavy_phantoms
	(md_start)
	
		(md_print "SAVANNAH: More heavy phantoms, take them out.")
		(md_object_play 0 NONE m45_1300)
	
	(md_stop)
)

(script static void md_crv_ec2_reinforcements
	(md_start)
	
		(md_print "SAVANNAH: Heads up, Sabres. Multiple impulse drive signatures detected. More bogeys incoming.")
		(md_object_play 30 NONE m45_1190)
	
		(md_print "ECHO 2: Echo 2 to Savannah actual, where are these reinforcements coming from. Thought the target was jammed.")
		(md_object_play 45 NONE m45_1310)
	
		(md_print "SAVANNAH: Must be squadrons coming back from patrol, Echo 2.")
		(md_object_play 30 NONE m45_1320)
		
		(md_print "HOLLAND: Don't let any of them get away, Sabres. Kill them before they bug out and warn that super carrier what we're up to.")
		(md_object_play 0 NONE m45_1330)
		
		(wake show_objective_corvette_escort)
		
	(md_stop)
)

;*
(script dormant md_crv_hol_bombers_on_time
	(md_start)
		
		(md_print "HOLLAND: Seraph bombers are scrambling, right on time. Sabre teams, kill those Seraphs, protect the Savannah.")
		(md_object_play 0 NONE m45_1340)
	
	(md_stop)
)
*;
;*
(script dormant md_crv_hol_corvette_shields
	(md_start)
	
		(md_print "HOLLAND: Careful, Savannah, that corvette still has its shields.")
		(md_object_play 0 NONE m45_1410)
		
		(md_print "SAVANNAH: Sabre teams, run interference while I take them out!")
		(md_object_play 0 NONE m45_1420)
		
	(md_stop)
)
*;

(script dormant md_crv_sav_clip_engines
	(sleep (random_range (* 30 5) (* 30 7)))
	
	(wake crv_hud_flash)
	
	(md_start)
	
		(md_print "SAVANNAH: Shields eliminated, might want to clip her engines, Colonel. See if we can slow her down.")
		(md_object_play 0 NONE m45_1430)
		
		(md_print "HOLLAND: Good thinking, Savannah. Will make boarding her a whole lot easier.")
		(md_object_play 0 NONE m45_1440)
	
		;(md_print "HOLLAND: Noble 6, I'm marking a target. Take out the Corvette's main engine.")
		;(md_object_play 0 NONE m45_1460)
	
		(md_print "HOLLAND: Noble 6, I'm marking targets. Take out the Corvette's main engines.")
		(md_object_play 0 NONE m45_1460)
		
	(md_stop)
	
	(wake crv_engine_control)
)

(script dormant md_crv_dot_flares
	(sleep_until b_crv_all_engines_damaged)
	(sleep 30)
	(md_start)

		(md_print "DOT: Warning, energy flares detected in the corvette's aft launch bays.")
		(md_object_play 0 NONE m45_1470)
	
		(sleep 25)
		
	(md_stop)
)

(script dormant md_crv_sav_deploying_pods
	(md_start)

		(md_print "SAVANNAH: They're deploying elite drop pods to the surface.")
		(md_object_play 0 NONE m45_1480)
	
		(md_print "HOLLAND: Destroy as many as you can, Noble 6. There are already too many of those murdering bastards on Reach.")
		(md_object_play 0 NONE m45_1490)
		
	(md_stop)
)

(script dormant md_crv_hol_destroy_pod_bays
	(md_start)
	
		(md_print "HOLLAND: Lieutenant, destroy the drop pod launch bays. Cook those Elites in their cans.")
		(md_object_play 0 NONE m45_1500)
	
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; BOARDING
; -------------------------------------------------------------------------------------------------
(script static void md_brd_hol_analyze_entrance
	(md_start)
	
		(sleep (random_range 45 75))	
		;(md_print "SAVANNAH: Savannah to Holland, all hostile fighters eliminated.")
		;(md_object_play 0 NONE m45_1340)
	
		(md_print "HOLLAND: Dot, analyze all available data on that corvette. Find a way inside.")
		(md_object_play 45 NONE m45_1510)
		
		(mus_start mus_07)
		
		(md_print "DOT: Scans indicate a structural weakness surrounding a platform on top of the vessel.")
		(md_object_play 30 NONE m45_1520)
		
		(md_print "HOLLAND: Noble 6, set down immediately on that corvette's topside landing pad.")
		(md_object_play 0 NONE m45_1370)
		;(md_print "HOLLAND: Noble 6, see if your weapons can breach the barrier around that topside platform.")
		;(md_object_play 0 NONE m45_1530)
		
	(md_stop)
)

(script dormant md_brd_hol_breach_reminder_1
	(md_start)
		
		(md_print "HOLLAND: Target the weak spot on the top of the corvette, Lieutenant.")
		(md_object_play 0 NONE m45_1540)
	
	(md_stop)
)

(script dormant md_brd_hol_breach_reminder_2
	(md_start)
	
		(md_print "HOLLAND: Spartan, you won't be able to land until you breach that topside barrier.")
		(md_object_play 0 NONE m45_1550)
		
	(md_stop)
)

(script static void md_brd_sav_airspace_clear
	(md_start)

		;(md_print "SAVANNAH: Savannah to Holland -- all escort craft elimated. Airspace is clear, Colonel.")
		;(md_object_play 0 NONE m45_1360)
		
		(md_print "HOLLAND: Noble 6, set down immediately on that corvette's topside landing pad.")
		(md_object_play 0 NONE m45_1370)
		
	(md_stop)
)

(script dormant md_brd_hol_land_reminder_1
	(md_start)
	
		(md_print "HOLLAND: Noble 6, repeat, set down on that landing pad.")
		(md_object_play 0 NONE m45_1380)
		
	(md_stop)
)

(script dormant md_brd_hol_land_reminder_2
	(md_start)

		(md_print "HOLLAND: I need you to land on that corvette, Lieutenant.")
		(md_object_play 0 NONE m45_1390)
	
	(md_stop)
)

(script dormant md_brd_hol_land_reminder_3
	(md_start)
	
		(md_print "HOLLAND: Spartan, park your bird topside. Now.")
		(md_object_play 0 NONE m45_1400)
		
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; COMMS
; -------------------------------------------------------------------------------------------------
(script dormant md_com_hol_intro
	(sleep (random_range 60 90))
	(md_start)

		(md_print "HOLLAND: Noble Six, the Savannah's countermeasures won't work forever.")
		(md_print "HOLLAND: Find a way inside and permanently disable that cruiser's communications.")
		(md_object_play 15 NONE m45_1560)
			
		(md_print "HOLLAND: As soon as we're sure the corvette can't squawk, we'll initiate Uppercut Phase 2.")
		(md_object_play 0 NONE m45_1600)
		
	(md_stop)
	
	;(new_mission_objective 12 ct_obj_comms_seize)
	(wake show_objective_comms_seize)
	;(wake md_com_hol_airlock_reminder)
)

(script dormant md_com_hol_inside_reminder_1
	(md_start)
	
		(md_print "HOLLAND: Get inside, Spartan. If that corvette calls for backup, we're done for.")
		(md_object_play 0 NONE m45_1580)
		
	(md_stop)
)

(script dormant md_com_hol_inside_reminder_2
	(md_start)
	
		(md_print "HOLLAND: Head for the comm center, Lieutenant. Find and destroy the relay core.")
		(md_object_play 0 NONE m45_1590)
		
	(md_stop)
)

(script dormant md_com_hol_corvette_squawk
	(md_start)
	
		(md_print "HOLLAND: As soon as we're sure the corvette can't squawk, we'll initiate Uppercut Phase 2.")
		(md_object_play 0 NONE m45_1600)
		
	(md_stop)
)

(script dormant md_com_hol_airlock_reminder
	(if debug (print "comms: reminder started for entering airlock..."))
	
	(branch
		(>= s_objcon_com 10)
		(mda_com_hol_airlock_reminder))
	
	(sleep s_md_reminder_wait)
	
	(sleep_until
		(begin
			(if (< s_objcon_com 10)
				(md_com_hol_landing_pad))

			(if (< s_objcon_com 10)
				(begin
					(f_blip_flag fl_comms_airlock_left blip_recon)
					(f_blip_flag fl_comms_airlock_right blip_recon)))
					
			(sleep s_md_reminder_interval)
			
		(>= s_objcon_com 10))
	)
	
	(if debug (print "comms: reminder for airlock no is longer necessary..."))
)

(script static void mda_com_hol_airlock_reminder
	(sleep_until (>= s_objcon_com 10) 1)
	
	(f_unblip_flag fl_comms_airlock_left)
	(f_unblip_flag fl_comms_airlock_right)
)

(script static void md_com_hol_landing_pad
	(md_start)

		(md_print "HOLLAND: Six, I'm looking at recon shots of that landing pad -- ")
		(md_print "HOLLAND: Should be airlocks to the interior, port and starboard. Move inside.")
		;(md_play 0 sound\dialog\levels\m45\mission\robot\m45_0840.sound)
		
	(md_stop)
)


; -------------------------------------------------------------------------------------------------
; HANGAR
; -------------------------------------------------------------------------------------------------
(script static void md_hgr_hol_intro
	(md_start)
	
		(md_print "HOLLAND: Holland to Savannah, enemy comm relay is now offline.")
		(md_object_play 30 NONE m45_1670)
		
		(md_print "SAVANNAH: Copy that. Halting countermeasures. Diverting all power and personnel to weapons.")
		(md_object_play 15 NONE m45_1680)

		(md_print "HOLLAND: All right, Noble. Let's get that bomb onboard. Six, head for the hangar.")
		(md_object_play 0 NONE m45_1690)
	
	(md_stop)
	
	(mus_stop mus_07)
)


(script dormant md_hgr_pl1_hangar_this_way
	
	(md_start)
	
		(md_print "PILOT #1: Spartans, hangar's this way.")
		(md_object_play 0 NONE m45_1700)
		
	(md_stop)
)

(script dormant md_hgr_pl2_on_our_way
	(sleep (random_range 90 120))
	
	(vs_cast gr_unsc_pilots FALSE 10 m45_1710)
	
	(md_start)
	
		(md_print "PILOT #2: Colonel, on our way to the hangar.")
		(md_ai_play 30 (vs_role 1) m45_1710)
		
		(md_print "HOLLAND: Noble 5, meet them there.")
		(md_object_play 20 NONE m45_1720)
		
		(md_print "JORGE: Affirmative, on approach.")
		(md_object_play 0 NONE m45_1730)
		
	(md_stop)
)

(script dormant md_grm_odst_sav_hitting
	(md_start)

		(md_print "ODST: Whoa... Savannah's hitting this Corvette hard!")
		(md_object_play 0 NONE m45_1870)
	
		(md_print "ODST: Hope the old girl can take it as well as she dishes it out!")
		(md_object_play 0 NONE m45_1880)
		
	(md_stop)
)


(script dormant md_hgr_jor_shield_door_up
	(md_start)
	
		(md_print "JORGE: Hang on. Shield door is up. Six, I need you to disable it.")
		(md_object_play 0 NONE m45_1740)
	
	(md_stop)
)

(script dormant md_hgr_tr5_in_hangar
	(vs_cast sq_unsc_com_pilots FALSE 10 m45_1750)
	;(set ai_tr1 (vs_role 1))
	
	(md_start)
	
		(md_print "TROOPER 5: We're in the hangar, Noble 5.")
		(md_ai_play 0 (vs_role 1) m45_1750)
	
		(md_print "JORGE: Not a moment too soon. Shield controls should be around there somewhere.")
		(md_object_play 0 NONE m45_1760)
		
	(md_stop)
)

(script dormant md_hgr_jor_cant_land_until
	(md_start)
	
		(md_print "JORGE: Can't land until you drop that shield, Lieutenant.")
		(md_object_play 0 NONE m45_1770)
		
	(md_stop)
)

(script dormant md_hgr_tr5_shield_control_platform
	(md_start)
		
		(md_print "TROOPER 5: Shield controls are on the far platform, Spartan.")
		(md_ai_play 0 ai_tr5 m45_1780)
		
	(md_stop)
)

(script dormant md_hgr_tf2_shield_control_platform
	(md_start)
		
		(md_print "TROOPER FEMALE 2: Shield controls are on the far platform, Spartan.")
		(md_ai_play 0 ai_tf2 m45_1790)
		
	(md_stop)
)

(script dormant md_hgr_jor_go_for_controls
	(md_start)
	
		(md_print "JORGE: Six, go for those shield controls. I...")
		(md_object_play 0 NONE m45_1800)
		
	(md_stop)
	
	(mus_start mus_08)
)

(script dormant md_hgr_tf2_head_for_controls
	(md_start)
	
		(md_print "TROOPER FEMALE 2: Sir, head for the shield controls. We'll cover you.")
		(md_ai_play 0 ai_tf2 m45_1810)
		
	(md_stop)
)

(script dormant md_hgr_tf2_maam_head_for_controls
	(md_start)
	
		(md_print "TROOPER FEMALE 2: Ma'am, head for the shield controls. We'll cover you.")
		(md_ai_play 0 ai_tf2 m45_1820)
		
	(md_stop)
)

(script dormant md_hgr_jor_splendid
	(md_start)
	
		(md_print "JORGE: Splendid, coming in.")
		(md_object_play 0 NONE m45_1830)
	
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; GUNROOM
; -------------------------------------------------------------------------------------------------
(script dormant md_grm_hol_find_bridge
	(sleep 60)
	
	(md_start)

		(md_print "HOLLAND: Noble 6, get that corvette moving toward that super carrier. Head for the bridge, find the nav controls.")
		(md_object_play 0 NONE m45_1840)
		
		(wake show_objective_sieze_bridge)
		(mus_alt mus_08)
		
	(md_stop)
	
	(wake md_grm_tr1_plenty_of_arms)
)

(script dormant md_grm_tr1_plenty_of_arms
	(sleep 30)
	
	(vs_cast gr_unsc_pilots FALSE 10 m45_1850)
	(set ai_tr1 (vs_role 1))
	
	(md_start)
	

	
		(md_print "TROOPER 1: We got plenty of arms and ammo if you need'em, Spartan.")
		(md_ai_play 0 ai_tr1 m45_1850)
			
	(md_stop)
	
	(f_callout_object dm_grm_weapons0 blip_ammo)
	(f_callout_object dm_grm_weapons1 blip_ammo)
)

(script dormant md_grm_tr5_lead_the_way

	
	(md_start)
	
		(md_print "TROOPER 5: Lead the way, Lieutenant.")
		(md_ai_play 0 ai_tr5 m45_1850)
	
	(md_stop)
)


(global ai ai_com_tr1 none)
(global ai ai_com_tr5 none)

(script dormant md_hgr_tr1_savannah_hitting_hard
	(sleep (random_range 30 60))
	
	(sound_impulse_start sound\levels\120_halo\trench_run\island_creak.sound NONE 1)
	(cam_shake 0.2 1 2 3)
	(interpolator_start corvette_power)
	
	(if (> (ai_living_count sq_unsc_com_pilots) 0)
		(begin
			(if (>= (ai_living_count sq_unsc_com_pilots) 3)
				(thespian_performance_setup_and_begin thespian_corvette_stagger_pilot2 "" 0))
				
			(if (>= (ai_living_count sq_unsc_com_pilots) 2)
				(thespian_performance_setup_and_begin thespian_corvette_stagger_pilot1 "" 0))
				
			(if (>= (ai_living_count sq_unsc_com_pilots) 1)
				(thespian_performance_setup_and_begin thespian_corvette_stagger_pilot0 "" 0))
				
			(sleep 60)
			
			(vs_cast sq_unsc_com_pilots FALSE 10 m45_1870 m45_1880)
			(set ai_com_tr1 (vs_role 1))
			(set ai_com_tr5 (vs_role 2))
			
				
			(md_start)
		
				(md_print "TROOPER 1: Whoa. Savannah's hitting this corvette hard.")
				(md_ai_play 0 ai_com_tr1 m45_1870)
				;(md_object_play 0 NONE m45_1870)
			
				(md_print "TROOPER 5: Hope the old girl can take it as well as she dishes out.")
				(md_ai_play 0 ai_com_tr5 m45_1880)
				;(md_object_play 0 NONE m45_1880)
				
			(md_stop)		
		)
	)

)

(script static void md_grm_savannah_goes_down
	(md_start)
	
		(md_print "SAVANNAH: Savannah to Holland, sustaining major structural damage. We need to break off, Colonel.")
		(md_object_play 0 NONE m45_1890)
		
		(md_print "HOLLAND: Copy, Savannah. Our team is in. Disengage.")
		(md_object_play 0 NONE m45_1900)
		
		(sleep_until (>= s_objcon_grm 60) 30 (* 30 120))
		
		(sleep (random_range 15 35))
		(mus_stop mus_08)
		
		(wake grm_kill_savannah_guns)
		
		(md_print "SAVANNAH: Break off! Break off!")
		(md_object_play 0 NONE m45_1910)
		
		(md_print "SAVANNAH: Hull breach! Reactor's flaring! Dammit, I'm losing her!")
		(md_object_play 0 NONE m45_1920)
		
	(md_stop)
	
	
	(sleep 15)
	(mus_start mus_09)
)

(script dormant md_grm_sav_need_to_break_off
	(md_start)
	
		(md_print "SAVANNAH: Savannah to Holland, sustaining major structural damage. We need to break off, Colonel.")
		(md_object_play 0 NONE m45_1890)
		
		(md_print "HOLLAND: Copy, Savannah. Our team is in. Disengage.")
		(md_object_play 0 NONE m45_1900)
		
	(md_stop)
)

(script dormant md_grm_sav_break_off
	(md_start)
	
		(md_print "SAVANNAH: Break off! Break off!")
		(md_object_play 0 NONE m45_1910)
		
		(md_print "SAVANNAH: Hull breach! Reactor's flaring! Dammit, I'm losing her!")
		(md_object_play 0 NONE m45_1920)
		
	(md_stop)
)

(global boolean b_grm_hol_finishes_dialogue false)
(script dormant md_grm_hol_savannah_can_you_hear
	(md_start)
	
		(md_print "HOLLAND: Savannah actual, can you hear me?")
		(md_object_play 90 NONE m45_1930)
		
		(md_print "JORGE: Frigate's gone, six. Nothing we could do.")
		;(md_ai_play 0 ai_jorge m45_1940)
		(md_object_play 35 NONE m45_1940)
		
		(md_print "HOLLAND: Noble, you are in deep with no cover. Get that corvette moving and get the hell out of there.")
		(md_object_play 0 NONE m45_1950)
		
	(md_stop)
	
	(set b_grm_hol_finishes_dialogue true)
	
	(game_save_no_timeout)
)

(script dormant md_grm_jor_frigates_gone
	(md_start)
		
		(md_print "JORGE: Frigate's gone, six. Nothing we could do.")
		(md_ai_play 0 ai_jorge m45_1940)
		
	(md_stop) 
)

(script dormant md_grm_hol_you_are_in_deep
	(md_start)
	
		(md_print "HOLLAND: Noble, you are in deep with no cover. Get that corvette moving and get the hell out of there.")
		(md_object_play 0 NONE m45_1950)
	
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; BRIDGE
; -------------------------------------------------------------------------------------------------
(script dormant md_brg_tr5_looks_like_bridge
	(sleep (random_range 30 60))

	(vs_cast gr_unsc_pilots FALSE 10 m45_1960)

	(md_start)
	
		(md_print "TROOPER 5: Looks like the bridge, Spartan. Let's clear it out!")
		(md_ai_play 0 (vs_role 1) m45_1960)
		
	(md_stop)
)

(script dormant md_brg_hol_locate_terminal
	(md_start)
	
		(md_print "HOLLAND: Noble 6, locate that navigation terminal.")
		(md_object_play 0 NONE m45_1970)
	
	(md_stop)
)

(script dormant md_brg_tf2_gotta_find_terminal
	(md_start)
	
		(md_print "TROOPER FEMALE 2: Gotta find that nav terminal.")
		(md_ai_play 0 ai_tf2 m45_1980)
		
	(md_stop)
)

(script dormant md_brg_tr_gotta_find_terminal_b
	(vs_cast sq_unsc_grm_pilots FALSE 10 m45_1990)

	(md_start)
	
		(md_print "TROOPER MALE 1: Gotta find that nav terminal.")
		(md_ai_play 0 (vs_role 1) m45_1990)
		
	(md_stop)
)

(script static void md_brg_hol_move_lieutenant
	(md_start)
	
		(md_print "HOLLAND: Move, Lieutenant. Put that corvette on a refueling track to the super carrier.")
		(md_object_play 0 NONE m45_2000)
		
	(md_stop)
)

(script dormant md_brg_hol_taking_so_long
	(md_start)
	
		(md_print "HOLLAND: Noble 6, what's taking so long? Find that nav terminal!")
		(md_object_play 0 NONE m45_2010)
		
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; ESCAPE
; -------------------------------------------------------------------------------------------------
(script dormant md_esc_tr5_think_that_did_it
	(md_start)
	
		(md_print "TROOPER 5: Think that did it, Lieutenant. Refueling track confirmed.")
		(md_ai_play 0 ai_tr5 m45_2020)
		
	(md_stop)
)

(script dormant md_esc_hol_well_done
	(sleep 30)
	
	(md_start)
	
		(md_print "HOLLAND: Well done, Noble 6. Uppercut initiated. Corvette is underway.")
		(md_object_play 30 NONE m45_2030)
		
		(md_print "JORGE: Six, our rides out of here are taking heavy fire. Get back here.")
		(md_object_play 0 NONE m45_2040)
		
		(wake show_objective_rescue_jorge)
		;(mus_play mus_mikefull)
		
	(md_stop)
)


(script dormant md_esc_at_your_earliest
	(sleep (random_range 60 210))
	(md_start)
	
		(md_print "JORGE: At your earliest convenience, Noble 6!")
		(md_object_play 0 NONE m45_2050)
		
	(md_stop)
)



; -------------------------------------------------------------------------------------------------
; FINAL
; -------------------------------------------------------------------------------------------------
(script dormant md_fin_jor_good_of_you
	(sleep_until (>= s_objcon_fin 10))
	(sleep 60)
	
	(md_start)
	
		(md_print "JORGE: Good of you to come. Hostiles are pounding the hell out of my Pelican.")
		(md_ai_play 0 ai_jorge m45_2060)
		
	(md_stop)
	
	
	(wake show_objective_defend_bomb)
	(sleep 45)
	(f_blip_flag fl_fin_slipspace blip_defend)
	(sleep 30)
	
	(f_callout_object dm_fin_weapons0 blip_ammo)
	(f_callout_object dm_fin_weapons1 blip_ammo)
	(f_callout_object dm_fin_weapons2 blip_ammo)
	
	(game_save)

	
)

(script static void md_fin_jor_and_stay_down
	(md_start)
	
		(md_print "JORGE: And stay down!")
		(md_ai_play 0 ai_jorge m45_2070)
	
		(cs_run_command_script ai_jorge cs_fin_jorge_pelican)
		
		(sleep 60)
		
		(md_print "JORGE: Savannah did a number on the door. There's no way back up to the Sabres. Noble 6, form up on me.")
		(md_ai_play 0 ai_jorge m45_2080)
		
		(sleep 30)
		
		(f_blip_ai ai_jorge 21)
		(wake md_fin_jor_meet_reminder_loop)
		
	(md_stop)
	
)

(script dormant md_fin_jor_savannah_did_number
	(md_start)
	
		(md_print "JORGE: Savannah did a number on the door. There's no way back up to the Sabres. Noble 6, form up on me.")
		(md_ai_play 0 ai_jorge m45_2080)
		
	(md_stop)
)

(script dormant md_fin_jor_meet_reminder_loop
	(branch
		(= b_fin_completed true) (md_abort)
	)
	
	(sleep_until
		(begin
			(sleep (* 30 30))
			(md_fin_jor_meet_me_at_bomb)
			
			(sleep (* 30 45))
			(md_fin_jor_my_position_now)
		0)
	1)
)

(script static void md_fin_jor_meet_me_at_bomb
	(md_start)
	
		(md_print "JORGE: Meet me at the bomb, Six.")
		(md_ai_play 0 ai_jorge m45_2090)
		
	(md_stop)
)

(script static void md_fin_jor_my_position_now
	(md_start)
	
		(md_print "JORGE: Spartan, my position. Now.")
		(md_ai_play 0 ai_jorge m45_2100)
		
	(md_stop)
)



; =================================================================================================
; CORVETTE
; =================================================================================================
(script static void setup_corvette_cannons
	(object_create_folder_anew v_corvette_cannons)
	(corvette_load_gunners)
	(sleep 1)
	(wake corvette_cannon_control)
)

(script static void corvette_load_gunners
	(ai_place sq_cov_crv_cannon_gunners/gunner_left0)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left0 v_crv_cannon_left0)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left1)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left1 v_crv_cannon_left1)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left2)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left2 v_crv_cannon_left2)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_right0)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_right0 v_crv_cannon_right0)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_right1)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_right1 v_crv_cannon_right1)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_right2)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_right2 v_crv_cannon_right2)
	
	(sleep 1)
	
	(ai_cannot_die sq_cov_crv_cannon_gunners true)
	(ai_disregard (ai_actors sq_cov_crv_cannon_gunners) true)
	
	(ai_set_clump sq_cov_crv_cannon_gunners CLUMP_CORVETTE_AA)
)

(script static void corvette_load_gunners_left
	(ai_place sq_cov_crv_cannon_gunners/gunner_left0)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left0 v_crv_cannon_left0)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left1)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left1 v_crv_cannon_left1)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left2)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left2 v_crv_cannon_left2)
	
	(sleep 1)
	
	(ai_cannot_die sq_cov_crv_cannon_gunners true)
	;(ai_disregard (ai_actors sq_cov_crv_cannon_gunners) true)
)

(script static void setup_corvette_cannons_comms
	(ai_erase sq_cov_crv_cannon_gunners)
	(object_create_folder_anew v_corvette_cannons)

	(ai_place sq_cov_crv_cannon_gunners/gunner_left0)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left0 v_crv_cannon_left0)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left1)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left1 v_crv_cannon_left1)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left2)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left2 v_crv_cannon_left2)
	
	(sleep 1)
	
	(ai_cannot_die sq_cov_crv_cannon_gunners true)
	(ai_disregard (ai_actors sq_cov_crv_cannon_gunners) true)
	
	(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_corvette_gunners_comms)
	(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_corvette_gunners_comms)
	(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_corvette_gunners_comms)
		
)

(script static void setup_corvette_cannons_hangar
	(ai_erase sq_cov_crv_cannon_gunners)
	(object_create_folder_anew v_corvette_cannons)

	(ai_place sq_cov_crv_cannon_gunners/gunner_left0)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left0 v_crv_cannon_left0)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left1)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left1 v_crv_cannon_left1)
	
	(ai_place sq_cov_crv_cannon_gunners/gunner_left2)
	(ai_vehicle_enter_immediate sq_cov_crv_cannon_gunners/gunner_left2 v_crv_cannon_left2)
	
	(sleep 1)
	
	(ai_cannot_die sq_cov_crv_cannon_gunners true)
	(ai_disregard (ai_actors sq_cov_crv_cannon_gunners) true)
	
	(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_corvette_gunners_hangar)
	(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_corvette_gunners_hangar)
	(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_corvette_gunners_hangar)
		
)

(script command_script cs_corvette_gunners_left
	(if debug (print "corvette: left cannons aiming at the frigate.."))
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_rear_top01"))
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_rear_bottom01"))
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_right_bottom01"))
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_right_top03"))
			)
			(sleep (random_range 100 200))
		0)
	1)
	
	
	(sleep_forever)
)

(script command_script cs_corvette_gunners_right
	(begin_random_count 1
		(cs_shoot true (object_at_marker dm_savannah_corvette "turret_rear_top01"))
		(cs_shoot true (object_at_marker dm_savannah_corvette "turret_rear_bottom01"))
		(cs_shoot true (object_at_marker dm_savannah_corvette "turret_right_bottom01"))
		(cs_shoot true (object_at_marker dm_savannah_corvette "turret_right_top03"))
	)
	
	(sleep_forever)
)

(script command_script cs_corvette_gunners_comms
	(if debug (print "corvette: left cannons aiming at the frigate.."))
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_rear_top01"))
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_rear_bottom01"))
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_right_bottom01"))
				(cs_shoot true (object_at_marker dm_savannah_comms "turret_right_top03"))
			)
			
			(sleep (random_range 100 200))
		0)
	1)
	
	(sleep_forever)
)

(script command_script cs_corvette_gunners_hangar
	(if debug (print "corvette: left cannons aiming at the frigate.."))
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot true (object_at_marker dm_savannah_hangar "turret_rear_top01"))
				(cs_shoot true (object_at_marker dm_savannah_hangar "turret_rear_bottom01"))
				(cs_shoot true (object_at_marker dm_savannah_hangar "turret_right_bottom01"))
				(cs_shoot true (object_at_marker dm_savannah_hangar "turret_right_top03"))
			)
			(sleep (random_range 100 200))
		0)
	1)
	
	
	(sleep_forever)
)


(script command_script cs_gunroom_gunners_left
	(if debug (print "corvette: left cannons aiming at the frigate.."))
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point true ps_grm_cannons/target0)
				(cs_shoot_point true ps_grm_cannons/target1)
				(cs_shoot_point true ps_grm_cannons/target2)
			)
			(sleep (random_range 90 150))
		(= (object_get_health dm_savannah_gunroom) -1))
	1)
	
	(sleep (* 30 1))
	(ai_erase ai_current_actor)
)

(script command_script cs_gunroom_gunner_left0
	(if debug (print "corvette: left cannons aiming at the frigate.."))
	(ai_set_targeting_group ai_current_actor 2 false)
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point true ps_grm_cannons/gun0_target0)
				(cs_shoot_point true ps_grm_cannons/gun0_target1)
				(cs_shoot_point true ps_grm_cannons/gun0_target2)
			)
			(sleep (random_range 90 150))
		(= (object_get_health dm_savannah_gunroom) -1))
	1)
	
	;(sleep (* 30 1))
	(ai_erase ai_current_actor)
)

(script command_script cs_gunroom_gunner_left1
	(if debug (print "corvette: left cannons aiming at the frigate.."))
	(ai_set_targeting_group ai_current_actor 2 false)
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point true ps_grm_cannons/gun1_target0)
				(cs_shoot_point true ps_grm_cannons/gun1_target1)
				(cs_shoot_point true ps_grm_cannons/gun1_target2)
			)
			(sleep (random_range 90 150))
		(= (object_get_health dm_savannah_gunroom) -1))
	1)
	
	;(sleep (* 30 1))
	(ai_erase ai_current_actor)
)

(script command_script cs_gunroom_gunner_left2
	(if debug (print "corvette: left cannons aiming at the frigate.."))
	(ai_set_targeting_group ai_current_actor 2 false)
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point true ps_grm_cannons/gun2_target0)
				(cs_shoot_point true ps_grm_cannons/gun2_target1)
				(cs_shoot_point true ps_grm_cannons/gun2_target2)
			)
			(sleep (random_range 90 150))
		(= (object_get_health dm_savannah_gunroom) -1))
	1)
	
	;(sleep (* 30 1))
	(ai_erase ai_current_actor)
)




(script dormant corvette_cannon_control
	(branch 
		(= b_com_started true) (branch_abort)
	)
	
	(sleep_until
		(begin
			(sleep_until
				(and
					(> (device_get_position dm_savannah_corvette) 0.00)	;	 frigate is in view of the left guns
					(< (device_get_position dm_savannah_corvette) 0.15)) 1)
					; left-side guns fire at the frigate
					; -------------------------------------------------
					(if debug (print "corvette: left cannons aiming at the frigate.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_corvette_gunners_left)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_corvette_gunners_left)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_corvette_gunners_left)
					; -------------------------------------------------
					
			(sleep_until (> (device_get_position dm_savannah_corvette) 0.15) 1)
			
					; left-side guns are free
					; -------------------------------------------------
					(if debug (print "corvette: left cannons are free.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_abort)
					; -------------------------------------------------
					
			(sleep_until 
				(and
					(> (device_get_position dm_savannah_corvette) 0.44)		; frigate is in view of the right guns
					(< (device_get_position dm_savannah_corvette) 0.56)) 1)
					; right-side guns fire at the frigate
					; -------------------------------------------------
					(if debug (print "corvette: right cannons aiming at the frigate.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right0 cs_corvette_gunners_right)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right1 cs_corvette_gunners_right)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right2 cs_corvette_gunners_right)
					; -------------------------------------------------
					
			(sleep_until (> (device_get_position dm_savannah_corvette) 0.56) 1)
			
					; left-side guns are free
					; -------------------------------------------------
					(if debug (print "corvette: right cannons are free.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right0 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right1 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right2 cs_abort)
					; -------------------------------------------------
		0)
	1)
)

(script static void test_corvette_cannons
	(setup_corvette_cannons)
	(crv_savannah_orbit)
	(sleep 1)
	;(wake corvette_cannon_control)
)


(script static void test_player_corvette_guns
	(vehicle_load_magic v_crv_cannon_left0 "" (player0))
)

; =================================================================================================
; SAVANNAH
; =================================================================================================
(script static void (savannah_load_gunners (device_name d))
	
	; RIGHT
	; -------------------------------------------------------------------------------------------------
	(if debug (print "corvette savannah: loading right side gunners..."))
	
	(ai_place sq_unsc_sav_gunners/gunner_right_top01)
	(vehicle_load_magic 
		(object_at_marker d "turret_right_top01")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_right_top01))
	
	(ai_place sq_unsc_sav_gunners/gunner_right_top02)
	(vehicle_load_magic 
		(object_at_marker d "turret_right_top02")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_right_top02))
	;(cs_run_command_script sq_unsc_sav_gunners/gunner_right_top02 cs_savannah_missile_control)	
	
	(ai_place sq_unsc_sav_gunners/gunner_right_top03)	
	(vehicle_load_magic 
		(object_at_marker d "turret_right_top03")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_right_top03))
	
	(ai_place sq_unsc_sav_gunners/gunner_right_bottom01)
	(vehicle_load_magic 
		(object_at_marker d "turret_right_bottom01")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_right_bottom01))
	
	; LEFT
	; -------------------------------------------------------------------------------------------------
	(if debug (print "corvette savannah: loading left side gunners..."))
		
	(ai_place sq_unsc_sav_gunners/gunner_left_top01)
	(vehicle_load_magic 
		(object_at_marker d "turret_left_top01")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_left_top01))
	
	
	(ai_place sq_unsc_sav_gunners/gunner_left_top02)
	(vehicle_load_magic 
		(object_at_marker d "turret_left_top02")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_left_top02))
	;(cs_run_command_script sq_unsc_sav_gunners/gunner_left_top02 cs_savannah_missile_control)
	
	(ai_place sq_unsc_sav_gunners/gunner_left_top03)
	(vehicle_load_magic 
		(object_at_marker d "turret_left_top03")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_left_top03))

	
	(ai_place sq_unsc_sav_gunners/gunner_left_bottom01)
	(vehicle_load_magic 
		(object_at_marker d "turret_left_bottom01")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_left_bottom01))
	
	
	; REAR		
	; -------------------------------------------------------------------------------------------------
	(if debug (print "corvette savannah: loading rear gunners..."))
	
	(ai_place sq_unsc_sav_gunners/gunner_rear_top01)
	(vehicle_load_magic 
		(object_at_marker d "turret_rear_top01")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_rear_top01))
		
	(ai_place sq_unsc_sav_gunners/gunner_rear_bottom01)
	(vehicle_load_magic 
		(object_at_marker d "turret_rear_bottom01")
		""
		(ai_get_object sq_unsc_sav_gunners/gunner_rear_bottom01))
	
	
	(ai_set_clump sq_unsc_sav_gunners CLUMP_SAVANNAH_AA)
	(ai_disregard (ai_actors sq_unsc_sav_gunners) true)
)

(script command_script cs_amb_savannah_guns_high
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p0)
					(sleep (random_range 30 150)))
					
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p1)
					(sleep (random_range 30 150)))
					
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p2)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p3)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p4)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p5)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p6)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p7)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p8)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p9)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_high/p10)
					(sleep (random_range 30 150)))
					
			)
		0)
	1)
)

(script command_script cs_amb_savannah_guns_low
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p0)
					(sleep (random_range 30 150)))
					
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p1)
					(sleep (random_range 30 150)))
					
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p2)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p3)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p4)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p5)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p6)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p7)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p8)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p9)
					(sleep (random_range 30 150)))
				
				(begin
					(cs_shoot_point true ps_amb_sav_targets_low/p10)
					(sleep (random_range 30 150)))
					
			)
		0)
	1)
)


(script static void com_savannah_chase
	(object_destroy_folder dm_savannah)
	(object_create dm_savannah_comms)
	;(device_set_position_track dm_savannah_comms "m45_chase" 1)
	;(device_set_power dm_savannah_comms 1)
	;(device_set_position dm_savannah_comms 1)
	(device_set_position_track dm_savannah_comms "m45_orbit_corvette" 0)
	(device_set_position_immediate dm_savannah_comms 0)
	
	
	(device_set_power dm_savannah_comms 1)
	(device_set_position dm_savannah_comms 1)
	
	(object_function_set 0 0.4)
	
	
	;(device_animate_position dm_savannah_comms 1.0 8 1 1 true)
	

)

(script static void hgr_savannah_chase
	(object_destroy_folder dm_savannah)
	(object_create dm_savannah_hangar)
	(device_set_position_track dm_savannah_hangar "m45_chase" 1)
	(device_set_power dm_savannah_hangar 1)
	(device_set_position dm_savannah_hangar 1)
)

(script static void grm_savannah_chase
	(object_destroy_folder dm_savannah)
	(object_create dm_savannah_gunroom)
	(device_set_position_track dm_savannah_gunroom "m45_chase" 1)
	(device_set_power dm_savannah_gunroom 1)
	(device_set_position dm_savannah_gunroom 1)
)

(global boolean b_savannah_destroyed false)
(script dormant grm_savannah_moment
		(object_create_folder_anew v_corvette_cannons)
		(sleep 1)
		(corvette_load_gunners_left)
		
		
	;(sleep_until (>= s_objcon_grm 30) 1)
	
		(object_destroy_folder dm_savannah)
		(object_create dm_savannah_gunroom)
		
		(sleep 1)
		
		(savannah_load_gunners dm_savannah_gunroom)
		
		(ai_erase sq_unsc_sav_gunners/gunner_left_top01)
		(ai_erase sq_unsc_sav_gunners/gunner_left_top02)
		(ai_erase sq_unsc_sav_gunners/gunner_left_top03)
		(ai_erase sq_unsc_sav_gunners/gunner_left_bottom01)
		(ai_erase sq_unsc_sav_gunners/gunner_left_bottom02)
		(ai_erase sq_unsc_sav_gunners/gunner_rear_bottom01)
	
		(ai_set_targeting_group sq_unsc_sav_gunners s_tg_ambient_battle false)
		(ai_set_clump sq_unsc_sav_gunners CLUMP_SABRES)
		
		(ai_set_team sq_unsc_sav_gunners spare)
		
		(if debug (print "corvette: left cannons aiming at the frigate.."))
		(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_gunroom_gunner_left2)
		(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_gunroom_gunner_left1)
		(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_gunroom_gunner_left0)
		(ai_disregard (ai_actors sq_cov_crv_cannon_gunners) true)
	
	(sleep_until 
		(or
			(>= s_objcon_grm 30) 
			(and
				(<= (ai_living_count gr_cov_grm_hall) 0)
				(> (ai_spawn_count gr_cov_grm_hall) 0))
		)
	1)
		(sleep (random_range 30 60))
		(md_grm_savannah_goes_down)
		
		(wake grm_destroy_savannah)
		
		(sleep (random_range (* 30 10) (* 30 11)))
		(wake md_grm_hol_savannah_can_you_hear)
)

(script dormant grm_destroy_savannah
		(wake grm_stagger_control)

		(if debug (print "swapping pristine frigate for destroyed..."))
		(object_destroy dm_savannah_gunroom)
		(object_create dm_savannah_destroyed)
		
		(if debug (print "putting destroyed frigate on m45_drift animation track..."))
		(device_set_position_track dm_savannah_destroyed "m45_drift" 0)
		(device_set_position_immediate dm_savannah_destroyed 0)
		(sleep 1)
		
		(device_animate_position dm_savannah_destroyed 1.0 s_fx_frigate_death_time 0.034 0.034 false)
		; start destroying the frigate with specific script calls if needed...
		
		(set b_savannah_destroyed true)
		(wake grm_warp_seraphs_out)
		(sleep (* 30 s_fx_frigate_death_time))	; sleep as long as the destruction takes
		
		(object_destroy_folder dm_savannah)

)


(script dormant grm_warp_seraphs_out
	(sleep (random_range 120 240))
	(cs_run_command_script sq_cov_amb_seraphs0 cs_grm_warpout)

)
(script command_script cs_grm_warpout
	(cs_vehicle_speed 1.0)
	
	(begin_random_count 1
		(begin
			(cs_fly_by ps_grm_warpout/warpout0_0)
			(cs_fly_by ps_grm_warpout/warpout0_1)
		)
		
		(begin
			(cs_fly_by ps_grm_warpout/warpout1_0)
			(cs_fly_by ps_grm_warpout/warpout1_1)
		)
		
		(begin
			(cs_fly_by ps_grm_warpout/warpout2_0)
			(cs_fly_by ps_grm_warpout/warpout2_1)
		)
	)
	
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1000)	
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 20)
	(sleep 20)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant grm_kill_savannah_guns
	(begin_random
		(begin
			(ai_erase sq_unsc_sav_gunners/gunner_right_top01)
			(sleep (random_range 15 35)))
			
		(begin
			(ai_erase sq_unsc_sav_gunners/gunner_right_top02)
			(sleep (random_range 15 35)))
			
		(begin
			(ai_erase sq_unsc_sav_gunners/gunner_right_top03)
			(sleep (random_range 15 35)))
			
		(begin
			(ai_erase sq_unsc_sav_gunners/gunner_right_bottom01)
			(sleep (random_range 15 35)))
			
		(begin
			(ai_erase sq_unsc_sav_gunners/gunner_right_bottom02)
			(sleep (random_range 15 35)))
			
		(begin
			(ai_erase sq_unsc_sav_gunners/gunner_rear_top01)
			(sleep (random_range 15 35)))
	)
)
(global boolean b_grm_terminals_alert false)
(script dormant grm_stagger_control
		(sleep (* 30 11))
		
		(if (>= (ai_living_count gr_unsc_pilots) 4)
			(thespian_performance_activate thespian_grm_stagger_pilot3))
		
		(if (>= (ai_living_count gr_unsc_pilots) 3)
			(thespian_performance_activate thespian_grm_stagger_pilot2))
				
		(if (>= (ai_living_count gr_unsc_pilots) 2)
			(thespian_performance_activate thespian_grm_stagger_pilot1))
				
		(if (>= (ai_living_count gr_unsc_pilots) 1)
			(thespian_performance_activate thespian_grm_stagger_pilot0))
			
		(sleep 60)
		(set b_grm_terminals_alert true)	
)

(script static void waf_savannah_dock
	(object_destroy dm_savannah_wafer)
	(object_create dm_savannah_wafer)
	(device_set_position_track dm_savannah_wafer "m45_dock" 0)
	(device_set_position_immediate dm_savannah_wafer 0)	
	(device_animate_position dm_savannah_wafer 0.99 60 1 0 false)
)

(script static void crv_savannah_orbit
	(object_destroy dm_savannah_corvette)
	(object_create dm_savannah_corvette)
	(device_set_position_track dm_savannah_corvette "m45_orbit_corvette" 0)
	(device_set_position_immediate dm_savannah_corvette 0)
	
	
	(device_set_power dm_savannah_corvette 1)
)

(script dormant crv_savannah_setup_and_start
	(crv_savannah_warp)
)

(script static void crv_savannah_warp
	(object_create_anew dm_savannah_corvette)
	(object_function_set 0 0.8)
	;(object_set_function_variable dm_savannah_corvette "frigate_engines" 0.8 1)
	(savannah_load_gunners dm_savannah_corvette)
	(device_set_power dm_savannah_corvette 0)
	
	(device_set_position_track dm_savannah_corvette "m45_warp_in" 0)
	(device_set_position_immediate dm_savannah_corvette 0)
	;(device_animate_position dm_savannah_corvette 0 0 0 0 false)
	;(device_set_position_immediate dm_savannah_corvette 0)
	(device_animate_position dm_savannah_corvette 0.99 25 0 3 false)
	
	
	(sleep (- (* 30 25) 12))
	;(sleep 600)
	;(sleep 278)
	
	(if debug (print "savannah: entering m45_orbit_corvette track..."))
	
	(object_destroy dm_savannah_corvette)
	(object_create dm_savannah_corvette)
	
	(savannah_load_gunners dm_savannah_corvette)
	(device_set_position_immediate dm_savannah_corvette 0)
	(device_set_position_track dm_savannah_corvette "m45_orbit_corvette" 0)
	
	;(device_animate_position dm_savannah_corvette 1 0 0 0 false)
	;(device_animate_position dm_savannah_corvette 1.0 10 0 1 true)
	(device_set_power dm_savannah_corvette 1)
	(object_function_set 0 1.0)
	;(object_set_function_variable dm_savannah_corvette "frigate_engines" 1 90)
	;(device_set_position_immediate dm_savannah_corvette 0)
	
	(if (< s_crv_engines_damaged 4)
		(wake md_crv_sav_clip_engines)
		
		(set b_crv_all_engines_damaged true)
	)
	
)

; =================================================================================================
; LONG NIGHT OF SOLACE
; =================================================================================================

(script static void lnos_setup
	(object_create_anew dm_lnos)
	(object_cinematic_visibility dm_lnos true)
	(device_set_position_track dm_lnos "m45_lnos_approach" 0)
	;(object_cinematic_visibility dm_lnos true)
	;(device_set_position_immediate dm_lnos 0)
)

(script static void lnos_setup_bridge
	(object_create_anew dm_lnos)
	(object_cinematic_visibility dm_lnos true)
	(device_set_position_track dm_lnos "m45_lnos_approach" 0)
	(device_animate_position dm_lnos 0.65 0 0 0 false)
	(sleep 1)
	
)

(script static void lnos_arrive
	(sound_impulse_start sound\levels\solo\m45\corvette_power_up.sound NONE 1)
	(device_animate_position dm_lnos 1.0 (* 60 10) 1 3 false)
	(cam_shake 10 0.10 3 5)
)

(script static void lnos_arrive_fast
	;(objects_attach sky_corvette_nosun "long_night_of_solace" dm_lnos "")
	(device_animate_position dm_lnos 1.0 10 1 3 false)
)


; =================================================================================================
; SPACE DEBRIS
; =================================================================================================
(global real r_crv_debris_speed 20)
(global short s_crv_debris_spawn_delay_min 60)
(global short s_crv_debris_spawn_delay_max 120)
; -------------------------------------------------------------------------------------------------
(script dormant crv_debris_control
	(crv_spawn_moving_debris sc_crv_debris_00 10)
	(crv_spawn_moving_debris sc_crv_debris_01 10)
	(crv_spawn_moving_debris sc_crv_debris_02 10)
	(crv_spawn_moving_debris sc_crv_debris_03 10)
	(crv_spawn_moving_debris sc_crv_debris_04 10)
	(crv_spawn_moving_debris sc_crv_debris_05 10)
	(crv_spawn_moving_debris sc_crv_debris_06 10)
	(crv_spawn_moving_debris sc_crv_debris_07 10)
	(crv_spawn_moving_debris sc_crv_debris_08 10)
	(crv_spawn_moving_debris sc_crv_debris_09 10)
)

(script static void (crv_spawn_moving_debris (object_name debris) (short frame))
	(object_create_anew debris)
	(object_cinematic_visibility debris true)
	(sleep (random_range s_crv_debris_spawn_delay_min s_crv_debris_spawn_delay_max))
)



(script static void (attach_and_animate 
		(object_name to_attach) 
		(boolean cinematic_visibility)
		(device_name marker) 
		
		(string_id track)
		(real start_position)
		(real end_position)
		(real time))
	
	(object_create_anew marker)
	(object_cinematic_visibility marker true)
	(device_set_position_track marker track 0)
	(device_set_position_immediate marker start_position)
	(sleep 1)
	
	(object_create_anew to_attach)
	;(object_cinematic_visibility to_attach true)

	;(object_hide to_attach true)
	;
	(objects_attach marker "" to_attach "")
	;(object_hide to_attach false)
	(device_animate_position marker end_position time 0 0 true)
	
)

;*
(script static void (bch_seraph_bombingrun_loop (device_name marker) (object_name bomber))
	(sleep_until
		(begin
			(bch_seraph_bombingrun_start marker bomber)
			(sleep_until (>= (device_get_position marker) 1) 1)
			;(objects_detach dm_marker_seraph_bombingrun0 (ai_vehicle_get_from_spawn_point sq_cov_bch_seraph_bombers0/pilot0))
			(object_destroy bomber)
			(sleep (random_range 0 10))
		b_bch_bombingrun_complete)
	1)
)
*;
; =================================================================================================
; PODS
; =================================================================================================
(script static void bch_pod_test
	(drop_pod dm_bch_pod_marker_start0 sq_cov_bch_landing0/elite0)
	(drop_pod dm_bch_pod_marker_start1 sq_cov_bch_landing0/elite1)
)


(global short s_pod_drop_interval 15)
(script dormant crv_pod_drop_left_control
	(sleep_until
		(begin
			; -------------------------------------------------
			; group left01
			(crv_launch_pods 
				dm_crv_pod_left_00 "m45_drop_a1"	
				dm_crv_pod_left_01 "m45_drop_a2"
				dm_crv_pod_left_02 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_03 "m45_drop_a1"	
				dm_crv_pod_left_04 "m45_drop_a2"
				dm_crv_pod_left_05 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_06 "m45_drop_a1"	
				dm_crv_pod_left_07 "m45_drop_a2"
				dm_crv_pod_left_08 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_09 "m45_drop_a1"	
				dm_crv_pod_left_10 "m45_drop_a2"
				dm_crv_pod_left_11 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_12 "m45_drop_a1"	
				dm_crv_pod_left_13 "m45_drop_a2"
				dm_crv_pod_left_14 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_15 "m45_drop_a1"	
				dm_crv_pod_left_16 "m45_drop_a2"
				dm_crv_pod_left_17 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_18 "m45_drop_a1"	
				dm_crv_pod_left_19 "m45_drop_a2"
				dm_crv_pod_left_20 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			
			(crv_launch_pods 
				dm_crv_pod_left_21 "m45_drop_a1"	
				dm_crv_pod_left_22 "m45_drop_a2"
				dm_crv_pod_left_23 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_24 "m45_drop_a1"	
				dm_crv_pod_left_25 "m45_drop_a2"
				dm_crv_pod_left_26 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_left_27 "m45_drop_a1"	
				dm_crv_pod_left_28 "m45_drop_a2"
				dm_crv_pod_left_29 "m45_drop_a3")

			(sleep (* 30 10))
		b_brd_started)
	1)
)

(script dormant crv_pod_drop_right_control
	(sleep_until
		(begin
			; -------------------------------------------------
			(crv_launch_pods 
				dm_crv_pod_right_00 "m45_drop_a1"	
				dm_crv_pod_right_01 "m45_drop_a2"
				dm_crv_pod_right_02 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_03 "m45_drop_a1"	
				dm_crv_pod_right_04 "m45_drop_a2"
				dm_crv_pod_right_05 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_06 "m45_drop_a1"	
				dm_crv_pod_right_07 "m45_drop_a2"
				dm_crv_pod_right_08 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_09 "m45_drop_a1"	
				dm_crv_pod_right_10 "m45_drop_a2"
				dm_crv_pod_right_11 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_12 "m45_drop_a1"	
				dm_crv_pod_right_13 "m45_drop_a2"
				dm_crv_pod_right_14 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_15 "m45_drop_a1"	
				dm_crv_pod_right_16 "m45_drop_a2"
				dm_crv_pod_right_17 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_18 "m45_drop_a1"	
				dm_crv_pod_right_19 "m45_drop_a2"
				dm_crv_pod_right_20 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			
			(crv_launch_pods 
				dm_crv_pod_right_21 "m45_drop_a1"	
				dm_crv_pod_right_22 "m45_drop_a2"
				dm_crv_pod_right_23 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_24 "m45_drop_a1"	
				dm_crv_pod_right_25 "m45_drop_a2"
				dm_crv_pod_right_26 "m45_drop_a3")
			(sleep s_pod_drop_interval)
			
			(crv_launch_pods 
				dm_crv_pod_right_27 "m45_drop_a1"	
				dm_crv_pod_right_28 "m45_drop_a2"
				dm_crv_pod_right_29 "m45_drop_a3")

			(sleep (* 30 10))
		b_brd_started)
	1)
)

(script static void (crv_launch_pods 
					(device_name d1) 
					(string_id anim1) 
					(device_name d2)
					(string_id anim2)  
					(device_name d3)
					(string_id anim3))
					
	(object_create_anew d1)
	(object_create_anew d2)
	(object_create_anew d3)

	(device_set_position_track d1 anim1 0)
	(device_set_position_track d2 anim2 0)
	(device_set_position_track d3 anim3 0)
	
	(device_animate_position d1 0 0 0 0 false)
	(device_animate_position d2 0 0 0 0 false)	
	(device_animate_position d3 0 0 0 0 false)
	
	(device_animate_position d1 1.0 10 0 0 false)
	(device_animate_position d2 1.0 10 0 0 false)
	(device_animate_position d3 1.0 10 0 0 false)
	
	(sleep (* 30 10))
	
	(if (<= (object_get_health d1) 0)
		(begin
			(if debug (print "submitting incident for pod"))
			(submit_incident_with_cause_player "m45_elite_pod" player0)
			(submit_incident_with_cause_player "m45_elite_pod" player1)
			(submit_incident_with_cause_player "m45_elite_pod" player2)
			(submit_incident_with_cause_player "m45_elite_pod" player3)))
			
	(if (<= (object_get_health d2) 0)
		(begin
			(if debug (print "submitting incident for pod"))
			(submit_incident_with_cause_player "m45_elite_pod" player0)
			(submit_incident_with_cause_player "m45_elite_pod" player1)
			(submit_incident_with_cause_player "m45_elite_pod" player2)
			(submit_incident_with_cause_player "m45_elite_pod" player3)))
			
	(if (<= (object_get_health d3) 0)
		(begin
			(if debug (print "submitting incident for pod"))
			(submit_incident_with_cause_player "m45_elite_pod" player0)
			(submit_incident_with_cause_player "m45_elite_pod" player1)
			(submit_incident_with_cause_player "m45_elite_pod" player2)
			(submit_incident_with_cause_player "m45_elite_pod" player3)))
	
	(sleep 1)
	(object_destroy d1)
	(object_destroy d2)
	(object_destroy d3)
)

(script static void bch_test_jetpack_pods
	(wake bch_pod_drop_jetpack0)
	(sleep (random_range 10 15))
	(wake bch_pod_drop_jetpack1)
	(sleep (random_range 10 15))
	(wake bch_pod_drop_jetpack2)
)


(script dormant bch_pod_drop_jetpack0
	(sleep 7)
	(drop_pod dm_bch_pod_marker_jetpack0 sq_cov_bch_rocks_jetpacks0/jetpack0)
	;*
	(object_create_anew dm_bch_pod_jetpack0)
	(device_set_position_track dm_bch_pod_jetpack0 "pod_drop_100wu" 0)	
	(device_animate_position dm_bch_pod_jetpack0 1.0 5.0 2 0 false)
	(sleep (* 30 5))
	(ai_place sq_cov_bch_rocks_jetpacks0/jetpack0)
	*;
)

(script dormant bch_pod_drop_jetpack1
	(sleep (random_range 0 20))
	(drop_pod dm_bch_pod_marker_jetpack1 sq_cov_bch_rocks_jetpacks0/jetpack1)
	
	;*
	(object_create_anew dm_bch_pod_jetpack1)
	(device_set_position_track dm_bch_pod_jetpack1 "pod_drop_100wu" 0)	
	(device_animate_position dm_bch_pod_jetpack1 1.0 5.0 2 0 false)
	(sleep (* 30 5))
	(ai_place sq_cov_bch_rocks_jetpacks0/jetpack1)
	*;
)

(script dormant bch_pod_drop_jetpack2
	(sleep 18)
	(sleep (random_range 0 20))
	(drop_pod dm_bch_pod_marker_jetpack2 sq_cov_bch_rocks_jetpacks0/jetpack2)
	;*
	(object_create_anew dm_bch_pod_jetpack2)
	(device_set_position_track dm_bch_pod_jetpack2 "pod_drop_100wu" 0)	
	(device_animate_position dm_bch_pod_jetpack2 1.0 5.0 2 0 false)
	(sleep (* 30 5))
	(ai_place sq_cov_bch_rocks_jetpacks0/jetpack2)
	*;
)

(script dormant bch_pod_drop_counter0
	(sleep (random_range 120 180))
	(drop_pod dm_bch_pod_marker_counter0 sq_cov_bch_counter_elites0/elite0)
)


; =================================================================================================
; CORVETTE POWER
; =================================================================================================
(script static void power_down_corvette
	(if debug (print "corvette gets rocked..."))
	(sound_impulse_start sound\levels\120_halo\trench_run\island_creak.sound NONE 1)
	(sound_class_set_gain amb 0 90)
	(cam_shake 0.2 1 2 3)
	
	(if debug (print "corvette powers back up"))
	(sound_class_set_gain amb 1 90)
)


; =================================================================================================
; CRASHING SERAPH
; =================================================================================================
(script dormant bch_seraph_crash_control
			
	(sleep_until (>= s_objcon_bch 60))
	
			; -------------------------------------------------
			(ai_place sq_cov_bch_seraphs/crash0)
			(object_create_anew dm_bch_seraph_crash)
			(device_set_position_track dm_bch_seraph_crash "e3_seraph_crash0" 1)
			(sleep 2)
			
			(objects_attach dm_bch_seraph_crash "" (ai_vehicle_get sq_cov_bch_seraphs/crash0) "")
			(device_set_power dm_bch_seraph_crash 1)
			(device_set_position dm_bch_seraph_crash 1)
			(device_animate_position dm_bch_seraph_crash 1.0 6 0 0 true)	
			; -------------------------------------------------
	
	(sleep_until (>= (device_get_position dm_bch_seraph_crash) 1) 1)
	
			; -------------------------------------------------
			(objects_detach dm_bch_seraph_crash (ai_vehicle_get_from_starting_location sq_cov_bch_seraphs/crash0))
			;(damage_object (ai_vehicle_get_from_starting_location sq_cov_bch_seraph_bombers0/pilot_crash0) "" 1000)
			(ai_erase sq_cov_bch_seraphs/crash0)
			(object_destroy (ai_vehicle_get_from_starting_location sq_cov_bch_seraphs/crash0))
			(effect_new_on_object_marker objects\levels\solo\m45\wall_panel\fx\wall_panel_destroyed.effect sc_wall_panel "")
			(object_set_permutation sc_wall_panel default destroyed)
			(object_create_folder seraph_impact)
			(object_destroy dm_bch_seraph_crash)
			(damage_object sc_wall_panel "" 1000)
			
			(cam_shake 0.2 1 1 3)
			(sleep 300)
			(object_destroy sc_wall_panel)
)

; -------------------------------------------------------------------------------------------------
; SPACE BATTLE
; -------------------------------------------------------------------------------------------------
(global boolean b_ambient_battle_paused false)
(script dormant amb_corvette_battle

	(branch
		(= b_hgr_switch_flipped true) (branch_abort)
	)
	
	(ai_place sq_cov_amb_seraphs0)
	(sleep 1)
	(ai_set_targeting_group sq_cov_amb_seraphs0 s_tg_ambient_battle true)
	(ai_set_clump sq_cov_amb_seraphs0 CLUMP_SERAPHS)
						
	(sleep 60)
	
	
	(sleep_until
		(begin
			(sleep_until (not b_ambient_battle_paused))
			
			(sleep_until
				(or 
					(<= (ai_living_count gr_unsc_amb) 0)
					(<= (ai_living_count gr_cov_amb) 0)))
			
			(sleep (random_range 90 210))		
			(if debug (print "ambient space battle: squad defeated... spawning reinforcements..."))
			
			
			(if (<= (ai_living_count gr_unsc_amb) 0)
					(begin
						(ai_place sq_unsc_amb_sabres0)
						(sleep 1)
						(ai_set_targeting_group sq_unsc_amb_sabres0 s_tg_ambient_battle false)
						(ai_set_clump sq_unsc_amb_sabres0 CLUMP_SABRES)
					)
					
					(begin
						(ai_place sq_cov_amb_seraphs0)
						(sleep 1)
						(ai_set_targeting_group sq_cov_amb_seraphs0 s_tg_ambient_battle false)
						(ai_set_clump sq_cov_amb_seraphs0 CLUMP_SERAPHS)
					)
			)
			
			(ai_magically_see sq_unsc_amb_sabres0 sq_cov_amb_seraphs0)
			(ai_magically_see sq_cov_amb_seraphs0 sq_unsc_amb_sabres0)
			(ai_magically_see sq_unsc_sav_gunners sq_cov_amb_seraphs0)
			
	 	(or
	 		b_hgr_switch_flipped
	 		b_grm_started
	 		b_brg_started
	 		b_esc_started
	 		b_fin_started))
	1)
)

(script dormant amb_gunroom_battle
	(branch
		(= b_savannah_destroyed true) (branch_abort)
	)

	(ai_place sq_cov_amb_seraphs0)
	(sleep 1)
	(ai_set_targeting_group sq_cov_amb_seraphs0 s_tg_ambient_battle true)
	(ai_set_clump sq_cov_amb_seraphs0 CLUMP_SERAPHS)

	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count gr_cov_amb) 0))
			(sleep (random_range 90 210))
			
			(ai_place sq_cov_amb_seraphs0)
			(sleep 1)
			(ai_set_targeting_group sq_cov_amb_seraphs0 s_tg_ambient_battle false)
			(ai_set_clump sq_cov_amb_seraphs0 CLUMP_SERAPHS)
			
			(ai_magically_see sq_unsc_amb_sabres0 sq_cov_amb_seraphs0)
			(ai_magically_see sq_cov_amb_seraphs0 sq_unsc_amb_sabres0)
			(ai_magically_see sq_unsc_sav_gunners sq_cov_amb_seraphs0)
		b_savannah_destroyed)
	1)
)


; =================================================================================================
; CHAPTER TITLES
; =================================================================================================
(script static void (new_mission_objective (string_id screen) (string_id start_menu))
	;(objectives_clear)
	(chud_show_screen_objective "")
	(sound_impulse_start sound\game_sfx\fireteam\issue_directive.sound NONE 1)
	(f_hud_obj_new screen start_menu)
	;(cinematic_set_chud_objective t)
	;(if debug (print "objectives: adding objective to the start menu tray..."))
	;(objectives_show objective_index))
)
	
(script static void clear_mission_objectives
	(if debug (print "objectives: clearing objectives out of the start menu tray..."))
	(objectives_clear))
	
(script static void (show_tutorial (cutscene_title t))
	(sound_impulse_start sound\game_sfx\fireteam\issue_directive.sound NONE 1)
	(cinematic_set_title ct_tutorial_footer)
	(cinematic_set_title t)
	(sleep (* 30 10)))

(script static void show_fighter_warning
	(sound_impulse_start sound\game_sfx\fireteam\issue_directive.sound NONE 1)
	(chud_set_static_hs_variable player0 1 1)
	(chud_set_static_hs_variable player1 1 1)
	(chud_set_static_hs_variable player2 1 1)
	(chud_set_static_hs_variable player3 1 1)
)

(script static void clear_fighter_warning
	(sound_impulse_start sound\game_sfx\fireteam\issue_directive.sound NONE 1)
	(chud_clear_hs_variable player0 1)
	(chud_clear_hs_variable player1 1)
	(chud_clear_hs_variable player2 1)
	(chud_clear_hs_variable player3 1)
)

	
(script static void (show_update (cutscene_title t))
	(sound_impulse_start sound\game_sfx\fireteam\issue_directive.sound NONE 1)
	;(cinematic_set_title ct_obj_update_footer)
	(cinematic_set_chud_objective t))


(script dormant show_objective_beach
	(new_mission_objective ct_obj_beach PRIMARY_OBJECTIVE_1))
	
(script dormant show_objective_flight_control
	(new_mission_objective ct_obj_command PRIMARY_OBJECTIVE_2))
	
(script dormant show_objective_launch
	(new_mission_objective ct_obj_launch PRIMARY_OBJECTIVE_4))
	
(script dormant show_objective_corvette_escort
	(new_mission_objective ct_obj_corvette PRIMARY_OBJECTIVE_9))
	
(script dormant show_objective_comms_seize
	(new_mission_objective ct_obj_comms_kill PRIMARY_OBJECTIVE_13))
	
(script dormant show_objective_rescue_jorge
	(new_mission_objective objective_crv_escape PRIMARY_OBJECTIVE_16))
	
(script dormant show_objective_bioscanner
	(new_mission_objective ct_obj_command_scanner PRIMARY_OBJECTIVE_3))
	
(script dormant show_objective_wafer_defense
	(new_mission_objective ct_obj_wafer_defend PRIMARY_OBJECTIVE_6))
	
(script dormant show_objective_wafer_guns_online
	(new_mission_objective ct_obj_wafer_online PRIMARY_OBJECTIVE_7))
	
(script dormant show_objective_wafer_dock
	(new_mission_objective ct_obj_wafer_dock PRIMARY_OBJECTIVE_8))
	
(script dormant show_objective_corvette_entrance
	(new_mission_objective ct_obj_corvette_hole PRIMARY_OBJECTIVE_11))
	
(script dormant show_objective_corvette_landing
	(new_mission_objective ct_obj_boarding PRIMARY_OBJECTIVE_12))
	
(script dormant show_objective_go_to_hangar
	(new_mission_objective objective_crv_hangar PRIMARY_OBJECTIVE_14))
	
(script dormant show_objective_sieze_bridge
	(new_mission_objective objective_crv_brg PRIMARY_OBJECTIVE_15)) 
	
(script dormant show_objective_defend_bomb
	(new_mission_objective objective_crv_final PRIMARY_OBJECTIVE_16))
	
(script dormant show_objective_engage_refuel
	(new_mission_objective objective_crv_brg_refuel PRIMARY_OBJECTIVE_15))
	
(script dormant show_objective_corvette_engines
	(new_mission_objective objective_crv_engines PRIMARY_OBJECTIVE_10)
	)
(script dormant show_chapter_title_beach
	(f_hud_chapter ct_beach))

(script dormant show_chapter_title_wafer
	(f_hud_chapter ct_wafer))

(script dormant show_chapter_title_corvette
	(begin_random_count 1
		(f_hud_chapter ct_corvette)
		(f_hud_chapter ct_corvette_alt)
	)
)
; =================================================================================================
; TUTORIAL
; =================================================================================================
(global short s_players_finished_tutorial 0)
(global boolean b_saber_tutorial_complete false)
(global short s_players_in_game 0)
(global short s_sabre_tutorial_delay 30)
; -------------------------------------------------------------------------------------------------
(script static void (start_sabre_tutorial (player player_variable))

	(branch
		(= b_saber_tutorial_complete true)
		(cancel_sabre_tutorial))
		
	(f_tutorial_turn player_variable ct_tutorial_turning)
	(sleep s_sabre_tutorial_delay)
	
	(f_tutorial_throttle player_variable ct_tutorial_throttle)
	(sleep s_sabre_tutorial_delay)

	; teach the player boost
	(f_tutorial_boost player_variable ct_tutorial_boost)
	(md_sabre_boost player_variable)
	(sleep s_sabre_tutorial_delay)
	
	; teach the weapon usage
	(f_tutorial_fire_weapon player_variable ct_tutorial_weapon)
	(sleep s_sabre_tutorial_delay)
	;(md_sabre_boost player_short)
	
	; teach the player to toggle weapons
	(f_tutorial_rotate_weapons player_variable ct_tutorial_toggle)
	(md_sabre_weapons_toggle player_variable)
	(sleep s_sabre_tutorial_delay)
	
	;(f_tutorial_fire_weapon player_variable ct_tutorial_weapon)
	
	(f_tutorial_tricks player_variable ct_tutorial_tricks)
	
	; well done, player...
	(if debug (print "tutorial: player has completed flight training!"))
	(set s_players_finished_tutorial (+ s_players_finished_tutorial 1))
)	
	

(script static void cancel_sabre_tutorial
	(if debug (print "tutorial: canceling or finishing sabre tutorial for a player...")))
	
(script dormant sabre_tutorial
	;(md_sabre_tutorial_start)
	
		(wake player3_sabre_tutorial)
		(wake player2_sabre_tutorial)
		(wake player1_sabre_tutorial)
		(wake player0_sabre_tutorial)
	
	; wait for everyone to finish the tutorial or time out if they fuck off
	(sleep_until (>= s_players_finished_tutorial (game_coop_player_count)) 1 (* 30 60))
	
	(sleep 30)
	; blank out their tutorials
	(f_hud_training_clear player0)
	(f_hud_training_clear player1)
	(f_hud_training_clear player2)
	(f_hud_training_clear player3)
	
	(md_sabre_tutorial_end)
	(set b_saber_tutorial_complete true)
)

(script dormant player0_sabre_tutorial
	(if debug (print "tutorial: starting player 1 sabre training..."))
	(start_sabre_tutorial player0))
	
(script dormant player1_sabre_tutorial
	(if debug (print "tutorial: starting player 2 sabre training..."))
	(start_sabre_tutorial player1))
	
(script dormant player2_sabre_tutorial
	(if debug (print "tutorial: starting player 3 sabre training..."))
	(start_sabre_tutorial player2))
	
(script dormant player3_sabre_tutorial
	(if debug (print "tutorial: starting player 4 sabre training..."))
	(start_sabre_tutorial player3))
		


; DIALOGUE
; -------------------------------------------------------------------------------------------------
(script static void (md_play_on_player (short player_short) (sound line))
	(sound_impulse_start line (player_get player_short) 1)
	(sleep (sound_impulse_language_time line)))
; -------------------------------------------------------------------------------------------------

(script static void (md_sabre_boost (player player_variable))
	(md_print "SABRE FLIGHT COMPUTER: Forward thrusters online.")
	(md_object_play 0 player_variable m45_0780_sab)
)

(script static void (md_sabre_rear_thruster (player player_variable))
	(md_print "SABRE FLIGHT COMPUTER: Rear thrusters online.")
	(md_object_play 0 player_variable m45_0790_sab)
)

(script static void (md_sabre_weapons_toggle (player player_variable))
	(md_print "SABRE FLIGHT COMPUTER: Dual weapons systems online.")
	(md_object_play 0 player_variable m45_0810_sab)
)

(script static void (md_sabre_aux (player player_variable))
	(md_print "SABRE FLIGHT COMPUTER: Auxilliary boosters online.")
	(md_object_play 0 player_variable m45_0800_sab)
)

(script static void md_sabre_tutorial_start
	(md_start)
		
		(md_print "HOLLAND: Noble Six, these Sabres have been customized for orbital defense. You may need to get reacquainted.")
		(md_print "HOLLAND: Rendezvous at anchor 9 with Frigate Savannah and the other Sabres as soon as you're ready. Holland out.")
		(md_object_play 0 NONE m45_0770)
	
	(md_stop)
	
	(if debug (print "mus_05 starting"))
	(mus_start mus_05)
)

(script static void md_sabre_tutorial_end
	(md_start)
	
		(md_print "JORGE: Okay, Lieutenant. Playtime's over. Let's get this show on the road.")
		(md_object_play 0 NONE m45_0820)
	
	(md_stop)
)

(script static void md_sabre_tutorial_end_2
	(md_print "JORGE: Come on, Spartan. We need to rendezvous with the Savannah.")
	(md_object_play 0 NONE m45_0830)
)

(script dormant show_tutorial_seraph_shields
	(sleep (* 5 30))
	
	(wake md_hol_guns_on_shields)
	
	(f_hud_training_forever player0 ct_tutorial_seraph_shields)
	(f_hud_training_forever player0 ct_tutorial_seraph_shields)
	(f_hud_training_forever player0 ct_tutorial_seraph_shields)
	(f_hud_training_forever player0 ct_tutorial_seraph_shields)
	
	(sleep (* 4 30))
	
	(f_hud_training_clear player0)
	(f_hud_training_clear player1)
	(f_hud_training_clear player2)
	(f_hud_training_clear player3)
	
	(sleep (* 1 30))
	
	(f_hud_training_forever player0 ct_tutorial_seraph_hull)
	(f_hud_training_forever player0 ct_tutorial_seraph_hull)
	(f_hud_training_forever player0 ct_tutorial_seraph_hull)
	(f_hud_training_forever player0 ct_tutorial_seraph_hull)
	
	(sleep (* 4 30))
	
	(f_hud_training_clear player0)
	(f_hud_training_clear player1)
	(f_hud_training_clear player2)
	(f_hud_training_clear player3)
	
	(sleep (* 1 30))
)


; =================================================================================================
(script static void (cam_shake (real attack) (real intensity) (short duration) (real decay))
	(player_effect_set_max_rotation 3 3 3)
	(player_effect_start intensity attack)
	(sleep duration)
	(player_effect_stop decay))
	
(script static void trigger_bombing
	(sound_impulse_start sound\levels\solo\m45\base_scripted_expl2.sound NONE 1)
	(sleep 10)
	(cam_shake 1 0.28 50 0.45)
	(interpolator_start base_bombing)
)

(script dormant fac_trigger_bombing_00
	(sleep (random_range 15 45))
	(trigger_bombing))
	
(script dormant fac_trigger_bombing_01
	(sleep (random_range 15 45))
	;(wake md_fac_spkr_warning2)
	(trigger_bombing))

(script static void trigger_bombing_heavy
	(sound_impulse_start sound\levels\solo\m45\base_scripted_expl1.sound NONE 1)
	(sleep 10)
	(cam_shake 1 0.5 50 0.45)
	(interpolator_start base_bombing)
)




; BOMBING RUN
; -------------------------------------------------------------------------------------------------
(global short s_lnc_bombingrun_delay_min 10)
(global short s_lnc_bombingrun_delay_max 25)
(global real s_lnc_seraph_bombingrun_time 6)

(script static void (seraph_bombingrun_loop (device_name marker) (object_name bomber))
	(sleep_until
		(begin
			(seraph_bombingrun_start marker bomber)
			(sleep_until (>= (device_get_position marker) 1) 1)
			;(objects_detach dm_marker_seraph_bombingrun0 (ai_vehicle_get_from_spawn_point sq_cov_bch_seraph_bombers0/pilot0))
			(object_destroy bomber)
			(sleep (random_range 0 10))
		0)
	1)
)

(script static void (seraph_bombingrun_single (device_name marker) (object_name bomber))
	(seraph_bombingrun_start marker bomber)
	(sleep_until (>= (device_get_position marker) 1) 1)
	;(objects_detach dm_marker_seraph_bombingrun0 (ai_vehicle_get_from_spawn_point sq_cov_bch_seraph_bombers0/pilot0))
	(object_destroy bomber)
	(sleep (random_range 0 10))

)

(script static void (seraph_bombingrun_start (device_name marker) (object_name bomber))
	(object_create_anew marker)
	(device_set_position_track marker "e3_seraph_flyover0" 0)
	(device_set_position_immediate marker 0)
	(sleep 1)
	
	(object_create bomber)
	(sleep 1)
	
	(objects_attach marker "" bomber "")
	(device_animate_position marker 1.0 s_lnc_seraph_bombingrun_time 0 0 true)
)

(script dormant lnc_bombingrun_00
	(seraph_bombingrun_single dm_marker_bombingrun_00 v_seraph_bomber_00))
	
(script dormant lnc_bombingrun_01
	(seraph_bombingrun_single dm_marker_bombingrun_01 v_seraph_bomber_01))
	
(script dormant lnc_bombingrun_02
	(seraph_bombingrun_single dm_marker_bombingrun_02 v_seraph_bomber_02))
	
(script dormant lnc_bombingrun_03
	(seraph_bombingrun_single dm_marker_bombingrun_03 v_seraph_bomber_03))
	

(script static void start_lnc_bombingrun
	(if debug (print "starting launch facility bombing run"))
	(wake lnc_bombingrun_00)
	(sleep (random_range s_lnc_bombingrun_delay_min s_lnc_bombingrun_delay_max))
	
	(wake lnc_bombingrun_01)
	(sleep (random_range s_lnc_bombingrun_delay_min s_lnc_bombingrun_delay_max))
	
	(wake lnc_bombingrun_02)
	(sleep (random_range s_lnc_bombingrun_delay_min s_lnc_bombingrun_delay_max))
	
	(wake lnc_bombingrun_03)
	(sleep (random_range s_lnc_bombingrun_delay_min s_lnc_bombingrun_delay_max))
	
	(sleep (* 30 9))
	(lnc_setup_aa)
	(lnc_seraphs_loop)
)


(script static void lnc_bombingrun_kill
	(sleep_forever lnc_bombingrun_00)
	(sleep_forever lnc_bombingrun_01)
	(sleep_forever lnc_bombingrun_02)
	(sleep_forever lnc_bombingrun_03)
		
	(object_destroy_folder v_lnc_seraphs)
	(object_destroy_folder dm_lnc_bombingrun)
)

; HANGAR PELICAN
; -------------------------------------------------------------------------------------------------
(script static void (setup_hangar_pelican (short enc))
	; create the pelican and slipspace bomb
	(object_create sc_hgr_pelican)
	(scenery_animation_start_at_frame sc_hgr_pelican objects\vehicles\human\pelican\pelican.model_animation_graph "vehicle:fully_opened" 100)
	(object_create sc_hgr_slipspace)
	
	; create the equipment cases
	(object_create sc_hgr_equipmentcase0)
	(object_create sc_hgr_equipmentcase1)
	
	; create the nutblockers
	(object_create_folder cr_hgr_pelican)
	(object_create sc_hgr_pelican_left_leg0)
	(object_create sc_hgr_pelican_left_leg1)
	(object_create sc_hgr_pelican_right_leg0)
	(object_create sc_hgr_pelican_right_leg1)
	
	; create the health packs
	(object_create_folder hp_hgr)
	
	; create the weapons
	(object_create_folder wp_grm)
	
	; create the common weapons crates
	(object_create dm_grm_weapons0)
	(object_create dm_grm_weapons1)
	
	; create the equipment
	(object_create_folder eq_grm)
	
	(if (= enc 0)
		(begin
			; GUNROOM
			; -------------------------------------------------
			(if debug (print "gunroom weapons"))
			(object_destroy dm_fin_weapons0)
			(object_destroy dm_fin_weapons1)
			(object_destroy dm_fin_weapons2)
			(object_create dm_grm_weapons_closed0)
			(object_create dm_grm_weapons_closed1)
			(object_create dm_grm_weapons_closed2)
		)
		
		(begin
			; FINAL
			; -------------------------------------------------
			(if debug (print "final"))
			(object_destroy dm_grm_weapons_closed0)
			(object_destroy dm_grm_weapons_closed1)
			(object_destroy dm_grm_weapons_closed2)
			(object_create dm_fin_weapons0)
			(object_create dm_fin_weapons1)
			(object_create dm_fin_weapons2)
			
			(object_create wp_fin_plasmalauncher0)
			
			(if (difficulty_is_heroic_or_higher)
				(begin
					(if debug (print "spawning dmrs"))
					(object_create wp_fin_dmr0_heroic)
					(object_create wp_fin_dmr1_heroic)
				)
				
				(begin
					(if debug (print "spawning rocket launcher"))
					(object_create wp_fin_rocketlauncher0)
				)
			)
		)
	)
)

(global sound sfx_light_quad sound\levels\solo\m45\flood_light\flood_light_quad.sound)
(global sound sfx_light sound\levels\solo\m45\flood_light\flood_light.sound)

(script dormant lnc_light_control
	(sleep_until (> (device_get_position dm_slo_shutter) 0.5) 1)
	(lnc_lights_on)
)

(script static void lnc_lights_on
	(object_destroy_folder sc_lnc_lights)
	(sleep 1)

	(if debug (print "::: low lights on :::"))
	(object_create sc_slo_lights_low)
	
	(sound_impulse_start sfx_light ss_flood_light_low_left 1.0)
	(sound_impulse_start sfx_light ss_flood_light_low_right 1.0)
	(sound_impulse_start sfx_light_quad ss_flood_light_low_left 1.0)
	(sound_impulse_start sfx_light_quad ss_flood_light_low_right 1.0)
	
		(sleep 45)
	
	(if debug (print "::: mid lights on :::"))
	(object_create sc_slo_lights_mid)
	
	(sound_impulse_start sfx_light ss_flood_light_mid_left 1.0)
	(sound_impulse_start sfx_light ss_flood_light_mid_right 1.0)
	(sound_impulse_start sfx_light_quad ss_flood_light_mid_left 1.0)
	(sound_impulse_start sfx_light_quad ss_flood_light_mid_right 1.0)
	
	
		(sleep 55)
	
	(if debug (print "::: high lights on :::"))
	(object_create launch_facility_light)
	
	(sound_impulse_start sfx_light ss_flood_light_top_left 1.0)
	(sound_impulse_start sfx_light ss_flood_light_top_right 1.0)
	(sound_impulse_start sfx_light_quad ss_flood_light_top_left 1.0)
	(sound_impulse_start sfx_light_quad ss_flood_light_top_right 1.0)
	
)


(script static void (bch_skybox_pod_drop (device_name d))
	(object_create_anew d)
	(object_cinematic_visibility d true)
	(device_set_position_track d "m45_skybox_drop_600wu" 0)
	(device_animate_position d 1.0 6.0 2 0 false)
)



(script static void bch_skybox_pod_trail
	(bch_skybox_pod_drop dm_skybox_pod_00)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_01)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_02)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_03)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_04)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_05)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_06)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_07)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_08)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_09)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_10)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_11)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_12)
	(bch_skybox_pod_delay)
	(bch_skybox_pod_drop dm_skybox_pod_13)
)

(script static void bch_skybox_pod_delay
	(sleep (random_range 5 10))
)