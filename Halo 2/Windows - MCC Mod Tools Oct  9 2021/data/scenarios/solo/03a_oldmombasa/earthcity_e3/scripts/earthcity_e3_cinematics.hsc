; Cinematics for EARTHCITY E3 DEMO

;-GLOBALS-----------------------------------------------------------------------

(global boolean g_intro false)

;-STUBS-------------------------------------------------------------------------

(script stub void joe_mission_start
	(print "stub: mission start")
	)
	
(script stub void joe_field_hospital_warthog_go
	(print "stub: joe_field_hospital_warthog_go")
	)
	
(script stub void joe_odsts_return
	(print "stub: joe_odsts_return")
	)
	
(script stub void joe_odsts_enter_hospital
	(print "stub: joe_odsts_enter_hospital")
	)
	
(script stub void joe_odsts_head_for_sarge
	(print "stub: odsts head for crater")
	)

(script stub void joe_grunt_wave_begins
	(print "stub: here come the grunts")
	)
	
(script stub boolean joe_bombers_can_enter
	(print "stub: joe_bombers_can_enter")
	(= 0 1)
	)

(script stub void joe_bombs_away
	(print "stub: joe_bombs_away")
	)
	
(script stub void joe_turret_exploded
	(print "stub: joe_turret_exploded")
	)

;-INTRO & OUTRO SCRIPTS AT THE BOTTOM-------------------------------------------


;-HOSTILE FIRE------------------------------------------------------------------

(script dormant hostile_fire_1
	(effect_new effects\bursts\guntower_burst f_hostile_fire_11)
	(sleep 15)
	(effect_new effects\bursts\guntower_burst f_hostile_fire_21)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_51)
	(sleep 20)
	(effect_new effects\bursts\guntower_burst f_hostile_fire_31)
	(sleep 10)
;	(effect_new effects\bursts\guntower_burst f_hostile_fire_41)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_61)
	)

(script dormant hostile_fire_2
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_12)
	(sleep 10)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_22)
	(sleep 30)
	(effect_new effects\bursts\guntower_burst f_hostile_fire_42)
	(sleep 30)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_32)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_52)
	(sleep 30)
	(effect_new effects\bursts\guntower_burst f_hostile_fire_62)
	)
	
(script dormant hostile_fire_3
	(effect_new effects\bursts\guntower_burst f_hostile_fire_43)
	(sleep 30)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_23)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_13)
	(sleep 5)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_63)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_73)
;	(sleep 10)
;	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_33)
;	(sleep 20)
;	(effect_new effects\explosions\c_flak_explosion f_hostile_fire_53)
	)
	
(script dormant cockpit_fire
;	(effect_new effects\bursts\guntower_burst f_cockpit_burst_1)
;	(sleep 5)
	(effect_new effects\explosions\c_flak_explosion f_cockpit_flak_3)
	(sleep 30)
	(effect_new effects\explosions\c_flak_explosion f_cockpit_flak_1)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion f_cockpit_flak_2)
	(sleep 20)
	(effect_new effects\explosions\c_flak_explosion f_cockpit_flak_4)
	)
	
(script dormant troopbay_fire
	(effect_new effects\explosions\c_flak_explosion f_troopbay_flak_1)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion f_troopbay_flak_2)
	(sleep 20)
	(effect_new effects\explosions\c_flak_explosion f_troopbay_flak_3)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion test)
	)
	
(script dormant lz_fire
	(effect_new effects\explosions\c_flak_explosion f_lz_fire_1)
	(sleep 30)
	(effect_new effects\explosions\c_flak_explosion f_lz_fire_2)
	(sleep 60)
	(effect_new effects\bursts\guntower_burst f_lz_fire_5)
	(sleep 30)
	(effect_new effects\explosions\c_flak_explosion f_lz_fire_3)
	(sleep 60)
	(effect_new effects\explosions\c_flak_explosion f_lz_fire_6)
	(sleep 90)
	(effect_new effects\bursts\guntower_burst f_lz_fire_4)
	)

;-TITLES------------------------------------------------------------------------

(script static void bungie_in
	(ui_debug_screen_tag ui\screens\e3\bungie_logo)
	)
	
(script static void super_in
	(ui_debug_screen_tag ui\screens\e3\e3_chapter_label)
	)
	
(script static void halo2_in
	(ui_debug_screen_tag ui\screens\e3\halo2_logo)
	)
	
(script static void title_fade
;	(ui_dispose); I had to comment out this line, it was crashing -Jaime
	(sleep 1)
	)

;-COMMAND SCRIPTS FOR ODSTS-----------------------------------------------------

(script command_script odst_crater_1
	(cs_play_sound sound\e3\dialog\e3_470_odst 1 1)
	)
	
(script command_script odst_crater_2
	(cs_play_sound sound\e3\dialog\e3_540_odst 1 1)
	)
	
(script command_script odst_crater_3
	(cs_play_sound sound\e3\dialog\e3_540_odst 1 1)
	)
	
(script command_script odst_crater_4
	(cs_play_sound sound\e3\dialog\e3_570_odst 1 1)
	)
	
;-COMMAND SCRIPTS FOR GUNTOWER----------------------------------------------------------------------

(script command_script cs_shoot_city
	(cs_force_combat_status 4)
	(cs_shoot_point true guntower_targets/city) 
	(sleep 32000)
	)
(script command_script cs_shoot_hospital
	(cs_force_combat_status 4)
	(cs_shoot_point true guntower_targets/hospital)
	(sleep 32000)
	)

(script command_script cs_shoot_crater
	(cs_force_combat_status 4)
	(cs_shoot_point true guntower_targets/crater)
	(sleep 32000)
	)
	
(script dormant guntower_setup

	(ai_place gunner)
	(object_create guntower)
	
	(vehicle_load_magic guntower "c_turret_ap_d" (list_get (ai_actors gunner) 0))
	(object_teleport guntower f_guntower)
	(vehicle_hover guntower true)
	
	(sleep 5)

	(cs_run_command_script gunner cs_shoot_city)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .5 .4 .4)
	(cinematic_lighting_set_secondary_light 20 180 .2 .2 .3)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting guntower 1)
	;
	
	)

;-DORMANT SCRIPTS FOR SGT. BANKS, ODST & MAJ. EASLEY----------------------------

(script dormant longsword_start
	
	(joe_bombs_away)
	
	(object_create_containing longsword)
	(object_create_containing bomb)
	
	(custom_animation longsword_1 objects\vehicles\longsword\animations\e3\e3 "longsword01_bombrun" false)
	(custom_animation longsword_2 objects\vehicles\longsword\animations\e3\e3 "longsword02_bombrun" false)
	
	(scenery_animation_start bomb_1 scenarios\objects\human\military\longsword_bomb\animations\e3\e3 "bomb01")
	(scenery_animation_start bomb_2 scenarios\objects\human\military\longsword_bomb\animations\e3\e3 "bomb02")
	(scenery_animation_start bomb_3 scenarios\objects\human\military\longsword_bomb\animations\e3\e3 "bomb03")
	(scenery_animation_start bomb_4 scenarios\objects\human\military\longsword_bomb\animations\e3\e3 "bomb04")
	
	(sound_looping_start sound\e3\new_longsword\new_longsword none 1)
	
	(sleep 350)
	
	(joe_turret_exploded)
	
	(object_destroy_containing longsword)
	(object_destroy_containing bomb)
	)

(script command_script cs_turret_2
	(cs_enable_moving false)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep 32000)
	)

(script dormant crater
	(ai_erase bandaged_marine)

	(cs_run_command_script gunner cs_shoot_hospital)

	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:460" true)
	(sound_impulse_start sound\e3\dialog\e3_460_banks sgt_banks 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_460_banks))
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:injured:idle" true)
	
;	(sleep 60)
	
	(joe_grunt_wave_begins)
	
	(sleep_until (objects_can_see_object (player0) sgt_banks 10.0) 5 150)

	(cs_run_command_script gunner cs_turret_2)
	(cs_run_command_script odst_1 odst_crater_1)
	
	(ai_erase m_hall_1)
	(ai_erase m_hall_2)
	(ai_erase parsons)
	(object_destroy hall_turret)
	(object_destroy private_ryan)
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:480" true)
	(sound_impulse_start sound\e3\dialog\e3_480_banks sgt_banks 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_480_banks))
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:walk" true)
	(sleep 125)
	
	(cs_run_command_script gunner cs_shoot_city)
	
	(object_create_anew handset)
	(objects_attach sgt_banks "left_hand" handset "left_hand")
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:490" true)
	(sound_impulse_start sound\e3\dialog\e3_490_banks sgt_banks 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_490_banks))
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:500" true)
	(sound_impulse_start sound\e3\dialog\e3_500_banks sgt_banks 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_500_banks))
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:talk:idle" true)
	
	(cs_run_command_script gunner cs_shoot_crater)
	
	(sleep 120)
	
	(cs_run_command_script odst_1 odst_crater_2)
	
	(sleep 120)
		
	(cs_run_command_script odst_1 odst_crater_3)
	(sleep_until (not (cs_command_script_running odst_1 odst_crater_3)) 5)
	
	(sleep_until (joe_bombers_can_enter) 5)
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:510" true)
	(sound_impulse_start sound\e3\dialog\e3_510_banks sgt_banks 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_510_banks))
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:talk:idle" true)
	
	(sound_impulse_start sound\e3\dialog\e3_520_easley none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_520_easley))
	
	(wake longsword_start)
	
	(sleep 140)
	
	(object_create_anew e4_gun_smoke)
	
	(sound_impulse_start sound\e3\expl_bomb_drop none 1)
	
	(effect_new_on_object_marker effects\explosions\bomb_dropping bomb_1 "")
	(sleep 10)
	(effect_new_on_object_marker effects\explosions\bomb_dropping bomb_2 "")
	(sleep 20)
	(effect_new_on_object_marker effects\explosions\bomb_dropping bomb_3 "")
	(sleep 10)
	(effect_new_on_object_marker effects\explosions\bomb_dropping bomb_4 "")
	
	(effect_new effects\explosions\gun_tower_explosion f_guntower_explosion)
	(sleep 5)
	(object_destroy guntower)
	
	(sleep 75)
	
	(sound_impulse_start sound\e3\dialog\e3_550_easley none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_550_easley))
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:560" false)
	(sound_impulse_start sound\e3\dialog\e3_560_banks sgt_banks 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_560_banks))
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:talk:idle" false)
 	
	(cs_run_command_script odst_1 odst_crater_4)
	
	(object_teleport sgt_banks f_smg_handoff)
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:stand:idle" false)
	
	(sleep_until (objects_can_see_object (player0) sgt_banks 30.0))
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:563" false)
	(sound_impulse_start sound\e3\dialog\e3_563_banks sgt_banks 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_563_banks))
	
	(object_destroy outro_smg_1)
	(object_destroy_containing target)
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:564" true)
	(sound_impulse_start sound\e3\dialog\e3_564_banks sgt_banks 1)
	
	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:stand:idle" true)
	
	(sleep 1000)
	
	(object_destroy handset)
	(object_destroy sgt_banks)
	(object_destroy dead_comm_marine)
	)

(script dormant crater_setup
	
	(joe_odsts_head_for_sarge)
	
	(object_create sgt_banks)
	(object_create dead_comm_marine)
	
	(object_cinematic_lod sgt_banks true)
	
	(object_create_anew target_3)
	(object_create_anew target_4)
	(object_create_anew target_5)
	
	(unit_impervious sgt_banks true)
	(unit_impervious dead_comm_marine true)
	
	(object_cannot_take_damage sgt_banks)
	(object_cannot_take_damage dead_comm_marine)
	
	(object_create_anew outro_smg_1)
	(objects_attach sgt_banks "right hand" outro_smg_1 "")
	
	(object_cinematic_collision sgt_banks true)
	(object_cinematic_collision dead_comm_marine true)

	(custom_animation sgt_banks objects\characters\marine\marine_cinematics\marine_cinematics "sin:banks:injured:idle" false)
	(custom_animation dead_comm_marine objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:radio:dead" false)
	
	(sleep_until (volume_test_objects tv_crater_start (players)) 5)
	(sleep 45)
	(wake crater)
	)
	
;-HORRIBLE PEREZ DIALOG HACK----------------------------------------------------

(script dormant dialog_hack_2
	(sound_impulse_start sound\e3\dialog\e3_350_perez none 1)
	)
	
;-PEREZ COMMAND SCRIPTS, PARSONS TO CRATER--------------------------------------

(script command_script hall_5
     (cs_force_combat_status 3)
     (sleep 30)
     (cs_enable_targeting true)
     (cs_shoot true hey_jackass_shoot_this)
     (sleep 32000)
     )

(script command_script cs_bm_3
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:440" 0 true)
	(cs_play_sound sound\e3\dialog\e3_440_perez 1 1)
	
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	
	(cs_go_to bm_walk/p4)
;	(cs_crouch true)
	
	(cs_enable_moving false)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(cs_shoot true guntower)
	
	(object_pvs_clear)
	
	(sleep 32000)
	)

(script dormant bm_3
	(cs_run_command_script bandaged_marine cs_bm_3)
	
	;PREDICTION grunts and jackals
	(object_type_predict objects\characters\jackal\jackal)
	(object_type_predict objects\characters\grunt\grunt)
	(object_type_predict objects\weapons\pistol\plasma_pistol\plasma_pistol)
	(object_type_predict scenarios\objects\human\residential\cafe_chair\cafe_chair)
	(object_type_predict scenarios\objects\human\residential\cafe_table\cafe_table)
	(object_type_predict scenarios\solo\earthcity\earthcity_e3\cinematics\corpse_marine_flat\corpse_marine_flat)
	(object_type_predict scenarios\solo\earthcity\earthcity_e3\cinematics\corpse_marine_slump\corpse_marine_slump)
	;END PREDICTION

	(sleep 60)

     (cs_run_command_script m_hall_1 hall_5)
     (cs_run_command_script m_hall_2 hall_5)
     
     (sleep_until (volume_test_objects tv_sarge_start (player0)) 1)
	(wake crater_setup)
	(wake guntower_setup)
	
	;goodbye bloom (but, oh, how sweet you were)
	(cinematic_screen_effect_set_bloom_transition 0 0 0 0 0 3)
	(sleep 90)
	(cinematic_screen_effect_stop)
	)
	

;-PARSONS-----------------------------------------------------------------------

(script command_script cs_parsons_2
	
	(effect_new_on_object_marker effects\explosions\explosion_e3_wall_medium parsons_shield "explosion")
	(object_set_region_state parsons_shield "" destroyed)
	
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:watcher:430" 0 true)

	(sleep 30)
	
	(sleep 30)
	
	(cs_play_sound sound\e3\dialog\e3_430_watcher 1 1)
	(wake bm_3)
	(cs_pause 1000)
	)

(script command_script cs_no_shield_for_you
	(cs_enable_targeting true)
	(cs_shoot true parsons_shield)
	(sleep 32000)
	)

(script dormant parsons_2
	(cs_run_command_script parsons cs_parsons_2)
	)
	
(script command_script cs_parsons_1
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:watcher:410" 0 true)
	(cs_play_sound sound\e3\dialog\e3_410_watcher 1 1)
	)

(script command_script cs_parsons_crouch
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:watcher:idle" 0 true)
	)

(script dormant parsons_crouch
	(cs_run_command_script parsons cs_parsons_crouch)
	)

(script dormant parsons_1
	(cs_run_command_script parsons cs_parsons_1)
	)

;-HALL MARINES------------------------------------------------------------------

(script command_script hall_0
	(cs_force_combat_status 3)
	(cs_enable_targeting true)
	(cs_shoot true hey_jackass_shoot_this)
	(sleep 32000)
	)

(script command_script hall_1
	(cs_force_combat_status 3)
	(cs_enable_targeting true)
	(cs_shoot true hey_jackass_shoot_this)
	(sleep 32000)
	)
	
(script command_script hall_2
	(cs_force_combat_status 3)
	(cs_enable_targeting true)
	(cs_shoot true hey_jackass_shoot_this)
	(sleep 32000)
	)
	
;-PEREZ COMMAND SCRIPTS, LZ TO PARSONS---------------------------------------------
	
(script dormant hall_marines

	(object_destroy w_lieutenant)
	(object_destroy_containing w_marine)
	(object_destroy_containing medic)
	(object_destroy_containing stretcher)
	(object_destroy_containing tent_doc)
	(object_destroy_containing tent_marine)
	
	(cs_run_command_script m_hall_1 hall_1)
	(cs_run_command_script m_hall_2 hall_2)

	(sound_impulse_start sound\e3\dialog\e3_360_hall1 (list_get (ai_actors m_hall_1) 0) 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_360_hall1))
	
	(sound_impulse_start sound\e3\dialog\e3_370_hall2 (list_get (ai_actors m_hall_2) 0) 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_370_hall2))
	
	(sound_impulse_start sound\e3\dialog\e3_380_hall1 (list_get (ai_actors m_hall_1) 0) 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_380_hall1))
	
	(sound_impulse_start sound\e3\dialog\e3_390_hall2 (list_get (ai_actors m_hall_2) 0) 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_390_hall2))
	
	)

(script dormant hall_marines_trigger
	(sleep_until (volume_test_objects tv_hall_marines (players)) 5)
	(wake hall_marines)
	(wake parsons_crouch)
	
	;this is why bernie wears sunglasses
	(cinematic_screen_effect_set_bloom_transition .6 0 0 1 1 3)
	(cinematic_screen_effect_start 0)
	)

(script command_script cs_bm_2

	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	
	(object_pvs_activate hall_turret)
	
	(cs_go_to bm_walk/p11)
	(cs_go_to bm_walk/p1)
	(cs_go_to bm_walk/p2)
	(cs_go_to bm_walk/p3)
	(cs_face true bm_walk/p8)
	
	(cs_pause 1)
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:400:idle" 0 true)
	
;	(sleep_until (<= (objects_distance_to_object (ai_actors bandaged_marine) (player0)) 1))
	(sleep_until (volume_test_objects tv_parsons (players)) 5)
	
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:400" 0 true)
	(cs_play_sound sound\e3\dialog\e3_400_perez 1 1)
	
	(wake parsons_1)
	(sleep_until (not (cs_command_script_running parsons cs_parsons_1)) 1)
	
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:420" 0 true)
	(cs_play_sound sound\e3\dialog\e3_420_perez 1 1)
	
;	(effect_new effects\explosions\explosion_cement parsons_explosion)
	
	(wake parsons_2)
	)

(script dormant bm_2

	(object_destroy intro_pelican_1)

	(ai_erase fh_marine_1)
	(ai_erase fh_marine_2)

	(ai_place m_hall_1)
	(ai_place m_hall_2)
	
	(object_cinematic_lod (list_get (ai_actors m_hall_1) 0) 1)
	(object_cinematic_lod (list_get (ai_actors m_hall_2) 0) 1)
	
	(object_create private_ryan)
	(object_cinematic_collision private_ryan true)
	(custom_animation private_ryan objects\characters\marine\marine_cinematics\marine_cinematics "sin:wall:agony%1" false)
	
	(ai_place parsons)
;	(object_create parsons_shield)
	
	(vehicle_load_magic hall_turret "h_turret_ap_d" (list_get (ai_actors m_hall_2) 0))

	(wake hall_marines_trigger)

	(cs_run_command_script bandaged_marine cs_bm_2)
	(sleep 5)
	
	(wake dialog_hack_2)
	
	(sleep 90)
	
	(cs_run_command_script m_hall_1 hall_0)
	(cs_run_command_script m_hall_2 hall_0)
	
	(sleep_until (not (cs_command_script_running bandaged_marine cs_bm_2)) 5)
	)
	
(script dormant limping_marines
	(custom_animation w_marine_4 objects\characters\marine\marine_cinematics\marine_cinematics "sin:limp:assist" false)
	(custom_animation w_marine_5 objects\characters\marine\marine_cinematics\marine_cinematics "sin:limp:hurt" false)
	)
	
(script command_script cs_bm_1
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	
	(joe_field_hospital_warthog_go)
	
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:210" 0 true)
	(cs_play_sound sound\e3\dialog\e3_210_perez 1 1)
	
	(wake limping_marines)

	(cs_go_to bm_walk/p7)
	(cs_go_to bm_walk/p10)
	(cs_go_to bm_walk/p0)
	(cs_face true bm_walk/p9)

	(cs_pause 2)
	(cs_force_combat_status 2)
	(cs_look_player true)

	(sleep_until (<= (objects_distance_to_object (ai_actors bandaged_marine) (player0)) 4) 1)
	
	(custom_animation medic_4 objects\characters\marine\marine_cinematics\marine_cinematics "sin:medic:call" false)
	(sleep 40)	
	(sound_impulse_start sound\e3\dialog\e3_310_medic4 medic_4 1)
	
	(joe_odsts_return)
	
	(sleep (sound_impulse_time sound\e3\dialog\e3_310_medic4))
	
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:320" 0 true)
	(cs_play_sound sound\e3\dialog\e3_320_perez 1 1)
	
	(joe_odsts_enter_hospital)
	
	(sound_impulse_start sound\e3\dialog\e3_330_cor none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_330_cor))
	
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:340" 0 true)
	(cs_play_sound sound\e3\dialog\e3_340_perez 1 1)
	
	(wake bm_2)
	)
	
(script dormant bm_1
	(cs_run_command_script bandaged_marine cs_bm_1)
	(sleep_until (not (cs_command_script_running bandaged_marine cs_bm_1)) 5)
	)
	
(script command_script cs_fh_run_1
	(cs_force_combat_status 3)
	(cs_go_to fh_run_1/p0)
	)
	
(script command_script cs_fh_run_2
	(cs_force_combat_status 3)
	(cs_go_to fh_run_1/p1)
	)
	
(script dormant fh_run_1

	(object_destroy_containing tarmac)
	(object_destroy_containing initial_dust)

	(ai_place fh_marine_1)
	(ai_place fh_marine_2)
	
	(cs_run_command_script fh_marine_1 cs_fh_run_1)
	(sleep 15)
	(cs_run_command_script fh_marine_2 cs_fh_run_2)
	)
	
(script command_script cs_perez_dust_idle
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:dust:idle" 0 true)
	)

;-MEDICS & WOUNDED MARINES------------------------------------------------------
	
(script dormant medic_2
	(sound_impulse_start sound\e3\dialog\e3_290_medic2 tent_doc_1 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_290_medic2))
	
	(sound_impulse_start sound\e3\dialog\e3_300_medic3 tent_doc_2 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_300_medic3))
	)
	
(script dormant medic_1

	(sound_impulse_start sound\e3\dialog\e3_260_medic1 medic_1 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_260_medic1))

;	(sound_impulse_start sound\e3\dialog\e3_270_wounded3 w_marine_1 1)
;	(sleep (sound_impulse_time sound\e3\dialog\e3_270_wounded3))
	
	(sound_impulse_start sound\e3\dialog\e3_280_medic1 medic_1 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_280_medic1))	
	
	(sleep_until (volume_test_objects tv_medic_2 (players)) 5)
	(wake fh_run_1)
	(wake medic_2)
	
	(object_cinematic_lod medic_4 true)
	(object_cinematic_lod medic_5 true)
	(object_cinematic_lod w_marine_6 true)
	(object_cinematic_lod w_lieutenant true)	
	
	)
	
(script dormant walkway_1
	
	(sound_impulse_start sound\e3\dialog\e3_220_wounded1 w_marine_4 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_220_wounded1))
	
	(sound_impulse_start sound\e3\dialog\e3_230_wounded2 w_marine_5 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_230_wounded2))
	
	(sleep_until (volume_test_objects tv_fh_marines_1 (players)) 5)
	)

(script static void triage_tent_setup

	(object_create_anew_containing tent_marine)
	(object_create_anew_containing tent_doc)
	
	(object_teleport tent_doc_1 f_tent_doc)
	(object_teleport tent_doc_2 f_tent_doc)
	
	(object_cinematic_collision tent_doc_1 true)
	(object_cinematic_collision tent_doc_2 true)
	(object_cinematic_collision tent_marine_1 true)
	
	(objects_attach stretcher_2 "occupant" tent_marine_1 "")

	(custom_animation tent_marine_1 objects\characters\marine\marine_cinematics\marine_cinematics "sin:back:dead" false)
	(custom_animation tent_doc_1 objects\characters\marine\marine_cinematics\marine_cinematics "sin:medic:operate" false)
	(custom_animation tent_doc_2 objects\characters\marine\marine_cinematics\marine_cinematics "sin:medic:operatehelp" false)
	)

(script dormant field_hospital_setup

	(ai_place bandaged_marine)
	(unit_impervious (ai_actors bandaged_marine) true)
	(object_cannot_take_damage (list_get (ai_actors bandaged_marine) 0))
	(object_cinematic_lod (ai_get_object bandaged_marine) true)
	
	(sleep 5)
	(cs_run_command_script bandaged_marine cs_perez_dust_idle)

	(object_create_anew w_lieutenant)
	(object_create_anew_containing w_marine)
	(object_create_anew_containing medic)
	(object_create_anew_containing tarmac)
	
	
	(object_cinematic_lod medic_1 true)
	(object_cinematic_lod w_marine_1 true)
	(object_cinematic_lod w_marine_4 true)
	(object_cinematic_lod w_marine_5 true)
	(object_cinematic_lod w_tarmac_3 true)
	(object_cinematic_lod w_tarmac_4 true)
	
	(object_create_anew_containing triage_tent)
	(object_create_anew_containing stretcher)
	
	(object_cinematic_collision w_lieutenant true)
	(object_cinematic_collision w_marine_1 true)
;	(object_cinematic_collision w_marine_3 true)
	(object_cinematic_collision w_marine_4 true)
	(object_cinematic_collision w_marine_5 true)
	(object_cinematic_collision w_marine_6 true)
	(object_cinematic_collision w_marine_7 true)
	
	(object_cinematic_collision medic_1 true)
	(object_cinematic_collision medic_4 true)
	(object_cinematic_collision medic_5 true)
	
	(object_cinematic_collision w_tarmac_1 true)
	(object_cinematic_collision w_tarmac_2 true)
	(object_cinematic_collision w_tarmac_3 true)
	(object_cinematic_collision w_tarmac_4 true)
	(object_cinematic_collision w_tarmac_5 true)
;	(object_cinematic_collision w_tarmac_6 true)
	
	(object_cinematic_collision stretcher_1 true)
	(object_cinematic_collision stretcher_2 true)
	(object_cinematic_collision stretcher_3 true)
	(object_cinematic_collision stretcher_4 true)
	(object_cinematic_collision stretcher_5 true)
	(object_cinematic_collision stretcher_6 true)
	
	(objects_attach stretcher_1 "occupant" w_marine_1 "")
	(objects_attach stretcher_6 "occupant" w_marine_6 "")
	(objects_attach stretcher_3 "occupant" w_lieutenant "")
	(objects_attach stretcher_4 "occupant" w_tarmac_1 "")
	(objects_attach stretcher_5 "occupant" w_tarmac_2 "")
	
	(unit_suspended w_marine_1 true)
	(objects_detach stretcher_1 w_marine_1)
	
	(unit_suspended w_marine_6 true)
	(objects_detach stretcher_6 w_marine_6)
	
	(object_teleport medic_1 f_medic_1)
	(object_teleport medic_4 f_medic_4)
	(object_teleport medic_5 f_medic_5)
	
	(sleep 5)
	
	(custom_animation w_lieutenant objects\characters\marine\marine_cinematics\marine_cinematics "sin:back:dead" false)
	
	(custom_animation w_marine_1 objects\characters\marine\marine_cinematics\marine_cinematics "sin:back:compression" false)
	(custom_animation medic_1 objects\characters\marine\marine_cinematics\marine_cinematics "sin:medic:compression" false)	
	
	(custom_animation medic_4 objects\characters\marine\marine_cinematics\marine_cinematics "sin:medic:callidle" false)
	
	(custom_animation w_marine_6 objects\characters\marine\marine_cinematics\marine_cinematics "sin:back:lookatleg" false)
	(custom_animation medic_5 objects\characters\marine\marine_cinematics\marine_cinematics "sin:medic:fixleg" false)
	
	(custom_animation w_marine_7 objects\characters\marine\marine_cinematics\marine_cinematics "sin:wall:breath%1" false)
	
	(custom_animation w_tarmac_1 objects\characters\marine\marine_cinematics\marine_cinematics "sin:front:agony%1" false)
	(custom_animation w_tarmac_2 objects\characters\marine\marine_cinematics\marine_cinematics "sin:left:agony%0" false)
	(custom_animation w_tarmac_3 objects\characters\marine\marine_cinematics\marine_cinematics "sin:back2:breath%1" false)
	(custom_animation w_tarmac_4 objects\characters\marine\marine_cinematics\marine_cinematics "sin:wall:breath%1" false)
	(custom_animation w_tarmac_5 objects\characters\marine\marine_cinematics\marine_cinematics "sin:wall:agony%0" false)	

	(sleep_until (<= (objects_distance_to_object (ai_actors bandaged_marine) (player0)) 2))
;	(sleep_until (volume_test_objects tv_bm_1 (players)) 5)
	
;	;PREDICTION first person stuff
;	(camera_predict camera_predict_2)
;    (object_type_predict scenarios\objects\solo\earthcity\medical_create_med\medical_create_med)
;    (object_type_predict scenarios\objects\human\military\stretcher_high\stretcher_high)
;    (object_type_predict objects\vehicles\warthog\warthog)
;    (object_type_predict scenarios\objects\human\military\barricade_small_visor\barricade_small_visor)
;    ;END PREDICTION
	
	(wake bm_1)
	
	(sleep_until (volume_test_objects tv_walkway_marines (players)) 5)
	(wake walkway_1)
	
	(sleep_until (volume_test_objects tv_medic_1 (players)) 5)
	(triage_tent_setup)
	(wake medic_1)
	)

;-INTRO EFFECTS-----------------------------------------------------------------

(script dormant intro_flak
	(effect_new effects\explosions\c_flak_explosion f_flak_1)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion f_flak_2)
	(sleep 15)
	(effect_new effects\explosions\c_flak_explosion f_flak_3)
	(sleep 30)
	(effect_new effects\explosions\c_flak_explosion f_flak_4)
	(sleep 30)
	(effect_new effects\explosions\c_flak_explosion f_flak_5)
	)

;-INTRO SETUP & AI--------------------------------------------------------------

(script command_script cs_pelican_1
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1)
	(cs_fly_by intro_pelican_1/p0)
	)

(script command_script cs_pelican_2
	(cs_fly_by intro_pelican_2/p0)
	(cs_fly_by intro_pelican_2/p1)
	(cs_fly_to intro_pelican_2/p3)
	)

(script command_script cs_pelican_3
	(object_set_velocity intro_pelican_3 2.0)
	(cs_fly_by intro_pelican_3/p0)
	(cs_fly_by intro_pelican_3/p1)
	)
	
(script command_script cs_intro_vamp
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:pilot_pelican_tactical" 0 true)
	(cs_play_sound sound\e3\dialog\e3_140_dspilot 0 1)
;	(cs_play_sound <sound> <%> <real>)
;	(cs_fly_by intro_vamp/p0)
	(cs_fly_by intro_vamp/p1)
	)
	
(script dormant chief_cortana_dialog_1
	(sound_impulse_start sound\e3\dialog\e3_070_cor none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_070_cor))
	(sleep 5)
	
	(sound_impulse_start sound\e3\dialog\e3_080_mc none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_080_mc))

	(sleep 10)
	(sound_impulse_start sound\e3\dialog\e3_090_johnson none 1)
	)
	
(script dormant intro_chief_reveal

	(object_destroy intro_pelican_2)
	(object_destroy_containing odst)
	(object_destroy earthcity_scenery)

	(wake chief_cortana_dialog_1)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	(object_pvs_activate chief)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "pelican_b:idle" false)
	(object_create_anew rifle_1)
	(objects_attach chief "right hand" rifle_1 "")
	
	;CINEMATC_LIGHTING
	(cinematic_lighting_set_primary_light -50 120 .3 .3 .5)
	(cinematic_lighting_set_secondary_light 20 -30 .5 .3 .1)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting chief 1)
	;
	
	(camera_set_relative intro_chief_reveal_1 0 intro_pelican_1)
	(camera_set_relative intro_chief_reveal_2 150 intro_pelican_1)
	
	(sleep 150)
	
	(player_effect_stop 0)
	
	(object_create_anew intro_pelican_2)
	(object_cinematic_lod intro_pelican_2 true)
	
	(object_pvs_activate intro_pelican_2)
	(object_teleport intro_pelican_2 f_intro_camera_2)

	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .6 .5 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_pelican_2 1)
	(object_uses_cinematic_lighting clouds_scenery 1)
	;
	
	(custom_animation intro_pelican_2 objects\vehicles\pelican\animations\e3\e3 "e3_pelican_flyby2" false)
	(camera_set_animation_relative scenarios\solo\earthcity\earthcity_e3\cinematics\camera\camera "camerapelican_flyby2" intro_pelican_2 f_intro_camera_2)
	(vehicle_engine_hack intro_pelican_2 true 1)

	(sleep 101)
	
	(custom_animation johnson objects\characters\marine\marine_cinematics\marine_cinematics "sin:johnson_pelican_04" false)
	(sleep 11)
;Moving Sound Destination
	(sound_impulse_start sound\e3\dialog\e3_100_johnson none 0)
;Moving Sound Destination

	(sleep 7)
	
	(set g_intro true)
	)

(script static void load_tactical_pelican

	(ai_place intro_pilot_1)
	(ai_place intro_door_gunner)
	
	(vehicle_load_magic intro_pelican_1 "pelican_d" (list_get (ai_actors intro_pilot_1) 0))
	(vehicle_load_magic intro_pelican_1 "pelican_g" (list_get (ai_actors intro_door_gunner) 0))
	
	(object_create_anew chief)
	(object_create_anew johnson)
	(object_create_anew_containing odst)
	(object_create_anew copilot_double)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting intro_odst_1 1)
	(object_uses_cinematic_lighting intro_odst_2 1)
	(object_uses_cinematic_lighting intro_odst_3 1)
	(object_uses_cinematic_lighting intro_odst_4 1)
	(object_uses_cinematic_lighting copilot_double 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_pilot_1) 0) 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_door_gunner) 0) 1)
	
	(objects_attach intro_pelican_1 chief_rear chief "")
	(objects_attach intro_pelican_1 johnson johnson "")
	(objects_attach intro_pelican_1 "pelican_p_copilot" copilot_double "")
	(objects_attach intro_pelican_1 "pelican_p_l05" intro_odst_1 "")
	(objects_attach intro_pelican_1 "pelican_p_l04" intro_odst_2 "")
	(objects_attach intro_pelican_1 "pelican_p_r05" intro_odst_3 "")
	(objects_attach intro_pelican_1 "pelican_p_r04" intro_odst_4 "")
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "pelican_b:idle_2" false)
	(custom_animation johnson objects\characters\marine\marine_cinematics\marine_cinematics "sin:johnson_pelican_cockpit" false)
	(custom_animation copilot_double objects\characters\marine\marine_cinematics\marine_cinematics "pchair_driver:idle" false)
	(custom_animation intro_odst_1 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_1" false)
	(custom_animation intro_odst_2 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_3" false)
	(custom_animation intro_odst_3 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_2" false)
	(custom_animation intro_odst_4 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_1" false)
	)
	
(script dormant load_pelican_double_1
	(object_create_anew intro_pelican_2)
	(object_cinematic_lod intro_pelican_2 true)
	
	;CINEMATIC LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_pelican_2 1)
	;
	
	(object_create_anew chief_double)
	(object_create_anew_containing odst_double)
	
	(ai_place intro_door_gunner)
	(sleep 5)
	
	(object_uses_cinematic_lighting chief_double 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting odst_double_1 1)
	(object_uses_cinematic_lighting odst_double_2 1)
	(object_uses_cinematic_lighting odst_double_3 1)
	(object_uses_cinematic_lighting odst_double_4 1)
	(object_uses_cinematic_lighting copilot_double 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_pilot_1) 0) 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_door_gunner) 0) 1)
	
	(objects_attach intro_pelican_2 chief_rear chief_double "")
	(objects_attach intro_pelican_2 "pelican_p_l05" odst_double_1 "")
	(objects_attach intro_pelican_2 "pelican_p_l04" odst_double_2 "")
	(objects_attach intro_pelican_2 "pelican_p_r05" odst_double_3 "")
	(objects_attach intro_pelican_2 "pelican_p_r04" odst_double_4 "")
	(vehicle_load_magic intro_pelican_2 "pelican_g" (list_get (ai_actors intro_door_gunner) 0))
	(sleep 5)
	
	(custom_animation chief_double objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "pelican_b:idle" false)
	(custom_animation odst_double_1 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_1" false)
	(custom_animation odst_double_2 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_3" false)	(custom_animation intro_odst_3 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_2" false)
	(custom_animation odst_double_3 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_1" false)
	(custom_animation odst_double_4 objects\characters\marine\marine_cinematics\marine_cinematics "p_alert:sit_3" false)
	)

(script static void cleanup_pelican_double_1
	(object_destroy_containing chief_double)
	(object_destroy_containing odst_double)
	)
		
(script static void load_pelican_double_2
	(object_create_anew chief_double)
	(object_create_anew johnson_double)
	(object_create_anew pilot_double)
	(object_create_anew copilot_double)
	
	(object_set_shadowless chief_double true)
	(object_set_shadowless pilot_double true)
	
	(objects_attach intro_pelican_2 chief_rear chief_double "")
	(objects_attach intro_pelican_2 "johnson" johnson_double "")
	(objects_attach intro_pelican_2 "pelican_d" pilot_double "")
	(objects_attach intro_pelican_2 "pelican_p_copilot" copilot_double "")
	
	(custom_animation chief_double objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "pelican_b:idle" false)
	(custom_animation johnson objects\characters\marine\marine_cinematics\marine_cinematics "sin:johnson_pelican_cockpit" false)
	(custom_animation pilot_double objects\characters\marine\marine_cinematics\marine_cinematics "pchair_driver:idle" false)
	(custom_animation copilot_double objects\characters\marine\marine_cinematics\marine_cinematics "pchair_driver:idle" false)
	
	)
	
(script dormant load_final_pelican

	(object_create_anew chief_double)
	(ai_place intro_door_gunner)
	
	(sleep 5)
	
	(objects_attach intro_pelican_1 chief_rear chief_double "")
	(custom_animation chief_double objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "sin:mc:pelican:idle" false)
	
	(vehicle_load_magic intro_pelican_1 "pelican_g" (list_get (ai_actors intro_door_gunner) 0))
	)
	
(script dormant load_final_odsts
	
	(ai_place intro_odst_1)
	(ai_place intro_odst_2)
	(ai_place intro_odst_3)
	(ai_place intro_odst_4)
	
	(sleep 5)
	
	(vehicle_load_magic intro_pelican_1 "pelican_p_l05" (list_get (ai_actors intro_odst_1) 0))
	(vehicle_load_magic intro_pelican_1 "pelican_p_l04" (list_get (ai_actors intro_odst_2) 0))
	(vehicle_load_magic intro_pelican_1 "pelican_p_r05" (list_get (ai_actors intro_odst_3) 0))
	(vehicle_load_magic intro_pelican_1 "pelican_p_r04" (list_get (ai_actors intro_odst_4) 0))
	)

(script command_script cs_odst_1_unload
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_move_in_direction 270 2 0)
	(cs_go_to odst_unload/p0)
	)
	
(script command_script cs_odst_2_unload
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_move_in_direction 270 2 0)
	(cs_go_to odst_unload/p0)
	)
	
(script command_script cs_odst_3_unload
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_move_in_direction 270 2 0)
	(cs_go_to odst_unload/p1)
	)
	
(script command_script cs_odst_4_unload
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_move_in_direction 270 2 0)
	(cs_go_to odst_unload/p1)
	)

(script dormant unload_final_pelican
;	(vehicle_unload intro_pelican_1 "")
	
	(ai_exit_vehicle intro_odst_1)
	(cs_run_command_script intro_odst_1 cs_odst_1_unload)
	(sleep 5)
	
	(ai_exit_vehicle intro_odst_3)
	(cs_run_command_script intro_odst_3 cs_odst_3_unload)
	(sleep 5)
	
	(ai_exit_vehicle intro_odst_2)
	(cs_run_command_script intro_odst_2 cs_odst_2_unload)
	(sleep 5)
	
	(ai_erase intro_odst_4)
;	(cs_run_command_script intro_odst_4 cs_odst_4_unload)
;	(sleep 5)
	)
	
(script static void cleanup_pelican_double_2
	(object_destroy_containing johnson_double)
	(object_destroy_containing pilot_double)
	)

(script static void intro_1_setup

	(ui_transition_out_console_window)

	(object_create_anew intro_pelican_1)
	(object_cinematic_lod intro_pelican_1 true)
	
	(object_create_anew chief)
	(object_create_anew johnson)
	(object_create_anew copilot_double)
	
	(sleep 5)

	(ai_place intro_pilot_1)
	(vehicle_load_magic intro_pelican_1 "pelican_d" (list_get (ai_actors intro_pilot_1) 0))
	
	(objects_attach intro_pelican_1 chief_rear chief "")
	(objects_attach intro_pelican_1 johnson johnson "")
	(objects_attach intro_pelican_1 "pelican_p_copilot" copilot_double "")
	
	(custom_animation johnson objects\characters\marine\marine_cinematics\marine_cinematics "sin:johnson_pelican_cockpit" false)
	(custom_animation copilot_double objects\characters\marine\marine_cinematics\marine_cinematics "pchair_driver:idle" false)
	
	(sleep 30)

	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1.5)	
	
	(sleep 65)
	
	(object_teleport intro_pelican_1 f_intro_pelican_1)
	;marcus
	(cs_run_command_script intro_pilot_1 cs_pelican_1)
	)

(script dormant intro_2_setup
	(object_teleport intro_pelican_1 f_intro_pelican_2)
	(cs_run_command_script intro_pilot_1 cs_pelican_2)
	)
	
(script dormant intro_vamp	
	(object_teleport intro_pelican_1 f_intro_vamp)
	(cs_run_command_script intro_pilot_1 cs_intro_vamp)
	)
	
(script dormant intro_3_setup
	(ai_place intro_pilot_2)
	
	(object_create_anew intro_pelican_3)
	(object_cinematic_lod intro_pelican_3 true) 
	
	(vehicle_load_magic intro_pelican_3 "pelican_d" (list_get (ai_actors intro_pilot_2) 0))
	(object_teleport intro_pelican_3 f_intro_pelican_3)
	(object_set_scale intro_pelican_3 .8 0)
	(cs_run_command_script intro_pilot_2 cs_pelican_3)
	)
	
(script static void intro_cleanup_1
	(object_destroy_containing johnson)
	(object_destroy_containing chief)
	(object_destroy_containing odst)
	(object_destroy_containing sniper)
	(object_destroy_containing rifle)
	)

(script static void intro_cleanup_2
	(ai_erase intro_pilot_1)
	(ai_erase intro_copilot_1)
	(ai_erase intro_pilot_2)
	(object_destroy intro_pelican_2)
	(object_destroy intro_pelican_3)
	)
	
(script static void intro_cleanup_3
	(object_destroy bm_double)
	(object_destroy_containing lz_dust_small)
	(ai_erase intro_odst_1)
	(ai_erase intro_odst_2)
	(ai_erase intro_odst_3)
	(ai_erase intro_odst_4)
	)

(script static void sniper_setup
	(object_create_anew_containing sniper)
	(object_cinematic_collision sniper_1 true)
	(object_cinematic_collision sniper_2 true)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .4 .3 .2)
	(cinematic_lighting_set_secondary_light 20 180 .1 .1 .3)
	(cinematic_lighting_set_ambient_light .1 .1 .1)
	(object_uses_cinematic_lighting sniper_rifle 1)
	(object_uses_cinematic_lighting sniper_scope 1)
	(object_uses_cinematic_lighting sniper_1 1)
	(object_uses_cinematic_lighting sniper_2 1)
	;

	(objects_attach sniper_1 "right hand" sniper_rifle "")
	
	(object_pvs_activate sniper_1)

	(object_cinematic_lod sniper_1 true)
	(object_cinematic_lod sniper_2 true)

	(object_cinematic_lod sniper_car1 true)
	(object_cinematic_lod sniper_car2 true)
	(object_cinematic_lod sniper_car3 true)
	(object_cinematic_lod sniper_car4 true)
	(object_cinematic_lod sniper_car5 true)
	(object_cinematic_lod sniper_car6 true)
	(object_cinematic_lod sniper_car7 true)

	(custom_animation sniper_1 objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:sniper" false)
	(unit_custom_animation_at_frame sniper_2 objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:spotter" false 120)
	)
	
(script static void make_things_dusty
	;cough! cough!
	(object_create_anew_containing initial_dust)
	)
	
;-INTRO------------------------------------------------------------------------- 

(script static void intro_scene_1

	;PREDICTION pelican, marines, environment
     (object_type_predict_high objects\vhicles\pelican\pelican)
     (object_type_predict_high objects\characters\marine\marine)
     (object_type_predict_high objects\characters\marine\marine_odst\marine_odst)
	(object_type_predict_high objects\characters\masterchief\masterchief)
	(camera_predict camera_predict_1)
     ;END PREDICTION

	(fade_out 0 0 0 0)

	(sound_looping_predict sound\e3\music\e3_music_01\e3_music_01)
	(sound_looping_start sound\e3\music\e3_music_01\e3_music_01 none 1)

	;intro foley 1
	(sound_looping_start sound\e3\foley\e3_intro_foley_01\e3_intro_foley_01 none 1)
	
	(sound_class_set_gain projectile_detonation 0 0)
	(sound_class_set_gain ambient_machinery 0 0)

	(ai_allegiance human player)
	
	(object_teleport (list_get (players) 0) johnson_player)
	
	(cinematic_start)
	(camera_control on)
	
	(wake load_pelican_double_1)
	
	(sleep 30)
	
	(object_teleport intro_pelican_2 f_intro_camera_1)
	(object_pvs_activate intro_pelican_2)
	
	(custom_animation intro_pelican_2 objects\vehicles\pelican\animations\e3\e3 "e3_pelican_flyby1" false)
	(camera_set_animation_relative scenarios\solo\earthcity\earthcity_e3\cinematics\camera\camera "camerapelican_flyby1" none f_intro_camera_1)
	(vehicle_engine_hack intro_pelican_2 true 1)
	
	(object_create_anew earthcity_scenery)
	(object_create_anew clouds_scenery)
	
	(cinematic_screen_effect_set_bloom .6 0 0 1 1)
	(cinematic_screen_effect_start 0)
	
	(sleep 30)
	
	(fade_in 0 0 0 60)
	
	(sleep 60)
	(super_in)

	(sleep 90)
	
;	(ui_dispose)
	
	(intro_1_setup)
	
	(sleep 15)
	
	(wake intro_chief_reveal)
	
	(cleanup_pelican_double_1)
	
	(sleep_until g_intro 5)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	(object_destroy intro_pelican_2)
	
	(object_pvs_activate johnson)
	
	(object_destroy earthcity_scenery)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .7 .5 .3)
	(cinematic_lighting_set_secondary_light 20 100 .2 .2 .4)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_pilot_1) 0) 1)
	;
	
	(camera_set_relative intro_johnson_1 0 intro_pelican_1)
	(camera_set_relative intro_johnson_2 120 intro_pelican_1)
	
	(sleep 1)
	
	;MOVING SOUND
;	(sound_impulse_start sound\e3\dialog\e3_100_johnson none 1)
	(sleep (- (sound_impulse_time sound\e3\dialog\e3_100_johnson) 2))
	
	(sound_impulse_start sound\e3\dialog\e3_110_johnson none 0)
	(sleep (sound_impulse_time sound\e3\dialog\e3_110_johnson))
	;MOVING SOUND

	(player_effect_stop 0)
	
	(object_create_anew intro_pelican_2)
	(object_cinematic_lod intro_pelican_2 true)
	
	(object_pvs_activate intro_pelican_2)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .6 .5 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_pelican_2 1)
	(object_uses_cinematic_lighting clouds_scenery 1)
	;
	
	(object_teleport intro_pelican_2 f_intro_camera_3)
	(custom_animation intro_pelican_2 objects\vehicles\pelican\animations\e3\e3 "e3_pelican_flyby3" false)
	(camera_set_animation_relative scenarios\solo\earthcity\earthcity_e3\cinematics\camera\camera "camerapelican_flyby3" intro_pelican_2 f_intro_camera_3)
	(vehicle_engine_hack intro_pelican_2 true 1)

	(object_teleport intro_pelican_1 f_intro_pelican_2)
	(sleep 90)
	
	;PREDICTION pelican, marines, environment
	(shader_predict scenarios\skies\solo\earthcity\shaders\ec_sky_dome)
	(bitmap_predict "scenarios\skies\solo\earthcity\bitmaps\ec_sky_dome")
	(shader_predict "scenarios\shaders\human\urban\metals\street_highway_border")
	(shader_predict "scenarios\shaders\human\urban\metals\street_highway_bottom")
	(shader_predict "objects\vehicles\uberchassis\shaders\uberchassis_body")
	(bitmap_predict "effects\decals\bullet_holes\bitmaps\destruction_crack")
	(bitmap_predict "effects\decals\bullet_holes\bitmaps\wall_cracks")
	(bitmap_predict "effects\decals\bullet_holes\bitmaps\metal")
	(object_type_predict_high objects\characters\marine\marine)
     (object_type_predict_high objects\vehicles\uberchassis\uberchassis)
     (object_type_predict_high scenarios\objects\human\military\sniper_rifle\cinematic_sniper_rifle)
     (object_type_predict_high scenarios\objects\human\military\spotting_scope\spotting_scope)
  	(camera_predict intro_snipers_1a)
	;
	(print "sniper predict")
     
     (sleep 45)

	(fade_out 1 1 1 15)
	(sleep 15)
	)
	
(script static void intro_scene_2
	
	(object_destroy clouds_scenery)
	
	(sniper_setup)
	
	(wake hostile_fire_2)
	
	(camera_set intro_snipers_1a 0)
	(camera_set_pan intro_snipers_1b 180)
	
	(cinematic_screen_effect_stop)
	
	(fade_in 1 1 1 15)
	
	(sleep 60)
	
	(custom_animation sniper_2 objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:spotter" false)
	(sound_impulse_start sound\e3\dialog\e3_120_sniper sniper_2 1)
	
	(sleep 30)
	
	(camera_pan intro_snipers_2b intro_snipers_2a 90 0 1 45 0)
	
	;intro foley 2
	(sound_looping_start sound\e3\foley\e3_intro_foley_02\e3_intro_foley_02 none 1)
	
	(object_create_anew intro_pelican_2)
	(object_cinematic_lod intro_pelican_2 true)
	
	(object_pvs_activate intro_pelican_2)
	
	(object_teleport intro_pelican_2 f_intro_pelican_2)
	(custom_animation intro_pelican_2 objects\vehicles\pelican\animations\e3\e3 "e3_pelican_flyby4" false)
	(vehicle_engine_hack intro_pelican_2 true 1)
	
	;PREDICTION
	(shader_predict "objects\characters\marine\shaders\marine_standard")
	(object_type_predict_high objects\characters\marine\marine)
	(camera_predict camera_predict_3)	;
	
	(sleep 45)
		
	(sleep (sound_impulse_time sound\e3\dialog\e3_120_sniper))
	
	(load_pelican_double_2)
	
	(cinematic_screen_effect_stop)
	
	(camera_set_relative intro_sniper_flyover_1 0 intro_pelican_2)

	(custom_animation pilot_double objects\characters\marine\marine_cinematics\marine_cinematics "sin:pilot_pelican_console" false)
	
	(sound_impulse_start sound\e3\dialog\e3_130_dspilot none 1)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	;PREDICTION
	(camera_predict intro_snipers_rev_1)
	;END PREDICTION

	(sleep 90)

	(load_tactical_pelican)
	
	(object_hide chief true)
	(object_hide intro_odst_1 true)
	(object_hide intro_odst_2 true)
	(object_hide intro_odst_3 true)
	(object_hide intro_odst_4 true)
	
	(player_effect_stop 0)

	(wake hostile_fire_1)
	
	(object_hide johnson_double true)
	(object_hide copilot_double true)

	(camera_set intro_snipers_rev_1 0)
	(camera_set intro_snipers_rev_1b 164)
	
	;JAY!
	;(sleep 45)
	(sleep 15)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1.5)
	
	;JAY!
	(sleep 30)
	
	(wake intro_vamp)
	
	(sleep 30)
	
	(custom_animation johnson objects\characters\marine\marine_cinematics\marine_cinematics "sin:johnson_pelican_tactica" false)
	
	(object_hide copilot_double false)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 35 20 .6 .5 .4)
	(cinematic_lighting_set_secondary_light 20 160 .3 .1 .1)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_pilot_1) 0) 1)
	;
	
	(camera_set_relative intro_pilot_johnson_1 0 intro_pelican_1)
	
	(object_pvs_activate intro_pelican_1)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	(sleep 1)
	
	(sound_impulse_start sound\e3\dialog\e3_140_dspilot (list_get (ai_actors intro_pilot_1) 0) 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_140_dspilot))	
	
	(sleep 41)
	
	(sound_impulse_start sound\e3\dialog\e3_150_johnson none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_150_johnson))

	;PREDICT
	(object_type_predict_high objects\characters\marine\marine_odst\marine_odst)
     (object_type_predict_high scenarios\objects\human\military\sniper_rifle\cinematic_sniper_rifle)
     (object_type_predict_high objects\weapons\rifle\battle_rifle\battle_rifle)
	;END PREDICT

	;JAY!
	;(sleep 48)
	
	(wake cockpit_fire)
	
	(sleep 29)
	
	(object_hide chief false)
	(object_hide intro_odst_1 false)
	(object_hide intro_odst_2 false)
	(object_hide intro_odst_3 false)
	(object_hide intro_odst_4 false)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_secondary_light 16 330 .1 .1 .2)
	(cinematic_lighting_set_primary_light 20 160 .3 .3 .1)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_pilot_1) 0) 1)
	;

	(camera_set_relative intro_get_tactical_1 0 intro_pelican_1)
	
;	(cinematic_screen_effect_set_bloom 1 0 0 1 1)
;	(cinematic_screen_effect_start 0)
	
	(sound_impulse_start sound\e3\dialog\e3_160_johnson none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_160_johnson))
	
	;JAY!	
	(sleep 19)
	
	(object_teleport intro_pelican_1 f_intro_vamp)
	
	(sound_impulse_start sound\e3\dialog\e3_170_cor none 1)
	
	(object_create_anew rifle_1)
	(object_create_anew rifle_2)
	(objects_attach intro_odst_1 "right hand" rifle_1 "")
	(objects_attach intro_odst_2 "right hand" rifle_2 "")
	(custom_animation intro_odst_1 objects\characters\marine\marine_cinematics\marine_cinematics "sin:pelican:odst:l_04" false)
	(custom_animation intro_odst_2 objects\characters\marine\marine_cinematics\marine_cinematics "sin:pelican:odst:l_05" false)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 10 90 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 300 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_odst_1 1)
	(object_uses_cinematic_lighting intro_odst_2 1)
	(object_uses_cinematic_lighting rifle_1 1)
	(object_uses_cinematic_lighting rifle_2 1)
	;
	
	(camera_set_relative intro_odst_1a 0 intro_pelican_1)
	
	;intro foley 3
	(sound_looping_start sound\e3\foley\e3_intro_foley_03\e3_intro_foley_03 none 1)
	
	(sleep 60)
	
	(object_create_anew sniper_rifle)
	(objects_attach intro_odst_4 "right hand" sniper_rifle "")
	
	(object_create_anew sniper_rifle_magazine)
	(objects_attach intro_odst_4 "left_hand" sniper_rifle_magazine "left_hand")
	
	(custom_animation intro_odst_4 objects\characters\marine\marine_cinematics\marine_cinematics "sin:pelican:odst:r_04" false)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 20 85 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 280 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_odst_4 1)
	(object_uses_cinematic_lighting sniper_rifle 1)
	;
	
	(camera_set_relative intro_odst_2a 0 intro_pelican_1)
	
	(sleep 19)
		
	(wake intro_3_setup)
	
	(sleep 58)
	
	(object_create_anew helmet_odst)
	(objects_attach intro_pelican_1 "pelican_p_r05" helmet_odst "")
	
	(object_create_anew rifle_1)
	(objects_attach chief "right hand" rifle_1 "")
	
	(scenery_animation_start helmet_odst objects\characters\marine\marine_odst\helmet\helmet "pelican:odst:r_05:helmet")
	(custom_animation intro_odst_3 objects\characters\marine\marine_cinematics\marine_cinematics "sin:pelican:odst:r_05" false)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light -10 140 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 0 .2 .2 .4)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting helmet_odst 1)
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting intro_odst_3 1)
	;
	
	(camera_set_relative intro_odst_3a 0 intro_pelican_1)
	
	(wake troopbay_fire)
	
;	(sleep (sound_impulse_time sound\e3\dialog\e3_170_cor))
	(sleep 85)
	
	(player_effect_stop 0)
	(cinematic_screen_effect_stop)
	
	(wake hostile_fire_3)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_pelican_3 1)
	;
	
	(camera_set intro_pelican_track_1 0)
	(camera_pan intro_pelican_track_1 intro_pelican_track_2 175 0 1 60 0)
	
	(print "insert cross-fade here")
	
	(object_teleport intro_pelican_1 f_intro_vamp)
	
	(intro_cleanup_1)
	
	(sleep 100)
	
	)
	
(script static void intro_scene_3
	
	(object_create_anew intro_pelican_1)
	(object_cinematic_lod intro_pelican_1 true)
	
	(object_pvs_activate intro_pelican_1)
	
	(wake load_final_pelican)
	
	;PREDICTION pelican, marines, environment
     (object_type_predict scenarios\objects\solo\earthcity\watercloset\watercloset)
     (object_type_predict_high objects\characters\marine\marine)
	(camera_predict intro_final_approach_1)
     ;END PREDICTION
	
	(sleep 74)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_crossfade 1)
	
	(sleep 1)
	
	(custom_animation intro_pelican_1 objects\vehicles\pelican\animations\e3\e3 "e3_pelican_landing" false)
	(vehicle_engine_hack intro_pelican_1 true 1)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_pelican_1 1)
	;
	
	(object_hide chief_double true)
	(object_hide (list_get (ai_actors intro_door_gunner) 0) true)
	
	(camera_pan intro_final_approach_1 intro_final_approach_2 90 0 1 30 0)
	
	(intro_cleanup_2)
	
	(sleep 75)
	
	(object_create_anew bm_double)
	(object_pvs_activate bm_double)
	
	(custom_animation bm_double objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:dust:idle" false)
	
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 0 0 0.001 0.45 0.45 0.001)
	
	(player_effect_set_max_rotation 0 1 1)
;	(player_effect_set_max_translation 0 0 .005)
	(player_effect_start .25 0)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_pelican_1 1)
	;
	
	(object_hide chief_double false)
	(object_hide (list_get (ai_actors intro_door_gunner) 0) false)
	
	(camera_set intro_bm_flyover_1a 0)
	(camera_set intro_bm_flyover_1b 60)
	
	(sleep 30)
	(vehicle_engine_hack intro_pelican_1 true 0.5)
	
	(cinematic_screen_effect_set_depth_of_field 1 0 0.45 0.5 0.45 0 0.5)
	(sleep 30)
	
	(cinematic_screen_effect_stop)
	
	(camera_set intro_rear_gear_1a 0)
	
	(object_create_anew_containing lz_dust_small)
	(object_create_anew lz_dust_large_stretcher)
	
	(sleep 30)
	
	(vehicle_engine_hack intro_pelican_1 true 0)
	;charlie is a royal pain in the arse
	
	;PREDICTION pelican, marines, environment
     (object_type_predict_high objects\characters\marine\marine)
     (object_type_predict_high objects\characters\marine\marine_odst\marine_odst)
     ;END PREDICTION

	(bitmap_predict "objects\vehicles\pelican\bitmaps\pelican_bump")
	(sleep 30)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .25 .2 .1)
	(cinematic_lighting_set_secondary_light 20 180 .1 .1 .3)
	(cinematic_lighting_set_ambient_light .1 .1 .1)
	(object_uses_cinematic_lighting intro_pelican_1 1)
	;
	
	(camera_set intro_front_gear_1a 0)
	
	(bitmap_predict "objects\vehicles\pelican\bitmaps\pelican_bump")
	(sleep 45)
	
	(custom_animation bm_double objects\characters\marine\marine_cinematics\marine_cinematics "sin:perez:dust:look" false)
	
	(camera_set intro_bm_shield_1a 0)
	
	(wake load_final_odsts)
	
	(bitmap_predict "objects\vehicles\pelican\bitmaps\pelican_bump")
	
	(sleep 43)
	
	(player_effect_stop 0)
	
	(camera_set intro_dust_1 0)
	(camera_set_pan intro_dust_2 46)
	
	(sound_impulse_start sound\e3\dialog\e3_180_johnson none 1)
	
	(wake unload_final_pelican)
	
	(wake field_hospital_setup)
	
	(sleep 46)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)	
	
	(object_create_anew rifle_1)
	(objects_attach chief_double "right hand" rifle_1 "")
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .5 .4 .3)
	(cinematic_lighting_set_secondary_light 20 180 .2 .2 .4)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting intro_pelican_1 0)
	(object_uses_cinematic_lighting chief_double 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_odst_1) 0) 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_odst_2) 0) 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_odst_3) 0) 1)
	(object_uses_cinematic_lighting (list_get (ai_actors intro_odst_4) 0) 1)
	;
	
	(camera_set intro_chief_unload_1 0)
	(camera_pan intro_chief_unload_1 intro_chief_unload_2 90 0 1 30 0)
;	(camera_set intro_chief_unload_2 120)
	
	(custom_animation chief_double objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "sin:mc:pelican:exit" true)
	
	(sleep 75)
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_teleport (list_get (players) 0) e3_start)
	
	(intro_cleanup_3)
	
	(cinematic_stop)
	(camera_control off)
	
	(player_effect_stop 0)
	
	(joe_mission_start)
	
	;PREDICTION first person stuff
     (object_type_predict objects\characters\masterchief\fp\fp)
     (object_type_predict scenarios\objects\solo\earthcity\medical_ivstand\medical_ivstand)
     (object_type_predict scenarios\objects\human\military\stretcher_low\stretcher_low)
     (object_type_predict objects\weapons\rifle\smg\smg)
	(camera_predict camera_predict_2)
     ;END PREDICTION
	
	(make_things_dusty)
	
	(sound_class_set_gain "weapon_ready" 1 0)
	(sound_class_set_gain projectile_detonation 1 1)
	(sound_class_set_gain ambient_machinery 1 1)
	
	(sleep 15)
	
	(fade_in 1 1 1 15)
	
	(wake lz_fire)
	
	(sleep 30)
	
	(sound_impulse_start sound\e3\dialog\e3_190_johnson none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_190_johnson))
	
	(sound_impulse_start sound\e3\dialog\e3_200_cor none 1) 
	(sleep (sound_impulse_time sound\e3\dialog\e3_200_cor))
	
	)
	
(script static void intro
	(intro_scene_1)
	(intro_scene_2)
	(intro_scene_3)
	)

;-OUTRO AI--------------------------------------------------------------

(script command_script chief_ghost_outro_1		
	(cs_ignore_obstacles 1)
	(cs_go_to ghost_chase/10)
	(cs_go_to ghost_chase/12)
	)

(script command_script cs_b_outro_11		
	(cs_ignore_obstacles 1)
	(cs_go_to ghost_chase/10)
	(cs_go_to ghost_chase/12)
	)

(script command_script cs_b_outro_21		
	(cs_ignore_obstacles 1)
	(cs_go_to ghost_chase/10)
	(cs_go_to ghost_chase/12)
	)
	
(script command_script cs_b_outro_31		
	(cs_ignore_obstacles 1)
	(cs_go_to ghost_chase/10)
	(cs_go_to ghost_chase/12)
	)
	
(script command_script cs_phantom_3_fly
	(cs_ignore_obstacles 1)
	
	(cs_fly_by dropship_chase/p01)
	(cs_fly_by dropship_chase/p20)
	)
	
(script command_script cs_phantom_3_shoot
	(cs_enable_targeting true)
	(cs_shoot true (ai_vehicle_get chief_1/driver0))
	(sleep 32000)
	)

(script dormant outro_setup_1

	(ai_place chief_1)
	(ai_place b_outro_11)
	(ai_place b_outro_21)
	(ai_place b_outro_31)
	(ai_place phantom_3)
	
	(object_cinematic_lod (list_get (ai_actors chief_1) 0) 1)
	(object_cinematic_lod (list_get (ai_actors b_outro_11) 0) 1)
	(object_cinematic_lod (list_get (ai_actors b_outro_21) 0) 1)
	(object_cinematic_lod (list_get (ai_actors b_outro_31) 0) 1)
	(object_cinematic_lod (list_get (ai_actors phantom_3) 0) 1)
	
	(sleep 5)
	
	(object_set_velocity (ai_vehicle_get chief_1/driver0) 7 0 1)
	(object_set_velocity (ai_vehicle_get b_outro_11/driver0) 7 0 1)
	(object_set_velocity (ai_vehicle_get b_outro_21/driver0) 7 0 1)
	(object_set_velocity (ai_vehicle_get b_outro_31/driver0) 7 0 1)
	
	(cs_run_command_script chief_1 chief_ghost_outro_1)
	(cs_run_command_script b_outro_11 cs_b_outro_11)
	(cs_run_command_script b_outro_21 cs_b_outro_21)
	(cs_run_command_script b_outro_31 cs_b_outro_31)
	
	(cs_run_command_script phantom_3/driver0 cs_phantom_3_fly)
	(cs_run_command_script phantom_3/gunner0 cs_phantom_3_shoot)
	)
	
(script command_script cs_p_outro_1
	(cs_enable_pathfinding_failsafe 1)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 4)
	(cs_fly_by dropship_chase/p11)
	(cs_fly_by dropship_chase/p12)
	)
	
(script command_script cs_p_outro_2
	(cs_enable_pathfinding_failsafe 1)
	(cs_fly_by dropship_chase/p21)
	(cs_fly_by dropship_chase/p22)
	(cs_fly_to dropship_chase/p23)
	)
	
(script command_script cs_p_outro_3
	(cs_enable_targeting true)
	(cs_shoot true chief_ghost)
	(sleep 32000)
	)

(script dormant outro_setup_2

	(object_create_anew outro_phantom_1)
	
	(ai_place phantom_1)
	(ai_place phantom_gunner_1)
	(ai_place phantom_gunner_2)
	(ai_place phantom_2)
	
	(object_cinematic_lod outro_phantom_1 1)
	(object_cinematic_lod (list_get (ai_actors phantom_2) 0) 1)
	
	(sleep 5)
	
	(vehicle_load_magic outro_phantom_1 "phantom_d" (list_get (ai_actors phantom_1) 0))
	(vehicle_load_magic outro_phantom_1 "phantom_g_l" (list_get (ai_actors phantom_gunner_1) 0))
	(vehicle_load_magic outro_phantom_1 "phantom_g_r" (list_get (ai_actors phantom_gunner_2) 0))
	
	(sleep 5)
	
	(object_teleport outro_phantom_1 f_outro_phantom_start)
	
	(object_set_velocity (ai_vehicle_get phantom_2/driver0) 4)
	
	(cs_run_command_script phantom_1 cs_p_outro_1)
	(cs_run_command_script phantom_2 cs_p_outro_2)
	(cs_run_command_script phantom_gunner_2 cs_p_outro_3)
	)
	
(script command_script chief_ghost_outro_2
	(object_set_velocity (ai_vehicle_get ai_current_actor) 7 0 1)
	(cs_ignore_obstacles 1)
	
	(cs_go_to ghost_chase/21 3)
	(cs_go_to ghost_chase/22 3)
	(cs_go_to ghost_chase/23 3)
	(cs_go_to ghost_chase/24 3)
	(cs_go_to ghost_chase/25 3)
	(cs_go_to ghost_chase/26 3)
	(cs_go_to ghost_chase/27 3)
	(cs_go_to ghost_chase/28 3)
	(cs_go_to ghost_chase/29 3)
	)

(script command_script cs_b_outro_12
	(cs_ignore_obstacles 1)
	
	(cs_shoot true chief_ghost)
	
	(cs_go_to ghost_chase/21 3)
	(cs_go_to ghost_chase/22 3)
	(cs_go_to ghost_chase/23 3)
	(cs_go_to ghost_chase/24 3)
	(cs_go_to ghost_chase/25 3)
	(cs_go_to ghost_chase/26 3)
	(cs_go_to ghost_chase/27 3)
	(cs_go_to ghost_chase/28 3)
	(cs_go_to ghost_chase/29 3)
	)

(script command_script cs_b_outro_22
	(cs_ignore_obstacles 1)
	
;	(cs_shoot true chief_ghost)
	
	(cs_go_to ghost_chase/21 3)
	(cs_go_to ghost_chase/22 3)
	(cs_go_to ghost_chase/23 3)
	(cs_go_to ghost_chase/24 3)
	(cs_go_to ghost_chase/25 3)
	(cs_go_to ghost_chase/26 3)
	(cs_go_to ghost_chase/27 3)
	(cs_go_to ghost_chase/28 3)
	(cs_go_to ghost_chase/29 3)
	)
	
(script command_script cs_b_outro_32
	(cs_ignore_obstacles 1)
	
	(cs_go_to ghost_chase/21 3)
	(cs_go_to ghost_chase/22 3)
	(cs_go_to ghost_chase/23 3)
	(cs_go_to ghost_chase/24 3)
	(cs_go_to ghost_chase/25 3)
	(cs_go_to ghost_chase/26 3)
	(cs_go_to ghost_chase/27 3)
	(cs_go_to ghost_chase/28 3)
	(cs_go_to ghost_chase/29 3)
	)

(script dormant outro_setup_3

	(object_create_anew chief_ghost)
	(object_pvs_activate chief_ghost)
	
	(ai_place chief_2)
	
	(unit_impervious (ai_actors chief_2) true)
	(object_cannot_take_damage (list_get (ai_actors chief_2) 0))
	(object_cannot_take_damage chief_ghost)
	
	(ai_place b_outro_12)
	(ai_place b_outro_22)
	(ai_place b_outro_32)
	
	(sleep 5)
	
	(vehicle_load_magic chief_ghost "ghost_d" (list_get (ai_actors chief_2) 0))

	(object_set_velocity chief_ghost 12 0 1)
	(object_set_velocity (ai_vehicle_get b_outro_12/driver0) 12 0 1)
	(object_set_velocity (ai_vehicle_get b_outro_22/driver0) 12 0 1)
	(object_set_velocity (ai_vehicle_get b_outro_32/driver0) 12 0 1)
	
	(cs_run_command_script chief_2 chief_ghost_outro_2)
	(cs_run_command_script b_outro_12 cs_b_outro_12)
	(cs_run_command_script b_outro_22 cs_b_outro_22)
	(cs_run_command_script b_outro_32 cs_b_outro_32)
	)
	
(script command_script cs_b_outro_13
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	
	(cs_go_to ghost_chase/31_1)
	
	; ouch!
	(unit_kill (ai_vehicle_get ai_current_actor))
	)
	
(script command_script cs_b_outro_23
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	
	(cs_go_to ghost_chase/31_2)
	
	; mommy!
	(unit_kill (ai_vehicle_get ai_current_actor))
	)
	
(script command_script cs_phantom_shoot_sign
	(cs_force_combat_status 4)
	(cs_shoot_point true sign_target/shoot_this)
	(sleep 32000)
	)
	
(script command_script cs_phantom_shoot_chief
	(cs_shoot true chief_ghost)
	(sleep 32000)
	)
	
(script command_script cs_phantom_shoot_stop
	(cs_shoot false)
	(cs_pause 32000)
	)
	
(script dormant streetage
	(cs_run_command_script shorty_mc_deadeye cs_phantom_shoot_chief)
	)
	
(script static void stoppage
	(cs_run_command_script shorty_mc_deadeye cs_phantom_shoot_stop)
	)

(script dormant brute_death_setup

	(ai_place b_outro_13)
	(ai_place b_outro_23)
	
	(object_create_anew_containing b_ghost)
	
	(sleep 5)
	
	(vehicle_load_magic b_ghost_1 "ghost_d" (list_get (ai_actors b_outro_13) 0))
	(vehicle_load_magic b_ghost_2 "ghost_d" (list_get (ai_actors b_outro_23) 0))
	
	(cs_run_command_script b_outro_13 cs_b_outro_13)
	(cs_run_command_script b_outro_23 cs_b_outro_23)
	; look out for that bloom effect!
	)

;-OUTRO PODS----------------------------------------------------------- 

(script dormant distant_pods
	
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_11)
	(sleep 30)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_21)
	(sleep 30)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_31)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_41)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_51)
	
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_22)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_12)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_32)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_42)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_52)
	(sleep 10)
	
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_33)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_23)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_13)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_53)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_43)
	
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_14)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_34)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_distant_pod_24)
	)
	
(script dormant turn_pods
	(effect_new effects\explosions\cloud_light1 f_turn_pod_1)
	(sleep 2)
	(effect_new effects\explosions\cloud_light2 f_turn_pod_2)
	(sleep 1)
	(effect_new effects\explosions\cloud_ligh3 f_turn_pod_3)
	(sleep 2)
	(effect_new effects\explosions\cloud_light1 f_turn_pod_4)
	)
	
(script dormant pass_pods

	(sleep 30)
	
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_11)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_21)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_31)
	(sleep 10)
	
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_12)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_22)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_32)
	(sleep 10)
	
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_13)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_23)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_33)
	(sleep 10)
	
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_14)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_24)
	(sleep 5)
	(effect_new effects\bursts\pod_distant_burst f_pass_pod_34)
	(sleep 10)
	)

(script dormant close_pods_1

	(object_create_anew_containing outro_pod_scenery)
	
	;CINEMATIC_LIGHTING
	(object_uses_cinematic_lighting outro_pod_scenery_1 1)
	(object_uses_cinematic_lighting outro_pod_scenery_2 1)
	(object_uses_cinematic_lighting outro_pod_scenery_3 1)
	(object_uses_cinematic_lighting outro_pod_scenery_4 1)
	(object_uses_cinematic_lighting outro_pod_scenery_5 1)
	(object_uses_cinematic_lighting outro_pod_scenery_6 1)
	;
	
	(scenery_animation_start outro_pod_scenery_4 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_4 f_outro_pod_close_2)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_4 "exhaust")
	(sleep 10)
	
	(scenery_animation_start outro_pod_scenery_1 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_1 f_outro_pod_1)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_1 "exhaust")
	(sleep 10)
	
	(scenery_animation_start outro_pod_scenery_3 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_3 f_outro_pod_3)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_3 "exhaust")
	(sleep 10)
	
	(scenery_animation_start outro_pod_scenery_6 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_6 f_outro_pod_close_1)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_6 "exhaust")
	(sleep 5)
	
	(scenery_animation_start outro_pod_scenery_2 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_2 f_outro_pod_2)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_2 "exhaust")
	(sleep 5)
	
	; 45 ticks
	(sleep 15) 
	(effect_new effects\impact\pod_impact f_outro_pod_close_2)
	
	(sleep 11)
	(effect_new effects\impact\pod_impact f_outro_pod_1)
	
	(sleep 11)
	(effect_new effects\impact\pod_impact f_outro_pod_3)
	
	(sleep 6)
	(effect_new effects\impact\pod_impact f_outro_pod_close_1)
	
	(sleep 6)
	(effect_new effects\impact\pod_impact f_outro_pod_2)
	
	)

(script dormant close_pods_2

	(object_create_anew outro_pod_scenery_6)
	(object_create_anew outro_pod_scenery_4)

	(scenery_animation_start outro_pod_scenery_5 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_5 f_outro_pod_5)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_5 "exhaust")
	(sleep 5)

	(scenery_animation_start outro_pod_scenery_4 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_4 f_outro_pod_4)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_4 "exhaust")
	(sleep 5)
	
	(scenery_animation_start outro_pod_scenery_6 objects\vehicles\insertion_pod\insertion_pod "e3_pod_landing")
	(sleep 1)
	(object_teleport outro_pod_scenery_6 f_outro_pod_6)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\pod_exhaust outro_pod_scenery_6 "exhaust")
	
	; 13 ticks
	(sleep 47) 
	(effect_new effects\impact\pod_impact f_outro_pod_5)
	
	(sleep 6)
	(effect_new effects\impact\pod_impact f_outro_pod_4)
	
	(sleep 6)
	(effect_new effects\impact\pod_impact f_outro_pod_6)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 0)
	(player_effect_stop 1.5)
	
	)
	
;-OUTRO SMGS, ENERGY BLADES & GRENADE SETUP----------------------------------------------------------- 

(script static void smg_setup
	(object_create_anew_containing smg)
	(scenery_animation_start outro_smg_1 objects\weapons\rifle\smg\fp_smg\fp_smg_cinematics\fp_smg_cinematics "smg:idle")
	(scenery_animation_start outro_smg_2 objects\weapons\rifle\smg\fp_smg\fp_smg_cinematics\fp_smg_cinematics "smg:idle")
	(objects_attach chief "right hand" outro_smg_1 "")
	(objects_attach chief "left hand" outro_smg_2 "")
	)

(script static void grenade_setup
	(object_create_anew outro_grenade)
	(objects_attach chief "right hand" outro_grenade "")
	)

;-OUTRO SCENES------------------------------------------------------------------

(script static void outro_scene_1

	(sound_class_set_gain "weapon_ready" 0 0)
	(sound_class_set_gain "weapon_fire" .7 0)

	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy_type_mask 63)
	
	(cinematic_start)
	(camera_control on)
	
	(object_teleport (list_get (players) 0) johnson_player)
	
	(camera_set outro_onramp_1 0)
	(object_pvs_set_camera outro_onramp_1)
	
	(wake outro_setup_1)

	;JAY!
	(sleep 15)
	
	(sound_looping_start sound\e3\music\e3_outro_music\e3_outro_music none 1)

	;JAY!
	(sleep 15)

	(fade_in 1 1 1 15)
	
	(camera_set outro_onramp_2 180)
	
	(print "fade in")
	
	(sleep 120)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 0)
	(player_effect_stop 1.5)
	
	(wake outro_setup_2)
	(wake outro_setup_3)
	
	(camera_set outro_onramp_3 60)
	
	(sleep 60)

	(ai_erase chief_1)
	(ai_erase b_outro_11)
	(ai_erase b_outro_21)
	(ai_erase b_outro_31)
	
	(player_effect_set_max_rotation 0 0.5 0.5)	
	(player_effect_start .25 0)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting chief_ghost 1)
	(object_uses_cinematic_lighting (list_get (ai_actors chief_2) 0) 1)
	;
	
	(camera_set_relative outro_ghost_chase_2a 0 chief_ghost)
	(camera_set_relative outro_ghost_chase_2 45 chief_ghost)
	
	(ai_erase phantom_3)
	
	(custom_animation (ai_get_unit chief_2) objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_mc_shoulder" false)
	
	;PREDICTION
	(object_type_predict_high objects\vehicles\phantom\phantom)
	;END PREDICTION
	
	(sleep 45)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .1 .1 .3)
	(cinematic_lighting_set_ambient_light .05 .05 .05)
	(object_uses_cinematic_lighting outro_phantom_1 1)
	(object_uses_cinematic_lighting (list_get (ai_actors phantom_2) 0) 1)
	;
	
	(camera_set_relative outro_phantom_gun_dolly_1 0 outro_phantom_1)
	
	(sleep 75)
	
	(player_effect_stop 0)
	
	(camera_set outro_phantom_pass_1 0)
	(camera_set outro_phantom_pass_2 90)
	(sleep 90)
	
;	(player_effect_stop 0)
	
	(camera_set outro_highway_low_2 0)
	(camera_set_pan outro_highway_low_1 60)
	(sleep 60)
	
;	(player_effect_set_max_rotation 0 1 1)
;	(player_effect_start .5 0)
;	(player_effect_stop 1.5)
	
	(camera_set_relative chief_bh_approach_1 0 chief_ghost)
	(camera_set_relative chief_bh_approach_2 90 chief_ghost)

	(sleep_until (volume_test_objects tv_outro_bh_1 chief_ghost) 1)

	)
	
(script dormant phantom_fiery_death
	(sleep 90)
	(effect_new_on_object_marker effects\fire\spark_long falling_sign "marker_up")
	
	;95
	(sleep 5)
	(effect_new_on_object_marker effects\explosions\elec_explosion_sparks falling_sign "sparks1")
	
	;136
	(sleep 41)  
	(effect_new_on_object_marker effects\explosions\elec_explosion_sparks falling_sign "sparks2")
	
	;199
	(sleep 63)
	(effect_new_on_object_marker effects\explosions\elec_explosion_sparks falling_sign "elec_explosion_sparks")
	
	;224
	(sleep 25)
	(effect_new_on_object_marker effects\explosions\elec_explosion falling_sign "elec_explosion")
	
	(sleep 15)
	(print "boom")
	(effect_new_on_object_marker effects\vehicles\creep\c_hull_destroyed_large outro_phantom_1 "phantom_small_target02")
	
	;249
	(sleep 10)
	(effect_new_on_object_marker effects\explosions\elec_explosion_sparks falling_sign "elec_explosion_sparks3")
	
	;252  
	(sleep 3)
	(effect_new_on_object_marker effects\explosions\elec_explosion_sparks falling_sign "elec_explosion_sparks2")
	
	;291
	(sleep 39)
	(effect_new_on_object_marker effects\vehicles\creep\c_hull_destroyed_large outro_phantom_1 "")
	
	;300
	(sleep 9)
;	(effect_new_on_object_marker effects\explosions\elec_explosion_sparks fallling_sign "smoke2")
	
	;350
	(sleep 50)
	(effect_new effects\explosions\gun_tower_explosion f_phantom_explosion)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1.5)
	
	)

(script static void outro_scene_2
	
	(sound_class_set_gain projectile_detonation 0 0)

	(ai_erase phantom_1)
	(ai_erase phantom_gunner_1)
	(ai_erase phantom_gunner_2)
	(ai_erase phantom_2)

	(object_create_anew outro_phantom_1)
	(object_create_anew outro_phantom_2)
	(object_create_anew falling_sign)
	
	(ai_place shorty_mc_oneeye)
	(ai_place shorty_mc_deadeye)
	(sleep 1)
	
	(vehicle_load_magic outro_phantom_1 "phantom_d" (list_get (ai_actors shorty_mc_oneeye) 0))
	(vehicle_load_magic outro_phantom_1 "phantom_g_r" (list_get (ai_actors shorty_mc_deadeye) 0))
	
	(custom_animation outro_phantom_1 objects\vehicles\phantom\animations\e3\e3 "phantomsigncrush" false)
	(custom_animation outro_phantom_2 objects\vehicles\phantom\animations\e3\e3 "phantombuildingcrash" false)
	(scenery_animation_start falling_sign scenarios\objects\solo\earthcity\sign_falling\sign_falling "falling")
	
	(cs_run_command_script shorty_mc_deadeye cs_phantom_shoot_sign)
	
	(vehicle_engine_hack outro_phantom_1 true 1)
	(unit_set_actively_controlled outro_phantom_1 true)
	
	(wake phantom_fiery_death)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .1 .1 .3)
	(cinematic_lighting_set_ambient_light .05 .05 .05)
	(object_uses_cinematic_lighting outro_phantom_1 1)
	(object_uses_cinematic_lighting outro_phantom_2 1)
	;
	
	(player_effect_set_max_rotation 0 0.5 0.5)	
	(player_effect_start .25 0)
	
	(camera_set_relative outro_phantom_sign_1 0 outro_phantom_1)
	(sleep 90)
	
	(player_effect_stop 0)
	
	(camera_set outro_sign_1a 0)
	(camera_set_pan outro_sign_1b 60)
	
	;outro foley 1
	(sound_looping_start sound\e3\foley\e3_outro_foley_01\e3_outro_foley_01 none 1)
	
	(wake streetage)
	
	(sleep 60)
	
	(stoppage)
	
;	(ai_erase shorty_mc_oneeye)
;	(ai_erase shorty_mc_deadeye)
	
	(camera_set outro_sign_2a 0)
	(camera_set_pan outro_sign_2b 28)
	(sleep 28)
	
	(camera_set outro_sign_3a 0)
	(camera_set_pan outro_sign_3b 62)
	(sleep 62)
	
;	(custom_animation chief_ghost objects\vehicles\ghost\animations\e3\e3 "ghost_tunnelchase01" false)
;	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "ghost_cin_tunnelchase01" false)
;	(camera_set_animation scenarios\solo\earthcity\earthcity_e3\cinematics\camera\camera "cameraghost_tunnel01")
	
	(camera_set outro_dust_1 0)
	(camera_set outro_dust_2 155)
	(sleep 100)
	
	;PREDICTION
     (object_type_predict objects\vehicles\uberchassis\uberchassis)
     (camera_predict outro_tunnel_1)
     ;END PREDICTION
     
     (sleep 55)
	
	(ai_erase chief_2)
	
	(object_create_anew chief)
	(object_create_anew chief_ghost)
	(object_pvs_activate chief)
	
	(object_create_anew bastard_joes_tunnel_lights)
	
	(object_create_anew_containing c_obfuscating)
	(object_create_anew_containing persistent)
	
	(object_set_shadowless persistent_chassis_1 true)
	(object_set_shadowless persistent_chassis_2 true)
	(object_set_shadowless c_obfuscating_chassis_1 true)
	(object_set_shadowless tunnel true)
	(object_set_shadowless tunnel_door true)
	
	(unit_custom_animation_at_frame chief_ghost objects\vehicles\ghost\animations\e3\e3 "ghost_tunnelchase01" false 30)
	(unit_custom_animation_at_frame chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "ghost_cin_tunnelchase01" false 30)

	(vehicle_engine_hack chief_ghost true 1)
	(unit_set_actively_controlled chief_ghost true)

	(camera_set outro_tunnel_1 0)
	(camera_set outro_tunnel_2 75)

	(ai_erase chief_2)
	(ai_erase b_outro_12)
	(ai_erase b_outro_22)
	(ai_erase b_outro_32)

	(sleep 90)
	)

(script dormant cortana_tunnel_warn
	(sound_impulse_start sound\e3\dialog\e3_810_cor none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_810_cor))
	
	(sound_impulse_start sound\e3\dialog\e3_820_mc none 1)
	(sleep (sound_impulse_time sound\e3\dialog\e3_820_mc))
	)

(script dormant post_e3_sparks
	(sleep 204)
	(effect_new_on_object_marker effects\fire\sparks_skid chief "right_hand")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_r_arm")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_r_thigh")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_torso")
	)

(script static void outro_scene_3

	(sound_class_set_gain projectile_detonation 1 1)
;	(cinematic_screen_effect_set_bloom 1 0.5 0.5 1 1)
;	(cinematic_screen_effect_start 0)

	(object_pvs_activate chief_ghost)
	
	(object_create_anew tunnel_door)
;	(object_create_anew_containing tunnel_em_light)
	
	(custom_animation chief_ghost objects\vehicles\ghost\animations\e3\e3 "ghost_tunnelchase02" false)
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "ghost_cin_tunnelchase02" false)
	(scenery_animation_start tunnel_door scenarios\objects\solo\earthcity\door_bulkhead\door_bulkhead "door_closing")

	(wake post_e3_sparks)

	(vehicle_engine_hack chief_ghost true 1)
	(unit_set_actively_controlled chief_ghost true)

	(player_effect_set_max_rotation 0 0.5 0.5)	
	(player_effect_start .25 0)
	
	(camera_set_relative outro_chief_door_1 0 chief_ghost)
	
	;outro foley 2
	(sound_looping_start sound\e3\foley\e3_outro_foley_02\e3_outro_foley_02 none 1)
	
	(sleep 45)
	
	(camera_set_relative outro_cortana_warn_1 0 chief_ghost)
	
	(wake cortana_tunnel_warn)
	
	(sleep 45)

	(camera_set outro_tunnel_close_1 0)
	(camera_set outro_tunnel_close_2 48)
	
	(sleep 48)
	
	(player_effect_stop 0)
	
	(camera_set_relative outro_chief_door_1 0 chief_ghost)
	
	(player_effect_set_max_rotation 0 0.5 0.5)	
	(player_effect_start .25 0)
	
	(sleep 39)
	
	(player_effect_stop 0)
	
	(camera_set outro_hood_scrape_1 0)
	(camera_set_pan outro_hood_scrape_2 15)
	
	(sleep 10)
	
	(effect_new_on_object_marker effects\vehicles\ghost\c_hull_destroyed_medium chief_ghost "hull_destroyed_effect")
	
	(vehicle_engine_hack chief_ghost true 0)
	
	(object_destroy_containing c_obfuscating)
	(object_create b_obfuscating_fire_1)
	(object_create b_obfuscating_smoke_1)
	(object_create b_obfuscating_smoke_2)
	(object_create b_obfuscating_chassis_1)
	
	(sleep 30)
	
	(wake brute_death_setup)
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting chief_ghost 1)
	;
	
	(camera_set outro_tumble_2 0)
	(camera_set_pan outro_tumble_1 57)
	
	(effect_new_on_object_marker effects\fire\sparks_skid chief "head")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "right_hand")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "left_hand")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_l_arm")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_r_arm")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_l_thigh")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_r_thigh")
	(effect_new_on_object_marker effects\fire\sparks_skid chief "e3_spark_torso")
	
	;JAY!
	(sleep 55)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 0)
	(player_effect_stop 1.5)
	
	;JAY!
	(sleep 2)
	
	(fade_out 0 0 0 0)
	(print "fade")
	
	)

(script static void outro_scene_4
	
	;PREDICT
	(object_type_predict_high objects\characters\brute\brute)
     (object_type_predict_high objects\vehicles\ghost\ghost)
	;END PREDICT
	
	(sleep 30)
	
	(player_effect_set_max_rotation 0 0.5 0.5)	
	(player_effect_start .25 0)
	
	;CINEMATIC_LIGHTING
	(object_uses_cinematic_lighting (list_get (ai_actors b_outro_13) 0) 1)
	(object_uses_cinematic_lighting (list_get (ai_actors b_outro_23) 0) 1)
	(object_uses_cinematic_lighting b_ghost_1 1)
	;
	
	(camera_set_relative outro_brute_death_1 0 b_ghost_1)
	(camera_set_relative outro_brute_death_1b 45 b_ghost_1)
	(scenery_animation_start tunnel_door scenarios\objects\solo\earthcity\door_bulkhead\door_bulkhead "door_bottomclosing")
	
	(fade_in 0 0 0 0)
	
	(sleep 45)
	
	(custom_animation (ai_get_unit b_outro_13) objects\characters\brute\brute_cinematics\brute_cinematics "e3_out_brute_react" false)
	
	(camera_set_relative outro_brute_death_3 0 b_ghost_1)
	(camera_set_relative outro_brute_death_3a 45 b_ghost_1)
	(sleep 15)
	
	(sound_impulse_start sound\e3\brute_tunnel_suprise none 1)
	(sleep 57)
	
	(player_effect_stop 0)
	)
	
(script dormant brute_fiery_death
	(sleep 30)
	
	(ai_erase b_outro_13)
	(ai_erase b_outro_23)
	(object_destroy b_ghost_1)
	
	(effect_new effects\vehicles\ghost\c_hull_destroyed_e3_flat f_brute_death_1)
	(sleep 15)
	(effect_new effects\vehicles\ghost\c_hull_destroyed_e3_flat f_brute_death_2)
	)
	
(script dormant pod_hatch_blow
	(sleep 21)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\hatch_release outro_pod_scenery_6 "hatch_release01")
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\hatch_release outro_pod_scenery_6 "hatch_release02")
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\hatch_release outro_pod_scenery_6 "hatch_release03")
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\hatch_release outro_pod_scenery_6 "hatch_release04")
	
	;70
	(sleep 50)
	(effect_new_on_object_marker objects\vehicles\insertion_pod\effects\hatches_blown outro_pod_scenery_6 "door_blast")
	)
	
(script dormant flash
	(sleep 85)
	(effect_new_on_object_marker objects\weapons\grenade\plasma_grenade\effects\plasma_grenade_armed_scenery outro_grenade "light") 
	)	

(script static void outro_scene_5
	
	(object_destroy_type_mask 62)

	(cinematic_start)
	(camera_control on)
	
	(object_create_anew cruiser)
	(device_set_position cruiser 1)
	(object_create_anew chief)
	(object_create_anew_containing smg)
	
	(object_destroy_containing b_obfuscating)
	(object_destroy_containing persistent)
	(object_create_anew_containing obscuring)
	
	(object_pvs_activate chief)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod outro_smg_1 true)
	(object_cinematic_lod outro_smg_2 true)
	
	(objects_attach chief "right_hand" outro_smg_1 "")
	(objects_attach chief "left_hand" outro_smg_2 "")

	(object_set_scale cruiser 0.9 0)
	
	(cinematic_screen_effect_stop)
	
	(wake brute_fiery_death)
	
	(object_destroy bastard_joes_tunnel_lights)
	
	;CINEMATIC_LIGHTING
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting outro_smg_1 1)
	(object_uses_cinematic_lighting outro_smg_2 1)
	;
	
	(camera_set outro_mc_rise_0 0)
	(camera_set outro_mc_rise_1 120)
	(sleep 60)
;	(object_destroy_containing tunnel_em_light)
	
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .25 .25 0.001 0 0 0.001)
	(cinematic_screen_effect_set_bloom_transition .6 0 0 1 1 3)
	(print "depth")
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_00_mc" false)
	
	(sleep 60)
	
	(cinematic_screen_effect_set_depth_of_field 1 .25 0 0.5 0 .25 0.5)
	(print "depth")
	
	(sleep 22)
	
	(sound_impulse_start sound\e3\dialog\e3_840_cor none 1)
	
	(sleep 8)
	
	(camera_set outro_mc_rise_2 60)
	
	(bitmap_predict "objects\characters\masterchief\bitmaps\masterchief_bump")
	(object_type_predict_high objects\characters\masterchief\masterchief)
	(sleep 60)
	
;	(cinematic_screen_effect_set_bloom 1 0 0 1 1)
;	(cinematic_screen_effect_set_depth_of_field 1 0 0 0.001 0 0 0.001)
	(cinematic_screen_effect_stop)
	
	;outro foley 1
	(sound_looping_start sound\e3\foley\e3_outro_foley_02b\e3_outro_foley_02b none 1)
	
	(camera_set outro_vista_1a 0)
	(camera_pan outro_vista_1a outro_vista_1b 180 0 1 30 0)
	
	(wake distant_pods)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_01_mc" true)
;	JAY! (sleep 150)

	(sleep 30)
	(sound_impulse_start sound\e3\dialog\e3_841_cor none 1)
	(sleep 90)
	
	(wake turn_pods)
	(sleep 30)
	
;	JAY! (sound_impulse_start sound\e3\dialog\e3_841_cor none 1)
	(sleep 15)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_02_mc" true)
	(sleep 15)
	
	(camera_set outro_chief_turn_1 0)
	(sleep 30)
	
	(camera_set outro_chief_turn_2 0)
	(camera_set_pan outro_chief_turn_2a 60)
	
	;outro foley 3
	(sound_looping_start sound\e3\foley\e3_outro_foley_03\e3_outro_foley_03 none 1)
	
	;JAY! Sleep used to be here...
;	(sleep 30)
	
	(wake close_pods_1)
	
	;Not here!
	(sleep 30) 
	
	(camera_set outro_pod_high_1 0)
	(camera_set_pan outro_pod_high_2 90)
	
	(sleep 30)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 0)
	(player_effect_stop 1.5)
	
	(sleep 60)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_10_mc" false)
;	(scenery_animation_start bomb_4 scenarios\objects\human\military\longsword_bomb\animations\e3\e3 "bomb04")
	
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 0.35 0.35 0.001 0 0 0.001)
	
	(wake close_pods_2)
	
	(object_set_shadowless chief true)
	
	(camera_set outro_pod_land_1 0)
	(camera_set outro_pod_land_2 90)
	
	(sleep 90)
	
	(cinematic_screen_effect_set_depth_of_field 1 0 0 0.001 0 0 0.001)
;	(cinematic_screen_effect_stop)
	
	(wake pass_pods)
	
	(cinematic_bloom 1 1 1)
	
	(camera_set outro_pod_open_1 0)
	
	(object_set_shadowless chief false)
	
	;outro foley 4
	(sound_looping_start sound\e3\foley\e3_outro_foley_04\e3_outro_foley_04 none 1)
	
	(sleep 60)
	
	(scenery_animation_start outro_pod_scenery_6 objects\vehicles\insertion_pod\insertion_pod "e3_pod_opening")
	
	(wake pod_hatch_blow)
	
	(sleep 60)
	
	(object_create_anew outro_elite_1)
	(object_cinematic_lod outro_elite_1 true)
		
	(object_create_anew outro_blade_1)
;	(object_set_permutation outro_blade_1 blade noblade)
	(objects_attach outro_elite_1 "right_hand_elite" outro_blade_1 "")
	
	(custom_animation outro_elite_1 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_08_elite" false)

	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -60 1 .8 .6)
	(cinematic_lighting_set_secondary_light 20 180 .1 .1 .2)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting outro_elite_1 1)
	;

	(object_teleport outro_elite_1 f_hack_for_john)
	
	(sleep 30)
	
	(camera_set outro_pod_open_2 30)
	
	(sleep 92)
	
	(object_create_anew outro_elite_2)
	(object_cinematic_lod outro_elite_2 true)
	
	(object_create_anew outro_blade_6)
;	(object_set_permutation outro_blade_6 blade noblade)
	(objects_attach outro_elite_2 "right_hand_elite" outro_blade_6 "")
	
	;CINEMATIC_LIGHTING
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	(object_uses_cinematic_lighting outro_elite_2 1)
	;
	
	(custom_animation outro_elite_2 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_09_elite_bark" false)
	(custom_animation outro_elite_1 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_09_elite_look" false)
	
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 0.25 0.25 0.001 0 0 0.001)
	
	(object_teleport outro_pod_scenery_5 f_outro_pod_5b)
	
	(camera_set outro_elite_warn_1 0)
	(camera_set outro_elite_warn_2 90)
	
	(sound_impulse_start sound\e3\dialog\e3_860_elite outro_elite_2 1) 
	
	(sleep 25)
	
	(cinematic_screen_effect_set_depth_of_field 1 0.25 0 0.5 0 0.25 0.5)
	
	(sleep 60)
	
	(cinematic_screen_effect_set_depth_of_field 1 0 0 0.001 0 0 0.001)
;	(cinematic_screen_effect_stop)
	(object_destroy outro_pod_scenery_6)
	
;	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_10_mc" false)
	(unit_custom_animation_at_frame outro_elite_1 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_10_elite" false 15)
	
;	(cinematic_screen_effect_stop)
	
	(camera_set outro_elite_sword_rev_1 0)
	(camera_set_pan outro_elite_sword_rev_2 49)
	
	;outro foley 5
	(sound_looping_start sound\e3\foley\e3_outro_foley_05\e3_outro_foley_05 none 1)
	
	(sleep 29)
;	(sleep 44)
	
	(object_destroy outro_blade_1)
	(object_create_anew outro_blade_on_1)
	(objects_attach outro_elite_1 "right_hand_elite" outro_blade_on_1 "")
	(effect_new_on_object_marker objects\weapons\melee\energy_blade\effects\blade_activate outro_blade_on_1 ground_point)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_11_mc" true)

	(sleep 20)
	
	(cinematic_bloom 0.5 0.5 1)

	(camera_set outro_mc_draw_1 0)
	(camera_set_pan outro_mc_draw_2 60)
	
;	(cinematic_screen_effect_set_bloom_transition 1 0 0 1 1 2)
;	(cinematic_screen_effect_start 0)
	
	(sleep 63)
	
	(object_create_anew outro_elite_3)
	(object_create_anew outro_elite_4)
	
	;CINEMATIC_LIGHTING
	(object_uses_cinematic_lighting outro_elite_3 1)
	(object_uses_cinematic_lighting outro_elite_4 1)
	;
	
	(object_create_anew outro_blade_2)
	(object_create_anew outro_blade_3)
	
	(objects_attach outro_elite_3 "right_hand_elite" outro_blade_2 "")
	(objects_attach outro_elite_4 "right_hand_elite" outro_blade_3 "")
	
	(object_cinematic_lod outro_elite_3 true)
	(object_cinematic_lod outro_elite_4 true)
	
	(object_set_permutation outro_blade_2 blade noblade)
	(object_set_permutation outro_blade_3 blade default)
;	(object_set_permutation outro_blade_2 blade noblade)
;	(object_set_permutation outro_blade_3 blade noblade)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_12_mc" false)
	(custom_animation outro_elite_3 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_12_elite_01" false)
	(custom_animation outro_elite_4 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_12_elite_02" false)
	
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 0.35 0.35 0.001 0 0 0.001)
	
	(camera_set outro_chief_backoff_1 0)
	(camera_pan outro_chief_backoff_1 outro_chief_backoff_2 59 0 1 0 1)
	
;	JAY! (sleep 30)
	(sleep 16)
	
	(object_destroy outro_blade_2)
	(object_create_anew outro_blade_on_2)
	(objects_attach outro_elite_3 "right_hand_elite" outro_blade_on_2 "")
	(effect_new_on_object_marker objects\weapons\melee\energy_blade\effects\blade_activate outro_blade_on_2 ground_point)

	;JAY! THIS IS NEW!
	(sleep 14)

	(sleep 25)
	
	(object_create_anew outro_elite_5)
	(object_create_anew outro_elite_6)
	
	;CINEMATIC_LIGHTING
	(object_uses_cinematic_lighting outro_elite_5 1)
	(object_uses_cinematic_lighting outro_elite_6 1)
	;
	
	(object_create_anew outro_blade_4)
	(object_create_anew outro_blade_5)
	
	(objects_attach outro_elite_5 "right_hand_elite" outro_blade_4 "")
	(objects_attach outro_elite_6 "right_hand_elite" outro_blade_5 "")
	
	(object_cinematic_lod outro_elite_5 true)
	(object_cinematic_lod outro_elite_6 true)
	
	(object_set_permutation outro_blade_4 blade default)
	(object_set_permutation outro_blade_5 blade default)
;	(object_set_permutation outro_blade_4 blade noblade)
;	(object_set_permutation outro_blade_5 blade noblade)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_13_mc" false)
	(custom_animation outro_elite_3 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_13_elite_f01" false)
	(custom_animation outro_elite_4 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_13_elite_f02" false)
	(custom_animation outro_elite_5 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_13_elite_b01" false)
	(custom_animation outro_elite_6 objects\characters\elite\elite_cinematics\elite_cinematics "e3_out_13_elite_b02" false)
	
	(cinematic_screen_effect_stop)
	
	(camera_set outro_chief_backoff_3 0)
	(camera_pan outro_chief_backoff_3 outro_chief_backoff_4 89 0 1 0 1)
	
	(sleep 68)

	(object_destroy_containing obscuring)

;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 5 0 0 0.001 0.25 0.25 0.001)

;	(camera_set outro_miss_2 0)
	(camera_pan outro_miss_2 final_shot_1 90 0 1 30 0)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_15_mc" true)
	(wake flash)
	
	(sleep 26)
	(object_destroy outro_smg_1)
	
	(sleep 18)
	(object_create_anew outro_grenade)
	(objects_attach chief "right_hand" outro_grenade "")
	
	(sleep 6)
;	(sound_impulse_start sound\e3\plasma_powerup none 0)
	
	(sleep 84)
	
	(camera_set final_shot_2 15)
	(sleep 15)
	
	(fade_out 1 1 1 5)
	
	(sleep 15)
	
	(sound_class_set_gain "weapon_ready" 1 1)
	(camera_set the_end 0)
	
	(cinematic_screen_effect_stop)
	
	)

;-OUTRO MASTER------------------------------------------------------------------ 

(script static void outro
	(outro_scene_1)
	(outro_scene_2)
	(outro_scene_3)
	(outro_scene_4)
	(outro_scene_5)
	)
	
(script dormant outro_trigger
	(sleep_until (volume_test_objects tv_outro_start (player0)) 15)
	(outro)
	(halo2_in)
	)
	
;-JOHNSON BRIEFING--------------------------------------------------------------

(script static void johnson_briefing

	(cinematic_start)
	(camera_control on)
	
	(object_create_anew briefing_johnson)
	(object_teleport briefing_johnson johnson_start)
	
	(sound_impulse_predict sound\temp\sgtjohnson\johnson_speech)

	(camera_set johnson_1 0)
	
	(sleep 30)
	
	(fade_in 0 0 0 0)
	
	(custom_animation briefing_johnson objects\characters\marine\marine_johnson\marine_johnson "prologue_speech" false)
	
	(sleep 20)
	
	(sound_impulse_start sound\temp\sgtjohnson\johnson_speech johnson 1)
	
	(sleep 280)
	(camera_set johnson_2 0)

	(sleep (sound_impulse_time sound\temp\sgtjohnson\johnson_speech))
	
	(sleep 15)
	
	(fade_out 0 0 0 15)
	
	(sleep 15)
	)

;-MAIN & SETUP--------------------------------------------------------------

(script static void bungie_logo
	(fade_out 0 0 0 0)
	(sleep 60)
	(bungie_in)
	)

(script static void press_briefing_start
	(title_fade)
	(intro)
	)
	
(script static void johnson_briefing_start
	(title_fade)
	(johnson_briefing)
	)
	
(script static void quick_start
	(wake field_hospital_setup)
	(joe_mission_start)
	)

(script dormant intro_hack
	(sleep_until (volume_test_objects tv_intro_hack (players)) 5)
	(print "you have triggered the intro cinematic")
	(sleep 60)
	(intro)
	)

(script startup main_cinematics

	(ai_allegiance human player)
	(ai_allegiance human flood)	
	(ai_allegiance covenant flood)
	(ai_allegiance flood player)
	(ai_allegiance flood human)
	(ai_allegiance flood covenant)	

	(hud_show_health off)
	(hud_show_motion_sensor off)
	(hud_show_shield off)
	(hud_show_ammo off)
	(show_hud_help_text false)
	(show_hud_messages false)
	
;	(bungie_logo)

	(wake intro_hack)
	(wake outro_trigger)
	)
	
(script startup main_music 
	(sleep_until (volume_test_objects tv_e6_init (players)) 5)
	(print "music to drive by...")
	(sound_looping_start sound\e3\music\e3_main_music\e3_main_music none 1)
	(sleep_until (volume_test_objects tv_outro_start (players)) 5)
	(sound_looping_stop sound\e3\music\e3_main_music\e3_main_music)
	)
	
(script static void final_shot

	(cinematic_start)
	(camera_control on)
	
	(sleep 60)

	(object_create_anew chief)

	(camera_set outro_miss_2 0)
	(camera_set final_shot_1 60)
	
	(custom_animation chief objects\characters\masterchief\masterchief_cinematics\masterchief_cinematics "e3_out_15_mc" true)
	(wake flash)
	
	(sleep 26)
	(object_destroy outro_smg_1)
	
	(sleep 18)
	(object_create_anew outro_grenade)
	(objects_attach chief "right_hand" outro_grenade "")
	
	(sleep 6)
	(sound_impulse_start sound\e3\plasma_powerup none 1)
	
	(sleep 84)
	
	(camera_set final_shot_2 15)
	(sleep 15)
	
	(fade_out 1 1 1 5)
	
	(sleep 15)
	)
