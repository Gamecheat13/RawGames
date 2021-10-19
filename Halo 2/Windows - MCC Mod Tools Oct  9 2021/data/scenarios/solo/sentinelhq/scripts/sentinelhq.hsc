; stub scripts for cinematics -----------------------------------------

(script stub void x06
	(print "stub")
	)
	
(script stub void c06_intro
	(print "stub")
	)
	
;(script stub void c06_intra_1
;	(print "stub")
;	)
	
;(script stub void c06_intra_2
;	(print "stub")
;	)
	
(script stub void x07
	(print "stub")
	)

;----------------------------------------------------------------------


;(script dormant ai_kill

;	(print "ai_kill")

;	(ai_kill wall1_maj01_a_sent03)
;	(ai_kill wall1_maj00_maj01)
;	(ai_kill wall1_min01_sent01)
;	(ai_kill wall1_min01_sent02)
		
;	(ai_kill wall1_min01_sent03)

;	(ai_kill wall1_maj01_sent01)
	
;	(ai_kill wall1_maj01_maj01)
;)

;(script dormant wall1_cir_maj01

;	(sleep_until (volume_test_objects wall1_cir_maj01 (players))15)

;	(ai_place wall1_cir_maj01)

;)

;(script dormant game_save01

;	(sleep_until (volume_test_objects wall1_maj01_ent (players))15)

;	(game_save_unsafe);SSSAAAVVVEEE---

;)

;(script dormant wall1_maj03_sent01

;	(sleep_until (volume_test_objects wall1_maj03_sent01 (players))15)
	
;	(wake ai_kill);wake

;	(ai_place wall1_maj03_sent01)
	
;)

;(script command_script cs_wall1_min02_sent02

;	(cs_fly_to_and_face wall1_min02_sent02/p0 wall1_min02_sent02/p1 )	
;	(cs_fly_to_and_face wall1_min02_sent02/p1 wall1_min02_sent02/p2 1)	
;)

;(script static void dtest06
	
;	(sleep 10)
	
;	(ai_erase wall1_min02_sent02)
	
;	(sleep 15)
	
;	(ai_place wall1_min02_sent02)
	
;	(cs_run_command_script wall1_min02_sent02 cs_wall1_min02_sent02)
;)


;(script dormant wall1_min02_sent02

;	(sleep 15)
	
;	(ai_erase wall1_min02_sent02)
	
;	(sleep 15)
	
;	(ai_place wall1_min02_sent02)
	
;	(cs_run_command_script wall1_min02_sent02 cs_wall1_min02_sent02)
	
;	(wake wall1_maj03_sent01);wake
;)

;(script dormant wall1_min02_sent01

;	(sleep_until (volume_test_objects wall1_min02_sent (players))15)
	
;	(ai_place wall1_min02_sent01)
	
;	(wake wall1_min02_sent02);wake
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(script dormant wall1_maj02_sent01

;	(sleep_until (volume_test_objects wall1_maj02_sent01 (players))15)

;	(ai_place wall1_maj02_sent01)
	
;	(wake wall1_min02_sent01);wake
;)

;(script command_script cs_wall1_bz01_a_sent

;	(cs_fly_to_and_face wall1_bz01_a_sent/p1 wall1_bz01_a_sent/p1 1)
;	(cs_fly_to wall1_bz01_a_sent/p0 2)
;;	(cs_fly_to_and_face wall1_bz01_a_sent/p2 wall1_bz01_a_sent/p2 1)
;)

;(script continuous wall1_bz01_a_sent01_loop

;	(print "continuous running")
	
;	(sleep_until 
;		(not 
;			(cs_command_script_running wall1_bz01_a_sent01 cs_wall1_bz01_a_sent)
;		)
;	)
	
;	(print "script running")
	
;	(cs_run_command_script wall1_bz01_a_sent01 cs_wall1_bz01_a_sent)
;)

;(script static void dtest05

;	(ai_erase wall1_bz01_a_sent01)
	
;	(sleep 10)

;	(ai_place wall1_bz01_a_sent01)
	
;	(cs_run_command_script wall1_bz01_a_sent01 cs_wall1_bz01_a_sent)	
;)


;(script dormant wall1_bz01_sent01

;	(sleep_until (volume_test_objects wall1_bz01_sent01 (players))15)
	
;	(game_save_unsafe);SSSAAAVVVEEE---
	
;	(ai_place wall1_bz01_sent01)
	
;	(wake wall1_bz01_a_sent01_loop);wake
	
;	(wake wall1_maj02_sent01);wake
	
;	(sleep_until (volume_test_objects wall1_bz01_sent02 (players))15)
	
;	(ai_place wall1_bz01_sent02)
	
;	(sleep_until (volume_test_objects wall1_bz01_sent03 (players))15)
	
;	(ai_place wall1_bz01_sent03)
;)

;(script command_script cs_wall1_conduat02_a_sent03

;	(cs_fly_to wall1_conduat02_a_sent/p10 1)
;	(cs_fly_to_and_face wall1_conduat02_a_sent/p11 wall1_conduat02_a_sent/p12 1)
;	(cs_fly_to wall1_conduat02_a_sent/p12 1)
;	(cs_fly_to_and_face wall1_conduat02_a_sent/p9 wall1_conduat02_a_sent/p10 1)

;)

;(script continuous wall1_maj01_a_sent03_loop

;	(print "continuous running")
	
;	(sleep_until 
;		(not 
;			(cs_command_script_running wall1_maj01_a_sent03 cs_wall1_conduat02_a_sent03)
;		)
;	)
	
;	(print "script running")
	
;	(cs_run_command_script wall1_maj01_a_sent03 cs_wall1_conduat02_a_sent03)
;)

;(script static void dtest04

;	(ai_erase wall1_maj01_a_sent03)
	
;	(sleep 10)

;	(ai_place wall1_maj01_a_sent03)
	
;	(cs_run_command_script wall1_maj01_a_sent03 cs_wall1_conduat02_a_sent03)	
;)

;(script command_script cs_wall1_conduat02_a_sent02

;	(cs_fly_to wall1_conduat02_a_sent/p1 1)
;	(cs_fly_to wall1_conduat02_a_sent/p2 1)
;	(cs_fly_to_and_face wall1_conduat02_a_sent/p3 wall1_conduat02_a_sent/p4 1)
;	(cs_fly_to wall1_conduat02_a_sent/p4 1)
;	(cs_fly_to wall1_conduat02_a_sent/p5 1)
;	(cs_fly_to wall1_conduat02_a_sent/p6 1)
;	(cs_fly_to wall1_conduat02_a_sent/p7 1)
;	(cs_fly_to wall1_conduat02_a_sent/p7 1)
;	(cs_fly_to_and_face wall1_conduat02_a_sent/p8 wall1_min01_sent02/p0 1)
;	(cs_fly_to wall1_conduat02_a_sent/p0 1)
	
;)

;(script continuous wall1_maj01_a_sent02_loop

;	(print "continuous running")
	
;	(sleep_until 
;		(not 
;			(cs_command_script_running wall1_maj01_a_sent02 cs_wall1_conduat02_a_sent02)
;		)
;	)
	
;	(print "script running")
	
;	(cs_run_command_script wall1_maj01_a_sent02 cs_wall1_conduat02_a_sent02)
;)

;(script static void dtest03
;
;	(ai_erase wall1_maj01_a_sent02)
	
;	(sleep 10)

;	(ai_place wall1_maj01_a_sent02)
	
;	(cs_run_command_script wall1_maj01_a_sent02 cs_wall1_conduat02_a_sent02)
	
;)



;(script static void dtest02

;	(ai_erase wall1_maj01_a_sent01)
	
;	(sleep 10)

;	(ai_place wall1_maj01_a_sent01)
	
;	(cs_run_command_script wall1_maj01_a_sent01 cs_wall1_conduat02_a_sent)
	
;)

;(script dormant wall1_maj01_sent01

;	(sleep_until (volume_test_objects wall1_maj01 (players))15)
	
;	(ai_place wall1_min01_sent03)

;	(ai_place wall1_maj01_sent01)
	;
;	(ai_place wall1_maj01_maj01)
	
;	(ai_place wall1_maj01_a_sent01)
;	(ai_place wall1_maj01_a_sent02)
	
;	(wake wall1_maj01_a_sent01_loop);wake
;	(wake wall1_maj01_a_sent02_loop);wake
	
;	(wake wall1_bz01_sent01);wake
	
;)
	

;(script command_script cs_wall1_min01_sent02

;	(cs_fly_to_and_face wall1_min01_sent02/p0 wall1_min01_sent02/p1 1)
;	(cs_fly_to_and_face wall1_min01_sent02/p1 wall1_min01_sent02/p2 1)
;	(cs_fly_to_and_face wall1_min01_sent02/p1 wall1_min01_sent02/p3 1)
	
;)

;(script static void dtest01
	
;	(sleep 10)
	
;	(ai_place wall1_min01_sent02)
	
;	(cs_run_command_script wall1_min01_sent02/starting_locations_0 cs_wall1_min01_sent02)
;)


;(script dormant wall1_min01_sent01

;	(sleep_until (volume_test_objects wall1_min01_sent01 (players))15)
	
;	(ai_place wall1_min01_sent01)
	
;	(wake wall1_maj01_sent01);wake
	
;	(sleep_until (volume_test_objects wall1_min01_back (players))15)
	
;	(ai_place wall1_min01_sent02)
;	
;	(cs_run_command_script wall1_min01_sent02/starting_locations_0 cs_wall1_min01_sent02)
;)

;(script dormant wall1_maj00_maj01

;	(sleep_until (volume_test_objects wall1_maj01_ent (players))15)
	
;	(ai_place wall1_maj00_maj01)

;)

;(script command_script cs_wall1_ldg_b05_ldg02

;	(cs_fly_to_and_face wall1_ldg_b05_ldg/p1 wall1_ldg_b02/p2 1)
;)

;(script command_script cs_wall1_ldg_b05_ldg

;	(cs_fly_to_and_face wall1_ldg_b05_ldg/p0 wall1_ldg_b05_ldg/p2 1)
;)

;(script dormant wall1_ldg_b05_ldg
	
;	(sleep_until (volume_test_objects wall1_ldg_b05_ldg (players))15)

;	(ai_place wall1_ldg_b05_ldg)
;	(cs_run_command_script wall1_ldg_b05_ldg/starting_locations_0 cs_wall1_ldg_b05_ldg)
;	(cs_run_command_script wall1_ldg_b05_ldg/starting_locations_1 cs_wall1_ldg_b05_ldg02)
;)

;(script static void dtest01
	
;	(sleep 10)
	
;	(ai_place wall1_ldg_b01)
	
;	(cs_run_command_script wall1_ldg_b01 cs_wall1_ldg_b01)


;)


;(ai_magically_see_players <ai>)

(global boolean G_wall1_condLR_F02 false)

(global boolean G-defen-front-cave false)
(global boolean G-sen-interior-front-back false)
(global boolean G-asenfac-flood-wraith02 false)
(global boolean G-keyholder-back false)
(global boolean G-keyholder-front false)
(global boolean G-wall2-cond1-front-lr false)

(script dormant library-end
	
	(cinematic_fade_to_white)
	
	(if (cinematic_skip_start)
		(begin
			(X07)
		)
		(cinematic_skip_stop)
	)
	
	(game_won)
)

(script dormant library-dock02

	(sleep_until 
		(or
			(volume_test_objects library-dock02 (players))
			(volume_test_objects library-dock02-back (players))
			
		)
	15)
	
	(ai_place library-dock02-flood-m)



)


(script dormant library

	(sleep_until 
		(or   
			(volume_test_objects library (players))
			(volume_test_objects library02 (players))
		)
	15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake library-dock02);wake
	
	(ai_place library-dock-turrets)
	
	(ai_place library-flood01)
	
	(ai_place library-flood02-g)
	
	(sleep_until (volume_test_objects library-front (players))15)
	
	(ai_place library-flood03-g)
	
	(ai_place library-flood04-m)
	
	(ai_place library-back-turrets)
	
	(sleep_until 
		(or
			(volume_test_objects library-front-back (players))
			(<= (ai_living_count sg-library-front01) 2)
		)
	15)
	
	(ai_place library-flood05-m)

	(sleep_until (volume_test_objects library-middle (players))15)
	
	(ai_place library-middle-flood01-g)
	
	(ai_place library-middle-flood01-m)
	
	(sleep_until (volume_test_objects library-middle-back (players))15)


 	(ai_place library-back-flood01-m)
	(ai_place library-back-flood01-g)


	(sleep_until (volume_test_objects the-end (players))15)
	(ai_erase_all)
	
	(wake library-end);wake
)

(script dormant keyride-front01

	(sleep_until (volume_test_objects keyride-front01 (players))15)
	
	(ai_place keyride-front01)
	
	(sleep_until (volume_test_objects keyride-front02 (players))15)
	(ai_place keyride-front02)
	(ai_erase keyride-front01)
	
	(sleep_until (volume_test_objects keyride-middle01 (players))15)
	
	(ai_erase keyride-front02)
	(ai_place keyride-middle01)
	
	(sleep_until (volume_test_objects keyride-middle02 (players))15)
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_erase keyride-middle01)
	(ai_place keyride-middle02)
	
	(sleep_until (volume_test_objects keyride-up01 (players))15)
	(ai_erase keyride-middle02)
	(ai_place keyride-up01)
	
	(sleep_until (volume_test_objects keyride-up02 (players))15)
	(ai_erase keyride-up01)
	(ai_place keyride-up02)
	
	(sleep_until (volume_test_objects keyride-up03 (players))15)
	(ai_erase keyride-up02)
	(ai_place keyride-up03)
	
	(sleep_until (volume_test_objects keyride-top01 (players))15)
	
	(ai_erase keyride-up03)
	(ai_place keyride-top01)
	(ai_place keyride-top02)
	
	(sleep_until (volume_test_objects library (players))15)
	
	(ai_erase keyride-top01)
	(ai_erase keyride-top02)

)

(script dormant key-ride-begin

	(sleep_until (volume_test_objects key-ride-begin (players))15)
	
	;(wake keyride-front01);wake
	
	(if (cinematic_skip_start)
		(begin
		
			;this doesn't work just yet
			;(c04_intra_1)
			
			(cinematic_start)
	
			(sleep 30)
			(print "good luck dervish!!")
		
			(sleep 90)
	
			(print "I'll hold them off!!")
	
			(sleep 90)
		
			(print "get the icon!!")
	
			(sleep 30)
	
			(cinematic_stop)
		)
		(cinematic_skip_stop)
	)
)


(script dormant keyholder-back-right

	(sleep_until (volume_test_objects keyholder-back-right (players))15)
	
	(if G-keyholder-back (sleep_forever))
	(set G-keyholder-back true)
	
	(ai_place keyholder-back-left)

)

(script dormant keyholder-back-left

	(sleep_until (volume_test_objects keyholder-back-left (players))15)
	
	(if G-keyholder-back (sleep_forever))
	(set G-keyholder-back true)
	
	(ai_place keyholder-back-right)

)


(script dormant keyholder-front-right

	(sleep_until (volume_test_objects keyholder-front-right (players))15)
	
	(if G-keyholder-front (sleep_forever))
	(set G-keyholder-front true)
	
	(ai_place keyholder-front-right)
)

(script dormant keyholder-front-left

	(sleep_until (volume_test_objects keyholder-front-left (players))15)
	
	(if G-keyholder-front (sleep_forever))
	(set G-keyholder-front true)
	
	(ai_place keyholder-front-left)
)

(script dormant keyholder-flood01

	(sleep_until (volume_test_objects keyholder-flood01 (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake keyholder-back-left);wake
	(wake keyholder-back-right);wake
	(wake keyholder-front-left);wake
	(wake keyholder-front-right);wake

	(ai_place keyholder-back-tur)
	
	(sleep_until 
		(or
			(<= (ai_living_count keyholder-back-tur) 0)
			(volume_test_objects keyholder-back-tur02 (players))
		)		
	15)
	
	(ai_place keyholder-back-tur02)

)

(script dormant final-exit
	(sleep_until 
		(or
			(volume_test_objects final-exit-r (players))
			(volume_test_objects final-exit-l (players))
		)	
	15)
	
	(wake key-ride-begin);wake
	;(wake keyholder-flood01);wake
	
	
	(ai_place final-flood-exit)
)

(script dormant final-fexit

	(sleep_until (volume_test_objects final-fexit (players))15)
	(wake final-exit);wake
	
	(ai_place final-fexit-wraith)
	(ai_place final-fexit-tur01)
	
	(ai_place final-crashed-p-cov01)
	(ai_place final-crashed-p-flood01)
	
)

(script dormant final-low-back

	(sleep_until (volume_test_objects final-low-back (players))15)

	(ai_place final-low-back-tur01)
	(ai_place final-low-back-w01)
	(ai_place final-low-back-fw01)
)
(script dormant final-high-back-flood
	(sleep_until (volume_test_objects final-high-back-flood (players))15)

	(ai_place final-high-back-flood)
)

(script dormant final-high-wraith01

	(sleep_until (volume_test_objects final-low-wraith02-02 (players)) 15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake final-low-back);wake
	(wake final-fexit);wake
	(wake final-high-back-flood);wake
	
	(ai_place final-high-wraith01)
	(ai_place final-flood-tur01)

)

(script dormant asenfac-flood-wraith02-t

	(sleep_until (volume_test_objects final-low-wraith02-02 (players)) 15)
	
	(if G-asenfac-flood-wraith02 (sleep_forever))
	(set G-asenfac-flood-wraith02 true)
	
	(ai_place asenfac-fwraith-front02)
)

(script command_script cs_asenfac-flood-w02
	(cs_go_to asenfac-flood-wraith02/p0 1)
	(cs_go_to asenfac-flood-wraith02/p1 1)
	(cs_go_to asenfac-flood-wraith02/p4 1)
)


(script dormant asenfac-flood-wraith02

	(sleep_until (<= (ai_living_count asenfac-fwraith-front01) 1))
	
	(if G-asenfac-flood-wraith02 (sleep_forever))
	(set G-asenfac-flood-wraith02 true)
	
	(ai_place asenfac-fwraith-front02)
	
	(cs_run_command_script asenfac-fwraith-front02/starting_locations_0 cs_asenfac-flood-w02)
	(sleep 45)
	;(cs_run_command_script asenfac-fwraith-front02/starting_locations_1 cs_asenfac-flood-w02-02)
)

(script dormant asenfac-front

	(sleep_until (volume_test_objects asenfac-front (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake asenfac-flood-wraith02);wake
	(wake asenfac-flood-wraith02-t);wake
	(wake final-high-wraith01);wake

	(ai_place senfac2-flood-exit)
	(ai_place asenfac-sent-front01)
	(ai_place asenfac-flood-front01)
	(ai_place asenfac-fwraith-front01)
)

(script command_script cs_senfac2-sent-inside01-02
	(cs_fly_to_and_face senfac2-sent-inside/p2 senfac2-sent-inside/p3 1)
	(cs_fly_to senfac2-sent-inside/p3 1)
)

(script command_script cs_senfac2-sent-inside01
	(cs_fly_to_and_face senfac2-sent-inside/p0 senfac2-sent-inside/p1 1)
	(cs_fly_to senfac2-sent-inside/p1 1)
)

(script dormant senfac2-sent-inside

	(sleep_until 
		(and
			(<= (ai_living_count senfac2-sent-entrance01) 0)
			(or
				(volume_test_objects senfac-inside-bottom (players))
				(volume_test_objects senfac-inside-top (players))
			)
		)
	)
	
	(ai_place senfac2-sent-inside01);wake
	
	(cs_run_command_script senfac2-sent-inside01/starting_locations_0 cs_senfac2-sent-inside01)
	(cs_run_command_script senfac2-sent-inside01/starting_locations_1 cs_senfac2-sent-inside01)
	(cs_run_command_script senfac2-sent-inside01/starting_locations_2 cs_senfac2-sent-inside01-02)
	(cs_run_command_script senfac2-sent-inside01/starting_locations_3 cs_senfac2-sent-inside01-02)
)

(script dormant senfac2-entrance-loop
	(sleep_until 
		(begin 
			(ai_place senfac2-sent-entrance01)
				(sleep_until 
					(<= (ai_living_count senfac2-sent-entrance01) 1)
				)	
			;loop forever	
			;false
			(or
				(> (ai_spawn_count senfac2-sent-entrance01) 12)
				(volume_test_objects senfac2-entrance-loop-stop (players))
			)
		)
		;you can put testing rate here and a time out after that..yay
	5)
)

(script dormant senfac2-entrance
	(sleep_until (volume_test_objects senfac2-entrance (players))15)
	(ai_place senfac2-flood-entrance)
	(wake senfac2-entrance-loop);wake
	(wake senfac2-sent-inside);wake
	;(wake asenfac-front);wake
	
	(sleep_until 
		(or 
			(volume_test_objects senfac-inside-bottom (players))
			(volume_test_objects senfac-inside-top (players))
		)
	)
	
	(ai_place senfac2-flood-exit)
	(ai_place senfac2-sent-exit01)
)

(script dormant senfacb-flood-exit02
	(sleep_until (volume_test_objects senfacb-flood-exit02 (players))15)
	(ai_place senfacb-flood-exit01)

)

(script dormant senfacb-flood-exit

	(sleep_until (volume_test_objects senfacb-flood-exit (players))15)
	(wake senfac2-entrance);wake
	(sleep_until 
		(and
			(<= (ai_living_count senfacb-flood-back01) 2)
			(volume_test_objects senfacb-flood-exit (players))
		)	
	15)
	
	(ai_place senfacb-flood-back01)

)

(script dormant senfacb-flood-tur02

	(sleep_until (volume_test_objects senfacb-flood-tur02 (players))15)
	(ai_place senfacb-flood-tur02)
	(wake senfacb-flood-exit);wake
	(wake senfacb-flood-exit02);wake
	
)

(script dormant senfacb-sent01-loop
	(sleep_until 
		(begin 
			(ai_place senfacb-sent01)
				(sleep_until 
					(<= (ai_living_count senfacb-sent01) 2)
				)	
			;loop forever	
			;false
			(or
				(> (ai_spawn_count senfacb-sent01) 12)
				(volume_test_objects senfacb-start02 (players))
			)
		)
		;you can put testing rate here and a time out after that..yay
	5)
)

(script dormant senfacb-start

	(sleep_until (volume_test_objects senfacb-start (players))15)
	(game_save_unsafe);SSSAAAVVVEEE---
	(ai_place senfacb-flood-tur01)
	(ai_place senfacb-flood-start01)
	(wake senfacb-sent01-loop);wake
	(wake senfacb-flood-tur02);wake
	(sleep_until (volume_test_objects senfacb-start02 (players))15)
	(sleep 90)
	(ai_place senfacb-flood-back01)
	;(sleep_until (<= (ai_living_count senfacb-flood-back01) 1))
	;(ai_place senfacb-flood-back01)
)

(script dormant senfac1-flood01r

	(sleep_until 
		(or	
			(<= (ai_living_count senfac1-flood01) 2)
			(volume_test_objects senfac-flood01r (players))
		)
	15)
	(ai_place senfac1-flood01)
	
	(sleep_until
		(and
			(<= (ai_living_count senfac1-flood01) 0)
			(volume_test_objects senfac-flood01r (players))
		)
	)
	(ai_place senfac1-flood-exit01)
)

(script dormant senfac1-start	

	(sleep_until (volume_test_objects senfac1-start (players))15)
	
	
	(wake senfac1-flood01r);wake
	(wake senfacb-start);wake
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place senfac1-flood01)
	(ai_place senfac1-sent01)
	(ai_place senfac1-enfor01)
	
	(sleep_until (<= (ai_living_count senfac1-sent01) 2))
	(ai_place senfac1-sent02)
)

(script dormant q-zone1-end-sent-spawn
	(sleep_until 
		(begin 
			(ai_place q-zone1-end-sent01)
				(sleep_until 
					(<= (ai_living_count q-zone1-end-sent01) 1)
				)	
			;loop forever	
			;false
			(or
				(> (ai_spawn_count q-zone1-end-sent01) 16)
				(<= (ai_living_count q-zone1-end-floodwart02) 0)
				(volume_test_objects q-zone1-stop-sen-spawn (players))
			)
		)
		;you can put testing rate here and a time out after that..yay
	5)
)

(script command_script cs_q-zone1-end-fwart02
	(cs_go_to q-zone1-end-wart02/p0 1)
	(cs_go_to q-zone1-end-wart02/p1 1)
	(cs_go_to q-zone1-end-wart02/p2 1)
	(cs_go_to q-zone1-end-wart02/p3 1)
	(cs_go_to q-zone1-end-wart02/p4 1)
	(cs_go_to q-zone1-end-wart02/p5 1)
	(cs_go_to q-zone1-end-wart02/p6 1)
	(cs_go_to q-zone1-end-wart02/p7 1)
	(cs_go_to q-zone1-end-wart02/p8 1)
	(cs_go_to q-zone1-end-wart02/p10 1)

)
(script dormant q-zone1-end-fwart02-loop
	(sleep_until 
		(begin 
			(cs_run_command_script q-zone1-end-floodwart02/starting_locations_0 cs_q-zone1-end-fwart02)
				(sleep_until 
					(not 			
						(cs_command_script_running q-zone1-end-floodwart02/starting_locations_0  cs_q-zone1-end-fwart02)
					)
				)
				
			;loop forever	
			;false
			(or
				
				(<= (ai_living_count q-zone1-end-floodwart02) 0)
				(volume_test_objects q-zone-end-wart-script (players))
			)
		)
		;you can put testing rate here and a time out after that..yay
	5)
)


(script dormant q-zone-end02

	(sleep_until (volume_test_objects q-zone1-end (players))15)

	(ai_place q-zone1-end-floodwart02)
	(wake q-zone1-end-fwart02-loop);wake
	(wake q-zone1-end-sent-spawn);wake
)

(script dormant q-zone-end

	(sleep_until 
		(or
			(<= (ai_living_count sg-q-zone-middle-fv) 0)
			(volume_test_objects q-zone1-end (players))
		)	
	15)
	
	(ai_place q-zone1-end-floodwart01)
)

(script dormant q-zone-middle

	(sleep_until 
		(or
			(volume_test_objects q-zone-front-2middlel (players))
			(volume_test_objects q-zone-middle (players))
		)	
	15)
	
	(wake q-zone-end);wake
	(wake q-zone-end02);wake
	(ai_place q-zone1-flood-wraith01) 
	(ai_place q-zone1-middle-flood)
	(ai_place q-zone1-middle-fghost01) 
	(sleep 15)
	
	(ai_place q-zone1-middle-tur03)


)

(script dormant q-zone-gap-flood01

	(sleep_until (volume_test_objects q-zone-gap-flood01 (players))15)
	(ai_erase sen-b-area-enfor01)
	(ai_erase sen-bridge-enfor01)
	(ai_erase sen-bridge-flood01)
	(ai_erase sen-bridge-bottom-f01)
	
	(ai_place q-zone-gap-flood01) 
	(ai_place q-zone1-front-tur02)
	(wake q-zone-middle);wake

)

;(script command_script cs_q-zone-front-sen01
;	(cs_fly_to_and_face sen-b-area-enfor01/p9 sen-b-area-enfor01/p10 1)
;)

(script dormant q-zone-front-sen01
	
	(sleep_until (volume_test_objects q-zone01-enfor-gap (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(wake q-zone-gap-flood01);wake
	
	(ai_place q-zone1-front-tur01)
	(ai_place qzone1-middle-rocket01)

	;(cs_run_command_script q-zone-front-sen01/starting_locations_2 cs_q-zone-front-sen01)
	;(cs_run_command_script q-zone-front-sen01/starting_locations_3 cs_q-zone-front-sen01)
)

(script command_script cs_sen-bridge-bottom-enfor01-02
	(cs_fly_to_and_face sen-b-area-enfor01/p7 sen-b-area-enfor01/p8 1)
	(cs_fly_to sen-b-area-enfor01/p8 1)
)

(script command_script cs_sen-bridge-bottom-enfor01
	(cs_fly_to sen-b-area-enfor01/p6 1)
)

(script dormant sen-bridge-bottom-f01
	
	(sleep_until (volume_test_objects sen-bridge-bottom-f01 (players))15)
	(wake q-zone-front-sen01);wake
	
	;(ai_place sen-bridge-bottom-f01)
	(ai_place sen-bridge-bottom-enfor01)
	
	(cs_run_command_script sen-bridge-bottom-enfor01/starting_locations_0 cs_sen-bridge-bottom-enfor01)
	(cs_run_command_script sen-bridge-bottom-enfor01/starting_locations_1 cs_sen-bridge-bottom-enfor01-02)
	
	(sleep_until 
		(and
			(volume_test_objects sen-bridge-bottom-f03 (players))
			(<= (ai_living_count sen-bridge-bottom-f01) 2)
		)
	)
	(ai_place sen-bridge-bottom-f01)
)

(script dormant sen-bridge-enfor01
	
	(ai_place sen-bridge-enfor01)
	(ai_place sen-bridge-flood01)
	
	(wake sen-bridge-bottom-f01);wake
	(sleep_until 
		(or
			(<= (ai_living_count sen-bridge-flood01) 2)
			(volume_test_objects sen-bridge-bottom-f01 (players))
		)	
	15)
	
	(ai_set_orders sen-bridge-flood01 sen-bridge-bottom-f01)
	(ai_set_orders sen-bridge-enfor01 sen-bridge-bottom-sen01)
	
	
)

(script dormant q-zone-front-flood01
	
	(sleep_until (volume_test_objects q-zone01-jug-intro (players))15)
	(ai_place q-zone-front-flood01)
	(sleep_until (<= (ai_living_count q-zone-front-flood01) 2))
	(ai_place q-zone-front-flood02)
)

(script command_script cs_sen-b-area-enfor01-02
	(cs_fly_to sen-b-area-enfor01/p3 1)
	(cs_fly_to sen-b-area-enfor01/p4 1)
	(cs_fly_to sen-b-area-enfor01/p5 1)
)

(script command_script cs_sen-b-area-enfor01
	(cs_fly_to sen-b-area-enfor01/p0 1)
	(cs_fly_to sen-b-area-enfor01/p1 1)
	(cs_fly_to sen-b-area-enfor01/p2 1)
)

(script static void dtest02

	(ai_erase sen-b-area-enfor01)
	
	(sleep 15)
	
	(ai_place sen-b-area-enfor01)
	(cs_run_command_script sen-b-area-enfor01/starting_locations_0 cs_sen-b-area-enfor01)
	(cs_run_command_script sen-b-area-enfor01/starting_locations_1 cs_sen-b-area-enfor01-02)
)

(script dormant sen-b-area-enfor01

	(sleep_until (volume_test_objects sen-b-area-enfor01 (players))15)
	
	(ai_erase sen-interior-enfor01)
	(ai_erase sen-interior-front-back-l01)
	(ai_erase sen-interior-front-back-r01)
	(ai_erase sen-interior-front-rein01)
	(ai_erase sen-interior-middle-enfor)
	(ai_erase sen-interior-flood01)
	(ai_erase sen-interior-flood-sen)
	(ai_erase sen-interior-exit)
	(ai_erase sen-interior-left-flood)
	(ai_erase sen-interior-left-enfor)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place sen-b-area-enfor01)
	(cs_run_command_script sen-b-area-enfor01/starting_locations_0 cs_sen-b-area-enfor01)
	(cs_run_command_script sen-b-area-enfor01/starting_locations_1 cs_sen-b-area-enfor01-02)
	
	(object_cannot_take_damage (ai_actors sen-b-area-enfor01))
	
	(wake q-zone-front-flood01);wake
	(wake sen-bridge-enfor01);wake
	
	(ai_place q-zone-front-sen01)
	(ai_place sen-bridge-bottom-f01)
	
	(sleep_until (volume_test_objects sen-bridge-bottom-f02 (players))15)
	(ai_set_orders sen-bridge-enfor01 q-zone01-enfor-gap)
	
	(sleep_until (volume_test_objects q-zone-bridge-after (players))15)
	
	(object_can_take_damage (ai_actors sen-b-area-enfor01))
	
)


(script dormant sen-interior-exit

	(sleep_until (volume_test_objects sen-interior-exit (players))15)
	(ai_place sen-interior-exit)
	;(wake sen-b-area-enfor01);wake
)

(script dormant sen-interior-flood

	(sleep_until (volume_test_objects sen-interior-flood (players))15)
	(ai_place sen-interior-flood01)
	(ai_place sen-interior-flood-sen)
)

(script dormant sen-interior-front-back-r

	(sleep_until (volume_test_objects sen-interior-front-back-r (players))15)
	(if G-sen-interior-front-back (sleep_forever))
	(set G-sen-interior-front-back true)
	
	(ai_place sen-interior-front-back-r01)
)


(script dormant sen-interior-front-back-l

	(sleep_until (volume_test_objects sen-interior-front-back-l (players))15)
	(if G-sen-interior-front-back (sleep_forever))
	(set G-sen-interior-front-back true)

	(ai_place sen-interior-front-back-l01)
	
	;(sleep_until (volume_test_objects sen-interior-front-back-l (players))15)
)


(script dormant sen-interior-left
	
	(ai_place sen-interior-left-enfor)
	(object_cannot_take_damage (ai_actors sen-interior-left-enfor))
	(sleep_until 
		(begin 
			(ai_erase sen-interior-left-flood)
			(sleep 5)
			(ai_place sen-interior-left-flood)
				(sleep_until 
					(<= (ai_living_count sen-interior-left-flood) 0)
				)	
			;loop forever	
			;false
			(or
				(> (ai_spawn_count sen-interior-left-flood) 9)
				(volume_test_objects sen-interior-exit-a (players))
			)
		)
		;you can put testing rate here and a time out after that..yay
	5)
	(object_can_take_damage (ai_actors sen-interior-left-enfor))

)

(script dormant sen-interior-front-rein01
	(sleep_until (<= (ai_living_count sg-sen-interior-front01) 4))
	(ai_place sen-interior-front-rein01)
	
	(sleep 15)
	
	(wake sen-interior-left);wakea
)

(script dormant sen-interior-front
	(sleep_until (volume_test_objects sen-interior-front (players))15)
	(wake sen-interior-front-back-l);wake
	(wake sen-interior-front-back-r);wake
	(wake sen-interior-front-rein01);wake
	(wake sen-interior-flood);wake
	(wake sen-interior-exit);wake
	
	;(ai_erase_all)
	
	(sleep 30)
	
	(ai_place defen-allies-wraiths02)
	
	(ai_place defen-allies-shadow02)
	
	(ai_place sen-interior-enfor01)

	(ai_place sen-interior-aggr01)
	
	(ai_place sen-interior-middle-enfor)
	
	(sleep_until 
		(or
			(<= (ai_living_count sg-sen-interior-front01) 0)
			(volume_test_objects_all sen-interior-allies-move01 (ai_actors sg-sen-interior-front01))
		)
	)
	
	(ai_set_orders defen-allies-wraiths02 sen-interior-front-back)
	
	(sleep_until 
		(or
			(<= (ai_living_count sg-sen-interior-middle01) 0)
			(volume_test_objects_all sen-interior-allies-move01 (ai_actors sg-sen-interior-middle01))
		)
	)
	
	(ai_set_orders defen-allies-wraiths02 sen-interior-middle-back-a)
	
	(sleep_until (volume_test_objects sen-interior-exit (players))15)
	
	(sleep 15)
	
	(sleep_until
		(and
			(<= (ai_living_count sen-interior-middle-enfor) 0)
			(<= (ai_living_count sen-interior-exit) 0)
			(<= (ai_living_count sen-interior-enfor01) 0)
		)
	)
	
	(ai_set_orders defen-allies-wraiths02 sen-interior-low-a)
)

(script command_script cs_defen-sentinels01

	(cs_fly_to defen-sentinels/p0 1)
)


(script dormant defen-sentinels

	(device_set_position defen_door 1)

	(ai_place defen-sentinels01)
	(cs_run_command_script defen-sentinels01 cs_defen-sentinels01)
	;(wake sen-interior-front);wake

)

(script dormant defen-allies01

	(sleep_until (<= (ai_living_count sg-defen-finalwave) 0))
	
	(if (cinematic_skip_start)
		(begin
	
			;this doesn't work just yet
			;(c04_intra_1)
	
			(cinematic_start)
		
			(print "well done Dervish")	
			(sleep 90)
			(print "youve killed all the flood")
			;(object_create_containing "defen-phatom")
			;(object_destroy temp-defen-exit-block)
			(sleep 90)
	
			(print "take these and find the sacred icon")
			(sleep 90)
	
			(cinematic_stop)
		)
		(cinematic_skip_stop)
	)
	
	(ai_place defen-allies-shadow)
	(ai_place defen-allies-wraiths01)
	
	(wake defen-sentinels);wake
)


;
(script command_script cs_defen-out-wart
	(cs_go_to defen-out-wart/p0 1)
	(cs_go_to defen-out-wart/p1 1)
	(cs_go_to defen-out-wart/p2 1)
	(cs_go_to defen-out-wart/p3 1)
	(cs_go_to defen-out-wart/p4 1)
	(cs_go_to defen-out-wart/p5 1)
	(cs_go_to defen-out-wart/p6 1)
	(cs_go_to defen-out-wart/p7 1)
	(cs_go_to defen-out-wart/p8 1)
	(cs_go_to defen-out-wart/p9 1)
	(cs_go_to defen-out-wart/p10 1)
	(cs_go_to defen-out-wart/p11 1)
	(cs_go_to defen-out-wart/p12 1)
	(cs_go_to defen-out-wart/p13 1)
	(cs_go_to defen-out-wart/p14 1)
	(cs_go_to defen-out-wart/p15 1)
)

(script dormant defen-out-wart-loop
	(sleep_until 
		(begin 
			(cs_run_command_script defen-out-wart/starting_locations_0 cs_defen-out-wart)
				(sleep_until 
					(not 			
						(cs_command_script_running defen-out-wart cs_defen-out-wart)
					)
				)
				
			;loop forever	
			;false
			(or
				
				(<= (ai_living_count defen-out-wart) 0)
				(<= (ai_living_count sg-defen-out02) 0)
			)
		)
		;you can put testing rate here and a time out after that..yay
	30 1800)
)

(script static void dtest01
	
	(sleep 10)
	(ai_erase defen-out-wart)
	(sleep 15)
	
	(ai_place defen-out-wart)
	(wake defen-out-wart-loop);wake
)

(script dormant defen-out02

	(ai_place defen_out_left02)
	(sleep 90)
	(ai_place defen_out_right02)
	(wake defen-allies01);wake
)

(script dormant defen-out-wart
	(sleep_until (<= (ai_living_count sg-defen-out-back) 0))
	(ai_place defen-out-wart)
	(wake defen-out-wart-loop);wake
	(wake defen-out02);wake
	;(cs_run_command_script defen-out-wart/starting_locations_0 cs_defen-out-wart)
)

(script dormant defen-out-back01
	
	(sleep_until (<= (ai_living_count defen-out-right01) 1))
	(ai_set_orders defen-allies-elites01 defen-center-back-a)
	(print "THEY'RE ATTACKING THE REAR!!!")
	
	(sleep 60)
	
	(print "WART WART!!")
	
	(garbage_collect_unsafe)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place defen-out-back-left01)
	(sleep 60)
	(ai_place defen-out-back-right01)
	(sleep 120)
	(ai_place defen-out-back-center01)
	(sleep 120)
	(print "brace for a REAR attack!")
	(sleep_until (<= (ai_living_count sg-defen-out-back) 3))
	(ai_place defen-out-back-right01)
	(sleep 60)
	(ai_place defen-out-back-left01)
	(sleep 120)
	(ai_place defen-out-back-center01)
	;(sleep_until (<= (ai_living_count sg-defen-out-back) 3))
	(wake defen-out-wart);wake
	;(ai_place defen-out-back-left01)
	;(sleep 60)
	;(ai_place defen-out-back-center01)
	;(sleep 120)
	;(ai_place defen-out-back-left01)

)

(script dormant defen-out-front-right

	(sleep_until 
		(and
			(<= (ai_living_count defen-out-left01) 0)
			(<= (ai_living_count defen_out_left02) 0)
			(<= (ai_living_count defen-out-left-g01) 0)
		)		
	)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(sleep 300)
	(ai_set_orders defen-allies-elites01 defen-center-front-right-a)
	(print "THEY'RE ATTACKING FROM THE OTHER SIDE!!!")
	
	(ai_place defen_out_right02)
	(garbage_collect_unsafe)
	
	(sleep 10)
	
	(ai_set_orders defen_out_right02 pre-defen-out-right)
	
	(sleep 90)
	
	(print "Reposition!")
	
	(sleep_until (<= (ai_living_count defen_out_right02) 1))
	
	(sleep 90)
	
	(ai_place defen-out-right01)
	(garbage_collect_unsafe)
	(sleep 60)
	(sleep_until (<= (ai_living_count defen-out-right01) 2))
	(ai_place defen-out-right01)
	(sleep_until (<= (ai_living_count defen-out-right01) 3))
	(ai_place defen-out-right01)
	;(sleep_until (<= (ai_living_count defen-out-right01) 3))
	;(ai_place defen-out-right01)
	(wake defen-out-back01);wake
)

(script command_script cs_defen-spotlights05
	(cs_enable_looking false)
	
	(sleep_until 
		(begin 
			(print "tyson green")
			
			(cs_face 1 defen-spotlights/p2)
			(sleep 300)
			;loop forever	
			;false
				(and
					(<= (ai_fighting_count defen-out-left-g01) 0)
					(<= (ai_fighting_count defen-out-left01) 0)
					(<= (ai_fighting_count defen-out-left-infect) 0)
				)
				;(volume_test_objects wall1-hall02-f01up (players))
		)
		;you can put testing rate here and a time out after that..yay
	5)
	(print "defen-spot-pre-l01 ended05")
)
(script command_script cs_defen-spotlights04
	(cs_enable_looking false)
	
	(sleep_until 
		(begin 
			(print "tyson green")
			
			(cs_face 1 defen-spotlights/p0)
			(sleep 300)
			;loop forever	
			;false
				(and
					(<= (ai_fighting_count defen-out-left-g01) 0)
					(<= (ai_fighting_count defen-out-left01) 0)
					(<= (ai_fighting_count defen-out-left-infect) 0)
				)
				;(volume_test_objects wall1-hall02-f01up (players))
		)
		;you can put testing rate here and a time out after that..yay
	5)
	(print "defen-spot-pre-l01 ended04")
)

(script command_script cs_defen-spotlights03
	(cs_enable_looking false)
	
	(sleep_until 
		(begin 
			(print "tyson green")
			
			(cs_face 1 defen-spotlights/p1)
			(sleep 60)
			(cs_face 1 defen-spotlights/p2)
			(sleep 90)
			(cs_face 1 defen-spotlights/p14)
			(sleep 30)
			(cs_face 1 defen-spotlights/p9)
			(cs_face 1 defen-spotlights/p15)
			(sleep 60)
			(cs_face 1 defen-spotlights/p6)
			(sleep 60)
			;loop forever	
			;false
				(and
					(volume_test_objects pre-defen-flood-attack (players))
					(<= (ai_living_count sg-defen-out02) 0)
				)
				;(volume_test_objects wall1-hall02-f01up (players))
		)
		;you can put testing rate here and a time out after that..yay
	5)
	(print "defen-spot-pre-l01 ended03")
)

(script static void dtest06

	(ai_erase defen-spotlights)
	
	(sleep 10)
	
	(ai_place defen-spotlights)

	(cs_run_command_script defen-spotlights/starting_locations_0 cs_defen-spotlights03)
	;(cs_run_command_script defen-spotlights/starting_locations_1 cs_defen-spotlights02)
)

(script dormant defen-allies-elites01-place

	(if
		(<= (ai_living_count defen-allies-elites01) 0)
		(ai_place defen-allies-elites01)
	)
)

(script dormant defen-allies-elites01

	(sleep_until 
		(and
			(<= (ai_living_count sg-defen-out02) 0)
			;(<= (ai_living_count sg-wallexit-afterbridge-far) 0)
			;(<= (ai_living_count sg-wallexit-front-afterbridge) 0)
			(volume_test_objects pre-defen-flood-attack (players))
		)	
	15)
	
	(wake defen-allies-elites01-place);wake
	
	(garbage_collect_unsafe)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(cs_run_command_script defen-spotlights/starting_locations_0 cs_defen-spotlights03)
	
	(sleep 60)
	
	(print "Dervish!! YOU MADE IT!!")
	
	(sleep 90)
	
	(print "Its good to see you!")
	
	(sleep 69)
	
	(print "We need to hold this position until REINFORCEMENTS arrive.")
	
	(sleep 90)
	
	;(ai_place defen-allies-elites01)
	
	(sleep 300)
	(ai_place defen_out_left02)
	
	(sleep 10)
	
	(ai_set_orders defen_out_left02 pre-defen-out-left)
	
	(cs_run_command_script defen-spotlights/starting_locations_0 cs_defen-spotlights04)
	(cs_run_command_script defen-spotlights/starting_locations_1 cs_defen-spotlights05)
	
	(print "Flood!!!  Left SIDE!")
	
	(sleep_until (<= (ai_living_count defen_out_left02) 1))
	
	(ai_place defen_out_left02)
	
	(sleep 10)
	
	(ai_set_orders defen_out_left02 pre-defen-out-left)
	
	(sleep_until (<= (ai_living_count defen_out_left02) 2))
	
	(ai_set_orders defen_out_left02 defen-out-front-left-intro)
	
	(sleep 150)
	
	(ai_place defen-out-left01)
	(sleep_until (<= (ai_living_count defen-out-left01) 2))
	(ai_place defen-out-left01)
	(sleep_until (<= (ai_living_count defen-out-left01) 3))
	
	(ai_place defen-out-left-infect)
	(sleep 350)
	
	(ai_place defen-out-left-g01)
	;(ai_place defen-out-left01)
	(sleep_until (<= (ai_living_count defen-out-left-g01) 2))
	(ai_place defen_out_left02)
	(wake defen-out-front-right);wake
)
(script command_script cs_defen-spotlights02
	
	(cs_enable_looking false)
	
	(sleep_until 
		(begin 
			(print "tyson green")
			
			(cs_face 1 defen-spotlights/p11)
			(sleep 150)
			(cs_face 1 defen-spotlights/p9)
			(sleep 150)
			(cs_face 1 defen-spotlights/p12)
			(sleep 150)
			(cs_face 1 defen-spotlights/p13)
			(sleep 150)
			;loop forever	
			;false
				(and
					(volume_test_objects pre-defen-flood-attack (players))
					(<= (ai_living_count sg-defen-out02) 0)
				)
				;(volume_test_objects wall1-hall02-f01up (players))
		)
		;you can put testing rate here and a time out after that..yay
	5)
	(print "defen-spot-pre-l01 ended02")
)

(script command_script cs_defen-spotlights

	(cs_enable_looking false)
	
	(sleep_until 
		(begin 
			(print "tyson green")
			(cs_face 1 defen-spotlights/p0)
			(sleep 150)
			(cs_face 1 defen-spotlights/p1)
			(sleep 150)
			(cs_face 1 defen-spotlights/p2)
			(sleep 150)
			
			;loop forever	
			;false
				(and
					(volume_test_objects pre-defen-flood-attack (players))
					(<= (ai_living_count sg-defen-out02) 0)
				)
				;(volume_test_objects wall1-hall02-f01up (players))
		)
		;you can put testing rate here and a time out after that..yay
	5)
	
	(print "defen-spot-pre-l01 ended")
)

(script dormant defen-spot-pre-l01

	(print "defen-spot-pre-l01")

	(cs_run_command_script defen-spotlights/starting_locations_0 cs_defen-spotlights)
	(cs_run_command_script defen-spotlights/starting_locations_1 cs_defen-spotlights02)
)

(script static void dtest05

	(ai_erase defen-spotlights)
	
	(sleep 10)
	
	(ai_place defen-spotlights)

	(cs_run_command_script defen-spotlights/starting_locations_0 cs_defen-spotlights)
	(cs_run_command_script defen-spotlights/starting_locations_1 cs_defen-spotlights02)
)

(script dormant pre-defen-start

	(sleep_until (volume_test_objects wallexit-front-afterbridge-l (players))15)
	
	(ai_place defen-allies-elites01)
	(ai_place defen-allies-grunts01)
	
	(ai_place defen_out_left02)
	(ai_place defen_out_right02)
	
	(sleep 10)
	
	(wake defen-spot-pre-l01);wake
	
	(ai_set_orders defen_out_left02 pre-defen-out-left)
	(ai_set_orders defen_out_right02 pre-defen-out-right)

	(object_cannot_take_damage (ai_actors defen-allies-elites01))
	(object_cannot_take_damage (ai_actors defen-allies-grunts01))
	
	(object_cannot_take_damage (ai_actors defen_out_left02))
	(object_cannot_take_damage (ai_actors defen_out_right02))
	
	(sleep_until (volume_test_objects wallexit-back2defen-front (players))15)
	
	(object_can_take_damage (ai_actors defen-allies-elites01))
	(object_can_take_damage (ai_actors defen-allies-grunts01))
	
	(object_can_take_damage (ai_actors defen_out_left02))
	(object_can_take_damage (ai_actors defen_out_right02))
	
	(sleep_until (<= (ai_living_count sg-defen-out02) 2))
	
	(ai_place defen_out_left02)
	(ai_place defen_out_right02)
)



(script dormant defen-front-cave-back
	(sleep_until (volume_test_objects defen-front-cave-back (players))15)
	(if G-defen-front-cave (sleep_forever))
	(set G-defen-front-cave true)
	
	(ai_place defen-front-cave)
	(ai_set_orders defen-front-cave defen-front-cave-back)
)

(script dormant defen-front-cave-front
	(sleep_until (volume_test_objects defen-front-cave-front (players))15)
	(if G-defen-front-cave (sleep_forever))
	(set G-defen-front-cave true)
	
	(ai_place defen-front-cave)
	(ai_set_orders defen-front-cave defen-front-cave-front)
)

(script dormant wallexit-middle-right
	(sleep_until 
		(or
			(volume_test_objects wallexit-middle-right (players))
			(volume_test_objects wallexit-middle-right-back (players))
		)
	)
	(ai_place wallexit-middle-right)


)

(script dormant wallexit-afterbridge-farleft
	(sleep_until (volume_test_objects wallexit-afterbridge-farleft (players)))
	(ai_place wallexit-afterbridge-farleft)
	
	(sleep_until 
		(or
			(and
				(<= (ai_living_count  wallexit-afterbridge-farleft) 2)
				(volume_test_objects  wallexit-afterbridge-farleft (players))
			)
			(volume_test_objects  wallexit-afterbridge-farleft02 (players))
		)
	15)
	(ai_place wallexit-afterbridge-farleft02)
)

(script dormant wallexit-front-afterbridge
	(sleep_until (volume_test_objects wallexit-front-afterbridge (players))15)
	(wake wallexit-afterbridge-farleft);wake
	
	;(ai_place sg-wallexit-front-afterbridge)
	(sleep_until 
		(or
			(<= (ai_living_count sg-wallexit-front-afterbridge) 1)
			(volume_test_objects wallexit-front-bridge (players))
		)
	15)
	
	(ai_set_orders sg-wallexit-front-afterbridge wallexit-afterbridge-left)
	(ai_set_orders wallexit-front-center01 wallexit-afterbridge-left)
	(ai_place wallexit-afterbridge-lm01)	
	(ai_set_orders wallexit-afterbridge-lm01 wallexit-afterbridge-left)
	(sleep 10)
	
	(sleep_until 
		(or
			(<= (ai_living_count sg-wallexit-front-afterbridge) 2)
			(volume_test_objects wallexit-afterbridge-farleft (players))
		)
	15)
	
	(ai_set_orders sg-wallexit-front-afterbridge wallexit-afterbridge-farleft)
)

(script dormant wallexit-front-center01
	(sleep_until (volume_test_objects wallexit-front-center01 (players))15)
	;(wake wallexit-front-afterbridge);wake
	;(wake wallexit-middle-right);wake
	(wake defen-front-cave-front);wake
	(wake defen-front-cave-back);wake
	
	(wake pre-defen-start);wake
	
	;(ai_place wallexit-front-center01)
	;(sleep_until 
		;(or
			;(<= (ai_living_count wallexit-front-center01) 2)
	;		(volume_test_objects wallexit-front-bridge (players))
		;)
	;15)
	;(ai_place wallexit-front-center01)
	
	
)

(script command_script cs_defen-spot-pre
	(cs_enable_looking false)
	(sleep_until 
		(begin 
			(cs_face 1 defen-spotlights/p17)
			;loop forever	
			;false	
				(volume_test_objects pre-defen-flood-attack (players))
		)
		;you can put testing rate here and a time out after that..yay
	30)
	(print "defen-spot-pre ended")
)

(script dormant wallexit-front

	(sleep_until (volume_test_objects wallexit-save (players))15)
	(ai_place defen-spotlights)
	(ai_place wallexit-camp1-spotlight)
	(cs_run_command_script wallexit-camp1-spotlight/starting_locations_0 cs_defen-spot-pre)
	(ai_place wallexit-camp1-mflood01)
	(ai_place wallexit-camp1-flood01)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(sleep_until 
		(or
			(volume_test_objects wallexit-front-front (players))
			(volume_test_objects wallexit-front-right (players))
		)
	)
	(wake wallexit-front-center01);wake
	;(ai_place wallexit-front-l01)
	;(ai_place wallexit-front-r01)
	
	;(sleep_until (<= (ai_living_count sg-wallexit-front) 1))

	;(ai_place sg-wallexit-front)
	
	;(sleep_until (<= (ai_living_count sg-wallexit-front) 2))
	
	;(ai_set_orders sg-wallexit-front wallexit-afterbridge)
)



(script dormant wall2-slide02-mr

	(sleep_until (<= (ai_living_count wall2-slide02-m01) 1))
	(ai_place wall2-slide02-mr)
)

(script dormant wall2-slide02-sentinelsr

	(sleep_until (<= (ai_living_count wall2-slide02-sentinels) 3))
	(ai_place wall2-slide02-sentinels)
)

(script dormant wall2-slide02

	(sleep_until (volume_test_objects wall2-slide02 (players))15)
	(wake wall2-slide02-sentinelsr);wake
	(wake wall2-slide02-mr);wake

	;(wake wallexit-front);wake
	
	(ai_place wall2-slide02-g01)
	(ai_place wall2-slide02-m01)
	(ai_place wall2-slide02-sentinels)
	
	(sleep_until (<= (ai_living_count wall2-slide02-g01) 1))
	(ai_place wall2-slide02-gr)
	
)

(script dormant wall2-slide01-top01

	(sleep_until (volume_test_objects wall2-slide01-top01 (players))15)
	(wake wall2-slide02);wake
	
	(ai_place wall2-slide01-top01)
	(sleep_until (volume_test_objects wall2-slide01-top02 (players))15)
	(ai_place wall2-slide01-top02)
	(sleep_until (volume_test_objects wall2-slide01-m-end01 (players))15)
	(ai_place wall2-slide01-m-end01)
	(sleep_until (volume_test_objects wall2-slide01-middle01 (players))15)
	
	(object_create_containing "wall2-slide1-crate")
	(ai_place wall2-slide01-middle01)
	
	(sleep_until (volume_test_objects wall2-slide01-end01 (players))15)
	(ai_place wall2-slide01-end01)
	(sleep_until (volume_test_objects wall2-slide01-end02 (players))15)
	(ai_place wall2-slide01-end02)
)


(script dormant wall2-slide01-front
	(sleep_until (volume_test_objects wall2-slide01-front (players))15)
	(wake wall2-slide01-top01);wake
	
	(ai_place wall2-slide01-g01)
	(ai_place wall2-slide01-m01)
	
	(sleep_until 
		(or
			(volume_test_objects wall2-slide01-middle (players))
			(<= (ai_living_count sg-wall2-slide01-front) 3)
		)
	)
	
	(ai_place wall2-slide01-gm01r)

)
(script dormant wall2-exit-pistondoor-car01
	(sleep_until (volume_test_objects wall2-exit-pistondoor-car01 (players))15)
	(garbage_collect_unsafe)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	(wake wall2-slide01-front);wake
	
	(ai_place wall2-exit-pistondoor-car01)
)


;
(script dormant wall2-cond03-back-l01

	(sleep_until 
		(or
			(volume_test_objects wall2-cond03-middle-r01-car (players))
			(volume_test_objects wall2-cond03-middle-l01-car (players))
		)
	)
	;(wake wall2-exit-pistondoor-car01);wake
	(ai_place wall2-cond03-back-l01)
	(ai_place wall2-cond03-exit01)
	
)
;

(script command_script cs_wall2-cond03-enforcer
	(cs_fly_to_and_face wall2-cond03-enforcer/p0 wall2-cond03-enforcer/p2 1)
	(cs_fly_to_and_face wall2-cond03-enforcer/p1 wall2-cond03-enforcer/p2 1)
)
(script dormant wall2-cond03-enforcer

	(sleep_until 
		(or
			(volume_test_objects wall2-cond03-front-right (players))
			(volume_test_objects wall2-cond03-front-left (players))
		)
	)
	
	(ai_place wall2-cond03-enforcer)
	(cs_run_command_script wall2-cond03-enforcer cs_wall2-cond03-enforcer)
)
;

(script dormant wall2-cond03-front-r01
	(sleep_until (volume_test_objects wall2-cond03-back-r01-car (players))15)
	(ai_place wall2-cond03-front-r01)
)

(script dormant wall2-cond03-back-r01-car
	(sleep_until (volume_test_objects wall2-cond03-back-r01-car (players))15)
	(ai_place wall2-cond03-back-r01-car)
)
(script dormant wall2-cond03-middle-r01-car
	(sleep_until (volume_test_objects wall2-cond03-middle-r01-car (players))15)
	(ai_place wall2-cond03-middle-r01-car)
)
(script dormant wall2-cond03-back-l01-car
	(sleep_until (volume_test_objects wall2-cond03-back-l01-car (players))15)
	(ai_place wall2-cond03-back-l01-car)
)
(script dormant wall2-cond03-middle-l01-car
	(sleep_until (volume_test_objects wall2-cond03-middle-l01-car (players))15)
	(ai_place wall2-cond03-middle-l01-car)
)

(script dormant wall2-cond03-front

	(sleep_until (volume_test_objects wall2-cond03-front (players))15)
	(wake wall2-cond03-middle-l01-car);wake
	(wake wall2-cond03-back-l01-car);wake
	(wake wall2-cond03-middle-r01-car);wake
	(wake wall2-cond03-back-r01-car);wake
	
	(wake wall2-cond03-enforcer);wake
	
	(ai_place wall2-cond03-front-l01-car)
	(ai_place wall2-cond03-front-r01-car)
	(ai_place wall2-cond03-front-l01)
	
	(sleep 15)
	(wake wall2-cond03-back-l01);wake
	
)

(script dormant wall2-cond02-middle02-sent01
	
	(sleep_until (volume_test_objects wall2-cond02-middle02-sent01 (players))15)
	(wake wall2-cond03-front);wake
	(ai_set_orders sg-wall2-cond02 wall2-cond02-back)
	
	(ai_place wall2-cond02-middle02-sent01)
	
	(ai_place wall2-cond02-middle02-middle01)
)


(script dormant wall2-cond02-middle02-mid
	(sleep_until (volume_test_objects wall2-cond02-middle02-mid (players))15)
	(wake wall2-cond02-middle02-sent01);wake
	
	(ai_place wall2-cond02-middle02-front01)
	
	(ai_place wall2-cond02-middle02-front02)
	
	(sleep_until (volume_test_objects wall2-cond2-middle-save (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
)

(script dormant wall2-cond02-front-r02

	(print "wall2-cond02-front-r02")

	(sleep_until 
		(or
			(volume_test_objects wall2-cond02-front-l03 (players))
			(volume_test_objects wall2-cond02-front-r02 (players))
			(<= (ai_living_count wall2-cond02-front-r01) 0)
		)
	)
	
	(print "placing wall2-cond02-front-r02")
	
	(ai_place wall2-cond02-front-r02)
	
	(sleep_until 
		(and
			(or
				(volume_test_objects wall2-cond02-back-right (players))
				(volume_test_objects wall2-cond02-back-left-back (players))
			)
			(<= (ai_living_count wall2-cond01-front-r02) 0)
		)
	)
	(ai_place wall2-cond02-back-r03)
)

(script dormant wall2-cond02-front
	(sleep_until (volume_test_objects wall2-cond02-front (players))15)

	
	(ai_place wall2-cond02-front-l01)
	(ai_place wall2-cond02-front-r01)
	
	(sleep 10)
	
	(wake wall2-cond02-front-r02);wake
	(wake wall2-cond02-middle02-mid);wake
	
	(sleep_until 
		(and
			(volume_test_objects wall2-cond02-front-l02 (players))
			(volume_test_objects wall2-cond02-front-r02 (players))
			(<= (ai_living_count wall2-cond02-front-l01) 1)
		)
	)
	(ai_place wall2-cond02-front-l02)
	(sleep_until 
		(or
			(volume_test_objects wall2-cond02-back-left (players))
			(volume_test_objects wall2-cond02-back-right-back (players))
			(<= (ai_living_count wall2-cond02-front-l02) 1)
		)
	)
	(ai_place wall2-cond02-back-l01)
	
)

;
(script dormant wall2-cond01-middle01-back01
	(sleep_until (volume_test_objects wall2-cond01-middle01-back01 (players))15)
	(game_save_unsafe);SSSAAAVVVEEE---
	(ai_place wall2-cond01-middle01-back01)
	(sleep_until (volume_test_objects wall2-cond01-middle01-back02 (players))15)
	(ai_place wall2-cond01-middle01-back02)
)

(script dormant wall2-cond01-middle01-front02
	(sleep_until (volume_test_objects wall2-cond01-middle01-front02 (players))15)
	(ai_place wall2-cond01-middle01-front02)
)

(script dormant wall2-cond01-middle01-front01
	(sleep_until (volume_test_objects wall2-cond01-back-l01 (players))15)
	(ai_place wall2-cond01-middle01-front01)
)

(script dormant wall2-cond01-back-l00
	(sleep_until 
		(or
			(volume_test_objects wall2-cond01-back-l00 (players))
			(volume_test_objects wall2-cond01-back-l01 (players))
		)
	15)
	(ai_place wall2-cond01-back-l01)
)

(script dormant wall2-cond01-frontr
	
	(sleep_until 
		(and
			(volume_test_objects wall2-cond01-back-l00 (players))
			(<= (ai_living_count wall2-cond01-front-r01) 1)
			
		)
	)
	(if G-wall2-cond1-front-lr (sleep_forever))
	(set G-wall2-cond1-front-lr true)
	
	(ai_place wall2-cond01-front-r02)
)
(script dormant wall2-cond01-frontl

	(sleep_until 
		(and
			(or
				(volume_test_objects wall2-cond01-back-r00 (players))
				(volume_test_objects wall2-cond01-front-r01 (players))
			)
			(<= (ai_living_count wall2-cond01-front-r01) 1)
			
		)
	)
	
	(print "wall2-cond01-frontl")
	(if G-wall2-cond1-front-lr (sleep_forever))
	(set G-wall2-cond1-front-lr true)

	(ai_place wall2-cond01-front-l01)
)

(script dormant ai_kill02

	(ai_kill wall2-ledge-f01)
	(ai_kill wall2-ledge-f01r)
	(ai_kill wall2-ledge-flow01)
	(ai_kill wall2-ledge-low-tube)
	(ai_kill wall2-ledge-low-middle)
	(ai_kill wall2-ledge-middle-left)
	(ai_kill wall2-ledge-middle-left-car01)
	(ai_kill wall2-ledge-middle-glass)
	(ai_kill wall2-ledge-middle-glass02)
	(ai_kill wall2-ledge-middle-right02)
	(ai_kill wall2-ledge-back-low)
	(ai_kill wall2-ledge-back-low-exit-car)
	(ai_kill wall2-ledge-back-exit01)
	(ai_kill wall2-ledge-back-exit02)
	(ai_kill wall2-ledge-back-sentinels)
	(ai_kill wall2-ledge-middle-sentinel)

)

(script dormant wall2-cond01-entrance

	(sleep_until (volume_test_objects wall2-cond01-entrance (players))15)
	(wake wall2-cond01-back-l00);wake
	(wake wall2-cond01-middle01-front01);wake
	(wake wall2-cond01-middle01-front02);wake
	(wake wall2-cond01-middle01-back01);wake
	(wake wall2-cond02-front);wake
	
	(wake ai_kill02);wake
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place wall2-cond01-entrance)
	(sleep_until (volume_test_objects wall2-cond01-front-r01 (players))15)
	(ai_place wall2-cond01-front-r01)
	
	(wake wall2-cond01-frontl);wake
	(wake wall2-cond01-frontr);wake
)



;
(script dormant wall2-ledge-back-sentinels

	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-f-noglass03 (players))
			(volume_test_objects wall2-ledge-back-sentinels (players))
		)	
		15)
	(ai_place wall2-ledge-back-sentinels)
	(sleep_until (<= (ai_living_count wall2-ledge-back-sentinels) 1))
	(ai_place wall2-ledge-back-sentinels)
)
(script dormant wall2-ledge-back-exit

	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-f-noglass03 (players))
			(volume_test_objects wall2-ledge-back-exit (players))
		)	
	15)
	;(wake wall2-cond01-entrance);wake
	(ai_place wall2-ledge-back-exit01)
	(sleep_until 
		(or	
			(<= (ai_living_count wall2-ledge-back-exit01) 1)
			(volume_test_objects wall2-ledge-back-exit02 (players))
		)	
	15)
	
	(ai_place wall2-ledge-back-exit02)
)

(script dormant wall2-ledge-back-low

	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-f-noglass02 (players))
			(volume_test_objects wall2-ledge-back-low (players))
		)
	15)
	(ai_place wall2-ledge-back-low)
	(ai_place wall2-ledge-back-low-exit-car)
	
	
)

(script dormant wall2-ledge-middle-glass02

	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-back-low (players))
			(<= (ai_living_count wall2-ledge-middle-right02) 3)
		)	
	15)
	(ai_place wall2-ledge-middle-glass02)
)

(script dormant wall2-ledge-middle-right02

	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-middle-right02 (players))
			(volume_test_objects wall2-ledge-f-noglass02 (players))
		)
		15)
	
	
	(ai_place wall2-ledge-middle-right02)
	(wake wall2-ledge-middle-glass02);wake
	(wake wall2-ledge-back-low);wake

)

(script dormant wall2-ledge-middle-glass

	(print "hi")

	;(sleep_until 
	;	(or
	;		(volume_test_objects wall2-ledge-middle-left-glass (players))
	;		(<= (ai_living_count wall2-ledge-middle-left) 3)
	;	)	
	;15)
	
	;(ai_set_orders wall2-ledge-middle-glass wall2-ledge-middle-left)

)

(script dormant wall2-ledge-middle-left
	
	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-f-noglass01 (players))
			(volume_test_objects wall2-ledge-middle-left (players))
		)
	15)
	
	(ai_place wall2-ledge-middle-left-car01)
	(sleep 10)
	(ai_place wall2-ledge-middle-glass)
	
	(wake wall2-ledge-middle-glass);wake
	(wake wall2-ledge-middle-right02);wake
	

	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-middle-left02 (players))
			(volume_test_objects wall2-ledge-middle-left03 (players))
			(volume_test_objects wall2-ledge-f-noglass01 (players))
			(volume_test_objects wall2-ledge-f-noglass02 (players))
		
		)	
	15)
	(ai_place wall2-ledge-middle-left)
)

(script dormant wall2-ledge-middle-low
	(sleep_until (volume_test_objects wall2-ledge-middle-low (players))15)
	(ai_place wall2-ledge-low-middle)
)
(script dormant wall2-ledge-low-tube
	(sleep_until 
		(or 
			(volume_test_objects wall2-ledge-f-noglass01 (players))
			(volume_test_objects wall2-ledge-low-tube (players))
		)
	15)
	(ai_place wall2-ledge-low-tube)
	
	(ai_place wall2-ledge-middle-sentinel)
	
	
	(sleep_until (<= (ai_living_count wall2-ledge-middle-sentinel) 1))
	(ai_place wall2-ledge-middle-sentinel)
	
	(sleep_until (<= (ai_living_count wall2-ledge-middle-sentinel) 1))
	(ai_place wall2-ledge-middle-sentinel)
)

(script dormant wall2-ledge-f01r
	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-f01r (players))
			(<= (ai_living_count wall2-ledge-f01) 1)
		)	
	15)
	(ai_place wall2-ledge-f01r)
)
(script dormant wall2-ledge-f01

	(sleep_until (volume_test_objects wall2-ledge-f01 (players))15)
	(ai_place wall2-ledge-f01)
	(game_save_unsafe);SSSAAAVVVEEE---
	(wake wall2-ledge-f01r);wake
	(wake wall2-ledge-middle-low);wake
	(wake wall2-ledge-low-tube);wake
	(wake wall2-ledge-back-exit);wake
	(wake wall2-ledge-back-sentinels);wake
	(wake wall2-ledge-middle-left);wake
	

	(sleep_until 
		(or
			(volume_test_objects wall2-ledge-low (players))
			(volume_test_objects wall2-ledge-low-tube (players))
			(<= (ai_living_count wall2-ledge-f01) 1)
			
		)	
	15)	
	(ai_place wall2-ledge-flow01)
)


;
(script command_script cs_wall2-hall01-bcar01-02
	(cs_go_to wall2-hall01-carrier/p1 1)
)
(script command_script cs_wall2-hall01-bcar01
	(cs_go_to wall2-hall01-carrier/p0 1)
)
(script static void dtest
	
	(sleep 10)
	
	(ai_erase wall2-hall01-bcar01)
	
	(sleep 15)
	
	(ai_place wall2-hall01-bcar01)
	
	(cs_run_command_script wall2-hall01-bcar01/starting_locations_0 cs_wall2-hall01-bcar01-02)
	(cs_run_command_script wall2-hall01-bcar01/starting_locations_1 cs_wall2-hall01-bcar01-02)
	(cs_run_command_script wall2-hall01-bcar01/starting_locations_2 cs_wall2-hall01-bcar01)
)

(script dormant wall2-hall01-bcar01

		(sleep_until (volume_test_objects wall2-hall01-bcar01 (players))15)
		;(wake wall2-ledge-f01);wake
		
		(ai_place wall2-hall01-bcar01)
		;(cs_run_command_script wall2-hall01-bcar01 cs_wall2-hall01-bcar01)
		
		(sleep_until (volume_test_objects wall2-hall01-b01m (players))15)
		(ai_place wall2-hall01-b01m)
		(sleep_until 
			(or
				(<= (ai_living_count wall2-hall01-b01m) 1)
				(volume_test_objects wall2-hall1-exit (players))
			)	
		15)
		(ai_place wall2-hall01-b02m)
)

(script dormant wall2-hall01-m04r
	(sleep_until (<= (ai_living_count wall2-hall01-m03) 2))
	(ai_place wall2-hall01-m04r)
)


;
(script command_script cs_wall2-hall01-mcar01-02
	(cs_move_in_direction 0 3 82.6429)
)
(script command_script cs_wall2-hall01-mcar01
	(cs_move_in_direction 0 3 0)
)
(script dormant wall2-hall01-m03
	
	(sleep_until (volume_test_objects wall2-hall01-m03 (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place wall2-hall01-m03)
	(ai_place wall2-hall01-mcar01)
	
	(cs_run_command_script wall2-hall01-mcar01/starting_locations_0 cs_wall2-hall01-mcar01)
	(cs_run_command_script wall2-hall01-mcar01/starting_locations_1 cs_wall2-hall01-mcar01)
	(cs_run_command_script wall2-hall01-mcar01/starting_locations_2 cs_wall2-hall01-mcar01)
	;(cs_run_command_script wall2-hall01-mcar01/starting_locations_3 cs_wall2-hall01-mcar01-02)
	
	(wake wall2-hall01-m04r);wake
	(wake wall2-hall01-bcar01);wake
	
	(sleep_until (<= (ai_living_count wall2-hall01-mcar01) 3))
	(ai_place wall2-hall01-mcar02)
	
)

(script dormant wall2-hall01-f03g

	(sleep_until 
		(or
			(<= (ai_living_count wall2-hall01-f01g) 1)
			(volume_test_objects wall2-hall01-f03g (players))
		)	
	15)
	(ai_place wall2-hall01-f03g)
)

(script dormant wall2-hall01-f01m

	(sleep_until (volume_test_objects wall2-hall01-f01m (players))15)
	(ai_place wall2-hall01-f01m)
	(ai_place wall2-hall01-f01g)
	(ai_place wall2-hall01-f02m)
	
	(wake wall2-hall01-f03g);wake
	(wake wall2-hall01-m03);wake
	
	(sleep_until (<= (ai_living_count sg-wall2-hall01-f01) 3))
	
	(ai_place wall2-hall01-f03gr)
	;(ai_magically_see_players wall2-hall01-f03gr)
)

(script dormant wall2-hall01-save01

	(sleep_until (volume_test_objects wall2-hall01-save01 (players))15)
	(game_save_unsafe);SSSAAAVVVEEE---
)

(script dormant ai-kill02
	(sleep_until (volume_test_objects wall2-hall01-ai-kill02 (players))15)
	
	(object_destroy rob01)
	(ai_erase wall1-plugholder01)
	(ai_erase wall1-plugholder02)
	(ai_erase wall1-plugholder-gap01)
	(ai_erase wall1-plugholder-backl01)
	(ai_erase wall1-plugholder-backcl01)
	(sleep 10)
	
	(ai_erase plugride-gap01)
	(ai_erase plugride-gap02)
	(ai_erase wall1-plugholder01)
	(ai_erase wall1-plugholder02)
	(ai_erase wall1-plugholder-gap01)
	(ai_erase wall1-plugholder-backl01)
	(ai_erase wall1-plugholder-backcl01)
	(object_destroy trenchphantom)
	
	
)

(script dormant wall2-hall01-pistondoor

	(sleep_until (volume_test_objects wall2-hall01-pistondoor (players))15)
	(wake wall2-hall01-f01m);wake
	(wake wall2-hall01-save01);wake
	(wake ai-kill02);wake
	
	(game_save_unsafe);SSSAAAVVVEEE---
	(ai_place wall2-hall01-pistondoor)
	
)


;
(script dormant wall1-plugholder-backc01
	
	(sleep_until 
		(or
			(volume_test_objects wall1-plugholder-backc (players))
			(<= (ai_living_count wall1-plugholder-backl01) 0)
		)	
	15)
	(ai_place wall1-plugholder-backcl01)
)
(script dormant wall1-plugholder-backl01

	(sleep_until 
		
		(or
			(and
				(<= (ai_living_count wall1-plugholder02) 0)
				(<= (ai_living_count wall1-plugholder01) 0)
			)
			(and
				(<= (ai_fighting_count wall1-plugholder02) 0)
				(<= (ai_fighting_count wall1-plugholder01) 0)
			)
		)
				
	30 5400)
	
	(print "FLOOD BREAK THROUGH VENT THING!!!")
	
	(ai_place wall1-plugholder-backl01)
	
	(ai_place wall1-plugholder-inf)
	
	(sleep 10)
	
	(object_destroy_containing "plugholderglass")
	
	(wake wall1-plugholder-backc01);wake
	(wake wall2-hall01-pistondoor);wake
)




(script dormant wall1-plugholder01

	(sleep_until (volume_test_objects wall1-plugholder01 (players))15)
	
	(game_save_unsafe);SSSAAAVVVEEE---
	
	(ai_place wall1-plugholder01)
	(sleep 45)
	(wake wall1-plugholder-backl01);wake
	
	(sleep_until (<= (ai_living_count wall1-plugholder01) 1))
	(ai_place wall1-plugholder02)
	
	(sleep_until (<= (ai_living_count wall1-plugholder02) 1))
	(ai_place wall1-plugholder01)
	
)



(script dormant ai-kill01

	(print "ai_kill01")
	
	(ai_erase wall1_ent)
	(ai_erase wall1_ent2)
	(ai_erase wall1_ent_slide)
	(ai_erase wall1_ent_slide2)
	(ai_erase wall1_hall01_f01)
	(ai_erase wall1_hall01_f02)
	(ai_erase wall1_hall01_m01)
	(ai_erase wall1_hall01_m02)
	(ai_erase wall1_hall01_b01)
	(ai_erase wall1_condf02)
	(ai_erase wall1_condf01)
	(ai_erase wall1_condfb01)
	(ai_erase wall1_condr_f02)
	(ai_erase wall1_condl_f02)
	(ai_erase wall1_condr_f03)
	(ai_erase wall1_condl_f03)
	(ai_erase wall1_condc_m01)
	(ai_erase wall1_condc_m02)
	(ai_erase wall1_condc_m03)
	(ai_erase wall1_condb-r01)
	(ai_erase wall1_condb-r02)
	(ai_erase wall1_condb-exit)
	(ai_erase wall1_condb-l02)
	(ai_erase wall1-condf-ambient)
	(ai_erase wall1-condm-ambient)
	(ai_erase wall1-hall02-f01up)
	(ai_erase wall1-hall02-f02)
	(ai_erase wall1-hall02-b01)
	(ai_erase wall1-hall02-b02)
	(ai_erase wall1-plug01)
	(ai_erase wall1-plug-enforcer)
	(sleep 15)
	(ai_erase wall1-plug03)
	(sleep 10)
	(ai_erase wall1-plug02)
)

(script command_script cs_plugride
	(cs_go_to plugride/p0 1)
	;(cs_jump_to_point plugride/p1 1 1)
	(cs_jump 20 .1)
	
)

(script static void dtest03
	(ai_erase plugride-gap01)
	
	(sleep 15)
	
	(ai_place plugride-gap01)
	
	(cs_run_command_script plugride-gap01 cs_plugride)
)

(script dormant plugride01
	
	(sleep_until (volume_test_objects plugride01 (players))15)
	(ai_place plugride-gap01)
	(ai_place plugride-gap02)
	
	;(cs_run_command_script plugride-gap01 cs_plugride)
)



(script dormant wall1-plugholder-gap
	
	(sleep_until (volume_test_objects trenchphantom (players))15)
	(wake ai-kill01);wake
	(object_create trenchphantom)
	(sleep_until (volume_test_objects wall1-plugholder-gap (players))15)
	(ai_place wall1-plugholder-gap01)
	
)

(script dormant plug-release-cin
	
	;(sleep_until (>= (device_get_power plug01) 1))
	(wake ai-kill01);wake
	(wake plugride01);wake

	(cinematic_start)
	
	(sleep 90)
	
	(print "gggggghhhhhhhhh!!!")
	
	(sleep 60)
	
	(print "eeeeerrrrrrrrrrr!!!")
	
	(sleep 60)
	
	(print "Kaaaaaa CHIINK!!")
	
	(sleep 30)
	
	(cinematic_stop)
)


(script static short absorber01-count
	(if
		(<= (object_get_health plugabsorber01) 0)
		0
		1
	)
)
(script static short absorber02-count
	(if
		(<= (object_get_health plugabsorber02) 0)
		0
		1
	)
)
(script static short absorber03-count
	(if
		(<= (object_get_health plugabsorber03) 0)
		0
		1
	)
)
(script static short absorber04-count
	(if
		(<= (object_get_health plugabsorber04) 0)
		0
		1
	)
)
(script static short absorber05-count
	(if
		(<= (object_get_health plugabsorber05) 0)
		0
		1
	)
)
(script static short absorber06-count
	(if
		(<= (object_get_health plugabsorber06) 0)
		0
		1
	)
)
(script static short absorber07-count
	(if
		(<= (object_get_health plugabsorber07) 0)
		0
		1
	)
)
(script static short absorber08-count
	(if
		(<= (object_get_health plugabsorber08) 0)
		0
		1
	)
)

(script static short absorber-totalcount
	(+
		(absorber01-count)
		(absorber02-count)
		(absorber03-count)
		(absorber04-count)
		(absorber05-count)
		(absorber06-count)
		(absorber07-count)
		(absorber08-count)				
	)
)

(script dormant plug-rods08
	(sleep_until (<= (object_get_health plugabsorber08) 0) 10)
	(device_set_position plug-thin-fr 1)
	(object_destroy plugabsorber08)
)

(script dormant plug-rods07
	(sleep_until (<= (object_get_health plugabsorber07) 0) 10)
	(device_set_position plug-thin-br 1)
	(object_destroy plugabsorber07)
)

(script dormant plug-rods06
	(sleep_until (<= (object_get_health plugabsorber06) 0) 10)
	(device_set_position plug-thin-bl 1)
	(object_destroy plugabsorber06)
)

(script dormant plug-rods05
	(sleep_until (<= (object_get_health plugabsorber05) 0) 10)
	(device_set_position plug-thin-fl 1)
	(object_destroy plugabsorber05)
)

(script dormant plug-rods04
	(sleep_until (<= (object_get_health plugabsorber04) 0) 10)
	(device_set_position plug-thick-fl 1)
	(object_destroy plugabsorber04)
)

(script dormant plug-rods03
	(sleep_until (<= (object_get_health plugabsorber03) 0) 10)
	(device_set_position plug-thick-bl 1)
	(object_destroy plugabsorber03)
)


(script dormant plug-rods02
	(sleep_until (<= (object_get_health plugabsorber02) 0) 10)
	(device_set_position plug-thick-br 1)
	(object_destroy plugabsorber02)
)


(script dormant plug-rods01
	(sleep_until (<= (object_get_health plugabsorber01) 0) 10)
	(device_set_position plug-thick-fr 1)
	(object_destroy plugabsorber01)
)

(script dormant plug-absorbers

	(sleep_until (volume_test_objects plug-intro (players))15)
	
	(game_save);SSSAAAVVVEEE---
	
	
	(wake plug-rods08);wake
	(wake plug-rods07);wake
	(wake plug-rods06);wake
	(wake plug-rods05);wake
	(wake plug-rods04);wake
	(wake plug-rods03);wake
	(wake plug-rods02);wake
	(wake plug-rods01);wake
	
	(sound_impulse_start "sound\dialog\levels\06_sentinelwall\mission\l06_0010_tar" none 1)
	(print "Dervish!  Destroy the GLASS absorber plates on the four pillars!!")
	
	(sleep 105)
	
	(print "There are EIGHT absorber plates that need to be destroyed!!")
	
	(sleep_until (<= (absorber-totalcount) 7))
	
	(print "absorber destroyed!")
	
	(sleep_until (<= (absorber-totalcount) 6))
	(print "absorber destroyed!")
	
	(sleep_until (<= (absorber-totalcount) 5))
	(print "absorber destroyed!")

	(sleep_until (<= (absorber-totalcount) 4))
	(print "Good job dervish!!  Im detecting half have been destroyed!!")
	
	(sleep 90)
	
	(print "Only 4 more to go!!")
	
	(sleep_until (<= (absorber-totalcount) 3))
	(print "absorber destroyed!")
	
	(sleep_until (<= (absorber-totalcount) 2))
	(print "absorber destroyed!")
	
	(sleep_until (<= (absorber-totalcount) 1))
	(print "absorber destroyed!")

	(sleep_until (<= (absorber-totalcount) 0))
	(print "absorber destroyed!")
	
	(wake ai-kill01);wake
	(object_create plug-switch)
	
	
	(device_set_position plug-keylock04 1)
	(device_set_position plug-keylock03 1)
	(device_set_position plug-keylock02 1)
	(device_set_position plug-keylock01 1)
	;(wake plug-release-cin);wake
)


;
(script command_script cs_wall1-plug03
	(cs_fly_to wall1-plugr-outside/p0 1)
	(cs_fly_to wall1-plugr-outside/p1 1)
	(cs_fly_to wall1-plugr-outside/p2 1)
)

(script command_script cs_wall1-plug02-02
	(cs_fly_to wall1-plugl-up/p3 1)
	(cs_fly_to wall1-plugl-up/p1 1)
)
(script command_script cs_wall1-plug02
	(cs_fly_to wall1-plugl-up/p2 1)
	(cs_fly_to wall1-plugl-up/p0 1)
)



(script dormant killvol-wallgap02
	(sleep_until 
		(or
			(volume_test_objects killvol01-wallgap (unit (player1)))
			(volume_test_objects killvol02-wallgap (unit (player1)))
			(volume_test_objects killvol03-wallgap (unit (player1)))
			(volume_test_objects killvol04-wallgap (unit (player1)))
			(volume_test_objects killvol05-wallgap (unit (player1)))
			(volume_test_objects killvol06-wallgap (unit (player1)))
			(volume_test_objects killvol07-wallgap (unit (player1)))
			(volume_test_objects killvol08-wallgap (unit (player1)))
		)
	5)
	
	(print "killvol activated")
	(unit_kill (unit (player1)))
)

(script dormant killvol-wallgap01
	(sleep_until 
		(or
			(volume_test_objects killvol01-wallgap (unit (player0)))
			(volume_test_objects killvol02-wallgap (unit (player0)))
			(volume_test_objects killvol03-wallgap (unit (player0)))
			(volume_test_objects killvol04-wallgap (unit (player0)))
			(volume_test_objects killvol05-wallgap (unit (player0)))
			(volume_test_objects killvol06-wallgap (unit (player0)))
			(volume_test_objects killvol07-wallgap (unit (player0)))
			(volume_test_objects killvol08-wallgap (unit (player0)))
			(volume_test_objects killvol09-wallgap (unit (player0)))
		)
	5)
	(print "killvol activated")
	
	(unit_kill (unit (player0)))
)

(script dormant wall1-plug

	(sleep_until (volume_test_objects wall1-plug (players))15)
	(wake plug-absorbers);wake
	(wake killvol-wallgap01);wake
	(wake killvol-wallgap02);wake
	
	(ai_place wall1-plug01)
	(ai_place wall1-plug-enforcer)
	
	(sleep_until (<= (ai_living_count wall1-plug01) 3))
	(ai_place wall1-plug02)
	
	(cs_run_command_script wall1-plug02/starting_locations_0 cs_wall1-plug02)
	(cs_run_command_script wall1-plug02/starting_locations_1 cs_wall1-plug02)
	(cs_run_command_script wall1-plug02/starting_locations_2 cs_wall1-plug02-02)
	
	(sleep_until (<= (ai_living_count wall1-plug02) 2))
	
	(sleep_until 
		(begin 
			(sleep 60)
			(ai_place wall1-plug03)
			(cs_run_command_script wall1-plug03 cs_wall1-plug03)
				(sleep_until 
					(<= (ai_living_count wall1-plug03) 0)
				)	
			;loop forever	
			;false
				(or
					(> (ai_spawn_count wall1-plug03) 9)
					(<= (absorber-totalcount) 0)
				)
			
		)
		;you can put testing rate here and a time out after that..yay
	5)
)

(script dormant wall1-plug-pistondoor
	
	
	(print "wall1-plug-pistondoor wake")
	(sleep_until (volume_test_objects plug-intro (players))15)
	
	(sleep_until 
		(begin 
			(print "wall1-plug-pistondoor running")
			(sleep 120)
			(ai_place wall1-plug-pistondoor)
				(sleep_until 
					(<= (ai_living_count wall1-plug-pistondoor) 0)
				)	
			;loop forever	
			;false
				(or
					(> (ai_spawn_count q-zone1-end-sent01) 8)
					(volume_test_objects wall1-plug-pistondoor (players))
				)
			
		)
		;you can put testing rate here and a time out after that..yay
	5)
)






(script dormant turn-off-walls

	(sleep_until (volume_test_objects turn-off-walls (players))15)
	(print "turn-off-walls-running")

	(sleep_forever wall2-cond03-back-r01-car)
	(sleep_forever wall2-cond03-middle-r01-car)
	(sleep_forever wall2-cond02-front)
	(sleep_forever wall2-cond01-middle01-front01)
	(sleep_forever wall2-cond01-middle01-front02)
	(sleep_forever wall2-cond01-frontr)
	(sleep_forever wall2-ledge-middle-low)
	(sleep_forever wall2-hall01-m04r)
	(sleep_forever wall2-hall01-m03)
	(sleep_forever wall1-plug-pistondoor)
	(sleep_forever killvol-wallgap02)
	(sleep_forever killvol-wallgap01)
	
	(sleep 10)
	
	(ai_erase_all)
	
	(object_destroy_containing "dead_body")
	
	(sleep 10)
	
	(garbage_collect_unsafe)
)


;
(script command_script cs_wall1-hall02-b01-04
	(cs_fly_to wall1-hall02-b01/p3 1)
)
(script command_script cs_wall1-hall02-b01-03
	(cs_fly_to wall1-hall02-b01/p0 1)
)
(script command_script cs_wall1-hall02-b01-02
	(cs_fly_to_and_face wall1-hall02-b01/p3 wall1-hall02-b01/p2 1)
	(cs_fly_to_and_face wall1-hall02-b01/p4 wall1-hall02-b01/p2 1)
)
(script command_script cs_wall1-hall02-b01
	(cs_fly_to_and_face wall1-hall02-b01/p0 wall1-hall02-b01/p2 1)
	(cs_fly_to_and_face wall1-hall02-b01/p1 wall1-hall02-b01/p2 1)
)

(script dormant wall1-hall02-b01

	(sleep_until (volume_test_objects wall1-hall02-b01 (players))15)
	
	(wake wall1-plug-pistondoor);wake
	(wake turn-off-walls);wake
	;(wake wall1-plug);wake

	(ai_place wall1-hall02-b01)
	
	(cs_run_command_script wall1-hall02-b01/starting_locations_0 cs_wall1-hall02-b01)
	(cs_run_command_script wall1-hall02-b01/starting_locations_1 cs_wall1-hall02-b01)
	(cs_run_command_script wall1-hall02-b01/starting_locations_2 cs_wall1-hall02-b01-02)
	
	(sleep_until (<= (ai_living_count wall1-hall02-b01) 2))
	
	(ai_place wall1-hall02-b02)
	
	;(cs_run_command_script wall1-hall02-b02/starting_locations_0 cs_wall1-hall02-b01-03)
	;(cs_run_command_script wall1-hall02-b02/starting_locations_1 cs_wall1-hall02-b01-04)
	;(cs_run_command_script wall1-hall02-b02/starting_locations_2 cs_wall1-hall02-b01-04)
)


;
(script command_script cs_wall1_hall02-f02-02
	(cs_fly_to_and_face wall1-hall02-f02/p3 wall1-hall02-f02/p2 1)
)
(script command_script cs_wall1_hall02-f02
	(cs_fly_to_and_face wall1-hall02-f02/p0 wall1-hall02-f02/p2 1)
	(cs_fly_to_and_face wall1-hall02-f02/p1 wall1-hall02-f02/p2 1)
)
(script command_script cs_wall1_hall02-f01up	
	(cs_fly_to wall1-hall02-f02/p4 2)
)

(script dormant wall1-hall02-f01up

	(sleep_until (volume_test_objects wall1-hall02-f01up (players))15)
	
	(game_save);SSSAAAVVVEEE---
	
	(wake wall1-hall02-b01);wake
	
	(ai_place wall1-hall02-f01up)
	(cs_run_command_script wall1-hall02-f01up cs_wall1_hall02-f01up)
	
	(sleep_until (volume_test_objects wall1-hall02-f02 (players))15)
	(ai_place wall1-hall02-f02)
	
	(cs_run_command_script wall1-hall02-f02/starting_locations_0 cs_wall1_hall02-f02)
	(cs_run_command_script wall1-hall02-f02/starting_locations_1 cs_wall1_hall02-f02-02)
	(cs_run_command_script wall1-hall02-f02/starting_locations_2 cs_wall1_hall02-f02-02)
)


;
(script command_script cs_wall1_condB-l02
	(cs_fly_to_and_face wall1_condB-l02/p0 wall1_condB-l02/p2 1)
	(cs_fly_to_and_face wall1_condB-l02/p1 wall1_condB-l02/p2 1)
	
)
(script dormant wall1_condB-l02

	(sleep_until (volume_test_objects wall1_condB-l02 (players))15)
	(ai_place wall1_condB-l02)
	
	(cs_run_command_script wall1_condB-l02/starting_locations_0 cs_wall1_condB-l02)
)

;
(script command_script cs_wall1_condB-r02-02
	(cs_fly_to_and_face wall1_condB-r02/p1 wall1_condB-r02/p0 1)
)
(script command_script cs_wall1_condB-r02
	(cs_fly_to_and_face wall1_condB-r02/p0 wall1_condB-r02/p1 1)
)
(script dormant wall1_condB-r02

	(sleep_until 
		(or
			(volume_test_objects wall1_condB-r02 (players))
			(<= (ai_living_count  wall1_condB-r01) 0)
		)
	15)
	;(wake wall1-hall02-f01up);wake
	(ai_place wall1_condB-r02)
	
	(cs_run_command_script wall1_condB-r02/starting_locations_0 cs_wall1_condB-r02)
	(cs_run_command_script wall1_condB-r02/starting_locations_1 cs_wall1_condB-r02-02)
	(cs_run_command_script wall1_condB-r02/starting_locations_2 cs_wall1_condB-r02-02)
	
	(sleep_until 
		(or
			(volume_test_objects wall1-condB-exit (players))
			(<= (ai_living_count  wall1_condB-r02) 0)
		)
	15)
	
	(ai_place wall1_condB-exit)
)

;
(script command_script cs_wall1_condB-r01-02
	(cs_fly_to_and_face wall1_condB-r02/p2 wall1_condB-r02/p3 1)
)
(script command_script cs_wall1_condB-r01
	(cs_fly_to_and_face wall1_condB-r01/p0 wall1_condB-r01/p2 1)
)
(script dormant wall1_condB-r01

	(sleep_until (volume_test_objects wall1_condB-r01 (players))15)
	(ai_place wall1_condB-r01)
	(cs_run_command_script wall1_condB-r01/starting_locations_0 cs_wall1_condB-r01)
	(cs_run_command_script wall1_condB-r01/starting_locations_1 cs_wall1_condB-r01)
	(cs_run_command_script wall1_condB-r01/starting_locations_2 cs_wall1_condB-r01-02)
)

;
(script dormant wall1_condM_back
	
	(sleep_until (volume_test_objects wall1_condM_back (players))15)
	
	(wake wall1_condB-r01);wake
	(wake wall1_condB-r02);wake
	(wake wall1_condb-l02);wake
	
	(ai_place wall1_condC_M02)
	
	(sleep_until 
		(or
			(volume_test_objects wall1_condM_back_r (players))
			(<= (ai_living_count wall1_condC_M02) 1)
		)		
	15)
	
	(ai_place wall1_condC_M03)
)

(script dormant wall1_condM_idle
	
	(sleep_until (volume_test_objects wall1_condM_idle (players))15)
	(ai_place wall1_condC_M01)
)



;
(script command_script cs_wall1-condm-ambient

	(cs_fly_to wall1-condm-ambient/p0 1)
	(cs_fly_to wall1-condm-ambient/p1 1)
	(cs_fly_to wall1-condm-ambient/p2 1)
	(cs_fly_to_and_face wall1-condm-ambient/p3 wall1-condm-ambient/p4 1)
	(cs_fly_to wall1-condm-ambient/p2 1)
	(cs_fly_to wall1-condm-ambient/p1 1)
	(cs_fly_to wall1-condm-ambient/p0 1)
	(cs_fly_to wall1-condm-ambient/p4 1)
)
(script dormant wall1-condm-ambient-loop

	(sleep 15)
	(sleep_until 
		(begin 
			(cs_run_command_script wall1-condm-ambient cs_wall1-condm-ambient)
				(sleep_until 
					(not 
						(cs_command_script_running wall1-condm-ambient cs_wall1-condm-ambient)
					)
				)
				
			;loop forever	
			;false
			(or
				
				(<= (ai_living_count wall1-condm-ambient) 0)
				(volume_test_objects wall1-hall02-f01up (players))
			)
		)
		;you can put testing rate here and a time out after that..yay
	5)
	
)
(script dormant wall1-condm-ambient
	
	(ai_place wall1-condm-ambient)
	(wake wall1-condm-ambient-loop);wake
)


;
(script command_script cs_wall1_condR_F03
	(cs_fly_to_and_face wall1_condr_F02/p3 wall1_condr_F02/p4 1)
	(cs_fly_to_and_face wall1_condr_F02/p2 wall1_condr_F02/p4 1)
)
(script command_script cs_wall1_condl_F03-02
	(cs_fly_to_and_face wall1_condl_F02/p1 wall1_condl_F02/p4 1)
)
(script command_script cs_wall1_condl_F03
	(cs_fly_to_and_face wall1_condl_F02/p3 wall1_condl_F02/p4 1)
)
(script dormant wall1_condR_F02
	(sleep_until (volume_test_objects wall1_condR_F02 (players))15)
	
	(if G_wall1_condLR_F02 (sleep_forever))
	(set G_wall1_condLR_F02 true)

	(ai_place wall1_condl_F03)

	(cs_run_command_script wall1_condl_F03/starting_locations_0 cs_wall1_condl_F03)
	(cs_run_command_script wall1_condl_F03/starting_locations_1 cs_wall1_condl_F03)
	(cs_run_command_script wall1_condl_F03/starting_locations_2 cs_wall1_condl_F03-02)

	(ai_place wall1_condR_F03)
	(cs_run_command_script wall1_condR_F03 cs_wall1_condr_F03)
)


(script command_script cs_wall1_condL_F02
	(cs_fly_to_and_face wall1_condL_F02/p0 wall1_condL_F02/p2 1)
	(cs_fly_to_and_face wall1_condL_F02/p1 wall1_condL_F02/p2 1)
)

(script command_script cs_wall1_condR_F02-02
	(cs_fly_to_and_face wall1_condR_F02/p2 wall1_condR_F02/p1 1)
)
(script command_script cs_wall1_condR_F02
	(cs_fly_to_and_face wall1_condR_F02/p0 wall1_condR_F02/p1 1)
)
(script dormant wall1_condL_F02

	(sleep_until (volume_test_objects wall1_condL_F02 (players))15)
	
	(if G_wall1_condLR_F02 (sleep_forever))
	(set G_wall1_condLR_F02 true)

	(ai_place wall1_condR_F02)

	(cs_run_command_script wall1_condR_F02/starting_locations_0 cs_wall1_condR_F02)
	(cs_run_command_script wall1_condR_F02/starting_locations_1 cs_wall1_condR_F02)
	(cs_run_command_script wall1_condR_F02/starting_locations_2 cs_wall1_condR_F02-02)

	(ai_place wall1_condL_F02)
	(cs_run_command_script wall1_condL_F02 cs_wall1_condL_F02)
)


(script command_script cs_wall1_condF02
	(cs_fly_to_and_face wall1_cond_F01/p2 wall1_cond_F01/p4 1)
	(cs_fly_to_and_face wall1_cond_F01/p3 wall1_cond_F01/p4 1)
)
(script command_script cs_wall1_condF01
	(cs_fly_to_and_face wall1_cond_F01/p0 wall1_cond_F01/p1 1)
)
(script dormant wall1_condF01

	(sleep_until (volume_test_objects game-save-cond01 (players))15)

	(ai_place wall1-cond1-sen-atk-a)
	(ai_place wall1-cond1-allies)

	(sleep_until 
		(or
			(volume_test_objects wall1_condF01 (players))
			(volume_test_objects wall1_condF01-02 (players))
		)
	15)
	
	(wake wall1_condL_F02);wake
	(wake wall1_condR_F02);wake
	(wake wall1_condM_idle);wake
	(wake wall1_condM_back);wake
	(wake wall1-condm-ambient);wake
	
	(ai_place wall1_condF01)
	
	(cs_run_command_script wall1_condF01/starting_locations_0 cs_wall1_condF01)
	(cs_run_command_script wall1_condF01/starting_locations_1 cs_wall1_condF01)
	
	(ai_place wall1_condF02)
	
	(cs_run_command_script wall1_condF02 cs_wall1_condF02)
	
	(sleep_until 
		(or
			(volume_test_objects wall1_condFB01 (players))
			(<= (ai_living_count sg_wall1_condF01) 2)
		)		
	15)
	
	(ai_place wall1_condFB01)
)

;
(script command_script cs_wall1-condF-ambient
	(cs_fly_to wall1-condF-ambient/p0 1)
	(cs_fly_to wall1-condF-ambient/p1 1)
	(cs_fly_to wall1-condF-ambient/p2 1)
	
	(ai_erase wall1-condF-ambient)
)
(script dormant wall1-condF-ambient

	(sleep_until (volume_test_objects wall1-condF-ambient (players))15)
	(ai_place wall1-condF-ambient)
	(cs_run_command_script wall1-condF-ambient cs_wall1-condF-ambient)
)


;
(script dormant wall1_hall01_b01
	(sleep_until (volume_test_objects wall1_hall01_b01 (players))15)
	(ai_place wall1_hall01_b01)
)

(script command_script cs_wall1_hall01_m01
	(cs_fly_to_and_face wall1_hall01_m01/p0 wall1_hall01_m01/p2 1)
	(cs_fly_to_and_face wall1_hall01_m01/p1 wall1_hall01_m01/p2 1)
)
(script dormant wall1_hall01_m01
	
	(sleep_until (volume_test_objects wall1_hall01_m01 (players))15)
	
	(wake wall1_hall01_b01);wake
	(wake wall1-condF-ambient);wake
	
	(ai_place wall1_hall01_m01)
	
	(cs_run_command_script wall1_hall01_m01 cs_wall1_hall01_m01)
	
	(sleep_until 
		(or
			(volume_test_objects wall1_hall01_m02 (players))
			(<= (ai_living_count wall1_hall01_m01) 2)
		)		
	15)
	
	(ai_place wall1_hall01_m02)
	
	(cs_run_command_script wall1_hall01_m02 cs_wall1_hall01_m01)
)


(script command_script cs_wall1_hall01_f02-3
	(cs_fly_to_and_face wall1_hall01_f02/p3 wall1_hall01_f02/p2 1)
)
(script command_script cs_wall1_hall01_f02-2
	(cs_fly_to_and_face wall1_hall01_f02/p1 wall1_hall01_f02/p2 1)
)
(script command_script cs_wall1_hall01_f02
	(cs_fly_to_and_face wall1_hall01_f02/p0 wall1_hall01_f02/p2 1)
)

(script dormant wall1_hall01_f01

	(sleep_until (volume_test_objects wall1_hall01_f01 (players))15)
	
	(wake wall1_hall01_m01);wake
	
	;(ai_place wall1_hall01_f01)
	
 	;(sleep_until (volume_test_objects wall1_hall01_f02 (players))15)
	
	;(ai_place wall1_hall01_f02)
	
	;(cs_run_command_script wall1_hall01_f02/starting_locations_0 cs_wall1_hall01_f02)
	;(cs_run_command_script wall1_hall01_f02/starting_locations_1 cs_wall1_hall01_f02)
	;(cs_run_command_script wall1_hall01_f02/starting_locations_2 cs_wall1_hall01_f02-2)
	;(cs_run_command_script wall1_hall01_f02/starting_locations_3 cs_wall1_hall01_f02-3)
)


(script command_script cs_wall1_ent_slide2-02

	(cs_fly_to wall1_ent_slide/p4 1)
)
(script command_script cs_wall1_ent_slide2

	(cs_fly_to_and_face wall1_ent_slide/p2 wall1_ent_slide/p3 1)
)
(script dormant wall1_ent_slide2

	(sleep_until (volume_test_objects wall1_ent_slide2 (players))15)
	(ai_place wall1_ent_slide2)
	(cs_run_command_script wall1_ent_slide2/starting_locations_0 cs_wall1_ent_slide2-02)
	(cs_run_command_script wall1_ent_slide2/starting_locations_1 cs_wall1_ent_slide2)
)


(script command_script cs_wall1_ent_slide

	(cs_fly_to_and_face wall1_ent_slide/p0 wall1_ent_slide/p1 1)
)
(script dormant wall1_ent_slide

	(sleep_until (volume_test_objects wall1_ent_slide (players))15)
	(wake wall1_ent_slide2);wake
	
	(ai_place wall1_ent_slide)
		
	(cs_run_command_script wall1_ent_slide cs_wall1_ent_slide)
)


(script command_script cs_wall1_ent2-2
	(cs_fly_to_and_face wall1_ent2/p1 wall1_ent2/p2 1)
)
(script command_script cs_wall1_ent2
	(cs_fly_to_and_face wall1_ent2/p0 wall1_ent2/p2 1)
)

(script command_script cs_wall1_ent-2
	(cs_fly_to_and_face wall1_ent/p0 wall1_ent/p2 1)
)
(script command_script cs_wall1_ent
	(cs_fly_to_and_face wall1_ent/p1 wall1_ent/p2 1)
)
(script dormant wall1_ent

	(wake wall1_ent_slide);wake
	
	(sleep_until (volume_test_objects wall1_ent (players))15)
	
	(ai_place wall1-ent-back)
	
	(ai_place wall1-ent-back02)
	
	;(ai_place wall1_ent)
	
	;(cs_run_command_script wall1_ent/starting_locations_0 cs_wall1_ent)
	;(cs_run_command_script wall1_ent/starting_locations_1 cs_wall1_ent)
	;(cs_run_command_script wall1_ent/starting_locations_2 cs_wall1_ent)
	;(cs_run_command_script wall1_ent/starting_locations_3 cs_wall1_ent-2)
	
	;(sleep_until (<= (ai_living_count wall1_ent) 2))
	
	;(ai_place wall1_ent2)
	
	;(cs_run_command_script wall1_ent2/starting_locations_0 cs_wall1_ent2)
	;(cs_run_command_script wall1_ent2/starting_locations_1 cs_wall1_ent2)
	;(cs_run_command_script wall1_ent2/starting_locations_2 cs_wall1_ent2-2)
)

(script dormant game-save-cond01

	(sleep_until (volume_test_objects game-save-cond01 (players))15)
	(game_save_unsafe);SSSAAAVVVEEE---

)



(script startup sentinelhq	
	
;	(wake game_save01);wake

	(wake game-save-cond01);wake
	

	(wake wall1_condF01);wake
	
	(wake wall1_hall01_f01);wake
	(wake wall1-hall02-f01up);wake
	(wake wall1-plugholder01);wake
	(wake wall1-plugholder-gap);wake
	
	(wake wall1-plug);wake
	(wake wall2-ledge-f01);wake
	(wake wall2-cond01-entrance);wake
	(wake wall2-exit-pistondoor-car01);wake
	(wake wallexit-front);wake
	(wake defen-allies-elites01);wake
	(wake sen-interior-front);wake
	(wake sen-b-area-enfor01);wake
	(wake senfac1-start);wake
	(wake asenfac-front);wake
	(wake keyholder-flood01);wake
	
	(wake plugride01);wake
	(wake library);wake
	
	(wake keyride-front01);wake
	
	(if (cinematic_skip_start)
		(begin
			
			(if (cinematic_skip_start)
				(begin
					(X06)
				)
			)
			(cinematic_skip_stop)

			(if (cinematic_skip_start)
				(begin
					(C06_intro)
				)
			)
			(cinematic_skip_stop)
		)
	)
	
	(wake wall1_ent);wake
	
	
;	(wake wall1_maj00_maj01);wake
	
;	(wake wall1_min01_sent01);wake
	
;	(wake wall1_cir_maj01);wake
	
;	(ai_place a_elites)

;	(print "place a_elites")
	
	;(sleep_forever wall1-condm-ambient-loop)
	;(sleep_until (volume_test_objects wall1-hall02-f01up (players))15)
	;(sleep_forever wall1-condm-ambient-loop);sleep
;	(sleep_forever wall1_maj01_a_sent02_loop)
;	(sleep_forever wall1_maj01_a_sent03_loop)
;	(sleep_forever wall1_bz01_a_sent01_loop)
	
)
