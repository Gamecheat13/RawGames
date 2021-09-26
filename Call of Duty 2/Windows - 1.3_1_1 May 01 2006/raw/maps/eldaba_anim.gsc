main()
{
	maps\eldaba_anim::misc();
	maps\eldaba_anim::mosque();
	maps\eldaba_anim::door();
	maps\eldaba_anim::boat();
	maps\eldaba_anim::dialogue();
	maps\eldaba_anim::planes();
}

misc()
{
	level.scrsound["tank shot"]			=	"tiger_fire";
	level.scrsound["mosque explode"]	=	"Building_explosion2";
	level.scrsound["plane explode"]		=	"explo_rock";
	level.scrsound["plane_crashing"]	= 	"stuka_crash";
	
	level.scr_sound["stuka_1"]			= 	"plane_flyby_stuka1";
	level.scr_sound["stuka_2"]			= 	"plane_flyby_stuka2";
	level.scr_sound["stuka_3"]			= 	"plane_flyby_stuka3";
	
	level.scr_sound["spitfire_1"]			= 	"plane_flyby_spitfire1";
	level.scr_sound["spitfire_2"]			= 	"plane_flyby_spitfire2";
	level.scr_sound["spitfire_3"]			= 	"plane_flyby_spitfire3";
	
	level.scr_sound ["battleship_gun"]			= "Battleship_gun";
	level.scr_sound ["stuka gun loop"] 			= "stuka_gun_loop"; // Stuka guns firin
	level.scr_sound ["stuka_plane_loop"]		= "stuka_plane_loop";
	level.scr_sound ["spitfire_plane_loop"]		= "spitfire_plane_loop";	
	level.scr_sound ["artillery"] 				= "artillery_explosion";
}

#using_animtree("eldaba_tower_explode");
mosque()
{
	level.scr_anim["mosque"]["explode"]	= 	(%eldaba_tower_explosion);
}
#using_animtree("scripted_anim");
door()
{
	level.scr_anim["door"]["break"]	= 	(%eldaba_archedoor_ambush);
}
#using_animtree("eldaba_cargoship");
boat()
{
	level.scr_anim["boat"]["idle1"][0]			=	%eldaba_cargoship_idle;
	level.scr_anim["boat"]["sink1"]			=	%eldaba_cargoship_sink1;
	level.scr_anim["boat"]["idle2"][0]			=	%eldaba_cargoship_sink1idle;
	level.scr_anim["boat"]["sink2"]			=	%eldaba_cargoship_sink2;
	level.scr_anim["boat"]["splash_left"]	=	%eldaba_cargoship_splash_left;
	level.scr_anim["boat"]["splash_right"]	=	%eldaba_cargoship_splash_right;
}
#using_animtree("generic_human");
dialogue()
{
	//truck animations
	level.scr_anim["ccy"]["truck_idle"][0]				= (%eldaba_truckride_idle_bur);
	level.scr_anim["bs2"]["truck_idleweight"][0]		= 3;
	level.scr_anim["bs2"]["truck_idle"][1]				= (%eldaba_truckride_twitch_bur);
	level.scr_anim["bs2"]["truck_idleweight"][0]		= 1;
	level.scr_anim["ccy"]["truck_duck"]					= (%eldaba_truckride_duck_bur);
	level.scr_anim["ccy"]["truck_trans"]				= (%eldaba_truckride_trans_bur);
	level.scr_anim["ccy"]["truck_idle2"][0]				= (%eldaba_truckride_transidle_bur);
	
	//SOLDIER 4
	level.scr_anim["bs2"]["truck_idle"][0]				= (%eldaba_truckride_idle_guy2);
	level.scr_anim["bs2"]["truck_idleweight"][0]		= 3;
	level.scr_anim["bs2"]["truck_idle"][1]				= (%eldaba_truckride_twitch_guy2);
	level.scr_anim["bs2"]["truck_idleweight"][1]		= 1;
	level.scr_anim["bs2"]["truck_idle"][2]				= (%eldaba_truckride_twitch2_guy2);
	level.scr_anim["bs2"]["truck_idleweight"][2]		= 1;
	level.scr_anim["bs2"]["truck_duck"]					= (%eldaba_truckride_duck_guy2);
	//SOLDIER 3
	level.scr_anim["bs3"]["truck_idle"][0]				= (%eldaba_truckride_idle_guy3);
	level.scr_anim["bs3"]["truck_duck2"]				= (%eldaba_truckride_getdown_guy3);
	level.scr_anim["bs3"]["truck_duck"]					= (%eldaba_truckride_duck_guy3);
	level.scr_anim["bs3"]["truck_idle2"][0]				= (%eldaba_truckride_duckidle_guy3);
	//MACGREGOR
	level.scr_anim["mac"]["truck_idle"][0]				= (%eldaba_truckride_idle_mac);
	level.scr_anim["mac"]["truck_idleweight"][0]		= 4;
	level.scr_anim["mac"]["truck_idle"][1]				= (%eldaba_truckride_twitch1_mac);
	level.scr_anim["mac"]["truck_idleweight"][1]		= 2;
	level.scr_anim["mac"]["truck_idle"][2]				= (%eldaba_truckride_twitch2_mac);
	level.scr_anim["mac"]["truck_idleweight"][2]		= 1;
	level.scr_anim["mac"]["truck_duck"]					= (%eldaba_truckride_duck_mac);
	
	//GENERIC
	level.scr_anim["bs1"]["doorbreach"] 	 = %eldaba_scene_kickdoor;
	level.scr_anim["bs1"]["death"] 			 = %eldaba_scene_kickdoor_pose;
	
	level.scr_anim["mac"]["hideLowWall"][0]	 = %hideLowWall_1;
	level.scr_anim["mac"]["hideLowWall"][1]	 = %hideLowWall_2;
	
	level.scr_anim["generic"]["kick door 1"] = %chateau_kickdoor1;
	level.scr_anim["generic"]["kick door 2"] = %chateau_kickdoor2;
	level.scr_anim["generic"]["director"] 	 = %eldaba_director;
	level.scr_anim["generic"]["crate_walk"]	 = %eldaba_walk_crate;
	level.scr_anim["generic"]["reg_walk"]	 = %stand_walk_combat_loop_01;
	level.scr_anim["generic"]["wave"]		 = %wave_overhere;
	//level.scrsound["generic"]["wave_face"]		= "eldaba_letsgo";
	
	//TIRED GUYS
	level.scr_anim["tired"]["wounded_0"][0]		= %brecourt_woundedman_idle;
	level.scr_anim["tired"]["tiredA"][0]			= %eldaba_tired_idleA;
	level.scr_anim["tired"]["tiredB"][0]			= %eldaba_tired_idleB;
	
	
	// Intro dialogue
	//You hear that players been made sergeant?
	level.scrsound["mac"]["eldaba_mac_madesergeant"]		= "eldaba_mac_madesergeant";
	//he used to be just one of the boys
	level.scrsound["bs3"]["eldaba_bs3_oneoftheboys"]		= "eldaba_bs3_oneoftheboys";
	//hes one of them now
	level.scrsound["mac"]["eldaba_mac_hesoneofthem"]		= "eldaba_mac_hesoneofthem";
	//crying shame that is
	level.scrsound["bs3"]["eldaba_bs3_cryingshame"]			= "eldaba_bs3_cryingshame";
	//its a bloody tragedy
	level.scrsound["mac"]["eldaba_mac_bloodytragedy"]		= "eldaba_mac_bloodytragedy";
	
	//where are we going sir?
	level.scrsound["bs2"]["eldaba_bs2_where"]				= "eldaba_bs2_where";
	//we beat the germans....We’ve been ordered to take the town
	level.scrsound["ccy"]["eldaba_ccy_beatgermans"]			= "eldaba_ccy_beatgermans";
	//el what sir?
	level.scrsound["bs2"]["eldaba_bs2_elwhat"]				= "eldaba_bs2_elwhat";
	//does it really matter?
	level.scrsound["ccy"]["eldaba_ccy_doesntmatter"]		= "eldaba_ccy_doesntmatter";
	//no sire, suppose not
	level.scrsound["bs2"]["eldaba_bs2_nosir"]				= "eldaba_bs2_nosir";
	
	//Look up there! That spitfire is tearing them up!
	level.scrsound["mac"]["eldaba_mac_spitfire"]			= "eldaba_mac_spitfire";
	//Oh! Oh! He just got one!
	level.scrsound["mac"]["eldaba_mac_hejustgotone"]		= "eldaba_mac_hejustgotone";
	//You’d never get me into one of those things.
	level.scrsound["bs3"]["eldaba_bs3_getmeintothose"]		= "eldaba_bs3_getmeintothose";
	
	//Those fighters are getting a little close.
	level.scrsound["ccy"]["eldaba_ccy_gettingclose"]		= "eldaba_ccy_gettingclose";
	//Get down, lads!
	level.scrsound["ccy"]["eldaba_ccy_getdownlads"]			= "eldaba_ccy_getdownlads";
	//eldaba_bur_sc03_02_t1_head
	//It’s gonna hit us!
	level.scrsound["bs3"]["eldaba_bs3_gonnahitus"]			= "eldaba_bs3_gonnahitus";
	
	//
	level.scrsound["bs1"]["eldaba_bs1_assembleoncapt"]		= "eldaba_bs1_assembleoncapt";
	//Right then. Pay attention now boys. We’ve got to secure the – [BANG]
	level.scrsound["ccy"]["eldaba_ccy_rightthen"]			= "eldaba_ccy_rightthen";
	//sniper!
	level.scrsound["mac"]["eldaba_mac_sniper"]				= "eldaba_mac_sniper";
	//captain hit
	level.scrsound["bs1"]["eldaba_bs1_thecaptainhit"]		= "eldaba_bs1_thecaptainhit";
	//That’s a bloody understatement! He’s dead, you wanker!
	level.scrsound["mac"]["eldaba_mac_bloodyunderstatement"]= "eldaba_mac_bloodyunderstatement";
	
	//sniper
	level.scrsound["bs1"]["eldaba_bs1_seesniper"]			= "eldaba_bs1_seesniper";
	level.scrsound["bs2"]["eldaba_bs2_seesniper"]			= "eldaba_bs2_seesniper";
	level.scrsound["bs3"]["eldaba_bs3_seesniper"]			= "eldaba_bs3_seesniper";
	level.scrsound["mac"]["eldaba_mac_seesniper"]			= "eldaba_mac_seesniper";
	
	//lovelyshooting
	level.scrsound["jack"]["eldaba_tcr_lovelyshooting"]		= "eldaba_tcr_lovelyshooting";
	//looks like your in charge seargent
	level.scrsound["jack"]["eldaba_tcr_yourincharge"]		= "eldaba_tcr_yourincharge";
	//lets go i've got a radio
	level.scrsound["mac"]["eldaba_mac_gotradio"]			= "eldaba_mac_gotradio";	
	//Let’s run for the tower.
	level.scrsound["mac"]["eldaba_mac_runfortower"]			= "eldaba_mac_runfortower";	
	//Come on PLAYERNAME, we’ve got to go to the mosque.
	level.scrsound["mac"]["eldaba_mac_mosque"]				= "eldaba_mac_mosque";	
	
	//(talking on the radio) MacGregor calling Ripper Jack. First AT gun spotted.
	level.scrsound["mac"]["eldaba_mac_ripperjack"]			= "eldaba_mac_ripperjack";
	//(heard through the radio) Roger MacGregor. Ripper Jack here. Advise on position over.
	level.scrsound["jack"]["eldaba_tcr_rogermacgregor"]		= "eldaba_tcr_rogermacgregor";
	//(talking on the radio) Position is [GET POSITION FROM MO]
	level.scrsound["mac"]["eldaba_mac_positionis"]			= "eldaba_mac_positionis";
	//(heard through the radio) Roger MacGregor. Gun is at [REPEATS POSITION].
	level.scrsound["jack"]["eldaba_tcr_gunisat"]			= "eldaba_tcr_gunisat";
	//(talking on the radio) Roger that Ripper.
	level.scrsound["mac"]["eldaba_mac_rogerripper"]			= "eldaba_mac_rogerripper";
	
	//(talking on the radio) Second gun spotted over.
	level.scrsound["mac"]["eldaba_mac_secondspotted"]		= "eldaba_mac_secondspotted";
	//(heard through the radio) Roger MacGregor. Advise position over.
	level.scrsound["jack"]["eldaba_tcr_adviseposition"]		= "eldaba_tcr_adviseposition";
	// (talking on the radio) Roger Ripper. Gun spotted at [GET POSITION FROM MO] over.
	level.scrsound["mac"]["eldaba_mac_rogerripperspotted"]	= "eldaba_mac_rogerripperspotted";
	// (heard through the radio) Roger MacGregor. Enemy Gun spotted at [REPEATS POSITION] over.
	level.scrsound["jack"]["eldaba_tcr_enemygunspotted"]	= "eldaba_tcr_enemygunspotted";
	// (talking on the radio) Roger that Ripper. Happy hunting.
	level.scrsound["mac"]["eldaba_mac_happyhunting"]		= "eldaba_mac_happyhunting";
	//(heard through the radio) Jolly good MacGregor. Enjoy the show. Over.
	level.scrsound["jack"]["eldaba_tcr_jollygood"]			= "eldaba_tcr_jollygood";
	// (covering the head set, talking to the player directly) Jolly good. 
	level.scrsound["mac"]["eldaba_mac_jollygood"]			= "eldaba_mac_jollygood";
	// (shakes his head) Can believe the silly gits they make into officers?
	level.scrsound["mac"]["eldaba_mac_sillygits"]			= "eldaba_mac_sillygits";	
	//Those bastards are dead now. We should go meet back with the tank commander.
	level.scrsound["mac"]["eldaba_mac_bastards"]			= "eldaba_mac_bastards";
	
	//Alright lads. The streets of this town are too small for our tanks...
	level.scrsound["jack"]["eldaba_tcr_streetstoosmall"]	= "eldaba_tcr_streetstoosmall";
	level.scr_anim["jack"]["eldaba_tcr_streetstoosmall"]	= (%eldaba_tankcomander);
	//(sarcastic) Carry on then. Don’t worry about us infantry.
	level.scrsound["mac"]["eldaba_mac_carryon"]				= "eldaba_mac_carryon";
	
	
	//NEW DIALOGUE
	//intro
	level.scrsound["mac"]["eldaba_mac_flankright"]			= "eldaba_mac_flankright";
	level.scr_anim["mac"]["eldaba_mac_flankright"]			= (%eldaba_scene_mcgreg_flank);
	//hallway blast/doorbreach
	level.scrsound["gi4"]["eldaba_gi4_nowgonow"]			= "eldaba_gi4_nowgonow";
	level.scrsound["bs1"]["find_way_around"]				= "eldaba_bs1_holdon";
	//docks
	level.scrsound["bs1"]["smoke"]							= "eldaba_bs1_useasmokegrenade";
	level.scrsound["bs1"]["yessir"]							= "eldaba_bs1_acknowledge_yes";
	
	
	//com
	level.scrsound["eldaba_hqr_broadsword"]					= "eldaba_hqr_broadsword";
	//end
	level.scrsound["price"]["eldaba_pri_cheeruplads"]		= "eldaba_pri_cheeruplads";
	level.scr_anim["price"]["eldaba_pri_cheeruplads"]		= (%eldaba_scene_price_ending);
	level.scr_anim["price"]["eldaba_pri_idle"][0]				= (%eldaba_scene_price_ending_idle);
	
	level.scrsound["mac"]["eldaba_mac_drinktothat"]			= "eldaba_mac_drinktothat";
	
}

#using_animtree("eldaba_dogfight");
planes()
{
	level.scr_animtree["dogfight"]		 		= #animtree;
	level.scr_anim["plane german"]["loop"][0]	= (%eldaba_germanplane_loopA);
	level.scr_anim["plane british"]["loop"][0]	= (%eldaba_britishplane_loopA);
	level.scr_anim["plane german"]["loop"][1]	= (%eldaba_germanplane_loopB);
	level.scr_anim["plane british"]["loop"][1]	= (%eldaba_britishplane_loopB);
    level.scr_anim["plane german"]["loop"][2]	= (%eldaba_germanplane_loopC);
	level.scr_anim["plane british"]["loop"][2]	= (%eldaba_britishplane_loopC);
	level.scr_anim["plane german"]["loop"][3]	= (%eldaba_germanplane_loopD);
	level.scr_anim["plane british"]["loop"][3]	= (%eldaba_britishplane_loopD);
	
	level.scr_anim["plane german"]["alley"]		= (%eldaba_germanplane_alley);
	level.scr_anim["plane british"]["alley"]	= (%eldaba_britishplane_alley);
	level.scr_anim["plane german"]["dock"]		= (%eldaba_germanplane_dock);
	level.scr_anim["plane british"]["dock"]		= (%eldaba_britishplane_dock);
	level.scr_anim["plane german"]["tower"]		= (%eldaba_germanplane_tower);
	level.scr_anim["plane british"]["tower"]	= (%eldaba_britishplane_tower);
}