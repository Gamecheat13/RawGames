;   C10 Cinematics Script

;========== Global Variables ==========

;========== Junk Scripts ==========

(script static void c10_cinematic_placeholder
	(cinematic_start)
	(sleep (* 30 2.5))
	(print "insert cinematic here")
	(sleep (* 30 2.5))
	(cinematic_stop)
	)

(script static void cinematic_placeholder_endgame
	(cinematic_start)
	(sleep (* 30 2.5))
	(print "insert cinematic here")
	(sleep (* 30 2.5))
	)

;========== Dialog Scripts ==========

(script dormant dialog_initial_dropoff
	(print "Pilot: We're here Chief.")
	(print "Pilot: The last transmission from the Captain's dropship was tracked to this location.")
	(print "Pilot: That was over 12 hours ago and since then no one's been able to raise Captain Keyes or his team.")
	)
	
(script dormant dialog_pilot_patroling
	(print "Pilot: I'll stay in the area just in case anything happens.")
	(print "Pilot: When you find the Captain radio and I'll come pick up everyone.")
	)

(script dormant dialog_pilot_nav_point
	(print "Pilot: I'll mark the last known position of the captain's dropship on your motion sensor")
	)

(script dormant dialog_pilot_good_luck
	(print "Pilot: Good luck sir.")
	)

; this should eventually be a sound point that is placed in the editor
(script static void dialog_repeating_message
	(print "[over the radio]... immediate assistance... can't raise him...")
	(sleep (* 30 2))
	(print "[over the radio]... attacked... something out there...")
	(sleep (* 30 2))
	(print "[over the radio]... swamp... not Covenant...")
	(sleep (* 30 2))
	(print "[over the radio]... Captain Keyes... missing...")
	(sleep (* 30 2))
	(print "[over the radio]... Forerunner structure in the swamp... heavy Covenant presence...")
	(sleep (* 30 2))
	(print "[over the radio]... Mayday... this is command dropship Cerberus...") 
	(sleep (* 30 2))
	(print "[over the radio]... ... ...")
	(sleep (* 30 2))
	)

(script dormant dialog_marine_a
	(print "Marine: Stay back!  You're one of them!  One of those monsters!")
	)
(script dormant dialog_marine_b
	(print "Marine: I said stay back!")
	)
	
(script dormant dialog_marine_c
	(print "Marine: (angry/scared) Aaaaaah!!!!")
	)

(script dormant dialog_marine_d
	(print "Marine: Get away!")
	)
	
(script dormant dialog_marine_e
	(print "Marine: Find your own hiding place!")
	)

(script dormant dialog_marine_f
	(print "Marine: I'm smart!  I hid, not like the others… dead, worse than dead.")
	(print "Marine: Those things hauled them off, still breathing… still screaming.")
	)

(script dormant dialog_marine_g
	(print "Marine: (hysterical) Aaah!!! Aaah!!! Aaaaaah!!!")
	)
	
(script dormant dialog_marine_h
	(print "Marine: Just leave me alone!")
	)

(script dormant dialog_marine_i
	(print "Marine: Sarge, Jenkins, Bisenti… all of them!  Those…things killed them all!")
	)

(script dormant dialog_marine_j
	(print "Marine: I don't want to go!")
	)

(script dormant dialog_marine_k
	(print "Marine: (crying) Aaaaaah!!!!")
	)

(script dormant dialog_marine_l
	(print "Marine: No!")
	)

(script dormant dialog_marine_m
	(print "Marine: Stay back you.  I won't end up like the others.  I won't let you take me!")
	)

(script dormant dialog_pilot_found
	(print "Pilot: Chief is that you!?!  I lost your signal when you disappeared inside the structure.")
	(print "Pilot: What's going on down there?  I'm tracking movement all over the place!")
	)

(script dormant dialog_cyborg_extraction
	(print "Chief: I need extraction, I'll explain later.")
	)
	
(script dormant dialog_pilot_no_can_do
	(print "Pilot: I can't sir.") 
	(print "Pilot: Your somewhere under the swamp's canopy and I don't see any way through.")
	)

(script dormant dialog_pilot_tower
	(print "Pilot: There's a tower sticking up out of the fog a few hunder meters from your current location.")
	(print "Pilot: If you can climb above the canopy I can pick you up.")
	)

(script dormant dialog_monitor_greetings
	(print "Monitor: Greetings!  I'm 342 Guilty Spark.")
	)

(script dormant dialog_monitor_flood_a
	(print "Monitor: It appears that someone has carelessly let loose the Flood.")
	)

(script dormant dialog_monitor_flood_b
	(print "Monitor: The Flood will try to leave Halo if given the chance.")
	(print "Monitor: We need to stop them and I'll need your assistance.")
	)

(script dormant dialog_monitor_leave
	(print "Monitor: Come with me.")
	)

(script dormant dialog_pilot_lost_signal
	(print "Pilot: Chief!  I've lost your signal, where'd you go!?!  Chief!  Chief!")
	)
