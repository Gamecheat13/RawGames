(script static void test_halls
	(fade_out 0 0 0 0)
	(sleep 1)
	(player_enable_input false)
	(print "switching bsp...")
	(sleep 15)
	(switch_bsp 1)
	(print "teleporting players...")
	(object_teleport (player0) halls)
;	(object_teleport (player1) cov_defense_b)
	(fade_in 0 0 0 60)
;	(print "erasing ai...")
;	(ai_erase_all)
;	(sleep 5)
;	(print "initializing area scripts...")
;	(wake enc_cov_defense)
	(sleep 10)
	(player_enable_input true)
)

(script static void test_jails
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) jails0_tele)
	(object_teleport (player1) jails1_tele)

	(sleep_until (volume_test_objects tv_jails (players)) 5)
	(wake enc_jails)
)

(script static void test_corridors_b
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) corrb0_tele)
	(object_teleport (player1) corrb1_tele)

	(sleep 90)
	(wake enc_corridors_b)
	
	(sleep_until (volume_test_objects tv_tower_a_ext (players)) 5)
	(wake enc_tower_a_ext)

	(sleep_until (volume_test_objects tv_gardens_a (players)) 5)
	(wake enc_gardens_a)

	(sleep_until (volume_test_objects tv_mid_tower (players)) 5)
	(wake enc_mid_tower)

	(sleep_until (volume_test_objects tv_gardens_b (players)) 5)
	(wake enc_gardens_b)

	(sleep_until (volume_test_objects tv_tower_b_ext (players)) 5)
	(wake enc_tower_b_ext)

	(sleep_until (volume_test_objects tv_mausoleum_ext (players)) 5)
	(wake enc_mausoleum_ext)

	(sleep_until (volume_test_objects tv_mausoleum (players)) 5)
	(wake enc_mausoleum)

)

(script static void test_gardens
	(fade_out 0 0 0 0)
	(sleep 1)
	(player_enable_input false)
	(print "switching bsp...")
	(sleep 15)
	(switch_bsp 3)
	(print "teleporting players...")
	(object_teleport (player0) garden)
;	(object_teleport (player1) cov_defense_b)
	(fade_in 0 0 0 60)
;	(print "erasing ai...")
;	(ai_erase_all)
;	(sleep 5)
;	(print "initializing area scripts...")
;	(wake enc_cov_defense)
	(sleep 10)
	(player_enable_input true)
)

(script static void test_mausoleum
	(fade_out 0 0 0 0)
	(sleep 1)
	(player_enable_input false)
	(print "switching bsp...")
	(sleep 15)
	(switch_bsp 4)
	(print "teleporting players...")
	(object_teleport (player0) mausoleum)
;	(object_teleport (player1) cov_defense_b)
	(fade_in 0 0 0 60)
;	(print "erasing ai...")
;	(ai_erase_all)
;	(sleep 5)
;	(print "initializing area scripts...")
;	(wake enc_cov_defense)
	(sleep 10)
	(player_enable_input true)
)

