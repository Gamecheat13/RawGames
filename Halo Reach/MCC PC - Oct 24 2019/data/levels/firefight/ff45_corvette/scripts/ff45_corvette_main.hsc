

(script startup ff45_main
	; Turn off the space junk
	(render_weather 0)
	
	; Slam some doors open
	(device_set_position safe_door0 1)
	(device_set_position safe_door1 1)

	; Snap to black 
	(if (> (player_count) 0) (cinematic_snap_to_black))
	(sleep 5)
	
	; switch to the proper zone set 
	(switch_zone_set set_firefight)

	; Setting up squad groups
	(set ai_sur_wave_spawns gr_wave_spawns)
	(set ai_sur_bonus_wave ff_bonus)
	(set ai_sur_remaining ff_remaining)
	(set s_sur_wave_squad_count 6)
	
	; Fireteam squads
	(set ai_sur_fireteam_squad0 ff_elite_fireteam0)
	(set ai_sur_fireteam_squad1 ff_elite_fireteam1)
	(set ai_sur_fireteam_squad2 ff_elite_fireteam2)
	(set ai_sur_fireteam_squad3 ff_elite_fireteam3)
	(set ai_sur_fireteam_squad4 ff_elite_fireteam4)
	(set ai_sur_fireteam_squad5 ff_elite_fireteam5)
	
	; Wave objective
	(set ai_obj_survival ff_objective)
	
	; Phantom squads
	(set ai_sur_phantom_01 ff_phantom0)
	(set ai_sur_phantom_02 ff_phantom1)
	(set ai_sur_phantom_03 ff_phantom2)
	(set ai_sur_phantom_04 ff_phantom3)
	(set ai_sur_bonus_phantom ff_phantom_bonus)

	; Phantom load and usage parameters 
	(set k_phantom_spawn_limit 2)
	(set s_sur_dropship_type 2)	; Use Spirits instead of Phantoms
	(set b_sur_phantoms_semi_random true)
	(set s_sur_drop_side_01 "dual")
	(set s_sur_drop_side_02 "dual")
	(set s_sur_drop_side_03 "dual")
	(set s_sur_drop_side_04 "dual")
	(set s_sur_drop_side_bonus "dual")
			
	; Set these three to named objects in your scenario
	; Recommend using tags/objects/temp/tysongr/unsc_shield_generator_anvil
	(set obj_sur_generator0 generator0)
	(set obj_sur_generator1 generator1)
	(set obj_sur_generator2 generator2)
	(set obj_ammo_crate0 ammo_crate0)
	(set obj_ammo_crate1 ammo_crate1)
	
	; Shorten wave delay
	(set k_sur_wave_timer 60)
		
	; Wake the survival mode global scirpt 
	(wake survival_mode)
	(wake ff45_weapon_drops)
	(wake ff45_wave_ticker)
	
	; Startup grunts!
	(if (survival_mode_scenario_extras_enable)
		(ai_place ff_startup_grunts)
	)
)


(script static void (survival_set_hold_task (ai squad))
	(ai_set_task squad ff_objective hold_task)
)


(global short s_last_wave_index -2)
(script dormant ff45_wave_ticker
	(set s_last_wave_index (survival_mode_wave_get))
	(sleep_until
		(begin
			(if (!= s_last_wave_index (survival_mode_wave_get))
				(begin
					(set s_last_wave_index (survival_mode_wave_get))
					(ff45_freeze_doors)
					(ff45_spawn_engineers)
				)
			)
			false
		)
		1
	)
)


(script static void ff45_freeze_doors
	(device_operates_automatically_set door0 false)
	(device_operates_automatically_set door1 false)
	(device_operates_automatically_set door2 false)
	(device_operates_automatically_set door3 false)
	(device_operates_automatically_set door4 false)
	(device_operates_automatically_set door5 false)
	(sleep 90)
	(device_operates_automatically_set door0 true)
	(device_operates_automatically_set door1 true)
	(device_operates_automatically_set door2 true)
	(device_operates_automatically_set door3 true)
	(device_operates_automatically_set door4 true)
	(device_operates_automatically_set door5 true)
)


(script static void (ff45_load_wraith (vehicle phantom))
	(if 
		(and
			(survival_mode_scenario_extras_enable)
		 	(= (random_range 0 5) 0)
			(<= (object_get_health (ai_vehicle_get_from_spawn_point ff_wraith0/driver)) 0)
		)
		(begin
			(f_load_fork_cargo phantom "large" ff_wraith0 none none)
		)
	)
)


;- Objective Scripts -------------------------------------------------------------------------------------------------------

(script static void survival_refresh_follow
	(survival_refresh_sleep)
	(ai_reset_objective ff_objective/main_follow)
)

(script static void survival_hero_refresh_follow
	(survival_refresh_sleep)
	(survival_refresh_sleep)
	(ai_reset_objective ff_objective/hero_follow)
)

(script static void survival_generator_refresh
	(survival_refresh_sleep)
	(survival_refresh_sleep)
	(ai_reset_objective ff_objective/generator)
)


;- Phantom Scripts ---------------------------------------------------------------------------------------------------------

(global vehicle g_hangar_phantom none)

(script continuous phantom_unloader0
	(sleep_forever)
	(sleep 210)
	(f_unload_fork_cargo v_sur_phantom_01 "large")
	(unit_open v_sur_phantom_01)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_01)
	(sleep 120)
	(unit_close v_sur_phantom_01)
)

(script continuous phantom_unloader1
	(sleep_forever)
	(sleep 240)
	(f_unload_fork_cargo v_sur_phantom_02 "large")
	(unit_open v_sur_phantom_02)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_02)
	(sleep 120)
	(unit_close v_sur_phantom_02)
)

(script continuous phantom_unloader2
	(sleep_forever)
	(sleep 210)
	(f_unload_fork_cargo v_sur_phantom_03 "large")
	(unit_open v_sur_phantom_03)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_03)
	(sleep 120)
	(unit_close v_sur_phantom_03)
)

(script continuous phantom_unloader3
	(sleep_forever)
	(sleep 240)
	(f_unload_fork_cargo v_sur_phantom_04 "large")
	(unit_open v_sur_phantom_04)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_04)
	(sleep 120)
	(unit_close v_sur_phantom_04)
)

(global vehicle g_callout_phantom none)

(script continuous phantom_callout
	(sleep_forever)
	(f_survival_callout_dropship g_callout_phantom)
)

(script command_script cs_ff_phantom0
	(set v_sur_phantom_01 (ai_vehicle_get ai_current_actor))
	(sleep 1)
	(object_cannot_die v_sur_phantom_01 TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(ai_dont_do_avoidance ai_current_actor TRUE)
	(object_set_shadowless v_sur_phantom_01 TRUE)
	
	; Wraith option
	(ff45_load_wraith v_sur_phantom_01)

	; Move into station
	(cs_fly_by ps_phantom0/p0)
	(set g_callout_phantom v_sur_phantom_01)
	(cs_fly_by ps_phantom0/p1)
	(wake phantom_callout)
	(cs_fly_to_and_face ps_phantom0/p2 ps_phantom0/p2_face 1.5)
	
	; Wait for it to clear
	(sleep 45)
	
	; Flag the hangar as occupied
	(set g_hangar_phantom v_sur_phantom_01)
	
	; Begin the unloader
	(wake phantom_unloader0)
	
	; Move in real slow like
	(cs_vehicle_speed 0.3)
	(cs_fly_by ps_phantom0/p3)
	
	; Unflag the hangar
	(set g_hangar_phantom none)
	(cs_fly_by ps_phantom0/p3_5)
	(cs_face true ps_phantom0/p3_5_facing)

	; Keep going
	(cs_fly_by ps_phantom0/p4)
	(cs_face false ps_phantom0/p3_5_facing)

	; Move out
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_phantom0/p5 3.0)
	(cs_fly_by ps_phantom0/p6)

	; Get lost
	(ai_erase ai_current_squad)
)


(script command_script cs_ff_phantom1
	(set v_sur_phantom_02 (ai_vehicle_get ai_current_actor))
	(sleep 1)
	(object_cannot_die v_sur_phantom_02 TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)		
	(ai_dont_do_avoidance ai_current_actor TRUE)
	(object_set_shadowless v_sur_phantom_02 TRUE)

	; Wraith option
;	(ff45_load_wraith v_sur_phantom_02)

	; Move into station
	(cs_fly_by ps_phantom1/p0)
;	(set g_callout_phantom v_sur_phantom_02)
	(cs_fly_by ps_phantom1/p1)
;	(wake phantom_callout)
	(cs_fly_to_and_face ps_phantom1/p2 ps_phantom1/p2_face 1.5)
	
	; Wait for it to clear
	(sleep 45)
	(sleep_until 
		(or
			(= g_hangar_phantom none) 
			(<= (object_get_health g_hangar_phantom) 0)
		)
		5
	)
	
	; Flag the hangar as occupied
	(set g_hangar_phantom v_sur_phantom_02)
	
	; Begin the unloader
	(wake phantom_unloader1)

	; Move in real slow like
	(cs_vehicle_speed 0.3)
	(cs_fly_by ps_phantom1/p3_5)
	(cs_face true ps_phantom1/p3_5_facing)
	(cs_fly_by ps_phantom1/p4)
	(cs_face false ps_phantom1/p3_5_facing)

	; Unflag the hangar
	(set g_hangar_phantom none)

	; Move out
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_phantom1/p5)
	(cs_fly_by ps_phantom1/p6)

	; Get lost
	(ai_erase ai_current_squad)
)


(script command_script cs_ff_phantom2
	(set v_sur_phantom_03 (ai_vehicle_get ai_current_actor))
	(sleep 1)
	(object_cannot_die v_sur_phantom_03 TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)		
	(ai_dont_do_avoidance ai_current_actor TRUE)
	(object_set_shadowless v_sur_phantom_03 TRUE)

	; Wraith option
	(ff45_load_wraith v_sur_phantom_03)

	; Move into station
	(cs_fly_by ps_phantom2/p0)
	(set g_callout_phantom v_sur_phantom_03)
	(cs_fly_by ps_phantom2/p1)
	(wake phantom_callout)
	(cs_fly_to_and_face ps_phantom2/p2 ps_phantom2/p2_face 1.5)
	
	; Wait for it to clear
	(sleep 45)
	
	; Flag the hangar as occupied
	(set g_hangar_phantom v_sur_phantom_03)
	
	; Begin the unloader
	(wake phantom_unloader2)

	; Move in real slow like
	(cs_vehicle_speed 0.3)
	(cs_fly_by ps_phantom2/p3)

	; Unflag the hangar
	(set g_hangar_phantom none)
	(cs_fly_by ps_phantom2/p3_5)
	(cs_face true ps_phantom2/p3_5_facing)
	(cs_fly_by ps_phantom2/p4)
	(cs_face false ps_phantom2/p3_5_facing)

	; Move out
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_phantom2/p5)
	(cs_fly_by ps_phantom2/p6)

	; Get lost
	(ai_erase ai_current_squad)
)


(script command_script cs_ff_phantom3
	(set v_sur_phantom_04 (ai_vehicle_get ai_current_actor))
	(sleep 1)
	(object_cannot_die v_sur_phantom_04 TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)		
	(ai_dont_do_avoidance ai_current_actor TRUE)
	(object_set_shadowless v_sur_phantom_04 TRUE)

	; Wraith option
;	(ff45_load_wraith v_sur_phantom_04)

	; Move into station
	(cs_fly_by ps_phantom3/p0)
;	(set g_callout_phantom v_sur_phantom_04)
	(cs_fly_by ps_phantom3/p1)
;	(wake phantom_callout)
	(cs_fly_to_and_face ps_phantom3/p2 ps_phantom3/p2_face 1.5)
	
	; Wait for it to clear
	(sleep 45)
	(sleep_until 
		(or
			(= g_hangar_phantom none) 
			(<= (object_get_health g_hangar_phantom) 0)
		)
		5
	)
	
	; Flag the hangar as occupied
	(set g_hangar_phantom v_sur_phantom_04)
	
	; Begin the unloader
	(wake phantom_unloader3)
	
	; Move in real slow like
	(cs_vehicle_speed 0.3)
	(cs_fly_by ps_phantom3/p3_5)
	(cs_face true ps_phantom3/p3_5_facing)
	(cs_fly_by ps_phantom3/p4)
	(cs_face false ps_phantom3/p3_5_facing)

	; Unflag the hangar
	(set g_hangar_phantom none)

	; Move out
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_phantom3/p5)
	(cs_fly_by ps_phantom3/p6)

	; Get lost
	(ai_erase ai_current_squad)
)


(script command_script cs_ff_phantom_bonus
	(set v_sur_bonus_phantom (ai_vehicle_get ai_current_actor))
	(sleep 1)
	(object_cannot_die v_sur_bonus_phantom TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(ai_dont_do_avoidance ai_current_actor TRUE)
	(object_set_shadowless v_sur_bonus_phantom TRUE)
	
	; Move into station
	(cs_fly_by ps_phantom_bonus/p0)
	(set g_callout_phantom v_sur_phantom_01)
	(cs_fly_by ps_phantom_bonus/p1)
	(wake phantom_callout)
	(cs_fly_to_and_face ps_phantom_bonus/p2 ps_phantom_bonus/p2_face 1.5)
	
	; Wait for it to clear
	(sleep 45)
	
	; Move in real slow like
	(cs_vehicle_speed 0.3)
	(cs_fly_to ps_phantom_bonus/p3)
	
	; Unload
	(set b_sur_bonus_phantom_ready true)

	; Wait for the bonus round to end
	(sleep_until b_sur_bonus_end)

	; Keep going
	(cs_fly_by ps_phantom_bonus/p3_5)
	(cs_face true ps_phantom_bonus/p3_5_facing)
	(cs_fly_by ps_phantom_bonus/p4)
	(cs_face true ps_phantom_bonus/p3_5_facing)

	; Move out
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_phantom_bonus/p5)
	(cs_fly_by ps_phantom_bonus/p6)

	; Get lost
	(ai_erase ai_current_squad)
)


;- Resupply Pods ---------------------------------------------------------------------------------------------------------

(script static boolean (resupply_pod_test_weapon (object pod))
	(or
		(!= (object_at_marker pod "gun_high") NONE)
		(!= (object_at_marker pod "gun_mid") NONE)
		(!= (object_at_marker pod "gun_lower") NONE)
	)              
)


(script static void (ff45_resupply_launch (object_name pod) (real english))
	; Destroy any extant pods
	(object_destroy pod)

	; Create the pod and launch it
	(begin_random_count 1
		(object_create_variant pod "laser")
		(object_create_variant pod "rocket")
		(object_create_variant pod "sniper")
	)
;	(object_set_velocity pod english 0 -25)
	
	; Make it invulnerable for the flight in
	(object_cannot_take_damage pod)
	
	; Wait to place the waypoint
	(sleep_until 
		(and
			(volume_test_object tv_resupply_zone pod)
			(object_get_at_rest pod)
			(resupply_pod_test_weapon pod)
		)
		30
		300
	)
	
	; Remove invulnerability
	(object_can_take_damage pod)
	
	; Damage it to open it
	(object_damage_damage_section pod "panel" 100)

	; Put the blip on
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object pod blip_ordnance)
	
	; Sleep until it should come off
	(sleep_until
		(or
			(not (volume_test_object tv_resupply_zone pod))
			(not (resupply_pod_test_weapon pod))
			(not (>= (object_get_health pod) 0))
		)
		5
		1800 ; Timeout after a minute
	)
	
	; And unblip it
	(f_unblip_object pod)
)


(script continuous ff45_resupply0
	(sleep_forever)
	(sleep (random_range 0 15))
	
	; Launch the pod
	(ff45_resupply_launch resupply0 2.25)
)


(script continuous ff45_resupply1
	(sleep_forever)
	(sleep (random_range 0 15))
	
	; Launch the pod
	(ff45_resupply_launch resupply1 3.25)
)


(script continuous ff45_resupply2
	(sleep_forever)
	(sleep (random_range 0 15))
	
	; Launch the pod
	(ff45_resupply_launch resupply2 4.75)
)


(script dormant ff45_weapon_drops
	(sleep_until
		(begin
			(sleep_until (survival_mode_should_drop_weapon))
			
			; Spawn two of the three
			(begin_random_count 2
				(wake ff45_resupply0)
				(wake ff45_resupply1)
				(wake ff45_resupply2)
			)
			
			; Respawn grenades
			(object_create_folder_anew cr_grenades)
			
			false
		)
	)
)


;- Engineers ---------------------------------------------------------------------------------------------------------

(script static void ff45_spawn_engineers
	(if 
		(and
			(survival_mode_scenario_extras_enable)
		 	(= (random_range 0 5) 0)
		)
		(begin
			(ai_place ff_engineers)
		)
	)
)
