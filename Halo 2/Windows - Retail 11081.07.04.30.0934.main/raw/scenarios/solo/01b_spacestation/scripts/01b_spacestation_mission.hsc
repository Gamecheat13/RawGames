;	01b_SPACESTATION Mission Script


;=================================
;======== Globals =========
;=================================
	(global short seconds 30)

	(global boolean mark_1st_waves_end FALSE)
	(global boolean mark_bomb2_objective FALSE)
	(global boolean mark_1st_blast FALSE)
	(global short timer_flavor 0)
	(global short global_flavor_delay (* 20 seconds))

	(global boolean mark_flavor_disable FALSE)
	(global boolean mark_flavor_vacuum FALSE)
	(global boolean mark_flavor_brace FALSE)
	(global boolean mark_flavor_gun FALSE)
	(global boolean mark_flavor_dck FALSE)
	(global boolean mark_flavor_trm1 FALSE)
	(global boolean mark_flavor_atr1 FALSE)
	(global boolean mark_flavor_bay2 FALSE)
	(global boolean mark_flavor_bay1 FALSE)
	(global boolean mark_flavor_atr2 FALSE)
	(global boolean mark_flavor_1st FALSE)
	(global boolean mark_flavor_board FALSE)
	(global boolean mark_flavor_bomb FALSE)
	(global boolean mark_flavor_init FALSE)
	(global boolean mark_flavor_megg FALSE)
	(global boolean mark_flavor_safe_cycle FALSE)
	(global short counter_flavor_brace 0)
	(global short counter_flavor_gun 0)
	(global short counter_flavor_dck 0)
	(global short counter_flavor_atr2 0)
	(global short counter_flavor_atr1 0)
	(global short counter_flavor_1st 0)
	(global short counter_flavor_init 0)
	(global short counter_flavor_board_safe 0)
	(global short counter_flavor_board 0)
	(global short counter_flavor_bomb_safe 0)
	(global short counter_flavor_bomb 0)
	
(script dormant megg_check
	(if (not (difficulty_legendary)) (sleep_forever))
	(if (game_is_cooperative) (sleep_forever))
	(if (not (ice_cream_flavor_available 3)) (sleep_forever))
	(sleep_until
		(cond
			((< (object_get_shield (player0)) 1)			(begin
														(print "oops")
														(sleep_forever)
														FALSE
													))
			(mark_flavor_gun							(begin
														(set mark_flavor_megg TRUE)
														TRUE
													))
		)
	1)
)

(script dormant ice_cream_check
	(if (not (difficulty_legendary)) (sleep_forever))
	(object_create yorick)
	(sleep_until
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	1)
	(ice_cream_flavor_stock 3)
	(print "blam")
)

;========== Checkpoint Scripts ==========
(script static void save_cutscene
	(data_mine_set_mission_segment "01b_cutscene")
)

(script static void save_1st_start
	(game_save)
	(data_mine_set_mission_segment "01b_1st_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_1st_wv4
	(game_save)
	(data_mine_set_mission_segment "01b_1st_wv4")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_1st_wv5_end
	(game_save)
	(data_mine_set_mission_segment "01b_1st_wv5_end")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_atr2_start
	(game_save)
	(data_mine_set_mission_segment "01b_atr2_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_atr2_mid
	(game_save)
	(data_mine_set_mission_segment "01b_atr2_mid")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_bay1_start
	(game_save)
	(data_mine_set_mission_segment "01b_bay1_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_bay1_mid
	(game_save)
	(data_mine_set_mission_segment "01b_bay1_mid")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_bay2_start
	(game_save)
	(data_mine_set_mission_segment "01b_bay2_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script dormant save_bay2_retreat
	(sleep_until (volume_test_objects tv_bay2_hall (players)))
	(game_save)
	(data_mine_set_mission_segment "01b_bay2_retreat")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_bay2_mid
	(game_save)
	(data_mine_set_mission_segment "01b_bay2_mid")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script dormant save_bay2_fnl
	(sleep_until (= (ai_living_count bay2_cov_fnl) 0) 1)
	(game_save)
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)
	

(script dormant save_arm_start
	(sleep_until (= (ai_living_count arm_cov_stl) 0) 1)
	(game_save)
	(data_mine_set_mission_segment "01b_arm_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script dormant save_atr1_start
	(game_save)
	(data_mine_set_mission_segment "01b_atr1_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))

	(sleep_until
		(and
			(<= (ai_living_count atr1_cov_fbalcony) 1)
			(<= (ai_living_count atr1_cov_bbalcony) 1)
			(volume_test_objects tv_arm_save (players))
		)
	1)
	(game_save)
	(set timer_flavor (max timer_flavor (* 10 seconds)))

	(sleep_until
		(and
			(= (ai_living_count atr1_cov_fbalcony) 0)
			(= (ai_living_count atr1_cov_bbalcony) 0)
			(= (ai_living_count atr1_cov_sec_front) 0)
			(volume_test_objects tv_arm_save (players))
		)
	1)
	(game_save)
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_trm1_start
	(game_save)
	(data_mine_set_mission_segment "01b_trm1_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_dck_start
	(game_save)
	(data_mine_set_mission_segment "01b_dck_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_elv_start
	(game_save)
	(data_mine_set_mission_segment "01b_elv_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_lvr_start
	(game_save)
	(data_mine_set_mission_segment "01b_lvr_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

(script static void save_gun_start
	(game_save)
	(data_mine_set_mission_segment "01b_gun_start")
	(set timer_flavor (max timer_flavor (* 10 seconds)))
)

;=================================
;======== Flavor Scripts =========
;=================================


(script dormant title_1st
	(cinematic_show_letterbox true)
	(hud_cinematic_fade 0 0.5)
	(sleep 30)
	(cinematic_set_title title_1st)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script dormant title_bay2
	(cinematic_show_letterbox true)
	(hud_cinematic_fade 0 0.5)
	(sleep 30)
	(cinematic_set_title title_bay2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script dormant title_dck
	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_06 NONE 1); backrhodes
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_dck)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script dormant title_gun
	(cinematic_show_letterbox true)
	(hud_cinematic_fade 0 0.5)
	(sleep 30)
	(cinematic_set_title title_gun)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script static short timer_flavor_set
	(random_range (* 15 seconds) (* 30 seconds))
)


(script static short timer_flavor_set_long
	(random_range (* 45 seconds) (* 60 seconds))
)

(script static void flavor_stop
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2300_lhd);"Brace for impact!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2310_lhd);"All hands! Brace for impact!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2320_lhd);"Hang on, everyone!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2330_lhd);"Impact! Brace yourselves!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2100_lhd);"Alert! Boarders in port dry dock!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2250_lhd);"Fire-team to terminal 2!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2220_lhd);"Fire-teams to habitat delta!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2190_lhd);"Hostiles have taken security station 1!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2170_lhd);"I need a squad in habitat delta!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2060_lhd);"Alert! Hostiles have breached the port MAC bay!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2080_lhd);"We've got boarders in the port Pelican bay!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2160_lhd);"Boarders in habitat alpha!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2230_lhd);"I need a squad in habitat alpha ASAP!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2210_lhd);"Quick-response teams to security station 3!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2030_lhd);"Seal pressure-doors!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2000_lhd);"All hands: report to battle stations!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2010_lhd);"Alert: boarders inbound!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2400_lhd);"Paging Meg.  Please come to the red courtesy phone.  Meg to the red courtesy phone, please."
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_0570_cor);"There isn't much time, Chief! Hurry!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2580_cor);"Chief!  We don't have much time!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2590_cor);"Not a lot of time on the clock, Chief!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2600_cor);"Where are you? The bomb is right here!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2610_cor);"Clock's ticking, Chief! Get down here!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2630_cor);"Chief! Over here! Next to the bomb!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2640_cor);"Ask yourself this question: is what I'm doing right now helping Cortana keep this station from blowing into tiny, tiny bits?"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2650_cor);"Just a friendly reminder…bomb!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2660_cor);"If this thing goes off...I'm never talking to you again."
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2340_lhd);"All non-combat personnel to pressure-zones!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2350_lhd);"All hands to pressure-zones!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2360_lhd);"All non-combat personnel report to evacuation-stations!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2370_lhd);"All hands report to evacuation-stations!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2380_lhd);"All hands: we are abandoning the station!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2390_lhd);"All personnel: prepare to abandon station!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2480_lhd);"Good work, Chief! Now push them back to their boarding craft!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2490_lhd);"Find the boarders' point-of-entry, Chief! Cut them off at the source!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2500_lhd);"Chief? If we don't take out their boarding craft, they'll just keep sending reinforcements!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2510_lhd);"Focus on the boarding craft, Chief! The Marines can handle the rest!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2520_lhd);"There are more boarding-craft in your area, Chief!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2530_lhd);"Chief? I'm showing active boarding craft nearby. Find them!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2540_lhd);"Take out the remaining boarding craft, Chief!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2200_lhd);"Security station 4 is under attack!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2110_lhd);"Boarders in section 7!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2120_lhd);"Fire teams: boarders in section 2!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2130_lhd);"Attention: we have boarders in section 3!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2240_lhd);"Fire-team to tram terminal 1!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2140_lhd);"Boarders have breached the communications-deck!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2260_lhd);"Quick-response teams to the communications deck!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2150_lhd);"Alert: we have hostiles on the command-deck!"										
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2010_lhd);"Alert: boarders inbound!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2000_lhd);"All hands: report to battle stations!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2020_lhd);"This is not a drill! I repeat: this is not a drill!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2030_lhd);"Seal pressure-doors!"
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_2040_lhd);"Open weapons-lockers!"
)

(script dormant flavor_mission
	(sleep_until
		(cond
			(mark_flavor_disable	(begin
									(flavor_stop)
									(ai_dialogue_enable 0)
									(sleep_until (not mark_flavor_disable) 1)
									(sleep (* 5 seconds))
									(ai_dialogue_enable 1)
									(set timer_flavor (max timer_flavor (* 5 seconds)))
									FALSE
								))
			(mark_flavor_vacuum		FALSE)
			((> timer_flavor 0)		(begin
									(set timer_flavor (- timer_flavor 1))
									FALSE
								))
			(mark_flavor_brace		(begin
									(cond
										((= counter_flavor_brace 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2300_lhd NONE 1 ""));"Brace for impact!"
										((= counter_flavor_brace 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2310_lhd NONE 1 ""));"All hands! Brace for impact!"
										((= counter_flavor_brace 2)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2320_lhd NONE 1 ""));"Hang on, everyone!"
										((= counter_flavor_brace 3)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2330_lhd NONE 1 ""));"Impact! Brace yourselves!"
										(TRUE					(set counter_flavor_brace 0))
									)
									(sleep (random_range (* 3 seconds) (* 7 seconds)))
									(damage_players effects\scenarios\objects\solo\spacestation\boarding_craft_shake)
									(print "KLANG!")
									(sound_impulse_start sound\ambience\spacestation\docking_clangs\docking_stereo NONE 1)
									(sleep (sound_impulse_language_time sound\ambience\spacestation\docking_clangs\docking_stereo))
									(set counter_flavor_brace (+ counter_flavor_brace 1))
									(set timer_flavor (timer_flavor_set))
									(set mark_flavor_brace FALSE)
									FALSE
								))
			(mark_flavor_dck		(begin
									(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2100_lhd NONE 1 "");"Alert! Boarders in port dry dock!"
									(set mark_flavor_dck FALSE)
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(mark_flavor_trm1		(begin
									(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2250_lhd NONE 1 "");"Fire-team to terminal 2!"
									(set mark_flavor_trm1 FALSE)
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(mark_flavor_atr1		(begin
									(cond
										((= counter_flavor_atr1 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2220_lhd NONE 1 ""));"Fire-teams to habitat delta!"
										((= counter_flavor_atr1 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2190_lhd NONE 1 ""));"Hostiles have taken security station 1!"
										((= counter_flavor_atr1 2)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2170_lhd NONE 1 ""));"I need a squad in habitat delta!"
										(TRUE					(set mark_flavor_atr1 FALSE))
									)
									(set counter_flavor_atr1 (+ counter_flavor_atr1 1))
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(mark_flavor_bay2		(begin
									(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2060_lhd NONE 1 "");"Alert! Hostiles have breached the port MAC bay!"
									(set mark_flavor_bay2 FALSE)
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(mark_flavor_bay1		(begin
									(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2080_lhd NONE 1 "");"We've got boarders in the port Pelican bay!"
									(set mark_flavor_bay1 FALSE)
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(mark_flavor_atr2		(begin
									(cond
										((= counter_flavor_atr2 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2160_lhd NONE 1 ""));"Boarders in habitat alpha!"
										((= counter_flavor_atr2 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2230_lhd NONE 1 ""));"I need a squad in habitat alpha ASAP!"
										((= counter_flavor_atr2 2)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2210_lhd NONE 1 ""));"Quick-response teams to security station 3!"
										((= counter_flavor_atr2 3)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2030_lhd NONE 1 ""));"Seal pressure-doors!"
										(TRUE	(set mark_flavor_atr2 FALSE))
									)
									(set counter_flavor_atr2 (+ counter_flavor_atr2 1))
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(mark_flavor_1st		(begin
									(cond
										((= counter_flavor_1st 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2000_lhd NONE 1 ""));"All hands: report to battle stations!"
										((= counter_flavor_1st 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2010_lhd NONE 1 ""));"Alert: boarders inbound!"
										(TRUE					(set mark_flavor_1st FALSE))
									)
									(set counter_flavor_1st (+ counter_flavor_1st 1))
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(mark_flavor_megg		(begin
									(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2400_lhd NONE 1 "");"Paging Meg.  Please come to the red courtesy phone.  Meg to the red courtesy phone, please."
									(set mark_flavor_megg FALSE)
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			((and
				mark_flavor_bomb
				(game_safe_to_save)
			)					(begin
									(cond
										((not mark_flavor_safe_cycle)		(set mark_flavor_safe_cycle TRUE))
										((= counter_flavor_bomb_safe 0)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0570_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"There isn't much time, Chief! Hurry!"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0570_cor NONE 1 "radio_default");"There isn't much time, Chief! Hurry!"
;											)
										)
										((= counter_flavor_bomb_safe 1)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2580_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"Chief!  We don't have much time!"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2580_cor NONE 1 "radio_default");"Chief!  We don't have much time!"
;											)
										)
										((= counter_flavor_bomb_safe 2)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2590_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"Not a lot of time on the clock, Chief!"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2590_cor NONE 1 "radio_default");"Not a lot of time on the clock, Chief!"
;											)
										)
										((= counter_flavor_bomb_safe 3)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2600_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"Where are you? The bomb is right here!"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2600_cor NONE 1 "radio_default");"Where are you? The bomb is right here!"
;											)
										)
										((= counter_flavor_bomb_safe 4)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2610_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"Clock's ticking, Chief! Get down here!"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2610_cor NONE 1 "radio_default");"Clock's ticking, Chief! Get down here!"
;											)
										)
										((= counter_flavor_bomb_safe 5)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2630_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"Chief! Over here! Next to the bomb!"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2630_cor NONE 1 "radio_default");"Chief! Over here! Next to the bomb!"
;											)
										)
										((= counter_flavor_bomb_safe 6)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2640_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"Ask yourself this question: is what I'm doing right now helping Cortana keep this station from blowing into tiny, tiny bits?"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2640_cor NONE 1 "radio_default");"Ask yourself this question: is what I'm doing right now helping Cortana keep this station from blowing into tiny, tiny bits?"
;											)
										)
										((= counter_flavor_bomb_safe 7)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2650_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"Just a friendly reminder…bomb!"
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2650_cor NONE 1 "radio_default");"Just a friendly reminder…bomb!"
;											)
										)
										((= counter_flavor_bomb_safe 8)
;											(if (> (ai_living_count gun_cortana) 0)
;												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2660_cor (list_get (ai_get_object gun_cortana) 1) 1 "radio_3d");"If this thing goes off...I'm never talking to you again."
												(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2660_cor NONE 1 "radio_default");"If this thing goes off...I'm never talking to you again."
;											)
										)
										(TRUE						(set counter_flavor_bomb_safe 0))
									)
									(set counter_flavor_bomb_safe (+ counter_flavor_bomb_safe 1))
									(set timer_flavor (timer_flavor_set_long))
									FALSE
								))
			(mark_flavor_bomb		(begin
									(cond
										((= counter_flavor_bomb 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2340_lhd NONE 1 ""));"All non-combat personnel to pressure-zones!"
										((= counter_flavor_bomb 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2350_lhd NONE 1 ""));"All hands to pressure-zones!"
										((= counter_flavor_bomb 2)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2360_lhd NONE 1 ""));"All non-combat personnel report to evacuation-stations!"
										((= counter_flavor_bomb 3)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2370_lhd NONE 1 ""));"All hands report to evacuation-stations!"
										((= counter_flavor_bomb 4)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2380_lhd NONE 1 ""));"All hands: we are abandoning the station!"
										((= counter_flavor_bomb 5)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2390_lhd NONE 1 ""));"All personnel: prepare to abandon station!"
										(TRUE					(set mark_flavor_bomb FALSE))
									)
									(set counter_flavor_bomb (+ counter_flavor_bomb 1))
									(set timer_flavor (timer_flavor_set))
									(set mark_flavor_safe_cycle FALSE)
									FALSE
								))
			((and
				mark_flavor_board
				(game_safe_to_save)
			)					(begin
									(cond
										((not mark_flavor_safe_cycle)		(set mark_flavor_safe_cycle TRUE))
										((= counter_flavor_board_safe 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2480_lhd NONE 1 "radio_default"));"Good work, Chief! Now push them back to their boarding craft!"
										((= counter_flavor_board_safe 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2490_lhd NONE 1 "radio_default"));"Find the boarders' point-of-entry, Chief! Cut them off at the source!"
										((= counter_flavor_board_safe 2)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2500_lhd NONE 1 "radio_default"));"Chief? If we don't take out their boarding craft, they'll just keep sending reinforcements!"
										((= counter_flavor_board_safe 3)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2510_lhd NONE 1 "radio_default"));"Focus on the boarding craft, Chief! The Marines can handle the rest!"
										((= counter_flavor_board_safe 4)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2520_lhd NONE 1 "radio_default"));"There are more boarding-craft in your area, Chief!"
										((= counter_flavor_board_safe 5)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2530_lhd NONE 1 "radio_default"));"Chief? I'm showing active boarding craft nearby. Find them!"
										((= counter_flavor_board_safe 6)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2540_lhd NONE 1 "radio_default"));"Take out the remaining boarding craft, Chief!"
										(TRUE						(set counter_flavor_board_safe 0))
									)
									(set counter_flavor_board_safe (+ counter_flavor_board_safe 1))
									(set timer_flavor (timer_flavor_set_long))
									FALSE
								))
			(mark_flavor_board		(begin
									(cond
										((= counter_flavor_board 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2200_lhd NONE 1 ""));"Security station 4 is under attack!"
										((= counter_flavor_board 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2110_lhd NONE 1 ""));"Boarders in section 7!"
										((= counter_flavor_board 2)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2120_lhd NONE 1 ""));"Fire teams: boarders in section 2!"
										((= counter_flavor_board 3)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2130_lhd NONE 1 ""));"Attention: we have boarders in section 3!"
										((= counter_flavor_board 4)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2240_lhd NONE 1 ""));"Fire-team to tram terminal 1!"
										((= counter_flavor_board 5)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2140_lhd NONE 1 ""));"Boarders have breached the communications-deck!"
										((= counter_flavor_board 6)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2260_lhd NONE 1 ""));"Quick-response teams to the communications deck!"
										((= counter_flavor_board 7)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2150_lhd NONE 1 ""));"Alert: we have hostiles on the command-deck!"										
										(TRUE					(set mark_flavor_board FALSE))
									)
									(set counter_flavor_board (+ counter_flavor_board 1))
									(set timer_flavor (timer_flavor_set))
									(set mark_flavor_safe_cycle FALSE)
									FALSE
								))
			(mark_flavor_init		(begin
									(cond
										((= counter_flavor_init 0)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2010_lhd NONE 1 ""));"Alert: boarders inbound!"
										((= counter_flavor_init 1)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2000_lhd NONE 1 ""));"All hands: report to battle stations!"
										((= counter_flavor_init 2)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2020_lhd NONE 1 ""));"This is not a drill! I repeat: this is not a drill!"
										((= counter_flavor_init 3)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2030_lhd NONE 1 ""));"Seal pressure-doors!"
										((= counter_flavor_init 4)	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_2040_lhd NONE 1 ""));"Open weapons-lockers!"
										(TRUE					(set mark_flavor_init FALSE))
									)
									(set counter_flavor_init (+ counter_flavor_init 1))
									(set timer_flavor (timer_flavor_set))
									FALSE
								))
			(TRUE				FALSE)
		)
	1)
)

;=================================
;======== Command Scripts =========
;=================================
(script command_script cs_clear
	(sleep 1)
)

;=================================
;========== 1st Scripts ==========
;=================================
(script command_script cs_1st_hichief
	(cs_approach_player 1.5 10 10)
)

(script command_script cs_weapons
	(sleep (random_range 90 180))
)

(script dormant 1st_tram
	(pvs_set_object tram)
	(object_create_anew 1st_tram_wall_1)
	(object_create_anew 1st_tram_wall_2)
	(device_set_position_immediate tram 1)
	(device_set_position_immediate 1st_door_tram 1)
	(sleep 1)
	(pvs_clear)
	(ai_place 1st_hum_tram)
	(object_set_permutation (ai_get_object 1st_hum_johnson) "helmet" "")
	(sleep 30)
	(device_set_position tram 0)
	(sleep 360)
	(device_set_position 1st_door_tram 0)
	(sleep 90)
	(ai_erase 1st_hum_tram)
	(object_destroy 1st_tram_wall_1)
	(object_destroy 1st_tram_wall_2)
	(object_destroy tram)
)
	
(script command_script cs_1st_fieldoffire
	(cs_aim_object 1 1st_door_blast)
	(sleep_forever)
)

(script command_script cs_1st_johnson_deploy
	(cs_face_object 1 1st_door_blast)
	(sleep 60)
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\marine\marine" "combat:missile:point" true)

	(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
     (sleep 30)
     (cs_deploy_turret 1st_turrets/1st_turrets_balcony)
)

(script static void 1st_malta
	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_01 NONE 1); spooky2_short
	(sleep 30)
	(print "How's it going, Malta?")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0080_jon (ai_get_object 1st_hum_johnson) 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0080_jon))
	(sleep 7)

	(print "Standby...")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0090_mm1 NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0090_mm1))

	(sound_impulse_start_effect sound\ambience\spacestation\docking_clangs\docking_mono NONE 1 "radio_default")

	(sleep 5)
	(print "They're latched!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0100_mm1 NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0100_mm1))

	(print "(grunts and snarls)")
;	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0110_gjc NONE 1)
;	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0110_gjc))

	(print "Check your targets, watch the crossfire!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0120_mm1 NONE 1 "radio_default")
	(sleep (- (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0120_mm1) 60))

	(object_create_anew 1st_craft)
	(device_set_position_immediate 1st_craft 1)
	(device_set_position 1st_craft 0)

	(sleep 65)

	(print "They're in standard formation: little bastards up front, big ones in back. Good luck, Cairo!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0130_mm1 NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0130_mm1))

	(sleep_until (<= (device_get_position 1st_craft) 0.1) 1)
	(print "KLANG!")
	(damage_players effects\scenarios\objects\solo\spacestation\boarding_craft_shake)
	(sound_impulse_start sound\ambience\spacestation\docking_clangs\docking_stereo NONE 1)
	(sleep (sound_impulse_language_time sound\ambience\spacestation\docking_clangs\docking_stereo))
	(sound_looping_start sound\ambience\spacestation\ss_behind_bulkhead\ss_behind_bulkhead 1st_door_blast 1)
)


(script dormant 1st_waves
	(effect_new_on_object_marker effects\scenarios\solo\spacestation\door_charging 1st_door_blast "")
	(sleep 240)

	(object_type_predict "objects\characters\elite\elite")
	(object_type_predict "objects\characters\grunt\grunt")

	(sleep 30)

	(ai_place 1st_cov_wv1)
	(sleep 30)

	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion 1st_blast_flag_1)
	(sound_impulse_start sound\visual_effects\explosion_medium_metal_bits 1st_door_blast 1)
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion 1st_blast_flag_2)

	(sleep 1)
	(sound_looping_stop sound\ambience\spacestation\ss_behind_bulkhead\ss_behind_bulkhead)
	(object_damage_damage_section 1st_door_blast main 1)
	(sleep 3)
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion 1st_blast_flag_1)
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion 1st_blast_flag_2)

	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_02 NONE 1)
	(cs_run_command_script 1st_hum cs_clear)
	(sleep 2)
	(set mark_1st_blast TRUE)

	(sleep_until (< (ai_living_count 1st_cov) 2) 10 300)
	(sleep_until
		(or
			(= (ai_living_count 1st_cov) 0)
			(< (ai_fighting_count 1st_cov) 2)
		)
	10)

	(ai_place 1st_cov_wv2)
	(sleep_until (< (ai_living_count 1st_cov) 2) 10 300)
	(sleep_until
		(or
			(= (ai_living_count 1st_cov) 0)
			(< (ai_fighting_count 1st_cov) 2)
		)
	10)

	(ai_place 1st_cov_wv3)
	(object_destroy 1st_door_top)	
	(sleep_until (< (ai_living_count 1st_cov) 2) 10 300)
	(sleep_until
		(or
			(= (ai_living_count 1st_cov) 0)
			(< (ai_fighting_count 1st_cov) 2)
		)
	10)
;	(sleep_until (not (objects_can_see_flag (players) 1st_2nd_flag 40)) 1)
	(save_1st_wv4)
	(sleep 60)
	(ai_place 1st_cov_wv4)
	(sleep_until (< (ai_living_count 1st_cov) 2) 10 300)

;	(sleep_until (not (objects_can_see_flag (players) 1st_2nd_flag 40)) 1)
	(sleep_until
		(or
			(= (ai_living_count 1st_cov) 0)
			(< (ai_fighting_count 1st_cov) 2)
		)
	10)

	(set mark_1st_waves_end TRUE)
	(save_1st_wv5_end)
;	(ai_place 1st_cov_wv5)
)

(script static boolean 1st_waves_end
	(if mark_1st_waves_end TRUE FALSE)
)

(script dormant 1st_mission
	(print "1st")
	(set mark_flavor_init TRUE)
	(ai_place 1st_hum)
	(ai_cannot_die 1st_hum_johnson 1)

	(sleep_until (volume_test_objects tv_1st_hallb (players)) 10)
	(ai_set_orders 1st_hum 1st_hum_halla)
	(device_set_position bigrack_bsp0a_5 1)
	(sleep 15)
	(device_set_position bigrack_bsp0a_6 1)

	(sleep_until (volume_test_objects tv_1st_halla (players)) 10)
	(ai_set_orders 1st_hum_floor 1st_hum_floor)
	(ai_set_orders 1st_hum_balcony 1st_hum_balcony)
	(ai_set_orders 1st_hum_johnson 1st_hum_balcony_stairs)
	(set mark_flavor_disable TRUE)
	(1st_malta)

	(sleep_until (volume_test_objects tv_1st_all (players)) 10)

;	(print "Everybody be cool!")
;	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0150_jon (ai_get_object 1st_hum_johnson) 1)
;	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0150_jon))

	(cs_run_command_script 1st_hum_johnson cs_1st_johnson_deploy)
	(sleep 45)

	(print "Field of fire on that bulkhead!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0070_jon (ai_get_object 1st_hum_johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0070_jon))
	(cs_queue_command_script 1st_hum cs_1st_fieldoffire)

	(sleep 30)
	(wake title_1st)
	(sleep 30)
	(save_1st_start)

	(wake 1st_waves)

	(print "Soon as that door opens...")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0180_jon (ai_get_object 1st_hum_johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0180_jon))

	(print "Let 'em have it.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0190_jon (ai_get_object 1st_hum_johnson) 1)
	(objectives_show_up_to 0)

	(sleep 30)
	(set mark_flavor_disable FALSE)

;	(game_can_use_flashlights 1)
	(wake megg_check)

	(sleep_until
		(and
			mark_1st_blast
			(volume_test_objects tv_1st_exit (players))
		)
	10)
	(sleep_forever 1st_waves)
	(set mark_1st_waves_end TRUE)

	(set mark_flavor_init FALSE)
	(set mark_flavor_atr2 TRUE)
	(set mark_flavor_board TRUE)

	(ai_place 1st_cov_hall)
	(ai_place 1st_hum_stairs)

	(sleep_until (volume_test_objects tv_atr2_security_r (players)) 1)
	(ai_disposable 1st_cov 1)

	(sleep_until (volume_test_objects tv_atr2_lstair (players)) 1)
	(ai_disposable 1st_hum 1)

	(sleep_until (= (structure_bsp_index) 2) 10)
	(ai_erase 1st_cov)
)
;==================================
;========== atr2 Scripts ==========
;==================================
(script dormant atr2_mission
	(print "atr2")

	(sleep_until (volume_test_objects tv_atr2_security_r (players)) 1)
	(sound_looping_stop scenarios\solo\01b_spacestation\01b_music\01b_02)
	(save_atr2_start)
	(ai_disposable 1st_cov 1)
	(ai_place atr2_hum) (print "Hum bunker behind window")
	(sleep 5)
	(ai_place atr2_cov_floor) (print "Covenant harass below")

	(sleep_until
		(or
			(volume_test_objects tv_atr2_lstair (players))
			(volume_test_objects tv_atr2_floor_front (players))
			(< (ai_strength atr2_cov) 0.35)
		)
	1)
	(print "Cov assault left stair")
	(print "Hum repel assault")
	(print "Cov guard hall")
	(if (< (ai_living_count atr2_cov) 7) (ai_place atr2_cov_lstair) (begin (ai_place atr2_cov_lstair_elt) (ai_place atr2_cov_lstair_rear_elt)))

	(sleep_until (volume_test_objects tv_atr2_floor_front (players)) 1)
	(set mark_flavor_brace TRUE)

	(print "Hum take atrium floor")
	(ai_place atr2_cov_bbalcony_grt)

	(sleep_until (volume_test_objects tv_atr2_floor_mid (players)) 1)
	(save_atr2_mid)
	(print "Cov retreat to atrium back")
	(print "Cov guard back balcony")
	(print "Cov are reenforced")
	(if (< (ai_living_count atr2_cov) 7) (ai_place atr2_cov_fnl) (ai_place atr2_cov_fnl_elt))
	(if (< (ai_living_count atr2_cov) 7) (ai_place atr2_cov_re))
	(device_set_position atr2_door_re 1)
	(sound_looping_stop scenarios\solo\01b_spacestation\01b_music\01b_01); spooky2_short

	(sleep_until (= (structure_bsp_index) 2) 10)
	(set mark_flavor_atr2 FALSE)
	(set mark_flavor_bay1 TRUE)
	(ai_disposable atr2_cov 1)
	(ai_disposable atr2_hum 1)
	(ai_erase atr2_cov_re)
	(ai_erase atr2_cov_floor)
)

;==================================
;========== bay1 Scripts ==========
;==================================

(script command_script cs_lookat_malta
	(cs_force_combat_status 2)
	(cs_face_object 1 malta)
	(cs_go_to bay1/window 1)
	(sleep_forever)
)

(script static void bay1_malta
	(print "Boarder Effect")
	(object_damage_damage_section malta default 0.4)

	(cs_run_command_script bay1_hum cs_lookat_malta)
	(sleep 120)
	(sleep_until (objects_can_see_object (players) malta 35) 1 120)

	(print "Hey...check it out! The Malta's already driven off its boarders?!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0200_cky (ai_get_object bay1_hum) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0200_cky))

	(sleep_until (objects_can_see_object (players) malta 35) 1 60)
	(print "Malta, what is your status, over?")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0210_cor NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0210_cor))

	(sleep_until (objects_can_see_object (players) malta 35) 1 120)

	(print "I don't believe it! They're retreating! We won!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0220_mm1 NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0220_mm1))

	(sleep_until (objects_can_see_object (players) malta 35) 1 120)
	(print "Explosions!")
	(object_damage_damage_section malta default 0.4)

	(sleep 120)
	(sleep_until (objects_can_see_object (players) malta 35) 1 120)
	(print "BOOM!")
	(object_damage_damage_section malta default 1)
	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_03 NONE 1); borealis

	(sleep 60)

	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0221_cky (ai_get_object bay1_hum) 1)

	(sleep 90)
	(damage_players effects\damage_effects\spacestation_shockwave) 
;	(player_effect_set_max_translation .01 .01 .01)
;	(player_effect_start 1 .25)
;	(sleep 30)
;	(player_effect_stop 3)
)

(script dormant bay1_mission
	(print "bay1")
	(object_create_anew bay1_boarding_door)

	(sleep_until (volume_test_objects tv_bay1_stairs (players)) 1)
	(save_bay1_start)
	(sleep 5)

	(ai_place bay1_hum)
	(ai_place bay1_cov_floor)
	(ai_place bay1_cov_catwalk)
	(print "Hum bunker below")
	(print "Covenant turrets above")
	(print "Covenant infantry below")

	(sleep_until (<= (ai_living_count bay1_cov) 4) 10)
	(if (difficulty_normal) (sleep_until (= (ai_living_count bay1_cov_floor_elt) 0) 10))
	(sleep_until
		(or
			(<= (ai_living_count bay1_cov) 2)
			(<= (ai_fighting_count bay1_cov) 1)
		)
	10)
	(ai_place bay1_cov_wv2)
	(sleep 15)
	(object_destroy bay1_boarding_door)
	(sleep_until
		(and
			(not (volume_test_objects tv_bay1_boarding_tube (players)))
			(not (volume_test_objects tv_bay1_boarding_tube (ai_actors bay1_cov)))
		)
	1)
	(object_create_anew bay1_boarding_door)

	(sleep_until (< (ai_living_count bay1_cov) 4) 10)
	(if (difficulty_normal) (sleep_until (= (ai_living_count bay1_cov_wv2_elt) 0) 10))
	(sleep_until
		(or
			(<= (ai_living_count bay1_cov) 2)
			(<= (ai_fighting_count bay1_cov) 1)
		)
	10)
	(ai_place bay1_cov_wv3)
	(sleep 15)
	(object_destroy bay1_boarding_door)
	(sleep_until
		(and
			(not (volume_test_objects tv_bay1_boarding_tube (players)))
			(not (volume_test_objects tv_bay1_boarding_tube (ai_actors bay1_cov)))
		)
	1)
	(object_create_anew bay1_boarding_door)

	(sleep_until (<= (ai_living_count bay1_cov) 4) 10)
	(if (difficulty_normal) (sleep_until (= (ai_living_count bay1_cov_wv3_elt) 0) 10))
	(sleep_until
		(or
			(<= (ai_living_count bay1_cov) 2)
			(<= (ai_fighting_count bay1_cov) 1)
		)
	10)
	(if
		(not (difficulty_normal))
		(begin
			(ai_place bay1_cov_wv4)
			(sleep 15)
			(object_destroy bay1_boarding_door)
			(sleep_until
				(and
					(not (volume_test_objects tv_bay1_boarding_tube (players)))
					(not (volume_test_objects tv_bay1_boarding_tube (ai_actors bay1_cov)))
				)
			1)
			(object_create_anew bay1_boarding_door)
		)
	)
	(sleep_until (<= (ai_living_count bay1_cov) 4) 10)
	(if
		(difficulty_legendary)
		(begin
			(sleep (* 15 seconds))
			(ai_place bay1_cov_wv5)
			(sleep 15)
			(object_destroy bay1_boarding_door)
			(sleep_until
				(and
					(not (volume_test_objects tv_bay1_boarding_tube (players)))
					(not (volume_test_objects tv_bay1_boarding_tube (ai_actors bay1_cov)))
				)
			1)
			(object_create_anew bay1_boarding_door)
		)
	)
			
	(set mark_flavor_disable TRUE)

	(sleep_until (<= (ai_living_count bay1_cov) 1) 10)
	(sleep_until (<= (ai_living_count bay1_cov) 0) 10 900)
	(sleep_until (<= (ai_fighting_count bay1_cov) 0) 10)
	
	(bay1_malta)
	(save_bay1_mid)
	(cs_run_command_script bay1_hum cs_clear)
	(set mark_flavor_disable FALSE)
;	(sleep 150)

	(set mark_flavor_bay1 FALSE)
	(set mark_flavor_bay2 TRUE)

	(ai_place bay1_cov_fnl)
	(effect_new "effects\objects\weapons\grenade\plasma_grenade\detonation.effect" bay1_blast_flag_1)
	(damage_new "objects\weapons\grenade\plasma_grenade\damage_effects\plasma_grenade_explosion.damage_effect" bay1_blast_flag_1)
	(sleep 2)
	(effect_new "effects\objects\weapons\grenade\plasma_grenade\detonation.effect" bay1_blast_flag_2)
	(damage_new "objects\weapons\grenade\plasma_grenade\damage_effects\plasma_grenade_explosion.damage_effect" bay1_blast_flag_2)
	(object_destroy bay1_door_exit)
	(set mark_flavor_brace TRUE)

	(sleep_until (volume_test_objects tv_bay2_hall (players)) 1)
	(ai_disposable bay1_cov 1)

	(sleep_until (= (structure_bsp_index) 0) 10)
	(ai_erase bay1_cov)
)

;==================================
;========== bay2 Scripts ==========
;==================================
(script command_script cs_lookat_athens
	(cs_force_combat_status 2)
	(cs_face_object 1 athens)
	(cs_go_to bay2/window 1)
	(sleep_forever)
)

(script static void bay2_athens
	(print "Boarder Effect")
	(object_damage_damage_section athens default 0.4)
	(cs_run_command_script bay1_hum cs_lookat_athens)
	(sleep 120)
	(sleep_until (objects_can_see_object (players) athens 25) 1 120)

	(print "Uh-oh. They're leaving the Athens!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0230_cky NONE 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0230_cky))

	(sleep_until (objects_can_see_object (players) athens 25) 1 120)
	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_04 NONE 1); stingers/harphit
	(print "Explosions!")
	(sleep 45)
	(object_damage_damage_section athens default 0.4)

	(sleep_until (objects_can_see_object (players) athens 25) 1 120)
	(print "BOOM!")
	(object_damage_damage_section athens default 1)

	(sleep 90)
	(damage_players effects\damage_effects\spacestation_shockwave) 
;	(player_effect_set_max_translation .01 .01 .01)
;	(player_effect_start 1 .25)
;	(sleep 30)
;	(player_effect_stop 3)

	(print "Cortana, assessment!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0260_lhd NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0260_lhd))

	(print "That explosion came from inside the Athens - same as the Malta. The Covenant must have brought something with them. A bomb.")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0270_cor NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0270_cor))

	(print "Then they sure as hell brought one here. Chief, find it!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0280_lhd NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0280_lhd))

	(objectives_finish_up_to 0)
	(objectives_show_up_to 1)
)

(script dormant bay2_mission
	(print "bay2")
	(object_create_anew bay2_boarding_door)

	(sleep_until (volume_test_objects tv_bay2_hall (players)) 1)
	(save_bay2_start)
	(ai_place bay2_hum)
	(ai_place bay2_cov_floor)
	(ai_place bay2_cov_catwalk)
	(print "Hum bunker below")
	(print "Covenant turrets above")
	(print "Covenant infantry below")

	(sleep_until (<= (ai_living_count bay2_cov) 4) 10)
	(if (difficulty_normal) (sleep_until (= (ai_living_count bay2_cov_floor_elt) 0) 10))
	(sleep_until
		(or
			(<= (ai_living_count bay2_cov) 2)
			(<= (ai_fighting_count bay2_cov) 1)
		)
	10)
	(ai_place bay2_cov_wv2)
	(sleep 15)
	(object_destroy bay2_boarding_door)
	(sleep_until
		(and
			(not (volume_test_objects tv_bay2_boarding_tube (players)))
			(not (volume_test_objects tv_bay2_boarding_tube (ai_actors bay2_cov)))
		)
	1)
	(if (difficulty_normal) (wake save_bay2_retreat))
	(object_create_anew bay2_boarding_door)

	(sleep_until (<= (ai_living_count bay2_cov) 4) 10)
	(if (difficulty_normal) (sleep_until (= (ai_living_count bay2_cov_wv2_elt) 0) 10))
	(sleep_until
		(or
			(<= (ai_living_count bay2_cov) 2)
			(<= (ai_fighting_count bay2_cov) 1)
		)
	10)
	(ai_place bay2_cov_wv3)
	(sleep 15)
	(object_destroy bay2_boarding_door)
	(sleep_until
		(and
			(not (volume_test_objects tv_bay2_boarding_tube (players)))
			(not (volume_test_objects tv_bay2_boarding_tube (ai_actors bay2_cov)))
		)
	1)
	(object_create_anew bay2_boarding_door)

	(sleep_until (<= (ai_living_count bay2_cov) 4) 10)
	(if (difficulty_normal) (sleep_until (= (ai_living_count bay2_cov_wv3_elt) 0) 10))
	(sleep_until
		(or
			(<= (ai_living_count bay2_cov) 2)
			(<= (ai_fighting_count bay2_cov) 1)
		)
	10)
	(if
		(not (difficulty_normal))
		(begin
			(ai_place bay2_cov_wv4)
			(sleep 15)
			(object_destroy bay2_boarding_door)
			(sleep_until
				(and
					(not (volume_test_objects tv_bay2_boarding_tube (players)))
					(not (volume_test_objects tv_bay2_boarding_tube (ai_actors bay2_cov)))
				)
			1)
			(object_create_anew bay2_boarding_door)
		)
	)
	(sleep_until (<= (ai_living_count bay2_cov) 4) 10)
	(if
		(difficulty_legendary)
		(begin
			(sleep (* 10 seconds))
			(ai_place bay2_cov_wv5)
			(sleep 15)
			(object_destroy bay2_boarding_door)
			(sleep_until
				(and
					(not (volume_test_objects tv_bay2_boarding_tube (players)))
					(not (volume_test_objects tv_bay2_boarding_tube (ai_actors bay2_cov)))
				)
			1)
			(object_create_anew bay2_boarding_door)
		)
	)

	(set mark_flavor_disable TRUE)

	(sleep_until (= (ai_living_count bay2_cov_catwalk) 0) 10)
	(sleep_until (<= (ai_living_count bay2_cov) 1) 10)
	(sleep_until (<= (ai_living_count bay2_cov) 0) 10 900)
	(sleep_until (<= (ai_fighting_count bay2_cov) 0) 10)

	(bay2_athens)
	(save_bay2_mid)
	(wake title_bay2)
;	(sleep 180)

	(set mark_flavor_disable FALSE)
	(set mark_flavor_board FALSE)
	(set mark_flavor_bay2 FALSE)
	(set mark_flavor_bomb TRUE)

	(ai_place bay2_cov_fnl)
	(device_operates_automatically_set bay2_door_exit_1 1)
	(device_operates_automatically_set bay2_door_exit_2 1)
	
	(wake save_bay2_fnl)
	
	(sleep_until (= (structure_bsp_index) 0) 1)
	(device_set_position_immediate bay2_door_exit_1 0)
	(device_set_position_immediate bay2_door_exit_2 0)
	(device_operates_automatically_set bay2_door_exit_1 0)
	(device_operates_automatically_set bay2_door_exit_2 0)
	(ai_erase bay2_cov)
	(ai_erase bay2_hum)
	(ai_erase bay1_hum)
)

;==================================
;========== arm Scripts ==========
;==================================
(script command_script cs_arm_guns_grate
	(cs_enable_targeting 1)
	(cs_go_to arm/guns)
	(sleep_forever)
)

(script dormant arm_mission
	(print "arm")
	(sleep 5)
	(ai_place arm_cov_stl)
	(wake save_arm_start)

	(sleep_until (volume_test_objects tv_arm_start (players)) 1)
	(sleep 3)

	(ai_place arm_hum_guns)
	(ai_cannot_die arm_hum_guns 1)
	(ai_place arm_cov_elt)
	(ai_cannot_die arm_cov_elt 1)

	(set mark_flavor_disable TRUE)

	(sleep_until (volume_test_objects tv_arm_stairs (players)) 1)
	(cond
		((and
			(difficulty_legendary)
			(game_is_cooperative)
		)						(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_3400_gun (ai_get_object arm_hum_guns) 1))
		((game_is_cooperative) 		(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_3390_gun (ai_get_object arm_hum_guns) 1))
		((difficulty_legendary) 		(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_3420_gun (ai_get_object arm_hum_guns) 1))
		((difficulty_heroic) 		(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_3410_gun (ai_get_object arm_hum_guns) 1))
		(TRUE 					(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_3380_gun (ai_get_object arm_hum_guns) 1))
	)

	(sleep 60)

	(device_operates_automatically_set arm_door_charger_1 1)
	(device_operates_automatically_set arm_door_charger_2 1)
	(sleep_until
		(or
			(>= (device_get_position arm_door_charger_1) 0.1)
			(>= (device_get_position arm_door_charger_2) 0.1)
		)
	1 150)
	(cond
		((and
			(difficulty_legendary)
			(game_is_cooperative)
			(> (real_random_range 0 1) 0.9)
		)								(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_3450_gun (ai_get_object arm_hum_guns) 1))
		(TRUE							(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_3430_gun (ai_get_object arm_hum_guns) 1))
	)
	(sleep_until
		(or
			(>= (device_get_position arm_door_charger_1) 0.3)
			(>= (device_get_position arm_door_charger_2) 0.3)
		)
		1
		(+
			(sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_3450_gun)
			(sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_3430_gun)
		)
	)
	(ai_cannot_die arm_hum_guns 0)
	(ai_cannot_die arm_cov_elt 0)
	(ai_kill arm_hum_guns)

	(sleep_until
		(or
			(= (ai_living_count arm_cov) 0)
			(volume_test_objects tv_atr1_floor (players))
		)
	1)
	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_05 NONE 1); f_full

	(set mark_flavor_disable FALSE)
	(set mark_flavor_atr1 TRUE)
)

;==================================
;========== atr1 Scripts ==========
;==================================
(script command_script cs_atr1_turret_fbalcony
	(cs_deploy_turret atr1_turrets/fbalcony)
	(damage_new "effects\damage_effects\glass_breaker" fbalcony_flag)
)

(script command_script cs_atr1_turret_bbalcony
	(cs_deploy_turret atr1_turrets/bbalcony)
	(damage_new "effects\damage_effects\glass_breaker" bbalcony_flag)
)

(script dormant atr1_mission
	(print "atr1")

	(sleep_until (volume_test_objects tv_atr1_floor (players)) 1)
	(wake save_atr1_start)
	(sleep 15)
	(ai_place atr1_cov_fbalcony)
	(ai_place atr1_cov_bbalcony)
	(ai_place atr1_cov_sec_front)
	(set mark_flavor_brace TRUE)

	(sleep_until (volume_test_objects tv_atr1_mid (players)) 1)
	(ai_place atr1_cov_stairs_front)

	(sleep_until
		(or
			(< (ai_strength atr1_cov_stairs) 0.25)
			(volume_test_objects tv_atr1_stairs (players))
		)
	1)
	(if (< (ai_living_count atr1_cov) 6) (ai_place atr1_cov_stairs_back) (ai_place atr1_cov_stairs_back_elt))

	(sleep_until (volume_test_objects tv_atr1_sec (players)) 1)
	(if (< (ai_living_count atr1_cov) 6) (ai_place atr1_cov_sec_back) (ai_place atr1_cov_sec_back_elt))

	(sleep_until
		(or
			(= (ai_living_count atr1_cov_sec_back) 0)
			(volume_test_objects tv_trm1_floor (players))
		)
	1)

	(set mark_flavor_atr1 FALSE)
	(set mark_flavor_trm1 TRUE)

	(sound_looping_stop scenarios\solo\01b_spacestation\01b_music\01b_05); f_full

	(sleep_until (volume_test_objects tv_trm1_floor (players)) 1)
	(sleep_forever save_atr1_start)
	(ai_disposable atr1_cov 1)

	(sleep_until (= (structure_bsp_index) 3) 10)
	(ai_erase atr1_cov)
;	(ai_erase atr1_hum)
)

;==================================
;========== trm1 Scripts ==========
;==================================

(script command_script cs_trm1_bunker
	(cs_enable_moving 0)
	(cs_crouch 1)
	(sleep_forever)
	)

(script command_script cs_trm1_lookat_player_crouch
	(cs_enable_moving 0)
	(cs_crouch 1)
	(cs_face_player 1)
	(sleep_forever)
	)

(script command_script cs_trm1_lookat_miranda_crouch
	(cs_enable_moving 0)
	(cs_crouch 1)
	(cs_face_object 1 (ai_get_object trm1_hum_miranda))
	(sleep_forever)
	)

(script command_script cs_trm1_lookat_johnson_crouch
	(cs_enable_moving 0)
	(cs_crouch 1)
	(cs_face_object 1 (ai_get_object trm1_hum_johnson))
	(sleep_forever)
	)

(script static void trm1_tomyship
	(cs_run_command_script trm1_hum_johnson cs_trm1_lookat_player_crouch)
	(print "C'mon, Chief! This way!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0290_jon NONE 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0290_jon))

	(sleep_until
		(and
			(< (objects_distance_to_object (players) (ai_get_object trm1_hum_miranda)) 3)
			(objects_can_see_object (players) (ai_get_object trm1_hum_miranda) 25)
		)
	1 120)
	(cs_run_command_script trm1_hum_miranda cs_trm1_lookat_player_crouch)
	(print "I was almost on-board when they showed up.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0300_mir (ai_get_object trm1_hum_miranda) 1)
	(sleep 30)
	(cs_run_command_script trm1_hum_johnson cs_trm1_lookat_miranda_crouch)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0300_mir))

	(print "Don't worry, Ma'am. We'll get 'em!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0310_jon (ai_get_object trm1_hum_johnson) 1)
	(sleep 30)
	(cs_run_command_script trm1_hum_miranda cs_trm1_lookat_johnson_crouch)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0310_jon))

	(cs_run_command_script trm1_hum_johnson cs_clear)
	(sleep 30)
	(cs_run_command_script trm1_hum_miranda cs_clear)
)

(script command_script cs_trm1_approach
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_approach (player0) 2 6 3)
	(sleep_forever)
)

(script command_script cs_trm1_moveto_alock
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to trm1/alock)
)

(script command_script cs_trm1_moveto_alock_miranda
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to trm1/alock_miranda)
)

(script command_script cs_trm1_moveto_alock_johnson
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to trm1/alock_johnson)
)

(script command_script cs_trm1_moveto_alock_block
	(cs_go_to trm1/alock_block)
)

(script command_script cs_trm1_lookat_block
	(cs_enable_moving 0)
	(cs_face_object 1 (ai_get_object trm1_hum_block_mar))
	(sleep_forever)
)

(script command_script cs_trm1_lookat_player
	(cs_enable_moving 0)
	(cs_face_player 1)
	(sleep_forever)
	)

(script command_script cs_trm1_lookat_miranda
	(cs_enable_moving 0)
	(cs_face_object 1 (ai_get_object trm1_hum_miranda))
	(sleep_forever)
	)

(script command_script cs_trm1_lookat_johnson
	(cs_enable_moving 0)
	(cs_face_object 1 (ai_get_object trm1_hum_johnson))
	(sleep_forever)
	)

(script dormant trm1_bugproblem
	(cs_run_command_script trm1_hum_block_mar cs_trm1_approach)
	(cs_run_command_script trm1_hum_miranda cs_trm1_approach)
	(cs_run_command_script trm1_hum_johnson cs_trm1_approach)

	(sleep 30)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object trm1_hum_miranda)) 2) 1 120) 
	(print "Thanks, Chief. I owe you one.  Take me now!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0380_mir (ai_get_object trm1_hum_miranda) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0380_mir))

	(sleep_until (volume_test_objects tv_trm1_block (players)) 1 180)
	(sleep_until (objects_can_see_object (players) (ai_get_object trm1_hum_johnson) 40) 1 90)
	(if
		(< (objects_distance_to_object (players) (ai_get_object trm1_hum_johnson)) 4)
		(begin
			(print "Get going. I'll cover the Commander!")
			(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0370_jon (ai_get_object trm1_hum_johnson) 1)
		)
	)
	(cs_run_command_script trm1_hum_miranda cs_clear)
	(cs_run_command_script trm1_hum_johnson cs_clear)
)

(script dormant trm1_cleanup
	(sleep 90)
	(sleep_until
		(and
			(volume_test_objects_all tv_trm1_start (players))
			(= (device_get_position trm1_door_exit) 0)
			(> (player_count) 0)
		)
	1)
	(ai_erase atr1_cov_bbalcony)
	(ai_erase atr1_cov_fbalcony)
	(ai_erase atr1_cov_stairs)
)

(script dormant trm1_mission
	(print "trm1")

	(sleep_until (volume_test_objects tv_trm1_floor (players)) 1)
	(set mark_flavor_disable TRUE)

	(object_create trm1_tram)
	(save_trm1_start)
	(ai_place trm1_hum_alock)
	(object_set_permutation (ai_get_object trm1_hum_johnson) "helmet" "")
	(ai_cannot_die trm1_hum_johnson 1)
	(ai_cannot_die trm1_hum_miranda 1)
	(cs_run_command_script trm1_hum_johnson cs_trm1_bunker)
	(cs_run_command_script trm1_hum_miranda cs_trm1_bunker)
;	(ai_place trm1_hum_block)
	(ai_place trm1_cov_alock)
	
	(sleep_until (volume_test_objects tv_trm1_start (players)) 1)
	
	(wake trm1_cleanup)
	(trm1_tomyship)

	(sleep_until
		(or
			(volume_test_objects tv_trm1_alock (players))
			(= (ai_living_count trm1_cov_alock) 0)
		)
	1)
	(ai_set_orders trm1_hum_block trm1_hum_block)

	(sleep_until (= (ai_living_count trm1_cov_alock) 0) 1)
	(wake trm1_bugproblem)

	(set mark_flavor_disable FALSE)

	(sleep_until (volume_test_objects tv_trm1_block (players)) 1)
	(ai_place trm1_cov_block)
	(ai_magically_see_object trm1_cov_block (player0))
	(ai_magically_see_object trm1_cov_block (player1))

	(sleep_until (volume_test_objects tv_dck_mid (players)) 1)
 	(ai_set_orders trm1_hum_alock trm1_hum_iac)
	(ai_disposable trm1_cov_alock 1)
	(ai_disposable trm1_cov_block 1)
	(ai_disposable trm1_hum_alock 1)
	(ai_disposable trm1_hum_block 1)

	(sleep_until (= (structure_bsp_index) 3) 10)
	(ai_erase trm1_cov_alock)
	(ai_erase trm1_cov_block)
	(ai_erase trm1_hum_alock)
	(ai_erase trm1_hum_block)
)

;==================================
;========== dck Scripts ==========
;==================================
(script dormant dck_hog
	(object_create_anew dck_hog)
	(object_create_anew dck_hog_rail)
	(objects_attach dck_hog_rail rail dck_hog "")
	(device_set_position_track dck_hog_rail track:rail 0)
	(device_animate_position dck_hog_rail 1.0 20 0 0 true)
	(sleep (* 200 seconds))
	(object_destroy dck_hog)
	(object_destroy dck_hog_rail)
)

(script static void dck_setusup
	(print "Sir! Boarders have breached the fire-control center. They have a bomb!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0390_cor NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0390_cor))

	(print "Can you defuse it?")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0400_lhd NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0400_lhd))

	(print "Yes...but I'll need the Chief's help to make contact with the detonator.")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0410_cor NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0410_cor))
;*
	(print "Alert! The Covenant fleet is on the move. Orders, Sir? ")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0420_ahp NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0420_ahp))

	(print "Engage, Admiral!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0430_lhd NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0430_lhd))

	(print "Aye-aye!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0440_ahp NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0440_ahp))
*;
	(print "Chief, get to the bomb. Double-time! Cortana, prioritize targets, and fire-at-will!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0450_lhd NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0450_lhd))
)

(script dormant dck_mission
	(print "dck")

	(sleep_until (volume_test_objects tv_dck_start (players)) 1)
	(set mark_flavor_trm1 FALSE)
	(set mark_flavor_dck TRUE)

	(sleep_until
		(and
			(volume_test_objects_all tv_dck_start (players))
			(> (player_count) 0)
		)
	1 90)
	(volume_teleport_players_not_inside tv_dck_start dck_enter_flag)
	(object_create dck_wall_enter)

	(device_set_position dck_door_arm_1 0)
	(save_dck_start)
	(wake title_dck)

	(sleep 45)
	(device_set_position dck_door_arm_2 1)
	(sound_impulse_start "sound\visual_effects\ss_airlock\airlock" NONE 1)
	(sleep 45)

	(physics_set_gravity 0.75)
	(set_global_sound_environment 1 1 0 0 1000 5)
	(set mark_flavor_vacuum TRUE)	

	(ai_place dck_cov_enter_elt)
	(ai_place dck_cov_arm1_elt)

	(sleep_until (volume_test_objects tv_dck_arm1_back (players)) 1)
	(wake dck_hog)

	(sleep_until
		(or
			(volume_test_objects tv_dck_mid (players))
			(<= (ai_strength dck_cov) .3)
		)
	1)

	(ai_place dck_cov_arm2)
	(ai_magically_see_object dck_cov_arm2 (player0))
	(ai_magically_see_object dck_cov_arm2 (player1))

;	(sleep_until (<= (ai_living_count dck_cov) 1) 10)
	(set mark_flavor_disable TRUE)

	(sleep 150)
	(dck_setusup)

	(set mark_flavor_disable FALSE)

	(sleep_until (= (structure_bsp_index) 3) 10)
	(ai_erase dck_cov)
)

;==================================
;========== elv Scripts ==========
;==================================
(script dormant elv_goinloud
	(sleep_forever dck_setusup)
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_0390_cor)
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_0400_lhd)
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_0410_cor)
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\L01_0450_lhd)

	(set mark_flavor_disable TRUE)

	(print "First echelon, you're with me. Blanket those cruisers - take 'em out one-by-one. Second echelon, keep those carriers busy!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0470_ahp NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0470_ahp))
	(sleep 15)

	(print "Registering all hostile vessels inside the kill-zone. Thirteen cruisers, two assault-carriers. I'm going loud!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0460_cor NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0460_cor))
	
	(sleep_until (objects_can_see_flag (players) macgun_flag 25) 1 120)
	(device_set_power macgun 1)
	(device_set_power gun_loader 1)

	(set mark_flavor_disable FALSE)
	(save_elv_start)
)

(script static boolean elv_elevator_test
	(> (device_get_position elv_elevator) 0.8)
)

(script static boolean elv_elevator_down
	(volume_test_objects_all tv_elevator (players))
)

(script dormant elv_mission
	(print "elv")
	(sleep_until (= (structure_bsp_index) 3) 1)
	(object_type_predict "objects\characters\marine\marine")
	(object_type_predict "objects\characters\bugger\bugger")

	(set_global_sound_environment 1 1 1 1 8000 0)
	(physics_set_gravity 1)
	(sound_impulse_start "sound\visual_effects\ss_airlock\airlock_repressurize" NONE 1)
	(set mark_flavor_vacuum FALSE)	
	(device_operates_automatically_set bsp3_door_backward 0)
	(device_operates_automatically_set bsp3_door_backward_2 0)
	(device_operates_automatically_set bsp3_door_forward 1)

	(objects_attach elv_elevator "control_1" elv_elevator_control_1 "")
	(objects_attach elv_elevator "control_2" elv_elevator_control_2 "")
	(save_elv_start)
	(wake elv_goinloud)
	(ai_place elv_hum_mar)

	(sleep_until (volume_test_objects tv_elv_start (players)) 1)
	(ai_place elv_cov_top)
	(sleep 30)
	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_07 NONE 1); swelltrill

	(sleep_until (<= (ai_strength elv_cov) .35) 10)
;	(save_elv_mid)
	(object_type_predict "objects\characters\grunt\grunt")
	(object_type_predict "objects\characters\elite\elite")
	(sleep 15)
	(ai_place elv_cov_elevator)
	(sleep 5)
	(device_set_position lvr_door_enter_1 1)
	(device_set_power elv_elevator_control_1 1)
	(device_set_power elv_elevator_control_2 1)

	(sleep_until (= (device_get_position lvr_door_enter_1) 1) 1)
	(sleep_until (volume_test_objects_all tv_elevator (ai_actors elv_cov_elevator))	1 (* 20 seconds))

	(device_set_position elv_elevator 1)

	(sleep_until (> (device_group_get elv_elevator_position) 0) 1 (* 120 seconds))
	(device_set_position elv_elevator 0)
	(device_set_power elv_elevator_control_1 0)
	(device_set_power elv_elevator_control_2 0)

	(sleep_until (volume_test_objects_all tv_lvr_enter (players)) 1)
	(ai_disposable elv_cov 1)
	(ai_disposable elv_hum_mar 1)
)

;==================================
;========== lvr Scripts ==========
;==================================

(script dormant lvr_carrier_flyby
	(object_create carrier_01)
	(effect_new_on_object_marker effects\scenery\solids\human_fleet_ships_attack_carrier carrier_01 bow)
	(scenery_animation_start_relative carrier_01 scenarios\objects\covenant\military\capital_ship\spacestation\spacestation "capital_ship_01" flyby)
	
	(sound_impulse_start sound\ambience\spacestation\cap_ship_flyover lvr_flyby_flag 1)

	(sleep 330)
	(damage_players effects\damage_effects\carrier_flyby)

	(sleep_until (= (scenery_get_animation_time carrier_01) 0) 1)
	(object_destroy carrier_01)
)

(script dormant lvr_carriers
	(set mark_flavor_disable TRUE)

;	(print "That's the last of the cruisers. Damn fine shooting, Cortana!")
;	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0480_lhd NONE 1 "radio_default")
;	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0480_lhd))
;	(sleep 15)

;	(print "Admiral! The point-defense is too intense! My grid is maxed! I don't think - ")
;	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0490_nrl NONE 1 "radio_default")
;	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0490_nrl))
;	(sleep 8)

	(print "The carriers are breaking-through, Sir! They're heading straight for the Cairo!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0500_ahp NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0500_ahp))
 
	(sleep 7)

	(print "Cortana, concentrate your fire on the first carrier! Admiral, do what you can against the second!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0510_lhd NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0510_lhd))
	(sleep 8)

	(print "Everyone form-up! Follow my lead!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0520_ahp NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0520_ahp))
;	(sleep 8)

;	(print "All remaining vessels: pull-back! Form a defensive perimeter around the Cairo!")
;	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0560_lhd NONE 1 "radio_default")
;	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0560_lhd))

	(set mark_flavor_disable FALSE)
	(save_lvr_start)

;	(sleep_until (> (scenery_get_animation_time carrier_01) 0) 1)

	(sleep_until (volume_test_objects tv_lvr_back (players)) 1 (* 15 seconds))

	(set mark_flavor_disable TRUE)
	(print "The first carrier completely ignored us, Sir - blew through the Malta's debris-field, and headed straight for Earth!")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_0530_cor NONE 1 "radio_default")
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0530_cor))
	(set mark_flavor_disable FALSE)
)

(script dormant lvr_mission
	(print "lvr")
	(sleep_until
		(and
			(volume_test_objects_all tv_lvr_enter (players))
			(> (player_count) 0)
		)
	1)
	(object_create lvr_wall_enter)
	(device_set_position lvr_door_enter_1 0)
	(wake lvr_carriers)

	(sleep_until (= (device_get_position lvr_door_enter_1) 0) 1)
	(ai_erase elv_cov_top)
	(sleep_until (game_safe_to_save) 1 150)
	(save_lvr_start)
	(sleep 30)
	(ai_place lvr_cov_wv1)
;	(ai_place lvr_cov_air)

	(wake lvr_carrier_flyby)
	(device_set_position lvr_door_enter_2 1)
	(device_set_power lvr_airlock_blower 1)
	(sound_impulse_start "sound\visual_effects\ss_airlock\airlock" NONE 1)
	(sleep 30)

	(physics_set_gravity 0.75)
	(set mark_flavor_vacuum TRUE)	
	(biped_ragdoll lvr_body_1)
	(biped_ragdoll lvr_body_2)
	(sleep 60)

	(set_global_sound_environment 1 1 0 0 1000 5)
	(device_set_power lvr_airlock_blower 0)

	(sleep_until (volume_test_objects tv_lvr_back (players)) 1)
	(if (not (difficulty_normal)) (ai_place lvr_cov_wv2))

	(sleep_until (< (objects_distance_to_object (players) gun_elevator_door_top) 4) 1)
	(device_operates_automatically_set gun_elevator_door_top 1)
	(device_set_position_immediate gun_elevator .1)
	(device_set_position gun_elevator 0)

	(sleep_until
		(and
			(volume_test_objects_all tv_gun_elevator (players))
			(> (player_count) 0)
		)
	1)
	(object_create gun_wall_enter)
	(sleep_forever lvr_carriers)
	(set mark_flavor_disable TRUE)
	(device_set_position gun_elevator 1)
	(ai_disposable gun_cov 1)

	(physics_set_gravity 1)
	(set_global_sound_environment 1 1 1 1 8000 0)
	(set mark_flavor_vacuum FALSE)
	(sleep 30)
	(sound_impulse_start "sound\visual_effects\ss_airlock\airlock_repressurize" NONE 1)
	(sleep 30)
	(print "There's quite a lot of Elites in here, you may need to get creative.")
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\mission\L01_4000_cor NONE 1 "radio_default")
	(sleep (- (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_4000_cor) 60))

	(wake title_gun)
	(sound_looping_start scenarios\solo\01b_spacestation\01b_music\01b_08 NONE 1); 05_nostrings
	(set mark_flavor_disable FALSE)
	(ai_erase lvr_cov)
)

;==================================
;========== gun Scripts ==========
;==================================

(script command_script cs_expand_cortana
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(object_set_scale (ai_get_object ai_current_actor) 0.01 1)
	(ai_disregard (ai_get_object ai_current_actor) true)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\teleport_in (ai_get_object ai_current_actor) "body")
	(sleep 1)
	(object_set_scale (ai_get_object ai_current_actor) 0.4 20)
	(cs_face_player true)
	(sleep_forever)
)

(script command_script cs_shrink_cortana
	(cs_enable_dialogue false)
	(sleep 60)
	(effect_new_on_object_marker effects\objects\characters\cortana\teleport_out (ai_get_object ai_current_actor) "body")
	(sleep 3)
	(object_set_scale (ai_get_object ai_current_actor) 0.01 20)
	(sleep 30)
	(ai_erase ai_current_actor)
)
;*
(script dormant gun_cortana
	(sleep_until
		(cond
			(mark_bomb2_objective										TRUE)
			((= (ai_living_count gun_cov) 0)								(begin
																		(cs_run_command_script gun_cortana cs_shrink_cortana)
																		(sleep 120)
																		(ai_place gun_cortana_3)
																		(objects_attach outro_cortana_stand "cortana_attach_left" (ai_get_object gun_cortana_3) "")
																		TRUE
																	))
			((< (objects_distance_to_object (player0) gun_cortana_stand_1) 3)	(begin
																		(print "cor_1")
																		(cs_run_command_script gun_cortana cs_shrink_cortana)
																		(sleep 120)
																		(ai_place gun_cortana_1)
																		(objects_attach gun_cortana_stand_1 "cortana_attach_right" (ai_get_object gun_cortana_1) "")
																		(sleep_until (> (objects_distance_to_object (player0) gun_cortana_stand_1) 5) 1)
																		FALSE
																	))
			((< (objects_distance_to_object (player0) gun_cortana_stand_2) 3)	(begin
																		(print "cor_2")
																		(cs_run_command_script gun_cortana cs_shrink_cortana)
																		(sleep 120)
																		(ai_place gun_cortana_2)
																		(objects_attach gun_cortana_stand_2 "cortana_attach_left" (ai_get_object gun_cortana_2) "")
																		(sleep_until (> (objects_distance_to_object (player0) gun_cortana_stand_2) 5) 1)
																		FALSE
																	))
			((< (objects_distance_to_object (player0) outro_cortana_stand) 3)	(begin
																		(print "cor_3")
																		(cs_run_command_script gun_cortana cs_shrink_cortana)
																		(sleep 120)
																		(ai_place gun_cortana_3)
																		(objects_attach outro_cortana_stand "cortana_attach_left" (ai_get_object gun_cortana_3) "")
																		(sleep_until (> (objects_distance_to_object (player0) outro_cortana_stand) 5) 1)
																		FALSE
																	))
			((< (objects_distance_to_object (player0) gun_cortana_stand_4) 3)	(begin
																		(print "cor_4")
																		(cs_run_command_script gun_cortana cs_shrink_cortana)
																		(sleep 120)
																		(ai_place gun_cortana_4)	
																		(objects_attach gun_cortana_stand_4 "cortana_attach_right" (ai_get_object gun_cortana_4) "")
																		(sleep_until (> (objects_distance_to_object (player0) gun_cortana_stand_4) 5) 1)
																		FALSE
																	))
		)
	1)
	(sleep_until mark_bomb2_objective 1)
	(ai_erase gun_cortana_1)
	(ai_erase gun_cortana_2)
	(ai_erase gun_cortana_3)
	(ai_erase gun_cortana_4)
)
			

(script static void test
	(object_create carrier_01)
;	(object_create gun_fleet)
;	(objects_attach carrier_01 "" gun_fleet "")
;	(scenery_animation_start_relative carrier_01 scenarios\objects\covenant\military\capital_ship\spacestation\spacestation "capital_ship_01" anchor_outro1)
;	(effect_new_on_object_marker effects\scenery\solids\human_fleet_ships_attack_carrier carrier_01 bow)
;	(sleep 225)
	(damage_players effects\damage_effects\spacestation_shockwave) 

;	(sleep_until (= (scenery_get_animation_time carrier_01) 0) 1)
;	(object_destroy carrier_01)
)
*;
(script dormant gun_flyby
	(object_create carrier_02)
	(scenery_animation_start_relative carrier_02 scenarios\objects\covenant\military\capital_ship\spacestation\spacestation "capital_ship_02" anchor_outro1)
	(effect_new_on_object_marker effects\scenery\solids\human_fleet_ships_attack_carrier carrier_02 bow)
	(sleep 330)
	(damage_players effects\damage_effects\carrier_flyby) 

	(sleep_until (= (scenery_get_animation_time carrier_02) 0) 1)
	(object_destroy carrier_02)
)

(script static void gun_mission
	(print "gun")
	(object_type_predict "objects\characters\grunt\grunt")
	(object_type_predict "objects\characters\elite\elite")

	(sleep_until
		(and
			(volume_test_objects_all tv_elv_enter (players))
			(> (player_count) 0)
		)
	1)

	(set mark_flavor_dck FALSE)
	(set mark_flavor_gun TRUE)

	(object_create gun_wall_enter)
	(save_gun_start)
	(ai_place gun_cov)
	(ai_place gun_hum_mar)
;	(wake capital_flyby_gun)
;	(wake gun_carrier)
;	(wake gun_cortana)
	(wake gun_flyby)

	(sleep_until (<= (ai_living_count gun_cov) 4) 1)
	(sound_looping_set_alternate scenarios\solo\01b_spacestation\01b_music\01b_08 1); 05_nostrings alt
	(set mark_flavor_vacuum TRUE)

	(sleep_until (= (ai_living_count gun_cov) 0) 1)
	(set mark_flavor_bomb FALSE)
	(set mark_flavor_disable TRUE)
	(sound_looping_stop scenarios\solo\01b_spacestation\01b_music\01b_08); 05_nostrings

	(sleep 150)
	(sleep_until (< (objects_distance_to_object (players) pickle) 4) 1 150)

	(set mark_bomb2_objective TRUE)
)

;=================================
;========== Load Script ==========
;=================================

(script static void load_bsp0a
	(object_create_anew rack_bsp0a_1_smg_1)
	(objects_attach rack_bsp0a_1 smg_1 rack_bsp0a_1_smg_1 "")

	(object_create_anew rack_bsp0a_1_smg_2)
	(objects_attach rack_bsp0a_1 smg_2 rack_bsp0a_1_smg_2 "")

	(object_create_anew rack_bsp0a_2_br_1)
	(objects_attach rack_bsp0a_2 br_2 rack_bsp0a_2_br_1 "")

	(object_create_anew rack_bsp0a_2_br_2)
	(objects_attach rack_bsp0a_2 br_3 rack_bsp0a_2_br_2 "")

	(object_create_anew rack_bsp0a_3_smg_1)
	(objects_attach rack_bsp0a_3 smg_1 rack_bsp0a_3_smg_1 "")

	(object_create_anew rack_bsp0a_3_smg_2)
	(objects_attach rack_bsp0a_3 smg_2 rack_bsp0a_3_smg_2 "")

	(object_create_anew rack_bsp0a_4_br_1)
	(objects_attach rack_bsp0a_4 br_2 rack_bsp0a_4_br_1 "")

	(object_create_anew rack_bsp0a_4_br_2)
	(objects_attach rack_bsp0a_4 br_4 rack_bsp0a_4_br_2 "")

	(object_create_anew rack_bsp0a_5_smg_1)
	(objects_attach rack_bsp0a_5 smg_1 rack_bsp0a_5_smg_1 "")

	(object_create_anew rack_bsp0a_5_smg_2)
	(objects_attach rack_bsp0a_5 smg_3 rack_bsp0a_5_smg_2 "")

	(object_create_anew rack_bsp0a_5_smg_3)
	(objects_attach rack_bsp0a_5 smg_4 rack_bsp0a_5_smg_3 "")

	(object_create_anew rack_bsp0a_6_br_1)
	(objects_attach rack_bsp0a_6 br_1 rack_bsp0a_6_br_1 "")

	(object_create_anew rack_bsp0a_6_br_2)
	(objects_attach rack_bsp0a_6 br_2 rack_bsp0a_6_br_2 "")

	(object_create_anew rack_bsp0a_6_br_3)
	(objects_attach rack_bsp0a_6 br_4 rack_bsp0a_6_br_3 "")

	(object_create_anew bigrack_bsp0a_5_smg_1)
	(objects_attach bigrack_bsp0a_5 gun_r_01 bigrack_bsp0a_5_smg_1 "")

	(object_create_anew bigrack_bsp0a_5_smg_2)
	(objects_attach bigrack_bsp0a_5 gun_r_03 bigrack_bsp0a_5_smg_2 "")

	(object_create_anew bigrack_bsp0a_5_smg_3)
	(objects_attach bigrack_bsp0a_5 gun_l_02 bigrack_bsp0a_5_smg_3 "")

	(object_create_anew bigrack_bsp0a_6_smg_1)
	(objects_attach bigrack_bsp0a_6 gun_l_02 bigrack_bsp0a_6_smg_1 "")

	(object_create_anew bigrack_bsp0a_6_smg_2)
	(objects_attach bigrack_bsp0a_6 gun_r_03 bigrack_bsp0a_6_smg_2 "")
)

(script static void load_bsp2
	(object_create_anew rack_bsp2_1_smg_1)
	(objects_attach rack_bsp2_1 smg_1 rack_bsp2_1_smg_1 "")

	(object_create_anew rack_bsp2_1_smg_2)
	(objects_attach rack_bsp2_1 smg_2 rack_bsp2_1_smg_2 "")

	(object_create_anew rack_bsp2_1_smg_3)
	(objects_attach rack_bsp2_1 smg_3 rack_bsp2_1_smg_3 "")
)

(script static void load_bsp0b
	(object_create_anew rack_bsp0b_1_br_1)
	(objects_attach rack_bsp0b_1 br_1 rack_bsp0b_1_br_1 "")

	(object_create_anew rack_bsp0b_1_br_2)
	(objects_attach rack_bsp0b_1 br_3 rack_bsp0b_1_br_2 "")

	(object_create_anew rack_bsp0b_2_smg_1)
	(objects_attach rack_bsp0b_2 smg_2 rack_bsp0b_2_smg_1 "")

	(object_create_anew rack_bsp0b_2_smg_2)
	(objects_attach rack_bsp0b_2 smg_4 rack_bsp0b_2_smg_2 "")

	(object_create_anew bigrack_bsp0b_1_br_1)
	(objects_attach bigrack_bsp0b_1 gun_l_01 bigrack_bsp0b_1_br_1 "")

	(object_create_anew bigrack_bsp0b_1_br_2)
	(objects_attach bigrack_bsp0b_1 gun_r_02 bigrack_bsp0b_1_br_2 "")

	(object_create_anew bigrack_bsp0b_2_br_1)
	(objects_attach bigrack_bsp0b_2 gun_l_03 bigrack_bsp0b_2_br_1 "")

	(object_create_anew bigrack_bsp0b_3_br_1)
	(objects_attach bigrack_bsp0b_3 gun_l_02 bigrack_bsp0b_3_br_1 "")

	(object_create_anew bigrack_bsp0b_3_br_2)
	(objects_attach bigrack_bsp0b_3 gun_r_01 bigrack_bsp0b_3_br_2 "")

	(object_create_anew bigrack_bsp0b_4_br_1)
	(objects_attach bigrack_bsp0b_4 gun_r_02 bigrack_bsp0b_4_br_1 "")

	(object_create_anew bigrack_bsp0b_5_smg_1)
	(objects_attach bigrack_bsp0b_5 gun_r_01 bigrack_bsp0b_5_smg_1 "")

	(object_create_anew bigrack_bsp0b_6_smg_1)
	(objects_attach bigrack_bsp0b_6 gun_l_03 bigrack_bsp0b_6_smg_1 "")

	(object_create_anew bigrack_bsp0b_6_smg_2)
	(objects_attach bigrack_bsp0b_6 gun_r_02 bigrack_bsp0b_6_smg_2 "")

	(object_create_anew bigrack_bsp0b_7_smg_1)
	(objects_attach bigrack_bsp0b_7 gun_r_03 bigrack_bsp0b_7_smg_1 "")

	(object_create_anew bigrack_bsp0b_8_smg_1)
	(objects_attach bigrack_bsp0b_8 gun_l_01 bigrack_bsp0b_8_smg_1 "")
	
	(object_create_anew atr1_elevator)
)

(script static void load_bsp3
	(object_create_anew rack_bsp3_1_br_1)
	(objects_attach rack_bsp3_1 br_1 rack_bsp3_1_br_1 "")

	(object_create_anew rack_bsp3_1_br_2)
	(objects_attach rack_bsp3_1 br_3 rack_bsp3_1_br_2 "")

	(object_create_anew rack_bsp3_2_smg_1)
	(objects_attach rack_bsp3_2 smg_2 rack_bsp3_2_smg_1 "")

	(object_create_anew rack_bsp3_2_smg_2)
	(objects_attach rack_bsp3_2 smg_4 rack_bsp3_2_smg_2 "")

	(object_create_anew rack_bsp3_4_br_1)
	(objects_attach rack_bsp3_4 br_2 rack_bsp3_4_br_1 "")

	(object_create_anew rack_bsp3_4_br_2)
	(objects_attach rack_bsp3_4 br_2 rack_bsp3_4_br_2 "")

	(object_create_anew rack_bsp3_5_smg_1)
	(objects_attach rack_bsp3_5 smg_3 rack_bsp3_5_smg_1 "")
)

;=================================
;========== Main Script ==========
;=================================

(script static void mission_start
	(print "01b SPACESTATION")
	(print "Designer - Jaime")
	(print "Env. Artsits - Paul, Dave")
;	(object_teleport (player0) arm_flag)
)

(script static void mission_setup
	(objectives_clear)
	(game_can_use_flashlights 0)
	(ai_allegiance player human)
	(ai_allegiance covenant prophet)
	(ai_allegiance prophet covenant)
	(device_set_position_immediate macgun 0)
	(device_set_position_immediate gun_loader 0)
	(device_set_power macgun 0)
	(device_set_power gun_loader 0)
	(object_create malta)
	(object_create athens)
)

(script startup mission_spacestation
	(if (= (player_count) 0 ) (sleep_forever))
	(cinematic_snap_to_white)
	(save_cutscene)
	(if (cinematic_skip_start)
		(begin
			(cinematic_stash_players)
			(x02)
			(cinematic_unstash_players)
		)
	)
	(cinematic_skip_stop)
	(object_type_predict scenarios\objects\solo\spacestation\ss_tram_car\ss_tram_car)
	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(mission_start)
	(mission_setup)
	(load_bsp0a)
	(wake flavor_mission)
	(wake 1st_mission)
	(wake atr2_mission)
	(wake 1st_tram)
	(sleep 1)
	(cinematic_fade_from_white)

	(sleep_until (= (structure_bsp_index) 2) 1)
	(load_bsp2)
	(device_operates_automatically_set bsp2_door_forward 1)

	(wake bay1_mission)
	(wake bay2_mission)

	(sleep_until (= (structure_bsp_index) 0) 1)
	(load_bsp0b)
	(wake ice_cream_check)
	(wake arm_mission)
	(wake atr1_mission)
	(wake trm1_mission)
	(wake dck_mission)

	(sleep_until (= (structure_bsp_index) 3) 1)
	(load_bsp3)
	(wake elv_mission)
	(wake lvr_mission)
	(gun_mission)
	(playtest_mission)

	(save_cutscene)
	(cinematic_fade_to_white)
	(device_set_power gun_loader 0)
	(device_set_power macgun 0)
	(sleep 45)
	(if (cinematic_skip_start)
		(begin
			(cinematic_stash_players)
			(c01_outro)
			(cinematic_unstash_players)
		)
	)
	(cinematic_skip_stop)
	(game_won)
)

;=================================
;========= Cheat Scripts =========
;=================================
(script static void cheat_atr2
	(switch_bsp 0)
	(object_teleport (player0) atr2_flag)
)

(script static void cheat_bay1
	(switch_bsp 2)
	(object_teleport (player0) bay1_flag)
)

(script static void cheat_bay2
	(switch_bsp 2)
	(object_teleport (player0) bay2_flag)
)

(script static void cheat_arm
	(switch_bsp 0)
	(object_teleport (player0) arm_flag)
)

(script static void cheat_atr1
	(switch_bsp 0)
	(wake mission_spacestation)
	(object_teleport (player0) atr1_flag)
)

(script static void cheat_trm1
	(switch_bsp 0)
	(wake mission_spacestation)
	(object_teleport (player0) trm1_flag)
)

(script static void cheat_elv
	(switch_bsp 3)
	(wake mission_spacestation)
	(wake mission_spacestation)
	(object_teleport (player0) elv_flag)
)

(script static void cheat_lvr
	(switch_bsp 3)
	(wake mission_spacestation)
	(wake mission_spacestation)
	(object_teleport (player0) lvr_flag)
)

(script static void cheat_gun
	(switch_bsp 3)
	(wake mission_spacestation)
	(wake mission_spacestation)
	(object_teleport (player0) gun_flag)
)