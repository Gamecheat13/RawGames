#include maps\_utility;
#include maps\_anim;
#include animscripts\utility;
#include animscripts\shared;
#using_animtree("generic_human");
main()
{
	setsavedcvar( "cg_drawHUD", 0 );
	thread fovChange();


//    setCullFog (300, 3500, 25/256, 45/256, 48/256, 0.1);
//	setcullfog (5, 4000, 0.43, 0.43, 0.454, 0);
    setCullFog (300, 3500, 25/256, 45/256, 48/256, 0.1);
//	setsavedcvar("timescale", "0.5");

	precachemodel("xmodel/door_barn_credit");
	precacheModel("xmodel/wall_tank_pieces");
	precacheModel("xmodel/wall_tank_broke");
	precacheModel("xmodel/tag_origin");

	level.timescaleEnabled = false;
//	level.timescaleEnabled = true;
//	level.mortar = loadfx ("fx/impacts/newimps/minefield_dark.efx");
	//level.mortar = level._effect["mortar"];
//	if (getcvar ("start") != "start")
//		return;
	thread checklev();
//	level.check = true;
/*
	=================
	credits file changes
	=================
*/
	iwNames();

	level.cameraOffsetPrint = [];
	level.cameraOffset = [];

	level.cameraOffset["camera"] = (-2.93652,-9.74121,-0.868896);
	level.cameraOffset["auto240"] = (-0.477539,-10.3975,-0.909668);
	level.cameraOffset["auto242"] = (-0.0595703,-1.30127,-0.0141602);
	level.cameraOffset["auto244"] = (-21.917,-13.5674,-5.81909);
	level.cameraOffset["auto246"] = (4.1123,-4.92822,-0.344238);
	level.cameraOffset["auto293"] = (-0.717773,17.4702,-2.60425);
	level.cameraOffset["auto248"] = (-0.40332,0,-0.00769043);
	level.cameraOffset["auto250"] = (1.53223,1.57715,-0.0402832);
	level.cameraOffset["auto284"] = (-3.29541,-5.88257,-0.380005);
	level.cameraOffset["auto289"] = (-1.21387,-9.9519,-0.843506);
	level.cameraOffset["auto291"] = (3.60742,-9.77246,-0.911133);
	level.cameraOffset["camera_ladder"] = (8.47705,-11.113,-1.65076);
	level.cameraOffset["camera_ladder_top"] = (-33.7905,0,-10.4197);
	level.cameraOffset["auto312"] = (-1.3562,-4.65918,-0.196533);
	level.cameraOffset["auto314"] = (-10.3926,13.3618,-2.43738);
	level.cameraOffset["auto317"] = (-3.35083,21.9993,-4.2793);
	level.cameraOffset["auto319"] = (-18.4736,11.4258,-4.06982);
	level.cameraOffset["camera_beat_far"] = (40.3845,27.6316,-25.2786);
	level.cameraOffset["camera_beat_close"] = (18.3772,6.19702,-3.22083);
	level.cameraOffset["auto326blend"] = (-6.78516,3.07886,-0.369995);
	level.cameraOffset["auto327blendEnd"] = (-8.80908,3.18335,-0.735596);
	level.cameraOffset["camera_breakdoor"] = (-0.420654,5.39941,-0.244873);
	level.cameraOffset["camera_farm"] = (10.1948,0,-0.878662);
	level.cameraOffset["auto336"] = (-10.0681,19.0051,-3.98718);
	level.cameraOffset["auto339"] = (-3.78052,2.24561,-0.161377);
	level.cameraOffset["camera_spotlight"] = (-15.8992,27.001,-8.83203);
	level.cameraOffset["camera_surrender"] = (5.14893,-10.9175,-1.22681);
	level.cameraOffset["camera_look"] = (-14.0144,-5.81738,-1.95044);
	level.cameraOffset["camera_door_kick_far"] = (1.33215,-1.573,-0.0354004);
	level.cameraOffset["camera_door_kick"] = (2.52869,-4.91528,-0.255127);
	level.cameraOffset["auto347"] = (1.66455,0,-0.0252686);
	level.cameraOffset["auto361"] = (-22.8053,14.3196,-6.3822);
	level.cameraOffset["camera_halftrack_entrance"] = (-7.40761,15.5842,-2.53479);
	level.cameraOffset["auto366"] = (-51.285,23.8862,-40.0178);
	level.cameraOffset["camera_halftrack_unload"] = (0,-17.6453,-2.65332);
	level.cameraOffset["camera_axis_watch"] = (13.3627,5.93457,-1.80872);
	level.cameraOffset["camera_house_defend"] = (-5.2937,0,-0.234009);
	level.cameraOffset["camera_corner_planner"] = (5.15741,2.80762,-0.288086);
	level.cameraOffset["camera_30cal"] = (-0.141357,-3.00977,-0.0756836);
	level.cameraOffset["camera_corner_planner"] = (5.15741,2.80762,-0.288086);
	level.cameraOffset["camera_corner_sneak"] = (1.69336,0,-0.0319824);
	level.cameraOffset["camera_corner_sneak_blend"] = (-0.0584717,3.81079,-0.121216);
	level.cameraOffset["camera_sneak_attack"] = (-0.521362,0,-0.00878906);
	level.cameraOffset["camera_30cal"] = (-0.141357,-3.00977,-0.0756836);
	level.cameraOffset["camera_mortar_setup"] = (-2.60919,3.43237,-0.155151);
	level.cameraOffset["camera_mortar_setup"] = (-3.94043,7.48438,-1.11792);
	level.cameraOffset["camera_mortar_setup_blend"] = (8.38239,10.3083,-1.4895);
	level.cameraOffset["camera_drag_hit"] = (8.89429,0,-0.66333);
	level.cameraOffset["camera_house_smoke"] = (-22.9023,3.6731,-4.66467);
	level.cameraOffset["camera_smoke_throw"] = (2.46008,3.1189,-0.131592);
	level.cameraOffset["camera_smoke_throw_blend"] = (2.4353,-3.13794,-0.131592);
	level.cameraOffset["camera_smoke_escape"] = (17.2502,0,-2.53564);
	level.cameraOffset["camera_window"] = (-1.94254,23.4871,-4.82227);
	level.cameraOffset["camera_car"] = (3.78693,14.0706,-1.79626);
	level.cameraOffset["camera_car"] = (3.78693,14.0706,-1.79626);
	level.cameraOffset["camera_car_blend"] = (4.17346,12.8145,-1.5332);
	level.cameraOffset["camera_car_right"] = (29.1531,8.45654,-8.245);
	level.cameraOffset["camera_car_left"] = (-27.2728,-11.2422,-7.75244);
	level.cameraOffset["camera_tank_wall"] = (-2.63611,-1.83447,-0.0860596);
	level.cameraOffset["camera_car_chase"] = (0,0,0);
	level.cameraOffset["camera_tank_search"] = (-15.4424,0,-2.02258);
	level.cameraOffset["camera_tank_search"] = (-15.4424,0,-2.02258);
	level.cameraOffset["camera_tank_search_blend"] = (-21.814,0,-4.112);
	level.cameraOffset["camera_car_drive"] = (10.0938,15.1677,-2.83313);
	level.cameraOffset["camera_sky"] = (8.20996,47.8018,-24.6787);
	level.cameraOffset["camera_plane_chase"] = (0.358887,-56.457,-36.8644);
	level.cameraOffset["camera_plane_chase_blend"] = (-0.182129,8.47754,-0.602173);
	level.cameraOffset["camera_plane_dive"] = (0,0,0);
	level.cameraOffset["camera_plane_spin"] = (0,0,0);
	level.cameraOffset["camera_car_side"] = (34.1675,-17.2715,-13.8019);
	level.cameraOffset["camera_ending_arrival"] = (0,0,0);
	level.cameraOffset["camera_ending_smoke"] = (0,0,0);
	level.cameraOffset["camera_ending_explosion"] = (-11.0674,-1.36475,-1.04541);
	level.cameraOffset["camera_ending_explosion_blend"] = (7.82324,5.2395,6.4176);
	level.cameraOffset["camera_ending_explosion_blend"] = (7.82324,5.2395,6.4176);
	level.cameraOffset["camera_ending_explosion_blend2"] = (-2.50293,0,-0.053833);
	level.cameraOffset["camera_ending_explosion_blend2"] = (-2.89307,0,0.621094);
	level.cameraOffset["camera1_blend"] = (-0.359375,6.20264,-0.32251);
	level.cameraOffset["camera_jeep_pulls_up"] = (1.53223,1.57715,-0.0402832);
	level.cameraOffset["camera_sneaky_guy"] = (-3.29541,-5.88257,-0.380005);
	level.cameraOffset["camera_forest"] = (-1.21387,-9.9519,-0.843506);
	level.cameraOffset["camera_smoke_escape2"] = (-8.12953,-1.70923,-0.577881);

	level.cameraBlendNum = 0;
	
	level.playerShield = getent ("player_shield","targetname");
	level.explosionhide = true; // for mortarteams
//	level.check = true;
	thread unlinkcheck();
	
	level.globalTimer = 12;
	maps\_jeep::main("xmodel/vehicle_american_jeep");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_woodland");
	maps\_truck::main("xmodel/vehicle_opel_blitz_woodland");
	maps\_armoredcar::main("xmodel/vehicle_german_armored_car");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_stuka::main("xmodel/vehicle_stuka_flying");


	maps\credits_fx::main();
	level.mortar = loadfx ("fx/explosions/artilleryExp_dirt_brown.efx");
	maps\_load::main();
	maps\_mortarTeam::main();
	maps\credits_anim::main();

	array_thread (getentarray("delete","targetname"), ::deleter);
	array_thread(getentarray("ending_model","targetname"), ::hideModel);
	thread aiOverrides();

	anim.maymoveCheckEnabled = false; // so the corner guys pop out regardless of where player-camera is
		
	level observation_ladder_ladderAnim("fall");
	thread battleChatterOff( "allies" );
	thread battleChatterOff( "axis" );

	level.player.ignoreme = true;
	maps\credits_strings::precacheCredits();
	precacheString( &"CREDIT_NO_COWS");

	level.player.health = 1000;
	level.flag["tank arrived"] = false;	
	level.flag["credits done"] = false;	
	level.flag["ready to end"] = false;	
	level.flag["move_center"] = false;	

	flag_init ("ladder_gather");
	flag_init ("ladder_up");
	flag_init ("spit");
	flag_init ("camera_change");
	flag_init ("price_pulls_gunner");	
	flag_init ("ender_enters_car");
	flag_init ("movie_credits_complete");
	
	flag_clear("price_rescued");
	flag_clear("car_escape");
	flag_clear("emerge_from_smoke");
	
	level.totalCredits = 0;	
	level.won = false;
	level.player takeallweapons();
//	precachemodel("xmodel/vehicle_tank_panzeriv_machinegun");
//	precachemodel("xmodel/character_soviet_overcoat");



/*
	setCullFog(2500, 2900 , 0.0, 0.0, 0.0, 0);
	if (getcvar ("start") == "start")
		setCullFog(500, 900 , 0.0, 0.0, 0.0, 0);
*/
	thread maps\credits_strings::text();	
	ender = getent ("ender","targetname");
	ender.bcname = level.credits_name["ender"];
	ender.name = undefined;
	ender.health = 50000;
	ender.ignoreme = true;
	level.ender = ender;
	thread music();
	thread endLevel();

	if (getcvar ("start") == "" || getcvar ("start") == "start")
		level.player freezeControls(true);

	if (!level.check)
	{
		flag_set ("movie_credits_complete");
		return;
	}
	level thread maps\credits_amb::main();	
	thread storyBegins(ender);
		

	thread cameraSystem();
	thread barnDoorAnim();
	
	trigger = getent ("melee_trigger","targetname");
	trigger waittill ("trigger");
	thread melee_scene();
}

activateCamera(camera, moveTarget, delay, timer, blendIn, blendOut)
{
	/#
	if (getcvar("debug_unlink") == "on")
		return;
	#/

	if (isdefined (self.script_delay))
		wait (self.script_delay);

	if (isdefined(self.script_noteworthy))
	{
		if (self.script_noteworthy == "timescale_delayed")
			thread delayedTimescale(self.script_timescale);
	}
	else
	if (isdefined(self.script_timescale))
	{
		if (level.timescaleEnabled)
			setsavedcvar("timescale", "" + self.script_timescale);
	}

	offsetGen = false;
	if (isdefined(level.cameraOffset[camera.targetname]))
		offset = level.cameraOffset[camera.targetname];
	else
	{
		offset = (0,0,0);
		offsetGen = true;
	}
	
	targ = getent (camera.target, "targetname");
	angles = vectortoangles(targ.origin - camera.origin);

	model = spawn ("script_model",(0,0,0));
	level.camera_model = model;
	model.angles = angles;
	model setmodel ("xmodel/tag_origin");
	model.origin = camera.origin + (0,0,-60) - offset;
	level.model = model;
	
	level.playerShield linkto (model, "tag_origin", (0,0,0), (0,0,0));
	level.player playerlinktoabsolute (model, "tag_origin");
	level.player dontInterpolate();
	thread cameraOffsetPrint(camera, offsetGen);
	
	if (!isdefined (moveTarget))
		return;

	wait (delay);
	offsetGen = false;
	if (isdefined(level.cameraOffset[moveTarget.targetname]))
		offset = level.cameraOffset[moveTarget.targetname];
	else
	{
		offset = (0,0,0);
		offsetGen = true;
	}

	if (!isdefined(blendIn))
		blendIn = 0.2;
	if (!isdefined(blendOut))
		blendOut = 0.2;
		
	targ = getent (moveTarget.target, "targetname");
	angles = vectortoangles(targ.origin - moveTarget.origin);
	model moveto (moveTarget.origin + (0,0,-60) - offset, timer, timer * blendIn, timer * blendOut);
	model rotateto (angles, timer, timer * blendIn, timer * blendOut);
	thread cameraOffsetPrint(moveTarget, offsetGen, timer);
}

movetoCamera(moveTarget, delay, timer, blendIn, blendOut)
{
	/#
	if (getcvar("debug_unlink") == "on")
		return;
	#/

	offsetGen = false;
	if (isdefined(level.cameraOffset[moveTarget.targetname]))
		offset = level.cameraOffset[moveTarget.targetname];
	else
	{
		offset = (0,0,0);
		offsetGen = true;
	}
	
	wait (delay);

	targ = getent (moveTarget.target, "targetname");
	angles = vectortoangles(targ.origin - moveTarget.origin);
	level.camera_model moveto (moveTarget.origin + (0,0,-60) - offset, timer, timer * blendIn, timer * blendOut);
	level.camera_model rotateto (angles, timer, timer * blendIn, timer * blendOut);
	thread cameraOffsetPrint(moveTarget, offsetGen);
}

cameraOffsetPrint(camera, offsetGen, timer)
{
	if (isdefined (timer))
		wait timer;
		
	wait (0.2);
	if (!offsetGen)
		return;
	
	offset = level.player.origin - (camera.origin + (0,0,-60));
	if (offset[1] < 1 && offset[1] > -1)
		offset = (offset[0], 0, offset[2]);
		
	level.cameraOffsetPrint[level.cameraOffsetPrint.size] = "	level.cameraOffset[\"" + camera.targetname + "\"] = (" + offset[0] + "," + offset[1] + "," + offset[2] + ");";
}

/*
activateCamera(camera)
{
	/#
	if (getcvar("debug_unlink") == "on")
		return;
	#/

	if (isdefined (self.script_delay))
		wait (self.script_delay);

	if (isdefined(self.script_noteworthy))
	{
		if (self.script_noteworthy == "timescale_delayed")
			thread delayedTimescale(self.script_timescale);
	}
	else
	if (isdefined(self.script_timescale))
	{
		if (level.timescaleEnabled)
			setsavedcvar("timescale", "" + self.script_timescale);
	}
	
	targ = getent (camera.target, "targetname");
	angles = vectortoangles(targ.origin - camera.origin);
	forward = anglestoforward(angles);

	model = spawn ("script_model",(0,0,0));
	model.angles = angles;
	model setmodel ("xmodel/tag_origin");
	scaler = -83;	
//	model.origin = camera.origin + (0,0,-60);
	scale = vectorscale(forward, scaler);
	model.origin = camera.origin + scale + (0,0,-44);
	level.player playerlinktoabsolute (model, "tag_origin");
	level.player dontInterpolate();
	for (;;)
	{
		scale = vectorscale(forward, scaler);
		model.origin = camera.origin + scale + (0,0,-44);
		println ("scaler " + scaler + " origin " + level.player geteye());
		scaler++;
		wait (0.05);
	}
}

*/

cameraSystem()
{
//		if (1) return;
	activateCamera (getent ("camera1","script_noteworthy"));
	array_thread (getentarray ("camera_trigger","targetname"), ::cameraThink);
	array_thread (getentarray ("camera_blend_trigger","targetname"), ::cameraBlendThink);
	array_thread (getentarray ("camera_free_trigger","targetname"), ::cameraFreeThink);
	if (level.timescaleEnabled)
		array_thread (getentarray ("timescale_trigger","targetname"), ::timescaleThink);

}

timescaleThink()
{
	self waittill ("trigger");
	setsavedcvar("timescale", "" + self.script_timescale);
}

delayedTimescale(timescale)
{
//	wait (0.2);	
	if (!level.timescaleEnabled)
		return;
		
	setsavedcvar("timescale", "" + timescale);
}

deleter()
{
	self delete();
}


camera360 (camera, org)
{
	/#
	if (getcvar("debug_unlink") == "on")
		return;
	#/

	targ = getent (camera.target, "targetname");
	angles = vectortoangles(targ.origin - camera.origin);
	forward = anglestoforward(angles);
	scale = vectorscale(forward, -20);
	model = spawn ("script_model",(0,0,0));
	model.origin = camera.origin + scale + (0,0,-60);
	model setmodel ("xmodel/tag_origin");
	model.angles = angles;
	level.player playerlinktoabsolute (model, "tag_origin", (1,1,1));
	level.player dontInterpolate();
	ent = spawn("script_origin",(0,0,0));
	ent.origin = (org[0], org[1], model.origin[2]);
	model linkto (ent);
	ent rotateyaw(360, 0.3, 0.1, 0.1);
	wait (0.3);
}

cameraBlendThink()
{
	for (;;)
	{
		self waittill ("trigger",other);
		if (other == level.ender)
			break;
	}
	
	cam1_start = spawn ("script_origin",(0,0,0));
	cam1_end = spawn ("script_origin",(0,0,0));
	cam2_start = spawn ("script_origin",(0,0,0));
	cam2_end = spawn ("script_origin",(0,0,0));
	
	level.cameraBlendNum = 0;
	ent1 = getent (self.target,"targetname");
	cam1_start.origin = ent1.origin;
	cam1_start.target = ent1.target + "blend";
	cam1_start.targetname = ent1.targetname + "blend";
	
	targets = getentarray(ent1.target,"targetname");
	assert (targets.size == 2);
	for (i=0;i<targets.size;i++)
	{
		if (isdefined(targets[i].target))
		{
			// has a target so its the 2nd camera
			cam2_start.origin = targets[i].origin;
			cam2_start.target = targets[i].target + "blend";
			cam2_start.targetname = targets[i].targetname + "blendEnd";

			cam2_end.origin = getent(targets[i].target,"targetname").origin;
			cam2_end.targetname = targets[i].target + "blend";
			continue;
		}
		
		cam1_end.origin = targets[i].origin;
		cam1_end.targetname = ent1.target + "blend";
	}

	delay = 0;	// 0.5;
	if (isdefined (self.script_delay))
		delay = self.script_delay;

	blendTime = 3.4;
	if (isdefined (self.script_wait))
		blendTime = self.script_wait;
	
	activateCamera(cam1_start, cam2_start, delay, blendTime);
}

cameraThink()
{
	for (;;)
	{
		self waittill ("trigger",other);
		if (other == level.ender)
			break;
	}
	
	activateCamera(getent(self.target,"targetname"));	
}

cameraFreeThink()
{
	self waittill ("trigger",other);
	activateCamera(getent(self.target,"targetname"));	
}

globalTimer()
{
	wait (40);
	while (level.globalTimer > 6)
	{
		level.globalTimer-= 0.05;
		wait (0.2);
	}
}

setDestHeight()
{
	level endon ("stop set dest height");
	while (1)
	{
		level.destinationHeight	= level.ender.origin[2];
		wait (0.05);		
	}
}

jeepTrigger()
{
	self waittill ("trigger");
	wait (3);
	trigger = getent (self.target,"targetname");
	trigger notify ("trigger");
}


enderChainOfNodes()
{
	node = getnode(self.target,"targetname");
	self setgoalnode(node);
	self.pacifist = true;
	for (;;)
	{
		self waittill ("goal");
		if (!isdefined(node.target))
			break;
		node = getnode(node.target,"targetname");
		self setgoalnode(node);
	}
	self notify ("chain_end");
}

pathChainOfNodes()
{
	node = getnode (self.target,"targetname");
	self.goalradius = 8;
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.pacifist = true;
	for (;;)
	{
		self setgoalnode(node);
		self.goalradius = node.radius;
		self waittill ("goal");
		if (isdefined(node.script_noteworthy))
		{
//			if (node.script_noteworthy == "forest_pause")
//				flag_wait ("ladder_gather");
			if (node.script_noteworthy == "ladder_gather")
			{
				flag_wait ("ladder_up");
				wait (randomfloat(1.4));
			}
		}
		
//		if (isdefined(node.script_delay))
//			wait (node.script_delay);
		if (!isdefined(node.target))
			break;
		node = getnode(node.target,"targetname");
	}

	// so they dont bunch up jumping over
	if (!isdefined(level.town_queue))
		level.town_queue = -1;
	level.town_queue++;
	wait (level.town_queue * 2.4);
			
	node = getnode("town_node","targetname");
	self.goalradius = node.radius;
	self setgoalnode(node);
}

getVehicleParkNode(node)
{
	nodes = getnodearray(node.target,"targetname");
	node = undefined;
	for (i=0;i<nodes.size;i++)
	{
		if (nodes[i].parkUsed)
			continue;
	 	node = nodes[i];
	 	break;
	}
	
	while (!isdefined(node))
	{
		level waittill ("node_free", freename);
		nodes = getnodearray(freename,"targetname");
		for (i=0;i<nodes.size;i++)
		{
			if (nodes[i].parkUsed)
				continue;
		 	node = nodes[i];
		 	break;
		}
	}

	return node;		
}


groundEffects(delay, iterations)
{
	array = getentarray("plane_effect_gen","targetname");
	for (i=0;i<array.size;i++)
		array[i] thread groundEffectsGen(delay, iterations);
}

groundEffectsGen( delay, iterations)
{
	wait (delay);
	start = self.origin;
	end = getent(self.target,"targetname").origin;
	

	dif = (end - start);
	dif = vectorscale(dif, 1.0/iterations);

	current = start;
	for (i=0;i<iterations;i++)
	{
		playfx(level._effect["gravel"], current);
		thread playsoundinspace("bullet_large_gravel", current);

		current += dif;
		wait (0.05);
	}
}

/*
	wait (2.7);
	wait (0.3);
	playfxontag(level._effect["tank_explosion"], armoredCar, "tag_origin");
	wait (0.3);
	thread planeFliesOnPath(getvehiclenode("plane_spin","targetname"));
	wait (1.3);

*/

groundExplodesAroundCar(tiger)
{
	wait (1.2);
	exploder(30);
	level.armoredCar playsound ("jeep_skid");
	wait (2.35);
	exploder(31);
	level.armoredCar playsound ("jeep_skid");
	
	wait (3.5);
	tiger fireTurret();
}

bunkerGuys()
{
	spawn = self dospawn();
	spawn endon ("death");
	wait (35 + randomfloat(5));
	spawn delete();
}

skipTrigger()
{
	if (getcvar ("start") != self.script_noteworthy)
		return;
		
	self waittill ("trigger");
	spawners = getentarray(self.target,"targetname");
	for (i=0;i<spawners.size;i++)
	{
		spawners[i].count = 1;
		spawn = spawners[i] dospawn();
		spawn_failed(spawn);
		spawn thread pathChainOfNodes();
	}	
}

targetPractice(armoredCar)
{
	spawn = self stalingradspawn();
	spawn_failed(spawn);
	spawn endon ("death");
	spawn.goalradius = 64;
	spawn.baseaccuracy = 0;
	spawn.health = 5000;
	spawn.threatbias = 2343;
	spawn linkto (armoredCar);
	level waittill ("delete_practice");
	spawn delete();
}

getawaySpawner()
{
	spawn = self stalingradspawn();
	node = getnode(self.target,"targetname");
	spawn_failed(spawn);
	spawn setgoalnode (node);
	spawn.goalradius = 64;
	spawn.baseaccuracy = 0;
	spawn.ignoreme = true;
}

nodeChain(node)
{
	self setgoalnode(node);
	self waittill ("goal");
	node = getnode (node.target,"targetname");
	self setgoalnode(node);
}

priceCar(price)
{
	anim_reach_solo( price, "getin", "tag_driver");
	thread anim_single_solo( price, "getin", "tag_driver");
	wait (1);
	thread playsoundinspace ("tank_hatch", price.origin);
	price waittillmatch ("single anim", "end");
	price delete();
}

enderCar(ender)
{
	anim_reach_solo( ender, "getin", "tag_passenger");
	thread playsoundinspace("credits_carclimb"); // carclimb");
	anim_single_solo( ender, "getin", "tag_passenger");
	thread anim_single_solo( ender, "getinEnd", "tag_driver");
	wait (1);
	thread playsoundinspace ("tank_hatch", ender.origin);
	ender waittillmatch ("single anim", "end");
	flag_set("ender_enters_car");
	ender delete();
}

priceGrabsGunner(price)
{
	flag_set("price_pulls_gunner");
}

gunnerCar(gunner)
{
	flag_wait("price_pulls_gunner");
	self notify ("stop_idle_loop");
	anim_single_solo( gunner, "grab", "tag_gunner");
	anim_loop_solo( gunner, "deathPose", "tag_gunner", "stop_idle_loop");
}

ambientBullet()
{
	level endon ("stop_ambient_shooting");
	target = getent(self.target,"targetname");
	angles = vectortoangles (target.origin - self.origin);
	forward = anglestoforward(angles);
	past = vectorscale(forward, 1400); // move in front of friendlies
	dest = self.origin + past;
	
	for (;;)
	{
		wait (randomfloat(1.5));
		for (i=0;i<3;i++)
		{
			magicbullet ( "mp44", self.origin, self.origin + (0,0,150));
			bullettracer ( self.origin, dest );
			wait (0.2 + randomfloat (0.15));
		}
	}
}

setFightSettings()
{
	spawn_failed(self);
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.goalradius = 16;
	self.interval = 0;
	self.ignoreme = true;
	self.baseaccuracy = 100;
	self notify ("stop magic bullet shield");
	waittillframeend; // otherwise the notify is acted upon after the new thread starts and the 150 health overwrites the high health
	self thread magic_bullet_shield();
	self.anim_disablePain = true;
}

chaseSpawner()
{
	level.chaser = self stalingradspawn();
}

nodeShoot(enemy, weapon)
{
//	enemy endon ("death");
	dest = enemy gettagorigin ("tag_eye");
	angles = vectortoangles (enemy.origin - self.origin);
	forward = anglestoforward(angles);
//	forward = (0,forward[1],0);
	scale = vectorscale(forward, 80); // move in front of friendlies
	past = vectorscale(forward, 1400); // move in front of friendlies
	org = self.origin + scale + (0,0,45);
	org2 = self.origin + past + (0,0,45);
	
	if (!isdefined(level.bqueue))
		level.bqueue = -1;
	level.bqueue++;
	
	wait (level.bqueue*0.10);
	wait (randomfloat(level.bqueue*0.10));

	if (isalive(enemy))
		dest = enemy gettagorigin ("tag_eye");
	magicbullet ( weapon, org, dest);
	bullettracer ( org, org2);
	if (1) return;
	for (i=0;i<343;i++)
	{
		line ( org, dest, (1,0,1), 1);
		line (org, org2, (0,1,1), 1);
		wait (0.05);
	}
}

setgoalchain(node)
{
	self.goalradius = 8;
	self.pathenemylookahead = 0;
	self.pathenemyfightdist = 0;
	self.interval = 0;
	
	for (;;)
	{
		node = getnode(node.target,"targetname");
		self setgoalnode(node);
		self waittill ("goal");
		if (isdefined(node.script_noteworthy))
			GatherDelay(node.script_noteworthy, 2);
		flag_wait ("camera_change");
		if (!isdefined(node.target))
			break;
	}

/*
	node = getnode("destination_node","targetname");
	self setgoalnode(node);
	self.goalradius = 128;
	self waittill ("goal");
*/	

}

plane_quake()
{
	self endon ("death");
	while (1)
	{
		earthquake(0.35, 0.5, self.origin, 1450); // scale duration source radius
		wait (0.05);
	}
}

planeControlsCameraAndShoots(path)
{
	plane = spawnPlane();
	plane thread flyPath(path);
	plane playsound ("plane_flyby_stuka1");
	wait 0.05; 
	plane Hide();
	model = spawn("script_model",(0,0,0));
	model setmodel("xmodel/tag_origin");
	model linkto(plane, "tag_prop", (0,0,0), (18,0,0));
//	level.player playerlinktoabsolute (plane, "tag_prop");
	level.player playerlinktoabsolute (model, "tag_origin");
	wait (2);
	plane thread planeShoot();
}

planeFliesOnPathAndShoots(path, shootDelay)
{
	plane = spawnPlane();
	plane thread flyPath(path);
	plane playsound ("plane_flyby_stuka2");
	if (!isdefined(shootDelay))
		shootDelay = 0;
	wait (shootDelay);
	plane thread planeShoot();
}

planeFliesOnPathDelayed(path, delay)
{
	wait (delay);
	plane = spawnPlane();
	plane thread flyPath(path);
	plane playsound ("plane_flyby_stuka3");
}

planeFliesOnPath(path)
{
	plane = spawnPlane();
	plane thread flyPath(path);
	plane playsound ("plane_flyby_stuka1");
}

flyPath(path)
{
	self attachPath( path );
//	plane playsound ("plane_flyby_stuka" + level.demo_plane_sound);
	self startPath();
	self waittill ("reached_end_node");
	self delete();
}

spawnPlane()
{
	return spawnVehicle( "xmodel/vehicle_stuka_flying", "plane", "Stuka", (0,0,0), (0,0,0) );
}

planeShoot()
{
	self endon ("death");
	level endon ("stop_plane_shoot_sound");
	thread planeShootSound();
	for (;;)
	{
		if (randomint (100) < 50)
			tagFiresMg42("tag_gunLeft");
		if (randomint (100) < 50)
			tagFiresMg42("tag_gunRight");
		wait (0.01);
	}
}

planeShootSound()
{
	self endon ("death");
	self thread playloopsoundonentity ("stuka_guns");
	level waittill ("stop_plane_shoot_sound");
	self notify ("stop sound" + "stuka_guns");
}

tagFiresMg42(tag)
{
	playfxOnTag(level._effect["mg42"], self, tag);
//	playsoundontag("weap_mg42_loop", tag);
	/*
	org = self gettagorigin(tag);
	angles = self gettagangles(tag);
	forward = anglestoforward(angles);
	scale = vectorscale(forward, 1000);
	magicbullet ( "mp40", org, org + scale );
	*/
}

smokeThrow(guy)
{
	guy.grenadeWeapon = "smoke_grenade_american";
//	guy.grenadeAmmo++;
	org = getent (guy.animname, "targetname");
	guy MagicGrenade (guy gettagOrigin("tag_weapon_right"), org.origin, 2 + randomfloat(0.5));
//	guy.grenadeWeapon = guy.oldGrenadeWeapon;
}

mortarExplosion()
{
//	playSoundinSpace("mortar_incoming1", target.origin);
	playSoundinSpace("mortar_incoming2", self.origin);
//	playSoundinSpace("mortar_incoming3", target.origin);
//	playSoundinSpace("mortar_incoming1", target.origin);
	wait 0.35;
	
	thread playSoundinSpace("mortar_explosion", self.origin);
	playfx(level.mortar, self.origin);
}

ai_kickdoor_fx()
{
	self endon("death");
	level endon("stop_guy_fx_on_doorbreach");
	n = 1;
	
	tag[0] = "j_neck";
	tag[1] = "j_shoulder_le";
	tag[2] = "j_shoulder_ri";
	tag[3] = "j_spine4";
	
	self waittill ("single anim", notetrack);
	
	while(1)
	{
		self waittill ("single anim", notetrack);
		if (notetrack != "notetrack_fx")
			continue;
		
		playfxOnTag ( level._effect["flesh_hit"] , self, random(tag) );
		
		n++;
		if(n == 6)
		{
			while(1)
			{
				self waittill ("single anim", notetrack);
				if (notetrack == "notetrack_fx")
				{
					playfxOnTag ( level._effect["flesh_hit"] , self, random(tag) );
					playfxOnTag ( level._effect["flesh_hit"] , self, random(tag) );
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
//	level.scr_anim["bs1"]["death_loop"][0] = level.scr_anim["bs1"]["death"];
//	node anim_loop_solo(self, "death_loop");
	self dodamage(self.health - 1, (0,0,0));
}


axisDoorKickSpawner()
{
	self waittill ("spawned", spawn);
	spawn_failed(spawn);
	waittillframeend; // to get past vehicle script
	spawn.anim_forced_cover = "hide";
	spawn.health = 50000;
	level.axisDoorKicker = spawn;
	spawn waittill ("unload");
	spawn.health = 50000;
}

kilLSelfTrigger()
{
	// failsafe so the german dies
	self endon ("death");
	trigger = getent ("house_kill_trigger", "script_noteworthy");
	trigger waittill ("trigger");
	self dodamage(self.health, (0,0,0));
}

gunThink()
{
	org = level.surrenderGuy.origin;
	while (isalive (level.surrenderGuy))
	{
		magicbullet ( "mp40", self.origin, org + (0,0,16 + randomfloat(32)) + randomvector(10));
		wait (0.1);
	}
}

spotlight()
{
	targ = getent(self.target,"targetname");
	model = spawn ("script_model",(0,0,0));
	model.origin = self.origin;
	model setmodel ("xmodel/tag_origin");
	playfxontag ( level._effect["spotlight"], model, "tag_origin");
//	model thread playsoundinspace("minefield_click"); // didnt work well 
	model thread rotateSpotlight(self, targ);
	
	while (isalive(level.surrenderGuy))
	{
		targ moveto (level.surrenderGuy.origin + (0,0,50), 0.2);
		wait (0.1);
	}
}
	
rotateSpotlight(start, end)
{
	level.surrenderGuy endon ("death");
	for (;;)
	{
		angles = vectortoangles(end.origin - start.origin);
		self rotateto(angles, 0.2);
		wait (0.1);
	}
}

#using_animtree("generic_human");
endLevel ()
{
	flag_wait ("movie_credits_complete");
	wait (7);
	flag_set ("move_center");
	flag_wait ("credits done");
	wait (0.5);

	if (level.won)
	{
		newStr = newHudElem();
				offsetter = 0;
	
		newStr setText(&"CREDIT_NO_COWS");
		newStr.alignX = "center";
		newStr.horzAlign = "center";
		newStr.vertAlign = "middle";
		newStr.alignY = "middle";
		newStr.location = 0;
		newStr.foreground = 1;
		newStr.fontScale = 1.30;
		newStr.sort = 20;
		newStr.alpha = 0;
		newStr fadeOverTime (1.5);
		newStr.alpha = 1;
		wait (3.5);
		newStr fadeOverTime (1.5);
		newStr.alpha = 0;
		wait (3);
	}

	setCvar("ui_victoryquote", "@VICTORYQUOTE_THOSE_WHO_HAVE_LONG_ENJOYED");
	setsavedcvar("ui_nextmission","3");
	missionSuccess("training", false);
}

 
skip ()
{
	setcvar ("skip", "");
	while (1)
	{
		if (getcvar ("skip") != "")
		{
			org = spawn ("script_origin",(0,0,0));
			org.origin = level.ender.origin;
			level.ender linkto (org);
			org moveto (level.enderNode.origin + (0,0,70), 0.1);
			wait (0.1);
			level.skip = true;
			level.ender notify ("skip");
			org delete();
		}
		setcvar ("skip", "");
		wait (0.1);
	}
}

timer ()
{
	seconds = 0;
	minutes = 0;
	while (1)
	{
		wait (1);
		seconds++;
		if (seconds >= 60)
		{
			minutes++;
			seconds-=60;
		}
		if (seconds < 10)
			println (minutes,":0",seconds);
		else
			println (minutes,":",seconds);
	}
}

music ()
{
	if (level.check) // game completed, real credits
	{
		musicPlay("credits_music_suspense");
		//wait 103;
		flag_wait("price_rescued");
		musicStop(1);
		wait 1.1;
		musicPlay("credits_music_fighting");
		//wait 183;
		flag_wait("car_escape");
		musicStop(1);
		wait 2;
		musicPlay("credits_music_escaping");
		//wait 48;
		flag_wait("emerge_from_smoke");
		musicStop(1);
		wait 1.1;
		musicPlay("credits_music_victory");
	}
	else
	{
		for (;;)
		{
			/*
			musicPlay("credits_plain_music_rhinelastwords");
			wait 123;
			musicstop(1);
			wait 1.1;
			*/
			
			musicPlay("credits_plain_music_88ridge");
			wait 183;
			musicstop(1);
			wait 1.1;
			
			musicPlay("credits_plain_music_trainyard");	
			wait 153;
			musicstop(1);
			wait 1.1;
			
			musicPlay("credits_plain_music_duhocassaultend");
			wait 128;
			musicstop(1);
			wait 1.1;
			
			/*
			musicPlay("credits_plain_music_comradesniper");
			wait 180;
			musicstop(1);
			wait 1.1;
			
			musicPlay("credits_plain_music_holdline");
			wait 31;
			musicstop(1);
			wait 1.1;
			
			musicPlay("credits_plain_music_charge");
			wait 122;
			musicstop(1);
			wait 1.1;
			
			musicPlay("credits_plain_music_sovietvictory");	
			wait 37;
			musicstop(1);
			wait 1.1;
			
			musicPlay("credits_plain_music_88ridgevictory");
			wait 50;
			musicstop(1);
			wait 1.1;
			*/
		}
	}
}

checkLev()
{
	if (getcvar("debug_credits") == "")
		setcvar("debug_credits", "off");
	else
	if (getcvar("debug_credits") == "on")
	{
		level.check = true;
		return;
	}
	
	//if (getcvar("beat_the_game") == "I_sure_did")
	
	level.check = false;
	if (getcvarint("mis_01") < 10)
		return;
	if (getcvarint("mis_02") < 10)
		return;
	if (getcvarint("mis_03") < 10)
		return;
	if (getcvarint("mis_04") < 10)
		return;
	if (getcvarint("mis_05") < 10)
		return;
	if (getcvarint("mis_06") < 10)
		return;
	if (getcvarint("mis_07") < 10)
		return;
	if (getcvarint("mis_08") < 10)
		return;
	if (getcvarint("mis_09") < 10)
		return;
	if (getcvarint("mis_10") < 10)
		return;
	
	level.check = true;
}

unlinkcheck()
{
	/#
	if (getcvar("debug_unlink") == "")
		setcvar("debug_unlink", "");
	for (;;)
	{
		if (getcvar("debug_unlink") == "on")
		{
			level.player unlink();
			wait (1);
		}
		wait (0.05);
	}
	#/
}

raise_ladder()
{
	animNode = getnode ("ladder_node_guy2","targetname");
	addNotetrack_customFunction("soldier", "lift", ::liftLadder, "setupladder");
	
	self.animname = "soldier";
	self.laddersetup = true;
	anim_reach_solo (self, "setupladder", undefined, animNode);
	level notify ("starting_ladder_anim");
	anim_single_solo (self, "setupladder", undefined, animNode);
	level notify ("ladder_up");
}

liftLadder(guy)
{
	level thread observation_ladder_ladderAnim("setup");
}

#using_animtree("toujane_ladder");
observation_ladder_ladderAnim(animName)
{
	ladder = getent("ladder","targetname");
	ladder UseAnimTree(#animtree);
	
	if (animName == "fall")
		ladder setflaggedanim ("ladder", %toujane_ladder_fall);
	else if (animName == "setup")
	{
		ladder playsound("raise_ladder");
		ladder setflaggedanimknob ("ladder", %toujane_ladder_setup);
		ladder waittillmatch ("ladder", "end");
	}
}

melee_scene()
{
	chair = getent("prison_chair","targetname");
	guard = getent("prison_guard","targetname") stalingradspawn();
	price = getent("price","targetname") stalingradspawn();
	price.bcname = level.credits_name["price"];

	level.price = price;
	level.chair = chair;
	level.guard = guard;
	
	spawn_failed(guard);
	spawn_failed(price);
	
	guard.ignoreme = true;
	price.ignoreme = true;
	guard.pacifist = true;
	price.pacifist = true;
	
	price.animname = "price";
	guard.animname = "guard";

	guys[0] = price;
	guys[1] = guard;

	for (;;)
	{
		guard endon ("death");
		if (flag ("spit"))
		{
			flag_clear ("spit");
			level notify ("startSpit");
			chair melee_anim (guys, "spit");
		}
		else
			chair melee_anim (guys, "double");
			
//		wait (randomfloat(1));
	}
}

melee_anim (guys, anime)
{
	self notify ("stopIdle");
	guys[1] endon ("death");
	thread anim_single (guys, anime);
	array_thread(guys, ::loopStarter, self);
	self waittill (anime);
}

loopStarter(chair)
{
	chair endon ("stopIdle");
	self waittillmatch ("single anim","end");
	chair anim_loop_solo(self, "idle", undefined, "stopIdle");
}

delayedFunction (func, delay, arg1, arg2)
{
	wait (delay);
	if (isdefined(arg2))
		[[func]](arg1, arg2);
	else
	if (isdefined(arg1))
		[[func]](arg1);
	else
		[[func]]();
}

crouchTrigger()
{
	self waittill ("trigger");
	level.ender allowedstances("crouch");
	level.price allowedstances("crouch");
	wait (7);
	level.ender allowedstances("crouch", "stand");
	level.price allowedstances("crouch", "stand");
}

#using_animtree("barndoor");
barnDoorAnim()
{
	level.scr_anim["barn_door"]["barndoor"]			= (%breakout_barngate_open_door);
	animNode = getent("doorkick_goal","targetname");
	door = getent("barn_door_model","targetname");
	door setmodel ("xmodel/door_barn_credit");
	door.animname = "barn_door";
	door useanimtree (#animtree);
	door.origin = getStartOrigin(animNode.origin, animNode.angles, level.scr_anim[door.animName]["barndoor"]);
	door.angles = getStartAngles(animNode.origin, animNode.angles, level.scr_anim[door.animName]["barndoor"]);
//	door hide();


	doorscript = getent("left_door","targetname");
//	doorscript hide();
//	door.origin = doorscript.origin;
//	door.angles = animNode.angles;
	doorscript linkto (door, "tag_barndoor", (0,3,0),(0,-90,0));
//	doorscipt setshadowhint("normal");
}

mgSetupThread()
{
	self waittill ("goal");
	wait (0.05);
	self.mg42 setmode("manual_ai");
	level waittill ("mg_fire");
	org = spawn("script_origin",(0,0,0));
	org.origin = level.axisDoorKicker.origin + (0,0,38);
	self.mg42 settargetentity(org);
	self.mg42 startfiring();
	wait (6);
	self.mg42 stopfiring();
}

getVolumeEnt(array, volume)
{
	for (i=0;i<array.size;i++)
	{
		if (array[i] istouching (volume))
			return array[i];
	}
	return undefined;
}


mortarSpawnerThink()
{
	self waittill ("spawned", spawn);
	spawn_failed(spawn);
	waittillframeend; // overwrite spawn settings
	spawn defaultSettings();
	for (;;)
	{
		spawn waittill ("set_health");
		spawn.health = 9000;
	}
}

halftrackRider()
{
	self waittill ("spawned", spawn);
	spawn_failed(spawn);
	waittillframeend; // in case of vehicle scripts
	spawn defaultSettings();
	spawn waittill ("unload");
	waittillframeend;
	spawn defaultSettings();
	spawn stopuseturret();
}

defaultSettings()
{
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.baseAccuracy = 0;
	self.health = 9000;
	self.suppressionwait = 0;
	self.anim_forced_cover = "show";
}

changeWeaponToLuger()
{
	wait (1.9);
	self.weapon = "luger";
	self PutGunInHand("right");
	self.allowDeath = true;
}

stopMortar()
{
	self notify ("stop_mortar");
	self.node notify ("stopIdle");
	self.aimGuy notify ("stop_mortar");
	self.loadGuy notify ("stop_mortar");
	self.aimGuy stopanimscripted();
	self.loadGuy stopanimscripted();
	self.aimGuy putguninhand("right");
	self.loadGuy putguninhand("right");
}

aimAtTargets()
{
//	targets = getentarray("turret_target","targetname");
	/*
	wait (2);
	turret = self getturret();
	level.mg42Targets = [];
	for (;;)
	{
		target = random(level.mg42Targets);
		turret settargetentity (target);
		wait (0.5 + randomfloat (1));
	}	
	turret notify ("stopfiring");
	turret stopFiring();
	turret thread stopfire();	
	for (;;)
	{
		target = random(targets);
		turret settargetentity (target);
		wait (0.5 + randomfloat (1));
	}
	*/
}

stopFire()
{
	for (;;)
	{
		self stopfiring();
		wait (0.05);
	}
}


storyBegins(ender)
{
	spawn_failed(ender);

	getent ("jeep_trigger","targetname") thread jeepTrigger();
	ender setgoalpos (ender.origin);
	ender.animplaybackrate = 1;
	wait (1);
	
	node = getnode (ender.target,"targetname");
	ender.goalradius = 8;
	ender.pathenemyfightdist = 0;
	ender.pathenemylookahead = 0;

	if (getcvar ("start") == "end")
	{
		escapeSequence();
		return;
	}
	
	if (getcvar ("start") == "plane")
	{
		flag_set("price_rescued");
		flag_set("car_escape");
		
		endDrive();
		return;		
	}


	if (getcvar ("start") == "ladder")
	{
		array_thread (getentarray("skip_trigger","targetname"), ::skipTrigger);
		node = getnode ("ladder","script_noteworthy");
		ender teleport (node.origin);

		enemyspawner = getent("pacifist_spawner","targetname");
		spawn = enemyspawner stalingradspawn();
		spawn_failed(spawn);
		spawn.pacifist = true;
		spawn thread aimAtTargets();


		ai = getaiarray("allies");
		for (i=0;i<ai.size;i++)
			ai[i].pacifist = true;
		ladderSequence();
		return;
	}

	ender setgoalpos(ender.origin);
	wait (3);
	ender setgoalnode(node);
	getent ("camera1_blend_trigger","targetname") waittill ("trigger");
	activateCamera (getent ("camera1","script_noteworthy"), getent ("camera1_blend","targetname"), 0, 5);

	getent ("camera_start_trigger","targetname") waittill ("trigger");
	level.camera_model moveto (level.camera_model.origin + (-1500, 250, 100), 9.65, 1);

//	level.camera_model linkto (level.ender);
	trigger = getent ("cliff_jump_trigger","script_noteworthy");
	trigger waittill ("trigger");
	waittillframeend; // so we're consistently last just to make sure being last doesnt break it
//	level.camera_model unlink();

	trigger = getent ("cliff_land_trigger","script_noteworthy");
	trigger waittill ("trigger", other);
	wait (1.5);
	
	ender delete();
	ender = getent("ender_jeep_spawner","targetname") stalingradspawn();
	ender.bcname = level.credits_name["ender"];

	level.ender = ender;
	activateCamera (getent ("camera_jeep_pulls_up","targetname"));

	spawn_failed(ender);
	enderNode = getnode(ender.target,"targetname");
	ender setgoalnode(enderNode);
	ender.goalradius = 8;
	ender waittill ("goal");
	wait (2);
	enderNode = getnode(enderNode.target, "targetname");
	ai = getaiarray("allies");
	ender setgoalnode(enderNode);
	for (i=0;i<ai.size;i++)
		ai[i] setgoalnode(enderNode);
		
	sneakyGuy = getent("sneaky_buddy_spawner","targetname") stalingradspawn();
	spawn_failed(sneakyGuy);
	sneakyGuy.pacifist = true;
	sneakyGuy thread pathChainOfNodes();
		
	wait (2);

	ender = getent ("ender_postjeep_spawner","targetname") stalingradSpawn();
	ender.bcname = level.credits_name["ender"];
	level.ender = ender;
	spawn_failed(ender);
	ender thread enderChainOfNodes();
	
	spawners = getentarray("jeep_guy_spawner","targetname");
	runners = [];
	for (i=0;i<spawners.size;i++)
		runners[runners.size] = spawners[i] stalingradspawn();

	for (i=0;i<runners.size;i++)
	{
		spawn_failed(runners[i]);
		runners[i] setgoalnode(getnode(runners[i].target,"targetname"));
		runners[i].goalradius = 100;
	}
	
	
	wait (1.5);
	activateCamera (getent ("camera_sneaky_guy","targetname"));

	for (i=0;i<ai.size;i++)
		ai[i] delete();
	
	enemyspawner = getent("pacifist_spawner","targetname");
	spawn = enemyspawner stalingradspawn();
	spawn_failed(spawn);
	spawn.pacifist = true;
	spawn thread aimAtTargets();
	
	ai = getentarray("jeep_guy","script_noteworthy");
	for (i=0;i<ai.size;i++)
	{
		if (!isalive(ai[i]))
			continue;
		ai[i] thread pathChainOfNodes();
	}
	
	ender.pacifist = true;

	wait (7);
	activateCamera (getent ("camera_forest","targetname"));
	
	ender waittill ("chain_end");
	
	ladderSequence();
}

ladderSequence()
{
	ender = level.ender;
	ender thread raise_ladder();
	level waittill ("starting_ladder_anim");
	thread delayedFunction (::activateCamera, 1.5, getent ("camera_ladder","targetname"));
	/*
	thread delayedFunction (::activateCamera, 5.4, getent ("camera_ladder_top","targetname"));
	level waittill ("ladder_up");
	*/
	wait (5);
	activateCamera (getent ("camera_ladder_top","targetname"));
	ender stopanimscripted();
	flag_set ("ladder_up");
	
	node = getnode ("vehicle_park_node","targetname");
	ender setgoalnode (node);
	ender waittill ("goal");
	wait (2);
	node = getnode(node.target,"targetname");
	ender setgoalnode (node);
	
	trigger = getent ("melee_trigger_2","targetname");
	trigger waittill ("trigger");
	wait (2.5);
	activateCamera (getent ("camera_beat_far","targetname"));
	wait (3);
	flag_set("spit");
	level waittill ("startSpit");
	activateCamera (getent ("camera_beat_close","targetname"));
	wait (3);
	barnDoorKick();
}

#using_animtree("barndoor");
barndoorkick()
{
	door = getent("barn_door_model","targetname");
	guy[0] = level.ender;
	guy[1] = door;
	
	//door thread debugTag("tag_origin");
	
//	door hide();
				
	// play kick animation on mcgregor
	animNode = getent("doorkick_goal","targetname");
	animNode anim_reach_solo (guy[0], "barndoor");		
	animNode thread maps\_anim::anim_single (guy, "barndoor");
	wait 1.2;
//	wait 1.05;
	
	activateCamera (getent ("camera_breakdoor","targetname"));
	waittillframeend;	
	if (level.timescaleEnabled)
		setsavedcvar("timescale", "0.25");
	door playsound ("wood_door_fisthit");
	wait 1;		
	door playsound ("wood_door_shoulderhit");

//	activateCamera (getent ("camera_breakdoor","targetname"));
	if (level.timescaleEnabled)
		setsavedcvar("timescale", "1");
//	waittillframeend;	
	activateCamera (getent ("camera_farm","targetname"));
	thread attackGuard();
	wait .5;
	doorscript = getent("left_door","targetname");
	doorScript connectpaths();
}

#using_animtree("generic_human");
attackGuard()
{
	pathBlocker = getent ("ender_path_blocker","targetname"); // otherwise ender can go the wrong way sometimes
	pathBlocker disconnectPaths();
	ender = level.ender;
	ender.pacifist = false;
	ender.goalradius = 100;
	ender setgoalentity(level.guard);
	
	price = level.price;
	level.playerShield notsolid(); // so helmet cant get stuck on the box
	level.guard.ignoreme = false;
	level.guard.health = 1;
	level.guard.allowdeath = true;
	level.guard waittill ("death");
	ender.pacifist = true;
	
	flag_set("price_rescued");
	
	price stopanimscripted();
	level.chair notify ("stopIdle");
	level.chair thread anim_loop_solo (price, "idle", undefined, "stopIdle");
	
	enderNode = getnode ("ender_node","targetname");
	ender setgoalnode (enderNode);
	ender.goalradius = 64;
	trigger = getent ("price_go_trigger","script_noteworthy");
	thread pathConnector();

	for (;;)
	{
		trigger waittill ("trigger", other);
		if (other == ender)
			break;
	}
	
	priceNode = getnode("price_node","targetname");
	price.goalradius = 64;
	price setgoalnode (priceNode);
	price stopanimscripted();

	// forces price and ender to crouch
	getent ("crouch_trigger","script_noteworthy") thread crouchTrigger();
	
	ai = getaiarray("allies");
	surrenderVolume = getent ("surrender_start_volume","targetname");
	waveVolume = getent ("wave_volume","targetname");
	runners = [];
	surrenderGuy = undefined;
	waveGuy = undefined;
	mgGuy = undefined;

	
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] == ender)
			continue;
		if (ai[i] == price)
			continue;
		
		if (ai[i] istouching (surrenderVolume))
		{
			surrenderGuy = ai[i];
			surrenderGuy.bcname = level.credits_name["surrenderGuy"];
			continue;
		}
		
		if (ai[i] istouching (waveVolume))
		{
			waveGuy = ai[i];
			waveGuy.bcname = level.credits_name["waveGuy"];
			continue;
		}

		if (!isdefined(mgGuy))
		{
			mgGuy = ai[i];
			mgGuy.bcname = level.credits_name["cal30guy"];
			continue;
		}		
		
		if (!isdefined(ai[i].bcname))
		{
			ai[i].bcname = level.iwNames[level.iwNamesIndex];
			level.iwNamesIndex++;
		}
		
		runners[runners.size] = ai[i];
	}

	wait (4);
	level.playerShield solid(); // turn it back on again
	
	mgNode = getnode ("mg_prep_node","script_noteworthy");
	mgGuy.goalradius = 64;
	mgGuy setgoalnode (mgNode);
	for (i=0;i<runners.size;i++)
	{
		runners[i].goalradius = 24;
		runners[i] setgoalnode (getnode("friendly_pause_node_" + (i+1), "targetname"));
		wait (randomfloat (1));
	}
	
	axisGuy = getaiarray("axis")[0];
	axisGuy thread forcecustomBattleChatter( "infantry_generic" );
	wait (2.5);
	axisGuy thread forcecustomBattleChatter( "infantry_many" );
	wait (0.5);
	waveGuy.animname = "waveGuy";
	waveNode = getnode ("wave_node","targetname");
	waveNode anim_reach_solo (waveGuy, "wave2run");
	waveGuy thread forcecustomBattleChatter( "move_forward", surrenderGuy );
//	waveNode anim_single_solo (waveGuy, "wave2run");
	waveGuy anim_single_solo (waveGuy, "wave2run");
	waveGuy.goalradius = 128;
	waveHideNode = getnode("wave_hide_node", "targetname");
	waveGuy setgoalnode (waveHideNode);
	
	wait (0.1);
	surrenderGuy.animname = "surrenderGuy";
	surrenderGuy.deathanim = %stand_death_frontspin;
	surrenderNode = getnode("surrender_node","targetname");
	surrenderNode thread anim_reach_solo (surrenderGuy, "surrender");
	trigger = getent("surrender_trigger","targetname");
	trigger waittill ("trigger");

	activateCamera (getent ("camera_spotlight","targetname"));
	wait (1.25);
	axisGuy thread forcecustomBattleChatter( "infantry_exposed" );
	

	level.surrenderGuy = surrenderGuy;
	array_thread (getentarray("spotlight","targetname"), ::spotLight);
	
//	surrenderGuy.allowDeath = true;
	surrenderGuy waittill ("goal");
	surrenderGuy.dropWeapon = false;
	throwVel = 75 + randomInt(50);
	surrenderGuy DropWeapon(surrenderGuy.weapon, surrenderGuy.anim_gunHand, throwVel);
	surrenderGuy PutGunInHand("none");
	surrenderNode thread anim_loop_solo (surrenderGuy, "idle", undefined, "stopIdle");

	wait (1);
	activateCamera (getent ("camera_surrender","targetname"));
	wait (0.4);
	
	surrenderNode notify ("stopIdle");
//	surrenderGuy.weapon = "colt";
	surrenderGuy.secondaryweapon = "none";
	surrenderGuy.anim_movement = "stop";
	surrenderNode thread anim_single_solo (surrenderGuy, "pistol_pull");
	surrenderGuy thread changeWeaponToLuger();


	lookNode = getnode("look_node","targetname");
	waveGuy.goalradius = 16;

//	wait (0.55);
	wait (0.25);
	waveGuy.team = "neutral";
	waveGuy setgoalnode (lookNode);
//	wait (1.45);
	wait (1.75);
		
	surrenderGuy stopanimscripted();
	surrenderGuy.health = 150;
	array_thread (getentarray("gun","targetname"), ::gunThink);
		
	runnerNodes = getnodearray("runner_node","targetname");
	for (i=0;i<runners.size;i++)
		runners[i] setgoalnode(runnerNodes[i]);

	surrenderGuy thread surrenderGuy_death_failsafe();
	surrenderGuy waittill ("death");
	thread battleChatterOn( "allies" );
	thread battleChatterOn( "axis" );

	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		ai[i] thread magic_bullet_shield();
		ai[i].pacifist = false;
		ai[i].suppressionwait = 0;
		ai[i].anim_forced_cover = "show";
		ai[i].baseaccuracy = 0;
		ai[i].ignoreme = false;
	}
	
	mgGuy.goalradius = 32;
	pauseNode = getnode ("friendly_pause_node_1","targetname");
	mgGuy setgoalnode(pauseNode);		

	wait (0.8);
	activateCamera(getent("camera_look","targetname"));	
	waveGuy waittill ("goal");

	node = getent ("door_kick_node","script_noteworthy");
	node thread anim_reach_solo (ender, "kick_door");
//	wait (1.3);
	wait (0.85);
	waveNode = getnode (lookNode.target,"targetname");
	waveGuy setgoalnode(waveNode);
	wait (1);
	waveGuy.team = "allies";

	
	activateCamera(getent("camera_door_kick_far","targetname"));	
	node anim_reach_solo (ender, "kick_door");
	spawner = getent("door_spawner","targetname");
	spawner.count = 1;
	spawn = spawner stalingradspawn();
	spawn_failed(spawn);
	spawn.baseaccuracy = 0;
//	spawn.health = 5000;
	spawn thread killSelfTrigger();
	
	node thread anim_single_solo (ender, "kick_door");
	ender setgoalnode (getnode(node.target,"targetname"));

	runnerNodes = getnodearray("runner_cover","targetname");
	for (i=0;i<runners.size;i++)
		runners[i] setgoalnode(runnerNodes[i]);
		
	priceNode = getnode("price_cover","targetname");
	price.goalradius = 64;
	price setgoalnode (priceNode);
		

	wait (0.8);
	activateCamera(getent("camera_door_kick","targetname"));	
	
	array_thread (getentarray("halftrack_rider","script_noteworthy"), ::halftrackRider);
	array_thread (getentarray("mortar_spawner","script_noteworthy"), ::mortarSpawnerThink);
	

	trigger = getent("halftrack_trigger","targetname");
	for (;;)
	{
		trigger waittill ("trigger",other);
		if (other == ender)
			break;
	}
	
	wait (1);
	// start up the halftrack
	getent ("axis_door_kick_spawner","script_noteworthy") thread axisDoorKickSpawner();
	getent(trigger.target,"targetname") notify ("trigger"); 
	
	wait (1);
	activateCamera(getent("camera_halftrack_entrance","targetname"));
	
	trigger = getent ("halftrack_camera_trigger","targetname");
	trigger waittill ("trigger", other);
	activateCamera(getent(trigger.target,"targetname"));
	other waittill ("unload");
	level notify ("unloaded");
	wait (0.35);
	activateCamera(getent("camera_halftrack_unload","targetname"));
	wait (3.3);
//	wait (3.7);
	activateCamera(getent("camera_axis_watch","targetname"));
	wait(6.3);
	wait(1.5);
	
	activateCamera(getent("camera_house_defend","targetname"));
	wait (3);
	cal30guy = getent ("mg_spawner","targetname") stalingradspawn();
	cal30guy.bcname = level.credits_name["cal30guy"];

	spawn_failed(cal30guy);
	cal30guy.ignoreme = true;
	cal30guy thread magic_bullet_shield();
	cal30guy thread mgSetupThread();
	mgGuy delete();
	wait (1);
	
	activateCamera(getent("camera_corner_planner","targetname"));
	wait (2);
	
	level.scr_anim["axisKickGuy"]["door_breach"] 	 = %eldaba_scene_kickdoor;
	level.scr_anim["axisKickGuy"]["death"] 			 = %eldaba_scene_kickdoor_pose;
	activateCamera(getent("camera_30cal","targetname"));
	//30 cal gun runs in and sets up
	wait (3);
	activateCamera(getent("camera_corner_planner","targetname"));
	wait (0.4);
	// kick door scene begins
	axisKicker = level.axisDoorKicker;
	axisKicker.animname = "axisKickGuy";
	axisKicker.anim_disablePain = true;
	axisKicker.team = "neutral";
	
	axisKickNode = getnode ("temp_doorkick_node", "targetname");
	axisKickNode thread anim_reach_solo (axisKicker, "door_breach");
	wait (0.7);
	thread activateCamera(getent("camera_corner_sneak","targetname"), getent("camera_corner_sneak_blend","targetname"), 0.5, 5.4);
	
//	thread movetoCamera(getent("camera_sneak_attack","targetname"), 5.9, 1.5, 0.01, 0.01);

	axisKicker waittill ("goal");


	axisKicker.deathanim = level.scr_anim[axisKicker.animname]["death"];
	axisKickNode thread anim_single_solo(axisKicker, "door_breach");
	axisKicker thread ai_kickdoor_fx();
	axisKicker thread ai_kickdoor_kill(axisKickNode);

	wait 1;
	activateCamera(getent("camera_sneak_attack","targetname"));
	thread playsoundinspace("wood_door_kick", axisKickNode.origin + (0,0,40));

	
	wait 1.2;

	level notify("started_doorshread");
	exploder(10);
	level notify("mg_fire");

	wait (1);

	org = spawn("script_origin",axisKicker.origin + (0,0,30));
//	mgGuy setmode("manual_ai"); // auto, auto_ai, manual
//	mg42 settargetentity(targ_org);
	wait (1.5);

	exploder(14);
	waittillframeend;
	activateCamera(getent("camera_30cal","targetname"));

	mortarSpawner = getent ("mortar_spawner", "targetname");
	mortarEnt = mortarspawner maps\_mortarTeam::mortarSpawner();
	wait (1);
	wait (2.2);
	
	activateCamera(getent("camera_mortar_setup","targetname"));
//	mortarEnt waittill ("loadguy_done");
	mortarEnt waittill ("loadguy_starting");
	wait (1.2);
	thread activateCamera(getent("camera_mortar_setup","targetname"), getent("camera_mortar_setup_blend","targetname"), 0, 1.5);
	closestGerman = getclosestai(level.player.origin, "axis");
	level.scr_sound[closestGerman.animName]["taunt"] = "GE_2_taunt";
	closestGerman thread anim_single_solo (closestGerman, "taunt");
	mortarEnt waittill ("mortar_fired");
	
	dragGuy = getVolumeEnt(getaiarray("allies"), getent("drag_volume","targetname"));
	dragGuy.deathanim = %death_explosion_back13;
	dragOrigin = getent("drag_origin","targetname");
	dragGuy.animname = "dragger";
	if (!isdefined(dragGuy.bcName))
	{
		dragGuy.bcname = level.iwNames[level.iwNamesIndex];
		level.iwNamesIndex++;
	}
	
	dragOrigin thread anim_single_solo(dragGuy, "drag_start");

	wait (1.2);
	activateCamera(getent("camera_drag_hit","targetname"));
	waveGuy thread forcecustomBattleChatter( "cover_generic", dragGuy );
	
	wait (0.8);
	mortar = getent("mortar_spot","targetname");
	mortar mortarExplosion();
	earthquake(1, 2, mortar.origin, 500);
		
	array = getArrayOfClosest(level.player.origin, getaiarray("allies"), [], 2);
	
	for (i=0;i<array.size;i++)
	{
		if (!isdefined(array[i].deathAnim))
			array[i].deathAnim = %death_explosion_up10;
		array[i] stopanimscripted();
		array[i] notify ("stop magic bullet shield");
		waittillframeend;
		array[i] dodamage(50000,(0,0,-500));
	}
	
	wait (1.5);
	
	activateCamera(getent("camera_house_smoke","targetname"));
	level.explosionhide = false; // for mortarteams

	smokeGuy[0] = getVolumeEnt(getaiarray("allies"), getent("smoke_volume","targetname"));
	redshirt = smokeGuy[0];
	redshirt.bcname = level.credits_name["redshirt"];


	smokeGuy[1] = ender;
	smokeGuy[2] = price;
	
	smokeGuy[0].animname = "grenade_corner_stand";
	smokeGuy[1].animname = "grenade_corner_crouch";
	smokeGuy[2].animname = "grenade_stand";

	smokeNode = [];
	for (i=0;i<smokeGuy.size;i++)
		smokeGuy[i].anim_forced_cover = "hide";	

	wait (1.2);
	smokeGuy[1] setBattleChatter(false);
		
	smokeGuy[1].lookTarget = smokeGuy[0];
	thread battleChatterOff( "allies" );		
	smokeGuy[1] anim_single_solo (smokeGuy[1], "call_for_smoke");
	wait (0.35);
		
//	wait (1.8);	

	thread activateCamera(getent("camera_smoke_throw","targetname"), getent("camera_smoke_throw_blend","targetname"), 0.6, 2);
	for (i=0;i<smokeGuy.size;i++)
	{
		assert(isdefined(smokeGuy[i].covernode));
		if (smokeGuy[i].animname != "grenade_stand")
		{
			smokeNode[i] = spawn("script_origin",(0,0,0));
			smokeNode[i].origin = smokeGuy[i].covernode.origin;
			smokeNode[i].angles = smokeGuy[i].covernode.angles + (0,-90,0);
		}
		else
			smokeNode[i] = smokeGuy[i].covernode;
		
		smokeNode[i] thread anim_single_solo (smokeGuy[i], "grenade_throw");
		wait (0.8);
	}
	for (i=0;i<smokeGuy.size;i++)
		smokeGuy[i].anim_forced_cover = "show";	
	thread battleChatterOff( "allies" );		
	
	wait (1.35);
	activateCamera (getent ("camera_smoke_escape","targetname"));

//	activateCamera(getent("camera_axis_watch","targetname"));
//	thread activateCamera(getent("camera_axis_watch","targetname"), getent ("camera_smoke_escape","targetname"), 9, 2);

	wait (5);
	axis = [];
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if (isdefined(ai[i].animname))
			continue;
		ai[i].animname = "generic";
		axis[axis.size] = ai[i];
	}

	axis[0] thread anim_single_solo (axis[0], "cough");
	wait (0.5);
	axis[1] thread anim_single_solo (axis[1], "cough");
	wait (0.7);

	mortarEnt stopMortar();
	mortarNode = getnode("mortar_seek_node","targetname");
	mortarEnt.aimGuy setgoalnode(mortarNode);
	mortarEnt.loadGuy setgoalnode(mortarNode);
	
	wait (2.2);
//	activateCamera (getent ("camera_ally_charge","targetname"));
	wait (1.3);
	
	thread playsoundinspace ("credits_walla", getent ("camera_smoke_escape","targetname").origin);
	for (i=0;i<ai.size;i++)
	{
		ai[i] dodamage (ai[i].health, (0,0,0));
		wait (0.4 + randomfloat(0.4));
	}	
	
	flag_set ("camera_change");
	wait(5);
	activateCamera (getent ("camera_smoke_escape2","targetname"));
	thread battleChatterOn( "allies" );

	redshirt delete();
	ender delete();
	price delete();
	cal30guy delete();
	
	escapeSequence();
}

nodeSpawn(nodeName, spawnerName)
{
	node = getnode(nodename,"script_noteworthy");
	spawner = getent(spawnerName,"targetname");
	spawner.origin = node.origin;
	guy = spawner stalingradspawn();
	spawn_failed(guy);
	return guy;
}

escapeSequence()
{
	thread battleChatterOn("allies");
	price = nodeSpawn("price_teleport_node","price_smoke_spawner");
	price.bcname = level.credits_name["price"];

	ender = nodeSpawn("ender_teleport_node","ender_smoke_spawner");
	ender.bcname = level.credits_name["ender"];
	
	redshirt = nodeSpawn("redshirt_teleport_node","redshirt_smoke_spawner");
	redshirt.bcname = level.credits_name["redshirt"];
		
	cal30guy = nodeSpawn("cal30_teleport_node","cal30_smoke_spawner");
	cal30guy.bcname = level.credits_name["cal30guy"];

	redshirt.looktarget = ender;

	priceNode = getnode("price_node","script_noteworthy");
	enderNode = getnode("ender_node","script_noteworthy");
	redshirtNode = getnode("redshirt_node","script_noteworthy");
	cal30node = getnode("mgstart_node","script_noteworthy");
	
	price setgoalnode(priceNode);
	ender setgoalnode(enderNode);
	redshirt setgoalnode(redshirtNode);
	cal30guy setgoalnode(cal30node);	

	ender setFightSettings();
	price setFightSettings();
	redshirt setFightSettings();
	cal30guy setFightSettings();
	
/*	

	if (getcvar("start") == "end")
	{
		price = getent("price","targetname") stalingradspawn();
		ender = level.ender;
		cal30guy = getent("mgjump_spawner","targetname") stalingradspawn();
		redshirt = getent("redshirt_spawner","targetname") stalingradspawn();
		
		price teleport (priceNode.origin);
		price setgoalnode(priceNode);
		ender teleport (enderNode.origin);
		ender setgoalnode(enderNode);
		redshirt teleport (redshirtNode.origin);
		redshirt setgoalnode(redshirtNode);
		cal30guy teleport (mgNode.origin);
		cal30guy setgoalnode(mgNode);
//		activateCamera (getent ("camera_window","targetname"));
	}	
	else
*/
	
	/*
	{
		stair_trigger = getent ("stair_trigger","targetname");
		for (;;)
		{
			stair_trigger waittill ("trigger",other);
			if (!isalive(other))
				continue;
			if (other == ender)
				break;
		}
	}
	*/
	
	wait (2);
	
	stairGuy = getent ("staircase_spawner","targetname") stalingradspawn();
	stairGuy.animname = "stairguy";
	stairGuy.ignoreme = true;
	
	stairGuy.deathanim = %death_run_forward_crumple;
	stairGuy.deathanim = %death_run_right;

	stairNode = getent ("staircase_origin","targetname");
	stairNode.origin += (150,-50,25);
	stairNode.angles = (0,290,0);
	stairNode thread anim_single_solo (stairGuy, "jumpdown");
	stairGuy.allowdeath = true;
	
	wait (4.5);
	activateCamera (getent ("camera_window","targetname"));
	wait (1.05);
	priceNode thread nodeShoot (stairGuy, price.weapon);
	enderNode thread nodeShoot (stairGuy, ender.weapon);
	redshirtNode thread nodeShoot (stairGuy, redshirt.weapon);
	cal30guy thread nodeShoot (stairGuy, cal30guy.weapon);
//	stairGuy dodamage(stairGuy.health, (0,0,0));
	
	node = getnode("destination_node","targetname");
	priceCarNode = getnode ("price_car_node","target");
	price setgoalnode(priceCarNode);
	enderCarNode = getnode("ender_car_node","target");
	ender setgoalnode(enderCarNode);

	wait (0.65);
	calDeathNode = getnode ("mg_death_node","target");
	cal30guy setgoalnode(calDeathNode);
	array_thread (getentarray("ambient_bullet","targetname"), ::ambientBullet);

//	redshirtNode = getnode ("redshirt_node","targetname");
	redshirtNode = getnode ("redshirt_corner_node","targetname");
	redshirt setgoalnode(redshirtNode);
	redshirt.goalradius = 8;

	trigger = getent ("death_trigger","targetname");
	for (;;)
	{
		if (trigger istouching (redshirt))
			break;
		wait (0.05);
	}
	
	price thread nodeChain (getnode ("price_car_node","target"));
	ender thread nodeChain (getnode("ender_car_node","target"));
	cal30guy setgoalnode(getnode("mg_death_node","target"));

	redshirtPractice = getent ("redshirt_target_practice_spawner","targetname") stalingradspawn();
	spawn_failed(redshirtPractice);
	redshirt.baseAccuracy = 0;
	redshirtPractice.threatbias = 10000;
	redshirtPractice.baseAccuracy = 0;
	redshirt.anim_forced_cover = "show";
	redshirt.suppressionwait = 0;
	redshirt.favoriteEnemy = redshirtPractice;
	
	/*
	level.bqueue = 0;	
	redshirt.health = 1;
	redshirt notify ("stop magic bullet shield");
	priceNode thread nodeShoot (redshirt, "mp44");
	enderNode thread nodeShoot (redshirt, "mp44");
	redshirtNode thread nodeShoot (redshirt, "mp44");
	cal30guy thread nodeShoot (redshirt, "mp44");
	*/

	gunner = getent ("gunner_spawner","targetname") stalingradspawn();
	spawn_failed(gunner);
	gunner.ignoreme = true;
	gunner.animname = "gunner";
	gunner PutGunInHand("none");
	armoredcar = getent ("armoredcar","targetname");
	level.armoredCar = armoredCar;
	armoredcar thread anim_loop_solo( gunner, "death_idle", "tag_gunner", "stop_idle_loop");
	armoredcar maps\credits_anim::armored_car_openHatch();
	wait (1);

	

	german = getent ("car_spawner","targetname") stalingradspawn();
	spawn_failed(german);
	german.goalradius = 5;
	german.threatbias = 23432;

	activateCamera(getent("camera_car","targetname"));	
	german.health = 2000;
//	wait (0.7);
	cal30guy setgoalnode(getnode("mg_death_node","targetname"));
	wait (0.3);
	ender.animname = "ender";
	price.animname = "price";

	wait (0.5);
	cal30guy.health = 1;
	cal30guy notify ("stop magic bullet shield");
	priceNode thread nodeShoot (cal30guy, "mp44");
	enderNode thread nodeShoot (cal30guy, "mp44");
	redshirtNode thread nodeShoot (cal30guy, "mp44");
	cal30node thread nodeShoot (cal30guy, "mp44");

	wait (1.5);
	german.health = 1;
	if (isalive(german))
		german dodamage (german.health, (0,0,0));
	activateCamera(getent("camera_car","targetname"), getent ("camera_car_blend","targetname"), 0.5, 1);
	riders[0] = ender;
	riders[1] = price;
	armoredcar thread enderCar(ender);
	armoredcar thread priceCar(price);
	armoredcar thread gunnerCar(gunner);
	

	flag_wait("price_pulls_gunner");
	activateCamera(getent("camera_car_right","targetname"));
	wait (6);
	activateCamera(getent("camera_car_left","targetname"));
	
	
	array_thread(getentarray("target_practice","targetname"), ::targetPractice, armoredCar);
	array_thread(getentarray("getaway_spawner","targetname"), ::getawaySpawner);
/*	
	truck = getent ("axis_truck","targetname");
	truckGuy = getent ("driver_spawner","targetname") stalingradspawn();
	spawn_failed(truckGuy);
	truckGuy.animname = "german";
	truck thread anim_reach_solo (truckGuy, "truck", "tag_driver");
*/
	wait (0.9);
	level notify ("stop_ambient_shooting");

	activateCamera(getent ("camera_car_blend","targetname"));
	redShirt dodamage(redshirt.health, (0,0,0));

	wait (2);
	flag_wait("ender_enters_car");

	carPath = getvehiclenode("armoredcar_path","targetname");
	armoredCar attachPath(carPath);
	armoredCar startpath();
	armoredCar playsound ("vehicle_brakesqueal");
	wait (1);
	array_thread(getaiarray("axis"), ::chaseArmoredCar);
	activateCamera(getent("camera_tank_wall","targetname"));
	wait (2.3);
	level notify ("delete_practice");	
	
	tiger = maps\_vehicle::scripted_spawn(40)[0];	//spawns in the Tiger
	level thread maps\_vehicle::gopath(tiger);
	
	thread maps\credits_anim::breakwall();
	exploder(20);
	wait (0.5);
	wedge = getent("tank_lift","targetname");
	wedge moveto (wedge.origin + (0,0,-150), 4, 0.5, 0);
	wait (3);

	activateCamera(getent("camera_car_chase","targetname"));
	thread groundExplodesAroundCar(tiger);
	wait (9);
	activateCamera(getent("camera_tank_search","targetname"));
	
	carPath = getvehiclenode("car_flee_path","targetname");
	armoredCar attachPath(carPath);
	armoredCar setspeed (0,1000);

	tiger setwaitnode(getvehiclenode("tank_search_node","script_noteworthy"));
	tiger waittill ("reached_wait_node");
	tiger setspeed(0,150);
	wait (0.5);
	target = getent("tank_target","targetname");
	tiger setTurretTargetEnt(target, (0,0,0));
	wait (1.3);
	target = getent(target.target,"targetname");	
	tiger setTurretTargetEnt(target, (0,0,0));
	wait (2.5);
	target = getent(target.target,"targetname");	
	tiger setTurretTargetEnt(target, (0,0,0));
	wait (1);
	activateCamera(getent("camera_tank_search","targetname"), getent("camera_tank_search_blend","targetname"), 0, 1.5);
	wait (2.1);
	target = getent("tank_target","targetname");
	tiger setTurretTargetEnt(target, (0,0,0));
	wait (2);
	tiger setspeed(9,8);
	wait (2);
	
	flag_set("car_escape");
	
	armoredCar startpath();
	armoredCar setspeed(25,10);
	wait (2.2);
	activateCamera(getent("camera_car_drive","targetname"));
	wait (2.9);
	activateCamera (getent ("camera_sky","targetname"));
	wait (2);
	thread planeFliesOnPath(getvehiclenode("plane_pre_path","targetname"));
	wait (3);
	
	armoredCar delete();
	
	endDrive();
}

endDrive()
{
	array_thread(getaiarray(), ::deleter); // get rid of any AI that exist at this point

    setCullFog (300, 3500, 25/256, 45/256, 48/256, 0);
	carPath = getvehiclenode("car_path_plane","targetname");
	armoredCar = spawnVehicle( "xmodel/vehicle_german_armored_car", "armoredcar", "armoredcar", carPath.origin, carPath.angles );
	armoredCar attachpath(carPath);
	armoredCar startpath();
	armoredCar setspeed(30,500);
	
	activateCamera (getent ("camera_plane_chase","targetname"),getent ("camera_plane_chase_blend","targetname"), 0, 1.5, 0, 1);
//	wait (0.5);
	wait (1.3);
	thread planeFliesOnPathAndShoots(getvehiclenode("plane_attack_path","targetname"));
	wait (1.3);
	exploder(50);

	wait (1.5);
	
	armoredCar setspeed(40,500);
	activateCamera (getent ("camera_car_side","targetname"));
	wait (1.8);

    setCullFog (8000, 10500, 25/256, 45/256, 48/256, 0);
	activateCamera (getent ("camera_plane_dive","targetname"));
//	wait (0);
	thread planeFliesOnPathAndShoots(getvehiclenode("plane_dive","targetname"), 2.5);

	wait (2.2);
	
	carPath = getvehiclenode("car_wrap_path","targetname");
	armoredCar delete();
	armoredCar = spawnVehicle( "xmodel/vehicle_german_armored_car", "armoredcar", "armoredcar", carPath.origin, carPath.angles );
	armoredCar attachpath(carPath);
	armoredCar startpath();
	armoredCar setspeed(30,500);

	wait (1.5);
    setCullFog (300, 3500, 25/256, 45/256, 48/256, 0);
	
	level notify ("stop_plane_shoot_sound"); // we're really only 1 plane but at times 2 exist so stop the shooting on the first one
	thread planeControlsCameraAndShoots(getvehiclenode("plane_final_attack","targetname"));
	thread groundEffects(2, 26);
	thread planeFliesOnPathDelayed(getvehiclenode("plane_spin","targetname"), 2.8);
	wait (3.0);
	playfxontag(level._effect["tank_explosion"], armoredCar, "tag_origin");
	thread playsoundinspace("mortar_explosion", armoredCar gettagorigin("tag_origin"));
	wait (0.6);

	level notify ("stop_plane_shoot_sound"); // we're really only 1 plane but at times 2 exist so stop the shooting on the first one
	camera = getent ("camera_plane_spin","targetname");
	activateCamera (camera);
    setCullFog (10000, 15500, 25/256, 45/256, 48/256, 0);
    angles = vectortoangles(getent(camera.target,"targetname").origin - camera.origin);
    forward = anglestoforward(angles);
    right = anglestoright(angles);
    up = anglestoup(angles);

    up = vectorscale(up, -200);
    right = vectorscale(right, 100);
    forward = vectorscale(forward, 350);
    
    
	playfx(level._effect["tank_explosion"], camera.origin + right + forward + up);
	armoredCar delete();
	wait (4);
	exploder(35); // explosion over the hedgerow
	wait (0.5);
    setCullFog (300, 3500, 25/256, 45/256, 48/256, 0);

	activateCamera(getent("camera_ending_arrival","targetname"));
	carPath = getvehiclenode("car_path_final","targetname");
	armoredCar = spawnVehicle( "xmodel/vehicle_german_armored_car", "armoredcar", "armoredcar", carPath.origin, carPath.angles );
	armoredCar attachpath(carPath);
	armoredCar thread smokingEngineAtOffset((25,0,70));
	armoredCar thread smokingEngineAtOffset((55,-25,40));
	armoredCar thread smokingEngineAtOffset((-30,30,40));
	armoredCar thread occasionalExplosion();
	wait (1.5);
	armoredCar startpath();
	armoredCar stuttersUntilReachingWaitNode(getvehiclenode("car_wait_node_end","script_noteworthy"));
	playfx(level._effect["tank_explosion"], armoredCar.origin);
	thread playsoundinspace("credits_armoredcar_sputter", armoredCar.origin);

	armoredCar notify ("stop_smoking");
	armoredCar setspeed(0,15);
	wait (1.0);
	
//	activateCamera(getent("camera_ending_smoke","targetname"));
//	wait (0.5);
	playfx(level._effect["ammo_explosion"], armoredCar.origin);
	thread playsoundinspace("explo_ammo_dump", armoredCar.origin);
	wait (1.5);

	activateCamera(getent("camera_ending_explosion","targetname"));
	wait (0.5);
	org = armoredCar.origin;
	playfx(level._effect["big_explosion"], org);
	thread playsoundinspace("artillery_explosion", org);
	armoredCar delete();
	wait (1);
	
//	playfx(level._effect["smoke_shield"], org, org + (-100,-50,0));
//	playfx(level._effect["smoke_shield"], org, org + (-100,-50,0));
	exploder(37);	
	exploder(37);	
	ambientPlay(level.ambient_track ["stop"], 3);

	wait (6);
	
	node = getnode("stumble_node","targetname");
	priceSpawner = getent ("price_end_spawner","targetname");
	angle = 190;
	priceSpawner.angles = node.angles + (0,angle,0);
	priceSpawner.origin = node.origin;
	price = priceSpawner stalingradSpawn();
	price.bcname = level.credits_name["price"];

	enderSpawner = getent ("randall_end_spawner","targetname");
	enderSpawner.origin = node.origin + (0,32,0);
	enderSpawner.angles = node.angles + (0,angle,0);
	ender = enderSpawner stalingradSpawn();
	ender.bcname = level.credits_name["ender"];

	price PutGunInHand("none");
	ender PutGunInHand("none");
	price.animname = "price";
	ender.animname = "ender";
	guy[0] = price;
	guy[1] = ender;

//	for (;;)
//		price anim_single(guy, "walk");
	
	price setcontents(0);
	ender setcontents(0);
	price animcustom(::donothing);
	ender animcustom(::donothing);
	wait (0.05);
	price clearanim(%body, 0);
	ender clearanim(%body, 0);
	price animMode ( "gravity" );
	ender animMode ( "gravity" );
	ender linkto (price, "tag_origin", (0,0,0), (180,180,180));
	wait (2);
	
	flag_set("emerge_from_smoke");
	
	thread walkForever(price, ender);	
	wait (4.25);
	wavers = getentarray("ending_spawner","targetname");
	wavers = array_randomize(wavers);
	for (i=0;i<int(wavers.size*0.5);i++)
		wavers[i] thread spawnAndWave("stand");
	for (i=int(wavers.size*0.5);i < wavers.size;i++)
		wavers[i] thread spawnAndWave("crouch");
	thread waveNotify(wavers);
		
	wait (4);
	array_thread(getentarray("ending_runner","targetname"), ::spawnAndRun);
	array_thread(getentarray("ending_model","targetname"), ::showModel);
	activateCamera(getent("camera_ending_explosion","targetname"), getent("camera_ending_explosion_blend","targetname"), 0, 2, 1, 0);
	wait (2);
	activateCamera(getent("camera_ending_explosion_blend","targetname"), getent("camera_ending_explosion_blend2","targetname"), 0, 2, 0, 1);
	exploder(99); // mad cheering
	wait (2.4);
	array_thread(getentarray("ending_helper","targetname"), ::spawnAndRunThenWalk);
	wait (1.75);
	activateCamera(getent("camera_ending_explosion_blend2","targetname"), getent("camera_ending_explosion_blend3","targetname"), 0, 5, 1, 0);
	level.screenOverlay fadeOverTime (5);
	level.screenOverlay.alpha = 1;
	flag_set ("movie_credits_complete");
	

	wait (1);
	println ("");
	println ("Offsets:");
	for (i=0;i<level.cameraOffsetPrint.size;i++)
		println (level.cameraOffsetPrint[i]);
}

waveNotify(wavers)
{
	wait (7.5);
	for (i=0;i<wavers.size;i++)
	{
		wavers[i] notify ("wave_notify");
		wait (0.05 + randomfloat(0.1));
	}
}

spawnAndWave(stance)
{
	org = getent("rotate_point","targetname").origin;
	vec = org - self.origin;
	angles = vectortoangles(vec);
	self.angles = (0,angles[1],0);
	spawn = self stalingradspawn();
	spawn_failed(spawn);
	spawn.animname = "ending_guy";
	if (stance == "stand")
	{
		anime = "cheer_stand";
		spawn allowedstances("stand");
	}
	else
	{
		anime = "cheer_crouch";
		spawn allowedstances("crouch");
	}
	
	ent = spawn("script_origin", (0,0,0));
	ent.angles = spawn.angles;
	ent.origin = spawn.origin;

	self waittill ("wave_notify");
//	wait (7.5 + randomfloat(3));
	ent anim_single_solo(spawn, anime);
}

spawnAndRun()
{
//	wait (3);
	spawn = self stalingradspawn();
	spawn_failed(spawn);
	spawn.interval = 0;
}

spawnAndRunThenWalk()
{
//	wait (3);
	spawn = self stalingradspawn();
	spawn_failed(spawn);
	spawn.interval = 0;
	spawn.walkdist = 160;
	spawn.goalradius = 8;
	spawn.walk_noncombatanim = %armed_walk_slow; // %unarmed_walk_russian;
//	spawn putGuninhand("none");
}

showModel()
{
	self show();
}

hideModel()
{
	self hide();
}

walkForever(price, ender)
{
	for (;;)
	{
//		price anim_single(guy, "walk");
		price setflaggedanimknobrestart("flag", level.scr_anim[price.animname]["walk"], 1, 0.2, 0.55);
		ender setflaggedanimknobrestart("flag", level.scr_anim[ender.animname]["walk"], 1, 0.2, 0.55);
		price waittillmatch("flag","end");
	}
}

occasionalExplosion()
{
	self endon ("stop_smoking");
	amount = 0.3;
	for (;;)
	{
		playfx(level._effect["small_explosion"], self gettagorigin("tag_origin") + randomvector(100));
		thread playsoundinspace("credits_armoredcar_sputter", self.origin);
		wait (amount);
		amount += 0.1 + randomfloat(0.5);
		if (amount >= 2)
			amount = 0.3;
	}
}

smokingEngineAtOffset(offset)
{
	self endon ("stop_smoking");
	model = spawn ("script_model",(0,0,0));
	model setmodel ("xmodel/tag_origin");
	model linkto (self, "tag_origin", offset, (0,0,0));
//	model thread drawTagForever("tag_origin");
	
	for (;;)
	{
		playfxontag(level._effect["smoking_car"], model, "tag_origin");
		wait (0.25);
	}
}

stuttersUntilReachingWaitNode(waitnode)
{
	self setwaitnode(waitnode);
	self endon ("reached_wait_node");
	for (;;)
	{
		self setspeed(2,5);
		wait (0.5 + randomfloat(1.5));
		self setspeed(9,200);
		wait (0.5);		
	}
}

donothing()
{
	for (;;)
		wait (5000);
}

chaseArmoredCar()
{
	node = getnode("chase_node","targetname");
	self setgoalnode(node);
	self.goalradius = node.radius;
}

aiOverrides()
{
	array_thread(getaiarray(), ::aiAllyOverride);
	array_thread(getspawnerteamarray("allies"), ::spawnerAllyOverride);
}

aiAllyOverride()
{
	if (spawn_failed(self))
		return;
	self.dontavoidplayer = true;
}

spawnerAllyOverride()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("spawned", spawn);
		if (spawn_failed(spawn))
			continue;
		spawn thread aiAllyOverride();
	}
}

iwNames()
{
	level.iwNames = [];

	addName("Walton");
	addName("Glasco");
	addName("West");
	addName("Messerly");
	addName("Pearson");
	addName("Smith");
	addName("Gigliotti");
	addName("Rieke");
	addName("Barb");
	addName("Collier");
	addName("McCandlish");
	addName("Gaines");
	addName("Heath");
	addName("Porter");
	addName("Grenier");
	addName("Alderman");
	addName("Lopez");
	addName("Ganus");
	addName("Kuhn");
	addName("Johnsen");
	addName("Emslie");
	addName("Zampella");
	addName("Allen");
	addName("Houle");
	addName("Hammon");
	addName("Glenn");
	addName("Alavi");
	addName("McLeod");
	addName("Vantine");
	addName("Shiring");
	addName("Escher");
	addName("Hassell");
	level.iwNames = array_randomize(level.iwNames);	
	level.credits_name["ender"] = level.iwNames[0];
	level.credits_name["price"] = level.iwNames[1];
	level.credits_name["surrenderGuy"] = level.iwNames[2];
	level.credits_name["cal30guy"] = level.iwNames[3];
	level.credits_name["waveGuy"] = level.iwNames[4];
	level.credits_name["redshirt"] = level.iwNames[5];
	level.iwNamesIndex = 6;	
}

addName(msg)
{
	level.iwNames[level.iwNames.size] = msg;
}


pathConnector()
{
	wait (1);
	pathBlocker = getent ("ender_path_blocker","targetname"); // otherwise ender can go the wrong way sometimes
	pathBlocker connectPaths();
	pathBlocker delete();
}

fovChange()
{
	// script errors if you change it on the first frame
	wait (0.05);
	setsavedcvar("cg_fov","80");
}

surrenderGuy_death_failsafe()
{
	self endon ("death");
	wait (1);
	self dodamage(self.health, (0,0,0));
}