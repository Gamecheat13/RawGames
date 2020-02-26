#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_music;
#include maps\sniper;


event3_start()
{
	level.player SetViewModel( "viewmodel_rus_guardsinged_arms" );
	maps\sniper_event2::jumpout_fx();
	thread tp_to_start("event3");
	level notify ("e2_sniper_dead");
	wait 8;
	level.alleyguys_dead = 0;
	trig = getent("dudeguys", "target");
	trig notify ("trigger");
	trig = getent("e3_allies_saveu_colorchain", "targetname");
	trig thread wait_and_notify(5, "trigger");
	wait 1;
	e3_transition_dialogue();
	wait 2;
		
	level thread e3_sniping_cover_battle();
	wait 0.2;
	level notify ("e3_go");
	wait 3;
	//level.hero set_run_anim("e1_street_run");
	level notify ("event2_started");
}

event3b_start()
{
	thread tp_to_start("event3b");
	wait 15;
	spot = getstruct("factory_door_spot", "targetname");
	level.hero.animname = "hero";
	animtime = getanimlength(level.scr_anim["hero"]["door_open3"]);
	spot thread anim_single_solo(level.hero, "door_open3");
	wait animtime - 1.5;

	level.hero stopanimscripted();
	level.hero enable_ai_color();
	getent("post_door_charge_chain", "script_noteworthy") notify ("trigger", level.player);
	//spot delete();
	wait 120;
	
	

	level.alleyguys_dead = 0;
	level.guys_onground_killed = 0;

	getent("dudeguys", "target") notify ("trigger");
	wait 1;
	getent("e3_allies_cleared_firsthalf", "targetname") notify ("trigger");
	flag_set("e3_forward_comrades");
	level thread allies_moveup_chatter();
	level waittill ("ura");
	level thread say_dialogue("friends_moving_up", undefined, 0.5);
	level thread say_dialogue("up_stairs_quickly");
	
	maps\_spawner::kill_spawnernum(13);
	spawners = getentarray("alley_dudes2_reinforce", "targetname");
	if (isdefined(spawners) && spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}

	thread sniper_cover_battle2();
	e3_threat_stuff();
}

event3c_start()
{
	thread tp_to_start("event3");
	wait 5;
	keys = getarraykeys(level.scr_sound["temptalk"]);
	for (i=0; i < keys.size; i++)
	{
		level thread say_dialogue(keys[i]);
	}
	wait 120;
	
	maps\sniper_event2::player_bb_jumpout();

	getent("dudeguys", "target") notify ("trigger");
	wait 1;
	getent("e3_allies_cleared_firsthalf", "targetname") notify ("trigger");
	
	
	iprintln("Forward Comrades!");
	flag_set("e3_forward_comrades");
	wait 2;
	iprintln("Our men are advancing!  Come quickly, we must move around to cover them!");
	
	maps\_spawner::kill_spawnernum(13);

	thread sniper_cover_battle2();
	e3_threat_stuff();
}





e3_threat_stuff()
{

	guys = getaiarray("allies");
	for (i=0; i < guys.size; i++)
	{
		guys[i] setthreatbiasgroup("russian_squad");
	}
	
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] setthreatbiasgroup("player");
	}
	level.hero setthreatbiasgroup("hero");

	setignoremegroup("russian_squad", "newbhater");
	setignoremegroup("player", "newbhater");
	setignoremegroup("hero", "newbhater");
	setthreatbias("newbs", "newbhater", 10000);
	setignoremegroup("badguys", "russian_squad");
	setignoremegroup("russian_squad", "badguys");
	setignoremegroup("flankers", "russian_squad");
	setignoremegroup("player", "flankers");
	setthreatbias("badguys", "player", 10000);
	setthreatbias("player", "badguys", 10000);
	setthreatbias("ignoreplayer", "russian_squad", 10000);
	setthreatbias("flankers", "russian_squad", 1000);
	if (level.difficulty < 3)
	{
		setthreatbias("hero", "badguys", 10000);
		setthreatbias("badguys", "hero", 10000);
		setignoremegroup("hero", "badguys");
	}
	else
	{
		setignoremegroup("badguys", "hero");
		setignoremegroup("hero", "badguys");
	}
}

reach_wait_single(myanimname, myanim, myflag, node)
{
	self.animname = myanimname;
	self disable_ai_color();
	//node anim_reach_solo(self, myanim);
	if(isdefined(myflag))
	{
		flag_set(myflag);
	}
	flag_wait("friendlies_vignette_go");
	node anim_single_solo(self, myanim);
	self enable_ai_color();
}
	
e3_transition_dialogue()
{
	level.hero setcandamage(true);
	level thread allies_overfence_dialogue();
	node = getstructent("alleyguys_node", "targetname");
	guy1 = grab_ai_by_script_noteworthy("e3_allied_squad_leader", "allies");
	guy1 thread reach_wait_single("redshirt", "postbb_redshirt1", "postbb_redshirt1_inplace", node);
	
	num = 2;
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		if (isdefined(allies[i].script_noteworthy) && allies[i].script_noteworthy=="e3_allied_squad_animate" && num < 4)
		{
			allies[i] thread reach_wait_single("redshirt", "postbb_redshirt"+num, "postbb_redshirt"+num+"_inplace", node);
			num++;
		}
	}
	
	flag_wait("postbb_redshirt1_inplace");
	flag_wait("postbb_redshirt2_inplace");
	flag_wait("postbb_redshirt3_inplace");
	wait 0.4;
	flag_set("friendlies_vignette_go");
	getent("e3_allies_saveu_colorchain", "targetname") notify ("trigger");
	
	level.hero.animname = "hero";
	animtime = getanimlength(level.scr_anim["hero"]["postbb_hero"]);
	level.hero.disablearrivals = false;
	level.hero.disableexits = false;
	//level.hero disable_ai_color();
	
	getent("e3_allies_tofence_chain", "targetname") thread wait_and_notify(animtime - 1, "trigger");
	
	node thread anim_single_solo(level.hero, "postbb_hero");
	wait animtime - 0.1;
	level.hero set_run_anim("patrol_walk");
	wait 0.1;
	level.hero set_run_anim("patrol_walk");
	//wait animtime - 0.1;
	level.hero stopanimscripted();
	//level.hero set_run_anim("patrol_walk");

	level thread say_dialogue("wait_for_screams");
	level thread say_dialogue("dimitri_this_way");
	
	//level.hero enable_ai_color();
	level notify ("e3_go");
	//level.hero set_run_anim("patrol_walk");
	
	wait 9;
	//level.hero set_run_anim("e1_street_run");
	level.hero reset_run_anim();
	level.hero.ignoreme = true;
	level thread maps\_utility::autosave_by_name( "dialogue_over" );
}

allies_overfence_dialogue()
{
	trig = getent("allies_overfence_chain", "targetname");
	trig waittill ("trigger");
	guy = grab_ai_by_script_noteworthy("e3_allied_squad_leader", "allies");
	guy.animname = "hero";
	guy anim_single_solo(guy, "this_way_coms");
	guy anim_single_solo(guy, "take_positions");
}
	

e3_sniping_cover_battle()
{
	level thread battlechatter_off("axis");
	level thread ai_through_door();
	
	level.guys_onground_killed = 0;
	//thread aicount();
	level thread e3_trigsoff();
	
	level notify ("hero_getup");

	wait 0.1;
	level thread e3_threat_stuff();
		
	getent("alley_dudes3", "target") thread waittill_trigg_and_say("left_balcony", 2);
	getent("alley_dudes3", "target") thread waittill_trig_and_notify(level, "stealthbreak");
	
	
	level waittill ("e3_go");
	
	//TUEY Set Music To PRE_SNIPE_FLAMEGUY
	setmusicstate("PRE_SNIPE_FLAMEGUY");

	level thread alldudes_2_come();
	level thread resnov_splain_stuff();
	
	getent("e3_squad_getready_chain", "script_noteworthy") notify ("trigger");
	getent("e3_ladder_blocker", "targetname") delete();
	getent("player_inplace", "script_noteworthy") waittill ("trigger");
	getent("e3_ladderbacktrack_clip", "targetname") trigger_on();
	
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] thread player_speed_set(190,3);
		players[i] allowsprint(true);
	}
	
	level thread impatient_allies();
	level.player thread stealth_checker();
	level waittill ("stealthbreak");
	level notify ("stop_talking");
	wait 0.1;
	level.hero enable_ai_color();
	
	flag_set("e3_fight_go");

	spawners = getentarray("alley_dudes1_2", "targetname");		// first courtyard reinforcements
	if (isdefined(spawners) && spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}
	level thread wait_and_killspawner(randomintrange(15,30), 20);
	battlechatter_on("allies");
	battlechatter_on("axis");
	level.hero set_battlechatter(false);
	level notify ("fight!");
	thread molotov_circus();
	guys = getaiarray("allies");
	guys2 = getaiarray("axis");
	array_thread(guys, ::solo_set_pacifist, false);
	array_thread(guys2, ::solo_set_pacifist, false);
	getent("guys_charge", "targetname") notify ("trigger");
	
	level thread color_chain3();
	wait 0.5;
	guy = grab_ai_by_script_noteworthy("e3_patrolguy2", "axis");
	if (isdefined(guy) && isai(guy) && isalive(guy) )
	{
	}
	else
	{
		level.hero stopanimscripted();
		level thread say_dialogue("belly_laugh1");
		level thread say_dialogue("excel_aim_D");
	}
	wait 2;
	level thread say_dialogue("give_covering_fire");
	level thread keep_firing();
}

impatient_allies()
{
	level endon ("stealthbreak");
	wait 70;
	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		allies[i] solo_set_pacifist(false);
	}
	wait 2;
	level notify ("stealthbreak");
}
keep_firing()
{
	level endon ("e3_forward_comrades");
	level.keepfiring_length = 20;
	wait 40;
	level thread say_dialogue("keep_firing");
	while(1)
	{
		level thread keep_firing_loop();
		while(1)
		{
			if (level.player isfiring() )
			{
				level notify ("player_fired");
				break;
			}
			wait 0.1;
		}
		wait 1;
	}
}
		
	
keep_firing_loop()
{
	level endon ("e3_forward_comrades");
	level endon ("player_fired");
	wait level.keepfiring_length;
	level thread say_dialogue("keep_firing");
	level.keepfiring_length = level.keepfiring_length+5;
}
	
		

alleyguysdead()
{
	thread wait_and_setflag(10, "e3_fightison");
	while (level.alleyguys_dead<12)
	{
		wait 0.5;
		if (flag("e3_fightison"))
			break;
	}
	flag_set("e3_fightison");


	getent("guys_charge2", "targetname") notify ("trigger");
	level.alleyguys_dead = 0;
}

alldudes_2_come()
{
	guys = getaiarray("allies");
	array_thread(guys, ::solo_set_pacifist, true);
	level waittill ("fight!");
	
	//TUEY Set Music To LAST_BATTLE_PHASE_1
	setmusicstate("LAST_BATTLE_PHASE_1");
	guys = array_remove(guys, level.hero);
	for (i=0; i < guys.size; i++)
	{
		wait(randomfloatrange(0.1, 0.3));
		guys[i] playsound("russian_battle_crymn");
	}




	thread alleyguysdead();
	flag_wait("e3_fightison");

	//TUEY Play Battle Cry
	//playsoundatposition ("russian_battle_cry", (5576, -56, 424));


	wait 2;
	
	
	spawners = getentarray("alley_dudes2_high", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] stalingradspawn();
	}
	
	wait 4;
	level thread say_dialogue("mg_2nd_floor");
	
		while (level.alleyguys_dead<7)
	{
		wait 0.5;
	}
	
	getent("dudeguys_redshirt", "target") notify ("trigger");
	
	spawners = getentarray("alley_dudes2", "targetname");
	if (isdefined(spawners) && spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}
	
	spawners = getentarray("alley_dudes2_high2", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		spawners[i] stalingradspawn();
	}

	wait 1;
	maps\_spawner::kill_spawnernum(10);
	waittill_aigroupcleared("e3_flamer_the_2nd");

	getent("guys_charge3", "targetname") notify ("trigger");

	thread Sniper_Cover_Battle2();
	wait 4;
	getent("alley_dudes3", "target") notify ("trigger");
	wait 1;
	maps\_spawner::kill_spawnernum(11);
	waittill_aigroupcleared("e3_leftguys");
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i].script_noteworthy) 
		&& (guys[i].script_noteworthy == "e3_left_balcony_guys" || guys[i].script_noteworthy == "e3_left_roof_guys" || guys[i].script_noteworthy == "e3_p1_second_floor_guys" || guys[i].script_noteworthy == "floor2_mgguy") )
		{
			guys[i] thread wait_and_kill(randomint(2), getstruct("magicfriendlybullet_spot", "targetname") );
		}
	}
	waittill_aigroupcleared("e3_3rd_floor_guys");
	
	
	maps\_spawner::kill_spawnernum(12);
	nodes = getnodearray("e3_alley_fallback_nodes", "script_noteworthy");
	guys = getaiarray("axis");
	nodecounter = 0;
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(nodes[nodecounter]) )
		{
			guys[i] thread ignore_and_run(nodes[nodecounter]);
			nodecounter++;
		}
	}
	wait 2;
	level thread allies_moveup_chatter();
	wait 2;
	getent("e3_allies_cleared_firsthalf", "targetname") notify ("trigger");
	flag_set("e3_forward_comrades");

	level waittill ("ura");
		level thread maps\_utility::autosave_by_name( "ura_charge" );
	level notify ("e3_forward_comrades");
	level thread say_dialogue("friends_moving_up", undefined, 0.5);
	
	checktrig = getent("e3_sargego_midstair_check", "targetname");
	if (level.player istouching(checktrig))
	{
		level thread say_dialogue("up_stairs_quickly");
		getent("e3_sargego_midstair_chain", "targetname") notify ("trigger");
		trig = getent("e3_3rd_floor_chain", "script_noteworthy");
		trig trigger_on();		
	}


	getent("e3_post_3rdfloor_chain", "script_noteworthy") trigger_on();
	wait 8;
	spawners = getentarray("alley_dudes2_reinforce", "targetname");
	if (isdefined(spawners[0]))
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}
	
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		guys[i] solo_set_pacifist(false);
	}
}

sniper_cover_battle2()
{
	waittill_aigroupcleared("castlewall_guys_charge");
	getent("castlewall_chargers_dead_chain", "script_noteworthy") notify ("trigger");
	waittill_aigroupcleared("castlewall_guys");

	level thread maps\_utility::autosave_by_name( "castlewall_battle" );
	flag_wait("e3_forward_comrades");
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i].script_noteworthy) 
		&& (guys[i].script_noteworthy == "e3_left_balcony_guys" || guys[i].script_noteworthy == "e3_left_roof_guys" || guys[i].script_noteworthy == "e3_p1_second_floor_guys") )
		{
			guys[i] thread wait_and_kill(randomint(20));
		}
	}
	
	//iprintln("Down in the courtyard!  We must cover our comrades!");
	getent("e3_allies_cleared_castlewall", "targetname") thread wait_and_notify(5, "trigger");
	wait 1;
	level thread say_dialogue("friends_need_cover");
	level thread rip_vermin();
	maps\_spawner::kill_spawnernum(15);
	while(1)
	{
		guys = getaiarray("axis");
		if (guys.size < 8)
		{
			nodes = getnodearray("e3_guys_retreat_into_building_nodes", "script_noteworthy");
			nodecounter = 0;
			for (i=0; i < guys.size; i++)
			{
				if (isdefined(nodes[nodecounter]))
				{
					guys[i] thread ignore_and_run(nodes[nodecounter]);
					guys[i] thread wait_and_kill(30);
					nodecounter++;
				}
			}
			wait 2;
			break;
		}
		wait 0.5;
	}
	
	trig = getent("newbs_charge", "target");
	trig notify ("trigger");
	wait 1;
	level notify ("newbs_runnin");
	maps\_spawner::kill_spawnernum(32);
	wait 5;
	
	allies = getentarray("dudeguys_charge", "targetname");
	for (i=0; i < allies.size; i++)
	{
		allies[i] stalingradspawn();
	}
	
	spawners = getentarray("e3_snipercover_3floordudes", "targetname");
	if (isdefined(spawners) && spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}
	
	
	
	getent("e3_castlewall_chain", "script_noteworthy") notify ("trigger");
	wait 6;
	getent("e3_b2_reinforcements", "script_noteworthy") notify ("trigger");
	//delaythread(10, ::say_dialogue, "take_out_ht_mg");
	//thread wait_and_print(10,"Kill the Halftrack machine gunner!", "neverend");
	wait 1;
	guy = grab_ai_by_script_noteworthy("e3_halftrack_mgguy", "axis");
	guy waittill ("death");
	
	spawners = getentarray("e3_snipercover_3floormgguy", "targetname");
	if (isdefined(spawners) && spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}
	
	
	wait 7;
	maps\_spawner::kill_spawnernum(16);
	
	spawners = getentarray("e3_snipercover_3floordudes_left", "targetname");
	if (isdefined(spawners) && spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted(spawners);
	}
	
	retreatguys = grab_ais_by_script_noteworthy("e3_guys_retreat_into_building", "axis");
	retreatnodes = getnodearray("e3_guys_retreat_into_building_nodes", "script_noteworthy");
	thread guys_to_nodes(retreatguys,retreatnodes); 
	getent("toughguys_advance", "script_noteworthy") notify ("trigger");
	
	trig = getent("e3_battle2_chain", "script_noteworthy");
	trig thread waittill_trigg_and_say("comrades_clearing", 6);
	waittill_aigroupcleared("e3_infrontof_final_building_guys");

	trig notify ("trigger"); // color chain of allies into building
	waittill_aigroupcleared("e3_retreat_in_building_guys");
	wait 2;
	getent("e3_battle2_chain2", "script_noteworthy") notify ("trigger"); // color chain of allies into building
	wait 1;
	maps\_spawner::kill_spawnernum(14);
	waittill_aigroupcleared("e3_lastguys_inbuilding");
	axis = getaiarray("axis");
	for (i=0; i < axis.size; i++)
	{
		axis[i] thread wait_and_kill(randomfloat(5));
	}
	level.hero reset_run_anim();
	wait 1;

	getent("russians_last_chain", "script_noteworthy") notify ("trigger");

	thread maps\sniper_event4::event4_setup();
	
	//iprintln("End of Scripting");
}


floor3_guys_dead()
{
	thread one_for_four();
	waittill_aigroupcleared("e3_3rd_floor_guys");
	level notify ("3rd_floor_clear");
	flag_set("e3_leftguys_come");
}

e3_trigsoff()
{
	getent("e3_post_3rdfloor_chain", "script_noteworthy") trigger_off();
}

aicount()
{
	while(1)
	{
		guys1 = getaiarray("axis");
		guys2 = getaiarray("allies");
		iprintln("Axis: "+guys1.size);
		iprintln("Allies: "+guys2.size);
		iprintln("Total: "+(guys1.size+guys2.size));
		wait 4;
	}
}

one_for_four()
{
	level endon ("3rd_floor_clear");
	maxkilled = level.guys_onground_killed + 2;
	while(1)
	{
		if (level.guys_onground_killed > maxkilled)
		{
			guys = getaiarray("axis");
			for (i=0; i < guys.size; i++)
			{
				if( isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "e3_p1_second_floor_guys")
				{
					guys[i] dodamage(guys[i].health * 10, (0,0,0) );
					maxkilled = level.guys_onground_killed + 2;
					break;
				}
			}
		}
		wait 1;
	}
}

one_for_ten()
{
	maxkilled = level.guys_onground_killed + 2;
	while(1)
	{
		if (level.guys_onground_killed > maxkilled)
		{
			guys = getaiarray("axis");
			for (i=0; i < guys.size; i++)
			{
				if( isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "e3_snipercover_b_snipers")
				{
					guys[i] dodamage(guys[i].health * 10, (0,0,0) );
					maxkilled = level.guys_onground_killed + 2;
					break;
				}
			}
		}
		wait 1;
	}
}

ai_through_door()
{
	door = getent("factory_door", "targetname");
	door rotateyaw( -120, 0.4, 0.3, .1 );
	door connectpaths();
	trig = getent("alley_dudes4", "target");
	trig thread waittill_trigg_and_say("more_infantry", 1);
	trig waittill ("trigger");
	
	getent("e3_plank_blocker", "targetname") trigger_on();
	
	flag_set("rooftop_battle");
	maps\_spawner::kill_spawnernum(20);
	maps\_spawner::kill_spawnernum(21);
	maps\_spawner::kill_spawnernum(12);
	maps\_spawner::kill_spawnernum(10);
	maps\_spawner::kill_spawnernum(11);
	
	trig = getent("alley_dudes4b", "target");
	trig thread wait_and_notify(randomintrange(10,30), "trigger");
	trig waittill ("trigger");
	door = getent("factory_door", "targetname");
	door rotateyaw( 120, 0.4, 0.3, .1 );
	door disconnectpaths();
	wait 2;
	maps\_spawner::kill_spawnernum(13);
}


color_chain3()
{
	waittill_aigroupcleared("alley_dudes1");
	getent("guys_charge3", "targetname") notify ("trigger");
}

molotov_circus()
{
	level endon ("event4_started");
	while(1)
	{
		wait randomintrange(10,20);
		guys = getaiarray("allies");
		for (i=0; i < guys.size; i++)
		{
			if (guys[i] != level.hero && isdefined(guys[i].enemy) )
			{
				guys[i].animname = "allies";
				guys[i] anim_single_solo(guys[i],"molotov_toss");
				break;
			}
		}
	}
}

rip_vermin()
{
	while(1)
	{
		if (level.player.usingturret == 1)
		{
			level thread say_dialogue("rrrip_vermin");
			break;
		}
		wait 0.5;
	}
}

allies_moveup_chatter()
{
	allies = getaiarray("allies");
	myguy = undefined;
	for (i=0; i < allies.size; i++)
	{
		if (isdefined(allies[i].script_noteworthy) && allies[i].script_noteworthy=="e3_allied_squad_leader")
		{
			myguy = allies[i];
			break;
		}
	}
	myguy thread magic_bullet_shield();
	myguy stopanimscripted();
	myguy.animname = "hero";
	myguy anim_single_solo(myguy, "theyre_retreating");
	wait 0.1;
	//lines[1] = "charge";
	myguy stopanimscripted();
	myguy.animname = "hero";
	myguy anim_single_solo(myguy, "forward");
	wait randomfloatrange(0.1, 0.4);
	myguy.animname = "hero";
	myguy anim_single_solo(myguy, "ura");
	myguy thread stop_magic_bullet_shield();
	level notify ("ura");
	for (i=0; i < allies.size; i++)
	{
		if (isdefined(allies[i].script_noteworthy))
		{
			wait(randomfloatrange(0.2, 0.5));
			allies[i] playsound ("russian_battle_crymn"); 
			
		}
	}
	level waittill ("newbs_runnin");
	for (i=0; i < allies.size; i++)
	{
		if (isdefined(allies[i].script_noteworthy) && allies[i].script_noteworthy=="e3_allied_squad_leader")
		{
			myguy.animname = "hero";
			myguy anim_single_solo(myguy, "charge");
			break;
		}
	}
	

}
	
resnov_splain_stuff()
{
	objective_controller(6);
	level endon ("stealthbreak");
	trig = getent("resnov_splain_trig", "targetname");
	trig waittill ("trigger");
	spot = getstruct("resnov_direction_node", "targetname");
	level.hero.animname = "hero";
	spot anim_reach_solo(level.hero, "resnov_splain");
	spot anim_single_solo(level.hero, "resnov_splain");
	level thread notify_on_notify("stealthbreak", spot, "stoploop");
	
	//spot thread anim_loop_solo(level.hero, "resnov_splain_loop", undefined, "stoploop");
	level.hero enable_ai_color();
	wait 20;
	while(1)
	{
		level thread say_dialogue("shoot_fuel_tank");
		wait 5;
		level thread say_dialogue("take_the_shot");
		wait 5;
		level thread say_dialogue("no_time_to_waste");
		wait 5;
	}
}

