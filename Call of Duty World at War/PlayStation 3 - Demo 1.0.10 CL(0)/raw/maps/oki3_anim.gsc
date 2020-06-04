/*-----------------------------------------------------
Animation loadout for Okinawa 2
-----------------------------------------------------*/
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\oki3_util;
#include maps\_music;
#using_animtree ("generic_human");

main()
{
	
		precache_anims();
		setup_supply_drop_anims();
		init_spiderhole_lid_anims();
		init_spiderhole_anims();
		init_outro_anim();
		
		event1_mg_tarp();
		event2_mortarhut_explode();
		event4_castle_fall();
		
}

precache_anims()
{
	//makes it a bit easier to set it up
	prefix = "Oki3_IGD_";
	r = "_ROEB";
	p = "_POLO";
	
	//most of the dialogue for the level
	level.scr_sound["mortarpit_building_explo"] = "mortarpit_building_explo";
	level.scr_sound["sarge"]["supplies"] 			= prefix + "000A" + r;
	level.scr_sound["sarge"]["doubletime"] 		= prefix + "002A" + r;		
	level.scr_sound["polonsky"]["thereitis"]	= prefix + "001A" + p;
	level.scr_sound["sarge"]["this_is_it"] 		= prefix + "003A" + r;


	level.scr_sound["polonsky"]["snipers"] 		= prefix + "004A" + p;
	level.scr_sound["polonsky"]["where_are"] 	= prefix + "005A" + p;
	level.scr_sound["polonsky"]["in_weeds"] 	= "Oki3_IGD_206A_POLO";
	level.scr_sound["polonsky"]["shoot"]			= "pel2_IGD_107A_USR6";

	level.scr_sound["sarge"]["in_trees"] 			= prefix + "006A" + r;
	level.scr_sound["sarge"]["take_down"] 		=	prefix + "007A" + r;
	level.scr_sound["sarge"]["mg"] 						= prefix + "026A" + r;
	level.scr_sound["sarge"]["mg_nag"]				= prefix + "028A" + r;
	level.scr_sound["sarge"]["incoming"]			= prefix + "010A" + r;
	level.scr_sound["sarge"]["find_cover"] 		= prefix + "011A" + r;	
	level.scr_sound["polonsky"]["incoming"]		= prefix + "012A" + p;
	
	//finds tunnel
	level.scr_sound["sarge"]["spotters"] 			= prefix + "013A" + r;
	level.scr_sound["sarge"]["take_out"] 			= prefix + "014A" + r;
	level.scr_sound["sarge"]["volunteers"] 		= prefix + "015A" + r;
	level.scr_sound["sarge"]["clear_out"] 		= prefix + "017A" + r;		
	level.scr_sound["polonsky"]["miller"] 		= prefix + "016A" + p;
	
	
	//spiderholes/ambush
	level.scr_sound["sarge"]["follow_me"]			= "Oki3_OrderMoveForward";
	level.scr_sound["sarge"]["spiderholes"] 	= prefix + "022A" + r;
	level.scr_sound["sarge"]["eyes_wide"] 		= prefix + "024A" + r;		
	level.scr_sound["polonsky"]["sobs"] 			= prefix + "023A" + p;
	level.scr_sound["sarge"]["watch_more"] 		= prefix + "025A" + r;
	
	//push forward after ambush
	level.scr_sound["sarge"]["push"] 					= prefix + "029A" + r;
	level.scr_sound["sarge"]["multiple"] 			= prefix + "030A" + r;
	level.scr_sound["sarge"]["each_side"] 		= prefix + "031A" + r;
	
	level.scr_sound["sarge"]["up_stairs"] 		= prefix + "032A" + r;
		
	
	//mortar pits
	level.scr_sound["polonsky"]["first"]			= prefix + "033A" + p;	
	level.scr_sound["sarge"]["clear_em"]			= prefix + "034A" + r;
	level.scr_sound["sarge"]["use_against"]		= prefix + "035A" + r;	
	level.scr_sound["sarge"]["one_down"]			= prefix + "036A" + r;
	level.scr_sound["polonsky"]["second"]			= prefix + "037A" + p;	
	level.scr_sound["polonsky"]["two_more"]		= prefix + "040A" + p;
	level.scr_sound["polonsky"]["more"]				= prefix + "038A" + p;	
	level.scr_sound["sarge"]["take_last"] 		= prefix + "042A" + r;
	level.scr_sound["sarge"]["do_it0"] 				= prefix + "041A" + r;
	level.scr_sound["sarge"]["pits_clear"] 		= prefix + "043A" + r;
	level.scr_sound["sarge"]["gatehouse"] 		= prefix + "039A" + r;
	
	// "Get to it, Miller - Take out that Mortar pit!"
	level.scr_sound["sarge"]["do_it1"] = "Oki3_IGD_100A_ROEB";
	// "Hurry, Miller!  clear that mortar pit!"
	level.scr_sound["sarge"]["do_it2"] = "Oki3_IGD_101A_ROEB";
	// "Take down that mortar pit!!!"
	level.scr_sound["polonsky"]["do_it0"] = "Oki3_IGD_104A_POLO";
	// "C'mon, Miller - destroy that mortar pit!!"
	level.scr_sound["polonsky"]["do_it1"] = "Oki3_IGD_105A_POLO";
	// "Miller - Take out the Mortar pit!"
	level.scr_sound["polonsky"]["do_it2"] = "Oki3_IGD_103A_POLO";

	

	
	level.scr_sound["polonsky"]["deeper"] 		= prefix + "020A" + p;
	
//Over Black
	// "Word is - the main force pulled back to the north ridge.."
	level.scr_sound["sarge"]["ob1"] = "Oki3_IGD_200A_ROEB";
	// "...But I want everyone ready to fight."
	level.scr_sound["sarge"]["ob2"] = "Oki3_IGD_201A_ROEB";
	// "Watch the grass... Watch the trees... Watch any Goddamn place tojo could be waiting."
	level.scr_sound["sarge"]["ob3"] = "Oki3_IGD_202A_ROEB";
	
//to supply drop
	// "Our planes bombed the shit outta the place…"
	level.scr_sound["polonsky"]["planes_bombed"] = "Oki3_IGD_203A_POLO";
	// "They'll be back - Soon as they're refuelled and rearmed."
	level.scr_sound["sarge"]["be_back"] = "Oki3_IGD_204A_ROEB";
	// "For now - it's just us."
	level.scr_sound["sarge"]["for_now"] = "Oki3_IGD_205A_ROEB";	
	
//ambush
	// "They're comin' over the sandbags!"
	level.scr_sound["polonsky"]["sandbags"] = "Oki3_IGD_207A_POLO";
	
//underground
	// "Good luck - we'll regroup on the other side!"
	level.scr_sound["sarge"]["good_luck"] = "Oki3_IGD_018A_ROEB";
	
//push up the hill
	// "Focus on the hill!"
	level.scr_sound["sarge"]["focus_hill"] = "Oki3_IGD_208A_ROEB";
	// "Get up there!"
	level.scr_sound["sarge"]["get_up_there"] = "Oki3_IGD_209A_ROEB";
	// "Spread out 
	level.scr_sound["sarge"]["spread_out"] = "Oki3_IGD_210A_ROEB";
	// "Through the gate!"
	level.scr_sound["sarge"]["thru_gate"] = "Oki3_IGD_212A_ROEB";
	
	
//after taking the hill
	// "I'm low on ammo!"
	level.scr_sound["polonsky"]["low_ammo"] = "Oki3_IGD_216A_POLO";
	// "Scavenge what you can!"
	level.scr_sound["sarge"]["scavenge"] = "Oki3_IGD_217A_ROEB";
	// "Use the enemy's weapons if you have to!"
	level.scr_sound["sarge"]["enemy_weapons"] = "Oki3_IGD_218A_ROEB";	
	// "There!  In the high window!"
	level.scr_sound["sarge"]["high_window"] = "Oki3_IGD_213A_ROEB";
	// "On the roof!"
	level.scr_sound["sarge"]["on_roof"] = "Oki3_IGD_214A_ROEB";
	// "More of them - on the roof!"
	level.scr_sound["polonsky"]["more_on_roof"] = "Oki3_IGD_215A_POLO";
	// "Into the west building!"
	level.scr_sound["sarge"]["west_bld"] = "Oki3_IGD_219A_ROEB";	
	// "Up the stairs!"
	level.scr_sound["polonsky"]["stairs"] = "Oki3_IGD_220A_POLO";
	
	
//mortar pit area
	
	// "Push forward! -We've got to take out those mortars!"
	level.scr_sound["sarge"]["push_forward"] = "Oki3_IGD_029A_ROEB";


	// "Flank round!"
	level.scr_sound["sarge"]["flank_round"] = "Oki3_IGD_221A_ROEB";
	
	// "Grab a mortar shell and throw it!"
	level.scr_sound["sarge"]["mortar_nag0"] = "Oki3_IGD_222A_ROEB";
	// "Pick up those mortar shells!"
	level.scr_sound["sarge"]["mortar_nag1"] = "Oki3_IGD_500A_ROEB";

	
	// "Clear the area before we move up!"
	level.scr_sound["sarge"]["clear_area"] = "Oki3_IGD_223A_ROEB";
	// "Grab more mortar shells!"
	level.scr_sound["sarge"]["grab_more"] = "Oki3_IGD_225A_ROEB";
	// "We got another MG on our left flank!"
	level.scr_sound["sarge"]["another_mg"] = "Oki3_IGD_226A_ROEB";
	// "On that balcony!"
	level.scr_sound["sarge"]["on_balcony"] = "Oki3_IGD_224A_ROEB";	
	// "Good work with those mortars, Miller!"
	level.scr_sound["sarge"]["good_work"] = "Oki3_IGD_227A_ROEB";
	// "Get over to that east building!"
	level.scr_sound["sarge"]["east_bld"] = "Oki3_IGD_228A_ROEB";
	// "Pits clear - Move up!"
	level.scr_sound["sarge"]["pits_clear"] = "Oki3_IGD_043A_ROEB";

	
	

//planters/garden area
	// "Okay... We're nearly there."
	level.scr_sound["sarge"]["nearly_there"] = "Oki3_IGD_229A_ROEB";
	// "Planes should be en route to assist."
	level.scr_sound["sarge"]["planes_enroute"] = "Oki3_IGD_230A_ROEB";
	// "Good... They can blow this place to kingdom come."
	level.scr_sound["polonsky"]["they_can_blow"] = "Oki3_IGD_231A_POLO";
	// "Stay alert."
	level.scr_sound["sarge"]["stay_alert"] = "Oki3_IGD_234A_ROEB";
	// "Clear every corner of this courtyard."
	level.scr_sound["sarge"]["both_sides"] = "Oki3_IGD_235A_ROEB";
	// "Flank round both sides!"
	level.scr_sound["sarge"]["every_corner"] = "Oki3_IGD_236A_ROEB";
	// "Split up and hunt 'em down!"
	level.scr_sound["sarge"]["hunt_down"] = "Oki3_IGD_237A_ROEB";
	

//enter main castle sieden
	// "This way."
	level.scr_sound["sarge"]["this_way"] = "Oki3_IGD_238A_ROEB";
	// "Shhh..."
	level.scr_sound["sarge"]["shhh"] = "Oki3_IGD_240A_ROEB";
	// "Sarge - shadows…"
	level.scr_sound["polonsky"]["shadows"] = "Oki3_IGD_242A_POLO";
	
	// "Take aim…"
	level.scr_sound["sarge"]["take_aim"] = "Oki3_IGD_243A_ROEB";
	// "Open fire!"
	level.scr_sound["sarge"]["open_fire"] = "Oki3_IGD_244A_ROEB";
	// "Clear the area!"
	level.scr_sound["sarge"]["clear_area2"] = "Oki3_IGD_245A_ROEB";
	// "Miller - man that MG!"
	level.scr_sound["sarge"]["man_mg"] = "Oki3_IGD_246A_ROEB";


//downstairs
	// "Downstairs!  Into the tunnels!"
	level.scr_sound["sarge"]["downstairs"] = "Oki3_IGD_247A_ROEB";
	// "Shoot those barrels!!!"
	level.scr_sound["sarge"]["shoot_barrels"] = "Oki3_IGD_248A_ROEB";
	// "Up above!"
	level.scr_sound["sarge"]["up_above"] = "Oki3_IGD_250A_ROEB";
	// "They're up above us!"
	level.scr_sound["sarge"]["above_us"] = "Oki3_IGD_251A_ROEB";
	// "On the stairs!"
	level.scr_sound["polonsky"]["on_stairs"] = "Oki3_IGD_252A_POLO";
	// "Upstairs... this way."
	level.scr_sound["sarge"]["upstairs"] = "Oki3_IGD_254A_ROEB";


	
//fake surrender
	
	// "Sarge! - We got movement."
	level.scr_sound["polonsky"]["movement"] = "Oki3_IGD_045A_POLO";


	// "Search him…"
	level.scr_sound["sarge"]["search_him"] = "Oki3_IGD_256A_ROEB";
	// "Keep those hands high…"
	level.scr_sound["sarge"]["hands_high"] = "Oki3_IGD_257A_ROEB";
	// "On the ground... NOW!"
	level.scr_sound["polonsky"]["on_ground"] = "Oki3_IGD_258A_POLO";
	// "I said - On the ground!"
	level.scr_sound["polonsky"]["i_said"] = "Oki3_IGD_259A_POLO";
	// "Get down... "
	level.scr_sound["sarge"]["get_down"] = "Oki3_IGD_260A_ROEB";


//polonsky lives
	// "ROEBUCK!!!"
	level.scr_sound["polonsky"]["sarge"] = "Oki3_IGD_300A_POLO";
	// "Miller!  They killed the sarge!"
	level.scr_sound["polonsky"]["killed_sarge"] = "Oki3_IGD_301A_POLO";
	// "The bastards killed him!"
	level.scr_sound["polonsky"]["bastards_killed"] = "Oki3_IGD_302A_POLO";
	// "You sons of bitches!"
	level.scr_sound["polonsky"]["sonsabitches"] = "Oki3_IGD_303A_POLO";
	// "You Goddamn sons of bitches!!!"
	level.scr_sound["polonsky"]["gd_sonsabitches"] = "Oki3_IGD_304A_POLO";
	// "You're all going to hell - y'hear me???"
	level.scr_sound["polonsky"]["yhear_me"] = "Oki3_IGD_305A_POLO";
	// "You're all going straight to Hell!!!"
	level.scr_sound["polonsky"]["straight_2_hell"] = "Oki3_IGD_306A_POLO";
	// "They're everywhere!"
	level.scr_sound["polonsky"]["all_around"] = "Oki3_IGD_307A_POLO";
	// "They're using smoke!"
	level.scr_sound["polonsky"]["using_smoke"] = "Oki3_IGD_308A_POLO";
	// "Keep firing!"
	level.scr_sound["polonsky"]["keep_firing"] = "Oki3_IGD_309A_POLO";
	// "They're comin' right at us!"
	level.scr_sound["polonsky"]["running_at_us"] = "Oki3_IGD_310A_POLO";
	// "Another fuckin' Banzaii charge!"
	level.scr_sound["polonsky"]["another_charge"] = "Oki3_IGD_311A_POLO";
	// "Hold the line!"
	level.scr_sound["polonsky"]["hold_line"] = "Oki3_IGD_312A_POLO";
	// "Let 'em have it!!!!"
	level.scr_sound["polonsky"]["let_em_haveit"] = "Oki3_IGD_313A_POLO";
	// "You guy ain't learnt your lesson?"
	level.scr_sound["polonsky"]["lesson"] = "Oki3_IGD_314A_POLO";
	// "They're pouring out of that building!!!"
	level.scr_sound["polonsky"]["out_of_building"] = "Oki3_IGD_315A_POLO";
	// "You hear that?... Call in those fucking planes!"
	level.scr_sound["polonsky"]["call_in_planes"] = "Oki3_IGD_316A_POLO";
	// "Blow the bastards to kingdom come!"
	level.scr_sound["polonsky"]["kingdom_come"] = "Oki3_IGD_317A_POLO";
	// "Miller! Call an airstrike - NOW!"
	level.scr_sound["polonsky"]["airstrike_now"] = "Oki3_IGD_318A_POLO";
	// "Do it, Miller - call in those planes!"
	level.scr_sound["polonsky"]["do_it_planes"] = "Oki3_IGD_319A_POLO";
	// "There's more of them!!!"
	level.scr_sound["polonsky"]["theres_more"] = "Oki3_IGD_320A_POLO";
	// "We need that airstrike!!!"
	level.scr_sound["polonsky"]["need_airstrike"] = "Oki3_IGD_321A_POLO";
	
	
	//to the east
	level.scr_sound["polonsky"]["to_east"] = "US_pol_direction_relative_east_00";
	//east of here
	level.scr_sound["polonsky"]["east_ofhere"] = "US_pol_direction_relative_east_01";
	
	//to the north
	level.scr_sound["polonsky"]["to_north"] = "US_pol_direction_relative_north_00";
	//north of here
	level.scr_sound["polonsky"]["north_ofhere"] = "US_pol_direction_relative_north_01";
	
	
	// "Damn..."
	level.scr_sound["polonsky"]["dam"] = "Oki3_IGD_322A_POLO";
	// "We did it... it's over..."
	level.scr_sound["polonsky"]["its_over"] = "Oki3_IGD_323A_POLO";
	// "We made it..."
	level.scr_sound["polonsky"]["we_did_it"] = "Oki3_IGD_324A_POLO";
	
	level.scr_sound["polonsky"]["generic_fight0"] = "Oki3_IGD_312A_POLO";//hold the line
	level.scr_sound["polonsky"]["generic_fight1"] = "Oki3_IGD_313A_POLO";//let em have it
	level.scr_sound["polonsky"]["generic_fight2"] = "Oki3_IGD_309A_POLO";//keep firing

//sarge lives
	// "Polonsky!!!"
	level.scr_sound["sarge"]["no_polonsky"] = "Oki3_IGD_325A_ROEB";
	// "Miller!  Polonsky's down!"
	level.scr_sound["sarge"]["polonsky_down"] = "Oki3_IGD_326A_ROEB";
	// "Those animals killed him!"
	level.scr_sound["sarge"]["those_animals"] = "Oki3_IGD_327A_ROEB";
	// "ANIMALS!!!"
	level.scr_sound["sarge"]["animals"] = "Oki3_IGD_328A_ROEB";
	// "You Goddamn animals!!!"
	level.scr_sound["sarge"]["damn_animals"] = "Oki3_IGD_329A_ROEB";
	// "This ain't over - y'hear me???"
	level.scr_sound["sarge"]["aint_overa"] = "Oki3_IGD_330A_ROEB";
	// "This ain't OVER!!!"
	level.scr_sound["sarge"]["aint_overb"] = "Oki3_IGD_331A_ROEB";
	// "They're all around!"
	level.scr_sound["sarge"]["all_around"] = "Oki3_IGD_332A_ROEB";
	// "They're using smoke!"
	level.scr_sound["sarge"]["using_smoke"] = "Oki3_IGD_333A_ROEB";
	// "Keep suppressing firing!"
	level.scr_sound["sarge"]["keep_firing"] = "Oki3_IGD_334A_ROEB";
	// "They're running right at us!"
	level.scr_sound["sarge"]["running_at_us"] = "Oki3_IGD_335A_ROEB";
	// "Another Goddamn Banzaii charge!"
	level.scr_sound["sarge"]["another_charge"] = "Oki3_IGD_336A_ROEB";
	// "Hold the line!"
	level.scr_sound["sarge"]["hold_line"] = "Oki3_IGD_337A_ROEB";
	// "Put 'em down!!!"
	level.scr_sound["sarge"]["put_em_down"] = "Oki3_IGD_338A_ROEB";
	// "Kill 'em all!!!"
	level.scr_sound["sarge"]["kill_em_all"] = "Oki3_IGD_339A_ROEB";
	// "They're coming out of that building!!!"
	level.scr_sound["sarge"]["out_of_building"] = "Oki3_IGD_340A_ROEB";
	// "You hear that?... Call in the planes!"
	level.scr_sound["sarge"]["call_in_planes"] = "Oki3_IGD_341A_ROEB";
	// "Blow them all to Hell!"
	level.scr_sound["sarge"]["kingdom_come"] = "Oki3_IGD_342A_ROEB";
	// "Now, Miller! Call an airstrike!"
	level.scr_sound["sarge"]["airstrike_now"] = "Oki3_IGD_343A_ROEB";
	// "Call in those planes, Miller!"
	level.scr_sound["sarge"]["call_planes_miller"] = "Oki3_IGD_344A_ROEB";
	// "More of them!!!"
	level.scr_sound["sarge"]["more_ofem"] = "Oki3_IGD_345A_ROEB";
	// "We need that airstrike!!!"
	level.scr_sound["sarge"]["need_airstrike"] = "Oki3_IGD_346A_ROEB";
	
	//to the east
	level.scr_sound["sarge"]["to_east"] = "US_roe_direction_relative_east_00";
	//east of here
	level.scr_sound["sarge"]["east_ofhere"] = "US_roe_direction_relative_east_01";
	
		//to the north
	level.scr_sound["sarge"]["to_north"] = "US_roe_direction_relative_north_00";
	//north of here
	level.scr_sound["sarge"]["north_ofhere"] = "US_roe_direction_relative_north_01";
	
	
	
	// "Damn..."
	level.scr_sound["sarge"]["dam"] = "Oki3_IGD_347A_ROEB";
	// "It's over... It's finally over..."
	level.scr_sound["sarge"]["its_over"] = "Oki3_IGD_348A_ROEB";
	// "We did it..."
	level.scr_sound["sarge"]["we_did_it"] = "Oki3_IGD_349A_ROEB";
	
	level.scr_sound["sarge"]["generic_fight0"] = "Oki3_IGD_337A_ROEB";//hold the line
	level.scr_sound["sarge"]["generic_fight1"] = "Oki3_IGD_338A_ROEB";//put em down
	level.scr_sound["sarge"]["generic_fight2"] = "Oki3_IGD_339A_ROEB";//kill em all
	level.scr_sound["sarge"]["generic_fight3"] = "Oki3_IGD_334A_ROEB";//keep firing
	

//radio chatter	- sarge
	// "Airstrike available."	
	level.scr_sound["sarge"]["available0"] = "Pel1_IGD_835A_RADO";
	// "Airstrike at the ready. "
	level.scr_sound["sarge"]["available1"] = "Pel1_IGD_836A_RADO";	
	// "Airstrike primed and ready to fire."
	level.scr_sound["sarge"]["available2"] = "Pel1_IGD_837A_RADO";
	// "Awaiting target co-ordinates."
	level.scr_sound["sarge"]["available3"] = "Pel1_IGD_838A_RADO";
	
	// "Confirmed."
	level.scr_sound["sarge"]["confirmed0"] = "Pel1_IGD_845A_RADO";
	// "Co-ordinates received."
	level.scr_sound["sarge"]["confirmed1"] = "Pel1_IGD_841A_RADO";
	
	// "30 seconds."
	level.scr_sound["sarge"]["45_sec"] = "Pel1_IGD_820A_RADO";
	level.scr_sound["sarge"]["30_sec"] = "Pel1_IGD_823A_RADO";
	level.scr_sound["sarge"]["20_sec"] = "Pel1_IGD_825A_RADO";	
	level.scr_sound["sarge"]["10_sec"] = "Pel1_IGD_827A_RADO";
	level.scr_sound["sarge"]["5_sec"] = "Pel1_IGD_828A_RADO";
	
	
	
	// "Support unavailable."
	level.scr_sound["sarge"]["unavailable"] = "Pel1_IGD_843A_RADO";
	// "Negative on those co-ordinates - Check your status."
	level.scr_sound["sarge"]["negative"] = "Pel1_IGD_844A_RADO";
	
	//target hit
	level.scr_sound["sarge"]["hit"] = "Pel1_IGD_810A_RADO";
		//target miss
	level.scr_sound["sarge"]["miss"] = "Pel1_IGD_804A_RADO";
	

//radio chatter	- polonsky
	// "Airstrike available."	
	level.scr_sound["polonsky"]["available0"] = "Pel1_IGD_835A_RADO";
	// "Airstrike at the ready. "
	level.scr_sound["polonsky"]["available1"] = "Pel1_IGD_836A_RADO";	
	// "Airstrike primed and ready to fire."
	level.scr_sound["polonsky"]["available2"] = "Pel1_IGD_837A_RADO";
	// "Awaiting target co-ordinates."
	level.scr_sound["polonsky"]["available3"] = "Pel1_IGD_838A_RADO";
	
	// "Confirmed."
	level.scr_sound["polonsky"]["confirmed0"] = "Pel1_IGD_845A_RADO";
	// "Co-ordinates received."
	level.scr_sound["polonsky"]["confirmed1"] = "Pel1_IGD_841A_RADO";
	
	// "20 seconds."
	level.scr_sound["polonsky"]["45_sec"] = "Pel1_IGD_820A_RADO";
	level.scr_sound["polonsky"]["30_sec"] = "Pel1_IGD_823A_RADO";
	level.scr_sound["polonsky"]["20_sec"] = "Pel1_IGD_825A_RADO";	
	level.scr_sound["polonsky"]["10_sec"] = "Pel1_IGD_827A_RADO";
	level.scr_sound["polonsky"]["5_sec"] = "Pel1_IGD_828A_RADO";
	
	// "Support unavailable."
	level.scr_sound["polonsky"]["unavailable"] = "Pel1_IGD_843A_RADO";
	// "Negative on those co-ordinates - Check your status."
	level.scr_sound["polonsky"]["negative"] = "Pel1_IGD_844A_RADO";
	
	//target hit
	level.scr_sound["polonsky"]["hit"] = "Pel1_IGD_810A_RADO";

		//target miss
	level.scr_sound["polonsky"]["miss"] = "Pel1_IGD_804A_RADO";
	
	//death sounds
	level.scr_sound["polonsky"]["polonsky_death"] = "US_pol_death_large";
	level.scr_sound["sarge"]["sarge_death"] = "US_roe_death_small";

	//random redshirt stuff
	level.scr_sound["redshirt"]["plugged_ya"]	=	prefix + "019A" + p;
	
	//ANIMS//
	
	//generic stair running anim
	level.scr_anim["polonsky"][ "stairs_up" ]							= %ai_staircase_run_up_v1;
	level.scr_anim["polonsky"][ "stairs_down" ]						= %ai_staircase_run_down_v1;
	level.scr_anim["sarge"][ "stairs_up" ]							= %ai_staircase_run_up_v1;
	level.scr_anim["sarge"][ "stairs_down" ]						= %ai_staircase_run_down_v1;
	level.scr_anim["generic"][ "stairs_up" ]							= %ai_staircase_run_up_v1;
	level.scr_anim["generic"][ "stairs_down" ]						= %ai_staircase_run_down_v1;
	
	level.scr_sound["redshirt"]["cmon"] = "Oki3_SatchelSoldier_00";
	level.scr_sound["redshirt"]["hurry"] = "Oki3_SatchelSoldier_01";
	
	//guys run to the supply drop	
 	level.scr_anim["sarge"]["supply_in"]		=  %ch_oki3_snipershot_guy1_in;
 	level.scr_anim["sarge"]["supply_loop"][0] 	=	%ch_oki3_snipershot_guy1_loop;
 	level.scr_anim["sarge"]["supply_out"]		=  %ch_oki3_snipershot_guy1_out;
 	
 	level.scr_anim["pawn"]["supply_in"]			=  %ch_oki3_snipershot_guy2_in;
 	level.scr_anim["pawn"]["supply_loop"][0] 	=	%ch_oki3_snipershot_guy2_loop;
 	level.scr_anim["pawn"]["supply_out"]		=  %ch_oki3_snipershot_guy2_out;
 	
 	level.scr_anim["polonsky"]["supply_in"]			=  %ch_oki3_snipershot_guy3_in;
 	level.scr_anim["polonsky"]["supply_loop"][0] 	=	%ch_oki3_snipershot_guy3_loop;
 	level.scr_anim["polonsky"]["supply_out"]		=  %ch_oki3_snipershot_guy3_out;
	
//
//	level.scr_sound["sarge"]["here_come"]			= "print:Get to that bunker now!";
//	level.scr_sound["sarge"]["ambush"]				=	"print:Ambush! They're charging us! Stand your ground Marines!";
//	level.scr_sound["sarge"]["get_moving"] 		= "print:Get moving!";
//	level.scr_sound["sarge"]["supplies_secured"] = "print:Good job!";
//	level.scr_sound["sarge"]["take_ammo"] = "print:Take some ammo from the supply drop";
//	level.scr_sound["sarge"]["use_airstrike"] = "print:Use the air support to destroy the buildings";
//	

	//level.scr_sound["sarge"]["meet_squad"] = "print:Listen up, there's another squad up ahead waiting for us, lets move!";
	//level.scr_sound["polonsky"]["sarge_killed"]	=	"print:They got Sarge! Those bastards! Nooooooooooooooooooooo!";
	//
	//level.scr_sound["redshirt"]["getting_killed0"]	=	"print:Damnit we're getting murdered out here!";
	//level.scr_sound["redshirt"]["getting_killed1"]	=	"print:They're killin' us!";
	//level.scr_sound["redshirt"]["getting_killed2"]	=	"print:I don't think we can hold em much longer!";	
	//level.scr_sound["sarge"]["meet_by_wall"] = "print:Ok guys, lets secure those supply drops. Polanski, players, come with me. The rest of you split up and secure the other drops.";
	//level.scr_anim["sarge"]["meet_by_wall"] = %Ch_oki3_regroup_sarge_order;
	//level.scr_sound["sarge"]["charge_castle"] = "print:Go!";	


	
	//level.scr_sound["sarge"]["get_radio"] = "print:Cover me! I see a radio on that guy, I'm going to go get it, maybe we can use it";

	//level.scr_sound["sarge"]["radio_found"] = "print:Ok, I've got the radio, i'm coming back now";
	//level.scr_anim["sarge"]["radio_found"]= %ch_supplydrop_guy1_pickup;
	
	//level.scr_sound["polonsky"]["coming_from_north"] = "print:They're coming from the north buildings!";
	//level.scr_sound["polonsky"]["coming_from_south"] = "print:Damnit, now they're coming from the south!";
	
	//level.scr_sound["polonsky"]["use_airsupport"] = "print:Use air support to target the north buildings!";
	//level.scr_sound["polonsky"]["support_used"] = "print:Great job, they won't be coming out of there any longer";
	//level.scr_sound["polonsky"]["target_castle"] = "print:Get some air support on the main castle soldier!";
	//level.scr_sound["polonsky"]["target_castle_1"] = "print:Shit, we need more firepower! Call another airstrike on the castle!";
	//level.scr_sound["polonsky"]["target_castle_nag"] = "print:Call another airstrike on the castle!";
	//level.scr_sound["polonsky"]["target_castle_2"] = "print:Damnit! One more airstrike ought to do it!";
	
	//polonsky finds the tunnel entrance
	//level.scr_sound["polonsky"]["tunnel"] = "print:Hey Guys! Check this out, looks like another damn tunnel. Get down there and make sure it's all clear.";
	level.scr_anim["polonsky"]["tunnel"] = %ch_oki3_tunnel_discover;
	
	level.scr_anim["redshirt"]["get_into_bunker"][0] = %ch_oki3_waving;
	level.scr_anim["redshirt"]["bunker_death"] = %ch_oki3_waving_death;
		
	
	//japanese are faking their surrender	
	level.scr_anim["surrender_1"]["surrender_loop"][0] = %ch_oki3_outro_japanese1_loop;
	level.scr_anim["surrender_2"]["surrender_loop"][0] = %ch_oki3_outro_japanese2_loop;
	level.scr_anim["surrender_3"]["surrender_loop"][0] = %ch_oki3_outro_japanese3_loop;
	level.scr_anim["surrender_1"]["fake_surrender"] = %ch_oki3_outro_japanese1;
	level.scr_anim["surrender_2"]["fake_surrender"] = %ch_oki3_outro_japanese2;
	level.scr_anim["surrender_3"]["fake_surrender"] = %ch_oki3_outro_japanese3;
	level.scr_anim["surrender_1"]["fake_surrender_death"] = %ch_oki3_outro_japanese1_dead;
	level.scr_anim["surrender_2"]["fake_surrender_death"] = %ch_oki3_outro_japanese2_dead;
	level.scr_anim["surrender_3"]["fake_surrender_death"] = %ch_oki3_outro_japanese3_dead;
	level.scr_anim["sarge"]["fake_surrender"] = %ch_oki3_outro_roeabuck;
	level.scr_anim["sarge"]["fake_surrender_death"] = %ch_oki3_outro_roeabuck_dead;
	level.scr_anim["sarge"]["fake_surrender_trans"] = %ch_oki3_outro_roeabuck_saved;
	level.scr_anim["polonsky"]["fake_surrender"] = %ch_oki3_outro_polanski;	
	level.scr_anim["polonsky"]["fake_surrender_trans"] = %ch_oki3_outro_polanski_saved; //Glocke: New animation for transitioning polanski to Roebuck's corpse
	level.scr_anim["polonsky"]["fake_surrender_death"] = %ch_oki3_outro_polanski_dead;
	addNotetrack_customFunction("sarge","explosion",maps\oki3_courtyard::surrender_death,"fake_surrender");
	addNotetrack_customFunction("surrender_1","weapons_ready",maps\oki3_courtyard::handle_fake_surrender,"fake_surrender");
	addNotetrack_customFunction("polonsky","detach_gun",::detach_gun,"fake_surrender");
	addNotetrack_customFunction("polonsky","attach_gun",::attach_gun,"fake_surrender");
	addNotetrack_customFunction("surrender_1","i_am_dead",::kill_japanese1_guy,"fake_surrender");

	
	
	addNotetrack_dialogue("sarge","dialog","fake_surrender","Oki3_IGD_047A_ROEB");
	addNotetrack_dialogue("sarge","dialog","fake_surrender","Oki3_IGD_256A_ROEB");
	addNotetrack_dialogue("sarge","dialog","fake_surrender","Oki3_IGD_257A_ROEB");
	addNotetrack_dialogue("sarge","dialog","fake_surrender","Oki3_IGD_049A_ROEB");
	
	addNotetrack_dialogue("polonsky","dialog","fake_surrender","Oki3_IGD_258A_POLO");
	addNotetrack_dialogue("polonsky","dialog","fake_surrender","Oki3_IGD_262A_POLO");
	addNotetrack_dialogue("polonsky","dialog","fake_surrender","Oki3_IGD_263A_POLO");
	
	addNotetrack_dialogue("polonsky","dialog","fake_surrender","Oki3_IGD_300A_POLO");
	addNotetrack_dialogue("polonsky","dialog","fake_surrender","Oki3_IGD_301A_POLO");
	
	
	//grass guys
	level.scr_anim["bunkers"]["prone_anim_fast"] 				= %ch_grass_prone2run_fast;
	level.scr_anim["bunkers"]["prone_anim_fast_b"] 			= %ch_grass_prone2run_fast_b;
		
	//japanese in underground tunnel event 1
	level.scr_anim["table_guy1"]["arguing"][0] = %ch_oki3_tableguys_guy1_loop;//%ch_makinraid_map_b_guy2;
	level.scr_anim["table_guy2"]["arguing"][0] = %ch_oki3_tableguys_guy2_loop;//%ch_makinraid_map_b_guy3;
	level.scr_anim["table_guy3"]["arguing"][0] = %ch_oki3_tableguys_guy3_loop;//%ch_makinraid_map_b_guy4;
	level.scr_anim["table_guy4"]["arguing"][0] = %ch_oki3_tableguys_guy4_loop;//%ch_makinraid_map_b_guy4;
	level.scr_anim["tunnel_guy5"]["telescope"][0] = %Ch_oki3_telescope_loop;
	
	level.scr_anim["table_guy1"]["react"] = %ch_oki3_tableguys_guy1;
	level.scr_anim["table_guy2"]["react"] = %ch_oki3_tableguys_guy2;
	level.scr_anim["table_guy3"]["react"] = %ch_oki3_tableguys_guy3;
	level.scr_anim["table_guy4"]["react"] = %ch_oki3_tableguys_guy4;
	level.scr_anim["tunnel_guy5"]["react"] = %Ch_oki3_telescope;	
	addNotetrack_customFunction("table_guy1", "explosion", ::tunnel_shake, "arguing");
	
	
	// bonzai run cycles
	level.scr_anim["banzai"]["sprint_a"]							= %ai_bonzai_sprint_a;
	level.scr_anim["banzai"]["sprint_b"]							= %ai_bonzai_sprint_b;
	level.scr_anim["banzai"]["sprint_c"]							= %ai_bonzai_sprint_c;
	
	level.scr_anim["banzai2"]["sprint_a"]							= %ai_bonzai_sprint_a;
	level.scr_anim["banzai2"]["sprint_b"]							= %ai_bonzai_sprint_b;
	level.scr_anim["banzai2"]["sprint_c"]							= %ai_bonzai_sprint_c;
	
	
	//guys on the hill getting supplies
	level.scr_anim["redshirt"]["gather_supplies"][0] = %ch_supplydrop_guy1_pickup;
	
	
	level.scr_anim["sarge"]["door_kick3"]					= %door_kick_in;
	addNotetrack_sound("sarge", "kick", "door_kick3", "wood_door_kick");
	addNotetrack_customFunction("sarge", "kick", maps\oki3::kick_mortar_boards, "door_kick3");
	
	level.scr_anim["sarge"]["door_kick5"]					= %ch_berlin3b_door_bash;//%door_kick_in;
	addNotetrack_sound("sarge", "bash", "door_kick5", "wood_door_kick");
	addNotetrack_customFunction("sarge", "bash", maps\oki3::shoulder_mortar_boards, "door_kick5");
	
	
	
		//set up sarge kicking the door in the planters area
	level.scr_anim["sarge"]["door_kick4"]					= %ch_berlin3b_door_bash;//%door_kick_in;
	addNotetrack_sound("sarge", "bash", "door_kick4", "wood_door_kick");
	addNotetrack_customFunction("sarge", "bash", maps\oki3::shoulder_mortar_door, "door_kick4");
	
	
	
	//set up sarge kicking the door in the planters area
	level.scr_anim["sarge"]["door_kick"]					= %ch_berlin3b_door_bash;//%door_kick_in;
	addNotetrack_sound("sarge", "bash", "door_kick", "wood_door_kick");
	addNotetrack_customFunction("sarge", "bash", maps\oki3::open_planter_door, "door_kick");
	
	//set up sarge kicking the door in the planters area
	level.scr_anim["sarge"]["door_kick2"]					= %ch_berlin3b_door_bash_short;//door_kick_in;
	addNotetrack_sound("sarge", "door_hit", "door_kick2", "wood_door_kick");
	addNotetrack_customFunction("sarge", "door_hit", maps\oki3_courtyard::open_courtyard_door, "door_kick2");
		
	//spiderhole guy gets owned
	level.scr_anim["bayonet_guy1"]["flipover"] = %ch_bayonet_flipover_guy1;
	level.scr_anim["bayonet_guy2"]["flipover"] = %ch_bayonet_flipover_guy2;
	
	//marine gets the stabbins
	level.scr_anim["jumpin_guy1"]["jumpin"] = %ch_bayonet_jumpin_guy1;
	level.scr_anim["jumpin_guy2"]["jumpin"] = %ch_bayonet_jumpin_guy2;
	
	level.scr_anim["ambush_staber"]["ambush_stab"] = %ch_oki3_first_spider_guy2;
	level.scr_anim["ambush_stabee"]["ambush_stab"] = %ch_oki3_first_spider_guy1;
	level.scr_anim["ambush_stabee"]["ambush_loop"][0] = %ch_oki3_first_spider_guy1_loop;	
	addNotetrack_customfunction("ambush_staber","now_killable",::staber_canbe_killed,"ambush_stab");
	addNotetrack_customfunction("ambush_staber","not_killable",::staber_cantbe_killed,"ambush_stab");
		
		
	//melee battle
	level.scr_anim["jpn"]["fight"] = %ch_berlin1_E3vignette3_german;	// German dies
	level.scr_anim["us"]["fight"] = %ch_berlin1_E3vignette3_russian;
	level.scr_anim["jpn"]["fight_death"] = %ch_berlin1_E3vignette3_german_death;
	addNotetrack_customFunction("jpn", "kill_german", ::kill_vig_guy, "fight");
	
	
	//patrol stuffs
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;
	
	
	//satchel thrower guy 
	level.scr_anim["redshirt"]["satchel_wait"][0] = %ch_oki3_satchel_waiting;
	
	level.scr_anim["redshirt"]["satchel_throw"] = %ch_oki3_satchel_throw;
	//level.scr_sound["redshirt"]["satchel_throw"] = "print:Stand back , i'm gonna make sure those bastards can't use that tunnel again";
	addnotetrack_customfunction("redshirt","attach_bag",::attach_satchel,"satchel_wait");
	addnotetrack_customfunction("redshirt","detach_bag",::detach_satchel,"satchel_throw");
	
	
	//feigning death dudes
	level.scr_anim["feign_guy1"]["feign"][0] 	= %ch_makinraid_feigning_death_jap01_dead;
	level.scr_anim["feign_guy1"]["death"] 		= %ch_makinraid_feigning_death_jap01_die;
	level.scr_anim["feign_guy1"]["getup"] 		= %ch_makinraid_feigning_death_jap01_getup;

	level.scr_anim["feign_guy2"]["feign"][0] 	= %ch_makinraid_feigning_death_jap04_dead;
	level.scr_anim["feign_guy2"]["death"] 		= %ch_makinraid_feigning_death_jap04_die;
	level.scr_anim["feign_guy2"]["getup"] 		= %ch_makinraid_feigning_death_jap04_getup;
	
	level.scr_anim["feign_guy3"]["feign"][0] 	= %ch_makinraid_feigning_death_jap01_dead;
	level.scr_anim["feign_guy3"]["death"] 		= %ch_makinraid_feigning_death_jap01_die;
	level.scr_anim["feign_guy3"]["getup"] 		= %ch_makinraid_feigning_death_jap01_getup;
	
	level.scr_anim["feign_guy4"]["feign"][0] 	= %ch_makinraid_feigning_death_jap04_dead;
	level.scr_anim["feign_guy4"]["death"] 		= %ch_makinraid_feigning_death_jap04_die;
	level.scr_anim["feign_guy4"]["getup"] 		= %ch_makinraid_feigning_death_jap04_getup;
	
	level.scr_anim["feign_guy5"]["feign"][0] 	= %ch_makinraid_feigning_death_jap01_dead;
	level.scr_anim["feign_guy5"]["death"] 		= %ch_makinraid_feigning_death_jap01_die;
	level.scr_anim["feign_guy5"]["getup"] 		= %ch_makinraid_feigning_death_jap01_getup;
	
	level.scr_anim["feign_guy6"]["feign"][0] 	= %ch_makinraid_feigning_death_jap04_dead;
	level.scr_anim["feign_guy6"]["death"] 		= %ch_makinraid_feigning_death_jap04_die;
	level.scr_anim["feign_guy6"]["getup"] 		= %ch_makinraid_feigning_death_jap04_getup;


	level.scr_anim["polonsky"]["outro2"] = %ch_oki3_outro2_polanski;
	level.scr_anim["redshirt1"]["outro2"] = %ch_oki3_outro2_redshirt1;
	level.scr_anim["redshirt2"]["outro2"] = %ch_oki3_outro2_redshirt2;
	level.scr_anim["sarge"]["outro2"] = %ch_oki3_outro2_roeabuck;
	addNotetrack_customfunction("polonsky","attach_tag",::attach_dogtag,"outro2");
	addNotetrack_customFunction("polonsky","fade_out",::fade_outro,"outro2");
	
	addNotetrack_dialogue("polonsky","dialog","outro2","us_loadingmovie_oki3_00b");
	addNotetrack_dialogue("polonsky","dialog","outro2","us_loadingmovie_oki3_01b");
	addNotetrack_dialogue("polonsky","dialog","outro2","us_loadingmovie_oki3_02b");
	addNotetrack_dialogue("polonsky","dialog","outro2","us_loadingmovie_oki3_04b");
	addNotetrack_dialogue("polonsky","dialog","outro2","us_loadingmovie_oki3_05b");

	
	//polonsky opens the tunnel entrance
	level.scr_anim["polonsky"]["find_tunnel"] = %ch_oki3_polonski_trap_in;
	level.scr_anim["polonsky"]["open_tunnel"][0] =%ch_oki3_polonski_trap_loop;
	level.scr_anim["polonsky"]["close_tunnel"] =%ch_oki3_polonski_trap_out;
	addNotetrack_customFunction("polonsky", "attach_door", ::attach_tunnel_lid, "find_tunnel");
	addNotetrack_customFunction("polonsky", "detach_door", ::detach_tunnel_lid, "find_tunnel");
	
	level.scr_anim["sarge"]["shoulder1"] = %ch_berlin3b_door_bash_short;
	level.scr_anim["sarge"]["shoulder2"] = %ch_berlin3b_door_bash;	
	
//	Waiting for Scripter	Oki3_IGD_600A_JAS2	Oki3_IGD_600A_JAS2	JAS2 (Japanese Soldier 2)	"Please don't shoot, we will surrender!"	IN JAPANESE	yes	yes			// ""Please don't shoot, we will surrender!""\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_600A_JAS2";
//	Waiting for Scripter	Oki3_IGD_601A_JAS2	Oki3_IGD_601A_JAS2	JAS2 (Japanese Soldier 2)	"Please!"	IN JAPANESE	yes	yes			// ""Please!""\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_601A_JAS2";
//	Waiting for Scripter	Oki3_IGD_602A_JAS2	Oki3_IGD_602A_JAS2	JAS2 (Japanese Soldier 2)	"Please!"	IN JAPANESE	yes	yes			// ""Please!""\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_602A_JAS2";
//	Waiting for Scripter	Oki3_IGD_603A_JAS2	Oki3_IGD_603A_JAS2	JAS2 (Japanese Soldier 2)	"Don't fire!'	IN JAPANESE	yes	yes			// ""Don't fire!'"\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_603A_JAS2";
//	Waiting for Scripter	Oki3_IGD_604A_JAS2	Oki3_IGD_604A_JAS2	JAS2 (Japanese Soldier 2)	"Don't fire!'	IN JAPANESE	yes	yes			// ""Don't fire!'"\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_604A_JAS2";
//	Waiting for Scripter	Oki3_IGD_605A_JAS2	Oki3_IGD_605A_JAS2	JAS2 (Japanese Soldier 2)	"Don't fire!'	IN JAPANESE	yes	yes			// ""Don't fire!'"\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_605A_JAS2";
//	Waiting for Scripter	Oki3_IGD_606A_JAS2	Oki3_IGD_606A_JAS2	JAS2 (Japanese Soldier 2)	"Don't fire!'	IN JAPANESE	yes	yes			// ""Don't fire!'"\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_606A_JAS2";
//	Waiting for Scripter	Oki3_IGD_607A_JAS2	Oki3_IGD_607A_JAS2	JAS2 (Japanese Soldier 2)	"We'll surrender!"	IN JAPANESE	yes	yes			// ""We'll surrender!""\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_607A_JAS2";
//	Waiting for Scripter	Oki3_IGD_608A_JAS2	Oki3_IGD_608A_JAS2	JAS2 (Japanese Soldier 2)	"We'll surrender!"	IN JAPANESE	yes	yes			// ""We'll surrender!""\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_608A_JAS2";
//	Waiting for Scripter	Oki3_IGD_609A_JAS2	Oki3_IGD_609A_JAS2	JAS2 (Japanese Soldier 2)	"We'll surrender!"	IN JAPANESE	yes	yes			// ""We'll surrender!""\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_609A_JAS2";
//	Waiting for Scripter	Oki3_IGD_610A_JAS2	Oki3_IGD_610A_JAS2	JAS2 (Japanese Soldier 2)	"We'll surrender!"	IN JAPANESE	yes	yes			// ""We'll surrender!""\level.scr_sound["jas2 (japanese soldier 2)"]["REFERENCE"] = "Oki3_IGD_610A_JAS2";

// ""Please don't shoot, we will surrender!""
level.scr_sound["surrender_2"]["dont_shoot0"] = "Oki3_IGD_600A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot1"] = "Oki3_IGD_601A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot2"] = "Oki3_IGD_602A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot3"] = "Oki3_IGD_603A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot4"] = "Oki3_IGD_604A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot5"] = "Oki3_IGD_605A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot6"] = "Oki3_IGD_606A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot7"] = "Oki3_IGD_607A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot8"] = "Oki3_IGD_608A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot9"] = "Oki3_IGD_609A_JAS2";
level.scr_sound["surrender_2"]["dont_shoot9"] = "Oki3_IGD_610A_JAS2";

//japanese guys in tunnel
// "contact confirmed,"
level.scr_sound["table_guy2"]["contact"] = "Oki3_IGD_900A_JAS2";
// "??????????????????????"
level.scr_sound["table_guy1"]["good"] = "Oki3_IGD_901A_JAS1";
// "hay"
level.scr_sound["table_guy1"]["hay"] = "Oki3_IGD_902A_JAS2";

//“3rd battery to observation post six. Requesting damage report and new firing coordinates.”
level.scr_sound["table_guy3"]["3rdbattery"] = "Oki3_IGD_903A_JAS3";
// "???"
level.scr_sound["table_guy3"]["kurma"] = "Oki3_IGD_905A_JAS3";
// "????????????????????????????????????"
level.scr_sound["table_guy3"]["continue"] = "Oki3_IGD_906A_JAS3";


//anim on corpse by the collectible
level.scr_anim["collectible_corpse"]["death_loop"] = %ch_oki3_collectible;

//oon noooooes! someone died
level.scr_anim["sarge"]["who_died"] = %ch_oki3_guardian_angel;
level.scr_anim["polonsky"]["who_died"] = %ch_oki3_guardian_angel;

addNotetrack_dialogue("sarge","dialog","who_died","Oki3_IGD_325A_ROEB");
addNotetrack_dialogue("sarge","dialog","who_died","Oki3_IGD_326A_ROEB");

addNotetrack_dialogue("polonsky","dialog","who_died","Oki3_IGD_300A_POLO");
addNotetrack_dialogue("polonsky","dialog","who_died","Oki3_IGD_301A_POLO");

// "Hold your fire."
level.scr_sound["sarge"]["hold_fire"] = "Oki3_IGD_046A_ROEB";
// "Shit!"
level.scr_sound["polonsky"]["shit"] = "Oki3_IGD_048A_POLO";

level.scr_sound["sarge"]["00b"] = "us_loadingmovie_oki3_00b";
level.scr_sound["sarge"]["01b"] = "us_loadingmovie_oki3_01b";
level.scr_sound["sarge"]["02b"] = "us_loadingmovie_oki3_02b";
level.scr_sound["sarge"]["03c"] = "us_loadingmovie_oki3_03c";
level.scr_sound["sarge"]["04b"] = "us_loadingmovie_oki3_04b";
level.scr_sound["sarge"]["05b"] = "us_loadingmovie_oki3_05b";


level.scr_sound["polonsky"]["00b"] = "us_loadingmovie_oki3_00b";
level.scr_sound["polonsky"]["01b"] = "us_loadingmovie_oki3_01b";
level.scr_sound["polonsky"]["02b"] = "us_loadingmovie_oki3_02b";
level.scr_sound["polonsky"]["03c"] = "us_loadingmovie_oki3_03c";
level.scr_sound["polonsky"]["04b"] = "us_loadingmovie_oki3_04b";
level.scr_sound["polonsky"]["05b"] = "us_loadingmovie_oki3_05b";



}
	
#using_animtree( "spiderhole_model" );
init_spiderhole_lid_anims()
{
	PrecacheModel( "tag_origin_animate" ); // Used to link the spiderhole lid
	level.scr_animtree["spiderhole_lid"] = #animtree;
	level.scr_anim["spiderhole_lid"]["jump_out"] = %o_spiderhole_jump_out_lid;
	level.scr_anim["spiderhole_lid"]["stumble_out"] = %o_spiderhole_stumble_out_lid;
	level.scr_anim["spiderhole_lid"]["grenade_toss"] = %o_spiderhole_grenade_toss_lid;
	level.scr_anim["spiderhole_lid"]["gun_spray"] = %o_spiderhole_gun_spray_lid;
	level.scr_anim["spiderhole_lid"]["idle"] = %o_spiderhole_idle_lid;
	level.scr_anim["spiderhole_lid"]["crouch2stand"] =%o_spiderhole_idle_lid;
	level.scr_anim["spiderhole_lid"]["jump_attack"] = %o_spiderhole_jump_attack_lid;
}

#using_animtree( "generic_human" );
init_spiderhole_anims()
{
	level.scr_anim["spiderhole"]["sprint"][0] = %ai_bonzai_sprint_a;
	level.scr_anim["spiderhole"]["sprint"][1] = %ai_bonzai_sprint_b;
	level.scr_anim["spiderhole"]["sprint"][2] = %ai_bonzai_sprint_c;
	
	level.scr_anim["spiderhole"]["jump_out"] = %ai_spiderhole_jump_out;
	level.scr_anim["spiderhole"]["stumble_out"] = %ai_spiderhole_stumble_out;
	level.scr_anim["spiderhole"]["grenade_toss"] = %ai_spiderhole_grenade_toss;
	level.scr_anim["spiderhole"]["gun_spray"] = %ai_spiderhole_gun_spray;
	level.scr_anim["spiderhole"]["crouch2stand"] = %crouch2stand;
	level.scr_anim["spiderhole"]["jump_attack"] =  %ai_spiderhole_jump_attack;
	level.scr_anim["spiderhole"]["spiderhole_idle_crouch"][0] = %ai_spiderhole_idle;
}	
	
	
#using_animtree ("supply_drop");
setup_supply_drop_anims()
{
		
	//supply drop anims
	level.scr_anim["drop"]["drop"]							= %o_supplydrop_loop;
	level.scr_anim["drop"]["landing"]					= %o_supplydrop_landing;
	level.scr_anim["drop"]["landingb"] 				= %o_supplydrop_landingB;
	
	level.scr_anim["drop1"]["drop"]							= %o_supplydrop_loop;
	level.scr_anim["drop1"]["landing"]					= %o_supplydrop_landing;
	level.scr_anim["drop1"]["landingb"] 				= %o_supplydrop_landingB;
	
}

#using_animtree ("generic_human");
banzai_run_anim_setup()
{
		self endon("death");

		banzai_runs = 3;
		num = randomint(banzai_runs);
		
		anim_string = undefined;
		the_anim 		= undefined;
		
		if (num == 0)
		{
			the_anim = %ai_bonzai_sprint_a;
			anim_string = "sprint_a";
		}
		else if (num == 1)
		{
			the_anim = %ai_bonzai_sprint_b;
			anim_string = "sprint_b";
		}
		else if (num == 2)
		{
			the_anim = %ai_bonzai_sprint_c;
			anim_string = "sprint_c";
		}
		else
		{
			the_anim = %ai_bonzai_sprint_a;
			anim_string = "sprint_a";		
		}
		
		//only set up banzai behavior on 85% of the guys
		if (isalive(self) )
		{
				//self.animname = "banzai";
				self.targetname = "banzai_guy";
				self.meleeRange = 1024;
				self.meleeRangeSq = 1024*1024;
				self.goalradius = 64;
				//self.a.combatrunanim = the_anim;
				//self.run_combatanim =	the_anim;
				//self.preCombatRunEnabled = true;
				self.pathenemyFightdist = 128;
				self.pathenemyLookahead = 128;
				self setgoalentity( get_closest_player(self.origin) );
				self thread charge_at_players();
		}
}

#using_animtree("generic_human");
init_anims()
{
	

}

// Kill the guy who dies in this vignette
kill_vig_guy(guy)
{
	if(isDefined(guy) && isAlive(guy))
	{
		guy.deathanim = level.scr_anim["jpn"]["fight_death"];
		if(isDefined( guy.magic_bullet_shield))
		{
			guy stop_magic_bullet_shield();
		}
		guy doDamage(guy.health + 25, (0,180,48));
	}
}


//flappy curtain sweetness
#using_animtree( "oki3_models" ); 
event1_mg_tarp()
{
	level.scr_animtree["event1_mg_curtains"]			= #animtree;
	level.scr_anim["event1_mg_curtains"]["intro"]		= %o_clothblinders_flap_intro;
	level.scr_anim["event1_mg_curtains"]["loop"]		= %o_clothblinders_flap_loop;
	level.scr_anim["event1_mg_curtains"]["outro"]		= %o_clothblinders_flap_outro;
}


#using_animtree("oki3_models");
event4_castle_fall()
{
	precachemodel("anim_okinawa_castlefront");
	level.scr_animtree["castle"]			= #animtree;
	level.scr_anim["castle"]["front_fall"]		= %o_oki3_castlefront;	
	level.scr_sound["castle"]["front_fall"] = "courtyard_building_collapse";
}


event2_mortarhut_explode()
{
	
	PrecacheModel( "anim_okinawa_mortarpit_bunker" );

	level.scr_animtree["mortarpit_bunker"] 				= #animtree; 	
	level.scr_model["mortarpit_bunker"] 				= "anim_okinawa_mortarpit_bunker"; 
	level.scr_anim["mortarpit_bunker"]["explode"]	 	= %o_oki3_mortarpit_bunker;	
	
	
}

tunnel_shake(guy)
{
	earthquake(randomfloatrange(.45,.55),randomfloatrange(1.5,3),(3462.5, 2579.5, -822.3),1024);
	playsoundatposition("mortar_dirt",(3462.5, 2579.5, -822.3));
	level notify("explosion","fake");
	exploder(15);
	exploder(16);
	exploder(17);
	exploder(18);
	
	lantern = getent("lantern","script_noteworthy");
	lantern physicslaunch ( lantern.origin, (randomintrange(-20,20),randomintrange(-20,20),randomintrange(-20,20)) );
	
}

#using_animtree( "player" );
init_outro_anim()
{
	level.scr_animtree["player_hands"] = #animtree;
	level.scr_model["player_hands"] = "viewmodel_usa_marine_player";
	level.scr_anim["player_hands"]["outro2"] = %int_oki3_outro2_player;	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//	outro 2: sarge dies, Polonsky gets dog tag
////////////////////////////////////////////////////////////////////////////////////////////////////////

// The AI animation for the intro
oki3_outro_2()
{
	
	if(!isDefined(level.last_hero))
	{
		level.last_hero = level.polonsky;
	}
	
	//define this so that nexmission can clean up the hudelems
	level.nextmission_cleanup = ::clean_up_fadeout_hud;
	level share_screen( get_host(), true );
	
	battlechatter_off("allies");
	battlechatter_off("axis");
	level waittill("do_outro");

	axis = getaiarray("axis");
	array_thread(axis,maps\oki3_util::bloody_death);	
	
	//make it so that nobody can be damaged during the cutscene
	allies = getaiarray("allies");
	for(i=0;i<allies.size;i++)
	{
		allies[i] setcandamage(false);
	}
	
	
	if(isAlive(level.sarge))
	{
		allies = array_remove(allies,level.sarge);
		
	}
	if(isalive(level.polonsky))
	{
		allies = array_remove(allies,level.polonsky);
	}
	
	//friendlies gather aroudn the supply bag
	level thread outro_friendlies_goto_bag(allies);
	
	redshirt1 = spawn_outro_redshirt_1();//allies[randomint(allies.size)];

	//wait a frame before spawning in the next dude;
	wait_network_frame();
	
	redshirt2 = spawn_outro_redshirt_2();
	wait_network_frame();
	sarge = spawn_outro_corpse(level.last_hero);
		
	guys = [];
		
	guys[0] = sarge;
	guys[0].animname = "sarge";
	if(isAlive(level.polonsky))
	{
		guys[1] = level.polonsky;
	}	
	else
	{
		guys[1] = level.sarge;
	}
	guys[1].animname = "polonsky";
	guys[2] = redshirt1;
	
	guys[3] = redshirt2;
	//guys[3].animname = "redshirt2";
	
	anode = getnode("outro_anim", "targetname");

	thread play_outro_on_all_players(anode);
	anode anim_single( guys, "outro2" );
	share_screen( get_host(), false );
	
	setsaveddvar("miniscoreboardhide","1");
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] setclientDvar("miniscoreboardhide","0");
		players[i] setclientDvar("compass","1");
		players[i] SetClientDvar( "hud_showStance", "1" ); 
		players[i] SetClientDvar( "ammoCounterHide", "0" );
	}	
	
	wait(3);
	nextmission();
	
}

//play_outro_dialogue()
//{
//	
//	if(!isDefined(level.last_hero))
//	{
//		level.last_hero = level.polonsky;
//	}
//	wait(1.65);
//	level.last_hero do_dialogue("00b");
//	wait(1);
//	level.last_hero do_dialogue("01b");
//	wait(1);
//	level.last_hero do_dialogue("02b");
//	//level.last_hero do_dialogue("03c");
//	wait(1.5);
//	level.last_hero do_dialogue("04b");
//	wait(1.25);
//	level.last_hero do_dialogue("05b");	
//}

/*------------------------------------
friendlies goto the supply drop during the outro
------------------------------------*/
outro_friendlies_goto_bag(guys)
{	
	for(i=0;i<guys.size;i++)
	{
		//target = getnode("outro_patrol_" + ( i+1),"targetname");
		guys[i].animname = "generic";
		guys[i].target = "outro_patrol_" + ( i+1);
		guys[i] set_generic_run_anim( "patrol_walk", true );
		guys[i] setgoalpos( getnode(guys[i].target,"targetname").origin,getnode(guys[i].target,"targetname").angles);
	}
}


clean_up_fadeout_hud()
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		if(isDefined(players[i].warpblack))
		{
			players[i].warpblack Destroy();
		}
		players[i] setclientdvar("miniscoreboardhide","0");
		players[i] setclientdvar("compass","1");
		players[i] SetClientDvar( "hud_showStance", "1" ); 
		players[i] SetClientDvar( "ammoCounterHide", "0" );
	}	
}




play_outro_on_all_players(anode)
{
	hide_all_player_models();
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread play_outro_on_player( "outro2", anode );
	}
	
	level thread outro_smoke(players[0].origin);		
}


outro_smoke(org)
{
	
	while(1)
	{
		
		playfx(level._effect["outro_smoke"], ( 7767, -5911, 67));
		wait(.5);		
	}	
}

// Handles the spawning/lerping/playing animation of the viewhands
// self is a player
play_outro_on_player( anime, node )
{
	self endon( "disconnect" );

	self disableWeapons();

	self allowprone(false);
	self allowcrouch(false);
	self allowstand(true);
	self setstance("stand");
	self setclientDvar("miniscoreboardhide","1");
	self setclientDvar("compass","0");
	self SetClientDvar( "hud_showStance", "0" ); 
	self SetClientDvar( "ammoCounterHide", "1" );	

	viewhands = spawn_anim_model( "player_hands" );
	//viewhands Hide();

	self.viewhands = viewhands;

	// Set the origin of the viewhands
	org = GetStartOrigin( node.origin, node.angles, level.scr_anim["player_hands"][anime] );
	angles = GetStartAngles( node.origin, node.angles, level.scr_anim["player_hands"][anime] );
	viewhands.origin = org;
	viewhands.angles = angles;
	guy = undefined;
	
	if(isAlive(level.polonsky))
	{
		guy = level.polonsky;
	}	
	else
	{
		guy = level.sarge;
	}
	//guy LinkTo( viewhands, "tag_sync" );
	self PlayerLinkTo( viewhands, "tag_player", 1, 20, 20, 15, 0 );
	
	node anim_single_solo( viewhands, anime );
}

staber_canbe_killed(guy)
{
	level endon("cant_kill");
	
	guy.allowdeath = true;
	guy waittill("death");

	level.stabee stopanimscripted();
	level.stabee.allowdeath = true;
	level.stabee.pacifist = false;
	level.stabee.ignoreall = false;

}

staber_cantbe_killed(guy)
{
	
	level notify("cant_kill");
	guy.allowdeath = false;
	level.stabee dodamage(level.stabee.health + 100,level.stabee.origin);
}


attach_tunnel_lid(guy)
{
	lid = getent("tunnel_lid","targetname");	
	//lid linkto(guy,"tag_inhand");
	//try tag_inhand
	lid linkto(guy,"tag_weapon_left");
	lid notsolid();
	level.polonsky.lid = lid;
	wait(1);
	getent("trap_door_clip","targetname") delete();
	level.sarge do_dialogue("clear_out");
	
	tunnel = getent("tunnel_entered","targetname");
	objective_state(2,"done");
	objective_add(4,"current",&"OKI3_OBJ4_A",tunnel.origin);	
}


detach_tunnel_lid(guy)
{
	lid = getent("tunnel_lid","targetname");
	lid unlink();
}




attach_satchel(guy)
{
	if(!isDefined(guy.satchel_attached))
	{
		guy.satchel = spawn("script_model",guy gettagorigin("tag_weapon_left"));
		guy.satchel setmodel("weapon_satchel_charge");
		guy.satchel linkto(guy,"tag_weapon_left");
		guy.satchel_attached = true;
	}	
}

detach_satchel(guy)
{
	guy.satchel unlink();
	guy.satchel delete();
	
}

attach_dogtag(guy)
{
	players = get_players();
	array_thread(players,::dogtag);	
}

dogtag()
{
	self endon("disconnect");
	
	tag = spawn("script_model",self.viewhands gettagorigin("tag_weapon"));
	tag.angles = self.viewhands gettagangles("tag_weapon");
	tag setmodel("okinawa_dogtag");
	self.viewhands attach("okinawa_dogtag","tag_weapon");	
}


fade_outro(guy)
{
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread hud_fade_to_black(.5);
	}
	
	
}

/*------------------------------------
detach the gun from polonsky when he 
beats on the guy
------------------------------------*/
detach_gun(guy)
{
	position = guy.weaponInfo[ guy.weapon ].position;
	level.polonsky_gun = spawn("script_model", guy gettagorigin("tag_weapon_right"));
	level.polonsky_gun.angles =  guy gettagangles("tag_weapon_right");
	level.polonsky_gun setmodel(getweaponmodel(guy.primaryweapon));
	guy	animscripts\shared::placeWeaponOn( guy.primaryweapon, "none");
	
}

/*------------------------------------
reattach it when he picks it up
------------------------------------*/
attach_gun(guy)
{
	guy	animscripts\shared::placeWeaponOn( guy.primaryweapon, "right");
	level.polonsky_gun delete();
}

/*------------------------------------
kill the japanese attacker on polonsky's last punch
------------------------------------*/
kill_japanese1_guy(guy)
{
	
	guy.allowdeath = true;
	guy dodamage(guy.health + 5,guy.origin);
	
}



/*------------------------------------
either Polonsky's  or Roebuck's dead body
------------------------------------*/
#using_animtree( "generic_human" );
spawn_outro_corpse(guy)
{
	
	anode = getnode("outro_anim", "targetname");
	corpse = spawn( "script_model" , anode.origin );
	
	if(isDefined(guy) && guy == level.polonsky)
	{
		corpse character\char_usa_marine_h_miller::main();
	}
	else
	{
		corpse character\char_usa_marine_h_polonsky::main();
	}
	
	corpse UseAnimTree(#animtree);
	corpse.animname = "sarge";	
	return corpse;
	
}

/*------------------------------------
super sad redshirt dude
------------------------------------*/
#using_animtree( "generic_human" );
spawn_outro_redshirt_1()
{
	
	anode = getnode("outro_anim", "targetname");
	redshirt = spawn( "script_model" , anode.origin );
	redshirt character\char_usa_marine_r_special::main();	
	redshirt UseAnimTree(#animtree);
	redshirt.animname = "redshirt1";
	redshirt.weapon = "m1garand";
	redshirt.secondaryweapon = "m1garand";
	redshirt.sidearm = "m1garand";
	redshirt anim_init_dude();

	return redshirt;
	
}

/*------------------------------------
redshirt guy
------------------------------------*/
#using_animtree( "generic_human" );
spawn_outro_redshirt_2()
{
	
	anode = getnode("outro_anim", "targetname");
	redshirt = spawn( "script_model" , anode.origin );
	redshirt character\char_usa_marine_r_thompson::main();	
	redshirt UseAnimTree(#animtree);
	redshirt.animname = "redshirt2";
	redshirt.weapon = "m1garand";
	redshirt.secondaryweapon = "m1garand";
	redshirt.sidearm = "m1garand";
	redshirt anim_init_dude();

	return redshirt;
	
}

/*------------------------------------
needed for the script_model dudes above
so that they have weapons in their hands
//stolen from the animscripts ;)
------------------------------------*/
anim_init_dude()
{
	
	self.a = spawnStruct();
	self.primaryweapon = self.weapon;
	
	self animscripts\init::initWeapon( self.primaryweapon, "primary" );
	self animscripts\init::initWeapon( self.secondaryweapon, "secondary" );
	self animscripts\init::initWeapon( self.sidearm, "sidearm" );
	
	self.a.weaponPos["left"] = "none";
	self.a.weaponPos["right"] = "none";
	self.a.weaponPos["chest"] = "none";
	self.a.weaponPos["back"] = "none";

	self.lastWeapon = self.weapon;
	self.root_anim = %root;

	self.isSniper = false;	
	self.a.rockets = 3;
	self.a.rocketVisible = true;
	self.a.no_weapon_switch = false;
	self.a.nonstopFire = false;
  self.a.reacquireGuy = false;
	self.a.pose = "stand";
	self.a.movement = "stop";
	self.a.state = "stop";
	self.a.special = "none";
	self.a.gunHand = "none";	// Initialize so that PutGunInHand works properly.
	self.a.PrevPutGunInHandTime = -1;
	animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
	
}