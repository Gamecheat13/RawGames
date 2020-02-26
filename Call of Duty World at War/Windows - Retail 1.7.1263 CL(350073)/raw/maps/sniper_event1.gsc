#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\sniper;
#include maps\_music;



event1_start()
{
	wait 1;
	level.hero.name = undefined;			// so you can't see his name in green
	level thread hero_wakeup();
	level thread meet_hero();		
	players = get_players();
	array_thread(players, ::wakeup_in_fountain);		// control players vision and stance limitations, some notifies
	level thread out_of_fountain_conditions();			// watches conditions to be met before player moves out of fountain
	thread set_distant_planegroup_speed();					// just sets the speed of distant planes
	thread set_overhead_planegroup_speed();					// sets random speeds of planes overhead
	getent("planes_come_trig", "targetname") waittill ("trigger");
	flag_set("wave1_coming");
	thread plane_controller("wave1");
	wait 8;
	/*
	angles = adjust_angles_to_player( (0,0,-10) );
	level.ground_ref_ent rotateto( angles, 5, 4, 1);		
	wait 10;
	angles = adjust_angles_to_player( (0,0,0) );
	level.ground_ref_ent rotateto( angles, 5, 4, 1);	
	*/
}

event1_shooting_start()
{
	level endon ("player_broke_stealth");
	flag_set("crawl_done");
	
	get_players()[0] takeallweapons();
	level.hero animscripts\shared::placeweaponOn(level.hero.sidearm, "right");

	level thread meet_hero2();

	VisionSetNaked("Sniper_default",1);
	getent("tank_walkers", "target") delete();
	getent("meet_sniper_trig", "targetname") notify ("trigger");
	level thread e1_crouch_by_opening();
	level thread out_of_fountain_conditions();			// watches conditions to be met before player moves out of fountain
	thread set_distant_planegroup_speed();					// just sets the speed of distant planes
	thread set_overhead_planegroup_speed();	
	//level.hero lookatentity(level.player);
	spot = getstruct("fountain_reznov_align_spot", "targetname");
}

#using_animtree( "sniper_crows" );
event1_moveup_start()
{
	wait 10;
	level notify ("event2_started");
	spot = getent("fountain_anim_spot", "targetname");
	corpses = [];
	for (i=1; i < 26; i++)
	{
		corpse = spawn( "script_model" , spot.origin );
		corpse character\char_rus_r_ppsh_forsniper::main();
		corpse UseAnimTree(#animtree);
		corpse.angles = spot.angles;
		corpse.animname = "deadguy";
		corpses = array_add(corpses, corpse);
		if (i==5 || i==6 || i==7 || i==8 || i==5 || i==1 || i==2 || i==4 || i==23 || i==24 || i==25)
		{
			corpse thread maps\sniper_event1::delete_at_gun_pickup();
		}

		//corpse.script_linkto = "tag_origin";
		spot thread anim_single_solo( corpse, "body"+i+"_death");
		iprintln(i);
		wait 1;
	}
	
	setmusicstate("DOG_KILLED");
	flag_set("found_infountain");
	
	VisionSetNaked("Sniper_default",1);
	thread e1_waitfor_player_break_stealth();
	get_players()[0] thread is_player_firing_during_boom();
	thread set_distant_planegroup_speed();
	thread set_overhead_planegroup_speed();
	getent("tank_walkers", "target") delete();
	getent("meet_sniper_trig", "targetname") delete();
	getent("by_wall_opening_trig", "targetname") delete();
	maps\_spawner::kill_spawnernum(1);
	maps\_spawner::kill_spawnernum(2);
	getent("officer_jeep_trig", "targetname") notify ("trigger");
	//thread plane_controller("wave2");
	spots = getstructarray("bombers_distance_start", "targetname");
	planes = [];
	for (i=0; i < spots.size; i++)
	{
		planes[i] = spawn("script_model", spots[i].origin);
		planes[i].angles = spots[i].angles;
		planes[i] setModel( "vehicle_ger_air_condor" );
		destination = (spots[i].origin[0],-64000,spots[i].origin[2]);
		planes[i] flyto(destination, spots[i].speedinmph);
		planes[i] playloopsound ("bombers");
		planes[i] thread delete_plane_at_end();
	}
	thread spawn_fast_planes();
	level thread e1_backtrack_blocking();
	wait 5;
	out_of_fountain();
}

event1d_start()
{
	tp_to_start("event1d");
	wait 10;
	spot = getstruct("sarge_walk_along_spot", "targetname");
	level.hero.animname = "hero";
	animtime = getanimlength(level.scr_anim["hero"]["building_spin"]);
	spot thread anim_single_solo(level.hero, "building_spin");
	wait animtime - 0.05;
	maps\sniper_event2::move_along_road2();
}


groggy_wakeup()
{
		self setstance("prone");
		overlay = newHudElem();
		overlay.x = 0;
		overlay.y = 0;
		overlay setshader( "black", 640, 480 );
		overlay.alignX = "left";
		overlay.alignY = "top";
		overlay.horzAlign = "fullscreen";
		overlay.vertAlign = "fullscreen";
		overlay.alpha = 0;
		overlay.sort = 1;
		
	overlay fadeOverlay( 0.0001, 1, 2 );
			// CROW WOOT
			
	thread crow_animate();
	
	//Sets the busses so that the sniper shot is a little more quiet than normal to make the planes seem 'louder'
	clientnotify("INTRO_BUS");

	battlechatter_off();
	//TUEY Setting Music State to Intro
	setmusicstate("INTRO");


	// play fx for pebble shake
	//exploder(100);
	earthquake(0.1, 30, get_players()[0].origin, 500);
	VisionSetNaked("Sniper_wake",1); 
	self shellshock( "sniper_intro", 55);// fade out over 1 sec, wait 2, fade in over 5
	
	angles = adjust_angles_to_player( (-25,00,30) );
	level.ground_ref_ent rotateto( angles, .2, 0.1, 0.1 );

	//get_players()[0] setwatersheeting(1,15);
	//delaythread(45, ::restore_lookspeed);
	overlay fadeOverlay( 0.01, 1, 2 );
	//level thread spawn_corpsedudes();
	
	angles = adjust_angles_to_player( (-22,00,23) );

	wait 0.2;

	level.ground_ref_ent rotateto( angles, 5 );
	level.player playrumbleonentity("damage_light");
	wait 0.4;
	level.player playrumbleonentity("damage_light");
	wait 0.4;
	//get_players()[0] setwatersheeting(1,6);
	overlay thread fadeOverlay( 2, 0.35, 3);
	//get_players()[0] setwatersheeting(1,9);
	wait 2;
	
	angles = adjust_angles_to_player( (-15,00,5) );
	level.ground_ref_ent rotateto( angles, 3 );

	wait 0.5;
	getent("ftn_walker_early", "targetname") stalingradspawn();
	wait 1.5;
	
	//get_players()[0] setwatersheeting(0,3);
	overlay fadeOverlay( 2.5, 1, 6 );
	get_players()[0] setwatersheeting(0);
	level.player playrumbleonentity("damage_light");
	angles = adjust_angles_to_player( (-7,2, -5) );
	level.ground_ref_ent rotateto( angles, 6, 5, 1 );
	wait 0.5;
	getent("tank_walkers", "target") notify ("trigger");
	level notify ("waking_up");
	overlay fadeOverlay( 2.5, 0.2, 1.5);
  VisionSetNaked("Sniper_default",35);
	
	wait 1;
	//level thread tankrumble();
	wait 1;
	
	overlay fadeOverlay( 1, 1, 6);
	overlay fadeOverlay( 5, 0.2, 1);
	overlay restoreVision( 6, 0 );

	wait 2;
	level notify ("player_wokeup");
	level.ground_ref_ent rotateto( (12,0,0), 7, 2, 5 );
	level waittill ("gunner_fired");
	self freezecontrols(true);

	wait 8;
	self freezecontrols(false);
	wait 5;
	level.ground_ref_ent rotateto( (0,0,0), 2.5, 1.5, 1 );
	level thread do_custom_introscreen();

}

angle_checker()
{
	level endon ("lookup_done");
	while(1)
	{
		angles = level.player getplayerangles();
		if (angles[1] > 130 || angles[1] < 45)
		{
			level notify ("angles_toside");
			level.ground_ref_ent rotateto( (0,0,0), 2, 1, 1 );
			wait 3;
			level.ground_ref_ent rotateto( (0,0,0), 2, 1, 1 );
			wait 3;
			level.ground_ref_ent rotateto( (0,0,0), 2, 1, 1 );
			wait 3;
			level.ground_ref_ent rotateto( (0,0,0), 2, 1, 1 );
			wait 3;
			break;
		}
		wait 0.05;
	}
}

wakeup_in_fountain()
{
	level.ground_ref_ent = spawn( "script_model", (0,0,0) );
	level.player playerSetGroundReferenceEnt( level.ground_ref_ent );
	self thread groggy_wakeup();


	self disableweapons();	
	self takeweapon("mosin_rifle_scoped");
	self allowstand(false);
	self allowcrouch(false);
	self allowprone(true);
	self allowsprint(false);
	self allowjump(false);
	self setstance("prone");
	self hud_hide();
	self Setclientdvar( "bg_prone_yawcap", "25" );
	self.nopronerotation = true;
	self thread player_speed_set(1,1);


	
	self setweaponammostock("stick_grenade", 0);
	self setweaponammoclip("stick_grenade", 0);
	
	get_players()[0] FreezeControls( false );
	wait 20;

	self setweaponammoclip("mosin_rifle_scoped", 0);
	self setweaponammostock("mosin_rifle_scoped", 0);
	self setweaponammostock("stick_grenade", 0);
	self setweaponammoclip("stick_grenade", 0);
	
			// planes fly across in the distance
	spots = getstructarray("bombers_distance_start", "targetname");
	planes = [];
	for (i=0; i < spots.size; i++)
	{
		planes[i] = spawn("script_model", spots[i].origin);
		planes[i].angles = spots[i].angles;
		planes[i] setModel( "vehicle_ger_air_condor" );
		destination = (spots[i].origin[0],-64000,spots[i].origin[2]);
		planes[i] flyto(destination, spots[i].speedinmph);
		planes[i] playloopsound ("bombers");
		planes[i] thread delete_plane_at_end();
		planes[i] thread rotate_plane_roll(1, 7, 1, 5);
	}
	thread spawn_fast_planes();

	wait 33;
	self thread player_speed_set(50,5);
	
	trig = getent("let_player_turn", "targetname");
	trig thread wait_and_notify(30, "trigger");
	trig waittill ("trigger");
	level notify ("resnov_wake");
	self thread player_speed_set(35,0.1);
	wait 5.7;
	self.nopronerotation = false;
	self Setclientdvar( "bg_prone_yawcap", "85" );
	wait 2;
	self thread player_speed_set(58,15);
	wait 15;
	self thread player_speed_set(190,20);
	self enableweapons();

}

spawn_fast_planes()
{
	for (j=1; j < 4; j++)
	{
		spots = getstructarray("plane_group_fast_"+j, "script_noteworthy");
		planes = [];
		speed = randomintrange(90,115);
		for (i=0; i < spots.size; i++)
		{
			planes[i] = spawn("script_model", spots[i].origin);
			planes[i].angles = spots[i].angles;
			planes[i] setModel( "vehicle_ger_air_condor" );
			destination = (spots[i].origin[0],-64000,spots[i].origin[2]);
			planes[i] flyto(destination, speed);
			planes[i] playloopsound ("bombers");
			planes[i] thread delete_plane_at_end();
			planes[i] thread rotate_plane_roll(1, 7, 1, 5);
		}
		wait randomintrange(4,10);
	}
}

delete_plane_at_end()
{
	while(1)
	{
		if (self.origin[1] < -63500)
		{
			self notify ("death");
			self delete();
			return;
		}
		wait 1;
	}
}

set_overhead_planegroup_speed()
{
	plane_groups_done = false;
	num = 0;
	while (plane_groups_done == false)
	{
		planes = getstructarray("wave2_group"+num, "script_noteworthy");
		if (isdefined(planes) && planes.size > 0)
		{
			speed = randomintrange(60,85);
			for (i=0; i < planes.size; i++)
			{
				planes[i].speedinmph = speed;
				if (num==4)
				{
					planes[i].speedinmph = 110;
				}
			}
		}
		else if (!isdefined(planes) || planes.size <= 0)
		{
			plane_groups_done = true;
			break;
		}
		num++;
	}
}

set_distant_planegroup_speed()
{
	plane_groups_done = false;
	num = 0;
	while (plane_groups_done == false)
	{
		planes = getstructarray("plane_group"+num, "script_noteworthy");
		if (isdefined(planes) && planes.size > 0)
		{
			speed = 75;
			for (i=0; i < planes.size; i++)
			{
				planes[i].speedinmph = speed;
			}
		}
		else if (!isdefined(planes) || planes.size <= 0)
		{
			plane_groups_done = true;
			break;
		}
		num++;
	}
}

hero_wakeup()
{
	level.hero.animname = "hero";
	spot = getstruct("fountain_reznov_align_spot", "targetname");
	level.hero animscripts\shared::placeweaponOn(level.hero.weapon, "none");
	level.hero animscripts\shared::placeweaponOn(level.hero.sidearm, "right");
	spot thread anim_loop_solo(level.hero, "resnov_intro_loop", undefined, "stop_loop");
	level waittill ("resnov_wake");
	
	//getent("fountain_anim_spot", "targetname") delete();		// cleanup script_origins
	spots = getentarray("fountain_walkers_spots", "script_noteworthy");
	for (i=0; i < spots.size; i++)
	{
		spots[i] delete();
	}
	
	spot notify ("stop_loop");
	anime = "resnov_crawl";
	animlength = getanimlength(level.scr_anim[level.hero.animname][anime]);
	spot thread anim_single_solo(level.hero, anime);
	//level.hero animscripts\shared::placeweaponOn(level.hero.weapon, "none");
	level.hero animscripts\shared::placeweaponOn(level.hero.sidearm, "right");
	wait 6;		// time to animate before saying shh
	level.hero.name = "Sgt. Reznov";
	wait 10;
	thread objective_controller(1);

	wait animlength - 27;	// time waited so far + time to set flag
	wait 5;
	flag_set("resnov_by_opening");
	//level.hero lookatentity(level.player);
	wait 6;
	
	meet_hero2(); 		// for skipto
}

meet_hero2()
{
	level endon ("player_broke_stealth");
	spot = getstruct("fountain_reznov_align_spot", "targetname");
	flag_set("crawl_done");
	spot thread anim_loop_solo(level.hero, "resnov_wait_loop", undefined, "stop_loop");
	//level.hero animscripts\shared::placeweaponOn(level.hero.weapon, "none");
	level.hero animscripts\shared::placeweaponOn(level.hero.sidearm, "right");

	flag_wait("player_by_opening");
	spot notify ("stop_loop");
	//level thread lookat_on_off(3);
	spot anim_single_solo(level.hero, "resnov_gun");
	level thread maps\_utility::autosave_by_name( "gavegun_save" );
	level thread hud_show();
	//level thread lookat_on_off(4);
	spot anim_single_solo(level.hero, "resnov_info2");
	level thread hud_show();
	level thread wait_and_setflag(10, "planes_wave2_come");
	animtime = getanimlength(level.scr_anim["hero"]["resnov_talk"]);
	//level thread lookat_on_off(4);
	spot anim_single_solo(level.hero, "resnov_talk");

	spot thread anim_loop_solo(level.hero, "resnov_gun_loop", undefined, "stop_loop");

	flag_wait("wave2_plane1_approaches");
	spot notify ("stop_loop");
	spot anim_single_solo(level.hero, "ftn_ready");
	flag_wait("bombers_passing");
	spot anim_single_solo(level.hero, "ftn_shootnow");
	level notify ("shootnow");
	level thread hud_show();
	
	spot notify ("stop_loop");
	spot thread anim_loop_solo(level.hero, "ftn_again_loop", undefined, "stop_loop");


	level waittill ("resnov_jumpout_time");
	spot notify ("stop_loop");
}

ftn_chatter(myanim)
{
	level endon ("found_infountain");
	level endon ("player_broke_stealth");
	level endon ("E1_shooting_done");
	if (flag("E1_shooting_done") || flag("found_infountain") )
		return;
	if (flag("found_infountain_reznov_hide") )
	{
		level thread say_dialogue(myanim);
		return;
	}
	myanim = "ftn_"+myanim;
	flag_waitopen("ftn_chattering");
	flag_set("ftn_chattering");
	spot = getstruct("fountain_reznov_align_spot", "targetname");
	level.hero.animname = "hero";
	spot notify ("stop_loop");
	spot anim_single_solo(level.hero, myanim);
	spot notify ("stop_loop");
	spot thread anim_loop_solo(level.hero, "ftn_again_loop", undefined, "stop_loop");
	wait 0.7;
	flag_clear("ftn_chattering");
}

meet_hero()
{

	trig = getent("meet_sniper_trig", "targetname");
	trig waittill ("trigger");


	level notify ("go_go_ambient_planes");

	trig = getent("by_wall_opening_trig", "targetname");
	trig waittill ("trigger");
	flag_wait("resnov_by_opening");
	//thread books();
	level thread e1_crouch_by_opening();
}

e1_crouch_by_opening()
{
	level endon ("player_broke_stealth");
	thread crouch_hint();
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "1" ); 
	}
	trig = getent("officer_jeep_trig", "targetname");
	thread waittill_player_crouches(trig);
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] allowcrouch(true);
		players[i] allowjump(true);
	}

	thread distance_convoy();
	trig waittill ("trigger");
	
	wait 1;

	horch = getent("officer_horch", "targetname");
	playfxontag(level._effect["horch_headlights"], horch, "tag_headlight_right");
	playfxontag(level._effect["horch_headlights"], horch, "tag_headlight_left");
	flag_set("player_by_opening");
	flag_wait("crawl_done");
	players = get_players();
	
	wait 2;
	
	trigs = getentarray("e1_fountain_trigs", "script_noteworthy");		// clean up fountain trigs
	for (i=0; i < trigs.size; i++)
	{
		trigs[i] delete();
	}
	
	level thread switch_rifles();
	
	flag_wait ("planes_wave2_come");
	thread plane_controller("wave2");
	flag_wait ("takebullets");
	level thread one_less_bullet_check();  // to account for bug if player is holding down button
	wait 7;
	for (i=0; i < players.size; i++)
	{
		players[i] setweaponammostock("mosin_rifle_scoped", 99);
		players[i] thread is_player_firing_during_boom();
		SetSavedDvar( "ammoCounterHide", "0" );
		flag_set("give_player_bullets");
	}
	level thread sarge_say_hah();													// sarge says hah and again when u shoot these dudes
	getent("street_dudes", "target") notify ("trigger");
	level thread e1_waitfor_player_break_stealth();
	wait 1;
	maps\_spawner::kill_spawnerNum(1);

	getent("e1_distance_drones", "target") notify ("stop_drone_loop");
	flag_wait("wave2_plane1_approaches");
	if (!flag("player_is_effed"))
	{
		maps\_utility::autosave_by_name( "shoot_now_save" );
	}
	flag_wait("bombers_passing");
	level thread achievement_checker();
	wait 1;
	level thread encourage_player();

	level thread sniping_timer();
	objective_controller(2);
}

waittill_player_crouches(trig)
{
	crouched = 0;
	while(crouched == 0)
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (players[i] getstance() == "crouch")
			{
				trig notify ("trigger");
				crouched = 1;
				break;
			}
		}
		wait 0.1;
	}
}

out_of_fountain_conditions()
{
	level endon ("player_broke_stealth");
	level thread fail_bomberpass();
	waittill_aigroupcleared("front_doorsmen");
	level notify ("front_doorsmen_cleared");

	wait 1;
	
	clips = getentarray("dog_clips", "targetname");		
	for (i=0; i < clips.size; i++)
	{
		clips[i] trigger_on();
		clips[i] disconnectpaths();	
	}
	
	getent("dog_handler", "script_noteworthy") stalingradspawn();
	wait 5;
	getent("mydog", "script_noteworthy") stalingradspawn();
	wait 1;
	maps\_spawner::kill_spawnernum(5);
	waittill_aigroupcleared("E1_patrollers");
	
	//TUEY SETs Music State to DOG_KILLED -- this should keep the fancy music from playing too long.
	setmusicstate("DOG_KILLED");

	level.hero.health = 99999999;
	level.hero.ignoreme = true;
	level.hero solo_set_pacifist(true);
	level.hero.ignoreall = true;
	
	flag_set("E1_shooting_done");
	
	cleanup_e1_origins();
	
	/*
	for (i=0; i < clips.size; i++)
	{
		clips[i] connectpaths();
		clips[i] delete();	
	}
	*/
	level notify ("E1_shooting_done");
	out_of_fountain();
}

out_of_fountain()
{
	level endon ("player_broke_stealth");
	level notify ("E1_patrollers_dead");
	thread hero_animate_at_horch();
	wait 2;
	players = get_players();
	for (i=0; i < players.size; i++)
	{
		players[i] allowstand(true);
		players[i] allowcrouch(true);
		players[i] allowsprint(true);
		players[i] allowjump(true);
	}
	level notify ("fountain_out");

;
	objective_controller(3);
	trig = getent("E1_player_near_building_trig", "targetname");
	trig waittill ("trigger");
	flag_set("outof_fountain");
	
	thread e1_backtrack_blocking();
	wait 5;


	wait 2;
	trigs = getentarray("player_jumping_by_car_trig", "targetname");
	for (i=0; i < trigs.size; i++)
	{
		trigs[i] trigger_on();
		trigs[i] thread waittill_trig_and_notify(level, "player_broke_stealth");
	}
	wait 3;
	maps\sniper_event2::move_along_road();
}

hero_animate_at_horch()
{
	level endon ("player_broke_stealth");
	//Sets the busses back to normal
	clientnotify("POST_INTRO_BUS");

	level.hero.disablearrivals = true;
	level.hero.disableexits=true;
	
	level.hero endon ("death");
	spot = getstruct("fountain_reznov_align_spot", "targetname");
	level.hero.animname = "hero";
	level notify ("stop_talking");
	
	wait 0.05;
	level notify("resnov_jumpout_time");
	level.hero.ignoreme = true;
	level thread maps\_utility::autosave_by_name( "fountain_out_save" );
	
	if (!flag("found_infountain") )
	{
		
		level.hero animscripts\shared::placeweaponOn(level.hero.weapon, "none");
		spot anim_single_solo(level.hero, "ftn_"+level.e1_timing_feedback);
		animtime = getanimlength(level.scr_anim["hero"]["resnov_jump"]);
		// CCheng (8/29/2008): Helper function moved from mak_anim to _anim for ending
		// a scripted animation a little early so it has a chance to smoothly blend out.
		spot thread anim_single_solo_earlyout(level.hero, "resnov_jump");

		level.hero set_run_anim("e1_street_run");
		wait animtime - 2;
		getent("fountain_clipper", "targetname") delete();
		// CCheng (8/29/2008): End early to match the 0.2s early out of the anim_single_solo().
		wait 1.8;
	}
	else if (flag("found_infountain") )
	{
		level.hero set_run_anim("e1_street_run");
		level thread say_dialogue(level.e1_timing_feedback);
		waittillframeend;
		level thread say_dialogue("close_in");
		waittillframeend;
		level thread say_dialogue("this_way2");
		wait 5;
		getent("fountain_clipper", "targetname") delete();
	}
	
	spot = getstruct("hero_stop_at_horch_spot", "targetname");

	animtime = getanimlength(level.scr_anim["hero"]["e1_street_horchhide"]);
	
	level.hero.disablearrivals = true;	// just keep doin it i guess
	level.hero.disableexits	=true;
	
	level.hero set_run_anim("e1_street_run");
	spot anim_reach_solo(level.hero, "e1_street_horchhide");

	spot thread  anim_single_solo(level.hero, "e1_street_horchhide");
	level thread wait_and_notify(animtime-0.05, "horchhide_done");
	level waittill ("horchhide_done");
	
	
	trig = getent("wave_player_fromhorch", "targetname");
	if (level.player istouching(trig))
	{
		newspot = spawn ("script_origin", level.hero.origin);
		newspot.angles = level.hero.angles;
		//level.hero stopanimscripted();
		animtime = getanimlength(level.scr_anim["hero"]["e1_street_followme"]);
		spot thread anim_single_solo(level.hero, "e1_street_followme");
		level.hero.disablearrivals = true;
		level.hero.disableexits=true;

		wait animtime - 0.14;						// sorta like anim_end_early
		level.hero stopanimscripted();
		newspot delete();
	}
	
	spot = getstructent("sarge_walk_along_spot", "targetname");
	
	spot anim_reach_solo(level.hero, "e1_street_windowhop");
	getent("fight_in_shop_chain", "targetname") notify ("trigger");
	spot anim_single_solo(level.hero, "e1_street_windowhop");
	getent("stupid_reznov_clip", "targetname") connectpaths();		// had to use this because reznov was acting stupid.
	getent("stupid_reznov_clip", "targetname") delete();
	spot notify ("stop_loop");
	spot thread anim_loop_solo(level.hero, "door_wait", undefined, "stoploop");
	flag_set("resnov_outof_event1");
	flag_wait("outof_event1");
	spot notify ("stoploop");
	getent("wave_player_fromhorch", "targetname") delete();
//newspot delete();
}

is_player_firing_during_boom()
{
	self endon ("death");
	level endon ("event2_started");
	self endon ("disconnect");
	while (1)
	{
		while(1)
		{
			self waittill( "action_notify_attack" );
			if (self isfiring())
			{
				wait 0.05;
				break;
			}
			else if (self isthrowinggrenade() )
			{
				wait 4;
				break;
			}
			wait 0.05;
		}
		stealth_condition_checker();
		wait 0.05;
	}
}
	
stealth_condition_checker()
{
	level endon ("player_broke_stealth");
	if ( (!flag("bombers_passing")&& !flag("player_in_shop")) 
		|| (flag("outof_event1") && !flag("player_in_shop")) 
		||  (flag("outof_fountain") && (!flag("player_in_shop") && !flag("outof_event1"))) )  
	{
		level notify ("player_broke_stealth", self);
	

	}
	else if ( (!flag("bombers_passing")&& flag("player_in_shop")) 
				||  (flag("outof_event1") && flag("player_in_shop") ) )
	{
		level notify ("player_broke_stealth_inshop", self);
		level waittill ("shop_area_clear");
	}
}

e1_waitfor_player_break_stealth()
{
	level endon ("event2_started");
	level waittill ("player_broke_stealth", player);
	flag_set("player_is_effed");
	setmusicstate("BROKE_STEALTH");


	level notify ("stop_talking");
	wait 0.01;
	
	if (!flag("failed_by_bombers_passed") )
	{
		thread say_dialogue("u_gave_away");
	}
	else 
	{
		level thread say_dialogue("found_us");
		lines = [];
		lines[0] = "its_too_late";
		lines[1] = "u_should_take_chance";
		lines[2] = "u_let_chance_slip";
		level thread say_dialogue(lines[randomint(2)] );
		
	}
	
	flag_set("not_speaking");
	thread hunters_after_hero();
		
	savetrigs = getentarray("trigger_autosave", "targetname");
	for (i=0; i < savetrigs.size; i++)
	{
		savetrigs[i] trigger_off();
	}
	
	spawners = getentarray("fountain_player_cleanup", "targetname");
	maps\_spawner::flood_spawner_scripted(spawners);
	wait 0.5;
	guys = getaiarray("axis");
	guy = grab_ai_by_script_noteworthy("officer", "axis");
	if (isdefined(guy))
	{
		guys = array_remove (guys, guy);
	}
	guy = grab_ai_by_script_noteworthy("officer_assistant", "axis");
	if (isdefined(guy))
	{
		guys = array_remove (guys, guy);
	}
	for (i=0; i < guys.size; i++)
	{
		
		guys[i] stopanimscripted();
		guys[i].goalradius = 64;
		guys[i] solo_set_pacifist(false);
		guys[i] setgoalentity(get_players()[0]);
		get_players()[0].ignoreme = false;
	}
	spots = getstructarray("stealthbreak_shotspots", "targetname");
	level.hero solo_set_pacifist(false);
	level.hero animscripts\shared::placeweaponOn("ppsh", "right");
	counter = 0;
	while (1)
	{
		players = get_players();
		for(i=0; i < players.size; i++)
		{
			wait randomintrange(3,6);
			counter++;
			//magicbullet("kar98k_scoped", spots[randomint(spots.size)].origin, players[i].origin+(0,0,15) );
			magicbullet("mosin_rifle_scoped_noflash", spots[randomint(spots.size)].origin, players[i].origin+(0,0,15) );
			players[i] thread dodamage_onhit(10*counter);
		}
		
	}
}

dodamage_onhit(amount)
{
	level notify("kill_dodamage_onhit");
	level endon ("kill_dodamage_onhit");
	self waittill ("damage", amount, attacker);
	{
		self dodamage(amount,attacker.origin);
	}
}
							///////////////////////////////////Bomber Stuff\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
plane_controller(wave)
{
	if (flag("player_is_effed"))
		return;
	level endon ("player_broke_stealth");
	level endon ("event2_started");
	level.enginefire_plane_passed = undefined;
	thread no_double_shake(5);  // tracks when planes shake player so shakes dont stack (looks bad)
	if (wave == "wave1")
	{
		thread bomber_wave_come("wave1_planes", 1);
	}
	else if (wave == "wave2")
	{
		thread bomber_wave_come("wave2_planes", undefined, 1);
		wait 1;
		level waittill ("anotherwave");
		if (!flag("E1_shooting_done") )
		{
			thread bomber_wave_come("wave2_planes", undefined, 2);
			wait 1;
			level waittill ("anotherwave");
		}
		if (level.difficulty < 3 &&!flag("E1_shooting_done") )
		{
			if (level.difficulty >=2)
			{
				encourage_player_toshoot(1);
			}
			thread bomber_wave_come("wave2_planes", 1, 1);
			wait 1;
			level waittill ("anotherwave");
		}
		if (level.difficulty ==1 && !flag("E1_shooting_done") )
		{
			encourage_player_toshoot(1);
			wait 0.1;
			thread bomber_wave_come("wave2_planes", 1, 1);
			wait 1;
			level waittill ("anotherwave");
		}
		flag_wait("bombers_passed");
		flag_set("all_bombers_passed");
	}
}

bomber_track(plane, wave2, lastwave, new_configuration)
{
	level notify ("new_bomber_track");
	level endon ("new_bomber_track");
	
	stillpassing = true;
	notified = false;
	ycoord = 34000;  // The position at which a new wave is spawned
	if (isdefined(new_configuration) && new_configuration == 2)
	{
		ycoord = 27000;
	}
	while(stillpassing== true)
	{
		wait 1;
		stillpassing = false;
		if (isdefined(plane) && plane.origin[1] < ycoord && isdefined(wave2) && notified ==false)
		{
			level notify("anotherwave");
			notified = true;
		}
		
		if (isdefined(plane) && plane.origin[1] > -4000)
		{
			stillpassing = true;
		}
				
		if (stillpassing == false)
		{
			notified = false;
			flag_clear("bombers_passing");
			flag_set("bombers_passed");
		}
	}
}

track_wave2_plane1()
{
	while(1)
	{
		if (self.origin[1] < 5000)
		{
			break;
		}
		wait 0.5;
	}
	flag_set("wave2_plane1_approaches");
}

fail_bomberpass()
{
	level endon ("E1_patrollers_dead");
	flag_wait("all_bombers_passed");
	flag_set("failed_by_bombers_passed");
	guys = getaiarray("axis");

	
	if (guys.size > 0 && !flag("player_in_shop") )
	{
		level notify ("player_broke_stealth", get_players()[0]);
	}
}


bomber_wave_come(planenames, lastwave, new_configuration, shadowdistdraw)
{
	
	leadplane = undefined;
	leadplane1 = undefined;

	//Tuey Play's distant incoming planes sound	
	playsoundatposition ("bombers_dist_inc", (1384, 8016, -1944));
	playsoundatposition ("bombers_dist_exit", (1384, 8016, -1944));

	if (isdefined(new_configuration) && new_configuration == 1)
	{
		spots = getstructarray("wave2_planes", "targetname");
	}
	else if (isdefined(new_configuration) && new_configuration == 2)
	{
		spots = getstructarray("wave2_planes2", "targetname");
	}
	else if(isdefined(new_configuration) && new_configuration == 3)
	{
		spots = getstructarray("bombers_sniperwave", "targetname");
		mph = 75;
	}
	else
	{
		spots = getstructarray("bombers_start", "targetname");
	}
	planes = [];
	for (i=0; i < spots.size; i++)
	{
		planes[i] = spawn("script_model", spots[i].origin);
		planes[i].angles = spots[i].angles;
		planes[i] setModel( "vehicle_ger_air_condor" );
		if (planenames == "wave1_planes")
		{
			mph = 85;
		}
		else
		{
			if (isdefined(spots[i].speedinmph))
			{
				mph = spots[i].speedinmph;
			}
			else
			{
				mph = 75;
			}
		}
		if (isdefined(spots[i].script_noteworthy)&& spots[i].script_noteworthy == "lead_bomber_start")
		{
			leadplane = planes[i];
			if (planenames == "wave2_planes"&& !isdefined(level.enginefire_plane_passed))
			{
				playfxontag (level._effect["plane_engine_fire"], leadplane, "tag_engine_fx");
				leadplane thread track_wave2_plane1();
				level.enginefire_plane_passed = 1;
				leadplane thread rotate_plane_roll(9, 15, 1.5, 4);
			}
			else if (planenames == "wave2_planes"&& isdefined(level.enginefire_plane_passed) )  // move this plane up because it looks dubm flying so low
			{
				planes[i].origin = spots[i].origin+(0,0,600);
			}
		}
		if (!isdefined(shadowdistdraw))
		{
			shadowdistdraw = 1500;
		}
		dist = distance( (planes[i].origin[0],0,0), (get_players()[0].origin[0], 0,0) );	//check X coord differentiation of plane and player
		if (dist < shadowdistdraw) // 900 is about the lod of the dynamic shadows, so if the player will see it, I'll spawn in a plane that draws a shadow where it would look best
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
		
		// does sniper_stealth_ai_setupuake if plane flies low over player, dont play sounds on first wave via Tuey's request
		if (spots[i].origin[2] < 3000 )
		{
			if (planenames == "wave1_planes")
			{
				planes[i] thread wait_n_shake(.18, 10);
			}
			else
			{
				planes[i] thread wait_n_shake(.08, 10);
			}
			
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
		if (isdefined(spots[i].script_noteworthy)&& spots[i].script_noteworthy == "last_bomber_start")
		{
			lastplane = planes[i];
			wave2 = undefined;
			if (planenames == "wave2_planes")
			{
				wave2 = 1;
			}
			thread bomber_track(lastplane, wave2, lastwave, new_configuration);
		}
	}
	while(1)
	{
		if (!isdefined(leadplane) || leadplane.origin[1] < 4000)
		{
			break;
		}
		wait 0.5;
	}
	flag_clear("bombers_passed");
	if (planenames!= "wave1_planes")
	{
		flag_set("bombers_passing");
	}
}

flyto(dest, mph, hyperspacein, dest2, mph2)
{
	dist = distance(self.origin, dest);
	distinmiles = units_to_miles(dist);
	milespersec = mph / 3600;
	time = distinmiles / milespersec;
	self moveto (dest, time);
	if (isdefined(hyperspacein))
	{
		wait time;
		self flyto(dest2, mph2);
	}
}

rotate_plane_roll(rangelow, rangehigh, timelow, timehigh)
{
	self endon ("death");
	while(isdefined(self))
	{
		time = randomfloatrange(timelow,timehigh);
		roll1 = randomintrange(rangelow,rangehigh);
		self rotateroll(roll1, time );
		wait time;
		self rotateroll( roll1*-1 , time);
		wait time;
		roll2 = randomintrange(rangehigh*-1,rangelow*-1);
		self rotateroll(roll2, time );
		wait time;
		self rotateroll( roll2*-1 ,time);
		wait time;		
	}
}

units_to_miles(num)	// convert inches to miles
{
	return num/63360;  
}
wait_n_shake(mag, time)
{
	level endon("bombers_passed");
	self endon ("death");
	shootnow = false;
	while(1)
	{
		dist = distance(self.origin, get_players()[0].origin);
		if (self.origin[1] < 2200)
		{
			if (level.isshaking == false)
			{
				level notify ("shake_it");
				level.player playrumblelooponentity("tank_rumble");
				earthquake(mag,time, get_players()[0].origin, 500);
				wait time;
				level.player stoprumble("tank_rumble");
			}
			break;
		}
		wait 0.5;
	}
}

no_double_shake(time)
{
	level endon ("e2_sniper_dead");
	while(1)
	{
		level.isshaking = false;
		level waittill ("shake_it");
		level.isshaking = true;
		wait time;
	}
}

event1_trigs_off()
{
	getent("e1_backtrack_blocker", "targetname") trigger_off();
	getent("e1_where_u_goin", "targetname") trigger_off();
	getent("player_panic_inshop", "targetname") trigger_off();
	getent("e5_chain2", "targetname") trigger_off();
	getent("e3_ladderbacktrack_clip", "targetname") trigger_off();
	getent("e3_3rd_floor_chain", "script_noteworthy") trigger_off();
	getent("post_e5_stun_chain", "script_noteworthy") trigger_off();
	getent("last_e3_chain", "targetname") trigger_off();
	getent("e5_firstblast_trig", "script_noteworthy") trigger_off();
	getent("player_backup_bbstairs_blocker", "targetname") trigger_off();
	getent("e3_plank_blocker", "targetname") trigger_off();
	getent("e1_bar_ai_ramp", "targetname") trigger_off();
	getent("E2_sniper_nearmiss_trig", "targetname") trigger_off();
	
	clip = getent("stay_out_of_building_clip", "targetname");
	clip connectpaths();
	clip trigger_off();

	trigs = getentarray("player_jumping_by_car_trig", "targetname");
	for (i=0; i < trigs.size; i++)
	{
		trigs[i] trigger_off();
	}
	
	blocker = getentarray("bb_doorblocker", "targetname");
	for (i=0; i < blocker.size; i++)
	{
		blocker[i] connectpaths();
		blocker[i] moveto(blocker[i].origin+(0,0,-10000), 0.1);
	}
	
	trigs = getentarray("fire_hurts_trigs", "targetname");
	for (i=0; i < trigs.size; i++)
	{
		trigs[i] thread fire_hurts_trigs();
	}
	
	clips= getentarray("e5_door_block", "targetname");
	for (i=0; i < clips.size; i++)
	{
		clips[i] connectpaths();
		clips[i] trigger_off();
	}
	
	clips = getentarray("dog_clips", "targetname");		
	for (i=0; i < clips.size; i++)
	{

		clips[i] connectpaths();	
		clips[i] trigger_off();
	}
	
	
	getent("b2_d", "targetname") hide();
	getent("b1_d", "targetname") hide();
}

e1_backtrack_blocking()
{
	level thread 	e1_player_breaks_stealth_during_pacing();
	getent("into_event2", "targetname") waittill ("trigger");
	//level.hero reset_run_anim();
	getent("e1_backtrack_blocker", "targetname") trigger_on();
	flag_wait("resnov_outof_event1");
	flag_set("outof_event1");
}

e1_player_breaks_stealth_during_pacing()
{
	level endon ("event2_started");
	level waittill ("player_broke_stealth");
	setmusicstate("BROKE_STEALTH");
	
	spawners = getentarray("e1_building_cleaners", "targetname");
	maps\_spawner::flood_spawner_scripted( spawners );
	thread hunters_after_hero();
	wait 10;
	nadespots = getstructarray("e1_grenade_flush_spot", "targetname");
	array_thread(nadespots, ::lob_them_nades);
}

lob_them_nades()
{
	dude = grab_ai_by_script_noteworthy("the_nade_dude", "axis");
	while(1)
	{
		wait randomint(15,30);
		vec = anglestoforward(self.angles);
		nvec = vectornormalize(vec);
		spot2 = spawn("script_origin", self.origin + (nvec*200));
		dude magicgrenade(self.origin, spot2.origin, randomint(5));
		spot2 delete();
	}
}

hunters_after_hero()
{
	level.hero enable_ai_color();
	level notify ("hunters_on_hero");
	level endon ("hunters_on_hero");
	wait 5;
	level.hero stopanimscripted();
	level.hero.allowdeath = 1;
	level.hero.health = 1;
	level.hero solo_set_pacifist(false);
	level.hero animscripts\shared::placeweaponOn("ppsh", "right");
	level.hero thread wait_and_kill(randomintrange(10,20) );
	level.hero waittill ("death");
	wait randomfloat(2);
	if (!isdefined(level.rkilled ))
	{
		iprintlnbold(&"SNIPER_REZNOV_KILLED");
	}
	level.rkilled = true;
	missionfailed();
}

hunters_after_hero_infountain()
{
	level endon ("front_doorsmen_cleared");
	level notify ("hunters_on_hero_infountain");
	level endon ("hunters_on_hero_infountain");
	level.hero waittill ("death");
	wait randomfloat(2);
	if (!isdefined(level.rkilled ))
	{
		iprintlnbold(&"SNIPER_REZNOV_KILLED");
	}
	level.rkilled = true;
	missionfailed();
}


crouch_hint()
{
	level.hintelem = NewHudElem();
	level.hintelem init_results_hudelem(320, 160, "center", "bottom", 1.5, 1.0);
	if( level.console )
		level.hintelem setText(&"SNIPER_HINT_CROUCH");
	else
		level.hintelem setText(&"SCRIPT_PLATFORM_SNIPER_HINT_CROUCH");
	
	while(get_players()[0] getstance() != "crouch" )
	{
		wait 0.2;
	}
	wait 0.5;
	level.hintelem setText("");	
}


init_results_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	self.font = "objective";
}

#using_animtree( "sniper_crows" );
crow_animate()
{
	level thread crow2_animate();
	level thread crow3_animate();
	level thread crow4_animate();
	level thread crow5_animate();
	
	spot = getent("fountain_anim_spot", "targetname");
	crow = spawn ("script_model", spot.origin);
	crow setmodel ("anim_berlin_crow");
	wait 0.1;
	
	level.crow1 = crow;
	crow UseAnimTree(#animtree);
	crow.animname = "crow1_tree";
	spot thread anim_single_solo(crow, "intro");
	animtime = getanimlength(level.scr_anim["crow1_tree"]["intro"]);
	wait animtime;
	

	spot thread anim_single_solo(crow, "loop");
	animtime = getanimlength(level.scr_anim["crow1_tree"]["loop"]);
	wait animtime;

	spot thread anim_single_solo(crow, "loop");
	animtime = getanimlength(level.scr_anim["crow1_tree"]["loop"]);
	flag_wait("crow_flyaway");
	level notify ("crow_flyaway");

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}
	

	spot thread anim_single_solo(crow, "outtro");
	animtime = getanimlength(level.scr_anim["crow1_tree"]["outtro"]);
	wait animtime;
	crow delete();
}

#using_animtree( "sniper_crows" );
crow2_animate()
{
	//crow = getent("crow1", "targetname");
	spot = getent("fountain_anim_spot", "targetname");
	crow = spawn ("script_model",spot.origin);
	crow setmodel ("anim_berlin_crow");
	wait 0.1;
	
	crow UseAnimTree(#animtree);
	crow.animname = "crow2_tree";
	
	spot thread anim_single_solo(crow, "intro");
	animtime = getanimlength(level.scr_anim["crow2_tree"]["intro"]);
	wait animtime;
	
	spot thread anim_single_solo(crow, "loop");
	animtime = getanimlength(level.scr_anim["crow2_tree"]["loop"]);
	wait animtime;
		
	spot thread anim_single_solo(crow, "loop");
	animtime = getanimlength(level.scr_anim["crow2_tree"]["loop"]);
	flag_wait("crow_flyaway");
	
	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}
	
	spot thread anim_single_solo(crow, "outtro");
	animtime = getanimlength(level.scr_anim["crow2_tree"]["outtro"]);
	wait animtime;
	crow delete();
}

#using_animtree( "sniper_crows" );
crow3_animate()
{
	

	//crow = getent("crow1", "targetname");
	spot = getent("fountain_anim_spot", "targetname");
	crow = spawn ("script_model",spot.origin);
	crow setmodel ("anim_berlin_crow");
	level thread  maps\sniper_amb::play_random_crow_sounds(crow);
	wait 0.1;
	
	crow UseAnimTree(#animtree);
	crow.animname = "crow3_tree";
	
	spot fake_anim_loop_solo(crow, "loop");
	level.crow1 = crow;

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}
	
	spot thread anim_single_solo(crow, "outtro");
	animtime = getanimlength(level.scr_anim["crow3_tree"]["outtro"]);
	wait animtime;
	crow delete();
}

fake_anim_loop_solo(guy, anime)
{
	level endon ("player_near_crow");
	while(1)
	{
		self thread anim_single_solo(guy, anime);
		animtime = getanimlength(level.scr_anim[guy.animname][anime]);
		wait animtime;
	}
}

#using_animtree( "sniper_crows" );
crow4_animate()
{

	//crow = getent("crow1", "targetname");
	spot = getent("fountain_anim_spot", "targetname");
	crow = spawn ("script_model",spot.origin);
	crow setmodel ("anim_berlin_crow");
	wait 0.1;
			
	crow UseAnimTree(#animtree);
	crow.animname = "crow4_tree";
	
	spot thread anim_single_solo(crow, "intro");
	animtime = getanimlength(level.scr_anim["crow4_tree"]["intro"]);
	wait animtime;
			
	spot thread anim_single_solo(crow, "loop");
	animtime = getanimlength(level.scr_anim["crow4_tree"]["loop"]);
	flag_wait("guy_fired");
	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}
	
	spot thread anim_single_solo(crow, "outtro");
	animtime = getanimlength(level.scr_anim["crow4_tree"]["outtro"]);
	wait animtime;
	crow delete();
}

#using_animtree( "sniper_crows" );
crow5_animate()
{

	//crow = getent("crow1", "targetname");
	spot = getent("fountain_anim_spot", "targetname");
	crow = spawn ("script_model",spot.origin);
	crow setmodel ("anim_berlin_crow");
	wait 0.1;
	
	crow UseAnimTree(#animtree);
	crow.animname = "facecrow";
	
	
	level.facecrow = crow;
	spot thread anim_single_solo(crow, "loop");
	animtime = getanimlength(level.scr_anim["facecrow"]["loop"]);
	wait animtime;
	
	spot thread anim_single_solo(crow, "outtro");
	animtime = getanimlength(level.scr_anim["facecrow"]["outtro"]);
	thread play_crow_flyaway_delay(crow);
	wait animtime;
	crow delete();
}

play_crow_flyaway_delay(crow)
{
	//wait(1.2 );
	crow playsound("face_raven_fly_away");

}


encourage_player()
{
	level endon ("player_broke_stealth");
	level endon ("E1_shooting_done");
	if (flag("E1_shooting_done"))
	{
		return;
	}
	players = get_players();
	array_thread(players, ::player_activity_checker);
	while(!flag("E1_shooting_done"))
	{
		if (flag("player_fired_check"))
		{
			flag_clear("player_fired_check");
			wait 8;
			if (!flag("player_fired_check"))
			{
				encourage_player_toshoot();
				wait 4;
			}
		}
		else
		{
			wait 12;
			if (!flag("player_fired_check"))
			{
				if (!flag("sargesaidhurry") )
				{
					level thread ftn_chatter("hurry");
					flag_set("sargesaidhurry");
				}
				else
				{
					level thread ftn_chatter("shootnow");
				}
				wait 4;
			}
		}
		wait 0.2;
	}
}
			
player_activity_checker()
{
	while(!flag("E1_shooting_done"))
	{
		self waittill( "action_notify_attack" );
		if (self isfiring())
		{
			wait 0.05;
			flag_set("player_fired_check");
		}
		else if (self isthrowinggrenade() )
		{
			wait 4;
			flag_set("player_fired_check");
		}
		wait 0.05;
	}
}

encourage_player_toshoot(lastwave)
{
	level endon ("player_broke_stealth");
	level endon ("E1_shooting_done");
	if (flag("E1_shooting_done"))
	{
		return;
	}
	guys = getaiarray("axis");
	if (isdefined(lastwave) && !flag("sargesaidhurry") )
	{
		level thread ftn_chatter("hurry");
		flag_set("sargesaidhurry");
		return;
	}
	
	
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i].script_noteworthy ) &&
		(guys[i].script_noteworthy == "by_tank_dude1" || 
		 guys[i].script_noteworthy == "by_tank_dude2" ) )
		{
			level thread ftn_chatter("straight");
			break;
		}
		if (isdefined(guys[i].script_noteworthy ) &&
		(guys[i].script_noteworthy == "by_tank_dude3" || guys[i].script_noteworthy == "by_tank_dude4") )
		{
			if (cointoss())
			{
				level thread ftn_chatter("moreleft");
			}
			else
			{
				level thread ftn_chatter("burning_car");
			}
			break;
		}
		
		if (isdefined(guys[i].script_noteworthy ) &&
		(guys[i].script_noteworthy == "horchguy1" || guys[i].script_noteworthy == "horchguy2") )
		{
			if (cointoss())
			{
				ftn_chatter("bystairs");
				ftn_chatter("aimright");
				break;
			}
		}
	}
}

sarge_say_hah()
{
	level endon ("player_broke_stealth");
	level thread sarge_say_again();
	guy = grab_ai_by_script_noteworthy("horchguy2", "axis");
	guy waittill ("death");
	wait 0.5;
	level thread ftn_chatter("ha");
}

sarge_say_again()
{
	level endon ("player_broke_stealth");
	guy = grab_ai_by_script_noteworthy("by_tank_dude1", "axis");
	guy waittill ("death");
	wait 0.5;
	level thread ftn_chatter("again");
}


restore_lookspeed()
{
	lookspeed = 15;
	while(lookspeed!=45)
	{
		lookspeed++;
		setdvar("bg_shock_lookControl_maxpitchspeed", lookspeed);
		setdvar("bg_shock_lookControl_maxyawspeed", lookspeed);
		wait 0.2;
	}
}

books()
{
	level endon ("books_gone");
	spot = getstruct("temp_book_spot", "targetname");
	while(1)
	{
		wait 5;
		playfx(level._effect["books_tossed"], spot.origin, anglestoforward(spot.angles));
	}
}

spawn_corpsedudes()
{
	spawners = getentarray("ftn_body_spawners", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		ok_to_spawn(1);
		spawners[i] stalingradspawn();
	}
	spawners = getentarray("ftn_body_spawners2", "targetname");
	for (i=0; i < spawners.size; i++)
	{
		ok_to_spawn(1);
		spawners[i] stalingradspawn();
	}
}
	
switch_rifles()
{
		while(1)
		{
			weap = level.player getcurrentweapon();
			if (isdefined(weap) && weap == "mosin_rifle_scoped")
			{
				level notify ("player_pickedup_gun");
				level.player setweaponammoclip("mosin_rifle_scoped", 0);
				level.player setweaponammostock("mosin_rifle_scoped", 0);
				level.fakerifle delete();
				if (flag("give_player_bullets"))
				{
					level.player setweaponammostock("mosin_rifle_scoped", 99);
					level.player thread is_player_firing_during_boom();
					SetSavedDvar( "ammoCounterHide", "0" );
				}
				break;
			}
			wait 0.001;
		}
}


delete_at_gun_pickup()
{
	level waittill ("player_pickedup_gun");
	self delete();
}
	
	
	

sniping_timer()
{
	level endon ("E1_patrollers_dead");
	level endon ("dog_on_u");
	level endon ("found_infountain");
	wait 35;
	level.e1_timing_feedback = "aim_good";
	level.e1_timing_feedback_time = 3;
	wait 20;
	level.e1_timing_feedback = "could_b_quicker";
	level.e1_timing_feedback_time = 5;
}
	
cleanup_e1_origins()
{			// clean up used script_origins
}

achievement_checker()
{
	achieve_check_loop();
	wait 0.05;
	if (flag("E1_shooting_done") && !flag("reznov_shot_street_guys") )
	{
		level.e1_timing_feedback = "excellent_aim";
		level.player maps\_utility::giveachievement_wrapper( "SNIPER_ACHIEVEMENT_AMSEL");
	}
}
	
	
achieve_check_loop()
{
	level endon ("E1_shooting_done");
	level endon ("player_broke_stealth");
	player_has_shot = 0;
	lastclipcount = undefined;
	while(1)
	{
		weap = level.player getcurrentweapon();
		if (weap != "mosin_rifle_scoped")
		{
			waitfor_player_toshoot();
			player_has_shot = 1;
			continue;
		}
		
		clipcount = level.player getcurrentweaponclipammo();
		if (isdefined(lastclipcount) && clipcount > lastclipcount )
		{
			wait 0.2;
			return;
		}
		if (isdefined(lastclipcount) && clipcount < lastclipcount)
		{
			player_has_shot = 1;
		}
		if (player_has_shot == 1 && clipcount == 0)
		{
			wait 0.3;
			return;
		}
		lastclipcount = clipcount;
		wait 0.05;
	}
}

waitfor_player_toshoot()
{
	while(1)
	{
		level.player waittill( "action_notify_attack" );
		if (level.player isfiring() )
		{
			return;
		}
	}
}


one_less_bullet_check()
{
	level endon ("shootnow");
	lastclipcount = level.player getcurrentweaponclipammo();
	lastammocount = level.player 	getammocount("mosin_rifle_scoped");
	while(1)
	{
		clipcount = level.player getcurrentweaponclipammo();
		ammocount = level.player 	getammocount("mosin_rifle_scoped");
		weap = level.player getcurrentweapon();
		if (clipcount < lastclipcount || ammocount < lastammocount)
		{
			level.player notify( "action_notify_attack");
		}
		lastclipcount = clipcount;
		lastammocount = ammocount;
		wait 0.05;
	}
}

