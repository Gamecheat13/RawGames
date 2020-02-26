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
	
	level.hindAttacker = undefined;
	level.peoplespeaking = false;
	level.team01breacher = undefined;
	level.team02breacher = undefined;
	level.team03breacher = undefined;
	level.sniperkills = 0;
	level.sniperConfirmDialogue = true;
	level.sniperTarget = undefined;
	level.sniperInterval = 5;
	level.snipersActive = false;
	level.playerMaxDistanceToBMPC4 = 128;
	level.playerMaxDistanceToBMPC4squared = level.playerMaxDistanceToBMPC4 * level.playerMaxDistanceToBMPC4;
	level.playerMaxDistanceFromBMP = 1024;
	level.playerMaxDistanceFromBMPsquared = level.playerMaxDistanceFromBMP * level.playerMaxDistanceFromBMP;
	level.playerDistanceToAI = 256;
	level.playerDistanceToAIsquared = level.playerDistanceToAI * level.playerDistanceToAI;
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
	level.cosine["35"] = cos(35);
	level.cosine["45"] = cos(45);
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
	maps\_bm21::main("vehicle_bm21_mobile");
	maps\_bmp::main("vehicle_bmp");
	maps\_mig29::main( "vehicle_mig29_desert" );
	maps\_blackhawk::main("vehicle_blackhawk");
	maps\launchfacility_a_anim::main();
	maps\_c4::main();
	maps\_load::main();
	//maps\_compass::setupMiniMap("compass_map_launchfacility_a");
	level thread maps\launchfacility_a_amb::main();	

	/*-----------------------
	FLAGS
	-------------------------*/		
	flag_init("bmp_02_spawned");
	flag_init("bmp_03_spawned");
	flag_init("bmp_04_spawned");
	
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
	flag_init("friendly_shoots_down_heli");
	flag_init("enemy_can_blow_up_truck");
	flag_init("hind_intro_dialogue");
	flag_init("friendlies_past_killzone");
	flag_init("stop_alarm");
	flag_init("hind_crash");
	flag_init("heli_attractor_deleted");
	flag_init("flanking_wall_breached");
	flag_init("blow_the_gate");
	flag_init("bmp_02_destroyed");
	flag_init("gate_sequence_starting");
	flag_init("migs_flyby1");
	flag_init("migs_flyby2");
	
	//tarmac
	flag_init("bmp_03_destroyed");
	flag_init("bmp_04_destroyed");
	flag_init("one_bmp_left");
	
	//vents
	flag_init("hinds_appear");
	flag_init("hind_rocket_sequence");
	flag_init("hind_missiles_fired");
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
	initDifficulty();
	initPlayer();
	vehicle_patrol_init();
	disable_color_trigs();
	hideAll();
	launch_lid_setup();
	thread migs_flyby1();
	thread migs_flyby2();
	thread sniper_activity();
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	
	array_thread( getentarray( "hostiles_container_runners", "script_noteworthy" ), ::add_spawn_function, ::AI_chain_and_seek );
	array_thread( getentarray( "hostiles_player_seek", "script_noteworthy" ), ::add_spawn_function, ::AI_player_seek );
	array_thread( getentarray( "hostiles_vehicle_support", "script_noteworthy" ), ::add_spawn_function, ::AI_vehicle_support );
	array_thread( getentarray( "enemy_rpd", "script_noteworthy" ), ::add_spawn_function, ::AI_enemy_RPD );
	//array_thread( getentarray( "vehicle_path_disconnector", "targetname" ), ::vehicle_path_disconnector );
	
	aVehicles_BMP_targetnames = [];
	aVehicles_BMP_targetnames[0] = "bmp_02"; 
	aVehicles_BMP_targetnames[1] = "bmp_03"; 
	aVehicles_BMP_targetnames[2] = "bmp_04"; 
	thread vehicle_bmp_setup( aVehicles_BMP_targetnames );
	thread vehicle_truck_setup();
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

	//thread truck_blows_up();
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
	//thread music_intro();
	//thread music_end();
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
	//thread heli_flyby_intro();
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
	level endon ("exit_container_area");
	
	flag_wait ("reach_container_area");
	flag_wait("heli_attractor_deleted");
	volume_containers = getent("volume_containers", "targetname");
	aRpgSources = getentarray("rpg_source", "targetname");
	assert(isdefined(aRpgSources));
	aRpgTargets = getentarray("rpg_target", "targetname");
	assert(isdefined(aRpgTargets));
	wait (2);

	thread rpg_ambient(aRpgSources, aRpgTargets, 2);
	wait (randomfloatrange(10, 20));
				
	while (true)
	{
		wait (0.5);
		while (!level.player istouching(volume_containers))
		{
			iRand = randomintrange(1, 3);
			thread rpg_ambient(aRpgSources, aRpgTargets, iRand);
			wait (randomfloatrange(10, 20));
		}
	}
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
	waittillframeend;
	
	level.grigsby delayThread( 0, ::anim_single_solo, level.grigsby, "spin" );
	//friendly2 delayThread( 1.5, ::anim_single_solo, friendly2, "spin" );
	
	flag_set("obj_gain_access_given");
	//Loudspeaker
	//"Facility perimeter has been compromised. All units proceed to defensive positions. Unknown enemy force moving in from the South or West. Facility is now on high alert."	
	//thread dialogue_loudspeaker("launchfacility_a_loudspeaker_01");

	level.peoplespeaking = true;
	
	//HQ Radio
	//"Bravo Six, we're picking up heavy activity inside the facility. Enemy air is running search patterns. What's your status over?"	
	level radio_dialogue_queue("launchfacility_a_hqradio_activity");

	//Price
	//"Status is TARFU and we're workin' on it, out!"
	level.price dialogue_execute("launchfacility_a_price_tarfu");

	//Price
	//"All right our cover’s blown! Grenier! Prep the AT4!"
	level.price dialogue_execute("launchfacility_a_price_at4_prep");	
	

	//Marine 01
	//"Roger that. Last round sir."
	radio_dialogue("launchfacility_a_marine_01_at4_prep");		

	
	level.peoplespeaking = false;
	
	flag_wait("hind_intro_dialogue");
	guy = get_closest_ally();
	
	level.peoplespeaking = true;
	
	//Marine 01
	//"Hind!!! 12 o'clock high!!!"	
	//guy dialogue_execute("launchfacility_a_marine1_chopper");

	battlechatter_on( "allies" );
	
	wait (3);
	//Price
	//"Go go go!!!"
	level.price dialogue_execute("launchfacility_a_price_gogogo1");
	
	//Sniper team
	//"Bravo Six, Sniper Team Two is now in position.  We'll give ya sniper cover and recon from where we are, over."
	level radio_dialogue_queue("launchfacility_a_recon_sniperteamtwo");
	
	//Price
	//"Copy!!! Keep us posted!!! Out!!!!"
	level.price dialogue_execute("launchfacility_a_price_keepposted");	

	level.peoplespeaking = false;
	
	wait(5);
	
	thread dialogue_smoke_hints();
	
}

dialogue_smoke_hints()
{
	flag_wait("bmp_02_spawned");
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

			//Sniper team
			//"This is Sniper Team Two. You've got hostiles and light armor coming to you from the north. Suggest you get some C4 out there or find some heavy weapons, over."
			level radio_dialogue_queue("launchfacility_a_recon_enemiestonorth");	
	
		}
	
		else if (iNags == 2)
		{

			//Price
			//"Throw some smoooke!!!!"
			level.price dialogue_execute("launchfacility_a_price_smoke_nag_01");

		}

		else if (iNags == 3)
		{

			//Grigsby
			//"We gotta cover our advaaaance! Everyone pop smooooke!"
			level.grigsby dialogue_execute("launchfacility_a_grigsby_smoke_nag_01");

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
	flag_wait("bmp_02_spawned");
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
			//Price
			//"Jackson! Get a C4 charge on that BMP!!!"
			level.price dialogue_execute("launchfacility_a_price_bmp_nag_01");

		}
		else if (iNags == 2)
		{
			//Price
			//"We gotta take out that BMP! Use your C4!"
			level.price dialogue_execute("launchfacility_a_price_bmp_nag_02");		
		}
		else
			break;
		
		thread hint(&"LAUNCHFACILITY_A_HINTSTR_C4_EQUIP", 7);
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



fireMG(iBurstNumber, fZoffset, eTargetEnt)
{
	self endon ("death");

	if (!isdefined(eTargetEnt))
		eTargetEnt = level.player;	
	
	if (!isdefined(fZoffset))
		fZoffset = 0;

	self setturrettargetent(eTargetEnt, (0, 0, fZoffset));
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


reach_container_area()
{
	flag_wait ("reach_container_area");
	thread autosave_by_name( "container" );
	
	wait (2);
	//Loudspeaker
	//"We are under attack! Lock down all points of entry immediately."
	//thread dialogue_loudspeaker("launchfacility_a_loudspeaker_02");
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

	org = level.friendly_at4 gettagorigin( "TAG_WEAPON_RIGHT" );
	magicbullet( "rpg_player", org, level.eHindIntro.origin );	

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
	level.eHindIntro endon ("death");
	wait(3.75);
	level.eHindIntro notify ("death");
}

hind_intro_think()
{
	level.eHindIntro = spawn_vehicle_from_targetname("hind_intro_flyby_01");
	level thread maps\_vehicle::gopath(level.eHindIntro);
	//sTag = "tag_missile_right";
	sTag = "tag_origin";
	targetOrg = spawn("script_origin", level.eHindIntro gettagorigin(sTag));
	targetOrg linkto(level.eHindIntro, sTag);
	if (getdvar("debug_launch") == "1")
		targetOrg thread print3Dthread("TARGET");
	
	wait(3.5);
	level.eHindIntro thread fireMG(randomintrange(14, 17), 80);

	wait (2);
	
	
	
	wait (2);
	hind_intro_target2 = getent("hind_intro_target2", "targetname");
	level.eHindIntro thread fireMG(randomintrange(20, 24), 80, hind_intro_target2);
	wait(1);
	flag_set("hind_intro_dialogue");

	wait (5);
	
	/*-----------------------
	HIND STARTS CRASH SEQUENCE
	-------------------------*/
	//flag_wait("player_near_intro_heli_sequnce");
	
	flag_set( "friendly_shoots_down_heli" );
	level.eHindIntro thread hind_crash_failsafe();
	wait(1);
	attractor = missile_createAttractorEnt( targetOrg, 100000, 60000 );
	
	wait(1);
	level.eHindIntro thread fireMG(15, 80);
	level.eHindIntro waittill("death");
	missile_deleteAttractor(attractor);
	flag_set("heli_attractor_deleted");	

	/*-----------------------
	END OLD CRASH SEQUENCE
	-------------------------*/	
	level.eHindIntro waittill("crash_done");
	flag_set("hind_crash");
	flag_set("stop_alarm");
	
	wait(.5);
	hind_crash = getent("hind_crash", "targetname");
	playfx ( getfx("hind_explosion"), hind_crash.origin);
	earthquake (0.6, 2, hind_crash.origin, 2000);
	thread play_sound_in_space( "building_explosion1", hind_crash.origin );
	hind_crash thread play_sound_in_space("vehicle_fire");
}

hind_intro_think2()
{
	hind_crash = getent("hind_crash", "script_noteworthy");
	level.eHindIntro = maps\_vehicle::waittill_vehiclespawn( "hind_intro" );
	level.eHindIntro setmaxpitchroll(50,30);
	level.eHindIntro setspeed(120, 15, 15);
	//crash_path = getent("crash_path", "script_noteworthy");
	
	wait(1);
	flag_set("hind_intro_dialogue");
	wait(.5);
	
	level.eHindIntro thread fireMG(15, 80);
	
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
	physicsExplosionSphere( org, 356, 128, 14 );
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
	//thread autosave_by_name( "exit_container" );
	volume = getent("volume_containers", "targetname");
	volume thread AI_in_volume_chase_player();
	thread truck_blows_up();
	thread left_gate_nag();
}

left_gate_nag()
{
	level endon ("obj_gain_access_complete");
	flag_wait("bmp_02_destroyed");
	volume_leftgate = getent("volume_leftgate", "script_noteworthy");
	while (true)
	{
		wait(randomfloatrange(25, 40));
		if (level.player istouching(volume_leftgate))
		{
			level.dialogueGateHint_number++;
			if (level.dialogueGateHint_number > level.dialogueGateHint_MAX)
				level.dialogueGateHint_number = 1;

			sDialogue = "launchfacility_a_gate_hint_0" + level.dialogueGateHint_number;
			level radio_dialogue_queue(sDialogue);	
		}

	}
}

truck_blows_up()
{
	level endon ("right_gate_approach");
	flag_wait("bmp_02_destroyed");
	flag_wait("truck_approach");
	flag_set("enemy_can_blow_up_truck");

	playerEye = level.player getEye();
	truck = getent("truck_troops_perimeter", "script_noteworthy");
	while (flag("enemy_can_blow_up_truck"))
	{
		if (!isdefined(truck))
			return;	
		qInFOV = within_fov(playerEye, level.player getPlayerAngles(), truck.origin, level.cosine["45"]);
		if (qInFOV)
			break;
		wait (0.05);
	}		
	if (!isdefined(truck))
		return;	
	
	guy = get_closest_ally();
	if (isdefined(guy))
		guy thread play_sound_on_entity("US_bra_threat_rpg");
		
	rpgorg = getent("rpg_source_right_1", "script_noteworthy");
	truck_rpg_target = getent("truck_rpg_target", "targetname");
	attractorRPG = missile_createAttractorEnt(truck_rpg_target, 10000, 6000 );
	magicbullet("rpg", rpgorg.origin, truck_rpg_target.origin);
	wait(3);
	missile_deleteAttractor(attractorRPG);
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
	
	
	while(level.peoplespeaking)
		wait(0.5);
	
	level.peoplespeaking = true;
	//HQ radio
	//"Bravo Six, this is command, gimme a sit-rep over."
	level radio_dialogue_queue("launchfacility_a_cmd_sitrep");
	
	//Price
	//"We're inside the perimeter, approaching the gates to the silos!!! Out!!!"
	level.price dialogue_execute("launchfacility_a_price_were_inside");	
	
	level.peoplespeaking = false;
	
	wait(1.5);
	//Loudspeaker
	//"Enemy units confirmed to be American special forces. Exercise extreme caution. Red Spetznaz units are en route to intercept."	
	//thread dialogue_loudspeaker("launchfacility_a_loudspeaker_03");
	
}

gate_left_approach()
{
	flag_wait("reached_left_gate");
	if (getdvar("debug_bmp") == "1")
		println("REACHED LEFT GATE");
	//thread autosave_by_name("left_gate");

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
	
	flag_set("migs_flyby1");
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
	org = getent("gate_explosives", "targetname");
	thread play_sound_in_space( "explo_metal_rand", org.origin );
	radiusdamage( org.origin, 256, 200, 50);
	earthquake (0.6, 1, org.origin, 2000);
	
	/*-----------------------
	MOVE INTO NEXT AREA
	-------------------------*/	
	disable_color_trigs();
	triggersEnable("colornodes_tarmac_front", "script_noteworthy", true);
	triggersEnable("colornodes_tarmac_rear", "script_noteworthy", true);
	triggersEnable("colornodes_tarmac_always_on", "script_noteworthy", true);
	
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

explosives_warning(sFlagToDisplay, sFlagToKill)
{
	level endon (sFlagToKill);
	flag_wait(sFlagToDisplay);
	iprintlnbold(&"LAUNCHFACILITY_A_HINTSTR_EXPLOSIVES_PLANTED");
}

explosives_warning2(sFlagToDisplay, sFlagToKill)
{
	level endon (sFlagToKill);
	thread explosives_warning_cleanup(sFlagToKill);
	
	while (true)
	{
		wait (0.05);
		while (flag(sFlagToDisplay))
		{
			thread hint (&"LAUNCHFACILITY_A_HINTSTR_EXPLOSIVES_PLANTED", 9999);
			if (flag(sFlagToDisplay))
				wait(.25);
		}
		thread hint_fade();
	}
}

explosives_warning_cleanup(sFlagToKill)
{
	flag_wait(sFlagToKill);
	thread hint_fade();
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
	
	org = getent("gate_explosives", "targetname");
	assert(isdefined(org));
	c4_model = spawn( "script_model", org.origin);
	c4_model setmodel( "weapon_c4" );
	c4_model.angles = org.angles;
	
	eNode anim_single_solo(self, "C4_plant");
	
	//Marine 02
	//"Charges set!!!!! Get back get back!!!"
	self thread dialogue_execute("launchfacility_a_marine2_gate_getback");	
	
	//thread explosives_warning("player_near_right_gate", "blow_the_gate");
	
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
	c4_model delete();
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
	
	wait (4);
	flag_set("migs_flyby2");
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
	//thread dialogue_loudspeaker("launchfacility_a_loudspeaker_04");
	
	flag_set("player_near_launchtube_03");
	wait(2);
	flag_set("player_near_launchtube_04");
	wait (1);

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
	ACTIVATE THE MIDDLE COLORNODES NEAREST TO PLAYER
	-------------------------*/	
	colornode_triggers = getentarray("colornodes_tarmac_bmp_03_dead", "script_noteworthy");
	eTrigger = getclosest(level.player.origin, colornode_triggers);
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
	ACTIVATE THE MIDDLE COLORNODES NEAREST TO PLAYER
	-------------------------*/	
	colornode_triggers = getentarray("colornodes_tarmac_bmp_04_dead", "script_noteworthy");
	eTrigger = getclosest(level.player.origin, colornode_triggers);
	eTrigger notify ("trigger", level.player);
}

proceed_to_vents()
{
	flag_wait ("obj_enemy_armor_complete");
	thread AA_vents_init();
	aAI_to_delete = getaiarray("axis");
	thread AI_delete_when_out_of_sight(aAI_to_delete, level.AIdeleteDistance);
	
	
	
	flag_set("player_near_launchtube_06");
	wait(2);
	flag_set("player_near_launchtube_05");	
}

/****************************************************************************
    LEVEL START: VENTS
****************************************************************************/

AA_vents_init()
{
	thread blackhawk_arrive();
	thread vents_friendly_movement();
	thread hind_rocket_sequence();
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
	level radio_dialogue("launchfacility_a_friendlies_east");
	
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
	
	
	aStrikeTeamThree = eBlackhawk.riders;
	array_thread(aStrikeTeamThree, ::AI_friendly_reinforcements_think, eBlackhawk);
	eBlackhawk waittill("unload");
	
	flag_set("breach_the_vents");
	
	wait (11);
	
	/*-----------------------
	BLACKHAWK LEAVES
	-------------------------*/	
	eBlackhawk_depart_path = getstruct("blackhawk_depart_path", "script_noteworthy");
	eBlackhawk vehicle_detachfrompath();
	eBlackhawk thread vehicle_dynamicpath(eBlackhawk_depart_path, false ); 	
	

}

AI_friendly_reinforcements_think(eVehicle)
{
	self endon ("death");


	self.ignoreme = true;
	
	wait(.5);
	if ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "pilot") )
			self notify ("stop magic bullet shield");
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
	level thread radio_dialogue_queue("launchfacility_a_marine3_teamin");	
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
	level thread radio_dialogue_queue("launchfacility_a_marine2_rappelling");
	
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
	level thread radio_dialogue_queue("launchfacility_a_price_inside_facility");	
	
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
	assert(isdefined(aAttackPointsHigher));
	assert(isdefined(aAttackPointsLower));
	
	wait (1.5);
	thread hind_attack_think(aAttackPointsHigher, "hind_end_higher");
	thread hind_attack_think(aAttackPointsLower, "hind_end_lower");

	level.peoplespeaking = true;
	
	thread autosave_by_name("hinds_closing");	
	
	//Sniper team
	//"Bravo Six, Two Hinds closing fast on your position. You gotta get outta sight, now!"
	level radio_dialogue_queue("launchfacility_a_recon_two_helis");
	
	level.peoplespeaking = false;
	
	wait(4.6);
	
	flag_set("hind_rocket_sequence");
	
}

hind_rocket_sequence()
{
	flag_wait("hind_rocket_sequence");

	/*-----------------------
	VARIABLE SETUP
	-------------------------*/		
	eTarget = getent("rocket_target", "targetname");
	eDamageTrig = getent("rocket_damage", "targetname");
	eDamageTrig thread hind_tree_explosion();
	eDamageTrig thread hind_tree_fx(eTarget);
	
	//level.hindAttacker settargetyaw(<yaw>)
	level.hindAttacker setLookAtEnt(eTarget);
	
	iPrintlnbold("INCOMING!!!");

	flag_set("team03_go");	
	wait (.5);
	
	level.hindAttacker maps\_helicopter_globals::fire_missile( "ffar_hind_nodamage", 2, eTarget, .75);
	
	wait(.5);
	//cleartargetyaw();
	level.hindAttacker clearLookAtEnt();
	

	
	wait(3);
	flag_set("hind_missiles_fired");
}

hind_tree_explosion()
{
	level endon ("hind_missiles_fired");
	eTarget = getent("rocket_target", "targetname");

	while (true)
	{
		self waittill ("damage", amount, attacker);
		if (attacker == level.player)
			continue;
		iRand = randomIntRange(1, 4);
		thread play_sound_in_space( "building_explosion" + iRand, eTarget.origin);
		earthquake (0.8, 2, eTarget.origin, 2000);
		fRand = randomfloatrange(0, 150);
		playfx ( getfx("hind_explosion"), eTarget.origin + (fRand, 0, 0));			
	}
}

hind_tree_fx(eTarget)
{
	self waittill ("damage", amount, attacker);
	if (attacker == level.player)
		return;
	thread hind_trees_fall();
	aFireOrgs = getentarray("tree_fire", "targetname");
	assertEx(aFireOrgs.size <= level._effect["tree_fire_fx"].size, "There are more 'tree_fire' script_origins than there are 'tree_fire_fx' to play on them");
	for(i=0;i<aFireOrgs.size;i++)
	{
		playfx ( level._effect["tree_fire_fx"][i], aFireOrgs[i].origin);
	}
	
	eTarget thread play_sound_in_space("medfire");
}

hind_trees_fall()
{
	aTrees = getentarray("trees_end", "script_noteworthy");
	minAngles = 18;
	maxAngles = 35;
	for(i=0;i<aTrees.size;i++)
	{
		fRotateTime = randomfloatrange(.5, 1.5);
		ang = aTrees[i].angles;
		ang += (randomfloatrange(minAngles, maxAngles),randomfloatrange(minAngles, maxAngles),randomfloatrange(minAngles, maxAngles));
		aTrees[i] thread hind_tree_rotate(ang, fRotateTime);
		//wait (randomfloatrange(.25, .8));
	}
}

hind_tree_rotate(ang, fRotateTime)
{
	self rotateto(ang, fRotateTime, fRotateTime/2, fRotateTime/2);
}

hind_go_to_vent()
{
	if (!isdefined(self))
		return;

	flag_wait("obj_rappel_complete");
	org = getent("hind_above_vent", "targetname");
	assert(isdefined(org));
	self clearLookAtEnt();
	self setspeed(200, 15, 15);
	self setvehgoalpos(org.origin, true);
}

hind_attack_think(aAttackPoints, sTargetname)
{
	level endon ("obj_rappel_complete");
	eHind = spawn_vehicle_from_targetname(sTargetname);
	
	if ( (isdefined(eHind.script_noteworthy)) && (eHind.script_noteworthy == "hind_rocket_attacker") )
		level.hindAttacker = eHind;
		
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
	flag_wait("hind_missiles_fired");
	while (true)
	{
		wait (randomfloatrange(2, 5));
		self thread fireMG(randomintrange(8, 17));
		wait (randomfloatrange(2, 5));
	}
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

initDifficulty()
{
	/*-----------------------
	SETUP VARIABLES
	-------------------------*/		
	skill = getdifficulty();
	level.skill = undefined;
	switch( skill )
	{
		case "gimp":
		case "easy":
			level.skill = "easy";
			break;
		case "medium":
			level.skill = "medium";
			break;
		case "hard":
		case "difficult":
			level.skill = "hard";
			break;
		case "fu":
			level.skill = "veteran";
			break;
	}
	
	/*-----------------------
	DELETE EASY WEAPON CACHES
	-------------------------*/	
	easyWeapons = getentarray("gameskill_easy", "script_noteworthy");
	assertEx((isdefined(easyWeapons)), "No weapons found with script_noteworthy 'gameskill_easy'");
	mediumWeapons = getentarray("gameskill_medium", "script_noteworthy");
	assertEx((isdefined(easyWeapons)), "No weapons found with script_noteworthy 'gameskill_medium'");
	switch( level.skill )
	{
		case "medium":
			array_thread (easyWeapons, ::deleteWeapons);
			break;
		case "hard":
		case "veteran":
			array_thread (easyWeapons, ::deleteWeapons);
			array_thread (mediumWeapons, ::deleteWeapons);
			break;
	}
}

deleteWeapons()
{
	if (isdefined(self))
		self delete();
}

migs_flyby1()
{
	flag_wait("migs_flyby1");
	trigger_migs_intro = getent("trigger_migs_intro", "script_noteworthy");
	trigger_migs_intro notify ("trigger", level.player);	
}

migs_flyby2()
{
	flag_wait("migs_flyby2");
	trigger_migs_end = getent("trigger_migs_end", "script_noteworthy");
	trigger_migs_end notify ("trigger", level.player);	
}

sniper_activity()
{
	level.aSniper_orgs = getentarray("sniper_position_container", "targetname");
	flag_wait ("obj_gain_access_complete");
	level.aSniper_orgs = getentarray("sniper_position_tarmac", "targetname");
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
	playfx (level._effect["launchtube_steam"], eLidFxEnt.origin);

	eLidFxEnt waittill ("sounddone");

	/*-----------------------
	BADPLACE
	-------------------------*/	
	//eBadplace = getent("badplace_lid_" + iTubeNumber, "targetname");
	//assertEx((isdefined(eBadplace)), "There is no volume with targetname badplace_lid_" + iTubeNumber);
	//badplace_brush("badplace_lid_volume" + iTubeNumber, 0, eBadplace, "allies", "axis");
	badplace_cylinder("badplace_lid_volume" + iTubeNumber, 0, eAnimEnt.origin, 225, 512, "axis", "allies");
	
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
			iEntityNumber = bmp getentitynumber();	
			bmp thread vehicle_death(iEntityNumber);
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
	
	self thread obj_enemy_armor_vehicle_death(index);
	self thread obj_enemy_armor_vehicle_position(index);
}

obj_enemy_armor_vehicle_death(index)
{
	self waittill ("death");
	level.enemyArmor = array_remove(level.enemyArmor, self);
	waittillframeend;
	objective_additionalposition(10, index, (0,0,0));	
	
	if (level.enemyArmor.size == 0)
	{
		flag_set ("obj_enemy_armor_complete");
		objective_state(10, "invisible");		
	}

	objective_string(10,  &"LAUNCHFACILITY_A_OBJ_ENEMY_ARMOR", level.enemyArmor.size);	

}

obj_enemy_armor_vehicle_position(index)
{
	self endon ("death");
	
	while (true)
	{
		wait(0.05);
		objective_additionalposition(10, index, self.origin);
	}
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

vehicle_truck_setup()
{
	aTrucks = getentarray("truck_troops", "targetname");
	for(i=0;i<aTrucks.size;i++)
		aTrucks[i] thread vehicle_truck_think();
}

vehicle_truck_think()
{
	self endon ("death");
	
	self truck_death_think();
	
}

truck_death_think()
{
	self endon ("death");
	iProjectileHits = 0;
	
	while (true)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		
//		if ( (isdefined(attacker)) && (isdefined(attacker.team)) && (attacker.team == "axis") )
//		{
//			if (!flag("enemy_can_blow_up_truck"))
//				continue;
//		}
		if ( (isdefined(attacker)) && (attacker != level.player) )
		{
			if (!flag("enemy_can_blow_up_truck"))
				continue;
		}
		
		if ( !isdefined( damage ) )
			continue;
		if ( damage <= 0 )
			continue;
		type = getDamageType( type );
		assert( isdefined( type ) );

		if ( type == "rocket" )
		{
			if (damage >= 300)
				break;
		}
		else if ( type == "c4" )
		{
			if (damage >= 250)
				break;
		}
		else
			continue;
	}

	thread play_sound_in_space( "building_explosion3", self.origin);
	earthquake (0.6, 2, self.origin, 2000);	
	self notify ("death");
}

vehicle_bmp_think( sTargetname )
{
	eVehicle = maps\_vehicle::waittill_vehiclespawn( sTargetname );
	flag_set(sTargetname + "_spawned");
	
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
	iEntityNumber = self getentitynumber();	
	iProjectileHits = 0;
	qDestroyedByRpg = false;
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
				{
					qDestroyedByRpg = true;
					break;
				}
					
			}
		}
		if ( type == "c4" )
		{
			if (damage >= 250)
				break;
		}
	}
	if (qDestroyedByRpg)
		thread bmp_death_dialogue();
	
	self thread vehicle_death(iEntityNumber);

}

bmp_death_dialogue()
{
	wait (1);
	/*-----------------------
	RANDOM RPG KILL DIALOGUE
	-------------------------*/
	level.dialogueRpgGoodShot_number++;
	if (level.dialogueRpgGoodShot_number > level.dialogueRpgGoodShot_MAX)
		level.dialogueRpgGoodShot_number = 1;

	sDialogue = "launchfacility_a_rpg_kill_0" + level.dialogueRpgGoodShot_number;
	
	if (!level.peoplespeaking)
	{
		level.peoplespeaking = true;
		level radio_dialogue(sDialogue);	
		level.peoplespeaking = false;
	}

}

vehicle_smoke()
{
	wait(1);
	/*-----------------------
	RANDOM RPG FIRST HIT DIALOGUE
	-------------------------*/
	level.dialogueRpgHit_number++;
	if (level.dialogueRpgHit_number > level.dialogueRpgHit_MAX)
		level.dialogueRpgHit_number = 1;

	sDialogue = "launchfacility_a_rpg_hit_0" + level.dialogueRpgHit_number;
	if (!level.peoplespeaking)
	{
		level.peoplespeaking = true;
		level radio_dialogue(sDialogue);	
		level.peoplespeaking = false;
	}

	/*-----------------------
	BMP STARTS SMOKING
	-------------------------*/
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
		case "mod_explosive":
		case "mod_explosive_splash":
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

	iEntityNumber = self getentitynumber();
	rearOrgOffset = (0, -33, 10);
	rearAngOffset = (0, 90, -90);
	frontOrgOffset = (129, 0, 35);
	frontAngOffset = (0, 90, 144);	
	
	self maps\_c4::c4_location( "rear_hatch_open_jnt_left", rearOrgOffset,  rearAngOffset);
	self maps\_c4::c4_location( "tag_origin", frontOrgOffset, frontAngOffset );
	self.rearC4location = spawn("script_origin", self.origin);
	self.frontC4location = spawn("script_origin", self.origin);
	self.rearC4location linkto(self, "rear_hatch_open_jnt_left", rearOrgOffset, rearAngOffset);
	self.frontC4location linkto(self, "tag_origin", frontOrgOffset, frontAngOffset);
	if (getdvar("debug_launch") == "1")
	{
		self.frontC4location thread print3Dthread("Front");
		self.rearC4location thread print3Dthread("Back");
	}
	self waittill( "c4_detonation" );

	self.frontC4location delete();
	self.rearC4location delete();
	
	/*-----------------------
	C4 STUNS AI CLOSEBY
	-------------------------*/			
	AI = get_ai_within_radius(512, self.origin, "axis");
	if ( (isdefined(AI)) && (AI.size > 0) )
		array_thread(AI, ::AI_stun, .75);

	self thread vehicle_death(iEntityNumber);
}

vehicle_death(iEntityNumber)
{
	self notify("clear_c4");
	setplayerignoreradiusdamage(true);

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
		eVehicle.enemyvolume = eGoalVolume;
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
	
	wait(0.05);
	//go to whatever volume the tank is in
	if (isdefined(eVehicle.enemyvolume))
			self set_goalvolume(undefined, eVehicle.enemyvolume);
	
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

AI_enemy_RPD()
{
	self endon ("death");
	//self.providecoveringfire = true;
	
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
		

		/*-----------------------
		GET LAST NODE IN CHAIN (CURRENT POSITION
		-------------------------*/	
		assert(isdefined(ePathstart));
		eCurrentNode = ePathstart get_last_ent_in_chain("vehiclenode");


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
		IF PLAYER IS RIGHT BEHIND/IN FRONT, TRY TO RUN HIM OVER/RETREAT
		-------------------------*/			
		if ( !isdefined( eStartNode ) )
		{
			if (distancesquared(self.rearC4location.origin,level.player.origin) <= level.playerMaxDistanceToBMPC4squared)
			{
				if (isdefined(go_right_node))
					eStartNode = go_right_node;
				else if (isdefined(go_left_node))
					eStartNode = go_left_node;
			}

			else if (distancesquared(self.frontC4location.origin,level.player.origin) <= level.playerMaxDistanceToBMPC4squared)
			{
				if (isdefined(go_left_node))
					eStartNode = go_left_node;
				else if (isdefined(go_right_node))
					eStartNode = go_right_node;
			}

		}

		
				
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
		prof_begin("sniper_activity");
		if (distancesquared(self.origin,level.player.origin) <= level.playerDistanceToAIsquared)
			self notify ("close_to_player");
		prof_end("sniper_activity");
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

		//Abort if people speaking
		if (level.peoplespeaking)
			continue;
		
		//Abort if snipers already shooting	
		if (level.snipersActive)
			continue;
			
		//if (!level.player islookingat(self))
			//continue;

		//Abort if AI not in designated volume
		//if (!self istouching(level.snipervolume))
			//continue;
		
		//Abort if player can't see
		playerEye = level.player getEye();
		targetTagOrigin = self gettagorigin ("TAG_EYE");
		
		prof_begin("sniper_activity");
		qInFOV = within_fov(playerEye, level.player getPlayerAngles(), targetTagOrigin, level.cosine["35"]);
		prof_end("sniper_activity");
		
		if (!qInFOV)
			continue;
		
		prof_begin("sniper_activity");
		playerCanSee = sighttracepassed(playerEye, targetTagOrigin, false, undefined);
		prof_end("sniper_activity");
		
		if (!playerCanSee)
			continue;
		
		
		/*-----------------------
		SHOOT
		-------------------------*/					
		//Abort if can't get a clear shot
		targetTagOrigin = self gettagorigin ("TAG_EYE");
		if (getdvar("debug_launch") == "1")
			self thread print3Dthread("target");
		for(i=0;i<level.aSniper_orgs.size;i++)
		{
			prof_begin("sniper_activity");
			sniperCanShoot = sighttracepassed(level.aSniper_orgs[i].origin, targetTagOrigin, true, self);
			prof_end("sniper_activity");
			
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
			playfxontag(getfx("headshot"), self, "tag_eye");	
		magicbullet("m14_scoped", eSniper_org.origin, targetTagOrigin);
		bullettracer (eSniper_org.origin, targetTagOrigin, true);
		thread play_sound_in_space( "weap_m82sniper_fire_npc", level.player.origin );	
		
		if (iBulletsFired != iBurst)
			wait(randomfloatrange(.25, .75)); 	
	}
	
	wait(randomfloatrange(.75, 1.5));
	
	/*-----------------------
	RANDOM CONFIRM DIALOGUE
	-------------------------*/
	if (level.sniperConfirmDialogue)
	{
		level.dialogueSniperConfirm_number++;
		if (level.dialogueSniperConfirm_number > level.dialogueSniperConfirm_MAX)
			level.dialogueSniperConfirm_number = 1;
	
		sDialogue = "launchfacility_a_sniper_confirm_0" + level.dialogueSniperConfirm_number;
		
		if (!level.peoplespeaking)
			level radio_dialogue_queue(sDialogue);		
	}


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
	level.excludedAi = [];
	level.excludedAi[0] = level.price;
	level.excludedAi[1] = level.grigsby;
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
	precacheString(&"LAUNCHFACILITY_A_OBJ_RIGHT_GATE");
	precacheString(&"LAUNCHFACILITY_A_OBJ_ENEMY_ARMOR");
	precacheString(&"LAUNCHFACILITY_A_OBJ_NORTH_TARMAC");
	precacheString(&"LAUNCHFACILITY_A_OBJ_RAPPEL");

	precacheItem("m14_scoped");
	precacheItem("rpg_player");
	precacheItem("hind_turret");
	precacheItem("hind_FFAR");
	precacheItem("hind_FFAR_nodamage");
	precacheModel("weapon_c4");
	precacheModel("weapon_c4_obj");
	precacheModel("viewmodel_base_fastrope_character");
	precacheModel("weapon_rpd_MG_Setup");
	
	precacheString(&"LAUNCHFACILITY_A_DEBUG_LEVEL_END");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_SMOKE");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_C4_EQUIP");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_C4_PLANT");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_C4_DETONATE");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_RAPPEL");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_RAPPEL_DOWN_SHAFT");
	precacheString(&"LAUNCHFACILITY_A_HINTSTR_EXPLOSIVES_PLANTED");
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