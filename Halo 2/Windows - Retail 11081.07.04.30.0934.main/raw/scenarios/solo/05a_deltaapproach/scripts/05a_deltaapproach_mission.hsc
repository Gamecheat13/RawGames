;05a_DELTAAPPROACH!
;-------------------------------------------------------------------------------

(script stub void c05_intro
	(print "hi, joe")
)
(script stub void X05
	(print "hi, joe")
)


;-------------------------------------------------------------------------------
;Global Scripts

;Global pausing script to fake sleeping and other stationary behaviors
(script command_script long_pause
	(cs_abort_on_alert TRUE)
	(sleep_forever)
)
(script command_script forever_pause
	(cs_pause -1)
)

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)

;-------------------------------------------------------------------------------
;Chapter Titles

;"Helljumpers"
(script dormant 05a_title0
	(cinematic_fade_from_white_bars)
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
	(game_save)
)

;"You Break It, You Buy It"
(script dormant 05a_title1
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)

;"Off the Rock, Through the Bush, Nothing But Jackal"
(script dormant 05a_title2
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_3)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)


;-------------------------------------------------------------------------------
;Objectives

(script dormant objective_lz_set
            (sleep 30)
            (print "new objective set:")
            (print "Clear the landing zone for the Pelicans.")
            (objectives_show_up_to 0)
)
(script dormant objective_lz_clear
            (print "objective complete:")
            (print "Clear the landing zone for the Pelicans.")
            (objectives_finish_up_to 0)
)

(script dormant objective_bridge_set
            (sleep 30)
            (print "new objective set:")
            (print "Extend the bridge, and cross the chasm.")
            (objectives_show_up_to 1)
)
(script dormant objective_bridge_clear
            (print "objective complete:")
            (print "Extend the bridge, and cross the chasm.")
            (objectives_finish_up_to 1)
)

(script dormant objective_ruins_set
            (sleep 30)
            (print "new objective set:")
            (print "Push through the Covenant-held ruins.")
            (objectives_show_up_to 2)
)
(script dormant objective_ruins_clear
            (print "objective complete:")
            (print "Push through the Covenant-held ruins.")
            (objectives_finish_up_to 2)
)

(script dormant objective_tower1_set
            (sleep 30)
            (print "new objective set:")
            (print "Reach the towers in the lake.")
            (objectives_show_up_to 3)
)
(script dormant objective_tower1_clear
            (print "objective complete:")
            (print "Reach the towers in the lake.")
            (objectives_finish_up_to 3)
)


;-------------------------------------------------------------------------------
;Music

(script dormant music_05a_01_start
	;lz encounter 1st checkpoint (or something)
	(print "music 05a_01 start")
	(sound_looping_start "scenarios\solo\05a_deltaapproach\05a_music\05a_01" none 1.0)
)

;(script dormant music_05a_01_stop
;	;half way down elevator ride
;	(print "music 05a_01 stop")
;	(sound_looping_stop "scenarios\solo\05a_deltaapproach\05a_music\05a_01")
;)

(script dormant music_05a_02_start
	;when warthog is dropped
	(print "music 05a_02 start")
	(sound_looping_start "scenarios\solo\05a_deltaapproach\05a_music\05a_02" none 1.0)
)

(script dormant music_05a_02_stop
	;maybe at the 1st checkpoint after the bridge goes up
	(print "music 05a_02 stop")
	(sound_looping_stop "scenarios\solo\05a_deltaapproach\05a_music\05a_02")
)

(script dormant music_05a_03_start
	;when you go into bridge control hut
	(print "music 05a_03 start")
	(sound_looping_start "scenarios\solo\05a_deltaapproach\05a_music\05a_03" none 1.0)
)

(script dormant music_05a_03_stop
	;when push button to extend bridge
	(print "music 05a_03 stop")
	(sound_looping_stop "scenarios\solo\05a_deltaapproach\05a_music\05a_03")
)

(script dormant music_05a_04_start
	;when you get into scorpion
	(print "music 05a_04 start")
	(sound_looping_start "scenarios\solo\05a_deltaapproach\05a_music\05a_04" none 1.0)
)

(script dormant music_05a_04_start_alt
	;arrive at old temple entrance
	(print "music 05a_04 start alt")
	(sound_looping_set_alternate "scenarios\solo\05a_deltaapproach\05a_music\05a_04" true)
)

(script dormant music_05a_04_stop
	;arrive at old temple
	(print "music 05a_04 stop")
	(sound_looping_stop "scenarios\solo\05a_deltaapproach\05a_music\05a_04")
)

(script dormant music_05a_05_start
	;after cortana says "…such nice places."
	(print "music 05a_05 start")
	(sound_looping_start "scenarios\solo\05a_deltaapproach\05a_music\05a_05" none 1.0)
)

(script dormant music_05a_05_stop
	;time out or when you hit the beginning of the exit
	(print "music 05a_05 stop")
	(sound_looping_stop "scenarios\solo\05a_deltaapproach\05a_music\05a_05")
)

(script dormant music_05a_06_start
	;trigger volume at the vista to the temple towers
	(print "music 05a_06 start")
	(sound_looping_start "scenarios\solo\05a_deltaapproach\05a_music\05a_06" none 1.0)
)


;-------------------------------------------------------------------------------
;Kill Volumes

;so much simpler
(script dormant kill_volumes
	(sleep_until
		(begin
			(sleep_until (= (structure_bsp_index) 0))
			(kill_volume_enable kill_bsp00_lz)
			(kill_volume_enable kill_bsp00_all)
			(kill_volume_disable kill_bsp01_all)
			;9/11
			(kill_volume_disable kill_approach_ramp)
			
			(sleep_until (= (structure_bsp_index) 1))
			(kill_volume_enable kill_bsp01_all)
			;9/11
			(kill_volume_enable kill_approach_ramp)

			(kill_volume_disable kill_bsp00_lz)
			(kill_volume_disable kill_bsp00_all)
			FALSE
		)
	)
)

;and to go with it, a kill script
(global short straggler_no 0)
(script dormant kill_stragglers
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors all_ai) straggler_no) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors all_ai) straggler_no)) 100)
				)
					(object_destroy (list_get (ai_actors all_ai) straggler_no))
			)
			(set straggler_no (+ straggler_no 1))
			(if (> straggler_no 19)
				(set straggler_no 0)
			)
			FALSE
		)
	)
)


;-------------------------------------------------------------------------------
;Misc.

(script dormant lights
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(= (volume_test_objects vol_lights_on_01 (players)) TRUE)
					(= (volume_test_objects vol_lights_on_02 (players)) TRUE)
					(= (volume_test_objects vol_lights_on_03 (players)) TRUE)
					(= (volume_test_objects vol_lights_on_04 (players)) TRUE)
					(= (volume_test_objects vol_lights_on_05 (players)) TRUE)
					(= (volume_test_objects vol_lights_on_06 (players)) TRUE)
				)
			)
			(game_can_use_flashlights TRUE)
			(sleep_until 
				(AND
					(= (volume_test_objects vol_lights_on_01 (players)) FALSE)
					(= (volume_test_objects vol_lights_on_02 (players)) FALSE)
					(= (volume_test_objects vol_lights_on_03 (players)) FALSE)
					(= (volume_test_objects vol_lights_on_04 (players)) FALSE)
					(= (volume_test_objects vol_lights_on_05 (players)) FALSE)
					(= (volume_test_objects vol_lights_on_06 (players)) FALSE)
				)
			)
			(game_can_use_flashlights FALSE)
			FALSE
		)
	)
)


;-------------------------------------------------------------------------------

(global effect phantom_boom "effects\scenarios\solo\deltatemple\phantom_explosion")

(script command_script lz_phantom_01_crash
	(cs_pause -1)
)

(script static void lz_phantom_01_blows
	(cs_run_command_script lz_phantom_01/pilot lz_phantom_01_crash)
	(begin_random
		(begin
			(effect_new_on_object_marker phantom_boom (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p")
			(sleep (random_range 10 60))
			(print ".")
		)
		(begin
			(effect_new_on_object_marker phantom_boom (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "right_gun")
			(sleep (random_range 10 60))
			(print ".")
		)
		(begin
			(effect_new_on_object_marker phantom_boom (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "left_gun")
			(sleep (random_range 10 60))
			(print ".")
		)
		(begin
			(effect_new_on_object_marker phantom_boom (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "chin_gun")
			(sleep (random_range 10 60))
			(print ".")
		)
		(begin
			(effect_new_on_object_marker phantom_boom (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "target_engine_left")
			(sleep (random_range 10 60))
			(print ".")
		)
		(begin
			(effect_new_on_object_marker phantom_boom (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "target_engine_right")
			(sleep (random_range 10 60))
			(print ".")
		)
	)
)


;-------------------------------------------------------------------------------
;Initializing start of mission

;Keeps guys in turrets
(script command_script stay_shooting
	;(cs_force_combat_status 4)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

;The number of turrets active in LZ
(global short lz_turret_count 2)

;Sets up everything to match with the end of the intro
(script static void prep_return_from_intro
	(if (difficulty_legendary)
		(set lz_turret_count 4)
	)
	(if (difficulty_heroic)
		(set lz_turret_count 3)
	)
	(if (difficulty_normal)
		(set lz_turret_count 2)
	)

;9/13
	(ai_place LZ_turrets_01)
	(ai_set_blind LZ_turrets_01 TRUE)
	(cs_run_command_script LZ_turrets_01 stay_shooting)
	(set lz_turret_count (- lz_turret_count 1))

	(begin_random
;		(if (> lz_turret_count 0)
;			(begin
;				(ai_place LZ_turrets_01)
;				(ai_set_blind LZ_turrets_01 TRUE)
;				(cs_run_command_script LZ_turrets_01 stay_shooting)
;				(set lz_turret_count (- lz_turret_count 1))
;			)
;		)
		(if (> lz_turret_count 0)
			(begin
				(ai_place LZ_turrets_02)
				(ai_set_blind LZ_turrets_02 TRUE)
				(cs_run_command_script LZ_turrets_02 stay_shooting)
				(set lz_turret_count (- lz_turret_count 1))
			)
		)
		(if (> lz_turret_count 0)
			(begin
				(ai_place LZ_turrets_03)
				(ai_set_blind LZ_turrets_03 TRUE)
				(cs_run_command_script LZ_turrets_03 stay_shooting)
				(set lz_turret_count (- lz_turret_count 1))
			)
		)
		(if (> lz_turret_count 0)
			(begin
				(ai_place LZ_turrets_04)
				(ai_set_blind LZ_turrets_04 TRUE)
				(cs_run_command_script LZ_turrets_04 stay_shooting)
				(set lz_turret_count (- lz_turret_count 1))
			)
		)
	)

	(if (difficulty_legendary)
		(begin
			(ai_place allies_lz_ledge 2)
			;(ai_place allies_lz_ridge 2)
			(ai_place LZ_jackals_ridge 1)
		)
	)
	(if (difficulty_heroic)
		(begin
			(ai_place allies_lz_ledge 2)
			(ai_place allies_lz_ridge 1)
			(ai_place LZ_jackals_ridge 1)
		)
	)
	(if (difficulty_normal)
		(begin
			(ai_place allies_lz_ledge 2)
			(ai_place allies_lz_ridge 1)
			(ai_place LZ_jackals_ridge 1)
		)
	)
		
	(object_teleport (player0) lz_start_player0)
	(object_teleport (player1) lz_start_player1)
)


;-------------------------------------------------------------------------------
;LZ

;Reminder to wait for hog if you start to leave on foot
(script dormant lz_pelican_wait
	(sleep_until 
		(AND
			(= (volume_test_objects vol_lz_all (players)) FALSE)
			(> (player_count) 0)
		)
	)
	(if 
		(AND
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) FALSE)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Let's wait for our Warthog. Unless you really want to walk...'")
				(sleep (ai_play_line_on_object NONE 0370))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0370_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

(script command_script drive_to_overlook_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to overlook/p2)
	(cs_go_to overlook/p3)
	(cs_go_to overlook/p6)
	(cs_go_to overlook/p7)
	(cs_go_to overlook/p4)
	(cs_go_to overlook/p5)
	(cs_go_to overlook/p1)
)
(script command_script drive_to_overlook_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to overlook/p2)
	(cs_go_to overlook/p3)
	(cs_go_to overlook/p6)
	(cs_go_to overlook/p7)
	(cs_go_to overlook/p4)
	(cs_go_to overlook/p5)
	(cs_go_to overlook/p0)
)

;Tells when your hog is full
(global boolean lz_mounted_up FALSE)
(global boolean ride_ally_comment_go FALSE)
;ODST calls out pelican
(script command_script lz_pelican_sighted
	(set ride_ally_comment_go TRUE)
	(cs_switch lz_odst)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ODST: 'Here comes our ride!'")
	(cs_play_line 0380)
)
;Marine calls for allies to saddle up
(script command_script lz_saddle_up
	(cs_switch lz_ally)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Saddle-up!  We're moving out!'")
	(cs_play_line 0050)
)

;Tells when the pelican has actually arrived
(global boolean lz_pelican_in_sight FALSE)
(global boolean lz_pelican_arrived FALSE)

(script dormant lz_pelican_timer
	(sleep 8000)
	(object_destroy (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot))
	(object_destroy (ai_vehicle_get_from_starting_location LZ_pelican_02/pilot))
)

;Pelican flies in to LZ
(script command_script LZ_pelican_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by LZ_pelicans/pel_a_09 20)
	(cs_fly_by LZ_pelicans/pel_a_08 20)
	(cs_fly_by LZ_pelicans/pel_a_07 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by LZ_pelicans/pel_a_06 20)

	(set lz_pelican_in_sight TRUE)
	(cs_vehicle_speed .5)

	(cs_fly_to LZ_pelicans/pel_a_04 5)
	(cs_fly_to_and_face LZ_pelicans/pel_a_04 LZ_pelicans/p0 1)

;	(cs_fly_to_and_face LZ_pelicans/pel_a_04 LZ_pelicans/pel_b_03 1)
;	(cs_fly_to_and_face LZ_pelicans/p1 LZ_pelicans/pel_b_03 1)

	(cs_fly_to LZ_pelicans/pel_a_05 1)
	(ai_set_orders LZ_allies allies_lz_hogs)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_lz_warthog (players)) FALSE)
			(= (volume_test_objects vol_lz_warthog (ai_actors all_allies)) FALSE)
			(> (player_count) 0)
		)
	)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_pelican_01/pilot) "pelican_lc")
	(sleep 45)
	(wake music_05a_02_start)
	(wake lz_pelican_timer)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_pelican_01/pilot) "pelican_p")

	(sleep_until (< (ai_living_count lz_pelican_01) 4))
	(set lz_pelican_arrived TRUE)

	(cs_fly_to LZ_pelicans/pel_a_04 1)
	(cs_vehicle_speed 1)
	(cs_fly_by LZ_pelicans/pel_a_06 3)
	(cs_fly_by LZ_pelicans/pel_a_07 20)
	(cs_vehicle_boost TRUE)
	(cs_fly_by LZ_pelicans/pel_a_09 20)
	(cs_fly_to LZ_pelicans/pel_a_10 20)
	(ai_erase lz_pelican_01)
)

;other pelican at LZ
(script command_script other_lz_pelican
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by LZ_pelicans/pel_b_07 20)
	(cs_fly_by LZ_pelicans/pel_b_06 20)
	(cs_fly_by LZ_pelicans/pel_b_05 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by LZ_pelicans/pel_b_04 10)
	(cs_vehicle_speed .5)
	(cs_face TRUE LZ_pelicans/pel_a_05)
	(sleep_until
		(begin
			(if (= lz_pelican_arrived FALSE)
				(cs_fly_by LZ_pelicans/pel_b_02 3)
			)
			(if (= lz_pelican_arrived FALSE)
				(cs_fly_by LZ_pelicans/pel_b_03 3)
			)
			(= lz_pelican_arrived TRUE)
		)
	)
	(cs_face FALSE LZ_pelicans/pel_a_05)
	(cs_fly_by LZ_pelicans/pel_b_05 20)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by LZ_pelicans/pel_b_07 40)
	(cs_fly_to LZ_pelicans/pel_b_08 30)
	(ai_erase lz_pelican_02)
)

;Brings in the pelican
(script dormant LZ_pelican
	(ai_place LZ_pelican_02)
	(cs_run_command_script LZ_pelican_02/pilot other_LZ_pelican)
	(sleep 120)

	(ai_place allies_lz_pelican (- 2 (ai_living_count all_allies)))
	(ai_place LZ_pelican_01)
	(ai_place LZ_warthog_01)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot))
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot) "pelican_p" (ai_actors allies_lz_pelican))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot) "pelican_lc" (ai_vehicle_get_from_starting_location LZ_warthog_01/driver))

	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot) TRUE)

	(cs_run_command_script LZ_pelican_01/pilot LZ_pelican_arrives)
	
;	(sleep_until (< (ai_living_count lz_enemies_all) 1))
	(ai_set_orders LZ_allies allies_lz_all)

	(sleep_until (= lz_pelican_in_sight TRUE))
	(if (= lz_pelican_arrived FALSE)
		(begin
			(sleep_until 
				(OR
					(ai_scene lz_pelican_sighted_scene lz_pelican_sighted LZ_allies)
					(AND
						(< (ai_living_count allies_lz_ledge) 1)
						(< (ai_living_count allies_lz_ridge) 1)
					)
				)
			30 150)
			(sleep 150)
			(if (= ride_ally_comment_go FALSE)
				(begin
					(ai_dialogue_enable FALSE)
					(sleep 60)
					(print "CORTANA: 'Here comes our ride!'")
					(sleep (ai_play_line_on_object NONE 2020))
					;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2020_cor))
					(sleep 30)
					(ai_dialogue_enable TRUE)
				)
			)
		)
	)
	
	(sleep 240)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "JOHNSON: 'I got a good view coming in.'")
	(print "'There's a big building in the middle of this island's lake.'")
	(sleep (ai_play_line_on_object NONE 0020))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0020_jon))
	(sleep 30)
	(print "CORTANA: 'I saw it too.  It looked like a temple.")
	(sleep (ai_play_line_on_object NONE 0030))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0030_cor))
	(sleep 15)
	(print "If I were a megalomaniac - and I'm not - that's where I'd be.")
	(sleep (ai_play_line_on_object NONE 0040))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0040_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)

	(sleep_until (= lz_pelican_arrived TRUE))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) TRUE)
	(ai_set_orders LZ_allies allies_lz_hogs)

	(ai_scene lz_saddle_up_scene lz_saddle_up all_allies)

	(sleep_until 
		(OR
			(AND
				(= (volume_test_objects vol_lz_all (players)) FALSE)
				(> (player_count) 0)	
			)
			(AND 
				(OR
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0))
				)
				(OR
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1))
					(= (game_is_cooperative) FALSE)
				)
			)
		)
	)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) FALSE)
	(game_save)

	(ai_enter_squad_vehicles all_allies) 
	(set lz_mounted_up TRUE)
)
(script static void short_LZ_pel
	(ai_place LZ_pelican_02)
	(cs_run_command_script LZ_pelican_02/pilot other_LZ_pelican)
	(sleep 120)

	(ai_place allies_lz_pelican (- 4 (ai_living_count all_allies)))
	(ai_place LZ_pelican_01)
	(ai_place LZ_warthog_01)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot))
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot) "pelican_p" (ai_actors allies_lz_pelican))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot) "pelican_lc" (ai_vehicle_get_from_starting_location LZ_warthog_01/driver))

;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_pelican_01/pilot) TRUE)

	(cs_run_command_script LZ_pelican_01/pilot LZ_pelican_arrives)
	
	(sleep_until (> (ai_living_count lz_enemies_all) 1))
	(ai_set_orders LZ_allies allies_lz_all)

	(sleep_until (= lz_pelican_in_sight TRUE))
	(if (= lz_pelican_arrived FALSE)
		(begin
			(sleep_until 
				(OR
					(ai_scene lz_pelican_sighted_scene lz_pelican_sighted LZ_allies)
					(AND
						(< (ai_living_count allies_lz_ledge) 1)
						(< (ai_living_count allies_lz_ridge) 1)
					)
				)
			30 150)
			(sleep 150)
			(if (= ride_ally_comment_go FALSE)
				(begin
					(ai_dialogue_enable FALSE)
					(sleep 60)
					(print "CORTANA: 'Here comes our ride!'")
					(sleep (ai_play_line_on_object NONE 2020))
					;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2020_cor))
					(sleep 30)
					(ai_dialogue_enable TRUE)
				)
			)
		)
	)
	
	(sleep 240)
	(ai_dialogue_enable FALSE)
	(sleep 60)	
	(print "JOHNSON: 'I got a good view coming in.'")
	(print "'There's a big building in the middle of this island's lake.'")
	(sleep (ai_play_line_on_object NONE 0020))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0020_jon))
	(sleep 30)
	(print "CORTANA: 'I saw it too.  It looked like a temple.")
	(sleep (ai_play_line_on_object NONE 0030))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0030_cor))
	(sleep 15)
	(print "If I were a megalomaniac - and I'm not - that's where I'd be.")
	(sleep (ai_play_line_on_object NONE 0040))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0040_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)

	(sleep_until (= lz_pelican_arrived TRUE))
;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) TRUE)
	(ai_set_orders LZ_allies allies_lz_hogs)

	(ai_scene lz_saddle_up_scene lz_saddle_up all_allies)
	
	(ai_enter_squad_vehicles all_allies)
	(sleep_until (> (ai_living_count lz_warthog_01) 1))
	(ai_set_orders lz_warthog_01 allies_overlook_pause)
)

;---

;Reminder dialogue for capping turrets
(script dormant lz_turret_reminder
	(sleep_until (< (ai_living_count LZ_enemies_turrets) 1) 30 8000)
	(if (> (ai_living_count LZ_enemies_turrets) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Those turrets will tear the Pelicans to shreds! Take them out!'")
			(sleep (ai_play_line_on_object NONE 0310))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0310_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
	(sleep_until (< (ai_living_count LZ_enemies_turrets) 1) 30 8000)
	(if (> (ai_living_count LZ_enemies_turrets) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Take out those turrets, Chief!'")
			(sleep (ai_play_line_on_object NONE 2010))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2010_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

;ODST says the turrets need to be capped
(script command_script ODST_warning
	(cs_switch lz_odst)
	(cs_start_approach_player 2 10 10)
	(cs_abort_on_damage TRUE)
;	(cs_face_player TRUE)
	(print "ODST: 'Sir! We gotta neutralize those turrets!'")
	(cs_play_line 0300)
;	(cs_face_player FALSE)
)
;ODST calls for the rest of LZ to be cleared once turrets down
(script command_script ODST_turrets_down
	(cs_switch lz_odst)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ODST: 'Clear this LZ! The Pelicans are right behind us!'")
	(cs_play_line 0010)
)

;Determines when all the turrets are dead
(global boolean turrets_down FALSE)

;Script tracking number of turrets killed
(script dormant LZ_turret_track
	(sleep_until (< (ai_living_count LZ_enemies_turrets) 1))
	(print "all turrets down")
	(set turrets_down TRUE)
	(sleep_until
		(OR
			(ai_scene lz_turrets_down_scene ODST_turrets_down all_allies)
			(< (ai_living_count all_allies) 1)
		)
	30 600) 
)

;---

;Tells when the phantoms are outbound
(global boolean lz_phantom_01_leaving FALSE)
(global boolean lz_phantom_02_leaving FALSE)
(global boolean lz_phantom_03_leaving FALSE)

;Command scripts for the Phantoms
(script dormant lz_phantom_01_drop
	(object_set_phantom_power (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) TRUE)

	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_a01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_a02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_a03")

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_b01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_b02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_b03")

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_c01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_c02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_c03")

	(ai_set_orders LZ_elites_phantom_01 lz_enemies_phantom_01)
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) FALSE)
)
(script command_script LZ_phantom_arrives_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by LZ_airspace/ph0a)
	(cs_fly_by LZ_airspace/ph1a)
	(cs_fly_by LZ_airspace/ph2a)
	(cs_vehicle_speed .3)
	(cs_fly_to LZ_airspace/pel6 2)
	(cs_fly_to_and_face LZ_airspace/pel6 LZ_airspace/p0 1)
;	(sleep 60)

	(wake lz_phantom_01_drop)

	(cs_fly_to_and_face LZ_airspace/ph3a LZ_airspace/p0 1)
	
	(sleep_until (< (ai_living_count lz_phantom_01) 2) 30 900)
;	(sleep 450)
	(set lz_phantom_01_leaving TRUE)

	(cs_fly_by LZ_airspace/ph2a)
	(cs_vehicle_speed .5)
	(cs_fly_by LZ_airspace/ph1a)
	(cs_fly_by LZ_airspace/ph0a)
	(cs_fly_to LZ_airspace/phxa)
	(ai_erase LZ_phantom_01)
)
(script dormant lz_phantom_02_drop
	(object_set_phantom_power (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) TRUE)

	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_a01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_a02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_a03")

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_b01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_b02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_b03")

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_c01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_c02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_02/pilot) "phantom_p_c03")

	(ai_set_orders LZ_elites_phantom_02 lz_enemies_phantom_02)
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) FALSE)
)
(script command_script LZ_phantom_arrives_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by LZ_airspace/ph0b)
	(cs_fly_by LZ_airspace/ph1b)
	(cs_fly_by LZ_airspace/ph2b)
	(cs_vehicle_speed .3)
	(cs_fly_to LZ_airspace/pel6 2)
	(cs_fly_to_and_face LZ_airspace/pel6 LZ_airspace/p1 1)
;	(sleep 60)

	(wake lz_phantom_02_drop)
	
	(cs_fly_to_and_face LZ_airspace/ph3b LZ_airspace/p1 2)

	(sleep_until (< (ai_living_count lz_phantom_02) 2) 30 900)
;	(sleep 450)

	(cs_fly_by LZ_airspace/ph2b)
	(cs_vehicle_speed .5)
	(cs_fly_by LZ_airspace/ph1b)
	(cs_fly_by LZ_airspace/ph0b)
	(cs_fly_to LZ_airspace/phxb)
	(ai_erase LZ_phantom_02)
	(set lz_phantom_02_leaving TRUE)
)
(script command_script LZ_phantom_arrives_03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by LZ_airspace/ph0a)
	(cs_fly_by LZ_airspace/ph1a)
	(cs_fly_by LZ_airspace/ph2a)
	(cs_vehicle_speed .3)
	(cs_fly_to LZ_airspace/ph3a 2)
	(cs_fly_to_and_face LZ_airspace/ph3a LZ_airspace/p0 1)
;	(sleep 60)

	(object_set_phantom_power (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) TRUE)

	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_a01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_a02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) "phantom_p_a03")

	(sleep_until (< (ai_living_count lz_phantom_01) 2) 30 900)
;	(sleep 450)

	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location lz_phantom_01/pilot) FALSE)
	(ai_set_active_camo lz_stealth_phantom_03 TRUE)
	(cs_fly_by LZ_airspace/ph2a)
	(cs_vehicle_speed .5)
	(cs_fly_by LZ_airspace/ph1a)
	(cs_fly_by LZ_airspace/ph0a)
	(cs_fly_to LZ_airspace/phxa)
	(ai_erase LZ_phantom_01)
	(set lz_phantom_03_leaving TRUE)
)

;Scripts controlling phantoms
(script static void lz_phantom_01_start
	(ai_place LZ_phantom_01)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_elites_phantom_01 2)
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_jackals_phantom_01 (random_range 2 4))
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_grunts_phantom_01 (- 6 (ai_living_count LZ_jackals_phantom_01)))
		)
	)
	(sleep 15)

	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) "phantom_p_c" (ai_actors LZ_elites_phantom_01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) "phantom_p" (ai_actors LZ_grunts_phantom_01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) "phantom_p" (ai_actors LZ_jackals_phantom_01))

	(sleep 15)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) TRUE)
	(cs_run_command_script LZ_phantom_01/pilot LZ_phantom_arrives_01)
	
	(sleep 210)
	(print "saving")
	(game_save)

	(sleep_until (< (ai_living_count lz_phantom_01) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location lz_phantom_01/pilot))
)

(script static void lz_phantom_02_start
	(ai_place LZ_phantom_02)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_elites_phantom_02 2)
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_jackals_phantom_02 (random_range 2 4))
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_grunts_phantom_02 (- 6 (ai_living_count LZ_jackals_phantom_02)))
		)
	)
	
	(sleep 15)

	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) "phantom_p_c" (ai_actors LZ_elites_phantom_02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) "phantom_p" (ai_actors LZ_jackals_phantom_02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) "phantom_p" (ai_actors LZ_grunts_phantom_02))

	(sleep 15)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) TRUE)
	(cs_run_command_script LZ_phantom_02/pilot LZ_phantom_arrives_02)

	(sleep 150)
	(print "saving")
	(game_save)
	
	(sleep_until (< (ai_living_count lz_phantom_02) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location lz_phantom_02/pilot))	
)

(script static void lz_phantom_03_start
	(ai_place LZ_phantom_01)
	(ai_place lz_stealth_phantom_03 3)
	
	(sleep 15)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) "phantom_p_a01" (ai_actors LZ_stealth_phantom_03/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) "phantom_p_a02" (ai_actors LZ_stealth_phantom_03/2))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) "phantom_p_a03" (ai_actors LZ_stealth_phantom_03/3))
	(sleep 15)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) TRUE)
	(cs_run_command_script LZ_phantom_01/pilot LZ_phantom_arrives_03)

	(sleep 210)
	(print "saving")
	(game_save)
	
	(sleep_until (< (ai_living_count lz_phantom_01) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location lz_phantom_01/pilot))
)

(script static void short_lz_ph_02
	(ai_allegiance prophet covenant)
	(ai_place LZ_phantom_02)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_elites_phantom_02 2)
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_jackals_phantom_02 (random_range 2 4))
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_grunts_phantom_02 (- 7 (ai_living_count LZ_jackals_phantom_02)))
		)
	)
	
	(sleep 15)

	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) "phantom_p_c" (ai_actors LZ_elites_phantom_02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) "phantom_p" (ai_actors LZ_jackals_phantom_02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) "phantom_p" (ai_actors LZ_grunts_phantom_02))

	(sleep 15)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_phantom_02/pilot) TRUE)
	(cs_run_command_script LZ_phantom_02/pilot LZ_phantom_arrives_02)
)

;----
	
;Overall script for LZ
(script dormant LZ_start
	(data_mine_set_mission_segment "05a_1_landing_zone")
	(game_save)

	(wake LZ_turret_track)
	(wake lz_turret_reminder)
	
	(sleep 5)
	(ai_scene lz_intro_inform_scene ODST_warning allies_lz_ledge)
	(sleep 120)
	
	;(ai_place LZ_elites_ledge 2)
	(ai_place LZ_grunts_ledge 3)
	(ai_set_blind LZ_turrets_01 FALSE)
	(ai_set_blind LZ_turrets_02 FALSE)
	(ai_set_blind LZ_turrets_03 FALSE)
	(ai_set_blind LZ_turrets_04 FALSE)

	(sleep_until 
		(OR 
			(AND
				(= (volume_test_objects vol_entry_ledge (players)) FALSE)
				(> (player_count) 0)
			)
			(< (ai_living_count LZ_enemies_all) 3)
		)
	)

	(game_save)

;	(if (< (ai_living_count LZ_enemies_all) 11)
;		(begin
;			(ai_place LZ_elites_ridge 2)
;		)
;	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_jackals_ridge (- 2 (ai_living_count LZ_jackals_ridge)))
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_grunts_ridge (- 3 (ai_living_count LZ_grunts_ledge)))
		)
	)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_lz_leaving_ridge (players)) TRUE)
			(< (ai_living_count LZ_enemies_all) 1)
		)
	)

	(ai_place LZ_jackals_structure 1)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_elites_yard 2)
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_jackals_yard (- 2 (ai_living_count LZ_jackals_ridge)))
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_grunts_yard (- 3 (+ (ai_living_count LZ_grunts_ledge) (ai_living_count LZ_grunts_ridge))))
		)
	)

	(game_save)
	(sleep 30)
	(wake music_05a_01_start)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_lz_in_yard_01 (players)) TRUE)
			(< (ai_living_count LZ_enemies_all) 3)
		)
	)

	(game_save)

	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_elites_structure (- 2 (ai_living_count LZ_elites_yard)))
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_grunts_structure (- 5 (ai_living_count LZ_enemies_yard)))
		)
	)

	(sleep_until 
		(OR 
			(= (volume_test_objects vol_lz_in_yard_02 (players)) TRUE)
			(< (ai_living_count LZ_enemies_all) 3)
		)
	)

	(game_save)

	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_elites_bunkered (- 2 (+ (ai_living_count LZ_elites_yard) (ai_living_count LZ_elites_structure))))
		)
	)
	(if (< (ai_living_count LZ_enemies_all) 11)
		(begin
			(ai_place LZ_grunts_bunkered (- 5 (ai_living_count LZ_enemies_structure)))
		)
	)
	
	(sleep_until 
		(AND 
			(= turrets_down TRUE) 
			(< (ai_living_count LZ_enemies_all) 1)
		)
	30 1800)
	(sleep_until (= (ai_trigger_test "done_fighting" LZ_enemies_all) TRUE))
	
	;should I have a timeout and ai_kill_silent in case you can't find a guy?
	
	(sleep 90)
	(ai_dialogue_enable FALSE)
	(sleep 60)	
	(print "CORTANA: 'Artillery disabled, Sergeant! Landing zone secure…for the moment.'")
	(sleep (ai_play_line_on_object NONE 0320))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0320_cor))
	(sleep 30)
	(print "JOHNSON: 'I hear ya. Starting our approach. Hang tight.'")
	(sleep (ai_play_line_on_object NONE 0330))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0330_jon))
	(sleep 60)
	(print "CORTANA: 'Easier said than done…Inbound Phantoms, Chief!'")
	(sleep (ai_play_line_on_object NONE 0340))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0340_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	
	(lz_phantom_01_start)
	
	(sleep_until (< (ai_living_count LZ_enemies_all) 1) 30 8000)
	(sleep_until (= (ai_trigger_test "done_fighting" LZ_enemies_all) TRUE))

	;again, should I have a timeout and ai_kill_silent in case you can't find a guy?
	
	(if (difficulty_legendary)
		(begin
			(sleep 60)
			(ai_dialogue_enable FALSE)
			(sleep 60)	
			(print "CORTANA: 'Another Phantom! On approach!'")
			(sleep (ai_play_line_on_object NONE 0350))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0350_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(lz_phantom_02_start)

			(sleep_until (< (ai_living_count LZ_enemies_all) 1) 30 8000)
			(sleep_until (= (ai_trigger_test "done_fighting" LZ_enemies_all) TRUE))
;			(game_save)	
			(lz_phantom_03_start)

			(sleep_until (< (ai_living_count LZ_enemies_all) 1) 30 4000)
			(sleep_until (= (ai_trigger_test "done_fighting" LZ_enemies_all) TRUE))
			(wake LZ_pelican)
			(wake objective_lz_clear)
		)
		(begin
			(sleep 60)
			(ai_dialogue_enable FALSE)
			(sleep 60)	
			(print "CORTANA: 'Another Phantom! On approach!'")
			(sleep (ai_play_line_on_object NONE 0350))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0350_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(lz_phantom_02_start)

			(sleep_until (< (ai_living_count LZ_enemies_all) 1) 30 8000)
			(sleep_until (= (ai_trigger_test "done_fighting" LZ_enemies_all) TRUE))
			(wake LZ_pelican)
			(wake objective_lz_clear)
		)
	)

	(sleep 90)
	(if (= lz_pelican_in_sight FALSE)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Hold here until the Pelican arrives, Chief.'")
			(sleep (ai_play_line_on_object NONE 0360))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0360_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)

	(game_save)

	(wake lz_pelican_wait)
)


;-------------------------------------------------------------------------------
;Overlook

;Reminder to get moving if you're lingering
(script dormant overlook_reminder
	(sleep_until (= (volume_test_objects vol_bridge_all (players)) TRUE) 30 5400)
	(if 
		(AND
			(= (volume_test_objects vol_bridge_all (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Let's get moving before we're spotted, alright?'")
				(sleep (ai_play_line_on_object NONE 0430))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0430_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Ally remarks on the beauty before him
(script command_script overlook_remark
	(cs_switch overlook_ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Whoa…'")
	(cs_play_line 0390)
	(sleep 30)
	(print "ALLY: 'It's like a postcard.'")
	(cs_play_line 0400)
	(sleep 30)
	(print "ALLY: 'Dear, Sarge: Kicking ass in outer space. Wish you were here.'")
	(cs_play_line 0410)
	(sleep 30)
	(print "JOHNSON: 'I heard that, Jackass.'")
	(sleep (ai_play_line_on_object NONE 0420))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0420_jon))
)

;Jackal wander
(script command_script overlook_wander1
	(cs_abort_on_alert TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to overlook/jack01)
					(cs_face TRUE overlook/jack_look)
					(sleep (random_range 30 90))
					(cs_face FALSE overlook/jack_look)
				)
				(begin
					(cs_go_to overlook/jack02)
					(cs_face TRUE overlook/jack_look)
					(sleep (random_range 30 90))
					(cs_face FALSE overlook/jack_look)
				)
				(begin
					(cs_go_to overlook/jack06)
					(cs_face TRUE overlook/jack05)
					(sleep (random_range 30 90))
					(cs_face FALSE overlook/jack05)
				)
			)
			FALSE
		)
	)
)
(script command_script overlook_wander2
	(cs_abort_on_alert TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to overlook/jack03)
					(cs_face TRUE overlook/jack_look)
					(sleep (random_range 30 90))
					(cs_face FALSE overlook/jack_look)
				)
				(begin
					(cs_go_to overlook/jack04)
					(cs_face TRUE overlook/jack_look2)
					(sleep (random_range 30 90))
					(cs_face FALSE overlook/jack_look2)
				)
				(begin
					(cs_go_to overlook/jack05)
					(cs_face TRUE overlook/jack06)
					(sleep (random_range 30 90))
					(cs_face FALSE overlook/jack06)
				)
			)
			FALSE
		)
	)
)

;Overall script for overlook
(script dormant overlook_start
	(ai_disposable lz_enemies_all TRUE)
	(data_mine_set_mission_segment "05a_2_overlook")
	(wake overlook_reminder)
	(game_save)
	
	(ai_place overlook_jackals_01 2)
	(if (difficulty_legendary)
		(ai_place overlook_jackals_02 2)
	)
	(if (difficulty_heroic)
		(ai_place overlook_jackals_02 1)
	)
	
	(sleep_until (= (volume_test_objects vol_overlook_pause (players)) TRUE))

	(sleep_until 
		(OR
			(< (ai_living_count overlook_jackals) 1)
			(= (volume_test_objects vol_bridge_all (players)) TRUE)
		)
	)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_bridge_all (players)) TRUE)
			(ai_scene overlook_remark_scene overlook_remark all_allies)
			(< (ai_living_count all_allies) 1)
		)
	30 300)
)


;-------------------------------------------------------------------------------
;Bridges

;Cortana bridge comments
(script dormant bridge_cortana_comment
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'The Covenant has control of the bridge ahead.'")
	(sleep (ai_play_line_on_object NONE 0440))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0440_cor))
	(sleep 15)
	(print "'They're going to try and bottle us up on this side of the gorge!'")
	(sleep (ai_play_line_on_object NONE 0450))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0450_cor))
	(sleep 30)
	(game_save)

	(sleep_until (= (volume_test_objects vol_bridge_near_bunker (players)) TRUE))
	(print "CORTANA: 'The controls to extend the bridge should be in this structure!'")
	(sleep (ai_play_line_on_object NONE 0460))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0460_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

(global boolean wraith_warning_go FALSE)
(script command_script bridge_wraith_warn
	(set wraith_warning_go TRUE)
	(cs_switch bridge_ally)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Watch out, Chief!  Wraiths on the far side!'")
	(cs_play_line 0480)
)

(script dormant bridge_wraith_warning
	(sleep 300)
	(sleep_until 
		(OR
			(ai_scene bridge_wraith_warn_scene bridge_wraith_warn all_allies)
			(< (ai_living_count all_allies) 1)
		)
	30 150)
	
	(sleep 30)
	
	(if (= wraith_warning_go FALSE)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Watch out, Chief!  Wraiths on the far side!'")
			(sleep (ai_play_line_on_object NONE 2030))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2030_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)	
)

;---

;Scripts for phantoms bringing in ghosts
(script command_script bridge_phantom_01a
	(cs_vehicle_boost TRUE)
	(cs_fly_by bridge_airspace/ph0 10)
	(cs_fly_by bridge_airspace/ph1 10)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed .5)
	(cs_fly_to bridge_airspace/pel5 1)
	(cs_fly_to bridge_airspace/ph2 1)

	(vehicle_unload (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) "phantom_lc")
;	(sleep 60)

	(sleep_until (< (ai_living_count bridge_phantom_01) 2))
	(cs_fly_to_and_face bridge_airspace/pel5 bridge_airspace/ph1 2)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by bridge_airspace/ph1 10)
	(cs_fly_by bridge_airspace/ph0 10)
	(cs_vehicle_boost FALSE)
	(cs_fly_to bridge_airspace/phx 20)
	(ai_erase bridge_phantom_01)
)
(script command_script bridge_phantom_01b
	(cs_vehicle_boost TRUE)
	(cs_fly_by bridge_airspace/ph0 10)
;	(cs_fly_by bridge_airspace/ph1 10)
	(cs_fly_by bridge_airspace/ph1too 10)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed .5)
	(cs_fly_to bridge_airspace/ph3 1)
	(cs_fly_to bridge_airspace/ph4 1)

	(vehicle_unload (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) "phantom_lc")
;	(sleep 60)

	(sleep_until (< (ai_living_count bridge_phantom_01) 2))
	(cs_fly_to_and_face bridge_airspace/ph3 bridge_airspace/ph1 2)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
;	(cs_fly_by bridge_airspace/ph1 10)
	(cs_fly_by bridge_airspace/ph1too 10)
	(cs_fly_by bridge_airspace/ph0 10)
	(cs_vehicle_boost FALSE)
	(cs_fly_to bridge_airspace/phx 20)
	(ai_erase bridge_phantom_01)
)
(script command_script bridge_phantom_02a
	(cs_vehicle_boost TRUE)
	(cs_fly_by bridge_airspace/pel0 10)
	(cs_fly_by bridge_airspace/pel1 10)
	(cs_fly_by bridge_airspace/pel2 20)
	(cs_vehicle_boost FALSE)
;	(cs_fly_by bridge_airspace/pel3 10)
	(cs_fly_by bridge_airspace/pel4 5)
	(cs_fly_to bridge_airspace/pel5 1)
;	(cs_vehicle_speed .5)
	(cs_fly_to bridge_airspace/ph2 1)

	(vehicle_unload (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) "phantom_lc")
;	(sleep 60)

	(sleep_until (< (ai_living_count bridge_phantom_02) 2))
	(cs_fly_to_and_face bridge_airspace/pel5 bridge_airspace/pel4 2)
	(cs_vehicle_speed 1)
	(cs_fly_by bridge_airspace/pel4 5)
	(cs_fly_by bridge_airspace/pel3 5)
	(cs_fly_by bridge_airspace/pel2 5)
	(cs_fly_by bridge_airspace/pel1 5)
	(cs_fly_by bridge_airspace/pel0 5)
	(cs_fly_by bridge_airspace/pelx 5)
	(ai_erase bridge_phantom_02)
)
(script command_script bridge_phantom_02b
	(cs_vehicle_boost TRUE)
	(cs_fly_by bridge_airspace/pel0 10)
	(cs_fly_by bridge_airspace/pel1 10)
	(cs_fly_by bridge_airspace/pel2 20)
	(cs_vehicle_boost FALSE)
;	(cs_fly_by bridge_airspace/pel3 10)
	(cs_fly_to bridge_airspace/ph3 1)
;	(cs_vehicle_speed .5)
	(cs_fly_to bridge_airspace/ph4 1)

	(vehicle_unload (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) "phantom_lc")
;	(sleep 60)

	(sleep_until (< (ai_living_count bridge_phantom_02) 2))
	(cs_fly_to_and_face bridge_airspace/ph3 bridge_airspace/pel2 2)
	(cs_vehicle_speed 1)
	(cs_fly_by bridge_airspace/pel3 5)
	(cs_fly_by bridge_airspace/pel2 5)
	(cs_fly_by bridge_airspace/pel1 5)
	(cs_fly_by bridge_airspace/pel0 5)
	(cs_fly_by bridge_airspace/pelx 5)
	(ai_erase bridge_phantom_02)
)

;Spawns ghosts via phantom
(script static void bridge_phantom_reinforce_01a
	(ai_place bridge_phantom_01)
;	(ai_place bridge_phantom_ghosts_01)
	(ai_place bridge_phantom_ghosts_02)
	
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/2))
	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) TRUE)

	(cs_run_command_script bridge_phantom_01/pilot bridge_phantom_01a)
	(sleep_until (< (ai_living_count bridge_phantom_01) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot))
)
(script static void bridge_phantom_reinforce_01b
	(ai_place bridge_phantom_01)
	(ai_place bridge_phantom_ghosts_01)
	
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_01/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_01/2))
	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot) TRUE)

	(cs_run_command_script bridge_phantom_01/pilot bridge_phantom_01b)
	(sleep_until (< (ai_living_count bridge_phantom_01) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot))
)
(script static void bridge_phantom_reinforce_02a
	(ai_place bridge_phantom_02)
	(ai_place bridge_phantom_ghosts_02)
	
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/2))
	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) TRUE)

	(cs_run_command_script bridge_phantom_02/pilot bridge_phantom_02a)
	(sleep_until (< (ai_living_count bridge_phantom_01) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot))
)
(script static void bridge_phantom_reinforce_02b
	(ai_place bridge_phantom_02)
;	(ai_place bridge_phantom_ghosts_02)
	(ai_place bridge_phantom_ghosts_02)
	
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/2))
	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_phantom_02/pilot) TRUE)

	(cs_run_command_script bridge_phantom_02/pilot bridge_phantom_02b)
	(sleep_until (< (ai_living_count bridge_phantom_01) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location bridge_phantom_01/pilot))
)

;Makes elites run for ghosts when alerted
(script command_script bridge_ghostman_r
	(cs_abort_on_alert TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to bridge/b1)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_go_to bridge/b2)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_go_to bridge/b3)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_go_to bridge/b4)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_go_to bridge/b5)
					(sleep (random_range 30 90))
				)
			)
			(> (ai_combat_status ai_current_actor) ai_combat_status_idle)
		)
	)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to bridge/r)
	(sleep 5)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/r) FALSE)
	(sleep 5)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/r))
)
(script command_script bridge_ghostman_l
	(cs_abort_on_alert TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to bridge/a1)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_go_to bridge/a2)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_go_to bridge/a3)
					(sleep (random_range 30 90))
				)
				(begin
					(cs_go_to bridge/a4)
					(sleep (random_range 30 90))
				)
			)
			(> (ai_combat_status ai_current_actor) ai_combat_status_idle)
		)
	)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to bridge/l)
	(sleep 5)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/l) FALSE)
	(sleep 5)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/l))
)

;For spawning waves of ghosts by phantom, varying with difficulty level
(global short bridge_vehicles_total 1)

;Spawns phantoms to bring in ghosts
(script dormant bridge_ghosts_by_phantom
	(if (difficulty_heroic)
		(set bridge_vehicles_total 2)
	)
	(if (difficulty_legendary)
		(set bridge_vehicles_total 3)
	)
	(sleep_until (> (ai_combat_status bridge_enemies_bunker) ai_combat_status_idle))	
	(sleep_until (< (ai_living_count bridge_ghost_elites) 1) 30 300)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/l) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/r) FALSE)
	
	(sleep_until (> (ai_living_count bridge_vehicles_all) 0) 30 450)
	
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(< (ai_living_count bridge_vehicles_all) 1)
					(= (volume_test_objects vol_bridge_ghost_spawn (players)) TRUE)
					(= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE)
				)
			)
			(if 
				(OR
					(= (volume_test_objects vol_bridge_ghost_spawn (players)) TRUE)
					(= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE)
				)
					(sleep_forever)
			)
			(if (> bridge_vehicles_total 0)
				(begin
					(game_save)
					(ai_place bridge_phantom_ghosts_01 1)
				)
			)
			(sleep (random_range 60 120))
			(if 
				(OR
					(= (volume_test_objects vol_bridge_ghost_spawn (players)) TRUE)
					(= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE)
				)
					(sleep_forever)
			)
			(if (> bridge_vehicles_total 0)
				(begin
					(game_save)
					(ai_place bridge_phantom_ghosts_01 1)
				)
			)
			(set bridge_vehicles_total (- bridge_vehicles_total 1))
			(OR
				(<= bridge_vehicles_total 0)
				(= (volume_test_objects vol_bridge_ghost_spawn (players)) TRUE)
				(= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE)
			)
		)
	)
	
	(sleep_until 
		(AND
			(< (ai_living_count bridge_vehicles_all) 1)
			(< (ai_living_count bridge_bunker_turrets) 1)
		)
	)
	(game_save_no_timeout)
	
;*	(begin_random
		(if (> bridge_vehicles_total 0)
			(begin
				(if (difficulty_normal)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_heroic)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_legendary)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 2))
				)
				(set bridge_vehicles_total (- bridge_vehicles_total 1))
				(game_save)
				(bridge_phantom_reinforce_01a)
			)
		)
		(if (> bridge_vehicles_total 0)
			(begin
				(if (difficulty_normal)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_heroic)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_legendary)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 2))
				)
				(set bridge_vehicles_total (- bridge_vehicles_total 1))
				(game_save)
				(bridge_phantom_reinforce_01b)
			)
		)
		(if (> bridge_vehicles_total 0)
			(begin
				(if (difficulty_normal)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_heroic)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_legendary)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 2))
				)
				(set bridge_vehicles_total (- bridge_vehicles_total 1))
				(game_save)
				(bridge_phantom_reinforce_01a)
			)
		)
		(if (> bridge_vehicles_total 0)
			(begin
				(if (difficulty_normal)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_heroic)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 1))
				)
				(if (difficulty_legendary)
					(sleep_until (< (ai_living_count bridge_vehicles_all) 2))
				)
				(set bridge_vehicles_total (- bridge_vehicles_total 1))
				(game_save)
				(bridge_phantom_reinforce_01b)
			)
		)
	)
	*;
)

;---

;Reminder to enter bunker and activate bridge
(script dormant bridge_activate_reminder
	(sleep_until (= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE) 30 16000)
	(if 
		(AND
			(= (volume_test_objects vol_bridge_inside_bunker (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Get into that structure and find the controls to extend the bridge!'")
				(sleep (ai_play_line_on_object NONE 0470))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0470_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Cortana's response to jackass marine
(script dormant bridge_cortana_response
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'A sermon, actually.  I've been listening to him since we landed.'")
	(print "CORTANA: 'So far it's the standard Covenant liturgy,'")
	(print "CORTANA: 'but I'll translate if he says anything interesting.'")
	(sleep (ai_play_line_on_object NONE 0080))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0080_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Jackass pointing out the prophet hologram
(global boolean regret_ally_comment_go FALSE)
(script command_script bridge_holo_comment
	(set regret_ally_comment_go TRUE)
	(cs_switch bridge_marine)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "MARINE: 'Isn't that our target?'")
	(cs_play_line 0060)
	(sleep 30)
	(print "MARINE: 'What's he doing?  Giving a speech?'")
	(cs_play_line 0070)
	(wake bridge_cortana_response)
)

(global boolean bunker_holo_trans FALSE)
(global boolean bunker_holo_chant TRUE)
(script dormant bunker_holo_looper
	(object_create regret01)
	(objects_attach bunker_throne "driver" regret01 "")
	(ai_disregard regret01 TRUE)
	(sleep_until
		(begin
			(begin_random
				(if (= bunker_holo_trans FALSE)
					(begin
						(set bunker_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant1a" TRUE)
						(sleep (ai_play_line_on_object regret01 3000))
						(sleep (random_range 240 480))
						(set bunker_holo_chant FALSE)
					)
				)
				(if (= bunker_holo_trans FALSE)
					(begin
						(set bunker_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant2b" TRUE)
						(sleep (ai_play_line_on_object regret01 3001))
						(sleep (random_range 240 480))
						(set bunker_holo_chant FALSE)
					)
				)
				(if (= bunker_holo_trans FALSE)
					(begin
						(set bunker_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant2c" TRUE)
						(sleep (ai_play_line_on_object regret01 3002))
						(sleep (random_range 240 480))
						(set bunker_holo_chant FALSE)
					)
				)
				(if (= bunker_holo_trans FALSE)
					(begin
						(set bunker_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant3a" TRUE)
						(sleep (ai_play_line_on_object regret01 3003))
						(sleep (random_range 240 480))
						(set bunker_holo_chant FALSE)
					)
				)
				(if (= bunker_holo_trans FALSE)
					(begin
						(set bunker_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant3c" TRUE)
						(sleep (ai_play_line_on_object regret01 3004))
						(sleep (random_range 240 480))
						(set bunker_holo_chant FALSE)
					)
				)
				(if (= bunker_holo_trans FALSE)
					(begin
						(set bunker_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant5a" TRUE)
						(sleep (ai_play_line_on_object regret01 3005))
						(sleep (random_range 240 480))
						(set bunker_holo_chant FALSE)
					)
				)
				(if (= bunker_holo_trans FALSE)
					(begin
						(set bunker_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant6a" TRUE)
						(sleep (ai_play_line_on_object regret01 3006))
						(sleep (random_range 240 480))
						(set bunker_holo_chant FALSE)
					)
				)
			)
			FALSE
		)
	)
)

;Cortana translates if you linger near the hologram long enough
(script dormant bridge_holo_translate
	(sleep_until
		(AND
			(< (ai_living_count bridge_enemies_bunker) 1)
			(= (volume_test_objects vol_bunker_upper_level (players)) TRUE)
		)
	)
	(sleep_until 
		(OR
			(< (ai_living_count all_allies) 1)	
			(ai_scene bridge_holo_scene bridge_holo_comment all_allies)
		)
	30 300)

	(sleep 30)
	(if 
		(AND
			(= regret_ally_comment_go FALSE)
			(= (volume_test_objects vol_bunker_upper_level (players)) TRUE)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Regret's giving a speech - a sermon to be exact.'") 
				(print "'So far it's the standard Covenant liturgy, but I'll translate if he says anything interesting.'")
				(sleep (ai_play_line_on_object NONE 2110))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2110_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_bunker_upper_level (players)) TRUE) 
			(< (ai_living_count bridge_enemies_bunker) 1)
		)
	)
	(sleep 60)
	(set bunker_holo_trans TRUE)
	
	(sleep_until 
		(AND
			(= (objects_can_see_object (players) regret01 30) TRUE)
			(= (volume_test_objects vol_bunker_upper_level (players)) TRUE)
			(= bunker_holo_chant FALSE)
		)
	)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(custom_animation regret01 objects\characters\prophet\prophet "regret_l05_0090_por" TRUE)
	(print "REGRET: 'The Forerunners, our most exalted Lords, used the seven sacred rings...'")
	(print "'...to flee a doomed existence - to escape their endless struggle against the Flood!'")
	(sleep (ai_play_line_on_object regret01 0090))
	(sleep 30)
	(custom_animation regret01 objects\characters\prophet\prophet "regret_l05_0100_por" TRUE)
	(print "'Long ago, the Prophets and Elites fought an equally fruitless war.'") 
	(print "'Indeed, I suspect we would still be at each other's throats had the Prophets...'") 
	(print "'...not found evidence of the Forerunners and their Great Journey!'")
	(sleep (ai_play_line_on_object regret01 0100))
;	(sound_impulse_start sound\dialog\levels\05_deltatemple\mission\L05_0100_por regret01 1)
;	(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0100_por))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 240 480))
	(set bunker_holo_trans FALSE)
)

;temp global to see if the following command script played or not
(global boolean bridge_ally_comment_go FALSE)

;Ally comment after bridge activated
(script command_script bridge_ally_comment
	(cs_switch bridge_ally)
	(cs_enable_pathfinding_failsafe TRUE)

;9/11
	(set bridge_ally_comment_go TRUE)

	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Good. The bridge is down. Now about those Wraiths…'")
	(cs_play_line 0490)
)

;Spawns guys that run out into the two large rock formations
(script dormant crack_spawn
	(sleep_until (> (ai_combat_status bridge_enemies_bunker) ai_combat_status_idle))
;	(if (difficulty_legendary)
;		(ai_place bridge_crack_jackals 0)
;	)
	(if (difficulty_heroic)
		(ai_place bridge_crack_jackals 1)
	)
	(if (difficulty_normal)
		(ai_place bridge_crack_jackals 2)
	)
	;(sleep 15)
	;(ai_place bridge_crack_grunts)
)

(script dormant bunker_turret_remanning
	(sleep_until
		(begin
			(if 
				(AND
					(= (volume_test_objects vol_bridge_inside_bunker (players)) FALSE)
					(> (player_count) 0)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_01) "c_turret_ap_d" (ai_actors all_enemies)) FALSE)
					(> (object_get_health (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_01)) 0)
					(< (ai_living_count bunker_turret_remen) 1)
				)
					(begin
						(ai_place bunker_turret_remen/1)
						(sleep 5)
						(ai_vehicle_enter bunker_turret_remen (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_01))
					)
			)
			(if 
				(AND
					(= (volume_test_objects vol_bridge_inside_bunker (players)) FALSE)
					(> (player_count) 0)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_02) "c_turret_ap_d" (ai_actors all_enemies)) FALSE)
					(> (object_get_health (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_02)) 0)
					(< (ai_living_count bunker_turret_remen) 1)
				)
					(begin
						(ai_place bunker_turret_remen/2)
						(sleep 5)
						(ai_vehicle_enter bunker_turret_remen (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_02))
					)
			)
			(if 
				(AND
					(= (volume_test_objects vol_bridge_inside_bunker (players)) FALSE)
					(> (player_count) 0)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_03) "c_turret_ap_d" (ai_actors all_enemies)) FALSE)
					(> (object_get_health (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_03)) 0)
					(< (ai_living_count bunker_turret_remen) 1)
				)
					(begin
						(ai_place bunker_turret_remen/3)
						(sleep 5)
						(ai_vehicle_enter bunker_turret_remen (ai_vehicle_get_from_starting_location bridge_bunker_turrets/bunker_03))
					)
			)
			(OR
				(= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE)
				(> (ai_spawn_count bunker_turret_remen) 5)
			)
		)
	)
)

;Spawning for the bunker
(script dormant bunker_upper_spawn_01
	(sleep_until 
		(OR
			(= (volume_test_objects vol_bunker_front (players)) TRUE)
			(< (ai_living_count bridge_enemies_bunker) 1)
		)
	)

;	(wake bunker_holo_looper)
	(game_save)

	(if (< (ai_living_count bridge_bunker_elites) 2)
		(ai_place bridge_bunker_elites_01 1)
	)
	(ai_place bridge_bunker_grunts_01 (- (random_range 1 3) (ai_living_count bridge_bunker_grunts)))

	(sleep_until 
		(OR
			(= (volume_test_objects vol_bunker_front (players)) TRUE)
			(< (ai_living_count bridge_enemies_bunker) 1)
		)
	)

	(game_save)

	(if 
		(AND
			(< (ai_living_count bridge_enemies_bunker) 1)
			(= (volume_test_objects vol_bridge_inside_bunker (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count bridge_bunker_elites) 2)
					(ai_place bridge_bunker_elites_01 1)
				)
				(ai_place bridge_bunker_jackals_01 (- 2 (ai_living_count bridge_bunker_jackals)))
			)
	)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_bunker_front (players)) TRUE)
			(< (ai_living_count bridge_enemies_bunker) 1)
		)
	)

	(game_save)

	(if 
		(AND
			(< (ai_living_count bridge_enemies_bunker) 1)
			(= (volume_test_objects vol_bridge_inside_bunker (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count bridge_bunker_elites) 2)
					(ai_place bridge_bunker_elites_01 (- 1 (ai_living_count bridge_bunker_elites)))
				)
				(ai_place bridge_bunker_jackals_01 (- 1 (ai_living_count bridge_bunker_jackals)))
				(ai_set_orders bridge_bunker_elites_01 bridge_bunker_in_upper_01)
				(ai_set_orders bridge_bunker_jackals_01 bridge_bunker_in_upper_01)
			)
	)
)
(script dormant bunker_upper_spawn_03
	(sleep_until 
		(OR
			(= (volume_test_objects vol_bunker_upper_level (players)) TRUE)
			(= (volume_test_objects vol_bunker_roof (players)) TRUE)
			(= (volume_test_objects vol_bunker_spawnstop_01 (players)) TRUE) 
			(= (volume_test_objects vol_bunker_spawnstop_02 (players)) TRUE)
			(= (volume_test_objects vol_bunker_spawnstop_03 (players)) TRUE)
		)
	)

;	(wake bunker_holo_looper)
	(game_save)
	(wake music_05a_03_start)

	(ai_place bridge_control_elites_01 1)
	(ai_place bridge_control_jackals_01 (random_range 0 3))
	(ai_place bridge_control_grunts_01 (- 3 (ai_living_count bridge_control_jackals_01)))
)

;Spawning for entry at the lower level
(script dormant bunker_lower_spawn_01
	(sleep_until (= (volume_test_objects vol_bunker_backdoor (players)) TRUE))

;	(wake bunker_holo_looper)
	(game_save)

	(if (< (ai_living_count bridge_bunker_elites) 2)
		(ai_place bridge_backdoor_elites_01 1)
	)
	(ai_place bridge_backdoor_grunts_01 (- (random_range 1 3) (ai_living_count bridge_bunker_grunts)))
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_bunker_backdoor (players)) TRUE)
			(< (ai_living_count bridge_enemies_bunker) 1)
		)
	)

	(game_save)

	(if 
		(AND
			(< (ai_living_count bridge_enemies_bunker) 1)
			(= (volume_test_objects vol_bunker_lower_level (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count bridge_bunker_elites) 2)
					(ai_place bridge_backdoor_elites_01 1)
				)
				(ai_place bridge_backdoor_jackals_01 (- 2 (ai_living_count bridge_bunker_jackals)))
			)
	)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_bunker_backdoor (players)) TRUE)
			(< (ai_living_count bridge_enemies_bunker) 1)
		)
	)

	(game_save)

	(if 
		(AND
			(< (ai_living_count bridge_enemies_bunker) 1)
			(= (volume_test_objects vol_bunker_lower_level (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count bridge_bunker_elites) 2)
					(ai_place bridge_backdoor_elites_01 (- 1 (ai_living_count bridge_bunker_elites)))
				)
				(ai_place bridge_backdoor_jackals_01 (- 2 (ai_living_count bridge_bunker_jackals)))
				(ai_set_orders bridge_backdoor_elites_01 bridge_bunker_in_lower_02)
				(ai_set_orders bridge_backdoor_jackals_01 bridge_bunker_in_lower_02)
			)
	)
)

;Shuts off spawning if you get too far into the structure
(script dormant bunker_spawn_checker
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_bunker_upper_level (players)) TRUE)
			(= (volume_test_objects vol_bunker_spawnstop_01 (players)) TRUE) 
			(= (volume_test_objects vol_bunker_spawnstop_02 (players)) TRUE)
			(= (volume_test_objects vol_bunker_spawnstop_03 (players)) TRUE)
		)
	)
	(sleep_forever bunker_upper_spawn_01)
	(sleep_forever bunker_lower_spawn_01)
	(sleep_forever bunker_turret_remanning)
)

;---

;Reminder to wait for tank if you start to leave without it
(script dormant bridge_pelican_wait
	(sleep_until 
		(OR
			(= (volume_test_objects vol_bridge_middle (players)) TRUE)
			(= (volume_test_objects vol_bridge_farside_all (players)) TRUE)
		)
	)
	(if 
		(AND
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player0)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player1)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player1)) FALSE)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'You don't want the tank?  O-kay…I guess we'll leave it for the others.'")
				(sleep (ai_play_line_on_object NONE 0510))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0510_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
	(wake music_05a_04_start)	
)

;Reminder to head across bridge if you're taking forever
(script dormant bridge_cross_reminder
	(sleep_until (= (volume_test_objects vol_bridge_farside_all (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_bridge_farside_all (players)) FALSE)
			(> (ai_living_count bridge_farside_wraiths) 0)
			(> (player_count) 0)
		)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Let's head across the bridge and deal with those Wraiths.'")
			(sleep (ai_play_line_on_object NONE 0520))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0520_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

;Banshees boost to follow
(script command_script banshee_boost
	(cs_vehicle_boost TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 50))
)

;Tells when bridge pelican has arrived with tank
(global boolean bridge_pelican_in_sight FALSE)
(global boolean bridge_pelican_arrived FALSE)

(script dormant bridge_pelican_timer
	(sleep 8000)
	(object_destroy (ai_vehicle_get_from_starting_location bridge_pelican/pilot))
)

;Pelican flies in with scorpion
(script command_script gimme_tank
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by bridge_airspace/pel0 50)
	(cs_fly_by bridge_airspace/pel1 50)
;	(ai_place bridge_pelican_chasers 2)
;	(cs_run_command_script bridge_pelican_chasers banshee_boost)
	(cs_fly_by bridge_airspace/pel2 50)
	(cs_fly_by bridge_airspace/pel3 50)
	(cs_fly_by bridge_airspace/pel4 20)
	(set bridge_pelican_in_sight TRUE)
	(cs_vehicle_boost FALSE)
	(ai_set_orders bridge_pelican_chasers bridge_air)
	(cs_fly_to bridge_airspace/pel4too 3)
	(cs_vehicle_speed .5)
	(cs_fly_to bridge_airspace/pel6 3)
	
	(cs_fly_to_and_face bridge_airspace/pel6 bridge_airspace/pel5 1)
	(cs_fly_to_and_face bridge_airspace/pel7 bridge_airspace/pel5 1)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_bridge_tank (players)) FALSE)
			(= (volume_test_objects vol_bridge_tank (ai_actors all_allies)) FALSE)
			(> (player_count) 0)
		)
	)
	(vehicle_unload (ai_vehicle_get_from_starting_location bridge_pelican/pilot) "pelican_lc")
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location bridge_pelican/pilot) "pelican_p")
	(set bridge_pelican_arrived TRUE)
	(wake bridge_pelican_timer)

	(sleep_until (< (ai_living_count bridge_pelican) 4))
	(cs_vehicle_speed .5)
	(cs_fly_to bridge_airspace/pel6 2)
	(cs_vehicle_boost TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_by bridge_airspace/pel4 10)
	(cs_fly_by bridge_airspace/pel1 20)
	(cs_fly_by bridge_airspace/pel0 20)
	(cs_fly_by bridge_airspace/pelx 20)
	(ai_erase bridge_pelican)
)

;Creates pelican and loads it
(script dormant bridge_pelican_run	
	(ai_place allies_bridge_pelican (- 2 (ai_living_count all_allies)))
	(ai_place bridge_pelican)
	(ai_place bridge_tank)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location bridge_pelican/pilot))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_pelican/pilot) "pelican_p" (ai_actors allies_bridge_pelican))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_pelican/pilot) "pelican_lc" (ai_vehicle_get_from_starting_location bridge_tank/driver))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_pelican/pilot) TRUE)	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" TRUE)
	(cs_run_command_script bridge_pelican/pilot gimme_tank)
)
(script static void short_bridge_pel	
	(ai_place allies_bridge_pelican (- 2 (ai_living_count all_allies)))
	(ai_place bridge_pelican)
	(ai_place bridge_tank)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location bridge_pelican/pilot))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_pelican/pilot) "pelican_p" (ai_actors allies_bridge_pelican))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_pelican/pilot) "pelican_lc" (ai_vehicle_get_from_starting_location bridge_tank/driver))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_pelican/pilot) TRUE)	
	(cs_run_command_script bridge_pelican/pilot gimme_tank)
)

;Spawns banshees after you get the tank
(script dormant bridge_banshee_spawn
	(sleep_until 
		(OR
			(< (ai_living_count bridge_farside_wraiths) 1)
			(= (volume_test_objects vol_winding_path (players)) TRUE)
		)
	)
	(if (= (volume_test_objects vol_winding_path (players)) TRUE)
		(sleep_forever)
	)
	(if 
		(AND
			(= (volume_test_objects vol_winding_path (players)) FALSE)
			(OR
				(difficulty_normal)
				(difficulty_heroic)
			)
		)
			(begin
				(ai_place bridge_banshees 1)
				(cs_run_command_script bridge_banshees banshee_boost)		
			)
	)
	(if 
		(AND
			(difficulty_legendary)
			(= (volume_test_objects vol_winding_path (players)) FALSE)
		)
			(begin
				(ai_place bridge_banshees 2)			
				(cs_run_command_script bridge_banshees banshee_boost)		
			)
	)

	(sleep_until 
		(OR
			(< (ai_living_count bridge_banshees) 1)
			(= (volume_test_objects vol_winding_path (players)) TRUE)
		)
	)
	(if (= (volume_test_objects vol_winding_path (players)) TRUE)
		(sleep_forever)
	)
	(if 
		(AND
			(= (volume_test_objects vol_winding_path (players)) FALSE)
			(OR
				(difficulty_normal)
				(difficulty_heroic)
			)
		)
			(begin
				(ai_place bridge_banshees 1)			
				(cs_run_command_script bridge_banshees banshee_boost)		
			)
	)
	(if 
		(AND
			(difficulty_legendary)
			(= (volume_test_objects vol_winding_path (players)) FALSE)
		)
			(begin
				(ai_place bridge_banshees 2)			
				(cs_run_command_script bridge_banshees banshee_boost)		
			)
	)
)

;Spawns ghosts on the far side once the bridge is extended
(script dormant farside_ghosts_spawn
	(sleep_until 
		(AND 
			(= (volume_test_objects vol_bridge_middle (players)) TRUE) 
			(= (device_get_position da_bridge) 0)
		)
	)
	(ai_place bridge_farside_ghosts 2)
	
	(sleep_until
		(OR
			(= (volume_test_objects vol_winding_path (players)) TRUE)
			(< (ai_living_count bridge_farside_ghosts) 1)
		)
	)
	(if 
		(AND
			(= (volume_test_objects vol_winding_path (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count bridge_farside_ghosts) 1)
		)
			(ai_place bridge_farside_ghosts 2)
	)
)

(script dormant bridge_spare_ghost_spawn
	(sleep_until
		(begin
			(if 
				(AND
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/1)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/2)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/3)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/4)) 1)
					(= (objects_can_see_flag (players) extra_ghost_01 45) FALSE)
					(> (objects_distance_to_flag (players) extra_ghost_01) 5)
				)
					(ai_place bridge_free_ghost/1)
			)
			(if 
				(AND
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/1)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/2)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/3)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/4)) 1)
					(= (objects_can_see_flag (players) extra_ghost_02 45) FALSE)
					(> (objects_distance_to_flag (players) extra_ghost_02) 5)
				)
					(ai_place bridge_free_ghost/2)
			)
			(if 
				(AND
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/1)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/2)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/3)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/4)) 1)
					(= (objects_can_see_flag (players) extra_ghost_03 45) FALSE)
					(> (objects_distance_to_flag (players) extra_ghost_03) 5)
				)
					(ai_place bridge_free_ghost/3)
			)
			(if 
				(AND
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/1)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/2)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/3)) 1)
					(< (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/4)) 1)
					(= (objects_can_see_flag (players) extra_ghost_04 45) FALSE)
					(> (objects_distance_to_flag (players) extra_ghost_04) 5)
				)
					(ai_place bridge_free_ghost/4)
			)
			(OR
				(> (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/1)) 0)
				(> (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/2)) 0)
				(> (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/3)) 0)
				(> (list_count (ai_vehicle_get_from_starting_location bridge_free_ghost/4)) 0)
			)
		)
	)			
)

;----

(script command_script bridge_wraith_engage
	(cs_abort_on_damage TRUE)
	(cs_go_to bridge/p0)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE (ai_vehicle_get_from_starting_location LZ_warthog_01/driver))
	;(sleep_until (= (device_get_position da_bridge) 0))
	(sleep_until (>= (ai_combat_status ai_current_actor) ai_combat_status_visible))
)

;to tell when the bridge reverses direction
(global real bridge_state 0)

;Overall script for bridges
(script dormant bridges_start
	(device_set_position_immediate da_bridge .5)
	(device_set_position real_bridge 1)
	(object_create waterfall_far)
	(object_create waterfall_close)
	(wake bunker_holo_looper)

	(ai_place bridge_bunker_ghosts)
	(ai_place bridge_ghost_elites 2)
	(cs_run_command_script bridge_ghost_elites/r bridge_ghostman_r)
	(cs_run_command_script bridge_ghost_elites/l bridge_ghostman_l)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/l) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/r) TRUE)
	(sleep 15)
	(if (difficulty_legendary)
		(ai_place bridge_bunker_turrets 4)
	)
	(if (difficulty_heroic)
		(ai_place bridge_bunker_turrets 3)
	)
	(if (difficulty_normal)
		(ai_place bridge_bunker_turrets 2)
	)
	(cs_run_command_script bridge_bunker_turrets stay_shooting)
	
	(sleep 15)
;	(sleep 15)
;	(ai_place bridge_turret_grunts_01 2)
;	(sleep 15)
;	(ai_place bridge_turret_grunts_02 1)
	
	(wake crack_spawn)
	;(wake bunker_upper_spawn_01)
	(wake bunker_upper_spawn_03)
	;(wake bunker_lower_spawn_01)
	(wake bunker_spawn_checker)
	(wake bridge_ghosts_by_phantom)
	(wake bunker_turret_remanning)

	(sleep_until (= (volume_test_objects vol_bridge_pause (players)) TRUE))
	(data_mine_set_mission_segment "05a_3_bridge")

	(wake music_05a_02_stop)

	(device_set_position da_bridge 1)
	(sleep 60)
	(wake bridge_cortana_comment)
	(wake bridge_activate_reminder)
	(device_group_change_only_once_more_set da_bridge TRUE)
	
	(sleep_until (= (volume_test_objects vol_bridge_engage (players)) TRUE))
	(ai_place bridge_farside_wraiths 1)
	(cs_run_command_script bridge_farside_wraiths bridge_wraith_engage)
	(wake bridge_wraith_warning)

	(sleep_until (= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE))
	(sleep_forever bridge_ghosts_by_phantom)
	
	(sleep_until
		(begin
			(set bridge_state (device_get_position da_bridge))
			(sleep 15)
			(< (device_get_position da_bridge) bridge_state)
		)
	)
	
	(wake music_05a_03_stop)
	(wake bridge_pelican_run)
	(wake lights)
	(ai_set_orders all_allies bridge_tank_wait)
	
	(game_save)
	
	(wake farside_ghosts_spawn)
	
	(if 
		(OR
			(difficulty_legendary)
			(difficulty_heroic)
		)
			(ai_place bridge_farside_wraiths (- 2 (ai_living_count bridge_farside_wraiths)))
			(ai_place bridge_farside_wraiths (- 1 (ai_living_count bridge_farside_wraiths)))
	)
	(wake bridge_cross_reminder)

	(sleep_until 
		(OR
			(ai_scene bridge_ally_scene bridge_ally_comment all_allies)
			(< (ai_living_count bridge_allies) 1)
		)
	30 150)
	(sleep 150)
	(if (= bridge_ally_comment_go FALSE)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Good. The bridge is down. Now about those Wraiths…'")
			(sleep (ai_play_line_on_object NONE 2040))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2040_cor))
		)
	)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "JOHNSON: 'Roger that, Marine. Armor's on the way!'")
	(sleep (ai_play_line_on_object NONE 0500))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0500_jon))
	(sleep 30)
	(ai_dialogue_enable TRUE)

	(game_save)
	(wake bridge_holo_translate)
	(wake bridge_pelican_wait)
	
	(sleep_until (= (device_get_position da_bridge) 0))	
	(device_set_position real_bridge 0)

	(sleep_until (= bridge_pelican_arrived TRUE))
	(wake bridge_banshee_spawn)
	(wake bridge_spare_ghost_spawn)

	(sleep_until 
		(OR
			(AND
				(= (volume_test_objects vol_bridge_all (players)) FALSE)
				(> (player_count) 0)
			)
			(AND 
				(OR
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/r) "ghost_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/l) "ghost_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_01/1) "ghost_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_01/2) "ghost_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/1) "ghost_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/2) "ghost_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_farside_ghosts/1) "ghost_d" (player0))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_farside_ghosts/2) "ghost_d" (player0))
				)
				(OR
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/l) "ghost_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_bunker_ghosts/r) "ghost_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_01/1) "ghost_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_01/2) "ghost_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/1) "ghost_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_phantom_ghosts_02/2) "ghost_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_farside_ghosts/1) "ghost_d" (player1))
					(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_farside_ghosts/2) "ghost_d" (player1))
					(= (game_is_cooperative) FALSE)
				)
			)
		)
	)
	(sleep 120)
	(game_save)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_tank/driver) FALSE)
	(if
		(OR
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player1))
		)
			(wake music_05a_04_start)
	)
)


;-------------------------------------------------------------------------------
;Winding Path

;turns waterfall sound on/off
(script dormant waterfall_toggle
	(sleep_until 
		(begin
			(sleep_until (= (volume_test_objects vol_waterfall_off (players)) TRUE))
			(object_destroy waterfall_far)
			(object_destroy waterfall_close)
			(sleep_until (= (volume_test_objects vol_waterfall_on (players)) TRUE))
			(object_create waterfall_far)
			(object_create waterfall_close)
			FALSE
		)
	)
)

;Tells heavies to deploy turrets
(global short w_path_turret_count 1)
(script command_script w_path_turret_0
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to w_path_turrets/go_p0)
	(cs_deploy_turret w_path_turrets/p0)
)
(script command_script w_path_turret_1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to w_path_turrets/go_p1)
	(cs_deploy_turret w_path_turrets/p1)
)
(script command_script w_path_turret_2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to w_path_turrets/go_p2)
	(cs_deploy_turret w_path_turrets/p2)
)
(script dormant w_path_turret_deploy
	(if (difficulty_legendary)
		(set w_path_turret_count 3)
	)
	(if (difficulty_heroic)
		(set w_path_turret_count 2)
	)
	(begin_random
		(if (> w_path_turret_count 0)
			(begin
				(ai_place w_path_heavies/0)
				(cs_run_command_script w_path_heavies/0 w_path_turret_0)
				(set w_path_turret_count (- w_path_turret_count 1))
			)
		)
		(if (> w_path_turret_count 0)
			(begin
				(ai_place w_path_heavies/1)
				(cs_run_command_script w_path_heavies/1 w_path_turret_1)
				(set w_path_turret_count (- w_path_turret_count 1))
			)
		)
		(if (> w_path_turret_count 2)
			(begin
				(ai_place w_path_heavies/2)
				(cs_run_command_script w_path_heavies/0 w_path_turret_2)
				(set w_path_turret_count (- w_path_turret_count 1))
			)
		)
	)
)

(global short w_path_spawn_count 5)

(script command_script throw_grenade
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(sleep_until (>= (ai_combat_status ai_current_actor) ai_combat_status_clear_los))
	(cs_grenade w_path_turrets/p3 1)
)

;Overall script for winding path
(script dormant winding_path_start
	(ai_disposable overlook_jackals TRUE)
	(ai_disposable bridge_enemies_all TRUE)
	(data_mine_set_mission_segment "05a_4_winding_path")
	(game_save)
	(wake waterfall_toggle)

	(ai_place w_path_free_ghost 1)
	(if (= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "" (players)) FALSE)
		(set w_path_spawn_count 3)
	)
	
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(< (ai_living_count winding_path_ghosts) 1)
					(= (volume_test_objects vol_winding_path_mid_01 (players)) TRUE)
				)
			)
			(if 
				(AND
					(= (volume_test_objects vol_winding_path_mid_01 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place winding_path_ghosts_01 1)
			)
			(sleep_until (= (volume_test_objects vol_winding_path_mid_01 (players)) TRUE) 30 (random_range 30 90))
			(if 
				(AND
					(= (volume_test_objects vol_winding_path_mid_01 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place winding_path_ghosts_01 1)
			)
			(OR
				(= (volume_test_objects vol_winding_path_mid_01 (players)) TRUE)
				(> (ai_spawn_count winding_path_ghosts_01) w_path_spawn_count)
			)
		)
	)
	
	(sleep_until (= (volume_test_objects vol_winding_path_mid_02 (players)) TRUE))
	(game_save)

;9/12

	(if (< (ai_living_count winding_path_enemies) 6)
		(ai_place winding_path_grunts 4)
	)
	(wake w_path_turret_deploy)
	
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(< (ai_living_count winding_path_ghosts) 1)
					(= (volume_test_objects vol_waterfall_on (players)) TRUE)
				)
			)
			(if 
				(AND
					(= (volume_test_objects vol_waterfall_on (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place winding_path_ghosts_02 1)
			)
			(sleep_until (= (volume_test_objects vol_waterfall_on (players)) TRUE) 30 (random_range 30 90))
			(if 
				(AND
					(= (volume_test_objects vol_waterfall_on (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place winding_path_ghosts_02 1)
			)
			(OR
				(= (volume_test_objects vol_waterfall_on (players)) TRUE)
				(> (ai_spawn_count winding_path_ghosts_02) w_path_spawn_count)
			)
		)
	)
	(game_save)
	(if (< (ai_living_count winding_path_enemies) 6)
		(ai_place winding_path_jackals 3)
	)
	(if (< (ai_living_count winding_path_enemies) 6)
		(ai_place winding_path_ledge_grunts 3)
	)
	(cs_run_command_script winding_path_ledge_grunts throw_grenade)
	
	(sleep_until 
		(AND
			(< (ai_living_count winding_path_ghosts) 1)
			(< (ai_living_count winding_path_grunts) 1)
			(< (ai_living_count winding_path_jackals) 1)
		)
	)
	(game_save)
)


;-------------------------------------------------------------------------------
;Old Temple Entrance

;Number of turrets in the area
(global short temple_ent_near_turret 1)
(global short temple_ent_far_turret 1)

;Places turrets, varying with difficulty
(script dormant temple_ent_turret_spawn
	(if (difficulty_legendary)
		(set temple_ent_near_turret 3)
		(set temple_ent_far_turret 3)
	)
	(if (difficulty_heroic)
		(set temple_ent_near_turret 2)
		(set temple_ent_far_turret 2)
	)
	(begin_random
		(if (> temple_ent_near_turret 0)
			(begin
				(ai_place temple_ent_turrets_01/1)
				(set temple_ent_near_turret (- temple_ent_near_turret 1))
			)
		)
		(if (> temple_ent_near_turret 0)
			(begin
				(ai_place temple_ent_turrets_01/2)
				(set temple_ent_near_turret (- temple_ent_near_turret 1))
			)
		)
		(if (> temple_ent_near_turret 0)
			(begin
				(ai_place temple_ent_turrets_02/1)
				(set temple_ent_near_turret (- temple_ent_near_turret 1))
			)
		)
		(if (> temple_ent_near_turret 0)
			(begin
				(ai_place temple_ent_turrets_02/2)
				(set temple_ent_near_turret (- temple_ent_near_turret 1))
			)
		)
	)
	(begin_random
		(if (> temple_ent_far_turret 0)
			(begin
				(ai_place temple_ent_turrets_03/1)
				(set temple_ent_far_turret (- temple_ent_far_turret 1))
			)
		)
		(if (> temple_ent_far_turret 0)
			(begin
				(ai_place temple_ent_turrets_03/2)
				(set temple_ent_far_turret (- temple_ent_far_turret 1))
			)
		)
		(if (> temple_ent_far_turret 0)
			(begin
				(ai_place temple_ent_turrets_04/1)
				(set temple_ent_far_turret (- temple_ent_far_turret 1))
			)
		)
		(if (> temple_ent_far_turret 0)
			(begin
				(ai_place temple_ent_turrets_04/2)
				(set temple_ent_far_turret (- temple_ent_far_turret 1))
			)
		)
	)
)

;Makes elites run for ghosts when alerted
(script command_script temple_ent_ghostman_r
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location temple_ent_ghosts_01/r))
)
(script command_script temple_ent_ghostman_l
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location temple_ent_ghosts_01/l))
)
(script dormant temple_ent_ghost_alert
	(sleep_until 
		(OR
			(> (ai_combat_status temple_ent_elites_01r) ai_combat_status_idle)
			(> (ai_combat_status temple_ent_elites_01l) ai_combat_status_idle)
		)
	)
	(cs_run_command_script temple_ent_elites_01r temple_ent_ghostman_r)
	(cs_run_command_script temple_ent_elites_01l temple_ent_ghostman_l)
)

;spawns ghosts, then banshees, then ghosts

(global short temple_ent_spawn_count 5)

(script dormant temple_ent_veh_spawn
	(if (= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "" (players)) FALSE)
		(set temple_ent_spawn_count 3)
	)
	
	(sleep_until 
		(OR
			(AND
				(< (ai_living_count temple_ent_elites_02r) 1)
				(< (ai_living_count temple_ent_elites_02l) 1)
				(< (ai_living_count temple_ent_ghosts_01) 1)
			)
			(AND
				(<= (object_get_health (ai_vehicle_get_from_starting_location temple_ent_ghosts_01/r)) 0)
				(<= (object_get_health (ai_vehicle_get_from_starting_location temple_ent_ghosts_01/l)) 0)
			)
			(= (volume_test_objects vol_temple_ent_02 (players)) TRUE)
			(= (volume_test_objects vol_temple_ent_03 (players)) TRUE)
		)
	30 900)
	
	(sleep_until 
		(begin
			(sleep_until 
				(OR
					(< (ai_living_count temple_ent_ghosts) 1)
					(= (volume_test_objects vol_temple_ent_02 (players)) TRUE)
				)
			)
			(game_save)
			(if (= (volume_test_objects vol_temple_ent_02 (players)) FALSE)
				(ai_place temple_ent_ghosts_02 (- 2 (ai_living_count temple_ent_ghosts)))
			)
			(sleep_until (= (volume_test_objects vol_temple_ent_02 (players)) TRUE) 30 (random_range 30 90))
			(if (= (volume_test_objects vol_temple_ent_02 (players)) FALSE)
				(ai_place temple_ent_ghosts_02 (- 2 (ai_living_count temple_ent_ghosts)))
			)
			(OR
				(> (ai_spawn_count temple_ent_ghosts_02) temple_ent_spawn_count)
				(= (volume_test_objects vol_temple_ent_02 (players)) TRUE)
				(= (volume_test_objects vol_temple_ent_03 (players)) TRUE)
			)
		)
	)

;*	(sleep_until 
		(begin
			(game_save)
			(ai_place temple_ent_banshees)
			(sleep_until 
				(begin
					(OR
						(< (ai_living_count temple_ent_banshees) 1)
						(= (volume_test_objects vol_temple_ent_03 (players)) TRUE)
					)
				)
			)
			(OR
				(= (ai_spawn_count temple_ent_banshees) 4)
				(= (volume_test_objects vol_temple_ent_03 (players)) TRUE)
			)
		)
	)
*;
	(sleep_until 
		(begin
			(sleep_until 
				(OR
					(< (ai_living_count temple_ent_ghosts) 1)
					(= (volume_test_objects vol_temple_ent_03 (players)) TRUE)
				)
			)
			(game_save)
			(if (= (volume_test_objects vol_temple_ent_03 (players)) FALSE)
				(ai_place temple_ent_ghosts_02 (- 2 (ai_living_count temple_ent_ghosts)))
			)
			(sleep_until (= (volume_test_objects vol_temple_ent_03 (players)) TRUE) 30 (random_range 30 90))
			(if (= (volume_test_objects vol_temple_ent_03 (players)) FALSE)
				(ai_place temple_ent_ghosts_02 (- 2 (ai_living_count temple_ent_ghosts)))
			)
			(OR
				(> (ai_spawn_count temple_ent_ghosts_02) (- (* temple_ent_spawn_count 2) 1))
				(= (volume_test_objects vol_temple_ent_03 (players)) TRUE)
			)
		)
	)
)

;Allies commenting about the area
(script command_script back_home_comment
	(cs_switch ally01)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Kinda reminds me of back home…'")
	(cs_play_line 0530)

	(cs_switch ally02)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Yeah. Too bad we're blowing it the hell up!'")
	(cs_play_line 0540)
)

;Reminder to push on
(script dormant temple_ent_reminder
	(sleep_until (= (volume_test_objects vol_tunnel_01 (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_tunnel_01 (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Let's push on. We need to find a an access point to those structures in the lake.'")
				(sleep (ai_play_line_on_object NONE 0580))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0580_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

(global boolean temple_ent_phase_01 FALSE)
(global boolean temple_ent_phase_02 FALSE)

;Overall script for old temple entrance
(script dormant old_temple_entrance_start
	(sleep_until (= (volume_test_objects vol_temple_entrance (players)) TRUE))
	(ai_disposable winding_path_enemies TRUE)
	(data_mine_set_mission_segment "05a_5_temple_entrance")
	(game_save)
	(wake 05a_title1)
	(wake music_05a_04_start_alt)
	(wake temple_ent_turret_spawn)
	(ai_place temple_ent_elites_01l 1)
	(ai_place temple_ent_elites_01r 1)
	
	(if (difficulty_heroic)
		(begin
			(ai_place temple_ent_jackals_01l 1)
			(ai_place temple_ent_jackals_01r 1)
		)
	)
	(if (difficulty_normal)
		(begin
			(ai_place temple_ent_jackals_01l 2)
			(ai_place temple_ent_jackals_01r 2)
		)
	)
	(ai_place temple_ent_ghosts_01 2)
	(wake temple_ent_ghost_alert)
	
	(sleep_until 
		(OR 
			(< (ai_living_count temple_ent_turrets_near) 1)
			(< (ai_living_count temple_ent_enemies_all) 4)
			(= (volume_test_objects vol_temple_ent_01 (players)) TRUE)
		)
	)
	(game_save)

;9/12

	(if (< (ai_living_count temple_ent_enemies_all) 8)
		(ai_place temple_ent_elites_02r (- 1 (ai_living_count temple_ent_elites_01r)))
	)
	(if (< (ai_living_count temple_ent_enemies_all) 8)
		(ai_place temple_ent_elites_02l (- 1 (ai_living_count temple_ent_elites_01l)))
	)
	(wake temple_ent_veh_spawn)
	(set temple_ent_phase_01 TRUE)

	(sleep_until 
		(OR 
			(< (ai_living_count temple_ent_enemies_all) 4)
			(= (volume_test_objects vol_temple_ent_02 (players)) TRUE)
		)
	)
	(game_save)
	(if (< (ai_living_count temple_ent_enemies_all) 8)
		(ai_place temple_ent_jackals_02c 2)
	)
	(if 
		(AND
			(> (object_get_health (ai_vehicle_get_from_starting_location temple_ent_turrets_03/1)) 0)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location temple_ent_turrets_03/1) "" (ai_actors all_enemies)) FALSE)
			(< (ai_living_count temple_ent_enemies_all) 8)
		)
			(ai_place temple_ent_grunts_01l 1)
	)
	(if 
		(AND
			(> (object_get_health (ai_vehicle_get_from_starting_location temple_ent_turrets_03/2)) 0)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location temple_ent_turrets_03/2) "" (ai_actors all_enemies)) FALSE)
			(< (ai_living_count temple_ent_enemies_all) 8)
		)
			(ai_place temple_ent_grunts_01l 1)
	)
	(if 
		(AND
			(> (object_get_health (ai_vehicle_get_from_starting_location temple_ent_turrets_04/1)) 0)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location temple_ent_turrets_04/1) "" (ai_actors all_enemies)) FALSE)
			(< (ai_living_count temple_ent_enemies_all) 8)
		)
			(ai_place temple_ent_grunts_01r 1)
	)
	(if 
		(AND
			(> (object_get_health (ai_vehicle_get_from_starting_location temple_ent_turrets_04/2)) 0)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location temple_ent_turrets_04/2) "" (ai_actors all_enemies)) FALSE)
			(< (ai_living_count temple_ent_enemies_all) 8)
		)
			(ai_place temple_ent_grunts_01r 1)
	)
	;rangers?
	(set temple_ent_phase_02 TRUE)

	(sleep_until 
		(OR 
			(< (ai_living_count temple_ent_enemies_all) 1)
			(= (volume_test_objects vol_temple_ent_03 (players)) TRUE)
		)
	)
	(game_save)
	(ai_set_orders temple_ent_ghosts temple_ent_back_02)
	(wake temple_ent_reminder)

	(sleep_until 
		(OR 
			(< (ai_living_count temple_ent_enemies_all) 1)
			(= (volume_test_objects vol_tunnel_01 (players)) TRUE)
		)
	)
	(game_save)

	(sleep_until 
		(OR
			(< (ai_living_count all_allies) 1)
			(ai_scene temple_ent_scene back_home_comment all_allies)
		)
	30 300)
)


;-------------------------------------------------------------------------------
;Tunnel

;Cortana the archaeologist
(script dormant temple_ent_arch
;9/11
;	(sleep_until (= (ai_trigger_test "done_fighting" tunnel_enemies_all) TRUE))
	(sleep_until 
		(OR 
			(= (ai_trigger_test "done_fighting" tunnel_enemies_all) TRUE)
			(= (volume_test_objects vol_old_temple_near_left (players)) TRUE)
		)
	)
	(sleep_until (= (volume_test_objects vol_old_temple_near_left (players)) TRUE) 30 450)
	(if 
		(AND
			(= (volume_test_objects vol_old_temple_near_left (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'These structures seem Forerunner,'")
				(print "'but they're much older than anything we ever found on the first Halo.'")
				(sleep (ai_play_line_on_object NONE 0570))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0570_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Ally commenting on the structures you're approaching
(global boolean structure_comment_go FALSE)
(script command_script old_temple_structure_comment
	(set structure_comment_go TRUE)
	(cs_switch ally)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Careful, we're coming-up on another structure!'")
	(cs_play_line 0600)
)

(script command_script tunnel_turret_0
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to tunnel_turrets/go_p0)
	(cs_deploy_turret tunnel_turrets/p0)
)
(script command_script tunnel_turret_1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to tunnel_turrets/go_p1)
	(cs_deploy_turret tunnel_turrets/p1)
)
(script command_script tunnel_turret_2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to tunnel_turrets/go_p2)
	(cs_deploy_turret tunnel_turrets/p2)
)
(script command_script tunnel_turret_3
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to tunnel_turrets/go_p3)
	(cs_deploy_turret tunnel_turrets/p3)
)

;Overall script for tunnel
(script dormant tunnel_start
	(ai_disposable temple_ent_enemies_all TRUE)
	(data_mine_set_mission_segment "05a_6_tunnel")
	(game_save)

;9/12

	(if (< (ai_living_count tunnel_enemies_all) 6)
		(ai_place tunnel_grunts 2)
	)
	(if (< (ai_living_count tunnel_enemies_all) 6)
		(ai_place tunnel_heavies_01 2)
	)
	(cs_run_command_script tunnel_heavies_01/0 tunnel_turret_0)
	(cs_run_command_script tunnel_heavies_01/1 tunnel_turret_1)
	(ai_place tunnel_ghosts_01 (- 2 (ai_living_count temple_ent_ghosts)))
	
	(sleep_until (= (volume_test_objects vol_tunnel_02 (players)) TRUE) 30 (random_range 30 90))
	(if (= (volume_test_objects vol_tunnel_02 (players)) FALSE)
		(ai_place tunnel_ghosts_01 (- 2 (ai_living_count temple_ent_ghosts)))
	)
		
	(sleep_until (= (volume_test_objects vol_tunnel_02 (players)) TRUE))
	(game_save)
	(if (< (ai_living_count tunnel_enemies_all) 6)
		(ai_place tunnel_jackals 2)
	)
	(if (< (ai_living_count tunnel_enemies_all) 6)
		(ai_place tunnel_heavies_02 2)
	)
	(cs_run_command_script tunnel_heavies_02/2 tunnel_turret_2)
	(cs_run_command_script tunnel_heavies_02/3 tunnel_turret_3)
	(ai_migrate temple_ent_ghosts tunnel_ghosts_02)
	(ai_migrate tunnel_ghosts_01 tunnel_ghosts_02)	
	(ai_place tunnel_ghosts_02 (- 2 (ai_living_count tunnel_ghosts)))

	(sleep_until (= (volume_test_objects vol_tunnel_03 (players)) TRUE) 30 (random_range 30 90))
	(if (= (volume_test_objects vol_tunnel_02 (players)) FALSE)
		(ai_place tunnel_ghosts_02 (- 2 (ai_living_count tunnel_ghosts)))
	)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_tunnel_03 (players)) TRUE)
			(AND
				(< (ai_living_count tunnel_ghosts) 1)
				(< (ai_living_count tunnel_infantry) 1)
			)
		)
	)
	;(wake temple_ent_arch)
	(game_save)

	(sleep_until 
		(OR
			(ai_scene old_temple_scene old_temple_structure_comment all_allies)
			(< (ai_living_count all_allies) 1)
		)
	30 150)
	
	(sleep 30)
	(if (= structure_comment_go FALSE)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Careful, we're coming-up on another structure!'")
			(sleep (ai_play_line_on_object NONE 2060))
			;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2060_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)


;-------------------------------------------------------------------------------
;Old Temple

;ice cream!!!
(script dormant arbiter_envy
	(sleep_until (= (volume_test_objects vol_arbiter_envy (players)) TRUE))
	(object_create envy)
	(ai_place envy_elites)
	(ai_set_active_camo envy_elites TRUE)
	(cs_run_command_script envy_elites forever_pause)
	(custom_animation_loop (unit (list_get (ai_actors envy_elites) 0)) objects\characters\elite\elite "combat:rifle:berserk" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors envy_elites) 1)) objects\characters\elite\elite "combat:rifle:berserk" TRUE)

	(sleep_until 
		(OR
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 0)
)

;To tell if the following command script succeeded
(global boolean old_temple_pel_comment_go FALSE)

;Ally pointing out the middle structure as the goal
(script command_script old_temple_pelican_comment
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Got a Pelican coming in!'")
	(cs_play_line 0620)
	(sleep 30)
	(print "ALLY: 'Let's clear an LZ!'")
	(cs_play_line 0630)
	(set old_temple_pel_comment_go TRUE)
)

(script dormant old_temple_pelican_timer
	(sleep 8000)
	(object_destroy (ai_vehicle_get_from_starting_location old_temple_pelican/pilot))
)

(global boolean old_temple_bombs_away FALSE)
;Brings in a pelican to help lead you to the center
(script command_script old_temple_pelican_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/pel0 20)
	(cs_fly_by old_temple_airspace/pel1 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by old_temple_airspace/pel2 20)
	(cs_fly_to old_temple_airspace/pel3 10)
	(cs_vehicle_speed .5)
	(cs_fly_to old_temple_airspace/pel4 5)
	(set old_temple_bombs_away TRUE)
	(cs_fly_to_and_face old_temple_airspace/pel4 old_temple_airspace/p0 1)

	(ai_place allies_old_temple_pelican (- 4 (ai_living_count all_allies)))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) "pelican_p" (ai_actors allies_old_temple_pelican))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) TRUE)

	(cs_fly_to old_temple_airspace/pel5 1)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) "pelican_p")

	;(sleep_until (< (ai_living_count old_temple_pelican) 4))
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_old_temple_center_01 (players)) TRUE)
			(= (volume_test_objects vol_old_temple_center_03 (players)) TRUE)
			(= (volume_test_objects vol_old_temple_center_05 (players)) TRUE)
		)
	)
	(sleep 90)	
	(wake old_temple_pelican_timer)
	(cs_vehicle_speed 1)
	(cs_fly_to old_temple_airspace/pel4 2)
	(cs_fly_by old_temple_airspace/pel3 5)
	(cs_fly_by old_temple_airspace/pel2 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/pel1 20)
	(cs_fly_by old_temple_airspace/pel0 20)
	(ai_erase old_temple_pelican)
)

;Loads and launches pelican
(script dormant old_temple_pelican
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 5)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 5) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 5))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 4)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 4) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 4))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 3)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 3) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 3))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 2) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 2))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 1) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 1))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 0) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 0))
	)
	(sleep 5)
	
	(sleep_until (< (ai_living_count old_temple_phantom) 1))
;	(ai_place allies_old_temple_pelican (- 4 (ai_living_count all_allies)))
	(ai_place old_temple_pelican)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location old_temple_pelican/pilot))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) "pelican_p" (ai_actors allies_old_temple_pelican))
;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) TRUE)

	(object_create_anew rack)
	(objects_attach (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) "pelican_sc_01" rack "pin")
	(object_create_anew bomb01)
	(objects_attach rack "rack01" bomb01 "pin")
	(object_create_anew bomb02)
	(objects_attach rack "rack02" bomb02 "pin")
	(object_create_anew bomb03)
	(objects_attach rack "rack03" bomb03 "pin")
	(object_create_anew bomb04)
	(objects_attach rack "rack04" bomb04 "pin")
	(object_create_anew bomb05)
	(objects_attach rack "rack05" bomb05 "pin")
	(object_create_anew bomb06)
	(objects_attach rack "rack06" bomb06 "pin")

	(cs_run_command_script old_temple_pelican/pilot old_temple_pelican_arrives)
	
	(sleep_until (= old_temple_bombs_away TRUE))
	
	(begin_random
		(begin
			(objects_detach rack bomb01)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb02)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb03)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb04)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb05)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb06)
			(sleep (random_range 10 30))
		)
	)
)
(script static void short_old_temple_pel
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 5)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 5) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 5))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 4)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 4) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 4))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 3)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 3) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 3))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 2) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 2))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 1) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 1))
	)
	(sleep 5)
	(if 
		(AND
			(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 50)
			(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 0) 45) FALSE)
		)
			(object_destroy (list_get (ai_actors all_allies) 0))
	)
	(sleep 5)

	(ai_place allies_old_temple_pelican 4)
	(ai_place old_temple_pelican)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location old_temple_pelican/pilot))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) "pelican_p" (ai_actors allies_old_temple_pelican))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) TRUE)

	(object_create_anew rack)
	(objects_attach (ai_vehicle_get_from_starting_location old_temple_pelican/pilot) "pelican_sc_01" rack "pin")
	(object_create_anew bomb01)
	(objects_attach rack "rack01" bomb01 "pin")
	(object_create_anew bomb02)
	(objects_attach rack "rack02" bomb02 "pin")
	(object_create_anew bomb03)
	(objects_attach rack "rack03" bomb03 "pin")
	(object_create_anew bomb04)
	(objects_attach rack "rack04" bomb04 "pin")
	(object_create_anew bomb05)
	(objects_attach rack "rack05" bomb05 "pin")
	(object_create_anew bomb06)
	(objects_attach rack "rack06" bomb06 "pin")

	(cs_run_command_script old_temple_pelican/pilot old_temple_pelican_arrives)
	
	(sleep_until (= old_temple_bombs_away TRUE))
	
	(begin_random
		(begin
			(objects_detach rack bomb01)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb02)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb03)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb04)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb05)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb06)
			(sleep (random_range 10 30))
		)
	)
)

;---

;Command scripts for the Phantoms
(script command_script old_temple_ph_01_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/ph0 20)
	(cs_fly_by old_temple_airspace/ph1 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by old_temple_airspace/ph2 20)
	(cs_fly_to old_temple_airspace/ph3a 3)
	(cs_vehicle_speed .5)
;	(cs_fly_to_and_face old_temple_airspace/ph3a old_temple_airspace/ph3b 1)
	(cs_fly_to old_temple_airspace/ph3a 1)
	(cs_fly_to old_temple_airspace/ph4a 1)
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) "phantom_lc")

	(sleep_until (< (ai_living_count old_temple_phantom) 2) 30 900)
;	(sleep 450)
;	(cs_fly_to old_temple_airspace/ph3a 1)
	(cs_fly_to_and_face old_temple_airspace/ph3a old_temple_airspace/ph2 1)
	(cs_vehicle_speed 1)
	(cs_fly_by old_temple_airspace/ph2 5)
	(cs_fly_by old_temple_airspace/ph1 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/ph0 20)
	(cs_fly_to old_temple_airspace/phx 20)
	(ai_erase old_temple_phantom)
)
(script command_script old_temple_ph_02_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/ph0 20)
	(cs_fly_by old_temple_airspace/ph1 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by old_temple_airspace/ph2 20)
	(cs_fly_to old_temple_airspace/ph3b 3)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face old_temple_airspace/ph3b old_temple_airspace/ph1 1)
	(cs_fly_to old_temple_airspace/ph4b 1)
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) "phantom_lc")

	(sleep_until (< (ai_living_count old_temple_phantom) 2) 30 900)
;	(sleep 450)
	(cs_fly_to old_temple_airspace/ph3b 1)
	(cs_vehicle_speed 1)
	(cs_fly_to_and_face old_temple_airspace/ph2 old_temple_airspace/ph1 1)
	(cs_fly_by old_temple_airspace/ph2 5)
	(cs_fly_by old_temple_airspace/ph1 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/ph0 20)
	(cs_fly_to old_temple_airspace/phx 20)
	(ai_erase old_temple_phantom)
)
(script command_script old_temple_ph_04_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/ph0 20)
	(cs_fly_by old_temple_airspace/ph1 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by old_temple_airspace/ph2 20)
	(cs_fly_to old_temple_airspace/ph3c 5)
;	(cs_fly_to old_temple_airspace/ph3c 1)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face old_temple_airspace/ph3c old_temple_airspace/p2 1)
	(cs_vehicle_speed 1)
	(cs_fly_to old_temple_airspace/ph4c 1)
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) TRUE)

	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_a01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_a02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_a03")
	(ai_set_orders old_temple_court_grunts_03 old_temple_courtyard_03)

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_b01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_b02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_b03")
	(ai_set_orders old_temple_court_jackals_03 old_temple_courtyard_03)

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_c01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_c02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_c03")
	(ai_set_orders old_temple_court_jackals_04 old_temple_courtyard_04)

	(sleep_until (< (ai_living_count old_temp_court_phantom) 2) 30 900)
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) FALSE)

;	(sleep 450)
	(cs_fly_to old_temple_airspace/ph3c 1)
	(cs_fly_by old_temple_airspace/ph2 5)
	(cs_fly_by old_temple_airspace/ph1 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/ph0 20)
	(cs_fly_to old_temple_airspace/phx 20)
	(ai_erase old_temple_phantom)
)
(script command_script old_temple_abort
	(cs_enable_pathfinding_failsafe TRUE)
	(if (= (volume_test_objects vol_old_temple_airspace_low (ai_actors old_temple_phantom)) TRUE)
		(begin
			(cs_enable_moving TRUE)
			(cs_enable_looking TRUE)
			(sleep_until (= (volume_test_objects vol_old_temple_airspace_high (ai_actors old_temple_phantom)) TRUE))
		)
	)
	(cs_vehicle_speed 1)
	(cs_fly_by old_temple_airspace/ph2 5)
	(cs_fly_by old_temple_airspace/ph1 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_by old_temple_airspace/ph0 20)
	(cs_fly_to old_temple_airspace/phx 20)
	(ai_erase old_temple_phantom)
)

;Scripts controlling phantoms
(script static void old_temple_phantom_01
	(sleep_until (< (ai_living_count old_temple_pelican) 1))
	(ai_place old_temple_phantom)
	(ai_place old_temple_ghosts_air)	
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location old_temple_ghosts_air/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location old_temple_ghosts_air/2))
	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) TRUE)

	(cs_run_command_script old_temple_phantom/pilot old_temple_ph_01_arrives)
	(sleep_until 
		(OR
			(< (ai_living_count old_temple_phantom) 1)
			(< (ai_living_count old_temple_ghosts_air) 1)
		)
	)
	(if (< (ai_living_count old_temple_ghosts_air) 1)
		(cs_run_command_script old_temple_phantom old_temple_abort)
	)
	(sleep_until (< (ai_living_count old_temple_phantom) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location old_temple_phantom/pilot))
)
(script static void old_temple_phantom_02
	(sleep_until (< (ai_living_count old_temple_pelican) 1))
	(ai_place old_temple_phantom)
	(ai_place old_temple_ghosts_air)	
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location old_temple_ghosts_air/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location old_temple_ghosts_air/2))
	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location old_temple_phantom/pilot) TRUE)

	(cs_run_command_script old_temple_phantom/pilot old_temple_ph_02_arrives)
	(sleep_until 
		(OR
			(< (ai_living_count old_temple_phantom) 1)
			(< (ai_living_count old_temple_ghosts_air) 1)
		)
	)
	(if (< (ai_living_count old_temple_ghosts_air) 1)
		(cs_run_command_script old_temple_phantom old_temple_abort)
	)
	(sleep_until (< (ai_living_count old_temple_phantom) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location old_temple_phantom/pilot))
)
(script dormant old_temple_phantom_04
	(sleep_until (< (ai_living_count old_temple_pelican) 1))
	(ai_place old_temple_court_jackals_03 2)
	(ai_place old_temple_court_grunts_03 3)
	(ai_place old_temple_court_jackals_04 3)
	(ai_place old_temp_court_phantom)
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_c" (ai_actors old_temple_court_jackals_04))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_a" (ai_actors old_temple_court_grunts_03))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_b" (ai_actors old_temple_court_jackals_03))
	(sleep 60)
	(cs_run_command_script old_temp_court_phantom/pilot old_temple_ph_04_arrives)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) TRUE)
	(sleep_until (< (ai_living_count old_temp_court_phantom) 1) 30 8000)
	(object_destroy (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot))
)
(script static void short_old_temple_phantom
	(ai_allegiance covenant prophet)
	(ai_place old_temple_court_jackals_03 2)
	(ai_place old_temple_court_grunts_03 3)
	(ai_place old_temple_court_jackals_04 3)
	(ai_place old_temp_court_phantom)
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_c" (ai_actors old_temple_court_jackals_04))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_a" (ai_actors old_temple_court_grunts_03))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) "phantom_p_b" (ai_actors old_temple_court_jackals_03))
	(sleep 60)
	(cs_run_command_script old_temp_court_phantom/pilot old_temple_ph_04_arrives)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location old_temp_court_phantom/pilot) TRUE)
;	(sleep_until (< (ai_living_count old_temple_phantom) 1))
)

;Tracks total number of vehicle waves to spawn
(global short old_temple_veh_total 2)
(global boolean old_temple_ghosts_over FALSE)

;Spawns phantoms to bring in ghosts
(script dormant old_temple_vehicle_spawn
	(ai_place old_temple_ghosts_far)
	(if (difficulty_heroic)
		(set old_temple_veh_total 3)
	)
	(if (difficulty_legendary)
		(set old_temple_veh_total 4)
	)
	(sleep_until (> (ai_living_count old_temple_ghosts_far) 0) 30 600)
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(< (ai_living_count old_temple_vehicles) 1)
					(= (volume_test_objects vol_old_temple_debris (players)) TRUE)
				)
			)
			(game_save)
			(if (= (volume_test_objects vol_old_temple_debris (players)) TRUE)
				(sleep_forever)
			)
			(if (= (volume_test_objects vol_old_temple_debris (players)) FALSE)
				(ai_place old_temple_ghosts_far 1)
			)
			(sleep_until (= (volume_test_objects vol_old_temple_debris (players)) TRUE) 30 (random_range 30 120))
			(if (= (volume_test_objects vol_old_temple_debris (players)) TRUE)
				(sleep_forever)
			)
			(if (= (volume_test_objects vol_old_temple_debris (players)) FALSE)
				(ai_place old_temple_ghosts_far 1)
			)	
			(set old_temple_veh_total (- old_temple_veh_total 1))
			(OR
				(AND 
					(difficulty_normal)
					(< old_temple_veh_total 2)
				)
				(AND 
					(difficulty_heroic)
					(< old_temple_veh_total 2)
				)
				(AND 
					(difficulty_legendary)
					(< old_temple_veh_total 3)
				)
				(= (volume_test_objects vol_old_temple_debris (players)) TRUE)
			)
		)
	)

	(sleep_until
		(begin
			(sleep_until 
				(OR
					(< (ai_living_count old_temple_vehicles) 1)
					(= (volume_test_objects vol_old_temple_debris (players)) TRUE)
				)
			)
			(game_save)
			(if (= (volume_test_objects vol_old_temple_debris (players)) TRUE)
				(sleep_forever)
			)
			(if (= (volume_test_objects vol_old_temple_debris (players)) FALSE)
				(begin
					(ai_place old_temple_ghosts_far 1)
					(ai_set_orders old_temple_ghosts_far old_temple_vehicles_ltd)
				)
			)
			(sleep_until (= (volume_test_objects vol_old_temple_debris (players)) TRUE) 30 (random_range 30 120))
			(if (= (volume_test_objects vol_old_temple_debris (players)) TRUE)
				(sleep_forever)
			)
			(if (= (volume_test_objects vol_old_temple_debris (players)) FALSE)
				(begin
					(ai_place old_temple_ghosts_far 1)
					(ai_set_orders old_temple_ghosts_far old_temple_vehicles_ltd)
				)
			)	
			(set old_temple_veh_total (- old_temple_veh_total 1))
			(OR
				(<= old_temple_veh_total 0)
				(= (volume_test_objects vol_old_temple_debris (players)) TRUE)
			)
		)
	)
	
	(sleep_until (< (ai_living_count old_temple_vehicles) 1))
	(set old_temple_ghosts_over TRUE)
)

;---

;Script for spawning guys while circling in vehicle
(script dormant old_temple_near_right
	(sleep_until 
		(AND
			(= (volume_test_objects vol_old_temple_near_right (players)) TRUE)
			(= (volume_test_objects vol_old_temple_int_01 (players)) FALSE)
			(= (volume_test_objects vol_old_temple_int_02 (players)) FALSE)
			(> (player_count) 0)
		)
	)

	(game_save)

;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_elites_near_right 1)
	)
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_jackals_near_right (- 2 (ai_living_count old_temple_peri_jackals)))
	)
)
(script dormant old_temple_far_left
	(sleep_until 
		(AND
			(= (volume_test_objects vol_old_temple_far_left (players)) TRUE)
			(= (volume_test_objects vol_old_temple_int_01 (players)) FALSE)
			(= (volume_test_objects vol_old_temple_int_02 (players)) FALSE)
			(> (player_count) 0)
		)
	)
	(game_save)

;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_grunts_far_left (- 3 (ai_living_count old_temple_peri_grunts)))
	)
)
(script dormant old_temple_far_right
	(sleep_until 
		(AND
			(= (volume_test_objects vol_old_temple_far_right (players)) TRUE)
			(= (volume_test_objects vol_old_temple_int_01 (players)) FALSE)
			(= (volume_test_objects vol_old_temple_int_02 (players)) FALSE)
			(> (player_count) 0)
		)
	)
	(game_save)

;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_grunts_far_right (- 3 (ai_living_count old_temple_peri_grunts)))
	)
)
(script dormant old_temple_below
	(sleep_until 
		(AND
			(= (volume_test_objects vol_old_temple_below (players)) TRUE)
			(= (volume_test_objects vol_old_temple_int_01 (players)) FALSE)
			(= (volume_test_objects vol_old_temple_int_02 (players)) FALSE)
			(> (player_count) 0)
		)
	)
	(game_save)

;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_jackals_below_far (- (random_range 2 5) (ai_living_count old_temple_peri_jackals)))
	)
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_jackals_below_near (- (random_range 2 5) (ai_living_count old_temple_peri_jackals)))
	)
)

;Respawns grunts for turrets if the turret is still intact
(script command_script old_temp_reman_fr
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_go_to old_temple/far_R)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location old_temple_turrets/far_R))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(sleep_forever)
)
(script command_script old_temp_reman_fl
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_go_to old_temple/far_L)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location old_temple_turrets/far_L))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(sleep_forever)
)
(script command_script old_temp_reman_nl
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_go_to old_temple/near_L)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location old_temple_turrets/near_L))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(sleep_forever)
)
(script command_script old_temp_reman_cen
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_go_to old_temple/center)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location old_temple_turrets/center))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(sleep_forever)
)
(script dormant old_temple_turret_reman
	(sleep_until
		(begin
			(if 
				(AND
					(> (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/far_R)) 0)
					(= (volume_test_objects vol_old_temple_farwall_all (players)) FALSE)
					(> (player_count) 0)
					(< (ai_spawn_count old_temple_grunts_far_right) 5)
					(< (ai_living_count old_temple_grunts_far_right) 1)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location old_temple_turrets/far_R) "" (ai_actors old_temple_turrets)) FALSE)
					(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location old_temple_turrets/far_R)) 20)
				)
					(begin
						(ai_place old_temple_grunts_far_right/1)
						(cs_run_command_script old_temple_grunts_far_right/1 old_temp_reman_fr)
					)		
			)
			(if 
				(AND
					(> (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/far_L)) 0)
					(= (volume_test_objects vol_old_temple_seawall_all (players)) FALSE)
					(> (player_count) 0)
					(< (ai_spawn_count old_temple_grunts_far_left) 5)
					(< (ai_living_count old_temple_grunts_far_left) 1)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location old_temple_turrets/far_L) "" (ai_actors old_temple_turrets)) FALSE)
					(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location old_temple_turrets/far_L)) 20)
				)
					(begin
						(ai_place old_temple_grunts_far_left/1)
						(cs_run_command_script old_temple_grunts_far_left/1 old_temp_reman_fl)
					)		
			)
			(if 
				(AND
					(> (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/near_L)) 0)
					(= (volume_test_objects vol_old_temple_seawall_all (players)) FALSE)
					(> (player_count) 0)
					(< (ai_spawn_count old_temple_grunts_near_left) 5)
					(< (ai_living_count old_temple_grunts_near_left) 1)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location old_temple_turrets/near_L) "" (ai_actors old_temple_turrets)) FALSE)
					(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location old_temple_turrets/near_L)) 20)
				)
					(begin
						(ai_place old_temple_grunts_near_left/1)
						(cs_run_command_script old_temple_grunts_near_left/1 old_temp_reman_nl)
					)		
			)
			(if 
				(AND
					(> (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/center)) 0)
					(= (volume_test_objects vol_old_temple_see_nook (players)) FALSE)
					(> (player_count) 0)
					(< (ai_spawn_count old_temple_grunts_center) 5)
					(< (ai_living_count old_temple_grunts_center) 1)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location old_temple_turrets/center) "" (ai_actors old_temple_turrets)) FALSE)
					(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location old_temple_turrets/center)) 20)
				)
						(begin
							(ai_place old_temple_grunts_center/1)
							(cs_run_command_script old_temple_grunts_center/1 old_temp_reman_cen)
						)		
			)
			(OR
				(= (volume_test_objects vol_old_temple_center_01 (player0)) TRUE)
				(= (volume_test_objects vol_old_temple_center_03 (player0)) TRUE)
				(= (volume_test_objects vol_old_temple_center_05 (player0)) TRUE)
				(AND
					(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/far_R)) 0)
					(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/far_L)) 0)
					(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/near_L)) 0)
					(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/center)) 0)
				)
			)
		)
	)
)

;---

;Deleting guys in perimeter once you reach the center and leave your vehicle
(script dormant old_temple_perimeter_nuke
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors old_temple_peri_grunts) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors old_temple_peri_grunts) 0)) 10)
				)
					(object_destroy (list_get (ai_actors old_temple_peri_grunts) 0))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors old_temple_peri_jackals) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors old_temple_peri_jackals) 0)) 10)
				)
					(object_destroy (list_get (ai_actors old_temple_peri_jackals) 0))
			)
			(sleep 5)
			(AND
				(< (ai_living_count old_temple_peri_grunts) 1)
				(< (ai_living_count old_temple_peri_jackals) 1)
			)
		)
	)
	(print "all gone")
)
(script static void nuke
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors old_temple_peri_grunts) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors old_temple_peri_grunts) 0)) 10)
				)
					(object_destroy (list_get (ai_actors old_temple_peri_grunts) 0))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors old_temple_peri_jackals) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors old_temple_peri_jackals) 0)) 10)
				)
					(object_destroy (list_get (ai_actors old_temple_peri_jackals) 0))
			)
			(sleep 5)
			(AND
				(< (ai_living_count old_temple_peri_grunts) 1)
				(< (ai_living_count old_temple_peri_jackals) 1)
			)
		)
	)
	(print "all gone")
)

(global boolean old_temple_chatter FALSE)

;Ally pointing out the middle structure as the goal
(global boolean old_temp_middle_go FALSE)
(script command_script old_temple_middle_comment
	(set old_temp_middle_go TRUE)
	(cs_switch ally)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'They're all pouring-out of the middle! Let's get in there!'")
	(cs_play_line 0610)
)
(script dormant old_temple_middle_ally
	(sleep_until 
		(OR
			(< (ai_living_count all_allies) 1)
			(ai_scene old_temple_mid_scene old_temple_middle_comment all_allies)
		)
	30 300)
	
	(sleep 30)
	(if 
		(AND 
			(= old_temp_middle_go FALSE)
			(= old_temple_chatter FALSE)
		)
			(begin
				(set old_temple_chatter TRUE)
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'They're all pouring-out of the middle! Let's get in there!'")
				(sleep (ai_play_line_on_object NONE 2070))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2070_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
				(set old_temple_chatter FALSE)
			)
	)
)

;Script for spawning guys in center area when approaching on foot
(script dormant old_temple_center
	(sleep_until 
		(OR
			(AND
				(= (unit_in_vehicle (player0)) FALSE)
				(OR
					(= (volume_test_objects vol_old_temple_center_01 (player0)) TRUE)
					(= (volume_test_objects vol_old_temple_center_03 (player0)) TRUE)
					(= (volume_test_objects vol_old_temple_center_05 (player0)) TRUE)
				)
			)
			(AND
				(= (unit_in_vehicle (player1)) FALSE)
				(OR
					(= (volume_test_objects vol_old_temple_center_01 (player1)) TRUE)
					(= (volume_test_objects vol_old_temple_center_03 (player1)) TRUE)
					(= (volume_test_objects vol_old_temple_center_05 (player1)) TRUE)
				)
			)
		)
	)
	(ai_disposable old_temple_peri_grunts TRUE)
	(ai_disposable old_temple_peri_jackals TRUE)

	(game_save)
	
	(sleep_forever old_temple_near_right)
	(sleep_forever old_temple_far_left)
	(sleep_forever old_temple_far_right)
	(sleep_forever old_temple_vehicle_spawn)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_tank/driver) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location lz_warthog_01/driver) TRUE)
	(cs_run_command_script old_temple_phantom old_temple_abort)
	(wake old_temple_perimeter_nuke)
	
;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_center_elites_01 (- 2 (ai_living_count old_temp_center_tough)))
	)
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_center_grunts_01 (- 3 (ai_living_count old_temp_center_fodder)))
	)
	(wake old_temple_middle_ally)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_old_temple_center_03 (players)) TRUE)
			(= (volume_test_objects vol_old_temple_center_05 (players)) TRUE)
			(< (ai_living_count old_temple_center_all) 3)
		)
	)

	(game_save)

;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_center_grunts_03 (- 3 (ai_living_count old_temp_center_fodder)))
	)
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_center_jackals_04 (- 2 (ai_living_count old_temp_center_tough)))
	)
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_center_grunts_04 (- 6 (ai_living_count old_temp_center_fodder)))
	)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_old_temple_center_05 (players)) TRUE)
			(< (ai_living_count old_temple_center_all) 3)
		)
	)

	(game_save)

;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_center_elites_05 (- 2 (ai_living_count old_temp_center_tough)))
	)
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_center_jackals_05 (- 4 (ai_living_count old_temp_center_tough)))
	)
	
	(sleep_until
		(begin
			(if 
				(AND
					(< (ai_living_count old_temple_center_all) 2)
					(= (volume_test_objects vol_old_temple_court_01 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place old_temple_courtyard_lure 1)
			)
			(sleep_until 
				(OR
					(= (volume_test_objects vol_old_temple_close_nuff (players)) TRUE)
					(< (ai_living_count old_temple_center_all) 2)
					(> (ai_spawn_count old_temple_courtyard_lure) 3)
				)
			30 210)
			(OR
				(= (volume_test_objects vol_old_temple_close_nuff (players)) TRUE)
				(> (ai_spawn_count old_temple_courtyard_lure) 3)
			)
		)
	)
	
;9/11	
	(game_save)
	
	(sleep_until (< (ai_living_count old_temple_center_all) 1) 30 3600)
	(sleep_until (= (ai_trigger_test "done_fighting" old_temple_center_all) TRUE) 30 3600)
	(game_save)
)

;Makes marines fight guys from center until you arrive
(script dormant old_temple_playfight
;9/11
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_playfight_e 2)
	)
	(if (< (ai_living_count old_temple_enemies) 8)
		(ai_place old_temple_playfight_g 3)
	)
	(sleep_until
		(begin
			(if (< (ai_living_count old_temple_playfight_g) 3)
				(ai_place old_temple_playfight_g 1)
			)
			(OR
				(= (volume_test_objects vol_old_temple_center_01 (players)) TRUE)
				(= (volume_test_objects vol_old_temple_center_03 (players)) TRUE)
			)
		)
	)
	(ai_set_orders allies_old_temple_pelican old_temple_center_allies_01)
)

;---

;Pointing out the debris
(script dormant old_temple_debris_comment
	(sleep_until 
		(AND
			(= (volume_test_objects vol_old_temple_debris (players)) TRUE)
			(= old_temple_chatter FALSE)
		)
	)
	(set old_temple_chatter TRUE)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'Looks like a landslide has blocked the main passage.'")
	(print "'We'll have to find an alternate route.'")
	(sleep (ai_play_line_on_object NONE 0670))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0670_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(set old_temple_chatter FALSE)
)
	
;Reminder to enter the middle
(script dormant old_temple_middle_reminder
	(sleep_until (= (volume_test_objects vol_old_temple_in_court (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_old_temple_in_court (players)) FALSE)
			(> (player_count) 0)
			(= old_temple_chatter FALSE)
		)
			(begin
				(set old_temple_chatter TRUE)
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'The Covenant holed-up in the middle of this structure.'")
				(print "'We need to clear them out.'")
				(sleep (ai_play_line_on_object NONE 0650))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0650_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
				(set old_temple_chatter FALSE)
			)
	)

	(sleep_until (= (volume_test_objects vol_old_temple_in_court (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_old_temple_in_court (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(activate_team_nav_point_flag default player old_temple_exit 0)
				(sleep_until (= (volume_test_objects vol_old_temple_in_court (players)) TRUE))
				(deactivate_team_nav_point_flag player old_temple_exit)
			)
	)
)

;Overall script for old temple
(script dormant old_temple_start
	(sleep_until (= (volume_test_objects vol_old_temple_start (players)) TRUE)) 
	(ai_disposable tunnel_enemies_all TRUE)
	(data_mine_set_mission_segment "05a_7_old_temple")
	(wake music_05a_04_stop)
	(game_save)

	(ai_place old_temple_init_jackals_nl 2)
	(sleep 2)
	(ai_place old_temple_turrets/center)
	(cs_run_command_script old_temple_turrets stay_shooting)
	(sleep 2)
	(ai_place old_temple_turrets/near_l)
	(cs_run_command_script old_temple_turrets stay_shooting)
	(sleep 2)
	(ai_place old_temple_turrets/far_l)
	(cs_run_command_script old_temple_turrets stay_shooting)
	(sleep 2)
	(ai_place old_temple_turrets/far_r)
	(cs_run_command_script old_temple_turrets stay_shooting)

;9/11
	;(ai_place old_temple_grunts_near_left 2)

	(wake old_temple_near_right)
	(wake old_temple_far_left)
	(wake old_temple_far_right)
	(wake old_temple_below)
	(wake old_temple_center)
	(wake old_temple_vehicle_spawn)
;	(wake old_temple_debris_comment)
	(wake old_temple_middle_reminder)
	(wake old_temple_turret_reman)

;9/11
	(if (difficulty_legendary)
		(wake arbiter_envy)
	)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_old_temple_center_01 (players)) TRUE)
			(= (volume_test_objects vol_old_temple_center_03 (players)) TRUE)
			(AND
				(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/far_R)) 0)
				(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/far_L)) 0)
				(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/near_L)) 0)
				(<= (object_get_health (ai_vehicle_get_from_starting_location old_temple_turrets/center)) 0)
				(= old_temple_ghosts_over TRUE)
			)
		)
	)
	(game_save)
	(wake old_temple_pelican)
	(wake old_temple_playfight)

	(sleep_until 
		(OR
			(ai_scene old_temple_pel_scene old_temple_pelican_comment all_allies)
			(< (ai_living_count all_allies) 1)
		)
	30 60)
	(sleep 300)
	(if 
		(AND
			(= old_temple_pel_comment_go FALSE)
			(= old_temple_chatter FALSE)
		)
			(begin
				(set old_temple_chatter TRUE)
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Pelican inbound!'")
				(sleep (ai_play_line_on_object NONE 2080))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2080_cor))
				(sleep 15)
				(print "CORTANA: 'Let's clear a landing-zone!'")
				(sleep (ai_play_line_on_object NONE 2090))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_2090_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
				(set old_temple_chatter FALSE)
			)
	)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_old_temple_center_01 (players)) TRUE)
			(= (volume_test_objects vol_old_temple_center_03 (players)) TRUE)
			(= (volume_test_objects vol_old_temple_in_court (players)) TRUE)
		)
	30 300)
	(if 
		(AND
			(= (volume_test_objects vol_old_temple_center_01 (players)) FALSE)
			(= (volume_test_objects vol_old_temple_center_03 (players)) FALSE)
			(= (volume_test_objects vol_old_temple_in_court (players)) FALSE)
			(> (player_count) 0)
			(= old_temple_bombs_away FALSE)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "JOHNSON: 'Clear out the riff-raff so I can set her down!'")
				(sleep (ai_play_line_on_object NONE 0640))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0640_jon))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)

;9/11	
	(game_save)
	
	(sleep_until (< (ai_living_count old_temple_enemies) 1) 30 3600)
	(sleep_until (= (ai_trigger_test "done_fighting" old_temple_enemies) TRUE) 30 3600)
	(game_save)
)


;-------------------------------------------------------------------------------
;Temple Courtyard

;Reminder to pass through the debris
(script dormant old_temple_debris_reminder
	(sleep_until (= (volume_test_objects vol_through_debris (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_through_debris (players)) FALSE)
			(> (player_count) 0)
			(= old_temple_chatter FALSE)	
		)
			(begin
				(set old_temple_chatter TRUE)
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'There should be a way through this debris…'")
				(sleep (ai_play_line_on_object NONE 0680))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0680_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
				(set old_temple_chatter FALSE)
			)
	)

	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE) 30 4000)
	(if 
		(AND
			(= (volume_test_objects vol_grotto (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(activate_team_nav_point_flag default player courtyard_exit 0)
				(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
				(deactivate_team_nav_point_flag player courtyard_exit)
			)
	)
)

;Cortana translates Regret's speech if you linger long enough
(global boolean court_holo_chant TRUE)
(global boolean court_holo_trans FALSE)

(script dormant old_temple_holo_translate
	(sleep_until (< (ai_living_count old_temple_court_all) 1))
	(sleep 300)
	(set court_holo_trans TRUE)
	(sleep_until
		(AND
			(= (volume_test_objects vol_old_temple_court_04 (players)) TRUE)
			(= (objects_can_see_object (players) regret02 30) TRUE)
			(= court_holo_chant FALSE)
		)
	)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(custom_animation regret02 objects\characters\prophet\prophet "regret_l05_0110_por" TRUE)
	(print "'In a gesture of peace and reconciliation, the Prophets promised to find the means...'")
	(print "'...of the Forerunners' transcendence, and to share this knowledge with the Elites.'")
	(sleep (ai_play_line_on_object regret02 0110))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0110_por))
	(sleep 30)
	(custom_animation regret02 objects\characters\prophet\prophet "regret_l05_0120_por" TRUE)
	(print "'The Elites promised to defend the Prophets as they searched - '")
	(print "'a simple arrangement that has become our binding Covenant!'")
	(sleep (ai_play_line_on_object regret02 0120))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0120_por))
	(sleep 60)
	(if (= old_temple_chatter FALSE)
		(begin
			(set old_temple_chatter TRUE)
			(print "CORTANA: 'Transcendence, huh? More like mass-suicide.'")
			(sleep (ai_play_line_on_object NONE 0660))
			(set old_temple_chatter FALSE)
		)
	)
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0660_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 240 480))
	(set court_holo_trans FALSE)
)

(script dormant courtyard_holo_looper
	(object_create regret02)
	(objects_attach court_throne_attach "" court_throne "driver")
	(objects_attach court_throne "driver" regret02 "")
	(ai_disregard regret02 TRUE)
	
	(sleep_until
		(begin
			(begin_random
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant1a" TRUE)
						(sleep (ai_play_line_on_object regret02 3000))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant2b" TRUE)
						(sleep (ai_play_line_on_object regret02 3001))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant2c" TRUE)
						(sleep (ai_play_line_on_object regret02 3002))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant3a" TRUE)
						(sleep (ai_play_line_on_object regret02 3003))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant3c" TRUE)
						(sleep (ai_play_line_on_object regret02 3004))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant5a" TRUE)
						(sleep (ai_play_line_on_object regret02 3005))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant6a" TRUE)
						(sleep (ai_play_line_on_object regret02 3006))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
			)
			FALSE
		)
	)
)
(script static void court_holo_looper
	(object_create regret02)
	(objects_attach court_throne_attach "" court_throne "driver")
	(objects_attach court_throne "driver" regret02 "")
	(ai_disregard regret02 TRUE)
	
	(sleep_until
		(begin
			(begin_random
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant1a" TRUE)
						(sleep (ai_play_line_on_object regret02 3000))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant2b" TRUE)
						(sleep (ai_play_line_on_object regret02 3001))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant2c" TRUE)
						(sleep (ai_play_line_on_object regret02 3002))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant3a" TRUE)
						(sleep (ai_play_line_on_object regret02 3003))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant3c" TRUE)
						(sleep (ai_play_line_on_object regret02 3004))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant5a" TRUE)
						(sleep (ai_play_line_on_object regret02 3005))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
				(if (= court_holo_trans FALSE)
					(begin
						(set court_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant6a" TRUE)
						(sleep (ai_play_line_on_object regret02 3006))
						(sleep (random_range 240 480))
						(set court_holo_chant FALSE)
					)
				)
			)
			FALSE
		)
	)
)

;Cortana the archaeologist
(script dormant old_temple_archaeologist
	(sleep_until (= (ai_trigger_test "done_fighting" all_enemies) TRUE))
	(sleep_until 
		(OR 
			(= (ai_trigger_test "done_fighting" all_enemies) TRUE)
			(= (volume_test_objects vol_through_debris (players)) TRUE)
		)
	)
	(sleep_until (= (volume_test_objects vol_through_debris (players)) TRUE) 30 300)
	(if 
		(AND
			(= (volume_test_objects vol_through_debris (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'What happened to this place? The stones…'")
				(print "'this isn't normal wear and tear. It almost looks like battle-scarring…'")
				(sleep (ai_play_line_on_object NONE 0590))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0590_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Script for spawning in the courtyard
(script dormant old_temple_courtyard
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_old_temple_court_01 (players)) TRUE)
			(= (volume_test_objects vol_old_temple_in_court (players)) TRUE)
		)
	)
	(ai_disposable old_temple_center_all TRUE)
	(data_mine_set_mission_segment "05a_8_old_temple_courtyard")
	(wake courtyard_holo_looper)
	(game_save)

;9/12

	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_elites_01 2)
	)
	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_grunts_01 3)
	)
	;(wake old_temple_phantom_04)

	(sleep_until 
		(OR 
			(< (ai_living_count old_temple_court_all) 3)
			(= (volume_test_objects vol_old_temple_court_02 (players)) TRUE)
		)
	)

	(game_save)

	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_grunts_02 (- 4 (ai_living_count old_temple_court_grunts_01)))
	)
	
	(sleep_until 
		(OR 
			(< (ai_living_count old_temple_court_all) 3)
			(= (volume_test_objects vol_old_temple_court_04 (players)) TRUE)
		)
	)

	(game_save)
	(wake old_temple_holo_translate)
	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_jackals_03 (- 2 (ai_living_count old_temple_court_elites_01)))
	)
	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_grunts_03 (- 3 (+ (ai_living_count old_temple_court_grunts_01) (ai_living_count old_temple_court_grunts_02))))
	)
	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_jackals_04 2)
	)

	(sleep_until 
		(OR 
			(< (ai_living_count old_temple_court_all) 3)
			(= (volume_test_objects vol_old_temple_court_05 (players)) TRUE)
		)
	)

	(game_save)

	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_elites_05 2)
	)
	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_jackals_05 2)
	)
	(wake old_temple_debris_reminder)

	(sleep_until 
		;(OR 
		;	(< (ai_living_count old_temple_court_all) 3)
			(= (volume_test_objects vol_old_temple_court_06 (players)) TRUE)
		;)
	)

;	(wake old_temple_archaeologist)
	(game_save)

	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_jackals_06 2)
	)
	(if (< (ai_living_count old_temple_court_all) 8)
		(ai_place old_temple_court_grunts_06 3)
	)
	
	(sleep_until (< (ai_living_count old_temple_court_all) 1) 30 4000)

;9/11	
	(sleep_until (= (ai_trigger_test "done_fighting" old_temple_court_all) TRUE) 30 3600)
	(game_save)
	
;*	(if 
		(AND
			(= (volume_test_objects vol_grotto (players)) FALSE)
			(> (player_count) 0)
		)
			(ai_place courtyard_grunts_end 2)
	)
	(sleep 210)
	(if 
		(AND
			(= (volume_test_objects vol_grotto (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count courtyard_grunts_end) 1)
		)	
			(ai_place courtyard_grunts_end (random_range 1 3))
	)
	(if (= (volume_test_objects vol_grotto (players)) TRUE)
		(sleep_forever)
	)
	(sleep_until 
		(begin
			(if 
				(AND
					(= (volume_test_objects vol_grotto (players)) FALSE)
					(> (player_count) 0)
					(< (ai_living_count courtyard_grunts_end) 1)
				)	
					(ai_place courtyard_grunts_end 1)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_grotto (players)) TRUE) 
					(< (ai_living_count courtyard_grunts_end) 1)
					(> (ai_spawn_count courtyard_grunts_end) 5)
				)
			30 210)	
			(OR
				(= (volume_test_objects vol_grotto (players)) TRUE)
				(> (ai_spawn_count courtyard_grunts_end) 5)
			)
		)
	)
*;
)


;-------------------------------------------------------------------------------
;Grotto

;*Cortana phantom warning
(script dormant grotto_cortana_warn
	(print "CORTANA: 'Phantom! Stay out of sight!'")
	(sleep (ai_play_line_on_object NONE 0730))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0730_cor))
)

;Ally phantom warning
(script command_script grotto_ally_warn
	(cs_switch ally)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ODST: 'Get down! Phantom!'")
	(cs_play_line 0740)
)

;Phantom flies in with reinforcements
(script command_script grotto_phantom_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by grotto_airspace/p0 20)
	(cs_fly_by grotto_airspace/ph0 20)
	(cs_vehicle_boost FALSE)
	(wake grotto_cortana_warn)
	(cs_fly_to grotto_airspace/ph1 5)
	(cs_vehicle_speed .5)
	(cs_fly_to grotto_airspace/ph1 1)
	(ai_scene grotto_ally_warn_scene grotto_ally_warn all_allies)
	(cs_fly_to grotto_airspace/ph2 1)
	
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_a01")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_a02")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_a03")

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b01")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b02")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b03")

;	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_c01")
;	(sleep 15)
;	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_c02")
;	(sleep 15)
;	(vehicle_unload (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_c03")

	(sleep_until (< (ai_living_count old_temple_phantom) 2) 30 900)
;	(sleep 450)

	(cs_fly_to_and_face grotto_airspace/ph1 grotto_airspace/ph0 3)
	(cs_fly_by grotto_airspace/ph0 5)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_to grotto_airspace/p0 20)
	(cs_fly_to grotto_airspace/phx 20)
	(ai_erase grotto_phantom)
)

;Loads up phantom and starts its run
(script dormant grotto_phantom_start
	(ai_place grotto_phantom)
	(ai_place grotto_phantom_jackals_01)
	(ai_place grotto_phantom_jackals_02)
	(ai_place grotto_phantom_jackals_03)
	(ai_place grotto_phantom_elites)

	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_a" (ai_actors grotto_phantom_elites))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b01" (ai_actors grotto_phantom_jackals_01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b02" (ai_actors grotto_phantom_jackals_02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b03" (ai_actors grotto_phantom_jackals_03))

	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) TRUE)
	(cs_run_command_script grotto_phantom/pilot grotto_phantom_arrives)
)
(script static void short_grotto_phantom
	(ai_allegiance covenant prophet)
	(ai_place grotto_phantom)
	(ai_place grotto_phantom_jackals_01)
	(ai_place grotto_phantom_jackals_02)
	(ai_place grotto_phantom_jackals_03)
	(ai_place grotto_phantom_elites)

	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_a" (ai_actors grotto_phantom_elites))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b01" (ai_actors grotto_phantom_jackals_01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b02" (ai_actors grotto_phantom_jackals_02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location grotto_phantom/pilot) "phantom_p_b03" (ai_actors grotto_phantom_jackals_03))

	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_phantom_01/pilot) TRUE)
	(cs_run_command_script grotto_phantom/pilot grotto_phantom_arrives)
)
*;

;---

;Cortana comments on grotto
(script dormant grotto_cortana_comment
	(sleep_until 
		(AND
			(= (volume_test_objects vol_grotto_follow_01 (players)) TRUE)
			(= (objects_can_see_flag (players) grotto_center 30) TRUE)
		)
	)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'You always bring me to such nice places.'")
	(sleep (ai_play_line_on_object NONE 0690))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0690_cor))
	(sleep 30)
	(wake music_05a_05_start)
	(ai_dialogue_enable TRUE)
	(sleep_until (game_safe_to_save))
	(game_save)
)

;Cheesy marine exchange at grotto
(script command_script grotto_ally_cheese
	(cs_switch ally01)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ODST: 'My girl would dig this place. So beautiful…'")
	(cs_play_line 0700)
	(sleep 30)

	(cs_switch ally02)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ODST: 'Beautiful and dangerous, man.'")
	(cs_play_line 0710)
	(sleep 30)

	(cs_switch ally01)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ODST: 'Hey. That's why I love her.'")
	(cs_play_line 0720)
)
(script dormant grotto_ally_comments
	(sleep_until 
		(ai_scene grotto_ally_cheese_scene grotto_ally_cheese all_allies)
	30 450)
)

;Reminder to press on
(script dormant grotto_reminder
	(sleep_until (= (volume_test_objects vol_grotto_exit (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_grotto_exit (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'We're approaching another structure. It should be the...'") 
				(print "'...lake access-point we've been looking for…'")
				(sleep (ai_play_line_on_object NONE 0750))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0750_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)

	(sleep_until (= (volume_test_objects vol_grotto_exit (players)) TRUE) 30 4000)
	(if 
		(AND
			(= (volume_test_objects vol_grotto_exit (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(activate_team_nav_point_flag default player grotto_exit 0)
				(sleep_until (= (volume_test_objects vol_grotto_exit (players)) TRUE))
				(deactivate_team_nav_point_flag player grotto_exit)
			)
	)
)

;---

(script dormant grotto_pool
	(sleep_until 
		(OR
			(< (ai_living_count grotto_init_01) 1)
			(= (volume_test_objects vol_grotto_first_pool_01 (players)) TRUE)
			(= (volume_test_objects vol_grotto_mid_02 (players)) TRUE)
			(= (volume_test_objects vol_grotto_mid_03 (players)) TRUE)
		)
	)
	(if 
		(OR
			(= (volume_test_objects vol_grotto_mid_02 (players)) TRUE)
			(= (volume_test_objects vol_grotto_mid_03 (players)) TRUE)
		)
			(sleep_forever)
	)
	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_crack_grunts 2)
	)
	
	(sleep_until 
		(OR
			(< (ai_living_count grotto_crack_grunts) 2)
			(= (volume_test_objects vol_grotto_first_pool_02 (players)) TRUE)
			(= (volume_test_objects vol_grotto_mid_02 (players)) TRUE)
			(= (volume_test_objects vol_grotto_mid_03 (players)) TRUE)
		)
	)
	(if 
		(OR
			(= (volume_test_objects vol_grotto_mid_02 (players)) TRUE)
			(= (volume_test_objects vol_grotto_mid_03 (players)) TRUE)
		)
			(sleep_forever)
	)
	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_buggers_new_01 (- 4 (ai_living_count grotto_buggers)))
	)
	
	(sleep_until 
		(OR
			(< (ai_living_count grotto_buggers_new_01) 2)
			(= (volume_test_objects vol_grotto_mid_02 (players)) TRUE)
			(= (volume_test_objects vol_grotto_mid_03 (players)) TRUE)
		)
	)
	(sleep_until 
		(begin
			(if (< (ai_living_count grotto_pool_grunts) 1)
				(ai_place grotto_pool_grunts 1)
			)
			(OR
				(= (volume_test_objects vol_grotto_mid_02 (players)) TRUE)
				(= (volume_test_objects vol_grotto_mid_03 (players)) TRUE)
				(> (ai_spawn_count grotto_pool_grunts) 3)
			)
		)
	)
)

(script dormant grotto_buggers_reinforce
	(if 
		(AND
			(< (ai_living_count grotto_enemies) 8)
			(difficulty_legendary)
		)
			(ai_place grotto_buggers_01 (- 4 (ai_living_count grotto_buggers)))
	)

	(sleep_until (= (volume_test_objects vol_grotto_mid_03 (players)) TRUE))
	(ai_migrate grotto_buggers_01 grotto_buggers_02)

	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_buggers_02 (- 4 (ai_living_count grotto_buggers)))
	)
)

;---

(script dormant grotto_extra_checkpoint
	(sleep 60)
	(sleep_until 
		(AND
			(= (volume_test_objects vol_grotto (players)) FALSE)
			(> (player_count) 0)
		)
	)
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(game_save)
)

(script command_script grotto_entry_patrol
	(cs_abort_on_alert TRUE)
	(sleep_until
		(begin
			(begin
				(cs_go_to_and_face grotto/p0 grotto/p2)
				(cs_aim TRUE grotto/p2)
				(sleep (random_range 30 90))
				(cs_aim FALSE grotto/p2)
			)
			(begin
				(cs_go_to_and_face grotto/p1 grotto/p2)
				(cs_aim TRUE grotto/p2)
				(sleep (random_range 30 90))
				(cs_aim FALSE grotto/p2)
			)
			FALSE
		)
	)
)

(global short grotto_final_snipers 1)
;Overall script for grotto
(script dormant grotto_start
	(ai_disposable old_temple_enemies TRUE)
	(data_mine_set_mission_segment "05a_9_grotto")
	(game_save)
	(wake 05a_title2)
	(ai_place grotto_init_01 1)
	(ai_place grotto_init_04 1)
	(ai_place grotto_init_05 1)
	;(ai_place grotto_init_06 1)
	(ai_place grotto_init_07 1)
	(ai_place grotto_init_09 1)
	(cs_run_command_script grotto_init_09 grotto_entry_patrol)
	(ai_place grotto_init_11 2)
	;(ai_place grotto_sleepers 1)
	
	(wake grotto_cortana_comment)
	(wake grotto_pool)
	(wake grotto_extra_checkpoint)

	(sleep_until 
	;	(OR
			(= (volume_test_objects vol_grotto_mid_02 (players)) TRUE)
	;		(< (ai_living_count grotto_enemies) 4)
	;	)
	)
	(game_save)
	(if 
		(OR
			(difficulty_heroic)
			(difficulty_legendary)
		)
			(set grotto_final_snipers 2)
	)
	(begin_random
		(if 
			(AND
				(> grotto_final_snipers 0)
				(< (ai_living_count grotto_enemies) 8)
			)
				(begin
					(ai_place grotto_cave_jackals_02 1)
					(set grotto_final_snipers (- grotto_final_snipers 1))
				)
		)
		(if
			(AND
				(> grotto_final_snipers 0)
				(< (ai_living_count grotto_enemies) 8)
			)
				(begin
					(ai_place grotto_cave_jackals_03 1)
					(set grotto_final_snipers (- grotto_final_snipers 1))
				)
		)
	)
	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_cave_jackals_01 1)
	)
	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_cave_elites 1)
	)
	(wake grotto_buggers_reinforce)

	(sleep_until 
	;	(OR
			(= (volume_test_objects vol_grotto_far_top (players)) TRUE)
	;		(< (ai_living_count grotto_enemies) 8)
	;	)
	)
	(game_save)

	(wake grotto_reminder)
	(ai_migrate grotto_buggers_02 grotto_buggers_03)
	(if 
		(AND
			(< (ai_living_count grotto_enemies) 8)
			(difficulty_legendary)
		)
			(ai_place grotto_buggers_03 (- 4 (ai_living_count grotto_buggers)))
	)
	(ai_set_orders grotto_buggers grotto_follow_03)

	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_end_elites_01 1)
	)
	(sleep 30)
;	(ai_place grotto_end_jackals_01 1)
;	(sleep 30)
	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_end_jackals_02 2)
	)
	(sleep 30)
;	(ai_place grotto_end_jackals_03 1)
;	(sleep 30)
	(if (< (ai_living_count grotto_enemies) 8)
		(ai_place grotto_end_elites_02 1)
	)

	(sleep_until 
	;	(OR
			(= (volume_test_objects vol_grotto_end (players)) TRUE)
	;		(< (ai_living_count grotto_enemies) 8)
	;	)
	)
	(wake music_05a_05_stop)
	(game_save)
	(ai_set_orders grotto_initial grotto_follow_03)
	
	(sleep_until (< (ai_living_count grotto_enemies) 1))
	(game_save)
	
;*	(if 
		(AND
			(= (volume_test_objects vol_grotto_end (players)) FALSE)
			(> (player_count) 0)
		)
			(ai_place grotto_grunts_end 1)
	)
	(sleep 300)
	(if 
		(AND
			(= (volume_test_objects vol_grotto_end (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count grotto_grunts_end) 1)
		)	
			(ai_place grotto_grunts_end 1)
	)
	(if (= (volume_test_objects vol_grotto_end (players)) TRUE)
		(sleep_forever)
	)
	(sleep_until 
		(begin
			(if 
				(AND
					(= (volume_test_objects vol_grotto_end (players)) FALSE)
					(> (player_count) 0)
					(< (ai_living_count grotto_grunts_end) 1)
				)	
					(ai_place grotto_grunts_end 1)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_grotto_end (players)) TRUE) 
					(< (ai_living_count grotto_grunts_end) 1)
					(> (ai_spawn_count grotto_grunts_end) 5)
				)
			30 210)	
			(OR
				(= (volume_test_objects vol_grotto_end (players)) TRUE)
				(> (ai_spawn_count grotto_grunts_end) 5)
			)
		)
	)
*;
)


;-------------------------------------------------------------------------------
;Temple Approach

;Comment on
(script dormant approach_cortana_comment
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'Good. Still no word about In Amber Clad on the Covenant battle-net.'") 
	(sleep (ai_play_line_on_object NONE 0760))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0760_cor))
	(sleep 60)
	(print "CORTANA: 'It's odd - the Covenant know we made land-fall,'")
	(print "'but they don't seem to consider us a very serious threat.'") 
	(sleep (ai_play_line_on_object NONE 0770))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0770_cor))
	(sleep 30)
	(print "CORTANA: 'Boy are they in for a big surprise!'") 
	(sleep (ai_play_line_on_object NONE 0780))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0780_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(game_save)
)


;Reminder to press on
(script dormant approach_reminder
	(sleep_until (= (volume_test_objects vol_tower1 (players)) TRUE) 30 3600)
	(if 
		(AND
			(= (volume_test_objects vol_tower1 (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'This tower cluster should connect to the structures further...'")
				(print "'...out in the lake. Let's get inside.'") 
				(sleep (ai_play_line_on_object NONE 0790))
				;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0790_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Overall script for temple approach
(script dormant temple_approach_start
	(ai_disposable grotto_enemies TRUE)
	(data_mine_set_mission_segment "05a_10_tower_approach")
	
	(ai_place approach_jackal_01)
	(ai_place approach_jackal_02)
	(ai_place approach_jackal_03)
	(ai_place approach_elite_01)
	(ai_place approach_elite_02)
	(ai_place approach_elite_03)
	(ai_place approach_grunts_01)

	(wake approach_cortana_comment)
	(wake approach_reminder)
	
	(sleep_until
		(OR
			(= (volume_test_objects vol_approach_ramp (players)) TRUE)
			(AND
				(= (volume_test_objects vol_approach_music (players)) TRUE)
				(= (objects_can_see_flag (players) see_tower1 30) TRUE)
			)
		)
	)
	(wake music_05a_06_start)
	
	(sleep_until
		(OR
			(> (ai_combat_status approach_enemies) ai_combat_status_idle)
			(= (volume_test_objects vol_approach_ramp (players)) TRUE)
		)
	)

;9/12

	(if 
		(AND
			(= (volume_test_objects vol_approach_ramp (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count approach_enemies) 8)
		)
			(ai_place approach_buggers 5)
	)
	(sleep 2)
	
	(sleep_until (< (ai_living_count approach_buggers) 1))
	(sleep_until
		(AND
			(OR
				(= (volume_test_object vol_no_see_ramp (player0)) TRUE)
				(= (volume_test_object vol_no_see_approach (player0)) TRUE)
			)
			(OR
				(= (volume_test_object vol_no_see_ramp (player1)) TRUE)
				(= (volume_test_object vol_no_see_approach (player1)) TRUE)
				(= (game_is_cooperative) FALSE)
			)
		)
	)
	(if (< (ai_living_count approach_enemies) 8)
		(ai_place approach_buggers_too 4)
	)
)


;-------------------------------------------------------------------------------
;Tower 1 Interior

(global boolean tower1_holo_trans FALSE)
(global boolean tower1_holo_chant TRUE)

(script dormant tower1_holo_looper
	(object_create regret03)
	(objects_attach tower1_throne "driver" regret03 "")
	(ai_disregard regret03 TRUE)
	(sleep_until
		(begin
			(begin_random
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant1a" TRUE)
						(sleep (ai_play_line_on_object regret03 3000))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant2b" TRUE)
						(sleep (ai_play_line_on_object regret03 3001))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant2c" TRUE)
						(sleep (ai_play_line_on_object regret03 3002))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant3a" TRUE)
						(sleep (ai_play_line_on_object regret03 3003))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant3c" TRUE)
						(sleep (ai_play_line_on_object regret03 3004))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant5a" TRUE)
						(sleep (ai_play_line_on_object regret03 3005))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant6a" TRUE)
						(sleep (ai_play_line_on_object regret03 3006))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
			)
			FALSE
		)
	)
)

(script dormant tower1_hg_warn
	(sleep_until 
		(AND
			(= (volume_test_objects vol_tower1_see_hg (players)) TRUE)
			(OR
				(objects_can_see_object (players) (list_get (ai_actors tower1_hg_01a) 0) 30)
				(objects_can_see_object (players) (list_get (ai_actors tower1_hg_01b) 0) 30)
			)
		)
	)		
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'Watch yourself! Honor-Guards!'")
	(sleep (ai_play_line_on_object NONE 0800))
	;(sleep (sound_impulse_language_time sound\dialog\levels\05_deltatemple\mission\L05_0800_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

(global boolean who_points TRUE)
(script command_script long_pause_point
	(sleep_until (> (ai_combat_status ai_current_actor) ai_combat_status_idle))
	(cs_aim_player TRUE)
	(cs_custom_animation objects\characters\elite\elite "combat:rifle:warn" 1 TRUE)
	(cs_aim_player FALSE)
)

;Overall script for tower 1 interior
(script dormant tower1_start
	(sleep_until (= (volume_test_objects vol_tower1 (players)) TRUE)) 
	(ai_disposable approach_enemies TRUE)
	(data_mine_set_mission_segment "05a_11_tower1_interior")
	(wake tower1_holo_looper)
	(game_save)
	
;	(ai_place tower1_grunts_01 3)
	(ai_place tower1_hg_01a 1)
	(ai_place tower1_hg_01b 1)
	(begin_random
		(if (= who_points TRUE)
			(begin
				(cs_run_command_script tower1_hg_01a long_pause_point)
				(ai_set_orders tower1_hg_01a tower1_hg1a)
				(cs_run_command_script tower1_hg_01b long_pause)
				(ai_set_orders tower1_hg_01b tower1_hg1b_back)
				(set who_points FALSE)
			)
		)
		(if (= who_points TRUE)
			(begin
				(cs_run_command_script tower1_hg_01a long_pause)
				(ai_set_orders tower1_hg_01a tower1_hg1a_back)
				(cs_run_command_script tower1_hg_01b long_pause_point)
				(ai_set_orders tower1_hg_01b tower1_hg1b)
				(set who_points FALSE)
			)
		)
	)
	(wake tower1_hg_warn)
	
	(sleep_until 
		(OR
			(AND
				(< (ai_living_count tower1_hg_01a) 1)
				(< (ai_living_count tower1_hg_01b) 1)
			)
			(= (volume_test_objects vol_tower1_upper (players)) TRUE)
		)
	)
	;(ai_place tower1_grunts_02 (- 3 (ai_living_count tower1_grunts_01)))
	(ai_place tower1_hg_02a (- 1 (ai_living_count tower1_hg_01a)))
	(ai_place tower1_hg_02b (- 1 (ai_living_count tower1_hg_01b)))
	
	(sleep_until (< (ai_living_count tower1_enemies) 1) 30 8000)
	(sleep_until (= (ai_trigger_test "done_fighting" tower1_enemies) TRUE))
	
	(sleep_until (= (volume_test_objects vol_tower1_all (players)) TRUE)) 
;	(sleep 30)
	(playtest_mission)
	(sleep 30)
	(sound_class_set_gain "" 0 15)
	(cinematic_fade_to_white)
	(sleep 30)
	(game_won) 
)


;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;Ally orders

;temp way of getting tank beyond old temple
(script command_script temple_ent_go
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_go_to_and_face temple_ent/p2 temple_ent/p1)
	(cs_vehicle_speed .25)
	(cs_go_to_and_face temple_ent/p0 temple_ent/p1)
	(cs_move_in_direction 0 10 0)
)

(script dormant bridge_bunker_backup
	(if (= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (ai_actors LZ_warthog_01)) TRUE)
		(sleep_until 
			(AND
				(= (volume_test_objects vol_bunker_parking (ai_actors LZ_warthog_01)) TRUE)
				(= (ai_trigger_test "done_fighting" LZ_warthog_01) TRUE)
			)
		)
	)
	(ai_vehicle_exit all_allies)
	(ai_set_orders all_allies allies_bridge_bunker)
)

;Sets ally orders in vehicles throughout mission
(script dormant ally_order_monitor
	(sleep_until 
		(OR
			(= lz_mounted_up TRUE)
			(= (volume_test_objects vol_lz_all (players)) FALSE)
		)
	)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_overlook_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_overlook_pause)
					(ai_set_orders LZ_warthog_01 allies_overlook_follow)
			)
			(= (volume_test_objects vol_overlook_pause (players)) TRUE)
		)
	)
	(sleep_until 
		(OR
			(= (volume_test_objects vol_bridge_pause (players)) TRUE)
			(AND
				(= (volume_test_objects vol_overlook_pause (ai_actors LZ_warthog_01)) TRUE)
				(= (ai_trigger_test "done_fighting" overlook_jackals) TRUE)
			)
		)
	)
	(sleep_until (= (volume_test_objects vol_bridge_pause (players)) TRUE) 30 300)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_bridge_follow_01)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_bridge_pause)
					(ai_set_orders LZ_warthog_01 allies_bridge_follow_01)
			)
			(= (volume_test_objects vol_bridge_pause (players)) TRUE)
		)
	)
	(sleep_until 
		(AND
			(= (volume_test_objects vol_bridge_pause (players)) FALSE) 
			(> (player_count) 0)
		)
	30 300)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_bridge_follow_01)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_bridge_advance)
					(ai_set_orders LZ_warthog_01 allies_bridge_follow_01)
			)
			(= (volume_test_objects vol_bridge_inside_bunker (players)) TRUE)
		)
	)
	
	(ai_set_orders ally_infantry allies_bridge_bunker)
	(ai_set_orders LZ_warthog_01 allies_bridge_bunker)
	(wake bridge_bunker_backup)
	(sleep_until 
		(OR
			(= bridge_pelican_arrived TRUE)
			(= (volume_test_objects vol_bridge_middle (players)) TRUE)
		)
	)
	(sleep_until
		(OR
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0)) TRUE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player1)) TRUE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
			(= (volume_test_objects vol_bridge_middle (players)) TRUE)
		)
	)
	(ai_enter_squad_vehicles all_allies)
	
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_bridge_follow_02)
			(ai_set_orders bridge_tank allies_bridge_follow_02)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_bridge_cross)
					(ai_set_orders LZ_warthog_01 allies_bridge_follow_02)
			)
			(OR
				(= (volume_test_objects vol_winding_path (players)) TRUE)
				(AND
					(= (volume_test_objects vol_bridge_farside_all (ai_actors LZ_warthog_01)) TRUE)
					(= (ai_trigger_test "done_fighting" bridge_farside_enemies) TRUE)
				)
			)
		)
	)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_w_path_follow)
			(ai_set_orders bridge_tank allies_w_path_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_w_path_advance)
					(ai_set_orders LZ_warthog_01 allies_w_path_follow)
			)
			(OR
				(= (volume_test_objects vol_temple_ent_start (players)) TRUE)
				(AND
					(= (volume_test_objects vol_temple_entrance (ai_actors LZ_warthog_01)) TRUE)
					(= (ai_trigger_test "done_fighting" winding_path_enemies) TRUE)
				)
			)
		)
	)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_temple_ent_follow)
			(ai_set_orders bridge_tank allies_temple_ent_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_advance_01)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_follow)
			)
			(OR
				(= (volume_test_objects vol_tunnel_01 (players)) TRUE)
				(= temple_ent_phase_01 TRUE)
				(AND
					(= (volume_test_objects vol_temple_ent_03 (ai_actors LZ_warthog_01)) TRUE)
					(= (ai_trigger_test "done_fighting" temple_ent_enemies_all) TRUE)
				)
			)
		)
	)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_temple_ent_follow)
			(ai_set_orders bridge_tank allies_temple_ent_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_advance_02)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_follow)
			)
			(OR
				(= (volume_test_objects vol_tunnel_01 (players)) TRUE)
				(= temple_ent_phase_02 TRUE)
				(AND
					(= (volume_test_objects vol_temple_ent_03 (ai_actors LZ_warthog_01)) TRUE)
					(= (ai_trigger_test "done_fighting" temple_ent_enemies_all) TRUE)
				)
			)
		)
	)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_temple_ent_follow)
			(ai_set_orders bridge_tank allies_temple_ent_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_advance_03)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_follow)
			)
			(OR
				(= (volume_test_objects vol_tunnel_01 (players)) TRUE)
				(AND
					(= (volume_test_objects vol_temple_ent_03 (ai_actors LZ_warthog_01)) TRUE)
					(= (ai_trigger_test "done_fighting" temple_ent_enemies_all) TRUE)
				)
			)
		)
	)
	;(cs_run_command_script LZ_warthog_01/driver temple_ent_go)
	(cs_run_command_script bridge_tank/driver temple_ent_go)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_tunnel_follow)
			(ai_set_orders bridge_tank allies_tunnel_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_tunnel_advance)
					(ai_set_orders LZ_warthog_01 allies_tunnel_follow)
			)
			(OR
				(= (volume_test_objects vol_old_temple_near_left (players)) TRUE)
				(AND
					(= (volume_test_objects vol_tunnel_03 (ai_actors LZ_warthog_01)) TRUE)
					(= (ai_trigger_test "done_fighting" tunnel_enemies_all) TRUE)
				)
			)
		)
	)
	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_old_temple_follow)
			(ai_set_orders bridge_tank allies_old_temple_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_old_temple_advance)
					(ai_set_orders LZ_warthog_01 allies_old_temple_follow)
			)
			(OR
				(= (volume_test_objects vol_old_temple_center_01 (players)) TRUE)
				(= (volume_test_objects vol_old_temple_center_01 (ai_actors LZ_warthog_01)) TRUE)
			)
		)
	)
	(sleep_until 
		(AND
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0)) FALSE)
			(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player1)) FALSE)
		)
	)
	(ai_vehicle_exit all_allies) 
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_tank/driver) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) TRUE)
	(ai_migrate allies_old_temple_pelican allies_old_temple_real)
	(ai_set_orders all_allies allies_old_temp_center)
	
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(ai_set_orders all_allies allies_grotto_suppress)

	(sleep_until (> (ai_combat_status grotto_enemies) ai_combat_status_idle))
	(ai_set_orders all_allies grotto_follow_01)

	(sleep_until (= (volume_test_objects vol_grotto_exit (players)) TRUE))
	(ai_set_orders all_allies allies_grotto_exit)
	
	(sleep_until (= (structure_bsp_index) 1))
	(ai_set_orders all_allies allies_approach)

	(sleep_until (= (volume_test_objects vol_tower1 (players)) TRUE))
	(ai_set_orders all_allies allies_tower1)
)


;-------------------------------------------------------------------------------

;Sleeping old stuff once past

(script static void sleep_intro
	(sleep_forever LZ_start)
	(sleep_forever LZ_turret_track)
	(sleep_forever lz_turret_reminder)
	(sleep_forever lz_pelican)
	(sleep_forever lz_pelican_wait)
	(sleep_forever lz_phantom_03_start)
)

(script static void sleep_bridge
	(sleep_forever overlook_start)
	(sleep_forever overlook_reminder)
	(sleep_forever bridges_start)
	(sleep_forever crack_spawn)
	(sleep_forever bunker_upper_spawn_01)
	(sleep_forever bunker_upper_spawn_03)
	(sleep_forever bunker_lower_spawn_01)
	(sleep_forever bunker_turret_remanning)
	(sleep_forever bunker_spawn_checker)
	(sleep_forever bridge_ghosts_by_phantom)
	(sleep_forever farside_ghosts_spawn)
	(sleep_forever bridge_phantom_reinforce_01a)
	(sleep_forever bridge_phantom_reinforce_01b)
	(sleep_forever bridge_phantom_reinforce_02a)
	(sleep_forever bridge_phantom_reinforce_02b)
	(sleep_forever bridge_cortana_comment)
	(sleep_forever bridge_wraith_warning)
	(sleep_forever bridge_activate_reminder)
	(sleep_forever bunker_holo_looper)
	(sleep_forever bridge_holo_translate)
	(sleep_forever bridge_pelican_wait)
	(sleep_forever bridge_cross_reminder)
	(sleep_forever bridge_banshee_spawn)
	(sleep_forever bridge_spare_ghost_spawn)
)

(script static void sleep_winding_path
	(sleep_forever winding_path_start)
)

(script static void sleep_temple_ent
	(sleep_forever old_temple_entrance_start)
	(sleep_forever temple_ent_ghost_alert)
	(sleep_forever temple_ent_veh_spawn)
	(sleep_forever temple_ent_reminder)
	(sleep_forever temple_ent_arch)
)
	
(script static void	sleep_tunnel
	(sleep_forever tunnel_start)
)

(script static void sleep_old_temple
	(sleep_forever old_temple_start)
	(sleep_forever old_temple_near_right)
	(sleep_forever old_temple_far_left)
	(sleep_forever old_temple_far_right)
	(sleep_forever old_temple_below)
	(sleep_forever old_temple_center)
	(sleep_forever old_temple_courtyard)
	(sleep_forever old_temple_vehicle_spawn)
	(sleep_forever old_temple_pelican)
	(sleep_forever old_temple_phantom_01)
	(sleep_forever old_temple_phantom_02)
	(sleep_forever old_temple_turret_reman)
	(sleep_forever old_temple_perimeter_nuke)
	(sleep_forever old_temple_middle_ally)
	(sleep_forever old_temple_playfight)
	(sleep_forever old_temple_debris_comment)
	(sleep_forever old_temple_middle_comment)
	(sleep_forever old_temple_debris_reminder)
	(sleep_forever old_temple_holo_translate)
	(sleep_forever courtyard_holo_looper)
	(sleep_forever old_temple_archaeologist)
)

(script static void sleep_grotto
	(sleep_forever grotto_start)
	(sleep_forever grotto_buggers_reinforce)
;	(sleep_forever grotto_end_reinforce)
	(sleep_forever grotto_cortana_comment)
	(sleep_forever grotto_ally_comments)
	(sleep_forever grotto_reminder)
	(sleep_forever grotto_pool)
	(sleep_forever grotto_extra_checkpoint)
)

(script static void sleep_approach
	(sleep_forever temple_approach_start)
	(sleep_forever approach_reminder)
)


;-------------------------------------------------------------------------------

;Startup scripts
(script startup mission	

;Cutscene stuff

	(cinematic_snap_to_black)	
	(if (= (volume_test_objects vol_starting_locations (players)) TRUE)
		(begin
			(sound_suppress_ambience_update_on_revert)
			(if (cinematic_skip_start)
				(begin
					(X05)
				)
			)
			(cinematic_skip_stop)

			(cinematic_snap_to_white)	

			(if (cinematic_skip_start)
				(begin
					(C05_intro)
				)
			)
			(cinematic_skip_stop)

		)
	)

	(sleep 2)
	(switch_bsp 0)	
	(sleep 2)
	
;Mission stuff

	(ai_allegiance covenant prophet)
	(ai_allegiance player human)	
	(objectives_clear)

	(prep_return_from_intro)		

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(wake 05a_title0)
	(wake objective_lz_set)
	(wake kill_volumes)
	
	(wake LZ_start)
	(wake ally_order_monitor)

	(sleep_until (= (volume_test_objects vol_overlook (players)) TRUE))
	(wake overlook_start)
	(wake bridges_start)
	(wake objective_bridge_set)

	(sleep_until (= (volume_test_objects vol_winding_path (players)) TRUE))
	(wake winding_path_start)
	(wake old_temple_entrance_start)
	(wake objective_bridge_clear)
	(wake objective_ruins_set)
	(sleep_intro)

	(sleep_until (= (volume_test_objects vol_tunnel_01 (players)) TRUE))
	(wake tunnel_start)
	(wake old_temple_start)
	(wake old_temple_courtyard)
	(sleep_bridge)
	(sleep_winding_path)

	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(wake grotto_start)
	(sleep_temple_ent)
	(sleep_tunnel)
	
	(sleep_until (= (volume_test_objects vol_approach (players)) TRUE))
	(wake temple_approach_start)
	(wake tower1_start)	
	(wake objective_ruins_clear)
	(wake objective_tower1_set)
	(sleep_old_temple)
	
	(sleep_until (= (volume_test_objects vol_tower1 (players)) TRUE))
	(sleep_grotto)
)

(script static void short_allies
	(ai_allegiance player human)
	(ai_place LZ_warthog_01)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0))
	(ai_place_in_vehicle allies_lz_ridge LZ_warthog_01)
	(object_teleport (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) ally_start)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_overlook_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_overlook_pause)
					(ai_set_orders LZ_warthog_01 allies_overlook_follow)
			)
			(= (volume_test_objects vol_overlook_pause (players)) TRUE)
		)
	)

	(sleep 30)
	(print "arrived")
	(sleep 30)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_bridge_follow_01)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_bridge_pause)
					(ai_set_orders LZ_warthog_01 allies_bridge_follow_01)
			)
			(= (volume_test_objects vol_bridge_pause (players)) TRUE)
		)
	)

	(sleep 30)
	(print "arrived")
	(sleep 30)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_bridge_follow_02)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_bridge_cross)
					(ai_set_orders LZ_warthog_01 allies_bridge_follow_02)
			)
			(OR
				(= (volume_test_objects vol_winding_path (players)) TRUE)
				(= (volume_test_objects vol_bridge_farside_all (ai_actors LZ_warthog_01)) TRUE)
			)
		)
	)

	(sleep 30)
	(print "arrived")
	(sleep 30)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_w_path_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_w_path_advance)
					(ai_set_orders LZ_warthog_01 allies_w_path_follow)
			)
			(OR
				(= (volume_test_objects vol_temple_ent_start (players)) TRUE)
				(= (volume_test_objects vol_temple_entrance (ai_actors LZ_warthog_01)) TRUE)
			)
		)
	)

	(sleep 30)
	(print "arrived")
	(sleep 30)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_temple_ent_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_advance_03)
					(ai_set_orders LZ_warthog_01 allies_temple_ent_follow)
			)
			(OR
				(= (volume_test_objects vol_tunnel_01 (players)) TRUE)
				(= (volume_test_objects vol_temple_ent_03 (ai_actors LZ_warthog_01)) TRUE)
			)
		)
	)
	;(cs_run_command_script LZ_warthog_01/driver temple_ent_go)
	(cs_run_command_script bridge_tank/driver temple_ent_go)

	(sleep 30)
	(print "arrived")
	(sleep 30)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_tunnel_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_tunnel_advance)
					(ai_set_orders LZ_warthog_01 allies_tunnel_follow)
			)
			(OR
				(= (volume_test_objects vol_old_temple_near_left (players)) TRUE)
				(= (volume_test_objects vol_tunnel_03 (ai_actors LZ_warthog_01)) TRUE)
			)
		)
	)

	(sleep 30)
	(print "arrived")
	(sleep 30)

	(sleep_until
		(begin
			(ai_set_orders ally_infantry allies_old_temple_follow)
			(if
				(OR
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player0)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1)) TRUE)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_g" (player1)) TRUE)
				)
					(ai_set_orders LZ_warthog_01 allies_old_temple_advance)
					(ai_set_orders LZ_warthog_01 allies_old_temple_follow)
			)
			(OR
				(= (volume_test_objects vol_old_temple_center_01 (players)) TRUE)
				(= (volume_test_objects vol_old_temple_center_01 (ai_actors LZ_warthog_01)) TRUE)
			)
		)
	)

	(sleep 30)
	(print "arrived")
	(sleep 30)

	(ai_vehicle_exit all_allies) 
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location bridge_tank/driver) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) TRUE)
	(ai_migrate allies_old_temple_pelican allies_old_temple_real)
	(ai_set_orders all_allies allies_old_temp_center)
	
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(ai_set_orders all_allies grotto_follow_01)

	(sleep_until (= (volume_test_objects vol_grotto_exit (players)) TRUE))
	(ai_set_orders all_allies allies_grotto_exit)
	
	(sleep_until (= (structure_bsp_index) 1))
	(ai_set_orders all_allies allies_approach)

	(sleep_until (= (volume_test_objects vol_tower1 (players)) TRUE))
	(ai_set_orders all_allies allies_tower1)
)
