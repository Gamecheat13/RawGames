/****************************************************************************
Level: 		Launch Facility #1
Campaign: 	Marine Force Recon
****************************************************************************/
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\jake_tools;
#using_animtree("generic_human");

main()
{
	setsaveddvar( "r_specularcolorscale", "1.2" );
	if (getdvar("debug_bmp") == "")
		setdvar("debug_bmp", "0");
	if (getdvar("debug_launch") == "")
		setdvar("debug_launch", "0");
			
	initPrecache();
	createThreatBiasGroup( "player" );

	/*-----------------------
	LEVEL VARIABLES
	-------------------------*/		
	level.team01 = [];
	level.team02 = [];
	level.team03 = [];
	level.peoplespeaking = false;
	level.team01breacher = undefined;
	level.team02breacher = undefined;
	level.team03breacher = undefined;
	level.sniperkills = 0;
	level.aSniper_orgs = getentarray("sniper_position", "targetname");
	level.sniperTarget = undefined;
	level.sniperInterval = 5;
	level.snipersActive = false;
	level.playerDistanceToAI = 256;
	level.playerDistanceToAI = level.playerDistanceToAI * level.playerDistanceToAI;
	level.axisKilledByPlayer = 0;
	level.playerParticipationContainer = 10;
	level.playerParticipationGate = 15;
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 2048;
	level.bmpMGrange = 850;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	level.playerVehicleDamageRange = 256;
	level.playerVehicleDamageRangeSquared = level.playerVehicleDamageRange * level.playerVehicleDamageRange;
	level.ent = undefined;
	level.AIdeleteDistance = 512;
	level.enemyArmor = [];
	level.enemyArmorIndex = 0;
	level.maxFriendliesKilled = 2;
	level.cosine = [];
	level.cosine["180"] = cos(180);
	level.color["white"] = (1, 1, 1);
	level.color["red"] = (1, 0, 0);
	level.color["blue"] = (.1, .3, 1);
	level.c4_callback_thread = ::c4_callback_thread_launchfacility;
	level.spawnerCallbackThread = ::AI_think;
	level.excludedAi = [];
	level.aColornodeTriggers = [];
	trigs = getentarray("trigger_multiple", "classname");
	for(i=0;i<trigs.size;i++)
	{
		if ( ( isdefined(trigs[i].script_noteworthy) ) && ( getsubstr(trigs[i].script_noteworthy, 0, 10) == "colornodes" ) )
			level.aColornodeTriggers = array_add(level.aColornodeTriggers, trigs[i]);
	}
	
	/*-----------------------
	STARTS
	-------------------------*/				
	add_start("container", ::start_container);
	add_start("tarmac", ::start_tarmac);
	add_start("gate", ::start_gate);
	add_start("vents", ::start_vents);
	default_start(::start_default);
	
	/*-----------------------
	GLOBAL SCRIPTS
	-------------------------*/			
	maps\createart\launchfacility_a_art::main();
	level thread maps\launchfacility_a_fx::main();
	maps\_hind::main("vehicle_mi24p_hind_woodland");
	maps\_bmp::main("vehicle_bmp");
	maps\_blackhawk::main("vehicle_blackhawk");
	maps\launchfacility_a_anim::main();
	maps\_c4::main();
	maps\_load::main();
	maps\_claymores_sp::main();
	//maps\_compass::setupMiniMap("compass_map_launchfacility_a");
	level thread maps\launchfacility_a_amb::main();	

	/*-----------------------
	FLAGS
	-------------------------*/		
	//objectives
	flag_init("obj_gain_access_given");
	flag_init("obj_gain_access_complete");
	flag_init("obj_enemy_armor_given");
	flag_init("obj_enemy_armor_complete");
	flag_init("obj_north_tarmac_given");
	flag_init("obj_north_tarmac_complete");
	flag_init("obj_rappel_given");
	flag_init("obj_rappel_complete");
	
	//approach & container
	flag_init("intro_complete");
	flag_init("hind_intro_dialogue");
	flag_init("friendlies_past_killzone");
	flag_init("stop_alarm");
	flag_init("friendly_shoots_down_heli");
	flag_init("hind_crash");
	flag_init("heli_attractor_deleted");
	flag_init("flanking_wall_breached");
	flag_init("blow_the_gate");
	flag_init("bmp_02_destroyed");
	flag_init("gate_sequence_starting");
	
	//tarmac
	flag_init("bmp_03_destroyed");
	flag_init("bmp_04_destroyed");
	flag_init("one_bmp_left");
	
	//vents
	flag_init("hinds_appear");
	flag_init("breach_the_vents");
	flag_init("vent01_open");
	flag_init("vent02_open");
	flag_init("vent03_open");
	flag_init("rappel_started");
	flag_init("team01_hooked_up");
	flag_init("team02_hooked_up");
	flag_init("team03_hooked_up");
	
	//misc
	flag_init("player_reached_kill_max");
	flag_init("level_fade_out");
	

	/*-----------------------
	GLOBAL THREADS
	-------------------------*/	
	initPlayer();
	vehicle_patrol_init();
	disable_color_trigs();
	hideAll();
	launch_lid_setup();
	array_thread( getentarray( "hostiles_container_runners", "script_noteworthy" ), ::add_spawn_function, ::AI_chain_and_seek );
	array_thread( getentarray( "hostiles_player_seek", "script_noteworthy" ), ::add_spawn_function, ::AI_player_seek );
	array_thread( getentarray( "hostiles_vehicle_support", "script_noteworthy" ), ::add_spawn_function, ::AI_vehicle_support );
	//array_thread( getentarray( "vehicle_path_disconnector", "targetname" ), ::vehicle_path_disconnector );
	
	aVehicles_BMP_targetnames = [];
	aVehicles_BMP_targetnames[0] = "bmp_02"; 
	aVehicles_BMP_targetnames[1] = "bmp_03"; 
	aVehicles_BMP_targetnames[2] = "bmp_04"; 
	thread vehicle_bmp_setup( aVehicles_BMP_targetnames );
	
	aC4_plants = getentarray( "c4_plant", "targetname" );
	if ( aC4_plants.size > 0 )
		array_thread( aC4_plants, ::c4_plant_think);
	
	/*-----------------------
	DEBUG
	-------------------------*/	
	//thread debug();

}

debug()
{
	wait(1);
	flag_set("hind_crash");
}


/****************************************************************************
    START FUNCTIONS
****************************************************************************/
start_default()
{
	AA_approach_init();
	//start_container();
	//start_gate();
	//start_tarmac();
	//start_vents();
}

start_container()
{
	initFriendlies("container");
}

start_gate()
{
	initFriendlies("gate");
	AA_gate_init();
	wait(0.5);
	flag_set("bmp_02_destroyed");
}

start_tarmac()
{
	initFriendlies("tarmac");
}

start_vents()
{
	initFriendlies("vents");
	AA_vents_init();
}

/****************************************************************************
    LEVEL START: APPROACH
****************************************************************************/
AA_approach_init()
{
	thread music_intro();
	thread music_end();
	thread AA_gate_init();
	initFriendlies("default");
	thread dialogue_intro();
	thread dialogue_c4_hints();
	battlechatter_off( "allies" );
	triggersEnable("colornodes_approach", "script_noteworthy", true);
	triggersEnable("colornodes_container", "script_noteworthy", true);
	thread friendlies_blow_bmp02();
	thread alarm_sound_thread();
	thread obj_gain_access();
	thread heli_flyby_intro();
	thread reach_container_area();
	thread container_rpg_moment();
	thread exit_container_area();
	thread hind_intro_think();
	thread heli_guy_death();
	thread container_heli_sequence();
	thread flanking_wall_breached();
	
}

container_rpg_moment()
{
	flag_wait ("reach_container_area");
	flag_wait("heli_attractor_deleted");
	//volume_containers = getent("volume_containers", "targetname");
	//while (!level.player istouching(volume_containers))
	wait (2);
	aRpgSources = getentarray("rpg_source", "targetname");
	assert(isdefined(aRpgSources));
	aRpgTargets = getentarray("rpg_target", "targetname");
	assert(isdefined(aRpgTargets));
	thread rpg_ambient(aRpgSources, aRpgTargets, 2);
}

music_intro()
{
	flag_wait ("reach_container_area");
	
	wait randomfloatrange( 10 , 15 );
	
	//play bravado-filled echoing Russian loudspeaker voice "Remember the fallen and fight for their honor!" or 
	//something like that, then the record player music is heard over the base loudspeaker system
	
	//sprinkle more bravado-filled ultranationalist rhetoric over the loudspeaker once every 25-35
	//seconds while the recording plays
	
	while( !flag( "obj_enemy_armor_complete" ) )
	{
		musicPlay( "launchfacility_a_start_vinyl_music" );  
		wait randomfloatrange( 128 , 134 );
	}
}

music_end()
{
	flag_wait ("obj_enemy_armor_complete");
	musicstop();
	
	//cut off with a speaker feedback whine and play angry echoing Russian loudspeaker voice shouting stuff 
	//about the place being overrun by enemies
}

dialogue_intro()
{
	flag_set("intro_complete");
	flag_set("obj_gain_access_given");
	//Loudspeaker
	//"Facility perimeter has been compromised. All units proceed to defensive positions. Unknown enemy force moving in from the South or West. Facility is now on high alert."	
	thread dialogue_loudspeaker("launchfacility_a_loudspeaker_01");

	level.peoplespeaking = true;
	
	//HQ Radio
	//"Bravo Six, we're picking up heavy activity inside the facility. Enemy air is running search patterns. What's your status over?"	
	radio_dialogue("launchfacility_a_hqradio_activity");

	//Price
	//"Status is TARFU and we're workin' on it, out!"
	level.price dialogue_execute("launchfacility_a_price_tarfu");

	//Price
	//"All right our cover’s blown! Grenier! Prep the AT4!"
	level.price dialogue_execute("launchfacility_a_price_at4_prep");	
	
	//Marine 01
	//"Roger that. Last round sir."
	//radio_dialogue("launchfacility_a_marine_01_at4_prep");
	
	level.peoplespeaking = false;
	
	flag_wait("hind_intro_dialogue");
	guy = get_closest_ally();
	assert(isdefined(guy));
	
	level.peoplespeaking = true;
	
	//Marine 01
	//"Hind!!! 12 o'clock high!!!"	
	guy dialogue_execute("launchfacility_a_marine1_chopper");

	
	battlechatter_on( "allies" );
	
	wait (2);
	//Price
	//"Go go go!!!"
	level.price dialogue_execute("launchfacility_a_price_gogogo1");
	
	//Sniper team
	//"Bravo Six, Sniper Team Two is now in position.  We'll give ya sniper cover and recon from where we are, over."
	radio_dialogue("launchfacility_a_recon_sniperteamtwo");
	
	//Price
	//"Copy!!! Keep us posted!!! Out!!!!"
	level.price dialogue_execute("launchfacility_a_price_keepposted");	

	level.peoplespeaking = false;
	
	wait(5);
	
	thread dialogue_smoke_hints();
	
}

dialogue_smoke_hints()
{
	level endon ("bmp_02_destroyed");
	level endon ("bmp_bypassed");
	level endon ("player_reached_kill_max");

	if (flag("bmp_02_destroyed"))
		return;

	iNags = 0;
	volume_smoke = getent("volume_smoke", "targetname");
	volume_smoke.smokethrown = false;
	volume_smoke thread smoke_detect();
	thread	dialogue_smoke_hints_cleanup(volume_smoke);
	
	/*-----------------------
	FRIENDLIES GIVE SMOKE HINTS
	-------------------------*/		
	while (volume_smoke.smokethrown == false)
	{
		iNags++;
		if (iNags == 1)
		{
			level.peoplespeaking = true;
			//Sniper team
			//"This is Sniper Team Two. You've got hostiles and light armor coming to you from the north. Suggest you get some C4 out there or find some heavy weapons, over."
			radio_dialogue("launchfacility_a_recon_enemiestonorth");	
			level.peoplespeaking = false;		
		}
	
		else if (iNags == 2)
		{
			level.peoplespeaking = true;
			//Price
			//"Throw some smoooke!!!!"
			level.price dialogue_execute("launchfacility_a_price_smoke_nag_01");
			level.peoplespeaking = false;		
		}

		else if (iNags == 3)
		{
			level.peoplespeaking = true;
			//Grigsby
			//"We gotta cover our advaaaance! Everyone pop smooooke!"
			level.grigsby dialogue_execute("launchfacility_a_grigsby_smoke_nag_01");
			level.peoplespeaking = false;
		}
		
		else
			break;

		thread hint(&"LAUNCHFACILITY_A_HINTSTR_SMOKE", 5);
		wait(randomfloatrange(6,11));
	}
	/*-----------------------
	A FRIENDLY POPS SMOKE NEAR TANK IF PLAYER STILL HAS NOT THROWN
	-------------------------*/		
	if (volume_smoke.smokethrown == false)
	{
		/*-----------------------
		FURTHEST FRIENDLY THROWS SMOKE
		-------------------------*/	
		aExcluders = [];
		aExcluders[0] = level.price;
		aExcluders[1] = level.grigsby;
		ai = get_array_of_closest(level.player.origin, level.squad, aExcluders);
		dude = ai[ai.size - 1];
		if ( (isdefined(dude)) && (isalive(dude)) )
		{
			dude thread dialogue_execute("launchfacility_a_marine_01_throwing_smoke");
			bmp = getent("bmp_02", "targetname");
			oldGrenadeWeapon = dude.grenadeWeapon;
			dude.grenadeWeapon = "smoke_grenade_american";
			dude.grenadeAmmo++;
			dude magicgrenade(bmp.origin, bmp.origin  + (0,200,64), .1);
			volume_smoke notify ("smoke_has_been_thrown");
			dude.grenadeWeapon = oldGrenadeWeapon;
		}
	}
}

dialogue_C4_hints()
{
	level endon ("bmp_02_destroyed");
	level endon ("bmp_bypassed");
	level endon ("player_reached_kill_max");
	
	if (flag("bmp_02_destroyed"))
		return;
	if (flag("bmp_bypassed"))
		return;
	if (flag("player_reached_kill_max"))
		return;	

	volume_smoke = getent("volume_smoke", "targetname");
	volume_smoke waittill ("smoke_has_been_thrown");
	
	wait (2);

	iNags = 0;
	while (iNags < 2)
	{
		iNags++;
		if (iNags == 1)
		{
			level.peoplespeaking = true;
			//Price
			//"Jackson! Get a C4 charge on that BMP!!!"
			level.price dialogue_execute("launchfacility_a_price_bmp_nag_01");
			level.peoplespeaking = false;

		}
		else if (iNags == 2)
		{
			level.peoplespeaking = true;
			//Price
			//"We gotta take out that BMP! Use your C4!"
			level.price dialogue_execute("launchfacility_a_price_bmp_nag_02");		
			level.peoplespeaking = false;	
		}
		else
			break;
			
		wait(randomfloatrange(8,12));
	}
}

dialogue_smoke_hints_cleanup(eVolume)
{
	eVolume waittill ("smoke_has_been_thrown");
	thread hint_fade();
}

flanking_wall_breached()
{
	flag_wait("flanking_wall_breached");
	
	if(flag("exit_container_area"))
		return;
	/*-----------------------
	STOP SPAWNING GUYS AND SET FLAG THAT OUT OF CONTAINER
	-------------------------*/	
	flag_set("exit_container_area");
	trig_killspawner = getent("killspawner_exit_container", "targetname");	
	trig_killspawner notify ("trigger", level.player);
}

alarm_sound_thread()
{
	origin_sound_alarm = getent("origin_sound_alarm", "targetname");


	while (true)
	{
		origin_sound_alarm playsound (level.scr_sound["launch_alarm_siren"], "sounddone");
		origin_sound_alarm waittill ("sounddone");
	
		if (flag("stop_alarm"))
			break;
	}
	//origin_sound_alarm notify ( "stop sound" + level.scr_sound["launch_alarm_buzzer"] );
	origin_sound_alarm thread play_sound_on_entity(level.scr_sound["launch_alarm_siren_fade"]);
}

friendlies_blow_bmp02()
{
	level endon ("bmp_02_destroyed");
	//level thread player_kill_counter(level.playerParticipationContainer);
	
	/*-----------------------
	WAIT FOR PLAYER TO KILL ENOUGH DUDES OR BYPASS BMP
	-------------------------*/
	//flag_wait_either ("bmp_bypassed", "player_reached_kill_max");
	flag_wait("bmp_bypassed");
	
	/*-----------------------
	PLAYER STILL HASN'T KILLED BMP
	-------------------------*/
	thread squad_bmp_destroy("bmp_02");
}

heli_flyby_intro()
{
	thread heli_flyby_distance();
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath(5);
	waittillframeend;
	aHeli = getent("hind_intro_flyby_01", "targetname");
	
	wait(4.5);
	aHeli thread fireMG(randomintrange(14, 17), 80);
	//aHeli thread heli_strafe();
	wait (4);
	aHeli notify ("stop_firingMG");
	wait (11);
	aHeli delete();	
}

heli_strafe()
{
	self endon ("stop_firingMG");
	self.turretFiring = false;
	
	while (true)
	{
		if (self.turretFiring == false)
		{
			wait (randomfloatrange(1, 3));
			self fireMG();
		}

		wait (0.05);
	}
}

fireMG(iBurstNumber, fZoffset)
{
	self endon ("death");
	
	if (!isdefined(fZoffset))
		fZoffset = 0;

	self setturrettargetent(level.player, (0, 0, fZoffset));
	iFireTime = 0.1;
	//iFireTime = weaponfiretime("hind_turret");
	assert(isdefined(iFireTime));
	
	if (!isdefined(iBurstNumber))
		iBurstNumber = randomintrange(8, 20);

	self.turretFiring = true;
	i = 0;
	while (i < iBurstNumber)
	{
		i++;
		wait(iFireTime);
		self fireWeapon();
	}
	self.turretFiring = false;
}

heli_flyby_distance()
{
	eHeli = maps\_vehicle::waittill_vehiclespawn("hind_intro_flyby_02");
	wait (20);
	
	eHeli delete();
	hind_intro_flyby_03 = getent("hind_intro_flyby_03", "targetname");
	hind_intro_flyby_03 delete();
}

reach_container_area()
{
	flag_wait ("reach_container_area");
	thread autosave_by_name( "container" );
	
	wait (2);
	//Loudspeaker
	//"We are under attack! Lock down all points of entry immediately."
	thread dialogue_loudspeaker("launchfacility_a_loudspeaker_02");
}

container_heli_sequence()
{
	while (!isdefined(level.friendly_at4))
		wait (0.05);
	node = getnode( "node_at4_guy", "targetname");

	createthreatbiasgroup( "ignored" );
	level.friendly_at4 set_threatbiasgroup( "ignored" );
	setignoremegroup( "ignored", "axis" );
	setignoremegroup( "axis", "ignored" );
	
	assert(isdefined(node));
	level.friendly_at4 set_animname( "frnd" );
	level.friendly_at4.ignoreme = true;
	
	//anim_reach_solo( guy, anime, tag, node, tag_entity )
	//anim_loop_solo( guy, anime, tag, ender, entity )
	
	node anim_reach_solo (level.friendly_at4, "RPG_conceal_idle_start");
	node thread anim_loop_solo (level.friendly_at4, "RPG_conceal_idle", undefined, "stop_idle");
	
	flag_wait( "friendly_shoots_down_heli" );
	
	node notify ( "stop_idle" );
	node anim_single_solo( level.friendly_at4, "RPG_conceal_2_standR" );
	
		
	//animscripted( <notify>, <origin>, <angles>, <animation>, <mode>, <root>)
	//level.friendly_at4 setflaggedanim ( "stop_anim", %RPG_stand_aim_5, 1.0, 0, 1 );
//	while (true)
//	{
//		level.friendly_at4 animscripted ( "stop_anim_scripted", level.friendly_at4.origin, level.friendly_at4.angles, %RPG_stand_aim_5 );
//		level.friendly_at4 waittillmatch ("stop_anim_scripted", "end");	
//		
//	}

	
	
	//level.friendly_at4 setanim ( %RPG_stand_aim_5, 1.0, 0, 1 );
	
	
	//level.friendly_at4 waittillmatch ("stop_anim");
	
	//node notify ( "stop_idle" );

	//level.friendly_at4 thread anim_loop_solo( level.friendly_at4, "RPG_stand_idle", undefined, "stop_loop" );
	//wait(.5);
	//node notify ("stop_loop");
	//level.friendly_at4 anim_single_solo( level.friendly_at4, "RPG_stand_fire" );
	
	org = level.friendly_at4 gettagorigin( "TAG_WEAPON_RIGHT" );
	magicbullet( "rpg_player", org, level.eHindIntro.origin );	

	level.eHindIntro notify ("hit_by_rpg");
	level.friendly_at4 anim_single_solo( level.friendly_at4, "RPG_standR_2_conceal" );
	
	node thread anim_loop_solo (level.friendly_at4, "RPG_conceal_idle", undefined, "stop_idle");
	
	flag_wait("exit_container_area");
	
	if (isdefined(level.friendly_at4))
	{
		level.friendly_at4 notify( "stop magic bullet shield" );
		level.friendly_at4 delete();
	}

}

hind_crash_failsafe()
{
	wait(2.7);
	//level.eHindIntro.health -= 3000;
	//level.eHindIntro notify ("damage", 3000, level.player);
	//level.eHindIntro dodamage(level.eHindIntro.health + 10000, level.eHindIntro.origin);
	level.eHindIntro notify ("death");
}


hind_intro_think()
{
	hind_crash = getent("hind_crash", "script_noteworthy");
	level.eHindIntro = maps\_vehicle::waittill_vehiclespawn( "hind_intro" );
	level.eHindIntro setmaxpitchroll(50,30);
	level.eHindIntro setspeed(120, 15, 15);
	crash_path = getent("crash_path", "script_noteworthy");
	
	wait(2);
	flag_set("hind_intro_dialogue");
	wait(1.5);
	
	level.eHindIntro thread fireMG(15, 80);
	wait(1);
	
	/*-----------------------
	HIND STARTS CRASH SEQUENCE
	-------------------------*/
	flag_set( "friendly_shoots_down_heli" );
	attractor = missile_createAttractorEnt( level.eHindIntro, 10000, 6000 );
	
	level.eHindIntro thread hind_crash_failsafe();
	
	wait(2.5);
	missile_deleteAttractor(attractor);
	flag_set("heli_attractor_deleted");

	/*-----------------------
	BEGIN OLD CRASH SEQUENCE
	-------------------------*/	
	/*
	level.eHindIntro waittill ("hit_by_rpg");
	wait(.2);
	level.eHindIntro vehicle_detachfrompath(); 
	level.eHindIntro thread vehicle_dynamicpath( crash_path, false ); 
	level.eHindIntro thread hind_crash_fx();

	wait(1);
	level.eHindIntro thread play_loop_sound_on_entity(level.scr_sound["launch_heli_dying_loop"]);
	missile_deleteAttractor(attractor);
	flag_set("heli_attractor_deleted");
	
	wait(3);

	level.eHindIntro thread play_loop_sound_on_entity(level.scr_sound["launch_heli_alarm_loop"]);
	
	wait( 4.5 );
	
	thread play_sound_in_space( "explo_metal_rand", hind_crash.origin );
	level.eHindIntro notify ( "stop sound" + level.scr_sound["launch_heli_alarm_loop"] );
	level.eHindIntro notify ( "stop sound" + level.scr_sound["launch_heli_dying_loop"] );
	
	wait(.2);
	playfx ( level._effect["hind_explosion"], hind_crash.origin );
	earthquake (0.6, 2, hind_crash.origin, 2000);
	if ( isdefined(level.eHindIntro) )
		level.eHindIntro delete();
	wait (.75);
	playfx ( level._effect["hind_explosion"], hind_crash.origin + (200, 0, 800) );
	thread play_sound_in_space( "building_explosion1", hind_crash.origin );
	
	*/

	/*-----------------------
	END OLD CRASH SEQUENCE
	-------------------------*/	
	level.eHindIntro waittill("crash_done");
	flag_set("hind_crash");
	flag_set("stop_alarm");
	
}

heli_guy_death()
{
	flag_wait( "friendly_shoots_down_heli" );
	wait(12);
	spawner = getent("heli_dude", "targetname");
	assert(isdefined(spawner));
	eGuy = spawner stalingradspawn();
	spawn_failed(eGuy);
	org = eGuy.origin + (100, -50, -100);
	eGuy.skipdeathanim = true;
	eGuy doDamage (eGuy.health + 1, eGuy.origin);
	wait(0.1);
	physicsExplosionSphere( org, 356, 128, 16 );

}

hind_crash_fx()
{
	self endon ("death");
	
	wait(1.2);
	playfxontag( level._effect["heli_aerial_explosion"], self, "tag_body" );	
	thread play_sound_in_space( "explo_metal_rand", self.origin );	
	
	while (true)
	{
		//playfxontag( level._effect["fire_trail_heli"], level.eHindIntro, "tag_origin" );
		playfxontag( level._effect["smoke_trail_heli"], self, "tag_engine_right" );		
		wait(0.01);
	}	
}


/****************************************************************************
    LEVEL START: CONTAINER
****************************************************************************/

exit_container_area()
{
	/*-----------------------
	AI LEFT BEHIND CHASE PLAYER
	-------------------------*/		
	flag_wait( "exit_container_area" );
	thread ignore_friendlies_till_past_killzone();
	thread autosave_by_name( "exit_container" );
	volume = getent("volume_containers", "targetname");
	volume thread AI_in_volume_chase_player();
}

ignore_friendlies_till_past_killzone()
{
	trig_ignoreme = getent("trig_ignoreme", "targetname");
	assert(isdefined(trig_ignoreme));
	for(i=0;i<level.squad.size;i++)
		level.squad[i] thread ignoreme_when_in_trigger(trig_ignoreme);
}

ignoreme_when_in_trigger(trig_ignoreme)
{
	level endon ("friendlies_past_killzone");
	while (true)
	{
		wait (0.05);
		trig_ignoreme waittill ("trigger", other);
		if (other != self)
			continue;

		self.ignoreme = true;
		self.a.disablePain = true;
		self set_maxsightdistsqrd(128);
		//self thread print3Dthread("IGNORED");
		while (self istouching(trig_ignoreme))
			wait (0.05);
			
			
		self.ignoreme = false;
		self.a.disablePain = false;
		self reset_maxsightdistsqrd();
		//self notify ("stop_3dprint");

	}
}

/****************************************************************************
    LEVEL START: GATE
****************************************************************************/
AA_gate_init()
{

	thread gate_squad_advance_no_bmp();
	thread gate_left_approach();
	thread gate_right_approach();
	thread gate_right_reach();
	thread gate_player_participation();
	thread gate_sequence();
}


gate_squad_advance_no_bmp()
{
	flag_wait ("bmp_02_destroyed");
	disable_color_trigs();
	triggersEnable("colornodes_gate_no_bmp", "script_noteworthy", true);

	trig_killspawner = getent("killspawner_exit_container", "targetname");	
	trig_killspawner notify ("trigger", level.player);
	
	/*-----------------------
	TRY TO KILL ANY REMAINING ENEMIES IN CONTAINER AREA
	-------------------------*/	
	eVolume = getent("volume_containers", "targetname");
	aAI_to_delete = getAIarrayTouchingVolume("axis", undefined,eVolume);
	if (aAI_to_delete.size > 0)
	{
		for(i=0;i<aAI_to_delete.size;i++)
			aAI_to_delete[i].health = 1;
		thread AI_delete_when_out_of_sight(aAI_to_delete, level.AIdeleteDistance);
	}
	
	wait (2);
	level.peoplespeaking = true;
	
	//HQ radio
	//"Bravo Six, this is command, gimme a sit-rep over."
	radio_dialogue("launchfacility_a_cmd_sitrep");
	
	//Price
	//"We're inside the perimeter, approaching the gates to the silos!!! Out!!!"
	level.price dialogue_execute("launchfacility_a_price_were_inside");	
	
	level.peoplespeaking = false;
	
	wait(1.5);
	//Loudspeaker
	//"Enemy units confirmed to be American special forces. Exercise extreme caution. Red Spetznaz units are en route to intercept."	
	thread dialogue_loudspeaker("launchfacility_a_loudspeaker_03");
	
}

gate_left_approach()
{
	flag_wait("reached_left_gate");
	if (getdvar("debug_bmp") == "1")
		println("REACHED LEFT GATE");
	thread autosave_by_name("left_gate");
	
	
	iprintlnbold("^2MARINE:^7 Gate is blocked! We gotta go right!");
}

gate_right_approach()
{
	flag_wait("right_gate_approach");
	
	level.peoplespeaking = true;
	//Grigsby
	//"We're gonna need some more ground support sir!!!!"
	level.grigsby dialogue_execute("launchfacility_a_griggs_moreground");
	
	//Price
	//"Already got it covered Griggs!!!"
	level.price dialogue_execute("launchfacility_a_price_alreadygot");	
	
	level.peoplespeaking = false;
}

gate_player_participation()
{
	level endon ("gate_sequence_starting");
	
	flag_wait ("bmp_02_destroyed");
	//flag_wait("right_gate_approach");
	
	level thread player_kill_counter(level.playerParticipationGate);

	/*-----------------------
	WAIT FOR PLAYER TO KILL ENOUGH DUDES
	-------------------------*/
	flag_clear("player_reached_kill_max");
	wait(.5);
	flag_wait("player_reached_kill_max");
	if (getdvar("debug_bmp") == "1")
		printLn("player has killed " + level.axisKilledByPlayer + " dudes...additional gate trigger activated");
	
	/*-----------------------
	ACTIVATE ADDITIONAL GATE TRIGGERS
	-------------------------*/
	aTrigs1 = getentarray("reached_right_gate_additional", "targetname");
	aTrigs2 = getentarray("reached_right_gate", "targetname");
	
	for(i=0;i<aTrigs1.size;i++)
		aTrigs1[i] trigger_on();

	/*-----------------------
	WAIT FOR PLAYER TO APPROACH GATE VIA LARGER TRIGGER
	-------------------------*/		
	array_thread (aTrigs1, ::gate_right_reach_trig_wait);
	level waittill ("level_ent_updated");

	/*-----------------------
	CANCEL ALL OTHER TRIGGERS
	-------------------------*/		
	for(i=0;i<aTrigs1.size;i++)
		aTrigs1[i] notify ("cancel");

	for(i=0;i<aTrigs2.size;i++)
		aTrigs2[i] notify ("cancel");

	flag_set("gate_sequence_starting");
}

gate_right_reach()
{
	
	/*-----------------------
	WAIT FOR PLAYER TO APPROACH GATE
	-------------------------*/		
	aTrigs = getentarray("reached_right_gate", "targetname");
	array_thread (aTrigs, ::gate_right_reach_trig_wait);
	level waittill ("level_ent_updated");
	for(i=0;i<aTrigs.size;i++)
		aTrigs[i] notify ("cancel");
	
	flag_set("gate_sequence_starting");
}


gate_sequence()
{
	flag_wait("gate_sequence_starting");
	
	thread autosave_by_name("right_gate");
	/*-----------------------
	SPAWN GATE DUDE AND HAVE PLANT C4
	-------------------------*/	
	assertEx((isdefined(level.ent)), "level.ent should have been updated when trigger was hit");
	eGateDude = level.ent stalingradspawn();
	spawn_failed(eGateDude);
	eGateDude thread friendly_blows_gate();

	/*-----------------------
	KILL ALL SPAWNERS IN GATE AREA
	-------------------------*/	
	thread autosave_by_name("gate_being_blown");
	
	aKillspawners_gate = getentarray("killspawners_gate", "script_noteworthy");
	for(i=0;i<aKillspawners_gate.size;i++)
		aKillspawners_gate[i] notify ("trigger", level.player);
	
	flag_wait("blow_the_gate");
	/*-----------------------
	BLOW THE GATE
	-------------------------*/
	exploder(500);
	org = getent("obj_gain_access", "targetname");
	thread play_sound_in_space( "explo_metal_rand", org.origin );
	earthquake (0.6, 1, org.origin, 2000);
	
	/*-----------------------
	MOVE INTO NEXT AREA
	-------------------------*/	
	disable_color_trigs();
	triggersEnable("colornodes_tarmac_front", "script_noteworthy", true);
	triggersEnable("colornodes_tarmac_rear", "script_noteworthy", true);
	
	flag_set ("obj_gain_access_complete");
	thread autosave_by_name( "gate_blown" );
	
	thread AA_tarmac_init();
	
	/*------------------------
	TRY TO KILL ANY REMAINING ENEMIES IN PERIMETER
	-------------------------*/
	aVolumes = getentarray("volumes_perimeter", "script_noteworthy");
	aAI_to_delete = [];
	aStragglers = undefined;
	for(i=0;i<aVolumes.size;i++)
	{
		aStragglers = undefined;
		aStragglers = getAIarrayTouchingVolume("axis", undefined,aVolumes[i]);
		if (aStragglers.size > 0)
			aAI_to_delete = array_merge(aAI_to_delete, aStragglers);
	}
	
	if (aAI_to_delete.size > 0)
	{
		for(i=0;i<aAI_to_delete.size;i++)
			aAI_to_delete[i].health = 1;
		thread AI_delete_when_out_of_sight(aAI_to_delete, level.AIdeleteDistance);
	}	
}

friendly_blows_gate()
{
	self endon ("death");
	
	self disable_ai_color();
	self.animname = "frnd";
	self invulnerable(true);
	self.ignoreme = true;
	self setFlashbangImmunity( true );
	//self teleport (org.origin);
	//self setgoalpos (org.origin);
	
	level.peoplespeaking = true;
	
	//Marine 01
	//"Cover me! I'm gonna blow the gate!"
	self thread dialogue_execute("launchfacility_a_marine1_gate_blow");
	
	eNode = getent("node_gate_destroy", "targetname");
	eNodeRetreat = getnode(eNode.target, "targetname");
	eNode anim_reach_solo (self, "C4_plant_start");
	eNode anim_single_solo(self, "C4_plant");

	//Marine 02
	//"Charges set!!!!! Get back get back!!!"
	self thread dialogue_execute("launchfacility_a_marine2_gate_getback");	
	
	self setGoalRadius(eNodeRetreat.radius);	
	self setgoalnode(eNodeRetreat);
	self waittill ("goal");
	wait (.5);
	self resetGoalRadius();
	
	//Marine 02
	//"Fire in the hole!!!"
	self dialogue_execute("launchfacility_a_marine2_fireinhole");

	level.peoplespeaking = false;
	
	/*-----------------------
	GATE BLOWN
	-------------------------*/		
	flag_set("blow_the_gate");
	wait (1);

	self enable_ai_color();
	
	/*-----------------------
	FRIENDLIES MOVE INTO NEXT AREA, BMPS SPAWNED
	-------------------------*/	
	trig_colornode = getent("colornodes_tarmac_front_start", "targetname");
	trig_colornode notify("trigger", level.player);
	triggers_bmp_tarmac = getentarray("triggers_bmp_tarmac", "script_noteworthy");
	for(i=0;i<triggers_bmp_tarmac.size;i++)
		triggers_bmp_tarmac[i] notify("trigger", level.player);

	/*-----------------------
	MAKE GATE DUDE VULNERABLE SO HE GETS KILLED
	-------------------------*/		
	wait (6);
	self invulnerable(false);
	self.ignoreme = false;

}

gate_right_reach_trig_wait()
{
	self endon ("cancel");
	spawner = getent(self.script_linkto, "script_linkname");
	assertEx((isdefined(spawner)), "trigger must linkto a spawner");
	self waittill ("trigger");
	level.ent = spawner;
	level notify ("level_ent_updated");
}

/****************************************************************************
    LEVEL START: TARMAC
****************************************************************************/
AA_tarmac_init()
{
	flag_set("friendlies_past_killzone");
	thread tarmac_colornodes_think();
	array_thread(level.squad, ::tarmac_friendly_engagement_think);
	thread reach_tarmac_halfwaypoint();
	thread tarmac_objectives();
	thread obj_enemy_armor();
	thread dialogue_tarmac_hints();
	thread proceed_to_vents();
}

tarmac_objectives()
{
	maps\_vehicle::waittill_vehiclespawn("bmp_04");

	level.peoplespeaking = true;
	
	//Price
	//"Through the gate! Let's go!!!"
	level.price thread dialogue_execute("launchfacility_a_price_tothetarmac");	
	
	level.peoplespeaking = false;
	
	wait (5);
	
	/*-----------------------
	ARMOR DIALOGUE & OBJECTIVE
	-------------------------*/
	level.peoplespeaking = true;
	
	//Grigsby
	//"Shit we got more BMPs!!!  Take cover!!!!"
	level.grigsby dialogue_execute("launchfacility_a_griggs_morebmps");
	
	//Price
	//"Jackson!!! Griggs!!! Knock 'em out, GO!!!!"
	level.price dialogue_execute("launchfacility_a_price_knockemout");	
	
	level.peoplespeaking = false;
	
	
	flag_set("obj_enemy_armor_given");

	/*-----------------------
	WAIT FOR EITHER BMP TO BE KILLED
	-------------------------*/			
	flag_wait_either("bmp_03_destroyed", "bmp_04_destroyed");
	flag_set("one_bmp_left");
}

dialogue_tarmac_hints()
{
	flag_wait("obj_enemy_armor_given");
	
	wait (10);

	if (flag("one_bmp_left"))
		return;
	
	level.peoplespeaking = true;
	//Grigsby
	//"Yo Jackson!! Keep your eyes open for RPGs!! We can use 'em to take out the armor from long range!!!"
	level.grigsby dialogue_execute("launchfacility_a_griggs_userpghint");	
	level.peoplespeaking = false;
	
	wait (10);

	if (flag("one_bmp_left"))
		return;
	
	level.peoplespeaking = true;
	//Grigsby
	//"We need to take out the BMPs! "
	level.grigsby dialogue_execute("launchfacility_a_griggs_vehicles_hint_01");
	level.peoplespeaking = false;
}

tarmac_friendly_engagement_think()
{
	self endon ("death");
	//self set_maxsightdistsqrd(512);
}

reach_tarmac_halfwaypoint()
{
	flag_wait("reach_tarmac_halfwaypoint");
	
	//Loudspeaker
	//"Preparing launch tubes 2 through 6 for firing. Standby."
	thread dialogue_loudspeaker("launchfacility_a_loudspeaker_04");
	
	flag_set("player_near_launchtube_03");
	wait(2);
	flag_set("player_near_launchtube_04");
	wait (1);
	flag_set("player_near_launchtube_06");
	wait(2);
	flag_set("player_near_launchtube_05");	
}

ignoreme_thread(bool)
{
	self endon ("death");
	if (!isalive(self))
		return;
	if (!isdefined(self))
		return;
	
	self.ignoreme = bool;
}

tarmac_colornodes_think()
{
	thread bmp_03_colornodes();
	thread bmp_04_colornodes();
}

bmp_03_colornodes()
{
	level endon ("obj_enemy_armor_complete");
	flag_wait("bmp_03_destroyed");
	
	triggersEnable("colornodes_tarmac_front", "script_noteworthy", false);
	triggersEnable("colornodes_tarmac_bmp_04_dead", "script_noteworthy", false);
	triggersEnable("colornodes_tarmac_bmp_03_dead", "script_noteworthy", true);
	
	/*-----------------------
	ACTIVATE THE COLORNODES NEAREST 
	TO BMP PATH, BUT FURTHEST FROM ACTUAL BMP
	-------------------------*/	
	colornode_triggers = [];
	colornodes_tarmac_rear = getentarray("colornodes_tarmac_rear", "script_noteworthy");
	colornodes_tarmac_bmp_03_dead = getentarray("colornodes_tarmac_bmp_03_dead", "script_noteworthy");
	colornode_triggers = array_merge(colornodes_tarmac_rear, colornodes_tarmac_bmp_03_dead);
	
	bmp = getent("bmp_04", "targetname");
	assertEx((isdefined(bmp)), "BMP_04 not defined");
	aTriggers = get_array_of_closest(bmp.origin, colornode_triggers);
	eTrigger = aTriggers[aTriggers.size - 1];
	eTrigger notify ("trigger", level.player);
}

bmp_04_colornodes()
{
	level endon ("obj_enemy_armor_complete");
	flag_wait("bmp_04_destroyed");

	triggersEnable("colornodes_tarmac_rear", "script_noteworthy", false);
	triggersEnable("colornodes_tarmac_bmp_03_dead", "script_noteworthy", false);
	triggersEnable("colornodes_tarmac_bmp_04_dead", "script_noteworthy", true);
	
	/*-----------------------
	ACTIVATE THE COLORNODES NEAREST 
	TO BMP PATH, BUT FURTHEST FROM ACTUAL BMP
	-------------------------*/	
	colornode_triggers = [];
	colornodes_tarmac_front = getentarray("colornodes_tarmac_front", "script_noteworthy");
	colornodes_tarmac_bmp_04_dead = getentarray("colornodes_tarmac_bmp_04_dead", "script_noteworthy");
	colornode_triggers = array_merge(colornodes_tarmac_front, colornodes_tarmac_bmp_04_dead);
	
	bmp = getent("bmp_03", "targetname");
	assertEx((isdefined(bmp)), "BMP_03 not defined");
	aTriggers = get_array_of_closest(bmp.origin, colornode_triggers);
	eTrigger = aTriggers[aTriggers.size - 1];
	eTrigger notify ("trigger", level.player);
}

proceed_to_vents()
{
	flag_wait ("obj_enemy_armor_complete");
	thread AA_vents_init();
	aAI_to_delete = getaiarray("axis");
	thread AI_delete_when_out_of_sight(aAI_to_delete, level.AIdeleteDistance);
}

/****************************************************************************
    LEVEL START: VENTS
****************************************************************************/

AA_vents_init()
{
	thread blackhawk_arrive();
	thread vents_friendly_movement();
	thread obj_north_tarmac();
	thread obj_rappel();
	thread player_rappel();
	thread friendlies_vent_rappel_setup();
	thread hind_attack();
	thread level_end();
}

blackhawk_arrive()
{
	thread blackhawk_think();
	wait(1);
	trigger_blackhawk = getent("trigger_blackhawk", "script_noteworthy");
	trigger_blackhawk notify ("trigger", level.player);
	
	wait (4);
	
	level.peoplespeaking = true;
	//HQ radio
	//"Bravo Six, this is Strike Team Three inserting from the east. Repeat, we're movin' in from the east. Check your targets and confirm, over."
	radio_dialogue("launchfacility_a_friendlies_east");
	
	//Price
	//"Copy Team Three! We'll meet you at the north end of the tarmac, out!!"
	level.price dialogue_execute("launchfacility_a_price_copyteamthree");
	
	level.peoplespeaking = false;
	
	flag_set("obj_north_tarmac_given");
	
	flag_wait_either("player_near_vents", "obj_rappel_given");
	
	flag_set("obj_north_tarmac_complete");
	
}

blackhawk_think()
{
	eBlackhawk = maps\_vehicle::waittill_vehiclespawn("blackhawk");
	assert(isdefined(eBlackhawk.riders));
	println("there are " + eBlackhawk.riders.size + " dudes in the chopper");
	array_thread(eBlackhawk.riders, ::AI_friendly_reinforcements_think, eBlackhawk);
	eBlackhawk waittill("unload");
	
	flag_set("breach_the_vents");
	
	wait (11);

	/*-----------------------
	BLACKHAWK LEAVES
	-------------------------*/	
	eBlackhawk_depart_path = getent("blackhawk_depart_path", "script_noteworthy");
	eBlackhawk vehicle_detachfrompath();
	eBlackhawk thread vehicle_dynamicpath(eBlackhawk_depart_path, false ); 	
	
	eBlackhawk waittill ("reached_end_node");
	eBlackhawk delete();
}

AI_friendly_reinforcements_think(eVehicle)
{
	self endon ("death");
	self.ignoreme = true;
	eVehicle waittill("unload");
	
}

vents_friendly_movement()
{
	disable_color_trigs();
	triggersEnable("colornodes_vents", "script_noteworthy", true);
	trig = getent("colornodes_vents", "script_noteworthy");
	trig notify ("trigger", level.player);	
}

vent_explode(iExploder)
{
	ent = getent("exploder_sound_" + iExploder, "targetname");
	thread play_sound_in_space( "explo_metal_rand", ent.origin );
	exploder(iExploder);
}

friendlies_vent_rappel_setup()
{
	flag_wait("breach_the_vents");
	
	level.ventNodes01 = getentarray("node_rappel_team_1", "script_noteworthy");
	level.ventNodes02 = getentarray("node_rappel_team_2", "script_noteworthy");
	level.ventNodes03 = getentarray("node_rappel_team_3", "script_noteworthy");
	
	level.team01 = array_removeDead(level.team01);
	level.team01 = array_removeUndefined(level.team01);
	
	level.team02 = array_removeDead(level.team02);
	level.team02 = array_removeUndefined(level.team02);
	
	level.team03 = array_removeDead(level.team03);
	level.team03 = array_removeUndefined(level.team03);
	
	
	array_thread(level.team01, ::friendly_vent_think, "01");
	array_thread(level.team02, ::friendly_vent_think, "02");
	array_thread(level.team03, ::friendly_vent_think, "03");
	
	thread team02_rappel();
	thread team03_rappel();
	
	/*-----------------------
	TEAM ONE READY
	-------------------------*/			
	flag_wait("vent02_open");
	
	//Price
	//"Squad, hook up! "
	level.price thread dialogue_execute("launchfacility_a_price_ropesout_01");
	
	
	flag_wait("vent01_open");
	flag_wait("vent03_open");
	
	flag_set("hinds_appear");	

	flag_wait("team01_hooked_up");
	flag_set("obj_rappel_given");


	flag_wait("team03_hooked_up");
	thread vent_nag();
	
	wait (1);
	
	/*-----------------------
	TEAMS RAPPEL IF NOT DONE ALREADY
	-------------------------*/	
	flag_set("team03_go");
	wait (2);
	flag_set("team02_go");
}

team03_rappel()
{
	/*-----------------------
	TEAM THREE GOES DOWN
	-------------------------*/			
	flag_wait("team03_hooked_up");
	
	flag_wait("team03_go");
	
	thread team_rappel(level.team03);

	wait (3);
	//Marine 03
	//"Team Three is inside."
	thread radio_dialogue("launchfacility_a_marine3_teamin");	
}

team02_rappel()
{
	/*-----------------------
	TEAM TWO GOES DOWN
	-------------------------*/			
	flag_wait("team02_hooked_up");
	
	flag_wait("team02_go");
	//Marine 02
	//"Team Two rappelling now."
	thread radio_dialogue("launchfacility_a_marine2_rappelling");
	
	thread team_rappel(level.team02);

}

player_rappel()
{
	flag_wait("obj_rappel_given");

	/*-----------------------
	GLOWING OBJ AND USE TRIGGERS
	-------------------------*/			
	obj_position = getent ("obj_rappel", "targetname");
	rappelObjModel = spawn ("script_model", obj_position.origin);
	rappelObjModel setmodel("weapon_c4_obj");
	rappelObjModel.angles = obj_position.angles;
	trigRappel = getent("trig_rappel", "targetname");
	trigRappel trigger_on();
	trigRappel sethintstring( "Hold &&1 to rappel" );
	//trigRappel setHintString( &"LAUNCHFACILITY_A_HINTSTR_RAPPEL");
	trigRappel usetriggerrequirelookat();
	trigRappel waittill("trigger");
	trigRappel trigger_off();
	rappelObjModel delete();
	
	flag_set("obj_rappel_complete");
	level.player EnableInvulnerability();
	level.player disableWeapons();
	/*-----------------------
	OTHER TEAMS RAPPEL IF NOT DONE ALREADY
	-------------------------*/	
	flag_set("team03_go");
	flag_set("team02_go");
	
	thread player_squad_rappel();
	
	/*-----------------------
	PLAYER PLAYS RAPPEL ANIMATION
	-------------------------*/		
	player_node = getnode( "player_rappel_node", "targetname" );
	
	// this is the model the player will attach to for the rappel sequence
	model = spawn_anim_model( "player_rappel" );
	model hide();
	
	// put the model in the first frame so the tags are in the right place
	player_node anim_first_frame_solo( model, "rappel" );

	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	player_node thread anim_single_solo( model, "rappel" );
	player_node waittill( "rappel" );
	//level.player unlink();

}


player_squad_rappel()
{
	wait (0.3);
	level.grigsby notify ("rappel_down_vent");
	
	wait (1.2);
	
	level.price notify ("rappel_down_vent");

	wait (1);
	
	level.otherSquadFriendly notify ("rappel_down_vent");
	
	VisionSetNaked( "launchfacility_a_rappel", 4 );
	
	wait (2);
	
	//Price
	//"Ok, we're in."
	thread radio_dialogue("launchfacility_a_price_inside_facility");	
	
	wait (1);
	flag_set("level_fade_out");	
}

team_rappel(aDudes)
{
	for(i=0;i<aDudes.size;i++)
	{
		wait(1);
		aDudes[i] notify ("rappel_down_vent");
	}
}

hind_attack()
{
	flag_wait("hinds_appear");

	aAttackPointsHigher = getentarray("hind_attack_point_higher", "script_noteworthy");
	aAttackPointsLower = getentarray("hind_attack_point_lower", "script_noteworthy");

	thread hind_attack_think(aAttackPointsHigher, "hind_end_higher");
	thread hind_attack_think(aAttackPointsLower, "hind_end_lower");

	level.peoplespeaking = true;
	
	//Sniper team
	//"Bravo Six, Two Hinds closing fast on your position. You gotta get outta sight, now!"
	radio_dialogue("launchfacility_a_recon_two_helis");
	
	level.peoplespeaking = false;
	
}

hind_go_to_vent()
{
	if (!isdefined(self))
		return;

	flag_wait("obj_rappel_complete");
	org = getent("hind_above_vent", "targetname");
	self clearLookAtEnt();
	self setspeed(200, 15, 15);		
	self setvehgoalpos(org.origin, true);
}

hind_attack_think(aAttackPoints, sTargetname)
{
	level endon ("obj_rappel_complete");
	eHind = spawn_vehicle_from_targetname(sTargetname);
	eHind endon ("death");
	
	if (sTargetname == "hind_end_lower")
		eHind thread hind_go_to_vent();
	
	eStartPoint = getent(eHind.target, "targetname");
	eHind setspeed(120, 15, 15);
	
	/*-----------------------
	GO TO THE END OF PATH, THEN ATTACK
	-------------------------*/	
	eHind setneargoalnotifydist(500);
	dest = getent(eStartPoint.target, "targetname");
	eHind setvehgoalpos(dest.origin, false);
	eHind waittill ("near_goal");
	eHind vehicle_detachfrompath();
	eHind thread hind_guns_think();

	/*-----------------------
	GET ON LOOP PATH
	-------------------------*/	
	eAttackPoint = getent(dest.script_linkTo, "script_linkname");
	assert(isdefined(eAttackPoint));
	eHind setvehgoalpos(eAttackPoint.origin, true);
	eHind waittill ("near_goal");
	eHind setLookAtEnt(level.player);
	eHind setspeed(30, 15, 15);
	
	dest = eAttackPoint;
	bStrafe = false;
	
	while (true)
	{
		bStrafe = false;
		/*-----------------------
		STRAFE IF DEFINED AND PLAYER A TARGET
		-------------------------*/
		if (isdefined(dest.script_linkTo))
		{
			sStrafeNumber = getsubstr(dest.targetname, 7); 
			eStrafeVolume = getent("strafe_volume_" + sStrafeNumber, "targetname");
			assert(isdefined(eStrafeVolume));
			if (level.player istouching(eStrafeVolume))
			{
				dest = getent(dest.script_linkTo, "script_linkname");
				eHind clearLookAtEnt();
				eHind setspeed(200, 15, 15);	
				bStrafe = true;		
			}
		}
		/*-----------------------
		JUST GET NEXT NODE IN CHAIN
		-------------------------*/
		if (bStrafe == false)
		{
			dest = getent(dest.target, "targetname");
			eHind setLookAtEnt(level.player);
			eHind setspeed(30, 15, 15);
		}
		
		/*-----------------------
		GO TO NEXT NODE (STRAFE OR RING)
		-------------------------*/			
		eHind setvehgoalpos(dest.origin, false);
		eHind waittill ("near_goal");
	}
}

hind_guns_think()
{
	level endon ("obj_rappel_complete");
	self endon ("death");
	while (true)
	{
		wait (randomfloatrange(2, 5));
		self thread fireMG(randomintrange(8, 17));
		wait (randomfloatrange(2, 5));
	}
	
	//eHind maps\_helicopter_globals::fire_missile( "ffar_bog_a_lite", 1, level.player );
	
}

level_end()
{
	flag_wait("level_fade_out");

	missionsuccess("launchfacility_b", false);
}

vent_nag()
{
	level endon ("obj_rappel_complete");
	wait (6.5);
	thread vent_nag_cleanup();
	if (!flag("obj_rappel_complete"))
		thread hint(&"LAUNCHFACILITY_A_HINTSTR_RAPPEL_DOWN_SHAFT", 9999);
	//Price
	//Jackson! Hook up! Let's go!"
	if (!flag("obj_rappel_complete"))
		level.price dialogue_execute("launchfacility_a_price_ropenag");	
}

vent_nag_cleanup()
{
	flag_wait("obj_rappel_complete");
	thread hint_fade();
}

friendly_vent_think(sTeam)
{
	self endon ("death");

	if (!isdefined(self))
		return;
	if (!isalive(self))
		return;

	/*-----------------------
	EACH AI GETS ASSIGNED CLOSEST NODE
	-------------------------*/	

	self.rappelNode = undefined;
	self.hookedUp = false;
	sFlagVentOpen = undefined;
	sFlagTeamInPosition = undefined;
	sDialogue = undefined;
	aTeam = undefined;
	
	switch (sTeam)
	{
		case "01":
			aTeam = level.team01;
			if (!level.ventNodes01.size > 0)
			{
				self.hookedUp = true;
				return;
			}
			self.rappelNode = getclosest(self.origin, level.ventNodes01);
			level.ventNodes01 = array_remove(level.ventNodes01, self.rappelNode);
			sFlagTeamInPosition = "team01_hooked_up";
			sFlagVentOpen = "vent02_open";
			if (!isdefined(level.team01breacher))
			{
				level.team01breacher = self;
				self thread friendly_breach_vent("02", sFlagVentOpen);
			}
			if ( (self != level.price) && (self != level.grigsby) )
				level.otherSquadFriendly = self;
			break;
		case "02":
			aTeam = level.team02;
			if (!level.ventNodes02.size > 0)
			{
				self.hookedUp = true;
				return;
			}
			self.rappelNode = getclosest(self.origin, level.ventNodes02);
			level.ventNodes02 = array_remove(level.ventNodes02, self.rappelNode);
			sFlagTeamInPosition = "team02_hooked_up";
			sFlagVentOpen = "vent03_open";
			sDialogue = "launchfacility_a_marine2_rappelling";
			if (!isdefined(level.team02breacher))
			{
				level.team02breacher = self;
				self thread friendly_breach_vent("03", sFlagVentOpen);
			}
			break;
		case "03":
			aTeam = level.team03;
			if (!level.ventNodes03.size > 0)
			{
				self.hookedUp = true;
				return;
			}
			self.rappelNode = getclosest(self.origin, level.ventNodes03);
			level.ventNodes03 = array_remove(level.ventNodes03, self.rappelNode);
			sFlagTeamInPosition = "team03_hooked_up";
			sFlagVentOpen = "vent01_open";
			sDialogue = "launchfacility_a_marine3_teamin";
			if (!isdefined(level.team03breacher))
			{
				level.team03breacher = self;
				self thread friendly_breach_vent("01", sFlagVentOpen);
			}
			break;
	}

	flag_wait(sFlagVentOpen);
	while (!isdefined(self.rappelNode))
		wait (0.05);		

	/*-----------------------
	PICK RAPPEL IDLES AND SETUP
	-------------------------*/	
	sAnim_rappel_setup_to_stand = undefined;
	sAnim_rappel_stand_idle = undefined;
	if ( (isdefined(self.rappelNode)) && (isdefined(self.rappelNode.targetname)) && (self.rappelNode.targetname == "rappel_variation_1") ) 
	{
		sAnim_rappel_setup_to_stand = "rappel_setup_to_stand_1";
		sAnim_rappel_stand_idle = "rappel_stand_idle_1";
	}
	else
	{
		sAnim_rappel_setup_to_stand = "rappel_setup_to_stand_2";
		sAnim_rappel_stand_idle = "rappel_stand_idle_2";
	}	

	/*-----------------------
	FRIENDLY HOOKS UP TO ROPE
	-------------------------*/	
	self disable_ai_color();
	self.rappelNode anim_reach_solo (self, "rappel_setup_start");
	self.rappelNode anim_single_solo(self, "rappel_setup_start");
	self.rappelNode anim_single_solo(self, sAnim_rappel_setup_to_stand);
	self.rappelNode thread anim_loop_solo (self, sAnim_rappel_stand_idle, undefined, "stop_idle");

	self.hookedUp = true;

	/*-----------------------
	IF ALL FRIENDLIES HOOKED UP, SET FLAG
	-------------------------*/			
	bTeamReady = true;
	for(i=0;i<aTeam.size;i++)
	{
		if (aTeam[i].hookedUp == false)
			bTeamReady = false;
	}
	if (bTeamReady)
		flag_set(sFlagTeamInPosition);
	
	/*-----------------------
	WAITS AND THEN RAPPELS DOWN
	-------------------------*/		
	self waittill ("rappel_down_vent");	
	
	self.rappelNode anim_single_solo(self, "rappel_drop");
	
	self notify( "stop magic bullet shield" );
	self delete();
}

friendly_breach_vent(sVentNumber, sFlagVentOpen)
{
	self endon ("death");
	self disable_ai_color();
	
	eAnimEnt = getent("node_scripted_vent_" + sVentNumber, "script_noteworthy");
	assert(isdefined(eAnimEnt));
	eAnimEnt anim_reach_solo (self, "C4_plant_start");
	eAnimEnt anim_single_solo(self, "C4_plant");
	self enable_ai_color();	
	wait (3);
	
	switch (sVentNumber)
	{
		case "01":
			thread vent_explode(600);
			break;
		case "02":
			thread vent_explode(700);
			break;
		case "03":
			thread vent_explode(800);
			break;
	}
	
	/*-----------------------
	VENT HAS BEEN BREACHED
	-------------------------*/			
	flag_set(sFlagVentOpen);
	
}


/****************************************************************************
    UTILITY FUNCTIONS
****************************************************************************/
AA_utility()
{
	
}

rpg_ambient(aRpgSources, aRpgTargets, iQuantity)
{
	iRpgs = 0;
	while (iRpgs < iQuantity)
	{
		iRpgs++;
		assertEx(aRpgSources.size > 0, "No more RPG sources left");
		assertEx(aRpgTargets.size > 0, "No more RPG targets left");
		eSource = getFarthest(level.player.origin, aRpgSources);
		aRpgSources = array_remove(aRpgSources, eSource);
		eTarget = getClosest(level.player.origin, aRpgTargets);
		//attractorRPG = missile_createAttractorEnt( eTarget, 10000, 6000 );
		aRpgTargets = array_remove(aRpgTargets, eTarget);
		magicbullet("rpg", eSource.origin, eTarget.origin);	
		wait(randomfloatrange(1.5,2.5));
		//missile_deleteAttractor(attractorRPG);
	}
}

c4_plant_think()
{
	iExploderNum = self.script_noteworthy;
	assertEx((isdefined(iExploderNum)), "Need to specify an integer for the exploder number to be used with this entity");
	eApproachTrigger = getent( self.target, "targetname" );
	assertEx((isdefined(eApproachTrigger)), "script_origin needs to target a trigger_multiple");
	eApproachTrigger waittill ( "trigger" );
	
	self maps\_c4::c4_location( undefined, (0, 0, 0), (0, 0, 0), self.origin );
	self waittill( "c4_detonation" );
	exploder(iExploderNum);
	
	self thread play_sound_in_space("detpack_explo_concrete");

	if ( isdefined( level.c4_callback_thread ) )
		self thread [[ level.c4_callback_thread ]]();
}

launch_lid_setup()
{
	thread launch_lid_think("03");
	thread launch_lid_think("04");
	thread launch_lid_think("05");
	thread launch_lid_think("06");
}

launch_flag_management(iTubeNumber)
{
	sFlag = "player_near_launchtube_" + iTubeNumber;
	flag_wait(sFlag);
	sOtherFlag = undefined;
	
	wait(2);
	if (iTubeNumber == "03")
		sOtherFlag = "player_near_launchtube_04";	
	if (iTubeNumber == "04")
		sOtherFlag = "player_near_launchtube_03";	
	if (iTubeNumber == "05")
		sOtherFlag = "player_near_launchtube_06";
	if (iTubeNumber == "06")
		sOtherFlag = "player_near_launchtube_05";		
		
	if (!flag(sOtherFlag))
		flag_set(sOtherFlag);
}

launch_lid_think(iTubeNumber)
{
	thread launch_flag_management(iTubeNumber);
	/*-----------------------
	VARIABLE SETUP
	-------------------------*/	
	sFlag = "player_near_launchtube_" + iTubeNumber;
	eLidArm = getent("lid_arm_" + iTubeNumber, "targetname");
	eLid = getent("lid_" + iTubeNumber, "targetname");
	eLidFxEnt = getent("lid_fx_" + iTubeNumber, "targetname");
	eLidFxEnt.opening = false;
	eAnimEnt = getent("lid_origin_" + iTubeNumber, "targetname");
	assert(isdefined(eLidArm));
	assert(isdefined(eLid));
	assert(isdefined(eAnimEnt));	
	eLid.rotationDummy = spawn( "script_origin", ( 0, 0, 0 ) );
	eLid.rotationDummy.angles = eAnimEnt.angles;
	eLid.rotationDummy.origin = eAnimEnt.origin;
	eLidArm.rotationDummy = spawn( "script_origin", ( 0, 0, 0 ) );
	eLidArm.rotationDummy.angles = eAnimEnt.angles;
	eLidArm.rotationDummy.origin = eAnimEnt.origin;
	eLid linkTo(eLid.rotationDummy);
	eLidArm linkTo(eLidArm.rotationDummy);	
	eMissile = getent("missile" + iTubeNumber, "targetname");
	assert(isdefined(eMissile));
	/*-----------------------
	ROTATE ARMAS DOWN IMMEDIATELY IN PREP
	-------------------------*/	
	eLidArm.rotationDummy rotatepitch(125, .5);
						//moveto( <point>, <time>, <acceleration time>, <deceleration time> )
	eLidArm.rotationDummy moveto(eLidArm.rotationDummy.origin + (0, 0, -50), .5);	
	/*-----------------------
	WAIT UNTIL PLAYER CLOSE TO LID
	-------------------------*/			
	flag_wait(sFlag);


	/*-----------------------
	INITIAL PARTICLES AND SOUND
	-------------------------*/		
	eLidFxEnt playsound (level.scr_sound["launch_tube_prepare"], "sounddone");
	
	eLidFxEnt thread heat_shimmer();
	playfx (level._effect["steam_cs"], eLidFxEnt.origin);
	playfx (level._effect["fog_hunted_a"], eLidFxEnt.origin - (0, 0, 200));
	eLidFxEnt waittill ("sounddone");

	/*-----------------------
	BADPLACE
	-------------------------*/	
	//eBadplace = getent("badplace_lid_" + iTubeNumber, "targetname");
	//assertEx((isdefined(eBadplace)), "There is no volume with targetname badplace_lid_" + iTubeNumber);
	//badplace_brush("badplace_lid_volume" + iTubeNumber, 0, eBadplace, "allies", "axis");
	badplace_cylinder("badplace_lid_volume" + iTubeNumber, 0, eAnimEnt.origin, 225, 512, "axis", "axis");
	
	/*-----------------------
	ROTATE LID OUTWARDS AND PLAY LOOP SOUND
	-------------------------*/	
	iOpenTime = 20;
	eLidFxEnt thread launch_lid_sound();
	eLidFxEnt.opening = true;
	
	eMissile thread missile_move();
	
	eLid.rotationDummy rotatepitch(-125, iOpenTime, 2, 2);
	eLidArm.rotationDummy rotatepitch(-125, iOpenTime/1.5, 1, 1);
	eLidArm.rotationDummy moveto(eLidArm.rotationDummy.origin + (0, 0, 50), (iOpenTime/2.5), 0, 2);	
	wait (iOpenTime - 1);
	eLidFxEnt.opening = false;
	eLidFxEnt notify("stopped_opening");

	/*-----------------------
	CLEANUP
	-------------------------*/	
	wait (2);
	eLid.rotationDummy delete();
	eLidArm.rotationDummy delete();
	eAnimEnt delete();

	/*-----------------------
	LET HEAT SHIMMER CONTINUE FOR A WHILE
	-------------------------*/	
	//wait(10);
	//eLidFxEnt notify("stop_heat_shimmer");
}

heat_shimmer()
{
	self endon ("stop_heat_shimmer");
	wait (4);
	while (true)
	{
		playfx (level._effect["abrams_exhaust"], self.origin);
		wait (.05);
	}
}

missile_move()
{
	//self ==> the missile
	self moveto( self.origin + (0, 0, 175), 18, 4, 4);
}
launch_lid_sound()
{
	//self ==> eLidFxEnt script_origin
	
	self playsound (level.scr_sound["launch_tube_open_start"], "sounddone");
	wait(1);
	self thread play_loop_sound_on_entity (level.scr_sound["launch_tube_open_loop"]);

	self waittill ("stopped_opening");
	self notify ( "stop sound" + level.scr_sound["launch_tube_open_loop"]);
	self playsound (level.scr_sound["launch_tube_open_end"]);

}



disable_color_trigs()
{
	array_thread(level.aColornodeTriggers, maps\_utility::trigger_off);
}

dialogue_loudspeaker(sDialogue)
{
	origin_sound_alarm = getent("origin_sound_alarm", "targetname");
	origin_sound_alarm play_sound_on_entity(level.scr_sound[sDialogue]);
}

squad_bmp_destroy(sTargetname)
{
	sFlagName = sTargetname + "_destroyed";
	level endon (sFlagName);
	bmp = getent(sTargetname, "targetname");
	assertEx((isdefined(bmp)), "BMP with targetname " + sTargetname + " is not defined");
	sFlagPlayerNearBMP = "player_near_" + sTargetname;

	/*-----------------------
	WAIT FOR PLAYER TO BE OUT OF VIEW
	-------------------------*/	
	while (flag(sFlagPlayerNearBMP))
		wait (.5);
	
	//Marine 01
	//"Charges placed! We’re blowing the BMP! Take cover! Move Move!!!"
	radio_dialogue("launchfacility_a_marine_01_blowing_bmp");
	
	if(isdefined(bmp))
	{
		if (!flag(sFlagName))
		{
			bmp endon ("death");
			sC4tag = "rear_hatch_open_jnt_left";
			iEntityNumber = bmp getentitynumber();	
			bmp thread vehicle_death(iEntityNumber, sC4tag);
		}
	}
}

player_kill_counter(iKillMax)
{
	level notify("reset_kill_counter");
	level endon("reset_kill_counter");
	flag_clear("player_reached_kill_max");
	
	level.axisKilledByPlayer = 0;
	while (level.axisKilledByPlayer < iKillMax)
		wait (2);
	
	flag_set("player_reached_kill_max");
}

c4_callback_thread_launchfacility()
{
	//self ==> the script_origin that acted as the location for the C4 plant and the exploder number
	switch (self.script_noteworthy)
	{
		case "100":	//the side breach wall beyond container area
			flag_set("flanking_wall_breached");
			break;
	}
}

obj_gain_access()
{
	flag_wait("obj_gain_access_given");
	objective_number = 1;

	obj_position = getent ("obj_gain_access", "targetname");
	objective_add(objective_number, "active", &"LAUNCHFACILITY_A_OBJ_GAIN_ACCESS", obj_position.origin);
	objective_current (objective_number);

	flag_wait ("obj_gain_access_complete");
	
	objective_state (objective_number, "done");
}

obj_enemy_armor()
{
	flag_wait("obj_enemy_armor_given");

	objective_add(10, "invisible",  &"LAUNCHFACILITY_A_OBJ_ENEMY_ARMOR");
	objective_string(10, &"LAUNCHFACILITY_A_OBJ_ENEMY_ARMOR",  level.enemyArmor.size);
	objective_state(10, "active");
	objective_current(10);	

	flag_wait ("obj_enemy_armor_complete");
	
	objective_state (10, "done");
}

obj_enemy_armor_vehicle_think()
{
	level.enemyArmorIndex++;
	index = level.enemyArmorIndex;
	level.enemyArmor = array_add(level.enemyArmor, self);
	objective_string(10,  &"LAUNCHFACILITY_A_OBJ_ENEMY_ARMOR", level.enemyArmor.size);
	objective_additionalposition(10, index, self.origin);
	
	if (level.enemyArmorIndex == 2 )
	{
		wait(1);
		objective_string(10,  &"LAUNCHFACILITY_A_OBJ_ENEMY_ARMOR", level.enemyArmor.size);	
	}
		
	
	self waittill ("death");
	level.enemyArmor = array_remove(level.enemyArmor, self);
	objective_additionalposition(10, index, (0,0,0));	
	
	if (level.enemyArmor.size == 0)
	{
		flag_set ("obj_enemy_armor_complete");
		objective_state(10, "invisible");		
	}

	objective_string(10,  &"LAUNCHFACILITY_A_OBJ_ENEMY_ARMOR", level.enemyArmor.size);	

}



obj_north_tarmac()
{
	flag_wait("obj_north_tarmac_given");
	objective_number = 5;

	obj_position = getent ("obj_rappel", "targetname");
	objective_add(objective_number, "active", &"LAUNCHFACILITY_A_OBJ_NORTH_TARMAC", obj_position.origin);
	objective_current (objective_number);

	flag_wait ("obj_north_tarmac_complete");
	
	objective_state (objective_number, "done");	
}


obj_rappel()
{
	flag_wait("obj_rappel_given");
	objective_number = 4;

	obj_position = getent ("obj_rappel", "targetname");
	objective_add(objective_number, "active", &"LAUNCHFACILITY_A_OBJ_RAPPEL", obj_position.origin);
	objective_current (objective_number);

	flag_wait ("obj_rappel_complete");
	
	objective_state (objective_number, "done");	
}

vehicle_bmp_setup( aTargetname )
{
	for(i=0;i<aTargetname.size;i++)
		thread vehicle_bmp_think ( aTargetname[i] );
	
	/*-----------------------
	SETUP BLASTMARKS FOR TARMAC
	-------------------------*/		
	blastmark_bmp_03 = getent("blastmark_bmp_03", "targetname");
	blastmark_bmp_04 = getent("blastmark_bmp_04", "targetname");
	if (isdefined(blastmark_bmp_03))
		blastmark_bmp_03 hide();
	if (isdefined(blastmark_bmp_04))
		blastmark_bmp_04 hide();

}

vehicle_bmp_think( sTargetname )
{
	eVehicle = maps\_vehicle::waittill_vehiclespawn( sTargetname );
	
	if ( (isdefined(eVehicle.script_noteworthy)) && (eVehicle.script_noteworthy == "objective_tarmac_armor") )
		eVehicle thread obj_enemy_armor_vehicle_think();
	
	eVehicle thread vehicle_turret_think();
	eVehicle thread vehicle_death_think();
	eVehicle thread vehicle_patrol_think();
	eVehicle thread vehicle_c4_think();
	eVehicle thread vehicle_enemies_setup();

	/*-----------------------
	BADPLACE TO KEEP ALLIES ON PERIMETER OF BMP
	-------------------------*/			
	eBadplace = getent("badplace_" + sTargetname, "targetname");
	if (isdefined(eBadplace))
		badplace_brush(sTargetname, 0, eBadplace, "allies");

	/*-----------------------
	DELETE BADPLACE AND SET FLAG WHEN DEAD
	-------------------------*/			
	eVehicle waittill ("death");
	eVehicleDeathOrigin = spawn( "script_origin", ( 0, 0, 0 ) );
	eVehicleDeathOrigin.angles = eVehicle.angles;
	eVehicleDeathOrigin.origin = eVehicle.origin;
	
	sFlag = sTargetname + "_destroyed";
	flag_set(sFlag);
	
	if (isdefined(eBadplace))
		badplace_delete(sTargetname);

	/*-----------------------
	CREATE BLAST MARK IF DEFINED
	-------------------------*/			
	blastmark_org = getent("blastmark_org_" + sTargetname, "targetname");
	if (isdefined(blastmark_org))
	{
		eBlastMark = getent("blastmark_" + sTargetname, "targetname");
		assertEx((isdefined(eBlastMark)), "There is no blast mark with targetname blastmark_" + sTargetname);
		eBlastMark show();
		eBlastMarkDummy = getent("blastmark_org_" + sTargetname, "targetname");
		assertEx((isdefined(eBlastMarkDummy)), "No script_origin with targetname blastmark_org_"  + sTargetname);
		eBlastMark linkTo(eBlastMarkDummy);
		eBlastMarkDummy.angles = eVehicleDeathOrigin.angles;
		eBlastMarkDummy.origin = (eVehicleDeathOrigin.origin[0],eVehicle.origin[1], blastmark_org.origin[2] + (1));
		eBlastMarkDummy thread print3Dthread("BLAST MARK!!!!");
		
		wait (0.05);
		eBlastMarkDummy unlink();
		eBlastMarkDummy delete();
		eVehicleDeathOrigin delete();
	}
}

vehicle_death_think()
{
	self endon ("death");
	sC4tag = "rear_hatch_open_jnt_left";
	iEntityNumber = self getentitynumber();	
	iProjectileHits = 0;
	
	while (true)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );

		if (attacker != level.player)
				continue;		
		if ( !isdefined( damage ) )
			continue;
		if ( damage <= 0 )
			continue;
		type = getDamageType( type );
		assert( isdefined( type ) );

		if ( type == "rocket" )
		{
			if (damage >= 300)
			{
				iProjectileHits++;
				if (iProjectileHits == 1)
					self thread vehicle_smoke();
				if (iProjectileHits == 2)	
					break;
			}
		}
		if ( type == "c4" )
		{
			if (damage >= 250)
				break;
		}
	}
	
	self thread vehicle_death(iEntityNumber, sC4tag);

}

vehicle_smoke()
{
	iprintlnbold("^2MARINE:^7 That's a hit! one more ought to do it");
	eSmokeOrg = spawn( "script_origin", ( 0, 0, 0 ) );
	eSmokeOrg.origin = self gettagorigin("tag_origin");
	eSmokeOrg linkto(self);
	
	while (isalive(self))
	{
		playfx (getfx( "smoke_trail_bmp"), eSmokeOrg.origin);
		playfx (getfx( "smoke_trail_bmp"), eSmokeOrg.origin + (50,50,-50));
		wait(.1);
	}	

	self waittill("death");
	eSmokeOrg delete();
}

getDamageType( type )
{
	//returns a simple damage type: melee, bullet, splash, or unknown
	
	if ( !isdefined( type ) )
		return "unknown";
	
	type = tolower( type );
	switch( type )
	{

		case "mod_grenade":
		case "mod_grenade_splash":
			return "c4";
		case "mod_projectile":
		case "mod_projectile_splash":
			return "rocket";
		case "unknown":
			return "unknown";
		default:
			return "unknown";
	}
}

vehicle_get_target(aExcluders)
{
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, false, false, false,  aExcluders);
	return eTarget;
}

vehicle_debug()
{
	self endon ("death");
	while (true)
	{
		wait(.5);
		thread debug_circle( self.origin, level.bmpMGrange, 0.5, level.color[ "red" ], undefined, true);
		thread debug_circle( self.origin, level.bmpCannonRange, 0.5, level.color[ "blue" ], undefined, true);
	}
}

vehicle_turret_think()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;
	aExcluders = level.squad;

	currentTargetLoc = undefined;

	
	if (getdvar("debug_bmp") == "1")
		self thread vehicle_debug();

	while (true)
	{
		wait (0.05);
		/*-----------------------
		GET A NEW TARGET UNLESS CURRENT ONE IS PLAYER
		-------------------------*/		
		if ( (isdefined(eTarget)) && (eTarget == level.player) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
			if ( !sightTracePassed )
			{
				//self clearTurretTarget();
				eTarget = self vehicle_get_target(aExcluders);
			}
				
		}
		else
			eTarget = self vehicle_get_target(aExcluders);

		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( (isdefined(eTarget)) && (isalive(eTarget)) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec(targetLoc);
			
			
			if (getdvar("debug_bmp") == "1")
				thread draw_line_until_notify(self.origin + (0, 0, 32), targetLoc, 1, 0, 0, self, "stop_drawing_line");
			
			fRand = ( randomfloatrange(2, 3));
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON OR MG
			-------------------------*/
			if ( (isdefined(eTarget)) && (isalive(eTarget)) )
			{
				if ( distancesquared(eTarget.origin,self.origin) <= level.bmpMGrangeSquared)
				{
					if (!self.mgturret[0] isfiringturret())
						self thread maps\_vehicle::mgon();
					
					wait(.5);
					if (!self.mgturret[0] isfiringturret())
					{
						self thread maps\_vehicle::mgoff();
						if (!self.turretFiring)
							self thread vehicle_fire_main_cannon();			
					}
	
				}
				else
				{
					self thread maps\_vehicle::mgoff();
					if (!self.turretFiring)
						self thread vehicle_fire_main_cannon();	
				}				
			}

		}
		
		//wait( randomfloatrange(2, 5));
	
		if (getdvar( "debug_bmp") == "1")
			self notify( "stop_drawing_line" );
	}
}

vehicle_fire_main_cannon()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	//self notify ("firing_cannon");
	//self endon ("firing_cannon");
	
	iFireTime = weaponfiretime("bmp_turret");
	assert(isdefined(iFireTime));
	
	iBurstNumber = randomintrange(3, 8);
	
	self.turretFiring = true;
	i = 0;
	while (i < iBurstNumber)
	{
		i++;
		wait(iFireTime);
		self fireWeapon();
	}
	self.turretFiring = false;
}

vehicle_c4_think()
{
	
	sC4tag = "rear_hatch_open_jnt_left";
	c4org = self gettagorigin(sC4tag);
	iEntityNumber = self getentitynumber();	
	self maps\_c4::c4_location( sC4tag, (0, -33, 10), (0, 90, -90) );
	
	self waittill( "c4_detonation" );

	/*-----------------------
	C4 STUNS AI CLOSEBY
	-------------------------*/			
	AI = get_ai_within_radius(512, c4org, "axis");
	if ( (isdefined(AI)) && (AI.size > 0) )
		array_thread(AI, ::AI_stun, .75);

	self thread vehicle_death(iEntityNumber, sC4tag);
}

vehicle_death(iEntityNumber, sC4tag)
{
	self notify("clear_c4");
	setplayerignoreradiusdamage(true);
	
	/*-----------------------
	SECONDARY EXPLOSIONS
	-------------------------*/		

//	wait ( randomfloatrange(0.5, 1) );
//	thread play_sound_in_space( "explo_metal_rand", self.origin );
//	playfxontag( level._effect["c4_secondary_explosion_01"], self, sC4tag );
//	radiusdamage(self.origin, 128, level.maxBMPexplosionDmg, level.minBMPexplosionDmg);
//
//	wait ( randomfloatrange(1, 1.5) );
//	thread play_sound_in_space( "explo_metal_rand", self gettagorigin( "tag_turret" ) );
//	playfxontag( level._effect["c4_secondary_explosion_02"], self, "tag_turret" );
//	radiusdamage(self.origin, 128, level.maxBMPexplosionDmg, level.minBMPexplosionDmg);
//	wait ( randomfloatrange(0.55, .75) );
	
	/*-----------------------
	FINAL EXPLOSION
	-------------------------*/		
	earthquake (0.6, 2, self.origin, 2000);	
	self notify( "death" );
	thread play_sound_in_space( "building_explosion3", self gettagorigin( "tag_turret" ) );
	AI = get_ai_within_radius(1024, self.origin, "axis");
	if ( (isdefined(AI)) && (AI.size > 0) )
		array_thread(AI, ::AI_stun, .85);

	/*-----------------------
	ONLY TOKEN DAMAGE INFLICTED ON PLAYER
	-------------------------*/
	radiusdamage(self.origin, 256, level.maxBMPexplosionDmg, level.minBMPexplosionDmg);
	thread player_token_vehicle_damage(self.origin);
	thread autosave_by_name("bmp_" + iEntityNumber + "_destroyed");	
	
	wait (2);
	setplayerignoreradiusdamage(false);
}

player_token_vehicle_damage(org)
{
	if ( distancesquared(org,level.player.origin) <= level.playerVehicleDamageRangeSquared )
		level.player dodamage(level.player.health / 3, (0,0,0));
}

vehicle_enemies_setup()
{
	//self ==> the vehicle
	if (!isdefined(self.script_linkto))
		return;
	eSpawnTrigger = getent(self.script_linkto, "script_linkname");
	

	/*-----------------------
	SPAWN HOSTILE SUPPORT
	-------------------------*/			
	eSpawnTrigger notify ("trigger", level.player);

	/*-----------------------
	KILLSPAWNERS GET TRIGGERED WHEN VEHICLE DIES
	-------------------------*/	
	aKillSpawnerTrigs = getentarray(eSpawnTrigger.script_linkto, "script_linkname");
//	aKillSpawnerTrigs = [];
//	tokens = strtok( eSpawnTrigger.script_linkto, " " );
//	for ( i=0; i < tokens.size; i++ )
//		aKillSpawnerTrigs[aKillSpawnerTrigs.size] = getent( tokens[ i ], "script_linkname" );

	assertEx((aKillSpawnerTrigs.size > 0), "Vehicle trigger that spawns support AI needs to scriptLinkto one or more killspawners. Targetname: " + self.targetname);
	array_thread(aKillSpawnerTrigs, ::vehicle_AI_killspawner_triggers_think, self);

	/*-----------------------
	ENEMY MOVES WHEN VEHICLE MOVES
	-------------------------*/	
	aHostileMovementTriggers = getentarray("triggers_" + self.targetname, "script_noteworthy");
	assertEx((isdefined(aHostileMovementTriggers)), "There are no triggers with script_noteworthy of triggers_" + self.targetname);
	array_thread(aHostileMovementTriggers, ::vehicle_AI_movement_triggers_think, self);

}

vehicle_AI_killspawner_triggers_think(eVehicle)
{
	eVehicle waittill ("death");
	self notify ("trigger", level.player);
}

vehicle_AI_movement_triggers_think(eVehicle)
{
	//self ==> the vehicle trigger that targets the goal volumes for enemy AI
	eVehicle endon ("death");
	
	eGoalVolume = getent(self.target, "targetname");
	assert(isdefined(eGoalVolume));
	
	while (true)
	{
		self waittill("trigger", ent);
		if (ent != eVehicle)
			continue;
		
		eVehicle notify ("changing_volume", eGoalVolume);
		eVehicle waittill ("changing_volume");
		wait (5);
	}
}

AI_vehicle_support()
{
	self endon ("death");
	
	eVehicleOrigin = getent(self.script_linkto, "script_linkname");
	assertEx((isdefined(eVehicleOrigin)), "Spawner with export number " + self.export + " needs to scriptLinkTo a single script_origin named origin_<vehiclename>");
	sVehicleName = getsubstr(eVehicleOrigin.script_noteworthy, 7);
	eVehicle = getent(sVehicleName, "targetname");
	assertEx((isdefined(eVehicle)), "There is no vehicle spawned with a targetname of " + sVehicleName);
	
	self thread AI_vehicle_support_vehicle_dead(eVehicle);
	
	while (true)
	{
		eVehicle waittill ("changing_volume", eGoalVolume);
		self set_goalvolume(undefined, eGoalVolume);
		wait (0.05);
	}
}

AI_vehicle_support_vehicle_dead(eVehicle)
{
	self endon ("death");
	eVehicle waittill ("death");
	
	self.health = 1;
	self thread AI_player_seek();
}

vehicle_patrol_init()
{
	level.aVehicleNodes = [];
	array1 = getvehiclenodearray( "go_right", "script_noteworthy" );
	array2 = getvehiclenodearray( "go_left", "script_noteworthy" );
	level.aVehicleNodes = array_merge( array1, array2 );	
}

vehicle_patrol_think()
{
	self endon ("death");

	ePathstart = self.attachedpath;
	self waittill ("reached_end_node");
	
	while (true)
	{
		wait (0.05);
		
		/*-----------------------
		REINITIALIZE ALL VARIABLES
		-------------------------*/			
		aLinked_nodes = [];
		eCurrentNode = undefined;
		go_left_node = undefined;
		go_right_node = undefined;
		eStartNode = undefined;		
		aPossibleEndNodes = [];
		closestEndNode = undefined;
		
//		/*-----------------------
//		WAIT FOR PLAYER LOCATION
//		-------------------------*/	
//		if ( !isdefined(level.player_location) )
//			level waittill ( "player_location_updated" );
//		
//		wait (0.05);
		/*-----------------------
		GET LAST NODE IN CHAIN (CURRENT POSITION
		-------------------------*/	
		assert(isdefined(ePathstart));
		eCurrentNode = ePathstart get_last_ent_in_chain("vehiclenode");

//		/*-----------------------
//		WHERE IS VEHICLE NOW? (LEFT, RIGHT, MID)
//		-------------------------*/		
//		assertEx((isdefined(ePathend.script_noteworthy)), "Ends of vehicle path must have a script_noteworthy of 'left', 'mid' or 'right': vehiclenode " + ePathend.targetname);
//		sCurrentVehiclePosition = ePathend.script_noteworthy;

		/*-----------------------
		GET ALL NODES THAT ARE GROUPED WITH THIS PATH END
		-------------------------*/		

		aLinked_nodes = level.aVehicleNodes;
		aLinked_nodes = array_remove( aLinked_nodes, eCurrentNode);
		aVehicleNodes = level.aVehicleNodes;
		sScript_vehiclenodegroup = eCurrentNode.script_vehiclenodegroup;
		assert(isdefined(sScript_vehiclenodegroup));
		for(i=0;i<aVehicleNodes.size;i++)
		{
			assertEx((isdefined(aVehicleNodes[i].script_vehiclenodegroup)), "Vehiclenode at " + aVehicleNodes[i].origin + " needs to be assigned a script_vehiclenodegroup");
			if ( aVehicleNodes[i].script_vehiclenodegroup != sScript_vehiclenodegroup )
				aLinked_nodes = array_remove( aLinked_nodes, aVehicleNodes[i] );
		}
		/*-----------------------
		GET START NODES TO GO LEFT/RIGHT FROM HERE
		-------------------------*/
		assertEx(aLinked_nodes.size > 0, "Ends of vehicle paths need to be grouped with at least one other chain of nodes for moving left, right or both");
		for(i=0;i<aLinked_nodes.size;i++)
		{
			if ( isdefined(aLinked_nodes[i].script_noteworthy) && (aLinked_nodes[i].script_noteworthy == "go_left") )
			{
				go_left_node = aLinked_nodes[i];
				go_left_node.end = undefined;				
			}

			else if ( isdefined(aLinked_nodes[i].script_noteworthy) && (aLinked_nodes[i].script_noteworthy == "go_right") )
			{
				go_right_node = aLinked_nodes[i];
				go_right_node.end = undefined;
			}
		}
		
		/*-----------------------
		DEFINE THE END NODE FOR EACH START NODE
		-------------------------*/		
		aPossibleEndNodes[0] = eCurrentNode;
		if ( isdefined(go_left_node) )
		{
			go_left_node.end = go_left_node get_last_ent_in_chain("vehiclenode");
			aPossibleEndNodes = array_add( aPossibleEndNodes, go_left_node.end );
		}		
		
		if ( isdefined(go_right_node) )
		{
			go_right_node.end = go_right_node get_last_ent_in_chain("vehiclenode");
			aPossibleEndNodes = array_add( aPossibleEndNodes, go_right_node.end );
		}
				
		/*-----------------------
		STAY PUT, OR START A NEW PATH?
		-------------------------*/			

		closestEndNode = getclosest( level.player.origin, aPossibleEndNodes );
		if ( closestEndNode == eCurrentNode )
			eStartNode = undefined;
		else if ( (isdefined(go_left_node)) && ( closestEndNode == go_left_node.end ) )
			eStartNode = go_left_node;
		else if ( (isdefined(go_right_node)) && ( closestEndNode == go_right_node.end ) )
			eStartNode = go_right_node;

		/*-----------------------
		GO ON THE NEW PATH TO GET CLOSER TO PLAYER
		-------------------------*/		
		if ( isdefined(eStartNode) )
		{
			self attachpath( eStartNode );
			ePathstart = eStartNode;
			thread maps\_vehicle::gopath( self );
			self waittill ("reached_end_node");
		}
		/*-----------------------
		STAY PUT AND WAIT A FEW SECONDS
		-------------------------*/		
		else
		{
			wait (3);
		}
	}

//		
//		/*-----------------------
//		IF PLAYER AND VEHICLE NOT IN SAME AREA
//		-------------------------*/			
//		sPlayerLocation = get_player_general_location();
//		
//		if ( sCurrentVehiclePosition != sPlayerLocation )		
//		{
//			eStartNode = undefined;
//			switch ( sPlayerLocation )
//			{
//				case "left":
//					if ( isdefined(go_left_node) )
//						eStartNode = go_left_node;
//					break;
//				case "right":
//					if ( isdefined(go_right_node) )
//						eStartNode = go_right_node;
//					break;
//				case "mid":
//					if ( sCurrentVehiclePosition == "left" )
//						eStartNode = go_right_node;
//					if ( sCurrentVehiclePosition == "right" )
//						eStartNode = go_left_node;
//					break;
//			}
//		}


}

get_last_ent_in_chain( sEntityType )
{
	ePathpoint = self;
	while ( isdefined(ePathpoint.target) )
	{
		wait (0.05);
		if ( isdefined( ePathpoint.target ) )
		{
			switch ( sEntityType )
			{
				case "vehiclenode":
					ePathpoint = getvehiclenode( ePathpoint.target, "targetname" );
					break;
				case "pathnode":
					ePathpoint = getnode( ePathpoint.target, "targetname" );
					break;
				case "ent":
					ePathpoint = getent( ePathpoint.target, "targetname" );
					break;
				default:
					assertmsg("sEntityType needs to be 'vehiclenode', 'pathnode' or 'ent'");
			}			
		}
		else
			break;
	}		
	ePathend = ePathpoint;
	return ePathend;
}


AI_think(guy)
{
	/*-----------------------
	RUN ON EVERY DUDE THAT SPAWNS
	-------------------------*/		
	if (guy.team == "axis")
		guy thread AI_axis_think();
	
	if (guy.team == "allies")
		guy thread AI_allies_think();
}

AI_allies_think()
{
	self endon ("death");

	self.animname = "frnd";
	self thread AI_friendly_waittill_death();
	self thread magic_bullet_shield();
	self setFlashbangImmunity(true);

	/*-----------------------
	WHICH TEAM IS FRIENDLY ON
	-------------------------*/		
	if (isdefined(self.script_forcecolor))
	{
		switch (self.script_forcecolor)
		{
			case "r":
				level.team01 = array_add(level.team01, self);
				if (getdvar("debug_launch") == "1")
					self thread print3Dthread("Team 01");
				break;
			case "o":
				level.team01 = array_add(level.team01, self);
				if (getdvar("debug_launch") == "1")
					self thread print3Dthread("Wingman");
				break;
			case "y":
				level.team02 = array_add(level.team02, self);
				if (getdvar("debug_launch") == "1")
					self thread print3Dthread("Team 02");
				break;
			case "g":
				level.team03 = array_add(level.team03, self);
				if (getdvar("debug_launch") == "1")
					self thread print3Dthread("Team 03");
				break;
		}
	}

	/*-----------------------
	DAMAGE BEHAVIOR
	-------------------------*/		
	while (true)
	{
		self waittill ( "damage", damage, attacker );
		/*-----------------------
		EVERY TIME HIT, IGNORE ME FOR A WHILE
		-------------------------*/		
		self.ignoreme = true;
		wait (randomfloatrange(4,6));
		self.ignoreme = false;

	}
}

AI_friendly_waittill_death()
{
	self waittill ("death");

}

AI_axis_think()
{
	self endon ("death");
	self.animname = "hostile";
	self thread AI_axis_death();
	self thread AI_axis_player_distance();
	self thread AI_axis_sniper_fodder();
}

AI_axis_player_distance()
{
	self endon ("death");
	
	while (true)
	{
		wait(.25);
		if (level.snipersActive)
			continue;
		if (distancesquared(self.origin,level.player.origin) <= level.playerDistanceToAI)
			self notify ("close_to_player");
	}
}

AI_axis_sniper_fodder()
{
	self endon ("death");
	
	while (true)
	{
		/*-----------------------
		WAIT TILL IN RANGE, THEN CHECK
		-------------------------*/	
		self waittill("close_to_player");

		//Abort if enemy isn't player
		//if (self.enemy != level.player)
			//continue;

		//Abort if snipers already shooting	
		if (level.peoplespeaking)
			continue;
				
		if (level.snipersActive)
			continue;
	
		//Abort if AI not in designated volume
		//if (!self istouching(level.snipervolume))
			//continue;

		/*-----------------------
		SHOOT
		-------------------------*/					
		//Abort if can't get a clear shot
		targetTagOrigin = self gettagorigin ("TAG_EYE");
		for(i=0;i<level.aSniper_orgs.size;i++)
		{
			sniperCanShoot = bullettracepassed(level.aSniper_orgs[i].origin, targetTagOrigin, true, undefined);
			if (sniperCanShoot)
			{
				self thread sniper_execute(targetTagOrigin, level.aSniper_orgs[i]);
				break;
			}
		}
	}
}

sniper_execute(targetTagOrigin, eSniper_org)
{
	//self ==> the AI targeted for execution
	if (!isdefined(self))
		return;
	if (!isalive(self))
		return;
	if (level.snipersActive)	
		return;

	level.snipersActive = true;
	
	level.sniperTarget = self;
	level notify ("sniper_target_updated");
	/*-----------------------
	SNIPER SHOOTS AI
	-------------------------*/	
	level.sniperkills++;
	if (getdvar("debug_launch") == "1")
	{
		level notify ("stop_drawing_line");
		thread draw_line_until_notify(eSniper_org.origin, targetTagOrigin, 1, 0, 0, level, "stop_drawing_line");
		println("***Snipers have killed " + level.sniperkills + " enemies");
	}
	iBurst = randomintrange(1, 3);
	iBulletsFired = 0;
	while ( iBulletsFired < iBurst)
	{
		iBulletsFired++;
		if (iBulletsFired == 1)
			self doDamage (self.health + 1, self.origin);
		magicbullet("m14_scoped", eSniper_org.origin, targetTagOrigin);
		bullettracer (eSniper_org.origin, targetTagOrigin);
		//thread play_sound_in_space( "weap_m14sniper_fire_npc", self.origin );	
		self play_sound_on_entity("weap_m14sniper_fire_npc");
		
		if (iBulletsFired != iBurst)
			wait(randomfloatrange(.25, .75)); 	
	}
	
	wait(randomfloatrange(.75, 1.5));
	
	/*-----------------------
	RANDOM CONFIRM DIALOGUE
	-------------------------*/		
	level.dialogueSniperConfirm_number++;
	//randomly skip a line
	iRand = randomintrange(0,2);
	if (iRand == 0)
 		level.dialogueSniperConfirm_number++;
	if (level.dialogueSniperConfirm_number > level.dialogueSniperConfirm_MAX)
		level.dialogueSniperConfirm_number = 1;

	sDialogue = "launchfacility_a_sniper_confirm_0" + level.dialogueSniperConfirm_number;
	
	if (!level.peoplespeaking)
		radio_dialogue(sDialogue);

	/*-----------------------
	DON'T ALLOW ANY MORE SNIPER TILL INTERVAL EXPIRED
	-------------------------*/			
	wait (level.sniperInterval);
	
	level.snipersActive = false;

}

AI_axis_death()
{
	self waittill ("death", attacker);
	if (!isdefined (attacker))
			return;
	if (attacker == level.player)
	{
		level.axisKilledByPlayer++;
		if (getdvar("debug_launch") == "1")
			println("Player has killed " + level.axisKilledByPlayer + " enemies");
	}
}

AI_in_volume_chase_player()
{
	//self ==> the volume passed
	aHostiles = getaiarray( "axis" );
	for( i = 0 ; i < aHostiles.size ; i++ )
	{
		if ( aHostiles[i] istouching( self ) )
		{
			aHostiles[i].goalradius = 600;
			aHostiles[i] setgoalentity( level.player );		
		}
	}	
}

AI_chain_and_seek()
{
	self endon( "death" );
	self waittill( "reached_path_end" );
	self thread AI_player_seek();
}

AI_player_seek()
{
	self endon ("death");
	newGoalRadius = distance( self.origin, level.player.origin );
	for(;;)
	{
		wait 2;
		self.goalradius = newGoalRadius;
			
		self setgoalentity ( level.player );
		newGoalRadius -= 175;
		if ( newGoalRadius < 512 )
		{
			newGoalRadius = 512;
			return;
		}
	}
}

initPlayer()
{	
	level.player set_threatbiasgroup ("player");
	//level.player_location = undefined;
	aTrigger_player_location = getentarray( "trigger_player_location", "targetname" );
	//array_thread ( aTrigger_player_location, :: trigger_player_location_think);
}

initFriendlies(sStartPoint)
{
	waittillframeend;
	
	assert(isdefined(sStartPoint));
	level.squad = [];

	/*-----------------------
	PRICE AND GRIGSBY
	-------------------------*/	
	level.price = spawn_script_noteworthy( "price" );
	level.grigsby = spawn_script_noteworthy( "grigsby" );
	level.squad[0] = level.price;
	level.squad[1] = level.grigsby;
	level.otherSquadFriendly = undefined;

	/*-----------------------
	SPAWN FRIENDLIES
	-------------------------*/		
	switch ( sStartPoint )
	{
		case "default":
			level.friendly_at4 = spawn_script_noteworthy( "friendly_at4" );
			aFriendly_support = spawnGroup( getentarray("friendly_support", "script_noteworthy") );
			level.squad = array_merge( level.squad, aFriendly_support );
			break;
		case "container":
			level.friendly_at4 = spawn_script_noteworthy( "friendly_at4" );
			aFriendly_support = spawnGroup( getentarray("friendly_support", "script_noteworthy") );
			level.squad = array_merge( level.squad, aFriendly_support );
			break;
		case "gate":
			aFriendly_support = spawnGroup( getentarray("friendly_support", "script_noteworthy") );
			level.squad = array_merge( level.squad, aFriendly_support );
			break;
		case "tarmac":
			break;
		case "vents":
			aFriendly_support = spawnGroup( getentarray("friendly_support", "script_noteworthy") );
			level.squad = array_merge( level.squad, aFriendly_support );
			break;
		default:
			assertmsg("The startPoint ' " + sStartPoint + " ' is not valid");
	}



	/*-----------------------
	WARP HEROES TO CORRECT POSITIONS
	-------------------------*/		
	aFriendlies = level.squad;
	warpNodes = getnodearray("nodeStart_" + sStartPoint, "targetname");
	assertEx((isdefined(warpNodes)), "No nodes with targetname: nodeStart_" + sStartPoint);
	iKeyFriendlies = 0;
	playerNode = undefined;
	while (iKeyFriendlies < 3)
	{
		wait (0.05);
		for(i=0;i<warpNodes.size;i++)
		{
			if (isdefined(warpNodes[i].script_noteworthy))
			{
				switch (warpNodes[i].script_noteworthy)
				{
					case "nodePrice":
						level.price start_teleport ( warpNodes[i] );
						aFriendlies = array_remove(aFriendlies, level.price);
						warpNodes = array_remove(warpNodes, warpNodes[i]);
						iKeyFriendlies ++;
						break;
					case "nodeGrigsby":
						level.grigsby start_teleport ( warpNodes[i] );
						aFriendlies = array_remove(aFriendlies, level.grigsby);
						warpNodes = array_remove(warpNodes, warpNodes[i]);
						iKeyFriendlies ++;
						break;
					case "nodePlayer":
						playerNode = warpNodes[i];
						warpNodes = array_remove(warpNodes, warpNodes[i]);
						iKeyFriendlies ++;
						break;
				}
			}	
		}		
	}
	
	/*-----------------------
	WARP SUPPORT FRIENDLIES TO CORRECT POSITIONS
	-------------------------*/	
	if (aFriendlies.size > 0)
	{
		for(i=0;i<aFriendlies.size;i++)
		{
			assertEx((isdefined(warpNodes[i])), "May not be enough warp nodes for support friendlies for start name");
			aFriendlies[i] start_teleport ( warpNodes[i] );
		}		
	}
	

	/*-----------------------
	WARP PLAYER LAST SO HE DOESN'T SEE
	-------------------------*/			
	assert(isdefined(playerNode));	
	level.player setorigin ( playerNode.origin );
	level.player setplayerangles ( playerNode.angles );
	
	level.excludedAi[0] = level.price;
	level.excludedAi[1] = level.grigsby;
}

initPrecache()
{  
	//Objective strings
	precacheString(&"LAUNCHFACILITY_A_OBJ_GAIN_ACCESS");
	precacheString(&"LAUNCHFACILITY_A_OBJ_RAPPEL");
	precacheString(&"LAUNCHFACILITY_A_OBJ_NORTH_TARMAC");
	
	precacheItem("m14_scoped");
	precacheItem("rpg_player");
	precacheModel("weapon_c4_obj");
	precacheModel("viewmodel_base_fastrope_character");
	
	precacheString(&"LAUNCHFACILITY_A_DEBUG_LEVEL_END");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_SMOKE");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_RAPPEL");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_RAPPEL_DOWN_SHAFT");
	
}


vehicle_path_disconnector()
{
	zone = getent( self.target, "targetname" );
	assert( isdefined( zone ) );
	zone notsolid();
	zone.origin -= ( 0, 0, 1024 );
	
	for(;;)
	{
		self waittill( "trigger", tank );
		assert( isdefined( tank ) );
		assert( tank == level.abrams );
		
		if ( !isdefined( zone.pathsDisconnected ) )
		{
			zone solid();
			zone disconnectpaths();
			zone notsolid();
			zone.pathsDisconnected = true;
		}
		
		thread vehicle_reconnects_paths( zone );
	}
}

vehicle_reconnects_paths( zone )
{
	zone notify( "waiting_for_path_reconnection" );
	zone endon( "waiting_for_path_reconnection" );
	wait 0.5;
	
	// paths get reconnected
	zone solid();
	zone connectpaths();
	zone notsolid();
	zone.pathsDisconnected = undefined;
}