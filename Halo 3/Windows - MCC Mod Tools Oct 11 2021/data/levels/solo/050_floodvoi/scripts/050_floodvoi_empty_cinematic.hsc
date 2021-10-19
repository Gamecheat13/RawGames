(global ai obj_arbiter NONE)

(script command_script cs_lb_ins_pod_comm
	(object_create_anew dm_ent_pod_commander)
		(sleep 1)
	(objects_attach dm_ent_pod_commander "pod_attach" (ai_vehicle_get sq_lb_elites/commander) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_commander 1)
	(sleep_until (>= (device_get_position dm_ent_pod_commander) 1) 1)
	
	(objects_detach dm_ent_pod_commander (ai_vehicle_get sq_lb_elites/commander))
	(object_destroy dm_ent_pod_commander)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/commander) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/commander)
		(sleep 60)
	;(cs_action ps_lb/elite_face ai_action_berserk)
)

(script command_script cs_lb_ins_pod_elite01
	(object_create_anew dm_ent_pod_elite01)
		(sleep 1)
	(objects_attach dm_ent_pod_elite01 "pod_attach" (ai_vehicle_get sq_lb_elites/elite01) "pod_attach")
		(sleep 1)
	
	(device_set_position dm_ent_pod_elite01 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite01) 1) 1)
	
	(objects_detach dm_ent_pod_elite01 (ai_vehicle_get sq_lb_elites/elite01))
	(object_destroy dm_ent_pod_elite01)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite01) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite01)
)

(script command_script cs_lb_ins_pod_elite02
	(object_create_anew dm_ent_pod_elite02)
		(sleep 1)
	(objects_attach dm_ent_pod_elite02 "pod_attach" (ai_vehicle_get sq_lb_elites/elite02) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_elite02 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite02) 1) 1)
	
	(objects_detach dm_ent_pod_elite02 (ai_vehicle_get sq_lb_elites/elite02))
	(object_destroy dm_ent_pod_elite02)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite02) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite02)
)

(script command_script cs_lb_ins_pod_elite03
	(object_create_anew dm_ent_pod_elite03)
		(sleep 1)
	(objects_attach dm_ent_pod_elite03 "pod_attach" (ai_vehicle_get sq_lb_elites/elite03) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_elite03 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite03) 1) 1)
	
	(objects_detach dm_ent_pod_elite03 (ai_vehicle_get sq_lb_elites/elite03))
	(object_destroy dm_ent_pod_elite03)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite03) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite03)
)

(script command_script cs_lb_ins_pod_elite04
	(object_create_anew dm_ent_pod_elite04)
		(sleep 1)
	(objects_attach dm_ent_pod_elite04 "pod_attach" (ai_vehicle_get sq_lb_elites/elite04) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_elite04 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite04) 1) 1)
	
	(objects_detach dm_ent_pod_elite04 (ai_vehicle_get sq_lb_elites/elite04))
	(object_destroy dm_ent_pod_elite04)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite04) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite04)
)


(script static void test_fleet_arrival
	(switch_zone_set set_lakebed_b)
	(sleep 90)
	(object_teleport (player0) fl_050pb_chief_teleport)
	(sleep_until
	    (begin
	        (wake ai_lb_elite_ins_pods)
	        (set g_elite_pods TRUE)
        	(sleep 45)
        	
        	(object_create_anew cov_cruiser_01)
        	(object_create_anew cov_cruiser_02)
        	(object_create_anew cov_capital_ship)
        	(object_set_always_active cov_cruiser_01 TRUE)
        	(object_set_always_active cov_cruiser_02 TRUE)
        	(object_set_always_active cov_capital_ship TRUE)
        	(scenery_animation_start cov_capital_ship objects\vehicles\cov_capital_ship\cinematics\perspectives\050pb_elite_fleet\050pb_elite_fleet "050pb_cin_capital_ship1_1")
        	(scenery_animation_start cov_cruiser_01 objects\vehicles\cov_cruiser\cinematics\perspectives\050pb_elite_fleet\050pb_elite_fleet "050pb_cin_cov_cruiser1_1")
        	(scenery_animation_start cov_cruiser_02 objects\vehicles\cov_cruiser\cinematics\perspectives\050pb_elite_fleet\050pb_elite_fleet "050pb_cin_cov_cruiser2_1")
        	
        	(sleep 450)
        	
        	(object_destroy cov_cruiser_01)
        	(object_destroy cov_cruiser_02)
        	(object_destroy cov_capital_ship)
        	
        	(ai_erase_all)
        	(object_destroy_containing "pod")
        	(garbage_collect_unsafe)
        	
        	FALSE
        )
    )
	
)

(global boolean g_elite_pods FALSE)

(script continuous ai_lb_elite_ins_pods
	(sleep_until g_elite_pods 1)
	(begin_random
		(begin (ai_place sq_lb_elites/elite01) (sleep (random_range 5 20)))
		(begin (ai_place sq_lb_elites/elite02) (sleep (random_range 5 20)))
		(begin (ai_place sq_lb_elites/elite03) (sleep (random_range 5 20)))
		(begin (ai_place sq_lb_elites/elite04) (sleep (random_range 5 20)))
	)
	(sleep (random_range 10 20))	
	(ai_place sq_lb_elites/commander)
	(sleep 1)
	(ai_cannot_die gr_lb_elites TRUE)
	(set g_elite_pods FALSE)
)

(script dormant ai_lb_elite_ins_pods
	(sleep_until g_elite_pods 1)
	(begin_random
		(begin (ai_place sq_lb_elites/elite01) (sleep (random_range 5 20)))
		(begin (ai_place sq_lb_elites/elite02) (sleep (random_range 5 20)))
		(begin (ai_place sq_lb_elites/elite03) (sleep (random_range 5 20)))
		(begin (ai_place sq_lb_elites/elite04) (sleep (random_range 5 20)))
	)
	(sleep (random_range 10 20))	
	(ai_place sq_lb_elites/commander)
	(sleep 1)
	(ai_cannot_die gr_lb_elites TRUE)
)

