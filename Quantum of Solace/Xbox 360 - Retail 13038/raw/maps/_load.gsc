#include maps\_utility;
#include common_scripts\utility;

main(bScriptgened)
{
	level._effect["light_green"]	= loadfx ("misc/door_lock_green");
	level._effect["light_red"]		= loadfx ("misc/door_lock_red");

	precachemodel("p_msc_security_keypad_light_grn");
	precachemodel("p_msc_security_keypad_light_red");

	maps\_constants::main();
	
	level.noTankSquish = true; // disables the playing of the "human_crunch" sound alias when someone is killed by a vehicle
	
	if(!isdefined(bScriptgened))
		bScriptgened = false;
	level.bScriptgened = bScriptgened;
	
	/# star (4 + randomint(4)); #/

	// SCRIPTER_MOD
	// MikeD (01/26/07): Added for propman to work.
	if( GetDvar( "propman" ) == "1" )
	{
		maps\_createdynents::main();
		return;
	}

	if (getDvar("debug") == "")
		setDvar("debug", "0");

	if (getDvar("fallback") == "")
		setDvar("fallback", "0");

	if (getDvar("angles") == "")
		setDvar("angles", "0");

	if (getDvar("noai") == "")
		setDvar("noai", "off");

	if (getDvar("scr_RequiredMapAspectratio") == "")
		setDvar("scr_RequiredMapAspectratio", "1");
		
	createPrintChannel( "script_debug" );
	
	level._loadStarted = true;
	
	level.script = tolower(getdvar ("mapname"));
	level.player = getent("player", "classname" );
	level.player.a = spawnStruct();
	
	//level.default_run_speed = 90;
	level.default_run_speed = GetDVarFloat("player_runSpeedScale");	// now used as a scale

	setSavedDvar( "sv_saveOnStartMap", true );
	setDvar("ui_hud_showstanceicon","1");
	setDvar("ui_hud_showcompass","1");
	setDvar("ui_hud_showsprintmeter","1");

	level.dronestruct = [];
	
	maps\_unlock_mechanisms::main();

//	if (!level.xenon)
//		level.player enableHealthShield( false );

	if ( !isdefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}
	// can be turned on and off to control friendly_respawn_trigger
	flag_init( "respawn_friendlies" );

	// for script gen
	flag_init("scriptgen_done");
	level.script_gen_dump_reasons = [];
	if(!isdefined(level.script_gen_dump))
	{
		level.script_gen_dump = [];
		level.script_gen_dump_reasons[0] = "First run";
	}
	if(!isdefined(level.script_gen_dump2))
		level.script_gen_dump2 = [];
		
	if(isdefined(level.createFXent))
		script_gen_dump_addline("maps\\createfx\\"+level.script+"_fx::main();",level.script+"_fx");  // adds to scriptgendump

	level.player.maxhealth = level.player.health;
	level.player.shellshocked = false;
	level.aim_delay_off = false;
	level.player.inWater = false;
	level.last_wait_spread = -1;
	level.hero_list = [];
//	level.ai_array = [];
	
	level.player thread maps\_utility::flashMonitor();
	level.player thread maps\_utility::concMonitor();
	level.player thread maps\_utility::shock_ondeath();
	level.player thread maps\_utility::stinger_ondeath();

	// BOND_MOD
	// KD - 4/2/08
	// automatically kills player if they fail the balance or ledge mechanic
	level.player thread maps\_utility::beam_monitor();
	level.player thread maps\_utility::ledge_monitor();

//	level.player thread ai_eq();
//	level.player thread maps\_spawner::setup_ai_eq_triggers();
//	level.eq_trigger_num = 0;
//	level.eq_trigger_table = [];
//	level.touched_eq_function[ true ] = ::player_touched_eq_trigger;
//	level.touched_eq_function[ false ] = ::ai_touched_eq_trigger;

	// SCRIPT_MOD
	// these are head icons so you can see who the players are
	PrecacheHeadIcon( "headicon_american" ); 
	
/#
	precachemodel ("fx");
//	precachemodel ("temp");
#/	
	precacheShellshock("victoryscreen");
	precacheShellshock("default");
	precacheShellshock("flashbang");
	precacheShellshock("concussion_grenade_mp");
	precacheShellshock("dog_bite");
	precacheRumble("damage_heavy");
	precacheRumble("damage_light");
	precacheRumble("earthquake");
	precacheRumble( "grenade_rumble" );
	precacheRumble( "artillery_rumble" );
	precacheRumble( "coverenter_rumble" );
	precacheRumble( "melee_attack_hit" );
	precacheRumble( "melee_attack_miss" );
	precacheRumble( "melee_struck_general" );
	precacheRumble( "movebody_rumble" );
	
	precacheRumble( "qk_hit" );
	
	precachestring(&"GAME_GET_TO_COVER");
	precachestring(&"SCRIPT_GRENADE_DEATH");
	precacheShader("hud_grenadeicon");
	precacheShader("hud_grenadepointer");


	level.createFX_enabled = (getdvar("createfx") != "");

	setupExploders();
	
	thread maps\_createfx::fx_init();
	if (level.createFX_enabled)
		maps\_createfx::createfx();

	animscripts\weaponList::precacheglobalfx();
	animscripts\weaponList::precacheglobalmodels();
	
	if (getdvar("r_reflectionProbeGenerate") == "1")
	{
		maps\_utility_code::struct_class_init();
		maps\_global_fx::main();
		level waittill ("eternity");
	}

	thread handle_starts();
		
	if ( getDvar( "g_connectpaths" ) == "2" )
	{
		/# printLn( "g_connectpaths == 2; halting script execution" ); #/
		level waittill ( "eternity" );
	}

	printLn( "level.script: ", level.script );

	maps\_autosave::main();
	maps\_anim::init();
	common_scripts\ambientpackage::init();
//	maps\_damagefeedback::init();
	maps\_playerawareness::init();
	maps\_aiPerceptionIndicator::init();
	maps\_music::init();

	//////////////////////////////////////////////////////////////////////////
	// BOND_MOD


	// lagacy... necessary?
	anim.useFacialAnims = false;

	if (!isdefined (level.missionfailed))
		level.missionfailed = false;
		
	level thread maps\_gameskill::setSkillThread();
	level thread maps\_debug::puppetWatcher();
	
	maps\_art::main();
	maps\_loadout::init_loadout();
	maps\_utility_code::struct_class_init();
	maps\_destructible::main();
	maps\_power_weapons::main();
	
	//Reset the revive effect
	reviveeffect( false );

	// BOND_MOD
	// MQL - 10/9/07
	// debuggin ai engagement distances
	/#
	level thread disp_engagement_dist();
	#/

	// BOND_MOD
	// MQL - 10/23/07
	// setup mousetraps
	//maps\_mousetraps::mousetraps_init();

	// BOND_MOD
	// WW - 06/24/08
	// Achievements function
	// COmmenting this out until we get issue 10793 fixed
	// WW - 07-01-08
	// moved this below the power weapon and data_collection calls
	// maps\_achievements::main();
	
	// global effects for objects
	maps\_global_fx::main();
	
	thread devhelp(); //don't know any other good places to put this so It's here for now.
	
	setSavedDvar( "ui_campaign", level.campaign ); // level.campaign is set in maps\_loadout::init_loadout

	maps\_mgturret::setdifficulty();
	thread maps\_vehicle::init_vehicles();	
	/#
	thread maps\_debug::mainDebug();
	#/
	thread maps\_autosave::beginningOfLevelSave();
	thread maps\_introscreen::main();
	thread maps\_quotes::main();
	//thread maps\_minefields::main();
	thread maps\_shutter::main();
	thread maps\_inventory::main();
	thread maps\_endmission::main();
	thread maps\_nightvision::main();
	maps\_friendlyfire::main();

	// For _anim to track what animations have been used. Uncomment this locally if you need it.
//	thread usedAnimations();

	array_levelthread( getentarray( "badplace", "targetname" ), ::badplace_think );
	array_levelthread( getentarray( "delete_on_load", "targetname" ), ::deleteEnt );
	array_thread( getnodearray( "traverse", "targetname" ), ::traverseThink );
	array_thread( getentarray( "piano_key", "targetname" ), ::pianoThink );
	array_thread( getentarray( "piano_damage", "targetname" ), ::pianoDamageThink );
	array_thread( getentarray( "water", "targetname" ), ::waterThink );

	array_thread(GetEntArray("ammo_crate", "targetname"), ::ammo_crate);
	
	thread maps\_interactive_objects::main();
	thread maps\_interactive_vehicles::main();
	thread maps\_pipes::main();
	thread maps\_leak::main();
	thread maps\_intelligence::main();
	thread maps\_audio::main();
	
	thread maps\_gameskill::playerHealthRegen();
	thread playerDamageRumble();
	thread player_death_grenade_hint();

	// this has to come before _spawner moves the turrets around
	thread massNodeInitFunctions();
	
	// Various newvillers globalized scripts
	flag_init( "spawning_friendlies" );
	flag_init( "friendly_wave_spawn_enabled" );
	flag_clear( "spawning_friendlies" );
	
	level.friendly_spawner["rifleguy"] = getentarray ("rifle_spawner","script_noteworthy");			
	level.friendly_spawner["smgguy"] = getentarray ("smg_spawner","script_noteworthy");
	thread maps\_spawner::goalVolumes();
	thread maps\_spawner::friendlyChains();
	thread maps\_spawner::friendlychain_onDeath();

//	array_thread (getentarray("ally_spawn", "targetname"), maps\_spawner::squadThink);
	array_thread (getentarray("friendly_spawn","targetname"), maps\_spawner::friendlySpawnWave);
	array_thread (getentarray("flood_and_secure", "targetname"), maps\_spawner::flood_and_secure);
	
	// Do various things on triggers
	level.player thread common_scripts\ambientpackage::initPlayer();

	// initialize doors
	maps\_doors::main();
	
	// initialize zone_emitters
	zone_emitters = getentarray( "zone_emitter", "classname" );
	for ( i = 0; i < zone_emitters.size; i++ )
	{
		coords = [];
		coord_structs = getstructarray( zone_emitters[i].target, "targetname" );
		if ( isdefined( coord_structs ) )
		{
			for ( j = 0; j < coord_structs.size; j++ )
			{
				coords[j] = coord_structs[j].origin;
			}
		}

		ents1 = getentarray( zone_emitters[i].target, "targetname" );
		ents2 = getentarray( zone_emitters[i].target, "script_noteworthy" );
		ents = array_merge( ents1, ents2 );
		zone_emitters[i] setupzoneemitter( zone_emitters[i].script_zoneemittersamplecount, coords, ents );
	}
	
	level.trigger_hint_string = [];
	level.trigger_hint_func = [];

	trigger_funcs = [];
	trigger_funcs[ "flood_spawner" ] = maps\_spawner::flood_trigger_think;
	trigger_funcs[ "trigger_spawner" ] = maps\_spawner::trigger_spawner;
	trigger_funcs[ "friendly_wave" ] = maps\_spawner::friendly_wave;
	trigger_funcs[ "friendly_wave_off" ] = maps\_spawner::friendly_wave;
	trigger_funcs[ "friendly_mgTurret" ] = maps\_spawner::friendly_mgTurret;
	trigger_funcs[ "trigger_autosave" ] = maps\_autosave::trigger_autosave;
	trigger_funcs[ "trigger_unlock" ] = ::trigger_unlock;
	trigger_funcs[ "trigger_lookat" ] = ::trigger_lookat;
	trigger_funcs[ "autosave_immediate" ] = maps\_autosave::trigger_autosave_immediate;
	trigger_funcs[ "flag_set" ] = ::flag_set_trigger;
	trigger_funcs[ "flag_unset" ] = ::flag_unset_trigger;
	trigger_funcs[ "random_spawn" ] = maps\_spawner::random_spawn;
	trigger_funcs[ "objective_event" ] = maps\_spawner::objective_event_init;
//	trigger_funcs[ "eq_trigger" ] = ::eq_trigger;
	trigger_funcs[ "script_flag_false" ] = ::script_flag_false_trigger;
	trigger_funcs[ "friendly_respawn_trigger" ] = ::friendly_respawn_trigger;
	trigger_funcs[ "friendly_respawn_clear" ] = ::friendly_respawn_clear;
	trigger_funcs[ "radio_trigger" ] = ::radio_trigger;
	trigger_funcs[ "trigger_ignore" ] = ::trigger_ignore;
	trigger_funcs[ "trigger_pacifist" ] = ::trigger_pacifist;
	trigger_funcs[ "trigger_delete" ] = ::trigger_turns_off;
	trigger_funcs[ "trigger_off" ] = ::trigger_turns_off;
	trigger_funcs[ "trigger_outdoor" ] = maps\_spawner::outdoor_think;
	trigger_funcs[ "trigger_indoor" ] = maps\_spawner::indoor_think;
	trigger_funcs[ "trigger_hint" ] = ::trigger_hint;
	trigger_funcs[ "disable_corner_aim" ] = ::disable_corner_aim;

	// trigger_multiple and trigger_radius can have the trigger_spawn flag set
	trigger_multiple = getentarray( "trigger_multiple", "classname" );
	trigger_radius = getentarray( "trigger_radius", "classname" );
	triggers = array_merge( trigger_multiple, trigger_radius );

	for ( i=0; i < triggers.size; i++ )
	{
		if ( triggers[ i ].spawnflags & 32 )
			thread maps\_spawner::trigger_spawner( triggers[ i ] );
	}

	for (p=0;p<6;p++)
	{
		switch (p)
		{
			case 0:
				triggertype = "trigger_multiple";
				break;

			case 1:
				triggertype = "trigger_once";
				break;

			case 2:
				triggertype = "trigger_use";
				break;
				
			case 3:	
				triggertype = "trigger_radius";
				break;
			
			case 4:	
				triggertype = "trigger_lookat";
				break;

			default:
				assert(p == 5);
				triggertype = "trigger_damage";
				break;
		}

		triggers = getentarray (triggertype,"classname");

		for (i=0;i<triggers.size;i++)
		{
			if (isdefined (triggers[i].target))
				level thread maps\_spawner::trigger_spawn(triggers[i]);

			if ( isdefined ( triggers[ i ].script_flag_true ) )
				level thread script_flag_true_trigger( triggers[ i ] );

			if (isdefined (triggers[i].script_autosavename) || isdefined (triggers[i].script_autosave))
				level thread maps\_autosave::autoSaveNameThink(triggers[i]);

			if (isdefined (triggers[i].script_fallback))
				level thread maps\_spawner::fallback_think(triggers[i]);

			if (isdefined (triggers[i].script_mgTurretauto))
				level thread maps\_mgturret::mgTurret_auto(triggers[i]);

			if (isdefined (triggers[i].script_killspawner))
				level thread maps\_spawner::kill_spawner(triggers[i]);

			if (isdefined (triggers[i].script_emptyspawner))
				level thread maps\_spawner::empty_spawner(triggers[i]);

			if (isdefined (triggers[i].script_prefab_exploder))
				triggers[i].script_exploder = triggers[i].script_prefab_exploder;

			if (isdefined (triggers[i].script_exploder))
				level thread maps\_load::exploder_load(triggers[i]);

			if (isdefined (triggers[i].script_triggered_playerseek))
				level thread triggered_playerseek(triggers[i]);
				
			if (isdefined (triggers[i].script_bctrigger))
				level thread bctrigger(triggers[i]);

			if (isdefined (triggers[i].script_trigger_group))
				triggers[i] thread trigger_group();

			if ( isdefined( triggers[ i ].targetname ) )
			{
				// do targetname specific functions
				targetname = triggers[ i ].targetname;
				if ( isdefined( trigger_funcs[ targetname ] ) )
				{
					level thread [[ trigger_funcs[ targetname ] ]]( triggers[ i ] );
				}
			}
		}
	}
	
	maps\_chase::main();

	level.ai_number = 0;
	level.shared_portable_turrets = [];
	maps\_spawner::main();
//	array_thread( getentarray( "misc_turret", "classname" ), maps\_mgturret::portable_mg_spot );

	// for cobrapilot extended visible distance and potentially others, stretch that horizon! -nate
	// origin of prefab is copied manually by LD to brushmodel contained in the prefab, no real way to automate this AFAIK
	array_thread( getentarray( "background_block", "targetname" ), ::background_block );

	maps\_hud::init();
	//maps\_hud_weapons::init();
	
	level maps\_useableobjects::main();

	//maps\_attachments::main();
	
	maps\_data_collection::main();
	//array_thread(GetEntArray("power_weapon_node", "script_noteworthy"), ::power_weapon);
	array_thread(GetEntArray("power_weapon_trigger", "targetname"), ::power_weapon);

	// BOND_MOD
	// WW - 06/24/08
	// Achievements function
	// COmmenting this out until we get issue 10793 fixed
	// WW - 07-01-08
	// moved this below the power weapon and data_collection calls
	maps\_achievements::main();

	thread maps\_utility::load_friendlies();

	// 05-14-08
	// scrowe
	// precaching the new sony_phone and starting its animation thread
	precacheitem( "sony_phone" );
	level.player thread phone_anim();
	
	// 6/30/08
	// bwang
	// precache the P99 ammo clip
	precacheitem( "p99_ammo");
		
//	level.player thread stun_test();
	level.player thread maps\_detonategrenades::watchGrenadeUsage();  // handles c4/claymores with special script - nate
	script_gen_dump();
	
	level.player thread player_init();
	level.player thread show_player_stimulus();
	level.handleFovNotesSetup = false;
	level.player thread animscripts\shared::handleFOVNotes( );

	level.player thread maps\_quick_kill::qk_bus();
	
	poisoneffect(false);
//	SetSavedDVar("ik_bob_pelvis_scale_1st","0.0");		//Set back to default - dodgy but it will do
	
	SetSavedDVar("p99_ammo_chance", "30");				// default chance for enemies to drop P99 ammo
	
	//SetDVar("cover_corner_trans_enabled",true);		//Set back to default - dodgy but it will do
	SetSavedDVar("cover_dash_fromCover_enabled",true);		//Set back to default - dodgy but it will do
	SetSavedDVar("cover_dash_from1stperson_enabled",true);	//Set back to default - dodgy but it will do
	SetSavedDVar("cover_dash_coplaner_enabled",true);		//Set back to default - dodgy but it will do
	SetSavedDVar("cover_corner_aim_enabled",true);			//Set back to default - dodgy but it will do
	
	SetDVar( "player_sprintEnabled", "1" );
	
	//SetSavedDVar("cover_disable", "0");	// disable cover off by default

	// Added 5/22/8 - mjm temp fix for AI lasers for Alpha
	SetDVar("cg_laserAiOn", 0);							//Set back to default - dodgy but it will do
	SetDVar("cg_laserForceOn", 0);						//Set back to default - dodgy but it will do
	setDVar("cg_laserrange", 1500);						//Set back to default - dodgy but it will do
	setDVar("cg_laserradius", 0.02);						//Set back to default - dodgy but it will do

	level thread breadcrumb();
}

// CODE_MOD
// moved most of the player initialization functionality out of the main() function
// into player_init() so we can call it every spawn.  Nothing should be in here
// that you dont want to happen every spawn.
player_init()
{
	//give the player a default model
	self.headicon = "headicon_american";
	
	level.player thread maps\_spawner::handleQKRumble();
	level.player thread maps\_spawner::handleQKGroundhit();
	
	//no prone
	level.player allowProne( false );
}




//**************************************************************************
//**************************************************************************

show_player_stimulus()
{
/#
	hud = NewHudElem();
	hud.location = 0;
	hud.alignX = "center";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.fontScale = 2;
	hud.sort = 20;
	hud.alpha = 1;
	hud.x = 315;
	hud.y = 400;
	hud.og_scale = 2;
	hud.color = ( 1, 0, 0 );
	
	while( isdefined(self) )
	{
		if (getDvarInt("ai_showPlayerStimulus") > 0 ) 
		{
			stimulus = self GetStimulusType();
			
			hud SetText( stimulus ); 
		}
		else
		{		
			hud SetText( "" ); 
		}
		

		wait 0.05;
	}	

	hud Destroy();	
#/
}

stun_test()
{
	
	if (getDvar("stuntime") == "")
		setDvar("stuntime", "0.5");
	level.player.allowads = true;


	for (;;)
	{
		self waittill ("damage");
		if (getDvarfloat("stuntime") == 0)
			continue;
		
		thread stun_player( self playerADS() );			
	}
}

stun_player(ADS_fraction)
{
	self notify( "stun_player" );
	self endon( "stun_player" );
	
	if (ADS_fraction > .3)
	{
		if (level.player.allowads == true)
			level.player playsound ("player_hit_while_ads");
			
		level.player.allowads = false;
		level.player allowads( false );
	}
	level.player setspreadoverride( 20 );
	
	wait (getDvarfloat("stuntime"));
	
	level.player allowads( true );
	level.player.allowads = true;
	level.player resetspreadoverride();
}

trigger_group()
{
	self thread trigger_group_remove();

	level endon("trigger_group_" + self.script_trigger_group);
	self waittill("trigger");
	level notify("trigger_group_" + self.script_trigger_group, self);
}

trigger_group_remove()
{
	level waittill("trigger_group_" + self.script_trigger_group, trigger);
	if (self != trigger)
		self delete();
}

/#



star (total)
{
//	println ("         ");
//	println ("         ");
	println ("         ");
	for (i=0;i<total;i++)
	{
		for (z=total-i;z>1;z--)
		print (" ");
		print ("*");
		for (z=0;z<i;z++)
			print ("**");
		println ("");
	}
	for (i=total-2;i>-1;i--)
	{
		for (z=total-i;z>1;z--)
		print (" ");
		print ("*");
		for (z=0;z<i;z++)
			print ("**");
		println ("");
	}

	println ("         ");
//	println ("         ");
//	println ("         ");
}
#/


exploder_load (trigger)
{
	level endon ("killexplodertridgers"+trigger.script_exploder);
	trigger waittill ("trigger");
	if(isdefined(trigger.script_chance) && randomfloat(1)>trigger.script_chance)
	{
		if(isdefined(trigger.script_delay))
			wait trigger.script_delay;
		else
			wait 4;
		level thread exploder_load(trigger);
		return;
	}
	maps\_utility::exploder (trigger.script_exploder);
	level notify ("killexplodertridgers"+trigger.script_exploder);
}

shock_onpain()
{
	precacheShellshock("pain");
	precacheShellshock("default");
	level.player endon ("death");
	if (getdvar("blurpain") == "")
		setdvar("blurpain", "on");

	while (1)
	{
		oldhealth = level.player.health;
		level.player waittill ("damage");
		if (getdvar("blurpain") == "on")
		{
//			println ("health dif was ", oldhealth - level.player.health);
			if (oldhealth - level.player.health < 129)
			{
				//level.player shellshock("pain", 0.4);
			}
			else
			{
				level.player shellshock("default", 5);
			}
		}
	}
}




usedAnimations ()
{
	setdvar ("usedanim", "");
	while (1)
	{
		if (getdvar("usedanim") == "")
		{
			wait(2);
			continue;
		}

		animname = getdvar("usedanim");
		setdvar ("usedanim", "");

		if (!isdefined (level.completedAnims[animname]))
		{
			println ("^d---- No anims for ", animname,"^d -----------");
			continue;
		}

		println ("^d----Used animations for ", animname,"^d: ", level.completedAnims[animname].size, "^d -----------");
		for (i=0;i<level.completedAnims[animname].size;i++)
			println (level.completedAnims[animname][i]);
	}
}


badplace_think(badplace)
{
	if (!isdefined(level.badPlaces))
		level.badPlaces = 0;
		
	level.badPlaces++;		
	badplace_cylinder("badplace" + level.badPlaces, -1, badplace.origin, badplace.radius, 1024);
}


setupExploders()
{
	// Hide exploder models.
	ents = getentarray ("script_brushmodel","classname");
	smodels = getentarray ("script_model","classname");
	for(i=0;i<smodels.size;i++)
		ents[ents.size] = smodels[i];

	for (i=0;i<ents.size;i++)
	{
		if (isdefined (ents[i].script_prefab_exploder))
			ents[i].script_exploder = ents[i].script_prefab_exploder;

		if (isdefined (ents[i].script_exploder))
		{
			if ((ents[i].model == "fx") && ((!isdefined (ents[i].targetname)) || (ents[i].targetname != "exploderchunk")))
				ents[i] hide();
			else if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploder"))
			{
				ents[i] hide();
				ents[i] notsolid();
				if(isdefined(ents[i].script_disconnectpaths))
					ents[i] connectpaths();
			}
			else if ((isdefined (ents[i].targetname)) && (ents[i].targetname == "exploderchunk"))
			{
				ents[i] hide();
				ents[i] notsolid();
				if(isdefined(ents[i].spawnflags) && (ents[i].spawnflags & 1))
					ents[i] connectpaths();
			}
		}
	}

	script_exploders = [];

	potentialExploders = getentarray ("script_brushmodel","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_prefab_exploder))
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
			
		if (isdefined (potentialExploders[i].script_exploder))
			script_exploders[script_exploders.size] = potentialExploders[i];
	}

	potentialExploders = getentarray ("script_model","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_prefab_exploder))
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;

		if (isdefined (potentialExploders[i].script_exploder))
			script_exploders[script_exploders.size] = potentialExploders[i];
	}

	potentialExploders = getentarray ("item_health","classname");
	for (i=0;i<potentialExploders.size;i++)
	{
		if (isdefined (potentialExploders[i].script_prefab_exploder))
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;

		if (isdefined (potentialExploders[i].script_exploder))
			script_exploders[script_exploders.size] = potentialExploders[i];
	}
	
	if (!isdefined(level.createFXent))
		level.createFXent = [];
	
	acceptableTargetnames = [];
	acceptableTargetnames["exploderchunk visible"] = true;
	acceptableTargetnames["exploderchunk"] = true;
	acceptableTargetnames["exploder"] = true;
	
	for ( i=0; i<script_exploders.size; i++)
	{
		exploder = script_exploders[i];
		ent = createExploder(exploder.script_fxid);
		ent.v = [];
		ent.v["origin"] = exploder.origin;
		ent.v["angles"] = exploder.angles;
		ent.v["delay"] = exploder.script_delay;
		ent.v["firefx"] = exploder.script_firefx;
		ent.v["firefxdelay"] = exploder.script_firefxdelay;
		ent.v["firefxsound"] = exploder.script_firefxsound;
		ent.v["firefxtimeout"] = exploder.script_firefxtimeout;
		ent.v["earthquake"] = exploder.script_earthquake;
		ent.v["damage"] = exploder.script_damage;
		ent.v["damage_radius"] = exploder.script_radius;
		ent.v["soundalias"] = exploder.script_soundalias;
		ent.v["repeat"] = exploder.script_repeat;
		ent.v["delay_min"] = exploder.script_delay_min;
		ent.v["delay_max"] = exploder.script_delay_max;
		ent.v["target"] = exploder.target;
		ent.v["ender"] = exploder.script_ender;
		ent.v["type"] = "exploder";
//		ent.v["worldfx"] = true;
		if(!isdefined(exploder.script_fxid))
			ent.v["fxid"] = "No FX";
		else
			ent.v["fxid"] = exploder.script_fxid;
		ent.v["exploder"] = exploder.script_exploder;
		assertEx (isdefined(exploder.script_exploder), "Exploder at origin " + exploder.origin + " has no script_exploder");

		if (!isdefined (ent.v["delay"]))
			ent.v["delay"] = 0;
			
		if ( isdefined( exploder.target ) )
		{
			org = getent( ent.v["target"], "targetname" ).origin;
			ent.v["angles"] = vectortoangles( org - ent.v["origin"] );
//			forward = anglestoforward( angles );
//			up = anglestoup( angles );
		}
			
		// this basically determines if its a brush/model exploder or not
		if (exploder.classname == "script_brushmodel" || isdefined( exploder.model ))
		{
			ent.model = exploder;
			ent.model.disconnect_paths = exploder.script_disconnectpaths;
		}
		
		if ( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[ exploder.targetname ] ))
			ent.v["exploder_type"] = exploder.targetname;
		else
			ent.v["exploder_type"] = "normal";
		
		ent maps\_createfx::post_entity_creation_function();
	}
}


nearAIRushesPlayer()
{
	if (isalive(level.enemySeekingPlayer))
		return;
	enemy = get_closest_ai (level.player.origin, "axis");
	if (!isdefined (enemy))
		return;
		
	if (distance(enemy.origin, level.player.origin) > 400)
		return;
		
	level.enemySeekingPlayer = enemy;
	enemy setgoalentity (level.player);
	enemy.goalradius = 512;
	
}

		
playerDamageRumble()
{
	while ( true )
	{
		level.player waittill ( "damage", amount );
		level.player PlayRumbleOnEntity( "damage_heavy" );		
	}
}

playerDamageShellshock()
{
	while ( true )
	{
		level.player waittill ( "damage", damage, attacker, direction_vec, point, cause );

		if( cause == "MOD_EXPLOSIVE" ||
			cause == "MOD_GRENADE" ||
			cause == "MOD_GRENADE_SPLASH" ||
			cause == "MOD_PROJECTILE" ||
			cause == "MOD_PROJECTILE_SPLASH" )
		{
			time = 0;

			multiplier = level.player.maxhealth / 100;
			scaled_damage = damage * multiplier;
			
			if(scaled_damage >= 90)
				time = 4;
			else if(scaled_damage >= 50)
				time = 3;
			else if(scaled_damage >= 25)
				time = 2;
			else if(scaled_damage > 10)
				time = 1;
			
			if(time)
				level.player shellshock("default", time);
		}
	}
}

map_is_early_in_the_game()
{
	if (level.script == "moscow")
		return true;
	return (level.script == "demolition");
}

player_death_grenade_hint()
{
	// set the player's "quote" to the grenade indicator hint
	level.player_died_to_grenades = false;

	while ( true )
	{
		level.player waittill ( "damage", damage, attacker, direction_vec, point, cause );

		if(	cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" )
			continue;

		if (level.gameskill >= 2)
		{
			// less grenade hinting on hard/fu
			if (!map_is_early_in_the_game() && randomint(100) < 85)
				continue;
		}
	
		thread set_grenade_hint_death_quote();
	}
}

set_grenade_hint_death_quote()
{
	level.player endon ("damage");
	setdvar("ui_deadquote", "@SCRIPT_GRENADE_DEATH");
	level.player_died_to_grenades = true;
	wait (0.05);
	level.player_died_to_grenades = false;
	// if the player is still alive a frame later, set it back to a normal quote
	if (isalive(level.player))
		thread maps\_quotes::setDeadQuote();
}



triggered_playerseek(trig)
{
	groupNum = trig.script_triggered_playerseek;
	trig waittill ("trigger");
	
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if (!isAlive(ai[i]))
			continue;
		if ( (isdefined (ai[i].script_triggered_playerseek)) && (ai[i].script_triggered_playerseek == groupNum) )
		{
			ai[i].goalradius = 800;
			ai[i] setgoalentity (level.player);
			level thread maps\_spawner::delayed_player_seek_think(ai[i]);
		}
	}
}

traverseThink()
{
	ent = getent(self.target,"targetname");
	self.traverse_height = ent.origin[2];
	ent delete();
}


pianoDamageThink()
{
	org = self getorigin();
//	note = "piano_" + self.script_noteworthy;
//	self setHintString (&"SCRIPT_PLATFORM_PIANO");
	note[0] = "large";
	note[1] = "small";
	for (;;)
	{
		self waittill ("trigger");
		thread play_sound_in_space("bullet_" + random(note) + "_piano", org);
	}
}

pianoThink()
{
	org = self getorigin();
	note = "piano_" + self.script_noteworthy;
	self setHintString (&"SCRIPT_PLATFORM_PIANO");
	for (;;)
	{
		self waittill ("trigger");
		thread play_sound_in_space(note ,org);
	}
}



bcTrigger( trigger )
{
	if ( isDefined( trigger.target ) )
	{
		realTrigger = getEnt( trigger.target, "targetname" );
		realTrigger waittill ( "trigger", other );
	}
	else
	{
		realTrigger = undefined;
		trigger waittill ( "trigger", other );
	}
	
	soldier = undefined;
	
	if ( isDefined( realTrigger ) )
	{
		if ( other.team == "axis" && level.player isTouching( trigger ) )
		{
			soldier = get_closest_ai( level.player getOrigin(), "allies" );
			if ( distance( soldier.origin, level.player getOrigin() ) > 512 )
				return;
		}
		else if ( other.team == "allies" )
		{
			soldiers = getAIArray( "axis" );
			
			for ( index = 0; index < soldiers.size; index++ )
			{
				if ( soldiers[index] isTouching( trigger ) )
					soldier = soldiers[index];
			}
		}
	}
	else
		soldier = other;
	
	if ( !isDefined( soldier ) )
		return;

	soldier custom_battlechatter( trigger.script_bctrigger );
}

waterThink()
{
	assert(isdefined(self.target));
	targeted = getent(self.target,"targetname");
	assert(isdefined(targeted));
	waterHeight = targeted.origin[2];
	targeted = undefined;
	
	level.depth_allow_prone = 8;
	level.depth_allow_crouch = 43;
	
	prof_begin("water_stance_controller");
	
	for (;;)
	{
		wait 0.05;
		//restore all defaults
		if (!level.player.inWater)
		{
			SetDvar("player_speedScaleDebug", "0");
			//level.player allowProne(true); // BOND_MOD: No Prone!
			level.player allowCrouch(true);
			level.player allowStand(true);
			thread waterThink_rampSpeed(level.default_run_speed);
		}
		
		//wait until in water
		self waittill ("trigger");
		SetDvar("player_speedScaleDebug", "1");

		level.player.inWater = true;
		while(level.player isTouching(self))
		{
			level.player.inWater = true;
			playerOrg = level.player getOrigin();
			d = (playerOrg[2] - waterHeight);
			if (d > 0)
				break;
			
			//slow the players movement based on how deep it is
			newSpeed = level.default_run_speed - (abs(d * 3.5) / 190);
			if (newSpeed < .3)
				newSpeed = .3;
			assert(newSpeed <= level.default_run_speed);
			thread waterThink_rampSpeed(newSpeed);

			//iPrintLnBold("depth: " + d + " - setting speed to: " + newSpeed);
			
			//controll the allowed stances in this water height
			if (abs(d) > level.depth_allow_crouch)
				level.player allowCrouch(false);
			else
				level.player allowCrouch(true);
			
			//// BOND_MOD: No Prone!
			//if (abs(d) > level.depth_allow_prone)
			//	level.player allowProne(false);
			//else
			//	level.player allowProne(true);
			
			wait 0.5;
		}
		level.player.inWater = false;
		wait 0.05;
	}
	
	prof_end("water_stance_controller");
}

waterThink_rampSpeed(newSpeed, rampTime)
{
	level notify ("ramping_water_movement_speed");
	level endon ("ramping_water_movement_speed");
	
	if (!IsDefined(rampTime))
	{
		rampTime = 0.5;
	}

	numFrames = int(rampTime * 20);
	
	//currentSpeed = getdvarint("g_speed");
	currentSpeed = GetDVarFloat("player_runSpeedScale");
	
	qSlower = false;
	if (newSpeed < currentSpeed)
		qSlower = true;
	
	speedDifference = abs(currentSpeed - newSpeed);
	speedStepSize = speedDifference / numFrames;
	
	for( i = 0 ; i < numFrames ; i++ )
	{
		currentSpeed = GetDVarFloat("player_runSpeedScale");
		if (qSlower)
			setsaveddvar("player_runSpeedScale", (currentSpeed - speedStepSize));
		else
			setsaveddvar("player_runSpeedScale", (currentSpeed + speedStepSize));
		wait 0.05;
	}

	setsaveddvar("player_runSpeedScale", newSpeed );
}



massNodeInitFunctions()
{
	nodes = getallnodes();

	if ( getDvarInt( "scr_useTurrets" ) == 1 )
		thread maps\_mgturret::auto_mgTurretLink( nodes );
	
	//thread maps\_colors::init_color_grouping(nodes);
}


/* 
**********

TRIGGER_UNLOCK

**********
*/ 

trigger_unlock( trigger )
{
	// trigger unlocks unlock another trigger. When that trigger is hit, all unlocked triggers relock
	// trigger_unlocks with the same script_noteworthy relock the same triggers
	
	noteworthy = "not_set";
	if ( isdefined( trigger.script_noteworthy ) )
		noteworthy = trigger.script_noteworthy;
		
	target_triggers = getentarray( trigger.target, "targetname" );

	trigger thread trigger_unlock_death( trigger.target );

	for ( ;; )
	{	
		array_thread( target_triggers, maps\_utility::trigger_off );
		trigger waittill( "trigger" );
		array_thread( target_triggers, maps\_utility::trigger_on );
		
		wait_for_an_unlocked_trigger( target_triggers, noteworthy );

		array_notify( target_triggers, "relock" );
	}
}

trigger_unlock_death( target )
{
	self waittill( "death" );
	target_triggers = getentarray( target, "targetname" );
	array_thread( target_triggers, maps\_utility::trigger_off );
}

wait_for_an_unlocked_trigger( triggers, noteworthy )
{
	level endon( "unlocked_trigger_hit" + noteworthy );
	ent = spawnstruct();
	for ( i=0; i<triggers.size; i++ )
	{
		triggers[ i ] thread report_trigger( ent, noteworthy );
	}
	ent waittill( "trigger" );
	level notify( "unlocked_trigger_hit" + noteworthy );
}

report_trigger( ent, noteworthy )
{
	self endon( "relock" );
	level endon( "unlocked_trigger_hit" + noteworthy );
	self waittill( "trigger" );
	ent notify( "trigger" );
}

/* 
**********

TRIGGER_LOOKAT

**********
*/ 

trigger_lookat( trigger )
{
	assertEx( isdefined( trigger.script_noteworthy ), "Trigger_lookat at " + trigger.origin + " has no script_noteworthy! The noteworthy is used as a flag that gets set when the trigger is activated." );
	flagName = trigger get_trigger_flag();
	if ( !isdefined( level.flag[ flagName ] ) )
		flag_init( flagName );
	
	dot = 0.78;
	if ( isdefined( trigger.script_dot ) )
	{
		dot = trigger.script_dot;
	}
		
	target_origin = trigger.origin;
	if ( isdefined( trigger.target ) )
	{
		target = getent( trigger.target, "targetname" );
		target_origin = target.origin;
		target delete();
	}

	trigger endon( "death" );
	
	for ( ;; )
	{
		flag_clear( flagName );
		trigger waittill( "trigger", other );
	
		assertEx( other == level.player, "trigger_lookat currently only supports looking from the player" );
		while ( level.player istouching( trigger ) )
		{
			if ( !sightTracePassed( other geteye(), target_origin, false, undefined ) )
			{
				wait( 0.5 );
				continue;
			}
				
			normal = vectorNormalize( target_origin - other.origin );
		    player_angles = level.player GetPlayerAngles();
		    player_forward = anglesToForward( player_angles );
	
	//		angles = vectorToAngles( target_origin - other.origin );
	//	    forward = anglesToForward( angles );
	//		draw_arrow( level.player.origin, level.player.origin + vectorscale(forward, 150), (1,0.5,0));
	//		draw_arrow( level.player.origin, level.player.origin + vectorscale(player_forward, 150), (0,0.5,1));
	
			dot = vectorDot( player_forward, normal );
			if ( dot >= 0.78 )
			{
				flag_set( flagName );
				wait( 2 );
			}
			wait( 0.5 );
		}
	}
}

handle_starts()
{
	waittillframeend; // starts happen at the end of the first frame, so threads in the mission have a chance to run and init stuff
/#
	if ( !isdefined( level.start_functions ) )
		level.start_functions = [];

	assertEx( getdvar( "jumpto" ) == "", "Use the START dvar instead of JUMPTO" );
	
	start = getdvar( "start" );

	
	// find the start that matches the one the dvar is set to, and execute it
	dvars = getArrayKeys( level.start_functions );
	for ( i=0; i < dvars.size; i++ )
	{
		if ( start == dvars[ i ] )
		{
			level.start_point = dvars[ i ];
			thread [[ level.start_functions[ dvars[ i ] ] ]]();
			return;
		}
	}
	
	// If safe_start is set then it will load that start position only if its possible
	// so you can have a start set without affecting maps that don't have that start
	safe_start = getdvar( "safe_start" );
	for ( i=0; i < dvars.size; i++ )
	{
		if ( safe_start == dvars[ i ] )
		{
			level.start_point = dvars[ i ];
			thread [[ level.start_functions[ dvars[ i ] ] ]]();
			return;
		}
	}

	if ( isdefined( level.default_start ) )
	{
		level.start_point = "default";
		thread [[ level.default_start ]]();
	}
	
	if ( start != "" )
	{
		assertEx( issubstr( start, " ** " ), "Start " + start + " has not been added to the startlist for this map. Add it with the add_start _utility command." );
		return;
	}
	
	string = " ** No starts setup for this map.";
	if ( dvars.size )
	{
		string = " ** ";
		for ( i=0; i < dvars.size; i++ )
		{
			string = string + dvars[ i ] + " ";
		}
	}
	
	setdvar( "start", string );

	return;
#/

	if ( isdefined( level.default_start ) )
	{
		thread [[ level.default_start ]]();
	}

}


devhelp_hudElements( hudarray, alpha )
{
	for (i=0;i<hudarray.size;i++)
		for (p=0;p<5;p++)
			hudarray[i][p].alpha = alpha;

}

devhelp()
{
	/#
	helptext = [];
	helptext[helptext.size] ="P: pause                                                       ";
	helptext[helptext.size] ="T: super speed                                                 ";
	helptext[helptext.size] =".: fullbright                                                  ";
	helptext[helptext.size] ="U: toggle normal maps                                          ";
	helptext[helptext.size] ="Y: print a line of text, useful for putting it in a screenshot ";
	helptext[helptext.size] ="H: toggle detailed ent info                                    ";
	helptext[helptext.size] ="g: toggle simplified ent info                                  ";
	helptext[helptext.size] =",: show the triangle outlines                                  ";
	helptext[helptext.size] ="-: Back 10 seconds                                             ";
	helptext[helptext.size] ="6: Replay mark                                                 ";
	helptext[helptext.size] ="7: Replay goto                                                 ";
	helptext[helptext.size] ="8: Replay live                                                 ";
	helptext[helptext.size] ="0: Replay back 3 seconds                                       ";
	helptext[helptext.size] ="[: Replay restart                                              ";
	helptext[helptext.size] ="\: map_restart                                                 ";
	helptext[helptext.size] ="U: draw material name                                          ";
	helptext[helptext.size] ="J: display tri counts                                          ";
	helptext[helptext.size] ="B: cg_ufo                                                      ";
	helptext[helptext.size] ="N: ufo                                                         ";
	helptext[helptext.size] ="C: god                                                         ";                                      
	helptext[helptext.size] ="K: Show ai nodes                                               ";                                      
	helptext[helptext.size] ="L: Show ai node connections                                    ";                                      
	helptext[helptext.size] ="Semicolon: Show ai pathing                                     ";                                      

	
	strOffsetX = [];
	strOffsetY = [];
	strOffsetX[0] = 0;
	strOffsetY[0] = 0;
	strOffsetX[1] = 1;
	strOffsetY[1] = 1;
	strOffsetX[2] = -2;
	strOffsetY[2] = 1;
	strOffsetX[3] = 1;
	strOffsetY[3] = -1;
	strOffsetX[4] = -2;
	strOffsetY[4] = -1;
	hudarray = [];
	for(i=0;i<helptext.size;i++)
	{
		newStrArray = [];
		for (p=0;p<5;p++)
		{
			// setup instructional text
			newStr = newHudElem();
			newStr.alignX = "left";
			newStr.location = 0;
			newStr.foreground = 1;
			newStr.fontScale = 1.30;
			newStr.sort = 20 - p;
			newStr.alpha = 1;
			newStr.x = 54 + strOffsetX[p];
			newStr.y = 80 + strOffsetY[p]+ i * 15;
			newstr settext(helptext[i]);
			if (p > 0)
				newStr.color = (0,0,0);
			
			newStrArray[newStrArray.size] = newStr;
		}
		hudarray[hudarray.size] = newStrArray;
	}
	
	devhelp_hudElements( hudarray , 0);

	while(1)
	{
		update = false;
		if(level.player buttonpressed("F1"))
		{
				devhelp_hudElements( hudarray , 1);
				while(level.player buttonpressed("F1"))
					wait .05;
		}
		devhelp_hudElements( hudarray , 0);
		wait .05;
	}
	#/
}


flag_set_trigger( trigger )
{
	trigger endon( "death" );
	flag = trigger get_trigger_flag();
	
	if ( !isdefined( level.flag[ flag ] ) )
		flag_init( flag );
	for ( ;; )
	{
		trigger waittill( "trigger" );
		flag_set( flag );
	}
}

flag_unset_trigger( trigger )
{
	trigger endon( "death" );
	flag = trigger get_trigger_flag();
	
	if ( !isdefined( level.flag[ flag ] ) )
		flag_init( flag );
	for ( ;; )
	{
		trigger waittill( "trigger" );
		flag_clear( flag );
	}
}

eq_trigger( trigger )
{
	level.set_eq_func[ true ] = ::set_eq_on;
	level.set_eq_func[ false ] = ::set_eq_off;
	targ = getent( trigger.target, "targetname" );
	for ( ;; )
	{
		trigger waittill( "trigger" );
		ai = getaiarray( "allies" );
		for ( i=0; i < ai.size; i++ )
		{
			ai[i] [[ level.set_eq_func[ ai[ i ] istouching( targ ) ] ]]();
		}
		while ( level.player istouching( trigger ) )
			wait ( 0.05 );

		ai = getaiarray( "allies" );
		for ( i=0; i < ai.size; i++ )
		{
			ai[i] [[ level.set_eq_func[ false ] ]] ();
		}
	}
	/*
	num = level.eq_trigger_num;
	trigger.eq_num = num;
	level.eq_trigger_num++;
	waittillframeend; // let the ai get their eq_num table created
	waittillframeend; // let the ai get their eq_num table created
	level.eq_trigger_table[ num ] = [];
	if ( isdefined( trigger.script_linkto ) )
	{
		tokens = strtok( trigger.script_linkto, " " );
		for ( i=0; i < tokens.size; i++ )
		{
			target_trigger = getent( tokens[ i ], "script_linkname" );
			// add the trigger num to the list of triggers this trigger hears 
			level.eq_trigger_table[ num ][ level.eq_trigger_table[ num ].size ] = target_trigger.eq_num;		
		}
	}
	
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		
		// are we already registered with this trigger?
		if ( other.eq_table[ num ] )
			continue;
			
		other thread [[ level.touched_eq_function[ other.is_the_player ] ]]( num, trigger );
	}
	*/
}


player_ignores_triggers()
{
	self endon( "death" );
	self.ignoretriggers = true;
	wait( 1 );
	self.ignoretriggers = false;
}

get_trigger_eq_nums( num )
{
	// tally up the triggers this trigger hears into, including itself
	nums = [];
	nums[ 0 ] = num;
	for ( i=0; i < level.eq_trigger_table[ num ].size; i++ )
	{
		nums[ nums.size ] = level.eq_trigger_table[ num ][ i ];
	}
	return nums;
}


player_touched_eq_trigger( num, trigger )
{
	self endon( "death" );

	nums = get_trigger_eq_nums( num );	
	for ( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = true;
		self.eq_touching[ nums[ r ] ] = true;
	}

	thread player_ignores_triggers();

	ai = getaiarray();
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		// is the ai in this trigger with us?
		for ( r=0; r < nums.size; r++ )
		{
			if ( guy.eq_table[ nums[ r ] ] )
			{
				guy eqoff();
				break;
			}
		}
	}

	while( self istouching( trigger ) )
		wait( 0.05 );
		
	for ( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = false;
		self.eq_touching[ nums[ r ] ] = undefined;
	}
	
	ai = getaiarray();
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];

		was_in_our_trigger = false;
		// is the ai in the trigger we just left?
		for ( r=0; r < nums.size; r++ )
		{
			// was the guy in a trigger we could hear into?
			if ( guy.eq_table[ nums[ r ] ] )
			{
				was_in_our_trigger = true;
			}
		}
		
		if ( !was_in_our_trigger )
			continue;

		// check to see if the guy is in any of the triggers we're still in
	
		touching = getarraykeys( self.eq_touching );
		shares_trigger = false;
		for ( p=0; p < touching.size; p++ )
		{
			if ( !guy.eq_table[ touching[ p ] ] )
				continue;
				
			shares_trigger = true;
			break;
		}
		
		// if he's not in a trigger with us, turn his eq back on
		if ( !shares_trigger )
			guy eqOn();
	}
}

ai_touched_eq_trigger( num, trigger )
{
	self endon( "death" );

	nums = get_trigger_eq_nums( num );	
	for ( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = true;
		self.eq_touching[ nums[ r ] ] = true;
	}

	// are we in the same trigger as the player?
	for ( r=0; r < nums.size; r++ )
	{
		if ( level.player.eq_table[ nums[ r ] ] )
		{
			self eqoff();
			break;
		}
	}
		
	// so other AI can touch the trigger
	self.ignoretriggers = true;
	wait( 1 );
	self.ignoretriggers = false;
	while( self istouching( trigger ) )
		wait( 0.5 );
		
	nums = get_trigger_eq_nums( num );	
	for ( r=0; r < nums.size; r++ )
	{
		self.eq_table[ nums[ r ] ] = false;
		self.eq_touching[ nums[ r ] ] = undefined;
	}
		
	touching = getarraykeys( self.eq_touching );
	for ( i=0; i < touching.size; i++ )
	{
		// is the player in a trigger that we're still in?
		if ( level.player.eq_table[ touching[ i ] ] )
		{
			// then don't turn eq back on
			return;
		}
	}

	self eqon();
}

ai_eq()
{
// 	level.set_eq_func[ false ] = ::set_eq_on;
// 	level.set_eq_func[ true ] = ::set_eq_off;
// 	index = 0;
// 	for ( ;; )
// 	{
// 		while( !level.ai_array.size )
// 		{
// 			wait( 0.05);
// 		}
// 		waittillframeend;
// 		waittillframeend;
// 		keys = getarraykeys( level.ai_array );
// 		index++;
// 		if ( index >= keys.size )
// 			index = 0;
// 		guy = level.ai_array[ keys[ index ] ];
// 		guy [[ level.set_eq_func[ sighttracepassed( level.player geteye(), guy geteye(), false, undefined ) ] ]]();
// 		wait( 0.05 );
// 	}
}

set_eq_on()
{
	self eqon();
}

set_eq_off()
{
	self eqoff();
}

create_flags_and_return_tokens( flags )
{
	tokens = strtok( flags, " " );	

	// create the flag if level script does not
	for ( i=0; i < tokens.size; i++ )
	{
		if ( !isdefined( level.flag[ tokens[ i ] ] ) )
		{
			flag_init( tokens[ i ] );
		}
	}
	
	return tokens;
}

script_flag_false_trigger( trigger )
{
	trigger endon( "death" );

	// all of these flags must be false for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );

	for ( ;; )
	{
		trigger trigger_on();
		wait_for_flag( tokens );
		
		trigger trigger_off();
		wait_for_flag( tokens );
		for ( i=0; i < tokens.size; i++ )
		{
			flag_wait( tokens[ i ] );
		}		
	}
}

script_flag_true_trigger( trigger )
{
	trigger endon( "death" );

	// any of these flags have to be true for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );

	for ( ;; )
	{
		trigger trigger_off();
		wait_for_flag( tokens );
		trigger trigger_on();
		for ( i=0; i < tokens.size; i++ )
		{
			flag_waitopen( tokens[ i ] );
		}		
	}
}

wait_for_flag( tokens )
{
	for ( i=0; i < tokens.size; i++ )
	{
		level endon( tokens[ i ] );
	}
	level waittill( "foreverrr");
}

friendly_respawn_trigger( trigger )
{
	spawners = getentarray( trigger.target, "targetname" );
	assertEx( spawners.size == 1, "friendly_respawn_trigger targets multiple spawner with targetname " + trigger.target + ". Should target just 1 spawner." );
	spawner = spawners[ 0 ];
	spawners = undefined;
	
	spawner endon( "death" );
	
	for ( ;; )
	{
		trigger waittill( "trigger" );
		level.respawn_spawner = spawner;
		wait( 0.5 );
	}
}

friendly_respawn_clear( trigger )
{
	for ( ;; )
	{
		trigger waittill( "trigger" );
		flag_clear( "respawn_friendlies" );
		wait( 0.5 );
	}
}

radio_trigger( trigger )
{
	trigger waittill( "trigger" );
	radio_dialogue( trigger.script_noteworthy );	
}

background_block ()
{
		assert(isdefined(self.script_bg_offset));
		self.origin -= self.script_bg_offset;
}

trigger_ignore( trigger )
{
	thread trigger_runs_function_on_touch( trigger, ::set_ignoreme, ::get_ignoreme );
}

trigger_pacifist( trigger )
{
	thread trigger_runs_function_on_touch( trigger, ::set_pacifist, ::get_pacifist );
}

trigger_runs_function_on_touch( trigger, set_func, get_func )
{
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( other [[ get_func ]]() )
			continue;
		other thread touched_trigger_runs_func( trigger, set_func );
	}
}

touched_trigger_runs_func( trigger, set_func )
{
	self endon( "death" );
	self.ignoreme = true;
	[[ set_func ]]( true );
	// so others can touch the trigger
	self.ignoretriggers = true;	
	wait( 1 );
	self.ignoretriggers = false;
	
	while( self istouching( trigger ) )
	{
		wait( 1 );
	}
	
	[[ set_func ]]( false );
}

trigger_turns_off( trigger )
{
	trigger waittill( "trigger" );
	trigger trigger_off();
	
	if ( !isdefined( trigger.script_linkTo ) )
		return;
	
	// also turn off all triggers this trigger links to
	tokens = strtok( trigger.script_linkto, " " );
	for ( i=0; i < tokens.size; i++ )
		array_thread( getentarray( tokens[ i ], "script_linkname" ), ::trigger_off );
}



script_gen_dump_checksaved()
{
	signatures = getarraykeys(level.script_gen_dump);
	for(i=0;i<signatures.size;i++)
		if(!isdefined(level.script_gen_dump2[signatures[i]]))
			level.script_gen_dump_reasons[level.script_gen_dump_reasons.size] = "Signature unmatched (removed feature): "+signatures[i];
}

script_gen_dump()
{
	//initialize scriptgen dump
	/#

	script_gen_dump_checksaved(); // this checks saved against fresh, if there is no matching saved value then something has changed and the dump needs to happen again.
	
	if(!level.script_gen_dump_reasons.size)
	{
		flag_set("scriptgen_done");
		return; // there's no reason to dump the file so exit
	}
	if(level.bScriptgened)
	{
		println(" ");
		println(" ");
		println(" ");
		println("^2----------------------------------------");
		println("^3Dumping scriptgen dump for these reasons");
		println("^2----------------------------------------");
		for(i=0;i<level.script_gen_dump_reasons.size;i++)
			println(i+".) "+level.script_gen_dump_reasons[i]);
		println("^2----------------------------------------");
		println(" ");
		println("for First Run make sure you delete all of the vehicle precache script calls, createart calls, createfx calls(most commonly placed in maps\\"+level.script+"_fx.gsc) ");
		println(" ");
		println("replace:");
		println("maps\\\_load::main(1);");
		println(" ");
		println("with (don't forget to add this file to P4):");
		println("maps\\scriptgen\\"+level.script+"_scriptgen::main();");
		println(" ");
		println("make sure this is in your "+level.script+".csv:");
		println("rawfile,maps/scriptgen/"+level.script+"_scriptgen.gsc");
		println("^2----------------------------------------");
		println(" ");
		println("^2/\\/\\/\\");
		println("^2scroll up");
		println("^2/\\/\\/\\");
		println(" ");
	}
	else
	{
		println(" ");
		println(" ");
		println("^3for legacy purposes I'm printing the would be script here, you can copy this stuff if you'd like to remain a dinosaur:");
		println("^3otherwise, you should add this to your script:");
		println("^3maps\\\_load::main(1);");
		println(" ");
		println("^3rebuild the fast file and the follow the assert instructions");
		println(" ");
	}
	
	filename = "scriptgen/"+level.script+"_scriptgen.gsc";
	
	if(level.bScriptgened)
		file = openfile(filename,"write");
	else
		file = 0;

	assertex(file != -1, "File not writeable (check it and and restart the map): " + filename);
	script_gen_dumpprintln (file,"//script generated script do not write your own script here it will go away if you do.");
	script_gen_dumpprintln (file,"main()");
	script_gen_dumpprintln (file,"{");
	script_gen_dumpprintln (file,"");
	script_gen_dumpprintln (file,"\tlevel.script_gen_dump = [];");
	script_gen_dumpprintln (file,"");

	//todo: sort these, People can setup the order by making them alphabetic (prefix a 001 on the signature to put it up top,etc)
	//todo: handle removed features. No good ideas on how to do this just yet. Possibly create a second array with maps\_utility::script_gen_dump_addline() 
	signatures = getarraykeys(level.script_gen_dump);
	for(i=0;i<signatures.size;i++)
		script_gen_dumpprintln (file,"\t"+level.script_gen_dump[signatures[i]]);

	for(i=0;i<signatures.size;i++)
	script_gen_dumpprintln (file,"\tlevel.script_gen_dump["+"\""+signatures[i]+"\""+"] = "+"\""+signatures[i]+"\""+";");

	script_gen_dumpprintln (file,"");
	script_gen_dumpprintln (file,"\tmaps\\\_load::main(1);");
	script_gen_dumpprintln (file,"}");
	
	if(level.bScriptgened)
		saved = closefile(file);
	else
		saved = 1;  //dodging save for legacy levels
	
	assertex(saved == 1,"map not saved (see above message?): " + filename);

	#/
	
	//level.bScriptgened is not set on non scriptgen powered maps, keep from breaking everything
	assertex(!level.bScriptgened,"SCRIPTGEN generated: follow instructions listed above this error in the console");
	if(level.bScriptgened)
		assertmsg("SCRIPTGEN updated: Rebuild fast file and run map again");
		
	flag_set("scriptgen_done");
	
}
script_gen_dumpprintln(file,string)
{
	// printing to file is optional
	if(file == -1 || !level.bScriptgened)
		println(string);
	else
		fprintln(file,string);
}

trigger_hint( trigger )
{
	assertEx( isdefined( trigger.script_hint ), "Trigger_hint at " + trigger.origin + " has no .script_hint" );
	trigger endon( "death" );
	
	// give level script a chance to set the hint string and optional boolean functions on this hint
	waittillframeend;
	assertEx( isdefined( level.trigger_hint_string[ trigger.script_hint ] ), "Trigger_hint with hint " + trigger.script_hint + " had no hint string assigned to it. Define hint strings with add_hint_string()" );
	trigger waittill( "trigger", other );
	assertEx( other == level.player, "Tried to do a trigger_hint on a non player entity" );
	
	// hint triggers have an optional function they can boolean off of to determine if the hint will occur
	// such as not doing the NVG hint if the player is using NVGs already
	if ( isdefined( level.trigger_hint_func[ trigger.script_hint ] ) )
	{
		if ( ![[ level.trigger_hint_func[ trigger.script_hint ] ]]() )
			return;
	}
	
	iprintlnbold( level.trigger_hint_string[ trigger.script_hint ] );
}


//JLM 9/18/07: Adding this function to allow for level notifications to be passed from code to script.
Callback_LevelNotifyDirect(notify_name)
{
	level notify(notify_name);
}

// power_weapon - handles power weapon crates placed in levels
power_weapon()
{
	lid = GetEnt(self.target, "targetname");

	self UseTriggerRequireLookAt(true);
	self waittill("trigger");

	//lid RotateTo(lid_end.angles, 1.2, 0.0, 1.2);
	lid delete();

	self delete();
}

//Scrowe 05-14-08 phone anims
phone_anim()
{
	unholster_on_close = false;

	// Init the players current weapon
	curr_weapon = level.player getcurrentweapon();
	level.player GiveWeapon( "sony_phone" );

	while( true )
	{
		// phone_state: 0 means we put it away, 1 means we just brought it up.  
		// <2|3|4> mean <objectives|camera|data collection> screen was just activated
		self waittill( "phonemenu", phone_state );

		if( phone_state == 1 )
		{
			// @HACK SJC to fix bug 16648 - press BACK repeatedly, get stuck in the phone
			if ( level.player getcurrentweapon() == "sony_phone" ) {
				level.player NotifyPhoneRaised();
				// SJC: commented out this next line to fix bug 21821: press BACK repeatedly, doesn't switch back to your former weapon.
				// curr_weapon = undefined;
			}
			else
			{
				// select the phone.
				if ( level.player SwitchToWeapon( "sony_phone" ) ) {
					// Remember the current player's weapon
					curr_weapon = level.player getcurrentweapon();
				} else {
					// if we're in a traversal, don't remember the player's current weapon.
					curr_weapon = undefined;
				}
			}
		}
		else if( phone_state == 0 )
		{
			// Remove the phone
			// level.player TakeWeapon( "sony_phone" );

			// Restore the correct player weapon			
			if( IsDefined( curr_weapon ) )
			{
				if( curr_weapon == "none" )
				{
					level.player SwitchToNoWeapon( );
				} else {
					level.player SwitchToWeapon( curr_weapon );
				}
			}
		}
	}
}

//
// disable_corner_aim - run on "disable_corner_aim" triggers to disable corner aim while the player is in the trigger
//
disable_corner_aim(trig)
{
	while (true)
	{
		trig waittill("trigger");

		SetDVar("cover_corner_aim_enabled", 0);
		while (level.player IsTouching(trig))
		{
			wait .05;
		}

		SetDVar("cover_corner_aim_enabled", 1);
	}
}

//
//	ammo_crate - give stock ammo for a weapon. used mainly for sniper events so the player doesn't run out of ammo
//

ammo_crate()
{
	while (true)
	{
		//if (IsDefined(self.weaponinfo))
		//{
		//	{
		//		level.player waittill("weapon_change");
		//	}
		//}

		self SetUseable(true);
		self SetHintString(&"HINT_AMMO_CRATE");

		self waittill("trigger");
		
		wep_list = level.player GetWeaponsList(); //get all weapons
		
		illegal_weapons = [];  //make the illegal array
		
		//illegal_weapons[illegal_weapons.size] = "8CAT_Eco";
		//illegal_weapons[illegal_weapons.size] = "8CAT_Eco_s";
		
		//illegal_weapons[illegal_weapons.size] = "8cat_shanty";
		
		//illegal_weapons[illegal_weapons.size] = "8CAT_Sink";
		//illegal_weapons[illegal_weapons.size] = "8CAT_Sink_T";
		
		//illegal_weapons[illegal_weapons.size] = "hutchinsona3_white";
		//illegal_weapons[illegal_weapons.size] = "hutchinsona4_casino";
		//illegal_weapons[illegal_weapons.size] = "hutchinsona4_casino_s";
		//illegal_weapons[illegal_weapons.size] = "hutchinsona4_shanty";
		//illegal_weapons[illegal_weapons.size] = "hutchinsona4_shanty_s";
		
		//illegal_weapons[illegal_weapons.size] = "ltd22_Barge";
		//illegal_weapons[illegal_weapons.size] = "ltd22_Barge_s";
		//illegal_weapons[illegal_weapons.size] = "ltd22_opera";
		//illegal_weapons[illegal_weapons.size] = "ltd22_opera_s";
		//illegal_weapons[illegal_weapons.size] = "ltd22_opera";
		//illegal_weapons[illegal_weapons.size] = "ltd22_scb";
		//illegal_weapons[illegal_weapons.size] = "ltd22_scb_s";
		
		//illegal_weapons[illegal_weapons.size] = "ltksm_get";
		//illegal_weapons[illegal_weapons.size] = "ltksm_siena";
		//illegal_weapons[illegal_weapons.size] = "ltksm_train";
		
		//illegal_weapons[illegal_weapons.size] = "dad_air";
		///illegal_weapons[illegal_weapons.size] = "dad_eco";
		//illegal_weapons[illegal_weapons.size] = "dad_sca";
		//illegal_weapons[illegal_weapons.size] = "dad_sink";
		
		allowed_weapons = maps\_utility::array_subtract(wep_list, illegal_weapons);  //filter illegal weapons from the main list and return the allowed list/array
		
		for(i = 0; i < allowed_weapons.size; i ++)
		{
			level.player GiveMaxAmmo(allowed_weapons[i]);
		}
		
		if ( allowed_weapons.size )
		{
			level.player playsound( "ammo_crate_pickup" );
		}
		
		//if (IsDefined(self.weaponinfo))
		//{
		//	level.player GiveMaxAmmo(self.weaponinfo);
		//}
		//else
		//{
		//	level.player GiveMaxAmmo(allowed_weapons);
		//}

		self SetUseable(false);
		wait 10;
	}
}

//
//	Breadcrumbing
//

breadcrumb()
{
	level.breadcrumb = GetEnt("breadcrumb", "targetname");
	level thread breadcrumb_update();

	while (true)
	{
		if (IsDefined(level.breadcrumb))
		{
			level.player ArrowSetGoal(level.breadcrumb.origin);
		}
		else
		{
			level.player ArrowSetGoal((0, 0, 0));
		}

		level waittill("breadcrumb_update");
	}
}

breadcrumb_update()
{
	level notify("breadcrumb_reset");
	wait .05;
	level endon("breadcrumb_reset");

	while (IsDefined(level.breadcrumb))
	{
		level.breadcrumb waittill("trigger");
		
		backtrack = GetEnt(level.breadcrumb.targetname, "target");
		if (IsDefined(backtrack))
		{
			backtrack thread breadcrumb_backtrack();
		}
		
		if (IsDefined(level.breadcrumb.target))
		{
			level.breadcrumb = GetEnt(level.breadcrumb.target, "targetname");
		}
		else
		{
			level.breadcrumb = undefined;
		}

		level notify("breadcrumb_update");
	}
}

breadcrumb_backtrack()
{
	level notify("backtrack_reset");
	wait .05;
	level endon("backtrack_reset");

	self waittill("trigger");	
	level.breadcrumb = GetEnt(self.target, "targetname");

	level thread breadcrumb_update();
	level notify("breadcrumb_update");

	backtrack = GetEnt(self.targetname, "target");
	if (IsDefined(backtrack))
	{
		backtrack thread breadcrumb_backtrack();
	}
}
