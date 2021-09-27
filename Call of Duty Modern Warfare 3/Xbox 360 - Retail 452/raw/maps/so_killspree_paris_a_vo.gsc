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
		"paris_lns_checkpoint1_r",		// in
		"paris_lns_sitrepongign_r",		// in
		"paris_lns_rogerwilco_r",		// in
		"paris_lns_gogogo2_r",			// in
		"paris_lns_acrossthestreet_r",	// in
		"paris_lns_downthestairs_r",	// in
		"paris_lns_engageenagage_r",	// in
		"paris_lns_frostwithme_r",		// in
		"paris_lns_onbalcony_r",		// in
		"paris_lns_yourstatus",			// in
		"paris_lns_getingame_r",		// in
		"paris_lns_wheresvolk_r",		// in
		"paris_lns_gotyourback_r",		// in
		"paris_lns_linkup",				// in
		"paris_lns_acrosscourtyard_r",	// in
		"paris_lns_coverfire_r",		// in
		"paris_lns_gogogo_r",			// in
		"paris_lns_topofstairs_r",		// in
		"paris_lns_closeairsupport_r",	// in
		"paris_lns_markirstrobes_r",	// in
		"paris_lns_idtargets",			// in
		"paris_lns_getstrobeson_r",		// cut
		"paris_lns_multiplehits_r",		// in
		"paris_lns_amiss_r",			// in
		"paris_lns_nohits_r",			// in
		"paris_lns_zerokills_r",		// in
		"paris_lns_directhit_r",		// in
		"paris_lns_thatsahit_r",		// in
		"paris_lns_thatsamiss_r",		// in
		"paris_lns_paxdown_r",			// in
		"paris_lns_endofalley_r",		// in
		"paris_lns_needastrobe_r",		// in
		"paris_lns_throwsmoke",			// in
		"paris_lns_putsmoke",			// in
		"paris_lns_useastrobe_r",		// in
		"paris_lns_markarmor_r",		// in
		"paris_lns_tosssmoke",			// in
		"paris_lns_russiansroping",		// in
		"paris_lns_btrdestroyed",		// in
		"paris_lns_thanksforassist",	// in
		"paris_lns_goodworkbrother_r",	// in
		"paris_lns_downthemanhole_r",	// in
		"paris_lns_belowground",		// in
		"paris_lns_getdowntheladder",	// in
		"paris_lns_downtheladder",		// in
		"paris_lns_headbelow",			// in
		"paris_lns_downthehole_r"		// in		
		
	]);

	// Radio Reno, aka Grinch
	add_radio([
		"paris_rno_watchyourstep_r",	// in
		"paris_rno_compromised",		// in
		"paris_rno_buildingacross",		// in
		"paris_rno_checkdoor_r",		// in
		"paris_rno_clear2_r",			// in
		"paris_rno_lesamis_r",			// in
		"paris_rno_moving_r",			// in
		"paris_rno_threeringcircus_r",	// in
		"paris_rno_tangosinbound_r"		// in
	
	]);
	
	// Radio GIGN Leader, aka Sabre
	add_radio([
		"paris_ggn_areyoudelta_r",		// in
		"paris_ggn_fourmen",			// in
		"paris_ggn_downthealley_r",		// in
		"paris_ggn_movemove_r",			// in
		"paris_ggn_incatacombs_r",		// in
		"paris_ggn_entranceahead_r",	// in
		"paris_ggn_entranceahead2_r",	// in
		"paris_ggn_overhere_r",			// in
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
		"paris_hqr_loseonlyshot",		// in
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
	flag_init( "flag_dialogue_check_door" );
	flag_init( "flag_dialogue_bookstore_clear" );
	flag_init( "flag_dialogue_press_the_attack_complete" );
	flag_init( "flag_dialogue_restaurant_meeting" );
	flag_init( "flag_dialogue_ac130_player_has_strobe" );
	flag_init( "flag_dialogue_down_the_alley" );
	flag_init( "flag_dialogue_heli_courtyard" );
	flag_init( "flag_dialogue_courtyard_2_clear" );
	flag_init( "flag_dialogue_btr_alley" );
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
	thread air_support_strobe_dialogue();

}

// everything here should be in script order

opening_dialogue()
{
	flag_wait( "flag_dialogue_opening" );
	conversation_begin();
	radio_dialogue("paris_grb_louvre_v2");
	radio_dialogue("paris_hqr_triagecivilians");
	conversation_end();
	
	flag_wait( "flag_little_bird_landed" );
	conversation_begin();
	radio_dialogue("paris_lns_stilldirty_r");
	conversation_end();
	
	wait 0.5;
	conversation_begin();
	radio_dialogue("paris_lns_checkpoint1_r");
	radio_dialogue("paris_hqr_heavyresistance");
	conversation_end();
	
	wait 1.5;
	conversation_begin();
	radio_dialogue("paris_lns_sitrepongign_r");
	radio_dialogue("paris_hqr_loseonlyshot");
	radio_dialogue("paris_lns_rogerwilco_r");
	conversation_end();
}


watch_your_step_dialogue()
{
	flag_wait ( "flag_dialogue_watch_your_step" );
	conversation_begin();
	radio_dialogue("paris_rno_watchyourstep_r");
	conversation_end();
}

gign_in_trouble_gialogue()
{
	flag_wait( "flag_rooftops_shimmy_player_finished" );
	conversation_begin();
	radio_dialogue("paris_hqr_gignpinned");
	conversation_end();
}
	
in_the_game_dialogue()
{
	flag_wait( "flag_dialogue_in_the_game" );
	
	wait .75;
	

	conversation_begin();

	line = random([
		"paris_rno_buildingacross",
		"paris_rno_compromised"
	]);
	radio_dialogue( line );
			
	line = random([
		"paris_lns_getingame_r",
		"paris_lns_engageenagage_r"
	]);
	radio_dialogue( line );

	flag_set( "flag_dialogue_go_hot_complete" );
	
	wait .75;
	radio_dialogue("paris_lns_downthestairs_r");
	conversation_end();
}


across_the_street_dialogue()
{
	flag_wait( "flag_obj_01_position_change_2" );
	conversation_begin();
	radio_dialogue("paris_lns_acrossthestreet_r");
	conversation_end();
}
	
check_for_survivors_dialogue()
{
	flag_wait( "flag_obj_01_position_change_4" );
	conversation_begin();
	radio_dialogue("paris_lns_frostwithme_r");
	conversation_end();
}	

on_balcony_dialogue()
{
	flag_wait( "flag_player_enters_bookstore" );
	conversation_begin();
	radio_dialogue("paris_lns_onbalcony_r");
	conversation_end();
}

check_door_dialogue()
{
	flag_wait( "flag_dialogue_check_door" );
	
	aud_send_msg("mus_enter_book_store_done");

	wait 1;
	conversation_begin();
	radio_dialogue("paris_rno_checkdoor_r");	
	conversation_end();
}
	
bookstore_clear_dialogue()
{
	flag_wait( "flag_dialogue_bookstore_clear" );
	conversation_begin();
	radio_dialogue( "paris_rno_clear2_r" );
	aud_send_msg( "mus_reached_gign" );
	conversation_end();
	flag_set( "flag_dialogue_press_the_attack_complete" );
}		
		
restaurant_pre_meeting_dialogue()
{		
	flag_wait( "trigger_restaurant_meeting" );
	conversation_begin();
	radio_dialogue( "paris_rno_lesamis_r" );
	conversation_end();
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

ac130_dialogue()
{
	flag_wait( "flag_ac130_moment_dialogue" );
	wait 2.0;
	conversation_begin();
	
	radio_dialogue( "paris_rno_tangosinbound_r" );
	radio_dialogue( "paris_rno_threeringcircus_r" );
	radio_dialogue( "paris_lns_closeairsupport_r" );
	
	aud_send_msg("mus_ac130_replies");

	radio_dialogue( "paris_fso_onracetrack");
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
				//radio_dialogue(line);
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
				//radio_dialogue(line);
				
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
					line = random(["paris_lns_amiss_r", "paris_lns_nohits_r", "paris_lns_zerokills_r", "paris_lns_thatsamiss_r"]);
				break;
							
				case 1:
					line = random(["paris_lns_directhit_r", "paris_lns_thatsahit_r"]);
				break;
							
				default:	
					line = random(["paris_lns_multiplehits_r", "paris_lns_paxdown_r"]);
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
	//radio_dialogue(line);
}

down_the_alley_dialogue()
{
	flag_wait("flag_dialogue_down_the_alley");	
	
	wait 1;
	
	conversation_begin();
	radio_dialogue( "paris_ggn_downthealley_r");	
	radio_dialogue( "paris_ggn_movemove_r");	
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
		
	// todo: better triggering for this?  line of sight?

	wait_and_pause_for_strobe(3, 15);

	if(flag("btr_cortyard_killed"))
		return;
	
	conversation_begin();
	radio_dialogue( "paris_lns_endofalley_r");
	conversation_end();
	
	wait_and_pause_for_strobe(5, 15);
	
	if(flag("btr_cortyard_killed"))
		return;
	
	conversation_begin();
	radio_dialogue( "paris_lns_useastrobe_r");
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
		radio_dialogue( "paris_lns_markarmor_r");
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
		radio_dialogue( "paris_lns_useastrobe_r");
		conversation_end();
		
		wait_and_pause_for_strobe(8, 15);	
		
		if(flag("btr_cortyard_killed"))
			break;
		
		conversation_begin();
		radio_dialogue( "paris_lns_getstrobeson_r");
		conversation_end();
		
	}

}

wait_and_pause_for_strobe(duration, extra_wait)
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
