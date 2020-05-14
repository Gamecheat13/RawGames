; =================================================================================================
; DIRT ROAD
; =================================================================================================
(script static void idi (ins_dirt))
(script static void ins_dirt

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: dirt road"))
	(set g_insertion_index s_insert_idx_dirt)
				
	; Play the intro cinematic	
	(if 
		(or
			(and cinematics (not editor))
			editor_cinematics
		)
			(begin
				(switch_zone_set set_intro_cinematic)
				(f_start_mission 070la_carter)
			)
	)

	; Switch to correct zone set unless "set_all" is loaded 

	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_dirt)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_dirt) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_dirt) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_dirt)"))
			(sleep 1)
		)	
	)

	(f_emile_spawn sq_emile/sp_dirt obj_dirt_hum)
	(wake f_emile_nanny)

	(ai_place sq_mongoose_player_0/sp_dirt_shack)
	(ai_place sq_mongoose_emile/sp_dirt_shack)
	(set v_mongoose_emile (ai_vehicle_get_from_starting_location sq_mongoose_emile/sp_dirt_shack))

	; Teleport
	(object_teleport_to_ai_point player0 ps_dirt_spawn/player0)
	(object_teleport_to_ai_point player1 ps_dirt_spawn/player1)
	(object_teleport_to_ai_point player2 ps_dirt_spawn/player2)
	(object_teleport_to_ai_point player3 ps_dirt_spawn/player3)

	; Bookkeeping
	(f_package_attach)

)

(global short s_goose_idx 0) 
; =================================================================================================
; MONGOOSE
; =================================================================================================
(script static void igo (ins_goose))
(script static void ins_goose

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: goose"))
	(set g_insertion_index s_insert_idx_goose)

	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_dirt)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_dirt) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_dirt) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_dirt)"))
			(sleep 1)
		)	
	)

	; spawn emile
	(f_emile_spawn sq_emile/sp_dirt_shack obj_vehicle_hum)
	(wake f_emile_nanny)

	(ai_place sq_mongoose_player_0/sp_dirt_shack)
	(ai_place sq_mongoose_emile/sp_dirt_shack)
	(set v_mongoose_emile (ai_vehicle_get_from_starting_location sq_mongoose_emile/sp_dirt_shack))

	; Teleport
	(object_teleport_to_ai_point player0 ps_goose_spawn/player0)
	(object_teleport_to_ai_point player1 ps_goose_spawn/player1)
	(object_teleport_to_ai_point player2 ps_goose_spawn/player2)
	(object_teleport_to_ai_point player3 ps_goose_spawn/player3)

	; Bookkeeping
	(set s_goose_idx 0)
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)

)


; =================================================================================================
; SCARAB DROP
; =================================================================================================
(script static void isc (ins_drop))
(script static void ins_drop

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: scarab drop"))
	(set g_insertion_index s_insert_idx_drop)

	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_dirt)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_dirt) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_dirt) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_dirt)"))
			(sleep 1)
		)	
	)

	; Set Up Mongoose and Emile
	(ai_place sq_mongoose_player_0/sp_dirt_bend)
	(f_emile_spawn_vehicle sq_emile/sp_dirt_bend sq_mongoose_emile/sp_dirt_bend obj_vehicle_hum)
	(wake f_emile_nanny)

	(set v_mongoose_emile (ai_vehicle_get_from_starting_location sq_mongoose_emile/sp_dirt_bend))
	(set v_mongoose_player_0 (ai_vehicle_get_from_starting_location sq_mongoose_player_0/sp_dirt_bend))

	(vehicle_load_magic v_mongoose_player_0 "mongoose_d" player0)

	(object_set_velocity v_mongoose_emile 12)
	(object_set_velocity v_mongoose_player_0 12)

	; Teleport
	(object_teleport_to_ai_point player1 ps_drop_spawn/player1)
	(object_teleport_to_ai_point player2 ps_drop_spawn/player2)
	(object_teleport_to_ai_point player3 ps_drop_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)

)

; =================================================================================================
; BLOCKADE
; =================================================================================================
(global boolean b_emile_block FALSE)
(script static void ibl (ins_block))
(script static void ins_block

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: blockade"))
	(set g_insertion_index s_insert_idx_block)
				
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_block)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_block) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_block) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_block)"))
			(sleep 1)
		)	
	)

	; Emile Setup
	(ai_place sq_mongoose_player_0/sp_block_cliff)
	(f_emile_spawn_vehicle sq_emile/sp_block_cliff sq_mongoose_emile/sp_block_cliff obj_vehicle_hum)
	(wake f_emile_nanny)

	(set v_mongoose_emile (ai_vehicle_get_from_starting_location sq_mongoose_emile/sp_block_cliff))
	(set v_mongoose_player_0 (ai_vehicle_get_from_starting_location sq_mongoose_player_0/sp_block_cliff))

	(sleep 10)

	; Teleport
	(object_teleport_to_ai_point player0 ps_block_spawn/player0)
	(object_teleport_to_ai_point player1 ps_block_spawn/player1)
	(object_teleport_to_ai_point player2 ps_block_spawn/player2)
	(object_teleport_to_ai_point player3 ps_block_spawn/player3)

	(vehicle_load_magic v_mongoose_player_0 "mongoose_d" player0)

	;(object_set_velocity v_mongoose_emile 12)
	;(object_set_velocity v_mongoose_player_0 12)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)

)

; =================================================================================================
; CARTER
; =================================================================================================
(script static void ica (ins_carter))
(script static void ins_cave (ins_carter))
(script static void ins_carter

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: cave - carter"))
	(set g_insertion_index s_insert_idx_carter)
				
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_cave)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_cave) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_cave) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_cave)"))
			(sleep 1)
		)	
	)

	; Emile Setup
	(f_emile_spawn sq_emile/sp_carter obj_carter_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_carter_spawn/player0)
	(object_teleport_to_ai_point player1 ps_carter_spawn/player1)
	(object_teleport_to_ai_point player2 ps_carter_spawn/player2)
	(object_teleport_to_ai_point player3 ps_carter_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	
)

; =================================================================================================
; CAVE - Tunnels
; =================================================================================================
(script static void itu (ins_tunnels))
(script static void ins_tunnels

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: cave - tunnels"))
	(set g_insertion_index s_insert_idx_tunnels)
				
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_cave)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_cave) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_cave) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_cave)"))
			(sleep 1)
		)	
	)

	; Emile Setup
	(f_emile_spawn sq_emile/sp_tunnels obj_tunnels_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_tunnels_spawn/player0)
	(object_teleport_to_ai_point player1 ps_tunnels_spawn/player1)
	(object_teleport_to_ai_point player2 ps_tunnels_spawn/player2)
	(object_teleport_to_ai_point player3 ps_tunnels_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)

)


; =================================================================================================
; BONEYARD - Wall
; =================================================================================================
(global boolean b_ins_wall FALSE)
(script static void iwa (ins_wall))
(script static void ibo (ins_wall))
(script static void ins_bone (ins_wall))
(script static void ins_wall

	(set b_ins_wall TRUE)
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: boneyard wall"))
	(set g_insertion_index s_insert_idx_wall)
				
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_bone)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_bone) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_bone) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_bone)"))
			(sleep 1)
		)	
	)

	; Emile Setup
	(f_emile_spawn sq_emile/sp_wall_cave obj_wall_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_wall_spawn/player0)
	(object_teleport_to_ai_point player1 ps_wall_spawn/player1)
	(object_teleport_to_ai_point player2 ps_wall_spawn/player2)
	(object_teleport_to_ai_point player3 ps_wall_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(set s_rain_force 1)
	(set s_music_alpha 1)
	(wake music_alpha)

)


; =================================================================================================
; FACTORY
; =================================================================================================

(global boolean b_factory_ins FALSE)
(script static void ifa (ins_factory))
(script static void ins_factory

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: boneyard factory"))
	(set g_insertion_index s_insert_idx_factory)
	(set b_factory_ins TRUE)

	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_bone)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_bone) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_bone) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_bone)"))
			(sleep 1)
		)	
	)

	; Emile Setup
	(f_emile_spawn sq_emile/sp_factory obj_factory_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_factory_spawn/player0)
	(object_teleport_to_ai_point player1 ps_factory_spawn/player1)
	(object_teleport_to_ai_point player2 ps_factory_spawn/player2)
	(object_teleport_to_ai_point player3 ps_factory_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(soft_ceiling_enable camera_blocker_07 FALSE)
	
)

; =================================================================================================
; CRANE
; =================================================================================================
(script static void icr (ins_crane))
(script static void ism (ins_crane))
(script static void ins_smelt (ins_crane))
(script static void ins_crane

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: smelter - crane"))
	(set g_insertion_index s_insert_idx_crane)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_smelt)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_smelt) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_smelt) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_smelt)"))
			(sleep 1)
		)	
	)
	
	; Emile Setup
	(f_emile_spawn sq_emile/sp_crane obj_crane_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_crane_spawn/player0)
	(object_teleport_to_ai_point player1 ps_crane_spawn/player1)
	(object_teleport_to_ai_point player2 ps_crane_spawn/player2)
	(object_teleport_to_ai_point player3 ps_crane_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(soft_ceiling_enable camera_blocker_07 FALSE)

)


; =================================================================================================
; CATWALK
; =================================================================================================

(script static void ict (ins_catwalk))
(script static void ins_catwalk

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: smelter - catwalk"))
	(set g_insertion_index s_insert_idx_catwalk)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_hall_2)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_hall_2) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_hall_2) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_hall_2)"))
			(sleep 1)
		)	
	)
	
	; Bookkeeping
	(ai_place sq_catwalk_marine_entry_ins)

	; Emile Setup
	(f_emile_spawn sq_emile/sp_catwalk obj_catwalk_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_catwalk_spawn/player0)
	(object_teleport_to_ai_point player1 ps_catwalk_spawn/player1)
	(object_teleport_to_ai_point player2 ps_catwalk_spawn/player2)
	(object_teleport_to_ai_point player3 ps_catwalk_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(soft_ceiling_enable camera_blocker_07 FALSE)
	(soft_ceiling_enable camera_blocker_08 FALSE)

)

; =================================================================================================
; =================================================================================================
; PLATFORM
; =================================================================================================
; =================================================================================================
(global boolean b_ins_platform FALSE)
(script static void ipl (ins_platform))
(script static void ins_platform

	(set b_ins_platform TRUE)
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: big gun - platform"))
	(set g_insertion_index s_insert_idx_platform)
					
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_final_0)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_final_0) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_final_0) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_final_0)"))
			(sleep 1)
		)	
	)
	
	; Emile Setup
	(f_emile_spawn sq_emile/sp_hall_2 obj_platform_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_platform_hall_spawn/player0)
	(object_teleport_to_ai_point player1 ps_platform_hall_spawn/player1)
	(object_teleport_to_ai_point player2 ps_platform_hall_spawn/player2)
	(object_teleport_to_ai_point player3 ps_platform_hall_spawn/player3)
	(object_teleport_to_ai_point o_emile ps_platform_hall_spawn/emile)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(soft_ceiling_enable camera_blocker_07 FALSE)
	(soft_ceiling_enable camera_blocker_08 FALSE)
	(set s_rain_force 8)
	(f_objects_hall_2_create)
	(set s_music_bravo 1)
	(wake music_bravo)

)


; =================================================================================================
; =================================================================================================
; PLATFORM 2
; =================================================================================================
; =================================================================================================
(global boolean b_ins_platform_2 FALSE)
(script static void ipl2 (ins_platform2))
(script static void ins_platform2

	(set b_ins_platform_2 TRUE)
	(set b_ins_platform TRUE)
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: big gun - platform"))
	(set g_insertion_index s_insert_idx_platform)
					
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_final_0)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_final_0) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_final_0) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_final_0)"))
			(sleep 1)
		)	
	)
	
	; Emile Setup
	(f_emile_spawn sq_emile/sp_platform obj_platform_hum)
	(wake f_emile_nanny)

	; Teleport
	(object_teleport_to_ai_point player0 ps_platform_door_spawn/player0)
	(object_teleport_to_ai_point player1 ps_platform_door_spawn/player1)
	(object_teleport_to_ai_point player2 ps_platform_door_spawn/player2)
	(object_teleport_to_ai_point player3 ps_platform_door_spawn/player3)

	; Bookkeeping
	(f_package_attach)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(soft_ceiling_enable camera_blocker_07 FALSE)
	(soft_ceiling_enable camera_blocker_08 FALSE)
	
	(set objcon_platform 40)

)

; =================================================================================================
; =================================================================================================
; ZEALOT
; =================================================================================================
; =================================================================================================

(script static void ize (ins_zealot))
(script static void ins_zealot

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: big gun - zealot"))
	(set g_insertion_index s_insert_idx_zealot)
	(set b_zealot_ready TRUE)
	(set b_cannon_ready TRUE)

	(zone_set_trigger_volume_enable begin_zone_set:set_final_1 FALSE)
	(zone_set_trigger_volume_enable zone_set:set_final_1 FALSE)

	(wake f_platform_cannon_init)

	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_final_2)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_final_2) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_final_2) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_final_2)"))
			(sleep 1)
		)	
	)

	; Teleport
	(object_teleport_to_ai_point player0 ps_zealot_spawn/player0)
	(object_teleport_to_ai_point player1 ps_zealot_spawn/player1)
	(object_teleport_to_ai_point player2 ps_zealot_spawn/player2)
	(object_teleport_to_ai_point player3 ps_zealot_spawn/player3)

	; Bookkeeping
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(soft_ceiling_enable camera_blocker_07 FALSE)
	(soft_ceiling_enable camera_blocker_08 FALSE)

)


; =================================================================================================
; =================================================================================================
; CANNON
; =================================================================================================
; =================================================================================================

(script static void icn (ins_cannon))
(script static void ins_cannon

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(if b_debug (print "::: insertion point: cannon"))
	(set g_insertion_index s_insert_idx_cannon)
	(set b_cannon_ready TRUE)

	(zone_set_trigger_volume_enable begin_zone_set:set_final_1 FALSE)
	(zone_set_trigger_volume_enable zone_set:set_final_1 FALSE)

	(wake f_platform_cannon_init)
	(wake f_platform_pillar)

	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_set_all)
		(begin
			(switch_zone_set set_final_2)
			(sleep 1)
			(if b_debug (print "::: INSERTION: Waiting for (set_final_2) to fully load..."))
			(sleep_until (= (current_zone_set_fully_active) s_set_final_2) 1)
			(if b_debug (print "::: INSERTION: Finished loading (set_final_2)"))
			(sleep 1)
		)	
	)
	
	; Teleport
	(object_teleport_to_ai_point player0 ps_cannon_spawn/player0)
	(object_teleport_to_ai_point player1 ps_cannon_spawn/player1)
	(object_teleport_to_ai_point player2 ps_cannon_spawn/player2)
	(object_teleport_to_ai_point player3 ps_cannon_spawn/player3)

	; Bookkeeping
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	(soft_ceiling_enable camera_blocker_06 FALSE)
	(soft_ceiling_enable camera_blocker_07 FALSE)
	(soft_ceiling_enable camera_blocker_08 FALSE)

)