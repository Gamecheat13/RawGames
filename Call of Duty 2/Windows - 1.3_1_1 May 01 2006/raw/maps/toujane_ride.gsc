#include maps\_utility;
#include maps\_anim;

main()
{
	setCullFog(500, 10000, .77 , .5 , .33 , 0);	
	if (getcvar ("start") == "")
		setcvar ("start", "start");
	if (getcvar ("fastdefend") == "")
		setcvar ("fastdefend", "0");
	
	fastLevel = getcvarint("scr_toujane_ride_fast");
	if (!isdefined(fastLevel))
		fastLevel = 0;
	trig = getent("opening_flood_spawner","script_noteworthy");
	if (fastLevel == 0)
		trig.script_maxspawn = undefined;
	if (fastLevel == 1)
		trig.script_maxspawn = 8;
	if (fastLevel >= 2)
		trig.script_maxspawn = 6;
	
	precacheShellshock("default");
	precacheString(&"TOUJANE_RIDE_PLATFORM_GETIN_ARMOREDCAR");
	precacheString(&"TOUJANE_RIDE_PLATFORM_TOGGLE_WEAPONS");
	precacheString(&"TOUJANE_RIDE_OBJ_DEFEND");
	precacheString(&"TOUJANE_RIDE_OBJ_DEFEND_DONE");
	precacheString(&"TOUJANE_RIDE_OBJ_ARMOREDCAR");
	precacheString(&"TOUJANE_RIDE_OBJ_ESCAPE");
	
	precacheModel("xmodel/wall_tank_pieces");
	precacheModel("xmodel/wall_tank_broke");
	precacheModel("xmodel/vehicle_stuka_flying");
	precacheModel("xmodel/vehicle_spitfire_flying");
	precacheModel("xmodel/eldaba_plane_rig");
	precacheModel("xmodel/duhoc_player_viewcam_joints");
	precacheModel("xmodel/prop_german_armored_car_tire");
	level.stukaBombModel = "xmodel/prop_stuka_bomb";
	precacheModel(level.stukaBombModel);
	precachevehicle("Stuka");
	
	flag_clear("level_ending");
	flag_clear("allow_talking");
	flag_set("allow_talking");
	
	flag_clear("last_truck_dialogue_done");
	flag_clear("backfortown_dialogue_done");
	flag_clear("teachthose_dialogue_done");
	flag_clear("rallyahead_dialogue_done");
	
	level.armored_car_death_fx = loadfx("fx/explosions/large_vehicle_explosion.efx");
	level.armored_car_death_model = ("xmodel/vehicle_german_armored_car_d");
		precacheModel(level.armored_car_death_model);
	
	level.playerKills = 0;
	level.firstObjectiveKillsRequired = 20;
	if (getcvarint ("fastdefend") > 0)
		level.firstObjectiveKillsRequired = 2;
	
	level.destroyable_tank_health = 4000;
	if (level.gameSkill == 0)
	{
		level.destroyable_tank_health = 4000;
		level.armoredCarHealth = 8000;
		delete_panzerguys();
	}
	else
	if (level.gameSkill == 1)
	{
		level.destroyable_tank_health = 5000;
		level.armoredCarHealth = 5000;
		delete_panzerguys();
	}
	else
	if (level.gameSkill >= 2)
	{
		level.destroyable_tank_health = 6000;
		level.armoredCarHealth = 3000;
	}
	
	level.cos80 = cos(80);
	
	flag_clear("InsideArmoredCar");
	flag_clear("opening_dialogue_done");
	flag_clear("spawn_armored_car");
	flag_clear("allow_building_exit");
	flag_clear("armoredcar_gunner_fallout");
	flag_clear("allow_use_armoredcar");
	flag_clear("macgregor_entered_armoredcar");
	flag_clear("price_entered_armoredcar");
	flag_clear("macgregor_getin");
	flag_clear("player_in_armoredcar");
	flag_clear("armoredcar_start_player_path");
	flag_clear("armored_car_scene_done");
	flag_clear("destroyable_tank_playerInPosition");
	flag_clear("destroyable_tank_dead");
	flag_clear("player_on_mg");
	flag_clear("music_ominous");
	flag_clear("final_crash_run");	//set this flag X seconds before ejection from armored car (where X is the length of the first ride music track, toujane_vehicle_ride)
	flag_clear("music_evacuation");
	flag_clear("gunner_dead");
	flag_clear("moving_from_dead_tank");
	
	aitype\axis_afrikakorp_reg_kar98::precache();
	level.drone_spawnFunction["axis"] = aitype\axis_afrikakorp_reg_kar98::main;
	level.max_drones["axis"] = 10;
	
	maps\_truck::main("xmodel/vehicle_opel_blitz_desert");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_desert");
	maps\_jeep::main("xmodel/vehicle_africa_jeep");
	maps\_armoredcar::main("xmodel/vehicle_german_armored_car");
	maps\_kubelwagon::main("xmodel/vehicle_german_kubel");
	maps\toujane_ride_fx::main();
	maps\_load::main();
	maps\toujane_ride_anim::main();
	maps\_drones::init();
	
	level.playerThreatBias = level.player.threatbias;
	
	thread maps\toujane_ride_amb::main();
	
	level.crateImpactSound = "crate_impact";
	
	level.radio = getent ("radio_voice_location","targetname");
	level.defend_mg42 = getent ("defend_mg42","targetname");
	level.windowOrigin = level.defend_mg42.origin;
	level.breakingEnts = [];
	level SetupCharacters();
	
	level array_thread (getspawnerarray(), ::spawners_tweak);
	level array_thread (getentarray("building_break_mg42","targetname"), ::building_break_turret);
	level array_thread (getentarray("building_break","targetname"), ::building_break_turret);
	level array_thread (getentarray("stop for barreltruck_trig","targetname"), ::triggerOff);
	level array_thread (getentarray("armored_car_startup_spawners_trig","targetname"), ::triggerOff);
	level array_thread (getentarray("deadend_truck_spawn_trig","targetname"), ::triggerOff);
	level array_thread (getentarray("stuka","targetname"), ::makeStuka);
	level array_thread (getentarray("second_pass_trigger","script_noteworthy"), ::triggerOff);
	level array_thread (getentarray("stuka_bomber","targetname"), ::stukaBomber);
	level array_thread (getentarray("wallchunk","targetname"), ::wallchunk_setup);
	level array_thread (getentarray("walldent","targetname"), ::wallchunk_setup);
	level array_thread (getentarray("panzerschreck_shoutout","targetname"), ::panzerschreck_shoutout);
	
	roof_clip = getent("roof_clip","targetname");
	roof_clip connectpaths();
	roof_clip solid();
	
	roof_clip2 = getent("roof_clip2","targetname");
	roof_clip2 connectpaths();
	roof_clip2 hide();
	
	getent("door_knockdown","targetname") hide();
	
	level.defend_mg42 thread playerUsingMG42_think();
	
	//adjust health on opening spawners
	trig = getent("opening_flood_spawner","script_noteworthy");
	spawners = getentarray(trig.target,"targetname");
	for( i = 0 ; i < spawners.size ; i++ )
		spawners[i].script_startinghealth = 50;
	
	thread DogFights();
	thread armored_car();
	thread Event_LevelEnd();
	thread halftrack_breakWall(); 
	thread armored_car_events_halftrack();
	thread armored_car_events_tank();
	thread destroyable_tank();
	thread deadEnd_stop_for_reverse();
	thread tunnel_bomb();
	thread skidjeep();
	thread first_tank_mg42settings();
	thread savegame_before_tank();
	thread crashing_soon();
	thread tunnel_dialogue();
	
	thread Event_EscapeFirstEncounter();
	thread Event_EscapeSecondEncounter();
	thread autosave_leavingbuilding();
	thread checkEscapeAutoSave1();
	thread checkEscapeAutoSave2();
	thread BackgroundExplosions();
	thread rearAttackersStart();
	thread attackersUpLadder();
	thread intersectionFirefight();
	thread smokeAttackRear();
	thread guysAtEnd();
	thread rearAdmirals();
	thread lastNazis();
	thread rearProtector();
	thread moreAttackingNazis();
	thread attackersByTank();
	
	thread music();
	
	if (getcvar ("start") == "start")
	{
		thread Objective_1_HoldPosition();
		thread dialogue_opening();
		thread first_truck();
		thread allow_building_exit();
		thread tank_wall_break();
		thread randomBombings();
		thread armored_car_enterTrigger();
	}
	else
	if (getcvar ("start") == "door")
	{
		thread door_sequence();
	}
	else
	if (getcvar ("start") == "ride")
	{
		//spawn the armored car and get it to it's end position asap
		flag_set("spawn_armored_car");
		while(!isdefined(level.armoredcar))
			wait 0.05;
		thread armored_car_playerEnter();
		
		//delete macgregor and price since they dont exist for the car ride
		wait 0.05;
		level.MacGregor delete();
		level.MacGregor = undefined;
		level.Price delete();
		level.Price = undefined;
	}
}

delete_panzerguys()
{
	deadend_panzerguys = getentarray("deadend_panzerguys","targetname");
	for( i = 0 ; i < deadend_panzerguys.size ; i++ )
	{
		if (!isdefined(deadend_panzerguys[i].script_noteworthy2))
			continue;
		if (deadend_panzerguys[i].script_noteworthy2 == "hardened")
			deadend_panzerguys[i] delete();
	}
}

savegame_before_tank()
{
	getent("savegame_before_tank","targetname") waittill ("trigger");
	thread autosavebyname("approachingTank");
}

wallchunk_setup()
{
	broken = getentarray(self.target,"targetname");
	for( i = 0 ; i < broken.size ; i++ )
	{
		if ( broken[i].classname == "script_origin" )
		{
			self.centerPoint = broken[i].origin;
			continue;
		}
		broken[i] hide();
	}
	assert(isdefined(self.centerPoint));
}

wallchunk_break()
{
	broken = getentarray(self.target,"targetname");
	origin = undefined;
	for( i = 0 ; i < broken.size ; i++ )
	{
		if ( broken[i].classname == "script_origin" )
		{
			origin = broken[i];
			continue;
		}
		broken[i] show();
	}
	assert(isdefined(origin));
	vecDirection = getent(origin.target,"targetname");
	assert(isdefined(vecDirection));
	
	playfx( level._effect["20mm_walldamage"], origin.origin, vectorNormalize(origin.origin - vecDirection.origin) );
	origin playsound("wall_crumble_large");
	earthquake(.50, .27, origin.origin, 200);
	self delete();
}

openGate()
{
	getent("gate_left","targetname") rotateYaw(90, .1);
	getent("gate_right","targetname") rotateYaw(-90, .1);
}

closeGate()
{
	getent("gate_left","targetname") rotateYaw(-90, .1);
	getent("gate_right","targetname") rotateYaw(90, .1);
}

door_sequence()
{
	door_shake = getent("door_shake","targetname");
	door_knockdown = getent("door_knockdown","targetname");
	door_area = getent("door_area","targetname");
	
	door_shake thread door_sequence_doorshake();
	while(!door_shake door_sequence_doorInSight())
		wait 1;
	
	thread closeGate();
	
	wait 1;
	
	//remove door set up for rotation on hinge
	level notify ("door_kicked_down");
	wait 0.05;
	door_shake delete();
	
	//put back door set up for other rotations
	door_knockdown show();
	door_knockdown notsolid();
	door_knockdown door_sequence_kickdown(door_area);
}

door_sequence_doorshake()
{
	level endon ("door_kicked_down");
	originalAngles = self.angles;
	for (;;)
	{
		timeBetweenKicks = (0.25 + randomfloat(0.5));
		self door_sequence_door_doShake(originalAngles);
		wait (timeBetweenKicks);
	}
}

door_sequence_door_doShake(originalAngles)
{
	rotateTime = 0.1;
	rotateAngle = 1.5 + randomfloat(2.0);
	self thread playsoundinspace("door_bounce");
	self rotateto( self.angles - (0,rotateAngle,0), rotateTime, 0, 0 );
	wait (rotateTime);
	self rotateto( originalAngles, rotateTime, 0, 0 );
	wait (rotateTime);
	self.angles = originalAngles;
}

door_sequence_doorInSight()
{
	forwardvec = anglestoforward(level.player.angles);
	normalvec = vectorNormalize(self.origin - (level.player getOrigin()) );
	vecdot = vectordot(forwardvec,normalvec);
	if (vecdot > level.cos80)
		return true;
	return false;
}

door_sequence_kickdown(door_area)
{
	self thread playsoundinspace("wood_door_kick");
	
	//spawn the dudes at the door
	thread door_sequence_spawners();
	
	self connectpaths();
	
	//rotates to flat on ground
	rotateTime = .4;
	door_direction = getent("door_direction","targetname");
	dummy = spawn("script_origin",self.origin);
	dummy.angles = vectortoangles(door_direction.origin - self.origin);
	self linkto(dummy);
	dummy rotatepitch( 90, rotateTime, 0.2, 0 );
	dummy moveto(door_direction.origin, rotateTime, 0, (rotateTime / 2) );
	wait (rotateTime);
}

door_sequence_spawners()
{
	door_spawners = getentarray("door_spawners","targetname");
	for( i = 0 ; i < door_spawners.size ; i++ )
	{
		guy = door_spawners[i] stalingradSpawn();
		if (spawn_failed(guy))
			continue;
		guy thread door_sequence_spawners_think();
	}
}

door_sequence_spawners_think()
{
	self endon ("death");
	self.goalradius = 128;
	self setgoalpos (level.player.origin);
	self.ignoreme = true;
	self.health = 50;
	
	wait 3;
	if (isdefined(self))
		self.ignoreme = false;
}

dialogue_opening()
{
	battleChatterOff("allies");
	
	level.radio playsound(level.scrsound["radio"]["opfivejerriesattack"], "sounddone");
	level.radio waittill("sounddone");
	level.Price anim_single_solo(level.Price, "davisisntdrill");
	
	if (!flag("player_on_mg"))
		level.Price anim_single_solo(level.Price, "davisgetonmg");
	
	flag_set("opening_dialogue_done");
	
	battleChatterOn("allies");
}

dialogue_armoredCarGetDown()
{
	battleChatterOff("allies");
	level.Price anim_single_solo(level.Price, "twentymil");
	level.MacGregor anim_single_solo(level.MacGregor, "everyonedown");
	battleChatterOn("allies");
}

dialogue_leaveBuilding()
{
	battleChatterOff("allies");
	
	flag_set("music_ominous");
	
	level.radio playsound(level.scrsound["radio"]["allreceivingunits"], "sounddone");
	level.radio waittill("sounddone");
	
	level.Price anim_single_solo(level.Price, "flankarmoredcar");
	
	level.radio playsound(level.scrsound["radio"]["opthreeunderattack"], "sounddone");
	level.radio waittill("sounddone");
	
	level.Price anim_single_solo(level.Price, "everyoneoutnow");
	level.Price anim_single_solo(level.Price, "davisonpoint");
	
	flag_set("allow_building_exit");
	
	level.radio playsound(level.scrsound["radio"]["thisisopsix"], "sounddone");
	level.radio waittill("sounddone");
	
	battleChatterOn("allies");
}

first_truck()
{
	flag_wait("opening_dialogue_done");
	wait 5;
	getent("truck_trigger","targetname") notify ("trigger");
}

armored_car()
{
	//wait until the armored car should spawn
	flag_wait("spawn_armored_car");
	getent("armoredcar_spawn_trigger","targetname") notify ("trigger");
	level.ArmoredCar = maps\_vehicle::waittill_vehiclespawn("armoredcar");
	assert(isdefined(level.ArmoredCar));
	level.ArmoredCar.BadPlaceModifier = 1.5;
	level.ArmoredCar.health = 10000000000000;
	level.breakingEnts[level.breakingEnts.size] = level.ArmoredCar;
	level.ArmoredCar setwaitnode(getvehiclenode("armoredcar_drive_node","targetname"));
	level.ArmoredCar thread armored_car_arrival_sfx();
	
	thread Event_CarCrash();
	
	if (getcvar ("start") == "start")
	{
		level.ArmoredCar thread armored_car_unmannedThink();
		level.ArmoredCar thread armored_car_mannedThink();
	}
	else
	{
		maps\_spawner::kill_spawnerNum(0);
		thread armored_car_openHatch();
		level.armoredcar waittill ("reached_wait_node");
		level.armoredcar setspeed(0,10000);
	}
}

armored_car_arrival_sfx()
{
	getent("armored_car_sfx","targetname") waittill ("trigger");
	self playsound("toujaneride_cararrival");
}

playerUsingMG42_think()
{
	for (;;)
	{
		//wait for player to get on the gun
		self waittill ("trigger");
		owner = self getturretowner();
		if (!isdefined(owner))
			continue;
		if (owner != level.player)
			continue;
		
		//player is on the mg42
		//---------------------
		flag_set("player_on_mg");
		level.macgregor.anim_DisablePain = true;
		level.price.anim_DisablePain = true;
		level.player thread playerUsingMG42_ignore_think();
		while( (isdefined(self)) && ( isdefined( self getturretowner() ) ) )
			wait 0.05;
		//---------------------
		//---------------------
		
		//######################
		
		//player is off the mg42
		//----------------------
		flag_clear("player_on_mg");
		level notify ("player_off_gun");
		level.macgregor.anim_DisablePain = false;
		level.price.anim_DisablePain = false;
		level.player.ignoreme = false;
		level.player.threatbias = level.playerThreatBias;
		//----------------------
		//----------------------
		
		if (!isdefined(self))
			return;
		
		wait 0.05;
	}
}

playerUsingMG42_ignore_think()
{
	level.player endon ("death");
	level endon ("player_off_gun");
	/*
	if (level.gameSkill > 2)
		level.player.threatbias = 200;
	else
		level.player.threatbias = 250;
	*/
	for (;;)
	{
		//level.player.ignoreme = true;
		
		level.player.threadbias = 100;
		level.macgregor.threatbias = 10000;
		level.price.threatbias = 10000;
		
		if (level.gameSkill > 2)
			wait (3 + randomfloat(3));
		else
			wait (3 + randomfloat(2));
		//level.player.ignoreme = false;
		level.player.threadbias = level.playerThreatBias;
		
		wait (2 + randomfloat(2));
	}
}

goProne(node, endonString)
{
	self endon (endonString);
	self.goalradius = 32;
	self setgoalnode(node);
	self waittill ("goal");
	self allowedstances("prone");
}

armored_car_unmannedThink()
{
	self waittill ("reached_wait_node");
	self setspeed(0,10000);
	self disconnectpaths();
	
	//make the armored car aim at the building
	target = getent("armoredcar_destroy_building_target","targetname");
	self setTurretTargetEnt(target, (0,0,0) );
	
	//"20 mil get down"
	level.macgregor thread goProne(getnode("prone_node_macgregor","targetname"), "stopProneOnly");
	level.price thread goProne(getnode("prone_node_price","targetname"), "stopProneOnly");
	
	dialogue_armoredCarGetDown();
	
	//20 mil shoots the building and sets off the exploders
	wallchunk = getentarray("wallchunk","targetname");
	
	//arrange wallchunk array furthest to closest to the player
	for(i = 0; i < wallchunk.size; i++)
		wallchunk[i].d = distance(wallchunk[i].centerPoint, (level.player getOrigin() + (0,0,40)) );
	for(i = 0; i < wallchunk.size; i++)
	{
		for(j = i; j < wallchunk.size; j++)
		{
			if(wallchunk[i].d < wallchunk[j].d)
			{
				temp = wallchunk[i];
				wallchunk[i] = wallchunk[j];
				wallchunk[j] = temp;
			}
		}
	}
	
	for( i = 0 ; i < wallchunk.size ; i++ )
	{
		self setTurretTargetVec (wallchunk[i].centerPoint);
		self notify ("turret_fire");
		wallchunk[i] thread wallchunk_break();
		if (distance(wallchunk[i].centerPoint, level.player.origin) <= 200)
			thread player_knockdown();
		wait 0.2;
	}
	
	level.player.knockedDown = undefined;
	wait 5;
	
	level.MacGregor notify ("stopProneOnly");
	level.Price notify ("stopProneOnly");
	level.MacGregor allowedStances("crouch");
	level.Price allowedStances("crouch");
	
	thread autosavebyname("armoredCarAttacks");
	
	//"20 mil get down" (again)
	dialogue_armoredCarGetDown();
	
	//armored car does second round of shots (deadly this time)
	shots = 25;
	for ( i = 0 ; i < shots ; i++ )
	{
		self setTurretTargetVec(level.player getEye());
		self waittill ("turret_on_target");
		self notify ("turret_fire");
		thread playsoundinspace("wall_crumble_large", level.windowOrigin);
		wait 0.17;
	}
	
	level.MacGregor allowedStances("stand","crouch","prone");
	level.Price allowedStances("stand","crouch","prone");
	
	//must get out of this building now and get the armored car
	thread dialogue_leaveBuilding();
}

armored_car_mannedThink()
{
	getent("armored_car_manned","targetname") waittill ("trigger");
	
	//kill the building attack spawners
	maps\_spawner::kill_spawnerNum(0);
	roof_clip = getent("roof_clip","targetname");
	if (isdefined(roof_clip))
	{
		roof_clip disconnectpaths();
		roof_clip delete();
	}
	
	axis = getaiarray("axis");
	axis = array_removeDead(axis);
	axis = array_randomize(axis);
	for( i = 0 ; i < int(axis.size / 2) ; i++ )
		axis[i] delete();
	
	
	level.gunner = getent("armored_car_gunner_spawner","targetname") stalingradSpawn();
	if (spawn_failed(level.gunner))
		assertMsg("armoredcar gunner failed to spawn");
	level.gunner.animname = "gunner";
	level.gunner.ignoreme = true;
	level.gunner animscripts\shared::putGunInHand ("none");
	level.gunner thread magic_bullet_shield();
	level.gunner linkto (level.armoredcar, "tag_gunner");
	level.gunner thread armored_car_gunnerThink();
	
	thread armored_car_openHatch();
	
	thread armored_car_aiDismountGun();
	
	level.gunner endon ("fakeDeath");
	
	targets = getentarray("armoredcar_destroy_building_target","targetname");
	for (;;)
	{
		//sometimes shoot at the player and sometimes at other spots
		//only if player is within 300 units
		if ( (distance(level.player.origin,level.armoredcar.origin) <= 800) && (randomint(2) == 0) )
			targetVec = level.player getEye();
		else
			targetVec = targets[randomint(targets.size)].origin;
		
		self setTurretTargetVec( targetVec );
		self waittill ("turret_on_target");
		if ( (isdefined(level.gunner.doingTurretAnims)) && (level.gunner.doingTurretAnims == true) )
			self armored_car_mannedThink_shootBursts();
		wait (2 + randomfloat(3));
	}
}

armored_car_mannedThink_shootBursts()
{
	level endon ("gunner_dismounted");
	shots = (3 + randomint(7));
	for ( i = 0 ; i < shots ; i++ )
	{
		self notify ("turret_fire");
		wait .17;
	}
}

armored_car_aiDismountGun()
{
	assert(isdefined(level.gunner));
	level.gunner endon ("fakeDeath");
	
	area = getent("near_armoredcar","targetname");
	
	for (;;)
	{
		level.gunner.doingTurretAnims = true;
		level.gunner animscripts\shared::putGunInHand ("none");
		level.gunner thread anim_loop_solo( level.gunner, "alive_idle", "tag_gunner", "stop_idle_loop", undefined, level.armoredcar );
		wait 2;
		
		area waittill ("trigger");
		
		level.gunner.doingTurretAnims = false;
		level notify ("gunner_dismounted");
		level.gunner notify ("stop_idle_loop");
		level.gunner animscripts\shared::putGunInHand ("right");
		level.gunner allowedStances("crouch");
		wait 2;
		
		while (level.player istouching (area))
			wait 0.2;
	}
}

armored_car_gunnerThink()
{	
	for (;;)
	{
		self waittill ("damage", amount, attacker);
		if (attacker != level.player)
			continue;
		break;
	}
	
	if ( (isdefined(level.gunner.doingTurretAnims)) && (level.gunner.doingTurretAnims == false) )
		level.gunner animscripts\shared::putGunInHand ("none");
	
	flag_set("gunner_dead");
	self notify ("fakeDeath");
	self notify ("stop_idle_loop");
	self anim_single_solo( self, "death", "tag_gunner", undefined, level.armoredcar );
	self thread anim_loop_solo( self, "death_idle", "tag_gunner", "stop_idle_loop", undefined, level.armoredcar );
	
	//make armored car point straight again
	relativeOffset = (200, 0, 77);
	ang = level.armoredcar getTagAngles("tag_body");
	forwardVec = anglestoforward(ang);
	rightVec = anglestoright(ang);
	upVec = anglestoup(ang);
	AimOrg = level.armoredcar getTagOrigin("tag_body");
	AimOrg += vectorMultiply(forwardVec, relativeOffset[0]);
	AimOrg += vectorMultiply(rightVec, relativeOffset[1]);
	AimOrg += vectorMultiply(upVec, relativeOffset[2]);
	level.armoredcar setTurretTargetVec(AimOrg);
	wait 2;
	
	//wait until the player has made it close to the armored car
	getent("near_armoredcar","targetname") waittill ("trigger");
	thread battleChatterOff("allies");
	level thread armored_car_getinAnims();
	
	//gunner dead now - wait until price notetrack to move him out of the vehicle
	flag_wait("armoredcar_gunner_fallout");
	self notify ("stop_idle_loop");
	self anim_single_solo( self, "grab", "tag_gunner", undefined, level.armoredcar );
	self thread anim_loop_solo( self, "deathPose", "tag_gunner", "stop_idle_loop", undefined, level.armoredcar );
}

#using_animtree( "vehicles" );
armored_car_openHatch()
{
	level.ArmoredCar UseAnimTree(#animtree);
	level.ArmoredCar setAnim( %armoredcar_hatch_open_pose );
}

allow_building_exit()
{
	flag_wait("allow_building_exit");
	
	//player allowed to leave the building now
	thread Objective_2_FightWayToCar();
	level notify ("stop bombings");
	thread building_unsafe();
	
	//set values back on the ai
	level.Price.accuracy = level.Price.old_accuracy;
	level.Price.old_accuracy = undefined;
	level.Price.accuracyStationaryMod = level.Price.old_accuracyStationaryMod;
	level.Price.old_accuracyStationaryMod = undefined;
	
	//delete the clip brushes that were blocking the door
	door_sequence();
	
	//put ai on friendly chain
	level.MacGregor.followmin = -1;
	level.MacGregor.followmax = 1;
	level.MacGregor setgoalentity (level.player);
	
	level.Price.followmin = -1;
	level.Price.followmax = 1;
	level.Price setgoalentity (level.player);
}

building_unsafe()
{
	wait 10;
	//makes the building unsafe to be in now (going in the top level will be death)
	
	trig = getent("building_unsafe_area","targetname");
	
	for (;;)
	{
		trig waittill ("trigger");
		
		//if the armoredcar gunner is dead, return
		if (flag("gunner_dead"))
			return;
		
		aimPos = level.player getEye();
		shots = (6 + randomint(6));
		for ( i = 0 ; i < shots ; i++ )
		{
			level.armoredcar setTurretTargetVec(aimPos);
			level.armoredcar notify ("turret_fire");
			wait 0.17;
		}
		
		wait 4;
	}
}

player_knockdown(length)
{
	if (isdefined(level.player.knockedDown))
		return;
	level.player.knockedDown = true;
	
	//kick player off mg42 if player is on it
	owner = level.defend_mg42 getturretowner();
	if ( (isdefined(owner)) && (owner == level.player) )
	{
		level.defend_mg42 useby (level.player);
		level.defend_mg42 maketurretunusable();
	}
	level.defend_mg42 delete();
	
	if (!isdefined(length))
		length = 5;
	
	halfLength = (length / 2);
	
	level.player allowstand(false);
	level.player allowcrouch(false);
	level.player shellshock("default", length);
	wait halfLength;
	level.player allowstand(true);
	level.player allowcrouch(true);
	wait halfLength;
}

SetupCharacters()
{
	level.MacGregor = undefined;
	level.Price = undefined;
	
	allies = getaiarray("allies");
	for (alliesIndex=0;alliesIndex<allies.size;alliesIndex++)
	{
		//allies[alliesIndex] thread animscripts\shared::SetInCombat(false);
		if (!isdefined (allies[alliesIndex].script_noteworthy))
			continue;
		
		if (allies[alliesIndex].script_noteworthy == "macgregor")
		{
			level.MacGregor = allies[alliesIndex];
			level.MacGregor.animname = "macgregor";
			level.MacGregor.old_maxsightdistsqrd = level.MacGregor.maxsightdistsqrd;
			level.MacGregor.suppressionwait = 0;
		}
		else if (allies[alliesIndex].script_noteworthy == "price")
		{
			level.Price = allies[alliesIndex];
			level.Price.animname = "price";
			level.Price.old_maxsightdistsqrd = level.Price.maxsightdistsqrd;
			level.Price.suppressionwait = 0;
		}
	}
	
	assertEX(isdefined(level.MacGregor), "MacGregor isn't being defined");
	assertEX(isdefined(level.Price), "Price isn't being defined");
	
	//level.MacGregor.script_friendname = "Pvt. MacGregor";
	//level.Price.script_friendname = "Cpt. Price";
	
	level.MacGregor thread magic_bullet_shield();
	level.Price thread magic_bullet_shield();
	
	level.MacGregor thread animscripts\battlechatter_ai::aiOfficerOrders();
	
	level.Price.old_accuracy = level.Price.accuracy;
	level.Price.accuracy = 1;
	level.Price.old_accuracyStationaryMod = level.Price.accuracyStationaryMod;
	level.Price.accuracyStationaryMod = 1;
}

Objective_1_HoldPosition()
{
	level.player.old_threatbias = level.player.threatbias;
	
	objective_add(1, "active", &"TOUJANE_RIDE_OBJ_DEFEND_DONE", level.player.origin + (0,0,45) );
	objective_string_nomessage(1, &"TOUJANE_RIDE_OBJ_DEFEND", 0 );
	objective_current(1);
}

Objective_2_FightWayToCar()
{
	objective_string_nomessage(1, &"TOUJANE_RIDE_OBJ_DEFEND_DONE");
	objective_state(1, "done");
	objective_add(2, "active", &"TOUJANE_RIDE_OBJ_ARMOREDCAR", level.ArmoredCar.origin );
	objective_current(2);
}

Objective_3_RetreatToujane()
{
	objective_state(2, "done");
	objective_add(3, "active", &"TOUJANE_RIDE_OBJ_ESCAPE", (544, -360, 16) );
	objective_current(3);
}

Event_LevelEnd()
{
	level.exitTrig = getent ("levelend","targetname");
	level.exitTrig waittill ("trigger");
	
	if (!flag("level_ending"))
	{
		flag_set("level_ending");
		flag_wait("last_truck_dialogue_done");
		flag_wait("backfortown_dialogue_done");
		flag_wait("teachthose_dialogue_done");
		flag_wait("rallyahead_dialogue_done");
		battleChatterOff("allies");
		objective_state(3, "done");
		maps\_endmission::nextmission();
	}
}

randomBombings()
{
	level endon ("stop bombings");
	for (;;)
	{
		wait (3 + randomfloat (7));
		index = randomInt(1 + (level.RandomExploderIndex_End - level.RandomExploderIndex_Start));
		rand = (level.RandomExploderIndex_Start + index);
		exploder(rand);
	}
}

armored_car_enterTrigger()
{
	trig = getent("enter_armoredcar_trigger","targetname");
	trig thread triggerOff();
	wait 1;
	trig setHintString(&"TOUJANE_RIDE_PLATFORM_GETIN_ARMOREDCAR", getKeyBinding( getUseKey() )["key1"]);
	
	flag_wait("allow_use_armoredcar");
	trig thread triggerOn();
}

armored_car_playerEnter_dialogHint()
{
	wait 4;
	if(!flag("player_in_armoredcar"))
		level.Price anim_single_solo(level.Price, "macgregorwheel");
}

armored_car_playerEnter()
{
	//player used the trigger to get into the armored car
	trig = getent("enter_armoredcar_trigger","targetname");
	if (getcvar ("start") != "ride")
	{
		thread armored_car_playerEnter_dialogHint();
		trig waittill ("trigger");
	}
	trig delete();
	
	//put the player in the vehicle
	level.playervehicle = level.armoredcar;
	level.armoredcar useby (level.player);
	level.player allowProne(false);
	level thread maps\_armoredcar::overheat_enable();
	level thread armored_car_playerToggleSideArm();
	level thread armored_car_death();
	
	roof_clip1 = getent("roof_clip1","targetname");
	roof_clip1 connectpaths();
	roof_clip1 delete();
	roof_clip2 = getent("roof_clip2","targetname");
	roof_clip2 connectpaths();
	roof_clip2 show();
	
	flag_set("player_in_armoredcar");
	
	Objective_3_RetreatToujane();
	
	setsavedcvar( "cg_viewVehicleInfluence", 0.2 );
	
	thread openGate();
	
	thread autoSaveByName("capturedArmoredCar");
	
	thread armored_car_playerEnter_hintPrint();
	
	if (isdefined(level.gunner))
	{
		level.gunner delete();
		level.gunner = undefined;
	}
	
	//wait until macgregor and price are in the car if they aren't already
	if (getcvar ("start") != "ride")
	{
		flag_wait("macgregor_entered_armoredcar");
		flag_wait("price_entered_armoredcar");
	}
	
	//turn on the trigger that will spawn enemies while car is getting started
	level array_thread (getentarray("armored_car_startup_spawners_trig","targetname"), ::triggerOn);
	
	thread armored_car_newPath();
	thread dialogue_startingCar();
}

armored_car_playerEnter_hintPrint()
{
	wait 3;
	iprintlnbold(&"TOUJANE_RIDE_PLATFORM_TOGGLE_WEAPONS" , getKeyBinding( getUseKey() )["key1"] );
}

armored_car_death()
{
	level.ArmoredCar endon ("reached_end_node");
	
	level.ArmoredCar waittill ("death");
	
	level.ArmoredCar playsound ( "panzerschreck_hitcar" );
	
	level.player enableHealthShield(false);
	level.player dodamage(level.player.health + 10, level.armoredcar.origin);
	level.player enableHealthShield(true);
	level.player notify ("death");
	wait 0.1;
	maps\_utility::missionFailedWrapper();
}

armored_car_doDialogue(alias)
{
	loops = 0;
	timeout = 20 * 5;
	while(isdefined(level.armoredcar.talking))
	{
		wait 0.05;
		loops++;
		if (loops >= timeout)
			break;
	}
	
	level.armoredcar.talking = true;
	level.armoredcar playsound( alias , "sounddone" );
	level.armoredcar waittill( "sounddone" );
	level.armoredcar.talking = undefined;
}

dialogue_startingCar()
{
	wait 1;
	armored_car_doDialogue(level.scrsound["price"]["whatyouwaitinfor"]);
	armored_car_doDialogue(level.scrsound["macgregor"]["controlsingerman"]);
	armored_car_doDialogue(level.scrsound["price"]["davistwelveoclock"]);
	wait 1;
	armored_car_doDialogue(level.scrsound["price"]["youdunce"]);
	armored_car_doDialogue(level.scrsound["macgregor"]["rightsir"]);
	wait 1;
	armored_car_doDialogue(level.scrsound["macgregor"]["hangon"]);
	
	flag_set("armoredcar_start_player_path");
	
	armored_car_doDialogue(level.scrsound["price"]["whatonearth"]);
	armored_car_doDialogue(level.scrsound["macgregor"]["thankyousir"]);
	
	wait 4;
	//"watch out for panzerschrecks Davis, one hit and we're dead"
	thread armored_car_doDialogue("toujaneride_mcg_watchoutpz");
}

armored_car_newPath()
{
	flag_wait("armoredcar_start_player_path");
	level.armoredcar resumeSpeed(10);
	
	level array_thread (getentarray("second_pass_trigger","script_noteworthy"), ::triggerOn);
	
	//set how much health the armored car will have (panzerschreck attacks)
	wait 10;
	level.ArmoredCar thread armored_car_health_think();
}

armored_car_health_think()
{
	for (;;)
	{
		self waittill ("damage", ammount, attacker);
		
		if(!isdefined (attacker))
			continue;
		if(!isdefined(attacker.classname))
			continue;
		
		doDamage = false;
		if(issubstr(attacker.classname, "pschreck"))
			doDamage = true;
		else
		if(attacker.classname == "script_vehicle")
			doDamage = true;
		
		if (!doDamage)
			continue;
		
		level.armoredCarHealth -= ammount;
		if (level.armoredCarHealth <= 0)
		{
			level.armoredcar dodamage(level.armoredcar.health + 1, level.armoredcar.origin);
			level.armoredcar notify ("death");
		}
	}
}

armored_car_getinAnims()
{
	thread armored_car_getin_price();
	thread armored_car_getin_macgregor();
}

armored_car_getin_price()
{
	//make macgregor get here too so he's not late
	level.MacGregor thread anim_reach_solo( level.MacGregor, "getin", "tag_driver", undefined, level.armoredcar );
	
	level.Price anim_reach_solo( level.Price, "getin", "tag_passenger", undefined, level.armoredcar );
	level.Price thread anim_single_solo( level.Price, "getin", "tag_passenger", undefined, level.armoredcar );
	level.armoredcar thread playsoundinspace("toujaneride_pullbodyfromvehicle");
	level.Price waittillmatch ("single anim","grab");
	flag_set("armoredcar_gunner_fallout");
	level.Price waittillmatch ("single anim","end");
	level.Price thread anim_reach_solo( level.Price, "getinEnd", "tag_driver", undefined, level.armoredcar );
	
	//allow player access to the armored car now
	flag_set("allow_use_armoredcar");
	thread armored_car_playerEnter();
	
	//wait until the player has entered the armored car before making price get in
	flag_wait("player_in_armoredcar");
	
	flag_set("macgregor_getin");
	
	level.Price anim_reach_solo( level.Price, "getinEnd", "tag_driver", undefined, level.armoredcar );
	level.armoredcar thread playsoundinspace("toujaneride_pullbodyfromvehicle_2");
	level.Price anim_single_solo( level.Price, "getinEnd", "tag_driver", undefined, level.armoredcar );
	level.Price delete();
	level.Price = undefined;
	flag_set("price_entered_armoredcar");
}

armored_car_getin_macgregor()
{
	flag_wait("macgregor_getin");
	level.MacGregor anim_reach_solo( level.MacGregor, "getin", "tag_driver", undefined, level.armoredcar );
	level.armoredcar thread playsoundinspace("toujaneride_pullbodyfromvehicle_3");
	level.MacGregor anim_single_solo( level.MacGregor, "getin", "tag_driver", undefined, level.armoredcar );
	level.MacGregor delete();
	level.MacGregor = undefined;
	flag_set("macgregor_entered_armoredcar");
}

armored_car_playerToggleSideArm()
{
	level.player endon ("death");
	level.player endon ("exit_armored_car");
	wait 0.05;
	controllingTurret = true;
	level.player.usingArmoredCar = true;
	for (;;)
	{
		//debounce
		while (level.player useButtonPressed())
			wait 0.05;
		
		while (!level.player useButtonPressed())
			wait 0.05;
		
		if (controllingTurret)
		{
			//take the player off the turret and link him to the vehicle
			level.armoredcar useby (level.player);
			level.player playerlinktodelta( level.armoredcar, "tag_player", 0 );
			level.player.usingArmoredCar = false;
			controllingTurret = false;
		}
		else
		{
			//put the player back on the turret
			level.player unlink();
			level.armoredcar useby (level.player);
			level.player.usingArmoredCar = true;
			controllingTurret = true;
		}
	}
}

#using_animtree("eldaba_dogfight");
DogFights()
{
	level thread DogFights_CreateGroup();
	wait 2;
	level thread DogFights_CreateGroup();
	wait 2;
	level thread DogFights_CreateGroup();
}

DogFights_CreateGroup()
{
	rigAngles = (0,randomint(360),0);
	level thread DogFights_CreateSingle("axis", rigAngles);
	level thread DogFights_CreateSingle("allies", rigAngles);
}

DogFights_CreateSingle(team, rigAngles)
{
	//spawn rig
	rig 				= spawn("script_model", (33,7000, 1500 + randomint(1500) ));
	rig.angles			= rigAngles;
	rig.animname 		= "plane rig";
	rig setmodel ("xmodel/eldaba_plane_rig");
	rig UseAnimTree(#animtree);
	rig hide();
	
	//spawn plane
	plane = spawn ("script_model",(0,0,0));
	tag = undefined;
	if (team == "allies")
	{
		plane setmodel ("xmodel/vehicle_spitfire_flying");
		tag = "tag_rotator_b";
	}
	else if (team == "axis")
	{
		plane setmodel ("xmodel/vehicle_stuka_flying");
		tag = "tag_rotator_g";
	}
	
	plane linkto (rig, tag, (0,0,0), (0,0,0));
	
	//rig plays anim
	rigArray[0] = rig;
	rig thread anim_loop( rigArray, team );
}

autosave_leavingbuilding()
{
	getent("autosave_leavingbuilding","targetname") waittill ("trigger");
	thread autoSaveByName("takeArmoredCar");
}

#using_animtree("toujane_wall_tank_collapse");
halftrack_breakwall()
{
	breakwall = getent ("wall","targetname");
	breakwall UseAnimTree(#animtree);	
	getent("wall_trigger","targetname") waittill ("trigger");
	breakwall setmodel("xmodel/wall_tank_pieces");
	breakwall setflaggedanim("wall done", %wall_tank_collapse);
	breakwall playsound("wall_crumble_alt");
	exploder(0);
	turrets = getent("halftrack_killable","targetname").mgturret;
	for( i = 0; i < turrets.size; i++)
		 turrets[i] setmode("auto_nonai"); 
	breakwall waittill("wall done");
	breakwall setmodel("xmodel/wall_tank_broke");
}

armored_car_events_halftrack()
{
	//first event is the halftrack coming through the wall
	halftrack = maps\_vehicle::waittill_vehiclespawn("halftrack_killable");
	halftrack.health = 10000000;
	
	wait 1;
	armored_car_doDialogue(level.scrsound["price"]["davishalftrack"]);
	level.armoredcar setSpeed(5, 100);
	
	halftrack.health = 2000;
	
	thread armored_car_events_halftrack_timeout();
	halftrack thread armored_car_events_halftrack_kill();
	
	flag_wait("armored_car_scene_done");
	
	level.armoredcar resumeSpeed(100);
}

armored_car_events_halftrack_kill()
{
	level endon ("armored_car_scene_done");
	self waittill("death");
	wait 1.5;
	armored_car_doDialogue(level.scrsound["price"]["notbadcorporal"]);	
	flag_set("armored_car_scene_done");
	level notify ("armored_car_scene_done");
}

armored_car_events_halftrack_timeout()
{
	level endon ("armored_car_scene_done");
	wait 5;
	flag_set("armored_car_scene_done");
	level notify ("armored_car_scene_done");
}

first_tank_mg42settings()
{
	tank = maps\_vehicle::waittill_vehiclespawn("firstTank");
	wait 1;
	if (!isdefined(tank))
		return;
	
	for( i = 0 ; i < tank.mgturret.size ; i++ )
		tank.mgturret[i] thread maps\_mg42::mg42_setdifficulty (tank.mgturret[i],"hard");
}

armored_car_events_tank()
{
	//event of tank spotting you, then you make a left
	tank = maps\_vehicle::waittill_vehiclespawn("secondtank");
	
	wait 1;
	
	armored_car_doDialogue( level.scrsound["price"]["lookoutfortank"] );	
	armored_car_doDialogue( level.scrsound["macgregor"]["didyousaytank"] );	
	armored_car_doDialogue( level.scrsound["price"]["hespottedus"] );	
	armored_car_doDialogue( level.scrsound["price"]["makealeft"] );	
	armored_car_doDialogue( level.scrsound["macgregor"]["ihopeyouknow"] );	
	armored_car_doDialogue( level.scrsound["price"]["now"] );	
	
	wait 2;
	
	armored_car_doDialogue( level.scrsound["macgregor"]["placelooks"] );
	armored_car_doDialogue( level.scrsound["price"]["wherewestarted"] );
	armored_car_doDialogue( level.scrsound["price"]["rightturn"] );
	armored_car_doDialogue( level.scrsound["macgregor"]["yessir"] );
	armored_car_doDialogue( level.scrsound["price"]["hopethisworks"] );
	armored_car_doDialogue( level.scrsound["price"]["keepitsteady"] );
}

destroyable_tank()
{
	thread destroyable_tank_playerInPosition();
	
	//waits for the player to kill the tank, as the tank tries to blow up the armored car
	level.destroyable_tank = maps\_vehicle::waittill_vehiclespawn("destroyable_tank");
	level.destroyable_tank.health = level.destroyable_tank_health;
	level.destroyable_tank endon ("death");
	
	//wait until player is in position
	flag_wait("destroyable_tank_playerInPosition");
	
	wait 2;
	
	//make the tank turret aim to the armored car and shoot
	level.destroyable_tank setTurretTargetEnt(level.armoredcar, (0,0,32) );
	level.destroyable_tank waittill ("turret_on_target");
	wait 5;
	for (;;)
	{
		level.destroyable_tank notify ("turret_fire");
		wait 4;
	}
}

destroyable_tank_playerInPosition_stopArmoredCar()
{
	wait 6;
	level.armoredcar setSpeed(0,10);
}

destroyable_tank_playerInPosition()
{
	getent("destroyable_tank_trigger","targetname") waittill ("trigger");
	
	level.savehere = false;
	
	flag_set("destroyable_tank_playerInPosition");
	thread destroyable_tank_playerInPosition_stopArmoredCar();
	thread tank_panzerguys();
	thread destroyable_tank_dialogue();
	
	while(!isdefined(level.destroyable_tank))
		wait 0.05;
	
	level.destroyable_tank waittill ("death");
	flag_set("destroyable_tank_dead");
	
	level.destroyable_tank playsound ( "panzerschreck_hitcar" );
	
	level.savehere = undefined;
	thread autosavebyname("tankDestroyed");
}

destroyable_tank_dialogue()
{
	wait 7;
	armored_car_doDialogue( level.scrsound["macgregor"]["bloodyhell"] );
	armored_car_doDialogue( level.scrsound["price"]["wellgetitstarted"] );
	armored_car_doDialogue( level.scrsound["price"]["nowwouldbegood"] );
	armored_car_doDialogue( level.scrsound["macgregor"]["doinmebest"] );
	armored_car_doDialogue( level.scrsound["price"]["macgregor"] );
	
	flag_wait("destroyable_tank_dead");
	armored_car_doDialogue( level.scrsound["macgregor"]["thatsdoneit"] );
	level.armoredcar resumeSpeed(100);
	flag_set("moving_from_dead_tank");
}

tank_panzerguys()
{
	//spawn the panzerschreck guys
	tank_panzerguy = getentarray("tank_panzerguy","targetname");
	for (i=0;i<tank_panzerguy.size;i++)
	{
		for (j=0;j<tank_panzerguy.size;j++)
		{
			if ( int(tank_panzerguy[j].script_noteworthy) != i)
				continue;
			
			tank_panzerguy[j] stalingradSpawn();
		}
		wait 1;
	}
}

deadEnd_stop_for_reverse()
{
	getent("dead_end","targetname") waittill ("trigger");
	
	thread armored_car_doDialogue( level.scrsound["price"]["itsadeadend"] );
	
	//wait till the armored car has turned around
	level.armoredcar setWaitNode( getvehiclenode("stop_for_reverse","targetname") );
	level.armoredcar waittill ("reached_wait_node");
	
	level thread crash_into_truck();
	
	//turn on the vehicle trigger for the truck that will come
	level array_thread (getentarray("deadend_truck_spawn_trig","targetname"), ::triggerOn);
	
	level.armoredcar setSpeed(0,10);
	
	//spawn the panzerschreck guys
	thread panzer_callouts_deadend();
	deadend_panzerguys = getentarray("deadend_panzerguys","targetname");
	for (i=0;i<deadend_panzerguys.size;i++)
	{
		for (j=0;j<deadend_panzerguys.size;j++)
		{
			if ( int(deadend_panzerguys[j].script_noteworthy) == i)
			{
				guy = deadend_panzerguys[j] stalingradSpawn();
				if (spawn_failed(guy))
					assertMsg("panzerschreck guy didn't spawn");
			}
		}
		if (i < 3)
		{
			wait 1.5;
		}
	}
	
	thread autosavebyname("deadendalley");
	
	level.armoredcar resumeSpeed(100);
}

panzer_callouts_deadend()
{
	armored_car_doDialogue("toujaneride_mcg_pzahead");
	armored_car_doDialogue("toujaneride_price_takeoutpanzershrecks");
	armored_car_doDialogue("toujaneride_mcg_pzahead");
}

crash_into_truck()
{
	level.armoredcar setWaitNode( getvehiclenode("crash_into_truck","targetname") );
	level.armoredcar waittill ("reached_wait_node");
	
	thread autosavebyname("skidTruck");
	
	level.armoredcar setSpeed(0,1000);
	
	wait 8;
	
	level.armoredcar resumeSpeed(10);
}

tunnel_dialogue()
{
	trig = getent("tunnel_dialogue","targetname");
	spot = getent(trig.target,"targetname");
	
	trig waittill ("trigger");
	wait 2;
	spot playsoundinspace("matmata_planewarning");
	spot playsoundinspace("matmata_planewarning");
	spot delete();
	trig delete();
}

tunnel_bomb()
{
	tunnel_before = getentarray("tunnel_before","targetname");
	tunnel_after = getentarray("tunnel_after","targetname");
	
	for (i=0;i<tunnel_after.size;i++)
		tunnel_after[i] hide();
	
	level waittill ("tunnel_bombed");
	
	exploder(1);
	
	thread autosavebyname("tunnelCollapse");
	
	thread playsoundinspace ("wall_crumble2", (951, 3995, 40));
	wait 1;
	thread playsoundinspace ("wall_crumble2", (951, 3995, 40));
	wait 1;
	for (i=0;i<tunnel_after.size;i++)
		tunnel_after[i] show();
	for (i=0;i<tunnel_before.size;i++)
		tunnel_before[i] hide();
}

makeStuka()
{
	path = getVehicleNodeArray(self.target,"targetname");
	self waittill ("trigger");
	
	for ( i = 0 ; i < path.size ; i++ )
	{
		plane = spawnVehicle( "xmodel/vehicle_stuka_flying", "stuka", "Stuka", path[i].origin, path[i].angles );
		plane attachPath(path[i]);
		plane thread makeStuka_think();
	}
}

makeStuka_think()
{
	self endon ("death");
	self startPath();
	self waittill ("reached_end_node");
	self delete();
}

rollingTire()
{
	tireRadius = 19;
	
	path = getent("tirepath","targetname");
	tire = spawn("script_model", path.origin + (0,0,tireRadius));
	tire setmodel ("xmodel/prop_german_armored_car_tire");
	
	for(;;)
	{
		if (!isdefined(path.target))
			break;
		nextPoint = getent(path.target,"targetname");
		if (!isdefined(nextPoint))
			break;
		moveTime = 1.2;
		tire moveto(nextPoint.origin + (0,0,tireRadius), moveTime, 0, 0);
		tire thread rollingTire_rotate(nextPoint.origin, (moveTime * 0.4));
		tire rotatepitch(360, moveTime);
		wait moveTime;
		path = nextPoint;
	}
}

rollingTire_rotate(point, time)
{
	desiredAngles = VectorToAngles( point - self.origin );
	desiredAngles = ( 0, desiredAngles[1], 0 );
	
	self rotateTo(desiredAngles, time, (time * 0.25), (time * 0.25) );
	
	//self.angles = desiredAngles;
}

crashing_soon()
{
	getent("crashing_soon","targetname") waittill ("trigger");
	wait 1;
	armored_car_doDialogue("toujaneride_macgregor_hangon");
	armored_car_doDialogue("alamein_prc_watchformines");
	armored_car_doDialogue("toujaneride_price_macgregor");
}

Event_CarCrash()
{
	aftercrash_player = getent ("aftercrash_player","targetname");
	aftercrash_macgregor = getent ("aftercrash_macgregor","targetname");
	aftercrash_price = getent ("aftercrash_price","targetname");
	
	level.ArmoredCar waittill ("reached_end_node");
	
	thread battleChatterOn("allies");
	level.player notify ("exit_armored_car");
	//make sure the player is in the armored car and not off the turret
	if ( (isdefined(level.player.usingArmoredCar)) && (level.player.usingArmoredCar == false) )
		level.ArmoredCar useby (level.player);
	
	level.ArmoredCar playsound ( "panzerschreck_hitcar" );
	thread maps\_fx::loopfx("armoredcar_smoke", level.armoredcar.origin, 1, level.armoredcar.origin + (0,0,200) );
	
	exploder(6);
	
	playfx(level.armored_car_death_fx, level.armoredcar.origin);
	
	level.flags["Player In Armored Car"] = false;
	level.flags["Breakable Boxes"] = false;
	
	thread maps\_armoredcar::overheat_disable();
	
	macgreg_spawner = getent ("macgregor2","script_noteworthy");
	level.MacGregor = undefined;
	level.MacGregor = macgreg_spawner doSpawn();
	if (spawn_failed(level.MacGregor))
		assertMsg("Second MacGregor failed to spawn");
	level.MacGregor.animname = "macgregor";
	price_spawner = getent("price2","script_noteworthy"); 
	level.Price = undefined; 
	level.Price = price_spawner dospawn();
	level.Price.animname = "price"; 
	
	level.MacGregor thread magic_bullet_shield();
	level.Price thread magic_bullet_shield();
	
	level.Price.accuracy = .7; 
	level.MacGregor.accuracy = .8; 
	
	level.excluders[0] = level.Price;
	level.excluders[1] = level.MacGregor;
	
	primaryWeapon = level.player getWeaponSlotWeapon("primary");
	secondaryWeapon = level.player getWeaponSlotWeapon("primaryb");
	level.player takeAllWeapons();
	
	//thread rollingTire();
	
	level.explosion_fov = spawn("script_model", level.armoredcar.origin);
	level.explosion_fov.angles = ( 0,level.armoredcar.angles[1],0 );
	level.explosion_fov setmodel ("xmodel/duhoc_player_viewcam_joints");
	
	level.explosion_fov UseAnimTree(level.scr_animtree["player"]);
	
	level.ArmoredCar useby (level.player);
	level.ArmoredCar setModel(level.armored_car_death_model);
	level.player setorigin(level.explosion_fov getTagOrigin("tag_guy_feet"));
	level.player setPlayerAngles(level.explosion_fov getTagAngles("tag_guy_feet") );
	level.player unlink();
	level.player allowProne(true);
	level.player playerLinkToAbsolute(level.explosion_fov, "tag_guy_feet");
	level.player shellshock("default", 5);
	level.explosion_fov setflaggedanimknobrestart("player_thrown",level.scr_anim["player"]["player_thrown"]);
	level.explosion_fov waittillmatch("player_thrown","end");

	//AI on friendlychain now
	level.MacGregor setgoalEntity (level.player);
	level.MacGregor.followmin = -1;
	level.MacGregor.followmax = 0;
	level.Price setgoalEntity (level.player);
	level.Price.followmin = -1;
	level.Price.followmax = 1;
	level.Price.pathenemyfightdist = 320;
	level.Price.pathenemylookahead = 320; 
	level.MacGregor.pathenemyfightdist = 320;
	level.MacGregor.pathenemylookahead = 320; 
	wait 1;
	
	//move ai out of vehicle
	dummy1 = spawn ("script_origin",level.MacGregor.origin);
	level.MacGregor linkto (dummy1);
	dummy1 moveTo (aftercrash_macgregor.origin, 1);
	dummy2 = spawn ("script_origin",level.Price.origin);
	level.Price linkto (dummy2);
	dummy2 moveTo (aftercrash_price.origin, 1);
	wait 2;
	dummy1 delete();
	dummy2 delete();

	level.explosion_fov clearanim(level.scr_anim["player"]["player_thrown"], 0);
	level.explosion_fov setflaggedanimknobrestart("player_standup",level.scr_anim["player"]["player_standup"]);
	level.explosion_fov waittillmatch("player_standup","end");

	level.player unlink();
	playerAngles = (0,280,0);
	//playerAngles = level.explosion_fov getTagAngles( "tag_guy_feet" );
	//playerAngles = (0, 0, playerAngles[2]);
	level.player setplayerangles( playerAngles );
	
	level.player takeAllWeapons(); 
	level.player giveweapon(primaryWeapon);
	level.player giveweapon(secondaryWeapon); 
	level.player giveWeapon("MK1britishfrag");
	level.player giveWeapon("smoke_grenade_american");
	level.player switchToOffhand("MK1britishfrag");
	level.player unlink(); 

	thread autoSaveByName("carCrash");

	level thread Dialogue_AtCarCrash();
}

skidjeep()
{
	skidjeep = maps\_vehicle::waittill_vehiclespawn("skidjeep");
	wait 0.05;
	if (!isdefined(skidjeep))
		return;
	wait 1.0;
	skidjeep thread playsoundinspace ("vehicle_skid");
}

#using_animtree("toujane_wall_tank_collapse");
tank_wall_break()
{
	trig = getent("tank_wall_break_trig","targetname");
	breakwall = getent (trig.target,"targetname");
	breakwall UseAnimTree(#animtree);
	
	wait 1;
	
	trig waittill ("trigger");
	breakwall setmodel ("xmodel/wall_tank_pieces");
	breakwall setflaggedanim("wall done", %wall_tank_collapse);
	breakwall playsound ("wall_crumble");
	exploder(0);
	breakwall waittill ("wall done");
	breakwall setmodel ("xmodel/wall_tank_broke");
}

Dialogue_AtCarCrash()
{
	battleChatterOff("allies"); 
	level playSoundinSpace(level.scrsound["price"]["runner"], level.price.origin);
	battleChatterOn("allies");
}

AI_GoToNode_Delete(node)
{
	self endon ("death");
	self.goalradius = 16;
	self setgoalnode (node);
	self waittill ("goal");
	self delete();
}

magic_health_buffer()
{
	originalHealth = self.health;
	self endon ("death");
	for(;;)
	{
		self waittill ("damage", ammount, attacker);
		if (attacker == level.player)
			self.health = originalHealth;
	}
}

building_break_turret()
{
	building = getent (self.target,"targetname");
	//center = getent (building.target,"targetname");
	
	for (;;)
	{
		self waittill ("damage", amount, ent);
		//player in armored car - only armored car turret can do destruction
		if ( flag("InsideArmoredCar") )
		{
			if (ent == level.player)
				break;
		}
		//player not in armored car - only mg42 can do destruction
		else if (isdefined(level.defend_mg42))
		{
			if (ent != level.player)
				continue;
			user = level.defend_mg42 getTurretOwner();
			if (!isdefined (user))
				continue;
			if (user == level.player)
				break;
		}
	}
	
	direction_vec = vectornormalize (building.origin - ent.origin);
	direction_vec = vectorScale(direction_vec, 300);
	building moveGravity (direction_vec, 4);
	rotate_x = ( 300 + randomfloat (300) );
	rotate_y = ( 100 + randomfloat (100) );
	rotate_z = ( 100 + randomfloat (100) );
	
	if (randomint(2) == 0)
		rotate_x = ( rotate_x * -1 );
	if (randomint(2) == 0)
		rotate_y = ( rotate_y * -1 );
	if (randomint(2) == 0)
		rotate_z = ( rotate_z * -1 );
	
	building rotateVelocity ( (rotate_x, rotate_y, rotate_z), 4);
	
	playfx (level._effect["building_break"], building.origin);
	wait 0.05;
	playfx (level._effect["building_break"], building.origin);
	wait 0.1;
	playfx (level._effect["building_break"], building.origin);
	
	wait 4;
	building delete();
	//center delete();
	self delete();
}

updatePlayerKillCount()
{
	if ( level.playerKills > level.firstObjectiveKillsRequired )
		return;
	self waittill ("death", attacker);
	if (!isdefined (attacker))
		return;
	if (attacker != level.player)
		return;
	
	wait (5 + randomfloat (5));
	
	level.playerKills++;
	
	percentage = 0;
	fifth = (level.firstObjectiveKillsRequired / 5);
	if (level.playerKills >= fifth )
		percentage = 20;
	if (level.playerKills >= (fifth * 2) )
		percentage = 40;
	if (level.playerKills >= (fifth * 3) )
		percentage = 60;
	if (level.playerKills >= (fifth * 4) )
		percentage = 80;
	if (level.playerKills >= level.firstObjectiveKillsRequired )
	{
		if (!flag("opening_dialogue_done"))
			return;
		if (!isdefined (level.ArmoredCar))
			flag_set("spawn_armored_car");
		percentage = 100;
	}
	
	objective_string_nomessage(1, &"TOUJANE_RIDE_OBJ_DEFEND", percentage );
}

spawners_tweak()
{	
	node = undefined;
	if (isdefined (self.target))
		node = getnode (self.target,"targetname");
	
	//prevent panzerschreck guys from going to their node
	if (self.classname == "actor_axis_afrikakorp_reg_pschreck")
		self.script_moveoverride = 1;
	
	for (;;)
	{
		self waittill ("spawned", spawned);
		if (spawn_failed(spawned))
			continue;
		spawned thread updatePlayerKillCount();
		if (isdefined (spawned.team))
			spawned.script_team = spawned.team;
		spawned.fightDist = (spawned.fightDist * 0.5);
		
		if (self.classname == "actor_axis_afrikakorp_reg_pschreck")
		{
			spawned thread panzerGuy(node);
			continue;
		}
		
		if (!isdefined (spawned.script_noteworthy))
			continue;
		
		switch (spawned.script_noteworthy)
		{
			case "delayed_runaway_delete_at_goal":
				goalnode = getnode (self.target,"targetname");
				runawayNode = getnode (goalnode.target,"targetname");
				wait 15;
				if ( (isdefined(spawned)) && (isalive(spawned)) )
				{
					spawned.fightDist = 0;
					spawned.maxdist = 0;
					spawned.maxsightdistsqrd = 4;
					spawned.ignoreme = true;
					spawned setgoalnode (runawayNode);
					spawned thread spawners_tweak_goalDelete();
				}
				break;
			case "delete_at_goal":
				spawned thread spawners_tweak_goalDelete();
				break;
			case "delete_at_goal_nosight":
				spawned.fightDist = 0;
				spawned.maxdist = 0;
				spawned.maxsightdistsqrd = 4;
				spawned.ignoreme = true;
				spawned.goalradius = 64;
				spawned thread spawners_tweak_goalDelete();
				break;
			case "no_sight_till_goal":
				spawned.goalradius = 350;
				spawned.old_fightdist = spawned.fightdist;
				spawned.fightdist = 4;
				spawned thread spawners_tweak_sightOnGoal(spawned.old_fightdist);
				break;
			case "no_sight":
				spawned.old_fightdist = spawned.fightdist;
				spawned.fightdist = 4;
				break;
			case "delete_at_goal_nosight_nodechain":
				spawned.fightDist = 0;
				spawned.maxsightdistsqrd = 4;
				spawned.ignoreme = true;
				spawned.goalradius = 64;
				if (!isdefined (node))
					break;
				spawned thread spawners_tweak_chainDelete(node);
				break;
			case "no_damage_from_AI":
				spawned thread magic_health_buffer();
				break;
			case "smallgoalfirst":
				spawned thread smallgoalfirst(node);
			default:
				break;
		}
	}
}

panzerGuy(node)
{
	assert(isdefined(node));
	self.anim_dropPanzer = true;
	self.goalradius = 8;
	maps\_spawner::panzer_target(self, node, undefined, level.armoredcar, (0,0,32) );
}

smallgoalfirst(node)
{
	if (!isdefined(node))
		return;
	if (!isdefined(node.radius))
		return;
	self.goalradius = 8;
	self waittill ("goal");
	self.goalradius = node.radius;
}

spawners_tweak_sightOnGoal(value)
{
	self endon ("death");
	self waittill ("goal");
	self.fightdist = value;
}

spawners_tweak_goalDelete()
{
	self endon ("death");
	self waittill ("goal");
	self delete();
}

spawners_tweak_chainDelete(node)
{
	for (;;)
	{
		self setgoalnode (node);
		self waittill ("goal");
		if (!isdefined (node.target))
			break;
		node2 = getnode(node.target,"targetname");
		if (!isdefined (node2))
			break;
		node = node2;
	}
	self delete();
}

spawnAndTag(spawnerArray,maxNumberToSpawn,spawnRandom,isPlayerGoal,startRadius)
{
	if(!isdefined(spawnerArray))
		return; 

	if(isdefined(maxNumberToSpawn) && isdefined(spawnRandom) && (spawnRandom == true))
	{
		for(i = 0; i < maxNumberToSpawn; i++)
		{
			spawned = spawnerArray[randomint(spawnerArray.size - 1)] doSpawn(); 
			if(spawn_failed(spawned))
				continue;
			
			if(isdefined(spawnerArray[i].targetname))
			{
				spawned.targetname = "spawned_" + spawnerArray[i].targetname; 
			}
			if(isdefined(spawnerArray[i].script_noteworthy))
			{
				spawned.script_noteworthy = "spawned_" + spawnerArray[i].script_noteworthy;
			}				
			if(isdefined(isPlayerGoal) && isPlayerGoal == true)
			{
				spawned setgoalentity(level.player); 
				if(isdefined(startRadius))
				{
					spawned.goalradius = startRadius; 
				}
			}
		}
		return spawnerArray; 
	}
	
	for(i = 0; i < spawnerArray.size; i++)
	{
		if(isdefined(maxNumberToSpawn) && (i >= maxNumberToSpawn))
			continue; 
		spawned = spawnerArray[i] doSpawn(); 
		if(spawn_failed(spawned))
			continue; 
		if(isdefined(spawnerArray[i].targetname))
		{
			spawned.targetname = "spawned_" + spawnerArray[i].targetname; 
		}
		if(isdefined(spawnerArray[i].script_noteworthy))
		{
			spawned.script_noteworthy = "spawned_" + spawnerArray[i].script_noteworthy;
		}				
	}	
	return spawnerArray; 
}

decrementGoalRadiusOverTime(nameOfSpawnedArray,minRadius,amountToDecrement,interval)
{
	while(1)
	{
		wait(interval); 
		ourGuys = getentarray(nameOfSpawnedArray,"targetname");
		ourGuys = pruneArrayOfDeadGuys(ourGuys); 
	
		for(i = 0; i < ourGuys.size; i++)
		{
			if(!isdefined(ourGuys[i]))
				continue; 
			if(ourGuys[i].goalradius > minradius)
				ourGuys[i].goalradius = ourGuys[i].goalradius - amountToDecrement; 
		}

		wait(0.05); 
	}
	
}
// checks an array of guys spawned with spawnAndTag, and respawns if they fall
// underneath a number
checkSpawnedArrayAndRespawn(spawnedArray,minimumNumberOfGuys,numberOfTimesToRespawn)
{
	while(1)
	{
		wait(0.05);
		for(i = 0; i < spawnedArray.size; i++)
		{
			if(!isalive(spawnedArray[i]))
			{
				spawnedArray = array_remove(spawnedArray,spawnedArray[i]);
				i = 0;
				continue; 
			}
		}
		if( (spawnedArray.size <= minimumNumberOfGuys) && (numberOfTimesToRespawn > 0) )
		{
			spawnAndTag(getentarray(getsubstr(spawnedArray[0].targetname,8),"targetname")); 
			numberOfTimesToRespawn--; 
			wait(1);
		}
	}
}

pruneArrayOfDeadGuys(arrayToPrune)
{
	for(i = 0; i < arrayToPrune.size; i++)
	{
		if(!isalive(arrayToPrune[i]))
		{
			arrayToPrune = array_remove(arrayToPrune,arrayToPrune[i]);
			i = 0;
			continue; 
		}
	}
	return arrayToPrune; 
}

checkSpawnedAndRetreat(spawnedArray,minimumNumberOfGuys,nodeToRetreatTo,message)
{
	while(1)
	{	
		wait(0.05);
		spawnedArray = pruneArrayOfDeadGuys(spawnedArray); 
		if(spawnedArray.size < minimumNumberOfGuys)
		{
			for(i = 0; i < spawnedArray.size; i++)
			{
				spawnedArray[i] setgoalnode(nodeToRetreatTo); 
				if(isdefined(message))
				{
					spawnedArray[i] thread guySendMessageOnGoal(message);					
				}
			}
			break; 
		}
	}
}

guySendMessageOnGoal(message)
{
	self waittill("goal"); 
	level notify(message); 
}

checkTouchingTriggers(arrayOfTriggers,message)
{
	assertEX(isdefined(self), "isTouchingTriggers called on undefined");
	assertEX(isdefined(arrayOfTriggers), "isTouchingTriggers called on undefined array");
		
	while(1)
	{
		level endon(message); 
		for(i = 0; i < arrayOfTriggers.size; i++)
		{
			if(self istouching(arrayOfTriggers[i]))
				level notify(message);
		}
		wait(0.05); 
	}
}

checkPlayerTouchingTrigger(trigger, message)
{
	while(1)
	{
		wait(0.05); 

		if(isdefined(trigger) && (level.player istouching(trigger)))
		{
			level notify(message); 
		}
	}
}


Event_EscapeFirstEncounter()
{
	getent("first_enc_trigger","targetname") waittill("trigger");
	spawnAndTag(getentarray("first_wave","targetname"));
	getent("first_enc_trigger","targetname") delete();
}

Event_EscapeSecondEncounter()
{
	getent("second_enc_trigger","targetname") waittill("trigger");
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	level.price anim_single_solo(level.price, "toujaneride_pri_maccovertherear");
	flag_set("allow_talking");
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	level.macgregor anim_single_solo(level.macgregor, "toujaneride_mcg_considerdone");
	flag_set("allow_talking");
	battleChatter_Allies("on");
	
	spawnAndTag(getentarray("second_wave","targetname"));
	getent("second_enc_trigger","targetname") delete(); 
	while(getentarray("spawned_second_wave","targetname").size > 2)
	{
		wait(0.5); 
	}
	spawnAndTag(getentarray("second_wave2","targetname"));
	wait(1); 
	level notify("protect rear");
	thread firstWavesDone(); 
}

firstWavesDone()
{
	while(1)
	{
		firstwave = getentarray("spawned_first_wave","targetname");	
		secondwave = getentarray("spawned_second_wave","targetname"); 
		secondwave2 = getentarray("spawned_second_wave2","targetname"); 
		if((firstwave.size == 0) && (secondwave.size == 0) && (secondwave2.size == 0))
		{
				flag_wait("allow_talking");
				battleChatter_Allies("off");
				flag_clear("allow_talking");
				level.price anim_single_solo(level.price,"toujaneride_pri_pushingrally");
				flag_set("allow_talking");
				battleChatter_Allies("on");
				
				level.MacGregor setgoalnode(getnode("macgregor02","targetname"));
				level.Price setgoalnode(getnode("price02","targetname")); 
				level.Price.goalradius = 16;
				level.MacGregor.goalradius = 16; 
				level.Price thread guySendMessageOnGoal("price at 02");
				level.MacGregor thread guySendMessageOnGoal("macgregor at 02"); 
				break; 
		}
		wait(0.05); 
	}	
}



BackgroundExplosions()
{
	while(1)
	{
		mortars = getentarray("mortars","targetname");
		for(i = 0; i < mortars.size; i++)
		{
			if(randomint(5) == 1)
			{
				playfx(level._effect["mortar building explosion"], mortars[i].origin);
					earthquake(.50, 2, mortars[i].origin, 2500);
				soundnum = randomint(3) + 1;
				thread playsoundinspace ("mortar_explosion"+soundnum,mortars[i].origin);
			}
			else
			{
				playfx(level._effect["mortar explosion"], mortars[i].origin);
					earthquake(.30, 2, mortars[i].origin, 2500);
				soundnum = randomint(3) + 1;
				thread playsoundinspace ("mortar_explosion"+soundnum,mortars[i].origin); 

			}
			wait(1 + randomfloat(5));
		}
		wait(0.05); 
	}
}

checkEscapeAutoSave1()
{
	level thread checkPlayerTouchingTrigger(getent("autosave_escape1","targetname"),"save 1");
	level waittill("save 1"); 
	thread autoSaveByName("escape1");
	getent("autosave_escape1","targetname") delete(); 
}

checkEscapeAutoSave2()
{
	getent("autosave_escape2","targetname") waittill("trigger"); 
	thread autoSaveByName("escape2");
	level notify("price at 03");
	getent("autosave_escape2","targetname") delete(); 
}

// spawnAndTag(spawnerArray,maxNumberToSpawn,spawnRandom,isPlayerGoal,startRadius)
// decrementGoalRadiusOverTime(nameOfSpawnedArray,minRadius,amountToDecrement,interval)

rearAttackersStart()
{
	getent("rear_attackers_start_trigger","targetname") waittill("trigger"); 
	spawnAndTag(getentarray("rear_attackers_start","targetname"),100,false,true,900);
	wait(2);
	thread decrementGoalRadiusOverTime("spawned_rear_attackers_start",500,50,5);
	level.MacGregor setgoalnode(getnode("macgregor01","targetname"));
	level.Price setgoalnode(getnode("price01","targetname")); 
	level.Price.goalradius = 16;
	level.MacGregor.goalradius = 16; 
	rearAttackers = getentarray("spawned_rear_attackers_start","targetname"); 
	
}

findClosestToPlayer(exclude, otherPlayerEnt)
{
	closestEnt = undefined;
	closest = 100000000;
	
	if (isdefined(level.tommy))
	{
		if (!isdefined(exclude))
			exclude = [];
		else
			exclude[exclude.size] = level.tommy;
	}
	
	for (i=0;i<self.size;i++)
	{
		isExcluder = false;
		if ( (isdefined (exclude)) && (isdefined (exclude[0])) )
		{
			//find if it's one of the exclude entities
			for (j=0;j<exclude.size;j++)
			{
				if (exclude[j] == self[i])
					isExcluder = true;
			}
		}
		
		if (isExcluder)
			continue;
		
		if (isdefined (otherPlayerEnt))
			dist = distance (otherPlayerEnt.origin, self[i].origin);
		else
			dist = distance (level.player.origin, self[i].origin);
		if (dist < closest)
		{
			closest = dist;
			closestEnt = self[i];
		}
	}
	return closestEnt;
}

attackersUpLadder()
{
	level waittill("price at 02");
	thread rearAttackerLadder(); 

	wait(4);
	
	guy = getaiarray("allies") findClosestToPlayer(level.excluders);
	if (!isdefined(guy))
		return;
	
	guy thread magic_bullet_shield();
	guy.animname = "soldier";
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	guy anim_single_solo(guy, "toujaneride_bs4_laddertorear");
	flag_set("allow_talking");
	battleChatter_Allies("on");
	
	guy notify ("stop magic bullet shield");
}

rearAttackerLadder()
{
	spawnAndTag(getentarray("ladderAttack","targetname")); 
	while(1)
	{
		
		ladderAttackSpawners = getentarray("ladderAttack","targetname");
		if(!isdefined(ladderAttackSpawners))
			break; 	
			
		ladderAttackers = getentarray("spawned_ladderAttack","targetname");
		if(ladderAttackers.size < 7)
		{
			numberOfGuysToSpawn = 7 - ladderAttackers.size;
			spawnAndTag(ladderAttackSpawners,numberOfGuysToSpawn,true); 
		}	
		wait(0.05); 
	}
	
}

interSectionFirefight()
{
	getent("intersectionFirefight_trigger","targetname") waittill("trigger"); 
	garbage = getentarray("spawned_rear_attackers_start","targetname"); 
	for(i = 0; i < garbage.size; i++)
		garbage[i] delete(); 
	spawnAndTag(getentarray("attackingNazis","targetname")); 
	spawnAndTag(getentarray("deadAllyGuys","targetname")); 
	allyGuys = getentarray("spawned_deadAllyGuys","targetname"); 
	wait(4); 
	level thread attackingNazisDestroyed(); 
	for(i = 0; i < allyGuys.size; i++)
	{
		if(isalive(allyGuys[i]))
		{
			allyGuys[i].accuracy = .2; 
			allyGuys[i].health = 20; 
		}
	}
	
	wait 10;
	
	allyGuys = pruneArrayOfDeadGuys(allyGuys); 
	for(i = 0; i < allyGuys.size; i++)
	{
		if(isdefined(allyGuys[i]))
		{
			magicbullet("kar98k", allyGuys[i].origin + (0,0,50),getent("magicShotSpot","targetname").origin);
			allyGuys[i] DoDamage(1000,getent("magicShotSpot","targetname").origin);
		}
		wait(randomfloat(2)); 
	}	
}

attackingNazisDestroyed()
{
	while(1)
	{
		attackingNazis = getentarray("spawned_attackingNazis","targetname"); 
		if(attackingNazis.size == 0)
		{
			flag_wait("allow_talking");
			battleChatter_Allies("off");
			flag_clear("allow_talking");
			level.macgregor anim_single_solo(level.macgregor,"toujaneride_mcg_totallyoutnumbered");
			flag_set("allow_talking");
			battleChatter_Allies("on");
			
			level.MacGregor setgoalnode(getnode("macgregor03","targetname"));
			level.Price setgoalnode(getnode("price03","targetname")); 
			level.Price.goalradius = 16;
			level.MacGregor.goalradius = 16; 
			level.Price thread guySendMessageOnGoal("price at 03");
			level.MacGregor thread guySendMessageOnGoal("macgregor at 03"); 			
			break; 
		}
		wait(0.05); 
	}

}

moreAttackingNazis()
{
	level waittill("price at 03"); 
	spawnAndTag(getentarray("attackingNazis2","targetname")); 
	moreAttackingNazis = getentarray("spawned_attackingNazis2","targetname");

	while(1)
	{
		moreAttackingNazis = getentarray("spawned_attackingNazis2","targetname");
		if(moreAttackingNazis.size == 0)
		{
			level.MacGregor setgoalnode(getnode("macgregor04","targetname"));
			level.Price setgoalnode(getnode("price04","targetname")); 
			level.Price.goalradius = 16;
			level.MacGregor.goalradius = 16; 
			level.Price thread guySendMessageOnGoal("price at 04");
			level.MacGregor thread guySendMessageOnGoal("macgregor at 04"); 							
			break; 
		}	
		wait(0.05); 
	}
}

attackersByTank()
{
	level waittill("price at 04"); 
	spawnAndTag(getentarray("attackersByTank","targetname")); 
	
	while(1)
	{
		attackersByTank = getentarray("attackersByTank","targetname"); 
		if(attackersByTank.size == 0)
		{
			level.MacGregor setgoalnode(getnode("macgregor05","targetname"));
			level.Price setgoalnode(getnode("price05","targetname")); 
			level.Price.goalradius = 16;
			level.MacGregor.goalradius = 16; 
			level.Price thread guySendMessageOnGoal("price at 05");
			level.MacGregor thread guySendMessageOnGoal("macgregor at 05"); 							
			break; 			
		}
		wait(0.05);
	}
}

rearProtector()
{
	level waittill("protect rear"); 
	spawnAndTag(getentarray("suicideChargers","targetname")); 
	suicideGuys = getentarray("spawned_suicideChargers","targetname"); 
	for(i = 0; i < suicideGuys.size; i++)
	{
		suicideGuys[i] thread magic_bullet_shield();
		suicideGuys[i].accuracy = .5;
		suicideGuys[i].pathenemyfightdist = 320; 
		suicideGuys[i].pathenemylookahead = 320; 
	}
	rearProtectors = getentarray("spawned_suicideChargers","targetname"); 
	for(i = 0; i < rearProtectors.size; i++)
	{
		rearProtectors[i] setgoalnode(getnode("rearProtector","targetname")); 
		rearProtectors[i].goalradius = 320;
	}
	wait(1);
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	level.price anim_single_solo(level.price,"toujaneride_pri_wheresrallypoint");
	flag_set("allow_talking");
	battleChatter_Allies("on");
	
	guy = getaiarray("allies") findClosestToPlayer(level.excluders);
	if (!isdefined(guy))
		return;
	
	guy thread magic_bullet_shield();
	guy.animname = "soldier";
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	guy anim_single_solo(guy, "toujaneride_bs4_rallytosouth");
	flag_set("allow_talking");
	battleChatter_Allies("on");
	
	guy notify ("stop magic bullet shield");
}

smokeAttackRear()
{
	level waittill("price at 03");
	//getent("smokeAttackRear_trigger","targetname") waittill("trigger");
	
	//spawnAndTag(getentarray("endCornerAttackers","targetname")); 

	garbage = getentarray("spawned_ladderAttack","targetname");
	suicideGuys = getentarray("spawned_suicideChargers","targetname");
	
	for(i = 0; i < suicideGuys.size; i++)
	{
		suicideGuys[i] notify("stop magic bullet shield"); 
		suicideGuys[i].accuracy = .1;
		suicideGuys[i].health = 10;
	}
	
	for(i = 0; i < garbage.size; i++)
		garbage[i] delete(); 
				
	spawnAndTag(getentarray("smokeThrower","targetname") );
	smokeThrower = getent("spawned_smokeThrower","targetname"); 
	if (!isdefined(smokeThrower))
		return;
	smokeThrower.grenadeWeapon = "smoke_grenade_american";
	smokeThrower.grenadeAmmo++;
	smokeThrower MagicGrenade(getent("spawned_smokeThrower","targetname").origin + (0,0,50), getent("smokeSpot","targetname").origin, 1.5);
	wait(1);
	if (!isdefined(smokeThrower))
		return;
	smokeThrower delete(); 
	wait(4);
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	level.macgregor anim_single_solo(level.macgregor,"toujaneride_mcg_smoketonorth");
	flag_set("allow_talking");
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	level.price anim_single_solo(level.price,"toujaneride_pri_notimeforthat");
	flag_set("allow_talking");
	battleChatter_Allies("on");
	
	spawnAndTag(getentarray("smokeRearAttacker","targetname")); 
	wait(1); 
	for(;;)
	{
		
		smokeAttackerSpawners = getentarray("smokeRearAttacker","targetname");
		if(!isdefined(smokeAttackerSpawners))
			break; 	
			
		smokeAttackers = getentarray("spawned_smokeRearAttacker","targetname");
		if (!isdefined(smokeAttackers))
			return;
		if (smokeAttackers.size <= 0)
			return;
		if(smokeAttackers.size < 5)
		{
			numberOfGuysToSpawn = 5 - smokeAttackers.size;
			spawnAndTag(smokeAttackerSpawners,numberOfGuysToSpawn,true); 
		}	
		wait(0.05); 
	}
	
}


lastNazis()
{
	getent("lastNazi_trigger","targetname") waittill("trigger"); 
	spawnAndTag(getentarray("nazisAtEnd","targetname")); 	
}

Battlechatter_Allies(OnOff)
{
	if (OnOff == "on")
		battleChatterOn("allies");
	else if (OnOff == "off")
		battleChatterOff("allies");
}

guysAtEnd()
{
	getent("guysAtEnd_trigger","targetname") waittill("trigger");
	spawnAndTag(getentarray("ourHeroes","targetname")); 	
	
	ourHeroes = getentarray("spawned_ourHeroes","targetname"); 
	naziBadMen = getentarray("spawned_nazisAtEnd","targetname"); 

	for(i = 0; i < ourHeroes.size; i++)
	{
		ourHeroes[i] thread magic_bullet_shield();
		ourHeroes[i].accuracy = 1; 
	}

	for(i = 0; i < naziBadMen.size; i++)
	{
		naziBadMen[i].health = 1; 		
	}
	
	while(naziBadMen.size > 0)
	{
		naziBadMen = pruneArrayofDeadGuys(naziBadMen); 
		wait(0.05); 

	}
	
	waving_guy = getent("spawned_waver","script_noteworthy"); 

	node = getnode("waveNode","targetname"); 
	
	guy = getaiarray("allies") findClosestToPlayer(level.excluders);
	if (isdefined(guy))
	{
		guy thread magic_bullet_shield();
		guy.animname = "soldier";
		
		flag_wait("allow_talking");
		wait 1;
		flag_wait("allow_talking");
		battleChatter_Allies("off");
		flag_clear("allow_talking");
		guy anim_single_solo(guy, "toujaneride_bs4_lasttruck");
		flag_set("allow_talking");
		battleChatter_Allies("on");
		
		guy notify ("stop magic bullet shield");
	}
	
	flag_set("last_truck_dialogue_done");

	flag_set("music_evacuation");

	if ( (isdefined(waving_guy)) && (isalive(waving_guy)) )
	{
		waving_guy.fightDist = 1;
		waving_guy.maxdist = 1;
		waving_guy.goalradius = 16; 
		waving_guy.animname = "generic";
		waving_guy.team = "neutral";
		waving_guy setgoalnode(node); 
		waving_guy set_forcegoal();
		waving_guy waittill("goal"); 
		for(i = 0; i < 2; i++)
		{
			node thread anim_single_solo(waving_guy, "wave");		
				wait(4); 
		}
	}
	
	allies = getaiarray("allies");
	
	for(i = 0; i < allies.size; i++)
	{
		allies[i] setgoalnode(getnode("truckNode","targetname"));
	}
	wait(7);
	
	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	level.price anim_single_solo(level.price, "toujaneride_price_backforthistown");
	flag_set("backfortown_dialogue_done");
	flag_set("allow_talking");
	battleChatter_Allies("on");
	
	wait(1);
	if (!flag("level_ending"))
	{
		flag_set("level_ending");
		flag_wait("last_truck_dialogue_done");
		flag_wait("backfortown_dialogue_done");
		flag_wait("teachthose_dialogue_done");
		flag_wait("rallyahead_dialogue_done");
		battleChatterOff("allies");
		objective_state(3, "done");
		maps\_endmission::nextmission();
	}
}

rearAdmirals()
{
	getent("rearAdmirals_trigger","targetname") waittill("trigger"); 
	smokeAttackerSpawners = getentarray("smokeRearAttacker","targetname");
	for(i = 0; i < smokeAttackerSpawners.size; i++)
	{
		smokeAttackerSpawners[i].count = 0; 
	}

	spawnAndTag(getentarray("rearAdmirals","targetname")); 
	rearAdmiralSpawners = getentarray("rearAdmirals","targetname");

	flag_wait("allow_talking");
	battleChatter_Allies("off");
	flag_clear("allow_talking");
	level.macgregor anim_single_solo(level.macgregor,"toujaneride_mcg_teachthose");
	thread ralley_ahead();
	flag_set("teachthose_dialogue_done");
	flag_set("allow_talking");
	battleChatter_Allies("on");
	
	while(1)
	{
		rearAdmiralSpawners = getentarray("rearAdmirals","targetname");
		if(!isdefined(rearAdmiralSpawners))
			break; 	
			
		admirals = getentarray("spawned_rearAdmirals","targetname");
		if(admirals.size < 6)
		{
			numberOfGuysToSpawn = 6 - admirals.size;
			spawnAndTag(rearAdmiralSpawners,numberOfGuysToSpawn,true); 
		}	
		wait(0.05); 
	}
}

ralley_ahead()
{
	level.price anim_single_solo(level.price,"toujaneride_pri_rallyjustahead");
	flag_set("rallyahead_dialogue_done");
}

music()
{
	flag_wait("music_ominous");
	
	musicplay("toujane_victory_barely");
	
	flag_wait("macgregor_entered_armoredcar");
	flag_wait("price_entered_armoredcar");
	
	musicplay("toujane_vehicle_ride");
	wait 64;	//length of toujane_vehicle_ride
	
	musicstop();
	
	thread music_loop("toujane_vehicle_loop", 60, "final_crash_run");
	
	flag_wait("moving_from_dead_tank");	//X seconds after autosave at tank kill sequence, start crash buildup music
	wait 59.2;	//48s is length of toujane_vehicle_crash
	
	flag_set("final_crash_run");
	
	musicstop(2);
	wait 2.25;
	
	musicplay("toujane_vehicle_crash");
	
	flag_wait("music_evacuation");
	
	musicplay("toujane_victory_barely");
}

music_loop(musicAlias, loopTime, endonMsg)
{
	level endon (endonMsg);
	
	while(1)
	{
		musicplay(musicAlias);
		wait loopTime;
		musicstop();
	}
}

panzerschreck_shoutout()
{
	assert(isdefined(self.script_noteworthy2));
	
	self waittill ("trigger");
	if (!isdefined(level.armoredcar))
		return;
	
	sAlias = undefined;
	switch(self.script_noteworthy2)
	{
		case "straight":
			//"panzerschreck dead ahead"
			sAlias = "toujaneride_mcg_pzahead";
			break;
		case "corner":
			//"panzerschreck by the corner of that building"
			sAlias = "toujaneride_mcg_pzcornerbldg";
			break;
		case "rooftop_straight":
			//"panzerschreck on the rooftop at 12 o'clock"
			sAlias = "toujaneride_mcg_pzrooftopfront";
			break;
		case "rooftop_left":
			//"panzerschreck on the rooftop to the left"
			sAlias = "toujaneride_mcg_pzrooftopleft";
			break;
		case "rooftop_right":
			//"panzerschreck on the rooftop to the right"
			sAlias = "toujaneride_mcg_pzrooftopright";
			break;
	}
	assert(isdefined(sAlias));
	
	if (isdefined(self.script_delay))
		wait (self.script_delay);
	thread armored_car_doDialogue(sAlias);
}

stukaBomber()
{
	paths = getvehiclenodearray(self.target,"targetname");
	assert(isdefined(paths));
	assert(isdefined(paths[0]));
	
	self waittill ("trigger");
	
	for( i = 0 ; i < paths.size ; i++ )
	{
		plane = spawnvehicle( "xmodel/vehicle_stuka_flying" , "plane" , "Stuka", paths[0].origin, paths[0].angles );
		plane attachpath(paths[0]);
		plane startpath();
		plane setspeed(160,10000);
		if ( (isdefined(paths[0].script_noteworthy)) && (paths[0].script_noteworthy == "onfire") )
			plane thread stukaBomber_burn();
		plane thread stukaBomber_sound();
		plane thread stukaBomber_bomb(paths[0]);
		plane thread stukaBomber_delete();
	}
}

stukaBomber_delete()
{
	self waittill ("reached_end_node");
	self delete();
}

stukaBomber_burn()
{
	self endon ("reached_end_node");
	for (;;)
	{
		playfxOnTag ( level._effect["stuka_smoke"], self, "tag_engine_left" );
		wait .1;
	}
}

stukaBomber_bomb(lastNode)
{	
	self endon ("reached_end_node");
	
	for (;;)
	{
		if (!isdefined(lastNode.target))
			return;
		nextNode = getvehiclenode(lastNode.target,"targetname");
		if (!isdefined(nextNode))
			return;
		
		self setWaitNode(nextNode);
		self waittill ("reached_wait_node");
		
		if ( (isdefined(nextNode.script_noteworthy)) && (nextNode.script_noteworthy == "bomb") )
		{
			if (isdefined(nextNode.target))
			{
				bombLocation = getent(nextNode.target,"targetname");
				if (isdefined(bombLocation))
					self thread stukaBomber_dropBomb(bombLocation);
			}
		}
		
		lastNode = nextNode;
	}
}

stukaBomber_dropBomb(bombDestination)
{
	bomb = spawn("script_model", self.origin);
	bomb.angles = self.angles;
	bomb setmodel(level.stukaBombModel);
	
	bombTime = 0.75;
	
	bomb moveto( bombDestination.origin, bombTime, .1, 0 );
	bomb rotatepitch( 500, bombTime, 0, 0 ) ;
	wait bombTime;
	if ( (isdefined(bombDestination.script_noteworthy)) && (bombDestination.script_noteworthy == "tunnel") )
		level notify ("tunnel_bombed");
	else
		playfx( level._effect["stukaBomb"], bombDestination.origin );
	
	thread playsoundinspace("artillery_explosion", bombDestination.origin );
	bomb delete();
}

stukaBomber_sound()
{
	self endon ("reached_end_node");
	
	flybyAlias = undefined;
	if (!isdefined(level.spitfireSound))
		level.spitfireSound = 1;
	switch(level.spitfireSound)
	{
		case 1:	flybyAlias = "plane_flyby_stuka1"; break;
		case 2:	flybyAlias = "plane_flyby_stuka2"; break;
		case 3:	flybyAlias = "plane_flyby_stuka3"; break;
	}
	assert(isdefined(flybyAlias));
	level.spitfireSound++;
	if (level.spitfireSound > 3)
		level.spitfireSound = 1;
	
	//wait until the plane is close to the player
	for(;;)
	{
		flatPlanePos = (self.origin[0], self.origin[1], 0);
		flatPlayerOrigin = (level.player.origin[0], level.player.origin[1], 0);
		if ( distance(flatPlanePos, flatPlayerOrigin) <= 3200 )
			break;
		wait 0.05;
	}
	self playsound(flybyAlias);
}