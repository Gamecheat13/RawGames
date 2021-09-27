#include maps\_utility;
#include maps\_anim;
#include maps\_sandstorm;

main()
{
	anims();
	animated_prop_setup();
	animated_model_setup();
	vehicle_intro_setup();
	load_player_anims();
}

#using_animtree( "generic_human" );
anims()
{
	
	// -- INTRO --
	// "We only get one shot at this"
	level.scr_sound[ "soap" ][ "payback_mct_targetsite" ] = "payback_mct_targetsite";  	
	
	// "Aye, we hit the target building fast and take down Warrabe!" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "price" ][ "payback_pri_targetbuilding" ] = "payback_pri_targetbuilding";  	
	
	// "That sandstorm's gonna piss on our plan if we drag our feet." - NOTETRACKED (keep for reference)
	//level.scr_sound[ "soap" ][ "payback_mct_dragourfeet" ] = "payback_mct_dragourfeet";  	
	
	// "Bravo team, take point through the gate!"
	level.scr_sound[ "price" ][ "payback_pri_throughgate" ] = "payback_pri_throughgate";  	
	
	// "Nikolai, soften 'em up!"
	level.scr_sound[ "price" ][ "payback_pri_softenhim" ] = "payback_pri_softenhim";  	
			
	// "Missiles away"
	level.scr_radio[ "payback_nik_misslesaway" ] = "payback_nik_misslesaway";		
	
	// "Targets ahead. Engage! Engage!"
	level.scr_sound[ "price" ][ "payback_pri_targetsahead" ] = "payback_pri_targetsahead";  	
	
	
	// -- ENEMY MEGAPHONE ANNOUNCEMENTS --
		
	// "Mortar teams, target the enemy squads!"
	level.scr_radio["payback_mrc3_mortarteams"] = "payback_mrc3_mortarteams"; 
	
	// "Destroy the helicopter! It's their only air support!"
	level.scr_radio["payback_mrc3_destroy"] = "payback_mrc3_destroy"; 
	
	// "The enemy is headed for the main house! Stop them!"
	level.scr_radio["payback_mrc3_mainhouse"] = "payback_mrc3_mainhouse"; 
	
	// "Set up additional gun emplacements. Do not let the enemy advance!"
	level.scr_radio["payback_mrc3_gunemplacements"] = "payback_mrc3_gunemplacements"; 
	
	// "The enemy is moving forward! More reinforcements are needed!"
	level.scr_radio["payback_mrc3_reinforcements"] = "payback_mrc3_reinforcements"; 
	
	// "All troops report to the main house! Move it!"
	level.scr_radio["payback_mrc1_alltroops"] = "payback_mrc1_alltroops"; 
	
	
	// -- OUTER COMPOUND --
	
	// "Yuri, stay with the team."
	level.scr_radio["payback_pri_staywithteam"] = "payback_pri_staywithteam"; 
	
	// "Go! Go!! Go!!!"
	//level.scr_sound[ "soap" ][ "payback_mct_gogogo_r" ] = "payback_mct_gogogo";  			
	
	// "Take these muppets down fast and push through to the target building."
	level.scr_sound[ "soap" ][ "payback_mct_takedown_r" ] = "payback_mct_takeemdown";  		
	
		
	// -- MORTARS --
	
	// "They're targeting us with mortars!"
	level.scr_sound["soap"][ "payback_mct_tagetusmorters_r" ] = "payback_mct_usingmortars";
	
	// "Nikolai, we need air support."
	level.scr_sound["price"][ "payback_pri_weneedair_r" ] = "payback_pri_needsupport";
	
	// "Moving into position now."
	level.scr_radio[ "payback_nik_movinginto_r" ] = "payback_nik_intoposition";  		
		
	// "Yuri, you've got control. Light 'em up."
	level.scr_sound[ "price" ][ "payback_pri_yougotcontrol_r" ] = "payback_pri_gotcontrol";  	
	
	
	// -- ENEMY REINFORCEMENTS / COMBAT CHATTER -- 
	
	// "Additional hostiles coming in from the north."
	level.scr_radio[ "payback_nik_additonalhostiles_r" ] = "payback_nik_hostilesnorth";		
	
	// Sweep under the docks!
	level.scr_sound["price"]["payback_pri_sweepunder"] = "payback_pri_sweepunder";
	
	// Lay down covering fire so we can move up the road!
	level.scr_sound["price"]["payback_pri_laydowncovering"] = "payback_pri_laydowncovering";
		
	// "Technicals coming in from the north."
	level.scr_sound[ "price" ][ "payback_pri_techincalscoming_r" ] = "payback_pri_technicals";
	
	// "More hostiles coming out of the buildings."
	level.scr_radio[ "payback_nik_morehostiles_r" ] = "payback_nik_outofbuildings";  	
	
	// "Enemy troops crossing the road."
	level.scr_radio[ "payback_nik_enemytroops_r" ] = "payback_nik_crossingroad";  		
	
	// "Additional forces closing in."
	level.scr_radio[ "payback_nik_additonalforces_r" ] = "payback_nik_closingin";  		
		
	// "The sand storm is moving in fast."
	//level.scr_radio[ "payback_nik_sandstorm_r" ] = "payback_nik_sandstorm";  		
	
	// "Roger that. All teams, we have to get to Waraabe before that storm hits. "
	//level.scr_sound[ "price" ][ "payback_pri_getkruger" ] = "payback_pri_getkruger";  		
	
		
	// -- OUTER COMPOUND OBJECTIVE REMINDERS --
	
	// "Advance to the target building!"
	level.scr_sound[ "price" ][ "payback_pri_advancetotarget" ] = "payback_pri_advancetotarget";  		
	
	// "Don't get pinned down. Warrabe's just ahead."
	level.scr_sound[ "price" ][ "payback_pri_pinneddown" ] = "payback_pri_pinneddown";  		
	
	// "Let's go. We have to get Warrabe!"
	level.scr_sound[ "price" ][ "payback_pri_getwaraabe" ] = "payback_pri_getwaraabe";  		
	
	// "Target building in sight - watch for crossfire!"
	level.scr_sound[ "soap" ][ "payback_mct_targetbuilding" ] = "payback_mct_targetbuilding";  		
	
	// "Move! Move! Let's find Warrabe."
	level.scr_sound[ "soap" ][ "payback_mct_findwaraabe" ] = "payback_mct_findwaraabe";  		
		
	// "Come on, let's get to the target building!"
	level.scr_sound[ "price" ][ "payback_pri_cmonletsget" ] = "payback_pri_cmonletsget";  		
	
	// "Yuri, move it! We've got to Warrabe before he escapes!
	level.scr_sound[ "price" ][ "payback_pri_yurimoveit" ] = "payback_pri_yurimoveit"; 
	
	// "Push forward to the compound!"
	//level.scr_sound[ "price" ][ "payback_pri_pushforward" ] = "payback_pri_pushforward";  		
		
	// "Let's go! Come on!"
	level.scr_sound[ "price" ][ "payback_pri_letsgocmon" ] = "payback_pri_letsgocmon";  		
	
		
	// -- NIKOLAI STRAFING RUNS --
	
	// "I'm in position for another pass."
	level.scr_radio[ "payback_nik_inposition" ] = "payback_nik_inposition";
	
	// "I'm ready to make another pass."
	level.scr_radio[ "payback_nik_ready" ] = "payback_nik_ready";
	
	// "Ready for another gun run."
	level.scr_radio[ "payback_nik_gunrun" ] = "payback_nik_gunrun";
	
	// "Price, the remote gun is online."
	level.scr_radio[ "payback_nik_gunonline" ] = "payback_nik_gunonline";
	
	// "Yuri, use the remote gun."
	level.scr_radio[ "payback_nik_useremotegun" ] = "payback_nik_useremotegun";
	
	// "Yuri, I'm ready for another strafing run."
	level.scr_radio[ "payback_nik_imready" ] = "payback_nik_imready";
	
	// "Activate the remote gun, Yuri."
	level.scr_radio[ "payback_nik_activategun" ] = "payback_nik_activategun";
	
	// -- NIKOLAI STRAFING RUN ENDS --
	
	// "Maneuvering around for another run."
	level.scr_radio[ "payback_nik_maneuvering" ] = "payback_nik_maneuvering";
	
	// "Circling back for another pass."
	level.scr_radio[ "payback_nik_circling" ] = "payback_nik_circling";
	
	// "I'll make another strafing run."
	level.scr_radio[ "payback_nik_anotherstrafing" ] = "payback_nik_anotherstrafing";
	
	// "I'll fly back for another pass."
	level.scr_radio[ "payback_nik_flyback" ] = "payback_nik_flyback";
	
	// "Coming back for another strafing run."
	level.scr_radio[ "payback_nik_comingback" ] = "payback_nik_comingback";
	
	// "I'll swing around for another run."
	level.scr_radio[ "payback_nik_swingaround" ] = "payback_nik_swingaround";
	
	// "I'll come back for another pass."
	level.scr_radio[ "payback_nik_anotherpass" ] = "payback_nik_anotherpass";
	
	
	// -- CHOPPER TARGET KILLS --
	// "Kills confirmed."
	level.scr_radio[ "payback_pri_killsconfirmed" ] = "payback_pri_killsconfirmed";
	
	// "Confirmed kill. Nice work."
	level.scr_radio[ "payback_pri_confirmedkill" ] = "payback_pri_confirmedkill";
	
	// "Good effect on target. Vehicle destroyed."
	level.scr_radio[ "payback_pri_vehicledestroyed" ] = "payback_pri_vehicledestroyed";
	
	// "Target destroyed. Well done, Yuri."
	level.scr_radio[ "payback_pri_welldoneyuri" ] = "payback_pri_welldoneyuri";
	
	// "Multiple kills confirmed."
	level.scr_radio[ "payback_pri_multipleconfirmed" ] = "payback_pri_multipleconfirmed";
	
	// "Keep putting rounds down."
	level.scr_radio[ "payback_pri_roundsdown" ] = "payback_pri_roundsdown";
	
	// "Good kills.  Very good kills."
	level.scr_radio[ "payback_nik_goodkills" ] = "payback_nik_goodkills";
	
	// "Targets down.  Keep it up."
	level.scr_radio[ "payback_nik_targetsdown" ] = "payback_nik_targetsdown";
	
	// "Nice shooting, Yuri.  Keep it coming."
	level.scr_radio[ "payback_nik_niceshooting" ] = "payback_nik_niceshooting";
	
	// "Multiple kills."
	level.scr_radio[ "payback_nik_multiplekills" ] = "payback_nik_multiplekills";
	
	// "At least 3 kills confirmed."
	level.scr_radio[ "payback_pri_atleastthree" ] = "payback_pri_atleastthree";
	
	// "5 down."
	level.scr_radio[ "payback_pri_fivedown" ] = "payback_pri_fivedown";
	
	// "6 more kills."
	level.scr_radio[ "payback_pri_sixmorekills" ] = "payback_pri_sixmorekills";
	
	// "8 plus kills."
	level.scr_radio[ "payback_pri_eightpluskills" ] = "payback_pri_eightpluskills";
	
	// -- CHOPPER NEAR MISS RPGs --
	// "That was too close."
	level.scr_radio[ "payback_nik_thatwasclose" ] = "payback_nik_thatwasclose";
	
	// "They’re aim is getting better."
	level.scr_radio[ "payback_nik_aimisbetter" ] = "payback_nik_aimisbetter";
	
	// "That almost hit me!"
	level.scr_radio[ "payback_nik_almosthit" ] = "payback_nik_almosthit";
	
	// "I hope my luck holds out!"
	level.scr_radio[ "payback_nik_luckholds" ] = "payback_nik_luckholds";
	
	// -- MAIN COMPOUND --
	// "Those MGs are tearing us apart."
	level.scr_sound[ "soap" ][ "payback_mct_tearingus" ] = "payback_mct_tearingus";
	
	// "Yuri, use the remote gun to take out those nests."
	level.scr_sound[ "price" ][ "payback_pri_yuriremotegun" ] = "payback_pri_yuriremotegun";
	
	// "Bravo Team, secure the perimeter.  Yuri, Soap - let's find this bastard."
	level.scr_sound[ "price" ][ "payback_pri_bravoteamsecure_r" ] = "payback_pri_secureperimeter";

	// "Baseplate, we’re entering the target building."
	level.scr_sound[ "price" ][ "payback_pri_baseplatetarget" ] = "payback_pri_baseplatetarget";

	
	// -- MOVING THROUGH TARGET BUILDING --
	
	// "Nikolai, prep for exfil. Echo team is standing by."
	level.scr_radio[ "payback_eol_prepforexfil" ] = "payback_eol_prepforexfil";
	
	// "Clear left."
	level.scr_sound[ "price" ][ "payback_pri_clearleft1_r" ] = "payback_pri_clearleft2";  		
	
	// "Clear right."
	level.scr_sound[ "soap" ][ "payback_mct_clearright1_r" ] = "payback_mct_clearright2";  		
	
	// "Watch those corners."
	level.scr_sound[ "price" ][ "payback_pri_wahtthecorners_r" ] = "payback_pri_watchthosecorners";  		
	
	// "First floor clear, moving to second."
	level.scr_sound[ "price" ][ "payback_pri_firstfloorclear" ] = "payback_pri_firstfloorclear";  			
	
	// "Copy. Proceed to second floor."
	level.scr_radio[ "payback_eol_proceedtosecond" ] = "payback_eol_proceedtosecond";
	
	// "Watch your corners"
	level.scr_sound[ "price" ][ "payback_pri_watchyourcorners" ] = "payback_pri_watchyourcorners";  		
			
	// "Contact front!"
	level.scr_sound[ "price" ][ "payback_pri_contactfront" ] = "payback_pri_contactfront";  			
	
	// "Possible visual on Warrabe. 2nd floor balcony."
	level.scr_radio[ "payback_nik_2ndflrbalcony" ] = "payback_nik_2ndflrbalcony";
	
	// "Copy that. Possible on Warrabe, 2nd floor." 
	level.scr_radio[ "payback_eol_2ndfloor" ] = "payback_eol_2ndfloor";
		
	// "Bravo-1, get in position."
	level.scr_sound[ "price" ][ "payback_pri_bravooneposition" ] = "payback_pri_bravooneposition";  			
	
	// "Flanking to the back now. Multiple targets entering 2nd floor room."
	level.scr_radio[ "payback_brvl_flankingtoback" ] = "payback_brvl_flankingtoback";
		
			
	// -- WARAABE BREACH --			
			
	// "Waraabe's office is just ahead."
	level.scr_sound[ "price" ][ "payback_pri_office" ] = "payback_pri_office";  

	// "That's the door to his office."	
	level.scr_sound[ "price" ][ "payback_pri_doortooffice" ] = "payback_pri_doortooffice";  
		
	// "Alright.  Easy on the trigger, mates.  We need him alive."
	level.scr_sound[ "price" ][ "payback_pri_needhimalive2" ] = "payback_pri_needhimalive2";  

	
	// -- WARAABE PRE-BREACH -- 
		
	// "Where’s my car? Why isn’t it here?"
	level.scr_sound[ "waraabe" ][ "payback_wrb_mycar" ] = "payback_wrb_mycar";
	
	// "The driver said he’s on the way.
	level.scr_sound[ "waraabe" ][ "payback_mrc1_driver" ] = "payback_mrc1_driver";
	
	// "That was five minutes ago!
	level.scr_sound[ "waraabe" ][ "payback_wrb_fiveminutes" ] = "payback_wrb_fiveminutes";
	
	// "Sir, I don’t know what ...
	level.scr_sound[ "waraabe" ][ "payback_mrc1_dontknow" ] = "payback_mrc1_dontknow";
	
	// "I have to leave now.  Right now!
	level.scr_sound[ "waraabe" ][ "payback_wrb_leavenow" ] = "payback_wrb_leavenow";
	
	// "I’m sure he’ll be here soon ...
	level.scr_sound[ "waraabe" ][ "payback_mrc1_heresoon" ] = "payback_mrc1_heresoon";
	
	// "We’re out of time! We’re trapped here!
	level.scr_sound[ "waraabe" ][ "payback_wrb_trapped" ] = "payback_wrb_trapped";
	
	
	// -- WARABBE INTERROGATION -- (KEEP)
	
	// "ARGGHHH!!!!" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "kruger" ][ "payback_wrb_pain1" ] = "payback_wrb_pain1";  					
	
	// "ARGGHHH!!!!" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "kruger" ][ "payback_wrb_pain2" ] = "payback_wrb_pain2";  					
	
	// "Gas masks on." - NOTETRACKED (keep for reference)
	//level.scr_sound[ "price" ][ "payback_pri_gasmaskson" ] = "payback_pri_gasmaskson";  					
	
	// "Look familiar?" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "price" ][ "payback_pri_lookfamiliar" ] = "payback_pri_lookfamiliar";  					
	
	// "You're insane!" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "kruger" ][ "payback_wrb_insane" ] = "payback_wrb_insane"; 

	// "Where's Makarov? Tell me and it's yours." - NOTETRACKED (keep for reference)
	//level.scr_sound[ "price" ][ "payback_pri_tellme2" ] = "payback_pri_tellme2";  					
	
	// "Our contact was a man named Volk! We never met Makarov!" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "kruger" ][ "payback_wrb_volk" ] = "payback_wrb_volk";  					
	
	// "Where's this Volk? Time's running out, mate." - NOTETRACKED (keep for reference)
	//level.scr_sound[ "soap" ][ "payback_mct_wheresvolk" ] = "payback_mct_wheresvolk";  			
	
	// "Paris! He oversaw the delivery in Paris!" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "kruger" ][ "payback_wrb_paris" ] = "payback_wrb_paris";  					
	
	// "Right, then. This for my mates at Hereford." - NOTETRACKED (keep for reference)
	//level.scr_sound[ "price" ][ "payback_pri_formymates" ] = "payback_pri_formymates";  			
	
	// "Wait!!!" - NOTETRACKED (keep for reference)
	//level.scr_sound[ "kruger" ][ "payback_wrb_wait" ] = "payback_wrb_wait";  					
	
			
	// -- POST INTERROGATION --
		
	// "Nikolai, Kruger broke! We have what we need. Ready for exfil."
	level.scr_sound[ "price" ][ "payback_pri_krugerbroke" ] = "payback_pri_krugerbroke";  			
	
	// "Almost there - the LZ looks clear but that sand storm is moving in fast."
	level.scr_radio[ "payback_nik_lzlooksclear" ] = "payback_nik_lzlooksclear";
	
	// "We see it. Meet you in 20 seconds."
	level.scr_sound[ "price" ][ "payback_pri_20seconds" ] = "payback_pri_20seconds";
	
	// "That storm is massive."
	level.scr_sound[ "soap" ][ "payback_mct_massive" ] = "payback_mct_massive";  		
	
	// "We do not want to get caught in that nightmare. Let’s move."
	level.scr_sound[ "price" ][ "payback_pri_nightmare" ] = "payback_pri_nightmare";  
	
	// "You think Warabe was telling the truth about Volk?"
	level.scr_sound[ "soap" ][ "payback_mct_tellingtruth" ] = "payback_mct_tellingtruth";  		
		
	// "Oh, yeah, he was telling the truth - I d bet Makarov s life on it."
	level.scr_sound[ "price" ][ "payback_pri_tellingtruth" ] = "payback_pri_tellingtruth";  

	// "We'll start making plans for Paris as soon as we get back, then we can talk to ..."
	level.scr_sound[ "price" ][ "payback_pri_makingplans" ] = "payback_pri_makingplans"; 
	
	
	
	// -- EXFIL ATTEMPT AMBUSH --
	
	// "Check left."
	level.scr_sound[ "price" ][ "payback_pri_checkleft" ] = "payback_pri_checkleft";  
	
	// "Clear."
	level.scr_sound[ "soap" ][ "payback_mct_clear2" ] = "payback_mct_clear2";  
	
	// "Watch those rooftops."
	level.scr_sound[ "price" ][ "payback_pri_watchrooftops" ] = "payback_pri_watchrooftops";  
	
	// "We gotta move."
	level.scr_sound[ "price" ][ "payback_pri_gottamove" ] = "payback_pri_gottamove";  	
	
	// "Sniper!"
	level.scr_sound[ "soap" ][ "payback_mct_sniper" ] = "payback_mct_sniper";  
	
	// "Take Cover!"
	level.scr_sound[ "price" ][ "payback_pri_takecover" ] = "payback_pri_takecover";  	
	
	// "Ambush!"
	level.scr_sound[ "soap" ][ "payback_mct_ambush" ] = "payback_mct_ambush";  
	
	// "Spread Out"
	level.scr_sound[ "soap" ][ "payback_mct_spreadout" ] = "payback_mct_spreadout";  
	
	// "Get outta the open!"
	level.scr_sound[ "price" ][ "payback_pri_outtatheopen" ] = "payback_pri_outtatheopen";  
	
	// "Move! Move!"
	level.scr_sound[ "soap" ][ "payback_mct_movemove" ] = "payback_mct_movemove";  			
	
	// "Nikolai, get out of here!"
	level.scr_sound[ "price" ][ "payback_pri_outofhere" ] = "payback_pri_outofhere";  
	
	// "Contact right! Contact right!"
	level.scr_sound[ "price" ][ "payback_pri_contactright" ] = "payback_pri_contactright";  
	
	// "On the rooftops!"
	level.scr_sound[ "soap" ][ "payback_mct_rooftops" ] = "payback_mct_rooftops";  		
	
	// "Nikolai, we’ve got to head to the secondary LZ!"
	level.scr_sound[ "price" ][ "payback_pri_nikolaisecondary" ] = "payback_pri_nikolaisecondary";
	
	// "That sand storm is coming in fast. I won t be able to touchdown once it hits."
	level.scr_radio[ "payback_nik_sandstormcoming" ] = "payback_nik_sandstormcoming";
	
	// "Just be there."
	level.scr_sound[ "price" ][ "payback_pri_justbethere" ] = "payback_pri_justbethere"; 
	
			
	// -- CITY / STREETS --
	
	// "We ve got to push through to the secondary LZ before the storm hits. Let s move!"
	level.scr_sound[ "price" ][ "payback_pri_beforethestorm" ] = "payback_pri_beforethestorm";  		

	// "Keep moving. And watch your flanks, we re entering the cross streets."
	level.scr_sound[ "price" ][ "payback_pri_crossstreets" ] = "payback_pri_crossstreets";  

	// "Multiple enemies are closing in."
	level.scr_radio[ "payback_nik_enemiesclosing" ] = "payback_nik_enemiesclosing";
	
	// "More of them on the roof!"
	level.scr_sound[ "price" ][ "payback_pri_moreonroof" ] = "payback_pri_moreonroof";  
	
	// "Keep pushing through!"
	level.scr_sound[ "price" ][ "payback_pri_keeppushing" ] = "payback_pri_keeppushing";  		
	
	// "The LZ is close. Keep moving!"
	level.scr_sound[ "price" ][ "payback_pri_lzisclose" ] = "payback_pri_lzisclose";  	

	// "They re all over us! Watch the alleys!"
	level.scr_sound[ "price" ][ "payback_pri_alloverus" ] = "payback_pri_alloverus";  
	
	// "Captain Price, the winds are getting stronger."
	level.scr_radio[ "payback_nik_winds" ] = "payback_nik_winds";
	
	// "Just hold on, Nikolai.  We're on the way."
	level.scr_sound[ "price" ][ "payback_pri_ontheway" ] = "payback_pri_ontheway";  
	
	
	// -- BURNING CAR -- 
	// "Contact front! Look out!"
	level.scr_sound[ "soap" ][ "payback_mct_contactfront" ] = "payback_mct_contactfront";  
	
	
	// -- CONSTRUCTION --
	// "Nikolai, the LZ is in sight."
	level.scr_sound[ "price" ][ "payback_pri_lzinsight" ] = "payback_pri_lzinsight";
	
	// "Move fast. I don t know how much longer I can fly in this storm."
	level.scr_radio[ "payback_nik_movefast" ] = "payback_nik_movefast";
	
	// "The wall!!  Watch out!!"
	level.scr_sound[ "price" ][ "payback_pri_thewall" ]	= "payback_pri_thewall";
	
	// "We need to push to the top floor.  Let's move."
	level.scr_sound[ "price" ][ "payback_pri_topfloor" ] = "payback_pri_topfloor";
	
	// "First floor clear! Move!"
	level.scr_sound[ "price" ][ "payback_pri_1stfloorclear2" ] = "payback_pri_1stfloorclear2";
	
	// "Watch it!"
	level.scr_sound[ "price" ][ "payback_pri_watchit" ] = "payback_pri_watchit";
		
	// "Starting my approach to the LZ."
	level.scr_radio[ "payback_nik_startingmyapproach" ] = "payback_nik_startingmyapproach";
	
	// "We’ll meet you at the top, Nikolai."
	level.scr_sound[ "price" ][ "payback_pri_meetyouattop" ] = "payback_pri_meetyouattop";
	
	// "Second floor clear! Keep moving!"
	level.scr_sound[ "price" ][ "payback_pri_2ndfloorclear" ] = "payback_pri_2ndfloorclear";
	
	// "Nikolai, we're at the LZ.  Where are you?"
	level.scr_sound[ "price" ][ "payback_pri_whereareyou" ]	= "payback_pri_whereareyou";
	
	// "Almost there." 
	level.scr_radio[ "payback_nik_almostthere" ] = "payback_nik_almostthere";
	
	// "The site is too hot!  I can't land!"
	level.scr_radio[ "payback_nik_sitetoohot" ] = "payback_nik_sitetoohot";
	
	// "Yuri, get on the remote turret and thin 'em out."
	level.scr_sound[ "price" ][ "payback_pri_turret" ] = "payback_pri_turret";
	
	// "I'm hit!! I'm hit!!!"
	level.scr_radio[ "payback_nik_imhit" ] = "payback_nik_imhit";
	
	
	// -- NEW CHOPPER CRASH / RAPPEL --
	
	// "He's out of control!"
	level.scr_sound[ "price" ][ "payback_pri_outofcontrol" ] = "payback_pri_outofcontrol";
	
	// "We've gotta get off this roof!"
	level.scr_sound[ "price" ][ "payback_pri_getoffroof" ] = "payback_pri_getoffroof";
	
	// "Go! Use the ropes!"
	level.scr_sound[ "price" ][ "payback_pri_useropes" ] = "payback_pri_useropes";
	
	// "Jump for it!"
	level.scr_sound[ "soap" ][ "payback_mct_jumpforit" ] = "payback_mct_jumpforit";
		
	// "Juuuuump!"
	level.scr_sound[ "soap" ][ "payback_mct_jump" ] = "payback_mct_jump";
	
	// "I'm going down!!  I'm going  *static*"
	level.scr_radio[ "payback_nik_goingdown" ] = "payback_nik_goingdown";
	
		
	// -- RAPPEL ENDING / SANDSTORM START --
	
	// "The controls have gone out!" This is supposed to be super garbled so you can't understand them at all
	//level.scr_radio[ "payback_nik_controlshavegone" ] = "payback_nik_controlshavegone";
	
	// "Nikolai?" - NOTETRACKED (keep for reference)
	// level.scr_sound[ "price" ][ "payback_pri_nikolai" ] = "payback_pri_nikolai";
	
	// "I’m going down. I repeat I’m going down!" This is supposed to be super garbled so you can't understand them at all
	// level.scr_radio[ "payback_nik_repeatgoingdown" ] = "payback_nik_repeatgoingdown";	
	
	// "Nikolai, do you copy?" - NOTETRACKED (keep for reference)
	// level.scr_sound[ "price" ][ "payback_pri_doyoucopy" ] = "payback_pri_doyoucopy";
	
	// "What the hell are we going to do now!?" - NOTETRACKED (keep for reference)
	// level.scr_sound[ "soap" ][ "payback_mct_goingtodonow" ] = "payback_mct_goingtodonow";
	
	// "Echo Team, Nikolai’s bird is down in the city and the bloody Sand Storm is on top of us! We’re going to need emergency exfil!" - NOTETRACKED (keep for reference)
	// level.scr_sound[ "price" ][ "payback_pri_bloodysand" ] = "payback_pri_bloodysand";
	
	// "Roger. Keep moving south and we’ll contact you when we get a fix on Nikolai." - NOTETRACKED (keep for reference)
	// level.scr_radio[ "payback_eol_movingsouth" ] = "payback_eol_movingsouth";
	
	// "C'mon, lads. We've got to reach Nikolai before Waraabe's men do." - (NOTETRACKED & used at start point)
	level.scr_sound[ "price" ][ "payback_pri_cmonlads" ] = "payback_pri_cmonlads";
	
	// "Vehicle coming through. Stay low and keep moving."
	level.scr_radio[ "payback_pri_vehiclecoming_r" ] = "payback_pri_vehiclecoming";
		
	// "Ah, I can t see two feet in front of me."
	level.scr_radio[ "payback_mct_cantsee_r" ] = "payback_mct_cantsee";  			    
	
	// "Hold up."
	level.scr_sound[ "price" ][ "payback_pri_holdup" ] = "payback_pri_holdup";
	
	// "Take 'em out!"
	level.scr_sound[ "price" ][ "payback_pri_takeemout" ] = "payback_pri_takeemout";
	
	// -- SANDSTORM - CONTACTING ECHO --
	
	// "Echo Team, what's your status?"
	level.scr_sound[ "price" ][ "payback_pri_echoteam2" ] = "payback_pri_echoteam2";
	
	// "We've located Nikolai's chopper. It's half a klick south of your position."
	level.scr_radio[ "payback_eol_locatedchopper" ] = "payback_eol_locatedchopper";  			    
	
	// "We'll meet you at the crash site."
	level.scr_sound[ "price" ][ "payback_pri_meetatcrash" ] = "payback_pri_meetatcrash";
	
	// "Roger that."
	level.scr_radio[ "payback_eol_rogerthat2" ] = "payback_eol_rogerthat2";  			    
	
	// -- SANDSTORM - ENEMY RUNNERS --
	// "This way! This way! They've found the chopper!"
	level.scr_radio[ "payback_afr_thisway" ] = "payback_mrc1_foundchopper";
		
	// "Get down!"
	level.scr_radio[ "payback_pri_getdown_r" ] = "payback_pri_getdown";
	
	// "Keep searching for the others! They will be coming for their friend!"
	level.scr_radio[ "payback_afm_keepsearching" ] = "payback_afm_keepsearching";
	
	// "They must have found Nikolai."
	level.scr_radio[ "payback_pri_foundnikolai_r" ] = "payback_pri_foundnikolai";
	
	// -- SANDSTORM - ECHO TEAM REPORT IN --
	// "Captain Price, we’ve reached Nikolai, but we’re under heavy fire."
	level.scr_radio[ "payback_tm2_reachednikolai" ] = "payback_tm2_reachednikolai";
		
	// "Hang on, we're almost there."
	level.scr_sound[ "price" ][ "payback_pri_hangon" ] = "payback_pri_hangon";
	
	// -- SANDSTORM - SHADOW MOMENT --
	// "Hurry, we've got the Americans pinned down! They killed Warabee, they must not be allowed to escape!"
	level.scr_radio[ "payback_afm_hurry" ] = "payback_afm_hurry";
			
	// "Looks like they're heading for Nikolai."
	level.scr_sound[ "price" ][ "payback_mct_headingfornik" ] = "payback_mct_headingfornik";
		
	// "Drop 'em!"
	level.scr_sound[ "price" ][ "payback_pri_dropem" ] = "payback_pri_dropem";
			
	
	// -- RESCUE NIKOLAI INTRO --
	// "There's Nikolai's Chopper!"
	level.scr_sound[ "soap" ][ "payback_mct_theresnikschopper" ] = "payback_mct_theresnikschopper";
		
	// "Echo Team's pinned down! Let's move!"
	level.scr_sound[ "price" ][ "payback_pri_echoteampinned" ] = "payback_pri_echoteampinned";
	
	// "Echo Team, we're approaching your position from the North West!"
	level.scr_sound[ "price" ][ "payback_pri_fromnorthwest" ] = "payback_pri_fromnorthwest";
	
	// "Copy that!"
	level.scr_radio[ "payback_eol_copythat" ] = "payback_eol_copythat";
	
	// "Good to see you, mates! Where's the convoy?"
	level.scr_sound[ "price" ][ "payback_pri_goodtoseeyou" ] = "payback_pri_goodtoseeyou";
	
	// "We've got two vehicles 50 meters to the northwest!"
	level.scr_sound[ "rescue_echo_1" ][ "payback_eol_twovehicles" ] = "payback_eol_twovehicles";
	
	// "All right. Yuri, grab Nikolai! Everyone else, get ready to suppress and fall back!"
	level.scr_sound[ "price" ][ "payback_pri_suppress" ] = "payback_pri_suppress";
	
	// -- PICKUP NIKOLAI --
	
	// "Yuri, get Nikolai. They re closing in."
	level.scr_sound[ "price" ][ "payback_pri_getnikolai" ] = "payback_pri_getnikolai";
	
	// "Grab Nikolai. We re running out of time."
	level.scr_sound[ "price" ][ "payback_pri_grabnikolai" ] = "payback_pri_grabnikolai";
	
	// "Yuri, what are you waiting for? Get Nikolai."
	level.scr_sound[ "price" ][ "payback_pri_waitingfor" ] = "payback_pri_waitingfor";
	
	// "Yuri, where are you going?"
	level.scr_radio[ "payback_pri_wheregoing" ] = "payback_pri_wheregoing";
	
	// "Get back here, Yuri!"
	level.scr_radio[ "payback_pri_getbackhere2" ] = "payback_pri_getbackhere2";
	
	// -- ESCAPE -- 
	
	// "Move out!"
	level.scr_sound[ "price" ][ "payback_pri_moveout4" ] = "payback_pri_moveout4";
		
	// "Echo-2 we've got Nikolai and are heading to the exfil point."
	level.scr_sound["price"][ "payback_pri_headingtoexfil" ] = "payback_pri_headingtoexfil";
	
	// "Let's get to the exfil point."
	level.scr_sound[ "price" ][ "payback_pri_gettoexfil" ] = "payback_pri_gettoexfil";
	
	// "Follow me." 
	level.scr_sound[ "soap" ][ "payback_mct_followme" ] = "payback_mct_followme";
	
	// "Come on, Yuri."
	level.scr_sound[ "price" ][ "payback_pri_comeonyuri" ] = "payback_pri_comeonyuri";
	
	// "There's Echo Team!"
	level.scr_sound[ "soap" ][ "payback_mct_iseethem" ] = "payback_mct_iseethem";
	
	// "Yuri, this way."
	level.scr_sound[ "price" ][ "payback_pri_yurithisway" ] = "payback_pri_yurithisway";
	
	// "We have to keep moving." 
	level.scr_sound[ "soap" ][ "payback_mct_keepmoving2" ] = "payback_mct_keepmoving2";
	
	// "Echo-2, we're approaching the exfil point!"
	level.scr_sound[ "rescue_echo_1" ][ "payback_eol_approachingexfil" ] = "payback_eol_approachingexfil";
		
	// "Let's go. They're just past the ridge."
	level.scr_sound[ "rescue_echo_1" ][ "payback_eol_letsgo" ] = "payback_eol_letsgo";
		
	// ALT - "There's our marker. They're just past the ridge!"
	level.scr_scr_sound[ "rescue_echo_1" ][ "payback_eol_marker" ] = "payback_eol_marker";
		
	// "Let's go, Yuri! Move it!"
	level.scr_sound[ "price" ][ "payback_pri_letsgoyuri" ] = "payback_pri_letsgoyuri";	
			
	// -- IN THE JEEPS --
	// "Glad you made it!"
	level.scr_sound[ "escape_jeep_1_driver" ][ "payback_eol_glad" ] = "payback_eol_glad"; 	
	
	// "So if Volk’s in Paris, how are we getting there in the middle of a bloody war?"
	level.scr_radio[ "payback_mct_inparis" ] = "payback_mct_inparis";
	
	// "We can't. But I know who can"
	level.scr_sound[ "price" ][ "payback_pri_iknowwho" ] = "payback_pri_iknowwho";
	
	
	// -- GENERIC SANDSTORM ENCOUNTERS -- 
	
	// "Move out."
	level.scr_radio[ "payback_pri_moveout_r" ] = "payback_pri_moveout3";
	
	// "Hostile dead ahead."
	level.scr_radio[ "payback_mct_deadahead_r" ] = "payback_mct_hostiledeadahead"; 		
	
	// "That was easy."
	level.scr_radio[ "payback_mct_thatwaseasy_r" ] = "payback_mct_thatwaseasy2";		
	
	// "We're clear."
	level.scr_radio[ "payback_mct_wereclear_r" ] = "payback_mct_wereclear2";		
	
	// "They know we re here!"
	level.scr_radio[ "payback_mct_theyknow_r" ] = "payback_mct_theyknow";			
	
	// "Hostiles dead ahead."
	level.scr_radio[ "payback_pri_deadahead_r" ] = "payback_pri_deadahead";
	
		

	/////////////////////////////
	////	Animation		/////
	/////////////////////////////
	
	//Intro
	level.scr_anim[ "soap" ][ "soap_shoots_from_hummer" ] = %payback_gatecrasher_intro_soap;
	addNotetrack_customFunction( "soap", "gun_2_right", maps\payback_1_script_a::soap_gun_right );
	addNotetrack_customFunction( "soap", "gun_2_left", maps\payback_1_script_a::soap_gun_left );
	
	level.scr_anim[ "soap" ][ "intro_soap" ] 			= %payback_intro_soap;
	level.scr_anim[ "soap" ][ "intro_soap_stand" ] 		= %payback_gatecrasher_intro_soap;
	level.scr_anim[ "soap" ][ "intro_soap_stand_idle" ] = %payback_gatecrasher_intro_soap_idle;
	level.scr_anim[ "soap" ][ "intro_soap_stand_end" ] 	= %payback_gatecrasher_intro_soap_exit;
	
	level.scr_anim[ "price" ][ "intro_price" ] 			= %payback_intro_price;
	level.scr_anim[ "price" ][ "intro_price_shift_up" ] 	= %payback_intro_shift_up;
	level.scr_anim[ "price" ][ "intro_price_shift_down" ] = %payback_intro_shift_down;
	level.scr_anim[ "price" ][ "intro_price_getout" ] = %payback_intro_dismount_price;
	
	
	level.scr_anim[ "generic" ][ "intro_civilian_A_run" ] = %freerunnerA_loop;
	level.scr_anim[ "generic" ][ "intro_civilian_B_run" ] = %freerunnerA_loop;
	
	
	level.scr_anim[ "price" ][ "intro_jump_react" ] 	= %payback_intro_turn_driver;	
	level.scr_anim[ "soap" ][ "intro_jump_react" ] 	= %payback_intro_turn_passenger;
	
	level.scr_anim[ "Hannibal" ][ "intro_jump_react" ] 	= %payback_intro_turn_driver;
	level.scr_anim[ "Murdock" ][ "intro_jump_react" ] 	= %payback_intro_turn_passenger;
	
		
	level.scr_anim[ "price_killguy_1" ][ "intro_price_shoots_guys" ] 	= %Payback_gatecrash_enemy_death_1;
	level.scr_anim[ "price_killguy_2" ][ "intro_price_shoots_guys" ] 	= %Payback_gatecrash_enemy_death_2;
	
	
	//bravo guy in back of front jeep signals to player's jeep
	level.scr_anim[ "Murdock" ][ "bravo_intro_signal" ] = %Payback_intro_bravo_thumbs_up;
	
	//bravo dude stands up to shoot during intro
	level.scr_anim[ "Barracus" ][ "bravo_intro_stand" ] = %Payback_intro_bravo_standup;
	level.scr_anim[ "Barracus" ][ "bravo_intro_stand_idle" ] = %Payback_intro_bravo_standup_idle;
	level.scr_anim[ "Barracus" ][ "bravo_intro_stand_turn" ] = %payback_intro_bravo_turn_back;
	level.scr_anim[ "Barracus" ][ "bravo_intro_stand_idle_2" ] = %payback_intro_bravo_standup_idle_2;
	level.scr_anim[ "Barracus" ][ "bravo_intro_stand_gatecrash" ] = %payback_intro_bravo_gatecrash_back;
	
	//guys closing the gate
	level.scr_anim[ "gate_guy_left" ][ "gate_close" ] = %Payback_gatecrash_closegate_l;
	level.scr_anim[ "gate_guy_right" ][ "gate_close" ] = %Payback_gatecrash_closegate_r;
	level.scr_anim[ "gate_guy_left" ][ "gate_close_dive" ] = %Payback_gatecrash_dive_l;
	level.scr_anim[ "gate_guy_right" ][ "gate_close_dive" ] = %Payback_gatecrash_dive_r;
	
	level.scr_anim[ "generic" ][ "gate_guy_anim" ][0] = %exposed_idle_twitch_v2;

	// soap dives down
	level.scr_anim["generic"]["london_kickout_window_kick_reaction"] = %london_kickout_window_kick_reaction;

	// enemy vignettes
	level.scr_anim["generic"]["payback_docks_table_enemy1"] = %payback_docks_table_enemy1;
	level.scr_anim["generic"]["payback_docks_table_enemy2"] = %payback_docks_table_enemy2;
	level.scr_anim["generic"]["payback_docks_get_rpg_enemy"] = %payback_docks_get_rpg_enemy;
	level.scr_anim["generic"]["payback_docks_drag_body1"] = %payback_docks_drag_body1;
	level.scr_anim["generic"]["payback_docks_drag_body2"] = %payback_docks_drag_body2;
	// add notetrack for drag_body2
	level.scr_anim["generic"]["payback_comp_balcony_kick_enemy"] = %payback_comp_balcony_kick_enemy;
	level.scr_anim["soap"]["payback_comp_balcony_kick_soap"] = %payback_comp_balcony_kick_soap;
	
	// kicking in doors in compound
	level.scr_anim["generic"]["doorkick_2_stand"] = %doorkick_2_stand;
	
	//price stack up near breach door
	level.scr_anim[ "price" ][ "payback_coverstand_trans_IN_R" ] = %coverstand_trans_IN_R;
	level.scr_anim[ "price" ][ "payback_coverstand_look_moveup" ] = %coverstand_look_moveup;
	level.scr_anim[ "price" ][ "payback_coverstand_look_idle" ][0] = %coverstand_look_idle;
	
	//soap stack up near breach door
	level.scr_anim[ "soap" ][ "payback_corner_standL_trans_IN_2" ] = %corner_standL_trans_IN_2;
	level.scr_anim[ "soap" ][ "payback_corner_standl_alert_idle" ][0] = %corner_standl_alert_idle;
	
	//Waraabe Interrogation
	level.scr_anim[ "price" ][ "waraabe_interrogation" ] = %payback_interrogation_price_new;
	addNotetrack_customFunction( "price", "unhide_mask_1", maps\payback_1_script_e::unhide_mask_1 , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "unhide_mask_3", maps\payback_1_script_e::unhide_mask_3 , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "activate_gas_can", maps\payback_1_script_e::activate_gas_can , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "hide_mask_1", maps\payback_1_script_e::hide_mask_1 , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "price_holster_mg", maps\payback_1_script_e::price_holster_mg , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "price_unholster_pistol", maps\payback_1_script_e::price_unholster_pistol , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "price_shoot_pistol", maps\payback_1_script_e::price_shoot_pistol , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "price_holster_pistol", maps\payback_1_script_e::price_holster_pistol , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "price_unholster_mg", maps\payback_1_script_e::price_unholster_mg , "waraabe_interrogation" );
	addNotetrack_customFunction( "price", "swap_model", maps\payback_1_script_e::swap_model, "waraabe_interrogation"  );
	
	level.scr_anim[ "kruger" ][ "waraabe_breach" ] = %payback_breach_warrabe;
	addNotetrack_customFunction( "kruger", "shot_in_leg", maps\payback_1_script_e::waraabe_shot_in_leg , "waraabe_breach" );
	level.scr_anim[ "kruger" ][ "waraabe_breach_injured_loop" ][0] = %payback_breach_warrabe_loop;
	level.scr_anim[ "kruger" ][ "payback_interrogation_warrabe" ] = %payback_interrogation_warrabe;
	addNotetrack_customFunction( "kruger", "wound_stomp", maps\payback_1_script_e::waraabe_leg_stomp , "payback_interrogation_warrabe" );
	level.scr_anim[ "kruger" ][ "payback_interrogation_warrabe_death_loop" ][0] = %payback_interrogation_warrabe_death_loop;
	level.scr_anim[ "kruger" ][ "waraabe_death_ground" ] = %payback_interrogation_death_on_ground_warrabe;
	level.scr_anim[ "kruger" ][ "waraabe_death_crate" ] = %payback_interrogation_death_on_crates_warrabe;
		
	level.scr_anim[ "generic" ][ "payback_breach_gunrack_guy" ] = %payback_breach_gunrack_guy;
	level.scr_anim[ "generic" ][ "payback_breach_crateguy" ] = %payback_breach_crateguy;
	level.scr_anim[ "generic" ][ "payback_breach_doorguy" ] = %payback_breach_doorguy;
	level.scr_anim[ "generic" ][ "payback_breach_react_soldier_4" ] = %payback_breach_react_soldier_4;
	level.scr_anim[ "generic" ][ "payback_breach_pushedguy" ] = %payback_breach_pushedguy;
	
	level.scr_anim[ "generic" ][ "generic_death" ] = %exposed_death_falltoknees_02;
	level.scr_anim[ "generic" ][ "generic_death_2" ] = %exposed_death_blowback;

	level.scr_anim[ "soap" ][ "waraabe_interrogation" ] = %payback_interrogation_soap_new;
	addNotetrack_customFunction( "soap", "unhide_mask_2", maps\payback_1_script_e::unhide_mask_2 , "waraabe_interrogation" );
	addNotetrack_customFunction( "soap", "unhide_gas_can", maps\payback_1_script_e::unhide_gas_can , "waraabe_interrogation" );
	addNotetrack_customFunction( "soap", "hide_mask_2", maps\payback_1_script_e::hide_mask_2 , "waraabe_interrogation"  );
	addNotetrack_customFunction( "soap", "open_door_2", maps\payback_1_script_e::open_exit_door , "waraabe_interrogation"  );
	
	//post interrogation dead drones
	level.scr_anim["generic"]["arcadia_ending_sceneA_enemy2_death_pose"] = %arcadia_ending_sceneA_enemy2_death_pose;
	level.scr_anim["generic"]["ch_pragueb_civ_escalator_12_a_death_pose"] = %ch_pragueb_civ_escalator_12_a_death_pose;
	level.scr_anim["generic"]["ch_pragueb_civ_escalator_12_b_death_pose"] = %ch_pragueb_civ_escalator_12_b_death_pose;
	level.scr_anim["generic"]["ch_pragueb_civ_escalator_12_c_death_pose"] = %ch_pragueb_civ_escalator_12_c_death_pose;
	
	//Streets
	//level.scr_anim[ "hannibal" ][ "payback_streets_snipe" ] = %death_stand_sniper_spin2;
	//level.scr_anim[ "hannibal" ][ "payback_bravo_chopper_wave" ][0] = %payback_bravo_chopper_wave;
	
	// guys dying from construction wall collapse
	level.scr_anim["generic"]["wall_fall_a"] = %payback_const_wall_fall_reaction_a;
	level.scr_anim["generic"]["wall_fall_b"] = %payback_const_wall_fall_reaction_b;
	
	//Chopper
	level.scr_anim[ "generic" ][ "stand_exposed_extendedpain_hip_2_crouch" ] = %stand_exposed_extendedpain_hip_2_crouch;
	
	//Construction Site Chopper Crash Dive
	level.scr_anim[ "generic" ][ "chopper_dive" ] = %exposed_dive_grenade_B;
	
	//price and soap chopper crash crouch movements
	level.scr_anim[ "price" ][ "exposed_crouch_turn_90_right" ] = %exposed_crouch_turn_90_right;
	level.scr_anim[ "price" ][ "exposed_crouch_turn_180_right" ] = %exposed_crouch_turn_180_right;
	level.scr_anim[ "soap" ][ "exposed_crouch_turn_90_left" ] = %exposed_crouch_turn_90_left;
	level.scr_anim[ "soap" ][ "exposed_crouch_turn_180_left" ] = %exposed_crouch_turn_180_left;
	
	// Price top of construction site
	level.scr_anim[ "price" ][ "const_top" ] = %payback_const_top_price;
	
	level.scr_anim[ "generic" ][ "death_run_forward_crumple" ]	=%death_run_forward_crumple;
	level.scr_anim[ "generic" ][ "death_stand_dropinplace" ]        = %death_stand_dropinplace;
	level.scr_anim[ "generic" ][ "death_explosion_stand_R_v1" ] 	= %death_explosion_stand_R_v1;	
	level.scr_anim[ "generic" ][ "death_explosion_right13" ] 	= %death_explosion_right13;	
	
	//Nikolai in heli
	level.scr_anim[ "generic" ][ "nikolai_in_heli_loop" ][0] = %helicopter_pilot1_idle;
	
	// rolling car in city
	level.scr_anim[ "generic" ][ "payback_city_pushcar_left" ]	 = %payback_city_truck_push_a;
	level.scr_anim[ "generic" ][ "payback_city_pushcar_right" ]	 = %payback_city_truck_push_b;

	//Construction Site Rappel
	level.scr_anim[ "soap" ][ "payback_const_rappel_soap_wave" ] = %payback_escape_forward_wave_right_price;
	
	level.scr_anim[ "soap" ][ "const_rappel_soap" ] = %payback_const_rappel_soap;
	//Caleb says he does not need this anymore as he can put Soap's gun back in his hand in the animation
	//addNotetrack_customFunction( "soap", "gun_2_hand", maps\payback_streets_const::soap_put_guns_back_in_hands , "const_rappel_soap" );
	addNotetrack_customFunction( "soap", "fire", maps\payback_streets_const::post_rappel_gate_open , "const_rappel_soap" );
	
	level.scr_anim[ "price" ][ "const_rappel_price" ] = %payback_const_rappel_price;
	addNotetrack_customFunction( "price", "gun_2_hand", maps\payback_streets_const::price_put_guns_back_in_hands , "const_rappel_price" );
	
	level.scr_anim[ "price" ][ "const_rappel_end_price" ] = %payback_const_rappel_end_price;
	
	// section 2 Sandstorm
	level.scr_anim[ "generic" ][ "corner_standR_trans_A_2_B" ]	= %corner_standR_trans_A_2_B;
	level.scr_anim[ "generic" ][ "deploy_flare" ] = %Payback_sstorm_flare;
	level.scr_anim[ "generic" ][ "payback_sstorm_reaction_guard1" ] = %payback_sstorm_reaction_guard1;
		
	// flashlight alley guys	
	level.scr_anim[ "generic" ][ "active_patrolwalk_v5" ] = %active_patrolwalk_v5;
	level.scr_anim[ "generic" ][ "active_patrolwalk_pause" ] = %active_patrolwalk_pause;
	level.scr_anim[ "generic" ][ "active_patrolwalk_turn_180" ] = %active_patrolwalk_turn_180;
		
	level.scr_anim[ "generic" ][ "payback_pmc_sandstorm_stumble_1" ] = %payback_pmc_sandstorm_stumble_1;
	level.scr_anim[ "generic" ][ "payback_pmc_sandstorm_stumble_2" ] = %payback_pmc_sandstorm_stumble_2;
	level.scr_anim[ "generic" ][ "payback_pmc_sandstorm_stumble_3" ] = %payback_pmc_sandstorm_stumble_3;
/*
	level.scr_anim[ "generic" ][ "payback_sstorm_shelter_guard1_enter"] = %payback_sstorm_shelter_guard1_enter;
	level.scr_anim[ "generic" ][ "payback_sstorm_shelter_guard1_loop"][0] = %payback_sstorm_shelter_guard1_loop;
	level.scr_anim[ "generic" ][ "payback_sstorm_shelter_guard2_enter"] = %payback_sstorm_shelter_guard2_enter;
	level.scr_anim[ "generic" ][ "payback_sstorm_shelter_guard2_loop"][0] = %payback_sstorm_shelter_guard2_loop;
	level.scr_anim[ "generic" ][ "payback_sstorm_shelter_guard3_enter"] = %payback_sstorm_shelter_guard3_enter;
	level.scr_anim[ "generic" ][ "payback_sstorm_shelter_guard3_loop"][0] = %payback_sstorm_shelter_guard3_loop;
*/
	//level.scr_anim[ "generic" ][ "payback_sstorm_run_and_wave" ] = %favela_run_and_wave;
	level.scr_anim[ "generic" ][ "payback_sstorm_guard_wave_1" ] = %payback_sstorm_guard_wave_1;
	level.scr_anim[ "generic" ][ "payback_sstorm_guard_wave_2" ] = %payback_sstorm_guard_wave_2;
	level.scr_anim[ "generic" ][ "signal_enemy_coverR" ]	= %CornerStndR_alert_signal_enemy_spotted;
	
	// balcony deaths
	level.scr_anim[ "generic" ][ "balcony_death" ] = [];
	level.scr_anim[ "generic" ][ "balcony_death" ][ 0 ] = %death_rooftop_A;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 1 ] = %death_rooftop_B;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 2 ] = %death_rooftop_C;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 3 ] = %death_rooftop_D;
	
	//Echo Pullout Nikolai
	level.scr_anim[ "rescue_echo_3" ][ "payback_sstorm_chopper_rescue_echo_pullout" ] = %payback_sstorm_chopper_rescue_echo_pullout;
	level.scr_anim[ "nikolai" ][ "payback_sstorm_chopper_rescue_nikolai_pullout" ]	= %payback_sstorm_chopper_rescue_nikolai_pullout;
	

	//echo running death
	level.scr_anim["generic"]["echo_stumble_forward_death"] = %stand_death_stumbleforward;
	
	//Price Street Run Anims
	level.scr_anim[ "price" ][ "payback_escape_start_backpedal_price" ] = %payback_escape_start_backpedal_price;
	level.scr_anim[ "price" ][ "escape_debris_dodge" ] = %payback_escape_dodge_debris_price;
	level.scr_anim[ "price" ][ "payback_escape_rpg_react_price" ] = %payback_escape_rpg_react_price;
	level.scr_anim[ "price" ][ "payback_escape_forward_wave_right_price" ] = %payback_escape_forward_wave_right_price;
	
	//soap Street Run Anims
	level.scr_anim[ "soap" ][ "payback_escape_start_wave_soap" ] = %payback_escape_start_wave_soap;
	level.scr_anim[ "soap" ][ "payback_escape_turn_shoot_wave_soap" ] = %payback_escape_turn_shoot_wave_soap;
	level.scr_anim[ "soap" ][ "payback_escape_hood_slide_soap" ] = %payback_escape_hood_slide_soap;
	level.scr_anim[ "soap" ][ "payback_escape_forward_wave_left_soap" ] = %payback_escape_forward_wave_left_soap;
	
	// Rescue Nikolai
	level.scr_anim[ "nikolai" ][ "rescue_nikolai_idle" ][0] = %payback_sstorm_chopper_rescue_nikolai_hit_idle;
	level.scr_anim[ "nikolai" ][ "rescue_nikolai" ]	= %payback_sstorm_chopper_rescue_nikolai_getup;
	level.scr_anim[ "nikolai" ][ "rescue_nikolai_death" ]	= %payback_sstorm_chopper_rescue_nikolai_killed;
	
	//price slide
	level.scr_anim[ "price" ][ "exfil_slide_price" ] = %payback_exfil_slide_price;
	level.scr_anim[ "price" ][ "payback_exfil_slide_loop_price" ][0] = %payback_exfil_slide_loop_price;
	level.scr_anim[ "price" ][ "payback_exfil_slide_end_price" ] = %payback_exfil_slide_end_price;
	addNotetrack_customFunction( "price", "slide_fx_on", maps\payback_rescue::slide_fx_on , "exfil_slide_price" );
	addNotetrack_customFunction( "price", "slide_fx_off", maps\payback_rescue::slide_fx_off , "exfil_slide_price" );
	
	//price enter jeep
	level.scr_anim[ "price" ][ "price_enter_jeep" ] = %rubicon_mount_backR;
	
	//soap slide
	level.scr_anim[ "soap" ][ "exfil_slide_soap" ] = %payback_exfil_slide_soap;
	addNotetrack_customFunction( "soap", "slide_fx_on", maps\payback_rescue::slide_fx_on , "exfil_slide_soap" );
	addNotetrack_customFunction( "soap", "slide_fx_off", maps\payback_rescue::slide_fx_off , "exfil_slide_soap" );
	
	//soap enter jeep
	level.scr_anim[ "soap" ][ "soap_enter_jeep" ] = %payback_exfil_enter_jeep_soap;
	
	//echo 2 slide
	level.scr_anim[ "rescue_echo_2" ][ "exfil_slide_echo_2" ] = %payback_exfil_slide_soap;
	addNotetrack_customFunction( "rescue_echo_2", "slide_fx_on", maps\payback_rescue::slide_fx_on , "exfil_slide_echo_2" );
	addNotetrack_customFunction( "rescue_echo_2", "slide_fx_off", maps\payback_rescue::slide_fx_off , "exfil_slide_echo_2" );
	
	//Nikolai Slide
	level.scr_anim[ "nikolai_jeep_escape" ][ "exfil_slide_nikolai" ] = %payback_exfil_slide_nikolai;
	addNotetrack_customFunction( "nikolai_jeep_escape", "slide_fx_on", maps\payback_rescue::slide_fx_on , "exfil_slide_nikolai" );
	addNotetrack_customFunction( "nikolai_jeep_escape", "slide_fx_off", maps\payback_rescue::slide_fx_off , "exfil_slide_nikolai" );
	          	
	//echo 1 enter jeep b
	level.scr_anim[ "rescue_echo_1" ][ "enter_jeep_rescue_echo_1" ] = %payback_exfil_slide_echo_a;
	//addNotetrack_customFunction( "rescue_echo_1", "move_front_jeep", maps\payback_rescue::jeep_b_move , "enter_jeep_rescue_echo_1" );
	
	
	///////////NEW JEEP ESCAPE/////////////////// 
	//price slide
	level.scr_anim[ "price" ][ "jeep_slide_escape" ] = %payback_end_slide_price;
	addNotetrack_customFunction( "price", "slide_fx_on", maps\payback_rescue::slide_fx_on , "jeep_slide_escape" );
	addNotetrack_customFunction( "price", "slide_fx_off", maps\payback_rescue::slide_fx_off , "jeep_slide_escape" );
	
	//price shoot loop
	level.scr_anim[ "price" ][ "price_jeep_shoot_loop" ][0] = %payback_end_fire_price;
	
	//price sit down
	level.scr_anim[ "price" ][ "price_jeep_sit_down" ] = %payback_end_to_idle_price;
	
	//price idle after he gets in the jeep
	level.scr_anim[ "price" ][ "price_back_jeep_loop" ][0] = %rubicon_idle_backL;
	
	//nikolai slide
	level.scr_anim[ "nikolai_jeep_escape" ][ "jeep_slide_escape" ] = %payback_end_slide_nikolai;
	addNotetrack_customFunction( "nikolai_jeep_escape", "slide_fx_on", maps\payback_rescue::slide_fx_on , "jeep_slide_escape" );
	addNotetrack_customFunction( "nikolai_jeep_escape", "slide_fx_off", maps\payback_rescue::slide_fx_off , "jeep_slide_escape" );
	
	//nikolai idle after he gets in the jeep
	level.scr_anim[ "nikolai_jeep_escape" ][ "nikolai_passenger_loop" ][0] = %payback_end_idle_nikolai;
	
	//escape jeep 1 gunner in passenger seat
	level.scr_anim[ "escape_jeep_1_gunner" ][ "escape_jeep_1_gunner_shoot_loop" ][0] = %payback_end_fire_passenger;
	level.scr_anim[ "escape_jeep_1_gunner" ][ "escape_jeep_1_gunner_sit_down" ] = %payback_end_to_idle_passenger;
	level.scr_anim[ "escape_jeep_1_gunner" ][ "escape_jeep_1_gunner_passenger_loop" ][0] = %rubicon_idle_passenger;
	
	//escape jeep 2 gunner in back left
	level.scr_anim[ "escape_jeep_2_gunner" ][ "escape_jeep_2_gunner_shoot_loop" ][0] = %payback_end_fire_back_l;
	level.scr_anim[ "escape_jeep_2_gunner" ][ "escape_jeep_2_gunner_sit_down" ] = %payback_end_to_idle_back_l;
	level.scr_anim[ "escape_jeep_2_gunner" ][ "escape_jeep_2_gunner_rear_loop" ][0] = %rubicon_idle_backL;
	
	//soap slide
	level.scr_anim[ "soap" ][ "jeep_slide_escape" ] = %payback_end_slide_soap;
	addNotetrack_customFunction( "soap", "slide_fx_on", maps\payback_rescue::slide_fx_on , "jeep_slide_escape" );
	addNotetrack_customFunction( "soap", "slide_fx_off", maps\payback_rescue::slide_fx_off , "jeep_slide_escape" );
	
	//soap shoot loop
	level.scr_anim[ "soap" ][ "soap_jeep_shoot_loop" ][0] = %payback_end_fire_soap;
	
	//soap shoot loop 2
	level.scr_anim[ "soap" ][ "soap_jeep_shoot_loop_2" ][0] = %payback_end_fire_soap_2;
	
	//soap sit down
	level.scr_anim[ "soap" ][ "soap_jeep_sit_down" ] = %payback_end_to_idle_soap;
	
	//soap idle after he gets in the jeep
	level.scr_anim[ "soap" ][ "soap_back_jeep_loop" ][0] = %rubicon_idle_backR;
	
	//rescue echo 1 slide
	level.scr_anim[ "rescue_echo_1" ][ "rescue_echo_1_slide" ] = %payback_end_slide_bravo_1;
	addNotetrack_customFunction( "rescue_echo_1", "slide_fx_on", maps\payback_rescue::slide_fx_on , "rescue_echo_1_slide" );
	addNotetrack_customFunction( "rescue_echo_1", "slide_fx_off", maps\payback_rescue::slide_fx_off , "rescue_echo_1_slide" );
	
	//rescue echo 2 slide
	level.scr_anim[ "rescue_echo_2" ][ "rescue_echo_2_slide" ] = %payback_end_slide_bravo_2;
	addNotetrack_customFunction( "rescue_echo_2", "slide_fx_on", maps\payback_rescue::slide_fx_on , "rescue_echo_2_slide" );
	addNotetrack_customFunction( "rescue_echo_2", "slide_fx_off", maps\payback_rescue::slide_fx_off , "rescue_echo_2_slide" );
	
	//escape jeep 1 driver
	level.scr_anim[ "escape_jeep_1_driver" ][ "escape_jeep_1_driver_loop" ][0] = %rubicon_idle_driver;

	//escape jeep 2 driver
	level.scr_anim[ "escape_jeep_2_driver" ][ "escape_jeep_2_driver_loop" ][0] = %rubicon_idle_driver;
	

	/////////////////////////////////////////////
}

#using_animtree( "animated_props" );
animated_prop_setup()
{
		
	level.scr_animtree["umbrella"] = #animtree;
	level.scr_anim["umbrella"]["heli_wind_near"][0] = %payback_tableumbrella_broken_wind_1;
	level.scr_anim["umbrella"]["heli_wind_far"][0] = %payback_tableumbrella_broken_wind_2;
	level.scr_anim["umbrella"]["wind_idle_1"][0] = %payback_tableumbrella_broken_wind_1_idle;
	level.scr_anim["umbrella"]["wind_idle_2"][0] = %payback_tableumbrella_broken_wind_2_idle;	
	
	level.scr_animtree["construction_lamp"] = #animtree;
	level.scr_anim["construction_lamp"]["wind_medium"][0] = %payback_const_hanging_light;
	
	level.scr_animtree["moroccan_lamp"] = #animtree;
	level.scr_anim["moroccan_lamp"]["wind_heavy"][0] = %payback_sstorm_moroccan_lamp_wind_heavy;
	
	level.scr_animtree["foliage_tree_palm_med_1"] = #animtree;
	level.scr_anim[ "foliage_tree_palm_med_1" ][ "light_sway" ][0] = %palmtree_med1_sway;
	level.scr_anim[ "foliage_tree_palm_med_1" ][ "strong_sway" ][0] = %payback_sstorm_palm_med_windy;
	level.scr_animtree["foliage_tree_palm_bushy_3"] = #animtree;
	level.scr_anim[ "foliage_tree_palm_bushy_3" ][ "med_sway" ][0] = %payback_sstorm_palm_bushy_windy_med;
	level.scr_anim[ "foliage_tree_palm_bushy_3" ][ "strong_sway" ][0] = %payback_sstorm_palm_bushy_windy;
	level.scr_animtree[ "foliage_tree_jungle" ] = #animtree;
	level.scr_anim[ "foliage_tree_jungle" ][ "wind_med_1" ][0] = %payback_sstorm_tree_jungle_wind_med;
	level.scr_anim[ "foliage_tree_jungle" ][ "wind_med_2" ][0] = %payback_sstorm_tree_jungle_wind_med_02;
	level.scr_anim[ "foliage_tree_jungle" ][ "wind_heavy_1" ][0] = %payback_sstorm_tree_jungle_wind_heavy;
	level.scr_anim[ "foliage_tree_jungle" ][ "wind_heavy_2" ][0] = %payback_sstorm_tree_jungle_wind_heavy_02;
	level.scr_animtree[ "foliage_tree_pine" ] = #animtree;
	level.scr_anim[ "foliage_tree_pine" ][ "wind_light_1" ][0] = %payback_sstorm_pine_wind_light_1;
	level.scr_anim[ "foliage_tree_pine" ][ "wind_light_2" ][0] = %payback_sstorm_pine_wind_light_2;
	level.scr_anim[ "foliage_tree_pine" ][ "wind_med_1" ][0] = %payback_sstorm_pine_wind_med_1;
	level.scr_anim[ "foliage_tree_pine" ][ "wind_med_2" ][0] = %payback_sstorm_pine_wind_med_2;
	level.scr_anim[ "foliage_tree_pine" ][ "wind_heavy_1" ][0] = %payback_sstorm_pine_wind_heavy_1;
	level.scr_anim[ "foliage_tree_pine" ][ "wind_heavy_2" ][0] = %payback_sstorm_pine_wind_heavy_2;
	level.scr_animtree[ "dwarf_palm" ] = #animtree;
	level.scr_anim[ "dwarf_palm" ][ "wind_light" ][0] = %payback_sstorm_dwarf_palm_light;
	level.scr_anim[ "dwarf_palm" ][ "wind_med" ][0] = %payback_sstorm_dwarf_palm_med;
	
	// rpg crate in enemy vignette
	level.scr_animtree["rpg_crate"] = #animtree;
	level.scr_anim["rpg_crate"]["payback_docks_get_rpg_crate"] = %payback_docks_get_rpg_crate;
	
	//Laundry
	level.scr_animtree[ "hanging_sheet" ] = #animtree;
	level.scr_anim[ "hanging_sheet" ][ "wind_medium" ][0]= %hanging_clothes_sheet_wind_medium;
	
	level.scr_animtree[ "hanging_short_sleeve" ] = #animtree;
	level.scr_anim[ "hanging_short_sleeve" ][ "wind_medium" ][0]= %hanging_clothes_short_sleeve_wind_medium;
	
	level.scr_animtree[ "hanging_long_sleeve" ] = #animtree;
	level.scr_anim[ "hanging_long_sleeve" ][ "wind_medium" ][0]= %hanging_clothes_long_sleeve_wind_medium;
	
	level.scr_animtree[ "hanging_apron" ] = #animtree;
	level.scr_anim[ "hanging_apron" ][ "wind_medium" ][0] = %hanging_clothes_apron_wind_medium;
	
	// rollcar
	level.scr_animtree["city_rollcar"] = #animtree;
	level.scr_anim["city_rollcar"]["payback_city_rollcar"] = %payback_city_truck_push_car;
	addNotetrack_flag( "city_rollcar" , "explosion" , "city_rollcar_switchmodel" , "payback_city_rollcar" );

	level.scr_animtree["car_barrels"] = #animtree;
	level.scr_model[ "car_barrels" ] = "generic_prop_raven";
	level.scr_anim[ "car_barrels" ][ "payback_city_truck_push_barrels" ] =%payback_city_truck_push_barrels;	
	
	// Antennas
	level.scr_animtree["sstorm_antenna"] = #animtree;
	level.scr_anim[ "sstorm_antenna" ][ "light_sway" ][0] = %payback_sstorm_antenna_wind_1;
	level.scr_anim[ "sstorm_antenna" ][ "strong_sway" ][0] = %payback_sstorm_antenna_wind_2;

	level.scr_animtree["highrise_fencetarp_01"] = #animtree;
	level.scr_anim[ "highrise_fencetarp_01" ][ "light_sway" ][0] = %highrise_fencetarp_01_wind;
	level.scr_anim[ "highrise_fencetarp_01" ][ "strong_sway_initial_loop" ][0] = %payback_sstorm_tarp_01_wind_1;
	level.scr_anim[ "highrise_fencetarp_01" ][ "strong_sway_tear" ] = %payback_sstorm_tarp_01_tear;
	level.scr_anim[ "highrise_fencetarp_01" ][ "strong_sway_final_loop" ][0] = %payback_sstorm_tarp_01_wind_2;

	level.scr_animtree["highrise_fencetarp_03"] = #animtree;
	level.scr_anim[ "highrise_fencetarp_03" ][ "light_sway" ][0] = %highrise_fencetarp_03_wind;
	level.scr_anim[ "highrise_fencetarp_03" ][ "strong_sway_1" ][0] = %payback_sstorm_tarp_03_wind_1;
	level.scr_anim[ "highrise_fencetarp_03" ][ "strong_sway_2" ][0] = %payback_sstorm_tarp_03_wind_2;
	
	level.scr_animtree["highrise_fencetarp_08"] = #animtree;
	level.scr_anim[ "highrise_fencetarp_08" ][ "strong_sway" ][0] = %highrise_fencetarp_08_wind;
	
	// crates with tarp
	level.scr_animtree["tarp_crate"] = #animtree;
	level.scr_anim["tarp_crate"][ "payback_tarp_crate_light_wind" ][0] = %payback_tarp_crate_light_wind;
	level.scr_anim["tarp_crate"][ "payback_tarp_crate_heavy_wind" ][0] = %payback_tarp_crate_heavy_wind;
	
	level.scr_animtree["payback_sstorm_grass"] = #animtree;
	level.scr_anim[ "payback_sstorm_grass" ][ "strong_sway_1" ][0] = %payback_sstorm_grass_wind_1;
	level.scr_anim[ "payback_sstorm_grass" ][ "strong_sway_2" ][0] = %payback_sstorm_grass_wind_2;
	level.scr_anim[ "payback_sstorm_grass" ][ "strong_sway_3" ][0] = %payback_sstorm_grass_wind_3;
	level.scr_anim[ "payback_sstorm_grass" ][ "light_sway" ][0] = %payback_sstorm_grass_wind_light;

	level.scr_animtree["payback_foliage_bush01"] = #animtree;
	level.scr_anim[ "payback_foliage_bush01" ][ "strong_sway_1" ][0] = %payback_sstorm_bush_wind_1;
	level.scr_anim[ "payback_foliage_bush01" ][ "strong_sway_2" ][0] = %payback_sstorm_bush_wind_2;
	level.scr_anim[ "payback_foliage_bush01" ][ "light_sway" ][0] =  %payback_sstorm_bush_low_wind_1;
	
	level.scr_animtree["payback_wires_single"] = #animtree;
	level.scr_anim[ "payback_wires_single" ][ "strong_sway" ][0] = %payback_sstorm_stwires_wind_1;
	
	level.scr_animtree["payback_wires_long"] = #animtree;
	level.scr_anim[ "payback_wires_long" ][ "wind_light_1" ][0] = %payback_wires_long_wind_light_1;
	level.scr_anim[ "payback_wires_long" ][ "wind_light_2" ][0] = %payback_wires_long_wind_light_2;
	level.scr_anim[ "payback_wires_long" ][ "wind_medium_1" ][0] = %payback_wires_long_wind_medium_1;
	level.scr_anim[ "payback_wires_long" ][ "wind_medium_2" ][0] = %payback_wires_long_wind_medium_2;
	level.scr_anim[ "payback_wires_long" ][ "wind_heavy_1" ][0] = %payback_wires_long_wind_heavy_1;
	level.scr_anim[ "payback_wires_long" ][ "wind_heavy_2" ][0] = %payback_wires_long_wind_heavy_2;
	level.scr_anim[ "payback_wires_long" ][ "wind_extreme_1" ][0] = %payback_wires_long_wind_heavy_1;
	level.scr_anim[ "payback_wires_long" ][ "wind_extreme_2" ][0] = %payback_wires_long_wind_heavy_2;
	level.scr_anim[ "payback_wires_long" ][ "wind_rescue_1" ][0] = %payback_wires_long_wind_medium_1;
	level.scr_anim[ "payback_wires_long" ][ "wind_rescue_2" ][0] = %payback_wires_long_wind_medium_2;
		
	level.scr_animtree["payback_wires_short"] = #animtree;
	level.scr_anim[ "payback_wires_short" ][ "wind_light_1" ][0] = %payback_wires_short_wind_light_1;
	level.scr_anim[ "payback_wires_short" ][ "wind_light_2" ][0] = %payback_wires_short_wind_light_2;
	level.scr_anim[ "payback_wires_short" ][ "wind_medium_1" ][0] = %payback_wires_short_wind_medium_1;
	level.scr_anim[ "payback_wires_short" ][ "wind_medium_2" ][0] = %payback_wires_short_wind_medium_2;
	level.scr_anim[ "payback_wires_short" ][ "wind_heavy_1" ][0] = %payback_wires_short_wind_heavy_1;
	level.scr_anim[ "payback_wires_short" ][ "wind_heavy_2" ][0] = %payback_wires_short_wind_heavy_2;
	level.scr_anim[ "payback_wires_short" ][ "wind_extreme_1" ][0] = %payback_wires_short_wind_heavy_1;
	level.scr_anim[ "payback_wires_short" ][ "wind_extreme_2" ][0] = %payback_wires_short_wind_heavy_2;
	level.scr_anim[ "payback_wires_short" ][ "wind_rescue_1" ][0] = %payback_wires_short_wind_medium_1;
	level.scr_anim[ "payback_wires_short" ][ "wind_rescue_2" ][0] = %payback_wires_short_wind_medium_2;
	
	level.scr_animtree["payback_sstorm_fence_chainlink"] = #animtree;
	level.scr_anim[ "payback_sstorm_fence_chainlink" ][ "strong_sway_1" ][0] = %payback_sstorm_fence_wind_1;
	level.scr_anim[ "payback_sstorm_fence_chainlink" ][ "strong_sway_2" ][0] = %payback_sstorm_fence_wind_2;
	
	level.scr_animtree["payback_sstorm_sign_metal"] = #animtree;
	level.scr_anim[ "payback_sstorm_sign_metal" ][ "strong_sway_l" ][0] = %payback_sstorm_sign_metal_wind_l;
	level.scr_anim[ "payback_sstorm_sign_metal" ][ "strong_sway_r" ][0] = %payback_sstorm_sign_metal_wind_r;

	level.scr_animtree["payback_sstorm_sign_chain"] = #animtree;
	level.scr_anim[ "payback_sstorm_sign_chain" ][ "strong_sway_l" ][0] = %payback_sstorm_sign_chain_L;
	level.scr_anim[ "payback_sstorm_sign_chain" ][ "strong_sway_r" ][0] = %payback_sstorm_sign_chain_R;

	level.scr_animtree["payback_scaffolding_collapse"] = #animtree;
	level.scr_anim[ "payback_scaffolding_collapse" ][ "payback_scaffolding_collapse" ] = %payback_scaffolding_collapse;

	// wall collapse
	level.scr_animtree["const_wall_frame"] = #animtree;
	level.scr_anim["const_wall_frame"]["fall"] = %payback_const_frame_break;
	level.scr_animtree["const_wall_scaffold"] = #animtree;
	level.scr_anim["const_wall_scaffold"]["fall"] = %payback_const_scaff_fall;
	level.scr_animtree["const_wall_wall"] = #animtree;
	level.scr_anim["const_wall_wall"]["fall"] = %payback_const_wall_fall;
	addNotetrack_flag( "const_wall_wall" , "screen_shake" , "const_wallfall_screen_shake" , "fall" );
	level.scr_animtree["const_wall_side_wall"] = #animtree;
	level.scr_anim["const_wall_side_wall"]["fall"] = %payback_const_side_wall_break;
	level.scr_animtree["const_wall_final_debris"] = #animtree;
	level.scr_anim["const_wall_final_debris"]["fall"] = %payback_const_final_break;
	
	/*
	level.scr_animtree["payback_wall_collapse"] = #animtree;
	level.scr_anim[ "payback_wall_collapse" ][ "wall_idle_loop" ][0] = %payback_wall_collapse_loop;
	level.scr_anim[ "payback_wall_collapse" ][ "wall_collapse" ] = %payback_wall_collapse;
	*/

	level.scr_animtree["payback_studwall_collapse"] = #animtree;
	level.scr_anim[ "payback_studwall_collapse" ][ "payback_studwall_collapse_loop" ][0] = %payback_studwall_collapse_loop;
	level.scr_anim[ "payback_studwall_collapse" ][ "payback_studwall_collapse" ] = %payback_studwall_collapse;

	// rolling bush
	level.scr_animtree["sstorm_bush"] = #animtree;
	level.scr_anim[ "sstorm_bush" ][ "roll_loop" ][0] = %payback_sstorm_bush_roll;
	level.scr_anim[ "sstorm_bush" ][ "roll_stop_loop" ][0] = %payback_sstorm_bush_stop_loop;
	
	// rolling bucket
	level.scr_animtree["sstorm_bucket"] = #animtree;
	level.scr_anim[ "sstorm_bucket" ][ "roll_loop" ][0] = %payback_sstorm_bucket_roll;
	level.scr_anim[ "sstorm_bucket" ][ "roll_stop_loop" ][0] = %payback_sstorm_bucket_stop_loop;
	
	// rolling barrel
	level.scr_animtree["sstorm_barrel"] = #animtree;
	level.scr_anim[ "sstorm_barrel" ][ "roll_loop" ][0] = %payback_sstorm_barrel_roll;
	
	// rolling chicken coup
	level.scr_animtree["sstorm_chicken_coop"] = #animtree;
	level.scr_anim[ "sstorm_chicken_coop" ][ "roll_loop" ] = %payback_sstorm_cage_roll;

	level.scr_animtree["sstorm_chicken"] = #animtree;
	level.scr_anim[ "sstorm_chicken" ][ "chicken_loop_01" ] = %chicken_cage_loop_01;
	level.scr_anim[ "sstorm_chicken" ][ "chicken_loop_02" ] = %chicken_cage_loop_02;

	//intro gate
	level.scr_animtree["intro_gate"] = #animtree;	
	
	level.scr_anim[ "intro_gate" ]["gate_close"]				= %payback_gatecrash_closegate_gate;
	level.scr_anim[ "intro_gate" ]["gate_crash"]				= %payback_gate_gatecrasher_intro;
	
	
	// tin roof in sandstorm
	level.scr_animtree["tinroof"] = #animtree;
	level.scr_anim["tinroof"]["payback_sstorm_tinroof_enter_idle"] = %payback_sstorm_tinroof_enter_idle;
	level.scr_anim["tinroof"]["payback_sstorm_tinroof_tear"] = %payback_sstorm_tinroof_tear;
	level.scr_anim["tinroof"]["payback_sstorm_tinroof_exit_idle"] = %payback_sstorm_tinroof_exit_idle;
	
	// gate in sandstorm
	level.scr_animtree["sstorm_gate"] = #animtree;
	level.scr_anim[ "sstorm_gate" ][ "gate_loop" ][0] = %payback_sstorm_gate_windy;
	level.scr_anim[ "sstorm_gate" ][ "gate_loop_single" ] = %payback_sstorm_gate_windy;
	level.scr_anim[ "sstorm_gate" ][ "gate_loop_2" ][0] = %payback_sstorm_gate_windy_2;
	level.scr_anim[ "sstorm_gate" ][ "gate_loop_2_single" ] = %payback_sstorm_gate_windy_2;
	
	//gate after rappel
	level.scr_anim[ "sstorm_gate" ][ "gate_loop_closed" ][0] = %payback_sstorm_gate_windy_loop_closed;
	level.scr_anim[ "sstorm_gate" ][ "gate_loop_closed_single" ] = %payback_sstorm_gate_windy_loop_closed;
	level.scr_anim[ "sstorm_gate" ][ "gate_windy_open" ] = %payback_sstorm_gate_windy_open;
	
	//chain on gate
	level.scr_animtree["sstorm_gate_chain"] = #animtree;	
	level.scr_anim["sstorm_gate_chain"]["chain_windy_loop_closed"][0] = %payback_sstorm_chain_windy_loop_closed;
	level.scr_anim["sstorm_gate_chain"]["chain_windy_loop_closed_single"] = %payback_sstorm_chain_windy_loop_closed;
	level.scr_anim["sstorm_gate_chain"]["chain_windy_open"] = %payback_sstorm_chain_windy_open;
	
	//chain on second gate
	level.scr_animtree[ "sstorm_gate_chain" ] = #animtree;
	level.scr_anim[ "sstorm_gate_chain" ][ "chain_windy_2_loop" ][0] = %payback_sstorm_chain_windy_2;
	level.scr_anim[ "sstorm_gate_chain" ][ "chain_windy_2_single" ] = %payback_sstorm_chain_windy_2;
	
	// market stall
	level.scr_animtree["marketstall"] = #animtree;
	level.scr_anim["marketstall"]["payback_sstorm_market_stall_loop"][0] = %payback_sstorm_market_stall_loop;
	level.scr_anim["marketstall"]["payback_sstorm_market_stall_tear"] = %payback_sstorm_market_stall_tear;
	level.scr_anim["marketstall"]["payback_sstorm_market_stall_exit"] = %payback_sstorm_market_stall_exit;
	
	//water tower
	level.scr_animtree["watertower"] = #animtree;
	level.scr_anim["watertower"]["payback_sstorm_water_tower_idle"][0] = %payback_sstorm_water_tower_idle;
	level.scr_anim["watertower"]["payback_sstorm_water_tower_fall"] = %payback_sstorm_water_tower_fall;
	
	//Interrogation
	
	//Price's hat
	level.scr_animtree["price_hat"] = #animtree;
	level.scr_model[ "price_hat" ] = "hat_price_africa";
	level.scr_anim[ "price_hat" ][ "price_hat_interrogation" ] = %payback_interrogation_price_hat;
	
	// front crates
	level.scr_animtree["dummy_prop_1"] = #animtree;
	level.scr_model[ "dummy_prop_1" ] = "generic_prop_raven";
	level.scr_anim[ "dummy_prop_1" ][ "waraabe_breach" ] = %payback_breach_frontcrates;
	level.scr_anim[ "dummy_prop_1" ][ "waraabe_interrogation" ] = %payback_interrogation_frontcrates;
	
	// gas canister
	level.scr_animtree["dummy_prop_2"] = #animtree;
	level.scr_model[ "dummy_prop_2" ] = "generic_prop_raven";
	level.scr_anim[ "dummy_prop_2" ][ "waraabe_interrogation" ] = %payback_interrogation_warrabe_gasmask;

	// extra gas mask
	level.scr_animtree[ "dummy_prop_7" ] = #animtree;
	level.scr_model[ "dummy_prop_7" ] = "generic_prop_raven";	
	level.scr_anim[ "dummy_prop_7" ][ "waraabe_interrogation" ] = %payback_interrogation_gascanister;
	addNotetrack_customFunction( "dummy_prop_7", "fx_big_spew", maps\payback_1_script_e::activate_gas_can_2 , "waraabe_interrogation" );
	addNotetrack_customFunction( "dummy_prop_7", "fx_sparks", maps\payback_1_script_e::fx_sparks, "waraabe_interrogation");
	addNotetrack_customFunction( "dummy_prop_7", "fx_initial_spew", maps\payback_1_script_e::fx_initial_spew, "waraabe_interrogation");
	addNotetrack_customFunction( "dummy_prop_7", "fx_big_spew", maps\payback_1_script_e::fx_big_spew , "waraabe_interrogation" );
	
	//price's gas mask
	level.scr_animtree[ "price_new_gas_mask" ] = #animtree;
	level.scr_model[ "price_new_gas_mask" ] = "pb_gas_mask_prop";	
	level.scr_anim[ "price_new_gas_mask" ][ "waraabe_interrogation" ] = %payback_interrogation_mask_price;
	
	//soap's gas mask
	level.scr_animtree[ "soap_new_gas_mask" ] = #animtree;
	level.scr_model[ "soap_new_gas_mask" ] = "pb_gas_mask_prop";	
	level.scr_anim[ "soap_new_gas_mask" ][ "waraabe_interrogation" ] = %payback_interrogation_mask_soap;
	
	//extra gas mask
	level.scr_animtree[ "extra_new_gas_mask" ] = #animtree;
	level.scr_model[ "extra_new_gas_mask" ] = "pb_gas_mask_prop";	
	level.scr_anim[ "extra_new_gas_mask" ][ "waraabe_interrogation" ] = %payback_interrogation_mask_waraabe;
	
	// back crates
	level.scr_animtree["dummy_prop_4"] = #animtree;
	level.scr_model[ "dummy_prop_4" ] = "generic_prop_raven";
	level.scr_anim[ "dummy_prop_4" ][ "waraabe_breach" ] = %payback_breach_backcrates;
	level.scr_anim[ "dummy_prop_4" ][ "waraabe_interrogation" ] = %payback_interrogation_backcrates;
	
	// clipboard and phone
	level.scr_animtree["dummy_prop_5"] = #animtree;
	level.scr_model[ "dummy_prop_5" ] = "generic_prop_raven";
	level.scr_anim[ "dummy_prop_5" ][ "waraabe_breach" ] = %payback_breach_clipboardphone;

	// exit door
	level.scr_animtree["dummy_prop_6"] = #animtree;
	level.scr_model[ "dummy_prop_6" ] = "generic_prop_raven";
	level.scr_anim[ "dummy_prop_6" ][ "waraabe_interrogation" ] = %payback_interrogation_door;
	
	//interrogation laptop
	level.scr_animtree["waraabe_laptop"] = #animtree;
	level.scr_model[ "waraabe_laptop" ] = "hjk_laptop_animated";
	level.scr_anim[ "waraabe_laptop" ][ "waraabe_breach" ] = %payback_breach_laptop;
	
	//shutters in interrogation room
	level.scr_animtree[ "interrogation_room_shutters" ] = #animtree;
	level.scr_model[ "interrogation_room_shutters" ] = "generic_prop_raven";
	level.scr_anim[ "interrogation_room_shutters" ]["shutters_01"][0] = %payback_interrogation_shutters1;
	level.scr_anim[ "interrogation_room_shutters" ]["shutters_02"][0] = %payback_interrogation_shutters2;	
	level.scr_anim[ "interrogation_room_shutters" ]["shutters_03"][0] = %payback_interrogation_shutters3;
	level.scr_anim[ "interrogation_room_shutters" ]["shutters_04"][0] = %payback_interrogation_shutters4;
	level.scr_anim[ "interrogation_room_shutters" ]["shutters_05"][0] = %payback_interrogation_shutters5;
	level.scr_anim[ "interrogation_room_shutters" ]["shutters_06"][0] = %payback_interrogation_shutters6;
	
	//curtains in interrogation room
	level.scr_animtree["interrogation_room_curtains"] = #animtree;
	level.scr_anim[ "interrogation_room_curtains" ]["curtains_01"][0] = %payback_interrogation_curtain1;
	level.scr_anim[ "interrogation_room_curtains" ]["curtains_02"][0] = %payback_interrogation_curtain2;
	level.scr_anim[ "interrogation_room_curtains" ]["curtains_04"][0] = %payback_interrogation_curtain4;
	level.scr_anim[ "interrogation_room_curtains" ]["curtains_05"][0] = %payback_interrogation_curtain5;
	level.scr_anim[ "interrogation_room_curtains" ]["curtains_06"][0] = %payback_interrogation_curtain6;	
	
	//curtains in compound first floor
	level.scr_animtree[ "compound_curtains" ] = #animtree;
	level.scr_anim[ "compound_curtains" ][ "lower_curtains_01" ][0] = %payback_lower_curtains1;
	level.scr_anim[ "compound_curtains" ][ "lower_curtains_02" ][0] = %payback_lower_curtains2;
	
	// Top of construction site debris (to block path down)
	level.scr_animtree["payback_const_crates"] = #animtree;
	level.scr_anim[ "payback_const_crates" ][ "debris_fall" ]               = %payback_const_crates;
	
	// Heli crash
	level.scr_animtree["payback_heli_crash"] = #animtree;
	level.scr_anim[ "payback_heli_crash" ][ "heli_crash" ]                  = %payback_heli_crash_new;
	level.scr_anim[ "payback_heli_crash" ][ "heli_crash_rappel" ]			= %payback_heli_crash_rappel;
	level.scr_anim[ "payback_heli_crash" ][ "heli_crash_rpg" ]				= %payback_heli_crash_rpg;
	level.scr_anim[ "payback_heli_crash" ][ "heli_crash_roof_debris" ]		= %payback_heli_crash_debris;
	level.scr_anim[ "payback_heli_crash" ][ "heli_crash_rappel_debris" ]	= %payback_heli_crash_rappel_debris;

/*	
	// Heli rpg
	level.scr_animtree["payback_heli_crash_rpg"] = #animtree;
	level.scr_model["payback_heli_crash_rpg"] = "projectile_rpg7";
*/	
	//Construction Site Rappel
	// player rope
	level.scr_animtree[ "player_rope" ] = #animtree;
	level.scr_model[ "player_rope" ] = "payback_const_rappel_rope";
	level.scr_anim[ "player_rope" ][ "payback_const_rappel_rope_idle_1" ][0] = %payback_const_rappel_rope_idle_1;
	level.scr_anim[ "player_rope" ][ "const_rappel_player" ] = %payback_const_rappel_rope_player;
	level.scr_anim[ "player_rope" ][ "const_rappel_price" ] = %payback_const_rappel_rope_price;
	
	//soap's rope
	level.scr_animtree[ "soap_rope" ] = #animtree;
	level.scr_model[ "soap_rope" ] = "payback_const_rappel_rope";
	level.scr_anim[ "soap_rope" ][ "payback_const_rappel_rope_idle_2" ][0] = %payback_const_rappel_rope_idle_2;
	level.scr_anim[ "soap_rope" ][ "const_rappel_soap" ] = %payback_const_rappel_rope_soap;
	
	level.scr_animtree[ "rope_glow" ] = #animtree;
	level.scr_model[ "rope_glow" ] = "payback_const_rappel_rope_obj";
	level.scr_anim[ "rope_glow" ][ "payback_const_rappel_rope_idle_1" ][0] = %payback_const_rappel_rope_idle_1;
	
	//crashed chopper prop
	level.scr_animtree[ "chopper_prop" ] = #animtree;
	level.scr_model[ "chopper_prop" ] = "pb_sstorm_chopper_rescue_propeller";
	level.scr_anim[ "chopper_prop" ][ "payback_sstorm_chopper_rescue_propeller" ][0] = %payback_sstorm_chopper_rescue_propeller;
	
	//crashed chopper tail
	level.scr_animtree[ "chopper_tail" ] = #animtree;
	level.scr_model[ "chopper_tail" ] = "pb_sstorm_chopper_rescue_tail_anim";
	level.scr_anim[ "chopper_tail" ][ "payback_sstorm_chopper_rescue_tail_rotor" ][0] = %payback_sstorm_chopper_rescue_tail_rotor;
	
	//Escape Debris that Price Dodges
	level.scr_animtree[ "escape_debris" ] = #animtree;
	level.scr_model[ "escape_debris" ] = "payback_escape_debris";
	level.scr_anim[ "escape_debris" ][ "escape_debris_dodge" ] = %payback_escape_price_debris;
}

#using_animtree( "script_model" );
animated_model_setup()
{
	level.scr_animtree["com_square_flag"] = #animtree;
	level.scr_anim[ "com_square_flag" ][ "strong_sway" ][0] = %cliffhanger_square_flag_high_wind;
	/*
	// door peek
	level.scr_animtree["door_peek"] = #animtree;
	level.scr_anim["door_peek"]["doorpeek_open"] = %doorpeek_open_door;

	// door kick
	level.scr_animtree["door_kick"] = #animtree;
	level.scr_anim["door_kick"]["door_kick_in"] = %doorpeek_kick_door;
	*/
	
	// payback breach charge
	level.scr_anim[ "breach_door_charge_payback" ][ "breach" ]			 = %breach_player_frame_charge;
	level.scr_animtree[ "breach_door_charge_payback" ] 					 = #animtree;
	level.scr_model[ "breach_door_charge_payback" ] 					 = "weapon_frame_charge_iw5_water";
	
	// payback door
	level.scr_anim[ "breach_door_model_payback" ][ "breach" ]			 = %breach_player_door_v2;
	level.scr_animtree[ "breach_door_model_payback" ]					 = #animtree;
	level.scr_model[ "breach_door_model_payback" ]						 = "pb_door_breach_anim";

	level.scr_anim[ "breach_door_hinge_payback" ][ "breach" ]			 = %breach_player_door_hinge_v1;
	level.scr_animtree[ "breach_door_hinge_payback" ] 					 = #animtree;
	level.scr_model[ "breach_door_hinge_payback" ] 						 = "pb_door_breach_hinge_anim";
}

#using_animtree( "vehicles" );
vehicle_intro_setup()
{
	//level.scr_animtree["bravo_hummer"] = #animtree;
	//level.scr_anim[ "bravo_hummer" ][ "gate_crash" ] 			 = %payback_truckb_gatecrasher_intro;	//brav0 crashes through gate
	
	//escape jeep 1
	level.scr_animtree["escape_jeep_1"] = #animtree;
	level.scr_model[ "escape_jeep_1" ] = "vehicle_jeep_rubicon";
	level.scr_anim[ "escape_jeep_1" ][ "jeep_slide_escape" ] = %payback_end_turnaround_jeep;
	
	//escape jeep 2
	level.scr_animtree["escape_jeep_2"] = #animtree;
	level.scr_model[ "escape_jeep_2" ] = "vehicle_jeep_rubicon";
	level.scr_anim[ "escape_jeep_2" ][ "jeep_slide_escape" ] = %payback_end_jeep_2;
	
	//swerve technical
	level.scr_animtree["swerve_technical"] = #animtree;
	level.scr_model[ "swerve_technical" ] = "vehicle_pickup_technical_pb_rusted";
	level.scr_anim[ "swerve_technical" ][ "jeep_slide_escape" ] = %payback_end_technical_2;
	
	//smash technical
	level.scr_animtree["smash_technical"] = #animtree;
	level.scr_model[ "smash_technical" ] = "vehicle_pickup_technical_pb_rusted";
	level.scr_anim[ "smash_technical" ][ "jeep_slide_escape" ] = %payback_end_technical_1;
	
	level.scr_animtree["alpha_hummer"] = #animtree;
	level.scr_anim[ "alpha_hummer" ][ "shift_up" ] 			 = %payback_intro_shift_up_jeep;	//brav0 crashes through gate
	level.scr_anim[ "alpha_hummer" ][ "wheel_turn" ] 		 = %Payback_intro_turn_rubicon;	//brav0 crashes through gate
	
	
	
}


//Overrides for vehicle animations
payback_vehicle_anim_overrides()
{
	//payback hummer
	level.vttype = "humvee";
	level.vtmodel = "vehicle_hummer_open_top_noturret";	
	level.vtclassname = "script_vehicle_hummer_opentop_payback";
	
	maps\_vehicle::build_aianims( ::intro_hummer_overrides, vehicle_scripts\_jeep_rubicon_payback::set_vehicle_anims );
}

#using_animtree( "generic_human");

intro_hummer_overrides()
{
	positions = vehicle_scripts\_jeep_rubicon_payback::setanims();

	positions[ 1 ].leanAndShoot = %payback_gatecrasher_intro_soap;
	return positions;
}

#using_animtree( "player" );
load_player_anims()
{
	//Intro, Jeep Exit
	level.scr_animtree[ "const_player_jeep_rig_1" ] = #animtree;
	level.scr_model[ "const_player_jeep_rig_1" ] = "viewhands_player_yuri";
	
	level.scr_anim[ "const_player_jeep_rig_1" ][ "intro_jeep_stand_player" ] = %Payback_intro_getup_player;
	level.scr_anim[ "const_player_jeep_rig_1" ][ "intro_jeep_jump_player" ] = %payback_intro_turn_player	;	
	level.scr_anim[ "const_player_jeep_rig_1" ][ "intro_jeep_exit_player" ] = %payback_gatecrash_dismount_player;

	//Construction Site Rappel Rig 1
	level.scr_animtree[ "const_player_rig_1" ] = #animtree;
	level.scr_model[ "const_player_rig_1" ] = "viewhands_player_yuri";
	level.scr_anim[ "const_player_rig_1" ][ "const_rappel_player" ] = %payback_const_rappel_player_intro;
	
	//Construction Site Rappel Rig 2
	level.scr_animtree[ "const_player_rig_2" ] = #animtree;
	level.scr_model[ "const_player_rig_2" ] = "viewhands_player_yuri";
	level.scr_anim[ "const_player_rig_2" ][ "const_rappel_player" ] = %payback_const_rappel_player_intro02;
	
	//Construction Site Rappel Rig Ledge 1
	level.scr_animtree[ "const_player_rig_ledge_1" ] = #animtree;
	level.scr_model[ "const_player_rig_ledge_1" ] = "viewhands_player_yuri";
	level.scr_anim[ "const_player_rig_ledge_1" ][ "const_rappel_player" ] = %payback_const_rappel_player_intro;
	
	//Construction Site Rappel Rig Ledge 2
	level.scr_animtree[ "const_player_rig_ledge_2" ] = #animtree;
	level.scr_model[ "const_player_rig_ledge_2" ] = "viewhands_player_yuri";
	level.scr_anim[ "const_player_rig_ledge_2" ][ "const_rappel_player" ] = %payback_const_rappel_player_intro02;
	
	// Rescue Nikolai
	level.scr_animtree[ "rescue_nikolai_player_rig" ] = #animtree;
	level.scr_model[ "rescue_nikolai_player_rig" ] = "viewhands_player_yuri";
	level.scr_anim[ "rescue_nikolai_player_rig" ][ "rescue_nikolai" ] = %payback_sstorm_chopper_rescue_player_getup;
	
	//player side arms
	level.scr_animtree[ "player_slide_rig" ] = #animtree;
	level.scr_model[ "player_slide_rig" ] = "viewhands_player_yuri";
	level.scr_anim[ "player_slide_rig" ][ "exfil_slide_player" ] = %payback_exfil_slide_player;
	
	//player slide legs
	level.scr_animtree[ "player_slide_legs" ] = #animtree;
	level.scr_model[ "player_slide_legs" ] = "viewlegs_generic";
	level.scr_anim[ "player_slide_legs" ][ "jeep_slide_escape" ] = %payback_end_slide_player_legs;
	addNotetrack_customFunction( "player_slide_legs", "slide_fx_on", maps\payback_rescue::slide_fx_on , "jeep_slide_escape" );
	addNotetrack_customFunction( "player_slide_legs", "slide_fx_off", maps\payback_rescue::slide_fx_off , "jeep_slide_escape" );
	
	//player jeep enter arms
	level.scr_animtree[ "player_jeep_enter_rig" ] = #animtree;
	level.scr_model[ "player_jeep_enter_rig" ] = "viewhands_player_yuri";
	level.scr_anim[ "player_jeep_enter_rig" ][ "exfil_enter_jeep_player" ] = %payback_exfil_enter_jeep_player;
	
	//new slide arms
	level.scr_animtree[ "player_slide_arms" ] = #animtree;
	level.scr_model[ "player_slide_arms" ] = "viewhands_player_yuri";
	level.scr_anim[ "player_slide_arms" ][ "jeep_slide_escape" ] = %payback_end_slide_player;
	
	//new jeep arms
	level.scr_animtree[ "player_jeep_arms" ] = #animtree;
	level.scr_model[ "player_jeep_arms" ] = "viewhands_player_yuri";
	level.scr_anim[ "player_jeep_arms" ][ "end_mount" ] = %payback_end_mount_player;

}
