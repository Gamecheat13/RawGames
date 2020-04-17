#include maps\_utility;
#include maps\gettler_util;

main()
{
	
	level.spawnerCallbackThread = ::spawn_think;

	all_spawners = GetSpawnerArray();
	array_thread(all_spawners, ::spawner_think);
	
	
	setup_interaction_hud();
	array_thread(GetNodeArray("interaction", "script_noteworthy"), ::interaction_node);
	
	array_thread(GetEntArray("fog", "targetname"), ::fog);
	
	array_thread(GetEntArray("gondola", "script_noteworthy"), ::gondola);
	
	if( GetDVarInt( "skip_intro" ) != 1 )
	{
		array_thread(GetVehicleNodeArray("nod_intro_gond_path", "script_noteworthy"), ::gondola_path);
	}
	
	array_thread(GetNodeArray("delete", "script_noteworthy"), ::delete_node); 
	array_thread(GetEntArray("delete", "script_noteworthy"), ::delete_trig);	

	array_thread(GetNodeArray("fire_at_target", "script_noteworthy"), ::fire_at_target_node);

	array_thread(GetEntArray("shake", "targetname"), ::shake_trig);
	array_thread(GetEntArray("tilt", "targetname"), ::tilt_trig); 
	array_thread(GetEntArray("break", "targetname"), ::break_trig);

	
	array_thread(GetEntArray("save_game", "targetname"), ::save_game);
	array_thread(GetEntArray("save_game", "script_noteworthy"), ::save_game);
	
	array_thread(GetEntArray("killspawner", "targetname"), ::killspawner_trig);	

	
	array_thread(GetEntArray("redlight", "targetname"), maps\gettler_vesper::redlight_trigger);
	
	
	
	
	array_thread(GetEntArray("pillars_side_gate", "targetname"), ::pillars_side_gate);
	
	array_thread(GetEntArray("lights_off", "targetname"), ::lights_off_trigger);
	array_thread(GetEntArray("lights_on", "targetname"), ::lights_on_trigger);

	array_thread(GetEntArray("stop_music", "script_noteworthy"), ::stop_music);

	
	array_thread(GetEntArray("trig_holster", "targetname"), ::holster);
	array_thread(GetEntArray("trig_unholster", "targetname"), ::unholster);
	array_thread(GetEntArray("death", "targetname"), ::fall_into_water );
	array_thread(GetEntArray("gondola", "script_noteworthy"), ::boat_float );
	array_thread(GetEntArray("trig_window_shutters", "targetname"), ::physics_shutters);
	array_thread(GetEntArray("trig_fx_notify", "targetname"), ::fx_notify);
	array_thread(GetEntArray("trig_phone_map_change", "targetname"), ::phone_map_change);
	array_thread(GetEntArray("trig_ambient_vo", "targetname"), ::ambient_vo);
	array_thread(GetEntArray("trig_battlechatter_vo", "targetname"), ::battlechatter_vo);
	

	
	destruction();

	
	
	

	

	
	GetEnt("oxytank_trigger", "targetname") thread oxy_tank();

	
	
	
	array_thread(GetEntArray("light", "targetname"), ::init_light);	

	

	maps\gettler_water::main();
	level thread bags();
	water_triggers();

	level thread viewbob_on();
	level thread viewbob_off();

	level thread elevator();
	level thread pulley();
	level thread control_panel_light();

	GetEnt("under_gondola", "targetname") thread under_gondola();
	
	
	

	
}


















init_light()
{
	while (true)
	{
		wait 1;
		depth = level.water.origin[2] - self.origin[2];
		if ((depth > 0) && (self GetLightIntensity() > 0))
		{
			
			self thread light_flicker();
			wait RandomIntRange(3, 6);
			self light_flicker(false, 0);
			break;
		}
	}
}

control_panel_light()
{
	light = GetEnt("control_panel_light", "targetname");

	
	flag_wait("player_3rd_floor");

	light thread light_flicker(true, 0, 2);

	level waittill("turn_off_control_panel_light");
	light light_flicker(false, 0);

	
	
	
	
	
}

spawner_think()
{
	self endon("death");

	
	
	
	
	
	
	
	
	
	
	
}




spawn_think(spawn)
{
	
	if (!spawn_failed(spawn))
	{
		
		spawn ai_think();
	}
}









ai_think()
{
	self thread maps\gettler_water::drown();

	self.grenadeAmmo = 0;	

	if (IsDefined(self.script_noteworthy))
	{
		if (self.script_noteworthy == "bag1")
		{
			self thread maps\gettler::blow_bag1();
		}
		
		else if (self.script_noteworthy == "shoot_at_bags")
		{
			self thread maps\gettler::shoot_at_bags();
			level notify("shoot_at_bags_guy_spawned");
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

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	gondola = SpawnVehicle("v_gondola_flatbottom", "spawned_gondola", "gondola", self.origin, self.angles);
	gondola.vehicletype = "gondola";
	gondola.target = self.targetname;
	gondola.bpathisdynamic = false;
	gondola thread gondola();
	gondola thread boat_float();
	gondola thread gondola_drones();
}

#using_animtree("fakeshooters");
gondola_drones()
{
	
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
	

	
	entDriver useAnimTree(#animtree);
	entMPass useAnimTree(#animtree);
	entFPass useAnimTree(#animtree);
	entDriver setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaDrive);
	entMPass setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);
	entFPass setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide_Female);

	
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
		
		gondola = SpawnVehicle("v_boat_motor_b", "spawned_gondola", "motor_boat", self.origin, self.angles);
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
	
	flag_set("bag6_ok");
	flag_set("bag7_ok");
	flag_set("bag8_ok");
	flag_set("bag9_ok");
	flag_set("bag10_ok");

	all_bags = GetEntArray("bag", "script_noteworthy");
	array_thread(all_bags, maps\gettler::bag);

	for (i = 0; i < all_bags.size; i++)
	{
		all_bags[i] LinkTo(level.water);	

		collision = GetEnt(all_bags[i].target, "targetname");
		if (IsDefined(collision))
		{
			all_bags[i].bag_collision = collision;
			collision LinkTo(all_bags[i]);	
		}
	}
	
	level thread make_bag5_ok();
	level thread maps\gettler::blow_bag2();
}

noop(ent)
{
	return;
}




make_bag5_ok()
{
	GetEnt("over_bag", "script_noteworthy") waittill("trigger");
	flag_set("bag5_ok");
	
	tilt_org = GetEnt("over_bag5_tilt", "targetname");
	level thread tilt_building(tilt_org.angles, 8);

	
	ai = get_ai_group_ai("group5");
	for (i = 0; i < ai.size; i++)
	{
		ai[i] SetTetherRadius(-1);
		ai[i] SetCombatRole("Basic");
	}

	
	piece = GetEnt("getx201", "script_noteworthy");
	
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






























fire_at_target_node()
{
	self waittill("trigger", ent);
	target = GetEnt(self.target, "targetname");

	count = 1;
	if (IsDefined(self.count))
	{
		count = self.count;
	}

	

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
	
	level thread tilt_building_scripted(angles, time, tilt_back, new_angles);
	wait time * .5;

	if (IsDefined(org.script_radius))
	{
		level thread physics_impulse(org.origin, org.script_radius, time / 2);
	}

	if (IsDefined(org.script_string))
	{
		maps\_sea::sea_add_physics_group(org.script_string, 4);
		
		
			
		
	}
}

move_lights()
{
	light_model = GetEnt("light_model", "targetname");
	light = GetEnt("light3c", "script_noteworthy");
	light_path = GetEnt("light_path", "targetname");
	
	light_model MoveTo(light_path.origin, .3);
	light MoveTo(light_path.origin, .3);
	light_path = GetEnt(light_path.target, "targetname");
	
	while (IsDefined(light_path))
	{
		light_model MoveTo(light_path.origin, .3);
		light MoveTo(light_path.origin, .3);
		light_path = GetEnt(light_path.target, "targetname");
	}
}

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
		
		door = GetNode("elevator_car_door_1", "targetname");
		door maps\_doors::open_door_from_door_node();
		
		trigger_wait("trig_get_in_elevator");

		
		
		
		
		
		
		wait(3);
	}
	
	level thread elevator_go_up(level.elevator_car, skipto);
	
	level.elevator_car waittill("movedone");
	flag_set("elevator_up");
	
	

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

		
		
		

		

		
		level.gettler stop_magic_bullet_shield();
		waittillframeend;
		level.gettler delete();
		
	}
	else
	{
		vesper_spawner = GetEnt("vepser_spawner_gettler_end", "targetname");
		level.vesper = vesper_spawner StalingradSpawn("vesper");
	}
		
	level.vesper SetGoalPos(level.vesper.origin);
		
	if (!skipto)
	{
		wait 2;
	}
	
	
	level.vesper LinkTo(level.elevator_car);
	
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
		
		
		
		
		 level.gettler LinkTo(level.elevator_car);
		 level.vesper LinkTo( level.elevator_car );
		

		
		
		
		
		
		

		door = GetNode("elevator_car_door_1", "targetname");
		
		door thread maps\_doors::close_door_from_door_node();	
		
		wait 2;
	}

	
	door1_left = GetEnt("elevator_car_door_1_left", "targetname");
	door1_right = GetEnt("elevator_car_door_1_right", "targetname");
	door2_left = GetEnt("elevator_car_door_2_left", "targetname");
	door2_right = GetEnt("elevator_car_door_2_right", "targetname");

	door1_left LinkTo(level.elevator_car);
	door1_right LinkTo(level.elevator_car);
	door2_left LinkTo(level.elevator_car);
	door2_right LinkTo(level.elevator_car);

	
	
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

	
	light = GetEnt("elevator_car_light", "targetname");
	light MoveZ(400, movetime, accel, decel);
	light thread light_flicker(true, 2, 3);
	
	
	
	
	level notify("elevator_moving_up");
	car MoveZ(400, movetime, accel, decel);
	wait movetime;
	
	light light_flicker(false, 3);

	
	
	if (!skipto)
	{
		level thread shake_building(1.5, .25);
	}
}






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
		

		light = GetEnt("elevator_car_light", "targetname");
		light thread light_flicker(true, 2, 3);

		tilt_org = GetEnt("elevator_crash_tilt", "targetname");
		level thread tilt_building_scripted(tilt_org.angles, 3, true);
		level thread maps\gettler::super_tilt();

		self PlaySound("GET_elevator_tilt");
		
		light light_flicker(false, 0);
		wait .5;

		
		level notify("fx_elevator_sparks");
		
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

	
	if( IsDefined( level.vesper ) )
	{
		level.vesper notify( "stop_vesper_dialogue" );
		level.vesper PlaySound( "VESP_GettG_073A" );
	}

	self waittill("rotatedone");

	
	if( IsDefined(level.vesper) )
	{
		level.vesper thread vesper_elev_anim_loop();
	}

	level notify("elevator_fall_start");
	
	exploder(destroy.script_exploder);

	
	ai = GetAIArray("axis");
	damage = GetEnt("elevator_damage", "targetname");
	for (i = 0; i < ai.size; i++)
	{
		if (ai[i] IsTouching(damage))
		{
			ai[i] DoDamage(300, ai[i].origin);
		}
	}

	
	level notify("playmusicpackage_house");
	
	

	if (!skipto)
	{
		level.player allowStand(false);
		
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

pulley()
{
	pulley = GetEnt("pulley", "targetname");
	boards = GetEnt("boards", "targetname");
	boards LinkTo(pulley);

	waittillframeend;
	pulley.link.setscale = .5;
	level waittill("shaking");
	

	spark_org = GetEnt("control_panel_spark", "targetname");
	trig = GetEnt( "pulley_trig", "targetname" );

	trig waittill( "trigger" );
	trig delete();

	level notify("turn_off_control_panel_light");

	
	level thread maps\_autosave::autosave_now("gettler");

	level thread spark(spark_org.origin);
	level thread pulley_activate();

	
	
}

pulley_activate(awarenessObject)
{
	pulley = GetEnt("pulley", "targetname");
	boards = GetEnt("boards", "targetname");
	
	pulley PlaySound("GET_pulley_activate", "sounddone");

	pulley waittill("sounddone");
	pulley PlaySound("GET_pulley_fall");

	pulley Unlink();

	
	
	
	
	

	
	pulley movez(-30, 2, 0.2, 1.8);
	pulley thread crane_fx_controller();
	pulley waittill("movedone");

	Playfx(level._effect["gettler_falling_debris07"], pulley.origin ); 
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (0,50,0)  ); 
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (10,-50,0)  ); 

	pulley movez(-90, 0.7, 0.5, 0.2);
	pulley thread crane_fx_controller();          
	wait(0.5);
	Playfx(level._effect["watersplash_large"], boards.origin + (0,0,-100)  ); 
	
	

	pulley waittill("movedone");
	Playfx(level._effect["gettler_falling_debris07"], pulley.origin ); 
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (20,0,5)  ); 
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (80,0,0)  ); 
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (-40,0,5)  ); 
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (0,50,0)  ); 
	Playfx(level._effect["gettler_falling_debris07"], boards.origin + (10,-50,0)  ); 

	Playfx(level._effect["venice_water_disturb06"], boards.origin + ( 0, 0,-4)  ); 

	

	level thread shake_building(1, .3);

	boards Unlink();
	boards RotatePitch(15, .3, .3);
	boards waittill("rotatedone");

	
	boards LinkTo(pulley);

	flag_set("pulley_lowered");
	level thread before_jump();
	level thread jump();

	
	pulley RotateYaw(10, 1, 0, .8);
	pulley waittill("rotatedone");
	pulley RotateYaw(-20, 1, 0, .8);
	pulley waittill("rotatedone");
	pulley RotateYaw(20, 2, 0, 1.2);
	pulley waittill("rotatedone");
	pulley RotateYaw(-10, 2, 0, 1.2);
	pulley waittill("rotatedone");
	

	pulley LinkTo(pulley.link);

	
	
	
	

	flag_wait("player_4th_floor");
	pulley.link.setscale = 1;
}


crane_fx_controller()
{
	Playfx(level._effect["gettler_falling_debris01"], self.origin ); 

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin ); 

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); 

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); 

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); 

	wait ( 0.2 );

	Playfx(level._effect["gettler_falling_debris01"], self.origin  ); 
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
		Playfx(level._effect["switchbox_spark"], origin); 
		waittillframeend;
	}
}

save_game()
{
	self waittill("trigger");

	
	
	
	
	
	
	
	
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











































































destruction()
{
	if (!IsDefined(level.destruction_chunks))
	{
		level.destruction_chunks = [];
	}

	
	chunks = GetEntArray("destruction", "targetname");
	for (i = 0; i < chunks.size; i++)
	{
		assertex(IsDefined(chunks[i].script_int), "destruction must always specify what level it's on with a 'script_int' value");
		if (!IsDefined(level.destruction_chunks[chunks[i].script_int]))
		{
			level.destruction_chunks[chunks[i].script_int] = [];
		}

		if (!IsDefined(chunks[i].script_noteworthy))
		{
			level.destruction_chunks[chunks[i].script_int] = array_add(level.destruction_chunks[chunks[i].script_int], chunks[i]);
		}
	}
}


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
	physics_explosion = GetEnt("tank_physics_explosion", "targetname");
	origin = tank.origin;
	exploder(tank.script_exploder);	
	level notify("walkway_explode_start");
	wait .05;
	PhysicsExplosionSphere(physics_explosion.origin, 300, 200, 5);

	
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

	
	sound_ent = Spawn("script_origin", origin);
	sound_ent PlaySound("GET_tank_explode", "sounddone");
	wait 1.5;
	level notify("oxy_tank_explode");
	sound_ent waittill("sounddone");
	sound_ent delete();
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	shake_building(2);
}





script_contraint()
{
	
	
	
	
	
	
	
	
	
	
	
	
	
	self waittill("trigger");
		
	
	level notify( "gondola_fall_start" );
	
	
	
	
	
	
	
	
	
	
	wait( 1 );
	RadiusDamage((2960, -528, 160), 128, 500, 200);
	PhysicsExplosionSphere((2960, -528, 160), 256, 128, 2);
	RadiusDamage((2960, -720, 160), 128, 500, 200);
	PhysicsExplosionSphere((2960, -720, 160), 256, 128, 2);
	RadiusDamage((2952, -856, 160), 128, 500, 200);
	PhysicsExplosionSphere((2952, -856, 160), 256, 128, 2);

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

fog()
{
	self waittill("trigger");

	

	if (self.script_int == 0)
	{
		setExpFog(0, 1600, 0.58, 0.60, 0.52, 2.0, 0.55);
	}
	else if (self.script_int == 1)
	{
		setExpFog(525, 66, 0.54, 0.47, 0.34, 2.0, 0.30);
	}
}




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
		trig = Spawn("trigger_radius", self.origin, 0, 25, 100);

		if (IsDefined(self.script_flag_set))
		{
			flag_init(self.script_flag_set);
		}

		trig interaction(self);
	}
}




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




clear_interaction(node)
{
	level.interaction_hud settext("");
	self notify("player_interaction_cancel");
	self thread interaction(node);
}




can_interact(node)
{
	dot = VectorDot(AnglesToForward(node.angles), AnglesToForward(level.player.angles));
	if ((!level.player IsTouching(self)) || (dot < .6))
	{
		return false;
	}
	return true;
}




player_interaction(node)
{
	self endon("player_interaction_cancel");

	
	
	
	
	

	
	if (IsDefined(node.script_flag_set))
	{
		flag_set(node.script_flag_set);
	}
	
	if (IsDefined(node.script_string))
	{
		level notify(node.script_string);
	}

	

	
	
	
	
	
	
	
	
	
	
	
	
	
	

	self clear_interaction(node);
	
}

pillars_side_gate()
{
	while (true)
	{
		self waittill("open"); 
		
		
		iPrintLnBold("Gate Creaking!");
		
		
		self waittill("closed");
		
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
		VisionSetNaked("gettler_house", 1);
		flag_set("_sea_viewbob");
		
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
		flag_clear("cargoship_lighting_off");	
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
	
	level.player DoDamage( 10000, (0, 0, 0) );
}

#using_animtree( "vehicles" );
boat_float()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	self UseAnimTree(#animtree);
	
	
	self setFlaggedAnimKnobRestart( "idle", %v_boat_float );
}


physics_shutters()
{
	
	if( !IsDefined( self.target ) )
	{
		return;
	}

	
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



fx_notify()
{
	if(!IsDefined(self))
		return;

	self waittill( "trigger" );

	if( IsDefined( self.script_noteworthy ) )
		level notify( self.script_noteworthy );
}


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


ambient_vo()
{
	
	if( !IsDefined( self.target ) )
	{
		return;
	}
	if( !IsDefined( self.script_noteworthy ) )
	{
		return;
	}
	
	
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

	self.vo_exhausted = false;

	
	while( IsDefined(entSpeaker[iCount]) && !self.vo_exhausted )
	{
		self waittill("trigger");

		switch(self.script_noteworthy)
		{
			case "two_male":
			entSpeaker[iCount] vo_two_male(self);
				break;

			case "two_female":
			entSpeaker[iCount] vo_two_female(self);
				break;

			case "phone_male":
			entSpeaker[iCount] vo_phone_male(self);
				break;

			case "phone_female":
			entSpeaker[iCount] vo_phone_female(self);
				break;

			case "two_mix_a":
			entSpeaker[iCount] vo_two_mix_a(self);
				break;

			case "two_mix_b":
			entSpeaker[iCount] vo_two_mix_b(self);
				break;
		}
		iCount++;
		if( iCount > iMaxSpeaker )
		{
			iCount = 0;
		}
	}
}


vo_two_male(trig)
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
	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_male++;
}

vo_two_female(trig)
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
	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_female++;
}

vo_phone_male(trig)
{
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
			self playsound("PHM1_GettG_007A", "end_ambient_vo", false);	
			break;

		case 1:
			self playsound("PHM2_GettG_041A", "end_ambient_vo", false);	
			break;
	}
	self waittill( "end_ambient_vo" );
	wait( RandomIntRange( 2, 7 ) );
	level._ambient_vo_count_phone_male++;
}

vo_phone_female(trig)
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
			self playsound("PHW1_GettG_013A", "end_ambient_vo", false);	
			break;
	}
	self waittill( "end_ambient_vo" );
	wait( RandomIntRange( 2, 7 ) );
	level._ambient_vo_count_phone_female++;
}

vo_two_mix_a(trig)
{
	if( !IsDefined(level._ambient_vo_count_two_mix_a) )
{
		level._ambient_vo_count_two_mix_a = 0;
	}

	iMaxLines = 4;

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

		case 4:
			self playsound("VEM3_GettG_012A", "end_ambient_vo", false);
			break;
	}
	self waittill( "end_ambient_vo" );
	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_mix_a++;
}

vo_two_mix_b(trig)
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
	wait( RandomIntRange( 1, 2 ) );
	level._ambient_vo_count_two_mix_b++;
}


battlechatter_vo()
{
	if (!isdefined(level.flag["battle_chatter"]))
	{
		flag_init("battle_chatter");
	}

	if( !IsDefined( self.script_noteworthy ) )
	{
		return;
	}

	while( IsDefined( self ) )
	{
		self waittill( "trigger" );

		if (!flag("battle_chatter"))
		{
			aiTemp = get_active_enemy();

			if( IsDefined( aiTemp ) )
			{
				flag_set("battle_chatter");
				aiTemp PlaySound( self.script_noteworthy );
				wait 3;
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


under_gondola()
{
	level endon("gondola_drop");
	self waittill("trigger");

	trig = GetEnt("gondola_pointers", "targetname");
	if (!flag("gondola_drop"))
	{
		
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
			if (ai[i] != point_guy)
			{
				level thread gondola_shooter(ai[i]);
				break;
			}
		}
	}
}

gondola_pointer()
{
	
	self CmdPlayAnim("Thug_Point2Gondola");
}

gondola_shooter(shooter)
{
	trig = GetEnt("script_constraint", "script_noteworthy");
	trig thread gondola_shooter_failsafe(shooter);	
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
				MissionFailed();
			}

			wait .05;
		}
	}
}