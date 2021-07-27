;========== Maneuver Scripts ==========

(script dormant man_marines_to_door
	(ai_migrate gravity_pad_marines gravity_pad_marines/pad)
	(sleep 90)
	(ai_conversation gravity_secure)
	(sleep 30)
;	(if debug (print "migrating marines to the door"))
	(ai_migrate gravity_pad_marines gravity_pad_marines/door)
	(sleep_until (and (volume_test_objects muster_bay_big_entrance (players))
				   (game_safe_to_save)))
	(if (= (ai_living_count gravity_pad_marines) 0) (ai_conversation grav_mus_door_locked_alt)
										   (ai_conversation grav_mus_locked_door))
	)

;========== Migrate Scripts (area 2) ==========

(script dormant traitor_bitch
	(sleep_until (ai_allegiance_broken player human))
	(ai_command_list_advance marines_initial)
	)

(script dormant mig_marines_area2
	(sleep_until (or (and (= (volume_test_objects_all area1_save_trigger (players)) 0)
					  (= (ai_status covenant_area2) 6))
				  (= (ai_living_count covenant_area2) 0)
				  (volume_test_objects area2_trigger_b (players))))
	(ai_conversation_stop initial_orders)
	(ai_command_list_advance marines_initial)
;	(ai_set_blind marines_initial true)
;	(ai_set_deaf marines_initial true)
	(sound_looping_set_alternate "levels\a50\music\a50_01" 1)
	(ai_migrate marines_initial/marines_ini_left marines_initial/marines_c)
	(ai_migrate marines_initial/marines_ini_right marines_initial/marines_a)
	(sleep -1 traitor_bitch)
	(sleep 1)
	(ai_command_list marines_initial/marines_c marines_c_forward)
	(ai_command_list marines_initial/marines_a marines_a_forward)

	(sleep (* 30 12))
;	(ai_set_blind marines_initial false)
;	(ai_set_deaf marines_initial false)
	(ai_conversation marines_attack)
	
	(sleep_until area2_marine_migrate)
	
	(begin_random (begin (ai_command_list_by_unit ini_marine_1 area2_mar_ledge_a) (sleep 5))
			    (begin (ai_command_list_by_unit ini_marine_2 area2_mar_ledge_b) (sleep 5))
;			    (begin (ai_command_list_by_unit ini_marine_3 area2_mar_ledge_b) (sleep 5))
			    (begin (ai_command_list_by_unit ini_marine_4 area2_mar_ledge_c) (sleep 5))
			    (begin (ai_command_list_by_unit ini_marine_5 area2_mar_ledge_d) (sleep 5))
;			    (begin (ai_command_list_by_unit ini_marine_6 area2_mar_ledge_e) (sleep 5))
			    (begin (ai_command_list_by_unit ini_marine_7 area2_mar_ledge_d) (sleep 5)))
	(sleep 15)
	(ai_migrate_and_speak marines_initial/marines_a marines_initial/marines_e advance)
	(ai_migrate_and_speak marines_initial/marines_c marines_initial/marines_g advance)
	(sleep 30)
	(sleep_until (and (volume_test_objects area2_trigger_b (players))
				   (= (ai_living_count covenant_area2/elites_left) 0)
				   (= (ai_living_count covenant_area2/elites_right) 0)))
	(ai_migrate_and_speak marines_initial/marines_e marines_initial/marines_o advance)
	(ai_migrate_and_speak marines_initial/marines_g marines_initial/marines_m advance)
	
	(sleep (* 30 5))
	(sleep_until area2_marine_migrate_2)
	(ai_migrate_and_speak marines_initial marines_initial/marines_q advance)
	
	(sleep_until (and (= (ai_living_count covenant_area2/grunts_back_left) 0)
				 	  (= (ai_living_count covenant_area2/grunts_back_right) 0)))
	(ai_migrate_and_speak marines_initial marines_initial/marines_s advance)

	(sleep_until (game_safe_to_save))
	(ai_conversation area2_clear)
	)

;========== Migrate Scripts (area 3) ==========

(script dormant mig_marines_area3
	(ai_migrate_and_speak marines_initial marines_area3/marines_a advance)
	
	(sleep_until (and (volume_test_objects area3_trigger_a (players))
				   (> (ai_status covenant_area3) 4)))
	(sleep 1)
	(ai_follow_target_players marines_area3/marines_a)
	)

;========== Migrate Scripts (Area 4) ==========

(script dormant mig_marines_area4_middle
	(ai_migrate marines_area4/squad_a marines_area4/squad_b)
	(if (> (ai_living_count marines_area4) 0) (ai_conversation area4_middle))
	
	(sleep_until (and (< (ai_living_count covenant_area4/grunts_b) 2)
				   (= (ai_living_count covenant_area4/jackals_g) 0)))
	(ai_migrate marines_area4/squad_b marines_area4/squad_u)
	
	(sleep_until (and (= (ai_living_count covenant_area4/grunts_s) 0)
				   (< (ai_living_count covenant_area4/jackals_u) 2)))
	(ai_migrate marines_area4/squad_u marines_area4/squad_s)
	
	(sleep_until (and (< (ai_living_count covenant_area4/grunts_q) 2)
				   (< (ai_living_count covenant_area4/elites_q) 2)))
	(ai_migrate marines_area4/squad_s marines_area4/squad_o)
	
	(sleep_until (and (= (ai_living_count covenant_area4/elites_q) 0)
				   (= (ai_living_count covenant_area4/grunts_q) 0)))
	(ai_migrate marines_area4/squad_o marines_area4/squad_x)

	(ai_follow_target_players marines_area4/squad_x)
	)
	
(script dormant mig_marines_area4_ledge
	(ai_migrate marines_area4/squad_a marines_area4/squad_c)
	(if (> (ai_living_count marines_area4) 0) (ai_conversation area4_left))

	(sleep_until (and (< (ai_living_count covenant_area4/jackals_c) 2)
				   (< (ai_living_count covenant_area4/jackals_d) 2)))
	(ai_migrate marines_area4/squad_c marines_area4/squad_d)
	
	(sleep_until (and (= (ai_living_count covenant_area4/jackals_c) 0)
				   (= (ai_living_count covenant_area4/jackals_d) 0)))
	(ai_migrate marines_area4/squad_d marines_area4/squad_m)
	
	(sleep_until (and (< (ai_living_count covenant_area4/grunts_q) 2)
				   (< (ai_strength covenant_area4/elites_q) .7)))
	(ai_migrate marines_area4/squad_m marines_area4/squad_q)
	
	(sleep_until (and (= (ai_living_count covenant_area4/elites_q) 0)
				   (= (ai_living_count covenant_area4/grunts_q) 0)))
	(ai_migrate marines_area4/squad_q marines_area4/squad_o)

	(sleep_until (and (= (ai_living_count covenant_area4/elites_q) 0)
				   (= (ai_living_count covenant_area4/grunts_q) 0)))
	(ai_migrate marines_area4/squad_o marines_area4/squad_x)

	(ai_follow_target_players marines_area4/squad_x)
	)


;========== Migrate Scripts (Area 5) ==========

(script dormant mig_marines_area5
	(ai_migrate marines_area4 marines_area4/squad_z)
	
	(sleep_until (= (ai_status covenant_area5) 6))
	(if (> (ai_living_count marines_area4) 0) (ai_conversation area5_active))
	(ai_migrate_and_speak marines_area4 marines_area5/marines_a advance)
	(ai_follow_target_players marines_area5/marines_a)
	(set play_music_a50_03 false)
	)
	
;========== Migrate Scripts (gravity room) ==========

(script dormant mig_grav_to_mus_marines
	(sleep_until muster_bay_door_unlocked)
	(ai_migrate gravity_pad_marines muster_bay_marines/squad_a)
	(ai_follow_target_players muster_bay_marines/squad_a)
	(ai_renew muster_bay_marines)
	(set play_music_a50_06 false)

	(ai_automatic_migration_target muster_bay_marines/squad_f false)
	(ai_automatic_migration_target muster_bay_marines/squad_g false)
	(ai_automatic_migration_target muster_bay_marines/squad_h false)
	)

(script dormant mig_grav_hall_cleanup
;	(if debug (print "migrating hallway covenant into muster bay"))
	(ai_migrate grav_mus_hall_covenant muster_bay_covenant_top/grav_hall_cleanup)
	(sleep_until (or (= 0 (ai_living_count gravity_pad_marines))
				  (= 0 (ai_living_count gravity_pad_covenant))))
;	(if debug (print "migrating gravity pad covenant into muster bay"))
	(ai_migrate gravity_pad_covenant muster_bay_covenant_top/grav_hall_cleanup)
	)
	
;========== Migrate Scripts (hangar)==========

(script dormant auto_migration_deactivate
	(ai_automatic_migration_target prison_marines/mig_marines_a false)
	(ai_automatic_migration_target prison_marines/mig_marines_b false)
	(ai_automatic_migration_target prison_marines/mig_marines_c false)
	(ai_automatic_migration_target prison_marines/mig_marines_d false)
	(ai_automatic_migration_target prison_marines/mig_marines_e false)
	(ai_automatic_migration_target prison_marines/mig_marines_f false)
	(ai_automatic_migration_target prison_marines/mig_marines_g false)
	(ai_automatic_migration_target prison_marines/mig_marines_h false)
	(ai_automatic_migration_target prison_marines/mig_marines_i false)
	(ai_automatic_migration_target prison_marines/mig_marines_j false)
	(ai_automatic_migration_target prison_marines/mig_marines_k false)
	(ai_automatic_migration_target prison_marines/mig_marines_z false)
	(ai_automatic_migration_target prison_marines/mig_marines_y false)
	)
	
;========== Migration Scripts (Prison Area) ==========

(script dormant mig_marines_prison_a
	(sleep_until (= (device_group_get prison_a_switch_position) 1))
	   (begin_random
		(begin (device_group_set prison_door_a_position_a 1)
			  (sleep (random_range 20 45)))
		(begin (device_group_set prison_door_a_position_b 1)
			  (sleep (random_range 20 45)))
		(begin (device_group_set prison_door_a_position_c 1)
			  (sleep (random_range 20 45)))
		(begin (device_group_set prison_door_a_position_d 1)
			  (sleep (random_range 20 45))))
	(object_set_permutation cell_a_door_a "" door_off-100)
	(object_set_permutation cell_a_door_b "" door_off-100)
	(object_set_permutation cell_a_door_c "" door_off-100)
	(object_set_permutation cell_a_door_d "" door_off-100)
	(object_set_permutation cell_a_door_e "" door_off-100)
	(object_set_permutation cell_a_door_f "" door_off-100)
	(object_set_permutation cell_a_door_g "" door_off-100)
	(object_set_permutation cell_a_door_h "" door_off-100)

;	(ai_migrate prison_marines_ini/captain prison_captain/mig_cap_cell_a)
;	(ai_migrate prison_marines_ini/marines_cellblock_a prison_marines/mig_marines_cell_a)
;	(ai_migrate prison_marines_ini/mar_nocap_cell_a prison_suicide/mig_suicide_cell_a)

;	(set player_location_index 5)
;	(if debug (print "(cellblock a) migrating captain and marines into room"))
	)

(script dormant mig_marines_prison_d
	(sleep_until (= 1 (device_group_get prison_d_switch_position)))
	(begin_random
		(begin (device_group_set prison_door_d_position_a 1)
			  (sleep (random_range 20 45)))
		(begin (device_group_set prison_door_d_position_b 1)
			  (sleep (random_range 20 45)))
		(begin (device_group_set prison_door_d_position_c 1)
			  (sleep (random_range 20 45)))
		(begin (device_group_set prison_door_d_position_d 1)
			  (sleep (random_range 20 45))))
	(object_set_permutation cell_d_door_a "" door_off-100)
	(object_set_permutation cell_d_door_b "" door_off-100)
	(object_set_permutation cell_d_door_c "" door_off-100)
	(object_set_permutation cell_d_door_e "" door_off-100)
	(object_set_permutation cell_d_door_f "" door_off-100)
	(object_set_permutation cell_d_door_g "" door_off-100)
	(object_set_permutation cell_d_door_h "" door_off-100)
	(object_set_permutation keyes_cell_door "" door_off-100)		

;	(object_set_collideable cell_d_door_a false)
;	(object_set_collideable cell_d_door_b false)
;	(object_set_collideable cell_d_door_c false)
;	(object_set_collideable cell_d_door_e false)
;	(object_set_collideable cell_d_door_f false)
;	(object_set_collideable cell_d_door_g false)
;	(object_set_collideable cell_d_door_h false)
;	(object_set_collideable keyes_cell_door false)		

		

	(ai_migrate prison_marines_ini/captain prison_captain/mig_cap_u)
	(ai_migrate prison_marines_ini/marines_cellblock_d prison_marines/mig_marines_u)
	(ai_migrate prison_marines_ini/mar_nocap_cell_d prison_suicide/mig_suicide_cell_d)
	(set player_location_index 1)
;	(if debug (print "(cellblock d) migrating captain and marines into room"))
	
	(sleep 1)

	(ai_follow_target_players prison_captain)
	(ai_follow_target_players prison_marines)
	(ai_follow_target_players prison_suicide)
;	(ai_follow_target_ai prison_marines prison_captain)

	(ai_follow_target_players hangar_captain_halls)
	(ai_follow_target_players hangar_marines_halls)
;	(ai_follow_target_ai hangar_marines_halls hangar_marines_halls)
	
	(ai_link_activation prison_marines control_prison_hall_cov)
	(ai_link_activation prison_captain prison_marines)
	(ai_link_activation hangar_captain_halls hangar_marines_halls)

	(device_one_sided_set control_door_a true)
	(device_one_sided_set control_door_b true)
	(device_one_sided_set control_door_c true)
;	(device_one_sided_set control_door_d true)
;	(device_operates_automatically_set control_hall_door true)
;	(device_set_power control_hall_door 1)
	
	(ai_automatic_migration_target prison_marines/mig_marines_a true)
	(ai_automatic_migration_target prison_marines/mig_marines_b true)
	(ai_automatic_migration_target prison_marines/mig_marines_c true)
	(ai_automatic_migration_target prison_marines/mig_marines_d true)
	(ai_automatic_migration_target prison_marines/mig_marines_e true)
	(ai_automatic_migration_target prison_marines/mig_marines_f true)
	(ai_automatic_migration_target prison_marines/mig_marines_g true)
	(ai_automatic_migration_target prison_marines/mig_marines_h true)
	(ai_automatic_migration_target prison_marines/mig_marines_i true)
	(ai_automatic_migration_target prison_marines/mig_marines_j true)
	(ai_automatic_migration_target prison_marines/mig_marines_k true)
	(ai_automatic_migration_target prison_marines/mig_marines_z true)
	(ai_automatic_migration_target prison_marines/mig_marines_y true)
	
	(ai_automatic_migration_target hangar_marines_halls/squad_a false)
	(ai_automatic_migration_target hangar_marines_halls/squad_b false)
	(ai_automatic_migration_target hangar_marines_halls/squad_c false)
	(ai_automatic_migration_target hangar_marines_halls/squad_d false)
	(ai_automatic_migration_target hangar_marines_halls/squad_e false)
	(ai_automatic_migration_target hangar_marines_halls/squad_f false)
	(ai_automatic_migration_target hangar_marines_halls/squad_g false)
	
	(ai_automatic_migration_target prison_captain/mig_cap_l 0)
	(ai_automatic_migration_target prison_captain/mig_cap_m 0)
	(ai_automatic_migration_target prison_captain/mig_cap_n 0)
	(ai_automatic_migration_target prison_captain/mig_cap_o 0)
	
	(ai_automatic_migration_target prison_marines/mig_marines_l 0)
	(ai_automatic_migration_target prison_marines/mig_marines_m 0)
	(ai_automatic_migration_target prison_marines/mig_marines_n 0)
	(ai_automatic_migration_target prison_marines/mig_marines_o 0)
	)
	
; new prison migration scripts to handle bsp and encounter swaps
;----------------> BSP switch nastines <----------------
(script static void mig_into_control
	(ai_migrate prison_marines prison_marines/mig_marines_p)
	(ai_migrate prison_captain prison_captain/mig_cap_p)
	(ai_migrate hangar_marines_halls prison_marines/mig_marines_p)
	(ai_migrate hangar_captain_halls prison_captain/mig_cap_p)

	(ai_migrate_by_unit captain_keyes prison_captain/mig_cap_p)
	(ai_migrate_by_unit free_marine_1 prison_marines/mig_marines_p)
	(ai_migrate_by_unit free_marine_2 prison_marines/mig_marines_p)
	(ai_migrate_by_unit free_marine_3 prison_marines/mig_marines_p)
	(sleep 1)
	(ai_teleport_to_starting_location_if_unsupported prison_marines/mig_marines_p)
	(ai_teleport_to_starting_location_if_unsupported prison_captain/mig_cap_p)
;	(ai_migrate prison_suicide prison_suicide/mig_suicide_p)
	(set player_location_index 1)
	)

(script static void mig_into_hangar
	(ai_migrate prison_marines hangar_marines_halls/squad_switch)
	(ai_migrate prison_captain hangar_captain_halls/squad_switch)
	(ai_migrate hangar_marines_halls hangar_marines_halls/squad_switch)
	(ai_migrate hangar_captain_halls hangar_captain_halls/squad_switch)

	(ai_migrate_by_unit captain_keyes hangar_captain_halls/squad_switch)
	(ai_migrate_by_unit free_marine_1 hangar_marines_halls/squad_switch)
	(ai_migrate_by_unit free_marine_2 hangar_marines_halls/squad_switch)
	(ai_migrate_by_unit free_marine_3 hangar_marines_halls/squad_switch)
	(sleep 1)
	(ai_teleport_to_starting_location_if_unsupported hangar_marines_halls/squad_switch)
	(ai_teleport_to_starting_location_if_unsupported hangar_captain_halls/squad_switch)
;	(ai_migrate prison_suicide prison_suicide/mig_suicide_q)
	(set player_location_index 2)
	)
;----------------> BSP switch nastines <----------------

; scripts that test if the player moved from each of the locations,
; and return the location to which he moved

(script static void mig_from_control
	(if (volume_test_objects hangar_migration (players)) (mig_into_hangar) (set player_location_index 1))
	)
	
(script static void mig_from_hangar
	(if (volume_test_objects control_migration (players)) (mig_into_control) (set player_location_index 2))
	)

(script continuous ini_prison_mig_manage
	(sleep 30)
	(cond 
		((= player_location_index 1) (mig_from_control))
		((= player_location_index 2) (mig_from_hangar)))
	)
;========== Encounter Scripts (Area 1) ==========

(script dormant enc_marines_area1
;	(if debug (print "placing marines"))
	(ai_place marines_initial/marines_ini_left)
	(ai_place marines_initial/marines_ini_right)
	)

;========== Encounter Scripts (Area 2) ==========

(script dormant enc_area2_ini
;	(if debug (print "placing area 2 turret gunners"))
	(ai_place covenant_area2/turret_gunner_a)
	(ai_place covenant_area2/turret_gunner_b)
;	(if debug (print "placing forward grunts"))
	(ai_place covenant_area2/grunts_left)
	(ai_place covenant_area2/grunts_middle)
	(ai_place covenant_area2/grunts_right)
;	(if debug (print "placing elites"))
	(ai_place covenant_area2/elites_right)
	(ai_place covenant_area2/elites_left)
;	(if debug (print "placing forward jackals"))
	(ai_place covenant_area2/jackals_left)
	(ai_place covenant_area2/jackals_right)
	(sleep 1)
	(objects_predict (ai_actors covenant_area2))
	)

(script dormant enc_area2_wave_2
;	(if debug (print "placing wave 2 covenant"))
	(ai_place covenant_area2/grunts_left_b)
;	(ai_place covenant_area2/grunts_middle_b)
	(ai_place covenant_area2/grunts_right_b)
	(ai_place covenant_area2/elites_back)
	(sleep 1)
	(objects_predict (ai_actors covenant_area2))
	)

(script dormant enc_back_area2
;	(if debug (print "placing back grunts"))
	(ai_place covenant_area2/grunts_back_left)
	(ai_place covenant_area2/grunts_back_right)
;	(if debug (print "placing back jackals"))
	(ai_place covenant_area2/jackals_back)
	(sleep 1)
	(objects_predict (ai_actors covenant_area2))
	)

;========== Initialization Scripts (area 2) ==========

(script continuous ini_enter_turret_area2_norm
	(if (and (> (ai_living_count covenant_area2/turret_gunner_a) 0)
		    (> (ai_living_count covenant_area2/turret_gunner_b) 0))
		(begin_random
			(begin (ai_go_to_vehicle covenant_area2/turret_gunner_a area2_turret_a gunner)
			  	  (sleep default_turret_gunner_delay))
			(begin (ai_go_to_vehicle covenant_area2/turret_gunner_b area2_turret_b gunner)
			  	  (sleep default_turret_gunner_delay))))
	)

(script continuous ini_enter_turret_area2_leg
	(if (and (> (ai_living_count covenant_area2/turret_gunner_a) 0)
		    (> (ai_living_count covenant_area2/turret_gunner_b) 0))
		(begin_random
			(begin (ai_go_to_vehicle covenant_area2/turret_gunner_a area2_turret_a gunner)
			  	  (sleep default_turret_gunner_delay))
			(begin (ai_go_to_vehicle covenant_area2/turret_gunner_b area2_turret_b gunner)
			  	  (sleep default_turret_gunner_delay))))
	(begin_random
		(begin (ai_go_to_vehicle covenant_area2 area2_turret_a gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area2 area2_turret_b gunner)
			  (sleep default_turret_gunner_delay))
		(sleep default_turret_gunner_delay))
	)

(script dormant ini_gun_runner
	(ai_place covenant_area2/gun_runner)
	(sleep (* 30 20))
	(sleep_until (and (= (ai_status marines_initial) 6)
				   (= (ai_living_count covenant_area2/turret_gunner_a) 0)))
	(ai_go_to_vehicle covenant_area2/gun_runner area2_turret_a "gunner")
	(if (> (ai_living_count covenant_area2/gun_runner) 0)
		(begin
		(ai_conversation run_for_gun)
		(activate_team_nav_point_object default_red player (unit (list_get (ai_actors covenant_area2/gun_runner) 0)) .6)))
;	(sleep_until (= (ai_living_count covenant_area2/gun_runner) 0))
;	(deactivate_team_nav_point_object player (unit (list_get (ai_actors covenant_area2/gun_runner) 0)))
	)

;========== Encounter Scripts (Area 3) ==========
(script dormant enc_area3_initial
	(ai_place covenant_area3/turret_gunner_a)
	(ai_place covenant_area3/grunts_ledge)
	(ai_place covenant_area3/jackals_hill_left)
	(ai_place covenant_area3/grunts_hill_right)
;	(ai_place covenant_area3/grunts_c)
	(sleep 1)
	(objects_predict (ai_actors covenant_area3))
	)
	
(script dormant enc_area3_second
	(ai_place covenant_area3/elites_hiding)
	(ai_place covenant_area3/grunts_back)
	(sleep 1)
	(objects_predict (ai_actors covenant_area3))
	)

(script dormant enc_elites_front_area3
	(ai_place covenant_area3/elites_front)
	(sleep 1)
	(objects_predict (ai_actors covenant_area3))
	)

(script dormant enc_elites_reins_area3
	(ai_place covenant_area3/elites_reins)
	(sleep 1)
	(objects_predict (ai_actors covenant_area3))
	)

(script dormant enc_grunts_reins_area3
	(ai_place covenant_area3/grunts_reins)
	(sleep 1)
	(objects_predict (ai_actors covenant_area3))
	)

;========== Initialization Scripts (area 3) ==========

(script dormant dialog_area3_initial
	(sleep_until (and (game_safe_to_save)
				   (< (ai_status covenant_area3) 3)))
	(ai_conversation area3_initial)
	)

(script dormant ini_area3_turrets_leg
	(ai_place covenant_area3/turret_gunner_b)
	(object_create area3_turret_b)
	(ai_go_to_vehicle covenant_area3/turret_gunner_b area3_turret_b gunner)
	(sleep 1)
	(objects_predict (ai_actors covenant_area3))
	)

(script continuous ini_enter_turret_area3_norm
	(ai_go_to_vehicle covenant_area3/turret_gunner_a area3_turret_a gunner)
	(sleep default_turret_gunner_delay)
	(sleep 1)
	(objects_predict (ai_actors covenant_area3))
	)

(script continuous ini_enter_turret_area3_leg
	(ai_go_to_vehicle covenant_area3/turret_gunner_a area3_turret_a gunner)
	(ai_go_to_vehicle covenant_area3/turret_gunner_b area3_turret_b gunner)

	(if (and (= (ai_living_count covenant_area3/turret_gunner_a) 0)
		    (= (ai_living_count covenant_area3/turret_gunner_b) 0))
	(begin_random
		(begin (ai_go_to_vehicle covenant_area3 area3_turret_a gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area3 area3_turret_b gunner)
			  (sleep default_turret_gunner_delay))
		(sleep default_turret_gunner_delay)))
	)


;========== Encounter Scripts (Area 4) ==========

(script dormant enc_area4_initial
	(ai_place covenant_area4/jackals_u)
;	(ai_place covenant_area4/jackals_c)
	(ai_place covenant_area4/jackals_d)
	(ai_place covenant_area4/grunts_b)
;	(ai_place covenant_area4/grunts_s)
	(ai_place covenant_area4/elites_e)
;	(ai_place covenant_area4/jackals_g)
	(sleep 1)
	(objects_predict (ai_actors covenant_area4))
	)

(script dormant enc_area4_second
	(ai_place covenant_area4/elites_q)
;	(ai_place covenant_area4/grunts_i)
	(if (< (ai_living_count covenant_area4) 6) (ai_place covenant_area4/grunts_q))
	(ai_place covenant_area4/grunts_k)
	(sleep 1)
	(objects_predict (ai_actors covenant_area4))
	)

;========== Initialization Scripts (area 4) ==========

(script dormant dialog_area4_initial
	(ai_conversation area4_initial)
	
	(sleep_until (volume_test_objects area4_trigger_a (players)))
	(if (< (ai_status covenant_area4) 4) (ai_conversation_advance area4_initial))
	)

(script continuous ini_area4_player_locator
	(cond
		((volume_test_objects area4_location_1 (players)) (set area4_location_index 1))
		((volume_test_objects area4_location_2 (players)) (set area4_location_index 2))
		(true (set area4_location_index 0)))
	(sleep (* 30 5))
	)

(script dormant ini_area4_grunts_m
	(sleep_until (or (volume_test_objects area4_grunts_m_trigger (players))
				  (volume_test_objects area4_grunts_m_trigger (ai_actors marines_area4))))
	(if (< (ai_living_count covenant_area4) 7) (ai_place covenant_area4/grunts_m))
	)
	
(script dormant ini_area4_marine_reins
	(sleep_until (and area4_pelican_a
				   (< (ai_living_count covenant_area4) 11)
				   (< (ai_living_count marines_area4) 1)))
	
	(if area4_marine_reins
		(cond
			((= area4_location_index 1) (if (not (game_is_cooperative)) (pelican_area4_a)))
			((= area4_location_index 2) (if (not (game_is_cooperative)) (pelican_area4_b)))))
	)

(script dormant ini_area4_dropship
	(sleep_until (and area4_covenant_reins
				   (< (ai_living_count covenant_area4) 5)))
	(sleep 1)
	(if (and area4_cov_dropship
		    (< (ai_living_count covenant_area4) 5))
	    (c_dropship_area4))
	)

(script dormant ini_area4_reins
	(ai_place covenant_area4/elites_reins)
	(if (< (ai_living_count covenant_area4) 7) (ai_place covenant_area4/grunts_reins))
	(sleep 1)
	(ai_allow_dormant covenant_area4/elites_reins false)
	(ai_allow_dormant covenant_area4/grunts_reins false)
	(ai_migrate covenant_area4 covenant_area4/squad_y)
	(ai_follow_target_players covenant_area4/squad_y)
	)


(global boolean area4_turret_spawn true)
(global short area4_turret_counter 0)
(global short area4_turret_limit 0)

(script dormant ini_area4_turrets
	(begin_random
		(if area4_turret_spawn
			(begin (ai_place covenant_area4/turret_gunner_a)
				  (object_create area4_turret_a)
				  (set area4_turret_counter (+ 1 area4_turret_counter))
				  (if (= area4_turret_counter area4_turret_limit) (set area4_turret_spawn false))))
		(if area4_turret_spawn
			(begin (ai_place covenant_area4/turret_gunner_b)
				  (object_create area4_turret_b)
				  (set area4_turret_counter (+ 1 area4_turret_counter))
				  (if (= area4_turret_counter area4_turret_limit) (set area4_turret_spawn false))))
		(if area4_turret_spawn
			(begin (ai_place covenant_area4/turret_gunner_c)
				  (object_create area4_turret_c)
				  (set area4_turret_counter (+ 1 area4_turret_counter))
				  (if (= area4_turret_counter area4_turret_limit) (set area4_turret_spawn false))))
		(if area4_turret_spawn
			(begin (ai_place covenant_area4/turret_gunner_d)
				  (object_create area4_turret_d)
				  (set area4_turret_counter (+ 1 area4_turret_counter))
				  (if (= area4_turret_counter area4_turret_limit) (set area4_turret_spawn false))))
		(if area4_turret_spawn
			(begin (ai_place covenant_area4/turret_gunner_e)
				  (object_create area4_turret_e)
				  (set area4_turret_counter (+ 1 area4_turret_counter))
				  (if (= area4_turret_counter area4_turret_limit) (set area4_turret_spawn false)))))
	)

(script continuous ini_enter_turret_area4_norm
	(ai_go_to_vehicle covenant_area4/turret_gunner_a area4_turret_a gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_b area4_turret_b gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_c area4_turret_c gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_d area4_turret_d gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_e area4_turret_e gunner)
	(sleep default_turret_gunner_delay)
	)

(script continuous ini_enter_turret_area4_leg
	(ai_go_to_vehicle covenant_area4/turret_gunner_a area4_turret_a gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_b area4_turret_b gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_c area4_turret_c gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_d area4_turret_d gunner)
	(ai_go_to_vehicle covenant_area4/turret_gunner_e area4_turret_e gunner)
	(sleep default_turret_gunner_delay)

	(if (and (= (ai_living_count covenant_area4/turret_gunner_a) 0)
		    (= (ai_living_count covenant_area4/turret_gunner_b) 0)
		    (= (ai_living_count covenant_area4/turret_gunner_c) 0)
		    (= (ai_living_count covenant_area4/turret_gunner_d) 0)
		    (= (ai_living_count covenant_area4/turret_gunner_e) 0))
	(begin_random
		(begin (ai_go_to_vehicle covenant_area4 area4_turret_a gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area4 area4_turret_b gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area4 area4_turret_c gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area4 area4_turret_d gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area4 area4_turret_e gunner)
			  (sleep default_turret_gunner_delay))
		(sleep default_turret_gunner_delay)))
	)

;========== Encounter Scripts (Area 5) ==========

(script dormant enc_area5_ini
	(ai_place covenant_area5/elites_w)
	(ai_place covenant_area5/grunts_a)
	(ai_place covenant_area5/jackals_c)
	(sleep 1)
	(objects_predict (ai_actors covenant_area5))
	)

(script dormant enc_area5_hunters
	(ai_place covenant_area5/hunters)
(custom_animation_list (ai_actors covenant_area5/hunters) cinematics\animations\hunter\level_specific\A50\A50 a50energylift 0)
	(sleep 1)
	(objects_predict (ai_actors covenant_area5))
	(sleep 300)
;	(ai_migrate covenant_area5/hunters covenant_area5/squad_q)
;	(ai_follow_target_players covenant_area5/squad_q)
	(ai_magically_see_players covenant_area5)
	)

(script static void enc_area5_e
	(ai_place covenant_area5/elites_e)
(custom_animation_list (ai_actors covenant_area5/elites_e) cinematics\animations\elite\level_specific\A50\A50 a50energylift 0)
	(begin_random
		(if area5_e_spawn
			(begin (ai_place covenant_area5/grunts_e)
(custom_animation_list (ai_actors covenant_area5/grunts_e) cinematics\animations\grunt\level_specific\A50\A50 a50energylift 0)
				  (set area5_e_spawn_counter (+ 1 area5_e_spawn_counter))
				  (if (= area5_e_spawn_counter area5_e_squad_index) (set area5_e_spawn false))))
		(if area5_e_spawn
			(begin (ai_place covenant_area5/jackals_e)
(custom_animation_list (ai_actors covenant_area5/jackals_e) cinematics\animations\jackal\level_specific\A50\A50 a50energylift 0)
				  (set area5_e_spawn_counter (+ 1 area5_e_spawn_counter))
				  (if (= area5_e_spawn_counter area5_e_squad_index) (set area5_e_spawn false)))))
	(set area5_e_spawn_counter 0)
	)

(script static void enc_area5_g
	(ai_place covenant_area5/elites_g)
(custom_animation_list (ai_actors covenant_area5/elites_g) cinematics\animations\elite\level_specific\A50\A50 a50energylift 0)
	(begin_random
		(if area5_g_spawn
			(begin (ai_place covenant_area5/grunts_g)
(custom_animation_list (ai_actors covenant_area5/grunts_g) cinematics\animations\grunt\level_specific\A50\A50 a50energylift 0)
				  (set area5_g_spawn_counter (+ 1 area5_g_spawn_counter))
				  (if (= area5_g_spawn_counter area5_g_squad_index) (set area5_g_spawn false))))
		(if area5_g_spawn
			(begin (ai_place covenant_area5/jackals_g)
(custom_animation_list (ai_actors covenant_area5/jackals_g) cinematics\animations\jackal\level_specific\A50\A50 a50energylift 0)
				  (set area5_g_spawn_counter (+ 1 area5_g_spawn_counter))
				  (if (= area5_g_spawn_counter area5_g_squad_index) (set area5_g_spawn false)))))
	(set area5_g_spawn_counter 0)
	)

(script static void enc_area5_o
	(ai_place covenant_area5/elites_o)
(custom_animation_list (ai_actors covenant_area5/elites_o) cinematics\animations\elite\level_specific\A50\A50 a50energylift 0)
	(begin_random
		(if area5_o_spawn
			(begin (ai_place covenant_area5/grunts_o)
(custom_animation_list (ai_actors covenant_area5/grunts_o) cinematics\animations\grunt\level_specific\A50\A50 a50energylift 0)
				  (set area5_o_spawn_counter (+ 1 area5_o_spawn_counter))
				  (if (= area5_o_spawn_counter area5_o_squad_index) (set area5_o_spawn false))))
		(if area5_o_spawn
			(begin (ai_place covenant_area5/jackals_o)
(custom_animation_list (ai_actors covenant_area5/jackals_o) cinematics\animations\jackal\level_specific\A50\A50 a50energylift 0)
				  (set area5_o_spawn_counter (+ 1 area5_o_spawn_counter))
				  (if (= area5_o_spawn_counter area5_o_squad_index) (set area5_o_spawn false)))))
	(set area5_o_spawn_counter 0)
	)

(script static void enc_area5_q
	(ai_place covenant_area5/elites_q)
(custom_animation_list (ai_actors covenant_area5/elites_q) cinematics\animations\elite\level_specific\A50\A50 a50energylift 0)
	(begin_random
		(if area5_q_spawn
			(begin (ai_place covenant_area5/grunts_q)
(custom_animation_list (ai_actors covenant_area5/grunts_q) cinematics\animations\grunt\level_specific\A50\A50 a50energylift 0)
				  (set area5_q_spawn_counter (+ 1 area5_q_spawn_counter))
				  (if (= area5_q_spawn_counter area5_q_squad_index) (set area5_q_spawn false))))
		(if area5_q_spawn
			(begin (ai_place covenant_area5/jackals_q)
(custom_animation_list (ai_actors covenant_area5/jackals_q) cinematics\animations\jackal\level_specific\A50\A50 a50energylift 0)
				  (set area5_q_spawn_counter (+ 1 area5_q_spawn_counter))
				  (if (= area5_q_spawn_counter area5_q_squad_index) (set area5_q_spawn false)))))
	(set area5_q_spawn_counter 0)
	)
	
;========== Initialization Scripts (area 5) ==========

(script dormant dialog_area5_initial
	(sleep_until (and (< (ai_status covenant_area4) 3)
				   (< (ai_living_count covenant_area4) 2)
				   (game_safe_to_save)))
	(ai_conversation area5_initial)
	(set play_music_a50_03 false)
	)

(global boolean area5_turret_spawn true)
(global short area5_turret_counter 0)
(global short area5_turret_limit 0)

(script dormant ini_area5_turrets
	(begin_random
		(if area5_turret_spawn
			(begin (ai_place covenant_area5/turret_gunner_a)
				  (object_create area5_turret_a)
				  (set area5_turret_counter (+ 1 area5_turret_counter))
				  (if (= area5_turret_counter area5_turret_limit) (set area5_turret_spawn false))))
		(if area5_turret_spawn
			(begin (ai_place covenant_area5/turret_gunner_b)
				  (object_create area5_turret_b)
				  (set area5_turret_counter (+ 1 area5_turret_counter))
				  (if (= area5_turret_counter area5_turret_limit) (set area5_turret_spawn false))))
		(if area5_turret_spawn
			(begin (ai_place covenant_area5/turret_gunner_c)
				  (object_create area5_turret_c)
				  (set area5_turret_counter (+ 1 area5_turret_counter))
				  (if (= area5_turret_counter area5_turret_limit) (set area5_turret_spawn false))))
		(if area5_turret_spawn
			(begin (ai_place covenant_area5/turret_gunner_d)
				  (object_create area5_turret_d)
				  (set area5_turret_counter (+ 1 area5_turret_counter))
				  (if (= area5_turret_counter area5_turret_limit) (set area5_turret_spawn false))))
		(if area5_turret_spawn
			(begin (ai_place covenant_area5/turret_gunner_e)
				  (object_create area5_turret_e)
				  (set area5_turret_counter (+ 1 area5_turret_counter))
				  (if (= area5_turret_counter area5_turret_limit) (set area5_turret_spawn false)))))
	(sleep 1)
	(objects_predict (ai_actors covenant_area5))
	)

(script continuous ini_enter_turret_area5_norm
	(ai_go_to_vehicle covenant_area5/turret_gunner_a area5_turret_a gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_b area5_turret_b gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_c area5_turret_c gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_d area5_turret_d gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_e area5_turret_e gunner)
	(sleep default_turret_gunner_delay)
	)

(script continuous ini_enter_turret_area5_leg
	(ai_go_to_vehicle covenant_area5/turret_gunner_a area5_turret_a gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_b area5_turret_b gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_c area5_turret_c gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_d area5_turret_d gunner)
	(ai_go_to_vehicle covenant_area5/turret_gunner_e area5_turret_e gunner)
	(sleep default_turret_gunner_delay)
	
	(if (and (> (ai_living_count covenant_area5/turret_gunner_a) 0)
		    (> (ai_living_count covenant_area5/turret_gunner_b) 0)
		    (> (ai_living_count covenant_area5/turret_gunner_c) 0)
		    (> (ai_living_count covenant_area5/turret_gunner_d) 0)
		    (> (ai_living_count covenant_area5/turret_gunner_e) 0))
	(begin_random
		(begin (ai_go_to_vehicle covenant_area5 area5_turret_a gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area5 area5_turret_b gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area5 area5_turret_c gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area5 area5_turret_d gunner)
			  (sleep default_turret_gunner_delay))
		(begin (ai_go_to_vehicle covenant_area5 area5_turret_e gunner)
			  (sleep default_turret_gunner_delay))
		(sleep default_turret_gunner_delay)))
	)

(global short area5_index 2)
(global long area5_spawn_delay 120)

(script continuous ini_area5_spawner
	(if (and (< (ai_living_count covenant_area5) area5_index)
		    (volume_test_objects area5_e_trigger (players))
		    area5_e_spawn)
	    (enc_area5_e))
	(sleep area5_spawn_delay)
	
	(if (and (< (ai_living_count covenant_area5) area5_index)
		    (volume_test_objects area5_g_trigger (players))
		    area5_g_spawn)
	    (enc_area5_g))
	(sleep area5_spawn_delay)

	(if (and (< (ai_living_count covenant_area5) area5_index)
		    (volume_test_objects area5_o_trigger (players))
		    area5_o_spawn)
	    (enc_area5_o))
	(sleep area5_spawn_delay)

	(if (and (< (ai_living_count covenant_area5) area5_index)
		    (volume_test_objects area5_q_trigger (players))
		    area5_q_spawn)
	    (enc_area5_q))
	(sleep area5_spawn_delay)
	(sleep 1)
	(objects_predict (ai_actors covenant_area5))
	)


(script continuous ini_area5_random_spawner
	(begin_random 
		(begin (sleep_until (< (ai_living_count covenant_area5) area5_index))
				(if area5_e_spawn (enc_area5_e)))
	
		(begin (sleep_until (< (ai_living_count covenant_area5) area5_index))
				(if area5_g_spawn (enc_area5_g)))
	
		(begin (sleep_until (< (ai_living_count covenant_area5) area5_index))
				(if area5_o_spawn (enc_area5_o)))
	
		(begin (sleep_until (< (ai_living_count covenant_area5) area5_index))
				(if area5_q_spawn (enc_area5_q))))
	(sleep 1)
	(objects_predict (ai_actors covenant_area5))
	)

(script continuous ini_area5_cov_chaser
	(if (or (> (ai_living_count covenant_area5/elites_e) 0)
		   (> (ai_living_count covenant_area5/grunts_e) 0)
		   (> (ai_living_count covenant_area5/jackals_e) 0))
	    (begin (sleep (* 30 5))
			 (ai_migrate covenant_area5 covenant_area5/squad_e)
			 (sleep 1)
			 (ai_follow_target_players covenant_area5/squad_e)))
			 
	(if (or (> (ai_living_count covenant_area5/elites_g) 0)
		   (> (ai_living_count covenant_area5/grunts_g) 0)
		   (> (ai_living_count covenant_area5/jackals_g) 0))
	    (begin (sleep (* 30 5))
			 (ai_migrate covenant_area5 covenant_area5/squad_g)
			 (sleep 1)
			 (ai_follow_target_players covenant_area5/squad_g)))
			 
	(if (or (> (ai_living_count covenant_area5/elites_o) 0)
		   (> (ai_living_count covenant_area5/grunts_o) 0)
		   (> (ai_living_count covenant_area5/jackals_o) 0))
	    (begin (sleep (* 30 5))
			 (ai_migrate covenant_area5 covenant_area5/squad_o)
			 (sleep 1)
			 (ai_follow_target_players covenant_area5/squad_o)))
			 
	(if (or (> (ai_living_count covenant_area5/elites_q) 0)
		   (> (ai_living_count covenant_area5/grunts_q) 0)
		   (> (ai_living_count covenant_area5/jackals_q) 0))
	    (begin (sleep (* 30 5))
			 (ai_migrate covenant_area5 covenant_area5/squad_q)
			 (sleep 1)
			 (ai_follow_target_players covenant_area5/squad_q)))
	(sleep 150)
	)

(script static void gravity_spawn_legendary
	(set area5_e_spawn true)
	(set area5_g_spawn true)
	(set area5_o_spawn true)
	(set area5_q_spawn true)
	(sleep 1)
	(sleep_until (and (not area5_e_spawn) (not area5_g_spawn) (not area5_o_spawn) (not area5_q_spawn)))
	)

;(script dormant ini_area5_cov_retreat
	
;	(vehicle_unload area5_turret_a gunner)
;	(vehicle_unload area5_turret_b gunner)
;	(vehicle_unload area5_turret_c gunner)
;	(vehicle_unload area5_turret_d gunner)
;	(vehicle_unload area5_turret_e gunner)
	
;	(ai_command_list covenant_area5/elites_w energylift_up_elite)
;	(ai_command_list covenant_area5/elites_o energylift_up_elite)
;	(ai_command_list covenant_area5/elites_q energylift_up_elite)
;	(ai_command_list covenant_area5/elites_g energylift_up_elite)
;	(ai_command_list covenant_area5/elites_e energylift_up_elite)
	
;	(ai_command_list covenant_area5/jackals_c energylift_up_jackal)
;	(ai_command_list covenant_area5/jackals_o energylift_up_jackal)
;	(ai_command_list covenant_area5/jackals_g energylift_up_jackal)
;	(ai_command_list covenant_area5/jackals_e energylift_up_jackal)
;	(ai_command_list covenant_area5/jackals_drop energylift_up_jackal)
	
;	(ai_command_list covenant_area5/grunts_a energylift_up_grunt)
;	(ai_command_list covenant_area5/grunts_o energylift_up_grunt)
;	(ai_command_list covenant_area5/grunts_g energylift_up_grunt)
;	(ai_command_list covenant_area5/grunts_e energylift_up_grunt)
;	(ai_command_list covenant_area5/grunts_q energylift_up_grunt)
;	(ai_command_list covenant_area5/grunts_drop energylift_up_grunt)
;	(ai_command_list covenant_area5/turret_gunner_a energylift_up_grunt)
;	(ai_command_list covenant_area5/turret_gunner_b energylift_up_grunt)
;	(ai_command_list covenant_area5/turret_gunner_c energylift_up_grunt)
;	(ai_command_list covenant_area5/turret_gunner_d energylift_up_grunt)
;	(ai_command_list covenant_area5/turret_gunner_e energylift_up_grunt)
;	)
	
(script dormant ini_area5_pelican
	(sleep_until (and (volume_test_objects area5_dropship_trigger (players))
				   (< (ai_living_count marines_area5) 1)))
	(if (and area5_pelican
		    (not (game_is_cooperative))) (pelican_area5_a))
	)

(script dormant ini_area5_c_dropship
	(sleep_until (< (ai_living_count covenant_area5) 3))
	(c_dropship_area5)
	(sleep_until (< (ai_living_count marines_area5/dropship_marines) 1))
	(ai_migrate covenant_area5/grunts_drop covenant_area5/squad_s)
	(ai_migrate covenant_area5/jackals_drop covenant_area5/squad_s)
	(sleep 1)
	(ai_follow_target_players covenant_area5/squad_s)
	)

(script dormant dialog_area5_guns
	(sleep_until (or (= (ai_status covenant_area5/turret_gunner_a) 6)
				  (= (ai_status covenant_area5/turret_gunner_b) 6)
				  (= (ai_status covenant_area5/turret_gunner_c) 6)
				  (= (ai_status covenant_area5/turret_gunner_d) 6)
				  (= (ai_status covenant_area5/turret_gunner_e) 6)))
				  
	(sleep -1 dialog_area5_initial)
	
	(if (> (ai_living_count marines_area5) 0) (ai_conversation area5_guns))
	(sleep_until (and (= (ai_living_count covenant_area5/turret_gunner_a) 0)
				   (= (ai_living_count covenant_area5/turret_gunner_b) 0)
				   (= (ai_living_count covenant_area5/turret_gunner_c) 0)
				   (= (ai_living_count covenant_area5/turret_gunner_d) 0)
				   (= (ai_living_count covenant_area5/turret_gunner_e) 0)))
	(if (> (ai_living_count marines_area5) 0) (ai_conversation area5_guns_clear))
	)

(script continuous ini_area5_cleanup_kill
	(if (< (ai_status covenant_area4) 3) (ai_kill_silent covenant_area4))
	(sleep 300)
	)

(script static void ini_marines_to_pad
	(ai_conversation lift_secured_alt)
	(ai_follow_target_disable marines_area5)
	(sleep 1)
	(ai_migrate marines_area5 marines_area5/gravity_pad_fodder)
	(sleep 1)
	(sleep_until (volume_test_objects gravity_pad_teleport_trigger (ai_actors marines_area5)) 30 210)
	)

;========== Encounter Scripts (Gravity Pad) ==========
	
(script dormant enc_grav_marines
;	(if debug (print "placing gravity pad marines"))
	(ai_place gravity_pad_marines)
	(sleep 1)
	(objects_predict (ai_actors gravity_pad_marines))
	)

(script dormant enc_grav_stealth_ini
	(ai_place gravity_pad_covenant/stealth_ini)
	)

(script dormant enc_grav_hunters
	(if (game_is_cooperative) (ai_place gravity_pad_covenant/grav_front_hunters)
	(cond
		((= (game_difficulty_get) normal) (ai_place gravity_pad_covenant/grav_front_jackals))
		((= (game_difficulty_get) hard) (ai_place gravity_pad_covenant/grav_front_hunters))
		((= (game_difficulty_get) impossible) (ai_place gravity_pad_covenant/grav_front_hunters))))
	
	(sleep_until (volume_test_objects grav_second_wave (players)))
	(ai_migrate gravity_pad_covenant gravity_pad_covenant/all)
	)
	
(script static void enc_grav_cov_frontleft
	(set grav_frontleft true)
;	(if debug (print "placing front left covenant"))
	(begin_random
		(if grav_frontleft
			(begin (ai_place gravity_pad_covenant/grav_frontleft_grunts)
;				  (if debug (print "grunts"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontleft_index gravity_enc_index) (set grav_frontleft false))))
		(if (and grav_frontleft
			    (= (game_difficulty_get) normal))
			(begin (ai_place gravity_pad_covenant/grav_frontleft_elites)
;				  (if debug (print "elites"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontleft_index gravity_enc_index) (set grav_frontleft false))))
		(if grav_frontleft
			(begin (ai_place gravity_pad_covenant/grav_frontleft_grunts_b)
;				  (if debug (print "grunts_b"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontleft_index gravity_enc_index) (set grav_frontleft false))))
		(if grav_frontleft
			(begin (ai_place gravity_pad_covenant/grav_frontleft_jackals)
;				  (if debug (print "jackals"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontleft_index gravity_enc_index) (set grav_frontleft false))))
		(if (and grav_frontleft
		   	    (= (game_difficulty_get) impossible))
			(begin (ai_place gravity_pad_covenant/frontleft_commander)
;				  (if debug (print "commander"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontleft_index gravity_enc_index) (set grav_frontleft false))))
		(if (and grav_frontleft
			    (= (game_difficulty_get) hard))
			(begin (ai_place gravity_pad_covenant/frontleft_stealth)
;				  (if debug (print "stealth"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontleft_index gravity_enc_index) (set grav_frontleft false)))))
	(set gravity_enc_index 0)
	)
	
(script static void enc_grav_cov_frontright
	(set grav_frontright true)
;	(if debug (print "placing front right covenant"))
	(begin_random
		(if grav_frontright
			(begin (ai_place gravity_pad_covenant/grav_frontright_grunts)
;				  (if debug (print "grunts"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontright_index gravity_enc_index) (set grav_frontright false))))
				  
		(if (and grav_frontright
			    (= (game_difficulty_get) normal))
			(begin (ai_place gravity_pad_covenant/grav_frontright_elites)
;				  (if debug (print "elites"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontright_index gravity_enc_index) (set grav_frontright false))))
				  
		(if grav_frontright
			(begin (ai_place gravity_pad_covenant/grav_frontright_grunts_b)
;				  (if debug (print "grunts_b"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontright_index gravity_enc_index) (set grav_frontright false))))
				  
		(if grav_frontright
			(begin (ai_place gravity_pad_covenant/grav_frontright_jackals)
;				  (if debug (print "jackals"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontright_index gravity_enc_index) (set grav_frontright false))))
		(if (and grav_frontright
		   	    (= (game_difficulty_get) impossible))
			(begin (ai_place gravity_pad_covenant/frontright_commander)
;				  (if debug (print "commander"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontright_index gravity_enc_index) (set grav_frontright false))))
				  
		(if (and grav_frontright
			    (= (game_difficulty_get) hard))
			(begin (ai_place gravity_pad_covenant/frontright_stealth)
;				  (if debug (print "stealth"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_frontright_index gravity_enc_index) (set grav_frontright false)))))
	(set gravity_enc_index 0)
	)
	
(script static void enc_grav_cov_rearleft
	(set grav_rearleft true)
;	(if debug (print "placing rear left covenant"))
	(begin_random
		(if grav_rearleft
			(begin (ai_place gravity_pad_covenant/grav_rearleft_grunts)
;				  (if debug (print "grunts"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearleft_index gravity_enc_index) (set grav_rearleft false))))
				  
		(if (and grav_rearleft
			    (= (game_difficulty_get) normal))
			(begin (ai_place gravity_pad_covenant/grav_rearleft_elites)
;				  (if debug (print "elites"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearleft_index gravity_enc_index) (set grav_rearleft false))))
				  
		(if grav_rearleft
			(begin (ai_place gravity_pad_covenant/grav_rearleft_grunts_b)
;				  (if debug (print "grunts_b"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearleft_index gravity_enc_index) (set grav_rearleft false))))
				  
		(if grav_rearleft
			(begin (ai_place gravity_pad_covenant/grav_rearleft_jackals)
;				  (if debug (print "jackals"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearleft_index gravity_enc_index) (set grav_rearleft false))))
		(if (and grav_rearleft
		   	    (= (game_difficulty_get) impossible))
			(begin (ai_place gravity_pad_covenant/rearleft_commander)
;				  (if debug (print "commander"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearleft_index gravity_enc_index) (set grav_rearleft false))))
				  
		(if (and grav_rearleft
			    (= (game_difficulty_get) hard))
			(begin (ai_place gravity_pad_covenant/rearleft_stealth)
;				  (if debug (print "stealth"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearleft_index gravity_enc_index) (set grav_rearleft false)))))
	(set gravity_enc_index 0)
	)
	
(script static void enc_grav_cov_rearright
	(set grav_rearright true)
;	(if debug (print "placing rear right covenant"))
	(begin_random
		(if grav_rearright
			(begin (ai_place gravity_pad_covenant/grav_rearright_grunts)
;				  (if debug (print "grunts"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearright_index gravity_enc_index) (set grav_rearright false))))
				  
		(if (and grav_rearright
		   	    (= (game_difficulty_get) normal))
			(begin (ai_place gravity_pad_covenant/grav_rearright_elites)
;				  (if debug (print "elites"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearright_index gravity_enc_index) (set grav_rearright false))))
				  
		(if grav_rearright
			(begin (ai_place gravity_pad_covenant/grav_rearright_grunts_b)
;				  (if debug (print "grunts_b"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearright_index gravity_enc_index) (set grav_rearright false))))
				  
		(if grav_rearright
			(begin (ai_place gravity_pad_covenant/grav_rearright_jackals)
;				  (if debug (print "jackals"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearright_index gravity_enc_index) (set grav_rearright false))))
		(if (and grav_rearright
		   	    (= (game_difficulty_get) impossible))
			(begin (ai_place gravity_pad_covenant/rearright_commander)
;				  (if debug (print "grunts_b"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearright_index gravity_enc_index) (set grav_rearright false))))
				  
		(if (and grav_rearright
			    (= (game_difficulty_get) hard))
			(begin (ai_place gravity_pad_covenant/rearright_stealth)
;				  (if debug (print "jackals"))
				  (set gravity_enc_index (+ 1 gravity_enc_index))
				  (if (= enc_grav_rearright_index gravity_enc_index) (set grav_rearright false)))))
	(set gravity_enc_index 0)
	)

;========== Initialization Scripts (Gravity Room) ==========

(script dormant gravity_marines_revive
	(sleep_until (= 2 gravity_wave_index) 60)
	(ai_renew gravity_pad_marines)
	(sleep_until (= 4 gravity_wave_index) 60)
	(ai_renew gravity_pad_marines)
	(sleep_until (= 6 gravity_wave_index) 60)
	(ai_renew gravity_pad_marines)
	(sleep_until (= 8 gravity_wave_index) 60)
	(ai_renew gravity_pad_marines)
	(sleep_until (= 10 gravity_wave_index) 60)
	(ai_renew gravity_pad_marines)
	)

(script continuous ini_gravity_wave
	(sleep_until gravity_wave)
;	(cond ((= 2 ini_grav_wave_index) (if debug (print "initializing gravity pad wave (three)")))
;		 ((= 3 ini_grav_wave_index) (if debug (print "initializing gravity pad wave (five)")))
;		 ((= 4 ini_grav_wave_index) (if debug (print "initializing gravity pad wave (seven)")))
;		 )
		 
	(begin_random
		(if gravity_wave
		   (if (and (= (volume_test_objects grav_leftfront_safe (players)) 0)
		   		  (= (device_get_position gravity_door_lf) 0))
			(begin (enc_grav_cov_frontleft)
;			  	  (sleep grav_frontleft_delay)
				  (set gravity_wave_index (+ 1 gravity_wave_index))
			  	  (if (= ini_grav_wave_index gravity_wave_index) (set gravity_wave false))
				  (inspect gravity_wave_index)
			  	  (sleep_until (< (ai_living_count gravity_pad_covenant) grav_cov_limit) 30 default_sleep_expire))))
			  	  
		(if gravity_wave
		   (if (and (= (volume_test_objects grav_rightfront_safe (players)) 0)
		   		  (= (device_get_position gravity_door_rf) 0))
			(begin (enc_grav_cov_frontright)
;				  (sleep grav_frontright_delay)
				  (set gravity_wave_index (+ 1 gravity_wave_index))
				  (if (= ini_grav_wave_index gravity_wave_index) (set gravity_wave false))
				  (inspect gravity_wave_index)
			  	  (sleep_until (< (ai_living_count gravity_pad_covenant) grav_cov_limit) 30 default_sleep_expire))))
				  
		(if gravity_wave		  
		   (if (and (= (volume_test_objects grav_leftrear_safe (players)) 0)
		   		  (= (device_get_position gravity_door_lr) 0))
			(begin (enc_grav_cov_rearleft)
;				  (sleep grav_rearleft_delay)
				  (set gravity_wave_index (+ 1 gravity_wave_index))
				  (if (= ini_grav_wave_index gravity_wave_index) (set gravity_wave false))
				  (inspect gravity_wave_index)
			  	  (sleep_until (< (ai_living_count gravity_pad_covenant) grav_cov_limit) 30 default_sleep_expire))))
		
		(if gravity_wave
		   (if (and (= (volume_test_objects grav_rightrear_safe (players)) 0)
		   		  (= (device_get_position gravity_door_rr) 0))
			(begin (enc_grav_cov_rearright)
;				  (sleep grav_rearright_delay)
				  (set gravity_wave_index (+ 1 gravity_wave_index))
				  (if (= ini_grav_wave_index gravity_wave_index) (set gravity_wave false))
				  (inspect gravity_wave_index)
			  	  (sleep_until (< (ai_living_count gravity_pad_covenant) grav_cov_limit) 30 default_sleep_expire)))))
				  
	(if (= ini_grav_wave_index gravity_wave_index) (set gravity_wave_index 0))
	(sleep 1)
	(objects_predict (ai_actors gravity_pad_covenant))
	)

;(script dormant ini_second_gravity_wave
;	(if debug (print "sleep until the player/marines see the locked door"))
;	(sleep_until (or (volume_test_objects muster_bay_big_entrance (ai_actors gravity_pad_marines))
;				  (and (= 0 (ai_living_count gravity_pad_marines))
;				  	  (volume_test_objects muster_bay_big_entrance (players)))))
;	(if debug (print "sleep until the player/marines go back up the ramp"))
;	(sleep_until (or (volume_test_objects muster_bay_big_entrance (ai_actors gravity_pad_marines))
;				  (and (= 0 (ai_living_count gravity_pad_marines))
;				  	  (volume_test_objects muster_bay_big_entrance (players)))))
;	(sleep grav_mar_return_delay)
;	(cond ((<= (ai_living_count gravity_pad_marines) 3) (begin (set gravity_wave true)
;												    (set ini_grav_wave_index 2)))
;		 ((<= (ai_living_count gravity_pad_marines) 5) (begin (set gravity_wave true)
;												    (set ini_grav_wave_index 3)))
;		 ((<= (ai_living_count gravity_pad_marines) 7) (begin (set gravity_wave true)
;												    (set ini_grav_wave_index 4))))
;	)

;(script static void ini_gravity_kill
;	(sleep -1 ini_gravity_wave)
;	)

;========== Encounter Scripts (Gravity - Muster Hallway) ==========

(script dormant enc_grav_mus_hall
	(sleep_until (volume_test_objects grav_muster_top_hall (players)))
;	(if debug (print "placing hallway covenant"))
	(ai_place grav_mus_hall_covenant/sidehall_grunts_left)
	(ai_place grav_mus_hall_covenant/sidehall_grunts_right)
	(ai_place grav_mus_hall_covenant/sidehall_elites_left)
	(ai_place grav_mus_hall_covenant/sidehall_elites_right)
	(ai_place grav_mus_hall_covenant/muster_grunts)
	(ai_place grav_mus_hall_covenant/muster_elites)
	(sleep 1)
	(objects_predict (ai_actors grav_mus_hall_covenant))
	)

(script continuous enc_grav_mus_hall_rear
	(sleep_until (volume_test_objects grav_muster_top_hall (players)))
	(sleep_until (= 0 (volume_test_objects grav_leftrear_safe (players))))
	(begin_random
		(if grav_mus_hall
			(begin (ai_place grav_mus_hall_covenant/rear_grunts)
;				  (if debug (print "spawning grunts"))
				  (set grav_mus_hall_index (+ 1 grav_mus_hall_index))
				  (if (= enc_grav_mus_hall_index grav_mus_hall_index) (set grav_mus_hall false))))
		
		(if grav_mus_hall
			(begin (ai_place grav_mus_hall_covenant/rear_jackals)
;				  (if debug (print "spawning jackals"))
				  (set grav_mus_hall_index (+ 1 grav_mus_hall_index))
				  (if (= enc_grav_mus_hall_index grav_mus_hall_index) (set grav_mus_hall false)))))
	(ai_magically_see_players grav_mus_hall_covenant/rear_grunts)
	(ai_magically_see_players grav_mus_hall_covenant/rear_jackals)
	(sleep (* 30 30))
	(set grav_mus_hall true)
	(set grav_mus_hall_index 0)
	(sleep 1)
	(objects_predict (ai_actors grav_mus_hall_covenant))
	)
	
;========== Encounter Scripts (Muster Bay Ledge) ==========

(script dormant enc_muster_ini
	(ai_place muster_bay_covenant_bottom/grunts_ini)
	(ai_place muster_bay_covenant_bottom/elites_ini)
	(ai_place muster_bay_covenant_bottom/jackals_ini)
	(sleep 1)
	(objects_predict (ai_actors muster_bay_covenant_bottom))
	)

;========== Initialization Scripts (Muster Bay Ledge) ==========

(script dormant ini_muster_hall
	(sleep_until (or (volume_test_objects mus_hangar_ledgehall (players))
				  (> (device_get_position muster_hall_door_b) 0)) 15)
	
;	(sleep_until (or (> (device_get_position muster_hall_door_b) 0)
;				  (> (device_get_position muster_ledge_door) 0)) 15)
	(ai_place muster_hall_cov/grunts_b)
	(ai_place muster_hall_cov/jackals_a)
	(ai_place muster_hall_cov/elites_c)
	(sleep 1)
	(device_set_power muster_ledge_door 1)
	(objects_predict (ai_actors muster_hall_cov))
	)


(script dormant ini_muster_bay_door_check
	(sleep_until (> (device_get_position muster_bay_door) .5))
	(sleep -1 man_marines_to_door)
	(set muster_bay_door_unlocked true)
;	(if debug (print "muster bay door is unlocked"))
	(deactivate_team_nav_point_object player muster_bay_control)
	(set play_music_a50_06 false)
	)
	
;========== Encounter Scripts (Muster Bay Bottom) ==========

(script dormant enc_muster_hangar_hall
	(ai_place muster_hangar_hall_cov/jackals_a)
	(ai_place muster_hangar_hall_cov/grunts_b)
	(ai_place muster_hangar_hall_cov/elites_c)
	(sleep 1)
	(objects_predict (ai_actors muster_bay_covenant_bottom))
	)

(script static void enc_mus_bot_l1
	(set muster_l1 true)
;	(if debug (print "placing muster_l1 covenant"))
	(begin_random
		(if muster_l1
			(begin (ai_place muster_bay_covenant_bottom/mus_jackals_l1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l1_index muster_enc_index) (set muster_l1 false)))
;				  (if debug (print "jackals l1"))
				  )
		
		(if muster_l1
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_l1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l1_index muster_enc_index) (set muster_l1 false)))
;				  (if debug (print "grunts l1"))
				  )

		(if muster_l1
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_b_l1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l1_index muster_enc_index) (set muster_l1 false)))
;				  (if debug (print "grunts l1"))
				  )

		(if muster_l1
			(begin (ai_place muster_bay_covenant_bottom/mus_elites_l1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l1_index muster_enc_index) (set muster_l1 false)))
;				  (if debug (print "elites l1"))
				  ))
	(set muster_enc_index 0)
	)

(script static void enc_mus_bot_l2
	(set muster_l2 true)
;	(if debug (print "placing muster_l2 covenant"))
	(begin_random
		(if muster_l2
			(begin (ai_place muster_bay_covenant_bottom/mus_jackals_l2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l2_index muster_enc_index) (set muster_l2 false)))
;				  (if debug (print "jackals l2"))
				  )
		
		(if muster_l2
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_l2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l2_index muster_enc_index) (set muster_l2 false)))
;				  (if debug (print "grunts l2"))
				  )

		(if muster_l2
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_b_l2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l2_index muster_enc_index) (set muster_l2 false)))
;				  (if debug (print "grunts l2"))
				  )

		(if muster_l2
			(begin (ai_place muster_bay_covenant_bottom/mus_elites_l2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l2_index muster_enc_index) (set muster_l2 false)))
;				  (if debug (print "elites l2"))
				  ))
	(set muster_enc_index 0)
	)

(script static void enc_mus_bot_l3
	(set muster_l3 true)
;	(if debug (print "placing muster_l3 covenant"))
	(begin_random
		(if muster_l3
			(begin (ai_place muster_bay_covenant_bottom/mus_jackals_l3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l3_index muster_enc_index) (set muster_l3 false)))
;				  (if debug (print "jackals l3"))
				  )
		
		(if muster_l3
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_l3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l3_index muster_enc_index) (set muster_l3 false)))
;				  (if debug (print "grunts l3"))
				  )

		(if muster_l3
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_b_l3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l3_index muster_enc_index) (set muster_l3 false)))
;				  (if debug (print "grunts l3"))
				  )

		(if muster_l3
			(begin (ai_place muster_bay_covenant_bottom/mus_elites_l3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_l3_index muster_enc_index) (set muster_l3 false)))
;				  (if debug (print "elites l3"))
				  ))
	(set muster_enc_index 0)
	)

(script static void enc_mus_bot_r1
	(set muster_r1 true)
;	(if debug (print "placing muster_r1 covenant"))
	(begin_random
		(if muster_r1
			(begin (ai_place muster_bay_covenant_bottom/mus_jackals_r1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r1_index muster_enc_index) (set muster_r1 false))
;				  (if debug (print "jackals r1"))
				  ))
		
		(if muster_r1
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_r1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r1_index muster_enc_index) (set muster_r1 false))
;				  (if debug (print "grunts r1"))
				  ))

		(if muster_r1
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_b_r1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r1_index muster_enc_index) (set muster_r1 false))
;				  (if debug (print "grunts r1"))
				  ))

		(if muster_r1
			(begin (ai_place muster_bay_covenant_bottom/mus_elites_r1)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r1_index muster_enc_index) (set muster_r1 false))
;				  (if debug (print "elites r1"))
				  )))
	(set muster_enc_index 0)
	)

(script static void enc_mus_bot_r2
	(set muster_r2 true)
;	(if debug (print "placing muster_r2 covenant"))
	(begin_random
		(if muster_r2
			(begin (ai_place muster_bay_covenant_bottom/mus_jackals_r2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r2_index muster_enc_index) (set muster_r2 false))
;				  (if debug (print "jackals r2"))
				  ))
		
		(if muster_r2
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_r2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r2_index muster_enc_index) (set muster_r2 false))
;				  (if debug (print "grunts r2"))
				  ))

		(if muster_r2
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_b_r2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r2_index muster_enc_index) (set muster_r2 false))
;				  (if debug (print "grunts r2"))
				  ))

		(if muster_r2
			(begin (ai_place muster_bay_covenant_bottom/mus_elites_r2)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r2_index muster_enc_index) (set muster_r2 false))
;				  (if debug (print "elites r2"))
				  )))
	(set muster_enc_index 0)
	)

(script static void enc_mus_bot_r3
	(set muster_r3 true)
;	(if debug (print "placing muster_r3 covenant"))
	(begin_random
		(if muster_r3
			(begin (ai_place muster_bay_covenant_bottom/mus_jackals_r3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r3_index muster_enc_index) (set muster_r3 false))
;				  (if debug (print "jackals r3"))
				  ))
		
		(if muster_r3
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_r3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r3_index muster_enc_index) (set muster_r3 false))
;				  (if debug (print "grunts r3"))
				  ))

		(if muster_r3
			(begin (ai_place muster_bay_covenant_bottom/mus_grunts_b_r3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r3_index muster_enc_index) (set muster_r3 false))
;				  (if debug (print "grunts r3"))
				  ))

		(if muster_r3
			(begin (ai_place muster_bay_covenant_bottom/mus_elites_r3)
				  (set muster_enc_index (+ 1 muster_enc_index))
				  (if (= enc_mus_bot_r3_index muster_enc_index) (set muster_r3 false))
;				  (if debug (print "elites r3"))
				  )))
	(set enc_mus_bot_r1_index 0)
	)
	
;========== Initialization Scripts (Muster Bay Bottom) ==========

(script dormant dialog_muster_clear
	(sleep_until (< (ai_status muster_bay_marines) 4))
	(ai_conversation muster_clear)
	)

(script dormant ini_muster_wave_normal
	(cond ((<= (ai_living_count muster_bay_marines) 1) (set ini_muster_wave_index 3)
											 (set muster_wave true))
		 ((<= (ai_living_count muster_bay_marines) 3) (set ini_muster_wave_index 5)
											 (set muster_wave true))
		 ((<= (ai_living_count muster_bay_marines) 5) (set ini_muster_wave_index 7)
											 (set muster_wave true)))
	)

(script dormant ini_muster_wave_hard
	(cond ((<= (ai_living_count muster_bay_marines) 1) (set ini_muster_wave_index 5)
											 (set muster_wave true))
		 ((<= (ai_living_count muster_bay_marines) 3) (set ini_muster_wave_index 7)
											 (set muster_wave true))
		 ((<= (ai_living_count muster_bay_marines) 5) (set ini_muster_wave_index 9)
											 (set muster_wave true)))
	)

(script dormant ini_muster_wave_legendary
	(cond ((<= (ai_living_count muster_bay_marines) 1) (set ini_muster_wave_index 7)
											 (set muster_wave true))
		 ((<= (ai_living_count muster_bay_marines) 3) (set ini_muster_wave_index 9)
											 (set muster_wave true))
		 ((<= (ai_living_count muster_bay_marines) 5) (set ini_muster_wave_index 11)
											 (set muster_wave true)))
	)

(script continuous ini_muster_wave_spawn
	(sleep_until muster_wave)
;	(cond ((= 2 ini_muster_wave_index) (if debug (print "initializing muster wave (two)")))
;		 ((= 4 ini_muster_wave_index) (if debug (print "initializing muster wave (four)")))
;		 ((= 6 ini_muster_wave_index) (if debug (print "initializing muster wave (six)")))
;		 )
	
	(begin_random
		(if muster_wave
		   (if (and (= 0 (volume_test_objects mus_l1_safe (players)))
		   		  (= (device_get_position muster_door_l1) 0))
			(begin (enc_mus_bot_l1)
;				  (sleep default_muster_delay)
				  (set muster_wave_index (+ 1 muster_wave_index))
				  (if (= ini_muster_wave_index muster_wave_index) (set muster_wave false))
				  (inspect muster_wave_index)
			  	  (sleep_until (< (ai_living_count muster_bay_covenant_bottom) muster_cov_limit) 30 default_sleep_expire))))
		(if muster_wave
		   (if (and (= 0 (volume_test_objects mus_l2_safe (players)))
		   		  (= (device_get_position muster_door_l2) 0))
			(begin (enc_mus_bot_l2)
;				  (sleep default_muster_delay)
				  (set muster_wave_index (+ 1 muster_wave_index))
				  (if (= ini_muster_wave_index muster_wave_index) (set muster_wave false))
				  (inspect muster_wave_index)
			  	  (sleep_until (< (ai_living_count muster_bay_covenant_bottom) muster_cov_limit) 30 default_sleep_expire))))
		(if muster_wave
		   (if (and (= 0 (volume_test_objects mus_l3_safe (players)))
		   		  (= (device_get_position muster_door_l3) 0))
			(begin (enc_mus_bot_l3)
;				  (sleep default_muster_delay)
				  (set muster_wave_index (+ 1 muster_wave_index))
				  (if (= ini_muster_wave_index muster_wave_index) (set muster_wave false))
				  (inspect muster_wave_index)
			  	  (sleep_until (< (ai_living_count muster_bay_covenant_bottom) muster_cov_limit) 30 default_sleep_expire))))
;		(if muster_wave
;		   (if (and (= 0 (volume_test_objects mus_r1_safe (players)))
;		   		  (= (device_get_position muster_door_r1) 0))
;			(begin (enc_mus_bot_r1)
;				  (sleep default_muster_delay)
;				  (set muster_wave_index (+ 1 muster_wave_index))
;				  (if (= ini_muster_wave_index muster_wave_index) (set muster_wave false))
;				  (inspect muster_wave_index)
;			  	  (sleep_until (< (ai_living_count muster_bay_covenant_bottom) muster_cov_limit) 30 default_sleep_expire))))
		(if muster_wave
		   (if (and (= 0 (volume_test_objects mus_r2_safe (players)))
		   		  (= (device_get_position muster_door_r2) 0))
			(begin (enc_mus_bot_r2)
;				  (sleep default_muster_delay)
				  (set muster_wave_index (+ 1 muster_wave_index))
				  (if (= ini_muster_wave_index muster_wave_index) (set muster_wave false))
				  (inspect muster_wave_index)
			  	  (sleep_until (< (ai_living_count muster_bay_covenant_bottom) muster_cov_limit) 30 default_sleep_expire))))
		(if muster_wave
		   (if (and (= 0 (volume_test_objects mus_r3_safe (players)))
		   		  (= 0 (volume_test_objects mus_r3_2_safe (players)))
		   		  (= (device_get_position muster_door_r3) 0))
			(begin (enc_mus_bot_r3)
;				  (sleep default_muster_delay)
				  (set muster_wave_index (+ 1 muster_wave_index))
				  (if (= ini_muster_wave_index muster_wave_index) (set muster_wave false))
				  (inspect muster_wave_index)
			  	  (sleep_until (< (ai_living_count muster_bay_covenant_bottom) muster_cov_limit) 30 default_sleep_expire)))))
	(if (= ini_muster_wave_index muster_wave_index) (set muster_wave_index 0))
	(sleep 1)
	(objects_predict (ai_actors muster_bay_covenant_bottom))
	)
	
(script dormant ini_muster_ledge
	(ai_place muster_bay_covenant_top/ledge_elites_side)
	(ai_place muster_bay_covenant_top/ledge_elites_back)
	(set muster_ledge true)
	(begin_random
		(if muster_ledge
			(begin (ai_place muster_bay_covenant_top/ledge_jackals_side)
				  (set muster_ledge_index (+ 1 muster_ledge_index))
			  	  (if (= ini_muster_ledge_index muster_ledge_index) (set muster_ledge false))))
			  	  
		(if muster_ledge
			(begin (ai_place muster_bay_covenant_top/ledge_grunts_middle)
				  (set muster_ledge_index (+ 1 muster_ledge_index))
				  (if (= ini_muster_ledge_index muster_ledge_index) (set muster_ledge false))))
				  
		(if muster_ledge		  
			(begin (ai_place muster_bay_covenant_top/ledge_jackals_back)
				  (set muster_ledge_index (+ 1 muster_ledge_index))
				  (if (= ini_muster_ledge_index muster_ledge_index) (set muster_ledge false)))))
	(if (= ini_muster_ledge_index muster_ledge_index) (set muster_ledge_index 0))
	(sleep 1)
	(objects_predict (ai_actors muster_bay_covenant_bottom))
	)
	
(script dormant ini_muster_hangar_hall
	(sleep_until (volume_test_objects muster_hangar_hall_trigger (players)))
	(wake enc_muster_hangar_hall)
	)
;========== Encounter Scripts (Hangar) ==========

(script dormant enc_hangar_hunters
	(if (and (= (volume_test_objects han_back_l_safe (players)) 0)
		    (= (device_get_position han_bot_l_door) 0))
	    (ai_place hangar_cov_first_floor/hunters_l))
	(sleep 1)
	
	(if (> (ai_living_count hangar_cov_first_floor/hunters_l) 0) (sleep -1))

	(if (and (= (volume_test_objects entr_safe (players)) 0)
		    (= (device_get_position hangar_first_floor_entr) 0))
	    (ai_place hangar_cov_first_floor/hunters_entr))
	(sleep 1)
	
	(if (or (> (ai_living_count hangar_cov_first_floor/hunters_l) 0) 
		   (> (ai_living_count hangar_cov_first_floor/hunters_entr) 0)) (sleep -1))

	(if (and (= (volume_test_objects han_back_r_safe (players)) 0)
		    (= (device_get_position han_bot_r_door) 0))
	    (ai_place hangar_cov_first_floor/hunters_r))
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_first_floor))
	)


(global boolean hangar_first_a true)
(global short hangar_first_counter_a 0)
(global short hangar_first_limit_a 2)

(script static void enc_hangar_first_a
	(if (and (= (volume_test_objects han_back_r_safe (players)) 0)
		    (= (device_get_position han_bot_r_door) 0))
	(begin
	(begin_random
		(if hangar_first_a
			(begin (ai_place hangar_cov_first_floor/grunts_a)
				  (set hangar_first_counter_a (+ 1 hangar_first_counter_a))
				  (if (= hangar_first_counter_a hangar_first_limit_a) (set hangar_first_a false))))
		(if hangar_first_a
			(begin (ai_place hangar_cov_first_floor/elites_a)
				  (set hangar_first_counter_a (+ 1 hangar_first_counter_a))
				  (if (= hangar_first_counter_a hangar_first_limit_a) (set hangar_first_a false))))
		(if hangar_first_a
			(begin (ai_place hangar_cov_first_floor/jackals_a)
				  (set hangar_first_counter_a (+ 1 hangar_first_counter_a))
				  (if (= hangar_first_counter_a hangar_first_limit_a) (set hangar_first_a false))))
		(if hangar_first_a
			(begin (ai_place hangar_cov_first_floor/grunts_a2)
				  (set hangar_first_counter_a (+ 1 hangar_first_counter_a))
				  (if (= hangar_first_counter_a hangar_first_limit_a) (set hangar_first_a false)))))
	(set hangar_first_a true)
	(set hangar_first_counter_a 0)))
	(device_set_position han_bot_r_door 1)
	)
	
(global boolean hangar_first_e true)
(global short hangar_first_counter_e 0)
(global short hangar_first_limit_e 2)

(script static void enc_hangar_first_e
	(begin_random
		(if hangar_first_e
			(begin (ai_place hangar_cov_first_floor/grunts_e)
				  (set hangar_first_counter_e (+ 1 hangar_first_counter_e))
				  (if (= hangar_first_counter_e hangar_first_limit_e) (set hangar_first_e false))))
		(if hangar_first_e
			(begin (ai_place hangar_cov_first_floor/grunts_e2)
				  (set hangar_first_counter_e (+ 1 hangar_first_counter_e))
				  (if (= hangar_first_counter_e hangar_first_limit_e) (set hangar_first_e false))))
		(if hangar_first_e
			(begin (ai_place hangar_cov_first_floor/jackals_e)
				  (set hangar_first_counter_e (+ 1 hangar_first_counter_e))
				  (if (= hangar_first_counter_e hangar_first_limit_e) (set hangar_first_e false))))
		(if hangar_first_e
			(begin (ai_place hangar_cov_first_floor/elites_e)
				  (set hangar_first_counter_e (+ 1 hangar_first_counter_e))
				  (if (= hangar_first_counter_e hangar_first_limit_e) (set hangar_first_e false)))))
	(set hangar_first_e true)
	(set hangar_first_counter_e 0)
	(sleep 1)
	(device_set_position han_bot_r_door 1)
	)
	
(global boolean hangar_first_i true)
(global short hangar_first_counter_i 0)
(global short hangar_first_limit_i 2)

(script static void enc_hangar_first_i
	(begin_random
		(if hangar_first_i
			(begin (ai_place hangar_cov_first_floor/grunts_i)
				  (set hangar_first_counter_i (+ 1 hangar_first_counter_i))
				  (if (= hangar_first_counter_i hangar_first_limit_i) (set hangar_first_i false))))
		(if hangar_first_i
			(begin (ai_place hangar_cov_first_floor/grunts_i2)
				  (set hangar_first_counter_i (+ 1 hangar_first_counter_i))
				  (if (= hangar_first_counter_i hangar_first_limit_i) (set hangar_first_i false))))
		(if hangar_first_i
			(begin (ai_place hangar_cov_first_floor/jackals_i)
				  (set hangar_first_counter_i (+ 1 hangar_first_counter_i))
				  (if (= hangar_first_counter_i hangar_first_limit_i) (set hangar_first_i false))))
		(if hangar_first_i
			(begin (ai_place hangar_cov_first_floor/elites_i)
				  (set hangar_first_counter_i (+ 1 hangar_first_counter_i))
				  (if (= hangar_first_counter_i hangar_first_limit_i) (set hangar_first_i false)))))
	(set hangar_first_i true)
	(set hangar_first_counter_i 0)
	)
	
(global boolean hangar_first_q true)
(global short hangar_first_counter_q 0)
(global short hangar_first_limit_q 2)

(script static void enc_hangar_first_q
	(if (and (= (volume_test_objects han_back_l_safe (players)) 0)
		    (= (device_get_position han_bot_l_door) 0))
	(begin
	(begin_random
		(if hangar_first_q
			(begin (ai_place hangar_cov_first_floor/grunts_q)
				  (set hangar_first_counter_q (+ 1 hangar_first_counter_q))
				  (if (= hangar_first_counter_q hangar_first_limit_q) (set hangar_first_q false))))
		(if hangar_first_q
			(begin (ai_place hangar_cov_first_floor/grunts_q2)
				  (set hangar_first_counter_q (+ 1 hangar_first_counter_q))
				  (if (= hangar_first_counter_q hangar_first_limit_q) (set hangar_first_q false))))
		(if hangar_first_q
			(begin (ai_place hangar_cov_first_floor/jackals_q)
				  (set hangar_first_counter_q (+ 1 hangar_first_counter_q))
				  (if (= hangar_first_counter_q hangar_first_limit_q) (set hangar_first_q false))))
		(if hangar_first_q
			(begin (ai_place hangar_cov_first_floor/elites_q)
				  (set hangar_first_counter_q (+ 1 hangar_first_counter_q))
				  (if (= hangar_first_counter_q hangar_first_limit_q) (set hangar_first_q false)))))
	(set hangar_first_q true)
	(set hangar_first_counter_q 0)))
	(sleep 1)
	(device_set_position han_bot_l_door 1)
	)
	
(global boolean hangar_first_s true)
(global short hangar_first_counter_s 0)
(global short hangar_first_limit_s 1)

(script static void enc_hangar_first_s
	(if (and (= (volume_test_objects han_exit_safe (players)) 0)
		    (= (device_get_position hangar_exit) 0))
	(begin
	(begin_random
		(if hangar_first_s
			(begin (ai_place hangar_cov_first_floor/grunts_s)
				  (set hangar_first_counter_s (+ 1 hangar_first_counter_s))
				  (if (= hangar_first_counter_s hangar_first_limit_s) (set hangar_first_s false))))
		(if hangar_first_s
			(begin (ai_place hangar_cov_first_floor/grunts_s2)
				  (set hangar_first_counter_s (+ 1 hangar_first_counter_s))
				  (if (= hangar_first_counter_s hangar_first_limit_s) (set hangar_first_s false))))
		(if hangar_first_s
			(begin (ai_place hangar_cov_first_floor/jackals_s)
				  (set hangar_first_counter_s (+ 1 hangar_first_counter_s))
				  (if (= hangar_first_counter_s hangar_first_limit_s) (set hangar_first_s false))))
		(if hangar_first_s
			(begin (ai_place hangar_cov_first_floor/elites_s)
				  (set hangar_first_counter_s (+ 1 hangar_first_counter_s))
				  (if (= hangar_first_counter_s hangar_first_limit_s) (set hangar_first_s false)))))
	(set hangar_first_s true)
	(set hangar_first_counter_s 0)))
	(sleep 1)
	(device_set_position hangar_exit 1)
	)
	
(global boolean hangar_first_y true)
(global short hangar_first_counter_y 0)
(global short hangar_first_limit_y 2)

(script static void enc_hangar_first_y
	(if (and (= (volume_test_objects entr_safe (players)) 0)
		    (= (device_get_position hangar_first_floor_entr) 0))
	(begin
	(begin_random
		(if hangar_first_y
			(begin (ai_place hangar_cov_first_floor/grunts_y)
				  (set hangar_first_counter_y (+ 1 hangar_first_counter_y))
				  (if (= hangar_first_counter_y hangar_first_limit_y) (set hangar_first_y false))))
		(if hangar_first_y
			(begin (ai_place hangar_cov_first_floor/grunts_y2)
				  (set hangar_first_counter_y (+ 1 hangar_first_counter_y))
				  (if (= hangar_first_counter_y hangar_first_limit_y) (set hangar_first_y false))))
		(if hangar_first_y
			(begin (ai_place hangar_cov_first_floor/jackals_y)
				  (set hangar_first_counter_y (+ 1 hangar_first_counter_y))
				  (if (= hangar_first_counter_y hangar_first_limit_y) (set hangar_first_y false))))
		(if hangar_first_y
			(begin (ai_place hangar_cov_first_floor/elites_y)
				  (set hangar_first_counter_y (+ 1 hangar_first_counter_y))
				  (if (= hangar_first_counter_y hangar_first_limit_y) (set hangar_first_y false)))))
	(set hangar_first_y true)
	(set hangar_first_counter_y 0)))
	(sleep 1)
	(device_set_position hangar_first_floor_entr 1)
	)

(global boolean hangar_second_a true)
(global short hangar_second_counter_a 0)
(global short hangar_second_limit_a 2)

(script static void enc_hangar_second_a
	(if (and (= (volume_test_objects hangar_second_safe_a (players)) 0)
		    (= (device_get_position hangar_second_door_a) 0))
	(begin
	(begin_random
		(if hangar_second_a
			(begin (ai_place hangar_cov_second_floor/grunts_a)
				  (set hangar_second_counter_a (+ 1 hangar_second_counter_a))
				  (if (= hangar_second_counter_a hangar_first_limit_y) (set hangar_second_a false))))
		(if hangar_second_a
			(begin (ai_place hangar_cov_second_floor/elites_a)
				  (set hangar_second_counter_a (+ 1 hangar_second_counter_a))
				  (if (= hangar_second_counter_a hangar_first_limit_y) (set hangar_second_a false))))
		(if hangar_second_a
			(begin (ai_place hangar_cov_second_floor/jackals_a)
				  (set hangar_second_counter_a (+ 1 hangar_second_counter_a))
				  (if (= hangar_second_counter_a hangar_first_limit_y) (set hangar_second_a false))))
	(set hangar_second_a true)
	(set hangar_second_counter_a 0))))
	(sleep 1)
	(device_set_position hangar_second_door_a 1)
	)

(global boolean hangar_second_e true)
(global short hangar_second_counter_e 0)
(global short hangar_second_limit_e 2)


(script static void enc_hangar_second_e
	(if (and (= (volume_test_objects hangar_second_trigger_a (players)) 0)
		    (= (device_get_position hangar_second_door_e ) 0))
	(begin
	(begin_random
		(if hangar_second_e
			(begin (ai_place hangar_cov_second_floor/grunts_e)
				  (set hangar_second_counter_e (+ 1 hangar_second_counter_e))
				  (if (= hangar_second_counter_e hangar_first_limit_y) (set hangar_second_e false))))
		(if hangar_second_e
			(begin (ai_place hangar_cov_second_floor/elites_e)
				  (set hangar_second_counter_e (+ 1 hangar_second_counter_e))
				  (if (= hangar_second_counter_e hangar_first_limit_y) (set hangar_second_e false))))
		(if hangar_second_e
			(begin (ai_place hangar_cov_second_floor/jackals_e)
				  (set hangar_second_counter_e (+ 1 hangar_second_counter_e))
				  (if (= hangar_second_counter_e hangar_first_limit_y) (set hangar_second_e false))))
	(set hangar_second_e true)
	(set hangar_second_counter_e 0))))
	(sleep 1)
	(device_set_position hangar_second_door_e 1)
	)

(global boolean hangar_second_i true)
(global short hangar_second_counter_i 0)
(global short hangar_second_limit_i 2)

(script static void enc_hangar_second_i
	(if (and (= (volume_test_objects hangar_second_trigger_c (players)) 0)
		    (= (device_get_position hangar_second_door_q) 0))
	(begin
	(begin_random
		(if hangar_second_i
			(begin (ai_place hangar_cov_second_floor/grunts_i)
				  (set hangar_second_counter_i (+ 1 hangar_second_counter_i))
				  (if (= hangar_second_counter_i hangar_first_limit_y) (set hangar_second_i false))))
		(if hangar_second_i
			(begin (ai_place hangar_cov_second_floor/elites_i)
				  (set hangar_second_counter_i (+ 1 hangar_second_counter_i))
				  (if (= hangar_second_counter_i hangar_first_limit_y) (set hangar_second_i false))))
		(if hangar_second_i
			(begin (ai_place hangar_cov_second_floor/jackals_i)
				  (set hangar_second_counter_i (+ 1 hangar_second_counter_i))
				  (if (= hangar_second_counter_i hangar_first_limit_y) (set hangar_second_i false))))
	(set hangar_second_i true)
	(set hangar_second_counter_i 0))))
	(sleep 1)
	(device_set_position hangar_second_door_q 1)
	)

(global boolean hangar_second_q true)
(global short hangar_second_counter_q 0)
(global short hangar_second_limit_q 2)

(script static void enc_hangar_second_q
	(if (and (= (volume_test_objects hangar_second_trigger_c (players)) 0)
		    (= (device_get_position hangar_second_door_q) 0))
	(begin
	(begin_random
		(if hangar_second_q
			(begin (ai_place hangar_cov_second_floor/grunts_q)
				  (set hangar_second_counter_q (+ 1 hangar_second_counter_q))
				  (if (= hangar_second_counter_q hangar_first_limit_y) (set hangar_second_q false))))
		(if hangar_second_q
			(begin (ai_place hangar_cov_second_floor/elites_q)
				  (set hangar_second_counter_q (+ 1 hangar_second_counter_q))
				  (if (= hangar_second_counter_q hangar_first_limit_y) (set hangar_second_q false))))
		(if hangar_second_q
			(begin (ai_place hangar_cov_second_floor/jackals_q)
				  (set hangar_second_counter_q (+ 1 hangar_second_counter_q))
				  (if (= hangar_second_counter_q hangar_first_limit_y) (set hangar_second_q false))))
	(set hangar_second_q true)
	(set hangar_second_counter_q 0))))
	(sleep 1)
	(device_set_position hangar_second_door_q 1)
	)

(script static void enc_hangar_second_elites_a
	(ai_place hangar_cov_second_floor/elites_ledge_a)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_second_floor))
	)

(script static void enc_hangar_second_elites_b
	(ai_place hangar_cov_second_floor/elites_ledge_b)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_second_floor))
	)

(script static void enc_hangar_second_elites_c
	(ai_place hangar_cov_second_floor/elites_ledge_c)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_second_floor))
	)

(script static void enc_hangar_third_a
	(if (and (= (volume_test_objects hangar_third_safe_a (players)) 0)
		    (= (device_get_position hangar_third_door_a) 0))
	(begin
	(ai_place hangar_cov_third_floor/grunts_a)
;	(ai_place hangar_cov_third_floor/elites_a)
	(ai_place hangar_cov_third_floor/jackals_a)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_third_floor))
	(device_set_position hangar_third_door_a 1)
	)))

(script static void enc_hangar_third_e
	(if (and (= (volume_test_objects hangar_third_safe_e (players)) 0)
		    (= (device_get_position hangar_third_door_e) 0))
	(begin
	(ai_place hangar_cov_third_floor/grunts_e)
	(ai_place hangar_cov_third_floor/elites_e)
;	(ai_place hangar_cov_third_floor/jackals_e)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_third_floor))
	(device_set_position hangar_third_door_e 1)
	)))

(script static void enc_hangar_third_i
	(if (and (= (volume_test_objects hangar_third_safe_m (players)) 0)
		    (= (device_get_position hangar_door_c) 0))
	(begin
	(ai_place hangar_cov_third_floor/grunts_i)
;	(ai_place hangar_cov_third_floor/elites_i)
	(ai_place hangar_cov_third_floor/jackals_i)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_third_floor))
	(device_set_position hangar_door_c 1)
	)))

(script static void enc_hangar_third_m
	(if (and (= (volume_test_objects hangar_third_safe_m (players)) 0)
		    (= (device_get_position hangar_door_c) 0))
	(begin
;	(ai_place hangar_cov_third_floor/grunts_m)
	(ai_place hangar_cov_third_floor/elites_m)
	(ai_place hangar_cov_third_floor/jackals_m)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_third_floor))
;	(device_set_position hangar_door_c 1)
	)))

(script dormant enc_hangar_lefthall
	(ai_place hangar_lefthall_cov/stealth_g)
	(ai_place hangar_lefthall_cov/stealth_e)
	(ai_place hangar_lefthall_cov/elites_a)
	
	(if (< (ai_living_count hangar_cov_first_floor) 5)
		(begin
			(ai_place hangar_lefthall_cov/grunts_a)
			(ai_place hangar_lefthall_cov/grunts_e)
			(ai_place hangar_lefthall_cov/jackals_i)))
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_third_floor))
	)

(script dormant enc_hangar_righthall
	(ai_place hangar_righthall_cov/grunts_a)
	(ai_place hangar_righthall_cov/jackals_c)
	(ai_place hangar_righthall_cov/elites_c)
	(ai_place hangar_righthall_cov/grunts_g)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_third_floor))
	)

;========== Initialization Scripts (Hangar Bay) ==========

(script static void test_hangar_door
	(object_destroy extraction_machine)
	(object_create extraction_control)
	(device_set_power hangar_door_b 1)
	(device_set_position hangar_door_b 0)
	(sleep_until (= (device_get_position hangar_door_b) 1))
	(device_set_power hangar_door_b 0)
	)

(script dormant ini_hangar_hall_open
	(set pelican_hangar_a_trigger 0)
	(sleep 1)
;	(device_set_power hangar_door_b 1)
;	(device_set_position hangar_door_b 0)

	(sleep 60)
	(wake enc_hangar_hunters)
	(wake music_a50_072)
	(ai_migrate hangar_cov_second_floor hangar_cov_second_floor/ledge_retreat)
	(ai_follow_target_players hangar_marines)
	
;	(sleep_until (= (ai_living_count hangar_cov_first_floor) 0))

	(sleep_until (and (= (ai_living_count hangar_cov_first_floor/hunters_entr) 0)
				   (= (ai_living_count hangar_cov_first_floor/hunters_r) 0)
				   (= (ai_living_count hangar_cov_first_floor/hunters_l) 0)) (* 30 20))

;	(enc_hangar_first_s)
	(set play_music_a50_072 0)
	(sleep 90)
	(if (and (= (device_get_position hangar_exit) 0)
		    (= (volume_test_objects hangar_first_trigger_a (players)) 0))
	    (ai_conversation shuttle_hall_door_open))
	(sleep 1)
	(device_one_sided_set hangar_exit 0)
	(device_set_position hangar_exit 1)
	
	(sleep_until (= (device_get_position hangar_exit) 1) 1)
	(device_set_power hangar_exit 0)
	(if (= (volume_test_objects hangar_first_trigger_a (players)) 0)
		(activate_team_nav_point_object "default_red" player hangar_exit .3))
	(sleep 60)
	
	(sleep_until (volume_test_objects hangar_first_trigger_a (players)))
	(ai_place hangar_cov_first_floor/grunts_w)
	(device_set_position hangar_lefthall_door 1)
	(ai_kill_silent hangar_cov_second_floor)
	(wake enc_hangar_lefthall)
	(deactivate_team_nav_point_object player hangar_exit)
	(ai_migrate hangar_marines hangar_marines_halls/squad_a)
	(ai_migrate hangar_cov_first_floor hangar_lefthall_cov/all)
	(ai_magically_see_players hangar_lefthall_cov/all)
	(ai_follow_target_players hangar_marines_halls)
	(ai_follow_target_players prison_marines)
	)

(script dormant ini_hover_hangar_dropships
	(object_create hangar_dropship_a)
	(vehicle_hover hangar_dropship_a 1)
	(sleep 1)
	(ai_braindead_by_unit hangar_dropship_a true)
	)

(script dormant ini_hangar_initial
	(enc_hangar_second_elites_a)
	(enc_hangar_first_i)
	(hangar_dropship_b)
	)
	
;marines in A
(script dormant ini_hangar_first_wave_a
	(enc_hangar_first_a)
	(enc_hangar_first_e)
	)

;marines in B
(script dormant ini_hangar_first_wave_b
	(enc_hangar_first_y)
	(ai_place hangar_cov_second_floor/jackals_o)
	(ai_place hangar_cov_second_floor/grunts_q)
	(sleep 1)
	(ai_migrate hangar_cov_first_floor hangar_cov_first_floor/marines_in_b)
	(ai_magically_see_players hangar_cov_first_floor/marines_in_b)

	(ai_magically_see_encounter hangar_cov_second_floor/jackals_o hangar_marines)
	(ai_magically_see_encounter hangar_cov_second_floor/grunts_q hangar_marines)
	
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_first_floor))
	)

;marines in D
(script dormant ini_hangar_first_wave_d
	(enc_hangar_first_a)
	(enc_hangar_first_q)
	(sleep 1)
	(ai_migrate hangar_cov_first_floor hangar_cov_first_floor/marines_in_d)
	(ai_magically_see_players hangar_cov_first_floor/marines_in_d)
	)

;marines in E
(script dormant ini_hangar_first_wave_e
;	(enc_hangar_first_q)
	(enc_hangar_first_y)
	(ai_place hangar_cov_second_floor/grunts_a)
	(sleep 1)
	(ai_migrate hangar_cov_first_floor hangar_cov_first_floor/marines_in_e)
	(ai_magically_see_players hangar_cov_first_floor/marines_in_e)
	)

;marines in F
(script dormant ini_hangar_first_wave_f
	(enc_hangar_first_a)
	(enc_hangar_first_y)
	(sleep 1)
;	(ai_place hangar_cov_second_floor/jackals_i)
	(ai_migrate hangar_cov_first_floor hangar_cov_first_floor/marines_in_f)
	(ai_magically_see_players hangar_cov_first_floor/marines_in_f)
	)

(script dormant ini_hangar_second_wave_h
	(enc_hangar_second_i)
	(enc_hangar_second_a)
	(sleep 1)
	(ai_migrate hangar_cov_second_floor hangar_cov_second_floor/marines_in_g)
	(ai_migrate hangar_lefthall_cov hangar_cov_second_floor/marines_in_g)
	)

(script dormant ini_hangar_second_wave_i
	(cond
		((< (ai_living_count hangar_cov_second_floor) 7) (enc_hangar_second_e))
		((< (ai_living_count hangar_cov_third_floor) 7) (ai_place hangar_cov_third_floor/jackals_a))
		((< (ai_living_count hangar_cov_third_floor) 5) (ai_place hangar_cov_third_floor/grunts_i)))
	(sleep 1)
	(ai_migrate hangar_cov_second_floor hangar_cov_second_floor/marines_in_h)
	)

(script dormant ini_hangar_second_wave_j
	(if (< (ai_living_count hangar_cov_second_floor) 7) (enc_hangar_second_q))
	(sleep 1)
	(ai_migrate hangar_cov_second_floor hangar_cov_second_floor/marines_in_i)
	)
	
(script dormant ini_hangar_third_wave_k
	(if (< (ai_living_count hangar_cov_third_floor) 5) (enc_hangar_third_e))
	(sleep 1)
	(ai_migrate hangar_cov_third_floor hangar_cov_third_floor/marines_in_p)
	(ai_migrate hangar_righthall_cov hangar_cov_third_floor/marines_in_p)
	)

(script dormant ini_hangar_third_wave_l
	(if (< (ai_living_count hangar_cov_third_floor) 5) (enc_hangar_third_i))
	(sleep 1)
	(if (< (ai_living_count hangar_cov_third_floor) 8) (enc_hangar_third_a))
	(sleep 1)
	(ai_migrate hangar_cov_third_floor hangar_cov_third_floor/marines_in_q)
	)

(script dormant ini_hangar_third_wave_m
	(if (< (ai_living_count hangar_cov_third_floor) 5) (enc_hangar_third_m))
	(sleep 1)
	(if (< (ai_living_count hangar_cov_third_floor) 8) (enc_hangar_third_e))
	(sleep 1)
	(ai_migrate hangar_cov_third_floor hangar_cov_third_floor/marines_in_r)
	)

(script dormant ini_hangar_pelican_a
	(sleep_until (< (ai_living_count hangar_marines) 1))
	(if (or (game_is_cooperative)
		   (= (game_difficulty_get) impossible)
		   (not (volume_test_objects hangar_pelican_a_trigger (players)))) (sleep -1))
	(ai_conversation shuttle_bay_doors_open)
	(sleep 360)
	(if pelican_hangar_a_trigger (wake pelican_hangar_a))
	)

(script dormant ini_hangar_pelican_b
	(device_set_power hangar_door_b 1)
	(device_set_position hangar_door_b 0)
	(if (or (game_is_cooperative)
		   (= (game_difficulty_get) impossible)
		   (> (ai_living_count hangar_marines_halls) 1)) (sleep -1))
	(sleep 1)
	(ai_conversation shuttle_second_reins_ini)

	(sleep_until (volume_test_objects hangar_second_reins_trigger (players)))
	(activate_team_nav_point_object "default_red" player hangar_door_b_control .7)
	
	(sleep_until (> (device_get_position hangar_door_b) 0) 10)
	(wake general_save)
	(device_set_power hangar_door_b_control 0)
	(wake music_a50_071)
	(sleep_until (= (device_get_position hangar_door_b) 1) 10)
	(device_set_power hangar_door_b 0)
	(ai_conversation shuttle_second_door_open)
	(deactivate_team_nav_point_object player hangar_door_b_control)
	(pelican_hangar_b)
	(sleep 1800)
	(device_set_power hangar_door_b 1)
	(device_set_position hangar_door_b 0)
	(device_set_position hangar_door_b_control 0)
	)

;(script dormant ini_shuttle_elites_switch
;	(ai_command_list hangar_cov_second_floor/elites_ledge_a shuttle_elites_switch)
;	(sleep_until (volume_test_objects shuttle_door_switch_trigger (ai_actors hangar_cov_second_floor/elites_ledge_a)))
;	(sleep 150)
;	(if (volume_test_objects shuttle_door_switch_trigger (ai_actors hangar_cov_second_floor/elites_ledge_a))
;	    (begin (device_group_set hangar_door_b_power 1) (ai_conversation shuttle_bay_door_closed)))
;	)

;(script dormant ini_shuttle_grunts_switch
;	(ai_place hangar_cov_second_floor/switch_runner)
;	(ai_command_list hangar_cov_second_floor/switch_runner shuttle_switch_runner)
;	(activate_team_nav_point_object default_red player (unit (list_get (ai_actors hangar_cov_second_floor/switch_runner) 0)) .6)
;	(sleep 90)
;	(ai_conversation shuttle_bay_door_runner)
;	(sleep_until (volume_test_objects shuttle_door_switch_trigger (ai_actors hangar_cov_second_floor/switch_runner)) 30 900)
;	(sleep 150)
;	(if (volume_test_objects shuttle_door_switch_trigger (ai_actors hangar_cov_second_floor/switch_runner))
;	    (begin (device_group_set hangar_door_b_power 1) (ai_conversation shuttle_bay_door_closed))
; else
;	    (wake pelican_hangar_a))
;	)

;(script dormant ini_shuttle_switch_runner
;	(ai_conversation shuttle_bay_doors_open)
;	(sleep_until (> (ai_conversation_status shuttle_bay_doors_open) 4))
	
;	(activate_team_nav_point_object default_red player (unit (list_get (ai_actors hangar_cov_second_floor/elites_ledge_a) 0)) .6)
;	(sleep_until (> (ai_status hangar_cov_second_floor/elites_ledge_a) 4))
;	(sleep (* 30 10))
;	(if (> (ai_living_count hangar_cov_second_floor/elites_ledge_a) 0)
;	    (wake ini_shuttle_elites_switch))
;	(sleep_until (= (ai_living_count hangar_cov_second_floor/elites_ledge_a) 0))
;	(if (= (device_get_position hangar_door_b) 1)
;	    (wake ini_shuttle_grunts_switch))
;	)

;========== Encounter Scripts (Control Room) ==========

(script dormant enc_control_in_room
	(ai_place control_covenant/pad_elites_major)
	(ai_place control_covenant/elites_left)
	(ai_place control_covenant/elites_right)
	(ai_place control_covenant/grunts_k)
	(ai_place control_covenant/grunts_m)
;	(ai_place control_engineers/left)
;	(ai_place control_engineers/right)
	(sleep 1)
	(objects_predict (ai_actors control_covenant))
	)

(script dormant enc_control_reins_a
	(ai_place control_covenant/jackals_reins)
	(sleep 1)
	(objects_predict (ai_actors control_covenant))
	)

(script dormant enc_control_reins_b
	(ai_place control_covenant/grunts_reins)
	(sleep 1)
	(objects_predict (ai_actors control_covenant))
	)

(script dormant enc_control_return
	(ai_place control_covenant/stealth_elites)
;	(ai_place control_engineers/left)
;	(ai_place control_engineers/right)
	(sleep 1)
	(objects_predict (ai_actors control_covenant))
	)

(script dormant enc_control_return_reins
	(ai_place control_covenant/grunts_return)
	(sleep 1)
	(objects_predict (ai_actors control_covenant))
	)
	
(script dormant dialog_control_clear
	(sleep_until (= (ai_living_count control_covenant) 0))
	(sleep 90)
	(ai_conversation command_clear)
	)

;========== Encounter Scripts (Prison Area) ==========

(script dormant enc_prison_cov_ini
	(ai_place control_prison_hall_cov/jackals_s)
	(ai_place control_prison_hall_cov/jackals_c)
	(ai_place control_prison_hall_cov/grunts_a)
	(ai_place control_prison_hall_cov/jackals_i)
	(sleep 1)
	(objects_predict (ai_actors control_prison_hall_cov))
	)

(script dormant enc_prison_return_ini
	(ai_place control_prison_hall_cov/elites_m)
	(ai_place control_prison_hall_cov/grunts_i)
	(ai_place control_prison_hall_cov/jackals_g)
	(ai_place control_prison_hall_cov/elites_s)
	(ai_place control_prison_hall_cov/elites_q)
	(ai_place control_prison_hall_cov/grunts_q)
	(ai_place control_prison_hall_cov/jackals_s)
	(ai_place control_prison_hall_cov/grunts_k)
	(sleep 1)
	(objects_predict (ai_actors control_prison_hall_cov))
	)

(script dormant enc_spawn_captain
	(object_create keyes_prison)
	(ai_attach keyes_prison prison_marines_ini/captain)
	(custom_animation keyes_prison cinematics\animations\captain\level_specific\A50\A50 A50keyessit false)
	(sleep 1)
	(objects_predict keyes_prison)
	)

(script dormant enc_spawn_marines
	(object_create jailed_marine_1)
	(object_create jailed_marine_2)
	(object_create jailed_marine_3)
	(ai_attach jailed_marine_1 prison_marines_ini/marines_cellblock_d)
	(ai_attach jailed_marine_2 prison_marines_ini/marines_cellblock_d)
	(ai_attach jailed_marine_3 prison_marines_ini/marines_cellblock_d)
	(sleep 1)
	(objects_predict jailed_marine_1)
	(objects_predict jailed_marine_2)
	(objects_predict jailed_marine_3)
	(custom_animation jailed_marine_1 cinematics\animations\marines\level_specific\A50\A50 A50cellsit false)
	(custom_animation jailed_marine_2 cinematics\animations\marines\level_specific\A50\A50 A50cellsit false)
	(custom_animation jailed_marine_3 cinematics\animations\marines\level_specific\A50\A50 A50cellsit false)
	
	(sleep_until (or (objects_can_see_object (players) jailed_marine_1 10)
				  (objects_can_see_object (players) jailed_marine_2 10)
				  (objects_can_see_object (players) jailed_marine_3 10)))
	(custom_animation jailed_marine_1 cinematics\animations\marines\level_specific\A50\A50 A50cellcelebrate01 true)
	(custom_animation jailed_marine_2 cinematics\animations\marines\level_specific\A50\A50 A50cellcelebrate02 true)
	(custom_animation jailed_marine_3 cinematics\animations\marines\level_specific\A50\A50 A50cellcelebrate01 true)
	
	(sleep_until (= (ai_living_count prison_cell_d_covenant) 0))
	(unit_stop_custom_animation jailed_marine_1)
	(unit_stop_custom_animation jailed_marine_2)
	(unit_stop_custom_animation jailed_marine_3)
	)

(script dormant enc_prison_cell_d_cov
	(ai_place prison_cell_d_covenant/elite_commander)
	(ai_place prison_cell_d_covenant/elites_left)
	(ai_place prison_cell_d_covenant/elites_right)
	(ai_place prison_cell_d_covenant/grunts_ini)
	(sleep 1)
	(objects_predict (ai_actors prison_cell_d_covenant))
	)

(script dormant enc_prison_cell_d_reins
;	(ai_place prison_cell_d_covenant/hunters)
;	(ai_place prison_cell_d_covenant/grunts_left)
;	(ai_place prison_cell_d_covenant/grunts_right)
;	(ai_place prison_cell_d_covenant/jackals)
;	(ai_magically_see_encounter prison_cell_d_covenant prison_marines)
;	(sleep (* 30 10))
	(ai_place prison_cell_d_covenant/stealth_elites)
	(sleep 1)
	(objects_predict (ai_actors prison_cell_d_covenant))
	)

(script static void ini_post_rescue
	(switch_bsp 3)
	(object_teleport (player0) prison_player0_teleport)
	(object_teleport (player1) prison_player1_teleport)
	(object_create captain_keyes)
	(object_create free_marine_1)
	(object_create free_marine_2)
	(object_create free_marine_3)
	(sleep 1)
	(fade_in 1 1 1 15)
	(ai_attach captain_keyes prison_captain/mig_cap_u)
	(ai_attach free_marine_1 prison_marines/mig_marines_u)
	(ai_attach free_marine_2 prison_marines/mig_marines_u)
	(ai_attach free_marine_3 prison_marines/mig_marines_u)
	
	(ai_erase hangar_cov_third_floor)
	(sleep 1)
	(objects_predict captain_keyes)
	(objects_predict free_marine_1)
	(objects_predict free_marine_2)
	(objects_predict free_marine_3)
	
	(if (or (= (game_difficulty_get) normal)
		   (= (game_difficulty_get) hard)) (ai_grenades 0))
	)

;========== Initialization Scripts (Prison Area) ==========

(script dormant ini_prison_a_dialog
	(sleep_until (volume_test_objects mig_cellblock_a (players)))
	(ai_conversation empty_prison)
	)

(script static void ini_prison_cleanup
	(fade_out 1 1 1 30)
	(sleep 30)
	(switch_bsp 3)
	(volume_teleport_players_not_inside null prison_teleport_flag)
	(object_destroy keyes_prison)
	(object_destroy jailed_marine_1)
	(object_destroy jailed_marine_2)
	(object_destroy jailed_marine_3)
	)

(script dormant dialog_prison
	(sleep_until (and (or (objects_can_see_object (players) jailed_marine_1 10)
					  (objects_can_see_object (players) jailed_marine_2 10)
					  (objects_can_see_object (players) jailed_marine_3 10))
			   (> (ai_status prison_cell_d_covenant) 4)))
	(ai_conversation prison_initial)

	(sleep_until (< (ai_strength prison_cell_d_covenant) .3))
	(ai_conversation prison_kickin_ass)
	(sleep_until (= (ai_living_count prison_cell_d_covenant) 0))
	(ai_conversation prison_clear)
	)

;========== Encounter Scripts (Hangar Return) ==========

(script dormant enc_hangar_return
	(ai_place hangar_cov_third_floor/grunts_return)
	(ai_place hangar_cov_third_floor/elites_return)
	(sleep 1)
	(objects_predict (ai_actors hangar_cov_third_floor))
	)

;========== Mission Scripts ==========

(script dormant mission_area1
;	(game_save_totally_unsafe)
	(wake music_a50_01)
;	(wake chapter_start)
;	(wake ini_area1_dialog)
	(wake obj_board)
	(sleep 30)
	(sleep 150)
	(wake obj_sniper)
	(wake traitor_bitch)
	)
	
(script dormant mission_area2
	(objects_predict area2_turret_a)
	(objects_predict field_generator_a)

	(ai_allow_dormant marines_initial false)

	(if (= (game_difficulty_get) impossible) (wake ini_enter_turret_area2_leg) (wake ini_enter_turret_area2_norm))
	(wake enc_area2_ini)
	(wake mig_marines_area2)
	(sleep 1)
	(ini_scenery_predictions)
	
	(sleep_until (volume_test_objects area2_trigger (players)))
	(if (!= (game_difficulty_get) impossible) (wake ini_gun_runner))
	(sleep 30)
	(sleep_until (or (and (volume_test_objects area2_trigger_a (players))
					  (< (ai_living_count covenant_area2) 10))
				  (volume_test_objects area2_trigger_b (players))
				  (= (ai_living_count covenant_area2) 0)))
	(wake enc_area2_wave_2)
	(set area2_marine_migrate true)
	(ini_scenery_predictions)

	(sleep_until (or (volume_test_objects area2_trigger_c (players))
				  (= (ai_living_count covenant_area2) 0)))
	(wake enc_back_area2)
	(set area2_marine_migrate_2 true)
	(sleep_until (= (ai_living_count covenant_area2) 0))
	(set play_music_a50_01 0)
	)

(script dormant mission_area3
	(ai_migrate covenant_area2 covenant_area3/area2_cleanup)
	(ai_allow_dormant covenant_area3/area2_cleanup false)
	(ai_allow_dormant marines_area3 false)
	(ai_link_activation covenant_area3 marines_area3)
	(sleep 1)
	(if (< (ai_status covenant_area3) 3) (ai_conversation area3_initial))
	(set play_music_a50_01 0)

	(sleep -1 ini_enter_turret_area2_norm)
	(sleep -1 ini_enter_turret_area2_leg)
	(cond
		((= (game_difficulty_get) normal) (wake ini_enter_turret_area3_norm))
		((= (game_difficulty_get) hard) (wake ini_enter_turret_area3_norm))
		((= (game_difficulty_get) impossible) (wake ini_enter_turret_area3_leg) (wake ini_area3_turrets_leg)))
	(sleep 1)
	(wake general_save)
	(game_save_no_timeout)
	(wake mig_marines_area3)
	(wake enc_area3_initial)
	(sleep 30)
	
	(sleep_until (or (= (ai_living_count covenant_area3/jackals_hill_left) 0)
				  (= (ai_living_count covenant_area3/turret_gunner_a) 0)
				  (= (ai_living_count covenant_area3/grunts_ledge) 0)
				  (volume_test_objects area3_trigger_a (players))))
	(sleep -1 dialog_area3_initial)
	(wake enc_elites_front_area3)
	(wake music_a50_02)

	(sleep_until (volume_test_objects area3_trigger_a (players)))
	(wake enc_area3_second)
	
	(sleep_until (volume_test_objects area3_trigger_b (players)))
	(wake enc_elites_reins_area3)
	
	(sleep_until (or (= 0 (ai_living_count covenant_area3/elites_reins))
				  (volume_test_objects area4_trigger (players))))
	(wake enc_grunts_reins_area3)
	(ai_allow_dormant covenant_area3/grunts_reins false)
;	(set play_music_a50_02 false)
	)

(script dormant mission_area4
	(sleep -1 ini_enter_turret_area3_norm)
	(sleep -1 ini_enter_turret_area3_leg)
	
	(wake dialog_area4_initial)
	
	(ai_migrate covenant_area3 covenant_area4/area3_cleanup)
	(ai_migrate marines_area3 marines_area4/squad_a)
	
	(wake enc_area4_initial)
		
	(cond
		((= (game_difficulty_get) normal) (wake ini_enter_turret_area4_norm) (set area4_turret_limit 3))
		((= (game_difficulty_get) hard) (wake ini_enter_turret_area4_norm) (set area4_turret_limit 4))
		((= (game_difficulty_get) impossible) (wake ini_enter_turret_area4_leg) (set area4_turret_limit 5)))

	(wake general_save)
	(sleep 1)
	(ai_allow_dormant covenant_area4/area3_cleanup false)
	(ai_allow_dormant marines_area4 false)

	(wake ini_area4_turrets)
	(wake ini_area4_player_locator)
	(wake ini_area4_dropship)
	(wake ini_area4_grunts_m)

	(sleep_until (or (volume_test_objects area4_marines_ledge_trigger (players))
				  (volume_test_objects area4_marines_middle_trigger (players))))
	(wake music_a50_03)
	(cond 
		((volume_test_objects area4_location_1 (players)) (wake mig_marines_area4_ledge))
		((volume_test_objects area4_location_2 (players)) (wake mig_marines_area4_middle)))
	(wake enc_area4_second)
	(sleep 30)
	(wake ini_area4_marine_reins)
	(sleep_until (volume_test_objects area4_reins_trigger (players)))
	(wake dialog_area5_initial)

	(wake general_save)
	(sound_looping_set_alternate "levels\a50\music\a50_03" 1)

	(wake ini_area4_reins)
	(set area4_cov_dropship 0)
	(set area4_marine_reins 0)
	(sleep 1)
	(ai_migrate covenant_area4 covenant_area4/squad_y)
	(sleep 1)
	(ai_follow_target_players covenant_area4/squad_y)
	)

(script dormant mission_area5
	(set play_music_a50_03 false)
	(wake general_save)
	
	(ai_allow_dormant marines_area5 false)

	(sleep -1 ini_enter_turret_area4_norm)
	(sleep -1 ini_enter_turret_area4_leg)
	(sleep -1 ini_area4_player_locator)
	(sleep -1 mig_marines_area4_ledge)
	(sleep -1 mig_marines_area4_middle)

	(wake ini_area5_turrets)
	(wake enc_area5_ini)
	(wake mig_marines_area5)
	(wake dialog_area5_guns)

	(cond
		((= (game_difficulty_get) normal) (wake ini_enter_turret_area5_norm) (set area5_turret_limit 3))
		((= (game_difficulty_get) hard) (wake ini_enter_turret_area5_norm) (set area5_turret_limit 4))
		((= (game_difficulty_get) impossible) (wake ini_enter_turret_area5_leg) (set area5_turret_limit 5)))
	
	(sleep_until (volume_test_objects area5_dropship_trigger (players)))
	(wake ini_area5_cov_chaser)
	(wake ini_area5_pelican)
	(wake ini_area5_c_dropship)
	(wake ini_area5_cleanup_kill)
	(wake ini_area5_spawner)
	(wake ini_area5_random_spawner)

	(sleep_until (and (not area5_e_spawn) (not area5_g_spawn) (not area5_o_spawn) (not area5_q_spawn)))
	(if (= (game_difficulty_get) impossible) (begin (wake general_save) (gravity_spawn_legendary)))
	(set area5_pelican 0)
;	(sleep -1 ini_area5_pelican)
	(ai_migrate covenant_area5 covenant_area5/squad_y)
	(ai_follow_target_players covenant_area5/squad_y)
	(sleep 1)


	(sleep_until (or (= (ai_living_count covenant_area5) 0)
				  (< (ai_status covenant_area5) 2)))
	(wake general_save)
	(sleep 210)
	(sleep_until (objects_can_see_flag (players) hunter_intro 30))
;	(wake ini_area5_cov_retreat)

	(sleep 1)
	
	(wake enc_area5_hunters)
	(wake music_a50_04)
	
	(sleep_until (= (ai_living_count covenant_area5/hunters) 0))
	(set play_music_a50_04 false)
	(sleep 150)
	(if (< (ai_living_count marines_area5) 5) (pelican_area5_b) (ini_marines_to_pad))
	(ai_follow_target_disable marines_area5)
	
	(sleep_until (volume_test_objects gravity_pad_teleport_trigger (players)))
	(ai_dialogue_triggers 0)

	(sleep 90)
	(ai_kill_silent covenant_area5)
	(players_unzoom_all)

   (if (mcc_mission_segment "cine2_into_the_belly") (sleep 1))              
   
	(if (cinematic_skip_start) (cutscene_energy_lift))
	(cinematic_skip_stop)

	(switch_bsp 1)
	(object_teleport (player0) gravity_teleport0_flag)
	(object_teleport (player1) gravity_teleport1_flag)
	(ai_detach (player0))
	)

(script dormant mission_gravity_room
	(ai_dialogue_triggers 1)
	(sound_class_set_gain "vehicle_engine" 0 0)
	(set play_music_a50_04 false)
	
	(sleep -1 ini_enter_turret_area5_norm)
	(sleep -1 ini_enter_turret_area5_leg)
	(sleep -1 ini_area5_spawner)
	(sleep -1 ini_area5_random_spawner)
	(sleep -1 ini_area5_cov_chaser)
	(sleep -1 ini_area5_cleanup_kill)
	
	(ai_erase_all)
	(sleep 1)	
	
	(fade_in .8 0 1 15)
	
	(cinematic_screen_effect_set_convolution 3 2 10 .001 1)
	(cinematic_screen_effect_set_filter_desaturation_tint .8 0 1)
	(cinematic_screen_effect_set_filter 1 0 1 0 true 1)
	(sleep 30)
	
	(cinematic_stop)
	(cinematic_screen_effect_stop)
	
	(wake enc_grav_marines)
	(sleep 15)
	(wake obj_rescue)
;	(sleep 1)
	(ai_conversation gravity_pad_initial)

	(sleep_until (> (ai_conversation_status gravity_pad_initial) 4))
	(game_save_totally_unsafe)
	
	(sleep 30)
	(wake enc_grav_stealth_ini)
	(wake ini_gravity_wave)
	(wake gravity_marines_revive)
	
;activates the first gravity wave
	(cond
		((= (game_difficulty_get) normal) (set ini_grav_wave_index 6) (set gravity_wave true))
		((= (game_difficulty_get) hard) (set ini_grav_wave_index 8) (set gravity_wave true))
		((= (game_difficulty_get) impossible) (set ini_grav_wave_index 10) (set gravity_wave true)))
	
	(sleep_until (= (ai_status gravity_pad_marines) 6))
	(sleep 30)
	(wake music_a50_05)
	(ai_conversation gravity_contact)

	(sleep_until (and (< (ai_living_count gravity_pad_covenant) 3)
				   (= gravity_wave 0)))
	(sleep_until (= (ai_living_count gravity_pad_covenant) 0) 30 (* 30 15))
	(sleep_until (= (volume_test_objects gravity_trigger (ai_actors gravity_pad_covenant)) 0))
	(wake general_save)
	(ai_migrate gravity_pad_marines gravity_pad_marines/all)
	(sleep (* 30 5))
	(wake enc_grav_hunters)
	(device_set_power gravity_bay_door 1)
	(device_set_position gravity_bay_door 1)
	
	(sleep_until (and (= (ai_living_count gravity_pad_covenant/grav_front_hunters) 0)
				   (= (ai_living_count gravity_pad_covenant/grav_front_jackals) 0)))
	(set play_music_a50_05 false)
	(wake general_save)
	(wake man_marines_to_door)
	(sleep (* 30 5))
	(device_one_sided_set gravity_door_lf false)
	(device_one_sided_set gravity_door_lr false)
	(ai_place gravity_pad_covenant/grunts_all)
	(device_set_power grav_mus_hall_door 1)
;	(wake ini_second_gravity_wave)
;	(sleep (* 30 45))
;	(wake ini_gravity_kill)
	(sleep -1 ini_gravity_wave)
	)
	
(script dormant mission_grav_mus_hall
	(wake enc_grav_mus_hall)
	(wake enc_grav_mus_hall_rear)

	(sleep_until (volume_test_objects muster_bay_top_entrance (players)))
	(wake mig_grav_hall_cleanup)
	)


(script dormant mission_muster_bay
	(wake general_save)
	(sleep -1 enc_grav_mus_hall_rear)
	(wake enc_muster_ini)
	(wake ini_muster_hall)
	(wake ini_muster_wave_spawn)
	(wake ini_muster_bay_door_check)
	(wake ini_muster_hangar_hall)
	(wake ini_muster_ledge)
	(sleep 1)
	(objects_predict (ai_actors muster_hall_cov))
	
	(wake mig_grav_to_mus_marines)
	
	(sleep_until (volume_test_objects muster_view_door (players)))
	(wake music_a50_06)
	(if (> (ai_living_count gravity_pad_marines) 0)
		  (begin (ai_conversation muster_door)
		  	    (activate_team_nav_point_object "default_red" player muster_bay_control .7)))

;	(sleep_until (< (ai_living_count muster_bay_covenant_bottom) 3))

	(sleep_until (and (< (ai_living_count muster_bay_covenant_bottom) 3)
				   (volume_test_objects muster_floor_trigger (players))))
	(wake general_save)
	(sleep 120)
	(cond
		((= (game_difficulty_get) normal) (wake ini_muster_wave_normal))
		((= (game_difficulty_get) hard) (wake ini_muster_wave_hard))
		((= (game_difficulty_get) impossible) (wake ini_muster_wave_legendary)))

	(sleep 300)

	(sleep_until (and (= muster_wave 0)
				   (or (= (ai_status muster_bay_covenant_bottom) 0)
					  (< (ai_living_count muster_bay_covenant_bottom) 2))))
	(if muster_door_nav (activate_team_nav_point_object "default_red" player muster_door_l2 .3))
	(set play_music_a50_06 false)
	(device_one_sided_set muster_door_l1 false)
	(device_one_sided_set muster_door_l2 false)
	(device_one_sided_set muster_door_l3 false)
	
	(ai_automatic_migration_target muster_bay_marines/squad_f true)
	(ai_automatic_migration_target muster_bay_marines/squad_g true)
	(ai_automatic_migration_target muster_bay_marines/squad_h true)
	(wake general_save)
	(sleep 90)
	(wake dialog_muster_clear)
	(sleep_until (or (volume_test_objects mus_l1_safe (players))
				  (volume_test_objects mus_l2_safe (players))
				  (volume_test_objects mus_l3_safe (players))
				  (volume_test_objects muster_hangar_hall_trigger (players))
			    ))
	(sleep -1 dialog_muster_clear)
	(deactivate_team_nav_point_object player muster_door_l2)
	
	)

(script dormant mission_hangar
	(sleep -1 ini_muster_wave_spawn)
	(set muster_door_nav 0)
	(deactivate_team_nav_point_object player muster_door_l2)
	(deactivate_team_nav_point_object player muster_bay_control)
	(device_set_position_immediate hangar_back_door 0)
	(device_set_position_immediate hangar_door_b 1)
	(device_set_power hangar_door_b 0)
	(ai_migrate muster_bay_marines hangar_marines/marines_ini)
	(sleep 1)
	(ai_teleport_to_starting_location_if_unsupported hangar_marines/marines_ini)

	(wake general_save)
	(ai_erase gravity_pad_marines)
	(ai_erase gravity_pad_covenant)
	(ai_erase muster_bay_covenant_top)
	(ai_erase muster_bay_covenant_bottom)
	(ai_erase muster_hall_cov)
	
	(wake ini_hover_hangar_dropships)
;	(wake ini_shuttle_switch_runner)
	(wake ini_hangar_initial)
	(sleep_until (> (device_get_position hangar_first_floor_entr) 0))
	(wake ini_hangar_pelican_a)

	(sleep_until (volume_test_objects hangar_entrance (players)) 15)
	(wake auto_migration_deactivate)

;	(sleep 150)
	(sleep_until (or (= (ai_status hangar_cov_first_floor) 6)
				  (= (volume_test_objects hangar_entrance (players)) 0)))
	(ai_migrate hangar_marines hangar_marines/mig_marines_a)
	(wake ini_hangar_first_wave_a)
	(set hangar_location_index 1)
	(ai_renew hangar_marines)
;	(wake music_a50_07)

;	(sleep 150)
	(sleep_until (or (volume_test_objects han_mig_a (players))
				  (volume_test_objects han_mig_b (players))
				  (volume_test_objects han_mig_c (players))))
	(sleep_until (< (ai_living_count hangar_cov_first_floor) 2))
	(ai_migrate hangar_marines hangar_marines/mig_marines_b)
	(wake ini_hangar_first_wave_b)
	(sound_looping_set_alternate "levels\a50\music\a50_07" 1)
	(set hangar_location_index 2)

;	(sleep 150)
	(sleep_until (or (volume_test_objects han_mig_d (players))
				  (volume_test_objects han_mig_g (players))))
	(sleep_until (< (ai_living_count hangar_cov_first_floor) 2))
	(wake general_save)
	(ai_migrate hangar_marines hangar_marines/mig_marines_d)
	(wake ini_hangar_first_wave_d)
	(set play_music_a50_07 0)
	(set hangar_location_index 3)
	(ai_renew hangar_marines)

;	(sleep 150)
	(sleep_until (or (volume_test_objects han_mig_e (players))
				  (volume_test_objects han_mig_o (players))
				  (volume_test_objects han_mig_e_2 (players))))
	(sleep_until (< (ai_living_count hangar_cov_first_floor) 2))
	(ai_migrate hangar_marines hangar_marines/mig_marines_e)
	(wake ini_hangar_first_wave_e)
	(set hangar_location_index 4)
	(ai_renew hangar_marines)

;	(sleep 150)
	(sleep_until (volume_test_objects han_mig_f (players)))
	(sleep_until (< (ai_living_count hangar_cov_first_floor) 2))
	(ai_migrate hangar_marines hangar_marines/mig_marines_f)
	(wake ini_hangar_first_wave_f)
	(set hangar_location_index 5)
	(ai_renew hangar_marines)
	(ai_conversation shuttle_hall_door_locked)
	
	(sleep_until (< (ai_living_count hangar_cov_first_floor) 2))
	(wake ini_hangar_hall_open)

	(sleep_until (volume_test_objects hangar_first_trigger_a (players)))
	(wake general_save)
	
	(sleep_until (volume_test_objects hangar_second_trigger_a (players)))
	(wake general_save)
	(wake ini_hangar_pelican_b)
	(wake ini_hangar_second_wave_h)

	(sleep_until (volume_test_objects hangar_exit_trigger (players)))
	(wake ini_hangar_second_wave_i)
	
	(sleep_until (volume_test_objects hangar_second_trigger_b (players)))
	(wake ini_hangar_second_wave_j)
	(wake enc_hangar_righthall)
	
	(sleep_until (volume_test_objects hangar_second_trigger_c (players)))
	(wake general_save)
	
	(sleep_until (volume_test_objects hangar_third_trigger_a (players)))
	(wake general_save)
	(wake ini_hangar_third_wave_k)
	
	(sleep_until (volume_test_objects hangar_third_trigger_c (players)))
	(wake ini_hangar_third_wave_l)
	
	(sleep_until (volume_test_objects hangar_third_trigger_d (players)))
	(wake ini_hangar_third_wave_m)

	(set player_location_index 2)
	(wake ini_prison_mig_manage)
	)

(script dormant mission_control
	(wake general_save)
	(wake enc_control_in_room)
	
	(sleep -1 ini_hangar_pelican_b)
	(deactivate_team_nav_point_object player hangar_door_b_control)

	
;	(sleep_until (volume_test_objects control_music_trigger (players)))
	(wake music_a50_08)

	(sleep_until (and (= (ai_living_count control_covenant/elites_left) 0)
				   (= (ai_living_count control_covenant/elites_right) 0)))
	(wake enc_control_reins_a)
	(sleep 1)
	
	(sleep_until (= (ai_living_count control_covenant) 0))
	(wake enc_control_reins_b)
	(device_set_power control_door_d 1)
	(if (not (volume_test_objects prison_trigger (players)))
		    (activate_team_nav_point_object "default_red" player control_door_d .3))
	(sleep_until (= (ai_living_count control_covenant) 0))
	(wake dialog_control_clear)
	(ai_migrate prison_marines control_marines/on_pad)
	(wake general_save)
;	(device_set_position control_door_d 1)
;	(sleep_until (= (device_get_position control_door_d) 1) 1)
;	(device_set_power control_door_d 0)
	(sleep_until (volume_test_objects prison_trigger (players)))
	(deactivate_team_nav_point_object player control_door_d)
	)

(script dormant mission_prison
	(sleep -1 dialog_control_clear)
	(set play_music_a50_08 false)
;	(if debug (print "prison area scripts activated"))
	(wake ini_prison_a_dialog)
	(wake enc_prison_cov_ini)
	(wake enc_spawn_captain)
	(sleep 1)
;	(set ini_captain_location 4)
	(set player_location_index 1)
	(sleep 1)
	(wake enc_spawn_marines)
	(wake mig_marines_prison_a)
	(wake mig_marines_prison_d)
	(wake enc_prison_cell_d_cov)
	(sleep_until (volume_test_objects prison_save_trigger (players)))
	(wake general_save)

	(sleep_until (> (device_get_position cellblock_d_maindoor) 0))
	(wake music_a50_09)
	(wake dialog_prison)
	
	(sleep_until (= (ai_living_count prison_cell_d_covenant) 0))
	(sleep_until (= (device_group_get prison_d_switch_position) 1))
	(set play_music_a50_09 false)
	(sleep (* 30 5))
	
	(ini_prison_cleanup)

   (if (mcc_mission_segment "cine3_keyes_in_brig") (sleep 1))              
   
	(if (cinematic_skip_start) (cutscene_rescue))
	(cinematic_skip_stop)

	(ini_post_rescue)
	(sleep -1 ini_prison_a_dialog)

	
;	(wake chapter_captain)
	(wake obj_escape)
	
	
	(ai_conversation prison_move_out)
	(wake general_save)
	(set captain_rescued true)
	(sleep 90)
	(wake enc_prison_cell_d_reins)
	(wake enc_prison_return_ini)
	(object_destroy extraction_machine)
	(object_create extraction_control)
	(device_set_power control_door_d 1)

	(wake game_lost_script)
	)

(script dormant mission_control_revisited
	(wake general_save)
	(ai_kill_silent control_marines)
;	(device_one_sided_set control_door_d 0)
	(sleep 1)
	(wake enc_control_return)
	(sleep_until (= (ai_living_count control_covenant) 0))
	(wake game_win_script)
	(sleep_until (> (ai_conversation_status shuttle_revisited) 4))
	(wake music_a50_11)
	(sleep 60)
	(wake enc_control_return_reins)
	(device_one_sided_set control_door_a false)
	(device_one_sided_set control_door_b false)
	(device_one_sided_set control_door_c false)
	(device_one_sided_set control_door_d false)
	
	(ai_automatic_migration_target prison_captain/mig_cap_l 1)
	(ai_automatic_migration_target prison_captain/mig_cap_m 1)
	(ai_automatic_migration_target prison_captain/mig_cap_n 1)
	(ai_automatic_migration_target prison_captain/mig_cap_o 1)
	
	(ai_automatic_migration_target prison_marines/mig_marines_l 1)
	(ai_automatic_migration_target prison_marines/mig_marines_m 1)
	(ai_automatic_migration_target prison_marines/mig_marines_n 1)
	(ai_automatic_migration_target prison_marines/mig_marines_o 1)

	(sleep_until (= (ai_living_count control_covenant) 0))
	(wake general_save)
	)
	
(script dormant mission_hangar_revisited
	(wake enc_hangar_return)
	
	(sleep_until (= (device_get_position hangar_door_c) 1) 1)
	(sound_looping_set_alternate "levels\a50\music\a50_11" 1)
	)

;========== kill all continuous scripts ==========

(script static void kill_all_continuous
	(sleep -1 ini_gravity_wave)
	(sleep -1 ini_muster_wave_spawn)
	(sleep -1 enc_grav_mus_hall_rear)
	(sleep -1 ini_prison_mig_manage)
	(sleep -1 ini_enter_turret_area2_norm)
	(sleep -1 ini_enter_turret_area2_leg)
	(sleep -1 ini_enter_turret_area3_norm)
	(sleep -1 ini_enter_turret_area3_leg)
	(sleep -1 ini_enter_turret_area4_norm)
	(sleep -1 ini_enter_turret_area4_leg)
	(sleep -1 ini_enter_turret_area5_norm)
	(sleep -1 ini_enter_turret_area5_leg)
	(sleep -1 ini_area4_player_locator)
	(sleep -1 ini_area5_spawner)
	(sleep -1 ini_area5_cov_chaser)
	(sleep -1 ini_area5_random_spawner)
	(sleep -1 general_save)
	(sleep -1 ini_area5_cleanup_kill)
	)
	
;========== Main Script ==========

(script startup mission_a50
	(fade_out 0 0 0 0)
;	(fade_in 0 0 0 (* 30 5))
;	(switch_bsp 3)
;	(if debug (print "ph34r the TUNA!"))
	(ai_allegiance player human)
	(cls)
;	(if debug (print "rise tuna rise!"))
	
;kill all continuous scripts
	(kill_all_continuous)
   (if (mcc_mission_segment "cine1_intro") (sleep 1))              

	(cutscene_insertion)
	
   (mcc_mission_segment "01_start")
   
	(set mission_begin 1)
	
	(wake mission_area1)
	(wake mission_area2)

	(sleep_until (volume_test_objects area3_trigger (players)))
	(wake mission_area3)
   (mcc_mission_segment "02_area3")

	(sleep_until (volume_test_objects area4_trigger (players)))
	(wake mission_area4)
   (mcc_mission_segment "03_area4")

	(sleep_until (volume_test_objects area5_trigger (players)))
	(wake mission_area5)
   (mcc_mission_segment "04_area5")

	(sleep_until (volume_test_objects gravity_trigger (players)))
	(wake mission_gravity_room)
   (mcc_mission_segment "05_ship")

	(sleep_until (volume_test_objects grav_leftfront_safe (players)))
	(wake mission_grav_mus_hall)
   (mcc_mission_segment "06_mus_hall")

	(sleep_until (volume_test_objects muster_bay_top_entrance (players)))
	(wake mission_muster_bay)
   (mcc_mission_segment "07_muster_bay")
			    		 
	(sleep_until (volume_test_objects hangar_trigger (players)))
	(wake mission_hangar)
   (mcc_mission_segment "08_hangar")
	
	(sleep_until (volume_test_objects control_migration (players)))
	(wake mission_control)
   (mcc_mission_segment "09_control")
		
	(sleep_until (volume_test_objects prison_trigger (players)))
	(wake mission_prison)
   (mcc_mission_segment "10_prison")

	(sleep_until captain_rescued)
	(sleep_until (volume_test_objects prison_trigger (players)))
	(wake mission_control_revisited)
   (mcc_mission_segment "11_control_revisited")

	(sleep_until (volume_test_objects hangar_migration (players)))
	(wake mission_hangar_revisited)
   (mcc_mission_segment "12_hangar_revisited")
	)

;========== Notes ==========

