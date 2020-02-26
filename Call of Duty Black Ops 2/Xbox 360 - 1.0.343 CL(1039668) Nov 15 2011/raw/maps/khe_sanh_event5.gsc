//////////////////////////////////////////////////////////
//
// khe_sanh_event5.gsc
//
//////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\khe_sanh_util;
#include maps\_anim;
#include maps\_flyover_audio;
#include maps\_music;

main()
{
	init_flags();
	level.player thread maps\_tvguidedmissile::watchForGuidedMissileFire();
	level thread event5_intro();
	level thread achievement_watcher_tanks();
}

init_flags()
{
	flag_init("stop_redshirt_movement");
	flag_init("player_forced_out_tow");
	flag_init("disable_tow_usage");
	flag_init("obj_e5_tow_tanks_complete");
	flag_init("end_jeep_tow_ride");
	flag_init("allies_on_jeep");
	flag_init("tank_destroyed");
	flag_init("heroes_at_end");
	flag_init("start_finale");
	flag_init("use_the_tow");
	flag_init("missile_exploded");
	flag_init("start_final_explosion");
	flag_init("tow_tutorial");
}

event5_intro()
{
	level.REPEL_NVA_TIME = 5; 
	level.player.animname = "mason";
	
	player = get_players()[0];

	//Get on Jeep!
	level thread event5_ride_the_jeep();

	trigger_wait("trig_event5_start");

	//rooftop collapse
	level notify("bunker02_start");
	playsoundatposition ( "exp_mortar_dirt", player.origin );
	//Exploder(490);
	Earthquake(0.65, 2, level.player.origin, 200, level.player);
	level thread custom_rumble(0.02, 15);

	autosave_by_name("e5_start_seige");

	wait 2;

	//set up threat
	level event5_threatbiasgroups();
	wait 0.05;

	//clean up event 4 and 4b
	level event4_cleanup_setup();

	level thread event5_radio_vo();

	//heroes
	level.squad["woods"] change_movemode("cqb_sprint");
	level.squad["hudson"] change_movemode("cqb_sprint");
	level.squad["woods"].goalradius = 64;
	level.squad["hudson"].goalradius = 64;
	level.squad["woods"].ignoreme = true;
	level.squad["hudson"].ignoreme = true;
	level.squad["woods"].ignoreall = true;
	level.squad["hudson"].ignoreall = true;

	//end setlow ready and renable all controls
	//level.player player_force_walk(false);

	//stop mortars from event4b
	//level notify("stop_mortars");

	level.drone_trigger_e5_right = GetEnt("e5_trig_drone_right", "script_noteworthy");
	level.drone_trigger_e5_right activate_trigger();

	level.drone_trigger_e5_left = GetEnt("e5_trig_drone_left", "script_noteworthy");
	level.drone_trigger_e5_left activate_trigger();

	level thread drone_speed_adjust();
	level thread event5_t55_ambient();
	level thread ambient_mortar_explosion("e5_ambient_mortar_", "e5_ambient_mortar_locs", 2, 2); //ambient_mortar_explosion(struct_name, grp_name, wait_time, interval)

	//starts the amb phantom vo and starts the napalm drops NO LONGER USER ACTIVATED
	level thread activate_radio_vo();

	//redshirts
	level thread event5_setup_redshirts();

	if( (!level.e5_jumpto && !level.e5b_jumpto) || level.e5_jumpto )
	{
		//opening setup
		event5_opening();

		//jeep battle 
		event5_jeep_tow_battle();
	}
	else
	{
		flag_set("obj_repel_infantry");
		flag_set("obj_repel_infantry_complete");
		flag_set("player_on_jeep");
		flag_set("obj_get_in_jeep");
		flag_set("phase_2_spawn");
		flag_set("phase_3_spawn");
		flag_set("obj_tow_jeep_phase_end");
		flag_set("start_finale");
	}

	event5_big_finale();
}

event5_opening()
{
	flag_set("obj_repel_infantry");
	
	level.squad["hudson"] set_goal_node(GetNode("node_hudson_bandana", "targetname"));
	level.squad["woods"] set_goal_node(GetNode("node_woods_bandana", "targetname"));

	level thread event5_redshirt_jeep();
	level thread event5_first_wave();

}

activate_radio_vo()
{
	//make sure all intro jeep talk is done
	level waittill("jeep_vo_done");
	//radio_struct = getstruct("struct_use_radio", "targetname");

	//level.squad["woods"] anim_single(level.squad["woods"], "radio_phantoms");//Mason! Call in the Phantoms!
	//wait 1;
	//level.squad["woods"] anim_single(level.squad["woods"], "e5_go_bunker");//Get to that bunker!

	//trigger = GetEnt("trig_radio_enter", "targetname");
	//trigger waittill("trigger");

	//level.squad["woods"] LookAtEntity(level.player);
	//level.squad["woods"] thread anim_single(level.squad["woods"], "radio_napalm_strike");//Get on that Radio mason, and call in a napalm strike!
	//level.squad["woods"] LookAtEntity();

	//level.VF_143 = spawn("script_model", radio_struct.origin);
	//level.VF_143 SetModel("tag_origin");
	//level.VF_143.animname = "amb_phantom_vo";

	level.player anim_single(level.player, "mason_call_napalm");//VF 143! Authorization Sierra Oscar Golf X-ray. Priority one ordinance on my command!

	wait 0.25;

	level thread event5_ambient_airstrikes();

	//wait for first strike
	level waittill("phantom_drop");

	wait 0.5;

	level.squad["woods"] anim_single(level.squad["woods"], "air_strike_react");//Nice!

	//trigger Delete();
}

first_wave_tank_vo()
{
	wait 1;
	level.squad["woods"] anim_single(level.squad["woods"], "e5_go_law");//Heads UP!

	wait 1;
	level.squad["woods"] anim_single(level.squad["woods"], "e5_tanks_start");//Gotta take out the tanks!
}

event5_jeep_tow_battle()
{
	level.e5_jeep_tanks = [];
	tank_count = 0;

	level thread cleanup_tank_debris();

	if(!IsDefined(level.e5_base_path))
	{
		for(i = 0; i < 4; i++)
		{
			level.e5_base_path[i] = GetVehicleNode("node_t55_base_path_"+i, "targetname");
		}
	}

	trigger_use("trig_t55_jeep_fight_0");
	wait 0.05;
	
	for(i = tank_count; i < 1; i++)
	{
		level.e5_jeep_tanks[i] = GetEnt("t55_jeep_fight_" +i , "targetname");
		level.e5_jeep_tanks[i] setup_jeep_tank(true);

		level.e5_jeep_tanks[i] thread go_path(level.e5_base_path[i]);

		tank_count++;
		wait 1;
	}

	flag_set("obj_get_in_jeep");

	//activate infantry for this section: up the road
	array_thread(GetEntArray("nva_spawners_tank_wave", "targetname"), ::add_spawn_function, ::event5_wave_0_think);
	trigger_use("trig_e5_nva_tank_wave"); //troops as you first approach first tank

	waittill_multiple_ents(level.e5_jeep_tanks[0], "death");//,level.e5_jeep_tanks[1], "death" );
	//array_wait( level.e5_jeep_tanks, "death" );
	flag_set("obj_tow_jeep_phase_2");
	trigger_use("trig_t55_jeep_fight_2"); //tank
	trigger_use("trig_e5_nva_sm_right"); //troops from vista right
	wait 0.05;

	//WAVE TWO
	x = 0;
	wave_count = 2 + tank_count;
	for(i = tank_count; i < wave_count; i++)
	{

		level.e5_jeep_tanks[i] = GetEnt("t55_jeep_fight_" +i , "targetname");
		level.e5_jeep_tanks[i] setup_jeep_tank(true);
		
		//tank paths 0, 1, 2
		level.e5_jeep_tanks[i] thread go_path(level.e5_base_path[x]);
		
		tank_count++;
		x++;
		wait 1;
	}
	
	flag_set("phase_2_spawn");

	waittill_multiple_ents(level.e5_jeep_tanks[1], "death", level.e5_jeep_tanks[2], "death");//, level.e5_jeep_tanks[4], "death" );

	//skill spawn manager at left side
	spawn_manager_kill("trig_e5_nva_sm_left");

	//kill ambient tanks
	level notify("kill_ambient_tanks");

	flag_set("obj_tow_jeep_phase_3");
	trigger_use("trig_t55_jeep_fight_5"); //tanks
	wait 0.05;
	
	//WAVE THREE
	wave_count = 3 + tank_count;
	x = 0;
	for(i = tank_count; i < wave_count; i++)
	{
		level.e5_jeep_tanks[i] = GetEnt("t55_jeep_fight_" +i , "targetname");
		level.e5_jeep_tanks[i] setup_jeep_tank(true);

		//tank paths 0, 1, 2, 3
		level.e5_jeep_tanks[i] thread go_path(level.e5_base_path[x]);
		tank_count++;
		x++;
		wait 1;
	}

	flag_set("phase_3_spawn");

	level.squad["woods"] thread anim_single(level.squad["woods"], "trans_final_wave");//It ain't over yet.

	waittill_multiple_ents(level.e5_jeep_tanks[3], "death", level.e5_jeep_tanks[4], "death", level.e5_jeep_tanks[5], "death");//, level.e5_jeep_tanks[8], "death" );

	flag_set("end_jeep_tow_ride");
	flag_set("obj_tow_jeep_phase_end");
	//kill the spawners that were left on
	spawn_manager_kill("trig_e5_nva_tank_wave");
	spawn_manager_kill("trig_e5_nva_sm_right");
}

//oh man this is bad
//self is tank array
cleanup_tank_debris()
{
	flag_wait("obj_tow_jeep_phase_2");
	wait 6;
	level.e5_jeep_tanks[0] Delete();
	//wait 6;
	//level.e5_jeep_tanks[1] Delete();


	flag_wait("obj_tow_jeep_phase_3");
	wait 6;
	level.e5_jeep_tanks[1] Delete();
	wait 6;
	level.e5_jeep_tanks[2] Delete();
	//wait 6;
	//level.e5_jeep_tanks[4] Delete();
}

#using_animtree("generic_human");
event5_big_finale()
{
/#
	//to time stuff out. ugh
	//level thread show_time(0.05);
#/	
	align_node = getent("align_finale", "targetname");
	level.bowman_pos_node = GetNode("node_bowman_temp", "targetname");

	flag_wait("start_finale");
	playsoundatposition( "evt_num_num_02_r_louder" , (0,0,0) );

	trigger_use("trig_heli_bowman");
	wait 0.05;

	//send heroes to spot
	//level.jeep_tow vehicle_unload(0.1);
	level.squad["woods"] SetGoalNode(GetNode("node_bowman_woods", "targetname"));
	level.squad["hudson"] SetGoalNode(GetNode("node_bowman_hudson", "targetname"));

	//send in the heli
	path = getvehiclenode("node_bowman_heli", "targetname");
	level.bowman_heli = GetEnt("heli_bowman", "targetname");
	level.bowman_heli SetForceNoCull();
	level.bowman_heli.drivepath = true;
	level.bowman_heli.goalradius = 128;
	level.bowman_heli thread go_path(path);
	level.bowman_heli waittill("reached_end_node"); 
	flag_set("end_scene");
	
	//cook off the player
	flag_set("obj_e5_tow_tanks_complete");

	//wait till the player exit jeep is done
	flag_wait("player_forced_out_tow");
	
	//End Level Snapshot
	level clientNotify ("theend");
	
	//TUey set up music (ENDING)
	setmusicstate ("ENDING");

	//clean out remaining AI
	axis = GetAIArray("axis");
	array_delete(axis);

	//turn into script model
	level.bowman_heli_swap = spawn_anim_model("huey_guard", level.bowman_heli.origin);
	level.bowman_heli_swap.angles = level.bowman_heli.angles;
	level.bowman_heli_swap Attach("t5_veh_helo_huey_att_interior", "tag_body");
	level.bowman_heli_swap Attach("t5_veh_helo_huey_att_decal_usmc_std", "tag_body");
	level.bowman_heli_swap Attach("t5_veh_helo_huey_att_usmc_m60", "tag_body");

	//huey rotors
	PlayFXOnTag(level._effect["huey_rotor"], level.bowman_heli_swap, "main_rotor_jnt");

	//fill in crew
	level.bowman_heli_swap.crew = [];	
	level.bowman_heli_swap.crew  = array_add(level.bowman_heli_swap.crew, spawn_fake_character(level.bowman_heli_swap.origin, (0,0,0), "huey_pilot_1"));	
	level.bowman_heli_swap.crew  = array_add(level.bowman_heli_swap.crew, spawn_fake_character(level.bowman_heli_swap.origin, (0,0,0), "huey_pilot_2"));	
	level.bowman_heli_swap.crew  = array_add(level.bowman_heli_swap.crew, spawn_fake_character(level.bowman_heli_swap.origin, (0,0,0), "bowman"));

	level.bowman_heli_swap.crew[0].animname = "huey_pilot_1";
	level.bowman_heli_swap.crew[1].animname = "huey_pilot_2";
	level.bowman_heli_swap.crew[2].animname = "gunner_pilot_1";

	level.bowman_heli_swap.crew[0] LinkTo(level.bowman_heli_swap, "tag_driver");
	level.bowman_heli_swap.crew[1] LinkTo(level.bowman_heli_swap, "tag_passenger");
	level.bowman_heli_swap.crew[2] LinkTo(level.bowman_heli_swap, "tag_gunner_turret1");

	for(i = 0; i < level.bowman_heli_swap.crew.size; i++ )
	{
		level.bowman_heli_swap.crew[i] UseAnimTree(#animtree);
		level.bowman_heli_swap.crew[i] thread anim_loop(level.bowman_heli_swap.crew[i], "huey_idle");
	}

	//turn off names and compass
	level.player SetClientDvar("compass", 0);
	level.player SetClientDvar("cg_drawfriendlynames", 0);

	level.player StartCameraTween(0.3);
	level.player DisableWeapons();
	level.player HideViewModel();
	level.end_play_body = spawn_anim_model("player_body", level.player.origin, level.player.angles);
	level.end_play_body.animname = "player_body";
	level.player PlayerLinkToAbsolute(level.end_play_body, "tag_player");
	level.player DisableInvulnerability();
	level.overridePlayerDamage = undefined;

	actors = [];
	level.bowman_heli_swap.crew[2].animname = "bowman";
	level.bowman_heli_swap.crew[2] UnLink();	
	actors[0] = level.bowman_heli_swap;
	actors[1] = level.bowman_heli_swap.crew[2];
	actors[2] = level.squad["woods"];
	actors[3] = level.squad["hudson"];
	actors[4] = level.end_play_body;
	level.bowman_heli Delete();

	actors[1] Attach("t5_weapon_M16A1_world", "tag_weapon_right");
	actors[1] UseWeaponHideTags("m16_sp");

	//Debugstar(fly_pos, 12000, (1,0,0));
	align_node notify("end_wait_loop");

	level notify("start_intro_reveal");	
	//this exploder is for helicopter dust
	//Exploder(590);
	align_node anim_single_aligned(actors, "reveal_loop");
	level notify("start_reveal");
	align_node anim_single_aligned(actors, "reveal");

	level.player SetClientDvar( "ammoCounterHide", 0 );
	level.player SetClientDvar("cg_drawfriendlynames", 1);
	level.player SetClientDvar("compass", 1);

	nextmission();
}

finale_explosions()
{
	// turn on battle chatter
	battlechatter_off("allies");
	battlechatter_off("axis");

	level arclight_finale();
	flag_set("start_final_explosion");
	wait 0.2;
	//flying b52
	//Exploder(598);
	//first explosion
	playsoundatposition ("evt_napalm_hit_00", (0,0,0));
	//Exploder(599);
	level thread custom_rumble(0.02, 20);

	//flag_set("heroes_at_end");
	level waittill("start_intro_reveal");

	//delete nva if we arent looking
	level thread cleanup_nva();

	//add some heli landing sounds
	playsoundatposition( "veh_huey_land", (0,0,0) );

	wait 0.6;
	//Exploder(599);
	playsoundatposition ("mpl_kls_napalm_lfe", (0,0,0));
	level thread custom_rumble(0.02, 20);

//	level waittill("start_reveal");
//wait 2.2;
//	wait 4;
}

cleanup_nva()
{
	nva_cleanup = GetAIArray("axis");
	for(i = 0; i < nva_cleanup.size; i++)
	{
		if(IsDefined(nva_cleanup[i]))
		{
			nva_cleanup[i] thread no_look_delete();
		}
	}
}

arclight_finale()
{
	if(IsDefined(level.jeep_tow_radio))
	{
		level.jeep_tow.animname = "arclight";
		level.jeep_tow anim_single(level.jeep_tow, "radar");//Arc Light establishing radar lock.
		level.jeep_tow anim_single(level.jeep_tow, "whammo");//Arc Light commencing bomb run.
	}
}

//self is tank
setup_jeep_tank( target_jeep )
{
	self.health = level.DEFAULT_TANK_HEALTH;
	self.obj_loc = spawn("script_model", self.origin + (0, 0, 50));
	self.obj_loc SetModel("tag_origin");
	self.obj_loc LinkTo(self);
	self.vehicleavoidance = true;	
	self.e5_tank = true;
	self thread tank_move_manager();
	self thread tank_stop_move_on_death();
	self thread tank_death_notifier();
	if(target_jeep)
	{
		self thread in_base_shoot_think(true);
	}
	else
	{
		self thread in_base_shoot_think(false);
	}

	self.overrideVehicleDamage = ::jeep_tank_damage;
}

jeep_tank_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
 	if (!IsDefined(sWeapon) || (sWeapon != "m220_tow_emplaced_khesanh_sp"))
 	{
 		iDamage = 0;
 	}

	return iDamage;
}

tank_death_notifier()
{
	self waittill("death");
	flag_set("tank_destroyed");
}

event5_ride_the_jeep()
{
	trigger_use("trig_tow_jeep");
	wait 0.05;

	level.jeep_tow = GetEnt("jeep_tow", "targetname");
	level.jeep_tow.vehicleavoidance = true;
	level.tow = GetEnt("align_tow_emplacement", "targetname");

	trig_tow = GetEnt("trig_tow", "targetname");
	jeep_path = getvehiclenode("node_jeep_tow_0", "targetname");

	//link tow to jeep
	level.tow.angles = level.jeep_tow.angles;
	level.tow.origin = level.jeep_tow GetTagOrigin( "tag_tow_attach" ); //+ AnglesToRight(level.jeep_tow GetTagAngles( "tag_gunner1" )) * 15;
	level.tow LinkTo(level.jeep_tow, "tag_tow_attach");

	//link trigger to jeep
	trig_tow.origin = level.jeep_tow GetTagOrigin("tag_passenger2");// + (0, -50, 50);
	trig_tow EnableLinkTo();
	trig_tow LinkTo(level.jeep_tow, "tag_passenger2");

	//start fail condition watcher
	level thread enter_jeep_fail();
	
	flag_wait("obj_get_in_jeep");

	array_thread(GetEntArray("jeep_nva_at_start", "targetname"), ::add_spawn_function, ::event5_wave_0_think);
	nvas_jeep = GetEntArray("jeep_nva_at_start", "targetname");
	guys = simple_spawn(nvas_jeep);

	level thread heroes_load_jeep();

	while(1)
	{
		dist = Distance2D( level.player.origin, level.jeep_tow GetTagOrigin("tag_passenger2"));

		if(dist < 85 && !level.e5b_jumpto)
		{
			level.player DisableWeapons();
			level.player HideViewModel();
			jeep_mount_hands = spawn_anim_model("player_hands", level.player.origin, level.player.angles);
			jeep_mount_hands.animname = "player_hands";
			/#
			level thread jeep_origin_debug(jeep_mount_hands);
			#/
			level.player StartCameraTween(0.2);
			level.jeep_tow thread anim_single_aligned(jeep_mount_hands, "enter_jeep");		
			wait 0.05;
			level.player PlayerLinkToAbsolute(jeep_mount_hands, "tag_player");

			level.jeep_tow waittill("enter_jeep");
			level.player Unlink();
			level.player PlayerLinkToDelta( level.jeep_tow, "tag_passenger2", 0.5 );

			jeep_mount_hands Delete();
			level.player EnableWeapons();
			level.player ShowViewModel();
			break;
		}

		wait 0.05;
	}

	autosave_by_name("e5_player_in_jeep");
	
	level thread setup_tow();	
	level.player thread player_loadout_jeep();
	//level.player thread prevent_gun_death();
	level.overridePlayerDamage = ::override_player_damage;

	level notify("give_ammo");

	//turn OFF ambient effects Uphill areas to entrance of destroyed bunker
	//stop_exploder(42);

	//stop mortars from event4b
	level notify("stop_mortars");
	
	flag_set("player_on_jeep");	
	level notify("cleanup_e4b_bunker");
	
	flag_wait("allies_on_jeep");

	wait 1;
	
	//TUey set up music
	setmusicstate ("IN_THE_JEEP");

	level.jeep_tow thread go_path(jeep_path);
	playsoundatposition( "veh_peel_out", (0,0,0) );
	level.jeep_tow thread jeep_tow_think();

	level thread start_jeep_vo();
}

enter_jeep_fail()
{
	level endon("player_on_jeep");

	node = GetVehicleNode("node_t55_base_path_3", "targetname");
	x = level.player GetEye();

	//buttons aren't supported in deathquotes, removing call
	//level thread jeep_start_death_hint_watcher();

	while(1)
	{
		if(level.player.origin[0] < -14800) //map line
		{
			MagicBullet("ak47_sp", node.origin, x, level.player);
			wait 0.05;
			level.player khe_sanh_die();
		}

		wait 0.05;
	}
}
/#
jeep_origin_debug(hands)
{
	level.player endon("death");

	while(1)
	{
		DebugStar(level.jeep_tow GetTagOrigin( "tag_origin" ), 1, (0,1,0) ); //green
		if(IsDefined(hands))
		{
			DebugStar(hands GetTagOrigin( "tag_player" ), 1, (0,0,1) ); //blue
			DebugStar(hands GetTagOrigin( "tag_origin" ), 1, (0,1,1) ); //yellow?
		}
		wait 0.05;
	}
}
#/
heroes_load_jeep()
{
	//studio to breadcrumb
	flag_set("obj_repel_infantry_complete");

	//was true at start of area coming out of tunnel
	level.squad["woods"].ignoreall = false;
	level.squad["hudson"].ignoreall = false;

	level.squad["woods"] thread anim_single(level.squad["woods"], "jeep_go");//On me.

	level.squad["woods"] SetGoalNode(GetNode( "node_woods_go_jeep", "targetname" ));
	level.squad["hudson"] SetGoalNode(GetNode( "node_hudson_go_jeep", "targetname" ));

	wait 0.25;
	level.squad["hudson"] anim_single(level.squad["hudson"], "hudson_bravado");//I'll draw their fire!

	waittill_multiple_ents(level.squad["woods"], "goal", level.squad["hudson"], "goal");

	//flag_set("obj_repel_infantry_complete");

	level.squad["woods"] anim_single(level.squad["woods"], "hudson_bravado");//And I thought he was a pussy...

	wait 0.5;

	//level.squad["woods"] thread anim_single(level.squad["woods"], "jeep_approach");//Now that's a jeep!
	level.squad["woods"] anim_single(level.squad["woods"], "jeep_approach");//Now that's what I'm talkin' about!
	wait 0.15;
	level.squad["woods"] anim_single(level.squad["woods"], "jeep_approach_tow");//Jump in back - get on the TOW.

	level.squad["woods"] thread run_to_vehicle_load( level.jeep_tow, false, "tag_driver" );
	level.squad["hudson"] thread run_to_vehicle_load( level.jeep_tow, false, "tag_passenger" );

	waittill_multiple_ents(level.squad["woods"], "enteredvehicle", level.squad["hudson"], "enteredvehicle");

	flag_set("allies_on_jeep");

	//tries to address pop during jeep idles
	level.squad["woods"] DisableClientLinkTo();
	level.squad["hudson"] DisableClientLinkTo();

}

//TODO I
//should really make a generic random vo player
start_jeep_vo()
{
	level endon("obj_e5_tow_tanks_complete");
	play_once = false;

	level.player.animname = "mason";
	level.player anim_single(level.player, "enter_tow");//This thing's built like a tank!
	wait 0.25;
	level.squad["woods"] anim_single(level.squad["woods"], "enter_tow_reply");//Yeah... But a damn sight more maneuverable!

	level notify("jeep_vo_done");

	while(1)
	{
		if(level.in_use && !play_once)
		{
			wait 1.15;
			play_once = true;
			level.squad["woods"] anim_single(level.squad["woods"], "steer_tow");//Use the controls to steer the TOW missle!
		}

		if(flag("tank_destroyed"))
		{
			flag_clear("tank_destroyed");
			x = RandomIntRange( 0, 10 );
			line_select = RandomIntRange( 0, 5 );		

			if(x <= 8 )
			{
				level.squad["woods"] anim_single(level.squad["woods"], "tank_hit_" + line_select);
/*
["tank_hit_0"] = "vox_khe1_s99_910A_wood"; //Good hit!
["tank_hit_1"] = "vox_khe1_s99_911A_wood"; //You nailed 'em!
["tank_hit_2"] = "vox_khe1_s99_912A_wood"; //Keep it up!
["tank_hit_3"] = "vox_khe1_s99_913A_wood"; //They felt that one!
["tank_hit_4"] = "vox_khe1_s99_914A_wood"; //Direct hit!
["tank_hit_5"] = "vox_khe1_s99_915A_wood"; //You got him!
*/
			}
		}

		wait 0.05;
	}
}



//self is tank
in_base_shoot_think(hero_jeep)
{
	self endon("death");

	FIRE_WAIT_X = 2;
	FIRE_WAIT_Y = 4;
	level.SHOOT_PLAYER = 12;
	timer = 0;

	exclude = [];
	exclude = array_add( exclude, level.squad["woods"]);
	exclude = array_add( exclude, level.squad["hudson"]);

	while(1)
	{
		targets = GetAIArray("allies");
		targets = array_exclude(targets, exclude);
		
		if(hero_jeep)
		{
			x = RandomIntRange(0, 10);
			
			if(!flag("use_the_tow"))
			{
				timer = 0;
			}

			if(timer >= level.SHOOT_PLAYER && flag("use_the_tow"))
			{
				//shoot player
				timer = 0;
				shoot_this = level.player.origin;
			}
			else if(x <= 1 && timer < level.SHOOT_PLAYER && !flag("use_the_tow"))
			{
				//shoot around jeep			
				if(IsDefined(level.jeep_tow))
				{
					shoot_this = tank_target_hero_jeep(600, self);
				}
				else
				{
					x = random(targets);
					shoot_this = x.origin;
				}
			}
			else
			{
				//shoot redshirts	
				x = random(targets);
				shoot_this = x.origin;
			}
		}	
		else
		{
			x = random(targets);
			shoot_this = x.origin;
		}		

		//set target to fire at
		self SetTurretTargetVec(shoot_this);

		//turrets return this by default
		self waittill("turret_on_target");

		trace_fraction = self SightConeTrace(shoot_this, level.player);

		if( trace_fraction > 0)
		{
			self FireWeapon();
		}

		x = RandomFloatRange(FIRE_WAIT_X,FIRE_WAIT_Y);
		
		if(flag("use_the_tow"))
		{
			timer += x;
		}
		wait x;
	}
}

tank_target_hero_jeep(dist, tank)
{
	target_list = [];

	DIST_FROM_JEEP = dist;
	DIST_FROM_JEEP_REVERSE = DIST_FROM_JEEP * -1;

	jeep_org_offset = level.jeep_tow.origin + (0, 0, 60);

	jeep_forward = jeep_org_offset + AnglesToForward( level.jeep_tow.angles ) * DIST_FROM_JEEP;
	jeep_back = jeep_org_offset + AnglesToForward( level.jeep_tow.angles ) * DIST_FROM_JEEP_REVERSE;
	jeep_right = jeep_org_offset + AnglesToRight( level.jeep_tow.angles ) * DIST_FROM_JEEP;
	jeep_left = jeep_org_offset + AnglesToRight( level.jeep_tow.angles ) * DIST_FROM_JEEP_REVERSE;
	
	//front left
	target_list[0] = jeep_forward + AnglesToRight( level.jeep_tow.angles ) * DIST_FROM_JEEP_REVERSE;
	//front
	target_list[1] = jeep_forward;
	//front right
	target_list[2] = jeep_forward + AnglesToRight( level.jeep_tow.angles ) * DIST_FROM_JEEP;	
	//left
	target_list[3] = jeep_left;
	//center	
	target_list[4] = jeep_org_offset;
	//right
	target_list[5] = jeep_right;
	//rear left
	target_list[6] = jeep_back + AnglesToRight( level.jeep_tow.angles ) * DIST_FROM_JEEP_REVERSE;
	//rear
	target_list[7] = jeep_back;
	//rear right

	target_list[8] = jeep_back + AnglesToRight( level.jeep_tow.angles ) * DIST_FROM_JEEP;	
/#
	for(i = 0; i < target_list.size; i++)	
	{
		if(i == 4)
		{
			Debugstar(target_list[i], 10000, (0,0,0));
		}
		else
		{
			//Debugstar(target_list[i], 10000, (1,1,1));
		}
	}
#/
	//no longer conisder the center of the jeep valid
	target_list = array_exclude( target_list , target_list[4] );

	//target_vec = random(target_list);
	target_vec = get_closest_point( tank.origin , target_list );
/#	
	Debugstar(target_vec, 10000, (1,0,0));
#/
	return target_vec;
}

jeep_tow_arclight_vo()
{
	wait 12;

	level.player.animname = "mason";
	level.player anim_single(level.player, "stop_1_a");//Roger that, six. Arc Light inbound per your mission.
	level.player anim_single(level.player, "stop_1_b");//Arc Light, 5 minutes out.
	
	flag_wait("obj_tow_jeep_phase_2");

	wait 5;

	level.player anim_single(level.player, "stop_2_a");//Arc Light, 2 minutes out.
	level.player anim_single(level.player, "stop_2_b");//Say again, this is Arc Light.

	flag_wait("obj_tow_jeep_phase_3");

	wait 5;

	level.player anim_single(level.player, "stop_3_a");//Arc Light, 1 minute out.
	level.player anim_single(level.player, "stop_3_b");//Arc Light has established orbit.
	level.player anim_single(level.player, "stop_3_c");//Arc Light is locked in and starting our bomb run.
}

//vo nag lines to shoot tanks
jeep_tank_nag()
{
	level endon("end_jeep_tow_ride");
	timer = 0;
	line_select = 0;

	x = 4;

	while(1)
	{
		if(flag("end_jeep_tow_ride"))
		{
			break;
		}

		if(!flag("use_the_tow"))
		{
			timer = 0;
		}

		if(timer >= x && flag("use_the_tow"))
		{
			x = RandomIntRange(10, 12);
			timer = 0;
			line_play_chance = RandomIntRange( 0, 10 );
			//line_select = RandomIntRange( 0, 5 );
			line_select++;

			if(line_play_chance <= 7 )
			{
				battlechatter_off("allies");
				level.squad["woods"] anim_single(level.squad["woods"], "tank_nag_" +line_select);
				/*
level.scr_sound["woods"]["tank_nag_0"] = "vox_khe1_s99_929A_wood"; //Focus on the tanks!
level.scr_sound["woods"]["tank_nag_1"] = "vox_khe1_s99_930A_wood"; //Deal with the tanks!
level.scr_sound["woods"]["tank_nag_2"] = "vox_khe1_s99_931A_wood"; //The tanks, Mason!
level.scr_sound["woods"]["tank_nag_3"] = "vox_khe1_s99_932A_wood"; //The tanks - You gotta hit 'em, Mason!
level.scr_sound["woods"]["tank_nag_4"] = "vox_khe1_s99_933A_wood"; //Take out those fucking tanks!
level.scr_sound["woods"]["tank_nag_5"] = "vox_khe1_s99_934A_wood"; //Those tanks ain't going anywhere!
				*/
				battlechatter_on("allies");
			}

			if(line_select >= 5)
			{
				line_select = 0;
			}
		}

		wait 0.05;
		timer += 0.05;
	}
}

//self is jeep
jeep_tow_think()
{
	//level endon("obj_e5_tow_tanks_complete");
	//start them on their drive idles
	//self thread anim_loop(self, "keychain", "jeep_drive_idle"); //anim scr is in khe_sanh_fx.gsc
	self thread anim_loop_aligned(level.squad["woods"], "jeep_ride_drive", "tag_driver", "jeep_drive_idle");
	self thread anim_loop_aligned(level.squad["hudson"], "jeep_ride_drive", "tag_passenger", "jeep_drive_idle");

	//narrtive arclight VO
	level thread jeep_tow_arclight_vo();
	
	//shows instruction to control missile
	level thread jeep_tow_hint();
	
	//woods yells nag lines to shoot tanks while in tow
	level thread jeep_tank_nag();

	//FIRST STOP
	self thread stop_jeep("stop_jeep");

	flag_wait("obj_tow_jeep_phase_2");
	
	self thread start_jeep();

	//SECOND STOP
	self thread stop_jeep("stop_jeep");

	//make sure the player doesn't enter a death loop
	level.player thread jeep_save_invulnerability();
	autosave_by_name("e5_2nd_stop");

	wait 2;

	flag_wait("obj_tow_jeep_phase_3");
	
	self thread start_jeep();

	//THIRD STOP
	self thread stop_jeep("stop_jeep");

	autosave_by_name("e5_third_stop");

	wait 2;

	flag_wait("end_jeep_tow_ride");

	flag_clear("use_the_tow");
	player_exit_tow();

	level.player EnableInvulnerability();

	//end the amb strikes vo
	level notify("end_amb_airstrikes_vo");

	//kills ambient tank function
	level notify("kill_ambient_tanks");
	
	level thread finale_explosions();

	//wait 1.7;
	flag_wait("start_final_explosion");

	self ResumeSpeed(10);
	self SetSpeed(20, 10, 5);
	playsoundatposition( "veh_peel_out", (0,0,0) );

	//FINALE STOP
	//vehicle_node_wait( "stop_jeep" , "script_noteworthy" );
	self waittill("reached_end_node");
	self notify("jeep_drive_idle");

	playsoundatposition( "veh_skid", (0,0,0) );

	wait 0.3;
	flag_set("start_finale");
}

//self is the player
jeep_save_invulnerability()
{
	self EnableInvulnerability();
	wait(5);
	self DisableInvulnerability();
}

stop_jeep(worthy_name)
{
	vehicle_node_wait( worthy_name , "script_noteworthy" );
	playsoundatposition( "veh_skid", (0,0,0) );
	self LaunchVehicle( (0, 25, 0), self GetTagOrigin("tag_passenger2") );
	self SetSpeed(0, 10, 5);
	
	self notify("jeep_drive_idle");
	self thread anim_loop_aligned(level.squad["woods"], "jeep_ride_stop", "tag_driver", "jeep_stop_idle");
	self thread anim_loop_aligned(level.squad["hudson"], "jeep_ride_stop", "tag_passenger", "jeep_stop_idle");

	flag_set("use_the_tow");
	player_enter_tow();
}

start_jeep()
{
	flag_clear("use_the_tow");
	player_exit_tow();

	wait 10;

	//handle switching between 
	self notify("jeep_stop_idle");
	//self thread anim_loop(self, "keychain", "jeep_drive_idle"); //anim scr is in khe_sanh_fx.gsc
	self thread anim_loop_aligned(level.squad["woods"], "jeep_ride_drive", "tag_driver", "jeep_drive_idle");
	self thread anim_loop_aligned(level.squad["hudson"], "jeep_ride_drive", "tag_passenger", "jeep_drive_idle");

	self ResumeSpeed(10);
	self SetSpeed(20, 10, 5);
	playsoundatposition( "veh_peel_out", (0,0,0) );
}

jeep_tow_hint()
{
	//waits for the enter the tow anim is played for the first time
	flag_wait("tow_tutorial");
	screen_message_create(&"KHE_SANH_TVMISSILE_CONTROLS");
	level.player waittill_notify_or_timeout("guided_missile_exploded", 5);
	screen_message_delete();
}

event5_ambient_airstrikes()
{
	//level endon("obj_e5_tow_tanks_complete");
	level endon("end_jeep_tow_ride");
	level.e5_air_interval = 7;
	phantom_path = [];

	level thread ambient_airstrikes_vo_setup();
	
	//so that first strike occurs in 3 secs
	timer = 0;

	for(i = 0; i < 16; i++)
	{
		phantom_path[i] = getvehiclenode("node_amb_f4_path_" +i, "targetname");
	}

	//stop mortars and drones when ambient airstrikes start.
	level notify("stop_mortars");
	level thread remove_drone_structs(level.drone_trigger_e5_right, false, 30);
	level thread remove_drone_structs(level.drone_trigger_e5_left, false, 30);
	//level.drone_trigger_e5_right Delete();
	//level.drone_trigger_e5_left Delete();

	while(1)
	{
		if(timer > level.e5_air_interval)
		{
			timer = 0;
			level notify("phantom_drop");
			x = RandomIntRange(0, 15);
			y = RandomIntRange(0, 9);
			if(y < 5)
			{
				phantom = SpawnVehicle("t5_veh_jet_f4_gearup_lowres", "event5_phantom", "plane_phantom_gearup_lowres", phantom_path[x].origin, phantom_path[x].angles );
			}
			else
			{
				phantom = SpawnVehicle("t5_veh_jet_f4_gearup_lowres_marines", "event5_phantom", "plane_phantom_gearup_lowres_camo", phantom_path[x].origin, phantom_path[x].angles );
			}
			phantom.takedamage = false;
			phantom.ignoreme = true;
			phantom maps\khe_sanh_fx::f4_add_contrails();
			phantom SetForceNoCull();
			phantom thread go_path(phantom_path[x]);
			phantom thread cleanup_vehicle();
			phantom thread plane_position_updater (500, "evt_f4_short_wash_loud", "null");

			wait 0.6;
			phantom event5_napalm_grid(x);
		}
	
		wait 1;
		timer++;
	}
}

//transitions vo playback from radio to jeep radio
ambient_airstrikes_vo_setup()
{
	level.jeep_tow_radio = spawn("script_model", level.jeep_tow GetTagOrigin("tag_tow_attach"));
	level.jeep_tow_radio SetModel("tag_origin");
	level.jeep_tow_radio.animname = "amb_phantom_vo";
	level.jeep_tow_radio LinkTo(level.jeep_tow, "tag_tow_attach");
	
	level.jeep_tow_radio anim_single(level.jeep_tow_radio, "strike_1");//Affirmative X-ray. Engaging.
	
	level.jeep_tow_radio thread ambient_airstrikes_vo_player();
	
	flag_wait("allies_on_jeep");

	flag_wait("obj_e5_tow_tanks_complete");
	level notify("end_amb_airstrikes_vo");

	//level.jeep_tow_radio Delete();
}

//self is entity
ambient_airstrikes_vo_player()
{
	level endon("end_amb_airstrikes_vo");
	timer = 0;

	while(1)
	{
		if(flag("obj_e5_tow_tanks_complete"))
		{
			break;
		}
		
		if(timer >= (level.e5_air_interval - 1))
		{
			self.animname = "amb_phantom_vo";
			timer = 0;
			line_play_chance = RandomIntRange( 0, 10 );
			line_select = RandomIntRange( 0, 9 );
			
			if(line_play_chance <= 4 )
			{
				self anim_single(self, "strike_" +line_select);
/*
["strike_0"] = "vox_khe1_s99_918A_b52r_f"; //Roger that, X-ray. VF 143 Standing by.
["strike_1"] = "vox_khe1_s99_919A_b52r_f"; //Affirmative X-ray. Engaging.
["strike_2"] = "vox_khe1_s99_920A_b52r_f"; //Coordinates received.  Keep your heads down, X-ray.
["strike_3"] = "vox_khe1_s99_921A_b52r_f"; //Understood X-ray. Commencing run.
["strike_4"] = "vox_khe1_s99_922A_b52r_f"; //VF 143. Beginning bomb run.
["strike_5"] = "vox_khe1_s99_923A_b52r_f"; //Roger X-ray. Coming in for a strafing run.
["strike_6"] = "vox_khe1_s99_924A_b52r_f"; //Understood. Stand by, X-ray.
["strike_7"] = "vox_khe1_s99_925A_b52r_f"; //VF 143 inbound.
["strike_8"] = "vox_khe1_s99_926A_b52r_f"; //Roger X-ray - Targetting Sector.
*/
			}
		}

		wait 0.05;
		timer += 0.05;
	}
}

event5_redshirt_jeep()
{
	trigger_use("trig_redshirt_jeep");
	flag_wait("obj_get_in_jeep");

	redshirt_jeep = GetEnt("redshirt_jeep", "targetname");
	redshirt_jeep maps\_vehicle::getonpath(GetVehicleNode( "node_redshirt_jeep_0",  "targetname" ));

	redshirt_jeep thread cleanup_vehicle();

	redshirt_jeep go_path(GetVehicleNode( "node_redshirt_jeep_0",  "targetname" ) );

	marines = [];
	for(i = 0; i < 2; i++)
	{
		marines[i] = GetEnt("jeep_redshirt_" +i, "targetname");
		marines[i] Delete();
	}
}

//self is level
event5_t55_ambient()
{
	self endon("kill_ambient_tanks");
	
	level.DRONE_TANK_CAP = 15;
	vista_path_paths = [];
	vista_path_total = GetVehicleNodeArray("node_tank_vista_path", "script_noteworthy");
	
	for(i = 0; i < vista_path_total.size; i++ )
	{
		vista_path_paths[i] = GetVehicleNode("e5_tank_amb_path_" +i, "targetname"); //8 total		
	}

	level.drone_tank = [];
	x = 0;

	while(1)
	{
		level.drone_tank = array_removeUndefined( level.drone_tank );
		if(level.drone_tank.size < level.DRONE_TANK_CAP)
		{
			if(x == vista_path_paths.size)
			{
				x = 0;
			}

			path = vista_path_paths[x];
			tank = SpawnVehicle("t5_veh_tank_t55", "t55_ambient", "tank_t55", path.origin, path.angles );
			maps\_vehicle::vehicle_init(tank);
			tank thread go_path(path);
			tank thread cleanup_vehicle();
			level.drone_tank = array_add( level.drone_tank, tank );
			x++;
			wait 2.5;
		}

		wait 0.05;
	}
}

event5_first_wave()
{
	array_thread(GetEntArray("nva_spawners_wave_0", "script_noteworthy"), ::add_spawn_function, ::event5_wave_0_think);
	trigger_use("trig_e5_nva_sm_left");
}

event5_wave_0_think()
{
	self.goalradius = 128;
	self.ignoresuppression = true;
	self.script_accuracy = 0.15;
	
	if(IsDefined(self.script_string) && self.script_string == "e5_anti_player")
	{
		self setThreatBiasGroup( "e5_anti_player" );
	}
	else
	{
		self setThreatBiasGroup( "e5_anti_allies" );
	}
	
	if(IsDefined(self.script_string) && self.script_string == "cqb_me")
	{
		self AllowedStances("crouch");
		self change_movemode("cqb_sprint");
	}
}

event5_setup_redshirts()
{
	//level endon("stop_redshirt_movement");

	array_thread(GetEntArray("e5_redshirt", "targetname"), ::add_spawn_function, ::event5_redshirt_think);
	
	//activate allies
	trigger_use("e5_ally_spawner");
}

event5_redshirt_think()
{
	self.goalradius = 128;
	self.script_accuracy = 0.5;
	self SetThreatBiasGroup( "e5_player_allies" );
	self magic_bullet_shield();
}

event5_napalm_grid(path_start)
{
	//if 16 exploders detonating 3 explosions
	x = 500 + path_start;
	//Exploder(x);

	if(even_number(path_start))
	{
		PlaySoundAtPosition( "chr_tinitus", (0,0,0) );  // RIIINNNGGG
	}

	Earthquake(0.3, 2, level.player.origin, 200, level.player);
	level thread custom_rumble(0.02, 10);
}

//sets up the tow and runs a loop to allow entry ans exit animations when using the tow
setup_tow()
{
	level.in_use = false;
	message = false;
	level.player AllowProne( false );

	level.tow MakeTurretUnusable();
	level.player_hands = spawn_anim_model("player_hands", level.player.origin, level.player.angles);
	level.player_hands.animname = "player_hands";
	level.player_hands Hide();

	level.player_hands LinkTo(level.jeep_tow, "tag_tow_attach");

	//run tow threads
	//switches hero light tanks when in tow overlay
	level.player thread tow_hero_light_hackery();
	
	//watches for missile when fired
	level.player thread missile_fire();
	
	//runs a thread on a massive trigger to force detonate missile if it exits the trigger
	level.player thread tow_boundary_logic();

	//forces the player off the tow and jeep when the battle ends
	level.player thread tow_force_off(level.tow, level.player_hands);
	
	//forces the player to reuse the tow if there are still tanks to shoot
	level.player thread force_use_tow(level.tow);
}

//forces the player to reuse the tow if there are still tanks to shoot
//self is player
force_use_tow(turret)
{
	self endon("death");
	level endon("player_forced_out_tow");

	while(1)
	{
		//allows player to go back to tow if they miss or pre detonate
		if(flag("missile_exploded") && flag("use_the_tow"))
		{
			flag_clear("missile_exploded");
			turret MakeTurretUsable();
			turret UseBy(level.player);
			level thread custom_rumble(0.02, 15);
			self DisableTurretDismount();
			self PlayerLinkToDelta( level.jeep_tow, "tag_passenger2", 0.5 );
		}


		//need to relink the player to the jeep when defeating wave
		if(flag("missile_exploded") && !flag("use_the_tow"))
		{
			flag_clear("missile_exploded");
			level thread custom_rumble(0.02, 15);
		}

		wait 0.05;
	}
}

player_enter_tow()
{
	level.in_use = true;
	clientnotify ("tms");

	level.player SetStance( "stand" );
	level.player HideViewModel();

	//level.player DisableWeapons();

	//Need to allow weapons so that the TOW fuel gauge works. but if we give you a gun, you can fire it midflight, so give a knife.
	//basically code hacked support for an emplaced TOW for SP where the fuel gauge is read off any weapony you have. the emplaced tow
	//doesnt register its own fuel gauge.
	level.player TakeAllWeapons();
	level.player GiveWeapon( "knife_sp", 0 );
	level.player SwitchToWeapon( "knife_sp" );
	level.player AllowMelee( true );

	level.player SetClientDvar( "ammoCounterHide", 1 );

	//play anim to enter tow
	level.player_hands Show();
	level.player Unlink();//test
	level.player StartCameraTween(0.2);
	level.player PlayerLinkToAbsolute(level.player_hands, "tag_player");

	level.player EnableInvulnerability();
	level.tow anim_single_aligned(level.player_hands, "mount_tow");
	flag_set("tow_tutorial");
	level.player DisableInvulnerability();

	level.player Unlink();
	level.player_hands Hide();
	level.tow MakeTurretUsable();
	level.tow UseBy(level.player);

	//relink player to jeep
	level.player DisableTurretDismount();
	level.player PlayerLinkToDelta( level.jeep_tow, "tag_passenger2", 0.5 );
}

player_exit_tow()
{
	level notify("give_ammo");
	level.in_use = false;
	clientnotify ("tmu");
	//play anim to exit tow
	level.player Unlink();
	level.player HideViewModel();

	level.player TakeWeapon( "knife_sp", 0 );
	level.player AllowMelee( false );
	level.player SetClientDvar( "ammoCounterHide", 0 );

	level.player DisableWeapons();
	level.player_hands Show();
	
	level.player StartCameraTween(0.2);
	level.player PlayerLinkToAbsolute(level.player_hands, "tag_player");

	level.player EnableInvulnerability();
	level.tow anim_single_aligned(level.player_hands, "dismount_tow");
	level.player DisableInvulnerability();

	level.player Unlink();
	level.player_hands Hide();
	level.tow MakeTurretUnusable();

	level.player ShowViewModel();
	level.player EnableWeapons();

	//relink player to jeep
	level.player PlayerLinkToDelta( level.jeep_tow, "tag_passenger2", 0.5 );
	level.player SetStance("stand");
}

//forces the player off the tow and jeep when the battle ends
//self is player
tow_force_off(turret, hands)
{
	level.player endon("death");

	flag_wait("end_jeep_tow_ride");

	flag_set("disable_tow_usage");

	flag_wait("obj_e5_tow_tanks_complete");
	//play end vo
	level thread end_jeep_vo();

	//play exit jeep anims
	self DisableWeapons();
	self HideViewModel();
	self Unlink();	
	jeep_mount_hands = spawn_anim_model("player_hands", level.player.origin, level.player.angles);
	jeep_mount_hands.animname = "player_hands";

	level.player StartCameraTween(0.1);
	self PlayerLinkToAbsolute(jeep_mount_hands, "tag_player");
	level.jeep_tow anim_single_aligned(jeep_mount_hands, "exit_jeep");	

	jeep_mount_hands Delete();
	self ShowViewModel();
	self EnableWeapons();
	self DisableInvulnerability();
	self SetStance("stand");
	self SetLowReady(true);

	self Unlink();
	flag_set("player_forced_out_tow");
}

tow_missile_audio()
{
	clientnotify ("tms");
	self waittill("guided_missile_exploded");
	clientnotify ("tmu");	
}

//switches hero light tanks when in tow overlay
tow_hero_light_hackery()
{
	level.player endon("death");
	level endon("disable_tow_usage");

	switched_light = false;

	while(1)
	{
		if(IsDefined(level.in_use) && level.in_use && !switched_light)
		{
			wait 1.5;
			//brighten dudes while in tow view
			SetDvar( "r_heroLightScale", "2 2 2" );
			switched_light = true;
		}
		
		if(IsDefined(level.in_use) && !level.in_use && switched_light)
		{
			SetDvar( "r_heroLightScale", "1 1 1" );	
			switched_light = false;
		}

		wait 0.05;
	}
}

end_jeep_vo()
{
	level.squad["hudson"] anim_single(level.squad["hudson"], "tow_jeep_ended");//It's over...
	wait 0.25;
	level.squad["woods"] anim_single(level.squad["woods"], "tow_jeep_ended");//No... This is the start of somethin' else...
	wait 0.25;
	level.squad["woods"] anim_single(level.squad["woods"], "tow_jeep_ended_b");//...They'll be back.
}

//self is player
missile_fire()
{
	self endon("death");
	level endon("disable_tow_usage");

	while(1)
	{
		self waittill("missile_fire");
		playsoundatposition ("wpn_tow_fire_plr", (0,0,0));
		level thread custom_rumble(0.02, 15);
		self thread missile_death_set_flag();
		level.missile_fire_count++;
	}
}

missile_death_set_flag()
{
	self endon("death");
	self waittill("guided_missile_exploded");
	flag_set("missile_exploded");
}

//runs a thread on a massive trigger to force detonate missile if it exits the trigger
//self is player
tow_boundary_logic()
{
	level.player endon("death");
	level endon("disable_tow_usage");

	trigger = GetEnt("trig_tow_region", "targetname");

	while(1)
	{
		self waittill( "missile_fire", missile, weap );
		
		missile.health = 1;

		while(IsDefined(missile) && missile IsTouching( trigger ))
		{
			wait 0.05;
		}

		//this would have been awesome an hour ago!!!
		if(IsDefined(missile))
		{
			missile ResetMissileDetonationTime( 0 );
			self notify("guided_missile_exploded");
		}

		wait 0.05;
	}
}

event4_cleanup_setup()
{
	level thread event4_cleanup();
	level thread event4b_bunker_cleanup();

	ally_cleanup = GetAIArray("allies");
	nva_cleanup = GetAIArray("axis");

	for(i = 0; i < ally_cleanup.size; i++)
	{
		ally_cleanup[i] disable_replace_on_death();
		//waittillframeend;
	}

	for(i = 0; i < ally_cleanup.size; i++)
	{
		if(IsDefined(ally_cleanup[i]) && !IsDefined(ally_cleanup[i].script_noteworthy))
		{
			ally_cleanup[i] Delete();
		}
	}

	for(i = 0; i < nva_cleanup.size; i++)
	{
		if(IsDefined(nva_cleanup[i]))
		{
			nva_cleanup[i] Delete();
		}
	}
}

//self is player
player_loadout_jeep()
{
	level endon("player_forced_out_tow");
	self endon("death");

	while(1)
	{
		//need to keep refreshing weapons so the tow gas gauge works
		level waittill("give_ammo");
		
		self TakeAllWeapons();
		//self GiveWeapon( "knife_sp", 0 );
		//self GiveWeapon( "frag_grenade_sp");

		//no melee
		self AllowMelee( false );
		self GiveWeapon( "m60_sp", 0 );
		self GiveWeapon( "china_lake_sp", 0 );
		self SwitchToWeapon( "china_lake_sp" );
		
		self GiveStartAmmo("m60_sp");
		self GiveStartAmmo("china_lake_sp");
		self GiveMaxAmmo("m60_sp");
		self GiveMaxAmmo("china_lake_sp");
		wait 1;
	}
}

event5_threatbiasgroups()
{
	//SetIgnoreMeGroup("player", "e5_anti_allies");
	//SetIgnoreMeGroup("e5_player_allies", "e5_anti_player");

	level.player SetThreatBiasGroup( "player" );
	level.squad["woods"] SetThreatBiasGroup( "e5_player_allies" );
	level.squad["hudson"] SetThreatBiasGroup( "e5_player_allies" );

	//This is the base threat of group1 against group2, which translates to how much entities in group2 will favor entities in group1.
	SetThreatBias("player", "e5_anti_player", 2000);
	SetThreatBias("e5_player_allies", "e5_anti_allies", 12000);
	SetThreatBias("player", "e5_anti_allies", 100);
	SetThreatBias("e5_player_allies", "e5_anti_player", 500);
}

event5_radio_vo()
{
	e5_radio_loc = getstruct("e5_start_radio", "targetname");
	e5_radio_vo = spawn("script_model", e5_radio_loc.origin);
	e5_radio_vo SetModel("tag_origin");
	e5_radio_vo.animname = "e5_start_radio";

	e5_radio_vo anim_single(e5_radio_vo, "repeat");//Repeat your last please.
	wait 0.5;
	e5_radio_vo anim_single(e5_radio_vo, "e5_radio_more_nva");//More NVA moving in!... Inafantry and armor!
	wait 0.3;
	e5_radio_vo anim_single(e5_radio_vo, "e5_radio_division");//They must have a fucking division hid out there.

	wait 4;

	e5_radio_vo.animname = "e5_b52_status";
	e5_radio_vo anim_single(e5_radio_vo, "grid_0");//Grid pattern - Delta-five-seven and Delta-five-nine.
	wait 0.25;
	e5_radio_vo anim_single(e5_radio_vo, "grid_clear");//Clear out from those attack sectors please.
	wait 0.25;
	e5_radio_vo anim_single(e5_radio_vo, "grid_pattern");//Grid pattern - Bravo-four-one - Check that - Bravo-four-eight and ten.
	wait 0.25;
	e5_radio_vo anim_single(e5_radio_vo, "grid_complete");//Arc Light sector selection complete.

	e5_radio_vo Delete();
	level notify("bunker_radio_done");
}

override_player_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if(IsDefined(eAttacker) && eAttacker != level.player)
	{
		if(IsDefined(eAttacker.classname))
		{
			if(eAttacker.classname != "script_vehicle")
			{
				iDamage = iDamage * 0.25; //only give player 25% damage
			}
		}
	}
	else if(IsDefined(eAttacker) && eAttacker == level.player)
	{
		iDamage = iDamage * 0.6; //if player detonates missile near him allow 60% damage
	}

	iDamage = Int(iDamage);
	
	return iDamage;
}

//self is player
prevent_gun_death()
{
	self endon("death");
	level endon("start_finale");
	addhealth = 0;

	while(1)
	{
		self waittill( "damage", amount, inflictor, direction, point, type, modelName, tagName );
		if( ((type == "MOD_PISTOL_BULLET")||(type == "MOD_RIFLE_BULLET") || (type == "MOD_HEAD_SHOT") 
			|| (type == "MOD_PROJECTILE_SPLASH") || (type == "MOD_PROJECTILE")) && !IsDefined(inflictor.e5_tank) )
		{		
			if( inflictor == self )
			{
				x = amount * 0.4;
			}
			else
			{
				x = amount * 0.85;
			}
			
			x = Int(x);
			
			//for debugging why setting player health updates maxHealth
			//self.maxHealth = self.health + 100;
			//wait 1;
			addhealth = self.health + x;
			//make sure health over 100 gets set because right now there is a bug where set.health updates maxhealth
			if( addhealth > self.maxHealth )
			{
				addhealth = self.maxHealth - self.health;
			}

			self.health = self.health + addhealth;
		}
	}
}

achievement_watcher_tanks()
{
	level.missile_fire_count = 0;
	level.player endon("death");

	flag_wait("obj_e5_tow_tanks_complete");

	if(level.missile_fire_count <= 6)
	{
		level.player giveachievement_wrapper( "SP_LVL_KHESANH_MISSILES" );
	}
}

event4_cleanup()
{
	event4_ents = [];

	ents = GetEntArray("e4_cleanup_ents", "script_noteworthy");
	actors = GetEntArray("e4_trench_burners", "script_noteworthy");
	actors_a = GetEntArray("e4_bunker_nva ", "targetname");
	actors_b = GetEntArray("e4_hill_rushers ", "targetname");
	actors_c = GetEntArray("e4_hill_trans_spawner ", "targetname");
	actors_d = GetEntArray("player_allies ", "script_noteworthy");
	actors_e = GetEntArray("anti_allies ", "script_noteworthy");
	actors_f = GetEntArray("anti_player ", "script_noteworthy");

	event4_ents = array_combine(ents, actors);
	event4_ents = array_combine(event4_ents, actors_a);
	event4_ents = array_combine(event4_ents, actors_b);
	event4_ents = array_combine(event4_ents, actors_c);
	event4_ents = array_combine(event4_ents, actors_d);
	event4_ents = array_combine(event4_ents, actors_e);
	event4_ents = array_combine(event4_ents, actors_f);

	if(event4_ents.size > 0)
	{
		event4_ents = array_removeUndefined( event4_ents );
		array_delete( event4_ents );		
		event4_ents = array_removeUndefined( event4_ents );
	}
}

//self is level
event4b_bunker_cleanup()
{
	//sent when player is starting jeep tow battle
	self waittill("cleanup_e4b_bunker");

	if(IsDefined(level.e4b_bunker_ents))
	{
		level.e4b_bunker_ents = array_removeUndefined( level.e4b_bunker_ents );
		array_delete( level.e4b_bunker_ents );
	}
}

jeep_start_death_hint_watcher()
{
	level endon("start_finale");
	while(1)
	{
		level.player waittill( "death", attacker, cause, weaponName ); 
		
		if(flag("use_the_tow"))
		{
			SetDvar( "ui_deadquote", &"KHE_SANH_TVMISSILE_CONTROLS" );//remind to use controls
		}

		wait 0.05;
	}

}

