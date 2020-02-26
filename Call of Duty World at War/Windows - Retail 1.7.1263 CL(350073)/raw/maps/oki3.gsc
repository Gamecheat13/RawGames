/*-----------------------------------------------------
	Okinawa 3
-----------------------------------------------------*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\oki3_util;
#include maps\oki3_callbacks;
#include maps\_anim;
#include maps\_music;

#using_animtree ("generic_human");
main()
{
	
	//level support scripts
	maps\oki3_fx::main();
	
	//callbacks
	init_callbacks();	
	

	//PrecacheShellShock( "teargas" ); 
	precacheitem("mortar_round");
	precacheitem("m8_white_smoke_light");
	precachemodel("okinawa_dogtag");
	precachemodel("tag_origin");
	precachemodel("weapon_satchel_charge");
	precachemodel("radio_jap_bro");
	precachestring(&"OKI3_USE_MORTAR");
	precachestring(&"OKI3_MORTAR_HINT");
	precacheshader("black");
	precacheshader("white");
	precachemodel("aircraft_bomb");
  precacheshader("hud_icon_airstrike");
  precachemodel("lights_tinhatlamp_off");
  PrecacheRumble("wpn_mortar_prime");
  PrecacheRumble("oki3_castle_fall");
		
	level.player_move_speed = 180;
	
	maps\_p51::main( "vehicle_p51_mustang" );

	// MikeD (5/5/2008): Vehicle Destructible Support
	//maps\_destructible_type94truck::init();
	
	//initialize any level flags
	init_flags();
	
	//initialilze skipto's
	init_starts();
	
	//bombing runs on the courtyard
	maps\oki3_dpad_asset::airstrike_init();
	
	//_load baby! 
	maps\_load::main();

	maps\_banzai::init();	
	maps\_bayonet::init();
	maps\_tree_snipers::main();
	maps\_mganim::main();
	maps\oki3_anim::main();
	maps\oki3_amb::main();
	
	maps\_mgturret::init_mg_animent();
		
	oki3_init();
		
	//start ambient packages
	level thread maps\oki3_amb::main();
	
	//setup the courtyard destruction in the final event
	level thread maps\oki3_courtyard::init_courtyard_destruction();
	
	//testing
	//remove_grenades_from_everyone();
	
	level thread oki3_achievement_setup();	
	level thread oki3_give_achievement();
	//guys going up/down stairs...looks better?
	//level thread handle_ai_stairs();
	
	
	
}


oki3_init()
{
	init_mortars();
	init_bunker_damage();
	init_spiderholes();	
	init_wall_clip();	
	//init_trap_door();	
	init_supply_drops();	
	init_spawn_functions();
}


init_wall_clip()
{
	
	castle_wall_clip = getent("castle_wall_clip","targetname");
	castle_wall_clip connectpaths();
	castle_wall_clip trigger_off();
	
}


/*------------------------------------
set up the trap door in the bunkers so that it rotates properly
------------------------------------*/
init_trap_door()
{
	trap_door = getent("trap_door","targetname");
	trap_door.angles = (0, -25, 0);
	trap_door.origin = trap_door.origin + (-15,5,0);
	
}

/*------------------------------------
initialize callback stuff
------------------------------------*/
init_callbacks()
{
	level thread onFirstPlayerConnect();
	level thread onPlayerConnect();
	level thread onPlayerDisconnect();
	level thread onPlayerSpawned();
	level thread onPlayerKilled();
}

/*------------------------------------
set us up the bombs
------------------------------------*/
init_mortars()
{
	
	//mortars in trenches
	maps\_mortar::set_mortar_delays( "dirt_mortar", 2, 4.25,0.5, 1.25 );
	maps\_mortar::set_mortar_range( "dirt_mortar", 512, 15000 );
	maps\_mortar::set_mortar_damage( "dirt_mortar", 16, 1, 2 );
	maps\_mortar::set_mortar_quake( "dirt_mortar", 0.27, 3, 784 );
	maps\_mortar::set_mortar_dust( "dirt_mortar", "bunker_dust", 512 );
	
	
	//mortars on the hillside
	maps\_mortar::set_mortar_delays( "hill_mortars", 2.25, 4.25,0.5, 1.25 );
	maps\_mortar::set_mortar_range( "hill_mortars", 500, 5000 );
	maps\_mortar::set_mortar_damage( "hill_mortars", 20, 100, 200 );
	maps\_mortar::set_mortar_quake( "hill_mortars", 0.32, 3, 1800 );
	//maps\_mortar::set_mortar_dust( "hill_mortars", "bunker_dust", 512 );	

	//mortars on courtyard rooftops
	maps\_mortar::set_mortar_delays( "courtyard_ambient_roof", 1.25, 2.25,0.5, 1.25 );
	maps\_mortar::set_mortar_range( "courtyard_ambient_roof", 200, 15000 );
	maps\_mortar::set_mortar_damage( "courtyard_ambient_roof", 20, 100, 200 );
	maps\_mortar::set_mortar_quake( "courtyard_ambient_roof", 0.2, 2, 3000 );	
	
	//mortars on courtyard ground
	maps\_mortar::set_mortar_delays( "courtyard_ambient_ground", 1.25, 2.25,0.5, 1.25 );
	maps\_mortar::set_mortar_range( "courtyard_ambient_ground", 200, 15000 );
	maps\_mortar::set_mortar_damage( "courtyard_ambient_ground", 20, 100, 200 );
	maps\_mortar::set_mortar_quake( "courtyard_ambient_ground", 0.2, 2, 3000 );
	
	//first  mortar which falls near the players
	maps\_mortar::set_mortar_delays( "first_mortar", 1.25, 2.25,0.5, 1.25 );
	maps\_mortar::set_mortar_range( "first_mortar", 200, 15000 );
	maps\_mortar::set_mortar_damage( "first_mortar", 256, 25, 50 );
	maps\_mortar::set_mortar_quake( "first_mortar", 0.39, 3, 1024 );

	//the ambient mortars
	maps\_mortar::set_mortar_range( "ambush_mortars", 448, 15000 );
	maps\_mortar::set_mortar_delays( "ambush_mortars", 2.55, 4.75,0.5, 1 );
	maps\_mortar::set_mortar_damage( "ambush_mortars", 256, 25, 50 );
	maps\_mortar::set_mortar_quake( "ambush_mortars", 0.32, 3, 1800 );
	maps\_mortar::set_mortar_dust( "ambush_mortars", "tunnel_dust", 1800 );		



	//init the mortarteams for back area	
	level thread maps\_mortarteam::main();
	
}

/*------------------------------------
set up the supply drops
------------------------------------*/
init_supply_drops()
{
	
	//grab the supply drops and hide them
	level.drop1 = getent("supply_drop1","targetname");
	level.drop2 = getent("supply_drop2","targetname");
	level.drop3 = getent("supply_drop3","targetname");
	level.drop4 = getent("supply_drop4","targetname");
	level.drop6 = getent("supply_drop6","targetname");
	

	level.drop2 moveto( (level.drop2.origin[0],	level.drop2.origin[1], 3154),.05);
	//level.drop3 moveto( (level.drop3.origin[0],	level.drop3.origin[1], 1971),.05);	
	
	level.drop1 hide();
	level.drop2 hide();
	level.drop3 hide();
	level.drop4 hide();	
	level.drop6 hide();	
}

init_flags()
{
	flag_init("set_low_ammo");
	flag_init("explosives_taken");
	flag_init("bunker_destroyed");
	flag_init("mortar_pits");
	flag_init("tunnel_entered");
	flag_init("bunker_entered");
	flag_init("do_tree_fx");
	flag_init("mortars_cleared");
	flag_init("stop_fake_mortar");
	flag_init("grass_admin_surprise");
	flag_init("grass_admin_surprise_damage" );
	flag_init("trig_grass_admin_camo_guys");
	flag_init("mg_mounted");
	flag_set ("set_low_ammo");
}


init_palm_trees()
{
	//palm tree stuffs
	//level.tree1 = getent("tree_intact","targetname");
	//level.tree1d = getent("tree_destroyed","targetname");		
	level.tree2 = getent("tree2_intact","targetname");
	level.tree2d = getent("tree2_destroyed","targetname");	
	//level.tree3 = getent("tree3_intact","targetname");
	//level.tree3d = getent("tree3_destroyed","targetname");	
	//level.tree4 = getent("tree4_intact","targetname");
	//level.tree4d = getent("tree4_destroyed","targetname");
	
	//level.tree1d hide();
	level.tree2d hide();
	//level.tree3d hide();
	//level.tree4d hide();
	
}

/*------------------------------------
initialize the start points
------------------------------------*/
init_starts()
{
	
	default_start( ::start_outside_castle );	
	add_start( "mortar_pits", ::start_by_mortar_pits,&"OKI3_STARTS_MORTARPITS" );	
	add_start("planters",::start_by_planters, &"OKI3_STARTS_PLANTERS");
	add_start("ambush",::start_ambush, &"OKI3_STARTS_AMBUSH");
	add_start("planters_end",::start_planters_end,&"OKI3_STARTS_PLANTERS_END");
	add_start("courtyard",::start_in_courtyard,&"OKI3_STARTS_COURTYARD");
	add_start("outro",::start_at_outro,&"OKI3_STARTS_OUTRO");
	//add_start("castle_explode",::start_castle_explode,&"OKI3_STARTS_EXPLODE");

}


init_spawn_functions()
{
	melee_guy1 = getent("melee_guy1","targetname");
	melee_guy1 add_spawn_function(::event1_spiderhole_ambush_melee);
	
	satchel_thrower = getent("satchel_thrower","targetname");
	satchel_thrower add_spawn_function(::event1_seal_tunnel_entrance);
	
	upper_mgguy = getent("upper_mg_guy","targetname");
	upper_mgguy add_spawn_function(::event1_upper_mg);

	gatehouse_mgguy = getent("gatehouse_mg_guy","script_noteworthy");
	gatehouse_mgguy add_spawn_function(::event3_gatehouse_mg);
	
	//portable_mgguy = getent("portable_mg_guy","script_noteworthy");
	//portable_mgguy add_spawn_function(::event3_portable_mg);

	hole1_guys = getentarray("hole_guys_1", "targetname");
	array_thread(hole1_guys, ::add_spawn_function, ::event4_hole1_guys);
	
	hole2_guys = getentarray("courtyard_hole2_guys", "targetname");
	array_thread(hole2_guys, ::add_spawn_function, ::event4_hole2_guys);
		
	house_guys = getentarray("auto4405","targetname");
	array_thread(house_guys, ::add_spawn_function, ::event4_house_guys);
	
	defender_guys = getentarray("courtyard_defenders","script_noteworthy");
	array_thread(defender_guys,::add_spawn_function,::event4_house_guys);
	
	sniper_guys = getentarray("treesniper_climber","targetname");
	array_thread (sniper_guys,::add_spawn_function,::tree_sniper_spawner_func);
	
	//outer_guys = getentarray("outer_guys","targetname");
	//array_thread(outer_guys,::add_spawn_function,::event1_outer_guys);
		
	e1_banzai_guys = getentarray("e1_banzai_guys","targetname");
	array_thread(e1_banzai_guys,::add_spawn_function,::e1_banzai_charge);
	
}

e1_banzai_charge()
{
	self endon("death");
	
	self.ignoreme = true;
	self thread maps\_banzai::banzai_force();
	wait(5);
	self.ignoreme = false;
}


//event1_outer_guys()
//{
//	self endon("death");
//	self.goalradius = 32;
//	self.ignoreall = true;
//	self waittill("goal");
//	self.ignoreall = false;
//}


event1_upper_mg()
{
	self endon("death");
	turret = getent("upper_mg","script_noteworthy");
	self.script_noteworthy = "upper_mg_guy";
	turret setturretignoregoals( true );
	
	level thread maps\_mgturret::burst_fire(turret);
	self thread random_death(150,180);
	
}

event3_gatehouse_mg()
{
	
	self endon("death");
	turret = getent("auto4051","targetname");
	turret setturretignoregoals( true );
	wait(6);
	// "We got another MG on our left flank!"\level.scr_sound["roebuck"]["REFERENCE"] = "Oki3_IGD_226A_ROEB";
	level.sarge do_dialogue("another_mg");
	
	
}

event4_hole1_guys()
{
	
	self endon("death");
	self.goalradius = 32;
	self waittill("goal");
	self delete();
	
}

event4_hole2_guys()
{
	self endon("death");
	self.goalradius = 32;
	self waittill("goal");
	wait(randomintrange(25,45));
	
	self bloody_death();

}


event4_house_guys()
{
	
	self endon("death");
	
	self.script_noteworthy = "house_guys";
	self.pacifist = true;
	self.ignoreall = true;
	self.pacifistwait = 0;
	self.goalradius = 32;
	self waittill("goal");
	self.pacifist = false;
	self.ignoreall = false;
	
	
}


event3_portable_mg()
{
	self endon("death");
	
	self.ignoreme = true;
	self.ignoreall = true;
	self waittill("goal");
	self.ignoreme = false;
	self.ignoreall = false;	
}


//monitor_e1_mgguy()
//{
//	self waittill("damage");
//	
//	turret = getent("upper_mg","script_noteworthy");
//	turret setmode("manual_ai");
//	
//}


event1_spiderhole_ambush_melee()
{
	self endon("death");
	
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.ingoreall = true;
	
	heros = [];
	heros[0] = level.sarge;
	heros[1] = level.polonsky;
	
	guys = [];
	guys[0] =	self;
	guys[1] = get_closest_ai_exclude(getent("melee_fight","targetname").origin,"allies",heros);
	
	tick = 0;
	while(!isDefined(guys[1]))
	{
		guys[1] = get_closest_ai_exclude(getent("melee_fight","targetname").origin,"allies",heros);
		wait (.05);
		tick++;
		if(tick > 140)
		{
			break;
		}
	}
	
	if(isDefined(guys[1]))
	{
		guys[1] set_force_color("o");	
		guys[0].animname = "jpn";
		guys[1].animname = "us";
		if(!isDefined(guys[1].magic_bullet_shield))
		{
			guys[1] thread magic_bullet_shield();
		}
		guys[1].ignoreme = true;
		guys[1].ignoreall = true;
		anim_org = getent("melee_fight","targetname");
		anim_org anim_reach ( guys, "fight");
		
		//if(isAlive(guys[0]) && isAlive( guys[1]))
		//{
	 	anim_org anim_single ( guys, "fight");
		//}
		guys[1].ignoreme = false;
		guys[1].ignoreall = false;
		if(isDefined(guys[1].magic_bullet_shield))
		{
			guys[1] stop_magic_bullet_shield();
		}
	}
	self.ignoreme = false;
	if(isDefined(self.magic_bullet_shield))
	{
		self stop_magic_bullet_shield();
	}
}


event1_seal_tunnel_entrance()
{
	self endon ("death");
	self disable_ai_color();
	self.notme = true;
	self.ignoreme = true;
	self.ignoreall = true;
	blast_volume = getent("blast_volume","targetname");
		
	self.animname = "redshirt";	
	anim_node = getnode("throw_satchel","targetname");
	self thread anim_loop_solo(self,"satchel_wait",undefined,"stop_waiting",anim_node);
	
	trigger_wait("tunnel_exit_lookat","targetname");
	
	self do_dialogue("cmon","redshirt");

	level waittill("all_out_bunker");
	self notify("stop_waiting");
	self do_dialogue("hurry","redshirt");

	anim_node thread anim_single_solo(self,"satchel_throw");
	level thread exit_bunker_dialogue();
	wait(6);

	ent = getent("play_smoke_fx","targetname");
	playsoundatposition("satchel_down_tunnel", ent.origin);	
	playfx( level._effect["bunker_satchel"] ,ent.origin);
	playfx( level._effect["dirt_mortar"],ent.origin);
	
	players = get_players_in_bunker();
	for(i=0;i<players.size;i++)
	{
		players[i] enablehealthshield(false);
		players[i] dodamage(players[i].health + 1000,players[i].origin);
	}

	blockers = getentarray("tunnel_block","targetname");
	for(i=0;i<blockers.size;i++)
	{
		blockers[i].origin = blockers[i].origin + (0,0,70);
		blockers[i] show();
		blockers[i] solid();
	}
	earthquake(.45,3,ent.origin + (0,0,-50),1024);

	while(!isDefined(level.spiderholes_triggered))
	{
		wait 1;
	}
	self.ignoreme = false;
	self.ignoreall = false;
	self thread bloody_death(true,20);
	self setgoalnode(getnode("flipover","targetname"));
}


exit_bunker_dialogue()
{
	
	wait(5);
	level.sarge do_dialogue("follow_me");
}


start_by_planters()
{
	
	setup_friendlies("mortar_pits");
	move_ai("outer_courtyard_ai");
	level thread move_players("outer_courtyard_players");	
	level waittill("introscreen_complete");
	level thread planter_battle();
	kill_beginning_guys();
	level.player_move_speed = 180;
	
	level thread mortarpits_shoot_boards();
	wait(1);
	level notify("mortar_guys_dead");
	level notify("mortar_area_clear");
}


start_planters_end()
{

	setup_friendlies();
	move_ai("planter_end_ai");
	level thread move_players("planter_end_players");
	getent("courtyard_clear","targetname") notify("trigger");
	
	level waittill("introscreen_complete");
	
	
	sarge_kick_door();
	level thread do_castle_dialogue();
	level.sarge set_force_color("o");
	level thread maps\oki3_courtyard::main();
	
	objective_add(6,"current",&"OKI3_OBJ1");
	objective_position(6,(8203, -2236, 157));
	getent("planter_door_end","targetname") notify("trigger");
	kill_beginning_guys();
	
	x =0;
	guys = getaiarray("allies");
	for(i=0;i<guys.size;i++)
	{

		if(guys[i] != level.sarge && guys[i] !=  level.polonsky && x<2)
		{
			guys[i] notify( "_disable_reinforcement" );
			wait(.1);
			guys[i] delete();
			x++;
		}
	}
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] takeweapon("air_support");
	}		
	

}

/*------------------------------------
supply drop that lands outside the main courtyard...need to remove
------------------------------------*/
#using_animtree ("supply_drop");
supply_drop_1()
{
	
	level.drop1 show();
	level.drop1.animname = "drop1";
	level.drop1 useanimtree(#animtree);
	
	trace = bulletTrace( level.drop1.origin,(level.drop1.origin + (0,0,-1000)) , true, undefined );
	vector = trace["position"];
	
	level.drop1.anchor = spawn("script_origin", level.drop1.origin);
	level.drop1 linkto(level.drop1.anchor);
	level.drop1.anchor moveto( vector, randomintrange(4,6) );
	level.drop1 thread move_drop1();
	level.drop1.anchor waittill("movedone");
	
	playfx(level._effect["bunker_dust"],level.drop1.anchor.origin);	
	level.drop1 notify("movedone");
	
	if(randomint(100) > 50)
	{
		str = "landing";
	}
	else
	{
		str = "landingb";
	}
	level.drop1 thread maps\_anim::anim_single_solo(level.drop1,"landingb");
	
	
	level.drop1.anchor moveto( level.drop1.anchor.origin + (-400,0,-150), 1);
	level.drop1.anchor waittill("movedone");
	
	level.drop1 unlink();
	level.drop1.anchor delete();
	level.drop1 delete();	

}

/*------------------------------------
temp until animation gets done
------------------------------------*/
#using_animtree ("supply_drop");
move_drop1()
{
	
	self.animname = "drop1";
	self useanimtree(#animtree);
	self endon("movedone");
	while(1)
	{
		level.drop1 maps\_anim::anim_single_solo(level.drop1,"drop");
		level.drop1 waittill("single anim");
	}
	
}

///*------------------------------------
//start the supply defend sequence
//------------------------------------*/
//start_courtyard_battle()
//{
//	trig = getent("sarge_dies","targetname");
//	trig waittill("trigger");
//
//	wait(1);
//	level.sarge thread do_dialogue("guys_surrender");
//	
//	//level thread castle_spawners();
//
//	
//	level.sarge setgoalnode(getnode("sarge_node","targetname"));
//	level.sarge waittill("goal");		
//	level.sarge thread stop_magic_bullet_shield();
//	wait(.5);
//	level.sarge thread bloody_death(true,1);
//	wait(1.5);
//	iprintlnbold("SARGE DIES HERE");
//	level.polonsky thread do_dialogue("sarge_killed");
//	//getent("enter_courtyard","targetname") notify("trigger");
//	objective_add(6,"current",&"OKI3_OBJ5",( 7623, -4535, 455.5));
//	
//	wait(5);
//	level thread maps\_mortar::mortar_loop( "courtyard_ambient_ground",1);
//	level thread maps\_mortar::mortar_loop( "courtyard_ambient_roof",1);
//	
//	level thread maps\oki3_courtyard::do_courtyard_destruction();
//	
//	castle_spawners();
//	
//
//	// MikeD (8/20/2007): Updated the _mortar script.
////	maps\_mortar::set_mortar_delays( "dirt_moRtar", 1, 3, 1, 3 );
////	maps\_mortar::set_mortar_range( "dirt_mortar", 200, 15000 );
////	maps\_mortar::set_mortar_damage( "dirt_mortar", 100, 0, 0 );
////	maps\_mortar::set_mortar_quake( "dirt_mortar", 0.15, 2, 5000 );
////	level thread maps\_mortar::mortar_loop( "dirt_mortar", 4 );
////	wait(1);
////	level notify("start_ambient_mortars");
//	//level thread castle_mortars_think();
//}



start_ambush()
{
		//blockers in the tunnel
		blockers = getentarray("tunnel_block","targetname");
		for(i=0;i<blockers.size;i++)
		{
			blockers[i] hide();
			blockers[i] notsolid();
			blockers[i] connectpaths();
		}
		
		getent("tunnel_exit_block","targetname") trigger_off();
		level setup_friendlies("ambush");
		level thread move_ai("start_ambush_ai");
		level thread move_players("start_ambush_players");
		level thread post_mortar_ambush();
		level thread mortar_teams();	
		getent("stop_mortars","targetname") notify("trigger");
		level waittill("introscreen_complete");
		ignoreall_on(getaiarray("allies"));	
		
		setup_closet_ambush();
	
}


start_in_courtyard()
{
	
	//level thread start_courtyard_battle();
	battlechatter_off("allies");
	
	setup_friendlies("inside_castle");
	move_ai("castle_ai");
	level thread move_players("castle_players");
	
	wait(1);
	
	getent("underground_exit_friends","targetname") notify("trigger");

 		level maps\oki3_courtyard::main();
		wait(1);
		getent("spawn_feigning_guys","targetname") notify("trigger");
		
		players = get_players();
		for(i=0;i<players.size;i++)
		{			
			players[i] takeweapon("air_support");
		}
}


//start_castle_explode()
//{
//	
//	//level thread start_courtyard_battle();
//	battlechatter_off("allies");
//	
//	setup_friendlies("inside_castle");
//	move_ai("castle_ai");
//	level thread move_players("castle_players");
//	
//	wait(1);
//	
//	getent("underground_exit_friends","targetname") notify("trigger");
//
//	//level maps\oki3_courtyard::main();
//	//wait(1);
//	//getent("spawn_feigning_guys","targetname") notify("trigger");
//	
//	players = get_players();
//	for(i=0;i<players.size;i++)
//	{			
//		players[i] takeweapon("air_support");
//	}
//}




start_at_outro()
{
	
	battlechatter_off("allies");	
	setup_friendlies("inside_castle");
	move_ai("castle_ai");
	level thread move_players("castle_players");	
	level waittill("introscreen_complete");
	thread maps\oki3_anim::oki3_outro_2();
	level.last_hero = level.polonsky;
	//level thread maps\oki3_anim::play_outro_dialogue();
	wait(.5);	
	level notify("do_outro");	
	
}


start_outside_castle()
{
	

	simple_spawn("fence_guys");
	setup_friendlies("castle_limits");
	move_ai("castle_limits_ai");
	toggle_ignoreall(1);
	battlechatter_off("allies");
	battlechatter_off("axis");	
	set_player_ammo_loadout();
	
	level thread do_intro_dialogue();

	//blockers in the tunnel
	blockers = getentarray("tunnel_block","targetname");
	for(i=0;i<blockers.size;i++)
	{
		blockers[i] hide();
		blockers[i] notsolid();
		blockers[i] connectpaths();
	}
	
	player_block = getent("tunnel_exit_block","targetname");
	player_block trigger_off();
		
	init_palm_trees();		

	//trig = getent("start_outer_castle","targetname");
	//trig notify("trigger");	
	//level.sarge setgoalnode(getnode("sarge","targetname"));
	//level.sarge.goalradius = 64;
	
	//make the friendlies ignore any enemies right now
	
	//drop the supplies
	level thread supply_drop();
	
	level thread event1_tree_snipers();
	
	wait_for_first_player();
	
	level notify("drop_supplies");	
	move_players("castle_limits_players");
			
	level waittill("introscreen_complete");
	getent("spawn_buzzby_guys","targetname") notify("trigger");
	level thread buzzby_sound();
	
	//level notify("intro");
	//level waittill("move");
	
	//maps\_debug::set_event_printname( "Ambush", true );
	
	
	//group of allies which are waiting ahead of the player
	level thread forward_squad();	
	
	//building behind the castle entrance
	level thread guard_shack();
	
	//set up the mortar teams inside of castle grounds	
	level thread mortar_teams();	
	
	//the battle in the planters area
	level thread planter_battle();
	
	//add the first objective
	//objective_add(1,"current",&"OKI3_REGROUP_BY_WALL",(3944, 3920, -776));

	level thread event1_regroup();
	level thread init_tunnel_hint();
	level thread hint_trigger_think();	
	level thread start_fake_mortars();	
}

buzzby_sound()
{
	wait(.5);
	
	players = get_players();
	planes = getentarray("buzzby_planes","targetname");
	for(i=0;i<planes.size;i++)
	{
		planes[i] thread plane_loop_sound();
		planes[i] thread delete_plane();
	}
}

plane_loop_sound()
{
	//min_dist = 15000 * 15000;
	//players = get_players();
	//while(distancesquared(players[0].origin , self.origin) > min_dist)
	//{
	//	wait_network_frame();
	//}
	wait(randomfloatrange(0.1,1));
	self playsound("plane_flyby_" + randomintrange(1,5));
}

delete_plane()
{
	
	self waittill("reached_end_node");
	self delete();	
}

do_intro_dialogue()
{
	//TUEY Sets Music State to INTRO
	setmusicstate("INTRO");


	level.sniper_pawn.goalradius = 64;
	level.sniper_pawn setgoalnode(getnode("pawn_intro","targetname"));//setgoalpos( (4777.3, 5042.8, -791.4));
	
	level.sarge.goalradius = 64;
	level.sarge setgoalnode(getnode("sarge_intro","targetname"));//setgoalpos( (4777.3, 5042.8, -791.4));
	
	
	level.polonsky.goalradius = 64;
	level.polonsky setgoalnode(getnode("polonsky_intro","targetname"));//setgoalpos( (4777.3, 5042.8, -791.4));
	wait(1);
	level.sarge do_dialogue("ob1");
	level.sarge do_dialogue("ob2");
	level.sarge do_dialogue("supplies");
	level.polonsky do_dialogue("thereitis");
	
	//level waittill("intro");
	//level.sarge waittill("goal");	

	level notify("move");
	level.sarge thread do_dialogue("doubletime");
	wait(2.5);
	level.sarge thread do_dialogue("ob3");
	wait(6);	
	level.polonsky thread do_dialogue("planes_bombed");
	wait(2.5);
	level.sarge do_dialogue("be_back");
	wait(.25);
	level.sarge thread do_dialogue("for_now");	
}

start_fake_mortars()
{
	trigger_wait("squad_regroup","targetname");
	level thread maps\oki3_fx::mortarpits_fake_launch();

}

event1_regroup()
{
		
	nodes = getnodearray("meat_wall","targetname");
	level.polonsky.goalradius = 32;
	level.sniper_pawn.goalradius = 32;
	level.polonsky setgoalnode(nodes[0]);
	level.sniper_pawn setgoalnode(nodes[1]);

	objective_add(2,"current",&"OKI3_OBJ4",(5717.5, 3154.5, -754));

  level.sarge set_force_color("y");
  level.polonsky set_force_color("y");
  level.sniper_pawn set_force_color("g");
	//wait(1);
	level.sarge enable_ai_color();
		
	secure_the_supply_drops();
	level thread event1_tree_sniper_ambush();
	level thread over_wall_think();

	
}



secure_the_supply_drops()
{
	
	trig = getent("team_splitup","targetname");
	trig notify("trigger");
	
	//TUEY Sets Music State to SUPPLIES
	setmusicstate("SUPPLIES");
	
	//level.sniper_pawn.goalradius = 64;
	
	//level.sniper_pawn setgoalnode(getnode("pawn","targetname"));
	level notify("forward_squad_move");	
}

/*------------------------------------
group of guys who are already chillin by
the trenches. They usually get worked by 
the first mortar
------------------------------------*/
forward_squad()
{
	//getent("run_to_bunkers","targetname") waittill("trigger");
	level waittill("forward_squad_move");
	getent("ai_drop","targetname") notify("trigger");
	
	guys = get_ai_group_ai("forward_squad");
	//guys_2 = get_ai_group_ai("squad2");	
	
	//guys = array_combine(guys_2,guys_1);
	
	nodes = getnodearray("runto_supplies","targetname");	
	for(i=0;i<guys.size;i++)
	{
		guys[i].goalradius = 64;
		guys[i].pacifist = true;
		guys[i] setgoalnode( nodes[i]);
		guys[i] thread forward_squad_guy();
		guys[i] notify("_disable_reinforcement");
	}
	
	guys = get_ai_group_ai("friends");
	for(i=0;i<guys.size;i++)
	{
		if (guys[i] != level.polonsky && guys[i] != level.sarge)
		{
			guys[i] notify("_disable_reinforcement");
		}
	}
	
	
}

/*------------------------------------
these guys are just for show, so kill them 
when the mortars start going off if the first
mortar doesnt' get them first
------------------------------------*/
forward_squad_guy()
{
	self endon("death");
	level waittill("owned");
	
	self.pacifist= false;
	
	level waittill("first_mortar");
	
	wait(20);

	self thread bloody_death(true,randomint(5));
}



/*------------------------------------
sets up all the throwable mortars in the
back area
------------------------------------*/
start_mortar_pits()
{
	getent("start_mortar_pits","targetname") waittill("trigger");
	
	autosave_by_name("mortar_pits_start");
	init_usable_mortars();
	trig = getent("after_mortar_trigger","script_noteworthy");
	trig trigger_off();
	
	//init_bunker_damage();
	flag_set("mortar_pits");
	level thread motar_pit_damage();
	level thread monitor_bunker_damage();	
	level thread monitor_mg_bunker_damage();
	level thread spawn_mortarpit_dudes();
	level thread e3_save_stairs();
	level thread mortarpits_shoot_boards();
	level thread alert_mggunner();
		
	wait(1);
	kill_beginning_guys();

}

e3_save_stairs()
{
	org_trigger( (709 ,-3675, -189.6),156);
	autosave_by_name("mortarpits_stairs");
}

init_usable_mortars()
{
	level thread mortar_round_think("pit1");
	level thread mortar_round_think("pit1a");
	level thread mortar_round_think("pit2");
	level thread mortar_round_think("pit2a");
	level thread mortar_round_think("pit3");	
	level thread mortar_round_think("pit4");	
	level thread mortar_round_think("intro");
	level thread mortar_round_think("intro2");	
	level thread mortar_round_think("intro_wall");	
	level thread mortar_round_think("wall2");	
	level thread mortar_round_think("wall3");
	level thread mortar_round_think("mgwall");

}

init_bunker_damage()
{
	
	intact = getent("mortar_house_intact","targetname") ;//
	damage2 = getent("mortar_house_damage_2","targetname");//
	damage3 = getent("mortar_house_damage_3","targetname");//
	bigbits = getentarray("bigbits","script_noteworthy");
	deleted_bits = getent("mortar_house_damage_delete","targetname");//
	loose_boards = getentarray("loose_boards","script_noteworthy");
	
	
	bits = [];
	bits = array_combine(bigbits,loose_boards);

	for(i=0;i<bits.size;i++)
	{
		bits[i] hide();
		bits[i] notsolid();
	}
	deleted_bits hide();
	
	
	clipper = getent("mortar_house_clip","targetname");
	clipper connectpaths();
	clipper trigger_off();
	
	
	damage2 hide();
	damage2 notsolid();
	
	damage3 hide();
	damage3 notsolid();
	
	//mg hut stuff
	mg_intact = getent("mortarpit_mghut_intact","targetname") ;
	mg_damage1 = getent("mortarpit_mghut_wrecked","targetname");
	
	mg_damage1 hide();
	mg_damage1 notsolid();
	
	//chunks
	chunks = [];
	chunks[0] = getent("mortarpit_mghut_wrecked_chunk_1","script_noteworthy");
	chunks[1] = getent("mortarpit_mghut_wrecked_chunk_2","script_noteworthy");
	chunks[2] = getent("mortarpit_mghut_wrecked_chunk_3","script_noteworthy");
	chunks[3] = getent("mortarpit_mghut_wrecked_chunk_4","script_noteworthy");
	chunks[4] = getent("mortarpit_mghut_wrecked_chunk_5","script_noteworthy");
	chunks[5] = getent("mortarpit_mghut_wrecked_chunk_6","script_noteworthy");
	
	for(i=0;i<chunks.size;i++)
	{
		chunks[i] hide();
	}
	
	curtains = getent("event1_mg_curtains","targetname");
	mg = getent("auto4051","targetname");
	
	mg_clipper = getent("mg_hut_clip","targetname");
	mg_clipper connectpaths();
	mg_clipper trigger_off();
	
	//damage trigger in MG hut
	getent("mghut_fire_damage","targetname") trigger_off();
		
}

/*------------------------------------
players can destroy the building with mortars
------------------------------------*/
monitor_bunker_damage()
{
	
	//grab all the pieces
	intact = getent("mortar_house_intact","targetname") ;
	damage2 = getent("mortar_house_damage_2","targetname");
	damage3 = getent("mortar_house_damage_3","targetname");
	bits = getent("mortar_house_damage_delete","targetname");
	clipper = getent("mortar_house_clip","targetname");
	trig = getent("mortar_house_dmg","targetname");	
	
	//turn off the dmg trigger
	getent("mortarpit_dmg","targetname") trigger_off();

	//flags
	dmg2 = false;
	dmg3 = false;

	//2nd damage state
	while(!dmg2)
	{
		trig waittill("damage",amount,attacker,dVec,P,type);
				
		if(is_player(attacker))
		{
			if(amount > 400) 
			{
				exploder(20);
				earthquake(.65 ,2,trig.origin,2000);
				intact hide();
				intact notsolid();
				damage2 show();
				damage2 solid();
				clipper trigger_on();
				clipper disconnectpaths();
				
				//trigger the killspawner trigger so that no more guys try to come into the ruined building
				ks = getent("script_killspawner_305","targetname");
				if(isDefined(ks))
				{
					ks notify("trigger");
				}

				guys = getaiarray("axis");
				players = get_players();
				for(i=0;i<guys.size;i++)
				{
					if(guys[i] istouching(trig))
					{
						guys[i] thread flamedeath(attacker);
					}
				}
				for(i=0;i<players.size;i++)
				{
					if(players[i] istouching(trig))
					{
						players[i] thread kill_player();
					}
				}				
				
				//setup the mortar hut animation for the 2nd damage state
				setup_mortarhut_anim();
				level.hut_destroyed = true;	;
				wait(.5);
				wait(.25);
//				trig notify("damage",amount,attacker,dVec,P,type);
//			}
//		}
//	}
//	
//	//3rd damage state
//	while(!dmg3)
//	{
		//trig waittill("damage",amount,attacker,dVec,P,type);
				
		//if(is_player(attacker))
		//{
			//if(type == "MOD_EXPLOSIVE" && amount >410)			//{

				exploder(21);
				playfx(level._effect["a_exp_mortarpit_bldg01"], intact.origin);
				earthquake(.55 ,3,trig.origin,2000);	
				playfx( level._effect["a_fire_smoke_med_int"], (893, -3908, -120));
				playfx( level._effect["a_fire_smoke_med_int"], (1008, -3960, -160));
				bits delete();	
				damage2 hide();
				damage2 notsolid();
				damage3 show();
				damage3 solid();				
				thread delete_pieces_after_animate();
				//animate the bigger chunks flying out of the building
				level.mortarhut_pieces thread anim_single_solo(level.mortarhut_pieces,"explode");
				dmg3= true;
				dmg2= true;
				getent("mortarpit_dmg","targetname") trigger_on();
				maps\_utility::arcademode_assignpoints( "arcademode_score_generic250", attacker );		
				wait(.25);
				stop_exploder(20);
			}
		}	
	}	
}

kill_player()
{
	self enableHealthShield( false );
	radiusDamage(self.origin, 128, self.health + 100, self.health + 100);
	self enableHealthShield( true );	
}


delete_pieces_after_animate()
{
	
	bigbits = getentarray("bigbits","script_noteworthy");
	loose_boards = getentarray("loose_boards","script_noteworthy");
	
	pieces = [];
	pieces = array_combine(bigbits,loose_boards);
	delete_pieces(pieces);
}

delete_pieces(pieces)
{
	wait(6);
	level.mortarhut_pieces moveto(level.mortarhut_pieces.origin + (0,0,-500),8);
	level.mortarhut_pieces waittill("movedone");
		
	for(i=0;i<pieces.size;i++)
	{
		pieces[i] unlink();
		pieces[i] delete();
	}
	level.mortarhut_pieces delete();
	
}

setup_mortarhut_anim()
{
	
	ent = getstruct("mortar_hut_anim","targetname");

	mdl = spawn("script_model",ent.origin);
	mdl  setmodel(level.scr_model["mortarpit_bunker"]);
	mdl.animname = "mortarpit_bunker";
	mdl SetAnimTree();
	level.mortarhut_pieces = mdl;
	
	bigbits = getentarray("bigbits","script_noteworthy");
	loose_boards = getentarray("loose_boards","script_noteworthy");
	
	bits = [];
	bits = array_combine(bigbits,loose_boards);
	for(i=0;i<bits.size;i++)
	{
		bits[i] show();
		bits[i] linkto( mdl, trim_targetname(bits[i].targetname));
	}
}


trim_targetname(targetname)
{
	
	strng = targetname;
	newstr = "";
	for(x=strng.size -1;x>12;x--)
	{
		newstr = strng[x] + newstr;
	}	
	return (newstr);
	
}

monitor_mg_bunker_damage()
{
	
	intact = getent("mortarpit_mghut_intact","targetname") ;
	damage1 = getent("mortarpit_mghut_wrecked","targetname");
	
	//chunks
	chunks = [];
	chunks[0] = getent("mortarpit_mghut_wrecked_chunk_1","script_noteworthy");
	chunks[1] = getent("mortarpit_mghut_wrecked_chunk_2","script_noteworthy");
	chunks[2] = getent("mortarpit_mghut_wrecked_chunk_3","script_noteworthy");
	chunks[3] = getent("mortarpit_mghut_wrecked_chunk_4","script_noteworthy");
	chunks[4] = getent("mortarpit_mghut_wrecked_chunk_5","script_noteworthy");
	chunks[5] = getent("mortarpit_mghut_wrecked_chunk_6","script_noteworthy");
	
	curtains = getent("event1_mg_curtains","targetname");
	mg = getent("auto4051","targetname");
	
	clipper = getent("mg_hut_clip","targetname");
	trig = getent("mg_hut_dmg","targetname");
	

	dmg1 = false;
	mg_gunner = false;
	//1st damage state
	while(!dmg1)
	{
		trig waittill("damage",amount,attacker,dVec,P,type);
		
		if(is_player(attacker))
		{
			if(amount >400)
			{
				owner = mg getturretowner();
				if(isDefined(owner))
				{
					mg_gunner = true;
				}							
				exploder(30);
				intact hide();
				intact notsolid();
				damage1 show();
				curtains hide();
				damage1 solid();
				earthquake(.51 ,3,mg.origin,1200);
				//playfx( level._effect["a_fire_smoke_med_int"], (2103, -4448.5, -15));
				
				players = get_players();			
				guys = getaiarray("axis");
				for(i=0;i<guys.size;i++)
				{
					if(guys[i] istouching(trig))
					{
						guys[i] thread flamedeath(attacker);
					}
				}
				
				for(i=0;i<players.size;i++)
				{
					if(players[i] istouching(trig))
					{
						players[i] thread kill_player();
					}
				}			
				
								
				for(x=0;x<chunks.size;x++)
				{
					chunks[x] delete();

				}
				
				clipper trigger_on();
				getent("mghut_fire_damage","targetname") trigger_on();
				clipper disconnectpaths();
				mg hide();
				dmg1 = true;
				level.hut_destroyed = true;				
				
				//do arcademode stuffs
				if(mg_gunner)
				{
					arcademode_assignpoints( "arcademode_score_generic1000", attacker );
				}
				else
				{
					arcademode_assignpoints( "arcademode_score_generic250", attacker );
				}
			}
		}
	}
}

stop_bunker_defenders()
{
	getent("stop_bunker_defenders","targetname") waittill("trigger");
	level notify("stop_bunker_defenders");
}

start_by_mortar_pits()
{
	battlechatter_off("allies");
	battlechatter_off("axis");
	init_usable_mortars();
	init_bunker_damage();
	
	trig = getent("after_mortar_trigger","script_noteworthy");
	trig trigger_off();
	
	flag_set("mortar_pits");
	level thread motar_pit_damage();
	level thread monitor_bunker_damage();
	level thread monitor_mg_bunker_damage();
		
	level thread e3_save_stairs();
	
	
	wait(1);
	kill_beginning_guys();
	
	
	trigs = getentarray("mortar_team","targetname");
	array_thread(trigs,maps\oki3_util::trigger_array_notify);
	
	level.player_move_speed = 180;
	
	setup_friendlies("mortar_pits");
	move_ai("mortar_pits_ai");
	level thread move_players("mortar_pits_players");	
	level waittill("introscreen_complete");
	
	//level thread spawn_mortarpit_ai();
	level thread mortar_objective();
	level thread dialogue_more_mortars();	
	level thread planter_battle();
	level thread rear_mortarpits_support();
	level thread spawn_mortarpit_dudes();
	level thread mortarpits_shoot_boards();
	//level thread spawn_grass_guys();	
	getent("spawn_mortar_guys","targetname") notify("trigger");
	getent("spawn_mortarpit_ai","script_noteworthy") notify("trigger");
	getent("mortar_stairs","script_noteworthy") notify("trigger");
	
	wait(1);
	getent("mortar_objective","targetname") notify("trigger");
	wait(5);
	battlechatter_on("allies");
	battlechatter_on("axis");
	level thread monitor_volume_for_enemies("mortarpit_front","front_cleared","mortarpits_front_chain");
	level waittill("front_cleared");
	autosave_by_name("mortarpits_front");
	
}

mortar_pacing_audio()
{
	trigger_wait("mortar_stairs","script_noteworthy");
	//TUEY setmusicstate PRE_MORTARS
	setmusicstate("PRE_MORTARS");
	
	//add xtra stuffs

	
}

spawn_mortarpit_dudes()
{
	trigger_wait("spawn_mortarpit_dudes","targetname");
	simple_floodspawn("mortarpit_dudes");
	level thread monitor_volume_for_enemies("mortarpit_front","front_cleared","mortarpits_front_chain");
	level.sarge thread do_dialogue("flank_round");
	level thread cleanup_front_ai();
	level thread setup_collectible_corpse();
}

cleanup_front_ai()
{
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if(ai[i].origin[1] > -1869.5)
		{
			ai[i] thread random_death(3,10);
		}
	}
	
}


rear_mortarpits_support()
{
	org_trigger((720, -3696, -176),208);
	simple_spawn("auto4071");
	
}


spawn_mortarpit_ai()
{
	trig = getent("spawn_mortarpit_ai","script_noteworthy");
	trig waittill("trigger");	
	level.polonsky thread do_dialogue("stairs");
	//spawn in the guys in the mortar pits
	wait(1);		

	trigs = getentarray("mortar_team","targetname");
	array_thread(trigs,maps\oki3_util::trigger_array_notify);
	flag_set("stop_fake_mortar");
	wait(1);

	level.sarge do_dialogue("push_forward");	
	
}

/*------------------------------------
battle in the garden area
------------------------------------*/
planter_battle()
{
	//turn off the trigger at the end
	trig = getent("courtyard_clear","targetname") ;
	trig trigger_off();
	
	getent("regroup_after_planters","targetname") trigger_off();
	
	
	//TUEY Set music state to POST_MORTARS
	setmusicstate("PLANTERS");

	//wait for player to enter building and split up the squad
	getent("split_squad_at_planter","script_noteworthy") waittill("trigger");	
	setup_planter_squads();
	level thread do_planter_dialogue();
	//remove_guy_from_squad();
	monitor_planter_spawners();	
	
	level waittill("courtyard_clear");
	trig notify("trigger");

	//TUEY Set music state to POST_MORTARS
	setmusicstate("PLANTERS_CLEARED");

	friends = getaiarray("allies");
	for(i=0;i<friends.size;i++)
	{
		friends[i] set_force_color("o");
	}
	
	objective_add(5,"current",&"OKI3_REGROUP",( 6031, -4012.5, 128 ));
	trig notify("trigger");
	getent("regroup_after_planters","targetname") trigger_on();	
	
	getent("regroup_after_planters","targetname") waittill("trigger");
	objective_state(5,"done");
	
		
	sarge_kick_door();

	level thread do_castle_dialogue();
		
	level.sarge set_force_color("o");
	level thread maps\oki3_courtyard::main();
	autosave_by_name("planters_battle_end");
}

do_planter_dialogue()
{
	battlechatter_off("allies");
	
	level.sarge do_dialogue("nearly_there");
	level.sarge do_dialogue("planes_enroute");
	level.polonsky do_dialogue("they_can_blow");
	wait(1);
	level.sarge do_dialogue("stay_alert");
	level.sarge do_dialogue("every_corner");
	wait(1);
	level.sarge do_dialogue("both_sides");
	level.sarge do_dialogue("hunt_down");
	
	battlechatter_on("allies");
	objective_add(5, "current",&"OKI3_OBJ6A",(5694, -4694.5 ,160.8));
	objective_ring(5);
	//TUEY Set the music state to PLANTERS after this exchange.
	setmusicstate("PLANTERS");
}

do_castle_dialogue()
{
	battlechatter_off("allies");
	level.sarge thread do_dialogue("this_way");
	wait(1);
	level.sarge do_dialogue("shhh");
		
	getent("building_L_spawners","targetname") waittill("trigger");
	wait(1);
	level.polonsky do_dialogue("shadows");
	wait(.5);	
	level.sarge thread do_dialogue("take_aim");
	wait(1);
	getent("building_L_friendly","targetname") notify("trigger");

}

monitor_planter_spawners()
{
	trigger_wait("front_planter_guys","script_noteworthy");
	
	//spawn in the first group of guys
	event3_front_planter_guys();

	wait(1);
	
	level thread monitor_ai_group("planters_left_front","planters_left_mid","squad_left_mid",2,"squad_left_advance");
	level thread monitor_ai_group("planters_right_front_mid","right_rear_enemies","squad_right_mid",1,"squad_right_advance");
	
	level thread planters_left_back();
	level thread planters_right_back();
	level thread planters_left_mid();
	level thread planters_right_rear();
	level thread stop_planter_spawners();
	level thread planter_battle_end();
//	wait(3);
//	level.sarge thread do_dialogue("multiple");
//	wait(2.5);
//	level.sarge thread do_dialogue("each_side");	
	
}

planters_left_back()
{
	level endon("planter_battle_finished");
	
	level waittill("squad_left_advance");
	waitfor_death("planters_left_back",1);
	getent("squad_left_back","script_noteworthy") notify("trigger");
	
}

planters_right_back()
{
	
	level endon("planter_battle_finished");
	
	level waittill("squad_right_advance");
	waitfor_death("planters_right_back",1);
	getent("squad_right_back","script_noteworthy") notify("trigger");
}

planters_right_rear()
{
	trigger_wait("right_rear_enemies","script_noteworthy");
	simple_spawn("planters_right_back");
	
}

planters_left_mid()
{
	trigger_wait("planters_left_mid","script_noteworthy");
	simple_spawn("planters_left_back");
}



monitor_ai_group(enemy_aigroup,next_enemy_spawners,friendly_advance_chain,guysalive,notification)
{
	
	next_enemy = getent(next_enemy_spawners,"script_noteworthy");
	next_pos = getent(friendly_advance_chain,"script_noteworthy");
	
	waitfor_death(enemy_aigroup,guysalive);
	next_enemy notify("trigger");
	next_pos notify("trigger");	
	level notify(notification);
	
}

waitfor_death(aigroup,numleft)
{
	
	level endon("planter_battle_finished");
	
	while(1)
	{
		enemies = get_ai_group_ai(aigroup);
		if(isDefined(enemies) && enemies.size > numleft)
		{
			wait .05;
		}
		else
		{
			break;
		}
	}
	
}

setup_planter_squads()
{
	guys = getaiarray("allies");
	for(i=0;i<guys.size;i++)
	{
		if(i %2)
		{
			guys[i] set_force_color("p");
			guys[i].purplesquad = true;
		}
		else
		{
			guys[i] set_force_color("b");
			guys[i].bluesquad = true;
		}
		}
	}
	
remove_guy_from_squad()
{
	guys = getaiarray("allies");
	psquad = false;
	bsquad = false;
	
	for(i=0;i<guys.size;i++)
	{
		if(isDefined(guys[i].purplesquad) &&  !psquad)
		{
			if(guys[i] != level.sarge && guys[i] !=  level.polonsky)
			{
				guys[i] notify( "_disable_reinforcement" );
				psquad = true;
			}
		}
		
		if(isDefined(guys[i].bluesquad) &&  !bsquad)
		{
			if(guys[i] != level.sarge && guys[i] !=  level.polonsky)
			{
				guys[i] notify( "_disable_reinforcement" );
				bsquad = true;
			}
		}
	}	
}


planter_battle_end()
{
	getent("planter_battle_end","script_noteworthy") waittill("trigger");
	
	getent("squad_right_back","script_noteworthy").color_enabled = false;// trigger_off();
	getent("squad_left_back","script_noteworthy").color_enabled = false;// trigger_off();
	
	level notify("planter_battle_finished");
	
	planters_fall_back();
	
	radius = getent("planter_end_radius","script_noteworthy");
	
	end = false;
	while(!end)
	{
		alive = false;
		guys = getaiarray("axis");
		for(i=0;i<guys.size;i++)
		{
			if( guys[i] istouching(radius))
			//if(distancesquared(guys[i].origin,radi.origin) < 1024 * 1024)
			{
				alive = true;
			}
		}
		if(!alive)
		{
			end = true;
		}
		wait 1;
	}
	level notify("courtyard_clear");	
}

planters_fall_back()
{
	
	radi = getent("planter_end_radius","script_noteworthy");
	nodes = getnodearray("510_fallback","script_noteworthy");
	guys = getaiarray("axis");
	for(i=0;i<guys.size;i++)
	{
		if( guys[i] istouching(radi))
		{
			guys[i] thread fallback_planters(nodes[randomint(nodes.size)]);
		}
	}
}

fallback_planters(spot)
{
	self endon("death");
	
	self.script_goalvolume = 510;
	self.goalradius = 256;
	self setgoalnode( spot );
	self waittill("goal");
	wait(5);
	self.ready_to_charge = 1;
}


banzai_wave_think()
{
	while(1)
	{
		wait(1);
		ai = getaiarray("axis");
		chargers = 0;
		for(i=0;i<ai.size;i++)
		{
			if(isAlive(ai[i]) && isDefined(ai[i].ready_to_charge) && chargers < 4)
			{
				self.banzai_no_wait = 1;
				self thread maps\_banzai::banzai_force();
				chargers++;
			}
		}
		if(chargers > 3)
		{
			wait(15);
			chargers = 0;
		}
	}
}


stop_planter_spawners()
{
	getent("stop_planter_spawners","script_noteworthy") waittill("trigger");
	
	empty_spawners("planters_left_back");
	empty_spawners("planters_right_back");
	
}


/*------------------------------------
various setup functions for Squadmanager spawners 
------------------------------------*/
setup_castle_spawners()
{
	self.targetname = "castle_gate_guy";
	self.goalradius = 64;
}

setup_behind_spawners()
{
	self.targetname = "castle_defend_guy";
	self.goalradius = 64;
}

setup_bunker_defenders()
{
	self.goalradius = 64;
}

setup_planter_spawners()
{
	self.targetname = "planter_guy";
	self.goalradius = 1024;
}

monitor_bunkers()
{
	self waittill("trigger");
	level notify("bunker_entered");
}


/*------------------------------------
sarge kicks the door open after the 
planters area battle
------------------------------------*/
sarge_kick_door()
{
	
	//anim_single_solo( guy, anime, tag, entity, tag_entity )
	anim_node = getnode("sarge_door_kick","targetname");
	anim_node anim_reach_solo(level.sarge, "door_kick");
	anim_node anim_single_solo(level.sarge,"door_kick");
}

open_planter_door(guy)
{
	door = getent("door_right","targetname");
	door playsound("door_kick");
	door connectpaths();
	waittillframeend;
	door rotateyaw(-115, 1, 0.25, 0.25);
}

/*------------------------------------
spawn in the mortar guys and deal with the objectives
------------------------------------*/
mortar_teams()
{
	trig = getent("spawn_mortar_guys","targetname");
	trig waittill("trigger");
	
	//stop the ambient mortars now that the mortarteams are being spawned in
	level notify( "stop_all_mortar_loops" );
	
	objective_position(5,(1492, -532, -423));
	objective_ring(5);
	
//	//spawn in the guys in the mortar pits
//	trigs = getentarray("mortar_team","targetname");
//	array_thread(trigs,maps\oki3_util::trigger_array_notify);
	level thread mortar_objective();
	level thread start_mortar_pits();
	level thread spawn_mortarpit_ai();
	level thread rear_mortarpits_support();
	level.polonsky thread do_dialogue("deeper");
	level thread mortar_pacing_audio();
	org_trigger( (1492, -532, -423),132);
	
	objective_position(5, ( 3110, -2565.5 ,-196));
	objective_ring(5);
	
	level thread setup_closet_ambush();
	
}


mortar_objective()
{	
	trig = getent("mortar_objective","targetname");
	trig waittill("trigger");
	
	//kill all the guys in the previous areas, like spiderhole dudes that maybe didn't pop off
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if(isDefined(ai[i].script_spiderhole))
		{
			ai[i] stopanimscripted();
			ai[i] delete();
		}
	}
	
	level notify("stop_mortar_fx");
	
	//TUEY setmusicstate MORTAR_PITS
	setmusicstate("MORTAR_PITS");
	
	update_mortar_objectives();
	guys = get_ai_group_ai("mortar_guys");	
	//monitor the mortar pit guys for when they die
	array_thread(guys,::monitor_mortar_guys);
	level thread dialogue_more_mortars();
	level thread spawn_grass_guys();
	
	level waittill("mortar_guys_dead");
	objective_string(5,&"OKI3_OBJ2");
	objective_state(5,"done");	
	
	objective_add(6,"current",&"OKI3_OBJ1",( 6031, -4012.5, 128 ));
	
	level notify("stop_trench_mortars");
	autosave_by_name("mortarpits_cleared");
	
}

dialogue_more_mortars()
{
	trigger_wait("mortarpits_front_chain","targetname");
	level.polonsky do_dialogue("more");
}

/*------------------------------------
updates the objective stars in the mortar pits
and plays the appropriate v.o.
------------------------------------*/
update_mortar_objectives()
{
	objective_delete(5);
	
	guys = get_ai_group_ai("mortar_guys");
	objective_add(5,"current");
	if(isDefined(guys) && guys.size > 0)
	{
		switch(guys.size)
		{
			case 1: objective_string(5,&"OKI3_OBJ2_1");break;
			case 2:	objective_string(5,&"OKI3_OBJ2_2");break;
			case 3:	objective_string(5,&"OKI3_OBJ2_3");break;
			case 4: objective_string(5,&"OKI3_OBJ2_4");break;
		}
		
		for(i=0;i<guys.size;i++)
		{
			if(i==0)
			{
				objective_position(5,guys[i].origin);
			}
			else
			{
				objective_additionalposition(5,i,guys[i].origin);
			}
			
		}
		
		wait( randomfloat(1.5) );
		switch(guys.size)
		{	
			case 1: level.sarge do_dialogue("take_last");level.sarge thread last_mortar_nag();break;
			case 2:	level.polonsky do_dialogue("second");level.polonsky do_dialogue("two_more");break;
			case 3:	level.sarge do_dialogue("one_down");break;
			case 4: level.polonsky do_dialogue("first");level.sarge do_dialogue("clear_em");break;
		}	
	}
	else
	{
		wait( randomfloat(1.5) );
		battlechatter_off("allies");
		level notify("mortar_guys_dead");
		flag_set("mortars_cleared");
		
		//TUEY Set music state to POST_MORTARS
		setmusicstate("POST_MORTARS");
		
		level.sarge do_dialogue("pits_clear");
		wait(1);
		level.sarge do_dialogue("east_bld");
		
	}
	
}


/*------------------------------------
nags the player to clear out the last mortar pit 
every 15-30 seconds if the player hasn't done it yet
------------------------------------*/
last_mortar_nag()
{
	level endon("mortar_guys_dead");
	level.sarge endon("death");
	
	while(!flag("mortars_cleared"))
	{
		wait(Randomintrange(15,30));
		if(randomint(100) >50)
		{
			level.sarge do_dialogue("do_it" + randomint(3));
		}
		else
		{
			level.polonsky do_dialogue("do_it" + randomint(3));
		}
	}
	
}

/*------------------------------------
waits for the mortar guy to be killed and
then updates the objectives

self = mortar operator 
------------------------------------*/
monitor_mortar_guys()
{
	self thread mortar_guy_alert();
	while(isAlive(self))
	{
		wait(1);
	}	
	update_mortar_objectives();
}


monitor_banzai_chargers()
{

	guys_alive = true;
	while(guys_alive)
	{
		guys = getentarray("banzai_guy","targetname");
		if(guys.size < 1)
		{
			guys_alive = false;
		}
		wait(1);
			
	}


	level notify("banzai_complete");
}


/*------------------------------------
drop the supplies 
------------------------------------*/
supply_drop( )
{
		
	level waittill("drop_supplies");		
			
	trig = getent("supply_drop_trigger","targetname");
	trig notify("trigger");
	
	level thread drop_supplies(1);
	level thread drop_supplies(2);
	level thread drop_supplies(3);
	level thread drop_supplies(4);
	level thread drop_supplies(6);
	
	wait(.25);
	
	for(i=1;i<5;i++)
	{
		plane = getent("drop_plane" + i,"targetname");
		plane thread plane_loop_sound();
	}
	
	
}


/*------------------------------------
drop the supplies from the plane
------------------------------------*/
drop_supplies(drop)
{
	
	drop_node = getvehiclenode("drop_supplies_" + drop,"targetname");
	
	drop_node waittill("trigger");
	
	plane = getent("drop_plane" + drop,"targetname");
		
	the_drop = getent("supply_drop" + drop,"targetname");
	
	switch(drop)
	{
		case 1:
			the_drop show();
			thread supply_drop_1();
			break;
						
		case 2:
			the_drop show();
			the_drop moveto( (the_drop.origin[0],the_drop.origin[1],40),randomintrange(5,12));
			the_drop thread delete_me();
			break;
			
		case 3:
		//	the_drop show();
		//	the_drop moveto( (the_drop.origin[0],the_drop.origin[1],248),randomintrange(5,12));
		//	the_drop thread delete_me();
			thread do_supply_drop(3,plane);
			break;
		
		case 4:
			thread do_supply_drop(4,plane);
			break;
			
		case 6:
			thread do_supply_drop(6,plane);

	}
	
	plane waittill("reached_end_node");
	plane delete();
	
}

delete_me()
{
	self waittill("movedone");
	self delete();
}


///*------------------------------------
//guys fall back once player blows the front gate
//------------------------------------*/
//fall_back_to_stairs()
//{
//
//	guys = getentarray("castle_defend_guy","targetname");
//	nodes = getnodearray("backline_retreaters","targetname");
//	nodecount = 0;	
//
//	if( isDefined(guys) &&  guys.size )
//	{
//		for(i=0;i<guys.size;i++)
//		{
//			if(nodecount < nodes.size)
//			{
//				guys[i].goalradius = 128;
//				guys[i] setgoalnode(nodes[nodecount]);
//				nodecount++;
//			}
//			else
//			{
//				guys[i] bloody_death( true, 2);
//			}
//		}		
//	}
//}

/*------------------------------------
make an enemy banzai the player
------------------------------------*/
#using_animtree("generic_human");
charge_at_player()
{

		banzai_runs = 3;
		num = randomint(banzai_runs);
		
		anim_string = undefined;
		the_anim 		= undefined;
		
		if (num == 0)
		{
			the_anim = %ai_bonzai_sprint_a;
			anim_string = "sprint_a";
		}
		else if (num == 1)
		{
			the_anim = %ai_bonzai_sprint_b;
			anim_string = "sprint_b";
		}
		else if (num == 2)
		{
			the_anim = %ai_bonzai_sprint_c;
			anim_string = "sprint_c";
		}
		else
		{
			the_anim = %ai_bonzai_sprint_c;
			anim_string = "sprint_c";		
		}
		
		if (isalive(self)  )
		{
				self.animname = "banzai";
				self.health = 100;
				self.targetname = "banzai_guy";
				self.meleeRange = 4096;
				self.meleeRangeSq = 4096*4096;
				self.goalradius = 64;
				self.a.combatrunanim = the_anim;
				self.preCombatRunEnabled = true;
				self.pathenemyFightdist = 64;
				self.pathenemyLookahead = 64;
				self setgoalentity(get_closest_player(self.origin));
				self.run_combatanim =	the_anim;
		}
}



ambient_mortars()
{
	//continue with the ambient mortars	in the trenches area
	maps\_mortar::set_mortar_delays( "trench_mortars", 1.25, 2.25,0.5, 1.25 );
	maps\_mortar::set_mortar_range( "trench_mortars", 1000, 15000 );
	maps\_mortar::set_mortar_damage( "trench_mortars", 100, 160, 100 );
	maps\_mortar::set_mortar_quake( "trench_mortars", 0.2, 3, 2048 );
	
	maps\_mortar::set_mortar_delays( "hill_mortars", 1.25, 2.25,0.5, 1.25 );
	maps\_mortar::set_mortar_range( "hill_mortars", 1000, 15000 );
	maps\_mortar::set_mortar_damage( "hill_mortars", 100, 160, 100 );
	maps\_mortar::set_mortar_quake( "hill_mortars", 0.15, 3, 5000 );

	
	//level thread maps\_mortar::mortar_loop( "trench_mortars", 1 );
	level thread maps\_mortar::mortar_loop( "hill_mortars", 1 );
	level thread maps\_mortar::mortar_loop( "ambush_mortars", 1 );	
}


//
///*------------------------------------
//damage the bunkers in the back area if a mortar is thrown on it
//
//------------------------------------*/
//bunker_damage(trig,bnkr)
//{
//	trigger = getent(trig,"targetname");
//	
//	bunker_intact = getent("mortar_bunker" + bnkr + "_intact","targetname");
//	bunker_busted = getent("mortar_bunker" + bnkr + "_busted","targetname");
//	bunker_clip = 	getent("bunker" + bnkr + "_clip","targetname");
//	bunker_playerclip = getent("bunker" + bnkr + "_playerclip","targetname");
//	
//	bunker_clip connectpaths();
//	bunker_clip trigger_off();
//	bunker_busted connectpaths();
//	bunker_intact connectpaths();
//	bunker_busted hide();
//	bunker_playerclip trigger_off();
//	
//	
//	damaged = false;
//	while(!damaged)
//	{
//		trigger waittill("damage",dmg,attacker,vDir,vPoint,dmgType);
//		
//		if(bnkr == 1)
//		{
//			level notify("stop_bunker_defenders");
//		}
//		
//		if(is_player(attacker))
//		{
//			if(dmgType == "MOD_EXPLOSIVE" && dmg >399)
//			
//			{
//				earthquake(.45 ,3,trigger.origin,1000);
//				p = getstruct("bunker_" + bnkr + "_fx","targetname");
//				playfx( level._effect["bunker_explode"] ,p.origin );
//				bunker_busted show();
//				bunker_intact delete();				
//				bunker_clip trigger_on();
//				bunker_playerclip trigger_on();
//				bunker_clip disconnectpaths();
//				damaged= true;
//				radiusdamage( p.origin,512,600,50);
//			}
//		}
//	}	
//	
//}

/*------------------------------------
detect damage on the mortar pits
------------------------------------*/
motar_pit_damage()
{
	
	trigs = getentarray("mortar_pit_damage","targetname");
	array_thread(trigs,::mortar_pit_damage_think);
		
}


/*------------------------------------
detect the mortars being thrown into the pits
self = damage trigger on each of the mortar pits
------------------------------------*/
mortar_pit_damage_think()
{
	self endon("stop_damage");

	while(1)
	{
		
		self waittill("damage",dmg,attacker,vDir,vPoint,dmgType);
			
		if(is_player(attacker) && dmgType == "MOD_EXPLOSIVE")
		{
			earthquake(.55 ,3,self.origin,1000);			

			if(dmg > 440)
			{
				playfx(level._effect["mortar_pit_debris"] ,self.origin + (0,0,15));
				ent = getent(self.script_noteworthy + "_radiusdamage","targetname");		
				if(isDefined(ent))
				{
					guys = getaiarray("axis");
					for(i=0;i<guys.size;i++)
					{
						if( distancesquared(guys[i].origin,ent.origin) < (256 * 256))
						{
							guys[i] thread flamedeath(attacker);
						}
					}
				}
				self notify("stop_damage");
			}
			
		}
	}	
}

///*------------------------------------
//breaks the sticktraps around the pits when damaged
//self = the unbroken sticktraps
//------------------------------------*/
//damage_sticktraps()
//{
//
//	self setmodel("static_okinawa_broken_sticktrap");
//
//}


/*------------------------------------
ambush near the supply drop to kick things off
------------------------------------*/
event1_tree_sniper_ambush()
{
	
	level.sniper_pawn thread event1_treesniper_pawn();
	
	
	//wait for players to get close
	org_trigger( (5754.5, 3062, -759),540);
	level thread supply_drop_objective();
	
	wait(1);	

	level thread enter_bunker_objective();
	level waittill("reaction_over");
	
	level.sarge.a.pose = "crouch";
	wait(2);	
	//simple_spawn("bunker_guy");
	
	level.sarge set_force_color("y");
	level.polonsky set_force_color("y");
	
	simple_spawn("e1_banzai_guys");
	getent("post_sniper_reaction","targetname") notify("trigger");
	wait(1);
	
	//TUEY setmusicstate AMBUSH
	setmusicstate("AMBUSH");	
	
//	level.polonsky do_dialogue("snipers");
	wait(1);	
	level.polonsky do_dialogue("sandbags");
	wait(.5);
	battlechatter_on("axis");
	toggle_ignoreall(1);
	wait(1);
	//level.polonsky do_dialogue("sandbags");
		
	battlechatter_on("allies");
	wait(1);
	level.sarge do_dialogue("eyes_wide");
	level.polonsky do_dialogue("in_weeds");
	level thread post_sniper_mortars();
	level thread friends_engage_snipers();
	wait(1.5);	
	simple_spawn("treesniper_climber",undefined,1);
	
	//alert all the snipers of an enemy
	snipers = getaiarray("axis");
	for(i=0;i<snipers.size;i++)
	{
		if(isAlive(snipers[i]))
		{
			snipers[i] notify("enemy");
		}
	}
	
	flag_set( "do_tree_fx" );
	battlechatter_off("allies");
	level.sarge do_dialogue("in_trees");
	level.sarge do_dialogue("take_down");
	battlechatter_on("allies");
	//level.polonsky allowedstances("prone","crouch","stand");

	wait(20);
	level notify("first_mortar");

	//TUEY Set Music State to MORTARS_INC
	setmusicstate("MORTARS_INC");

	level thread kill_tree_snipers();
	
	wait(2);

	level.sarge do_dialogue("incoming");
	if(!flag("bunker_entered"))
	{
		objective_state(2,"done");
		objective_add(3,"current",&"OKI3_TAKE_COVER",getent("bunker_entered","targetname").origin);
		level.bunker_objective = true;
	}	

	level thread find_bunker_tunnel();	

	getent("run_to_bunkers","targetname") notify("trigger");
	wait(.5);
	getent("post_reaction_mortars","targetname") notify("trigger");
	level.sarge thread get_to_bunker();
	level.polonsky thread get_to_bunker();
	wait(1);
	level thread mortar_push();
	level.polonsky do_dialogue("incoming");
	
}

get_to_bunker()
{
	self endon ("death");
	
	self.ignoreall = true;
	self.ignoreme = true;
	self waittill("goal");
	self.ignoreall = false;
	self.ignoreme = false;
	
}


kill_squad()
{
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
	{
	
		if(ai[i] != level.polonsky && ai[i] != level.sarge)
		{
			ai[i] thread random_death(1,3);
		}
	}
}


friends_engage_snipers()
{
	
	trig = getent("sniper_cover","targetname");
	cover_nodes = getnodearray("sniper_cover","targetname");
	nodecount = 0;	

	friends = getaiarray("allies");
	for(i=0;i<friends.size;i++)
	{
		if( friends[i] istouching(trig) && friends[i] != level.waver)
		{
				friends[i] thread runto_sniper_cover(cover_nodes[nodecount]);
				nodecount++;
		}		
	}	
}

setup_waving_guy()
{
	trig = getent("sniper_cover","targetname");
	waver = false;
	
	while(!waver)
	{
		friends = getaiarray("allies");
		for(i=0;i<friends.size;i++)
		{
			if( friends[i] istouching(trig))
			{
				if(!waver)
				{
					level.waver = friends[i];
					waver = true;
				}
			}	
		}
		wait(.1);
	}
	level.waver thread magic_bullet_shield();
	level thread e1_mortar_threshold();
	level thread waving_guy_move();
}

waving_guy_move()
{
	level waittill("first_mortar");
	
	if(!isDefined(level.mortar_threshold_reached) && isDefined(level.waver) )
	{
		level.waver thread waver_loop();
	}
}
waver_loop()
{
		level.waver endon("death");
		level.waver endon("stop_waving");
		
		level.waver.pacifist = true;
		level.waver.ignoreme = true;
		
		anim_node = getnode("waving_guy_anim","targetname");
		level.waver setgoalnode(anim_node);
		level.waver.goalradius = 64;
		level.waver waittill("goal");
		level.waver.is_at_goal = true;
		level.waver.animname = "redshirt";
		level.waver.spot = spawn("script_origin",anim_node.origin + (0,0,8));
		level.waver.spot.angles = anim_node.angles - (0,45,0);
		level.waver thread anim_loop_solo(level.waver, "get_into_bunker", undefined, "blowmeup",level.waver.spot);
		level thread blow_up_waver();
		

}

e1_mortar_threshold()
{
	trigger_wait("mortar_threshold","targetname");	
	level.mortar_threshold_reached = true;
	
	simple_spawn("bunker_guy");
	
}

blow_up_waver()
{	
	trigger_wait("kill_waver","targetname");
	
	while(!isDefined(level.waver.is_at_goal))
	{
		wait_network_frame();
	}
	
	anim_node = getnode("waving_guy_anim","targetname");
	//level.waver set_random_gib();
	level.waver set_random_gib();
	level.waver.deathanim =  %ch_oki3_waving_death;
	//ent = spawn("script_model", ( 5228,2110,-725 ));
	//level.waver.a.gib_ref = "right_leg";
	level.waver notify("blowmeup");
	level.waver.spot.angles = level.waver.spot.angles - (0,45,0);
	level.waver maps\_mortar::explosion_activate( "first_mortar", 96, 25, 25, 0.4, 3, 512 );
	//level.waver thread animscripts\death::do_gib();
	level.waver stop_magic_bullet_shield();
	level.waver.spot thread anim_single_solo(level.waver,"bunker_death");
	level.waver.allowdeath = true;
	wait(.1);
	level.waver dodamage(100,level.waver.origin);
	level.waver.health = 1;

//	wait(.1);
	//level.waver stopanimscripted();

}

blow_up_waver_old()
{	
	trigger_wait("kill_waver","targetname");
	
	level.waver notify("blowmeup");
	level.waver stopanimscripted();
	level.waver stop_magic_bullet_shield();
	level.waver.health = 1;
	
	level.waver set_random_gib();
	level.waver.deathanim =  %death_explosion_forward13;
	//ent = spawn("script_model", ( 5228,2110,-725 ));
	level.waver thread maps\_mortar::explosion_activate( "first_mortar", 96, 25, 25, 0.4, 3, 512 );

}





#using_animtree("generic_human");
runto_sniper_cover( node )
{
	self endon("death");
	if(!isDefined(self.magic_bullet_shield))
	{
		self thread magic_bullet_shield();
	}
	self ClearEnemy();
	self.ignoreall = true;
	self.goalradius = 64;
	self setgoalnode( node );
	//self thread waitfor_mortar_death();		
	self waittill("goal");
	self stop_magic_bullet_shield();
	self.ignoreall = false;
	


}

waitfor_mortar_death()
{
	self endon("death");
	
	level waittill ("first_mortar");
	self.health = 5;
	deathanim = [];
	deathanim[0] = %death_explosion_up10;
 	deathanim[1] = %death_explosion_back13;
	deathanim[2] = %death_explosion_forward13;
	deathanim[3] = %death_explosion_left11;
	deathanim[4] = %death_explosion_right13;
		
	self.deathanim = deathanim[randomint(deathanim.size)];
	
}

event1_tree_snipers()
{
	//simple_spawn("tree_sniper_guys",maps\oki3_tree_snipers::tree_sniper_spawner_func);
	trig = getent("setup_tree_snipers","script_noteworthy");
	trig notify("trigger");
	//trig waittill("trigger");
	wait(.15);
	
	level thread sniper_leafy_conceal();
	
	//grab all the tree sniper guys and make them sorta stealthy
	guys = getaiarray("axis");
	for(i=0;i<guys.size;i++)
	{
		guys[i] ClearEnemy();
		guys[i].ignoreme = true;
		guys[i].ignoreall = true;
		guys[i].pacifist = true;
		guys[i].pacifistwait = .05;
		guys[i] allowedstances("crouch");
		guys[i] thread tree_sniper_think();
	}

}



tree_sniper_think()
{	
	self endon("death");
		
	self waittill("enemy");	
	self.pacifist = false;
	self.ignoreall = false;
	self.ignoreme = false;
	//self.disableaimassist = false;
	//self.activatecrosshair = true;
	level notify("owned");	

}


find_bunker_tunnel()
{
	
	//polonsky finds the tunnel entrance in the bunker
	level thread polonsky_finds_tunnel();
	
	//wait for players to exit the tunnel
	level thread post_mortar_ambush();
	
	//add new objective
	tunnel = getent("tunnel_entered","targetname");

	//wait for the players to jump in the tunnel
	tunnel waittill("trigger",user);
	thread kill_squad();	
	flag_set("tunnel_entered");
	simple_spawn("auto3757");
	// TUEY Set Music State to TUNNEL
	setmusicstate("TUNNEL");

	thread warp_players("tunnel_entered",user);
	
	//setup the guys in the tunnel
	level thread setup_tunnel_guys();
	level thread setup_tunnel_radio();	
	
	//update the objective once the tunnel is entered
	objective_position(4,(3007, 2213, -947));
	objective_ring(4);
	
	wait(1);
	level.polonsky.lid linkto(level.polonsky,"tag_weapon_left");
	level.polonsky.anim_spot anim_single_solo(level.polonsky,"close_tunnel");
	level.polonsky.lid unlink();
	level.polonsky.anim_spot delete();
	level.polonsky.ignoreall = false;
	level.polonsky.grenadeawareness = 1;
	level.sarge.ignoreall = false;
	level.sarge.grenadeawareness = 1;
	level.sarge thread do_dialogue("good_luck");
	
	// waits for players to get close enough to the guys in the tunnel before making them
	// aware of any enemies
	level thread wakeup_tunnel_guys();
	
	level waittill("tunnel_guys_alerted");

	//Set Music State to AMBUSH_DUEX
	setmusicstate("TUNNEL_AMBUSH");

	level.mortars_falling = false;
	wait(randomfloatrange(1,3));
	simple_spawn("auto3816",::spawn_func_tunnel_defender);	
	
}


spawn_func_tunnel_defender()
{
	self endon("death");
	self.goalradius = 64;
	self.ignoreall = true;
	wait(3);
	self.ignoreall = false;	
}

kill_tree_snipers()
{	

	spawners = getentarray("outer_guys","targetname");
	for(i=0;i<spawners.size;i++)
	{
		spawners[i].count = 0;
	}	
	
	guys = getaiarray("axis");	
	for(i=0;i<guys.size;i++)
	{
		if(!isDefined(guys[i].is_tunnelguy))
		{
			guys[i] thread random_death(1,8);
		}
	}	
}

polonsky_finds_tunnel()
{
	wait(.5);
	tunnel_node = getnode("find_tunnel","script_noteworthy");
	level.polonsky set_force_color("g");
	level.polonsky.goalradius = 32;
	level.polonsky.ignoreall = true;
	level.polonsky.grenadeawareness = 0;
	level.sarge.grenadeawareness = 0;
	level.polonsky setgoalnode(tunnel_node);
	level.polonsky waittill("goal");
	flag_wait("bunker_entered");
		
 	event1_tunnel_dialogue();
 	
	level.polonsky.animname = "polonsky";
	anim_node = getnode("waving_guy_anim","targetname");
	spot = spawn("script_origin",anim_node.origin);
	spot.angles = (0, 214.3, 0);

	level.polonsky.anim_spot = spot;
	spot anim_reach_solo(level.polonsky,"find_tunnel");
	level thread enter_tunnel_nag();
	spot anim_single_solo(level.polonsky,"find_tunnel");
	spot thread anim_loop_solo(level.polonsky,"open_tunnel",undefined,"shut_trap");
	
	battlechatter_on("allies");
}

event1_tunnel_dialogue()
{
	
	battlechatter_off("allies");
	battlechatter_off("axis");
	
	level.sarge do_dialogue("spotters");
	level.sarge do_dialogue("take_out");
}

enter_tunnel_nag()
{
	wait(3);
	while(!flag("tunnel_entered"))
	{
		level.polonsky do_dialogue("miller");
		wait(randomintrange(7,13));
	}
	
}

/*------------------------------------
makes the guard alert to players
------------------------------------*/
wakeup_tunnel_guys()
{
	//trig = getent("wakeup_tunnel_guys","targetname");
	//trig waittill("trigger");
	org_trigger( ( 3793, 2329, -1030.5 ),71);
	
	guys = get_ai_group_ai("e1_tunnel_guys");
	for(i=0;i<guys.size;i++)
	{
		if(guys[i].script_noteworthy == "guard_guy")
		{
			guys[i].pacifist = false;
		}
	}	
}

#using_animtree("generic_human");
setup_tunnel_guys()
{
	
	level.banzai_guys = 0;
	wait(.5);
	guys = get_ai_group_ai("e1_tunnel_guys");
	table_guys = [];
	for(i=0;i<guys.size;i++)
	{
		if(isDefined(guys[i].script_noteworthy)) //; && guys[i].script_noteworthy == "periscope_guy")
		{
			guys[i] clearenemy();
			
			switch(guys[i].script_noteworthy)
			{
				case "periscope_guy":
					guys[i].animname = "tunnel_guy5";
					guys[i] animscripts\shared::placeWeaponOn( guys[i].primaryweapon, "none");

					guys[i] thread guy_detect_enemy();
					getnode("auto3795","targetname") thread anim_loop_solo( guys[i], "telescope", undefined);
					break;
				case "map_guy":
					guys[i].animname = "table_guy1";
					//guys[i] animscripts\shared::placeWeaponOn( guys[i].primaryweapon, "none");
					guys[i] thread guy_detect_enemy();

					table_guys = add_to_array(table_guys,guys[i]);
					break;
				case "radio_guy":
					guys[i].animname = "table_guy2";
					//guys[i] animscripts\shared::placeWeaponOn( guys[i].primaryweapon, "none");
					guys[i] thread guy_detect_enemy();

					table_guys = add_to_array(table_guys,guys[i]);
					break;
				case "officer_guy":
					guys[i].animname = "table_guy3";
					//guys[i] animscripts\shared::placeWeaponOn( guys[i].primaryweapon, "none");
					guys[i] thread guy_detect_enemy();

					table_guys = add_to_array(table_guys,guys[i]);
					break;
					
				case "map_guy2":
					guys[i].animname = "table_guy4";
					//guys[i] animscripts\shared::placeWeaponOn( guys[i].primaryweapon, "none");
					guys[i] thread guy_detect_enemy();
					table_guys = add_to_array(table_guys,guys[i]);
					break;
				
				case "guard_guy":
					guys[i].animname = "generic";
					guys[i] thread maps\_patrol::patrol( guys[i].target );
					//guys[i] thread guard_waitfor_death();
					guys[i] thread guard_monitor_for_enemy();
					guys[i].maxsightdistsqrd = 384*384;
					guys[i].pacifist = true;
					break;
			}
		}
	}
	anim_org = getstruct("table_org","targetname");
	anim_org thread anim_loop ( table_guys, "arguing", undefined, "stop_arguing" ,anim_org);
	level thread table_dialog(table_guys);
	//kill the enemies outside the bunker
	kill_tree_snipers();
}

table_dialog(guys)
{
	level endon("tunnel_guys_alerted");
	
	while(!isDefined(level.tunnel_guys_alerted))
	{
		guys[1] animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["table_guy2"]["contact"], 1.0, "dialogue_done" );
		guys[1] waittill("dialogue_done");
		
		guys[0] animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["table_guy1"]["good"], 1.0, "dialogue_done" );
		guys[0] waittill("dialogue_done");
		guys[0] animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["table_guy1"]["hay"], 1.0, "dialogue_done" );
		guys[0] waittill("dialogue_done");		
		guys[2] animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["table_guy3"]["3rdbattery"], 1.0, "dialogue_done" );
		guys[2] waittill("dialogue_done");
		guys[2] animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["table_guy3"]["kurma"], 1.0, "dialogue_done" );
		guys[2] waittill("dialogue_done");
		guys[2] animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["table_guy3"]["continue"], 1.0, "dialogue_done" );
		guys[2] waittill("dialogue_done");
		
	}	
}

guy_detect_enemy()
{
	
	self.allowdeath = true;
	self.ignoreme = true;
	self.pacifist = true;
	self.pacifistwait = 0.05;
	self.is_tunnelguy = true;
	
	self waittill_any("enemy","damage","death","bulletwhizby");
	guys = get_ai_group_ai("e1_tunnel_guys");
	for(i=0;i<guys.size;i++)
	{
		if(isDefined(guys[i].script_noteworthy) && guys[i].script_noteworthy== "guard_guy")
		{
			guys[i] notify("enemy");
		}
	}
}

/*------------------------------------
the guard waits for an enemy, then alerts 
the other guys
------------------------------------*/
guard_monitor_for_enemy()
{
	
	self.is_tunnelguy = true;
	
	self waittill_any("enemy","death","damage","bulletwhizby");	
	alert_tunnel_guys();
	
}

alert_tunnel_guys()
{
	if(!isDefined(level.tunnel_guys_alerted))
	{
		level.tunnel_guys_alerted = true;
		guys = get_ai_group_ai("e1_tunnel_guys");
		array_thread(guys,::alert_tunnel_guy);
	}
	level notify("tunnel_guys_alerted");
	level.tunnel_guys_alerted = true;
	
	//tuey set music state to TUNNEL_ENEMIES
	setmusicstate("TUNNEL_AMBUSH");	
	
	//stop the ambush and trench mortars
	level._explosion_stop_barrage["ambush_mortars"] = true;
	wait(randomintrange(1,4));
	level._explosion_stop_barrage["dirt_mortar"] = true;
		
}

/*------------------------------------
guys react
------------------------------------*/
alert_tunnel_guy()
{
	self endon("death");
	
	anim_org = getstruct("table_org","targetname");
	periscope_org = getnode("auto3795","targetname");
	
	if(isDefined(self.script_noteworthy) && self.script_noteworthy != "guard_guy")
	{	
		wait(randomfloatrange(0.05,.5));
		
		self stopanimscripted();
		
		//guy on the binoculars needs his weapon back
		if(self.script_noteworthy == "periscope_guy")
		{
			periscope_org anim_single_solo( self, "react" );
			weapon = self.sidearm;
			self animscripts\shared::placeWeaponOn( weapon, "right");
		}
		else
		{
			anim_org anim_single_solo( self, "react" );
		}
		
		//put two guys into banzai mode
		if(self.script_noteworthy == "map_guy")
		{
			self.ignoreall = false;
			self.maxsightdistsqrd = 1024*1024;
			self.pacifist = false;
			self.goalradius = 64;
			self thread maps\_banzai::banzai_force();
			level.banzai_guys++;
			
		}
		else
		{

			self.ignoreall = false;
			self.maxsightdistsqrd = 1024*1024;	
			self.pacifist = false;
			if(level.banzai_guys < 2)
			{
				self.goalradius = 64;
				self.banzai_no_wait = 1;
				self thread maps\_banzai::banzai_force();
				level.banzai_guys++;
			}
			
		}	
	}	
}

banzai_wait()
{
	self endon("death");
	
	self.goalradius = 64;
	self.banzai_no_wait = 1;
	self thread maps\_banzai::banzai_force();
		
}

setup_tunnel_radio()
{
	level endon("tunnel_exited");
	
	broken_radio = "radio_jap_bro";
	radio = getent("tunnel_radio","targetname");
	radio playloopsound("oki3_radio");
	broken = false;
	radio setcandamage(true);
	
	while(!broken)
	{
		radio waittill("damage",amt,attacker);		
		if( isplayer(attacker))
		{
			playfx(level._effect["zort"],radio.origin + (randomintrange(-10,10),randomintrange(-10,10),randomintrange(1,10)));
			radio stoploopsound();
			radio playsound("radio_destroyed");
			radio setmodel(broken_radio);
			maps\_utility::arcademode_assignpoints( "arcademode_score_generic250", attacker );
			broken = true;
		}
	}	
	x = 0;
	while(x<12)
	{
		wait(randomfloatrange(.5,2));
		playfx(level._effect["zort"],radio.origin + (randomintrange(-10,10),randomintrange(-10,10),randomintrange(1,10)) );
		radio playsound("radio_destroyed");
		x++;
	}
	
}




/*------------------------------------
guy who gets worked by the sniper
------------------------------------*/
event1_treesniper_pawn()
{

	//make him invulnerable so players can't shoot him 
	if(!isDefined(self.magic_bullet_shield))
	{
		self thread magic_bullet_shield();
	}

	//guy will get sniped in 4/6 seconds, or if the player trips the trigger ahead of the supply drop
	level thread wait_for_snipe();
	
	//wait for all the conditions to be met, and then snipe the dude
	level waittill_multiple("snipe","polonsky_supplies","sarge_supplies","pawn_supplies","safe_to_snipe");
	
	//the guy stops gathering supplies and slumps over the bag
	level notify("stop_supply_drop");
	self.deathanim = %ch_oki3_snipershot_guy2_out;
	self.nodeathragdoll = true;
		
	magicbullet("type99_rifle_scoped",( 5757, 1697, -275),self gettagorigin("J_HEAD"));
	bullettracer(( 5757, 1697, -275),self gettagorigin("J_HEAD"),true);
	playsoundatposition("weap_arisaka_fire",( 5757, 1697, -275));
	forward = AnglesToForward( (0 ,90, 0) );
	self thread oki3_pop_helmet();
	
	if( is_mature() )
	{
		PlayFX( level._effect["headshot"], self GetTagOrigin( "J_HEAD" ), forward );
	}
	
	if(isDefined(self.magic_bullet_shield))
	{
		self stop_magic_bullet_shield();
	}	
		
	//polonsky & sarge react to the sniper shot
	guys = [];
	guys[0] = level.sarge;
	guys[1] = level.polonsky;
	
	anim_node = getent("supply_drop_org","targetname");
	self stopanimscripted();
	self set_force_color("o");
	self dodamage(self.health + 100,self.origin);
	level notify("owned");
	level.polonsky thread sniper_dialogue();
	simple_spawn("bunker_guy");
	simple_floodspawn("outer_guys");	
	//force polonsky to stay prone for a few seconds so he transitions out of the anim better
	level.polonsky thread polonsky_prone();	
	anim_node anim_single(guys,"supply_out",undefined,anim_node);
	level notify("reaction_over");
}

sniper_dialogue()
{
	wait(.5);
	level.polonsky do_dialogue("snipers");
	level.polonsky do_dialogue ("where_are");
	
}

/*------------------------------------
polonsky stays prone for a few seconds and transitions out of the reaction anim a bit nicer
------------------------------------*/
polonsky_prone()
{
	self endon("death");
	self.a.pose = "prone";
	self allowedstances("prone");// allowedstances("prone");
	wait(1.5);
	self allowedstances("prone","crouch","stand");
	self.a.pose = "crouch";
	wait(.25);
	
	
}

/*------------------------------------
these functions help to handle cases where the guy is sniped
------------------------------------*/
wait_for_snipe()
{
	level thread wait_for_trigger_snipe();
	wait(randomfloatrange(4.5,6));
	level notify("snipe");
}

wait_for_trigger_snipe()
{
	trigger_Wait("trigger_snipe","targetname");
	level notify("snipe");
}


/*------------------------------------
mortars start to fall after the sniper ambush
------------------------------------*/
post_sniper_mortars()
{
	
	//explosion_activate( mortar_name, blast_radius, min_damage, max_damage, quake_power, quake_time, quake_radius, dust_points )

	level waittill("first_mortar");
	
	//drop a few mortars before the "big one" 
	pre1 = spawnstruct();
	pre1.origin = ( 4010.5, 3338 ,-775.9 );
	pre1.is_struct = true;
	pre2 = spawnstruct();
	pre2.origin = ( 5044.5, 2548.5, -758.4 );
	pre2.is_struct = true;
	pre1 maps\_mortar::explosion_activate( "first_mortar", 128, 25, 50 );
	pre2 thread maps\_mortar::explosion_activate( "first_mortar", 236, 25, 50 );
	
	wait(randomfloatrange(.2,1.2));
	pre3 = spawnstruct();
	pre3.origin = (5293.4, 2676.2, -745.4);
	pre3.is_struct = true;
	pre3 thread maps\_mortar::explosion_activate("first_mortar",128,25,50);

	wait(1);
	
	//we were blowing up lots of trees at one point, but now we jsut have one lonely tree :(
	level thread palm_trees();
	
	wait(2);
	
	//ambient mortar explosions to the south and behind the player
	level thread maps\_mortar::mortar_loop( "dirt_mortar", 1 );
	level thread maps\_mortar::mortar_loop( "hill_mortars",1);
	level thread maps\_mortar::mortar_loop( "ambush_mortars",1);
}

/*------------------------------------
makes a tree explode via a nearby mortar impact
------------------------------------*/
burst_tree(tree_intact,tree_destroyed)
{
	
	ent = spawnstruct();
	ent.origin = (tree_intact.origin );
	ent.is_struct = true;
	ent thread maps\_mortar::explosion_activate( "first_mortar", 128, 25, 50 );
	while(1)
	{
		level waittill("explosion",exp_name);
		if(exp_name == "first_mortar")
		{
			tree_intact hide();
			tree_destroyed show();	
			playfx(level._effect["tree_burst"],tree_destroyed.origin);
			break;
		}
	}
	
}

/*------------------------------------
explode some trees
------------------------------------*/
palm_trees()
{
	
	//wait(randomintrange(2,5));
	//level thread burst_tree( getent("tree3_intact","targetname"),getent("tree3_destroyed","targetname") );	
	wait(randomintrange(2,5));
	level thread burst_tree(level.tree2,level.tree2d );	
	//wait(randomintrange(1,3));
	//level thread burst_tree( level.tree4,level.tree4d );
	
	
}

/*------------------------------------
handle objectives/dialogue for when the 
squad runs into the bunker after the mortar start falling
------------------------------------*/
mortar_push()
{
	level.mortars_falling = true;
	battlechatter_off("allies");
	wait(2);
	level.sarge do_dialogue("find_cover");
	battlechatter_on("allies");
	wait(13);
	if(!flag("bunker_entered"))
	{	
		battlechatter_off("allies");
		level.sarge do_dialogue("find_cover");
		battlechatter_on("allies");
	}
	wait(10);
	
	//after about 25 seconds, the players will get damaged/killed by falling mortars if they are not in the bunker
	while( level.mortars_falling )
	{
		wait(2);
		check_players_in_bunker();
	}

	level notify("stop_all_mortar_loops");
}


/*------------------------------------
players get ammo from supply drop
------------------------------------*/
supply_drop_objective()
{
	
	org_trigger( (5718.5, 3149, -759),386);
	level thread take_ammo_from_supplydrop();	
	
	//warp any slackers
	event1_warp_supplydrop();
	
	level notify("safe_to_snipe");
	objective_string(2,&"OKI3_OBJ5");
	objective_current(2);
	autosave_by_name("supply_drop_secured");
	
	level thread setup_waving_guy();
	
	
}

/*------------------------------------
display the "get to cover" objective if the player
is not alread in the bunker when the mortars start falling
------------------------------------*/
enter_bunker_objective()
{

	trig = getent("bunker_entered","targetname");	
	trig waittill("trigger");
	
	if(isDefined(level.bunker_objective))
	{
		objective_state(3,"done");
		level thread autosave_by_name("post_sniper_bunker_entered");
	}
	
	flag_set("bunker_entered");
}


/*------------------------------------
japanese ambush the player after coming out of the tunnel
------------------------------------*/
post_mortar_ambush(not_start)
{
	
	//stop the mortar barrage
	getent("stop_mortars","targetname") waittill("trigger");
	
	battlechatter_off("allies");
	battlechatter_off("axis");
	
	level thread spiderhole_ambush_chatter();
	
	level thread post_mortar_fx();
	simple_spawn("satchel_thrower");
	simple_spawn("squad_2");
	
	level.sarge set_force_color("o");
	level.polonsky set_force_color("o");
	level.polonsky.goalradius = 512;
	
	if(!isDefined(not_start))
	{
		mover1 = spawn("script_origin",level.sarge.origin);
		mover2 = spawn("script_origin",level.polonsky.origin);
		level.sarge linkto(mover1);
		level.polonsky linkto(mover2);
		mover1 moveto( (2790.5, 2051, -819.8),.1);
		mover2 moveto( (2914.5, 2036 ,-814.8),.1);
		wait(1);
		mover1 delete();
		mover2 delete();
	}
	
	level.sarge thread sarge_spiderhole_ambush();
		
	level thread bunker_cleared_think();

	level thread spiderhole_stabbins();
	//level thread ambush_friendly_movement();
	//level thread spiderhole_ambush_jumpin();
	level thread spiderhole_ambush_flipover();
	
	getent("pop_smoke","targetname") waittill("trigger");	
		
	level.spiderholes_triggered = true;				
	wait(3);

	wait(randomfloatrange(.05,1));	
	getent("spiderhole_ambush","targetname") notify("trigger");
	
	//TUEY Set Music State to Spider Holes
	setmusicstate("SPIDER_HOLES");

	//simple_spawn("melee_guy1");
	
	thread post_spiderhole_think();
	wait(1);
	
	level thread event1_spawn_rear_defenders();
	level thread event1_rear_fallback();
	level thread event1_front_fallback();
}

event1_spawn_rear_defenders()
{
	
	trigger_wait("spawn_rear_defenders","script_noteworthy");
	simple_floodspawn("rear_defenders");

}

sarge_spiderhole_ambush()
{
	self disable_ai_color();
	self.goalradius = 32;
	self setgoalnode( getnode("spiderhole_roebuck","targetname"));
	self waittill("goal");
	self.goalradius = 256;
	trigger_wait("test_ambush","targetname");
	self enable_ai_color();
}


spiderhole_ambush_chatter()
{
	trigger_wait("spiderhole_ambush","targetname");
	simple_spawn("banzai_ambush_guys");
	level.sarge do_dialogue("spiderholes");
	//level.polonsky do_dialogue("sobs");
	level.sarge do_dialogue("watch_more");
	battlechatter_on("axis");
	battlechatter_on("allies");
	ignoreall_off(getaiarray("allies"));
	level thread sarge_fight_dialogue();
}

sarge_fight_dialogue()
{
	trigger_wait("post_spiderhole_infantry","script_noteworthy");
	//wait(.5);
	//level.sarge do_dialogue("push");
	//battlechatter_on("allies");
	wait(5);
	//battlechatter_off("allies");
	//wait(.5);
	level.sarge do_dialogue("focus_hill");
	wait(1);
	level.sarge do_dialogue("spread_out");
}

stop_ambient_mortars()
{
	level.mortars_falling = false;
}

post_spiderhole_think()
{
	
	level thread post_spiderhole_floodspawner();
	//wait 3 seconds then send in more ambushers over the wall
	wait(2);
	simple_spawn("upper_mg_guy");
	//getent("post_spiderhole_infantry","script_noteworthy") notify("trigger");
	level thread monitor_spiderhole_ambush();
	//wait a bit then allow the player to move faster 
	wait(5);
	
	level.player_move_speed = 180;
	//mg guy on top of main gate
	wait(10);
	battlechatter_off("allies");
	level.sarge do_dialogue("mg");
	battlechatter_off("allies");
	wait(4);
	battlechatter_off("allies");
	level.sarge do_dialogue("mg_nag");
	battlechatter_on("allies");
}

post_spiderhole_floodspawner()
{
	//trigger_wait("post_spiderhole_infantry","script_noteworthy");
	defenders = getentarray("auto3792","targetname");
	
	for(i=0;i<defenders.size;i++)
	{
		defenders[i] thread maps\_spawner::flood_spawner_think();
		wait(.15);
	}
}

spiderhole_ambush_flipover()
{
	anim_org = getent("flipover","targetname");
	temp_node = getnode("flipover","targetname");
	
	//send polonsky
	guy1 = level.polonsky;
	
	guy1.ignoreme = true;
	guy1.ignoreall = true;
	guy1.goalradius = 96;
	guy1 setgoalnode(temp_node);
	guy1 set_force_color("g");
	
	while(!isDefined(level.spiderholes_triggered))
	{
		wait .05;
	}
	
	guy2 = undefined;	
	while(!isDefined(guy2))
	{
		//get the guy who jumped from the spiderhole
		guys = get_ai_group_ai("spiderhole_ambushers");
		for(i=0;i<guys.size;i++)
		{
			if(isDefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "flipover")
			{
				guy2 = guys[i];
				guy2 thread magic_bullet_shield();
				break;
			}
		}
		wait (.01);
	}
	guy2 waittill("out_of_spiderhole");
	guy2.allowdeath = false;
	guy2.ignoreall = true;
	guy2.ignoreme = true;
	guy2 clearenemy();
	// Set up the animnames from the anim_loader function
	guy1.animname = "jumpin_guy2";
	guy2.animname = "jumpin_guy1";
	//guy2.deathanim = %ch_bayonet_jumpin_guy1;

	// Set up the array of guys to pass into the anim_loop
	flip_array = [];
	flip_array = array_add ( flip_array, guy1 );
	flip_array = array_add ( flip_array, guy2 );
	//anim_org anim_reach ( bayonet_array, "flipover", undefined, undefined, anim_org);
	if(isAlive(guy2))
	{
		guy2.allowdeath = false;
		
 		anim_org thread anim_single ( flip_array, "jumpin");
 		guy2 stop_magic_bullet_shield();
	 	guy2 doDamage(guy2.health + 5,(0,180,48));
	}	
	
	guy1.ignoreme = false;
	guy1.ignoreall = false;	
	guy1 set_force_color("o");
	guy1.goalradius = 512;	
	
}


/*------------------------------------
friendly gets owned by a guy jumping out of the spiderhole
can be interrupted ( save the friendly )
------------------------------------*/
spiderhole_stabbins()
{

	guys = [];
	
	dudes = simple_spawn("ambush_stabber",::setup_stabber);
	guys[0] = dudes[0];
	guys[1] = choose_random_guy();
	guys[1].ignoreall = true;

	
	level.stabber= guys[0];
	level.stabee = guys[1];
	
	guys[1].animname = "ambush_stabee";
		
	anim_spot = getnode("new_stabe_node","targetname");
	anim_spot anim_reach_solo(guys[1],"ambush_stab",undefined,anim_spot);	
	guys[1] thread anim_loop_solo(guys[1],"ambush_loop",undefined,"stop_ambush_loop",anim_spot);
	guys[0] thread arcademode_kill_staber();
	trigger_wait("pop_smoke","targetname");
	guys[1] notify("stop_ambush_loop");
	anim_spot thread anim_single(guys,"ambush_stab",undefined,anim_spot);
	level thread open_spiderhole();
	level thread maps\oki3_anim::staber_canbe_killed(guys[0]);
	
	wait(3);
	getent("test_ambush","targetname") notify("trigger");
}


arcademode_kill_staber()
{
	
	self waittill("death");
	if(isDefined(self.attacker) && isPlayer(self.attacker))
	{
		maps\_utility::arcademode_assignpoints( "arcademode_score_generic500", self.attacker );
	}
}

open_spiderhole()
{
	wait(.15);
	lid = getent("stabber_lid","script_noteworthy");
	lid playsound("spider_hole_open");

	tag_origin = Spawn( "script_model", lid.origin );
	tag_origin SetModel( "tag_origin_animate" );

	tag_origin.angles = (0 ,135, 0);//lid.angles;

	lid LinkTo( tag_origin, "origin_animate_jnt");

	tag_origin assign_animtree( "spiderhole_lid" );
	tag_origin SetAnimKnob( level.scr_anim["spiderhole_lid"]["jump_out"], 1, 0.2, 1 );

}

setup_stabber()
{
	self.ignoreme = true;
	self.pacifist = true;
	self.pacifist_wait = 0.05;
	self.ignoreall = true;
	self.animname = "ambush_staber";
	level notify("stabber_setup");

}

spiderhole_ambush_jumpin()
{
	
	//send the redshirt to the location
	guy2 = undefined;
	while(!isDefined(guy2))
	{
		guy2 = choose_random_redshirt("bayonet_stab",512);
		wait(.05);
	}	
	guy2 set_force_color("g");
	level.guy2 = guy2;
	anim_org = getent("bayonet_stab","targetname");
	temp_node = getnode("bayonet_stab","targetname");
	guy2.ignoreme = true;
	guy2.allowdeath = false;
	guy2.ignoreall = true;
	guy2.goalradius = 8;
	guy2 setgoalnode(temp_node);
	guy2 set_force_color("g");
	
	while(!isDefined(level.spiderholes_triggered))
	{
		wait .05;
	}
	
	//wait for the guy to spawn in and jump out of the spiderhole
	guy1 = undefined;	
	while(!isDefined(guy1))
	{
		//get the guy who jumped from the spiderhole
		guys = get_ai_group_ai("spiderhole_ambushers");
		for(i=0;i<guys.size;i++)
		{
			if(isDefined(guys[i].script_noteworthy) && guys[i].script_noteworthy == "bayonet_guy1")
			{
				guy1 = guys[i];
				break;
			}
		}
		wait (.01);
	}
	guy1 thread magic_bullet_shield();
	guy1.ignoreme = true;
	guy1.ignoreall = true;
	guy1 ClearEnemy();
	guy1 waittill("out_of_spiderhole");
	wait(.3);
	guy1.allowdeath = false;
	guy1.ignoreme = true;
	guy1 ClearEnemy();	
	
	// Set up the animnames from the anim_loader function
	guy1.animname = "bayonet_guy1";
	guy1.allowdeath = false;

	guy2.animname = "bayonet_guy2";
	guy2.allowdeath = true;	
	guy2.deathanim = %ch_bayonet_flipover_guy2;
	// Set up the array of guys to pass into the anim_loop
	bayonet_array = [];
	bayonet_array = array_add ( bayonet_array, guy1 );
	bayonet_array = array_add ( bayonet_array, guy2 );
	//anim_org anim_reach ( bayonet_array, "flipover", undefined, undefined, anim_org);
	guy2 set_force_color("o");
	if(isAlive(guy1))
	{
 		anim_org thread anim_single ( bayonet_array, "flipover");
	 	if(isDefined(guy1.magic_bullet_shield))
		{
			guy1 stop_magic_bullet_shield();
		}
	 	guy2 doDamage(guy2.health + 5,(0,180,48));
		guy1.ignoreme = false;
		guy1.ignoreall = false;
		guy1.allowdeath = true;
		
	}	
	
}

monitor_spiderhole_ambush()
{
	thread ambush_movement();
	wait(2);
	waittill_aigroupcount( "spiderhole_ambushers",2 );	
	trig = getent("e1_friendlies_stairs","targetname");
	trig notify("trigger");
}

ambush_movement()
{
	wait(10);
	trig = getent("e1_friendlies_stairs","targetname");
	trig notify("trigger");
}


/*------------------------------------
lingering dust after the mortar barrage
------------------------------------*/
post_mortar_fx()
{
	
	ent1 = spawn("script_model",(3544.4, 907.352, -654.782));
	ent2 = spawn("script_model",(4023.26, 2967.62 ,-825.312));
	ent1 setmodel("tag_origin");
	ent2 setmodel("tag_origin");
	ent1.angles =(277.5, 90 ,-6.81);
	ent2.angles =(277.5, 90, -6.81023);
	
	forward = anglestoforward(ent1.angles);	
	forward2 = anglestoforward(ent2.angles);
	//playfxontag(level._effect["after_mortars"],ent1,"tag_origin" );
	//playfxontag(level._effect["after_mortars"],ent2,"tag_origin" );	
	level waittill("stop_mortar_fx");
	ent1 delete();
	ent2 delete();
	
}

/*------------------------------------

------------------------------------*/
#using_animtree("generic_human");
setup_supply_guys()
{
	wait(3);
	guys = get_ai_group_ai("supply_guys");
	for(i=0;i<guys.size;i++)
	{
		guys[i].animname = "redshirt";
		guys[i] thread anim_loop_solo( guys[i], "gather_supplies", undefined, "stop_gathering" );
	}	
}


//wait for a player to jump over the wall
over_wall_think()
{
	level thread players_over_wall();
	trig = getent("over_wall","targetname");
	while(1)
	{
		trig waittill("trigger",user);
		user.a.overwall = true;
	}
}


//	wait for all players to jump over the wall
players_over_wall()
{

	while(1)
	{
		over = true;
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if(!isDefined(players[i].a.overwall))
			{
				over = false;
			}
		}
		if(over)
		{
//			guys = get_ai_group_ai("supply_guys");
//			for(i=0;i<guys.size;i++)
//			{
//				guys[i] notify("stop_gathering");
//				guys[i] thread bloody_death(true,randomint(4));
//			}
			break;
			
		}
		wait(1);
	}	
	
	
	
	//getent("team_over_wall","targetname") notify("trigger");
	supply_drop_anim();

}

supply_drop_anim()
{
	//level.sniper_pawn thread snipe_the_supply_guy();
	
	level.sarge.animname = "sarge";
	level.polonsky.animname = "polonsky";
	level.sniper_pawn.animname = "pawn";
	
	
	
	guys = [];
	guys[0] = level.sarge;
	guys[1] = level.polonsky;
	guys[2] = level.sniper_pawn;
	
	array_thread(guys,::do_supply_drop_anim);
}

do_supply_drop_anim()
{
	anim_node = getent("supply_drop_org","targetname");	
	
	anim_node anim_reach_solo(self,"supply_in");
	if(self == level.sarge)
	{
		level.sarge thread supply_dialog();
	}
	anim_node anim_single_solo(self,"supply_in");
	level thread anim_loop_solo(self,"supply_loop",undefined,"stop_supply_drop",anim_node);
	
	if(self == level.sniper_pawn)
	{
		level notify("pawn_supplies");
	}
	if( self == level.polonsky)
	{
		level notify("polonsky_supplies");
	}
	if( self == level.sarge)
	{
			level notify("sarge_supplies");
	}
}

supply_dialog()
{
	wait(1);
	self playsound(level.scr_sound["sarge"]["this_is_it"]);	
}

event1_warp_supplydrop()
{
	
	players = get_players();
	volume = getent("gate_check","targetname");
	ents = getstructarray("warp_supplies","targetname");
	
	count = 0;
	for(i=0;i<players.size;i++)
	{
			
		if( players[i] istouching(volume) )
		{
			
		}	
		else
		{
			players[i] thread warp_player(ents[count]);
			players[i].a.overwall = true;
			count++;
		}		
	}
}


//wait for players to exit the bunker
bunker_cleared_think()
{
	level thread players_cleared_bunker();
	trig = getent("players_exit_bunker","targetname");
	trig waittill("trigger",user);

	players = get_players();
	ents = getstructarray("tunnel_exit","targetname");	

	warp_players("tunnel_exit",user);
	for(i=0;i<players.size;i++)
	{
		players[i].a.clearbunker = true;
	}

}


//	wait for all players to jump over the wall
players_cleared_bunker()
{

	while(1)
	{
		clear = true;
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if(!isDefined(players[i].a.clearbunker))
			{
				clear = false;
			}
		}
		if(clear)
		{
			break;
			
		}
		wait(1);
	}
	
	level notify("all_out_bunker");
	
	//save the game
	autosave_by_name("all_out_bunker");
	
	objective_state(4,"done");
	objective_add(5,"current",&"OKI3_OBJ1", ( 3626.5, -91.5, -449.3 ) );
	objective_ring(5);
	
}


/*------------------------------------
spawns enemies in the guardhouse area
------------------------------------*/
guard_shack()
{
	trigger_wait("spawn_shack_guys","targetname");	
	simple_spawn("shack_upper_guys");
	shutter = [];
	shutter[0] = 2;
	shutter[1] = 3;

	shutters = array_randomize(shutter);
	
	for(i =0;i<shutters.size;i++)
	{	
		getent("shack_shutter" + shutters[i] + "_left","targetname") rotateyaw( -120, randomfloatrange(.1,.4), 0, .0 );
		getent("shack_shutter" + shutters[i] + "_right","targetname") rotateyaw( 120,randomfloatrange(.1,.4), 0, 0 );
		wait randomfloatrange(.2,.5);
	}

	
}

/*------------------------------------
give the player some ammo when they pick up the new supplies
------------------------------------*/
take_ammo_from_supplydrop()
{
	trig = getent("take_ammo","targetname");
	trig sethintstring( &"OKI3_TAKE_AMMO");
	while(1)
	{
		trig waittill("trigger",user);
		
		//TUEY SET MUSICSTATE AMBUSH
		setmusicstate("AMBUSH");
		
		user playsound("gren_pickup_plr");
		weapons = user GetWeaponsList();		
		for( i = 0; i < weapons.size; i++ )
		{
			weapon = weapons[i];
			if(weapon != "type100_smg" && weapon != "type99_rifle" && weapon != "type99_rifle_bayonet" && weapon != "type99_rifle_scoped" && weapon != "type97_frag")
			{
				user setweaponammostock(weapon,500);	
			}		
		}
	}
}

event1_rear_fallback()
{
	
	trig = getent("defenders_retreat","targetname");
	trig.script_color_auto_disable = 0;
	
	trigger_Wait("defenders_retreat","targetname");
	
	nodes = getnodearray("castle_wall_retreat","script_noteworthy");
	retreaters = get_ai_group_ai("rear_defenders");
	
	nodecount =0;
	for(i=0;i<retreaters.size;i++)
	{
		guy = retreaters[i];
		
		if(nodecount < nodes.size)
		{
			guy thread guy_retreats(nodes[nodecount],107);
			nodecount++;
		}
		else
		{
			guy.banzai_no_wait= 1;
			guy.goalradius =64;
			guy thread maps\_banzai::banzai_force();
		}

	}
		
	//friendly movement in event2
	level thread event2_monitor_enemies();
	
	event1_block_castle_wall();	
	level.sarge do_dialogue("up_stairs");
	wait(1);
	level.sarge do_dialogue("thru_gate");	
	
	
	//level thread random_path_up_stairs();
}


event1_front_fallback()
{
	
	//trigger_wait("front_guys_retreat","targetname");
	
	getent("front_guys_retreat","targetname") waittill("trigger",user);
	
	level thread monitor_castle_stairs_defenders();
	
	volumes = getentarray("info_volume","classname");
	nodes = getnodearray("castle_front_retreat","script_noteworthy");
	
	nodecount = 0;
	for(i=0;i<volumes.size;i++)
	{
		vol = volumes[i];
		if(isDefined(vol.script_goalvolume))
		{

			if (vol.script_goalvolume == 101||vol.script_goalvolume == 102)
			{
				
				ai = getaiarray("axis");
				for(j=0;j<ai.size;j++)
				{
					if( ai[j] istouching(vol))
					{
						if(nodecount < nodes.size)
						{
							ai[j] thread guy_retreats(nodes[nodecount],107);
							nodecount++;
						}
						else
						{
							ai[j].banzai_no_wait = 1;
							ai[j] thread maps\_banzai::banzai_force();
						}
					}
					
				}
			}
		}
	}
	
}

handle_ai_stairs()
{
	trigs = getentarray("stairs_up","targetname");
	array_thread(trigs,::ai_upstairs);
	
	trigs = getentarray("stairs_down","targetname");
	array_thread(trigs,::ai_downstairs);
	
}

ai_upstairs()
{

	level thread ai_stop_stairs(getent(self.target,"targetname"));
	while(1)
	{
		self waittill ("trigger", user);
		if(!isDefined(user.stairs))
		{
			user.stairs = 1;
			if(user != level.polonsky && user != level.sarge)
			{
				user.animname = "generic";
			}
			
			user set_run_anim("stairs_up");
		}
	}
}

ai_stop_stairs(trig)
{
	while(1)
	{
		trig waittill("trigger",user);
		{
			if(isDefined(user.stairs))
			{
				user.stairs = undefined;
				if(user != level.polonsky && user != level.sarge)
				{
					user.animname = undefined;
				}
				user reset_run_anim();					
			}
		}
	}
}

ai_downstairs()
{

	level thread ai_stop_stairs(getent(self.target,"targetname"));
	while(1)
	{
		self waittill ("trigger", user);
		if(!isDefined(user.stairs))
		{
			user.stairs = 1;
			if(user != level.polonsky && user != level.sarge)
			{		
				user.animname = "generic";
			}
			user set_run_anim("stairs_down");
		}
	}
}


monitor_castle_stairs_defenders()
{
	
	monitor_volume_for_enemies("stairs_volume",undefined,"defenders_retreat");
		
}

event1_block_castle_wall()
{
	
	castle_wall_clip = getent("castle_wall_clip","targetname");
	castle_wall_clip trigger_on();
	castle_wall_clip disconnectpaths();
	
}


event2_monitor_enemies()
{
	trigger_Wait("monitor_enemies_e2_1","targetname");
	level thread e2_dialogue();
	
	trig = getent("defenders_retreat","targetname");
	trig.script_color_auto_disable = 1;
	
	maps\_debug::clear_event_printname();
	wait(3);
	level thread monitor_volume_for_enemies("fallback_volume","fallback_cleared","e2_color_shack");
	
	level waittill("fallback_cleared");
	level thread monitor_volume_for_enemies("shack_volume",undefined,"e2_color_shack2");
	
	trigger_wait("monitor_enemies_e2_2","targetname");
	level thread monitor_volume_for_enemies("corridor_area",undefined,"e2_color_corridor");
	
}


e2_dialogue()
{
	level.polonsky thread do_dialogue("low_ammo");
	wait(2);
	level.sarge thread do_dialogue("scavenge");
	wait(2);
	level.sarge thread do_dialogue("enemy_weapons");
	
	trigger_wait("spawn_shack_guys","targetname");
	wait(2);
	level.sarge thread do_dialogue("high_window");
	wait(2);
	level.polonsky thread do_dialogue("more_on_roof");
	
	//TOdo - add nag for roof guys
	trigger_wait("e2_color_corridor","targetname");
	level.sarge thread do_dialogue("west_bld");


}

monitor_grass_guys()
{
	alive = true;

	while(alive)
	{
		count = 0;
		guys =  getaiarray("axis");
		for(i=0;i<guys.size;i++)
		{
			if( isAlive(guys[i]) && isDefined(guys[i].script_string) && guys[i].script_string == "grass_guy")
			{
				count++;
			}
		}
		if(count<1)
		{
			alive = false;
		}
		wait(1);
	}
	
	level notify("mortar_area_clear");
}



grass_mortars_camo_guys_strat()
{

	self endon( "death" );
	self.anchor = spawn("script_origin",self.origin);
	//self.script_noteworthy = "dont_kill_me";
	self allowedstances ( "prone" );
	self.a.pose = "prone"; 
	self.allowdeath = 1;
	self.pacifist = 1;
	self.pacifistwait = 0.05;
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.ignoresuppression = 1;
	self.surprisedPlayer = false;
	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;
	self.activatecrosshair = false;
	self.script_string = "grass_guy";
	//self.banzai_no_wait = 1;
	self.animname = "bunkers";
	
	//track the achievement
	self thread oki3_grass_guy_achievement();
	
	self thread grass_admin_surprise_damage( "grass_admin_surprise_damage", "trig_grass_admin_camo_guys" );
	self linkto(self.anchor);
	flag_wait_either( "grass_admin_surprise", "grass_admin_surprise_damage" );
	self unlink();
	// stagger their emergence times if necessary
	if( isdefined( self.script_float ) )
	{
		wait( self.script_float );
	}
	
	setmusicstate("MORTAR_BANZAI");

	//self playsound("banzai_charge");

	self.activatecrosshair = true;
	self.drawoncompass = true;

	//self thread maps\oki3_util::grass_surprise_half_shield( 1.8 );
	//self thread maps\oki3_util::grass_camo_ignore_delay( 1.8 );

	self allowedstances( "stand" );
	self.a.pose = "stand"; 
	
	// choose which variant anim to use
	prone_anim = undefined;
	if( RandomInt( 2 ) )
	{
		prone_anim = level.scr_anim["bunkers"]["prone_anim_fast"];	
	}
	else
	{
		prone_anim = level.scr_anim["bunkers"]["prone_anim_fast_b"];
	}
	
	level.animtimefudge = 0.05;
	self play_anim_end_early( prone_anim, level.animtimefudge );	
	
	self.surprisedPlayer = true;
	self.pacifist = 0;
	self.ignoreall = 0;
	self.grenadeawareness = 0.2;
	self.disableArrivals = false;
	self.disableExits = false;
	self.ignoreme = false;
	
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "pel2_no_banzai" )
	{
		self allowedstances( "crouch" );
		wait( RandomIntRange( 4, 7 ) );
	}
	
	self.banzai_no_wait = 1;
	//self maps\oki3_anim::banzai_run_anim_setup();
	self thread maps\_banzai::banzai_force();

}



grass_admin_surprise_damage( flag_name, alt_flag_name )
{

	level endon( "trig_ditch_guys" );

	self waittill( "damage" );
	flag_set( flag_name );
	if( isdefined( alt_flag_name ) )
	{
		flag_set( alt_flag_name );
	}
	
}

spawn_grass_guys()
{
	
	trigger_Wait("spawn_grass_guys","targetname");
	level thread trigger_grass_guys();
	simple_spawn("mortar_grass_guys",::Grass_Mortars_Camo_Guys_Strat);
	wait(5);
	level thread monitor_grass_guys();
}

trigger_grass_guys()
{
	trigger_wait("grass_surprise","targetname");
	flag_set("grass_admin_surprise");
}


tree_sniper_spawner_func()
{
	
	self endon("death");
	
	anim_node = getnode(self.target, "targetname");
	anim_point = getent(anim_node.target,"targetname");	
	self.ignoreme = true;
	self.animname = "tree_guy";
	
	if (self.script_noteworthy == "climb")
	{
		self maps\_tree_snipers::do_climb(anim_point);
	}
	if (isdefined(self))
	{
		self allowedstances ("crouch");
	}
	self.allowdeath = true;
	self thread maps\_tree_snipers::tree_death(self, anim_point);
	
	wait(10);
	self.ignoreme = false;
		
}


/*------------------------------------
spawns the first group of guys for the battle in the planters/garden area
------------------------------------*/
event3_front_planter_guys()
{
	//trigger_wait("front_planter_guys","script_noteworthy");	
	spawners =getentarray("auto3630","targetname");
	for(i=0;i<spawners.size;i++)
	{
		//wait for a snapshot after spawning every 2 guys
		if(i % 2)
		{
			wait_network_frame();
		}
		spawners[i] thread maps\_spawner::flood_spawner_think();
	}
	wait_network_frame();
}



/*------------------------------------
a few guys hiding in the supply room on 
the way to the mortarpits area
------------------------------------*/
setup_closet_ambush()
{
	
	level thread closet_ambush();
	anim_org0 = getnode("feign_spawner0","targetname");
	anim_org1 = getnode("feign_spawner1","targetname");
	
	simple_spawn("feign_spawner0",::closet_ambush_spawnfunc);
	simple_spawn("feign_spawner1",::closet_ambush_spawnfunc);
	
	guy1 = getent("feign_spawner0_alive","targetname");
	guy2 = getent("feign_spawner1_alive","targetname");

	guy1.animname = "feign_guy1";
	guy1.allowdeath = true;
	guy1 thread maps\_anim::anim_loop_solo(guy1,"feign",undefined,"stop_feign",anim_org0);
	if(randomint(100) >50)
	{
		guy2.animname = "feign_guy2";
		guy2.allowdeath = true;
		guy2 thread maps\_anim::anim_loop_solo(guy2,"feign",undefined,"stop_feign",anim_org1);	
	}
	else
	{
		guy2.clost_banzai = 1;
		guy2.goalradius = 64;
		guy2 setgoalnode(anim_org1);
		
	}

}

closet_ambush_spawnfunc()
{
	self.pacifist = 1;
	self.pacifistwait = .05;
	self.ignoreall = true;
	self.ignoreme = true;
}

closet_ambush()
{
	spot = getstruct("feign_spawner0","targetname");
	org_trigger((1241, -1283, -419),128);
	
	guy1 = getent("feign_spawner0_alive","targetname");
	guy2 = getent("feign_spawner1_alive","targetname");
	
	if(isDefined(guy1))
	{
			guy1 thread do_ambush();
	}	
	
	if(isDefined(guy2))
	{
	 if(!isDefined(guy2.clost_banzai) )
		{
			guy2 thread do_ambush();
		}
		else
		{
			guy2.ignoreall = false;
			guy2.pacifist = false;
			guy2.ignoreme = false;
			guy2.script_player_chance = 100;
			guy2 thread maps\_banzai::banzai_force();
		}
	}		
}

do_ambush()
{
	self endon ("death");
	
	wait(randomfloatrange(0,1));
	self notify("stop_feign");
	self maps\_anim::anim_single_solo( self,"getup");
	self.ignoreall = false;
	self.pacifist = false;
	self.goalradius = 64;
	self.ignoreme = false;
	self.script_player_chance = 100;
	self thread maps\_banzai::banzai_force();

}

/*------------------------------------
achievement wrapper for the "mortar-dom" achievement
------------------------------------*/
oki3_achievement_setup()
{
	spawners = getspawnerarray();
	for(i=0;i<spawners.size;i++)
	{
		if(isSubstr(spawners[i].classname,"actor_axis"))
		{
			spawners[i] add_spawn_function( ::wait_for_death );
		}
	}
		
}

wait_for_death()
{
	self waittill("death");

	if ( !isDefined( self.attacker ) || !isPlayer( self.attacker ) )
		return;
	
	player = self.attacker;
	
	if( self.damageWeapon == "mortar_round" )
	{
		if(!isdefined(player.mortar_deaths))
		{
			player.mortar_deaths = 1;
		}
		else
		{
			player.mortar_deaths ++;
		}
		if(player.mortar_deaths > 7)
		{
			level notify("no_tube",player);
		}
		if(!isDefined(level.mortar_deaths))
		{
			level.mortardeaths = 1;
		}
		else
		{
			level.mortardeaths++;
			if( level.mortardeaths>5 && !isDefined(level.mortar_congrats) && isDefined(level.hut_destroyed ))
			{
				level.sarge thread do_dialogue(level.scr_sound["sarge"]["good_work"]);
				level.mortar_congrats = true;
			}
		}
	}
}

oki3_give_achievement()
{
	while(1)
	{
		level waittill("no_tube",player);
		player GiveAchievement( "OKI3_ACHIEVEMENT_KILL8" );
	}		
}

oki3_grass_guy_achievement()
{
	while(1)
	{
		self waittill( "damage", damage_amount, attacker, direction_vec, point, type );
		
		if ( self.health <= 0 && !self.surprisedplayer )
		{
			if ( isdefined( attacker ) && isplayer( attacker )  )
				attacker maps\_utility::giveachievement_wrapper( "ANY_ACHIEVEMENT_GRASSJAP");
		}
	}
}

mortarpits_shoot_boards()
{
	
	level waittill_multiple("mortar_guys_dead","mortar_area_clear");
	door = getent("mortarpit_door","targetname");
	door solid();
	door disconnectpaths();
	//clip = getent("board_clip","targetname");
	left_boards = [];
	right_boards = [];
	
	trig = getent("after_mortar_trigger","script_noteworthy");
	trig trigger_on();	
	
//	for(i=0;i<4;i++)
//	{
//		left_boards[i] = getent("left_board_" + (i+1),"targetname");
//		//right_boards[i] = getent("right_board_" + (i+1),"targetname");
//		left_boards[i] setcandamage(true);
//		//right_boards[i] setcandamage(true);
//	}
	
	level.sarge disable_ai_color();
	level.sarge.grenadeawareness = 0;
	shoulder_node = getnode("mortarpit_shoulder_door","targetname");	
//	//anim_node = getnode("mortarpit_kick","targetname");
//	
	shoulder_node anim_reach_solo(level.sarge, "door_kick4");
	shoulder_node anim_single_solo(level.sarge,"door_kick4");	
	//kick_node = getnode("mortarpit_kick_boards","targetname");
//	kick_node anim_reach_solo(level.sarge, "door_kick3");
//	kick_node anim_single_solo(level.sarge,"door_kick3");
//	wait(1);
//	shoulder_board_node = getnode("mortarpit_shoulder_boards","targetname");	
	//anim_node = getnode("mortarpit_kick","targetname");
	
//	shoulder_board_node anim_reach_solo(level.sarge, "door_kick5");
//	shoulder_board_node anim_single_solo(level.sarge,"door_kick5");

}

//force_target(org)
//{
//	level.sarge endon("stop_forcing_target");
//	while(1)
//	{
//		level.sarge setentitytarget (org);
//		level.sarge clearenemy();
//	}
//}



kick_mortar_boards(guy)
{	
	//play_sound_in_space("door_kick",(2853.5, -4657.5 ,87));
	exploder(10000);		 
}

shoulder_mortar_boards(guy)
{
	play_sound_in_space("door_kick",(2853.5, -4657.5 ,87));
	exploder(10001);
	
}

shoulder_mortar_door(guy)
{
	door = getent("mortarpit_door","targetname");
	door playsound("door_kick");
	door connectpaths();

	waittillframeend;
	door rotateyaw(-135, 1, 0.25, 0.25);
	door connectpaths();
	door solid();
	level.sarge clearentitytarget();	
	//clip connectpaths();
	//clip delete();
	level.sarge enable_ai_color();
	level.sarge.grenadeawareness = 1;
	level.sarge.ignoreme = false;
}

#using_animtree( "generic_human" );
setup_collectible_corpse()
{

	spot = spawn("script_origin",(1896,-5426,-44));
	spot.angles = (0,225,0);
	corpse = spawn( "script_model" , spot.origin );
	corpse character\char_jap_oki_rifle::main();
	corpse UseAnimTree(#animtree);
	corpse.angles = spot.angles;
	corpse.animname = "collectible_corpse";

	spot thread anim_single_solo( corpse, "death_loop");
}
	
alert_mggunner()
{
	
	trigger_wait("alert_mg","targetname");
	mg = getent("auto4051","targetname");
	guy = mg getturretowner();	

	if( isdefined(guy) && isdefined(mg) )
	{
		mg setturretignoregoals( false );
		guy.script_mg42 = undefined;
		guy.banzai_no_wait = 1;
		wait(.2);
		guy thread maps\_banzai::banzai_force();
	}		
}

