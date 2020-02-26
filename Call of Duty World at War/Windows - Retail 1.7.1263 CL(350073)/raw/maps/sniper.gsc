/*MAP : Sniper


Event 1: 
	A) Tank and troops patrol through shooting at bodies
		- Tank paths
		- Troop patrol paths, animations, stop points to shoot
		- Effects playing from shots
	B) Ambient death effects
		- Flies on corpses
		- Crows feasting on flesh
		- blood running down face
	C) Aftermath-esque crawling around
	D) Sniper friend animating, calling you over
	E) Officer's Car rolls up (probably an escort car too)
	F) Mortar sounds, Random mortar hit
	G) Animations for guys getting out of car, officer going in building, guys patroling
	H) Mortar hit as soon as you get sniper rifle
	I) scattered sniper rifle bullets
	J) Set placement/gameplay for patrolling guys, determine timing of mortar hits
	Extras:
		- Hide HUD in start
	







*/
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\sniper_stealth_logic;
#include maps\_music;
// main function for handeling Snipe_geo
main()
{
			// set that fog!
	setVolFog(759.379, 4196, 276, 358.969, 0.49, 0.56, 0.6, 0.0);
	
			// init those vehicles!
	maps\_panzeriv::main("vehicle_ger_tracked_panzer4v1", "panzeriv", false);
	maps\_jeep::main( "vehicle_ger_wheeled_horch1a_backseat" );
	maps\_halftrack::main("vehicle_ger_tracked_halftrack", undefined, false);
	maps\_truck::main( "vehicle_ger_wheeled_opel_blitz", "opel" );

			// sound go! effects go!

	maps\sniper_fx::main();
				
			// precache go!
	precacheshellshock( "sniper_intro" );
	precacheshellshock( "sniper_water" );
	precacheshellshock( "level_end" );
	precacheshellshock( "tankblast" );
	precacheshellshock( "aftermath" );
	precacheshellshock( "frag_grenade_mp");
	precachemodel("char_rus_guard_ushankaup1");
	precachemodel("vehicle_ger_air_condor");
	precachemodel("vehicle_ger_tracked_halftrack");
	precachemodel("vehicle_ger_wheeled_opel_blitz");
	precachemodel("weapon_rus_ppsh_smg");
	PrecacheModel( "tag_origin_animate" );
	precachemodel( "tag_origin" );
	//precachemodel("weapon_ger_mp40_smg");
	precacheitem("ppsh");
	precacheitem("molotov");
	precacheitem("napalmblob");
	precacheItem( "napalmbloblight" );                                
	precacheitem("mosin_rifle_scoped");
	precacheitem("mosin_rifle_scoped_noflash");
	//precacheitem("kar98k_scoped");
	PrecacheModel("weapon_rus_mosinnagant_scoped_rifle");
	PrecacheModel("anm_okinawa_cigarette_jpn" );
	PrecacheModel("anim_berlin_mannequin");
	PrecacheModel("anim_berlin_mannequin_d");
	precachemodel("anim_sniper_beam_fall");
	precachemodel("viewmodel_rus_guard_player");
	precachemodel("anim_sniper_bookshelf_fall");
	precachemodel("anim_sniper_ceiling_fall2");
	precachemodel("anim_sniper_ceiling_fall3");
	precachemodel("anim_berlin_crow");
	precachemodel("anim_sniper_chandelier_fall");
	precachemodel("anim_berlin_chandelier01");
	precachemodel("anim_sniper_pipe_bust");
	precachemodel("anim_berlin_curtain_beige_d");
	precachemodel("viewmodel_rus_guardsinged_arms");
	precachemodel("viewmodel_rus_guardsinged_player");
	
	precacherumble("tank_rumble");
	precacherumble("explosion_generic");
	precacherumble("damage_light");
	
	stringrefs();
	
			// Skipto's
	default_start( 	maps\sniper_event1::event1_start); 	

	add_start( "event1b", maps\sniper_event1::event1_shooting_start, &"STARTS_SNIPER_EVENT1B" );
	add_start( "event1c", maps\sniper_event1::event1_moveup_start, &"STARTS_SNIPER_EVENT1C" );
	add_start( "event1d", maps\sniper_event1::event1d_start, &"STARTS_SNIPER_EVENT1D"  );
	
	add_start( "event2", maps\sniper_event2::event2_start, &"STARTS_SNIPER_EVENT2" );
	add_start( "event2b", maps\sniper_event2::event2b_start,&"STARTS_SNIPER_EVENT2B"  );
	add_start( "event2c", maps\sniper_event2::event2c_start, &"STARTS_SNIPER_EVENT2C");
	add_start( "event2d", maps\sniper_event2::event2d_start, &"STARTS_SNIPER_EVENT2D");
	add_start( "event2e", maps\sniper_event2::event2e_start, &"STARTS_SNIPER_EVENT2E");
		
	add_start( "event3", maps\sniper_event3::event3_start, &"STARTS_SNIPER_EVENT3");
	add_start( "event3b", maps\sniper_event3::event3b_start, &"STARTS_SNIPER_EVENT3B");
	add_start( "event3c", maps\sniper_event3::event3c_start, &"STARTS_SNIPER_EVENT3C");
	add_start( "event4", maps\sniper_event4::event4_start, &"STARTS_SNIPER_EVENT4");
	add_start( "event5", maps\sniper_event4::event5_skipto, &"STARTS_SNIPER_EVENT5");
	
	
	//level.custom_introscreen = ::custom_introscreen;

			// Dogs go!
	animscripts\dog_init::initDogAnimations();

	// MikeD (6/26/2008): Moved this into _loadout with the other levels.
	//maps\_load::set_player_viewhand_model("viewmodel_rus_guard_player");
	
			// Drones go!
	maps\sniper_anim::drone_custom_run_cycles();
	maps\_drones::init();
		
	
	level.drone_spawnFunction["axis"] = character\char_ger_wrmcht_k98::main;

		
			// level Go!
	level.campaign = "russian";
	maps\_load::main();
	
	level.e1_timing_feedback = "excellent_aim";
	level.e1_timing_feedback_time = 4;	// time length of sound
	
	maps\sniper_anim::main();
	
	maps\_mganim::main();
			// level specific stealth script
	sniper_stealth_main();
	
			// sound
	maps\sniper_amb::main();
	
			// setup all custom spawn functions

			// initailize flags, setup triggers and flags
	level thread init_flags();
	level thread trig_and_flag_setup();
	
	
	switch(getdifficulty() )
	{
		case "easy":
		level.difficulty = 1;
		break;
		case "medium":
		level.difficulty = 2;
		break;
		case "hard":
		level.difficulty = 3;
		break;
		case "fu":
		level.difficulty = 4;
		break;
	}
	
	maps\sniper_ai_spawnfuncs::setup_spawn_functions();
		
	wait_for_first_player();
	get_players()[0] FreezeControls( true );
			// Set up the hero char
	level.hero = getent("sniper_hero", "script_noteworthy");
	level.hero thread hero_setup();
	level.default_goalradius = 32;
	level.explodernum = 0;
	level.linequeue = [];
	level.linequeue2 = [];
	level.animfudgetime = 0.05;
	level.hero_run_anim = "e1_street_run";
	
	
	// Must have threat bias groups to use threatbias groups
	createthreatbiasgroup("russian_squad");
	createthreatbiasgroup("badguys");
	createthreatbiasgroup("ignoreplayer");
	createthreatbiasgroup("hero");
	createthreatbiasgroup("player");
	createthreatbiasgroup("flankers");
	createthreatbiasgroup("newbhater");
	createthreatbiasgroup("newbs");
	
			//***TEMP level.player fix for dog scripts
	level thread dog_script_fix();
			// This thread checks to see if player is in an open area then picks him off
	thread player_in_the_open();
	level thread reset_hero_run_anim_trigs();
	level thread dialogue_interrupted();
	level thread fake_ppsh();
	level thread delete_triggers();
	level thread origin_counter();
	level thread is_player_scoped();
	level thread friendly_fire_check(); // friendly fire system isn't working fullproof so doing my own 
	level.player thread grenadetoss_is_attacking();
	
			// What the compass range "should" be
	setsaveddvar("compassMaxRange", 1500);
	
		// Disable trigs that turn on through script
	level thread maps\sniper_event1::event1_trigs_off();
	battlechatter_off("allies");
	battlechatter_off("axis");
	
	mannequin_org = (2106.81, -1077.02, 148.358);
	mannequin_ang = (0, 206.465, -0.05);
	mannequin = spawn ("script_model", mannequin_org);
	mannequin.angles = mannequin_ang;
	mannequin setmodel("anim_berlin_mannequin");
	level.mannequin = mannequin;
	
	//autosave_now();
	flag_wait("introscreen_complete");
}	
		// copied from coup, basically fades screen to/from black and sets a blur
fadeOverlay( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	get_players()[0] setblur( blur, duration );
	wait duration;
}

		// copied from coup, fades screen from black and sets a blur
restoreVision( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 0, blur );
}
		//**TEMP - will remove when dog scripts are clean
dog_script_fix()
{
	level.player = get_players()[0];
}
	
init_flags()
{
	flag_init("sniper_nearmiss_fired");
	flag_init("hero_inplace_after_nearmiss");
	flag_init("E2_player_on_second_floor_flag");
	flag_init("E2_second_floor_room2_flag");
	flag_init("planes_shaking");
	flag_init("bombers_passed");
	flag_init("bombers_passing");
	flag_init("all_bombers_passed");
	flag_init("wave2_ready");
	flag_init("stopstar_onsarge");
	flag_init("outof_fountain");
	flag_init("outof_event1");
	flag_init("inside_sniper_building");
	flag_init("sarge_at_nearshot_place");
	flag_init("player_at_nearshot_place");
	flag_init("wave2_plane1_approaches");
	flag_init("player_on_bb_floor2");
	flag_init("player_shotat_sniper");
	flag_init("sniper_found_player");
	flag_init("player_in_shop");
	flag_init("player_ready_2b_saved");
	flag_init("player_up_after_fall");
	flag_init("hero_not_speaking");
	flag_set("hero_not_speaking");
	flag_init("takebullets");
	flag_init("sniper_position_called");
	flag_init("ready_to_run");
	flag_init("done_talking_by_nearmiss");
	flag_init("E1_shooting_done");
	flag_init("not_speaking");
	flag_init("E1_another_patrol");
	flag_init("e3_leftguys_come");
	flag_init("e3_fightison");
	flag_init("wave1_coming");
	flag_init("driver_incar");
	flag_init("driver_dead");
	flag_init("1_wheel_shot");
	flag_init("2_wheel_shot");
	flag_init("e3_forward_comrades");
	flag_init("shootanim_done");
	flag_init("resnov_by_opening");
	flag_init("player_by_opening");
	flag_init("sarge_pastu_in_bb");
	flag_init("player_fired_in_e4");
	flag_init("sarge_redy2_prone_bb");
	flag_init("player_fired_check");
	flag_init("tank2_dude_spawned");
	flag_init("sargesaidhurry");
	flag_init("planes_wave2_come");
	flag_init("horchguy1_killed");
	flag_init("sniper_animating");
	flag_init("hero_ready_upstairs");
	flag_init("resnov_outof_event1");
	flag_init("gun_loop_time");
	flag_init("crawl_done");
	flag_init("give_player_bullets");
	flag_init("pro_sniper");
	flag_init("ok_sniper");
	flag_init("newb_sniper");
	flag_init("hero_moveto_stairs");
	flag_init("hero_moveup_stairs");
	flag_init("player_attacking");
	flag_init("pushing_mannequin");
	flag_init("pushing_mannequin_d");
	flag_init("guy_fired");
	flag_init("chand_rdy_to_fall");
	flag_init("recovering");
	flag_init("boards_onu");
	flag_init("limp2");
	flag_init("opening_bar_still");
	flag_init("mannequin_hit");
	flag_init("display_intro");
	flag_init("player_is_effed");
	flag_init("dog_found_you");
	flag_init("bb_escape_ison");
	flag_init("stop_deathstar_fx");
	flag_init("crow_flyaway");
	flag_init("done_chastising_inbar");
	flag_init("officers_sniper_onu");
	flag_init("officers_sniper_running");
	flag_init("car_ready_4_officer");
	flag_init("officer_rdy_4_car");
	flag_init("e3_fight_go");
	flag_init("ftn_chattering");
	flag_init("officer_running");	
	flag_init("rooftop_battle");
	flag_init("player_shotat_helmet");
	flag_init("helmet_trick_time");
	flag_init("postbb_redshirt1_inplace");
	flag_init("postbb_redshirt2_inplace");
	flag_init("postbb_redshirt3_inplace");
	flag_init("friendlies_vignette_go");
	flag_init("officer_to_tank");
	flag_init("reznov_perch_speech1");
	flag_init("did_officer_timescale");
	flag_init("player_passed_bar");
	flag_init("approach_nearshot");
	flag_init("failed_by_bombers_passed");
	flag_init("player_is_ads");
	flag_init("did_noscope");
	flag_init("officer_isincar");
	flag_init("officer_last_run");
	flag_init("alley_flamer_flaming");
	flag_init("alley_leader_animate");
	flag_init("kill_fannout_guys");
	flag_init("hop_down_complete");
	flag_init("player_at_burntrig5");
	flag_init("player_near_crow");
	flag_init("opening_bar_door");
	flag_init("player_is_exposed");
	flag_init("barfight_ison");
	flag_init("found_infountain");
	flag_init("player_readyto_jump");
	flag_init("amsel_dead");
	flag_init("gunner_shoot_now_k");
	flag_init("gunner_shoot_now_k_preset");
	flag_init("gunner_ready_toshoot");
	flag_init("found_infountain_reznov_hide");
	flag_init("reznov_shot_street_guys");
	
}

		//usefull for unpacifisting guys i put ignoreall on, takes out of run anim
solo_set_pacifist(pacifist_state)
{
	self endon ("death");
	if (isdefined(self) && isai(self))
	{
		self.pacifist = pacifist_state;
		if (pacifist_state == false)
		{
			self.maxsightdistsqrd = 90000000;
			self stopanimscripted();
			self.ignoreme = false;
			self.ignoreall = false;
			self.script_sightrange = 90000000;
			self reset_run_anim();
		}
	}
}

hero_setup()
{
	self.name = "Sgt. Reznov";
	self.animname = "hero";
	self solo_set_pacifist(true);
	self.ignoreall = true;
	self.ignoreme = true;
	self.dontavoidplayer = true;
	self set_battlechatter(false);
}

hud_hide()
{
	wait 0.1;
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "0" ); 
		player SetClientDvar( "compass", "0" ); 
		player SetClientDvar( "ammoCounterHide", "1" );
	}
}

hud_show()
{
	wait 0.1;
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "1" ); 
		player SetClientDvar( "compass", "1" ); 
		player SetClientDvar( "ammoCounterHide", "0" );
	}
}

		// copied from hunted, only use at begining of level in fountain
player_speed_set(speed, time)
{
	currspeed = int( getdvar( "g_speed" ) );
	goalspeed = speed;
	if( !isdefined( self.g_speed ) )
		self.g_speed = currspeed;     
	range = goalspeed - currspeed;
	interval = .05;
	numcycles = time / interval;
	fraction = range / numcycles;          
	while( abs(goalspeed - currspeed) > abs(fraction * 1.1) )
	{
		currspeed += fraction;
    setsaveddvar( "g_speed", int(currspeed) );
  	wait interval;
	}
  setsaveddvar( "g_speed", goalspeed );
}
	
grab_ai_by_script_noteworthy(value,side)
{
	guys = getaiarray(side);
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i]) && isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == value)
		{
			return guys[i];
		}
	}
}

grab_ais_by_script_noteworthy(value,side)
{
	guys = getaiarray(side);
	myguys = [];
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i]) && isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == value)
		{
			myguys = array_add(myguys, guys[i]);
		}
	}
	return myguys;
}

delete_triggers()
{
	level thread delete_at_bb();
	//getent("approaching_nearshot_place", "script_noteworthy") thread trigger_and_delete();
	getent("inside_sniper_building_trig", "script_noteworthy") thread trigger_and_delete();
}	

trigger_and_delete()
{
	self endon ("death");
	self waittill ("trigger");
	wait 10;
	self delete();
}

delete_at_bb()
{
	level waittill ("e2_sniper_dead");
	getent("goalvolume_1", "script_noteworthy") delete();
	deletemes = getentarray("e1_playeropen_trigs", "script_noteworthy");
	for (i=0; i < deletemes.size; i++)
	{
		deletemes[i] delete();
	}
}
	
	

		// flags i want to set when triggers get hit, get it out of the way here
trig_and_flag_setup()
{
	getent("E2_player_on_second_floor_trig", "targetname")				 thread notify_and_set_flag("trigger","E2_player_on_second_floor_flag");
	getent("hero_to_spin", "targetname") 													 thread notify_and_set_flag("trigger","player_passed_bar");
	getent("approaching_nearshot_place", "script_noteworthy")			 thread notify_and_set_flag("trigger","approach_nearshot");
	getent("E2_second_floor_room2_trig", "targetname") 						 thread notify_and_set_flag("trigger", "E2_second_floor_room2_flag");
	getent("sarge_up_bb_stairs_chain", "script_noteworthy") 			 thread notify_and_set_flag("trigger", "hero_moveup_stairs");
	getent("chand_fall_trig", "targetname") 											 thread notify_and_set_flag("trigger", "chand_rdy_to_fall");
	getent("approaching_nearshot_place", "script_noteworthy") 		 thread notify_and_set_flag("trigger", "kill_fannout_guys");
  getent("fire_chase_5", "targetname")													 thread notify_and_set_flag("trigger", "player_at_burntrig5");
  //getent("let_player_turn", "targetname")											 thread notify_and_set_flag("trigger", "player_near_crow");
  getent("e5_reznov_jump_trig", "targetname")										 thread notify_and_set_flag("trigger", "player_readyto_jump");


	getent("stairguys_dtrigger", "targetname") 											 thread waittill_damage_and_notify(level, "horchguy1died");
	getent("stairguys_dtrigger", "targetname") 											 thread waittill_damage_and_notify(level, "horchguy2died");

	getent("leftguys_dtrigger", "targetname") 											 thread waittill_damage_and_notify(level, "by_tank_dude3died");
	getent("leftguys_dtrigger", "targetname") 											 thread waittill_damage_and_notify(level, "by_tank_dude4died");
	
	getent("midguys_dtrigger", "targetname") 											 thread waittill_damage_and_notify(level, "by_tank_dude1died");
	getent("midguys_dtrigger", "targetname") 											 thread waittill_damage_and_notify(level, "by_tank_dude2died");
}


		// usefull tool , use on triggers, AI, level, etc.
notify_and_set_flag(mynotify, flag)
{
	self waittill (mynotify);
	flag_set(flag);
}

notify_on_notify(selfnotify, thing, thingnotify)
{
	self waittill (selfnotify);
	thing notify (thingnotify);
}

		// sets custom run anim back to standard combat anim
reset_run_anim()
{
	self endon ("death");
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}
		// usefull to thread and wait on the notify if it can be notified multiple ways
wait_and_notify(waittime, mynotify)
{
	self endon ("death");
	wait waittime;
	self notify (mynotify);
}
		// Since I might run into trouble of a guy being undefined on death..
die_and_notify(guy, mynotify)
{
	guy waittill ("death");
	level notify (mynotify);
}

waittill_and_setflag(mynotify,myflag)
{
	self waittill (mynotify);
	flag_set(myflag);
}

waittill_flag_anddie(myflag)
{
	self endon ("death");
	flag_wait(myflag);
	self dodamage(self.health * 10, (0,0,0) );
}
	


wait_and_setflag(time, myflag)
{
	time = int(time);
	wait time;
	flag_set(myflag);
}

wait_and_clearflag(time, myflag)
{
	time = int(time);
	wait time;
	flag_clear(myflag);
}

wait_and_delete(thing, time)
{
	wait time;
	if (isdefined(thing))
	{
		thing delete();
		thing = "undefined";
	}
}

wait_and_trigoff(thing, time)
{
	wait time;
	if (isdefined(thing))
	{
		thing unlink();
		thing moveto(thing.origin+(0,0,-10000), 0.01);
		wait 0.1;
		thing delete();
		thing = "undefined";
	}
}


wait_and_kill(time, spot)
{
	self endon ("death");
	wait time;
	if (isdefined(spot))
	{
		bullettracer(spot.origin, self geteye(), true);
		magicbullet("ppsh", spot.origin, self geteye());
		self dodamage(self.health*10, spot.origin);
	}
	else
	{
		self dodamage(self.health*10, self.origin);
	}
}

wait_and_chargeplayer(time)
{
	self endon ("death");
	wait time;
	self.goalradius = 128;
	self setgoalentity(level.player);
	self.goalradius = 128;
	
}
		// used for guys talking in front of officer building, play their reaction animation
wake_nearby(guy)
{
	level endon ("player_broke_stealth");
	sn = guy.script_noteworthy;
	guy waittill ("death");
	wait 0.6;
	guys = getaiarray("axis");
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(guys[i]) && isdefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == sn)  // basically the other guy, but setup in case there was more
		{
			guys[i] endon ("death");
			getstruct("guards_talk_spot_original", "targetname") notify ("stoptalk");
			guys[i] stopanimscripted();
			guys[i].animname = "generic";
			guys[i] anim_single_solo(guys[i], "_stealth_find_jog");
			guys[i] solo_set_pacifist(false);
			guys[i] setgoalentity(get_players()[0]);
		}
	}
}

// sets off the guys moving way off in the distance down the street
distance_convoy()
{
	getent("e1_distance_drones", "target") notify ("trigger");  // start drones
	level endon ("event2_started");
	spot = (0,0,-10000);
	angle = (0,0,0);
	vehicles = [];			// array of structs that just stores data for vehicles to spawn
	vehicles[0] = spawnstruct();  
	vehicles[0].mymodel ="vehicle_ger_tracked_panzer4v1";
	vehicles[0].mytargetname = "tank";
	vehicles[0].mytype = "panzeriv";
	vehicles[1] = spawnstruct();
	vehicles[1].mymodel ="vehicle_ger_tracked_halftrack";
	vehicles[1].mytargetname = "halftrack";
	vehicles[1].mytype = "halftrack";
	vehicles[2] = spawnstruct();
	vehicles[2].mymodel ="vehicle_ger_wheeled_opel_blitz";
	vehicles[2].mytargetname = "truck";
	vehicles[2].mytype = "opel";
	lasttype = vehicles[0].mytype;
	startnode = getvehiclenode("distance_convoy_start_node", "targetname");
	endnode   = getvehiclenode("distance_convoy_last_node", "targetname");
	counter = 0;
	while(1)
	{
		countercycle = randomintrange(3,5);
		cur_veh = vehicles[randomintrange(0,2)];
		if (cur_veh.mytype ==lasttype)
		{
			continue;
		}
		lasttype = cur_veh.mytype;
		myvehicle = spawnvehicle(cur_veh.mymodel, cur_veh.mytargetname, cur_veh.mytype, spot, angle);
		myvehicle.vehicletype = cur_veh.mytype;
		myvehicle.script_nomg = true;
		vehicle_init(myvehicle);
		build_treadfx(cur_veh.mytype);
		myvehicle attachpath(startnode);
		myvehicle startpath();
		level thread wait_and_delete(myvehicle, 20); // delete vehicle after it crosses street
		myvehicle setspeed(randomintrange(9,12), 100, 100);
		wait randomintrange(5,9);
		if (counter > countercycle)
		{
			wait randomintrange(15,30);
			counter = 0;
		}
		else 
		{
			counter++;
		}
	}
}


objective_controller(num)
{
	if(num==1)
	{
				// First objective after hopping fence
		objective_add(0, "active", &"SNIPER_OBJ_1");
		objective_current(0);
		level thread star_on_sarge(0, level.hero);
	}
	if(num==2)
	{
		flag_set("stopstar_onsarge");
		objective_state(0, "done");
		objective_delete(0);
		objective_add(1, "active", &"SNIPER_OBJ_2");
		objective_current(1);
		flag_clear("stopstar_onsarge");
		
		level thread streetguys_objective();
	}
	if(num==3)
	{
				// First objective after hopping fence
		objective_state(1, "done");
		objective_add(2, "active", &"SNIPER_OBJ_3", level.hero.origin);
		objective_current(2);
		level thread star_on_sarge(2, level.hero);
	}
	if (num == 4)
	{
		flag_set("stopstar_onsarge");
		objective_state(2, "active");
		objective_add(3, "active", &"SNIPER_OBJ_4");
		objective_current(3);
		level thread star_on_sarge(3, level.e2sniper);
	}
	if (num == 5)
	{
		objective_state(3, "done");
		objective_current(2);
		level thread star_on_sarge(2, level.hero);
	}
	if (num == 6)
	{
		flag_set("stopstar_onsarge");
		objective_state(2, "active");
		objective_add(4, "active", &"SNIPER_OBJ_5");
		objective_current(4);
		level thread star_on_sarge(4, level.hero);
	}
	if (num == 7)
	{
		objective_state(4, "done");
		objective_current(2);
		level thread star_on_sarge(2, level.hero);
	}
	if (num == 8)
	{
		flag_set("stopstar_onsarge");
		objective_state(2, "active");
		objective_add(5, "active", &"SNIPER_OBJ_6");
		objective_current(5);
		level thread star_on_sarge(5, level.officer);
	}
	if (num == 9)
	{
		objective_state(5, "done");
		level notify ("stop_ping");
		objective_current(2);
	}
	if (num == 10)
	{
		objective_state(2, "done");
	}
	
}

star_ping(num)
{
	level notify ("stop_ping");
	wait 0.1;
	level endon ("stop_ping");
	while(1)
	{
		objective_ring(num);
		wait 60;
	}
}

coin_toss()
{
	toss = undefined;
	coin = randomint(100);
	if (coin >= 50)
	{
		toss = "heads";
	}
	else if (coin <= 50)
	{
		toss = "tails";
	}
	return(toss);
}

stringrefs()
{
	precachestring(&"SNIPER_OBJ_1");
	precachestring(&"SNIPER_OBJ_2");
	precachestring(&"SNIPER_OBJ_3");
	precachestring(&"SNIPER_OBJ_5");
	precachestring(&"SNIPER_OBJ_6");
	
	if( level.console )
		precachestring(&"SNIPER_HINT_CROUCH");
	else
		precachestring(&"SCRIPT_PLATFORM_SNIPER_HINT_CROUCH");

	precachestring(&"SNIPER_TO_BE_CONTINUED");
	precachestring(&"SNIPER_GENERAL_ESCAPED");
	precachestring(&"SNIPER_REZNOV_KILLED");
	precachestring(&"SNIPER_JUMP_FARTHER");
	precachestring(&"SNIPER_EASY_PRONE_DESC");

}

		// PLaces objective star on a given actor
star_on_sarge(obj_num, guy)
{
	level thread star_ping(obj_num);
	guy endon ("death");
	wait 1;
	flag_clear("stopstar_onsarge");
	pinger = 0;
	while (isalive(guy))
	{
		pinger++;
		objective_position(obj_num, guy.origin);
		wait 0.2;
		if (flag("stopstar_onsarge"))
		{
			break;
		}
	}
}

streetguys_objective()
{
	guy1 = grab_ai_by_script_noteworthy("horchguy1", "axis");
	guy2 = grab_ai_by_script_noteworthy("horchguy2", "axis");
	level thread star_on_streetguys(10, guy1, guy2);
	
	guy1 = grab_ai_by_script_noteworthy("by_tank_dude1", "axis");
	guy2 = grab_ai_by_script_noteworthy("by_tank_dude2", "axis");
	level thread star_on_streetguys(11, guy1, guy2);
	
	guy1 = grab_ai_by_script_noteworthy("by_tank_dude3", "axis");
	guy2 = grab_ai_by_script_noteworthy("by_tank_dude4", "axis");
	level thread star_on_streetguys(12, guy1, guy2);
}

star_on_streetguys(obj_num, guy1, guy2)
{
	objective_add(obj_num,"current", "", guy1.origin);
	while(isdefined(guy1) && isalive(guy1))
	{
		objective_position(obj_num, guy1.origin);
		wait 0.05;
	}
	while(isdefined(guy2) && isalive(guy2))
	{
		objective_position(obj_num, guy2.origin);
		wait 0.05;
	}
	objective_delete(obj_num);
}

star_street_guys(obj_num)
{
	level endon ("fountain_out");
	level endon ("player_broke_stealth");
	wait 1;
	flag_clear("stopstar_onsarge");
	while(1)
	{
		guys = getaiarray("axis");
		if (isdefined (guys) && guys.size > 0)
		{
			thread star_on_sarge(obj_num, guys[0]);
			guys[0] waittill ("death");
		}
		wait 0.5;
	}
}

waittill_damage_and_notify(thing, mynotify)
{
	self waittill ("damage");
	if (isdefined(self))
	{
		thing notify (mynotify);
	}
}


waittill_trig_and_notify(thing, mynotify)
{
	self waittill ("trigger");
	if (isdefined(self))
	{
		thing notify (mynotify);
	}
}

bad_player_bad()
{
	self waittill ("trigger");
	while(1)
	{
		if (level.player istouching(self) )
		{
			
			guys = getaiarray("axis");
			if (isdefined(guys[0]) )
			{
				tag = guys[0] gettagorigin("tag_flash");
				magicbullet ("mp40", tag, level.player geteye() );
				level.player dodamage( 50, tag);
			}
			else
			{
				tag = level.player geteye()+(0,0,10);
				magicbullet ("mp40", tag, level.player geteye() );
				level.player dodamage( 50, tag);
			}
		}
		wait 0.1;
	}
}


		// This thread checks to see if player is in an open area then picks him off
player_in_the_open()
{
	trigs = getentarray("bad_player_trigger", "targetname");
	array_thread(trigs, ::bad_player_bad);
	trigs = getentarray("player_in_open", "targetname");
	array_thread(trigs, ::waittill_trig_and_notify, level, "player_in_open");
	while(1)
	{
		level waittill ("player_in_open");
		//iprintln("Get back here before you get picked off!");
		wait 2;
		trigs = getentarray("player_in_open", "targetname");
		while(1)
		{
			players = get_players();
			for (i=0; i < players.size; i++)
			{
				for (j=0; j < trigs.size; j++)
				{
					if (players[i] istouching(trigs[j]))
					{
						level notify ("player_broke_stealth");
						wait 1;
						magicbullet ("mosin_rifle_scoped_noflash", level.player.origin + (300, -500, 100),level.player geteye());
						players[i] dodamage(players[i].health * 10, level.player.origin + (300, -500, 100) );
						wait 10;
					}
				}
			}
			wait 1;
		}
	}
}


movespot_around(value1, value2, time)
{
	self endon ("death");
	orig_spot = self.origin;
	while(1)
	{
		self moveto (orig_spot+value1, time);
		wait time;
		self moveto (orig_spot+value2, time);
		wait time;
	}
}

stringint_to_realint(string)
{
	if (string == "1")
	{
		return 1;
	}
	if (string == "2")
	{
		return 2;
	}
	if (string == "3")
	{
		return 3;
	}
	if (string == "4")
	{
		return 4;
	}
	if (string == "5")
	{
		return 5;
	}
	if (string == "6")
	{
		return 6;
	}
}

dialogue_safety()
{
	level endon ("ok_talking_now");
	wait 20;
	flag_set("hero_not_speaking");
}

dialogue_interrupted()
{
	while(1)
	{
		level waittill ("stop_talking");
		level.hero StopSounds();
		level.linequeue = [];
		level.linequeue2 = [];
		//wait 2;
		flag_set("hero_not_speaking");

	}
}
say_dialogue(myline, myflag, timedelay)
{
	if (flag("not_speaking")) 
	{
		return;
	}
	level endon("stop_talking");
	queue = level.linequeue.size;
	level.linequeue[queue] = myline;
	//myqueuepos = level.linequeue.size;
	level.hero.animname = "hero";
	while(1)
	{
		level thread dialogue_safety();
		flag_wait("hero_not_speaking");
		level notify ("ok_talking_now");
		level thread dialogue_safety();
		if (level.linequeue[0] == myline)
		{
			flag_clear("hero_not_speaking");
			level.hero.animname = "hero";
			
					// Sean's facial animation stuff
			stringline = level.scr_sound["hero"][myline];
			level.hero thread maps\_anim::anim_facialFiller( "sound_done" );
      level.hero animscripts\face::SaySpecificDialogue( undefined, stringline, 1.0, "sound_done" );
      level.hero waittill( "sound_done" );
			
			//level.hero anim_single_solo(level.hero, myline);
			for (i=0; i < level.linequeue.size; i++)
			{
				if (isdefined(level.linequeue[i+1]) )
				{
					level.linequeue2[i] = level.linequeue[i+1];
				}
				else
				{
					level.linequeue = [];
				}
			}
			for (i=0; i < level.linequeue2.size; i++)
			{
				level.linequeue[i] = level.linequeue2[i];
			}
			level.linequeue2 = [];


			if (isdefined(myflag))
			{
				flag_set(myflag);
			}
			if (isdefined(timedelay))
			{
				wait timedelay;
			}
			level notify ("ok_talking_now");
			flag_set("hero_not_speaking");
			break;
		}
		wait 0.1;
	}
}

dead_on_arrival()
{
	self waittill ("goal");
	self delete();
}

killspawner_onspawn(num)
{
	wait 2;
	maps\_spawner::kill_spawnernum(num);
}

find_nodes(guys,nodes)
{
	nodecounter = 0;
	for(i=0; i < guys.size; i++)
	{
		dist = 3000;
		if (isdefined(nodes[nodecounter]) )
		{
			mynode = nodes[nodecounter];
			for (j=0; j< nodes.size; j++)
			{
				if (!isdefined(nodes[j].taken) )
				{
					tempdist = distance(guys[i].origin, nodes[j].origin);
					if (tempdist < dist)
					{
						dist = tempdist;
						mynode = nodes[j];
					}
				}
			}
			mynode.taken = true;
			guys[i] setgoalnode(mynode);
		}
		nodecounter++;
	}
}

set_player_shock( var1, var2 )
{
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		players[i] Shellshock( var1, var2 ); 
	}
}

kill_on_goal()
{
	self waittill ("goal");
	self delete();
}

wait_and_print(time, line, ender)
{

}


waittill_trigg_and_print(theline, delaytime)
{
	self waittill("trigger");
	if (isdefined(delaytime))
	{
		wait delaytime;
	}
	iprintln(theline);
}

waittill_trigg_and_say(theline, delaytime)
{
	self waittill("trigger");
	if (isdefined(delaytime))
	{
		wait delaytime;
	}
	level thread say_dialogue(theline);
}

delete_spots()
{
	spots = getentarray("script_origin", "classname");
	for (i=0; i < spots.size; i++)
	{
		if (spots[i].origin[1] > 20000)
			spots[i] delete();
	}
}

ignore_and_run(node)
{
	self endon ("death");
	//self.ignoreall = true;
	self.pacifist = true;
	self setgoalnode(node);
	self waittill ("goal");
	self solo_set_pacifist(false);
}
/*
shot_in_head()
{
     if( damageLocationIsAny("head", "neck" ))
     { 
          do_headshot 
          return true; 
     } 

     return false; 
}

damageLocationIsAny( a, b, c, d, e, f, g, h, i, j, k, ovr ) 
{ 
     /* possibile self.damageLocation's: 
          "torso_upper" 
          "torso_lower" 
          "helmet" 
          "head" 
          "neck" 
          "left_arm_upper" 
          "left_arm_lower" 
          "left_hand" 
          "right_arm_upper" 
          "right_arm_lower" 
          "right_hand" 
          "gun" 
          "none" 
          "left_leg_upper" 
          "left_leg_lower" 
          "left_foot" 
          "right_leg_upper" 
          "right_leg_lower" 
          "right_foot" 
     

     if ( !isdefined( a ) ) return false; 
     if ( self.damageLocation == a ) return true; 
     if ( !isdefined( b ) ) return false;
     if ( self.damageLocation == b ) return true; 
     if ( !isdefined( c ) ) return false; 
     if ( self.damageLocation == c ) return true; 
     if ( !isdefined( d ) ) return false; 
     if ( self.damageLocation == d ) return true; 
     if ( !isdefined( e ) ) return false; 
     if ( self.damageLocation == e ) return true; 
     if ( !isdefined( f ) ) return false; 
     if ( self.damageLocation == f ) return true; 
     if ( !isdefined( g ) ) return false; 
     if ( self.damageLocation == g ) return true; 
     if( !isdefined( h ) ) return false; 
     if( self.damageLocation == h ) return true; 
     if( !isdefined( i ) ) return false; 
     if( self.damageLocation == i ) return true; 
     if( !isdefined( j ) ) return false; 
     if( self.damageLocation == j ) return true; 
     if( !isdefined( k ) ) return false; 
     if( self.damageLocation == k ) return true; 
     assert(!isdefined(ovr)); 
     return false; 
}
*/

tp_to_start(eventname)
{
	level.hero = getent("sniper_hero", "script_noteworthy");
	level.hero allowedstances("stand", "crouch", "prone");
	players = get_players();
	event3_players_start = getstructarray(eventname+"_playerstart", "targetname");
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event3_players_start[i].origin+(0,0,-10000) );
		players[i] setplayerangles( event3_players_start[i].angles);
	}
	wait 0.1;
	hero_start_spot = getstruct(eventname+"_herostart", "targetname");
	level.hero teleport(hero_start_spot.origin, hero_start_spot.angles);
	wait 0.1;
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event3_players_start[i].origin);
		players[i] setplayerangles( event3_players_start[i].angles);
	}
	VisionSetNaked("Sniper_default",1);
	get_players()[0] giveweapon("mosin_rifle_scoped");
	get_players()[0] SwitchToWeapon( "mosin_rifle_scoped" );
	guys = getentarray("wounded_fountain_guys", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i] delete();
	}
}




guys_to_nodes(guys, nodes)
{
	nodecounter = 0;
	for (i=0; i < guys.size; i++)
	{
		if (isdefined(nodes[nodecounter]))
		{
			guys[i] thread ignore_and_run(nodes[nodecounter]);
			nodecounter++;
		}
	}
}

getsquad()
{
	squad = getaiarray("allies");
	squad =	array_remove(squad, level.hero);
	return squad;
}

wait_and_unignore(time)
{
	self endon ("death");
	wait (time);
	self solo_set_pacifist(false);
	self.ignoreme = false;
	self.health = 100;
}

wait_and_spawn(time)
{
	wait time;
	self stalingradspawn();
}

wait_and_openflag(time, myflag)
{
	wait time;
	flag_clear(myflag);
}

wait_and_killspawner(time, num)
{
	wait time;
	maps\_spawner::kill_spawnernum(num);
}
goal_failsafe(time)
{
	self endon ("death");
	self endon ("goal");
	wait time;
	self notify ("goal");
}

reset_hero_run_anim_trigs()
{
	trigs = getentarray("hero_runanim_trigs", "script_noteworthy");
	array_thread (trigs, ::trig_reset_hero_anim);
	trigs = getentarray("hero_downstairs_trigs", "script_noteworthy");
	array_thread (trigs, ::downstairs_runanim);
	trigs = getentarray("hero_upstairs_trigs", "script_noteworthy");
	array_thread (trigs, ::upstairs_runanim);
}

trig_reset_hero_anim()
{
	while(1)
	{
		self waittill ("trigger", triggerer);
		if (triggerer == level.hero)
			break;
		wait 0.05;
	}
	level.hero set_run_anim("e1_street_run");
	wait 2;
	self delete();
}

downstairs_runanim()
{
	while(1)
	{
		self waittill ("trigger", triggerer);
		if (triggerer == level.hero)
			break;
		wait 0.05;
	}
	level.hero set_run_anim("stairs_down");
	wait 2;
	self delete();
}

upstairs_runanim()
{
	while(1)
	{
		self waittill ("trigger", triggerer);
		if (triggerer == level.hero)
			break;
		wait 0.05;
	}
	level.hero set_run_anim("stair_run");
	wait 2;
	self delete();
}

count_teh_time()
{
	level.tehtimecounter = 0;
	while(1)
	{
		level.tehtimecounter = level.tehtimecounter+0.05;
		wait 0.05;
	}
}

fake_ppsh()
{
	level.fake_ppsh = spawn("script_model", ( 112.834, 669.472, 2.01857) );
	level.fake_ppsh.angles = (358.474, 359.958, -88.7951);
	level.fake_ppsh setmodel("weapon_rus_ppsh_smg");
}

stealth_checker()
{
	level endon ("stealthbreak");
	flag_clear("player_attacking");
	self thread action_attack_checker();
	while(1)
	{
		if ( self isfiring() )
		{
			wait 0.1;
			if (flag("player_attacking"))
			{
				level notify ("stealthbreak");
			}
		}
		if ( self isthrowinggrenade() )
		{
			wait 4;
			level notify ("stealthbreak");
		}
		wait 0.05;
	}
}

grenadetoss_is_attacking()
{
	while(1)
	{
		if ( self isthrowinggrenade() )
		{
			self notify( "action_notify_attack" );
		}
		wait 0.05;
	}
}

action_attack_checker()
{
	level endon ("stealthbreak");
	lastclipcount = level.player getcurrentweaponclipammo();
	weap = level.player getcurrentweapon();
	lastammocount = level.player getammocount(weap);
	while(1)
	{
		weap = level.player getcurrentweapon();
		clipcount = level.player getcurrentweaponclipammo();
		ammocount = level.player 	getammocount(weap);
		weap = level.player getcurrentweapon();
		if (clipcount < lastclipcount || ammocount < lastammocount)
		{
			flag_set("player_attacking");
		}
		lastclipcount = clipcount;
		lastammocount = ammocount;
		wait 0.05;
	}
}

streetdudes_findyou()
{
	self endon ("death");
	level waittill ("found_infountain");
	guys_areclose = 0;
	level.e1_timing_feedback = "could_b_quicker";
	flag_set("found_infountain_reznov_hide");
	
	spot = getstruct("fountain_reznov_align_spot", "targetname");
	spot notify ("stop_loop");
	spot thread anim_loop_solo(level.hero, "resnov_gun_loop", undefined, "stop_loop");
	
	
	
	if (isdefined(level.scr_anim[self.animname]["react"]) && isdefined(self.animspot) && isdefined(self.deathanim) )
	{
		self.animspot anim_single_solo(self, "react");
	}
	self solo_set_pacifist(false);
	node = getnode(self.script_noteworthy+"_covernode", "script_noteworthy");
	if (isdefined(node))
	{
		self setgoalnode(node);
	}
	else 
	{
		self	setgoalentity(get_players()[0]);
	}
	self	thread wait_and_chargeplayer(randomintrange(7, 40) );
	
	
	while(guys_areclose == 0)
	{
		axis = getaiarray("axis");
		for (i=0; i < axis.size; i++)
		{
			dist = distance (level.hero.origin, axis[i].origin);
			if (dist < 250)
			{
				guys_areclose = 1;
			}
		}
		wait 0.05;
	}
	
	flag_set("found_infountain");
	spot notify ("stop_loop");
	level.hero stopanimscripted();
	//spot thread anim_loop_solo(level.hero, "resnov_wait_loop", undefined, "stop_loop");
	level.hero.health = 1;
	level.hero solo_set_pacifist(false);
	if (!isdefined(level.hero.saidfoundus))
	{
		level.hero.saidfoundus = 1;
		level thread say_dialogue("found_us");
		level thread maps\sniper_event1::hunters_after_hero_infountain();
	}

}

adjust_angles_to_player( stumble_angles )
{
		pa = stumble_angles[0];
		ra = stumble_angles[2];

		rv = anglestoright( level.player.angles );
		fv = anglestoforward( level.player.angles );

		rva = ( rv[0], 0, rv[1]*-1 );
		fva = ( fv[0], 0, fv[1]*-1 );
		angles = vector_multiply( rva, pa );
		angles = angles + vector_multiply( fva, ra );
		return angles + ( 0, stumble_angles[1], 0 );
}


do_custom_introscreen()
{
	custom_introscreen(&"SNIPER_INTROSCREEN_TITLE", &"SNIPER_INTROSCREEN_DATE", &"SNIPER_INTROSCREEN_PLACE", &"SNIPER_INTROSCREEN_INFO", &"SNIPER_INTROSCREEN_INFO2" );
}

custom_introscreen( string1, string2, string3, string4, string5 )
{
/#
	if( GetDvar( "introscreen" ) == "0" )
	{
		waittillframeend; 
		level notify( "finished final intro screen fadein" ); 
		waittillframeend; 
		flag_set( "starting final intro screen fadeout" );
		waittillframeend; 
		level notify( "controls_active" ); // Notify when player controls have been restored
		waittillframeend; 
		flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" ); 
		return; 
	}

	if( level.start_point != "default" )
	{
		return;
	}
#/

	level.introstring = []; 
	wait 2;
	// TUEY SET MUSIC STATE TO BOMBERS
	setmusicstate ("BOMBERS");
	wait 0.5;
	//Title of level
	if( IsDefined( string1 ) )
	{
		maps\_introscreen::introscreen_create_line( string1, "lower_left" ); 
	}

	wait( 2 );

	
	if( IsDefined( string2 ) )
	{
		maps\_introscreen::introscreen_create_line( string2, "lower_left" ); 
		wait 2;
	}

	if( IsDefined( string3 ) )
	{
		maps\_introscreen::introscreen_create_line( string3, "lower_left" ); 
		wait 1.5;
	}

	
	if( IsDefined( string4 ) )
	{
		maps\_introscreen::introscreen_create_line( string4, "lower_left" ); 
		wait 1.5;
	}

	if( IsDefined( string5 ) )
	{
		maps\_introscreen::introscreen_create_line( string5, "lower_left" ); 
	}

	wait 3;
	level thread maps\_introscreen::introscreen_fadeOutText(); 

}

random_walk()
{
	num = randomint(100);
	if (num < 33)
	{
		return "street_patrol1";
	}
	if (num < 66)
	{
		return "street_patrol2";
	}
	else
	{
		return "street_patrol3";
	}
}

swap_struct_with_origin()
{
	spot = spawn ("script_origin", self.origin);
	if (isdefined(self.angles))
	{
		spot.angles = self.angles;
	}
	return spot;
}

getstructent(key, value)
{
	spot1 = getstruct(key, value);
	spot2 = spawn ("script_origin", spot1.origin);
	if (isdefined(spot1.angles))
	{
		spot2.angles = spot1.angles;
	}
	return spot2;
}


origin_counter()
{
	while(1)
	{
		spots = getentarray("script_origin", "classname");
		trigs = getentarray("trigger_radius", "classname");
		trigs2 = getentarray("trigger_multiple", "classname");
		models = getentarray("script_model", "classname");
		brushes = getentarray("script_brushmodel", "classname");
		dest = getentarray("destructible", "targetname");
		angles = level.player getplayerangles();
		gun = getent("e3_cover_mg", "script_noteworthy");
		nades = level.player getweaponammostock("stick_grenade");
		weap = level.player getcurrentweapon();
		wait 2;
	}
}

delete_origins_afterfight()
{
	level waittill ("e3_fightison");
	wait 2;
	self delete();
}

#using_animtree( "sniper_crows" );
its_curtains_for_ya()
{
	self notify ("newcurtain_anim");
	self endon ("death");
	self endon ("newcurtain_anim");
	if (!isdefined(self.animated))
	{
		self.animated = 1;
	}

	//model = getent("my_curtain", "targetname");
	self UseAnimTree(#animtree);
	self.animname = "curtain";
	spot = getstruct("dog_bark_node", "targetname");
	if ( (!isdefined(self.animating) || (isdefined(self.animating) && self.animating == 0)) && self.animated < 5 )
	{
		wait 0.2;
		myanim = get_curtain_anim("flaming_intro");
		self anim_single_solo(self, myanim);
		if (!isdefined(self.flaming) )
		{
			self thread curtain_fx();
			self.flaming = 1;
		}
		self.animating = 1;
	}
	else
	{
		self.animating = 1;
		myanim = get_curtain_anim("flaming_loop");
		self anim_single_solo(self, myanim);
	}
	self.animated ++;
	myanim = get_curtain_anim("flaming_loop");
	self anim_single_solo(self, myanim);
	animtime = getanimlength(level.scr_anim["curtain"][myanim]);
		
	myanim = get_curtain_anim("flaming_outtro");
	self anim_single_solo(self, myanim);
	self.animating = 0;
	myanim = get_curtain_anim("calm_loop");
	self anim_loop_solo(self, myanim, undefined, "newcurtain_anim");
}	

get_curtain_anim(myanim)
{
	int = randomintrange(1,4);
	mystring = myanim+int;
	return mystring;
}

curtain_fx()
{
	bone = [];
	bone[0]=  "curt_r2_04";
	bone[1] = "curt_r1_01";
	bone[2]	=  "curt_r2_01";
	bone[3]	=  "curt_r3_01";
	bone[4]	=  "curt_r1_02";
	bone[5]	=  "curt_r2_02";
	bone[6] =	"curt_r3_02";
	bone[7] = 	"curt_r1_03";
	bone[8] = 	"curt_r2_03";
	bone[9] =	"curt_r3_03";
	counter = 0;
	while(counter < 4)
	{
		
		for (i=0; i < bone.size; i++)
		{
			toss = randomint(100);
			if (toss > 80 && counter < 5)
			{
				playfxontag(level._effect["fire_debris_small"], self, bone[i]);
				counter++;
			}
		}
	}
}


e2_flamer_struct_movers()
{
	self endon ("death");
	while(1)
	{
		xval = randomint(5);
		zval = randomint(3);
		pitchvar = randomint(10);
		if (cointoss())
		{
			pitchvar = pitchvar * -1;
		}
		yawvar = randomint(10);
		if (cointoss())
		{
			yawvar = yawvar * -1;
		}
		time = randomintrange(2,6);
		self rotateto(self.angles + (pitchvar, yawvar, 0),  time);
		self moveto(self.origin+(xval,0,zval), time);
		wait time;
		self rotateto(self.angles + (pitchvar*-1, yawvar*-1, 0), time);
		self moveto(self.origin+(xval*-1,0,zval*-1), time);
		wait time;
	}
}

fire_hurts_trigs()
{
	self endon ("death");
	while(1)
	{
		if (level.player istouching(self))
		{
			level.player setburn(0.5);
			level.player dodamage(10, self.origin);
		}
		wait 1;
	}
}

is_player_scoped()
{
	flag_set("did_noscope");
	flag_wait("friendlies_vignette_go");
	flag_clear("did_noscope");
	level endon ("said_noscope");
	while(1)
	{
		if (level.player AdsButtonPressed() )
		{
			flag_set("player_is_ads");
			wait 1;
		}
		else
		{
			flag_clear("player_is_ads");
		}
		wait 0.3;
	}
}

random_offset(xoffset, yoffset, zoffset)
{
	x = randomint(xoffset);
	y = randomint(yoffset);
	z = randomint(zoffset);
	
	if (cointoss())
	{
		x = x*1;
	}
	if (cointoss())
	{
		y = y*1;
	}
	if (cointoss())
	{
		z = z*1;
	}
	
	return (x,y,z);
}
	
kill_on_hit(ender, shotspot, attacker)
{
	level endon (ender);
	self waittill ("damage");
	if (isdefined(attacker))
	{
		self dodamage(self.health * 10, (shotspot), attacker, attacker );
	}
	else
	{
		self dodamage(self.health * 10, (shotspot) );
	}
}

playsound_generic_facial( sound, lookTarget )
{
	self endon( "death" );
  self endon( "disconnect" );  // in hindsight, not really sure if we will ever need this

  notifyString = "sound_done";
  self thread maps\_anim::anim_facialFiller( notifyString, lookTarget );
  self animscripts\face::SaySpecificDialogue( undefined, sound, 1.0, notifyString );
   self waittill( notifyString );
}

play_random_dialogue(line1, line2, line3, line4, line5, line6)
{
	lines = [];
	if (isdefined(line1) )
	{
		lines = array_add(lines, line1);
	}
	if (isdefined(line2) )
	{
		lines = array_add(lines, line2);
	}
	if (isdefined(line3) )
	{
		lines = array_add(lines, line3);
	}
	if (isdefined(line4) )
	{
		lines = array_add(lines, line4);
	}
	if (isdefined(line5) )
	{
		lines = array_add(lines, line5);
	}
	if (isdefined(line6) )
	{
		lines = array_add(lines, line6);
	}
	while(1)
	{
		myline = lines[randomint(lines.size)];
		if (!isdefined (level.lastrandomline) || level.lastrandomline != myline)
		{
			level.lastrandomline = myline;
			break;
		}
	}
	level thread say_dialogue(myline);
}

friendly_fire_check()
{
	level.friendlyfirecount = 0;
	while(1)
	{
		level.hero waittill ("damage", damage, attacker );
		level thread friendly_fire_reset();
		if (attacker == level.player)
		{
			level.friendlyfirecount++;
		}
		if (level.friendlyfirecount > 1)
		{
			SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN" );
			missionfailed();
		}
	}
}

friendly_fire_reset()
{
	level notify ("new_ff_reset_counter");
	level endon ("new_ff_reset_counter");
	wait 30;
	level.friendlyfirecount = 0;
}

reznov_killed_streetguys()
{
	self waittill ("damage", damage, attacker );
	if ( attacker == level.hero)
	{
		flag_set("reznov_shot_street_guys");
	}
}
		