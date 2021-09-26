#include maps\_anim;
#include maps\_utility;
#using_animtree ("generic_human");
main()
{	
	level.scr_anim["generic"]["wave"]	= %run_and_wave;

	level.scr_anim["wounded_puller"]["start_idle"][0]	= %demolition_trench_beginning_idle;
	level.scr_anim["wounded_puller"]["drag_start"]		= %demolition_trench_tank_dragger;
	level.scr_anim["wounded_puller"]["middle_idle"][0]	= %demolition_trench_middle_idle;
	level.scr_anim["wounded_puller"]["drag_end"]		= %demolition_trench_dragend_idle;
	addNotetrack_dialogue("wounded_puller", "dialog", "drag_end", "demolition_rs4_getdownnn");
	
	level.scr_anim["wounded_puller"]["end_idle"][0]		= %demolition_trench_end_idle;
		
	level.scr_anim["wounded_dragged"]["start_idle"][0]	= %demolition_trench_beginning_wounded;
	level.scr_anim["wounded_dragged"]["drag_start"]		= %demolition_trench_tank_wounded;
	level.scr_anim["wounded_dragged"]["middle_idle"][0]	= %demolition_trench_middle_wounded;
	level.scr_anim["wounded_dragged"]["drag_end"]		= %demolition_trench_dragend_wounded;
	level.scr_anim["wounded_dragged"]["end_idle"][0]	= %demolition_trench_end_wounded;

	level.scr_notetrack["explosives_guy"][0]["notetrack"]		= "pickup tnt";
	level.scr_notetrack["explosives_guy"][0]["attach model"]	= "xmodel/military_tntbomb";
	level.scr_notetrack["explosives_guy"][0]["selftag"]			= "tag_weapon_left";
	
	level.scr_notetrack["explosives_guy"][1]["notetrack"]		= "give tnt";
	level.scr_notetrack["explosives_guy"][1]["detach model"]	= "xmodel/military_tntbomb";
	level.scr_notetrack["explosives_guy"][1]["selftag"]			= "tag_weapon_left";
	
	level.scr_anim["explosives_guy"]["start_idle"][0]	 	= %demolition_hall_door_idle;
	level.scr_anim["explosives_guy"]["start_pos"]		 	= %demolition_hall_door_idle;
	level.scr_anim["explosives_guy"]["planting_idle"][0] 	= %demolition_hall_igotsome_set;
	level.scr_anim["explosives_guy"]["got_some"] 			= %demolition_hall_igotsome;
	level.scr_anim["explosives_guy"]["get_up"] 				= %demolition_hall_igotsome_getup;
	
	level.scr_anim["explosives_guy"]["bomb_left"]			= %demolition_hall_hereyougo_l;
	addNotetrack_dialogue("explosives_guy", "dialog", "bomb_left", "demolition_rs3_mainsupports");
	level.scr_anim["explosives_guy"]["bomb_right"]			= %demolition_hall_hereyougo_r;
	addNotetrack_dialogue("explosives_guy", "dialog", "bomb_right", "demolition_rs3_mainsupports");
	addNotetrack_dialogue("explosives_guy", "dialog", "got_some", "demolition_rs3_gotsometnt");
	addNotetrack_sound("explosives_guy", "throw sound", "got_some", "demolition_chargetoss");


	level.scr_anim["call_guy"]["start_idle"][0]			 	= %demolition_hall_stair_idle; // demolition_hall_stair_idle;
	level.scr_anim["call_guy"]["start_pos"]				 	= %demolition_hall_stair_idle;
	level.scr_anim["call_guy"]["call_idle"][0]			 	= %demolition_hall_shoutidle_stairs; // demolition_hall_stair_idle;
	level.scr_anim["call_guy"]["bring_explosives"]			= %demolition_hall_shout;
	level.scr_anim["call_guy"]["get_some"]					= %demolition_hall_igotsome_receiver;
	level.scr_look["call_guy"]["get_some"]["left"]			= %demolition_hall_receiver_left;
	level.scr_look["call_guy"]["get_some"]["left_angle"]	= -70; //-114;
	level.scr_look["call_guy"]["get_some"]["right"]			= %demolition_hall_receiver_right;
	level.scr_look["call_guy"]["get_some"]["right_angle"]	= 92; // 100;
	addNotetrack_sound("call_guy", "catch sound", "get_some", "demolition_chargecatch");
	
	addNotetrack_dialogue("call_guy", "dialog", "bring_explosives", "demolition_rs4_engineers");
	addNotetrack_dialogue("call_guy", "dialog", "get_some", "demolition_rs1_helpusout");
	addNotetrack_attach("call_guy", "pickup tnt", 	"xmodel/military_tntbomb", "tag_weapon_left");
	addNotetrack_detach("call_guy", "give tnt", 	"xmodel/military_tntbomb", "tag_weapon_left");

	level.scr_anim["question_guy"]	["shout"] 				= %demolition_barricade_question;
	level.scr_anim["question_guy"]	["idle"][0]				= %demolition_barricade_question_idle;
	addNotetrack_dialogue("question_guy", "dialog", "shout", "demolition_rs4_asksurrender");

	level.scr_anim["barricade"]["idle"][0]				 	= %demolition_barricade_idle;
	level.scr_anim["barricade"]["shout"] 					= %demolition_barricade_shout;
	addNotetrack_sound("barricade", "door bang", "shout", "demolition_door_hit");
	
	level.scr_anim["barricade"]["shout_idle"][0]			= %demolition_barricade_shout_idle;
	addNotetrack_dialogue("barricade", "dialog", "shout", "demolition_rs1_barricaded");
	addNotetrack_dialogue("barricade", "dialog2", "shout", "demolition_rs1_howtosurrender");

	level.scr_anim["engineer"]["plant"]						= %demolition_hall_plant_tnt_1;
	level.scr_anim["engineer"]["crouch"]					= %demolition_hall_tntcrouch;
	level.scr_anim["engineer"]["planting_idle"][0]			= %demolition_hall_checktnt;
	level.scr_anim["engineer"]["stand"]						= %demolition_hall_tntgetup;
	level.scr_anim["engineer"]["bomb_left"]					= %demolition_hall_hereyougo_l_other;
	level.scr_anim["engineer"]["bomb_right"]				= %demolition_hall_hereyougo_r_other;
	
	addNotetrack_attach("engineer", "pickup tnt", 	"xmodel/military_tntbomb", "tag_weapon_left");
	addNotetrack_detach("engineer", "stick",	 	"xmodel/military_tntbomb", "tag_weapon_left");
	addNotetrack_detach("engineer", "give tnt",	 	"xmodel/military_tntbomb", "tag_weapon_left");

	addNotetrack_dialogue("engineer", "dialog", "bomb_left", 	"demolition_rs3_mainsupports");
	addNotetrack_dialogue("engineer", "dialog", "bomb_right", 	"demolition_rs3_mainsupports");
	addNotetrack_dialogue("engineer", "dialog", "got_some", 	"demolition_rs3_gotsometnt");
	// demolition team on the way!
	level.scrsound["engineer"]["on_the_way"]				= "demolition_rs3_teamontheway";

	level.scrsound["letlev"][1]["selftag"]			= "tag_weapon_left";


//	It's about damn time you showed up. This way Comrades!
	
	level.scr_anim["trench_guy"]["idle"][0]		= %corner_right_crouch_alertidle;
	level.scr_anim["trench_guy"]["this_way"]	= %demolition_rs4_sc01_01_thisway;
	addNotetrack_dialogue("trench_guy", "dialog", "this_way", "demolition_rs4_damntime");
//	level.scrSound["trench_guy"]["this_way"] = "demolition_rs4_damntime";
	

//	“The Germans are massing for a counter attack! Prepare yourselves Comrades!”
	level.scrSound["warning_guy"]["massing"] = "demolition_rs1_massing";

//	“We are too few, we cannot stay here! They will overwhelm us!”	
	level.scrSound["generic"]["too_few"] = "demolition_rs3_toofew";
	
//	“Stay where you are! We will hold this position until help arrives! The aid station on Solechnaya Street 
//	is counting on us to stop the fascists!”	
	level.scr_anim["commissar"]["stay"] = %demolition_defend_staywhereyouare;
	addNotetrack_dialogue("commissar", "dialog", "stay", "demolition_rs1_countingonus");
//	level.scrSound["commissar"]["stay"] = "demolition_rs1_countingonus";
	
//	“Hold the line comraaades! Do NOT let them pass!”	
	level.scrSound["generic"]["hold_line"] = "demolition_rs4_holdline";
	
	level.scr_anim["commissar"]["idle"][0] = %demolition_defend_idle;
	
//	Steady Comraaaades!!! Wait till they get close!!!	
	level.scr_anim["commissar"]["steady"] = %demolition_defend_steady;
	addNotetrack_dialogue("commissar", "dialog", "steady", "demolition_rs1_waitclose");
//	level.scrSound["commissar"]["steady"] = "demolition_rs1_waitclose";
	
//	Here they cooome!!! Open firrrre!!!!!	
	level.scrSound["generic"]["open_fire"] = "demolition_rs4_heretheycome";
	
//	“They're falling baaack!! Chaaarge!!!”	
	level.scr_anim["commissar"]["charge"] = %demolition_defend_charge_downhill;
	addNotetrack_dialogue("commissar", "dialog", "charge", "demolition_rs1_fallingback");
//	level.scrSound["commissar"]["charge"] = "demolition_rs1_fallingback";
	
//	“For Mother Russiaaa!”	
	level.scrSound["generic"]["for_russia"] = "demolition_rs4_motherrussia";
	
//	“Keep after them, don’t let them get away!!!”	
	level.scrSound["generic"]["keep_after_them"] = "demolition_rs3_keepafterthem";
	



//	Letlev commissar_charge_ready (screaming up and down the line) "Comrades!!!! For the Soviet Union, and for your glorious Motherlaaaand...Get readyyyyy!!!!" 
	level.scrSound["letlev"]["ready"] = "commissar_charge_ready";


//	Letlev commissar_charge_nofallingback (apoplectic) "No falling back! Do not retreat!!!" 
	level.scrSound["letlev"]["no_falling_back"] = "commissar_charge_nofallingback";

//	Letlev commissar_charge_killfascists "Kill the fascists!!!! Show them no mercy!!!" 
	level.scrSound["letlev"]["kill_fascists"] = "commissar_charge_killfascists";

//	Letlev commissar_charge_cowards "Cowards will be executed for dereliction for duty!!!" 
	level.scrSound["letlev"]["cowards_executed"] = "commissar_charge_cowards";

//	Letlev commissar_charge_attack "Attack!!! ATTAAAAACK!!!!" 
	level.scrSound["letlev"]["attack"] = "commissar_charge_attack";

//	Letlev commissar_charge_keepforward "Keep going forward!!!!" 
	level.scrSound["letlev"]["keep_forward"] = "commissar_charge_keepforward";

//	Letlev commissar_charge_movecoward (livid) "Get moving you coward!!!!" 
	level.scrSound["letlev"]["get_moving"] = "commissar_charge_movecoward";

//	Letlev commissar_charge_shootyou "Go! Or I will shoot you myself!!!" 
	level.scrSound["letlev"]["go_or_die"] = "commissar_charge_shootyou";


//	Letlev commissar_charge_chargethose "Charge those enemy positions you fool! Get out there! Move!!!" 
	level.scrSound["letlev"]["charge_enemy"] = "commissar_charge_chargethose";

	/*

	level.scr_anim["commissar"]["line1"]			= (%commissar1_line_31_fullbody);
	level.scr_anim["commissar"]["line2"]			= (%commissar4_line_41_fullbody);
	level.scr_anim["commissar"]["line3"]			= (%commissar1_line_40_fullbody);
	level.scr_anim["commissar"]["line4"]			= (%commissar2_line_51_fullbody);
	level.scr_anim["commissar"]["line5"]			= (%commissar2_line_52_fullbody);
	level.scr_anim["commissar"]["line6"]			= (%commissar3_line_33_fullbody);
	level.scr_anim["commissar"]["line7"]			= (%commissar3_line_49_fullbody);
	level.scr_anim["commissar"]["idle"][0]			= (%commissar4_line_32_fullbody);
	level.scr_anim["commissar"]["idle"][1]			= (%commissar4_line_50_fullbody);
	level.scr_anim["commissar"]["idle"][2]			= (%commissar4_line_51_fullbody);
	level.scr_anim["commissar"]["idle"][3]			= (%commissar4_line_51_fullbody);
	level.scr_anim["commissar"]["idle"][4]			= (%commissar4_line_50_fullbody);
	level.scr_anim["commissar"]["idle"][5]			= (%commissar4_line_32_fullbody);
	*/
	
	// The charges are set, get to a safe distance!			
	level.scrsound["generic"]["safe_distance"] = "demolition_rs4_safedistance";
	// It's about to blow, get clear of the building!!!		
	level.scrsound["generic"]["get_clear"] = 		"demolition_rs1_abouttoblow";
	// Move iiit!!! Ruuun!!!!						
	level.scrsound["generic"]["move_it"] =	 		"demolition_rs4_moveitrun";
	// Let's go, let's go!!! (add embellishment in Russian)		
	level.scrsound["generic"]["lets_go"] =	 		"demolition_rs3_letsgoletsgo";
	// Hurry Comraaades!!						
	level.scrsound["generic"]["hurry_comrades"] = 	"demolition_rs1_hurrycomrades";
	// (coughing from dust, 5 sec)					
	level.scrsound["generic"]["cough1"] =	 		"demolition_rs1_coughing";
	// (coughing from dust, 5 sec)					
	level.scrsound["generic"]["cough2"] = 			"demolition_rs4_coughing";
	// (coughing from dust, 5 sec)					
	level.scrsound["generic"]["cough3"] = 			"demolition_rs3_coughing";

	// 	THAT'S how you negotiate with the fascists, Comrades!!! 		
	level.scrsound["barricade"]["negotiate"] = 		"demolition_rs1_negotiate";

	// Viktor, go with Vasili and report to Major Zubov! The rest of us will secure this area against a counterattack.		
	level.scrsound["generic"]["report"] = 			"demolition_rs1_finalorders";
	// Right away Comrade Lieutenant! Vasili, let's go!		
	level.scrsound["generic"]["right_away"] = 		"demolition_rs4_rightawayletsgo";
	
	level.announcement = [];
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda1";
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda2";
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda3";
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda4";
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda5";
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda6";
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda7";
	level.announcement[level.announcement.size] = "downtownsniper_gplv_propaganda8";
	level.announcement = array_randomize(level.announcement);
}