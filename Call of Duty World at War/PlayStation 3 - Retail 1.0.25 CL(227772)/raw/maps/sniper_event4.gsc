
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\sniper_stealth_logic;
#include maps\sniper;
#include maps\_music;
#include maps\sniper_event1;

event4_start()
{
	level thread player_fires();
	spot = getstruct("reznov_laugh_node", "targetname");
	spot thread anim_single_solo(level.hero, "reznov_cheer");
	thread aicount();
	squad = [];
	spawners = getentarray("dudeguys", "targetname");
	for (i=0; i < spawners.size;i++)
	{
		squad[i] = spawners[i] stalingradspawn();
	}

	
	level.hero = getent("sniper_hero", "script_noteworthy");
	players = get_players();
	event4_players_start = getstructarray("event4_player_start", "targetname");
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin+(0,0,-10000) );
		players[i] setplayerangles( event4_players_start[i].angles);
	}
	wait 0.1;
	hero_start_spot = getstruct("e4_herostart", "targetname");
	level.hero teleport(hero_start_spot.origin, hero_start_spot.angles);

	
	wait 0.1;
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin);
		players[i] setplayerangles( event4_players_start[i].angles);
	}
	
	spots = getstructarray("e4_squad_start_spots", "targetname");
	
	wait 0.5;
	for (i=0; i < spots.size; i++)
	{
		squad[i] teleport(spots[i].origin, spots[i].angles);
	}
	
	guys = getentarray("wounded_fountain_guys", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i] delete();
	}

	
	
	VisionSetNaked("Sniper_default",1);
	get_players()[0] giveweapon("mosin_rifle_scoped");
	get_players()[0] SwitchToWeapon( "mosin_rifle_scoped" );
	
	//level.hero allowedstances("stand","crouch");
	level.hero.ignoreall = true;
	//getent("snipe_officer_chain", "targetname") notify ("trigger");
	level notify ("event4_started");
	getent("russians_last_chain", "script_noteworthy") notify ("trigger");

	players = get_players();
	array_thread(players, ::player_fires);
	thread spawn_officer();
	level notify ("event2_started");
}

event5_skipto()
{
	level.hero = getent("sniper_hero", "script_noteworthy");
	players = get_players();
	event4_players_start = getstructarray("event4_player_start", "targetname");
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin+(0,0,-10000) );
		players[i] setplayerangles( event4_players_start[i].angles);
	}
	wait 0.1;
	hero_start_spot = getstruct("e4_herostart", "targetname");
	level.hero teleport(hero_start_spot.origin, hero_start_spot.angles);
	
	wait 0.1;
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event4_players_start[i].origin);
		players[i] setplayerangles( event4_players_start[i].angles);
	}


	
	VisionSetNaked("Sniper_default",1);
	get_players()[0] giveweapon("mosin_rifle_scoped");
	get_players()[0] SwitchToWeapon( "mosin_rifle_scoped" );

	level.hero enable_ai_color();
	wait 5;
	level notify ("event2_started");
	event5_start();


}


event4_setup()
{	

	level thread say_dialogue("when_our_comrades");
	level thread say_dialogue("cut_off");
	
	//TUEY Set music state to CLEAR_ESCAPE
	setmusicstate("CLEAR_ESCAPE");
	
	objective_controller(7);
	getent("sarge_at_doore4door_chain", "script_noteworthy") notify ("trigger");
	wait 0.1;

	open_factory_door();
	level notify ("event4_started");
	getent("e4_cqb_guys", "target") waittill ("trigger");
	
	//TUEY Set music state to SURPRISED_AGAIN
	setmusicstate("SURPRISED_AGAIN");
	
	level thread sarge_cqb_control();
	wait 2;
	maps\_spawner::kill_spawnernum(33);
	thread spawn_officer();
}

sarge_cqb_control()
{
	waittill_aigroupcleared("e4_cqb_guys_1");
	getent("e4_cqb1_dead", "script_noteworthy") delete();
	waittill_aigroupcleared("e4_cqb_guys_2");
	wait 1.5;
	level thread say_dialogue("perfect_spot");

	//TUEY Set Music State to CLEAR_ESCAPE
	setmusicstate("VANTAGE_POINT");
	
	getent("e4_cqb2_dead", "script_noteworthy") notify ("trigger");
	level.player thread player_fires();
	level.hero solo_set_pacifist(true);
	level.hero.ignoreall = true;
	level.hero.ignoreme = true;
}

player_fires()
{
	createthreatbiasgroup("badguys");
	createthreatbiasgroup("player");
	createthreatbiasgroup("hero");
	
	level.hero setthreatbiasgroup("hero");
	
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i].ignoreme = true;
		players[i] setthreatbiasgroup("player");
	}

	while(1)
	{
		
		self waittill( "action_notify_attack" );
		if (self isfiring() || flag("player_fired_in_e4") )
		{
			break;
		}
		wait 0.05;
	}
	
	flag_set("reznov_perch_speech1");
	level.hero solo_set_pacifist(false);
	level notify ("player_shot");
	guys = getaiarray("axis");
	flag_set("player_fired_in_e4");
	for (i=0; i < guys.size; i++)
	{
		if ( (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "officer2" ) 
		||	 (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "vehicle_riders") 
		||   (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "officer_driver")
		||	 (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "bodyguard") 
		||	 (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "officers_sniper")
		||	 (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "lead_bodyguard")	)
		{
			continue;
		}
		else
		{
			guys[i] solo_set_pacifist(false);
			guys[i] setthreatbiasgroup("badguys");
			guys[i].goalradius = 2400;
		}
	}

	players[0].ignoreme = false;
	setthreatbias("badguys", "player", 10000);
	setthreatbias("player", "badguys", 10000);
	setthreatbias("player", "badguys", 10000);
	level.hero.pacifist = false;
	level.hero.ignoreall = false;
	level.hero.ignoreme = false;
}

hold_fire_chat()
{
	level thread battlechatter_off("allies");
	
	level thread say_dialogue("hold_fire");
	level thread say_dialogue("too_close_to_amsel");
	level thread say_dialogue("nothing_wecando");
	level thread say_dialogue("sacrafice");
	level thread say_dialogue("amsels_death", "reznov_perch_speech1");

	flag_wait("reznov_perch_speech1");
	if (flag("player_fired_in_e4"))
	{
		russian_diary_event("good");
		level.hero stopanimscripted();
		level notify ("stop_talking");
		wait 0.05;
		level thread say_dialogue("u_fool", undefined, 0.5);
		wait 2;
		level thread say_dialogue("still_die", undefined, 1);
	}
	else
	{
		russian_diary_event("evil");
	}
	level thread say_dialogue("building_wit_flags");
	waittillframeend;
	level thread say_dialogue("amsel_soon_insights");
	waittillframeend;
	level thread say_dialogue("battle_will_flush");
}

	
spawn_officer()
{
	getent("officer_entourage", "target") waittill ("trigger");
	level thread close_e3_door();
	level thread maps\_utility::autosave_by_name( "officer_wait" );
	level.hero.pacifist = true;
	level.hero.ignoreall = true;
	level.hero.ignoreme = true;
	wait 1;
	level thread hold_fire_chat();

	level thread tank_on_friendlies();
	level waittill ("enemies_charge_allies");
	wait 5;
	level thread maps\_utility::autosave_by_name( "officer_spawned" );
	wait 4;
	
	getent("spawn_officer", "targetname") notify ("trigger");
	
	//TUEY Set Music State to AMSEL_IS_DOOMED
	setmusicstate("AMSEL_IS_DOOMED");

	wait 1;
	level notify ("stop_talking");
	objective_controller(8);
	wait 0.05;
	level thread say_dialogue("coward_there");
	waittillframeend;
	level thread say_dialogue("hes_not_alone", undefined, 0.5);
	waittillframeend;
	level thread say_dialogue("put_bullet_in_bodyguard");
	
}

close_e3_door()
{
	door = getent("factory_door", "targetname");
	door rotateyaw( 120, 0.4, 0.3, .1 );
	door disconnectpaths();
}

horch_come()
{
	horch = getent("horch", "targetname");
	trig1 = getent("back_right_tire_trig", "targetname");
	trig2 = getent("front_right_tire_trig", "targetname");
	thread wheels_shot(trig2);
	thread wheels_shot(trig1);
	flag_wait("officer_rdy_4_car");
	getent("more_vehicles_come", "targetname") notify ("trigger");

}
	

driver_shot()
{
	level endon ("officer_shot_incar");
	horch = getent("horch", "targetname");
	level endon ("tires_shot");
	level.driver.animname = "driver";
	level.officer endon ("death");
	thread car_getaway();
	level.driver waittill ("damage");
	horch notify ("stoploop_driver");
	level notify ("driver_dead");
	horch setspeed(0,5,5);
	level.driver stopanimscripted();
	flag_set("driver_dead");
	level notify ("driver_shot");
	horch anim_single_solo(level.driver, "driver_death");
	horch notify ("stoploop_driver");
	horch thread anim_loop_solo(level.driver, "driver_death_loop", undefined, "death");
	level.driver.health = 999999999;
	//evel.driver dodamage(level.driver.health*2, (0,0,0) );



	wait 2.5;

	level.officer thread officer_last_run();
}

driver_wave()
{
	if ( flag("driver_dead") )
	{
		return;
	}
	level endon("driver_dead");
	
	horch = getent("horch", "targetname");
	level.driver.animname = "driver";
	tag = "tag_driver";
	
	level.driver.animname = "driver";
	horch notify ("stoploop_driver");
	horch.animname = "horch";
	horch anim_reach_solo(level.driver, "horch_getin", tag, horch);
	horch thread anim_single_solo(horch, "amsel_in");
	horch anim_single_solo(level.driver, "horch_getin", tag, horch);
	

	horch thread anim_loop_solo(level.driver, "driver_under_fire", tag, "stoploop_driver", horch);
}

drag_trig_with_wheel(spot)
{
	level endon ("officer_shot_incar");
	level.officer endon ("death");
	while(1)
	{
		self.origin = spot.origin;
		wait 0.05;
	}
}

wheels_shot(wheel)
{
	level endon ("officer_shot_incar");
	level.officer endon ("death");
	level endon("driver_dead");
	
	horch = getent("horch", "targetname");
	wheelorg = spawn ("script_origin", wheel.origin);
	wheelorg linkto(horch);
	wheel thread drag_trig_with_wheel(wheelorg);
	wheel waittill ("damage");
	if (!flag("1_wheel_shot"))
	{
		flag_set("1_wheel_shot");
		horch setspeed(5,5,5);
		if (wheel.targetname == "front_right_tire_trig")
		{
			horch.animname = "horch";
			horch anim_single_solo(horch, "flat_front");
		}
		else
		{
			horch.animname = "horch";
			horch anim_single_solo(horch, "flat_back");
		}
	}
	else 
	{
		flag_set("2_wheel_shot");
		level notify ("tires_shot");
		horch setspeed(0,5,5);
		wait 2.5;
		level.officer thread officer_last_run();
	}
}

tank_shoot_while_backing()
{
	wait 1;
	tank = getent("tank_near_officer", "targetname");
	spot = getstructent("douchespot", "targetname");
	spot.origin = spot.origin +(0,0,30);
	wait 3;
	tank setturrettargetent(spot);
	wait 3;
	tank fireweapon();
	spot2 = getstructent("douchespot2", "targetname");
	spot2.origin = spot2.origin +(0,0,30);
	wait 3;
	tank setturrettargetent(spot2);
	wait 3;
	tank fireweapon();
}

officer_run()
{
	level thread pistol_achievement_check();
	level thread event4_damage_control();
	level endon ("officer_shot_incar");
	chance = randomint(100);
	if (level.difficulty > 2)
	{
		level thread maps\_utility::autosave_by_name( "general_hiding" );
	}
		
	
	level.hero.pacifist = true;
	level.hero.ignoreall = true;
	level.hero.ignoreme = true;
	level thread wait_and_clearflag(5, "can_save");
	//level.officer set_force_cover("hide");
	BadPlacesEnable(0);
	level.officer endon ("death");
	node = getnode("officer_end_goal", "targetname");
	level.officer.animname = "officer";
	
	foundnode = 0;
	talked = 0;
	lastnode = undefined;
	//level.officer thread officer_run_cycles();
	
	for (i=1; i < 6; i++)
	{
		if (level.difficulty == 1)
		{
			level.officer set_run_anim("run_cautious");
		}
		else if (level.difficulty ==2)
		{
			toss = randomint(100);
			if ( toss < 22)
			{
				level.officer set_run_anim("run_quickly");
			}
			else if (toss < 60)
			{
				level.officer set_run_anim("run_cautious");
			}
			else if (toss < 101)
			{
				level.officer set_run_anim("run_away");
			}
		}
		else if (level.difficulty > 2)
		{
			level.officer set_run_anim("run_quickly");
		}
	
		node = getnode("officer_runto_node_"+i, "targetname");
		if (node.origin[1] - level.officer.origin[1] > 150 || foundnode ==1 || i==5)
		{
			talked++;

			if (i==1)
			{

			}
			if (i==2)
			{
				self.health = level.difficulty * 90;
				
				if (cointoss())
					level thread say_dialogue("hide_tank");
				else
					level thread say_dialogue("hide_tank2");
				
			}
			if (i==3)
			{
				flag_set("player_fired_in_e4");
				setignoremegroup("badguys", "hero");
				setignoremegroup("hero", "badguys");
				level.player notify ("action_notify_attack");
				getent("cover_officer_inmid_guys", "script_noteworthy") notify ("trigger");
			}
			if (i==4)
			{
				level thread say_dialogue("hide_flak");
				
			}
			if (i ==5)
			{
				getent("cover_officer_onfoot_guys", "script_noteworthy") notify ("trigger");
				getent("e4_horch_come_trig", "targetname") thread wait_and_notify (5, "trigger");
			}
			
			foundnode = 1;
			flag_waitopen("officers_sniper_running");
			wait randomintrange(4,8);
			
			if (isdefined(lastnode))
			{
				lastnode notify ("stoploop");
			}
			
			flag_set("officer_running");
			if (i==4)
			{			
				level.officer setgoalnode(node); 
				level.officer waittill ("goal");
				level.officer allowedstances("crouch");
			}
			else
			{
				if (i==2)
				{
					level notify ("wave_ansel");
				}
				//if (isdefined(lastnode))
				//{
				//	lastnode thread anim_single_solo(level.officer, "cover_run");
				//	wait 1;
				//	level.officer stopanimscripted();
				//}
				chance = randomint(100);
				
				if (i >1 && chance > 75 && level.difficulty < 3 && !isdefined(level.e5saidrunning) )
				{
					level thread say_dialogue("hes_running");
					level.e5saidrunning = 1;
				}
				else if (i >1 && chance > 50 && level.difficulty < 3 && !isdefined(level.e5saidonmove))
				{
					level thread say_dialogue("hes_on_move");
					level.e5saidonmove = 1;
				}
				else if (i >1 && chance > 25 && level.difficulty < 3 && !isdefined(level.e5saidamrun))
				{
					level thread say_dialogue("amsel_running");
					level.e5saidamrun = 1;
				}
				
				level.officer allowedstances("stand", "crouch", "prone");
				level.officer setgoalnode(node);
				level.officer waittill ("goal");
				//node anim_reach_solo(level.officer, "run_cover");
				//node anim_single_solo(level.officer, "run_cover");
			}
			
			flag_clear("officer_running");
				
			if (i==2)
			{
				tank = getent("tank_near_officer", "targetname");
				thread tank_shoot_while_backing();
				tank setspeed(3,1,1);
				if (cointoss())
					level thread say_dialogue("hide_truck", undefined, 1);
				else
					level thread say_dialogue("hide_truck2", undefined, 1);
				if (isdefined(level.officers_sniper) && isalive(level.officers_sniper))
				{
					level thread say_dialogue("kill_bodyguard");
				}
			}
			
			level.officer.animname = "officer";
			//node thread anim_loop_solo(level.officer,"crouchhide", undefined, "stoploop");
			lastnode = node;
			if (i!=1)
			{
				level notify ("officers_sniper_move");
			}
		}
	}
	
	//level thread say_dialogue("behind_car");
	node = getnode("officer_to_horch_node", "targetname");
	flag_wait("car_ready_4_officer");		
	lastnode notify ("stoploop");
	flag_set("officer_running");
	if (flag("driver_dead"))
	{
		level thread officer_last_run();
		return;
	}
	

	tag = "tag_passenger4";
	horch = getent("horch", "targetname");
	org = horch gettagorigin(tag);
	spot = spawn("script_origin", org);
	spot linkto(horch, tag);

	self linkto(horch, tag,(0,0,0), (0,0,0));
	animtime = getanimlength(level.scr_anim["officer"]["horch_getin"]);
	spot thread anim_single_solo(level.officer, "horch_getin", tag, horch);
	level thread driver_wave();
	//level.officer.deathanim = level.scr_anim["officer"][ "horch_deathloop" ];
	
	
	level.officer setgoalnode(node); 
	wait 1;
	level thread say_dialogue("getting_into_car");

	
	if (flag("driver_dead"))
	{
		level.officer stopanimscripted();
		level.officer unlink();
		level thread officer_last_run();
		return;
	}
	
	flag_set("officer_rdy_4_car");
	
	wait animtime - 6;
	
	if (flag("driver_dead"))
	{
		level.officer stopanimscripted();
		level.officer unlink();
		level thread officer_last_run();
		return;
	}

	level notify ("officer_incar");
	//self thread anim_single_solo(self, "ride");
	self.health = 100;

	horch resumespeed(10);
	
	level thread say_dialogue("shoot_driver");
	flag_set("officer_isincar");
	wait 5;
	
	
	if (flag("driver_dead"))
	{
		level.officer stopanimscripted();
		level.officer unlink();
		level thread officer_last_run();
		return;
	}
	horch thread anim_loop_solo(self, "oficer_ride_back", tag, "stoploop", horch);
	level thread officer_ride();

}

officers_sniper_run()
{
	flag_set("officers_sniper_onu");
	level.officers_sniper endon ("death");
	self.health = level.difficulty * 110;
	node = getnode("officer_end_goal", "targetname");
	foundnode = 0;
	shootside = 0;
	for (i=1; i < 5; i++)
	{
		node = getnode("officers_sniper_node"+i, "targetname");
		shootside = 1;

			if (i==2 )
			{
				shootside = 2;
			}
			
			if (i ==3)
			{
				shootside = 2;
			}
			
			flag_set("officers_sniper_running");
			
			if (isdefined(level.officers_sniper.animspot) )
			{
				level.officers_sniper.animspot notify ("stoploop");
				level.officers_sniper.animspot delete();
			}
			
			self setgoalnode(node); 
			self waittill ("goal");
			//self enable_pain();
			self.health = 200;
			flag_clear("officers_sniper_running");
			officers_sniper_snipeu(shootside, node);
	}
	officers_sniper_snipeu(shootside, node);
}

fake_notetrack(guy, time)
{
	guy endon ("death");
	wait time;
	level thread maps\sniper_anim::notify_sniperfire(guy);
}

officers_sniper_snipeu(side, node)
{
	if (isdefined(level.officers_sniper.animspot) )
	{
		level.officers_sniper.animspot notify ("stoploop");
		level.officers_sniper.animspot delete();
	}
	loopanim = undefined;
	level.officers_sniper endon ("death");
	level endon ("officers_sniper_move");
	myanim = undefined;
	shoottime = undefined;
	if (side ==1)
	{
			level.officers_sniper.animname = "officers_sniper";
			myanim = "shoot_l";
			loopanim = "loop_l";
			shoottime = 2;
		}
		else if (side ==2)
		{
			level.officers_sniper.animname = "officers_sniper";
			myanim = "shoot_r";
			loopanim = "loop_r";
			shoottime = 1.5;
		}

	
	shotanimname = level.officers_sniper.animname;
	animspot = spawn("script_origin", node.origin+(0,0,8.865));
	level.officers_sniper.animspot = animspot;
	animspot.angles = node.angles;
	animspot anim_reach_solo(level.officers_sniper,myanim);
	animspot delete();
	
	while(1)
	{
		
		animspot = spawn("script_origin", node.origin+(0,0,8.865));
		level.officers_sniper.animspot = animspot;
		
		animspot.angles = node.angles;
		level.officers_sniper.animname = "officers_sniper";
		animspot thread anim_loop_solo(level.officers_sniper, loopanim, undefined, "stoploop");
		flag_wait("officer_running");
		
		
		animspot notify ("stoploop");		
		
		level.officers_sniper.animname = shotanimname;
		level thread fake_notetrack(level.officers_sniper, shoottime);
		animspot anim_single_solo(level.officers_sniper,myanim);
		level.officers_sniper.animname = "officers_sniper";
		animspot thread anim_loop_solo(level.officers_sniper, loopanim, undefined, "stoploop");
		wait randomfloat(0.4);
		animspot notify ("stoploop");
		animspot delete();
		
	}
}

officer_death()
{
	level endon ("officer_running");
	level.officer waittill ("damage");
	level notify ("officer_shot_incar");
	horch = getent("horch", "targetname");
	//horch setspeed (0,10,10);
	tag = "tag_passenger4";
	org = horch gettagorigin(tag);
	ang = horch gettagangles(tag);
	spot = spawn ("script_origin", org+(-30,100,0) );
	spot.angles = ang;
	level.officer unlink();
	level.officer linkto (spot);
	spot moveto (spot.origin+(-200, 100,-25), 1);
	//level.officer unlink();
	horch.animname = "horch";
	flag_set("did_officer_timescale");
	
	//TUEY Set Music State to AMSEL_IS_DEAD
	setmusicstate("AMSEL_IS_DEAD");
	level notify ("stop_talking");
	herospot = getstruct("reznov_laugh_node", "targetname");
	herospot thread anim_single_solo(level.hero, "reznov_cheer");
	
	level thread do_death_timescale();
	//horch thread anim_single_solo(horch, "amsel_death");
	//level.officer anim_single_solo(level.officer, "horch_death");
	//level.officer startragdoll();
	//wait 0.05;
	//level.officer unlink();
	level.officer.deathanim = level.scr_anim["officer"][ "horch_death" ];
	level.officer.health = 50;
	level.officer dodamage(level.officer.health*10, (level.player.origin) );
}
	

officer_ride()
{
	level endon ("officer_shot_incar");
	level endon ("officer_running");
	level thread officer_death();
	horch = getent("horch", "targetname");
	level endon ("officer_running");
	level.officer endon ("death");
	level.officer.health = 5000;
	myanims = [];
	myanims[0] = "horch_lookback";
	myanims[1] = "horch_wave1";
	myanims[2] = "horch_wave2";
	
	tag = "tag_passenger4";
	
	while(1)
	{
		wait randomintrange(2,5);
		horch notify("stoploop");
		level.officer.animname = "officer";
		horch anim_single_solo(level.officer, myanims[randomint(myanims.size)], tag, horch );
		horch thread anim_loop_solo(level.officer, "oficer_ride_back", tag, "stoploop", horch);
	}
}

clear_on_snipers_death()
{
	level.officers_sniper waittill ("death");
	flag_clear("officers_sniper_running");
}
		
		
	
officer_last_run()
{
	if (flag("officer_last_run") || flag("amsel_dead") )
	{
		return;
	}
	flag_set("officer_last_run");
	level notify ("officer_running");
	level.officer.health = level.difficulty * 70;
	level.officer endon ("death");
	horch = getent("horch", "targetname");
	tag = "tag_passenger4";
	horch notify ("stoploop");
	level.officer.animname = "officer";
	animtime = getanimlength(level.scr_anim["officer"]["horch_getout"]);
	


	horch.animname = "horch";
	horch thread anim_single_solo(horch, "amsel_out");
	horch thread anim_single_solo(level.officer , "horch_getout", tag, horch);
	level.officer unlink();

	wait animtime -0.2;

	level.officer stopanimscripted();
	level.officer set_run_anim("last_run");
	level.officer.deathanim = undefined;
	level.officer.deathanim = level.scr_anim[ "officer" ][ "amsel_shot" ];
	node = getnode("officer_runto_node_6", "targetname");
	getent("lastguys_shootatu3", "target") notify ("trigger");
	level thread say_dialogue("amsel_running", undefined, 0.5);
	level thread say_dialogue("do_not_let", undefined, 2);
	level thread say_dialogue("kill_him");
	level.officer setgoalnode(node); 
	level.officer waittill ("goal");
	iprintlnbold(&"SNIPER_GENERAL_ESCAPED");
	faillines = [];
	faillines[0] = "failed1";
	faillines[1] = "failed2";
	faillines[2] = "failed3";
	level thread say_dialogue(faillines[randomint(faillines.size)]);
	wait 1;
	missionfailed();
	wait 10;
}

officer_run_cycles()
{
	self endon ("death");
	while(1)
	{
		toss = randomint(100);
		if (toss > 40)
		{
			self set_run_anim("low_walk");
		}
		else 
			self reset_run_anim();
		wait (randomintrange(4,10));
	}
	
}

car_getaway()
{
	level endon ("officer_shot_incar");
	level.officer endon ("death");
	level endon ("driver_shot");
	level endon("driver_dead");
	
	if ( flag("driver_dead") )
		return;
	node = getvehiclenode("officer_got_away", "script_noteworthy");
	node waittill ("trigger");
	iprintlnbold(&"SNIPER_GENERAL_ESCAPED");
	faillines[0] = "failed1";
	faillines[1] = "failed2";
	faillines[2] = "failed3";
	level thread say_dialogue(faillines[randomint(faillines.size)]);
	wait 1;
	missionfailed();
	wait 10;
}

kill_bodyguard()
{
	level endon ("setup_line_protection");
	while(1)
	{
		self waittill ("damage");
		guys = getaiarray("axis");
		for (i=0; i < guys.size; i++)
		{
			if (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "bodyguard")
			{
				guys[i] dodamage(guys[i].health, get_players()[0].origin);
				break;
			}
		}
	}

}

officer_health_back(health)
{
	self endon ("death");
	level waittill ("car_stopped");
	self.health = health;
}

do_death_timescale()
{
	wait 0.05;
	settimescale(0.2);
	wait 1;
	settimescale(0.3);
	wait 0.5;
	num = 0.4;
	while(1 > num)
	{
		settimescale(num);
		num = num+0.05;
		wait 0.05;
	}
	settimescale(1);
}
	
officer_dead(guy)
{
	guy waittill ("death");
	flag_set("amsel_dead");
	level notify ("stop_talking");
		
	guys = getaiarray("axis");
	nodes = getnodearray("e5_outside_guyscharge_nodes", "script_noteworthy");
	nodecounter = 0;
	
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(nodes[nodecounter]))
		{
			guys[i] setgoalnode(nodes[nodecounter]);
			nodecounter++;
		}
	}
	
	if (isdefined(level.officers_sniper) && isalive(level.officers_sniper) )
	{
		level.officers_sniper dodamage(level.officers_sniper.health*10, (0,0,0) );
	}
	flag_set("can_save");
	level.hero.ignoreme = true;
	level.hero.ignoreall = true;
	level.hero.pacifist = true;
	level.hero clearentitytarget();
	level.hero clearentitytarget(level.hero.target);
	level.hero clearenemy();
	level.hero.ignoreme = true;
	level.hero.ignoreall = true;
	level.hero.pacifist = true;
	level.player thread player_speed_set(30,5);
	spot = getstruct("reznov_laugh_node", "targetname");

	
	if (!flag("did_officer_timescale"))
	{
		//TUEY Set Music State to AMSEL_IS_DEAD
		setmusicstate("AMSEL_IS_DEAD");
		spot thread anim_single_solo(level.hero, "reznov_cheer");
		do_death_timescale();
		

	}
	objective_controller(9);
	level notify ("officer_dead");
	thread tank_is_mad();
	wait 2;
	wait 10;

}

open_factory_door()
{
	spot = getstructent("factory_door_spot", "targetname");
	level.hero.animname = "hero";
	spot anim_reach_solo(level.hero, "door_open3");
	animtime = getanimlength(level.scr_anim["hero"]["door_open3"]);
	spot thread anim_single_solo(level.hero, "door_open3");
	//wait animtime - 0.5;
	wait animtime - 0.5;
	level.hero stopanimscripted();
	level.hero enable_ai_color();
	getent("post_door_charge_chain", "script_noteworthy") notify ("trigger", level.player);
	spot delete();
}

levelend()
{
	//level.player freezecontrols(true);
	level.player unlink();
	level.player shellshock("sniper_water", 20);
	//level notify ("level_over");
			// To Be Continued...
	bg = NewHudElem(); 
	bg.x = 0; 
	bg.y = 0; 
	bg.horzAlign = "fullscreen"; 
	bg.vertAlign = "fullscreen"; 
	bg.foreground = true; 
	bg SetShader( "black", 640, 480 ); 
	bg.alpha = 0;
	bg FadeOverTime( 10.0 );
	bg.alpha = 1; 

	//TUEY Added "shock" file to control busses and fade out other sounds ()	
	//level thread set_player_shock( "level_end", 20 );

	//	TUEY Sets the music for the END LEVEL section
	setmusicstate("ENDLEVEL");

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		//players[i] FreezeControls( true );
	}

	wait(12 );
	nextmission();
}

tank_is_mad()
{
	level notify ("tank_luv_u");
	tank = getent("tank_near_officer", "targetname");

	
		spot = getstructent("tank_with_vengeance_target", "targetname");
		tank setturrettargetent(spot);
		wait 3;
		tank fireweapon();
		playfx(level._effect["building_wall_explode"], spot.origin, anglestoforward(spot.angles));
		level.player thread player_speed_set(190,1);
		event5_start();
}

tank_on_friendlies()
{
	level endon ("tank_luv_u");
	tank = getent("tank_near_officer", "targetname");
	spot = getstructent("tank_shoot_friendlies_spot", "targetname");
	wait 6;
	tank setturrettargetent(spot);
	wait 2;
	tank fireweapon();
	wait 0.1;
	playfx(level._effect["building_wall_explode"], spot.origin, anglestoforward(spot.angles));
	radiusdamage(spot.origin, 500,99900,98000);
	guys = getaiarray("allies");
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "dudeguys_charge")
		{
			guys[i].health = 10;
			guys[i] magicgrenade(guys[i].origin, guys[i].origin+(0,-20,1), 0.01);
			guys[i] dodamage(guys[i].health*10, (0,0,0));
		}
	}
	chunks = getentarray("tank_shot", "targetname");
	for (i=0; i < chunks.size; i++)
	{
		chunks[i] delete();
	}
	wait 1;
	tank resumespeed(10);
	
	ospot = getstruct("douchespot", "targetname");
	spot = ospot swap_struct_with_origin();
	
	tank setturrettargetent(spot);
	node = getvehiclenode("tank_backupfrom_node", "script_noteworthy");
	spot = getstructent("douchespot", "targetname");


	tank setturrettargetent(spot);
	node waittill ("trigger");
	tank setspeed (0,10,10);
	
	tank fireweapon();
	getent(ospot.targetname+"_geo", "targetname") delete();
	playfx(level._effect["inside_tankhit"], spot.origin, anglestoforward(spot.angles));

	ospot = getstruct("douchespot2", "targetname");
	spot = ospot swap_struct_with_origin();
	wait randomintrange(2,3);
	tank setturrettargetent(spot);
	wait randomintrange(2,5);
	tank fireweapon();
	wait 0.1;
	getent(ospot.targetname+"_geo", "targetname") delete();
	playfx(level._effect["inside_tankhit"], spot.origin, anglestoforward(spot.angles));


	clip = getent("stay_out_of_building_clip", "targetname");
	clip trigger_on();
	clip disconnectpaths();

	
	
	clips = getentarray("chargers_clip", "targetname");
	for (i=0; i < clips.size; i++)
	{
		clips[i] connectpaths();
		clips[i] delete();
	}
	wait 1;
	level notify ("enemies_charge_allies");
	
	guys = grab_ais_by_script_noteworthy("e3_allied_squad", "allies");
	guy	 = grab_ai_by_script_noteworthy("e3_allied_squad_leader", "allies");
	guys = array_add(guys, guy);
	guys2 = grab_ais_by_script_noteworthy("e3_allied_squad_animate", "allies");
	guys = array_combine(guys, guys2);
	for (i=0; i < guys.size; i++)
	{
		guys[i].health = 100;
		guys[i].pacifist = true;
		guys[i].ignoreall = true;
		guys[i] set_force_cover("hide");
		guys[i] ClearEnemy();
		guys[i] thread wait_and_kill(randomintrange(20,40));
	}
	getent("allies_retreat_chain", "targetname") notify ("trigger");
	
	wait 2;
	enemies = getaiarray("axis");
	nodes = getnodearray("e4_enemies_advance_nodes", "script_noteworthy");
	nodecounter = 0;
	for (i=0; i < enemies.size; i++)
	{
		if ( (isdefined(enemies[i].script_noteworthy) 
		 	 		&& enemies[i].script_noteworthy != "bodyguard" 
		   		&& enemies[i].script_noteworthy != "officer2" 						 
		   		&& enemies[i].script_noteworthy != "officer_driver"
		   		&& enemies[i].script_noteworthy != "officers_sniper"
		   		&& enemies[i].script_noteworthy != "lead_bodyguard")
		
				||	!isdefined(enemies[i].script_noteworthy) )
		{
			if (isdefined(nodes[nodecounter]))
				enemies[i] setgoalnode (nodes[nodecounter]);
			enemies[i] thread wait_and_kill(randomintrange(35,50));
			nodecounter++;
		}
	}
	
	wait 7;
	enemies = getaiarray("axis");
	for (i=0; i < enemies.size; i++)
	{
		if ( (isdefined(enemies[i].script_noteworthy) 
		 	 		&& enemies[i].script_noteworthy != "bodyguard" 
		   		&& enemies[i].script_noteworthy != "officer2" 						 
		   		&& enemies[i].script_noteworthy != "officer_driver"
		   		&& enemies[i].script_noteworthy != "officers_sniper"
		   		&& enemies[i].script_noteworthy != "lead_bodyguard")
		
				||	!isdefined(enemies[i].script_noteworthy) )
		{
			spot = getstructent("e4_fake_target", "targetname");
			enemies[i] setentitytarget(spot);
		}
	}

	maps\_spawner::kill_spawnernum(18);	
	wait 7;
	nodes = getnodearray("e3_alley_fallback2_nodes", "script_noteworthy");
	nodecounter = 0;
	enemies = getaiarray("axis");
	for (i=0; i < enemies.size; i++)
	{
		if ( (isdefined(enemies[i].script_noteworthy) 
		 	 		&& enemies[i].script_noteworthy != "bodyguard" 
		   		&& enemies[i].script_noteworthy != "officer2" 						 
		   		&& enemies[i].script_noteworthy != "officer_driver"
		   		&& enemies[i].script_noteworthy != "officers_sniper"
		   		&& enemies[i].script_noteworthy != "lead_bodyguard")
		
				||	!isdefined(enemies[i].script_noteworthy) )
		{
			if (isdefined(nodes[nodecounter]) )
			{
				enemies[i] thread run_offscreen_anddie(nodes[nodecounter]);
				nodecounter++;
			}
		}
	}
	
	enemies = getaiarray("axis");
	nodes = getnodearray("e5_leftoverguys_streetnodes", "script_noteworthy");
	nodecounter = 0;
	for (i=0; i < enemies.size; i++)
	{
		if ( (isdefined(enemies[i].script_noteworthy) 
		 	 		&& enemies[i].script_noteworthy != "bodyguard" 
		   		&& enemies[i].script_noteworthy != "officer2" 						 
		   		&& enemies[i].script_noteworthy != "officer_driver"
		   		&& enemies[i].script_noteworthy != "officers_sniper"
		   		&& enemies[i].script_noteworthy != "lead_bodyguard")
		
				||	!isdefined(enemies[i].script_noteworthy) )
		{
			if (isdefined(nodes[nodecounter]) && !isdefined(enemies[i].death_assigned) )
			{
				enemies[i] setgoalnode(nodes[nodecounter]);
				nodecounter++;
			}
		}
	}
	
}

run_offscreen_anddie(node)
{
	self.death_assigned = true;
	self endon ("death");
	self setgoalnode (node);
	self waittill("goal");
	self thread wait_and_kill(randomintrange(2,5));
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


////***********************EVENT 5 GO MOTHAFUCKA!!!!!******************\\\\\

e5_kill_trigs()
{
	for (i=1; i < 9; i++)
	{
		wait 6;
		getent("e5_killtrig_"+i, "targetname") thread killtrig_loop();
	}
}
	


killtrig_loop()
{
	while(level.player.health > 0)
	{
		if (level.player istouching(self))
		{
			playfx(level._effect["inside_tankhit"], level.player.origin, anglestoforward(level.player.angles));
			wait 0.1;
			level.player dodamage(100, level.player.origin);
			earthquake(0.85, 2, level.player.origin, 600);
			level.player playrumbleonentity("explosion_generic");
			wait 1;
		}
		wait 0.05;
	}
}

hero_dive()
{
	divespot = getstruct("reznov_laugh_node", "targetname");
	level.hero.animname = "hero";
	wait 0.5;
	level.hero.ignoreall = true;
	animtime = getanimlength(level.scr_anim["hero"]["reznov_cheer_dive"]);
	divespot thread anim_single_solo(level.hero, "reznov_cheer_dive");
	level.hero enable_ai_color();
	getent("post_e5_stun_chain", "script_noteworthy") notify ("trigger", level.player);
	wait animtime - 0.05;
	if( level.hero.a.pose != "prone" )
	{
		level.hero.a.pose = "prone"; 
	}
	
}

move_explosion_oneye()
{
	level endon ("lerp_done");
	fakeeye = spawn("script_model", level.player.origin);
	fakeeye.angles = level.player.angles;
	fakeeye setmodel("tag_origin");
	playfxontag(level._effect["temp_bb_explode"], fakeeye, "tag_origin");
	while(1)
	{
		fakeeye.origin = level.player geteye();
		fakeeye.angles = (0,0,0);
		wait 0.05;
	}
}
event5_start()
{

	playsoundatposition("exp_amsel_dead", (0,0,0));
	level.hero.dontavoidplayer = true;
	level.hero.grenadeawareness = 0;
	level.player disableweapons();
			// hackey so i dont have to redo cruncher, moving trigger

	level thread maps\_utility::autosave_by_name( "wall_blown" );
	level thread maps\_autosave::autosave_game_now( "wall_blown" );

	//set music state to "CHASE"
	//setmusicstate("CHASE");
	
	level.hero.pacifist = true;
	level.hero.ignoreall = true;
	level.hero.ignoreme = true;
	level.hero clearentitytarget();
	level.hero clearentitytarget(level.hero.target);
	level.hero clearenemy();
	level.hero disable_pain();
		
	trig = getent("snipe_officer_chain", "targetname");
	if (isdefined(trig))
	{
		trig delete();
	}

	clips= getentarray("e5_door", "targetname");
	for (i=0; i < clips.size; i++)
	{
		clips[i] connectpaths();
		clips[i] delete();
	}
	
	clips= getentarray("e5_door_block", "targetname");
	for (i=0; i < clips.size; i++)
	{
		clips[i] trigger_on();
	}

	spot = getstructent("player_stunned_by_e5_tank", "targetname");
	spot1 = spawn("script_model", spot.origin);
	spot1.angles = spot.angles;
	spot1 setmodel("tag_origin");
	
	level thread move_explosion_oneye();
	earthquake(0.7, 2, level.player.origin, 600);
	wait 0.1;

	
	wall1 = getentarray("e5_wall_hit_first", "targetname");
	for (i=0; i < wall1.size; i++)
	{
		wall1[i] delete();
	}
	
	//set music state to "CHASE"
	setmusicstate("CHASE");
	
	level thread hero_dive();

	level.player lerp_player_view_to_tag( spot1, "tag_origin", 0.4, 1, 0, 0, 0, 0 );
	level.player unlink();

	level.player playrumbleonentity("explosion_generic");
	level.player shellshock( "tankblast", 4 );// fade out over 1 sec, wait 2, fade in over 5
	level.player allowstand(false);
	level.player allowcrouch(false);
	level.player allowprone(true);
	level.player allowjump(false);
	level.player setstance("prone");
	level.player thread	player_speed_set(5, 5);
	animtime = getanimlength(level.scr_anim["hero"]["tankblast_dive"]);
	level thread scareshots();
	wait animtime - 3.1;
	level notify ("lerp_done");
	wait 1.5;
	level thread say_dialogue("we_must_go");
	level thread say_dialogue("before_tank_fires_again");
	
	level thread e5_playerdown_fakenades();
	wait 1;
	
	spot = getstruct("e5_wall_hit0_spot", "targetname");
	tank = getent("e5_tank", "targetname");
	tank SetTurretTargetVec( spot.origin );

	level.player allowstand(true);
	level.player allowcrouch(true);
	level.player allowprone(true);
	level.player allowjump(true);
	level.player thread	player_speed_set(190, 2);
	level.player setstance("stand");
	level.player enableweapons();
	level thread e5_kill_trigs();
	level.hero.disablearrivals = true;
	level.hero.disableexits = true;
	
	getent("e5_chain2", "targetname") trigger_on();
	level notify ("player_up_after_tankblast");
	getent("e5_firstblast_trig", "script_noteworthy") trigger_on();
	
	getent("e5_chain2", "targetname") waittill ("trigger");
	dtrig = getent("e5_wall_hit0_dtrig", "targetname");		// do damage to player if he stays by wall
	dtrig thread stay_away_fromwall();
	
	tank fireweapon();
	wait 0.05;
	wall1 = getentarray("e5_wall_hit0", "targetname");
	spot = getstruct("e5_wall_hit0_spot", "targetname");
	for (i=0; i < wall1.size; i++)
	{
		wall1[i] delete();
	}

	
	playfx(level._effect["inside_tankhit"], spot.origin, anglestoforward(spot.angles));
	earthquake(0.5, 1, spot.origin, 1000);
	level.player playrumbleonentity("explosion_generic");
	if (distance(spot.origin, level.player.origin) < 500)
	{
		level thread limp_when_hit();
		level.player shellshock ("tankblast", 0.5);
	}
	

	spot = getstruct("e5_wall_hit1_tanktarget", "targetname");
	tank = getent("e5_tank", "targetname");
	tank SetTurretTargetVec( spot.origin );
	spot = getstruct("e5_wall_hit1_spot", "targetname");
	
	getent("e5_chain3", "targetname") waittill ("trigger");
	
	level thread hero_stumble();
	dtrig = getent("e5_wall_hit1_dtrig", "targetname");  // do damage to player if he stays by wall
	dtrig thread stay_away_fromwall();
	
	shotspot = getstructent("fake_mg_fire_target", "targetname");
	//level thread fake_mg_fire(shotspot);
	
		tank fireweapon();
	wait 0.05;
	wall1 = getentarray("e5_wall_hit1", "targetname");
	spot = getstruct("e5_wall_hit1_spot", "targetname");
	for (i=0; i < wall1.size; i++)
	{
		wall1[i] delete();
	}

	playfx(level._effect["inside_tankhit"], spot.origin, anglestoforward(spot.angles));
	earthquake(0.5, 1, spot.origin, 1000);
	level.player playrumbleonentity("explosion_generic");
	if (distance(spot.origin, level.player.origin) < 500)
	{
		level thread limp_when_hit();
	}
	
	spot = getstruct("e5_wall_hit2b_tanktarget", "targetname");
	tank = getent("e5_tank", "targetname");
	tank SetTurretTargetVec( spot.origin );
	spot = getstruct("e5_wall_hit2b_spot", "targetname");
	
	getent("e5_chain3b", "script_noteworthy") waittill ("trigger");
	
	
	dtrig = getent("e5_wall_hit2b_dtrig", "targetname");  // do damage to player if he stays by wall
	dtrig thread stay_away_fromwall();
	
	shotspot = getstructent("fake_mg_fire_target2", "targetname");
	//level thread fake_mg_fire(shotspot);
	
	

	tank fireweapon();
	wait 0.05;
	
	wall1 = getentarray("e5_wall_hit2b", "targetname");
	spot = getstruct("e5_wall_hit2b_spot", "targetname");
	for (i=0; i < wall1.size; i++)
	{
		wall1[i] delete();
	}
	
	playfx(level._effect["inside_tankhit"], spot.origin, anglestoforward(spot.angles));
	earthquake(0.5, 1, spot.origin, 1000);
	level.player playrumbleonentity("explosion_generic");

	level thread limp_when_hit_hard();

	spot = getstruct("e5_wall_hit2_spot", "targetname");
	tank = getent("e5_tank", "targetname");
	tank SetTurretTargetVec( spot.origin);
	
	getent("e5_tank_hit3_trig", "targetname") waittill ("trigger");
	
	level thread e5_bomber_wave();
	dtrig = getent("e5_wall_hit2_dtrig", "targetname");  // do damage to player if he stays by wall
	dtrig thread stay_away_fromwall();
	
	tank fireweapon();
	wait 0.05;
	wall1 = getentarray("e5_wall_hit2", "targetname");
	spot = getstruct("e5_wall_hit2_spot", "targetname");
	for (i=0; i < wall1.size; i++)
	{
		wall1[i] delete();
	}
	playfx(level._effect["inside_tankhit"], spot.origin, anglestoforward(spot.angles));
	earthquake(0.5, 1, spot.origin, 1000);
	level.player playrumbleonentity("explosion_generic");
	if (distance(spot.origin, level.player.origin) < 500)
	{
		level thread limp_when_hit();
	}
	
	spot = getstruct("e5_wall_hit5_spot", "targetname");
	tank = getent("e5_tank", "targetname");
	tank SetTurretTargetVec( spot.origin );
	
	getent("e5_wall_hit5_trig", "targetname") waittill ("trigger");
	spot = getstruct("e5_wall_hit5_spot", "targetname");
	
	tank fireweapon();
	wait 0.05;
	wall1 = getentarray("tank_chunk_attic", "targetname");
	for (i=0; i < wall1.size; i++)
	{
		wall1[i] delete();
	}
	
	
	playfx(level._effect["building_wall_explode"], spot.origin, anglestoforward(spot.angles));
	earthquake(0.5, 1, spot.origin, 1000);
	level.player playrumbleonentity("explosion_generic");
	if (distance(spot.origin, level.player.origin) < 500)
	{
		level thread limp_when_hit();
		level.player shellshock ("tankblast", 0.5);
	}
	
	getent("hideweapon_trig", "targetname") waittill ("trigger");
	
	//level thread player_sucks_atjumping();	// check to see if player dies by falling
	
	level.player disableweapons();	
	
	getent("e5_tank_hit4_trig", "targetname") waittill ("trigger");
	level.player setcandamage(false);
	
	level thread hat_floats();
	setVolFog(60, 155, 75, -200, 0.24, 0.21, 0.14, 1);
	//VisionSetNaked("Sniper_water",1);
	level.player thread	player_speed_set(5, 1);
	deleteit = 0;
	for (i=0; i < 10; i++)
	{
		offset1 = (randomint(20), randomint(20), -1*randomint(5));
		offset2 = (-1*randomint(20), -1*randomint(20), -1*randomint(5));
		offset = offset1 + offset2;
		spot1 = spawn("script_model", (level.player geteye())+(offset) );
		spot1 setmodel("tag_origin");
		spot2 = spawn("script_model", (level.player geteye())+(offset) );
		spot2 setmodel("tag_origin");
		spot1 linkto(level.player);
		spot2 linkto(level.player);
		playfxontag(level._effect["limb_bubbles"], spot1, "tag_origin");
		playfxontag(level._effect["torso_bubbles"], spot2, "tag_origin");
		
		bubblemin = 3;
		bubblemax = 6;
		if (deleteit == 0)
		{
			deleteit = 1;
			level thread wait_and_trigoff(spot1, randomfloat(bubblemin, bubblemax) );
			spot2 thread drag_bubbles();
			
		}
		else if (deleteit == 1)
		{
			level thread wait_and_trigoff(spot1, randomfloat(bubblemin, bubblemax) );
			level thread wait_and_trigoff(spot2, randomfloat(bubblemin, bubblemax) );
		}
	}

	level thread water_bullets();
	
	wait 0.3;
	spot = getstruct("riverfall_spot6", "targetname");
	spot1 = spawn("script_model", spot.origin);
	spot1.angles = spot.angles;
	spot1 setmodel("tag_origin");

	level.player lerp_player_view_to_tag( spot1, "tag_origin", 1.5, 1, 0, 0, 0, 0 );
	level thread objective_controller(10);	// complete objective before level ends, as per showstopper bug
	/*for (i=0; i < structs.size; i++)
	{

		struct = getstruct("riverfall_spot"+i, "targetname");
		linkspot moveto (struct.origin, 0.4);
		angstruct = getstruct("e5_rollspot"+i, "targetname");
		linkspot rotateto (angstruct.angles, 0.4);
		wait 0.4;
	}
	*/
	level thread levelend();
	//level.player unlink();
	//level.player thread	player_speed_set(250, 1);
}

hero_stumble()
{
	node = getnode("e5_hero_stumble_node", "targetname");
	spot = spawn("script_origin", level.hero.origin+(0,0,1) );
	spot.angles = node.angles;
	level.hero.animname = "hero";
	//node anim_reach_solo(level.hero, "bb_stumble3");
	animtime = getanimlength(level.scr_anim["hero"]["bb_stumble3"]);
	dist = distance(node.origin, level.hero.origin);
	if (dist < 50)
	{
		spot thread anim_single_solo(level.hero, "bb_stumble3");
		//level.hero enable_ai_color();
		level.hero disable_ai_color();
		wait animtime - 0.2;
		level.hero.disablearrivals = true;
		level.hero.disableexits = true;
		level.hero reset_run_anim();
	}
	
	level.hero pushplayer(true);
	level.hero.dontavoidplayer = true;
	//level.hero stopanimscripted();
	spot = getstruct("rambov_node", "targetname");
	getent("e5_stairdudes", "target") notify ("trigger");
	
	spot anim_reach_solo(level.hero, "rambov");
	level thread reznov_pwn_stairdudes();
	animtime = getanimlength(level.scr_anim["hero"]["rambov"]);
	spot thread anim_single_solo(level.hero, "rambov");
	level.hero disable_ai_color();
	wait 0.1;
	level thread reznov_ready_tojump();
	wait animtime - 0.9;

	level notify ("calm_down_reznov");
	wait 0.8;
	//level.hero enable_ai_color();
}

water_bullets()
{
	level endon ("level_over");
	counter = 0;
	while(counter < 3)
	{
		wait randomfloatrange(0.5, 2);
		startspot = getstruct("riverfall_spot1", "targetname");
		magicbullet("kar98k", startspot.origin, (level.player geteye() + ( randomintrange(3, 6), randomintrange(3, 6),0) ) );
		wait randomfloatrange(0.5, 2);
		magicbullet("kar98k", startspot.origin, (level.player geteye() + (-1*randomintrange(3, 6),-1*randomintrange(3, 6),0) ) ) ;
		counter++;
	}
}

drag_bubbles()
{
	wait 3;
	spot = spawn ("script_model", level.player.origin);
	spot setmodel("tag_origin");
	spot linkto(level.player);
	for (i=1; i < 5; i++)
	{
		self unlink();
		self linkto (spot, "tag_origin", (0,0,i*-1) );
		wait 1;
	}
}

reznov_pwn_stairdudes()
{
	level endon ("calm_down_reznov");
	level thread say_dialogue("rambov_yell");
	wait 0.7;

	for (i=0; i < 7; i++)
	{
		guy = grab_ai_by_script_noteworthy("e5_stairdude"+i, "axis");
		gunspot = level.hero gettagorigin("tag_flash");
		ang = level.hero gettagangles("tag_flash");
		//playfx(level._effect["fake_rifleflash"] , gunspot, anglestoforward(ang) );
		while(isalive(guy))
		{
			if (!isdefined(guy.deathcounter) )
			{
				guy.deathcounter = 1;
				guy thread wait_and_kill(randomfloatrange(0.25,0.35) );
			}
			playfxontag ( level._effect["fake_rifleflash"], level.hero, "tag_flash");
			gunspot = level.hero gettagorigin("tag_flash");
			magicbullet("ppsh", gunspot, (guy geteye() + random_offset(20,20,20) )   );
			wait 0.08;
			guy dodamage(1,gunspot);
		}
	}
	level.hero.ignoreme = true;
	level.hero.ignoreall = true;
	level.hero.pacifist = true;
	wait 0.2;
	level.hero stopanimscripted();
}

reznov_ready_tojump()
{
	spot = getstruct("e5_resnov_jump_node", "targetname");
	level.hero.animname = "hero";
	node = getnode("jump_target_node", "targetname");
	level.hero setgoalnode(node);
	level.hero waittill ("goal");
	wait 1;
	//spot thread anim_loop_solo(level.hero, "reznov_jump_towater_loop", undefined, "stoploop");
	flag_wait("player_readyto_jump");
	spot notify ("stoploop");
	level thread say_dialogue("into_river");
	level thread say_dialogue("go");
	//spot anim_reach_solo(level.hero, "reznov_jump_towater");
	spot anim_single_solo(level.hero, "reznov_jump_towater");
	animtime = getanimlength(level.scr_anim["hero"]["reznov_fall_towater"]);
	spot anim_single_solo(level.hero, "reznov_fall_towater");
	level.hero playsound("grenade_bounce_water");
	level.hero stopanimscripted();
	newspot = spawn("script_model", level.hero.origin);
	newspot setmodel("tag_origin");
	newspot.angles = (0,270,0);
	level.hero linkto(newspot);
	newspot thread anim_loop_solo(level.hero, "swimming", undefined, "death");
	dest = getstruct("hero_swim_spot", "targetname");
	newspot moveto ( (level.hero.origin[0], level.hero.origin[1], dest.origin[2]) , 0.5);
	newspot rotateto (dest.angles, 1);
	//wait 0.3;
	playfx(level._effect["river_splash"], newspot.origin);
	playsoundatposition("dive_in_plr",(0,0,0));
	waterplayer = spawn("script_origin", newspot.origin);
	waterplayer playloopsound("under_waterF");
	wait 0.5;
	newspot moveto ( 	dest.origin , 0.5);
}

limp_when_hit()
{
	level notify ("limpin");
	level endon ("limpin");
	level.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) );
	level.player PlayerSetGroundReferenceEnt( level.ground_ref_ent );
	get_players()[0] setblur( 2, 0.5 );
	first_limp_point = (6, -18, 0);
	angles = adjust_angles_to_player( first_limp_point );
	level.player thread player_speed_set(110,0.4);
	level.ground_ref_ent rotateto( angles, 0.6, 0.55, 0.05 );
	wait 0.5;
	get_players()[0] setblur( 0, 0.5 );
	second_limp_point = (3, -9, 0);
	angles = adjust_angles_to_player( second_limp_point );
	level.player thread player_speed_set(140,0.2);
	level.ground_ref_ent rotateto( angles, 0.7, 0.65, 0.05 );
	wait 0.3;
	level.player thread player_speed_set(180,1);
	third_limp_point = (0, 0, 0);
	angles = adjust_angles_to_player( third_limp_point );
	level.ground_ref_ent rotateto( angles, 0.5, 0.45, 0.05 );
}

limp_when_hit_hard()
{
	level.player shellshock ("tankblast", 1);
	level notify ("limpin");
	level endon ("limpin");
	level.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) );
	level.player PlayerSetGroundReferenceEnt( level.ground_ref_ent );
	get_players()[0] setblur( 2, 0.5 );
	first_limp_point = (11, -25, 0);
	angles = adjust_angles_to_player( first_limp_point );
	level.player thread player_speed_set(50,0.4);
	level.ground_ref_ent rotateto( angles, 0.6, 0.55, 0.05 );
	wait 1;
	get_players()[0] setblur( 0, 0.5 );
	second_limp_point = (6, 12, 0);
	angles = adjust_angles_to_player( second_limp_point );
	level.player thread player_speed_set(70,0.2);
	level.ground_ref_ent rotateto( angles, 0.7, 0.65, 0.05 );
	wait 0.6;
	level.player thread player_speed_set(180,1);
	third_limp_point = (0, 0, 0);
	angles = adjust_angles_to_player( third_limp_point );
	level.ground_ref_ent rotateto( angles, 0.5, 0.45, 0.05 );
}

fake_mg_fire(shotspot)
{
	firespot = getstructent("fake_mg_fire_spot", "targetname");
	originalspot = shotspot.origin;
	while(1)
	{
		zcoordmod = randomint(10);
		if (cointoss() )
		{
			zcoordmod = zcoordmod*-1;
		}
		shotspot.origin = ( (shotspot.origin[0]+10), shotspot.origin[1],(originalspot[2]+zcoordmod) ) ;
		if (distance(shotspot.origin, originalspot) > 600)
		{
			level notify ("stop_e5_fakefire");
			break;
		}
		trace = bullettrace( firespot.origin, shotspot.origin, false, undefined);
		magicbullet( "mp40", firespot.origin, trace["position"] );
		bullettracer(firespot.origin, trace["position"]);
		wait 0.05;
	}
	originalspot = shotspot.origin;
	while(1)
	{
		zcoordmod = randomint(10);
		if (cointoss() )
		{
			zcoordmod = zcoordmod*-1;
		}
		shotspot.origin = ( (shotspot.origin[0]-10), shotspot.origin[1],(originalspot[2]+zcoordmod) ) ;
		if (distance(shotspot.origin, originalspot) > 600)
		{
			level notify ("stop_e5_fakefire");
			break;
		}
		trace = bullettrace( firespot.origin, shotspot.origin, false, undefined);
		magicbullet( "mp40", firespot.origin, trace["position"] );
		bullettracer(firespot.origin, trace["position"]);
		wait 0.05;
	}
}

stay_away_fromwall()
{
	wait 4;
	testing_patience = 10;
	while(1)
	{
		if (level.player istouching(self))
		{
			magicbullet( "mp40", (level.player geteye())+(0,10,50), level.player geteye());
			level.player dodamage( 10, (level.player geteye())+(0,10,10) );
			velocity = level.player GetVelocity();
			level.player_speed = abs( velocity [0] ) + abs( velocity[1] );
			if (level.player_speed > 10 && testing_patience > 0)
			{
				wait testing_patience;
				testing_patience = testing_patience-0.1;
			}
			else 
			{
				wait 0.2;
			}
		}
		wait 0.05;
	}
}

e5_bomber_wave()
{
	level thread no_double_shake(5);
	level.isshaking = false;
	leadplane = undefined;
	leadplane1 = undefined;

	//Tuey Play's distant incoming planes sound	
	playsoundatposition ("bombers_dist_inc", (1384, 8016, -1944));
	playsoundatposition ("bombers_dist_exit", (1384, 8016, -1944));


	spots = getstructarray("e5_bombers", "targetname");

	planes = [];
	for (i=0; i < spots.size; i++)
	{
		planes[i] = spawn("script_model", spots[i].origin);
		planes[i].angles = spots[i].angles;
		planes[i] setModel( "vehicle_ger_air_condor" );
		
		mph = 85;


		dist = distance( (planes[i].origin[0],0,0), (get_players()[0].origin[0], 0,0) );	//check X coord differentiation of plane and player
		if (dist < 2100) // 900 is about the lod of the dynamic shadows, so if the player will see it, I'll spawn in a plane that draws a shadow where it would look best
		{
			shadowplane_org = (spots[i].origin[0], spots[i].origin[1], 0); // position of the plane but at ground level
			vec =  (1281.4, -892.6, -1853);  // This is the vector that is oppposite of the sundirection, so I know where shadow is
			nvec = vectornormalize(vec);
			x = -30000;
			while(1)  // make sure the spawn position is in the worrld bounds
			{
				spawnpos = shadowplane_org +(nvec*x);
				if (spawnpos[0] < -63000 || spawnpos[1] > 64000 || spawnpos[2] > 32000)
				{
					x = x+1000;
				}
				else
					break;
			}
			
			if (spawnpos[2] > 2000)
			{
				planeshadow = spawn("script_model", spawnpos );
				planeshadow.angles = spots[i].angles;
				planeshadow setModel( "vehicle_ger_air_condor" );
				dest = (planeshadow.origin[0],-64000,planeshadow.origin[2]);
				planeshadow flyto(dest, mph);
				planeshadow playloopsound("bombers");
				planeshadow thread delete_plane_at_end();
			}
			
		}
			
		dest1 = (spots[i].origin[0],30000,spots[i].origin[2]);
		dest2 = (spots[i].origin[0],-64000,spots[i].origin[2]);
		planes[i] flyto(dest2, mph);
		planes[i] thread delete_plane_at_end();
		if (isdefined(leadplane) && planes[i] != leadplane || !isdefined(leadplane) )
		{
			planes[i] thread rotate_plane_roll(0, 7, 1, 5);
		}
		
		// does sniper_stealth_ai_setupuake if plane flies low over player
		if (spots[i].origin[2] < 3000)
		{
			planes[i] thread maps\sniper_event1::wait_n_shake(.15, 10);
			planes[i] thread  maps\sniper_amb::plane_shockwave();
			planes[i] thread maps\sniper_amb::play_low_plane_sounds(mph);
			playfxontag (level._effect["wing_contrails"]	, planes[i], "tag_wingtip_left");
			playfxontag (level._effect["wing_contrails"]	, planes[i], "tag_wingtip_right");
			playfxontag (level._effect["plane_propellor"], planes[i], "tag_engine_fx");
		}

		if (spots[i].origin[2] >= 3000)
		{
				planes[i] playloopsound("bombers");
		}
	}
}

#using_animtree( "sniper_crows" );
hat_floats()
{
	level.player playsound("dive_in_plr");
	wait 0.7;
	spot = getstruct("hatfall_animspot", "targetname");
	hat = spawn ("script_model", spot.origin);
	hat setmodel ("char_rus_guard_ushankaup1");
	wait 0.1;
	hat UseAnimTree(#animtree);
	hat.script_linkto = "origin_animate_jnt";
	playfx(level._effect["limb_bubbles"], hat.origin);
	anim_ents_solo( hat, "float", undefined, undefined, hat, "hat" );
	anim_ents_solo( hat, "float", undefined, undefined, hat, "hat" );
	anim_ents_solo( hat, "float", undefined, undefined, hat, "hat" );
	anim_ents_solo( hat, "float", undefined, undefined, hat, "hat" );
}


event4_damage_control()
{
	level.officer endon ("death");
	player = get_players()[0];
	level.player_hits_sustained = 0;
	modifier = level.difficulty;

	while(1)
	{
		level.player_hits_sustained++;
		player waittill ("damage", amount, attacker);
		if (isdefined(attacker) && attacker.classname != "worldspawn")
		{
			continue;
		}
		
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
		player dodamage(damage_amount * damage_modifier, level.officer.origin);
		wait 2;
	}
}

scareshots()
{
	level endon ("player_up_after_tankblast");
	scareshots = getstructarray("e5_playerdown_scareshot_start", "targetname");
	endshot = getstruct("e5_playerdown_scareshot_target", "targetname");
	shots = randomintrange(100, 110);
	for (i=0; i < shots; i++)
	{
		shotspot = scareshots[randomint(scareshots.size)];
		yoffset = randomint(150);
		zoffset = randomint(25);
		if (cointoss() )
		{
			yoffset = yoffset*-1;
		}
		if (cointoss() )
		{
			zoffset =zoffset*-1;
		}
		thespot = endshot.origin + (0,yoffset, zoffset);
		bullettracer( shotspot.origin ,	thespot , true);
		if (cointoss() )
		{
			magicbullet("kar98k",	shotspot.origin ,	thespot  );
		}
		else
		{
			magicbullet("mp40",	shotspot.origin ,	thespot  );
		}
		wait randomfloatrange(0.1,0.6);
	}
}


e5_playerdown_fakenades()
{
	if (level.difficulty ==1)
	{
		return;
	}
	spots = getstructarray("e5_playerdown_fakenades", "targetname");
	for (i=0; i < spots.size; i++)
	{
		guys = getaiarray("axis");
		if (isdefined(guys[0]) )
		{
			guys[0] MagicGrenade( spots[i].origin, level.player.origin+random_offset(40,20,20) , 5 );
		}
		wait randomfloatrange(0.1,0.7);
	}
}

player_sucks_atjumping()
{
	level.player waittill ("damage", amount, inflictor, direction, point, type, modelName, tagName );
	if (level.player.health < 0 && type == "MOD_FALLING")
	{
		level thread showJumpHint(level.player);
	}
}

showJumpHint(player)
{
	wait 1;
	level.showJumpHintElem = maps\_hud_util::createFontString( "default", 2, player );
	level.showJumpHintElem.color = (1,1,1);
	level.showJumpHintElem setText( &"SNIPER_JUMP_FARTHER" );
	level.showJumpHintElem.x = 0;
	level.showJumpHintElem.y = 20;
	level.showJumpHintElem.alignX = "center";
	level.showJumpHintElem.alignY = "middle";
	level.showJumpHintElem.horzAlign = "center";
	level.showJumpHintElem.vertAlign = "middle";
	level.showJumpHintElem.foreground = true;
	level.showJumpHintElem.alpha = 1;
	level.showJumpHintElem endon ( "death" );
}

pistol_achievement_check()
{
	while(1)
	{
		level.officer waittill ("damage", amount, attacker, direction, point, type);
		if (level.officer.health < 0)
		{
			weap = level.player getcurrentweapon();
			if (weap == "walther" && type != "MOD_GRENADE_SPLASH" )
			{
				level.player maps\_utility::giveachievement_wrapper( "SNIPER_ACHIEVEMENT_GUNSLING");
				return;
			}
		}
	}
}