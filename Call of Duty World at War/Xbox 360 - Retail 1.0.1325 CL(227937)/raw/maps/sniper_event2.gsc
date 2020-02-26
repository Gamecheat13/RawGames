#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_music;
#include maps\sniper;


event2_start()
{
	setmusicstate("SNIPER_DEAD");
	tp_to_start("event2");
	getent("E1_player_near_building_trig", "targetname") delete();
	flag_set("outof_event1");
	flag_set("hero_ready_upstairs");
	
	event2_trigsoff();
	
	
	//reznov_wait_at_stair();
	//level thread player_tooeager_toface_sniper("sniper_battle_started", "player_eager_toface_sniper");
	//level thread player_tooeager_toface_sniper("event2_started", "player_eager_toface_sniper_atwindow");
	level notify ("event2_started");
	
	thread sniper_battle_start();
	thread sniper_dead_now();
	thread reznov_wait_at_stair();

}

event2b_start()
{
	
	level notify ("event2_started");
	tp_to_start("event2b");
	
	spot = getstruct("mannequin", "targetname");
	level.hero.animname = "hero";

	animtime = getanimlength(level.scr_anim["hero"]["mannequin_out"]);
	spot thread anim_single_solo(level.hero,"mannequin_out");
	wait animtime - 0.08;
	level.hero stopanimscripted();
	spot = getstruct("new_crawlout_align_node", "targetname");
	animtime = getanimlength(level.scr_anim["hero"]["bb_intro_hop_down"]);
	spot anim_reach_solo(level.hero, "bb_intro_hop_down");
	spot anim_single_solo(level.hero, "bb_intro_hop_down");
	spot thread anim_loop_solo(level.hero, "bb_intro_hop_loop", undefined, "stop_loop");
	/*wait animtime/2;
	level.hero.a.pose = "crouch"; 
	wait animtime/2;
	level.hero allowedstances("crouch");
	*/
	flag_set("hop_down_complete");
	//blocker = getent("block_player_by_dog", "targetname");
	//blocker delete();
	getent("downstairs_clip", "targetname") delete();
	setmusicstate("SNIPER_DEAD");

	getent("E1_player_near_building_trig", "targetname") delete();
	event2_trigsoff();
	level.hero.animname = "hero";
	
	level thread hero_downstairs_bb();
	level.hero.ignoreall = true;
	getent("e2_sarge_into_flame_building", "targetname") notify ("trigger");

	getent("E2_mean_patrollers", "target") waittill ("trigger");
	patrol_passes();
	thread building_burn();
	
	//TUEY change music state to "FIRE"
	setmusicstate("FIRE");
	level notify ("e2_sniper_dead");
}


event2c_start()
 {
 	
 	objective_controller(3);

	tp_to_start("event2c");
	level.beamskipto = true;
	wait 8;
	
	spot = getstruct("new_crawlout_align_node", "targetname");
	level.hero.animname = "hero";
	spot anim_single_solo(level.hero, "bb_stairs_out");	
	level.hero set_run_anim("stair_run");	
	level.hero enable_ai_color();
	
	get_players()[0] thread player_knocked_down2();
	
	thread bb_sdk_own_wall();
	thread player_bb_jumpout();
	
	level.hero allowedstances("prone","crouch","stand");
	players = get_players();
	array_thread(players, ::by_window_trig);

}

event2d_start()
 {
	tp_to_start("event2d");
	level thread furnace_burst();
	bookcase_fun();
	//get_players()[0] thread player_knocked_down2();
	
}

event2e_start()
 {
 	
 	objective_controller(3);

	tp_to_start("event2e");

		
	thread bb_sdk_own_wall();
	thread player_bb_jumpout();
	
	level.hero allowedstances("prone","crouch","stand");
	players = get_players();
	array_thread(players, ::by_window_trig);
	
	level notify ("event2_started");
	level notify ("e2_sniper_dead");
}

event2a_start()
 {
	tp_to_start("event2a");
	level thread furnace_burst();
	//bookcase_fun();
	//get_players()[0] thread player_knocked_down2();
	
}

#using_animtree( "sniper_crows" );
bookcase_fire()
{
	wait 3;
	bookshelf = getent("bookcase", "targetname");
	playfxontag(level._effect["bookcase_fire"], bookshelf, "tag_fx4");
	playfxontag(level._effect["bookcase_fire"], bookshelf, "tag_fx5");
	playfxontag(level._effect["bookcase_fire"], bookshelf, "tag_fx6");
	playfxontag(level._effect["bookcase_fire"], bookshelf, "tag_fx8");

}

#using_animtree( "sniper_crows" );
bookcase_fun() // bookshelf falling
{
	bookshelf = getent("bookcase", "targetname");
	
	trig = getent("bookcase_trig", "targetname");
	trig waittill ("trigger");
	//spot = getnode("bookshelf_fall_align", "targetname");
	//align = spawn("script_origin", spot.origin);
	//align.angles = spot.angles;
	


	bookshelf UseAnimTree(#animtree);
	bookshelf.script_linkto = "origin_animate_jnt";
	bookshelf playsound ("bookcase_fall");
	level thread anim_ents_solo( bookshelf, "fall", undefined, undefined, bookshelf, "bookshelf" );

	
	wait 2.4;
	level.player playrumbleonentity("explosion_generic");
	wait 0.6;
	spot = getstruct("bookcase_fall_fx", "targetname");
	playfx(level._effect["bookcase_bounce"], spot.origin);
	earthquake(0.3, 0.5, level.player.origin, 500);

	wait 1;
	level	thread say_dialogue("they_r_surround");

}

		 

///////////////  Section 1 - This script supports the player in the store, breaking stealth, and AI reactions \\\\\\\\\\\\
charge_player_at_storefight()
{
	self endon("death");
	wait randomintrange(30,60);
	self setgoalentity(get_players()[0]);
}

player_panics()
{
	trig =	getent("player_panic_inshop", "targetname");
	trig trigger_on();
	trig waittill ("trigger");
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		guys[i] setgoalentity(get_players()[0]);
	}
}

hero_finish_barwalk()
{
	level endon ("fightdone");
	if (flag("opening_bar_door"))
	{
		flag_waitopen("opening_bar_still");
	}
	if (flag("opening_bar_still"))
	{
		level.hero stopanimscripted();
		spot = getstructent("sarge_walk_along_spot", "targetname");
		spot anim_reach_solo(level.hero, "bar_lift_only");
		spot anim_single_solo(level.hero, "bar_lift_only");
	}
	level.hero solo_set_pacifist(false);
	level.hero enable_ai_color();
}

hero_dies_nowfail()
{
	level endon ("fightdone");
	level.hero waittill ("death");
	iprintlnbold(&"SNIPER_REZNOV_KILLED");
	missionfailed();
}

break_stealth_but_player_canwin()
{

	flag_set("player_in_shop");
	level endon ("door_out_opened");
	level waittill ("player_broke_stealth_inshop");
	flag_set("barfight_ison");
	//TUEY Sets music state to BROKE_STEALTH
	setmusicstate("BROKE_STEALTH");


	level thread hero_dies_nowfail();
	level.hero.ignoreme = true;
	level.hero.health = 3000;
	thread player_panics();
	level thread hero_finish_barwalk();
	level notify ("stop_talking");
	wait 0.01;
	thread say_dialogue("u_gave_away");
	getent("fight_in_shop_chain", "targetname") notify ("trigger");
	nodes = getnodearray("shop_fight_axis_nodes", "script_noteworthy");
	nodecounter = 0;
	axis = getaiarray("axis");
	for (i=0; i < axis.size; i++)
	{
		axis[i] solo_set_pacifist(false);
		if (isdefined(nodes[nodecounter]) )
		{
			axis[i] setgoalnode(nodes[nodecounter]);
			axis[i] thread charge_player_at_storefight();
			nodecounter++;
		}
		else
		{
			axis[i] setgoalentity(get_players()[0]);
		}
	}
	guys = getentarray("player_in_shop_enemies", "targetname");
	for (i=0;  i < guys.size; i++)
	{
		guys[i] dospawn();
	}
	wait 2;
	maps\_spawner::kill_spawnernum(8);
	waittill_aigroupcleared("player_inshop_enemies");
	axis = getaiarray("axis");
	for (i=0; i < axis.size; i++)
	{
		axis[i] solo_set_pacifist(false);
		axis[i] setgoalentity(get_players()[0]);
	}
	waittill_aigroupcleared("player_inshop_enemies2");
	flag_clear("barfight_ison");
	//TUEY Set music state to SURVIVED_BROKEN_STEALTH
	setmusicstate("SURVIVED_BROKEN_STEALTH");

	chastisements = [];
	chastisements[0] = "cant_afford";
	chastisements[1] = "nearly_ruined";
	chastisements[2] = "sniper_stay_hidden";
	chastisements[3] = "dont_draw_attention";
	chastisements[4] = "kill_amsel";
	chastiseused = [];
	chastiseused[0] = undefined;
	chastiseused[1] = undefined;
	chastiseused[2] = undefined;
	chastiseused[3] = undefined;
	chastiseused[4] = undefined;
	
	for (i=0; i < 2; i++)
	{
		while(1)
		{
			chastise = chastisements[randomint(chastisements.size)];
			if (!isdefined(chastiseused[chastise] ) )
			{
				chastiseused[chastise] = true;
				break;
			}
			wait 0.01;
		}
		thread say_dialogue(chastise);
	}
	
	level notify ("fightdone");
	
	thread say_dialogue("move_quietly", "done_chastising_inbar");
	level.hero solo_set_pacifist(true);
	level.hero.ignoreme = true;
	level.hero.ignoreall = true;
	level.hero.ignoreme = true;
	level.hero.health = 99999999;

	wait 2;
	flag_clear("player_in_shop");
	level notify ("shop_area_clear");
	spot = getstructent("sarge_walk_along_spot", "targetname");
	
	level.hero.animname = "hero";
	animtime = getanimlength(level.scr_anim["hero"]["building_spin"]);
	spot anim_reach_solo(level.hero, "building_spin_door");
	flag_wait("done_chastising_inbar");
	level.hero set_run_anim("e1_street_run");
	thread move_along_road2();
}

move_along_road()
{
	event2_trigsoff();


	thread player_lingers_by_nearmiss();
	thread e2_backtrack_blocking();
	level.hero allowedstances("prone", "crouch", "stand");
	flag_set("opening_bar_still");
	flag_wait("outof_event1");
	
	level notify ("left_horch");


	thread break_stealth_but_player_canwin();
	level endon ("player_broke_stealth_inshop");
	


	spot = getstruct("sarge_walk_along_spot", "targetname");
	flag_wait("resnov_outof_event1");
	
	ramp = getent("e1_bar_ai_ramp", "targetname");
	ramp trigger_on();
	ramp connectpaths();
	
	thread maps\sniper_amb::change_music_state_delay(0, "STORY");
	wait 0.8;
	spot anim_single_solo(level.hero, "bar_lift_a");
	spot anim_single_solo(level.hero, "bar_lift_only");
	spot anim_single_solo(level.hero, "bar_lift_c");
	spot thread anim_loop_solo(level.hero, "bar_wait", undefined, "stoploop");
	flag_wait("player_passed_bar");
	spot notify ("stoploop");
	animtime = getanimlength(level.scr_anim["hero"]["bar_wave"]);
	spot anim_single_solo(level.hero, "bar_wave");
	//wait animtime - 0.05;
	//level.hero stopanimscripted();
	//level.hero play_anim_end_early( level.scr_anim["hero"]["bar_wave"], 0.05 );
	animtime = getanimlength(level.scr_anim["hero"]["building_spin"]);
	spot thread anim_single_solo(level.hero, "building_spin");
	wait animtime - 0.05;
	level thread move_along_road2();
}

///////////////////////////////////////////////		End Section 1 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	


////////////////// Section 2 - Controls gameplay of player on the road, before Sniper battle, after shop area\\\\\\\\\\\\\

move_along_road2()
{

	spot = getstruct("sarge_walk_along_spot", "targetname");
	level.hero.animname = "hero";

	
	animtime = getanimlength(level.scr_anim["hero"]["building_spin_door"]);
	spot thread anim_single_solo(level.hero, "building_spin_door");
	playsoundatposition ("bar_door_squeak", level.hero.origin);
		
		
	//level thread player_tooeager_toface_sniper("sniper_battle_started", "player_eager_toface_sniper");
	//level thread player_tooeager_toface_sniper("event2_started", "player_eager_toface_sniper_atwindow");
	
	level endon ("player_broke_stealth_inshop");
	level endon ("player_broke_stealth");
	wait animtime;
	
	spot notify ("stoploop");
	
	spot = getstruct("sarge_nextbuilding_align", "targetname");
	
	getent("E2_sniper_nearmiss_trig", "targetname") trigger_on();
	//spot anim_reach_solo(level.hero, "pacing_car_idle1_reach");
	spot thread anim_loop_solo(level.hero, "pacing_car_idle1", undefined, "stoploop");
	
	
	getent("E2_sniper_nearmiss_trig", "targetname") thread notify_and_set_flag("trigger", "player_at_nearshot_place");
	flag_wait("approach_nearshot");
	player_inopen_check();
	spot notify ("stoploop");
	spot anim_single_solo(level.hero, "pacing_car_truck");

	
	spot thread anim_loop_solo(level.hero, "pacing_truck_idle", undefined, "stoploop");
	player_inopen_check();
	spot notify ("stoploop");
	
	animtime = getanimlength(level.scr_anim["hero"]["pacing_truck_window"]);
	spot thread anim_single_solo(level.hero, "pacing_truck_window");
	wait animtime/2;
	level thread no_sniper_backtracking();
	wait animtime/2;

	flag_set("done_talking_by_nearmiss");
	spot thread anim_loop_solo(level.hero, "pacing_window_loop", undefined, "stoploop");
	

	thread sniper_battle_intro();

	flag_set("sarge_at_nearshot_place");
	thread sniper_dead_now();			// thread watching when sniper battle is over and to move on to BB event
	
}



sniper_battle_intro()
{

	level endon ("player_broke_stealth");
	flag_wait("player_at_nearshot_place");		// all the conditions to move on and have the nearmiss shot
	flag_wait("sarge_at_nearshot_place");
	flag_wait("done_talking_by_nearmiss");
	level notify ("event2_started");
	flag_clear("player_is_exposed");
		
	spot1 = getstruct("E2_sniper_nearmiss_shotspot", "targetname");
	spot2 = getstruct("E2_sniper_nearmiss_hitspot", "targetname");
	bullettracer(spot1.origin, spot2.origin, true);
	wait 0.25;
	
	spot = getstruct("sarge_nextbuilding_align", "targetname");
	
	thread reznov_wait_at_stair();

	wait 0.20;
	
	magicbullet ("mosin_rifle_scoped_noflash", spot1.origin, spot2.origin);
	flag_set("sniper_nearmiss_fired");
	
	spot notify ("stoploop");
	
	

	level	thread glass_break();
	node = getnode("whizby_node", "targetname");
	level notify ("stop_talking");
	wait 0.1;
	
	

	
	//TUEY switch music state to sniper
	setmusicstate ("SNIPER");
	

	wait 0.8;

	thread wait_and_notify(8,"sniper_second_shot");

	
	level waittill ("sniper_second_shot");
	if (!flag("inside_sniper_building"))
	{

		while(!flag("inside_sniper_building"))
		{
			magicbullet ("mosin_rifle_scoped_noflash", spot1.origin, get_players()[0] geteye());
			level.player thread kill_on_hit("inside_sniper_building", spot1.origin, spot1);
			wait 3;
		}
	}
	level notify ("inside_sniper_building");
	thread sniper_battle_start();
	wait 1.2;
	
	spot1 = getstruct("instore_shotspot", "targetname");
	spot2 = getstruct("instore_hitspot", "targetname");
	bullettracer(spot1.origin, spot2.origin, true);
	//magicbullet ("kar98k_scoped", spot1.origin, spot2.origin);
	magicbullet ("mosin_rifle_scoped_noflash", spot1.origin, spot2.origin);
	maps\_spawner::kill_spawnernum(200);
}
	

reznov_wait_at_stair()
{	
	maps\_spawner::kill_spawnernum(8);
	spot = getstruct("sarge_nextbuilding_align", "targetname");
	animtime = getanimlength(level.scr_anim["hero"]["pacing_window_roll"]);
	spot thread anim_single_solo(level.hero, "pacing_window_roll");
	spot = getstruct("stairbottom_node", "targetname");
	wait animtime - 0.5;
	if( level.hero.a.pose != "prone" )
	{
		level.hero.a.pose = "prone"; 
	}
	wait 0.7;
	level.hero anim_single_solo(level.hero, "pacing_window_roll_stand");
	spot anim_reach_solo (level.hero, "stair_in");
	animtime = getanimlength(level.scr_anim["hero"]["stair_in"]);
	spot anim_single_solo (level.hero, "stair_in");
	spot thread anim_loop_solo(level.hero, "stair_wait_loop", undefined, "stopmyloop");
	flag_wait("hero_ready_upstairs");
	player_inopen_check();
	spot notify ("stopmyloop");
	spot anim_single_solo(level.hero, "stair_wait");
	spot thread anim_loop_solo(level.hero, "stair_wait_loop", undefined, "stopmyloop");
	player_inopen_check();
	spot notify ("stopmyloop");
	animtime = getanimlength(level.scr_anim["hero"]["stair_out"]);
	level.hero enable_ai_color();
	//spot thread anim_single_solo (level.hero, "stair_out");
	spot thread anim_single_solo_earlyout(level.hero, "stair_out");
	
	level.hero.disablearrivals = true;
	level.hero.disableexits=true;
	wait animtime - 0.2;
	level notify ("up_stairs");
	level.hero set_run_anim("stair_run");
	//level.hero stopanimscripted();
}
/////////////////////////////////////////////////////// End Section 2 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\































////////////////////////////////////////// Section 5 - Burning building event \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
flame_building()
{
	level thread hero_downstairs_bb();
	level.hero.ignoreall = true;
	getent("e2_sarge_into_flame_building", "targetname") notify ("trigger");
	trig = getent("e2_sarge_into_flame_building2", "targetname");
	trig trigger_on();
	trig thread hero_opendoor_2();
	getent("E2_mean_patrollers", "target") waittill ("trigger");
	patrol_passes();
	thread building_burn();
	
	//TUEY change music state to "FIRE"
	setmusicstate("FIRE");
}
	
patrol_passes()
{
	players = get_players();
	array_thread(players, ::player_broke_bb_stealth);
	level endon ("player_broke_bb_stealth");
	battlechatter_on("axis");
	thread say_dialogue("shh_patrol");
	thread say_dialogue("let_them_pass");
	level.hero setcandamage(false);
	
	//TUEY Make the clock GONG to freak you out a bit before the dog gets to you
	level notify ("dog_is_coming");

	flag_wait("dog_found_you");
}

easy_prone_check()
{
	waittime = 0;
	if ( level.difficulty ==1 )
	{
		waittime = 4;
	}
	if ( level.difficulty ==2 )
	{
		waittime = 7;
	}
	if ( level.difficulty > 2 )
	{
		return;
	}
	
	wait waittime;
	level.hintelem = NewHudElem();
	level.hintelem maps\sniper_event1::init_results_hudelem(320, 160, "center", "bottom", 1.5, 1.0);
	level.hintelem setText(&"SNIPER_EASY_PRONE_DESC");
	while(get_players()[0] getstance() != "prone" )
	{
		wait 0.2;
	}
	wait 0.5;
	level.hintelem setText("");	
}

save_if_ready()
{
	while(1)
	{
		if (level.player.origin[0] > 2800)
		{
			level thread maps\_autosave::autosave_game_now( "bb_escape" );
			break;
		}
		wait 0.05;
	}
}

building_burn()
{
	
	if (level.player.origin[0] > 2700)
	{
		level thread maps\_autosave::autosave_game_now( "bb_escape" );
	}
	if (level.difficulty > 2)
	{
		getent("start_dem_flames", "script_noteworthy") delete();
	}
	
	level notify ("bb_escape_ison");
	flag_set("bb_escape_ison");
		
	level thread bookcase_fun();		// bookcase falls
	level thread ceiling1_fall();		// debris by door by stairs falls down
	level thread ceiling2_fall();		// debris at top of stairs falls down
	level thread furnace_burst();
	level thread bb_stairtop_scare();
	level.hero.grenadeawareness = 0;
	
	getent("dog_came_chain", "targetname") notify ("trigger");
	burntrigs = getentarray("window_flamer_trigs", "targetname");
	for (i=0; i < burntrigs.size; i++)
	{
		level.player thread trig_burn_u(burntrigs[i]);
	}
	
	level.hero thread waittill_and_setflag("goal", "sarge_redy2_prone_bb");
	
	//get_players()[0] thread player_speed_set(160,30);
	
	wait 1;
	blocker = getent("block_player_by_dog", "targetname");
	thread move_blocker_slowly(blocker, 20);
	//blocker delete();
	level thread easy_prone_check();
	

	getent("bb_floor2_trig", "script_noteworthy") thread notify_and_set_flag("trigger", "player_on_bb_floor2");
	spawners = getentarray("bb_outside_shooters", "targetname");
 	for (i=0; i < spawners.size; i++)
 	{
 		spawners[i] stalingradspawn();
 	}
	guys = getaiarray("axis");
	spots = getstructarray("left_side_bb_shotspots", "script_noteworthy");
	nodes = getnodearray("own_left_side_nodes", "script_noteworthy");
	nodecounter = 0;
	for (i=0; i < guys.size; i++)
	{
		if (guys[i].classname != "actor_axis_ger_ber_wehr_reg_flamethrower"  )
		{
			guys[i] notify ("enemy");
			guys[i] solo_set_pacifist(false);
			guys[i] stopanimscripted();
			guys[i] reset_run_anim();
			guys[i].goalradius = 32;
			guys[i] setgoalnode(nodes[nodecounter]);
			
			spot = spots[randomint(spots.size)] swap_struct_with_origin();
			
			spot thread delete_after_bb();
			
			guys[i] setentitytarget(spot);
			//nodecounter++;
		}
	}
	
	
	trig = 	getent("e2_flamer1", "target");
	trig thread wait_and_notify(3, "trigger");
	trig waittill ("trigger");
	VisionSetNaked("sniper_inside_fire",12);
	exploder(11);

	
	//TUEY Turn on the building fires
	level thread maps\sniper_amb::play_fire_sounds();

	//thread boards_falling();
	thread downstairs_burn_trigs();
	level.hero.dontavoidplayer = true;

	wait 1;

	getent("e2_flamer5", "targetname") stalingradspawn();
	sarge_getup_xcoord = 3440;
	
	
	
	players = get_players();
	array_thread(players, ::make_player_prone, sarge_getup_xcoord);
	wait 2;
	for(i=1; i < 5; i++)
	{
		trig = getent("fake_shots_"+i+"_trig", "targetname");
		trig thread fake_shots_init(i);
	}
	getent("burning_building_enemy_clip", "targetname") trigger_on();
	getent("burning_building_enemy_clip", "targetname") disconnectpaths();

		

	array_thread(players, ::player_knocked_down2);
	thread bb_sdk_own_wall();
	thread player_bb_jumpout();
	

	players = get_players();
	array_thread(players, ::by_window_trig);
	
	BadPlacesEnable(0);
}


move_blocker_slowly(thing, seconds)
{
	times = seconds*10;
	for (i=0; i < times; i++)
	{
		thing.origin = thing.origin+(2.7,0,0);
		wait 0.1;
	}
	thing delete();
}

make_player_prone(xcoord)
{
	self allowsprint(false);
	timedelay = 2;
	stay_down = undefined;
	while(self.origin[0] < xcoord)
	{
		if (self getstance() != "prone")
		{
		 get_players()[0] setblur( 0.2,  timedelay/2 );
		 magicbullet("mp40", (self geteye()) + (0,-30,0), self geteye());
		 if (self getstance() == "stand")
		 {
				self dodamage(50, self.origin+(0,-30,0));
		 }
		 self dodamage(20, self.origin+(0,-30,0));
		 wait timedelay/2;
		 get_players()[0] setblur( 0.2, timedelay/2 );
		 wait  timedelay/2;
		 if (timedelay > .3)
		 {
		 	timedelay = timedelay - .2;
		 }
		 if (timedelay < 1.7 && !isdefined(stay_down) && self.origin[0] < xcoord && self.origin[1] > -700)
		 {
		 	thread say_dialogue("stay_down");
		 	stay_down = 1;
		 }
		}
		wait 0.05;
	}
}


fake_shots_init(num)
{
	self waittill ("trigger");
	spot1 = getstruct("fake_shots_"+num+"_start", "targetname");
	spot2 = getstruct("fake_shots_"+num+"_target", "targetname");
	maxshots = randomintrange(3,6);
	for (x=0; x < maxshots; x++)
	{
		shootspot = spot1.origin + ((randomint(20) - randomint(20)), 0,0);
		magicbullet("mp40", shootspot, spot2.origin );
		bullettracer(shootspot, spot2.origin, true);
		wait 0.11;
	}

	//TUEY Change Music State to SNIPER
//	setmusicstate ("SNIPER");
}

player_broke_bb_stealth()
{
	level endon ("bb_escape_ison");
	self thread stealth_checker();
	level waittill ("stealthbreak");
	level notify ("stop_talking");
	wait 0.01;
	flag_set ("dog_found_you");

}

tank_luvs_u()
{
	self endon("death");
	self setspeed (0,5,5);
	getent("bb_sdk", "targetname") setspeed (0,10,10);
	while (isalive(self))
	{
		shoottime = randomintrange(2,6);
		cantanksee = false;
		players = get_players();
		tanktarget = players[randomint(players.size)];
		if (self.health > 0) 
		{
			self setTurretTargetvec (tanktarget geteye() );
		}
		wait shoottime;
		waittime = 0.3;
		while(shoottime > waittime)
		{
			tag = self gettagorigin("tag_flash");
			success = bullettracepassed(tag+(0,0,15), tanktarget.origin, true, tanktarget);
			if (success == true)
			{
				self fireweapon();
			}
			wait waittime;
			waittime = waittime + 0.3;
		}
	}
}

upstairs_checker()
{
	trig = getent("player_upstairs_now_trig", "targetname");
	trig waittill ("trigger");
	level notify ("player_just_got_upstairs");
	wait 1.5;
	level thread upstairs_burn_trigs();
	
	for (i=1; i < 7; i++)
	{
		trig = getent("fire_chase_"+i, "targetname");
		players = get_players();
		array_thread(players, ::trig_burn_u,trig);
	}
	for (i=1; i < 6; i++)
	{
		stop_exploder(i);
	}
	curtains = getentarray("bb_curtains", "script_noteworthy");		// clean up curtains and their fx
	for(i=0; i < curtains.size; i++)
	{
		curtains[i] delete();
	}
	
}

downstairs_burn_trigs()
{
	level thread upstairs_checker();
	level endon ("player_just_got_upstairs");
	wait 3;
	waittime = 20;
	increment = 1;
	
	switch(getdifficulty() )
	{
		case "easy":
		{
			waittime = 25;
			increment = 0.5;
			break;
		}
		case "medium":
		{
			waittime = 22;
			increment = 0.7;
			break;
		}
		case "difficult":
		{
			waittime = 15;
			increment = 0.4;
			break;
		}
		case "fu":
		{
			waittime = 13;
			increment = 0.4;
			break;
		}
	}
	
	for (i=1; i < 13; i++)
	{
		trig = getent("start_dem_flames", "script_noteworthy");
		if (i==2 && isdefined(trig))		// in case player was slow so they aren't stuck in infinite death loop
		{
			trig delete();
		}
		
		if (flag("player_at_burntrig5") )
		{
			if (i < 4)
			{
				i = 4;
			}
			waittime = waittime / 2;
			flag_clear("player_at_burntrig5");
		}
		
		if (i==8)
		{
			flag_wait("player_up_after_fall");
			wait 3;
			waittime = 3;
		}
		trig = getent("fire_chase_"+i, "targetname");

		players = get_players();
		array_thread(players, ::trig_burn_u,trig);
		
		for (j=0; j < waittime; j++)
		{
			wait 1;
			if (flag("player_up_after_fall") && i < 7 )
			{
				i = 7;
				break;
			}
		}
		if (waittime > 3)
		{
			waittime= waittime -increment;
		}
	}
}


upstairs_burn_trigs()
{
	wait 5;
	waittime = 8;
	for (i=7; i < 13; i++)
	{
		if (i==8)
		{
			flag_wait("player_up_after_fall");
			wait 10;
		}
		trig = getent("fire_chase_"+i, "targetname");

		players = get_players();
		array_thread(players, ::trig_burn_u,trig);
		
		wait waittime;
		waittime--;
	}
}


trig_burn_u(trig)
{
	//trig notify ("newthread");
	level endon ("roll_done");
	self endon ("death");
	while(1)
	{
		if (self istouching(trig)&& !flag("boards_onu") )
		{
			self setburn(0.5);
			self setblur(2,0.6);
			wait 0.3;
			self dodamage(25, self.origin);
			wait 0.3;
			self setblur(0,0.1);
		}
		wait 0.1;
	}
}

by_window_trig()
{
	flag_wait("player_on_bb_floor2");
	trig = getent("player_close_to_window_trig", "targetname");
	while(1)
	{
		if (self istouching(trig) && self getstance()== "stand" )
		{
			//magicbullet("kar98k_scoped", (self geteye()) + (0,-30,0), self geteye());
			magicbullet("mosin_rifle_scoped_noflash", (self geteye()) + (0,-30,0), self geteye());
			self dodamage(10, self.origin+(0,-30,0));
			wait 1;
		}
		wait 0.2;
	}
}
/*
boards_falling()
{
	for (i=1; i < 8; i++)
	{
		trig = getent("falling_boards_pos"+i+"_trig", "targetname");
		trig waittill ("trigger");
		spots = getentarray("falling_boards_pos"+i, "targetname");
		for(j=0; j < spots.size; j++)
		{
			//playfx(level._effect["fallingboards_fire"], spots[j].origin);
		}
	}
}
*/

player_out_of_bb()
{
	maps\_spawner::kill_spawnernum(203);
	
	level notify ("bb_sequence_over");
	for (i=9; i < 12; i++)
	{
		stop_exploder(i);
	}

	
	guys = getentarray("E2_mean_patrollers", "targetname");
	for (i=0; i < guys.size; i++)
	{
		guys[i] delete();
	}
	self shellshock( "tankblast", 5 );// fade out over 1 sec, wait 2, fade in over 5
	self allowstand(false);
	self allowcrouch(false);
	self allowprone(true);
	self allowjump(false);
	self setstance("prone");
	self thread	player_speed_set(0.5, 1);
	self Setclientdvar( "bg_prone_yawcap", "15" );
	self.nopronerotation = true;
	spot = getstructent("alleyguys_node", "targetname");
	
	self shellshock( "aftermath", 20 );// fade out over 1 sec, wait 2, fade in over 5
	level waittill ("k_getup");
	animtime = getanimlength(level.scr_anim["hero"]["kicked_vignette"]);
	
	wait animtime - 1;
	getent("e3_allies_saveu_chain", "targetname") notify ("trigger");
	wait 1;	
	spot thread anim_loop_solo(level.hero, "kicked_loop", undefined, "stoploop");
	
	
	level.alleyguys_dead = 0;
	guys = getentarray("wounded_fountain_guys", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i] dodamage(guys[i].health * 10, (0,0,0));
	}
	thread maps\sniper_event3::e3_transition_dialogue();
	thread maps\sniper_event3::e3_sniping_cover_battle();
	
	flag_wait("friendlies_vignette_go");
	spot notify ("stoploop");
	wait 0.1;
	
	level.hero enable_ai_color();
	
	self thread	player_speed_set(140, 3);
	self enableweapons();
	self Setclientdvar( "bg_prone_yawcap", "85" );
	self.nopronerotation = false;
	self allowstand(true);
	self allowcrouch(true);
	self allowjump(true);
	self allowsprint(true);
	
}

player_knocked_down2()
{
	stop_exploder(7);
	player = self;
	
	level thread armored_car_line();
	level thread chandolier_notify();
	level thread chandolier_fall();
	
	beams = getentarray("burning_beam", "targetname");
	for (i=0; i < beams.size; i++)
	{
		beams[i] moveto(beams[i].origin+(0,0,300), 0.1 );
	}
	getent("falling_boards_pos6_trig", "targetname") waittill ("trigger");
	
			// in case hero is still back downstiars
	level notify ("boardfall_time");
	level.hero.ignoreall = true;
	level.hero.ignoreme = true;
	level.hero.pacifist = true;
	level.hero ClearEnemy();
	level.hero allowedstances("prone","stand", "crouch");


	level.hero stopanimscripted();
	
	level.hero set_run_anim("runcough1");
	earthquake(0.5, 1, level.player.origin, 500);
	
	guys = getentarray("bb+_runup_nshoot_dudes", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i] delete();
	}
	
	spots = getstructent("bb_debris_fallonu", "targetname");
	playfx(level._effect["debris_fall"], spots.origin, anglestoforward(spots.angles) );


	//TUEY Plays 2D sound of the boards
	playsoundatposition("celing_collapse_start", (0,0,0));
	
	//TUEY SEtS Music State to "CELING"
	setmusicstate("CELING");
	player thread	player_speed_set(5, 3);	
	
	get_players()[0] allowstand(true);
	get_players()[0] allowcrouch(false);
	get_players()[0] allowprone(false);
	get_players()[0] allowjump(false);
	get_players()[0] setstance("stand");
	wait 0.5;
	spots delete();
	
	spot = getstruct("new_crawlout_align_node", "targetname");
	spot notify ("stoploop");



	level thread beams_fall(); // here is the beam falling anim magic
	
	resnov_align = getnode("bb_debris_align_node", "targetname");
	player = self;
	
	
	spot = getstructent("hallsmoke_fxspot", "targetname");
	playfx(level._effect["bb_hall_smoke"], spot.origin, anglestoforward(spot.angles));
	
	level waittill ("resnov_save_u_go");

	
	
	spot delete();
	
	
	level.hero.animname = "hero";

	animtime = getanimlength(level.scr_anim["hero"]["resnov_beam_up"]);
	resnov_align thread hero_liftbeam_torun();
	
	board = getent("board_tomove", "script_noteworthy");
	
	level waittill ("beam_lift_time");
	

	
	level waittill ("player_up");

	blocker = getentarray("bb_doorblocker", "targetname");
	for (i=0; i < blocker.size; i++)
	{
		blocker[i] moveto(blocker[i].origin+(0,0,10000), 0.1);
	}


	getent("player_postsave_chain", "targetname") notify ("trigger");
	
	player Setclientdvar( "bg_prone_yawcap", "85" );
	player.nopronerotation = false;
	get_players()[0] allowstand(true);
	get_players()[0] allowcrouch(true);
	get_players()[0] allowprone(true);
	get_players()[0] allowjump(true);
	get_players()[0] setstance("stand");
	player thread	player_speed_set(150, 5);	
	wait 1;
	get_players()[0] stopshellshock( );
	//get_players()[0] enableweapons();
	//get_players()[0] thread	player_speed_set(190, 3);	

	wait animtime - 3;
}

hero_liftbeam_torun()
{
	level.hero.animname = "hero";
	self anim_single_solo(level.hero,"resnov_beam_up");
	spot = getstructent("hero_bigfall_react", "targetname");
	spot anim_reach_solo(level.hero, "bb_stumble1");
	animtime = getanimlength(level.scr_anim["hero"]["bb_stumble1"]);
	spot thread anim_single_solo(level.hero, "bb_stumble1");
	wait animtime - 0.5;
	level.hero stopanimscripted();
	level.hero enable_ai_color();
}

player_bb_jumpout()
{	
	getent("jump_now_comrade_trig", "targetname") waittill ("trigger");
	thread say_dialogue("jump");
	player = get_players()[0];

	trig = getent("jump_trig", "targetname");
	trig waittill ("trigger");

	player playsound ("player_land_outside");

	flag_set("stop_deathstar_fx");
	flag_clear("limp2");
	maps\_spawner::kill_spawnernum(203);
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		guys[i] delete();
	}
	
	ospot = getstruct("jump_spot", "targetname");
	spot = ospot swap_struct_with_origin();
	
	exploder(12);
	
	player lerp_player_view_to_position( spot.origin, spot.angles, .2, .7, 2, 2, 2, 2, undefined );
	
	spot delete();
	
	ospot = getstruct("roll_spot", "targetname");
	spot = ospot swap_struct_with_origin();
	
	player lerp_player_view_to_position( spot.origin, spot.angles, .2, .7, 2, 2, 2, 2, undefined );
	player dodamage(1,player.origin+(0,0,20));

	earthquake(0.5,0.5, level.player.origin, 300);
	
	player playerlinktoabsolute(spot);
	
	player disableweapons();
	//spot moveto( (4266, -665.5, spot.origin[2]), 7);
	spot moveto( spot.origin + (0,30,0), 0.5);
	spots = getstructarray("rollspots", "script_noteworthy");
	time = 0;
	VisionSetNaked("Sniper_default",1);
	
	player allowstand(false);
	player setstance("crouch");
	
	for (i=1; i < 12; i++)
	{
		if (i==1)
		{
			time = 0.15;
		}
		if (i==3)
		{
			time = 0.2;
		}
		if (i==4)
		{
			level	thread guy_jumpout_window();
			time = 0.13;
		}
		if (i==5)
		{

			time = 0.76;
		}
		if (i==6)
		{
			time = 0.63;
		}
		if (i==7)
		{
			time = 0.13;
			level notify ("outta_sight_outta_mind");
			spot moveto( spot.origin + (0,125,0), 0.5);
		}
		if (i==8)
		{

			//level.hero stopanimscripted();

			time = 0.12;
		}
		if (i==9)
		{
			time = 0.11;
		}
		rollspot = getstruct("rollspot"+i, "targetname");
		spot rotateto( rollspot.angles, time);
		wait time;
			
	}
	
	level notify ("roll_done");
	
	player unlink();
	
	spot delete();

	player thread player_out_of_bb();
}


guy_jumpout_window()
{
		level.hero.grenadeawareness = 1;
		level notify ("hero_jumping_out");
		if (isdefined(level.bb_jumpout_spot))
		{
			level.bb_jumpout_spot notify ("stoploop");
		}
		level.hero allowedstances("stand", "crouch", "prone");
		guy = level.hero;
		guy.animname = "hero";
		spot = spawn("script_origin", guy.origin);
		

		ospot = getstruct("animspot", "targetname");
		animspot = ospot swap_struct_with_origin();
	
		ospot = getstruct("alleyguys_node", "targetname");
		animspot2 = ospot swap_struct_with_origin();

		animspot thread anim_single_solo(guy, "bb_jumpout");

		wait 0.8;
		fxspot = getstructent("blowspot", "targetname");
		playfx(level._effect["temp_bb_explode"], fxspot.origin, anglestoforward(fxspot.angles) );
		earthquake(0.4, 2, level.player.origin, 500);
		level.player playrumbleonentity("explosion_generic");
		
		//TUEY play the explosion sound
		fxspot playsound ("exp_second_floor");		

		//TUEY Set music state to "EXPLOSION"
		setmusicstate("EXPLOSION");

		//level waittill ("outta_sight_outta_mind");
		//level.hero stopanimscripted();
		level.hero linkto(animspot);
		level waittill ("roll_done");
		wait 0.1;
	
		level.hero stopanimscripted();
		animtime = getanimlength(level.scr_anim["hero"]["bb_jumproll"]);
		animspot2 thread anim_single_solo(guy, "bb_jumproll");
		level.hero unlink();
		fxspot delete();
		wait animtime;
		
		animspot2 thread anim_loop_solo(level.hero, "bb_proneloop", undefined, "stoploop");
		getent("e3_alley_kicker", "targetname") stalingradspawn();
		getent("e3_alley_leader", "targetname") thread wait_and_spawn(1.3);
		level waittill ("alley_kicker_inplace");
		animspot2 notify ("stoploop");
		animspot2 thread anim_single_solo (level.hero, "kicked_vignette");
		level notify ("k_getup");
}

hero_wait_byhole()
{
	level endon ("hero_jumping_out");
	spot = getstructent("alleyguys_node", "targetname");
	level.bb_jumpout_spot = spot;
	spot anim_reach_solo(level.hero, "resnov_hole_talk");
	spot anim_single_solo(level.hero, "resnov_hole_talk");
	spot thread anim_loop_solo(level.hero, "resnov_hole_wait", undefined, "stoploop");
}
	

bb_sdk_own_wall()
{	
	level thread yahoo_fx();
	level thread beams_shot();
	getent("sdk_fire_trig", "targetname") waittill ("trigger");
	
	level thread hero_wait_byhole();
	flag_set("limp2");
	sdk = getent("bb_sdk", "targetname");
	for (i=13; i > 0; i--)
	{
		spots = getentarray("hole_"+i, "targetname");
		//sdk setturrettargetvec(spots[0].origin);
		level.player playrumbleonentity("damage_light");
		wait 0.217;
		//sdk fireweapon();
		
		earthquake (0.35, 0.2, get_players()[0].origin, 500);
		playfx(level._effect["temp_20mm_impact"], (spots[0].origin[0], -1030,spots[0].origin[2]) );
		spots[0] thread maps\sniper_amb::play_house_debris_sounds();
		for (j=0; j < spots.size; j++)
		{
			radiusdamage((spots[j].origin[0], spots[j].origin[1], (get_players()[0].origin[2]+10) ), 100, 10, 15);
			spots[j] hide();
		}



	}
	for (i=1; i < 14; i++)
	{
		spots = getentarray("hole_"+i, "targetname");
		//sdk setturrettargetvec(spots[0].origin);
		wait 0.25;
		earthquake (0.35, 0.2, get_players()[0].origin, 500);
		playfx(level._effect["temp_20mm_impact"], (spots[0].origin[0], -1030,spots[0].origin[2]) );
		spots[0] thread maps\sniper_amb::play_house_debris_sounds();
		for (j=0; j < spots.size; j++)
		{
			radiusdamage( (spots[j].origin[0], spots[j].origin[1], (get_players()[0].origin[2]+10) ) , 300, 80, 90);
			spots[j] delete();
		}
		//sdk fireweapon();

	}
}
		

/////////////////////////////////////////////////////// End Section 5 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
























////////////////////////////////////////////// Section 4 - Sniper Battle  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


animtime_notify(time)
{
	//assertex(isdefined(time), "time isn't defined");
	if(isdefined(time))
	{
		flag_set("sniper_animating");
		wait (time);
		flag_clear("sniper_animating");
	}
	level notify ("shootanim_done");
}

bombers_continue()
{
	level endon ("e2_sniper_dead");
	level thread maps\sniper_event1::no_double_shake(5);
	while(1)
	{
		level thread maps\sniper_event1::bomber_wave_come("bombers_sniperwave", 1, 3, 3000);
		wait 50;
	}
}
sniper_battle_start()
{
	
	//level.mannequinn = spawn ("script_model", (2104.38, -1072.23, 150.616));
	//level.mannequinn.angles = (359.835 , 206.353 , 0.000736663);
	//level.mannequinn.model = ("static_berlin_mannequin");
	stop_exploder(100); // delete fountain exploder
	level thread bombers_continue();
	
	level.player_hits_sustained = 1;
	if (cointoss())
	{
		level.e2sniper = getent("sniper1", "script_noteworthy") stalingradspawn();
	}
	else
	{
		level.e2sniper = getent("sniper2", "script_noteworthy") stalingradspawn();
	}
	

	level.e2sniper endon ("death");
	level.e2sniper thread give_ammo_to_stupid_player();

	level.hero.disablearrivals = true;
	level.hero.disableexits=true;
	wait 2;
	level.hero.animname = "hero";
	spot = getstruct("stairbottom_node", "targetname");
	//spot anim_reach_solo (level.hero, "stair_out");
	flag_set("hero_ready_upstairs");
	level waittill ("up_stairs");
	//level.hero set_run_anim("stair_run");
	newspot = getstruct("mannequin", "targetname");
	newspot anim_reach_solo (level.hero, "mannequin_entrance");
	newspot anim_single_solo (level.hero, "mannequin_entrance");
	newspot thread anim_loop_solo(level.hero, "mannequin_wait", undefined, "stoploop");
	wait 1;
	player_inopen_check();
	level thread maps\_utility::autosave_by_name( "reznov_goin_in" );
	thread objective_controller(4);
	flag_wait("E2_second_floor_room2_flag");
	player_inopen_check();
	
	//level.hero reset_run_anim();
	newspot notify ("stoploop");
	newspot anim_single_solo (level.hero, "mannequin_entrance_dialog");
	newspot thread anim_loop_solo(level.hero, "mannequin_wait", undefined, "stoploop");
	player_inopen_check();
	newspot notify ("stoploop");
	level notify ("sniper_battle_started");
	newspot thread anim_single_solo(level.hero,"mannequin_in");
	level.hero set_run_anim("e1_street_run");
	level.hero.disablearrivals = true;
	level.hero.disableexits=true;
		
	animtime = getanimlength(level.scr_anim["hero"]["mannequin_in"]);
	wait animtime - 0.09;
	level.hero set_run_anim("e1_street_run");
	level.hero stopanimscripted();
	level.hero set_run_anim("e1_street_run");
	level.sniper_looking_max = 1;
	
	//newspot thread anim_reach_solo(level.hero,	"mannequin_loop1_reach");
	
	//wait 0.5;
	
	ospot = getstruct("sniper_aim_here", "targetname");
	aimspot = ospot swap_struct_with_origin();
	
	nodenum = level.e2sniper.currentnum;
	node = level.e2sniper.currentnode;
	
	level thread sniper_shoot(aimspot, undefined, node ,nodenum);
		
	//level.hero.disablearrivals = true;
	//level.hero.disableexits=true;
	newspot anim_reach_solo(level.hero,	"mannequin_slide_in");
	//node = getnode("e2_mannequin_slide_hacknode", "targetname");
	//level.hero setgoalnode(node);
	//level.hero.goalradius = 8;
	//wait 0.1;
	//level.hero waittill ("goal");
	
	newspot anim_single_solo(level.hero,	"mannequin_slide_in");
	
	newspot thread anim_loop_solo(level.hero,	"mannequin_loop1", undefined, "stoploop");
		
	if (level.difficulty < 3 )
	{
		hero_call_sniper_pos(nodenum, 1);
		level thread hero_mannequin_anims(newspot);
		headspot = ( 2092.09, -1045.86, 223.12); // pulled this out of debugger for head tag
		spot2 = spawn("script_origin", headspot);
		level.mannequin_headspot = headspot;	// for reference in another thread

		//ang = ( 359.952, 206.387, -0.0714356 )
	
		// do hero animations of moving mannequin
	
		level thread mannequin_damage_control(spot2);	// use damage trigger to see when mannequin is hit

		level waittill ("mannequin_fall");
		sniper_shoot(spot2);
	}
	else
	{
		newspot notify ("stoploop");
		newspot anim_single_solo(level.hero,	"mannequin_loop3_dialog1");
		newspot thread anim_loop_solo(level.hero,	"mannequin_loop3", undefined, "stoploop");
		level thread maps\_autosave::autosave_game_now( "hard_sniper" );
	}
	level thread player_vs_sniper();
	flag_set("player_shotat_sniper");
}

hero_mannequin_anims(newspot)
{
	level.e2sniper endon ("death");
	animtime = getanimlength(level.scr_anim["hero"]["mannequin_push"]);
	newspot anim_single_solo(level.hero,	"mannequin_push");
	newspot notify ("stoploop");
	newspot thread anim_loop_solo(level.hero,	"mannequin_endpush_loop", undefined, "stoploop");
	flag_wait ("mannequin_hit");
	newspot notify ("stoploop");
	newspot anim_single_solo(level.hero,	"mannequin_back");
	newspot anim_single_solo(level.hero,	"mannequin_loop3_dialog1");
	newspot thread anim_loop_solo(level.hero,	"mannequin_loop3", undefined, "stoploop");
}

dontlet_player_on_snipers_back()
{
	level.e2sniper endon ("death");
	while(1)
	{
		windowtrig = getent("sniper_hidespot_bot", "targetname");		// this node is visible when sniper is hiding, so dont want to use it
		if (level.player istouching(windowtrig) &&  level.e2sniper.currentnum == 7)
		{
			flag_set("player_shotat_sniper");
			wait 10;
		}
		wait 1;
	}
}

animspot_cleaner()
{
	level waittill ("animspot_clean");
	self notify ("stopidle");
	self delete();
}

sniper_on_u(trig, player)
{
	level.e2sniper endon ("death");
	level notify ("newspot");
	level endon ("newspot");
	spot = spawn("script_origin", player geteye() );			// last spot to shoot at?
	counter = 0;
	dontshoot = true;
	wait 1;
	spintimes = 0;
	gothismany = undefined;



	nodes = getnodearray(level.e2sniper.script_noteworthy+"_hide_nodes", "script_noteworthy");
	node = undefined;
	if (!isdefined( level.e2sniper.currentnode) || !isdefined( level.e2sniper.currentnum) )		// give sniper a node if he doesnt have one
	{
		num = randomintrange(1,nodes.size);
		level.e2sniper.currentnum = num;
		level.e2sniper.currentnode = getnode(level.e2sniper.script_noteworthy+"_pos_"+num, "targetname");
	}
	
	
	while(1)	// this loop has the sniper wait, pick a node to shoot from, decide whether to shoot or not, and maybe pass the window
	{
		flag_waitopen("sniper_animating");		// waits till snipers last shoot animation is done
		level.e2sniper.currentnode.counter = level.nodefindticker;		// I believe this has to do with not going to a node he's been to in the last 3 times
		lastnode = level.e2sniper.currentnode; 
		num = level.e2sniper.currentnum;															
		level.nodefindticker++;				// I believe this has to do with not going to a node he's been to in the last 3 times
		sniper_run_direction = undefined;								//
		
		
		
		

		level notify ("animspot_clean");
		
		level.e2sniper stopanimscripted();		// stop what he's doing, probably looping, even though his last anim should be done
		
		
			while(1)	// get his next node, next to the current one
			{
				if (cointoss())			// go to players left!
				{
					num = level.e2sniper.currentnum+randomint(3);		
					possiblenode = getnode(level.e2sniper.script_noteworthy+"_pos_"+num, "targetname");	// does this node exist?
					if (isdefined(possiblenode))
					{
							// So, if he's been to this node, it has a .counter, every time he moves the ticker goes up, so if he's been this node in his last 2 moves, he'll skip and find a new node, keeps him moving around
						if ( isdefined(possiblenode.counter) && ( (level.nodefindticker - possiblenode.counter) < 3) )
						{
							continue;
						}
						
						windowtrig = getent("sniper_hidespot_bot", "targetname");		// this node is visible when sniper is hiding, so dont want to use it
						if (level.player istouching(windowtrig) && num == 7)
						{
							continue;
						}
						
						node = possiblenode;
						//** TEMP - I think that the .currentnum and .currentnode should always be set at same time
						//level.e2sniper.currentnum = num;
						sniper_run_direction = "right";
						break;
					}
				}
				else 
				{
					num = level.e2sniper.currentnum-randomint(3);
					possiblenode = getnode(level.e2sniper.script_noteworthy+"_pos_"+num, "targetname");
					if (isdefined(possiblenode))
					{
						if ( isdefined(possiblenode.counter) && ( (level.nodefindticker - possiblenode.counter) < 3) )
						{
							continue;
						}
						
						windowtrig = getent("sniper_hidespot_bot", "targetname");		// this node is visible when sniper is hiding, so dont want to use it
						if (level.player istouching(windowtrig) && num == 7)
						{
							continue;
						}
						
						node = possiblenode;
						// ** TEMP - see above explanation
						//level.e2sniper.currentnum = num;
						sniper_run_direction = "left";
						break;
					}
				}
				wait 0.05;
			}
			

			level.e2sniper setgoalnode(node);
			level.e2sniper thread goal_failsafe(6);	// was having pathing issues, will warp to avoid stuck
			level.e2sniper waittill("goal");
			wait 0.5;		// let him get into cover position
			
			level.e2sniper.currentnode = node;
			level.e2sniper.currentnum = num;

			myanimname = undefined;
			luck = randomint(100);
			difficulty_chance =  level.difficulty * 25;

				// the chance is misleading, its pretty much half of what I give it, since there is a good chance he will backtrack which breaks the loop
			if (luck > difficulty_chance && isdefined(node) && level.difficulty < 3 && spintimes < 2)		// a chance that the sniper does a pass by the window without shooting
			{
				while(1) // find an appropriate direction and number of nodes to move
				{
										
					switch (node.type)
					{
						case "Cover Right":
							myanimname = "sniperL_pass";
							gothismany = 1;
							break;
						case "Cover Left":
							myanimname = "sniperR_pass";
							gothismany = -1;
							break;
					}	
					
					if (myanimname == "sniperR_pass" && isdefined(sniper_run_direction) && sniper_run_direction == "right")		// make sure sniper doesn't backtrack
					{
						break;					
					}
					
					if (myanimname == "sniperL_pass" && isdefined(sniper_run_direction) && sniper_run_direction == "left")		// make sure sniper doesn't backtrack
					{
						break;
					}
										
					
					mynum = num+gothismany;	// go right or left
					
					possiblenode = getnode(level.e2sniper.script_noteworthy+"_pos_"+mynum, "targetname");
					
					windowtrig = getent("sniper_hidespot_bot", "targetname");		// this node is visible when sniper is hiding, so dont want to use it
					if (level.player istouching(windowtrig) && mynum == 7)
					{
						break;
					}
					
					if (isdefined(possiblenode))
					{
						keys = getarraykeys(level.scr_anim[myanimname]);
						passanim = keys[randomint(keys.size)];
						level.e2sniper.animname = myanimname;
						level.e2sniper thread goal_failsafe(6);
						animspot = spawn("script_origin", node.origin+(0,0,8.865));
						animspot thread animspot_cleaner();
						animspot.angles = node.angles;
						level.e2sniper setgoalnode(node);
						level.e2sniper waittill ("goal");
						
						animtime = getanimlength(level.scr_anim[ level.e2sniper.animname ][ passanim]);
						
						flag_set("sniper_animating");
						animspot anim_single_solo(level.e2sniper, passanim);
						flag_clear("sniper_animating");  // makes sniper not reset until done animating
	
						level.e2sniper.animname = "sniperR";
						animspot.origin = node.origin+(0,0,8.865);
						animspot thread anim_loop_solo(level.e2sniper, "idle_R", undefined, "stopidle");
						level.lastanimspot = animspot;	
	
						node = possiblenode;
						level.e2sniper.currentnode = node;
						level.e2sniper.currentnum = mynum;
						num = mynum;
						spintimes++;
						break;
					}		// end going to node
					
				}		// end while	nodesearch loop
			}			// end if luck > difficulty
			


		level notify ("animspot_clean");
		
		level.e2sniper.animname = "sniperR";
		animspot = spawn("script_origin", node.origin+(0,0,8.865));
		animspot.angles = node.angles;
		level.lastanimspot = animspot;
		level.lastanimspot thread animspot_cleaner();
		animspot.origin = level.e2sniper.currentnode.origin+(0,0,8.865);
		animspot thread anim_loop_solo(level.e2sniper, "idle_R", undefined, "stopidle");

		
		wait randomfloat(8.5);
		

		if ( (isdefined(trig) && player istouching(trig) ) || level.difficulty > 2  )
		{
			player = get_players()[0];
			spot delete();
			spot = spawn("script_origin", player geteye() );
			dontshoot = undefined;
			counter = 0;
			
			chance = randomint(100);
			if (!isdefined(level.helmet_trick_done) && chance > 75 && level.e2sniper.currentnum < 7)
			{
				helmet_ona_stick(node);
			}
			
			flag_set("sniper_found_player");
			sniper_shoot(get_players()[0], undefined, node, num);
			
			if (level.difficulty ==1 )
			{
				level.sniper_looking_max = level.sniper_looking_max+1;
			}
			if (level.difficulty ==2 && cointoss() )
			{
				level.sniper_looking_max = level.sniper_looking_max + .5;
			}
		}
		
		else
		{
			flag_clear("sniper_found_player");
			counter ++;
			dontshoot = true;

			level.sniper_looking_max = level.sniper_looking_max + 1/level.difficulty;
			
			sniper_shoot(spot, dontshoot, node, num);
			if ( counter > level.sniper_looking_max || counter > (7 - level.difficulty) )
			{
				flag_set("player_shotat_sniper");
			}
			
		}
		wait randomfloatrange(3,7);
	}
}


sniper_shoot(shotspot, dontfire, node, num)		// node is the node to shoot from, num is the number of that node, marks where it is
{

	level endon ("newspot");
	level.e2sniper endon ("death");
			
	level notify ("animspot_clean");
		
			
	if (!isdefined(num))
	{
		num = level.e2sniper.currentnum;
	}
	
	
	if (!isdefined(node))
	{
		node = level.e2sniper.currentnode;
	}
	
	level.e2sniper.currentnode = node;
	level.e2sniper.currentnum = num;
	
	level notify ("end_current_shoot");
	level endon ("end_current_shoot");
	notplayer = undefined;
	if (shotspot != get_players()[0])
	{
		shotspot = shotspot.origin;
		notplayer = true;
	}
	myanim = undefined;
	toss = 0;			 // 1 is left node, 2 is right node, for animation deciding purposes
	shootnow = false;
	xnum = undefined;						//potentially used to store node that sniper goes to when using the "pass shoot" animation 
	xpossiblenode = undefined;	//

	while(shootnow ==false)
	{
		shootnow = true;

		if (node.type == "Cover Right" )
		{
			level.e2sniper.animname = "sniperL_shoot";
			toss = 1;
			keys = getarraykeys(level.scr_anim[level.e2sniper.animname]);
			myanim = keys[randomint(keys.size)];
			if (num > 5)		// this particular node is too low to duck and shoot
			{
				myanim = "shoot_left_hi";
			}
			
			if ( (isdefined(dontfire) || level.difficulty < 3)  && cointoss()&& !isdefined(level.sniper_wasout_lasttime) )
			{
				if (level.sniper_looking_max > 5 && level.sniper_looking_max < 9)
				{
					level.e2sniper.animname = "sniperL_scan";
					myanim = "scanL_lo";
					dontfire = 1;
				}
				else if (level.sniper_looking_max > 9 )
				{
					level.e2sniper.animname = "sniperL_scan";
					myanim = "scanL_hi";
					dontfire = 1;
				}
			}
			
			if (myanim == "shoot_pass")
			{
				xnum = level.e2sniper.currentnum+1;
				xpossiblenode = getnode(level.e2sniper.script_noteworthy+"_pos_"+xnum, "targetname");
				if (!isdefined(xpossiblenode))
				{
					shootnow = false;
				}
			}
						
		}
		if (node.type == "Cover Left")
		{
			level.e2sniper.animname = "sniperR_shoot";
			toss = 2;
			keys = getarraykeys(level.scr_anim[level.e2sniper.animname]);
			myanim = keys[randomint(keys.size)];
			if (num > 6 || num==0)		// this particular node is too low to duck and shoot
			{
				myanim = "shoot_right_hi";
			}			
			
			if ((isdefined(dontfire) || level.difficulty < 3)  && cointoss() && !isdefined(level.sniper_wasout_lasttime) )
			{
				if (level.sniper_looking_max > 5 && level.sniper_looking_max < 9)
				{
					level.e2sniper.animname = "sniperR_scan";
					myanim = "scanR_lo";
					dontfire = 1;
				}
				else if (level.sniper_looking_max > 9  )
				{
					level.e2sniper.animname = "sniperR_scan";
					myanim = "scanR_hi";
					dontfire = 1;
				}
			}
					
			if (myanim == "shoot_pass")		// checks to see if there is a node to pass to
			{
				xnum = level.e2sniper.currentnum-1;
				xpossiblenode = getnode(level.e2sniper.script_noteworthy+"_pos_"+xnum, "targetname");
				if (!isdefined(xpossiblenode))
				{
					shootnow = false;
				}
			}
				
		}
		wait 0.05;
	}

	
	animspot = spawn("script_origin", node.origin+(0,0,8.865));
	animspot.angles = node.angles;
	animspot thread animspot_cleaner();
	animtime = getanimlength(level.scr_anim[ level.e2sniper.animname ][ myanim]);
	level thread animtime_notify(animtime);
	
	if (level.e2sniper.animname ==  "sniperR_scan" || level.e2sniper.animname ==  "sniperL_scan")
	{
		level.sniper_wasout_lasttime = 1;
		level.sniper_looking_max = level.sniper_looking_max - 2;
	}
	else
	{
		level.sniper_wasout_lasttime = undefined;
	}
	
	
	animspot thread anim_single_solo(level.e2sniper, myanim);

	if (!isdefined(dontfire))
	{
		level.e2sniper waittill("sniperfire");
		if (!isdefined(notplayer))
		{
			shotspot = get_players()[0] geteye();
		}
		firespot = level.e2sniper gettagorigin("tag_flash");
		vec = firespot- shotspot;
		nvec = vectornormalize(vec);
		playfx(level._effect["fake_rifleflash"] , firespot);
		trace = bullettrace(firespot+(nvec*5), shotspot, false, undefined);
		//bullettracer(firespot+(nvec*5), trace["position"], true);
		bullettracer(firespot+(nvec*5), shotspot, true);
		wait 0.45;
		if (!isdefined(notplayer))
		{
			shotspot = get_players()[0] geteye();
		}
		//magicbullet ("kar98k_scoped", firespot+(nvec*10), shotspot);
		magicbullet ("mosin_rifle_scoped", firespot+(nvec*10), shotspot);
		level notify ("sniper_shot");
	}

	if (isdefined(xpossiblenode) && isdefined(xnum) )
	{
		level.e2sniper.currentnum = xnum;
		level.e2sniper.currentnode = xpossiblenode;
	}
	level waittill ("shootanim_done");
	
	

	
	if (toss == 1)
	{
		level.e2sniper.animname = "sniperL";
		animspot.origin = level.e2sniper.currentnode.origin+(0,0,8.865);
		animspot thread anim_loop_solo(level.e2sniper, "idle_L", undefined, "stopidle");
	}
	else
	{
		level.e2sniper.animname = "sniperR";
		animspot.origin = level.e2sniper.currentnode.origin+(0,0,8.865);
		animspot thread anim_loop_solo(level.e2sniper, "idle_R", undefined, "stopidle");
	}
	self.goalradius = 16;
	level.lastanimspot = animspot;
}


player_vs_sniper()
{
	thread sarge_tell_reposition();
	level.e2sniper endon ("death");
	player = get_players()[0];
	
	level.nodefindticker = 0;
	
	level thread dontlet_player_on_snipers_back(); // from one spot the player can see the sniper idling, this makes sniper run if the player is there
	thread sniper_on_u_damage_control();	// increases damage from every shot so the player doesn't take unrealistic damage
	spottrigs = [];
	spottrigs[0] = getent("sniper_hidespot_mid", "targetname");
	spottrigs[1] = getent("sniper_hidespot_right", "targetname");
	spottrigs[2] = getent("sniper_hidespot_back", "targetname");
	spottrigs[3] = getent("sniper_hidespot_bot", "targetname");
	spottrigs[4] = getent("sniper_hidespot_right_low", "targetname");
	spottrigs[5] = getent("sniper_hidespot_midright", "targetname");
	
	player.spottrig = undefined;
	while(1)
	{
		if ( player isfiring() || flag("player_shotat_sniper") )
		{
			flag_waitopen("helmet_trick_time");
						// if sniper is scanning he should react
			if (isdefined(level.e2sniper.animname) && (level.e2sniper.animname == "sniperL_scan" || level.e2sniper.animname == "sniperL_scan"))
			{
				node = getnode(level.e2sniper.script_noteworthy+"_safety_node", "targetname");
				level.e2sniper stopanimscripted();
				level.e2sniper setgoalnode(node);
				wait 1.5;
			}
			else		// otherwise he should finish his animation so he doesn't dissappear
			{
				flag_waitopen("sniper_animating");
			}
			
			flag_set("player_shotat_sniper");
			level notify ("player_shotat_sniper");
			for (i=0; i < spottrigs.size; i++)
			{
				if (player istouching(spottrigs[i]) )
				{
					player.spottrig = spottrigs[i];
				}
			}
			flag_clear("player_shotat_sniper");
			level.e2sniper thread sniper_on_u(player.spottrig, player);
			wait 5;
		}
		wait 0.05;
	}
}

sarge_tell_reposition()
{
	level.e2sniper endon ("death");
	movetells = [];
	/*movetells[0] = "get_to_window";
	movetells[1] = "find_cover";
	movetells[2] = "u_pinned";
	*/
	movetells[0] = "get_to_window";
	movetells[1] = "find_cover";
	movetells[2] = "u_pinned";
	movetells[3] = "sniper_position_tell";
	lasttell = "";
	tell = undefined;
	wait 15;
	waittime = 35;
	if (level.difficulty == 3)
	{
		movetells[0] = "sniper_position_tell";
		movetells[1] = "sniper_position_tell";
		movetells[2] = "sniper_position_tell";
		movetells[3] = "sniper_position_tell";
		waittime = 65;
	}

	while(1)
	{
		cycle = false;
		flag_wait("sniper_found_player");
		
		while(cycle==false)
		{
			tell = movetells[randomint(movetells.size)];
			if (isdefined(lasttell) && tell !=  lasttell)
			{
				lasttell = tell;
				cycle = true;
			}
			
			wait 0.01;
		}
		
		if (tell == "sniper_position_tell" && isdefined(level.e2sniper.currentnum) )
		{
			thread hero_call_sniper_pos(level.e2sniper.currentnum);
		}
		else
		{
			thread say_dialogue(tell);
		}
		flag_clear("sniper_found_player");

		wait waittime;
		
	}
}
				


sniper_on_u_damage_control()
{
	level.e2sniper endon ("death");
	player = get_players()[0];
	modifier = level.difficulty;
	if (modifier ==1)
	{
		modifier = 0;
	}
	while(1)
	{
		level.player_hits_sustained++;
		player waittill ("damage", amount, attacker);
		if (modifier >= level.player_hits_sustained)
		{
			level.player_hits_sustained = modifier+1;
		}
		else if (level.difficulty != 1)
		{
			level.player_hits_sustained++;
		}
		damage_amount = level.difficulty*15;
		damage_modifier = randomfloatrange( .5*level.player_hits_sustained,level.player_hits_sustained);
		player dodamage(damage_amount * damage_modifier, level.e2sniper.origin, level.e2sniper, level.e2sniper);
		wait 2;
	}
}


hero_call_sniper_pos(nodenum, facial)
{
	nodes = getnodearray(level.e2sniper.script_noteworthy+"_hide_nodes", "script_noteworthy");
	halfsize = nodes.size/2;
	animspot = getstruct("mannequin", "targetname");
	level.hero.animname = "hero";
	if (level.e2sniper.script_noteworthy == "sniper1")
	{
		if(nodenum >halfsize)
		{
			if (isdefined(facial))
			{
				animspot notify ("stoploop");
				animspot anim_single_solo(level.hero, "mannequin_loop1_dialog3");
			}
			else
			{
				level thread say_dialogue("4_floor_l");
			}
		}
		else
		{
			if (isdefined(facial))
			{
				animspot notify ("stoploop");
				animspot anim_single_solo(level.hero, "mannequin_loop1_dialog2");
			}
			else
			{
				level thread say_dialogue("4_floor_r");
			}
		}
	}
	else if (level.e2sniper.script_noteworthy == "sniper2")
	{
		if(nodenum >halfsize)
		{
			if (isdefined(facial))
			{
				animspot notify ("stoploop");
				animspot anim_single_solo(level.hero, "mannequin_loop1_dialog4");
			}
			else
			{
				level thread say_dialogue("3_floor_l");
			}
		}
		else
		{
			if (isdefined(facial))
			{
				animspot notify ("stoploop");
				animspot anim_single_solo(level.hero, "mannequin_loop1_dialog1");
			}
			else
			{
				level thread say_dialogue("3_floor_r");
			}
		}
	}
	animspot notify ("stoploop");
	if (isdefined(facial))
	{
		animspot thread anim_loop_solo(level.hero,	"mannequin_loop1", undefined, "stoploop");
	}
	else
	{
		animspot thread anim_loop_solo(level.hero,	"mannequin_loop3", undefined, "stoploop");
	}
}

sniper_dead_now()
{
	level waittill ("e2_sniper_dead");
	level.e2sniper notify ("stopidle");
	level notify ("kill_fanout_guys");
	guys = getaiarray("axis");
	array_thread(guys, ::wait_and_kill, 1);
	guy = level.hero;
	
	//Tuey Change Music State to SNIPER_DEAD
	setmusicstate("SNIPER_DEAD");
		
	if (flag("pushing_mannequin"))
	{
		newspot = getstruct("mannequin", "targetname");
		newspot notify ("stoploop");
		flag_set ("mannequin_hit");
		org = guy gettagorigin("tag_inhand");
		ang = guy gettagangles("tag_inhand");
		guy detach ("anim_berlin_mannequin", "tag_inhand");
	
		mannequin = spawn ("script_model", org);
		mannequin.angles = ang;
		mannequin setmodel("anim_berlin_mannequin");
	}

	if (flag("pushing_mannequin_d"))
	{
		newspot = getstruct("mannequin", "targetname");
		newspot notify ("stoploop");
		flag_set ("mannequin_hit");
		org = guy gettagorigin("tag_inhand");
		ang = guy gettagangles("tag_inhand");
		guy detach ("anim_berlin_mannequin_d", "tag_inhand");
	
		mannequin = spawn ("script_model", org);
		mannequin.angles = ang;
		mannequin setmodel("anim_berlin_mannequin_d");
	}
	level.hero stopanimscripted();


	objective_controller(5);
	level notify ("stop_talking");
	wait 0.1;
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		guys[i] dodamage(guys[i].health * 10, (0,0,0) );
	}
	wait 0.05;
	thread say_dialogue("good_hunting");
	wait 0.2;
	thread say_dialogue("patrols_heard");
	wait 0.05;
	thread say_dialogue("need_tomove");
	
	level.hero solo_set_pacifist(true);
	level.hero.ignoreall = true;

	thread flame_building();
}

#using_animtree( "sniper_crows" );
bb_opendoors()
{
	newspot = getstruct("mannequin", "targetname");
	
	
	door1		  = getent("store_door", "targetname");
	door1.script_linkto = "origin_animate_jnt";
	/*
	door1_org = getent("uh_door1_thx", "targetname");
	door1_org.animname = "leftdoor";
	door1_org UseAnimTree(#animtree);

	door1 linkto(door1_org);
	*/
	door1 = GetEnt( "store_door", "targetname" );
	door1 ConnectPaths();
	level thread anim_ents_solo( door1, "open", undefined, undefined, door1, "rightdoor" );	
	
		
	door2 = getent("store_door2", "targetname");
	/*door2_org = getent("uh_door2_thx", "targetname");

	door2_org.animname = "rightdoor";
	door2_org UseAnimTree(#animtree);
	door2 linkto(door2_org);
	*/
	
	door2.script_linkto = "origin_animate_jnt";
	door2 ConnectPaths();
	level thread anim_ents_solo( door2, "open", undefined, undefined, door2, "leftdoor" );	
	door1 playsound("big_door_squeak");
	
		

}

hero_opendoor_2()
{
	newspot = getstruct("mannequin", "targetname");
	newspot notify ("stoploop");
	spot = getstruct("mannequin", "targetname");
	level.hero.animname = "hero";
	spot anim_reach_solo(level.hero,"mannequin_out");
	animtime = getanimlength(level.scr_anim[level.hero.animname]["mannequin_out"]);
	self waittill ("trigger");
	level thread bb_opendoors();
	spot thread anim_single_solo(level.hero,"mannequin_out");

	getent("e2_sarge_into_flame_building2_chain", "targetname") notify ("trigger");

	level.hero.disablearrivals = true;
	level.hero.disableexits=true;
	wait animtime - 0.1;
	level.hero stopanimscripted();
	getent("downstairs_clip", "targetname") delete();
	spot = getstruct("new_crawlout_align_node", "targetname");
	animtime = getanimlength(level.scr_anim["hero"]["bb_intro_hop_down"]);
	spot anim_reach_solo(level.hero, "bb_intro_hop_down");
	spot anim_single_solo(level.hero, "bb_intro_hop_down");
	spot thread anim_loop_solo(level.hero, "bb_intro_hop_loop", undefined, "stop_loop");
	/*waittillframeend;
	wait animtime/2;
	level.hero.a.pose = "crouch"; 
	wait animtime/2;
	level.hero allowedstances("crouch");
	*/
	flag_set("hop_down_complete");
}


/////////////////////////////////////////////////////// End Section 5 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

e2_backtrack_blocking()
{
	getent("inside_sniper_building_trig", "script_noteworthy") waittill ("trigger");
	getent("sniper_building_playerclip", "targetname") trigger_on();
	flag_set("inside_sniper_building");
	level notify ("sniper_second_shot");
}


glass_break()
{
	wait 3;	
	spot1 = getstruct("E2_sniper_nearmiss_shotspot", "targetname");
	spot2 = getstruct("E2_sniper_nearmiss_hitspot2", "targetname");
	bullettracer(spot1.origin, spot2.origin, true);
	
	wait 0.35;

	//trig delete();
	pos = getstruct("glass_break_pos", "targetname");
	playfx(level._effect["glass_break"], pos.origin);
	playsoundatposition ("break_window", (1616, -272, 8));

	windows = getentarray("shot_window", "targetname");
	for (i=0; i < windows.size; i++)
	{
		windows[i] delete();
	}

	wait 0.1;
	//magicbullet ("kar98k_scoped", spot1.origin, spot2.origin);
	magicbullet ("mosin_rifle_scoped_noflash", spot1.origin, spot2.origin);
	getent("sniper_building_playerclip", "targetname") trigger_off();

}

player_lingers_by_nearmiss()
{
	level endon ("e2_sniper_dead");
	level endon ("newspot");
	spot1 = getstruct("E2_sniper_nearmiss_shotspot", "targetname");
	getent("inside_sniper_building_trig", "script_noteworthy") waittill ("trigger");
	wait 2;
	trig = getent("player_hugging_wall_by_nearmiss", "targetname");
	while(1)
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (players[i] istouching(trig))
			{
				while(1)
				{
					wait 4;
					players = get_players();
					for (i=0; i < players.size; i++)
					{
						if (players[i] istouching(trig))
						{	
							bullettracer(spot1.origin, get_players()[0].origin, true);
							//magicbullet ("kar98k_scoped", spot1.origin, get_players()[0].origin);
							magicbullet ("mosin_rifle_scoped_noflash", spot1.origin, get_players()[0].origin);
							get_players()[0] dodamage (get_players()[0].health *10, spot1.origin);
							wait 10;
						}
					}
				}
			}
		}
		wait 2;
	}
}


event2_trigsoff()
{
	getent("e2_sarge_into_flame_building2", "targetname")  trigger_off();
	getent("burning_building_enemy_clip", "targetname")		 connectpaths();
	getent("burning_building_enemy_clip", "targetname") 	 trigger_off();
}

mannequin_damage_control(spot)
{
	trig = getent("mannequin_damage_trig", "targetname");
	trig.origin = spot.origin;
	while(1)
	{
		trig waittill ("damage", amount, attacker);
		if (get_players()[0] != attacker)
		{
			break;
		}
		wait 0.05;
	}
	flag_set ("mannequin_hit");
}

#using_animtree ("generic_human");
hero_downstairs_bb()
{
	trig = getent("hero_downstairs_bb", "script_noteworthy");
	if(isdefined(trig))
	{
		trig waittill ("trigger");
	}
	
	maps\_spawner::kill_spawnernum(201);
	
	level.hero.animname = "hero";
	spot = getstruct("new_crawlout_align_node", "targetname");
	getent("sarge_over_table", "targetname") waittill ("trigger");
	getent("player_backup_bbstairs_blocker", "targetname") trigger_on(); // script brushmodel blocking player back up stairs

	flag_wait("hop_down_complete");
	
	/*level.hero reset_run_anim();
	level.hero allowedstances("prone","crouch","stand");
	level.hero.a.pose = "stand";

	node = getnode("e2_intro_hop_hacknode", "targetname");
	
	level.hero setgoalnode(node);
	level.hero.goalradius = 2;		//**TEMP hacky mchackerson waiting for codefix
	wait 0.2;
	level.hero waittill ("goal");
	*/
		
	spot notify ("stop_loop");
	spot anim_single_solo(level.hero, "bb_intro_hop");
	spot anim_single_solo(level.hero, "bb_intro_staylow");
	spot thread anim_loop_solo(level.hero, "bb_intro_loop", undefined, "stoploop");
	flag_wait("bb_escape_ison");
	spot notify ("stoploop");
	
	animtime = getanimlength(level.scr_anim["hero"]["bb_intro_dive"]);	
	spot thread anim_single_solo(level.hero, "bb_intro_dive");
	wait animtime*(2/8);
	if( level.hero.a.pose != "prone" )
	{
		level.hero.a.pose = "prone"; 
		
	}
	level.hero allowedstances("prone");
	
	wait animtime*(5/8);
	getent("e2_flamer6", "targetname") stalingradspawn();
	


	wait animtime*(1/8);
	

	
	//level thread e2_fall_effects();
	thread say_dialogue("burn_us_out");
	thread say_dialogue("stay_low_dontbreathe");
	
	level endon ("boardfall_time");	
	
	spot anim_reach_solo(level.hero, "bb_crawl_getup");
	animtime = getanimlength(level.scr_anim["hero"]["bb_crawl_getup"]);	
	spot thread anim_single_solo(level.hero, "bb_crawl_getup");
	level.hero.ignoreall = true;
	level.hero.ignoreme = true;
	level.hero.pacifist = true;
	level.hero ClearEnemy();
	wait 1;
	level.hero allowedstances("prone","stand", "crouch");
	wait 2;
	
	if( level.hero.a.pose != "stand" )
	{
		//( get rid of any prone or other stuff that might be going on )
		//level.hero ClearAnim( %root, 0.2 ); 
		if( level.hero.a.pose == "prone" )
		{
			level.hero animscripts\utility::ExitProneWrapper( 1 ); 
		}
		level.hero.a.pose = "stand"; 
	}
	level.hero.a.movement = "run"; 

		// ender if player gets too far ahead of reznov

	//level.hero allowedstances("stand", "crouch");
	wait animtime - 3;
	level thread say_dialogue("we_must_hurry");
	level.hero enable_ai_color();
	level.hero set_run_anim("sneaky_walk1");
	/*if (!flag("hero_moveto_stairs"))
	{
		level.hero solo_set_pacifist(false);
	}
	*/
	flag_wait("hero_moveto_stairs");
	spot = getstruct("falling_boards_react", "targetname");
	level.hero.animname = "hero";
	

	
	spot anim_single_solo(level.hero, "bb_stumble4");
	level.hero set_run_anim("runcough1");
	spot = getstruct("new_crawlout_align_node", "targetname");
	spot anim_reach_solo(level.hero, "bb_stairs_loop_reach");
	//animtime = getanimlength(level.scr_anim["hero"]["bb_stairs_in"]);	
//	spot anim_single_solo(level.hero, "bb_stairs_in");	
	spot thread anim_loop_solo(level.hero, "bb_stairs_loop", undefined, "stoploop");
	flag_wait("hero_moveup_stairs");
	spot notify ("stoploop");
	//level.hero stopanimscripted();
	level notify ("up_bb_stairs_now");
	level thread say_dialogue("move_upstairs");
	spot anim_single_solo(level.hero, "bb_stairs_out");	
	level.hero set_run_anim("stair_run");	
	level.hero enable_ai_color();

}


beams_fall()
{
	newspot = getnode("bb_debris_align_node", "targetname");
	spot = spawn("script_origin", newspot.origin);
	spot.angles = newspot.angles;
	//spot setmodel("anim_sniper_beam_fall");
	
	beams = getentarray("beam_fall", "targetname");
	for (i=0; i < beams.size; i++)
	{
		beams[i].script_linkto = beams[i].script_noteworthy;
		beams[i].originalspot = beams[i].origin;
		beams[i].anglesspot = beams[i].angles;
	}

	maps\_anim::anim_ents( beams, "fall", undefined, undefined, spot, "beams" );
	spot delete();
}

ceiling1_fall() //the stuff falling behind door #1 downstairs
{
	trig = getent("falling_boards_pos4_trig", "targetname");
	trig waittill ("trigger");
	
	spot = getstructent("falling_boards_react", "targetname");
	spot playsound("bomb_far_scripted");

	level.hero.animname = "hero";
	spot anim_reach_solo(level.hero, "bb_stumble4");
	flag_set("hero_moveto_stairs");
	//trig2 = getent("falling_boards_pos4_trig", "targetname");
	//trig2 waittill ("trigger");

	newspot = getnode("celing1_fall", "targetname");
	spot = spawn("script_model", newspot.origin);
	spot.angles = newspot.angles;
	spot setmodel("anim_sniper_ceiling_fall3");
	

	beams = getentarray("beam_fall_3", "targetname");
	for (i=0; i < beams.size; i++)
	{
		beams[i].script_linkto = beams[i].script_noteworthy;
	}
	
	earthquake(0.4, 2, level.player.origin, 500);
	playfx(level._effect["collapse_1"], (3838,-351,147) );

	playsoundatposition("celing_fall_1",(3838,-351,147));

	animlength = getanimlength( level.scr_anim["celing1_fall"]["fall"]);
	level thread maps\_anim::anim_ents( beams, "fall", undefined, undefined, spot, "celing1_fall" );
	level.player playrumbleonentity("explosion_generic");
	wait animlength;
	
	spot delete();
}

ceiling2_fall() // the stuff falling at the top of the stairs
{
	trig = getent("bb_floor2_trig", "script_noteworthy");
	trig waittill ("trigger");
	newspot = getnode("celing2_fall", "targetname");
	spot = spawn("script_model", newspot.origin);
	spot playsound("bomb_far_scripted");
	spot.angles = newspot.angles;
	spot setmodel("anim_sniper_ceiling_fall2");
	beams = getentarray("beam_fall2", "targetname");
	for (i=0; i < beams.size; i++)
	{
		beams[i].script_linkto = beams[i].script_noteworthy;
	}

	level.player playrumbleonentity("explosion_generic");
	earthquake(0.4, 4, level.player.origin, 1000);
	playfx(level._effect["collapse_2"], (3821,-108,388) );
	playsoundatposition("celing_fall_2", (3821,-108,388) );
	
	animlength = getanimlength( level.scr_anim["celing2_fall"]["fall"]);
	level thread maps\_anim::anim_ents( beams, "fall", undefined, undefined, spot, "celing2_fall" );
	wait 2;
	level.player playrumbleonentity("explosion_generic");
	wait animlength- 2;
	
	spot delete();
}




chandolier_notify()
{
	while(!flag("chand_rdy_to_fall"))
	{
		level waittill ("chand_fall_check");
	}
	level notify ("chandelier_fall");
}


#using_animtree( "sniper_crows" );
chandolier_loop()
{
	level endon ("chandelier_fall");
	node = getstruct("chandolier_align", "targetname");
	spot = spawn ("script_origin", node.origin);
	spot.angles = node.angles;
	
	model = getent("anim_chandolier", "targetname");
	model UseAnimTree(#animtree);
	model.animname = "chandelier";
	while(1)
	{
		model anim_single_solo(model, "loop");
	}
}


#using_animtree( "sniper_crows" );
chandolier_fall()  // the big ass chandolier fall
{
	chandolier_loop();
	stop_exploder(8);
	node = getstruct("chandolier_align", "targetname");
	spot = spawn ("script_origin", node.origin);
	spot.angles = node.angles;
	
	model = getent("anim_chandolier", "targetname");
	model UseAnimTree(#animtree);
	model.animname = "chandelier";
	model stopanimscripted();
	model playsound("beam_break");

	
	beams = getentarray("chandelier_fall", "targetname");
	spot2 = spawn("script_model", spot.origin);
	spot2.angles = spot.angles;
	spot2 setmodel("anim_sniper_chandelier_fall");
	for (i=0; i < beams.size; i++)
	{
		beams[i].script_linkto = beams[i].script_noteworthy;
	}
	//wait 0.05;
	
	level.player playrumbleonentity("explosion_generic");
	earthquake(0.3, 0.5, level.player.origin, 1000);
	playfx(level._effect["collapse_chand"], (2841,-717,301) );
	model thread anim_single_solo(model, "fall");
	animlength = getanimlength( level.scr_anim["chandelier_frame"]["fall"]);
	level thread maps\_anim::anim_ents( beams, "fall", undefined, undefined, spot2, "chandelier_frame" );
	level thread chandolier_2_shake();
	wait 1.7;
	level.player playrumbleonentity("explosion_generic");
	earthquake(0.5, 1, level.player.origin, 1000);
	model playsound("explosion_fake");
	wait 1.2;
	level.player playrumbleonentity("explosion_generic");
	earthquake(0.3, 0.4, level.player.origin, 1000);
	wait animlength -2.9;
	model playsound("beam_break_2");
	spot delete();
	spot2 delete();

}

chandolier_2_shake()
{
	level endon ("roll_done");
	chand = getent("chandolier_2", "targetname");
	chand UseAnimTree(#animtree);
	chand.animname = "chandelier_2";
	while(1)
	{
		chand anim_single_solo(chand, "shake");
		chand playsound("chandelier");
	}
}

beams_shot()
{
	getent("fire_chase_11", "targetname") waittill ("trigger");
	getent("b1_d", "targetname") show();
	getent("b1", "targetname") delete();
	wait 0.25;
	getent("b2_d", "targetname") show();
	getent("b2", "targetname") delete();
}

furnace_burst() // the pipe burst flying across room and flame shooting out after you get up from crawl
{
	node = getnode("dstairs_furnace_align", "targetname");
	spot = spawn("script_model", node.origin);
	spot.angles = node.angles;
	spot setmodel("anim_sniper_pipe_bust");
	
	pipe = getent("dstairs_furnace", "targetname");
	pipe.script_linkto = "pipe";
	trig = getent("sarge_moveon_towardstairs_chain", "script_noteworthy");
	trig waittill ("trigger");
	
	exploder(24);
	level._effect["pipe_trail"]					= loadfx("maps/sniper/fx_sys_element_flame_trail_small_emitter");
	level._effect["pipe_flame"]					= loadfx("maps/sniper/fx_oven_pipe_flame");
	
	fxspot = getstruct("first_pipefx_spot", "targetname");
	playfx(level._effect["pipe_flame"], fxspot.origin, anglestoforward(fxspot.angles) );
	pipe playsound("explosion_heater");
	
	pipefx = spawn("script_model", pipe.origin);
	pipefx setmodel("tag_origin");
	pipefx linkto(pipe);
	playfxontag(level._effect["pipe_trail"], pipefx, "tag_origin");
	pipe playloopsound("heater_loop");
	
	earthquake(0.5,0.4, level.player.origin, 600);
	maps\_anim::anim_ents_solo( pipe, "shoot", undefined, undefined, spot, "dstairs_pipe" );

	spot delete();
}

larry_the_limper()
{
	level.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) );
	level.player PlayerSetGroundReferenceEnt( level.ground_ref_ent );
	
	while(!flag("limp2"))
	{
		velocity = level.player GetVelocity();
		level.player_speed = abs( velocity [0] ) + abs( velocity[1] );
		if (level.player_speed > 1)
		{
			get_players()[0] setblur( 2, 0.5 );
			first_limp_point = (0, 0, 11);
			angles = adjust_angles_to_player( first_limp_point );
			level.player thread player_speed_set(170,0.4);
			level.ground_ref_ent rotateto( angles, 0.6, 0.55, 0.05 );
			wait 0.5;
			get_players()[0] setblur( 0, 0.5 );
			second_limp_point = (0, 0, 6);
			angles = adjust_angles_to_player( second_limp_point );
			level.player thread player_speed_set(90,0.2);
			level.ground_ref_ent rotateto( angles, 0.7, 0.65, 0.05 );
			wait 0.3;
			level.player thread player_speed_set(130,1);
			third_limp_point = (0, 0, -5);
			angles = adjust_angles_to_player( third_limp_point );
			level.ground_ref_ent rotateto( angles, 0.5, 0.45, 0.05 );
			wait 0.5;
		}
		wait 0.05;
	}
	
	modifier = 0;
	speed_modifier = 1;
	
	while(flag("limp2") && modifier < 5)
	{
		velocity = level.player GetVelocity();
		level.player_speed = abs( velocity [0] ) + abs( velocity[1] );
		if (level.player_speed > 1)
		{
			get_players()[0] setblur( 2, 0.5 );
			first_limp_point = (0, 0, 7+(modifier *-1) );
			angles = adjust_angles_to_player( first_limp_point );
			level.player thread player_speed_set(180,0.4);
			level.ground_ref_ent rotateto( angles, 0.6, 0.55, 0.05 );
			wait 0.5;
			
			get_players()[0] setblur( 0, 0.5 );
			second_limp_point = (0, 0, 5+(modifier *-1) );
			angles = adjust_angles_to_player( second_limp_point );
			level.player thread player_speed_set(100*speed_modifier,0.2);
			level.ground_ref_ent rotateto( angles, 0.7, 0.65, 0.05 );
			wait 0.3;
			level.player thread player_speed_set(140*speed_modifier,1);
			third_limp_point = (0, 0, -3 +(modifier *1));
			angles = adjust_angles_to_player( third_limp_point );
			level.ground_ref_ent rotateto( angles, 0.5, 0.45, 0.05 );
			wait 0.5;
		}
		modifier = modifier + 0.4;
		speed_modifier = speed_modifier+0.1;
		wait 0.05;
	}

	recover();
	
}
			
recover()
{
	flag_set("recovering");
	level.ground_ref_ent RotateTo( ( 0, 0, 0 ), 1, 0.2, 0.8 );
	level.ground_ref_ent waittill( "rotatedone" );
	flag_clear("recovering");
}

delete_after_bb()
{
	level waittill ("bb_sequence_over");
	self delete();
}

yahoo_fx()
{

	trig = getent("falling_boards_pos7_trig", "targetname");
	trig waittill ("trigger");
	for (i=0; i < 9; i++)
	{
		stop_exploder(i);
	}
	fxspot = spawn ("script_model", level.player.origin+(0,1,0) );
	fxspot setmodel("tag_origin");

	

	wait 0.05;
	playfxontag(level._effect["deathstar_escape"], fxspot, "tag_origin");
	
	fxspot playsound("holy_shit");

	modifier = 10;
	counter = 0;
	fxorigin = level.player.origin;
	xorigin = 0;
	parsecs = 0;
	while(!flag("stop_deathstar_fx"))
	{
		//fxspot moveto(level.player.origin+(20,0,0), 0.05);
		ang = level.player getplayerangles();
		velocity = level.player GetVelocity();
		if (level.player.origin[0] < 3970)
		{
			xorigin = level.player.origin[0];
		}
		
		fxspot.origin = (xorigin+modifier,level.player.origin[1],level.player.origin[2]);
		fxspot.angles = ang;
		level.player_speed = abs( velocity [0] ) + abs( velocity[1] );
		if (  (ang[1] > 40  || ang[1] < -40) || level.player_speed < 10  )
		{
			level.player setburn(0.05);
			level.player dodamage(1,level.player.origin);
		}
		
		if (modifier < 26)
		{
			modifier = modifier + 0.1;
		}
		wait 0.05;
		parsecs++;
		if (parsecs > 35)
		{
			level.player setburn(0.05);
			level.player dodamage(1,level.player.origin+(-100,0,0) );
			parsecs = 0;
		}
	}
	fxspot unlink();
	wait 0.5;
	fxspot delete();
}

bb_stairtop_scare()
{
	trig = getent("player_upstairs_now_trig", "targetname");
	trig waittill ("trigger");
		level thread maps\sniper::say_dialogue("b4_burned_alive");
	
	spot1 = getstruct("bb_nade_start", "targetname");
	spot2 = getstruct("bb_nade_aim", "targetname");
	ai = getaiarray("axis");
	if (level.difficulty != 1)
	{
		ai[0] magicgrenade (spot1.origin, spot2.origin, 5);
	}
	for (i=0; i < 20; i++)
	{
		offsety = randomint(35);
		offsetz = randomint(10);
		magicbullet( "mp40", spot1.origin, spot2.origin+(0,offsety ,offsetz ) );
		bullettracer(spot1.origin, spot2.origin+(0,offsety ,offsetz ) );
		wait 0.12;
	}
	wait randomfloat(0.5, 2);
	for (i=0; i < 18; i++)
	{
		offsety = randomint(35);
		offsetz = randomint(10);
		magicbullet( "mp40", spot1.origin, spot2.origin+(0,offsety ,offsetz ) );
		bullettracer(spot1.origin, spot2.origin+(0,offsety ,offsetz ) );
		wait 0.12;
	}
	ai = getaiarray("axis");
	
	if (level.difficulty != 1)
	{
		ai[0] magicgrenade (spot1.origin, spot2.origin, 5);
	}
	for (i=0; i < 50; i++)
	{
		offsety = randomint(35);
		offsetz = randomint(10);
		magicbullet( "mp40", spot1.origin, spot2.origin+(0,offsety ,offsetz ) );
		bullettracer(spot1.origin, spot2.origin+(0,offsety ,offsetz ) );
		wait 0.12;
	}
}

e2_fall_effects()
{
	wait 3;
	for (i=1; i < 5; i++)
	{
		spot = getstruct("e2_fall_effect_"+i, "targetname");
		playfx(level._effect["fallingboards_fire"], spot.origin);
		wait randomfloatrange(1,4);
		if (i==2)
		{
			wait 3;
		}
	}
}

jumpout_fx()
{
	stop_exploder(9);
	stop_exploder(10);
	spots = getstructarray("bb_jumpout_wall_spots", "script_noteworthy");
	for (i=0; i < spots.size; i++)
	{
		playfx(level._effect["fire_indoor_wall_crawl2"], spots[i].origin, anglestoforward(spots[i].angles), anglestoup(spots[i].angles));
	}
	spots = getstructarray("bb_jumpout_fire_spots", "script_noteworthy");
	for (i=0; i < spots.size; i++)
	{
		playfx(level._effect["fire_debris_large"], spots[i].origin);
	}
}

helmet_ona_stick(node)
{
	flag_set("helmet_trick_time");
	level.helmet_trick_done = true;
	helmet = getent("fake_helmet", "targetname");
	dtrig = getent("helmet_dtrig", "targetname");
	stick = getent("helmet_ona_stick", "targetname");
	xcoordmod = 0;
	switch (node.type)
	{
		case "Cover Right":
			xcoordmod = 40;
			break;
		case "Cover Left":
			xcoordmod = -60;
			break;
	}
	dtrigorg = spawn ("script_origin", dtrig.origin);
	dtrigorg linkto(helmet);
	dtrig thread drag_trig_with_org(dtrigorg);
	stick linkto(helmet);
	
	helmet.origin = node.origin + (xcoordmod, 0,15);
	//dtrig thread waittill_and_setflag("damage", "helmet_shot");
	level thread waittill_and_setflag("stealthbreak", "player_shotat_helmet");
	level.player thread stealth_checker();
	top = 0;
	counter = 0;
	direction = 1;
	increment = 0;
	playedfx = 0;
	leftright = 0;
	lrdirection = "r";
	originalx = helmet.origin[0];
	xcap = 4;
	while(!flag("player_shotat_helmet") && counter < 4)
	{
		
		helmet.origin = (leftright+originalx,helmet.origin[1],helmet.origin[2] + increment);
		wait 0.05;
		top = top+increment;
		if (direction == 1 && top < 13)
		{
			increment = 0.3;
			chance = randomint(100);
			if (chance > 75)
			{
				if (lrdirection == "r" && leftright < xcap)
				{
					leftright = leftright + 0.1;
				}
				else if (leftright >= xcap)
				{
					lrdirection = "l";
				}
			}
			if (chance > 75)
			{
				if (lrdirection == "l" && leftright > xcap*-1)
				{
					leftright = leftright - 0.1;
				}
				else if (leftright <= xcap*-1)
				{
					lrdirection = "r";
				}
			}
		}
		if (direction == 1 && top > 13)
		{
			pressed = level.player adsbuttonpressed();
			if (playedfx==0 || pressed == false)
			{
				spot = spawn("script_model", helmet.origin+(0,0,10));
				spot setmodel ("tag_origin");
				//vec = spot.origin - level.player geteye();
				vec = level.player geteye() - spot.origin;
				spot.angles = vectortoangles(vec);
				ang = spot gettagangles("tag_origin");
				
				playfxontag(level._effect["scope_glint"], spot, "tag_origin");
				level thread wait_and_delete(spot, 2);
				wait 0.5;
				playedfx = 1;
			}
			direction = 2;
			increment = -0.3;
			wait 0.5;
		}
		if (direction == 2 && top > 7)
		{
			increment = -0.3;
		}
		if (direction == 2 && top < 7)
		{
			direction = 1;
			increment = 0.3;
			counter ++;
		}
	}
	if (flag("player_shotat_helmet"))
	{
		stick delete();
		helmet moveto (helmet.origin + (0,-200,-10), 1);
		helmet rotatepitch(180, 1.5);
		level thread say_dialogue("just_decoy");
		level thread say_dialogue("stay_focused", undefined, 1);
	}
	else
	{
		stick delete();
		helmet moveto (helmet.origin + (0,0,-15), 3);
		wait randomint(3,7);
	}
	level thread wait_and_openflag(3, "helmet_trick_time");
}


drag_trig_with_org(spot)
{
	level endon ("stealthbreak");
	while(1)
	{
		self.origin = spot.origin;
		wait 0.05;
	}
}

armored_car_line()
{
	trig = getent("fire_chase_9", "targetname");
	trig waittill ("trigger");
	level thread say_dialogue("armored_car");
	level thread say_dialogue("keep_moving");
}

player_tooeager_toface_sniper(ender, trigtargetname)
{
	//level endon ("event2_started");
	level endon (ender);
	trig = getent(trigtargetname, "targetname");
	trig waittill ("trigger");
	shotspot = getstruct("E2_sniper_nearmiss_shotspot", "targetname");
	flag_set("player_is_exposed");	
	wait 3;
	
	
	while(1)
	{
		wait randomintrange(2,5);
		if (level.player istouching(trig) )
		{
			flag_set("player_is_exposed");
			magicbullet ("mosin_rifle_scoped_noflash", shotspot.origin, level.player geteye() );
			wait 1;
			level.player thread kill_on_hit(ender, shotspot.origin, shotspot);
		}
		else
		{
			flag_clear("player_is_exposed");
		}
	}
}


player_inopen_check()
{
	/*
	level endon ("event2_started");
	level endon ("sniper_battle_started");
	level endon ("stop_inopen_dialogue");
	if (flag("player_is_exposed") )
	{
		level thread player_inopen_dialogue();
		flag_waitopen("player_is_exposed");
		level notify ("stop_talking");
		level notify ("stop_inopen_dialogue");

	}
	*/
}

player_inopen_dialogue()
{
	level endon ("event2_started");
	level endon ("sniper_battle_started");
	level endon ("stop_inopen_dialogue");
	while(1)
	{
		level notify ("stop_talking");
		wait 0.1;
		play_random_dialogue("over_here", "they_will_see_you", "stay_close");
		wait 0.1;
		play_random_dialogue("over_here", "they_will_see_you", "stay_close");
		
		wait 10;
	}
}
	

no_sniper_backtracking()
{
	level endon ("inside_sniper_building");
	trig = getent("nobacktrack_fromsniper", "targetname");
	trig waittill("trigger");
	spot1 = getstruct("E2_sniper_nearmiss_shotspot", "targetname");
	magicbullet("mosin_rifle_scoped_noflash", spot1.origin, level.player geteye() );
	level.player dodamage (level.player.health*10, spot1.origin);
	level thread say_dialogue("sniper");
}

give_ammo_to_stupid_player()
{
	while(level.difficulty < 3)
	{
		weap = level.player getcurrentweapon();
		ammocount = level.player 	getammocount(weap);
		if (ammocount == 0)
		{
			level.player setweaponammostock(weap, 99);
			level thread say_dialogue("take_the_shot");
		}
		wait 1;
	}
}