
;========== Insertion Scripts ==========

(script dormant insertion_turrets
	(ai_vehicle_enterable_distance insertion_turret_a 10)
	(ai_vehicle_enterable_distance insertion_turret_b 10)
	(ai_vehicle_enterable_actor_type insertion_turret_a grunt)
	(ai_vehicle_enterable_actor_type insertion_turret_b grunt)
	)

;========== Encounter Scripts (A1 Interior) ==========

(script static void enc_a1_initial
	(ai_place a1_cov/elites_door)
	(ai_place a1_cov/elites_middle)
	(ai_place a1_cov/grunts_middle)
	(sleep 1)
	(objects_predict (ai_actors a1_cov))
	)

(script static void enc_a1
	(ai_place a1_cov/grunts_ledge)
	(ai_place a1_cov/elites_left)
	(ai_place a1_cov/elites_right)

	(begin_random
		(if a1_spawn
			(begin (ai_place a1_cov/grunts_left)
				  (set a1_spawn_counter (+ 1 a1_spawn_counter))
				  (if (= a1_spawn_counter a1_squad_index) (set a1_spawn false))))
		(if a1_spawn
			(begin (ai_place a1_cov/jackals_left)
				  (set a1_spawn_counter (+ 1 a1_spawn_counter))
				  (if (= a1_spawn_counter a1_squad_index) (set a1_spawn false)))))
	(set a1_spawn_counter 0)
	(set a1_spawn true)
	(sleep 3)
	(begin_random
		(if a1_spawn
			(begin (ai_place a1_cov/grunts_right)
				  (set a1_spawn_counter (+ 1 a1_spawn_counter))
				  (if (= a1_spawn_counter a1_squad_index) (set a1_spawn false))))
		(if a1_spawn
			(begin (ai_place a1_cov/jackals_right)
				  (set a1_spawn_counter (+ 1 a1_spawn_counter))
				  (if (= a1_spawn_counter a1_squad_index) (set a1_spawn false)))))
	(set a1_spawn_counter 0)
	(set a1_spawn true)
	(sleep 1)
	(objects_predict (ai_actors a1_cov))
	)
	
(script static void enc_a1_rear
	(ai_place a1_cov/grunts_rear)
	(sleep 1)
	(objects_predict (ai_actors a1_cov))
	)

;========== Encounter Scripts (A Bridge) ==========

(script dormant enc_a_bridge
	(ai_place a_bridge/grunts_a)
	(ai_place a_bridge/jackals_a)
	(ai_place a_bridge/elites_a)
	(sleep 1)
	(objects_predict (ai_actors a_bridge))
	)

(script dormant enc_a_bridge_second
	(ai_place a_bridge/grunts_low)
	(ai_place a_bridge/jackals_m)
	(ai_place a_bridge/turret_grunts)
	(sleep 1)
	(objects_predict (ai_actors a_bridge))
	)

(script dormant enc_a_bridge_reins_sword
	(ai_place a_bridge/elites_reins)
	)

(script dormant enc_a_bridge_reins	
	(begin_random
		(if a_bridge_rein
			(begin (ai_place a_bridge/grunts_reins)
				  (set a_bridge_rein_counter (+ 1 a_bridge_rein_counter))
				  (if (= a_bridge_rein_counter a_bridge_rein_index) (set a_bridge_rein false))))
		(if a_bridge_rein
			(begin (ai_place a_bridge/jackals_reins)
				  (set a_bridge_rein_counter (+ 1 a_bridge_rein_counter))
				  (if (= a_bridge_rein_counter a_bridge_rein_index) (set a_bridge_rein false)))))
	(set a_bridge_rein_counter 0)
	(set a_bridge_rein true)
	(sleep 1)
	(objects_predict (ai_actors a_bridge))
	)

;========== Initialization Scripts (A Bridge) ==========

(script dormant ini_cinematic_ext_a_pelican
	(cinematic_ext_a_pelican))

(script dormant ini_ext_a_objects
	(object_create ext_a_bridge_turret_a)
	(object_create ext_a_bridge_turret_b)
	(object_create ext_a_bridge_turret_c)
	(object_create ext_a_bridge_turret_d)
	(sleep 1)
	(objects_predict ext_a_bridge_turret_a)
	)

(script dormant ini_a_bridge_initial
	(wake enc_a_bridge)
	(sleep_until (and (= (ai_living_count a_bridge/grunts_a) 0)
				   (= (ai_living_count a_bridge/jackals_a) 0)))
	(ai_defend a_bridge/first_elites)
	)

(script dormant ini_ext_a_banshee
	(object_create ext_a_banshee_a)
	(objects_predict ext_a_banshee_a)
	(ai_place ext_a_area_a_cov/banshee_a_pilot)
	(vehicle_load_magic ext_a_banshee_a driver (ai_actors ext_a_area_a_cov/banshee_a_pilot))
	(ai_vehicle_encounter ext_a_banshee_a ext_a_banshee/squad_a)
	(sleep 1)
	(objects_predict ext_a_banshee_a)
	(objects_predict (ai_actors a_bridge))
	(ai_follow_target_players ext_a_banshee/squad_a)
	(ai_magically_see_players ext_a_banshee)
	)

(script dormant ini_a_bridge_reins
	(sleep_until (or (and (= (ai_living_count a_bridge/grunts_a) 0)
					  (= (ai_living_count a_bridge/jackals_a) 0)
					  (= (ai_living_count a_bridge/elites_a) 0)
					  (= (ai_living_count a_bridge/grunts_low) 0)
					  (= (ai_living_count a_bridge/jackals_m) 0)
					  (= (ai_living_count a_bridge/grunts_a) 0))
				  (volume_test_objects a_bridge_reins_trigger (players))))
	(if (or (= (game_difficulty_get) hard)
		   (= (game_difficulty_get) impossible)) (wake enc_a_bridge_reins))
	(wake enc_a_bridge_reins_sword)
;	(sound_looping_set_alternate "levels\b40\music\b40_01" 1)
	)

(script continuous ini_a_bridge_turret_near
	(begin_random
		(begin (ai_go_to_vehicle a_bridge/grunts_a ext_a_bridge_turret_c gunner) (sleep default_turret_delay))
		(begin (ai_go_to_vehicle a_bridge/grunts_a ext_a_bridge_turret_d gunner) (sleep default_turret_delay))
		(sleep default_turret_delay))
	)
	
(script continuous ini_a_bridge_turret_far
	(begin_random
		(begin (ai_go_to_vehicle a_bridge/turret_grunts ext_a_bridge_turret_a gunner) (sleep default_turret_delay))
		(begin (ai_go_to_vehicle a_bridge/turret_grunts ext_a_bridge_turret_b gunner) (sleep default_turret_delay))
		(sleep default_turret_delay))
	)

;========== Encounter Scripts (A2) ==========

(script dormant enc_a2_top_cov
	(ai_place a2_top_cov/elites_a)
	(ai_place a2_top_cov/grunt_sniper)
	(ai_place a2_top_cov/grunts_a)
	(ai_place a2_top_cov/grunts_ledge)
	(if (or (= (game_difficulty_get) hard)
		   (= (game_difficulty_get) impossible)) (ai_place a2_top_cov/hunters))
	(ai_follow_target_ai a2_top_cov/grunts_a a2_top_cov/elites_a)
	(sleep 1)
	(objects_predict (ai_actors a2_top_cov))
	)

(script dormant enc_a2_bottom
;	(ai_place a2_bottom_cov/engineers)
	(ai_place a2_bottom_cov/jackals_inner)
	(ai_place a2_bottom_cov/grunts_a)
	(ai_place a2_bottom_cov/elites_a)
	(ai_place a2_bottom_cov/jackals_a)
	(ai_place a2_bottom_cov/grunts_lift)
	(sleep 1)
	(objects_predict (ai_actors a2_bottom_cov))
	)

(script dormant enc_a2_tube
	(ai_place a2_bottom_cov/grunts_tub)
	(sleep 1)
	(objects_predict (ai_actors a2_bottom_cov))
	)

;========== Initialization Scripts (A2) ==========

(script dormant ini_a2_top_reins
	(sleep_until (or (volume_test_objects a2_top_reins_trigger (players))
				  (= (ai_living_count a2_top_cov/elites_a) 0)))
	(ai_attack a2_top_cov/hunters)
	)
;========== Encounter Scripts (Exterior A) ==========

(script dormant enc_ext_a_cov
	(ai_place ext_a_area_a_cov/grunts_a)
;	(ai_place ext_a_area_a_cov/elites_a)
;	(ai_place ext_a_area_a_cov/elites_e)
	(ai_place ext_a_area_a_cov/elites_k)
	(ai_place ext_a_area_a_cov/jackals_k1)
	
	(begin_random
		(if ext_a_spawn
			(begin (ai_place ext_a_area_a_cov/jackals_e)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_a_cov/grunts_e)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false)))))
	(set ext_a_spawn_counter 0)
	(set ext_a_spawn true)
	(sleep 1)
	(objects_predict (ai_actors ext_a_area_a_cov))
	)

(script dormant enc_ext_a_marines
	(ai_place ext_a_area_a_marines/marines_ini)
;	(ai_place ext_a_area_a_marines/sarge)
	(sleep 1)
	(ai_migrate ext_a_area_a_marines ext_a_area_a_marines/marines_ini)
	(objects_predict (ai_actors ext_a_area_a_marines))
	)

(script dormant enc_ext_a_a_cov_second
	(if (< (ai_living_count ext_a_area_a_cov) 10)
		(ai_place ext_a_area_a_cov/jackals_o)
		(ai_place ext_a_area_a_cov/elites_o))
	(sleep 1)
	(if (< (ai_living_count ext_a_area_a_cov) 10)
		(ai_place ext_a_area_a_cov/jackals_q))
	)

(script dormant enc_ext_a_area_b
	(ai_place ext_a_area_b_cov/ghost_a_pilot)
	(ai_place ext_a_area_b_cov/ghost_b_pilot)
	(ai_place ext_a_area_b_cov/elites_u)
	(ai_place ext_a_area_b_cov/elites_e)
	(ai_place ext_a_area_b_cov/grunts_e)
	(ai_place ext_a_area_b_cov/jackals_e)

	(begin_random
		(if ext_a_spawn
			(begin (ai_place ext_a_area_b_cov/grunts_u)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_b_cov/jackals_u)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false)))))
	(set ext_a_spawn_counter 0)
	(set ext_a_spawn true)
	(sleep 1)
	(objects_predict (ai_actors ext_a_area_b_cov))
	)

(script dormant enc_ext_a_area_b_2
	(ai_place ext_a_area_b_cov/elites_q)
	(ai_place ext_a_area_b_cov/elites_k)

	(begin_random
		(if ext_a_spawn
			(begin (ai_place ext_a_area_b_cov/grunts_q)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_b_cov/jackals_q)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false)))))
	(set ext_a_spawn_counter 0)
	(set ext_a_spawn true)
	(sleep 2)
	(begin_random
		(if ext_a_spawn
			(begin (ai_place ext_a_area_b_cov/grunts_k)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_b_cov/jackals_k)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false)))))
	(set ext_a_spawn_counter 0)
	(set ext_a_spawn true)
	(sleep 1)
	(objects_predict (ai_actors ext_a_area_b_cov))
	)

(script dormant enc_ext_a_area_b_mar
	(ai_place ext_a_area_b_marines/marines_ini)
	(ai_place ext_a_area_b_marines/sarge)
	(sleep 1)
	(objects_predict (ai_actors ext_a_area_b_marines))
	
	(sleep 300)
	(ai_migrate ext_a_area_b_marines ext_a_area_b_marines/squad_a)
	(ai_follow_target_players ext_a_area_b_marines/squad_a)
	)
	
(script dormant enc_ext_a_area_c_cov
	(begin_random
		(if ext_a_spawn
			(begin (ai_place ext_a_area_c_cov/grunts_w)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_c_cov/elites_u)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_c_cov/elites_w)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_c_cov/grunts_y)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_c_cov/jackals_y)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_c_cov/grunts_u)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false))))
		(if ext_a_spawn
			(begin (ai_place ext_a_area_c_cov/jackals_u)
				  (set ext_a_spawn_counter (+ 1 ext_a_spawn_counter))
				  (if (= ext_a_spawn_counter ext_a_squad_index) (set ext_a_spawn false)))))
	(set ext_a_spawn_counter 0)
	(set ext_a_spawn true)

	(ai_place ext_a_area_c_cov/hunters)
	(ai_place ext_a_area_c_cov/jackals_q)
	(sleep 1)
	(objects_predict (ai_actors ext_a_area_c_cov))
	)

(script dormant crev_ent_turret_a
	(object_create crev_ent_turret_a)
	(ai_place ext_a_area_c_cov/turret_a_gunners)
	(ai_go_to_vehicle ext_a_area_c_cov/turret_a_gunners crev_ent_turret_a gunner)
	(sleep 1)
	(objects_predict crev_ent_turret_a)
	(objects_predict (ai_actors ext_a_area_c_cov))
	)

(script dormant crev_ent_turret_b
	(object_create crev_ent_turret_b)
	(ai_place ext_a_area_c_cov/turret_b_gunners)
	(ai_go_to_vehicle ext_a_area_c_cov/turret_b_gunners crev_ent_turret_b gunner)
	(sleep 1)
	(objects_predict crev_ent_turret_b)
	(objects_predict (ai_actors ext_a_area_c_cov))
	)

(script dormant crev_ent_turret_c
	(object_create crev_ent_turret_c)
	(ai_place ext_a_area_c_cov/turret_c_gunners)
	(ai_go_to_vehicle ext_a_area_c_cov/turret_c_gunners crev_ent_turret_c gunner)
	(sleep 1)
	(objects_predict crev_ent_turret_c)
	(objects_predict (ai_actors ext_a_area_c_cov))
	)

(script dormant crev_ent_turret_d
	(object_create crev_ent_turret_d)
	(ai_place ext_a_area_c_cov/turret_d_gunners)
	(ai_go_to_vehicle ext_a_area_c_cov/turret_d_gunners crev_ent_turret_d gunner)
	(sleep 1)
	(objects_predict crev_ent_turret_d)
	(objects_predict (ai_actors ext_a_area_c_cov))
	)

(script dormant crev_ent_turret_e
	(object_create crev_ent_turret_e)
	(ai_place ext_a_area_c_cov/turret_e_gunners)
	(ai_go_to_vehicle ext_a_area_c_cov/turret_e_gunners crev_ent_turret_e gunner)
	(sleep 1)
	(objects_predict crev_ent_turret_e)
	(objects_predict (ai_actors ext_a_area_c_cov))
	)

	
;========== Initialization Scripts (Exterior A) ==========

(script dormant ini_ext_a_dropships_a
	(cinematic_ext_a_dropship_a)
	(cinematic_ext_a_dropship_b)
	)

(script dormant ini_ext_a_c_dropship_a
	(cinematic_crev_ent_a)
	)

(script dormant ini_ext_a_c_dropship_b
	(cinematic_crev_ent_b)
	)

(script dormant ini_ext_a_c_dropship_c
	(cinematic_crev_ent_c)
	)

(script dormant ini_ext_a_marines
	(wake enc_ext_a_marines)

	(sleep_until (volume_test_objects ext_a_area_a_marines (players)))
	(ai_migrate ext_a_area_a_marines ext_a_area_a_marines/squad_c)
	(ai_follow_target_players ext_a_area_a_marines/squad_c)
	(ai_playfight ext_a_area_a_marines false)
	(ai_playfight ext_a_area_a_cov/jackals_e false)
	(ai_playfight ext_a_area_a_cov/grunts_e false)
	(ai_conversation ext_a_marines)
	)

(global boolean ext_a_mig_cov 1)
(global short ext_a_mig_cov_limit 0)

(script continuous ext_a_migration
	(if ext_a_mig_cov
		(begin (set ext_a_mig_cov_limit (- ext_a_mig_cov_limit 1))
			  (sleep 1)
			  (ai_command_list_by_unit 
				(unit (list_get (ai_actors ext_a_area_b_cov/squad_a) ext_a_mig_cov_limit))
					ext_a_area_a_ledge_a)
			  (if (= ext_a_mig_cov_limit 0) (set ext_a_mig_cov 0))))
	(inspect ext_a_mig_cov_limit)
	(sleep 1)
	(if ext_a_mig_cov
		(begin (set ext_a_mig_cov_limit (- ext_a_mig_cov_limit 1))
			  (sleep 1)
			  (ai_command_list_by_unit 
				(unit (list_get (ai_actors ext_a_area_b_cov/squad_a) ext_a_mig_cov_limit))
					ext_a_area_a_ledge_b)
			  (if (= ext_a_mig_cov_limit 0) (set ext_a_mig_cov 0))))
	(inspect ext_a_mig_cov_limit)
	(sleep 1)
	(if ext_a_mig_cov
		(begin (set ext_a_mig_cov_limit (- ext_a_mig_cov_limit 1))
			  (sleep 1)
			  (ai_command_list_by_unit 
				(unit (list_get (ai_actors ext_a_area_b_cov/squad_a) ext_a_mig_cov_limit))
					ext_a_area_a_ledge_c)
			  (if (= ext_a_mig_cov_limit 0) (set ext_a_mig_cov 0))))
	(inspect ext_a_mig_cov_limit)
	(sleep 1)
	(if ext_a_mig_cov
		(begin (set ext_a_mig_cov_limit (- ext_a_mig_cov_limit 1))
			  (sleep 1)
			  (ai_command_list_by_unit 
				(unit (list_get (ai_actors ext_a_area_b_cov/squad_a) ext_a_mig_cov_limit))
					ext_a_area_a_ledge_d)
			  (if (= ext_a_mig_cov_limit 0) (set ext_a_mig_cov false))))
	(inspect ext_a_mig_cov_limit)
	(sleep 1)
	(if (= ext_a_mig_cov_limit 0) (begin (ai_follow_target_players ext_a_area_b_cov/squad_a) (sleep -1)))
	)

(script dormant ini_ext_a_area_a_migration
	(sleep_until (volume_test_objects ext_a_area_a_follow (players)))
	(vehicle_unload ext_a_turret_a "gunner")
	(ai_migrate ext_a_area_a_cov ext_a_area_a_cov/squad_o)
	(ai_follow_target_players ext_a_area_a_cov)
	
	(sleep_until (volume_test_objects ext_a_area_b_trigger (players)))
	(sleep -1 dialog_ext_a_a_clear)
	(sleep 1)

	(ai_migrate ext_a_area_a_marines ext_a_area_b_marines/squad_a)
	(ai_migrate ext_a_area_a_cov ext_a_area_b_cov/squad_all)
	
	(ai_command_list ext_a_area_a_ghost_a ext_a_area_a_ledge_c)
	(ai_command_list ext_a_area_a_ghost_b ext_a_area_a_ledge_c)
	(ai_command_list ext_a_area_a_wraith ext_a_wraith_ledge)
	
	(sleep 1)
	(set ext_a_mig_cov_limit (ai_living_count ext_a_area_b_cov/squad_a))
	(sleep 1)
	(inspect ext_a_mig_cov_limit)

	(ai_command_list_by_unit 
		(unit (list_get (ai_actors ext_a_area_b_cov/squad_a) ext_a_mig_cov_limit))
			ext_a_area_a_ledge_a)
		
	(wake ext_a_migration)
	
	(ai_command_list_by_unit 
		(unit (list_get (ai_actors ext_a_area_b_marines/squad_a) 0)) ext_a_area_a_ledge_b)
	(ai_command_list_by_unit 
		(unit (list_get (ai_actors ext_a_area_b_marines/squad_a) 1)) ext_a_area_a_ledge_c)
	(ai_command_list_by_unit 
		(unit (list_get (ai_actors ext_a_area_b_marines/squad_a) 2)) ext_a_area_a_ledge_b)
	(ai_command_list_by_unit
		(unit (list_get (ai_actors ext_a_area_b_marines/squad_a) 3)) ext_a_area_a_ledge_c)
	)

(script dormant ini_ext_a_area_b
	(objects_predict ext_a_area_b_ghost_a)
	(objects_predict ext_a_area_b_ghost_b)

	(sleep_until (volume_test_objects ext_a_area_b_ghosts (players)))
	(wake general_save)
	(vehicle_load_magic ext_a_area_b_ghost_a "driver" (ai_actors ext_a_area_b_cov/ghost_a_pilot))
	(vehicle_load_magic ext_a_area_b_ghost_b "driver" (ai_actors ext_a_area_b_cov/ghost_b_pilot))
	
	(ai_vehicle_encounter ext_a_area_b_ghost_a ext_a_area_b_ghost_a/squad_g)
	(ai_vehicle_encounter ext_a_area_b_ghost_b ext_a_area_b_ghost_b/squad_g)
	
	(ai_follow_target_players ext_a_area_b_ghost_a/squad_g)
	(ai_follow_target_players ext_a_area_b_ghost_b/squad_g)

	(ai_vehicle_enterable_distance ext_a_area_b_ghost_a 15)
	(ai_vehicle_enterable_distance ext_a_area_b_ghost_b 15)
	
	(ai_magically_see_players ext_a_area_b_ghost_a)
	(ai_magically_see_players ext_a_area_b_ghost_b)
	)
	
(script dormant ini_ext_a_area_c_banshee
	(ai_place ext_a_area_c_cov/banshee_pilot)
	(ai_go_to_vehicle ext_a_area_c_cov/banshee_pilot ext_a_area_c_banshee "driver")
	(sleep 1)
	(ai_vehicle_encounter ext_a_area_c_banshee ext_a_banshee/squad_c)
	(ai_follow_target_players ext_a_banshee/squad_c)
	(ai_magically_see_players ext_a_banshee)
	)

(script dormant ini_ext_a_area_c_turrets
	(begin_random
		(if crev_ent_turrets
			(begin (wake crev_ent_turret_a)
				  (set crev_ent_turret_counter (+ 1 crev_ent_turret_counter))
				  (if (= crev_ent_turret_counter crev_ent_turret_limit) (set crev_ent_turrets false))))
		(if crev_ent_turrets
			(begin (wake crev_ent_turret_b)
				  (set crev_ent_turret_counter (+ 1 crev_ent_turret_counter))
				  (if (= crev_ent_turret_counter crev_ent_turret_limit) (set crev_ent_turrets false))))
		(if crev_ent_turrets
			(begin (wake crev_ent_turret_c)
				  (set crev_ent_turret_counter (+ 1 crev_ent_turret_counter))
				  (if (= crev_ent_turret_counter crev_ent_turret_limit) (set crev_ent_turrets false))))
		(if crev_ent_turrets
			(begin (wake crev_ent_turret_d)
				  (set crev_ent_turret_counter (+ 1 crev_ent_turret_counter))
				  (if (= crev_ent_turret_counter crev_ent_turret_limit) (set crev_ent_turrets false))))
		(if crev_ent_turrets
			(begin (wake crev_ent_turret_e)
				  (set crev_ent_turret_counter (+ 1 crev_ent_turret_counter))
				  (if (= crev_ent_turret_counter crev_ent_turret_limit) (set crev_ent_turrets false)))))
	(set crev_ent_turret_counter 0)
	(set crev_ent_turrets true)
	)

(script static void migration_a_a
	(sleep 1))
	
(script static void migration_a_b
	(ai_migrate ext_a_area_a_marines ext_a_area_b_marines/squad_a)
	(sleep 1)
	(ai_follow_target_players ext_a_area_b_marines/squad_a)
	)
	
(script static void migration_a_c
	(ai_migrate ext_a_area_a_marines ext_a_area_c_marines/squad_a)
	(ai_migrate ext_a_area_b_marines ext_a_area_c_marines/squad_a)
	(sleep 1)
	(ai_follow_target_players ext_a_area_c_marines/squad_a)
	)
	
(script static void migration_crev
	(ai_migrate ext_a_area_a_marines crev_marines/squad_a)
	(ai_migrate ext_a_area_b_marines crev_marines/squad_a)
	(ai_migrate ext_a_area_c_marines crev_marines/squad_a)
	(sleep 1)
	(ai_follow_target_players crev_marines/squad_a)
	)

(script static void migration_b_a
	(ai_migrate ext_a_area_a_marines ext_b_marines_ini/squad_y)
	(ai_migrate ext_a_area_b_marines ext_b_marines_ini/squad_y)
	(ai_migrate ext_a_area_c_marines ext_b_marines_ini/squad_y)
	(ai_migrate crev_marines ext_b_marines_ini/squad_y)
	(sleep 1)
	(ai_follow_target_players ext_b_marines_ini/squad_y)
	)

(script static void migration_b_b
	(ai_migrate ext_a_area_a_marines ext_b_marines/squad_a)
	(ai_migrate ext_a_area_b_marines ext_b_marines/squad_a)
	(ai_migrate ext_a_area_c_marines ext_b_marines/squad_a)
	(ai_migrate crev_marines ext_b_marines/squad_a)
	(ai_migrate ext_b_marines_ini ext_b_marines/squad_a)
	(sleep 1)
	(ai_follow_target_players ext_b_marines/squad_a)
	)

(script static void exit_jeep
	(ai_exit_vehicle ext_a_jeep)
	(ai_exit_vehicle ext_b_jeep)
;	(sleep 90)
	(cond
		((= exterior_player_location 1) (migration_a_a))
		((= exterior_player_location 2) (migration_a_b))
		((= exterior_player_location 3) (migration_a_c))
		((= exterior_player_location 4) (migration_crev))
		((= exterior_player_location 5) (migration_b_a))
		((= exterior_player_location 6) (migration_b_b))
		)
	)

(script static void exit_tank
	(ai_exit_vehicle ext_a_tank)
	(ai_exit_vehicle ext_b_tank)
;	(sleep 90)
	(cond
		((= exterior_player_location 1) (migration_a_a))
		((= exterior_player_location 2) (migration_a_b))
		((= exterior_player_location 3) (migration_a_c))
		((= exterior_player_location 4) (migration_crev))
		((= exterior_player_location 5) (migration_b_a))
		((= exterior_player_location 6) (migration_b_b))
		)
	)

(script continuous ini_jeep_exit_a
	(sleep_until (not (vehicle_test_seat_list ext_a_jeep "w-driver" (players))))
	(sleep 90)
	(if (and (< (ai_status ext_a_jeep) 4) (= (vehicle_test_seat_list ext_a_jeep "w-driver" (players)) 0))
		    (exit_jeep))
	(sleep 300)
	)
	
(script continuous ini_tank_exit_a
	(sleep_until (not (vehicle_test_seat_list ext_a_tank "scorpion-driver" (players))))
	(sleep 90)
	(if (= (vehicle_test_seat_list ext_a_tank "scorpion-driver" (players)) 0)
	    (exit_tank))
	(sleep 300)
	)


;========== Encounter Scripts (Crevasse) ==========

(script dormant enc_crevasse
	(ai_place crevasse_cov_a/jackals_w)
	(ai_place crevasse_cov_a/elites_k)
	(ai_place crevasse_cov_a/turret_a_gunners)
	(ai_place crevasse_cov_a/turret_b_gunners)

	(ai_place crevasse_cov_b/turret_c_gunners)
	(ai_place crevasse_cov_b/hunters)
	(ai_place crevasse_cov_b/jackals_g)
	(ai_place crevasse_cov_b/grunts_a)
	(ai_place crevasse_cov_b/elites_k)
	(sleep 1)
	(objects_predict (ai_actors crevasse_cov_a))
	(objects_predict (ai_actors crevasse_cov_b))
	(objects_predict crevasse_turret_a)
	)

(script dormant enc_crevasse_reins
	(ai_place crevasse_cov_b/elites_reins)
	(ai_place crevasse_cov_b/grunts_reins)
	(sleep 1)
	(objects_predict (ai_actors crevasse_cov_b))
	)
	

;========== Initialization Scripts (Crevasse) ==========

(script dormant ini_crevasse_reins
	(sleep_until (> (device_group_get garagedoor_c_position) 0))
	(wake enc_crevasse_reins)
	(wake general_save)
	)

(script continuous ini_crevasse_turret_a
	(begin_random
		(begin (ai_go_to_vehicle crevasse_cov_a/turret_a_gunners crevasse_turret_a gunner) (sleep default_turret_delay))
		(sleep default_turret_delay))
	)
	
(script continuous ini_crevasse_turret_b
	(begin_random
		(begin (ai_go_to_vehicle crevasse_cov_a/turret_b_gunners crevasse_turret_b gunner) (sleep default_turret_delay))
		(sleep default_turret_delay))
	)

(script continuous ini_crevasse_turret_c
	(begin_random
		(begin (ai_go_to_vehicle crevasse_cov_b/turret_c_gunners crevasse_turret_c gunner) (sleep default_turret_delay))
		(sleep default_turret_delay))
	)
	
(script dormant ini_crev_dialog
	(sleep_until (volume_test_objects crev_dialog_trigger (players)))
	(ai_conversation enter_crev)
	)

;========== Encounter Scripts (Exterior B) ==========

; this script dumps 12 (max) covenant into the area
(script dormant enc_ext_b_tunnel
	(ai_place ext_b_area_a_cov/elites_a)
	(ai_place ext_b_area_a_cov/grunts_a)
	(ai_place ext_b_area_a_cov/jackals_c)
	(ai_place ext_b_area_a_cov/jackals_d)
	(sleep 1)
	(objects_predict (ai_actors ext_b_area_a_cov))
	)

; this script dumps 8 covenant into the area
(script dormant enc_ext_b_a_trigger_b
	(if (< (ai_living_count ext_a_area_a_cov) 4)
		(begin
			(ai_place ext_b_area_a_cov/elites_u)
			(ai_place ext_b_area_a_cov/grunts_u)
			(ai_place ext_b_area_a_cov/jackals_u)
			(ai_place ext_b_area_a_cov/elites_v)
			(ai_place ext_b_area_a_cov/grunts_v)
			(ai_place ext_b_area_a_cov/jackals_v)
			(ai_place ext_b_area_a_cov/elites_j)
			(sleep 1)
			(objects_predict (ai_actors ext_b_area_a_cov))))
	)

; this script dumps 8 covenant into the area
(script dormant enc_ext_b_a_trigger_c
	(if (< (ai_living_count ext_a_area_a_cov) 4)
		(begin
			(ai_place ext_b_area_a_cov/elites_s)
			(ai_place ext_b_area_a_cov/grunts_s)
			(ai_place ext_b_area_a_cov/jackals_s)
			(ai_place ext_b_area_a_cov/elites_t)
			(ai_place ext_b_area_a_cov/grunts_t)
			(ai_place ext_b_area_a_cov/jackals_t)
			(sleep 1)
			(objects_predict (ai_actors ext_b_area_a_cov))))
	)

; this script dumps 13 (max) covenant into the area
(script dormant enc_ext_b_b
	(if (< (ai_living_count ext_a_area_b_cov) 8)
		(begin
			(ai_place ext_b_area_b_cov/grunts_a)
			(ai_place ext_b_area_b_cov/grunts_c)
			(ai_place ext_b_area_b_cov/elites_c)))
	(ai_place ext_b_area_b_cov/jackals_b)
	(ai_place ext_b_area_b_cov/turret_gunner_a)
	(ai_place ext_b_area_b_cov/turret_gunner_b)
	
	(ai_go_to_vehicle ext_b_area_b_cov/turret_gunner_a ext_b_b_turret_a "gunner")
	(ai_go_to_vehicle ext_b_area_b_cov/turret_gunner_b ext_b_b_turret_b "gunner")
	(sleep 1)
	(objects_predict ext_b_b_turret_a)
	(objects_predict (ai_actors ext_b_area_b_cov))
	)
	
(script dormant enc_ext_b_b_marines
	(ai_place ext_b_marines/marines_tunnel)
	(ai_place ext_b_marines/sarge)

;	(ai_place ext_b_area_b_cov/elites_e)
;	(ai_place ext_b_area_b_cov/grunts_e)
;	(ai_place ext_b_area_b_cov/jackals_e)
	(ai_place ext_b_area_b_cov/hunters)
	(sleep 1)
	(objects_predict (ai_actors ext_b_area_b_cov))
	
	(sleep 150)
	(ai_conversation ext_b_b_ini)
	)

(script dormant enc_ext_b_cave
	(ai_place ext_b_area_b_cov/stealth_i)
	(if (< (ai_living_count ext_b_area_b_cov) 8)
		(begin
			(ai_place ext_b_area_b_cov/grunts_j)
			(ai_place ext_b_area_b_cov/jackals_l)))
	(sleep 1)
	(objects_predict (ai_actors ext_b_area_b_cov))
	)

(script dormant enc_ext_b_b_final
	(ai_place ext_b_area_b_cov/elites_o)
	(ai_place ext_b_area_b_cov/grunts_m)
	(ai_place ext_b_area_b_cov/turret_gunner_c)
	(ai_go_to_vehicle ext_b_area_b_cov/turret_gunner_c ext_b_b_turret_c "gunner")
	
;	(ai_place ext_b_area_c_cov/elites_a)
;	(ai_place ext_b_area_c_cov/grunts_a)
	(sleep 1)
	(objects_predict (ai_actors ext_b_area_b_cov))
	(objects_predict (ai_actors ext_b_area_c_cov))
	(objects_predict ext_b_b_turret_c)
	)

(script dormant enc_ext_b_c_ini
	(if (< (ai_living_count ext_b_area_c_cov) 3)
		(begin
			(ai_place ext_b_area_c_cov/elites_a)
			(ai_place ext_b_area_c_cov/grunts_a)))
	(ai_place ext_b_area_c_cov/grunts_b)
	(ai_place ext_b_area_c_cov/turret_gunner_a)
	(sleep 1)
	(ai_go_to_vehicle ext_b_area_c_cov/turret_gunner_a ext_b_c_turret_a "gunner")
	(objects_predict (ai_actors ext_b_area_c_cov))
	(objects_predict ext_b_c_turret_a)
	)

(script dormant enc_ext_b_c_final
	(ai_place ext_b_area_c_cov/elites_b)
	(ai_place ext_b_area_c_cov/turret_gunner_b)
	(ai_place ext_b_area_c_cov/turret_gunner_c)
	(ai_place ext_b_area_c_cov/ghost_pilot_a)
	(ai_place ext_b_area_c_cov/ghost_pilot_b)
	(sleep 1)
	(ai_go_to_vehicle ext_b_area_c_cov/turret_gunner_b ext_b_c_turret_b "gunner")
	(ai_go_to_vehicle ext_b_area_c_cov/turret_gunner_c ext_b_c_turret_c "gunner")
	
	(ai_go_to_vehicle ext_b_area_c_cov/ghost_pilot_a ext_b_c_ghost_a "driver")
	(ai_go_to_vehicle ext_b_area_c_cov/ghost_pilot_b ext_b_c_ghost_b "driver")
	
	(ai_vehicle_encounter ext_b_c_ghost_a ext_b_c_ghost_a/squad_j)
	(ai_vehicle_encounter ext_b_c_ghost_b ext_b_c_ghost_b/squad_l)
	
	(ai_follow_target_players ext_b_c_ghost_a/squad_j)
	(ai_follow_target_players ext_b_c_ghost_b/squad_l)
	
	(objects_predict (ai_actors ext_b_area_c_cov))
	(objects_predict ext_b_c_ghost_a)
	)

(script dormant enc_ext_b_c_reins
	(ai_place ext_b_area_c_cov/elites_d)
	(ai_place ext_b_area_c_cov/elites_e)
	(sleep 1)
	(objects_predict (ai_actors ext_b_area_c_cov))
	)
	
;========== Initialization Scripts (Exterior B) ==========

(script dormant ini_ext_b_a_dropship_a
	(ext_b_a_dropship_a)
	)

(script continuous ini_jeep_exit_b
	(sleep_until (= (vehicle_test_seat_list ext_a_jeep "w-driver" (players)) 0))
	(sleep 90)
	(if (and (< (ai_status ext_b_jeep) 4) (= (vehicle_test_seat_list ext_a_jeep "w-driver" (players)) 0))
		    (exit_jeep))
	(sleep 300)
	)
	
(script continuous ini_tank_exit_b
	(sleep_until (= (vehicle_test_seat_list ext_a_tank "scorpion-driver" (players)) 0))
	(sleep 90)
	(if (= (vehicle_test_seat_list ext_a_tank "scorpion-driver" (players)) 0)
			(exit_tank))
	(sleep 300)
	)

(script dormant ini_ext_b_tunnel
	(wake enc_ext_b_tunnel)
	
	(sleep_until (= (ai_status ext_b_area_a_cov) 6))
	(ai_go_to_vehicle ext_b_area_a_cov/elites_a tunnel_ghost_b "driver")
	(ai_vehicle_encounter tunnel_ghost_a tunnel_ghost_a/squad_a)
	(ai_follow_target_players tunnel_ghost_a/squad_a)
	
	(sleep 600)
	(ai_vehicle_enterable_distance tunnel_ghost_b 10)
	(ai_vehicle_encounter tunnel_ghost_b tunnel_ghost_b/squad_a)
	(ai_follow_target_players tunnel_ghost_b/squad_a)
	(ai_magically_see_players tunnel_ghost_b)
	)

(script dormant ini_tunnel_follow
	(ai_migrate ext_b_area_a_cov/elites_a ext_b_area_a_cov/squad_d)
	(ai_migrate ext_b_area_a_cov/grunts_a ext_b_area_a_cov/squad_d)
	(ai_migrate ext_b_area_a_cov/jackals_c ext_b_area_a_cov/squad_d)
	(ai_migrate ext_b_area_a_cov/jackals_d ext_b_area_a_cov/squad_d)
	(sleep 1)
	(ai_follow_target_players ext_b_area_a_cov/squad_d)
	)

(script dormant ini_ext_b_tower
	(sleep_until (volume_test_objects ext_b_tower_trigger (players)))
	(ai_place ext_b_area_a_cov/elites_tower)
	(sleep 1)
	(objects_predict (ai_actors ext_b_area_a_cov/elites_tower))
	)
	
(script dormant ini_ext_b_second
	(ai_place ext_b_area_a_cov/turret_a_gunner)
	(ai_place ext_b_area_a_cov/turret_b_gunner)
	(ai_place ext_b_area_a_cov/ghost_pilot_c)
	(ai_place ext_b_area_a_cov/ghost_pilot_d)
	(ai_place ext_b_area_a_cov/wraith_gunner)
	
	(ai_go_to_vehicle ext_b_area_a_cov/ghost_pilot_c ext_b_a_ghost_c "driver")
	(ai_go_to_vehicle ext_b_area_a_cov/ghost_pilot_d ext_b_a_ghost_d "driver")
	(ai_go_to_vehicle ext_b_area_a_cov/turret_a_gunner ext_b_a_turret_a "gunner")
	(ai_go_to_vehicle ext_b_area_a_cov/turret_b_gunner ext_b_a_turret_b "gunner")
	(ai_go_to_vehicle ext_b_area_a_cov/wraith_gunner ext_b_a_wraith "driver")

	(ai_vehicle_encounter ext_b_a_ghost_c ext_b_a_ghost_c/squad_c)
	(ai_vehicle_encounter ext_b_a_ghost_d ext_b_a_ghost_d/squad_d)
	(ai_vehicle_encounter ext_b_a_wraith ext_b_a_wraith/wraith)
	
	(ai_follow_target_players ext_b_area_a_cov/ghost_pilot_c)
	(ai_follow_target_players ext_b_area_a_cov/ghost_pilot_d)
	(ai_follow_target_players ext_b_a_ghost_c/squad_c)
	(ai_follow_target_players ext_b_a_ghost_d/squad_d)
	(sleep 1)
	(objects_predict ext_b_a_ghost_c)
	(objects_predict ext_b_a_turret_a)
	(objects_predict ext_b_a_wraith)
	(objects_predict (ai_actors ext_b_area_a_cov))
	
	(ai_migrate ext_b_area_a_cov/elites_a ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/grunts_a ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_c ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_d ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/elites_e ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/grunts_e ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_e ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/elites_f ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/grunts_f ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_f ext_b_area_a_cov/squad_l)
	
	(ai_follow_target_players  ext_b_area_a_cov/squad_l)
	(sleep 30)
	(ai_magically_see_players ext_b_a_wraith)
	(ai_magically_see_players ext_b_a_ghost_c)
	(ai_magically_see_players ext_b_a_ghost_d)
	)

(script dormant ini_ext_b_trigger_b
	(sleep_until (volume_test_objects ext_b_a_trigger_b (players)))
	(wake enc_ext_b_a_trigger_b)
	)

(script dormant ini_ext_b_trigger_c
	(sleep_until (volume_test_objects ext_b_a_trigger_c (players)))
	(wake enc_ext_b_a_trigger_c)
	)

(script dormant ini_ext_b_trigger_d
	(ai_place ext_b_area_a_cov/hunter_o)
	(ai_place ext_b_area_a_cov/hunter_q)
	
	(if (and (= (ai_living_count ext_b_a_ghost_a) 0)
		    (= (ai_living_count ext_b_a_ghost_b) 0)
		    (= (ai_living_count ext_b_a_ghost_c) 0)
		    (= (ai_living_count ext_b_a_ghost_d) 0))
	    (begin  (ai_place ext_b_area_a_cov/ghost_pilot_e) (ai_place ext_b_area_a_cov/ghost_pilot_f)))
	
	(ai_go_to_vehicle ext_b_area_a_cov/ghost_pilot_e ext_b_a_ghost_e "driver")
	(ai_go_to_vehicle ext_b_area_a_cov/ghost_pilot_f ext_b_a_ghost_f "driver")

	(ai_vehicle_encounter ext_b_a_ghost_c ext_b_a_ghost_e/squad_e)
	(ai_vehicle_encounter ext_b_a_ghost_d ext_b_a_ghost_f/squad_f)
	
	(ai_follow_target_players ext_b_area_a_cov/ghost_pilot_e)
	(ai_follow_target_players ext_b_area_a_cov/ghost_pilot_f)
	(ai_follow_target_players ext_b_a_ghost_e/squad_e)
	(ai_follow_target_players ext_b_a_ghost_f/squad_f)
	(sleep 1)
	(objects_predict ext_b_a_ghost_c)
	(objects_predict (ai_actors ext_b_area_a_cov))
	
	(ai_migrate ext_b_area_a_cov/elites_u ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/grunts_u ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_u ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/elites_v ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/grunts_v ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_v ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/elites_j ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/elites_s ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/grunts_s ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_s ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/elites_t ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/grunts_t ext_b_area_a_cov/squad_l)
	(ai_migrate ext_b_area_a_cov/jackals_t ext_b_area_a_cov/squad_l)

	(ai_follow_target_players  ext_b_area_a_cov/squad_l)
	(sleep 30)
	(ai_magically_see_players ext_b_a_ghost_e)
	(ai_magically_see_players ext_b_a_ghost_f)
	)

(script dormant ini_ext_b_b_dropship_a
	(ext_b_b_dropship_a)
	(sleep_until (volume_test_objects ext_b_b_trigger_c (players)))
	(ai_migrate ext_b_area_b_cov/elites_p ext_b_area_b_cov/squad_p)
	(ai_migrate ext_b_area_b_cov/grunts_p ext_b_area_b_cov/squad_p)
	(ai_migrate ext_b_area_b_cov/jackals_p ext_b_area_b_cov/squad_p)
	(ai_follow_target_players  ext_b_area_b_cov/squad_p)
	
	)

(script dormant ini_pipe_cov
	(sleep_until (volume_test_objects ext_b_c_trigger_c (players)))
	(ai_place ext_b_area_c_cov/elites_c)
	(sleep 1)
	(objects_predict (ai_actors ext_b_area_c_cov))
	(ai_migrate ext_b_area_c_cov/elites_c ext_b_area_c_cov/squad_c)
	(ai_follow_target_players ext_b_area_c_cov/squad_c)
	)

(script dormant ini_ext_b_banshee_a
	(ai_place ext_b_area_a_cov/banshee_pilot)
	(ai_go_to_vehicle ext_b_area_a_cov/banshee_pilot ext_b_banshee_a driver)
	(ai_vehicle_encounter ext_b_banshee_a ext_b_banshee/squad_c)
	(ai_follow_target_players ext_b_banshee/squad_c)
	(sleep 30)
	(ai_magically_see_players ext_b_banshee)
	)

(script dormant ini_ext_b_banshee_b
	(ai_place ext_b_area_c_cov/banshee_pilot)
	(vehicle_load_magic ext_b_banshee_b "driver" (ai_actors ext_b_area_c_cov/banshee_pilot))
	(sleep 1)
	(ai_vehicle_encounter ext_b_banshee_b ext_b_banshee/squad_a)
	(ai_follow_target_players ext_b_banshee/squad_a)
	(sleep 30)
	(ai_magically_see_players ext_b_banshee)
	)

(script dormant ext_b_b_vehicle_exit
	(ai_vehicle_enterable_disable ext_a_dropship_ghost_a)
	(ai_vehicle_enterable_disable ext_a_dropship_ghost_b)
	(ai_vehicle_enterable_disable ext_a_area_b_ghost_a)
	(ai_vehicle_enterable_disable ext_a_area_b_ghost_b)
	(ai_vehicle_enterable_disable crev_ent_ghost_a)
	(ai_vehicle_enterable_disable crev_ent_ghost_b)
	(ai_vehicle_enterable_disable crev_ent_ghost_c)

	(ai_vehicle_enterable_disable ext_b_a_ghost_a)
	(ai_vehicle_enterable_disable ext_b_a_ghost_b)
	(ai_vehicle_enterable_disable ext_b_a_ghost_c)
	(ai_vehicle_enterable_disable ext_b_a_ghost_d)
	(ai_vehicle_enterable_disable ext_b_a_ghost_e)
	(ai_vehicle_enterable_disable ext_b_a_ghost_f)
	(ai_vehicle_enterable_disable tunnel_ghost_a)
	(ai_vehicle_enterable_disable tunnel_ghost_b)
	
	(sleep 1)

	(ai_exit_vehicle ext_b_a_ghost_a)
	(ai_exit_vehicle ext_b_a_ghost_b)
	(ai_exit_vehicle ext_b_a_ghost_c)
	(ai_exit_vehicle ext_b_a_ghost_d)
	(ai_exit_vehicle ext_b_a_ghost_e)
	(ai_exit_vehicle ext_b_a_ghost_f)
	(ai_exit_vehicle tunnel_ghost_a)
	(ai_exit_vehicle tunnel_ghost_b)

	(ai_exit_vehicle mig_b_ghost_a)
	(ai_exit_vehicle mig_b_ghost_b)
	(ai_exit_vehicle mig_b_ghost_c)
	(ai_exit_vehicle mig_b_ghost_d)
	(ai_exit_vehicle mig_b_ghost_e)
	(ai_exit_vehicle mig_b_ghost_f)
	(ai_exit_vehicle mig_b_ghost_g)
	)

;========== Encounter Scripts (B3) ==========

(script dormant enc_b3_bottom_cov
	(ai_place b3_bottom_cov/elite_guards)
	(ai_place b3_bottom_cov/grunts_a)
	(ai_place b3_bottom_cov/grunts_e)
	(ai_place b3_bottom_cov/grunts_g)
	(ai_place b3_bottom_cov/grunts_i)
	(ai_place b3_bottom_cov/grunts_m)
	(sleep 1)
	(objects_predict (ai_actors b3_bottom_cov))
	)

(script dormant enc_b3_lift_cov
	(ai_place b3_top_cov/jackals_lift)
	(sleep 1)
	(objects_predict (ai_actors b3_top_cov))
	)

(script dormant enc_b3_top_cov
	(ai_place b3_top_cov/jackals_lift_room)
	(ai_place b3_top_cov/elite_tree)
	(ai_place b3_top_cov/elite_commander)
	(ai_place b3_top_cov/grunts_a)
	(ai_place b3_top_cov/jackals_a)

	(begin_random
		(if b3_top_spawn
			(begin (ai_place b3_top_cov/grunts_c1)
				  (set b3_top_spawn_counter (+ 1 b3_top_spawn_counter))
				  (if (= b3_top_spawn_counter b3_top_squad_index) (set b3_top_spawn false))))
		(if b3_top_spawn
			(begin (ai_place b3_top_cov/grunts_c2)
				  (set b3_top_spawn_counter (+ 1 b3_top_spawn_counter))
				  (if (= b3_top_spawn_counter b3_top_squad_index) (set b3_top_spawn false))))
		(if b3_top_spawn
			(begin (ai_place b3_top_cov/jackals_c)
				  (set b3_top_spawn_counter (+ 1 b3_top_spawn_counter))
				  (if (= b3_top_spawn_counter b3_top_squad_index) (set b3_top_spawn false)))))
	(set b3_top_spawn_counter 0)
	(set b3_top_spawn true)
	
	(sleep 1)
	(ai_follow_target_ai b3_top_cov/grunts_a b3_top_cov/elite_commander)
	(ai_follow_target_ai b3_top_cov/jackals_a b3_top_cov/elite_commander)
	(objects_predict (ai_actors b3_top_cov))
	)

(script dormant enc_b3_top_cov_reins
	(ai_place b3_top_cov/elites_reins)
	(ai_place b3_top_cov/grunts_reins)
	(ai_place b3_top_cov/jackals_reins)
	(sleep 1)
	(ai_follow_target_ai b3_top_cov/grunts_reins b3_top_cov/elites_reins)
	(objects_predict (ai_actors b3_top_cov))
	)

;========== Initialization Scripts (B3) ==========

(script dormant ini_b3_bottom_cov
	(wake enc_b3_bottom_cov)
	(sleep_until (or (> (ai_status b3_bottom_cov/grunts_a) 3)
				  (> (ai_status b3_bottom_cov/grunts_e) 3)
				  (> (ai_status b3_bottom_cov/grunts_g) 3)
				  (> (ai_status b3_bottom_cov/grunts_i) 3)
				  (> (ai_status b3_bottom_cov/grunts_m) 3)))
	(ai_defend b3_bottom_cov/elite_guards)
	)

(script dormant ini_b3_top_reins
	(sleep_until (or (volume_test_objects b3_top_reins_trigger (players))
				  (= (ai_living_count b3_top_cov) 0)))
	(wake enc_b3_top_cov_reins)
	(sleep 1)
	(sleep_until (= (ai_living_count b3_top_cov/elites_reins) 0))
	(ai_migrate b3_top_cov b3_top_cov/squad_all)
	(sleep_until (= (ai_living_count b3_top_cov) 0))
	(set play_music_b40_05 0)
	)

(script dormant ini_b3_top_tree
	(sleep_until (or (volume_test_objects b3_top_tree_trigger_a (players))
				  (volume_test_objects b3_top_tree_trigger_b (players))))
	(ai_command_list_by_unit (unit (list_get (ai_actors b3_top_cov/elite_tree) 0)) b3_top_tree)
	(sleep 120)
	(ai_command_list_by_unit (unit (list_get (ai_actors b3_top_cov/elite_tree) 0)) b3_top_tree_off)
	)

;========== Encounter Scripts (B3 Bridge) ==========

(script dormant enc_b3_bridge
	(ai_place b3_bridge/grunts_a)
	(ai_place b3_bridge/grunts_c)
	(ai_place b3_bridge/jackals_c)
	(ai_place b3_bridge/grunts_g)
	(ai_place b3_bridge/jackals_g)
	(ai_place b3_bridge/elites_e)
	
	(ai_place b4_bridge/b3_grunts_c)
	(ai_place b4_bridge/b3_grunts_e)
	(ai_place b4_bridge/b3_grunts_g)
	(sleep 1)
	(objects_predict (ai_actors b3_bridge))
	(objects_predict (ai_actors b4_bridge))
	)

(script dormant enc_b3_bridge_reins
	(ai_place b3_bridge/stealth_elites)
	(ai_place b3_bridge/grunts_reins)
	(sleep 1)
	(objects_predict (ai_actors b3_bridge))
	)

;========== Encounter Scripts (B4) ==========

(script dormant enc_b4_a
	(ai_place b4_a_cov/elites_1)
	(ai_place b4_a_cov/elites_2)
	(ai_place b4_a_cov/elites_3)
	(ai_place b4_a_cov/elites_4)
	(sleep 1)
	(objects_predict (ai_actors b4_a_cov))
	)

(script dormant enc_b4_b
	(ai_place b4_b_cov/elites_w)
	(ai_place b4_b_cov/grunts_w)
	(ai_place b4_b_cov/elites_a)
	(ai_place b4_b_cov/grunts_m)
	(ai_place b4_b_cov/grunts_g)
	(ai_place b4_b_cov/jackals_k)
	(sleep 1)
	(objects_predict (ai_actors b4_b_cov))
	)

(script dormant enc_b4_hall
	(ai_place b4_hall/grunts)
	(ai_place b4_hall/jackals)
	(sleep 1)
	(objects_predict (ai_actors b4_hall))
	)

;========== Encounter Scripts (B4 Bridge) ==========

(script dormant enc_b4_bridge_ini
	(ai_place b3_bridge/hunters)
	(ai_place b4_bridge/elites_c)

	(begin_random
		(if b4_bridge_spawn
			(begin (ai_place b4_bridge/grunts_a)
				  (set b4_bridge_spawn_counter (+ 1 b4_bridge_spawn_counter))
				  (if (= b4_bridge_spawn_counter b4_bridge_squad_index) (set b4_bridge_spawn false))))
		(if b4_bridge_spawn
			(begin (ai_place b4_bridge/jackals_a)
				  (set b4_bridge_spawn_counter (+ 1 b4_bridge_spawn_counter))
				  (if (= b4_bridge_spawn_counter b4_bridge_squad_index) (set b4_bridge_spawn false)))))
	(set b4_bridge_spawn_counter 0)
	(set b4_bridge_spawn true)
	(sleep 1)
	(objects_predict (ai_actors b3_bridge))
	(objects_predict (ai_actors b4_bridge))
	)

(script dormant enc_b4_bridge_reins_a
	(ai_place b4_bridge/elites_g)
	
	(begin_random
		(if b4_bridge_spawn
			(begin (ai_place b4_bridge/grunts_e)
				  (set b4_bridge_spawn_counter (+ 1 b4_bridge_spawn_counter))
				  (if (= b4_bridge_spawn_counter b4_bridge_squad_index) (set b4_bridge_spawn false))))
		(if b4_bridge_spawn
			(begin (ai_place b4_bridge/jackals_e)
				  (set b4_bridge_spawn_counter (+ 1 b4_bridge_spawn_counter))
				  (if (= b4_bridge_spawn_counter b4_bridge_squad_index) (set b4_bridge_spawn false)))))
	(set b4_bridge_spawn_counter 0)
	(set b4_bridge_spawn true)
	(sleep 1)
	(objects_predict (ai_actors b4_bridge))
	)

(script dormant enc_b4_bridge_reins_b
	(ai_place b4_bridge/stealth_elites)
	(sleep 1)
	(objects_predict (ai_actors b4_bridge))
	)

;========== Initialization Scripts (B3 Bridge) ==========

(script dormant ini_b4_bridge_cheat
	(sleep_until (volume_test_objects b4_bridge_reins_trigger_b (players)))
	(wake enc_b4_bridge_reins_b)
	(ai_migrate b4_bridge b4_bridge/squad_all)
	)

;========== Encounter Scripts (B5) ==========

(script dormant enc_b5_a
	(ai_place b5_a_cov/jackals_a)
	(ai_place b5_a_cov/jackals_g)
	(ai_place b5_a_cov/grunts_c)
	(ai_place b5_a_cov/grunts_i)
	(sleep 1)
	(objects_predict (ai_actors b5_a_cov))
	)

(script dormant enc_b5_hall
	(ai_place b5_hall_cov/stealth_elites_a)
	(ai_place b5_hall_cov/stealth_elites_e)
	(sleep 1)
	(objects_predict (ai_actors b5_hall_cov))
	)

(script dormant enc_b5_b
	(ai_place b5_b_cov/hunters)
	(sleep 1)
	(objects_predict (ai_actors b5_b_cov))
	)

(script dormant enc_b5_b_reins_1
	(ai_place b5_b_cov/elites_reins)
	(ai_place b5_b_cov/jackals_reins)
	(ai_place b5_b_cov/grunts_reins)
	(sleep 1)
	(objects_predict (ai_actors b5_b_cov))
	)

(script dormant enc_b5_b_reins_2
	(ai_place b5_b_cov/jackals_reins)
	(ai_place b5_b_cov/grunts_reins)
	(sleep 1)
	(objects_predict (ai_actors b5_b_cov))
	)


;========== Encounter Scripts (C Bridge) ==========

(script dormant enc_c_bridge_banshee
	(ai_place c_bridge/banshee_a_elite)
	(ai_place c_bridge/banshee_b_elite)
	(sleep 1)
	(objects_predict (ai_actors c_bridge))
	)
	
(script dormant enc_c_bridge_initial
	(ai_place c_bridge/elites_a)
	
	(begin_random
		(if c_bridge_spawn
			(begin (ai_place c_bridge/grunts_a1)
				  (set c_bridge_spawn_counter (+ 1 c_bridge_spawn_counter))
				  (if (= c_bridge_spawn_counter c_bridge_squad_index) (set c_bridge_spawn false))))
		(if c_bridge_spawn
			(begin (ai_place c_bridge/grunts_a2)
				  (set c_bridge_spawn_counter (+ 1 c_bridge_spawn_counter))
				  (if (= c_bridge_spawn_counter c_bridge_squad_index) (set c_bridge_spawn false))))
		(if c_bridge_spawn
			(begin (ai_place c_bridge/jackals_a)
				  (set c_bridge_spawn_counter (+ 1 c_bridge_spawn_counter))
				  (if (= c_bridge_spawn_counter c_bridge_squad_index) (set c_bridge_spawn false)))))
	(set c_bridge_spawn_counter 0)
	(set c_bridge_spawn true)
	(sleep 1)
	(objects_predict (ai_actors c_bridge))
	)


(script dormant enc_c_bridge_second
	(ai_place c_bridge/elites_b)
	
	(begin_random
		(if c_bridge_spawn
			(begin (ai_place c_bridge/grunts_b1)
				  (set c_bridge_spawn_counter (+ 1 c_bridge_spawn_counter))
				  (if (= c_bridge_spawn_counter c_bridge_squad_index) (set c_bridge_spawn false))))
		(if c_bridge_spawn
			(begin (ai_place c_bridge/grunts_b2)
				  (set c_bridge_spawn_counter (+ 1 c_bridge_spawn_counter))
				  (if (= c_bridge_spawn_counter c_bridge_squad_index) (set c_bridge_spawn false))))
		(if c_bridge_spawn
			(begin (ai_place c_bridge/jackals_b)
				  (set c_bridge_spawn_counter (+ 1 c_bridge_spawn_counter))
				  (if (= c_bridge_spawn_counter c_bridge_squad_index) (set c_bridge_spawn false)))))
	(set c_bridge_spawn_counter 0)
	(set c_bridge_spawn true)
	(sleep 1)
	(objects_predict (ai_actors c_bridge))
	)

(script dormant enc_c_bridge_reins
	(if (or (= (game_difficulty_get) hard)
		   (= (game_difficulty_get) impossible)) (ai_place c_bridge/hunter_c))
	(ai_place c_bridge/grunts_c)
	(sleep 1)
	(objects_predict (ai_actors c_bridge))
	
	(device_set_position c_bridge_far_door 1)
	)

;========== Initialization Scripts (C Bridge) ==========

(script dormant ini_c_bridge_banshee
	(ai_vehicle_encounter ext_c_banshee_a ext_c_banshee/banshee)
	(ai_vehicle_encounter ext_c_banshee_b ext_c_banshee/banshee)
	
	(sleep_until (volume_test_objects c_bridge_banshee_trigger (players)) 30 (* 30 15))
	(ai_go_to_vehicle c_bridge/banshee_a_elite ext_c_banshee_a driver )
	(ai_go_to_vehicle c_bridge/banshee_b_elite ext_c_banshee_b driver )
	)

;========== Encounter Scripts (C1) ==========

(script dormant enc_c1_top
	(ai_place c1_top_cov/grunts_middle)
	(ai_place c1_top_cov/jackals_c)
	(ai_place c1_top_cov/jackals_m)
	(sleep 1)
	(objects_predict (ai_actors c1_top_cov))
	)
	
(script dormant enc_c1_bottom
	(ai_place c1_bottom_cov/grunts_w)
	(ai_place c1_bottom_cov/stealth_elites)
	(ai_place c1_bottom_cov/jackals_far)
	(sleep 1)
	(objects_predict (ai_actors c1_bottom_cov))
	)
	
;========== Encounter Scripts (Exterior C) ==========

(script dormant enc_ext_c_ghost_pilots
	(ai_place ext_c_cov/ghost_pilot_a)
;	(ai_place ext_c_cov/ghost_pilot_b)
	(ai_place ext_c_cov/ghost_pilot_c)
	(ai_place ext_c_cov/wraith_pilot)
	(vehicle_load_magic ext_c_wraith_a "driver" (ai_actors ext_c_cov/wraith_pilot))
	(ai_vehicle_encounter ext_c_wraith_a ext_c_wraith/wraith)
	(sleep 1)
	(objects_predict (ai_actors ext_c_cov))
	)

(script dormant enc_ext_c
;	(ai_place ext_c_cov/ghost_pilot_a)
;	(ai_place ext_c_cov/ghost_pilot_b)
;	(ai_place ext_c_cov/ghost_pilot_c)
;	(ai_place ext_c_cov/jackals_s)
;	(ai_place ext_c_cov/jackals_g)
;	(ai_place ext_c_cov/grunts_g)
;	(ai_place ext_c_cov/grunts_o)
;	(ai_place ext_c_cov/elites_o)
	(ai_place ext_c_cov/turret_grunts)
	(sleep 1)
	(objects_predict (ai_actors ext_c_cov))
	)

(script dormant enc_ext_c_zig_top
;	(ai_place zig_cov_top/elite_commander_top)
	(ai_place zig_cov_top/hunters)
	(ai_place zig_cov_top/turret_grunts)
	(ai_place zig_cov_top/grunt_grenaders)
	(sleep 1)
	(objects_predict (ai_actors zig_cov_top))
	)

(script dormant enc_ext_c_zig_bottom
	(ai_place zig_cov_bottom/hunters_a)
	(ai_place zig_cov_bottom/turret_grunts_a)
	(ai_place zig_cov_bottom/turret_grunts_b)
	(ai_place zig_cov_bottom/elites_e)
	(ai_place zig_cov_bottom/grunts_e)
	(ai_place zig_cov_bottom/grunts_k)
	(ai_place zig_cov_bottom/jackals_k)
	(ai_place zig_cov_bottom/jackals_o)
	(sleep 1)
	(objects_predict (ai_actors zig_cov_bottom))
	)

(script dormant enc_control
	(ai_place control_cov/elites_g)
	(ai_place control_cov/grunts_g)
	(ai_place control_cov/elite_commander)
	(ai_place control_cov/grunts_a)
	(ai_place control_cov/turret_grunts)
	(sleep 1)
	(objects_predict (ai_actors control_cov))
	(ai_braindead control_cov true)
	)

;========== Initialization Scripts (Exterior C) ==========

(script static void ext_c_ghost_exit_a
	(ai_command_list ext_c_cov/ghost_a ext_c_ghost_exit_a)
	(if (volume_test_objects ghost_exit_trigger_a (ai_actors ext_c_cov/ghost_a))
	    (ai_exit_vehicle ext_c_cov/ghost_a))
	)

(script static void ext_c_ghost_exit_b
	(ai_command_list ext_c_cov/ghost_b ext_c_ghost_exit_b)
	(if (volume_test_objects ghost_exit_trigger_a (ai_actors ext_c_cov/ghost_b))
	    (ai_exit_vehicle ext_c_cov/ghost_b))
	)

(script static void ext_c_ghost_exit_c
	(ai_command_list ext_c_cov/ghost_c ext_c_ghost_exit_c)
	(if (volume_test_objects ghost_exit_trigger_c (ai_actors ext_c_cov/ghost_c))
	    (ai_exit_vehicle ext_c_cov/ghost_c))
	)

(script continuous ini_ext_c_ghosts
	(ai_vehicle_encounter ext_c_ghost_a ext_c_cov/ghost_a)
	(ai_vehicle_encounter ext_c_ghost_b ext_c_cov/ghost_b)
	(ai_vehicle_encounter ext_c_ghost_c ext_c_cov/ghost_c)
	
	(if (>= (ai_status ext_c_cov/ghost_pilot_a) 5)
	    (begin (sleep (random_range 0 120)) (ai_go_to_vehicle ext_c_cov/ghost_pilot_a ext_c_ghost_a driver)))
	(if (>= (ai_status ext_c_cov/ghost_pilot_b) 5)
	    (begin (sleep (random_range 0 120)) (ai_go_to_vehicle ext_c_cov/ghost_pilot_b ext_c_ghost_b driver)))
	(if (>= (ai_status ext_c_cov/ghost_pilot_c) 5)
	    (begin (sleep (random_range 0 120)) (ai_go_to_vehicle ext_c_cov/ghost_pilot_c ext_c_ghost_c driver)))
	(sleep 5)
	
	(if (and (> (ai_living_count ext_c_cov/ghost_a) 0)
		    (<= (ai_status ext_c_cov/ghost_a) 2))
	    (ext_c_ghost_exit_a))
	(if (and (> (ai_living_count ext_c_cov/ghost_b) 0)
		    (<= (ai_status ext_c_cov/ghost_b) 2))
	    (ext_c_ghost_exit_b))
	(if (and (> (ai_living_count ext_c_cov/ghost_c) 0)
		    (<= (ai_status ext_c_cov/ghost_c) 2))
	    (ext_c_ghost_exit_c))
	(sleep 60)
	)

(script continuous ini_ext_c_turrets
	(begin_random
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle ext_c_cov/turret_grunts ext_c_turret_a gunner) (sleep control_turret_delay))
		(sleep control_turret_delay))
;		(begin (ai_go_to_vehicle ext_c_cov/turret_grunts ext_c_turret_b gunner) (sleep control_turret_delay))
;		(sleep control_turret_delay))
	)

(script continuous ini_zig_bottom_turrets
	(begin_random
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle zig_cov_bottom/turret_grunts_a zig_bottom_turret_a gunner) (sleep control_turret_delay))
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle zig_cov_bottom/turret_grunts_b zig_bottom_turret_b gunner) (sleep control_turret_delay))
		(sleep control_turret_delay))
	)

(script continuous ini_zig_top_turrets
	(begin_random
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle control_cov/turret_grunts control_turret_a gunner) (sleep control_turret_delay))
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle control_cov/turret_grunts control_turret_b gunner) (sleep control_turret_delay))
		(sleep control_turret_delay))
	)

(script continuous ini_control_turrets
	(begin_random
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle zig_cov_top/turret_grunts zig_top_turret_a gunner) (sleep control_turret_delay))
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle zig_cov_top/turret_grunts zig_top_turret_b gunner) (sleep control_turret_delay))
		(sleep control_turret_delay)
		(begin (ai_go_to_vehicle zig_cov_top/turret_grunts zig_top_turret_b gunner) (sleep control_turret_delay))
		(sleep control_turret_delay))
	)
		
(script dormant ini_ext_c_migration
	(sleep_until (volume_test_objects zig_migration_trigger (players)))
	(wake general_save)
	(ai_migrate ext_c_cov zig_cov_bottom/squad_all)
	)
	
(script dormant ini_control_door
	(sleep_until (> (device_get_position control_door_a) 0) 5)
	(device_set_never_appears_locked control_door_a 1)
	(sleep_until (> (device_get_position control_door_b) 0) 5)
	(device_set_never_appears_locked control_door_b 1)
	(sleep_until (> (device_get_position control_door_c) 0) 5)
	(device_set_never_appears_locked control_door_c 1)
	(sleep_until (> (device_get_position control_door_d) 0) 5)
	(device_set_never_appears_locked control_door_d 1)
	)


;========== Setup Scripts ==========

(script dormant a1_setup
	(ai_migrate insertion_cov/grunts a1_cov/insertion_cleanup)
	(ai_magically_see_players a1_cov/insertion_cleanup)
	)

(script dormant a_bridge_setup
	(sleep -1 dialog_a1_clear)
	(ai_erase insertion_cov/elites)
;	(ai_migrate a1_cov a_bridge/a1_cleanup)
;	(ai_magically_see_players a_bridge/a1_cleanup)
;	(ai_teleport_to_starting_location_if_unsupported a_bridge/a1_cleanup)

	(sleep 1)
	(objects_predict ext_a_bridge_turret_a)
	(objects_predict ext_a_bridge_turret_b)
	(objects_predict ext_a_bridge_turret_c)
	(objects_predict ext_a_bridge_turret_d)
	(predict_ext_scenery)
	)

(script dormant a2_setup
	(object_create_containing "a2_dump")
;	(ai_migrate a_bridge a2_top_cov/a_bridge_cleanup)
;	(ai_magically_see_players a2_top_cov/a_bridge_cleanup)
;	(ai_teleport_to_starting_location_if_unsupported a2_top_cov/a_bridge_cleanup)
	)

(script dormant ext_a_setup
	(ai_erase a2_top_cov)
	
	(vehicle_load_magic ext_a_turret_a gunner (ai_actors ext_a_area_a_cov/grunts_a))
	(ai_vehicle_enterable_distance ext_a_turret_a 10)
	(ai_vehicle_enterable_actor_type ext_a_turret_a grunt)
		
	(object_destroy ext_a_pelican_jeep)
	
	(object_create ext_a_jeep)
	(object_create_containing "ext_a_dump_1")
;	(object_create ext_a_area_a_rocket)
;	(object_create ext_a_area_a_sniper)
	(object_create_containing "ext_a_ammo")
;	(object_create ext_a_ammo_2)
;	(object_create ext_a_ammo_3)
;	(object_create ext_a_ammo_4)
;	(object_create ext_a_ammo_5)
;	(object_create ext_a_ammo_6)
;	(object_create ext_a_ammo_7)
;	(object_create ext_a_ammo_8)
;	(object_create ext_a_ammo_9)
;	(object_create ext_a_ammo_10)
;	(object_create ext_a_ammo_22)
;	(object_create ext_a_ammo_23)
;	(object_create ext_a_ammo_24)
;	(object_create ext_a_ammo_25)
;	(object_create ext_a_ammo_26)
;	(object_create ext_a_ammo_27)
	(object_create_containing ext_a_marine)
;	(object_create ext_a_marine_2)
;	(object_create ext_a_marine_3)
;	(object_create ext_a_marine_4)
	
;	(ai_migrate a2_bottom_cov ext_a_area_a_cov/a2_cleanup)
;	(ai_magically_see_players ext_a_area_a_cov/a2_cleanup)
;	(sleep 1)
;	(ai_teleport_to_starting_location_if_unsupported ext_a_area_a_cov/a2_cleanup)
;	(sleep 1)
;	(ai_migrate ext_a_area_a_cov/a2_cleanup ext_a_area_a_cov/squad_w)
;	(ai_follow_target_players ext_a_area_a_cov/squad_w)
	
	(ai_vehicle_encounter ext_a_jeep ext_a_jeep)
	(ai_vehicle_encounter ext_a_tank ext_a_tank)
	
	(objects_predict ext_a_turret_a)
	(objects_predict ext_a_jeep)
;	(objects_predict ext_a_area_a_rocket)
;	(objects_predict ext_a_area_a_sniper)
	(objects_predict pelican_crashed)
	)

(script dormant ext_a_c_setup
;	(sleep -1 ext_a_save_1)
;	(ai_migrate ext_a_area_b_cov ext_a_area_c_cov/squad_y)
	(ai_migrate ext_a_area_b_marines ext_a_area_c_marines/squad_e)
	(sleep 1)
;	(ai_follow_target_players ext_a_area_c_cov/squad_y)
	(ai_follow_target_players ext_a_area_c_marines/squad_e)
	)

(script dormant ext_b_setup
	(ai_vehicle_encounter ext_a_jeep ext_b_jeep)
	(ai_vehicle_encounter ext_a_tank ext_b_tank)
	
	(ai_vehicle_encounter ext_a_dropship_ghost_a mig_b_ghost_a)
	(ai_vehicle_encounter ext_a_dropship_ghost_b mig_b_ghost_b)
	(ai_vehicle_encounter ext_a_area_b_ghost_a mig_b_ghost_c)
	(ai_vehicle_encounter ext_a_area_b_ghost_b mig_b_ghost_d)
	(ai_vehicle_encounter crev_ent_ghost_a mig_b_ghost_e)
	(ai_vehicle_encounter crev_ent_ghost_b mig_b_ghost_f)
	(ai_vehicle_encounter crev_ent_ghost_c mig_b_ghost_g)

;	(ai_migrate crevasse_cov_b ext_b_area_a_cov/squad_y)
;	(ai_migrate crev_cov ext_b_area_a_cov/squad_y)
;	(ai_teleport_to_starting_location_if_unsupported ext_b_area_a_cov/squad_y)
;	(ai_follow_target_players ext_b_area_a_cov/squad_y)
	
	(ai_migrate crev_marines ext_b_marines_ini/squad_y)
	(ai_follow_target_players ext_b_marines_ini/squad_y)

;	(wake general_save)
	(predict_ext_scenery)
	)

(script dormant ext_c_bridge_setup
	(predict_ext_scenery)
	(objects_predict ext_c_banshee_a)
	(objects_predict ext_c_wraith_a)
	(objects_predict ext_c_ghost_a)
	)

(script dormant ext_c_setup
;	(ai_migrate c1_bottom_cov ext_c_cov/c1_bot_cleanup)
	(predict_ext_scenery)
	(objects_predict ext_c_banshee_a)
	(objects_predict ext_c_wraith_a)
	(objects_predict ext_c_ghost_a)
	(device_set_power ext_c_ent_door 1)
	)

;========== Mission Scripts ==========

;(script static void test
;	(ai_place insertion_cov/grunts_ini)
;	(sleep 90)
;	(ai_command_list insertion_cov/grunts_ini ini_fleeing_grunts)
;	)

(script static void test_insertion
	(ai_place insertion_cov/grunts_ini)
	(ai_set_blind insertion_cov/grunts_ini true)
	(ai_set_deaf insertion_cov/grunts_ini true)
	(sleep 1)
	(objects_predict (ai_actors insertion_cov))
	(objects_predict insertion_banshee_a)
;	(objects_predict insertion_banshee_b)
	(objects_predict insertion_turret_a)
	(objects_predict insertion_turret_b)
	
; this used to be 28 seconds
	(sleep 60)
;	(ai_conversation insertion)
	(ai_command_list insertion_cov/grunts_ini ini_fleeing_grunts)
	)

(script dormant mission_insertion_a
	(ai_place insertion_cov/grunts_ini)
	(ai_set_blind insertion_cov/grunts_ini true)
	(ai_set_deaf insertion_cov/grunts_ini true)
	(sleep 1)
	(objects_predict (ai_actors insertion_cov))
;	(objects_predict insertion_banshee_a)
;	(objects_predict insertion_banshee_b)
	(objects_predict insertion_turret_a)
	(objects_predict insertion_turret_b)
	
; this used to be 28 seconds
	(sleep (* 30 21))
;	(ai_conversation insertion)
	(ai_command_list insertion_cov/grunts_ini ini_fleeing_grunts)
	)

(script dormant mission_insertion_b
	(wake obj_chasm1)
	(set mission_start 1)
	(sleep 60)
	(sleep_until (= (device_get_position insertion_door) 0))
	(sleep 60)
	(ai_place insertion_cov/grunts)
	(ai_place insertion_cov/elites)
;	(ai_erase insertion_cov/grunts_ini)
	(ai_set_blind insertion_cov false)
	(ai_set_deaf insertion_cov false)
	(device_set_position insertion_door 1)
;	(ai_vehicle_encounter insertion_banshee_a insertion_banshee/banshee)
;	(ai_vehicle_encounter insertion_banshee_b insertion_banshee/banshee)
	(ai_attack insertion_cov/grunts)
	
	(if (= (game_difficulty_get_real) impossible) (wake insertion_turrets))
;	(ai_magically_see_players insertion_cov/grunts)
	)

(script dormant mission_a1
	(wake a1_setup)
	(wake general_save)
	(game_save_no_timeout)
	(enc_a1_initial)
	
	(sleep_until (= (device_get_position a1_entrance_door) 1))
	(device_one_sided_set a1_entrance_door false)
	(enc_a1)
		
	(sleep_until (volume_test_objects a1_backdoor_trigger (players)))
	(enc_a1_rear)
	(ai_defend a1_cov/middle)
	(wake dialog_a1_clear)
	(sleep (* 30 15))
	(ai_migrate a1_cov a1_cov/back)
	)

(script dormant mission_a_bridge
;	(wake general_save)
	(wake a_bridge_setup)
	(wake ini_a_bridge_initial)
	(wake ini_a_bridge_turret_near)
	(if (or (= (game_difficulty_get) hard)
		   (= (game_difficulty_get) impossible)) (wake ini_ext_a_banshee))

	(sleep_until (= (device_get_position a_bridge_entrance_door) 1))
	(device_one_sided_set a_bridge_entrance_door false)
	(ai_conversation a_bridge_ini)
	(wake ini_cinematic_ext_a_pelican)
	(wake music_b40_01)
	(wake dialog_a_bridge_ini)

	(sleep_until (volume_test_objects ext_a_banshee_a_trigger (players)))
	(wake enc_a_bridge_second)
	
	(sleep_until (volume_test_objects a_bridge_reins_trigger (players)))
	(wake general_save)
	(ai_defend a_bridge/mid_squad)
	(wake ini_a_bridge_reins)
	(wake ini_a_bridge_turret_far)
	)

(script dormant mission_a2
;	(wake general_save)
;	(set play_music_b40_01 false)
	(wake a2_setup)
	(wake enc_a2_top_cov)
	(wake ini_a2_top_reins)
	(wake music_b40_011)
	(wake music_b40_02)

	(sleep_until (volume_test_objects a2_bottom_trigger (players)))
	(ai_erase ext_a_area_a_marines)
	(wake enc_a2_bottom)
	(ai_conversation a2_clear)
;	(wake general_save)
	(objects_predict (ai_actors a2_bottom_cov))

	(sleep_until (and (volume_test_objects a2_tube_trigger (players))
				   (or (objects_can_see_flag (players) a2_tub_flag_a 15)
					  (objects_can_see_flag (players) a2_tub_flag_b 15))))
	(ai_place a2_bottom_cov/grunts_tub)
	)

(script dormant mission_ext_a
	(set exterior_player_location 1)
	(predict_ext_scenery)
	(wake ext_a_setup)
	(wake enc_ext_a_cov)
	(wake ini_ext_a_marines)
	(wake ini_ext_a_area_a_migration)
	(wake dialog_ext_a_a_clear)
	(wake ini_ext_a_dropships_a)
	(wake ini_jeep_exit_a)
;	(wake general_save)

	(sleep 1)
	(ai_playfight ext_a_area_a_marines true)
	(ai_playfight ext_a_area_a_cov/jackals_e true)
	(ai_playfight ext_a_area_a_cov/grunts_e true)
	
;	(sleep_until (> (device_get_position ext_a_door) 0))
;	(ai_conversation ext_a_a)

	(sleep_until (volume_test_objects ext_a_area_a_follow (players)))
	(wake general_save)
	(wake enc_ext_a_a_cov_second)

	(sleep_until (volume_test_objects ext_a_area_b_trigger (players)) 10)
;	(wake general_save)
	(object_create_containing "ext_a_dump_2")
	(set exterior_player_location 2)
	(wake ini_tank_exit_a)
	(wake dialog_ext_a_b)
	(wake enc_ext_a_area_b)

; this spawns the marines, sleeps for 10 seconds then dumps all the marines into squad a
; and sets them to follow the player
	(wake enc_ext_a_area_b_mar)
	(wake ini_ext_a_area_b)
	(wake music_b40_03)
;	(wake dialog_scorpion_dead)
	(sleep 1)
	(objects_predict ext_a_tank)
	
	(sleep_until (volume_test_objects ext_a_area_b_ghosts (players)))
	(if (< (ai_living_count ext_a_area_b_cov) 6) (wake enc_ext_a_area_b_2))

	(sleep_until (or (volume_test_objects ext_a_area_c_trigger_a (players))
				  (volume_test_objects ext_a_area_c_trigger_b (players))) 10)
	(object_create_containing "ext_a_dump_3")
	(object_destroy_containing "a2_dump")
	(set exterior_player_location 3)
	(wake general_save)
	(wake ext_a_c_setup)			  
	(wake dialog_ext_a_c_wraith)
	(wake dialog_ext_a_c)
;	(wake dialog_ext_a_c_door)
	
	(wake ini_ext_a_c_dropship_a)
	(wake ini_ext_a_c_dropship_b)
	(wake ini_ext_a_c_dropship_c)
	(set ext_a_squad_index 3)
	(set ext_a_spawn false)
	(wake music_b40_04)
	(sleep -1 dialog_ext_a_b)
	(sleep 1)
	(wake enc_ext_a_area_c_cov)
	(wake ini_ext_a_area_c_turrets)
	
	
	(sleep_until (volume_test_objects ext_a_c_follow_trigger (players)))
	(wake general_save)
	(wake ini_ext_a_area_c_banshee)
	(ai_migrate ext_a_area_c_cov ext_a_area_c_cov/squad_c)
	(ai_follow_target_players ext_a_area_c_cov/squad_c)

	)

(script dormant mission_crevasse
	(object_create_containing "ext_a_dump_4")
	(object_destroy_containing "ext_a_dump_1")
	(object_destroy_containing "ext_a_dump_2")
	(set exterior_player_location 4)
;	(set play_music_b40_03 false)
	(ai_migrate ext_a_area_c_cov crevasse_cov_a/squad_all)
	(ai_migrate ext_a_area_c_marines crev_marines/squad_a)
	(sleep 1)
;	(ai_follow_target_players crev_cov/squad_a)
	(ai_follow_target_players crev_marines/squad_a)
	
	(wake general_save)
	(wake enc_crevasse)
;	(wake ini_crevasse_reins)
	(wake ini_crevasse_turret_a)
	(wake ini_crevasse_turret_b)
	(wake ini_crevasse_turret_c)
	(wake ini_crev_dialog)
	(sleep 1)
	(objects_predict crevasse_turret_a)
	(objects_predict crevasse_turret_b)
	(objects_predict crevasse_turret_c)

	(sleep_until (volume_test_objects crevasse_mig_trigger (players)))
	(ai_migrate crevasse_cov_a crevasse_cov_b/squad_all)
	(sound_looping_set_alternate "levels\b40\music\b40_04" 1)

	)

(script dormant mission_ext_b
	(wake general_save)
	(object_destroy_containing "ext_a_dump_3")
	(set play_music_b40_04 0)
	(set exterior_player_location 5)
	(wake ext_b_setup)
	(wake ini_ext_b_tunnel)
	(wake ini_jeep_exit_b)
	(wake ini_tank_exit_b)
	
	(sleep_until (volume_test_objects ext_b_a_trigger_a (players)))
	(object_create_containing "ext_b_dump_1")
	(wake obj_chasm2)
	(wake general_save)
	(wake ini_tunnel_follow)
	(wake ini_ext_b_tower)
	(wake ini_ext_b_a_dropship_a)
	
	(sleep_until (or (volume_test_objects ext_b_a_trigger_b (players))
				  (volume_test_objects ext_b_a_trigger_c (players))))
	(object_destroy_containing "ext_a_dump_4")
	(wake general_save)
	(wake ini_ext_b_trigger_b)
	(wake ini_ext_b_trigger_c)
	(wake ini_ext_b_second)
	
	(sleep_until (volume_test_objects ext_b_a_trigger_d (players)))
	(wake general_save)
	(wake ini_ext_b_trigger_d)
	(wake ini_ext_b_banshee_a)
	
	(sleep_until (volume_test_objects ext_b_b_trigger_a (players)) 5)
	(object_create_containing "ext_b_dump_2")
	(set exterior_player_location 6)
	(wake general_save)
	(ai_migrate ext_b_area_a_cov ext_b_area_b_cov/squad_a)
	(ai_follow_target_players ext_b_area_b_cov/squad_a)
	
	(ai_migrate ext_b_marines_ini ext_b_marines/squad_v)
	(ai_follow_target_players ext_b_marines/squad_v)
	(wake enc_ext_b_b)
	
	(sleep -1 ini_ext_b_trigger_b)
	(sleep -1 ini_ext_b_trigger_c)
	
	(sleep_until (volume_test_objects ext_b_b_trigger_b (players)))
	(wake general_save)
	(wake enc_ext_b_b_marines)
	
	(sleep_until (volume_test_objects ext_b_b_floor_trigger (players)))
	(wake music_b40_041)
	(wake ext_b_b_vehicle_exit)
	(ai_migrate ext_b_marines ext_b_marines/squad_u)
	(ai_follow_target_players ext_b_marines/squad_u)

	(wake ini_ext_b_b_dropship_a)
	
	(sleep_until (volume_test_objects ext_b_b_trigger_c (players)))
	(wake general_save)
	
	(sleep_until (volume_test_objects ext_b_tunnel_trigger (players)) 5)
	(object_create_containing "ext_b_dump_3")
	(wake enc_ext_b_cave)

	(sleep_until (volume_test_objects ext_b_b_trigger_d (players)))
	(wake enc_ext_b_b_final)
	
	(sleep_until (volume_test_objects ext_b_c_trigger_a (players)))
	(sound_looping_set_alternate "levels\b40\music\b40_041" 1)
	(wake general_save)
	(wake dialog_ext_b_c)
	(wake ini_pipe_cov)
	(ai_migrate ext_b_area_b_cov ext_b_area_c_cov/squad_b)
	(ai_follow_target_players ext_b_area_c_cov/squad_b)
	(sleep 1)
	(wake enc_ext_b_c_ini)

	(sleep_until (volume_test_objects ext_b_c_trigger_b (players)))
	(set play_music_b40_041 0)
	(wake enc_ext_b_c_final)
	(wake ini_ext_b_banshee_b)

	(sleep_until (volume_test_objects ext_b_c_trigger_d (players)))
	(wake enc_ext_b_c_reins)
	(wake general_save)
	(sleep 30)
	(wake dialog_ext_b_c_clear)
	)
	
(script dormant mission_b3
;	(wake general_save)
	(object_create_containing "b3_dump")
	(object_destroy_containing "ext_b_dump_1")
	(wake music_b40_042)
	(wake ini_b3_bottom_cov)
	(wake music_b40_05)
	
	(sleep_until (volume_test_objects b3_lift_cov_trigger (players)))
	(wake enc_b3_lift_cov)
	(ai_erase ext_b_marines)
	(ai_erase ext_b_marines_ini)
	
	(sleep_until (volume_test_objects b3_top_trigger (players)))
	(wake general_save)
	(wake enc_b3_top_cov)
	(wake ini_b3_top_reins)
	(wake ini_b3_top_tree)
	)

(script dormant mission_b3_bridge
;	(wake general_save)
	(object_destroy_containing "ext_b_dump_2")
	(object_destroy_containing "ext_b_dump_3")
	(set play_music_b40_05 0)
	(wake enc_b3_bridge)
	(wake ini_b4_bridge_cheat)
	
	(sleep_until (volume_test_objects b3_bridge_reins_trigger (players)))
	(wake general_save)
	(wake enc_b3_bridge_reins)

	(sleep_until (volume_test_objects b4_a_trigger (players)) 10)	
	(wake general_save)
	(object_create_containing "b4_dump")
	(wake enc_b4_a)
	
	(sleep_until (volume_test_objects b4_hall_trigger (players)))
	(wake general_save)
	(wake enc_b4_hall)
	(ai_migrate b4_a_cov b4_hall/all)
	(sleep 1)
	(if (> (ai_status b4_hall) 4) (ai_magically_see_players b4_hall/all))
	
	(sleep_until (volume_test_objects b4_b_trigger (players)))
	(wake general_save)
	(wake enc_b4_b)
	(ai_migrate b4_hall b4_b_cov/all)
	(sleep 1)
	(if (> (ai_status b4_b_cov) 4) (ai_magically_see_players b4_b_cov/all))

	(sleep_until (volume_test_objects b4_bridge_trigger (players)) 10)
	(device_set_power b4_bridge_door 1)
	(sleep -1 ini_b4_bridge_cheat)
	(wake enc_b4_bridge_ini)
	(wake music_b40_06)
	(wake general_save)

	(sleep_until (volume_test_objects b4_bridge_reins_trigger_a (players)))
	(wake general_save)
	(wake enc_b4_bridge_reins_a)
	
	(sleep_until (volume_test_objects b4_bridge_reins_trigger_b (players)))
	(wake enc_b4_bridge_reins_b)
	)

(script dormant mission_b5
;	(wake general_save)
	(object_create_containing "b5_dump")
	(object_destroy_containing "b3_dump")
	(if (= (game_difficulty_get) normal) (object_create b5_rocket_a))
	(wake music_b40_061)
	(wake enc_b5_a)
	(set play_music_b40_06 false)
	
	(ai_migrate b3_bridge/hunters b4_bridge/hunters_teleport)
	(ai_teleport_to_starting_location b4_bridge/hunters_teleport)

	(sleep_until (volume_test_objects b5_hall_trigger (players)))
	(wake general_save)
	(wake enc_b5_hall)
	(ai_migrate b5_a_cov b5_hall_cov/all)
	(sleep 1)
	(if (> (ai_status b5_hall_cov) 4) (ai_magically_see_players b5_hall_cov/all))
	
	(sleep_until (volume_test_objects b5_b_trigger (players)))
	(wake general_save)
	(wake enc_b5_b)
	(ai_migrate b5_hall_cov b5_b_cov/all)
	(sleep 1)
	(if (> (ai_status b5_b_cov) 4) (ai_magically_see_players b5_b_cov/all))

	(sleep_until (volume_test_objects b5_b_reins_trigger (players)))
	(if (= (ai_living_count b5_b_cov/hunters) 0) (wake enc_b5_b_reins_1) (wake enc_b5_b_reins_2))
	(sleep 1)
	(ai_magically_see_players b5_b_cov)
	(wake dialog_b5_clear)
	)

(script dormant mission_control
	(sleep_until (volume_test_objects control_trigger (players)))
	(object_destroy_containing "b5_dump")
	(object_destroy_containing "c1_dump")
	(set play_music_b40_07 0)
	(set play_music_b40_071 0)
	(wake enc_control)
	(wake music_b40_08)
	(wake ini_control_door)
	(wake general_save)
	
	(sleep_until (> (device_get_position control_door_a) 0) 5)
	(ai_braindead control_cov false)
	
	(sleep 300)
	(device_set_position control_door_b 1)
	
	(sleep_until (volume_test_objects inside_control (players)))
	(ai_migrate control_cov control_cov/inside)

	(sleep_until (> (device_get_position control_door_c) .3))
	(wake dialog_control_clear)
	(ai_migrate control_cov control_cov/final)
	)

(script dormant mission_c_bridge
	(set play_music_b40_061 0)
	(object_create_containing "ext_c_dump")
	(object_destroy_containing "ext_b_dump_3")
	(sleep -1 dialog_b5_clear)
	(wake mission_control)
	(wake ext_c_bridge_setup)
	(wake ini_c_bridge_banshee)
	(wake ini_ext_c_ghosts)
	(wake enc_c_bridge_banshee)
	(wake enc_c_bridge_initial)
	(wake enc_ext_c_ghost_pilots)
	(wake music_b40_07)
;	(wake general_save)
	(sleep 30)
	(wake enc_c_bridge_second)
	(sleep 60)
	
	(sleep_until (= (device_get_position c_bridge_near_door) 1))
	(device_one_sided_set c_bridge_near_door false)
;	(wake dialog_ext_c_banshee)
	
	(sleep_until (volume_test_objects c_bridge_reins_trigger (players)))
	(wake enc_c_bridge_reins)
	(device_one_sided_set c_bridge_far_door false)
	)

(script dormant mission_c1
;	(wake general_save)
	(object_create_containing "c1_dump")
	(object_destroy_containing "b5_dump")
	(set play_music_b40_07 false)
	(wake enc_c1_top)
	(wake music_b40_071)
	
	(sleep_until (volume_test_objects c1_bottom_trigger (players)))
;	(wake general_save)
	(wake enc_c1_bottom)
	)

(script dormant mission_ext_c
	(wake dialog_ext_c_ini)
	(wake ext_c_setup)
	(ai_erase c_bridge)
	(wake enc_ext_c)
	(wake enc_ext_c_zig_bottom)
	(wake ini_ext_c_turrets)
	(wake ini_zig_bottom_turrets)
	(wake ini_ext_c_ghosts)
	(wake ini_ext_c_migration)
;	(wake general_save)

	(sleep_until (volume_test_objects zig_trigger_a (players)))
	(wake general_save)
	
	(sleep_until (volume_test_objects zig_trigger_b (players)))
	(wake enc_ext_c_zig_top)
	(wake general_save)
	(wake ini_zig_top_turrets)
	(wake ini_control_turrets)
	)

;========== kill all continuous scripts ==========

(script static void kill_all_continuous
	(sleep -1 ini_a_bridge_turret_near)
	(sleep -1 ini_a_bridge_turret_far)
	(sleep -1 ini_crevasse_turret_a)
	(sleep -1 ini_crevasse_turret_b)
	(sleep -1 ini_crevasse_turret_c)
	(sleep -1 ini_ext_c_ghosts)
	(sleep -1 ini_ext_c_turrets)
	(sleep -1 ini_zig_bottom_turrets)
	(sleep -1 ini_zig_top_turrets)
	(sleep -1 ini_control_turrets)
	(sleep -1 ext_a_migration)
	(sleep -1 ini_jeep_exit_a)
	(sleep -1 ini_tank_exit_a)
	(sleep -1 ini_jeep_exit_b)
	(sleep -1 ini_tank_exit_b)
	(sleep -1 general_save)
	)
	
;========== Teleport Scripts ==========

(script startup mission_b40
   (if (mcc_mission_segment "cine1_intro") (sleep 1))              
   
	(fade_out 0 0 0 0)
	(kill_all_continuous)
	(cls)
	(switch_bsp 3)

;	(if debug (print "yummy!"))
;	(if debug (print "tuna?"))
	
	(ai_allegiance player human)
	(ai_allegiance human player)

	(wake mission_insertion_a)
	(sleep 1)
	(wake title_intro)
	(cutscene_insertion_a)
	(sleep 1)
	(wake mission_insertion_b)
	(sleep 1)
	(cutscene_insertion_b)
	(game_save_totally_unsafe)
	
   (mcc_mission_segment "01_start")
   
;<JLG>
	(if (and (not (game_is_cooperative))
		    (= normal (game_difficulty_get)))
	    (wake help_tank))
	    
	(if (and (not (game_is_cooperative))
		    (= normal (game_difficulty_get)))
	    (wake help_banshee))
	    
	(wake title_thunder)
	(wake title_control)
;</JLG>

	(wake game_win_script)
	(wake save_script)
;	(ai_conversation_advance insertion)
	
	(sleep_until (volume_test_objects a1_trigger (players)) 10)
	(wake mission_a1)
   (mcc_mission_segment "02_a1")
	
	(sleep_until (volume_test_objects a_bridge_trigger (players)) 10)
	(wake mission_a_bridge)
   (mcc_mission_segment "03_a_bridge")

	(sleep_until (volume_test_objects a2_top_trigger (players)) 10)
	(wake mission_a2)
   (mcc_mission_segment "04_a2")
	
	(sleep_until (volume_test_objects ext_a_trigger (players)) 10)
	(wake mission_ext_a)
   (mcc_mission_segment "05_ext_a")

	(sleep_until (volume_test_objects crevasse_trigger (players)) 10)
	(wake mission_crevasse)
   (mcc_mission_segment "06_crevasse")
	
	(sleep_until (volume_test_objects ext_b_trigger (players)) 10)
	(wake mission_ext_b)
   (mcc_mission_segment "07_ext_b")
	
	(sleep_until (volume_test_objects b3_bottom_trigger (players)) 10)
	(wake mission_b3)
   (mcc_mission_segment "08_b3")

	(sleep_until (volume_test_objects b3_bridge_trigger (players)) 10)
	(wake mission_b3_bridge)
   (mcc_mission_segment "09_b3_bridge")

	(sleep_until (volume_test_objects b5_a_trigger (players)) 10)
	(wake mission_b5)
   (mcc_mission_segment "10_b5")

	(sleep_until (volume_test_objects ext_c_trigger_a (players)) 10)
	(wake mission_c_bridge)
   (mcc_mission_segment "11_c_bridge")
	
	(sleep_until (volume_test_objects c1_top_trigger (players)) 10)
	(wake mission_c1)
   (mcc_mission_segment "12_c1")

	(sleep_until (volume_test_objects ext_c_trigger_b (players)) 10)
	(wake mission_ext_c)
   (mcc_mission_segment "13_ext_c")
	
	)

