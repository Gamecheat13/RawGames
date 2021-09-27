#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;

#using_animtree( "generic_human" );

prepare_dialogue()
{
	//characters
	price = "price";
	yuri = "yuri";
	nikolai = "nikolai";
	makarov = "makarov";
	
	/********************************
	*************INTRO***************
	********************************/
	//Yuri: You're sure this armor will protect us?
	level.scr_sound[Yuri][ "dubai_yur_surethisarmor" ]		= "dubai_yur_surethisarmor";
	//Price: It will buy us time.  Nikolai, are you patched into their system?
	level.scr_radio[ "dubai_pri_buyustime" ]		= "dubai_pri_buyustime";
	//Nikolai: Working on it. My Arabic's rusty.
	level.scr_radio[ "dubai_snd_arabicsrusty" ]		= "dubai_snd_arabicsrusty";

	//Yuri: Looks like they know we're here, Price.
	level.scr_sound[Yuri][ "dubai_yur_knowwerehere" ]		= "dubai_yur_knowwerehere";
	//Nikolai: I've tapped in to their security feed.  Makarov's in the atrium on the top floor.
	level.scr_radio[ "dubai_nik_topfloor" ]		= "dubai_nik_topfloor";
	//Price: This is it. Makarov doesn't leave here alive.
	level.scr_radio[ "dubai_pri_thisisit" ]		= "dubai_pri_thisisit";
	//Nikolai: Roger that. Good luck.
	level.scr_radio[ "dubai_snd_goodluck" ]		= "dubai_snd_goodluck";
	//Price: Yuri, get ready.
	level.scr_radio[ "dubai_pri_yurigetready" ]		= "dubai_pri_yurigetready";
	//Price: This is for Soap.
	level.scr_radio[ "dubai_pri_forsoap2" ]		= "dubai_pri_forsoap2";
	
	/********************************
	************STREETS**************
	********************************/
	//Price: We've got their attention. Second wave of responders will be coming any moment.
	level.scr_radio[ "dubai_pri_gottheirattention" ]		= "dubai_pri_gottheirattention";

	//Price: Here they come, right on schedule.
	level.scr_radio[ "dubai_pri_heretheycome" ]		= "dubai_pri_heretheycome";
	//Price: Shoot the cars!
	level.scr_radio[ "dubai_pri_shootcars" ]		= "dubai_pri_shootcars";
	
	//Nikolai: Makarov's got a small army in there!
	level.scr_radio[ "dubai_nik_smallarmy" ]		= "dubai_nik_smallarmy";
	//Price: It won't help him. Take control of the lifts so he can't escape.
	level.scr_radio[ "dubai_pri_wonthelphim" ]		= "dubai_pri_wonthelphim";
	//Nikolai: I'm on it.
	level.scr_radio[ "dubai_nik_imonit2" ]		= "dubai_nik_imonit2";

	
	//Yuri: RPGs! Second floor!
	level.scr_radio[ "dubai_pri_rpg2ndfloor" ]		= "dubai_pri_rpg2ndfloor";
	//Price: Keep firing!
	level.scr_radio[ "dubai_pri_keepfiring" ]		= "dubai_pri_keepfiring";
	//Price: Don't let up!
	level.scr_radio[ "dubai_pri_dontletup" ]		= "dubai_pri_dontletup";

	//Yuri: Civilians coming out. Watch your fire.
	level.scr_radio[ "dubai_yur_watchfire" ]		= "dubai_yur_watchfire";
	//Price: Nikolai, where's Makarov?
	level.scr_radio[ "dubai_pri_wheresmakarov" ]		= "dubai_pri_wheresmakarov";
	//Nikolai: Still in the atrium, but he's on the move!
	level.scr_radio[ "dubai_nik_onthemove" ]		= "dubai_nik_onthemove";
	//Price: Don't lose him!  We're almost there!
	level.scr_radio[ "dubai_pri_dontlosehim" ]		= "dubai_pri_dontlosehim";

	//Yuri: Price, keep up!
	level.scr_radio[ "dubai_yur_keepup" ]		= "dubai_yur_keepup";
	//Yuri: Price, over here!
	level.scr_radio[ "dubai_yur_overhere" ]		= "dubai_yur_overhere";

	
	/********************************
	*************LOBBY***************
	********************************/
	//Yuri: Hostiles by the escalator!
	level.scr_radio[ "dubai_pri_escalator" ]		= "dubai_pri_escalator";
	
	//Price: Up the escalator!
	level.scr_radio[ "dubai_pri_upescalator" ]		= "dubai_pri_upescalator";
	
	//Price: Nikolai, we need control of those lifts!
	level.scr_radio[ "dubai_pri_controloflifts" ]		= "dubai_pri_controloflifts";
	//Nikolai: I've almost got it!
	level.scr_radio[ "dubai_nik_almostgotit" ]		= "dubai_nik_almostgotit";

	
	//Price: Push forward!
	level.scr_radio[ "dubai_pri_pushforward" ]		= "dubai_pri_pushforward";
	
	//Yuri: Price, keep moving!
	level.scr_radio[ "dubai_pri_keepmoving" ]		= "dubai_pri_keepmoving";
	//Yuri: Price, come on!
	level.scr_radio[ "dubai_pri_yuricomeon" ]		= "dubai_pri_yuricomeon";
	//Yuri: Price, get in the lift!
	level.scr_radio[ "dubai_pri_getinthelift" ]		= "dubai_pri_getinthelift";
	
	//Nikolai: Ok, I've got control of the elevators. Sending them down to your floor.
	level.scr_radio[ "dubai_snd_elevators" ]		= "dubai_snd_elevators";

	//Yuri: The lift's up ahead!
	level.scr_radio[ "dubai_pri_liftupahead" ]		= "dubai_pri_liftupahead";
	
	/********************************
	************ELEVATOR*************
	********************************/
	//Nikolai: He's moved to the restaurant, same floor! He's got a large security detail with him.
	level.scr_radio[ "dubai_snd_restaurant" ]		= "dubai_snd_restaurant";
	//Yuri: What kind of opposition is waiting for us?
	level.scr_radio[ "dubai_pri_opposition" ]		= "dubai_pri_opposition";
	//Nikolai: Forty plus foot mobiles, SMGs and Assault Rifles.
	level.scr_radio[ "dubai_snd_twentyplus" ]		= "dubai_snd_twentyplus";
	
	//Nikolai: Enemy chopper closing on your position.
	level.scr_radio[ "dubai_nik_enemychopper" ]		= "dubai_nik_enemychopper";
	
	//Yuri: One is heading for the roof, probably going for Makarov.
	level.scr_radio[ "dubai_pri_headingforroof" ]		= "dubai_pri_headingforroof";
	
	//Yuri: Get down!
	level.scr_radio[ "dubai_pri_getdown" ]		= "dubai_pri_getdown";
	//Yuri: Shoot it down!
	level.scr_radio[ "dubai_pri_shootitdown" ]		= "dubai_pri_shootitdown";
	//Yuri: Good shot!
	level.scr_radio[ "dubai_pri_goodshot" ]		= "dubai_pri_goodshot";
	
	//Price: Look out!
	level.scr_radio[ "dubai_pri_lookout" ]		= "dubai_pri_lookout";
	
	//Yuri: Our armor's shredded!
	level.scr_sound[Yuri][ "dubai_pri_shredded" ]		= "dubai_pri_shredded";
	//Yuri: Nikolai, we need another lift!
	level.scr_sound[Yuri][ "dubai_pri_anotherlift" ]		= "dubai_pri_anotherlift";
	//Nikolai: Copy, on it's way.
	level.scr_radio[ "dubai_snd_onitsway" ]		= "dubai_snd_onitsway";
	//Yuri: This won't hold much longer.
	level.scr_sound[Yuri][ "dubai_pri_wonthold" ]		= "dubai_pri_wonthold";
	//Yuri: Jump!
	level.scr_sound[Yuri][ "dubai_pri_jump" ]		= "dubai_pri_jump";
	
	//Yuri: PRICE!!! NO!!!
	level.scr_sound[Yuri][ "dubai_yur_priceno" ]		= "dubai_yur_priceno";

	//Nikolai: Makarov's chopper just touched down!  He's heading there now!
	level.scr_radio[ "dubai_nik_toucheddown" ]		= "dubai_nik_toucheddown";
	//Price: He's not getting away!  Let's move!
	level.scr_radio[ "dubai_pri_gettingaway" ]		= "dubai_pri_gettingaway";
	//Nikolai: Be careful, they're setting up barricades.
	level.scr_radio[ "dubai_nik_barricades" ]		= "dubai_nik_barricades";

	//Yuri: Frag out!
	level.scr_sound[Yuri][ "dubai_pri_fragout" ]		= "dubai_pri_fragout";

	/********************************
	***********TOP FLOOR*************
	********************************/
	//Price: Watch yourself, Yuri! Your armor is gone!
	level.scr_radio[ "dubai_pri_watchyourself" ]		= "dubai_pri_watchyourself";
	
	//Nikolai: Multiple threats to your right.
	level.scr_radio[ "dubai_nik_threatsright" ]		= "dubai_nik_threatsright";
	//Price: Keep pressing.  We've almost got him.
	level.scr_radio[ "dubai_pri_keeppressing" ]		= "dubai_pri_keeppressing";
	
	//Nikolai: You're almost at the restaurant!
	level.scr_radio[ "dubai_nik_restaurant2" ]		= "dubai_nik_restaurant2";
	//Price: Keep pushing forward!
	level.scr_radio[ "dubai_pri_keeppushing" ]		= "dubai_pri_keeppushing";

	//Price: We can't let him escape!
	level.scr_radio[ "dubai_pri_letescape" ]		= "dubai_pri_letescape";

	
	//Price: Restaurant's this way!
	level.scr_radio[ "dubai_pri_restaurant" ]		= "dubai_pri_restaurant";
	//Nikolai: He's still there! You've almost got him!
	level.scr_radio[ "dubai_snd_almostgothim" ]		= "dubai_snd_almostgothim";

	
	/********************************
	***********RESTAURANT************
	********************************/
	//Price: There he is!
	level.scr_radio[ "dubai_pri_thereheis" ]		= "dubai_pri_thereheis";
	//Price: Watch out for that chopper!
	level.scr_radio[ "dubai_pri_watchout" ]		= "dubai_pri_watchout";
	//Yuri: Rockets!
	level.scr_sound[Yuri][ "dubai_pri_rockets" ]		= "dubai_pri_rockets";

	//Price: (startled yell)
	level.scr_radio[ "dubai_pri_shocked" ]		= "dubai_pri_shocked";
	//Yuri: (startled yell of pain)
	level.scr_radio[ "dubai_yur_pain" ]		= "dubai_yur_pain";


	//Price: Yuri…
	level.scr_radio[ "dubai_pri_yuri2" ]		= "dubai_pri_yuri2";
	//Yuri: Don't let him get away.
	level.scr_sound[Yuri][ "dubai_yur_dontlethim" ]		= "dubai_yur_dontlethim";
	//Nikolai: Makarov's heading to the roof!
	level.scr_radio[ "dubai_nik_makarovroof" ]		= "dubai_nik_makarovroof";
	
	/********************************
	***********STAIRWELL*************
	********************************/
	//Nikolai: He's dead ahead.  Keep running!
	level.scr_radio[ "dubai_nik_keeprunning" ]		= "dubai_nik_keeprunning";
	//Nikolai: He's going for the chopper! Run!
	level.scr_radio[ "dubai_snd_chopper" ]		= "dubai_snd_chopper";


	/********************************
	************FINALE***************
	********************************/
	//Makarov: Goodbye, Captain Price.
	level.scr_sound[Makarov][ "dubai_mkv_goodbye" ]		= "dubai_mkv_goodbye";
	level.scr_face[Makarov][ "dubai_mkv_goodbye" ] = %dubai_finale_draw_makarov_face;
	
	//Nag lines
	level.juggernaut_nag_lines = [];
	level.juggernaut_nag_lines[level.juggernaut_nag_lines.size] = "dubai_yur_keepup"; //Yuri: Price, keep up!
	level.juggernaut_nag_lines[level.juggernaut_nag_lines.size] = "dubai_yur_overhere"; //Yuri: Price, over here!
	level.juggernaut_nag_lines[level.juggernaut_nag_lines.size] = "dubai_pri_keepmoving"; //Yuri: Price, keep moving!
	
	array_thread( getentarray( "juggernaut_movement_trigger", "script_noteworthy" ), ::nag_juggernaut_movement_triggers_think );
}

play_dialogue()
{
	thread dubai_intro_dialogue();
	thread dubai_streets_dialogue();
	thread dubai_exterior_circle_dialogue();
	thread dubai_lobby_dialogue();
	thread dubai_lobby_near_elevator();
	thread dubai_elevator_dialogue();
	thread dubai_top_floor_dialogue();
	thread dubai_restaurant_dialogue();
	thread dubai_stairwell_dialogue();
	thread dubai_finale_roof_dialogue();
	thread dubai_finale_roof_makarov_dialogue();
}

dubai_intro_dialogue()
{
	flag_wait( "vo_intro_on_black" );
	
	//hint( "Price: Get ready.", 2 );
	
	wait 2.5;
	
	//Yuri: You're sure this armor will protect us?
	level.yuri dialogue_queue( "dubai_yur_surethisarmor" );
	
	wait 0.5;
	
	//Price: It will buy us time.  Nikolai, are you patched into their system?
	radio_dialogue( "dubai_pri_buyustime" );

	//Nikolai: Working on it. My Arabic's rusty.
	radio_dialogue("dubai_snd_arabicsrusty");

	
	
	flag_wait( "vo_intro_start" );
	
	//Yuri: Looks like they know we're here, Price.
	level.yuri dialogue_queue( "dubai_yur_knowwerehere" );
	
	flag_set( "pip_atrium_start" );
	flag_set( "exterior_civilians_initial" );
	//Nikolai: I've tapped in to their security feed.  Makarov's in the atrium on the top floor.
	radio_dialogue("dubai_nik_topfloor");
	
	delaythread( 1, ::flag_set, "objective_kill_makarov" );
	
	//Price: This is it. Makarov doesn't leave here alive.
	radio_dialogue( "dubai_pri_thisisit" );
	//Nikolai: Roger that. Good luck.
	//radio_dialogue( "dubai_snd_goodluck" );
	
	flag_wait( "vo_intro_get_ready" );
	//Price: Yuri, get ready.
	radio_dialogue( "dubai_pri_yurigetready" );
	
	wait 2.5;
	
	//Price: This is for Soap.
	radio_dialogue( "dubai_pri_forsoap2" );
	aud_send_msg("mus_first_combat");
}

dubai_streets_dialogue()
{
	flag_wait( "vo_streets_start" );
	
	thread nag_streets();
	
	//Price: We've got their attention. Second wave of responders will be coming any moment.
	radio_dialogue( "dubai_pri_gottheirattention" );
	
	level.friendlyFireDisabled = false;
	
	flag_wait( "exterior_suv_1" );
	
	thread nag_juggernaut_movement_reset();
	
	wait 1;
	
	//Price: Here they come, right on schedule.
	radio_dialogue( "dubai_pri_heretheycome" );
	
	//Price: Shoot the cars!
	radio_dialogue( "dubai_pri_shootcars" );
	
	wait 10;
	
	thread nag_juggernaut_movement_reset();
	
	//Nikolai: Makarov's got a small army in there!
	radio_dialogue("dubai_nik_smallarmy");
	//Price: It won't help him. Take control of the lifts so he can't escape.
	radio_dialogue( "dubai_pri_wonthelphim" );
	//Nikolai: I'm on it.
	radio_dialogue("dubai_nik_imonit2");
	
	thread nag_juggernaut_movement_reset();
}

nag_streets()
{
	thread nag_juggernaut_movement();
}

nag_juggernaut_movement()
{
	level endon( "juggernaut_movement_nag_reset" );
	
	wait 20;
	
	while( !flag( "yuri_in_elevator" ) )
	{
		//play a random nag line
		radio_dialogue( random(level.juggernaut_nag_lines) );
		
		wait 10;
	}
}

nag_juggernaut_movement_triggers_think()
{
	self waittill( "trigger" );
	
	level notify( "juggernaut_movement_nag_reset" );
	
	thread nag_juggernaut_movement();
	
}

nag_juggernaut_movement_reset()
{
	level notify( "juggernaut_movement_nag_reset" );
	thread nag_juggernaut_movement();
}

dubai_exterior_circle_dialogue()
{
	flag_wait( "exterior_suv_scene" );
	
	thread dubai_streets_rpg_dialogue();
	
	wait 3;
	
	thread nag_juggernaut_movement_reset();
	
	wait 3;
	
	//Price: Don't let up!
	radio_dialogue( "dubai_pri_dontletup" );
	
	flag_wait( "exterior_enemies_violent_death" );
	
	thread nag_juggernaut_movement_reset();
	
	//Yuri: Civilians coming out. Watch your fire.
	radio_dialogue( "dubai_yur_watchfire" );
	
	flag_wait( "vo_near_lobby" );
	
	//Price: Nikolai, where's Makarov?
	radio_dialogue( "dubai_pri_wheresmakarov" );
	
	flag_set( "pip_lounge_start" );
	//Nikolai: Still in the atrium, but he's on the move!
	radio_dialogue( "dubai_nik_onthemove" );
	//Price: Don't lose him!  We're almost there!
	radio_dialogue( "dubai_pri_dontlosehim" );
	
	thread nag_juggernaut_movement_reset();
	
}

dubai_streets_rpg_dialogue()
{
	flag_wait( "exterior_rpg_enemies_in_position" );

	thread nag_juggernaut_movement_reset();

	//Yuri: RPGs! Second floor!
	radio_dialogue( "dubai_pri_rpg2ndfloor" );
}

dubai_lobby_dialogue()
{
	//level endon( "vo_lobby_near_elevator" );
	
	flag_wait( "vo_lobby_start" );
	
	thread nag_juggernaut_movement_reset();
	
	wait 2;
	//Yuri: Hostiles by the escalator!
	radio_dialogue("dubai_pri_escalator");
	
	flag_wait( "lobby_combat_ascent" );
	
	thread nag_juggernaut_movement_reset();
	
	wait 3;
	//Price: Up the escalator!
	radio_dialogue("dubai_pri_upescalator");
	
	wait 3;
	//Price: Nikolai, we need control of those lifts!
	radio_dialogue( "dubai_pri_controloflifts" );
	//Nikolai: I've almost got it!
	radio_dialogue( "dubai_nik_almostgotit" );
	
	flag_wait( "lobby_combat_top" );
	
	thread nag_juggernaut_movement_reset();
	
	//Yuri: Push forward!
	radio_dialogue("dubai_pri_pushforward");
	
	wait 4;
	
	//Nikolai: Ok, I've got control of the elevators. Sending them down to your floor.
	radio_dialogue("dubai_snd_elevators");
	
	flag_wait( "lobby_yuri_to_elevator" );
	
	wait 1;
	
	//Price: The lift's up ahead!
	radio_dialogue("dubai_pri_liftupahead");
}

dubai_lobby_near_elevator()
{
	//wait until Yuri is in the elevator before the nagging starts
	flag_wait( "yuri_in_elevator" );
	
	thread nag_lobby_elevator();
}

nag_lobby_elevator()
{
	level endon( "player_in_elevator" );
	
	wait 10;
	
	lines = [];
	lines[lines.size] = "dubai_pri_getinthelift"; //Yuri: Price, get in the lift!
	lines[lines.size] = "dubai_pri_yuricomeon"; //Yuri: Price, come on!
	
	while( !flag( "player_in_elevator" ) )
	{
		radio_dialogue( random( lines ) );
		
		wait randomintrange( 5, 10 );
	}
}

dubai_elevator_dialogue()
{
	flag_wait( "vo_elevator_start" );
		
	level endon( "vo_elevator_player_falling" );
	thread dubai_elevator_player_falling_dialogue();
		
	//if debug testing elevator animations, skip this dialogue
	if( !GetDvarInt( "dev_elevator_anim_test" ) )
	{
		flag_set( "pip_restaurant_start" );
		//Nikolai: He's moved to the restaurant, same floor! He's got a large security detail with him.
		radio_dialogue("dubai_snd_restaurant");
		//Yuri: What kind of opposition is waiting for us?
		radio_dialogue("dubai_pri_opposition");
		//Nikolai: Forty plus foot mobiles, SMGs and Assault Rifles.
		radio_dialogue("dubai_snd_twentyplus");
		
		wait 0.5;
		//Sandman: Enemy chopper closing on your position.
		radio_dialogue("dubai_nik_enemychopper");
		
		//Yuri: One is heading for the roof, probably going for Makarov.
		radio_dialogue("dubai_pri_headingforroof");
		
		//chopper approaches to open fire
		flag_wait( "elevator_chopper_preattack" );
		//thread hint( "Yuri: Get down!", 2 );
		
		//Yuri: Shoot it down!
		radio_dialogue("dubai_pri_shootitdown");

		wait 4;
		//Price: Keep firing!
		radio_dialogue( "dubai_pri_keepfiring" );
	
		//players shoots down chopper
		flag_wait( "elevator_chopper_killed" );
		//wait 0.5;
		
		//Yuri: Good shot!
		radio_dialogue("dubai_pri_goodshot");
		
		wait 1;
		
		//if chopper has already exploded, don't say line
		if( !flag( "elevator_chopper_crash_done" ) )
		{
			//Price: Look out!
			radio_dialogue("dubai_pri_lookout");
		}
	}
	
	flag_wait( "elevator_chopper_crash_done" );
	
	//in case "Look out!" is still playing
	radio_dialogue_stop();
	
	//wait 5;
	//Yuri: Our armor's shredded!
	flag_wait( "yuri_no_juggernaut_spawned" );
	level.yuri dialogue_queue("dubai_pri_shredded");
	
	wait 7.5;
	//Yuri: Sandman, we need another lift!
	level.yuri dialogue_queue("dubai_pri_anotherlift");
	
	wait 1;
	
	//Nikolai: Copy, on it's way.
	radio_dialogue("dubai_snd_onitsway");
	
	flag_wait( "elevator_initial_short_drop" );
	wait 1;
	//Yuri: This won't hold much longer.
	level.yuri dialogue_queue("dubai_pri_wonthold");
	
	flag_wait( "replacement_elevator_in_position" );
	
	wait 1;
	//Yuri: Jump!
	level.yuri dialogue_queue("dubai_pri_jump");
	
	//flag_wait( "elevator_replacement_moving_to_top" );
	
	flag_wait( "top_floor_countdown_start" );
	
	//Nikolai: Makarov's chopper just touched down!  He's heading there now!
	radio_dialogue("dubai_nik_toucheddown");
	wait 0.5;
	//Price: He's not getting away!  Let's move!
	radio_dialogue("dubai_pri_gettingaway");
	
	wait 1;
	//Nikolai: Be careful, they're setting up barricades.
	radio_dialogue("dubai_nik_barricades");
	
	flag_wait( "top_floor_yuri_grenade_start" );
	//Yuri: Frag out!
	level.yuri dialogue_queue("dubai_pri_fragout");
}

dubai_elevator_player_falling_dialogue()
{
	level endon( "top_floor_countdown_start" );
	
	flag_wait( "vo_elevator_player_falling" );
	
	//Yuri: PRICE!!! NO!!!
	level.yuri dialogue_queue("dubai_yur_priceno");
}

dubai_top_floor_dialogue()
{
	flag_wait( "vo_top_floor_start" );
	
	wait 2.5;
	
	//Price: Watch yourself, Yuri! Your armor is gone!
	radio_dialogue("dubai_pri_watchyourself");
	
	wait 1;
	
	flag_wait( "top_floor_lounge_combat_1" );
	//Nikolai: Multiple threats to your right.
	radio_dialogue("dubai_nik_threatsright");
	
	wait 0.5;
	
	//Yuri: Keep pressing.  We've almost got him.
	radio_dialogue("dubai_pri_keeppressing");
	
	flag_wait( "top_floor_lounge_combat_2" );
	wait 1;
	
	//Price: We can't let him escape!
	radio_dialogue("dubai_pri_letescape");

	flag_wait( "top_floor_lounge_combat_3" );
	wait 1;

	//Nikolai: You're almost at the restaurant!
	radio_dialogue("dubai_nik_restaurant2");
	//Price: Keep pushing forward!
	radio_dialogue("dubai_pri_keeppushing");
	
	//wait until enemies are cleared out
	flag_wait( "top_floor_lounge_clear" );
	
	wait 0.5;
	//Price: Restaurant's this way!
	radio_dialogue("dubai_pri_restaurant");
	//Nikolai: He's still there! You've almost got him!
	radio_dialogue("dubai_snd_almostgothim");
}

dubai_restaurant_dialogue()
{
	flag_wait( "vo_restaurant_start" );
	
	//Price: There he is!
	radio_dialogue("dubai_pri_thereheis");
	
	wait 2;
	//Price: Watch out for that chopper!
	radio_dialogue("dubai_pri_watchout");
	
	flag_wait( "chopper_restaurant_strafe_run" );
	
	//Yuri: Rockets!
	level.yuri dialogue_queue("dubai_pri_rockets");
	
	wait 1;
	
	//Price: (startled yell)
	radio_dialogue("dubai_pri_shocked");
	
	flag_wait( "vo_restaurant_destruction_yuri" );
	
	//Yuri: (startled yell of pain)
	radio_dialogue("dubai_yur_pain");
	
	wait 2;
	//Price: Yuri…
	radio_dialogue("dubai_pri_yuri2");
	
	//Yuri: Don't let him get away.
	level.yuri dialogue_queue("dubai_yur_dontlethim");
	aud_send_msg("mus_dont_let_him_get_away");
	
	flag_set( "yuri_restaurant_dialogue_done" );
	
	//wait 1;
	
	//Nikolai: Makarov's heading to the roof!
	radio_dialogue("dubai_nik_makarovroof");
}

dubai_stairwell_dialogue()
{
	flag_wait( "vo_stairwell_start" );
	
	//Sandman: He's dead ahead.  Keep running!
	radio_dialogue("dubai_nik_keeprunning");
}

dubai_finale_roof_dialogue()
{
	flag_wait( "finale_sequence_begin" );
	
	//Sandman: He's going for the chopper! Run!
	radio_dialogue("dubai_snd_chopper");
	
}

dubai_finale_roof_makarov_dialogue()
{
	flag_wait( "vo_finale_roof_start" );
	
	level.makarov dialogue_queue("dubai_mkv_goodbye");
}