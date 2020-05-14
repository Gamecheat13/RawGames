; =================================================================================================
; MUSIC
; =================================================================================================

(global short s_music_dirt -1)
(script dormant music_dirt

	(sleep_until (>= s_music_dirt 1 ))
	(dprint "music deliver")
	(sound_looping_start levels\solo\m70\music\m70_music_01 NONE 1)

	(sleep_until (>= s_music_dirt 2 ))
	(dprint "music transport")
	(sound_looping_stop levels\solo\m70\music\m70_music_01)
	(sound_looping_start levels\solo\m70\music\m70_music_02 NONE 1)

)

(global short s_music_drop -1)
(script dormant music_drop

	(sleep_until (>= s_music_drop 1 ))
	(dprint "music gun it")
	(sound_looping_set_alternate levels\solo\m70\music\m70_music_02 TRUE)	

	(sleep_until (>= s_music_drop 2 ))
	(dprint "music tunnel")
	(sound_looping_start levels\solo\m70\music\m70_music_03 NONE 1)

	(sleep_until (>= s_music_drop 3 ))
	(dprint "music jump")
	(sound_looping_stop levels\solo\m70\music\m70_music_02)

	(sleep_until (>= s_music_drop 4 ))
	(dprint "music jump end")
	(sound_looping_start levels\solo\m70\music\m70_music_04 NONE 1)

	(sleep_until (>= s_music_drop 5 ))
	(dprint "music caves")
	(sound_looping_stop levels\solo\m70\music\m70_music_03)

)

(global short s_music_block -1)
(script dormant music_block

	(sleep_until (>= s_music_block 1 ))
	(dprint "music block end")
	(sound_looping_start levels\solo\m70\music\m70_music_05 NONE 1)

	(sleep_until (>= s_music_block 2 ))
	(dprint "music situation")
	(sound_looping_stop levels\solo\m70\music\m70_music_05)

)

(global short s_music_tunnels -1)
(script dormant music_tunnels

	(sleep_until (>= s_music_tunnels 1 ))
	(dprint "music tunnels buggers")
	(sound_looping_start levels\solo\m70\music\m70_music_06 NONE 1)

	(sleep_until (>= s_music_tunnels 2 ))
	(dprint "music keyes")
	(sound_looping_stop levels\solo\m70\music\m70_music_06)

)

(global short s_music_wall -1)
(script dormant music_wall

	(sleep_until (>= s_music_wall 1 ))
	(dprint "music countdown")
	(sound_looping_start levels\solo\m70\music\m70_music_07 NONE 1)
	
	(sleep_until (>= s_music_wall 2 ))
	(dprint "music long fight")
	(sound_looping_start levels\solo\m70\music\m70_music_08 NONE 1)

)

(global short s_music_factory -1)
(script dormant music_factory

	(sleep_until (>= s_music_factory 1 ))
	(dprint "music bomb 1")
	(sound_looping_stop levels\solo\m70\music\m70_music_08)
	(sound_looping_start levels\solo\m70\music\m70_music_09 NONE 1)
	
)

(global short s_music_crane -1)
(script dormant music_crane

	(sleep_until (>= s_music_crane 1 ))
	(dprint "music hunters")
	(sound_looping_stop levels\solo\m70\music\m70_music_09)
	(sound_looping_start levels\solo\m70\music\m70_music_10 NONE 1)

	(sleep_until (>= s_music_crane 2 ))
	(dprint "music hunters dead")
	(sound_looping_stop levels\solo\m70\music\m70_music_10)

)

(global short s_music_catwalk -1)
(script dormant music_catwalk

	(sleep_until (>= s_music_catwalk 1 ))
	(dprint "music catwalks")
	(sound_looping_start levels\solo\m70\music\m70_music_11 NONE 1)

)

(global short s_music_platform -1)
(script dormant music_platform

	(sleep_until (>= s_music_platform 1 ))
	(dprint "music room")
	(sound_looping_stop levels\solo\m70\music\m70_music_11)

	(sleep_until (>= s_music_platform 2 ))
	(dprint "music pad")
	(sound_looping_start levels\solo\m70\music\m70_music_12 NONE 1)

	(sleep_until (>= s_music_platform 3 ))
	(dprint "music hold them")
	(sound_looping_start levels\solo\m70\music\m70_music_13 NONE 1)

	(sleep_until (>= s_music_platform 4 ))
	(dprint "music hammer or wave 2")
	(sound_looping_stop levels\solo\m70\music\m70_music_13)

	(sleep_until (>= s_music_platform 5 ))
	(dprint "music plasma dead")
	(sound_looping_start levels\solo\m70\music\m70_music_14 NONE 1)

)

(global short s_music_zealot -1)
(script dormant music_zealot

	(sleep_until (>= s_music_zealot 1 ))
	(dprint "music clear path")
	(sound_looping_start levels\solo\m70\music\m70_music_15 NONE 1)

	(sleep_until (>= s_music_zealot 2 ))
	(dprint "music final elite")
	(sound_looping_start levels\solo\m70\music\m70_music_16 NONE 1)

)

(global short s_music_cannon -1)
(script dormant music_cannon

	(sleep_until (>= s_music_cannon 1 ))
	(dprint "music enter gun")
	(sound_looping_stop levels\solo\m70\music\m70_music_15)

	(sleep_until (>= s_music_cannon 2 ))
	(dprint "music checkpoint")
	(sound_looping_stop levels\solo\m70\music\m70_music_16)
	(sound_looping_start levels\solo\m70\music\m70_music_17 NONE 1)

	(sleep_until (>= s_music_cannon 3 ))
	(dprint "music reticle")
	(sound_looping_stop levels\solo\m70\music\m70_music_17)

)

(global short s_music_alpha -1)
(script dormant music_alpha

	(sleep_until (>= s_music_alpha 1 ))
	(dprint "music alpha start")
	(sound_looping_start levels\solo\m70\music\m70_music_06 NONE 1)

	(sleep_until (>= s_music_alpha 2 ))
	(dprint "music alpha end")
	(sound_looping_stop levels\solo\m70\music\m70_music_06)

)

(global short s_music_bravo -1)
(script dormant music_bravo

	(sleep_until (>= s_music_bravo 1 ))
	(dprint "music bravo start")
	(sound_looping_start levels\solo\m70\music\m70_music_11 NONE 1)

	(sleep_until (>= s_music_bravo 2 ))
	(dprint "music bravo end")
	(sound_looping_stop levels\solo\m70\music\m70_music_11)

)

; =================================================================================================
; RAIN
; =================================================================================================

(global short s_rain_force -1)
(global short s_rain_force_last -1)

(script dormant f_rain

	(branch
		(= s_rain_force 0)
		(f_rain_kill)
	)

	(sleep_until
		(begin

			(if (not (= s_rain_force s_rain_force_last))
				(begin
				
					(dprint "changing rain")
					(set s_rain_force_last s_rain_force)

					(cond
						((= s_rain_force 1)
							(begin
								(dprint "off")
								(weather_animate_force off 1 (random_range 5 15))		
							)
						)
						((= s_rain_force 2)
							(begin
								(dprint "no rain")
								(weather_animate_force no_rain 1 (random_range 5 15))		
							)
						)
						((= s_rain_force 3)
							(begin
								(dprint "light change 1/2")
								(weather_animate_force no_rain 1 (random_range 5 15))	
								(set s_rain_force 4)
								(sleep (random_range (* 30 20)(* 30 60)))
							)
						)
						((= s_rain_force 4)
							(begin
								(dprint "light change 2/2")
								(weather_animate_force light_rain 1 (random_range 5 15))		
								(set s_rain_force 3)
								(sleep (random_range (* 30 20)(* 30 60)))
							)
						)
						((= s_rain_force 5)
							(begin
								(dprint "medium")
								(weather_animate_force light_rain 1 (random_range 5 15))		
							)
						)
						((= s_rain_force 6)
							(begin
								(dprint "medium change 1/2")
								(weather_animate_force light_rain 1 (random_range 5 15))	
								(set s_rain_force 7)
								(sleep (random_range (* 30 20)(* 30 60)))
							)
						)
						((= s_rain_force 7)
							(begin
								(dprint "medium change 2/2")
								(weather_animate_force heavy_rain 1 (random_range 5 15))		
								(set s_rain_force 6)
								(sleep (random_range (* 30 20)(* 30 60)))
							)
						)
						((= s_rain_force 8)
							(begin
								(dprint "heavy")
								(weather_animate_force heavy_rain 1 (random_range 5 15))		
							)
						)
						((= s_rain_force 9)
							(begin
								(dprint "cine rain")
								(weather_animate_force cine_rain 1 0)		
							)
						)
					)

				)
			)

		FALSE)
	5)

)

(script static void f_rain_kill

	(weather_animate_force off 1 (random_range 5 15))	

)

; =================================================================================================
; MUSIC
; =================================================================================================

(script static void f_music_intro

	(dprint "music intro")
	
)

(script static void f_music_dirt

	(dprint "music dirt")

)

(script static void f_music_drop

	(dprint "music scarabdrop")

)

(script static void f_music_cave

	(dprint "music cave")

)


(script static void f_music_block

	(dprint "music blockade")

)

(script static void f_music_bone

	(dprint "music boneyard")

)

(script static void f_music_smelt

	(dprint "music smelter")

)


(script static void f_music_platform

	(dprint "music platform")

)

(script static void f_music_zealot

	(dprint "music zealot")

)

(script static void f_music_cannon

	(dprint "music cannon")

)

; =================================================================================================
; MISSION OBJECTIVES
; =================================================================================================

(script static void mo_dirtroad

	(f_hud_obj_new prompt_dirtroad pause_dirtroad)

)


(script static void mo_blockade

	(f_hud_obj_new prompt_blockade pause_blockade)

)

(script static void mo_wall

	(f_hud_obj_new prompt_wall pause_wall)

)

(script static void mo_platform

	(f_hud_obj_new prompt_platform pause_platform)

)


(script static void mo_zealot

	(f_hud_obj_new prompt_zealot pause_zealot)

)


(script static void mo_cannon

	(f_hud_obj_new prompt_cannon pause_cannon)

)

; =================================================================================================
; CHAPTER TITLES
; =================================================================================================

(script static void tit_dirt

	(f_hud_chapter ct_dirtroad)

)


(script static void tit_block

	(f_hud_chapter ct_blockade)

)


(script static void tit_wall

	(f_hud_chapter ct_wall)

)


(script static void tit_platform

	(f_hud_chapter ct_platform)

)

; =================================================================================================
; MISSION DIALOGUE
; =================================================================================================

(script static void f_abort_md

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; Dirt Road  ========================================================

(global boolean g_dialog FALSE)
(script static void md_dirt_drop
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)


		(md_print "EMILE: Still with us, Commander?")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0010)
		(md_print "CARTER: Stay low -- let me draw the heat.  Just deliver that package.")
		(f_md_object_play 0 NONE m70_0020)
		(set s_music_dirt 1)


	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_dirt_look
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "EMILE: Six. There's our destination: Pillar of Autumn.")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0030)
		(md_print "EMILE: Race you to her.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0040)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_dirt_look_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "EMILE: Hold up... Contacts. They must have seen us drop.")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0050)
		(md_print "EMILE: Let's take 'em out -- we need those wheels.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0060)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_dirt_look_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Let's go, Lieutenant!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0070)

	(set g_dialog FALSE)
)


(script static void md_dirt_bridge_delay
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Let's head east across the bridge!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0080)

	(set g_dialog FALSE)
)

; Mongoose  ========================================================

(script static void md_goose_wheels
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: We got transport.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0090)
		(set s_music_dirt 2)

	(set g_dialog FALSE)
)

(script static void md_goose_wheels_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Jump on that mongoose. Let's spit some dirt.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0100)

	(set g_dialog FALSE)
)

(script static void md_goose_wheels_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: What are you waiting for, Six?")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0110)

	(set g_dialog FALSE)
)

(script static void md_goose_pass
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: You think we got time to walk, Lieutenant?")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0120)

	(set g_dialog FALSE)
)

(global short s_md_goose_findnew 0)
(script static void md_goose_findnew

	(if (= s_md_goose_findnew 0) (md_goose_findnew_0))
	(if (= s_md_goose_findnew 1) (md_goose_findnew_1))

	(set s_md_goose_findnew (+ s_md_goose_findnew 1))
	(if (= s_md_goose_findnew 2) (set s_md_goose_findnew 0))

)

(script static void md_goose_findnew_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Six.  Take that Mongoose.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0130)

	(set g_dialog FALSE)
)

(script static void md_goose_findnew_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Commandeer that Mongoose, Lieutenant.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0150)

	(set g_dialog FALSE)
)

; Scarab drop  ========================================================

(script static void md_drop_intro
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)

		(md_print "EMILE: Scarabs -- do not engage!  Gun it, Six!")
		(f_md_ai_play (random_range 20 30) (object_get_ai o_emile) m70_0170)
		(set s_music_drop 1)
		(md_print "EMILE: Noble. Out of the drop zone! Now!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0180)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_drop_carter
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "CARTER: Get the package out of there!  Remember your objective!")
		(f_md_object_play 0 NONE m70_0200)

	(set g_dialog FALSE)
)

(script static void md_drop_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Don't stop, Six!  Push through these guys!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0190)

	(set g_dialog FALSE)
)

(script static void md_drop_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Move it, Lieutenant!  We gotta get to the Autumn!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0210)

	(set g_dialog FALSE)
)

; Blockade  ========================================================

(script static void md_block_bridge
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "EMILE: Bridge ahead is out, Six -- gonna have to jump it!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0220)
		(set s_music_drop 3)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_block_dismount
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)

		(md_print "EMILE: Looks like we can climb around to the south...")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0230)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_block_warn
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		;(md_print "EMILE: Guess we're back on foot.  Gotta deliver that package...")
		;(f_md_ai_play 0 sq_emile m70_0240)
		(md_print "CARTER: Noble... Enemy forces blocking the road ahead...")
		(f_md_object_play 0 NONE m70_0250)

	(set g_dialog FALSE)
)

; not used
(script static void md_block_combat
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Contacts!")
		(f_md_ai_play (* 30 10) (object_get_ai o_emile) m70_0280)
		(md_print "EMILE: You wanna go?  Try me!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0290)

	(set g_dialog FALSE)
)

(script static void md_block_wraith
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Got a Wraith!  Southeast side!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0300)

	(set g_dialog FALSE)
)


(script static void md_block_snipers
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Snipers!  High up, to the south!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0310)

	(set g_dialog FALSE)
)

(script static void md_block_gulch_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)

		(md_print "CARTER: I show a cave system... near your location...")
		(f_md_object_play (random_range 30 60) NONE m70_0260)
		(md_print "EMILE: Should be good cover. We'll find it, Commander.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0270)
		;(md_print "EMILE: Look for that cave system!")
		;(f_md_ai_play 0 sq_emile m70_0320)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_block_gulch_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Cave must be around here someplace...")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0330)

	(set g_dialog FALSE)
)

(script static void md_block_gulch_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Figure that cave's gotta be to the east or north...")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0340)

	(set g_dialog FALSE)
)

(script static void md_block_cave
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "EMILE: Get to that cave!  I'm right behind you!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0350)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_block_cave_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Caves, Spartan. We gotta go!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0410)

	(set g_dialog FALSE)
)

; Carter  ========================================================

(script static void md_carter_battle_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)

		(set s_music_block 2)
		(md_print "CARTER: Noble. You've got a... situation.")
		(f_md_object_play 0 NONE m70_0420)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)


(script static void md_carter_react
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Crevice to the east.  Let's go.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0500)

	(set g_dialog FALSE)
)


; Tunnels  ========================================================

(script static void md_tunnels_bugger_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Buggers.  Go quiet...")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0510)
		(set s_music_tunnels 1)

	(set g_dialog FALSE)
)

(script static void md_tunnels_bugger_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: More of 'em, Six!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0520)

	(set g_dialog FALSE)
)

(script static void md_tunnels_bugger_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Gotta get out of these caves -- take the package to the Autumn!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0530)

	(set g_dialog FALSE)
)

(script static void md_tunnels_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Keep moving, Six.  Gotta get that package to Keyes.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0540)

	(set g_dialog FALSE)
)

(script static void md_tunnels_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Had enough of these caves...")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0550)

	(set g_dialog FALSE)
)

(script static void md_tunnels_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Let's get the hell outta here.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0560)

	(set g_dialog FALSE)
)

(script static void md_tunnels_delay_3
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "EMILE: Better not be moving in circles...")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0570)

	(set g_dialog FALSE)
)

; Wall  ========================================================

(script static void md_wall_intro
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)	

		(set s_music_tunnels 2)
		(set s_music_alpha 2)
		(sleep 60)
		(md_print "KEYES: This is Captain Keyes of the Pillar of Autumn.  We are tracking you, Noble. ")
		(f_md_object_play (random_range 30 60) NONE m70_0580)
		(md_print "EMILE: We'll be there, sir.")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0590)
		(md_print "KEYES: Better be, Spartan, because my countdown has no abort.")
		(f_md_object_play 0 NONE m70_0600)
		(set s_music_wall 1)


	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(global ai ai_trooper_wall_1 NONE)
(script static void md_wall_marine_0_near
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(if (= s_wall_md_marine_idx 0) (vs_cast sq_wall_marine_2/trooper_0 FALSE 10 "m70_0610"))
		(if (= s_wall_md_marine_idx 1) (vs_cast sq_wall_marine_4/trooper_1 FALSE 10 "m70_0610"))
		(set ai_trooper_wall_1 (vs_role 1))
	
		(md_print "TROOPER: Spartans!  Over here!")
		(f_md_object_play 0 NONE m70_0610)

	(set g_dialog FALSE)
)

(script static void md_wall_marine_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)

		(md_print "TROOPER: Not looking good, sir.  Coveys have taken the whole shipyard.")
		(f_md_ai_play (random_range 30 60) ai_trooper_wall_1 m70_0620)
		(md_print "EMILE: Understood.  We gotta get to the dry-dock.  Priority One.")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0640)
		(md_print "TROOPER: Keep heading east.  Good luck.")
		(f_md_ai_play (random_range 30 60) ai_trooper_wall_1 m70_0650)
		(md_print "TROOPER: Marines!  Push 'em back!")
		(f_md_ai_play 0 ai_trooper_wall_1 m70_0660)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

; Factory  ========================================================

(global ai ai_factory_marine_1 NONE)
(script static void md_factory_marine_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)
	
		(vs_cast sq_factory_marine_1 FALSE 10 "m70_0670")
		(set ai_factory_marine_1 (vs_role 1))

		(md_print "TROOPER: Sierra -- you made it!")
		(f_md_ai_play (random_range 30 60) ai_factory_marine_1 m70_0670)
		(md_print "EMILE: So far.  Tac eval?")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0680)
		(md_print "TROOPER: They got this facility covered from all angles.  We'll give you covering fire; take the flank -- there has to be a way around.")
		(f_md_ai_play (random_range 30 60) ai_factory_marine_1 m70_0690)
		(md_print "EMILE: We'll find it.  You just keep 'em busy.")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0700)
		(md_print "TROOPER: You got it, sir.")
		(f_md_ai_play 0 ai_factory_marine_1 m70_0710)


	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_factory_ship_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Come on, Six.  We gotta move through that facility ahead.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0730)

	(set g_dialog FALSE)
)


(script static void md_factory_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Clock's ticking, Lieutenant.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0740)

	(set g_dialog FALSE)
)

(script static void md_factory_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: We don't have much time, Noble Six.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0750)

	(set g_dialog FALSE)
)

(script static void md_factory_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Gotta keep moving.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0760)

	(set g_dialog FALSE)
)

(script static void md_factory_delay_3
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Autumn can't wait forever.")
		(f_md_ai_play (random_range 20 30) (object_get_ai o_emile) m70_0770)
		(md_print "EMILE: Let's go, Six!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0780)

	(set g_dialog FALSE)
)

; Crane  ========================================================

(global ai ai_trooper_crane_1 NONE)
(script static void md_crane_intro
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(vs_cast sq_crane_marine_control FALSE 10 "m70_0790")
		(set ai_trooper_crane_1 (vs_role 1))
	
		(md_print "TROOPER: Spartans! Dry dock's through that structure 'cross the way!")
		(f_md_ai_play (random_range 20 30) ai_trooper_crane_1 m70_0790)
		(md_print "TROOPER: Punch through! We'll back you up!")
		(f_md_ai_play 0 ai_trooper_crane_1 m70_0800)

	(set g_dialog FALSE)
)

(script static void md_crane_combat
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Tangos!  Both platforms!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0810)

	(set g_dialog FALSE)
)

(script static void md_crane_phantom
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Watch that Phantom!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0820)

	(set g_dialog FALSE)
)

(script static void md_crane_room_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Head outside!  I'm right behind you!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0830)

	(set g_dialog FALSE)
)

(script static void md_crane_hunters
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Hunters!  East platform!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0840)

	(set g_dialog FALSE)
)

(script static void md_crane_outside_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Door to the east!  Keep moving!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0850)

	(set g_dialog FALSE)
)

; Catwalks  ========================================================

(script static void md_catwalk_floor_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)
	
		(md_print "EMILE: High ground!  Head up to the catwalks!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0860)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_catwalk_floor_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Better angles from the catwalks, Six!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0870)

	(set g_dialog FALSE)
)

(script static void md_catwalk_floor_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Lieutenant!  We need to get up to those catwalks!")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0880)

	(set g_dialog FALSE)
)

(script static void md_catwalk_top_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)
	
		(md_print "EMILE: Let's find a way out, Six. East door on the platform looks good.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0910)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_catwalk_exit
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)
	
		(md_print "KEYES: Keyes to Noble team.  We're running out of time here, Spartans.")
		(f_md_object_play (random_range 30 60) NONE m70_0920)
		(md_print "EMILE: Solid copy, Sir.  We're close.")
		(f_md_ai_play (random_range 20 30) (object_get_ai o_emile) m70_0930)
		(md_print "EMILE: Last push, Lieutenant.")
		(f_md_ai_play 0 (object_get_ai o_emile) m70_0940)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

; Platform  ========================================================

(global ai ai_trooper_platform_1 NONE)
(script static void md_platform_intro
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)

		(vs_cast sq_platform_marine_w0_2/marine_1 FALSE 10 "m70_0960")
		(set ai_trooper_platform_1 (vs_role 1))

		(md_print "EMILE: What's the situation?")
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0950)
		(md_print "TROOPER: We rigged a mass-driver up top.  We lose it, and the Autumn has no covering fire! She'll never make orbit!")
		(f_md_ai_play (random_range 30 60) ai_trooper_platform_1 m70_0960)
		(md_print "EMILE: Noble to Keyes: we're at the pad.")
		(set s_music_platform 2)
		(f_md_ai_play (random_range 30 60) (object_get_ai o_emile) m70_0970)
		(md_print "KEYES: Copy, Noble.  My Pelican's ready; clear an LZ and I'll meet you there.")
		(f_md_object_play (random_range 30 60) NONE m70_0980)
		(md_print "EMILE: Will do, Captain.  All right, Six... This is it.")
		(f_md_ai_play (random_range 20 30) (object_get_ai o_emile) m70_0990)
		(md_print "EMILE: I'll man the big gun!  You just get to the platform and deliver that package!")
		(f_md_ai_play 10 (object_get_ai o_emile) m70_1000)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_platform_emilegun
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: I'm in position!  I'll take out as many dropships as I can!")
		(f_md_object_play 0 NONE m70_1010)

	(set g_dialog FALSE)
)


(script static void md_platform_wave_0_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Do it, Six!  Kill those bastards!")
		(f_md_object_play 0 NONE m70_1030)

	(set g_dialog FALSE)
)


(script static void md_platform_wave_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Hold 'em off until Keyes gets here!")
		(f_md_object_play 0 NONE m70_1020)
		(set s_music_platform 3)

	(set g_dialog FALSE)
)

(script static void md_platform_wave_1_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: Take 'em out, Lieutenant! Clear the zone!")
		(f_md_object_play 0 NONE m70_1040)

	(set g_dialog FALSE)
)

(script static void md_platform_wave_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "EMILE: We got more on the way!")
		(f_md_object_play 0 NONE m70_1050)

	(set g_dialog FALSE)
)

(script static void md_platform_wave_2_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "TROOPER: Spartan! We're gonna lose this position!")
		(f_md_object_play 0 NONE m70_1090)

	(set g_dialog FALSE)
)


(script static void md_platform_wave_2_delay_0_marine
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "TROOPER: They're everywhere, Spartan!  Assist!")
		(f_md_object_play 0 NONE m70_1070)

	(set g_dialog FALSE)
)

(script static void md_platform_done
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) FALSE)

		(md_print "EMILE: Noble to Keyes: The pad is clear!")
		(f_md_object_play (random_range 30 60) NONE m70_1170)
		(md_print "KEYES: On my way.")
		(f_md_object_play (random_range 30 60) NONE m70_1180)
		(md_print "EMILE: Six. Time for you to leave. Get the package to the pad... and get your ass off this planet. I got your back.")
		(f_md_object_play 0 NONE m70_1190)

	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	(set g_dialog FALSE)
)

(script static void md_platform_keyesenter
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "KEYES: This is Keyes.  On hot approach to platform Delta.")
		(f_md_object_play 0 NONE m70_1200)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_platform_keyesland
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "KEYES: Ready to take possession of the package, Noble.")
		(f_md_object_play 0 NONE m70_1210)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

; Zealot  ========================================================

(script static void md_zealot_gotogun
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)	

		(md_print "KEYES: Noble Six, get on that mass driver and clear me a path!")
		(f_md_object_play 0 NONE m70_1220)
		(set s_music_zealot 1)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_zealot_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(md_print "KEYES: Spartan, do you copy?  Heat up that gun!  We've got multiple craft bearing down on us!")
		(f_md_object_play 0 NONE m70_1230)

	(set g_dialog FALSE)
)

(script static void md_zealot_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KEYES: We need you on that gun, Noble!  Or the Autum's sitting in her grave!")
		(f_md_object_play 0 NONE m70_1240)

	(set g_dialog FALSE)
)

(script static void md_zealot_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	
		(md_print "KEYES: You're going to have to take down that cruiser, Spartan!")
		(f_md_object_play 0 NONE m70_1250)

	(set g_dialog FALSE)
)

; Cannon  ========================================================

(script static void md_cannon_enter
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "KEYES: Cruiser moving into position... I need it dead!")
		(f_md_object_play 0 NONE m70_1270)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_cannon_move_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)	

		(md_print "KEYES: Mass driver won't crack those shields... Steady, Spartan...")
		(f_md_object_play 0 NONE m70_1280)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_cannon_fire_delay_0
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "KEYES: Fire now, Lieutenant!  Hit her in the gut!")
		(f_md_object_play 0 NONE m70_1310)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)


(script static void md_cannon_fire_delay_1
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "KEYES: You've got to fire NOW, Spartan!  We won't survive another hit!")
		(f_md_object_play 0 NONE m70_1320)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)


(script static void md_cannon_fire_delay_2
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)
	
		(md_print "KEYES: Aim for the glassing port!")
		(f_md_object_play 0 NONE m70_1300)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

(script static void md_cannon_die
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)
	(ai_dialogue_enable FALSE)	

		(md_print "KEYES: No! She's glassing! Do you copy, Noble?  DO YOU COPY...?")
		(f_md_object_play 0 NONE m70_1330)

	(ai_dialogue_enable TRUE)
	(set g_dialog FALSE)
)

; =================================================================================================
; MISSION DIALOGUE: MAIN SCRIPTS
; =================================================================================================
(script static void (md_play_debug (short delay) (string line))
	(if dialogue (print line))
	(sleep delay))

(script static void (md_play (short delay) (sound line))
	(sound_impulse_start line NONE 1)
	(sleep (sound_impulse_language_time line))
	(sleep delay))
