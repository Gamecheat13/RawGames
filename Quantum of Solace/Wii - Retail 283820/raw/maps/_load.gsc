#include maps\_utility;
#include common_scripts\utility;

main(bScriptgened)
{
	level._effect["light_green"]	= loadfx ("misc/door_lock_green");
	level._effect["light_red"]		= loadfx ("misc/door_lock_red");

	maps\_constants::main();
	
	level.noTankSquish = true; 
	
	if(!isdefined(bScriptgened))
		bScriptgened = false;
	level.bScriptgened = bScriptgened;
	
	/# star (4 + randomint(4)); #/

	
	
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
	
	level.default_run_speed = 190;
	setSavedDvar( "g_speed", level.default_run_speed );
	setSavedDvar( "sv_saveOnStartMap", true );
	setDvar("ui_hud_showstanceicon","1");
	setDvar("ui_hud_showcompass","1");

	level.dronestruct = [];
	
	maps\_unlock_mechanisms::main();




	if ( !isdefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}
	
	flag_init( "respawn_friendlies" );

	
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
		script_gen_dump_addline("maps\\createfx\\"+level.script+"_fx::main();",level.script+"_fx");  

	level.player.maxhealth = level.player.health;
	level.player.shellshocked = false;
	level.aim_delay_off = false;
	level.player.inWater = false;
	level.last_wait_spread = -1;
	level.hero_list = [];

	
	level.player thread maps\_utility::flashMonitor();
	level.player thread maps\_utility::concMonitor();
	level.player thread maps\_utility::shock_ondeath();
	level.player thread maps\_utility::stinger_ondeath();

	
	
	
	level.player thread maps\_utility::beam_monitor();
	level.player thread maps\_utility::ledge_monitor();








	
	
	PrecacheHeadIcon( "headicon_american" ); 
	
/#
	precachemodel ("fx");

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

	maps\_playerawareness::init();
	maps\_aiPerceptionIndicator::init();
	maps\_music::init();

	
	


	
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
	
	
	maps\_wiiaimassist::init_aimassist();
	
	
	reviveeffect( false );

	
	
	
	/#
	level thread disp_engagement_dist();
	#/

	
	
	
	

	
	
	
	
	
	
	
	
	
	maps\_global_fx::main();
	
	thread devhelp(); 
	
	setSavedDvar( "ui_campaign", level.campaign ); 

	maps\_mgturret::setdifficulty();
	thread maps\_vehicle::init_vehicles();
	
	maps\_interactive_vehicles::main();	
	/#
	thread maps\_debug::mainDebug();
	#/
	thread maps\_autosave::beginningOfLevelSave();
	thread maps\_introscreen::main();
	thread maps\_quotes::main();
	
	thread maps\_shutter::main();
	thread maps\_inventory::main();
	thread maps\_endmission::main();
	thread maps\_nightvision::main();
	maps\_friendlyfire::main();

	


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

	
	thread massNodeInitFunctions();
	
	
	flag_init( "spawning_friendlies" );
	flag_init( "friendly_wave_spawn_enabled" );
	flag_clear( "spawning_friendlies" );
	
	level.friendly_spawner["rifleguy"] = getentarray ("rifle_spawner","script_noteworthy");			
	level.friendly_spawner["smgguy"] = getentarray ("smg_spawner","script_noteworthy");
	thread maps\_spawner::goalVolumes();
	thread maps\_spawner::friendlyChains();
	thread maps\_spawner::friendlychain_onDeath();


	array_thread (getentarray("friendly_spawn","targetname"), maps\_spawner::friendlySpawnWave);
	array_thread (getentarray("flood_and_secure", "targetname"), maps\_spawner::flood_and_secure);
	
	
	level.player thread common_scripts\ambientpackage::initPlayer();

	
	maps\_doors::main();
	
	
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


	
	
	array_thread( getentarray( "background_block", "targetname" ), ::background_block );

	maps\_hud::init();
	
	
	level maps\_useableobjects::main();

	
	
	maps\_data_collection::main();
	
	array_thread(GetEntArray("power_weapon_trigger", "targetname"), ::power_weapon);

	
	
	
	
	
	
	maps\_achievements::main();

	thread maps\_utility::load_friendlies();

	
	
	
	precacheitem( "sony_phone" );
	level.player thread phone_anim();
	
	
	
	
	precacheitem( "p99_ammo");
		

	level.player thread maps\_detonategrenades::watchGrenadeUsage();  
	script_gen_dump();
	
	level.player thread player_init();
	level.player thread show_player_stimulus();
	level.handleFovNotesSetup = false;
	level.player thread animscripts\shared::handleFOVNotes( );
	
	poisoneffect(false);

	
	SetSavedDVar("p99_ammo_chance", "30");				
	
	
	SetSavedDVar("cover_dash_fromCover_enabled",true);		
	SetSavedDVar("cover_dash_from1stperson_enabled",true);	
	SetSavedDVar("cover_dash_coplaner_enabled",true);		
	SetSavedDVar("cover_corner_aim_enabled",true);			

	
	SetDVar("cg_laserAiOn", 0);							
	SetDVar("cg_laserForceOn", 0);						
	setDVar("cg_laserrange", 1500);						
	setDVar("cg_laserradius", 0.02);						

	level thread breadcrumb();
}





player_init()
{
	
	self.headicon = "headicon_american";
	
	level.player thread maps\_spawner::handleQKRumble();
	level.player thread maps\_spawner::handleQKGroundhit();
	
	
	level.player allowProne( false );
		
	
	
	
	
	
	
	
	level.aimAssist = getentarray( "aim_assist", "script_noteworthy");
	
	for (i=0; i<level.aimAssist.size; i++)
	{
		level.aimAssist[i] enableAimAssist();
	}
}







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

			if (oldhealth - level.player.health < 129)
			{
				
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


		}
			
		
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
	
	level.player_died_to_grenades = false;

	while ( true )
	{
		level.player waittill ( "damage", damage, attacker, direction_vec, point, cause );

		if(	cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" )
			continue;

		if (level.gameskill >= 2)
		{
			
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
	level.depth_allow_crouch = 33;
	level.depth_allow_stand = 50;
	
	prof_begin("water_stance_controller");
	
	for (;;)
	{
		wait 0.05;
		
		if (!level.player.inWater)
		{
			
			level.player allowCrouch(true);
			level.player allowStand(true);
			thread waterThink_rampSpeed(level.default_run_speed);
		}
		
		
		self waittill ("trigger");
		level.player.inWater = true;
		while(level.player isTouching(self))
		{
			level.player.inWater = true;
			playerOrg = level.player getOrigin();
			d = (playerOrg[2] - waterHeight);
			if (d > 0)
				break;
			
			
			newSpeed = int(level.default_run_speed - abs(d * 5));
			if (newSpeed < 50)
				newSpeed = 50;
			assert(newSpeed <= 190);
			thread waterThink_rampSpeed(newSpeed);
			
			
			if (abs(d) > level.depth_allow_crouch)
				level.player allowCrouch(false);
			else
				level.player allowCrouch(true);
			
			
			
			
			
			
			
			wait 0.5;
		}
		level.player.inWater = false;
		wait 0.05;
	}
	
	prof_end("water_stance_controller");
}

waterThink_rampSpeed(newSpeed)
{
	level notify ("ramping_water_movement_speed");
	level endon ("ramping_water_movement_speed");
	
	rampTime = 0.5;
	numFrames = int(rampTime * 20);
	
	currentSpeed = getdvarint("g_speed");
	
	qSlower = false;
	if (newSpeed < currentSpeed)
		qSlower = true;
	
	speedDifference = int(abs(currentSpeed - newSpeed));
	speedStepSize = int(speedDifference / numFrames);
	
	for( i = 0 ; i < numFrames ; i++ )
	{
		currentSpeed = getdvarint("g_speed");
		if (qSlower)
			setsaveddvar("g_speed", (currentSpeed - speedStepSize));
		else
			setsaveddvar("g_speed", (currentSpeed + speedStepSize));
		wait 0.05;
	}
	setsaveddvar("g_speed", newSpeed );
}



massNodeInitFunctions()
{
	nodes = getallnodes();

	if ( getDvarInt( "scr_useTurrets" ) == 1 )
		thread maps\_mgturret::auto_mgTurretLink( nodes );
	
	
}


 

trigger_unlock( trigger )
{
	
	
	
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
	waittillframeend; 
/#
	if ( !isdefined( level.start_functions ) )
		level.start_functions = [];

	assertEx( getdvar( "jumpto" ) == "", "Use the START dvar instead of JUMPTO" );
	
	start = getdvar( "start" );

	
	
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
		
		for ( r=0; r < nums.size; r++ )
		{
			
			if ( guy.eq_table[ nums[ r ] ] )
			{
				was_in_our_trigger = true;
			}
		}
		
		if ( !was_in_our_trigger )
			continue;

		
	
		touching = getarraykeys( self.eq_touching );
		shares_trigger = false;
		for ( p=0; p < touching.size; p++ )
		{
			if ( !guy.eq_table[ touching[ p ] ] )
				continue;
				
			shares_trigger = true;
			break;
		}
		
		
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

	
	for ( r=0; r < nums.size; r++ )
	{
		if ( level.player.eq_table[ nums[ r ] ] )
		{
			self eqoff();
			break;
		}
	}
		
	
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
		
		if ( level.player.eq_table[ touching[ i ] ] )
		{
			
			return;
		}
	}

	self eqon();
}

ai_eq()
{



















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
	
	/#

	script_gen_dump_checksaved(); 
	
	if(!level.script_gen_dump_reasons.size)
	{
		flag_set("scriptgen_done");
		return; 
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
		saved = 1;  
	
	assertex(saved == 1,"map not saved (see above message?): " + filename);

	#/
	
	
	assertex(!level.bScriptgened,"SCRIPTGEN generated: follow instructions listed above this error in the console");
	if(level.bScriptgened)
		assertmsg("SCRIPTGEN updated: Rebuild fast file and run map again");
		
	flag_set("scriptgen_done");
	
}
script_gen_dumpprintln(file,string)
{
	
	if(file == -1 || !level.bScriptgened)
		println(string);
	else
		fprintln(file,string);
}

trigger_hint( trigger )
{
	assertEx( isdefined( trigger.script_hint ), "Trigger_hint at " + trigger.origin + " has no .script_hint" );
	trigger endon( "death" );
	
	
	waittillframeend;
	assertEx( isdefined( level.trigger_hint_string[ trigger.script_hint ] ), "Trigger_hint with hint " + trigger.script_hint + " had no hint string assigned to it. Define hint strings with add_hint_string()" );
	trigger waittill( "trigger", other );
	assertEx( other == level.player, "Tried to do a trigger_hint on a non player entity" );
	
	
	
	if ( isdefined( level.trigger_hint_func[ trigger.script_hint ] ) )
	{
		if ( ![[ level.trigger_hint_func[ trigger.script_hint ] ]]() )
			return;
	}
	
	iprintlnbold( level.trigger_hint_string[ trigger.script_hint ] );
}



Callback_LevelNotifyDirect(notify_name)
{
	level notify(notify_name);
}


power_weapon()
{
	lid = GetEnt(self.target, "targetname");

	self UseTriggerRequireLookAt(true);
	self waittill("trigger");

	
	lid delete();

	self delete();
}


phone_anim()
{
	unholster_on_close = false;

	
	curr_weapon = level.player getcurrentweapon();
	level.player GiveWeapon( "sony_phone" );

	while( true )
	{
		
		
		self waittill( "phonemenu", phone_state );

		if( phone_state == 1 )
		{
			
			if ( level.player getcurrentweapon() == "sony_phone" ) {
				level.player NotifyPhoneRaised();
				
				
			}
			else
			{
				
				if ( level.player SwitchToWeapon( "sony_phone" ) ) {
					
					curr_weapon = level.player getcurrentweapon();
				} else {
					
					curr_weapon = undefined;
				}
			}
		}
		else if( phone_state == 0 )
		{
			
			

			
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





ammo_crate()
{
	while (true)
	{
		
		
		
		
		
		

		self SetUseable(true);
		self SetHintString(&"HINT_AMMO_CRATE");

		self waittill("trigger");
		
		wep_list = level.player GetWeaponsList(); 
		
		illegal_weapons = [];  
		
		
		
		
		
		
		
		illegal_weapons[illegal_weapons.size] = "hutchinsona3_white";
		illegal_weapons[illegal_weapons.size] = "hutchinsona4_casino";
		illegal_weapons[illegal_weapons.size] = "hutchinsona4_casino_s";
		illegal_weapons[illegal_weapons.size] = "hutchinsona4_shanty";
		illegal_weapons[illegal_weapons.size] = "hutchinsona4_shanty_s";
		
		illegal_weapons[illegal_weapons.size] = "ltd22_Barge";
		illegal_weapons[illegal_weapons.size] = "ltd22_Barge_s";
		illegal_weapons[illegal_weapons.size] = "ltd22_opera";
		illegal_weapons[illegal_weapons.size] = "ltd22_opera_s";
		illegal_weapons[illegal_weapons.size] = "ltd22_opera";
		illegal_weapons[illegal_weapons.size] = "ltd22_scb";
		illegal_weapons[illegal_weapons.size] = "ltd22_scb_s";
		
		illegal_weapons[illegal_weapons.size] = "ltksm_get";
		illegal_weapons[illegal_weapons.size] = "ltksm_siena";
		illegal_weapons[illegal_weapons.size] = "ltksm_train";
		
		illegal_weapons[illegal_weapons.size] = "dad_air";
		illegal_weapons[illegal_weapons.size] = "dad_eco";
		illegal_weapons[illegal_weapons.size] = "dad_sca";
		illegal_weapons[illegal_weapons.size] = "dad_sink";
		
		allowed_weapons = maps\_utility::array_subtract(wep_list, illegal_weapons);  
		
		for(i = 0; i < allowed_weapons.size; i ++)
		{
			level.player GiveMaxAmmo(allowed_weapons[i]);
		}
		
		
		
		
		
		
		
		
		

		self SetUseable(false);
		wait 10;
	}
}





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
