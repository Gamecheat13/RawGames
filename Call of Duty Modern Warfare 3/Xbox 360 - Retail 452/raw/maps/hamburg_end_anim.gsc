#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	models();
	vehicles();	
	props();
	generic_human();
}

#using_animtree( "generic_human" );
generic_human()
{
	/*-----------------------
	VO LINES tank_snd_
	-------------------------*/	
	
	
	//	Frost!			
	level.scr_sound[ "sandman" ][ "hamburg_snd_frost" ] = "hamburg_snd_frost";
	
	//Two Two - you alright?!  Two Two - come in!			
	level.scr_radio[ "tank_rh1_22comein" ] = "tank_rh1_22comein";

	//You guys ok?!			
	level.scr_sound[ "sandman" ][ "hamburg_snd_guysok" ] = "hamburg_snd_guysok";

	//Yeah.  We're good.			
	level.scr_sound[ "generic" ][ "hamburg_rhg_weregood" ] = "hamburg_rhg_weregood";
		
	//Can you shoot?			
	level.scr_sound[ "sandman" ][ "hamburg_snd_canyoushoot" ] = "hamburg_snd_canyoushoot";
		
	//Yeah, I can hold my own.			
	level.scr_sound[ "generic" ][ "hamburg_rhg_holdmyown" ] = "hamburg_rhg_holdmyown";
		
	//Alright, basics fellas.  Find cover - return fire.  Let us know if you need help.			
	level.scr_sound[ "sandman" ][ "hamburg_snd_basics" ] = "hamburg_snd_basics";
		
	//Now we move fast, so keep your heads up.  Let's go.			
	level.scr_sound[ "sandman" ][ "hamburg_snd_movefast" ] = "hamburg_snd_movefast";

	//Metal Zero One, ISR has spotted the convoy half a click from your position.  Get there fast and secure a perimeter around that site.			
	level.scr_radio[ "tank_hqr_spottedtheconvoy" ] = "tank_hqr_spottedtheconvoy";

	//Copy.  We're on our way.			
	level.scr_sound[ "sandman" ][ "hamburg_snd_onourway" ] = "hamburg_snd_onourway";
	
	//TANK!			
	level.scr_sound[ "generic" ][ "hamburg_rhg_tank" ] = "hamburg_rhg_tank";

	//Take cover!			
	level.scr_sound[ "sandman" ][ "hamburg_snd_takecover" ] = "hamburg_snd_takecover";

	//RHINO ONE!  WHERE THE HELL ARE YOU?!			
	level.scr_sound[ "generic" ][ "hamburg_rhg_whereareyou" ] = "hamburg_rhg_whereareyou";

	//Threat neutralized.  We're movin up.			
	level.scr_radio[ "tank_rh1_threatneutralized" ] = "tank_rh1_threatneutralized";

	//INCOMING!!			
	level.scr_sound[ "generic" ][ "hamburg_rhg_incoming" ] = "hamburg_rhg_incoming";

	//Get inside!  Go!  Go!			
	level.scr_sound[ "sandman" ][ "hamburg_snd_getinside" ] = "hamburg_snd_getinside";

	//This is Drifter Five Five, engaging targets on the captiol building.			
	level.scr_radio[ "tank_f16_engagingtargets" ] = "tank_f16_engagingtargets";


		
	
	
	
	
	//---------------------------------------------------------------------
	//--   O L D
	//---------------------------------------------------------------------
	/*
	// "Everyone okay? Dust off and let's move!"
	level.scr_sound[ "sandman" ][ "tank_snd_dustoff" ] = "tank_snd_dustoff";  	

	//The HVIs are in a convoy at the end of this street.	 	 
	level.scr_sound[ "sandman" ][ "tank_snd_endofthestreet" ] = "tank_snd_endofthestreet";  	
	
		// "Overlord, Enemy tank incoming. Need support Now!"
	level.scr_sound[ "sandman" ][ "tank_snd_tankincoming" ] = "tank_snd_tankincoming";  	
		
	
	
	// "Understood. Searching for supporting assets now."
	level.scr_radio[ "tank_hqr_understood" ] = "tank_hqr_understood";		
	
	//Overlord, enemy tank is on top of us!
	level.scr_sound[ "sandman" ][ "tank_snd_ontopofus" ] = "tank_snd_ontopofus";		
	
	//Roger. Support assets arriving at your location momentarily. 	 	 	
	level.scr_radio[ "tank_hqr_supportassets" ] = "tank_hqr_supportassets";		
	
	//Enemy tank is down. Mopping up resistance now.	 	 	
	level.scr_radio[ "tank_tnk_moppingup" ] = "tank_tnk_moppingup";		
	
	//"Sandman","Sniper! Second Floor, destroyed building on the right! ",3 );
	level.scr_sound[ "sandman" ][ "tank_snd_snipersecond" ] = "tank_snd_snipersecond";
	
	
	//"Sandman","We've got runners on the Capitol building! " );
	level.scr_sound[ "sandman" ][ "tank_snd_runnersoncapital" ] = "tank_snd_runnersoncapital";

	
	// "The HVTs were last seen in convoy 1/2 click from here."
	level.scr_sound[ "sandman" ][ "tank_snd_hvts" ] = "tank_snd_hvts";  	
			
	// "Javelins, on the Capital Building! Inside, now!"
	level.scr_sound[ "sandman" ][ "tank_snd_capitalbuilding" ] = "tank_snd_capitalbuilding";  	
	
	//"The Javelins will own you- get in here
	level.scr_sound[ "sandman" ][ "tank_snd_javelinesincoming" ] = "tank_snd_javelinesincoming";  	
			
	// "Inside now! We need to push on to the HVTs! "
	level.scr_sound[ "sandman" ][ "tank_snd_insidenow" ] = "tank_snd_insidenow";  	
			
	// "Get over here before the Javelins take you out!"
	level.scr_sound[ "sandman" ][ "tank_snd_getoverhere" ] = "tank_snd_getoverhere";  	

	// "Sandman", "Overlord, Allied tank is down. Repeat, tank is down.",2);
	level.scr_sound[ "sandman" ][  "tank_snd_tankisdown" ] = "tank_snd_tankisdown";
	
	//"Overlord", "Overlord hears all",2);
	level.scr_radio[ "tank_hqr_understood3"] = "tank_hqr_understood3";
	
	// "Overlord, we're getting pounded down here! Need air support NOW!"
	level.scr_sound[ "sandman" ][ "tank_snd_pounded" ] = "tank_snd_pounded";  	
	
	// "Aaah, negative, air support is unavailable at this time"
	level.scr_radio[ "tank_hqr_unavailable" ] = "tank_hqr_unavailable";		

	//Frost - mget away from those windows.
	level.scr_sound[ "sandman" ][ "tank_snd_getawaywindows" ] = "tank_snd_getawaywindows";
	
	//	get out of the killzone.
	level.scr_sound[ "sandman" ][ "tank_snd_outofkillzone" ] = "tank_snd_outofkillzone";
	
	//Frost, get back here.
	level.scr_sound[ "sandman" ][ "tank_snd_getbackhere" ] = "tank_snd_getbackhere";
	
	// "There's a sniper nest opposite the Javelins."
	level.scr_sound[ "sandman" ][ "tank_snd_snipernest" ] = "tank_snd_snipernest";  	
			
	// "We'll take them out, use their gear to hit the Javelins."
	level.scr_sound[ "sandman" ][ "tank_snd_usetheirgear" ] = "tank_snd_usetheirgear";  	
			
	// "Frost, you’re with me to take out the sniper nest. everyone else, guard this area."
	level.scr_sound[ "sandman" ][ "tank_snd_frostwithme" ] = "tank_snd_frostwithme";  	

	//"Sandman", "We're coming up on the Sniper nest- get ready and take point.",2);
	level.scr_sound[ "sandman" ][ "tank_snd_takepoint" ] = "tank_snd_takepoint";  	

	// Get on that sniper rifle.
	level.scr_sound[ "sandman" ][ "tank_snd_getonsniperrifle" ] = "tank_snd_getonsniperrifle";  	
	
	//"<calm> Be advised we have air support inbound to your location for a run on the Capitol building." );
	level.scr_radio[ "tank_hqr_beadvised" ] = "tank_hqr_beadvised";		

	// "Good work Frost, lets find those HVIs"
	level.scr_sound[ "sandman" ][ "tank_snd_goodwork" ] = "tank_snd_goodwork"; 
	
	// "Overlord, this is Delta 1-2. Be advised, threat from the Capitol building is neutralized. Proceeding to the convoy’s last know position."
	level.scr_sound[ "sandman" ][ "tank_snd_capitalneutralized" ] = "tank_snd_capitalneutralized";
	
	// "Overlord we've got visuals on the convoy.  Multiple vehicles KIA, still clearing hostile forces from the area."
	level.scr_sound[ "sandman" ][ "tank_snd_clearinghostiles" ] = "tank_snd_clearinghostiles"; 
	
	// "We need to get moving after the HVTs. Go Go Go!"
	level.scr_sound[ "sandman" ][ "tank_snd_getmoving" ] = "tank_snd_getmoving"; 

	// "Lets move out, we need to find that convoy, watch crossfire on the streets, were still heavy with hostiles"
	level.scr_sound[ "sandman" ][ "tank_snd_letsmoveout" ] = "tank_snd_letsmoveout";  		
			
	// "Overlord, area clear. Approaching HVTs, over"
	level.scr_sound[ "sandman" ][ "tank_snd_approachinghvis" ] = "tank_snd_approachinghvis";  	
	
	
	level.scr_radio[ "tank_hqr_ospreysinbound" ] = "tank_hqr_ospreysinbound";
			
	// "Overlord, HVTs are NOT here... Over"
	level.scr_sound[ "sandman" ][ "tank_snd_hvisnothere" ] = "tank_snd_hvisnothere";  	

	// "GPS data is showing they are in second story office builidng... sending coordinates."
	level.scr_radio[ "tank_hqr_gpsshowing" ] = "tank_hqr_gpsshowing";		
			
	// "Roger that. Squad on me!"
	level.scr_sound[ "sandman" ][ "tank_snd_squadonme" ] = "tank_snd_squadonme";  	

	// "Overlord, HVTs are dead... we were too late"
	level.scr_sound[ "sandman" ][ "tank_snd_weweretoolate" ] = "tank_snd_weweretoolate";  	
	
	// "This war aint over yet gentlemen"
	level.scr_sound[ "sandman" ][ "tank_snd_waraintover" ] = "tank_snd_waraintover";  	
			
	// "Solid copy Delta, gather intel, evac on the way"
	level.scr_radio[ "tank_hqr_solidcopy" ] = "tank_hqr_solidcopy";		
	
	*/
	
	
	
	
	
	
	
	
	//*NEW* Convoy and Breach and Ending VO
	
	//Rooftop's clear!  Let's move!
	level.scr_sound[ "sandman" ][ "hamburg_snd_rooftopsclear" ] = "hamburg_snd_rooftopsclear";
	
	//The convoy should be at the end of the street!
	level.scr_sound[ "sandman" ][ "hamburg_snd_convoyatend" ] = "hamburg_snd_convoyatend";
	
	//RPGs!  Third floor!
	level.scr_sound[ "rogers" ][ "hamburg_rhg_rpgs" ] = "hamburg_rhg_rpgs";
	
	//Metal Zero One, have you reached the convoy?
	level.scr_radio[ "tank_hqr_reached" ] = "tank_hqr_reached";
	
	//Affirmative, Overlord - but we can't get to it yet!
	level.scr_sound[ "sandman" ][ "hamburg_snd_affirmitive" ] = "hamburg_snd_affirmitive";
	
	//Watch the left side!
	level.scr_sound[ "sandman" ][ "hamburg_snd_watchleft" ] = "hamburg_snd_watchleft";
	
	//We're clear!
	level.scr_sound[ "rogers" ][ "hamburg_rhg_wereclear" ] = "hamburg_rhg_wereclear";
	
	//Check the vehicles.
	level.scr_sound[ "sandman" ][ "hamburg_snd_checkvehicles" ] = "hamburg_snd_checkvehicles";
	
	//Nothin' here!
	level.scr_sound[ "rogers" ][ "hamburg_rhg_nothinhere" ] = "hamburg_rhg_nothinhere";
	
	//They're not here…
	level.scr_sound[ "sandman" ][ "hamburg_snd_nothere" ] = "hamburg_snd_nothere";
	
	//Overlord, negative precious cargo.  I say again - they're not at the convoy.
	level.scr_sound[ "sandman" ][ "hamburg_snd_negativecargo" ] = "hamburg_snd_negativecargo";
	
	//Copy.  Check the area for any sign of the delegates, but be advised - Raptor Four will be on station for exfil in ten minutes, over.
	level.scr_radio[ "tank_hqr_anysign" ] = "tank_hqr_anysign";
	
	//Copy your last.
	level.scr_sound[ "sandman" ][ "hamburg_snd_copyyourlast" ] = "hamburg_snd_copyyourlast";
	
	//Hey - there's a lot of blood over here…
	level.scr_sound[ "rogers" ][ "hamburg_rhg_lotofblood" ] = "hamburg_rhg_lotofblood";
	
	//It's going up those stairs.
	level.scr_sound[ "rogers" ][ "hamburg_rhg_goinup" ] = "hamburg_rhg_goinup";
	
	//Easy…
	level.scr_sound[ "sandman" ][ "hamburg_snd_easy" ] = "hamburg_snd_easy";
	
	//CONTACT!!
	level.scr_sound[ "rogers" ][ "hamburg_rhg_contact" ] = "hamburg_rhg_contact";
	level.scr_sound[ "generic" ][ "hamburg_rhg_contact" ] = "hamburg_rhg_contact";
	
	//Move!  Now!
	level.scr_sound[ "sandman" ][ "hamburg_snd_movenow" ] = "hamburg_snd_movenow";
	
	//Get a charge on the door!
	level.scr_sound[ "sandman" ][ "hamburg_snd_getacharge" ] = "hamburg_snd_getacharge";
	
	//Breach and clear!  Let's go!
	level.scr_sound[ "sandman" ][ "hamburg_snd_breachandclear" ] = "hamburg_snd_breachandclear";
	
	//Frost - get the damn door open!
	level.scr_sound[ "sandman" ][ "hamburg_snd_damndoor" ] = "hamburg_snd_damndoor";
	
	//Look at me, look at me.
	level.scr_sound[ "sandman" ][ "hamburg_snd_lookatme" ] = "hamburg_snd_lookatme";
	
	//It's him.
	level.scr_sound[ "sandman" ][ "hamburg_snd_itshim" ] = "hamburg_snd_itshim";
	
	//Overlord, P.I.D. on the Vice President.  We're ready for extraction.
	level.scr_sound[ "sandman" ][ "hamburg_snd_vicepres" ] = "hamburg_snd_vicepres";
	
	//Solid Copy, Zero One.  Great work.  Raptor Four is arriving on scene now.
	level.scr_radio[ "tank_hqr_onscene" ] = "tank_hqr_onscene";
	
	//Truck, Grinch - we got our guy.  We're on our way to LZ Neptune.  Meet us there.
	level.scr_sound[ "sandman" ][ "hamburg_snd_lzneptune" ] = "hamburg_snd_lzneptune";
	
	//Nice.  I guess the first round's on us.

	level.scr_radio[ "hamburg_rno_firstround" ] = "hamburg_rno_firstround";
	//*NEW END*//

	
	//*ANIMS BEGIN*//
	
	level.scr_anim[ "sandman" ][ "doorkick_2_stand" ] 		    = %doorkick_2_stand;	
	level.scr_anim[ "generic" ][ "doorkick_2_stand" ] 		    = %doorkick_2_stand;	
	

	//hvt_vehicle_search
	level.scr_anim[ "sandman" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_sandman;
	level.scr_anim[ "body1" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_body;
	
	level.scr_anim[ "rogers" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_rogers;
	level.scr_anim[ "body2" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_body;
	

	
	level.scr_anim[ "leftside" ][ "hvt_search_scene_left" ] = %hamburg_convoy_search_left_side_ally;
	
	level.scr_anim[ "rightside" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_right_side_ally;
	level.scr_anim[ "body3" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_right_side_casualty;
	
	//other dead bodies
	level.scr_anim[ "generic" ][ "hamburg_convoy_search_curb_casualty" ] = %hamburg_convoy_search_curb_casualty;
	level.scr_anim[ "generic" ][ "hamburg_convoy_search_front_gaz_russian_casualty" ] = %hamburg_convoy_search_front_gaz_russian_casualty;
	level.scr_anim[ "generic" ][ "hamburg_convoy_search_rear_gaz_russian_casualty" ] = %hamburg_convoy_search_rear_gaz_russian_casualty;
	level.scr_anim[ "generic" ][ "hamburg_convoy_search_suv1_casualty" ] = %hamburg_convoy_search_suv1_casualty;
	level.scr_anim[ "generic" ][ "hamburg_convoy_search_briefcase_casualty" ] = %hamburg_convoy_search_briefcase_casualty;
	//level.scr_anim[ "generic" ][ "hamburg_convoy_search_suv1_suv" ] = %hamburg_convoy_search_suv1_suv;
	
	//slowmo breach
	level.scr_anim[ "generic" ][ "patrol_bored_react_walkstop" ] = %patrol_bored_react_walkstop;
	level.scr_anim[ "generic" ][ "breach_react_blowback_v1" ] = %breach_react_blowback_v1;
	level.scr_anim[ "generic" ][ "exposed_idle_reactA" ] = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "hostage_stand_react_front" ] = %hostage_stand_react_front;
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v3" ] = %death_explosion_stand_B_v3;
	
	level.scr_anim[ "generic" ][ "execution_knife_soldier" ]			 = %execution_knife_soldier;
	level.scr_anim[ "generic" ][ "execution_knife_hostage" ]			 = %execution_knife_hostage;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_death" ]		 = %execution_knife_hostage_death;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_idle" ][ 0 ]	 = %hostage_knees_idle;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_manhandled" ]	 = %takedown_room2B_hostageA;
	level.scr_anim[ "generic" ][ "execution_knife_hostage_manhandled_idle" ][ 0 ]	 = %takedown_room2B_hostageA_idle;
	
	level.scr_anim[ "generic" ][ "melee_B_attack" ]			 = %melee_B_attack;
	level.scr_anim[ "generic" ][ "melee_B_attack_death" ]			 = %death_shotgun_back_v1;
	
	//enemy headshots hostage on his knees
	level.scr_anim[ "generic" ][ "execution_onknees_soldier" ]			 = %execution_onknees_soldier;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage" ]			 = %execution_onknees_hostage;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_idle" ][ 0 ] = %execution_onknees_hostage_survives;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_death" ]	 = %execution_onknees_hostage_death;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_manhandled_guarded" ]	 = %takedown_room1A_hostageB;
	level.scr_anim[ "generic" ][ "execution_onknees_hostage_manhandled_guarded_idle" ][ 0 ]	 = %takedown_room1A_hostageB_idle;
	level.scr_anim[ "sandman" ][ "traverse_jumpdown_130" ]	=%traverse_jumpdown_130;
	
	
	//dead hvts
	//level.scr_anim[ "generic" ][ "dead_hvt1" ] = %hamburg_null_breach_hvt_1;
	//level.scr_anim[ "generic" ][ "dead_hvt2" ] = %hamburg_null_breach_hvt_2;
	//level.scr_anim[ "generic" ][ "dead_hvt3" ] = %hamburg_null_breach_hvt_3;
	//level.scr_anim[ "generic" ][ "dead_hvt4" ] = %arcadia_ending_sceneA_enemy2_death_pose;
	level.scr_anim[ "generic" ][ "dead_hvt5" ] = %hamburg_null_breach_hvt_5;

	// Breach door
	//level.scr_anim[ "breach_door_model" ][ "breach" ]	 		= %breach_player_door_v2;
	level.scr_animtree[ "breach_door_model" ]					= #animtree;
	level.scr_model[ "breach_door_model	" ]					= "com_door_03_handleright";
		
	
	


	//goalpost
	level.scr_anim[ "generic" ][ "secure_hvi" ]						 = %hamburg_secure_hvi_vp;
	//sandman
	level.scr_anim[ "sandman" ][ "secure_hvi" ]						 = %hamburg_secure_hvi_sandman;
}
/*
Anims in generic_human.atr
hamburg_convoy_search_suv1_sandman
hamburg_convoy_search_suv1_body
hamburg_convoy_search_suv2_rogers
hamburg_convoy_search_suv2_body
hamburg_convoy_search_right_side_ally
hamburg_convoy_search_left_side_ally

Anims in animated_props.atr
1	
hamburg_convoy_search_suv1_suv
hamburg_convoy_search_suv2_suv
*/

#using_animtree( "script_model" );
models()
{
	
}

#using_animtree( "vehicles" );
vehicles()
{
	level.scr_animtree["generic"] = #animtree;
	
	level.scr_anim[ "generic" ][ "streets_bust_out_garage" ] = %hamburg_tank_entrance_tank;
//	level.scr_anim[ "generic" ][ "suburban_open_searchFR" ] = %suburban_dismount_frontR_door;
	
	level.scr_animtree["suv1"] = #animtree;
	level.scr_anim[ "suv1" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_suv;
	
	level.scr_animtree["suv2"] = #animtree;
	level.scr_anim[ "suv2" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_suv;
	
	level.scr_animtree["suv3"] = #animtree;
	level.scr_anim[ "suv3" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_suv3;
	
	level.scr_animtree["suv1b"] = #animtree;
	level.scr_anim[ "suv1b" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_suv;
	
	level.scr_animtree["suv2b"] = #animtree;
	level.scr_anim[ "suv2b" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_suv;
	
	level.scr_animtree["suv3b"] = #animtree;
	level.scr_anim[ "suv3b" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_suv3;
	
	level.scr_animtree["gaz1"] = #animtree;
	level.scr_anim[ "gaz1" ][ "hvt_search_scene_gaz" ] = %hamburg_convoy_search_gaz1;
	
	level.scr_animtree["gaz2"] = #animtree;
	level.scr_anim[ "gaz2" ][ "hvt_search_scene_gaz" ] = %hamburg_convoy_search_gaz2;
	
	level.scr_animtree["gaz3"] = #animtree;
	level.scr_anim[ "gaz3" ][ "hvt_search_scene_gaz" ] = %hamburg_convoy_search_gaz3;
	
	addNotetrack_startFXonTag("suv2", "window_start", "hvt_search_scene_rogers", "glass_scrape_runner","tag_fx_glass_front_base" );
	addNotetrack_stopFXonTag("suv2", "window_end", "hvt_search_scene_rogers", "glass_scrape_runner","tag_fx_glass_front_base" );
	/*
	level.scr_animtree[ "tank_crush" ]			 = #animtree;
	level.scr_anim[ "truck" ][ "tank_crush" ]	 = %pickup_tankcrush_front;
	level.scr_anim[ "tank" ][ "tank_crush" ] 	 = %tank_tankcrush_front;
	//level.scr_sound[ "tank_crush" ]				 = "bog_tank_crush_truck";
	
	//addNotetrack_customFunction( "btr", "impact4", ::jeremy_btr_crash_sounds, "prague_drop_btr" );
	//addNotetrack_customFunction( "truck", "glass_shatter", maps\prague_church_script::soap_jump_back, "tank_crush" );
	
	//addNotetrack_customFunction( "truck", "glass_shatter", maps\prague_church_script::soap_jump_back, "tank_crush" );
	
	level._vehicle_effect[ "tankcrush" ][ "window_med" ]	 = loadfx( "props/car_glass_med" );
	level._vehicle_effect[ "tankcrush" ][ "window_large" ]	 = loadfx( "props/car_glass_large" );
	*/
}

#using_animtree( "animated_props" );
props()
{
	//Notetracks for tower collapse scene
	//addNotetrack_customFunction( "tower_collapse", "", maps\hamburg_end_nest::function );
	
	level.scr_animtree["streets_entrance"] = #animtree;
	level.scr_anim[ "streets_entrance" ][ "streets_bust_out_garage" ] = %hamburg_tank_entrance_garage;
	
//	level.scr_animtree["streets_entrance_tank"] = #animtree;
//	level.scr_anim[ "streets_entrance_tank" ][ "streets_bust_out_garage" ] = %hamburg_tank_entrance_tank;
	
//	level.scr_animtree["tower_collapse"] = #animtree;
//	level.scr_anim[ "tower_collapse" ][ "nest_tower_collapse" ] = %hamburg_tower_collapse;

//	level.scr_animtree["awning_collapse"] = #animtree;
//	level.scr_anim[ "awning_collapse" ][ "nest_tower_collapse" ] = %hamburg_awning_crushed;
	
	level.scr_animtree["construction_lamp"] = #animtree;
	level.scr_anim["construction_lamp"]["wind_medium"][0] = %payback_const_hanging_light;
	
	level.scr_animtree["suv_spin_wheel_joint"] = #animtree;
	level.scr_model[ "suv_spin_wheel_joint" ]	= "generic_prop_raven";
	level.scr_anim[ "suv_spin_wheel_joint" ][ "hamburg_suburban_wheel" ][0] = %hamburg_suburban_wheel;
	
	level.scr_animtree["suv_spin_wheel"] = #animtree;
	level.scr_model[ "suv_spin_wheel" ]	= "suburban_destroyed_wheel";
	
	level.scr_animtree["hamburg_briefcase"] =#animtree;
	//level.scr_model[ "hamburg_briefcase" ] = "hamburg_handcuff_briefcase";
	level.scr_anim[ "hamburg_briefcase" ][ "scn_hamburg_briefcase" ] = %hamburg_convoy_search_briefcase;
	//suburban_destroyed_wheel

}

