;*********************************************************************;
;General
;*********************************************************************;
(global boolean g_play_cinematics TRUE)
(global boolean editor FALSE)
(global short testNum 0)
(global short testNum02 0)
(global short wave 1)
(global short waveMax 0)
(global vehicle testVehicle NONE)
(global vehicle testVehicle00 NONE)
(global vehicle testVehicle01 NONE)
(global vehicle testVehicle02 NONE)
(global vehicle testVehicle03 NONE)
(global ai testAIsquad00 NONE)
(global ai testAIsquad01 NONE)
(global ai testAIsquad02 NONE)
(global ai testAIsquad03 NONE)
(global ai testAI NONE)
(global ai testAI02 NONE)
(global unit testUnit NONE)
(global boolean g_tower1 FALSE)
(global boolean g_tower3 FALSE)
(global boolean g_truthdead FALSE)
(global boolean g_celltaken FALSE)
(global boolean g_cinematic_running FALSE)

; insertion point index 
(global short g_insertion_index 0)

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)

;Used to make an AI pause and do nothing
(script command_script pause_forever
	(sleep_forever)
)

;Used to make AI move but not shoot
(script command_script move_cs
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep_forever)
)

;*********************************************************************;
;Achievement Check Scripts
;*********************************************************************;

(script continuous achieveiment_som
	(if (= (volume_test_object vol_som (player0)) TRUE)
		(begin
			(print "Player 0 has arrived at som easter egg")
			(achievement_grant_to_player 0 _achievement_ace_siege_of_the_madrigal)
		)
	)
	
	(if (= (volume_test_object vol_som (player1)) TRUE)
		(begin
			(print "Player 1 has arrived at som easter egg")
			(achievement_grant_to_player 1 _achievement_ace_siege_of_the_madrigal)
		)
	)
	
	(if (= (volume_test_object vol_som (player2)) TRUE)
		(begin
			(print "Player 2 has arrived at som easter egg")
			(achievement_grant_to_player 2 _achievement_ace_siege_of_the_madrigal)
		)
	)
	
	(if (= (volume_test_object vol_som (player3)) TRUE)
		(begin
			(print "Player 3 has arrived at som easter egg")
			(achievement_grant_to_player 3 _achievement_ace_siege_of_the_madrigal)
		)
	)
)
; 

;*********************************************************************;
;Intro Script
;*********************************************************************;
(script dormant beach_pelican_setup
	(object_teleport (player0) teleport_init_player0)
	(object_teleport (player1) teleport_init_player1)
	(object_teleport (player2) teleport_init_player2)
	(object_teleport (player3) teleport_init_player3)
	(if (= (game_is_cooperative) FALSE)
		(begin
			(set testNum 1)
			(ai_place beach_pelican 1)
		)
		(begin
			(set testNum (game_coop_player_count))
			(ai_place beach_pelican 2)
		)
	)
	(cs_run_command_script beach_pelican/driver01 pause_forever)
	(cs_run_command_script beach_pelican/driver02 pause_forever)
	(set testNum (- testNum 1))
	(ai_place beach_inf_marines (- 3 testNum))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_l05" (player0))
	
	(if (= (game_is_cooperative) FALSE)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_r05" (list_get (ai_actors beach_inf_marines) 0))
	)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_r04" (list_get (ai_actors beach_inf_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_l04" (list_get (ai_actors beach_inf_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_r03" (list_get (ai_actors beach_inf_marines) 0))
	(sleep 1)
	(if (= (game_is_cooperative) TRUE)
		(begin
			(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_r05" (player1))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_r05" (player2))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_l05" (player3))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_r04" (list_get (ai_actors beach_inf_marines) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_l04" (list_get (ai_actors beach_inf_marines) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_r03" (list_get (ai_actors beach_inf_marines) 0))
			(sleep 1)
		)
	)
	
	(sleep 30)
	(flock_create "path_a_pelican")
	(flock_create "cell_b_phantoms_elite")
	(cinematic_fade_to_gameplay)
	(sleep 20)
	
	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))
	(unit_exit_vehicle (player2))
	(unit_exit_vehicle (player3))
	(wake md_beach_pile_out)
	(flock_stop "beach_pelicans01")
	(vehicle_unload (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_r05")
	(sleep (random_range 5 15))
	(vehicle_unload (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_r04")
	(sleep (random_range 5 15))
	(vehicle_unload (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_l04")
	(sleep (random_range 5 15))
	(vehicle_unload (ai_vehicle_get_from_starting_location beach_pelican/driver01) "pelican_p_r03")
	(sleep (random_range 5 15))
	(vehicle_unload (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_r04")
	(vehicle_unload (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_l04")
	(vehicle_unload (ai_vehicle_get_from_starting_location beach_pelican/driver02) "pelican_p_r03")
	(vs_force_combat_status beach_inf_marines ai_combat_status_active)
	(ai_disregard (ai_actors beach_pelican) TRUE)
	
	(sleep 30)
	(game_save_immediate)
	(sleep 80)
	(cs_run_command_script beach_pelican/driver01 beach_pelican_exit_cs)
	(ai_grenades TRUE)
	(if (= (game_is_cooperative) TRUE)
		(begin
			(sleep (random_range 70 90))
			(cs_run_command_script beach_pelican/driver02 beach_pelican02_exit_cs)
		)
	)
)

(script command_script beach_pelican_exit_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	;(cs_enable_targeting TRUE)
	;(cs_vehicle_speed 1)
	(cs_fly_to beach_pts/pelican01_exit_init)
	(cs_fly_by beach_pts/pelican01 8)
	;(cs_vehicle_boost TRUE)
	(cs_fly_by beach_pts/pelican02 10)
	(cs_vehicle_boost TRUE)
	(cs_fly_to beach_pts/pelican03 8)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script beach_pelican02_exit_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_fly_to beach_pts/pelican02_exit_init)
	(cs_fly_by beach_pts/pelican01 8)
	;(cs_vehicle_boost TRUE)
	(cs_fly_by beach_pts/pelican02 10)
	(cs_vehicle_boost TRUE)
	(cs_fly_to beach_pts/pelican03 8)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script aa_shoot_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (any_players_in_vehicle)))
	(print "AA leashed")
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)
	;(cs_enable_moving TRUE)
	(sleep_until
		(begin
			(begin_random
				(cs_go_to beach_pts/AA 1)
				(cs_shoot_point TRUE beach_pts/aa_shoot01)
				(cs_shoot_point TRUE beach_pts/aa_shoot02)
				(cs_shoot_point TRUE beach_pts/aa_shoot03)
			)
			(and (<= (ai_task_count beach_cov_obj/air_gate) 0) (<= (ai_task_count beach_cov_obj/inf_gate) 2))
		)
	)
	(print "AA unleashed")
)

(script dormant spawn_beach_cov
	(sleep_until (= (current_zone_set_fully_active) 1) 1)
	(print "spawning beach cov")
	(flock_create "beach_banshees01")
	(flock_create "beach_banshees01")
	(flock_create "beach_hornets01")
	(flock_create "beach_banshees02")
	(flock_create "beach_hornets02")
	(ai_place beach_cov_aa)
	(object_set_persistent (ai_vehicle_get_from_starting_location beach_cov_aa/driver01) TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location beach_cov_aa/driver01) "wraith_g" TRUE)
	;(cs_run_command_script beach_cov_aa/driver01 aa_shoot_cs)
	(ai_place beach_inf_cov01_lead)
	(ai_place beach_inf_cov02)
	(ai_place beach_inf_cov03)
	(ai_place beach_cov_turrets02)
)

(script dormant Intro_Start
	(print "Segment:Cinematic:Intro")
	(data_mine_set_mission_segment "100la_citadel_arrival")
	;(prepare_to_switch_to_zone_set set_beach)
	(switch_zone_set set_beach_cin)
	(sleep 30)
	
	(cinematic_snap_to_black)
	(object_set_function_variable crater_shield shader 1 0)
	(wake spawn_beach_cov)
	(ai_grenades FALSE)
	(if g_play_cinematics
		(begin
			(if (cinematic_skip_start)
				(begin
					(print "100la_citadel_arrival")
					
					(100la_citadel_arrival)
				)
			)
			(cinematic_skip_stop)
		)
		;else
		(begin
			(print "skipping '100la_citadel_arrival' cinematic")
		)
	)
	
	; cleanup cinematic scripts 
	(100la_citadel_arrival_cleanup)
	(sound_class_set_gain amb 1 60)

	(print "Segment:Beach")
	(data_mine_set_mission_segment "100_10_beach")
	
	;(switch_zone_set set_beach)
	(object_hide (player0) FALSE)
	(object_hide (player1) FALSE)
	(object_hide (player2) FALSE)
	(object_hide (player3) FALSE)
	(sleep 1)
	
	(ai_magically_see_object lock_a02_cov_obj (player0))
	;(ai_disregard (ai_actors beach_cov_aa) TRUE)
	(wake objective_1_set)
	(wake beach_pelican_setup)
	(object_create cov_capital_ship)
	(object_create beach_hog01)
	(object_create beach_hog02)
)

;*********************************************************************;
;Beach Landing Script
;*********************************************************************;
(script command_script beach_banshees_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	;(sleep 200)
	(cs_enable_moving TRUE)
	(sleep_forever)
)

(script dormant beach_saves01
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players vol_beach_saves)
				(game_safe_to_save))
			5)
		(game_save)
		(sleep (* 30 90))
		FALSE
		)
	)
)

(script dormant Beach_Start
	(sleep_until (>= (ai_living_count beach_pelican) 1))
	(wake beach_saves01)
	(if 
		(or
			(= (game_difficulty_get) easy)
			(= (game_difficulty_get) normal)
		)
		(object_create beach_laser)
	)
	(ai_set_targeting_group beach_cov_aa 1)
	
	(sleep_until (or (<= (ai_task_count beach_cov_obj/inf_init_gate) 5) (volume_test_players vol_beach_area02_start)) 5)
	(print "beach_inf_cov04")
	(ai_place beach_inf_cov04)
	(ai_place beach_inf_cov04b)
	(sleep 1)
	(ai_place beach_inf_cov05)
	(ai_place beach_inf_cov06)
	
	;(sleep_until (= (current_zone_set_fully_active) 2) 5)
	(sleep_until (volume_test_players vol_beach_area02_start) 5)
	(flock_stop "beach_banshees01")
	(flock_stop "beach_banshees02")
	(ai_place beach_hornet)
	(ai_place beach_banshee_cov)
	(cs_run_command_script beach_banshee_cov beach_banshees_init_cs)
	(wake beach_air_fight)
	(sleep 120)
	(cs_run_command_script beach_banshee_cov abort)
)

(script dormant Beach_cleanup
	(sleep_forever beach_saves01)
	(ai_disposable beach_cov_obj TRUE)
	(sleep_forever Beach_Start)
)

;*********************************************************************;
;PathA Script
;*********************************************************************;
(script dormant Beach_hog_drop
	(ai_place patha_pelican)
	(flock_delete "path_a_pelican")
	(ai_place patha_hog 1)
	(set testNum (- 3 (ai_living_count beach_inf_marines)))
	(ai_place patha_marines testNum)
	(sleep 1)
	(set testNum 0)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_lc" (ai_vehicle_get_from_starting_location patha_hog/warthog01))
	;(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_lc" (ai_vehicle_get_from_starting_location patha_goose/goose01))
	;(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver02) "pelican_sc02" (ai_vehicle_get_from_starting_location patha_goose/goose02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_r05" (list_get (ai_actors patha_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_l05" (list_get (ai_actors patha_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_r04" (list_get (ai_actors patha_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_l04" (list_get (ai_actors patha_marines) 0))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_pelican/driver01) TRUE)
	;(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_pelican/driver02) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_hog/warthog01) TRUE)
	;(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_goose/goose01) TRUE)
	(cs_run_command_script  patha_pelican/driver01 PathA_pelican01_cs)
	;(cs_run_command_script  patha_pelican/driver02 PathA_pelican02_cs)
	(sleep_until 
		(or
			(any_players_in_vehicle)
			;(volume_test_players vol_patha_choppers)
			FALSE
		)
	)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_hog/warthog01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_goose/goose01) FALSE)
	(ai_enter_squad_vehicles all_allies)
)

(script command_script PathA_pelican01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_ignore_obstacles TRUE)
	(cs_fly_by patha_pts/pelican01a 12)
	(cs_vehicle_boost TRUE)
	(cs_fly_by patha_pts/pelican01a02 8)
	(cs_vehicle_boost FALSE)
	(cs_fly_by patha_pts/pelican01a03 8)
	(cs_face TRUE patha_pts/pelican01_face)
	(cs_fly_to patha_pts/pelican01b 1)
	(cs_vehicle_speed .4)
	(ai_place patha_goose)
	(ai_place patha_odst)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_goose/goose01) "mongoose_d" (list_get (ai_actors patha_odst) 0))
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location patha_goose/goose01) "mongoose_p" TRUE)
	(cs_run_command_script (ai_get_driver patha_goose/goose01) pause_forever)
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_fly_to patha_pts/pelican01c 1)
	(cs_face FALSE patha_pts/pelican01_face)
	(sleep 10)
	(cs_run_command_script (ai_get_driver patha_goose/goose01) PathA_goose_cs)
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_lc")
	(vehicle_unload (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_r05")
	(sleep (random_range 0 20))
	(vehicle_unload (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_l05")
	(sleep (random_range 0 10))
	(vehicle_unload (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_r04")
	(sleep (random_range 0 20))
	(vehicle_unload (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_l04")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location patha_goose/goose01) "mongoose_d" TRUE)
	(sleep 60)
	;(vs_vehicle_speed_instantaneous (ai_get_driver patha_goose/goose01) 1)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location patha_hog/warthog01) "warthog_g" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location patha_hog/warthog01) "warthog_p" FALSE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location patha_goose/goose01) "mongoose_p" FALSE)
	(game_save)
	(ai_enter_squad_vehicles all_allies)
	;(cs_vehicle_speed 1)
	(cs_fly_to patha_pts/pelican01e 1)
	;(sleep_forever)
	(sleep_until 
		(and
			(volume_test_players vol_beach_banshee_fight)
			(any_players_in_vehicle)
		)
	)
	(cs_fly_by beach_pts/pelican01 8)
	(cs_fly_by beach_pts/pelican02 10)
	(cs_vehicle_boost TRUE)
	(cs_fly_to beach_pts/pelican03)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script PathA_goose_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	(cs_vehicle_speed_instantaneous 5)
	;(sleep 60)
	(cs_go_to patha_pts/goose01 1)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location patha_goose/goose01) "mongoose_p" FALSE)
	(cs_vehicle_speed .5)
	(cs_go_to patha_pts/goose02 1)
	(wake PathA_goose_reserve)
)

(script dormant PathA_goose_reserve
	(if (not (any_players_in_vehicle))
		(begin
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location patha_goose/goose01) "mongoose_d" TRUE)
			(vehicle_unload (ai_vehicle_get_from_starting_location patha_goose/goose01) "")
			(sleep 30)
			(sleep_until (any_players_in_vehicle) 5)
		)
	)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_goose/goose01) FALSE)
	(sleep 1)
	(ai_enter_squad_vehicles all_allies)
)

(script static void test_path_a_pelican
	(ai_erase_all)
	(ai_place patha_pelican)
	(ai_place patha_hog 1)
	(set testNum (- 3 (ai_living_count beach_inf_marines)))
	(ai_place patha_marines testNum)
	(sleep 1)
	(set testNum 0)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_lc" (ai_vehicle_get_from_starting_location patha_hog/warthog01))
	;(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_lc" (ai_vehicle_get_from_starting_location patha_goose/goose01))
	;(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver02) "pelican_sc02" (ai_vehicle_get_from_starting_location patha_goose/goose02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_r05" (list_get (ai_actors patha_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_l05" (list_get (ai_actors patha_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_r04" (list_get (ai_actors patha_marines) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_pelican/driver01) "pelican_p_l04" (list_get (ai_actors patha_marines) 0))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_pelican/driver01) TRUE)
	;(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_pelican/driver02) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_hog/warthog01) TRUE)
	;(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_goose/goose01) TRUE)
	(cs_run_command_script  patha_pelican/driver01 PathA_pelican01_cs)
)

(script dormant beach_air_fight
	(ai_set_targeting_group beach_banshee_cov 1)
	(ai_set_targeting_group beach_hornet 1)
	(ai_prefer_target_ai beach_hornet beach_banshee_cov TRUE)
	(sleep_until (<= (ai_living_count beach_inf_cov04/beach_chief) 0))
	;once cheiftain is dead, let marines target AA wraith
	(ai_set_targeting_group beach_hornet -1)
	(ai_set_targeting_group beach_banshee_cov -1)
	(ai_set_targeting_group beach_cov_aa -1)
	(ai_prefer_target_ai beach_cov_aa beach_hornet TRUE)
	(ai_prefer_target_ai beach_hornet beach_cov_aa TRUE)
	(if
		(or
			;AI ignore banshees on easy and normal
			(= (game_difficulty_get) easy)
			(= (game_difficulty_get) normal)
		)
		(begin
			(sleep_until (volume_test_players vol_beach_banshee_fight))
			(ai_set_targeting_group beach_banshee_cov 1)
			(ai_set_targeting_group beach_hornet 1)
		)
	)
)

(script dormant path_a_banshee_respawn
	(set testNum02 (- 2 (ai_task_count beach_cov_obj/banshee_gate)))
	(sleep 1)
	(ai_place beach_banshee_cov testnum02)
	(sleep 1)
	(set testNum02 0)
)

(script dormant path_a_game_save01
	(sleep_until 
		(and
			(volume_test_players vol_beach_banshee_fight)
			(any_players_in_vehicle)
		)
	5)
	(game_save)
)

(script dormant PathA_Start	
	(sleep_until (and
		(<= (ai_living_count beach_inf_cov04/beach_chief) 0)
		(<= (ai_task_count beach_cov_obj/wraith_gate) 0)
		(<= (ai_task_count beach_cov_obj/inf_gate) 2))
	)
	(sleep_until (<= (ai_task_count beach_cov_obj/inf_gate) 0) 30 (* 30 10))
	(if
		(or
			;spawn more banshees on heroic/legendary
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		(wake path_a_banshee_respawn)
	)
	;spawn these guys to set banshee task
	(ai_place path_a_cov01)
	(sleep 60)
	(wake md_beach_beachhead_secure)
	(set g_celltaken TRUE)
	;(wake beach_nav_exit)
	(game_save)
	(sleep 60)
	(wake Beach_hog_drop)
	(wake path_a_game_save01)
	(add_recycling_volume beach_pelican_drop_garbage 0 10)
	(ai_disregard (ai_actors beach_banshee_cov) TRUE)
	(sleep_until (volume_test_players vol_beach_banshee_fight) 5)
	(print "Segment:PathA")
	(data_mine_set_mission_segment "100_20_path_a")
	(ai_disregard (ai_actors beach_banshee_cov) FALSE)
	(sleep_until (volume_test_players vol_patha_choppers) 5)
	(ai_place patha_choppers01)
	(wake path_a_nav_exit)
	(sleep_until 
		(or
			(<= (ai_task_count beach_cov_obj/beach_taken_gate) 0)
			(volume_test_players vol_patha_flyby)
		)
	)
	(sleep_forever path_a_game_save01)
	(game_save)
	(sleep (random_range 60 100))
	(wake md_beach_joh_update)
	(sleep_until (<= (ai_task_count beach_cov_obj/beach_taken_gate) 0))
	(ai_disregard (ai_actors beach_banshee_cov) TRUE)
)

;*********************************************************************;
;Cell A Script
;*********************************************************************;
(script command_script cell_aa_shoot_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_looking FALSE)
	;(cs_enable_targeting FALSE)
	;(cs_enable_moving TRUE)
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE cell_a_pts/aa_shoot01)
				(cs_shoot_point TRUE cell_a_pts/aa_shoot02)
				(cs_shoot_point TRUE cell_a_pts/aa_shoot03)
			)
			FALSE
		)
	)
)

(script command_script cell_a_phantom_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to cell_a_pts/phantom_exit01)
	(cs_fly_to cell_a_pts/phantom_exit02)
	(cs_fly_to cell_a_pts/phantom_exit03)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cell_a_banshees
	(if (not (volume_test_object vol_cell_a_bansheespawn (ai_vehicle_get ai_current_actor)))
		(cs_run_command_script ai_current_actor abort)
	)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(sleep 120)
	(cs_vehicle_boost TRUE)
	(sleep (random_range 300 350))
	(cs_vehicle_boost FALSE)
)

(script command_script cell_a_wraith
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (volume_test_players vol_cell_a_center))
)

(script command_script cell_a_turrets
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep_forever)
)

(script dormant pelican_arrival
	(sleep_until (<= (ai_task_count cell_a_cov_obj/ground_vehicles) 0))
	(print "pelican inbound")
	(set g_celltaken TRUE)
	(ai_place cella_pelicans)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cella_pelicans/driver01) TRUE)
	(cs_run_command_script cella_pelicans/driver01 pelican_arrival_cs)
	(object_create cell_a_rack)
	(objects_attach (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_sc_01" cell_a_rack "pin")
	(object_create cell_a_capsule01)
	(objects_attach cell_a_rack "rack01" cell_a_capsule01 "pelican_attach")
	(object_create cell_a_capsule02)
	(objects_attach cell_a_rack "rack02" cell_a_capsule02 "pelican_attach")
	(object_create cell_a_capsule03)
	(objects_attach cell_a_rack "rack03" cell_a_capsule03 "pelican_attach")
	(object_create cell_a_capsule04)
	(objects_attach cell_a_rack "rack04" cell_a_capsule04 "pelican_attach")
)

(script command_script pelican_arrival_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by cell_a_pts/pelican01a 6)
	(cs_vehicle_boost FALSE)
	;(cs_fly_by cell_a_pts/pelican01b)
	(cs_fly_to cell_a_pts/pelican01c 2)
	;(cs_enable_looking TRUE)
	;(cs_enable_targeting TRUE)
	(set testNum (- 4 (ai_task_count cell_a_marines_obj/ground_units_gate)))
	(if 
		(and
			;seeing 1 guy jump out is dumb
			(>= testNum 2)
			(or
				;don't spawn more guys on heroic/legendary
				(= (game_difficulty_get) easy)
				(= (game_difficulty_get) normal)
			)
		)
		;drop more men:
		(begin
			(print "dropping more marines")
			(ai_place cella_marines testNum)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_r05" (list_get (ai_actors cella_marines) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_l05" (list_get (ai_actors cella_marines) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_r04" (list_get (ai_actors cella_marines) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_l04" (list_get (ai_actors cella_marines) 0))
			(cs_face TRUE cell_a_pts/pelican01_face01)
			(cs_fly_to cell_a_pts/pelican01d 1)
			(unit_open (ai_vehicle_get ai_current_actor))
			(sleep 60)
			(vehicle_unload (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_r05")
			(vehicle_unload (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_l05")
			(vehicle_unload (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_r04")
			(vehicle_unload (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_p_l04")
		)
		(begin
			(cs_face TRUE cell_a_pts/pelican01_face01)
			(cs_fly_to cell_a_pts/pelican01d 2)
			(sleep 80)
		)
	)
	(begin_random
		(begin
			(objects_detach cell_a_rack cell_a_capsule01)
			(sleep (random_range 0 5))
		)
		(begin
			(objects_detach cell_a_rack cell_a_capsule02)
			(sleep (random_range 0 5))
		)
		(begin
			(objects_detach cell_a_rack cell_a_capsule03)
			(sleep (random_range 0 5))
		)
		(begin
			(objects_detach cell_a_rack cell_a_capsule04)
			(sleep (random_range 0 5))
		)
	)
	(sleep 20)
	(object_damage_damage_section cell_a_capsule01 "indirect" 1)
	(object_damage_damage_section cell_a_capsule02 "indirect" 1)
	(object_damage_damage_section cell_a_capsule03 "indirect" 1)
	(object_damage_damage_section cell_a_capsule04 "indirect" 1)
	(sleep 30)
	(unit_close (ai_vehicle_get ai_current_actor))
	(set testNum 0)
	(cs_face FALSE cell_a_pts/pelican01_face01)
	(cs_fly_to cell_a_pts/pelican01b 2)
	(cs_fly_by cell_a_pts/pelican01a 6)
	(cs_vehicle_boost TRUE)
	(cs_fly_to cell_a_pts/pelican01_exit 6)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant cell_a_banshee_spawner
	(sleep_until
		(begin
			(ai_place cella_cov01_banshees01)
			(cs_run_command_script cella_cov01_banshees01 cell_a_banshees)
			(sleep_until (<= (ai_task_count cell_a_cov_obj/banshees) 2))
			FALSE
		)
	)
)

(script command_script cell_a_dismount_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(if (vehicle_test_seat_list (ai_vehicle_get_from_starting_location patha_hog/warthog01) "warthog_g" (ai_get_object ai_current_actor))
		(sleep_until (<= (ai_living_count cell_a_cov_obj) 0))
	)
	(sleep_until (volume_test_object vol_cell_a_lockstart (ai_get_object ai_current_actor)))
	(print "ai exiting vehicle")
	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) TRUE)
	(ai_vehicle_exit ai_current_actor)
)

(script dormant cell_a_catchup
	(sleep_until 
		(and
			(not (objects_can_see_flag (players) flag_cell_a_catchup 30))
			(volume_test_players_all vol_cell_a_center)
		)
	)
	(if 
		(and
			(not (volume_test_objects vol_cell_a_all (ai_vehicle_get_from_starting_location patha_hog/warthog01)))
			(>= (ai_living_count patha_hog) 1)
		)
		(object_teleport (ai_vehicle_get_from_starting_location patha_hog/warthog01) flag_cell_a_catchup)
		;(cs_run_command_script (ai_get_driver patha_hog/warthog01) cell_a_catchup_cs)
	)
	(if 
		(and
			(not (volume_test_objects vol_cell_a_all (ai_vehicle_get_from_starting_location patha_goose/goose01)))
			(>= (ai_living_count patha_goose) 1)
		)
		(object_teleport (ai_vehicle_get_from_starting_location patha_goose/goose01) flag_cell_a_catchup)
		;(cs_run_command_script (ai_get_driver  patha_goose/goose01) cell_a_catchup_cs)
	)
)
;*
(script command_script cell_a_catchup_cs
	(print "vehicle playing catchup")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to cell_a_pts/catchup01)
	(cs_go_to cell_a_pts/catchup02)
)
*;

(script command_script cell_a_catchup_hog
	(print "vehicle playing catchup")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to cell_a_pts/catchup01)
	(cs_go_to cell_a_pts/catchup02)
)

(script dormant cell_a_mauler_spawn
	(sleep_until
		(or
			(volume_test_players vol_cell_a_maulter_spawn)
			(<= (object_get_health (ai_vehicle_get_from_starting_location cella_cov01_wraiths01/driver01)) 0)
			;(<= (ai_living_count cella_cov01_wraiths01) 0)
		)
	1)
	(ai_place cella_cov01_maulers01)
	(cs_run_command_script cella_cov01_maulers01/driver01 cell_a_mauler_intro_cs)
	(cs_run_command_script cella_cov01_maulers01/driver02 cell_a_mauler_intro_cs)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cella_cov01_maulers01/driver01) "mauler_p_l" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cella_cov01_maulers01/driver01) "mauler_p_r" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cella_cov01_maulers01/driver02) "mauler_p_l" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cella_cov01_maulers01/driver02) "mauler_p_r" TRUE)
)

(script command_script cell_a_mauler_intro_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	(cs_abort_on_damage TRUE)
	(sleep_until (volume_test_players vol_cell_a_center))
	(cs_go_to cell_a_pts/mauler01)
)

(script dormant cell_a_ghost_spawn
	(ai_place cella_cov01_ghosts01)
	(sleep 1)
	(ai_place cella_cov01_ghosts02)
	(ai_place cella_cov01_ghost_drivers)
	(cs_run_command_script cella_cov01_ghosts01 pause_forever)
	(cs_run_command_script cella_cov01_ghost_drivers pause_forever)
	(sleep_until  (volume_test_players vol_cell_a_start) 1)
	(cs_run_command_script cella_cov01_ghosts01 abort)
	(cs_run_command_script cella_cov01_ghost_drivers abort)
	(sleep 1)
	(ai_set_blind cella_cov01_ghost_drivers/driver01 TRUE)
	(ai_set_deaf cella_cov01_ghost_drivers/driver01 TRUE)
	;(cs_run_command_script cella_cov01_ghosts02/driver01 pause_forever)
	(ai_vehicle_enter cella_cov01_ghost_drivers/driver01 (ai_vehicle_get_from_starting_location cella_cov01_ghosts02/driver01) "ghost_d")
	(sleep 1)
	(ai_enter_squad_vehicles cella_ghosts)
	(sleep 150)
	(ai_set_blind cella_cov01_ghost_drivers/driver01 FALSE)
	(ai_set_deaf cella_cov01_ghost_drivers/driver01 FALSE)
	;(cs_run_command_script cella_cov01_ghosts02/driver01 abort)
)

(script static void test_cella_maulers
	(undumb)
	(ai_place cella_cov01_maulers01)
	(cs_run_command_script cella_cov01_maulers01/driver01 cell_a_mauler_intro_cs)
	(cs_run_command_script cella_cov01_maulers01/driver02 cell_a_mauler_intro_cs)
)

(script dormant cellA_saves01
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players vol_cell_a_saves01)
				(game_safe_to_save))
			5)
		(game_save)
		(sleep (* 30 90))
		FALSE
		)
	)
)

(script dormant CellA_Start
	;(sleep_until (volume_test_players vol_cell_a_init))
	(print "Segment:CellA")
	(data_mine_set_mission_segment "100_30_cell_a")
	(add_recycling_volume beach_garbage 0 0)
	(wake cellA_saves01)
	(flock_create "cella_banshees")
	(flock_create "cella_hornets")
	(flock_create "cella_fish01")
	(flock_create "cella_fish02")
	(flock_create "cella_fish03")

	(sleep 1)
	(wake Beach_cleanup)
	(game_save)
	(wake md_cella_in_sight)
	;if player lost the hog, give them a flak cannon crate, else spawn emptry crate
	(if (<= (object_get_health (ai_vehicle_get_from_starting_location patha_hog/warthog01)) 0)
		(object_create cella_flak_crate)
		(object_create cella_noflak_crate)
	)
	(ai_place cella_cov01_wraiths01)
	(sleep 1)
	(wake cell_a_ghost_spawn)
	;only migrate allies if they took the beach, otherwise dispose of allies
	(if g_celltaken
		(ai_set_objective ground_allies cell_a_marines_obj)
		(ai_erase_inactive beach_marines_obj 30)
	)
	
	(sleep_until (volume_test_players vol_cell_a_start))
	(set g_celltaken FALSE)
	(ai_place cella_inf_cov03)
	(object_set_persistent (ai_vehicle_get_from_starting_location cella_cov01_wraiths01/driver01) TRUE)
	(ai_prefer_target_ai cell_a_marines_obj/not_player_vehicle_gate cella_vehicles TRUE)
	(wake cell_a_mauler_spawn)
	
	(ai_place cella_cov_shades01)
	(ai_place cella_cov_shades03)
	(if
		(or
			;spawn more banshees on heroic/legendary
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		(begin
			(ai_place cella_cov_shades02)
			;(ai_place cella_cov_sniper)
		)
	)

	(sleep_until (or (volume_test_players vol_cell_a_pathend)(volume_test_players vol_cell_a_center)))
	(if (= (game_is_cooperative) FALSE)
		(wake cell_a_catchup)
	)
	(wake pelican_arrival)
	(ai_place cella_inf_cov01)
	(sleep 1)
	(ai_place cella_inf_cov02)
	(sleep_until 
		(or
			(<= (ai_living_count cell_a_cov_obj) 0)
			(and
				(<= (ai_task_count cell_a_cov_obj/low_gate) 2)
				(<= (ai_task_count cell_a_cov_obj/inf_a_gate) 0)
				(volume_test_players vol_cell_a_tunnel)
			)
		)
	)
	(wake cell_a_nav_exit)
	
	;music
	(set g_music_100_01 FALSE)
	(sleep (random_range 30 40))
	(wake md_cella_perimeter_secure)
	
	(sleep_until 
		(and
			(volume_test_players vol_cell_a_lockstart)
			(not (any_players_in_vehicle))
		)
	)
	(ai_prefer_target_ai cell_a_marines_obj/not_player_vehicle_gate cella_vehicles FALSE)
	(game_save)
	(sleep (random_range 30 40))
	(print "exiting vehicles")
	(ai_vehicle_exit ground_allies)
	(sleep 30)
	(sleep_until (volume_test_players vol_lock_a01_migrate) 5)
	(print "exiting vehicles")
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_goose/goose01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_hog/warthog01) TRUE)
	(ai_vehicle_exit ground_allies)
	;(ai_set_objective cell_a_marines_obj/advance_inf lock_a_marines_obj)
	(ai_set_objective ground_allies lock_a_marines_obj)
)

(script dormant CellA_cleanup
	(sleep_forever cell_a_banshee_spawner)
	(sleep_forever pelican_arrival)
	(sleep_forever cellA_saves01)
	(sleep_forever cell_a_catchup)
	(ai_disposable cell_a_cov_obj TRUE)
)

;*********************************************************************;
;Lock A Script
;*********************************************************************;
(script command_script fore_repair_for01_cs
	;(cs_enable_looking TRUE)
	;(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(sleep_until
	(begin
		;(sleep 200)
		;(sleep (random_range 60 150))
		;(cs_enable_looking FALSE)
		;(cs_enable_targeting FALSE)
		(cs_enable_moving FALSE)
		(cs_shoot_point TRUE (ai_nearest_point ai_current_actor lock_a_pts))
		(sleep (random_range 60 150))
		(cs_shoot_point FALSE (ai_nearest_point ai_current_actor lock_a_pts))
		;(cs_enable_looking TRUE)
		;(cs_enable_targeting TRUE)
		(cs_enable_moving TRUE)
		FALSE
	)
	)
)

(script dormant lock_a_fore_repair
	(sleep_until
		(or
			;(<= (object_get_health core_for01) 0)
			FALSE
			FALSE
		)
	)
	; set allegiances 
	(ai_allegiance sentinel player)
	(ai_allegiance player sentinel)
	(ai_allegiance sentinel covenant)
	(ai_allegiance covenant sentinel)
	
	(ai_place test_fore)
)

(script dormant lock_a_elevator_setup
	(sleep_until
		(begin
			;sleep until cell_a_int is fully loaded
			(sleep_until (= (current_zone_set_fully_active) 3) 5)
			(object_create tower1_elevator)
			(object_create tower1_elevator_switch)
			(object_create tower1_holo)
			(sleep 1)
			(objects_attach tower1_elevator "citadel_elevator_switch" tower1_elevator_switch "")
			;sleep until player goes back to the beach
			(sleep_until (= (current_zone_set) 2))
			;when player loads new zone set, after beach, if its the waterfront, exit
			(sleep_until (not (= (current_zone_set) 2)))
			(>= (current_zone_set) 5)
		)
	)
	(object_destroy tower1_elevator)
	(object_destroy tower1_elevator_switch)
)

(script dormant lock_a_elevator_control
	(sleep_until
	(begin
		;elevator is ready to go up
		(sleep_until (> (device_get_position tower1_elevator) 0) 1)
		(device_set_power tower1_eleswitch_bottom 0)
		(sleep_until (>= (device_get_position tower1_elevator) 1) 1)
		(device_set_position tower1_elevator_switch .5)
		(sleep_until (>= (device_get_position tower1_elevator_switch) .5) 5)
		;elevator is ready to go down
		
		;if player got left behind, send back down, else lock elevator up top
		(if (not (volume_test_players vol_lock_a_elevator_test))
			(begin
				(device_group_change_only_once_more_set tower1_lift FALSE)
				(sleep 1)
				(device_group_change_only_once_more_set tower1_lift TRUE)
				(device_set_position tower1_elevator 0)
			)
			(sleep_until g_tower1)
		)
		
		(device_group_change_only_once_more_set tower1_lift FALSE)
		(sleep 1)
		(device_group_change_only_once_more_set tower1_lift TRUE)
		(device_set_power tower1_eleswitch_top 1)
		(sleep_until (< (device_get_position tower1_elevator) 1) 1)
		(device_set_power tower1_eleswitch_top 0)
		(sleep_until (<= (device_get_position tower1_elevator) 0) 1)
		(device_set_position tower1_elevator_switch 1)
		(sleep_until (>= (device_get_position tower1_elevator_switch) 1) 5)
		(device_set_position_immediate tower1_elevator_switch 0)
		
		(device_group_change_only_once_more_set tower1_lift FALSE)
		(sleep 1)
		(device_group_change_only_once_more_set tower1_lift TRUE)
		(if (not g_tower1)
			(device_set_power tower1_eleswitch_bottom 1)
		)
		g_tower1
	)
	)
)

(script dormant lock_a_floo01_backup
	(sleep_until (or
		(<= (ai_living_count lock_a_cov_obj) 5)
		(volume_test_players vol_lock_a01b_init))
	)
	(ai_place lock_a01b_cov_init)
)

(script dormant lock_a01_saves
	;*
	(sleep_until (and
		(volume_test_players vol_lock_a01_saves)
		(game_safe_to_save))
	5)
	(game_save)
	*;
	(sleep_until 
		(and
			(<= (ai_living_count lock_a01_cov_core) 0)
			(<= (ai_living_count lock_a01_cov_jacks) 0)
			(<= (ai_living_count lock_a01_cov_jacksnipes) 0)
			(<= (ai_living_count lock_a01_cov_grunts) 0)
			(<= (ai_living_count lock_a01b_cov_init) 0)
		)
	)
	(game_save)
)

(script dormant LockA_Start
	(wake lock_a_elevator_setup)
	(sleep_until (volume_test_players vol_lock_a01_start) 5)
	(print "Segment:LockA")
	(data_mine_set_mission_segment "100_40_lock_a01")
	(wake lock_a_elevator_control)
	;(wake md_locka_arb_breach)
	;wake upper area now, in case player bypasses lower level
	(wake LockA02_start)
	
	(object_create lock_a_terminal)
	(objects_attach lock_a_terminal_base "forerunner_terminal" lock_a_terminal "")
	
	(ai_place lock_a01_cov_core)
	(ai_place lock_a01_cov_jacks)
	(ai_place lock_a01_cov_jacksnipes)
	(ai_place lock_a01_cov_grunts)
	;(ai_place lock_a01_cov_brute)
	(ai_place lock_a01_cov_upper)
	(sleep 30)
	(wake lock_a01_saves)
	(wake lock_a_floo01_backup)
	
	(sleep_until 
		(or
			(volume_test_players vol_lock_a01b_start) 
			(volume_test_players vol_lock_a01_bypass) 
		)
	5)
	(if (volume_test_players vol_lock_a01b_start)
		;if normal route
		(begin
			(ai_place lock_a01b_cov_lead)
			(ai_place lock_a01b_jacks02)
		)
		;if bypass
		(begin
			(ai_place lock_a01b_cov_lead_bypass)
			(ai_place lock_a01b_jacks02_bypass)
		)
	)
	(ai_place lock_a01b_cov01)
	(ai_place lock_a01b_jacks01)
	
	
	(wake CellA_cleanup)
	(wake md_locka_hold_here)
	(sleep_forever lock_a01_saves)
	(wake lock_a02_saves)
	(sleep_until (<= (ai_living_count lock_a_cov_obj) 0))
	(wake lock_a_nav_elevator)
	(game_save)
)

(script dormant locka02_brute_intro
	(ai_place lock_a02_cov_lead)
	(ai_place lock_a02_cov02)
	(cs_run_command_script lock_a02_cov_lead pause_forever)
	(cs_run_command_script lock_a02_cov02 pause_forever)
	(vs_posture_set lock_a02_cov02 "act_kneel_1" FALSE)
	(vs_posture_set lock_a02_cov_lead/bodyguard01 "act_kneel_1" FALSE)
	(vs_posture_set lock_a02_cov_lead/bodyguard02 "act_kneel_1" FALSE)
	(sleep_until (>= (device_get_position tower1_elevator) .75) 10)
	(ai_play_line lock_a02_cov_lead/chief01 100MQ_010)
	(vs_custom_animation lock_a02_cov_lead/chief01 FALSE objects\characters\brute\brute "combat:hammer:cheer" FALSE)
	(sleep 20)
	(cs_run_command_script lock_a02_cov02 abort)
	(ai_magically_see_object lock_a02_cov_obj (player0))
	(sleep 40)
	(cs_run_command_script lock_a02_cov_lead abort)
)

(script dormant lock_a02_saves
	(sleep_until (>= (device_get_position tower1_elevator) .8) 5)
	(game_save)
)

(script dormant LockA02_start
	(sleep_until (volume_test_players vol_lock_a02_init) 5)
	(data_mine_set_mission_segment "100_45_lock_a02")
	(object_destroy cov_capital_ship)
	(sleep_forever capital_ship_control)
	(wake locka02_brute_intro)
	(sleep_until (<= (ai_living_count lock_a02_cov_obj) 0) 5)
	(wake md_locka_prompt01)
	(wake lock_a_nav_button)
	
	(game_save)
	(device_set_power tower1_switch 1)
	(device_set_power tower1_holo 1)
	(sleep_until (> (device_get_position tower1_switch) 0) 1)
	(device_operates_automatically_set tower1_holo FALSE)
	(device_set_position tower1_holo 0)
	
	(wake objective_1_clear)
	(set g_tower1 TRUE)
	(object_destroy (ai_vehicle_get_from_starting_location patha_pelican/driver01))
	(object_destroy (ai_vehicle_get_from_starting_location cella_pelicans/driver01))
	
	;music
	(set g_music_100_03 FALSE)
	(sound_impulse_start sound\device_machines\citadel_tower\tower1_power_down tower1_switch 1)
	
	(wake md_locka_tower1_done)
	(if g_play_cinematics
		(begin
			(perspective_start)
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
			(100pa_first_tower)
			;(object_teleport (player0) pers_towerA_player0)
			;(object_teleport (player1) pers_towerA_player1)
			;(object_teleport (player2) pers_towerA_player2)
			;(object_teleport (player3) pers_towerA_player3)
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
			(perspective_stop)
		)
	)
	
	(wake objective_2_set)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_a_int TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_a_int02 FALSE)
	;to stop hornet guys on the beach
	(zone_set_trigger_volume_enable zone_set:set_beach:01 FALSE)
	;this is to help with coop and allow guys to be up on the ledge
	(zone_set_trigger_volume_enable begin_zone_set:set_beach:backtrack FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_beach:* TRUE)
	(flock_delete "beach_banshees01")
	(flock_delete "beach_hornets01")
	(flock_delete "beach_banshees02")
	(flock_delete "beach_hornets02")
	(flock_delete "cell_b_phantoms_elite")
	(flock_stop "cella_banshees")
	(sleep_forever lock_a02_saves)
	(sleep_forever CellA_Start)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_goose/goose01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_hog/warthog01) FALSE)
	(game_save)
	(if 
		(or
			(not (volume_test_object vol_cell_a_lockstart (ai_vehicle_get_from_starting_location patha_hog/warthog01)))
			(<= (object_get_health (ai_vehicle_get_from_starting_location patha_hog/warthog01)) 0)
		)
		(object_destroy (ai_vehicle_get_from_starting_location patha_hog/warthog01))
	)
	(sleep_until (volume_test_players vol_lock_a03_start))
	(data_mine_set_mission_segment "100_46_lock_a03")
	(wake lock_a_nav_exit)
	(object_create cov_capital_ship)
	;spawn more cov downstairs
	(set testNum (- 9 (ai_living_count lock_a_cov_obj)))
	(sleep 1)
	;don't spawn more than 6 additional guys
	(if (> testNum 6)(set testNum 6))
	(ai_place lock_a03_cov01 testNum)
	(sleep 1)
	
	;spawn more marines downstairs
	(set testNum (- 2 (ai_living_count lock_a_marines_obj)))
	(sleep 1)
	(ai_place lock_a03_marines01 testNum)
	(sleep 1)
	(set testNum 0)

	;*
	(if g_celltaken
		(begin
			;(object_create_folder "scenery_tower1_supplies")
			(object_create_folder "crates_tower1_supplies")
			;(object_create_containing "tower1_supplies")
			(ai_place cell_a_pelican_supply)
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_a_pelican_supply/driver01) TRUE)
			(cs_run_command_script cell_a_pelican_supply/driver01 pause_forever)
			(ai_place cell_a_marine_supply02)
			(ai_place cell_a_marine_supply)
		)
	)
	*;
	(sleep_until (volume_test_players vol_lock_a03_migrate) 5)
	(wake cell_b_hog_goose)
	(ai_set_objective all_allies cell_a_marines_obj)
	
	(sleep_until (= (current_zone_set) 2))
	;don't let players go back
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_a_int:* FALSE)
	(zone_set_trigger_volume_enable zone_set:set_cell_a_int FALSE)
	(device_set_position_immediate lock_a_entry_door 0)
	(device_set_power lock_a_entry_door 0)
	
	(sleep_until (= (current_zone_set_fully_active) 2))
	(print "Segment:Drive to Hornets")
	(data_mine_set_mission_segment "100_47_drive_to_hornets")
	(lock_a_garbage)
	(ai_set_objective ground_allies beach_marines_obj)
	;(ai_set_objective cell_a_marines_obj/hog beach_marines_obj)
	;(ai_set_objective cell_a_marines_obj/head_south beach_marines_obj)
	(sleep 1)
	(wake spawn_air_forces)
	
	(if (= (game_is_cooperative) FALSE)
		(wake cell_b_vehicle_unload00)
		(begin
			(wake cell_b_vehicle_unload00)
			(wake cell_b_vehicle_unload01)
			(wake cell_b_vehicle_unload02)
			(wake cell_b_vehicle_unload03)
		)
	)
	
	(sleep_until (volume_test_players vol_cell_b_hornet_pickup) 5)
	(wake md_cellb_hornets)
	(game_insertion_point_unlock 1)
	(ai_erase_inactive cell_a_marines_obj 30)
)

(script static void lock_a_garbage
	(add_recycling_volume lock_a_garbage 0 0)
)

(script static void beach_cella_locka_garbage
	(add_recycling_volume beach_cella_locka_garbage 0 0)
)

;*********************************************************************;
;Cell B Script
;*********************************************************************;
(script dormant spawn_air_forces
	(ai_place cell_b_hornets01a)
	(ai_place cell_b_hornets01b)
	(cs_run_command_script cell_b_hornets01a/driver01 cell_b_hornet01a_init_cs)
	(cs_run_command_script cell_b_hornets01b/driver01 cell_b_hornet01b_init_cs)
	(if (= (game_is_cooperative) FALSE)
		(begin
			(ai_place cell_b_hornets02)
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_hornets02/driver01) TRUE)
			(cs_run_command_script cell_b_hornets02/driver01 cell_b_hornet_init_cs)
			(ai_place cell_b_pelicans02)
			(ai_cannot_die cell_b_pelicans02 TRUE)
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_pelicans02/driver01) TRUE)
			(cs_run_command_script cell_b_pelicans02/driver01 cell_b_pelican_init_cs)
		)
	)
	(sleep 1)
	(ai_place cell_b_pelican)
	(ai_cannot_die cell_b_pelican TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_pelican/driver01) TRUE)
	(cs_run_command_script cell_b_pelican/driver01 cell_b_pelican_init_cs)
	(sleep 1)
	(ai_place cell_b_elite_phantoms)
	(ai_cannot_die cell_b_elite_phantoms TRUE)
	(cs_run_command_script cell_b_elite_phantoms/driver01 pause_forever)
	(cs_run_command_script cell_b_elite_phantoms/driver02 pause_forever)
	(object_cannot_die (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver01) TRUE)
	(object_cannot_die (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver02) TRUE)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver01))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver02))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver02) TRUE)
	(sleep 1)
	(ai_place cell_b_phantoms01)
	(ai_place cell_b_aa01)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location cell_b_phantoms01/driver01) "phantom_lc" (ai_vehicle_get_from_starting_location cell_b_aa01/driver01))
	(cs_run_command_script cell_b_phantoms01/driver01 cell_b_phantom_drop01_cs)
	(sleep 1)
	(ai_place cell_b_island_cov01)
	(ai_place cell_b_island_cov02)
	
	(ai_place cell_b_banshees)
	(ai_place cell_b_banshees02)
	(ai_place cell_b_banshees03)
	(ai_cannot_die cell_b_banshees TRUE)
	(ai_cannot_die cell_b_banshees02 TRUE)
	(ai_cannot_die cell_b_banshees03 TRUE)
	
	;if co-op, make sure 3rd and 4th players get hornets
	(if (>= (game_coop_player_count) 3)
		(begin
			(ai_place cell_b_hornets_3player)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" TRUE)
		)
	)
	(if (= (game_coop_player_count) 4)
		(begin
			(ai_place cell_b_hornets_4player)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" TRUE)
		)
	)
)

(script static boolean cell_b_hornet_driver_test
	(or
		(vehicle_test_seat_list (ai_player_get_vehicle_squad (player0)) "hornet_p_l" (players))
		(vehicle_test_seat_list (ai_player_get_vehicle_squad (player0)) "hornet_p_r" (players))
	)
)

(script static void test_hornet_start
	(set g_tower1 TRUE)
	(ai_place test_hornet_odsts)
	(ai_place cell_b_hornets02)
	(cs_run_command_script cell_b_hornets02/driver01 cell_b_hornet_init_cs)
	(ai_place cell_b_pelican)
	(ai_place cell_b_pelicans02)
	(cs_run_command_script cell_b_pelican/driver01 cell_b_pelican_init_cs)
	(cs_run_command_script cell_b_pelicans02/driver01 cell_b_pelican_init_cs)
	
	(ai_place cell_b_hornets01a)
	(ai_place cell_b_hornets01b)
	(cs_run_command_script cell_b_hornets01a/driver01 cell_b_hornet01a_init_cs)
	(cs_run_command_script cell_b_hornets01b/driver01 cell_b_hornet01b_init_cs)
	(sleep_until (or
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (players)))
	)
	(wake cell_b_hornet_loadup)
)

(script command_script cell_b_hornet01b_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until	(or
					(volume_test_players vol_cell_b_start)
					(= (game_insertion_point_get) 1)
				)
	5)
	;(cs_fly_by beach_pts/hornet01bc 4)
	(cs_fly_by beach_pts/hornet01bb 4)
	(cs_face TRUE cell_b_pts/pelican01)
	(cs_fly_to beach_pts/hornet01ba 1)
	(sleep 30)
	;(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "hornet_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "hornet_d" TRUE)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "")
	(sleep_until 
		(or
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (players))
		)
	)
	(sleep 60)
)

(script command_script cell_b_hornet01a_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until	(or
					(volume_test_players vol_cell_b_start)
					(= (game_insertion_point_get) 1)
				)
	5)
	;(cs_fly_by beach_pts/hornet01ac 4)
	(cs_fly_by beach_pts/hornet01ab 4)
	(cs_face TRUE cell_b_pts/pelican01)
	(cs_fly_to beach_pts/hornet01aa 1)
	(sleep 30)
	;(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "hornet_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "hornet_d" TRUE)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "")
	(sleep_until 
		(or
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (players))
		)
	)
	(sleep 30)
)

(script dormant cell_b_hornet_loadup
	;load up the ODSTs
	;(ai_enter_squad_vehicles all_allies)
	(sleep 90)
	
	(if (= (game_is_cooperative) FALSE)
		(begin
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) FALSE)
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) FALSE)
			(ai_set_task_condition beach_marines_obj/hornet_pilots FALSE)
			(sleep 1)
			;load up the pilot
			(ai_vehicle_enter cell_b_hornets01a/driver01 (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d")
			(ai_vehicle_enter cell_b_hornets01b/driver01 (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d")
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_hornets02/driver01) TRUE)
		)
	)
	
	(sleep 1)
	(ai_enter_squad_vehicles all_allies)
	(sleep 1)
	;if coop make sure system works if players each want hornet or they ride together
	(if (= (game_is_cooperative) TRUE)
		(sleep_until (volume_test_players_all vol_cell_b_objectives) 5)
	)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" FALSE)
	(ai_set_task_condition beach_marines_obj/hornet_pilots FALSE)
	(sleep 1)
	;load up the pilot
	(ai_vehicle_enter cell_b_hornets01a/driver01 (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d")
	(ai_vehicle_enter cell_b_hornets01b/driver01 (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d")
)

(script command_script cell_b_pelican_init_cs
	(sleep_until (volume_test_players vol_cell_b_start) 5)
	(cs_enable_moving TRUE)
	;(cs_enable_looking TRUE)
	(cs_face TRUE cell_b_pts/pelican01)
	(sleep_until (volume_test_players vol_cell_b_objectives) 5)
)

(script command_script cell_b_hornet_init_cs
	;(cs_enable_moving TRUE)
	;(cs_enable_looking TRUE)
	(cs_face TRUE cell_b_pts/pelican01)
	(sleep_until 
		(or
			(volume_test_players vol_cell_b_objectives)
			(and
				(<= (object_get_health (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01)) 0)
				(<= (object_get_health (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01)) 0)
			)
		)
	5)
)

(script command_script pelican_supply_cs
	(if (<= (ai_living_count cell_a_cov_obj) 0)
	(begin
		;place objects:
		(cs_fly_to cell_a_pts/pelican01e 1)
		(cs_face TRUE cell_a_pts/pelican01_face01)
		(sleep_until (volume_test_players vol_lock_a03_follow))
		(object_create_containing "tower1_supplies")
		(ai_place cell_a_marine_supply)
		(ai_place cell_a_marine_supply02)
	)
	)
	(sleep_forever)
)

;*
(script command_script cell_b_pelican01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_vehicle_speed .6)
	(cs_fly_by beach_pts/pelican_hornet01 1)
	(cs_fly_by beach_pts/pelican_hornet02 1)
	(cs_fly_by beach_pts/pelican_hornet03 4)
	(cs_face TRUE beach_pts/pelican_hornet_face)
	(cs_fly_by beach_pts/pelican_hornet04 2)
	(sleep_forever)
)
*;

(script command_script cell_b_hornet01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (unit_in_vehicle ai_current_actor))
	(cs_enable_moving FALSE)
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)
	;(cs_vehicle_speed .6)
	(cs_fly_by beach_pts/pelican_hornet01)
	(cs_fly_by beach_pts/hornet02)
)

(script dormant cell_b_hog_goose
	(ai_place cell_b_goose)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_goose/driver01) "mongoose_d" TRUE)
	
	(sleep_until (volume_test_players vol_cell_a_newhog))
	(game_save)
	(if (not (volume_test_object vol_cell_a_lockstart (ai_vehicle_get_from_starting_location patha_hog/warthog01)))
		;if old hog not still around then spawn new one
		(begin
			(ai_place cell_b_hog)
			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_hog/driver01) TRUE)
			(cs_run_command_script cell_b_hog/driver01 cell_b_hog_cs)
		)
	)
	(sleep_until (any_players_in_vehicle))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_goose/driver01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_b_hog/driver01) FALSE)
	;(ai_enter_squad_vehicles beach_odsts)
	;(sleep 120)
	(ai_enter_squad_vehicles all_allies)
	(sleep 120)
	(ai_enter_squad_vehicles all_allies)
	(sleep 200)
	(ai_enter_squad_vehicles all_allies)
)

(script command_script cell_b_hog_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to cell_a_pts/cell_b_hog01a)
	(sleep 20)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_hog/driver01) "warthog_d" TRUE)
	(vehicle_unload (ai_vehicle_get_from_starting_location cell_b_hog/driver01) "warthog_d")
	(wake md_cellb_get_in)
)

(script command_script cell_b_aa_cs
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_forever)
)

(script command_script cell_b_phantom_drop01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (volume_test_players vol_cell_b_hornet_pickup) 30 400)
	(sleep_until (objects_can_see_object (player0) (ai_vehicle_get ai_current_actor) 30))
	(cs_vehicle_speed .6)
	(cs_fly_to cell_b_pts/wraith_drop01a)
	(cs_fly_to cell_b_pts/wraith_drop01b 1)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
	(ai_place_in_vehicle cell_b_cov01 (ai_get_squad ai_current_actor))
	;*
	(ai_trickle_via_phantom ai_current_actor cell_b_cov01)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p")
	(sleep 60)
	(unit_close (ai_vehicle_get ai_current_actor))
	*;
)

(script command_script cell_b_phantom_drop02_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to cell_b_pts/wraith_drop02a)
	(cs_vehicle_speed .3)
	(cs_fly_to cell_b_pts/wraith_drop02b 1)
	(vehicle_unload (ai_vehicle_get_from_starting_location cell_b_phantoms02/driver01) "phantom_lc")
)

(script command_script cell_b_banshee_cs
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_vehicle_boost FALSE)
					(cs_enable_targeting TRUE)
					(sleep (random_range (* 30 3) (* 30 8)))
					(cs_vehicle_boost TRUE)
					(cs_enable_targeting FALSE)
				)
				(sleep (random_range (* 30 3) (* 30 8)))
			)
			FALSE
		)
	)
)

(script dormant cell_b_elite_phantom_escape
	(cs_run_command_script  cell_b_elite_phantoms/driver01 cell_b_elite_phantom_cs)
	(sleep (random_range 20 50))
	(cs_run_command_script  cell_b_elite_phantoms/driver02 cell_b_elite_phantom_cs)
	(sleep (random_range 110 130))
	(print "cloak 1")
	(unit_set_active_camo (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver01) TRUE 3)
	(sleep (random_range 40 70))
	(print "cloak 2")
	(unit_set_active_camo (ai_vehicle_get_from_starting_location cell_b_elite_phantoms/driver02) TRUE 3)
	(sleep (* 4 30))
	(ai_erase cell_b_elite_phantoms)
)

(script command_script cell_b_elite_phantom_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to cell_b_pts/elite_phantom01)
)

(script dormant cell_b_island_hornet_respawn
	(sleep_until
		(begin
			(sleep_until
				(and
					(player_needs_vehicle_on_island)
					(<= (ai_task_count cell_b_cov_obj/banshee_gate) 0)
					(<= (ai_task_count cell_b_cov_obj/banshee_gate) 0)
					;(<= (object_get_health (ai_vehicle_get_from_starting_location cell_b_hornets_island/driver01)) 0)
					(not (volume_test_object vol_cell_b_island (ai_vehicle_get_from_starting_location cell_b_hornets_island/driver01)))
				)
			(random_range 400 500))
			(if
				(and
					(not (volume_test_players vol_cell_b_island_hornet))
					(not (objects_can_see_flag (players) flag_cell_b_island_hornet 30))
				)
				(begin
					(ai_place cell_b_hornets_island)
					(cs_run_command_script cell_b_hornets_island cell_b_island_hornet_respawn_cs)
				)
			)
			FALSE
		)
	)
)

(script command_script cell_b_island_hornet_respawn_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to cell_b_pts/island_hornet01 1)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "")
)

(script static boolean player_needs_vehicle_on_island
	(and
		(ai_player_any_needs_vehicle)
		(<= (ai_task_count cell_b_cov_obj/wraith_gate) 0)
		(<= (ai_task_count cell_b_cov_obj/inf_gate) 0)
		(volume_test_players vol_cell_b_island)
	)
)

(script static boolean player_and_hornet_on_tower
	(and
		(volume_test_players vol_cell_b_towerclear)
		(or
			(volume_test_object vol_cell_b_towerclear (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
			(volume_test_object vol_cell_b_towerclear (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
			(volume_test_object vol_cell_b_towerclear (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
			(volume_test_object vol_cell_b_towerclear (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))
			(volume_test_object vol_cell_b_towerclear (ai_vehicle_get_from_starting_location cell_b_hornets_island/driver01))
		)
	)
)

(script static boolean player_and_hornet_on_ridge
	(and
		(volume_test_players vol_cell_c_ridge_hornet)
		(or
			(volume_test_object vol_cell_c_ridge_hornet (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
			(volume_test_object vol_cell_c_ridge_hornet (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
			(volume_test_object vol_cell_c_ridge_hornet (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
			(volume_test_object vol_cell_c_ridge_hornet (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))
			(volume_test_object vol_cell_c_ridge_hornet (ai_vehicle_get_from_starting_location cell_b_hornets_island/driver01))
		)
	)
)

(script static boolean player_and_hornet_on_beach
	(and
		(volume_test_players vol_cell_b_hornet_pickup)
		(or
			(volume_test_object vol_cell_b_hornet_pickup (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
			(volume_test_object vol_cell_b_hornet_pickup (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
			(volume_test_object vol_cell_b_hornet_pickup (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
			(volume_test_object vol_cell_b_hornet_pickup (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))
			(volume_test_object vol_cell_b_hornet_pickup (ai_vehicle_get_from_starting_location cell_b_hornets_island/driver01))
		)
	)
)

(script dormant coop_respawn_control
	(game_safe_to_respawn FALSE)
	(sleep_until 
		(begin
			(if 
				;make sure player in on island or tower with hornet and no players are elsewhere
				(and
					(or
						(volume_test_players vol_cell_b_island)
						(player_and_hornet_on_tower)
						(player_and_hornet_on_beach)
					)
					(not (volume_test_players vol_hornet_coop_test01))
					(not (volume_test_players vol_hornet_coop_test02))
					(not (volume_test_players vol_hornet_coop_test03))
				)
				(game_safe_to_respawn TRUE)
				(game_safe_to_respawn FALSE)
			)
			(= (current_zone_set) 6)	
		)
	60)
	(game_safe_to_respawn TRUE)
	(game_save_no_timeout)
)

(script dormant CellB_Start
	(sleep_until (or
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (players)))
	)
	(print "Segment:Hornet Run")
	(data_mine_set_mission_segment "100_50_hornet_run")
	(soft_ceiling_enable soft_bsp010 FALSE)
	(soft_ceiling_enable soft_bsp040 FALSE)
	(soft_ceiling_enable no_climb TRUE)
	(soft_ceiling_enable soft_bsp070 FALSE)
	(soft_ceiling_enable soft_bsp100 FALSE)

	
	(wake gs_award_primary_skull)
	
	(wake hornet_control_player)
	(wake cell_b_hornet_loadup)
	(wake md_cellb_arb_2nd_clear)
	(wake cell_b_island_hornet_respawn)
	(if (= (game_is_cooperative) TRUE)
		(wake coop_respawn_control)
	)
	
	(ai_cannot_die cell_b_banshees FALSE)
	(ai_cannot_die cell_b_banshees02 FALSE)
	(ai_cannot_die cell_b_banshees03 FALSE)
	
	(object_create cell_b_terminal)
	(object_create cell_b_terminal_base)
	(objects_attach cell_b_terminal_base "forerunner_terminal" cell_b_terminal "")

	
	(sleep_until (volume_test_players vol_cell_b_objectives) 5)
	
	; if you start from the beginning wake the chapter title 
	(if (= (game_insertion_point_get) 0) (wake 100_title2))
	
	;music
	(wake music_100_055)
	
	; turn OFF music 051 
	(set g_music_100_051 FALSE)
	
	(ai_set_objective ground_allies cell_b_marines_obj)
	(ai_set_objective air_fleet cell_b_marines_obj)
	(ai_set_objective air_allies cell_b_marines_obj)

	(cs_run_command_script cell_b_pelicans02/driver01 abort)
	(wake cell_b_elite_phantom_escape)
	(cs_run_command_script cell_b_hornets02 abort)
	
	(sleep_until (= (current_zone_set_fully_active) 5) 1)
	
	;destory beams
	(object_destroy beam_vert_left)
	(object_destroy beam_vert_mid)
	
	(flock_delete "cella_hornets")
	(flock_delete "cella_fish01")
	(flock_delete "cella_fish02")
	(flock_delete "cella_fish03")
	(ai_erase_inactive all_allies 30)
	(if (= (game_is_cooperative) FALSE)
		(game_save)
	)
	;incase other hornet was left back on the beach in a coop game
	(if (= (game_is_cooperative) TRUE)
		(begin
			(if (volume_test_object vol_cell_b_hornet_pickup (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" FALSE)
			)
			(if (volume_test_object vol_cell_b_hornet_pickup (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" FALSE)
			)
			(sleep 1)
			(ai_enter_squad_vehicles all_allies)
		)
	)
	(object_set_persistent (ai_vehicle_get_from_starting_location beach_cov_aa/driver01) FALSE)
	(ai_set_objective vehicles_cov cell_c_cov_obj)
	(sleep 60)
	(if (<= (ai_task_count cell_c_cov_obj/banshee_gate) 5) (ai_place cell_c_cov_banshees01))
	(sleep_until (volume_test_players vol_cell_c_airfall))
	(ai_set_objective cell_b_marines_obj cell_c_marines_obj)
	(if (= (game_is_cooperative) FALSE)
		(game_save)
	)
)

;*********************************************************************;
;Cell C Script
;*********************************************************************;
(script dormant cell_c_elite_right_landing
	(sleep_until (and
		;(<= (ai_task_count cell_c_cov_obj/air_gate) 0)
		TRUE
		(<= (ai_task_count cell_c_cov_obj/aa_right) 0))
	)
	(print "landing elites")
	(add_recycling_volume vol_landing01_garbage 7 10)
	(ai_place cell_c_elite_phantoms/driver01)
	(unit_set_active_camo (ai_vehicle_get_from_starting_location cell_c_elite_phantoms/driver01) TRUE 0)
	(cs_run_command_script cell_c_elite_phantoms/driver01 cell_c_elite_phantomR_cs)
	(game_save)
	(sleep 140)
	(print "uncloaking")
	(unit_set_active_camo (ai_vehicle_get_from_starting_location cell_c_elite_phantoms/driver01) FALSE 3)
)

(script dormant cell_c_elite_left_landing
	(sleep_until (and
		;(<= (ai_task_count cell_c_cov_obj/air_gate) 0)
		TRUE
		(<= (ai_task_count cell_c_cov_obj/aa_left) 0))
	)
	(print "landing elites")
	(add_recycling_volume vol_landing02_garbage 7 10)
	(ai_place cell_c_elite_phantoms/driver02)
	(unit_set_active_camo (ai_vehicle_get_from_starting_location cell_c_elite_phantoms/driver02) TRUE 0)
	(cs_run_command_script cell_c_elite_phantoms/driver02 cell_c_elite_phantomL_cs)
	(game_save)
	(sleep 140)
	(print "uncloaking")
	(unit_set_active_camo (ai_vehicle_get_from_starting_location cell_c_elite_phantoms/driver02) FALSE 3)
)

(script command_script cell_c_elite_phantomR_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .9)
	(cs_fly_to cell_c_pts/elite_phantom01a 1)
	(cs_vehicle_speed .5)
	(cs_face TRUE cell_c_pts/elite_phantom01_face)
	(cs_fly_to cell_c_pts/elite_phantom01b 1)
	(sleep 60)
	(ai_trickle_via_phantom cell_c_elite_phantoms/driver01 cell_c_elites)
	(sleep 60)
	(cs_fly_to cell_c_pts/elite_phantom01a 1)
	(sleep_forever)
)

(script command_script cell_c_elite_phantomL_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .9)
	(cs_fly_to cell_c_pts/elite_phantom02a 1)
	(print "uncloaking")
	(unit_set_active_camo (ai_vehicle_get ai_current_actor) FALSE 3)
	(cs_vehicle_speed .5)
	(cs_face TRUE cell_c_pts/elite_phantom02_face)
	(cs_fly_to cell_c_pts/elite_phantom02b 1)
	(sleep 60)
	(ai_trickle_via_phantom cell_c_elite_phantoms/driver02 cell_c_elites_left)
	(if (= (game_is_cooperative) FALSE)
		(ai_trickle_via_phantom cell_c_elite_phantoms/driver02 cell_c_arbiter/arbiter)
	)
	(sleep 60)
	(cs_fly_to cell_c_pts/elite_phantom02a 1)
	(sleep_forever)
)

;*
(script dormant cell_c_elite_landing
	(sleep_until (and
		;(<= (ai_task_count cell_c_cov_obj/air_gate) 0)
		TRUE
		(<= (ai_task_count cell_c_cov_obj/aa_right) 0))
	)
	(print "landing elites")
	(cs_run_command_script cell_c_marines_obj/pelican_land01a cell_c_elite_pelican_cs)
	(cs_run_command_script cell_c_marines_obj/pelican_land01b cell_c_elite_pelican_cs)
)
*;

(script command_script cell_c_elite_pelican_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to cell_c_pts/pelican_right01a 1)
	(cs_face TRUE cell_c_pts/pelican_right_face)
	(ai_place_in_vehicle cell_c_elites (ai_get_squad ai_current_actor))
	(cs_fly_to cell_c_pts/pelican_right01b 1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 90)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p")
	(sleep 60)
	(cs_fly_to cell_c_pts/pelican_right01a 1)
	(sleep_forever)
)

(script dormant cell_c_marine_landing
	(sleep_until (and
		;(<= (ai_task_count cell_c_cov_obj/air_gate) 0)
		TRUE
		(<= (ai_task_count cell_c_cov_obj/aa_left) 0))
	)
	(print "landing marines")
	(cs_run_command_script cell_c_marines_obj/pelican_land02a cell_c_marine_pelican_cs)
	(cs_run_command_script cell_c_marines_obj/pelican_land02b cell_c_marine_pelican_cs)
)

(script command_script cell_c_marine_pelican_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to cell_c_pts/pelican_left01a 1)
	(cs_face TRUE cell_c_pts/pelican_left_face)
	(ai_place_in_vehicle cell_c_marines01 (ai_get_squad ai_current_actor))
	(cs_fly_to cell_c_pts/pelican_left01b 1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 60)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p")
	(sleep 60)
	(cs_fly_to cell_c_pts/pelican_left01a 1)
	(sleep_forever)
)

(script dormant CellC_Start
	(print "Segment:CellC")
	(data_mine_set_mission_segment "100_60_cell_c")
	(if (= (game_is_cooperative) FALSE)
		(game_save)
	)
	(ai_erase cell_b_hog)
	;(object_destroy (ai_vehicle_get_from_starting_location cell_b_pelican/driver01))
	(sleep 1)
	(ai_place cell_c_aa)
	(ai_place cell_c_aa_right)
	(ai_place cell_c_aa_left)
	;(ai_place cell_c_cov01)
	;(ai_place cell_c_cov02)
	(ai_place cell_c_shades_mid)
	;(ai_place cell_c_shades_left)
	;(ai_place cell_c_shades_right)
	(sleep_until (volume_test_players vol_cell_c_init))
	(ai_place cell_c_cov_brutes01)
	(sleep 60)
	(wake md_cellc_clear_lz)
	(wake cell_c_elite_right_landing)
	(wake cell_c_elite_left_landing)
	
	(sleep_until
		(or
			(volume_test_players vol_cell_c_brute_spawn02)
			(>= (ai_living_count cell_c_elites_left) 1)
			(>= (ai_living_count cell_c_elites) 1)
		)
	5)
	(ai_place cell_c_cov_brutes02)
	(ai_place cell_c_cov_brutes03)
	(wake lock_c_nav_start02)
	
	(ai_disposable cell_b_island_cov01 TRUE)
	(ai_disposable cell_b_island_cov02 TRUE)
	(ai_disposable cell_b_cov_ground TRUE)
	(sleep_forever cell_b_island_hornet_respawn)
	(game_save)
	
	(sleep_until (volume_test_players vol_cell_c_brute_spawn) 5)
	(if 
		;if brutes are mostly dead and allies are mostly alive, player needs more challenge
		(and 
			(<= (ai_task_count cell_c_cov_obj/brute_gate) 5)
			(>= (ai_task_count cell_c_marines_obj/inf_gate) 4)
		)
		(begin
			(ai_place cell_c_cov_brutes04)
			;if the cheiftain in dead, spawn another leader
			(if (<= (ai_living_count cell_c_cov_brutes01/chief) 0)
				(ai_place cell_c_cov_brutes04_lead)
			)
		)
	)
	(sleep_until (<= (ai_living_count cell_c_cov_obj) 0))
	(game_save)
	(wake CellC_cleanup)
)

(script dormant CellC_cleanup
	(print "cleanup")
)

;*********************************************************************;
;Lock C Script
;*********************************************************************;
(script command_script lockc_bugger_exit_cs
	;(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(begin_random
		(begin
			(cs_fly_to lock_c_pts/bugger_exit01)
			(cs_fly_to lock_c02_pts/bugger_exit01)
			(ai_erase ai_current_actor)
		)
		(begin
			(cs_fly_to lock_c_pts/bugger_exit02)
			(cs_fly_to lock_c02_pts/bugger_exit01)
			(ai_erase ai_current_actor)
		)
		(begin
			(cs_fly_to lock_c_pts/bugger_exit03)
			(cs_fly_to lock_c02_pts/bugger_exit01)
			(ai_erase ai_current_actor)
		)
		(begin
			(cs_fly_to lock_c_pts/bugger_exit04)
			(cs_fly_to lock_c02_pts/bugger_exit01)
			(ai_erase ai_current_actor)
		)
	)
)

(script dormant lock_c_elevator_setup
	(object_create tower3_elevator)
	(object_create tower3_elevator_switch)
	(sleep 1)
	(objects_attach tower3_elevator "citadel_elevator_switch" tower3_elevator_switch "")
	(sleep_until (= (current_zone_set) 10))
	(object_destroy tower3_elevator)
	(object_destroy tower3_elevator_switch)
)

(script dormant lock_c_elevator_control
	(sleep_until
	(begin
		;elevator is ready to go up
		(sleep_until (> (device_get_position tower3_elevator) 0) 1)
		(device_set_power tower3_eleswitch_bottom 0)
		(sleep_until (>= (device_get_position tower3_elevator) 1) 1)
		(device_set_position tower3_elevator_switch .5)
		(sleep_until (>= (device_get_position tower3_elevator_switch) .5) 5)
		;elevator is ready to go down
		
		;if player got left behind, send back down, else lock elevator up top
		(if (not (volume_test_players vol_lock_c_elevator_test))
			(begin
				(device_group_change_only_once_more_set tower3_lift FALSE)
				(sleep 1)
				(device_group_change_only_once_more_set tower3_lift TRUE)
				(device_set_position tower3_elevator 0)
			)
			(sleep_until g_tower3)
		)
		
		(device_group_change_only_once_more_set tower3_lift FALSE)
		(sleep 1)
		(device_group_change_only_once_more_set tower3_lift TRUE)
		(device_set_power tower3_eleswitch_top 1)
		(sleep_until (< (device_get_position tower3_elevator) 1) 1)
		(device_set_power tower3_eleswitch_top 0)
		(sleep_until (<= (device_get_position tower3_elevator) 0) 1)
		(device_set_position tower3_elevator_switch 1)
		(sleep_until (>= (device_get_position tower3_elevator_switch) 1) 5)
		(device_set_position_immediate tower3_elevator_switch 0)
		
		(device_group_change_only_once_more_set tower3_lift FALSE)
		(sleep 1)
		(device_group_change_only_once_more_set tower3_lift TRUE)
		(if (not g_tower3)
			(device_set_power tower3_eleswitch_bottom 1)
		)
		g_tower3
	)
	)
)

(script dormant lock_c01_saves
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players vol_lock_c01_saves)
				(game_safe_to_save))
			5)
		(game_save)
		(sleep (* 30 90))
		FALSE
		)
	)
)

(script dormant lock_c01_saves02
	(sleep_until
		(and
			(<= (ai_task_count lock_c_cov_obj/bugger_gate) 0)
			(<= (ai_task_count lock_c_cov_obj/hunter_gate) 0)
		)
	)
	(game_save)
)

(script dormant lock_c02_saves
	(sleep_until (and
		(volume_test_players vol_lock_c02_saves)
		(game_safe_to_save))
	)
	(game_save)
)

(script dormant LockC_Start
	(sleep_until (volume_test_players vol_lock_c01_start))
	(print "Segment:LockC")
	(data_mine_set_mission_segment "100_70_lock_c01")
	
	;music
	(wake music_100_06)
	(set g_music_100_06 TRUE)
	
	(beach_cella_locka_garbage)
	(wake lock_c_elevator_setup)
	(wake lock_c_elevator_control)
	
	(object_create lock_c_terminal)
	(objects_attach lock_c_terminal_base "forerunner_terminal" lock_c_terminal "")
	
	(sleep_until (volume_test_players vol_lock_c01_objs))
	(ai_set_objective cell_c_marines_obj/elites_inside lock_c_marines_obj)
	(ai_set_objective cell_c_marines_obj/marines_inside lock_c_marines_obj)
	(wake lock_c01_saves)
	(soft_ceiling_enable soft_bsp070 TRUE)
	(soft_ceiling_enable no_climb FALSE)
	(soft_ceiling_enable soft_bsp100 TRUE)
	(sleep_until (volume_test_players vol_lock_c_start))
	(add_recycling_volume waterfront_garbage 0 0)
	(sleep 1)
	(ai_place lock_c_hunters)
	(sleep 1)
	(ai_place lock_c_buggers01)
	(sleep 1)
	(ai_place lock_c_buggers02)
	(sleep 1)
	(ai_place lock_c_buggers03)
	;(ai_place lock_c_grunts01)
	;(ai_place lock_c_grunts02)
	(wake lock_c01_saves02)
	
	;music
	(wake music_100_058)
	(set g_music_100_058 TRUE)
	
	(sleep_until (or
		(volume_test_players vol_lock_c01b_start)
		(volume_test_players vol_lock_c01b_bypass))
	)
	;(game_save)
	(ai_place lock_c_brutes01)
	(ai_place lock_c_brutes02)
	(wake LockC02_start)
	
	;music
	(wake music_100_059)
	(set g_music_100_059 TRUE)
	
	(if (>= (ai_living_count lock_c_marines_obj) 2)
	;if player still has allies allive=increase challenge
		(ai_place lock_c_brutes02b)
	)
	
	(sleep_until
	;Bugger spawn:sleep until (player has kill the brutes AND is looking forward) OR (they hit the final volume)
		(or
			(volume_test_players vol_lock_c01b_bugger_end02)
			(and
				(volume_test_players vol_lock_c01b_bugger_end)
				(objects_can_see_flag (player0) flag_lock_c_buggers 30)
				(<= (ai_task_count lock_c_cov_obj/c02_gate) 1)
			)
		)
	5)
	(ai_place lock_c_buggers03)
	(if (and (not g_tower3) (= (game_is_cooperative) FALSE))
		(wake md_lockc_arb_prompt01)
	)
	(sleep_until (<= (ai_living_count lock_c_cov_obj) 0))
	(wake lock_c_nav_elevator)
	(set g_music_100_058 FALSE)
	(set g_music_100_059 FALSE)
	(game_save)
)

(script command_script lockc02_init_cs
	(cs_enable_targeting TRUE)
	(sleep_until (>= (device_get_position tower3_elevator) .8) 10)
	(sleep (random_range 0 40))
	(cs_force_combat_status ai_combat_status_alert)
	(ai_magically_see_object lock_c02_cov_obj (player0))
)

(script dormant LockC02_start
	(sleep_until (volume_test_players vol_lock_c02_init) 5)
	(data_mine_set_mission_segment "100_75_lock_c02")
	(object_create citadel_entry_door01)
	(sleep_forever lock_c01_saves)
	(wake lock_c02_saves)
	(ai_place lock_c02_cov01)
	(ai_place lock_c02_cov02a)
	(ai_place lock_c02_cov02b)
	(cs_run_command_script lock_c02_cov01 lockc02_init_cs)
	(cs_run_command_script lock_c02_cov02a lockc02_init_cs)
	(cs_run_command_script lock_c02_cov02b lockc02_init_cs)
	(sleep_until (<= (ai_living_count lock_c02_cov_obj) 0) 5)
	(wake md_lockc_prompt02)
	(wake lock_c_nav_button)
	
	(game_save)
	(device_set_power tower3_switch 1)
	(device_set_power tower3_holo 1)
	(sleep_until (> (device_get_position tower3_switch) 0) 1)
	(device_operates_automatically_set tower3_holo FALSE)
	(device_set_position tower3_holo 0)
	
	;dialog
	(wake md_lockc_prompt02)
	
	(sleep_until (> (device_get_position tower3_holo) 0) 1)
	(sleep_forever md_lockc_prompt02)
	(wake objective_2_clear)
	(set g_tower3 TRUE)
	(device_set_power beam_diag_right 0)
	(device_set_power beam_vert_right 0)
	(device_set_power beam_vert_right_crater 0)
	
	;music
	(set g_music_100_06 FALSE)
	
	(cinematic_fade_to_black)
	
	(print "Segment:Cinematic:100lb_hc_crash")
	(data_mine_set_mission_segment "100lb_HC_Crash")
	(if g_play_cinematics
		(begin
			(sleep 1)
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
			(if (cinematic_skip_start)
				(begin
					(print "100lb_hc_crash")
					(100lb_hc_crash)
				)
			)
			(cinematic_skip_stop)
			(object_teleport (player0) cin_towerC_player0)
			(object_teleport (player1) cin_towerC_player1)
			(object_teleport (player2) cin_towerC_player2)
			(object_teleport (player3) cin_towerC_player3)
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
			(object_create_folder flood_chunks)
			(object_set_region_state tower3_glass window destroyed)
			(ai_place lock_c03_flood01)
			(ai_place lock_c03_flood02)
		)
		;else
		(begin
			(print "skipping '100lb_hc_crash' cinematic")
			(ai_place lock_c03_flood01)
			(ai_place lock_c03_flood02)
			(object_create_folder flood_chunks)
			(object_set_region_state tower3_glass window destroyed)
			(device_set_power crater_shield 0)
		)
	)

	; cleanup cinematic scripts 
	(100lb_hc_crash_cleanup)
	
	(cinematic_fade_to_gameplay)
	
	;music
	(wake music_100_07)
	(set g_music_100_07 TRUE)
	(wake music_100_08)
	(set g_music_100_08 TRUE)
	
	;flood howl
	(sound_impulse_start "sound\dialog\110_hc\mission\110mx_300_grv" anchor_cell_c_howl 1)
	
	(print "Segment:100_76_lock_c_flood01")
	(data_mine_set_mission_segment "100_76_lock_c_flood01")
	(ai_set_task_condition lock_c_marines_obj/tower3_arb FALSE)
	(object_destroy crater_shield)
	(object_create debris_meteors)
	(soft_ceiling_enable no_jump TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_c_exit TRUE)
	(zone_set_trigger_volume_enable zone_set:set_cell_c_exit TRUE)
	(zone_set_trigger_volume_enable zone_set:set_cell_c_int FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_c_int:* FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_c_int02 FALSE)
	(object_create high_charity)
	(object_destroy cov_capital_ship)
	(wake objective_3_set)
	(wake cell_c_vehicle_cleanup)
	(sleep_forever md_lockc_arb_prompt01)
	(cs_run_command_script cell_c_arbiter abort)
	(game_save_immediate)
	(sleep 90)
	

	(sleep_until	(or 
					(< (device_get_position tower3_elevator) 1)
					(<= (ai_nonswarm_count lock_c03_flood_obj) 0)
				)
	)
	;dialog
	(wake md_lockc_status)
	
	(sleep_until (volume_test_players vol_lock_c02_init) 5)
	(data_mine_set_mission_segment "100_77_lock_c_flood02")
	(ai_disposable lock_c03_flood01 TRUE)
	(ai_disposable lock_c03_flood02 TRUE)
	(game_save)
	;(ai_place lock_c04_elites)
	(ai_place lock_c04_flood01)
	(wake lock_c04_flood_respawn)
	;(sleep_forever lock_c_elevator_control)
	(sleep_until (volume_test_players vol_lock_c04_exit) 5)
	(ai_place lock_c04_flood03)
	(flock_create "cellc_hornets")
	(flock_create "cellc_banshees")
	(ai_set_objective lock_c_marines_obj cell_c_marines_obj)
	(if 
		(and
			(<= (ai_living_count cell_c_arbiter) 0)
			(= (game_is_cooperative) FALSE)
		)
		(ai_place cell_c_arbiter)
	)
	(wake buffet_nav_start)
	
	(sleep_until (volume_test_players vol_lock_c_ext_start))
	(ai_set_objective lock_c04_flood_obj cell_c_flood_obj)
	(wake lock_c_ext_spawn)
	
	(if (= (game_is_cooperative) FALSE)
		(wake lock_04_arbiter_exit)
	)
	
	(sleep_until (volume_test_players vol_tankrun01_start) 1)
	(wake crater_entry_door)
	(wake Tank_tank_drop)
	(sleep_until (volume_test_players vol_tankrun01_vehicle_drop))
	(game_save)
)

(script static void test_arbiter_exit
	(set g_tower3 TRUE)
	(ai_place cell_c_arbiter)
	(wake lock_04_arbiter_exit)
)

(script dormant lock_04_arbiter_exit
	(ai_place lock_c_ext_elite_phantom)
	(ai_place lock_c_ext_spark)
	(cs_run_command_script lock_c_ext_elite_phantom/driver01 pause_forever)
	(object_create cell_c_phantom_block01)
	(object_create cell_c_phantom_block02)
	(sleep_until (= (current_zone_set_fully_active) 9))
	(ai_bring_forward (ai_get_object cell_c_arbiter/arbiter) 6)
	(ai_set_targeting_group cell_c_arbiter 1)
	(sleep_until (volume_test_object vol_cell_c_arbiter_exit_test02 cell_c_arbiter) 10)
	(ai_enter_squad_vehicles cellc_elites)
	(wake md_ridge_spark_assess)
	(sleep_until
		(and
			(volume_test_object vol_cell_c_arbiter_exit_test lock_c_ext_spark)
			(vehicle_test_seat (ai_vehicle_get_from_starting_location lock_c_ext_elite_phantom/driver01) "phantom_p_lf_main" lock_c_ext_elite_phantom)
		)
	)
	(cs_run_command_script lock_c_ext_elite_phantom/driver01 arbiter_exit_cs)
)

(script command_script arbiter_exit_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(unit_close (ai_vehicle_get ai_current_actor))
	(sleep 30)
	(ai_erase lock_c_ext_spark)
	(object_destroy cell_c_phantom_block01)
	(object_destroy cell_c_phantom_block02)
	(cs_fly_by cell_c_pts/arber_exit02 8)
	;allow elites to enter vehicles
	(ai_set_task_condition cell_c_marines_obj/ext_elites_vehicles TRUE)
	(wake arbiter_exit_surf)
	(unit_set_active_camo (ai_vehicle_get ai_current_actor) TRUE 3)
	(cs_vehicle_boost TRUE)
	(cs_fly_by cell_c_pts/arber_exit03 8)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant arbiter_exit_surf
	(ai_erase arbiter)
	(sleep 1)
	(print "killing surfers")
	(if (volume_test_object arbiter_exit_surf (player0)) (unit_kill (player0)))
	(if (volume_test_object arbiter_exit_surf (player1)) (unit_kill (player1)))
	(if (volume_test_object arbiter_exit_surf (player2)) (unit_kill (player2)))
	(if (volume_test_object arbiter_exit_surf (player3)) (unit_kill (player3)))
)

(script dormant lock_c04_flood_respawn
	(sleep 120)
	(sleep_until
		(begin
			(ai_place lock_c04_flood02)
			(sleep 220)
			(sleep_until (<= (ai_task_count lock_c04_flood_obj/init) 20))
			(<= (ai_task_count lock_c_marines_obj/init) 0)
		)
	)
)

(script dormant cell_c_vehicle_cleanup
	;hornets
	(object_destroy (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
	(object_destroy (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
	(object_destroy (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
	(object_destroy (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))

	(object_destroy (ai_vehicle_get_from_starting_location cell_b_hornets02/driver01))
	;wraith
	(object_destroy (ai_vehicle_get_from_starting_location cell_c_aa/driver01))
	;pelicans
	(object_destroy (ai_vehicle_get_from_starting_location cell_b_pelican/driver01))
	(object_destroy (ai_vehicle_get_from_starting_location cell_b_pelicans02/driver01))
	
	(sleep_forever hornet_control_player00)
	(sleep_forever hornet_control_player01)
	(sleep_forever hornet_control_player02)
	(sleep_forever hornet_control_player03)
)

;*********************************************************************;
;Tank Run Script
;*********************************************************************;
(script dormant Tank_tank_drop
	(ai_place tank_marines_pelican)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_pelican/driver01) TRUE)
	;(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_pelican/driver02) TRUE)
	(cs_run_command_script tank_marines_pelican/driver01 pause_forever)
	(sleep_until (= (current_zone_set_fully_active) 9))
	(ai_place tank_marines_scorpion)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_pelican/driver01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) "scorpion_g" FALSE)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location tank_marines_pelican/driver01) "pelican_lc" (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01))
	(cs_run_command_script tank_marines_pelican/driver01 Tank_pelican01_cs)
	(sleep_until (volume_test_players vol_cell_c_tankdrop))
	(wake br_citadel_03)
	(flock_stop "cellc_banshees")
	(wake tank_drop_unreserve)
)

(script dormant tank_drop_unreserve
	(sleep_until 
		(or 
			(any_players_in_vehicle)
			(volume_test_players vol_ice_start)
		)
	)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) FALSE)
	(ai_erase_inactive all_allies 0)
	(sleep 1)
	(ai_vehicle_enter lock_c_ext_marines_rl (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_p")
	;(ai_enter_squad_vehicles all_allies)
	;(ai_enter_squad_vehicles beach_inf_marines)
	(sleep 30)
	(ai_enter_squad_vehicles all_allies)
	(wake ridge_nav_start)
	;load up elites when they are ready
	(sleep_until (>= (ai_task_status cell_c_marines_obj/ext_elites_vehicles) 1))
	(ai_enter_squad_vehicles all_allies)
)

(script command_script Tank_pelican01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by cell_c_pts/tank_pelican01a)
	(cs_vehicle_boost FALSE)
	(cs_face TRUE cell_c_pts/tank_pelican01_face)
	(cs_fly_by cell_c_pts/tank_pelican01b)
	(sleep_until (or
		(volume_test_players vol_cell_c_tankdrop)
		(objects_can_see_object (player0) (ai_vehicle_get ai_current_actor) 30))
	5 );(* 30 10)
	(cs_fly_to cell_c_pts/tank_pelican01c 1)
	(vehicle_unload (ai_vehicle_get_from_starting_location tank_marines_pelican/driver01) "pelican_lc")
	(cs_fly_to cell_c_pts/tank_pelican01b 1)
	(ai_enter_squad_vehicles all_allies)
	(sleep_forever)
)

(script command_script tankrun_banshees_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep (random_range 300 400))
)

(script dormant lock_c_ext_spawn
	(ai_place lock_c_ext_marines)
	;(ai_place lock_c_ext_cov01)
	(sleep 1)
	(ai_place lock_c_ext_flood01)
	(sleep_until (volume_test_players vol_cell_c_ext01))
	(ai_place lock_c_ext_flood02)
)

(script dormant crater_entry_door
	(device_operates_automatically_set lock_c_entry_door 0)
	(device_set_position lock_c_entry_door 0)
	(sleep_until (<= (device_get_position lock_c_entry_door) 0))
	(device_set_power lock_c_entry_door 0)
	(add_recycling_volume lock_c_garbage 0 0)
	(lock_c_coop_teleport)
	(sleep 1)
	;(prepare_to_switch_to_zone_set set_cell_ice)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_ice TRUE)
	(zone_set_trigger_volume_enable zone_set:set_cell_ice:a TRUE)
	(zone_set_trigger_volume_enable zone_set:set_cell_ice:b TRUE)
	(sleep_until (= (current_zone_set_fully_active) 9) 1)
	
	(ai_place tank_marines_hog)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) TRUE)
	(ai_place tank_marines_goose)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_d" TRUE)
	(ai_place lock_c_ext_marines_rl)
	(sleep 30)
	(ai_vehicle_enter lock_c_ext_marines_rl (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_p")
	(device_set_position crater_entry_door 1)
	(game_save)
)

(script static void lock_c_coop_teleport
	(print "teleport backup")
	(if (volume_test_object vol_lock_c_coop_teleport (player0)) (object_teleport (player0) lock_c_coop_teleport_player0))
	(if (volume_test_object vol_lock_c_coop_teleport (player1)) (object_teleport (player1) lock_c_coop_teleport_player1))
	(if (volume_test_object vol_lock_c_coop_teleport (player2)) (object_teleport (player2) lock_c_coop_teleport_player2))
	(if (volume_test_object vol_lock_c_coop_teleport (player3)) (object_teleport (player3) lock_c_coop_teleport_player3))
)


(script dormant crater_entry_door_close
	(sleep_until (volume_test_players vol_crater_entry_door_close) 1)
	(device_set_position crater_entry_door 0)
	(sleep_until (<= (device_get_position crater_entry_door) .17) 1)
	(zone_set_trigger_volume_enable begin_zone_set:set_crater:* TRUE)
	(lock_c_ext_cleanup)
	(sleep 1)
	(sleep 30)
	(wake ice_vehicle_renew)
)

(script static void lock_c_ext_cleanup
	(ai_disposable Flood TRUE)
	(ai_set_objective cell_c_marines_obj/vehicles_to_ice path_b_marines_obj)
	(sleep 10)
	(ai_erase_inactive cell_c_marines_obj 30)
	(add_recycling_volume cell_c_garbage 0 0)
)

(script command_script ice_phantom_cs
	(sleep_until 
		(or
			(> (object_model_targets_destroyed (ai_vehicle_get ai_current_actor) "target_front") 0)
			(<= (ai_living_count (ai_get_squad ai_current_actor)) 3)
		)
	)
	(print "phantom leaving")
	(cs_fly_to path_b/phantom01)
	(cs_fly_to path_b/phantom02)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script static void test_tank_path
	(ai_place tank_marines_scorpion)
	;(object_teleport (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) teleport_ice_tank_renew)
	(object_teleport (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) flag_ridge_renew_hog)
	(ai_place ice_marines_renew)
	(ai_vehicle_enter_immediate ice_marines_renew (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) "scorpion_d")
	;(ai_set_objective all_allies path_b_marines_obj)
	(ai_set_objective all_allies tank_marines_obj)
	(ai_set_task_condition tank_marines_obj/tank_advance02 TRUE)
)

(script dormant ice_vehicle_renew
	(sleep_until (not (volume_test_players vol_ice_renew_check)))
	(if (volume_test_object vol_ice_left_behind (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01))
	;tank didn't make it through the door
		(begin
			(print "scorpion didn't make it")
			(object_teleport (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) teleport_ice_tank_renew)
			(if (<= (ai_living_count (ai_get_driver tank_marines_scorpion/scorpion01)) 0)
				(begin
					(ai_place ice_marines_renew)
					(ai_vehicle_enter_immediate ice_marines_renew (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) "scorpion_d")
				)
			)
		)
	)
	(if (volume_test_object vol_ice_left_behind (ai_vehicle_get_from_starting_location tank_marines_hog/driver01))
	;hog didn't make it through the door
		(begin
			(print "hog didn't make it")
			(object_teleport (ai_vehicle_get_from_starting_location  tank_marines_hog/driver01) teleport_ice_hog_renew)
			(if (<= (ai_living_count (ai_get_driver  tank_marines_hog/driver01)) 0)
				(begin
					(ai_place ice_marines_renew)
					(ai_vehicle_enter_immediate ice_marines_renew (ai_vehicle_get_from_starting_location  tank_marines_hog/driver01) "warthog_d")
				)
			)
		)
	)
	(if (volume_test_object vol_ice_left_behind (ai_vehicle_get_from_starting_location tank_marines_goose/driver01))
	;goose didn't make it through the door
		(begin
			(print "goose didn't make it")
			(object_teleport (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) teleport_ice_goose_renew)
			(if (<= (ai_living_count (ai_get_driver tank_marines_goose/driver01)) 0)
				(begin
					(ai_place ice_marines_renew)
					(ai_vehicle_enter_immediate ice_marines_renew (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_d")
					;equip RL passenger if possible
					(if 
						(and
							(<= (ai_living_count lock_c_ext_marines_rl) 0)
							(<= (ai_living_count tank_marines_goose) 1)
						)
						(ai_vehicle_enter_immediate lock_c_ext_marines_rl/RL (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_p")
					)
				)
			)
		)
	)
)

(script command_script tank_wraith_shoot_cs
	(cs_run_command_script tank_cov_wraiths01/gunner01 abort)
	(cs_enable_moving TRUE)
	(sleep 90)
	;(cs_enable_moving FALSE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(sleep (random_range 150 200))
					(cs_shoot_point TRUE crater_pts/wraith_shoot01)
				)
				(begin
					(sleep (random_range 150 200))
					(cs_shoot_point TRUE crater_pts/wraith_shoot02)
				)
				(begin
					(sleep (random_range 150 200))
					(cs_shoot_point TRUE crater_pts/wraith_shoot03)
				)
			)
			FALSE
		)
	)
)

(script dormant ridge_vehicle_renew
	;scorpion teleport
	(if (volume_test_object vol_ridge_renew_check (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01))
		(begin
			(object_teleport (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) flag_ridge_renew_hog)
			(if (<= (ai_living_count (ai_get_driver tank_marines_scorpion/scorpion01)) 0)
				(begin
					(ai_place tank_marines_renew02/scorpion)
					(ai_vehicle_enter_immediate tank_marines_renew02/scorpion (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) "scorpion_d")
				)
			)
		)
	)
	;hog teleport
	(if (volume_test_object vol_ridge_renew_check (ai_vehicle_get_from_starting_location tank_marines_hog/driver01))
		(begin
			(object_teleport (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) flag_ridge_renew_tank)
			(if (<= (ai_living_count (ai_get_driver tank_marines_hog/driver01)) 0)
				(begin
					(ai_place tank_marines_renew02/hog)
					(ai_vehicle_enter_immediate tank_marines_renew02/hog (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) "warthog_d")
				)
			)
			(if (<= (ai_living_count (object_get_ai (vehicle_gunner (ai_vehicle_get_from_starting_location tank_marines_hog/driver01)))) 0)
				(begin
					(ai_place tank_marines_renew02/hog02)
					(ai_vehicle_enter_immediate tank_marines_renew02/hog02 (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) "warthog_g")
				)
			)
		)
	)
	;hog drop if dead
	(if (<= (object_get_health (ai_vehicle_get_from_starting_location tank_marines_hog/driver01)) 0)
		(begin
			(print "dropping new hog")
			(ai_place tank_pelican_drop)
			(ai_place tank_marines_hog)
			(ai_place tank_marines_renew)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) "warthog_d" (list_get (ai_actors tank_marines_renew) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) "warthog_g" (list_get (ai_actors tank_marines_renew) 0))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location tank_pelican_drop/driver01) "pelican_lc" (ai_vehicle_get_from_starting_location tank_marines_hog/driver01))
			(cs_run_command_script tank_pelican_drop/driver01 ridge_pelican_cs)
			(ai_set_objective tank_marines_hog tank_marines_obj)
		)
	)
)

(script command_script ridge_pelican_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by crater_pts/ridge_pelican_drop01)
	(cs_vehicle_boost TRUE)
	(cs_fly_by crater_pts/ridge_pelican_drop02 8)
	(cs_vehicle_boost FALSE)
	(cs_fly_by crater_pts/ridge_pelican_drop03 5)
	(cs_face TRUE crater_pts/ridge_pelican_drop_face)
	(cs_fly_to crater_pts/ridge_pelican_drop04 2)
	(sleep 50)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_lc")
	(cs_face FALSE crater_pts/ridge_pelican_drop_face)
	(cs_fly_by crater_pts/ridge_pelican_drop03 5)
	(cs_fly_by crater_pts/ridge_pelican_drop02 8)
	(cs_fly_by crater_pts/ridge_pelican_drop01)
	(cs_fly_to crater_pts/ridge_pelican_drop_exit)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant tank_saves01
	(sleep_until
		(and
			(<= (ai_living_count tank_cov_shades02/shade02) 0)
			(<= (ai_living_count tank_cov_shades03/shade03) 0)
			(<= (ai_living_count tank_cov_snipes02) 0)
			(volume_test_players vol_tank_saves01)
			(game_safe_to_save)
		)
	5)
	(game_save)
)

(script dormant TankRun_Start
	(sleep_until (= (current_zone_set_fully_active) 9))
	(print "Segment:TankRun")
	(data_mine_set_mission_segment "100_80_ridge01")
		(flock_create "crater_banshees01")
	(flock_create "crater_hornets01")
	(flock_create "crater_banshees02a")
	(flock_create "crater_banshees02b")
	(flock_create "crater_hornets02")
	(flock_create "crater_phantoms01")
	(flock_create "crater_pelicans01")
	(game_insertion_point_unlock 2)
	(object_create_folder watchtowers)
	(sleep_until (volume_test_players vol_ice_start) 5)
	(cinematic_set_chud_objective obj_2)
	(ai_set_objective cell_c_marines_obj/vehicles_to_ice path_b_marines_obj)
	
	(sleep_until (volume_test_players vol_100_title3) 5)
	(if (!= (game_insertion_point_get) 2) (wake 100_title3))
	
	;music
	(set g_music_100_07 FALSE)
	(set g_music_100_08 FALSE)
	
	(wake crater_entry_door_close)
	(ai_set_objective cell_c_marines_obj/vehicles_to_ice path_b_marines_obj)
	(game_save)
	(sleep_until (volume_test_players vol_ice_start02) 5)
	(ai_place ice_cov_mauler01)
	(sleep_until (volume_test_players vol_tankrun01_cov01))
	(ai_place ice_cov01)
	
	(sleep_until (volume_test_players vol_tankrun01_migrate) 5)
	(ai_erase_inactive all_enemies 0)
	(ai_set_objective all_enemies tank_cov_obj)
	(ai_set_objective path_b_marines_obj tank_marines_obj)
	(soft_ceiling_enable soft_bsp070 FALSE)
	(soft_ceiling_enable soft_bsp100 FALSE)
	(ai_place tank_cov_snipes01)
	;(ai_place tank_cov_mauler01)
	(ai_place tank_cov_shades01)
	
	;MAIN RIDGE
	;(sleep_until (volume_test_players vol_tankrun_banshees) 5)
	(sleep_until (= (current_zone_set_fully_active) 10))
	(object_destroy (ai_vehicle_get_from_starting_location lock_c_ext_elite_phantom/driver01))
	(ai_erase lock_c_ext_spark)
	(ai_erase cell_c_arbiter)
	
	;dialog
	(wake md_crater_citadel_insight)
	
	(game_save)
	(ai_place tank_cov_ghosts01)
	(print "banshees")
	(ai_place tank_cov_banshees01)
	(cs_run_command_script tank_cov_banshees01 tankrun_banshees_init_cs)
	(ai_disregard (ai_actors tank_cov_banshees01) TRUE)
	
	(sleep_until (volume_test_players vol_tankrun_start) 5)
	(wake ridge_nav_end)
	(add_recycling_volume ice_garbage 15 5)
	(game_save)
	(ai_place tank_cov_shades02)
	(ai_place tank_cov_shades03)
	(sleep 1)
	(ai_place tank_cov_mauler02)
	(sleep 1)
	(ai_place tank_cov_mauler03)
	(ai_place tank_cov_snipes02)
	(sleep 1)
	(wake tank_saves01)
	
	(sleep_until (volume_test_players vol_tankrun01_ghosts01) 5)
	(ai_place tank_cov_ghosts02)
	;(ai_place tank_cov_ghosts01)
	(sleep_until (volume_test_players vol_tankrun_turn02) 5)
	(if (= (game_is_cooperative) FALSE)
		(wake ridge_vehicle_renew)
	)
	;(game_save)
	(print "final ridge spawn")
	(ai_place tank_cov_wraiths01)
	;(ai_place tank_cov_ghosts02)
	(ai_place tank_cov_shades04)
	(ai_place tank_cov_snipes03)
	(sleep_until (volume_test_players vol_tankrun_turn03) 5)
	(add_recycling_volume vol_ridge_garbage01 10 10)
	(wake crater_saves01)
)

(script dormant tank_cleanup
	(sleep_forever tank_saves01)
	(cs_run_command_script ridge_cov cs_kill_ridge_cov)
	(sleep_until (not (objects_can_see_flag (player0) flag_crater_flocks_erase 30)))
	(flock_delete "crater_banshees02a")
	(flock_delete "crater_banshees02b")
	(flock_delete "crater_hornets02")
	(flock_delete "crater_phantoms01")
	(flock_delete "crater_pelicans01")
)

(script command_script cs_kill_ridge_cov
	(sleep (random_range 60 170))
	(ai_kill_silent ai_current_actor)
	(add_recycling_volume ridge_garbage 10 5)
)


;*********************************************************************;
;Crater Script
;*********************************************************************;
(script command_script crater_banshees_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 200)
	(wake crater_banshees_passive)
)

(script command_script crater_banshee_passive_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	;(sleep 120)
	(cs_enable_moving TRUE)
	;(sleep 120)
	;(cs_vehicle_boost FALSE)
	(sleep_forever)
)

(script dormant crater_vehicle_renew
	(ai_place crater_pelican_start)
	
	;renew hog
	(if (volume_test_object vol_crater_vehicle_renew (ai_vehicle_get_from_starting_location tank_marines_hog/driver01))
		(object_destroy (ai_vehicle_get_from_starting_location tank_marines_hog/driver01))
	)
	(if (<= (object_get_health (ai_vehicle_get_from_starting_location tank_marines_hog/driver01)) 0)
		(begin
			(ai_place crater_marines_hogs)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location crater_pelican_start/driver01) "pelican_lc" (ai_vehicle_get_from_starting_location crater_marines_hogs/driver01))
			(cs_run_command_script crater_pelican_start/driver01 crater_pelican_start_cs)
		)
	)
	
	;renew goose
	(if (volume_test_object vol_crater_vehicle_renew (ai_vehicle_get_from_starting_location tank_marines_goose/driver01))
		(object_destroy (ai_vehicle_get_from_starting_location tank_marines_goose/driver01))
	)
	(if (<= (object_get_health (ai_vehicle_get_from_starting_location tank_marines_goose/driver01)) 0)
		(begin
			(ai_place crater_marine_goose)
			(cs_run_command_script crater_pelican_start/driver01 crater_pelican_start_cs)
		)
	)
	
	;delete tank
	(if (volume_test_object vol_crater_vehicle_renew (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01))
		(object_destroy (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01))
	)
	
	;enable hog respawn
	(wake crater_hog_respawn)
)

(script dormant crater_hog_respawn
	(sleep_until (<= (ai_task_count crater_marines_obj/hog_follow) 0))
	(sleep_until (and (not (volume_test_players vol_crater_hog_respawn)) (objects_can_see_flag (player0) flag_crater_hog_respawn 30)))
	(print "respawning hog")
	(ai_place crater_marines_hogs)
	(sleep_until (<= (ai_task_count crater_marines_obj/hog_follow) 0))
	(sleep_until (and (not (volume_test_players vol_crater_hog_respawn)) (objects_can_see_flag (player0) flag_crater_hog_respawn 30)))
	(print "respawning hog")
	(ai_place crater_marines_hogs)
	(sleep_until (<= (ai_task_count crater_marines_obj/hog_follow) 0))
	(sleep_until (and (not (volume_test_players vol_crater_hog_respawn)) (objects_can_see_flag (player0) flag_crater_hog_respawn 30)))
	(print "respawning hog")
	(ai_place crater_marines_hogs)
)

(script dormant crater_banshees_passive
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_run_command_script crater_cov_banshees crater_banshee_passive_cs)
					(if FALSE
						(cs_run_command_script crater_cov_banshees/driver01 abort)
					)
					(sleep (random_range 120 500))
				)
				(begin
					(cs_run_command_script crater_cov_banshees crater_banshee_passive_cs)
					(cs_run_command_script crater_cov_banshees/driver02 abort)
					(sleep (random_range 120 500))
				)
				(begin
					(cs_run_command_script crater_cov_banshees crater_banshee_passive_cs)
					(cs_run_command_script crater_cov_banshees/driver03 abort)
					(sleep (random_range 120 500))
				)
				(begin
					(cs_run_command_script crater_cov_banshees crater_banshee_passive_cs)
					(cs_run_command_script crater_cov_banshees/driver04 abort)
					(sleep (random_range 120 500))
				)
				(begin
					(cs_run_command_script crater_cov_banshees crater_banshee_passive_cs)
					(cs_run_command_script crater_cov_banshees/driver05 abort)
					(sleep (random_range 120 500))
				)
			)
			FALSE
		)
	)
)

(script dormant crater_banshee_control
	(print "spawning banshees")
	(sleep_until (<= (ai_task_count crater_cov_obj/banshees) 1))
	(flock_stop "crater_banshees01")
	(add_recycling_volume vol_crater_garbage 20 5)
	(sleep (* 5 30))
	(ai_place crater_cov_banshees)
	(ai_prefer_target_ai crater_cov_banshees air_allies TRUE)
)

(script dormant crater_hornet_control
	(ai_place crater_hornets01a)
	(ai_place crater_hornets01b)
	(wake crater_hornet_reserve)
	(wake md_crater_hornets_inbound)
	(cs_run_command_script crater_hornets01a/driver01 crater_hornet01_cs)
	(cs_run_command_script crater_hornets01b/driver01 crater_hornet02_cs)
	
	(sleep_until
		(begin
			(sleep_until (<= (ai_task_count crater_marines_obj/hornet_gate) 1))
			(ai_place crater_hornets02a)
			(ai_place crater_hornets02b)
			(sleep 90)
			(<= (ai_living_count scarabs_obj) 0)
		)
	)
)

(script static boolean crater_hornet_driver_test
	(or
		(vehicle_test_seat_list (ai_player_get_vehicle_squad (player0)) "hornet_p_l" (players))
		(vehicle_test_seat_list (ai_player_get_vehicle_squad (player0)) "hornet_p_r" (players))
	)
)

(script dormant crater_scarab_target_prefer
	(ai_disregard (ai_actors crater_hornets01a) TRUE)
	(ai_disregard (ai_actors crater_hornets01b) TRUE)
	(sleep_until
		(or
			(any_players_in_vehicle)
			(volume_test_players vol_crater_main)
		)
	)
	(ai_disregard (ai_actors crater_hornets01a) FALSE)
	(ai_disregard (ai_actors crater_hornets01b) FALSE)
	(sleep_until
		(begin
			(sleep_until (crater_hornet_driver_test))
			(print "scarab prefers pelican")
			(ai_prefer_target_ai scarabs_obj crater_pelican_start TRUE)
			(sleep_until (not (crater_hornet_driver_test)))
			(print "scarab doesn't prefers pelican")
			(ai_prefer_target_ai scarabs_obj crater_pelican_start FALSE)
			FALSE
		)
	)
)

(script command_script crater_hornet_scarab_cs
	(print "checking for hornet landing")
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	;wait until hornet has a pilot
	(sleep_until (unit_in_vehicle ai_current_actor))
	;abort passengers on hornet
	(if 
		(or
			(vehicle_test_seat (ai_vehicle_get ai_current_actor) "hornet_p_l" (ai_get_unit ai_current_actor))
			(vehicle_test_seat (ai_vehicle_get ai_current_actor) "hornet_p_r" (ai_get_unit ai_current_actor))
		)
		(cs_run_command_script ai_current_actor abort)
	)
	(sleep (random_range 100 150))
	;(sleep_until (vehicle_test_seat (ai_vehicle_get ai_current_actor) "hornet_d" (ai_get_unit ai_current_actor)))
	(begin_random
		(begin
			;(if (>= (ai_living_count crater_cov_scarab01) 1)
			(if (not (object_model_target_destroyed cin_scarab_a "indirect_engine"))
				(cs_run_command_script crater_marines_obj/hornet_scarab crater_hornet_scarab01_cs)
			)
		)
		(begin
			;(if (>= (ai_living_count crater_cov_scarab02) 1)
			(if (not (object_model_target_destroyed cin_scarab_b "indirect_engine"))
				(cs_run_command_script crater_marines_obj/hornet_scarab crater_hornet_scarab02_cs)
			)
		)
	)
)

(script command_script crater_hornet_scarab01_cs
	;(ai_disregard (ai_actors crater_marines_obj/hornet_scarab) TRUE)
	;(ai_disregard (player0) TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(vs_abort_on_vehicle_exit TRUE)
	(cs_enable_targeting TRUE)
	(print "hornet flying to scarab01")
	(cs_face_object TRUE cin_scarab_a)
	(cs_fly_to scarab_top_pts/scarab01_high)
	;look go_to because scarab moved
	(sleep_until
		(begin
			(cs_fly_to scarab_top_pts/scarab01_low 1)
			(sleep 30)
			;wait until player jumps off
			(not (vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "" (players)))
		)
	)
	(print "player hopped off?")
	(cs_fly_to scarab_top_pts/scarab01_high)
	;wait until scarab core dead
	(sleep_until (object_model_target_destroyed cin_scarab_a "indirect_engine"))
	(print "player ready for pickup")
	(cs_face_object FALSE cin_scarab_a)
	(sleep_until
		(begin
			(cs_fly_to scarab_top_pts/scarab01_low 1)
			(sleep 30)
			;wait until player jumps off
			(or 
				(vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "" (players))
				(not (volume_test_players vol_scarab01_top))
			)
		)
	)
	(cs_fly_by scarab_top_pts/scarab01_high)
)

(script command_script crater_hornet_scarab02_cs
	;(ai_disregard (ai_actors crater_marines_obj/hornet_scarab) TRUE)
	;(ai_disregard (player0) TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(vs_abort_on_vehicle_exit TRUE)
	(cs_enable_targeting TRUE)
	(print "hornet flying to scarab02")
	(cs_face_object TRUE cin_scarab_b)
	(cs_fly_to scarab_top_pts/scarab02_high)
	;look go_to because scarab moved
	(sleep_until
		(begin
			(cs_fly_to scarab_top_pts/scarab02_low 1)
			(sleep 30)
			;wait until player jumps off
			(not (vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "" (players)))
		)
	)
	(print "player hopped off?")
	(cs_fly_to scarab_top_pts/scarab02_high)
	(sleep_until (object_model_target_destroyed cin_scarab_b "indirect_engine"))
	(print "player ready for pickup")
	(cs_face_object FALSE cin_scarab_b)
	(sleep_until
		(begin
			(cs_fly_to scarab_top_pts/scarab02_low 1)
			(sleep 30)
			;wait until player jumps off
			(or 
				(vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "" (players))
				(not (volume_test_players vol_scarab02_top))
			)
		)
	)
	(cs_fly_by scarab_top_pts/scarab02_high)
)

(script static void test_hornet_crater
	(kill_volume_disable kill_vol_tankrun)
	(wake crater_hornet_control)
	(set game_speed 6)
	(sleep 350)
	(set game_speed 1)
	(sleep_until 
		(or
			(volume_test_players vol_crater_main)
			(volume_test_players vol_crater_advance01)
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) "" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) "" (players))
		)
	)
	(wake vg_scarab01_anim)
	(wake vg_scarab02_anim)
	(ai_disregard (ai_actors crater_marines_obj) TRUE)
	(ai_disregard (player0) TRUE)
)

(script command_script crater_phantom_drop01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to crater_pts/phantom01a)
	(cs_fly_to crater_pts/phantom01b 1)
	(cs_fly_to crater_pts/phantom01c 1)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
	(cs_fly_to crater_pts/phantom01b)
	(cs_fly_to crater_pts/phantom01a)
	(cs_fly_to crater_pts/phantom01_exit)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

;(objects_can_see_flag <object_list> crater_ghost_viewtest <real>)
;(objects_distance_to_flag <object_list> crater_ghost_viewtest)

(script dormant crater_cov_ground_forces
	(print "spawning ghosts01")
	(ai_place crater_cov_ghosts01)
	(sleep_until (> (ai_living_count scarabs_obj) 0))
	(sleep_until (<= (ai_living_count scarabs_obj) 2))
	(wake md_crater_first_scarab_dead)
	(sleep_forever crater_banshee_control)
	;maybe spawn more guys
	(add_recycling_volume vol_crater_garbage 20 10)
	(if (<= (ai_living_count crater_cov_ghosts01) 2) (ai_place crater_cov_ghosts01))
	(ai_place crater_cov_mauler01)
	;(ai_place crater_cov_mauler02)
)

(script command_script crater_pelican_start_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_face TRUE crater_pts/hornet_face01)
	;(cs_face_object TRUE (ai_vehicle_get_from_starting_location crater_cov_scarab01/driver01))
	(cs_fly_by crater_pts/hornet01a 8)
	(cs_fly_to crater_pts/pelican_start01b 1)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location crater_pelican_start/driver01) "pelican_lc")
	;(cs_face FALSE crater_pts/hornet_face01)
	;(cs_fly_by crater_pts/hornet01a 8)
	;(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script crater_hornet01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_face TRUE crater_pts/hornet_face01)
	;(cs_face_object TRUE (ai_vehicle_get_from_starting_location crater_cov_scarab01/driver01))
	(cs_fly_by crater_pts/hornet01a 8)
	(cs_fly_to crater_pts/hornet01b)
	(sleep_until (volume_test_players vol_crater_hornet_drop02))
	(cs_fly_to crater_pts/hornet01c 1)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "hornet_d")
)

(script command_script crater_hornet02_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_face TRUE crater_pts/hornet_face01)
	;(cs_face_object TRUE (ai_vehicle_get_from_starting_location crater_cov_scarab01/driver01))
	(cs_fly_by crater_pts/hornet01a 8)
	(cs_fly_to crater_pts/hornet02b)
	(sleep_until (volume_test_players vol_crater_hornet_drop02))
	(cs_fly_to crater_pts/hornet02c 1)
	(if (= (game_is_cooperative) FALSE)
		;allow player pickup in single player
		(begin
			(cs_abort_on_damage TRUE)
			(sleep_until (vehicle_test_seat (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) "" (player0)))
		)
		;unload 2nd hornet in coop
		(begin
			(vehicle_unload (ai_vehicle_get ai_current_actor) "hornet_d")
		)
	)
)

(script command_script crater_hornet_exit_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by crater_pts/hornet_crater_exit01 8)
	(cs_fly_to crater_pts/hornet_crater_exit02 1)
	(sleep_until (not (vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "" (players))))
)

(script dormant crater_hornet_reserve
	(ai_disregard (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) TRUE)
	(ai_disregard (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) "hornet_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) "hornet_d" TRUE)
	
	(if (= (game_is_cooperative) FALSE)
		(begin
			(sleep_until (or
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) "" (players))
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) "" (players))
				(volume_test_players vol_crater_main))
			)
		)
		;give 2nd player a chance to get other hornet
		(begin
			(sleep_until (volume_test_players vol_crater_main))
			(sleep 100)
		)
	)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) FALSE)
	(ai_vehicle_enter crater_hornets01a/driver01 (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) "hornet_d")
	(ai_vehicle_enter crater_hornets01b/driver01 (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) "hornet_d")
	(sleep 60)
	(ai_disregard (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) FALSE)
	(ai_disregard (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) FALSE)
	(ai_enter_squad_vehicles all_allies)
)

(script dormant arbiter_return
	(sleep_until (<= (ai_task_count crater_cov_obj/wraith_gate) 0))
	(ai_place crater_elite_phantom)
	(ai_cannot_die crater_elite_phantom TRUE)
	(object_cannot_die (ai_vehicle_get_from_starting_location crater_elite_phantom/driver01) TRUE)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location crater_elite_phantom/driver01))
	(unit_set_active_camo (ai_vehicle_get_from_starting_location crater_elite_phantom/driver01) TRUE 0)
	(cs_run_command_script crater_elite_phantom/driver01 arbiter_return_cs)
	(sleep 60)
	(print "uncloaking")
	(unit_set_active_camo (ai_vehicle_get_from_starting_location crater_elite_phantom/driver01) FALSE 3)
	(wake crater_exit_navs)
)

(script command_script arbiter_return_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .7)
	(cs_fly_by crater_pts/arbiter_return01 1)
	(cs_vehicle_speed .3)
	(cs_fly_to crater_pts/arbiter_return02 1)
	(ai_place crater_spark)
	(if (= (game_is_cooperative) FALSE)
		(ai_trickle_via_phantom crater_elite_phantom/driver01 crater_arbiter)
	)
	(wake objective_3_clear)
	(wake objective_4_set)
	(sleep 30)
	(cs_fly_to crater_pts/arbiter_return01 2)
	(wake md_crater_platform)
	(sleep_until (volume_test_players vol_crater_end01))
	(game_save)
	(sleep_forever md_crater_platform)
	(sleep_forever md_crater_platform02)
	;give time for old lines to finish
	(sleep 60)
	(wake md_crater_platform_active)
	(sleep_forever)
)

(script dormant crater_exit_navs
	;citadel entrance
	(sleep_until (<= (ai_living_count crater_cov_obj) 0) 30 (* 30 20))
	(sleep (* 30 15))
	(if
		(and
			(not (volume_test_players vol_crater_end01))
			(<= (device_get_position citadel_entry_door01) 0)
		)
		(Hud_activate_team_nav_point_flag player hud_citadel_entrance 0)
	)
	(sleep_until
		(or
			(volume_test_players vol_crater_end01)
			(> (device_get_position citadel_entry_door01) 0)
		)
	)
	(hud_deactivate_team_nav_point_flag player hud_citadel_entrance)
	
	;citadel entrance02
	(sleep_until (volume_test_players vol_tapestry_migrate) 30 (* 30 50))
	(if (not (volume_test_players vol_tapestry_migrate))
		(hud_activate_team_nav_point_flag player hud_citadel_entrance02 0)
	)
	(sleep_until (volume_test_players vol_tapestry_migrate))
	(hud_deactivate_team_nav_point_flag player hud_citadel_entrance02)
)

(script dormant scarab_fire_control
	(sleep_until
		(begin
		(cond
			((volume_test_players vol_scarab01_radius) 
				(begin
					(ai_prefer_target_ai crater_cov_scarab02 crater_marines_obj TRUE)
					(sleep_until (not (volume_test_players vol_scarab01_radius)))
					(ai_prefer_target_ai crater_cov_scarab02 crater_marines_obj FALSE)
				)
			)
			((volume_test_players vol_scarab02_radius)
				(begin
					(ai_prefer_target_ai crater_cov_scarab01 crater_marines_obj TRUE)
					(sleep_until (not (volume_test_players vol_scarab02_radius)))
					(ai_prefer_target_ai crater_cov_scarab01 crater_marines_obj FALSE)
				)
			)
		)
		(<= (ai_living_count scarabs_obj) 0)
		)
	)
)

(script static void test
	(kill_volume_disable kill_vol_tankrun)
	(wake vg_scarab01_anim)
	(wake vg_scarab02_anim)
)

(script dormant vg_scarab01_anim
	(ai_place crater_cov_scarab01)
	(vs_custom_animation crater_cov_scarab01/driver01 FALSE objects\giants\scarab\cinematics\perspectives\100pb_scarab_orbital\100pb_scarab_orbital "100pb_cin_scarab_b_1" FALSE)
	(wake scarab01_brutes)
	;(object_cannot_take_damage (ai_get_object scarab01_brutes))
	(sleep (unit_get_custom_animation_time (ai_get_unit crater_cov_scarab01/driver01)))
	(vs_stop_custom_animation crater_cov_scarab01/driver01)
	(ai_force_active crater_cov_scarab01/driver01 TRUE)
	
)

(script dormant scarab01_brutes
	(sleep 100)
	(ai_place crater_cov_brutes01)
	(sleep_until (<= (ai_living_count crater_cov_scarab01) 0))
	(ai_kill crater_cov_brutes01)
)
	

(script dormant vg_scarab02_anim
	(ai_place crater_cov_scarab02)
	(vs_custom_animation crater_cov_scarab02/driver01 FALSE objects\giants\scarab\cinematics\perspectives\100pb_scarab_orbital\100pb_scarab_orbital "100pb_cin_scarab_a_1" FALSE)
	(wake scarab02_brutes)
	(sleep (unit_get_custom_animation_time (ai_get_unit crater_cov_scarab02/driver01)))
	(vs_stop_custom_animation crater_cov_scarab02/driver01)
	(ai_force_active crater_cov_scarab02/driver01 TRUE)
)

(script dormant scarab02_brutes
	(sleep 150)
	(ai_place crater_cov_brutes02)
	(sleep_until (<= (ai_living_count crater_cov_scarab02) 0))
	(ai_kill crater_cov_brutes02)
)

(script static void tapestry_coop_teleport
	(print "teleport backup")
	(if (not (volume_test_object vol_crater_tapestry_teleport (player0))) (object_teleport (player0) tapestry_coop_teleport_player0))
	(if (not (volume_test_object vol_crater_tapestry_teleport (player1))) (object_teleport (player1) tapestry_coop_teleport_player1))
	(if (not (volume_test_object vol_crater_tapestry_teleport (player2))) (object_teleport (player2) tapestry_coop_teleport_player2))
	(if (not (volume_test_object vol_crater_tapestry_teleport (player3))) (object_teleport (player3) tapestry_coop_teleport_player3))
)

(script dormant crater_saves01
	(sleep_until (and
		(volume_test_players vol_crater_saves01)
		(game_safe_to_save))
	5)
	(game_save)
)

(script dormant crater_start
	(flock_stop "cellc_hornets")
	(flock_stop "cellc_banshees")
	(object_create citadel_entry_door01)
	
	(sleep_until (volume_test_players vol_crater_hornet_drop) 5)
	(wake crater_hornet_control)
	(wake crater_scarab_target_prefer)
	
	(sleep_until (volume_test_players vol_scrarab_advance) 5)
	(kill_volume_disable kill_vol_tankrun)
	(ai_erase_inactive tank_cov_obj 0)
	(if (= (game_is_cooperative) TRUE)
		(sleep_until
			(or
				(not (volume_test_players vol_ridge_ground))
				(<= (ai_task_count tank_cov_obj/ground_unit_gate) 3)
			)
		)
	)
	(print "Segment:Crater")
	(data_mine_set_mission_segment "100_90_crater")
	(ai_set_objective all_enemies crater_cov_obj)
	(wake tank_cleanup)
	(game_save)
	(wake crater_banshee_control)
	(wake crater_cov_ground_forces)
	(wake crater_vehicle_renew)
	(sleep_until 
		(or
			(volume_test_players vol_crater_main)
			(volume_test_players vol_crater_advance01)
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location crater_hornets01a/driver01) "" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location crater_hornets01b/driver01) "" (players))
		)
	)
	(soft_ceiling_enable vehicle_110 TRUE)
	(wake vg_scarab01_anim)
	(wake vg_scarab02_anim)
	(sleep 100)
	(wake md_crater_two_scarabs)
	
	(sleep_until (<= (ai_living_count scarabs_obj) 0))
	(data_mine_set_mission_segment "100_95_crater_scarabs_dead")
	(wake crater_cleanup)
	(wake md_crater_second_scarab_dead)
	;(switch_zone_set set_citadel_start)
	(game_save)
	(wake arbiter_return)
	(sleep_until (volume_test_players vol_tapestry_migrate))
	(ai_set_objective crater_arbiter tapestry_obj)
	(sleep_forever crater_hog_respawn)
	(sleep_until (volume_test_players vol_crater_doorclose) 5)
	(device_set_position citadel_entry_door01 0)
	
	;music
	(wake music_100_10)
	
	(sleep_until (<= (device_get_position citadel_entry_door01) 0) 5)
	(ai_bring_forward (ai_get_object crater_arbiter/arbiter) 4)
	(zone_set_trigger_volume_enable begin_zone_set:set_citadel_tapestry TRUE)
	
	(sleep_until (= (current_zone_set) 12) 1)
	(wake cor01)
	(tapestry_coop_teleport)
	
	(sleep_until (= (current_zone_set_fully_active) 12) 1)
	;(sleep_until (volume_test_players vol_tapestry_start) 1)
	(wake md_truth_tapestry_start)
	(sleep 50)
	(sleep_forever md_truth_tapestry_start)
	
	(cinematic_fade_to_black)
	(ai_erase crater_arbiter)
	(sleep 1)
	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)
	(ai_allegiance flood player)
	(ai_allegiance player flood)
	(ai_allegiance flood human)
	(ai_allegiance human flood)
	(ai_allegiance flood covenant)
	(ai_allegiance covenant flood)
	(object_destroy rind_elevator_start)
	(object_destroy_folder watchtowers)
	
	(print "Segment:Cinematic:100lc_miranda")
	(data_mine_set_mission_segment "100lc_Miranda")
	
	(if g_play_cinematics
		(begin
			(set g_cinematic_running TRUE)
			(if (cinematic_skip_start)
				(begin
					; snap to black 
					(cinematic_snap_to_black)
					
					(if debug (print "100lc_miranda"))
					(100lc_miranda)
					
					; cleanup cinematic scripts 
					(100lc_miranda_cleanup)
	
					; prepare to switch to set_chief_crater 
					(prepare_to_switch_to_zone_set set_citadel_ring)
					
						(if (cinematic_skip_start)
							(begin
								(if debug (print "100lc_miranda_part2"))
								(100lc_miranda_part2)
								
								(cinematic_snap_to_black)
								
								; cleanup cinematic scripts 
								(100lc_miranda_part2_cleanup)
								
								; switch to set_chief_crater 
								(switch_zone_set set_citadel_ring)
								(sleep 1)
								
									(if (cinematic_skip_start)
										(begin
											(if debug (print "100lc_miranda_part3"))
											(100lc_miranda_part3)
										)
									)
							)
						)
				)
			)
			(cinematic_skip_stop)
			(object_teleport (player0) teleport_ring_player0)
			(object_teleport (player1) teleport_ring_player1)
			(object_teleport (player2) teleport_ring_player2)
			(object_teleport (player3) teleport_ring_player3)
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
		)
		;else
		(begin
			(print "skipping '100lc_miranda' cinematic")
			(object_teleport (player0) teleport_ring_player0)
			(object_teleport (player1) teleport_ring_player1)
			(object_teleport (player2) teleport_ring_player2)
			(object_teleport (player3) teleport_ring_player3)
		)
	)
	; cleanup cinematic scripts 
	(100lc_miranda_cleanup)
	(100lc_miranda_part2_cleanup)
	(100lc_miranda_part3_cleanup)

	(sound_class_set_gain "" 1 30)
	
	(switch_zone_set set_citadel_ring)
	(sleep 1)
	(object_set_region_state rose_window window destroyed)
	
	(print "design:lighting rings")
	;(object_set_function_variable haloring_alpha bloom .15 0)
	(object_set_function_variable haloring_beta bloom .15 0)
	(object_set_function_variable haloring_gamma bloom .15 0)
	(object_set_function_variable haloring_delta bloom .15 0)
	(object_set_function_variable haloring_epsilon bloom .15 0)
	(object_set_function_variable haloring_eta bloom .15 0)
	(object_set_function_variable haloring_zeta bloom .15 0)
	
	(set g_cinematic_running FALSE)
	(game_save_immediate)
	(cinematic_fade_to_title)
)



(script dormant crater_cleanup
	(flock_delete "crater_banshees01")
	;(sleep_forever crater_banshee_control)
	(sleep_forever crater_banshees_passive)
	(sleep_forever crater_scarab_target_prefer)
	(sleep_until (= (current_zone_set) 12) 1)
	(sleep_forever crater_cov_ground_forces)
	(object_set_persistent (ai_vehicle_get_from_starting_location crater_cov_scarab01/driver01) FALSE)
	(object_set_persistent (ai_vehicle_get_from_starting_location crater_cov_scarab02/driver01) FALSE)
)

;*********************************************************************;
;Ring Room Script
;*********************************************************************;
(script dormant flood_infect_spawn
	(ai_place ring_flood_part01 4)
	(sleep_until
		(begin
			(sleep_until (<= (ai_swarm_count ring_flood_part01) 20) 5)
			
			(if (not (objects_can_see_flag (players) flag_ring_flood_part01 30))
				(ai_place ring_flood_part01 1)
			)
			;(sleep 60)
			FALSE
		)
	)
)

(script dormant ring_arbiter_control
	(sleep_until (volume_test_players vol_ring02_init))
	(sleep_until (<= (ai_living_count ring_cov_obj) 0))
	(print "updating arbiter objective")
	(ai_set_objective ring_marines_obj ring02_marines_obj)
	(sleep_until (volume_test_players vol_ring03_init))
	;(sleep_until (<= (ai_living_count ring02_cov_obj) 0))
	(ai_set_objective all_allies ring03_marines_obj)
	(sleep_until (volume_test_players vol_ring03_halfway))
	(ai_bring_forward (ai_get_object ring_arbiter/arbiter) 4)
)

(script command_script ring_bugger_exit_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep (random_range 0 100))
	(cs_enable_moving FALSE)
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)
	(cs_fly_to ring03_pts/bugger_exit)
	(ai_erase ai_current_actor)
)

(script dormant ring_flak
	(ai_place ring_cov_flak)
	(cs_run_command_script ring_cov_flak/right ring_flak_right_cs)
	(cs_run_command_script ring_cov_flak/left ring_flak_left_cs)
	(sleep_until (volume_test_players vol_ring01_back))
	(cs_run_command_script ring_cov_flak abort)
	(if
		(or
			;spawn turret on heroic/legendary
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
			(if (<= (ai_living_count ring_cov_flak) 1)
				(ai_place ring_cov_flak02)
			)
	)
)

(script command_script ring_flak_right_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ring01_pts/flak_right 1)
	(cs_enable_targeting TRUE)
	(sleep_forever)
)

(script command_script ring_flak_left_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ring01_pts/flak_left 1)
	(cs_enable_targeting TRUE)
	(sleep_forever)
)

(script dormant ring_cin_inf_spawn
	(sleep 60)
	(vs_swarm_to ring_cin_inf01 FALSE ring01_pts/cin_swarm01 1)
	(sleep 110)
	(vs_swarm_to ring_cin_inf01 FALSE ring01_pts/cin_swarm02 1)
	(sleep 160)
)

(script dormant ring_start
	(print "Segment:Ring")
	(data_mine_set_mission_segment "100_100_ring_room01")
	(sleep_until (not g_cinematic_running) 1)
	(wake 100_title4)
	(wake ring_holo_truth)
	(device_set_position_immediate citadel_dias 1)
	(object_create ring_pelican)
	(scenery_animation_start ring_pelican objects\vehicles\pelican\pelican "combat:fully_opened")
	(object_create rind_elevator_start)
	(if (= (game_is_cooperative) FALSE)
		(ai_place ring_arbiter)
	)
	(ai_cannot_die ring_arbiter TRUE)
	(wake ring_arbiter_control)
	(wake flood_infect_spawn)
	(ai_place ring_fore_part01_pure01)
	(ai_place ring_fore_part01_pure02)
	(sleep_until (volume_test_players vol_ring01_start) 5 (* 30 3))
	(ai_place ring_cov_part01)
	(ai_place ring_cov_part01b)
	(wake ring_flak)
	;(ai_place ring_fore_part01)
	;(ai_prefer_target_team ring_fore_part01 flood)
	;(ai_prefer_target_team all_enemies player)
	(sleep_until (or
		(<= (ai_task_count ring_cov_obj/leader_init) 5)
		 (volume_test_players vol_ring01_back))
	)
	(print "spawning cov/flood")
	;(ai_place ring_cov_part01c)
	(if
		(or
			;spawn turret on heroic/legendary
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		(ai_place ring_cov_turret)
	)
	(ai_place ring_flood_part01c)
	(sleep_until (volume_test_players vol_ring02_init) 5)
	(wake ring02_start)
	
	;music
	(wake music_100_11)
	(set g_music_100_11 TRUE)
	(wake music_100_12)
	(set g_music_100_12 TRUE)
)

(script dormant flood_infect_spawn02
	(sleep_until (volume_test_players vol_flood02_start) 5)
	(ai_place ring_flood_part02)
	(ai_magically_see ring_flood_part02 all_enemies)
	(sleep_until
		(begin
			(sleep_until (<= (ai_swarm_count ring_flood_part02) 20))
			(if (not (objects_can_see_flag (player0) flag_ring_flood02 30))
				(ai_place ring_flood_part02)
			)
			(sleep 60)
			FALSE
		)
	)
)

(script dormant ring_door03a_control
	(sleep_until 
		(and
			(not (volume_test_object vol_ring03_init ring_cov_part02_chief/chief))
			(not (volume_test_object vol_ring03_init ring_cov_part02_chief/body1))
			(not (volume_test_object vol_ring03_init ring_cov_part02_chief/body2))
		)
	5)
	(sleep_until (<= (device_get_position ring_door03a) 0) 1)
	(device_set_power ring_door03a 0)
	(sleep_until (<= (ai_living_count ring_cov_part02_chief/chief) 0) 5)
	(device_set_power ring_door03a 1)
)

(script dormant ring_flak02
	(sleep_until 
		(or
			(volume_test_players vol_ring02_middle)
			(<= (ai_task_count ring02_cov_obj/brute_jetpacks) 2)
		)
	)
	(ai_place ring_cov_part02_flak01)
	(cs_run_command_script ring_cov_part02_flak01/right ring_flak02_right_cs)
	(cs_run_command_script ring_cov_part02_flak01/left ring_flak02_left_cs)
	(sleep_until (volume_test_players vol_ring02_back))
	(cs_run_command_script ring_cov_part02_flak01 abort)
)

(script command_script ring_flak02_right_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ring02_pts/flak_right 1)
	(cs_enable_targeting TRUE)
	(sleep_forever)
)

(script command_script ring_flak02_left_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ring02_pts/flak_left 1)
	(cs_enable_targeting TRUE)
	(sleep_forever)
)

(script dormant ring02_start
	(print "Segment:Ring02")
	(data_mine_set_mission_segment "100ld_Confront_Truth")
	(if
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		(wake ring_flak02)
	)
	(game_save)
	(sleep_forever flood_infect_spawn)
	(ai_disposable ring_flood_part01 TRUE)
	(wake flood_infect_spawn02)
	(ai_place ring_cov_part02_chief)
	(ai_place ring_cov_part02_brutes01)
	;(ai_place ring_cov_part02_brutes02)
	(ai_place ring_cov_part02_brutes03)
	(cs_run_command_script ring_cov_part02_brutes03 pause_forever)
	(sleep_until (volume_test_players vol_ring02_start) 5)
	(wake ring_nav_end)
	(wake ring_door03a_control)
	(print "go crazy")
	(cs_run_command_script ring_cov_part02_brutes03 abort)
	(ai_magically_see all_enemies all_allies)
	(ai_magically_see all_allies all_enemies)
	(sleep_until (volume_test_players vol_ring03_init) 5)
	(wake ring03_start)
	(sleep_forever flood_infect_spawn02)
)

(script dormant ring03_flood_swarm
	(sleep_until (volume_test_players ring03_swarm) 1)
	(ai_place ring_flood_part03_com)
	(wake ring03_swarm01)
	(sleep 150)
	(wake ring03_swarm02)
)

(script dormant ring03_swarm01
	(ai_place ring_flood_part03a)
	(ai_place ring_flood_part03b)
	(vs_swarm_to ring_flood_part03a FALSE ring03_pts/flood_swarm01a 1)
	(sleep 60)
	(vs_swarm_to ring_flood_part03b FALSE ring03_pts/flood_swarm01b 1)
	(sleep 380)
	(vs_swarm_to ring_flood_part03a FALSE ring03_pts/flood_swarm02 1)
	(sleep 60)
	(vs_swarm_to ring_flood_part03b FALSE ring03_pts/flood_swarm02 1)
	(sleep 380)
)

(script dormant ring03_swarm02
	(ai_place ring_flood_part03c)
	(vs_swarm_to ring_flood_part03c FALSE ring03_pts/flood_swarm01a 1)
	(sleep 90)
	(ai_place ring_flood_part03d)
	(vs_swarm_to ring_flood_part03d FALSE ring03_pts/flood_swarm01b 1)
	(sleep 330)
	(vs_swarm_to ring_flood_part03c FALSE ring03_pts/flood_swarm02 1)
	(sleep 60)
	(vs_swarm_to ring_flood_part03d FALSE ring03_pts/flood_swarm02 1)
	(sleep 380)
)

(script dormant ring03_start
	(print "Segment:Ring03")
	(device_set_power ring_door03a 1)
	(if (volume_test_players vol_ring03_cheat)
		(ai_set_objective ring02_cov_obj ring03_cov_obj)
	)
	(game_save)
	(sleep 1)
	(wake ring03_flood_swarm)
	;if player cheats over the midrooms then wait for them to kill everybody
	(sleep_until 
		(or
			(<= (ai_living_count ring03_cov_obj) 0)
			(volume_test_players vol_ring03_end)
		)
	)
	
	(device_set_power ring_lightbridge_control 1)
	(sleep_until 
		(or
			(> (device_get_position ring_lightbridge_control) 0)
			(volume_test_players vol_ring03_end)
		)		
	1)
	(device_set_position ring_lightbridge_control 1)
	(device_operates_automatically_set ring_lightbridge_switch FALSE)
	(device_set_position ring_lightbridge_switch 0)

	(sleep_forever ring03_flood_swarm)
	(object_create lightbridge_ringroom)
	(device_set_position lightbridge_ringroom 1)
	
	;music
	(set g_music_100_11 FALSE)
	(set g_music_100_12 FALSE)
	
	; fade to black 
	(cinematic_fade_to_black)

	(object_destroy ring_pelican)
	(sleep 1)
	(wake objective_4_clear)
	(ai_erase_all)
	(if g_play_cinematics
		(begin
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
			(object_teleport (player0) teleport_ring_exit_player0)
			(object_teleport (player1) teleport_ring_exit_player1)
			(object_teleport (player2) teleport_ring_exit_player2)
			(object_teleport (player3) teleport_ring_exit_player3)
			(if (cinematic_skip_start)
				(begin
					(100ld_confront_truth)
					
					; cleanup cinematic scripts 
					(100ld_confront_truth_cleanup)
				)
			)
			(cinematic_skip_stop)
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
		)
		;else
		(begin
			(print "skipping '100lc_miranda' cinematic")
			(object_teleport (player0) teleport_ring_exit_player0)
			(object_teleport (player1) teleport_ring_exit_player1)
			(object_teleport (player2) teleport_ring_exit_player2)
			(object_teleport (player3) teleport_ring_exit_player3)
		)
	)
	
	(print "design:unlighting rings")
	(object_set_function_variable haloring_alpha bloom 0 0)
	(object_set_function_variable haloring_beta bloom 0 0)
	(object_set_function_variable haloring_gamma bloom 0 0)
	(object_set_function_variable haloring_delta bloom 0 0)
	(object_set_function_variable haloring_epsilon bloom 0 0)
	(object_set_function_variable haloring_eta bloom 0 0)
	(object_set_function_variable haloring_zeta bloom 0 0)
	
	(set g_truthdead TRUE)
	(object_create truth_flood)
	(sleep 1)
	;this is to fix a vol that is used for jumping over bridge in last cinematic
	(kill_volume_disable kill_vol_ring_end)
	(object_destroy ring_shaft_blocker)
	(wake gs_award_secondary_skull)
	(game_save_immediate)
	
	; fade in 
	(cinematic_fade_to_gameplay)
	
	;music
	(wake music_100_13)
	(set g_music_100_13 TRUE)
)

(script dormant ringex03_drop01
	(print "dropping flood")
	(ai_place ringex_flood_part03_drop01)
	(sleep (random_range 60 120))
	(ai_place ringex_flood_part03_drop01)
	(sleep (random_range 60 120))
	(ai_place ringex_flood_part03_drop01)
)

(script dormant ringex02_drop01
	(ai_place ringex_flood_part02_drop01)
	(sleep (random_range 60 120))
	(ai_place ringex_flood_part02_drop01)
	(sleep (random_range 60 120))
	(ai_place ringex_flood_part02_drop01)
)

(script command_script flood03_jump_cs
	(sleep (random_range 0 100))
	(cs_jump_to_point (random_range 8 10) 4)
)

(script command_script flood02_jump01_cs
	(sleep (random_range 0 100))
	(cs_jump_to_point (random_range 11 13) 6)
)

(script command_script flood02_jump02_cs
	(sleep (random_range 0 100))
	(cs_jump_to_point (random_range 8 12) 5)
)

(script command_script flood02_jump03_cs
	(sleep (random_range 0 100))
	(cs_jump_to_point (random_range 5 6) 4)
)

(script command_script flood01_jump01_goto_cs
	(sleep (random_range 0 60))
	(begin_random
		(begin
			(cs_go_to ring01_pts/jump01)
			(cs_face_player TRUE)
			(sleep 30)
			(cs_run_command_script ai_current_actor flood01_jump01_cs)
		)
		(begin
			(cs_go_to ring01_pts/jump02)
			(cs_face_player TRUE)
			(sleep 30)
			(cs_run_command_script ai_current_actor flood01_jump01_cs)
		)
		(begin
			(cs_go_to ring01_pts/jump03)
			(cs_face_player TRUE)
			(sleep 30)
			(cs_run_command_script ai_current_actor flood01_jump01_cs)
		)
		(begin
			(cs_go_to ring01_pts/jump04)
			(cs_face_player TRUE)
			(sleep 30)
			(cs_run_command_script ai_current_actor flood01_jump01_cs)
		)
		(begin
			(cs_go_to ring01_pts/jump05)
			(cs_face_player TRUE)
			(sleep 30)
			(cs_run_command_script ai_current_actor flood01_jump01_cs)
		)
	)
)

(script command_script flood01_jump01_cs
	(sleep (random_range 0 90))
	(cs_jump_to_point (random_range 4 5) 5)
)

(script dormant ringex01_drop01
	(ai_place ringex_part01_drop01)
	(sleep (random_range 10 70))
	(ai_place ringex_part01_drop01)
	(sleep (random_range 10 70))
	(ai_place ringex_part01_drop01)
	(sleep (random_range 10 70))
	(ai_place ringex_part01_drop01)
	(sleep (random_range 10 70))
	(ai_place ringex_part01_drop01)
	(sleep (random_range 10 70))
	(ai_place ringex_part01_drop01)
)

(script dormant ring01_swarm01
	(vs_swarm_to ringex_part01_inf01 FALSE ring01_pts/swarm01 1)
	(sleep 150)
)

(script dormant ring_exit
	(sleep_until g_truthdead 1)
	(print "Segment:Ring04")
	(data_mine_set_mission_segment "100_110_ring_room_escape")
	
	;zone triggers
	(zone_set_trigger_volume_enable begin_zone_set:set_citadel_ring02 FALSE)
	(zone_set_trigger_volume_enable zone_set:set_citadel_ring02 FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_halo TRUE)
	
	;reset objectives
	(ai_set_task_condition ring01_flood_obj FALSE)
	(ai_set_task_condition ring02_marines_obj FALSE)
	(ai_set_task_condition ring02_forerunner_obj FALSE)
	(ai_set_task_condition ring03_marines_obj FALSE)
	(ai_set_task_condition ring03_flood_obj FALSE)
	
	; create cortana beacon 
	(object_create_anew ring_cortana_light)
	
	(wake md_head_back)
	(wake ring_nav_exit_end)
	(ai_allegiance_remove flood player)
	(ai_allegiance_remove player flood)
	(ai_allegiance_remove flood human)
	(ai_allegiance_remove human flood)
	(ai_allegiance_remove flood covenant)
	(ai_allegiance_remove covenant flood)
	;(ai_prefer_target_team ring_forerunners flood)
	(ai_prefer_target_team flood_all sentinel)
	;(wake ringex03_drop02)
	(if (= (game_is_cooperative) FALSE)
		(ai_place ringex_allies)
	)
	(ai_place ringex_flood_part03_com01)
	(ai_place ringex_flood_part03_infect02)
	(wake cor02)
	(game_save_immediate)
	(sleep_until (volume_test_players vol_ringex03_start) 5)
	(ai_place ringex_flood_part03_infect01)
	(sleep_until (volume_test_players vol_ringex03_jump01))
	(wake ringex03_drop01)
	;(ai_place ringex_flood_part03_drop01)
	(ai_place ringex_part03_jump01)
	(cs_run_command_script ringex_part03_jump01 flood03_jump_cs)
	
	(sleep_until (volume_test_players vol_ringex03_halfway))
	(sleep_until (volume_test_players vol_ringex03_com03) 5)
	(ai_place ringex_part03_com03)
	(if
		(or
			;spawn more banshees on heroic/legendary
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		(ai_place ringex_part03_car01)
	)
	
	;Part B
	(sleep_until (volume_test_players vol_ringex03_end) 5)
	(ai_set_objective all_allies ring02_marines_obj)
	(ai_place ringex_flood_part02_infect01)
	(sleep 1)
	(ai_place ringex_fore_part02_01)
	(ai_dont_do_avoidance ringex_fore_part02_01 TRUE)
	(sleep 1)
	;(ai_place ringex_flood_part02_com01)
	(sleep 1)
	(ai_place ringex_flood_part02_com02)
	(sleep_until (volume_test_players vol_ringex02_jump01) 5)
	(ai_place ringex_part02_jump01)
	(cs_run_command_script ringex_part02_jump01 flood02_jump01_cs)
	
	(sleep_until (volume_test_players vol_ringex02_halfway) 5)
	(ai_place ringex_part02_inf01)
	(ai_place ringex_part02_jump02)
	(cs_run_command_script ringex_part02_jump02 flood02_jump02_cs)
	(wake ringex02_drop01)
	(sleep_until (volume_test_players vol_ringex02_halfway02) 5)
	(ai_place ringex_part02_inf01)
	(ai_place ringex_part02_jump03)
	(cs_run_command_script ringex_part02_jump03 flood02_jump03_cs)
	(ai_place ringex_part02_com03)
	(if
		(or
			;spawn more banshees on heroic/legendary
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		(ai_place ringex_flood_part02_car03)
	)
	(sleep 1)
	(sleep_until (volume_test_players vol_ringex02_end) 5)
	(ai_set_objective all_allies ring_marines_obj)
	(ai_set_objective ring02_forerunner_obj ring01_forerunner_obj)
;	(wake cor03)
	(ai_place ringex_part01_inf02)
	(ai_place ringex_flood_part01_car01)
	(ai_place ringex_flood_part01_com01)
	(ai_place ringex_part01_inf01)
	(sleep_until (volume_test_players vol_ringex01_halfway) 5)
	(ai_set_objective all_allies ring_elevator)
	(wake ring01_swarm01)
	(cs_run_command_script ringex_flood_part01_com01 flood01_jump01_goto_cs)
	(sleep_until (volume_test_players vol_ringex01_end) 5)
	(wake ringex01_drop01)
	
	(sleep_until (volume_test_players vol_ringex01_elevator_start) 5)
	(ai_bring_forward (ai_get_object ringex_allies/arbiter) 6)

	(sleep_until (volume_test_players vol_ringex04_end) 1)
	;(Hud_deactivate_team_nav_point_flag player nav_temp_cortana_ring)
	(wake objective_5_clear)
	
	(print "Segment:Cinematic:100le_halo_reveal")
	(data_mine_set_mission_segment "100le_Halo_Reveal")
	
		
	; fade to black 
	(cinematic_snap_to_black)
	(sleep 150)

	;music
	(set g_music_100_13 FALSE)

	(game_award_level_complete_achievements)
	(switch_zone_set set_halo02)
	(sleep_until (= (current_zone_set_fully_active) 16) 1)
	(sleep 1)

		
	(if g_play_cinematics
		(begin
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
			(ai_erase_all)
			(if (cinematic_skip_start)
				(begin
					(print "'100le_halo_reveal' cinematic cannot be compiled at this time")
					(100le_halo_reveal)
					
					; cleanup cinematic scripts 
					(100le_halo_reveal_cleanup)
				)
			)
			(cinematic_skip_stop)
		)
		;else
		(begin
			(print "skipping '100le_halo_reveal' cinematic")
		)
	)
	; turn off all game sounds 
	(sound_class_set_gain "" 0 0)
	
	(sleep 5)
	(end_mission)
)

;*********************************************************************;
;vehicle unload Scripts
;*********************************************************************;
(script dormant cell_b_vehicle_unload00
	(set testVehicle00 (ai_player_get_vehicle_squad (player0)))
	(sleep_until 
		(and
			(volume_test_object vol_cell_b_hornet_pickup (player0))
			(not (unit_in_vehicle (unit (player0))))
		)
	5)
	(ai_vehicle_reserve testVehicle00 TRUE)
	(vehicle_unload testVehicle00 "")
	(set testVehicle00 NONE)
)

(script dormant cell_b_vehicle_unload01
	(set testVehicle01 (ai_player_get_vehicle_squad (player0)))
	(sleep_until 
		(and
			(volume_test_object vol_cell_b_hornet_pickup (player0))
			(not (unit_in_vehicle (unit (player0))))
		)
	5)
	(ai_vehicle_reserve testVehicle01 TRUE)
	(vehicle_unload testVehicle01 "")
	(set testVehicle01 NONE)
)

(script dormant cell_b_vehicle_unload02
	(set testVehicle02 (ai_player_get_vehicle_squad (player0)))
	(sleep_until 
		(and
			(volume_test_object vol_cell_b_hornet_pickup (player0))
			(not (unit_in_vehicle (unit (player0))))
		)
	5)
	(ai_vehicle_reserve testVehicle02 TRUE)
	(vehicle_unload testVehicle02 "")
	(set testVehicle02 NONE)
)

(script dormant cell_b_vehicle_unload03
	(set testVehicle03 (ai_player_get_vehicle_squad (player0)))
	(sleep_until 
		(and
			(volume_test_object vol_cell_b_hornet_pickup (player0))
			(not (unit_in_vehicle (unit (player0))))
		)
	5)
	(ai_vehicle_reserve testVehicle03 TRUE)
	(vehicle_unload testVehicle03 "")
	(set testVehicle03 NONE)
)

(script dormant hornet_control_player
	(if (= (game_is_cooperative) FALSE)
		(wake hornet_control_player00)
		(begin
			(wake hornet_control_player00)
			(wake hornet_control_player01)
			(wake hornet_control_player02)
			(wake hornet_control_player03)
		)
	)
)

;*********************************************************************;
;Hornet Control Scripts
;*********************************************************************;
(script dormant hornet_control_player00
	(sleep_until (volume_test_object vol_cell_b_objectives (player0)))
	(sleep_forever cell_b_vehicle_unload00)
	(ai_set_objective beach_marines_obj/player_hornet cell_b_marines_obj)
	(sleep_until
		(begin
			(sleep_until
				(or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player0))
				)
			5)
			
			(cond
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player0)) 
					(begin
						(set testVehicle00 (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
						(set testAIsquad00 cell_b_hornets01a)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player0))
					(begin
						(set testVehicle00 (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
						(set testAIsquad00 cell_b_hornets01b)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player0))
					(begin
						(set testVehicle00 (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
						(set testAIsquad00 cell_b_hornets_3player)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player0))
					(begin
						(set testVehicle00 (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))
						(set testAIsquad00 cell_b_hornets_4player)
					)
				)
			)
			
			(ai_vehicle_reserve testVehicle00 FALSE)
			(ai_enter_squad_vehicles all_allies)
			(sleep_until
				(not (or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player0))
					)
				)
			5)
			(ai_vehicle_exit testAIsquad00)
			(ai_vehicle_reserve testVehicle00 TRUE)
			FALSE
		)
	)
)

(script dormant hornet_control_player01
	(sleep_until (volume_test_object vol_cell_b_objectives (player1)))
	(sleep_forever cell_b_vehicle_unload01)
	(ai_set_objective beach_marines_obj/player_hornet cell_b_marines_obj)
	(sleep_until
		(begin
			(sleep_until
				(or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player1))
				)
			5)
			
			(cond
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player1)) 
					(begin
						(set testVehicle01 (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
						(set testAIsquad01 cell_b_hornets01a)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player1))
					(begin
						(set testVehicle01 (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
						(set testAIsquad01 cell_b_hornets01b)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player1))
					(begin
						(set testVehicle01 (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
						(set testAIsquad01 cell_b_hornets_3player)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player1))
					(begin
						(set testVehicle01 (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))
						(set testAIsquad01 cell_b_hornets_4player)
					)
				)
			)
			
			(ai_vehicle_reserve testVehicle01 FALSE)
			(ai_enter_squad_vehicles all_allies)
			(sleep_until
				(not (or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player1))
					)
				)
			5)
			(ai_vehicle_exit testAIsquad01)
			(ai_vehicle_reserve testVehicle01 TRUE)
			FALSE
		)
	)
)

(script dormant hornet_control_player02
	(sleep_until (volume_test_object vol_cell_b_objectives (player2)))
	(sleep_forever cell_b_vehicle_unload02)
	(ai_set_objective beach_marines_obj/player_hornet cell_b_marines_obj)
	(sleep_until
		(begin
			(sleep_until
				(or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player2))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player2))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player2))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player2))
				)
			5)
			
			(cond
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player2)) 
					(begin
						(set testVehicle02 (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
						(set testAIsquad02 cell_b_hornets01a)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player2))
					(begin
						(set testVehicle02 (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
						(set testAIsquad02 cell_b_hornets01b)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player2))
					(begin
						(set testVehicle02 (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
						(set testAIsquad02 cell_b_hornets_3player)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player2))
					(begin
						(set testVehicle02 (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))
						(set testAIsquad02 cell_b_hornets_4player)
					)
				)
			)
			
			(ai_vehicle_reserve testVehicle02 FALSE)
			(ai_enter_squad_vehicles all_allies)
			(sleep_until
				(not (or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player2))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player2))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player2))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player2))
					)
				)
			5)
			(ai_vehicle_exit testAIsquad02)
			(ai_vehicle_reserve testVehicle02 TRUE)
			FALSE
		)
	)
)

(script dormant hornet_control_player03
	(sleep_until (volume_test_object vol_cell_b_objectives (player3)))
	(sleep_forever cell_b_vehicle_unload03)
	(ai_set_objective beach_marines_obj/player_hornet cell_b_marines_obj)
	(sleep_until
		(begin
			(sleep_until
				(or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player3))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player3))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player3))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player3))
				)
			5)
			
			(cond
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player3)) 
					(begin
						(set testVehicle03 (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01))
						(set testAIsquad03 cell_b_hornets01a)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player3))
					(begin
						(set testVehicle03 (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01))
						(set testAIsquad03 cell_b_hornets01b)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player3))
					(begin
						(set testVehicle03 (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01))
						(set testAIsquad03 cell_b_hornets_3player)
					)
				)
				((vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player3))
					(begin
						(set testVehicle03 (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01))
						(set testAIsquad03 cell_b_hornets_4player)
					)
				)
			)
			
			(ai_vehicle_reserve testVehicle03 FALSE)
			(ai_enter_squad_vehicles all_allies)
			(sleep_until
				(not (or
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01a/driver01) "hornet_d" (player3))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets01b/driver01) "hornet_d" (player3))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_3player/driver01) "hornet_d" (player3))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cell_b_hornets_4player/driver01) "hornet_d" (player3))
					)
				)
			5)
			(ai_vehicle_exit testAIsquad03)
			(ai_vehicle_reserve testVehicle03 TRUE)
			FALSE
		)
	)
)

;*********************************************************************;
;Objective Scripts
;*********************************************************************;
(script dormant objective_1_set
	(print "new objective set:")
	(print "Deactive the first Shield generator")
	(objectives_show_up_to 0)
	;(cinematic_set_chud_objective obj_0)
	(wake objective_1_set_hud)
)

;this is a special case for first obj
(script dormant objective_1_set_hud
	(sleep_until
		(or
			(volume_test_players vol_patha_choppers)
			(and
				(>= (ai_living_count patha_pelican) 1)
				(any_players_in_vehicle)
			)
		)
	)
	(sleep 60)
	(cinematic_set_chud_objective obj_0)
)

(script dormant objective_1_clear
	(print "objective complete:")
	(print "Deactive the first Shield generator")
	(objectives_finish_up_to 0)
)

(script dormant objective_2_set
	(sleep 30)
	(print "new objective set:")
	(print "Deactive the last Shield generator")
	(objectives_show_up_to 1)
)

(script dormant objective_2_clear
	(print "objective complete:")
	(print "Deactive the last Shield generator")
	(objectives_finish_up_to 1)
)

(script dormant objective_3_set
	(sleep 30)
	(print "new objective set:")
	(print "Defeat the Covenant at the Citadel gates")
	(objectives_show_up_to 2)
	;(cinematic_set_chud_objective obj_2)
)

(script dormant objective_3_clear
	(print "objective complete:")
	(print "Defeat the Covenant at the Citadel gates")
	(objectives_finish_up_to 2)
)

(script dormant objective_4_set
	(sleep 30)
	(print "new objective set:")
	(print "Stop Truth from firing the Halo rings")
	(objectives_show_up_to 3)
	(cinematic_set_chud_objective obj_3)
)

(script dormant objective_4_clear
	(print "objective complete:")
	(print "Stop Truth from firing the Halo rings")
	(objectives_finish_up_to 3)
)

(script dormant objective_5_set
	(sleep 30)
	(print "new objective set:")
	(print "Run for your life!")
	(objectives_show_up_to 4)
	(cinematic_set_chud_objective obj_4)
)

(script dormant objective_5_clear
	(print "objective complete:")
	(print "Run for your life!")
	(objectives_finish_up_to 4)
)

;*********************************************************************;
;Nav Point Scripts
;*********************************************************************;
(script dormant beach_nav_exit
	(deactivate_all_navs)
	(sleep_until 
		(or
			(volume_test_players vol_patha_choppers)
			(any_players_in_vehicle)
		)
	5 (* 120 30))
	(if (not (volume_test_players vol_beach_hog_area))
		(begin
			(Hud_activate_team_nav_point_flag player nav_intro_exit 0)
			(sleep_until 
				(and
					(volume_test_players vol_beach_hog_area)
					(any_players_in_vehicle)
				)
			5)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_intro_exit)
		)
	)
)

(script dormant path_a_nav_exit
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_cell_a_start) 30 (* 300 30))
	(if (not (volume_test_players vol_cell_a_start))
		(begin
			(Hud_activate_team_nav_point_flag player nav_patha_exit 0)
			(sleep_until (volume_test_players vol_cell_a_start) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_patha_exit)
		)
	)
)

(script dormant cell_a_nav_exit
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_lock_a01_start) 30 (* 120 30))
	(if (not (volume_test_players vol_lock_a01_start))
		(begin
			(Hud_activate_team_nav_point_flag player nav_cella_exit 0)
			(sleep_until (volume_test_players vol_lock_a01_start) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_cella_exit)
		)
	)
)

(script dormant lock_a_nav_elevator
	(if 
		;if player has not hit top switch and is not up top already
		(and
			(not g_tower1)
			(not (= (current_zone_set) 4))
		)
		(begin
			(sleep_until (> (device_get_position tower1_elevator) 0) 30 (* 30 30))
			(if (not (> (device_get_position tower1_elevator) 0))
				(begin
					(Hud_activate_team_nav_point_flag player nav_locka_elevator 0)
					(sleep_until (> (device_get_position tower1_elevator) 0) 1)
					(deactivate_all_navs)
					;(Hud_deactivate_team_nav_point_flag player nav_locka_elevator)
				)
			)
		)
	)
)

(script dormant lock_a_nav_button
	(deactivate_all_navs)
	(sleep_until (> (device_get_position tower1_switch) 0) 30 (* 30 30))
	(if (not (> (device_get_position tower1_switch) 0))
		(begin
			(Hud_activate_team_nav_point_flag player nav_locka_button 0)
			(sleep_until (> (device_get_position tower1_switch) 0) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nwav_point_flag player nav_locka_button)
		)
	)
)

(script dormant lock_a_nav_exit
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_cell_a_newhog) 5 (* 120 30))
	(if (not (volume_test_players vol_cell_a_newhog))
		(begin
			(Hud_activate_team_nav_point_flag player nav_locka_exit 0)
			(sleep_until (volume_test_players vol_cell_a_newhog) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_locka_exit)
		)
	)
	
	(wake hornet_nav_start)
)

(script dormant hornet_nav_start
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_cell_b_hornet_pickup) 5 (* 300 30))
	(if (not (volume_test_players vol_cell_b_hornet_pickup))
		(begin
			(Hud_activate_team_nav_point_flag player nav_hornet_start 0)
			(sleep_until (volume_test_players vol_cell_b_hornet_pickup) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_hornet_start)
		)
	)
)

(script dormant lock_c_nav_start01
	(deactivate_all_navs)
	(sleep (* 30 30))
	(if (volume_test_players vol_cell_b_towerclear)
		(begin
			(Hud_activate_team_nav_point_flag player nav_lockc_start 0)
			(sleep_until (volume_test_players vol_cell_c_brute_spawn) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_lockc_start)
		)
	)
)

(script dormant lock_c_nav_start02
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_cell_c_brute_spawn) 30 (* 300 30))
	(if (not (volume_test_players vol_cell_c_brute_spawn))
		(begin
			(Hud_activate_team_nav_point_flag player nav_lockc_start 0)
			(sleep_until (volume_test_players vol_cell_c_brute_spawn) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_lockc_start)
		)
	)
)

(script dormant lock_c_nav_elevator
	(if 
		;if player has not hit top switch and is not up top already
		(and
			(not g_tower3)
			(not (= (current_zone_set) 7))
		)
		(begin
			(sleep_until (> (device_get_position tower3_elevator) 0) 30 (* 30 30))
			(if (not (> (device_get_position tower3_elevator) 0))
				(begin
					(Hud_activate_team_nav_point_flag player nav_lockc_elevator 0)
					(sleep_until (> (device_get_position tower3_elevator) 0) 1)
					(deactivate_all_navs)
					;(Hud_deactivate_team_nav_point_flag player nav_lockc_elevator)
				)
			)
		)
	)
)

(script dormant lock_c_nav_button
	(deactivate_all_navs)
	(sleep_until (> (device_get_position tower3_switch) 0) 30 (* 30 30))
	(if (not (> (device_get_position tower3_switch) 0))
		(begin
			(Hud_activate_team_nav_point_flag player nav_lockc_button 0)
			(sleep_until (> (device_get_position tower3_switch) 0) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_lockc_button)
		)
	)
)

(script dormant buffet_nav_start
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_tankrun01_vehicle_drop) 30 (* 120 30))
	(if (not (volume_test_players vol_tankrun01_vehicle_drop))
		(begin
			(Hud_activate_team_nav_point_flag player nav_buffet_start 0)
			(sleep_until (volume_test_players vol_tankrun01_vehicle_drop) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_buffet_start)
		)
	)
)

(script dormant ridge_nav_start
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_tankrun01_migrate) 30 (* 200 30))
	(if (not (volume_test_players vol_tankrun01_migrate))
		(begin
			(Hud_activate_team_nav_point_flag player nav_ridge_start 0)
			(sleep_until (volume_test_players vol_tankrun01_migrate) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_ridge_start)
		)
	)
)

(script dormant ridge_nav_end
	(deactivate_all_navs)
	(sleep_until (volume_test_players vol_crater_hornet_drop02) 30 (* 300 30))
	(if (not (volume_test_players vol_crater_hornet_drop02))
		(begin
			(Hud_activate_team_nav_point_flag player nav_ridge_end 0)
			(sleep_until (volume_test_players vol_crater_hornet_drop02) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_ridge_end)
		)
	)
)

(script dormant ring_nav_end
	(deactivate_all_navs)
	(sleep_until (<= (ai_living_count all_enemies) 5))
	(sleep_until (<= (ai_living_count all_enemies) 0) 30 (* 120 30))
	(sleep_until (> (device_get_position ring_lightbridge_control) 0) 30 (* 120 30))
	(if (not (> (device_get_position ring_lightbridge_control) 0))
		(begin
			(Hud_activate_team_nav_point_flag player nav_ring_end 0)
			(sleep_until (> (device_get_position ring_lightbridge_control) 0) 1)
			(deactivate_all_navs)
			;(Hud_deactivate_team_nav_point_flag player nav_ring_end)
		)
	)
)

(script dormant ring_nav_exit_end
	(deactivate_all_navs)
	(sleep_until (volume_test_players ring04_cortana01) 30 (* 300 30))
	;(Hud_activate_team_nav_point_flag player nav_temp_cortana_ring 0)
	(object_create_anew ring_cortana_light)
)

(script static void deactivate_all_navs
	(Hud_deactivate_team_nav_point_flag player nav_intro_exit)
	(Hud_deactivate_team_nav_point_flag player nav_patha_exit)
	(Hud_deactivate_team_nav_point_flag player nav_cella_exit)
	(Hud_deactivate_team_nav_point_flag player nav_locka_elevator)
	(Hud_deactivate_team_nav_point_flag player nav_locka_button)
	(Hud_deactivate_team_nav_point_flag player nav_locka_exit)
	(Hud_deactivate_team_nav_point_flag player nav_hornet_start)
	(Hud_deactivate_team_nav_point_flag player nav_lockc_start)
	(Hud_deactivate_team_nav_point_flag player nav_lockc_start)
	(Hud_deactivate_team_nav_point_flag player nav_lockc_elevator)
	(Hud_deactivate_team_nav_point_flag player nav_lockc_button)
	(Hud_deactivate_team_nav_point_flag player nav_buffet_start)
	(Hud_deactivate_team_nav_point_flag player nav_ridge_start)
	(Hud_deactivate_team_nav_point_flag player nav_ridge_end)
	(Hud_deactivate_team_nav_point_flag player nav_ring_end)
)
;*********************************************************************;
;Tower Scripts
;*********************************************************************;
(script dormant sky_tower_control
	(object_create tower_right)
	(sleep_until
		(begin
			(if (volume_test_players vol_cell_a_init)
				;player entering cella
				(begin
					(object_destroy tower_mid)
					(object_create tower_right)
					(sleep_until (not (volume_test_players vol_cell_a_init)) 5)
				)
			)
			(if (volume_test_players vol_cell_a_start)
				(begin
					;player entering beach
					(object_create tower_mid)
					(object_destroy tower_right)
					(sleep_until (not (volume_test_players vol_cell_a_start)) 5)
				)
			)
			(>= (current_zone_set) 5)
		)
	5)
	;set waterfront
	(object_create tower_left)
	(object_destroy tower_right)
	;set_cell_c_int
	(sleep_until (>= (current_zone_set) 6) 5)
	(object_create tower_mid)
	(soft_ceiling_enable no_back TRUE)
	;crater
	(sleep_until (= (current_zone_set) 9) 5)
	(soft_ceiling_enable no_back FALSE)
	(object_destroy tower_right)
	(object_destroy tower_mid)
	(object_destroy tower_left)
)

;*********************************************************************;
;Capital Ship Firing Scripts
;*********************************************************************;
(script dormant capital_ship_control
	(sleep_until
		(begin
			(print "*capital ship firing*")
			(effect_new_on_object_marker "objects\vehicles\cov_capital_ship\fx\firing_fx\firing.effect" cov_capital_ship "")
			(sleep (random_range (* 30 10) (* 30 30)))
			FALSE
		)
	)
)

;*********************************************************************;
;Object Management Scripts
;*********************************************************************;
(script dormant object_management
	(sleep_until (> (player_count) 0) 1)
	(if (= (current_zone_set_fully_active) 0)
		(begin
			(print "place objects action")
			;(object_create_folder scenery_beach)
			;(object_create_folder crates_beach)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 1) 1)
	;cellb_beach_cella
	(if (= (current_zone_set_fully_active) 1)
		(begin
			(object_create_folder scenery_beach)
			(object_create_folder crates_beach)
			(object_create_folder crates_patha)
			(object_create_folder scenery_cella)
			(object_create_folder crates_cella)
			(object_create_folder crates_cellb_covdrop)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	;cella_locka
	(if (= (current_zone_set_fully_active) 3)
		(begin
			(object_create_folder crates_locka)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 5) 1)
	;waterfront
	(if (= (current_zone_set_fully_active) 5)
		(begin
			(object_destroy_folder scenery_cella)
			(object_destroy_folder crates_locka)
			(object_create_folder crates_cellc)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 6) 1)
	;cellb_cellc_lockc
	(if (= (current_zone_set_fully_active) 6)
		(begin
			(object_destroy_folder scenery_beach)
			(object_destroy_folder crates_beach)
			(object_destroy_folder crates_patha)
			(object_destroy_folder crates_cellb_covdrop)
			(object_create_folder crates_lockc)
			(object_create_folder crates_ice)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 9) 1)
	;ice
	(if (= (current_zone_set_fully_active) 9)
		(begin
			(object_destroy_folder crates_cellc)
			(object_create_folder crates_crater)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 10) 1)
	;crater
	(if (= (current_zone_set_fully_active) 10)
		(begin
			(object_destroy_folder crates_lockc)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 12) 1)
	;ring
	(if (= (current_zone_set_fully_active) 12)
		(begin
			(object_destroy_folder crates_ice)
			(object_destroy_folder crates_crater)
			(object_create_folder scenery_ring)
			(object_create_folder crates_ring)
		)
	)
)

;*********************************************************************;
;Main Mission Script
;*********************************************************************;
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
	; select insertion point 
	(cond
		((= (game_insertion_point_get) 0) (ins_beach))
		((= (game_insertion_point_get) 1) (ins_hornets))
		((= (game_insertion_point_get) 2) (ins_citadel_adv))
	)
)



(script startup mission_citadel
	(print_difficulty)
	
	; fade to black 
	(fade_out 0 0 0 0)
	(sound_class_set_gain amb 0 0)
	
	; hide the players 
	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)

	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)
	(ai_allegiance guilty player)
	(ai_allegiance player guilty)
	(ai_allegiance guilty human)
	(ai_allegiance human guilty)
	(ai_allegiance guilty covenant)
	(ai_allegiance covenant guilty)
	(ai_allegiance sentinel player)
	(ai_allegiance player sentinel)
	(ai_allegiance sentinel covenant)
	(ai_allegiance covenant sentinel)
	(ai_allegiance sentinel human)
	(ai_allegiance human sentinel)
	
	; pause metagame timer during cinematic  
	(campaign_metagame_time_pause TRUE)
	
	; the game can use flashlights 
	(game_can_use_flashlights TRUE)
	
	; wake object management scripts
	(wake object_management)
	
	;tower control
	(wake sky_tower_control)
	
	;HUD
	(chud_show_fire_grenades FALSE)
	
	;soft ceilings
	(soft_ceiling_enable soft_bsp010 TRUE)
	(soft_ceiling_enable soft_bsp040 TRUE)
	(soft_ceiling_enable no_climb FALSE)
	(soft_ceiling_enable soft_bsp070 TRUE)
	(soft_ceiling_enable soft_bsp100 TRUE)
	(soft_ceiling_enable vehicle_110 FALSE)
	(soft_ceiling_enable no_back FALSE)
	(soft_ceiling_enable no_jump FALSE)
	
	;zone triggers
	(zone_set_trigger_volume_enable begin_zone_set:set_beach:* FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_a_int FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_c_exit FALSE)
	(zone_set_trigger_volume_enable zone_set:set_cell_c_exit FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_ice FALSE)
	(zone_set_trigger_volume_enable zone_set:set_cell_ice:a FALSE)
	(zone_set_trigger_volume_enable zone_set:set_cell_ice:b FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_crater:* FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_citadel_tapestry FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_halo FALSE)
	
	; wake recycling volume thread 
	;(wake recycle_volumes)

	; === INSERTION POINT TEST =====================================================
	(if	(and
			(not editor)
			(> (player_count) 0)
		)
			; if game is allowed to start 
			(start)
			
			; if the game is NOT allowed to start do this 
			(begin 
				(fade_in 0 0 0 0)
				;(wake temp_camera_bounds_off)
			)
	)
	; === INSERTION POINT TEST =====================================================
	
		;====
			;Begin citadel introduction
			(sleep_until (>= g_insertion_index 1))
			(if (<= g_insertion_index 1) (wake Intro_Start))
		
		;====
			;Begin Beach Encounter
			(sleep_until	(or
							(= (current_zone_set_fully_active) 1)
							(>= g_insertion_index 2)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 2) (wake Beach_Start))
			
		;====
			;Begin Path A
			(sleep_until	(or
							(volume_test_players vol_beach_area03_start)
							(>= g_insertion_index 3)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 3) (wake PathA_Start))
		
		;====
			;Begin Cell A
			(sleep_until	(or
							(volume_test_players vol_cell_a_init)
							(>= g_insertion_index 4)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 4) (wake CellA_Start))
		
		;====
			;Begin Tower A 
			(sleep_until	(or
							(= (current_zone_set_fully_active) 3)
							(>= g_insertion_index 5)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 5) (wake LockA_Start))
		
		;====
			;Begin Cell B
			(sleep_until	(or
							g_tower1
							(>= g_insertion_index 6)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 6) (wake CellB_Start))
		
		;====
			;Begin Cell C
			(sleep_until	(or
							(= (current_zone_set_fully_active) 5)
							(>= g_insertion_index 7)
						)
			1)
				; wake encounter script 
			(if (<= g_insertion_index 7) (wake CellC_Start))
		
		;====
			;Begin Lock C 
			(sleep_until	(or
							(= (current_zone_set_fully_active) 6)
							(>= g_insertion_index 8)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 8) (wake LockC_Start))
			
		;====
			;Begin Tank Run 
			(sleep_until	(or
							g_tower3
							(>= g_insertion_index 9)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 9) (wake TankRun_Start))
			
		;====
			;Begin Crater
			(sleep_until	(or
							(= (current_zone_set_fully_active) 10)
							(>= g_insertion_index 10)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 10) (wake crater_start))
			
		;====
			;Begin Ring
			(sleep_until	(or
							(volume_test_players vol_ring01_init)
							(>= g_insertion_index 11)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 11) (wake ring_start))
			
		;====
			;Begin Ring Escape
			(sleep_until	(or
							(= (current_zone_set_fully_active) 14)
							(>= g_insertion_index 12)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 12) (wake ring_exit))

)