
#include maps\_anim;
#include maps\ber1_util;
#include maps\_utility;
#include common_scripts\utility;


#using_animtree("generic_human");
main()
{
	
	trainride();
	ruins();
	office();
	streets();
	asylum();
	tankride();

	setup_axis_drone_deaths();
	
	geo_anims();

}



trainride()
{

	level.scr_anim["russian_0"]["train_intro"] = %ch_berlin1_intro_guy02;
	level.scr_anim["russian_1"]["train_intro"] = %ch_berlin1_intro_guy03;
	level.scr_anim["russian_2"]["train_intro"] = %ch_berlin1_intro_guy04;
	level.scr_anim["russian_4"]["train_intro"] = %ch_berlin1_intro_guy06;
	level.scr_anim["russian_6"]["train_intro"] = %ch_berlin1_intro_guy08;
	level.scr_anim["russian_8"]["train_intro"] = %ch_berlin1_intro_guy10;
	level.scr_anim["russian_9"]["train_intro"] = %ch_berlin1_intro_hero01;
	level.scr_anim["russian_10"]["train_intro"] = %ch_berlin1_intro_hero03;
	level.scr_anim["russian_11"]["train_intro"] = %ch_berlin1_intro_hero04;
	level.scr_anim["russian_12"]["train_intro"] = %ch_berlin1_intro_sarge;

	level.scr_anim["russian_0"]["train_intro_exit"] = %ch_berlin1_intro_guy02_run; 
	level.scr_anim["russian_1"]["train_intro_exit"] = %ch_berlin1_intro_guy03_run; 
	level.scr_anim["russian_2"]["train_intro_exit"] = %ch_berlin1_intro_guy04_run; 
	level.scr_anim["russian_4"]["train_intro_exit"] = %ch_berlin1_intro_guy06_run; 
	level.scr_anim["russian_6"]["train_intro_exit"] = %ch_berlin1_intro_guy08_run; 
	level.scr_anim["russian_8"]["train_intro_exit"] = %ch_berlin1_intro_guy10_run; 
	level.scr_anim["russian_9"]["train_intro_exit"] = %ch_berlin1_intro_hero01_run;
	level.scr_anim["russian_10"]["train_intro_exit"] = %ch_berlin1_intro_hero03_run;
	level.scr_anim["russian_11"]["train_intro_exit"] = %ch_berlin1_intro_hero04_run;
	level.scr_anim["russian_12"]["train_intro_exit"] = %ch_berlin1_intro_sarge_run;

	// delayed train guys
	level.scr_anim["russian_3"]["train_intro"] = %ch_berlin1_intro_guy05;
	level.scr_anim["russian_5"]["train_intro"] = %ch_berlin1_intro_guy07;
	level.scr_anim["russian_7"]["train_intro"] = %ch_berlin1_intro_guy09;
	
	level.scr_anim["russian_3"]["train_intro_idle"][0] = %ch_berlin1_intro_guy05_idle;	
	level.scr_anim["russian_5"]["train_intro_idle"][0] = %ch_berlin1_intro_guy07_idle;	
	level.scr_anim["russian_7"]["train_intro_idle"][0] = %ch_berlin1_intro_guy09_idle;	
	
	level.scr_anim["russian_3"]["train_intro_exit"] = %ch_berlin1_intro_guy05_run;
	level.scr_anim["russian_5"]["train_intro_exit"] = %ch_berlin1_intro_guy07_run;
	level.scr_anim["russian_7"]["train_intro_exit"] = %ch_berlin1_intro_guy09_run;
				
	addNotetrack_customFunction( "russian_0", "train_stop", ::train_stopping, "train_intro" );
	addNotetrack_customFunction( "russian_12", "open_train_door", ::open_traincar_door, "train_intro" );


	// for drones
	//////////////
	level.scr_anim["russian0"]["train_intro"] = %ch_berlin1_intro_guy09;
	level.scr_anim["russian1"]["train_intro"] = %ch_berlin1_intro_guy02;
	level.scr_anim["russian2"]["train_intro"] = %ch_berlin1_intro_guy03;
	level.scr_anim["russian3"]["train_intro"] = %ch_berlin1_intro_guy04;
	level.scr_anim["russian4"]["train_intro"] = %ch_berlin1_intro_guy05;
	level.scr_anim["russian5"]["train_intro"] = %ch_berlin1_intro_guy06;
	level.scr_anim["russian6"]["train_intro"] = %ch_berlin1_intro_guy07;

	addNotetrack_customFunction("russian0", "unlink", ::unlink_boxcar_guys, "train_intro");	
	addNotetrack_customFunction("russian1", "unlink", ::unlink_boxcar_guys, "train_intro");
	addNotetrack_customFunction("russian2", "unlink", ::unlink_boxcar_guys, "train_intro");
	addNotetrack_customFunction("russian3", "unlink", ::unlink_boxcar_guys, "train_intro");
	addNotetrack_customFunction("russian4", "unlink", ::unlink_boxcar_guys, "train_intro");
	addNotetrack_customFunction("russian5", "unlink", ::unlink_boxcar_guys, "train_intro");
	addNotetrack_customFunction("russian6", "unlink", ::unlink_boxcar_guys, "train_intro");


	// katyusha operators
	level.scr_anim["truck"]["driver_sit_idle"][0] = %crew_truck_driver_sit_idle;
	level.scr_anim["truck"]["katyusha_idle_1"][0] = %crew_artillery1_shieldleft_idle;

	// waving guys
	level.scr_anim["russian"]["wave1"][0] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave1"][1] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave1"][2] = %ch_berlin1_commissar_whistling;
	level.scr_anim["russian"]["wave1"][3] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave1"][4] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave1"][5] = %ch_berlin1_commissar_waving;
	
	addNotetrack_sound( "russian", "whistle_start", "wave1", "whistle_blow" );
	
	level.scr_anim["russian"]["wave2"][0] = %ch_berlin1_commissar_whistling;
	level.scr_anim["russian"]["wave2"][1] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave2"][2] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave2"][3] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave2"][4] = %ch_berlin1_commissar_waving;
	level.scr_anim["russian"]["wave2"][5] = %ch_berlin1_commissar_waving;
	
	addNotetrack_sound( "russian", "whistle_start", "wave2", "whistle_blow" );
	
	level.scr_anim["russian"]["wave_tank"] = %ch_berlin1_commissar_waving;
	
	
	// train VO
	level.scr_sound["russian_0"]["on_your_feet"] 							= "Ber1_INT_007A_REZN";
	level.scr_sound["russian_0"]["fuhrers_bday"] 							= "Ber1_INT_008A_COMM";
	level.scr_sound["russian_0"]["with_your_bullets"] 						= "Ber1_INT_009A_COMM";
	level.scr_sound["russian_0"]["do_the_same"] 							= "Ber1_INT_010A_COMM";

}



ruins()
{
	
	// ruins VO
	
	level.scr_sound["vo"]["make_russia"] 									= "Ber1_IGD_000A_COMM";
	level.scr_sound["vo"]["charge!!!"] 										= "Ber1_IGD_001A_REZN";
	level.scr_sound["vo"]["keep_moving"] 									= "Ber1_IGD_002A_REZN";

	level.scr_sound["vo"]["move_up_tanks"] 									= "Ber1_IGD_009A_COMM";		
	level.scr_sound["vo"]["use_for_cover"] 									= "Ber1_IGD_010A_REZN";			
	level.scr_sound["vo"]["the_rats"] 										= "Ber1_IGD_003A_REZN";
	level.scr_sound["vo"]["clear_every"] 									= "Ber1_IGD_004A_REZN";
	level.scr_sound["vo"]["they_are_running"] 								= "Ber1_IGD_005A_CHER";
	level.scr_sound["vo"]["of_course"] 										= "Ber1_IGD_006A_REZN";	
	level.scr_sound["vo"]["more_upper_floor"] 								= "Ber1_IGD_007A_REZN";	
	level.scr_sound["vo"]["wipe_them_out"] 									= "Ber1_IGD_008A_REZN";		
	
	level.scr_sound["vo"]["setup_defenses"] 								= "Ber1_IGD_011A_CHER";		
	level.scr_sound["vo"]["stay_in_cover"] 									= "Ber1_IGD_012A_REZN";		
	level.scr_sound["vo"]["tanks_torn_apart"] 								= "Ber1_IGD_013A_REZN";		
	level.scr_sound["vo"]["find_a_better"] 									= "Ber1_IGD_015A_REZN";		
	
	level.scr_sound["vo"]["mg!!!"] 											= "Ber1_IGD_017A_REZN";	
	level.scr_sound["vo"]["panzerschrek!"] 									= "Ber1_IGD_016A_REZN";		
	level.scr_sound["vo"]["keep_fire_on"] 									= "Ber1_IGD_014A_REZN";		
	level.scr_sound["vo"]["they_are_still_holding"] 						= "Ber1_IGD_018A_REZN";		
	level.scr_sound["vo"]["destroy_every_last"] 							= "Ber1_IGD_019A_REZN";		
	level.scr_sound["vo"]["watch_for_panzers"] 								= "Ber1_IGD_020A_REZN";		
	level.scr_sound["vo"]["break_their_line"] 								= "Ber1_IGD_100A_REZN";		
	level.scr_sound["vo"]["concentrate_fire"] 								= "Ber1_IGD_022A_REZN";		
	level.scr_sound["vo"]["they_are_weakening"] 							= "Ber1_IGD_023A_REZN";		
	level.scr_sound["vo"]["finish_them"] 									= "Ber1_IGD_022B_REZN";		
	level.scr_sound["vo"]["quickly_dimitri"] 								= "Ber1_IGD_024A_REZN";		
	level.scr_sound["vo"]["fire_again"] 									= "Ber1_IGD_025A_REZN";		
	level.scr_sound["vo"]["take_it_out"] 									= "Ber1_IGD_026A_REZN";		
	level.scr_sound["vo"]["yes!!!"] 										= "Ber1_IGD_027A_REZN";		
	
	level.scr_sound["vo"]["move_forward"] 									= "Ber1_IGD_028A_COMM";		
	level.scr_sound["vo"]["this_way_into_building"] 						= "Ber1_IGD_029A_REZN";		
	level.scr_sound["vo"]["upstairs"] 										= "Ber1_IGD_030A_REZN";		
	
}


office()
{
	
	addnotetrack_dialogue( "execution_ally_1", "dialog", "execution", "Ber1_IGD_101A_RUR1" );
	addnotetrack_dialogue( "execution_ally_1", "dialog", "execution", "Ber1_IGD_104A_RUR3" );
	addnotetrack_dialogue( "execution_ally_1", "dialog", "execution", "Ber1_IGD_105A_GER1" );
	addnotetrack_dialogue( "execution_ally_1", "dialog", "execution", "Ber1_IGD_106A_GER1" );
	addnotetrack_dialogue( "execution_ally_1", "dialog", "execution", "Ber1_IGD_107A_GER2" );
	addnotetrack_dialogue( "execution_ally_1", "dialog", "execution", "Ber1_IGD_108A_GER2" );
	
	addnotetrack_customfunction( "execution_ally_1", "attach_gun_right", ::holster_weapon_switch_to_sidearm, "execution" ); 
	addnotetrack_customfunction( "execution_ally_1", "detach_gun_right", ::holster_sidearm_switch_to_weapon, "execution" ); 
	
	
	
	level.scr_anim["office"]["crawl_1"] 									= %ch_berlin2_crawl1;         
	level.scr_anim["office"]["crawl_1_death"] 								= %ch_berlin2_crawl1_shot;         
                                                                            
	level.scr_anim["office"]["crawl_2"] 									= %ch_berlin2_crawl2;         
	level.scr_anim["office"]["crawl_2_death"] 								= %ch_berlin2_crawl2_shot;         
	                                                                        
	level.scr_anim["office"]["crawl_3"] 									= %ch_berlin2_crawl3;         
	level.scr_anim["office"]["crawl_3_death"] 								= %ch_berlin2_crawl3_shot; 
	
	level.scr_anim["office"]["crawl_4"] 									= %ch_pel1_crawling_loco_guy1;
	level.scr_anim["office"]["crawl_4_death"] 								= %ch_pel1_crawling_natural_death_guy1;
	
	level.scr_anim["execution_ally_1"]["execution"] 						= %ch_berlin1_execution_captor1;
	level.scr_anim["execution_ally_2"]["execution"] 						= %ch_berlin1_execution_captor2;
	level.scr_anim["execution_axis_1"]["execution"] 						= %ch_berlin1_execution_prisoner1;
	level.scr_anim["execution_axis_2"]["execution"] 						= %ch_berlin1_execution_prisoner2;
	level.scr_anim["execution_axis_3"]["execution"] 						= %ch_berlin1_execution_prisoner3;
	level.scr_anim["execution_axis_4"]["execution"] 						= %ch_berlin1_execution_prisoner4;


	// OFFICE VO

	level.scr_sound["vo"]["there_are_survivors"] 							= "Ber1_IGD_031A_CHER";
	level.scr_sound["vo"]["these_animals"] 									= "Ber1_IGD_032A_COMM";
	level.scr_sound["vo"]["deserve_none"] 									= "Ber1_IGD_033A_COMM";

	level.scr_sound["vo"]["how_are_we_to"] 									= "Ber1_IGD_034A_CHER";	
	level.scr_sound["vo"]["brute_force"] 									= "Ber1_IGD_035A_REZN";	

}



streets()
{
	
	// bookcase push
	/////////////////
	level thread addNotetrack_customFunction( "street", "attach", ::bookcase_push_attach, "bookcase_push" );
	level thread addNotetrack_customFunction( "street", "detach", ::bookcase_push_detach, "bookcase_push" );
	level thread addNotetrack_attach( "street", "attach", "static_berlin_bookshelf_short_ber2", "tag_weapon_left", "bookcase_push" );
	level thread addNotetrack_detach( "street", "detach", "static_berlin_bookshelf_short_ber2", "tag_weapon_left", "bookcase_push" );
	
	level.scr_anim["street"]["bookcase_push"] 								= %ch_holland3_dresser;
	
	level.scr_anim["collectible"]["collectible_loop"][0]					= %ch_ber1_collectible;
	
	
	
	// street VO
	level.scr_sound["vo"]["keep_pushing"] 									= "Ber1_IGD_036A_COMM";
	level.scr_sound["vo"]["panzershrek_fire"] 								= "Ber1_IGD_037A_CHER";
	level.scr_sound["vo"]["deal_with_it"] 									= "Ber1_IGD_038A_REZN";
	level.scr_sound["vo"]["split_up"] 										= "Ber1_IGD_039A_REZN";	
	level.scr_sound["vo"]["rest_of_you"] 									= "Ber1_IGD_040A_REZN";	
	level.scr_sound["vo"]["fight_your_way"] 								= "Ber1_IGD_041A_COMM";	
	level.scr_sound["vo"]["hunt_them_down"] 								= "Ber1_IGD_042A_REZN";	
	
	
}

#using_animtree( "ber1_crows" );
asylum()
{

	level.scr_model["crow"] = "anim_berlin_crow";
	level.scr_animtree["crow"] = #animtree;	

	//Atrium Crows
	level.scr_anim["crow"]["crow1_loop"][0] 						= %o_berlin1_courtyard_crow1_loop;
	level.scr_anim["crow"]["crow1_outro"] 							= %o_berlin1_courtyard_crow1_outtro;

	level.scr_anim["crow"]["crow2_loop"][0] 						= %o_berlin1_courtyard_crow2_loop;
	level.scr_anim["crow"]["crow2_outro"] 							= %o_berlin1_courtyard_crow2_outtro;

	level.scr_anim["crow"]["crow3_loop"][0] 						= %o_berlin1_courtyard_crow3_loop;
	level.scr_anim["crow"]["crow3_outro"] 							= %o_berlin1_courtyard_crow3_outtro;

	level.scr_anim["crow"]["crow4_loop"][0] 						= %o_berlin1_courtyard_crow4_loop;
	level.scr_anim["crow"]["crow4_outro"] 							= %o_berlin1_courtyard_crow4_outtro;

	level.scr_anim["crow"]["crow5_loop"][0] 						= %o_berlin1_courtyard_crow5_loop;
	level.scr_anim["crow"]["crow5_outro"] 							= %o_berlin1_courtyard_crow5_outtro;

	level.scr_anim["crow"]["crow6_loop"][0] 						= %o_berlin1_courtyard_crow6_loop;
	level.scr_anim["crow"]["crow6_outro"] 							= %o_berlin1_courtyard_crow6_outtro;

	level.scr_anim["crow"]["crow7_loop"][0] 						= %o_berlin1_courtyard_crow7_loop;
	level.scr_anim["crow"]["crow7_outro"] 							= %o_berlin1_courtyard_crow7_outtro;

	level.scr_anim["crow"]["crow8_loop"][0] 						= %o_berlin1_courtyard_crow8_loop;
	level.scr_anim["crow"]["crow8_outro"] 							= %o_berlin1_courtyard_crow8_outtro;

	//Indoor Crows
	level.scr_anim["crow"]["indoor_crow1_loop"][0] 						= %o_berlin1_indoor_crow1_loop;
	level.scr_anim["crow"]["indoor_crow1_outro"] 						= %o_berlin1_indoor_crow1_outtro;

	level.scr_anim["crow"]["indoor_crow2_loop"][0] 						= %o_berlin1_indoor_crow2_loop;
	level.scr_anim["crow"]["indoor_crow2_outro"] 						= %o_berlin1_indoor_crow2_outtro;

	level.scr_anim["crow"]["indoor_crow3_loop"][0] 						= %o_berlin1_indoor_crow3_loop;
	level.scr_anim["crow"]["indoor_crow3_outro"] 						= %o_berlin1_indoor_crow3_outtro;

	level.scr_anim["crow"]["indoor_crow4_loop"][0] 						= %o_berlin1_indoor_crow4_loop;
	level.scr_anim["crow"]["indoor_crow4_outro"] 						= %o_berlin1_indoor_crow4_outtro;



	// ASYLUM VO
	
	// entering asylum
	level.scr_sound["vo"]["this_place_reeks"] 								= "Ber1_IGD_043A_REZN";	
	level.scr_sound["vo"]["so_it_should"] 									= "Ber1_IGD_044A_REZN";	
	level.scr_sound["vo"]["only_the_insane"] 								= "Ber1_IGD_045A_REZN";	
	level.scr_sound["vo"]["keep_moving_keep"] 								= "Ber1_IGD_046A_REZN";	
	level.scr_sound["vo"]["this_way_upstairs"] 								= "Ber1_IGD_047A_REZN";	

	//new ones
	level.scr_sound["vo"]["Grab_a_shotgun!"] 								= "Ber1_IGD_300A_REZN";	
	level.scr_sound["vo"]["close_quarters!"] 								= "Ber1_IGD_301A_REZN";	
	
	
	// creepy asylum
	level.scr_sound["vo"]["shhh"] 											= "Ber1_IGD_056A_REZN";	
	level.scr_sound["vo"]["do_you_hear"] 									= "Ber1_IGD_057A_CHER";	
	level.scr_sound["vo"]["no..."] 											= "Ber1_IGD_058A_REZN";	
	level.scr_sound["vo"]["i_am_suspicious"] 								= "Ber1_IGD_059A_REZN";	
	level.scr_sound["vo"]["move_carefully"] 								= "Ber1_IGD_060A_REZN";	
	
	
	// balcony area
	level.scr_sound["vo"]["get_on_that_mg"] 								= "Ber1_IGD_048A_REZN";	
	level.scr_sound["vo"]["use_their_weapons"] 								= "Ber1_IGD_049A_REZN";	
	level.scr_sound["vo"]["there_on_the_roof"] 								= "Ber1_IGD_050A_CHER";	
	level.scr_sound["vo"]["kill_them_all"] 									= "Ber1_IGD_051A_COMM";	
	level.scr_sound["vo"]["pick_them_off"] 									= "Ber1_IGD_052A_COMM";	
	
	//new ones
	level.scr_sound["vo"]["Good_hunting!"] 									= "Ber1_IGD_200A_REZN";	
	level.scr_sound["vo"]["Lets_move!"] 									= "Ber1_IGD_201A_REZN";	
	level.scr_sound["vo"]["Follow_me!"] 									= "Ber1_IGD_053A_REZN";	


	// MG hallway
	level.scr_sound["vo"]["follow_me!"] 									= "Ber1_IGD_053A_REZN";	
	level.scr_sound["vo"]["mg_has_hallway"] 								= "Ber1_IGD_054A_REZN";	
	level.scr_sound["vo"]["dimitri_take_it"] 								= "Ber1_IGD_055A_REZN";			
		
		
}

#using_animtree("generic_human");
tankride()
{
	
	level.scr_anim["tankride"]["surrender_walk"] 							= %ch_berlin1_surrendering_walk_b;
	level.scr_anim["tankride"]["surrender_to_idle"] 						= %ch_berlin1_surrendering_transition_to_idle_b;
	level.scr_anim["tankride"]["surrender_idle"] 							= %ch_berlin1_surrendering_idle_b;
	level.scr_anim["tankride"]["surrender_to_scared"] 						= %ch_berlin1_surrendering_transition_to_scared_b;
	level.scr_anim["tankride"]["surrender_scared"] 							= %ch_berlin1_surrendering_scared_b;
	
	// TANKRIDE VO
	level.scr_sound["vo"]["tanks_now_advancing"] 							= "Ber1_IGD_061A_REZN";			
	level.scr_sound["vo"]["spread_the_word"] 								= "Ber1_IGD_062A_COMM";			
	level.scr_sound["vo"]["citizens_of_berlin"] 							= "Ber1_IGD_063A_COMM";			
	level.scr_sound["vo"]["we_will_crush"] 									= "Ber1_IGD_064A_COMM";			
	level.scr_sound["vo"]["your_only_warning"] 								= "Ber1_IGD_065A_COMM";			
	level.scr_sound["vo"]["abandon_posts"] 									= "Ber1_IGD_066A_COMM";			
	level.scr_sound["vo"]["abandon_homes"] 									= "Ber1_IGD_067A_COMM";			
	level.scr_sound["vo"]["abandon_hope"] 									= "Ber1_IGD_068A_COMM";			
	level.scr_sound["vo"]["ura_1"] 											= "Ber1_IGD_069A_COMM";			
	level.scr_sound["vo"]["ura_2"] 											= "See1_IGD_700A_RURS";			
	
}



holster_weapon_switch_to_sidearm( guy )
{
	guy.og_weapon = guy.weapon; 
	guy gun_remove();
	guy gun_switchto( guy.sidearm, "left" ); 
	guy Attach( GetWeaponModel( guy.og_weapon ), "tag_weapon_right" ); 
}



holster_sidearm_switch_to_weapon( guy )
{
	guy gun_remove();
	guy Detach( GetWeaponModel( guy.og_weapon ), "tag_weapon_right" ); 
	guy gun_switchto( guy.og_weapon, "right" ); 
}




bookcase_push_attach( guy )
{

	bookcase = getent( "pub_bookcase", "targetname" );
	bookcase delete();
	
}

bookcase_push_detach( guy )
{

	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );
	
	bookcase = spawn( "script_model" , orig );
	bookcase.angles = angles;
	bookcase setmodel( "static_berlin_bookshelf_short_ber2" );
}



//**********************************************************************************************************

// unlink guys from the intro boxcar
unlink_boxcar_guys(guy)
{
	guy unlink();
	guy notify( "guy_unlink" );
}



// shake screen when train brakes
train_stopping( guy )
{
	boxcar = getEnt("boxcar_intro", "targetname");	
//	earthquake(0.3, 4, boxcar.origin, 1024);
	
	level notify ("train slowing");
		
	//client notify for Kevins audio
	SetClientSysState("levelNotify","train_quake");
}




geo_anims()
{

	setup_cafe_wall();
	setup_intro_house();
	setup_office_wall();
	setup_ruins_chimney();
	setup_traincar_door();
	
}



//**********************************************************************************************************

#using_animtree("ber1_traincar_door");
setup_traincar_door()
{
	level.scr_anim["boxcar"]["open"] = %o_berlin1_train_door_open;
	level.scr_anim["boxcar"]["close"] = %o_berlin1_train_door_close;
}



open_drone_traincar_door()
{
	
	self UseAnimTree( #animtree );
	self SetFlaggedAnimKnobRestart( "boxcar_anim", level.scr_anim["boxcar"]["open"], 1.0, 0.2, 1.0 );
	self waittillmatch( "boxcar_anim", "end" );
	
}



// self = the boxcar, since guy12 is running his animation off of that entity
open_traincar_door(guy)
{
	
	boxcar = getEnt( "boxcar_intro", "targetname" );

	boxcar UseAnimTree( #animtree );
//	self playsound("whistle_blow");
	
	boxcar SetFlaggedAnimKnobRestart( "boxcar_anim", level.scr_anim["boxcar"]["open"], 1.0, 0.2, 1.0 );
	SetClientSysState("levelNotify","train_quake");
	boxcar waittillmatch( "boxcar_anim", "end" );
	
	flag_set( "train_door_opened" );
	
}



// self = the boxcar, since guy12 is running his animation off of that entity
close_traincar_door()
{
	
	self UseAnimTree( #animtree );
	self SetFlaggedAnimKnobRestart("boxcar_anim", level.scr_anim["boxcar"]["close"], 1.0, 0.2, 1.0 );
	self waittillmatch( "boxcar_anim", "end" );
	
}



#using_animtree("ber1_cafe_wall");
setup_cafe_wall()
{
	level.scr_animtree["cafe_wall"] = #animtree;
	level.scr_model["cafe_wall"] = "anim_berlin_tank_wall";
	level.scr_anim["cafe_wall"]["crumble"] = %o_berlin1_tank_wall;
}



#using_animtree("ber1_office_wall");
setup_office_wall()
{
	level.scr_animtree["office_wall"] = #animtree;
	level.scr_model["office_wall"] = "anim_berlin_officewall";
	level.scr_anim["office_wall"]["crumble"] = %o_berlin1_officewall;
}



#using_animtree("ber1_ruins_chimney");
setup_ruins_chimney()
{
	level.scr_anim["chimney"]["crumble"] = %o_berlin1_ruins_chimney;
	
	addNotetrack_sound("chimney", "chimney_crumble_sound", "crumble", "chimney_fall1");
	addNotetrack_sound("chimney", "wire2_snap", "crumble", "elec_snap2");
	addNotetrack_sound("chimney", "wire1_snap", "crumble", "elec_snap1");
	addNotetrack_sound("chimney", "car_smash_sound", "crumble", "chimney_hit_car");
	addNotetrack_sound("chimney", "chimney_chunk_groundimpact_sound", "crumble", "chimney_hit1");
	addNotetrack_sound("chimney", "chimney_chunk_groundimpact_sound", "crumble", "chimney_hit2");
	addNotetrack_sound("chimney", "chimney_chunk_groundimpact_sound", "crumble", "chimney_hit3");
	addNotetrack_sound("chimney", "chimney_chunk_smallimpact_sound", "crumble", "null");
	
	addNotetrack_customFunction("chimney", "chimney_crumble_sound", ::chimney_crumble_fx, "crumble");
	addNotetrack_customFunction("chimney", "wire1_snap", ::chimney_wire1_fx, "crumble");
	addNotetrack_customFunction("chimney", "wire2_snap", ::chimney_wire2_fx, "crumble");
}



#using_animtree("ber1_ruins_chimney");
ruins_chimney()
{
	parent = getEnt( "ruins_chimney", "targetname" );
	parent.animname = "chimney";
	parent UseAnimTree( #animtree );
	
	pieces = getEntArray("chimneychunk", "targetname");
	
	for(i = 0; i < pieces.size; i++)
	{
		pieces[i].animname = "chimney";
		pieces[i] LinkTo(parent, pieces[i].script_linkto );
	}
	
	level thread chimey_rumble();
	parent anim_single_solo( parent, "crumble" );
	
	wire1_fx2 = parent getTagOrigin("wire1_fx2");
	wire2_fx2 = parent getTagOrigin("wire2_fx2");
	
	playFXonTag(level._effect["wire_sparks"], parent, "wire1_fx2");
	playFXonTag(level._effect["wire_sparks"], parent, "wire2_fx2");
	
	//client notify for Kevins audio
	SetClientSysState("levelNotify","elec_loop");
	
}



chimey_rumble()
{
	wait( 1.5 );
	earthquake( .30, 1.8, (948, -1760, -400), 1000 );
}



chimney_crumble_fx(parent)
{
	fx = getStruct("chimney_fx", "targetname");
	playfx(level._effect["chimney_collapse"], fx.origin);
}



chimney_wire1_fx(parent)
{
	wire1_fx1 = parent getTagOrigin("wire1_fx1");
	playFXonTag(level._effect["transformer_explode"], parent, "wire1_fx1");
}



chimney_wire2_fx(parent)
{
	wire1_fx2 = parent getTagOrigin("wire2_fx1");
	playFXonTag(level._effect["transformer_sparks"], parent, "wire2_fx1");
}



//**********************************************************************************************************

#using_animtree("ber1_intro_house");
setup_intro_house()
{
	level.scr_animtree["intro_house"] = #animtree;
	level.scr_model["intro_house"] = "anim_berlin_house_collapse";
	level.scr_anim["intro_house"]["collapse"] = %o_berlin1_house_collapse;
}

//**********************************************************************************************************



#using_animtree("fakeshooters");
setup_axis_drone_deaths()
{
	level.scr_anim["axis_drone"]["explosion_front"] = %ch_berlin1_explosion_front;
	level.scr_anim["axis_drone"]["explosion_back"] = %ch_berlin1_explosion_back;
	level.scr_anim["axis_drone"]["explosion_left"] = %ch_berlin1_explosion_left;
	level.scr_anim["axis_drone"]["explosion_right"] = %ch_berlin1_explosion_right;
}

//**********************************************************************************************************



// DEBUG!!
draw_notetrack( msg )
{
	self endon( "death" );

	self notify( "stop_draw_notetrack" );
	self endon( "stop_draw_notetrack" );

	while( 1 )
	{
		self waittill( msg, notetrack );
		println( "Notetrack found: ", notetrack );
		iprintln( "Notetrack found: ", notetrack );
		
		if( notetrack == "end" )
		{
			break;
		}
	}
}
