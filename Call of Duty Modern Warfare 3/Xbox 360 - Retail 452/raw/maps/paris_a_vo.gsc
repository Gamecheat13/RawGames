#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#include maps\paris_shared;

main()
{
	prepare_dialogue();
	init_dialogue_flags();
	start_dialogue_threads();	
}

prepare_dialogue()
{
	// please update these comments when you add stuff below so we can keep track
	
// Radio Lone Star, aka Sandman
	add_radio([
		"paris_lns_stilldirty_r",		// in
		"paris_lns_stilldirty",			// in
		"paris_lns_rogerwilco_r",		// in
		"paris_lns_ondeck",				// in
		"paris_lns_norook",				// in
		"paris_lns_patchmethrough",		// in
		"paris_lns_threeminutes",		// in
		"paris_lns_gogogo2_r",			// in
		"paris_lns_acrossthestreet_r",	// in
		"paris_lns_downthestairs_r",	// in
		"paris_lns_engageenagage_r",	// in
		"paris_lns_frostwithme_r",		// in
		"paris_lns_onbalcony_r",		// in
		"paris_lns_topfloorclear",		// in
		"paris_lns_yourstatus",			// in
		"paris_lns_getingame_r",		// in
		"paris_lns_getdownhere",		// in
		"paris_lns_restaurantahead",	// in
		"paris_lns_watchyourfirenorth",	// in
		"paris_lns_wheresvolk_r",		// in
		"paris_lns_gotyourback_r",		// in
		"paris_lns_linkup",				// in
		"paris_lns_acrosscourtyard_r",	// in
		"paris_lns_coverfire_r",		// in
		"paris_lns_gogogo_r",			// in
		"paris_lns_topofstairs_r",		// in
		"paris_lns_howmanywegot",		// waiting: How many we got?
		"paris_lns_closeairsupport_r",	// in
		"paris_lns_markirstrobes_r",	// in
		"paris_lns_idtargets",			// in
		"paris_lns_getstrobeson_r",		// in
		"paris_lns_multiplehits_r",		// in
		"paris_lns_amiss_r",			// in
		"paris_lns_nohits_r",			// in
		"paris_lns_zerokills_r",		// in
		"paris_lns_directhit_r",		// in
		"paris_lns_thatsahit_r",		// in
		"paris_lns_thatsamiss_r",		// in
		"paris_lns_endofalley_r",		// in
		"paris_lns_needastrobe_r",		// in
		"paris_lns_throwsmoke",			// in
		"paris_lns_putsmoke",			// in
		"paris_lns_useastrobe_r",		// in
		"paris_lns_markarmor_r",		// in
		"paris_lns_tosssmoke",			// in
		"paris_lns_gunshipcantsee",		// in
		"paris_lns_markwithsmoke",		// in
		"paris_lns_designatetarget", 	// in
		"paris_lns_russiansroping",		// in
		"paris_lns_imiprovise",			// in
		"paris_lns_btrdestroyed",		// in
		"paris_lns_thanksforassist",	// in
		"paris_lns_goodworkbrother_r",	// in
		"paris_lns_belowground",		// in
		"paris_lns_getdowntheladder",	// in
		"paris_lns_downtheladder",		// in
		"paris_lns_headbelow"			// in	
		
	]);

	// Radio Reno, aka Grinch
	add_radio([
		"paris_rno_lottarooks",			// in
		"paris_rno_watchyourstep_r",	// in
		"paris_rno_compromised",		// in
		"paris_rno_buildingacross",		// in
		"paris_rno_heavyfire",			// in
		"paris_rno_checkdoor_r",		// in
		"paris_rno_clear2_r",			// in
		"paris_rno_lesamis_r",			// in
		"paris_rno_allofem",			// waiting: That all of 'em?
		"paris_rno_moving_r",			// in
		"paris_rno_threeringcircus_r",	// in
		"paris_rno_tangosinbound_r"		// in
	
	]);
	
	// Radio GIGN Leader, aka Sabre
	add_radio([
		"paris_ggn_muchlonger",			// SABRE: This is Sabre!  How much longer?!
		"paris_ggn_threemins",			// SABRE: Please - just hurry!
		"paris_ggn_gladtosee",			// SABRE: Copy that.  Merde.. We're glad to see you.
		"paris_ggn_fourmen",			// in
		"paris_ggn_downthealley_r",		// in
		"paris_ggn_movemove_r",			// in
		"paris_ggn_incatacombs_r",		// in
		"paris_ggn_entranceahead_r",	// in
		"paris_ggn_entranceahead2_r",	// in
		"paris_ggn_overhere2_r"			// in
		
	]);
	
	// Fire Support Officer (radio)
	add_radio([
		"paris_fso_onracetrack"			// in
		
	]);
	
	// Overlord
	add_radio([
		"paris_hqr_triagecivilians",	// in
		"paris_hqr_heavyresistance",	// edit request from glen:  cutting out "2 armored divisions and 5 infantry battalions"
		"paris_hqr_gignpinned"			// in
		
	]);
	
	// AC-130 Pilot
	add_radio([
		"paris_plt_goinghot",			// in
		"paris_plt_engaging",			// in
		"paris_plt_targetconfirmed",	// in
		"paris_plt_rogermark",			// in
		"paris_plt_rogerspot",			// in
		"paris_plt_ontheway",			// in
		"paris_plt_engaging2",			// in
		"paris_plt_goodmark",			// in
		"paris_plt_roundsondeck",		// in
		"paris_plt_shotoutdangerclose",	// in
		"paris_plt_firing",				// in
		"paris_plt_orbitreestablished",	// in
		"paris_plt_sensorsback",		// in
		"paris_plt_calltargets",		// in, but may need rewrite
		"paris_plt_readyformark",		// in
		"paris_plt_readyfortargets",	// in
		"paris_plt_bingofuel"			// in
		
	]);
	
	// Green Beret
	add_radio([
		"paris_grb_louvre_v2"				//new fade-in baked into begining of source file
		
	]);	
	
	// Truck
	add_radio([
		"paris_trk_meetyou"				
		
	]);	
	
	// GIGN 1
	add_radio([
		"paris_ggn1_thiswayhurry", 		// in
		"paris_ggn1_cmoncmon" 			// in
		
	]);	
	
	// GIGN 2
	add_radio([
		"paris_ggn2_overhere",			// in
		"paris_ggn2_hurrycomeon"		// in
		
	]);	
	
	
	flag_init("flag_conversation_in_progress");
}

init_dialogue_flags()
{
	flag_init( "flag_dialogue_opening" );
	flag_init( "flag_dialogue_watch_your_step" );
	flag_init( "flag_dialogue_gign_in_trouble" );
	flag_init( "flag_dialogue_in_the_game" );
	flag_init( "flag_dialogue_down_the_stairs" );
	flag_init( "flag_dialogue_go_hot_complete" );
	flag_init( "flag_dialogue_bookstore_balcony" );
	flag_init( "flag_dialogue_bookstore_top_floor_clear_1" );
	flag_init( "flag_dialogue_bookstore_heavy_fire_1" );
	flag_init( "flag_dialogue_bookstore_heavy_fire_2" );
	flag_init( "flag_dialogue_check_door" );
	flag_init( "flag_dialogue_check_door_complete" );
	flag_init( "flag_dialogue_bookstore_clear" );
	flag_init( "flag_dialogue_press_the_attack_complete" );
	flag_init( "flag_dialogue_restaurant_meeting" );
	flag_init( "flag_rpg_top_of_stairs_dialogue" );
	flag_init( "flag_dialogue_ac130_player_has_strobe" );
	flag_init( "flag_dialogue_down_the_alley" );
	flag_init( "flag_dialogue_heli_courtyard" );
	flag_init( "flag_dialogue_courtyard_2_clear" );
	flag_init( "flag_dialogue_btr_alley" );
	flag_init( "flag_dialogue_destroyed_btr_with_rpg" );
	flag_init( "flag_dialogue_entrance_ahead" );
	flag_init( "flag_dialogue_manhole_prompt" );

	// some of these (but not all) should be removed
	flag_init( "flag_dialogue_catacombs_post_breach" );
	flag_init( "flag_dialogue_everyone_in_truck" );
	flag_init( "flag_dialogue_another_shooter" );
	flag_init( "flag_dialogue_use_javelin" );
	flag_init( "flag_dialogue_nice_shootin" );
	flag_init( "flag_dialogue_ac130_player_killed_targets" );
	flag_init( "flag_dialogue_makarov_men" );
	flag_init( "flag_dialogue_escape_timer_started" );
	flag_init( "flag_dialogue_in_the_truck" );
}

start_dialogue_threads()
{
	switch( level.start_point )
	{
		case "default":		
		
		case "rooftops":
			thread opening_dialogue();
			thread watch_your_step_dialogue();
			thread gign_in_trouble_gialogue();
			thread across_the_street_dialogue();
			
		case "stairwell":
			thread in_the_game_dialogue();
			thread check_for_survivors_dialogue();
			thread on_balcony_dialogue();
			thread bookstore_top_floor_clear_dialogue();
			thread bookstore_heavy_fire_dialogue_1();
			thread bookstore_heavy_fire_dialogue_2();
			thread check_door_dialogue();
			thread bookstore_clear_dialogue();
			
		case "restaurant_approach":
			thread restaurant_pre_meeting_dialogue();
			thread restaurant_meeting_dialogue();
			thread across_the_courtyard_dialogue();
			thread rpg_top_of_stairs_dialogue();
			thread follow_me_dialogue();
			thread joga_studio_dialogue();
		
		case "ac_moment":
			thread ac130_dialogue();
			thread air_support_strobe_dialogue();
			thread down_the_alley_dialogue();
			thread heli_unloading_dialogue();
			thread btr_dialogue();
			thread brt_destroyed_with_rpg_dialogue();
			thread courtyard_2_clear_dialogue();
	//		thread entrance_ahead_dialogue();
			
		case "sewer_entrance":
			thread manhole_dialogue();
				
		break;
		default:
			AssertMsg("Unhandled start point " + level.start_point);
	}
	
}

// everything here should be in script order

opening_dialogue()
{
	flag_wait( "flag_dialogue_opening" );
	wait 2.0;//1.546
	conversation_begin();
	radio_dialogue("paris_grb_louvre_v2");
	wait 0.473;
	radio_dialogue("paris_hqr_triagecivilians");
	conversation_end();

	wait 2.1;
	//flag_wait( "flag_little_bird_landed" );
	conversation_begin();
//	radio_dialogue("paris_lns_stilldirty_r"); 	//LITTLEBIRD PILOT: Overlord, Team One is on the deck now.
	radio_dialogue("paris_lns_stilldirty"); 	//SANDMAN: This area's still dirty from the chemical attack.  Keep your masks on.
	wait 0.15;
	radio_dialogue("paris_lns_ondeck"); 		//SANDMAN: Truck, we're on the deck and movin'.
	radio_dialogue("paris_trk_meetyou");		//TRUCK: Rog'.  I'll meet you at the LZ in one hour.  Good luck.
	conversation_end();

	wait 2;

	conversation_begin();
	radio_dialogue("paris_hqr_heavyresistance"); 	//OVERLORD: Metal Zero One, GIGN is pinned down at the Palm D'or restaurant.  Get there fast or we'll lose the only shot we've got at finding Makarov.
	radio_dialogue("paris_lns_rogerwilco_r"); 		//SANDMAN: Roger wilco.
	conversation_end();
	
	flag_wait( "flag_check_vitals" );
	wait 2;
	
	conversation_begin();
	radio_dialogue("paris_rno_lottarooks"); //GRINCH: Five Nine Five sounds like they got hit hard.  Lotta rooks in that unit.
	radio_dialogue("paris_lns_norook"); 	//SANDMAN: No one's a rook today.
	conversation_end();
}

watch_your_step_dialogue()
{
	flag_wait ( "flag_dialogue_watch_your_step" );
	wait 1;
	conversation_begin();
	radio_dialogue("paris_rno_watchyourstep_r"); //GRINCH: Watch your step.
	conversation_end();
}

gign_in_trouble_gialogue()
{
	flag_wait( "flag_dialogue_gignpinned" ); 
	conversation_begin();
	radio_dialogue("paris_hqr_gignpinned"); 		//OVERLORD: Zero One, be advised, GIGN is taking heavy casualties.  They won't last long.  You'll need to double time it to make the RV.
	radio_dialogue("paris_lns_patchmethrough"); 	// SANDMAN: Patch me through to 'em.
	radio_dialogue("paris_ggn_muchlonger"); 		//SABRE: This is Sabre!  How much longer?!
	radio_dialogue("paris_lns_threeminutes"); 		//SANDMAN: Three minutes out.  Keep your permiter secure.  We're almost there.
	radio_dialogue("paris_ggn_threemins"); 			//SABRE: Please - just hurry!
	radio_dialogue("paris_lns_gogogo2_r"); 			//SANDMAN: Let's go.
//	wait 1.5;
//	radio_dialogue("paris_lns_acrossthestreet_r");

	conversation_end();
}

across_the_street_dialogue()
{
	flag_wait( "player_rooftop_jump_complete" );
	
	wait 1;
	conversation_begin();
	radio_dialogue("paris_lns_acrossthestreet_r"); //SANDMAN: This way! Move!
	conversation_end();
}
	
in_the_game_dialogue()
{
	flag_wait( "flag_dialogue_in_the_game" );
	
	wait .75;
	
	conversation_begin();

	line = random([
		"paris_rno_buildingacross", 	//GRINCH: Contact!  Building across the street!
		"paris_rno_compromised" 		//GRINCH: We're compromised - building across the street!
	]);
	radio_dialogue( line );
			
	radio_dialogue("paris_lns_getingame_r"); //SANDMAN: Go loud!

	flag_set( "flag_dialogue_go_hot_complete" );
	
	wait .75;
	radio_dialogue("paris_lns_downthestairs_r"); //SANDMAN: Down the stairs!
	conversation_end();
}
	
check_for_survivors_dialogue()
{
	flag_wait( "flag_obj_01_position_change_5" );
	conversation_begin();
	radio_dialogue("paris_lns_frostwithme_r"); //SANDMAN: Frost, with me!  Hit the bookstore!
	conversation_end();
}	

on_balcony_dialogue()
{
	flag_wait( "flag_dialogue_bookstore_balcony" );
	
	if(!flag( "flag_bookstore_combat_top_rear" ) && !flag( "flag_bookstore_combat_interior" ))
	{
		conversation_begin();
		radio_dialogue("paris_lns_onbalcony_r"); //GRINCH: On the balcony!
		conversation_end();
	}
}

bookstore_top_floor_clear_dialogue()
{
	flag_wait( "flag_dialogue_bookstore_top_floor_clear_1" );
	wait 1;
	conversation_begin();
	radio_dialogue( "paris_lns_topfloorclear" ); //SANDMAN: Top floor clear!
	conversation_end();
}	

bookstore_heavy_fire_dialogue_1()
{
	flag_wait( "flag_dialogue_bookstore_heavy_fire_1" );
	time = randomfloatrange( 1.5, 3.5 );
	wait time;
	conversation_begin();
	radio_dialogue( "paris_rno_heavyfire" ); //GRINCH: Taking heavy fire!
	conversation_end();
}

bookstore_heavy_fire_dialogue_2()
{
	flag_wait( "flag_dialogue_bookstore_heavy_fire_2" );
	time = randomfloatrange( 1.5, 3.5 );
	wait time;
	conversation_begin();
	radio_dialogue( "paris_rno_heavyfire" ); //GRINCH: Taking heavy fire!
	radio_dialogue( "paris_lns_getdownhere" ); //SANDMAN: Frost, get down here!
	conversation_end();
}

bookstore_clear_dialogue()
{
	flag_wait( "flag_dialogue_bookstore_clear" );
	wait 1;
	conversation_begin();
	radio_dialogue( "paris_rno_clear2_r" );
	conversation_end();
	flag_set( "flag_dialogue_press_the_attack_complete" );
}	

check_door_dialogue()
{
	flag_wait( "flag_dialogue_check_door" );

	wait 1;
	conversation_begin();
	radio_dialogue( "paris_rno_checkdoor_r" ); 			//GRINCH: Check the door!
	radio_dialogue( "paris_lns_restaurantahead" ); 		//SANDMAN: The restaurant's at the end of this alley.
	radio_dialogue( "paris_lns_watchyourfirenorth" ); 	//SANDMAN: Sabre, this is Sandman.  Watch your fire to the North - we are coming to you.
	delayThread(2.5, ::flag_set, "flag_dialogue_check_door_complete");
	radio_dialogue( "paris_ggn_gladtosee" ); 			//SABRE: Copy that.  Merde.. We're glad to see you.
	conversation_end();
}
				
restaurant_pre_meeting_dialogue()
{		
	flag_wait( "flag_dialogue_lasamis" );
	conversation_begin();
	level.player thread play_sound_on_tag(level.scr_radio[ "paris_ggn1_thiswayhurry" ], undefined, true ); //GIGN 1: This way!  Hurry!
	wait 1.35;
	thread radio_dialogue( "paris_rno_lesamis_r" ); //GRINCH: It's the GIGN!
	wait 1.25;
	level.player thread play_sound_on_tag(level.scr_radio[ "paris_ggn1_cmoncmon" ], undefined, true ); //GIGN 1: Come on!  Come on!
	wait 1.25;
	thread gign_waving_dialogue();
	radio_dialogue( "paris_rno_allofem" );		//GRINCH: That all of 'em?
	conversation_end();
	wait 2;
	aud_send_msg( "mus_reached_gign" );
}

gign_waving_dialogue()
{
	wait 1.25;
	level.player thread play_sound_on_tag(level.scr_radio[ "paris_ggn2_hurrycomeon" ], undefined, true ); //GIGN 2: Hurry!  Come on!
	wait 1.25;
	level.player play_sound_on_tag(level.scr_radio[ "paris_ggn2_overhere" ], undefined, true ); //GIGN 2: Over here!
}

restaurant_meeting_dialogue()
{
	// I expect this might become a full animated scene
	flag_wait( "flag_dialogue_restaurant_meeting" );
	conversation_begin();
	
	radio_dialogue( "paris_lns_yourstatus" );
	radio_dialogue( "paris_ggn_fourmen" );
	radio_dialogue( "paris_lns_wheresvolk_r" );
	radio_dialogue( "paris_ggn_incatacombs_r" );
	radio_dialogue( "paris_lns_gotyourback_r" );

	aud_send_msg( "mus_follow_gign" );
	
	radio_dialogue( "paris_lns_linkup" );
	conversation_end();
}
	
across_the_courtyard_dialogue()
{
	flag_wait("flag_courtyard_1_wave_2");
	conversation_begin();
	
	aud_send_msg("mus_cross_courtyard1");
	
	radio_dialogue( "paris_lns_acrosscourtyard_r" );
	radio_dialogue( "paris_lns_coverfire_r" );
	radio_dialogue( "paris_rno_moving_r" );
	radio_dialogue( "paris_lns_gogogo_r" );
	conversation_end();
	
	flag_set( "flag_rpg_top_of_stairs_dialogue" );
}	
		
rpg_top_of_stairs_dialogue()
{
	flag_wait( "flag_rpg_top_of_stairs_dialogue" );
	conversation_begin();
	radio_dialogue( "paris_lns_topofstairs_r" );
	conversation_end();
}

follow_me_dialogue()
{
	flag_wait( "flag_cross_courtyard_complete" );
	conversation_begin();
	radio_dialogue( "paris_ggn_entranceahead_r" );
	conversation_end();
}

joga_studio_dialogue()
{
	flag_wait( "flag_joga_studio_dialogue" );
	conversation_begin();
	radio_dialogue("paris_lns_acrossthestreet_r");
	conversation_end();
}

ac130_dialogue()
{
	flag_wait( "flag_ac130_moment_dialogue" );
	wait 2.0;
	conversation_begin();
	
	radio_dialogue( "paris_rno_tangosinbound_r" ); //GRINCH: Boss, we got bad guys inbound.
	radio_dialogue( "paris_lns_howmanywegot" ); //SANDMAN: How many we got?
	radio_dialogue( "paris_rno_threeringcircus_r" ); //GRINCH: Looks like Moscow down there!  We're gonna need air support!
	radio_dialogue( "paris_lns_closeairsupport_r" ); // SANDMAN: Warhammer, this is Metal Zero-One. Request fire mission, over.
	
	aud_send_msg("mus_ac130_replies");

	radio_dialogue( "paris_fso_onracetrack"); //AC PILOT: Roger, Metal Zero-One.  Established in orbit at 12,000 feet.  Full load.  Mark your targets.
	conversation_end();
	
	thread mark_initial_targets_dialogue();
}

mark_initial_targets_dialogue()
{	
	flag_wait( "flag_dialogue_ac130_player_has_strobe" );
	
	
	last_line = undefined;
	while(!flag("flag_dialogue_ac130_player_killed_targets"))
	{		
		wait 1;
		flag_waitopen("flag_strobes_in_use");
	
		if(flag("flag_dialogue_ac130_player_killed_targets"))
			break;
	
		conversation_begin();
		while(true)
		{	
			line = random([
						"paris_lns_markirstrobes_r",
						"paris_lns_idtargets",
						"paris_lns_throwsmoke",
						"paris_lns_putsmoke",
						"paris_lns_getstrobeson_r"
				]);
			// make sure there's at least two lines in the list above
			if(!IsDefined(last_line) || last_line != line)
			{
				last_line = line;
				break;	
			}
			
		}
		
		radio_dialogue( line );
		conversation_end();
		
		wait 10;	
	}
}

air_support_strobe_dialogue()
{
	// should match the list in maps\paris_a_code::courtyard_2_combat()
	btr_courtyard_enemy_noteworthies = [
		  "enemy_courtyard_2_wave_1"
		, "enemy_courtyard_2_wave_2"
		, "enemy_courtyard_2_wave_3"
		, "enemy_courtyard_2_brt_crew"
		, "enemy_ai_initial_ac_moment"
		, "enemy_ai_initial_ac_moment_gaz"
		, "enemy_courtyard_2_heli_crew"
		];
	
	last_ready_line = undefined;
	last_fired_upon_line = undefined;
	while(1)
	{
		// good thing there are only 5 of these, as that's all waittill_any_return supports
		// sigh, now there are more
		msg = level waittill_any_return(/* "air_support_strobe_thrown", */ "air_support_strobe_no_targets", "air_support_strobe_popped", "air_suport_strobe_fired_upon", "air_support_strobe_killed", "air_support_strobe_ready");	
		
		switch(msg)
		{
			// taken out to get around the 5-argument limitation above
			//case "air_support_strobe_thrown":
			//break;
			
			case "air_support_strobe_no_targets":
				// todo: need some dialogue for this
			break;
			
			case "air_support_strobe_popped":
			break;
			
			case "air_support_strobe_ready":
				// early out if the battle is almost over, so it doesn't sound silly when he says he's ready
				// and then immediately says he's out of fuel
				if(flag("btr_cortyard_killed") && spawn_metrics_number_alive(btr_courtyard_enemy_noteworthies) < 4)
				{
					break;
				}			
				while(true)
				{
					line = random([
						"paris_plt_orbitreestablished",
						"paris_plt_sensorsback",
						"paris_plt_calltargets",
						"paris_plt_readyformark",
						"paris_plt_readyfortargets"
					]);
					if(!IsDefined(last_ready_line) || line != last_ready_line)
					{
						last_ready_line = line;
						break;
					}					
				}
				radio_dialogue(line);
			break;
			
			case "air_suport_strobe_fired_upon":
				while(true)
				{
					line = random([
						"paris_plt_goinghot", 
						"paris_plt_engaging", 
						"paris_plt_targetconfirmed", 
						"paris_plt_rogerspot",
						"paris_plt_ontheway",
						"paris_plt_engaging2",
						"paris_plt_goodmark",
						"paris_plt_roundsondeck",
						"paris_plt_shotoutdangerclose",
						"paris_plt_firing",
						"paris_plt_rogermark"
					]);
					if(!IsDefined(last_fired_upon_line) || line != last_fired_upon_line)
					{
						last_fired_upon_line = line;
						break;
					}
				}
				radio_dialogue(line);
				
			break;
			
			case "air_support_strobe_killed":
				air_support_strobe_kills_dialogue();
			break;
		}
	}		
}

air_support_strobe_kills_dialogue()
{
	level endon( "stop_air_support_strobe_kill_dialogue" );

	if ( level.air_support_strobe_btr_killed )
	{
		line = "paris_lns_btrdestroyed";
	}
	else
	{
		// only speak kill lines if btr wasn't killed,
		//   custom line will play for btr
		kills = maps\_air_support_strobe::get_num_kills();
		while(true)
		{
			// each case must choose between at least two lines!
			switch(kills)				
			{
				case 0:
					line = random(["paris_lns_nohits_r", "paris_lns_zerokills_r", "paris_lns_thatsamiss_r"]);
				break;
							
				case 1:
					line = random(["paris_lns_directhit_r", "paris_lns_thatsahit_r"]);
				break;
							
				default:	
					line = random(["paris_lns_multiplehits_r", "paris_lns_directhit_r"]);
			}
			
			if(!IsDefined(level.last_killed_line) || line != level.last_killed_line)
			{
				level.last_killed_line = line;
				break;
			}
		}
	}
	
	// this wait is important so the endon can end this before the line plays
	wait 2;
	
	if(!flag("flag_dialogue_courtyard_2_clear"))
	{
		radio_dialogue(line);
	}
}

down_the_alley_dialogue()
{
	flag_wait("flag_dialogue_down_the_alley");	
	
	wait 1;
	
	conversation_begin();
	radio_dialogue( "paris_ggn_downthealley_r");	
	radio_dialogue( "paris_lns_gogogo2_r");	
	conversation_end();
}

heli_unloading_dialogue()
{
	flag_wait("flag_dialogue_heli_unloading");	
	
	wait 1;
	
	conversation_begin();
	radio_dialogue( "paris_lns_russiansroping");	
	conversation_end();
}	

heli_courtyard_dialogue()
{
	// script has this happening before tanks_side_alley_dialogue, but it makes more sense here
	
	flag_wait("flag_dialogue_heli_courtyard");
	
	conversation_begin();
	radio_dialogue( "paris_ggn_entranceahead2_r");	
	conversation_end();
}

btr_dialogue()
{
	flag_wait("flag_dialogue_btr_alley");
		
	if(flag("btr_cortyard_killed"))
		return;
	
	radio_dialogue( "paris_lns_endofalley_r");	
	
	// todo: better triggering for this?  line of sight?
	
	wait_and_pause_for_strobe(5, 15);
	
	if(flag("btr_cortyard_killed"))
		return;
	
	conversation_begin();
	radio_dialogue( "paris_lns_markarmor_r");
	conversation_end();
	
	wait_and_pause_for_strobe(6, 15);
	while(!flag("btr_cortyard_killed"))
	{
		conversation_begin();
		radio_dialogue( "paris_lns_needastrobe_r");
		conversation_end();
		
		wait_and_pause_for_strobe(8, 15);
		
		if(flag("btr_cortyard_killed"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_useastrobe_r");
		conversation_end();
		
		wait_and_pause_for_strobe(8, 15);	
		
		if(flag("btr_cortyard_killed"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_tosssmoke");
		conversation_end();
		
		wait_and_pause_for_strobe(8, 15);	
		
		if(flag("btr_cortyard_killed"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_gunshipcantsee");
		conversation_end();
		
		wait_and_pause_for_strobe(8, 15);	
		
		if(flag("btr_cortyard_killed"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_markwithsmoke");
		conversation_end();
		
		wait_and_pause_for_strobe(8, 15);	
		
		if(flag("btr_cortyard_killed"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_designatetarget");
		conversation_end();

		wait_and_pause_for_strobe(8, 15);	
		
		if(flag("btr_cortyard_killed"))
			break;
	}

}

brt_destroyed_with_rpg_dialogue()
{
	flag_wait( "flag_dialogue_destroyed_btr_with_rpg" );
	
	wait 2;
	conversation_begin();
	radio_dialogue( "paris_lns_imiprovise");
	conversation_end();
}	

Wait_and_pause_for_strobe(duration, extra_wait)
{
	while(true)
	{
		add_wait(::_wait, duration);
		add_wait(::flag_wait, "flag_strobes_in_use");
		do_wait_any();
				
		if(flag("flag_strobes_in_use"))
		{
			add_wait(::_wait, extra_wait);					
			add_wait(::flag_waitopen, "flag_strobes_in_use");
			do_wait();
		}
		else
		{
			break;			
		}
	}	
}

courtyard_2_clear_dialogue()
{
	flag_wait("flag_dialogue_courtyard_2_clear");
	
	wait 3;
	conversation_begin();	
	radio_dialogue( "paris_lns_goodworkbrother_r");
	radio_dialogue( "paris_ggn_entranceahead2_r");
	wait 1;
	radio_dialogue( "paris_plt_bingofuel");	
	radio_dialogue( "paris_lns_thanksforassist");	
	conversation_end();
}

/*
entrance_ahead_dialogue()
{
	flag_wait("flag_dialogue_entrance_ahead");
	
	conversation_begin();
	radio_dialogue( "paris_ggn_entranceahead2_r");	
	conversation_end();
}
*/

manhole_dialogue()
{
	flag_wait("flag_dialogue_manhole_prompt");
	
	conversation_begin();
	radio_dialogue( "paris_ggn_overhere2_r");
	conversation_end();
	
	flag_wait( "flag_player_manhole_ready" );
	
	wait 2;
	if(flag("flag_player_manhole")) return;
	
	conversation_begin();
	radio_dialogue( "paris_lns_getdowntheladder");
	conversation_end();
	
	while(!flag("flag_player_manhole"))
	{
		wait 10;
		
		conversation_begin();
		radio_dialogue( "paris_lns_belowground");
		conversation_end();
	
		wait 20;
		
		if(flag("flag_player_manhole"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_downtheladder");
		conversation_end();	
		
		wait 30;
		
		if(flag("flag_player_manhole"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_headbelow");
		conversation_end();	
		
		wait 20;
	}

}
