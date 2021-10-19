
(script stub void intro 

	(print "tyson eyes!!!")
)


(global boolean G_lz_middle false)

(global boolean 1turret_jack_elites false)

(global boolean G_turret_left_elites02 false)
(global boolean G_turret_left_middle_trigger false)

(global boolean G_turret_right false)
(global boolean G_turret_right02 false)

(global boolean G_turret_left_right_move false)

(global boolean G_1turret_interior false)
(global boolean G_1turret_interior_back false)

(global boolean G_runandgun02_g false)
(global boolean G_runandgun02_g_reinforcements false)

(global boolean G_runandgun02_interior_l false)

(global boolean G_pre_s_trap_back false)

(global boolean G_2turret_interior_front false)

(global boolean G_trap01_dialog false)

(global boolean G_1turret_turret_dialog false)

(global boolean G_a_1turret_v_attack_b false)

(global boolean G_1turret_hbanshee false)

(global boolean G_runandgun02_dialog false)

(global boolean G_boss_fight_reinforce false)

(global boolean G_prize false)



(script dormant music_1

	;(sound_looping_start "sound\temp\music\level_music\alpha_moon\am_1" none 1)
	
	(sleep 9000)
	
	;(sound_looping_stop "sound\temp\music\level_music\alpha_moon\am_1")

)

(script dormant music_2

	;(sound_looping_start "sound\temp\music\level_music\alpha_moon\am_2" none 1)
	
	(sleep 9000)
	
	;(sound_looping_stop "sound\temp\music\level_music\alpha_moon\am_2")

)


(script dormant music_3

	;(sound_looping_start "sound\temp\music\level_music\alpha_moon\am_3" none .7)
	
	(sleep 9000)
	
	;(sound_looping_stop "sound\temp\music\level_music\alpha_moon\am_3")

)

(script dormant music_4

	;(sound_looping_start "sound\temp\music\level_music\alpha_moon\am_4" none 1)
	
	(sleep 9000)
	
	;(sound_looping_stop "sound\temp\music\level_music\alpha_moon\am_4")

)

(script dormant music_5

	;(sound_looping_start "sound\temp\music\level_music\alpha_moon\am_5" none 1)
	
	(sleep 3000)
	
	;(sound_looping_stop "sound\temp\music\level_music\alpha_moon\am_5")

)

(script dormant music_6

	;(sound_looping_start "sound\temp\music\level_music\alpha_moon\am_6" none 1)
	
	(sleep 9000)
	
	;(sound_looping_stop "sound\temp\music\level_music\alpha_moon\am_6")

)

(script dormant music_7

	;(sound_looping_start "sound\temp\music\level_music\alpha_moon\am_7" none 1)
	
	(sleep 9000)
	
	;(sound_looping_stop "sound\temp\music\level_music\alpha_moon\am_7")

)



(script dormant ai_kill01
	
	(print "ai_kill01")
	
	(ai_erase intro_elites)
	(ai_erase intro_grunts)
	(ai_erase turret01_elites)
	(ai_erase turret_left_elites)
	(ai_erase trap01_grunts)
	(ai_erase turret_right_elites01)
	(ai_erase turret_right_elites02)
	(ai_erase turret_right_grunts02)
	(ai_erase turret_right_grunts01)


)
	;vvvvvvvvvvvv-- AI kill02 --vvvvvvvvvvvvv

(script dormant ai_kill02

	(print "ai_kill02")
	
	(ai_erase runandgun01_ghostelites)
	(ai_erase runandgun01_ghostelites02)
	(ai_erase runandgun01_i_elites01)
	(ai_erase runandgun01_i_grunts01)
	(ai_erase runandgun01_i_elites02)
	(ai_erase runandgun01_i_grunts02)
	(ai_erase runandgun01_t_grunts02)
	(ai_erase runandgun01_t_grunts03)
	(ai_erase runandgun01_ghostelites03)
	(ai_erase runandgun01_ghostelites04)
	
	(ai_erase view_i_01)
	(ai_erase view_tankelites01)
	(ai_erase view_ghostelites01)
	(ai_erase view_shadow01)
	(ai_erase view_shadow02)
	
	(ai_erase 1turret_tankelites01)
	(ai_erase 1turret_shadows01)
	(ai_erase 1turret_tankelites02)
	(ai_erase 1turret_ghostelites01)
	(ai_erase 1turret_ghostelites02)
	(ai_erase 1turret_turret_elites01)
	(ai_erase 1turret_end_grunts01)
	
	(ai_erase 1turret_jack_elites01)
	
	(ai_erase 1turret_turretgrunts01)
	(ai_erase 1turret_wraith_behind)
	
	(ai_erase 1turret_interior_low)
	(ai_erase 1turret_interior_back)
	
)

(script dormant ai_kill03

	(print "ai_kill03")
	
	(ai_erase runandgun02_t_grunts01)
	(ai_erase runandgun02_t_grunts02)
	(ai_erase runandgun02_ghostelites01)
	(ai_erase runandgun02_tankelites01)
	(ai_erase runandgun02_interior)

)

(script dormant ai_kill04

	(ai_erase 2turret_av_turrets)
	(ai_erase 2turret_interior_back)
	(ai_erase 2turret_interior_front)
	(ai_erase 2turret_ghostelites01)
	(ai_erase 2turret_tankelites01)

)

(script dormant ai_kill05

	(print "ai_kill05")

	(ai_erase supertrap_turretgrunts01)
	(ai_erase supertrap_tankelites01)
	(ai_erase supertrap_grunts01)
	(ai_erase supertrap_grunts02)
	(ai_erase supertrap_grunts03)
	(ai_erase supertrap_left_v)
	(ai_erase supertrap_right_v)
	
	(wake ai_kill04)
	(wake ai_kill03)
	(wake ai_kill02)
	(wake ai_kill01)
)



(script dormant prize

	(if (<= (random_range 1 1500) 1) 
		(begin
			(print "YOU WIN $1!!!!!")
	
			(sleep 60)
	
			(print "Show this screen to Stephen to collect your prize")
		
		)
		
		(begin
		
			(print "Sorry you did not WIN")
	
			(sleep 60)
	
			(print "try again")
		
		
		)
	)
)

(script dormant level_ending

	(sleep_until 
		(and
			(<= (ai_living_count controlroom_back_elites01) 0)
			(<= (ai_living_count controlroom_ent_elites01) 0)
			(<= (ai_living_count controlroom_elites01) 0)
		)
	)
	
	(fade_out 0 0 0 0)
	
	(cinematic_start)
	(camera_control on)
	
	(camera_set hlead_fight_ending_push_1 0)
	
	(sleep 30)
	
	(fade_in 1 1 1 15)
	
	(print "Level Finished")
	
	(camera_set hlead_fight_ending_push_2 180)
	
	(sleep 30)
	
	(sound_impulse_start "sound\dialog\alphamoon\cinematic\c05_5000_hld" none 1)

	(camera_set hlead_fight_ending_push_3 180)
	
	(sleep 30)
	
	(camera_set hlead_fight_ending_push_4 180)
	
	(sleep 60)
	
	(sound_impulse_start "sound\dialog\alphamoon\cinematic\c05_5010_der" none 1)
	
	(camera_set hlead_fight_ending_push_5 180)
	
	(sleep 90)
	
	(sound_impulse_start "sound\dialog\alphamoon\cinematic\c05_5020_hld" none 1)
	
	(camera_set hlead_fight_ending_push_6 180)
	
	(sleep 90)
	
	(sound_impulse_start "sound\dialog\alphamoon\cinematic\c05_5030_gsp" none 1)
	
	(camera_set hlead_fight_ending_push_7 180)
	
	(sleep 90)
	
	(fade_out 0 0 0 15)
	
	(sleep 90)
	
	(print "--- Mission Complete!!!! ---")
	
	(sleep 70)
	
	(print "--- GET MORE WHEN YOU PURCHASE HALO 2 ---")
	
	(sleep 70)
	
	(print "--- COMING WINTER 2004 ---")
	
	(sleep 70)
	
	(print "Stand by to see if your a winner!")
	
	(sleep 90)
	
	(wake prize);wake
)

(script dormant boss_fight_reinforce_cnt

	(sleep_until 
			(and
			   	(<= (ai_living_count controlroom_back_elites01) 0)
			   	(<= (ai_living_count controlroom_ent_elites01) 0)
			)
	)

	(if G_boss_fight_reinforce (sleep_forever))
	(set G_boss_fight_reinforce true)
	
	(ai_place controlroom_back_elites01)
	
	(ai_set_orders controlroom_back_elites01 controlroom_back_attack)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1150_hld" none 1)
	
	(print "KILL THEM ALL!!!")
	
	(wake level_ending);wake
)

(script dormant boss_fight_reinforce_ent

	(sleep_until 
			(and
			   	(<= (ai_living_count controlroom_elites01) 0)
			   	(<= (ai_living_count controlroom_ent_elites01) 0)
			)
	)

	(if G_boss_fight_reinforce (sleep_forever))
	(set G_boss_fight_reinforce true)
	
	(ai_place controlroom_elites01)
	
	(ai_set_orders controlroom_elites01 controlroom_center_attack)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1170_hld" none 1)
	
	(print "KILL THEM ALL!!!")
	
	(wake level_ending);wake
)

(script dormant boss_fight_reinforce_back

	(sleep_until 
			(and
			   	(<= (ai_living_count controlroom_elites01) 0)
			   	(<= (ai_living_count controlroom_back_elites01) 0)
			)
	)

	(if G_boss_fight_reinforce (sleep_forever))
	(set G_boss_fight_reinforce true)
	
	(ai_place controlroom_elites01)
	
	(ai_set_orders controlroom_elites01 controlroom_center_attack)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1180_hld" none 1)
	
	(print "KILL THEM ALL!!!")
	
	(wake level_ending);wake
)

(script dormant boss_fight

	(Print "---ROUND 1---")
	
	(sleep 75)
	
	(Print "---FIGHT---")
	
	(ai_place controlroom_elites01)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1130_hld" none 1)
	
	(ai_set_orders controlroom_elites01 controlroom_center_attack)
	
	(sleep 80)
	
	(ai_place controlroom_ent_elites01)
	
	(ai_set_orders controlroom_elites01 controlroom_ent_attack)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1140_hld" none 1)
	
	(sleep 80)

	(ai_place controlroom_back_elites01)

	(ai_set_orders controlroom_elites01 controlroom_back_attack)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1160_hld" none 1)
	
	(sleep 60)

	(ai_place controlroom_bu_grunts01)

	(ai_set_orders controlroom_bu_grunts01 controlroom_bu_attack)
	
	(ai_place controlroom_eu_grunts01)

	(ai_set_orders controlroom_eu_grunts01 controlroom_eu_attack)
	
	(wake boss_fight_reinforce_ent);wake
	(wake boss_fight_reinforce_back);wake
	(wake boss_fight_reinforce_cnt);wake

)

(script dormant hlead_fight_intro

	(fade_out 0 0 0 0)
	
	(cinematic_start)
	(camera_control on)
	
	(camera_set hlead_fight_intro_pan_1 0)
	
	(sleep 30)
	
	(fade_in 1 1 1 15)
	
	(print "HERETIC BOSS FIGHT INTRO")
	
	(camera_set hlead_fight_intro_pan_2 120)
	
	(sleep 20)
	
	(print "--- Heretic Leader: You know nothing of what goes on here!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1100_hld" none 1)

	(camera_set hlead_fight_intro_pan_2 90)
	
	(sleep 20)
	
	(camera_set hlead_fight_intro_pan_3 90)
	
	(sleep 60)
	
	(print "--- Heretic Leader: You’ve allowed your self to become a mindless pawn of the prophets")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1120_hld" none 1)
	
	(camera_set hlead_fight_intro_pan_4 120)
	
	(sleep 90)
	
	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	(cinematic_stop)
	(camera_control off)
	
	(fade_in 1 1 1 15)
	
	(wake boss_fight);wake
)	




(script dormant heretic_leader_intro

	(sleep_until (volume_test_objects controlroom_debris_spawn (players))15)

	(wake ai_kill05)
	
	(object_create_containing "wrckd_cntrlrm")

	(object_destroy_containing "excavation_end")
	(object_destroy_containing "excavation_mid_low_debris")
	
	(sleep_until (volume_test_objects heretic_leader_intro (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(print "HERETIC LEADER FIGHT INTRO")
	
	(wake hlead_fight_intro);wake
)


(script dormant teleport_to_cr

	(sleep_until (volume_test_objects teleport_to_cr (players))15)

	(object_teleport (player0) wrecked_controlroom)
	
	(print "---YOU HAVE BEEN TELEPORTED!!!---")
	
	(sleep 50)
	
	(print "---PREPARE TO DIE!---")
)

;V_V_V_V_V_V_V   EXCAVATION !_!_!_!_!_!_!  V_V_V_V_V_V_V_V
;V_V_V_V_V_V_V   EXCAVATION !_!_!_!_!_!_!  V_V_V_V_V_V_V_V

(script dormant excavation_end_covenant_victory

	(wake teleport_to_cr);wake

	(sleep 95)

	(print "--- C.O.: The Heretic army has been crushed!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1050_soc" none 1)
	
	(sleep 70)
	
	(print "--- Allies: yea hoo!  We've won!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1060_el1" none 1)
	
	(sleep 60)
	
	(print "--- Allies: we are victorious!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1070_el2" none 1)
	
	(sleep 65)
	
	(print "--- Allies: the dishonorable fools are no more!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1080_el1" none 1)
	
	(sleep 85)
	
	(print "--- C.O.: your mission is not over Dervish. ")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1090_soc" none 1)
	
	(sleep 55)
	
	(print "--- C.O.: Find the Heretic leader... ")
	
	(sleep 55)
	
	(print "--- C.O.: and destroy him.")
)


	;vvvvvvvv ------  excavation_end_heretic_leader_intro ------- vvvv
	
(script dormant hlead_intro

	(fade_out 0 0 0 0)
	
	(cinematic_start)
	(camera_control on)
	;(ai 0)
	
	(object_create_containing "excavation_hlead_intro")
	
	(camera_set hlead_intro_push_1 0)
	
	(sleep 30)
	
	(fade_in 1 1 1 15)
	
	(print "HERETIC LEADER INTRO")
	
	(print "--- Heretic Leader: Damn your ignorance, you doom us all!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1040_hld" none 1)
	
	(camera_set hlead_intro_push_2 200)
	
	(sleep 200)
	
	(print "---FIND TO THE RING OF CRAP!!!---")
	
	(camera_set hlead_intro_push_3 200)
	
	(sleep 200)
	
	(fade_out 1 1 1 15)
	
	(sleep 15)
	
	;(ai 1)
	(cinematic_stop)
	(camera_control off)
	
	(fade_in 1 1 1 15)
	
	(wake excavation_end_covenant_victory);wake
)	

(script dormant excavation_end_heretic_leader_i

	(sleep_until (<= (ai_living_count excavation_end) 1))
	
	(wake hlead_intro);wake
)

	;vvvvvvvv --excavation end ( dropship staging area )-- vvvvvvvv

	;vvvvvvvv ------  excavation_end_heretic_dialog ------- vvvv

(script dormant excavation_end_heretic_dialog

	(sleep_until (volume_test_objects excavation_end_g_strt (players))15)
	
	(wake excavation_end_heretic_leader_i);wake
	
	(sleep 30)
	
	(wake music_7)

	(sleep 40)
	
	(print "--- Heretic: they broken through the defenses!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0970_he1" none 1)
	
	(sleep 65)

	(print "--- Heretic: we couldn’t hold them!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0980_he2" none 1)
	
	(sleep 60)
	
	(print "--- Heretic: escape while you can!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0990_he1" none 1)
	
	(sleep 60)
	
	(print "--- Heretic: get these ships out of here!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1000_he2" none 1)
	
	(sleep 65)
	
	(print "--- Heretic: save what you can!")

	(sound_impulse_start "sound\dialog\alphamoon\level\l05_1010_he1" none 1)

)

;(script dormant excavation_end_hds02
	
	;(ai_place excavation_end_hds02)
;)

(script dormant excavation_end_hds01

	(sleep_until (volume_test_objects excavation_end_g_strt (players))15)

	;(ai_place excavation_end_hds01)
	
	;(sleep_until 
	;	(not 
	;		(cs_command_script_running excavation_end_hds01 cs_excavation_end_hds01)
	;	)
	;)
)

(script dormant excavation_end_turrets01

	(sleep_until (volume_test_objects excavation_end_g_strt (players))15)
	
	(sleep 20)
			
	;(ai_place excavation_end_turrets01)
)

(script dormant excavation_end_wraiths01

	(sleep_until (volume_test_objects excavation_end_g_strt (players))15)
	
	;(ai_place excavation_end_w_left)
	
	;-------------excavation end right wraith-------------- 
	
	;(ai_place excavation_end_w_right)
)

	;vvv----  Creates 4 wraiths at the entrance to end   -------vvvvv
	;vvv-----  theses wraiths migrate in sapian -----vvvv
	
(script dormant excavation_end_strt

	(sleep_until 
		(or
			(volume_test_objects excavation_end_strt_v_right (players))
			(volume_test_objects excavation_end_strt_v_left (players))
		)
	15)

	;(ai_place excavation_end_strt_left_w01)
	;(ai_place excavation_end_strt_right_w01)
	
	(wake excavation_end_heretic_dialog);wake
	
)

	;vvv--------  creates 4 ghosts and migrates them to excavation end ---v


;(script dormant excavation_middle_low

	;(sleep_until (volume_test_objects excavation_middle_low_v (players))15)
	
	;(wake excavation_end_strt);wake
	;(wake excavation_end_turrets01);wake
	;(wake excavation_end_wraiths01);wake
	
	;(ai_place excavation_middle_low_g02)
;)

(script dormant excavation_save

	(sleep_until (volume_test_objects excavation_middle_lower (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
)

;(script dormant excavation_m_hds01_int

	;(sleep_until (volume_test_objects excavation_m_hds01 (players))15)

	;(sleep 10)
	
	;(ai_place excavation_m_hds01)
;)

;(script dormant excavation_middle

;	(sleep_until (volume_test_objects excavation_start_g_r (players))15)
	
;	(wake excavation_middle_low);wake	
	
;	(wake excavation_m_hds01_int);wake
	
;	(sleep 30)

;	(wake excavation_save);wake

	;(ai_place excavation_turretgrunts02)
		
	;(ai_place excavation_tankelites02)
;)

;(script dormant excavation_middle_wraiths01

;	(sleep_until (volume_test_objects excavation_start_g_r (players))15)
	
;	(sleep 10)
	
	;(ai_place excavation_middle_w_elites01)
		
;)

;(script dormant excavation_middle_turrets01

;	(sleep_until (volume_test_objects excavation_start_g_r (players))15)
	
;	(sleep 5)
	
	;(ai_place excavation_middle_turrets_g01)
;)


(script dormant excavation_start_g_r

	;(ai_place excavation_start_g_r01)
	
	(sleep 10)
	
	;(ai_place excavation_start_i_r01)
	
)

	;v------------excavation start ghosts--------------v

(script dormant excavation_start_ghosts

	(sleep 10)

	;(ai_place excavation_start_g_elites01)

)

;(script dormant excavation_start01

;	(sleep_until (volume_test_objects excavation_e_i_back (players))15)
	
;	(game_save_unsafe);SSSAAAVVVEEE---
	
;	(wake excavation_start_ghosts);wake
;	(wake excavation_start_g_r);wake
	
;	(wake excavation_middle_wraiths01);wake
;	(wake excavation_middle_turrets01);wake

;v------------excavation start grunt turrets--------------v

	;(ai_place excavation_turretgrunts01)
	
;v------------excavation start elite tanks--------------v

	;(ai_place excavation_start_w_left)
	;(ai_place excavation_start_w_right)
	
;v------------excavation start flee grunts--------------v

	;(ai_place excavation_fleegrunts01)

;	(wake excavation_middle);wake
;)

;(script dormant excavation_start_allied_dialog

;	(sleep_until (volume_test_objects excavation_start_center (players))15)
	
;	(sleep 30)
	
;	(print "--- Allies: encountering fierce resistance")
	
;	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0950_soc" none 1) 
	
;	(sleep 65)
	
;	(print "--- Allies: they are fighting to the end")
	
;	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0960_soc" none 1)
	
;	(sleep 40)
	
;	(object_destroy_containing "supertrap_debris")
;)

;(script dormant excavation_e_allied_dialog
	
;	(sleep_until (volume_test_objects excavation_e_allied_dialog (players))15)
	
;	(wake excavation_start_allied_dialog);wake

;	(print "--- Allies: This is amazing")
	
;	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0910_el1" none 1) 
	
;	(sleep 55)
	
;	(print "--- Allies: they are using this wreckage as their base!")
	
;	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0920_el2" none 1) 
	
;	(sleep 75)
	
;	(print "--- Allies: weve entered the enemy strong hold!")
	
;	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0930_el1" none 1) 
	
;	(sleep 65)
	
;	(print "--- Allies: Their forces are almost crushed")
	
;	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0940_el2" none 1) 
	
;)

;(script dormant ai_kill05_script

;	(sleep_until (volume_test_objects excavation_e_i_back (players))15)

;	(wake ai_kill05)
;)

;(script dormant excavation_e

;	(sleep_until (volume_test_objects excavation_start01 (players))15)
	
;	(wake ai_kill05_script);wake
	
;	(wake excavation_e_allied_dialog);wake
	
	;(ai_place excavation_e_avturret_g)
	
	;(ai_place excavation_e_i_front)
	
	;(ai_place excavation_e_i_back)
	
	;(ai_place excavation_e_shadow01)
	
;	(sleep 10)

	;(ai_place excavation_tankelites01)
;)



;VVVVVVV-----------FINAL---____BATTLE____FINAL---____BATTLE!!!-----------vvvvv
;VVVVVVV-----------FINAL---____BATTLE____FINAL---____BATTLE!!!-----------vvvvv
;VVVVVVV-----------FINAL---____BATTLE____FINAL---____BATTLE!!!-----------vvvvv


(script command_script cs_final_bat_hds03

	(cs_vehicle_speed .5)

	(cs_fly_to final_bat_hds03/p0 3)
	(cs_fly_to final_bat_hds03/p1 3)
	(cs_fly_to final_bat_hds03/p2 3)
	(cs_fly_to_and_face final_bat_hds03/p3 final_bat_hds03/p4 3)
	
	(vehicle_unload (ai_vehicle_get final_bat_hds03/starting_locations_0) "c_dropship_lc")
	
	;(ai_exit_vehicle lz01_allied_grunts01)
	
	(cs_pause 32000)
)



(script static void dtest13

	(ai_erase final_bat_hds03)
	
	(sleep 10)
	
	(ai_place final_bat_hds03)
	
	(cs_run_command_script final_bat_hds03 cs_final_bat_hds03)

)



(script command_script cs_final_bat_hds02

	(cs_vehicle_speed .5)

	(cs_fly_to final_bat_hds02/p0 3)
	(cs_fly_to final_bat_hds02/p1 3)
	(cs_fly_to_and_face final_bat_hds02/p2 final_bat_hds02/p3 3)
	
	(vehicle_unload (ai_vehicle_get final_bat_hds02/starting_locations_0) "c_dropship_lc")
	
	;(ai_exit_vehicle lz01_allied_grunts01)
	
	(cs_pause 32000)
)



(script static void dtest12

	(ai_erase final_bat_hds02)
	
	(sleep 10)
	
	(ai_place final_bat_hds02)
	
	(cs_run_command_script final_bat_hds02 cs_final_bat_hds02)

)


(script command_script cs_final_bat_hds01

	(cs_vehicle_speed .5)

	(cs_fly_to final_bat_hds01/p0 3)
	(cs_fly_to final_bat_hds01/p1 3)
	(cs_fly_to_and_face final_bat_hds01/p2 final_bat_hds01/p3 3)
	
	(vehicle_unload (ai_vehicle_get final_bat_hds01/starting_locations_0) "c_dropship_sc_01")
	
	(sleep 30)
	
	(vehicle_unload (ai_vehicle_get final_bat_hds01/starting_locations_0) "c_dropship_sc_02")
	
	;(ai_exit_vehicle lz01_allied_grunts01)
	
	(cs_pause 32000)
)

(script static void dtest11

	(ai_erase final_bat_hds01)
	
	(sleep 10)
	
	(ai_place final_bat_hds01)
	
	(cs_run_command_script final_bat_hds01 cs_final_bat_hds01)

)

(script dormant final_bat_hds01

	(sleep_until (<= (ai_living_count 2turret_1st_v)0)) 
	
	(ai_place final_bat_hds01)
	
	(ai_place final_bat_hds02)
	
	(ai_place final_bat_hds03)

	;(ai_place_in_vehicle lz01_allied_grunts01 lz01_a_dropship01)

	(cs_run_command_script final_bat_hds01 cs_final_bat_hds01)
	
	(cs_run_command_script final_bat_hds02 cs_final_bat_hds02)
	
	(cs_run_command_script final_bat_hds03 cs_final_bat_hds03)
	
	(ai_place_in_vehicle final_bat_ghosts01 final_bat_hds01)
	
	(ai_place_in_vehicle final_bat_shadow01 final_bat_hds02)
	
	(ai_place_in_vehicle final_bat_wraith01 final_bat_hds03)
)





;VVVVVVV-----------SUPER---____TRAP____!!!-----------vvvvv
;VVVVVVV-----------SUPER---____TRAP____!!!-----------vvvvv

(script dormant supertrap_allied_reminder

	(sleep_until 
		(and
			(volume_test_objects super_trap_allied_end (players))
			(> (ai_living_count supertrap_enemies) 5)
		)
	15)
	
	(print "--- Allies: We cant proceed until you clear out the trap!!!")
	
	(sleep 55)
	
	(print "--- Allies: Destroy the Heretic Trap!!!")

)

(script dormant supertrap_allied_praise

	(sleep_until 
		(and
			(volume_test_objects super_trap_allied_end (players))
			(<= (ai_living_count supertrap_enemies) 5)
		)
	15)
	
	(object_destroy_containing "stdebris")

	(print "ALLIES PROCEEDING THROUGH SUPER TRAP")
	
	(sleep 30)
	
	(print "--- Allies: There's no way we could have done it with out you!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0890_el1" none 1) 
	
	(sleep 65)
	
	(print "--- Allies: we're lucky to have you in our group!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0900_el2" none 1) 

)




(script command_script cs_supertrap_hds01

	(cs_vehicle_speed .5)

	(cs_fly_to_and_face supertrap_hds01/p0 supertrap_hds01/p4 4)
	(cs_fly_to_and_face supertrap_hds01/p1 supertrap_hds01/p4 4)
	(cs_fly_to_and_face supertrap_hds01/p2 supertrap_hds01/p4 4)
	(cs_fly_to_and_face supertrap_hds01/p3 supertrap_hds01/p4 4)	
)

(script static void dtest14

	(ai_erase supertrap_hds01)
	
	(sleep 10)
	
	(ai_place supertrap_hds01)
	
	(cs_run_command_script supertrap_hds01 cs_supertrap_hds01)
)

(script dormant supertrap_hds01

	(sleep_until (volume_test_objects supertrap_hds01 (players))15)
	
	(ai_erase supertrap_hds01)
	
	(sleep 10)
	
	(ai_place supertrap_hds01)
	
	(sleep 300)
	
	(cs_run_command_script supertrap_hds01 cs_supertrap_hds01)
	
;	(sleep_until (volume_test_objects excavation_e_i_back (players))15)
	
;	(object_destroy (ai_vehicle_get supertrap_hds01))
)

(script dormant supertrap_end
	;ln1225
	(sleep_until (volume_test_objects super_trap_allied_end (players))15)

	(ai_place supertrap_end01)
	
	(sleep_until 
		(or
			(volume_test_objects supertrap_end02 (players))
			(<= (ai_living_count supertrap_end01) 2)
		)
		15)

	(ai_place supertrap_end02)
	
	(sleep_until 
		(or
			(volume_test_objects supertrap_end02 (players))
			(<= (ai_living_count supertrap_end01) 0)
			(<= (ai_living_count supertrap_end01) 2)
		)
		15)
		
	(ai_set_orders supertrap_end02 supertrap_end02)
	
	(sleep_until 
		(or
			(<= (ai_living_count supertrap_end01_02) 0)
		
			(and
				(volume_test_objects supertrap_end03 (players))
				(<= (ai_living_count supertrap_end01_02) 2)
			)
		)
	15)
	
	(ai_place supertrap_end03)
	
	(ai_set_orders supertrap_end03 supertrap_end02)
	
	(sleep_until 
		(or
			(volume_test_objects supertrap_end03 (players))
			(<= (ai_living_count supertrap_end03) 1)
		)
	)
	
	(ai_place supertrap_end04)
	
	(ai_set_orders supertrap_end03 supertrap_end03)
	
	
	(print "supertrap_end01")
)

(script dormant supertrap_save
	
	(print "supertrap_save")
	
	(sleep_until (volume_test_objects supertrap_save (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(object_create_containing "supertrap_debris")

)

(script dormant supertrap_bridge01; maybe eventually add script to check for # of guys before these guys spawn
	;ln1197
	(sleep_until (volume_test_objects supertrap_bridge01 (players))15)
	
	(ai_place supertrap_bridge01)
	
)

(script dormant supertrap_interior
	;ln1196
	(sleep_until 
		(or
			(volume_test_objects supertrap_interior_low (players))
			(volume_test_objects supertrap_interior (players))
		)
	15)
	
	(ai_place supertrap_interior)

)

(script dormant supertrap_v

	(sleep 20)
	
	(sleep_until (volume_test_objects supertrap01 (players))15)
	
	(wake supertrap_interior);wake ln1156
	(wake supertrap_bridge01);wake ln1169
	
	(wake supertrap_end);wake ln1144
	
	
	(object_create supertrap_jackable_wraith01)

	;(object_create supertrap_wraith_right)
	;(object_create supertrap_wraith_left)
	
	(ai_place supertrap_left_v)
	(ai_place supertrap_right_v)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors supertrap_left_v) 0)) supertrap_wraith_left "wraith_driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors supertrap_right_v) 0)) supertrap_wraith_right "wraith_driver")
	
	(ai_set_orders supertrap_left_v supertrap_v_left_intro)
	(ai_set_orders supertrap_right_v supertrap_v_right_intro)
	
	(sleep_until (volume_test_objects supertrap_v_attack (players))15)
	
	(ai_set_orders supertrap_left_v supertrap_v_attack)
	(ai_set_orders supertrap_right_v supertrap_v_attack)
	
	(object_create_containing "excavation_e_debris")
	
	

)

(script dormant supertrap_middle_save

	(sleep_until 
		(or	
			(volume_test_objects supertrap_middle_save (players))
			(volume_test_objects supertrap_bridge01_cntr (players))
			(volume_test_objects supertrap_third_bridge (players))
		)	
	15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
)

(script dormant supertrap01
	
	(print "supertrap01")
	
	(wake supertrap_allied_praise);wake
	
	(wake supertrap_allied_reminder);wake
	
	(wake supertrap_save);wake
	
	(wake supertrap_v);wake
	
;	(wake excavation_e);wake
	
	(sleep_until (volume_test_objects supertrap01 (players))15)
	
	(print "trigger")
	
	(object_create_containing "stdebris")
	
	(ai_place supertrap_turretgrunts01)
	
	(ai_set_orders supertrap_turretgrunts01 supertrap_turret_attack)
	
	(sleep 15)
	
	(wake ai_kill04);wake
	
	(wake supertrap_middle_save);wake
	
	(wake supertrap_hds01);wake

	;v--------------supertrap ground tank-----------v
	
	(ai_place supertrap_tankelites01)
		
	(ai_set_orders supertrap_tankelites01 supertrap_ground_v_intro)
	
	;v-------------supertrap frontgrunts------------v

	(ai_place supertrap_grunts01)
	(ai_place supertrap_grunts02)
	
	(ai_set_orders supertrap_grunts01 supertrap_first_bridge)
	(ai_set_orders supertrap_grunts02 supertrap_turret_attack)
	
	;v------------more supertrap grunts-------------v

	(sleep_until (volume_test_objects supertrap02 (players))15)

	(ai_place supertrap_grunts03)
	
	(ai_set_orders supertrap_grunts03 supertrap_right_i_attack)

)


;vvvvvvvv====================Pre_s_trap==================vvvvvvvvvvv

(script dormant pre_s_trap_front_back

	(sleep_until (<= (ai_living_count pre_s_trap_front_back) 3))
	
	(ai_set_orders pre_s_trap_front_back pre_s_trap_back)
	

)
(script dormant pre_s_trap_back_all

	(sleep_until (volume_test_objects pre_s_trap_back_all (players))15)

	(if G_pre_s_trap_back (sleep_forever))
	(set G_pre_s_trap_back true)

	(ai_place pre_s_trap_back)
	
	(ai_place pre_s_trap_back02)
	
	(wake pre_s_trap_front_back);wake

)

(script dormant pre_s_trap_back

	(sleep_until 
		(or
			(volume_test_objects pre_s_trap_back (players))
			(<= (ai_living_count pre_s_trap_front) 2)
		)
	)

	(if G_pre_s_trap_back (sleep_forever))
	(set G_pre_s_trap_back true)

	(ai_place pre_s_trap_back)
	
	(ai_set_orders pre_s_trap_back pre_s_trap_front)
	
	(wake pre_s_trap_front_back);wake
	
	(sleep_until (volume_test_objects pre_s_trap_back_all (players))15)
	
	(ai_place pre_s_trap_back02)
	

)

(script dormant pre_s_trap
	;ln2313
	(sleep_until (volume_test_objects supertrap_save (players))15)

	(ai_place pre_s_trap_front)
	
	(wake pre_s_trap_back);wake
	
	(wake pre_s_trap_back_all);wake
	
	(wake supertrap01);wake
	
)



(script dormant supertrap_allied_trap_response

	(sleep_until (volume_test_objects supertrap01 (players))15)
	
	(print "--- Allies: retreat!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0840_el1" none 1) 
	
	(sleep 45)
	
	(print "--- Allies: were sitting ducks!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0850_el2" none 1) 
	
	(sleep 75)
	
	(print "--- Allies: this was a stupid idea!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0860_el1" none 1) 
	
	;vvvvv------ allies telling player they wont progress------vvvv
	
	(sleep 90)
	
	(print "--- Allies: That area is too well defended!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0870_el1" none 1) 
	
	(sleep 55)
	
	(print "--- Allies: We cant advance with our vehicles!!!!")
	
	(sleep 45)
	
	(print "--- Allies: We'll all be killed if we go through that with our vehicles!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0880_el2" none 1) 

)

(script dormant supertrap_allied_warning

	(sleep_until (volume_test_objects supertrap_allied_warning (players))15)
	
	(print "--- Allies: that looks dangerous")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0820_el1" none 1) 
	
	(sleep 55)
	
	(print "--- Allies: we'll be helpless in there")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0830_el2" none 1) 
	
	(wake supertrap_allied_trap_response);wake

)

;vvvvvv-------vvvvvvvvvvv-- 2 TURRET --vvvvvvvvv------------------------------------------------------------VVVVVVV
;vvvvvv-------vvvvvvvvvvv-- 2 TURRET --vvvvvvvvv------------------------------------------------------------VVVVVVV
;vvvvvv-------vvvvvvvvvvv-- 2 TURRET --vvvvvvvvv------------------------------------------------------------VVVVVVV


(script command_script cs_2turret_hdropship01

	(cs_fly_by 2turret_hdropship01/p0)
	(cs_fly_to_and_face 2turret_hdropship01/p1 2turret_hdropship01/p2)
	(cs_fly_to_and_face 2turret_hdropship01/p2 2turret_hdropship01/p3)
	(cs_fly_to_and_face 2turret_hdropship01/p3 2turret_hdropship01/p4)
	(cs_fly_to 2turret_hdropship01/p4)
)

(script dormant 2turret_hdropship01

	(sleep_until (volume_test_objects 2turret_attack_back (players))15)
	
	(sleep 100)
	
	(ai_erase 2turret_hdropship01)
	
	(sleep 10)
	
	(ai_place 2turret_hdropship01)
	
	(ai_set_orders 2turret_hdropship01 2turret_dropship_right)
	
	(cs_run_command_script 2turret_hdropship01 cs_2turret_hdropship01)
	
	(sleep_until (volume_test_objects supertrap01 (players))15)
	
	(object_destroy (ai_vehicle_get 2turret_hdropship01))
	(ai_erase 2turret_hdropship01)
)

(script static void test
	
	(ai_erase 2turret_hdropship01)
	
	(sleep 10)

	(ai_place 2turret_hdropship01)
	
	(cs_run_command_script 2turret_hdropship01 cs_2turret_hdropship01)
	
	(sleep_until (volume_test_objects supertrap01 (players))15)
	(object_destroy (ai_vehicle_get 2turret_hdropship01))
	(ai_erase 2turret_hdropship01)
)

	;(garbage_collect_unsafe)
	
(script dormant 2turret_allied_reinforcements

	(sleep 20)
	
	(wake supertrap_allied_warning);wake
	
	(object_create_containing "2turret_allied_R")
	
	(sleep 35)
	
	(print "--- Allies: what a relief")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0780_el1" none 1) 
	
	(sleep 65)
	
	(print "--- Allies: they don’t stand a chance now")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0790_el2" none 1) 
	
	(sleep 65)

	(print "--- Reinforcements: ready to serve!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0800_gr1" none 1) 
	
	(sleep 38)
	
	(print "--- Reinforcements: victory will be ours!!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0810_gr2" none 1) 
)
	
	
	
(script command_script cs_2turret_a_ds02

	(cs_vehicle_speed .7)

	(cs_fly_to 2turret_a_ds02/p0 4)
	(cs_fly_to 2turret_a_ds02/p1 4)
	(cs_fly_to 2turret_a_ds02/p2 4)
	(cs_fly_to 2turret_a_ds02/p3 4)
	(cs_vehicle_speed .2)
	(cs_fly_to 2turret_a_ds02/p4 4)
	(cs_fly_to_and_face 2turret_a_ds02/p5 2turret_a_ds02/p6 4)
)	
	
(script command_script cs_2turret_a_ds01

	(cs_vehicle_speed .5)

	(cs_fly_to 2turret_a_ds01/p0 4)
	(cs_fly_to 2turret_a_ds01/p1 4)
	(cs_fly_to 2turret_a_ds01/p2 4)
	(cs_vehicle_speed .2)
	(cs_fly_to 2turret_a_ds01/p3 4)
	
	(print "--- DS pilot:Prepare for landing")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0770_el1" none 1)
	
	(cs_fly_to_and_face 2turret_a_ds01/p4 2turret_a_ds01/p5 4)
	
	;(cs_pause 90)
	(print "unload")
	
	;(vehicle_unload (ai_vehicle_get 2turret_a_ds01/1) "cargo")
	
	(wake 2turret_allied_reinforcements);wake
)

(script static void dtest15

	(ai_erase 2turret_a_ds01)
	
	(sleep 10)
	
	(ai_place 2turret_a_ds01)
	
	(ai_place_in_vehicle 2turret_a_ds_wraith 2turret_a_ds01)
	
	(cs_run_command_script 2turret_a_ds01 cs_2turret_a_ds01)
	
	(sleep 30)
	
	;(cs_run_command_script 2turret_a_ds01/2 cs_2turret_a_ds02)
	
)

(script dormant 2turret_a_ds01

	(ai_erase 2turret_a_ds01)
	
	(sleep 10)
	
	(ai_place 2turret_a_ds01)
	
	;(ai_place_in_vehicle 2turret_a_ds_wraith 2turret_a_ds01/1)
	
	;(cs_run_command_script 2turret_a_ds01/1 cs_2turret_a_ds01)
	
	(sleep 30)
	
	;(cs_run_command_script 2turret_a_ds01/2 cs_2turret_a_ds02)
	
	;(sleep_until (volume_test_objects 2turret_intro_dialog (players)))
	;(object_destroy (ai_vehicle_get runandgun02_hds01/starting_locations_0))
)

(script dormant 2turret_allied_reinforce_dialog
	
	(sleep_until 
		(and
			(<= (unit_get_health 2turret_left)0) 
			(<= (unit_get_health 2turret_right)0)
		)
	)
	
	(sleep 30)
	
	(wake 2turret_a_ds01);wake
	
	(print "--- DS pilot: Proceeding to new LZ")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0760_el1" none 1) 
	
	(sleep 65)
	
	;(object_destroy 2turret_dropship02)
)


(script command_script cs_2turret_trench
	
	(print "guys walk off cliff")
	
	(cs_move_in_direction 71 7 0)
)	


(script dormant 2turret_trench

	(sleep_until (volume_test_objects 2turret_trench (players))15)
	
	(ai_place 2turret_trench01)

	(cs_run_command_script 2turret_trench01 cs_2turret_trench)
)

(script dormant 2turret_interior_front_front

	(sleep_until (volume_test_objects 2turret_interior_front_front (players))15)

	(if G_2turret_interior_front (sleep 32000))
	(set G_2turret_interior_front true)
	
	(wake 2turret_trench);wake
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place 2turret_interior_front)

	(ai_set_orders 2turret_interior_front 2turret_interior_front)
	
	(sleep_until 
		(or
			(volume_test_objects 2turret_interior_f_exit (players))
			(<= (ai_living_count 2turret_interior_front) 2)
		)	
	15)
	
	(ai_place 2turret_interior_f_exit)
	
	(ai_set_orders 2turret_interior_f_exit 2turret_interior_f_exit)
	
	(sleep_until 
		(volume_test_objects 2turret_interior_middle_f02 (players))15)
		
	(ai_set_orders 2turret_interior_f_exit 2turret_interior_middle_f)
	
	(ai_set_orders 2turret_interior_front 2turret_interior_f_exit)
		
	(ai_place 2turret_interior_middle_b)
	
	(ai_set_orders 2turret_interior_middle_b 2turret_interior_middle_b)
	
)

(script dormant 2turret_interior_front_back

	(sleep_until (volume_test_objects 2turret_interior_front_back (players))15)

	(if G_2turret_interior_front (sleep 32000))
	(set G_2turret_interior_front true)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place 2turret_interior_middle_b)
	
	(ai_set_orders 2turret_interior_middle_b 2turret_interior_middle_b)
	
	(ai_place 2turret_interior_f_exit)
	
	(ai_set_orders 2turret_interior_f_exit 2turret_interior_middle_b)
	
	(sleep_until 
		(or
			(<= (ai_living_count 2turret_interior_middle) 2)
			(volume_test_objects 2turret_interior_middle_f (players))
		)
	)
		(ai_set_orders 2turret_interior_middle 2turret_interior_middle_f)
		
	(sleep_until (volume_test_objects 2turret_interior_front_front (players))15)
	
	(ai_set_orders 2turret_interior_middle 2turret_interior_f_exit_r)
	
	(ai_place 2turret_interior_front)
	
	(ai_set_orders 2turret_interior_front 2turret_interior_front)
	
)

	;vvvvvvvvvv 2 turret--------interior back  vvvvvvvvvvvvvvvv

(script dormant 2turret_interior_back
	
	(sleep_until (volume_test_objects 2turret_interior_back (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
		(ai_place 2turret_interior_back)
	
		(ai_set_orders 2turret_interior_back 2turret_interior_back)
	
		(ai_place 2turret_interior_back_low)
	
	(sleep_until (volume_test_objects 2turret_interior_back02 (players))15)
	
		(ai_set_orders 2turret_interior_back_low 2turret_interior_back)
)

(script continuous 2turret_turret_left

	(sleep (random_range 20 55))
	
	;(print "2turret_turret_left")
	
	;(effect_new "effects\test\stephen_beam" 2turret_left)
	;(effect_new "effects\retro_rockets" 2turret_left)
	;(sound_impulse_start "sound\temp\plasma grenade\plasmagrenexpl" 2turret_left 1)
	
	(if 
		(<= (unit_get_health 2turret_left)0) 
		(begin
			;(effect_new "effects\test\stephen_explosion" 2turret_left_explosion)
			(sleep_forever) 
		)
	)
)

(script continuous 2turret_turret_right

	(sleep (random_range 20 55))
	
	;(print "2turret_turret_right")
	
	;(effect_new "effects\test\stephen_beam" 2turret_right)
	;(effect_new "effects\retro_rockets" 2turret_right)
	;(sound_impulse_start "sound\temp\plasma grenade\plasmagrenexpl" 2turret_right 1)
	
	(if 
		(<= (unit_get_health 2turret_right)0) 
		(begin
			;(effect_new "effects\test\stephen_explosion" 2turret_right_explosion)
			(sleep_forever) 
		)
	)

)


(script dormant 2turret_creation

	;(object_create 2turret_guntower_left)
	;(object_create 2turret_guntower_right)
	
	;(object_create 2turret_left)
	;(object_create 2turret_right)
	
	(wake 2turret_turret_right);wake
	(wake 2turret_turret_left);wake

)



(script dormant 2turret_allies_cds

	(object_create_containing "2turret_a_cds_debris")
	
	(object_create 2turret_allies_cds01)
	
	(sleep 45)
	
	(ai_place 2turret_allies_cds)
	
	(ai_set_orders 2turret_allies_cds 2turret_allies_cds)
)



(script dormant 2turret_middle_dialog

	(sleep_until (volume_test_objects 2turret_attack_back (players))15)
	
	(wake 2turret_allied_reinforce_dialog);wake

	(print "--- Allies: we need to get around them!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0720_el1" none 1) 
	
	(sleep 60)
	
	(print "--- Allies: attacking these turrets with vehicles is futil!!") 
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0730_el2" none 1) 

)

(script dormant 2turret_intro_dialog

	(sleep_until (volume_test_objects 2turret_intro_dialog (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake 2turret_middle_dialog);wake
	
	(sleep 25)
	
	(wake music_6)
	
	(sleep 25)
	
	(print "--- Allies: WART WART!! Theres 2 turrets!!") 
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0700_el1" none 1)
	
	(sleep 60)
	
	(print "--- Allies: Our vehicles are vunerable!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0710_el2" none 1)

)

(script dormant 2turret01

	(sleep_until (volume_test_objects 2turret01 (players))15)
	
	(wake 2turret_creation);wake
	(wake ai_kill03);wake
	(wake 2turret_intro_dialog);wake
	
	(sleep 5)
	
	(wake 2turret_allies_cds);wake
	
	(object_destroy_containing "1turret_debris")
	
	;(object_create 2turret_ghost01)
	;(object_create 2turret_ghost02)
	
	(ai_place 2turret_tankelites01)
	
	(ai_place 2turret_ghostelites01)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors 2turret_ghostelites01) 0)) 2turret_ghost01 "g-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 2turret_ghostelites01) 1)) 2turret_ghost02 "g-driver")
	
	;(ai_set_orders 2turret_tankelites01 2turret_w_intro)
	
	(ai_set_orders 2turret_ghostelites01 2turret_g_intro)
	
	(sleep_until (volume_test_objects 2turret_attack_back (players)))
	
	;(ai_set_orders 2turret_tankelites01 2turret_w_attack_back)
	
	(sleep 5)
	
	;(object_create 2turret_avturret01)
	;(object_create 2turret_avturret02)
	
	(ai_place 2turret_av_turrets)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors 2turret_av_turrets) 0)) 2turret_avturret01 "gt-gunner")
	;(unit_enter_vehicle (unit (list_get (ai_actors 2turret_av_turrets) 1)) 2turret_avturret02 "gt-gunner")
	
	(ai_set_orders 2turret_av_turrets 2turret_w_attack_front)
	
	(object_create 2turret_player_wraith01)
	
	(wake 2turret_hdropship01);wake
	
	(sleep 30)
	
	(wake 2turret_interior_front_front);wake
	(wake 2turret_interior_front_back);wake
	
	(wake 2turret_interior_back);wake

)





;VVVVVVVVVVVV+++++++++++   RUNANDGUN02   ++++++++--------------------------------------------------------vvvvvvvvvv
;VVVVVVVVVVVV+++++++++++   RUNANDGUN02   ++++++++--------------------------------------------------------vvvvvvvvvv
;VVVVVVVVVVVV+++++++++++   RUNANDGUN02   ++++++++--------------------------------------------------------vvvvvvvvvv

(script dormant runandgun02_interior_top
;ln1911
	(sleep_until 
		(or
			(volume_test_objects runandgun02_interior_top (players))
			(<= (ai_living_count runandgun02_t_grunts02) 1)
		)
	)

	(ai_place runandgun02_interior_top)
)

(script dormant runandgun02_interior_cnt_l
;ln1899
	(sleep_until 
		(or
			(volume_test_objects runandgun02_interior_up (players))
			(<= (ai_living_count runandgun02_interior_i) 3)
		)
	)

	(if G_runandgun02_interior_l (sleep 32000))
	(set G_runandgun02_interior_l true)
	
	(ai_place runandgun02_interior_left)
	
	(ai_place runandgun02_interior_cnt)
	
	(ai_set_orders runandgun02_interior_l runandgun02_interior_l)
	
	(ai_set_orders runandgun02_interior_cnt_l runandgun02_interior_cnt_l)
	
	(ai_set_orders runandgun02_interior_cnt runandgun02_interior_cnt)
	
	(sleep_until (volume_test_objects runandgun02_interior_trigger (players)))
	
		(ai_set_orders runandgun02_interior_left runandgun02_interior_cnt)
)

(script dormant runandgun02_interior_l
;ln1897
	(sleep_until (volume_test_objects runandgun02_interior_l (players)))

	(if G_runandgun02_interior_l (sleep 32000))
	(set G_runandgun02_interior_l true)
	
	(ai_place runandgun02_interior_left)
	
	(ai_set_orders runandgun02_interior_left runandgun02_interior_l)
	
	;(sleep_until (volume_test_objects runandgun02_interior_cnt_l (players)))
	
	(sleep_until (<= (ai_living_count runandgun02_interior_left) 3))
	
	(ai_place runandgun02_interior_cnt)
	
	(ai_set_orders runandgun02_interior_cnt runandgun02_interior_cnt_l)
)


	;vvvvvvvvVVVV----- runandgun02 ghostelites01 ------VVVVVVvvvvvvv
	
(script dormant runandgun02_interior

	(sleep_until 
		(or
			(volume_test_objects runandgun02_interior_trigger (players))
			(volume_test_objects runandgun02_interior_back (players))	
		)
	)

	(wake runandgun02_interior_l);wake ln1873
	(wake runandgun02_interior_cnt_l);wake ln1844
	(wake runandgun02_interior_top);wake ln1843
	
	(game_save_unsafe);SSSAAAVVVEEE---
		
	(ai_place runandgun02_interior)
	(ai_place runandgun02_interior02)
	
	(ai_set_orders runandgun02_interior runandgun02_interior_intro_low)
	(ai_set_orders runandgun02_interior02 runandgun02_interior_intro_high)
	
	(sleep_until 
		(or	(<= (ai_living_count runandgun02_interior_i) 3)
			(volume_test_objects runandgun02_interior_low_trigge (players))
		)
	)
	
	(ai_place runandgun02_interior_r)
	
	(ai_set_orders runandgun02_interior_r runandgun02_interior_intro_low)
)	

(script dormant runandgun02_g_reinforce_high

	(sleep_until (volume_test_objects runandgun02_up01 (players)))
	
	(sleep_until (<= (ai_living_count runandgun02_ghostelites01) 0))

	(if G_runandgun02_g_reinforcements (sleep 32000))
	(set G_runandgun02_g_reinforcements true)

	(ai_place runandgun02_r_ghostelites01)
	
	;(object_create runandgun02_ghost03)
	;(object_create runandgun02_ghost04)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_r_ghostelites01) 0)) runandgun02_ghost03 "g-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_r_ghostelites01) 0)) runandgun02_ghost04 "g-driver")
	
	(ai_set_orders runandgun02_r_ghostelites01 runandgun02_g_intro_up)
)

(script dormant runandgun02_g_reinforce_low

	(sleep_until (volume_test_objects runandgun02_low (players)))
	
	(sleep_until 
		(or
			(<= (ai_living_count runandgun02_tankelites01) 0)
			(volume_test_objects runandgun02_low (players))
		)
	)

	(if G_runandgun02_g_reinforcements (sleep 32000))
	(set G_runandgun02_g_reinforcements true)
	
	(ai_place runandgun02_r_ghostelites01)
	
	(ai_set_orders runandgun02_r_ghostelites01 runandgun02_g_intro_low)
)

(script dormant runandgun02_ghostelites01

	(sleep_until 
		(or
			(volume_test_objects runandgun02_ghostelites01 (players))
			(<= (ai_living_count runandgun02_low_wraiths) 1)
		)	
	15)
	
	(if G_runandgun02_g (sleep 32000))
	(set G_runandgun02_g true)
	
	;(object_create runandgun02_ghost01)
	;(object_create runandgun02_ghost02)

	(ai_place runandgun02_ghostelites01)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_ghostelites01) 0)) runandgun02_ghost01 "g-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_ghostelites01) 1)) runandgun02_ghost02 "g-driver")
	
	(ai_set_orders runandgun02_ghostelites01 runandgun02_g_intro_low)

)

(script dormant runandgun02_ghostelites02

	(sleep_until 
		;(or
			(volume_test_objects runandgun02_up01 (players))
			;(<= (ai_living_count runandgun02_tankelites01) 1)
		;)	
	15)
	
	(if G_runandgun02_g (sleep 32000))
	(set G_runandgun02_g true)
	
	;(object_create runandgun02_ghost01)
	;(object_create runandgun02_ghost02)

	(ai_place runandgun02_ghostelites01)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_ghostelites01) 0)) runandgun02_ghost01 "g-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_ghostelites01) 1)) runandgun02_ghost02 "g-driver")
	
	(ai_set_orders runandgun02_ghostelites01 runandgun02_g_intro_up)
)

(script dormant runandgun02_up_wraith

	;(object_create runandgun02_wraith03)
	
	(ai_place runandgun02_up_wraith)

	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_up_wraith) 0)) runandgun02_wraith03 "wraith-driver")

	(ai_set_orders runandgun02_up_wraith runandgun02_up_wraith_intro)
)
;(runandgun02_dialog_wraith_warning

;	(sleep_until 
;		(or
;			(volume_test_objects runandgun02_low (players))
;			(volume_test_objects runandgun02_up01 (players))
;		)
;	)

;	(print "--- Allies: Watch out Wraiths!!!")
	
;	(sleep 55)
	
;	(print "--- Allies: How did they get all these tanks?")

;)

(script dormant runandgun02_dialog_low
		 
	(sleep_until (volume_test_objects runandgun02_low (players)))
	
	(if G_runandgun02_dialog  (sleep_forever))
	(set G_runandgun02_dialog  true)
	
		(sleep 15)
	
	(print "--- Allies: Watch out Wraiths!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0610_el1" none 1)
	
		(sleep 55)
	
	(print "--- Allies: How did they get all these tanks?")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0620_el1" none 1)
	
		(sleep 60)
	
	(print "--- Allies: those turrets above us are hard to hit!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0670_el1" none 1)
	
		(sleep 30)
	
	(print "--- Allies: Taking heavy Fire!!!")
)

(script dormant runandgun02_dialog_hi
	
	(sleep_until (volume_test_objects runandgun02_up01 (players)))
		 
	(if G_runandgun02_dialog  (sleep_forever))
	(set G_runandgun02_dialog  true)
	
	(sleep 15)
	
	(print "--- Allies: Watch out Wraiths!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0610_el1" none 1)
	
	(sleep 55)
	
	(print "--- Allies: How did they get all these tanks?")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0620_el1" none 1)
	
	(sleep 60)
	
	(print "--- Allies: theres no cover from drop ships up there!!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0660_el1" none 1)
	
	(sleep 30)
	
	(print "--- Allies: Taking heavy Fire!!!")
)

(script dormant runandgun02_banshees

	(ai_place runandgun02_banshees)
)

(script command_script cs_runandgun02_hds01

	(cs_vehicle_speed .3)

	(cs_fly_to_and_face runandgun02_hds01/p0 runandgun02_hds01/p3 4)
	(cs_fly_to_and_face runandgun02_hds01/p1 runandgun02_hds01/p3 4)
	(cs_fly_to_and_face runandgun02_hds01/p2 runandgun02_hds01/p3 4)
)

(script continuous runandgun02_hds01_loop

	(print "continuous running")
	
	(sleep_until 
		(not 
			(cs_command_script_running runandgun02_hds01 cs_runandgun02_hds01)
		)
	)
	
	(print "script running")
	
	(cs_run_command_script runandgun02_hds01 cs_runandgun02_hds01)
)	

(script command_script cs_runandgun02_hds01_int

	(cs_vehicle_speed .5)

	(cs_fly_to runandgun02_hds01_int/p0 4)
	(cs_fly_to runandgun02_hds01_int/p1 4)
	(cs_fly_to runandgun02_hds01_int/p2 4)
	(cs_fly_to runandgun02_hds01_int/p3 4)
	
	(wake runandgun02_hds01_loop);wake
)

(script static void dtest09

	(ai_erase runandgun02_hds01)
	
	(sleep 10)
	
	(ai_place runandgun02_hds01)
	
	(cs_run_command_script runandgun02_hds01 cs_runandgun02_hds01_int)
	
	(sleep_until (volume_test_objects 2turret_intro_dialog (players)))
	(sleep_forever runandgun02_hds01_loop)
	(object_destroy (ai_vehicle_get runandgun02_hds01/starting_locations_0))
)

(script dormant runandgun02_hds01_int

	(ai_erase 1turret_hdropship01)
	
	(sleep 10)
	
	(ai_place 1turret_hdropship01)
	
	(cs_run_command_script runandgun02_hds01 cs_runandgun02_hds01_int)
	
	(sleep_until (volume_test_objects 2turret_intro_dialog (players)))
	(sleep_forever runandgun02_hds01_loop)
	(object_destroy (ai_vehicle_get runandgun02_hds01/starting_locations_0))
)


(script dormant runandgun02

	(sleep_until (volume_test_objects runandgun02 (players)))
	
	(object_destroy runandgun01_turret01)
	
	(object_destroy view_wraith02)
	(object_destroy view_ghost01)
	
	;v---------- wake script ai_kill02------------v
	
	(wake ai_kill02);wake
	
	;v---------- game save------------v

	(game_save_unsafe);SSSAAAVVVEEE---
	
	;v---------- runandgun02 enemies------------vv
	
	;-(object_create runandgun02_turret01)
	;-(object_create runandgun02_turret02)
	;-(object_create runandgun02_turret03)
	;-(object_create runandgun02_turret04)
	;-(object_create runandgun02_turret05)
	;-(object_create runandgun02_turret06)
	
	(object_create runandgun02_player_w01)
	
	(object_create_containing "runandgun02_debris")
	
	(ai_place runandgun02_t_grunts01)
	(ai_place runandgun02_t_grunts02)
	
	(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_t_grunts01) 0)) runandgun02_turret01 "gt_gunner")
	(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_t_grunts01) 1)) runandgun02_turret02 "gt_gunner")
	(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_t_grunts01) 2)) runandgun02_turret03 "gt_gunner")
	
	(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_t_grunts02) 0)) runandgun02_turret04 "gt_gunner")
	(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_t_grunts02) 1)) runandgun02_turret05 "gt_gunner")
	(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_t_grunts02) 2)) runandgun02_turret06 "gt_gunner")
	
	(ai_set_orders runandgun02_t_grunts01 runandgun02_v_attack)
	(ai_set_orders runandgun02_t_grunts02 runandgun02_v_attack)
	
	;(object_create runandgun02_wraith01)
	;(object_create runandgun02_wraith02)
	
	(ai_place runandgun02_tankelites01)
	(ai_place runandgun02_exit_wraith)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_tankelites01) 0)) runandgun02_wraith01 "wraith-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun02_tankelites01) 1)) runandgun02_wraith02 "wraith-driver")
	
	(ai_set_orders runandgun02_tankelites01 runandgun02_v_attack)
	(ai_set_orders runandgun02_exit_wraith runandgun02_exit_wraith)
	
	
	(wake runandgun02_ghostelites01);wake
	(wake runandgun02_ghostelites02);wake
	(wake runandgun02_interior);wake
	
	(sleep 15)
	
	(wake runandgun02_up_wraith);wake
	
	(wake runandgun02_dialog_hi);wake
	(wake runandgun02_dialog_low);wake
	
	(wake runandgun02_g_reinforce_high);wake
	(wake runandgun02_g_reinforce_low);wake
	
	(sleep 30)
	
	(wake runandgun02_hds01_int);wake
	(wake runandgun02_banshees);wake
	
	(wake pre_s_trap);wakeln1374
	
)






;vvvvvvvvvvv----------- 1TURRET!!!!!!!!!!!!!!!! --------------------------------------------------------vvvvvvvvvv
;vvvvvvvvvvv----------- 1TURRET!!!!!!!!!!!!!!!! --------------------------------------------------------vvvvvvvvvv
;vvvvvvvvvvv----------- 1TURRET!!!!!!!!!!!!!!!! --------------------------------------------------------vvvvvvvvvv


(script dormant 1turret_a_dropship01_cnt

		(sleep 30)
	
	(print "--- Allies: Excellent, reinforcements!")	
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0570_el1" none 1)
	
	(object_create 1turret_allied_wraith01)
	
		(sleep 45)
	
	(print "--- Allies: good to see you brothers!")	
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0580_el2" none 1)
	
		(sleep 60)
	
	(print "--- Reinforcements: ready for next assualt!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0590_gr1" none 1)
	
		(sleep 65)
	
	(print "--- Reinforcements: locked and loaded!")

	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0600_gr2" none 1)


)

(script dormant 1turret_a_dropship01_d
	
	(sleep 55)
		
	(print "--- DS pilot: Clear Landing Zone for reinforcements")	
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0561_el1" none 1)
)

(script command_script cs_1turret_a_dropship01

	(cs_vehicle_speed .8)

	(cs_fly_to 1turret_a_dropship01/p0 4)
	(cs_fly_to 1turret_a_dropship01/p1 4)
	(cs_fly_to 1turret_a_dropship01/p2 4)
	(cs_fly_to 1turret_a_dropship01/p3 4)
	
	(cs_vehicle_speed .4)
	
	(wake 1turret_a_dropship01_d);wake
	
	(cs_fly_to_and_face 1turret_a_dropship01/p4 1turret_a_dropship01/p5 4)
	
	(wake 1turret_a_dropship01_cnt);wake

	(cs_pause 32000)
)

(script static void dtest08

	(ai_erase 1turret_a_dropship01)
	
	(sleep 10)
	
	(ai_place 1turret_a_dropship01)
	
	;(wake 1turret_hdropship01_loop);wake
	
	(cs_run_command_script 1turret_a_dropship01 cs_1turret_a_dropship01)
	
	(sleep_until (volume_test_objects 2turret01 (players)))
	(object_destroy (ai_vehicle_get 1turret_a_dropship01/starting_locations_0))
)

(script dormant 1turret_a_dropship01

	(ai_erase 1turret_a_dropship01)
	
	(sleep 10)
	
	(ai_place 1turret_a_dropship01)
	
	(cs_run_command_script 1turret_a_dropship01 cs_1turret_a_dropship01)
	
	(sleep_until (volume_test_objects 2turret01 (players)))
	(object_destroy (ai_vehicle_get 1turret_a_dropship01/starting_locations_0))
)

(script dormant allied_reinforcements

	(sleep_until 
		(and
			(<= (ai_living_count 1turret_jack_elites01) 0)
			(<= (unit_get_health 1turret)0)
		)
	)
	
	(wake 1turret_a_dropship01);wake
	
		(sleep 45)
	
	(print "--- DS pilot: Drop ships on route")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0560_el1" none 1)
)

	;Vvvvvvvvvvvvv----------- 1turret_jack_elites03 ----------vvvvvvvV

(script dormant 1turret_jack_elites03

	(sleep_until (<= (ai_living_count 1turret_end_i) 2))
	
	(if 1turret_jack_elites (sleep 32000))
	(set 1turret_jack_elites true)

	(ai_place 1turret_jack_elites01)

	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_jack_elites01) 0)) 1turret_jack_wraith01 "wraith-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_jack_elites01) 1)) 1turret_jack_wraith02 "wraith-driver")
	
	(ai_set_orders 1turret_jack_elites01 1turret_jack_elites_attack)
	
	(wake allied_reinforcements);wake

)

(script dormant 1turret_jack_elites02

	(sleep_until (volume_test_objects 1turret_jack_activate03 (players)))
	
	(if 1turret_jack_elites (sleep 32000))
	(set 1turret_jack_elites true)
	
	(ai_place 1turret_jack_elites01)

	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_jack_elites01) 0)) 1turret_jack_wraith01 "wraith-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_jack_elites01) 1)) 1turret_jack_wraith02 "wraith-driver")
	
	(ai_set_orders 1turret_jack_elites01 1turret_jack_elites_attack)
	
	(wake allied_reinforcements);wake

)

(script dormant 1turret_jack_elites01

	(sleep_until (volume_test_objects 1turret_jack (players)))
	
	(if 1turret_jack_elites (sleep 32000))
	(set 1turret_jack_elites true)
	
	(ai_place 1turret_jack_elites01)
	
	(ai_set_orders 1turret_jack_elites01 1turret_jack_elites_intro)
	
	(sleep_until 
		(or
			(volume_test_objects 1turret_jack_activate01 (players))
			(volume_test_objects 1turret_jack_activate02 (players))
			(volume_test_objects 1turret_jack_activate03 (players))
		)
	)

	
	
	(ai_set_orders 1turret_jack_elites01 1turret_jack_elites_attack)
	
	(wake allied_reinforcements);wake
)





	;Vvvvvvvvv------------ 1turret_middle -------------vvvvvvvvV
	
	
	


(script command_script cs_1turret_i_r
	
	(print "guys walk off cliff")
	
	(cs_move_in_direction 373 7 0)
)	


(script dormant 1turret_middle

	(print "1turret_middle")

	(sleep_until 
		(or
			(volume_test_objects 1turret_middle (players))
			(<= (ai_living_count 1turret_intro_v) 2)
		)
	)
	
	(print "1turret_middle_running")
	
	(ai_set_orders 1turret_begining_guys 1turret_1stguys_fallback)
	
	;(garbage_collect_unsafe)
	
	(object_create 1turret_dropship01)
	;(object_create 1turret_wraith03)
	
	(ai_place 1turret_tankelites02)

	(ai_set_orders 1turret_tankelites02 1turret_intro_t)
	
	(ai_place 1turret_ghostelites02)
	
	(ai_set_orders 1turret_ghostelites02 1turret_intro_g)
	
	(ai_place 1turret_turret_elites01)
	(ai_set_orders 1turret_turret_elites01 1turret_i_attack)
	
	;v---------1turretgrunts---------v
	
	(ai_place 1turret_end_grunts01)
	
	(ai_set_orders 1turret_end_grunts01 1turret_attack)

	;v---------1turret jackable wraiths---------v	

	;(object_create 1turret_jack_wraith01)
	(object_create 1turret_jack_wraith02)
	
	(wake 1turret_jack_elites03);wake
	(wake 1turret_jack_elites02);wake
	(wake 1turret_jack_elites01);wake
	
	(sleep_until (<= (ai_living_count 1turret_end_i) 3))
	
	(ai_place 1turret_i_r)

	(cs_run_command_script 1turret_i_r cs_1turret_i_r)

)

	

	;vvvvv-------IIII  1turret interior  IIII-----------vvvv
	
(script dormant 1turret_sniper

	(sleep_until (volume_test_objects 1turret_sniper_post (players)))

		(ai_place 1turret_sniper_post)
)	
	
	
(script dormant 1turret_interior_r

	(sleep_until
		(or
			(volume_test_objects 1turret_interior_r (players))
			(<= (ai_living_count 1turret_interior_back) 3)
		)
	)
	
	(ai_place 1turret_interior_r)
)	

	

(script dormant 1turret_interior_back
	
	(sleep_until 
		(or
			(volume_test_objects 1turret_interior_low_ent (players))
			(volume_test_objects 1turret_interior_center_ent (players))
		)
	)
	
	(if G_1turret_interior_back (sleep 32000))
	(set G_1turret_interior_back true)
	
	(ai_place 1turret_interior_back)
	
	(ai_set_orders 1turret_interior_low 1turret_interior_back_attack)
	
	(wake 1turret_interior_r);wake

)

(script dormant 1turret_interior_back_rear
	
	(sleep_until (volume_test_objects 1turret_interior_rear_ent (players)))
	
	(if G_1turret_interior_back (sleep 32000))
	(set G_1turret_interior_back true)
	
	(ai_place 1turret_interior_back)
	
	(ai_set_orders 1turret_interior_low 1turret_interior_back_attack)
	
	(wake 1turret_sniper);wake

)

	;vvvvvvvv------ 1turret interior low ------------vvvvvvvvv

(script dormant 1turret_interior_low
	
	(sleep_until (volume_test_objects 1turret_interior_low_ent (players)))
	
	(if G_1turret_interior (sleep 32000))
	(set G_1turret_interior true)
	
	(wake 1turret_sniper);wake
	
	(ai_place 1turret_interior_low)
	
	(ai_set_orders 1turret_interior_low 1turret_interior_low_attack)
	
	(ai_place 1turret_interior_low_g)
	
	(ai_set_orders 1turret_interior_low_g 1turret_interior_low_retreat)
	
	(sleep_until (volume_test_objects 1turret_interior_save (players)))
	
	(game_save_unsafe);SSSAAAVVVEEE---
)

(script dormant 1turret_interior_center
	
	(sleep_until (volume_test_objects 1turret_interior_center_ent (players)))
	
	(if G_1turret_interior (sleep 32000))
	(set G_1turret_interior true)
	
	(wake 1turret_sniper);wake
	
	(ai_place 1turret_interior_low)
	
	(ai_set_orders 1turret_interior_low 1turret_interior_cntr_attack)
	
	(ai_place 1turret_interior_low_g)
	
	(ai_set_orders 1turret_interior_low_g 1turret_interior_cntr_retreat)
	
	(sleep_until (volume_test_objects 1turret_interior_save (players)))
	
	(game_save_unsafe);SSSAAAVVVEEE---

)
	;v---------1turret wraiths behind---------v
	
(script dormant 1turret_wraiths_behind

	(sleep_until 
		(and
			(<= (ai_living_count view_tankelites01) 0)
			(volume_test_objects 1turret_intro (players))
		)
	)
	
		;(object_create 1turret_wraith_behind01)
		;(object_create 1turret_wraith_behind02)
		
		;(ai_place 1turret_wraith_behind)
		
		;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_wraith_behind) 0)) 1turret_wraith_behind01 "wraith-driver")
		;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_wraith_behind) 1)) 1turret_wraith_behind02 "wraith-driver")		
)


(script command_script cs_1turret_hdropship01

	(cs_vehicle_speed .3)

	(cs_fly_to_and_face 1turret_hdropship01/p0 1turret_hdropship01/p1 4)
	(cs_fly_to_and_face 1turret_hdropship01/p1 1turret_hdropship01/p2 4)
	(cs_fly_to 1turret_hdropship01/p2 4)
	(cs_fly_to_and_face 1turret_hdropship01/p3 1turret_hdropship01/p5 4)
	(cs_fly_by 1turret_hdropship01/p4 4)
	(cs_fly_by 1turret_hdropship01/p5 4)
	(cs_fly_by 1turret_hdropship01/p6 4)
	(cs_fly_by 1turret_hdropship01/p7 4)
	(cs_fly_by 1turret_hdropship01/p8 4)
	(cs_fly_to_and_face 1turret_hdropship01/p9 1turret_hdropship01/p0 4)
)

(script continuous 1turret_hdropship01_loop

	(print "continuous running")
	
	(sleep_until 
		(not 
			(cs_command_script_running 1turret_hdropship01 cs_1turret_hdropship01)
		)
	)
	
	(print "script running")
	
	(cs_run_command_script 1turret_hdropship01 cs_1turret_hdropship01)
)	

(script static void dtest07

	(ai_erase 1turret_hdropship01)
	
	(sleep 10)
	
	(ai_place 1turret_hdropship01)
	
	(wake 1turret_hdropship01_loop);wake
	
	(sleep_until 
		(or
			(volume_test_objects runandgun02_up01 (players))
			(volume_test_objects runandgun02_low (players))
		)
	)
	
	(sleep_forever 1turret_hdropship01_loop)
	(object_destroy (ai_vehicle_get 1turret_hdropship01/1))
)

(script dormant 1turret_hdropship01

	(ai_erase 1turret_hdropship01)
	
	(sleep 10)
	
	(ai_place 1turret_hdropship01)
	
	(wake 1turret_hdropship01_loop);wake
	
	(sleep_until 
		(or
			(volume_test_objects runandgun02_up01 (players))
			(volume_test_objects runandgun02_low (players))
		)
	)
	
	(sleep_forever 1turret_hdropship01_loop)
	(object_destroy (ai_vehicle_get 1turret_hdropship01/1))
)

(script dormant 1turret_hbanshee
	
	(sleep_until (<= (ai_living_count view_hbanshees) 0))
	
	(if G_1turret_hbanshee (sleep 32000))
	(set G_1turret_hbanshee true)
	
	(ai_place 1turret_hbanshee)	
)

(script dormant 1turret_hbanshee_alt
	
	(sleep_until (volume_test_objects 1turret_turret_wake (players)))
	
	(if G_1turret_hbanshee (sleep 32000))
	(set G_1turret_hbanshee true)
	
	;(wake runandgun02_2banshees);wake
)

(script command_script cs_1turret_ghostelites01s2

	(cs_go_to 1turret_ghostelites01s2/p0 1)
	(cs_go_to 1turret_ghostelites01s2/p1 )
)


(script command_script cs_1turret_ghostelites01s1

	(cs_go_to 1turret_ghostelites01s1/p0 1)
	(cs_go_to 1turret_ghostelites01s1/p1 1)
	(cs_go_to 1turret_ghostelites01s1/p2 )
)	

(script static void dtest30
	
	(ai_erase 1turret_ghostelites01)
	
	(sleep 10)
	
	(ai_place 1turret_ghostelites01)

	(cs_run_command_script 1turret_ghostelites01/s1 cs_1turret_ghostelites01s1)
	(cs_run_command_script 1turret_ghostelites01/s2 cs_1turret_ghostelites01s2)

)

(script dormant 1turret_ghostelites01

	(ai_place 1turret_ghostelites01)

	(cs_run_command_script 1turret_ghostelites01/s1 cs_1turret_ghostelites01s1)
	(cs_run_command_script 1turret_ghostelites01/s2 cs_1turret_ghostelites01s2)
)

;v---------1turret intro---------v

(script dormant 1turret_intro
	
	(sleep_until (volume_test_objects 1turret_intro (players)))
	
	(print "tyson EYES!!!")
	(game_save_unsafe);SSSAAAVVVEEE---
	(wake 1turret_wraiths_behind)
	
	(ai_erase runandgun01_i_grunts02);!!!!ai_kill!!!!

;v---------1turret intro grunt turrets---------v

	;(object_create 1turret_turret03)
	;(object_create 1turret_turret04)
	
	(ai_place 1turret_turretgrunts01)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_turretgrunts01) 0)) 1turret_turret03 "gt_gunner")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_turretgrunts01) 1)) 1turret_turret04 "gt_gunner")
	
	(ai_set_orders 1turret_turretgrunts01 1turret_attack)

	;v---------1turret intro tanks---------v

	;(object_create 1turret_wraith01)
	;(object_create 1turret_wraith02)
	;(object_create 1turret_wraith04)
	
	;(ai_place 1turret_tankelites01)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_tankelites01) 0)) 1turret_wraith01 "wraith-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_tankelites01) 1)) 1turret_wraith02 "wraith-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_tankelites01) 2)) 1turret_wraith04 "wraith-driver")
	
	;(ai_set_orders 1turret_tankelites01 1turret_intro_t)
	
	;----=====1turret intro shadows=========------V
	
	;(ai_place 1turret_shadows01)
	
	;(ai_set_orders 1turret_shadows01 1turret_intro_t)

	;v---------1turret intro ghosts---------v
	
	;(object_create 1turret_ghost01)
	;(object_create 1turret_ghost02)
	;(object_create 1turret_ghost05)
	;(object_create 1turret_ghost06)
	
	(wake 1turret_ghostelites01);wake
	
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_ghostelites01) 0)) 1turret_ghost01 "G-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_ghostelites01) 1)) 1turret_ghost02 "G-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_ghostelites01) 2)) 1turret_ghost05 "G-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors 1turret_ghostelites01) 3)) 1turret_ghost06 "G-driver")


	(ai_set_orders 1turret_ghostelites01 1turret_intro_g)
	
	(wake 1turret_middle);wake
	
	(wake 1turret_interior_back);wake
	(wake 1turret_interior_back_rear);wake
	
	(wake 1turret_interior_low) ;wake
	(wake 1turret_interior_center) ;wake
	
	(wake 1turret_hbanshee);wake
	(wake 1turret_hbanshee_alt);wake
)

	;vvvvvvvvvvvv---------------  1turret_fire   --------------vvvv

(script continuous 1turret_turret

	(sleep (random_range 20 55))
	
	;(effect_new "effects\test\stephen_beam" 1turret)
	;(effect_new "effects\retro_rockets" 1turret)
	;(sound_impulse_start "sound\temp\plasma grenade\plasmagrenexpl" 1turret 1)
	
	(if 
		(<= (unit_get_health 1turret)0) 
		(begin
			;(effect_new "effects\test\stephen_explosion" 1turret_explosion)
			
			(sound_impulse_start "sound\dialog\alphamoon\level\l05_0540_el1" none 1)
			
			(sleep_forever) 
		)
	)
)

(script dormant 1turret_dialog_onfoot

	(sleep_until (volume_test_objects 1turret_interior_rear_ent (players))15)

	(if G_1turret_turret_dialog (sleep_forever))
	(set G_1turret_turret_dialog true)
	
	(print "--- Allies: You’ve found the turret's weakness!!")
	
	(sleep 55)

	(print "--- Allies: Assualting that turret with the vehicles would have been disaterous")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0550_el2" none 1)

)

(script dormant 1turret_dialog_vehicles

	(sleep_until (volume_test_objects 1turret_turret_wake (players))15)

	(if G_1turret_turret_dialog (sleep_forever))
	(set G_1turret_turret_dialog true)
	
	(print "--- Allies: that turret is too powerful!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0520_el1" none 1)
	
	(sleep 45)
	
	(print "--- Allies: pull back and see if theres another way to destroy it!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0530_el1" none 1)

)

(script dormant 1turret_turret_wake
	
	(sleep_until 
		(or
			(volume_test_objects 1turret_turret_wake (players))
			(volume_test_objects 1turret_interior_rear_ent (players))
		)
	15)
	
	(wake 1turret_turret);wake
)

(script dormant a_1turret_reinforce
	
	(sleep_until (volume_test_objects 1turret_intro (players))15)

	(ai_place a_1turret_ghosts)
	(ai_place a_1turret_wraiths)
	
)

(script dormant a_1turret_v_moveup

	(sleep_until (volume_test_objects a_1turret_v_attack_b (players))15)
	
	(if G_a_1turret_v_attack_b (sleep_forever))
	(set G_a_1turret_v_attack_b true)
	
	(ai_set_orders a_1turret_wraiths a_1turret_v_mid_adv)
	(ai_set_orders a_1turret_ghosts a_1turret_v_mid_adv)
	
	(if 
		(> (unit_get_health 1turret)0)  
		(begin
			(sleep 150)
			(ai_set_orders a_1turret_wraiths a_1turret_w_fback)
			(ai_set_orders a_1turret_ghosts a_1turret_g_back)
		)
		
		(begin
			(sleep 120)
			(ai_set_orders a_1turret_ghosts a_1turret_g_front)
		)
	)
)

(script dormant a_1turret_v_moveup_alt

	(sleep_until (volume_test_objects 1turret_interior_low_retreat (players))15)
	
	(if G_a_1turret_v_attack_b (sleep_forever))
	(set G_a_1turret_v_attack_b true)

	(sleep_until (<= (unit_get_health 1turret)0))

	(ai_set_orders a_1turret_ghosts a_1turret_g_front)
	(ai_set_orders a_1turret_wraiths a_1turret_w_fback)
)




;vvvvv-----clean up 01------------------------------vvvvv

(script dormant clean_up01

	(object_destroy_containing "runandgun01_interior_debris")
)

;vvvvvvvvvvvv------------------  VIEW!!!   ---------------------------------------------------vvvvvv
;vvvvvvvvvvvv------------------  VIEW!!!   ---------------------------------------------------vvvvvv
;vvvvvvvvvvvv------------------  VIEW!!!   ---------------------------------------------------vvvvvv

(script dormant view_dialog

	(sleep_until (volume_test_objects view_dialog (players)))
	
	(print "--- Allies: whoa!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0480_el1" none 1)
	
	(sleep 40)
	
	(print "--- Allies: That wreckages is huge!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0490_el1" none 1)
	
	(sleep 60)
	
	(print "--- Allies: This moon has been devistated")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0500_el1" none 1)
	
	(sleep 90)
	
	(print "--- C.O.: That giant piece of wreackage must be where their stonghold is!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0510_soc" none 1)
	
)

	;view-dropships----------------vvv---------------------------

(script command_script cs_view_hdropship_near

	(cs_fly_to_and_face view_hdropship_near/p0 view_hdropship_near/p3)
	(cs_fly_to_and_face view_hdropship_near/p1 view_hdropship_near/p3)
	(cs_fly_to_and_face view_hdropship_near/p2 view_hdropship_near/p3)
	(cs_pause 32000)
)

(script static void dtest06
	
	(ai_erase view_hdropship_near)
	
	(sleep 10)
	
	(ai_place view_hdropship_near)
	
	(cs_run_command_script view_hdropship_near cs_view_hdropship_near)
	
	(sleep_until (volume_test_objects 1turret_middle (players)))
	(object_destroy (ai_vehicle_get view_hdropship_near/starting_locations_0))
)

(script dormant view_hdropship_near
	
	(ai_erase view_hdropship_near)
	
	(sleep 10)
	
	(ai_place view_hdropship_near)
	
	(cs_run_command_script view_hdropship_near cs_view_hdropship_near)
	
	(sleep_until (volume_test_objects 1turret_middle (players)))
	(object_destroy (ai_vehicle_get view_hdropship_near/starting_locations_0))
)


(script command_script cs_view_hdropship_far

	(cs_fly_by view_hdropship_far/p0)
	(cs_fly_by view_hdropship_far/p1)
	(cs_fly_by view_hdropship_far/p2)
	(cs_fly_to_and_face view_hdropship_far/p3 view_hdropship_far/p4)
	(cs_fly_to view_hdropship_far/p4)
	(cs_fly_to_and_face view_hdropship_far/p4 view_hdropship_far/p5)
	(cs_pause 32000)
)

(script static void dtest05
	
	(ai_erase view_hdropship_far)
	
	(sleep 10)
	
	(ai_place view_hdropship_far)
	
	(cs_run_command_script view_hdropship_far cs_view_hdropship_far)
	
	(sleep_until (volume_test_objects 1turret_middle (players)))
	(object_destroy (ai_vehicle_get view_hdropship_far/starting_locations_0))
)

(script dormant view_hdropship_far
	
	(ai_erase view_hdropship_far)
	
	(sleep 10)
	
	(ai_place view_hdropship_far)
	
	(cs_run_command_script view_hdropship_far cs_view_hdropship_far)
	
	(sleep_until (volume_test_objects 1turret_middle (players)))
	(object_destroy (ai_vehicle_get view_hdropship_far/starting_locations_0))
)

(script dormant view_shadow01
	
	;-(sleep_until (volume_test_objects view (players)))

	(ai_place view_shadow01)
	(ai_place view_shadow02)
)

(script dormant view

	(sleep_until (volume_test_objects view (players)))
	
	(wake view_shadow01);wake
	
	(wake view_dialog);wake
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	;(object_create_containing "1turret_debris")
	
	(object_create view_player_wraith01)
	
	;(object_create view_wraith02)
	
	(ai_place view_tankelites01)

	;(unit_enter_vehicle (unit (list_get (ai_actors view_tankelites01) 0)) view_wraith02 "wraith-driver")
	
	;(ai_set_orders view_tankelites01 view_wraith_intro)
	
	;vvvvvvvvvvvvv----------view ghost----------vvvvvvvvvvvvv
	
	(ai_place view_ghostelites01)
	
	(ai_set_orders view_ghostelites01 view_attack)
	
	(ai_place view_hbanshees)
	
	(wake 1turret_turret_wake);wake
	(wake clean_up01);wake
	
	(sleep 10)
	
	(wake view_hdropship_near);wake
	(wake view_hdropship_far);wake
	
	(wake 1turret_dialog_vehicles);wake
	(wake 1turret_dialog_onfoot);wake
	
	(sleep_until (volume_test_objects 1turret_attack (players)))
	
	(ai_set_orders view_v view_attack)
)

;(script dormant ai_kill_temp

;	(sleep_until (volume_test_objects ai_kill_temp (players)))
	
;	(print "ai_kill_temp")

;	(wake ai_kill01)
;	(wake ai_kill02)
;
;)



(script dormant view_i

	(sleep_until 
		(or
			(volume_test_objects runandgun01_ghostelites04 (players))
			(<= (ai_living_count runandgun01_ghostelites03) 1)
			(<= (ai_living_count runandgun01_t_grunts03) 1)
		)
	)
	
	(ai_place view_i_01)
	
	(ai_set_orders view_i_01 view_i_front)
	
	(sleep_until (volume_test_objects runandgun01_ghostelites04 (players)))
	
	(ai_set_orders view_i_01 view_i_back)
	
	(game_save_unsafe);SSSAAAVVVEEE---
)

;vvvvvvvvvvvv---------------    RUNANDGUN01   ----------------------------------------------------VVVVVVVV
;vvvvvvvvvvvv---------------    RUNANDGUN01   ----------------------------------------------------VVVVVVVV
;vvvvvvvvvvvv---------------    RUNANDGUN01   ----------------------------------------------------VVVVVVVV

(script dormant runandgun01_filler
;ln3539
	(sleep_until
		(and
			(volume_test_objects runandgun01_filler (players))
			(<= (ai_living_count runandgun01_ghostelites) 0)
			(<= (ai_living_count runandgun01_ghostelites02) 1)
			(<= (ai_living_count runandgun01_i01) 1)
		)
	)		
	
		(ai_place runandgun01_filler)		
)

(script dormant runandgun01_turret01

	;(object_create runandgun01_turret01)
	
	(ai_place runandgun01_turretgrunt01)

	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_turretgrunt01) 0)) runandgun01_turret01 "gt_gunner")
	
	(ai_set_orders runandgun01_turretgrunt01 runandgun01_ghost_attack)
	
	;v--------------runandgun flee grunts----------v

	(ai_place runandgun01_fleegrunts01)
	
	(ai_set_orders runandgun01_fleegrunts01 runandgun01_flee_g_defense)
)	

(script dormant runandgun01_elites04

	(sleep 30)

	(sleep_until 
		(or
			(volume_test_objects runandgun01_ghostelites04 (players))
			(<= (ai_living_count runandgun01_ghostelites03) 0)
			(<= (ai_living_count runandgun01_t_grunts03) 0)
		)
	)
	
	(print "runandgun ghostelites04")
	
	;(object_create runandgun01_ghost07)
	;(object_create runandgun01_ghost08)
	
	(ai_place runandgun01_ghostelites04)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites04) 0)) runandgun01_ghost07 "G-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites04) 1)) runandgun01_ghost08 "G-driver")

	(ai_set_orders runandgun01_ghostelites04 runandgun01_g03_intro)
	
	;(object_create_containing "view_debris");creates debris for view area
	
	(sleep_until (volume_test_objects view_dialog (players)))
	
	(ai_set_orders runandgun01_ghostelites03 view_attack)
	
	(ai_set_orders runandgun01_ghostelites04 view_attack)
)

(script dormant runandgun01_t_grunts_02

	(sleep_until (volume_test_objects runandgun01_elites03 (players)))
	
	(sleep 10)
	
	;(object_create runandgun01_t_grunt_t03)
	;(object_create runandgun01_t_grunt_t04)
	;(object_create runandgun01_t_grunt_t05)
	
	(ai_place runandgun01_t_grunts03)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_t_grunts03) 0)) runandgun01_t_grunt_t03 "gt_gunner")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_t_grunts03) 1)) runandgun01_t_grunt_t04 "gt_gunner")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_t_grunts03) 2)) runandgun01_t_grunt_t05 "gt_gunner")
	
	(ai_set_orders runandgun01_t_grunts03 runandgun01_ghost_attack)
	
	(wake runandgun01_elites04);wake
)

(script dormant  runandgun01_t_grunts_01

	;(object_create runandgun01_t_grunt_t01)
	;(object_create runandgun01_t_grunt_t02)
	
	(ai_place runandgun01_t_grunts02)

	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_t_grunts02) 0)) runandgun01_t_grunt_t01 "gt_gunner")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_t_grunts02) 1)) runandgun01_t_grunt_t02 "gt_gunner")
	
	(ai_set_orders runandgun01_t_grunts02 runandgun01_ghost_attack)
	
	(wake runandgun01_t_grunts_02);wake
)
	;v--v-v-v-v-v runandgun01 ghost elites03 --v-v-v-v-v-v---


(script dormant runandgun01_elites03
	
	(print "tyson eyes!!!")
	
	(garbage_collect_unsafe)
	
	(sleep_until 
		(or
			(volume_test_objects runandgun01_elites03 (players))
			(<= (ai_living_count runandgun01_ghostelites02) 0)
		)
	)

	;(object_create runandgun01_ghost05)
	;(object_create runandgun01_ghost06)
	
	(ai_place runandgun01_ghostelites03)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites03) 0)) runandgun01_ghost05 "G-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites03) 1)) runandgun01_ghost06 "G-driver")

	(ai_set_orders runandgun01_ghostelites03 runandgun01_g03_intro)
	
	(wake runandgun01_turret01);wake
	(wake ai_kill01);wake
	
	(sleep 10)
	
	(wake view_i);wake
)

	;:::::v:::::scripted runandgun01 allied dropship::::::::v:::::::::
	;:::::v:::::scripted runandgun01 allied dropship::::::::v:::::::::
	
(script dormant runandgun01_big_d_d

	(sleep 60)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0460_el2" none 1)

	(sleep 90)
	
	;(object_destroy_containing "runandgun01_big_debris")
	
	;(effect_new "effects\test\stephen_explosion" runandgun01_bigd_exp01)
	;(effect_new "effects\test\stephen_explosion" runandgun01_bigd_exp02)
)

(script command_script cs_runandgun_part2_dropship01

	(cs_vehicle_speed .4)

	;(cs_fly_by runandgun01_part2_dropship01/p0 4)
	(cs_fly_to runandgun01_part2_dropship01/p0_1 4)
	(cs_fly_to runandgun01_part2_dropship01/p1 4)
	(cs_fly_to runandgun01_part2_dropship01/p2 4)
	(cs_fly_to_and_face runandgun01_part2_dropship01/p3 runandgun01_part2_dropship01/p4 4)
	
	(print "blow up wall")

	(wake runandgun01_big_d_d);wake
	
	(cs_fly_by runandgun01_part2_dropship01/p4 4)
	(cs_vehicle_speed .7)
	(cs_fly_by runandgun01_part2_dropship01/p5 4)
	(cs_fly_by runandgun01_part2_dropship01/p6 4)
	;(cs_fly_by runandgun01_part2_dropship01/p7 4)
	
	(object_destroy (ai_vehicle_get runandgun01_part2_dropship01/1))
)

(script static void dtest
	
	(ai_erase runandgun01_part2_dropship01)
	
	(sleep 10)
	
	(ai_place runandgun01_part2_dropship01)

	(cs_run_command_script runandgun01_part2_dropship01 cs_runandgun_part2_dropship01)
)

(script dormant runandgun01_part2

	(sleep_until 
		(or
			(volume_test_objects runandgun01_elites03 (players))
			(<= (ai_living_count runandgun01_ghostelites) 0)
		)
	)
	
	;(object_destroy runandgun01_part2_dropship01)
	
	(ai_erase runandgun01_part2_dropship01)
	
	(sleep 10)
	
	;(object_create runandgun01_part2_dropship01)
	
	(ai_place runandgun01_part2_dropship01)

	;(vehicle_load_magic runandgun01_part2_dropship01 "p_driver" (ai_actors runandgun01_part2_dropship01))
	
	(cs_run_command_script runandgun01_part2_dropship01 cs_runandgun_part2_dropship01)
)

	;------------vv runandgun01 ghost elites vv--------------------

(script dormant runandgun01_elites02
	
	(sleep_until 
		(or
			(volume_test_objects runandgun01_elites02 (players))
			(<= (ai_living_count runandgun01_ghostelites) 0)
		)
	)
	
	(print "runandgun01_ghostelites02")
	
	;(object_create runandgun01_ghost03)
	;(object_create runandgun01_ghost04)
	
	(ai_place runandgun01_ghostelites02)

	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites02) 0)) runandgun01_ghost03 "G-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites02) 1)) runandgun01_ghost04 "G-driver")
	
	(ai_set_orders runandgun01_ghostelites02 runandgun01_g_attack_1st)
	
	(wake runandgun01_elites03);wake
	
	(wake runandgun01_part2);wake
	
	;(wake view);wake
	
)

(script dormant allies02

	(ai_set_orders allied_wraith01 allied_w_runandgun01)
	(ai_set_orders allied_ghost01_02 allied_g_runandgun01)

)

(script dormant allies_ghost_warning

	(sleep 90)
	
	(print "--- Allies: Watch out for those ghosts!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0440_el1" none 1)
	
	(sleep 45)
	
	(print "--- Allies: Enemy vehicls incoming!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0450_el1" none 1)
 
)


(script dormant runandgun01_ghostelites01

	(sleep_until (volume_test_objects runandgun01_ghostelites01 (players))15)
	
	(wake allies_ghost_warning);wake
	
	(wake allies02);wake
	
	;(wake ai_kill_temp);wake

	(print "runandgun01_ghostelites01")

	;(object_create runandgun01_ghost01)
	;(object_create runandgun01_ghost02)
	
	(ai_place runandgun01_ghostelites)

	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites) 0)) runandgun01_ghost01 "G-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors runandgun01_ghostelites) 1)) runandgun01_ghost02 "G-driver")

	(ai_set_orders runandgun01_ghostelites runandgun01_g_attack_1st)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake runandgun01_elites02);wake
	
	(sleep 10)
	
	(wake runandgun01_t_grunts_01);wake
	
	(wake runandgun01_filler);wake3247
	
	
	
)

(script dormant runandgun01
	
	
	;(vehicle_load_magic runandgun01_ghost01 "g-driver" (ai_actors runandgun01_ghostelites))
	
	(print "runandgun_i")
	
	(ai_place runandgun01_i_elites01)
	(ai_place runandgun01_i_grunts01)
	
	(ai_set_orders runandgun01_i_elites01 runandgun01_i_attack01)
	(ai_set_orders runandgun01_i_grunts01 runandgun01_i_attack01)
	
	(ai_place runandgun01_i_elites02)
	(ai_place runandgun01_i_grunts02)
	
	(ai_set_orders runandgun01_i_elites02 runandgun01_i_attack02)
	(ai_set_orders runandgun01_i_grunts02 runandgun01_i_attack02)
			
	(wake runandgun01_ghostelites01);wake
	;(wake runandgun01_filler);wake
	
	(sleep_until (volume_test_objects runandgun01_interior (players))15)
	
	(ai_place runandgun01_interior)
	
	(ai_set_orders runandgun01_i_elites02 runandgun01_i_defend02)
	
	
	(sleep_until (<= (ai_living_count runandgun01_interior) 0))
	

	(ai_place runandgun01_interior02)
	
)

;vvvvvvvvvvv------TRAP01--------------------------------------------------------------vvvvvvvvvvvvv
;vvvvvvvvvvv------TRAP01--------------------------------------------------------------vvvvvvvvvvvvv
;vvvvvvvvvvv------TRAP01--------------------------------------------------------------vvvvvvvvvvvvv


	;vvvvv----- trap01 counter ---------vvvvvvv
	
(script dormant trap01_counter_dialog

	(sleep_until (volume_test_objects trap01_counter (players))15)

	(if G_trap01_dialog (sleep_forever))
	(set G_trap01_dialog true)

	(print "--- Allies: we're lucky you saw that trap")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0380_el1" none 1)
	
	(sleep 50)
	
	(print "--- Allies: we almost went into that trap")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0390_el2" none 1)
	
	(sleep 90)
	
	(print "--- C.O.: heretics are dishonorable and will use deception in combat")

	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0400_soc" none 1)

	(sleep 90)

	(print "--- C.O.: becareful of more traps")

	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0410_soc" none 1)
)

	;vvvvv------ trap01 spring------vvvvv

(script dormant trap01_spring_dialog

	(if G_trap01_dialog (sleep_forever))
	(set G_trap01_dialog true)
	
	(print "--- Allies: A TRAP!!!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0350_el1" none 1)
	
	(sleep 30)
	
	(print "--- Allies: damn they are all around us!!!!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0360_el1" none 1)
	
	(sleep 39)
	
	(print "--- Allies: those sneeky bastards!!!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0370_el1" none 1)
	
	(sleep 90)
	
	(print "--- C.O.: heretics are dishonorable and will use deception in combat")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0400_soc" none 1)

	(sleep 90)

	(print "--- C.O.: becareful of more traps")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0410_soc" none 1)
)

(script command_script cs_trap01_r
	
	(object_cannot_take_damage (ai_actors trap01_r))
	
	(cs_move_in_direction 0 8 0)
	
	(sleep 20)
	
	(object_can_take_damage (ai_actors trap01_r))
	
	(print "guys walk off cliff")
)	

(script static void testrr
	
	(ai_erase trap01_r)
	
	(sleep 10)


	(ai_place trap01_r)
	
	(cs_run_command_script trap01_r cs_trap01_r)

)


(script dormant trap01_r

	(print "trap01_r_wake")
	
	(sleep_until 
		(and
			(volume_test_objects trap01_center_retreat (players))
			(<= (ai_living_count trap01_grunts) 0)
		)
	)
		
	(ai_place trap01_r)
	
	(cs_run_command_script trap01_r cs_trap01_r)

)

(script command_script cs_trap01_low
	
	(cs_move_in_direction 127 3 0)
	
	(sleep 20)
	
	(print "guys walk off cliff")
)


(script dormant trap01_low
	
	(ai_place trap01_low)
	
	(object_cannot_take_damage (ai_actors trap01_low))
	
	(sleep 6)
	
	(object_can_take_damage (ai_actors trap01_low))
	
	(sleep_until (volume_test_objects runandgun01_ghostelites01 (players)))
	
	(cs_run_command_script trap01_low cs_trap01_low)
	
	(ai_set_orders trap01_low trap01_retreat_grunts)

)

(script dormant trap01_bait
	 
	(sleep_until (volume_test_objects trap01_bait (players))15)

	(ai_place trap01_bait)
)

(script dormant trap01

	(wake trap01_bait);wake
	
	(sleep_until (volume_test_objects runandgun01 (players))15)
	
	(ai_erase 3turrets)
	(garbage_collect_unsafe)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake trap01_counter_dialog);wake
	
	(wake runandgun01);wake
	
	(ai_place trap01_grunts)
	(ai_set_orders trap01_grunts trap01_intro_grunts)
	(ai_place trap01_grunts02)
	
	(sleep 10)
	
	(ai_place trap01_turret_grunts)
	
	(ai_set_orders trap01_turret_grunts trap01_intro_grunts)
	
	(wake trap01_r);wake
	
	(sleep_until (volume_test_objects trap01_spring (players))15)
	
	(object_create_containing "trap01_block")
	
	(object_create_containing "trap01_havok")
	
	(wake trap01_low);wake
	
	(object_destroy trap01_edebris01)
	(object_destroy trap01_edebris02)
	(object_destroy trap01_edebris03)
	(object_destroy trap01_edebris04)
	(object_destroy trap01_edebris05)
	
	(wake trap01_spring_dialog);wake
	
	(ai_set_orders trap01_grunts trap01_attack_grunts)
	
	;(sleep_until (<= (ai_living_count trap01_grunts) 4))
	
	;(object_destroy trap01_block01)

	;(object_destroy trap01_block02)
	
	;(object_destroy trap01_block06)
	
	;(object_create_containing "runandgun01_b_debris")
	
	(sleep 10)
	
	(object_create_containing "runandgun01_interior_debris")
	
	(sleep 30)
	
	(object_create_containing "runandgun01_big_debris")
	
)

(script dormant pretrap_debris_destroy

		(sleep_until (volume_test_objects pretrap_debris_destroy (players))15)

		(object_destroy_containing "pretrap_debris")
)

;vvvvvvvvvvv------allied vehicles----------vvvvvvvvvvvvv

(script dormant allies
	
	(sleep_until (<= (ai_living_count 3turrets) 0))
	
	
	
	
	;(object_create allied_wraith01)
	
	;(unit_enter_vehicle (unit (list_get (ai_actors allied_wraith01) 0)) allied_wraith01 "wraith-driver")
	
	;(unit_enter_vehicle (unit (list_get (ai_actors allied_ghost01_02) 0)) allied_ghost01 "g-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors allied_ghost01_02) 1)) allied_ghost02 "g-driver")
	
	;(ai_set_orders allied_wraith01 allied_v)
	;(ai_set_orders allied_ghost01_02 allied_v)
)

(script dormant save01
	
	(print "save01")
	(sleep_until (<= (ai_living_count turret_left_elites) 0))
	(game_save_unsafe)

)

(script command_script cs_lz01_a_dropship04

	(cs_vehicle_speed .4)

	(cs_fly_to lz01_a_dropship04/p0 3)
	(cs_fly_to lz01_a_dropship04/p1 3)
	(cs_fly_to lz01_a_dropship04/p2 3)
)

(script static void dtest04

	(ai_erase lz01_a_dropship04)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship04)
	
	(cs_run_command_script lz01_a_dropship04 cs_lz01_a_dropship04)
)

(script dormant lz01_a_dropship04

	(sleep 60)
	
	(ai_erase lz01_a_dropship04)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship04)
	
	(cs_run_command_script lz01_a_dropship04 cs_lz01_a_dropship04)
)

	;v======--- allied dropship 03 ---======v
	
(script dormant lz01_a_dropship03_cnts

	(sleep 60)
	
	;(ai_place allied_wraith01)
	
	(vehicle_unload (ai_vehicle_get lz01_a_dropship03/starting_locations_0) "phantom_lc")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0290_el2" none 1)
	
	(sleep 90)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0270_el2" none 1)
)

(script command_script cs_lz01_a_dropship03

	(cs_vehicle_speed .4)

	(cs_fly_to_and_face lz01_a_dropship03/p0 lz01_a_dropship03/p4 3)
	(cs_fly_to_and_face lz01_a_dropship03/p1 lz01_a_dropship03/p4 3)
	(cs_fly_to_and_face lz01_a_dropship03/p2 lz01_a_dropship03/p4 3)
	(cs_fly_to_and_face lz01_a_dropship03/p3 lz01_a_dropship03/p4 1)
	
	(wake lz01_a_dropship03_cnts);wake
	
	(cs_pause 32000)
)

(script static void dtest03

	
	(ai_erase lz01_a_dropship03)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship03)
	;(ai_place_in_vehicle allied_wraith01 lz01_a_dropship03)
	
	(cs_run_command_script lz01_a_dropship03 cs_lz01_a_dropship03)
)


(script dormant lz01_a_dropship03

	(sleep 150)
	
	(ai_erase lz01_a_dropship03)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship03)
	;(ai_place_in_vehicle allied_wraith01 lz01_a_dropship03)
	
	(cs_run_command_script lz01_a_dropship03 cs_lz01_a_dropship03)
)
	;v======--- allied dropship 02 ---======v
	
(script dormant lz01_a_dropship02_cnts

	(sleep 30)
	
	(vehicle_unload (ai_vehicle_get lz01_a_dropship02/starting_locations_0) "phantom_lc")
	;(vehicle_unload (ai_vehicle_get lz01_a_dropship02/starting_locations_0) "phantom_sc_2")
	(ai_place allied_ghost01_02)
	(object_cannot_take_damage (ai_actors allied_ghost01_02))
	
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0260_el1" none 1)
)

(script command_script cs_lz01_a_dropship02

	(cs_vehicle_speed .4)

	(cs_fly_to_and_face lz01_a_dropship02/p0 lz01_a_dropship02/p4 3)
	(cs_fly_to_and_face lz01_a_dropship02/p1 lz01_a_dropship02/p4 3)
	(cs_fly_to_and_face lz01_a_dropship02/p2 lz01_a_dropship02/p4 3)
	(cs_fly_to_and_face lz01_a_dropship02/p3 lz01_a_dropship02/p4 1)
	
	(vehicle_unload (ai_vehicle_get lz01_a_dropship02/starting_locations_0) "phantom_lc")
	;(vehicle_unload (ai_vehicle_get lz01_a_dropship02/starting_locations_0) "phantom_sc_2")
	
	(wake lz01_a_dropship02_cnts);wake
	
	(cs_pause 32000)
)

(script static void dtest02_2
	(sleep 60)
	
	(ai_erase lz01_a_dropship02)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship02)
	;(ai_place_in_vehicle allied_ghost01_02 lz01_a_dropship02)
	
	(cs_run_command_script lz01_a_dropship02 cs_lz01_a_dropship02)
)

(script dormant lz01_a_dropship02

	(sleep 60)
	
	(ai_erase lz01_a_dropship02)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship02)
	(ai_place_in_vehicle allied_ghost01_02/starting_locations_0 lz01_a_dropship02)
	(ai_place_in_vehicle allied_ghost01_02/starting_locations_1 lz01_a_dropship02)
	
	(cs_run_command_script lz01_a_dropship02 cs_lz01_a_dropship02)
)

	;v======--- allied dropship 01 ---======v
	
(script dormant lz01_a_dropship01_cnts
	
	(sleep 5)
	
	(object_create player_wraith01)
	
	(sleep 90)
	
	(sleep 120)
	
	(object_create_containing "lz_allied_storage")
)

(script command_script cs_lz01_a_dropship01

	(cs_vehicle_speed .5)

	(cs_fly_to_and_face lz01_a_dropship01/p0 lz01_a_dropship01/p4 3)
	(cs_fly_to_and_face lz01_a_dropship01/p1 lz01_a_dropship01/p4 3)
	(cs_fly_to_and_face lz01_a_dropship01/p2 lz01_a_dropship01/p4 3)
	(cs_fly_to_and_face lz01_a_dropship01/p3 lz01_a_dropship01/p4 1)
	
	(wake lz01_a_dropship01_cnts);wake
	
	;(ai_place lz01_allied_grunts01)
	;(ai_exit_vehicle lz01_allied_grunts01)
	
	(cs_pause 32000)
)

(script static void dtest02
	
	(ai_erase lz01_a_dropship01)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship01)
	
	(ai_place_in_vehicle lz01_allied_grunts01 lz01_a_dropship01)
	
	(cs_run_command_script lz01_a_dropship01 cs_lz01_a_dropship01)
)


(script dormant lz01_a_dropship01
	
	(ai_erase lz01_a_dropship01)
	
	(sleep 10)
	
	(ai_place lz01_a_dropship01)
	
	(ai_place_in_vehicle lz01_allied_grunts01 lz01_a_dropship01)
	
	(cs_run_command_script lz01_a_dropship01 cs_lz01_a_dropship01)
)

(script dormant allied_orders01

	(sleep_until (volume_test_objects allies_moveto_runandgun01 (players))15)
	
	(ai_set_orders allied_wraith01 a_runandgun01_w_front)
	(ai_set_orders allied_ghost01_02 a_runandgun01_g_front)
	
	(sleep_until (volume_test_objects runandgun01_elites03 (players))15)
	
	(ai_set_orders allied_wraith01 a_runandgun01_w_back)
	;(ai_set_orders allied_ghost01_02 a_runandgun01_g_front)
	
	(sleep_until (volume_test_objects 1turret_intro (players))15)
	
	(ai_migrate allied_wraith01 a_1turret_wraiths)
	(ai_migrate allied_ghost01_02 a_1turret_ghosts)

)

(script dormant vehicle_spawn01

	(sleep_until
		(and 
			(<= (unit_get_health turret01)0)
			(<= (unit_get_health turret_right)0)
			(<= (unit_get_health turret_left)0)
		)
	)
	
	;(sleep_until (volume_test_objects 3turret_allied_vehicle_spawn (players))15 300)
	
	;(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake pretrap_debris_destroy);wake
	
	(wake lz01_a_dropship01);wake
	
	(sleep 30)
	
	(wake lz01_a_dropship02);wake
	
	(sleep 30)
	
	(wake lz01_a_dropship03);wake
	
	(sleep 10)
	
	(wake lz01_a_dropship04);wake
	
	(wake allied_orders01);wake
)







	;vvvv-----  destroyable_cover_demo_dialog  -----vvvv

(script dormant destroyable_cover_demo_dialog

	(sleep_until (volume_test_objects destroyable_cover_demo (players))15)
	
	(print "--- Allies: take out that debris blocking the way")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0320_el1" none 1)

	(sleep 65)
	
	(wake music_5)
	
	(sleep 30)
	
	(print "--- Allies: we can destroy this debris with our heavy weapons")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0330_el1" none 1)
	
	(sleep 55)
	
	(print "--- Allies: use the Wrait to destroy  wreckage")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0340_el2" none 1)
	
)

(script dormant lz_secure_dialog01

	(sleep_until (volume_test_objects lz_secure_trigger01 (players))15)
		
	(print "--- C.O.:  We've established a secure L.Z.")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0300_soc" none 1)
	
	(sleep 60)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0310_soc" none 1)
	
	(print "--- C.O.:  Time to take out the heritic base")

)

	;vvvvvvvv----  Turret_right Turret_left Dialog   ------vvvvvv

(script dormant destroy_last_turret_dialog

	(print "destroy_last_turret_dialog running")
	
	(sleep_until
		(or
		
			(and
				;(> (unit_get_health turret01)1)
				(<= (unit_get_health turret_right)0)
				(<= (unit_get_health turret_left)0)
			)
			
			(and
				(<= (unit_get_health turret01)0)
				;(> (unit_get_health turret_right)1)
				(<= (unit_get_health turret_left)0)
			)
			
			(and
				(<= (unit_get_health turret01)0)
				(<= (unit_get_health turret_right)0)
				;(> (unit_get_health turret_left)1)
			)
		)
	)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(sleep 30)
	
	(print "--- C.O.:  One turret left.")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0180_soc" none 1)
	
	(sleep 60)
	
	(print "--- C.O.:  Hurry, Dervish!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0190_soc" none 1)

)

(script dormant lz_r

	(ai_place lz_back)
	(ai_place lz_front)

)

(script dormant last_turret_destroyed_dialog

	(print "last_turret_destroyed_dialog running")

	(sleep_until
		(and 
			(<= (unit_get_health turret01)0)
			(<= (unit_get_health turret_right)0)
			(<= (unit_get_health turret_left)0)
		)
	)
	
	(wake lz_r);wake
	
	(game_save_unsafe);SSSAAAVVVEEE---

	(sleep 30)
	
	(print "--- C.O.:  At LAST!!!.")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0200_soc" none 1)
	
	(sleep 60)
	
	(print "--- Tartarus:  All warriors, descend! The path is clear!")
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0210_soc" none 1)
	
	(sleep 75)
	
	(wake destroyable_cover_demo_dialog);wake
	
	(wake vehicle_spawn01);wake
	
	(wake lz_secure_dialog01);wake
	
	(wake music_4);wake

)

(script dormant lz_middle_l 
;ln4451
	(sleep_until 
		(or
			(volume_test_objects turret_left_middle01 (players))
			(volume_test_objects turret_left_middle02 (players))
		)	
	15)

	(if G_lz_middle (sleep 32000))
	(set G_lz_middle true)

	(ai_place lz_middle_l)
	
	(sleep_until (<= (ai_living_count lz_middle_l) 1))
	
	(sleep_until 
		(or 
			(<= (unit_get_health turret_right) 0)
			(<= (unit_get_health turret_left) 0)
		)
	)
	
	(if (<= (unit_get_health turret_right) 0) 
		(begin	
			(ai_set_orders lz_middle_l turret_left_front04)
		)
		
		(begin
			(ai_set_orders lz_middle_l turret_right_front04)
		)
	)
	
	(sleep_until 
		(and 
			(<= (unit_get_health turret_right) 0)
			(<= (unit_get_health turret_left) 0)
		)
	)
	
		(ai_set_orders lz_middle_l lz_front_right)
	
)

(script dormant lz_middle_r
;ln4452
	(sleep_until (volume_test_objects Turret_right_middle (players))15)

	(if G_lz_middle (sleep 32000))
	(set G_lz_middle true)

	(ai_place lz_middle_r)
	
	(sleep_until 
		(or 
			(<= (unit_get_health turret_right) 0)
			(<= (unit_get_health turret_left) 0)
		)
	)
	
	(if (<= (unit_get_health turret_left) 0) 
		(begin	
			(ai_set_orders lz_middle_r turret_right_front04)
		)
		
		(begin
			(ai_set_orders lz_middle_r turret_left_front04)
		)
	)
	
	(sleep_until 
		(and 
			(<= (unit_get_health turret_right) 0)
			(<= (unit_get_health turret_left) 0)
		)
	)
	
		(ai_set_orders lz_middle_r lz_front_left)
)


;vvvvvvv ------------- turret left/right move ------------------vvvvvvvvvvvv
	; (when a turret dies the troops defending that turret will 
	;            migrate to the other turret)



(script dormant turret_right_2_left	
	
	(sleep_until 
		(and
			(<= (unit_get_health turret_right) 0)
			(> (unit_get_health turret_left) 0)
		)
	)
	
		(if G_turret_left_right_move (sleep 32000))
		(set G_turret_left_right_move true)
		
		(ai_set_orders turret_right turret_left_attack)
		
)

(script dormant turret_left_2_right
	
	(sleep_until 
		(and
			(> (unit_get_health turret_right) 0)
			(<= (unit_get_health turret_left) 0)
		)
	)
	
		(if G_turret_left_right_move (sleep 32000))
		(set G_turret_left_right_move true)
		
		(ai_set_orders turret_left turret_right_attack)
		
)

;END__SEGMENT THING vvvvvvvvvvvvvvVVVVVVVVV

(script dormant g_end_segment01

          (sleep_until 
           		 (volume_test_objects turret_right_end (players))
          )
		
		
		(game_save_unsafe);SSSAAAVVVEEE---
          
          ;(end_segment)
            
          ;(print "paul sux")
)





;VVVVVVVVVVVVVVVVVV-----------TURRET_RIGHT-----------------------------------VVVVVVVVVVVVVV
;VVVVVVVVVVVVVVVVVV-----------TURRET_RIGHT-----------------------------------VVVVVVVVVVVVVV
;VVVVVVVVVVVVVVVVVV-----------TURRET_RIGHT-----------------------------------VVVVVVVVVVVVVV

(script dormant turret_right_r01

	(sleep_until (<= (ai_living_count turret_right) 2))
	
	(ai_place turret_right_r01)
	
	(sleep_until (<= (unit_get_health turret_right) 0))
	
	(sleep_until (volume_test_objects Turret_right_middle (players))15)
	
	(if (<= (unit_get_health turret_left) 0) 
		(begin	
			(ai_set_orders turret_right_r01 lz_front_right)
		)
		
		(begin
			(ai_set_orders turret_right_r01 lz_front_left)
		)
	)
)

(script dormant turret_right
	
	(print "turret_right wake")
	(sleep_until (volume_test_objects turret_right (players))15)
	(print "turret_right running")
	
	(if G_turret_right (sleep 32000))
	(set G_turret_right true)
	
	(ai_place turret_right_elites01)
	(ai_place turret_right_grunts01)
	
	(object_create turret_right_ap_turret01)
	
	(ai_vehicle_enter_immediate turret_right_grunts01/starting_locations_0 turret_right_ap_turret01 "c_turret_ap_d")
	
	(wake turret_right_r01);wake
	
	;(wake allies)
)

	;vvvvvv-----TURRET_RIGHT SPAWN if between turrets triggered---v

(script dormant turret_right_middle
	
	(print "turret_right_middle wake")
	(sleep_until (volume_test_objects turret_right_middle (players))15)
	(print "turret_right_middle running")
	
	(if G_turret_right (sleep 32000))
	(set G_turret_right true)
	
	(ai_place turret_right_elites01)
	(ai_place turret_right_grunts01)
	
	(object_create turret_right_ap_turret01)
	
	(ai_vehicle_enter_immediate turret_right_grunts01/starting_locations_0 turret_right_ap_turret01 "c_turret_ap_d")
	
	(wake turret_right_r01);wake
	
)

	;vvvvvv-----TURRET_RIGHT02 SPAWN if all guys in turret01 are dead---v

(script dormant turret_right02_alldead
	
	(print "turret_right02_alldead wake")
	(sleep_until (<= (unit_get_health turret01)0))
	(sleep_until (volume_test_objects turret_right02 (players))15)				
	(print "turret_right02_alldead running")
	
	(if G_turret_right02 (sleep 32000))
	(set G_turret_right02 true)

	(ai_place turret_right_elites02)
	(ai_place turret_right_grunts02)
	
	;(ai_set_orders turret_right_elites02 turret_right_investigate)
	;(ai_set_orders turret_right_grunts02 turret_right_investigate)
	
)

	;vvvvvv-----TURRET_RIGHT02 SPAWN if turret_right triggered---v

(script dormant turret_right02
	
	(print "turret_right02 wake")
	(sleep_until (volume_test_objects turret_right02 (players))15)
	(print "turret_right02 running")
	
	(if G_turret_right02 (sleep 32000))
	(set G_turret_right02 true)
	
	(ai_place turret_right_elites02)
	(ai_place turret_right_grunts02)
	
	;(ai_set_orders turret_right_elites02 turret_right_intro02)
	;(ai_set_orders turret_right_grunts02 turret_right_intro02)
)



;VVVVVVVVVVVVVVVVVV-----------TURRET_LEFT------------------------------------------VVVVVVVVVVVVVV
;VVVVVVVVVVVVVVVVVV-----------TURRET_LEFT------------------------------------------VVVVVVVVVVVVVV
;VVVVVVVVVVVVVVVVVV-----------TURRET_LEFT------------------------------------------VVVVVVVVVVVVVV

(script dormant turret_left_r01
	
	(sleep_until (<= (ai_living_count turret_left) 3))
	
	(ai_place turret_left_r01)
	
	(sleep_until (<= (unit_get_health turret_left) 0))
	
	(sleep_until 
		(and
			(volume_test_objects turret_left_middle01 (players))
			(volume_test_objects turret_left_middle02 (players))
		)
	)
	
	(if (<= (unit_get_health turret_right) 0) 
		(begin	
			(ai_set_orders turret_left_r01 lz_front_left)
		)
		
		(begin
			(ai_set_orders turret_left_r01 lz_front_right)
		)
	)
)

(script dormant turret_left
	
	(print "turret_left wake")
	(sleep_until (volume_test_objects turret_left (players))15)
	
	(if G_turret_left_middle_trigger (sleep 32000))
	(set G_turret_left_middle_trigger true)
	
	(print "turret_left running")
	
	(ai_place turret_left_elites)
	
	(object_create turret_left_ap_turret01)
	
	(ai_vehicle_enter_immediate turret_left_elites/starting_locations_1 turret_left_ap_turret01 "c_turret_ap_d")
	
	(ai_set_orders turret_left_elites turret_left_intro)
	
	(wake turret_left_r01);wake
	
	;(wake last_turret_destroyed_dialog);wake
	;(wake save01);wake
	
)

(script dormant turret_left_middle
	
	(print "turret_left wake")
	
	(sleep_until 
		(or
			(volume_test_objects turret_left_middle01 (players))
			(volume_test_objects turret_left_middle02 (players))
		)	
			15)
			
	(if G_turret_left_middle_trigger (sleep 32000))
	(set G_turret_left_middle_trigger true)
				
	(print "turret_left running")
	
	(ai_place turret_left_elites)
	
	(object_create turret_left_ap_turret01)
	
	(ai_vehicle_enter_immediate turret_left_elites/starting_locations_1 turret_left_ap_turret01 "c_turret_ap_d")
	
	(ai_set_orders turret_left_elites turret_left_intro)
	
	(wake turret_left_r01);wake
	
	(wake vehicle_spawn01);wake
	(wake save01);wake
	
	;(sleep_until (volume_test_objects runandgun01 (players))15)
	
	;(wake runandgun01)
	;(wake trap01)
	
)



	;vvvvvv-----TURRET_LEFT_ELITES02 SPAWN if all guys in turret01 are dead---v

(script dormant turret_left_elites02_alldead
	
	(print "turret_left_elites02_alldead wake")
	(sleep_until (<= (unit_get_health turret01)0))
	(print "turret_left_elites02_alldead running")
	
	(if G_turret_left_elites02 (sleep 32000))
	(set G_turret_left_elites02 true)
	
	(sleep_until (volume_test_objects turret_left02 (players)))

	(ai_place turret_left_elites02)
	(ai_place turret_left_grunts01)

	(ai_set_orders turret_left_elites02 turret_left_elites02_attack)
	(ai_set_orders turret_left_grunts01 turret_left_elites02_attack)

)

	;vvvvvv-----TURRET_LEFT_ELITES02 SPAWN if trigger Turret_left---v

(script dormant turret_left_elites02
	
	(print "turret_left_elites02 wake")
	(sleep_until (volume_test_objects turret_left02 (players))15)
	(print "turret_left_elites02 running")
	
	(if G_turret_left_elites02 (sleep 32000))
	(set G_turret_left_elites02 true)

	(ai_place turret_left_elites02)
	(ai_place turret_left_grunts01)

	(ai_set_orders turret_left_elites02 turret_left_elites02_intro)
	
	(sleep_until (<= (ai_living_count turret01_elites) 0))
	
	(ai_set_orders turret_left_elites02 turret_left_elites02_attack)
	(ai_set_orders turret_left_grunts01 turret_left_elites02_attack)

)

	;vvvvvv-----TURRET_LEFT_ELITES02 SPAWN if trigger Turret_Between---v

(script dormant turret_left_elites02_middle

	(sleep_until 
		(or
			(volume_test_objects turret_left_middle01 (players))
			(volume_test_objects turret_left_middle02 (players))
		)	
			15)
	
	(if G_turret_left_elites02 (sleep 32000))
	(set G_turret_left_elites02 true)
	
	(ai_place turret_left_elites02)
	(ai_place turret_left_grunts01)

	(ai_set_orders turret_left_elites02 turret_left_elites02_investig)

)


		
	
	;vvvv-------- DIALOG: turret01-------------------------v
	
(script dormant turret01_dialog_alt
	
	(sleep_until 
		(and
			(> (unit_get_health turret01) 0)
			(or	
				(volume_test_objects turret_left02 (players))
				(volume_test_objects turret_right02 (players))
			)
		)
	)
	
	(sleep 15)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0170_soc" none 1)
	
	(print "--- C.O.:  We need their air defenses destroyed before we can land our assault force,")
	
	(sleep 60)
	
	(print "--- C.O.:  find and destroy any AAA guns in the area")
	
)

(script dormant turret01_dialog

	(sleep_until 
		(or
			(<= (unit_get_health turret01)0)
			(<= (unit_get_health turret_right)0)
			(<= (unit_get_health turret_left)0)
		)
	)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(sleep 20)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0150_soc" none 1)
	
	(print "--- C.O.:  Good job. their defenses have been weakened..")
	
	(sleep 70)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0160_soc" none 1)

	(print "--- C.O.:  our scanners are detecting 2 more guns in the area. ..")
	
	(wake music_2);wake
	
	(sleep 90)
	
	(wake music_4);wake
	
	;(sleep 35)
	
	;(print "--- C.O.:  take them out so our assault force can land ") 

)
	;vvvv---------  turret01  ------------------------vvvvvvvvvvvvv
	

(script dormant turret01_2ndwave

	(sleep_until 
		(and
			(<= (unit_get_health turret01)0)
			(<= (ai_living_count turret01_reinforcements) 1)	
		)
	)
	
	(ai_place turret01_2ndwave_rr)
	(ai_place turret01_2ndwave_r)
	(ai_place turret01_2ndwave_ll)
)


(script command_script cs_turret01_reinforcements
	
	(print "guys walk off cliff")
	
	(cs_move_in_direction 320 7 0)
)	

(script static void testr
	
	(ai_erase turret01_reinforcements)
	
	(sleep 10)


	(ai_place turret01_reinforcements)
	
	(cs_run_command_script turret01_reinforcements/starting_locations_1 cs_turret01_reinforcements)
	(cs_run_command_script turret01_reinforcements/starting_locations_2 cs_turret01_reinforcements)
	(cs_run_command_script turret01_reinforcements/starting_locations_3 cs_turret01_reinforcements)
	
	
	;(cs_run_command_script turret01_reinforcements cs_turret01_reinforcements)

)

(script dormant turret01
	
	(print "turret01 wake")
	(sleep_until (volume_test_objects turret01 (players))15)
	(print "turret01 running")
	
	(ai_place turret01_elites)
	(ai_place turret01_elites02)
	(ai_place turret01_side_i)
	
	(ai_set_orders turret01_elites turret01_intro)
	(ai_set_orders turret01_elites02 turret01_elites02_intro)
	
	(sleep 5)
	
	(ai_place turret01_back_r)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake turret_left);wake
	(wake turret_left_middle);wake
	(wake turret_left_elites02_alldead);wake
	(wake turret_left_elites02);wake
	(wake turret_left_elites02_middle);wake
	
	(wake turret_right);wake
	(wake turret_right_middle);wake
	(wake turret_right02);wake
	(wake turret_right02_alldead);wake
	
	(sleep 15)
	
	(wake turret01_dialog);wake
	
	(wake turret01_dialog_alt);wake
	
	(wake destroy_last_turret_dialog);wake
	
	(wake last_turret_destroyed_dialog);wake
	
	(wake turret_right_2_left);wake
	(wake turret_left_2_right);wake
	
	
	(wake lz_middle_l);wake ln3944
	(wake lz_middle_r);wake ln3960
	

	(wake turret01_2ndwave);wake
	
	(sleep_until (<= (ai_living_count turret01_i) 2))
	
	(ai_place turret01_reinforcements)
	
	(cs_run_command_script turret01_reinforcements cs_turret01_reinforcements)
	
	;(cs_run_command_script turret01_reinforcements cs_turret01_reinforcements)
	
	;(cs_run_command_script turret01_reinforcements/starting_locations_1 cs_turret01_reinforcements)
	;(cs_run_command_script turret01_reinforcements/starting_locations_2 cs_turret01_reinforcements)
	;(cs_run_command_script turret01_reinforcements/starting_locations_3 cs_turret01_reinforcements)
	
)

(script dormant turret01_heretic_dialog

	(print "turret01_h_d")

	(sleep_until 
		(and
			(volume_test_objects turret01_heretic_dialog (players))
			(> (ai_living_count turret01_i) 3)
		)
	15)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0130_he1" none 1)
	
	(sleep 90)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0140_he2" none 1)
)

;vvvvvvvvvvvv---------------3 TURRETS firing fx--------------------------------------------------vv
;vvvvvvvvvvvv---------------3 TURRETS--------------------------------------------------vv
;vvvvvvvvvvvv---------------3 TURRETS--------------------------------------------------vv

(script continuous turret_right_effect
	
	(sleep (random_range 20 55))
	
	;(effect_new "effects\test\stephen_beam" turret_right)
	;(effect_new "effects\retro_rockets" turret_right)
	;(sound_impulse_start "sound\temp\alphamoon\cannon_fire" turret_right_root 1)
	
	(if 
		(<= (unit_get_health turret_right)0) 
		(begin
			;(effect_new "effects\test\stephen_explosion" turret_right_explosion)
			;(sound_impulse_start "sound\temp\alphamoon\cannon_explode" turret_right_root 1)
			(sleep_forever)
		) 
	)
)


(script continuous turret_left_effect
	
	
	(sleep (random_range 20 55))
	
	;(effect_new "effects\test\stephen_beam" turret_left)
	;(effect_new "effects\retro_rockets" turret_left)
	;(sound_impulse_start "sound\temp\alphamoon\cannon_fire" turret_left_root 1)
	
	(if 
		(<= (unit_get_health turret_left)0) 
		(begin
			;(effect_new "effects\test\stephen_explosion" turret_left_explosion)
			;(sound_impulse_start "sound\temp\alphamoon\cannon_explode" turret_left_root 1)
			(sleep_forever) 
		)
	)
)

(script continuous turret01_effect
	
	(sleep (random_range 20 55))
	
	;(effect_new "effects\test\stephen_beam" turret01)
	;(effect_new "effects\retro_rockets" turret01)
	;(sound_impulse_start "sound\temp\alphamoon\cannon_fire" turret01_root 1)
	
	(if 
		(<= (unit_get_health turret01)0) 
		(begin
			;(effect_new "effects\test\stephen_explosion" turret01_explosion)
			;(sound_impulse_start "sound\temp\alphamoon\cannon_explode" turret01_root 1)
			(sleep_forever) 
		)
	)
)

(script dormant turret01_dropship01
	
	(sleep_until (volume_test_objects turret01_dropship01 (players))15)
	
	(print "turret01 dropship")
	
	(wake turret01_heretic_dialog);wake
	
	(object_create turret01_dropship01_debris03)
	
	(wake music_3)
	
	(sleep 5)
	
	;(sound_impulse_start "sound\temp\alphamoon\dropship_crash" turret01_dropship01_debris03 1)
	
	(sleep 25)
	
	(object_create turret01_dropship02)
	
	(effect_new "z_old_fx\vehicles\creep\creep_damage" turret01_dropship01_exp01)
	(effect_new "z_old_fx\vehicles\creep\creep_damage" turret01_dropship01_exp02)
	(sleep 20)
	
	(effect_new "z_old_fx\vehicles\creep\creep_damage" turret01_dropship01_exp03)
	
	(object_create_containing "turret01_dropship01_debris")
	
	(sleep 35)
	(effect_new "z_old_fx\vehicles\creep\creep_damage" turret01_dropship01_exp04)
	
	(sleep 20)
	;(effect_new "effects\burning_large" turret01_dropship01_smk01)
	
	(sleep 90)
	(object_destroy turret01_dropship01_debris03)
)


(script dormant intro_dialog

	(sleep 35)

	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0030_soc" none 1)

	(print "--- C.O.:  Their defenses are stronger than we thought,")
	
	(sleep 60)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0040_soc" none 1)
	
	(print "--- C.O.:  no one else survived the first drop")
	
	(sleep 60)
	
	(sound_impulse_start "sound\dialog\alphamoon\level\l05_0050_soc" none 1)
	
	(print "--- C.O.:  Were pulling back until you have neutralized their defenses")
	
	(sleep 90)
	
	(wake music_1);wake
	
	(wake music_2);wake
)




(script dormant intro_reinforcements01
	
	(sleep_until 
		(or
			(<= (ai_living_count intro_intro) 3)	
			(volume_test_objects intro_front_middle_back (players))
		)
	15)
	
	(ai_place intro_reinforcements01)
	(ai_set_orders intro_reinforcements01 intro_reinforcements01)
)

(script dormant intro_i
	
	(ai_place intro_elites)
	(ai_place intro_grunts)
	
	(ai_place intro_front_middle)
	
	(ai_place intro_back)
	
	(ai_set_orders intro_elites intro_intro)
	(ai_set_orders intro_grunts intro_intro)
	
	(sleep 900)
	
	(ai_set_orders intro_elites intro_players_pod)
	(ai_set_orders intro_grunts intro_players_pod)

)

;vvvvvvvv-----------start up script---------------vvvvvvvvvvvvv

(script startup elites
	
	(print "tyson EYES!!!")
	
	(sleep_forever 1turret_hdropship01_loop)
	(sleep_forever runandgun02_hds01_loop)
	
	(wake music_1);wake
	
	(intro)
	
	(wake intro_dialog);wake
	
	(wake intro_i);wake
	
	
	
	(wake intro_reinforcements01);wake
	
	(wake turret01);wake
	
	(wake g_end_segment01);wake  ; on line 3837
	
	
	
	;(wake dropship_grunt);wake
	(wake trap01);wake
	
	
	
	(wake runandgun02);wake
	
;	(wake excavation_start01);wake
	
	(wake turret01_dropship01);wake
	(sleep 5)
	
	(wake 1turret_intro);wake
	
	(wake 2turret01);wake
	
;	(wake excavation_middle_low);wake
	
	(wake heretic_leader_intro);wake
	
	(sleep_forever 1turret_turret)
	(sleep_forever 2turret_turret_left)
	(sleep_forever 2turret_turret_right)

	(sleep 90)
	
	;(wake view_i);wake
	
	(wake view);wake
	
	(wake pre_s_trap);wakeln1373
	
	;(wake a_1turret_reinforce);wake
	
	;(sleep_until (volume_test_objects intro_back (players))15)
	
	;(ai_set_orders intro_elites turret01_retreat)
	;(ai_set_orders intro_grunts turret01_retreat)
	
	;(ai_set_orders marines tanks/tanks)
	;(ai_set_orders turret01_elites turret01/turret_intro)
	;(unit_enter_vehicle (unit (list_get (ai_actors marines) 0)) warthog "W-driver")
	;(unit_enter_vehicle (unit (list_get (ai_actors marines) 1)) warthog "W-gunner")
	;(unit_enter_vehicle (unit (list_get (ai_actors marines) 0)) scorpion "scorpion-driver")
	;(vehicle_load_magic scorpion "scorpion-driver" (ai_actors marines))
	;(vehicle_load_magic wraith "wraith-driver" (ai_actors elites))
)
