/*
Pel1 - Jesse S.

Notes:

- fix up friendly movement after flame event
- fix up friendly mvoement into trenches
- fix up friendly movement through tree part and after it
- fix up friendly movement in last battle
- put timer on AI in last event: they should die after a certain amount of time if flanked
- get guys working in tunnels again
- nodes in underground right area need adjustment so they all connect

- no sight for mgs 
- pull wall out
- explodey barrel in trench
- delay was too long on banzi guys grass

// progression after LVT

- squad gets out, takes up cover around lvts area
- rockets come in 5 seconds later
- squad moves up if players move up
- mortars come down 5 seconds after rockets
- squad moves up beach, over berm, dazed guys spawn in around pits
- guy in bunker spawns in, fires mg
	- flame guy on right takes him out quickly, rejoins drone squad, firing intermittently
	- they move up when you move up
- battle happens regularly from that point on


- static_peleliu_lvtcrew

*		Roe
Sul		Pol
*  		Player
*  		*
//	***
//	2*6
//	3*7
//	4*8
//	5*9

sul-3
pol-7
roe-6
player-8


*/

#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_music;
#include maps\_busing;


#using_animtree ("generic_human");
main()
{
	setsaveddvar("compassMaxRange", 800);
	
	
	watersimenable (true);							// turn on at the beginning every time
			
	thread maps\_dpad_asset::rocket_barrage_init();
		
	level.enable_weapons = 0;
	level.displaceredshirts = true;
	level.guys_at_berm = 0;
	
	thread onPlayerConnect();
	thread catch_first_player();
	// createfx needs this high up in the chain
	maps\pel1_fx::main();
			
	// LCI rocket model
	precachemodel("peleliu_aerial_rocket");
	precachemodel("tag_origin");
	precacheitem("type100_smg_nosound");
	precachemodel("viewmodel_usa_player");
	precachemodel("static_peleliu_lvtcrew");
	//precachemodel("weapon_usa_thompson_smg_wet");
	//precachemodel("weapon_usa_m1garand_rifle_wet");
	
	
	precachemodel("char_usa_raider_helm2");
	// see if this works for people
	precacheShader("white"); 
  	precacheShader("black"); 
    precacheshader("hud_icon_air_raid");
	// tree models
	precachemodel("foliage_pacific_snapped_palms01");
	precachemodel("foliage_pacific_snapped_palms04");
	precachemodel("foliage_pacific_snapped_palms04a");
	precachemodel("foliage_pacific_snapped_palms04b");
	precachemodel("foliage_pacific_snapped_palms04c");
	precachemodel( "foliage_pacific_trees_palm_anim2" );
	
	// for diff. vehicle types
	precachemodel( "vehicle_jap_type97_seta_chassis" );
	precachemodel( "vehicle_jap_type97_seta_turret" );
	precachemodel( "vehicle_jap_type97_setb_chassis" );
	precachemodel( "vehicle_jap_type97_setb_turret" );
	precachemodel( "vehicle_jap_type97_setc_chassis" );
	precachemodel( "vehicle_jap_type97_setc_turret" );	
	
	precacherumble("tank_rumble");
	
	// broken radio
	precachemodel( "radio_jap_bro" );
	
	
	precachemodel("weapon_jap_katana_long");
	PrecacheShellshock( "lvt_exp" ); 
		
	flag_init("heroes_setup");
	flag_clear("heroes_setup");
			
	// vehicle loading functions
	maps\_buffalo::main( "vehicle_usa_tracked_lvt4", "buffalo" );
	maps\_buffalo::main( "vehicle_usa_tracked_lvta2", "buffalo_players" );
		
	maps\_amtank::main( "vehicle_usa_tracked_lvta4_amtank", "amtank" );
	//maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3" );
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair_dist", "corsair", 0, 1 );
	maps\_aircraft::main( "vehicle_usa_aircraft_pel1_f4ucorsair", "corsair" );
	
	maps\_type97::main( "vehicle_jap_tracked_type97shinhoto", "type97", undefined, 2 );
	maps\_truck::main( "vehicle_jap_wheeled_type94", "model94" );	
			
	maps\_model3::main( "artillery_jap_model3_dist", "model3_pel1" );
		
	// drone loading
	character\char_usa_marine_r_rifle::precache();
	character\char_jap_makpel_rifle::precache();
	
	// These are called everytime a drone is spawned in to set up the character.
	level.drone_spawnFunction["axis"] = character\char_jap_makpel_rifle::main;
	level.drone_spawnFunction["allies"] = character\char_usa_marine_r_rifle::main; 

	// Call this before maps\_load::main(); to allow drone usage.
	maps\_drones::init();	
	// init bayonet fx
	maps\_bayonet::init();
				
	// Why is this asserting?
	maps\_mganim::main();
	
	// Start Function calls
	add_start( "beach", ::start_beach, &"STARTS_PEL1_BEACH" );
	add_start( "off_lvt", ::start_off_lvt, &"STARTS_PEL1_OFF_LVT" );
	add_start( "1st_fight", ::start_first_fight, &"STARTS_FIGHT1" );
	add_start( "2nd_fight_l", ::start_second_fight_left, &"STARTS_FIGHT2" );
	add_start( "3rd_fight", ::start_third_fight, &"STARTS_FIGHT3" );
	add_start( "mortars", ::start_mortars, &"STARTS_MORTARS" );
	add_start( "ending", ::start_ending, &"STARTS_ENDING" );
//	add_start( "mid_igc", ::start_mid_igc_pits );
//	add_start( "tunnel", ::start_tunnel );
			
	default_start( ::event1_setup );
	
	// _load!
	maps\_load::main();

	maps\_loadout::set_player_interactive_hands( "viewmodel_usa_player" );
	// init banzai
	maps\_banzai::init();
	
	//mortar team stuff
	maps\_mortarteam::main();
	level.mortar = loadfx("explosions/default_explosion");
	
	maps\_tree_snipers::main();
		
	// All the level support scripts.
	maps\pel1_amb::main();
	maps\pel1_anim::main();
	maps\pel1_status::main();

	// global levelvars
	level.maxfriendlies = 8;
	level.mortar = level._effect["dirt_mortar"];		
	
	// rocket barrage firing points	
	level.rocket_barrage_firing_positions[0] = "rocketbarrage_points1";
	level.rocket_barrage_firing_positions[1] = "rocketbarrage_points2";
	
	// local levelvars
	level.mortarcrews = 3;
	level.playerMortar = 1;			// to appease mortar_boom

	// flag inits	
	flag_inits();
	spawn_function_init();
	
	// threatbias group setups
	createthreatbiasgroup("players");
	createthreatbiasgroup("heroes");
	createthreatbiasgroup("japanese_turret_gunners");

	// ignoreme group setups
	setignoremegroup("players", "japanese_turret_gunners");					//turret guys ignore all players
	setignoremegroup("heroes", "japanese_turret_gunners");					//turret guys ignore all heroes
	setignoremegroup("japanese_turret_gunners", "heroes");					//heroes ignore turretguys
	
	// hero setup
	level.heroes = [];
//	level.whitney 	= getent("whitney", 	"script_noteworthy");
//	level.heroes[0] = level.whitney;
//	level.king 			= getent("king", 			"script_noteworthy");
//	level.heroes[1] =	level.king;
	level.polo 	= getent("anderson", 	"script_noteworthy");
	level.heroes[0] = level.polo;
	level.sarge 		= getent("sarge", 	"script_noteworthy");
	level.heroes[1] = level.sarge;
	level.sullivan 		= getent("sullivan", 	"script_noteworthy");
	level.heroes[2] = level.sullivan;
			
//	level.king 			setthreatbiasgroup("heroes");
//	level.whitney 	setthreatbiasgroup("heroes");	
	level.polo 	setthreatbiasgroup("heroes");	
	level.sarge 		setthreatbiasgroup("heroes");	
	level.sullivan 		setthreatbiasgroup("heroes");
	//level.flameguy 		setthreatbiasgroup("heroes");	
	
	// this is for specific rocket targets 
	level.rocket_barrage_targets = [];
	level.rocket_barrage_targets[0] = getent("big_bunker_damage_area","targetname");
	level.rocket_barrage_targets[1] = getent("small_bunker_damage_area","targetname");
	level.rocket_barrage_targets[2] = getent("crush_ambient_mg","targetname");
	
	for(i = 0; i < level.heroes.size; i++)
	{
		//level.heroes[i] disable_ai_color();
	}
	array_thread( level.heroes, ::magic_bullet_shield );

	flag_set("heroes_setup");
	
	// Mainly for deleting color trigs
	//delete_trigs = getentarray("delete_on_trig","script_noteworthy");
	//array_thread( delete_trigs, ::delete_on_trigger );
	
	
	// temp for now, figure out how to do with callbacks on connect
	thread threat_group_setter();
	thread setup_brushmodels();
 // thread setup_fake_dest_lvts();
	thread lvt_deleter();
	thread water_watcher();
	
	mortar_inits();
	
	no_zone_mover = getent("no_zone_mover","script_noteworthy");
	no_zone_mover.origin = no_zone_mover.origin - (0,0,10000);
	
	
	// level specific level vars
	level.stop_ambients = false;
	
	level.sarge pushPlayer(true);
	
	if(NumRemoteClients())	// In coop, remove trees.
	{
		things_to_damage = getentarray("script_model","classname");
		
		things = 0;
		
		before = 0;
		after = 0;
		
		for (i = 0; i < things_to_damage.size; i++)
		{
			if (isdefined (things_to_damage[i]) && (things_to_damage[i].model == "foliage_cod5_tree_maple_02_large" || things_to_damage[i].model == "foliage_pacific_palms01" || things_to_damage[i].model == "foliage_pacific_palms02" 
																							|| things_to_damage[i].model == "foliage_pacific_forest_shrubs03" || things_to_damage[i].model == "foliage_pacific_forest_shrubs01"))
			{		
				before ++;
				
				if(things > 0)
				{
					things_to_damage[i] delete();
				}
				else
				{
					after ++;
				}				
				
				things++;
				
				if(things > 4)	// leave some dressing.
				{
					things = 0;
				}
			}
		}
		
		println("*** Thinning out trees for coop play : Before " + before + " after " + after);

	}
	
}

flag_inits()
{
	// flags
	flag_init("ambients_on");
		flag_set("ambients_on");
	flag_init( "jog_enabled" );
		flag_clear( "jog_enabled" );	
	flag_init("flameguy_spawned");
		flag_clear("flameguy_spawned");
	flag_init("sullivan_over_berm");
		flag_clear("sullivan_over_berm");
	flag_init("sarge_over_berm");
		flag_clear("sarge_over_berm");	
	flag_init("polo_over_berm");
		flag_clear("polo_over_berm");		
	flag_init("flank_path_taken");
		flag_clear("flank_path_taken");	
	flag_init("stronghold_cleared");
		flag_clear("stronghold_cleared");	
	flag_init("mortars_cleared");
		flag_clear("mortars_cleared");	
	flag_init("end_tanks_dead");	
		flag_clear("end_tanks_dead");		
	flag_init("flame_the_ambient");	
		flag_clear("flame_the_ambient");	
	flag_init("past_flame_mg");	
		flag_clear("past_flame_mg");				
	flag_init("over_berm_3_flag");
		flag_clear("over_berm_3_flag");
			
										
}

water_watcher()
{
	while (1)
	{
		watersim = false;
			
		wait 1;
		players = get_players();
		
		for (i = 0; i < players.size; i++)
		{
			if (players[i].origin[1] < -8700)
			{
				watersim = true;
			}
		}
		
		watersimenable(watersim);
	}
	
}

lvt_deleter()
{
	lvt_remover = getent("lvt_remover","targetname");
	
	while (1)
	{
		lvt_remover waittill ("trigger", who);
		
		if (who.model == "vehicle_usa_tracked_lvt4")
		{
			who delete();
		}
	}	
}

catch_first_player()
{
		level waittill( "first_player_ready", player );
		level.otherPlayersSpectate = true;
		level.otherPlayersSpectateClient = player;
		
		level waittill ("players off lvt");
		level.otherPlayersSpectate = false;
		level.otherPlayersSpectateClient = undefined;
		
		players = get_players();
		
		// clear out the bread crumb info so we get the additional players
		// to spawn in a valid spot
		maps\_callbackglobal::Player_BreadCrumb_Reset( players[0].origin );
		
		for (i = 0; i < players.size; i++)
		{
			// spawn in everyone except player 1
			if (i != 0)
			{
				//
				//players[i] thread	maps\_callbackglobal::Callback_PlayerConnect();
				//players[i] thread maps\_callbackglobal::spawnPlayer(1);
				//level.displaceredshirts = false;
			}
			
		}			
}


setup_brushmodels()
{
	// Fix up the roated models
//	left_door = getent("trap_door_left" ,"targetname");
//	right_door = getent("trap_door_right" ,"targetname");
	
//	left_start = getstruct("trap_door_left_org","targetname");
//	right_start = getstruct("trap_door_right_org","targetname");
	
	
//	left_door.origin = (left_start.origin[0], left_start.origin[1], left_door.origin[2]);
//	right_door.origin = (right_start.origin[0], right_start.origin[1], right_door.origin[2]);
	
//	left_door.angles = left_door.angles + (0, 15, 0);
//	right_door.angles = right_door.angles + (0, 15, 0);
	
	getent("barrier2","targetname") hide();	
}

// Rolling up on shore
event1_setup()
{
	battlechatter_off();
	
	start_teleport_players( "coop_begins", true );
	
	//maps\_status::show_task( "Event 1 - Beach Assault" );
	flag_wait("heroes_setup");
		
	
	
	//level waittill( "first_player_ready", player );
	getent("spawn_player_vehicle","targetname") useby (get_players()[0]);
	getent("spawn_arty","targetname") useby (get_players()[0]);
	
	// this was needed to allow time to get the vehicle set up
	wait (0.1);	
	// starts at beginning of level.		
	level thread event1_put_players_on_lvt();
	level thread event1_put_ai_on_lvt();
//	level thread maps\pel1_amb::start_intro_music();	
//	level waittill ("introscreen_complete");

	level thread set_objective(0);
	
	SetSavedDvar( "compass", "0" ); 
		
	//level thread event1_smoke_screen();
	level thread event1_floating_bodies();
	//level thread event1_objective_watcher();
	level thread event1_mortars();
	level thread event1_setup_lvts_with_drones();
	level thread event1_beach_tanks_setup();
	level thread event1_squibline();
	level thread event1_model3_fire();
	level thread event1_ambient_lci_trigger();
	level thread event1_cleanup_lvts();
	level thread event1_lst_door_open();
	level thread event1_ambient_aaa_fx();
	level thread event1_pillar_cover_guys();
	level thread event1_guys_on_coral();
	level thread event1_amtank_fire_watcher();
	level thread event1_rocket_hints();
	level thread event1_plane_bomb_dropper();
	level thread event1_small_bunker_rocket_damage_think();
	level thread event1_crawling_guys();
	level thread event1_plop_water();
	
	level thread event1_remove_spawners_for_coop();
	
	//level thread event1_aaa_targetname_transmitter();
			
	getvehiclenode("event1_planecrashnode","script_noteworthy") thread event1_ambient_plane_crash();

	getvehiclenode("auto4755","targetname") thread event1_crazy_plane_crash();
	
	// hack: remove this trigger, causing drone issues
	getent("auto5686","target") delete();
	
	//level thread event1_ship_fire_controller();
				
//	deep_water_trigs = getentarray("deep_water_trigs","targetname");
//	no_water_trigs = getentarray("no_water_trigs","targetname");
	//array_thread( deep_water_trigs, ::event1_deep_water_run_change );
	//array_thread( no_water_trigs, ::event1_no_water_run_change );
					
	level waittill ("lst doors opened");
	
	getent("start_player_vehicle","targetname") useby (get_players()[0]);
		
	level.players_lvt waittill ("unload");
	
	// after the unload
	level thread event1_stuck_on_coral();
	level thread event1_drag1_setup();
		
	level waittill ("get out of lvt");
	
	// looping drones
	//getent("auto5001","target") useby (get_players()[0]);
	
	// one wave drones
	//getent("auto5289","target") useby (get_players()[0]);
	
	// radio coral guys
	getent("radio_squad_spawner","targetname") useby (get_players()[0]);	
		
	level thread event1_get_players_off_of_lvt();
	level thread event1_get_ai_off_of_lvt();
	//level thread event1_flamedeath();
	
	// next event setup
	level thread event2_setup();
	level thread event2_main_rocket_attack();
}

event1_remove_spawners_for_coop()
{
	players = get_players();
	
	if (NumRemoteClients() > 0)
	{
		spawners = getentarray("remove_on_coop","script_noteworthy");
		
		for (i = 0; i < spawners.size; i++)
		{
			spawners[i] delete();
		}
		
	}
}

event1_plop_water()
{
	wait 8;
	WaterPlop( (1956, -19853, -430), 2, 4 ); 
	WaterPlop( (2408, -20128, -426), 2, 4 ); 
	WaterPlop( (2904, -19718, -480), 2, 4 ); 
	WaterPlop( (3516, -20682, -480), 2, 4 ); 
	WaterPlop( (1955, -21043, -430), 2, 4 ); 
	
	physicsExplosionSphere( (1956, -19853, -430), 400, 400 * 0.25, 0.75 );	
	physicsExplosionSphere( (2408, -20128, -426), 400, 400 * 0.25, 0.75 );
	PhysicsExplosionSphere( (2904, -19718, -480), 400, 400 * 0.25, 0.75 );
	PhysicsExplosionSphere( (3516, -20682, -480), 400, 400 * 0.25, 0.75 );
	PhysicsExplosionSphere( (1955, -21043, -430), 400, 400 * 0.25, 0.75 );
	PhysicsExplosionSphere( (2906, -18676, -430), 400, 400 * 0.25, 0.75 );
	PhysicsExplosionSphere( (2906, -18676, -430), 400, 400 * 0.25, 0.75 );
	PhysicsExplosionSphere( (1485, -18804, -430), 400, 400 * 0.25, 0.75 );	
	PhysicsExplosionSphere( (2280, -18360, -430), 400, 400 * 0.25, 0.75 );	
	PhysicsExplosionSphere( (800,  -18360, -430), 400, 400 * 0.25, 0.75 );
	PhysicsExplosionSphere( (-800, -18360, -430), 400, 400 * 0.25, 0.75 );		
	PhysicsExplosionSphere( (3000, -18360, -430), 400, 400 * 0.25, 0.75 );	
	PhysicsExplosionSphere( (4000, -18360, -430), 400, 400 * 0.25, 0.75 );			
}

event1_plane_bomb_dropper()
{
	level.players_lvt waittill ("start_vehiclepath");
	
	wait 0.05;
	
	planes = getentarray("intro_plane1","targetname");
	planes = array_combine(planes, getentarray("intro_plane2","targetname"));

	
	for (i = 0; i < planes.size; i++)
	{
		planes[i] thread event1_plane_bomb_dropper_think();
	}	
}

event1_plane_bomb_dropper_think()
{
	while (self.origin[1] < -16000)
	{
		wait 0.05;
	}
	wait randomfloatrange (0.05, 0.1);
	
	self thread maps\_planeweapons::drop_bombs( 2, 0.1, 1.5, 128 );
	
}

event1_amtank1_think()
{
	node = getvehiclenode("blowup_amtank1", "script_noteworthy");
	node waittill ("trigger", who);
	
	who setspeed (0, 3, 3);
	
	level waittill ("players off lvt");
	wait 3;
	thread lookat_notify("amtank_lookat");
	
	level waittill_either("saw_amtank_blowup", "used rocket once");

	radiusdamage( who.origin + ( 0, 0, 0), 200, who.health + 1000, who.health + 500 ); 

		
//	playfxontag(level._effect["lvt_explode"], who, "tag_origin");		// fx
//	who playsound("explo_metal_rand");																// sound
//	who setmodel("vehicle_usa_tracked_lvt4_dest");										// model
//	who notify ("death");
		
}


event1_amtank2_think()
{
	node = getvehiclenode("amtank2_stop", "script_noteworthy");
	node waittill ("trigger", who);
	
	who setspeed (0, 3, 3);
	
	level waittill ("rockets done");

	who resumespeed (5);
	
//	playfxontag(level._effect["lvt_explode"], who, "tag_origin");		// fx
//	who playsound("explo_metal_rand");																// sound
//	who setmodel("vehicle_usa_tracked_lvt4_dest");										// model
//	who notify ("death");
		
}


event1_amtank3_think()
{
	node = getvehiclenode("amtank3_stop", "script_noteworthy");
	node waittill ("trigger", who);
	
	who setspeed (0, 3, 3);
	
	level waittill ("rockets done");

	who resumespeed (5);
	
//	playfxontag(level._effect["lvt_explode"], who, "tag_origin");		// fx
//	who playsound("explo_metal_rand");																// sound
//	who setmodel("vehicle_usa_tracked_lvt4_dest");										// model
//	who notify ("death");
		
}


lookat_notify(trig_name)
{
	trigger_wait(trig_name,"targetname");
	
	wait 0.5;
	
	level notify ("saw_amtank_blowup");	
}

//// this is so the cscs know what to look for
//event1_aaa_targetname_transmitter()
//{
//	point1 = getent("event1_aaa_fx_point1","targetname");
//	point2 = getent("event1_aaa_fx_point2","targetname");
//	point3 = getent("event1_aaa_fx_point3","targetname");
//	point4 = getent("event1_aaa_fx_point4","targetname");
//	point5 = getent("event1_aaa_fx_point5","targetname");
//	point6 = getent("event1_aaa_fx_point6","targetname");
//
//	point1 transmittargetname();
//	point2 transmittargetname();
//	point3 transmittargetname();
//	point4 transmittargetname();
//	point5 transmittargetname();
//	point6 transmittargetname();
//}

event1_rocket_hints_thread()
{
	self endon ("player pulledout rockets");
	
	while (1)
	{
		self thread rocket_strike_user_notify();
		
		wait 20;
	}
}

event1_rocket_hints()
{	
	level endon ("used rocket once");
	level endon ("player pulledout rockets");
	
	level thread event1_rocket_hints_finish();
	level thread event1_post_rockets_moveup_ai();

	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] thread event1_kill_player_on_too_far_up();
		players[i] thread event1_warn_player_on_too_far_up();
	}
	
	trigger_wait("use_rocket_hint","targetname");
	level thread event1_check_for_weapons();
		
	level thread event1_sullivan_instruct_rockets();
	maps\_utility::autosave_by_name( "Pel1 Coral" ); 
	
	starts = getstructarray("post_lvt_player_breadcrumbs","targetname");
	set_breadcrumbs(starts);
	
	level.rocket_barrage_allowed = true;
	
	players = get_players();
	
	for(i = 0; i < players.size; i ++)
	{
		players[i]	thread event1_rocket_hints_thread();
	}
}


event1_check_for_weapons()
{
	level endon ("player pulledout rockets");
	
	wait 1;
	
	while(1)
	{
		players = get_players();
		
		for (i = 0; i < players.size; i++)
		{
			if (players[i] getcurrentweapon() == "rocket_barrage")
			{
				if(isdefined(players[i].hintElem))
				{
					players[i].hintElem thread fade_then_kill_hud();
				}
				
				if(isdefined(players[i].hintElem2))
				{
					players[i].hintElem2 thread fade_then_kill_hud();
				}
				
				for(j =0; j < players.size; j++)
				{
					players[j] notify ("player pulledout rockets");	
				}
			}
		}
		wait 0.1;
	}
}

fade_then_kill_hud()
{
	if (isdefined(self))
	{
		self fadeovertime(0.2);
		self.alpha = 0;
	}
	
	wait 3;
	
	if (isdefined(self))
	{
		self destroy();
	}
}

event1_sullivan_instruct_rockets()
{
	level endon ("used rocket once");
	
	//level thread event1_sullivan_goodjob();
	wait 6;
	
	level.sullivan.animname = "sullivan";
	string = "barrge_use_intro";
	num = 1;
	
	num_strings = 6;
	
	did_once = false;
	while (1)
	{
		level.sullivan anim_single_solo(level.sullivan, string+num);
		num++;
		
		if (num == 3 && !did_once)
		{
			did_once = true;
		}
		// dont wait on the second one
		if (num != 2)
		{
			wait randomfloatrange (4.25, 5.5);
		}
		
		// too many! reset
		if (num > num_strings)
		{
			num = 1;
		}
	}
}

event1_sullivan_goodjob()
{
		//level waittill ("used rocket once");
		//wait 4;
		//level.sullivan anim_single_solo(level.sullivan, "good_job");
}

event1_post_rockets_moveup_ai()
{
		level waittill ("do aftermath");
			
		wait 5;
		
	//	battlechatter_off();
		
		level.sarge 	playsound(level.scr_sound["sarge"]["moveup_beach1"], "sounddone");
		level.sarge waittill ("sounddone");
		
		thread event1_post_aftermath_mortars();

		thread event1_post_rocket_dialogue();
		// he doesnt get threaded until later since he has to do anims eariler
		
		//level.sullivan thread event1_water_depth_think();
		
		trig = getent("event1_offlvt_moveup", "targetname");
		
		level notify ("rockets done");
		
		ai = grab_friendlies();	
		thread wait_to_do_water_depth(ai);

		array_thread( ai, ::event1_water_depth_out_think );

	
		if (isdefined(trig))
		{
			thread enable_ai_color_allies();
			
			trig notify ("trigger");
		}
}

wait_to_do_water_depth( ai )
{
	// so they do it roughly past the coral
	wait 3;
	
	valid_ai = [];
	for (i = 0; i < ai.size; i++)
	{
		if (isdefined(ai[i]) && isalive(ai[i]))
		{
			valid_ai = array_add(valid_ai, ai[i]);
		}
	}
	
	array_thread( valid_ai, ::event1_water_depth_think );
}

event1_water_depth_out_think()
{
	self endon ("death");
	
	while (self.origin[1] < -10917 && isalive(self) && isdefined(self))
	{
		wait 0.5;
	}
	
	if (isalive(self) && isdefined(self))
	{
		self notify ("out of water");
		
		// so we dont do water walks on land somehow
		self.isinwater = 0;		
		
		if (isdefined(self.a.old_combatrunanim))
		{
			self.a.combatrunanim = self.a.old_combatrunanim;
		}

		if (isdefined(self.a.old_combatrunanim))
		{
			self.run_combatanim = self.old_run_combatanim;
		}
		
		self.disableArrivals = false;	
		self.run_noncombatanim = undefined;
		self.walk_combatanim = undefined;
		self.walk_noncombatanim = undefined;
			
		self thread wetness_on_ai(0, 1, 30);
	}	
}

event1_post_rocket_dialogue()
{
	level endon ("stop color dialog");
			
	//battlechatter_off();
	
	wait 2;
			
	level.sarge 		playsound(level.scr_sound["sarge"]["moveup_beach2"], "sounddone");
	level.sarge waittill ("sounddone");
	
	level.polo 	playsound(level.scr_sound["polo"]["moveup_beach3"], "sounddone");
	level.polo waittill ("sounddone");

	//level.sarge 		playsound(level.scr_sound["sarge"]["moveup_beach3a"], "sounddone");
	//level.sarge waittill ("sounddone");
	wait 2.5;

	level.sullivan 	playsound(level.scr_sound["sullivan"]["moveup_beach4"], "sounddone");
	level.sullivan waittill ("sounddone");
	
	level.sullivan 	playsound(level.scr_sound["sullivan"]["moveup_beach5"], "sounddone");
	level.sullivan waittill ("sounddone");

	guys = grab_starting_guys();
	guy1 = undefined;
	guy2 = undefined;
	for (i = 0; i < guys.size; i++)
	{
		if (guys[i] != level.sarge && guys[i] != level.polo && guys[i] != level.sullivan && guys[i] != level.radioguy)
		{
			guy1 = guys[i];
		}
	}	

	for (i = 0; i < guys.size; i++)
	{
		if (guys[i] != guy1 && guys[i] != level.sarge && guys[i] != level.polo && guys[i] != level.sullivan && guys[i] != level.radioguy)
		{
			guys[i] = guy2;
		}
	}	

	level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt1"], "sounddone");
	level.sullivan waittill ("sounddone");
	
	level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt2"], "sounddone");
	level.sullivan waittill ("sounddone");

	level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt2a"], "sounddone");
	level.sullivan waittill ("sounddone");
		
	//level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt3"], "sounddone");
	//level.sullivan waittill ("sounddone");			

	//level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt4"], "sounddone");
	//level.sullivan waittill ("sounddone");			

	//level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt5"], "sounddone");
	//level.sullivan waittill ("sounddone");			

	level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt6"], "sounddone");
	level.sullivan waittill ("sounddone");	
	
	level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt7"], "sounddone");
	level.sullivan waittill ("sounddone");	
	
	level.sullivan 	playsound(level.scr_sound["redshirt"]["moveup_beach_redshirt8"], "sounddone");
	level.sullivan waittill ("sounddone");	
	
	//battlechatter_on();
}

event1_rocket_hints_finish()
{
	level waittill ("rockets available anytime");	
	iprintlnbold (&"PEL1_ROCKETS_ALWAYS_AVAIL");
}

event1_kill_player_on_too_far_up()
{	
	self thread event1_kill_player_on_too_far_up_during_strike();
	self thread event1_kill_player_on_too_far_up_during_strike_ender();
	level endon ("do aftermath");
	self endon ("death");
	self endon ("disconnect");
	
	while (1)
	{
		
		if (self.origin[1] > -12800)	// a lot past the coral area
		{
			wait randomfloatrange(0.1, 0.4);
			
			self dodamage(30, (2158, -10313, -380));
			
			if (self.health <= 10)
			{
				self enableHealthShield( false );
				self dodamage(self.health + 10, (2158, -10313, -380));
				playfx(level._effect["water_mortar"], self.origin);
				self playsound ("mortar_impact_water");
				self enableHealthShield( true );
			}
		}
		wait 0.1;
	}
}

event1_kill_player_on_too_far_up_during_strike_ender()
{
	self endon ("death");
	self endon ("disconnect");
	
	level waittill ("do aftermath");
	wait 10;
	level notify ("stop death wall");
	
	self allowstand(true);	
}

event1_kill_player_on_too_far_up_during_strike()
{
	self endon ("death");
	self endon ("disconnect");
	
	level endon ("stop death wall");
		
	level waittill ("do aftermath");
		
	while (1)
	{
		if (self.origin[1] > -11502)	// waaaaay past the coral area
		{
			self shellshock ("default", 5);
			self allowstand(false);
		}
		wait 0.1;
	}
}

event1_warn_player_on_too_far_up()
{
	level endon ("used rocket once");
	self endon ("death");
	self endon ("disconnect");
	
	
	level.polo.animname = "polo";
	string = "warn_get_back_here";
	num = 1;
	
	num_strings = 3;
	
	while (1)
	{		
		if (self.origin[1] > -13100)	// a little past the coral area
		{
			level.polo anim_single_solo(level.polo, string+num);
			num++;
			
			wait randomfloatrange(2.0, 3.25);
			
			// too many! reset
			if (num > num_strings)
			{
				num = 1;
			}
		}
		wait 0.1;
	}
}
	
event1_amtank_fire_watcher()
{
	level waittill ("players off lvt");
	
	vehicles = getentarray ("script_vehicle","classname");
	amtanks = [];
	
	for (i = 0; i < vehicles.size; i++)
	{
		if (vehicles[i].model == "vehicle_usa_tracked_lvta4_amtank")
		{
			amtanks = array_add(amtanks, vehicles[i]);
		}
	}
	
	for (i = 0; i < amtanks.size; i++)
	{
		amtanks[i] thread maps\_amtank::fire_loop_toggle(1);
	}
	
	level waittill ("do aftermath");
		
	for (i = 0; i < amtanks.size; i++)
	{
		amtanks[i] thread maps\_amtank::fire_loop_toggle(0);
	}
	
}

event1_guys_on_coral()
{
	getent("radio_squad_spawner","targetname") waittill ("trigger");
	
	wait 0.1;
	
	ai = get_ai_group_ai("coral_radio_guys");
			
	for (i = 0; i < ai.size; i++)
	{
		if (isdefined (ai[i].script_forcecolor) && ai[i].script_forcecolor == "y")
		{
			level.radioguy = ai[i];
			level.radioguy.animname = "radioguy";
			level.radioguy thread magic_bullet_shield();
			level.radioguy set_battlechatter( false );			
		}
	}
	
	ai = array_remove(ai, level.radioguy);
		
	for (i = 0; i < ai.size; i++)
	{
			ai[i].animname = "coralguy" + (i+1);
	}
	
	playpoint = getstruct("event1_guys_on_coral", "targetname");
	
	ai = array_add(ai, level.radioguy);	
	level thread anim_loop(ai, "coral_loop", undefined, "stop_coral_loop", playpoint);
	
	getent("event1_jeep_blowup_trig","targetname") waittill ("trigger");
	
	level notify ("stop_coral_loop");
	
	for (i = 0; i < ai.size; i++)
	{
			ai[i] stopanimscripted();
	}
	
	for (i = 0; i < ai.size; i++)
	{
			ai[i] thread event1_water_depth_think();
			
			if (ai[i] != level.radioguy)
			{
				ai[i].goalradius = 64;
				ai[i] setgoalpos(getnode(ai[i].target,"targetname").origin);
				ai[i] thread event1_coral_timed_death();
			}
	}
	// have radio guy run up, everyone else gets goalnodes on beach but dies after random time
	
}

event1_coral_timed_death()
{
	self endon ("death");
	
	wait randomfloatrange (3, 12);
	
	self dodamage (self.health + 10, (0,0,52));
}

event1_ambient_plane_crash()
{
	self waittill ("trigger", who);
	
	playfxontag(level._effect["plane_crashing"], who ,"tag_prop");
	
	finalnode = getvehiclenode("auto5013","targetname");
	finalnode waittill ("trigger");
	playfx(level._effect["bunker_explode_large"], finalnode.origin);
}

event1_crazy_plane_crash()
{
	self waittill ("trigger", who);
	
	who thread event1_crazy_plane_prop_fx();

	getvehiclenode("auto6154","targetname") waittill ("trigger");
	
	who playsound ("intro_plane_crash");
	
	finalnode = getvehiclenode("auto4756","targetname");
	finalnode waittill ("trigger");
	
	playfx(level._effect["water_mortar"], who.origin);

	playsoundatposition("plane_impact_water", who.origin);	
	who notify ("death");
	

}	

event1_crazy_plane_prop_fx()
{
	while (isalive(self))
	{
		playfxontag(level._effect["plane_crashing"], self ,"tag_prop");
		wait 5;
	}	
}

event1_ambient_aaa_fx()
{
	getent("start_models3s","targetname") waittill ("trigger");
	
	level clientNotify ("ab");	// aaa_begin
	level notify ("aaa_begin");
}


event1_cleanup_lvts()
{	
	level waittill ("remove floaters");

	real_lvts = getentarray("script_vehicle","classname");
	
	for (i = 0; i < real_lvts.size; i++)
	{
		if (real_lvts[i].model == "vehicle_usa_tracked_lvt4")
		{
			real_lvts[i] notify ("death");		
		}
	}

	beachdrones = getentarray("beach_drones_cover","script_noteworthy");
	
	for (i = 0; i < beachdrones.size; i++)
	{
		beachdrones[i] notify ("death");		
		beachdrones[i] thread maps\_drones::drone_delete();
	}
}

event1_pillar_cover_guys()
{
	thread event1_pillar_guys_sound();
	pillar1 = getstruct("beachpillar1","targetname");
	guys1 = [];
	guys1[0] = spawn_fake_guy_lvt( pillar1.origin, pillar1.angles, 1, "pillar_guy1", "pillar_guy1", 0, 1);
	guys1[1] = spawn_fake_guy_lvt( pillar1.origin, pillar1.angles, 1, "pillar_guy2", "pillar_guy2", 0, 1);
	guys1[2] = spawn_fake_guy_lvt( pillar1.origin, pillar1.angles, 1, "pillar_guy3", "pillar_guy3", 0, 1);
	
	pillar2 = getstruct("beachpillar2","targetname");
	guys2 = [];
	guys2[0] = spawn_fake_guy_lvt( pillar2.origin, pillar2.angles, 1, "pillar_guy4", "pillar_guy4", 0, 1);
	guys2[1] = spawn_fake_guy_lvt( pillar2.origin, pillar2.angles, 1, "pillar_guy5", "pillar_guy5", 0, 1);
	guys2[2] = spawn_fake_guy_lvt( pillar2.origin, pillar2.angles, 1, "pillar_guy6", "pillar_guy6", 0, 1);
	
	// make sure they all have collision and names, etc.
	allguys = array_combine(guys1,guys2);
	for (i = 0; i < allguys.size; i++)
	{
		allguys[i] event1_give_guys_names();
	}
	
	level thread event2_waittill_obstacle_explode(guys2, pillar2);
	
	pillar1 thread anim_loop(guys1, "coverloop", undefined, "stop_pillar_cover", pillar1);
	pillar2 thread anim_loop(guys2, "coverloop", undefined, "stop_pillar_cover", pillar2);
	
	level waittill ("remove floaters");
		
	for (i = 0; i < guys1.size; i++)
	{
		pillar1 notify ("stop_pillar_cover");		
		guys1[i] delete();
	}
	
	for (i = 0; i < guys2.size; i++)
	{
		pillar2 notify ("stop_pillar_cover");		
		guys2[i] delete();
	}
}

event2_waittill_obstacle_explode(guys2, pillar2)
{
	level endon ("remove floaters");

	barrier = getent("barrier2","targetname");
	trig = getent("obstacle_explode","targetname");
	
	player_saw_this = false;	
	while (!player_saw_this)
	{
		trig waittill ("trigger", who);
		if (distance(who.origin, barrier.origin) < 1000)
		{
			player_saw_this = true;
		}
		wait 0.05;
	}
	wait 1.5;
	
	getent("barrier1","targetname") delete();

	barrier show();
	playfx(level._effect["dirt_mortar"], barrier.origin);
	barrier playsound ("mortar_dirt");
	
	pillar2 notify ("stop_pillar_cover");	
	for (i = 0; i < guys2.size; i++)
	{
	
		guys2[i] startragdoll();
	}
}

event1_give_guys_names()
{
	self makeFakeAI();
	self.team = "allies";
	self.health = 1000000;
	self maps\_drones::drone_setName();
}

event1_pillar_guys_sound()
{
	trig = getent("ev1_pillar_guys_sound_trig","targetname");
	trig waittill ("trigger");
	
	soundpoint = getstruct("beachpillar2","targetname");
	
	playsoundatposition("Pel01_G1A_TRM1_004A", soundpoint.origin);
	wait 2;
	playsoundatposition("Pel01_G1A_TRM2_005A", soundpoint.origin);		
}

event1_ambient_lci_trigger()
{
	trig = getent("ambient_lci_trigger","targetname");
	trig waittill ("trigger");
	
	// rockets from each ship
	num_rockets = 36;
	num_rockets_per_ship = 12;
	
	// grab start points
	start_points = [];
	
	orgs = getstructarray("rocketbarrage_points2","targetname");
	
	// popultate the ship
	q = 0;
	for(i = 0; i < num_rockets; i++)
	{
		q = i % num_rockets_per_ship;	
		start_points[i] = orgs[q].origin;
	}
	
	level thread event1_lci_rocket_fire((8000, -10000, -535.5), start_points);	
	level notify("ship_fire_right");
	level clientnotify ("sfr");	// ship_fire_right
	
	wait 10;
		
	start_points = [];
	
	orgs = getstructarray("rocketbarrage_points2","targetname");
	
	// popultate the ship
	q = 0;
	for(i = 0; i < num_rockets; i++)
	{
		q = i % num_rockets_per_ship;	
		start_points[i] = orgs[q].origin;
	}
	
	level thread event1_lci_rocket_fire((8000, -10000, -535.5), start_points);	
	level notify("ship_fire_right");
	level clientnotify ("sfr");	// ship_fire_right
	
	wait 25;		
		
	// grab start points
	start_points = [];
	
	orgs = getstructarray("rocketbarrage_points1","targetname");
	
	// popultate the ship
	q = 0;
	for(i = 0; i < num_rockets; i++)
	{
		q = i % num_rockets_per_ship;		
		start_points[i] = orgs[q].origin;
	}
	
	level thread event1_lci_rocket_fire((-2000, -10000, -535.5), start_points);
	level notify("ship_fire_left");
	level clientnotify ("sfl");	// ship_fire_left
	
}

event1_water_depth_think()
{
	self endon ("death");
	self endon ("out of water");
	
	if (!isdefined(self))
	{
		return;
	}
	
	if (!isalive(self))
	{
		return;
	}
	
	self.old_run_combatanim = self.run_combatanim;
	self.a.old_combatrunanim = self.a.combatrunanim;
	
	self.isinwater = false;
				
	while (isdefined(self) && isalive(self))
	{
		depth = self depthinwater();
		
		run_cycles = 3;
		num = randomint(run_cycles);
		
		anim_string = undefined;
		the_anim 		= undefined;
		
		if (isdefined(depth) && depth >= 22)
		{
 			if (self.isinwater == 1)
 			{
 				wait 0.5;
 				continue;
 			}
 			
			if (num == 0 )
			{
				the_anim = %ai_run_deep_water_a;
				anim_string = "run_deep_a";
			}
			else if (num == 1)
			{
				the_anim = %ai_run_deep_water_b;
				anim_string = "run_deep_b";
			}	
			else if (num == 2)
			{
				the_anim = %ai_run_shallow_water_d;
				anim_string = "run_shallow_d";
			}			
			self.isinwater = 1;
						
		}
//		else if (depth < 18 && depth >= 12)
//		{
//			if (self.isinwater == 2)
// 			{
// 				wait 0.5;
// 				continue;
// 			}
// 			
//			if (num == 0 )
//			{
//				the_anim = %ai_run_shallow_water_a;
//				anim_string = "run_shallow_a";
//			}
//			else if (num == 1)
//			{
//				the_anim = %ai_run_shallow_water_b;
//				anim_string = "run_shallow_b";
//			}
//			else if ( num == 2)
//			{
//				the_anim = %ai_run_shallow_water_c;
//				anim_string = "run_shallow_c";
//			}
//
//			self.isinwater = 2;
//		}
		else
		{
			self.isinwater = 0;
						
			self.a.combatrunanim = self.a.old_combatrunanim;
			self.run_combatanim = self.old_run_combatanim;
			self.disableArrivals = false;
			
			self.run_noncombatanim = undefined;
			self.walk_combatanim = undefined;
			self.walk_noncombatanim = undefined;
		}

		// do this if we're in water	
		if (isdefined(self) && isdefined(self.isinwater) && self.isinwater)
		{
			self.animname = "in_water";
			self set_run_anim( anim_string );		
			self.run_combatanim = the_anim;
			self.disableArrivals = true;	
		}	
		wait 0.5;		
	}

}

//event1_deep_water_run_change()
//{
//	while (1)
//	{
//		self waittill ("trigger", who);
//
//		if (isdefined (who.inwater) || !isai(who))
//		{
//			continue;
//		}
//		else
//		{
//			who.inwater = true;
//		}
//		
//		run_cycles = 2;
//		num = randomint(run_cycles);
//		
//		anim_string = undefined;
//		the_anim 		= undefined;
//		
//		if (num == 0)
//		{
//			the_anim = %ai_run_shallow_water_a;
//			anim_string = "run_shallow_a";
//		}
//		else if (num == 1)
//		{
//			the_anim = %ai_run_shallow_water_b;
//			anim_string = "run_shallow_b";
//		}
//		
//		if (isalive(who) && isai(who))
//		{
//				who.animname = "in_water";
//				
//				who.old_run_combatanim = who.run_combatanim;
//				who.a.old_combatrunanim = who.a.combatrunanim;
//				who set_run_anim( anim_string );		
//				who.run_combatanim = the_anim;
//				who.disableArrivals = true;			
//		}	
//		wait 0.1;		
//	}
//}


//event1_no_water_run_change()
//{
//	while (1)
//	{
//		self waittill ("trigger", who);
//
//		if (who.inwater == true)
//		{
//			who.inwater = false;
//		}
//		else
//		{
//			continue;
//		}
//		who.a.combatrunanim = who.a.old_combatrunanim;
//		who.run_combatanim = who.old_run_combatanim;
//		who.disableArrivals = false;	
//						
//		wait 0.1;		
//	}
//}

mortar_inits()
{
//	set_mortar_delays( mortar_name, min_delay, max_delay, barrage_min_delay, barrage_max_delay, set_default )
	
//	maps\_mortar::set_mortar_delays( "dirt_mortar", 1, 3, 1, 3 );
//  maps\_mortar::set_mortar_chance( "dirt_mortar", 0.75 );
// 	maps\_mortar::set_mortar_damage( "dirt_mortar", 0, 0, 0 );
// 	maps\_mortar::set_mortar_quake( "dirt_mortar", 0.30, 2.5, 1000 );
// 	
//  level thread maps\_mortar::mortar_loop( "dirt_mortar" );

	maps\_mortar::set_mortar_delays( "beach_mortar_water", 3.5, 5, 3.5, 5 );
  maps\_mortar::set_mortar_chance( "beach_mortar_water", 0.5 );
  maps\_mortar::set_mortar_range( "beach_mortar_water", 300, 2500 );
 	maps\_mortar::set_mortar_damage( "beach_mortar_water", 0, 0, 0 );
 	maps\_mortar::set_mortar_quake( "beach_mortar_water", 0.30, 2.5, 1000 );


  
	//level thread maps\_mortar::generic_style( "dirt_mortar", 0.1, 1, 0.1, 400, 2000, undefined);
	//level thread maps\_mortar::generic_style( "water_mortar", 1, 1, 1, 400, 3000, undefined);
}

event1_mortars()
{
	level waittill ("aaa_begin");
	
	level thread maps\_mortar::mortar_loop( "beach_mortar_water" );
	
	level waittill ("do aftermath");
	level notify( "stop_all_mortar_loops" );	
}

event1_post_aftermath_mortars()
{	
	level thread maps\_mortar::mortar_loop( "beach_mortar_water" );
	
	level waittill ("stop_water_mortars");
	level notify( "stop_all_mortar_loops" );	
}

event1_squibline()
{
	starts = getstructarray("squibline","targetname");	
	starts2 = getstructarray("squiblinev2","targetname");	
		
	//array_thread( starts, ::event1_squibline_think );
	array_thread( starts2, ::event1_squibline_think_v2 );
		
}



event1_squibline_think()
{
	level endon ("do aftermath");
	while (1)
	{
		start = self;
		wait (randomintrange(5, 10));
		while (isdefined(start.target))
		{
			playfx(	level._effect["one_squib"], start.origin - (20+ randomint(40), 20 + randomint(40), 0));
			thread play_sound_in_space("bulletspray_large_sand", start.origin );
			wait (0.05);
			
			if (isdefined(start.target))
			{
				start = getstruct(start.target, "targetname");
			}
		}
	}

}

event1_squibline_think_v2()
{
	level endon ("do aftermath");
	
	start = self;
	end = getstruct(self.target, "targetname");
		
	while (1)
	{

		wait (randomintrange(8, 15));
		
		org = spawn("script_origin", start.origin);
		org moveto (end.origin, 0.7);
		org thread event1_squibline_think_impacts();
		org waittill ("movedone");
		org delete();

	}
}

event1_squibline_think_burst()
{
	start = self;
	end = getstruct(self.target, "targetname");
			
	org = spawn("script_origin", start.origin);
	org moveto (end.origin, 0.7);
	org thread event1_squibline_think_impacts();
	org waittill ("movedone");
	org delete();
}

event1_squibline_think_impacts()
{
		self endon ("movedone");
			
		while (1)
		{
			magicbullet("type100_smg_nosound", self.origin, self.origin + (100,50,0) -  (randomint(200),randomint(100),200));
			wait (0.05);
		}
}

event1_squibline_think_impacts_for_anim(rand)
{
		self endon ("movedone");
			
		while (1)
		{
			if (!isdefined(rand))
			{
				rand = 150;
			}
			else
			{
				rand = randomintrange(140, 200);
			}
			magicbullet("type100_smg_nosound", self.origin, self.origin - (0,500, rand));
			wait (0.1);
		}
}

event1_drag1_setup()
{
	//spawn_fake_guy_lvt(startpoint, startangles, us, animname, name, is_lvt_drone, assign_weapon)
	level waittill ("get out of lvt");
	
	dragger_spawner = getent("dragger_guy1","targetname");
	dragger = dragger_spawner spawn_ai();
	
	dragger thread magic_bullet_shield();
	
	if ( spawn_failed( dragger ) )
	{
		assertex( 0, "spawn failed from dragger guy" );
		return;			
	}
	dragger thread event1_water_depth_think();
		
	wounded = spawn_fake_guy_lvt((0,0,0), (0,0,0), 1, "wounded", "wounded_drone", 0, 0);
	
	dragger.animname = "dragger";
	
	dragset = [];
	dragset[0] = dragger;
	dragset[1] = wounded;
	
	startpoint = getstruct("drag_start_point","targetname");
	
	//wounded thread anim_loop_solo(wounded, "wounded_loop", undefined, "stop_wounded_loop", startpoint);

	//dragger anim_reach_solo(dragger, "pickup", undefined, startpoint);
	
	dragger.animname = "dragger";	
	
	dragger thread fail_on_ff();
	wounded thread fail_on_ff();
	
	
	//wounded notify ("stop_wounded_loop");
	//anim_single(dragset, "pickup", undefined, startpoint);
	thread anim_loop(dragset, "drag_loop", undefined, "stop_drag_loop", startpoint);
	
	level waittill ("remove floaters");
	level notify ("stop_drag_loop");
	
	dragger thread stop_magic_bullet_shield();
	
	dragger delete();
	wounded delete();
}

fail_on_ff()
{
	self endon ("death");
	
	self setcandamage (1);
	
	name = undefined;
	if (!isai(self))
	{
		self makefakeai();
		self.health = 100000;
		self.team = "allies";
		self.voice = "american";
		self maps\_names::get_name_for_nationality( "american" ); 
		self setlookattext( self.name, &"WEAPON_RIFLEMAN" );
	}
	
	players = get_players();
	
	if (players.size > 1)
	{
		return;
	}
	
	while (isdefined(self))
	{
		self waittill ("damage", amount, who);
		
		if (isplayer(who))
		{
			thread maps\_friendlyfire::missionfail();
		}	
	}	
	
}

//event1_objective_watcher()
//{
//	getent("ev1_near_berm","targetname") waittill ("trigger");
//	//level thread set_objective(1);
//}

// puts the players on the lvt on the way in
event1_put_players_on_lvt()
{
	// player's lvt group, notify is set by _vehicle
	//level waittill( "spawnvehiclegroup0");
	
	// get players
	players = get_players();
	
	// get player vehicle
	level.players_lvt = getent("player_lvt", "targetname");
	level.players_lvt playsound("lvt_start");
	
	// link the sound points for Gary
	level.players_lvt.front_sounds = getent("player_lvt_front_soundpoint","targetname");
	level.players_lvt.rear_sounds = getent("player_lvt_rear_soundpoint","targetname");
	level.players_lvt.front_sounds linkto (level.players_lvt);
	level.players_lvt.rear_sounds linkto (level.players_lvt);
	
	
	// loop through players, determine the proper tag for each player
	for (i = 0; i < players.size; i++)
	{
		org = undefined;
		ang = undefined;
		tag = undefined;
		
		players[i] thread attach_weapon_during_lvt_ride();

			
		if (i == 0)
		{
			tag = "tag_passenger8";
			players[i] playeranimscriptevent( "lvt_ride_player3" ); 
		}
		else if (i == 1)
		{
			tag = "tag_passenger4";
			players[i] playeranimscriptevent( "lvt_ride_player2" ); 
		}
		else if (i == 2)
		{
			tag = "tag_passenger5";
			players[i] playeranimscriptevent( "lvt_ride_player3" ); 
		}
		else 
		{
			tag = "tag_passenger9";
			players[i] playeranimscriptevent( "lvt_ride_player4" ); 
		}
		
		players[i] PlayRumbleLoopOnEntity( "tank_rumble" );
	
		// get the origin and angle for each tag
		org = level.players_lvt gettagOrigin (tag);
		ang = level.players_lvt gettagangles (tag);
		
		// set the players to the tag origins and angles
		players[i] setorigin (org);
		players[i] setplayerangles (ang);
		
		// link the player in place
		players[i].lvt_linkspot 	= spawn("script_origin", org);
		players[i].lvt_linkspot_ref = spawn("script_origin", org);
		//players[i].lvt_linkspot.angles = players[i].lvt_linkspot.angles + (270,270,270);
		
		if (i == 0)
		{
			players[i].lvt_linkspot 	linkto(level.players_lvt, tag, (0,0,0), (0,0,0));
			players[i].lvt_linkspot_ref linkto(level.players_lvt, tag, (0,0,0), (0,270,0));
		}	
		else if (i == 1)
		{
			players[i].lvt_linkspot 	linkto(level.players_lvt, tag, (8,13,4), (0,0,0));
			players[i].lvt_linkspot_ref linkto(level.players_lvt, tag, (8,13,4), (0,270,0));
		}	
		else if (i == 2)
		{
			// these offsets work for player tag 5, player 3
			players[i].lvt_linkspot 	linkto(level.players_lvt, tag, (8,12,0), (0,0,0));
			players[i].lvt_linkspot_ref linkto(level.players_lvt, tag, (8,12,0), (0,270,0));
		}
		else
		{
			// these offsets work for player tag 9, player 4
			players[i].lvt_linkspot 	linkto(level.players_lvt, tag, (21,-10,0), (0,0,0));
			players[i].lvt_linkspot_ref linkto(level.players_lvt, tag, (21,-10,0), (0,270,0));
		}	
		
		players[i] playerlinktodelta(players[i].lvt_linkspot, undefined, 1.0);
		//players[i] playerlinktoabsolute(players[i].lvt_linkspot);
		players[i] PlayerSetGroundReferenceEnt(players[i].lvt_linkspot_ref);
		players[i] allowcrouch(false);
		players[i] allowprone(false);	
		players[i] takeweapon("fraggrenade");			
	}
}

attach_weapon_during_lvt_ride()
{
	wait 4;
	self attach("weapon_usa_m1garand_rifle","tag_weapon_right");
}

// lvt is stuck guys need to get out
event1_stuck_on_coral()
{
	//level.players_lvt thread event1_stuck_lvt_anim();
	earthquake( 0.35, 1.5, level.players_lvt.origin, 2050 );
	level.players_lvt playsound("lvt_crash");
	thread rumble_all_players("damage_heavy");


	// clean up wake sounds
	level.players_lvt.front_sounds thread fake_sound_fade();
	level.players_lvt.rear_sounds thread fake_sound_fade();
	
	// arbitrary timing of mocap
	wait 11.5;
	
	//Audio is using the below notify--Tuey
	level notify ("get out of lvt");
	
	thread event1_switch_weapons_on();
}

fake_sound_fade()
{
	self unlink();
	self moveto (self.origin - (0,0,1000), 1);
	self waittill ("movedone");
	self delete();
}

event1_switch_weapons_on()
{
	players = get_players();
	
	for (i = 0 ; i < players.size; i++)
	{
		players[i] SwitchToWeapon( "m1garand_bayonet" );
	}
}

// unlinks the players from the lvt
event1_get_players_off_of_lvt()
{
	players = get_players();
		
	for (i = 0; i < players.size; i++)
	{
		players[i] PlayerSetGroundReferenceEnt(undefined);

		players[i] StopRumble( "tank_rumble" );
		
		level.enable_weapons = 1;
		
		org = undefined;
		if (i == 0)
		{
			org = (1922, -13126, -425);
		}
		else if (i == 1)
		{
			org = (2242, -13102, -425);
		}
		else if (i == 2)
		{
			org = (1906, -13262, -425);
		}
		else if (i == 3)
		{
			org = (2146, -13302, -425);
		}
		
		ang = (0,90,0);
		//players[i] setorigin ( players[i].origin + (0,0,20) );
		//players[i] setplayerangles (ang);
	}
	
	
	level notify ("players off lvt");
		
	thread event1_explode_and_fade_to_white();
	
//	brush = getent("player_lvt_clip","targetname");
//	brush.origin = level.players_lvt.origin;
//	brush.angles = (0, level.players_lvt.angles[1] + 270, level.players_lvt.angles[2]) ;
//	
//	brush = getent("mantleover_lvt","targetname");
//	brush.origin = level.players_lvt.origin;
//	brush.angles = (0, level.players_lvt.angles[1] + 270,  level.players_lvt.angles[2]);
}

delete_wait()
{
	wait 1;
	self delete();
}

event1_explode_and_fade_to_white()
{
	//playfx( level.vehicle_death_fx[ "buffalo" ][ 0 ], level.players_lvt.origin );
	
	clientnotify ("pol");	// players_off_lvt
	println("players_off_lvt NOTIFY SENT");
	
	fadetowhite = [];


	playfxontag(level._effect["special_lvt_explode"], level.players_lvt, "tag_origin");
	playsoundatposition ("lvt_explo", (0,0,0)); //Using playsoundatposition by design for occlusion override.
	
		
//	wait 0.25;
		
	level.players_lvt setmodel ("vehicle_usa_tracked_lvta2_d");
	thread maps\pel1::rumble_all_players("damage_heavy");

//	level thread maps\pel1_anim::tip_vehicle();
	thread slow_mo_the_tip();

	players = get_players();
	players[0] thread maps\pel1_anim::lvt_tipover();	
	
	for( i = 0; i < players.size; i++ )
	{
		//TUEY - change shellshock
		players[i] shellshock( "lvt_exp", 10);
		
	}
		
//	for( i = 0; i < players.size; i++ )
//	{
//		fadetowhite[i] = NewclientHudElem(players[i]);	
//		
//	}
	
//	for (i = 0; i < players.size; i++)
//	{
//		// fade to black
//		fadetowhite[i].x = 0; 
//		fadetowhite[i].y = 0; 
//		fadetowhite[i].alpha = 0; 
//		
//		fadetowhite[i].horzAlign = "fullscreen"; 
//		fadetowhite[i].vertAlign = "fullscreen"; 
//		fadetowhite[i].foreground = true; 
//		fadetowhite[i] SetShader( "white", 640, 480 ); 
//
//		// Fade into white
//		fadetowhite[i] FadeOverTime( 0.2 ); 
//		fadetowhite[i].alpha = 1; 
//	}
	
	//wait 0.3;
		

		
	level waittill ("fade_from_white");

		
//	players = get_players();
//	for (i = 0; i < players.size; i++)
//	{	
//		fadetowhite[i] FadeOverTime( 0.3 ); 
//		fadetowhite[i].alpha = 0; 
//	}
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] freezecontrols(true);
		players[i] shellshock("default", 3);
	}
	
	wait 3;
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] freezecontrols(false);				
	}
	
}

slow_mo_the_tip()
{
	//settimescale (0.3);
	wait 1;
	settimescale (1);
}

event1_crawling_guys()
{
	if( is_german_build() )
	{
		return;
	}
	
	struct1 = getstruct("crawl_guy1","targetname");
	struct2 = getstruct("crawl_guy2","targetname");
	struct3 = getstruct("crawl_guy3","targetname");
	
//			spawn_fake_guy_lvt(startpoint, startangles, us, animname, name, is_lvt_drone, assign_weapon, no_pack)

	guy1 = spawn_fake_guy_lvt(struct1.origin, struct1.angles, 0, "crawl1", "crawl", 0);
	guy2 = spawn_fake_guy_lvt(struct2.origin, struct2.angles, 0, "crawl2", "crawl", 0);
	guy3 = spawn_fake_guy_lvt(struct3.origin, struct3.angles, 0, "crawl3", "crawl", 0);
	
	guy1 thread crawl_think();
	guy2 thread crawl_think();
	guy3 thread crawl_think();	
	
	guy1.a.gib_ref = "left_leg";
	guy2.a.gib_ref = "no_legs";
	guy3.a.gib_ref = "right_leg";
	
	guy1 thread animscripts\death::do_gib();
	guy2 thread animscripts\death::do_gib();
	guy3 thread animscripts\death::do_gib();
}

crawl_think()
{
	self makeFakeAI();
	self solid();
	self.interval = 128;
	self setcandamage(true);
	self.team = "axis";
	self.health = 1;
	
	self endon ("shot_death");
	//self thread play_pain_sound();
	self thread anim_loop_solo(self, "crawl_idle", undefined, "stop_idling");
	self thread crawl_death_watcher();
	
	trigger_wait("ev1_near_berm","script_noteworthy");
	
	wait randomfloatrange (0.1, 2.0);
	
	self notify ("stop_idling");
	
	self anim_single_solo(self, "crawl_crawl");
	self anim_single_solo(self, "crawl_die");

	self notify ("stop_shot_death");
	self startragdoll();
	self stopsounds();

	wait 45;
	
	if (isdefined(self))
	{
		self delete();
	}
}

play_pain_sound()
{
	self endon ("stop_shot_death");
	self endon ("shot_death");	
	
	if ( !is_mature() )
	{
		return;
	}
	
	wait randomfloatrange (0.3, 1.3);
	
	soundtoplay = [];
	
	//soundtoplay[0] = "JA_0_pain_medium";
	//soundtoplay[1] = "JA_1_pain_medium";
	//soundtoplay[2] = "JA_3_pain_medium";
	soundtoplay[0] = "JA_0_pain_large";
	soundtoplay[1] = "JA_1_pain_large";
	soundtoplay[2] = "JA_3_pain_large";
		
	
	while (isdefined(self))
	{
		rand = randomint(soundtoplay.size);

		self playsound (soundtoplay[rand], "sounddone");
		
		self waittill ("sounddone");
		
		wait randomfloatrange (2.0, 5.0);
			
	}
}

crawl_death_watcher()
{
	self endon ("stop_shot_death");

	self waittill ("damage", amount, who);
	
	if (isplayer(who))
	{
		arcademode_assignpoints( "arcademode_score_generic100", who );
	}
	
	self notify ("shot_death");
	
	self anim_single_solo(self, "crawl_shot");
	self startragdoll();
	self stopsounds();
		
	wait 45;
	
	if (isdefined(self))
	{	
		self delete();
	}
}

event1_underwater_squib(rand)
{
	level endon ("do aftermath");
	level endon ("done underwater");
		
	start = getstruct("squibline_scripted1","targetname");
	end = getstruct(start.target, "targetname");
	
	while (1)
	{	
		org = spawn("script_origin", start.origin);
		org moveto (end.origin, 1.5);
		org thread event1_squibline_think_impacts_for_anim(rand);
		org waittill ("movedone");
		org delete();
		wait 3;
	}
}

event1_underwater_squib_kill_ai()
{
	self endon ("death");
	
	level endon ("do aftermath");
		
	start = self.origin + (0,600,64);
	end = self.origin - (0, 200, 0) + (0,0,64);

	org = spawn("script_origin", start);
	org moveto (end, 1.5);
	org thread event1_squibline_think_impacts();
	org waittill ("movedone");
	org delete();
	wait 3;
	
}

// puts friendly ai on the lvt as well
event1_put_ai_on_lvt()
{
	guys = grab_starting_guys();
	tag = undefined;

	tag = "tag_passenger2";
	level.gibsworth = getent("gibsworth","script_noteworthy");
	level.gibsworth linkto (level.players_lvt, tag);
	level.gibsworth animscripted("lvt_ridein", level.players_lvt gettagorigin(tag), level.players_lvt gettagangles(tag), %crew_lvt4_peleliu1_character2);
	level.gibsworth thread event2_headshot();
	level.gibsworth thread lvt_dialog();
	
	tag = "tag_passenger3";
	level.sullivan linkto (level.players_lvt, tag);
	level.sullivan animscripted("lvt_ridein", level.players_lvt gettagorigin(tag), level.players_lvt gettagangles(tag), %crew_lvt4_peleliu1_character3);
//sul-3
//pol-7
//roe-6
//player-8


	tag = "tag_passenger7";
	level.polo linkto (level.players_lvt, tag);
	level.polo animscripted("lvt_ridein", level.players_lvt gettagorigin(tag), level.players_lvt gettagangles(tag), %crew_lvt4_peleliu1_character7);
				
	tag = "tag_passenger6";
	level.sarge linkto (level.players_lvt, tag);
	level.sarge animscripted("lvt_ridein", level.players_lvt gettagorigin(tag), level.players_lvt gettagangles(tag), %crew_lvt4_peleliu1_character6);


		
	guys = array_remove(guys, level.sarge);
	guys = array_remove(guys, level.polo);
	guys = array_remove(guys, level.sullivan);
	guys = array_remove(guys, level.gibsworth);	

	
	coop_displacements = getentarray("lvt_coop_redshirt_displacement","targetname");
	
	for (i = 0; i < coop_displacements.size; i++)
	{
		coop_displacements[i] linkto(level.players_lvt);
	}
	
	players = get_players();

	for (i = 0; i < guys.size; i++)
	{
		if (i == 0)
		{
			if (level.displaceredshirts && players.size >= 3)
			{
				tag = "tag_passenger5";
				guys[i] linkto (coop_displacements[1]);
				guys[i] animscripted("lvt_ridein", coop_displacements[1].origin, coop_displacements[1].angles, %crouch_aim_straight);
			}
			else
			{
				tag = "tag_passenger5";
				guys[i] linkto (level.players_lvt, tag);
				guys[i] animscripted("lvt_ridein", level.players_lvt gettagorigin(tag), level.players_lvt gettagangles(tag), %crew_lvt4_peleliu1_character5);
			}
		}
		else if (i == 1)
		{
			if (level.displaceredshirts && players.size == 4)
			{
				tag = "tag_passenger9";
				guys[i] linkto (coop_displacements[2]);
				guys[i] animscripted("lvt_ridein", coop_displacements[2].origin, coop_displacements[2].angles, %crouch_aim_straight);
			}
			else
			{
				tag = "tag_passenger9";
				guys[i] linkto (level.players_lvt, tag);
				guys[i] animscripted("lvt_ridein", level.players_lvt gettagorigin(tag), level.players_lvt gettagangles(tag), %crew_lvt4_peleliu1_character9);
			}
		}
		else if (i == 2)
		{
			if (level.displaceredshirts && players.size >= 2)
			{
				tag = "tag_passenger4";
				guys[i] linkto (coop_displacements[0]);
				guys[i] animscripted("lvt_ridein", coop_displacements[0].origin, coop_displacements[0].angles, %crouch_aim_straight);
			}
			else
			{
				tag = "tag_passenger4";
				guys[i] linkto (level.players_lvt, tag);
				guys[i] animscripted("lvt_ridein", level.players_lvt gettagorigin(tag), level.players_lvt gettagangles(tag), %crew_lvt4_peleliu1_character4);
			}
		}
	}	

	lvt_driver = spawn_fake_guy_lvt( (0,0,0), (0,0,0), 1, "lvt_driver", "floater", 0, 0, 1);
	lvt_driver linkto (level.players_lvt, "tag_driver");
	lvt_driver thread driver_death();

	lvt_pass = spawn_fake_guy_lvt( (0,0,0), (0,0,0), 1, "lvt_passenger", "floater", 0, 0, 1);
	lvt_pass linkto (level.players_lvt, "tag_passenger");
	
	lvt_driver thread anim_loop_solo(lvt_driver, "drive_idle", "tag_driver", "stopdriveidle", level.players_lvt);
	lvt_pass thread anim_loop_solo(lvt_pass, "drive_idle",  "tag_passenger", "stopdriveidle", level.players_lvt);
	
	//thread draw_line_until_notify( get_players()[0].origin, lvt_driver.origin, 1, 1, 1, level, "blah" );
	//thread draw_line_until_notify( get_players()[0].origin, lvt_pass.origin, 1, 1, 1, level, "blah" );
	
	level thread sully_has_a_tommy();
	
	level.displaceredshirts = false;
	level.players_lvt thread maps\pel1_anim::lvt_play_ride_in();
	
	// cleanup the driver & passenger
	level waittill ("players off lvt");
	lvt_driver 	notify ("stopdriveidle");
	lvt_pass 	notify ("stopdriveidle");
	
	lvt_driver 	delete();
	lvt_pass 	delete();
}

driver_death()
{
	self waittillmatch ("looping anim", "shot");
	
	if( is_mature() )
	{
		playfxontag(level._effect["head_shot"], self, "j_head");	
	}

}

sully_has_a_tommy()
{
	level.sullivan animscripts\shared::placeWeaponOn(level.sullivan.weapon, "none");
	level.sullivan attach("weapon_usa_thompson_smg", "tag_weapon_right");
	//level.sullivan setlookattext(level.sullivan.name, &"WEAPON_SUBMACHINEGUNNER");
	level.sullivan.weapon = "thompson";
	
	level waittill ("players off lvt");

	level.sullivan.weapon = "shotgun";	
	level.sullivan detach("weapon_usa_thompson_smg", "tag_weapon_right");
	level.sullivan animscripts\shared::placeWeaponOn(level.sullivan.weapon, "right");	
	//level.sullivan setlookattext(level.sullivan.name, &"WEAPON_SHOTGUNNER");	
	
}

lvt_dialog()
{
	//TUEY Set music state to "INTRO"
	setmusicstate("INTRO");

	self waittillmatch ("lvt_ridein", "dialog");
	level.sullivan 	playsound(level.scr_sound["intro"]["intro1"]);	// = "  Pel1_INT_000A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sarge 	playsound(level.scr_sound["intro"]["intro2"]);	// = "Pel1_INT_001B_ROEB           
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sarge 	playsound(level.scr_sound["intro"]["intro3"]);	// = " Pel1_INT_002A_ROEB_A        
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sullivan 	playsound(level.scr_sound["intro"]["intro4"]);	// = " Pel1_INT_004A_ROEB          
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	//level.sarge 	playsound(level.scr_sound["intro"]["intro5"]);	// = " Pel1_INT_005A_ROEB_A        
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sarge 	playsound(level.scr_sound["intro"]["intro6"]);	// = "  Pel1_INT_006A_ROEB         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sarge		playsound(level.scr_sound["intro"]["intro7"]);	// = "  Pel1_INT_200A_ROEB         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sullivan 	playsound(level.scr_sound["intro"]["intro8"]);	// = "  Pel1_INT_003A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sullivan 	playsound(level.scr_sound["intro"]["intro9"]);	// = "  Pel1_INT_007A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sarge 	playsound(level.scr_sound["intro"]["intro10"]);	// = "  Pel1_INT_100A_ROEB         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sullivan 	playsound(level.scr_sound["intro"]["intro11"]);	// = "  Pel1_INT_008A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sarge 	playsound(level.scr_sound["intro"]["intro12"]); //= "P  Pel1_INT_009A_ROEB_A       
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	self 			playsound(level.scr_sound["intro"]["intro13"]);	// = "  Pel1_INT_010A_PSOU         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.polo 		playsound(level.scr_sound["intro"]["intro14"]);	// = "  Pel1_INT_101A_POLO         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	self	 		playsound(level.scr_sound["intro"]["intro15"]);	// = "  Pel1_INT_103A_USR2         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sarge		playsound(level.scr_sound["intro"]["intro16"]);	// = "  Pel1_INT_011A_ROEB_a       
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sullivan 	playsound(level.scr_sound["intro"]["intro17"]);	// = "  Pel1_INT_013A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	self			playsound(level.scr_sound["intro"]["intro18"]);	// = "  Pel1_INT_012A_PSOU         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sullivan 	playsound(level.scr_sound["intro"]["intro19"]);	// = "  Pel1_INT_102A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	self 			playsound(level.scr_sound["intro"]["intro20"]);	// = "  Pel1_INT_015A_LVTD         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.sullivan	playsound(level.scr_sound["intro"]["intro21"]);	// = "  Pel1_INT_016A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                       
	level.polo 		playsound(level.scr_sound["intro"]["intro22"]);	// = "  Pel1_INT_017A_POLO         
	self waittillmatch ("lvt_ridein", "dialog");                                                                                                                      
	level.polo 		playsound(level.scr_sound["intro"]["intro23"]); // = "  Pel1_INT_018A_POLO         
	self waittillmatch ("lvt_ridein", "dialog");                                                                                                                      
	level.sullivan 	playsound(level.scr_sound["intro"]["intro24"]); // = "  Pel1_INT_019A_SULL         
	self waittillmatch ("lvt_ridein", "dialog");                                                                                                                      
	self 		 	playsound(level.scr_sound["intro"]["intro25"]); // = "  Pel1_INT_020A_PSOU         
	self waittillmatch ("lvt_ridein", "dialog");                                                                                                                      
	level.sullivan 	playsound(level.scr_sound["intro"]["intro26"]); // = "  Pel1_INT_021A_SULL         
//	self waittillmatch ("lvt_ridein", "dialog");                                                                                                                     
//	level.sullivan 	playsound(level.scr_sound["intro"]["intro27"]);  // = " Pel1_INT_104A_SULL         	
}

event1_put_ai_on_lvt_short()
{
	guys = grab_starting_guys();
	tag = undefined;
	
	tag = "tag_passenger3";
	level.sarge linkto (level.players_lvt, tag);
	
	tag = "tag_passenger7";
	level.polo linkto (level.players_lvt, tag);
			
	tag = "tag_passenger4";
	level.sullivan linkto (level.players_lvt, tag);

	tag = "tag_passenger2";
	level.gibsworth = getent("gibsworth","script_noteworthy");
	level.gibsworth linkto (level.players_lvt, tag);
	level.gibsworth thread event2_headshot();	
//	
	guys = array_remove(guys, level.sarge);
	guys = array_remove(guys, level.polo);
	guys = array_remove(guys, level.sullivan);
	guys = array_remove(guys, level.gibsworth);
		
//	guys = array_remove(guys, level.flameguy);
	
	
	coop_displacements = getentarray("lvt_coop_redshirt_displacement","targetname");
	
	for (i = 0; i < coop_displacements.size; i++)
	{
		coop_displacements[i] linkto(level.players_lvt);
	}
	
	players = get_players();

	for (i = 0; i < guys.size; i++)
	{

		if (i == 2)
		{
			if (level.displaceredshirts && players.size >= 3)
			{
				tag = "tag_passenger5";
				guys[i] linkto (coop_displacements[1]);
			}
			else
			{
				tag = "tag_passenger5";
				guys[i] linkto (level.players_lvt, tag);
			}
		}
		else if (i == 3)
		{
			if (level.displaceredshirts && players.size == 4)
			{
				tag = "tag_passenger6";
				guys[i] linkto (coop_displacements[2]);
			}
			else
			{
				tag = "tag_passenger6";
				guys[i] linkto (level.players_lvt, tag);
			}
		}
		else if (i == 4)
		{
			if (level.displaceredshirts && players.size >= 2)
			{
				tag = "tag_passenger9";
				guys[i] linkto (coop_displacements[0]);
				}
			else
			{
				tag = "tag_passenger9";
				guys[i] linkto (level.players_lvt, tag);
			}
		}
	}	
	
	level.displaceredshirts = false;
	//level.players_lvt thread maps\pel1_anim::lvt_play_ride_in();
	
	
	
}

event2_headshot()
{
	self endon ("death");
	
	self waittillmatch("lvt_ridein","head_shot");

	if( is_mature() )
	{
		playfxontag(level._effect["head_shot"], self, "j_head");	
	}

	self playsound ("headshot_imp");
	playsoundatposition("headshot_rico", self.origin - (0,150,30) + (100,0,0));
		
	self swap_gibhead_guy();

	//TUEY SetMusicState to Beach
	setmusicstate("BEACH");

	// CODER_MOD
	// Dan L - 11/03/07
	// Added death for powned dude, to stop him running off to join his buddies after he was killed.

	self waittillmatch("lvt_ridein", "end");

	self.deathanim = level.scr_anim["ridein2"]["death"];
	self.allowdeath = true;
	
	self dodamage (self.health + 10, (0,0,0));	
	

}

swap_gibhead_guy()
{
	self.a.nodeath = true;
	
	tag = "j_helmet";
	model = "char_usa_raider_helm2";

	org = self gettagorigin( tag );
	ang = self gettagangles( tag );
	

	
	if( !is_mature() )
	{
		return;
	}

	CreateDynEntAndLaunch( model, org, ang, org, ( 1200, -600, 140 ) ); 
		
	// set to the other mans
	self codescripts\character::new();
	self character\char_usa_marine_r_nb_hshot_after::main();
}

delete_hat()
{
	wait 10;
	self delete();
}

// unlinks the ai from the lvt
event1_get_ai_off_of_lvt()
{
	guys = grab_starting_guys();
	for (i = 0; i < guys.size; i++)
	{
		guys[i] unlink();
	}

	nodes = getnodearray("coral_nodes","targetname");
	
	for (i = 0; i < guys.size; i++)
	{
		guys[i] disable_ai_color();
		guys[i].moveorg =  spawn("script_origin",guys[i].origin);
		guys[i] linkto(guys[i].moveorg);
		guys[i].moveorg moveto (nodes[i].origin, 0.1);
		guys[i] setgoalnode (nodes[i]);
	}


	wait 0.2;
	for (i = 0; i < guys.size; i++)
	{
		guys[i] unlink();
	}
	
	// head shot guy should not go fetal
	level.gibsworth notify ("death");
	level.gibsworth delete();
	
	// set the color trigger
	//getent("event1_offlvt_moveup", "targetname") useby (get_players()[0]);
}

event1_sarge_over_berm()
{		
	// this should happen with everyone else, but he's going to talk to the radio guy first
	ref_point = getstruct("over_reference","targetname");
	level.sarge		 thread event2_over_berm_anim_think(ref_point, 98);
}

// logic for firing the model3
event1_model3_fire(start_point)
{	
	getent("start_models3s","targetname") waittill ("trigger");
	
	gun1 = getent("model3_gun1","targetname");
	gun2 = getent("model3_gun3","targetname");
	
	if (!isdefined(start_point))
	{
		gun1 thread event1_model3_things_get_owned();
		gun1 thread event1_model3_fire_think(gun1, 0);
		gun2 thread event1_model3_fire_think(gun2, 1);
	
		wait 2;
	}
	
	gun2 thread event1_model3_fire_at_random_targets();
}


event1_model3_fire_think(gun, random_fire)
{
	self endon ("death");
	
	gun setturrettargetent(get_players()[0]);
			
	while (1)
	{
		if (!flag( "ambients_on" ))
		{
			wait 1;
			continue;
		}
		gun fireweapon();
		gun notify ("200mm gun fired");
		
		wait 1;
		
		gun notify ("200mm gun hit");

		if (!random_fire)
		{
			wait 4;		
		}
		else
		{
			wait randomfloatrange (3.75, 6.0);
		}
	}
}

lvt_guys_exploding_out()
{
	tags = [];
	// left side
	tags[0] = "tag_passenger2";
	tags[1] = "tag_passenger3";
	tags[2] = "tag_passenger4";
	tags[3] = "tag_passenger5";
	// right side
	tags[4] = "tag_passenger6";
	tags[5] = "tag_passenger7";
	tags[6] = "tag_passenger8";
	tags[7] = "tag_passenger9";

	anims[0] = %death_explosion_left11;
	anims[1] = %death_explosion_run_L_v1;
	anims[2] = %death_explosion_run_L_v2;
	anims[3] = %death_explosion_up10;
	anims[4] = %death_explosion_right13;
	anims[5] = %death_explosion_run_B_v2;
	anims[6] = %death_explosion_run_B_v1;
	anims[7] = %death_explosion_back13;
	
	rand1 = 0;
	rand2 = 0;
	rand3 = 0;

	rand1 = randomint(tags.size);		
	while (rand1 == rand2 || rand1 == rand3 || rand2 == rand3)
	{
		rand2 = randomint(tags.size);
		rand3 = randomint(tags.size);
	}
	
	guy1 = spawn_fake_guy_lvt(self gettagorigin(tags[rand1]), self gettagangles(tags[rand1]), 1, "drone_exploders", undefined, 0);
	guy2 = spawn_fake_guy_lvt(self gettagorigin(tags[rand2]), self gettagangles(tags[rand2]), 1, "drone_exploders", undefined, 0);
	guy3 = spawn_fake_guy_lvt(self gettagorigin(tags[rand3]), self gettagangles(tags[rand3]), 1, "drone_exploders", undefined, 0);

	guy1 animscripted("lvt_explo_out", self gettagorigin(tags[rand1]), self gettagangles(tags[rand1]), anims[rand1]);
	guy2 animscripted("lvt_explo_out", self gettagorigin(tags[rand2]), self gettagangles(tags[rand2]), anims[rand2]);
	guy3 animscripted("lvt_explo_out", self gettagorigin(tags[rand3]), self gettagangles(tags[rand3]), anims[rand3]);
	
	guy1 thread rag_when_done();
	guy2 thread rag_when_done();
	guy3 thread rag_when_done();
}


rag_when_done()
{
	self waittillmatch ("lvt_explo_out", "end");
	
	if(isdefined(self))
	{
//		self startragdoll();
//		
//		wait 2;
		
		self delete();
	}
}

#using_animtree ("vehicles");
event1_model3_things_get_owned()
{
	// so it feels the same every time!
	artypiece_quakepower 	= 0.35;
	artypiece_quaketime 	= 3.0;
	artypiece_quakeradius = 10000;
	
	// the first splash
	self waittill ("200mm gun hit");	
	obj = spawnstruct();
	obj.origin = level.players_lvt.origin;
	obj.origin = obj.origin + (-400,1000,0);	// front left of lvt = water exploshan
//	obj thread maps\_mortar::mortar_boom( obj.origin, artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, level._effect["water_mortar"], 1 );
	obj thread	maps\_mortar::explosion_boom( "water_mortar", artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, 1 );
	thread rumble_all_players("damage_light");

	// dead LVT
	dead_lvt = getent("wave3_lvts1","targetname");
	self setturrettargetent(dead_lvt);
	self waittill ("200mm gun hit");
	//radiusdamage( dead_lvt.origin + ( 0, 0, 0), 200, dead_lvt.health + 1000, dead_lvt.health + 500 ); 
	earthquake(artypiece_quakepower, artypiece_quaketime, dead_lvt.origin , artypiece_quakeradius);
	//dead_lvt setflaggedanim( "sinking", %v_lvt4_sinking, 1, 0 );
	dead_lvt thread lvt_fake_death(1, 1);
	dead_lvt notify ("stop float loop");
	thread rumble_all_players("damage_heavy");
		
	// dead LVT
	dead_lvt = getent("wave1_lvts2","targetname");
	self setturrettargetent(dead_lvt);
	self waittill ("200mm gun hit");
	//radiusdamage( dead_lvt.origin + ( 0, 0, 0), 200, dead_lvt.health + 1000, dead_lvt.health + 500 ); 
	earthquake(artypiece_quakepower, artypiece_quaketime, dead_lvt.origin , artypiece_quakeradius);
	//dead_lvt setflaggedanim( "sinking", %v_lvt4_sinking, 1, 0 );
	dead_lvt thread lvt_fake_death(1, 1);
	dead_lvt notify ("stop float loop");
	thread rumble_all_players("damage_heavy");
		
	// splash
	self setturrettargetent(level.players_lvt);	
	self waittill ("200mm gun hit");	
	obj = spawnstruct();
	obj.origin = level.players_lvt.origin;
	obj.origin = obj.origin + (-200,400,0);	// front left of lvt = water exploshan
	//obj thread maps\_mortar::mortar_boom( obj.origin, artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, level._effect["water_mortar"], 1 );
	obj thread	maps\_mortar::explosion_boom( "water_mortar", artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, 1 );
	thread do_water_drops_on_camera_for_time( 4 );
	thread do_water_sheeting_on_camera();
	thread rumble_all_players("damage_light");
		
	// splash
	self setturrettargetent(level.players_lvt);	
	self waittill ("200mm gun hit");	
	obj = spawnstruct();
	obj.origin = level.players_lvt.origin;
	obj.origin = obj.origin + (0,300,0);	// front of lvt = water exploshan
//	obj thread maps\_mortar::mortar_boom( obj.origin, artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, level._effect["water_mortar"], 1 );
	obj thread	maps\_mortar::explosion_boom( "water_mortar", artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, 1 );
	thread do_water_drops_on_camera_for_time( 5 );
	thread do_water_sheeting_on_camera();
	thread rumble_all_players("damage_light");
		
	// dead LVT
	dead_lvt = getent("wave3_lvts4","targetname");
	self setturrettargetent(dead_lvt);
	self waittill ("200mm gun hit");
	//radiusdamage( dead_lvt.origin + ( 0, 0, 0), 200, dead_lvt.health + 1000, dead_lvt.health + 500 ); 
	earthquake(artypiece_quakepower, artypiece_quaketime, dead_lvt.origin , artypiece_quakeradius);
	//dead_lvt setflaggedanim( "sinking", %v_lvt4_sinking, 1, 0 );
	dead_lvt thread lvt_fake_death(1, 1);
	dead_lvt notify ("stop float loop");
	thread rumble_all_players("damage_heavy");
				
	// splash
	self setturrettargetent(level.players_lvt);	
	self waittill ("200mm gun hit");	
	obj = spawnstruct();
	obj.origin = level.players_lvt.origin;
	obj.origin = obj.origin + (0,300,0);	// front of lvt = water exploshan
	//obj thread maps\_mortar::mortar_boom( obj.origin, artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, level._effect["water_mortar"], 1 );
	obj thread	maps\_mortar::explosion_boom( "water_mortar", artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, 1 );
	thread do_water_drops_on_camera_for_time( 5 );
	thread do_water_sheeting_on_camera();
	thread rumble_all_players("damage_light");
		
	// dead LVT
	dead_lvt = getent("wave2_lvts3","targetname");
	self setturrettargetent(dead_lvt);
	self waittill ("200mm gun hit");
	radiusdamage( dead_lvt.origin + ( 0, 0, 0), 200, dead_lvt.health + 1000, dead_lvt.health + 500 ); 
	earthquake(artypiece_quakepower, artypiece_quaketime, dead_lvt.origin , artypiece_quakeradius);
	dead_lvt = getent("wave1_lvts5","targetname");
	dead_lvt notify ("stop float loop");
	dead_lvt thread lvt_fake_death(0, 1);
	thread rumble_all_players("damage_heavy");
		
	dead_lvt = getent("wave2_lvts6","targetname");
	radiusdamage( dead_lvt.origin + ( 0, 0, 0), 200, dead_lvt.health + 1000, dead_lvt.health + 500 ); 
	earthquake(artypiece_quakepower, artypiece_quaketime, dead_lvt.origin , artypiece_quakeradius);
	dead_lvt notify ("stop float loop");
	
	self waittill ("200mm gun hit");
	dead_lvt = getent("wave1_lvts3","targetname");
	radiusdamage( dead_lvt.origin + ( 0, 0, 0), 200, dead_lvt.health + 1000, dead_lvt.health + 500 ); 
	earthquake(artypiece_quakepower, artypiece_quaketime, dead_lvt.origin , artypiece_quakeradius);
	dead_lvt thread lvt_fake_death(0, 1);
	dead_lvt notify ("stop float loop");
	thread rumble_all_players("damage_heavy");
			
	dead_lvt = getent("wave3_lvts2","targetname");
	radiusdamage( dead_lvt.origin + ( 0, 0, 0), 200, dead_lvt.health + 1000, dead_lvt.health + 500 ); 
	earthquake(artypiece_quakepower, artypiece_quaketime, dead_lvt.origin , artypiece_quakeradius);
	dead_lvt notify ("stop float loop");
	
	self thread event1_model3_fire_at_random_targets();	
}

#using_animtree ("generic_human");
event1_model3_fire_at_random_targets()
{
	self endon ("death");
	
	// so it feels the same every time!
	artypiece_quakepower 	= 0.25;
	artypiece_quaketime 	= 2.25;
	artypiece_quakeradius = 3000;
	
	structs = getstructarray("water_mortar","targetname");
	
	while (isdefined(self))
	{
		target_struct = structs[randomint(structs.size)];
		self setturrettargetvec(target_struct.origin);	
		self waittill ("200mm gun hit");	

		// splash
		//target_struct thread maps\_mortar::mortar_boom( target_struct.origin, artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, level._effect["water_mortar"], 1 );	
		target_struct thread	maps\_mortar::explosion_boom( "water_mortar", artypiece_quakepower, artypiece_quaketime, artypiece_quakeradius, 1 );
		thread rumble_all_players("damage_light", "damage_heavy", target_struct.origin,  400, 800);
	}
}

event1_floating_bodies()
{
	// first set
	body_points = getstructarray("floating_bodies", "targetname");
	bodyA = [];
	for (i = 0; i < body_points.size; i++)
	{
		rand = randomint(4);
		pitchangle = 150;
		if (rand == 0)
		{
			pitchangle = 0;
		}
		bodyA[i] = spawn_fake_guy_lvt( body_points[i].origin + (0,0,-15), body_points[i].angles, 1, "blah", "floater", 0);
		bodyA[i].targetname = "floating_body";
		
		if (rand == 0 || rand == 1)
		{
			//bodyA[i] animscripted("pose", bodyA[i].origin, bodyA[i].angles, level.scr_anim["float"]["floata"]);
		}
		else
		{
			//bodyA[i] animscripted("pose", bodyA[i].origin, bodyA[i].angles, level.scr_anim["float"]["floatb"]);
		}
		wait 0.3;
		bodyA[i] startragdoll();
	}
	
	level waittill ("remove floaters");
	level notify ("stoploop_floaters");
	
	for (i = 0; i < bodyA.size; i++)
	{
		bodyA[i] delete();
	}
}

// sets up the tanks that flank to the left and right
event1_beach_tanks_setup()
{
	stop_points = getvehiclenodearray("beach_tank_stop","script_noteworthy");
	
	for (i = 0; i < stop_points.size; i++)
	{
		stop_points[i] thread event1_beach_tanks_think();
	}
	
	left_tank_node = getvehiclenode("beach_tank_left_end", "script_noteworthy");
	left_tank_node thread event1_beach_left_end_think();

	right_tank_node = getvehiclenode("beach_tank_right_end", "script_noteworthy");
	right_tank_node thread event1_beach_right_end_think();	
}

// self are the nodes, who are the tanks
event1_beach_tanks_think()
{
	self waittill ("trigger", who);
	
	who setspeed (0, 15);
	
	level waittill ("start first mortar run");
	
	who resumespeed (10);
}

// left tank blows up the bunker
event1_beach_left_end_think()
{
		self waittill ("trigger", who);
		
		who setspeed (0, 25);
				
		wait (4);
		
		radiusdamage( who.origin + ( 0, 0, 64), 600, who.health + 1000, who.health + 500 ); 
}

// right tank up and dies 
event1_beach_right_end_think()
{
		self waittill ("trigger", who);
		
		radiusdamage( who.origin + ( 0, 0, 64), 600, who.health + 1000, who.health + 500 ); 
		
		//who setspeed (0, 25);
}

event1_lvt_blowup(node_noteworthy, waittime)
{
	node = getvehiclenode (node_noteworthy, "script_noteworthy");
	
	node waittill ("trigger",who);
	
	wait (waittime);
	radiusdamage( who.origin + ( 0, 0, 64), 100, who.health + 1000, who.health + 500 ); 	
	//who setspeed (0, 25);
	
	//print3d(who.origin + ( 0,0,64), "LVT BLEW UP!" 	, (1,0,0), 1, 3, 100);
}

event1_lvt_jeep_driver_dies()
{
	org = self.attached_jeep gettagorigin("tag_driver");
	ang = self.attached_jeep gettagangles("tag_driver");
	
	//println("jeep angles: " + ang);	
	guy = spawn_fake_guy_lvt(org, ang, 1, "drone_jeep_rider", "drone_jeep_rider");
	guy linkto (self.attached_jeep, "tag_driver");
	guy animscripted ("single anim", org, ang, %ch_driver_peleliu1_jeep_destroyed);
	self.attached_jeep.attached_guy = guy;	
}

// the main assault
event2_setup()
{
	thread event2_meet_with_sarge();
	thread event2_trap_door_watcher();
	//thread event2_bunker_explode_think();	
	thread event2_pistol_jap();
	thread event2_fire_walkers();
	//thread event2_bayonett_vignette();
	thread event2_grenade_death_guy();
	thread event2_redshirt_reinforce_begin();

	thread event2_dazed_guys();	
	thread event2_treeguy_dialogue();
	thread event2_grass_guy_dialogue();
	thread event3_setup();
	thread event2_weapon_pickups();
	thread event2_left_amtank_setup();
	thread event2_delete_vehicles_on_warp();	
	
}

event2_weapon_pickups()
{
	thread weapon_cleanup();
	
	trig1 = getent("crater1","targetname");
	trig2 = getent("crater2","targetname");
	trig3 = getent("crater3","targetname");
	
	trig1 waittill ("trigger");
	trig2 waittill ("trigger");
	trig3 waittill ("trigger", who);
	
	wait 10;
	

	
	if (isdefined(who) && who istouching (trig3))
	{
		//TUEY Sets the bus state to EASTER

		setbusstate("EASTER");
		starts1 = getentarray("gun01","targetname");
		starts2 = getentarray("gun02","targetname");
		starts3 = getentarray("gun03","targetname");
		starts4 = getentarray("gun04","targetname");
	
	
		starts1[0] moveto (starts1[0].origin + (0,0,500), 10, 6, 3);
		starts2[0] moveto (starts2[0].origin + (0,0,500), 10, 6, 3);
		starts3[0] moveto (starts3[0].origin + (0,0,500), 10, 6, 3);
		starts4[0] moveto (starts4[0].origin + (0,0,500), 10, 6, 3);

		starts1[1] moveto (starts1[1].origin + (0,0,500), 10, 6, 3);
		starts2[1] moveto (starts2[1].origin + (0,0,500), 10, 6, 3);
		starts3[1] moveto (starts3[1].origin + (0,0,500), 10, 6, 3);
		starts4[1] moveto (starts4[1].origin + (0,0,500), 10, 6, 3);
	
		if ( SoundExists( "Pel1_IGD_900A_JAS2_ST" ) )
		{
			playsoundatposition("Pel1_IGD_900A_JAS2_ST", starts1[0].origin + (0,0,500) );
		}
		
		earthquake( 0.3, 16, starts1[0].origin + (0,0,500), 2000 );
		playsoundatposition("earthquake", (0,0,0));

		thread rumble_all_players("damage_light", "damage_heavy", starts1[0].origin + (0,0,500),  400, 800);
		

		starts = getentarray ("r_gun_trigs","targetname");
		for (i = 0; i < starts.size; i++)
		{
			starts[i] thread do_give();
		}
		
		level notify ("rg_weapons_avail");
		level thread timer_for_bus(12);
	}

}
timer_for_bus(time)
{
	wait(time);
	setbusstate("return_default_slow");

}
do_give( weapon )
{
	wait 10;
	self.origin = self.origin + (0,0,500);
	
	while (1)
	{
		self waittill ("trigger", who);
		
		primaryWeapons = who GetWeaponsListPrimaries(); 
		current_weapon = undefined; 

		// This should never be true for the first time.
		if( primaryWeapons.size >= 2 ) // he has two weapons
		{
			current_weapon = who getCurrentWeapon(); // get his current weapon	

			if( isdefined( current_weapon ) )
			{
				who TakeWeapon( current_weapon ); 
			} 
		} 

		if( IsDefined( primaryWeapons ) && !isDefined( current_weapon ) )
		{
			for( i = 0; i < primaryWeapons.size; i++ )
			{
				who TakeWeapon( primaryWeapons[i] ); 
			}
		}

		who GiveWeapon( "ray_gun", 0 ); 
		who GiveMaxAmmo( "ray_gun" ); 
		who SwitchToWeapon( "ray_gun" ); 
	}
}

weapon_cleanup()
{
	level endon ("rg_weapons_avail");
	
	while (1)
	{
		players = get_players();
		
		for (i = 0; i < players.size; i++)
		{
			primaryWeapons = players[i] GetWeaponsListPrimaries();

			if( IsDefined( primaryWeapons ) )
			{
				for ( x = 0; x < primaryWeapons.size; x++ )
				{
					if ( primaryWeapons[x] == "ray_gun" )
					{
						players[i] TakeWeapon( primaryWeapons[x] );
					}
				}
			}
		}
		
		wait 0.2;
	}
}


event2_delete_vehicles_on_warp()
{
	trigger_wait("first_fight_warp","script_noteworthy");
	
	vehicles = getentarray("script_vehicle","classname");	
	for (i = 0; i < vehicles.size; i++)
	{
		vehicles[i] notify ("death");
		vehicles[i] delete();
	}	
}



event2_left_amtank_setup()
{
	node = getvehiclenode("left_side_amtank_stop1","script_noteworthy");
	
	node waittill ("trigger", who);
	
	who setspeed (0, 10);
	
	
	wait 15;
	
	waittill_aigroupcount("trench_jumpdown_guys", 0);
	
//	group_count = get_ai_group_count("trench_jumpdown_guys");
//	while (group_count)
//	{
//		group_count = get_ai_group_count("trench_jumpdown_guys");
//					
//		ai = get_ai_group_ai("trench_jumpdown_guys");
//		
//		if (ai.size)
//		{
//			who setturrettargetent(ai[0]);
//			wait 5;
//			who fireweapon();
//		}
//		else 
//		{
//			wait 0.1;
//			continue;
//		}	
//	}
	
	who resumespeed (10);
}


event2_treeguy_dialogue()
{
	trigger_wait ("tree_sniper_start","script_noteworthy");
	
	level notify ("grass_guys_dialog");
		
	wait 1.5;
	// tree area
	// "SULLIVAN!"\
	level.sarge anim_single_solo(level.sarge, "tree_area1");
	// "The tree!"\
	level.sarge anim_single_solo(level.sarge, "tree_area2");
	wait 1;
	// "What the Hell is he doing?!!"\
	level.polo anim_single_solo(level.polo, "tree_area3");
	wait 1;
	// "Take him down!"\
	level.sarge anim_single_solo(level.sarge, "tree_area4");
}

event2_grass_guy_dialogue()
{
	flag_wait( "grass_attack1" );
		
	// "In the grass!"\
	level.sarge anim_single_solo(level.sarge, "tree_area6");
	// "They're comin' out the Goddamn grass!"\
	level.sarge anim_single_solo(level.sarge, "tree_area7");
	wait 1.5;
	// "Stay together!"\
	level.sarge anim_single_solo(level.sarge, "tree_area8");
	wait 1.5;
	// "Shit!"\
	level.polo anim_single_solo(level.polo, "tree_area9");
	
	
	flag_wait( "grass_attack2" );
	// "More of 'em! "\
	wait 1;
	level.sullivan anim_single_solo(level.sullivan,"tree_area10");
	
	waittill_aigroupcount("ev1_grassguys1", 0);
	waittill_aigroupcount("ev1_grassguys2", 0);
	
	wait 1;
	
	trig = getent("post_grass_moveup1","targetname");
	if (isdefined(trig))
	{
		trig notify ("trigger");
	}
	
	// "They were waiting for us…"\
	//level.polo anim_single_solo(level.polo, "tree_area11");
	wait 2;
	// "Everyone keep 'em peeled."\
	level.sullivan anim_single_solo(level.sullivan, "tree_area12");
	wait 1;
	// "From here on out - watch the terrain."\
	level.sarge anim_single_solo(level.sarge, "tree_area13");
	wait 0.5;
	// "They could be anywhere."\
	level.sarge anim_single_solo(level.sarge, "tree_area14");
}

//event2_friendly_moveup_on_enemy_death()
//{
//	if (1)
//		return;
//	
//	trig1 = getent("moveup1","targetname");
//	//trig2 = getent("moveup2","targetname");
//	trig3 = getent("moveup3","targetname");
//	trig4 = getent("moveup4","targetname");
//	
//	trig3 thread event2_moveup_dialogue();
//	
//	// waittill first group near done				
//	while (get_ai_group_count("frontline") > 8)
//	{
//		wait 1;
//	}
//	
//	// auto move up friendlies
//	if (isdefined(trig1))
//	{
//		trig1 useby (get_players()[0]);
//	}
//
//	// TODO: THIS ONE IS GONE NOW, REMOVE
//	// wait for second line to be low	-	
//	while (get_ai_group_count("second_line") > 8)
//	{
//		wait 1;
//	}
//
////	// move up to second (or nearby third) line
////	if (isdefined(trig2))
////	{
////		trig2 useby (get_players()[0]);
////	}
//if  (isdefined(trig3))
//	{
//		trig3 useby (get_players()[0]);			
//	}
//
//	// guys in the tunnels that come out near end
//	while (get_ai_group_count("third_line") > 8)
//	{
//		wait 1;
//	}
//	
//	// get guys in front of tunnels
//	if (isdefined(trig4))
//	{
//		trig4 useby (get_players()[0]);
//	}
//	
//}

event2_dazed_guys()
{
	level waittill ("start first mortar run");
	
	if( is_german_build() )
	{
		trig = getent("spawn_dazed","targetname");
		trig delete();
	}
	else
	{
		getent("spawn_dazed","targetname") useby (get_players()[0]);	
	}

	
	level notify ("remove floaters");
		
}

event2_dazed_die_over_time()
{
	self endon ("death");
	self endon ("damage");
	
	wait (randomfloatrange(7,11));
	self.deathanim = self.possibledeathanim;
	self dodamage(self.health + 1, self.origin + (0,0,randomintrange(16,64)));
}

// each guy gets his own thread since the anims are diffent lengths
event2_over_the_berm_anims()
{
	wait (0.1);
	ref_point = getstruct("over_reference","targetname");
	
	guys = grab_starting_guys();
	
	guys = array_remove(guys, level.sarge);
	//guys = array_remove(guys, level.flameguy);
	
	//level.flameguy thread event2_over_berm_anim_think(ref_point, 99);
	
	for (i = 0; i < guys.size; i++)
	{
		guys[i] thread event2_over_berm_anim_think(ref_point, i);
	}	
}

// logic for going over the berm
event2_over_berm_anim_think(ref_point, point_num)
{
	self disable_ai_color();
	
	self endon ("death");
	
	//self waittill ("goal");
	
	// if you're not on the beach, wait to prevent errors with the water depth run function
	while (self.origin[1] < -11256)
	{
		wait 0.1;
	}
	
	self.animname = "berm" + (point_num + 1);
		
	if (self == level.sarge)
	{
		self.animname = "sarge";
	}

	// get everyone there
	self anim_reach_solo(self, "over", undefined, ref_point );
	
	self allowedstances("crouch");
	wait 0.5;
	flag_wait("over_berm_flag");
	
	// we dont know sullivans animname (it could be one of many) so lets just play the right VO
	if (self == level.sullivan)
	{
		level notify ("stop color dialog");
		thread sullivan_over_sounds();
	}
	
	if (self == level.sarge)
	{
		wait_for_berm3 = false;
		ai = getaiarray ("allieS");
		for (i = 0; i < ai.size; i++)
		{
			if (ai[i].animname == "berm3")
			{
				wait_for_berm3 = true;
				
				if (self != level.polo && self != level.sarge && self != level.sullivan && self != level.radioguy)
				{
					ai[i] thread magic_bullet_shield();
				}
			}
		}
		
		if (wait_for_berm3)
		{
			flag_wait("over_berm_3_flag");	
		}
	}
	// then animate everyone
	self anim_single_solo(self, "over",undefined, ref_point );  

	if (self.animname == "berm3")
	{
		flag_set("over_berm_3_flag");	
		
		if (self != level.polo && self != level.sarge && self != level.sullivan && self != level.radioguy)
		{
			self thread stop_magic_bullet_shield();
		}
	}
	
	trig = getent("event2_foxhole_colorgroup","targetname");
	if (isdefined(trig))
	{
		trig notify ("trigger");
	}
	
	if (self == level.polo)
	{
		self.animname = "polo";
		flag_set("polo_over_berm");			
		//self thread anim_single_solo(self, "over_berm1");		
	}

	if (self == level.sullivan)
	{
		self.animname = "sullivan";
		flag_set("sullivan_over_berm");
	}
		
	if (self == level.sarge)
	{
		flag_set("sarge_over_berm");			
		//wait 1;
		//self thread anim_single_solo(self, "over_berm2");
	}
	
	self allowedstances("crouch", "stand", "prone");
		
	self enable_ai_color();
	
}

sullivan_over_sounds()
{
		wait 1.0;
		level.sullivan 	playsound(level.scr_sound["sullivan"]["moveup_beach6"]);
		
		//wait 2;
		flag_wait("polo_over_berm");			
		level.polo playsound(level.scr_sound["polo"]["over_berm1"]);	
	
		wait 1.5;
		flag_wait("sarge_over_berm");			
		level.sarge playsound(level.scr_sound["sarge"]["over_berm2"]);
}

// lets me know if I need to spawn in more redshirts as the first battle starts
event2_redshirt_reinforce_begin()
{
	trig = getent("initial_spawn","script_noteworthy");
	
	trig waittill ("trigger");

	reds 		= get_force_color_guys( "allies", "r" );
	greens  = get_force_color_guys( "allies", "g" );

	//iprintlnbold("greens: "+ greens.size);
	//iprintlnbold("reds: "+reds.size);
	
}

event2_grenade_death_guy()
{
	if( is_german_build() )
	{
		return; 
	}
	
	level endon ("stop_suicide");
		
	thread event2_grenade_guys_ender();
	getent("event2_grenade_death_guy_trig","targetname") waittill ("trigger");
	
	org = getstruct("event2_grenade_death_guy_spot","targetname");
		
	spawner = getent(org.targetname, "target");
	
	guy = spawn_fake_guy_lvt(org.origin, org.angles, 0, "grenade_jap", "grenade_jap", 0);
	
	guy.a.gib_ref = "right_arm";

	guy thread do_gib_after_time(4);
	
	//guy makeFakeAI();
	//guy setcandamage(false);
	//guy.team = "axis";
	//guy.health = 1;

	guy thread anim_single_solo( guy, "suicide", undefined, org );			
}

event2_grenade_guys_ender()
{
	trigger_wait("dont_do_suicide","targetname");
	
	level notify ("stop_suicide");
}


do_gib_after_time( time_wait )
{
	wait (time_wait);
	
	self thread animscripts\death::do_gib();
}

event2_fire_walkers()
{
	//level.scr_anim["on_fire_run"]["on_fire"]
	//level.scr_anim["on_fire_walk"]["on_fire"]
			
	getent("event2_fire_wallkers_trig","targetname") waittill ("trigger");

	level.flameguy thread event2_flame_ambient();
	ambient_turret = getent("ambient_side_mg","targetname");
	level thread event2_ambient_mg_crush();
	
	//ambient_turret thread invincible_turret_setup(100000, 1);
	
	ambient_turret.manual_targets = getentarray(ambient_turret.target,"targetname");
	ambient_turret.manual_targets[0] thread move_mg_target(ambient_turret);
	ambient_turret SetMode( "auto_nonai" );
	ambient_turret thread maps\_mgturret::burst_fire_unmanned();
	unmanned = true;

	level thread event2_ambient_battle_watcher();
	
	
	level.flameguy enable_ai_color();
	
	thread event2_first_fight_dialogue();
	
	thread event2_flame_walk_out_fx();
	
//	wait (0.1);
//		
//	walkers = get_ai_group_ai( "firewalkers" );
//	
//	for (i = 0; i < walkers.size; i++)
//	{
//		walkers[i].animname = walkers[i].script_noteworthy;
//		walkers[i] thread event2_bunker_flamedeath_hack_wait();		
//		walkers[i] thread event2_flame_walk_out_death();
//		
//		if (walkers[i].script_noteworthy == "on_fire_run")
//		{			
//			walkers[i].deathanim = level.scr_anim["on_fire_run"]["on_fire"];
//			walkers[i] dodamage(walkers[i].health + 10, (0,0,0));
//				
//			//walkers[i] thread anim_single_solo( walkers[i], "on_fire" );
//		} 
//		else if (walkers[i].script_noteworthy == "on_fire_walk")
//		{
//			walkers[i].deathanim = level.scr_anim["on_fire_walk"]["on_fire"];
//			walkers[i] dodamage(walkers[i].health + 10, (0,0,0));				
//			
//			//walkers[i] thread anim_single_solo( walkers[i], "on_fire" );
//		} 	
//	}
	
	wait 10;
	
	level.flameguy enable_ai_color();
		
}

event2_ambient_battle_watcher()
{
	flag_wait ("ambient_moveup");
	
	mg = getent("ambient_side_mg","targetname");
	
	thread clean_up_ambient_stuff();
					
}

move_mg_target(ambient_turret)
{
	ambient_turret endon ("death");
	while (1)
	{
		self moveto ((2632, -7357, -241.666), 2);
		wait randomfloatrange(1,3);
		self moveto ((2952, -7320, -216.542), 2);
	}
}

event2_flame_walk_out_death()
{
	self endon ("death");
	
	self waittill ("single anim");
	self dodamage(self.health + 10, (0,0,0));
}

event2_flame_walk_out_fx()
{
	fx1 = getstruct("event2_walkflame_point1","targetname");
	fx2 = getstruct("event2_walkflame_point2","targetname");
	
//	door = getent("flame_door","targetname");
//	door rotateroll (-90, 0.2);
	
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );
	wait (0.25);
	playfx( level._effect[ "bunker_fire_out" ], fx2.origin + (0,0,32), anglestoforward(fx2.angles ) );
	
	wait 0.25;

	playfx( level._effect[ "bunker_fire_out" ], fx2.origin + (0,0,32), anglestoforward(fx2.angles ) );	
	wait (0.25);
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );

	wait 0.5;	
	
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );
	wait (0.5);
	playfx( level._effect[ "bunker_fire_out" ], fx2.origin + (0,0,32), anglestoforward(fx2.angles ) );

	wait 0.75;

	playfx( level._effect[ "bunker_fire_out" ], fx2.origin + (0,0,32), anglestoforward(fx2.angles ) );	
	wait (0.25);
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );
	
	wait 0.5;
	
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );
	wait (0.5);
	playfx( level._effect[ "bunker_fire_out" ], fx2.origin + (0,0,32), anglestoforward(fx2.angles ) );
	
	//notify for audio -- Tuey
	level notify("bunker_busted");

	//TUEY Setting music state to FIRST_FIGHT
	setmusicstate("FIRST_FIGHT");
}

event2_first_fight_dialogue()
{	
	level endon ("grass_guys_dialog");
	
	flag_wait("past_flame_mg");
	
	level.sarge.animname = "sarge";
	level.sullivan.animname = "sullivan";
	level.polo.animname = "polo";

	players = get_players();
	
	if (distance(players[0].origin, level.sarge.origin) < 1500)
	{
		battlechatter_on();
				
		wait 2;
		
		banzai = get_living_ai( "first_banzai_guy", "script_noteworthy" );
		
		friendlies = getaiarray("allies");
		
		if (isdefined(banzai) && isalive(banzai) )
		{
			canseeai = false;
			for (i = 0; i < friendlies.size; i++)
			{
				if (friendlies[i] cansee(banzai))
				{
					// "Banzai charge!"\
					level.sarge anim_single_solo(level.sarge, "first_fight2");
					break;
				}
			}
		}
		
		wait 3;
		// "They're not gonna hold back!"\
		level.sarge anim_single_solo(level.sarge, "first_fight3");
		

	
		wait 2;
		// "Stay on 'em!"\
		level.sarge anim_single_solo(level.sarge, "first_fight4");
	
		wait 3;
	
		// "Eyes south!  Another MG!"\
		level.sarge anim_single_solo(level.sarge, "first_fight5");
		// "Miller - Take it out."\
		level.sullivan anim_single_solo(level.sullivan, "first_fight6");
		// "Keep it tight!"\
		wait 3;
		level.sullivan anim_single_solo(level.sullivan, "first_fight7");
		wait 3;
		// "Tojo!... On the ridge!"\
		//level.sarge anim_single_solo(level.sarge, "first_fight8");
	}
		
	flag_wait("over_wall_attackers");
	BadPlacesEnable( 1 );
	
	wait 2;
	// "They're coming over the wall!"\
	level.sarge anim_single_solo(level.sarge, "first_fight11");
	
	wait 4;
	// "Stay with me, Miller."\
	level.sarge anim_single_solo(level.sarge, "first_fight12");

	wait 12;
	// "Clear out the trenches!"\
	level.sarge anim_single_solo(level.sarge, "first_fight9");
	
	wait 10;
	// "Keep pushing!!!"\
	level.sullivan anim_single_solo(level.sullivan, "first_fight10");


}

event2_pistol_jap()
{
	if( is_german_build() )
	{
		return; 
	}
	
	org = getstruct("event2_pistol_jap","targetname");

	guy = spawn_fake_guy_lvt(org.origin, org.angles, 0, "pistol_jap", "pistol_jap", 0);
	
	//wait (0.1);
	guy makeFakeAI();
	guy setcandamage(true);
	guy.team = "axis";
	guy.health = 5;
	guy UseAnimTree(#animtree);
	guy attach("weapon_jap_nambu_pistol", "tag_weapon_right");
	
	thread addNotetrack_customFunction( "pistol_jap", "fire", ::event2_jap_pistol_fire, "fire" );
	
	guy thread anim_loop_solo( guy, "grab_loop", undefined, "stop_grabbing", org );	

	guy thread event2_pistol_jap_think(org);	
	guy thread event2_jap_pistol_death(org);	
}

event2_pistol_jap_think(org)
{
	self endon ("death");
	self endon ("damage");
	trig = getent("event2_pistol_jap_start_fire","targetname");
	trig waittill ("trigger");
	
	self notify ("stop_grabbing");
	self anim_single_solo( self, "fire", undefined, org );
	self notify ("death");
}

event2_jap_pistol_fire(guy)
{
	//iprintlnbold("fire gun");
	playfxontag (	level._effect["pistol_flash"]	, guy, "tag_flash");
	magicbullet("nambu", self.origin - (0,0,59), self.origin - (0,0,60));
	
	dam_trig = getent("event2_pistol_jap_fire_dam","targetname");
	
	players = get_players();
	player = players[randomint(players.size)];
	
	if (player istouching(dam_trig))
	{
			player dodamage( 10, guy.origin );
	}	
}

event2_jap_pistol_death(org)
{
	self thread event2_jap_pistol_death_assign_points();
	self waittill_any ("damage", "death");
	
	self anim_single_solo( self, "death", undefined, org );
	self startragdoll();
}

event2_jap_pistol_death_assign_points()
{
	self endon ("death");
	
	self waittill ("damage", amount, who);
	
	if (isplayer(who))
	{
		arcademode_assignpoints( "arcademode_score_generic100", who );
	}
}



event3_setup()
{
	level.sarge.animname = "sarge";
	level.sullivan.animname = "sullivan";
	level.polo.animname = "polo";
	
	thread event3_dialogue();
	thread event3_into_bunker_dialogue();
	thread event3_into_bunker_dialogue2();
	thread event3_upstairs_dialogue();	
	thread event3_last_bunker_rocket_damage_think();
	thread event3_flank_right_flag_set();
	thread event3_tanks();
	thread event3_suppressed_amtank();
	thread event3_setup_tunnel_radio();
	thread event3_clean_up_enemies();
	thread event3_mortar_checker();
}

event3_clean_up_enemies()
{
	trigger_wait("obj_entrance_gained","targetname");
	
	no_zone_mover = getent("no_zone_mover","script_noteworthy");
	no_zone_mover.origin = no_zone_mover.origin + (0,0,10000);
	
	ai = getaiarray("axis");
	
	for (i = 0; i < ai.size; i++)
	{
		if ( isdefined(ai[i]) && isalive(ai[i]) && ai[i].origin[1] < -4090)
		{
			ai[i] thread bloody_death();
			wait randomfloatrange (0.75, 3.0);
		}
	}
		
}



event3_setup_tunnel_radio()
{
	broken_radio = "radio_jap_bro";
	radio = getent("tunnel_radio","targetname");
	radio playloopsound("pel1_radio");
	broken = false;
	radio setcandamage(true);
	
	radio waittill("damage", amount, who);
	
	// 500 points for the radio
	arcademode_assignpoints( "arcademode_score_generic500", who );
		
	
	playfx(level._effect["broken_radio_spark"],radio.origin + (randomintrange(-10,10),randomintrange(-10,10),randomintrange(1,10)));
	radio stoploopsound();
	radio playsound("radio_destroyed");
	radio setmodel(broken_radio);
	
	for (i = 0; i < 12; i++)
	{
		wait( randomfloatrange(1,3) );
		playfx( level._effect["broken_radio_spark"], radio.origin + (randomintrange(-10,10),randomintrange(-10,10),randomintrange(1,10)) );
		radio playsound("radio_destroyed");
	}
}

event3_last_bunker_rocket_damage_think()
{
	area = getent("big_bunker_damage_area","targetname");
	
	spawner1 = getent("rocketman_delete1","script_noteworthy");
	spawner2 = getent("rocketman_delete2","script_noteworthy");
	
	area.remove_spawner = false;
	while (1)
	{
		area waittill( "damage", damage, other, direction, origin, damage_type );
		if (damage_type == "MOD_CRUSH")
		{
			level notify ("bunker_crushed");
			
			area thread event3_rocket_remove_spawner(spawner1, spawner2);
			axis = getaiarray("axis");
			for (i = 0; i < axis.size; i++)
			{
				if (axis[i] istouching(area))
				{
					axis[i] dodamage(axis[i].health + 10, (0,0,0));
				}	
			}
		}
	}	
}


event1_small_bunker_rocket_damage_think()
{
	area = getent("small_bunker_damage_area","targetname");
		
	while (1)
	{
		area waittill( "damage", damage, other, direction, origin, damage_type );
		if (damage_type == "MOD_CRUSH")
		{			
			axis = getaiarray("axis");
			for (i = 0; i < axis.size; i++)
			{
				if (axis[i] istouching(area))
				{
					axis[i] dodamage(axis[i].health + 10, (0,0,0));
					playsoundatposition("rocket_target_explo", (1944,-6304,-144) );
					return;
				}	
			}
		}
	}	
}

event2_ambient_mg_crush()
{
	area = getent("crush_ambient_mg","targetname");
		
	while (1)
	{
		area waittill( "damage", damage, other, direction, origin, damage_type );
		if (damage_type == "MOD_CRUSH")
		{			
			mg = getent("ambient_side_mg","targetname");
			
			if (isdefined(mg))
			{
				if (mg istouching(area))
				{
	
					thread clean_up_ambient_stuff();
					return;
				}
			}	
		}
	}	
}

clean_up_ambient_stuff()
{
	mg = getent("ambient_side_mg","targetname");

	if (isdefined(mg))
	{
		mg notify ("death");
		mg delete();
	}
		
	level.flameguy clearentitytarget();
	level.flameguy notify ("stop_flaming");
							

					
	trig = getent("auto6310","target");
	if (isdefined(trig))
	{
		trig delete();
	}

	trig = getent("auto6309","target");
	if (isdefined(trig))
	{
		trig delete();
	}	
	
	wait 5;
	trig = getent("ambient_moveup_orange","script_noteworthy");
	if (isdefined(trig))
	{
		trig notify ("trigger");
	}
	
	trig = getent("auto6348","target");
	if (isdefined(trig))
	{
		trig notify ("trigger");
	}	
	
	thread remove_flame_guy();
	
}


remove_flame_guy()
{
	if (isdefined(level.flameguy))
	{
		level.flameguy waittill ("goal");
		
		if (isdefined(level.flameguy))
		{
			level.flameguy notify( "_disable_reinforcement" );
			level.flameguy stop_magic_bullet_shield();
			level.flameguy delete();
		}
	}
}

// if people call rockets on the bunker, take out the MG guy
event3_rocket_remove_spawner(spawner1, spawner2)
{
	if (self.remove_spawner)
	{
		return;
	}
	
	self.remove_spawner = true;
	
	if (isdefined(spawner1))
	{
		playsoundatposition("rocket_target_explo", spawner1.origin );
		spawner1 delete();
		
		wait 10;
		self.remove_spawner = false;
		return;
	}
	else if (isdefined(spawner2))
	{
		playsoundatposition("rocket_target_explo", spawner2.origin );			
		spawner2 delete();
		wait 10;
		self.remove_spawner = false;
		return;
	}
}

event3_dialogue()
{
	trigger_wait("post_grass_moveup2","targetname");
	level.sarge set_force_color("g");
			
	level endon ("going into tunnels");
	
	// "Regroup at the truck."\
	level.sarge anim_single_solo(level.sarge, "third_fight1");
	
	wait 1;

	// "Roebuck - Tunnels southwest."\
	level.sullivan anim_single_solo(level.sullivan, "third_fight2");
	
	waittill_aigroupcount("tunnel_banzaiers", 0);
	wait 1;
	// "Get in there... See if you can get a flanking position."\
	level.sullivan anim_single_solo(level.sullivan, "last_fight3");
	
	wait 2;
	
	level thread event3_player_stays_in_the_open_leftside();
	
	trigger_wait("event3_flank_tunnel1","targetname");
	// "Miller - on me!"\
	level.sarge anim_single_solo(level.sarge, "third_fight4");
	
	trigger_wait("event3_flank_tunnel2","targetname");
	// "Let's get the jump on these bastards."\
	level.sarge anim_single_solo(level.sarge, "third_fight5");

	trigger_wait("event3_flank_tunnel3","targetname");
	// "We got 'em."\
	level.sarge anim_single_solo(level.sarge, "third_fight6");

	trigger_wait("event3_flank_tunnel4","targetname");
	// "Hit 'em hard!"\
	level.sarge anim_single_solo(level.sarge, "third_fight7");
	
	wait 3;
	// "Keep firing!"\
	level.sarge anim_single_solo(level.sarge, "third_fight8");
}

event3_into_bunker_dialogue()
{	
	level endon ("stop_into_bunker_dialogue");
	
	trig = getent("event3_into_final_bunker","targetname");
	trigorg = trig.origin;
	
	trigger_wait("event3_into_final_bunker","targetname");
	level.sarge set_force_color("r");
	
	// wait until a player and the squad are nearby
	guys_near_player_and_trig = false;
	while (!guys_near_player_and_trig)
	{
		if (distance(trigorg, level.sullivan.origin ) < 500)
		{
			nearest_player = get_closest_player( trigorg );
			if (distance(nearest_player.origin, level.sullivan.origin) < 500)
			{
				guys_near_player_and_trig = true;
			}
		}
		wait 0.1;
	}
	
	// into the last bunker
	// "Roebuck, Miller... Good work. "\
	level.sullivan anim_single_solo(level.sullivan, "final_bunker1");
	// "Let's finish this."\
	level.sarge anim_single_solo(level.sarge, "final_bunker2");
	// "Move in."\
	level.sullivan anim_single_solo(level.sullivan, "final_bunker3");
	

}

event3_into_bunker_dialogue2()
{
	level endon ("stop_inside_bunker_dialogue");
	
	trigger_wait("event3_into_final_bunker2","targetname");
	
	wait 2;
	level notify ("stop_into_bunker_dialogue");
	
	// "Up the ladder."\
	level.sarge anim_single_solo(level.sarge, "final_bunker4");
	wait 1.25;
	// "Clear 'em out!"\
	level.sarge anim_single_solo(level.sarge, "final_bunker5");
}

event3_upstairs_dialogue()
{		
	trigger_wait("event2_after_trap_door_fc","targetname");

	level notify ("stop_inside_bunker_dialogue");
	
	wait 3;	
	
	level.sarge.animname = "sarge";
	level.sullivan.animname = "sullivan";
	
	// "Shit!... Mortars southwest!"\
	level.sarge anim_single_solo(level.sarge, "final_bunker6");
	// "They've got Jackson's squad pinned down!"\
	level.sarge anim_single_solo(level.sarge, "final_bunker7");
	// "Get on those MGs and tear them up!"\
	level.sullivan anim_single_solo(level.sullivan, "final_bunker8");
	
	level.sarge thread tell_player_to_use_rockets();
	
	waittill_aigroupcount("mortar_squads", 4);
	// "Keep on it, Miller!"\
	level.sarge anim_single_solo(level.sarge, "final_bunker9");

	flag_wait ("end_tanks_dead");

	waittill_aigroupcount("mortar_squads", 0);	
	
	level notify ("end_cleared");
	
	// "Outstanding, Marines... Out-fucking-standing."\
	level.sullivan anim_single_solo(level.sullivan, "final_bunker10");
	level notify ("mortar guys dead");

	thread event3_drones_moveup();
	//TUEY Set Music State to END_LEVEL
	setmusicstate("END_LEVEL");

	// "There's more mortar pits ahead - we need to move on."\
	level.sarge anim_single_solo(level.sarge, "final_bunker11");	
	level.sullivan anim_single_solo(level.sullivan, "final_bunker12");



	
}

tell_player_to_use_rockets()
{
	level endon ("end tank died");


	wait 3;
		level.sarge anim_single_solo(level.sarge, "use_rockets_end4");	
		level.sarge anim_single_solo(level.sarge, "use_rockets_end2");	
			
	while (1)
	{
		wait 12;
		level.sarge anim_single_solo(level.sarge, "use_rockets_end3");
		level.sarge anim_single_solo(level.sarge, "use_rockets_end1");
	
		wait 12;
		
		level.sarge anim_single_solo(level.sarge, "use_rockets_end4");	
		level.sarge anim_single_solo(level.sarge, "use_rockets_end2");		
	}

}

event3_drones_moveup()
{
	//wait 2.5;
	flag_wait("end_tanks_dead");
			
	drones = getentarray("run_n_gun_drones","script_noteworthy");
	
	for (i = 0; i < drones.size; i++)
	{
		drones[i] notify ("Stop shooting");
		
		if (i % 4 == 0)
		{
			wait 0.5;
		}
	}
}

event1_lci_rocket_fire(dest_point, start_points, do_aftermath, is_player_controlled, which_player)
{	
	// launch ftom the boat
	thread play_sound_in_space ("rocket_launch", start_points[0]);
				
	if (isdefined(do_aftermath))
	{
		level thread event1_lci_aftermath_effect();	
	}
		
	for (i = 0; i < start_points.size; i++)
	{
			rocket = spawn ("script_model", start_points[i]);
			rocket setmodel ("peleliu_aerial_rocket");
			yaw_vec = vectortoangles(dest_point - rocket.origin);
			
			rocket.angles = (315, yaw_vec[1] ,0);
			
			// TODO: take out this wait
			wait (0.01);
			playfx( level._effect[ "rocket_launch" ], rocket.origin, anglestoforward(rocket.angles + (20,0,0) ) );	
			playfxontag( level._effect[ "rocket_trail" ], rocket, "tag_origin" );
			
			// sound of rocket flying through the air
			//level thread maps\pel1_amb::play_rocket_sound(rocket);	
		
			rocket playloopsound ("rocket_run");

			if (isdefined(do_aftermath) && do_aftermath)
			{
				rocket thread event1_lci_rocket_fly_think((dest_point[0] - 1000 + randomint(2000), dest_point[1] - 1000 + randomint(2000), dest_point[2] + randomint (40)));
			}
//			else if (isdefined(is_player_controlled) && is_player_controlled)
//			{
//				//rocket thread maps\_dpad_asset::lci_player_rocket_fly_think((dest_point[0] - 200 + randomint(200), dest_point[1] - 200 + randomint(200), dest_point[2] - (32)), which_player);
//			}			
			else
			{
				rocket thread event1_lci_simple_rocket_fly_think((dest_point[0] - 1000 + randomint(2000), dest_point[1] - 1000 + randomint(2000), dest_point[2] + randomint (40)));
			}
			wait (randomfloatrange (0.1, 0.2));
	}
}

event1_lci_aftermath_effect()
{
	level waittill ("do aftermath");
	playfx(level._effect["rocket_aftermath"], (2071, -8481, -314.8) );
	playsoundatposition("rocket_target_explo", (2036, -10207, -295.9));
	
}



// and the rockets' red glaaaaaare
event1_lci_rocket_fly_think( destination_pos )
{ 
	// self is the rocket
	//self endon ("remove thrown object");
	
	//TUEY set music state to "ROCKETS" when play blows up the jungle.
	setmusicstate("PLAYER_ROCKETS");	
	thread throw_object_with_gravity( self, destination_pos );
	
	while (1)
	{
		if (self.origin[2] < -450 )
		{
			if (self.origin[1] < -9552)
			{
				playfx(level._effect["lci_rocket_impact"], self.origin);	
				playsoundatposition("rocket_impact",self.origin);
				// lci rocket impact sound
				thread play_sound_in_space ("rocket_dirt", self.origin);
			}
			else
			{
				rand = randomint(5);
				if (rand == 0)
				{
					playfx(level._effect["lci_rocket_impact"], self.origin);	
					playsoundatposition("rocket_impact",self.origin);
					
				}
				playsoundatposition("mortar_dirt",self.origin);
								
			}
			self stoploopsound(1);
			earthquake( 0.5, 3, self.origin, 6050 );
			thread main_rocket_rumble();	
			level notify ("start removing trees");

			break;
		}
		/*
		else
		{
			counter = RandomIntRange(1,5);
			if (counter == 1)
			{
				playfx(level._effect["lci_rocket_impact_dummy"], self.origin);
			}
		}
		*/
		wait (0.05);
	}
	level notify ("do aftermath");
	clientnotify ("bfe");	// beach_fakefire_end
		
	flag_clear("ambients_on");
		
	self notify ("remove thrown object");
	
	// to get shit deleting again
	wait (2);
	self delete();	
}

main_rocket_rumble()
{
	// the initial hit
	thread rumble_all_players("damage_heavy");
		
	// start looping
	players = get_players();
	for (i = 0; i< players.size; i++)
	{
		level.players_lvt PlayRumbleLoopOnEntity( "tank_rumble" );
	}
	
	wait 7;
	
	//end looping
	players = get_players();
	for (i = 0; i< players.size; i++)
	{
		players[i] StopRumble( "tank_rumble" );
	}	
}

// and the rockets' red glaaaaaare
event1_lci_simple_rocket_fly_think( destination_pos )
{ 
	// self is the rocket
	//self endon ("remove thrown object");
		
	thread throw_object_with_gravity( self, destination_pos );
	
	while (1)
	{
		if (self.origin[2] < -450 )
		{
				playfx(level._effect["lci_rocket_impact"], self.origin);	
				// lci rocket impact sound
				self stoploopsound(1);
				playsoundatposition ("rocket_impact", self.origin);
				
				earthquake( 0.5, 3, self.origin, 2050 );	
				break;
		}
		wait (0.05);
	}		
	self notify ("remove thrown object");
	
	// to get shit deleting again
	wait (2);
	self delete();	
}

event1_rocket_impact_think()
{
	things_to_damage = getentarray("script_model","classname");
	
	level waittill ("start removing trees");
	
	// for gary, should only play once on first player called in impact
	playsoundatposition("fake_rockets_L", (2036, -10207, -295.9));
	playsoundatposition("fake_rockets_R", (1036, -10207, -295.9));
	
	for (i = 0; i < things_to_damage.size; i++)
	{
		if (isdefined (things_to_damage[i]) && (things_to_damage[i].model == "foliage_cod5_tree_maple_02_large" || things_to_damage[i].model == "foliage_pacific_palms01" || things_to_damage[i].model == "foliage_pacific_palms02" 
																						|| things_to_damage[i].model == "foliage_pacific_forest_shrubs03" || things_to_damage[i].model == "foliage_pacific_forest_shrubs01"))
		{
			//if (distance (self.origin, things_to_damage[i].origin) > 50)
			//{
				//foliage_cod5_tree_maple_02_large
				if (things_to_damage[i].model == "foliage_cod5_tree_maple_02_large" || things_to_damage[i].model == "foliage_pacific_palms01" || things_to_damage[i].model == "foliage_pacific_palms02")
				{
					stumps = [];
					stumps[0] = "foliage_pacific_snapped_palms01";
					stumps[1] = "foliage_pacific_snapped_palms04";
					stumps[2] = "foliage_pacific_snapped_palms04a";
					stumps[3] = "foliage_pacific_snapped_palms04b";
					stumps[4] = "foliage_pacific_snapped_palms04c";

					// delete things in the middle of the path
					if (things_to_damage[i].origin[0] > 1450 && things_to_damage[i].origin[0] < 2500)
					{
						if (things_to_damage[i].origin[1] > -10300 && things_to_damage[i].origin[1] < -8400)
						{
							things_to_damage[i] thread event2_tree_rotate_and_delete();
						}
					}
					else
					{
						rand =	randomint(5);
						 
						if (rand == 0)
						{
							playfx(level._effect["palms01"], things_to_damage[i].origin, anglestoforward(things_to_damage[i].angles + (270,0,0)));			 
						}
						else if (rand == 1)
						{
							playfx(level._effect["palms04"], things_to_damage[i].origin, anglestoforward(things_to_damage[i].angles + (270,0,0)));	
						}
						else if (rand == 2)
						{
							playfx(level._effect["palms04a"], things_to_damage[i].origin, anglestoforward(things_to_damage[i].angles + (270,0,0)));	
						}
						else if (rand == 3)
						{
							playfx(level._effect["palms04b"], things_to_damage[i].origin, anglestoforward(things_to_damage[i].angles + (270,0,0)));		
						}
						else if (rand == 4)
						{
							playfx(level._effect["palms04c"], things_to_damage[i].origin, anglestoforward(things_to_damage[i].angles + (270,0,0)));	
						}

						//things_to_damage[i] setmodel(stumps[rand]);
						//things_to_damage[i] playsound ("tree_fall");
						playsoundatposition("tree_fall", things_to_damage[i].origin);
		
						things_to_damage[i] thread event2_tree_rotate_and_delete();
					}
				}
				else if (things_to_damage[i].model == "foliage_pacific_forest_shrubs03" || things_to_damage[i].model == "foliage_pacific_forest_shrubs01")
				{
					things_to_damage[i] thread event2_tree_rotate_and_delete();
					//foliage_pacific_burnt_bush01
				}
			//}
		}
		//wait (0.2);
	}
}

event2_tree_rotate_and_delete()
{
	wait randomfloatrange (1, 4);
	self rotateto((180, 270, 0), 1.5, 0.6, 0.1);
	wait 1.8;
	self delete();
}

event2_meet_with_sarge()
{

	thread set_objective(1);



	// get the machienguns ready
	thread event2_open_fire();


	thread event2_over_the_berm_anims();
		
	trigger_wait("ev1_near_berm","script_noteworthy");
	
	flag_set( "jog_enabled" );
	event1_jog_the_ai();
	thread event1_sarge_over_berm();
	
	
	level.sullivan  playsound(level.scr_sound["sullivan"]["moveup_beach6a"]);
				
	
	level notify ("start first mortar run");
	


	drones = getentarray("drone","targetname");
	for (i = 0; i < drones.size; i++)
	{
			drones[i] notify ("drone out of cover");
	}
	

	
	getent("event2_foxhole_colorgroup","targetname") useby (get_players()[0]);
	//getent("event2_foxhole_colorgroup","targetname") delete();
	
	//level.sarge disable_ai_color();
	//level.sarge setgoalnode (getnode("event2_foxhole_sarge","targetname"));
	//level.sarge.goalradius = 32;
		

		
	//level.sarge.animplaybackrate = 1.0;
	
	//level.sarge waittill ("goal");
	//level.sarge.animname = "sarge";

	
	// turn off all the friendly ai for a sec
	ai = getaiarray("allies");
	for (i = 0; i < ai.size; i++)
	{
			ai[i] set_ignoreall(true);
	}
	
				
	//level notify ("remove floaters");		
	
	// MikeD: Flaming the bunker!
	flag_init( "flame_the_bunker" );
	flag_clear( "flame_the_bunker" );
	
	trigger_wait("ev2_player_neaby_foxhole","targetname");
	
	level thread event2_flame_the_bunker();
	

	// MikeD: Flaming the bunker!
	level waittill( "bunker_getting_flamed" );
	
	wait( 4 );
	
	wait 2;
	level notify ("flame guy is flaming bunker");
	wait 2;
	
	smolderpoint = getstruct("event1_bunker_smolder","targetname");
	playfx(level._effect["bunker_fire_smolder"], smolderpoint.origin, anglestoforward(smolderpoint.angles));
	
	flag_set( "flame_the_bunker" );
	
	level notify ("moving up after flame");
	wait (1);

								
	// guys dont use chain here, use colors, two squads, green and red on left / right.
	level.sarge enable_ai_color();		

	thread event2_use_and_remove_first_line_color_trigs();
	
	// turn off all the friendly ai for a sec
	ai = getaiarray("allies");
	for (i = 0; i < ai.size; i++)
	{
		ai[i] set_ignoreall(false);
	}
		
}

event1_jog_the_ai()
{
	ai = getaiarray ("allies");
	
	for (i = 0; i < ai.size; i++)
	{
		ai[i] thread jog_internal();
	}
}

event2_main_rocket_attack()
{
	// this will be the time afte rthe boat until the rockets begin
	//trigger_wait("ev1_rocket_barrage_start", "targetname");
	level waittill ("do big barrage");
	 	
	level.radioguy thread anim_single_solo(level.radioguy, "rb_confirm_main");
	
	wait 5;
	
	// rockets from each ship
	num_rockets = 36;
	num_rockets_per_ship = 12;
	
	pa_fire = getent("pa_fire_right","targetname");
	playsoundatposition("pa_fire", pa_fire.origin);
	
	wait(0.4);
	pa_fire_b = getent("pa_fire_left","targetname");
	pa_fire_b playsound("pa_fire");


	// grab start points
	start_points	= [];
	
	orgs = getstructarray("rocketbarrage_points2","targetname");
	
	// popultate the ship
	q = 0;
	for(i = 0; i < num_rockets; i++)
	{
		q = i % num_rockets_per_ship;	
		start_points[i] = orgs[q].origin;
	}
	
	//level waittill ("sarge signals rockets");
	
	level thread event1_rocket_impact_think();
		
	level thread event1_lci_rocket_fire((2041, -8080, -535.5), start_points, 1);	
		
	// grab start points
	start_points = [];
	
	orgs = getstructarray("rocketbarrage_points1","targetname");
	
	// popultate the ship
	q = 0;
	for(i = 0; i < num_rockets; i++)
	{
		q = i % num_rockets_per_ship;		
		start_points[i] = orgs[q].origin;
	}
	
	level thread event1_lci_rocket_fire((2041, -8080, -535.5), start_points, 1);
}


event2_reply_to_sarge()
{
	level.sarge anim_single_solo( level.sarge, "sarge_in_hole" );
		
}

// MikeD: Tells Flamer to Flame the Bunker
event2_flame_the_bunker()
{

	
	level.flameguy = pel1_ai_spawner("flame_guy_spawner");


	flag_set("flameguy_spawned");
	
	
	level.flameguy disable_ai_color();
	level.flameguy.goalradius = 32;
	level.flameguy setgoalnode (getnode("event2_flameguy_flamenode","targetname"));
	level.flameguy.animname = "jonesy";
	
	level.flameguy thread magic_bullet_shield();
	
	level.flameguy.cansee_override = 1;
	
	og_shootTime_min = level.flameguy.a.flamethrowerShootTime_min;
	og_shootTime_max = level.flameguy.a.flamethrowerShootTime_max;

	level.flameguy.a.flamethrowerShootTime_min = 10000;
	level.flameguy.a.flamethrowerShootTime_max = 15000;

	og_DelayTime_min = level.flameguy.a.flamethrowerShootDelay_min;
	og_DelayTime_max = level.flameguy.a.flamethrowerShootDelay_max;

	level.flameguy.a.flamethrowerShootDelay_min = 0;
	level.flameguy.a.flamethrowerShootDelay_max = 1;

	org = Spawn( "script_origin", ( 2171, -7800, -294 ) );
	targets = [];
	//targets[0] = ( 1875, -8162, -294 );
	//targets[1] = ( 2171, -8170, -294 );

	targets[0] = ( 2000, -8000, -180 );
	targets[1] = ( 2180, -8000, -220 );

	level.flameguy waittill ("goal");	
	level.flameguy SetEntityTarget( org );


	wait( 1 );

	level notify( "bunker_getting_flamed" );

	while( !flag( "flame_the_bunker" ) )
	{
		for( i = 0; i < targets.size; i++ )
		{
			time = 1.5;
			org MoveTo( targets[i], time );
			org waittill( "movedone" );
		}
	}

	level.flameguy ClearEntityTarget();
	org Delete();

	level.flameguy.a.flamethrowerShootTime_min = og_shootTime_min;
	level.flameguy.a.flamethrowerShootTime_max = og_shootTime_max;

	level.flameguy.a.flamethrowerShootDelay_min = og_DelayTime_min;
	level.flameguy.a.flamethrowerShootDelay_max = og_DelayTime_max;
	
	level.flameguy.cansee_override = undefined;
}

event2_flame_ambient()
{
	self endon ("stop_flaming");
	
	
	level.flameguy.cansee_override = 1;
	
	og_shootTime_min = level.flameguy.a.flamethrowerShootTime_min;
	og_shootTime_max = level.flameguy.a.flamethrowerShootTime_max;

	level.flameguy.a.flamethrowerShootTime_min = 10000;
	level.flameguy.a.flamethrowerShootTime_max = 15000;

	og_DelayTime_min = level.flameguy.a.flamethrowerShootDelay_min;
	og_DelayTime_max = level.flameguy.a.flamethrowerShootDelay_max;

	level.flameguy.a.flamethrowerShootDelay_min = 0;
	level.flameguy.a.flamethrowerShootDelay_max = 1;

	org = getent("flame_ai_ambient_target","targetname");


	level.flameguy thread flame_on_off(org);
		
	level.flameguy waittill ("goal");
	level.flameguy SetEntityTarget( org );

	wait( 1 );

	level notify( "ambient_getting_flamed" );

	targets[0] = ( 2728, -7176, -104 );
	targets[0] = ( 2864, -7176, -104 );
	 	
	while( !flag( "flame_the_ambient" ) )
	{
		for( i = 0; i < targets.size; i++ )
		{
			time = 1.5;
			org MoveTo( targets[i], time );
			org waittill( "movedone" );
		}
	}

	level.flameguy ClearEntityTarget();
	org Delete();

	level.flameguy.a.flamethrowerShootTime_min = og_shootTime_min;
	level.flameguy.a.flamethrowerShootTime_max = og_shootTime_max;

	level.flameguy.a.flamethrowerShootDelay_min = og_DelayTime_min;
	level.flameguy.a.flamethrowerShootDelay_max = og_DelayTime_max;
	
	level.flameguy.cansee_override = undefined;
}

flame_on_off(org)
{
	self endon ("stop_flaming");
	
	while (isalive(self))
	{
		self SetEntityTarget( org );
		wait randomfloatrange(3, 5);
		self ClearEntityTarget();
		wait randomfloatrange(3, 8);		
	}
}

// machine guns open fire across the field
event2_open_fire()
{
	level endon ("stop flame out");
	
	getent("ev2_machinegun_openfire","targetname") waittill ("trigger");
	// machineguns open fire here
	
	BadPlacesEnable( 0 );
		
	thread event2_mg_dialogue();
	
	flag_set("ambients_on");
	
	getent("event2_jap_mg_guy_trig","targetname") notify ("trigger");
	
	level notify ("mgs_open_fire");
	clientnotify("mof");	// mgs_open_fire
	
	flag_clear( "jog_enabled" );
		
	level thread mg_open_flap();
	
	friendlies_crouch_only(false);
	
	dazed = get_ai_group_ai("dazed");
	for (i = 0; i < dazed.size; i++)
	{
		if (isalive(dazed[i]))
		{
			 dazed[i] dodamage ( dazed[i].health + 10, (0,0,32));
		}
	}	
	
	//iprintlnbold ("MGs! Get down in that crater!");
	
	// guy is flaming bunker
	level waittill ("flame guy is flaming bunker");

	
	thread event2_flame_out_fx();
	
	getent("flamebunker_window_right","targetname") delete();
	
	earthquake( 0.25, 1.5, (2000, -8000, 0), 2000 );
	thread rumble_all_players("damage_light", "damage_heavy", (2003.5, -8071.3, -348),  400, 800);


	flame_mg_guy = get_living_ai( "flame_mg_guy", "script_noteworthy" );

	thread event2_bunker_flamedeath("event2_japflamedeath1", "flamebunker1", "event2_japflamedeath_point1", flame_mg_guy);


}

event2_mg_dialogue()
{

	
	// "MG nest!"\
	
	flag_wait("sarge_over_berm");	
	level.sarge.animname = "sarge";	
	level.sarge anim_single_solo(level.sarge, "over_berm4");

	flag_wait("sullivan_over_berm");
	level.sullivan.animname = "sullivan";		
	// "Hit the deck!!!"\
	level.sullivan anim_single_solo(level.sullivan, "over_berm3");

	//Tuey Set Music State to MG_ENCOUNTER
	setmusicstate("MG_ENCOUNTER");


	flag_wait("flameguy_spawned");
	
	// "Flamethrower! Move up!"\
	level.sarge anim_single_solo(level.sarge, "over_berm5");
	// "Yes, Sir!"\
	//level.flameguy anim_single_solo(level.flameguy, "over_berm6");
	
	flag_wait("polo_over_berm");
	wait 2;		
	level.polo.animname = "polo";
	// "Burn 'em, Jonesy."\
	level.polo anim_single_solo(level.polo, "over_berm7");
	
	wait 1;
	// "Fix bayonets!"\
	level.sullivan anim_single_solo(level.sullivan, "over_berm8");
	// "Use 'em if you have to!"\
	level.sullivan anim_single_solo(level.sullivan, "over_berm9");
	
	
	level waittill ("moving up after flame");
	
	//TUEY Setting music state to FIRST_FIGHT
	setmusicstate("FIRST_FIGHT");	

	// "Pick it up... Push through their lines!"\
	level.sullivan anim_single_solo(level.sullivan, "over_berm10");
	// "Flank left!  Around the bunker!"\	
	level.sarge anim_single_solo(level.sarge, "first_fight1");
	
	flag_set("past_flame_mg");
}

rocket_strike_user_notify_monitor()
{
	self waittill("player pulledout rockets");
	
	if(isdefined(self.hintElem))
	{
		self.hintElem destroy();
		self.hitElem = undefined;
	}
}

rocket_strike_user_notify()
{	
	self endon ("player pulledout rockets");
	
	self thread rocket_strike_user_notify_monitor();

	self.hintElem = maps\_hud_util::createFontString( "objective", 1.2, self );
	self.hintElem maps\_hud_util::setPoint( "TOP", undefined, 0, 110 );
	self.hintElem.sort = 0.5;
	self.hintElem.alpha = 0;
	self.hintElem fadeovertime(0.5);
	self.hintElem.alpha = 1;
	
	self.hintElem setText( &"PEL1_ROCKET_HOWTO" );
	
	self thread fade_hint_over_time();
	
	self thread do_rocket_hud_elem();

	
	//iprintlnbold (&"PEL1_ROCKET_HOWTO");
/*	level.hintElem = maps\_hud_util::createFontString( "objective", 2 );
	level.hintElem maps\_hud_util::setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;
	level.hintElem.alpha = 0;
	level.hintElem fadeovertime(0.5);
	level.hintElem.alpha = 1;
	
	level.hintElem setText( &"PEL1_ROCKET_HOWTO" );
	
	level.hintElem thread fade_hint_over_time();
	
		
	players = get_players();

	players[0] thread do_rocket_hud_elem();*/
	
}

fade_hint_over_time()
{
	self endon ("player pulledout rockets");	
	
	wait 6.4;

	self.hintElem fadeovertime(1);
	self.hintElem.alpha = 0;
		
	wait 2;
	self.hintElem destroy();
	self.hintElem = undefined;
}

do_rocket_hud_elem_monitor()
{
	self waittill("player pulledout rockets");
	if(isdefined(self.hintElem2))
	{
		self.hintElem2 destroy();
		self.hintElem2 = undefined;
	}
}

do_rocket_hud_elem()
{
	self endon ("player pulledout rockets");

	self thread do_rocket_hud_elem_monitor();
			
	self.hintElem2 = newclienthudelem(self);
	
	self.hintElem2.x = 290; 
	self.hintElem2.y = 200; 
	self.hintElem2.alpha = 0; 

	self.hintElem2.foreground = true; 
	self.hintElem2 SetShader( "hud_icon_air_raid", 64, 64); 

	// Fade into white
	self.hintElem2 FadeOverTime( 0.2 ); 
	self.hintElem2.alpha = 1; 
	
	
	wait 5;
	
	self.hintElem2 MoveOverTime( 1.5 );
	self.hintElem2.y = 450;
	self.hintElem2.x = self.hintElem2.x + 70;
	self.hintElem2 ScaleOverTime( 1.5, 8, 8 ); 
	
	wait 1.2;
	
	self.hintElem2 FadeOverTime( 0.2 ); 
	self.hintElem2.alpha = 0;
	wait 0.2;
	self.hintElem2 destroy();
	self.hintElem2 = undefined;
}

mg_open_flap()
{
	flap = getent("the_flap","targetname");
	cover = getentarray("flap_cover","targetname");

	for (i = 0; i < cover.size; i++)
	{
		cover[i] linkto (flap);
	}	
	
	flap rotateroll(-90, 1);
}

event2_stop_mg_fire_early()
{
	level endon ("stop_caring_about_mg");
	
	trigger_wait("stop_mg_fire_early","targetname");
	
	self notify ("death");
	level notify ("stop flame out");
	self delete();
}

event2_flame_out_fx()
{
	fx1 = getstruct("event2_japflamedeath_point1","targetname");
	//fx2 = getstruct("event2_japflamedeath_point2","targetname");
	
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );
	wait (0.25);
	//playfx( level._effect[ "bunker_fire_out" ], fx2.origin + (0,0,32), anglestoforward(fx2.angles ) );
	playsoundatposition("rocket_falloff_dist", fx1.origin);
	
	wait 0.5;
	
	level notify ("stop_caring_about_mg");
		
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );
	playsoundatposition("rocket_explode_dirt", fx1.origin);
	
	wait (0.75);
	//playfx( level._effect[ "bunker_fire_out" ], fx2.origin + (0,0,32), anglestoforward(fx2.angles ) );
	
	wait 1.25;	
	
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin + (0,0,32), anglestoforward(fx1.angles ) );
	playsoundatposition("bunker_explo", fx1.origin);
	wait (0.5);

	
}

event2_bunker_flamedeath(t_name, animname, animpoint, flame_mg_guy)
{
	point = getstruct(animpoint, "targetname");
		
	if (isdefined(flame_mg_guy) && isalive(flame_mg_guy) && flame_mg_guy.health > 1)
	{
		guy = flame_mg_guy;
	}	
	else
	{
		// if players are nearby and can see the spawn, return
		players = get_players();
		for (i = 0; i < players.size; i++)
		{
			if (distance(players[i].origin, point.origin) < 150)
			{
				return;
			}
		}
		
		// if we make it through, spawn the man
		guy = getent(t_name, "targetname") stalingradspawn();
	}

	guy playsound ("body_burn");
	
	guy.animname = animname;
	guy.ignoreme = true;
				

	
	// this would allow for the player to shoot and guys and ragdoll them but right now
	// setting skipdeathanim makes the guys delete sometimes
	//guy.skipdeathanim = true;
	//guy.allowdeath = true;	
	guy thread event2_bunker_flamedeath_hack_wait();
	guy anim_single_solo( guy, "flamedeath", undefined, point );
	guy playsound("body_burn");
	//print3d(guy.origin + ( 0,0,0), "org here" 	, (1,0,0), 1, 3, 100);
	if (isalive (guy))
	{
		if (guy.origin[0] > 2000)
		{
			guy.deathanim = level.scr_anim["flamebunker1"]["dead"]; 
		}
		else
		{
			guy.deathanim = level.scr_anim["flamebunker2"]["dead"]; 
		}
		guy dodamage( guy.health + 50, (0,0,0) );
	}
	//guy anim_single_solo( guy, "dead", undefined, point );	
}

event2_bunker_flamedeath_hack_wait()
{
	//total hack until playfxontag starts working again
	wait 0.1;
	
	self thread animscripts\death::flame_death_fx();
}

// waits until trigger is hit before opening trap door and throwing down some nades
event2_trap_door_watcher()
{
	
	
	level waittill ("mortar guys dead");
	flag_wait("end_tanks_dead");
	
	wait 1.5;
	
	animguys = [];	
	animguys[0] = level.sarge;
	animguys[1] = level.polo;
	animguys[2] = level.sullivan;
		
	level.sarge 		disable_ai_color();
	level.polo 	disable_ai_color();
	level.sullivan 	disable_ai_color();
	
	level.sarge.animname = "sarge";
	level.polo.animname = "polo";
	level.sullivan.animname = "sullivan";	
	
	refpoint = getnode("outro_door_node","targetname");
	
	left_door = getent("bunker_door_left","targetname");
	right_door = getent("bunker_door_right","targetname");
	
	level thread maps\pel1_amb::play_end_music();
	
	level.sullivan.goalradius = 32;
	level.polo.goalradius = 32;
	level.sarge.goalradius = 32;
	
	level anim_reach(animguys, "outro_start", undefined, undefined, refpoint);
	
	set_yaws_of_outro_guys( refpoint );
	
	trig = getent("event2_blow_door","targetname");
	breakme = false;
	while (!breakme)
	{
		players = get_players();
		
		for (i = 0; i < players.size; i++)
		{
			if (trig istouching (players[i]))
			{
				breakme = true;
			}
		}
		wait 0.05;
	}

	
	objective_state (6, "done");
			
	axis_spawner = getent("outro_axis_spawn", "targetname");
	ally_spawner = getent("outro_ally_spawn", "targetname");
	
	axis_guy = axis_spawner stalingradspawn();
	axis_guy.dropweapon = false;
	axis_guy.ignoreme = true;
	axis_guy.ignoreall = true;
	
	ally_guy = ally_spawner stalingradspawn();
	
	axis_guy.animname = "officer";
	ally_guy.animname = "jackson";
	
	animguys[3] = axis_guy;
	//animguys[4] = ally_guy;

	level thread event3_final_door_openings();
//	ally_guy thread event3_door_open_notify_ally(axis_guy, refpoint);
	axis_guy thread event3_door_open_notify_axis();
	axis_guy thread event3_katana_watcher();
	
	level.sarge thread end_level_watcher();
	

	thread event3_outro_dialogue( axis_guy );
	level.sullivan thread event3_sully_drop();
	level.sarge thread event3_roebuck_fire_and_drop();
	
	//level anim_single(animguys, "outro_start", undefined, undefined, refpoint);
	animguys[1] thread anim_single_solo(animguys[1], "outro_start", undefined, refpoint);
	animguys[1] waittillmatch("single anim", "start_anims");
	
	animguys[0] thread anim_single_solo(animguys[0], "outro_start", undefined, refpoint);
	animguys[2] thread anim_single_solo(animguys[2], "outro_start", undefined, refpoint);
	animguys[3] anim_single_solo(animguys[3], "outro_start", undefined, refpoint);
	//animguys[4] anim_single_solo(animguys[4], "outro_start", undefined, refpoint);				
}

event3_sully_drop()
{
	self waittillmatch ("single anim", "detach_gun");
	
	self animscripts\shared::placeWeaponOn(self.weapon, "none");
		
	org = self gettagorigin( "tag_weapon_right" );
	ang = self gettagangles( "tag_weapon_right" );

	gun = spawn("script_model", org);
	gun.angles = ang;
	gun setmodel("weapon_usa_trenchgun_rifle");
}

event3_roebuck_fire_and_drop()
{
	self waittillmatch ("single anim", "fire_gun");
	playfxontag ( level._effect["thompson_muzzle"], self, "tag_flash");
	self playsound ("outro_gunshot");
	
	self waittillmatch ("single anim", "detach_gun");
	
	self animscripts\shared::placeWeaponOn(self.weapon, "none");
	
	org = self gettagorigin( "tag_weapon_right" );
	ang = self gettagangles( "tag_weapon_right" );

	gun = spawn("script_model", org);
	gun.angles = ang;
	gun setmodel("weapon_usa_thompson_smg");
	
		
}

set_yaws_of_outro_guys( ref_point )
{
	sullnode = getnode("final_sullivannode","targetname");
	sargenode = getnode("final_sargenode","targetname");
	polonode = getnode("final_polonode","targetname");
	
	level.sullivan.goalradius = 32;
	level.polo.goalradius = 32;
	level.sarge.goalradius = 32;
	
	org1 = getstartOrigin( ref_point.origin, ref_point.angles, level.scr_anim[ "sullivan" ][ "outro_start" ] );
	org2 = getstartOrigin( ref_point.origin, ref_point.angles, level.scr_anim[ "sarge" ][ "outro_start" ] );
	org3 = getstartOrigin( ref_point.origin, ref_point.angles, level.scr_anim[ "polo" ][ "outro_start" ] );
	
	
	level.sullivan 	setgoalpos(org1, sullnode.angles);
	level.sarge 	setgoalpos(org2, sargenode.angles );
	level.polo 		setgoalpos(org3, polonode.angles);
	
	
	level.at_outro_goals = 0;
	level.sullivan thread inc_goal_setter(sullnode);
	level.sarge thread inc_goal_setter(sargenode); 
	level.polo thread inc_goal_setter(polonode);
	
	while (level.at_outro_goals != 3)
	{
		wait 0.05;
	}
	
	
}

inc_goal_setter( node )
{
	self waittill ("goal");
	self waittill ("orientdone");
	
	//self thread animscripts\stop::main();
	//self setgoalnode (node);
	wait 0.75;
	
	level.at_outro_goals++;
}


end_level_watcher()
{
	self waittillmatch ("single anim", "start_fade_to_black");
	nextmission();
}


event3_katana_watcher()
{
	self endon ("scripted death");

	self.ignoreall = true;
	self.ignoreme = true;
	
	self animscripts\shared::placeWeaponOn(self.weapon, "none");	
	self attach("weapon_jap_katana_long", "tag_weapon_left");
	
	thread event3_katana_drop_regular();
	
	
	self waittill ("death");
	self drop_the_sword();
}

event3_katana_drop_regular()
{
	self endon ("death");
	
	self waittillmatch("single anim","drop_sword");
	
	self notify ("scripted death");
	self drop_the_sword();
}

drop_the_sword()
{
	self detach("weapon_jap_katana_long", "tag_weapon_left");
	
	angles = self gettagangles("tag_weapon_left");
	origin = self gettagorigin("tag_weapon_left");
	
	CreateDynEntAndLaunch( "weapon_jap_katana_long", origin, angles, origin, (1,1,1) ); 
}

event3_outro_dialogue( axis_guy )
{
	battlechatter_off();
	
	level.polo waittillmatch ("single anim", "dialog");
	level.sarge 	playsound(level.scr_sound["outro"]["outro1"]);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
	level.sullivan 	playsound(level.scr_sound["outro"]["outro2"]);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
					playsoundatposition(level.scr_sound["outro"]["outro3"], level.sullivan.origin);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
	level.polo 		playsound(level.scr_sound["outro"]["outro4"]);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
	level.sullivan	playsound(level.scr_sound["outro"]["outro5"]);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
					playsoundatposition(level.scr_sound["outro"]["outro6"], axis_guy.origin);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
	axis_guy 		playsound(level.scr_sound["outro"]["outro7"]);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
	 				playsoundatposition(level.scr_sound["outro"]["outro8"], axis_guy.origin);	// = "";
	
	level.polo waittillmatch ("single anim", "dialog");
	level.sullivan 	playsound(level.scr_sound["outro"]["outro9"]);	// = "";	
	
	level.polo waittillmatch ("single anim", "dialog");
	level.sarge 	playsound(level.scr_sound["outro"]["outro10"]);	// = "";	
	
	level.polo waittillmatch ("single anim", "dialog");
					playsoundatposition(level.scr_sound["outro"]["outro11"], level.sarge.origin);	// = "";			
}

event3_final_door_openings()
{
	rightdoor	= getent("bunker_door_right", "targetname");
	leftdoor	= getent("bunker_door_left", "targetname");
	

	
	level waittill ("open_door_axis");	
	
	//TUEY Lets try this...shoudl switch music when the door is opened.
	setmusicstate("SULLIVAN_DIED");
	
	rightdoor notsolid();
	
	rightdoor rotateyaw(120, 0.5);
	rightdoor waittill ("rotatedone");
	rightdoor rotateyaw(-20, 5);
}


event3_door_open_notify_axis()
{

	self waittillmatch ("single anim", "hit_door" );
	level notify ("open_door_axis");
	
	level.sullivan waittillmatch ("single anim", "stabbed" );	
	
	playfxontag(level._effect["sullivan_death_fx"], level.sullivan, "tag_inhand");
	
	thread rumble_all_players("damage_light", "damage_heavy", level.sullivan.origin, 300, 600);


	// Promoted!
	level.sarge.name = "Sgt. Roebuck";
	
	self.allowdeath = true;	

}

getClosestEnt(org, array)
{
	if (array.size < 1)
		return;
		
//	dist = distance(array[0] getorigin(), org);
//	ent = array[0];
	dist = 99999999;
	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}



event2_napalm_flameouts()
{
	
	fx1 = getstruct("napalm_flameout1","targetname");
	//fx2 = getstruct("napalm_flameout2","targetname");
	
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin, anglestoforward(fx1.angles ) );
	wait 0.25;
	//playfx( level._effect[ "bunker_fire_out" ], fx2.origin, anglestoforward(fx1.angles ) );
	
	wait 1;
	playfx( level._effect[ "bunker_fire_out" ], fx1.origin, anglestoforward(fx1.angles ) );
	//playfx( level._effect[ "bunker_fire_out" ], fx2.origin, anglestoforward(fx1.angles ) );
}

// remove trigs so the squad doesnt roll back
event2_use_and_remove_first_line_color_trigs()
{
	red0 		= getent("event2_post_flamebunker","targetname");
	red0 		useby (get_players()[0]);
}



event3_player_stays_in_the_open_leftside()
{
	level endon ("bunker_crushed");
	
	level thread event3_branching_dialogue_kill_on_player_moveup();
	
	level.polo.animname = "polo";
	level.sarge.animname = "sarge";
	level.sullivan.animname = "sullivan";
	
	flank_string = "last_battle_flank_around";
	headon_string = "last_battle_use_rockets";
	flank_num = 1;
	headon_num = 1;
	
	num_flank_strings = 3;
	num_headon_strings = 3;

	host = get_players()[0];
	
	wait 5;
		
	while (!flag("flank_path_taken"))
	{	
		mgguys = get_ai_group_count("end_mgs");
		if (mgguys < 3)
		{
			break;
		}
		
		if (host.origin[0] > 2704) // right of truck
		{
			if (flank_num == 1 || flank_num == 2)
			{
				level.polo anim_single_solo(level.polo, flank_string + flank_num);
			}
			else
			{
				level.sarge anim_single_solo(level.sarge, flank_string + flank_num);
			}
			
			flank_num++;
			
			wait randomfloatrange(2.0, 3.25);
			
			// too many! reset and wait a spell
			if (flank_num > num_flank_strings)
			{
				flank_num = 1;
				wait 15;
			}
		}
		else	// left of truck
		{
			level.polo anim_single_solo(level.polo, headon_string + headon_num);

			headon_num++;
			
			wait randomfloatrange(2.0, 3.25);
			
			// too many! reset and wait a spell
			if (headon_num > num_headon_strings)
			{
				headon_num = 1;
				wait 15;
			}
		}
		wait 1;
	}	
}

event3_flank_right_flag_set()
{
	trigger_wait("right_flank_spawner_trig","targetname");
	flag_set("flank_path_taken");
}

event3_branching_dialogue_kill_on_player_moveup()
{
	level endon ("bunker_crushed");
	
	host = get_players()[0];
	
	while (1)
	{
		if (host.origin[1] > -4984)
		{
			level notify ("bunker_crushed");
		}
		wait 0.5;
	}
		
}

event3_suppressed_amtank()
{
	node = getvehiclenode("stop_suppressed","script_noteworthy");
	
	node waittill ("trigger", who);
	
	who setspeed (0, 1000);
	
	who thread amtank_firing_loop();
	
	level waittill ("mortar guys dead");
	flag_wait("end_tanks_dead");
	
	
	wait 1;
	who resumespeed (5);
}

amtank_firing_loop()
{
	level endon ("mortar guys dead");
	
	structs = getstructarray("suppressed_amtank_firepoints","targetname");

	while (isalive(self))
	{
		struct = structs[randomint(structs.size)];
		
		self setturrettargetvec(struct.origin);
		
		wait randomfloatrange(5, 8);
		
		self fireweapon();
	}
}

event3_tanks()
{
	level waittill ("spawnvehiclegroup23");
	
	wait 0.05;
	
	Objective_Add( 5, "current" );
	Objective_String( 5, &"PEL1_OBJECTIVE2F" );
			
	setsaveddvar("compassMaxRange", 100);
		
	thread event3_tank_checker();
			
			
	// adjust the repspawn timing for more ownage
	level.rocket_barrage_max_x = 7500;
	level.rocket_barrage_min_y = -6300;
	level.barrage_charge_time = 15; 
	
	tanks = getentarray("event3_tanks","targetname");
	
	truck = getent("event3_truck","targetname");
	truck.unload_group = "all";
	
	for (i = 0; i < tanks.size; i++)
	{
		tanks[i] thread end_tank_firing_positions();
		tanks[i] thread end_tank_death_watcher( i );
	}
	
	while (1)
	{
		tanks_dead = false;
		
		for (i = 0; i < tanks.size; i++)
		{
			if (isalive (tanks[i]))
			{
				tanks_dead = true;
			}
		}
		if (!tanks_dead)
		{
			break;
		}
		wait 0.1;
	}
	
	thread event3_remove_end_spawners();
	flag_set("end_tanks_dead");
	objective_state (5, "done");
		
}

// crazy fail safe stuff that we shouldn't need to do ever but for some reason causes
// progression breaks when you run through the level
event3_remove_end_spawners()
{
	spawners = getentarray("very_end_spawners","script_noteworthy");
	
	for (i = 0; i < spawners.size; i++)
	{
		if ( !spawners[i] isSpawner() )
		{
			continue;
		}
		
		spawners[i] delete();
		
	}
}


end_tank_death_watcher( num )
{
/*	while (isalive(self))
	{
		Objective_AdditionalPosition( 5, num, self.origin );
		wait 0.1;
	}*/

	Objective_AdditionalPosition( 5, num, self );	// Pass in entity, don't animate based on ent position.
			
	self waittill ("death");
	
	Objective_AdditionalPosition( 5, num, (0,0,0) );
		
	level notify ("end tank died");
}

end_tank_firing_positions()
{	
	self endon ("death");
	
	structs = getstructarray("end_tank_firing_positions","targetname");

	while (isalive(self))
	{
		struct = structs[randomint(structs.size)];
		
		self setturrettargetvec(struct.origin);
		
		wait randomfloatrange(5, 8);
		
		self fireweapon();
	}
}

//////////////////////////////////////////////////////////////////
///////////////////// UTILITY FUNCTIONS //////////////////////////
//////////////////////////////////////////////////////////////////

// Grab starting AI, probably heros
grab_starting_guys()
{
	return getentarray("starting_allies","targetname");
}

// Grab the points to warp the starting AI to
grab_start_points(startpoint, ai_or_player)
{
	starts = undefined;

	if (ai_or_player == "ai")
	{
		if (startpoint == "beach")
		{
			starts = getstructarray("start_beach_ai","targetname");		
		}
		else if (startpoint == "1st_fight")
		{
			starts = getstructarray("start_1st_fight_ai","targetname");		
		}
		else if (startpoint == "2nd_fight_l")
		{
			starts = getstructarray("start_2nd_fight_l_ai","targetname");		
		}
		else if (startpoint == "3rd_fight")
		{
			starts = getstructarray("start_3rd_fight_ai","targetname");		
		}
		else if (startpoint == "mortars")
		{
			starts = getstructarray("start_mortar_ai","targetname");		
		}
	}
	else if (ai_or_player == "players")
	{
		if (startpoint == "beach")
		{
			starts = getstructarray("beach_start_points","targetname");		
		}
		else if (startpoint == "1st_fight")
		{
			starts = getstructarray("1st_fight_start_points","targetname");		
		}
		else if (startpoint == "2nd_fight_l")
		{
			starts = getstructarray("2nd_fight_l_start_points","targetname");		
		}
		else if (startpoint == "3rd_fight")
		{
			starts = getstructarray("3rd_fight_start_points","targetname");		
		}
		else if (startpoint == "mortars")
		{
			starts = getstructarray("mortar_start_points","targetname");		
		}
	}
	
	return starts;
}

// warp the starting ai to the start points
warp_starting_guys(startpoint)
{
	guys = grab_starting_guys();
	starts = grab_start_points(startpoint, "ai");
	
	if (!isdefined(starts) || !isdefined(guys))
	{
		return;
	}
	
	for (i = 0; i < guys.size; i++)
	{
		guys[i] teleport (starts[i].origin, starts[i].angles);
	}
}

// warp the starting ai to the start points
warp_players(startpoint)
{
	//thread hide_players();
	
	starts = grab_start_points(startpoint, "players");
		
	// grab all players
	players = get_players();

	// set up each player, make sure there are four points to start from
	for (i = 0; i < players.size; i++)
	{
		players[i] setOrigin( starts[i].origin );
		players[i] setPlayerAngles( starts[i].angles );
	}
}

// use this on an array of friendlies to set them to follow the player
set_friendlies_on_chain()
{
	for (i = 0; i < self.size; i++)
	{
		self[i] setgoalentity (get_players()[0]);
	}	
}

// disables all friendly ai color 
disable_ai_color_allies()
{
	ai = getaiarray("allies");
	
	for (i = 0; i < ai.size; i++)
	{
		ai[i] disable_ai_color();
	}
}

// enables all friendly ai colors
enable_ai_color_allies()
{
	ai = getaiarray("allies");
	
	for (i = 0; i < ai.size; i++)
	{
		ai[i] enable_ai_color();
	}
}

// hide players so AI to teleport, doesnt work atm
hide_players()
{
	// grab all players
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
//		org = spawn ("script_origin", players[i].origin);
//		players[i].start_org = org;
		players[i] setorigin((3182, -3877, -164));
	}
	level waittill ("ai teleported");

//	players = get_players();
//	for (i = 0; i < players.size; i++)
//	{
//		players[i] setorigin (players[i].start_org.origin);
//		players[i].start_org delete();
//	}
}

// The objecive setting function for pel1
set_objective(num, ent)
{
	startplace = getdvar("start");
	 	
	// assault beach
	if( num == 0 )
	{
		objective_add( 0, "active", &"PEL1_OBJECTIVE1", ( 3152, -7624, -256 ) );
		objective_current( 0 );
	}
	// call in strike
	else if( num == 0.1 )
	{
		objective_string( 0, &"PEL1_OBJECTIVE1A"  );
		objective_position( 0, ( 2036, -10207, -295.9 ) );
		objective_current( 0 );
	}
	// wait for flamethrower
	else if( num == 0.3 )
	{
		level.sarge notify ("stop objective on entity");
		objective_string( 0, &"PEL1_OBJECTIVE2"  );
		objective_position( 0, ( 2066, -8670, -324.4 ) );
		//thread objective_on_entity(0, level.sarge);
		//objective_onentity(0, level.sarge);
		objective_current( 0 );
	}
	// push through japanese defensive lines
	else if( num == 1 )
	{
		level waittill ("rockets done");
			
		// grab the first trig
		trig = getent("bread_crumber_begin","targetname");
		
		// clear the old one, set up the new one	
		objective_state (0, "done");
		wait_network_frame();
		objective_add( 1, "active", &"PEL1_OBJECTIVE2A", ( trig.origin ) );
		objective_current( 1 );	
		
		// loop until we're out of trigs
		while (1)
		{
			trig waittill ("trigger");
			
			if (!isdefined (trig.target))
			{
				break;
			}
			
			trig = getent(trig.target,"targetname"); 
		
			objective_position( 1, ( trig.origin ) );	
		}
		wait_network_frame();
		thread set_objective(2);
	}
	else if (num == 2)
	{
		// gain entrance to japanese stronghold
		objective_state (1, "done");
		wait_network_frame();
		objective_add( 2, "current", &"PEL1_OBJECTIVE2B", ( 2897, -3763, -214 ) );				
		//objective_current( 2 );	

		// clear japanese stronghold
		getent("obj_entrance_gained","targetname") waittill ("trigger");
		objective_state (2, "done");
		wait_network_frame();
		objective_add( 3, "current", &"PEL1_OBJECTIVE2C", ( 2838.3, -3879.7, -47.9 ) );
		wait_network_frame();
		//objective_current( 3 );	
		thread event3_stronghold_checker();
		

		// regroup
		flag_wait("mortars_cleared");
		flag_wait("stronghold_cleared");
		flag_wait("end_tanks_dead");
					
		objective_add( 6, "active", &"PEL1_OBJECTIVE2D", ( 2832, -3416, -40 ) );
		objective_current( 6 );	
		setsaveddvar("compassMaxRange", 800);
				
	}
	
	wait_network_frame();
}

event3_tank_checker()
{
	level waittill ("end tank died");
	objective_string(5, &"PEL1_OBJECTIVE2G");

	level waittill ("end tank died");	
	objective_string(5, &"PEL1_OBJECTIVE2H");
}

event3_stronghold_checker()
{
	waittill_aigroupcount("end_mgs", 0);

	flag_set("stronghold_cleared");
	objective_state (3, "done");
}

event3_mortar_checker()
{
	trigger_wait("mortar_crew_spawn1","script_noteworthy");

	// take out mortar crews
	objective_add( 4, "current", &"PEL1_OBJECTIVE2E", ( 4022, -3950, -165.1 ) );
	//objective_current( 4 );	

//	Objective_AdditionalPosition( 5, 10, (4022, -3950, -165.1) );
		
	waittill_aigroupcount("mortar_squads", 0);
	
//	Objective_AdditionalPosition( 5, 10, (0,0,0) );
	
	flag_set("mortars_cleared");	
	objective_state (4, "done");
}


// Grab starting AI, probably heros
grab_friendlies()
{
	return getaiarray("allies");
}

cleanup_enemies()
{
	ai = getaiarray("axis");
	for (i = 0; i < ai.size; i++)
	{
		if (isalive(ai[i]))
		{
			ai[i] dodamage(ai[i].health + 5, (0,0,0));
		}
	}
}

objective_on_entity(obj_num, ent)
{
	ent endon ("stop objective on entity");
	
	while(1)
	{
		objective_position(obj_num, ent.origin);
		wait (0.1);
	}
}

// until we get the proper way to do this
threat_group_setter()
{
	while (1)
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{
			players[i] setthreatbiasgroup("players");
		}
		wait (2);
	}
}

//////////////////////////////////////////////////////////////////
///////////////////// START FUNCTIONS ////////////////////////////
//////////////////////////////////////////////////////////////////

start_beach()
{
	VisionSetNaked("pel1",3);	
		
	thread hide_players();
	
	wait 0.5;
		
	warp_starting_guys ("beach");
	
	starts = getstructarray("beach_start_points","targetname");
	
	level notify ("ai teleported");
		
	thread warp_players("beach");

	//getent("beach_mgs_trig","script_noteworthy") useby (get_players()[0]);
	
	// guys goto color nodes on beach
	getent("event1_offlvt_moveup", "targetname") useby (get_players()[0]);
		
	thread event2_setup();
	thread event1_squibline();
	thread event1_floating_bodies();
	thread enable_player_weapons();
	thread delete_trees_and_bushes();	
	thread event1_small_bunker_rocket_damage_think();
	thread event1_crawling_guys();
			
	// hack: remove this trigger, causing drone issues
	getent("auto5686","target") delete();
	
	level thread event1_pillar_cover_guys();
	level thread event1_small_bunker_rocket_damage_think();
		
	getent("radio_squad_spawner","targetname") useby (get_players()[0]);
	
	wait 0.1;
	
	ai = get_ai_group_ai("coral_radio_guys");
			
	for (i = 0; i < ai.size; i++)
	{
		if (isdefined (ai[i].script_forcecolor) && ai[i].script_forcecolor == "y")
		{
			level.radioguy = ai[i];
			level.radioguy.animname = "radioguy";
			level.radioguy thread magic_bullet_shield();
			level.radioguy enable_ai_color();
			level.radioguy set_battlechatter( false );
		}
		else
		{
			ai[i] delete();
		}
	}
	level.rocket_barrage_allowed = true;
		
	level.rocket_barrage_first_barrage = false;		
}

start_off_lvt()
{
	VisionSetNaked("pel1",3);	
	getent("spawn_arty","targetname") useby (get_players()[0]);
			
	thread hide_players();
	level.rocket_barrage_allowed = true;
		
	wait 0.5;
		
//	warp_starting_guys ("beach");
//	
//	starts = getstructarray("beach_start_points","targetname");
//	
//	level notify ("ai teleported");
//		
//	thread warp_players("beach");

	//getent("beach_mgs_trig","script_noteworthy") useby (get_players()[0]);
	
	// guys goto color nodes on beach
//	getent("event1_offlvt_moveup", "targetname") useby (get_players()[0]);
		
	thread event2_setup();
	thread event2_main_rocket_attack();
	thread event1_squibline();
	thread event1_floating_bodies();
	thread event1_rocket_hints();
	thread event1_mortars();
	thread event1_crawling_guys();
	
	
	// set up the arty pieces
	thread event1_model3_fire( 1 );
	getent("start_models3s","targetname") notify ("trigger");
	
	thread enable_player_weapons();
	level thread event1_pillar_cover_guys();
	
	getent("radio_squad_spawner","targetname") useby (get_players()[0]);
	
	wait 0.1;
	
	ai = get_ai_group_ai("coral_radio_guys");
			
	for (i = 0; i < ai.size; i++)
	{
		if (isdefined (ai[i].script_forcecolor) && ai[i].script_forcecolor == "y")
		{
			level.radioguy = ai[i];
			level.radioguy.animname = "radioguy";
			level.radioguy thread magic_bullet_shield();
			level.radioguy enable_ai_color();
			level.radioguy set_battlechatter( false );
		}
		else
		{
			ai[i] delete();
		}
	}
	

	level.rocket_barrage_first_barrage = true;
	
	lvtnode = getvehiclenode("auto4778","targetname");

	level.players_lvt = spawnvehicle( "vehicle_usa_tracked_lvt4", "player_lvt", "buffalo", lvtnode.origin, lvtnode.angles + (0,90,0));		
	
	thread hide_players();
	event1_put_ai_on_lvt_short();
			
	//thread event1_put_players_on_lvt();
	thread event1_small_bunker_rocket_damage_think();


	
	wait 5;
	level clientnotify ("ab");	// aaa_begin
	level clientnotify ("sfl");	// ship_fire_left
	level clientnotify ("sfr");	// ship_fire_right
			
	level notify ("aaa_begin");
	
	println("*** Server : Sent notify to start fakefire");	
	thread event1_get_ai_off_of_lvt();	
	thread event1_explode_and_fade_to_white();
	
}



start_first_fight()
{
	VisionSetNaked("pel1",3);	
		
	thread hide_players();
	level.rocket_barrage_allowed = true;
	
	wait 0.5;
		
	warp_starting_guys ("1st_fight");
	
	starts = getstructarray("1st_fight_start_points","targetname");
	
	level notify ("ai teleported");
		
	thread warp_players("1st_fight");
		
	thread event2_trap_door_watcher();
	//thread event2_bunker_explode_think();
	// guys dont use chain here, use colors, two squads, green and red on left / right.
//	for(i = 0; i < level.heroes.size; i++)
//	{
//		level.heroes[i] enable_ai_color();
//	}
	
	// use the _colors triggers on the left and right
	thread start_event2_colorsetup();
	thread enable_player_weapons();
	thread event2_grenade_death_guy();
	//thread event2_bayonett_vignette();
	thread event2_fire_walkers();
	
	thread event2_treeguy_dialogue();
	thread event2_grass_guy_dialogue();
	thread delete_trees_and_bushes();	
	thread event3_setup();
	thread event2_left_amtank_setup();
	
	// hack: remove this trigger, causing drone issues
	getent("auto5686","target") delete();
					
	//thread event2_friendly_moveup_on_enemy_death();
	
	level.otherPlayersSpectate = false;
	level.otherPlayersSpectateClient = undefined;
			
	getent("radio_squad_spawner","targetname") useby (get_players()[0]);
	
	wait 0.1;
	
	ai = get_ai_group_ai("coral_radio_guys");
			
	for (i = 0; i < ai.size; i++)
	{
		if (isdefined (ai[i].script_forcecolor) && ai[i].script_forcecolor == "y")
		{
			level.radioguy = ai[i];
			level.radioguy.animname = "radioguy";
			level.radioguy thread magic_bullet_shield();
			level.radioguy enable_ai_color();
			level.radioguy set_battlechatter( false );
		}
		else
		{
			ai[i] delete();
		}
	}
	
	level.rocket_barrage_first_barrage = false;
	
	//thread event2_first_fight_dialogue();
	flag_set("past_flame_mg");
}

start_second_fight_left()
{
	VisionSetNaked("pel1",3);	
		
	thread hide_players();
	level.rocket_barrage_allowed = true;
		
	wait 0.5;
		
	warp_starting_guys ("2nd_fight_l");
	
	starts = getstructarray("2nd_fight_l_start_points","targetname");
	
	level notify ("ai teleported");
		
	thread warp_players("2nd_fight_l");
		
	thread event2_trap_door_watcher();
	//thread event2_bunker_explode_think();
	wait (1);
		
	// guys dont use chain here, use colors, two squads, green and red on left / right.
	for(i = 0; i < level.heroes.size; i++)
	{
		level.heroes[i] enable_ai_color();
	}
	
	// use the _colors triggers on the left and right
	thread start_event2_colorsetup();
	thread enable_player_weapons();
	
	thread event3_setup();
		
	thread delete_trees_and_bushes();	
		
	thread event2_grenade_death_guy();
	
	level.rocket_barrage_first_barrage = false;
		
}

start_third_fight()
{
	VisionSetNaked("pel1",3);	
		
	thread hide_players();
	level.rocket_barrage_allowed = true;
		
	wait 0.5;
		
	warp_starting_guys ("3rd_fight");
	
	starts = getstructarray("3rd_fight_start_points","targetname");
	
	level notify ("ai teleported");
		
	thread warp_players("3rd_fight");
		
	thread event2_trap_door_watcher();
	
	wait (1);
		
	// guys dont use chain here, use colors, two squads, green and red on left / right.
	for(i = 0; i < level.heroes.size; i++)
	{
		level.heroes[i] enable_ai_color();
	}
	
	// use the _colors triggers on the left and right
	//thread start_event2_colorsetup();
	thread enable_player_weapons();
	
	thread delete_trees_and_bushes();	
			
	thread event3_setup();
		
	thread event2_grenade_death_guy();
	
	level.rocket_barrage_first_barrage = false;
}


start_mortars()
{
	VisionSetNaked("pel1",3);	
		
	thread hide_players();
	level.rocket_barrage_allowed = true;
		
	wait 0.1;
		
	warp_starting_guys ("mortars");
	
	starts = getstructarray("mortars_start_points","targetname");
	
	wait 0.1;
	
	level notify ("ai teleported");
		
	thread warp_players("mortars");
		
	thread event2_trap_door_watcher();

	thread event2_grenade_death_guy();
		
	thread set_objective(2);
	
	wait (1);
		
	// guys dont use chain here, use colors, two squads, green and red on left / right.
	for(i = 0; i < level.heroes.size; i++)
	{
		level.heroes[i] enable_ai_color();
	}
	
	// use the _colors triggers on the left and right
	thread start_event2_colorsetup();
	thread enable_player_weapons();
	thread event3_suppressed_amtank();
	thread event3_tanks();
	thread event3_mortar_checker();
		
	thread event3_upstairs_dialogue();
		
	level.rocket_barrage_first_barrage = false;
}

start_ending()
{
	VisionSetNaked("pel1",3);	
		
	thread hide_players();
	level.rocket_barrage_allowed = true;
		
	wait 0.1;
		
	warp_starting_guys ("mortars");
	
	starts = getstructarray("mortars_start_points","targetname");
	
	wait 0.1;
	
	level notify ("ai teleported");
		
	thread warp_players("mortars");
		
	thread event2_trap_door_watcher();
	thread enable_player_weapons();
		
	wait 3;
	level notify ("mortar guys dead");
	flag_set("end_tanks_dead");
	
}

start_event2_colorsetup()
{
	wait (1);
	// guys dont use chain here, use colors, two squads, green and red on left / right.
	for(i = 0; i < level.heroes.size; i++)
	{
		level.heroes[i] enable_ai_color();
	}
	
	// use the _colors triggers on the left and right
	thread event2_use_and_remove_first_line_color_trigs();
}

enable_player_weapons()
{
	level.enable_weapons = 1;
		
	players = get_players();
	
	for (i = 0; i < players.size; i++)
	{
		players[i] enableweapons();
	}
}

invincible_turret_setup( maxrange, fireondrones )
{				
	self endon ("death");
		
	self setmode( "auto_nonai" );
	self setTurretTeam( "axis" );
	
	//self.accuracy  = 0.01;
	
	//self thread always_fire(fireondrones);
			
	self thread maps\_mgturret::burst_fire_unmanned();
	self maketurretunusable();
		
	level thread maps\_mgturret::mg42_setdifficulty( self, getdifficulty() );
		
	if( isdefined( fireondrones ) )
	{
		self.script_fireondrones = fireondrones; 
		self thread maps\_mgturret::mg42_target_drones( undefined, "axis" );
	}
	
	self setshadowhint( "never" );
	
	if( isdefined( maxrange ) )
		self.maxrange = maxrange; 
	
}

always_fire(fireondrones)
{
	self endon ("death");
	
	squibs = [];
	if( !isdefined( fireondrones ) || fireondrones == 0)
	{
		squibs = getstructarray("squibline_flame_bunker","targetname");
	}
	
	while (1)
	{
		level endon ("battle_on");
		burstsize = randomintrange (8, 20);
		
		if (isdefined(squibs) && squibs.size > 0)
		{
			squib = squibs[randomint(squibs.size)];
			squib thread event1_squibline_think_burst();
		}
			
		for (i = 0; i < burstsize; i++)
		{
			self shootturret(); 
			self.isfiring = true;			
			wait (0.1);
		}
		
		if (isdefined (self.deathzoneactive) && self.deathzoneactive)
		{
			continue;
		}
		else
		{
			self.isfiring = false;
			wait (randomfloatrange (0.5, 2));
		}
	}
}



delete_on_trigger()
{
	self waittill ("trigger");
	
	if (isdefined(self))
	{
		self delete();
	}
}


/// LVT SPECIAL TIME!
event1_setup_lvts_with_drones()
{
	//wait (0.2);	
	
	// wave 1	
	lvt  = getent("wave1_lvts1","targetname");
	lvt thread lvt_stop_and_unload();
	
	lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
		
	lvt  = getent("wave1_lvts2","targetname");
	lvt thread lvt_stop_and_unload();
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
		
	lvt  = getent("wave1_lvts3","targetname");
	lvt thread lvt_stop_and_unload(1);
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
	
	lvt  = getent("wave1_lvts4","targetname");
	lvt thread lvt_stop_and_unload();
	lvt thread lvt_float_loop();
	
	lvt  = getent("wave1_lvts5","targetname");
	lvt thread lvt_stop_and_unload();
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
	
	lvt  = getent("wave1_lvts6","targetname");
	lvt thread lvt_stop_and_unload();
	lvt thread lvt_float_loop();
	
	// wave 2
	lvt  = getent("wave2_lvts1","targetname");
	lvt thread lvt_stop_and_unload();
	lvt thread lvt_float_loop();
		
	lvt  = getent("wave2_lvts2","targetname");
	lvt thread lvt_stop_and_unload();
	lvt thread lvt_float_loop();
	
	lvt  = getent("wave2_lvts3","targetname");
	lvt thread lvt_stop_and_unload();
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
	
	lvt  = getent("wave2_lvts5","targetname");
	lvt thread lvt_stop_and_unload();
	lvt thread lvt_float_loop();
	
	lvt  = getent("wave2_lvts6","targetname");
	lvt thread lvt_stop_and_unload();
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
	
	// wave 3
	lvt  = getent("wave3_lvts1","targetname");
	lvt thread lvt_stop_and_unload();
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
			
	lvt  = getent("wave3_lvts2","targetname");
	lvt thread lvt_stop_and_unload();
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
			
	// contains jeep
	lvt  = getent("wave3_lvts3","targetname");
	lvt thread event1_lvt_jeep_rollout();
	lvt thread lvt_float_loop();
		
	lvt  = getent("wave3_lvts4","targetname");
	lvt thread lvt_stop_and_unload();
		lvt thread populate_lvt_with_heads_and_shoulders();
	lvt thread lvt_float_loop();
			
	lvt  = getent("wave1_amtank1","targetname");	
	lvt thread event1_amtank1_think();
	
	lvt  = getent("wave1_amtank2","targetname");	
	lvt thread event1_amtank2_think();
	
	lvt  = getent("wave1_amtank3","targetname");	
	lvt thread event1_amtank3_think();	
}



remove_fake_shoulders()
{
	self waittill_either("fake_death", "death");
	self.fake_shoulders delete ();
}

populate_lvt_with_drones(num_guys)
{
	for (i = 0; i < num_guys; i++)
	{			
			// returns all the data setup in set_anims for the vehicle
			animpos = maps\_vehicle_aianim::anim_pos( self, i );
			
			self.drone_riders[i] = spawn_fake_guy_lvt(self gettagorigin(animpos.sittag), self gettagangles(animpos.sittag), 1, "drone_riders", undefined, 1);
			self.drone_riders[i] linkto (self, animpos.sittag);
			self.drone_riders[i].position = i;
			
			self.drone_riders[i].target = self.targetname + "_drone_unload" + (i + 1);
			self.drone_riders[i] maps\_drones::build_struct_targeted_origins();
			
			self thread drone_on_lvt_think(self.drone_riders[i]);

	}	
	self thread drone_lvt_death_think();
			
}

drone_lvt_death_think()
{
	self waittill_either("fake_death", "death");
	
	for (i = 0; i < self.drone_riders.size; I++)
	{
			self.drone_riders[i] notify ("death");
			//Self.drone_riders[i] notify ("drone_death");
			//self.drone_riders[i] notify ("delete");			
			self.drone_riders[i] thread maps\_drones::drone_delete();
	}

}

drone_on_lvt_think(guy)
{
	self endon ("drone_unload");
	self endon ("death");	
	
	animpos = maps\_vehicle_aianim::anim_pos( self, guy.position );
				
	while (1)
	{
		guy animscripted("lvt_ride_idle", self gettagorigin(animpos.sittag), self gettagangles(animpos.sittag) + (0,180,0), animpos.idle);
		guy waittillmatch("lvt_ride_idle","end");
	}
}

unload_lvt_think()
{
		self endon ("death");
		
		self waittill ("drone_unload");
		
		for (i = 0; i < self.drone_riders.size; i++)
		{
			animpos = maps\_vehicle_aianim::anim_pos( self, self.drone_riders[i].position );
					
			self.drone_riders[i] stopanimscripted();
			self.drone_riders[i] unlink();
			self.drone_riders[i] animscripted("lvt_ride_exit", self gettagorigin(animpos.sittag), self gettagangles(animpos.sittag), animpos.getout);	
			//println ("drone angles: " + self.drone_riders[i].angles + " tag angles: " + self gettagangles(animpos.sittag));
			self.drone_riders[i] thread drone_unload_think();
		}
}

drone_unload_think()
{
		self endon ("death");
		self endon ("drone_death");			
		
		self waittillmatch("lvt_ride_exit","end");
		
		//fake death if this drone is told to do so
		if ( (isdefined(self.fakeDeath)) && (self.fakeDeath == true) && isdefined(self))
		{
			self thread maps\_drones::drone_fakeDeath();	
		}
		
		if (isdefined(self))
		{
			self thread maps\_drones::drone_runChain(self);
		}
}


spawn_fake_guy_lvt(startpoint, startangles, us, animname, name, is_lvt_drone, assign_weapon, no_pack)
{
	guy = spawn("script_model", startpoint);
	guy.angles = startangles;
	
	if (isdefined(no_pack) && no_pack)
	{
		guy character\char_usa_marine_r_nb_rifle:: main();
	}
	else if (us)
	{
		guy character\char_usa_marine_r_rifle::main();
	}
	else
	{
		guy character\char_jap_makpel_rifle::main();		
	}
	
	guy UseAnimTree(#animtree);
	guy.a = spawnstruct();
	guy.animname = animname;
	
	if (!isdefined(name))
	{
		guy.targetname = "drone";
	}
	else
	{
		guy.targetname = name;
	}

	if (isdefined(assign_weapon) && assign_weapon == 1)
	{
			guy maps\_drones::drone_assign_weapon("allies");
	}
	
	if (isdefined(is_lvt_drone) && is_lvt_drone == 1)
	{
		// from _drones
		guy maps\_drones::drone_assign_weapon("allies");
		guy.targetname = "drone";
		guy makeFakeAI();
		guy.team = "allies";
		guy.fakeDeath = true;
		guy.health = 1000000;
		guy.fakeDeath = true;
		guy.drone_run_cycle = level.drone_run_cycle["run_fast"];
		guy thread maps\_drones::drone_setName();
		guy thread maps\_drones::drones_clear_variables();
		structarray_add(level.drones[guy.team],guy);
		level notify ("new_drone");
	}
	
	return guy;
}


throw_object_with_gravity( object, target_pos )
{
	 //object endon ("remove thrown object");
   start_pos = object.origin; // Get the start position

   ///////// Math Section
   // Reverse the gravity so it's negative, you could change the gravity
// by just putting a number in there, but if you keep the dvar, then the
// user will see it change.
   gravity = GetDvarInt( "g_gravity" ) * -1;
   
   // Get the distance
   dist = Distance( start_pos, target_pos );

   // Figure out the time depending on how fast we are going to
// throw the object... 300 changes the "strength" of the velocity.
// 300 seems to be pretty good. To make it more lofty, lower the number.
// To make it more of a b-line throw, increase the number.
   time = dist / 2000;

   // Get the delta between the 2 points.
   delta = target_pos - start_pos;

   // Here's the math I stole from the grenade code. :) First figure out
// the drop we're going to need using gravity and time squared.
   drop = 0.5 * gravity * ( time * time );

   // Now figure out the trajectory to throw the object at in order to
// hit our map, taking drop and time into account.
   velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
   ///////// End Math Section

   object MoveGravity( velocity, time );  
   
   // SCRIPTER_MOD: JesseS (10/2/2007):  arbitrary pitch, seems to work best here
   object rotatepitch(100, time);  
   
   object waittill("movedone");
   object.origin = target_pos;
   
   wait 2;
   if (isdefined(object))
   {
			object delete();	
   }
 
}



// anything using vehicle.atr goes below here
#using_animtree ("vehicles");
lvt_stop_and_unload(no_ramp_drop)
{
	self endon ("death");
	
	self waittill ("unload");
	
	self setspeed (0, 10);
	
	
	self notify ("stop float loop");
	self clearanim(%v_lvt4_float_loop, 0);
		
	wait 2;
	if (!isdefined(no_ramp_drop))
	{
		self setflaggedanim( "drop_gate", %v_lvt4_open_ramp, 1, 0 );
		self notify ("drone_unload");
	}
	
	wait 8;
	self clearanim(%v_lvt4_open_ramp, 0);
	self setflaggedanim( "open_gate", %v_lvt4_ramp_close, 1, 0 );
	//wait 2;
	//self resumespeed (1);
	
	//wait (10);

}

event1_stuck_lvt_anim()
{
	self setflaggedanim( "lvt_stuck", %v_lvt4_stuck, 1, 0 );
}

event1_lvt_jeep_rollout()
{
	self.attached_jeep = getent("explodey_jeep","targetname");
	self.attached_jeep.angles = self.angles + (0,0,0);
	self.attached_jeep.origin = self.origin;
	self.attached_jeep UseAnimTree(#animtree);
	self.attached_jeep linkto	(self, "tag_origin" ,(-65,0,38), (0,180,0));
	
	colide = getent("jeep_colision","targetname");
	colide.origin = self.attached_jeep.origin;
	colide.angles = self.attached_jeep.angles + (0,90,0);
	colide linkto	(self.attached_jeep, "tag_origin");
	
		
	getvehiclenode ("jeep_rollout","script_noteworthy") waittill ("trigger",who);
	who setspeed (0, 25);
	
	who clearanim(%v_lvt4_float_loop, 0);
	
	getent("event1_jeep_blowup_trig","targetname") waittill ("trigger");

	self.attached_jeep animscripted( "jeep_unload", self.attached_jeep.origin, self.attached_jeep.angles, %v_willys_peleliu1_jeep_destroyed );	
	self.attached_jeep unlink();
	
	self thread event1_lvt_jeep_driver_dies();
	
	// arbitrary!
	wait 1.7;
	self notify ("stop float loop");	
	self clearanim(%v_lvt4_float_loop, 0);		
	self setflaggedanim( "lvt_stuck", %v_lvt4_peleliu1_jeep_destroyed, 1, 0 );	
	wait 0.4;


	playfxontag(level._effect["jeep_explode"], self.attached_jeep, "tag_origin");
	self.attached_jeep playsound("vehicle_explo");
	
	
	self thread lvt_fake_death(0);
	
	self clearanim(%v_lvt4_peleliu1_jeep_destroyed, 0);
	self setflaggedanim( "fast_open_ramp", %v_lvt4_ramp_open, 1, 0 );	
	
	level waittill ("remove floaters");
	
	self delete();
	colide delete();
	self.attached_jeep delete();
	self.attached_jeep.attached_guy delete();
	
}

event1_lst_door_open()
{
	// 16 seconds form the start of the anim syncs up well
	wait 11;	// time until door opens
	
	lst = getent("player_lst","targetname");
	lst UseAnimTree(#animtree);
	lst animscripted( "lst_door_open", lst.origin, lst.angles, %v_lst_open_doors );	
	
	lst thread lst_door_sound_on_done();
	
	level notify ("lst door opening");
	
	lst thread lst_door_fx();
	
	wait 5;		// time until lvt takes off
	
	level notify ("lst doors opened");
	
}

lst_door_sound_on_done()
{
	self waittillmatch("lst_door_open", "end");
	door = getent("lst_door_open_sound", "targetname");
	
	door playsound("door_stop");
}

lst_door_fx()
{
	//self waittill ("lst_door_open");
	wait 5;
	doorfxpoint = getstruct ("lst_door_fx","targetname");
	
	playfx(level._effect["door_splash"], doorfxpoint.origin, anglestoforward(doorfxpoint.angles));
	level notify ("lst door splash");
	//wait 1.25;
	
	trigger_wait("lvt_splash_trig","targetname");
	playfxontag(level._effect["exit_splash"], level.players_lvt, "tag_wake" );
	level notify("lvt_splash");
	
	thread rumble_all_players("damage_heavy");
	
	
	thread do_water_drops_on_camera_for_time( 5 );
	thread do_water_sheeting_on_camera();
		
	thread get_all_allies_wet_in_lvt();
	
	// wake sounds
	level.players_lvt.front_sounds playloopsound("lvt_wake");
	level.players_lvt.rear_sounds playloopsound("lvt_engines");
	
}

get_all_allies_wet_in_lvt()
{
	ai = getaiarray("allieS");
	
	for (i = 0; i < ai.size; i++)
	{
		ai[i] thread wetness_on_ai(1, 1);
	}	
}

////// CO-OP FUNCTIONS /////////
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	
		// put any calls here that you want to happen when the player connects to the game
		println("Player connected to game.");

		//maps\pel1_fx::fog_and_vision_settings(player);				
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println("Player disconnected from the game.");
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println("Player spawned in to game at " + self.origin);
		
		self thread maps\_dpad_asset::rocket_barrage_player_init();
	
		self setdepthoffield( 10, 35, 1000, 7000, 6, 1.5 );
		
		// disable weapons for intro rail
		if (!level.enable_weapons)
		{
			self disableweapons();
		}
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");

		// put any calls here that you want to happen when the player gets killed
		println("Player killed at " + self.origin);
		
	}
}	

lvt_fake_death(do_sink, do_exploding_guys)
{
	self setspeed (0, 5);
	self notify ("fake_death");
	
	playfxontag(level._effect["lvt_explode"], self, "tag_origin");		// fx
	self playsound("explo_metal_rand");																// sound
	self setmodel("vehicle_usa_tracked_lvt4_dest");										// model
	
	if (isdefined(do_exploding_guys))
	{
		self thread lvt_guys_exploding_out();
	}
		
	if (isdefined(do_sink) && do_sink)
	{
		self notify ("stop float loop");	
		self clearanim(%v_lvt4_float_loop, 0);	
		self setflaggedanim( "sinking", %v_lvt4_sinking );	// anim
		self waittill ("sinking");
		self notify( "nodeath_thread" );
		self notify("death");
		self delete();
	}
}




friendlies_crouch_only(on_off)
{
	ai = grab_friendlies();
	if (on_off)
	{
		for (i= 0; i < ai.size; i++)
		{
			if (isalive(ai[i]))
			{
				ai[i] allowedstances("crouch");
			}
		}
	}
	else
	{
		for (i= 0; i < ai.size; i++)
		{
			if (isalive(ai[i]))
			{
				ai[i] allowedstances("crouch", "stand", "prone");
			}
		}
	}
}

//////////////////////////////////////////////////
//////// Spawn Functions
//////////////////////////////////////////////////

spawn_function_init()
{
	level.animtimefudge = 0.05;
		
	grassguys1 = getEntArray("grass_guys1", "script_noteworthy");
	array_thread(grassguys1, ::add_spawn_function, ::event1_grass_guys1_init);

	grassguys2 = getEntArray("grass_guys2", "script_noteworthy");
	array_thread(grassguys2, ::add_spawn_function, ::event1_grass_guys2_init);	
	
	bayo_jap1 = getEntArray("bayo_jap1", "script_noteworthy");
	array_thread(bayo_jap1, ::add_spawn_function, ::event2_bayo_jap_init);	

	bayo_jap2 = getEntArray("bayo_jap2", "script_noteworthy");
	array_thread(bayo_jap2, ::add_spawn_function, ::event2_bayo_jap_init);	

	bayo_usguy = getEntArray("bayo_us1", "script_noteworthy");
	array_thread(bayo_usguy, ::add_spawn_function, ::event2_bayo_us_init);	
	
	retreaters = getEntArray("flame_bunker_retreaters", "script_noteworthy");
	array_thread(retreaters, ::add_spawn_function, ::event2_retreaters);	

	dazed_guys = getEntArray("auto5022", "targetname");
	array_thread(dazed_guys, ::add_spawn_function, ::event1_dazed_guys);		
	
	trench_banzai = getEntArray("trench_banzai_spawner1", "script_noteworthy");
	array_thread(trench_banzai, ::add_spawn_function, ::trench_banzai_guys);	
	
	dazed1 = getEntArray("dazed1", "script_noteworthy");
	array_thread(dazed1, ::add_spawn_function, ::dazed_guy_setup);	

	dazed2 = getEntArray("dazed2", "script_noteworthy");
	array_thread(dazed2, ::add_spawn_function, ::dazed_guy_setup);	
	
	dazed3 = getEntArray("dazed3", "script_noteworthy");
	array_thread(dazed3, ::add_spawn_function, ::dazed_guy_setup);	
	
	dazed4 = getEntArray("dazed4", "script_noteworthy");
	array_thread(dazed4, ::add_spawn_function, ::dazed_guy_setup);		
	
	
	loggers = getEntArray("ev1_log_guys", "script_noteworthy");
	array_thread(loggers, ::add_spawn_function, ::log_guy_setup);			
	
	stumpy = getEntArray("ev1_log_guys_stump", "script_noteworthy");
	array_thread(stumpy, ::add_spawn_function, ::stump_guy_setup);	

	seekers = getEntArray("ev1_seeker_after_goal", "script_noteworthy");
	array_thread(seekers, ::add_spawn_function, ::seeker_after_goal);		
	
	climb = getEntArray("climb", "script_noteworthy");
	array_thread(climb, ::add_spawn_function, ::tree_climber);	

	fallbacks = getEntArray("falling_back_guys", "script_noteworthy");
	array_thread(fallbacks, ::add_spawn_function, ::falling_back_guys);		
}

falling_back_guys()
{
	self endon ("death");
	
	self thread event1_water_depth_think();
	
	wait randomfloatrange(4, 10);
	self thread event1_underwater_squib_kill_ai();
	
	wait randomfloatrange(0.75, 1.5);
	self dodamage(self.health + 1, (0,0,0));
}

tree_climber()
{
	self endon ("death");
	self.ignoreme = true;
	
	self thread treeguy_deathwatch();
	
	wait 15;
	
	self.ignoreme = false;
}

treeguy_deathwatch()
{
	self waittill ("death");
	wait 1;
	// "Good shot, Miller."\
	level.sarge anim_single_solo (level.sarge, "tree_area5");
}

log_guy_setup()
{
	self endon ("death");
	
	self waittill ("goal");
	
	wait randomintrange(10,25);

	volumes = GetEntArray( "info_volume", "classname" ); 
	for( i = 0; i < volumes.size; i++ )
	{
		volume = volumes[i]; 
		
		if( IsDefined( volume.script_goalvolume ) && volume.script_goalvolume == 1)
		{
				self.goalradius = 1000; 
				self setgoalpos ((1629, -6898, -239));
				self setgoalvolume (volume);
		}
	}	
}

stump_guy_setup()
{
	self endon ("death");
	
	self waittill ("goal");
	
	wait randomintrange(10,25);

	volumes = GetEntArray( "info_volume", "classname" ); 	
	for( i = 0; i < volumes.size; i++ )
	{
		volume = volumes[i]; 
		
		if( IsDefined( volume.script_goalvolume ) && volume.script_goalvolume == 1)
		{
				self.goalradius = 1000; 
				self setgoalpos ((1629, -6898, -239));
				self setgoalvolume (volume);
		}
	}	
	
	wait randomintrange(6,12);
	
	self.goalradius = 64;
	
	//wait randomintrange (10, 20);
	self setgoalnode(getnode("daves_stump","script_noteworthy"));
	
	wait randomintrange (8, 15);
	
	self.goalradius = 230;
		
	self setgoalentity (get_closest_player(self.origin));
	
}

seeker_after_goal()
{
	self endon ("death");
	
	self waittill ("goal");
	
	wait randomintrange(12,20);
	
	self.goalradius = 256;
	self setgoalentity (get_closest_player(self.origin));
	
	wait randomintrange(8,16);
	
	self.goalradius = 128;
}

dazed_guy_setup()
{
	
	the_anim 		= undefined;
			

	if (self.script_noteworthy == "dazed1")
	{
		the_anim = level.scr_anim["dazedjap1"]["dazed"];
		self.animname = "dazedjap1";
		self.possibledeathanim = level.scr_anim["dazedjap1"]["dazed_death"];
	}
	else if (self.script_noteworthy == "dazed2")
	{
		the_anim = level.scr_anim["dazedjap2"]["dazed"];
		self.animname = "dazedjap2";
		self.possibledeathanim = level.scr_anim["dazedjap2"]["dazed_death"];
	}
	else if (self.script_noteworthy == "dazed3")
	{
		the_anim = level.scr_anim["dazedjap3"]["dazed"];
		self.animname = "dazedjap3";
		self.possibledeathanim = level.scr_anim["dazedjap3"]["dazed_death"];
	}
	else if (self.script_noteworthy == "dazed4")
	{
		the_anim = level.scr_anim["dazedjap4"]["dazed"];			
		self.animname = "dazedjap4";
		self.possibledeathanim = level.scr_anim["dazedjap4"]["dazed_death"];
	}
	
	self set_run_anim( "dazed" );		
	self.run_combatanim = the_anim;
	self.disableArrivals = true;	
	self.disableExits = true;	
	self set_ignoreall(1);
	self.health = 1;
	self.threatbias = 100000;
	self thread event2_dazed_die_over_time();
}



event2_retreaters()
{
	self.goalradius = 64;
	self.ignoreall = true;
	
	self waittill ("goal");
	
	self.goalradius = 1024;
	self.ignoreall = false;
}

event2_bayo_jap_init()
{
	self.allowdeath = true;
	self.ignoreall = true;
	self.animPlayBackRate = 1.2;
			
	self.animname = self.script_noteworthy;
}

event2_bayo_us_init()
{
	self.ignoreall = true;
	self.animPlayBackRate = 1.2;
		
	self.animname = self.script_noteworthy;
}

event1_grass_guys1_init()
{
	self endon( "death" );

	self grass_guys_init();
	
	flag_wait( "grass_attack1" );
	
	wait randomfloatrange(0.1, 0.5);	// make the guys not all get up at once

	// make him active again
	self grass_guys_awake();
	
	//TUEY Set Music State to BANZAI
	setmusicstate("BANZAI");

	self thread grass_camo_ignore_delay( randomfloatrange (2.0, 4.0) );
	
	// choose which variant anim to use
	prone_anim = choose_prone_to_run_anim_variant();
	level.animtimefudge = 0.05;
	
	self.animplaybackrate = 1.4;
	self play_anim_end_early( prone_anim, level.animtimefudge );		
	
	self.animplaybackrate = 1.0;
	self thread maps\_banzai::banzai_force();	
}



event1_grass_guys2_init()
{
	self endon( "death" );

	self grass_guys_init();
	
	flag_wait( "grass_attack2" );

	wait randomfloatrange(0.1, 0.5);	// make the guys not all get up at once

	// make him active again
	self grass_guys_awake();

	self thread grass_camo_ignore_delay( randomfloatrange (2.0, 4.0) );
	
	// choose which variant anim to use
	prone_anim = choose_prone_to_run_anim_variant();
	level.animtimefudge = 0.05;
	self play_anim_end_early( prone_anim, level.animtimefudge );		
	
	self thread maps\_banzai::banzai_force();		
}

trench_banzai_guys()
{
	self.banzai_no_wait = 1;	
	self thread maps\_banzai::banzai_force();	
}

event1_dazed_guys()
{
	wait 2;
	self.deathanim = self.possibledeathanim;	
	self thread die_if_ally_or_player_near();
}


grass_guys_init()
{
	self allowedstances ( "prone" );
	self disableaimassist();
	self.a.pose = "prone"; 
	self.allowdeath = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.ignoresuppression = 1;
	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;
	self.activatecrosshair = false;
	self.banzai_no_wait = 1;
	self.banzai_is_waiting = 1;
	self.animname = "grass_guy";
	
	self thread give_grass_guy_achivement();
}

give_grass_guy_achivement()
{
	self endon ("grassguy_awake");

	while( isdefined(self) )
	{
		self waittill( "damage", amount, attacker );
	 
		if( isplayer( attacker ) && isdefined(self))
		{		
			// if the amount is enough to kill the guy, give achievement
			if( amount >= self.health )
			{
				attacker giveachievement_wrapper( "ANY_ACHIEVEMENT_GRASSJAP" ); 	
				println("gave grass guy achivement");
			}			
		}	
	}	
}

grass_guys_awake()
{
	self.activatecrosshair = true;
	self enableaimassist();
	self.drawoncompass = true;
	self allowedstances( "stand" );
	self.a.pose = "stand"; 
	self.pacifist = 0;
	self.ignoreall = 0;
	self.grenadeawareness = 0.2;
	self.disableArrivals = false;
	self.disableExits = false;
	self notify ("grassguy_awake");
	self.banzai_is_waiting = 0;
		
	
	self thread maps\_banzai::start_banzai_announce();
	
}

grass_camo_ignore_delay( wait_time )
{
	self endon( "death" );

	wait( wait_time );
	self.ignoreme = 0;
}

//// Conserva's fix for prone-to-run banzai transition. should be added in _anim at some point?
//play_anim_end_early( the_anim, how_early )
//{
//	self animscripted( "anim single", self.origin, self.angles, the_anim  );			
//	animtime = getanimlength( the_anim  );
//	
//	animtime -= how_early;
//	wait(animtime);
//	 
//	self stopanimscripted();
//}


///////////////////
//
// choose which variant prone-to-run anim to use
//
///////////////////////////////

choose_prone_to_run_anim_variant()
{

	prone_anim = undefined;
	if( RandomInt( 2 ) )
	{
		prone_anim = level.scr_anim["grass_guy"]["prone_anim_fast"];	
	}
	else
	{
		prone_anim = level.scr_anim["grass_guy"]["prone_anim_fast_b"];
	}
	
	return prone_anim;
	
}

// MikeD steez
// Sets up the AI for force gibbing
set_random_gib()
{
	refs = [];
	refs[refs.size] = "right_arm"; 
	refs[refs.size] = "left_arm"; 
	refs[refs.size] = "right_leg"; 
	refs[refs.size] = "left_leg"; 
	refs[refs.size] = "no_legs"; 
	refs[refs.size] = "guts"; 

	self.a.gib_ref = get_random( refs );
}

get_random( array )
{
	return array[RandomInt( array.size )]; 
}

die_if_ally_or_player_near()
{
	self endon ("death");
	self endon ("damage");
	
	while (1)
	{
		guys = getaiarray ("allies");
		players = get_players();
		
		guys = array_combine(guys, players);
		
		
		for (i = 0; i < guys.size; i++)
		{
			if (distance (guys[i].origin, self.origin) < 150)
			{
				self dodamage(self.health + 1, self.origin + (0,0,randomintrange(16,64)));
			}
		}
		wait 0.3;
	}
}

pel1_ai_spawner(spawner_targetname)
{
	spawn = getent(spawner_targetname,"targetname") spawn_ai();

	if ( spawn_failed( spawn ) )
	{
		assertex( 0, "spawn failed from " + spawner_targetname );
		return;			
	}
	
	return spawn;
}

delete_trees_and_bushes()
{
	deleteme 	= getentarray ("run1_bushes","targetname");
	deleteme2 	= getentarray ("run1_trees","targetname");
	
	deleteme = array_combine(deleteme, deleteme2);
	
	for (i = 0; i < deleteme.size; i++)
	{
		deleteme[i] delete();
	}
	
}

lvt_float_loop()
{
	// make them not all start floating at the same time
	wait randomfloatrange(0.1, 5.0);
	
	self endon ("stop float loop");
	while (1)
	{
			self setflaggedanimrestart("float_loop", level.scr_anim["lvts"]["float_loop"], 1);
			self waittillmatch ("float_loop", "end");
	}
}

// from pel2 and makin
jog_internal()
{
	self endon( "death" );

	jogs_left = [];
	jogs_left[jogs_left.size] = "jog1";
	jogs_left[jogs_left.size] = "jog2";
	jogs_left[jogs_left.size] = "jog4";

	jogs_right = [];
	jogs_right[jogs_right.size] = "jog1";
	jogs_right[jogs_right.size] = "jog2";
	jogs_right[jogs_right.size] = "jog3";
	
	jogs_forward = [];
	jogs_forward[jogs_forward.size] = "jog1";
	jogs_forward[jogs_forward.size] = "jog2";

	self.run_dont_jog = false;

	jogging = false;
	while( flag( "jog_enabled" ) )
	{
	
		jogging = true;

		if( !self.run_dont_jog && self.origin[1] > -10350 )	// do this once they've crossed the berm
		{
			
			if( self.origin[0] < 1930 )
			{
				jog = jogs_left[RandomInt(jogs_left.size)];
			}
			else if( self.origin[0] > 2110 )
			{
				jog = jogs_right[RandomInt(jogs_right.size)];		
			}
			else
			{
				jog = jogs_forward[RandomInt(jogs_forward.size)];
			}
			
			self.moveplaybackrate = 0.8;
			self set_generic_run_anim( jog );
			delay = GetAnimLength( level.scr_anim["generic"][jog] );
			wait( delay - 0.2 );
		}
		else
		{
			jogging = false;
		}

		wait( 0.5 );
	}

	wait randomfloatrange (0.1, 1.5);
	
	self.moveplaybackrate = 1.0;
	self clear_run_anim();

	level notify( "stop_jog" );
}

// straight rip from pel2/mak to ensure consistency for co-op spawning
start_teleport_players( start_name, coop )
{
	// grab all players
	players = get_players();

	// Grab the starting points
	if( isdefined( coop ) && coop )
	{
		starts  = get_sorted_starts( start_name );	
	}
	else
	{
		starts = getstructarray( start_name, "targetname" );		
	}
	
	// make sure there are enough points to start from
	assertex( starts.size >= players.size, "Need more start positions for players!" ); 
	
	// set up each player
	for (i = 0; i < players.size; i++)
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		
		if( isdefined( starts[i].angles ) )
		{
			// Set the players' angles to face the right way.
			players[i] setPlayerAngles( starts[i].angles );
		}	
		else
		{
			// in case the script struct doesn't have angles set
			players[i] setPlayerAngles( ( 0, 0, 0 ) );
		}

	}	
	
	// CODER_MOD : DSL
	// Initialise the breadcrumb positions to the positions provided.
	set_breadcrumbs(starts);
}

// Get the points to warp the starting AI and players to
get_sorted_starts( start_name )
{
	
	player_starts = []; 

	player_starts = getstructarray( start_name, "targetname" ); 

	for( i = 0; i < player_starts.size; i++ )
	{
		for( j = i; j < player_starts.size; j++ )
		{
			if( player_starts[j].script_int < player_starts[i].script_int )
			{
				temp = player_starts[i]; 
				player_starts[i] = player_starts[j]; 
				player_starts[j] = temp; 
			}
		}
	}

	return player_starts; 
	
}

do_water_drops_on_camera_for_time( wait_time )
{
	players_water_drops_on();
	
	wait wait_time;
	
	players_water_drops_off();
}

players_water_drops_on()
{
	players = getplayers();
	for( i = 0 ; i < players.size; i++ )
	{
		players[i] setwaterdrops(100);	
	}	
}

players_water_drops_off()
{
	players = getplayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] setwaterdrops(0);	
	}	
}


do_water_sheeting_on_camera()
{
	players = getplayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] setwatersheeting(2, 3);
	}	
}

ok_to_set_wetness()
{
	if(!isdefined(level._num_wetness))
	{
		level thread wetness_monitor();
	}
	
	if(NumRemoteClients())
	{
		if(level._num_wetness > 1)
		{
			return false;
		}
	}
	
	return true;
}

wetness_monitor()
{
	level._num_wetness = 0;
	while(1)
	{
		wait_network_frame();
		level._num_wetness = 0;
	}
}

wetness_on_ai(wetness, top_down, fade_time)
{
	self endon ("death");
	
	if ( !isdefined(self.wetness) )
	{
		while(!ok_to_set_wetness())
		{
			wait_network_frame();
		}
		
		self setwetness( wetness, top_down );
		self.wetness = wetness;
		level._num_wetness ++;
	}
	else
	{
		// 20*0.05 = 1 sec
		frames = fade_time / 0.05;
		
		if (!frames)
		{
			return;
		}
		
		wet_diff = wetness - self.wetness;
		
		wet_per_frame = wet_diff / frames;

		for (i = 0; i < frames; i++)
		{
			while(!ok_to_set_wetness())
			{
				wait_network_frame();
			}
			self.wetness += wet_per_frame;
			self setwetness(self.wetness, top_down );
			level._num_wetness ++;
			wait 0.05;
		}
		
	}
		
}

// Kill the given AI with style( fx )
bloody_death( delay )
{
	self endon( "death" ); 

	if( !IsAi( self ) || !IsAlive( self ) )
	{
		return; 
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return; 
	}

	self.bloody_death = true; 

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) ); 
	}

	tags = []; 
	tags[0] = "j_hip_le"; 
	tags[1] = "j_hip_ri"; 
	tags[2] = "j_head"; 
	tags[3] = "j_spine4"; 
	tags[4] = "j_elbow_le"; 
	tags[5] = "j_elbow_ri"; 
	tags[6] = "j_clavicle_le"; 
	tags[7] = "j_clavicle_ri"; 
	
	for( i = 0; i < 2; i++ )
	{
		random = RandomIntRange( 0, tags.size ); 
		//vec = self GetTagOrigin( tags[random] ); 
		self thread bloody_death_fx( tags[random], undefined ); 
		wait( RandomFloat( 0.1 ) ); 
	}

	dmg = self.health + 10;

	self DoDamage( dmg, self.origin ); 
}	

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"]; 
	}

	PlayFxOnTag( fxName, self, tag ); 
}

rumble_all_players(high_rumble_string, low_rumble_string, rumble_org, high_rumble_range, low_rumble_range)
{
	players = get_players();
	
	for (i = 0; i < players.size; i++)
	{
		if (isdefined (high_rumble_range) && isdefined (low_rumble_range) && isdefined(rumble_org))
		{
			if (distance (players[i].origin, rumble_org) < high_rumble_range)
			{
				players[i] playrumbleonentity(high_rumble_string);
			}
			else if (distance (players[i].origin, rumble_org) < low_rumble_range)
			{
				players[i] playrumbleonentity(low_rumble_string);
			}
		}
		else
		{
			players[i] playrumbleonentity(high_rumble_string);
		}
	}
}

//#using_animtree ("pel1_fake_lvt_guys");
populate_lvt_with_heads_and_shoulders()
{
	self.fake_shoulders = spawn("script_model", self.origin );

	self.fake_shoulders setmodel ("static_peleliu_lvtcrew");
	self.fake_shoulders.angles = self.angles;
	self.fake_shoulders linkto (self, "tag_origin", (-80,0,81));
	
	//self.fake_shoulders useanimtree(#animtree);
	//self.fake_shoulders thread maps\pel1_anim::fake_lvt_guys_anim();
	
	self thread remove_fake_shoulders();
	
}
