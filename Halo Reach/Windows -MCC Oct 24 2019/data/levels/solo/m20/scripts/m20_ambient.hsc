; =================================================================================================
; MUSIC
; =================================================================================================

(script dormant music_memory_test
	(sound_looping_stop levels\solo\m20\music\m20_music01)
	(sound_looping_stop levels\solo\m20\music\m20_music02)
	(sound_looping_stop levels\solo\m20\music\m20_music03)
	(sound_looping_stop levels\solo\m20\music\m20_music04)
	(sound_looping_stop levels\solo\m20\music\m20_music05)
	(sound_looping_stop levels\solo\m20\music\m20_music06)
	(sound_looping_stop levels\solo\m20\music\m20_music07)
	(sound_looping_stop levels\solo\m20\music\m20_music08)
	(sound_looping_stop levels\solo\m20\music\m20_music09)
	(sound_looping_stop levels\solo\m20\music\m20_music10)
	(sound_looping_stop levels\solo\m20\music\m20_music11)
	(sound_looping_stop levels\solo\m20\music\m20_music12)
	(sound_looping_stop levels\solo\m20\music\m20_music13)
)

; =================================================================================================
; M20 OBJECTIVES
; =================================================================================================
(script static void mo_courtyard

	(f_hud_obj_new prompt_courtyard pause_courtyard)

)

(script static void mo_valley

	(f_hud_obj_new prompt_valley pause_valley)

)

(script static void mo_airview

	(f_hud_obj_new prompt_airview pause_airview)

)

(script static void mo_faragate

	(f_hud_obj_new prompt_faragate pause_faragate)

)

(script static void mo_clean

	(f_hud_obj_new prompt_clean pause_clean)

)


(script static void mo_airfar

	(f_hud_obj_new prompt_airfar pause_airfar)

)

(script static void mo_farair

	(f_hud_obj_new prompt_farair pause_farair)

)

(script static void mo_return

	(f_hud_obj_new prompt_return pause_return)

)


(script static void mo_sword

	(f_hud_obj_new prompt_sword pause_sword)

)

(script static void mo_roof

	(f_hud_obj_new prompt_roof pause_roof)

)

; =================================================================================================
; CHAPTER TITLES
; =================================================================================================

(script static void tit_courtyard

	(f_hud_chapter ct_courtyard)

)


(script static void tit_valley

	(f_hud_chapter ct_valley)

)

(script static void tit_return

	(f_hud_chapter ct_return)

)

(script static void tit_sword

	(f_hud_chapter ct_sword)

)

; =================================================================================================
; M20 ANIMATIONS
; =================================================================================================

; =================================================================================================
; MISSION DIALOGUE: MAIN SCRIPTS
; =================================================================================================
(script static void (md_play (short delay) (sound line))
	(sound_impulse_start line NONE 1)
	(sleep (sound_impulse_language_time line))
	(sleep delay)
)

; ===================================================================================================================================================
; ===================================================================================================================================================
; Radio Chatter
; ===================================================================================================================================================
; ================================================================================================================================================
(script dormant radio_chatter
	(sleep_until
		(begin
			(sleep_until b_radio_chatter)
			;(sound_looping_start sound\prototype\radio_chatter\radio_chatter_loop\radio_chatter_loop NONE 1)
			(begin_random_count 1
				(sleep (random_range 400 500))
				(sleep (random_range 900 1000))
				(sleep (random_range 2000 3000))
			)
			FALSE
		)
	)
)

(script static void test_chatter
	;(sound_looping_start sound\prototype\radio_chatter\radio_chatter_loop\radio_chatter_loop NONE 1)
	(sleep 0)
)


; ===================================================================================================================================================
; ===================================================================================================================================================
; DIALOG
; ===================================================================================================================================================
; ================================================================================================================================================
(global boolean g_dialog FALSE)


(script static void md_court_intro
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		(md_print "CARTER: Kat, Six: push back the attack on Sword base. Find out what we're dealing with.")
		(f_md_object_play (random_range 20 30) NONE m20_0010)
		;(md_print "CARTER: I'm taking the rest of the team north to shore up the perimeter.")
		;(f_md_object_play (random_range 30 60) NONE m20_0020)
		(md_print "KAT: Roger that. We’re your strike team.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0030)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)

)

(script static void md_court_north
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		(md_print "CONTROL: Spartans! Hostiles north!")
		(f_md_object_play (random_range 30 60) NONE m20_0040)
		(md_print "KAT: Let's knock some heads, Lieutenant!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0050)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)


(script static void md_court_drop_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(md_print "CONTROL: Dropship to the north!")
		(f_md_object_play (random_range 30 60) NONE m20_0100)
		(md_print "KAT: Roger that. Tracking it.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0110)
	
	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)

(script static void md_court_contacts_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "CONTROL: You've got enemy contacts, Spartans!")
		(f_md_object_play 0 NONE m20_0190)
		(set s_music_court 1)
	
	(set g_dialog FALSE)
)

(script static void md_court_combatend
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		(md_print "KAT: Noble Two to Sword control. Courtyard is clear, over.")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_kat) m20_0230)
		(set s_music_court 3)
		(md_print "CONTROL: Head for the main gate to the east. I'll brief you as you go.")
		(f_md_object_play 0 NONE m20_0240)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)

; Valley ========================================================

(script static void md_valley_airtagger
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		(md_print "KAT: Sword control, I see a target locator. Any artillery support in the area?")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_kat) m20_0310)
		(md_print "CONTROL: Limited, but we'll prioritize whatever you need, Ma'am.")
		(f_md_object_play 0 NONE m20_0320)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)

(script static void md_valley_airtagger_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Get the target locator, Six.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0340)

	(set g_dialog FALSE)
)


(script static void md_valley_airtagger_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Noble Six, pick up that target locator on your way out.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0350)

	(set g_dialog FALSE)
)

(script static void md_valley_airtagger_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Lieutenant!  We need that target locator!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0360)

	(set g_dialog FALSE)
)

(global ai ai_valley_marine_1 NONE)
(global ai ai_valley_marine_2 NONE)
(script static void md_valley_trooper_near
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(vs_cast sq_valley_marines_1/marine_1 FALSE 10 "m20_0480")
		(set ai_valley_marine_1 (vs_role 1))
		(vs_cast sq_valley_marines_1/marine_2 FALSE 10 "m20_0490")
		(set ai_valley_marine_2 (vs_role 2))

		(md_print "TROOPER 1: Check it out, troopers!  We got Spartan support!")
		(f_md_ai_play 0 ai_valley_marine_1 m20_0480)
		(md_print "TROOPER 2: Four Delta at your service!  Anything you need, just say the word!")
		(f_md_ai_play 0 ai_valley_marine_2 m20_0490)
		(md_print "KAT: Good to know, Private.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0500)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)

(script static void md_valley_hogkill
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "TROOPER: Three Echo Five Seven, headed back to base -- but we got enemy tangos on our six, copy!")
		(f_md_object_play 0 NONE m20_0370)

	(set g_dialog FALSE)
)

(script static void md_valley_tagshoot_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Six, use the target locator on that Wraith!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0380)

	(set g_dialog FALSE)
)

(script static void md_valley_tagshoot_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Six, keep the locator on the target until air support confirms a lock.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0400)

	(set g_dialog FALSE)
)

(script static void md_valley_wraiths_dead

		(md_valley_wraiths_dead_1)
		(md_valley_wraiths_dead_2)
		(sleep (random_range (* 30 3) (* 30 4)))
		(md_valley_wraiths_dead_kat)

)

(script static void md_valley_wraiths_dead_1
	
		(md_print "TROOPER 1: (cheering)")
		(f_md_ai_play 0 ai_valley_marine_1 m20_0420)

)

(script static void md_valley_wraiths_dead_2

		(md_print "TROOPER 2: (cheering)")
		(f_md_ai_play 0 ai_valley_marine_2 m20_0430)

)

(script static void md_valley_wraiths_dead_kat
	
		(md_print "KAT: OutSTANDing!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0470)

)

(script static void md_valley_hog
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Pelican inbound with transport, Six.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0720)
		(set s_music_court 4)
		(set s_music_valley 4)

	(set g_dialog FALSE)
)

(script static void md_valley_choice
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(md_print "CONTROL: The old Farragut Station has its own comms array. That should bring us back online with command.")
		(f_md_object_play (random_range 20 30) NONE m20_0260)
		(md_print "CONTROL: Airview Base has an Anti-Air battery that will help clear the skies.")
		(f_md_object_play (random_range 30 60) NONE m20_0270)
		(md_print "KAT: AA gun is to the west. Comms array is to the east. Let's roll!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0730)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)

(script static void md_valley_choice_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "CONTROL: Doesn't matter which you do first -- comms array or the AA gun -- just get 'em both up and running.")
		(f_md_object_play 0 NONE m20_0280)

	(set g_dialog FALSE)
)


(script static void md_valley_choice_air
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: I agree. Go for the gun.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0740)

	(set g_dialog FALSE)
)


(script static void md_valley_choice_far
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Good call. Let's get comms first.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0750)

	(set g_dialog FALSE)
)


; drop Shield ========================================================

(script static void md_shield_intro
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: That's a Drop Shield, Six.")
		(f_md_ai_play (random_range 20 30) (object_get_ai o_kat) m20_1160)
		(md_print "KAT: It will generate a temporary barrier that deflects incoming projectiles.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1170) 

	(set g_dialog FALSE)
)


(script static void md_shield_prompt
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Use the shield. Make sure it works.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1190) 

	(set g_dialog FALSE)
)


(script static void md_shield_confirm
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Checks out. Should help when you can't find cover.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1200) 

	(set g_dialog FALSE)
)


; Exterior ========================================================

(global short s_exterior_encounter 0)
(script static void f_md_exterior_increment

	(set s_exterior_encounter 1)

)

; Airview ========================================================

(script static void md_air_view

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: I'm picking up a power source!  We're close to the aa gun!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0830)

	(set g_dialog FALSE)

)

(script static void md_air_target

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: That's the gun over there!  Should be a reset control somewhere to get it on-line.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0845)

	(set g_dialog FALSE)

)


(script static void md_air_gun_delay_0

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: We need to activate that AA gun, Lieutenant. Go hit the reset control.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0855)

	(set g_dialog FALSE)

)

(script static void md_air_gun_delay_1

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Gun’s no good to us wihout power, activate it now!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0865)

	(set g_dialog FALSE)

)

(script static void md_air_gun_delay_2

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Six, are you hearing me? Find the reset controls and start up that gun!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_0875)

	(set g_dialog FALSE)

)

(script static void md_air_return_0

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Six!  Where are you going?")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1030)

	(set g_dialog FALSE)

)

(script static void md_air_done

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: That did it, Six. AA gun is online!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1975)

	(set g_dialog FALSE)

)

(script static void md_air_done_faragate

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "CONTROL: Nice work, Spartans. Head to Farragut Station, and get that comms array up and running.")
		(f_md_object_play 0 NONE m20_1010)

	(set g_dialog FALSE)

)

(script static void md_air_delay

	(if (= s_exterior_encounter 0) (md_air_delay_faragate))
	(if (= s_exterior_encounter 1) (md_air_delay_sword))

)

(script static void md_air_delay_faragate

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: We need to get that comms array online.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1050)

	(set g_dialog FALSE)

)

(script static void md_air_delay_sword

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(md_print "CONTROL: Noble, I need you back at Sword Base!")
		(f_md_object_play (random_range 30 60) NONE m20_1070)
		(md_print "KAT: We copy, Commander.  Let’s go, Six!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1080)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)

)

; Faragate ========================================================

(script static void md_far_view

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Hope that comms array has a working generator...")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1110)

	(set g_dialog FALSE)

)

(script static void md_far_target

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Let's search the area for a generator, Six.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1120)

	(set g_dialog FALSE)

)

(script static void md_far_generator_delay_0

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: South building, Lieutenant. Check it out!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1130)

	(set g_dialog FALSE)

)

(script static void md_far_generator_delay_1

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Generator must be in the south building. Find it, Lieutenant!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1140)

	(set g_dialog FALSE)

)

(script static void md_far_generator_found

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: There's the generator!  Go get it started!  I'll cover you!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1280)

	(set g_dialog FALSE)

)

(script static void md_far_comm

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: OK, generator is up and running!  Find that comms array.  Should be up high...")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1310)

	(set g_dialog FALSE)

)

(script static void md_far_comm_delay_0

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Six, check the structure to the north for that array.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1320)

	(set g_dialog FALSE)

)

(script static void md_far_comm_delay_1

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Array's got to be on top of that structure to the north. Find it, Six!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1320)

	(set g_dialog FALSE)

)

(script static void md_far_return_0

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Activate the comms array, Six!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1360)

	(set g_dialog FALSE)

)

(script static void md_far_return_1

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Lieutenant!  You're supposed to turn on the comms array, remember?")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1370)

	(set g_dialog FALSE)

)


(script static void md_far_done

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: You did it, Six!  Comms array up and running!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1380)

	(set g_dialog FALSE)

)

(script static void md_far_done_airview

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Now let's head for Airview Base and get that AA gun online...")
		(f_md_ai_play 10 (object_get_ai o_kat) m20_1390)

	(set g_dialog FALSE)

)

(script static void md_far_delay

	(if (= s_exterior_encounter 0) (md_far_delay_airview))
	(if (= s_exterior_encounter 1) (md_far_delay_sword))

)

(script static void md_far_delay_airview

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(md_print "CONTROL: Spartan team: what’s the ETA on that AA gun?")
		(f_md_object_play (random_range 30 60) NONE m20_1430)
		(md_print "KAT: On our way now. Let's roll, Six!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1440)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)

)

(script static void md_far_delay_sword

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(md_print "CARTER: Noble Strike this is Noble leader: get back to Sword Base A-Sap!")
		(f_md_object_play (random_range 30 60) NONE m20_1450)
		(md_print "KAT: On our way, Commander.  Six, let's go!")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1460)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)

)

; Hogdrop ========================================================

(global short s_hogdrop 0)
(script static void f_md_hogdrop_increment

	(set s_hogdrop 1)

)

(script static void md_hogdrop

	(if (= s_hogdrop 0) (md_hogdrop_0))
	(if (= s_hogdrop 1) (md_hogdrop_1))

)

(script static void md_hogdrop_0

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(md_print "CONTROL: Spartans, this is Sword control. Thought you could use some mobile firepower!")
		(f_md_object_play (random_range 30 60) NONE m20_1090)
		(md_print "KAT: Always. Take that Warthog, Six.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1100)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)

)

(script static void md_hogdrop_1

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)

		(md_print "CONTROL: Sending you some anti-armor support, Spartans.")
		(f_md_object_play (random_range 30 60) NONE m20_1450)
		(md_print "KAT: Copy that. Use the 'Hog, Noble Six.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1460)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)

)

; Return ========================================================

(script static void md_return_pre_intro

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "CONTROL: Good work, Spartans. Return to Sword Base.  The rest of your team is inbound, imminent.")
		(f_md_object_play 0 NONE m20_1400)

	(set g_dialog FALSE)

)

(script static void md_return_intro

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)

		(md_print "CARTER: Noble, be advised: Covenant Corvette moving into position.")
		(f_md_object_play (random_range 20 30) NONE m20_1540)
		(md_print "CARTER: Six, Kat. Get here quick. We'll meet you inside.")
		(f_md_object_play 0 NONE m20_1530)

		(set s_music_air 2)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)

)

(script static void md_return_gate

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		(md_print "JUN: We're stalled in the Tower atrium. Kat, where are you?")
		(f_md_object_play (random_range 30 60) NONE m20_1550)
		(md_print "KAT: Opening the gate now.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1560)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)

; Garage ========================================================

(script static void md_garage_clear
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Let’s get to the atrium.  We’ll have to go through the security office.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1600)

	(set g_dialog FALSE)
)

(script static void md_garage_elevator_prompt
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KAT: Elevator, Lieutenant. Take it.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1610)

	(set g_dialog FALSE)
)

(script static void md_garage_bomb
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		(md_print "EMILE: Corvette's hitting this base hard.")
		(f_md_object_play (random_range 30 60) NONE m20_1640)
		(md_print "KAT: Where's our orbital support? Got to be four platforms that could take it out with a single MAC round.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1650)
		;(md_print "AUNTIE DOT: The Corvette is too close to ONI Sword Base, Lieutenant Commander.  The sensitive nature of this facility prohibits risking any damage.")
		;(f_md_object_play (random_range 30 60) NONE m20_1660)
		;(md_print "EMILE: ONI Red Tape. They know there's a war on, right?")
		;(f_md_object_play 0 NONE m20_1680)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)


; Sword ========================================================


(script static void md_sword_enter
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		(md_print "SCANNER: Welcome to the Office of Naval Intelligence...")
		(f_md_object_play (random_range 30 60) NONE m20_1690)
		(md_print "KAT: I doubt that very much.")
		(f_md_ai_play 0 (object_get_ai o_kat) m20_1700)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)


(script static void md_sword_scanner
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	
		;(md_print "SCANNER: Welcome to the ONI security scanner...")
		;(f_md_object_play 10 NONE m20_1710)
		(md_print "SCANNER: Thank you -- Lieutenant.  You have been cleared for access!")
		(f_md_object_play 0 NONE m20_1720)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(set g_dialog FALSE)
)

(script static void md_sword_scanner_kat
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "SCANNER: Thank you -- Lieutenant Commander.  You have been cleared for access!")
		(f_md_object_play 0 NONE m20_1730)

	(set g_dialog FALSE)
)

(script static void md_sword_scanner_cov
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "SCANNER: Welcome to the ONI security sca--")
		(f_md_object_play 10 NONE m20_1740)
		(md_print "SCANNER: WARNING!  WARNING!  SECURITY BREACH!  SECURITY BREACH!")
		(f_md_object_play 10 NONE m20_1750)
		(md_print "SCANNER: Please wait for an ONI security representative to assist you.  Full compliance is advised.  Thank you for your cooperation!")
		(f_md_object_play 0 NONE m20_1760)

	(set g_dialog FALSE)
)


(script static void md_sword_fireteam_intro
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "CONTROL: There are multiple trooper fire teams on the ground in your area.  Feel free to enlist their help.")
		(f_md_object_play 0 NONE m20_0510)

	(set g_dialog FALSE)
)


(global ai ai_sword_marine_0_atrium NONE)
(script static void md_sword_fireteam_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(vs_cast sq_sword_marine_0_atrium FALSE 10 "m20_0480")
		(set ai_sword_marine_0_atrium (vs_role 1))

		(md_print "TROOPER: Five November, ready to go!  Just point us in the right direction!")
		(f_md_ai_play 0 ai_sword_marine_0_atrium m20_1700)

	(set g_dialog FALSE)
)

(script static void md_sword_fireteam_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "TROOPER: Alpha Company, Third Platoon! Holler if you need anything, Spartans!")
		(f_md_object_play 0 NONE m20_0560)

	(set g_dialog FALSE)

)

(script static void md_sword_atrium
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	(ai_actor_dialogue_enable (object_get_ai o_jorge) FALSE)
	
		(md_print "JORGE: Spartans! Over here!")
		(f_md_ai_play 0 gr_jorge m20_1770)
		(if (player_has_female_voice player0) (begin
			(md_print "CARTER: Six, head upstairs and assist Emile.  Jorge, make sure she gets there.")
			(f_md_object_play 0 NONE m20_1850)
		)(begin
			(md_print "CARTER: Six, head upstairs and assist Emile.  Jorge, make sure he gets there.")
			(f_md_object_play 0 NONE m20_1840)
	
		))
		(md_print "JORGE: Depend on it.")
		(f_md_ai_play 0 (object_get_ai o_jorge) m20_1860)
		(set s_music_sword 1)

	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_jorge) TRUE)
	(set g_dialog FALSE)

)

;*

		(md_print "CONTROL: Noble Team, you've got hostile air incoming!")
		(f_md_object_play (random_range 30 60) NONE m20_1780)
		(md_print "EMILE: I'm up top. Seeing multiple Banshees deploying from that Corvette.")
		(f_md_object_play (random_range 30 60) NONE m20_1790)
		(md_print "CONTROL: Got a Longsword squadron ready to drive it off so Orbital can fire a safe shot. But we'll have to elimiate those Banshees first!")
		(f_md_object_play (random_range 30 60) NONE m20_1800)
		(md_print "CARTER: We're working on it, Sword Control.")
		(f_md_object_play (random_range 30 60) NONE m20_1810)
		(md_print "EMILE: I've got good field of fire up here...")
		(f_md_object_play (random_range 30 60) NONE m20_1820)
		(md_print "CARTER: Solid copy, Four.  I'm sending Six up to assist.")
		(f_md_object_play 0 NONE m20_1830)

*;

(script static void md_sword_bomb_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "CONTROL: Corvette's gonna rip this base apart! What's the situation, Noble?!")
		(f_md_object_play (random_range 30 60) NONE m20_1870)
		(md_print "EMILE: I can't do this on my own! Need another Spartan up here!")
		(f_md_object_play (random_range 30 60) NONE m20_1880)
		(md_print "CARTER: Six! Get to the top floor and assist Emile!")
		(f_md_object_play 0 NONE m20_1890)
		(set s_music_sword 2)

	(set g_dialog FALSE)
)

(script static void md_sword_bomb_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "CONTROL: Commander, this base won't survive another salvo from that Corvette! Kill those Banshees!")
		(f_md_object_play (random_range 30 60) NONE m20_1900)
		(md_print "CARTER: Upstairs, Lieutenant!  We need those Longswords in the air!")
		(f_md_object_play 0 NONE m20_1910)

	(set g_dialog FALSE)
)

(script static void md_sword_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "CARTER: Keep moving up, Noble Six!")
		(f_md_object_play 0 NONE m20_1920)
	
	(set g_dialog FALSE)
)

(script static void md_sword_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "CARTER: We need you on the upper level, Lieutenant!")
		(f_md_object_play 0 NONE m20_1930)
	
	(set g_dialog FALSE)
)

; Roof ========================================================

(script static void md_roof_enter
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)
	
		(md_print "EMILE: About time!  You clear the ground -- I’ll take care of the Banshees!")
		(f_md_ai_play 0 (object_get_ai o_emile) m20_1970)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_roof_delay_0

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)

		(print "EMILE: Keep shooting, Noble Six!  Watch down low!")
		(f_md_ai_play 0 (object_get_ai o_emile) m20_1980)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_roof_delay_1

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)

		(md_print "EMILE: Kill those hostiles! Banshees are almost gone!")
		(f_md_ai_play 0 (object_get_ai o_emile) m20_2100)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_roof_clear_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)
	
		(md_print "EMILE: That's the way we get it done, Spartan!")
		(f_md_ai_play 0 (object_get_ai o_emile) m20_2030)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)


(script static void md_roof_clear_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "CONTROL: Noble team: Longswords are inbound, and ready to push. Orbital Defense is standing-by to take the shot.")
		(f_md_object_play 0 NONE m20_2020)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)


;*

(script static void md_roof_delay_1

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(print "EMILE: Don't let up, Lieutenant! Suppress those ground units!")
		(f_md_ai_play 0 gr_emile m20_1990)

	(set g_dialog FALSE)
)

(script static void md_roof_delay_2

	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(print "EMILE: Drop those ground units! Let 'em have it!")
		(f_md_ai_play 0 gr_emile m20_2000)

	(set g_dialog FALSE)
)

*;

; Spare ========================================================

(script static void md_xxx_muse
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Permission to speak freely, boss?")
		(f_md_ai_play 0 gr_kat m20_1480)
		(md_print "CARTER: Granted.")
		(f_md_object_play 0 NONE m20_1490)
		(md_print "KAT: Why are the Covenant hitting such a remote location?  Most of our forces are protecting population centers down south.")
		(f_md_ai_play 0 gr_kat m20_1500)
		(md_print "CARTER: Good question.  Dot?")
		(f_md_object_play 0 NONE m20_1510)
		(md_print "AUNTIE DOT: Insufficient information, Commander.  But it is a good question.")
		(f_md_object_play 0 NONE m20_1520)

	(set g_dialog FALSE)
)

(script static void md_xxx_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KAT: Hurry, Six!")
		(f_md_ai_play 0 gr_kat m20_1940)

	(set g_dialog FALSE)
)

(script static void md_xxx_delay_3
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "JORGE: Hurry, Six!")
		(f_md_ai_play 0 gr_jorge m20_1950)

	(set g_dialog FALSE)
)


(script static void md_xxx_delay_4
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Hurry, Six!")
		(f_md_object_play 0 NONE m20_1960)

	(set g_dialog FALSE)
)


; ===================================================================================================================================================
; ===================================================================================================================================================
; MUSIC 
; ===================================================================================================================================================
; ===================================================================================================================================================

(global short s_music_court -1)
(script dormant music_court

	(sleep_until (>= s_music_court 1 ))
	(dprint "music contacts")
	(sound_looping_set_alternate levels\solo\m20\music\m20_music01 TRUE)

	(sleep_until (>= s_music_court 2 ))
	(dprint "music kill boss")
	(sound_looping_stop levels\solo\m20\music\m20_music01)

	(sleep_until (>= s_music_court 3 ))
	(dprint "music court clear")
	(sound_looping_start levels\solo\m20\music\m20_music02 NONE 1)	

	(sleep_until (>= s_music_court 4 ))
	(dprint "music valley clear")
	(sound_looping_stop levels\solo\m20\music\m20_music02)

)

(global short s_music_valley -1)
(script dormant music_valley

	(sleep_until (>= s_music_valley 3 ))
	(dprint "music valley start")
	(sound_looping_start levels\solo\m20\music\m20_music02 NONE 1)	

	(sleep_until (>= s_music_valley 4 ))
	(dprint "music valley clear")
	(sound_looping_stop levels\solo\m20\music\m20_music02)
	
)

(global short s_music_far -1)
(script dormant music_far

	(sleep_until (>= s_music_far 1 ))
	(dprint "music far start")
	(sound_looping_start levels\solo\m20\music\m20_music03 NONE 1)	

	(sleep_until (>= s_music_far 2 ))
	(dprint "music far end")
	(sound_looping_stop levels\solo\m20\music\m20_music03)
	
)

(global short s_music_air -1)
(script dormant music_air

	(sleep_until (>= s_music_air 1 ))
	(dprint "music air start")
	(sound_looping_start levels\solo\m20\music\m20_music04 NONE 1)	

	(sleep_until (>= s_music_air 2 ))
	(dprint "music air end")
	(sound_looping_stop levels\solo\m20\music\m20_music04)
	
)

(global short s_music_return -1)
(script dormant music_return

	(sleep_until (>= s_music_return 1 ))
	(dprint "music return start")
	(sound_looping_start levels\solo\m20\music\m20_music10 NONE 1)	

	(sleep_until (>= s_music_return 2 ))
	(dprint "music return end")
	(sound_looping_stop levels\solo\m20\music\m20_music10)
	
)

(global short s_music_garage -1)
(script dormant music_garage

	(sleep_until (>= s_music_garage 1 ))
	(dprint "music garage start")
	(sound_looping_start levels\solo\m20\music\m20_music05 NONE 1)	

	(sleep_until (>= s_music_garage 2 ))
	(dprint "music hunters")
	(sound_looping_start levels\solo\m20\music\m20_music06 NONE 1)	
	
	(sleep_until (>= s_music_garage 3 ))
	(dprint "music 1st hunter dead")
	(sound_looping_set_alternate levels\solo\m20\music\m20_music06 TRUE)

	(sleep_until (>= s_music_garage 4 ))
	(dprint "music 2nd hunter dead")
	(sound_looping_stop levels\solo\m20\music\m20_music06)

	(sleep_until (>= s_music_garage 5 ))
	(dprint "music elevator")
	(sound_looping_stop levels\solo\m20\music\m20_music05)

)

(global short s_music_sword -1)
(script dormant music_sword

	(sleep_until (>= s_music_sword 1 ))
	(dprint "music jorge")
	(sound_looping_start levels\solo\m20\music\m20_music07 NONE 1)	

	(sleep_until (>= s_music_sword 2 ))
	(dprint "music carter")
	(sound_looping_activate_layer levels\solo\m20\music\m20_music07 1)	

	(sleep_until (>= s_music_sword 3 ))
	(dprint "music hall")
	(sound_looping_start levels\solo\m20\music\m20_music08 NONE 1)	

	(sleep_until (>= s_music_sword 4 ))
	(dprint "music hall end")
	(sound_looping_stop levels\solo\m20\music\m20_music07)

	(sleep_until (>= s_music_sword 5 ))
	(dprint "music roof")
	(sound_looping_stop levels\solo\m20\music\m20_music08)
	(sound_looping_start levels\solo\m20\music\m20_music09 NONE 1)

)


; =================================================================================================
; AMBIENT HELPER SCRIPTS
; =================================================================================================
; Set this boolean to TRUE before you start playing VO, and FALSE when you're done
; EX:
; (set g_pulse_spartan_transmission 1)
; (md_play 0 \sound\dialogue\temp\mysound1)
; (md_play 0 \sound\dialogue\temp\mysound2)
; (md_play 0 \sound\dialogue\temp\mysound3)
; (set g_pulse_spartan_transmission 0)

;*

(global boolean g_pulse_spartan_transmission 0)	
(script continuous spartan_transmission_pulse
	(if (= g_pulse_spartan_transmission 1) (cinematic_set_title ct_spartan_transmission))
	(sleep 30)
)

(global boolean g_pulse_trooper_transmission 0)	
(script continuous trooper_transmission_pulse
	(if (= g_pulse_trooper_transmission 1) (cinematic_set_title ct_trooper_transmission))
	(sleep 30)
)

(global boolean g_pulse_aa_powerup 0)	
(script continuous aa_powerup_pulse
	(if (= g_pulse_aa_powerup 1) (cinematic_set_title ct_aa_powerup))
	(sleep 30)
)

*;
