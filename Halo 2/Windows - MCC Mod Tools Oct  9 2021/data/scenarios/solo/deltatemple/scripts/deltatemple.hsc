;Delta Temple!
;-------------------------------------------------------------------------------

;Global pausing script to fake sleeping and other stationary behaviors
(script command_script long_pause
	(cs_abort_on_alert TRUE)
	(cs_pause -1)
)

;-------------------------------------------------------------------------------
;Main dialogue

;Intro dialogue
(script dormant dlg_cort_intro_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Well doesn't this feel familiar.")
)	
(script dormant dlg_cort_intro_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Our arrival hasn't gone unnoticed.")
	(sleep 90)
	(print "CORTANA: Enemy dropship on approach.")
	(sleep 90)
	(print "CORTANA: Time to make ourselves scarce, Chief.")
)
(script dormant dlg_cort_intro_02
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: We won't be getting any support on this one.")
	(sleep 120)
	(print "CORTANA: We're outnumbered and outgunned.")
	(sleep 90)
	(print "CORTANA: This might call for the subtle approach.")
	(sleep 90)
	(print "CORTANA: So can you tiptoe in this suit?")
)
;(script static void dlg_cort_intro_03
;	(sound_impulse_start sound\... none 1)
;	(print "CORTANA: Search parties ahead and behind.  Be careful.")
;)
(script dormant dlg_cort_intro_04
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: They're clearly going for containment.")
	(sleep 90)
	(print "CORTANA: Whatever is going on here, it's apparently too important...")
	(sleep 90)
	(print "CORTANA: ...for them to put on hold, even for you.")
)	

;Complex approach dialogue
(script dormant dlg_cort_approach_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: You always bring me to such nice places.")
)	
(script dormant dlg_cort_approach_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: I'll bet your frontal lobe that...")
	(sleep 90)
	(print "CORTANA: ...the Prophet Hierarch is somewhere in that complex.")
	(sleep 90)
	(print "CORTANA: Probably on the other side of a few hundred of his best men.")
)	

;Guard change dialogue
(script dormant dlg_cort_guardchange_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Looks like a changing of the guard.")
)
(script dormant dlg_cort_guardchange_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: If they find the bodies left back there...")
)	
  
;Hide N seek dialogue
(script dormant dlg_cort_hideNseek_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: I'd swear these grunts are playing...")
	(sleep 90)
	(print "CORTANA: ...some variant on hide and seek.")
	(sleep 90)
	(print "CORTANA: It's almost cute.  Almost.")
)	

;Reaction to speech dialgue
(script dormant dlg_cort_speechreaction_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: That's our guy.")
	(sleep 90)
	(print "CORTANA: He seems to be making some kind of speech...")
	(sleep 90)
	(print "CORTANA: ...or holding a ceremony of some sort.")
	(sleep 120)
	(print "CORTANA: I'll start working on a translation.")
)	

;Speech translation
(script dormant dlg_cort_speechtrans_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Interesting.")
	(sleep 60)
	(print "CORTANA: The Hierarch is performing some sort...")
	(sleep 90)
	(print "CORTANA: ...of ritual cleansing of the Halo.")
	(sleep 90)
	(print "CORTANA: Listen...")
)	
(script dormant dlg_cort_speechtrans_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: 'Just one of seven Halos'")
	(sleep 60)
	(print "CORTANA: 'Will prove awesome to behold.'")
)	
(script dormant dlg_cort_speechtrans_02
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: 'Imagine their collective glory,'")
	(sleep 60)
	(print "CORTANA: 'And alight our hearts, our souls!'")
)	
(script dormant dlg_cort_speechtrans_03
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: 'And yet we must not forget'")
	(sleep 60)
	(print "CORTANA: 'They symbolize The Journey.'")
)	
(script dormant dlg_cort_speechtrans_04
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: 'And so we'll mind to leave behind'")
	(sleep 60)
	(print "CORTANA: 'No traces of our yearning.'")
)	
(script dormant dlg_cort_speechtrans_05
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: (gasp)  The Covenant...")
	(sleep 60)
	(print "CORTANA: I think they're planning to activate the Halo.")
)	

;Central platform dialogue
(script dormant dlg_cort_centralplat_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Another dropship on approach.")
	(sleep 120)
	(print "CORTANA: Looks like they're fortifying.")
	(sleep 90)
	(print "CORTANA: Too little, too late.")
)

;Reaching elevator tower dialogue
(script dormant dlg_cort_elevunder_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: My analysis of this complex indicates...")
	(sleep 90)
	(print "CORTANA: ...that there's a submerged section connecting...")
	(sleep 90)
	(print "CORTANA: ...these towers to the far group.")
	(sleep 90)
	(print "CORTANA: Looks like we're going down.")
	(sleep 90)
	;check to see if the elevator is already underway
	(if (OR (= (device_get_position elev_under) 1.0) (= (device_get_position elev_under) 0.865))
		(begin
			(print "CORTANA: Unless you'd prefer to swim.")
		)
	)
)

;Sunken hall dialogue
(script dormant dlg_cort_sunkhall_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: That glass better be bulletproof...")
)

;Sunken chamber dialogue
(script dormant dlg_cort_sunkchamber_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: And people tell me I have a big head.")
;	(print "CORTANA: Now THAT is a big head.")
)
(script dormant dlg_cort_sunkchamber_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: He just keeps going on and on.")
	(sleep 90)
	(print "CORTANA: The triumph.  The glory.")
	(sleep 90)
	(print "CORTANA: This Great Journey.")
	(sleep 90)
	(print "CORTANA: Don't these idiots realize they'll all be killed?")
)

;Reaching second elevator dialogue
(script dormant dlg_cort_elevup_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: We're closing in on the source of the Heirarch's broadcast.")
	(sleep 90)
	(print "CORTANA: Security is bound to get a lot stiffer.")
)

;Temple view dialogue
(script dormant dlg_cort_templeview_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: If I was a megalomaniac - and I'm not -")
	(sleep 90)
	(print "CORTANA: I'd probably be holed up in a place like that.")
)

;Latecomers dialogue
(script dormant dlg_cort_marchers_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Another dropship on approach.")
)
(script dormant dlg_cort_marchers_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Looks like a few latecomers for the party.")
	(sleep 90)
	(print "CORTANA: The ones in the lead look like the same race as the Hierarch.")
	(sleep 90)
	(print "CORTANA: Get a good look.")
)

;Prophet's shuttle dialogue
(script dormant dlg_cort_shuttle_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: The Hierarch's shuttle, I presume.")
	(sleep 90)
	(print "CORTANA: The big boys always get the best parking spaces.")
)

;Entering temple dialogue
(script dormant dlg_cort_entertemple_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Decision time, Chief.")
	(sleep 90)
	(print "CORTANA: One man to kill, and a hundred ways to do it.")
	(sleep 90)
	(print "CORTANA: Not to mention a hundred guards protecting him.")
	(sleep 90)
	(print "CORTANA: No pressure.")
)
(script dormant dlg_cort_entertemple_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: And remember, once the job is done...")
	(sleep 90)
	(print "CORTANA: ...this whole place is going to be howling for your blood.")
	(sleep 90)
	(print "CORTANA: Be ready for a quick exit.")
)

;After assassination dialogue
(script dormant dlg_cort_afterdead_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Time to go, Chief!")
	(sleep 90)
	(print "CORTANA: I'm calling for your ride.")
	(sleep 90)
	(print "CORTANA: Head back outside and dig in while we wait for evac.")
)
(script dormant dlg_cort_afterdead_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Sergeant, we're ready for extraction.")
	(sleep 90)
	(print "CORTANA: I'm sending you coordinates now.")
)
(script dormant dlg_johnson_afterdead_00
;	(sound_impulse_start sound\... none 1)
	(print "JOHNSON (RADIO): ...trouble...wing of banshees...")
	(sleep 90)
	(print "JOHNSON (RADIO): ...gone to ground...on evac, Cortana...")
	(sleep 90)
	(print "JOHNSON (RADIO): ...repeat...negative on evac...")
)
(script dormant dlg_cort_afterdead_02
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Sergeant?  Sergeant!")
	(sleep 90)
	(print "CORTANA: I lost him.")
	(sleep 90)
	(print "CORTANA: Looks like we'd better make our own arrangements.")
)

;Back at shuttle dialogue
(script dormant dlg_cort_jackshuttle_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: The Prophet won't be needing this anymore.")
	(sleep 90)
	(print "CORTANA: Clear out any stowaways and get us out of here!")
)


;-------------------------------------------------------------------------------
;Misc. dialogue

;Prophet speech dialogue
;no idea how this will work

;Covenant crowd noise
;whatever

;Comm grunt dialogue
(script dormant dlg_cort_commgrunt_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: That grunt there is a walking panic button...")
	(sleep 90)
	(print "CORTANA: ...wired directly to the Covenant Battlenet.")
	(sleep 90)
	(print "CORTANA: If he sees you, he'll alert the Prophet that you're here.")
	(sleep 90)
	(print "CORTANA: And the Hierarch will be a lot harder to kill...")
	(sleep 90)
	(print "CORTANA: ...if he knows we're coming.")
)

;Dialogue when entering zones NOT on alert
(script dormant dlg_cort_notalert_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: They know you're coming, just not when you're coming.")
	(sleep 90)
	(print "CORTANA: Let's try to keep it that way.")
)
(script dormant dlg_cort_notalert_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: The alert hasn't propagated this far.")
	(sleep 90)
	(print "CORTANA: I don't think they were expecting a lone wolf attack like this.")
)
(script dormant dlg_cort_notalert_02
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: They must not realize we've come this far.")
	(sleep 90)
	(print "CORTANA: Otherwise I'd expect these guys to be a lot friskier.")
)
(script dormant dlg_cort_notalert_03
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: This is funny.")
	(sleep 90)
	(print "CORTANA: The men in this area have no clue what's really going on.")
	(sleep 90)
	(print "CORTANA: Half of them think our entire fleet is approaching...")
	(sleep 90)
	(print "CORTANA: ...and the other half think it's all part of the show.")
)
(script dormant dlg_cort_notalert_04
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: The Covenant appear to be a little distracted by the ceremony.")
	(sleep 90)
	(print "CORTANA: The forces in this area seem to think...")
	(sleep 90)
	(print "CORTANA: ...you're still in another zone.")
	(sleep 90)
	(print "CORTANA: Try not to prove otherwise.")
)

;Dialogue when the player has been detected
(script dormant dlg_cort_spotted_00
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: Let me guess.")
	(sleep 60)
	(print "CORTANA: You'd prefer a straight fight to all this sneaking around?")
)
(script dormant dlg_cort_spotted_01
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: I think they know you're here.")
)
(script dormant dlg_cort_spotted_02
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: You've been made, Chief!")
)
(script dormant dlg_cort_spotted_03
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: This section just went on alert.")
)
(script dormant dlg_cort_spotted_04
;	(sound_impulse_start sound\... none 1)
	(print "CORTANA: So much for subtle.")
)


;-------------------------------------------------------------------------------
;Music

;Intro music
(script dormant music_intro
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;General sneaking music
(script static void music_sneaking
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;Alert but not found music
(script static void music_alert
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;Discovered and in combat music
(script static void music_combat
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;Complex approach music
(script static void music_approach
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;Going underwater music
(script static void music_underwater
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;Temple approach music
(script static void music_temple
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;After assassination music
(script static void music_escape
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)

;Outro music
(script static void music_outro
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)


;-------------------------------------------------------------------------------
;Elevator scripts

;Script controlling rear elevator in temple
(global short temple_player 0)
(global short temple_lift 0)
(script static void temple_locations
	(cond
		((volume_test_objects vol_temple_elev_bottom (players)) (set temple_player 0))
		((volume_test_objects vol_temple_elev_top (players)) (set temple_player 1))
		((volume_test_objects vol_left_temple_elev_bottom (players)) (set temple_player 2))
		((volume_test_objects vol_left_temple_elev_top (players)) (set temple_player 3))
		(TRUE (set temple_player 4))
	)
	(cond
		((= (device_get_position elev_temple) .489) (set temple_lift 1))
		((= (device_get_position elev_temple) 1) (set temple_lift 0))
		((or (!= (device_get_position elev_temple) .489) (!= (device_get_position elev_temple) 1)) (set temple_lift 2))
	)
)
(script continuous temple_mover
	(sleep_until (OR (OR (volume_test_objects vol_left_temple_elev_bottom (players)) (volume_test_objects vol_left_temple_elev_top (players))) (OR (volume_test_objects vol_temple_elev_bottom (players)) (volume_test_objects vol_temple_elev_top (players)))))
	(temple_locations)
	(sleep 1)
	(cond
		((AND (= temple_player 0) (= temple_lift 0)) (device_set_position elev_temple .489))
		((AND (= temple_player 1) (= temple_lift 1)) (device_set_position elev_temple 1))
		((AND (!= temple_lift 0) (= temple_player 2)) (device_set_position elev_temple 1))
		((AND (!= temple_lift 1) (= temple_player 3)) (device_set_position elev_temple .489))
	)
	(sleep 1)
	(sleep_until (OR (OR (volume_test_objects vol_left_temple_elev_bottom (players)) (volume_test_objects vol_left_temple_elev_top (players))) (OR (volume_test_objects vol_temple_elev_bottom (players)) (volume_test_objects vol_temple_elev_top (players)))))
	(cond
		((AND (= temple_player 0) (= temple_lift 0)) (sleep_until (OR (volume_test_objects vol_left_temple_elev_bottom (players)) (volume_test_objects vol_left_temple_elev_top (players)))))
		((AND (= temple_player 1) (= temple_lift 1)) (sleep_until (OR (volume_test_objects vol_left_temple_elev_bottom (players)) (volume_test_objects vol_left_temple_elev_top (players)))))
	)
	(sleep 1)
)

;Script for tower elevator (where you go to the second level for the first time)
(global short tower_player 0)
(global short tower_lift 0)
(script static void tower_locations
	(cond
		((volume_test_objects vol_tower_elev_bottom (players)) (set tower_player 0))
		((volume_test_objects vol_tower_elev_top (players)) (set tower_player 1))
		((volume_test_objects vol_left_tower_elev_bottom (players)) (set tower_player 2))
		((volume_test_objects vol_left_tower_elev_top (players)) (set tower_player 3))
		(TRUE (set tower_player 4))
	)
	(cond
		((= (device_get_position elev_tower) .004) (set tower_lift 1))
		((= (device_get_position elev_tower) 1) (set tower_lift 0))
		((or (!= (device_get_position elev_tower) .004) (!= (device_get_position elev_tower) 1)) (set tower_lift 2))
	)
)
(script continuous tower_mover
	(sleep_until (OR (OR (volume_test_objects vol_left_tower_elev_bottom (players)) (volume_test_objects vol_left_tower_elev_top (players))) (OR (volume_test_objects vol_tower_elev_bottom (players)) (volume_test_objects vol_tower_elev_top (players)))))
	(tower_locations)
	(sleep 1)
	(cond
		((AND (= tower_player 0) (= tower_lift 0)) (device_set_position elev_tower .004))
;		((AND (= tower_player 1) (= tower_lift 1)) (device_set_position elev_tower 1))
		((AND (!= tower_lift 0) (= tower_player 2)) (device_set_position elev_tower 1))
		((AND (!= tower_lift 1) (= tower_player 3)) (device_set_position elev_tower .004))
	)
	(sleep 1)
	(sleep_until (OR (OR (volume_test_objects vol_left_tower_elev_bottom (players)) (volume_test_objects vol_left_tower_elev_top (players))) (OR (volume_test_objects vol_tower_elev_bottom (players)) (volume_test_objects vol_tower_elev_top (players)))))
	(cond
		((AND (= tower_player 0) (= tower_lift 0)) (sleep_until (OR (volume_test_objects vol_left_tower_elev_bottom (players)) (volume_test_objects vol_left_tower_elev_top (players)))))
		((AND (= tower_player 1) (= tower_lift 1)) (sleep_until (OR (volume_test_objects vol_left_tower_elev_bottom (players)) (volume_test_objects vol_left_tower_elev_top (players)))))
	)
	(sleep 1)
)


;-------------------------------------------------------------------------------
;Arranging BSPs in reverse order, so 1 can wake 2, and 2 can wake 3


;-------------------------------------------------------------------------------
;BSP 3
;-------------------------------------------------------------------------------

;Kill zone for BSP 3
(script continuous bsp3_killer_01
	(if (= (volume_test_objects kill_vol_04 (players)) TRUE)
		(if (= (volume_test_object kill_vol_04 (list_get (players) 0)) TRUE)
			(unit_kill (unit (list_get (players) 0)))
			(unit_kill (unit (list_get (players) 1)))
		)
	)
)


;-------------------------------------------------------------------------------
;Final elevator tower

;Placing guards
(script dormant place_finaltower_enemies
	(sleep_until (= (volume_test_objects vol_reached_3 (players)) TRUE))
	(game_save_no_timeout)
	(ai_place final_tower_elites)
	(ai_place final_tower_grunts)
	(wake dlg_cort_elevup_00)
	(sleep_until (< (ai_living_count final_tower) 3))
	(ai_set_orders final_tower final_tower_retreat)
)


;-------------------------------------------------------------------------------
;First plate

;Waking sleepers if patrolmen are alerted
(script dormant wake_plate1_sleepers
	(ai_set_blind plate1_sleepers_01 0)
	(ai_set_blind plate1_sleepers_02 0)
)
;Variables for looping patrols
(global short waker_status 0)
(global short waker_status02 0)
;Putting sleepers to sleep
(script continuous plate1_sleep_fuck01a
	(sleep_until (= (structure_bsp_index) 2))
	(custom_animation (unit (ai_get_object plate1_sleepers_01/sleeper00)) objects\characters\grunt\grunt "asleep:pistol:idle:var0" TRUE)
	(sleep 60)
)
(script continuous plate1_sleep_fuck01b
	(sleep_until (= (structure_bsp_index) 2))
	(custom_animation (unit (ai_get_object plate1_sleepers_01/sleeper01)) objects\characters\grunt\grunt "asleep:pistol:idle:var0" TRUE)
	(sleep 60)
)
(script command_script sleep_plate1_sleepers
	(cs_abort_on_alert TRUE)
	(ai_set_blind plate1_sleepers_01 1)
	(cs_pause -1)
)
;Putting sleepers to sleep again after elite leaves
(script command_script goback_plate1_sleepers00
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to bsp3_plate1/p0)
	(ai_set_blind plate1_sleepers_01 1)
	(wake plate1_sleep_fuck01a)
	(cs_pause -1)
)
(script command_script goback_plate1_sleepers01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to bsp3_plate1/p1)
	(ai_set_blind plate1_sleepers_01 1)
	(wake plate1_sleep_fuck01b)
	(cs_pause -1)
)
(script static void timeout
	(ai_set_orders plate1_sleepers_01 plate1_patrol_01)	
	(cs_run_command_script plate1_sleepers_01/sleeper00 goback_plate1_sleepers00)
	(cs_run_command_script plate1_sleepers_01/sleeper01 goback_plate1_sleepers01)
)
;Elite on patrol, wakes sleeping grunts when found
(script command_script waker01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to bsp3_plate1/p9)
	(cs_go_to bsp3_plate1/p3)
	(cs_go_to bsp3_plate1/p6)
	(cs_go_to bsp3_plate1/p3)
	(cs_go_to bsp3_plate1/p10)
	(cs_go_to bsp3_plate1/p8)
	(cs_go_to bsp3_plate1/p4)
	(cs_aim TRUE bsp3_plate1/p0)
	(cs_pause 1)
	(cs_aim TRUE bsp3_plate1/p0)
	(sleep_forever plate1_sleep_fuck01a)
	(sleep_forever plate1_sleep_fuck01b)
	(ai_set_blind plate1_sleepers_01 0)
	(ai_set_orders plate1_sleepers_01 test_wake_01)
	(cs_pause 2)
	(cs_aim FALSE bsp3_plate1/p0)
	(cs_go_to bsp3_plate1/p2)
	(timeout)
	(set waker_status 1)
)
(script continuous check_waker01
	(sleep_until (= waker_status 1))
	(set waker_status 0)
	(cs_run_command_script plate1_guards_01/guard01 waker01)
)
;Sleepers on the other side
(script continuous plate1_sleep_fuck02a
	(sleep_until (= (structure_bsp_index) 2))
	(custom_animation (unit (ai_get_object plate1_sleepers_02/sleeper00)) objects\characters\grunt\grunt "asleep:pistol:idle:var0" TRUE)
	(sleep 60)
)
(script continuous plate1_sleep_fuck02b
	(sleep_until (= (structure_bsp_index) 2))
	(custom_animation (unit (ai_get_object plate1_sleepers_02/sleeper01)) objects\characters\grunt\grunt "asleep:pistol:idle:var0" TRUE)
	(sleep 60)
)
(script command_script sleep_plate1_sleepers02
	(cs_abort_on_alert TRUE)
	(ai_set_blind plate1_sleepers_02 1)
	(cs_pause -1)
)
;Causes them to go back after elite has woken them
(script command_script goback_plate1_sleepers00too
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to bsp3_plate1/p15)
	(ai_set_blind plate1_sleepers_02 1)
	(wake plate1_sleep_fuck02a)
	(cs_pause -1)
)
(script command_script goback_plate1_sleepers01too
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to bsp3_plate1/p16)
	(ai_set_blind plate1_sleepers_02 1)
	(wake plate1_sleep_fuck02b)
	(cs_pause -1)
)
(script static void timeout02
	(ai_set_orders plate1_sleepers_02 plate1_patrol_01)	
	(cs_run_command_script plate1_sleepers_02/sleeper00 goback_plate1_sleepers00too)
	(cs_run_command_script plate1_sleepers_02/sleeper01 goback_plate1_sleepers01too)
)
;Other elite on patrol, wakes sleeping grunts when found
(script command_script waker02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to bsp3_plate1/p13)
	(cs_aim TRUE bsp3_plate1/p15)
	(cs_pause 1)
	(sleep_forever plate1_sleep_fuck02a)
	(sleep_forever plate1_sleep_fuck02b)
	(ai_set_blind plate1_sleepers_02 0)
	(ai_set_orders plate1_sleepers_02 test_wake_02)
	(cs_pause 2)
	(cs_aim FALSE bsp3_plate1/p15)
	(cs_go_to bsp3_plate1/p8too)
	(timeout02)
	(cs_go_to bsp3_plate1/p10too)
	(cs_go_to bsp3_plate1/p3too)
	(cs_go_to bsp3_plate1/p11)
	(cs_go_to bsp3_plate1/p3too)
	(cs_go_to bsp3_plate1/p9too)
	(cs_go_to bsp3_plate1/p2too)
	(set waker_status02 1)
)
(script continuous check_waker02
	(sleep_until (= waker_status02 1))
	(set waker_status02 0)
	(cs_run_command_script plate1_guards_01/guard02 waker02)
)
;Scripts to wake alerted guys and shuts off associated scripts
(script dormant plate1_sleep_fuckers_01_alert
	(sleep_until (> (ai_combat_status plate1_sleepers_01) ai_combat_status_idle))
	(sleep_forever plate1_sleep_fuck01a)
	(sleep_forever plate1_sleep_fuck01b)
	(ai_set_blind plate1_sleepers_01 0)
	(ai_set_orders plate1_sleepers_01 plate1_attack)
)
(script dormant plate1_sleep_fuckers_02_alert
	(sleep_until (> (ai_combat_status plate1_sleepers_02) ai_combat_status_idle))
	(sleep_forever plate1_sleep_fuck02a)
	(sleep_forever plate1_sleep_fuck02b)
	(ai_set_blind plate1_sleepers_02 0)
	(ai_set_orders plate1_sleepers_02 plate1_attack)
)
(script dormant plate1_guards_01_alert
	(sleep_until (> (ai_combat_status plate1_guards_01) ai_combat_status_idle))
	(sleep_forever check_waker01)
	(ai_set_orders plate1_guards_01 plate1_attack)
)
;Places sleepers, patrolmen, and plate3 snipers
(script dormant place_firstplate_enemies
	(sleep_until (= (volume_test_objects vol_reach_firstplate (players)) TRUE))
	(game_save_no_timeout)
	(ai_place plate1_guards_01)
	(cs_run_command_script plate1_guards_01/guard01 waker01)
	(wake check_waker01)
	(cs_run_command_script plate1_guards_01/guard02 waker02)
	(wake check_waker02)
	(ai_place plate1_sleepers_01)
	(cs_run_command_script plate1_sleepers_01 sleep_plate1_sleepers)
	(ai_place plate1_sleepers_02)
	(cs_run_command_script plate1_sleepers_02 sleep_plate1_sleepers02)
	(wake plate1_sleep_fuck01a)
	(wake plate1_sleep_fuck01b)
	(wake plate1_sleep_fuck02a)
	(wake plate1_sleep_fuck02b)
	(wake plate1_sleep_fuckers_01_alert)
	(wake plate1_sleep_fuckers_02_alert)
	(wake plate1_guards_01_alert)
	(ai_place plate3_snipers)
	(object_create parked_dropship)
	;sleep until get out to temple (come up with a better way to do this one)
	(sleep_until (= (volume_test_objects vol_bsp3_plate01 (players)) TRUE))
	(sleep_until (= (objects_can_see_flag (players) temple_door 20) TRUE))
	(wake dlg_cort_templeview_00)
)


;-------------------------------------------------------------------------------
;Second plate

;Causes latecomers to march toward temple
;(script command_script march_upper
;	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_abort_on_alert TRUE)
;	(cs_go_to march_upper/p0)
;	(cs_go_to march_upper/p1)
;	(cs_go_to march_upper/p2)
;	(cs_go_to march_upper/p3)
;	(cs_go_to march_upper/p4)
;	(cs_go_to march_upper/p5)
;	(cs_go_to march_upper/p6)
;	(cs_go_to march_upper/p7)
;	(cs_go_to march_upper/p8)
;	(cs_go_to march_upper/p9)
;	(cs_go_to march_upper/p10)
;)
;(script command_script march_lower01
;	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_abort_on_alert TRUE)
;	(cs_go_to march_lower/p0)
;	(cs_go_to march_lower/p1)
;	(cs_go_to march_lower/p2)
;	(cs_go_to march_lower/p3)
;	(cs_go_to march_lower/p4)
;	(cs_go_to march_lower/p5)
;)	
;(script command_script march_lower02
;	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_abort_on_alert TRUE)
;	(cs_go_to march_lower/p6)
;	(cs_go_to march_lower/p7)
;	(cs_go_to march_lower/p8)
;	(cs_go_to march_lower/p9)
;	(cs_go_to march_lower/p10)
;)
;Variable to tell when latecomers have arrived	
(global short latecomers_arrived 0)
;Dropship flies in to deposit latecomers
(script command_script late_dropship_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1.0)
	(cs_fly_by bsp3_airspace/p1 3)
	(cs_fly_by bsp3_airspace/p2 3)
	(cs_fly_by bsp3_airspace/p3 3)
	(cs_vehicle_speed .5)
	(cs_fly_to bsp3_airspace/p4 3)
	(ai_vehicle_exit plate2_dropship)
	(ai_vehicle_exit plate2_latecomers_p)	
	(ai_vehicle_exit plate2_latecomers_e)	
	(ai_vehicle_exit plate2_latecomers_j)	
	(set latecomers_arrived 1)
)
;Places dropship and latecomers in it
(script dormant place_secondplate_enemies
	(sleep_until (= (volume_test_objects vol_bsp3_plate02a (players)) TRUE))
	(game_save_no_timeout)
;	(ai_place plate2_dropship)
	(object_create temp_phantom)
	(ai_place plate2_latecomers_p)
	(ai_place plate2_latecomers_e)
	(ai_place plate2_latecomers_j)
;	(ai_place_in_vehicle plate2_latecomers plate2_dropship)
;	(cs_run_command_script plate2_dropship late_dropship_arrives)
	(wake dlg_cort_marchers_00)
;	(sleep_until (= latecomers_arrived 1))
;	(cs_run_command_script plate2_latecomers/prophet01 march_upper)
;	(cs_run_command_script plate2_latecomers/guard01 march_lower01)
;	(sleep 120)
;	(cs_run_command_script plate2_latecomers/prophet02 march_upper)
;	(cs_run_command_script plate2_latecomers/guard02 march_lower02)
;	(sleep 120)
;	(cs_run_command_script plate2_latecomers/prophet03 march_upper)
;	(cs_run_command_script plate2_latecomers/guard03 march_lower01)
;	(sleep 120)
;	(cs_run_command_script plate2_latecomers/prophet04 march_upper)
;	(cs_run_command_script plate2_latecomers/guard04 march_lower02)
	;sleep until see some marchers or shuttle (waiting until this ain't a hack)
	(sleep 120)
	(wake dlg_cort_marchers_01)
)


;-------------------------------------------------------------------------------
;Third plate

;Placing enemies on third plate
(script dormant place_thirdplate_enemies
	(sleep_until (= (volume_test_objects vol_bsp3_plate03a (players)) TRUE))
	(game_save_no_timeout)
	(ai_place plate3_guards_e)
	(ai_place plate3_guards_g)
	(sleep_until (> (ai_combat_status plate3_guards) ai_combat_status_idle))
	(ai_place plate3_reinforce_e)
	(ai_place plate3_reinforce_j)
;	(sleep_until (< (ai_living_count plate3_reinforce) 3))
;	(ai_place plate3_reinforce_h)
)


;-------------------------------------------------------------------------------
;Fourth plate

;Placing enemies on fourth plate
;(script dormant place_fourthplate_enemies
;	(sleep_until (= (volume_test_objects vol_??? (players)) TRUE))
;	(game_save_no_timeout)
;	(print "Fourth plate guys spawn!")
;	(ai_place fourth_plate_guards)
;)


;-------------------------------------------------------------------------------
;Temple

;TBD


;-------------------------------------------------------------------------------
;Startup script for BSP 3

;Wakes all BSP 3 scripts
(script dormant bsp3_startup
	(device_set_position elev_up .8511)
	(wake temple_mover)
;	(wake place_finaltower_enemies)
;	(wake place_firstplate_enemies)
;	(wake place_secondplate_enemies)
;	(wake place_thirdplate_enemies)
;	(wake place_fourthplate_enemies)
;	(wake place_temple_enemies)
	(wake bsp3_killer_01)
)


;-------------------------------------------------------------------------------
;Script to switch from BSP 2 to BSP 3

;Script for elevator going up to BSP 3
(global short bsp2switcher_player 0)
(global short bsp2switcher_lift 0)
(script static void bsp2switcher_locations
	(cond
		((volume_test_objects vol_on_elev_up (players)) (set bsp2switcher_player 0))
		((volume_test_objects vol_left_bsp2switcher_bottom01 (players)) (set bsp2switcher_player 1))
		((volume_test_objects vol_left_bsp2switcher_bottom02 (players)) (set bsp2switcher_player 1))
		((volume_test_objects vol_left_bsp2switcher_bottom03 (players)) (set bsp2switcher_player 1))
		(TRUE (set bsp2switcher_player 2))
	)
	(cond
		((= (device_get_position elev_up) .8511) (set bsp2switcher_lift 1))
		((= (device_get_position elev_up) 0) (set bsp2switcher_lift 0))
		((or (!= (device_get_position elev_up) 0) (!= (device_get_position elev_up) .8511)) (set bsp2switcher_lift 2))
	)
)
(script continuous bsp2switcher_mover
	(sleep_until (OR (OR (volume_test_objects vol_on_elev_up (players)) (volume_test_objects vol_left_bsp2switcher_bottom01 (players))) (OR (volume_test_objects vol_left_bsp2switcher_bottom02 (players)) (volume_test_objects vol_left_bsp2switcher_bottom03 (players)))))
	(bsp2switcher_locations)
	(sleep 1)
	(cond
		((AND (= bsp2switcher_player 0) (= bsp2switcher_lift 0)) (device_set_position elev_up .8511))
		((AND (!= bsp2switcher_lift 0) (= bsp2switcher_player 1)) (device_set_position elev_up 0))
	)
	(sleep 1)
)
;Script to wake BSP 3 startup
(script dormant going_up
	(sleep_until (= (volume_test_objects vol_on_elev_up_forsure (players)) TRUE))
	(sleep_until (= (structure_bsp_index) 2))
	(wake bsp3_startup)
)


;-------------------------------------------------------------------------------
;BSP 2
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;Entry tunnel

;Placing enemies for entry tunnel
(script dormant place_entrytunnel_enemies
	(ai_place entry_tunnel_patrol_e)
	(ai_place entry_tunnel_patrol_j)
	(sleep_until (= (volume_test_objects vol_reached_2 (players)) TRUE))
	(game_save_no_timeout)
	(wake dlg_cort_sunkhall_00)
)


;-------------------------------------------------------------------------------
;Sunken chamber

;Hides and destroys vulnerable guys on opposite side from player
(script dormant hide_holoside_guys
	(ai_set_orders sunken_holoside_nonsnipers sunken_holoside_hide)
	(sleep_until (volume_test_objects_all vol_holoside_hide (ai_actors sunken_holoside_nonsnipers)))
	(ai_erase sunken_holoside_nonsnipers)
)
(script dormant hide_viewside_guys
	(ai_set_orders sunken_viewside_nonsnipers sunken_viewside_hide)
	(sleep_until (volume_test_objects_all vol_viewside_hide (ai_actors sunken_viewside_nonsnipers)))
	(ai_erase sunken_viewside_nonsnipers)
)
;Making jackals focus on the hologram
(script command_script sunken_hologram_focus
	(cs_abort_on_alert TRUE)
	(cs_aim TRUE look_targets/big_head)
	(cs_pause -1)
)
(script command_script sunken_drop_down_90
	(cs_move_in_direction 90 2 0)
	(sleep 1)
)
(script command_script sunken_drop_down_270
	(cs_move_in_direction 270 2 0)
	(sleep 1)
)
;Monitors guys on viewside of chamber
(script dormant monitor_sunken_viewside
	(sleep_until (AND (> (ai_combat_status sunken_viewside) ai_combat_status_idle) (< (ai_strength sunken_viewside) .5)))
	(cond
		((OR (= (volume_test_objects vol_sunk_viewside_01 (players)) TRUE) (= (volume_test_objects vol_sunk_viewside_02 (players)) TRUE)) 
			(begin 
				(ai_place sunken_viewside_reinforce_e)
				(ai_place sunken_viewside_reinforce_g)
				(ai_place sunken_viewside_reinforce_j)
			)
		)
		(TRUE 
			(begin
				(ai_place sunken_viewside_snipers_01)
				(ai_place sunken_viewside_snipers_02)
				(cs_run_command_script sunken_viewside_snipers_02/go90_01 sunken_drop_down_90)
				(cs_run_command_script sunken_viewside_snipers_02/go90_02 sunken_drop_down_90)
				(cs_run_command_script sunken_viewside_snipers_02/go270_01 sunken_drop_down_270)
				(cs_run_command_script sunken_viewside_snipers_02/go270_02 sunken_drop_down_270)
;				(wake hide_viewside_guys)
			)
		)
	)
)
;Monitors guys on holoside of chamber
(script dormant monitor_sunken_holoside
	(sleep_until (AND (> (ai_combat_status sunken_holoside) ai_combat_status_idle) (< (ai_strength sunken_holoside) .5)))
	(cond
		((OR (= (volume_test_objects vol_sunk_holoside_01 (players)) TRUE) (= (volume_test_objects vol_sunk_holoside_02 (players)) TRUE)) 
			(begin 
				(ai_place sunken_holoside_reinforce_e)
				(ai_place sunken_holoside_reinforce_g)
				(ai_place sunken_holoside_reinforce_j)
			)
		)
		(TRUE 
			(begin
				(ai_place sunken_holoside_snipers_01)
				(ai_place sunken_holoside_snipers_02)
				(cs_run_command_script sunken_holoside_snipers_02/go90_01 sunken_drop_down_90)
				(cs_run_command_script sunken_holoside_snipers_02/go90_02 sunken_drop_down_90)
				(cs_run_command_script sunken_holoside_snipers_02/go270_01 sunken_drop_down_270)
				(cs_run_command_script sunken_holoside_snipers_02/go270_02 sunken_drop_down_270)
;				(wake hide_holoside_guys)
			)
		)
	)
)
;Placing enemies for sunken chamber
(script dormant place_chamber_enemies
	(sleep_until (= (volume_test_objects vol_enter_chamber (players)) TRUE))
	(game_save_no_timeout)
	(ai_place sunken_holoside_jackals_01)
	(ai_place sunken_holoside_jackals_02)
	(ai_place sunken_holoside_grunts_01)
	(ai_place sunken_holoside_grunts_02)
	(ai_place sunken_viewside_grunts_01)
	(ai_place sunken_viewside_grunts_02)
	(ai_place sunken_viewside_elites_01)
	(ai_place sunken_viewside_elites_02)
;	(ai_place sunken_hunters)
	(cs_run_command_script sunken_viewside_elites_01 sunken_hologram_focus)
	(cs_run_command_script sunken_viewside_elites_02 sunken_hologram_focus)
;	(cs_run_command_script sunken_hunters sunken_hologram_focus)
	(wake monitor_sunken_viewside)
	(wake monitor_sunken_holoside)
	;sleep until player sees main chamber
	(sleep_until (= (objects_can_see_flag (players) big_head 20) TRUE))
	(wake dlg_cort_sunkchamber_00)
	(sleep 150)
	(wake dlg_cort_sunkchamber_01)
)


;-------------------------------------------------------------------------------
;Exit tunnel

;Slams door once elites have retreated through
(script dormant slam_exit_tunnel_door
	(sleep_until (> (ai_combat_status exit_tunnel_patrol_e_01) ai_combat_status_idle))
	(cs_run_command_script exit_tunnel_patrol_e_01 sunken_drop_down_270)
	(sleep_until (= (volume_test_objects vol_on_elev_up (ai_actors exit_tunnel_patrol_e_01)) TRUE))
	(object_create exit_tunnel_door)
	(ai_set_orders exit_tunnel_patrol_e_01 exit_tunnel_attack05)
)
;Placing enemies for exit tunnel
(script dormant place_exittunnel_enemies
	(sleep_until (= (volume_test_objects vol_exit_chamber (players)) TRUE))
	(game_save_no_timeout)
	(ai_place sunken_reinforce_end_g)
	(ai_place sunken_reinforce_end_e)
	(ai_place sunken_reinforce_end_j)
	(ai_place exit_tunnel_patrol_g)
	(ai_place exit_tunnel_patrol_e_01)
	(ai_place exit_tunnel_patrol_e_02)
	(wake slam_exit_tunnel_door)
;	(cs_run_command_script exit_tunnel_patrol_e/doorman long_pause)
	(sleep_until (= (volume_test_objects vol_left_bsp2switcher_bottom03 (players)) TRUE))
	(ai_place exit_tunnel_reinforce)
	(sleep_until (= (ai_living_count exit_tunnel_all) 0))
	(device_set_power elev_bsp2switcher_switch_01 1)
	(device_set_power elev_bsp2switcher_switch_02 1)
	(device_set_power elev_bsp2switcher_switch_03 1)
	(device_set_power elev_bsp2switcher_switch_04 1)
;	(wake bsp2switcher_mover)
)


;-------------------------------------------------------------------------------
;Startup script for BSP 2

;Wakes all BSP 2 scripts
(script dormant bsp2_startup
	(wake place_entrytunnel_enemies)
	(wake place_chamber_enemies)
	(wake place_exittunnel_enemies)
)


;-------------------------------------------------------------------------------
;Script to switch from BSP 1 to BSP 2

;Script for elevator going down to BSP 2
(global short bsp1switcher_player 0)
(global short bsp1switcher_lift 0)
(script static void bsp1switcher_locations
	(cond
		((volume_test_objects vol_on_elev_under (players)) (set bsp1switcher_player 0))
		((volume_test_objects vol_left_bsp1switcher_top01 (players)) (set bsp1switcher_player 1))
		((volume_test_objects vol_left_bsp1switcher_top02 (players)) (set bsp1switcher_player 1))
		((volume_test_objects vol_left_bsp1switcher_top03 (players)) (set bsp1switcher_player 1))
		((volume_test_objects vol_left_bsp1switcher_top04 (players)) (set bsp1switcher_player 1))
		(TRUE (set bsp1switcher_player 2))
	)
	(cond
		((= (device_get_position elev_under) 0.0035) (set bsp1switcher_lift 1))
		((= (device_get_position elev_under) 1) (set bsp1switcher_lift 0))
		((or (!= (device_get_position elev_under) 0.0035) (!= (device_get_position elev_under) 1)) (set bsp1switcher_lift 2))
	)
)
(script continuous bsp1switcher_mover
	(sleep_until (OR (volume_test_objects vol_on_elev_under (players)) (OR (OR (volume_test_objects vol_left_bsp1switcher_top01 (players)) (volume_test_objects vol_left_bsp1switcher_top02 (players))) (OR (volume_test_objects vol_left_bsp1switcher_top03 (players)) (volume_test_objects vol_left_bsp1switcher_top04 (players))))))
	(bsp1switcher_locations)
	(sleep 1)
	(cond
		((AND (= bsp1switcher_player 0) (= bsp1switcher_lift 0)) (device_set_position elev_under 0.0035))
		((AND (!= bsp1switcher_lift 0) (= bsp1switcher_player 1)) (device_set_position elev_under 1))
	)
	(sleep 1)
)
;Script to wake BSP 2 startup
(script dormant going_down
;temp
;	(sleep_until (AND (= (volume_test_objects vol_on_elev_under (players)) TRUE) (= (ai_living_count elev_tower_all) 0)))
;	(end_segment)
	
	(sleep_until (= (volume_test_objects vol_on_elev_under_forsure (players)) TRUE))
	(sleep_until (= (structure_bsp_index) 1))
	(device_set_position elev_under 0.0035)
	(wake bsp2_startup)
)


;-------------------------------------------------------------------------------
;BSP 1
;-------------------------------------------------------------------------------

;Kill zones for BSP 1
(script continuous bsp1_killer_01
	(if (= (volume_test_objects kill_vol_01 (players)) TRUE)
		(if (= (volume_test_object kill_vol_01 (list_get (players) 0)) TRUE)
			(unit_kill (unit (list_get (players) 0)))
			(unit_kill (unit (list_get (players) 1)))
		)
	)
)
(script continuous bsp1_killer_02
	(if (= (volume_test_objects kill_vol_02 (players)) TRUE)
		(if (= (volume_test_object kill_vol_02 (list_get (players) 0)) TRUE)
			(unit_kill (unit (list_get (players) 0)))
			(unit_kill (unit (list_get (players) 1)))
		)
	)
)
(script continuous bsp1_killer_03
	(if (= (volume_test_objects kill_vol_03 (players)) TRUE)
		(if (= (volume_test_object kill_vol_03 (list_get (players) 0)) TRUE)
			(unit_kill (unit (list_get (players) 0)))
			(unit_kill (unit (list_get (players) 1)))
		)
	)
)


;-------------------------------------------------------------------------------
;Outdoor park

;Dropship patrol after initial investigation
(global short dropship_patrol_status01 0)
(script command_script dropship_patrol01
;	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .55)
	(cs_fly_by bsp1_airspace/p11 5)
	(cs_fly_by bsp1_airspace/p12 5)
	(cs_fly_by bsp1_airspace/p15 5)
	(cs_fly_by bsp1_airspace/p16 5)
	(cs_fly_by bsp1_airspace/p9 5)
	(cs_fly_by bsp1_airspace/p10 5)
	(set dropship_patrol_status01 1)
)
(script continuous check_dropship_patrol01
	(sleep_until (= dropship_patrol_status01 1))
	(set dropship_patrol_status01 0)
	(cs_run_command_script park_dropship01/driver dropship_patrol01)
)
;Sleeping patrol scripts if guy(s) are dead
(script dormant dropship_patrol_killer01
	(sleep_until (= (ai_living_count park_dropship01) 0))
	(sleep_forever check_dropship_patrol01)
)
;Script to make watchtower guys look in specific directions
(script command_script test_lookers
	(cs_abort_on_alert TRUE)
	(cs_aim TRUE look_targets/tower_right)
	(cs_pause -1)
)
(script command_script test_lookers2
	(cs_abort_on_alert TRUE)
	(cs_aim TRUE look_targets/tower_left)
	(cs_pause -1)
)
(script continuous switch_look_01
	(cs_run_command_script park_watchers_01/watcher01 test_lookers)
	(sleep 180)
	(cs_run_command_script park_watchers_01/watcher01 test_lookers2)
	(sleep 180)
)
(script dormant watchtower_killer01
	(sleep_until (= (ai_living_count park_watchers_01) 0))
	(sleep_forever switch_look_01)
)
;Temp scripts to make dropship paratroopers survive drop
(script dormant survive03
	(object_cannot_take_damage (ai_actors dropship_passengers03))
	(sleep 210)
	(object_can_take_damage (ai_actors dropship_passengers03))
)
(script dormant survive02
	(object_cannot_take_damage (ai_actors dropship_passengers02))
	(sleep 240)
	(object_can_take_damage (ai_actors dropship_passengers02))
)
(script dormant survive01
	(object_cannot_take_damage (ai_actors dropship_passengers01))
	(sleep 300)
	(object_can_take_damage (ai_actors dropship_passengers01))
)
;Initial dropship investigation of landing site
(script command_script dropship_investigate
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_by bsp1_airspace/p7 5)
	(cs_fly_by bsp1_airspace/p8 5)
	(cs_vehicle_speed .55)
	(cs_fly_by bsp1_airspace/p9 5)
	(cs_fly_by bsp1_airspace/p10 5)
	(cs_pause 4)
;	(cs_vehicle_speed .55)
	(cs_fly_to_and_face bsp1_airspace/p14 bsp1_airspace/p11 3)
	(ai_vehicle_exit dropship_passengers01)
	(wake survive01)
	(cs_pause 2)
	(cs_fly_by bsp1_airspace/p11 5)
	(cs_fly_by bsp1_airspace/p12 5)
	(ai_vehicle_exit dropship_passengers02)
	(wake survive02)	
	(cs_pause 2)
	(cs_fly_by bsp1_airspace/p15 5)
	(ai_vehicle_exit dropship_passengers03)
	(wake survive03)
	(cs_pause 2)
	(cs_fly_by bsp1_airspace/p16 5)
	(cs_fly_by bsp1_airspace/p9 5)
	(cs_pause 2)
	(cs_fly_by bsp1_airspace/p10 5)
	(wake check_dropship_patrol01)
	(wake dropship_patrol_killer01)
	(set dropship_patrol_status01 1)
)
;Scripts to engage patrol orders once jackals reach destinations
(script dormant patrol_starter_01
	(sleep_until (= (volume_test_objects vol_patrol_01 (ai_actors park_patrol_01)) TRUE))
	(ai_set_orders park_patrol_01 park_patrol_01)
)
(script dormant patrol_starter_02
	(sleep_until (= (volume_test_objects vol_patrol_02 (ai_actors park_patrol_02)) TRUE))
	(ai_set_orders park_patrol_02 park_patrol_02)
)
(script dormant patrol_starter_03
	(sleep_until (= (volume_test_objects vol_patrol_03 (ai_actors park_patrol_03)) TRUE))
	(ai_set_orders park_patrol_03 park_patrol_03)
)
(script dormant patrol_starter_04
	(sleep_until (= (volume_test_objects vol_patrol_04 (ai_actors park_patrol_04)) TRUE))
	(ai_set_orders park_patrol_04 park_patrol_04)
)
(script dormant patrol_starter_05
	(sleep_until (= (volume_test_objects vol_patrol_05 (ai_actors park_patrol_05)) TRUE))
	(ai_set_orders park_patrol_05 park_patrol_05)
)
;Placing initial enemies after intro cinematic
(script dormant place_initial_enemies
	(ai_place park_watchers_01)
	(wake switch_look_01)
	(wake watchtower_killer01)
	(ai_place park_dropship01)
	(ai_place_in_vehicle dropship_passengers01 park_dropship01)
	(ai_place_in_vehicle dropship_passengers02 park_dropship01)
	(ai_place_in_vehicle dropship_passengers03 park_dropship01)
	(cs_run_command_script park_dropship01/driver dropship_investigate)
	(ai_place park_patrol_01)
	(wake patrol_starter_01)
	(ai_place park_patrol_02)
	(wake patrol_starter_02)
	(ai_place park_patrol_03)
	(wake patrol_starter_03)
	(game_save_no_timeout)
	(wake dlg_cort_intro_01)
	(sleep 600)
	;maybe do a check to make sure the player hasn't already gotten in combat?
	(wake dlg_cort_intro_02)
	;wait until the player sees the watchtower
;	(sleep_until (= (objects_can_see_object (players) watch01 20) TRUE))
;	(wake dlg_cort_intro_04)
	(sleep_until (= (volume_test_objects vol_patrol_04 (players)) TRUE))
	(ai_place park_patrol_04)
	(wake patrol_starter_04)
	(ai_place park_patrol_05)
	(wake patrol_starter_05)
	(ai_place park_tunnel_elites)
	(ai_place park_tunnel_grunts)
	(ai_place park_tunnel_jackals)
)


;-------------------------------------------------------------------------------
;Complex approach

;Randomly spawning sniper targets
(global boolean place_more_targets TRUE)
(global short targets_placed 0)
(global short total_targets 2)
(script static void random_snipe_targets
	(begin_random
		(if place_more_targets
			(begin
				(ai_place snipe_target_02)
 				(set targets_placed (+ 1 targets_placed))
 				(if (= targets_placed total_targets) (set place_more_targets FALSE))
			)
		)
;		(if place_more_targets
;			(begin
;				(ai_place snipe_target_07)
;				(set targets_placed (+ 1 targets_placed))
 ;				(if (= targets_placed total_targets) (set place_more_targets FALSE))
;			)
;		)
		(if place_more_targets
			(begin
				(ai_place snipe_target_05)
				(set targets_placed (+ 1 targets_placed))
 				(if (= targets_placed total_targets) (set place_more_targets FALSE))
			)
		)
		(if place_more_targets
			(begin
				(ai_place snipe_target_03)
 				(set targets_placed (+ 1 targets_placed))
 				(if (= targets_placed total_targets) (set place_more_targets FALSE))
			)
		)
	)
)
;Temporarily gets buggers into view when spawned
(script command_script go_left
	(cs_move_in_direction 0 2 0)
)
(script command_script go_right
	(cs_move_in_direction 180 2 0)
)
;Spawning more snipers if first two are alerted and killed
(script dormant place_approach_sniper_reinforce
	(sleep_until (AND (OR (< (ai_strength approach_bugs_01) 1) (< (ai_strength approach_bugs_02) 1)) (OR (> (ai_combat_status approach_bugs_01) ai_combat_status_idle) (> (ai_combat_status approach_bugs_02) ai_combat_status_idle))))
	(ai_place approach_bugs_reinforce)
	(cs_run_command_script approach_bugs_reinforce/left go_left)
	(cs_run_command_script approach_bugs_reinforce/right go_right)
)
;Placing sniper targets and counter-snipers
(script dormant temple_approach
	(sleep_until (= (volume_test_objects vol_complex_approach (players)) TRUE))
	(game_save_no_timeout)
	(device_set_position complex_entrance 1)
	(ai_place approach_bugs_01)
	(ai_place approach_bugs_02)
	(ai_place snipe_target_01)
	(ai_place snipe_target_04)
	(ai_place snipe_target_06)
	(random_snipe_targets)
	(wake place_approach_sniper_reinforce)
	;maybe do a check to see if the player is looking at the towers
	(sleep_until (= (objects_can_see_flag (players) complex_approach 45) TRUE))
	(wake dlg_cort_approach_00)
	(sleep 150)
	;maybe check again to see if you're in combat?
	(wake dlg_cort_approach_01)
)


;-------------------------------------------------------------------------------
;Tower 1 lower

;Shutting you inside once you enter
(script dormant closing_entryway
	(sleep_until (= (volume_test_objects vol_inside_complex (players)) TRUE))
;	(object_create trapped)
	(device_set_position complex_entrance 0)
	(volume_teleport_players_not_inside vol_inside_complex coop_entryway)
	(ai_erase park_all)
	(ai_erase approach_bugs_01)
	(ai_erase approach_bugs_02)
	(ai_erase approach_bugs_reinforce)
	(sleep_forever check_dropship_patrol01)
	(sleep_forever switch_look_01)
)
;Gets grunts off benches
(script command_script get_off_bench_left
	(cs_move_in_direction 0 .1 0)
)
(script command_script get_off_bench_front
	(cs_move_in_direction 90 .1 0)
)
;Scripts to check alert level of sleepers and jackals
(script dormant tower1_lower_grunts_alert
	(sleep_until (> (ai_combat_status tower1_lower_grunts) ai_combat_status_idle))
	(cs_run_command_script tower1_lower_grunts/bench_left get_off_bench_left)
	(cs_run_command_script tower1_lower_grunts/bench_front get_off_bench_front)
)
;temp
(script dormant tower1_lower_drop_alert
	(sleep_until (> (ai_combat_status tower1_lower_drop) ai_combat_status_idle))
	(ai_force_active tower1_drop_jackals TRUE)
	(ai_force_active tower1_drop_grunts TRUE)
)
(script dormant tower1_lower_halls_alert
	(sleep_until (> (ai_combat_status tower1_lower_halls) ai_combat_status_idle))
	(ai_force_active tower1_lower_elites TRUE)
	(ai_force_active tower1_lower_hall_grunts TRUE)
)
;Placing enemies for first interior and beyond
(script dormant place_complex_enemies
	(sleep_until (= (volume_test_objects vol_entering_complex (players)) TRUE))	
	(game_save_no_timeout)
	(ai_place tower1_lower_grunts)
	(ai_place tower1_lower_jackals)
	(ai_place tower1_lower_elites)
;	(cs_run_command_script tower1_lower_elites long_pause)
	(ai_place tower1_drop_jackals)
;	(cs_run_command_script tower1_drop_jackals long_pause)
	(ai_place tower1_drop_grunts)
;	(cs_run_command_script tower1_drop_grunts long_pause)
	(ai_place tower1_lower_hall_grunts)
	(wake closing_entryway)
	(wake tower1_lower_grunts_alert)
	(wake tower1_lower_drop_alert)
	(wake tower1_lower_halls_alert)
	(device_set_position_immediate tower1lower_left 1)
	(device_set_position_immediate tower1lower_right 1)
)


;-------------------------------------------------------------------------------
;Bridge 1 lower

;Spawning buggers on roof if you enter their territory or alert bridge1
(script dormant place_tower2_lower_roof
	(sleep_until (OR (= (volume_test_objects vol_on_tower2_mid (players)) TRUE) (> (ai_combat_status bridge1_lower_crossers) ai_combat_status_idle)))
	(ai_place bridge1_lower_buggers_01)
	(ai_place bridge1_lower_buggers_02)
)
;Spawning bugger snipers across the way if bridge alerted
(script dormant place_platform_lower
	(sleep_until (> (ai_combat_status bridge1_lower_crossers) ai_combat_status_idle))
	(ai_place platform_lower_bugs)
)
;Placing changing of the guard from tower 2 lower to tower 1 lower
(script dormant place_guardchange_enemies
	(sleep_until (= (volume_test_objects vol_on_bridge1_lower_all (players)) TRUE))
	(game_save_no_timeout)
	(ai_place bridge1_crossers_elites)
	(ai_place bridge1_crossers_jackals)
	(ai_place bridge1_crossers_grunts)
	(wake place_tower2_lower_roof)
	(wake place_platform_lower)
	;check to see if the player is facing crossers (the timing is messed right now because of the hack to get them to cross)
;	(sleep_until (= (objects_can_see_object (players) (list_get (ai_actors bridge1_crossers_elites) 0) 20) TRUE))
;	(wake dlg_cort_guardchange_00)
;	(sleep 90)
;	;check if the player killed the guys in the last room
;	(if (OR (< (ai_living_count tower1_lower_elites) 1) (OR (< (ai_living_count tower1_lower_grunts) 3) (< (ai_living_count tower1_lower_elites) 1)))
;		(begin
;			(wake dlg_cort_guardchange_01)
;		)
;	)
	(sleep_until (> (ai_combat_status bridge1_lower_crossers) ai_combat_status_idle))
	(ai_migrate snipe_target_01 bridge1_crossers_elites)
	(ai_migrate snipe_target_05 bridge1_crossers_jackals)
)


;-------------------------------------------------------------------------------
;Tower 2 lower

;Getting guys off elevator
(script command_script get_off_elev_tower
	(cs_move_in_direction 0 2 0)
)
;Placing enemies for second tower lower
(script dormant place_tower2_lower_enemies
	(sleep_until (= (volume_test_objects vol_on_bridge1_lower_end (players)) TRUE))
	(ai_place tower2_lower_grunts)
	(device_set_position_immediate tower2lower_left 1)
	(device_set_position_immediate tower2lower_right 1)
	(device_set_position_immediate tower2lower_mid 1)
	(sleep_until (= (volume_test_objects vol_save_tower2_lower (players)) TRUE))
	(game_save_no_timeout)

	;temp
	(ai_erase bridge1_lower_buggers_02)

	(sleep_until (OR (= (ai_living_count tower2_lower_grunts) 0) (AND (< (ai_strength tower2_lower_grunts) .5) (> (ai_combat_status tower2_lower_grunts) ai_combat_status_idle))))
	(device_set_position_immediate elev_tower .5)
	(device_set_position elev_tower 1.0)
	(ai_place tower2_lower_reinforce_elites)
	(ai_place tower2_lower_reinforce_jackals)
	(ai_place tower2_lower_reinforce_grunts)
	(sleep_until (= (device_get_position elev_tower) 1.0))
	(cs_run_command_script tower2_lower_reinforce_elites get_off_elev_tower)
	(cs_run_command_script tower2_lower_reinforce_jackals get_off_elev_tower)
	(cs_run_command_script tower2_lower_reinforce_grunts get_off_elev_tower)
	(ai_migrate tower2_lower_grunts tower2_lower_reinforce_grunts)
	(sleep_until (= (ai_living_count tower2_lower_all) 0)) 
	(device_set_power elev_tower_switch_01 1)
	(device_set_power elev_tower_switch_02 1)
;	(wake tower_mover)
)


;-------------------------------------------------------------------------------
;Lower tower killer

;Kills everything in lower towers once get to upper floors
(script dormant lower_level_killer
	(ai_erase bsp1_complex_lower)
)


;-------------------------------------------------------------------------------
;Tower 2 upper

;Make viewers stare at hologram
(script command_script look_hologram01
	(cs_abort_on_alert TRUE)
	(cs_look TRUE look_targets/holo1)
	(cs_pause -1)
)	
;Placing enemies for second tower upper
(script dormant place_tower2upper_enemies
	(sleep_until (= (volume_test_objects vol_enter_tower2_upper (players)) TRUE))
	(ai_place tower2_upper_jackals)
	(cs_run_command_script tower2_upper_jackals look_hologram01)
	(ai_place tower2_upper_patrol_elites)
	(ai_place tower2_upper_patrol_jackals)
	(ai_place tower2_upper_hall_grunts)
	(ai_place tower2_upper_hall_bugs)
	(device_set_position_immediate tower2upper_left 1)
	(device_set_position_immediate tower2upper_right 1)
;	(cs_run_command_script tower2_upper_hall_bugs long_pause)
	(wake lower_level_killer)
	(sleep_until (< (device_get_position elev_tower) .25))
	(game_save_no_timeout)
	;sleep until the player reaches the first level and sees hologram
	(sleep_until (AND (= (objects_can_see_flag (players) holo1 20) TRUE) (= (device_get_position elev_tower) .004)))
	(wake dlg_cort_speechreaction_00)
)


;-------------------------------------------------------------------------------
;Bridges upper

;Spawns buggers from tower1 roof if bridges are alerted or if player gets on roof
(script dormant place_tower1roof_enemies
	(sleep_until (OR (AND (= (volume_test_objects vol_bridge1_upper_all (players)) TRUE) (> (ai_combat_status bridge1_upper_all) ai_combat_status_idle)) (= (volume_test_objects vol_tower1_toproof (players)) TRUE)))
	(ai_place tower1_verytop_reinforce)
)
;Spawns buggers from tower3 roof if bridges are alerted
(script dormant place_tower3roof_enemies
	(sleep_until (AND (> (ai_combat_status bridge2_upper_all) ai_combat_status_idle) (= (volume_test_objects vol_bridge2_upper_all (players)) TRUE)))
	(ai_place tower3_verytop_reinforce)
	(sleep 30)
	(ai_place tower3_verytop_reinforce)
	(sleep 30)
	(ai_place tower3_verytop_reinforce)
	(sleep 30)
	(ai_place tower3_verytop_reinforce)
)
;Placing upper bridge enemies
(script dormant place_upperbridge_enemies
	(sleep_until (OR (= (volume_test_objects vol_tower2_upper_hall_L (players)) TRUE) (= (volume_test_objects vol_tower2_upper_hall_R (players)) TRUE)))
	(game_save_no_timeout)
	(ai_place bridge1_upper_elites)
	(ai_place bridge1_upper_bugs)
;	(cs_run_command_script bridge1_upper_bugs long_pause)
	(ai_place bridge2_upper_elites)
	(ai_place bridge2_upper_bugs)
;	(cs_run_command_script bridge2_upper_bugs long_pause)
	(ai_place bridge2_upper_grunts)
	(ai_place platform_upper_bugs)
	(wake place_tower1roof_enemies)
	(wake place_tower3roof_enemies)
	(sleep_until (= (volume_test_objects vol_bridge2_upper_all (players)) TRUE))
	(game_save_no_timeout)
)


;-------------------------------------------------------------------------------
;Tower 1 upper

;Make viewers stare at hologram
(script command_script look_hologram02
	(cs_abort_on_alert TRUE)
	(cs_look TRUE look_targets/holo2)
	(cs_pause -1)
)
;Placing enemies for first tower upper
(script dormant place_tower1upper_enemies
	(sleep_until (= (volume_test_objects vol_on_bridge1_upper_end (players)) TRUE))
	(ai_place tower1_upper_grunts_01)
;	(cs_run_command_script tower1_upper_grunts_01 long_pause)
	(ai_set_blind tower1_upper_grunts_01 1)
	(ai_place tower1_upper_grunts_02)
	(cs_run_command_script tower1_upper_grunts_02 look_hologram02)
	(ai_place tower1_upper_grunts_03)
	(ai_place tower1_upper_elites)
	(device_set_position_immediate tower1upper_left 1)
	(device_set_position_immediate tower1upper_right 1)	
;	(cs_run_command_script tower1_upper_elites long_pause)
	(sleep_until (= (volume_test_objects vol_save_tower1_upper (players)) TRUE))
	(game_save_no_timeout)
	;not sure how or where these next lines will go, for sure
	(sleep_until (= (objects_can_see_flag (players) holo2 20) TRUE))
	(wake dlg_cort_speechtrans_00)
	(sleep 300)
	(wake dlg_cort_speechtrans_01)
	(sleep 120)
	(wake dlg_cort_speechtrans_02)
	(sleep 120)
	(wake dlg_cort_speechtrans_03)
	(sleep 120)
	(wake dlg_cort_speechtrans_04)
	(sleep 180)
	(wake dlg_cort_speechtrans_05)
)


;-------------------------------------------------------------------------------
;Tower 3 upper

;Make viewers stare at hologram
(script command_script look_hologram03
	(cs_abort_on_alert TRUE)
	(cs_look TRUE look_targets/holo3)
	(cs_pause -1)
)
;Placing enemies for third tower upper
(script dormant place_tower3upper_enemies
	(sleep_until (= (volume_test_objects vol_on_bridge2_upper_end (players)) TRUE))
	(ai_place tower3_upper_bugs)
	(cs_run_command_script tower3_upper_bugs look_hologram03)
	(ai_place tower3_upper_grunts)
	(ai_place tower3_upper_elites_01)
	(ai_place tower3_upper_elites_02)
	(device_set_position_immediate tower3upper_right 1)
	(device_set_position_immediate tower3upper_left 1)
;	(cs_run_command_script tower3_upper_elites_01 long_pause)
;	(cs_run_command_script tower3_upper_elites_02 long_pause)
	(sleep_until (= (volume_test_objects vol_save_tower3_upper (players)) TRUE))
	(game_save_no_timeout)
)


;-------------------------------------------------------------------------------
;Central platform

;Destroys dropship after it has left
(script dormant kill_dropship
	(object_destroy (ai_vehicle_get platform_upper_dropship/dropship))
	(ai_erase platform_upper_dropship)
)
;Dropship arrival and cargo deposit
(script dormant deposit_cargo
	(vehicle_unload (ai_vehicle_get platform_upper_dropship/dropship) "phantom_sc")
;	(ai_place platform_upper_turrets)
	(ai_vehicle_enterable_team (ai_vehicle_get platform_upper_turrets/turret01) Covenant)
	(ai_vehicle_enterable_team (ai_vehicle_get platform_upper_turrets/turret02) Covenant)
	(vehicle_unload (ai_vehicle_get platform_upper_dropship/dropship) "phantom_p")
	(object_cannot_take_damage (ai_actors platform_upper_grunts))
	(sleep 60)
	(object_can_take_damage (ai_actors platform_upper_grunts))
)
(script command_script dropship_arrive
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .7)
	(cs_fly_by bsp1_airspace/p1 5)
	(cs_fly_to bsp1_airspace/p0 2)
	(cs_pause 1)
	(wake deposit_cargo)
	(cs_pause 3)
)
(script command_script dropship_depart
;	(cs_abort_on_alert TRUE)
	(cs_fly_by bsp1_airspace/p6 5)
	(cs_fly_by bsp1_airspace/p2 5)
	(cs_fly_by bsp1_airspace/p5 5)
;	(cs_fly_by bsp1_airspace/p3 5)
;	(cs_fly_to bsp1_airspace/p4 5)
	(wake kill_dropship)
)
;Places dropship and has it fly in to reinforce area
(script dormant place_platformupper_enemies
	(sleep_until (= (volume_test_objects vol_exit_tower3_upper (players)) TRUE))
	(game_save_no_timeout)
	(device_set_position_immediate elevtower_enter 1)
	(device_set_position_immediate elevtower_mid 1)
	(ai_place platform_upper_dropship)
;	(ai_place_in_vehicle platform_upper_hunters platform_upper_dropship)
;	(ai_place_in_vehicle platform_upper_grunts platform_upper_dropship)
	(cs_run_command_script platform_upper_dropship/dropship dropship_arrive)
	(wake dlg_cort_centralplat_00)
	(sleep 60)
	(ai_place platform_upper_grunts)
;	(ai_place platform_upper_hunters)
	(sleep_until (= (cs_command_script_running platform_upper_dropship dropship_arrive) FALSE))
	(cs_run_command_script platform_upper_dropship/dropship dropship_depart)
)


;-------------------------------------------------------------------------------
;First elevator tower

;Makes jackal movers face their crate
(script command_script jackal_crate_focus
	(cs_abort_on_alert TRUE)
	(cs_look TRUE look_targets/jackal_crate)
	(cs_pause -1)
)
;Makes grunt mover face his crate
(script command_script grunt_crate_focus
	(cs_abort_on_alert TRUE)
	(cs_look TRUE look_targets/grunt_crate)
	(cs_pause -1)
)
;Makes guys get off elevator
(script command_script get_off_elev_under
	(cs_move_in_direction 180 4 0)
)
;Placing enemies for elevator tower upper
(script dormant place_elevatortowerdown_enemies
	(sleep_until (= (volume_test_objects vol_enter_elevator_upper (players)) TRUE))
	(game_save_no_timeout)
	(device_set_position_immediate elev_under .75)
	(ai_place elev_tower_jackals)
	(ai_place elev_tower_grunts)
	(ai_place elev_tower_elites)
;	(cs_run_command_script elev_tower_elites long_pause)
	(wake dlg_cort_elevunder_00)
	(sleep_until (OR (AND (> (ai_combat_status elev_tower_all) ai_combat_status_idle) (< (ai_living_count elev_tower_all) 3)) (= (ai_living_count elev_tower_all) 0)))
	(ai_place elev_tower_reinforce_elites)
	(ai_place elev_tower_reinforce_jackals)
	(ai_place elev_tower_reinforce_grunts)
	(device_set_position elev_under 1)
	(sleep_until (= (device_get_position elev_under) 1))
	(cs_run_command_script elev_tower_reinforce_elites get_off_elev_under)
	(cs_run_command_script elev_tower_reinforce_jackals get_off_elev_under)
	(cs_run_command_script elev_tower_reinforce_grunts get_off_elev_under)
	(sleep_until (= (ai_living_count elev_tower_all) 0))
	(device_set_power elev_bsp1switcher_switch_01 1)
	(device_set_power elev_bsp1switcher_switch_02 1)
;	(wake bsp1switcher_mover)
)


;-------------------------------------------------------------------------------
;Clean-up scripts
;-------------------------------------------------------------------------------

;Killing leftovers from BSP 1
(script dormant kill_bsp1_leftovers
	(sleep_until (= (structure_bsp_index) 1))
	(ai_erase_all)
	
;temp
	(object_destroy elev_tower)
	(object_create elev_up)
	
	(sleep_forever dropship_patrol_killer01)
	(sleep_forever watchtower_killer01)
	(sleep_forever patrol_starter_01)
	(sleep_forever patrol_starter_02)
	(sleep_forever patrol_starter_03)
	(sleep_forever patrol_starter_04)
	(sleep_forever patrol_starter_05)
	(sleep_forever place_initial_enemies)
	(sleep_forever place_approach_sniper_reinforce)
	(sleep_forever temple_approach)
	(sleep_forever closing_entryway)
	(sleep_forever tower1_lower_grunts_alert)
	(sleep_forever tower1_lower_drop_alert)
	(sleep_forever tower1_lower_halls_alert)
	(sleep_forever place_complex_enemies)
	(sleep_forever place_tower2_lower_roof)
	(sleep_forever place_platform_lower)
	(sleep_forever place_guardchange_enemies)
	(sleep_forever place_tower2_lower_enemies)
	(sleep_forever place_tower2upper_enemies)
	(sleep_forever place_tower1roof_enemies)
	(sleep_forever place_tower3roof_enemies)
	(sleep_forever place_upperbridge_enemies)
	(sleep_forever place_tower1upper_enemies)
	(sleep_forever place_tower3upper_enemies)
	(sleep_forever place_platformupper_enemies)
	(sleep_forever place_elevatortowerdown_enemies)

	(sleep_forever check_dropship_patrol01)
	(sleep_forever switch_look_01)

	(sleep_forever tower_mover)
	(sleep_forever bsp1switcher_mover)

	(sleep_forever bsp1_killer_01)
	(sleep_forever bsp1_killer_02)
	(sleep_forever bsp1_killer_03)
)

;Killing leftovers from BSP 2
(script dormant kill_bsp2_leftovers
	(sleep_until (= (structure_bsp_index) 2))
	(ai_erase_all)
	
;temp
	(object_destroy elev_under)
	(object_destroy elev_tower)
	(object_create elev_temple)	
	
	(sleep_forever place_entrytunnel_enemies)
	(sleep_forever monitor_sunken_holoside)
	(sleep_forever monitor_sunken_viewside)
	(sleep_forever place_chamber_enemies)
	(sleep_forever slam_exit_tunnel_door)
	(sleep_forever place_exittunnel_enemies)
	
	(sleep_forever bsp2switcher_mover)
)


;-------------------------------------------------------------------------------
;REALLY temp stuff

(script dormant teleport_to_approach
	(object_teleport (list_get (players) 0) temp_approach_01)
	(object_teleport (list_get (players) 1) temp_approach_02)
)
(script dormant teleport_to_upper
	(device_set_position_immediate elev_tower .004)
	(object_teleport (list_get (players) 0) temp_upper_01)
	(object_teleport (list_get (players) 1) temp_upper_02)
)
(script dormant teleport_to_bsp2
	(switch_bsp 1)
	(object_create_anew elev_under)
	(device_set_position_immediate elev_under .0035)
	(object_create_anew elev_up)
	(object_teleport (list_get (players) 0) temp_bsp2_01)
	(object_teleport (list_get (players) 1) temp_bsp2_02)
	(sleep 30)
	(wake bsp2_startup)
)
(script dormant teleport_to_bsp3
	(switch_bsp 2)
	(object_create_anew elev_up)
	(object_create_anew elev_temple)
	(device_set_position_immediate elev_up .8511)
	(object_teleport (list_get (players) 0) temp_bsp3_01)
	(object_teleport (list_get (players) 1) temp_bsp3_02)
	(sleep 30)
	(wake bsp3_startup)
)


;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;Startup scripts
(script startup mission
	(ai_allegiance prophet covenant)	
	(ai_allegiance covenant prophet)	
;	(wake place_initial_enemies)
	;waking my leftover eliminators
	(wake kill_bsp1_leftovers)	
	(wake kill_bsp2_leftovers)	
	;sleeping sleep script hacks
	(sleep_forever check_waker01)
	(sleep_forever check_waker02)
	(sleep_forever plate1_sleep_fuck01a)
	(sleep_forever plate1_sleep_fuck01b)
	(sleep_forever plate1_sleep_fuck02a)
	(sleep_forever plate1_sleep_fuck02b)
	;putting my watchtower looking scripts to sleep until the guys are spawned
	(sleep_forever switch_look_01)
	;putting patrol scripts to sleep until encounters spawned
	(sleep_forever check_dropship_patrol01)
	;putting elevator scripts to sleep until you get close
	(sleep_forever tower_mover)
	(sleep_forever bsp1switcher_mover)
	(sleep_forever bsp2switcher_mover)
	(sleep_forever temple_mover)
	;putting BSP 3 kill zone to sleep for now
	(sleep_forever bsp3_killer_01)
	;waking scripts for trigger volumes for first bsp
	(wake temple_approach)
	(wake place_complex_enemies)
	(wake place_guardchange_enemies)
	(wake place_tower2_lower_enemies)
	(wake place_tower2upper_enemies)
	(wake place_upperbridge_enemies)
	(wake place_tower1upper_enemies)
	(wake place_tower3upper_enemies)
	(wake place_platformupper_enemies)
	(wake place_elevatortowerdown_enemies)
	(wake going_down)
	(wake going_up)
)
