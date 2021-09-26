#include maps\_utility;
#include maps\_anim;
main()
{
	setExpFog(0.0001, .676, .730, .719, 0);
	if (getcvar("jumpto") == "")
    	setcvar("jumpto", "");

	level.jumptodocks = false;
	level.jumptocom = false;
	level.jumptomg = false;
	level.jumptoend = false;
	
	if (!isdefined(getcvar ("jumpto")))
	 	setcvar ("jumpto", "null");
	else if((getcvar ("jumpto") == "docks"))
		level.jumptodocks = true;
	else if((getcvar ("jumpto") == "com"))
	{
		level.jumptodocks = true;
		level.jumptocom = true;
	}
	else if((getcvar ("jumpto") == "mg"))
	{
		level.jumptodocks = true;
		level.jumptocom = true;
		level.jumptomg = true;
	}
	else if((getcvar ("jumpto") == "end"))
	{
		level.jumptodocks = true;
		level.jumptocom = true;
		level.jumptomg = true;
		level.jumptoend = true;
	}

	//precaches
	precacheShellshock("default");
	precacheItem("panzerfaust");
	precacheModel("xmodel/eldaba_plane_rig");
	precacheModel("xmodel/vehicle_spitfire_flying");
	precacheModel("xmodel/vehicle_stuka_flying");
	precacheModel("xmodel/prop_stuka_bomb");
	precacheModel("xmodel/weapon_panzerfaust");
	precacheModel("xmodel/prop_crate_dak9");
	precacheModel("xmodel/prop_wine_crate");
	precacheModel("xmodel/prop_kitchen_winebottle");
	precacheModel("xmodel/prop_door_wood_arched_damaged");
	precacheModel("xmodel/vehicle_cargoship");
	precacheModel("xmodel/vehicle_cargoship_d");
	precacheModel("xmodel/vehicle_cargoship_crates");
	precacheModel("xmodel/vehicle_cargoship_crates_d");
	precacheModel("xmodel/weapon_us_smoke_grenade");
	
	precacheShader("inventory_docs");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////
	//FOR E3 BUILD
	/////////////////////////////////////////////////////////////////////////////////////////////////
		precacheModel("xmodel/military_german_fieldradio_tan_obj");
		precacheModel("xmodel/military_german_radio2_tan_obj");
		precacheModel("xmodel/military_german_microphone_obj");
		precacheModel("xmodel/military_german_headset_obj");
		
		ent = spawn("script_model", (2759, 1936, 101) );
		ent setmodel("xmodel/military_german_radio2_tan_obj");
		ent.angles = (0, 246.321, 0);
		ent.targetname = "comm_obj_trig_targets";
		
		ent = spawn("script_model", (2757, 1939, 138) );
		ent setmodel("xmodel/military_german_fieldradio_tan_obj");
		ent.angles = (0, 230, 0);
		ent.targetname = "comm_obj_trig_targets";
		
		ent = spawn("script_model", (2754, 1934, 153) );
		ent setmodel("xmodel/military_german_microphone_obj");
		ent.angles = (0, 258.3, 0);
		ent.targetname = "comm_obj_trig_targets";
		
		ent = spawn("script_model", (2761, 1943, 153) );
		ent setmodel("xmodel/military_german_headset_obj");
		ent.angles = (0, 10.9, 0);
		ent.targetname = "comm_obj_trig_targets";
		
		trig = getent("comm_obj_trig","targetname");
		trig.target = "comm_obj_trig_targets";
	/////////////////////////////////////////////////////////////////////////////////////////////////
	//
	/////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	level.strings["com"] = &"ELDABA_PLATFORM_HINTSTR_USERADIO";
	level.strings["doc"] = &"ELDABA_PLATFORM_HINTSTR_DOCUMENTS";	
	precacheString(level.strings["com"]);
	precacheString(level.strings["doc"]);
	
	level.obj_string["docks1"] 		= &"ELDABA_OBJ_DOCKS1"; 
	level.obj_string["docks2"] 		= &"ELDABA_OBJ_DOCKS2";  
	level.obj_string["com"] 		= &"ELDABA_OBJ_COM";
	level.obj_string["hq"] 			= &"ELDABA_OBJ_HQ";
	level.obj_string["price"] 		= &"ELDABA_OBJ_PRICE";
	
	precacheString(level.obj_string["docks1"]);
	precacheString(level.obj_string["docks2"]);
	precacheString(level.obj_string["com"]);
	precacheString(level.obj_string["hq"]);
	precacheString(level.obj_string["price"]);
	
	turrets = getentarray("mgnest_autotargets","target");
	turrets[turrets.size] = getent("mg_blockage_gun","targetname");
	for(i=0;i<turrets.size;i++)
		turrets[i] setturretignoregoals(true);
	
	//get this stuff done first
	force_intro_truck_positions();
	
	//global scripts
	maps\_jeep::main("xmodel/vehicle_africa_jeep");
	maps\_jeep::main("xmodel/vehicle_africa_jeep_can");
	maps\_truck::main("xmodel/vehicle_opel_blitz_desert");
	maps\_crusader::main("xmodel/vehicle_crusader2");
	maps\_flak88::main("xmodel/german_artillery_flak88");

	maps\_tankai::main();	
	maps\_tankai_crusader::main("xmodel/vehicle_crusader2");
	maps\eldaba_fx::main();	
	maps\_load::main();
	maps\_float::main(undefined, undefined, 500, undefined, undefined);//range, freq, wavelength, rotation, origin
	maps\eldaba_anim::main();
	level thread maps\eldaba_amb::main();
	
	// tweak the first mgs to make them less oppressive
	thread special_mg_settings();
	thread special_demo_settings();
	
	level.flag["player_flanked_right"] = false;
	level.flag["wave_me_home"] = true;
	level.flag["mg42guys_wakeup_ready"] = false;
	level.flags["Breakable Boxes"] = false;
	flag_init("first_area_complete");
	level.breakingEnts = [];
	
	if(!level.jumptodocks)
	{
		//thread maps\_introscreen::introscreen(level.strings["intro1"], level.strings["intro2"], level.strings["intro3"]);		
		musicPlay("eldaba_intro_music");
	}	
	//global variables
	level.global_ed_assmin 	= 1;
	level.global_ed_assmax 	= 6;	
	
	
	
	if(!level.jumptodocks)
	{
		trig = getent("first_trigger", "targetname");
		trig notify("trigger");
	}
	
	spwnrs = getentarray("hq_houseguys1","targetname");
	temp = getentarray("hq_houseguys2","targetname");
	spwners = array_merge(spwnrs, temp);
	temp = getentarray("spawner_artillery","targetname");
	spwners = array_merge(spwnrs, temp);
	temp = getentarray("auto8395","targetname");
	spwners = array_merge(spwnrs, temp);
	temp = getentarray("auto8394","targetname");
	spwners = array_merge(spwnrs, temp);
	temp = getentarray("auto8398","targetname");
	spwners = array_merge(spwnrs, temp);
	temp = getentarray("mg_run_guys","targetname");
	spwners = array_merge(spwnrs, temp);
	
	array_thread(spwners, ::disable_long_deaths);
	
	//main loops
	thread disable_long_deaths();
	thread objectives();
	thread mosque_think();
	thread end_main();
	thread friendly_main();									
	thread dialogue_main();
	thread mg_wakeup();
	thread mg_main();
	thread lampglowfx();
	
	thread flank_right_trip();
	
	//misc global triggers
	triggers = getentarray("kill_all_axis", "targetname");
	array_thread(triggers, ::kill_all_axis);
	triggers = getentarray("playsound","targetname");
	array_thread(triggers, ::playsound_ontrigger);
	
	if(!level.jumptodocks)				
		thread intro_main();
	if(!level.jumptocom)
		thread flaks_main();
	if(!level.jumptomg)
		thread docks_main();
	else
	{
		trig = getent("leavingdocks","targetname");
		trig triggerOff();
		trig = getent("spawner_artillery","target");
		trig triggerOff();
		trig = getent("auto7080","target");
		trig triggerOff();
		trig = getent("runupdocks", "target");
		trig triggerOff();

		thread docks_EXP_boatsink("supplyboat2");
	    thread docks_EXP_mortar_hole("dock_mortar_hole2", "dock_mortar_hole2_remove", "flak_gun2");
	    thread docks_EXP_mortar_hole("dock_mortar_hole1", "dock_mortar_hole1_remove", "flak_gun4");
	    thread docks_EXP_boatsink("supplyboat1");
	}
	if(!level.jumptoend)
		thread sky_main();
		
	shadow = getent("dock_mortar_dock_shadow2","targetname");
	shadow hide();
		
	if(level.jumptoend)
		level.player setorigin ((832, -375, 188));
	else if(level.jumptomg)
		level.player setorigin ((2826, 1911, 100));
	else if(level.jumptocom)
		level.player setorigin ((1343,1576,30));
	else if(level.jumptodocks)
		level.player setorigin ((-1385,245,40));
		
	level.player.threatbias = 250;
	
	if (getcvar("demolevel") == "")
    	setcvar("demolevel", "");
	if((getcvar ("demolevel") == "1"))
		thread eldaba_demo_main();
}

flank_right_trip()
{
	nodes = getnodearray("intro_flank_right_trip", "script_noteworthy");
	nodes2 = getnodearray("intro_flank_right_trip", "targetname");	
	
	node = getFurthestNode(nodes2[0].origin, nodes);
	nodes = array_remove(nodes, node);
	node.flanknum = 2;
	node = getFurthestNode(nodes2[0].origin, nodes);
	nodes = array_remove(nodes, node);
	node.flanknum = 4;
	node = getFurthestNode(nodes2[0].origin, nodes);
	nodes = array_remove(nodes, node);
	node.flanknum = 1;
	node = getFurthestNode(nodes2[0].origin, nodes);
	nodes = array_remove(nodes, node);
	node.flanknum = 3;
	nodes = getnodearray("intro_flank_right_trip", "script_noteworthy");
	
	spwn = [];
	for(i=0;i<nodes.size;i++)
	{
		spwn[spwn.size] = getent(nodes[i].targetname, "target");
		spwn[spwn.size-1].flank_right_time = i;
		spwn[spwn.size-1].flank_right_node = random(nodes2);
		nodes2 = array_remove(nodes2, spwn[spwn.size-1].flank_right_node);
		spwn[spwn.size-1].flank_right_num = nodes[i].flanknum;
	}

	array_thread(spwn, ::flank_right_guys);
}

#using_animtree("generic_human");
flank_right_guys()
{
	level endon("player_flanked_right");
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;
	
	guy endon("death");
	
	wait 4;
	
	guy thread magic_bullet_shield();
	guy.ignoreme = true;
	guy set_forcegoal();
	guy.anim_forced_cover = "hide";
	guy thread flank_right_guys_end();
	guy.anim_disablePain = true; 
	guy.oldgrenadeawareness = guy.grenadeawareness;
	guy.grenadeawareness =0;
	
	//level waittill("mac_said_flank_right");
	//level waittill("dismounted truck");
	trig = getent("intro_runeventtrig","targetname");
	trig waittill("trigger");
	
	switch(self.flank_right_num)
	{
		case 1:
		{
			wait randomfloat(.5);
			self thread flank_right_guys_go(guy, "UK_2_order_move_follow");
		}break;
		case 2:
		{
			wait randomfloat(.5);
			self thread flank_right_guys_go(guy);//, "UK_1_order_move_follow");	
		}break;
		case 3:
		{
			wait randomfloat(.5);
			self thread flank_right_guys_go(guy);//, "UK_3_order_move_follow");
		}break;
		case 4:
		{
			wait randomfloat(.5);
			self thread flank_right_guys_go(guy);
		}break;
			
	}
}

flank_right_guys_end()
{
	self endon("death");
	level waittill("player_flanked_right");
	
	self thread flank_right_setnormal();
}

flank_right_setnormal()
{
	assert (!flag("first_area_complete"));
	
	self notify ("stop magic bullet shield");
	self unset_forcegoal();
	self.followingPlayer = true;
	self.ignoreme = false;
	self.anim_forced_cover = "none";
	self.anim_disablePain = false;
	self.run_noncombatanim = undefined;
	self.run_combatanim = undefined; 
	if (isdefined(self.oldgrenadeawareness))
	self.grenadeawareness = self.oldgrenadeawareness;
		
	flag_wait("friendly_chain");
	if (isalive(self))
	{	
		level endon ("first_area_complete");
		self.followmin = 3;
		self.followmax = 12;
		self setgoalentity (level.player);
		self waittill ("death");
	}
	
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		if (isdefined(ai[i].followingPlayer))
			continue;
		assert(isalive(level.macgregor));
		if (ai[i] == level.macgregor)
			continue;
		ai[i] thread flank_right_setnormal();
		ai[i] thread temporary_ignore();
		break;
	}
}

temporary_ignore()
{
	self endon ("death");
	self.ignoreme = true;
	self.suppressionwait = 0;
	wait (9);
	self.ignoreme = false;
}

flank_right_guys_go(guy, msg)
{
	guy setgoalnode(self.flank_right_node);
	self notify ("stop magic bullet shield");
	level endon ("first_area_complete");
	wait .75;
	if(isdefined(msg))
		guy playsound(msg);
	
	guy waittill("goal");
	
	guy thread flank_right_setnormal();
}

shadow_hints()
{
	wait 1;

	playerVehicle = getent( "player_truck1", "script_noteworthy" );
	jeep1 = getent( "auto232", "targetname" );
	jeep2 = getent( "auto235", "targetname" );

	playerVehicle setshadowhint( "receiver" );
	jeep1 setshadowhint( "always" );
	jeep2 setshadowhint( "always" );

	level waittill ("dismounted truck");
	jeep1 setshadowhint( "normal" );
	jeep2 setshadowhint( "normal" );

	level waittill("player_flanked_right");
	playerVehicle setshadowhint( "normal" );	
}

lampglowfx()
{
	lightfx = getentarray("ed_chainlamp_glowFX_origin","targetname");
	for(i=0;i<lightfx.size; i++)
		maps\_fx::loopfx("glow_moroccan_chainlamp", lightfx[i].origin, 0.3, lightfx[i].origin + (0,0,1));
}

force_intro_truck_positions()
{
	mac = getent("macgregor","script_noteworthy");
	mac.script_startingposition = 3;
	
	bur = getent("cynical","script_noteworthy");
	bur.script_startingposition = 2;
	
	bs2 = getent("soldier2","script_noteworthy");
	bs2.script_startingposition = 7;
	
	bs3 = getent("soldier3","script_noteworthy");
	bs3.script_startingposition = 8;
}

end_main()
{
	truck = getent("end_rightflank_truck","targetname");
	truck notsolid();
	truck hide();
	truck triggerOff();
	
	thread end_mission();
	thread end_flyby();
	thread end_last_alley_dudes();
	spawners = getentarray("manflank_barricade_east","targetname");
	array_thread(spawners,::end_manflak);
	spawners = getentarray("end_leftflank_guys","targetname");
	array_thread(spawners,::end_leftflank);
	spwner = getent("end_lastenemy","targetname");
	spwner thread end_lastenemy();
	spwner = getent("end_waver", "targetname");
	spwner thread end_waver();
	
	thread open_door_msg("ed_scripted_allydoor", "move on past mg42 nest");
	
	level waittill("turn_on_end_flankright");
	//turn on the background runner
	trig = getent("end_rightflank_trigger","targetname");
	trig notify("trigger");
	truck solid();
	truck show();
	truck triggerOn();
}

end_wavertrig()
{
	trig = getent("wave_me_home","targetname");
	trig waittill("trigger");
	level.flag["wave_me_home"] = false;
	
	battleChatterOff( "allies" );
	playsoundinspace("eldaba_bs1_thisbuildingclear", (1644, 482, 210));
	thread battleChatterOn( "allies" );
}
end_waver()
{
	level waittill("last_guy_ready");
	level.lastguy waittill("death");
	node = getnode(self.target, "targetname");
	guy = self dospawn();
	if (spawn_failed(guy))
		return;
	
	thread end_wavertrig();
	guy endon("death");
	
	guy set_forcegoal();
	guy waittill("goal");
	
	level notify("turn_on_end_flankright");
	
	guy.animname = "generic";
	
	while(level.flag["wave_me_home"])
	{
		node anim_reach_solo (guy, "wave");
		node thread maps\_anim::anim_single_solo(guy, "wave");
		guy waittillmatch ("single anim", "dialog");
		playsoundinspace("eldaba_letsgo", guy.origin);
		if(level.flag["wave_me_home"])
			wait 5;
	}
	
	guy setgoalentity(level.player);
}

end_lastenemy()
{
	//self.script_startinghealth = 60000;
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;
	level.player.ignoreme = false;
	level.lastguy = guy;
	level notify("last_guy_ready");
	guy endon("death");
	
	guy.baseAccuracy = 0;
	guy.accuracy = 0;
	guy.ignoreme = true;
	guy set_forcegoal();
	guy waittill("goal");
	
	wait 1;
	
	pos = spawn("script_origin", (1752, 675, 7));
	magicbullet("kar98k", pos.origin, guy.origin);	
	pos playsound("weap_thompson_fire");
	guy DoDamage ( guy.health + 50, pos.origin );
}

end_leftflank()
{
	//self.script_startinghealth = 1000;
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;
	
	level notify("end_leftflank_spawned");
	
	guy endon("death");
	//guy.ignoreme = true;	
	
	trigger = getent("reinforcements8","target");
	trigger waittill("trigger");
	
	guy set_forcegoal();
	node = getnode("end_leftflank_node","targetname");
	
	while(isdefined(node))
	{
		guy setgoalnode(node);
		guy.goalradius = 16;
		if(isdefined(node.target))
			node = getnode(node.target, "targetname");	
		else 
			node = undefined;
		guy waittill("goal");
	}
	guy delete();
}

end_manflak()
{
	self.script_startinghealth = 1;
	level.flag["eldaba_germanrun"] = false;
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;
		
	guy endon("death");	
	guy set_forcegoal();
	guy.interval = 0;
	guy.suppressionwait = 0;
	level waittill("end_leftflank_spawned");
	
	if(!level.flag["eldaba_germanrun"])
	{
		level.flag["eldaba_germanrun"] = true;
		playsoundinspace("eldaba_germanrun", self.origin);
	}
	
	trig = getent("end_allywaydeath", "targetname");
	while(1)
	{
		trig waittill("trigger", other);
		if(other == guy)
		{
			pos = spawn("script_origin", (1097, 434, 5));
			x = 3 + randomint(3);
			for(j=0;j<x;j++)
			{
				magicbullet("kar98k", pos.origin, guy.origin + (0,0, randomfloat(20)));
				pos playsound("weap_thompson_fire");
				wait .1;
			}	
			guy DoDamage ( guy.health + 50, pos.origin );
		}
	}
	
	
}

end_tired_anims()
{
	//max wounded animations = 6;
	tired = getentarray("end_tired_anims","targetname");

	for (i=0 ; i < tired.size; i++)
	{
		animnode = getnode(tired[i].target,"targetname");
		guy = tired[i] dospawn();

		if (spawn_failed(guy))
			continue;

		guy.animname = "tired";
		guy.pacifist = 1;

		number = -1;
		if (isdefined(guy.script_noteworthy))
			number = int(guy.script_noteworthy);
		
		switch(number)
		{
			case 1:
				guy thread maps\_anim::anim_loop_solo (guy, "tiredA" , undefined, "end_loop", animnode);
				break;
			case 3:	
				guy thread maps\_anim::anim_loop_solo (guy, "tiredB" , undefined, "end_loop", animnode);
				break;
			default:
			{
				guy animscripts\shared::PutGunInHand("none");
				guy.hasWeapon = 0;
				guy thread maps\_anim::anim_loop_solo (guy, "wounded_0" , undefined, "end_loop", animnode);
			}break;
		}
	//		guy thread maps\_anim::anim_loop_solo (guy, "wounded_"+ , undefined, "end_loop", animnode);
	//	else
			
	}
}

end_mission()
{
	cratewalkers = getentarray("crate_walkers","script_noteworthy");
	array_thread( cratewalkers, ::end_cratewalkers );
	
	level waittill("end_mission");
	
	thread battleChatterOff( "allies" );
	
	macspawn = getent("endmission_mac","targetname");
	pricespawn = getent("endmission_price","targetname");
	endrunners = getentarray("end_runners","targetname");
	director = getent("director","targetname");
	
	thread end_tired_anims();
	director thread end_director();
	macspawn thread end_mac();
	pricespawn thread end_price();	
	
	array_thread(endrunners, ::end_runners);
	
	trigger = getent("end_mission_pricemac","targetname");
	trigger waittill("trigger");
	
	level notify("mission_complete");
	level waittill("all_end_dialogue_done");
	
	maps\_endmission::nextmission();
}
#using_animtree("generic_human");

end_cratewalkers()
{
	self waittill("spawned", guy);
	if(spawn_failed(guy))
		return;	
	
	guy endon("death");
	
	guy.walk_combatanim2 		= %eldaba_walk_crate;
	guy.walk_combatanim 		= %eldaba_walk_crate;
	guy.walk_noncombatanim2 	= %eldaba_walk_crate;
	guy.walk_noncombatanim 		= %eldaba_walk_crate;
	guy.standanim				= %eldaba_walk_crate_idle;
	
	guy animscripts\shared::PutGunInHand("none");
	guy.hasWeapon = 0;
	
	pos = guy gettagorigin("TAG_WEAPON_RIGHT");
	//model = spawn("script_model", pos);
	//model setmodel ("xmodel/prop_crate_dak1");
	
	guy attach ("xmodel/prop_crate_dak9", "TAG_WEAPON_RIGHT");
	guy.goalradius = 16;
	guy.walkdist			= 5000000;
}

end_director()
{
	guy = self dospawn();
	guy endon("death");
	node = getnode(self.target, "targetname");
	if(spawn_failed(guy))
		return;	
	guy.animname = "generic";
	
	level waittill("end_flyby");
	
	node thread maps\_anim::anim_single_solo(guy, "director");
	
	node = getnode("auto8323","targetname");
	guy setgoalnode(node);
}

end_runners()
{
	level waittill("end_flyby");
	self dospawn();
}
#using_animtree("generic_human");
end_price()
{
//	self thread animscripts\shared::SetInCombat(false);	
	
	guy = self dospawn();
	if(spawn_failed(guy))
		return;	
	guy endon("death");
	guy thread end_death_mission_fail();
	
	guy.script_bcdialog = false;
	guy maps\_utility::setBattleChatter(false);
	guy.animname = "price";
	guy.grenadeawareness = 0;
	
	guy.walk_combatanim2 		= %eldaba_scene_price_ending_idle;
	guy.walk_combatanim 		= %eldaba_scene_price_ending_idle;
	guy.walk_noncombatanim2 	= %eldaba_scene_price_ending_idle;
	guy.walk_noncombatanim 		= %eldaba_scene_price_ending_idle;
	guy.standanim				= %eldaba_scene_price_ending_idle;
	guy.walkdist			= 50000;
	guy allowedStances("stand");
	guy.goalradius = 16;
	guy.interval = 0;
	
	guy animscripts\shared::PutGunInHand("none");
	guy.hasWeapon = 0;
	guy attach ("xmodel/prop_kitchen_winebottle", "TAG_WEAPON_RIGHT");
	guy attach ("xmodel/prop_kitchen_winebottle", "TAG_WEAPON_LEFT");
	
	//guy setgoalpos(self.origin);
	//node = getnode("endmission_pricenode","targetname");
	node = spawn("script_origin", (1696, 1558, 85));
	node.angles = (0, 245.2, 0);
	guy teleport(node.origin, node.angles);
	node thread maps\_anim::anim_loop_solo ( guy, "eldaba_pri_idle", undefined, "stop_idle");
	
	trigger = getent("end_mission_pricemac","targetname");
	trigger waittill("trigger");
	
	//guy thread end_walknodepath("endmission_pricenode");
	
	node notify("stop_idle");
	level notify("mac_end_respond");
	guy dialogue_thread("eldaba_pri_cheeruplads", node);
	guy.animplaybackrate = .3;
	guy setgoalpos(guy.origin);
//	node thread maps\_anim::anim_loop_solo ( guy, "eldaba_pri_idle", undefined, "stop_idle");
	
	
}

end_death_mission_fail()
{
	while(1)
	{		
		self waittill("damage", amount, ent);
		if(ent == level.player)
			break;
	}
	setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH");
	maps\_utility::missionFailedWrapper();
}

#using_animtree("generic_human");
end_mac()
{
//	self thread animscripts\shared::SetInCombat(false);

	guy = self dospawn();
	if(spawn_failed(guy))
		return;	
	guy endon("death");
	guy thread end_death_mission_fail();
	
	guy.script_bcdialog = false;
	guy maps\_utility::setBattleChatter(false);
	guy.animname = "mac";
	guy.grenadeawareness = 0;
	
	
	guy.walk_combatanim2 		= %eldaba_walk_crate;
	guy.walk_combatanim 		= %eldaba_walk_crate;
	guy.walk_noncombatanim2 	= %eldaba_walk_crate;
	guy.walk_noncombatanim 		= %eldaba_walk_crate;
	guy.standanim				= %eldaba_walk_crate_idle;
	guy.interval = 0;
	
	guy animscripts\shared::PutGunInHand("none");
	guy.hasWeapon = 0;
	
	guy attach ("xmodel/prop_wine_crate", "TAG_WEAPON_RIGHT");
	
	guy.walkdist			= 50000;
	guy allowedStances("stand");
	guy.goalradius = 16;
	guy setgoalpos(self.origin);
	
	trigger = getent("end_mission_pricemac","targetname");
	trigger waittill("trigger");
	
	guy thread end_walknodepath("endmission_macnode");
	
	level waittill("mac_end_respond");
	wait 7;
	guy dialogue_thread("eldaba_mac_drinktothat");
	level notify("all_end_dialogue_done");
}

end_walknodepath(name)
{
	node = getnode(name, "targetname");
	
	while(isdefined(node))
	{
		self setgoalnode(node);
		self.goalradius = 16;
		if(isdefined(node.target))
			node = getnode(node.target, "targetname");	
		else 
			node = undefined;
		self waittill("goal");
	}
}

end_flybywait()
{
	level endon("end_flyby");
	self waittill("trigger");
	level notify("end_flyby");
}

end_flyby()
{
	level waittill("end_mission");
	trigger = getentarray("topgun_flyby", "targetname");
	array_thread(trigger, ::end_flybywait);
	
	level waittill("end_flyby");
	
	plane1 = sky_makeplane("endflyby1", "xmodel/vehicle_spitfire_flying");
	plane1 thread playSoundOnTag(level.scr_sound ["spitfire_2"], "tag_prop");
	plane2 = sky_makeplane("endflyby2", "xmodel/vehicle_spitfire_flying");
	plane2 thread playSoundOnTag(level.scr_sound ["spitfire_3"], "tag_prop");
	
	wait 5;
	plane3 = sky_makeplane("endflyby1", "xmodel/vehicle_spitfire_flying");
	plane3 thread playSoundOnTag(level.scr_sound ["spitfire_1"], "tag_prop");
	plane4 = sky_makeplane("endflyby2", "xmodel/vehicle_spitfire_flying");
	plane4 thread playSoundOnTag(level.scr_sound ["spitfire_2"], "tag_prop");
	
	plane1 waittill("reached_end_node");
	plane1 delete();
	plane2 delete();
	
	plane3 waittill("reached_end_node");
	plane3 delete();
	plane4 delete();
}

end_friendly_useturret()
{
	self endon("death");
	level endon("get_off_that_mg42");
	node = getnode("mgwell_retreat_start2", "targetname");
	self setgoalnode(node);
	self.goalradius = 16;
	self.script_noteworthy = "off_friendly_chain";
	self waittill("goal");
	self.goalradius = 512;
	turret = getent(node.target, "targetname");
	dist = 90 * 90;
	while(distancesquared(level.player.origin, self.origin) > dist)
	{
		self useturret(turret);
		turret setmode("auto_ai");
		wait 1;
	}
}

end_last_alley_dudes()
{				
	trig = getent("last_alley_dudes", "target");
	trig thread triggerOff();
	level waittill("move on past mg42 nest");
	
	ai = getaiarray("axis");
	dist = 200 * 200;
	for(i=0;i<ai.size;i++)
	{
		if((isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == "no_delete") || (distancesquared(level.player.origin, ai[i].origin) < dist) )
			continue;
		ai[i] delete();
	}
	trig thread triggerOn();
	trig waittill("trigger");
	level notify("last_alley_dudes");
}

mg_wakeup()
{
	spwners = getentarray("mg42nest_guys","script_noteworthy");
	array_thread(spwners, ::mg_wakeup_think);
	
	trig = getent("mg_roofdudes","target");
	trig waittill ("trigger");
	level.flag["mg42guys_wakeup_ready"] = true;
	
	trig = [];
	trig[trig.size] = getent("mg_guys_wakup_look", "targetname");
	trig[trig.size] = getent("mg_guys_wakup_now", "targetname");
	
	array_thread(trig, ::mg_wakeup_trigs);
	
	level waittill("mg42guys_wakeup_retreat");
	clip = getent("mgnest_nosightclip","targetname");
	
	temp = getaiarray("axis");
	ai = [];
	for(i=0; i<temp.size;i++)
	{
		if(isdefined(temp[i].script_noteworthy) && temp[i].script_noteworthy == "mg42nest_guys")
			ai[ai.size] = temp[i];
	}
	
	playsoundinspace("eldaba_germanrun", ai[0].origin);

	clip notsolid();
	clip connectpaths();
	clip delete();
	
}
mg_wakeup_trigs()
{
	level endon("mg42guys_wakeup_retreat");	
	self waittill("trigger");
	level notify("mg42guys_wakeup_retreat");
}

mg_wakeup_think()
{
	self endon("death");
	while(1)
	{
		self waittill("spawned", guy);	
		if(spawn_failed(guy))
			continue;
		
		guy thread mg_wakeup_think2();
	}	
}

mg_wakeup_think2()
{
	level endon("mg42guys_wakeup_retreat");
	self waittill("damage");
	if(level.flag["mg42guys_wakeup_ready"])
		level notify("mg42guys_wakeup_retreat");
}

mg_main()
{
	clip = getent("end_mg1nodeblock","targetname");
	clip = getent(clip.target, "targetname");
	clip disconnectpaths();
	
	mg_mgs = [];
	level.mg_breakable_users = 0;
	
	wait .05;
	mg_mgs[mg_mgs.size] = getent("auto7006","targetname");
	mg_mgs[mg_mgs.size] = getent("auto7007","targetname");
	array_thread (mg_mgs, ::mg_ownerchange);
	
	mgnesttrig = undefined;
	
	if(!level.jumptomg)
	{
		mgnesttrig = getent("mg42nest_spawners","target");
		mgnesttrig triggerOff();
	}
	if(!level.jumptoend)
	{
		thread open_door_msg("ed_scripted_allydoor2", "move_on_past_com");

		spwners = getentarray("mg_run_guys","targetname");
		array_thread(spwners, ::mg_runners);
		spwners = getentarray("doorbreach_guys","targetname");
		array_thread(spwners, ::mg_doorbreach);
		spwners = getentarray("mgnest_dummies","targetname");
		array_thread(spwners, ::mg_dummies);
		spwners = getentarray("mgnest_dummies2","targetname");
		array_thread(spwners, ::mg_dummies);
		mg = getent("db_turret","targetname");
		mg thread mg_doorbreach_turret(); 
		
		level waittill("move_on_past_com");
		ai = getaiarray("allies");
		for(i=0;i<ai.size;i++)
		{
			ai[i].baseAccuracy = 0;
			ai[i].accuracy = 0;	
		}
		if(!level.jumptomg)
			mgnesttrig notify("trigger");
		trig = getent("mgnest_dummies","target");
		trig notify("trigger");
		level waittill("move on past mg42 nest");
	}

	clip = getent("end_mg1nodeblock","targetname");
	clip waittill("trigger");
	clip = getent(clip.target, "targetname");
	clip notsolid();
	clip connectpaths();
	clip delete();
}

mg_ownerchange()
{
	level waittill("overlooking_mgnest");
	overtaken = false;
	guy = undefined;
	while(1)
	{
		self waittill("turretownerchange");
		if(isdefined (guy) )
		{
			level.breakingEnts = array_remove(level.breakingEnts, guy);
			guy notify("stop_ownerchange2");
		}
		guy = self getturretowner();
		
		if(isdefined(guy) && (guy == level.player || guy.team == "allies") )
		{
			self.suppresionFire = false;
			level.breakingEnts[level.breakingEnts.size] = guy;
			level.flags["Breakable Boxes"] = true;
			level.mg_breakable_users++;
			overtaken = true;
		}
		else if(overtaken)
			level.mg_breakable_users--;
			/*
		if(isdefined(guy) && guy.team == "axis" )
			guy.ignoreme = true;
			*/
		if(!level.mg_breakable_users)
			level.flags["Breakable Boxes"] = false;
	}	
}

mg_dummies()
{
	self endon("death");
	self.script_startinghealth = 300;
	while(1)
	{
		self waittill("spawned", guy);	
		if(spawn_failed(guy))
		{
			wait .5;
			continue;
		}
		guy thread mg_dummies2();
		
	}
}
mg_dummies2()
{
	self endon("death");
	self.baseAccuracy = 0;
	self.accuracy = 0;
	self.suppressionwait = 7;
	level waittill("move on past mg42 nest");
	self delete();
}

mg_doorbreach_turret()
{
	level waittill("doorbreachmgguy");
	guy = level.doorbreachmgguy;
	
	guy useturret(self);
	self setmode("manual_ai");
	targetent = getent("db_supressor","targetname");
	self settargetentity(targetent);	
	
	level waittill("started_doorshread");
	self shootturret();
	self startfiring();
	thread mg_doorbreach_hurttrig();
	level waittill("mg_door_breached");
	wait 3;
	level notify("doorbreachmgguy_stopshoot");
	//self cleartargetentity();
	self stopfiring();
	self setmode("auto_ai");
}

mg_doorbreach_hurttrig()
{
	level endon("doorbreachmgguy_stopshoot");
	
	trig = getent("doorbreach_firepath","targetname");
	while(1)
	{
		trig waittill("trigger", other);
		
		if(other == level.player)
		{
			other dodamage ( 75, (0,0,0) );
			wait .25 + randomfloat(.15);	
		}
	}	
}

mg_doorbreach()
{
	self endon("death");
	mg = false;
	if(isdefined(self.target) && self.target == "db_turretnode")
		mg = true;
	
	self waittill("spawned", guy);	

	if(spawn_failed(guy))
		return;
	
	guy endon("death");
	guy.ignoreme = true;
	guy set_forcegoal();
	
	if(mg)
	{
		level.doorbreachmgguy = guy;
		level notify("doorbreachmgguy");
		guy unset_forcegoal();
		return;
	}
	guy.team = "axis";
	
	level waittill("mg_door_breached");
	wait 1.5;
//	level waittill("doorbreachmgguy_stopshoot");
	guy unset_forcegoal();	
	guy.ignoreme = false;
	guy setgoalnode( getnode("doorbreach_node", "targetname") );
}

mg_runners()
{
	self endon("death");
	self waittill("spawned", guy);	
	
	if(spawn_failed(guy))
		return;
	guy endon("death");
	guy.interval = 0;
	guy set_forcegoal();
	
	guy waittill("goal");
	guy waittill("goal");

	guy unset_forcegoal();	
}

docks_main()
{
	if(!level.jumptocom)
	{
		thread docks_smokethrow();
		thread docks_1flakdown();	
	}
	thread docks_setup();
	thread docks_comflankers();
	thread docks_comm_obj_trig();
	spwners = getentarray("com_flank_guys","targetname");
	array_thread(spwners, ::docks_comflanker_think);
	
	//kill roof mg42 when player enters house
	trig = getent("docks_killmg","targetname");
	trig waittill("trigger");
	mg = getentarray("mg42_artillery_roof","script_noteworthy");
	for(i=0;i<mg.size;i++)
		mg[i] delete();
	
	trig = getent("orange_smoke","targetname");
	trig waittill("trigger");
	level notify("com_obj_available");
	maps\_utility::exploder(4);
	
	battleChatterOff();
	playsoundinspace("eldaba_bs1_smokeinplace", (2491, 1532, 19));
}

docks_setup()
{
	grnd = getent("dock_mortar_hole1","targetname");
	mrtr = getent(grnd.target,"targetname");
	mrtr notsolid();
	mrtr hide();
	
	grnd = getent("dock_mortar_hole2","targetname");
	mrtr = getent(grnd.target,"targetname");
	mrtr notsolid();
	mrtr hide();
	
	clip = getent("fardock_lostclip","targetname");
	clip notsolid();
	
	boat = getent("supplyboat1","script_noteworthy");
	boat thread docks_boatbob();
	boat = getent("supplyboat2","script_noteworthy");
	boat thread docks_boatbob();
}

#using_animtree("eldaba_cargoship");
docks_boatbob()
{
	self hide();
	level waittill("in_hallway_to_docks");
	self show();
	self.animname = "boat";
	self UseAnimTree(#animtree);
	
	self thread maps\_anim::anim_loop_solo ( self, "idle1", undefined, "stop_bob");
}

docks_comm_obj_trig()
{
	trig = getent("comm_obj_trig","targetname");
	trig setHintString (level.strings["com"]);
	if(!level.jumptocom)
	{
		trig triggerOff();
		level waittill("com_obj_available");
		trig triggerOn();
	}
	trig waittill("trigger");
	
	thread docks_cleanup();
	
	glows = getentarray(trig.target, "targetname");
	for(i=0;i<glows.size;i++)
		glows[i] delete();
	
	pos = spawn("script_origin", (trig getorigin()) );
	
	trig delete();
	trig = getent("leaving_com","targetname");
	trig thread docks_com_objleave();
	pos playsound(level.scrsound["eldaba_hqr_broadsword"]);

	wait 5;
	docks_artillary_barage();
	wait 10;
	
	wait 2;
	level notify("docks_objective_completed");
	
	
}

docks_cleanup()
{
	ai = getaiarray("axis");
	dist = 256 * 256;
	for(i=0;i<ai.size;i++)
	{
		if((isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == "no_delete") || (distancesquared(level.player.origin, ai[i].origin) < dist))
		{
			ai[i] thread docks_cleanup2();
			continue;
		}	
		ai[i] delete();
	}	
}

docks_cleanup2()
{
	self.health = 5;
	self endon("death");	
	
	wait (.75 + randomfloat(1));
	x = randomint(100);
	if(x > 50)
		wait(randomfloat(.5));
	
	ai = getaiarray("allies");
	guy = random(ai);
	
	magicbullet("kar98k", guy.origin, self.origin);
	thread playsoundinspace("weap_enfield_fire", guy.origin);			
	self DoDamage ( self.health + 50, guy.origin );
	
}

docks_com_objleave()
{
	self waittill("trigger");
	level.flag["speedy_com_obj"] = true;
	level notify("docks_objective_completed");
	level notify("speedy_com_obj");
}

docks_artillary_barage()
{
	
    maps\_utility::exploder(6); //artillery fire
    
    wait 2;
    thread docks_EXP_dock();
    maps\_utility::exploder(5); //artillery impacts
    wait 3;
    boat = getent("supplyboat2","script_noteworthy");
    thread playsoundinspace("ship_sinking1", boat.origin);//eldaba_letsgo//water_splash_shipbow
    thread docks_EXP_boatsink("supplyboat2");
    wait 1;
    thread docks_EXP_mortar_hole("dock_mortar_hole2", "dock_mortar_hole2_remove", "flak_gun2");
    wait 3;
    thread docks_EXP_mortar_hole("dock_mortar_hole1", "dock_mortar_hole1_remove", "flak_gun4");
    wait 1;
    boat = getent("supplyboat1","script_noteworthy");
    thread playsoundinspace("ship_sinking2", boat.origin);//eldaba_letsgo//water_splash_shipbow
    thread docks_EXP_boatsink("supplyboat1");

}

docks_EXP_boatsink_bubble(name)
{
	self endon("stop_sink_effect");
	if(name == "supplyboat1")
	{
		while(1)
		{
			playfxOnTag (level._effect["water_bubble"], self, "tag_wake");
			wait 0.3;
		}
	}
	else
	{
		while(1)
		{
			playfxOnTag (level._effect["water_bubble"], self, "tag_wake");
			wait 0.3;
		}
	}
}

#using_animtree("eldaba_cargoship");
docks_EXP_boatsink(name)
{
	link = [];
	//time = 7;
	boats = getent(name, "script_noteworthy");

	time = 23.5;
	boattime = 8;
	
	boats notify("stop_bob");
	
	if(name == "supplyboat1")
	{
		boats.animname = "boat";
		boats UseAnimTree(#animtree);
		maps\_utility::exploder(10);
		boats setmodel("xmodel/vehicle_cargoship_crates_d");
		boats thread boat_fx_fire();
		boats thread docks_EXP_boatsink_bubble(name);
		boats thread maps\_anim::anim_single_solo (boats, "sink1");
		boats waittillmatch ("single anim", "end");
		boats thread maps\_anim::anim_loop_solo (boats, "idle2");
		
	}
	else
	{
		boats.animname = "boat";
		boats UseAnimTree(#animtree);
		maps\_utility::exploder(11);
		boats thread maps\_anim::anim_single_solo (boats, "sink2");
		boats thread docks_EXP_boatsink_bubble(name);
		boats thread boat_fx_fire();
		boats setmodel("xmodel/vehicle_cargoship_crates_d");
		wait 3;
		boats setmodel("xmodel/vehicle_cargoship_d");
		maps\_utility::exploder(2);			
		boats notify ("stop_boat_fx_fire");
		wait boattime;
		boats notify ("stop_boat_fx_fire");
		wait time - boattime;
		boats notify("stop_sink_effect");
		wait 4;
		for(i=0;i<boats.size;i++)
		{
			boats unlink();
			boats delete();
		}
	}
	
}


boat_fx_fire()
{
	self endon ("stop_boat_fx_fire");
	for (;;)
	{
		playfxOnTag (level._effect["cargoship_fire"], self, "tag_fire");
		wait 2.0;
	}
}


docks_EXP_mortar_hole(hole, remove, flak)
{
	grnd = getent(hole, "targetname");
	mrtr = getent(grnd.target, "targetname");
	gun = getent(flak, "targetname");
	gun delete();
	radiusDamage(grnd getorigin(), 350, 100000,110000);
	grnd delete();
	mrtr show();
	mrtr solid();
	
	deleteme = getentarray(remove, "targetname");
	for(i=0;i<deleteme.size;i++)
		deleteme[i] delete();
		
	if(hole == "dock_mortar_hole2")
		maps\_fx::loopfx("thin_light_smoke_L", (197,1863,-38), 0.6, (195,1866,61));
	else
		maps\_fx::loopfx("thin_light_smoke_L", (1486,1668,-28), 0.6, (1485,1671,71));
	
}

docks_EXP_dock()
{
	org = getent("dock_mortar_dock_exppoint","targetname");
	org delete();
	shadow = getent("dock_mortar_dock_shadow1","targetname");
	shadow delete();
	shadow = getent("dock_mortar_dock_shadow2","targetname");
	shadow show();
	clip = getent("fardock_lostclip","targetname");
	clip solid();
}

docks_comflanker_think()
{
	self endon("death");
	self waittill("spawned", guy);	
	
	if(spawn_failed(guy))
		return;
	guy endon("death");
	
	//guy.ignoreme = true;
	guy.old_suppressionwait = guy.suppressionwait;
	guy.suppressionwait = 0;
		
	//guy.pathenemylookahead = 128;
	//guy.pathenemyfightdist = 128; 
//	guy set_forcegoal();
	
	guy waittill("goal");

	//guy.ignoreme = false;
	guy.suppressionwait = guy.old_suppressionwait;
//	guy unset_forcegoal();
}

docks_comflankers()
{
	trig = getent("com_flank_guys","target");
	trig thread triggerOff();
	
	nowok = getent("bydockwall","targetname");
	nowok waittill("trigger");
	trig thread triggerOn();
	
	look = getent("com_flank_trig_look", "targetname");
	look waittill("trigger");
	trig notify("trigger");
}

docks_1flakdown()
{
	trig = getent("docks_1flakdown","targetname");
	level waittill("one flak crew killed");
	trig notify("trigger");
}

docks_smokethrow()
{
	trigger = getent("docks_mg42_opener", "script_noteworthy");
	trigger triggerOff();
	level waittill ("start_dock_scene");
	trigger triggerOn();
	trigger waittill("trigger");
	level notify("docks mg42 lit up");
	level endon("docks_objective_completed");
	mg = getent("dockroof_mg","targetname");
	mg waittill("turretownerchange");

	nade = getent("throw_smoke_here","targetname");
		
	tooclose = 200 * 200;
	toofar = 1024 * 1024;
	
	ai = getaiarray("allies");
	while(!ai.size)
	{
		wait .5;	
		ai = getaiarray("allies");
	}
	callguy = ai[0];
	dist = distancesquared(callguy.origin, nade.origin);
	for(i=0;i<ai.size;i++)
	{
		dist2 = distancesquared(ai[i].origin, nade.origin);
		if(dist2 > dist && dist2 < toofar)
		{
			dist2 = dist;
			callguy = ai[i];	
		}
	}
	
		callguy thread maps\_utility::magic_bullet_shield();
		callguy.ignoreme = true;
	
		battleChatterOff();
		callguy.animname = "bs1";
		//callguy dialogue_thread("smoke"); 
		playsoundinspace("eldaba_bs1_useasmokegrenade", callguy.origin);
		
		callguy.ignoreme = false;
		callguy notify ("stop magic bullet shield");
		
		wait .5;
		
	//throw a smoke grenade
	ai = getaiarray("allies");
	while(!ai.size)
	{
		wait .5;	
		ai = getaiarray("allies");
	}
	
	throwguy = ai[0];
	dist = distancesquared(throwguy.origin, nade.origin);
	for(i=0;i<ai.size;i++)
	{
		dist2 = distancesquared(ai[i].origin, nade.origin);
		if(dist2 < dist && dist2 > tooclose)
		{
			dist2 = dist;
			throwguy = ai[i];	
		}
	}

		throwguy thread maps\_utility::magic_bullet_shield();
		throwguy.ignoreme = true;	
		
		throwguy.animname = "bs1";
		//throwguy dialogue_thread("yessir");
		playsoundinspace("eldaba_bs1_acknowledge_yes", throwguy.origin);
		thread battleChatterOn();
			
		if (!isdefined(throwguy.oldGrenadeWeapon))
			throwguy.oldGrenadeWeapon = throwguy.grenadeWeapon;
		
		throwguy.grenadeWeapon = "smoke_grenade_american";
		throwguy.grenadeAmmo++;
		
		throwguy MagicGrenade (nade.origin + (0,0,5), nade.origin, 1.5);
		
		throwguy.grenadeWeapon = throwguy.oldGrenadeWeapon;
		throwguy notify ("stop magic bullet shield");
		throwguy.ignoreme = false;
		
	wait 6;
	
	ai = getaiarray("allies");
	while(!ai.size)
	{
		wait .5;	
		ai = getaiarray("allies");
	}
	dist = distancesquared(ai[0].origin, nade.origin);
	throwguy = ai[0];
	for(i=0;i<ai.size;i++)
	{
		dist2 = distancesquared(ai[i].origin, nade.origin);
		if(dist2 < dist && dist2 > tooclose)
		{
			dist2 = dist;
			throwguy = ai[i];	
		}
	}
	level notify ("smoke_was_thrown"+nade.origin);
	throwguy thread maps\_utility::magic_bullet_shield();
	throwguy.ignoreme = true;
	battleChatterOff();
		throwguy playsound("eldaba_smoke");
	battleChatterOn();
	throwguy notify ("stop magic bullet shield");
	throwguy.ignoreme = false;
}

docks_obj_explode(msg, time, flak)
{
	level waittill(msg);
	wait time;
	
	earthquake(0.75, 1.0, self.origin, 6000); // scale duration source radius	
	
	dist = 350*350;
	
	if(distanceSquared(level.player.origin, self.origin) < dist)
		thread maps\_shellshock::main(1);
	
	TankFireSound = spawn("script_origin",self.origin);
	TankFireSound playloopsound ("medfire");	
	radiusDamage(self.origin, 2, 10000000,10000000);
	//if(!isdefined(flak))
	//	self dodamage ( self.health + 200, (0,0,0) );
	self notify ("death");
}

dialogue_main()
{
	level waittill("intro_objects_available");
	vehicle = getent("player_truck1", "script_noteworthy");
	thread dialogue_mac_fankright();
	dialogue_truck4(vehicle);
	
}

dialogue_special_tank(dialogue)
{
	self setBattleChatter(false);
	
	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
		self waittill ("my done speaking");

	self.MyIsSpeaking = true;
	
	tag_origin = self.RidingTank getTagOrigin (self.tankride_tag);
	tag_angles = self.RidingTank getTagAngles (self.tankride_tag);
	
	self.playingCustomAnim = true;
	
	self animscripted("tank dialogue anim", tag_origin, tag_angles, level.scr_anim[self.animname][dialogue]);
	
	//"You hear that Norman has been sent home?"
//	self waittillmatch ("tank dialogue anim", "dialogue_01");
//	self thread animscripts\face::SaySpecificdialogue(undefined, level.scrsound["macgregor"]["toujane_macgregor_normansenthome"], 1.0);
	
	//"That “lucky bastard” lost his leg."
//	self waittillmatch ("tank dialogue anim", "dialogue_02");
//	self thread animscripts\face::SaySpecificdialogue(undefined, level.scrsound["macgregor"]["toujane_macgregor_losthisleg"], 1.0);
	self thread animscripts\face::SaySpecificdialogue(undefined, level.scrsound[self.animname][dialogue], 1.0);
		
	self waittillmatch ("tank dialogue anim", "end");
	self.playingCustomAnim = undefined;
	self thread maps\_tankai::loop_riding_anim(self.RidingTank);
	
	self.MyIsSpeaking = false;
	self notify ("my done speaking");
}

dialogue_comcomplete()
{
	playsoundinspace("eldaba_letsgo", (2491, 1532, 19));
	battleChatterOn( "allies" );
}

dialogue_thread(dialogue, node, team)
{
	self endon("death");
//	team1 = "allies";
//	if(isdefined(team))
//		team1 = team;
	self.oldbattlechatter = self.battlechatter;
	self setBattleChatter(false);
	if (!isdefined(self.magic_bullet_shield))
	{
		self.health_before_dialogue = self.health;
		self.health = 1000000;
		if(!isdefined(self.animname))
			self.animname = "soldier";
	}
		
	facial = undefined;	
	
	if(isdefined(node))
		level maps\_anim::anim_single_solo(self, dialogue, undefined, node);
	else
		level maps\_anim::anim_single_solo(self, dialogue);
	
	self setBattleChatter(self.oldbattlechatter);

	if (isdefined (self.health_before_dialogue))
	{
		self.health = self.health_before_dialogue;
		self.health_before_dialogue = undefined;
		//self.animname = undefined;
	}
}

dialogue_mac_fankright()
{
	level.macgregor waittill("speak_flank_right");
	
	mg = [];
	mg[mg.size] = getent("mg_blockage_gun2","targetname");
	mg[mg.size] = getent("mg_blockage_gun","targetname");
	
	while(!level.flag["player_flanked_right"])
	{
		battleChatterOff( "allies" );

		level.macgregor dialogue_thread("eldaba_mac_flankright", level.macgregor.flankspeachnode);
		level notify("mac_said_flank_right");
		thread battleChatterOn( "allies" );

		level.macgregor thread maps\_anim::anim_loop_solo ( level.macgregor, "hideLowWall", undefined, "talkaboutflank", level.macgregor.flankspeachnode);
		wait 10;
		level.macgregor notify("talkaboutflank");
	}
}

dialogue_truck4(vehicle)
{
	battleChatterOff( "allies" );
	level waittill("tank bomb dropped");
	//Get down, lads!
	level.cynical		dialogue_thread("eldaba_ccy_getdownlads");
	thread battleChatterOn( "allies" );
}

intro_notifydeleteallies()
{
	trig = getent("auto8101", "target");
	trig waittill("trigger");
	level notify("in_hallway_to_docks");
	auto_save();
}

intro_flanking_mortarhit()
{
	trig = getent("intro_flanking_mortar_trig","targetname");
	trig waittill ("trigger");
	
	impactPoint = getent(trig.target, "targetname");
	impactPoint thread maps\_mortar::explosion_activate ("bomb_impact", 1, 1, 2, 0.5, 2, 2000); // temp values
}

intro_main2()
{
	flag_set("first_area_complete");
	thread intro_missiondonedialogue();
	level waittill("intro allies can move on now");
	nodes = getnodearray("new_intro_endspots","script_noteworthy");
	ai = getaiarray("allies");
	
	ai = array_remove(ai, level.macgregor);
	macnode = undefined;
	if(isdefined(level.macgregor))
	{
		macnode = getClosestNode(level.macgregor.origin, nodes);
		nodes = array_remove(nodes, macnode);
	}
	for(i=0; i<ai.size;i++)
	{
		if(isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == "reinforcements")
		{
			if(!isdefined(macnode))
			{
				macnode = getClosestNode(ai[i].origin, nodes);
				nodes = array_remove(nodes, macnode);
			}	
			ai[i] setgoalnode(macnode);
			ai[i].oldradius = ai[i].goalradius;
			ai[i].goalradius = 16;
			ai[i] set_forcegoal();
			if(isdefined(level.macgregor))
			{
				level.macgregor setgoalpos(macnode.origin + (64,-64,0));
				level.macgregor set_forcegoal();
			}
			ai[i] thread first_friendly_dude_think(macnode);
			
			continue;
		}
		node = random(nodes);
		nodes = array_remove(nodes, node);
		ai[i] setgoalnode(node);
		ai[i] set_forcegoal();
	}
}

first_friendly_dude_think2()
{
	self endon("death");
	self endon("first_friendly_dude_think");
	self waittill("macgregor_intro_death");
	
	self unset_forcegoal();
	self setgoalentity(level.player);
	self.goalradius = self.oldradius;
}

first_friendly_dude_think(macnode)
{
	self endon ("death");
	self thread first_friendly_dude_think2();
	level.macgregor endon("death");
	
	dist = 256 * 256;
	if(!isdefined(level.macgregor))
	{
		self notify ("macgregor_intro_death");
		return;
	}
	while(distancesquared(level.macgregor.origin, macnode.origin) > dist)
	{
		wait .05;
		if(!isdefined(level.macgregor))
		{
			self notify ("macgregor_intro_death");
			return;
		}
	}
	self unset_forcegoal();	
	self setgoalentity(level.player);
	self.goalradius = self.oldradius;
	
	self notify("first_friendly_dude_think");	
	level.macgregor setgoalnode(macnode);	
}

intro_main()
{
	thread intro_actors_setup();
	wait 0.9;

	thread intro_vehicle_setup();
	thread shadow_hints();
	thread intro_dead_tank_setup();
	thread intro_block_tank_setup();
	thread intro_misc_setup();
//	thread intro_ScreenShake();	
	thread intro_flanking_mortarhit();
	thread intro_notifydeleteallies();
	
	spwners = getentarray("intro_mgcorner_guys", "targetname");
	array_thread(spwners, ::intro_mgcorner);
	
	level waittill("mosque blown");
	wait 6;
	thread sky_intro_attacking();
	
	trigger = getent("fc50", "target");
	trigger waittill("trigger");
	
	ai = getaiarray("axis");
	pos = getent("player_truck1", "script_noteworthy");
	
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == "intro_2ndfloor")
		{
			magicbullet("kar98k", pos.origin, ai[i].origin);
			pos playsound("weap_thompson_fire");			
			ai[i] DoDamage ( ai[i].health + 50, pos.origin );
		}
	}	
	
	thread intro_main2();	
	
	level waittill("start_dock_scene");
	wait .1;
	ai = getaiarray("allies");
	for(i=0; i<ai.size;i++)
	{
		if(isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == "reinforcements")
			continue;
		ai[i] delete();
	}
}
intro_missiondonedialogue_check()
{
	self waittill("death");
	level notify("one intro enemy down");	
}
intro_missiondonedialogue()
{
	ai = getaiarray("axis");
	if(ai.size)
	{
		number = ai.size;
		array_thread(ai, ::intro_missiondonedialogue_check);
		while(1)
		{
			level waittill("one intro enemy down");	
			number--;
			if(!number)
				break;
		}
	}
	wait .5;
	battleChatterOff( "allies" );
	playsoundinspace("eldaba_bs3_clearhere", (-679, -641, 50));
	level notify("intro allies can move on now");
	wait .25;
	if(isdefined(level.macgregor))
		level.macgregor playsound("eldaba_mac_goodworkdavis");
	level notify("eldaba_mac_goodworkdavis");
	thread battleChatterOn( "allies" );
}

intro_mg_owner()
{
	level endon("in_hallway_to_docks");
	
	while(1)
	{
		self waittill("turretownerchange");
		guy = self getturretowner();	
		if(isdefined(guy))
			guy.ignoreme = true;
	}
}

intro_mgcorner()
{
	self endon("death");
	while(self.count)
	{
		self waittill("spawned", guy);
		//get the guy
		if(spawn_failed(guy))
			return;
		
		guy endon("death");
		
		guy thread set_forcegoal();
		guy waittill("goal");
		guy thread unset_forcegoal();	
	}
}

intro_block_tank_setup()
{
	tank = undefined;
	tank = getent("block_tank", "targetname");	
	while(!isdefined(tank))
	{
		wait .05;
		tank = getent("block_tank", "targetname");		
	}
	tank.allowUnloadIfAttacked = false;
	tank thread maps\_tankgun::mgoff();
	
	level waittill ("entrance_bomb_released");
	
	wait .4;
	
	earthquake(1.0, 1.0, tank.origin, 6000); // scale duration source radius	
	
	tank dodamage ( tank.health + 200, (0,0,0) );
	tank notify ("death");
	TankFireSound = spawn("script_origin",tank.origin);
	TankFireSound playloopsound ("medfire");
}

intro_dead_tank_setup()
{	
	tank = undefined;
	tank = getent("lead_tank", "targetname");	
	while(!isdefined(tank))
	{
		wait .05;
		tank = getent("lead_tank", "targetname");		
	}
	tank.allowUnloadIfAttacked = false;
	tank thread maps\_tankgun::mgoff();
	tank waittill ("reached_end_node");
	level notify("lead tank dead");
	earthquake(1.0, 1.0, tank.origin, 6000); // scale duration source radius	
	
	tank dodamage ( tank.health + 200, (0,0,0) );
	tank notify ("death");
	TankFireSound = spawn("script_origin",tank.origin);
	TankFireSound playloopsound ("medfire");
	wait 10;
	TankFireSound delete();
}

intro_ScreenShake()
{
	level endon ("dismounted truck");
	for (;;)
	{
		earthquake(0.15, .1, (-896, 440, 56), 20000); // scale duration source radius
		wait .05;
	}
}

intro_dummies2()
{
	self set_forcegoal();
	self.baseAccuracy = 0;
	self.accuracy = 0;
	self.suppressionwait = 7;
}

intro_dummies()
{
	self endon("death");
	self endon("in_hallway_to_docks");
	self.script_startinghealth = 900;
	self waittill("spawned", guy);	
	while(spawn_failed(guy))
	{
		wait 1;
		self.count = 1;
		guy = self dospawn();
	}
	while(1)
	{
		guy.dropweapon = false;
		guy thread intro_dummies2();
		guy waittill("death");	
		
		wait 2;
		
		self.count = 1;
		guy = self dospawn();
		
		while(spawn_failed(guy))
		{
			wait 1;
			self.count = 1;
			guy = self dospawn();
		}
	}
}

intro_misc_setup()
{	
	thread intro_artillery_hits();
	spwners = getentarray("intro_dummies","targetname");
	array_thread (spwners, ::intro_dummies);
		
	trigger = getent("outside_triggers", "targetname");
	trigger triggerOff();
	
	spawners = getentarray("outsiders", "targetname");
	for(i=0;i<spawners.size; i++)
	{
		guy = spawners[i] dospawn();
		if(spawn_failed(guy))
			continue;
		guy thread outsiderthink(getnode(spawners[i].target, "targetname"));
	}
	spawners = getentarray("plane_runners", "script_noteworthy");
	//spawners = getentarray("plane_runners", "targetname");
	array_thread(spawners, ::planerunnerthink);
	
	ai = getaiarray("allies");
	for(i = 0; i< ai.size; i++)
		ai[i] setBattleChatter(false);
	
	wait 25;
	level notify ("go outsiders");
	wait 10;
	//this moves the tank
	level notify ("go plane runners");
	wait 5;
	ai = getaiarray("allies");
	for(i = 0; i< ai.size; i++)
		ai[i] setBattleChatter(true);
	
	level waittill ("dismounted truck");
	//badplace_cylinder("truckback_badplace", 25, (-1211, -1009, 45), 90, 128, "allies","neutral");
	
	level notify ("delete outside stuff");
	stuff = getentarray("outsideoftown", "targetname");
	for(i=0;i<stuff.size;i++)
		stuff[i] delete();
		
	auto_save();
	
	trig = getent("player_flanked_right","targetname");
	trig waittill("trigger");
	
	level.flag["player_flanked_right"] = true;
	level notify("player_flanked_right");
	level.macgregor notify("talkaboutflank");
}

kill_all_axis()
{
	self waittill("trigger");
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
		ai[i] delete();	
}

planerunnerthink()
{
	self endon("death");
	guy = self dospawn();//waittill("spawned", guy);
	if(spawn_failed(guy))
		return;
	level waittill ("go plane runners");
	guy setgoalnode(getnode("planerunners_node","targetname"));
	
	level waittill("delete outside stuff");
	self delete();
}

outsiderthink(node)
{
	self endon("death");
	self set_forcegoal();
	pnode = node;
	
	level waittill ("go outsiders");
	while(isdefined(pnode.target))
	{
		self waittill ("goal");
		pnode = getnode(pnode.target, "targetname");
		self setgoalnode(pnode);	
		self.goalradius = 8;
	}
	
	level waittill("delete outside stuff");
	self delete();
}

intro_vehicle_setup()
{		
	//take care of the player placement on the truck
	vehicle = undefined;
	while(!isdefined(vehicle))
	{
		vehicle = getent("player_truck1", "script_noteworthy");
		wait .1;
	}
	level notify("intro_truck_available");
	
	vehicle.health = 100000;
	//put the player on the tank
	level.player setorigin (vehicle getTagOrigin ("tag_guy05"));//tag_guy05
	level.player playerLinkToDelta (vehicle, "tag_guy05", 0.85);
	//Player can only crouch on the tank
	level.player allowLeanLeft(false);
	level.player allowLeanRight(false);
	level.player allowProne(false);
	
	wait 1;
	level.player setplayerangles (vehicle gettagAngles ("tag_guy05"));	//tag_guy05
	
	vehicle waittill ("reached_end_node");
	level notify ("dismounted truck");
	level.player setplayerangles((level.player.angles[0],level.player.angles[1],level.player.angles[2]));
	level.player unlink();
	//give some controls back to the player
	level.player allowLeanLeft(true);
	level.player allowLeanRight(true);
	level.player allowProne(true);
}

intro_actors_setup()
{
	macspwn = getent("macgregor","script_noteworthy");
	level.macgregor = undefined;
	level.cynical	= undefined;
	level.soldier1 	= undefined;
	level.soldier2 	= undefined;
	level.soldier3 	= undefined;
	
	level waittill("intro_truck_available");
	
	allies = getaiarray("allies");
	for (alliesIndex=0;alliesIndex<allies.size;alliesIndex++)
	{
		if(!isdefined(allies[alliesIndex].script_noteworthy))
			continue;
	//	allies[alliesIndex] thread animscripts\shared::SetInCombat(false);
		if (allies[alliesIndex].script_noteworthy == "scripted_intro_allies")
		{
			allies[alliesIndex].dropweapon = false;
		}
		if (allies[alliesIndex].script_noteworthy == "macgregor")
		{
			level.macgregor = allies[alliesIndex];
			level.macgregor.animname = "mac";
			level.macgregor.flankspeachnode = getnode(macspwn.target, "targetname");
		}
		else if (allies[alliesIndex].script_noteworthy == "soldier1")
		{
			level.soldier1 = allies[alliesIndex];
			level.soldier1.animname = "bs1";
		}
		else if (allies[alliesIndex].script_noteworthy == "soldier2")
		{
			level.soldier2 = allies[alliesIndex];
			level.soldier2.animname = "bs2";
		}
		else if (allies[alliesIndex].script_noteworthy == "soldier3")
		{
			level.soldier3 = allies[alliesIndex];
			level.soldier3.animname = "bs3";
		}
		else if (allies[alliesIndex].script_noteworthy == "cynical")
		{
			level.cynical = allies[alliesIndex];
			level.cynical.animname = "ccy";
		}	
	}
	
	assertEX(isdefined(level.macgregor), "MacGregor isn't being defined");
	assertEX(isdefined(level.soldier1), "Soldier1 isn't being defined");
	assertEX(isdefined(level.soldier2), "Soldier2 isn't being defined");
	assertEX(isdefined(level.soldier3), "Soldier3 isn't being defined");
	assertEX(isdefined(level.cynical), "Cynical isn't being defined");
	
	level.macgregor thread maps\_utility::magic_bullet_shield();
	level.macgregor.script_bcdialog = false;
	level.macgregor maps\_utility::setBattleChatter(false);
	
	level.macgregor.baseAccuracy = 0;
	level.soldier1.baseAccuracy = 0;
	level.soldier2.baseAccuracy = 0;
	level.soldier3.baseAccuracy = 0;
	level.cynical.baseAccuracy = 0;
	
	level.macgregor.accuracy = 0;
	level.macgregor.grenadeammo = 0;
	level.soldier1.accuracy = 0;
	level.soldier2.accuracy = 0;
	level.soldier3.accuracy = 0;
	level.cynical.accuracy = 0;
	
	level.macgregor.tag = "tag_guy03";
	level.soldier2.tag 	= "tag_guy07";
	level.soldier3.tag 	= "tag_guy08";
	level.cynical.tag 	= "tag_guy02";
	
	level.macgregor.dropweapon = false;
	level.soldier1.dropweapon = false;
	level.soldier2.dropweapon = false;
	//level.soldier3.dropweapon = false//bren gun
	level.cynical.dropweapon = false;
	
	
	//thread maps\_anim::anim_loop_solo(vehicle, "truck_idle", "tag_origin", "dismounted truck", undefined, vehicle);
	guys = [];
	guys[guys.size] = level.macgregor;
	guys[guys.size] = level.cynical;
	guys[guys.size] = level.soldier2;
	guys[guys.size] = level.soldier3;
	
	array_thread(guys, ::intro_truck_anims);
	vehicle = getent("player_truck1", "script_noteworthy");
	
	level notify("intro_objects_available");

	allies = getaiarray("allies");
	array_thread(allies, ::intro_allies_behavior1);
}
#using_animtree("germantruck");

intro_truck_anims()
{
	self endon("death");
	vehicle = getent("player_truck1", "script_noteworthy");
	
	self thread maps\_anim::anim_loop_solo ( self, "truck_idle", self.tag, "duck", undefined, vehicle);
	level waittill("oh_look_its_got_one");
	wait 2.3;
	if(self.animname == "bs3")
		wait 1.5;
	self notify("duck");
	if(self.animname == "bs3")
		maps\_anim::anim_single_solo ( self, "truck_duck2", self.tag, undefined, vehicle);
	else
		maps\_anim::anim_single_solo ( self, "truck_duck", self.tag, undefined, vehicle);
	self waittillmatch ("single anim", "end");
		
	self thread maps\_anim::anim_loop_solo ( self, "truck_idle", self.tag, "duck", undefined, vehicle);
	level waittill("tank bomb dropped");
	self notify("duck");

	if(self.animname == "ccy")
	{
		maps\_anim::anim_single_solo ( self, "truck_trans", self.tag, undefined, vehicle);
		self waittillmatch ("single anim", "end");
	}
	else
	{
		maps\_anim::anim_single_solo ( self, "truck_duck", self.tag, undefined, vehicle);
		self waittillmatch ("single anim", "end");
	}
	if(self.animname == "bs3" || self.animname == "ccy")
		self thread maps\_anim::anim_loop_solo ( self, "truck_idle2", self.tag, "get_out", undefined, vehicle);
	else
		self thread maps\_anim::anim_loop_solo ( self, "truck_idle", self.tag, "get_out", undefined, vehicle);
	level waittill("dismounted truck");
	self notify("get_out");
}
	
intro_allies_behavior1()
{
	self endon("death");
	self thread set_forcegoal();
	self.old_suppressionwait = self.suppressionwait;
	self.suppressionwait = 0;
	self.interval = 0;
	self.goalradius = 4;
	
	if(self == level.macgregor)
	{	
		self.anim_disablePain = true; 
		self.oldgrenadeawareness = self.grenadeawareness;
		self.grenadeawareness =0;
	}
	
	self waittill("goal");
	self.suppressionwait = self.old_suppressionwait;
	
	if(self == level.macgregor)
	{
		self.anim_forced_cover = "hide";
		level.macgregor notify("speak_flank_right");
	}
}
ai_kickdoor_fx()
{
	self endon("death");
	level endon("stop_guy_fx_on_doorbreach");
	x = 1;
	n = 1;
	
	self waittill ("doorbreach", notetrack);
	if (notetrack == "kick")
		self playsound("wood_door_kick");
	
	while(1)
	{
		self waittill ("doorbreach", notetrack);
		if (notetrack != "notetrack_fx")
			continue;
		
		playfxOnTag ( level._effect["flesh_hit"] , self, "joint"+x );
		
		x++;
		if(x > 2)
			x = 1;
		n++;
		if(n == 6)
		{
			while(1)
			{
				self waittill ("doorbreach", notetrack);
				if (notetrack == "notetrack_fx")
				{
					playfxOnTag ( level._effect["flesh_hit"] , self, "joint2" );
					playfxOnTag ( level._effect["flesh_hit"] , self, "joint1" );
					break;
				}
			}
			break;
		}
		
	}
}

ai_kickdoor_kill(node)
{
	self endon("death");
	level waittill("started_doorshread");
	wait 2.175;//75;
	level notify("stop_guy_fx_on_doorbreach");
	self stopanimscripted();
	level.scr_anim["bs1"]["death_loop"][0] = level.scr_anim["bs1"]["death"];
	
	node thread anim_loop_solo(self, "death_loop");
	self dodamage(self.health - 1, (0,0,0));
	self setcontents(0);
}

#using_animtree("scripted_anim");
ai_kickdoor (guy, node, door)
{
	guy endon("death");
	guy.animname = "bs1";
	guy.ignoreme = true;
//	guy setgoalnode(node);
	guy set_forcegoal();
	//guy waittill("goal");
	node anim_reach_solo (guy, "doorbreach");
	guy.deathanim = level.scr_anim["bs1"]["death"];
	guy notify ("stop magic bullet shield");
	guy animscripted("doorbreach", node.origin, node.angles, level.scr_anim["bs1"]["doorbreach"]);//
	guy thread ai_kickdoor_fx();
	guy thread ai_kickdoor_kill(node);
	
	wait 2.2;
	level notify("started_doorshread");
	thread playsoundinspace("eldaba_doorbreak", door.origin);
	wait .2;
	brake = spawn("script_model", door.origin);
	brake.angles = door.angles;
	brake setmodel("xmodel/prop_door_wood_arched_damaged");
	brake.animname = "door";
	brake UseAnimTree(#animtree);
	
	door delete();
	maps\_utility::exploder(8);
	base = spawn("script_origin", brake.origin);
	base.angles = node.angles + (0,180,0);
	base thread maps\_anim::anim_single_solo (brake, "break");
}	

flaks_fire()
{
	self endon ("stop flak88");
	self endon ("crew killed");
	self endon ("crew dismounted");

	self.autoTarget = false;
	
	target = getent(self.target, "targetname");
	while(1)
	{
		wait (randomfloat(2) + 2);	
		if(level.flag["end_dock_scene"])
		{
			self clearturrettarget();
			return;
			level waittill ("end_dock_scene");
			wait (randomfloat(2) + 2);	
		}
		self setTurretTargetEnt( target, (0, 0, 0));
		self waittill("turret_on_target");
		if(level.flag["real_fire"])
			self notify ("turret_fire");
		else
			playsoundinspace("flak88_fire", self.origin);
		earthquake(.1, 1, self.origin, 9000); // scale duration source radius
	}
}

flaks_dockscene_start1()
{
	level endon("fire_off_flaks");
	self waittill("trigger");
	level notify("fire_off_flaks");	
}

flaks_dockscene_start2()
{
	level endon("fire_off_flaks");
	wait 1.5;
	level notify("fire_off_flaks");	
}

flaks_dockscene()
{
	for(i=0;i<level.flakguns.size;i++)
	{
		target = getent(level.flakguns[i].target, "targetname");
		level.flakguns[i] setTurretTargetEnt( target, (0, 0, 0));
	}
	trigger = getent("fire_off_flaks", "targetname");
	trigger waittill("trigger");	
	
	//save before flaks
	auto_save();
	
	trigger = getent("lookat_flaks", "targetname");
	trigger thread flaks_dockscene_start1();
	thread flaks_dockscene_start2();
	
	level waittill("fire_off_flaks");	
	
	level.flakguns[2] notify ("turret_fire");
	wait .75;
	level.flakguns[3] notify ("turret_fire");
	wait .1;
	level.flakguns[0] notify ("turret_fire");
	wait .75;
	level.flakguns[1] notify ("turret_fire");
}

flaks_main()
{
	level.flakguns = [];
	level.flakguns[level.flakguns.size] = getent("flak_gun1", "targetname");
	level.flakguns[level.flakguns.size] = getent("flak_gun2", "targetname");
	level.flakguns[level.flakguns.size] = getent("flak_gun3", "targetname");
	level.flakguns[level.flakguns.size] = getent("flak_gun4", "targetname");
	level notify("flakguns_available");
	level.flag["end_dock_scene"] = false;
	level.flag["real_fire"] = false;	
	array_thread (level.flakguns, ::flaks_fire);
	
	temp = getentarray("stop flak88", "targetname");
	level.obj1_flak_stoptrig = [];

	for(i=0;i<temp.size;i++)
	{
		if(isdefined(temp[i].script_flak88) && temp[i].script_flak88 == "1")
		{
			level.obj1_flak_stoptrig[level.obj1_flak_stoptrig.size] = temp[i];
			break;
		}
	}
	
	for(i=0;i<temp.size;i++)
	{
		if(isdefined(temp[i].script_flak88) && temp[i].script_flak88 == "2")
		{
			level.obj1_flak_stoptrig[level.obj1_flak_stoptrig.size] = temp[i];	
			break;
		}
	}
	for(i=0;i<temp.size;i++)
	{
		if(isdefined(temp[i].script_flak88) && temp[i].script_flak88 == "3")
		{
			level.obj1_flak_stoptrig[level.obj1_flak_stoptrig.size] = temp[i];	
			break;
		}
	}
	for(i=0;i<temp.size;i++)
	{
		if(isdefined(temp[i].script_flak88) && temp[i].script_flak88 == "4")
		{
			level.obj1_flak_stoptrig[level.obj1_flak_stoptrig.size] = temp[i];	
			break;
		}
	}
	trigger = getent("start_dock_scene", "targetname");
	trigger waittill("trigger");
	level.flag["real_fire"] = true;
	//Smoking ships
	maps\_fx::loopfx("thin_black_smoke_M", (139,13301,-85), 1, (39,13300,-83));//moved to script
	maps\_fx::loopfx("thin_black_smoke_M", (406,13326,-60), 1, (309,13330,-82));//moved to script
	maps\_fx::loopfx("thin_black_smoke_M", (-3587,12396,-12), 1, (-3683,12385,-36));//moved to script
	maps\_fx::loopfx("thin_black_smoke_M", (-3851,12421,205), 1, (-3948,12410,182));//moved to script
	level notify ("start_dock_scene");
	
	flak_guys = [];
	for(i = 0; i < 4; i++)
		flak_guys[flak_guys.size] = [];
	
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_flak88) && ai[i].script_flak88 == "1")
			flak_guys[0][flak_guys[0].size] = ai[i];
	
		else if(isdefined(ai[i].script_flak88) && ai[i].script_flak88 == "2")
			flak_guys[1][flak_guys[1].size] = ai[i];
		
		else if(isdefined(ai[i].script_flak88) && ai[i].script_flak88 == "3")
			flak_guys[2][flak_guys[2].size] = ai[i];
		
		else if(isdefined(ai[i].script_flak88) && ai[i].script_flak88 == "4")
			flak_guys[3][flak_guys[3].size] = ai[i];
		
	}
	
	for(i = 0; i < flak_guys.size;i++)
		array_thread (flak_guys[i], ::flaks_guythink, i);
	
	level.flag["end_dock_scene"] = true;
	flaks_dockscene();
	level.flag["end_dock_scene"] = false;
	level notify ("end_dock_scene");
}	

flaks_guythink(index)
{
	level.flakguns[index].crew_num = level.flakguns[index].crewsize;
	self waittill("death");
	
	if(isdefined(level.obj1_flak_stoptrig[index]))
	{
		level.obj1_flak_stoptrig[index] notify("trigger");	
		level.flakguns[index] notify ("stop flak88");
	}
	
	level.flakguns[index].crew_num--;
	if(!level.flakguns[index].crew_num)
		level.obj1_flak_stoptrig[index] notify("crew killed");
}

#using_animtree("eldaba_tower_explode");
mosque_explode(mosquebroke)
{
	fxPos = (-528, -104, 1110);
	org2 = spawn("script_origin", fxPos);
	org2 playsound (level.scrsound["mosque explode"]);
	
	maps\_utility::exploder(1);
	
	mosquebroke show();
	mosquebroke.animname = "mosque";
	mosquebroke UseAnimTree(#animtree);
	mosquebroke thread maps\_anim::anim_single_solo(mosquebroke, "explode");
	
	wait .5;
	earthquake(1.0, 1.5, fxPos, 5000); // scale duration source radius
	ent = getent("mosque_smoke_org","targetname");
	level notify("mosque blown");
	
	time = 0;
	
	wait 5;
	mosquebroke delete();
/*	while(time < 20)
	{
		playfx(level._effect["thin_black_smoke_M"], ent.origin, (ent.origin + (0,0,10)));
		time += .6;
		wait .6; 
	}*/
}

intro_artillery_hits()
{
	level endon ("dismounted truck");

    maps\_utility::exploder(7);

    wait 12;
    maps\_utility::exploder(7);

    wait 12;
    maps\_utility::exploder(7);

    wait 12;
    maps\_utility::exploder(7);

    wait 12;
    maps\_utility::exploder(7);
}

mosque_think()
{	
	mosque = getent("mosque_top_broken", "targetname");
	mosque hide();
	if(!level.jumptodocks)
	{
		level waittill("lead tank dead");
		wait 6;
		auto_save();
		wait 6;
	}
	mosque_explode(mosque);
}

friendly_main()
{
	level.flag["no_reinforcements"] = false;
	thread friendly_ChainMain();
	thread friendly_reinforcements();
	trig = getent("reinforcements3","target");
	trig triggerOff();
	trig = getent("reinforcements5","target");
	trig triggerOff();
}

friendly_reinforcements()
{
	triggers = getentarray("reinforcement_tracker","targetname");
	array_thread(triggers, ::friendly_reinforcements_setup);
}

friendly_reinforcements_setup()
{
	spwnrs = getentarray(self.target, "targetname");
	array_thread(spwnrs, ::friendly_reinforcements_think, self);
}

friendly_reinforcements_think(trigger)
{
	self.count = 0;
	self.timer = false;
	if(isdefined(self.script_noteworthy) && (self.script_noteworthy == "reinforcements3" || self.script_noteworthy == "reinforcements4") )
		self.script_startinghealth = 400;
	
	while(1)
	{
		trigger waittill("trigger", other);
		level.reinforcement_trigger = trigger;
	
		while(!level.flag["no_reinforcements"])
		{
			wait .1;
			if(	level.reinforcement_trigger != trigger)
				break;
			if(self.timer)
				self waittill("timer done");
			self.count = 1;
			guy = self dospawn();
			if(spawn_failed(guy))
				continue;
			
			self thread friendly_reinforcements_think3();
			guy thread maps\_utility::magic_bullet_shield();
			guy.ignoreme = true;
			guy thread friendly_reinforcements_think2();
			wait 2;
			if( !(isdefined(guy) && isalive(guy)) )
				continue;
			guy notify ("stop magic bullet shield");
			guy.ignoreme = false;		
			guy waittill("death");
		}
	}	
}

friendly_reinforcements_think3()
{
	self.timer = true;
	wait 3;
	self.timer = false;
	self notify("timer done");
}

friendly_reinforcements_think2()
{
	self endon("death");
	if(!level.flag["friendly_chain"])
		level waittill("friendly_chain");
	self setgoalentity(level.player);
	self.followmax = level.global_ed_assmax;
	self.followmin = level.global_ed_assmin;
	self.maxdist *= .75;
	self.fightdist *= .75;
}

friendly_ChainTrigger(name, number, repeat)
{
	trigger = getent(name, "target");
	if(isdefined(repeat) && repeat != false)
		_rep = true;
	else
		_rep = false;
	while(1)
	{
		trigger waittill("trigger");
		chain = get_friendly_chain_node (number);
		level.player SetFriendlyChain (chain);
		level.flag["friendly_chain"] = true;
		level notify("friendly_chain");
		
		if(!_rep)
			break;
	}
	trigger thread triggerOff();
}

friendly_ChainFlak1()
{
	level waittill("fire_off_flaks");
	self triggerOn();
}

friendly_ChainDockwall()
{
	//level waittill("docks mg42 lit up");
	ent = getent("throw_smoke_here","targetname");
	level waittill ("smoke_was_thrown"+ent.origin);
	self notify("trigger");
	self triggerOff();
}

friendly_reinforcementOn(name)
{
	level waittill("friendly_chain");
	trig = getent(name,"target");
	trig triggerOn();
	trig notify ("trigger");
}

friendly_ChainMain()
{
	level.flag["friendly_chain"] = false;
	firstflak 	= getent("fc300","target");
	firstflak 	thread triggerOff();
	mgpassage	= getent("fc500", "target");
	mgpassage	thread triggerOff();
	doortrig	= getent("mghp_sidedoor_trig", "targetname");
	doortrig 	thread triggerOff();
	kickertrig = getent("fc600","target");
	kickertrig 	thread triggerOff();
	
	if(!level.jumptodocks)
	{
		//flank to the right of the mosque;
		friendly_ChainTrigger("fc0", "0");
		friendly_ChainTrigger("fc25", "25");
		friendly_ChainTrigger("fc50", "50");
	
	
		//inside the house and out the back
		friendly_ChainTrigger("fc75", "75");
		friendly_ChainTrigger("auto7697", "200");
	}
	if(!level.jumptocom)
	{
		//take the docks
		level waittill ("start_dock_scene");
		level.flag["friendly_chain"] = false;
	
		thread friendly_reinforcementOn("reinforcements3");
	}		
	if(!level.jumptomg)
	{
		thread friendly_ChainTrigger("fc300", "300");
		thread friendly_ChainTrigger("fc395", "395");
		firstflak thread friendly_ChainFlak1();
		dockwall = getent("fc395", "target");
		dockwall thread friendly_ChainDockwall();
	}	
	if(!level.jumptocom)
	{	
		friendly_ChainTrigger("fc315", "315");
		friendly_ChainTrigger("fc325", "325");
		friendly_ChainTrigger("fc350", "350");
		friendly_ChainTrigger("fc375", "375");
	}
	if(!level.jumptomg)
	{
		//the comm center
		friendly_ChainTrigger("fc400", "400");
		auto_save();
	}	
	if(!level.jumptoend)
	{
		//attack towards the mg42
		level waittill("move_on_past_com");
		kickertrig thread triggerOn();
		thread dialogue_comcomplete();
		//grab AI and make them stop following you
		ai = getaiarray("allies");
		rambo = getnodearray("mg42_rambo","targetname");
		num = 0;
		for(i=0;i<ai.size;i++)
		{
				ai[i] setgoalnode(rambo[num]);
				num++;
				if(num >= rambo.size)
					num = 0;
		}
		
		//as soon as a new friendly chain is set (mgpassage triggerOn), these guys will spawn
		thread friendly_reinforcementOn("reinforcements5");
		//the mg passage
		wait .1;
		mgpassage triggerOn();
		doortrig triggerOn();
		//"this way" near ally
		thread friendly_ChainTrigger("fc500", "500");
		//INTO the ally
		thread friendly_ChainTrigger("fc600", "600");
		
		spawner = getent("door_kicker","script_noteworthy");
		spawner thread friendly_doorkicker();

		//bust down the door
		doortrig waittill("trigger");
		auto_save();
		level notify("kick_down_the_door");
		
		//into the alley
		friendly_ChainTrigger("fc700", "700");
		//into the room
		friendly_ChainTrigger("fc900", "900");
		level.doorkicker delete();
		auto_save();
		level notify("overlooking_mgnest");
		thread sky_killplanes();
		//out the window into the obj
		friendly_ChainTrigger("fc1000", "1000");
	}	
	else
	{
		trig = getent("reinforcements7","target");
		wait .05;
		trig notify("trigger");
		level notify("overlooking_mgnest");
	}
	
	//wait by the alley
	level waittill("move on past mg42 nest");
	//go to the gate
	friendly_ChainTrigger("fc1100", "1100");
	//but have 1 dude get on the mg
	//and kill the rest of your friendly ai if they still exist
	wait .1;
	ai = getaiarray("allies");
	friendly = [];
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i].script_noteworthy) && (ai[i].script_noteworthy == "reinforcements6" || ai[i].script_noteworthy == "reinforcements7") )
			friendly[friendly.size] = ai[i];
		else
			ai[i] delete();
	}
	if(friendly.size)
		friendly[0] thread end_friendly_useturret();
	
	level waittill("end_leftflank_spawned");
	level notify("get_off_that_mg42");
	level.player.ignoreme = true;
	auto_save();
	friendly_ChainTrigger("fc1250", "1250");
	level.flag["no_reinforcements"] = true;
	friendly_ChainTrigger("fc1300", "1300");
	level notify("end_mission");
} 

friendly_doorkicker()
{	
	self waittill("spawned", kicker);	
	if(spawn_failed(kicker))
		assertEX(isdefined(kicker), "door kicker isn't being defined");
	
	kicker thread maps\_utility::magic_bullet_shield();
	kicker.anim_disablePain = true; 
	kicker.oldgrenadeawareness = kicker.grenadeawareness;
	kicker.grenadeawareness =0;
	
	kicker endon("death");
	kicker thread friendly_doorkicker_death_fail();
	
	level.doorkicker = kicker;
	
	node = getnode("mghp_sidedoor_node","targetname");
	door = getent("doorbreach_door","targetname");
		
	level waittill("kick_down_the_door");
	
	ai_kickdoor (kicker, node, door);
	
	level notify("mg_door_breached");
	
	level waittill("doorbreachmgguy_stopshoot");
	
	clip = getent("doorbreachclip", "targetname");
	clip notsolid();
	clip connectpaths();
	clip delete();
}		

friendly_doorkicker_death_fail()
{
	level endon("started_doorshread");
	while(1)
	{		
		self waittill("damage", amount, ent);
		if(ent == level.player)
			break;
	}
	setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH");
	maps\_utility::missionFailedWrapper();
}

objectives_flak(objnum, i)
{
	objective_additionalposition(objnum, i, self.origin);
	self triggerOff();
	level waittill ("start_dock_scene");
	self triggerOn();
	self waittill("trigger");
	level.flaknum--;
	objective_additionalposition(objnum, i, (0,0,0) );
	if(level.flaknum)
		objective_string(objnum, level.obj_string["docks1"], level.flaknum);
	
	level notify("one flak crew killed");
}

objectives()
{
	//enter town and take out the flaks
	objnum = 1;
	if(!level.jumptocom)
	{
		//level waittill("flakguns_available");
		wait 6;
		level.flaknum = level.flakguns.size;
		
		objective_add(objnum, "active", "");
		objective_string(objnum, level.obj_string["docks1"], level.flaknum);
		objective_current(objnum);
		for(i=0;i< level.obj1_flak_stoptrig.size; i++)
			level.obj1_flak_stoptrig[i] thread objectives_flak(objnum, i);
		
		while(level.flaknum)
			level waittill("one flak crew killed");
		
		objective_state(objnum,  "done");
		objective_string(objnum, level.obj_string["docks2"]);
		objnum++;
	}
	if(!level.jumptomg)
	{
		level.flag["speedy_com_obj"] = false;
		objective_add(objnum, "active", level.obj_string["com"], (2752, 1940, 200) );
		objective_current(objnum);
		
		level waittill("docks_objective_completed");
		objective_state(objnum,  "done");
		auto_save();
		objnum++;
	}
	if(!level.jumptoend)
	{
		doctrigs = getentarray("documents", "targetname");
		level.documents = doctrigs.size;
		pos = getent("documents","targetname");
		objective_add(objnum, "active", level.obj_string["hq"], (pos getorigin()));
		objective_current(objnum);
		if(level.jumptomg)
			wait .05;
		if(!level.jumptomg)
		while(!level.flag["speedy_com_obj"])
			level waittill("speedy_com_obj");
		level notify("move_on_past_com");

		array_thread(doctrigs, ::objectives_doc, objnum);

		level waittill("documents_taken");
		objective_state(objnum, "done");
		auto_save();
		objnum++;
	}

	if(!(getcvar ("demolevel") == "1"))
		maps\_inventory::inventory_create( "inventory_docs", true );
	thread dialogue_dockobj();
	price = getnode("endmission_macnode","targetname");
	objective_add(objnum, "active", level.obj_string["price"], price.origin);
	objective_current(objnum);
	if(level.jumptoend)
		wait .1;
	level notify("move on past mg42 nest");
	level waittill("end_leftflank_spawned");
	musicPlay("eldaba_end_music");
	
	level waittill("mission_complete");
	objective_state(objnum, "done");
}

dialogue_dockobj()
{
	wait 1.5;
	playsoundinspace("eldaba_bs1_itsallclear",(1402, -781, 82));
}

objectives_doc(objnum)
{
	self setHintString (level.strings["doc"]);
	self waittill("trigger");

	org =  self getorigin();	
	thread playsoundinspace("Paper_grab", org);

	map = getentarray(self.target, "targetname");
	for(i=0;i<map.size;i++)
		map[i] delete();	
		
	
	self delete();
	
	level.documents--;
	
	if(level.documents == 0)
		level notify("documents_taken");
	
	wait .5;
	playsoundinspace("Paper_tear",org);
}

sky_main()
{
	skynode = getnodearray("sky_center","targetname");
	
	level.planes = [];
	array_thread (skynode, ::sky_loop);
	
	thread sky_dockflyby();	
	if(!level.jumptodocks)
	{
		thread sky_crashing1();
		thread sky_attacking1();
		thread sky_strafing1();
	}
//	if(!level.jumptoend)
//		thread sky_crashing2();
}

sky_explode()
{
	self endon("death");
	self waittillmatch("single anim", "custom = damaged");
	playfx(level._effect["planeexplosion"], self.plane.origin);
	earthquake(1.0, 1.5, self.plane.origin, 5000);
	self.plane playsound (level.scrsound["plane explode"]);
}

sky_delete_plane()
{
	self waittillmatch("single anim", "end");
	self.plane delete();
	self delete();
}
	
sky_drop_bomb(startnode, speed)
{
	//create the bomb
	bomb = spawn("script_origin", startnode.origin);
	
	node1 = startnode;
	node2 = getent(node1.target, "targetname");
	
	vec = vectorNormalize(node2.origin - node1.origin);
	vec = maps\_utility::vectorScale(vec, speed);
	
	
	model = spawn("script_model", startnode.origin);
	model setmodel ("xmodel/prop_stuka_bomb");
	bomb.angles = model.angles;
	model linkto(bomb);
	bomb.angles = (vec + (0,180,0));
	
	bomb moveGravity(vec, 5);
	
	wait 6;
	model unlink();
	bomb delete();
	model delete();
}

sky_crashing2()
{
	trig = getent("look_planecrash2", "targetname");
	trig waittill ("trigger");
	plane = sky_makeplane("well_p_crash", undefined, 180);
	plane thread sky_crashing1_flame();
	plane thread sky_quake();
	plane thread playSoundOnTag(level.scr_sound ["stuka_1"], "tag_prop");
	plane waittill("reached_end_node");
	
	maps\_utility::exploder(9);
	plane notify ("delete me");
	plane delete();
}

sky_crashing1()
{
	end = getvehiclenode("p2", "targetname");
	soundorg = spawn("script_model", end.origin);
	
	time = 26;
	stime = 1.65;
	
	wait (time - stime);
	soundorg playsound(level.scrsound["plane_crashing"]);
	level notify("oh_look_its_got_one");
	
	wait (stime);
	plane = sky_makeplane("p2", undefined, 250);
	soundorg linkto(plane);
	plane thread sky_crashing1_flame();
	plane thread sky_quake2();
	plane waittill("reached_end_node");
	
	
	earthquake(1.0, 1.5, plane.origin, 8000); // scale duration source radius
	maps\_utility::exploder(3);
	plane notify ("delete me");
	plane delete();
	
}
sky_crashing1_flame()
{
	self endon ("death");
	self endon ("delete me");
	while (1)
	{
		playfxOnTag ( level._effect["planeenginesmoke"], self, "tag_engine_left" );
		wait .1;
	}
}

sky_dockflyby()
{
	level waittill ("start_dock_scene");
	
	trig = getent("introdockflyby_lookat","targetname");
	trig waittill("trigger");
	
	plane = sky_makeplane("dockintroflyby");
	plane thread playSoundOnTag(level.scr_sound ["stuka_1"], "tag_prop");
	wait 1;
	plane2 = sky_makeplane("dockintroflyby", "xmodel/vehicle_spitfire_flying");
	plane thread playSoundOnTag(level.scr_sound ["spitfire_1"], "tag_prop");
	
	plane waittill("reached_end_node");
	plane delete();
	plane2 delete();	
}

sky_makeplane(name, type, speed)
{
	node = getVehicleNode( name, "targetname" );
	plane = undefined;
	if(isdefined(type))
	{
		plane = spawnVehicle( type, "plane", "stuka", (0,0,0), (0,0,0) );
		plane setmodel (type);
	}
	else
	{
		plane = spawnVehicle( "xmodel/vehicle_stuka_flying", "plane", "stuka", (0,0,0), (0,0,0) );
		plane setmodel ("xmodel/vehicle_stuka_flying");
	}
	plane attachPath( node );
	plane startPath();
	if(isdefined(speed))
		plane setspeed(speed, speed);
	
	plane thread sky_quake();
	return plane;
}

sky_strafing1()
{
	wait 50;	
	plane = sky_makeplane("intro_straf1", undefined, 220);
	plane.firing = false;
	plane thread sky_quake();
	plane thread sky_fireFX();
	
	wait 5.5;
	plane notify ("yo start firing");
	plane.firing = true;

	wait .5;
	plane thread playSoundOnTag(level.scr_sound ["stuka_1"], "tag_prop");
	wait 1.5;
	plane.firing = false;
	
	plane waittill("reached_end_node");
	plane delete();
}

sky_intro_attacking()
{
	plane = sky_makeplane("lpn", undefined, 150);
	plane thread sky_quake();
////////////////////
	wait 2.5;
	plane thread playSoundOnTag(level.scr_sound ["stuka_3"], "tag_prop");
	wait .8;
	temp 				= getent("dropbomb_entrance","targetname");
	bombnode 			= spawn("script_origin", ((plane getTagOrigin("tag_BIGbomb"))));
	bombnode.target 	= temp.targetname;
	thread sky_drop_bomb(bombnode, 3000);
	level notify ("entrance_bomb_released");
////////////////////	
	plane waittill("reached_end_node");
	plane delete();
}

sky_attacking1()
{
	wait 46.3;
	plane = sky_makeplane("p1", undefined, 220);
	
	node = getvehiclenode("auto242", "targetname");
	plane setwaitnode(node);
	bombnode = getent("dropbomb1","targetname");
	
	plane waittill("reached_wait_node");
	plane thread playSoundOnTag(level.scr_sound ["stuka_2"], "tag_prop");
	thread sky_drop_bomb(bombnode, 4200);
	level notify("tank bomb dropped");
	
	plane waittill("reached_end_node");
	plane delete();
}

#using_animtree("eldaba_dogfight");
sky_anim(node, animation, trigger)
{
	trigger waittill("trigger");
	pnode = spawn("script_origin", node.origin);
	
	pnode.angles = node.angles;//` + (0, -90, 0);
	
	pair = [];
	
	rig 				= spawn("script_model", (0,0,0));
	rig.animname 		= "plane british";
	rig setmodel ("xmodel/eldaba_plane_rig");
	rig hide();
	rig UseAnimTree(#animtree);
	
	plane 				= spawn ("script_model",(0,0,0));
	plane setmodel ("xmodel/vehicle_spitfire_flying");
	plane linkto (rig, "tag_rotator_b", (0,0,0), (0,0,0));
	plane thread playLoopSoundOnTag(level.scr_sound ["spitfire_plane_loop"], "tag_prop");
	rig.plane = plane;
	//plane thread sky_quake();	
	rig linkto (pnode);
	rig.pnode = pnode;
	pair[pair.size] = rig;
	
	rig = undefined;
	plane = undefined;
	
	rig 				= spawn("script_model", (0,0,0));
	rig.animname 		= "plane german";
	rig setmodel ("xmodel/eldaba_plane_rig");
	rig hide();
	rig UseAnimTree(#animtree);
	
	plane 				= spawn ("script_model",(0,0,0));
	plane setmodel ("xmodel/vehicle_stuka_flying");
	plane linkto (rig, "tag_rotator_g", (0,0,0), (0,0,0));
	plane thread playLoopSoundOnTag(level.scr_sound ["stuka_plane_loop"], "tag_prop");
	rig.plane = plane;
	//plane thread sky_quake();	
	rig linkto (pnode);	
	rig.pnode = pnode;	
	pair[pair.size] = rig;
	
	pnode thread maps\_anim::anim_single(pair, animation);
	
	array_thread (pair, ::sky_fire);
}

#using_animtree("eldaba_dogfight");
sky_loop()
{
	node = self;
	pair = [];
	loc = node.origin;
	pnode = spawn("script_origin", loc);
	
	
	rig 				= spawn("script_model", (0,0,0));
	rig.animname 		= "plane british";
	rig setmodel ("xmodel/eldaba_plane_rig");
	rig hide();
	rig UseAnimTree(#animtree);
	
	plane 				= spawn ("script_model",(0,0,0));
	plane setmodel ("xmodel/vehicle_spitfire_flying");
	plane linkto (rig, "tag_rotator_b", (0,0,0), (0,0,0));
	plane thread playLoopSoundOnTag(level.scr_sound ["spitfire_plane_loop"], "tag_prop");
	rig.plane = plane;
	//plane thread sky_quake();	
	rig linkto (pnode);
	rig.pnode = pnode;
	level.planes[level.planes.size] = rig;
	pair[pair.size] = rig;
	
	
	rig = undefined;
	plane = undefined;
	
	rig 				= spawn("script_model", (0,0,0));
	rig.animname 		= "plane german";
	rig setmodel ("xmodel/eldaba_plane_rig");
	rig hide();
	rig UseAnimTree(#animtree);
	
	plane 				= spawn ("script_model",(0,0,0));
	plane setmodel ("xmodel/vehicle_stuka_flying");
	plane linkto (rig, "tag_rotator_g", (0,0,0), (0,0,0));
	plane thread playLoopSoundOnTag(level.scr_sound ["stuka_plane_loop"], "tag_prop");
	rig.plane = plane;
	//plane thread sky_quake();	
	rig linkto (pnode);	
	rig.pnode = pnode;	
	level.planes[level.planes.size] = rig;
	pair[pair.size] = rig;
	
	pnode.angles = node.angles;
	
	wait(randomfloat(1.5));
	pnode thread maps\_anim::anim_loop(pair, "loop");//, undefined, "stop plane loop");
	pnode = undefined;

	array_thread (pair, ::sky_fire);
}

sky_fireFX()
{
	self endon ("death");
	
	while(1)
	{	
		while(!self.firing)
			self waittill ("yo start firing");
		
		self thread playLoopSoundOnTag(level.scr_sound ["stuka gun loop"], "tag_gunLeft");
		self thread playLoopSoundOnTag(level.scr_sound ["stuka gun loop"], "tag_gunRight");
	
		while(self.firing)
		{
			//find orientation
			ang = anglesToForward (self.angles);
			ang2 = ang;
			ang = maps\_utility::vectorScale(ang, 5000);
			ang2 = maps\_utility::vectorScale(ang2, 700);
			
			//left
			playfxOnTag ( level._effect["planeshoot"], self, "tag_gunLeft" );
			org = self gettagorigin("tag_gunLeft");
			org = org+ang2;
			bulletTracer(org, org + ang);
			
			//right
			playfxOnTag ( level._effect["planeshoot"], self, "tag_gunRight" );
			org = self gettagorigin("tag_gunRight");
			org = org+ang2;
			bulletTracer(org, org + ang);

			wait (0.05);
		}
		self notify("stop sound" + level.scr_sound["stuka gun loop"]);	
	}

}

sky_fire()
{
	self endon ("death");
	self.plane endon("death");
	self.plane.firing = false;
	self.plane thread sky_fireFX();
	while(1)
	{
		self waittill("looping anim", notetrack);
		if(notetrack == "fire = start")
		{
			self.plane.firing = true;
			self.plane notify ("yo start firing");	
		}
		else if(self.plane.firing == true && notetrack == "fire = end")
			self.plane.firing = false;	
	}
}

sky_quake()
{
	self endon("death");
	while (1)
	{
		earthquake(0.5, 0.1, self.origin, 3000); // scale duration source radius
		wait (0.1);
	}
}

sky_quake2()
{
	self endon("death");
	while (1)
	{
		earthquake(0.75, 0.1, self.origin, 4000); // scale duration source radius
		wait (0.1);
	}
}

sky_killplanes()
{
	for(i=0;i<level.planes.size;i++)
		level.planes[i].plane delete();
}

auto_save()
{
	if(!isdefined(level.autosavenum))
		level.autosavenum = 1;
	autosave(level.autosavenum);
	level.autosavenum++;
}

open_door_msg(name, msg)
{
	doors = getentarray(name, "targetname");
	for (i=0;i<doors.size;i++)
		doors[i] disconnectpaths();
		
	level waittill(msg);
	
	for (i=0;i<doors.size;i++)
	{
		doors[i] notsolid();
		doors[i] connectpaths();
		doors[i] solid();
		if (doors[i].script_noteworthy == "right")
			doors[i] rotateyaw(89, 0.4,0.05,0.05);
		else
			doors[i] rotateyaw(-92, 0.4,0.05,0.05);
	}
}

playsound_ontrigger()
{
	self waittill ("trigger");
	org = getent(self.target, "targetname");
	if(!isdefined(org) || org.classname != "script_origin")
		assertEX(isdefined(org), "play sound at "+ self getorigin() + " is not defined");
	else
		org playsound (self.script_noteworthy);
}

disable_long_deaths()
{
	self waittill("spawned", guy);
	if (spawn_failed(guy))
		return;
	guy.anim_disableLongDeath = true;
}
getClosestNode(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0].origin, org);
	ent = array[0];
//	dist = 256;
//	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getFurthestNode(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0].origin, org);
	ent = array[0];
//	dist = 256;
//	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist < dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

eldaba_demo_main()
{
	level.xenon = false; 
    if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
		level.xenon = true;
	
	// generates "Get to Cover" x number of times when you first get hurt
   	setcvar( "takeCoverWarnings", 10 );
    
    level.strings["objective_hint"] 		= spawnstruct();
	level.strings["objective_hint"].text	= &"ELDABA_OBJ_HINT";
	precacheShader("objective");
	precacheshader("logo_cod2");
	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		precacheshader("popmenu_bg");
	precacheString(level.strings["objective_hint"].text);
    
    thread eldaba_logo_promo("logo_cod2", 179,45,15,-5);
    
    level waittill("eldaba_mac_goodworkdavis");
    
    if(level.xenon)
		eldaba_demo_special_hint("objective", "objective_hint", 20, 0, 10, 70, 137);
	else
		eldaba_demo_special_hint("objective", "objective_hint", 20, 0, 10, 60, 180);	
}

eldaba_logo_promo(shader, scalex, scaley, x, y)
{
	logo = newHudElem();
	logo setShader(shader, scalex, scaley);
	logo.y = y;
	logo.x = x;
	logo.alignX = "right";
	logo.alignY = "top";
	logo.horzAlign = "right";
	logo.vertAlign = "top";
}

special_hint_background()
{
	if(!isdefined(self.background))
		return;
	self.background.x = 320;
	self.background.y = 206;
	self.background.alignX = "center";
	self.background.alignY = "middle";
	if(level.xenon)
		self.background setshader("popmenu_bg", 650, 60);
	else
		self.background setshader("popmenu_bg", 650, 50);
	self.background.alpha = .5;
}

eldaba_demo_special_hint(shader, hint, scale, xoffset, yoffset, xnum, ynum, horzAlign)
{
	if (flag("player_has_red_flashing_overlay"))
		return undefined;
	level notify("hud_elem_going_up");
	level endon("hud_elem_going_up");
	level endon("hud_elem_interupt");
	
	background = undefined;
	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		background = newHudElem();
		
	stancehint = newHudElem();
	stancehint.label = (level.strings[hint].text);
	if(isdefined(level.strings[hint].bind))
		stancehint setText(level.strings[hint].bind);
	
	stancehint.background = background;
	stancehint special_hint_background();
	
	stancehint add_hudelm_position();
	
	stanceicon = newHudElem();
	stanceicon add_hudelm_position(true, (xoffset - 15), (xoffset - 10), yoffset);

	if(level.xenon)
		stanceicon setShader(shader, (scale + 5), (scale + 5));
	else
		stanceicon setShader(shader, scale,  scale);
	
	stanceicon thread add_hudelem_pulse(1, true);
	stancehint thread add_hudelem_pulse(1, true);
	
	stanceicon thread eldaba_demo_remove_specialhint("hud_elem_going_up");
	stanceicon thread eldaba_demo_remove_specialhint("hud_elem_interupt");
	stancehint thread remove_hudelm_hint("hud_elem_going_up");
	stancehint thread remove_hudelm_hint("hud_elem_interupt");
	
	wait 5;
	
	stanceicon destroy();
	stanceicon = newHudElem();
	if(level.xenon)
		stanceicon setShader(shader, (scale + 5), (scale + 5));
	else
		stanceicon setShader(shader, scale, scale);
	
	stanceicon add_hudelm_position(true, (xoffset - 15), (xoffset - 10), yoffset);
	stanceicon thread eldaba_demo_remove_specialhint("hud_elem_going_up");
	stanceicon thread eldaba_demo_remove_specialhint("hud_elem_interupt");
	stanceicon.alpha = 1;
	
	stanceicon moveovertime(1);
	stanceicon.x = xnum; 
	stanceicon.y = ynum;
	if(isdefined(horzAlign))
		stanceicon.horzAlign = horzAlign;
	else
		stanceicon.horzAlign = "left";
	stanceicon.vertAlign = "middle";
	
	if(level.xenon)
		stanceicon scaleovertime(1, scale, scale);
	else
		stanceicon scaleovertime(1, (scale-5), scale-5);
	wait .85;
	stanceicon fadeovertime(.15);
	stanceicon.alpha = 0;

	wait .5;
	
	stancehint fadeovertime(.5);
	stancehint.alpha = 0;
	if(isdefined(stancehint.background))
	{
		stancehint.background fadeovertime(.5);
		stancehint.background.alpha = 0;
		stancehint.background destroy();
	}
	
	stancehint destroy();
	stanceicon destroy();
}

eldaba_demo_remove_specialhint(ender)
{
	level waittill(ender);
	if(!isdefined(self))
		return;
	self notify("destroying");
	self notify("destroyed");
	self destroy();
}

special_mg_settings()
{
	turrets = getentarray("misc_turret","classname");
	for (i=0;i<turrets.size;i++)
	{
		if (turrets[i].origin == (-834, -222, 29))
			turrets[i] set_turret_settings();
		if (turrets[i].origin == (-943, 233, 203))
			turrets[i] set_turret_settings();
	}
}

set_turret_settings()
{
	self.script_delay_min = 0.2;
	self.script_delay_max = 1;
	self.script_burst_min = 0.2;
	self.script_burst_max = 0.7;
	self.convergencetime = 100;
}

special_demo_settings()
{
	thread createAutoSave((-160.375, -620.452, 17.8769), 256);
	spawners = getspawnerteamarray("axis");
	exportNums = [];
	exportNums[exportNums.size] = 291;
	exportNums[exportNums.size] = 292;
	exportNums[exportNums.size] = 293;
	exportNums[exportNums.size] = 294;
	exportNums[exportNums.size] = 380;
	exportNums[exportNums.size] = 381;
	exportNums[exportNums.size] = 301;
	exportNums[exportNums.size] = 302;
	exportNums[exportNums.size] = 306;
	
	for (i=0;i<spawners.size;i++)
	{
		for (p=0;p<exportNums.size;p++)
		{
			if (spawners[i].export == exportNums[p])
				spawners[i] thread removeSpawnersGrenades();
		}
	}
}

removeSpawnersGrenades()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (!spawn_failed(spawn))
			spawn.grenadeammo = 0;
	}
}

createAutoSave(org, radius)
{
	ent = spawn("trigger_radius",org, 0, radius, 128);
	ent waittill ("trigger");
	autosave(1);
}