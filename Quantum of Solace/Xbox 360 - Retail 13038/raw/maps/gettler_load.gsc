#include maps\_utility;
#include maps\gettler_util;

main()
{
	//level.default_goalradius = 150;
	level.spawnerCallbackThread = ::spawn_think;

	all_spawners = GetSpawnerArray();
	array_thread(all_spawners, ::spawner_think);

	// player interaction nodes
	setup_interaction_hud();
	array_thread(GetNodeArray("interaction", "script_noteworthy"), ::interaction_node);

	array_thread(GetEntArray("fog", "targetname"), ::fog);

	array_thread(GetEntArray("gondola", "script_noteworthy"), ::gondola);
	// mql 4/30/08: call gondolas only on scene anim
	if( GetDVarInt( "skip_intro" ) != 1 )
	{
		array_thread(GetVehicleNodeArray("nod_intro_gond_path", "script_noteworthy"), ::gondola_path);
	}

	array_thread(GetNodeArray("delete", "script_noteworthy"), ::delete_node); // delete an AI when it gets to its goal
	array_thread(GetEntArray("delete", "script_noteworthy"), ::delete_trig);	// delete entities that a trigger is targeting

	array_thread(GetNodeArray("fire_at_target", "script_noteworthy"), ::fire_at_target_node);

	array_thread(GetEntArray("shake", "targetname"), ::shake_trig);
	array_thread(GetEntArray("tilt", "targetname"), ::tilt_trig); // TODO: put this back in and fix it
	array_thread(GetEntArray("stop_super_tilt", "script_noteworthy"), ::stop_super_tilt_trig);
	array_thread(GetEntArray("break", "targetname"), ::break_trig);

	// save game triggers can be set up with targetname or script_noteworthy
	array_thread(GetEntArray("save_game", "targetname"), ::save_game);
	array_thread(GetEntArray("save_game", "script_noteworthy"), ::save_game);

	array_thread(GetEntArray("killspawner", "targetname"), ::killspawner_trig);	// another way of doing killspawner trigger, this way targets the spawners

	// redlight triggers for follow vesper
	array_thread(GetEntArray("redlight", "targetname"), maps\gettler_vesper::redlight_trigger);

	// fake physics contraints
	//array_thread(GetEntArray("script_constraint", "script_noteworthy"), ::script_contraint);

	array_thread(GetEntArray("pillars_side_gate", "targetname"), ::pillars_side_gate);

	array_thread(GetEntArray("lights_off", "targetname"), ::lights_off_trigger);
	array_thread(GetEntArray("lights_on", "targetname"), ::lights_on_trigger);

	array_thread(GetEntArray("stop_music", "script_noteworthy"), ::stop_music);

	// mql 3/14: add new stuff
	array_thread(GetEntArray("trig_holster", "targetname"), ::holster);
	array_thread(GetEntArray("trig_unholster", "targetname"), ::unholster);
	array_thread(GetEntArray("death", "targetname"), ::fall_into_water );
	array_thread(GetEntArray("gondola", "script_noteworthy"), ::boat_float );
	array_thread(GetEntArray("trig_window_shutters", "targetname"), ::physics_shutters);
	array_thread(GetEntArray("trig_fx_notify", "targetname"), ::fx_notify);
	array_thread(GetEntArray("trig_phone_map_change", "targetname"), ::phone_map_change);
	array_thread(GetEntArray("trig_ambient_vo", "targetname"), ::ambient_vo);
	array_thread(GetEntArray("trig_battlechatter_vo", "targetname"), ::battlechatter_vo);
	//array_thread(GetEntArray("civ_zone", "targetname"), ::civ_zone);

	// init destruction chunks
	destruction();

	// exploder callbacks
	//GetEnt("stair_chunk_1", "script_noteworthy").exploder_callback = ::stair_chunk;
	//GetEnt("stair_chunk_2", "script_noteworthy").exploder_callback = ::stair_chunk_2;

	//level thread stair_chunk();

	// Oxytank
	GetEnt("oxytank_trigger", "targetname") thread oxy_tank();

	/////////////////////

	//setup_active_cover_nodes();

	maps\gettler_water::main();
	level thread bags();
	water_triggers();

	level thread viewbob_on();
	level thread viewbob_off();

	level thread elevator();
	level thread pulley();
	level thread control_panel_light();

	//GetEnt("under_gondola", "targetname") thread under_gondola();	//disabled - this works but doesn't really comunicate what's going on to the player, they just die.
																	// I also made the boat only drop from the player hitting the boat, so the thugs would accedently make it fall.

	GetEnt("kill_boat_yard_window_guy", "script_noteworthy") thread kill_boat_yard_window_guy();
	//wait 1;
	//iPrintLnBold("Found " + level.light_count +  " lights!");

	//GetEnt("trigger_stairs2", "targetname") thread trigger_stairs2();

	// attach lights to their script brush models
	array_thread(GetEntArray("light", "targetname"), ::init_light);

	level.light_final = GetEnt("light_final", "targetname");
	level.light_final.light_intensity = level.light_final GetLightIntensity();
	level.light_final SetLightIntensity(0);

	// physics optimization triggers
	array_thread(GetEntArray("phys_group", "targetname"), ::phys_group_trigger);

	level.sway_facade = GetEnt("sway_facade", "targetname");
	if (IsDefined(level.sway_facade))
	{
		if (level.ps3)
		{
			level.sway_facade delete();	// ps3 can't hang
		}
		else
		{
			level.sway_facade NotSolid();
			level.sway_facade Hide();
		}
	}

	level thread maps\gettler::ledge_stop();
}

//init_light()
//{
//	link = GetEnt(self.targetname, "target");
//	if (IsDefined(link))
//	{ 
//		//self LinkTo(link);
//
//		time = 5000;
//
//		while( true )
//		{  
//			//self rotatevelocity((360,360,0), time);
//			wait time;
//		}
//	}
//}

init_light()
{
	//while (true)
	//{
	//	wait 1;
	//	depth = level.sea_model.origin[2] - self.origin[2];
	//	if ((depth > 0) && (self GetLightIntensity() > 0))
	//	{
	//		//iPrintLnBold("light under water");
	//		self thread light_flicker();
	//		wait RandomIntRange(3, 6);
	//		self light_flicker(false, 0);
	//		break;
	//	}
	//}

	while (!self IsTouching(level.sea_model))
	{
		wait .5;
	}

	self thread light_flicker();
	wait RandomIntRange(3, 6);
	self light_flicker(false, 0);
}

control_panel_light()
{
	light = GetEnt("control_panel_light", "targetname");

	// wait til player is on 3rd floor
	flag_wait("player_3rd_floor");

	light thread light_flicker(true, 0, 2);

	level waittill("turn_off_control_panel_light");
	light light_flicker(false, 0);

	//while (true)
	//{
	//	light SetLightIntensity(RandomFloat(2));
	//	wait .05;
	//}
}

spawner_think()
{
	self endon("death");

	// delete spawners if the spawn fails, but only if they've spawned their first time
	//start_count = self.count;
	//while (true)
	//{
	//	self waittill("spawn_failed");
	//	if (self.count < start_count)
	//	{
	//		iPrintLn("deleting spawner!");
	//		self delete();
	//	}
	//}
}

//
// spawn_think - do custom stuff for AI when they spawn
//
spawn_think(spawn)
{
	//self thread death();	// handle spawner death
	if (!spawn_failed(spawn))
	{
		//spawn thread death();
		spawn ai_think();
	}
}

//death()
//{
//	self waittill("death");
//}

//
// ai_think - main function to do custom stuff for all AI, broken out from spawn think so it can be used for non spawned AI
//
ai_think()
{
	self thread maps\gettler_water::drown();

	if (IsDefined(self.script_noteworthy))
	{
		if (self.script_noteworthy == "bag1")
		{
			self thread maps\gettler::blow_bag1();
		}
		// DEMO - added //////////////////////////////////////////////
		else if (self.script_noteworthy == "shoot_at_bags")
		{
			self thread maps\gettler::shoot_at_bags();
			level notify("shoot_at_bags_guy_spawned");
		}
		// !DEMO /////////////////////////////////////////////////////
		else if (self.script_noteworthy == "vesper")
		{
			level.vesper = self;
			self gun_remove();
			level.vesper thread maps\gettler_util::attach_suit_case("del_suitcase");
		}
		else if (self.script_noteworthy == "gettler")
		{
		}
	}

	if(isdefined(self.script_parameters))
	{
		token = strtok(self.script_parameters, ":;,");
		for(i = 0; i < token.size; i++)
		{
			switch (token[i])
			{
			case "alert_flag":
				i++;
				self thread alert_flag(token[i]);
				break;
			}
		}
	}

	if (IsDefined(self.script_aigroup))
	{
		if (self.script_aigroup == "pillar_guards")
		{
			self LaserOn();
		}
	}

	if (issubstr(self.classname, "civilian"))
	{
		self thread civilian();
	}
}

//
// alert flag - set min alert to "yellow" when the specified flag is set
//
alert_flag(the_flag)
{
	flag_initialize(the_flag, true);
	flag_wait(the_flag);
	self SetAlertStateMin("alert_yellow");
}

civilian()
{
	if (self.type != "dog")
	{
		self animscripts\shared::placeWeaponOn(self.weapon, "none");
	}

	self.animname = "civilian";

	wait .5;  

	//self SetMachine("Brain", "BrainAiPushyBasic");
	//self SetGoalNode(GetNode(self.target, "targetname"));
	//self SetTetherRadius( 12*30 );
}

gondola()
{
	self.player_vehicle = false;
	if (IsDefined(self.script_string) && (self.script_string == "player_vehicle"))
	{
		self.player_vehicle = true;
	}

	if (IsDefined(self.targetname))
	{
		trig = GetEnt(self.targetname, "target");
		if (IsDefined(trig))
		{
			trig waittill("trigger");
		}

		if (self.player_vehicle)
		{
			level.player SetPlayerAngles(self.angles);
			level.player PlayerLinkTodelta(self, "tag_player", 1.0);

			GetEnt("gondola_end_clip", "targetname") NotSolid();
		}
	}

	self maps\_vehicle::getonpath();	
	if (IsDefined(self.attachedpath))
	{
		level thread maps\_vehicle::gopath(self);
	}

	self waittill("reached_end_node");

	if (self.player_vehicle)
	{
		GetEnt("gondola_end_clip", "targetname") Solid();
		level.player Unlink();
	}
	else
	{
		self delete();
	}
}

gondola_path()
{
	level endon( "stop_gondolas" );

	// mql 4/29/08: turn this into a 1 shot for intro
	//while (true)
	//{
	//	wait RandomIntRange(45, 90);
	//	if( IsDefined( self.targetname ) && ( self.targetname == "nod_motor_boat_path" ) )
	//	{
	//		gondola = SpawnVehicle("v_boat_motor_a", "spawned_gondola", "motor_boat", self.origin, self.angles);
	//		gondola.vehicletype = "motor_boat";
	//		maps\_vehicle::vehicle_init( gondola );
	//	}
	//	else
	//	{
	//		gondola = SpawnVehicle("v_gondola_flatbottom", "spawned_gondola", "gondola", self.origin, self.angles);
	//		gondola.vehicletype = "gondola";
	//	}
	//	gondola.target = self.targetname;
	//	gondola.bpathisdynamic = false;
	//	gondola thread gondola();
	//	gondola thread boat_float();
	//	
	//}
	gondola = SpawnVehicle("v_gondola_flatbottom", "spawned_gondola", "gondola", self.origin, self.angles);
	gondola.vehicletype = "gondola";
	gondola.target = self.targetname;
	gondola.bpathisdynamic = false;
	gondola thread gondola();
	gondola thread boat_float();
	gondola thread gondola_drones();
	gondola thread link_wake_to_ent("gondola_wake", 150);	
}

link_wake_to_ent(effect, life)
{
	ent_tag = Spawn("script_model", self.origin + (20, 0, 0));
	ent_tag SetModel("tag_origin");
	ent_tag.angles = (-90, 0, 0);
	ent_tag LinkTo(self);
		
	while(isdefined(self) && life > 0)
	{
		PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
		wait(0.2);
		life--;
	}
	ent_tag delete();
}

#using_animtree("fakeshooters");
gondola_drones()
{
	// spawn models
	entDriver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	entDriver.angles = self.angles;
	entDriver character\character_tourist_1_venice::main();
	entDriver LinkTo( self, "tag_driver" );
	entMPass = Spawn( "script_model", self GetTagOrigin( "tag_passenger01" ) );
	entMPass.angles = self.angles;
	entMPass character\character_tourist_2_venice::main();
	entMPass LinkTo( self, "tag_passenger01" );
	entFPass = Spawn( "script_model", self GetTagOrigin( "tag_passenger02" ) );
	entFPass.angles = self.angles;
	entFPass character\character_fem_civ_1_venice::main();
	entFPass LinkTo( self, "tag_passenger02" );
	wait( 0.05 );
	entOar = Spawn( "script_model", entDriver GetTagOrigin( "tag_weapon_right" ) );
	entOar.angles = entDriver gettagangles( "tag_weapon_right" );
	entOar SetModel( "p_msc_gondola_oar_b" );
	entOar LinkTo( entDriver, "tag_weapon_right" );


	// play anims
	entDriver useAnimTree(#animtree);
	entMPass useAnimTree(#animtree);
	entFPass useAnimTree(#animtree);
	entDriver setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaDrive);
	entMPass setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);
	entFPass setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide_Female);

	// wait to del ents
	self waittill( "reached_end_node" );
	entDriver Delete();
	entMPass Delete();
	entFPass Delete();
	entOar Delete();
}

motor_boat_loop()
{
	level endon( "stop_gondolas" );

	while (true)
	{
		gondola = SpawnVehicle("v_boat_motor_a", "spawned_gondola", "motor_boat", self.origin, self.angles);
		gondola.vehicletype = "motor_boat";
		maps\_vehicle::vehicle_init( gondola );

		gondola.target = self.targetname;
		gondola.bpathisdynamic = false;
		gondola thread gondola();
		gondola thread boat_float();
		gondola thread motor_boat_drones();
		gondola PlayLoopSound("GET_Random_MotorBoat_Music");
		wait RandomIntRange(45, 90);
	}
}

#using_animtree("fakeshooters");
motor_boat_drones()
{
	// spawn models
	entDriver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	entDriver.angles = self.angles;
	if( RandomInt( 2 ) )
	{
		entDriver character\character_tourist_1_venice::main();
	}
	else
	{
		entDriver character\character_tourist_2_venice::main();
	}
	entDriver LinkTo( self, "tag_driver", (0,0,-12), (0,0,0) );
	entPass = Spawn( "script_model", self GetTagOrigin( "tag_passenger01" ) );
	entPass.angles = self.angles;

	pass_fem = false;
	if( RandomInt( 2 ) )
	{
		entPass character\character_fem_civ_1_venice::main();
		pass_fem = true;
	}
	else
	{
		entPass character\character_tourist_3_venice::main();
	}
	entPass LinkTo( self, "tag_passenger01", (0,0,-12), (0,0,0) );

	// play anims
	entDriver useAnimTree(#animtree);
	entPass useAnimTree(#animtree);
	entDriver setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);
	
	if (pass_fem)
	{
		entPass setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide_Female);
	}
	else
	{
		entPass setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);
	}

	// wait to del ents
	self waittill( "reached_end_node" );
	entDriver Delete();
	entPass Delete();
}

water_triggers()
{
	trigs = GetEntArray("raise_water", "targetname");
	array_thread(trigs, maps\gettler_water::trigger_water);
}

bags()
{
	flag_initialize("bag1");
	flag_initialize("bag2");
	flag_initialize("bag3");
	flag_initialize("bag4");
	flag_initialize("bag5");
	flag_initialize("bag6");
	flag_initialize("bag7");
	flag_initialize("bag8");
	flag_initialize("bag9");
	flag_initialize("bag10");

	flag_initialize("bag1_ok");
	flag_initialize("bag2_ok");
	flag_initialize("bag3_ok");
	flag_initialize("bag4_ok"); 
	flag_initialize("bag5_ok");
	flag_initialize("bag6_ok");
	flag_initialize("bag7_ok");
	flag_initialize("bag8_ok");
	flag_initialize("bag9_ok"); 
	flag_initialize("bag10_ok");

	flag_set("bag1_ok");
	flag_set("bag2_ok");
	flag_set("bag3_ok");
	flag_set("bag4_ok");
	//flag_set("bag5_ok");
	flag_set("bag6_ok");
	flag_set("bag7_ok");
	flag_set("bag8_ok");
	flag_set("bag9_ok");
	flag_set("bag10_ok");

	all_bags = GetEntArray("bag", "script_noteworthy");
	array_thread(all_bags, maps\gettler::bag);

	for (i = 0; i < all_bags.size; i++)
	{
		all_bags[i] LinkTo(level.sea_model);	// TODO: do this better so we get a better bobbing effect

		collision = GetEnt(all_bags[i].target, "targetname");
		if (IsDefined(collision))
		{
			all_bags[i].bag_collision = collision;
			collision LinkTo(all_bags[i]);	// Link collision to the bag models
		}
	}

	level thread make_bag5_ok();
	level thread maps\gettler::blow_bag2();
}

noop(ent)
{
	return;
}

//
// make_bag5_ok - after the player has crossed the bag, make it ok for that bag to burst (don't raise the water)
//
make_bag5_ok()
{
	flag_set("bag5_ok");
	GetEnt("over_bag", "script_noteworthy") waittill("trigger");

	tilt_org = GetEnt("over_bag5_tilt", "targetname");
	level thread tilt_building(tilt_org.angles, 8);

	//remove tethers
	ai = get_ai_group_ai("group5");
	for (i = 0; i < ai.size; i++)
	{
		ai[i] SetTetherRadius(-1);
		ai[i] SetCombatRole("Basic");
	}

	// trigger ceiling collapse
	piece = GetEnt("getx201", "script_noteworthy");
	//piece = GetEnt("destruction_test", "script_noteworthy");
	maps\gettler_util::trigger_destruction(piece);
}

delete_node()
{
	while (true)
	{
		self waittill("trigger", e);
		e delete();
	}
}

delete_trig()
{
	self waittill("trigger");
	if (IsDefined(self.target))
	{
		array_delete(GetEntArray(self.target, "targetname"));
	}

}

//setup_active_cover_nodes()
//{
//	if (!IsDefined(level.active_cover))
//	{
//		level.active_cover = [];
//	}
//
//	nodes = GetNodeArray("active_cover", "script_noteworthy");
//	for (i = 0; i < nodes.size; i++)
//	{
//		if (IsDefined(nodes[i].script_string))
//		{
//			index = 0;
//			if (IsDefined(level.active_cover[nodes[i].script_string]))
//			{
//				index = level.active_cover[nodes[i].script_string].size;
//			}
//
//			level.active_cover[nodes[i].script_string][index] = nodes[i];
//
//			//SetNodePriority(nodes[i], false);	// TODO: This doesn't work, replace when we get a system for assigning priority to a node, or enabling/disabling nodes
//
//			/#
//			//nodes[i] maps\gettler_util::show_label("inactive");
//			#/
//		}
//	}
//}

fire_at_target_node()
{
	self waittill("trigger", ent);
	target = GetEnt(self.target, "targetname");

	count = 1;
	if (IsDefined(self.count))
	{
		count = self.count;
	}

	//self script_delay();

	if (IsDefined(target.script_radius) && IsDefined(target.script_damage))
	{
		RadiusDamage(target.origin, target.script_radius, target.script_damage, target.script_damage / 2);
	}

	if (IsDefined(ent))
	{
		ent CmdShootAtEntity(target, true, count);
	}

}

shake_trig()
{
	duration = 2;
	if (IsDefined(self.script_int))
	{
		duration = self.script_int;
	}

	raise_water = false;
	if (IsDefined(self.script_noteworthy) && (self.script_noteworthy == "raise_water"))
	{
		raise_water = true;
	}

	self waittill("trigger");
	level thread shake_building(duration, self.script_float);

	if (raise_water)
	{
		maps\gettler_water::raise_water();
	}
}

tilt_trig()
{
	level thread do_tilt_trig(self);
}

do_tilt_trig(trig)
{
	org = GetEnt(trig.target, "targetname");
	angles = org.angles;

	time = 1;
	if (IsDefined(org.script_float))
	{
		time = org.script_float;
	}

	tilt_back = false;
	if (IsDefined(org.script_int))
	{
		tilt_back = org.script_int;
	}

	new_angles = undefined;
	if (IsDefined(org.script_vector))
	{
		new_angles = org.script_vector;
	}

	trig waittill("trigger");
	//iPrintLnBold("tilt trigger");
	//level thread tilt_building_scripted(angles, time, tilt_back, new_angles);
	wait time * .5;

	//level waittill("new_tilt");
	if (IsDefined(org.script_radius))
	{
		level thread physics_impulse(org.origin, org.script_radius, time / 2);
	}

	if (IsDefined(org.script_string))
	{
		maps\_sea::sea_add_physics_group(org.script_string, 4);
		//if (org.script_string == "junk2")
		//{
		//level thread move_lights();
		//}
	}
}

//move_lights()
//{
//	light_model = GetEnt("light_model", "targetname");
//	light = GetEnt("light3c", "script_noteworthy");
//	light_path = GetEnt("light_path", "targetname");
//
//	light_model MoveTo(light_path.origin, .3);
//	light MoveTo(light_path.origin, .3);
//	light_path = GetEnt(light_path.target, "targetname");
//	
//	while (IsDefined(light_path))
//	{
//		light_model MoveTo(light_path.origin, .3);
//		light MoveTo(light_path.origin, .3);
//		light_path = GetEnt(light_path.target, "targetname");
//	}
//}

elevator(skipto)
{
	if (!IsDefined(skipto))
	{
		skipto = false;
	}

	if (!IsDefined(level.flag["elevator_up"]))
	{
		flag_init("elevator_up");
	}

	pseudo_floor = GetEnt("elevator_pseudo_floor", "targetname");
	pseudo_floor NotSolid();

	level.elevator_car = GetEnt("elevator_car", "targetname");

	if (!skipto)
	{
		//trigger_wait("trig_get_in_elevator");
		//wait(3);
		waittill_aigroupcleared("group2");
	}

	level thread elevator_go_up(level.elevator_car, skipto);
		
	//Start House String Music - Added by crussom
	level notify("playmusicpackage_house_quiet");

	level.elevator_car waittill("movedone");
	flag_set("elevator_up");

	//iPrintLnBold("elevator up");

	pseudo_floor Solid();

	if (!skipto)
	{
		level thread shake_building(1, .3);
	}

	level.elevator_tower = GetEnt("elevator_tower", "targetname");
	level.elevator_car LinkTo(level.elevator_tower);

	if (!skipto)
	{
		wait 1;

		// DEMO - removed //////////////////////////////////////////////
		level.gettler stop_magic_bullet_shield();
		waittillframeend;
		level.gettler delete();
		// !DEMO ///////////////////////////////////////////////////////
	}
	else
	{
		vesper_spawner = GetEnt("vepser_spawner_gettler_end", "targetname");
		level.vesper = vesper_spawner StalingradSpawn("vesper");
		//level.vesper gun_remove();
	}

	level.vesper SetGoalPos(level.vesper.origin);

	if (!skipto)
	{
		wait 2;
	}

	// DEMO - removed /////////////////////////////////////////
	level.vesper LinkTo(level.elevator_car);
	// !DEMO //////////////////////////////////////////////////
	level.elevator_tower elevator_crash_down(skipto);
}

elevator_go_up(car, skipto)
{
	if (!IsDefined(skipto))
	{
		skipto = false;
	}

	ent = undefined;

	if (!skipto)
	{
		// DEMO - removed //////////////////////////////////////
		level.gettler LinkTo(level.elevator_car);
		level.vesper LinkTo( level.elevator_car );
		// !DEMO ///////////////////////////////////////////////

		//wait 2;
	}

	//iPrintLn("going up");

	movetime = 10;
	accel = 2;
	decel = 2;

	if (skipto)
	{
		movetime = .01;
		accel = 0;
		decel = 0;
	}

	car PlaySound("GET_elevator_move");
	
	

	if (!skipto)
	{
		level thread shake_building(1, .2);
	}

	// DEMO - added //////////////////////////////////////
	light = GetEnt("elevator_car_light", "targetname");
	light MoveZ(400, movetime, accel, decel);
	light thread light_flicker(true, 2, 3);
	//light EnableLinkTo();
	//light LinkTo(level.elevator_car);
	// !DEMO /////////////////////////////////////////////

	level notify("elevator_moving_up");
	car MoveZ(400, movetime, accel, decel);
	wait movetime;
	//car waittill("movedone");
	light light_flicker(false, 2);

	if (!skipto)
	{
		level thread shake_building(1.5, .25);
	}
}

//elevator_sparks()
//{
//	level notify("fx_elevator_sparks");
//}

elevator_crash_down(skipto)
{
	if (!IsDefined(skipto))
	{
		skipto = false;
	}

	destroy = GetEnt("elevator_destroy", "targetname");
	beam = GetEnt("beampiece", "script_noteworthy");
	board1 = GetEnt("elevator_crash_board1", "targetname");
	board2 = GetEnt("elevator_crash_board2", "targetname");
	board3 = GetEnt("elevator_crash_board3", "targetname");

	if (!skipto)
	{
		trig = GetEnt("elevator_crash", "targetname");
		trig waittill("trigger");
		//iPrintLn("elevator crash down");

		level thread elevator_splash_fx();
		maps\gettler_water::surface_fx();

		light = GetEnt("elevator_car_light", "targetname");
		light thread light_flicker(true, 1.5, 3);

		tilt_org = GetEnt("elevator_crash_tilt", "targetname");
		level thread tilt_building_scripted(tilt_org.angles, 3, true);
		level thread maps\gettler::super_tilt();

		self PlaySound("GET_elevator_tilt");
		//wait 1.5;
		wait .5;
		light light_flicker(false, 0);

		//wait 1.5;
		level notify("fx_elevator_sparks");
		//wait 1.5;
	
	}

	angle = 35;
	time = 2;
	accel = 1;

	if (skipto)
	{
		time = .01;
		accel = 0;
	}

	self RotatePitch(angle, time, accel);
	level notify("elevator_falling");

	// stop vesper dialog loop and play a specific vo
	if( IsDefined( level.vesper ) )
	{
		level.vesper notify( "stop_vesper_dialogue" );
		level.vesper PlaySound( "VESP_GettG_073A" );
	}

	self waittill("rotatedone");
	self PlaySound("GET_elevator_impact");

	// put vesper in anim
	if( IsDefined(level.vesper) )
	{
		level.vesper thread vesper_elev_anim_loop();
	}

	level notify("elevator_fall_start");
	//Playfx(level._effect["gettler_falling_debris03"], GetEnt("falling_debris", "targetname").origin);
	exploder(destroy.script_exploder);

	// kill guys that are right under the elevator
	ai = GetAIArray("axis");
	damage = GetEnt("elevator_damage", "targetname");
	for (i = 0; i < ai.size; i++)
	{
		if (ai[i] IsTouching(damage))
		{
			ai[i] DoDamage(300, ai[i].origin);
		}
	}

	//level.vesper show_label("Screaming!", "talk", 3); // TODO: Play Dialog


	//Start Climax Music - Added by crussom
	level notify("playmusicpackage_house");
	
	if (!skipto)
	{
		level.player allowStand(false);
		//level.player ShellShock("ac130", 3);
		level thread shake_building(2, .4);
	}

	angle = 35;
	time = 2.5;
	accel = 2.5;

	if (skipto)
	{
		time = .01;
		accel = 0;
	}

	board1 RotateRoll(40, .3, .3);

	angle = 35;
	time = 2.5;
	accel = 2.5;

	if (skipto)
	{
		time = .01;
		accel = 0;
	}

	if (!skipto)
	{
		wait .2;
	}

	angle = 30;
	time = .7;
	accel = .4;

	if (skipto)
	{
		time = .01;
		accel = 0;
	}

	beam RotateRoll(angle, time, accel);

	if (!skipto)
	{
		wait .2;
	}

	angle = 25;
	time = .3;
	accel = .3;

	if (skipto)
	{
		time = .01;
		accel = 0;
	}

	board2 RotatePitch(angle, time, accel);
	board2 waittill("rotatedone");

	angle = -15;
	time = .3;
	accel = .3;

	if (skipto)
	{
		time = .01;
		accel = 0;
	}

	board3 RotatePitch(angle, time, accel);

	if (!skipto)
	{
		wait 2;
		level.player allowStand(true);
		level._sea_flip_rotation = false;
	}

	wait(10);
	if( IsDefined(level.vesper) )
	{
		level.vesper thread vesper_elevator_dialog();
	}
}

elevator_splash_fx()
{
	splash = GetEnt("elevator_splash_fx1", "targetname");
	Playfx(level._effect["gettler_airbag_burst1"], splash.origin);
	splash PlaySound("GET_bag_explode", "sounddone");

	wait .5;

	splash = GetEnt("elevator_splash_fx2", "targetname");
	Playfx(level._effect["gettler_airbag_burst1"], splash.origin);
	splash PlaySound("GET_bag_explode", "sounddone");

	wait 1.2;
	
	splash = GetEnt("elevator_splash_fx3", "targetname");
	Playfx(level._effect["gettler_airbag_burst1"], splash.origin);
	splash PlaySound("GET_bag_explode", "sounddone");
	
	splash = GetEnt("elevator_splash_fx4", "targetname");
	Playfx(level._effect["gettler_airbag_burst1"], splash.origin);
	//splash PlaySound("GET_bag_explode", "sounddone");
}

pulley()
{
	pulley = GetEnt("pulley", "targetname");
	boards = GetEnt("boards", "targetname");
	boards LinkTo(pulley);

	waittillframeend;
	pulley.link.setscale = .5;
	level waittill("shaking");
	//pulley.link.setscale = 3;

	spark_org = GetEnt("control_panel_spark", "targetname");
	trig = GetEnt( "pulley_trig", "targetname" );

	level thread control_panel_sparks(spark_org, trig);

	trig waittill( "trigger" );
	trig delete();

	level notify("turn_off_control_panel_light");

	level thread spark(spark_org.origin);
	level thread pulley_activate();

	//trig = GetEnt("pulley_trig", "targetname");
	//maps\_playerawareness::setupEntSingleUseOnly(trig, ::pulley_activate, "Push Button to Lower the Pulley", 0, "", true, true, undefined, level.awarenessMaterialElectric, true, false, false);
}

control_panel_sparks(spark_org, trig)
{
	trig endon("trigger");

	while (true)
	{
		level thread spark(spark_org.origin);
		wait 2;
	}
}

pulley_activate(awarenessObject)
{
	pulley = GetEnt("pulley", "targetname");
	boards = GetEnt("boards", "targetname");

	//pulley PlaySound("GET_pulley_activate", "sounddone");

	//pulley waittill("sounddone");
	pulley PlaySound("GET_pulley_fall");

	pulley Unlink();

	/////
	//pulley MoveZ(-120, 2, 2);
	//
	//pulley waittill("movedone");
	/////

	///////Jeremy's version
	pulley movez(-30, 2, 0.2, 1.8);
	pulley thread crane_fx_controller();
	pulley waittill("movedone");

	Playfx(level._effect["gettler_falling_debris07"], pulley.origin ); //using effect from gettler_fx.gsc
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (0,50,0)  ); //using effect from gettler_fx.gsc
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (10,-50,0)  ); //using effect from gettler_fx.gsc

	pulley movez(-90, 0.7, 0.5, 0.2);
	pulley thread crane_fx_controller();          
	wait(0.5);
	Playfx(level._effect["watersplash_large"], boards.origin + (0,0,-100)  ); //using effect from gettler_fx.gsc
	//level thread maps\gettler::bag_explode_sound(boards.origin);
	//Playfx(level._effect["gettler_airbag_burst1"], boards.origin + (0,0,-100));

	pulley waittill("movedone");
	Playfx(level._effect["gettler_falling_debris07"], pulley.origin ); //using effect from gettler_fx.gsc
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (20,0,5)  ); //using effect from gettler_fx.gsc
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (80,0,0)  ); //using effect from gettler_fx.gsc
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (-40,0,5)  ); //using effect from gettler_fx.gsc
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (0,50,0)  ); //using effect from gettler_fx.gsc
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (10,-50,0)  ); //using effect from gettler_fx.gsc

	Playfx(level._effect["venice_water_disturb06"], boards.origin + ( 0, 0,-4)  ); //using effect from gettler_fx.gsc

	////////

	level thread shake_building(1, .3);

	boards Unlink();
	boards RotatePitch(15, .3, .3);
	boards waittill("rotatedone");

	//pulley.link.setscale = 7.5;
	boards LinkTo(pulley);

	flag_set("pulley_lowered");
	level thread before_jump();
	level thread jump();

	////added - wobble
	pulley RotateYaw(10, 1, 0, .8);
	pulley waittill("rotatedone");
	pulley RotateYaw(-20, 1, 0, .8);
	pulley waittill("rotatedone");
	pulley RotateYaw(20, 2, 0, 1.2);
	pulley waittill("rotatedone");
	pulley RotateYaw(-10, 2, 0, 1.2);
	pulley waittill("rotatedone");
	////

	pulley LinkTo(pulley.link);


	//SaveGame("gettler");
	level thread maps\_autosave::autosave_now("gettler");

	flag_wait("player_4th_floor");
	pulley.link.setscale = 1;
}

// Jeremy's goodness
crane_fx_controller()
{
	Playfx(level._effect["gettler_falling_debris01"], self.origin ); //using effect from gettler_fx.gsc

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin ); //using effect from gettler_fx.gsc

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); //using effect from gettler_fx.gsc

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); //using effect from gettler_fx.gsc

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); //using effect from gettler_fx.gsc

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); //using effect from gettler_fx.gsc
}

before_jump()
{
	boards = GetEnt("boards", "targetname");
	trig = GetEnt("jumping_pulley_gap", "targetname");
	if (IsDefined(trig))
	{
		trig waittill("trigger");
	}

	level thread maps\gettler::bag_explode_sound(boards.origin);
	Playfx(level._effect["gettler_airbag_burst1"], boards.origin + (0, 80, -100));

	wait .5;

	level thread maps\gettler::bag_explode_sound(boards.origin);
	Playfx(level._effect["gettler_airbag_burst1"], boards.origin + (0, -80, -100));
}

jump()
{
	trig = GetEnt("jumping_pulley_gap_jump", "targetname");
	if (IsDefined(trig))
	{
		trig waittill("trigger");
	}
}

spark(origin)
{
	sound_ent = Spawn("script_origin", origin);
	sound_ent PlaySound("GET_spark", "sounddone");
	for (i = 0; i < 7; i++)
	{
		Playfx(level._effect["switchbox_spark"], origin); //spark!
		waittillframeend;
	}

	sound_ent waittill("sounddone");
	sound_ent delete();
}

save_game()
{
	self waittill("trigger");

	//ratio = level.player.health / level.player.maxHealth;
	//if( ratio < 0.5  )
	//{
	//	level.player setnormalhealth( level.player.maxHealth / 2 );
	//}

	//SaveGame("gettler");

	maps\_autosave::autosave_by_name("gettler");
}

killspawner_trig()
{
	ents = GetEntArray(self.target, "targetname");
	for (i = 0; i < ents.size; i++)
	{
		ents[i] delete();
	}
}

// Group Spawners - this is the old way, now I'm using stuff from _spawner.gsc

//group_spawner()
//{
//	if (!IsDefined(self.script_int) || (self.script_int == 0))
//	{
//		self trigger_off();
//	}
//
//	GetEntArray(self.target, "targetname", self.spawners);
//	array_thread(self.spawners, ::monitor_spawned, self);
//
//	//if (IsDefined(trig.script_string))
//	//{
//	//	thread_notify(trig, %trigger) cancel_spawn(trig); 
//	//}
//
//	self waittill("done_spawning");
//
//	if (IsDefined(self.script_string))
//	{
//		while (self.spawned.size > 0)
//		{
//			wait(.5);
//		}
//
//		next = GetEnt(self.script_string, "script_noteworthy");
//		if (IsDefined(next))
//		{
//			next trigger_on();
//		}
//	}
//}
//
//monitor_spawned(trig)
//{
//	self.count++;	// so it stays alive
//	self waittill("spawned", spawned);
//
//	if (!IsDefined(trig.spawned))
//	{
//		trig.spawned = [];
//	}
//
//	trig.spawned[trig.spawned.size] = spawned;	// add to spawned
//	array_remove(trig.spawners, spawned);				// remove from spawners
//
//	if (!trig.hostage_spawners.size)
//	{
//		trig notify("done_spawning");
//	}
//
//	spawned waittill("death");
//	array_remove(trig.spawned, spawned);
//	self delete();	// delete the spawner
//}

// can't do this because we can't grab triggers based on "script_uniquename"
//cancel_spawn(entity trig)
//{
//	waittill(trig, %done_waitting);
//	entity_array cancel_trigs;
//	GetEntArray(trig.script_string, %script_uniquename, cancel_trigs);
//	FOR_EACH(entity_array, cancel_trigs)
//	{
//		_util::trigger_off(*_it);
//		notify(*_it, %done_spawning);
//		waittill(*_it, %done_waitting);
//	}
//}

//
// destruction - setup destruction exploders to trigger when the building shakes
//
destruction()
{
	if (!IsDefined(level.destruction_chunks))
	{
		level.destruction_chunks = [];
	}

	// organize chunks by script_int
	chunks = GetEntArray("destruction", "targetname");
	for (i = 0; i < chunks.size; i++)
	{
		assertex(IsDefined(chunks[i].script_int), "destruction must always specify what level it's on with a 'script_int' value");
		if (!IsDefined(level.destruction_chunks[chunks[i].script_int]))
		{
			level.destruction_chunks[chunks[i].script_int] = [];
		}

		if (!IsDefined(chunks[i].script_noteworthy))// if it has a script_noteworthy, than we leave it out of the automatic system so we can script it
		{
			level.destruction_chunks[chunks[i].script_int] = array_add(level.destruction_chunks[chunks[i].script_int], chunks[i]);
		}
	}
}

// oxytank - make sure player triggers it
oxy_tank()
{
	flag_wait("player_on_platform");
	maps\_playerawareness::setupEntSingleDamageOnlyNoWait(self, ::oxy_tank_explode, true, maps\_playerawareness::awarenessFilter_PlayerOnlyDamage, level.awarenessMaterialMetal, true, false);
}

oxy_tank_explode(trig)
{
	ai = GetAIArray("axis");
	for (i = 0; i < ai.size; i++)
	{
		if (IsDefined(ai[i].script_noteworthy) && (ai[i].script_noteworthy == "ai_gettler_propane_splode"))
		{
			ai[i] invalidategoal();
		}
	}

	tank = GetEnt("oxytank", "targetname");
	//physics_explosion = GetEnt("tank_physics_explosion", "targetname");
	origin = tank.origin;
	exploder(tank.script_exploder);	// trigger exploder
	level notify("walkway_explode_start");
	//wait .05;
	//PhysicsExplosionSphere(physics_explosion.origin, 300, 200, 5);

	// kill ai & player if he's near the splosion
	entaRedshirts = GetAIArray( "axis" );
	for( i = 0; i < entaRedshirts.size; i++ )
	{
		if( Distance( origin, entaRedshirts[i].origin ) < 300 )
		{
			entaRedshirts[i] DoDamage( 10000, (0, 0, 0) );
		}
	}
	if( Distance( origin, level.player.origin ) < 225 )
	{
		level.player DoDamage( 10000, (0, 0, 0) );
	}

	// Play Sound
	sound_ent = Spawn("script_origin", origin);
	sound_ent PlaySound("GET_tank_explode", "sounddone");
	wait 1.5;
	level notify("oxy_tank_explode");
	sound_ent waittill("sounddone");
	sound_ent delete();
	// TEMP: fixes broken RadiusDamage

	//ai = GetAIArray("axis");
	//for (i = 0; i < ai.size; i++)
	//{
	//	if (Distance(ai[i].origin, tank.origin) < 400)
	//	{
	//		ai[i] DoDamage(1000, ai[i].origin);
	//	}
	//}

	///////////////////////////////////////////

	//maps\gettler_util::radius_damage(tank.origin, 300, 400, 200);

	shake_building(2);
}

//*******exploder callbacks*******//

/*
stair_chunk(chunk)
{
trig = GetEnt("stairs_trigger", "script_noteworthy");
trig waittill("trigger");

other_trig = GetEnt("stair_exploder_trigger", "script_noteworthy");
if (IsDefined(other_trig))
{
other_trig notify("trigger");	// tigger the lookat trigger for the collapsing stairs to make sure it fires even if the player hasn't looked at it.
}

exploder(GetEnt("exploder10", "targetname").script_exploder);	// exploder that opens up path for guys on the first floor to run up to the bag

chunk = GetEnt("stair_chunk_1", "script_noteworthy");
chunk2 = GetEnt("stair_chunk_2", "script_noteworthy");
chunk LinkTo(chunk2);

chunk2 RotatePitch(25, .5, .5);
chunk2 waittill("rotatedone");

chunk Unlink();
chunk RotatePitch(70, .5, .5);
}
*/

script_contraint()
{
	//self endon("broken");
	//
	//force_ent = GetEnt(self.target, "targetname");
	//primary_ent = GetEnt(force_ent.target, "targetname");
	//
	//other_constraint = undefined;
	//if (IsDefined(self.target2))
	//{
	//	other_constraint = GetEnt(self.target2, "targetname");
	//}
	//	
	//self SetCanDamage(true);
	//self waittill("damage");
	self waittill("trigger");

	// notify to start fx
	level notify( "gondola_fall_start" );

	//self Hide();

	//if (IsDefined(other_constraint))
	//{
	//	//other_constraint delete();	// TODO: play FX on other_constraint
	//	other_constraint notify("broken");
	//}

	// wait a sec and do radius damage in effect areas
	wait( 1 );
	RadiusDamage((2960, -528, 160), 128, 500, 200);
	PhysicsExplosionSphere((2960, -528, 160), 256, 128, 2);
	RadiusDamage((2960, -720, 160), 128, 500, 200);
	PhysicsExplosionSphere((2960, -720, 160), 256, 128, 2);
	RadiusDamage((2952, -856, 160), 128, 500, 200);
	PhysicsExplosionSphere((2952, -856, 160), 256, 128, 2);

	//force_amount = 1; // TODO: make this editable
	//
	//num_frames = 2;  // TODO: change to time?
	//for (i = 0; i < num_frames; i++)
	//{
	//	primary_ent PhysicsLaunch(force_ent.origin, vector_multiply(force_ent.angles, force_amount));
	//	wait .05;
	//}

	//wait 1;
	//RadiusDamage(primary_ent.origin, 300, 500, 200);
	//PhysicsExplosionSphere(primary_ent.origin, 400, 300, 2);
	//maps\gettler_util::radius_damage(primary_ent.origin, 300, 400, 200);

	//wait 2;
	//primary_ent delete();
}

fog()
{
	self waittill("trigger");

	//SetExpFog(“fog near plane”, “fog half plane”, “fog red”, “fog green”, “fog blue”, “Lerp time”, “Fog max”);

	if (self.script_int == 0)
	{
		setExpFog(0, 4600, 0.58, 0.60, 0.52, 2.0, 0.55);
	}
	else if (self.script_int == 1)
	{
		setExpFog(534.1, 1651.85, 0.5, 0.5, 0.5, 2.0, 0.65);
	}
}

//
// interaction_hud - display for the player to open doors
//
setup_interaction_hud()
{
	level.interaction_hud = newHudElem();
	level.interaction_hud.x = 0;
	level.interaction_hud.y = 0;
	level.interaction_hud.alignX = "center";
	level.interaction_hud.alignY = "middle";
	level.interaction_hud.horzAlign = "center";
	level.interaction_hud.vertAlign = "middle";
	level.interaction_hud.foreground = true;
	level.interaction_hud.fontScale = 1.5;
	level.interaction_hud.alpha = 1.0;
	level.interaction_hud.color = (1, 1, 1);
	level.interaction_hud.inuse = false;
}

interaction_node()
{
	if (IsDefined(self.script_noteworthy) && (self.script_noteworthy == "interaction"))
	{
		radius = 25;
		if (IsDefined(self.radius))
		{
			radius = self.radius;
		}

		trig = Spawn("trigger_radius", self.origin, 0, radius, 100);

		if (IsDefined(self.script_flag_set))
		{
			flag_init(self.script_flag_set);
		}

		if (IsDefined(self.script_flag_true))
		{
			flag_wait(self.script_flag_true);
		}

		trig interaction(self);
	}
}

//
// interaction_node - handle player interaction at iteraction nodes
//
interaction(node)
{
	self endon("player_interaction_cancel");
	self waittill("trigger");

	while (true)
	{
		if (can_interact(node))
		{
			self thread player_interaction(node);
		}
		else
		{
			self thread clear_interaction(node);
		}

		wait .2;
	}
}

//
// clear - clear the door hud and re-thread the player function
//
clear_interaction(node)
{
	level.interaction_hud settext("");
	self notify("player_interaction_cancel");
	self thread interaction(node);
}

//
// can_interact - test to see if the player is in position to do the interaction
//
can_interact(node)
{
	dot = VectorDot(AnglesToForward(node.angles), AnglesToForward(level.player.angles));
	if ((!level.player IsTouching(self)) || (dot < .6))
	{
		return false;
	}
	return true;
}

//
// player_open - prompt the player to interact and handle the button press
//
player_interaction(node)
{
	self endon("player_interaction_cancel");

	//level.interaction_hud settext("Use");
	//while (!level.player usebuttonpressed())
	//{
	//	wait .05;
	//}

	// set a flag when the player interacts
	if (IsDefined(node.script_flag_set))
	{
		flag_set(node.script_flag_set);
	}

	if (IsDefined(node.script_string))
	{
		level notify(node.script_string);
	}

	// TODO: make a way to register "callback" functions

	//if (IsDefined(node.target))
	//{
	//	target = GetEnt(node.target, "targetname");
	//	if (IsDefined(target))
	//	{
	//		if (IsDefined(target.script_noteworthy))
	//		{
	//			if (target.script_noteworthy == "scripted_player_sequence")
	//			{
	//				level thread scripted_player_sequence(target, node);
	//			}
	//		}
	//	}
	//}

	self clear_interaction(node);
	//player_god_off();
}

pillars_side_gate()
{
	while (true)
	{
		self waittill("open"); // will be doors
		//self waittill("trigger"); // triggers for now

		//iPrintLnBold("Gate Creaking!");
		//iPrintLnBold("Enemy Upstairs - Look Out!");

		self waittill("closed");
		//wait 3;
	}
}

lights_off_trigger()
{
	self waittill("trigger");
	lights = strtok(self.script_parameters, ",");
	for(i = 0; i < lights.size; i++)
	{
		light = GetEnt(lights[i], "script_noteworthy");
		if (IsDefined(light))
		{
			if (!IsDefined(light.light_intensity_start))
			{
				light.light_intensity_start = light GetLightIntensity();
			}

			//Print3d(light.origin, "turing light off", (1, 0, 0), 1, 4, 500);
			light SetLightIntensity(0);
		}
	}
}

lights_on_trigger()
{
	self waittill("trigger");
	lights = strtok(self.script_parameters, ",");
	for(i = 0; i < lights.size; i++)
	{
		light = GetEnt(lights[i], "script_noteworthy");
		if (IsDefined(light))
		{
			if (IsDefined(light.light_intensity_start))
			{
				//Print3d(light.origin, "turing light on", (0, 1, 0), 1, 4, 500);
				light SetLightIntensity(light.light_intensity_start);
			}
		}
	}
}

viewbob_on()
{
	trig = GetEnt("viewbob_on", "targetname");
	while (IsDefined(trig))
	{
		trig waittill("trigger");
		VisionSetNaked("gettler_house", 3);
		flag_set("_sea_viewbob");
		//flag_set("cargoship_lighting_off");	// this turns it on!
		flag_waitopen("_sea_viewbob");
	}
}

viewbob_off()
{
	trig = GetEnt("viewbob_off", "targetname");
	while (IsDefined(trig))
	{
		trig waittill("trigger");
		VisionSetNaked("default_glow", 1);
		flag_clear("_sea_viewbob");
		flag_clear("cargoship_lighting_off");	// this turns it off!
		flag_wait("_sea_viewbob");
	}
}

break_trig()
{
	destruction = GetEntArray(self.script_noteworthy, "script_noteworthy");
	for (i = 0; i < destruction.size; i++)
	{
		if (destruction[i] != self)
		{
			level thread trigger_destruction(destruction[i], self);
		}
	}

	if (self.script_noteworthy == "wall_exploder1")
	{
		level.shoot_at_bags_guy_kill_trig = self;
	}
}

stop_music()
{
	self waittill("trigger");
	MusicStop(0);
}


// mql 3/14: add holster and unholster weapon triggers
holster()
{
	while (true)
	{
		self waittill("trigger");
		holster_weapons();
		level waittill("weapons_unholstered");
	}
}

unholster()
{
	while (true)
	{
		self waittill("trigger");
		unholster_weapons();
		level waittill("weapons_holstered");
	}
}

fall_into_water()
{
	self waittill("trigger");
	//missionFailedWrapper();
	level.player DoDamage( 10000, (0, 0, 0) );
}

// mql 4/21/08: add physics for shutters
physics_shutters()
{
	// check for valid shutters
	if( !IsDefined( self.target ) )
	{
		return;
	}

	// get shutter positions
	entShutters = GetEntArray( self.target, "targetname" );

	while( true )
	{
		if( level.player IsTouching(self) )
		{
			for( i = 0; i < entShutters.size; i++ )
			{
				wait( randomfloatrange( 2.5, 7 ) );
				if((IsDefined(entShutters[i].script_int)) && ( entShutters[i].script_int > 0 ))
				{
					PhysicsJolt( entShutters[i].origin, entShutters[i].script_int, (entShutters[i].script_int / 2), vector_multiply(entShutters[i].angles, 0.0001) );
				}
				else
				{
					PhysicsJolt( entShutters[i].origin, 128, 64, vector_multiply(entShutters[i].angles, 0.0001) );
				}
			}
			for( i = 0; i < entShutters.size; i++ )
			{
				wait( randomfloatrange( 2.5, 7 ) );
				if((IsDefined(entShutters[i].script_int)) && ( entShutters[i].script_int > 0 ))
				{
					PhysicsJolt( entShutters[i].origin, entShutters[i].script_int, (entShutters[i].script_int / 2), vector_multiply(entShutters[i].angles, -0.0001) );
				}
				else
				{
					PhysicsJolt( entShutters[i].origin, 128, 64, vector_multiply(entShutters[i].angles, -0.0001) );
				}
			}
		}
		else
		{
			wait( 0.25 );
		}
	}
}


// mql 4/29/08: add auto notification for fx based on triggers
fx_notify()
{
	if(!IsDefined(self))
		return;

	self waittill( "trigger" );

	if( IsDefined( self.script_noteworthy ) )
		level notify( self.script_noteworthy );
}

// mql 5/1/08: change minimap
phone_map_change()
{
	if( !IsDefined( self.script_noteworthy ) )
	{
		return;
	}

	while( true )
	{
		self waittill( "trigger" );

		SetSavedDVar( "sf_compassmaplevel", self.script_noteworthy );

		wait( 0.25 );
	}
}

// mql 5/8/08: ambient vo
ambient_vo()
{
	// check for valid script_origin targets
	if( !IsDefined( self.target ) )
	{
		return;
	}
	if( !IsDefined( self.script_noteworthy ) )
	{
		return;
	}

	// get array of origins
	entSpeaker = GetEntArray( self.target, "targetname" );
	if( entSpeaker.size < 1 )
	{
		return;
	}
	else
	{
		iMaxSpeaker = entSpeaker.size - 1;
		iCount = 0;
	}

	if (self.script_noteworthy == "two_mix_b")
	{
		// male talks first, so make sure his "speaker" is the first in the array
		assertex(entSpeaker.size == 2, "speaker count doesn't match conversation.");
		if (IsDefined(entSpeaker[0].script_int) && entSpeaker[0].script_int)	// script_int means female
		{
			// swap
			temp = entSpeaker[0];
			entSpeaker[0] = entSpeaker[1];
			entSpeaker[1] = temp;
		}
	}

	self.vo_exhausted = false;

	// loop to check if player within distance to start sound
	while( IsDefined(entSpeaker[iCount]) && !self.vo_exhausted )
	{
		self waittill("trigger");

		//print3d(entSpeaker[iCount].origin, "-", (1,1,1), 1, 1, 60);
		drone = maps\_utility::find_closest_drone(entSpeaker[iCount].origin);
		if( isdefined(drone) )
		{
			drone.doFacialAnim = true;

			//print3d(entSpeaker[iCount].origin, "!", (1,1,1), 1, 1, 60);
		}

		//iprintlnbold("noteworthy: " + self.script_noteworthy);

		switch(self.script_noteworthy)
		{
		case "two_male":
			entSpeaker[iCount] vo_two_male(self, drone);
			break;

		case "two_female":
			entSpeaker[iCount] vo_two_female(self, drone);
			break;

		case "phone_male":
			entSpeaker[iCount] vo_phone_male(self, drone);
			break;

		case "phone_female":
			entSpeaker[iCount] vo_phone_female(self, drone);
			break;

		case "two_mix_a":
			entSpeaker[iCount] vo_two_mix_a(self, drone);
			break;

		case "two_mix_b":
			entSpeaker[iCount] vo_two_mix_b(self, drone);
			break;
		}
		iCount++;
		if( iCount > iMaxSpeaker )
		{
			iCount = 0;
		}

		if( isdefined(drone) )
		{
			drone.doFacialAnim = false;
		}
	}
}

// vo
vo_two_male(trig, drone)
{
	if( !IsDefined(level._ambient_vo_count_two_male) )
	{
		level._ambient_vo_count_two_male = 0;
	}

	iMaxLines = 5;

	if( !IsDefined(self) )
	{
		return;
	}

	if( level._ambient_vo_count_two_male > iMaxLines )
	{
		level._ambient_vo_count_two_male = 0;
		trig.vo_exhausted = true;
		return;
	}

	switch(level._ambient_vo_count_two_male)
	{
	case 0:
		self playsound("VEM1_GettG_001A", "end_ambient_vo", false);
		break;

	case 1:
		self playsound("VEM2_GettG_002A", "end_ambient_vo", false);
		break;

	case 2:
		self playsound("VEM1_GettG_003A", "end_ambient_vo", false);
		break;

	case 3:
		self playsound("VEM2_GettG_004A", "end_ambient_vo", false);
		break;

	case 4:
		self playsound("VEM1_GettG_005A", "end_ambient_vo", false);
		break;

	case 5:
		self playsound("VEM2_GettG_006A", "end_ambient_vo", false);
		break;
	}
	self waittill( "end_ambient_vo" );

	if( isdefined(drone) )
	{
		drone.doFacialAnim = false;
			//iprintlnbold("stop facial");
	}

	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_male++;
}

vo_two_female(trig, drone)
{
	if( !IsDefined(level._ambient_vo_count_two_female) )
	{
		level._ambient_vo_count_two_female = 0;
	}

	iMaxLines = 5;

	if( !IsDefined(self) )
	{
		return;
	}

	if( level._ambient_vo_count_two_female > iMaxLines )
	{
		level._ambient_vo_count_two_female = 0;
		trig.vo_exhausted = true;
		return;
	}

	switch(level._ambient_vo_count_two_female)
	{
	case 0:
		self playsound("VEW2_GettG_030A", "end_ambient_vo", false);
		break;

	case 1:
		self playsound("VEW3_GettG_031A", "end_ambient_vo", false);
		break;

	case 2:
		self playsound("VEW2_GettG_032A", "end_ambient_vo", false);
		break;

	case 3:
		self playsound("VEW3_GettG_033A", "end_ambient_vo", false);
		break;

	case 4:
		self playsound("VEW2_GettG_034A", "end_ambient_vo", false);
		break;

	case 5:
		self playsound("VEW3_GettG_035A", "end_ambient_vo", false);
		break;
	}
	self waittill( "end_ambient_vo" );

	if( isdefined(drone) )
	{
		drone.doFacialAnim = false;
			//iprintlnbold("stop facial");
	}

	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_female++;
}

vo_phone_female(trig, drone)
{
	if( !IsDefined(level._ambient_vo_count_phone_female) )
	{
		level._ambient_vo_count_phone_female = 0;
	}

	iMaxLines = 0;

	if( !IsDefined(self) )
	{
		return;
	}

	if( level._ambient_vo_count_phone_female > iMaxLines )
	{
		level._ambient_vo_count_phone_female = 0;
		trig.vo_exhausted = true;
		return;
	}

	switch(level._ambient_vo_count_phone_female)
	{
	case 0:
		self playsound("PHW1_GettG_013A", "end_ambient_vo", false);	// "... now tell me, did you call to appologize?"
		break;
	}
	self waittill( "end_ambient_vo" );

	if( isdefined(drone) )
	{
		drone.doFacialAnim = false;
			//iprintlnbold("stop facial");
	}

	wait( RandomIntRange( 2, 7 ) );
	level._ambient_vo_count_phone_female++;
}

vo_two_mix_a(trig, drone)
{
	if( !IsDefined(level._ambient_vo_count_two_mix_a) )
	{
		level._ambient_vo_count_two_mix_a = 0;
	}

	iMaxLines = 3;

	if( !IsDefined(self) )
	{
		return;
	}

	if( level._ambient_vo_count_two_mix_a > iMaxLines )
	{
		level._ambient_vo_count_two_mix_a = 0;
		trig.vo_exhausted = true;
		return;
	}

	switch(level._ambient_vo_count_two_mix_a)
	{
	case 0:
		self playsound("VEM4_GettG_007A", "end_ambient_vo", false);
		break;

	case 1:
		self playsound("VEW1_GettG_009A", "end_ambient_vo", false);
		break;

	case 2:
		self playsound("VEM4_GettG_010A", "end_ambient_vo", false);
		break;

	case 3:
		self playsound("VEW1_GettG_011A", "end_ambient_vo", false);
		break;

	//case 4:	// cut from the game apparently
	//	self playsound("VEM3_GettG_012A", "end_ambient_vo", false);
	//	break;
	}
	self waittill( "end_ambient_vo" );

	if( isdefined(drone) )
	{
		drone.doFacialAnim = false;
			//iprintlnbold("stop facial");
	}

	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_mix_a++;
}

vo_two_mix_b(trig, drone)
{
	if( !IsDefined(level._ambient_vo_count_two_mix_b) )
	{
		level._ambient_vo_count_two_mix_b = 0;
	}

	iMaxLines = 4;

	if( !IsDefined(self) )
	{
		return;
	}

	if( level._ambient_vo_count_two_mix_b > iMaxLines )
	{
		level._ambient_vo_count_two_mix_b = 0;
		trig.vo_exhausted = true;
		return;
	}

	switch(level._ambient_vo_count_two_mix_b)
	{
	case 0:
		self playsound("VEM5_GettG_036A", "end_ambient_vo", false);
		break;

	case 1:
		self playsound("VEW4_GettG_037A", "end_ambient_vo", false);
		break;

	case 2:
		self playsound("VEM5_GettG_038A", "end_ambient_vo", false);
		break;

	case 3:
		self playsound("VEW4_GettG_039A", "end_ambient_vo", false);
		break;

	case 4:
		self playsound("VEM5_GettG_040A", "end_ambient_vo", false);
		break;
	}
	self waittill( "end_ambient_vo" );

	if( isdefined(drone) )
	{
		drone.doFacialAnim = false;
			//iprintlnbold("stop facial");
	}

	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_mix_b++;
}

// battlechatter - vo
battlechatter_vo()
{
	if (!isdefined(level.flag["battle_chatter"]))
	{
		flag_init("battle_chatter");
	}

	if (!isdefined(level.flag["enable_battle_chatter"]))
	{
		flag_init("enable_battle_chatter");
	}

	flag_set("enable_battle_chatter");

	if( !IsDefined( self.script_noteworthy ) )
	{
		return;
	}

	while( IsDefined( self ) )
	{
		flag_wait("enable_battle_chatter");
		self waittill( "trigger" );

		if (!flag("battle_chatter"))
		{
			aiTemp = get_active_enemy();

			if( IsDefined( aiTemp ) && (aiTemp GetAlertState() != "alert_green"))
			{
				flag_set("battle_chatter");
				//aiTemp PlaySound( self.script_noteworthy );
				aiTemp play_dialogue(self.script_noteworthy);
				//wait 3;
				flag_clear("battle_chatter");
			}

			wait( RandomIntRange( 45, 60 ) );
		}
		else
		{
			wait 3;
		}
	}
}

// function to make an ememy shoot the gondola down if the player is under it and hasn't already shot it down
under_gondola()
{
	level endon("gondola_drop");
	self waittill("trigger");

	trig = GetEnt("gondola_pointers", "targetname");
	if (!flag("gondola_drop"))
	{
		// Get random entity
		point_guy = undefined;
		ai = GetAIArray("axis");
		for (i = 0; i < ai.size; i++)
		{
			if (ai[i] IsTouching(trig))
			{
				point_guy = ai[i];
				point_guy thread gondola_pointer();
				break;
			}
		}

		wait 3;

		ai = array_randomize(ai);
		for (i = 0; i < ai.size; i++)
		{
			if (!IsDefined(point_guy) || (ai[i] != point_guy))
			{
				level thread gondola_shooter(ai[i]);
				break;
			}
		}
	}
}

gondola_pointer()
{
	//Point at gondola
	self CmdPlayAnim("Thug_Point2Gondola");
}

gondola_shooter(shooter)
{
	trig = GetEnt("script_constraint", "script_noteworthy");
	trig thread gondola_shooter_failsafe(shooter);	// we don't need this if we put a permanent bridge accross the canal
	shooter CmdShootAtEntity(trig, false, 2, 100);
}

gondola_shooter_failsafe(shooter)
{
	level endon("gondola_drop");
	shooter waittill("death");
	self notify("trigger");
}

civ_zone()
{
	while (true)
	{
		self waittill("trigger");

		while (level.player IsTouching(self))
		{
			if (level.player AttackButtonPressed())
			{
				maps\_utility::missionFailedWrapper();
			}

			wait .05;
		}
	}
}

kill_boat_yard_window_guy()
{
	self waittill("trigger");
	guy = GetEnt("boat_yard_window_guy", "script_noteworthy");
	if (IsDefined(guy))
	{
		guy delete();
	}
}

stop_super_tilt_trig()
{
	self waittill("trigger");
	level notify("stop_super_tilt");
}

// physics optimization
phys_group_trigger()
{
	if (!IsDefined(level.phys_group_triggers))
	{
		level.phys_group_triggers = [];
	}

	level.phys_group_triggers[level.phys_group_triggers.size] = self;

	self thread trigger_phys_group();

	while (IsDefined(self))
	{
		if (IsDefined(level.active_phys_group_trigger) && (level.active_phys_group_trigger == self))
		{
			level waittill("new_phys_group");
		}

//		self waittill("trigger");
		self waittill("phys_group_trigger");
		level notify("new_phys_group");

		//Print3d(self.origin, "Active Phys Group: " + self.script_string, (0, 1, 0), 1, .9, 100);

		level.active_phys_group_trigger = self;

		// remove other groups
		for (i = 0; i < level.phys_group_triggers.size; i++)
		{
			if (level.phys_group_triggers[i] != self)
			{
				remove_group = level.phys_group_triggers[i].script_string;
				maps\_sea::sea_remove_physics_group(remove_group, true);
			}
		}

		maps\_sea::sea_add_physics_group(self.script_string, 1.5);
	}
}

trigger_phys_group()
{
	while (IsDefined(self))
	{
		self waittill("trigger");
		
		eye = level.player GetEye();
		dot = VectorDot(AnglesToForward(level.player GetViewAngles()), VectorNormalize(self.origin - eye));
		
		if (dot > .6)
		{
			self notify("phys_group_trigger");
		}

		wait .05;
	}
}

#using_animtree( "vehicles" );
boat_float()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	self UseAnimTree(#animtree);
	//self SetAnim( %v_boat_float, 1.0, 1.0, 1.0 );
	//self SetAnimKnob( %v_boat_float, 1.0, 1.0, 1.0 );
	self setFlaggedAnimKnobRestart( "idle", %v_boat_float );
}

#using_animtree( "generic_human" );
vo_phone_male(trig, drone)
{
	if (!IsDefined(self.ok_to_talk) || !self.ok_to_talk)
	{
		self waittill("talk");
	}

	if( !IsDefined(level._ambient_vo_count_phone_male) )
	{
		level._ambient_vo_count_phone_male = 0;
	}

	iMaxLines = 1;

	if( !IsDefined(self) )
	{
		return;
	}

	if( level._ambient_vo_count_phone_male > iMaxLines )
	{
		level._ambient_vo_count_phone_male = 0;
		trig.vo_exhausted = true;
		return;
	}

	switch(level._ambient_vo_count_phone_male)
	{
	case 0:
		self setFlaggedAnimKnobRestart("face", %Thu_Fac_Speak, 1.0, 0.1, 1.0 );
		self playsound("PHM2_GettG_041A", "end_ambient_vo", false);	// "And how did he seem, was he happy? ... "
		break;

		//case 1:	//apparently cut form the game
		//	self playsound("PHM1_GettG_007A", "end_ambient_vo", false);	// "It's got everything we've been looking for..."
		//	break;
	}
	self waittill( "end_ambient_vo" );
	self clearAnim( %Thu_Fac_Speak, 0.0 );

	wait( RandomIntRange( 2, 7 ) );
	level._ambient_vo_count_phone_male++;
}