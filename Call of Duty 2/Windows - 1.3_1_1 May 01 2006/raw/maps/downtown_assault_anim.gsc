#include maps\_anim;

#using_animtree("generic_human");
main()
{
	level.scr_anim["generic"]["wave"]	= %run_and_wave;

	// "Our comrades are pinned down up there! We must assist them!!!"
	level.scrsound["generic"]["assist"]			= "downtownassault_rs4_ourcomrades";

//	Comrades - the fascists have recaptured several apartments along this street. 
//  Our duty is to take back these buildings, one by one, and then destroy their ammunition 
//  depot near city hall. Let's go!
	level.scrsound["volsky"]["intro"]			= "downtownassault_volsky_intro";
// "Move in comrades!!! We need to get closer!"	
	level.scrsound["volsky"]["closer"]			= "downtownassault_volsky_movein";

	// "Panzer taaaank!!!"
	level.scrsound["generic"]["panzer"]			= "downtownassault_rs2_panzer";

	// "Those men are all dead!!! This is suicide! We're next!!!"
	level.scrsound["generic"]["suicide"]		= "downtownassault_rs4_thosemen";



	// "Keep it together Pavel! Vasili! Our comrades might have an anti-tank weapon with them! Go find out! We will cover you!!! Move!!!"
//	addNotetrack_dialogue("volsky", "dialog", "find_antitank", "downtownassault_volsky_keeptogether");
	level.scr_face["volsky"]["find_antitank"]	= %downtownassault_vsk_sc04_02_t3_head;
	level.scrsound["volsky"]["find_antitank"]	= "downtownassault_volsky_keeptogether";
	

	// "Hmph. Must be your peasant's luck, Vasili, well done! Now set those explosives on the back of the tank!"
//	addNotetrack_dialogue("volsky", "dialog", "lucky", "downtownassault_volsky_peseantsluck");
	level.scr_face["volsky"]["lucky"]			= %downtownassault_vsk_sc05_01_t1_head;
	level.scrsound["volsky"]["lucky"]			= "downtownassault_volsky_peseantsluck";


	// "These buildings are back in Soviet hands comrades!! Head for that office building and clear it out!!! Keep moving!!!"
	level.scrsound["volsky"]["got_buildings"]	= "downtownassault_volsky_backinsoviethands";

	// "First floor all clear!!!"
	level.scrsound["generic"]["first_floor"]	= "downtownassault_rs4_firstfloor";

	// "Second floor is clear!!!"
	level.scrsound["generic"]["second_floor"]	= "downtownassault_rs3_secondfloorclear";

	// "Da! Building is secure!!!"
	level.scrsound["generic"]["building_secure"]= "downtownassault_rs2_buildingsecure";

	// Vasili! We have comrades down there, trying to breach the German ammo depot! 
	// Fire on the German positions so they can move up and get inside! 
//	addNotetrack_dialogue("volsky", "dialog", "help_comrades", "downtownassault_volsky_depot1");
	level.scr_face["volsky"]["help_comrades"]	= %downtownassault_vsk_sc08_01_t1_head;
	level.scrsound["volsky"]["help_comrades"]	= "downtownassault_volsky_depot1";
	
	//	Vasili! Suppress the Germans in the building on the left side of the road!
	level.scrsound["volsky"]["suppress_germans"]	= "downtownassault_volsky_depot2";
	
	//	The building on the left, Vasili!! Shoot through those windows!!!
	level.scrsound["volsky"]["left_building"]		= "downtownassault_volsky_depot3";

	//	Keep the pressure on the Germans so our men can move up to the depot!
	level.scrsound["volsky"]["keep_pressure"]		= "downtownassault_volsky_depot4";
	
	//	Don’t let up! They must reach the depot!
	level.scrsound["volsky"]["dont_give_up"]		= "downtownassault_volsky_depot5";
	
	

	// "Good day comrade!!!! Leave some for me, ok?!!!!"
	level.scrsound["crazy"]["leave_some"]		= "downtownassault_rcs_goodday";
	// "This one's for my mother!!!!!"
//	addNotetrack_dialogue("crazy", "dialog", "mother", "downtownassault_rcs_formymother");
	level.scr_face["crazy"]["mother"]			= %downtownassault_rcs_sc09_02_t4_head;
	level.scrsound["crazy"]["mother"]			= "downtownassault_rcs_formymother";
	
	
	// "This one's for Valentina!!!!!"
//	addNotetrack_dialogue("crazy", "dialog", "valentina", "downtownassault_rcs_forvalentina");
	level.scr_face["crazy"]["valentina"]		= %downtownassault_rcs_sc09_03_t3_head;
	level.scrsound["crazy"]["valentina"]		= "downtownassault_rcs_forvalentina";
	
	// "That was for my father you fascist son of a bitch!!!!"
//	addNotetrack_dialogue("crazy", "dialog", "father", "downtownassault_rcs_formyfather");
	level.scr_face["crazy"]["father"] 			= %downtownassault_rcs_sc09_05_t4_head;
	level.scrsound["crazy"]["father"] 			= "downtownassault_rcs_formyfather";
	// "HaHaaa!!!!"

	// "That one's for my little sister you butchers!!!!"
	level.scrsound["crazy"]["sister"]			= "downtownassault_rcs_formysister";
	// """And this one's for my dog!!!! 
	// "How you like iiit?!!! AAAAAAAAAAAAA-(boom)"""
	level.scrsound["crazy"]["dog"]				= "downtownassault_rcs_formydog";

	// "Panzer tank!!! Vasili!!! Get away from the window!!! Move!!!"
	level.scrsound["volsky"]["window"]			= "downtownassault_volsky_panzertank";


	// "Vasili! Let's go! We can use your satchel charges to take out that Panzer!"
//	addNotetrack_dialogue("volsky", "dialog", "satchel", "downtownassault_volsky_letsgo");
	level.scr_face["volsky"]["satchel"]			= %downtownassault_vsk_sc11_01_t3_head;
	level.scrsound["volsky"]["satchel"]			= "downtownassault_volsky_letsgo";

	// "Don't try to be a hero, Vasili! We must find a way to attack that Panzer from the side!"
	level.scrsound["volsky"]["attack_side"]		= "downtownassault_volsky_fromtheside";

	// "Vasili! Take cover!!!"
	level.scrsound["volsky"]["take_cover"]		= "downtownassault_volsky_takecover";

	// "This is the quickest way to the city hall comrades! Through here, let's go!!"
//	addNotetrack_dialogue("volsky", "dialog", "cityhall", "downtownassault_volsky_cityhall");
	level.scr_face["volsky"]["cityhall"]		= %downtownassault_vsk_sc14_01_t1_head;
	level.scrsound["volsky"]["cityhall"]		= "downtownassault_volsky_cityhall";
}
	